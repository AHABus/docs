# AHABus Packet Radio Protocol

    author:     Amy Parent <amy@amyparrent.com>
    version:    3
    date:       2017-02-15

This document describes the protocol used by the AHABus platform (or any other
compliant bus) to transfer telemetry data from an airborne platform (typically,
a High-Altitude Balloon payload) to a ground station over a radio link.

## Protocol Overview

The protocol is designed with low-bandwidth, low-power radio links in mind, to
stay within the legal limits for airborne transmission in the UK [1]: 70cm
wavelength band transmissions at a power no higher than 10 mW.

The model used by low-cost High Altitude Balloon missions (one way, two-point
non multiplexed RTTY link), there is no real network to speak of. For this
reason, the OSI layers model [2] is hardly applicable to the AHABus protocol.

None the less, the protocol follows a layer model, described here in increasing
levels of abstraction: the application-level packets are encapsulated in frames,
which provide order and error correction. Frames themselves are sent over
the RTTY radio link, which uses Frequency-Shift Keying to convert a digital
stream of bits to an analogue radio signal.

## Requirements

The AHABus Packet Protocol's main goal is to support telemetry transmission
from an AHABus-based High Altitude Balloon mission to a ground station. The
following requirements all come from this main goal:

 * provide a system to transmit multiple payload's data on a same link
 * provide stable transmissions on a low-power link
 * provide some level of transmission error correction
 * provide means to track the payload's GNSS location over time
 
## Layers Specification

The three main layers of the AHABus Radio Protocol are meant to be as
independent from each other as possible. The rationale behind that is that one
layer could be swapped for a different implementation without impacting the
design of the other layers.

On every layer above the data-link layer, any multi-octet field must be
transmitted in network byte order (little-endian). Integers must be transmitted
in two's-complement binary format, floating point values in IEEE754 single
precision. Values sent as fixed-point have their fractional and integer bit
width specified when required.

### Radio Link

The lowest-level layer of the AHABus Radio Protocol is the radio link. Its only
role is to provide a raw binary stream between the payload and the ground
station, without consideration for the transmitted data's structure.

Because of the restrictions imposed on airborne radio transmission equipment in
the United Kingdom [1], the chosen physical link is:
 
    frequency:      434MHz band
    power:          < 10mW
    Modulation:     FSK/AFSK
     
    Encoding:       RTTY (8bit-bytes, No parity bit, 2 stop bits)
    Rate:           50-300bauds

These are guidelines only, and can be swapped for other types of modulation
and encoding where it is legal to do so, and as long as the chosen encoding
can provide a binary stream.

### FEC Layer

The FEC layer provides transfer reliability to the [over] layers. Any data
generated by upper layers is split into frames at the FEC layer. Each frame is
composed of a frame sync marker, a header, the binary data and a Forward Error
Correction code.

The header contains the frame's AHABus protocol version and a sequence number
which allows a partial frame stream to be re-constructed on the ground in the
case a frame is lost in transmission.

The last 32 octets of each frame make up the frame's Reed-Solomon (255,223) [3]
FEC code, used to correct data corruptions on reception of each frame. The
code is computed using the complete frame, sync marker and header included.

A frame should start to be decoded when the incoming byte in the streams goes
from `0xAA` to `0x5A`. There can be any number of sync bytes (`0xAA`). The
frame marker (`0x5A`) is part of the frame's 256 bytes, but is not counted when
computing the Reed-Solomon error-correction code for the frame.

**AHABus Frame Structure**

    struct radio_frame {
        00: u8          start_marker = 0x5A
        01: u8          protocol_version
        02: u16         sequence_number
        04: b8[220]     data
        e0: b8[32]      fec_code
    }

### Application Layer

The application layer provides the support for the high-level AHABus operations:
packets encapsulate both each instruments' data samples, but also ancillary
data that is required to support a High-Altitude Balloon mission. Packets also
allow multiple instruments' data to be sent over a shared connection.

Each packet is composed of a primary and second header, and a body of variable
length.

 * The primary header contains data required for the packet decoder to parse
   and dispatch the packet's data correctly:
   
    * AHABus protocol version,
    * Payload ID of the instruments who's data is carried in the packet,
    * Packet's length in bytes, including the header.

 * The secondary header contains ancillary data required for the support of the
   mission:
    * AHABus platform's latitude in decimal format at the time the packet was
      encoded, in (8.24) fixed point format,
    * AHABus platform's longitude in decimal format at the time the packet was
      encoded, in (8.24) fixed point format,
    * AHABus platform's altitude in metres at the time the packet was encoded,
      in 16-bit unsigned integer format.

Packets transmitted over AHABus frame streams should be aligned on frame
boundaries. Each packet should start on a new frame, and the end of a packet
should be the last data in a frame.

**AHABus Packet Structure**

    struct radio_packet {
        00: u8          protocol_version
        01: u8          instrument_id
        04: u16         length
        06: f32         latitude
        08: f32         longitude
        0a: u16         altitude
        0c: b8[length]  data
    }

## Related Documents

 * [AHABus Payload Bus Protocol Specification][d1]

## References

 1. Ofcom (2014). IR 2030 - [UK Interface Requirements 2030 Licence Exempt
    Short Range Devices][r1]. London
    
 4. Stallings, W. (1987). Handbook of computer- communications standards.
    Macmillan. isbn: 002948071X.
    
 3. UKHAS (2010). [Reed-Solomon Encoder (255,223)][r2].

 [d1]: https://github.com/AHABus/src/software/payload-bus.md

 [r1]: https://www.ofcom.org.uk/__data/assets/pdf_file/0028/84970/ir_2030-june2014.pdf
 [r2]: http://ukhas.org.uk/code:rs8encode