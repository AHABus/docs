# AHABus Payload Bus Protocol

    author:     Amy Parent <amy@amyparrent.com>
    version:    0.1
    date:       2017-02-15

This document describes the protocol used by the AHABus platform (or any other
compliant bus) to communicate and fetch data from payload instruments hosted on
an FCORE data bus.

## Protocol Overview

The AHABus protocol (AHAP) is designed to provide an asymmetric communication
platform between a High-Altitude Balloon mission's instruments and the main
flight computer (FCORE).

AHAP relies on the two-wire (Phillips I2C) protocol to establish a connection
between the main computer and each payload. Communications are controlled
solely by the main computer: a payload can only send or receive data when it
has been addressed.

Because the AHABus platform relies on low-bandwidth data, data rate caps can be
enforced on each payload. These caps are defined on a per-mission basis. If a
payload returns more data than it is allowed to the computer will stop
addressing it.

FCORE (the software component of the AHABus flight computer) will address each
payload in turn over a certain period of time. By default, each payload has the
same data rate restrictions. If priorities are given to payloads, higher
priority payloads will be allowed higher data caps than their low-priority
counterparts.

AHAP is a virtual remote memory access protocol. After opening a communication
line with a payload, the computer requests the data at certain virtual memory
addresses (defined in further sections) to obtain payload data and metadata
relating to it. There are no requirement that those addresses map to physical
addresses on each instrument's controller -- just that the instrument return
the expected pieces of data or metadata.

## Virtual Registers

Payloads that implement AHAP should provided specific information in certain
virtual registers, mapped at the following addresses:

| Address   | Name          |                                               |
|:----------|:--------------|:----------------------------------------------|
| `$00[1]`  | Tx Flag       | `0x01` when the bus controller is addressing  |
| `$01[2]`  | Data Length   | Number of bytes of available data             |
| `$10[-]`  | Data          | Start of data made available to the bus       |

## Communications format

AHABus uses the I2C protocol to denote whether an address is being read, or
written to. Communication is always initiated by the Bus Controller.

To accommodate low-budget, low-power devices which may present small I2C
transmission buffers, the AHABus protocol does not allow transmission of more
than 32 bytes at once. If a payload must send more than 32 bytes of data, the
controller will read its data sequentially, in chunks of 32 bytes starting at
address `$10`.

## Synopsis

In typical operations, a bus controller/payload interaction follows these steps:

 1. The bus controller addresses the payload's address and writes `0xff` in
    the Tx Flag register. At this point, the payload must not change the
    contents of any of its public registers.
    
 2. The bus controller requests the contents of the of Data Length register by
    writing its address on the bus, then reading two bytes. If no data is
    available (Data Length = `0x0000`), the controller goes to step 4.
    
 3. The bus controller requests the data by writing the address of the data
    area, and reads `Data Length` bytes.

 4. The bus controller writes `0x0` in the payload's Tx Flag register. The
    connection is considered close after this point.

In the event where any of the connection's communication would fail, the bus
controller skips any further steps and attempts to close the connection.

## Related Documents

 * [AHABus Packet Radio Protocol Specification][d1]

## References

 [d1]: https://github.com/AHABus/src/software/packet-radio.md
