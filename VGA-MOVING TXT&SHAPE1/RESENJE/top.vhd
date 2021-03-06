----------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije                  --
--  Copyright � 2009 All Rights Reserved                                        --
----------------------------------------------------------------------------------
--                                                                              --
-- Autor: LPRS2 TIM 2009/2010 <LPRS2@KRT.neobee.net>                            --
--                                                                              --
-- Datum izrade: /                                                              --
-- Naziv Modula: vga.vhd                                                        --
-- Naziv projekta: LabVezba2                                                    --
--                                                                              --
-- Opis: ispisivanje vrednosti rezolucije u gornjem desnom uglu                 --
--                                                                              --
-- Ukljucuje module: vga, char_rom                                              --
--                                                                              --
-- Verzija : 1.0                                                                --
--                                                                              --
-- Dodatni komentari: /                                                         --
--                                                                              --
-- ULAZI: FPGA_CLK                                                              --
--        FPGA_RESET                                                            --
--                                                                              --
-- IZLAZI: VGA_HSYNC                                                            --
--         VGA_VSYNC                                                            --
--         BLANK                                                                --
--         PIX_CLOCK                                                            --
--         PSAVE                                                                --
--         SYNC                                                                 --
--         RED0                                                                 --
--         RED1                                                                 --
--         RED2                                                                 --
--         RED3                                                                 --
--         RED4                                                                 --
--         RED5                                                                 --
--         RED6                                                                 --
--         RED7                                                                 --
--         GREEN0                                                               --
--         GREEN1                                                               --
--         GREEN2                                                               --
--         GREEN3                                                               --
--         GREEN4                                                               --
--         GREEN5                                                               --
--         GREEN6                                                               --
--         GREEN7                                                               --
--         BLUE0                                                                --
--         BLUE1                                                                --
--         BLUE2                                                                --
--         BLUE3                                                                --
--         BLUE4                                                                --
--         BLUE5                                                                --
--         BLUE6                                                                --
--         BLUE7                                                                --
--                                                                              --
-- PARAMETRI : /                                                                --
--                                                                              --
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY top IS PORT (
                    FPGA_CLK    : IN  STD_LOGIC; -- TAKT  sa ploce
                    FPGA_RESET  : IN  STD_LOGIC; -- RESET sa ploce
                    -- vga pinovi
                    VGA_HSYNC   : OUT STD_LOGIC; -- signal horizontalne sinhronizacije
                    VGA_VSYNC   : OUT STD_LOGIC; -- signal vertikalne   sinhronizacije

                    BLANK       : OUT STD_LOGIC; -- signal indikacije aktivnosti piksela
                    PIX_CLOCK   : OUT STD_LOGIC; -- takt sa kojim je sinhronizovano ispisivanje pixela
                    PSAVE       : OUT STD_LOGIC; -- signal kontrole napajanja, MORA uvek na visokom logickom nivou
                    SYNC        : OUT STD_LOGIC; -- sjedinjena vertikalna i horizontalna sinhronizacija
                    RED0        : OUT STD_LOGIC; -- izlaz za crvenu boju
                    RED1        : OUT STD_LOGIC; -- izlaz za crvenu boju
                    RED2        : OUT STD_LOGIC; -- izlaz za crvenu boju
                    RED3        : OUT STD_LOGIC; -- izlaz za crvenu boju
                    RED4        : OUT STD_LOGIC; -- izlaz za crvenu boju
                    RED5        : OUT STD_LOGIC; -- izlaz za crvenu boju
                    RED6        : OUT STD_LOGIC; -- izlaz za crvenu boju
                    RED7        : OUT STD_LOGIC; -- izlaz za crvenu boju
                    GREEN0      : OUT STD_LOGIC; -- izlaz za zelenu boju
                    GREEN1      : OUT STD_LOGIC; -- izlaz za zelenu boju
                    GREEN2      : OUT STD_LOGIC; -- izlaz za zelenu boju
                    GREEN3      : OUT STD_LOGIC; -- izlaz za zelenu boju
                    GREEN4      : OUT STD_LOGIC; -- izlaz za zelenu boju
                    GREEN5      : OUT STD_LOGIC; -- izlaz za zelenu boju
                    GREEN6      : OUT STD_LOGIC; -- izlaz za zelenu boju
                    GREEN7      : OUT STD_LOGIC; -- izlaz za zelenu boju
                    BLUE0       : OUT STD_LOGIC; -- izlaz za plavu  boju
                    BLUE1       : OUT STD_LOGIC; -- izlaz za plavu  boju
                    BLUE2       : OUT STD_LOGIC; -- izlaz za plavu  boju
                    BLUE3       : OUT STD_LOGIC; -- izlaz za plavu  boju
                    BLUE4       : OUT STD_LOGIC; -- izlaz za plavu  boju
                    BLUE5       : OUT STD_LOGIC; -- izlaz za plavu  boju
                    BLUE6       : OUT STD_LOGIC; -- izlaz za plavu  boju
                    BLUE7       : OUT STD_LOGIC  -- izlaz za plavu  boju
                   );
