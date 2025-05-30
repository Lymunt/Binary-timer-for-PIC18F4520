#line 1 "C:/Users/owner/Desktop/Git for PIC18F4520/Code-for-PIC18F4520/microC/DZ.c"
sbit LCD_RS at LATB2_bit;
sbit LCD_EN at LATB5_bit;
sbit LCD_D4 at LATD4_bit;
sbit LCD_D5 at LATD5_bit;
sbit LCD_D6 at LATD6_bit;
sbit LCD_D7 at LATD7_bit;

sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISD4_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D7_Direction at TRISD7_bit;

sbit COL_0 at LATA0_bit;
sbit COL_1 at LATA1_bit;
sbit COL_2 at LATA2_bit;
sbit COL_3 at LATA3_bit;

sbit ROW_0 at RA4_bit;
sbit ROW_1 at RA5_bit;
sbit ROW_2 at RA6_bit;
sbit ROW_3 at RA7_bit;

sbit COL_0_Direction at TRISA0_bit;
sbit COL_1_Direction at TRISA1_bit;
sbit COL_2_Direction at TRISA2_bit;
sbit COL_3_Direction at TRISA3_bit;

sbit ROW_0_Direction at TRISA4_bit;
sbit ROW_1_Direction at TRISA5_bit;
sbit ROW_2_Direction at TRISA6_bit;
sbit ROW_3_Direction at TRISA7_bit;

sbit UART_OUT at LATC6_bit;
sbit UART_IN at RC7_bit;

sbit UART_OUT_Direction at TRISC6_bit;
sbit UART_IN_Direction at TRISC7_bit;

unsigned char uart_ready = 0;
unsigned char uart_input = 0;



void interrupt() {
 if (PIR1.RCIF == 1){
 uart_ready++;
 uart_input = RCREG;
 }
}

void timer_init(){
 T0CON = 0x00;
}

void delay_40us() {
 T1CON.TMR1ON = 0;
 TMR1H = 0xFF;
 TMR1L = 0x9C;
 PIR1.TMR1IF = 0;
 T1CON.TMR1ON = 1;

 while (!PIR1.TMR1IF);
}

void delay_ms_manual(unsigned int ms) {
 unsigned int i, j;
 for (i = 0; i < ms; i++) {
 for (j = 0; j < 25; j++) {
 delay_40us();
 }
 }
}

void to_binary(unsigned char val, char *buffer) {
 int i = 0;
 for ( i = 7; i >= 0; i--) {
 buffer[7 - i] = (val & (1 << i)) ? '1' : '0';
 }
 buffer[8] = '\0';
}

void pulse_e() {
 LCD_EN = 1;
 delay_40us();
 LCD_EN = 0;
 delay_40us();

}

void lcd_cmd_4(unsigned char cmd){
 LCD_D4 = (cmd >> 0) & 1;
 LCD_D5 = (cmd >> 1) & 1;
 LCD_D6 = (cmd >> 2) & 1;
 LCD_D7 = (cmd >> 3) & 1;
}

void lcd_cmd_my(unsigned char cmd){
 LCD_RS = 0;
 lcd_cmd_4(cmd >> 4);
 pulse_e();
 lcd_cmd_4(cmd & 0x0F);
 pulse_e();
}

void lcd_char_my(unsigned char row, unsigned char column, unsigned char cmd){

 unsigned char adress;

 if (row == 1)
 adress = 0x80 + (column - 1);
 else if (row == 2)
 adress = 0xC0 + (column - 1);

 lcd_cmd_my(adress);

 LCD_RS = 1;
 lcd_cmd_4(cmd >> 4);
 pulse_e();
 lcd_cmd_4(cmd & 0x0F);
 pulse_e();
}

void lcd_init_r(){

 lcd_cmd_4(0x03);

 pulse_e();

 delay_40us();
}

void lcd_init_all(){

 delay_ms_manual(20);

 lcd_init_r();

 lcd_init_r();

 lcd_init_r();

 lcd_cmd_4(0x02);
 pulse_e();

 lcd_cmd_my(0x28);

 lcd_cmd_my(0x0F);

 lcd_cmd_my(0x01);

 lcd_cmd_my(0x06);
}

 unsigned char check_rows(){
 unsigned char row_result = 0;

 if(ROW_0 == 1){
 row_result = 0x10;
 return row_result;
 }
 if(ROW_1 == 1){
 row_result = 0x14;
 return row_result;
 }
 if(ROW_2 == 1){
 row_result = 0x18;
 return row_result;
 }
 if(ROW_3 == 1){
 row_result = 0x1C;
 return row_result;
 }
 return row_result;
}

 unsigned char check_keyboard(){
 unsigned char keyboard_result = 0;
 unsigned char row_result = 0;
 unsigned char i = 0;
 char bin_str[9];

 COL_0 = 1;
 row_result = check_rows();
 if(row_result !=0){
 delay_ms_manual(200);
 keyboard_result = 0x00+row_result;

 return keyboard_result;
 }
 COL_0 = 0;

 COL_1 = 1;
 row_result = check_rows();
 if(row_result !=0){
 delay_ms_manual(200);
 keyboard_result = 0x01+row_result;

 return keyboard_result;
 }
 COL_1 = 0;

 COL_2 = 1;
 row_result = check_rows();
 if(row_result !=0){
 delay_ms_manual(200);
 keyboard_result = 0x02+row_result;

 return keyboard_result;
 }
 COL_2 = 0;

 COL_3 = 1;
 row_result = check_rows();
 if(row_result !=0){
 delay_ms_manual(200);
 keyboard_result = 0x03+row_result;

 return keyboard_result;
 }
 COL_3 = 0;

 return keyboard_result;
}

