module spi_slave (mosi , miso , ss_n , rx_data , rx_valid , tx_data , tx_valid , clk , rst_n) ;
parameter IDLE = 3'b000 , CHK_CMD = 3'b001 , WRITE = 3'b010, READ_ADR = 3'b011 , READ_DATA = 3'b100 ;
input mosi , ss_n , rst_n , clk , tx_valid ;
input [7:0] tx_data ;
output reg miso, rx_valid ;
output reg [9:0] rx_data ;
reg [2:0]ns ,cs ; //ns:next state , cs:current state
reg sel_sig ; // signal that select between which go first [read_address(0)] or [read_data (1)]
integer i = 9 ; // counter for writing
integer j = 7; // counter for reading
(*fsm_encoding="sequential"*) 
//state mem
always @(posedge clk or negedge rst_n) begin
  if (~(rst_n) ) begin
    cs<= IDLE ;
  end
  else if (rst_n ) begin
    cs<=ns ;
  end
end
//next state
always @(*) begin
  case (cs)
    IDLE:begin
      if (ss_n)
        ns=IDLE ;
      else if (~(ss_n))
        ns=CHK_CMD ;
    end

    CHK_CMD:begin
      if (ss_n==0 && mosi==0)
        ns=WRITE ;
      else if (ss_n)
        ns=IDLE ;
      else if (ss_n ==0 && mosi==1 && sel_sig==0)
        ns=READ_ADR ;
      else if (ss_n ==0 && mosi==1 && sel_sig==1)
        ns=READ_DATA ;
    end

    WRITE:begin
      if (ss_n)
        ns=IDLE ;
      else if (~ss_n && rx_data[9]==1'b0) //checked
        ns=WRITE ;
    end

    READ_ADR:begin
      if (ss_n==1)
        ns=IDLE ;
      else if (ss_n ==0 && rx_data[9:8]==2'b10) //checked
        ns=READ_ADR ;
    end

    READ_DATA:begin
      if (ss_n==1)
        ns=IDLE ;
      else if (~ss_n && rx_data [9:8] == 2'b11) //checked
        ns=READ_DATA ;
    end

    default: ns=IDLE ;
  endcase
end
//outputs
always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    rx_data<=0 ;
    rx_valid<=0 ;
    miso<=0 ;
    sel_sig<=1'b0 ;
  end
  else begin
    case (cs)
      WRITE:begin
        if (i>0) begin
          rx_data[i]<=mosi ;
          i<=i-1 ;
        end
        if (i==0)begin
          rx_valid<=1 ;
          i<=10 ;
        end
        else if (i>0)
          rx_valid<=0 ;
      end

      READ_ADR:begin
        if (i>0) begin
          rx_data[i]<=mosi ;
          i<=i-1 ;
        end
        if (i==0)begin
          rx_valid<=1 ;
          i<=10 ;
        end
        else if (i!=0)begin
          rx_valid<=0 ; 
          sel_sig <=1 ;
      end
      end
      
      READ_DATA:begin
  if (i>=0) begin
    rx_data[i]<=mosi ;
    i<=i-1 ;
  end
  if (i==8)
    rx_valid <=1 ;
  if (i==0) begin
    rx_valid <=0 ;
    i<=10 ;
  end
  if (tx_valid==1) begin
    if (j>=0) begin
      miso<=tx_data[j] ;
      j<=j-1 ;
    end
    if(j==0) 
      j<=7;
    end  
    sel_sig<=0;
end

default: rx_data<=0;
endcase

end
end 
endmodule 