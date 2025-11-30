
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{

int num1 = atoi(argv[1]);
sleep(num1);

exit(0);

}
