# UART Tang Primer 20k

The **`uart_test`** module is a simple UART loopback system that receives serial data via **`uart_rx`**, stores it in a buffer, and transmits it back through **`uart_tx`** after detecting a carriage return (`0x0D`).

[img](https://raw.githubusercontent.com/proxytype/Tang20k-Uart/refs/heads/main/tang-primer-20k.png)

The **Tang Primer 20K** is a compact and powerful FPGA development board based on the **Gowin GW2AR-18C FPGA**, offering **20K LUTs** (Look-Up Tables) for flexible digital logic design. Designed for both beginners and experienced FPGA developers, it supports the **Gowin IDE** toolchain, making it ideal for hardware prototyping, signal processing, and embedded system applications. The board features a **high-speed USB Type-C interface**, onboard **SPI Flash**, and **SDRAM**, enabling efficient data storage and high-speed computation. Additionally, it includes multiple **I/O headers**, allowing easy interfacing with external peripherals such as sensors, displays, and communication modules. With its open-source support and compatibility with **RISC-V soft-core processors**, the Tang Primer 20K is a versatile platform for FPGA-based innovation and custom hardware development.

## **Module Ports**
- `clk` (input) – System clock.
- `rst_n` (input) – Active-low reset.
- `uart_rx` (input) – UART receive pin.
- `uart_tx` (output) – UART transmit pin.

## **Parameters**
- `CLK_FRE` – System clock frequency (27 MHz by default).
- `UART_FRE` – UART baud rate (115200 bps by default).

## **Registers and Signals**
- `user_buffer[0:255]` – Stores received characters.
- `buffer_index` – Tracks the number of stored bytes.
- `tx_data` – Byte to be transmitted.
- `tx_data_valid` – Signals when data is valid for transmission.
- `tx_data_ready` – Indicates when the transmitter is ready.
- `rx_data` – Received byte from UART.
- `rx_data_valid` – Indicates valid received data.
- `rx_data_ready` – Always `1`, indicating the receiver is always ready.
- `state` – FSM state register (`IDLE`, `WAIT`, `SEND`).
- `tx_cnt` – Tracks the number of transmitted bytes.

## **Finite State Machine (FSM)**
1. **`IDLE`** – Transitions to `WAIT` state.
2. **`WAIT`** – Listens for incoming UART data:
   - If valid data is received, it is stored in `user_buffer[]`.
   - If a carriage return (`0x0D`) is detected, switches to `SEND` state.
3. **`SEND`** – Transmits the buffered data byte by byte:
   - When all data is sent, resets `buffer_index` and returns to `WAIT`.

## **UART Receiver and Transmitter**
The module instantiates:
- `uart_rx` – Handles receiving of UART data.
- `uart_tx` – Handles transmitting UART data.

Both use **`CLK_FRE`** and **`UART_FRE`** to configure baud rate.

## **Operation**
1. The module waits for incoming UART data.
2. It stores received bytes in a buffer.
3. When `0x0D` (carriage return) is detected, it starts sending back stored data.
4. Once transmission is complete, it returns to the waiting state.

This module is useful for UART debugging, echo testing, and basic communication between an FPGA and a UART-based device.


## **Gowin IDE – FPGA Development Environment**  

To compile and implement the `uart_test` module, you need to use **Gowin IDE**, an FPGA development environment specifically designed for **Gowin FPGAs**. It provides synthesis, place & route, and programming tools necessary to deploy Verilog and VHDL designs onto Gowin FPGA hardware.

### **Features of Gowin IDE**  
- **HDL Support** – Supports **Verilog** and **VHDL** design entry.  
- **Integrated Simulation** – Allows functional verification of designs.  
- **Synthesis & Implementation** – Converts HDL into bitstreams for Gowin FPGAs.  
- **IP Cores** – Includes ready-to-use UART, PLL, and memory controllers.  
- **Device Programmer** – Used for flashing compiled bitstreams onto FPGA devices.

---

### **Setting Up Gowin IDE**  
1. **Download & Install**  
   - Obtain **Gowin IDE** from the official [Gowin Semiconductor website](https://www.gowinsemi.com/).  
   - Install the IDE and required device libraries for your FPGA model.  

2. **Create a New Project**  
   - Open **Gowin IDE**.  
   - Click **File → New Project**.  
   - Select the target FPGA family and device.  
   - Choose **Verilog** as the design language.  

3. **Add the `uart_test` Verilog Module**  
   - Import the `uart_test.v` file into the **Project Manager**.  
   - Ensure the UART RX and TX modules (`uart_rx.v`, `uart_tx.v`) are also included.  

4. **Assign Pins**  
   - Open **Constraint Editor** and map FPGA pins to `uart_rx`, `uart_tx`, `clk`, and `rst_n`.  

5. **Compile & Synthesize**  
   - Run **Synthesis** to convert Verilog code into a netlist.  
   - Perform **Place & Route** to optimize the design for the FPGA.  
   - Generate the final **bitstream** for programming.  

6. **Programming the FPGA**  
   - Connect your **Gowin FPGA board** via **USB JTAG**.  
   - Use **Gowin Programmer** to load the bitstream.  
   - Observe UART communication using a serial terminal (e.g., PuTTY, Tera Term).  

---

### **Additional Tools**  
- **Gowin EDA Toolchain** – Supports third-party synthesis tools like **Synplify**.  
- **Waveform Debugging** – Use the built-in **Gowin Logic Analyzer** to debug signals.  

### **Supported FPGAs**  
The module is compatible with various **Gowin FPGA families**, such as:  
- GW1N (LittleBee)  
- GW1NR (LittleBee Risc-V)  
- GW2A (Arora)  


# WinSerial

## Overview
The **WinSerial** is a simple C# Console application for serial communication over a specified COM port. It enables sending and receiving data through a serial interface, making it useful for interacting with embedded systems, microcontrollers, or other serial-based devices.

## Features
- Connects to a specified serial port with configurable settings
- Reads incoming serial data in a separate thread
- Sends user-input messages to the connected device
- Handles exceptions for stability
- Supports basic data formatting

## Prerequisites
- .NET Framework or .NET Core installed
- A device connected via a serial interface (e.g., Arduino, FPGA, or another computer)
- Knowledge of the correct **COM port** and **baud rate** for the device

## Installation
1. Clone or download the repository.
2. Open the project in **Visual Studio** or any compatible C# IDE.
3. Ensure the correct **COM port** is set in the `portName` variable inside the `Main` method.

## Usage

### 1. Configure the Serial Port
Modify the following variables inside the `Main` method to match your device’s serial settings:
```csharp
string portName = "COM9"; // Set the correct COM port
int baudRate = 115200;  // Set the correct baud rate
int dataBits = 8;
Parity parity = Parity.None;
StopBits stopBits = StopBits.One;
```

### 2. Run the Application
Execute the program. If successful, it will open the serial port and start listening for incoming data.

### 3. Sending Data
- The program will prompt you to enter a message.
- Type a message and press **Enter** to send it.
- The message is sent with a **newline and carriage return (\n\r)** to indicate the end of transmission.

### 4. Receiving Data
- Incoming data is printed to the console.
- The program continuously listens for new data.
- Any **null or carriage return characters** are removed for cleaner output.

## Error Handling
- The program handles serial port access errors, timeouts, and disconnection issues.
- If the COM port is unavailable, an error message is displayed.
- Read timeouts are ignored to prevent unnecessary exceptions.