void uart_init(){

 UART_OUT_Direction = 1;
 UART_IN_Direction = 1;

 SPBRG = 15;
 TXSTA = 0x00;
 RCSTA.SPEN = 1;
 RCSTA.CREN = 1;

 PIE1.RCIE = 1;

 INTCON.GIE = 1;
 INTCON.GIEL = 1;
}

void main() {
 unsigned char count = 0;
 unsigned char second_input = 0;
 unsigned char i = 0;

 unsigned char j = 1;
 unsigned char k = 0;
 unsigned char input_value = 0;
 unsigned char keyboard_result = 0;
 char bin_str[9];

 ADCON1 = 0x0F;

 LCD_RS_Direction =0;
 LCD_EN_Direction =0;
 LCD_D4_Direction =0;
 LCD_D5_Direction =0;
 LCD_D6_Direction =0;
 LCD_D7_Direction =0;

 COL_0_Direction =0;
 COL_1_Direction =0;
 COL_2_Direction =0;
 COL_3_Direction =0;

 ROW_0_Direction =1;
 ROW_1_Direction =1;
 ROW_2_Direction =1;
 ROW_3_Direction =1;

 TRISD.B0 = 0;

 timer_init();

 uart_init();

 lcd_init_all();

 delay_ms_manual(10);

 while(1){
 delay_ms_manual(1000);
 i = 0;
 j = 0;

 second_input = 0;
 uart_input = 0;
 input_value = 0;
 keyboard_result = 0;
 uart_ready = 0;

 j = 1;
 lcd_char_my(1,j,'S');
 j++;
 lcd_char_my(1,j,'E');
 j++;
 lcd_char_my(1,j,'T');
 j++;
 lcd_char_my(1,j,':');
 j++;
 j++;

 j=1;

 delay_ms_manual(10);

 while (keyboard_result !=0x12) {

 keyboard_result = check_keyboard();

 if (keyboard_result == 0x10) {
 input_value <<= 1;
 }
 if (keyboard_result == 0x11) {
 input_value = (input_value << 1) | 1;
 }
 if (keyboard_result == 0x12) {
 lcd_char_my(1, j, 'S');
 j++;
 lcd_char_my(1, j, 'T');
 j++;
 lcd_char_my(1, j, 'A');
 j++;
 lcd_char_my(1, j, 'R');
 j++;
 lcd_char_my(1, j, 'T');
 j++;
 lcd_char_my(1, j, 'I');
 j++;
 lcd_char_my(1, j, 'N');
 j++;
 lcd_char_my(1, j, 'G');
 delay_ms_manual(2000);
 }

 if(keyboard_result == 0x13){
 j = 1;
 lcd_char_my(1,j,'B'); j++;
 lcd_char_my(1,j,'R'); j++;
 lcd_char_my(1,j,'E'); j++;
 lcd_char_my(1,j,'A'); j++;
 lcd_char_my(1,j,'K'); j++;
 lcd_char_my(1,j,'I'); j++;
 lcd_char_my(1,j,'N'); j++;
 lcd_char_my(1,j,'G'); j++;
 lcd_char_my(1,j,' '); j++;
 lcd_char_my(1,j,' '); j++;
 lcd_char_my(1,j,' '); j++;
 lcd_char_my(1,j,' '); j++;
 lcd_char_my(1,j,' '); j++;
 lcd_char_my(1,j,' '); j++;
 delay_ms_manual(2000);
 input_value = 0;
 break;
 }

 to_binary(input_value, bin_str);
 for (i = 0; i < 8; i++) {
 lcd_char_my(2, i + 1, bin_str[i]);
 }
 }

 count = input_value;

 lcd_cmd_my(0x01);

 delay_ms_manual(100);

 j = 1;
 lcd_char_my(1,j,'S'); j++;
 lcd_char_my(1,j,'E'); j++;
 lcd_char_my(1,j,'C'); j++;
 lcd_char_my(1,j,'O'); j++;
 lcd_char_my(1,j,'N'); j++;
 lcd_char_my(1,j,'D'); j++;
 lcd_char_my(1,j,':');

 while (1) {
 keyboard_result = check_keyboard();
 if(keyboard_result == 0x13){
 second_input = 255;
 j = 1;
 lcd_char_my(1,j,'B'); j++;
 lcd_char_my(1,j,'R'); j++;
 lcd_char_my(1,j,'E'); j++;
 lcd_char_my(1,j,'A'); j++;
 lcd_char_my(1,j,'K'); j++;
 lcd_char_my(1,j,'I'); j++;
 lcd_char_my(1,j,'N'); j++;
 lcd_char_my(1,j,'G'); j++;
 lcd_char_my(1,j,' '); j++;
 lcd_char_my(1,j,' '); j++;
 lcd_char_my(1,j,' '); j++;
 lcd_char_my(1,j,' '); j++;
 lcd_char_my(1,j,' '); j++;
 lcd_char_my(1,j,' '); j++;

 to_binary(second_input, bin_str);
 for (i = 0; i < 8; i++) lcd_char_my(2, i + 1, bin_str[i]);

 delay_ms_manual(2000);
 break;
 }

 if (uart_ready >0) {
 second_input = uart_input;
 to_binary(second_input, bin_str);
 for (i = 0; i < 8; i++) lcd_char_my(2, i + 1, bin_str[i]);

 j = 1;
 lcd_char_my(1, j, 'S');
 j++;
 lcd_char_my(1, j, 'T');
 j++;
 lcd_char_my(1, j, 'A');
 j++;
 lcd_char_my(1, j, 'R');
 j++;
 lcd_char_my(1, j, 'T');
 j++;
 lcd_char_my(1, j, 'I');
 j++;
 lcd_char_my(1, j, 'N');
 j++;
 lcd_char_my(1, j, 'G');
 j++;
 lcd_char_my(1, j, ' ');

 delay_ms_manual(2000);
 break;
 }
 }

 lcd_cmd_my(0x01);
 delay_ms_manual(100);

 if(second_input==count){
 j = 1;
 lcd_char_my(2, j, 'X');
 j++;
 lcd_char_my(2, j, '=');
 j++;
 lcd_char_my(2, j, 'Y');
 j++;
 delay_ms_manual(5000);
 }else if(second_input<count){
 j = 1;
 lcd_char_my(2, j, 'X');
 j++;
 lcd_char_my(2, j, '<');
 j++;
 lcd_char_my(2, j, 'Y');
 j++;
 delay_ms_manual(5000);
 }else{

 j = 1;
 lcd_char_my(1, j, 'B');
 j++;
 lcd_char_my(1, j, 'I');
 j++;
 lcd_char_my(1, j, 'N');
 j++;
 j++;
 lcd_char_my(1, j, 'C');
 j++;
 lcd_char_my(1, j, 'O');
 j++;
 lcd_char_my(1, j, 'U');
 j++;
 lcd_char_my(1, j, 'N');
 j++;
 lcd_char_my(1, j, 'T');
 j++;
 lcd_char_my(1, j, 'E');
 j++;
 lcd_char_my(1, j, 'R');

 to_binary(count, bin_str);

 for (i = 0; i < 8; i++) {
 lcd_char_my(2, i + 2, bin_str[i]);
 }
 delay_ms_manual(1000);

 while (count<second_input) {
 keyboard_result = check_keyboard();
 if(keyboard_result == 0x13){
 j = 1;
 lcd_char_my(1,j,'B'); j++;
 lcd_char_my(1,j,'R'); j++;
 lcd_char_my(1,j,'E'); j++;
 lcd_char_my(1,j,'A'); j++;
 lcd_char_my(1,j,'K'); j++;
 lcd_char_my(1,j,'I'); j++;
 lcd_char_my(1,j,'N'); j++;
 lcd_char_my(1,j,'G'); j++;
 lcd_char_my(1,j,' '); j++;

 lcd_char_my(1,j,' '); j++;
 lcd_char_my(1,j,' '); j++;
 lcd_char_my(1,j,' '); j++;
 lcd_char_my(1,j,' '); j++;
 lcd_char_my(1,j,' '); j++;
 delay_ms_manual(5000);
 break;
 }
 count++;

 to_binary(count, bin_str);

 for (i = 0; i < 8; i++) {
 lcd_char_my(2, i + 2, bin_str[i]);
 }

 delay_ms_manual(1000);

 }
 lcd_cmd_my(0x01);
 delay_ms_manual(100);
 }
 lcd_cmd_my(0x01);
 delay_ms_manual(100);

 j = 1;
 lcd_char_my(1,j,'R'); j++;
 lcd_char_my(1,j,'E'); j++;
 lcd_char_my(1,j,'S'); j++;
 lcd_char_my(1,j,'T'); j++;
 lcd_char_my(1,j,'A'); j++;
 lcd_char_my(1,j,'R'); j++;
 lcd_char_my(1,j,'T'); j++;
 lcd_char_my(1,j,'I'); j++;
 lcd_char_my(1,j,'N'); j++;
 lcd_char_my(1,j,'G'); j++;

 delay_ms_manual(2000);

 lcd_cmd_my(0x01);
 }
}
