#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

#define BUF_SIZE 512
#define MAX_FILE_SIZE 10000  // assume files < 10 KB

int main(int argc, char *argv[]) {
    if(argc < 2 || argc > 4) {
        printf("Usage: tail <filename> [-n number]\n");
        exit(0);
    }

    char *filename = argv[1];
    int n = 10;  // default number of lines

    // Only allow "tail filename" or "tail filename -n number"
    if(argc == 4) {
        if(strcmp(argv[2], "-n") != 0) {
            printf("Usage: tail <filename> [-n number]\n");
            exit(0);
        }
        n = atoi(argv[3]);
        if(n <= 0) {
            printf("tail: invalid number of lines '%s'\n", argv[3]);
            exit(0);
        }
    }

    // Reject other invalid forms
    if(argc == 3) {
        printf("Usage: tail <filename> [-n number]\n");
        exit(0);
    }

    int fd = open(filename, O_RDONLY);
    if(fd < 0) {
        printf("tail: cannot open %s\n", filename);
        exit(0);
    }

    char buf[BUF_SIZE];
    char *filebuf = malloc(MAX_FILE_SIZE);
    if(!filebuf) {
        printf("tail: memory error\n");
        close(fd);
        exit(0);
    }

    int size = 0;
    int r;
    while((r = read(fd, buf, sizeof(buf))) > 0) {
        if(size + r > MAX_FILE_SIZE) {
            printf("tail: file too large\n");
            free(filebuf);
            close(fd);
            exit(0);
        }
        memmove(filebuf + size, buf, r);
        size += r;
    }
    close(fd);

    // Count lines from the end
    int linecount = 0;
    int start = 0;
    for(int i = size-1; i >= 0; i--) {
        if(filebuf[i] == '\n') linecount++;
        if(linecount == n) {
            start = i + 1;
            break;
        }
    }

    // Write last N lines
    write(1, filebuf + start, size - start);

    // Ensure newline at the end
    if(size == 0 || filebuf[size-1] != '\n')
        write(1, "\n", 1);

    free(filebuf);
    exit(0);
}
