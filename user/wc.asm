
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:
int total_w = 0;
int total_c = 0;
int total_L = 0;
int file_count = 0;

void wc(int fd, char *name) {
   0:	7175                	addi	sp,sp,-144
   2:	e506                	sd	ra,136(sp)
   4:	e122                	sd	s0,128(sp)
   6:	fca6                	sd	s1,120(sp)
   8:	f8ca                	sd	s2,112(sp)
   a:	f4ce                	sd	s3,104(sp)
   c:	f0d2                	sd	s4,96(sp)
   e:	ecd6                	sd	s5,88(sp)
  10:	e8da                	sd	s6,80(sp)
  12:	e4de                	sd	s7,72(sp)
  14:	e0e2                	sd	s8,64(sp)
  16:	fc66                	sd	s9,56(sp)
  18:	f86a                	sd	s10,48(sp)
  1a:	f46e                	sd	s11,40(sp)
  1c:	0900                	addi	s0,sp,144
  1e:	f8a43023          	sd	a0,-128(s0)
  22:	f6b43c23          	sd	a1,-136(s0)
  int i, n;
  int l, w, c, inword;
  int longest_line = 0;
  int current_line_len = 0;
  int has_content = 0;
  26:	f8043423          	sd	zero,-120(s0)
  int current_line_len = 0;
  2a:	4901                	li	s2,0
  int longest_line = 0;
  2c:	4b81                	li	s7,0
  
  l = w = c = 0;
  inword = 0;
  2e:	4b01                	li	s6,0
  l = w = c = 0;
  30:	4a81                	li	s5,0
  32:	4d81                	li	s11,0
  34:	4d01                	li	s10,0
  
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      if(buf[i] == '\n'){
  36:	4ca9                	li	s9,10
        l++;
        if(current_line_len > longest_line){
          longest_line = current_line_len;
        }
        current_line_len = 0;
        has_content = 0;
  38:	4a01                	li	s4,0
        c++;  // Only count non-newline characters
        current_line_len++;
        has_content = 1;
      }
      
      if(strchr(" \r\t\n\v", buf[i]))
  3a:	00001c17          	auipc	s8,0x1
  3e:	cb6c0c13          	addi	s8,s8,-842 # cf0 <malloc+0x112>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	20000613          	li	a2,512
  46:	00002597          	auipc	a1,0x2
  4a:	ffa58593          	addi	a1,a1,-6 # 2040 <buf>
  4e:	f8043503          	ld	a0,-128(s0)
  52:	690000ef          	jal	6e2 <read>
  56:	04a05a63          	blez	a0,aa <wc+0xaa>
    for(i=0; i<n; i++){
  5a:	00002497          	auipc	s1,0x2
  5e:	fe648493          	addi	s1,s1,-26 # 2040 <buf>
  62:	009509b3          	add	s3,a0,s1
  66:	a831                	j	82 <wc+0x82>
        c++;  // Only count non-newline characters
  68:	2a85                	addiw	s5,s5,1
        current_line_len++;
  6a:	2905                	addiw	s2,s2,1
        has_content = 1;
  6c:	4785                	li	a5,1
  6e:	f8f43423          	sd	a5,-120(s0)
      if(strchr(" \r\t\n\v", buf[i]))
  72:	8562                	mv	a0,s8
  74:	492000ef          	jal	506 <strchr>
  78:	c505                	beqz	a0,a0 <wc+0xa0>
        inword = 0;
  7a:	8b52                	mv	s6,s4
    for(i=0; i<n; i++){
  7c:	0485                	addi	s1,s1,1
  7e:	fc9982e3          	beq	s3,s1,42 <wc+0x42>
      if(buf[i] == '\n'){
  82:	0004c583          	lbu	a1,0(s1)
  86:	ff9591e3          	bne	a1,s9,68 <wc+0x68>
        l++;
  8a:	2d05                	addiw	s10,s10,1
        if(current_line_len > longest_line){
  8c:	87de                	mv	a5,s7
  8e:	012bd363          	bge	s7,s2,94 <wc+0x94>
  92:	87ca                	mv	a5,s2
  94:	00078b9b          	sext.w	s7,a5
        has_content = 0;
  98:	f9443423          	sd	s4,-120(s0)
        current_line_len = 0;
  9c:	8952                	mv	s2,s4
  9e:	bfd1                	j	72 <wc+0x72>
      else if(!inword){
  a0:	fc0b1ee3          	bnez	s6,7c <wc+0x7c>
        w++;
  a4:	2d85                	addiw	s11,s11,1
        inword = 1;
  a6:	4b05                	li	s6,1
  a8:	bfd1                	j	7c <wc+0x7c>
      }
    }
  }
  
  // If file doesn't end with newline but has content, count the last line
  if(has_content || current_line_len > 0){
  aa:	f8843783          	ld	a5,-120(s0)
  ae:	e399                	bnez	a5,b4 <wc+0xb4>
  b0:	01205963          	blez	s2,c2 <wc+0xc2>
    l++;
  b4:	2d05                	addiw	s10,s10,1
    if(current_line_len > longest_line){
  b6:	87de                	mv	a5,s7
  b8:	012bd363          	bge	s7,s2,be <wc+0xbe>
  bc:	87ca                	mv	a5,s2
  be:	00078b9b          	sext.w	s7,a5
      longest_line = current_line_len;
    }
  }
  
  if(n < 0){
  c2:	0c054d63          	bltz	a0,19c <wc+0x19c>
    printf("wc: read error\n");
    exit(1);
  }
  
  // Update totals
  total_l += l;
  c6:	00002717          	auipc	a4,0x2
  ca:	f5a70713          	addi	a4,a4,-166 # 2020 <total_l>
  ce:	431c                	lw	a5,0(a4)
  d0:	01a787bb          	addw	a5,a5,s10
  d4:	c31c                	sw	a5,0(a4)
  total_w += w;
  d6:	00002717          	auipc	a4,0x2
  da:	f4670713          	addi	a4,a4,-186 # 201c <total_w>
  de:	431c                	lw	a5,0(a4)
  e0:	01b787bb          	addw	a5,a5,s11
  e4:	c31c                	sw	a5,0(a4)
  total_c += c;
  e6:	00002717          	auipc	a4,0x2
  ea:	f3270713          	addi	a4,a4,-206 # 2018 <total_c>
  ee:	431c                	lw	a5,0(a4)
  f0:	015787bb          	addw	a5,a5,s5
  f4:	c31c                	sw	a5,0(a4)
  if(longest_line > total_L){
  f6:	00002797          	auipc	a5,0x2
  fa:	f1e7a783          	lw	a5,-226(a5) # 2014 <total_L>
  fe:	0177d663          	bge	a5,s7,10a <wc+0x10a>
    total_L = longest_line;
 102:	00002797          	auipc	a5,0x2
 106:	f177a923          	sw	s7,-238(a5) # 2014 <total_L>
  }
  file_count++;
 10a:	00002717          	auipc	a4,0x2
 10e:	f0670713          	addi	a4,a4,-250 # 2010 <file_count>
 112:	431c                	lw	a5,0(a4)
 114:	2785                	addiw	a5,a5,1
 116:	c31c                	sw	a5,0(a4)
  
  // Print results based on flags with readable format
  char *display_name = (name[0] == '\0') ? "stdin" : name;
 118:	f7843783          	ld	a5,-136(s0)
 11c:	0007c783          	lbu	a5,0(a5)
 120:	e799                	bnez	a5,12e <wc+0x12e>
 122:	00001797          	auipc	a5,0x1
 126:	bbe78793          	addi	a5,a5,-1090 # ce0 <malloc+0x102>
 12a:	f6f43c23          	sd	a5,-136(s0)
  
  if(show_all){
 12e:	00002797          	auipc	a5,0x2
 132:	ed27a783          	lw	a5,-302(a5) # 2000 <show_all>
 136:	cfa5                	beqz	a5,1ae <wc+0x1ae>
    printf("File: %s\n", display_name);
 138:	f7843583          	ld	a1,-136(s0)
 13c:	00001517          	auipc	a0,0x1
 140:	bcc50513          	addi	a0,a0,-1076 # d08 <malloc+0x12a>
 144:	1e7000ef          	jal	b2a <printf>
    printf("  Lines: %d\n", l);
 148:	85ea                	mv	a1,s10
 14a:	00001517          	auipc	a0,0x1
 14e:	bce50513          	addi	a0,a0,-1074 # d18 <malloc+0x13a>
 152:	1d9000ef          	jal	b2a <printf>
    printf("  Words: %d\n", w);
 156:	85ee                	mv	a1,s11
 158:	00001517          	auipc	a0,0x1
 15c:	bd050513          	addi	a0,a0,-1072 # d28 <malloc+0x14a>
 160:	1cb000ef          	jal	b2a <printf>
    printf("  Characters: %d\n", c);
 164:	85d6                	mv	a1,s5
 166:	00001517          	auipc	a0,0x1
 16a:	bd250513          	addi	a0,a0,-1070 # d38 <malloc+0x15a>
 16e:	1bd000ef          	jal	b2a <printf>
    printf("\n");
 172:	00001517          	auipc	a0,0x1
 176:	c3e50513          	addi	a0,a0,-962 # db0 <malloc+0x1d2>
 17a:	1b1000ef          	jal	b2a <printf>
      printf("  Characters: %d\n", c);
    if(flag_longest)
      printf("  Longest line: %d\n", longest_line);
    printf("\n");
  }
}
 17e:	60aa                	ld	ra,136(sp)
 180:	640a                	ld	s0,128(sp)
 182:	74e6                	ld	s1,120(sp)
 184:	7946                	ld	s2,112(sp)
 186:	79a6                	ld	s3,104(sp)
 188:	7a06                	ld	s4,96(sp)
 18a:	6ae6                	ld	s5,88(sp)
 18c:	6b46                	ld	s6,80(sp)
 18e:	6ba6                	ld	s7,72(sp)
 190:	6c06                	ld	s8,64(sp)
 192:	7ce2                	ld	s9,56(sp)
 194:	7d42                	ld	s10,48(sp)
 196:	7da2                	ld	s11,40(sp)
 198:	6149                	addi	sp,sp,144
 19a:	8082                	ret
    printf("wc: read error\n");
 19c:	00001517          	auipc	a0,0x1
 1a0:	b5c50513          	addi	a0,a0,-1188 # cf8 <malloc+0x11a>
 1a4:	187000ef          	jal	b2a <printf>
    exit(1);
 1a8:	4505                	li	a0,1
 1aa:	520000ef          	jal	6ca <exit>
    printf("File: %s\n", display_name);
 1ae:	f7843583          	ld	a1,-136(s0)
 1b2:	00001517          	auipc	a0,0x1
 1b6:	b5650513          	addi	a0,a0,-1194 # d08 <malloc+0x12a>
 1ba:	171000ef          	jal	b2a <printf>
    if(flag_lines)
 1be:	00002797          	auipc	a5,0x2
 1c2:	e727a783          	lw	a5,-398(a5) # 2030 <flag_lines>
 1c6:	e79d                	bnez	a5,1f4 <wc+0x1f4>
    if(flag_words)
 1c8:	00002797          	auipc	a5,0x2
 1cc:	e647a783          	lw	a5,-412(a5) # 202c <flag_words>
 1d0:	eb95                	bnez	a5,204 <wc+0x204>
    if(flag_chars)
 1d2:	00002797          	auipc	a5,0x2
 1d6:	e567a783          	lw	a5,-426(a5) # 2028 <flag_chars>
 1da:	ef8d                	bnez	a5,214 <wc+0x214>
    if(flag_longest)
 1dc:	00002797          	auipc	a5,0x2
 1e0:	e487a783          	lw	a5,-440(a5) # 2024 <flag_longest>
 1e4:	e3a1                	bnez	a5,224 <wc+0x224>
    printf("\n");
 1e6:	00001517          	auipc	a0,0x1
 1ea:	bca50513          	addi	a0,a0,-1078 # db0 <malloc+0x1d2>
 1ee:	13d000ef          	jal	b2a <printf>
}
 1f2:	b771                	j	17e <wc+0x17e>
      printf("  Lines: %d\n", l);
 1f4:	85ea                	mv	a1,s10
 1f6:	00001517          	auipc	a0,0x1
 1fa:	b2250513          	addi	a0,a0,-1246 # d18 <malloc+0x13a>
 1fe:	12d000ef          	jal	b2a <printf>
 202:	b7d9                	j	1c8 <wc+0x1c8>
      printf("  Words: %d\n", w);
 204:	85ee                	mv	a1,s11
 206:	00001517          	auipc	a0,0x1
 20a:	b2250513          	addi	a0,a0,-1246 # d28 <malloc+0x14a>
 20e:	11d000ef          	jal	b2a <printf>
 212:	b7c1                	j	1d2 <wc+0x1d2>
      printf("  Characters: %d\n", c);
 214:	85d6                	mv	a1,s5
 216:	00001517          	auipc	a0,0x1
 21a:	b2250513          	addi	a0,a0,-1246 # d38 <malloc+0x15a>
 21e:	10d000ef          	jal	b2a <printf>
 222:	bf6d                	j	1dc <wc+0x1dc>
      printf("  Longest line: %d\n", longest_line);
 224:	85de                	mv	a1,s7
 226:	00001517          	auipc	a0,0x1
 22a:	b2a50513          	addi	a0,a0,-1238 # d50 <malloc+0x172>
 22e:	0fd000ef          	jal	b2a <printf>
 232:	bf55                	j	1e6 <wc+0x1e6>

0000000000000234 <main>:

int main(int argc, char *argv[]) {
 234:	7179                	addi	sp,sp,-48
 236:	f406                	sd	ra,40(sp)
 238:	f022                	sd	s0,32(sp)
 23a:	ec26                	sd	s1,24(sp)
 23c:	e84a                	sd	s2,16(sp)
 23e:	1800                	addi	s0,sp,48
  int fd, i;
  int first_file_idx = 1;
  
  // Parse flags
  for(i = 1; i < argc && argv[i][0] == '-'; i++){
 240:	4785                	li	a5,1
 242:	10a7d863          	bge	a5,a0,352 <main+0x11e>
 246:	80ae                	mv	ra,a1
 248:	00858f93          	addi	t6,a1,8
  int first_file_idx = 1;
 24c:	4285                	li	t0,1
  for(i = 1; i < argc && argv[i][0] == '-'; i++){
 24e:	02d00913          	li	s2,45
    char *flag = argv[i];
    int j;
    
    for(j = 1; flag[j] != '\0'; j++){
      if(flag[j] == 'l'){
 252:	06c00713          	li	a4,108
        flag_lines = 1;
        show_all = 0;
      } else if(flag[j] == 'w'){
 256:	07700813          	li	a6,119
        flag_words = 1;
        show_all = 0;
      } else if(flag[j] == 'c'){
 25a:	06300893          	li	a7,99
        flag_chars = 1;
        show_all = 0;
      } else if(flag[j] == 'L'){
 25e:	04c00e13          	li	t3,76
        flag_longest = 1;
 262:	00002e97          	auipc	t4,0x2
 266:	dc2e8e93          	addi	t4,t4,-574 # 2024 <flag_longest>
 26a:	4605                	li	a2,1
        flag_chars = 1;
 26c:	00002397          	auipc	t2,0x2
 270:	dbc38393          	addi	t2,t2,-580 # 2028 <flag_chars>
        flag_words = 1;
 274:	00002f17          	auipc	t5,0x2
 278:	db8f0f13          	addi	t5,t5,-584 # 202c <flag_words>
        flag_lines = 1;
 27c:	00002317          	auipc	t1,0x2
 280:	db430313          	addi	t1,t1,-588 # 2030 <flag_lines>
        show_all = 0;
 284:	00002697          	auipc	a3,0x2
 288:	d7c68693          	addi	a3,a3,-644 # 2000 <show_all>
 28c:	a8b1                	j	2e8 <main+0xb4>
        flag_lines = 1;
 28e:	00c32023          	sw	a2,0(t1)
        show_all = 0;
 292:	0006a023          	sw	zero,0(a3)
    for(j = 1; flag[j] != '\0'; j++){
 296:	0785                	addi	a5,a5,1
 298:	fff7c583          	lbu	a1,-1(a5)
 29c:	c1b1                	beqz	a1,2e0 <main+0xac>
      if(flag[j] == 'l'){
 29e:	fee588e3          	beq	a1,a4,28e <main+0x5a>
      } else if(flag[j] == 'w'){
 2a2:	01058963          	beq	a1,a6,2b4 <main+0x80>
      } else if(flag[j] == 'c'){
 2a6:	01158a63          	beq	a1,a7,2ba <main+0x86>
      } else if(flag[j] == 'L'){
 2aa:	01c59b63          	bne	a1,t3,2c0 <main+0x8c>
        flag_longest = 1;
 2ae:	00cea023          	sw	a2,0(t4)
        show_all = 0;
 2b2:	b7c5                	j	292 <main+0x5e>
        flag_words = 1;
 2b4:	00cf2023          	sw	a2,0(t5)
        show_all = 0;
 2b8:	bfe9                	j	292 <main+0x5e>
        flag_chars = 1;
 2ba:	00c3a023          	sw	a2,0(t2)
        show_all = 0;
 2be:	bfd1                	j	292 <main+0x5e>
 2c0:	e44e                	sd	s3,8(sp)
      } else {
        printf("wc: invalid option -- '%c'\n", flag[j]);
 2c2:	00001517          	auipc	a0,0x1
 2c6:	aa650513          	addi	a0,a0,-1370 # d68 <malloc+0x18a>
 2ca:	061000ef          	jal	b2a <printf>
        printf("Usage: wc [-l] [-w] [-c] [-L] [file ...]\n");
 2ce:	00001517          	auipc	a0,0x1
 2d2:	aba50513          	addi	a0,a0,-1350 # d88 <malloc+0x1aa>
 2d6:	055000ef          	jal	b2a <printf>
        exit(1);
 2da:	4505                	li	a0,1
 2dc:	3ee000ef          	jal	6ca <exit>
      }
    }
    first_file_idx++;
 2e0:	2285                	addiw	t0,t0,1
  for(i = 1; i < argc && argv[i][0] == '-'; i++){
 2e2:	0fa1                	addi	t6,t6,8
 2e4:	06550763          	beq	a0,t0,352 <main+0x11e>
 2e8:	000fb783          	ld	a5,0(t6)
 2ec:	0007c483          	lbu	s1,0(a5)
 2f0:	01249763          	bne	s1,s2,2fe <main+0xca>
    for(j = 1; flag[j] != '\0'; j++){
 2f4:	0017c583          	lbu	a1,1(a5)
 2f8:	0789                	addi	a5,a5,2
 2fa:	f1d5                	bnez	a1,29e <main+0x6a>
 2fc:	b7d5                	j	2e0 <main+0xac>
  }
  
  // If no files specified, read from stdin
  if(first_file_idx >= argc){
 2fe:	04a2da63          	bge	t0,a0,352 <main+0x11e>
 302:	e44e                	sd	s3,8(sp)
 304:	00329913          	slli	s2,t0,0x3
 308:	9906                	add	s2,s2,ra
 30a:	405507bb          	subw	a5,a0,t0
 30e:	1782                	slli	a5,a5,0x20
 310:	9381                	srli	a5,a5,0x20
 312:	9796                	add	a5,a5,t0
 314:	078e                	slli	a5,a5,0x3
 316:	00f089b3          	add	s3,ra,a5
    exit(0);
  }
  
  // Process each file
  for(i = first_file_idx; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 31a:	4581                	li	a1,0
 31c:	00093503          	ld	a0,0(s2)
 320:	3ea000ef          	jal	70a <open>
 324:	84aa                	mv	s1,a0
 326:	04054163          	bltz	a0,368 <main+0x134>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 32a:	00093583          	ld	a1,0(s2)
 32e:	cd3ff0ef          	jal	0 <wc>
    close(fd);
 332:	8526                	mv	a0,s1
 334:	3be000ef          	jal	6f2 <close>
  for(i = first_file_idx; i < argc; i++){
 338:	0921                	addi	s2,s2,8
 33a:	ff3910e3          	bne	s2,s3,31a <main+0xe6>
  }
  
  // Print totals if multiple files
  if(file_count > 1){
 33e:	00002717          	auipc	a4,0x2
 342:	cd272703          	lw	a4,-814(a4) # 2010 <file_count>
 346:	4785                	li	a5,1
 348:	02e7cb63          	blt	a5,a4,37e <main+0x14a>
        printf("  Longest line: %d\n", total_L);
    }
    printf("\n");
  }
  
  exit(0);
 34c:	4501                	li	a0,0
 34e:	37c000ef          	jal	6ca <exit>
 352:	e44e                	sd	s3,8(sp)
    wc(0, "");
 354:	00001597          	auipc	a1,0x1
 358:	99458593          	addi	a1,a1,-1644 # ce8 <malloc+0x10a>
 35c:	4501                	li	a0,0
 35e:	ca3ff0ef          	jal	0 <wc>
    exit(0);
 362:	4501                	li	a0,0
 364:	366000ef          	jal	6ca <exit>
      printf("wc: cannot open %s\n", argv[i]);
 368:	00093583          	ld	a1,0(s2)
 36c:	00001517          	auipc	a0,0x1
 370:	a4c50513          	addi	a0,a0,-1460 # db8 <malloc+0x1da>
 374:	7b6000ef          	jal	b2a <printf>
      exit(1);
 378:	4505                	li	a0,1
 37a:	350000ef          	jal	6ca <exit>
    printf("===== TOTAL =====\n");
 37e:	00001517          	auipc	a0,0x1
 382:	a5250513          	addi	a0,a0,-1454 # dd0 <malloc+0x1f2>
 386:	7a4000ef          	jal	b2a <printf>
    if(show_all){
 38a:	00002797          	auipc	a5,0x2
 38e:	c767a783          	lw	a5,-906(a5) # 2000 <show_all>
 392:	ef85                	bnez	a5,3ca <main+0x196>
      if(flag_lines)
 394:	00002797          	auipc	a5,0x2
 398:	c9c7a783          	lw	a5,-868(a5) # 2030 <flag_lines>
 39c:	e7b5                	bnez	a5,408 <main+0x1d4>
      if(flag_words)
 39e:	00002797          	auipc	a5,0x2
 3a2:	c8e7a783          	lw	a5,-882(a5) # 202c <flag_words>
 3a6:	efa5                	bnez	a5,41e <main+0x1ea>
      if(flag_chars)
 3a8:	00002797          	auipc	a5,0x2
 3ac:	c807a783          	lw	a5,-896(a5) # 2028 <flag_chars>
 3b0:	e3d1                	bnez	a5,434 <main+0x200>
      if(flag_longest)
 3b2:	00002797          	auipc	a5,0x2
 3b6:	c727a783          	lw	a5,-910(a5) # 2024 <flag_longest>
 3ba:	ebc1                	bnez	a5,44a <main+0x216>
    printf("\n");
 3bc:	00001517          	auipc	a0,0x1
 3c0:	9f450513          	addi	a0,a0,-1548 # db0 <malloc+0x1d2>
 3c4:	766000ef          	jal	b2a <printf>
 3c8:	b751                	j	34c <main+0x118>
      printf("  Lines: %d\n", total_l);
 3ca:	00002597          	auipc	a1,0x2
 3ce:	c565a583          	lw	a1,-938(a1) # 2020 <total_l>
 3d2:	00001517          	auipc	a0,0x1
 3d6:	94650513          	addi	a0,a0,-1722 # d18 <malloc+0x13a>
 3da:	750000ef          	jal	b2a <printf>
      printf("  Words: %d\n", total_w);
 3de:	00002597          	auipc	a1,0x2
 3e2:	c3e5a583          	lw	a1,-962(a1) # 201c <total_w>
 3e6:	00001517          	auipc	a0,0x1
 3ea:	94250513          	addi	a0,a0,-1726 # d28 <malloc+0x14a>
 3ee:	73c000ef          	jal	b2a <printf>
      printf("  Characters: %d\n", total_c);
 3f2:	00002597          	auipc	a1,0x2
 3f6:	c265a583          	lw	a1,-986(a1) # 2018 <total_c>
 3fa:	00001517          	auipc	a0,0x1
 3fe:	93e50513          	addi	a0,a0,-1730 # d38 <malloc+0x15a>
 402:	728000ef          	jal	b2a <printf>
 406:	bf5d                	j	3bc <main+0x188>
        printf("  Lines: %d\n", total_l);
 408:	00002597          	auipc	a1,0x2
 40c:	c185a583          	lw	a1,-1000(a1) # 2020 <total_l>
 410:	00001517          	auipc	a0,0x1
 414:	90850513          	addi	a0,a0,-1784 # d18 <malloc+0x13a>
 418:	712000ef          	jal	b2a <printf>
 41c:	b749                	j	39e <main+0x16a>
        printf("  Words: %d\n", total_w);
 41e:	00002597          	auipc	a1,0x2
 422:	bfe5a583          	lw	a1,-1026(a1) # 201c <total_w>
 426:	00001517          	auipc	a0,0x1
 42a:	90250513          	addi	a0,a0,-1790 # d28 <malloc+0x14a>
 42e:	6fc000ef          	jal	b2a <printf>
 432:	bf9d                	j	3a8 <main+0x174>
        printf("  Characters: %d\n", total_c);
 434:	00002597          	auipc	a1,0x2
 438:	be45a583          	lw	a1,-1052(a1) # 2018 <total_c>
 43c:	00001517          	auipc	a0,0x1
 440:	8fc50513          	addi	a0,a0,-1796 # d38 <malloc+0x15a>
 444:	6e6000ef          	jal	b2a <printf>
 448:	b7ad                	j	3b2 <main+0x17e>
        printf("  Longest line: %d\n", total_L);
 44a:	00002597          	auipc	a1,0x2
 44e:	bca5a583          	lw	a1,-1078(a1) # 2014 <total_L>
 452:	00001517          	auipc	a0,0x1
 456:	8fe50513          	addi	a0,a0,-1794 # d50 <malloc+0x172>
 45a:	6d0000ef          	jal	b2a <printf>
 45e:	bfb9                	j	3bc <main+0x188>

0000000000000460 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 460:	1141                	addi	sp,sp,-16
 462:	e406                	sd	ra,8(sp)
 464:	e022                	sd	s0,0(sp)
 466:	0800                	addi	s0,sp,16
  extern int main();
  main();
 468:	dcdff0ef          	jal	234 <main>
  exit(0);
 46c:	4501                	li	a0,0
 46e:	25c000ef          	jal	6ca <exit>

0000000000000472 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 472:	1141                	addi	sp,sp,-16
 474:	e422                	sd	s0,8(sp)
 476:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 478:	87aa                	mv	a5,a0
 47a:	0585                	addi	a1,a1,1
 47c:	0785                	addi	a5,a5,1
 47e:	fff5c703          	lbu	a4,-1(a1)
 482:	fee78fa3          	sb	a4,-1(a5)
 486:	fb75                	bnez	a4,47a <strcpy+0x8>
    ;
  return os;
}
 488:	6422                	ld	s0,8(sp)
 48a:	0141                	addi	sp,sp,16
 48c:	8082                	ret

000000000000048e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 48e:	1141                	addi	sp,sp,-16
 490:	e422                	sd	s0,8(sp)
 492:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 494:	00054783          	lbu	a5,0(a0)
 498:	cb91                	beqz	a5,4ac <strcmp+0x1e>
 49a:	0005c703          	lbu	a4,0(a1)
 49e:	00f71763          	bne	a4,a5,4ac <strcmp+0x1e>
    p++, q++;
 4a2:	0505                	addi	a0,a0,1
 4a4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4a6:	00054783          	lbu	a5,0(a0)
 4aa:	fbe5                	bnez	a5,49a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4ac:	0005c503          	lbu	a0,0(a1)
}
 4b0:	40a7853b          	subw	a0,a5,a0
 4b4:	6422                	ld	s0,8(sp)
 4b6:	0141                	addi	sp,sp,16
 4b8:	8082                	ret

00000000000004ba <strlen>:

uint
strlen(const char *s)
{
 4ba:	1141                	addi	sp,sp,-16
 4bc:	e422                	sd	s0,8(sp)
 4be:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4c0:	00054783          	lbu	a5,0(a0)
 4c4:	cf91                	beqz	a5,4e0 <strlen+0x26>
 4c6:	0505                	addi	a0,a0,1
 4c8:	87aa                	mv	a5,a0
 4ca:	86be                	mv	a3,a5
 4cc:	0785                	addi	a5,a5,1
 4ce:	fff7c703          	lbu	a4,-1(a5)
 4d2:	ff65                	bnez	a4,4ca <strlen+0x10>
 4d4:	40a6853b          	subw	a0,a3,a0
 4d8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 4da:	6422                	ld	s0,8(sp)
 4dc:	0141                	addi	sp,sp,16
 4de:	8082                	ret
  for(n = 0; s[n]; n++)
 4e0:	4501                	li	a0,0
 4e2:	bfe5                	j	4da <strlen+0x20>

00000000000004e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4e4:	1141                	addi	sp,sp,-16
 4e6:	e422                	sd	s0,8(sp)
 4e8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4ea:	ca19                	beqz	a2,500 <memset+0x1c>
 4ec:	87aa                	mv	a5,a0
 4ee:	1602                	slli	a2,a2,0x20
 4f0:	9201                	srli	a2,a2,0x20
 4f2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 4f6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4fa:	0785                	addi	a5,a5,1
 4fc:	fee79de3          	bne	a5,a4,4f6 <memset+0x12>
  }
  return dst;
}
 500:	6422                	ld	s0,8(sp)
 502:	0141                	addi	sp,sp,16
 504:	8082                	ret

0000000000000506 <strchr>:

char*
strchr(const char *s, char c)
{
 506:	1141                	addi	sp,sp,-16
 508:	e422                	sd	s0,8(sp)
 50a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 50c:	00054783          	lbu	a5,0(a0)
 510:	cb99                	beqz	a5,526 <strchr+0x20>
    if(*s == c)
 512:	00f58763          	beq	a1,a5,520 <strchr+0x1a>
  for(; *s; s++)
 516:	0505                	addi	a0,a0,1
 518:	00054783          	lbu	a5,0(a0)
 51c:	fbfd                	bnez	a5,512 <strchr+0xc>
      return (char*)s;
  return 0;
 51e:	4501                	li	a0,0
}
 520:	6422                	ld	s0,8(sp)
 522:	0141                	addi	sp,sp,16
 524:	8082                	ret
  return 0;
 526:	4501                	li	a0,0
 528:	bfe5                	j	520 <strchr+0x1a>

000000000000052a <gets>:

char*
gets(char *buf, int max)
{
 52a:	711d                	addi	sp,sp,-96
 52c:	ec86                	sd	ra,88(sp)
 52e:	e8a2                	sd	s0,80(sp)
 530:	e4a6                	sd	s1,72(sp)
 532:	e0ca                	sd	s2,64(sp)
 534:	fc4e                	sd	s3,56(sp)
 536:	f852                	sd	s4,48(sp)
 538:	f456                	sd	s5,40(sp)
 53a:	f05a                	sd	s6,32(sp)
 53c:	ec5e                	sd	s7,24(sp)
 53e:	1080                	addi	s0,sp,96
 540:	8baa                	mv	s7,a0
 542:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 544:	892a                	mv	s2,a0
 546:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 548:	4aa9                	li	s5,10
 54a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 54c:	89a6                	mv	s3,s1
 54e:	2485                	addiw	s1,s1,1
 550:	0344d663          	bge	s1,s4,57c <gets+0x52>
    cc = read(0, &c, 1);
 554:	4605                	li	a2,1
 556:	faf40593          	addi	a1,s0,-81
 55a:	4501                	li	a0,0
 55c:	186000ef          	jal	6e2 <read>
    if(cc < 1)
 560:	00a05e63          	blez	a0,57c <gets+0x52>
    buf[i++] = c;
 564:	faf44783          	lbu	a5,-81(s0)
 568:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 56c:	01578763          	beq	a5,s5,57a <gets+0x50>
 570:	0905                	addi	s2,s2,1
 572:	fd679de3          	bne	a5,s6,54c <gets+0x22>
    buf[i++] = c;
 576:	89a6                	mv	s3,s1
 578:	a011                	j	57c <gets+0x52>
 57a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 57c:	99de                	add	s3,s3,s7
 57e:	00098023          	sb	zero,0(s3)
  return buf;
}
 582:	855e                	mv	a0,s7
 584:	60e6                	ld	ra,88(sp)
 586:	6446                	ld	s0,80(sp)
 588:	64a6                	ld	s1,72(sp)
 58a:	6906                	ld	s2,64(sp)
 58c:	79e2                	ld	s3,56(sp)
 58e:	7a42                	ld	s4,48(sp)
 590:	7aa2                	ld	s5,40(sp)
 592:	7b02                	ld	s6,32(sp)
 594:	6be2                	ld	s7,24(sp)
 596:	6125                	addi	sp,sp,96
 598:	8082                	ret

000000000000059a <stat>:

int
stat(const char *n, struct stat *st)
{
 59a:	1101                	addi	sp,sp,-32
 59c:	ec06                	sd	ra,24(sp)
 59e:	e822                	sd	s0,16(sp)
 5a0:	e04a                	sd	s2,0(sp)
 5a2:	1000                	addi	s0,sp,32
 5a4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5a6:	4581                	li	a1,0
 5a8:	162000ef          	jal	70a <open>
  if(fd < 0)
 5ac:	02054263          	bltz	a0,5d0 <stat+0x36>
 5b0:	e426                	sd	s1,8(sp)
 5b2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5b4:	85ca                	mv	a1,s2
 5b6:	16c000ef          	jal	722 <fstat>
 5ba:	892a                	mv	s2,a0
  close(fd);
 5bc:	8526                	mv	a0,s1
 5be:	134000ef          	jal	6f2 <close>
  return r;
 5c2:	64a2                	ld	s1,8(sp)
}
 5c4:	854a                	mv	a0,s2
 5c6:	60e2                	ld	ra,24(sp)
 5c8:	6442                	ld	s0,16(sp)
 5ca:	6902                	ld	s2,0(sp)
 5cc:	6105                	addi	sp,sp,32
 5ce:	8082                	ret
    return -1;
 5d0:	597d                	li	s2,-1
 5d2:	bfcd                	j	5c4 <stat+0x2a>

00000000000005d4 <atoi>:

int
atoi(const char *s)
{
 5d4:	1141                	addi	sp,sp,-16
 5d6:	e422                	sd	s0,8(sp)
 5d8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5da:	00054683          	lbu	a3,0(a0)
 5de:	fd06879b          	addiw	a5,a3,-48
 5e2:	0ff7f793          	zext.b	a5,a5
 5e6:	4625                	li	a2,9
 5e8:	02f66863          	bltu	a2,a5,618 <atoi+0x44>
 5ec:	872a                	mv	a4,a0
  n = 0;
 5ee:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 5f0:	0705                	addi	a4,a4,1
 5f2:	0025179b          	slliw	a5,a0,0x2
 5f6:	9fa9                	addw	a5,a5,a0
 5f8:	0017979b          	slliw	a5,a5,0x1
 5fc:	9fb5                	addw	a5,a5,a3
 5fe:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 602:	00074683          	lbu	a3,0(a4)
 606:	fd06879b          	addiw	a5,a3,-48
 60a:	0ff7f793          	zext.b	a5,a5
 60e:	fef671e3          	bgeu	a2,a5,5f0 <atoi+0x1c>
  return n;
}
 612:	6422                	ld	s0,8(sp)
 614:	0141                	addi	sp,sp,16
 616:	8082                	ret
  n = 0;
 618:	4501                	li	a0,0
 61a:	bfe5                	j	612 <atoi+0x3e>

000000000000061c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 61c:	1141                	addi	sp,sp,-16
 61e:	e422                	sd	s0,8(sp)
 620:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 622:	02b57463          	bgeu	a0,a1,64a <memmove+0x2e>
    while(n-- > 0)
 626:	00c05f63          	blez	a2,644 <memmove+0x28>
 62a:	1602                	slli	a2,a2,0x20
 62c:	9201                	srli	a2,a2,0x20
 62e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 632:	872a                	mv	a4,a0
      *dst++ = *src++;
 634:	0585                	addi	a1,a1,1
 636:	0705                	addi	a4,a4,1
 638:	fff5c683          	lbu	a3,-1(a1)
 63c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 640:	fef71ae3          	bne	a4,a5,634 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 644:	6422                	ld	s0,8(sp)
 646:	0141                	addi	sp,sp,16
 648:	8082                	ret
    dst += n;
 64a:	00c50733          	add	a4,a0,a2
    src += n;
 64e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 650:	fec05ae3          	blez	a2,644 <memmove+0x28>
 654:	fff6079b          	addiw	a5,a2,-1
 658:	1782                	slli	a5,a5,0x20
 65a:	9381                	srli	a5,a5,0x20
 65c:	fff7c793          	not	a5,a5
 660:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 662:	15fd                	addi	a1,a1,-1
 664:	177d                	addi	a4,a4,-1
 666:	0005c683          	lbu	a3,0(a1)
 66a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 66e:	fee79ae3          	bne	a5,a4,662 <memmove+0x46>
 672:	bfc9                	j	644 <memmove+0x28>

0000000000000674 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 674:	1141                	addi	sp,sp,-16
 676:	e422                	sd	s0,8(sp)
 678:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 67a:	ca05                	beqz	a2,6aa <memcmp+0x36>
 67c:	fff6069b          	addiw	a3,a2,-1
 680:	1682                	slli	a3,a3,0x20
 682:	9281                	srli	a3,a3,0x20
 684:	0685                	addi	a3,a3,1
 686:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 688:	00054783          	lbu	a5,0(a0)
 68c:	0005c703          	lbu	a4,0(a1)
 690:	00e79863          	bne	a5,a4,6a0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 694:	0505                	addi	a0,a0,1
    p2++;
 696:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 698:	fed518e3          	bne	a0,a3,688 <memcmp+0x14>
  }
  return 0;
 69c:	4501                	li	a0,0
 69e:	a019                	j	6a4 <memcmp+0x30>
      return *p1 - *p2;
 6a0:	40e7853b          	subw	a0,a5,a4
}
 6a4:	6422                	ld	s0,8(sp)
 6a6:	0141                	addi	sp,sp,16
 6a8:	8082                	ret
  return 0;
 6aa:	4501                	li	a0,0
 6ac:	bfe5                	j	6a4 <memcmp+0x30>

00000000000006ae <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6ae:	1141                	addi	sp,sp,-16
 6b0:	e406                	sd	ra,8(sp)
 6b2:	e022                	sd	s0,0(sp)
 6b4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6b6:	f67ff0ef          	jal	61c <memmove>
}
 6ba:	60a2                	ld	ra,8(sp)
 6bc:	6402                	ld	s0,0(sp)
 6be:	0141                	addi	sp,sp,16
 6c0:	8082                	ret

00000000000006c2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6c2:	4885                	li	a7,1
 ecall
 6c4:	00000073          	ecall
 ret
 6c8:	8082                	ret

00000000000006ca <exit>:
.global exit
exit:
 li a7, SYS_exit
 6ca:	4889                	li	a7,2
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 6d2:	488d                	li	a7,3
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6da:	4891                	li	a7,4
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <read>:
.global read
read:
 li a7, SYS_read
 6e2:	4895                	li	a7,5
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	8082                	ret

00000000000006ea <write>:
.global write
write:
 li a7, SYS_write
 6ea:	48c1                	li	a7,16
 ecall
 6ec:	00000073          	ecall
 ret
 6f0:	8082                	ret

00000000000006f2 <close>:
.global close
close:
 li a7, SYS_close
 6f2:	48d5                	li	a7,21
 ecall
 6f4:	00000073          	ecall
 ret
 6f8:	8082                	ret

00000000000006fa <kill>:
.global kill
kill:
 li a7, SYS_kill
 6fa:	4899                	li	a7,6
 ecall
 6fc:	00000073          	ecall
 ret
 700:	8082                	ret

0000000000000702 <exec>:
.global exec
exec:
 li a7, SYS_exec
 702:	489d                	li	a7,7
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <open>:
.global open
open:
 li a7, SYS_open
 70a:	48bd                	li	a7,15
 ecall
 70c:	00000073          	ecall
 ret
 710:	8082                	ret

0000000000000712 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 712:	48c5                	li	a7,17
 ecall
 714:	00000073          	ecall
 ret
 718:	8082                	ret

000000000000071a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 71a:	48c9                	li	a7,18
 ecall
 71c:	00000073          	ecall
 ret
 720:	8082                	ret

0000000000000722 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 722:	48a1                	li	a7,8
 ecall
 724:	00000073          	ecall
 ret
 728:	8082                	ret

000000000000072a <link>:
.global link
link:
 li a7, SYS_link
 72a:	48cd                	li	a7,19
 ecall
 72c:	00000073          	ecall
 ret
 730:	8082                	ret

0000000000000732 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 732:	48d1                	li	a7,20
 ecall
 734:	00000073          	ecall
 ret
 738:	8082                	ret

000000000000073a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 73a:	48a5                	li	a7,9
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <dup>:
.global dup
dup:
 li a7, SYS_dup
 742:	48a9                	li	a7,10
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 74a:	48ad                	li	a7,11
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 752:	48b1                	li	a7,12
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 75a:	48b5                	li	a7,13
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 762:	48b9                	li	a7,14
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 76a:	48d9                	li	a7,22
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 772:	48dd                	li	a7,23
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 77a:	48e1                	li	a7,24
 ecall
 77c:	00000073          	ecall
 ret
 780:	8082                	ret

0000000000000782 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 782:	48e5                	li	a7,25
 ecall
 784:	00000073          	ecall
 ret
 788:	8082                	ret

000000000000078a <random>:
.global random
random:
 li a7, SYS_random
 78a:	48e9                	li	a7,26
 ecall
 78c:	00000073          	ecall
 ret
 790:	8082                	ret

0000000000000792 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 792:	48ed                	li	a7,27
 ecall
 794:	00000073          	ecall
 ret
 798:	8082                	ret

000000000000079a <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 79a:	48f1                	li	a7,28
 ecall
 79c:	00000073          	ecall
 ret
 7a0:	8082                	ret

00000000000007a2 <set_sched>:
.global set_sched
set_sched:
 li a7, SYS_set_sched
 7a2:	48f5                	li	a7,29
 ecall
 7a4:	00000073          	ecall
 ret
 7a8:	8082                	ret

00000000000007aa <wait_sched>:
.global wait_sched
wait_sched:
 li a7, SYS_wait_sched
 7aa:	48f9                	li	a7,30
 ecall
 7ac:	00000073          	ecall
 ret
 7b0:	8082                	ret

00000000000007b2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7b2:	1101                	addi	sp,sp,-32
 7b4:	ec06                	sd	ra,24(sp)
 7b6:	e822                	sd	s0,16(sp)
 7b8:	1000                	addi	s0,sp,32
 7ba:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7be:	4605                	li	a2,1
 7c0:	fef40593          	addi	a1,s0,-17
 7c4:	f27ff0ef          	jal	6ea <write>
}
 7c8:	60e2                	ld	ra,24(sp)
 7ca:	6442                	ld	s0,16(sp)
 7cc:	6105                	addi	sp,sp,32
 7ce:	8082                	ret

00000000000007d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7d0:	7139                	addi	sp,sp,-64
 7d2:	fc06                	sd	ra,56(sp)
 7d4:	f822                	sd	s0,48(sp)
 7d6:	f426                	sd	s1,40(sp)
 7d8:	0080                	addi	s0,sp,64
 7da:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7dc:	c299                	beqz	a3,7e2 <printint+0x12>
 7de:	0805c963          	bltz	a1,870 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7e2:	2581                	sext.w	a1,a1
  neg = 0;
 7e4:	4881                	li	a7,0
 7e6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7ea:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7ec:	2601                	sext.w	a2,a2
 7ee:	00000517          	auipc	a0,0x0
 7f2:	60250513          	addi	a0,a0,1538 # df0 <digits>
 7f6:	883a                	mv	a6,a4
 7f8:	2705                	addiw	a4,a4,1
 7fa:	02c5f7bb          	remuw	a5,a1,a2
 7fe:	1782                	slli	a5,a5,0x20
 800:	9381                	srli	a5,a5,0x20
 802:	97aa                	add	a5,a5,a0
 804:	0007c783          	lbu	a5,0(a5)
 808:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 80c:	0005879b          	sext.w	a5,a1
 810:	02c5d5bb          	divuw	a1,a1,a2
 814:	0685                	addi	a3,a3,1
 816:	fec7f0e3          	bgeu	a5,a2,7f6 <printint+0x26>
  if(neg)
 81a:	00088c63          	beqz	a7,832 <printint+0x62>
    buf[i++] = '-';
 81e:	fd070793          	addi	a5,a4,-48
 822:	00878733          	add	a4,a5,s0
 826:	02d00793          	li	a5,45
 82a:	fef70823          	sb	a5,-16(a4)
 82e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 832:	02e05a63          	blez	a4,866 <printint+0x96>
 836:	f04a                	sd	s2,32(sp)
 838:	ec4e                	sd	s3,24(sp)
 83a:	fc040793          	addi	a5,s0,-64
 83e:	00e78933          	add	s2,a5,a4
 842:	fff78993          	addi	s3,a5,-1
 846:	99ba                	add	s3,s3,a4
 848:	377d                	addiw	a4,a4,-1
 84a:	1702                	slli	a4,a4,0x20
 84c:	9301                	srli	a4,a4,0x20
 84e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 852:	fff94583          	lbu	a1,-1(s2)
 856:	8526                	mv	a0,s1
 858:	f5bff0ef          	jal	7b2 <putc>
  while(--i >= 0)
 85c:	197d                	addi	s2,s2,-1
 85e:	ff391ae3          	bne	s2,s3,852 <printint+0x82>
 862:	7902                	ld	s2,32(sp)
 864:	69e2                	ld	s3,24(sp)
}
 866:	70e2                	ld	ra,56(sp)
 868:	7442                	ld	s0,48(sp)
 86a:	74a2                	ld	s1,40(sp)
 86c:	6121                	addi	sp,sp,64
 86e:	8082                	ret
    x = -xx;
 870:	40b005bb          	negw	a1,a1
    neg = 1;
 874:	4885                	li	a7,1
    x = -xx;
 876:	bf85                	j	7e6 <printint+0x16>