END top;

ARCHITECTURE rtl OF top IS

-- instanciranje komponenti

COMPONENT vga IS GENERIC (

                       -- podrzane rezolucije vga ekrana -- vrednost parametra
                       --     rezolucija 640x480         --        0
                       --     rezolucija 800x600         --        1
                       --     rezolucija 1024x768        --        2
                       --     rezolucija 1152x864        --        3
                       --     rezolucija 1280x1024       --        4
                       resolution_type : integer  := 0

                      );
              PORT(
                   clk_i          : IN  STD_LOGIC;                       -- takt
                   rst_n_i        : IN  STD_LOGIC;                       -- reset
                   red_i          : IN  STD_LOGIC;                       -- ulazna  vrednost crvene boje
                   green_i        : IN  STD_LOGIC;                       -- ulazna  vrednost zelene boje
                   blue_i         : IN  STD_LOGIC;                       -- ulazna  vrednost plave  boje
                   red_o          : OUT STD_LOGIC;                       -- izlazna vrednost crvene boje
                   green_o        : OUT STD_LOGIC;                       -- izlazna vrednost zelene boje
                   blue_o         : OUT STD_LOGIC;                       -- izlazna vrednost plave  boje
                   pixel_row_o    : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);   -- pozicija pixela po vrstama
                   pixel_column_o : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);   -- pozicija pixela po kolonama
                   hsync_o        : OUT STD_LOGIC;                       -- horizontalna sinhronizacija
                   vsync_o        : OUT STD_LOGIC;                       -- vertikalna   sinhronizacija
                   psave_o        : OUT STD_LOGIC;                       -- signal kontrole napajanja, MORA uvek na visokom logickom nivou
                   blank_o        : OUT STD_LOGIC;                       -- aktivni deo linije
                   vga_pix_clk_o  : OUT STD_LOGIC;                       -- takt sa kojim je sinhronizovano ispisivanje pixela
                   vga_rst_n_o    : OUT STD_LOGIC;                       -- reset sinhronizovan sa vga_pix_clk_o taktom
                   sync_o         : OUT STD_LOGIC                        -- sjedinjena vertikalna i horizontalna sinhronizacija
                  );
END COMPONENT vga;

COMPONENT char_rom IS PORT (
                            clk_i               : IN   STD_LOGIC;                            -- takt signal
                            character_address_i : IN   STD_LOGIC_VECTOR (5 DOWNTO 0);        -- adresa karaktera
                            font_row_i          : IN   STD_LOGIC_VECTOR (2 DOWNTO 0);        --
                            font_col_i          : IN   STD_LOGIC_VECTOR (2 DOWNTO 0);        --
                            rom_mux_output_o    : OUT  STD_LOGIC                             -- izlazni signal iz char_rom-a
                           );
END COMPONENT char_rom;

-- rezolucija ekrana
SIGNAL    horizontal_res       : STD_LOGIC_VECTOR(10 DOWNTO 0);
SIGNAL    vertical_res         : STD_LOGIC_VECTOR(10 DOWNTO 0);

------------------------------------------------
CONSTANT  res_type_c             : INTEGER := 4;
------------------------------------------------

    ------> PODESAVANJE REZOLUCIJE <------
    --             |                    --
    -- rezolucija  | vrednost parametra --
    --             |    res_type        --
    ---------------|----------------------
    -- 640x480     |      0             --
    -- 800x600     |      1             --
    -- 1024x768    |      2             --
    -- 1152x864    |      3             --
    -- 1280x1024   |      4             --
    --------------------------------------

