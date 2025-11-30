#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if (argc == 2 && strcmp(argv[1], "?") == 0) {
    printf("Usage: fact <positive number>\n");
    exit(0);
  }

  if (argc != 2) {
    printf("You can only calculate factorial for one number\n");
    exit(0);
  }

  if (argv[1][0] == '-') {
    printf("Factorial is not defined for negative numbers\n");
    exit(0);
  }

  int num = atoi(argv[1]);

  int result = 1;

  for (int i = 1; i <= num; i++) {
    result = result * i;
  }

  printf("Factorial of %d = %d\n", num, result);

  exit(0);
}
