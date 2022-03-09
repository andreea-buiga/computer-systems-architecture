/*++
Write a C program that calls the function sumNumbers, written in assembly language. This functions receives
as parameters two integer numbers that were read in the C program, computes their sum and returns this value.
The C program will display the sum computed by the sumNumbers function.
--*/


#include <stdio.h>

// the function declased in the en_modulSumaNumere.asm file
int nrMax(int a, int b);

int main()
{
    // declare variables
    int x = 0; 
    int max = 0;

    // read the two integers from the keyboard
    
    while(scanf("%d", &x))
    {
        max = nrMax(x,max);
    }

    
    // display the result
    printf("The maximum number in base 16 is %x", max);
    
    FILE *fp;
    fp  = fopen ("data.txt", "w");
    fprintf(fp,"The maximum number in base 16 is %x", max);
    
    
    fclose (fp);
    
    return 0;
}