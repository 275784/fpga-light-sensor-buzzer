-- Konrad Misztela
-- 275784
-- Modul Top

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port (
        SW_zero     : in  STD_LOGIC;
        Clock100MHz : in  STD_LOGIC;
        ADC_DOUT    : in  STD_LOGIC;
        ADC_CLK     : out STD_LOGIC;
        ADC_CS      : out STD_LOGIC;
        Buzzer      : out STD_LOGIC
    );
end top;

architecture Behavioral of top is

    -- Sygna³y wewnêtrzne ³¹cz¹ce modu³y
    signal s_adc_data : std_logic_vector(11 downto 0);
    signal s_buzzer   : std_logic; -- Sygna³ dla dŸwiêku przed prze³¹cznikiem

    component light_sensor is
        Port (
            Clock100MHz: in std_logic;
            ADC_DOUT:    in std_logic;
            ADC_CLK:     out std_logic;
            ADC_CS:      out std_logic;
            data_out:    out std_logic_vector(11 downto 0)
        );
    end component;

    component buzzer_controller is
        Port (
            Clock100MHz : in std_logic;
            adc_data    : in std_logic_vector(11 downto 0);
            Buzzer      : out std_logic
        );
    end component;

begin

    Inst_light_sensor: light_sensor port map (
        Clock100MHz => Clock100MHz,
        ADC_DOUT    => ADC_DOUT,
        ADC_CLK     => ADC_CLK,
        ADC_CS      => ADC_CS,
        data_out    => s_adc_data
    );

    Inst_buzzer_controller: buzzer_controller port map (
        Clock100MHz => Clock100MHz,
        adc_data    => s_adc_data,
        Buzzer      => s_buzzer
    );

    Buzzer <= s_buzzer when SW_zero = '1' else '0';

end Behavioral;