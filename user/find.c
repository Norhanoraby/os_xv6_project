#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fs.h"
#include "user/user.h"

void print_help() {
    printf("Usage: find <directory> <filename>\n");
}

// Compare DIRSIZ fixed-length names el bykon 14 bytes lw a2al by add zeros w lw aktar by truncate
int same_name(char *a, char *b) {
    for (int i = 0; i < DIRSIZ; i++) {
        if (a[i] != b[i])
            return 0;
        if (a[i] == 0 && b[i] == 0)
            return 1;
    }
    return 1;
}

// Recursive find function with match count
int find(char *path, char *target) {
    int fd;
    struct stat st;// de bt2ule lw da file wala directory
    struct dirent de;// by read files inside folders"directories"
    char buf[512];// bahut feeh full path ex: /home/user/file
    char *p;//pointer for building the path
    int found = 0; // flag to track if we found any match

    // Open directory/file
    fd = open(path, 0);
    if (fd < 0) {
        printf("find: cannot open %s\n", path);
        return 0;//cannot be opened(not found)
    }
    // if statement de bt2ule lw this path is a file, directory

    if (fstat(fd, &st) < 0) {
        printf("find: cannot stat %s\n", path);
        close(fd);
        return 0;
    }

    // If it's a file, compare filename only
    if (st.type == T_FILE) {
        char *filename = path + strlen(path);
        while (filename > path && *(filename - 1) != '/')//ya3ne hena malesh da3wa bl path ba3ud arga3 lehd mawsal ll file name el howa ba3d akher /
            filename--;

        if (strcmp(filename, target) == 0) {// compare this file name with the target and if match do this
            printf("%s\n", path);
            found = 1;
        }

        close(fd);
        return found;
    }

    // Directory case: scan contents
    while (read(fd, &de, sizeof(de)) == sizeof(de)) {
      //skip empty entries Skip . and .. "garbage entries"
        if (de.inum == 0 || strcmp(de.name, ".") == 0 ||strcmp(de.name, "..") == 0)
            continue;

        // Build full path: path + "/" + name ex: path=/home ,de.name=a.txt
        strcpy(buf, path); // bahut fl buffer /home
        p = buf + strlen(buf);// khalet el pointery yb2a 3and end of string el howa "e"
        *p++ = '/';// add / ba3d /home f hatkon "/home/"
        memmove(p, de.name, DIRSIZ);//copy the 14 byte fixed filename
        p[DIRSIZ] = 0; // null-terminate

        if (strcmp(de.name, target) == 0) {//check filename with target
            printf("%s\n", buf);//print the full path
            found = 1;
        }

        // If directory → recurse, ex: /home/user/a.txt "ya3ne badawar gowa el home ba3den akhush 3ala user w adawar till i reach file"
        if (stat(buf, &st) == 0 && st.type == T_DIR) {
            if (find(buf, target))
                found = 1; // if found in subdir, mark as found
        }
    }

    close(fd);
    return found;
}

int main(int argc, char *argv[]) {
    if (argc == 2 && strcmp(argv[1], "?") == 0) {
        print_help();
        exit(0);
    }

    if (argc != 3) {
        print_help();
        exit(1);
    }

    // Call find and check if file was found
    if (!find(argv[1], argv[2])) {
        printf("find: file '%s' not found\n", argv[2]);
        exit(1); // error code
    }

    exit(0);
}
