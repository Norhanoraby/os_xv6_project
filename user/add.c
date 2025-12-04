#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int is_valid_number(char *str) {
    int i = 0;
    
    // Check for empty string
    if(str[0] == '\0') {
        return 0;
    }
    
    // Allow leading '+' or '-'
    if(str[0] == '+' || str[0] == '-') {
        i = 1;
        // Just a sign with no digits is invalid
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
    
    return 1;  // Valid number
}

int my_atoi(char *str) {
    int result = 0;
    int sign = 1;
    int i = 0;
    
    // Handle sign
    if(str[0] == '-') {
        sign = -1;
        i = 1;
    } else if(str[0] == '+') {
        i = 1;
    }
    
    // Convert digits
    while(str[i] != '\0') {
        result = result * 10 + (str[i] - '0');
        i++;
    }
    
    return sign * result;
}

int
main(int argc, char *argv[])
{
    if(argc == 2 && strcmp(argv[1], "?") == 0) {
        printf("Usage: add number1 number2\n");
        exit(0);
    }
    
    if(argc != 3) {
        printf("You can only add two numbers\n");
        exit(0);
    }
    
    // Validate first argument
    if(!is_valid_number(argv[1])) {
        printf("needs numbers\n");
        exit(0);
    }
    
    // Validate second argument
    if(!is_valid_number(argv[2])) {
        printf("needs numbers\n");
        exit(0);
    }
    
    int num1 = my_atoi(argv[1]);
    int num2 = my_atoi(argv[2]);
    int total = num1 + num2;
    
    printf("The sum of %d and %d is %d\n", num1, num2, total);
    exit(0);
}