#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int is_valid_positive_number(char *str) {
    int i = 0;
    
    // Check for empty string
    if(str[0] == '\0') {
        return 0;
    }
    
    // Check if starts with a sign (negative not allowed, positive optional)
    if(str[0] == '-') {
        return 0;  // Negative numbers not allowed
    }
    
    if(str[0] == '+') {
        i = 1;
        // Just a '+' with no digits is invalid
        if(str[1] == '\0') {
            return 0;
        }
    }
    
    // Check if all remaining characters are digits
    while(str[i] != '\0') {#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int is_valid_positive_number(char *str) {
    int i = 0;
    
    // Check for empty string
    if(str[0] == '\0') {
        return 0;
    }
    
    // Check if starts with a sign (negative not allowed, positive optional)
    if(str[0] == '-') {
        return 0;  // Negative numbers not allowed
    }
    
    if(str[0] == '+') {
        i = 1;
        // Just a '+' with no digits is invalid
        if(str[1] == '\0') {
            return 0;
        }
    }
    
    // Check if all remaining characters are digits
    while(str[i] != '\0') {
        if(str[i] < '0' || str[i] > '9') {
            return 0;  // Found a non-digit character
        }
        i++;
    }
    
    return 1;  // Valid positive number
}

int
main(int argc, char *argv[])
{
    if (argc != 2) {
        printf("Usage: sleep <positive number>\n");
        exit(0);
    }
    
    // Check for negative numbers first
    if (argv[1][0] == '-') {
        printf("sleep: invalid time interval '%s'\n", argv[1]);
        exit(0);
    }
    
    // Validate input for letters and special characters
    if (!is_valid_positive_number(argv[1])) {
        printf("sleep: invalid time interval '%s'\n", argv[1]);
        exit(0);
    }
    
    int num1 = atoi(argv[1]);
    sleep(num1);
    exit(0);
}
        if(str[i] < '0' || str[i] > '9') {
            return 0;  // Found a non-digit character
        }
        i++;
    }
    
    return 1;  // Valid positive number
}

int
main(int argc, char *argv[])
{
    if (argc != 2) {
        printf("Usage: sleep <positive number>\n");
        exit(0);
    }
    
    // Check for negative numbers first
    if (argv[1][0] == '-') {
        printf("sleep: invalid time interval '%s'\n", argv[1]);
        exit(0);
    }
    
    // Validate input for letters and special characters
    if (!is_valid_positive_number(argv[1])) {
        printf("sleep: invalid time interval '%s'\n", argv[1]);
        exit(0);
    }
    
    int num1 = atoi(argv[1]);
    sleep(num1);
    exit(0);
}