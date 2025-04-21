
_to_binary:

;DZ.c,44 :: 		void to_binary(unsigned char val, char *buffer) {
;DZ.c,45 :: 		int i = 0;
	CLRF        to_binary_i_L0+0 
	CLRF        to_binary_i_L0+1 
;DZ.c,46 :: 		for ( i = 7; i >= 0; i--) {
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
	GOTO        L__to_binary58
	MOVLW       0
	SUBWF       to_binary_i_L0+0, 0 
L__to_binary58:
	BTFSS       STATUS+0, 0 
	GOTO        L_to_binary1
;DZ.c,47 :: 		buffer[7 - i] = (val & (1 << i)) ? '1' : '0';
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
L__to_binary59:
	BZ          L__to_binary60
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__to_binary59
L__to_binary60:
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
;DZ.c,46 :: 		for ( i = 7; i >= 0; i--) {
	MOVLW       1
	SUBWF       to_binary_i_L0+0, 1 
	MOVLW       0
	SUBWFB      to_binary_i_L0+1, 1 
;DZ.c,48 :: 		}
	GOTO        L_to_binary0
L_to_binary1:
;DZ.c,49 :: 		buffer[8] = '\0';
	MOVLW       8
	ADDWF       FARG_to_binary_buffer+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_to_binary_buffer+1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
;DZ.c,50 :: 		}
L_end_to_binary:
	RETURN      0
; end of _to_binary

_pulse_e:

;DZ.c,52 :: 		void pulse_e() {
;DZ.c,53 :: 		LCD_EN = 1;
	BSF         LATB5_bit+0, BitPos(LATB5_bit+0) 
;DZ.c,54 :: 		Delay_us(1);
	NOP
	NOP
;DZ.c,55 :: 		LCD_EN = 0;
	BCF         LATB5_bit+0, BitPos(LATB5_bit+0) 
;DZ.c,56 :: 		Delay_us(40);
	MOVLW       33
	MOVWF       R13, 0
L_pulse_e5:
	DECFSZ      R13, 1, 1
	BRA         L_pulse_e5
;DZ.c,58 :: 		}
L_end_pulse_e:
	RETURN      0
; end of _pulse_e

_lcd_cmd_4:

;DZ.c,60 :: 		void lcd_cmd_4(unsigned char cmd){
;DZ.c,61 :: 		LCD_D4 = (cmd >> 0) & 1;
	MOVLW       1
	ANDWF       FARG_lcd_cmd_4_cmd+0, 0 
	MOVWF       R0 
	BTFSC       R0, 0 
	GOTO        L__lcd_cmd_463
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__lcd_cmd_464
L__lcd_cmd_463:
	BSF         LATD4_bit+0, BitPos(LATD4_bit+0) 
L__lcd_cmd_464:
;DZ.c,62 :: 		LCD_D5 = (cmd >> 1) & 1;
	MOVF        FARG_lcd_cmd_4_cmd+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       1
	ANDWF       R0, 1 
	BTFSC       R0, 0 
	GOTO        L__lcd_cmd_465
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__lcd_cmd_466
L__lcd_cmd_465:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__lcd_cmd_466:
;DZ.c,63 :: 		LCD_D6 = (cmd >> 2) & 1;
	MOVF        FARG_lcd_cmd_4_cmd+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       1
	ANDWF       R0, 1 
	BTFSC       R0, 0 
	GOTO        L__lcd_cmd_467
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
	GOTO        L__lcd_cmd_468
L__lcd_cmd_467:
	BSF         LATD6_bit+0, BitPos(LATD6_bit+0) 
L__lcd_cmd_468:
;DZ.c,64 :: 		LCD_D7 = (cmd >> 3) & 1;
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
	GOTO        L__lcd_cmd_469
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
	GOTO        L__lcd_cmd_470
L__lcd_cmd_469:
	BSF         LATD7_bit+0, BitPos(LATD7_bit+0) 
L__lcd_cmd_470:
;DZ.c,65 :: 		}
L_end_lcd_cmd_4:
	RETURN      0
; end of _lcd_cmd_4

_lcd_cmd_my:

;DZ.c,67 :: 		void lcd_cmd_my(unsigned char cmd){
;DZ.c,68 :: 		LCD_RS = 0;
	BCF         LATB2_bit+0, BitPos(LATB2_bit+0) 
;DZ.c,69 :: 		lcd_cmd_4(cmd >> 4);
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
;DZ.c,70 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,71 :: 		lcd_cmd_4(cmd & 0x0F);
	MOVLW       15
	ANDWF       FARG_lcd_cmd_my_cmd+0, 0 
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,72 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,73 :: 		}
L_end_lcd_cmd_my:
	RETURN      0
; end of _lcd_cmd_my

_lcd_char_my:

;DZ.c,75 :: 		void lcd_char_my(unsigned char row, unsigned char column, unsigned char cmd){
;DZ.c,79 :: 		if (row == 1)
	MOVF        FARG_lcd_char_my_row+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_lcd_char_my6
;DZ.c,80 :: 		adress = 0x80 + (column - 1);
	DECF        FARG_lcd_char_my_column+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDLW       128
	MOVWF       lcd_char_my_adress_L0+0 
	GOTO        L_lcd_char_my7
L_lcd_char_my6:
;DZ.c,81 :: 		else if (row == 2)
	MOVF        FARG_lcd_char_my_row+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_lcd_char_my8
;DZ.c,82 :: 		adress = 0xC0 + (column - 1);
	DECF        FARG_lcd_char_my_column+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDLW       192
	MOVWF       lcd_char_my_adress_L0+0 
L_lcd_char_my8:
L_lcd_char_my7:
;DZ.c,84 :: 		lcd_cmd_my(adress);
	MOVF        lcd_char_my_adress_L0+0, 0 
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,86 :: 		LCD_RS = 1;
	BSF         LATB2_bit+0, BitPos(LATB2_bit+0) 
;DZ.c,87 :: 		lcd_cmd_4(cmd >> 4);
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
;DZ.c,88 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,89 :: 		lcd_cmd_4(cmd & 0x0F);
	MOVLW       15
	ANDWF       FARG_lcd_char_my_cmd+0, 0 
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,90 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,91 :: 		}
L_end_lcd_char_my:
	RETURN      0
; end of _lcd_char_my

_lcd_init_r:

;DZ.c,93 :: 		void lcd_init_r(){
;DZ.c,95 :: 		lcd_cmd_4(0x03);
	MOVLW       3
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,97 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,99 :: 		Delay_us(40);
	MOVLW       33
	MOVWF       R13, 0
L_lcd_init_r9:
	DECFSZ      R13, 1, 1
	BRA         L_lcd_init_r9
;DZ.c,100 :: 		}
L_end_lcd_init_r:
	RETURN      0
; end of _lcd_init_r

_lcd_init_all:

;DZ.c,102 :: 		void lcd_init_all(){
;DZ.c,104 :: 		Delay_ms(20);
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
;DZ.c,106 :: 		lcd_init_r();
	CALL        _lcd_init_r+0, 0
;DZ.c,108 :: 		lcd_init_r();
	CALL        _lcd_init_r+0, 0
;DZ.c,110 :: 		lcd_init_r();
	CALL        _lcd_init_r+0, 0
;DZ.c,112 :: 		lcd_cmd_4(0x02);
	MOVLW       2
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,113 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,115 :: 		lcd_cmd_my(0x28);
	MOVLW       40
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,117 :: 		lcd_cmd_my(0x0C);
	MOVLW       12
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,119 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,121 :: 		lcd_cmd_my(0x06);
	MOVLW       6
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,122 :: 		}
L_end_lcd_init_all:
	RETURN      0
; end of _lcd_init_all

_check_rows:

;DZ.c,124 :: 		unsigned char check_rows(){
;DZ.c,125 :: 		if(ROW_0 == 1){
	BTFSS       RA4_bit+0, BitPos(RA4_bit+0) 
	GOTO        L_check_rows11
;DZ.c,126 :: 		return 0x10;
	MOVLW       16
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,127 :: 		}
L_check_rows11:
;DZ.c,128 :: 		if(ROW_1 == 1){
	BTFSS       RA5_bit+0, BitPos(RA5_bit+0) 
	GOTO        L_check_rows12
;DZ.c,129 :: 		return 0x14;
	MOVLW       20
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,130 :: 		}
L_check_rows12:
;DZ.c,131 :: 		if(ROW_2 == 1){
	BTFSS       RA6_bit+0, BitPos(RA6_bit+0) 
	GOTO        L_check_rows13
;DZ.c,132 :: 		return 0x18;
	MOVLW       24
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,133 :: 		}
L_check_rows13:
;DZ.c,134 :: 		if(ROW_3 == 1){
	BTFSS       RA7_bit+0, BitPos(RA7_bit+0) 
	GOTO        L_check_rows14
;DZ.c,135 :: 		return 0x1C;
	MOVLW       28
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,136 :: 		}
L_check_rows14:
;DZ.c,137 :: 		return 0;
	CLRF        R0 
;DZ.c,138 :: 		}
L_end_check_rows:
	RETURN      0
; end of _check_rows

_check_keyboard:

;DZ.c,140 :: 		unsigned char check_keyboard(){
;DZ.c,141 :: 		unsigned char row_result = 0;
	CLRF        check_keyboard_row_result_L0+0 
;DZ.c,144 :: 		COL_0 = 1;
	BSF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;DZ.c,145 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,146 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard15
;DZ.c,147 :: 		Delay_ms(200);
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
;DZ.c,148 :: 		return 0x00+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_check_keyboard
;DZ.c,149 :: 		}
L_check_keyboard15:
;DZ.c,150 :: 		COL_0 = 0;
	BCF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;DZ.c,152 :: 		COL_1 = 1;
	BSF         LATA1_bit+0, BitPos(LATA1_bit+0) 
;DZ.c,153 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,154 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard17
;DZ.c,155 :: 		Delay_ms(200);
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
;DZ.c,156 :: 		return 0x01+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	ADDLW       1
	MOVWF       R0 
	GOTO        L_end_check_keyboard
;DZ.c,157 :: 		}
L_check_keyboard17:
;DZ.c,158 :: 		COL_1 = 0;
	BCF         LATA1_bit+0, BitPos(LATA1_bit+0) 
