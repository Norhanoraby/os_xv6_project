#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
//#include "date.h"   

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
uint64 syscall_count = 0;
uint64
sys_countsyscall(void)
{
  return syscall_count;
}
uint64
sys_getppid(void)
{
  return myproc()->parent->pid;
}
uint64
sys_shutdown(void)
{
  printf("shutting down \n");
  volatile uint32 *shutdown_reg=(uint32 *)0x100000;
  *shutdown_reg=0x5555;
  return 0;
}

// Simple kernel PRNG using LCG
static unsigned int lcg_state = 1;

uint64
sys_rand(void)
{
  // Seed only once using ticks (global variable provided by xv6)
  extern uint ticks;
  if (lcg_state == 1)
    lcg_state = ticks + 1;  // avoid 0 seed

  // LCG formula
  lcg_state = (1103515245 * lcg_state + 12345) & 0x7fffffff;

  return lcg_state;
}

uint64
sys_getptable(void)
{
  int nproc;
  uint64 buffer;
  
  argint(0, &nproc);
  argaddr(1, &buffer);
  
  return getptable(nproc, buffer);
}
// Import the global variable
extern int sched_mode; 

uint64
sys_set_sched(void)
{
  int mode;
  // Read the 1st argument passed to the syscall
 argint(0, &mode);
  
  // Validations
  if(mode != 0 && mode != 1 && mode !=2) // 0=RR, 1=FCFS, 2=prio
      return -1;

  sched_mode = mode; // UPDATE THE GLOBAL VARIABLE
  return 0; // Success
}
uint64
sys_wait_sched(void)
{
  uint64 p_status; // Pointer for status
  uint64 p_tt;     // Pointer for Turnaround Time
  uint64 p_wt;     // Pointer for Waiting Time

  // Retrieve the 3 addresses passed by the user
  if(argaddr(0, &p_status) < 0) return -1;
  if(argaddr(1, &p_tt) < 0)     return -1;
  if(argaddr(2, &p_wt) < 0)     return -1;

  return wait_sched(p_status, p_tt, p_wt);
}



