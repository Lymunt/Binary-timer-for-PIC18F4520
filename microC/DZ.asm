
_interrupt:

;DZ.c,46 :: 		void interrupt() {
;DZ.c,47 :: 		if (PIR1.RCIF == 1){
	BTFSS       PIR1+0, 5 
	GOTO        L_interrupt0
;DZ.c,48 :: 		uart_ready++;
	INCF        _uart_ready+0, 1 
;DZ.c,49 :: 		second_input =  RCREG;
	MOVF        RCREG+0, 0 
	MOVWF       _second_input+0 
;DZ.c,50 :: 		}
L_interrupt0:
;DZ.c,51 :: 		}
L_end_interrupt:
L__interrupt64:
	RETFIE      1
; end of _interrupt

_to_binary:

;DZ.c,53 :: 		void to_binary(unsigned char val, char *buffer) {
;DZ.c,54 :: 		int i = 0;
	CLRF        to_binary_i_L0+0 
	CLRF        to_binary_i_L0+1 
;DZ.c,55 :: 		for ( i = 7; i >= 0; i--) {
	MOVLW       7
	MOVWF       to_binary_i_L0+0 
	MOVLW       0
	MOVWF       to_binary_i_L0+1 
L_to_binary1:
	MOVLW       128
	XORWF       to_binary_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__to_binary66
	MOVLW       0
	SUBWF       to_binary_i_L0+0, 0 
L__to_binary66:
	BTFSS       STATUS+0, 0 
	GOTO        L_to_binary2
;DZ.c,56 :: 		buffer[7 - i] = (val & (1 << i)) ? '1' : '0';
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
L__to_binary67:
	BZ          L__to_binary68
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__to_binary67
L__to_binary68:
	MOVF        FARG_to_binary_val+0, 0 
	ANDWF       R0, 1 
	MOVLW       0
	ANDWF       R1, 1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_to_binary4
	MOVLW       49
	MOVWF       R5 
	GOTO        L_to_binary5
L_to_binary4:
	MOVLW       48
	MOVWF       R5 
L_to_binary5:
	MOVFF       R3, FSR1L+0
	MOVFF       R4, FSR1H+0
	MOVF        R5, 0 
	MOVWF       POSTINC1+0 
;DZ.c,55 :: 		for ( i = 7; i >= 0; i--) {
	MOVLW       1
	SUBWF       to_binary_i_L0+0, 1 
	MOVLW       0
	SUBWFB      to_binary_i_L0+1, 1 
;DZ.c,57 :: 		}
	GOTO        L_to_binary1
L_to_binary2:
;DZ.c,58 :: 		buffer[8] = '\0';
	MOVLW       8
	ADDWF       FARG_to_binary_buffer+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_to_binary_buffer+1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
;DZ.c,59 :: 		}
L_end_to_binary:
	RETURN      0
; end of _to_binary

_pulse_e:

;DZ.c,61 :: 		void pulse_e() {
;DZ.c,62 :: 		LCD_EN = 1;
	BSF         LATB5_bit+0, BitPos(LATB5_bit+0) 
;DZ.c,63 :: 		Delay_us(1);
	NOP
	NOP
;DZ.c,64 :: 		LCD_EN = 0;
	BCF         LATB5_bit+0, BitPos(LATB5_bit+0) 
;DZ.c,65 :: 		Delay_us(40);
	MOVLW       33
	MOVWF       R13, 0
L_pulse_e6:
	DECFSZ      R13, 1, 1
	BRA         L_pulse_e6
;DZ.c,67 :: 		}
L_end_pulse_e:
	RETURN      0
; end of _pulse_e

_lcd_cmd_4:

;DZ.c,69 :: 		void lcd_cmd_4(unsigned char cmd){
;DZ.c,70 :: 		LCD_D4 = (cmd >> 0) & 1;
	MOVLW       1
	ANDWF       FARG_lcd_cmd_4_cmd+0, 0 
	MOVWF       R0 
	BTFSC       R0, 0 
	GOTO        L__lcd_cmd_471
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__lcd_cmd_472
L__lcd_cmd_471:
	BSF         LATD4_bit+0, BitPos(LATD4_bit+0) 
L__lcd_cmd_472:
;DZ.c,71 :: 		LCD_D5 = (cmd >> 1) & 1;
	MOVF        FARG_lcd_cmd_4_cmd+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       1
	ANDWF       R0, 1 
	BTFSC       R0, 0 
	GOTO        L__lcd_cmd_473
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__lcd_cmd_474
L__lcd_cmd_473:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__lcd_cmd_474:
;DZ.c,72 :: 		LCD_D6 = (cmd >> 2) & 1;
	MOVF        FARG_lcd_cmd_4_cmd+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       1
	ANDWF       R0, 1 
	BTFSC       R0, 0 
	GOTO        L__lcd_cmd_475
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
	GOTO        L__lcd_cmd_476
L__lcd_cmd_475:
	BSF         LATD6_bit+0, BitPos(LATD6_bit+0) 
L__lcd_cmd_476:
;DZ.c,73 :: 		LCD_D7 = (cmd >> 3) & 1;
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
	GOTO        L__lcd_cmd_477
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
	GOTO        L__lcd_cmd_478
L__lcd_cmd_477:
	BSF         LATD7_bit+0, BitPos(LATD7_bit+0) 
L__lcd_cmd_478:
;DZ.c,74 :: 		}
L_end_lcd_cmd_4:
	RETURN      0
; end of _lcd_cmd_4

_lcd_cmd_my:

;DZ.c,76 :: 		void lcd_cmd_my(unsigned char cmd){
;DZ.c,77 :: 		LCD_RS = 0;
	BCF         LATB2_bit+0, BitPos(LATB2_bit+0) 
;DZ.c,78 :: 		lcd_cmd_4(cmd >> 4);
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
;DZ.c,79 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,80 :: 		lcd_cmd_4(cmd & 0x0F);
	MOVLW       15
	ANDWF       FARG_lcd_cmd_my_cmd+0, 0 
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,81 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,82 :: 		}
L_end_lcd_cmd_my:
	RETURN      0
; end of _lcd_cmd_my

_lcd_char_my:

;DZ.c,84 :: 		void lcd_char_my(unsigned char row, unsigned char column, unsigned char cmd){
;DZ.c,88 :: 		if (row == 1)
	MOVF        FARG_lcd_char_my_row+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_lcd_char_my7
;DZ.c,89 :: 		adress = 0x80 + (column - 1);
	DECF        FARG_lcd_char_my_column+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDLW       128
	MOVWF       lcd_char_my_adress_L0+0 
	GOTO        L_lcd_char_my8
L_lcd_char_my7:
;DZ.c,90 :: 		else if (row == 2)
	MOVF        FARG_lcd_char_my_row+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_lcd_char_my9
;DZ.c,91 :: 		adress = 0xC0 + (column - 1);
	DECF        FARG_lcd_char_my_column+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDLW       192
	MOVWF       lcd_char_my_adress_L0+0 
L_lcd_char_my9:
L_lcd_char_my8:
;DZ.c,93 :: 		lcd_cmd_my(adress);
	MOVF        lcd_char_my_adress_L0+0, 0 
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,95 :: 		LCD_RS = 1;
	BSF         LATB2_bit+0, BitPos(LATB2_bit+0) 
;DZ.c,96 :: 		lcd_cmd_4(cmd >> 4);
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
;DZ.c,97 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,98 :: 		lcd_cmd_4(cmd & 0x0F);
	MOVLW       15
	ANDWF       FARG_lcd_char_my_cmd+0, 0 
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,99 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,100 :: 		}
L_end_lcd_char_my:
	RETURN      0
; end of _lcd_char_my

_lcd_init_r:

;DZ.c,102 :: 		void lcd_init_r(){
;DZ.c,104 :: 		lcd_cmd_4(0x03);
	MOVLW       3
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,106 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,108 :: 		Delay_us(40);
	MOVLW       33
	MOVWF       R13, 0
L_lcd_init_r10:
	DECFSZ      R13, 1, 1
	BRA         L_lcd_init_r10
;DZ.c,109 :: 		}
L_end_lcd_init_r:
	RETURN      0
; end of _lcd_init_r

_lcd_init_all:

;DZ.c,111 :: 		void lcd_init_all(){
;DZ.c,113 :: 		Delay_ms(20);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_lcd_init_all11:
	DECFSZ      R13, 1, 1
	BRA         L_lcd_init_all11
	DECFSZ      R12, 1, 1
	BRA         L_lcd_init_all11
	NOP
;DZ.c,115 :: 		lcd_init_r();
	CALL        _lcd_init_r+0, 0
;DZ.c,117 :: 		lcd_init_r();
	CALL        _lcd_init_r+0, 0
;DZ.c,119 :: 		lcd_init_r();
	CALL        _lcd_init_r+0, 0
;DZ.c,121 :: 		lcd_cmd_4(0x02);
	MOVLW       2
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,122 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,124 :: 		lcd_cmd_my(0x28);
	MOVLW       40
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,126 :: 		lcd_cmd_my(0x0F);
	MOVLW       15
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,128 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,130 :: 		lcd_cmd_my(0x06);
	MOVLW       6
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,131 :: 		}
L_end_lcd_init_all:
	RETURN      0
; end of _lcd_init_all

_check_rows:

;DZ.c,133 :: 		unsigned char check_rows(){
;DZ.c,134 :: 		unsigned char row_result = 0;
	CLRF        check_rows_row_result_L0+0 
;DZ.c,136 :: 		if(ROW_0 == 1){
	BTFSS       RA4_bit+0, BitPos(RA4_bit+0) 
	GOTO        L_check_rows12
;DZ.c,137 :: 		row_result = 0x10;
	MOVLW       16
	MOVWF       check_rows_row_result_L0+0 
;DZ.c,138 :: 		return row_result;
	MOVLW       16
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,139 :: 		}
L_check_rows12:
;DZ.c,140 :: 		if(ROW_1 == 1){
	BTFSS       RA5_bit+0, BitPos(RA5_bit+0) 
	GOTO        L_check_rows13
;DZ.c,141 :: 		row_result = 0x14;
	MOVLW       20
	MOVWF       check_rows_row_result_L0+0 
;DZ.c,142 :: 		return row_result;
	MOVLW       20
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,143 :: 		}
L_check_rows13:
;DZ.c,144 :: 		if(ROW_2 == 1){
	BTFSS       RA6_bit+0, BitPos(RA6_bit+0) 
	GOTO        L_check_rows14
;DZ.c,145 :: 		row_result = 0x18;
	MOVLW       24
	MOVWF       check_rows_row_result_L0+0 
;DZ.c,146 :: 		return row_result;
	MOVLW       24
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,147 :: 		}
L_check_rows14:
;DZ.c,148 :: 		if(ROW_3 == 1){
	BTFSS       RA7_bit+0, BitPos(RA7_bit+0) 
	GOTO        L_check_rows15
;DZ.c,149 :: 		row_result = 0x1C;
	MOVLW       28
	MOVWF       check_rows_row_result_L0+0 
;DZ.c,150 :: 		return row_result;
	MOVLW       28
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,151 :: 		}
L_check_rows15:
;DZ.c,152 :: 		return row_result;
	MOVF        check_rows_row_result_L0+0, 0 
	MOVWF       R0 
;DZ.c,153 :: 		}
L_end_check_rows:
	RETURN      0
; end of _check_rows

_check_keyboard:

;DZ.c,155 :: 		unsigned char check_keyboard(){
;DZ.c,156 :: 		unsigned char keyboard_result = 0;
	CLRF        check_keyboard_keyboard_result_L0+0 
	CLRF        check_keyboard_row_result_L0+0 
;DZ.c,161 :: 		COL_0 = 1;
	BSF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;DZ.c,162 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,163 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard16
;DZ.c,164 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_check_keyboard17:
	DECFSZ      R13, 1, 1
	BRA         L_check_keyboard17
	DECFSZ      R12, 1, 1
	BRA         L_check_keyboard17
	DECFSZ      R11, 1, 1
	BRA         L_check_keyboard17
	NOP
	NOP
;DZ.c,165 :: 		keyboard_result = 0x00+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	MOVWF       check_keyboard_keyboard_result_L0+0 
;DZ.c,167 :: 		return keyboard_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_check_keyboard
;DZ.c,168 :: 		}
L_check_keyboard16:
;DZ.c,169 :: 		COL_0 = 0;
	BCF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;DZ.c,171 :: 		COL_1 = 1;
	BSF         LATA1_bit+0, BitPos(LATA1_bit+0) 
;DZ.c,172 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,173 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard18
;DZ.c,174 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_check_keyboard19:
	DECFSZ      R13, 1, 1
	BRA         L_check_keyboard19
	DECFSZ      R12, 1, 1
	BRA         L_check_keyboard19
	DECFSZ      R11, 1, 1
	BRA         L_check_keyboard19
	NOP
	NOP
;DZ.c,175 :: 		keyboard_result = 0x01+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       check_keyboard_keyboard_result_L0+0 
;DZ.c,177 :: 		return keyboard_result;
	GOTO        L_end_check_keyboard
;DZ.c,178 :: 		}
L_check_keyboard18:
;DZ.c,179 :: 		COL_1 = 0;
	BCF         LATA1_bit+0, BitPos(LATA1_bit+0) 
