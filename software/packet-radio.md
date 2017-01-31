# AHABus Packet Radio Protocol

    author:     Cesar Parent <cesar@cesarparent.com>
    version:    0.1
    date:       2017-01-31

This document describes the protocol used by the AHABus platform (or any other
compliant bus) to transfer telemetry data from an airborne platform (typically,
a High-Altitude Balloon payload) to a ground station over a radio link.

The protocol is designed with low-bandwidth, low-power radio links in mind, to
stay within the legal limits for airborne transmission in the UK (1): 70cm
wavelength band transmissions at a power no higher than 10 mW.

## References

 1. Ofcom (2014). IR 2030 - [UK Interface Requirements 2030 Licence Exempt
    Short Range Devices][1]. London


 [1]: https://www.ofcom.org.uk/__data/assets/pdf_file/0028/84970/ir_2030-june2014.pdf