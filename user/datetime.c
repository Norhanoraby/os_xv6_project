#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"

// user/datetime.c
int
main(void)
{
    struct rtcdate d;
    if(datetime(&d) < 0){
        printf("date syscall failed\n");
        exit(1);
    }
    
    printf("Year: %d\n", d.year);
    printf("Month: %d\n", d.month);
    printf("Day: %d\n", d.day);
    printf("Time: %d:%d:%d\n", d.hour, d.minute, d.second);

    exit(0);
}