;DZ.c,181 :: 		COL_2 = 1;
	BSF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;DZ.c,182 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,183 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard20
;DZ.c,184 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_check_keyboard21:
	DECFSZ      R13, 1, 1
	BRA         L_check_keyboard21
	DECFSZ      R12, 1, 1
	BRA         L_check_keyboard21
	DECFSZ      R11, 1, 1
	BRA         L_check_keyboard21
	NOP
	NOP
;DZ.c,185 :: 		keyboard_result = 0x02+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	ADDLW       2
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       check_keyboard_keyboard_result_L0+0 
;DZ.c,187 :: 		return keyboard_result;
	GOTO        L_end_check_keyboard
;DZ.c,188 :: 		}
L_check_keyboard20:
;DZ.c,189 :: 		COL_2 = 0;
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;DZ.c,191 :: 		COL_3 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;DZ.c,192 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,193 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard22
;DZ.c,194 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_check_keyboard23:
	DECFSZ      R13, 1, 1
	BRA         L_check_keyboard23
	DECFSZ      R12, 1, 1
	BRA         L_check_keyboard23
	DECFSZ      R11, 1, 1
	BRA         L_check_keyboard23
	NOP
	NOP
;DZ.c,195 :: 		keyboard_result = 0x03+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	ADDLW       3
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       check_keyboard_keyboard_result_L0+0 
;DZ.c,197 :: 		return keyboard_result;
	GOTO        L_end_check_keyboard
