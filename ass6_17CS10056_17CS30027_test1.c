// Calculate Interest

int gcd(int a, int b)
{
    if(b == 0)
    {
        return a;
    }
    else
    {
        return gcd(b, a%b);
    }
}

int main()

{
    int a, b;
    int c, err;
    prints("\n****************** GCD *****************\n");
    prints("\nEnter two numbers:\n");
    a = readi(&err);
    b = readi(&err);

    c = gcd(a, b);

    prints("\nGCD :\n");
    printi(c);
    prints("\n***********************************\n");
    return 0;

}