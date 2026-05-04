#include <8051.h>

void msec(int x)
{
    while(x-->0)
    {
        TH0 = (-10000)>>8;
        TL0 = -10000;

        TR0 = 1;

        while(TF0==0);

        TF0 = 0;
        TR0 = 0;
    }
}

void delay_sec(int s)
{
    while(s--)
        msec(100);
}

void main()
{
    TMOD = 0x01;

    while(1)
    {
        // LED1 ? LED8 ????? 1 ???????
        P1 = 0x81;   // 10000001 - LED1 (P1.0) ? LED8 (P1.7)
        delay_sec(1);
        
        // LED2 ? LED7 ????? 2 ???????
        P1 = 0x42;   // 01000010 - LED2 (P1.1) ? LED7 (P1.6)
        delay_sec(2);
        
        // LED3 ? LED6 ????? 3 ???????
        P1 = 0x24;   // 00100100 - LED3 (P1.2) ? LED6 (P1.5)
        delay_sec(3);
        
        // LED4 ? LED5 ????? 4 ???????
        P1 = 0x18;   // 00011000 - LED4 (P1.3) ? LED5 (P1.4)
        delay_sec(4);
    }
}