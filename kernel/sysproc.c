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



// Memory-mapped mtime address (from memlayout.h)
#define MTIME 0x0200BFF8UL
volatile uint64* mtime = (uint64*)MTIME;

/*uint64
sys_date(void)
{
    struct rtcdate d;
    uint64 addr;

    // Get the user pointer to the rtcdate struct
    if(argaddr(0, &addr) < 0)
        return -1;

    // Read elapsed cycles from mtime register
    uint64 ticks_since_boot = *mtime;

    // Convert cycles to seconds (mtime increments at 10MHz in QEMU)
    uint64 elapsed_seconds = ticks_since_boot / 10000000;

    // Compute current UNIX timestamp
    uint64 current_time = BOOT_EPOCH + elapsed_seconds;

    // Convert current_time to human-readable date
    // Simple algorithm for converting UNIX timestamp
    // (for xv6 you can use a minimal version)
    int sec = current_time % 60;
    int min = (current_time / 60) % 60;
    int hour = (current_time / 3600) % 24;

    int days = current_time / 86400;

    // naive approximation for year/month/day
    int year = 1970;
    while(days >= 365){
        if((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0))
            days -= 366;
        else
            days -= 365;
        year++;
    }
    int month = 1;
    int month_days[12] = {31,28,31,30,31,30,31,31,30,31,30,31};
    if((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0))
        month_days[1] = 29;
    for(int i=0;i<12;i++){
        if(days >= month_days[i]){
            days -= month_days[i];
            month++;
        } else break;
    }
    int day = days + 1;

    // Fill struct
    d.year = year;
    d.month = month;
    d.day = day;
    d.hour = hour;
    d.minute = min;
    d.second = sec;

    // Copy struct to user space
    if(copyout(myproc()->pagetable, addr, (char*)&d, sizeof(d)) < 0)
        return -1;

    return 0;
}*/


