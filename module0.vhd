library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

package module0 is

	constant n : integer := 6;
	constant m : integer := 6;
	
	--type declaration
	subtype ROW_BYTE is std_logic_vector(15 downto 0);
	type COLUMN_BYTE is array ((n-1) downto 0) of ROW_BYTE;
	type memory is array ((m-1) downto 0) of COLUMN_BYTE;
	
	subtype SECONDARY_ROW_BYTE is std_logic_vector(31 downto 0);
	type SECONDARY_COLUMN_BYTE is array ((n-1) downto 0) of SECONDARY_ROW_BYTE;
	type secondary_memory is array ((m-1) downto 0) of SECONDARY_COLUMN_BYTE;

	subtype f is std_logic_vector(23 downto 0);
	type nf is array ((n-1) downto 0) of f;
	type mnf is array ((m-1) downto 0) of nf;
	
	subtype f2 is std_logic_vector(47 downto 0);
	type nf2 is array ((n-1) downto 0) of f2;
	type mnf2 is array ((m-1) downto 0) of nf2;
	
	--function declaration
	--initializing rom
	function init_rom
		return memory is 
		variable tmp : memory := (others => (others => (others => '0')));
	begin 
		for addr_pos1 in 0 to m - 1 loop
			for addr_pos2 in 0 to n - 1 loop
				-- Initialize each address with the address itself
				tmp(addr_pos1)(addr_pos2):= std_logic_vector(to_unsigned(addr_pos1 + addr_pos2, 16));
			end loop;
		end loop;
		return tmp;
	end init_rom;	 
	
	--initializing secondary rom
	function init_secondary_rom
		return secondary_memory is 
		variable tmp1 : secondary_memory := (others => (others => (others => '0')));
	begin 
		for addr_pos1 in 0 to m - 1 loop
			for addr_pos2 in 0 to n - 1 loop
				-- Initialize each address with the address itself
				tmp1(addr_pos1)(addr_pos2):= std_logic_vector(to_unsigned(addr_pos1 + addr_pos2, 32));
			end loop;
		end loop;
		return tmp1;
	end init_secondary_rom;
	
end module0;

package body module0 is
 
end module0;
