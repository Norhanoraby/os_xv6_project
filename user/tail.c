#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include  "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
 if (argc == 2 && strcmp(argv[1], "?") == 0) {
    printf("Usage: Enter a valid file name\n");
    exit(0);
  }

  switch(argc)
  {
  case(2):
  {
  int fd = open(argv[1], O_RDONLY);
  if (fd < 0) {
    printf("tail: cannot open %s\n", argv[1]);
    exit(0);
  }

  char buf[512];
  int m = 10;
  int r;


  while ((r = read(fd, buf, sizeof(buf))) > 0) {
    write(1, buf, r);
       if (r < 0) {
        printf("tail: read error\n");
       }
    close(fd);
    int count = 0;
    for (int i = r - 1; i >= 0; i--) {
        if (buf[i] == '\n') {
            count++;
            if (count == m + 1) {
                write(1, buf + i + 1, r - i - 1);
                return 0;
            }
                write(1, buf, r);
        }
    }
  }
  break;
  }

  case(4):
  {
  if(strcmp(argv[2], "-n") != 0 )
  {
    printf("Usage: tail <filename> -n <number>");
    exit(0);
  }
  int fd = open(argv[1], O_RDONLY);
  if (fd < 0) {
    printf("tail: cannot open %s\n", argv[1]);
    exit(0);
  }

  char buf[512];
  int n = atoi(argv[3]);
  int f;

  // Read entire file for now
  while ((f = read(fd, buf, sizeof(buf))) > 0) {
        if (f < 0) {
        printf("tail: read error\n");
        }
close(fd);
int count = 0;
    for (int i = f - 1; i >= 0; i--) {
        if (buf[i] == '\n') {
            count++;
            if (count == n + 1) { // stop after finding the N-th line from bottom
                write(1, buf + i + 1, f - i - 1);
                return 0;
            }
                write(1, buf, f);
        }
    }  // print to stdout

  break;
  }
    default:
    printf("Usage: tail <filename> [-n number]\n");
    break;
}


  exit(0);
}

}
