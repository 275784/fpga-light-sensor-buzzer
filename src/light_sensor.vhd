-- Konrad Misztela
-- 275784
-- Fototranzystor + ADC (z FSM, 16-bitowa)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity light_sensor is
    Port (
        Clock100MHz : in  std_logic;
        ADC_DOUT    : in  std_logic;
        ADC_CLK     : out std_logic;
        ADC_CS      : out std_logic;
        data_out    : out std_logic_vector(11 downto 0)
    );
end light_sensor;

architecture Behavioral of light_sensor is
    -- Definicja stanów
    type t_state is (IDLE, READ_ADC, UPDATE_OUT);
    signal state : t_state := IDLE;

    -- Rejestry wewnêtrzne (16 bitów dla pe³nej ramki SPI)
    signal shift_reg    : std_logic_vector(15 downto 0) := (others => '0');
    signal bit_cnt      : integer range 0 to 16 := 0;
    
    -- Dzielnik zegara
    signal clk_div      : integer range 0 to 49 := 0; 
    signal sclk_int     : std_logic := '0';
    signal data_out_sig : std_logic_vector(11 downto 0) := (others => '0');

begin
    p_fsm: process(Clock100MHz)
    begin
        if rising_edge(Clock100MHz) then
            case state is
                
                -- Spoczynek
                when IDLE =>
                    sclk_int <= '0';
                    bit_cnt  <= 16;
                    clk_div  <= 0;
                    state    <= READ_ADC;

                -- Komunikacja z czujnikiem
                when READ_ADC =>
                    if clk_div = 49 then
                        clk_div <= 0;
                        if sclk_int = '0' then
                            sclk_int <= '1';
                        else 
                            sclk_int <= '0';
                            
                            -- Wsuwanie 16 bitów
                            shift_reg <= shift_reg(14 downto 0) & ADC_DOUT;
                            bit_cnt   <= bit_cnt - 1;
                            
                            -- Przejœcie po zebraniu ca³ej ramki
                            if bit_cnt = 1 then
                                state <= UPDATE_OUT;
                            end if;
                            
                        end if;
                    else
                        clk_div <= clk_div + 1;
                    end if;

                -- Wystawienie gotowych danych
                when UPDATE_OUT =>
                    -- Wycinane tylko 12 najm³odszych bitów
                    data_out_sig <= shift_reg(11 downto 0);
                    state <= IDLE;
                    
            end case;
        end if;
    end process p_fsm;

    -- Przypisania sygna³ów na piny fizyczne
    ADC_CLK  <= sclk_int;
    ADC_CS   <= '0' when state = READ_ADC else '1';
    data_out <= data_out_sig;

end Behavioral;