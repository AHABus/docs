# AHABus Packet Radio Protocol

    author:     Cesar Parent <cesar@cesarparent.com>
    version:    0.1
    date:       2017-01-31

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

### AHABus Frames

    struct radio_frame {
        00: u16         start_marker
        02: u8          protocol_version
        03: u16         sequence_number
        04: b8[220]     data
        e0: b8[32]      fec_code
    }

### AHABus Packets

    struct radio_packet {
        00: u8          protocol_version
        01: u8          instrument_id
        02: u16         sequence_number
        04: u16         length
        06: u16         latitude
        08: u16         longitude
        0a: u16         altitude
        0c: b8[length]  data
    }

## Related Documents

 * [AHABus Architecture Overview][d1]
 * [AHABus Payload Bus Protocol Specification][d2]

## References

 1. Ofcom (2014). IR 2030 - [UK Interface Requirements 2030 Licence Exempt
    Short Range Devices][r1]. London
    
 4. Stallings, W. (1987). Handbook of computer- communications standards.
    Macmillan. isbn: 002948071X.
    
 3. UKHAS (2010). [Reed-Solomon Encoder (255,223)][r2].


 [d1]: //todo
 [d2]: //todo

 [r1]: https://www.ofcom.org.uk/__data/assets/pdf_file/0028/84970/ir_2030-june2014.pdf
 [r2]: https://ukhas.org.uk/code:rs8encode