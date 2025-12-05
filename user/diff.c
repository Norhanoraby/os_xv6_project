#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int readline(int fd, char *buf, int max)
{
    int n=0;
    char c;
    while(n < max-1){
        if(read(fd, &c, 1) != 1)
            break;
        buf[n++] = c;
        if(c=='\n') break;
    }
    buf[n] = 0;
    return n;
}

void strip_newlines(char *buf)
{
    int len = strlen(buf);

    // Remove trailing newline
    if(len > 0 && buf[len-1] == '\n'){
        buf[len-1] = 0;
        len--;
    }
}

int main(int argc, char *argv[])
{
    if(argc == 2 && strcmp(argv[1], "?") == 0){
        printf("Usage: diff <file1> <file2>\n");
        exit(0);
    }

    if(argc != 3){
        printf("Error: diff requires 2 files\n");
        exit(1);
    }

    int fd1 = open(argv[1], 0);
    int fd2 = open(argv[2], 0);

    if(fd1 < 0 || fd2 < 0){
        printf("Error: cannot open files\n");
        exit(1);
    }

    char b1[512], b2[512];
    int line=1;
    int diff = 0;

    while(1){
        int n1 = readline(fd1, b1, sizeof(b1));
        int n2 = readline(fd2, b2, sizeof(b2));

        if(n1 == 0 && n2 == 0)
            break;

        // *** FIXED PART: strip newline and CR ***
        strip_newlines(b1);
        strip_newlines(b2);

        if(n1 > 0 && n2 == 0){
            diff=1;
            printf("Line %d only in %s:\n< %s\n", line, argv[1], b1);
        }
        else if(n2 > 0 && n1 == 0){
            diff=1;
            printf("Line %d only in %s:\n> %s\n", line, argv[2], b2);
        }
        else if(strcmp(b1, b2) != 0){
            diff=1;
            printf("Line %d differs:\n< %s\n> %s\n", line, b1, b2);
        }

        line++;
    }

    if(!diff)
        printf("Files are identical\n");

    close(fd1);
    close(fd2);
    exit(0);
}
