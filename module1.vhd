library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity module1 is
	Port (
    phase_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    nd : IN STD_LOGIC;
    phase_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    clk : IN STD_LOGIC;
    sclr : IN STD_LOGIC
  );
end module1;

architecture Behavioral of module1 is

	--component declaration
	component cordic_v4_0 is
		Port(
			phase_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			nd : IN STD_LOGIC;
			x_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			y_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			rdy : OUT STD_LOGIC;
			rfd : OUT STD_LOGIC;
			clk : IN STD_LOGIC;
			sclr : IN STD_LOGIC
		);
	end component;

	component fixed_to_float is
		Port (
			aclk : IN STD_LOGIC;
			s_axis_a_tvalid : IN STD_LOGIC;
			s_axis_a_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			m_axis_result_tvalid : OUT STD_LOGIC;
			m_axis_result_tdata : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
		);
	end component;
	
	component floating_point_v6_1 is
		Port(
			aclk : IN STD_LOGIC;
			s_axis_a_tvalid : IN STD_LOGIC;
			s_axis_a_tdata : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
			s_axis_b_tvalid : IN STD_LOGIC;
			s_axis_b_tdata : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
			m_axis_result_tvalid : OUT STD_LOGIC;
			m_axis_result_tdata : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
		);
	end component;

	component float_to_fixed is
		Port(
			aclk : IN STD_LOGIC;
			s_axis_a_tvalid : IN STD_LOGIC;
			s_axis_a_tdata : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
			m_axis_result_tvalid : OUT STD_LOGIC;
			m_axis_result_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	end component;


	--signal declaration
	signal x: STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal y: STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal rdy: STD_LOGIC;
	signal rfd: STD_LOGIC;
	signal fx: STD_LOGIC_VECTOR(23 DOWNTO 0);
	signal fy: STD_LOGIC_VECTOR(23 DOWNTO 0);
	signal x_result_tvalid: STD_LOGIC;
	signal y_result_tvalid: STD_LOGIC;
	signal div_result_tvalid: STD_LOGIC;
	signal div_result_tdata: STD_LOGIC_VECTOR(23 DOWNTO 0);
	signal phase_out_result_tvalid: STD_LOGIC;
	
begin

	--port mapping
	cord: cordic_v4_0 port map (phase_in => phase_in,
											nd => nd,
											x_out => x,
											y_out => y,
											rdy => rdy,
											rfd => rfd,
											clk => clk,
											sclr => sclr);

	f2f1: fixed_to_float port map(aclk => clk, s_axis_a_tvalid => '1', s_axis_a_tdata => x, m_axis_result_tvalid => x_result_tvalid, m_axis_result_tdata => fx);
	f2f2: fixed_to_float port map(aclk => clk, s_axis_a_tvalid => '1', s_axis_a_tdata => y, m_axis_result_tvalid => y_result_tvalid, m_axis_result_tdata => fy);
	
	fpv6: floating_point_v6_1 port map(aclk => clk,
												  s_axis_a_tvalid => '1',
												  s_axis_a_tdata => fy,
												  s_axis_b_tvalid => '1', 
												  s_axis_b_tdata => fx,
												  m_axis_result_tvalid => div_result_tvalid,
												  m_axis_result_tdata => div_result_tdata);
	
	f2f3: float_to_fixed port map(aclk => clk, s_axis_a_tvalid => '1', s_axis_a_tdata => div_result_tdata, m_axis_result_tvalid => phase_out_result_tvalid, m_axis_result_tdata => phase_out);
	
end Behavioral;