0000000000000878 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 878:	711d                	addi	sp,sp,-96
 87a:	ec86                	sd	ra,88(sp)
 87c:	e8a2                	sd	s0,80(sp)
 87e:	e0ca                	sd	s2,64(sp)
 880:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 882:	0005c903          	lbu	s2,0(a1)
 886:	26090863          	beqz	s2,af6 <vprintf+0x27e>
 88a:	e4a6                	sd	s1,72(sp)
 88c:	fc4e                	sd	s3,56(sp)
 88e:	f852                	sd	s4,48(sp)
 890:	f456                	sd	s5,40(sp)
 892:	f05a                	sd	s6,32(sp)
 894:	ec5e                	sd	s7,24(sp)
 896:	e862                	sd	s8,16(sp)
 898:	e466                	sd	s9,8(sp)
 89a:	8b2a                	mv	s6,a0
 89c:	8a2e                	mv	s4,a1
 89e:	8bb2                	mv	s7,a2
  state = 0;
 8a0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 8a2:	4481                	li	s1,0
 8a4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 8a6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 8aa:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 8ae:	06c00c93          	li	s9,108
 8b2:	a005                	j	8d2 <vprintf+0x5a>
        putc(fd, c0);
 8b4:	85ca                	mv	a1,s2
 8b6:	855a                	mv	a0,s6
 8b8:	efbff0ef          	jal	7b2 <putc>
 8bc:	a019                	j	8c2 <vprintf+0x4a>
    } else if(state == '%'){
 8be:	03598263          	beq	s3,s5,8e2 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 8c2:	2485                	addiw	s1,s1,1
 8c4:	8726                	mv	a4,s1
 8c6:	009a07b3          	add	a5,s4,s1
 8ca:	0007c903          	lbu	s2,0(a5)
 8ce:	20090c63          	beqz	s2,ae6 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 8d2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8d6:	fe0994e3          	bnez	s3,8be <vprintf+0x46>
      if(c0 == '%'){
 8da:	fd579de3          	bne	a5,s5,8b4 <vprintf+0x3c>
        state = '%';
 8de:	89be                	mv	s3,a5
 8e0:	b7cd                	j	8c2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 8e2:	00ea06b3          	add	a3,s4,a4
 8e6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 8ea:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 8ec:	c681                	beqz	a3,8f4 <vprintf+0x7c>
 8ee:	9752                	add	a4,a4,s4
 8f0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 8f4:	03878f63          	beq	a5,s8,932 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 8f8:	05978963          	beq	a5,s9,94a <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 8fc:	07500713          	li	a4,117
 900:	0ee78363          	beq	a5,a4,9e6 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 904:	07800713          	li	a4,120
 908:	12e78563          	beq	a5,a4,a32 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 90c:	07000713          	li	a4,112
 910:	14e78a63          	beq	a5,a4,a64 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 914:	07300713          	li	a4,115
 918:	18e78a63          	beq	a5,a4,aac <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 91c:	02500713          	li	a4,37
 920:	04e79563          	bne	a5,a4,96a <vprintf+0xf2>
        putc(fd, '%');
 924:	02500593          	li	a1,37
 928:	855a                	mv	a0,s6
 92a:	e89ff0ef          	jal	7b2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 92e:	4981                	li	s3,0
 930:	bf49                	j	8c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 932:	008b8913          	addi	s2,s7,8
 936:	4685                	li	a3,1
 938:	4629                	li	a2,10
 93a:	000ba583          	lw	a1,0(s7)
 93e:	855a                	mv	a0,s6
 940:	e91ff0ef          	jal	7d0 <printint>
 944:	8bca                	mv	s7,s2
      state = 0;
 946:	4981                	li	s3,0
 948:	bfad                	j	8c2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 94a:	06400793          	li	a5,100
 94e:	02f68963          	beq	a3,a5,980 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 952:	06c00793          	li	a5,108
 956:	04f68263          	beq	a3,a5,99a <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 95a:	07500793          	li	a5,117
 95e:	0af68063          	beq	a3,a5,9fe <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 962:	07800793          	li	a5,120
 966:	0ef68263          	beq	a3,a5,a4a <vprintf+0x1d2>
        putc(fd, '%');
 96a:	02500593          	li	a1,37
 96e:	855a                	mv	a0,s6
 970:	e43ff0ef          	jal	7b2 <putc>
        putc(fd, c0);
 974:	85ca                	mv	a1,s2
 976:	855a                	mv	a0,s6
 978:	e3bff0ef          	jal	7b2 <putc>
      state = 0;
 97c:	4981                	li	s3,0
 97e:	b791                	j	8c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 980:	008b8913          	addi	s2,s7,8
 984:	4685                	li	a3,1
 986:	4629                	li	a2,10
 988:	000ba583          	lw	a1,0(s7)
 98c:	855a                	mv	a0,s6
 98e:	e43ff0ef          	jal	7d0 <printint>
        i += 1;
 992:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 994:	8bca                	mv	s7,s2
      state = 0;
 996:	4981                	li	s3,0
        i += 1;
 998:	b72d                	j	8c2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 99a:	06400793          	li	a5,100
 99e:	02f60763          	beq	a2,a5,9cc <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 9a2:	07500793          	li	a5,117
 9a6:	06f60963          	beq	a2,a5,a18 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 9aa:	07800793          	li	a5,120
 9ae:	faf61ee3          	bne	a2,a5,96a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9b2:	008b8913          	addi	s2,s7,8
 9b6:	4681                	li	a3,0
 9b8:	4641                	li	a2,16
 9ba:	000ba583          	lw	a1,0(s7)
 9be:	855a                	mv	a0,s6
 9c0:	e11ff0ef          	jal	7d0 <printint>
        i += 2;
 9c4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 9c6:	8bca                	mv	s7,s2
      state = 0;
 9c8:	4981                	li	s3,0
        i += 2;
 9ca:	bde5                	j	8c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9cc:	008b8913          	addi	s2,s7,8
 9d0:	4685                	li	a3,1
 9d2:	4629                	li	a2,10
 9d4:	000ba583          	lw	a1,0(s7)
 9d8:	855a                	mv	a0,s6
 9da:	df7ff0ef          	jal	7d0 <printint>
        i += 2;
 9de:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 9e0:	8bca                	mv	s7,s2
      state = 0;
 9e2:	4981                	li	s3,0
        i += 2;
 9e4:	bdf9                	j	8c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 9e6:	008b8913          	addi	s2,s7,8
 9ea:	4681                	li	a3,0
 9ec:	4629                	li	a2,10
 9ee:	000ba583          	lw	a1,0(s7)
 9f2:	855a                	mv	a0,s6
 9f4:	dddff0ef          	jal	7d0 <printint>
 9f8:	8bca                	mv	s7,s2
      state = 0;
 9fa:	4981                	li	s3,0
 9fc:	b5d9                	j	8c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9fe:	008b8913          	addi	s2,s7,8
 a02:	4681                	li	a3,0
 a04:	4629                	li	a2,10
 a06:	000ba583          	lw	a1,0(s7)
 a0a:	855a                	mv	a0,s6
 a0c:	dc5ff0ef          	jal	7d0 <printint>
        i += 1;
 a10:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a12:	8bca                	mv	s7,s2
      state = 0;
 a14:	4981                	li	s3,0
        i += 1;
 a16:	b575                	j	8c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a18:	008b8913          	addi	s2,s7,8
 a1c:	4681                	li	a3,0
 a1e:	4629                	li	a2,10
 a20:	000ba583          	lw	a1,0(s7)
 a24:	855a                	mv	a0,s6
 a26:	dabff0ef          	jal	7d0 <printint>
        i += 2;
 a2a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a2c:	8bca                	mv	s7,s2
      state = 0;
 a2e:	4981                	li	s3,0
        i += 2;
 a30:	bd49                	j	8c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 a32:	008b8913          	addi	s2,s7,8
 a36:	4681                	li	a3,0
 a38:	4641                	li	a2,16
 a3a:	000ba583          	lw	a1,0(s7)
 a3e:	855a                	mv	a0,s6
 a40:	d91ff0ef          	jal	7d0 <printint>
 a44:	8bca                	mv	s7,s2
      state = 0;
 a46:	4981                	li	s3,0
 a48:	bdad                	j	8c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a4a:	008b8913          	addi	s2,s7,8
 a4e:	4681                	li	a3,0
 a50:	4641                	li	a2,16
 a52:	000ba583          	lw	a1,0(s7)
 a56:	855a                	mv	a0,s6
 a58:	d79ff0ef          	jal	7d0 <printint>
        i += 1;
 a5c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a5e:	8bca                	mv	s7,s2
      state = 0;
 a60:	4981                	li	s3,0
        i += 1;
 a62:	b585                	j	8c2 <vprintf+0x4a>
 a64:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 a66:	008b8d13          	addi	s10,s7,8
 a6a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a6e:	03000593          	li	a1,48
 a72:	855a                	mv	a0,s6
 a74:	d3fff0ef          	jal	7b2 <putc>
  putc(fd, 'x');
 a78:	07800593          	li	a1,120
 a7c:	855a                	mv	a0,s6
 a7e:	d35ff0ef          	jal	7b2 <putc>
 a82:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a84:	00000b97          	auipc	s7,0x0
 a88:	36cb8b93          	addi	s7,s7,876 # df0 <digits>
 a8c:	03c9d793          	srli	a5,s3,0x3c
 a90:	97de                	add	a5,a5,s7
 a92:	0007c583          	lbu	a1,0(a5)
 a96:	855a                	mv	a0,s6
 a98:	d1bff0ef          	jal	7b2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a9c:	0992                	slli	s3,s3,0x4
 a9e:	397d                	addiw	s2,s2,-1
 aa0:	fe0916e3          	bnez	s2,a8c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 aa4:	8bea                	mv	s7,s10
      state = 0;
 aa6:	4981                	li	s3,0
 aa8:	6d02                	ld	s10,0(sp)
 aaa:	bd21                	j	8c2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 aac:	008b8993          	addi	s3,s7,8
 ab0:	000bb903          	ld	s2,0(s7)
 ab4:	00090f63          	beqz	s2,ad2 <vprintf+0x25a>
        for(; *s; s++)
 ab8:	00094583          	lbu	a1,0(s2)
 abc:	c195                	beqz	a1,ae0 <vprintf+0x268>
          putc(fd, *s);
 abe:	855a                	mv	a0,s6
 ac0:	cf3ff0ef          	jal	7b2 <putc>
        for(; *s; s++)
 ac4:	0905                	addi	s2,s2,1
 ac6:	00094583          	lbu	a1,0(s2)
 aca:	f9f5                	bnez	a1,abe <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 acc:	8bce                	mv	s7,s3
      state = 0;
 ace:	4981                	li	s3,0
 ad0:	bbcd                	j	8c2 <vprintf+0x4a>
          s = "(null)";
 ad2:	00000917          	auipc	s2,0x0
 ad6:	31690913          	addi	s2,s2,790 # de8 <malloc+0x20a>
        for(; *s; s++)
 ada:	02800593          	li	a1,40
 ade:	b7c5                	j	abe <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 ae0:	8bce                	mv	s7,s3
      state = 0;
 ae2:	4981                	li	s3,0
 ae4:	bbf9                	j	8c2 <vprintf+0x4a>
 ae6:	64a6                	ld	s1,72(sp)
 ae8:	79e2                	ld	s3,56(sp)
 aea:	7a42                	ld	s4,48(sp)
 aec:	7aa2                	ld	s5,40(sp)
 aee:	7b02                	ld	s6,32(sp)
 af0:	6be2                	ld	s7,24(sp)
 af2:	6c42                	ld	s8,16(sp)
 af4:	6ca2                	ld	s9,8(sp)
    }
  }
}
 af6:	60e6                	ld	ra,88(sp)
 af8:	6446                	ld	s0,80(sp)
 afa:	6906                	ld	s2,64(sp)
 afc:	6125                	addi	sp,sp,96
 afe:	8082                	ret