;DZ.c,198 :: 		}
L_check_keyboard22:
;DZ.c,199 :: 		COL_3 = 0;
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;DZ.c,201 :: 		return keyboard_result;
	MOVF        check_keyboard_keyboard_result_L0+0, 0 
	MOVWF       R0 
;DZ.c,202 :: 		}
L_end_check_keyboard:
	RETURN      0
; end of _check_keyboard

_uart_init:

;DZ.c,204 :: 		void uart_init(){
;DZ.c,206 :: 		UART_OUT_Direction = 1;
	BSF         TRISC6_bit+0, BitPos(TRISC6_bit+0) 
;DZ.c,207 :: 		UART_IN_Direction = 1;
	BSF         TRISC7_bit+0, BitPos(TRISC7_bit+0) 
;DZ.c,209 :: 		SPBRG = 15;
	MOVLW       15
	MOVWF       SPBRG+0 
;DZ.c,210 :: 		TXSTA = 0x00;
	CLRF        TXSTA+0 
;DZ.c,211 :: 		RCSTA.SPEN = 1;
	BSF         RCSTA+0, 7 
;DZ.c,212 :: 		RCSTA.CREN = 1;
	BSF         RCSTA+0, 4 
;DZ.c,214 :: 		PIE1.RCIE = 1;
	BSF         PIE1+0, 5 
;DZ.c,216 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;DZ.c,217 :: 		INTCON.GIEL = 1;
	BSF         INTCON+0, 6 
;DZ.c,218 :: 		}
L_end_uart_init:
	RETURN      0