SIGNAL  pix_clk_s              : STD_LOGIC;
SIGNAL  red_out_s              : STD_LOGIC_VECTOR( 7 DOWNTO 0);
SIGNAL  green_out_s            : STD_LOGIC_VECTOR( 7 DOWNTO 0);
SIGNAL  blue_out_s             : STD_LOGIC_VECTOR( 7 DOWNTO 0);
SIGNAL  red_s                  : STD_LOGIC;
SIGNAL  green_s                : STD_LOGIC;
SIGNAL  blue_s                 : STD_LOGIC;
SIGNAL  pixel_row_s            : STD_LOGIC_VECTOR(10 DOWNTO 0);
SIGNAL  pixel_column_s         : STD_LOGIC_VECTOR(10 DOWNTO 0);
-- signali za rom
SIGNAL  char_addr_s            : STD_LOGIC_VECTOR( 5 DOWNTO 0);
SIGNAL  font_col_s             : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL  font_row_s             : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL  rom_out_s              : STD_LOGIC;

-- realizacija modula
BEGIN



  vga_i:vga GENERIC MAP(
                         resolution_type => res_type_c
                       )
              PORT MAP (
                         clk_i           => FPGA_CLK        ,
                         rst_n_i         => FPGA_RESET      ,
                         red_i           => rom_out_s       ,
                         green_i         => rom_out_s       ,
                         blue_i          => rom_out_s       ,
                         red_o           => red_s           ,
                         green_o         => green_s         ,
                         blue_o          => blue_s          ,
                         pixel_row_o     => pixel_row_s     ,
                         pixel_column_o  => pixel_column_s  ,
                         hsync_o         => VGA_HSYNC       ,
                         vsync_o         => VGA_VSYNC       ,
                         psave_o         => PSAVE           ,
                         blank_o         => BLANK           ,
                         vga_pix_clk_o   => pix_clk_s       ,
                         vga_rst_n_o     => open            ,
                         sync_o          => SYNC
                       );



  char_rom_i:char_rom PORT MAP(
                               clk_i                => pix_clk_s    ,        --
                               character_address_i  => char_addr_s  ,        -- adresa karaktera
                               font_row_i           => font_row_s   ,        --
                               font_col_i           => font_col_s   ,        --
                               rom_mux_output_o     => rom_out_s             -- izlazni signal iz char_rom-a
                              );




  -- odredjivanje boje ispisa okvira i pozadine

  rgb_out:PROCESS (
                   pixel_column_s,
                   pixel_row_s   ,
                   red_s         ,
                   green_s       ,
                   blue_s        ,
                   horizontal_res,
                   vertical_res
                  )
  BEGIN
    IF (pixel_row_s    < 4                    OR
        pixel_row_s    > (vertical_res - 5)   OR
        pixel_column_s < 4                    OR
        pixel_column_s > (horizontal_res - 5)      ) THEN

       red_out_s   <= "11111111";
       green_out_s <= (OTHERS => '0');
       blue_out_s  <= (OTHERS => '0');

     ELSE
       IF (red_s = '1')   THEN red_out_s <= (red_s & "1111111");
       ELSE                    red_out_s <= (red_s & "0000000");
       END IF;

       IF (green_s = '1') THEN green_out_s <= (green_s & "1111111");
       ELSE                    green_out_s <= (green_s & "0000000");
       END IF;

       IF (blue_s = '1')  THEN blue_out_s <= (blue_s & "1111111");
       ELSE                    blue_out_s <= (blue_s & "0000000");
       END IF;

     END IF;
  END PROCESS rgb_out;



-- podesavanje ispisa na ekran u zavisnosti od rezolucije
----------------------------------------------------------------------------------------
--        rezolucija 640x480
----------------------------------------------------------------------------------------
g1:IF res_type_c = 0 GENERATE

    horizontal_res  <= "01010000000"; --640
    vertical_res    <= "00111100000"; --480;

    addr_gen: PROCESS (pixel_column_s,pixel_row_s)
    BEGIN
      IF (pixel_row_s < 40 AND pixel_row_s >= 32) THEN

        IF    (pixel_column_s < 584 AND pixel_column_s >= 576) THEN char_addr_s <= o"66";
        ELSIF (pixel_column_s < 592 AND pixel_column_s >= 584) THEN char_addr_s <= o"64";
        ELSIF (pixel_column_s < 600 AND pixel_column_s >= 592) THEN char_addr_s <= o"60";
        ELSIF (pixel_column_s < 608 AND pixel_column_s >= 600) THEN char_addr_s <= o"30";
        ELSIF (pixel_column_s < 616 AND pixel_column_s >= 608) THEN char_addr_s <= o"64";
        ELSIF (pixel_column_s < 624 AND pixel_column_s >= 616) THEN char_addr_s <= o"70";
        ELSIF (pixel_column_s < 632 AND pixel_column_s >= 624) THEN char_addr_s <= o"60";
        ELSE                                                        char_addr_s <= o"40";
        END IF;

      ELSE
        char_addr_s <= o"40";
      END IF;
    END PROCESS addr_gen;

  END GENERATE g1;


