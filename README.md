# UART Tang 20k Module

The **`uart_test`** module is a simple UART loopback system that receives serial data via **`uart_rx`**, stores it in a buffer, and transmits it back through **`uart_tx`** after detecting a carriage return (`0x0D`).

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
