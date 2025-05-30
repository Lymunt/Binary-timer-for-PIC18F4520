
_interrupt:

;DZ.c,46 :: 		void interrupt() {
;DZ.c,47 :: 		if (PIR1.RCIF == 1){
	BTFSS       PIR1+0, 5 
	GOTO        L_interrupt0
;DZ.c,48 :: 		uart_ready++;
	INCF        _uart_ready+0, 1 
;DZ.c,49 :: 		uart_input =  RCREG;
	MOVF        RCREG+0, 0 
	MOVWF       _uart_input+0 
;DZ.c,50 :: 		}
L_interrupt0:
;DZ.c,51 :: 		}
L_end_interrupt:
L__interrupt60:
	RETFIE      1
; end of _interrupt

_timer_init:

;DZ.c,53 :: 		void timer_init(){
;DZ.c,54 :: 		T0CON = 0x00;
	CLRF        T0CON+0 
;DZ.c,55 :: 		}
L_end_timer_init:
	RETURN      0
; end of _timer_init

_delay_40us:

;DZ.c,57 :: 		void delay_40us() {
;DZ.c,58 :: 		T1CON.TMR1ON = 0;
	BCF         T1CON+0, 0 
;DZ.c,59 :: 		TMR1H = 0xFF;
	MOVLW       255
	MOVWF       TMR1H+0 
;DZ.c,60 :: 		TMR1L = 0x9C;
	MOVLW       156
	MOVWF       TMR1L+0 
;DZ.c,61 :: 		PIR1.TMR1IF = 0;
	BCF         PIR1+0, 0 
;DZ.c,62 :: 		T1CON.TMR1ON = 1;
	BSF         T1CON+0, 0 
;DZ.c,64 :: 		while (!PIR1.TMR1IF);
L_delay_40us1:
	BTFSC       PIR1+0, 0 
	GOTO        L_delay_40us2
	GOTO        L_delay_40us1
L_delay_40us2:
;DZ.c,65 :: 		}
L_end_delay_40us:
	RETURN      0
; end of _delay_40us

_delay_ms_manual:

