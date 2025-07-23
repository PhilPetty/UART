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
begin
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

			i_rst				=> rst,
			
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
			
			
	p_uart_disp : process(i_clk)
	begin
		if rising_edge (i_clk) then
	--	copy_rx_dv	<= rx_dv;
			if syncRst = '1' then
				AN0				<= '1';
				AN1				<= '1';
				AN2				<= '1';
				AN3				<= '1';
				num_disp		<= "11111111";
				--rx_dv			<= '0';
				
			else
				--rx_dv	<= o_rx_dv;
				--rx_dv			<= '1';

				--	case r_state_disp is
					
					--	when dv0	=>
					--		if 	rx_dv = '0' then
					--			AN0				<= '1';
					--			AN1				<= '1';
					--			AN2				<= '1';
					--			AN3				<= '1';
					--			num_disp		<= "11111111";
					--			r_state_disp 	<= dv0;
					--		else
					--			r_state_disp	<= dv1;
					--		end if;
					--	when dv1	=>
							if rx_dv = '1' then
								AN0				<= '0';
								AN1				<= '1';
								AN2				<= '1';
								AN3				<= '1';
								num_disp		<= syncd_byte;
						--	else
							--	r_state_disp	<= dv0;
					
							end if;
				--	end case;
			end if;
		end if;
	end process;
	tx_uartOut	<= rx_uart_syncd;
end RTL;	