#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    if(argc == 2 && strcmp(argv[1], "?") == 0){
        printf("Usage: mv <src> <dest>\n");
        exit(0);
    }

    if(argc != 3){
        printf("Error: mv requires 2 arguments\n");
        exit(1);
    }

    if(link(argv[1], argv[2]) < 0){
        printf("Error: cannot link %s -> %s\n", argv[1], argv[2]);
        exit(1);
    }

    unlink(argv[1]);
    exit(0);
}