module ram(din, clk, rst_n, rx_valid, dout, tx_valid);

parameter mem_depth=256, addr_size=8, mem_width=8;

input [9:0] din ;
input clk, rst_n, rx_valid;
output reg [addr_size-1:0] dout ;
output reg tx_valid;

reg [addr_size-1:0] addr_wr ;
reg [addr_size-1:0] addr_rd ;

reg [mem_width-1:0] mem [mem_depth-1 : 0] ;

always @(posedge clk or negedge rst_n ) begin
    if (!rst_n ) begin
        dout <= #1 8'b0 ;
        tx_valid<=0 ;
    end
    else begin
        if (rx_valid) begin
            case (din[9:8])
                2'b00: begin
                    addr_wr<=din[7:0] ;
                    tx_valid<=0 ;
                end
                2'b01: begin
                    mem[addr_wr]<=din[7:0] ;
                    tx_valid<=0 ;
                end
                2'b10: begin
                    addr_rd <=din[7:0] ;
                    tx_valid<=0 ;
                end
                2'b11: begin
                    dout<=mem[addr_rd] ;
                    tx_valid<=1 ;
                end
            endcase
        end
    end
end
endmodule