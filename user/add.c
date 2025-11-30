
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{

int num1 = atoi(argv[1]);
int num2 = atoi(argv[2]);
int sum = num1 + num2;
printf("%d ",sum);

exit(0);

}
