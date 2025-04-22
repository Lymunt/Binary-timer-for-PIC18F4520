
_interrupt:

;DZ.c,47 :: 		void interrupt() {
;DZ.c,48 :: 		PORTD.B0 = ~PORTD.B0;
	BTG         PORTD+0, 0 
;DZ.c,49 :: 		if (PIR1.RCIF == 1){
	BTFSS       PIR1+0, 5 
	GOTO        L_interrupt0
;DZ.c,50 :: 		uart_char = RCREG;
	MOVF        RCREG+0, 0 
	MOVWF       _uart_char+0 
;DZ.c,51 :: 		uart_ready++;
	INCF        _uart_ready+0, 1 
;DZ.c,52 :: 		}
L_interrupt0:
;DZ.c,53 :: 		}
L_end_interrupt:
L__interrupt68:
	RETFIE      1
; end of _interrupt

_to_binary:

;DZ.c,55 :: 		void to_binary(unsigned char val, char *buffer) {
;DZ.c,56 :: 		int i = 0;
	CLRF        to_binary_i_L0+0 
	CLRF        to_binary_i_L0+1 
;DZ.c,57 :: 		for ( i = 7; i >= 0; i--) {
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
	GOTO        L__to_binary70
	MOVLW       0
	SUBWF       to_binary_i_L0+0, 0 
L__to_binary70:
	BTFSS       STATUS+0, 0 
	GOTO        L_to_binary2
;DZ.c,58 :: 		buffer[7 - i] = (val & (1 << i)) ? '1' : '0';
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
L__to_binary71:
	BZ          L__to_binary72
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__to_binary71
L__to_binary72:
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
;DZ.c,57 :: 		for ( i = 7; i >= 0; i--) {
	MOVLW       1
	SUBWF       to_binary_i_L0+0, 1 
	MOVLW       0
	SUBWFB      to_binary_i_L0+1, 1 
;DZ.c,59 :: 		}
	GOTO        L_to_binary1
L_to_binary2:
;DZ.c,60 :: 		buffer[8] = '\0';
	MOVLW       8
	ADDWF       FARG_to_binary_buffer+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_to_binary_buffer+1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
;DZ.c,61 :: 		}
L_end_to_binary:
	RETURN      0
; end of _to_binary

_pulse_e:

;DZ.c,63 :: 		void pulse_e() {
;DZ.c,64 :: 		LCD_EN = 1;
	BSF         LATB5_bit+0, BitPos(LATB5_bit+0) 
;DZ.c,65 :: 		Delay_us(1);
	NOP
	NOP
;DZ.c,66 :: 		LCD_EN = 0;
	BCF         LATB5_bit+0, BitPos(LATB5_bit+0) 
;DZ.c,67 :: 		Delay_us(40);
	MOVLW       33
	MOVWF       R13, 0
L_pulse_e6:
	DECFSZ      R13, 1, 1
	BRA         L_pulse_e6
;DZ.c,69 :: 		}
L_end_pulse_e:
	RETURN      0
; end of _pulse_e

_lcd_cmd_4:

;DZ.c,71 :: 		void lcd_cmd_4(unsigned char cmd){
;DZ.c,72 :: 		LCD_D4 = (cmd >> 0) & 1;
	MOVLW       1
	ANDWF       FARG_lcd_cmd_4_cmd+0, 0 
	MOVWF       R0 
	BTFSC       R0, 0 
	GOTO        L__lcd_cmd_475
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__lcd_cmd_476
L__lcd_cmd_475:
	BSF         LATD4_bit+0, BitPos(LATD4_bit+0) 
L__lcd_cmd_476:
;DZ.c,73 :: 		LCD_D5 = (cmd >> 1) & 1;
	MOVF        FARG_lcd_cmd_4_cmd+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       1
	ANDWF       R0, 1 
	BTFSC       R0, 0 
	GOTO        L__lcd_cmd_477
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__lcd_cmd_478
L__lcd_cmd_477:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__lcd_cmd_478:
;DZ.c,74 :: 		LCD_D6 = (cmd >> 2) & 1;
	MOVF        FARG_lcd_cmd_4_cmd+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       1
	ANDWF       R0, 1 
	BTFSC       R0, 0 
	GOTO        L__lcd_cmd_479
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
	GOTO        L__lcd_cmd_480
L__lcd_cmd_479:
	BSF         LATD6_bit+0, BitPos(LATD6_bit+0) 
L__lcd_cmd_480:
;DZ.c,75 :: 		LCD_D7 = (cmd >> 3) & 1;
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
	GOTO        L__lcd_cmd_481
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
	GOTO        L__lcd_cmd_482
L__lcd_cmd_481:
	BSF         LATD7_bit+0, BitPos(LATD7_bit+0) 
L__lcd_cmd_482:
;DZ.c,76 :: 		}
L_end_lcd_cmd_4:
	RETURN      0
; end of _lcd_cmd_4

_lcd_cmd_my:

;DZ.c,78 :: 		void lcd_cmd_my(unsigned char cmd){
;DZ.c,79 :: 		LCD_RS = 0;
	BCF         LATB2_bit+0, BitPos(LATB2_bit+0) 
;DZ.c,80 :: 		lcd_cmd_4(cmd >> 4);
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
;DZ.c,81 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,82 :: 		lcd_cmd_4(cmd & 0x0F);
	MOVLW       15
	ANDWF       FARG_lcd_cmd_my_cmd+0, 0 
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,83 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,84 :: 		}
L_end_lcd_cmd_my:
	RETURN      0
; end of _lcd_cmd_my

_lcd_char_my:

;DZ.c,86 :: 		void lcd_char_my(unsigned char row, unsigned char column, unsigned char cmd){
;DZ.c,90 :: 		if (row == 1)
	MOVF        FARG_lcd_char_my_row+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_lcd_char_my7
;DZ.c,91 :: 		adress = 0x80 + (column - 1);
	DECF        FARG_lcd_char_my_column+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDLW       128
	MOVWF       lcd_char_my_adress_L0+0 
	GOTO        L_lcd_char_my8
L_lcd_char_my7:
;DZ.c,92 :: 		else if (row == 2)
	MOVF        FARG_lcd_char_my_row+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_lcd_char_my9
;DZ.c,93 :: 		adress = 0xC0 + (column - 1);
	DECF        FARG_lcd_char_my_column+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDLW       192
	MOVWF       lcd_char_my_adress_L0+0 
L_lcd_char_my9:
L_lcd_char_my8:
;DZ.c,95 :: 		lcd_cmd_my(adress);
	MOVF        lcd_char_my_adress_L0+0, 0 
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,97 :: 		LCD_RS = 1;
	BSF         LATB2_bit+0, BitPos(LATB2_bit+0) 
;DZ.c,98 :: 		lcd_cmd_4(cmd >> 4);
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
;DZ.c,99 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,100 :: 		lcd_cmd_4(cmd & 0x0F);
	MOVLW       15
	ANDWF       FARG_lcd_char_my_cmd+0, 0 
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,101 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,102 :: 		}
L_end_lcd_char_my:
	RETURN      0
; end of _lcd_char_my

_lcd_init_r:

;DZ.c,104 :: 		void lcd_init_r(){
;DZ.c,106 :: 		lcd_cmd_4(0x03);
	MOVLW       3
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,108 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,110 :: 		Delay_us(40);
	MOVLW       33
	MOVWF       R13, 0
L_lcd_init_r10:
	DECFSZ      R13, 1, 1
	BRA         L_lcd_init_r10
;DZ.c,111 :: 		}
L_end_lcd_init_r:
	RETURN      0
; end of _lcd_init_r

_lcd_init_all:

;DZ.c,113 :: 		void lcd_init_all(){
;DZ.c,115 :: 		Delay_ms(20);
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
;DZ.c,117 :: 		lcd_init_r();
	CALL        _lcd_init_r+0, 0
;DZ.c,119 :: 		lcd_init_r();
	CALL        _lcd_init_r+0, 0
;DZ.c,121 :: 		lcd_init_r();
	CALL        _lcd_init_r+0, 0
;DZ.c,123 :: 		lcd_cmd_4(0x02);
	MOVLW       2
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,124 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,126 :: 		lcd_cmd_my(0x28);
	MOVLW       40
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,128 :: 		lcd_cmd_my(0x0F);
	MOVLW       15
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,130 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,132 :: 		lcd_cmd_my(0x06);
	MOVLW       6
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,133 :: 		}
L_end_lcd_init_all:
	RETURN      0
; end of _lcd_init_all

_check_rows:

;DZ.c,135 :: 		unsigned char check_rows(){
;DZ.c,136 :: 		unsigned char row_result = 0;
	CLRF        check_rows_row_result_L0+0 
;DZ.c,138 :: 		if(ROW_0 == 1){
	BTFSS       RA4_bit+0, BitPos(RA4_bit+0) 
	GOTO        L_check_rows12
;DZ.c,139 :: 		row_result = 0x10;
	MOVLW       16
	MOVWF       check_rows_row_result_L0+0 
;DZ.c,140 :: 		return row_result;
	MOVLW       16
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,141 :: 		}
L_check_rows12:
;DZ.c,142 :: 		if(ROW_1 == 1){
	BTFSS       RA5_bit+0, BitPos(RA5_bit+0) 
	GOTO        L_check_rows13
;DZ.c,143 :: 		row_result = 0x14;
	MOVLW       20
	MOVWF       check_rows_row_result_L0+0 
;DZ.c,144 :: 		return row_result;
	MOVLW       20
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,145 :: 		}
L_check_rows13:
;DZ.c,146 :: 		if(ROW_2 == 1){
	BTFSS       RA6_bit+0, BitPos(RA6_bit+0) 
	GOTO        L_check_rows14
;DZ.c,147 :: 		row_result = 0x18;
	MOVLW       24
	MOVWF       check_rows_row_result_L0+0 
;DZ.c,148 :: 		return row_result;
	MOVLW       24
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,149 :: 		}
L_check_rows14:
;DZ.c,150 :: 		if(ROW_3 == 1){
	BTFSS       RA7_bit+0, BitPos(RA7_bit+0) 
	GOTO        L_check_rows15
;DZ.c,151 :: 		row_result = 0x1C;
	MOVLW       28
	MOVWF       check_rows_row_result_L0+0 
;DZ.c,152 :: 		return row_result;
	MOVLW       28
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,153 :: 		}
L_check_rows15:
;DZ.c,154 :: 		return row_result;
	MOVF        check_rows_row_result_L0+0, 0 
	MOVWF       R0 
;DZ.c,155 :: 		}
L_end_check_rows:
	RETURN      0
; end of _check_rows

_check_keyboard:

;DZ.c,157 :: 		unsigned char check_keyboard(){
;DZ.c,158 :: 		unsigned char keyboard_result = 0;
	CLRF        check_keyboard_keyboard_result_L0+0 
	CLRF        check_keyboard_row_result_L0+0 
;DZ.c,163 :: 		COL_0 = 1;
	BSF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;DZ.c,164 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,165 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard16
;DZ.c,166 :: 		Delay_ms(200);
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
;DZ.c,167 :: 		keyboard_result = 0x00+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	MOVWF       check_keyboard_keyboard_result_L0+0 
;DZ.c,169 :: 		return keyboard_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_check_keyboard
;DZ.c,170 :: 		}
L_check_keyboard16:
;DZ.c,171 :: 		COL_0 = 0;
	BCF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;DZ.c,173 :: 		COL_1 = 1;
	BSF         LATA1_bit+0, BitPos(LATA1_bit+0) 
;DZ.c,174 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,175 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard18
;DZ.c,176 :: 		Delay_ms(200);
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
;DZ.c,177 :: 		keyboard_result = 0x01+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       check_keyboard_keyboard_result_L0+0 
;DZ.c,179 :: 		return keyboard_result;
	GOTO        L_end_check_keyboard
;DZ.c,180 :: 		}
L_check_keyboard18:
;DZ.c,181 :: 		COL_1 = 0;
	BCF         LATA1_bit+0, BitPos(LATA1_bit+0) 