----------------------------------------------------------------------------------------
--        rezolucija 800x600
----------------------------------------------------------------------------------------
g2:IF res_type_c = 1 GENERATE

    horizontal_res  <= "01100100000"; --800
    vertical_res    <= "01001011000"; --600

    addr_gen: PROCESS (pixel_column_s,pixel_row_s)
    BEGIN
      IF (pixel_row_s < 40 AND pixel_row_s >= 32) THEN

        IF    (pixel_column_s < 728 AND pixel_column_s >= 720) THEN char_addr_s <= o"70";
        ELSIF (pixel_column_s < 736 AND pixel_column_s >= 728) THEN char_addr_s <= o"60";
        ELSIF (pixel_column_s < 744 AND pixel_column_s >= 736) THEN char_addr_s <= o"60";
        ELSIF (pixel_column_s < 752 AND pixel_column_s >= 744) THEN char_addr_s <= o"30";
        ELSIF (pixel_column_s < 760 AND pixel_column_s >= 752) THEN char_addr_s <= o"66";
        ELSIF (pixel_column_s < 768 AND pixel_column_s >= 760) THEN char_addr_s <= o"60";
        ELSIF (pixel_column_s < 776 AND pixel_column_s >= 768) THEN char_addr_s <= o"60";
        ELSE                                                        char_addr_s <= o"40";
        END IF;

      ELSE
        char_addr_s <= o"40";
      END IF;
    END PROCESS addr_gen;

  END GENERATE g2;

----------------------------------------------------------------------------------------
--        rezolucija 1024x768
----------------------------------------------------------------------------------------
g3:IF res_type_c = 2 GENERATE

    horizontal_res  <= "10000000000"; --1024
    vertical_res    <= "01100000000"; --768

    addr_gen: PROCESS (pixel_column_s,pixel_row_s)
    BEGIN
      IF (pixel_row_s < 40 AND pixel_row_s >= 32) THEN

        IF    (pixel_column_s < 952  AND pixel_column_s >= 944 ) THEN char_addr_s <= o"61";
        ELSIF (pixel_column_s < 960  AND pixel_column_s >= 952 ) THEN char_addr_s <= o"60";
        ELSIF (pixel_column_s < 968  AND pixel_column_s >= 960 ) THEN char_addr_s <= o"62";
        ELSIF (pixel_column_s < 976  AND pixel_column_s >= 968 ) THEN char_addr_s <= o"64";
        ELSIF (pixel_column_s < 984  AND pixel_column_s >= 976 ) THEN char_addr_s <= o"30";
        ELSIF (pixel_column_s < 992  AND pixel_column_s >= 984 ) THEN char_addr_s <= o"67";
        ELSIF (pixel_column_s < 1000 AND pixel_column_s >= 992 ) THEN char_addr_s <= o"66";
        ELSIF (pixel_column_s < 1008 AND pixel_column_s >= 1000) THEN char_addr_s <= o"70";
        ELSE                                                          char_addr_s <= o"40";
        END IF;

      ELSE
        char_addr_s <= o"40";
      END IF;
    END PROCESS addr_gen;

  END GENERATE g3;


