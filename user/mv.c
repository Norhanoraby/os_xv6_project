#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fs.h"
#include "user/user.h"

// Manual strcat implementation for xv6
char* strcat(char *dest, const char *src) {
    char *ptr = dest;
    while (*ptr != '\0') {
        ptr++;
    }
    while (*src != '\0') {
        *ptr++ = *src++;
    }
    *ptr = '\0';
    return dest;
}

// Extract filename from path
char* get_filename(char *path) {
    char *p = path + strlen(path);
    while (p > path && *p != '/') {
        p--;
    }
    if (*p == '/') p++;
    return p;
}

int main(int argc, char *argv[]) {
    struct stat st;
    char newpath[512];

    if (argc != 3) {
        fprintf(2, "Usage: mv source destination\n");
        exit(1);
    }

    char *source = argv[1];
    char *dest = argv[2];

    // Check if source exists
    if (stat(source, &st) < 0) {
        fprintf(2, "mv: cannot stat %s\n", source);
        exit(1);
    }

    // Check if destination is a directory
    if (stat(dest, &st) == 0 && st.type == T_DIR) {
        // Destination is a directory, append source filename
        char *filename = get_filename(source);
        strcpy(newpath, dest);
        if (newpath[strlen(newpath) - 1] != '/') {
            strcat(newpath, "/");
        }
        strcat(newpath, filename);
    } else {
        // Destination is a file or doesn't exist
        strcpy(newpath, dest);
    }

    // Perform the move using link and unlink
    if (link(source, newpath) < 0) {
        fprintf(2, "mv: link failed\n");
        exit(1);
    }

    if (unlink(source) < 0) {
        fprintf(2, "mv: unlink failed\n");
        unlink(newpath); // Cleanup
        exit(1);
    }

    exit(0);
}