;DZ.c,160 :: 		COL_2 = 1;
	BSF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;DZ.c,161 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,162 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard19
;DZ.c,163 :: 		Delay_ms(200);
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
;DZ.c,164 :: 		return 0x02+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	ADDLW       2
	MOVWF       R0 
	GOTO        L_end_check_keyboard
;DZ.c,165 :: 		}
L_check_keyboard19:
;DZ.c,166 :: 		COL_2 = 0;
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;DZ.c,168 :: 		COL_3 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;DZ.c,169 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,170 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard21
;DZ.c,171 :: 		Delay_ms(200);
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
;DZ.c,172 :: 		return 0x03+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	ADDLW       3
	MOVWF       R0 
	GOTO        L_end_check_keyboard
;DZ.c,173 :: 		}
L_check_keyboard21:
;DZ.c,174 :: 		COL_3 = 0;
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;DZ.c,176 :: 		return 0;
	CLRF        R0 
;DZ.c,177 :: 		}
L_end_check_keyboard:
	RETURN      0
; end of _check_keyboard

_uart_write:

;DZ.c,179 :: 		void uart_write(char my_data){
;DZ.c,180 :: 		while (!PIR1.TXIF){}
L_uart_write23:
	BTFSC       PIR1+0, 4 
	GOTO        L_uart_write24
	GOTO        L_uart_write23
L_uart_write24:
;DZ.c,181 :: 		TXREG = my_data;
	MOVF        FARG_uart_write_my_data+0, 0 
	MOVWF       TXREG+0 
;DZ.c,182 :: 		}
L_end_uart_write:
	RETURN      0
