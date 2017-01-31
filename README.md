# AHABus Documentation

This repository contains the documentation for the AHABus High-Altitude Balloon
platform, its core flight software ([FCORE][1]) and the protocols it uses to
transmit telemetry over radio and gather data from payload over the main payload
bus.

The documentation for the software-level communication protocols is located in
[`src/software/`][2], and the documentation for the hardware bus interface will
eventually be added to [`src/hardware/`][3].

PDF versions of the different documents can be generated by running `make doc`.
This require [pandoc][3] to be installed for markdown parsing and pdf
generation.

 [1]: https://github.com/ahabus/fcore
 [2]: src/software/
 [3]: src/hardware/
 [4]: http://pandoc.org
