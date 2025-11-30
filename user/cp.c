#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
 int fd_src, fd_dest;
    char buf[512];
    int n;
    int w;

    if (argc != 3) {
        printf("Usage: cp source_file dest_file\n");
        exit(0);
    }

    // Open source file for reading
    fd_src = open(argv[1], O_RDONLY);
    if (fd_src < 0) {
        printf("cp: cannot open source file %s\n", argv[1]);
        exit(0);
    }

    // Open (or create) destination file for writing
    fd_dest = open(argv[2], O_CREATE | O_WRONLY);
    if (fd_dest < 0) {
        printf("cp: cannot open destination file %s\n", argv[2]);
        close(fd_src);
        exit(0);
    }

    // Copy data from source to destination
    while ((n = read(fd_src, buf, sizeof(buf))) > 0) {
      w = write(fd_dest, buf, n);
        if (w!= n) {
            printf("cp: write error\n");
            close(fd_src);
            close(fd_dest);
            exit(0);
        }
    }

    if (n < 0) {
        printf("cp: read error\n");
    }

    close(fd_src);
    close(fd_dest);
  exit(0);
}