;DZ.c,183 :: 		COL_2 = 1;
	BSF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;DZ.c,184 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,185 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard20
;DZ.c,186 :: 		Delay_ms(200);
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
;DZ.c,187 :: 		keyboard_result = 0x02+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	ADDLW       2
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       check_keyboard_keyboard_result_L0+0 
;DZ.c,189 :: 		return keyboard_result;
	GOTO        L_end_check_keyboard
;DZ.c,190 :: 		}
L_check_keyboard20:
;DZ.c,191 :: 		COL_2 = 0;
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;DZ.c,193 :: 		COL_3 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;DZ.c,194 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,195 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard22
;DZ.c,196 :: 		Delay_ms(200);
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
;DZ.c,197 :: 		keyboard_result = 0x03+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	ADDLW       3
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       check_keyboard_keyboard_result_L0+0 
;DZ.c,199 :: 		return keyboard_result;
	GOTO        L_end_check_keyboard
;DZ.c,200 :: 		}
L_check_keyboard22:
;DZ.c,201 :: 		COL_3 = 0;
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;DZ.c,203 :: 		return keyboard_result;
	MOVF        check_keyboard_keyboard_result_L0+0, 0 
	MOVWF       R0 
;DZ.c,204 :: 		}
L_end_check_keyboard:
	RETURN      0
