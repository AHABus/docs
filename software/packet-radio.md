# AHABus Packet Radio Protocol

    author:     Cesar Parent <cesar@cesarparent.com>
    version:    0.1
    date:       2017-01-31

This document describes the protocol used by the AHABus platform (or any other
compliant bus) to transfer telemetry data from an airborne platform (typically,
a High-Altitude Balloon payload) to a ground station over a radio link.

## Protocol Overview

The protocol is designed with low-bandwidth, low-power radio links in mind, to
stay within the legal limits for airborne transmission in the UK (1): 70cm
wavelength band transmissions at a power no higher than 10 mW.

The model used by low-cost High Altitude Balloon missions (one way, two-point
non multiplexed RTTY link), there is no real network to speak of. For this
reason, the OSI layers model (2) is hardly applicable to the AHABus protocol.

None the less, the protocol follows a layer model, described here in increasing
levels of abstraction: the application-level packets are encapsulated in frames,
which provide order and error correction. Frames themselves are sent over
the RTTY radio link, which uses Frequency-Shift Keying to convert a digital
stream of bits to an analogue radio signal.

## Layers Specification


### Radio Link Layer


### Frame Layer


### Application Layer.


## References

 1. Ofcom (2014). IR 2030 - [UK Interface Requirements 2030 Licence Exempt
    Short Range Devices][1]. London
    
 4. Stallings, W. (1987). Handbook of computer- communications standards. Macmillan. isbn: 002948071X.
    
 3. UKHAS (2010). [Reed-Solomon Encoder (255,223)][1].


 [1]: https://www.ofcom.org.uk/__data/assets/pdf_file/0028/84970/ir_2030-june2014.pdf
 [2]: https://ukhas.org.uk/code:rs8encode