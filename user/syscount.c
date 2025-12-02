#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  printf("System call count: %d\n", countsyscall());
  //printf("After another call: %d\n", countsyscall());
  exit(0);
}