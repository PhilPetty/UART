-- 4bytedata.vhd
--
-- 4byte Data Logic File
--
-- Phillip Petty
-- 
-- 7/30/2025


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity four_byte_data is
	generic(
			state_clk	: integer := 1000
			);

	port (
		--inputs
		clk			:	in std_logic;
		rx_dv			:	in std_logic;
		syncd_byte		:	in std_logic_vector(7 downto 0);
		syncRst			:	in std_logic;
		--outputs
		AN0				: 	out std_logic;
		AN1				: 	out std_logic;
		AN2				: 	out std_logic;
		AN3				: 	out std_logic;
		num_disp		: 	out std_logic_vector(7 downto 0)
		--byteprnt		: out std_logic_vector(7 downto 0)
		);
		

end four_byte_data;

architecture RTL of four_byte_data is
	
	type byte_collection_states		is	(collectbyte, prnt_byte);
	type fourbytestates 			is	(byte1state, byte2state, byte3state, byte4state);
	type byte_array is array (0 to 3) of std_logic_vector(7 downto 0);
	signal state_time				:	integer range 0 to state_clk - 1	:= 0;
	signal byteprnt					: 	byte_array := (others => ( others => '0'));
	signal byte_col					:	byte_collection_states	:= collectbyte;
	signal bytestate				:	fourbytestates 	:= byte1state;
	signal rx_byteIndex				:	integer range 0 to 3		:= 0;	

	
	
begin
	p_fourbyte : process(clk)
	begin
		if rising_edge (clk) then
	--	copy_rx_dv	<= rx_dv;
			if syncRst = '1' then
				AN0				<= '1';
				AN1				<= '1';
				AN2				<= '1';
				AN3				<= '1';
				num_disp		<= "11111111";
				byteprnt(0)		<= "11111111";
				byteprnt(1)		<= "11111111";
				byteprnt(2)		<= "11111111";
				byteprnt(3)		<= "11111111";
				--syncd_byte		<= "00000000";
				rx_byteIndex		<=0;
				byte_col				<= collectbyte;
			else	
				case byte_col is
				
					when collectbyte =>

						if 	rx_dv = '1' then
							byteprnt(rx_byteIndex)	<= syncd_byte;
							if 	rx_byteIndex < 3 then 
								rx_byteIndex <= rx_byteIndex + 1;
							else
								rx_byteIndex		<= 0;
								byte_col			<= prnt_byte;
							end if;
						else
							byte_col				<= collectbyte;
						end if;	
					when prnt_byte =>


						if rx_dv = '0' then
							
							case bytestate is

								when byte1state =>
									if state_time < state_clk - 1 then
										AN0				<= '1';
										AN1				<= '1';
										AN2				<= '1';
										AN3				<= '0';
										num_disp		<= byteprnt(0);
										state_time		<= state_time + 1;
									else
										state_time		<= 0;
										bytestate		<= byte2state;
									end if;
									
								when byte2state =>
									if state_time < state_clk - 1 then
										AN0				<= '1';
										AN1				<= '1';
										AN2				<= '0';
										AN3				<= '1';
										num_disp		<= byteprnt(1);
										state_time		<= state_time + 1;
									else
										state_time		<= 0;
										bytestate		<= byte3state;
									end if;
										
								when byte3state =>
									if state_time < state_clk - 1 then
										AN0				<= '1';
										AN1				<= '0';
										AN2				<= '1';
										AN3				<= '1';
										num_disp		<= byteprnt(2);
										state_time		<= state_time + 1;
									else
										state_time		<= 0;
										bytestate		<= byte4state;
									end if;
									
								when byte4state =>
									if state_time < state_clk - 1 then
										AN0				<= '0';
										AN1				<= '1';
										AN2				<= '1';
										AN3				<= '1';
										num_disp		<= byteprnt(3);
										state_time		<= state_time + 1;
									else
										state_time		<= 0;
										bytestate		<= byte1state;
									end if;

								end case;
						else
							byteprnt(rx_byteIndex)	<= syncd_byte;
							rx_byteIndex <= rx_byteIndex + 1;							
							byte_col				<= collectbyte;
						end if;			
							
				end case;
			end if;
		end if;
	end process;
end RTL;