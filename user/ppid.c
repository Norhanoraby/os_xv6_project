#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  printf("My PID: %d\n", getpid());
  printf("My parent's PID: %d\n", getppid());
  
  int pid = fork();
  if(pid == 0) {
    // Child process
    printf("\nChild process:\n");
    printf("  My PID: %d\n", getpid());
    printf("  My parent's PID: %d\n", getppid());
    exit(0);
  } else {
    // Parent process
    wait(0);
    printf("\nParent after child exits:\n");
    printf("  My PID: %d\n", getpid());
    printf("  My parent's PID: %d\n", getppid());
  }
  
  exit(0);
}