0000000000000b00 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b00:	715d                	addi	sp,sp,-80
 b02:	ec06                	sd	ra,24(sp)
 b04:	e822                	sd	s0,16(sp)
 b06:	1000                	addi	s0,sp,32
 b08:	e010                	sd	a2,0(s0)
 b0a:	e414                	sd	a3,8(s0)
 b0c:	e818                	sd	a4,16(s0)
 b0e:	ec1c                	sd	a5,24(s0)
 b10:	03043023          	sd	a6,32(s0)
 b14:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b18:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b1c:	8622                	mv	a2,s0
 b1e:	d5bff0ef          	jal	878 <vprintf>
}
 b22:	60e2                	ld	ra,24(sp)
 b24:	6442                	ld	s0,16(sp)
 b26:	6161                	addi	sp,sp,80
 b28:	8082                	ret

0000000000000b2a <printf>:

void
printf(const char *fmt, ...)
{
 b2a:	711d                	addi	sp,sp,-96
 b2c:	ec06                	sd	ra,24(sp)
 b2e:	e822                	sd	s0,16(sp)
 b30:	1000                	addi	s0,sp,32
 b32:	e40c                	sd	a1,8(s0)
 b34:	e810                	sd	a2,16(s0)
 b36:	ec14                	sd	a3,24(s0)
 b38:	f018                	sd	a4,32(s0)
 b3a:	f41c                	sd	a5,40(s0)
 b3c:	03043823          	sd	a6,48(s0)
 b40:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b44:	00840613          	addi	a2,s0,8
 b48:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b4c:	85aa                	mv	a1,a0
 b4e:	4505                	li	a0,1
 b50:	d29ff0ef          	jal	878 <vprintf>
}
 b54:	60e2                	ld	ra,24(sp)
 b56:	6442                	ld	s0,16(sp)
 b58:	6125                	addi	sp,sp,96
 b5a:	8082                	ret

