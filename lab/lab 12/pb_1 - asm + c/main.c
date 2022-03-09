#include <stdio.h>

void perm(int);

int main()
{
    int a = 1514909970;                            // a is given
    printf("hex representation: %lX.\n", a);    // print hex representation
    printf("circular permutations:\n");
    perm(a);                                    // call asm function
    return 0;
}
