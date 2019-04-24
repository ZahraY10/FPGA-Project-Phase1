library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity module3 is
	Port(
		phase_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		nd : IN STD_LOGIC;
		phase_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		clk : IN STD_LOGIC;
		sclr : IN STD_LOGIC
	 );
end module3;

architecture Behavioral of module3 is

	--component declaration
	component module1 is
		Port (
			phase_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			nd : IN STD_LOGIC;
			phase_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
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
	
	component floating_point_addition is
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

	
	--signal declaration
	signal float_phase_in: STD_LOGIC_VECTOR(23 DOWNTO 0);
	signal float_tanh_phase_in: STD_LOGIC_VECTOR(23 DOWNTO 0);
	signal half_phase_in: STD_LOGIC_VECTOR(23 DOWNTO 0);
	signal half_tanh_phase_in: STD_LOGIC_VECTOR(23 DOWNTO 0);
	signal fixed_point_half_phase: STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal float_phase_in_tvalid: STD_LOGIC;
	signal float_tanh_phase_in_tvalid: STD_LOGIC;
	signal half_phase_in_tvalid: STD_LOGIC;
	signal half_tanh_phase_in_tvalid: STD_LOGIC;
	signal fixed_half_phase_in_tvalid: STD_LOGIC;
	signal fixed_half_phase_in_tdata: STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal tanh_half_phase_in: STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal float_sigmoid: STD_LOGIC_VECTOR(23 downto 0);
	signal float_sigmoid_tvalid: STD_LOGIC;
	signal fixed_sigmoid_tvalid: STD_LOGIC;
	
begin

	--converting phase_in to float
	float_pi: fixed_to_float port map(aclk => clk,
												 s_axis_a_tvalid => '1',
												 s_axis_a_tdata => phase_in,
										       m_axis_result_tvalid => float_phase_in_tvalid,
										       m_axis_result_tdata => float_phase_in);
	
	--dividing float phase_in by half									  
	div: floating_point_v6_1 port map(aclk => clk,
											    s_axis_a_tvalid => '1',
												 s_axis_a_tdata => float_phase_in,
												 s_axis_b_tvalid => '1',
												 s_axis_b_tdata => "000010000000000000000000",
												 m_axis_result_tvalid => half_phase_in_tvalid,
												 m_axis_result_tdata => half_phase_in);
	
	--converting half of phase_in to fixed point
	fixed_half_pi: float_to_fixed port map(aclk => clk,
														s_axis_a_tvalid => '1',
														s_axis_a_tdata => half_phase_in,
														m_axis_result_tvalid => fixed_half_phase_in_tvalid,
														m_axis_result_tdata => fixed_half_phase_in_tdata);
	
	--calculating tanh(phase_in / 2)
	mod1: module1 port map(phase_in => fixed_half_phase_in_tdata, 
								  nd => '1',
								  phase_out => tanh_half_phase_in,
								  clk => clk,
								  sclr => sclr);

	--converting tanh(phase_in / 2) to floating point
	float_tanh_pi: fixed_to_float port map(aclk => clk,
												   s_axis_a_tvalid => '1',
												   s_axis_a_tdata => tanh_half_phase_in,
										         m_axis_result_tvalid => float_tanh_phase_in_tvalid,
										         m_axis_result_tdata => float_tanh_phase_in);
	
	--dividing tanh(phase_in / 2) by half									  
	div_tanh: floating_point_v6_1 port map(aclk => clk,
											    s_axis_a_tvalid => '1',
												 s_axis_a_tdata => float_tanh_phase_in,
												 s_axis_b_tvalid => '1',
												 s_axis_b_tdata => "000010000000000000000000",
												 m_axis_result_tvalid => half_tanh_phase_in_tvalid,
												 m_axis_result_tdata => half_tanh_phase_in);
	
	

	--calculating sigmoid
	calc_sigmoid: floating_point_addition port map(aclk => clk,
																 s_axis_a_tvalid => '1',
																 s_axis_a_tdata => half_tanh_phase_in,
																 s_axis_b_tvalid => '1',
																 s_axis_b_tdata => "000010000000000000000000",
																 m_axis_result_tvalid => float_sigmoid_tvalid,
																 m_axis_result_tdata => float_sigmoid);
	
	
	--converiting sigmoid to fixed point
	fixed_half_tanh_pi: float_to_fixed port map(aclk => clk,
														     s_axis_a_tvalid => '1',
														     s_axis_a_tdata => float_sigmoid,
														     m_axis_result_tvalid => fixed_sigmoid_tvalid,
														     m_axis_result_tdata => phase_out);
	
end Behavioral;

