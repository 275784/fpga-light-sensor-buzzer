-- Konrad Misztela
-- 275784
-- Buzzer

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity buzzer_controller is
    Port (
        Clock100MHz : in std_logic;
        adc_data    : in std_logic_vector(11 downto 0);
        Buzzer      : out std_logic
    );
end buzzer_controller;

architecture Behavioral of buzzer_controller is
    signal adc_val      : integer range 0 to 4095 := 0;
    
    -- Zmienny licznik dla ró¿nych czêstotliwoœci
    signal buzzer_limit : integer := 0;
    
    -- Licznik, który porównuje do buzzer_limit
    signal pwm_counter  : integer := 0;
    
    -- Dzwiek buzzera
    signal buzzer_state : std_logic := '0';

begin
    adc_val <= to_integer(unsigned(adc_data));

    process(adc_val)
    begin
        if adc_val <= 455 then
            buzzer_limit <= 0;          -- Cisza
        elsif adc_val <= 910 then
            buzzer_limit <= 95602;      -- 523 Hz
        elsif adc_val <= 1366 then
            buzzer_limit <= 85178;      -- 587 Hz
        elsif adc_val <= 1822 then
            buzzer_limit <= 75872;      -- 659 Hz
        elsif adc_val <= 2278 then
            buzzer_limit <= 71633;      -- 698 Hz
        elsif adc_val <= 2734 then
            buzzer_limit <= 63775;      -- 784 Hz
        elsif adc_val <= 3190 then
            buzzer_limit <= 56818;      -- 880 Hz
        elsif adc_val <= 3646 then
            buzzer_limit <= 50607;      -- 988 Hz
        else
            buzzer_limit <= 47755;      -- 1047 Hz
        end if;
    end process;

    process(Clock100MHz)
    begin
        if rising_edge(Clock100MHz) then
            if buzzer_limit = 0 then
                buzzer_state <= '0';
                pwm_counter <= 0;
            else
                if pwm_counter >= buzzer_limit - 1 then
                    buzzer_state <= not buzzer_state;
                    pwm_counter <= 0;
                else
                    pwm_counter <= pwm_counter + 1;
                end if;
            end if;
        end if;
    end process;

Buzzer <= buzzer_state;

end Behavioral;