#include <8051.h>

void delay_short(void)
{
    unsigned char i;
    for(i = 0; i < 80; i++);
}

unsigned char scan_key(void)
{
    unsigned char a;

    P1 = 0xFE;
    delay_short();
    a = P1 & 0xF0;
    if(a != 0xF0)
    {
        if(a == 0xE0) return '1';
        if(a == 0xD0) return '4';
        if(a == 0xB0) return '7';
    }

    P1 = 0xFD;
    delay_short();
    a = P1 & 0xF0;
    if(a != 0xF0)
    {
        if(a == 0xE0) return '2';
        if(a == 0xD0) return '5';
        if(a == 0xB0) return '8';
    }

    P1 = 0xFB;
    delay_short();
    a = P1 & 0xF0;
    if(a != 0xF0)
    {
        if(a == 0xE0) return '3';
        if(a == 0xD0) return '6';
        if(a == 0xB0) return '9';
    }

    P1 = 0xF7;
    delay_short();
    a = P1 & 0xF0;
    if(a != 0xF0)
    {
        if(a == 0xE0) return '*';
        if(a == 0xD0) return '-';
        if(a == 0xB0) return '+';
    }

    return 0xFF;
}

unsigned char get_key(void)
{
    unsigned char k1, k2, k3;

    k1 = scan_key();
    if(k1 == 0xFF) return 0xFF;

    delay_short();
    k2 = scan_key();

    if(k1 != k2) return 0xFF;

    delay_short();
    k3 = scan_key();

    if(k2 == k3)
        return k1;

    return 0xFF;
}

void main(void)
{
    unsigned char key;
    unsigned char last_key = 0xFF;

    P0 = 0xFF;
    P1 = 0xF0;
    P2 = 0x00;

    P0 = 0x38;
    P2 = 1; P2 = 0;

    P0 = 0x0C;
    P2 = 1; P2 = 0;

    P0 = 0x01;
    P2 = 1; P2 = 0;

    delay_short();

    P0 = 0x80;
    P2 = 1; P2 = 0;

    while(1)
    {
        key = get_key();

        if(key != 0xFF && key != last_key)
        {
            P0 = key;
            P2 = 3;
            P2 = 2;
        }

        last_key = key;
        delay_short();
    }
}