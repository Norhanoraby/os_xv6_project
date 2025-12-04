#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

char buf[512];

// Flags for controlling output
int flag_lines = 0;
int flag_words = 0;
int flag_chars = 0;
int flag_longest = 0;
int show_all = 1;  // If no flags specified, show all

// Totals for multiple files
int total_l = 0;
int total_w = 0;
int total_c = 0;
int total_L = 0;
int file_count = 0;

void wc(int fd, char *name) {
  int i, n;
  int l, w, c, inword;
  int longest_line = 0;
  int current_line_len = 0;
  int has_content = 0;
  
  l = w = c = 0;
  inword = 0;
  
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      if(buf[i] == '\n'){
        l++;
        if(current_line_len > longest_line){
          longest_line = current_line_len;
        }
        current_line_len = 0;
        has_content = 0;
      } else {
        c++;  // Only count non-newline characters
        current_line_len++;
        has_content = 1;
      }
      
      if(strchr(" \r\t\n\v", buf[i]))
        inword = 0;
      else if(!inword){
        w++;
        inword = 1;
      }
    }
  }
  
  // If file doesn't end with newline but has content, count the last line
  if(has_content || current_line_len > 0){
    l++;
    if(current_line_len > longest_line){
      longest_line = current_line_len;
    }
  }
  
  if(n < 0){
    printf("wc: read error\n");
    exit(1);
  }
  
  // Update totals
  total_l += l;
  total_w += w;
  total_c += c;
  if(longest_line > total_L){
    total_L = longest_line;
  }
  file_count++;
  
  // Print results based on flags with readable format
  char *display_name = (name[0] == '\0') ? "stdin" : name;
  
  if(show_all){
    printf("File: %s\n", display_name);
    printf("  Lines: %d\n", l);
    printf("  Words: %d\n", w);
    printf("  Characters: %d\n", c);
    printf("\n");
  } else {
    printf("File: %s\n", display_name);
    if(flag_lines)
      printf("  Lines: %d\n", l);
    if(flag_words)
      printf("  Words: %d\n", w);
    if(flag_chars)
      printf("  Characters: %d\n", c);
    if(flag_longest)
      printf("  Longest line: %d\n", longest_line);
    printf("\n");
  }
}

int main(int argc, char *argv[]) {
  int fd, i;
  int first_file_idx = 1;
  
  // Parse flags
  for(i = 1; i < argc && argv[i][0] == '-'; i++){
    char *flag = argv[i];
    int j;
    
    for(j = 1; flag[j] != '\0'; j++){
      if(flag[j] == 'l'){
        flag_lines = 1;
        show_all = 0;
      } else if(flag[j] == 'w'){
        flag_words = 1;
        show_all = 0;
      } else if(flag[j] == 'c'){
        flag_chars = 1;
        show_all = 0;
      } else if(flag[j] == 'L'){
        flag_longest = 1;
        show_all = 0;
      } else {
        printf("wc: invalid option -- '%c'\n", flag[j]);
        printf("Usage: wc [-l] [-w] [-c] [-L] [file ...]\n");
        exit(1);
      }
    }
    first_file_idx++;
  }
  
  // If no files specified, read from stdin
  if(first_file_idx >= argc){
    wc(0, "");
    exit(0);
  }
  
  // Process each file
  for(i = first_file_idx; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
    close(fd);
  }
  
  // Print totals if multiple files
  if(file_count > 1){
    printf("===== TOTAL =====\n");
    if(show_all){
      printf("  Lines: %d\n", total_l);
      printf("  Words: %d\n", total_w);
      printf("  Characters: %d\n", total_c);
    } else {
      if(flag_lines)
        printf("  Lines: %d\n", total_l);
      if(flag_words)
        printf("  Words: %d\n", total_w);
      if(flag_chars)
        printf("  Characters: %d\n", total_c);
      if(flag_longest)
        printf("  Longest line: %d\n", total_L);
    }
    printf("\n");
  }
  
  exit(0);
}