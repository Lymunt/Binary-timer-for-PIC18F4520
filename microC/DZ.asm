
_to_binary:

;DZ.c,35 :: 		void to_binary(unsigned char val, char *buffer) {
;DZ.c,36 :: 		int i = 0;
	CLRF        to_binary_i_L0+0 
	CLRF        to_binary_i_L0+1 
;DZ.c,37 :: 		for ( i = 7; i >= 0; i--) {
	MOVLW       7
	MOVWF       to_binary_i_L0+0 
	MOVLW       0
	MOVWF       to_binary_i_L0+1 
L_to_binary0:
	MOVLW       128
	XORWF       to_binary_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__to_binary42
	MOVLW       0
	SUBWF       to_binary_i_L0+0, 0 
L__to_binary42:
	BTFSS       STATUS+0, 0 
	GOTO        L_to_binary1
;DZ.c,38 :: 		buffer[7 - i] = (val & (1 << i)) ? '1' : '0';
	MOVF        to_binary_i_L0+0, 0 
	SUBLW       7
	MOVWF       R0 
	MOVF        to_binary_i_L0+1, 0 
	MOVWF       R1 
	MOVLW       0
	SUBFWB      R1, 1 
	MOVF        R0, 0 
	ADDWF       FARG_to_binary_buffer+0, 0 
	MOVWF       R3 
	MOVF        R1, 0 
	ADDWFC      FARG_to_binary_buffer+1, 0 
	MOVWF       R4 
	MOVF        to_binary_i_L0+0, 0 
	MOVWF       R2 
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__to_binary43:
	BZ          L__to_binary44
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__to_binary43
L__to_binary44:
	MOVF        FARG_to_binary_val+0, 0 
	ANDWF       R0, 1 
	MOVLW       0
	ANDWF       R1, 1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_to_binary3
	MOVLW       49
	MOVWF       R5 
	GOTO        L_to_binary4
L_to_binary3:
	MOVLW       48
	MOVWF       R5 
L_to_binary4:
	MOVFF       R3, FSR1L+0
	MOVFF       R4, FSR1H+0
	MOVF        R5, 0 
	MOVWF       POSTINC1+0 
;DZ.c,37 :: 		for ( i = 7; i >= 0; i--) {
	MOVLW       1
	SUBWF       to_binary_i_L0+0, 1 
	MOVLW       0
	SUBWFB      to_binary_i_L0+1, 1 
;DZ.c,39 :: 		}
	GOTO        L_to_binary0
L_to_binary1:
;DZ.c,40 :: 		buffer[8] = '\0';
	MOVLW       8
	ADDWF       FARG_to_binary_buffer+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_to_binary_buffer+1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
;DZ.c,41 :: 		}
L_end_to_binary:
	RETURN      0
; end of _to_binary

_pulse_e:

;DZ.c,43 :: 		void pulse_e() {
;DZ.c,44 :: 		LCD_EN = 1;
	BSF         LATB5_bit+0, BitPos(LATB5_bit+0) 
;DZ.c,45 :: 		Delay_us(1);
	NOP
	NOP
;DZ.c,46 :: 		LCD_EN = 0;
	BCF         LATB5_bit+0, BitPos(LATB5_bit+0) 
;DZ.c,47 :: 		Delay_us(40);
	MOVLW       33
	MOVWF       R13, 0
L_pulse_e5:
	DECFSZ      R13, 1, 1
	BRA         L_pulse_e5
;DZ.c,49 :: 		}
L_end_pulse_e:
	RETURN      0
; end of _pulse_e

_lcd_cmd_4:

;DZ.c,51 :: 		void lcd_cmd_4(unsigned char cmd){
;DZ.c,52 :: 		LCD_D4 = (cmd >> 0) & 1;
	MOVLW       1
	ANDWF       FARG_lcd_cmd_4_cmd+0, 0 
	MOVWF       R0 
	BTFSC       R0, 0 
	GOTO        L__lcd_cmd_447
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__lcd_cmd_448
L__lcd_cmd_447:
	BSF         LATD4_bit+0, BitPos(LATD4_bit+0) 
L__lcd_cmd_448:
;DZ.c,53 :: 		LCD_D5 = (cmd >> 1) & 1;
	MOVF        FARG_lcd_cmd_4_cmd+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       1
	ANDWF       R0, 1 
	BTFSC       R0, 0 
	GOTO        L__lcd_cmd_449
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__lcd_cmd_450
L__lcd_cmd_449:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__lcd_cmd_450:
;DZ.c,54 :: 		LCD_D6 = (cmd >> 2) & 1;
	MOVF        FARG_lcd_cmd_4_cmd+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       1
	ANDWF       R0, 1 
	BTFSC       R0, 0 
	GOTO        L__lcd_cmd_451
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
	GOTO        L__lcd_cmd_452
L__lcd_cmd_451:
	BSF         LATD6_bit+0, BitPos(LATD6_bit+0) 
L__lcd_cmd_452:
;DZ.c,55 :: 		LCD_D7 = (cmd >> 3) & 1;
	MOVF        FARG_lcd_cmd_4_cmd+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       1
	ANDWF       R0, 1 
	BTFSC       R0, 0 
	GOTO        L__lcd_cmd_453
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
	GOTO        L__lcd_cmd_454
L__lcd_cmd_453:
	BSF         LATD7_bit+0, BitPos(LATD7_bit+0) 
L__lcd_cmd_454:
;DZ.c,56 :: 		}
L_end_lcd_cmd_4:
	RETURN      0
; end of _lcd_cmd_4

_lcd_cmd_my:

;DZ.c,58 :: 		void lcd_cmd_my(unsigned char cmd){
;DZ.c,59 :: 		LCD_RS = 0;
	BCF         LATB2_bit+0, BitPos(LATB2_bit+0) 
;DZ.c,60 :: 		lcd_cmd_4(cmd >> 4);
	MOVF        FARG_lcd_cmd_my_cmd+0, 0 
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	RRCF        FARG_lcd_cmd_4_cmd+0, 1 
	BCF         FARG_lcd_cmd_4_cmd+0, 7 
	RRCF        FARG_lcd_cmd_4_cmd+0, 1 
	BCF         FARG_lcd_cmd_4_cmd+0, 7 
	RRCF        FARG_lcd_cmd_4_cmd+0, 1 
	BCF         FARG_lcd_cmd_4_cmd+0, 7 
	RRCF        FARG_lcd_cmd_4_cmd+0, 1 
	BCF         FARG_lcd_cmd_4_cmd+0, 7 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,61 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,62 :: 		lcd_cmd_4(cmd & 0x0F);
	MOVLW       15
	ANDWF       FARG_lcd_cmd_my_cmd+0, 0 
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,63 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,64 :: 		}
L_end_lcd_cmd_my:
	RETURN      0
; end of _lcd_cmd_my

_lcd_char_my:

;DZ.c,66 :: 		void lcd_char_my(unsigned char row, unsigned char column, unsigned char cmd){
;DZ.c,70 :: 		if (row == 1)
	MOVF        FARG_lcd_char_my_row+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_lcd_char_my6
;DZ.c,71 :: 		adress = 0x80 + (column - 1);
	DECF        FARG_lcd_char_my_column+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDLW       128
	MOVWF       lcd_char_my_adress_L0+0 
	GOTO        L_lcd_char_my7
L_lcd_char_my6:
;DZ.c,72 :: 		else if (row == 2)
	MOVF        FARG_lcd_char_my_row+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_lcd_char_my8
;DZ.c,73 :: 		adress = 0xC0 + (column - 1);
	DECF        FARG_lcd_char_my_column+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDLW       192
	MOVWF       lcd_char_my_adress_L0+0 
L_lcd_char_my8:
L_lcd_char_my7:
;DZ.c,75 :: 		lcd_cmd_my(adress);
	MOVF        lcd_char_my_adress_L0+0, 0 
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,77 :: 		LCD_RS = 1;
	BSF         LATB2_bit+0, BitPos(LATB2_bit+0) 
;DZ.c,78 :: 		lcd_cmd_4(cmd >> 4);
	MOVF        FARG_lcd_char_my_cmd+0, 0 
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	RRCF        FARG_lcd_cmd_4_cmd+0, 1 
	BCF         FARG_lcd_cmd_4_cmd+0, 7 
	RRCF        FARG_lcd_cmd_4_cmd+0, 1 
	BCF         FARG_lcd_cmd_4_cmd+0, 7 
	RRCF        FARG_lcd_cmd_4_cmd+0, 1 
	BCF         FARG_lcd_cmd_4_cmd+0, 7 
	RRCF        FARG_lcd_cmd_4_cmd+0, 1 
	BCF         FARG_lcd_cmd_4_cmd+0, 7 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,79 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,80 :: 		lcd_cmd_4(cmd & 0x0F);
	MOVLW       15
	ANDWF       FARG_lcd_char_my_cmd+0, 0 
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,81 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,82 :: 		}
L_end_lcd_char_my:
	RETURN      0
; end of _lcd_char_my

_lcd_init_r:

;DZ.c,84 :: 		void lcd_init_r(){
;DZ.c,86 :: 		lcd_cmd_4(0x03);
	MOVLW       3
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,88 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,90 :: 		Delay_us(40);
	MOVLW       33
	MOVWF       R13, 0
L_lcd_init_r9:
	DECFSZ      R13, 1, 1
	BRA         L_lcd_init_r9
;DZ.c,91 :: 		}
L_end_lcd_init_r:
	RETURN      0
; end of _lcd_init_r

_lcd_init_all:

;DZ.c,93 :: 		void lcd_init_all(){
;DZ.c,95 :: 		Delay_ms(20);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_lcd_init_all10:
	DECFSZ      R13, 1, 1
	BRA         L_lcd_init_all10
	DECFSZ      R12, 1, 1
	BRA         L_lcd_init_all10
	NOP
;DZ.c,97 :: 		lcd_init_r();
	CALL        _lcd_init_r+0, 0
;DZ.c,99 :: 		lcd_init_r();
	CALL        _lcd_init_r+0, 0
;DZ.c,101 :: 		lcd_init_r();
	CALL        _lcd_init_r+0, 0
;DZ.c,103 :: 		lcd_cmd_4(0x02);
	MOVLW       2
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,104 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,106 :: 		lcd_cmd_my(0x28);
	MOVLW       40
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,108 :: 		lcd_cmd_my(0x0C);
	MOVLW       12
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,110 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,112 :: 		lcd_cmd_my(0x06);
	MOVLW       6
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,113 :: 		}
L_end_lcd_init_all:
	RETURN      0
; end of _lcd_init_all

_check_rows:

;DZ.c,115 :: 		unsigned char check_rows(){
;DZ.c,116 :: 		unsigned char row_result = 0;
	CLRF        check_rows_row_result_L0+0 
;DZ.c,118 :: 		if(ROW_0 == 1){
	BTFSS       RA4_bit+0, BitPos(RA4_bit+0) 
	GOTO        L_check_rows11
;DZ.c,119 :: 		row_result = 0x10;
	MOVLW       16
	MOVWF       check_rows_row_result_L0+0 
;DZ.c,120 :: 		return row_result;
	MOVLW       16
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,121 :: 		}
L_check_rows11:
;DZ.c,122 :: 		if(ROW_1 == 1){
	BTFSS       RA5_bit+0, BitPos(RA5_bit+0) 
	GOTO        L_check_rows12
;DZ.c,123 :: 		row_result = 0x14;
	MOVLW       20
	MOVWF       check_rows_row_result_L0+0 
;DZ.c,124 :: 		return row_result;
	MOVLW       20
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,125 :: 		}
L_check_rows12:
;DZ.c,126 :: 		if(ROW_2 == 1){
	BTFSS       RA6_bit+0, BitPos(RA6_bit+0) 
	GOTO        L_check_rows13
;DZ.c,127 :: 		row_result = 0x18;
	MOVLW       24
	MOVWF       check_rows_row_result_L0+0 
;DZ.c,128 :: 		return row_result;
	MOVLW       24
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,129 :: 		}
L_check_rows13:
;DZ.c,130 :: 		if(ROW_3 == 1){
	BTFSS       RA7_bit+0, BitPos(RA7_bit+0) 
	GOTO        L_check_rows14
;DZ.c,131 :: 		row_result = 0x1C;
	MOVLW       28
	MOVWF       check_rows_row_result_L0+0 
;DZ.c,132 :: 		return row_result;
	MOVLW       28
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,133 :: 		}
L_check_rows14:
;DZ.c,134 :: 		return row_result;
	MOVF        check_rows_row_result_L0+0, 0 
	MOVWF       R0 
;DZ.c,135 :: 		}
L_end_check_rows:
	RETURN      0
; end of _check_rows

_check_keyboard:

;DZ.c,137 :: 		unsigned char check_keyboard(){
;DZ.c,138 :: 		unsigned char keyboard_result = 0;
	CLRF        check_keyboard_keyboard_result_L0+0 
	CLRF        check_keyboard_row_result_L0+0 
;DZ.c,143 :: 		COL_0 = 1;
	BSF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;DZ.c,144 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,145 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard15
;DZ.c,146 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_check_keyboard16:
	DECFSZ      R13, 1, 1
	BRA         L_check_keyboard16
	DECFSZ      R12, 1, 1
	BRA         L_check_keyboard16
	DECFSZ      R11, 1, 1
	BRA         L_check_keyboard16
	NOP
	NOP
;DZ.c,147 :: 		keyboard_result = 0x00+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	MOVWF       check_keyboard_keyboard_result_L0+0 
;DZ.c,149 :: 		return keyboard_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_check_keyboard
;DZ.c,150 :: 		}
L_check_keyboard15:
;DZ.c,151 :: 		COL_0 = 0;
	BCF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;DZ.c,153 :: 		COL_1 = 1;
	BSF         LATA1_bit+0, BitPos(LATA1_bit+0) 
;DZ.c,154 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,155 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard17
;DZ.c,156 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_check_keyboard18:
	DECFSZ      R13, 1, 1
	BRA         L_check_keyboard18
	DECFSZ      R12, 1, 1
	BRA         L_check_keyboard18
	DECFSZ      R11, 1, 1
	BRA         L_check_keyboard18
	NOP
	NOP
;DZ.c,157 :: 		keyboard_result = 0x01+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       check_keyboard_keyboard_result_L0+0 
;DZ.c,159 :: 		return keyboard_result;
	GOTO        L_end_check_keyboard
;DZ.c,160 :: 		}
L_check_keyboard17:
;DZ.c,161 :: 		COL_1 = 0;
	BCF         LATA1_bit+0, BitPos(LATA1_bit+0) 
