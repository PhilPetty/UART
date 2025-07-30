-- tb_uart_sample_01.vhd
--
-- Test bench for 4byte UART
--
-- Phillip Petty
-- 
-- 7/30/2025


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity tb_uart_sample is
end tb_uart_sample;

architecture behave of tb_uart_sample is
	
	-- Tb is set to a 50MHZ clock so 1/50,000,000 = 20ns
	constant c_clk_period : time := 20 ns;
	
	--1/baud then (1/baud)/(time period)
	-- 1/38400 = 26uS  then 26uS/20nS ~ 1302
	-- OR
	--HZ/baud
		-- 50,000,000/38400 ~ 1302
	constant c_clks_per_bit : integer := 1302;
	
	-- 1 bit transmited every 1/38400 = 26042 ns
	--constant c_bit_period : time := 26042 ns;
	constant clock_counter	: integer := 1000;
	
	signal r_Clock     	: std_logic                    := '0';
	signal r_TX_DV     	: std_logic                    := '0';
	signal r_TX_Byte   	: std_logic_vector(7 downto 0) := "00000000";
	signal w_TX_Serial 	: std_logic;
	signal w_TX_Active 	: std_logic;
	signal w_RX_DV     	: std_logic;
	signal w_RX_Byte   	: std_logic_vector(7 downto 0) := "00000000";  
	signal r_RX_Serial 	: std_logic := '1';
	signal w_UART_Data 	: std_logic;
	signal rst	   	   	: std_logic := '0';
	signal byte_async  	: std_logic;
	signal num_disp		: std_logic_vector(7 downto 0)	:= "00000000";
	signal disp_dv		: std_logic;
begin
	-- instantiate tx_UART
	uart_tx_inst : entity work.tx_UART_sample
		generic map(
			g_clks_per_bit => c_clks_per_bit
			)
		port map(
			i_clk 			=> r_Clock,
			i_tx_dv 		=> r_TX_DV,
			i_tx_byte		=> r_TX_Byte,
			o_tx_active 	=> w_TX_Active,
			o_tx_data 		=> w_TX_Serial,
			i_rst			=> rst
			);
			
	-- instantiate UART reciever
	--uart_rx_inst : entity work.rx_uart_sample
	--	generic map(
	--		g_clks_per_bit => c_clks_per_bit
	--		)
	--	port map (
    --	 		i_Clk       	=> r_Clock,
    --			i_data_serial 	=> w_UART_Data,
    --			o_rx_dv     	=> w_RX_DV,
    --			o_rx_byte 		=> w_RX_Byte,
	--			i_rst			=> rst
	--		);
	
	uart_disp_inst	: entity work.Uart_disp
		generic map(
			g_clk_counter	=> clock_counter
			)
	
	port map(
			i_clk				=> r_Clock,
			rst					=> rst,
			rx_uart_async		=> w_UART_Data, --byte_async,
			num_disp			=> num_disp
			--o_rx_dv				=> w_RX_Byte
			);
	
		
  -- Keeps the UART Receive input high (default) when
  -- UART transmitter is not active
  w_UART_Data <= w_TX_Serial when w_TX_Active = '1' else '1';
 
  r_Clock <= not r_Clock after c_CLK_PERIOD/2;	
  rst <= '1', '0' after 2 us;
  process is
  begin
  wait until rst = '0';
	--Tell the UART to send a command. (USE TX)
	wait until rising_edge(r_Clock);				-- wait to clock signals before simulations
    wait until rising_edge(r_Clock);
    r_TX_DV   <= '1';								-- assert Data valid signal to indicate byte is ready to be loaded
    r_TX_Byte <= X"FF";								-- binary value = (00110111)
    wait until rising_edge(r_Clock);				-- wait another clock cycle to give time for transmitter to latch byte
    r_TX_DV   <= '0';								-- reset data valid
	wait for 100000000 ns;
		--Tell the UART to send a command. (USE TX)
	wait until rising_edge(r_Clock);				-- wait to clock signals before simulations
    wait until rising_edge(r_Clock);
    r_TX_DV   <= '1';								-- assert Data valid signal to indicate byte is ready to be loaded
    r_TX_Byte <= X"37";								-- binary value = (00110111)
    wait until rising_edge(r_Clock);				-- wait another clock cycle to give time for transmitter to latch byte
    r_TX_DV   <= '0';								-- reset data valid
	wait for 100000000 ns;
		--Tell the UART to send a command. (USE TX)
	wait until rising_edge(r_Clock);				-- wait to clock signals before simulations
    wait until rising_edge(r_Clock);
    r_TX_DV   <= '1';								-- assert Data valid signal to indicate byte is ready to be loaded
    r_TX_Byte <= X"FA";								-- binary value = (00110111)
    wait until rising_edge(r_Clock);				-- wait another clock cycle to give time for transmitter to latch byte
    r_TX_DV   <= '0';								-- reset data valid
	wait for 100000000 ns;
		--Tell the UART to send a command. (USE TX)
	wait until rising_edge(r_Clock);				-- wait to clock signals before simulations
    wait until rising_edge(r_Clock);
    r_TX_DV   <= '1';								-- assert Data valid signal to indicate byte is ready to be loaded
    r_TX_Byte <= X"AA";								-- binary value = (00110111)
    wait until rising_edge(r_Clock);				-- wait another clock cycle to give time for transmitter to latch byte
    r_TX_DV   <= '0';								-- reset data valid
	
    -- Check that corrrect byte was received
    wait until rising_edge(w_RX_DV);
	wait for 5 ms;
	assert false report "SIM TIMEOUT - No RX response" severity failure;
	
	    -- Check that the correct command was received
    if w_RX_Byte = X"37" then
      report "Test Passed - Correct Byte Received" severity note;
    else
      report "Test Failed - Incorrect Byte Received" severity note;
    end if;
 
    assert false report "Tests Complete" severity failure;
     
  end process;
   
end Behave;