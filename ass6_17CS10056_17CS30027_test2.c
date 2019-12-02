// Fibonacci Triangle

int main()
{
    int a = 0, b = 1, i, c, n, j;

    prints("\n*************************** Fibonacci Triangle ***************************\n");
    prints("\nEnter the limit: \n");
    int err;
    n = readi(&err);

    for(i = 1 ; i <= n ; i++)
    {
        a = 0;
        b = 1;
        printi(b);
        prints("\t");

        for(j = 1 ; j < i ; j++)
        {
            c = a+b;
            printi(c);
            prints("\t");

            a = b;
            b = c;
        }

        prints("\n");
    }

    
    prints("\n*******************************************************************\n");
    
    return 0;
}