; end of _uart_init

_main:

;DZ.c,220 :: 		void main() {
;DZ.c,221 :: 		unsigned char count = 0;
	CLRF        main_count_L0+0 
	CLRF        main_i_L0+0 
	MOVLW       1
	MOVWF       main_j_L0+0 
	CLRF        main_k_L0+0 
	CLRF        main_input_value_L0+0 
	CLRF        main_keyboard_result_L0+0 
;DZ.c,230 :: 		ADCON1 = 0x0F;
	MOVLW       15
	MOVWF       ADCON1+0 
;DZ.c,232 :: 		LCD_RS_Direction =0;
	BCF         TRISB2_bit+0, BitPos(TRISB2_bit+0) 
;DZ.c,233 :: 		LCD_EN_Direction =0;
	BCF         TRISB5_bit+0, BitPos(TRISB5_bit+0) 
;DZ.c,234 :: 		LCD_D4_Direction =0;
	BCF         TRISD4_bit+0, BitPos(TRISD4_bit+0) 
;DZ.c,235 :: 		LCD_D5_Direction =0;
	BCF         TRISD5_bit+0, BitPos(TRISD5_bit+0) 
;DZ.c,236 :: 		LCD_D6_Direction =0;
	BCF         TRISD6_bit+0, BitPos(TRISD6_bit+0) 
;DZ.c,237 :: 		LCD_D7_Direction =0;
	BCF         TRISD7_bit+0, BitPos(TRISD7_bit+0) 
;DZ.c,239 :: 		COL_0_Direction =0;
	BCF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;DZ.c,240 :: 		COL_1_Direction =0;
	BCF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
;DZ.c,241 :: 		COL_2_Direction =0;
	BCF         TRISA2_bit+0, BitPos(TRISA2_bit+0) 
;DZ.c,242 :: 		COL_3_Direction =0;
	BCF         TRISA3_bit+0, BitPos(TRISA3_bit+0) 
;DZ.c,244 :: 		ROW_0_Direction =1;
	BSF         TRISA4_bit+0, BitPos(TRISA4_bit+0) 
;DZ.c,245 :: 		ROW_1_Direction =1;
	BSF         TRISA5_bit+0, BitPos(TRISA5_bit+0) 
;DZ.c,246 :: 		ROW_2_Direction =1;
	BSF         TRISA6_bit+0, BitPos(TRISA6_bit+0) 
;DZ.c,247 :: 		ROW_3_Direction =1;
	BSF         TRISA7_bit+0, BitPos(TRISA7_bit+0) 
;DZ.c,249 :: 		TRISD.B0 = 0;
	BCF         TRISD+0, 0 
;DZ.c,251 :: 		uart_init();
	CALL        _uart_init+0, 0
;DZ.c,253 :: 		lcd_init_all();
	CALL        _lcd_init_all+0, 0
;DZ.c,255 :: 		Delay_ms(10);
	MOVLW       33
	MOVWF       R12, 0
	MOVLW       118
	MOVWF       R13, 0
L_main24:
	DECFSZ      R13, 1, 1
	BRA         L_main24
	DECFSZ      R12, 1, 1
	BRA         L_main24
	NOP
;DZ.c,257 :: 		while(1){
L_main25:
;DZ.c,258 :: 		i = 0;
	CLRF        main_i_L0+0 
;DZ.c,259 :: 		j = 0;
	CLRF        main_j_L0+0 
;DZ.c,261 :: 		second_input = 0;
	CLRF        _second_input+0 
;DZ.c,262 :: 		input_value = 0;
	CLRF        main_input_value_L0+0 
;DZ.c,263 :: 		keyboard_result = 0;
	CLRF        main_keyboard_result_L0+0 
;DZ.c,264 :: 		uart_ready = 0;
	CLRF        _uart_ready+0 
;DZ.c,266 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,267 :: 		lcd_char_my(1,j,'S');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       83
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,268 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,269 :: 		lcd_char_my(1,j,'E');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,270 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,271 :: 		lcd_char_my(1,j,'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,272 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,273 :: 		lcd_char_my(1,j,':');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       58
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,274 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,275 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,277 :: 		j=1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,279 :: 		Delay_ms(10);
	MOVLW       33
	MOVWF       R12, 0
	MOVLW       118
	MOVWF       R13, 0
L_main27:
	DECFSZ      R13, 1, 1
	BRA         L_main27
	DECFSZ      R12, 1, 1
	BRA         L_main27
	NOP
;DZ.c,281 :: 		while (keyboard_result !=0x12) {
L_main28:
	MOVF        main_keyboard_result_L0+0, 0 
	XORLW       18
	BTFSC       STATUS+0, 2 
	GOTO        L_main29
;DZ.c,282 :: 		lcd_char_my(1, 6, k);
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       6
	MOVWF       FARG_lcd_char_my_column+0 
	MOVF        main_k_L0+0, 0 
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,283 :: 		k++;
	INCF        main_k_L0+0, 1 
;DZ.c,285 :: 		keyboard_result = check_keyboard();
	CALL        _check_keyboard+0, 0
	MOVF        R0, 0 
	MOVWF       main_keyboard_result_L0+0 
;DZ.c,287 :: 		if (keyboard_result == 0x10) {
	MOVF        R0, 0 
	XORLW       16
	BTFSS       STATUS+0, 2 
	GOTO        L_main30
;DZ.c,288 :: 		input_value <<= 1;
	RLCF        main_input_value_L0+0, 1 
	BCF         main_input_value_L0+0, 0 
;DZ.c,289 :: 		}
L_main30:
;DZ.c,290 :: 		if (keyboard_result == 0x11) {
	MOVF        main_keyboard_result_L0+0, 0 
	XORLW       17
	BTFSS       STATUS+0, 2 
	GOTO        L_main31
;DZ.c,291 :: 		input_value = (input_value << 1) | 1;
	RLCF        main_input_value_L0+0, 1 
	BCF         main_input_value_L0+0, 0 
	BSF         main_input_value_L0+0, 0 
;DZ.c,292 :: 		}
L_main31:
;DZ.c,293 :: 		if (keyboard_result == 0x12) {
	MOVF        main_keyboard_result_L0+0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_main32
;DZ.c,294 :: 		lcd_char_my(1, j, 'S');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       83
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,295 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,296 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,297 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,298 :: 		lcd_char_my(1, j, 'A');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       65
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,299 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,300 :: 		lcd_char_my(1, j, 'R');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,301 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,302 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,303 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,304 :: 		lcd_char_my(1, j, 'I');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,305 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,306 :: 		lcd_char_my(1, j, 'N');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,307 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,308 :: 		lcd_char_my(1, j, 'G');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       71
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,309 :: 		Delay_ms(2000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_main33:
	DECFSZ      R13, 1, 1
	BRA         L_main33
	DECFSZ      R12, 1, 1
	BRA         L_main33
	DECFSZ      R11, 1, 1
	BRA         L_main33
	NOP
;DZ.c,310 :: 		}
L_main32:
;DZ.c,312 :: 		if(keyboard_result == 0x13){
	MOVF        main_keyboard_result_L0+0, 0 
	XORLW       19
	BTFSS       STATUS+0, 2 
	GOTO        L_main34
;DZ.c,313 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,314 :: 		lcd_char_my(1,j,'B'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       66
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,315 :: 		lcd_char_my(1,j,'R'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,316 :: 		lcd_char_my(1,j,'E'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,317 :: 		lcd_char_my(1,j,'A'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       65
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,318 :: 		lcd_char_my(1,j,'K'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       75
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,319 :: 		lcd_char_my(1,j,'I'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,320 :: 		lcd_char_my(1,j,'N'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,321 :: 		lcd_char_my(1,j,'G'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       71
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,322 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,323 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,324 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,325 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,326 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,327 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,328 :: 		Delay_ms(2000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_main35:
	DECFSZ      R13, 1, 1
	BRA         L_main35
	DECFSZ      R12, 1, 1
	BRA         L_main35
	DECFSZ      R11, 1, 1
	BRA         L_main35
	NOP
;DZ.c,329 :: 		input_value = 0;
	CLRF        main_input_value_L0+0 
;DZ.c,330 :: 		break;
	GOTO        L_main29
;DZ.c,331 :: 		}
L_main34:
;DZ.c,333 :: 		to_binary(input_value, bin_str);
	MOVF        main_input_value_L0+0, 0 
	MOVWF       FARG_to_binary_val+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FARG_to_binary_buffer+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FARG_to_binary_buffer+1 
	CALL        _to_binary+0, 0
;DZ.c,334 :: 		for (i = 0; i < 8; i++) {
	CLRF        main_i_L0+0 
L_main36:
	MOVLW       8
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main37
;DZ.c,335 :: 		lcd_char_my(2, i + 1, bin_str[i]);
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
;DZ.c,334 :: 		for (i = 0; i < 8; i++) {
	INCF        main_i_L0+0, 1 
;DZ.c,336 :: 		}
	GOTO        L_main36
L_main37:
;DZ.c,337 :: 		}
	GOTO        L_main28
L_main29:
;DZ.c,339 :: 		count = input_value;
	MOVF        main_input_value_L0+0, 0 
	MOVWF       main_count_L0+0 
;DZ.c,341 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,343 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       69
	MOVWF       R12, 0
	MOVLW       169
	MOVWF       R13, 0
L_main39:
	DECFSZ      R13, 1, 1
	BRA         L_main39
	DECFSZ      R12, 1, 1
	BRA         L_main39
	DECFSZ      R11, 1, 1
	BRA         L_main39
	NOP
	NOP
;DZ.c,345 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,346 :: 		lcd_char_my(1,j,'S'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       83
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,347 :: 		lcd_char_my(1,j,'E'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,348 :: 		lcd_char_my(1,j,'C'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       67
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,349 :: 		lcd_char_my(1,j,'O'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       79
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,350 :: 		lcd_char_my(1,j,'N'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,351 :: 		lcd_char_my(1,j,'D'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       68
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,352 :: 		lcd_char_my(1,j,':');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       58
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,354 :: 		while (1) {
L_main40:
;DZ.c,355 :: 		lcd_char_my(2, 10, k);
	MOVLW       2
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       10
	MOVWF       FARG_lcd_char_my_column+0 
	MOVF        main_k_L0+0, 0 
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,356 :: 		k++;
	INCF        main_k_L0+0, 1 
;DZ.c,358 :: 		keyboard_result = check_keyboard();
	CALL        _check_keyboard+0, 0
	MOVF        R0, 0 
	MOVWF       main_keyboard_result_L0+0 
;DZ.c,359 :: 		if(keyboard_result == 0x13){
	MOVF        R0, 0 
	XORLW       19
	BTFSS       STATUS+0, 2 
	GOTO        L_main42
;DZ.c,360 :: 		second_input = 255;
	MOVLW       255
	MOVWF       _second_input+0 
;DZ.c,361 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,362 :: 		lcd_char_my(1,j,'B'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       66
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,363 :: 		lcd_char_my(1,j,'R'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,364 :: 		lcd_char_my(1,j,'E'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,365 :: 		lcd_char_my(1,j,'A'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       65
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,366 :: 		lcd_char_my(1,j,'K'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       75
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,367 :: 		lcd_char_my(1,j,'I'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,368 :: 		lcd_char_my(1,j,'N'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,369 :: 		lcd_char_my(1,j,'G'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       71
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,370 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,371 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,372 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,373 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,374 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,375 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,376 :: 		Delay_ms(2000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_main43:
	DECFSZ      R13, 1, 1
	BRA         L_main43
	DECFSZ      R12, 1, 1
	BRA         L_main43
	DECFSZ      R11, 1, 1
	BRA         L_main43
	NOP
;DZ.c,377 :: 		break;
	GOTO        L_main41
;DZ.c,378 :: 		}
L_main42:
;DZ.c,380 :: 		if (uart_ready >0) {
	MOVF        _uart_ready+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_main44
;DZ.c,382 :: 		to_binary(second_input & 0xFF, bin_str);
	MOVLW       255
	ANDWF       _second_input+0, 0 
	MOVWF       FARG_to_binary_val+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FARG_to_binary_buffer+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FARG_to_binary_buffer+1 
	CALL        _to_binary+0, 0
;DZ.c,383 :: 		for (i = 0; i < 8; i++) lcd_char_my(2, i + 1, bin_str[i]);
	CLRF        main_i_L0+0 
L_main45:
	MOVLW       8
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main46
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
	INCF        main_i_L0+0, 1 
	GOTO        L_main45
L_main46:
;DZ.c,385 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,386 :: 		lcd_char_my(1, j, 'S');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       83
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,387 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,388 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,389 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,390 :: 		lcd_char_my(1, j, 'A');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       65
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,391 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,392 :: 		lcd_char_my(1, j, 'R');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,393 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,394 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,395 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,396 :: 		lcd_char_my(1, j, 'I');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,397 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,398 :: 		lcd_char_my(1, j, 'N');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,399 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,400 :: 		lcd_char_my(1, j, 'G');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       71
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,401 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,402 :: 		lcd_char_my(1, j, ' ');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,404 :: 		Delay_ms(2000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_main48:
	DECFSZ      R13, 1, 1
	BRA         L_main48
	DECFSZ      R12, 1, 1
	BRA         L_main48
	DECFSZ      R11, 1, 1
	BRA         L_main48
	NOP
;DZ.c,405 :: 		break;
	GOTO        L_main41
;DZ.c,406 :: 		}
L_main44:
;DZ.c,407 :: 		}
	GOTO        L_main40
L_main41:
;DZ.c,409 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,410 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       69
	MOVWF       R12, 0
	MOVLW       169
	MOVWF       R13, 0
L_main49:
	DECFSZ      R13, 1, 1
	BRA         L_main49
	DECFSZ      R12, 1, 1
	BRA         L_main49
	DECFSZ      R11, 1, 1
	BRA         L_main49
	NOP
	NOP
;DZ.c,412 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,413 :: 		lcd_char_my(1, j, 'B');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       66
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,414 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,415 :: 		lcd_char_my(1, j, 'I');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,416 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,417 :: 		lcd_char_my(1, j, 'N');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,418 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,419 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,420 :: 		lcd_char_my(1, j, 'C');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       67
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,421 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,422 :: 		lcd_char_my(1, j, 'O');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       79
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,423 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,424 :: 		lcd_char_my(1, j, 'U');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       85
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,425 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,426 :: 		lcd_char_my(1, j, 'N');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,427 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,428 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,429 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,430 :: 		lcd_char_my(1, j, 'E');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,431 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,432 :: 		lcd_char_my(1, j, 'R');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,434 :: 		to_binary(count, bin_str);
	MOVF        main_count_L0+0, 0 
	MOVWF       FARG_to_binary_val+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FARG_to_binary_buffer+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FARG_to_binary_buffer+1 
	CALL        _to_binary+0, 0
;DZ.c,436 :: 		for (i = 0; i < 8; i++) {
	CLRF        main_i_L0+0 
L_main50:
	MOVLW       8
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main51
;DZ.c,437 :: 		lcd_char_my(2, i + 2, bin_str[i]);
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
;DZ.c,436 :: 		for (i = 0; i < 8; i++) {
	INCF        main_i_L0+0, 1 
;DZ.c,438 :: 		}
	GOTO        L_main50
L_main51:
;DZ.c,439 :: 		Delay_ms(1000);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_main53:
	DECFSZ      R13, 1, 1
	BRA         L_main53
	DECFSZ      R12, 1, 1
	BRA         L_main53
	DECFSZ      R11, 1, 1
	BRA         L_main53
	NOP
;DZ.c,441 :: 		while (count<second_input) {
L_main54:
	MOVF        _second_input+0, 0 
	SUBWF       main_count_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main55
;DZ.c,442 :: 		keyboard_result = check_keyboard();
	CALL        _check_keyboard+0, 0
	MOVF        R0, 0 
	MOVWF       main_keyboard_result_L0+0 
;DZ.c,443 :: 		if(keyboard_result == 0x13){
	MOVF        R0, 0 
	XORLW       19
	BTFSS       STATUS+0, 2 
	GOTO        L_main56
;DZ.c,444 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,445 :: 		lcd_char_my(1,j,'B'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       66
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,446 :: 		lcd_char_my(1,j,'R'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,447 :: 		lcd_char_my(1,j,'E'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,448 :: 		lcd_char_my(1,j,'A'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       65
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,449 :: 		lcd_char_my(1,j,'K'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       75
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,450 :: 		lcd_char_my(1,j,'I'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,451 :: 		lcd_char_my(1,j,'N'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,452 :: 		lcd_char_my(1,j,'G'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       71
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,453 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,455 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,456 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,457 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,458 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,459 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,460 :: 		Delay_ms(5000);
	MOVLW       64
	MOVWF       R11, 0
	MOVLW       106
	MOVWF       R12, 0
	MOVLW       151
	MOVWF       R13, 0
L_main57:
	DECFSZ      R13, 1, 1
	BRA         L_main57
	DECFSZ      R12, 1, 1
	BRA         L_main57
	DECFSZ      R11, 1, 1
	BRA         L_main57
	NOP
	NOP
;DZ.c,461 :: 		break;
	GOTO        L_main55
;DZ.c,462 :: 		}
L_main56:
;DZ.c,463 :: 		count++;
	INCF        main_count_L0+0, 1 
;DZ.c,465 :: 		to_binary(count, bin_str);
	MOVF        main_count_L0+0, 0 
	MOVWF       FARG_to_binary_val+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FARG_to_binary_buffer+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FARG_to_binary_buffer+1 
	CALL        _to_binary+0, 0
;DZ.c,467 :: 		for (i = 0; i < 8; i++) {
	CLRF        main_i_L0+0 
L_main58:
	MOVLW       8
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main59
;DZ.c,468 :: 		lcd_char_my(2, i + 2, bin_str[i]);
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
;DZ.c,467 :: 		for (i = 0; i < 8; i++) {
	INCF        main_i_L0+0, 1 
;DZ.c,469 :: 		}
	GOTO        L_main58
L_main59:
;DZ.c,471 :: 		Delay_ms(1000);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_main61:
	DECFSZ      R13, 1, 1
	BRA         L_main61
	DECFSZ      R12, 1, 1
	BRA         L_main61
	DECFSZ      R11, 1, 1
	BRA         L_main61
	NOP
;DZ.c,473 :: 		}
	GOTO        L_main54
L_main55:
;DZ.c,474 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,476 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       69
	MOVWF       R12, 0
	MOVLW       169
	MOVWF       R13, 0
L_main62:
	DECFSZ      R13, 1, 1
	BRA         L_main62
	DECFSZ      R12, 1, 1
	BRA         L_main62
	DECFSZ      R11, 1, 1
	BRA         L_main62
	NOP
	NOP
;DZ.c,477 :: 		}
	GOTO        L_main25
;DZ.c,478 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
