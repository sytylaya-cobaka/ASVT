#include <8051.h>

void delay()
{
    unsigned int i,j;
    for(i=0;i<4;i++)
        for(j=0;j<2;j++);
}

void lcd_cmd(unsigned char cmd)
{
    P0 = cmd;
    P2 = 0x1;
    P2 = 0x0;
}

void lcd_data(unsigned char data)
{
    P0 = data;
    P2 = 0x3;
    P2 = 0x2;
}

void lcd_print(char *str)
{
    while(*str)
    {
        lcd_data(*str);
        str++;
    }
}

void erase_word(unsigned char pos, unsigned char len)
{
    unsigned char i;
    lcd_cmd(0x80 + pos);  
    for(i=0;i<len;i++)
        lcd_data(' ');
}

void main()
{
    unsigned char pos;

    unsigned char str1[] = { 
        0xAB,0xB2,0xA6,0xAE,0xA9,0xC0,0
    };

    unsigned char str2[] = {  
        0xA1,0xA0,0xB2,0xA0,0xB1,0xA3,0xA9,0xAE,0xA0,0
    };

    lcd_cmd(0x38);
    lcd_cmd(0x0E);
    lcd_cmd(0x01);

    
    lcd_cmd(0xC0 + 4); //qentr
    lcd_print(str2);

    pos = 0;

    while(1)
    {
      
        lcd_cmd(0x80 + pos);
        lcd_print(str1);

        delay();

        erase_word(pos,6);   

        pos += 2;

        if(pos > 9)         // do kuda beg 16-slovo
            pos = 0;
    }
}