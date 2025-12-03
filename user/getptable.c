// user/ptabletest.c or user/getptable.c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define MAX_PROC 64

// Must match the structure in kernel
struct proc_info {
  int pid;
  int ppid;
  int state;
  char name[16];
  uint64 sz;
};

// State strings for display
const char *state_names[] = {
  "UNUSED",
  "USED", 
  "SLEEPING",
  "RUNNABLE",
  "RUNNING",
  "ZOMBIE"
};

int
main(int argc, char *argv[])
{
  struct proc_info ptable[MAX_PROC];
  int result;
  int i;
  int count = 0;
  
  printf("Testing getptable system call...\n");
  printf("================================\n\n");
  
  // Call the system call
  result = getptable(MAX_PROC, (uint64)ptable);
  
  if (result == 0) {
    printf("ERROR: getptable failed!\n");
    exit(1);
  }
  
  printf("getptable succeeded!\n\n");
  
  // Print header - simpler format for xv6 printf
  printf("PID  PPID STATE      NAME             SIZE\n");
  printf("---  ---- -----      ----             ----\n");
  
  // Display process information
  for (i = 0; i < MAX_PROC; i++) {
    // Check if this is a valid process entry
    if (ptable[i].pid > 0) {
      const char *state_str = "UNKNOWN";
      if (ptable[i].state >= 0 && ptable[i].state <= 5) {
        state_str = state_names[ptable[i].state];
      }
      
      // Simple format without width specifiers
      printf("%d\t %d\t %s\t %s\t %d\n",
             ptable[i].pid,
             ptable[i].ppid,
             state_str,
             ptable[i].name,
             (int)ptable[i].sz);
      count++;
    }
  }
  
  printf("\nTotal processes: %d\n", count);
  
  exit(0);
}