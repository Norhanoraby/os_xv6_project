#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"


int main(int argc, char *argv[]) {

  int pid;
  int k, nprocess = 10;
  int z, steps = 1000000;
  char buffer_src[1024], buffer_dst[1024];
  int status, tt, wt;
  int total_tt = 0, total_wt = 0;
  int mode = 0; // roundrobin el default beta3e
  if (argc >= 2) {
      mode = atoi(argv[1]); // Read mode from command line (e.g., "2")
  }
  if (set_sched(mode) < 0) {
       printf("Error setting scheduler (Mode %d)\n", mode);
       exit(1);
  }
  if(mode == 1) 
      printf("Scheduler set to FCFS. Creating 10 processes...\n");
  else if (mode ==2)
      printf("Scheduler set to priority. Creating 10 processes...\n");
  else
  printf("Scheduler set to RoundRobin. Creating 10 processes...\n");



  for (k = 0; k < nprocess; k++) {
    // ensure different creation times (proc->ctime)
    // needed for properly testing FCFS scheduling
    if (mode == 2) 
        sleep(1); // Faster creation for Priority
    else 
    sleep(2);

    pid = fork();
    if (pid < 0) {
      printf("%d failed in fork!\n", getpid());
      exit(0);

    }
    else if (pid == 0) {
      // child
      printf("[pid=%d] created\n", getpid());

      for (z = 0; z < steps; z += 1) {
         // copy buffers one inside the other and back
         // used for wasting cpu time
         memmove(buffer_dst, buffer_src, 1024);
         memmove(buffer_src, buffer_dst, 1024);
      }
      exit(0);
    }
  }

    for (k = 0; k < nprocess; k++) {
        pid = wait_sched(&status, &tt, &wt);
        if(pid > 0) {
            printf("[pid=%d] terminated. turnaround=%d, wait=%d\n", pid, tt, wt);
            // Sum them up for the average calculation
            total_tt += tt;
            total_wt += wt;
        } else {
            printf("Error in wait_sched\n");
        }
    }
    
    // Calculate and Print Averages
    printf("Avg turnaround time:%d.%d\n", total_tt / nprocess, 
           (total_tt * 10 / nprocess) % 10);
    printf("Avg wait time:%d.%d\n", total_wt / nprocess,
           (total_wt * 10 / nprocess) % 10);
           
    set_sched(0);
    
    exit(0);
}