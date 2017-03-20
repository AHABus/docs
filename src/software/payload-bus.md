# AHABus Payload Bus Protocol

    author:     Cesar Parent <cesar@cesarparent.com>
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

AHABus supports two types of communications. Communication is always initiated
by the bus controller. The first operation of a transmission is always a write
from the controller to the payload.

 * Read Com: The controller writes one byte indicating which address is being
   read, and listens for one or more bytes. The number of bytes expected to be
   sent by the payload depends on the requested address. If it is one of the
   virtual registers, one or two byte is expected. In the case of the Data
   memory area, exactly `Data Length` bytes will be accepted by the controller.
 
 * Write Com: The controller writes one byte indicating which address is being
   written, followed by one byte to be written to that address in the payload.

## Synopsis

In typical operations, a bus controller/payload interaction follows these steps:

 1. The bus controller addresses the payload's address and writes `0x01` in
    the Tx Flag register. At this point, the payload should not change the
    contents of any of the public registers.
    
 2. The bus controller requests the contents of the of Data Length register by
    writing its address on the bus, then reading two bytes. If no data is
    available (Data Length = `0x0000`), the controller goes to step 4.
    
 3. The bus controller requests the data by writing the address of the data
    area, and reads `Data Length` bytes.

 4. The bus controller writes `0x0` in the payload's Tx
