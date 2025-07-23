library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
	entity rx_uart_sample is
--Setting Variables
	generic(
	--1/baud then (1/baud)/(time period)
	-- 1/38400 = 26uS  then 26uS/20nS ~ 1302
	-- OR
	--HZ/baud
		-- 50,000,000/38400 ~ 1302
	g_clks_per_bit : integer := 1302
);
  port (
    i_clk 			: in std_logic;
    i_data_serial 	: in  std_logic;
    i_rst			: in std_logic;
    o_rx_dv     	: out std_logic;
    o_rx_Byte   	: out std_logic_vector(7 downto 0)
);
end rx_uart_sample;

architecture RTL of rx_uart_sample is

--init state types
	type rx_main is (rx_IDLE, rx_START, rx_DATA, rx_STOP);
	signal r_state_main : rx_main := rx_IDLE;											--start idle state
																					-- *note* r_ means register
																					
	signal r_clk_counter : integer range 0 to g_clks_per_bit - 1 := 0;				-- set baud rate for bits
																					-- *note* we minus 1 from total baud rate to account for 0 int start
																					-- *note* := 0 tels clk counter to start at 0
																					
	signal r_bit_idx : integer range 0 to 7 := 0;									-- index bits for correct transmit order and start at 0
	
	signal r_tx_data 	: std_logic_vector(7 downto 0) := (others => '0');					--transmit signal
																					--*note* := "00000000" sets all 8 bits to 0 for clean start
	signal r_rx_dv		: std_logic := '0';
		
begin

		
	--process sensitive to fpga clock
	p_uart_rx : process (i_clk)
	begin
	
		if rising_edge (i_clk) then
		
					if i_rst = '1' then
					--r_state_main <= rx_IDLE;
					r_clk_counter <= 0;
					r_bit_idx <= 0;
					r_tx_data <= "00000000";
					r_rx_dv <= '0';
					--o_rx_dv <= '0';
					else

					case r_state_main is
								-- set reset

				when rx_IDLE =>
					
					o_rx_dv			<= '0';
					r_clk_counter	<= 0;
					r_bit_idx		<= 0;
					r_tx_data		<= (others => '0');
					
					if i_data_serial = '0' then
						r_state_main 	<= rx_START;
					else
						r_state_main 	<= rx_IDLE;
					end if;
				
				when rx_START =>
					if 	r_clk_counter < g_clks_per_bit /2 then					-- we do -1 to account for 0 start
						r_clk_counter <= r_clk_counter + 1;
					else
						r_clk_counter <= 0;								-- reset clock counter for future operations
						r_state_main <= rx_DATA;							-- operation complete store data and move to next state
					end if;
				
				when rx_DATA =>
					if 	r_clk_counter < g_clks_per_bit - 1 then				-- we do -1 to account for 0 start
						r_clk_counter <= r_clk_counter + 1;
					else
						r_clk_counter <= 0;
						r_tx_data(r_bit_idx) <= i_data_serial;
						if 	r_bit_idx < 7 then
							r_bit_idx	<= r_bit_idx + 1;
						else
							r_bit_idx	<= 0;
							r_state_main	<= rx_STOP;
						end if;
					end if;
				
				when rx_STOP =>
						--o_rx_dv    <= '1';
					-- Wait g_CLKS_PER_BIT-1 clock cycles for Stop bit to finish
					if 	r_clk_counter < g_CLKS_PER_BIT-1 then
						r_clk_counter <= r_clk_counter + 1;
						--r_rx_dv    <= '1';
					else
						o_rx_dv    <= '1';
						--o_rx_dv 	<= r_rx_dv;
						--o_rx_Byte   <= r_tx_data(0) & r_tx_data(1) & r_tx_data(2) & r_tx_data(3) & r_tx_data(4) & r_tx_data(5) & r_tx_data(6) & r_tx_data(7);
						r_clk_counter <= 0;
						r_state_main   <= rx_IDLE;
					end if;
			end case;
			end if;
		end if;
	end process p_uart_rx;
	--o_rx_dv 	<= r_rx_dv;
	o_rx_Byte   <= r_tx_data;
end RTL;