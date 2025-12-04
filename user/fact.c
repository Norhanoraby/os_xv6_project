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
    if (argc == 2 && strcmp(argv[1], "?") == 0) {
        printf("Usage: fact <positive number>\n");
        exit(0);
    }
    
    if (argc != 2) {
        printf("You can only calculate factorial for one number\n");
        exit(0);
    }
    
    // Check for negative numbers first
    if (argv[1][0] == '-') {
        printf("Factorial is not defined for negative numbers\n");
        exit(0);
    }
    
    // Validate input for letters and special characters
    if (!is_valid_positive_number(argv[1])) {
        printf("Invalid input: please enter a positive number\n");
        exit(0);
    }
    
    int num = atoi(argv[1]);
    int result = 1;
    
    for (int i = 1; i <= num; i++) {
        result = result * i;
    }
    
    printf("Factorial of %d = %d\n", num, result);
    exit(0);
}