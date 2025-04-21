//регистры для работы с LCD
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

//Регистры для работы с матричной клавиатруой
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

//Регистрыв для работы с COM-портом
sbit UART_OUT at LATC6_bit;
sbit UART_IN at RC7_bit;

sbit UART_OUT_Direction at TRISC6_bit;
sbit UART_IN_Direction at TRISC7_bit;

void to_binary(unsigned char val, char *buffer) {
     int i = 0;
     for ( i = 7; i >= 0; i--) {
         buffer[7 - i] = (val & (1 << i)) ? '1' : '0';
     }
    buffer[8] = '\0';
}

void pulse_e() {
     LCD_EN = 1;
     Delay_us(1);
     LCD_EN = 0;
     Delay_us(40);

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

     Delay_us(40);
}

void lcd_init_all(){

     Delay_ms(20);

     lcd_init_r();

     lcd_init_r();

     lcd_init_r();

     lcd_cmd_4(0x02);
     pulse_e();

     lcd_cmd_my(0x28);

     lcd_cmd_my(0x0C);

     lcd_cmd_my(0x01);

     lcd_cmd_my(0x06);
}

unsigned char check_rows(){
    if(ROW_0 == 1){
        return 0x10;
    }
    if(ROW_1 == 1){
        return 0x14;
    }
    if(ROW_2 == 1){
        return 0x18;
    }
    if(ROW_3 == 1){
        return 0x1C;
    }
    return 0;
}

unsigned char check_keyboard(){
    unsigned char row_result = 0;
    unsigned char i = 0;

    COL_0 = 1;
    row_result =  check_rows();
    if(row_result !=0){
       Delay_ms(200);
       return 0x00+row_result;
    }
    COL_0 = 0;

    COL_1 = 1;
    row_result =  check_rows();
    if(row_result !=0){
       Delay_ms(200);
       return 0x01+row_result;
    }
    COL_1 = 0;

    COL_2 = 1;
    row_result =  check_rows();
    if(row_result !=0){
       Delay_ms(200);
       return 0x02+row_result;
    }
    COL_2 = 0;

    COL_3 = 1;
    row_result =  check_rows();
    if(row_result !=0){
       Delay_ms(200);
       return 0x03+row_result;
    }
    COL_3 = 0;

    return 0;
}

void uart_write(char my_data){
    while (!PIR1.TXIF){}
    TXREG = my_data;
}

char uart_read(){
    while (!PIR1.RCIF){}
    return RCREG;
}

char uart_data_ready(){
    return PIR1.RCIF;
}


void main() {
     unsigned char count = 0;
     unsigned char i = 0;
     unsigned char j = 1;
     unsigned char k = 0;
     unsigned char input_value = 0;
     unsigned char keyboard_result = 0;
     char bin_str[9];
     unsigned char uart_received;
     unsigned int uart_value = 0;
     unsigned char second_input = 0;

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
     
     UART_OUT_Direction = 0;
     UART_IN_Direction = 1;
     SPBRG = 64;
     TXSTA = 0x20;
     RCSTA = 0x09;

     lcd_init_all();

     Delay_ms(10);

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

     while (keyboard_result !=0x12) {
         lcd_char_my(1, 6, k);
         k++;

         keyboard_result = check_keyboard();

         if (keyboard_result == 0x10) {
             input_value <<= 1;
         }
         if (keyboard_result == 0x11) {
             input_value = (input_value << 1) | 1;
         }
         if (keyboard_result == 0x12) {
             count = input_value;
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
             Delay_ms(2000);
         }

         to_binary(input_value, bin_str);
         for (i = 0; i < 8; i++) {
             lcd_char_my(2, i + 1, bin_str[i]);
         }
     }

     count = input_value;

     lcd_cmd_my(0x01);

     Delay_ms(100);
     
     j = 1;
     lcd_char_my(1,j,'S'); j++;
     lcd_char_my(1,j,'E'); j++;
     lcd_char_my(1,j,'C'); j++;
     lcd_char_my(1,j,'O'); j++;
     lcd_char_my(1,j,'N'); j++;
     lcd_char_my(1,j,'D'); j++;
     lcd_char_my(1,j,':');

     uart_value = 0;
     while (1) {
           if (uart_data_ready()) {
              uart_received = uart_read();
              if (uart_received >= '0' && uart_received <= '9') {
                 uart_value = uart_value * 10 + (uart_received - '0');
                 uart_write(uart_received);
              }
              if (uart_received == 13) {
                 second_input = uart_value;
                 break;
              }
           }
           to_binary(uart_value & 0xFF, bin_str);
           for (i = 0; i < 8; i++) lcd_char_my(2, i + 1, bin_str[i]);
     }

     lcd_cmd_my(0x01);
     Delay_ms(100);

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

     while (1) {
          Delay_ms(1000);
          count++;
          if (count > 255) count = 0;

          to_binary(count, bin_str);

          for (i = 0; i < 8; i++) {
              lcd_char_my(2, i + 2, bin_str[i]);
          }


          //lcd_char_my(count);

        }
}