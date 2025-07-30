-- UART_display.vhd
--
-- 4byte UART TOP LEVEL FILE
--
-- Phillip Petty
-- 
-- 7/30/2025


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

	entity Uart_disp is
	generic(
		--g_clks_per_bit : integer := 1302
		g_clk_counter	: integer := 1000
	);
	
	port(
	--inputs
		i_clk			: in std_logic;
		rst				: in std_logic;
		--sync_byte		: in std_logic;
		--	: in std_logic_vector(7 downto 0);
		--rx_dv			: out std_logic;
		rx_uart_async	: in std_logic;
		

	-- outputs
	AN0			: out std_logic;
	AN1			: out std_logic;
	AN2			: out std_logic;
	AN3			: out std_logic;
	num_disp	: out std_logic_vector(7 downto 0);
	tx_uartOut	: out std_logic
	--o_rx_dv		: out std_logic;	
	
	);
end Uart_disp;

architecture RTL of Uart_disp is
	--type disp_main is (dv0, dv1); 
	--signal r_state_disp			: disp_main := dv0;
	--signal r_bit_idx 			: integer range 0 to 7 := 0;
	--signal r_tx_data	 		: std_logic_vector(7 downto 0) := (others => '0'); 
	--signal r_clk_counter		: integer range 0 to g_clk_counter - 1 := 0;
	signal syncRst				: std_logic := '0';
	signal syncd_byte			: std_logic_vector(7 downto 0) := (others => '0');
	signal rx_uart_syncd		: std_logic;
	signal rx_dv				: std_logic;
	signal resetinvert			: std_logic;
	signal byteprnt_sig			: std_logic_vector(7 downto 0);
--	signal copy_rx_dv			: std_logic;
	
component	dualRankSync is generic ( resetVal    			: std_logic := '0');

	port (
		clk						: in std_logic;
		
		rst						: in std_logic;
		
		inData					: in std_logic;
		
		outData					: out std_logic );
	
	end component;
	
component rstDualRankSync is generic ( asyncRstAssertVal 	: std_logic := '0');

    port (

        clk                     : in  std_logic;

        asyncRst                : in  std_logic;

        syncRst                 : out std_logic );

    end component;	
	
component rx_uart_sample is

		port(
			
			i_clk				: in std_logic;
			
			i_rst				: in std_logic;
			
			i_data_serial		: in std_logic;
			
			o_rx_Byte			: out std_logic_vector(7 downto 0);
			
			o_rx_dv				: out std_logic
			
			);
end component;

component four_byte_data is


	port (
		--inputs
		clk				: in std_logic;
		rx_dv			: in std_logic;
		syncd_byte		: in std_logic_vector(7 downto 0);
		syncRst			: in std_logic;
		--outputs
		AN0				: out std_logic;
		AN1				: out std_logic;
		AN2				: out std_logic;
		AN3				: out std_logic;
		num_disp		: out std_logic_vector(7 downto 0)
		--byteprnt		: out std_logic_vector(7 downto 0)
		);
end component;
begin

four_byte_data_i	: four_byte_data


	port map (
		--inputs
		clk				=>	i_clk,
		rx_dv			=>	rx_dv,
		syncd_byte		=>	syncd_byte,
		syncRst			=>	syncRst,
		--outputs
		AN0				=> 	AN0,
		AN1				=> 	AN1,
		AN2				=> 	AN2,
		AN3				=> 	AN3,
		num_disp		=> 	num_disp
		--byteprnt		=>	byteprnt_sig
		);
		

-- new reset/rstinvert
-- set asyncRst to resetinvert
resetinvert     <= not rst;
rstDualRankSync_i   : rstDualRankSync        generic map (

            asyncRstAssertVal    => '1')

        port map (

            clk             => i_clk,

            asyncRst        => resetinvert,

            syncRst         => syncRst

        );

rx_uart_sample_i   : rx_uart_sample  

        port map (

			i_clk				=> i_clk,

			i_rst				=> syncRst,
			
			i_data_serial		=> rx_uart_syncd,

			o_rx_Byte			=> syncd_byte,  --7bits
			
			o_rx_dv				=> rx_dv

			
      );


dualRankSync_uartRx   : dualRankSync        generic map (
            resetVal    => '1')
        port map (
            rst         => resetinvert,
            clk         => i_clk,
            inData      => rx_uart_async,
            outData     => rx_uart_syncd );
			
	--COMMENTED OUT BLOCK IS FOR SINGLE BYTE OVER UART OPERATIONS
	--
	--p_uart_disp : process(i_clk)
	--begin
	--	if rising_edge (i_clk) then
	--	copy_rx_dv	<= rx_dv;
	--		if syncRst = '1' then
	--			AN0				<= '1';
	--			AN1				<= '1';
	--			AN2				<= '1';
	--			AN3				<= '1';
	--			num_disp		<= "10101010";
	--			--rx_dv			<= '0';
	--			
	--		else
	--						if rx_dv = '1' then
	--							AN0				<= '0';
	--							AN1				<= '1';
	--							AN2				<= '1';
	--							AN3				<= '1';
	--							num_disp		<= syncd_byte;
						--	else
							--	r_state_disp	<= dv0;
					
	--						end if;
				--	end case;
	--		end if;
	--	end if;
	--end process;
	--
	tx_uartOut	<= rx_uart_syncd;
end RTL;	