0000000000000b5c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b5c:	1141                	addi	sp,sp,-16
 b5e:	e422                	sd	s0,8(sp)
 b60:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b62:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b66:	00001797          	auipc	a5,0x1
 b6a:	4d27b783          	ld	a5,1234(a5) # 2038 <freep>
 b6e:	a02d                	j	b98 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b70:	4618                	lw	a4,8(a2)
 b72:	9f2d                	addw	a4,a4,a1
 b74:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b78:	6398                	ld	a4,0(a5)
 b7a:	6310                	ld	a2,0(a4)
 b7c:	a83d                	j	bba <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b7e:	ff852703          	lw	a4,-8(a0)
 b82:	9f31                	addw	a4,a4,a2
 b84:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b86:	ff053683          	ld	a3,-16(a0)
 b8a:	a091                	j	bce <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b8c:	6398                	ld	a4,0(a5)
 b8e:	00e7e463          	bltu	a5,a4,b96 <free+0x3a>
 b92:	00e6ea63          	bltu	a3,a4,ba6 <free+0x4a>
{
 b96:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b98:	fed7fae3          	bgeu	a5,a3,b8c <free+0x30>
 b9c:	6398                	ld	a4,0(a5)
 b9e:	00e6e463          	bltu	a3,a4,ba6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ba2:	fee7eae3          	bltu	a5,a4,b96 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 ba6:	ff852583          	lw	a1,-8(a0)
 baa:	6390                	ld	a2,0(a5)
 bac:	02059813          	slli	a6,a1,0x20
 bb0:	01c85713          	srli	a4,a6,0x1c
 bb4:	9736                	add	a4,a4,a3
 bb6:	fae60de3          	beq	a2,a4,b70 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 bba:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 bbe:	4790                	lw	a2,8(a5)
 bc0:	02061593          	slli	a1,a2,0x20
 bc4:	01c5d713          	srli	a4,a1,0x1c
 bc8:	973e                	add	a4,a4,a5
 bca:	fae68ae3          	beq	a3,a4,b7e <free+0x22>
    p->s.ptr = bp->s.ptr;
 bce:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 bd0:	00001717          	auipc	a4,0x1
 bd4:	46f73423          	sd	a5,1128(a4) # 2038 <freep>
}
 bd8:	6422                	ld	s0,8(sp)
 bda:	0141                	addi	sp,sp,16
 bdc:	8082                	ret

