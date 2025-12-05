#include "kernel/types.h"
#include "user.h"

int main(void)
{
    int r = random();
    printf("rand = %d\n", r);
    exit(0);
}