; end of _uart_write

_uart_read:

;DZ.c,184 :: 		char uart_read(){
;DZ.c,185 :: 		while (!PIR1.RCIF){}
L_uart_read25:
	BTFSC       PIR1+0, 5 
	GOTO        L_uart_read26
	GOTO        L_uart_read25
L_uart_read26:
;DZ.c,186 :: 		return RCREG;
	MOVF        RCREG+0, 0 
	MOVWF       R0 
;DZ.c,187 :: 		}
L_end_uart_read:
	RETURN      0
; end of _uart_read

_uart_data_ready:

;DZ.c,189 :: 		char uart_data_ready(){
;DZ.c,190 :: 		return PIR1.RCIF;
	MOVLW       0
	BTFSC       PIR1+0, 5 
	MOVLW       1
	MOVWF       R0 
;DZ.c,191 :: 		}
L_end_uart_data_ready:
	RETURN      0
; end of _uart_data_ready

_main:

;DZ.c,194 :: 		void main() {
;DZ.c,195 :: 		unsigned char count = 0;
	CLRF        main_count_L0+0 
	CLRF        main_i_L0+0 
	MOVLW       1
	MOVWF       main_j_L0+0 
	CLRF        main_k_L0+0 
	CLRF        main_input_value_L0+0 
	CLRF        main_keyboard_result_L0+0 
	CLRF        main_uart_value_L0+0 
	CLRF        main_uart_value_L0+1 
;DZ.c,206 :: 		ADCON1 = 0x0F;
	MOVLW       15
	MOVWF       ADCON1+0 
;DZ.c,208 :: 		LCD_RS_Direction =0;
	BCF         TRISB2_bit+0, BitPos(TRISB2_bit+0) 
;DZ.c,209 :: 		LCD_EN_Direction =0;
	BCF         TRISB5_bit+0, BitPos(TRISB5_bit+0) 
;DZ.c,210 :: 		LCD_D4_Direction =0;
	BCF         TRISD4_bit+0, BitPos(TRISD4_bit+0) 
;DZ.c,211 :: 		LCD_D5_Direction =0;
	BCF         TRISD5_bit+0, BitPos(TRISD5_bit+0) 
;DZ.c,212 :: 		LCD_D6_Direction =0;
	BCF         TRISD6_bit+0, BitPos(TRISD6_bit+0) 
;DZ.c,213 :: 		LCD_D7_Direction =0;
	BCF         TRISD7_bit+0, BitPos(TRISD7_bit+0) 
;DZ.c,215 :: 		COL_0_Direction =0;
	BCF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;DZ.c,216 :: 		COL_1_Direction =0;
	BCF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
;DZ.c,217 :: 		COL_2_Direction =0;
	BCF         TRISA2_bit+0, BitPos(TRISA2_bit+0) 
;DZ.c,218 :: 		COL_3_Direction =0;
	BCF         TRISA3_bit+0, BitPos(TRISA3_bit+0) 
;DZ.c,220 :: 		ROW_0_Direction =1;
	BSF         TRISA4_bit+0, BitPos(TRISA4_bit+0) 
;DZ.c,221 :: 		ROW_1_Direction =1;
	BSF         TRISA5_bit+0, BitPos(TRISA5_bit+0) 
;DZ.c,222 :: 		ROW_2_Direction =1;
	BSF         TRISA6_bit+0, BitPos(TRISA6_bit+0) 
;DZ.c,223 :: 		ROW_3_Direction =1;
	BSF         TRISA7_bit+0, BitPos(TRISA7_bit+0) 
;DZ.c,225 :: 		UART_OUT_Direction = 0;
	BCF         TRISC6_bit+0, BitPos(TRISC6_bit+0) 
;DZ.c,226 :: 		UART_IN_Direction = 1;
	BSF         TRISC7_bit+0, BitPos(TRISC7_bit+0) 
;DZ.c,227 :: 		SPBRG = 64;
	MOVLW       64
	MOVWF       SPBRG+0 
;DZ.c,228 :: 		TXSTA = 0x20;
	MOVLW       32
	MOVWF       TXSTA+0 
;DZ.c,229 :: 		RCSTA = 0x09;
	MOVLW       9
	MOVWF       RCSTA+0 
;DZ.c,231 :: 		lcd_init_all();
	CALL        _lcd_init_all+0, 0
;DZ.c,233 :: 		Delay_ms(10);
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
;DZ.c,235 :: 		lcd_char_my(1,j,'S');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       83
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,236 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,237 :: 		lcd_char_my(1,j,'E');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,238 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,239 :: 		lcd_char_my(1,j,'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,240 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,241 :: 		lcd_char_my(1,j,':');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       58
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,242 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,243 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,245 :: 		j=1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,247 :: 		while (keyboard_result !=0x12) {
L_main28:
	MOVF        main_keyboard_result_L0+0, 0 
	XORLW       18
	BTFSC       STATUS+0, 2 
	GOTO        L_main29
;DZ.c,248 :: 		lcd_char_my(1, 6, k);
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       6
	MOVWF       FARG_lcd_char_my_column+0 
	MOVF        main_k_L0+0, 0 
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,249 :: 		k++;
	INCF        main_k_L0+0, 1 
;DZ.c,251 :: 		keyboard_result = check_keyboard();
	CALL        _check_keyboard+0, 0
	MOVF        R0, 0 
	MOVWF       main_keyboard_result_L0+0 
;DZ.c,253 :: 		if (keyboard_result == 0x10) {
	MOVF        R0, 0 
	XORLW       16
	BTFSS       STATUS+0, 2 
	GOTO        L_main30
;DZ.c,254 :: 		input_value <<= 1;
	RLCF        main_input_value_L0+0, 1 
	BCF         main_input_value_L0+0, 0 
;DZ.c,255 :: 		}
L_main30:
;DZ.c,256 :: 		if (keyboard_result == 0x11) {
	MOVF        main_keyboard_result_L0+0, 0 
	XORLW       17
	BTFSS       STATUS+0, 2 
	GOTO        L_main31
;DZ.c,257 :: 		input_value = (input_value << 1) | 1;
	RLCF        main_input_value_L0+0, 1 
	BCF         main_input_value_L0+0, 0 
	BSF         main_input_value_L0+0, 0 
;DZ.c,258 :: 		}
L_main31:
;DZ.c,259 :: 		if (keyboard_result == 0x12) {
	MOVF        main_keyboard_result_L0+0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_main32
;DZ.c,260 :: 		count = input_value;
	MOVF        main_input_value_L0+0, 0 
	MOVWF       main_count_L0+0 
;DZ.c,261 :: 		lcd_char_my(1, j, 'S');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       83
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,262 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,263 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,264 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,265 :: 		lcd_char_my(1, j, 'A');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       65
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,266 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,267 :: 		lcd_char_my(1, j, 'R');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,268 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,269 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,270 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,271 :: 		lcd_char_my(1, j, 'I');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,272 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,273 :: 		lcd_char_my(1, j, 'N');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,274 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,275 :: 		lcd_char_my(1, j, 'G');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       71
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,276 :: 		Delay_ms(2000);
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
;DZ.c,277 :: 		}
L_main32:
;DZ.c,279 :: 		to_binary(input_value, bin_str);
	MOVF        main_input_value_L0+0, 0 
	MOVWF       FARG_to_binary_val+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FARG_to_binary_buffer+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FARG_to_binary_buffer+1 
	CALL        _to_binary+0, 0
;DZ.c,280 :: 		for (i = 0; i < 8; i++) {
	CLRF        main_i_L0+0 
L_main34:
	MOVLW       8
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main35
;DZ.c,281 :: 		lcd_char_my(2, i + 1, bin_str[i]);
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
;DZ.c,280 :: 		for (i = 0; i < 8; i++) {
	INCF        main_i_L0+0, 1 
;DZ.c,282 :: 		}
	GOTO        L_main34
L_main35:
;DZ.c,283 :: 		}
	GOTO        L_main28
L_main29:
;DZ.c,285 :: 		count = input_value;
	MOVF        main_input_value_L0+0, 0 
	MOVWF       main_count_L0+0 
;DZ.c,287 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,289 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       69
	MOVWF       R12, 0
	MOVLW       169
	MOVWF       R13, 0
L_main37:
	DECFSZ      R13, 1, 1
	BRA         L_main37
	DECFSZ      R12, 1, 1
	BRA         L_main37
	DECFSZ      R11, 1, 1
	BRA         L_main37
	NOP
	NOP
;DZ.c,291 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,292 :: 		lcd_char_my(1,j,'S'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       83
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,293 :: 		lcd_char_my(1,j,'E'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,294 :: 		lcd_char_my(1,j,'C'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       67
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,295 :: 		lcd_char_my(1,j,'O'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       79
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,296 :: 		lcd_char_my(1,j,'N'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,297 :: 		lcd_char_my(1,j,'D'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       68
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,298 :: 		lcd_char_my(1,j,':');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       58
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,300 :: 		uart_value = 0;
	CLRF        main_uart_value_L0+0 
	CLRF        main_uart_value_L0+1 
;DZ.c,301 :: 		while (1) {
L_main38:
;DZ.c,302 :: 		if (uart_data_ready()) {
	CALL        _uart_data_ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main40
;DZ.c,303 :: 		uart_received = uart_read();
	CALL        _uart_read+0, 0
	MOVF        R0, 0 
	MOVWF       main_uart_received_L0+0 
;DZ.c,304 :: 		if (uart_received >= '0' && uart_received <= '9') {
	MOVLW       48
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_main43
	MOVF        main_uart_received_L0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_main43
L__main56:
;DZ.c,305 :: 		uart_value = uart_value * 10 + (uart_received - '0');
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
;DZ.c,306 :: 		uart_write(uart_received);
	MOVF        main_uart_received_L0+0, 0 
	MOVWF       FARG_uart_write_my_data+0 
	CALL        _uart_write+0, 0
;DZ.c,307 :: 		}
L_main43:
;DZ.c,308 :: 		if (uart_received == 13) {
	MOVF        main_uart_received_L0+0, 0 
	XORLW       13
	BTFSS       STATUS+0, 2 
	GOTO        L_main44
;DZ.c,310 :: 		break;
	GOTO        L_main39
;DZ.c,311 :: 		}
L_main44:
;DZ.c,312 :: 		}
L_main40:
;DZ.c,313 :: 		to_binary(uart_value & 0xFF, bin_str);
	MOVLW       255
	ANDWF       main_uart_value_L0+0, 0 
	MOVWF       FARG_to_binary_val+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FARG_to_binary_buffer+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FARG_to_binary_buffer+1 
	CALL        _to_binary+0, 0
;DZ.c,314 :: 		for (i = 0; i < 8; i++) lcd_char_my(2, i + 1, bin_str[i]);
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
;DZ.c,315 :: 		}
	GOTO        L_main38
L_main39:
;DZ.c,317 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,318 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       69
	MOVWF       R12, 0
	MOVLW       169
	MOVWF       R13, 0
L_main48:
	DECFSZ      R13, 1, 1
	BRA         L_main48
	DECFSZ      R12, 1, 1
	BRA         L_main48
	DECFSZ      R11, 1, 1
	BRA         L_main48
	NOP
	NOP
;DZ.c,320 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,321 :: 		lcd_char_my(1, j, 'B');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       66
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,322 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,323 :: 		lcd_char_my(1, j, 'I');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,324 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,325 :: 		lcd_char_my(1, j, 'N');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,326 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,327 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,328 :: 		lcd_char_my(1, j, 'C');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       67
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,329 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,330 :: 		lcd_char_my(1, j, 'O');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       79
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,331 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,332 :: 		lcd_char_my(1, j, 'U');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       85
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,333 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,334 :: 		lcd_char_my(1, j, 'N');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,335 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,336 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,337 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,338 :: 		lcd_char_my(1, j, 'E');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,339 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,340 :: 		lcd_char_my(1, j, 'R');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,342 :: 		while (1) {
L_main49:
;DZ.c,343 :: 		Delay_ms(1000);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_main51:
	DECFSZ      R13, 1, 1
	BRA         L_main51
	DECFSZ      R12, 1, 1
	BRA         L_main51
	DECFSZ      R11, 1, 1
	BRA         L_main51
	NOP
;DZ.c,344 :: 		count++;
	INCF        main_count_L0+0, 1 
;DZ.c,345 :: 		if (count > 255) count = 0;
	MOVF        main_count_L0+0, 0 
	SUBLW       255
	BTFSC       STATUS+0, 0 
	GOTO        L_main52
	CLRF        main_count_L0+0 
L_main52:
;DZ.c,347 :: 		to_binary(count, bin_str);
	MOVF        main_count_L0+0, 0 
	MOVWF       FARG_to_binary_val+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FARG_to_binary_buffer+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FARG_to_binary_buffer+1 
	CALL        _to_binary+0, 0
;DZ.c,349 :: 		for (i = 0; i < 8; i++) {
	CLRF        main_i_L0+0 
L_main53:
	MOVLW       8
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main54
;DZ.c,350 :: 		lcd_char_my(2, i + 2, bin_str[i]);
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
;DZ.c,349 :: 		for (i = 0; i < 8; i++) {
	INCF        main_i_L0+0, 1 
;DZ.c,351 :: 		}
	GOTO        L_main53
L_main54:
;DZ.c,356 :: 		}
	GOTO        L_main49
;DZ.c,357 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
