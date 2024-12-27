vlib work
vlog instantiation_module.v RAM.v SPI.v spi_slave_tb.v
vsim -voptargs=+acc work.spi_slave_tb
add wave *
run -all
#quit -sim