;DZ.c,163 :: 		COL_2 = 1;
	BSF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;DZ.c,164 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,165 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard19
;DZ.c,166 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_check_keyboard20:
	DECFSZ      R13, 1, 1
	BRA         L_check_keyboard20
	DECFSZ      R12, 1, 1
	BRA         L_check_keyboard20
	DECFSZ      R11, 1, 1
	BRA         L_check_keyboard20
	NOP
	NOP
;DZ.c,167 :: 		keyboard_result = 0x02+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	ADDLW       2
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       check_keyboard_keyboard_result_L0+0 
;DZ.c,169 :: 		return keyboard_result;
	GOTO        L_end_check_keyboard
;DZ.c,170 :: 		}
L_check_keyboard19:
;DZ.c,171 :: 		COL_2 = 0;
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;DZ.c,173 :: 		COL_3 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;DZ.c,174 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,175 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard21
;DZ.c,176 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_check_keyboard22:
	DECFSZ      R13, 1, 1
	BRA         L_check_keyboard22
	DECFSZ      R12, 1, 1
	BRA         L_check_keyboard22
	DECFSZ      R11, 1, 1
	BRA         L_check_keyboard22
	NOP
	NOP
;DZ.c,177 :: 		keyboard_result = 0x03+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	ADDLW       3
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       check_keyboard_keyboard_result_L0+0 
;DZ.c,179 :: 		return keyboard_result;
	GOTO        L_end_check_keyboard
