library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.module0.ALL;

entity module4 is
	Port(clk: in std_logic);
end module4;

architecture Behavioral of module4 is

	--component declaration
	component module3 is
		Port (
			phase_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			nd : IN STD_LOGIC;
			phase_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			clk : IN STD_LOGIC;
			sclr : IN STD_LOGIC
		);
	end component;
	
	--signal declaration
	signal r : memory := init_rom;
	signal r2: memory := init_rom;
	


begin
		
	mod3: module3 port map(phase_in => r(0)(0), nd => '0', phase_out => r2(0)(0), clk => '1', sclr => '1');
	F1: for addr_pos1 in 0 to m - 1 generate
		begin
		F2: for addr_pos2 in 0 to n - 1 generate
			begin
			-- Initialize each address with the address itself
				mod3: module3 port map(phase_in => r(addr_pos1)(addr_pos2), nd => '1', phase_out => r2(addr_pos1)(addr_pos2), clk => clk, sclr => '0');	
		end generate F2;
	end generate F1;


end Behavioral;

