--Islemci tasarimi
--388858 
--Kenan Ismayil

Library IEEE;
Use IEEE.std_logic_1164.all;
Use IEEE.Numeric_std.all;
--Use IEEE.std_logic_unsigned .all;
--Use IEEE.std_logic_arith.all;


Entity eIslemci is
Generic(n : natural:=8);
Port	(s,r : in std_logic;         --reset
	 kmt : in std_logic_vector(2*n-1 downto 0));  --16 bit secme girisi
End eIslemci;

Architecture struct of eIslemci is


TYPE tMem is array(0 to 31) of std_logic_vector(n-1 downto 0);
signal Ram : tMem;   --Ram

TYPE tREG is array(0 to 15) of std_logic_vector(n-1 downto 0);
signal Reg :tREG; 

Begin --mimari

Komut:
Process(s,r)
Begin
	If(s'event and s='1') then
	Case kmt(15 downto 12) is    --en anlamli 4 bit
		When "0000" =>
		null;     --islemcinin beklemesi(nop)
		
		--loadx	  0001    4bitRegadresi   8bit sabit deger
		When "0001" =>
		Reg(to_integer(unsigned(kmt(11 downto 8))))<=kmt(7 downto 0);

		--loadr   0010    4bitRegadresi   4bitRegadresiKaynak   loadr ax,bx  ax<=bx
		When "0010" =>
		Reg(to_integer(unsigned(kmt(11 downto 8))))<=Reg(to_integer(unsigned(kmt(7 downto 4))));
		
		--Registerdeki bilgiyi bellege yaz
		--Storer 0011  4bitRegadresi 8bitRamadresi
		When "0011" =>
		Ram(to_integer(unsigned(kmt(7 downto 4))))<=Reg(to_integer(unsigned(kmt(11 downto 8))));


		--NAND  0100  4bitRegadresi  8bit sabit sayi
		--nand   ax,x   ax x ile nand mantiksal operatoru kullan sonuc ax'e yaz			
		When "0100" =>
		Reg(4)<="00000000";
		Reg(to_integer(unsigned(kmt(11 downto 8)))) <=
			std_logic_vector(
			unsigned(Reg(to_integer(unsigned(kmt(11 downto 8)))))
			nand unsigned(kmt(7 downto 0)));


		--loadmr  0101    4bitRegadresi   4bitRegadresi
		When "0101" =>
		Reg(to_integer(unsigned(kmt(11 downto 8))))<=
			Ram(to_integer(unsigned(Reg(to_integer(unsigned(kmt(7 downto 4)))) )));

		--loadm   0110    4bitRegadresi   4bitRamadresi
		When "0110" =>
		Ram(0)<="01010101";
		Reg(to_integer(unsigned(kmt(11 downto 8))))<=Ram(to_integer(unsigned(kmt(7 downto 4))));
		

		
		--ADDx  0111  4bitRegadresi  8bit sabit sayi
		--add,ax,x   x sabit sayi ile ax toplanir ve sonuc ax'e yazilir
		When "0111" =>
		Reg(to_integer(unsigned(kmt(11 downto 8)))) <=
			std_logic_vector(
			unsigned(Reg(to_integer(unsigned(kmt(11 downto 8)))))
			+ unsigned(kmt(7 downto 0)));
		
		--ADDr  1000  4bitRegadresi  4bitRegadresi  4bitRegadresi
		--addr   ax,bx,cx   cx bx ile toplanir sonuc ax'e yazilir
		When "1000" =>
		Reg(to_integer(unsigned(kmt(11 downto 8))))<=std_logic_vector
			(unsigned(Reg(to_integer(unsigned(kmt(7 downto 4)))))
			+ unsigned(Reg(to_integer(unsigned(kmt(3 downto 0))))) );

		
		--SUBr  1001  4bitRegadresi  4bitRegadresi   4bitRegadresi
		--sub   ax,x   ax'ten bx sabit sayi cikarilir ve sonuc cx'e yazilir
		When "1001" =>
		Reg(to_integer(unsigned(kmt(11 downto 8))))<=std_logic_vector
			(unsigned(Reg(to_integer(unsigned(kmt(7 downto 4)))))
			-unsigned(Reg(to_integer(unsigned(kmt(3 downto 0))))) );

		
		--Leftr  4bitRegadresi 8bitsabitsayi & '0'
		When "1010" =>
		Reg(to_integer(unsigned(kmt(11 downto 8))))<=kmt(6 downto 0) & '0';


		--AND  1011  4bitRegadresi  4bitRegadresi  4bitRegadresi
		--and   ax,bx,cx   cx bx ile and mantiksal operatoru kullan sonuc ax'e yaz			
		When "1011" =>
		Reg(to_integer(unsigned(kmt(11 downto 8))))<=std_logic_vector
			(unsigned(Reg(to_integer(unsigned(kmt(7 downto 4)))))
			and unsigned(Reg(to_integer(unsigned(kmt(3 downto 0))))) );

		--OR  1100  4bitRegadresi  4bitRegadresi  4bitRegadresi
		--or   ax,bx,cx   cx bx ile or mantiksal operatoru kullan sonuc ax'e yaz			
		When "1100" =>
		Reg(to_integer(unsigned(kmt(11 downto 8))))<=std_logic_vector
			(unsigned(Reg(to_integer(unsigned(kmt(7 downto 4)))))
			or unsigned(Reg(to_integer(unsigned(kmt(3 downto 0))))) );

		--Shiftr  4bitRegadresi '0'  &  8bitsabitsayi 
		When "1101" =>
		Reg(to_integer(unsigned(kmt(11 downto 8))))<='0' & kmt(7 downto 1);


		--Rotation(cevirme)  4bitRegadresi 8bitsabitsayi
		When "1110" =>
		Reg(to_integer(unsigned(kmt(11 downto 8))))<= kmt(6 downto 0) & kmt(7);



		--THE END :)

		When others=>
		null;
	End Case;
	End If;
End Process;
End struct;	