----------------------------------------------------------------------------------------
--        rezolucija 1152x864
----------------------------------------------------------------------------------------
g4:IF res_type_c = 3 GENERATE

    horizontal_res  <= "10010000000"; --1152
    vertical_res    <= "01101100000"; --864

    addr_gen: PROCESS (pixel_column_s,pixel_row_s)
    BEGIN
      IF (pixel_row_s < 40 AND pixel_row_s >= 32) THEN

        IF    (pixel_column_s < 1080 AND pixel_column_s >= 1072) THEN char_addr_s <= o"61";
        ELSIF (pixel_column_s < 1088 AND pixel_column_s >= 1080) THEN char_addr_s <= o"61";
        ELSIF (pixel_column_s < 1096 AND pixel_column_s >= 1088) THEN char_addr_s <= o"65";
        ELSIF (pixel_column_s < 1104 AND pixel_column_s >= 1096) THEN char_addr_s <= o"62";
        ELSIF (pixel_column_s < 1112 AND pixel_column_s >= 1104) THEN char_addr_s <= o"30";
        ELSIF (pixel_column_s < 1120 AND pixel_column_s >= 1112) THEN char_addr_s <= o"70";
        ELSIF (pixel_column_s < 1128 AND pixel_column_s >= 1120) THEN char_addr_s <= o"66";
        ELSIF (pixel_column_s < 1136 AND pixel_column_s >= 1128) THEN char_addr_s <= o"64";
        ELSE                                                          char_addr_s <= o"40";
        END IF;

      ELSE
        char_addr_s <= o"40";
      END IF;
    END PROCESS addr_gen;

  END GENERATE g4;


----------------------------------------------------------------------------------------
--        rezolucija 1280x1024
----------------------------------------------------------------------------------------
g5:IF res_type_c = 4 GENERATE

    horizontal_res  <= "10100000000"; --1280
    vertical_res    <= "10000000000"; --1024

    addr_gen: PROCESS (pixel_column_s,pixel_row_s)
    BEGIN
      IF (pixel_row_s < 40 AND pixel_row_s >= 32) THEN

        IF    (pixel_column_s < 1208  AND pixel_column_s >= 1200) THEN char_addr_s <= o"61";
        ELSIF (pixel_column_s < 1216  AND pixel_column_s >= 1208) THEN char_addr_s <= o"62";
        ELSIF (pixel_column_s < 1224  AND pixel_column_s >= 1216) THEN char_addr_s <= o"70";
        ELSIF (pixel_column_s < 1232  AND pixel_column_s >= 1224) THEN char_addr_s <= o"60";
        ELSIF (pixel_column_s < 1240  AND pixel_column_s >= 1232) THEN char_addr_s <= o"30";
        ELSIF (pixel_column_s < 1248  AND pixel_column_s >= 1240) THEN char_addr_s <= o"61";
        ELSIF (pixel_column_s < 1256  AND pixel_column_s >= 1248) THEN char_addr_s <= o"60";
        ELSIF (pixel_column_s < 1264  AND pixel_column_s >= 1256) THEN char_addr_s <= o"62";
        ELSIF (pixel_column_s < 1272  AND pixel_column_s >= 1264) THEN char_addr_s <= o"64";
        ELSE                                                           char_addr_s <= o"40";
        END IF;

      ELSE
        char_addr_s <= o"40";
      END IF;
    END PROCESS addr_gen;

  END GENERATE g5;


  -- odredjivanje velicine fonta

  font_row_s <= pixel_row_s(2 DOWNTO 0);
  font_col_s <= pixel_column_s(2 DOWNTO 0);

-- povezivanje na izlaz

  RED0    <= red_out_s(0);   -- R0
  RED1    <= red_out_s(1);   -- R1
  RED2    <= red_out_s(2);   -- R2
  RED3    <= red_out_s(3);   -- R3
  RED4    <= red_out_s(4);   -- R4
  RED5    <= red_out_s(5);   -- R5
  RED6    <= red_out_s(6);   -- R6
  RED7    <= red_out_s(7);   -- R7

  GREEN0  <= green_out_s(0); -- G0
  GREEN1  <= green_out_s(1); -- G1
  GREEN2  <= green_out_s(2); -- G2
  GREEN3  <= green_out_s(3); -- G3
  GREEN4  <= green_out_s(4); -- G4
  GREEN5  <= green_out_s(5); -- G5
  GREEN6  <= green_out_s(6); -- G6
  GREEN7  <= green_out_s(7); -- G7

  BLUE0   <= blue_out_s(0);  -- B0
  BLUE1   <= blue_out_s(1);  -- B1
  BLUE2   <= blue_out_s(2);  -- B2
  BLUE3   <= blue_out_s(3);  -- B3
  BLUE4   <= blue_out_s(4);  -- B4
  BLUE5   <= blue_out_s(5);  -- B5
  BLUE6   <= blue_out_s(6);  -- B6
  BLUE7   <= blue_out_s(7);  -- B7

  PIX_CLOCK <= pix_clk_s;

END rtl;



