;DZ.c,67 :: 		void delay_ms_manual(unsigned int ms) {
;DZ.c,69 :: 		for (i = 0; i < ms; i++) {
	CLRF        delay_ms_manual_i_L0+0 
	CLRF        delay_ms_manual_i_L0+1 
L_delay_ms_manual3:
	MOVF        FARG_delay_ms_manual_ms+1, 0 
	SUBWF       delay_ms_manual_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__delay_ms_manual64
	MOVF        FARG_delay_ms_manual_ms+0, 0 
	SUBWF       delay_ms_manual_i_L0+0, 0 
L__delay_ms_manual64:
	BTFSC       STATUS+0, 0 
	GOTO        L_delay_ms_manual4
;DZ.c,70 :: 		for (j = 0; j < 25; j++) {  // 25 ? 40 ??? = 1 ??
	CLRF        delay_ms_manual_j_L0+0 
	CLRF        delay_ms_manual_j_L0+1 
L_delay_ms_manual6:
	MOVLW       0
	SUBWF       delay_ms_manual_j_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__delay_ms_manual65
	MOVLW       25
	SUBWF       delay_ms_manual_j_L0+0, 0 
L__delay_ms_manual65:
	BTFSC       STATUS+0, 0 
	GOTO        L_delay_ms_manual7
;DZ.c,71 :: 		delay_40us();
	CALL        _delay_40us+0, 0
;DZ.c,70 :: 		for (j = 0; j < 25; j++) {  // 25 ? 40 ??? = 1 ??
	INFSNZ      delay_ms_manual_j_L0+0, 1 
	INCF        delay_ms_manual_j_L0+1, 1 
;DZ.c,72 :: 		}
	GOTO        L_delay_ms_manual6
L_delay_ms_manual7:
;DZ.c,69 :: 		for (i = 0; i < ms; i++) {
	INFSNZ      delay_ms_manual_i_L0+0, 1 
	INCF        delay_ms_manual_i_L0+1, 1 
;DZ.c,73 :: 		}
	GOTO        L_delay_ms_manual3
L_delay_ms_manual4:
;DZ.c,74 :: 		}
L_end_delay_ms_manual:
	RETURN      0
; end of _delay_ms_manual

_to_binary:

;DZ.c,76 :: 		void to_binary(unsigned char val, char *buffer) {
;DZ.c,77 :: 		int i = 0;
	CLRF        to_binary_i_L0+0 
	CLRF        to_binary_i_L0+1 
;DZ.c,78 :: 		for ( i = 7; i >= 0; i--) {
	MOVLW       7
	MOVWF       to_binary_i_L0+0 
	MOVLW       0
	MOVWF       to_binary_i_L0+1 
L_to_binary9:
	MOVLW       128
	XORWF       to_binary_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__to_binary67
	MOVLW       0
	SUBWF       to_binary_i_L0+0, 0 
L__to_binary67:
	BTFSS       STATUS+0, 0 
	GOTO        L_to_binary10
;DZ.c,79 :: 		buffer[7 - i] = (val & (1 << i)) ? '1' : '0';
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
L__to_binary68:
	BZ          L__to_binary69
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__to_binary68
L__to_binary69:
	MOVF        FARG_to_binary_val+0, 0 
	ANDWF       R0, 1 
	MOVLW       0
	ANDWF       R1, 1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_to_binary12
	MOVLW       49
	MOVWF       R5 
	GOTO        L_to_binary13
L_to_binary12:
	MOVLW       48
	MOVWF       R5 
L_to_binary13:
	MOVFF       R3, FSR1L+0
	MOVFF       R4, FSR1H+0
	MOVF        R5, 0 
	MOVWF       POSTINC1+0 
;DZ.c,78 :: 		for ( i = 7; i >= 0; i--) {
	MOVLW       1
	SUBWF       to_binary_i_L0+0, 1 
	MOVLW       0
	SUBWFB      to_binary_i_L0+1, 1 
;DZ.c,80 :: 		}
	GOTO        L_to_binary9
L_to_binary10:
;DZ.c,81 :: 		buffer[8] = '\0';
	MOVLW       8
	ADDWF       FARG_to_binary_buffer+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       0
	ADDWFC      FARG_to_binary_buffer+1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
;DZ.c,82 :: 		}
L_end_to_binary:
	RETURN      0
; end of _to_binary

_pulse_e:

;DZ.c,84 :: 		void pulse_e() {
;DZ.c,85 :: 		LCD_EN = 1;
	BSF         LATB5_bit+0, BitPos(LATB5_bit+0) 
;DZ.c,86 :: 		delay_40us();
	CALL        _delay_40us+0, 0
;DZ.c,87 :: 		LCD_EN = 0;
	BCF         LATB5_bit+0, BitPos(LATB5_bit+0) 
;DZ.c,88 :: 		delay_40us();
	CALL        _delay_40us+0, 0
;DZ.c,90 :: 		}
L_end_pulse_e:
	RETURN      0
; end of _pulse_e

_lcd_cmd_4:

;DZ.c,92 :: 		void lcd_cmd_4(unsigned char cmd){
;DZ.c,93 :: 		LCD_D4 = (cmd >> 0) & 1;
	MOVLW       1
	ANDWF       FARG_lcd_cmd_4_cmd+0, 0 
	MOVWF       R0 
	BTFSC       R0, 0 
	GOTO        L__lcd_cmd_472
	BCF         LATD4_bit+0, BitPos(LATD4_bit+0) 
	GOTO        L__lcd_cmd_473
L__lcd_cmd_472:
	BSF         LATD4_bit+0, BitPos(LATD4_bit+0) 
L__lcd_cmd_473:
;DZ.c,94 :: 		LCD_D5 = (cmd >> 1) & 1;
	MOVF        FARG_lcd_cmd_4_cmd+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       1
	ANDWF       R0, 1 
	BTFSC       R0, 0 
	GOTO        L__lcd_cmd_474
	BCF         LATD5_bit+0, BitPos(LATD5_bit+0) 
	GOTO        L__lcd_cmd_475
L__lcd_cmd_474:
	BSF         LATD5_bit+0, BitPos(LATD5_bit+0) 
L__lcd_cmd_475:
;DZ.c,95 :: 		LCD_D6 = (cmd >> 2) & 1;
	MOVF        FARG_lcd_cmd_4_cmd+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       1
	ANDWF       R0, 1 
	BTFSC       R0, 0 
	GOTO        L__lcd_cmd_476
	BCF         LATD6_bit+0, BitPos(LATD6_bit+0) 
	GOTO        L__lcd_cmd_477
L__lcd_cmd_476:
	BSF         LATD6_bit+0, BitPos(LATD6_bit+0) 
L__lcd_cmd_477:
;DZ.c,96 :: 		LCD_D7 = (cmd >> 3) & 1;
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
	GOTO        L__lcd_cmd_478
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
	GOTO        L__lcd_cmd_479
L__lcd_cmd_478:
	BSF         LATD7_bit+0, BitPos(LATD7_bit+0) 
L__lcd_cmd_479:
;DZ.c,97 :: 		}
L_end_lcd_cmd_4:
	RETURN      0
; end of _lcd_cmd_4

_lcd_cmd_my:

;DZ.c,99 :: 		void lcd_cmd_my(unsigned char cmd){
;DZ.c,100 :: 		LCD_RS = 0;
	BCF         LATB2_bit+0, BitPos(LATB2_bit+0) 
;DZ.c,101 :: 		lcd_cmd_4(cmd >> 4);
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
;DZ.c,102 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,103 :: 		lcd_cmd_4(cmd & 0x0F);
	MOVLW       15
	ANDWF       FARG_lcd_cmd_my_cmd+0, 0 
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,104 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,105 :: 		}
L_end_lcd_cmd_my:
	RETURN      0
; end of _lcd_cmd_my

_lcd_char_my:

;DZ.c,107 :: 		void lcd_char_my(unsigned char row, unsigned char column, unsigned char cmd){
;DZ.c,111 :: 		if (row == 1)
	MOVF        FARG_lcd_char_my_row+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_lcd_char_my14
;DZ.c,112 :: 		adress = 0x80 + (column - 1);
	DECF        FARG_lcd_char_my_column+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDLW       128
	MOVWF       lcd_char_my_adress_L0+0 
	GOTO        L_lcd_char_my15
L_lcd_char_my14:
;DZ.c,113 :: 		else if (row == 2)
	MOVF        FARG_lcd_char_my_row+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_lcd_char_my16
;DZ.c,114 :: 		adress = 0xC0 + (column - 1);
	DECF        FARG_lcd_char_my_column+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDLW       192
	MOVWF       lcd_char_my_adress_L0+0 
L_lcd_char_my16:
L_lcd_char_my15:
;DZ.c,116 :: 		lcd_cmd_my(adress);
	MOVF        lcd_char_my_adress_L0+0, 0 
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,118 :: 		LCD_RS = 1;
	BSF         LATB2_bit+0, BitPos(LATB2_bit+0) 
;DZ.c,119 :: 		lcd_cmd_4(cmd >> 4);
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
;DZ.c,120 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,121 :: 		lcd_cmd_4(cmd & 0x0F);
	MOVLW       15
	ANDWF       FARG_lcd_char_my_cmd+0, 0 
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,122 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,123 :: 		}
L_end_lcd_char_my:
	RETURN      0
; end of _lcd_char_my

_lcd_init_r:

;DZ.c,125 :: 		void lcd_init_r(){
;DZ.c,127 :: 		lcd_cmd_4(0x03);
	MOVLW       3
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,129 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,131 :: 		delay_40us();
	CALL        _delay_40us+0, 0
;DZ.c,132 :: 		}
L_end_lcd_init_r:
	RETURN      0
; end of _lcd_init_r

_lcd_init_all:

;DZ.c,134 :: 		void lcd_init_all(){
;DZ.c,136 :: 		delay_ms_manual(20);
	MOVLW       20
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       0
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,138 :: 		lcd_init_r();
	CALL        _lcd_init_r+0, 0
;DZ.c,140 :: 		lcd_init_r();
	CALL        _lcd_init_r+0, 0
;DZ.c,142 :: 		lcd_init_r();
	CALL        _lcd_init_r+0, 0
;DZ.c,144 :: 		lcd_cmd_4(0x02);
	MOVLW       2
	MOVWF       FARG_lcd_cmd_4_cmd+0 
	CALL        _lcd_cmd_4+0, 0
;DZ.c,145 :: 		pulse_e();
	CALL        _pulse_e+0, 0
;DZ.c,147 :: 		lcd_cmd_my(0x28);
	MOVLW       40
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,149 :: 		lcd_cmd_my(0x0F);
	MOVLW       15
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,151 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,153 :: 		lcd_cmd_my(0x06);
	MOVLW       6
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,154 :: 		}
L_end_lcd_init_all:
	RETURN      0
; end of _lcd_init_all

_check_rows:

;DZ.c,156 :: 		unsigned char check_rows(){
;DZ.c,157 :: 		unsigned char row_result = 0;
	CLRF        check_rows_row_result_L0+0 
;DZ.c,159 :: 		if(ROW_0 == 1){
	BTFSS       RA4_bit+0, BitPos(RA4_bit+0) 
	GOTO        L_check_rows17
;DZ.c,160 :: 		row_result = 0x10;
	MOVLW       16
	MOVWF       check_rows_row_result_L0+0 
;DZ.c,161 :: 		return row_result;
	MOVLW       16
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,162 :: 		}
L_check_rows17:
;DZ.c,163 :: 		if(ROW_1 == 1){
	BTFSS       RA5_bit+0, BitPos(RA5_bit+0) 
	GOTO        L_check_rows18
;DZ.c,164 :: 		row_result = 0x14;
	MOVLW       20
	MOVWF       check_rows_row_result_L0+0 
;DZ.c,165 :: 		return row_result;
	MOVLW       20
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,166 :: 		}
L_check_rows18:
;DZ.c,167 :: 		if(ROW_2 == 1){
	BTFSS       RA6_bit+0, BitPos(RA6_bit+0) 
	GOTO        L_check_rows19
;DZ.c,168 :: 		row_result = 0x18;
	MOVLW       24
	MOVWF       check_rows_row_result_L0+0 
;DZ.c,169 :: 		return row_result;
	MOVLW       24
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,170 :: 		}
L_check_rows19:
;DZ.c,171 :: 		if(ROW_3 == 1){
	BTFSS       RA7_bit+0, BitPos(RA7_bit+0) 
	GOTO        L_check_rows20
;DZ.c,172 :: 		row_result = 0x1C;
	MOVLW       28
	MOVWF       check_rows_row_result_L0+0 
;DZ.c,173 :: 		return row_result;
	MOVLW       28
	MOVWF       R0 
	GOTO        L_end_check_rows
;DZ.c,174 :: 		}
L_check_rows20:
;DZ.c,175 :: 		return row_result;
	MOVF        check_rows_row_result_L0+0, 0 
	MOVWF       R0 
;DZ.c,176 :: 		}
L_end_check_rows:
	RETURN      0
; end of _check_rows

_check_keyboard:

;DZ.c,178 :: 		unsigned char check_keyboard(){
;DZ.c,179 :: 		unsigned char keyboard_result = 0;
	CLRF        check_keyboard_keyboard_result_L0+0 
	CLRF        check_keyboard_row_result_L0+0 
;DZ.c,184 :: 		COL_0 = 1;
	BSF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;DZ.c,185 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,186 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard21
;DZ.c,187 :: 		delay_ms_manual(200);
	MOVLW       200
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       0
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,188 :: 		keyboard_result = 0x00+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	MOVWF       check_keyboard_keyboard_result_L0+0 
;DZ.c,190 :: 		return keyboard_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_check_keyboard
;DZ.c,191 :: 		}
L_check_keyboard21:
;DZ.c,192 :: 		COL_0 = 0;
	BCF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;DZ.c,194 :: 		COL_1 = 1;
	BSF         LATA1_bit+0, BitPos(LATA1_bit+0) 
;DZ.c,195 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,196 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard22
;DZ.c,197 :: 		delay_ms_manual(200);
	MOVLW       200
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       0
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,198 :: 		keyboard_result = 0x01+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       check_keyboard_keyboard_result_L0+0 
;DZ.c,200 :: 		return keyboard_result;
	GOTO        L_end_check_keyboard
;DZ.c,201 :: 		}
L_check_keyboard22:
;DZ.c,202 :: 		COL_1 = 0;
	BCF         LATA1_bit+0, BitPos(LATA1_bit+0) 
;DZ.c,204 :: 		COL_2 = 1;
	BSF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;DZ.c,205 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,206 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard23
;DZ.c,207 :: 		delay_ms_manual(200);
	MOVLW       200
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       0
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,208 :: 		keyboard_result = 0x02+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	ADDLW       2
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       check_keyboard_keyboard_result_L0+0 
;DZ.c,210 :: 		return keyboard_result;
	GOTO        L_end_check_keyboard
;DZ.c,211 :: 		}
L_check_keyboard23:
;DZ.c,212 :: 		COL_2 = 0;
	BCF         LATA2_bit+0, BitPos(LATA2_bit+0) 
;DZ.c,214 :: 		COL_3 = 1;
	BSF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;DZ.c,215 :: 		row_result =  check_rows();
	CALL        _check_rows+0, 0
	MOVF        R0, 0 
	MOVWF       check_keyboard_row_result_L0+0 
;DZ.c,216 :: 		if(row_result !=0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_check_keyboard24
;DZ.c,217 :: 		delay_ms_manual(200);
	MOVLW       200
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       0
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,218 :: 		keyboard_result = 0x03+row_result;
	MOVF        check_keyboard_row_result_L0+0, 0 
	ADDLW       3
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       check_keyboard_keyboard_result_L0+0 
;DZ.c,220 :: 		return keyboard_result;
	GOTO        L_end_check_keyboard
;DZ.c,221 :: 		}
L_check_keyboard24:
;DZ.c,222 :: 		COL_3 = 0;
	BCF         LATA3_bit+0, BitPos(LATA3_bit+0) 
;DZ.c,224 :: 		return keyboard_result;
	MOVF        check_keyboard_keyboard_result_L0+0, 0 
	MOVWF       R0 
;DZ.c,225 :: 		}
L_end_check_keyboard:
	RETURN      0
