module uart_test(
    input                        clk,
    input                        rst_n,
    input                        uart_rx,
    output                       uart_tx
);

parameter                        CLK_FRE  = 27;   // MHz
parameter                        UART_FRE = 115200; // Baud Rate

localparam                       IDLE =  0;
localparam                       WAIT =  1;
localparam                       SEND =  2;

reg[7:0]                         user_buffer[0:255];  // Buffer for received characters
reg[7:0]                         buffer_index;        // Buffer index
reg[7:0]                         tx_data;
reg                              tx_data_valid;
wire                             tx_data_ready;
wire[7:0]                        rx_data;
wire                             rx_data_valid;
wire                             rx_data_ready;
reg[3:0]                         state;
reg[7:0]                         tx_cnt;

assign rx_data_ready = 1'b1;  // Always ready to receive data

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        tx_data <= 8'd0;
        state <= IDLE;
        tx_cnt <= 8'd0;
        tx_data_valid <= 1'b0;
        buffer_index <= 8'd0;
    end
    else
    case(state)
        IDLE:
            state <= WAIT;
        WAIT:
        begin
        if (rx_data_valid && rx_data_ready) // UART Receiver is Ready!
        begin
                tx_data_valid <= 1'b0;

                if (buffer_index < 8'd255)  // Store received data
                begin
                    user_buffer[buffer_index] <= rx_data;
                    buffer_index <= buffer_index + 8'd1;
                end
                
                if (rx_data == 8'h0D)  // Carriage Return 
                begin
                    tx_data_valid <= 1'b1;
                    tx_cnt <= 8'd0;
                    state <= SEND;
                end
                
        end
         else if (tx_data_valid && tx_data_ready)
            begin
                tx_data_valid <= 1'b0;
            end
        end
        SEND:
        begin
            if(tx_cnt < buffer_index)
            begin
             if (tx_data_ready) // UART Transmitter is Ready!
             begin
                tx_data_valid <= 1'b1;
                tx_data <= user_buffer[tx_cnt];
                tx_cnt <= tx_cnt + 8'd1;
             end
            end
            else
            begin        
                buffer_index <= 8'd0;
                state <= WAIT;
                tx_cnt <= 8'd0;
            end
        end

        default:
            state <= IDLE;
    endcase
end

// UART Receiver
uart_rx #(
    .CLK_FRE(CLK_FRE),
    .BAUD_RATE(UART_FRE)
) uart_rx_inst (
    .clk(clk),
    .rst_n(rst_n),
    .rx_data(rx_data),
    .rx_data_valid(rx_data_valid),
    .rx_data_ready(rx_data_ready),
    .rx_pin(uart_rx)
);

// UART Transmitter
uart_tx #(
    .CLK_FRE(CLK_FRE),
    .BAUD_RATE(UART_FRE)
) uart_tx_inst (
    .clk(clk),
    .rst_n(rst_n),
    .tx_data(tx_data),
    .tx_data_valid(tx_data_valid),
    .tx_data_ready(tx_data_ready),
    .tx_pin(uart_tx)
);

endmodule
