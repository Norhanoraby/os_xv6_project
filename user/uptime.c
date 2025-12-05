#include "kernel/types.h"
#include "user/user.h"

int
main(void)
{
    int t = uptime();  
    printf("System uptime: %d ticks\n", t);

    
    printf("Approx uptime: %d seconds\n", t / 10);//conert ticks to sec 
//ya3ne kol 100 tick = 1 sec
    exit(0);
}
