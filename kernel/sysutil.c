#include "types.h"
#include "riscv.h"
#include "defs.h"      
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "syscall.h"
#include "fs.h"
#include "file.h"
#include "stat.h"
#include <stdint.h>

#ifndef BOOT_EPOCH
#define BOOT_EPOCH 1 // Example timestamp; set to the appropriate value
#endif
 

extern int keyboard_int_cnt;
uint64 sys_kbdint()
{

return keyboard_int_cnt;
}

//Random
static unsigned int lcg_state=1; //PRNG state
uint64
sys_random(void)
{
  // Seed only once using ticks (global variable provided by xv6)
  extern uint ticks;
  if (lcg_state == 1)
    lcg_state = ticks + 1;  // avoid 0 seed

  // LCG formula
  lcg_state = (1103515245 * lcg_state + 12345) & 0x7fffffff;

  return lcg_state;
}

//datetime
#define MTIME_FREQ 10000000ULL
#define HZ 100   // ticks per second in xv6 (default). Adjust if you changed timer frequency.

// Convert POSIX seconds (since epoch) into a calendar date (UTC).
// A simple integer-based conversion (Gregorian calendar).
static void
seconds_to_rtcdate(uint64 secs, struct rtcdate *r)
{
  // This is a standard conversion algorithm (civil_from_days style).
  // We'll convert seconds -> days + remainder seconds -> hour/min/sec.
  uint64 days = secs / 86400;
  uint64 rem = secs % 86400;

  r->hour = rem / 3600;
  rem %= 3600;
  r->minute = rem / 60;
  r->second = rem % 60;

  // Convert days since 1970-01-01 to y/m/d (Gregorian).
  // Algorithm adapted from "civil_from_days" (Howard Hinnant).
  // Note: input days is days since 1970-01-01.
  int64_t z = (int64_t)days + 719468; // shift to 0000-03-01 epoch used by algorithm
  int64_t era = (z >= 0 ? z : z - 146096) / 146097;
  unsigned doe = (unsigned)(z - era * 146097);          // [0, 146096]
  unsigned yoe = (doe - doe/1460 + doe/36524 - doe/146096) / 365; // [0, 399]
  int year = (int)(yoe + era * 400);
  unsigned doy = doe - (365*yoe + yoe/4 - yoe/100);     // [0, 365]
  unsigned mp = (5*doy + 2) / 153;                      // [0, 11]
  unsigned day = doy - (153*mp+2)/5 + 1;                // [1, 31]
  unsigned month = mp + (mp < 10 ? 3 : -9);             // [1, 12]
  year += (month <= 2);

  r->year = year;
  r->month = (int)month;
  r->day = (int)day;
}

uint64
sys_datetime(void)
{
  uint64 user_addr;
  struct rtcdate rd;

  // get user pointer argument 0
  if(argaddr(0, &user_addr) < 0)
    return -1;

 volatile uint64 *mtime = (volatile uint64 *)CLINT_MTIME;
 uint64 mtime_val = *mtime;   // increments in cycles / platform timeunits
// Now convert to seconds. The conversion constant depends on the platform's mtime frequency.
// On QEMU virt, mtime increments at the host timer frequency used by the platform (platform dependent).
 

uint64 unix_secs = BOOT_EPOCH + (mtime_val / MTIME_FREQ);


//TO adjust cairo 
unix_secs+=7200;

  seconds_to_rtcdate(unix_secs, &rd);


  // copy to user space
  if(copyout(myproc()->pagetable, user_addr, (char *)&rd, sizeof(rd)) < 0)
    return -1;

  return 0;
}