;DZ.c,180 :: 		}
L_check_keyboard21:
;DZ.c,181 :: 		COL_3 = 0;
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;DZ.c,183 :: 		return keyboard_result;
	MOVF        check_keyboard_keyboard_result_L0+0, 0 
	MOVWF       R0 
;DZ.c,184 :: 		}
L_end_check_keyboard:
	RETURN      0
; end of _check_keyboard

_main:

;DZ.c,186 :: 		void main() {
;DZ.c,187 :: 		unsigned char count = 0;
	CLRF        main_count_L0+0 
	CLRF        main_i_L0+0 
	MOVLW       1
	MOVWF       main_j_L0+0 
	CLRF        main_k_L0+0 
	CLRF        main_input_value_L0+0 
	CLRF        main_keyboard_result_L0+0 
;DZ.c,195 :: 		ADCON1 = 0x0F;
	MOVLW       15
	MOVWF       ADCON1+0 
;DZ.c,197 :: 		LCD_RS_Direction =0;
	BCF         TRISB2_bit+0, BitPos(TRISB2_bit+0) 
;DZ.c,198 :: 		LCD_EN_Direction =0;
	BCF         TRISB5_bit+0, BitPos(TRISB5_bit+0) 
;DZ.c,199 :: 		LCD_D4_Direction =0;
	BCF         TRISD4_bit+0, BitPos(TRISD4_bit+0) 
;DZ.c,200 :: 		LCD_D5_Direction =0;
	BCF         TRISD5_bit+0, BitPos(TRISD5_bit+0) 
;DZ.c,201 :: 		LCD_D6_Direction =0;
	BCF         TRISD6_bit+0, BitPos(TRISD6_bit+0) 
;DZ.c,202 :: 		LCD_D7_Direction =0;
	BCF         TRISD7_bit+0, BitPos(TRISD7_bit+0) 
;DZ.c,204 :: 		COL_0_Direction =0;
	BCF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;DZ.c,205 :: 		COL_1_Direction =0;
	BCF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
;DZ.c,206 :: 		COL_2_Direction =0;
	BCF         TRISA2_bit+0, BitPos(TRISA2_bit+0) 
;DZ.c,207 :: 		COL_3_Direction =0;
	BCF         TRISA3_bit+0, BitPos(TRISA3_bit+0) 
;DZ.c,209 :: 		ROW_0_Direction =1;
	BSF         TRISA4_bit+0, BitPos(TRISA4_bit+0) 
;DZ.c,210 :: 		ROW_1_Direction =1;
	BSF         TRISA5_bit+0, BitPos(TRISA5_bit+0) 
;DZ.c,211 :: 		ROW_2_Direction =1;
	BSF         TRISA6_bit+0, BitPos(TRISA6_bit+0) 
;DZ.c,212 :: 		ROW_3_Direction =1;
	BSF         TRISA7_bit+0, BitPos(TRISA7_bit+0) 
;DZ.c,214 :: 		lcd_init_all();
	CALL        _lcd_init_all+0, 0
;DZ.c,216 :: 		Delay_ms(10);
	MOVLW       33
	MOVWF       R12, 0
	MOVLW       118
	MOVWF       R13, 0
L_main23:
	DECFSZ      R13, 1, 1
	BRA         L_main23
	DECFSZ      R12, 1, 1
	BRA         L_main23
	NOP
;DZ.c,218 :: 		lcd_char_my(1,j,'S');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       83
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,219 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,220 :: 		lcd_char_my(1,j,'E');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,221 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,222 :: 		lcd_char_my(1,j,'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,223 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,224 :: 		lcd_char_my(1,j,':');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       58
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,225 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,226 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,228 :: 		j=1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,230 :: 		while (keyboard_result !=0x12) {
L_main24:
	MOVF        main_keyboard_result_L0+0, 0 
	XORLW       18
	BTFSC       STATUS+0, 2 
	GOTO        L_main25
;DZ.c,231 :: 		lcd_char_my(1, 6, k);
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       6
	MOVWF       FARG_lcd_char_my_column+0 
	MOVF        main_k_L0+0, 0 
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,232 :: 		k++;
	INCF        main_k_L0+0, 1 
;DZ.c,234 :: 		keyboard_result = check_keyboard();
	CALL        _check_keyboard+0, 0
	MOVF        R0, 0 
	MOVWF       main_keyboard_result_L0+0 
;DZ.c,236 :: 		if (keyboard_result == 0x10) {
	MOVF        R0, 0 
	XORLW       16
	BTFSS       STATUS+0, 2 
	GOTO        L_main26
;DZ.c,237 :: 		input_value <<= 1;
	RLCF        main_input_value_L0+0, 1 
	BCF         main_input_value_L0+0, 0 
;DZ.c,238 :: 		}
L_main26:
;DZ.c,239 :: 		if (keyboard_result == 0x11) {
	MOVF        main_keyboard_result_L0+0, 0 
	XORLW       17
	BTFSS       STATUS+0, 2 
	GOTO        L_main27
;DZ.c,240 :: 		input_value = (input_value << 1) | 1;
	RLCF        main_input_value_L0+0, 1 
	BCF         main_input_value_L0+0, 0 
	BSF         main_input_value_L0+0, 0 
;DZ.c,241 :: 		}
L_main27:
;DZ.c,242 :: 		if (keyboard_result == 0x12) {
	MOVF        main_keyboard_result_L0+0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_main28
;DZ.c,243 :: 		count = input_value;
	MOVF        main_input_value_L0+0, 0 
	MOVWF       main_count_L0+0 
;DZ.c,244 :: 		lcd_char_my(1, j, 'S');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       83
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,245 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,246 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,247 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,248 :: 		lcd_char_my(1, j, 'A');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       65
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,249 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,250 :: 		lcd_char_my(1, j, 'R');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,251 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,252 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,253 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,254 :: 		lcd_char_my(1, j, 'I');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,255 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,256 :: 		lcd_char_my(1, j, 'N');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,257 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,258 :: 		lcd_char_my(1, j, 'G');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       71
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,259 :: 		Delay_ms(2000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_main29:
	DECFSZ      R13, 1, 1
	BRA         L_main29
	DECFSZ      R12, 1, 1
	BRA         L_main29
	DECFSZ      R11, 1, 1
	BRA         L_main29
	NOP
;DZ.c,260 :: 		}
L_main28:
;DZ.c,262 :: 		to_binary(input_value, bin_str);
	MOVF        main_input_value_L0+0, 0 
	MOVWF       FARG_to_binary_val+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FARG_to_binary_buffer+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FARG_to_binary_buffer+1 
	CALL        _to_binary+0, 0
;DZ.c,263 :: 		for (i = 0; i < 8; i++) {
	CLRF        main_i_L0+0 
L_main30:
	MOVLW       8
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main31
;DZ.c,264 :: 		lcd_char_my(2, i + 1, bin_str[i]);
	MOVLW       2
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FSR0L+1 
	MOVF        main_i_L0+0, 0 
	ADDWF       FSR0L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0L+1, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,263 :: 		for (i = 0; i < 8; i++) {
	INCF        main_i_L0+0, 1 
;DZ.c,265 :: 		}
	GOTO        L_main30
L_main31:
;DZ.c,266 :: 		}
	GOTO        L_main24
L_main25:
;DZ.c,268 :: 		count = input_value;
	MOVF        main_input_value_L0+0, 0 
	MOVWF       main_count_L0+0 
;DZ.c,270 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,272 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       69
	MOVWF       R12, 0
	MOVLW       169
	MOVWF       R13, 0
L_main33:
	DECFSZ      R13, 1, 1
	BRA         L_main33
	DECFSZ      R12, 1, 1
	BRA         L_main33
	DECFSZ      R11, 1, 1
	BRA         L_main33
	NOP
	NOP
;DZ.c,274 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,275 :: 		lcd_char_my(1, j, 'B');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       66
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,276 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,277 :: 		lcd_char_my(1, j, 'I');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,278 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,279 :: 		lcd_char_my(1, j, 'N');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,280 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,281 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,282 :: 		lcd_char_my(1, j, 'C');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       67
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,283 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,284 :: 		lcd_char_my(1, j, 'O');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       79
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,285 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,286 :: 		lcd_char_my(1, j, 'U');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       85
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,287 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,288 :: 		lcd_char_my(1, j, 'N');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,289 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,290 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,291 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,292 :: 		lcd_char_my(1, j, 'E');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,293 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,294 :: 		lcd_char_my(1, j, 'R');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,296 :: 		while (1) {
L_main34:
;DZ.c,297 :: 		Delay_ms(1000);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_main36:
	DECFSZ      R13, 1, 1
	BRA         L_main36
	DECFSZ      R12, 1, 1
	BRA         L_main36
	DECFSZ      R11, 1, 1
	BRA         L_main36
	NOP
;DZ.c,298 :: 		count++;
	INCF        main_count_L0+0, 1 
;DZ.c,299 :: 		if (count > 255) count = 0;
	MOVF        main_count_L0+0, 0 
	SUBLW       255
	BTFSC       STATUS+0, 0 
	GOTO        L_main37
	CLRF        main_count_L0+0 
L_main37:
;DZ.c,301 :: 		to_binary(count, bin_str);
	MOVF        main_count_L0+0, 0 
	MOVWF       FARG_to_binary_val+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FARG_to_binary_buffer+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FARG_to_binary_buffer+1 
	CALL        _to_binary+0, 0
;DZ.c,303 :: 		for (i = 0; i < 8; i++) {
	CLRF        main_i_L0+0 
L_main38:
	MOVLW       8
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main39
;DZ.c,304 :: 		lcd_char_my(2, i + 2, bin_str[i]);
	MOVLW       2
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       2
	ADDWF       main_i_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FSR0L+1 
	MOVF        main_i_L0+0, 0 
	ADDWF       FSR0L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0L+1, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,303 :: 		for (i = 0; i < 8; i++) {
	INCF        main_i_L0+0, 1 
;DZ.c,305 :: 		}
	GOTO        L_main38
L_main39:
;DZ.c,310 :: 		}
	GOTO        L_main34
;DZ.c,311 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
