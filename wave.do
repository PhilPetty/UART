onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group TB /tb_uart_sample/r_Clock
add wave -noupdate -group TB /tb_uart_sample/r_TX_DV
add wave -noupdate -group TB -expand /tb_uart_sample/r_TX_Byte
add wave -noupdate -group TB /tb_uart_sample/w_TX_Serial
add wave -noupdate -group TB /tb_uart_sample/w_TX_Active
add wave -noupdate -group TB /tb_uart_sample/w_RX_DV
add wave -noupdate -group TB -expand /tb_uart_sample/w_RX_Byte
add wave -noupdate -group TB /tb_uart_sample/r_RX_Serial
add wave -noupdate -group TB /tb_uart_sample/w_UART_Data
add wave -noupdate -group TB /tb_uart_sample/rst
add wave -noupdate -group TB /tb_uart_sample/byte_async
add wave -noupdate -group TB -expand /tb_uart_sample/num_disp
add wave -noupdate -group TB /tb_uart_sample/disp_dv
add wave -noupdate -group TX /tb_uart_sample/uart_tx_inst/i_rst
add wave -noupdate -group TX /tb_uart_sample/uart_tx_inst/i_clk
add wave -noupdate -group TX -expand /tb_uart_sample/uart_tx_inst/i_tx_byte
add wave -noupdate -group TX /tb_uart_sample/uart_tx_inst/i_tx_dv
add wave -noupdate -group TX /tb_uart_sample/uart_tx_inst/o_tx_active
add wave -noupdate -group TX /tb_uart_sample/uart_tx_inst/o_data_serial
add wave -noupdate -group TX /tb_uart_sample/uart_tx_inst/o_stop
add wave -noupdate -group TX /tb_uart_sample/uart_tx_inst/o_tx_data
add wave -noupdate -group TX /tb_uart_sample/uart_tx_inst/r_state_main
add wave -noupdate -group TX /tb_uart_sample/uart_tx_inst/r_clk_counter
add wave -noupdate -group TX /tb_uart_sample/uart_tx_inst/r_bit_idx
add wave -noupdate -group TX /tb_uart_sample/uart_tx_inst/r_tx_data
add wave -noupdate -expand -group {UART DISP} /tb_uart_sample/uart_disp_inst/i_clk
add wave -noupdate -expand -group {UART DISP} /tb_uart_sample/uart_disp_inst/rst
add wave -noupdate -expand -group {UART DISP} /tb_uart_sample/uart_disp_inst/rx_uart_async
add wave -noupdate -expand -group {UART DISP} /tb_uart_sample/uart_disp_inst/AN0
add wave -noupdate -expand -group {UART DISP} /tb_uart_sample/uart_disp_inst/AN1
add wave -noupdate -expand -group {UART DISP} /tb_uart_sample/uart_disp_inst/AN2
add wave -noupdate -expand -group {UART DISP} /tb_uart_sample/uart_disp_inst/AN3
add wave -noupdate -expand -group {UART DISP} -expand /tb_uart_sample/uart_disp_inst/num_disp
add wave -noupdate -expand -group {UART DISP} /tb_uart_sample/uart_disp_inst/tx_uartOut
add wave -noupdate -expand -group {UART DISP} /tb_uart_sample/uart_disp_inst/syncRst
add wave -noupdate -expand -group {UART DISP} -expand /tb_uart_sample/uart_disp_inst/syncd_byte
add wave -noupdate -expand -group {UART DISP} /tb_uart_sample/uart_disp_inst/rx_uart_syncd
add wave -noupdate -expand -group {UART DISP} /tb_uart_sample/uart_disp_inst/rx_dv
add wave -noupdate -expand -group {UART DISP} /tb_uart_sample/uart_disp_inst/resetinvert
add wave -noupdate -expand -group RXDISP /tb_uart_sample/uart_disp_inst/rx_uart_sample_i/i_clk
add wave -noupdate -expand -group RXDISP /tb_uart_sample/uart_disp_inst/rx_uart_sample_i/i_data_serial
add wave -noupdate -expand -group RXDISP /tb_uart_sample/uart_disp_inst/rx_uart_sample_i/i_rst
add wave -noupdate -expand -group RXDISP /tb_uart_sample/uart_disp_inst/rx_uart_sample_i/o_rx_dv
add wave -noupdate -expand -group RXDISP /tb_uart_sample/uart_disp_inst/rx_uart_sample_i/o_rx_Byte
add wave -noupdate -expand -group RXDISP /tb_uart_sample/uart_disp_inst/rx_uart_sample_i/r_state_main
add wave -noupdate -expand -group RXDISP /tb_uart_sample/uart_disp_inst/rx_uart_sample_i/r_clk_counter
add wave -noupdate -expand -group RXDISP /tb_uart_sample/uart_disp_inst/rx_uart_sample_i/r_bit_idx
add wave -noupdate -expand -group RXDISP /tb_uart_sample/uart_disp_inst/rx_uart_sample_i/r_tx_data
add wave -noupdate -expand -group RXDISP /tb_uart_sample/uart_disp_inst/rx_uart_sample_i/r_rx_dv
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {373278 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {5482828 ns}
