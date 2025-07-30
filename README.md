# UART
UART
-----
this design pulls 8 bits of serial data
and sends it through FPGA via UART to a segment display
on xilinx basys 3 board.
------
comp.do and wave.do are for Modlesim Consol quick simulation and compile starting


This project demonstrates a simple UART (Universal Asynchronous Receiver/Transmitter) system implemented in VHDL on an FPGA. The UART receives 4 bytes of serial data, each 8 bits wide, and sends them to a 7-segment display for visualization.



The goal was to understand how to:

Receive serial data through UART

Buffer and store 4 bytes

Convert the data for 7-segment display output

Maintain signal timing and state transitions



It’s a clean beginner-friendly example of how UART communication and digital display logic work together on an FPGA. I think this could be a fun challenge for anyone learning HDL—try rewriting it in VHDL from scratch, or go one step further and reverse-engineer it in Verilog to compare styles and methodologies.



Whether you’re just starting out or brushing up on digital design, this kind of hands-on project can really help solidify your understanding.
