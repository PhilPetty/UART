-- tx_uart_sample_01.vhd
--
-- Transmit 4byte UART
--
-- Phillip Petty
-- 
-- 7/30/2025



library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
--Setting Variables
entity tx_uart_sample is
	generic(
		--1/baud then (1/baud)/(time period)
		-- 1/38400 = 26uS  then 26uS/20nS ~ 1302
	-- OR
	--HZ/baud
		-- 50,000,000/38400 ~ 1302
	g_clks_per_bit : integer := 2604
	);
		port(
		--ADD As Needed

			--INPUTS
			i_rst			: in std_logic; 
			i_clk 			: in std_logic;
			i_tx_byte 		: in std_logic_vector(7 downto 0);
			i_tx_dv 		: in std_logic;
			--OUTPUTS
			o_tx_active 	: out std_logic;
			o_data_serial 	: out std_logic;
			o_stop 			: out std_logic;
			o_tx_data 		: out std_logic
		);
end tx_uart_sample;


architecture RTL of tx_uart_sample is 



--init state types
	type t_main is (IDLE, tx_START, tx_DATA, tx_STOP);
	signal r_state_main : t_main := IDLE;											--start idle state
																					-- *note* r_ means register
																					
	signal r_clk_counter : integer range 0 to g_clks_per_bit - 1 := 0;				-- set baud rate for bits
																					-- *note* we minus 1 from total baud rate to account for 0 int start
																					-- *note* := 0 tels clk counter to start at 0
																					
	signal r_bit_idx : integer range 0 to 7 := 0;									-- index bits for correct transmit order and start at 0
	
	signal r_tx_data 	: std_logic_vector(7 downto 0) := "00000000";					--transmit signal
																					--*note* := "00000000" sets all 8 bits to 0 for clean start
		begin
			--process sensitive to fpga clock
			p_uart_tx : process (i_clk)
			begin	
				if rising_edge(i_Clk) then
				
				
					-- set reset
				if i_rst = '1' then
					--r_state_main <= IDLE;
					r_clk_counter <= 0;
					r_bit_idx <= 0;
					r_tx_data <= "00000000";
					o_tx_active <= '0';
				else
					-- DIRVE ACTIVE state
					if 	r_state_main = IDLE then
						o_tx_active <= '0';
					else
						o_tx_active <= '1';
					end if;
				-- recognize idle state
					case r_state_main is
					
						when idle =>						-- Sets our idle state our active output is low and our idle(data_serial) is high state							
							o_tx_active 	<= '0';
							o_data_serial 	<= '1';
							r_clk_counter	<= 0;
							r_bit_idx		<= 0;
							
								if i_tx_dv = '1' then
								r_tx_data 		<= i_tx_byte;
								r_state_main 	<= tx_START;

									else
									r_state_main	<= IDLE;
								end if;

				-- Start bit
				-- need to get it to set the start bit to 0 then count to baud rate to get full length of Start bit
						
						when tx_START =>
							o_tx_active 	<= '1';
							o_tx_data	<= '0';

							-- to set the time length for bit
							-- wait g_clks_per_bit -1
							-- then count r_clk_counter + 1 *this it to match baud rate
							-- else the clock count back to zero for use in next state
								if 	r_clk_counter < g_clks_per_bit - 1 then					-- we do -1 to account for 0 start
									r_clk_counter <= r_clk_counter + 1;
									else
										r_clk_counter <= 0;								-- reset clock counter for future operations
										r_state_main <= tx_DATA;							-- operation complete move to next state
								end if;
				-- Data bits
							when tx_DATA =>
								o_tx_data <= r_tx_data(r_bit_idx);
								
																
									if	r_clk_counter < g_clks_per_bit - 1 then				-- we do -1 to account for 0 start
										r_clk_counter <= r_clk_counter + 1;
									else
										r_clk_counter <= 0;
										
										if 	r_bit_idx < 7 then
											r_bit_idx <= r_bit_idx + 1;									
									
										else	
											r_bit_idx <= 0;
											r_state_main <= tx_STOP;
									
										end if;
									
									end if;	
																							-- reset clock counter for future operations
																							-- operation complete move to next state

				--Stop bit
							when tx_STOP =>
								o_data_serial <= '1';
								o_tx_active <= '0';
								
								-- stay in this state for one baud rate then back to IDLE
								if 	r_clk_counter < g_clks_per_bit - 1 then					-- we do -1 to account for 0 start
									r_clk_counter <= r_clk_counter + 1;
									else
										r_clk_counter <= 0;									-- reset clock counter for future operations
										r_state_main <= IDLE;								-- operation complete move to next state
								end if;				
					end case;
				end if;
				end if;
			end process p_uart_tx;
end RTL;