#include "kernel/types.h"
#include "user/user.h"

int
main(void)
{
    printf("Calling shutdown...\n");
    shutdown();
    // If shutdown works, you will NEVER see this line:
    printf("Shutdown failed....\n");
    exit(0);
}
