
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"
void
print_help()
{
    printf("Usage: touch filename\n");
    printf("Creates an empty file if it does not exist.\n");
    printf("Raises an error if the file already exists.\n");
}
int
main(int argc, char *argv[])
{
    if (argc == 2 && strcmp(argv[1], "?") == 0) {
        print_help();
        exit(0);
    }

    //to make sure that its the command and file name only
    if (argc != 2) {
        printf("Usage: touch filename\n");
        exit(1);
    }

    char *path = argv[1];

    // Try opening the file in read-only mode to check if it exists
    int fd = open(path, O_RDONLY);

    if (fd >= 0) {
        //if file already created raise an error
        close(fd);
        printf("touch: file '%s' already exists\n", path);
        exit(1);
    }

    // if its not created , create the file
    fd = open(path, O_CREATE | O_RDWR);

    if (fd < 0) {
        printf("touch: failed to create file '%s'\n", path);
        exit(1);
    }

    close(fd);

exit(0);
}