0000000000000bde <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 bde:	7139                	addi	sp,sp,-64
 be0:	fc06                	sd	ra,56(sp)
 be2:	f822                	sd	s0,48(sp)
 be4:	f426                	sd	s1,40(sp)
 be6:	ec4e                	sd	s3,24(sp)
 be8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bea:	02051493          	slli	s1,a0,0x20
 bee:	9081                	srli	s1,s1,0x20
 bf0:	04bd                	addi	s1,s1,15
 bf2:	8091                	srli	s1,s1,0x4
 bf4:	0014899b          	addiw	s3,s1,1
 bf8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 bfa:	00001517          	auipc	a0,0x1
 bfe:	43e53503          	ld	a0,1086(a0) # 2038 <freep>
 c02:	c915                	beqz	a0,c36 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c04:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c06:	4798                	lw	a4,8(a5)
 c08:	08977a63          	bgeu	a4,s1,c9c <malloc+0xbe>
 c0c:	f04a                	sd	s2,32(sp)
 c0e:	e852                	sd	s4,16(sp)
 c10:	e456                	sd	s5,8(sp)
 c12:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 c14:	8a4e                	mv	s4,s3
 c16:	0009871b          	sext.w	a4,s3
 c1a:	6685                	lui	a3,0x1
 c1c:	00d77363          	bgeu	a4,a3,c22 <malloc+0x44>
 c20:	6a05                	lui	s4,0x1
 c22:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c26:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c2a:	00001917          	auipc	s2,0x1
 c2e:	40e90913          	addi	s2,s2,1038 # 2038 <freep>
  if(p == (char*)-1)
 c32:	5afd                	li	s5,-1
 c34:	a081                	j	c74 <malloc+0x96>
 c36:	f04a                	sd	s2,32(sp)
 c38:	e852                	sd	s4,16(sp)
 c3a:	e456                	sd	s5,8(sp)
 c3c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 c3e:	00001797          	auipc	a5,0x1
 c42:	60278793          	addi	a5,a5,1538 # 2240 <base>
 c46:	00001717          	auipc	a4,0x1
 c4a:	3ef73923          	sd	a5,1010(a4) # 2038 <freep>
 c4e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c50:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c54:	b7c1                	j	c14 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 c56:	6398                	ld	a4,0(a5)
 c58:	e118                	sd	a4,0(a0)
 c5a:	a8a9                	j	cb4 <malloc+0xd6>
  hp->s.size = nu;
 c5c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c60:	0541                	addi	a0,a0,16
 c62:	efbff0ef          	jal	b5c <free>
  return freep;
 c66:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c6a:	c12d                	beqz	a0,ccc <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c6c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c6e:	4798                	lw	a4,8(a5)
 c70:	02977263          	bgeu	a4,s1,c94 <malloc+0xb6>
    if(p == freep)
 c74:	00093703          	ld	a4,0(s2)
 c78:	853e                	mv	a0,a5
 c7a:	fef719e3          	bne	a4,a5,c6c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 c7e:	8552                	mv	a0,s4
 c80:	ad3ff0ef          	jal	752 <sbrk>
  if(p == (char*)-1)
 c84:	fd551ce3          	bne	a0,s5,c5c <malloc+0x7e>
        return 0;
 c88:	4501                	li	a0,0
 c8a:	7902                	ld	s2,32(sp)
 c8c:	6a42                	ld	s4,16(sp)
 c8e:	6aa2                	ld	s5,8(sp)
 c90:	6b02                	ld	s6,0(sp)
 c92:	a03d                	j	cc0 <malloc+0xe2>
 c94:	7902                	ld	s2,32(sp)
 c96:	6a42                	ld	s4,16(sp)
 c98:	6aa2                	ld	s5,8(sp)
 c9a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 c9c:	fae48de3          	beq	s1,a4,c56 <malloc+0x78>
        p->s.size -= nunits;
 ca0:	4137073b          	subw	a4,a4,s3
 ca4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ca6:	02071693          	slli	a3,a4,0x20
 caa:	01c6d713          	srli	a4,a3,0x1c
 cae:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 cb0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 cb4:	00001717          	auipc	a4,0x1
 cb8:	38a73223          	sd	a0,900(a4) # 2038 <freep>
      return (void*)(p + 1);
 cbc:	01078513          	addi	a0,a5,16
  }
}
 cc0:	70e2                	ld	ra,56(sp)
 cc2:	7442                	ld	s0,48(sp)
 cc4:	74a2                	ld	s1,40(sp)
 cc6:	69e2                	ld	s3,24(sp)
 cc8:	6121                	addi	sp,sp,64
 cca:	8082                	ret
 ccc:	7902                	ld	s2,32(sp)
 cce:	6a42                	ld	s4,16(sp)
 cd0:	6aa2                	ld	s5,8(sp)
 cd2:	6b02                	ld	s6,0(sp)
 cd4:	b7f5                	j	cc0 <malloc+0xe2>