; end of _check_keyboard

_uart_init:

;DZ.c,227 :: 		void uart_init(){
;DZ.c,229 :: 		UART_OUT_Direction = 1;
	BSF         TRISC6_bit+0, BitPos(TRISC6_bit+0) 
;DZ.c,230 :: 		UART_IN_Direction = 1;
	BSF         TRISC7_bit+0, BitPos(TRISC7_bit+0) 
;DZ.c,232 :: 		SPBRG = 15;
	MOVLW       15
	MOVWF       SPBRG+0 
;DZ.c,233 :: 		TXSTA = 0x00;
	CLRF        TXSTA+0 
;DZ.c,234 :: 		RCSTA.SPEN = 1;
	BSF         RCSTA+0, 7 
;DZ.c,235 :: 		RCSTA.CREN = 1;
	BSF         RCSTA+0, 4 
;DZ.c,237 :: 		PIE1.RCIE = 1;
	BSF         PIE1+0, 5 
;DZ.c,239 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;DZ.c,240 :: 		INTCON.GIEL = 1;
	BSF         INTCON+0, 6 
;DZ.c,241 :: 		}
L_end_uart_init:
	RETURN      0
; end of _uart_init

_main:

;DZ.c,243 :: 		void main() {
;DZ.c,244 :: 		unsigned char count = 0;
	CLRF        main_count_L0+0 
	CLRF        main_second_input_L0+0 
	CLRF        main_i_L0+0 
	MOVLW       1
	MOVWF       main_j_L0+0 
	CLRF        main_input_value_L0+0 
	CLRF        main_keyboard_result_L0+0 
;DZ.c,254 :: 		ADCON1 = 0x0F;
	MOVLW       15
	MOVWF       ADCON1+0 
;DZ.c,256 :: 		LCD_RS_Direction =0;
	BCF         TRISB2_bit+0, BitPos(TRISB2_bit+0) 
;DZ.c,257 :: 		LCD_EN_Direction =0;
	BCF         TRISB5_bit+0, BitPos(TRISB5_bit+0) 
;DZ.c,258 :: 		LCD_D4_Direction =0;
	BCF         TRISD4_bit+0, BitPos(TRISD4_bit+0) 
;DZ.c,259 :: 		LCD_D5_Direction =0;
	BCF         TRISD5_bit+0, BitPos(TRISD5_bit+0) 
;DZ.c,260 :: 		LCD_D6_Direction =0;
	BCF         TRISD6_bit+0, BitPos(TRISD6_bit+0) 
;DZ.c,261 :: 		LCD_D7_Direction =0;
	BCF         TRISD7_bit+0, BitPos(TRISD7_bit+0) 
;DZ.c,263 :: 		COL_0_Direction =0;
	BCF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;DZ.c,264 :: 		COL_1_Direction =0;
	BCF         TRISA1_bit+0, BitPos(TRISA1_bit+0) 
;DZ.c,265 :: 		COL_2_Direction =0;
	BCF         TRISA2_bit+0, BitPos(TRISA2_bit+0) 
;DZ.c,266 :: 		COL_3_Direction =0;
	BCF         TRISA3_bit+0, BitPos(TRISA3_bit+0) 
;DZ.c,268 :: 		ROW_0_Direction =1;
	BSF         TRISA4_bit+0, BitPos(TRISA4_bit+0) 
;DZ.c,269 :: 		ROW_1_Direction =1;
	BSF         TRISA5_bit+0, BitPos(TRISA5_bit+0) 
;DZ.c,270 :: 		ROW_2_Direction =1;
	BSF         TRISA6_bit+0, BitPos(TRISA6_bit+0) 
;DZ.c,271 :: 		ROW_3_Direction =1;
	BSF         TRISA7_bit+0, BitPos(TRISA7_bit+0) 
;DZ.c,273 :: 		TRISD.B0 = 0;
	BCF         TRISD+0, 0 
;DZ.c,275 :: 		timer_init();
	CALL        _timer_init+0, 0
;DZ.c,277 :: 		uart_init();
	CALL        _uart_init+0, 0
;DZ.c,279 :: 		lcd_init_all();
	CALL        _lcd_init_all+0, 0
;DZ.c,281 :: 		delay_ms_manual(10);
	MOVLW       10
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       0
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,283 :: 		while(1){
L_main25:
;DZ.c,284 :: 		delay_ms_manual(1000);
	MOVLW       232
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       3
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,285 :: 		i = 0;
	CLRF        main_i_L0+0 
;DZ.c,286 :: 		j = 0;
	CLRF        main_j_L0+0 
;DZ.c,288 :: 		second_input = 0;
	CLRF        main_second_input_L0+0 
;DZ.c,289 :: 		uart_input = 0;
	CLRF        _uart_input+0 
;DZ.c,290 :: 		input_value = 0;
	CLRF        main_input_value_L0+0 
;DZ.c,291 :: 		keyboard_result = 0;
	CLRF        main_keyboard_result_L0+0 
;DZ.c,292 :: 		uart_ready = 0;
	CLRF        _uart_ready+0 
;DZ.c,294 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,295 :: 		lcd_char_my(1,j,'S');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       83
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,296 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,297 :: 		lcd_char_my(1,j,'E');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,298 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,299 :: 		lcd_char_my(1,j,'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,300 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,301 :: 		lcd_char_my(1,j,':');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       58
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,302 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,303 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,305 :: 		j=1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,307 :: 		delay_ms_manual(10);
	MOVLW       10
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       0
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,309 :: 		while (keyboard_result !=0x12) {
L_main27:
	MOVF        main_keyboard_result_L0+0, 0 
	XORLW       18
	BTFSC       STATUS+0, 2 
	GOTO        L_main28
;DZ.c,311 :: 		keyboard_result = check_keyboard();
	CALL        _check_keyboard+0, 0
	MOVF        R0, 0 
	MOVWF       main_keyboard_result_L0+0 
;DZ.c,313 :: 		if (keyboard_result == 0x10) {
	MOVF        R0, 0 
	XORLW       16
	BTFSS       STATUS+0, 2 
	GOTO        L_main29
;DZ.c,314 :: 		input_value <<= 1;
	RLCF        main_input_value_L0+0, 1 
	BCF         main_input_value_L0+0, 0 
;DZ.c,315 :: 		}
L_main29:
;DZ.c,316 :: 		if (keyboard_result == 0x11) {
	MOVF        main_keyboard_result_L0+0, 0 
	XORLW       17
	BTFSS       STATUS+0, 2 
	GOTO        L_main30
;DZ.c,317 :: 		input_value = (input_value << 1) | 1;
	RLCF        main_input_value_L0+0, 1 
	BCF         main_input_value_L0+0, 0 
	BSF         main_input_value_L0+0, 0 
;DZ.c,318 :: 		}
L_main30:
;DZ.c,319 :: 		if (keyboard_result == 0x12) {
	MOVF        main_keyboard_result_L0+0, 0 
	XORLW       18
	BTFSS       STATUS+0, 2 
	GOTO        L_main31
;DZ.c,320 :: 		lcd_char_my(1, j, 'S');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       83
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,321 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,322 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,323 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,324 :: 		lcd_char_my(1, j, 'A');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       65
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,325 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,326 :: 		lcd_char_my(1, j, 'R');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,327 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,328 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,329 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,330 :: 		lcd_char_my(1, j, 'I');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,331 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,332 :: 		lcd_char_my(1, j, 'N');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,333 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,334 :: 		lcd_char_my(1, j, 'G');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       71
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,335 :: 		delay_ms_manual(2000);
	MOVLW       208
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       7
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,336 :: 		}
L_main31:
;DZ.c,338 :: 		if(keyboard_result == 0x13){
	MOVF        main_keyboard_result_L0+0, 0 
	XORLW       19
	BTFSS       STATUS+0, 2 
	GOTO        L_main32
;DZ.c,339 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,340 :: 		lcd_char_my(1,j,'B'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       66
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,341 :: 		lcd_char_my(1,j,'R'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,342 :: 		lcd_char_my(1,j,'E'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,343 :: 		lcd_char_my(1,j,'A'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       65
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,344 :: 		lcd_char_my(1,j,'K'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       75
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,345 :: 		lcd_char_my(1,j,'I'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,346 :: 		lcd_char_my(1,j,'N'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,347 :: 		lcd_char_my(1,j,'G'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       71
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,348 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,349 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,350 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,351 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,352 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,353 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,354 :: 		delay_ms_manual(2000);
	MOVLW       208
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       7
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,355 :: 		input_value = 0;
	CLRF        main_input_value_L0+0 
;DZ.c,356 :: 		break;
	GOTO        L_main28
;DZ.c,357 :: 		}
L_main32:
;DZ.c,359 :: 		to_binary(input_value, bin_str);
	MOVF        main_input_value_L0+0, 0 
	MOVWF       FARG_to_binary_val+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FARG_to_binary_buffer+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FARG_to_binary_buffer+1 
	CALL        _to_binary+0, 0
;DZ.c,360 :: 		for (i = 0; i < 8; i++) {
	CLRF        main_i_L0+0 
L_main33:
	MOVLW       8
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main34
;DZ.c,361 :: 		lcd_char_my(2, i + 1, bin_str[i]);
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
;DZ.c,360 :: 		for (i = 0; i < 8; i++) {
	INCF        main_i_L0+0, 1 
;DZ.c,362 :: 		}
	GOTO        L_main33
L_main34:
;DZ.c,363 :: 		}
	GOTO        L_main27
L_main28:
;DZ.c,365 :: 		count = input_value;
	MOVF        main_input_value_L0+0, 0 
	MOVWF       main_count_L0+0 
;DZ.c,367 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,369 :: 		delay_ms_manual(100);
	MOVLW       100
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       0
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,371 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,372 :: 		lcd_char_my(1,j,'S'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       83
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,373 :: 		lcd_char_my(1,j,'E'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,374 :: 		lcd_char_my(1,j,'C'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       67
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,375 :: 		lcd_char_my(1,j,'O'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       79
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,376 :: 		lcd_char_my(1,j,'N'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,377 :: 		lcd_char_my(1,j,'D'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       68
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,378 :: 		lcd_char_my(1,j,':');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       58
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,380 :: 		while (1) {
L_main36:
;DZ.c,381 :: 		keyboard_result = check_keyboard();
	CALL        _check_keyboard+0, 0
	MOVF        R0, 0 
	MOVWF       main_keyboard_result_L0+0 
;DZ.c,382 :: 		if(keyboard_result == 0x13){
	MOVF        R0, 0 
	XORLW       19
	BTFSS       STATUS+0, 2 
	GOTO        L_main38
;DZ.c,383 :: 		second_input = 255;
	MOVLW       255
	MOVWF       main_second_input_L0+0 
;DZ.c,384 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,385 :: 		lcd_char_my(1,j,'B'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       66
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,386 :: 		lcd_char_my(1,j,'R'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,387 :: 		lcd_char_my(1,j,'E'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,388 :: 		lcd_char_my(1,j,'A'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       65
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,389 :: 		lcd_char_my(1,j,'K'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       75
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,390 :: 		lcd_char_my(1,j,'I'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,391 :: 		lcd_char_my(1,j,'N'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,392 :: 		lcd_char_my(1,j,'G'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       71
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,393 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,394 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,395 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,396 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,397 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,398 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,400 :: 		to_binary(second_input, bin_str);
	MOVF        main_second_input_L0+0, 0 
	MOVWF       FARG_to_binary_val+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FARG_to_binary_buffer+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FARG_to_binary_buffer+1 
	CALL        _to_binary+0, 0
;DZ.c,401 :: 		for (i = 0; i < 8; i++) lcd_char_my(2, i + 1, bin_str[i]);
	CLRF        main_i_L0+0 
L_main39:
	MOVLW       8
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main40
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
	GOTO        L_main39
L_main40:
;DZ.c,403 :: 		delay_ms_manual(2000);
	MOVLW       208
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       7
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,404 :: 		break;
	GOTO        L_main37
;DZ.c,405 :: 		}
L_main38:
;DZ.c,407 :: 		if (uart_ready >0) {
	MOVF        _uart_ready+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_main42
;DZ.c,408 :: 		second_input = uart_input;
	MOVF        _uart_input+0, 0 
	MOVWF       main_second_input_L0+0 
;DZ.c,409 :: 		to_binary(second_input, bin_str);
	MOVF        _uart_input+0, 0 
	MOVWF       FARG_to_binary_val+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FARG_to_binary_buffer+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FARG_to_binary_buffer+1 
	CALL        _to_binary+0, 0
;DZ.c,410 :: 		for (i = 0; i < 8; i++) lcd_char_my(2, i + 1, bin_str[i]);
	CLRF        main_i_L0+0 
L_main43:
	MOVLW       8
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main44
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
	GOTO        L_main43
L_main44:
;DZ.c,412 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,413 :: 		lcd_char_my(1, j, 'S');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       83
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,414 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,415 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,416 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,417 :: 		lcd_char_my(1, j, 'A');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       65
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,418 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,419 :: 		lcd_char_my(1, j, 'R');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,420 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,421 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,422 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,423 :: 		lcd_char_my(1, j, 'I');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,424 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,425 :: 		lcd_char_my(1, j, 'N');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,426 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,427 :: 		lcd_char_my(1, j, 'G');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       71
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,428 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,429 :: 		lcd_char_my(1, j, ' ');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,431 :: 		delay_ms_manual(2000);
	MOVLW       208
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       7
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,432 :: 		break;
	GOTO        L_main37
;DZ.c,433 :: 		}
L_main42:
;DZ.c,434 :: 		}
	GOTO        L_main36
L_main37:
;DZ.c,436 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,437 :: 		delay_ms_manual(100);
	MOVLW       100
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       0
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,439 :: 		if(second_input==count){
	MOVF        main_second_input_L0+0, 0 
	XORWF       main_count_L0+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_main46
;DZ.c,440 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,441 :: 		lcd_char_my(2, j, 'X');
	MOVLW       2
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       88
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,442 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,443 :: 		lcd_char_my(2, j, '=');
	MOVLW       2
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       61
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,444 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,445 :: 		lcd_char_my(2, j, 'Y');
	MOVLW       2
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       89
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,446 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,447 :: 		delay_ms_manual(5000);
	MOVLW       136
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       19
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,448 :: 		}else if(second_input<count){
	GOTO        L_main47
L_main46:
	MOVF        main_count_L0+0, 0 
	SUBWF       main_second_input_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main48
;DZ.c,449 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,450 :: 		lcd_char_my(2, j, 'X');
	MOVLW       2
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       88
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,451 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,452 :: 		lcd_char_my(2, j, '<');
	MOVLW       2
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       60
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,453 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,454 :: 		lcd_char_my(2, j, 'Y');
	MOVLW       2
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       89
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,455 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,456 :: 		delay_ms_manual(5000);
	MOVLW       136
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       19
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,457 :: 		}else{
	GOTO        L_main49
L_main48:
;DZ.c,459 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,460 :: 		lcd_char_my(1, j, 'B');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       66
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,461 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,462 :: 		lcd_char_my(1, j, 'I');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,463 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,464 :: 		lcd_char_my(1, j, 'N');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,465 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,466 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,467 :: 		lcd_char_my(1, j, 'C');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       67
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,468 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,469 :: 		lcd_char_my(1, j, 'O');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       79
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,470 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,471 :: 		lcd_char_my(1, j, 'U');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       85
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,472 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,473 :: 		lcd_char_my(1, j, 'N');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,474 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,475 :: 		lcd_char_my(1, j, 'T');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,476 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,477 :: 		lcd_char_my(1, j, 'E');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,478 :: 		j++;
	INCF        main_j_L0+0, 1 
;DZ.c,479 :: 		lcd_char_my(1, j, 'R');
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
;DZ.c,481 :: 		to_binary(count, bin_str);
	MOVF        main_count_L0+0, 0 
	MOVWF       FARG_to_binary_val+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FARG_to_binary_buffer+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FARG_to_binary_buffer+1 
	CALL        _to_binary+0, 0
;DZ.c,483 :: 		for (i = 0; i < 8; i++) {
	CLRF        main_i_L0+0 
L_main50:
	MOVLW       8
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main51
;DZ.c,484 :: 		lcd_char_my(2, i + 2, bin_str[i]);
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
;DZ.c,483 :: 		for (i = 0; i < 8; i++) {
	INCF        main_i_L0+0, 1 
;DZ.c,485 :: 		}
	GOTO        L_main50
L_main51:
;DZ.c,486 :: 		delay_ms_manual(1000);
	MOVLW       232
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       3
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,488 :: 		while (count<second_input) {
L_main53:
	MOVF        main_second_input_L0+0, 0 
	SUBWF       main_count_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main54
;DZ.c,489 :: 		keyboard_result = check_keyboard();
	CALL        _check_keyboard+0, 0
	MOVF        R0, 0 
	MOVWF       main_keyboard_result_L0+0 
;DZ.c,490 :: 		if(keyboard_result == 0x13){
	MOVF        R0, 0 
	XORLW       19
	BTFSS       STATUS+0, 2 
	GOTO        L_main55
;DZ.c,491 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,492 :: 		lcd_char_my(1,j,'B'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       66
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,493 :: 		lcd_char_my(1,j,'R'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,494 :: 		lcd_char_my(1,j,'E'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,495 :: 		lcd_char_my(1,j,'A'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       65
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,496 :: 		lcd_char_my(1,j,'K'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       75
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,497 :: 		lcd_char_my(1,j,'I'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,498 :: 		lcd_char_my(1,j,'N'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,499 :: 		lcd_char_my(1,j,'G'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       71
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,500 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,502 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,503 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,504 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,505 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,506 :: 		lcd_char_my(1,j,' '); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       32
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,507 :: 		delay_ms_manual(5000);
	MOVLW       136
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       19
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,508 :: 		break;
	GOTO        L_main54
;DZ.c,509 :: 		}
L_main55:
;DZ.c,510 :: 		count++;
	INCF        main_count_L0+0, 1 
;DZ.c,512 :: 		to_binary(count, bin_str);
	MOVF        main_count_L0+0, 0 
	MOVWF       FARG_to_binary_val+0 
	MOVLW       main_bin_str_L0+0
	MOVWF       FARG_to_binary_buffer+0 
	MOVLW       hi_addr(main_bin_str_L0+0)
	MOVWF       FARG_to_binary_buffer+1 
	CALL        _to_binary+0, 0
;DZ.c,514 :: 		for (i = 0; i < 8; i++) {
	CLRF        main_i_L0+0 
L_main56:
	MOVLW       8
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main57
;DZ.c,515 :: 		lcd_char_my(2, i + 2, bin_str[i]);
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
;DZ.c,514 :: 		for (i = 0; i < 8; i++) {
	INCF        main_i_L0+0, 1 
;DZ.c,516 :: 		}
	GOTO        L_main56
L_main57:
;DZ.c,518 :: 		delay_ms_manual(1000);
	MOVLW       232
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       3
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,520 :: 		}
	GOTO        L_main53
L_main54:
;DZ.c,521 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,522 :: 		delay_ms_manual(100);
	MOVLW       100
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       0
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,523 :: 		}
L_main49:
L_main47:
;DZ.c,524 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,525 :: 		delay_ms_manual(100);
	MOVLW       100
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       0
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,527 :: 		j = 1;
	MOVLW       1
	MOVWF       main_j_L0+0 
;DZ.c,528 :: 		lcd_char_my(1,j,'R'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVLW       1
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,529 :: 		lcd_char_my(1,j,'E'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       69
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,530 :: 		lcd_char_my(1,j,'S'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       83
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,531 :: 		lcd_char_my(1,j,'T'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,532 :: 		lcd_char_my(1,j,'A'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       65
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,533 :: 		lcd_char_my(1,j,'R'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       82
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,534 :: 		lcd_char_my(1,j,'T'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       84
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,535 :: 		lcd_char_my(1,j,'I'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       73
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,536 :: 		lcd_char_my(1,j,'N'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       78
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,537 :: 		lcd_char_my(1,j,'G'); j++;
	MOVLW       1
	MOVWF       FARG_lcd_char_my_row+0 
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_lcd_char_my_column+0 
	MOVLW       71
	MOVWF       FARG_lcd_char_my_cmd+0 
	CALL        _lcd_char_my+0, 0
	INCF        main_j_L0+0, 1 
;DZ.c,539 :: 		delay_ms_manual(2000);
	MOVLW       208
	MOVWF       FARG_delay_ms_manual_ms+0 
	MOVLW       7
	MOVWF       FARG_delay_ms_manual_ms+1 
	CALL        _delay_ms_manual+0, 0
;DZ.c,541 :: 		lcd_cmd_my(0x01);
	MOVLW       1
	MOVWF       FARG_lcd_cmd_my_cmd+0 
	CALL        _lcd_cmd_my+0, 0
;DZ.c,542 :: 		}
	GOTO        L_main25
;DZ.c,543 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