; end of _check_keyboard

_uart_init:

;DZ.c,206 :: 		void uart_init(){
;DZ.c,208 :: 		UART_OUT_Direction = 1;
	BSF         TRISC6_bit+0, BitPos(TRISC6_bit+0) 
;DZ.c,209 :: 		UART_IN_Direction = 1;
	BSF         TRISC7_bit+0, BitPos(TRISC7_bit+0) 
;DZ.c,211 :: 		SPBRG = 64;
	MOVLW       64
	MOVWF       SPBRG+0 
;DZ.c,212 :: 		TXSTA = 0x00;
	CLRF        TXSTA+0 
;DZ.c,213 :: 		RCSTA.SPEN = 1;
	BSF         RCSTA+0, 7 
;DZ.c,214 :: 		RCSTA.CREN = 1;
	BSF         RCSTA+0, 4 
;DZ.c,216 :: 		PIE1.RCIE = 1;
	BSF         PIE1+0, 5 
;DZ.c,218 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;DZ.c,219 :: 		INTCON.GIEL = 1;
	BSF         INTCON+0, 6 
;DZ.c,220 :: 		}
L_end_uart_init:
	RETURN      0
; end of _uart_init

_main:

;DZ.c,222 :: 		void main() {
;DZ.c,224 :: 		unsigned char count = 0;
	CLRF        main_count_L0+0 
	CLRF        main_i_L0+0 
	MOVLW       1
	MOVWF       main_j_L0+0 
	CLRF        main_k_L0+0 
	CLRF        main_input_value_L0+0 
	CLRF        main_keyboard_result_L0+0 
	CLRF        main_uart_value_L0+0 
	CLRF        main_uart_value_L0+1 
	CLRF        main_second_input_L0+0 
;DZ.c,235 :: 		ADCON1 = 0x0F;
	MOVLW       15
	MOVWF       ADCON1+0 
;DZ.c,237 :: 		LCD_RS_Direction =0;
	BCF         TRISB2_bit+0, BitPos(TRISB2_bit+0) 
;DZ.c,238 :: 		LCD_EN_Direction =0;
	BCF         TRISB5_bit+0, BitPos(TRISB5_bit+0) 
;DZ.c,239 :: 		LCD_D4_Direction =0;
	BCF         TRISD4_bit+0, BitPos(TRISD4_bit+0) 
;DZ.c,240 :: 		LCD_D5_Direction =0;
	BCF         TRISD5_bit+0, BitPos(TRISD5_bit+0) 
;DZ.c,241 :: 		LCD_D6_Direction =0;
	BCF         TRISD6_bit+0, BitPos(TRISD6_bit+0) 
;DZ.c,242 :: 		LCD_D7_Direction =0;
	BCF         TRISD7_bit+0, BitPos(TRISD7_bit+0) 
;DZ.c,244 :: 		COL_0_Direction =0;
	BCF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;DZ.c,245 :: 		COL_1_Direction =0;
	BCF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
;DZ.c,246 :: 		COL_2_Direction =0;
	BCF         TRISA2_bit+0, BitPos(TRISA2_bit+0) 
;DZ.c,247 :: 		COL_3_Direction =0;
	BCF         TRISA3_bit+0, BitPos(TRISA3_bit+0) 
;DZ.c,249 :: 		ROW_0_Direction =1;
	BSF         TRISA4_bit+0, BitPos(TRISA4_bit+0) 
;DZ.c,250 :: 		ROW_1_Direction =1;
	BSF         TRISA5_bit+0, BitPos(TRISA5_bit+0) 
;DZ.c,251 :: 		ROW_2_Direction =1;
	BSF         TRISA6_bit+0, BitPos(TRISA6_bit+0) 
;DZ.c,252 :: 		ROW_3_Direction =1;
	BSF         TRISA7_bit+0, BitPos(TRISA7_bit+0) 
;DZ.c,254 :: 		TRISD = 0;
	CLRF        TRISD+0 
;DZ.c,256 :: 		uart_init();
	CALL        _uart_init+0, 0
;DZ.c,258 :: 		lcd_init_all();
	CALL        _lcd_init_all+0, 0
;DZ.c,260 :: 		Delay_ms(10);
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
;DZ.c,262 :: 		while(1){
L_main25:
;DZ.c,263 :: 		i = 0;
	CLRF        main_i_L0+0 
;DZ.c,264 :: 		j = 0;
	CLRF        main_j_L0+0 
;DZ.c,266 :: 		uart_value = 0;
	CLRF        main_uart_value_L0+0 
	CLRF        main_uart_value_L0+1 
;DZ.c,267 :: 		second_input = 255;
	MOVLW       255
	MOVWF       main_second_input_L0+0 
;DZ.c,268 :: 		input_value = 0;
	CLRF        main_input_value_L0+0 
;DZ.c,269 :: 		keyboard_result = 0;
	CLRF        main_keyboard_result_L0+0 
;DZ.c,270 :: 		uart_ready = 0;
	CLRF        _uart_ready+0 
;DZ.c,272 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,273 :: 		lcd_char_my(1,j,'S');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       83
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,274 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,275 :: 		lcd_char_my(1,j,'E');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,276 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,277 :: 		lcd_char_my(1,j,'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,278 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,279 :: 		lcd_char_my(1,j,':');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       58
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,280 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,281 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,283 :: 		j=1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,285 :: 		while (keyboard_result !=0x12) {
L_main27:
	MOVF        main_keyboard_result_L0+0, 0 
	XORLW       18
	BTFSC       STATUS+0, 2 
	GOTO        L_main28
;DZ.c,286 :: 		lcd_char_my(1, 6, k);
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       6
	MOVWF       FARG_lcd_char_my_column+0 
	MOVF        main_k_L0+0, 0 
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,287 :: 		k++;
	INCF        main_k_L0+0, 1 
;DZ.c,289 :: 		keyboard_result = check_keyboard();
	CALL        _check_keyboard+0, 0
	MOVF        R0, 0 
	MOVWF       main_keyboard_result_L0+0 
;DZ.c,291 :: 		if (keyboard_result == 0x10) {
	MOVF        R0, 0 
	XORLW       16
	BTFSS       STATUS+0, 2 
	GOTO        L_main29
;DZ.c,292 :: 		input_value <<= 1;
	RLCF        main_input_value_L0+0, 1 
	BCF         main_input_value_L0+0, 0 
;DZ.c,293 :: 		}
L_main29:
;DZ.c,294 :: 		if (keyboard_result == 0x11) {
	MOVF        main_keyboard_result_L0+0, 0 
	XORLW       17
	BTFSS       STATUS+0, 2 
	GOTO        L_main30
;DZ.c,295 :: 		input_value = (input_value << 1) | 1;
	RLCF        main_input_value_L0+0, 1 
	BCF         main_input_value_L0+0, 0 
	BSF         main_input_value_L0+0, 0 
;DZ.c,296 :: 		}
L_main30:
;DZ.c,297 :: 		if (keyboard_result == 0x12) {
	MOVF        main_keyboard_result_L0+0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_main31
;DZ.c,298 :: 		lcd_char_my(1, j, 'S');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       83
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,299 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,300 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,301 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,302 :: 		lcd_char_my(1, j, 'A');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       65
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,303 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,304 :: 		lcd_char_my(1, j, 'R');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,305 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,306 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,307 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,308 :: 		lcd_char_my(1, j, 'I');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,309 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,310 :: 		lcd_char_my(1, j, 'N');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,311 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,312 :: 		lcd_char_my(1, j, 'G');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       71
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,313 :: 		Delay_ms(2000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_main32:
	DECFSZ      R13, 1, 1
	BRA         L_main32
	DECFSZ      R12, 1, 1
	BRA         L_main32
	DECFSZ      R11, 1, 1
	BRA         L_main32
	NOP
;DZ.c,314 :: 		}
L_main31:
;DZ.c,316 :: 		if(keyboard_result == 0x13){
	MOVF        main_keyboard_result_L0+0, 0 
	XORLW       19
	BTFSS       STATUS+0, 2 
	GOTO        L_main33
;DZ.c,317 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,318 :: 		lcd_char_my(1,j,'B'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       66
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,319 :: 		lcd_char_my(1,j,'R'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,320 :: 		lcd_char_my(1,j,'E'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,321 :: 		lcd_char_my(1,j,'A'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       65
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,322 :: 		lcd_char_my(1,j,'K'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       75
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,323 :: 		lcd_char_my(1,j,'I'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,324 :: 		lcd_char_my(1,j,'N'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,325 :: 		lcd_char_my(1,j,'G'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       71
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
;DZ.c,328 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,329 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,330 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,331 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,332 :: 		Delay_ms(2000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_main34:
	DECFSZ      R13, 1, 1
	BRA         L_main34
	DECFSZ      R12, 1, 1
	BRA         L_main34
	DECFSZ      R11, 1, 1
	BRA         L_main34
	NOP
;DZ.c,333 :: 		input_value = 0;
	CLRF        main_input_value_L0+0 
;DZ.c,334 :: 		break;
	GOTO        L_main28
;DZ.c,335 :: 		}
L_main33:
;DZ.c,337 :: 		to_binary(input_value, bin_str);
	MOVF        main_input_value_L0+0, 0 
	MOVWF       FARG_to_binary_val+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FARG_to_binary_buffer+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FARG_to_binary_buffer+1 
	CALL        _to_binary+0, 0
;DZ.c,338 :: 		for (i = 0; i < 8; i++) {
	CLRF        main_i_L0+0 
L_main35:
	MOVLW       8
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main36
;DZ.c,339 :: 		lcd_char_my(2, i + 1, bin_str[i]);
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
;DZ.c,338 :: 		for (i = 0; i < 8; i++) {
	INCF        main_i_L0+0, 1 
;DZ.c,340 :: 		}
	GOTO        L_main35
L_main36:
;DZ.c,341 :: 		}
	GOTO        L_main27
L_main28:
;DZ.c,343 :: 		count = input_value;
	MOVF        main_input_value_L0+0, 0 
	MOVWF       main_count_L0+0 
;DZ.c,345 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,347 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       69
	MOVWF       R12, 0
	MOVLW       169
	MOVWF       R13, 0
L_main38:
	DECFSZ      R13, 1, 1
	BRA         L_main38
	DECFSZ      R12, 1, 1
	BRA         L_main38
	DECFSZ      R11, 1, 1
	BRA         L_main38
	NOP
	NOP
;DZ.c,349 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,350 :: 		lcd_char_my(1,j,'S'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       83
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,351 :: 		lcd_char_my(1,j,'E'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,352 :: 		lcd_char_my(1,j,'C'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       67
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,353 :: 		lcd_char_my(1,j,'O'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       79
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,354 :: 		lcd_char_my(1,j,'N'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,355 :: 		lcd_char_my(1,j,'D'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       68
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,356 :: 		lcd_char_my(1,j,':');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       58
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,358 :: 		uart_value = 0;
	CLRF        main_uart_value_L0+0 
	CLRF        main_uart_value_L0+1 
;DZ.c,360 :: 		while (1) {
L_main39:
;DZ.c,361 :: 		lcd_char_my(2, 10, k);
	MOVLW       2
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       10
	MOVWF       FARG_lcd_char_my_column+0 
	MOVF        main_k_L0+0, 0 
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,362 :: 		k++;
	INCF        main_k_L0+0, 1 
;DZ.c,364 :: 		keyboard_result = check_keyboard();
	CALL        _check_keyboard+0, 0
	MOVF        R0, 0 
	MOVWF       main_keyboard_result_L0+0 
;DZ.c,365 :: 		if(keyboard_result == 0x13){
	MOVF        R0, 0 
	XORLW       19
	BTFSS       STATUS+0, 2 
	GOTO        L_main41
;DZ.c,366 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,367 :: 		lcd_char_my(1,j,'B'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       66
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,368 :: 		lcd_char_my(1,j,'R'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,369 :: 		lcd_char_my(1,j,'E'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,370 :: 		lcd_char_my(1,j,'A'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       65
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,371 :: 		lcd_char_my(1,j,'K'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       75
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,372 :: 		lcd_char_my(1,j,'I'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,373 :: 		lcd_char_my(1,j,'N'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,374 :: 		lcd_char_my(1,j,'G'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       71
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
;DZ.c,376 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,377 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,378 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,379 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,380 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,381 :: 		Delay_ms(2000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_main42:
	DECFSZ      R13, 1, 1
	BRA         L_main42
	DECFSZ      R12, 1, 1
	BRA         L_main42
	DECFSZ      R11, 1, 1
	BRA         L_main42
	NOP
;DZ.c,382 :: 		break;
	GOTO        L_main40
;DZ.c,383 :: 		}
L_main41:
;DZ.c,385 :: 		if (uart_ready>0) {
	MOVF        _uart_ready+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_main43
;DZ.c,386 :: 		uart_received = uart_char;
	MOVF        _uart_char+0, 0 
	MOVWF       main_uart_received_L0+0 
;DZ.c,387 :: 		if (uart_received >= '0' && uart_received <= '9') {
	MOVLW       48
	SUBWF       _uart_char+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_main46
	MOVF        main_uart_received_L0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_main46
L__main66:
;DZ.c,388 :: 		uart_value = uart_value * 10 + (uart_received - '0');
	MOVF        main_uart_value_L0+0, 0 
	MOVWF       R0 
	MOVF        main_uart_value_L0+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       48
	SUBWF       main_uart_received_L0+0, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVLW       0
	SUBWFB      R3, 1 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       main_uart_value_L0+0 
	MOVF        R3, 0 
	ADDWFC      R1, 0 
	MOVWF       main_uart_value_L0+1 
;DZ.c,389 :: 		}
L_main46:
;DZ.c,390 :: 		if (uart_ready == 2) {
	MOVF        _uart_ready+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main47
;DZ.c,391 :: 		second_input = uart_value;
	MOVF        main_uart_value_L0+0, 0 
	MOVWF       main_second_input_L0+0 
;DZ.c,392 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,393 :: 		lcd_char_my(1, j, 'S');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       83
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,394 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,395 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,396 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,397 :: 		lcd_char_my(1, j, 'A');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       65
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,398 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,399 :: 		lcd_char_my(1, j, 'R');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,400 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,401 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,402 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,403 :: 		lcd_char_my(1, j, 'I');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,404 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,405 :: 		lcd_char_my(1, j, 'N');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,406 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,407 :: 		lcd_char_my(1, j, 'G');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       71
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,408 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,409 :: 		lcd_char_my(1, j, ' ');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,411 :: 		Delay_ms(2000);
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
;DZ.c,412 :: 		break;
	GOTO        L_main40
;DZ.c,413 :: 		}
L_main47:
;DZ.c,414 :: 		to_binary(uart_ready & 0xFF, bin_str);
	MOVLW       255
	ANDWF       _uart_ready+0, 0 
	MOVWF       FARG_to_binary_val+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FARG_to_binary_buffer+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FARG_to_binary_buffer+1 
	CALL        _to_binary+0, 0
;DZ.c,415 :: 		for (i = 0; i < 8; i++) lcd_char_my(1, i + 9, bin_str[i]);
	CLRF        main_i_L0+0 
L_main49:
	MOVLW       8
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main50
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       9
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
	INCF        main_i_L0+0, 1 
	GOTO        L_main49
L_main50:
;DZ.c,416 :: 		}
L_main43:
;DZ.c,419 :: 		}
	GOTO        L_main39
L_main40:
;DZ.c,421 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,422 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       69
	MOVWF       R12, 0
	MOVLW       169
	MOVWF       R13, 0
L_main52:
	DECFSZ      R13, 1, 1
	BRA         L_main52
	DECFSZ      R12, 1, 1
	BRA         L_main52
	DECFSZ      R11, 1, 1
	BRA         L_main52
	NOP
	NOP
;DZ.c,424 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,425 :: 		lcd_char_my(1, j, 'B');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       66
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,426 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,427 :: 		lcd_char_my(1, j, 'I');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,428 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,429 :: 		lcd_char_my(1, j, 'N');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,430 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,431 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,432 :: 		lcd_char_my(1, j, 'C');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       67
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,433 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,434 :: 		lcd_char_my(1, j, 'O');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       79
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,435 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,436 :: 		lcd_char_my(1, j, 'U');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       85
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,437 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,438 :: 		lcd_char_my(1, j, 'N');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,439 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,440 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,441 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,442 :: 		lcd_char_my(1, j, 'E');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,443 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,444 :: 		lcd_char_my(1, j, 'R');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,446 :: 		to_binary(count, bin_str);
	MOVF        main_count_L0+0, 0 
	MOVWF       FARG_to_binary_val+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FARG_to_binary_buffer+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FARG_to_binary_buffer+1 
	CALL        _to_binary+0, 0
;DZ.c,448 :: 		for (i = 0; i < 8; i++) {
	CLRF        main_i_L0+0 
L_main53:
	MOVLW       8
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main54
;DZ.c,449 :: 		lcd_char_my(2, i + 2, bin_str[i]);
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
;DZ.c,448 :: 		for (i = 0; i < 8; i++) {
	INCF        main_i_L0+0, 1 
;DZ.c,450 :: 		}
	GOTO        L_main53
L_main54:
;DZ.c,451 :: 		Delay_ms(1000);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_main56:
	DECFSZ      R13, 1, 1
	BRA         L_main56
	DECFSZ      R12, 1, 1
	BRA         L_main56
	DECFSZ      R11, 1, 1
	BRA         L_main56
	NOP
;DZ.c,453 :: 		while (count<second_input) {
L_main57:
	MOVF        main_second_input_L0+0, 0 
	SUBWF       main_count_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main58
;DZ.c,454 :: 		keyboard_result = check_keyboard();
	CALL        _check_keyboard+0, 0
	MOVF        R0, 0 
	MOVWF       main_keyboard_result_L0+0 
;DZ.c,455 :: 		if(keyboard_result == 0x13){
	MOVF        R0, 0 
	XORLW       19
	BTFSS       STATUS+0, 2 
	GOTO        L_main59
;DZ.c,456 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,457 :: 		lcd_char_my(1,j,'B'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       66
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,458 :: 		lcd_char_my(1,j,'R'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,459 :: 		lcd_char_my(1,j,'E'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,460 :: 		lcd_char_my(1,j,'A'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       65
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,461 :: 		lcd_char_my(1,j,'K'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       75
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,462 :: 		lcd_char_my(1,j,'I'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,463 :: 		lcd_char_my(1,j,'N'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,464 :: 		lcd_char_my(1,j,'G'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       71
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,465 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,466 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,467 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,468 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,469 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,470 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,471 :: 		Delay_ms(5000);
	MOVLW       64
	MOVWF       R11, 0
	MOVLW       106
	MOVWF       R12, 0
	MOVLW       151
	MOVWF       R13, 0
L_main60:
	DECFSZ      R13, 1, 1
	BRA         L_main60
	DECFSZ      R12, 1, 1
	BRA         L_main60
	DECFSZ      R11, 1, 1
	BRA         L_main60
	NOP
	NOP
;DZ.c,472 :: 		break;
	GOTO        L_main58
;DZ.c,473 :: 		}
L_main59:
;DZ.c,474 :: 		count++;
	INCF        main_count_L0+0, 1 
;DZ.c,476 :: 		to_binary(count, bin_str);
	MOVF        main_count_L0+0, 0 
	MOVWF       FARG_to_binary_val+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FARG_to_binary_buffer+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FARG_to_binary_buffer+1 
	CALL        _to_binary+0, 0
;DZ.c,478 :: 		for (i = 0; i < 8; i++) {
	CLRF        main_i_L0+0 
L_main61:
	MOVLW       8
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main62
;DZ.c,479 :: 		lcd_char_my(2, i + 2, bin_str[i]);
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
;DZ.c,478 :: 		for (i = 0; i < 8; i++) {
	INCF        main_i_L0+0, 1 
;DZ.c,480 :: 		}
	GOTO        L_main61
L_main62:
;DZ.c,482 :: 		Delay_ms(1000);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_main64:
	DECFSZ      R13, 1, 1
	BRA         L_main64
	DECFSZ      R12, 1, 1
	BRA         L_main64
	DECFSZ      R11, 1, 1
	BRA         L_main64
	NOP
;DZ.c,484 :: 		}
	GOTO        L_main57
L_main58:
;DZ.c,485 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,487 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       69
	MOVWF       R12, 0
	MOVLW       169
	MOVWF       R13, 0
L_main65:
	DECFSZ      R13, 1, 1
	BRA         L_main65
	DECFSZ      R12, 1, 1
	BRA         L_main65
	DECFSZ      R11, 1, 1
	BRA         L_main65
	NOP
	NOP
;DZ.c,488 :: 		}
	GOTO        L_main25
;DZ.c,489 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
