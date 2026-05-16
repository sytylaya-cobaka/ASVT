#include <iostream>
using namespace std;

extern "C" float __cdecl SumR(int n, float x);

int main()
{
    float x;
    int n;

    cout << "Input x: ";
    cin >> x;

    cout << "Input n: ";
    cin >> n;

    float result = SumR(n, x);

    cout << "Result = " << result << endl;

    return 0;
}