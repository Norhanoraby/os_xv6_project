
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
  3e:	c96c0c13          	addi	s8,s8,-874 # cd0 <malloc+0x10a>
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
 126:	b9e78793          	addi	a5,a5,-1122 # cc0 <malloc+0xfa>
 12a:	f6f43c23          	sd	a5,-136(s0)
  
  if(show_all){
 12e:	00002797          	auipc	a5,0x2
 132:	ed27a783          	lw	a5,-302(a5) # 2000 <show_all>
 136:	cfa5                	beqz	a5,1ae <wc+0x1ae>
    printf("File: %s\n", display_name);
 138:	f7843583          	ld	a1,-136(s0)
 13c:	00001517          	auipc	a0,0x1
 140:	bac50513          	addi	a0,a0,-1108 # ce8 <malloc+0x122>
 144:	1cf000ef          	jal	b12 <printf>
    printf("  Lines: %d\n", l);
 148:	85ea                	mv	a1,s10
 14a:	00001517          	auipc	a0,0x1
 14e:	bae50513          	addi	a0,a0,-1106 # cf8 <malloc+0x132>
 152:	1c1000ef          	jal	b12 <printf>
    printf("  Words: %d\n", w);
 156:	85ee                	mv	a1,s11
 158:	00001517          	auipc	a0,0x1
 15c:	bb050513          	addi	a0,a0,-1104 # d08 <malloc+0x142>
 160:	1b3000ef          	jal	b12 <printf>
    printf("  Characters: %d\n", c);
 164:	85d6                	mv	a1,s5
 166:	00001517          	auipc	a0,0x1
 16a:	bb250513          	addi	a0,a0,-1102 # d18 <malloc+0x152>
 16e:	1a5000ef          	jal	b12 <printf>
    printf("\n");
 172:	00001517          	auipc	a0,0x1
 176:	c1e50513          	addi	a0,a0,-994 # d90 <malloc+0x1ca>
 17a:	199000ef          	jal	b12 <printf>
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
 1a0:	b3c50513          	addi	a0,a0,-1220 # cd8 <malloc+0x112>
 1a4:	16f000ef          	jal	b12 <printf>
    exit(1);
 1a8:	4505                	li	a0,1
 1aa:	520000ef          	jal	6ca <exit>
    printf("File: %s\n", display_name);
 1ae:	f7843583          	ld	a1,-136(s0)
 1b2:	00001517          	auipc	a0,0x1
 1b6:	b3650513          	addi	a0,a0,-1226 # ce8 <malloc+0x122>
 1ba:	159000ef          	jal	b12 <printf>
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
 1ea:	baa50513          	addi	a0,a0,-1110 # d90 <malloc+0x1ca>
 1ee:	125000ef          	jal	b12 <printf>
}
 1f2:	b771                	j	17e <wc+0x17e>
      printf("  Lines: %d\n", l);
 1f4:	85ea                	mv	a1,s10
 1f6:	00001517          	auipc	a0,0x1
 1fa:	b0250513          	addi	a0,a0,-1278 # cf8 <malloc+0x132>
 1fe:	115000ef          	jal	b12 <printf>
 202:	b7d9                	j	1c8 <wc+0x1c8>
      printf("  Words: %d\n", w);
 204:	85ee                	mv	a1,s11
 206:	00001517          	auipc	a0,0x1
 20a:	b0250513          	addi	a0,a0,-1278 # d08 <malloc+0x142>
 20e:	105000ef          	jal	b12 <printf>
 212:	b7c1                	j	1d2 <wc+0x1d2>
      printf("  Characters: %d\n", c);
 214:	85d6                	mv	a1,s5
 216:	00001517          	auipc	a0,0x1
 21a:	b0250513          	addi	a0,a0,-1278 # d18 <malloc+0x152>
 21e:	0f5000ef          	jal	b12 <printf>
 222:	bf6d                	j	1dc <wc+0x1dc>
      printf("  Longest line: %d\n", longest_line);
 224:	85de                	mv	a1,s7
 226:	00001517          	auipc	a0,0x1
 22a:	b0a50513          	addi	a0,a0,-1270 # d30 <malloc+0x16a>
 22e:	0e5000ef          	jal	b12 <printf>
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
 2c6:	a8650513          	addi	a0,a0,-1402 # d48 <malloc+0x182>
 2ca:	049000ef          	jal	b12 <printf>
        printf("Usage: wc [-l] [-w] [-c] [-L] [file ...]\n");
 2ce:	00001517          	auipc	a0,0x1
 2d2:	a9a50513          	addi	a0,a0,-1382 # d68 <malloc+0x1a2>
 2d6:	03d000ef          	jal	b12 <printf>
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
 358:	97458593          	addi	a1,a1,-1676 # cc8 <malloc+0x102>
 35c:	4501                	li	a0,0
 35e:	ca3ff0ef          	jal	0 <wc>
    exit(0);
 362:	4501                	li	a0,0
 364:	366000ef          	jal	6ca <exit>
      printf("wc: cannot open %s\n", argv[i]);
 368:	00093583          	ld	a1,0(s2)
 36c:	00001517          	auipc	a0,0x1
 370:	a2c50513          	addi	a0,a0,-1492 # d98 <malloc+0x1d2>
 374:	79e000ef          	jal	b12 <printf>
      exit(1);
 378:	4505                	li	a0,1
 37a:	350000ef          	jal	6ca <exit>
    printf("===== TOTAL =====\n");
 37e:	00001517          	auipc	a0,0x1
 382:	a3250513          	addi	a0,a0,-1486 # db0 <malloc+0x1ea>
 386:	78c000ef          	jal	b12 <printf>
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
 3c0:	9d450513          	addi	a0,a0,-1580 # d90 <malloc+0x1ca>
 3c4:	74e000ef          	jal	b12 <printf>
 3c8:	b751                	j	34c <main+0x118>
      printf("  Lines: %d\n", total_l);
 3ca:	00002597          	auipc	a1,0x2
 3ce:	c565a583          	lw	a1,-938(a1) # 2020 <total_l>
 3d2:	00001517          	auipc	a0,0x1
 3d6:	92650513          	addi	a0,a0,-1754 # cf8 <malloc+0x132>
 3da:	738000ef          	jal	b12 <printf>
      printf("  Words: %d\n", total_w);
 3de:	00002597          	auipc	a1,0x2
 3e2:	c3e5a583          	lw	a1,-962(a1) # 201c <total_w>
 3e6:	00001517          	auipc	a0,0x1
 3ea:	92250513          	addi	a0,a0,-1758 # d08 <malloc+0x142>
 3ee:	724000ef          	jal	b12 <printf>
      printf("  Characters: %d\n", total_c);
 3f2:	00002597          	auipc	a1,0x2
 3f6:	c265a583          	lw	a1,-986(a1) # 2018 <total_c>
 3fa:	00001517          	auipc	a0,0x1
 3fe:	91e50513          	addi	a0,a0,-1762 # d18 <malloc+0x152>
 402:	710000ef          	jal	b12 <printf>
 406:	bf5d                	j	3bc <main+0x188>
        printf("  Lines: %d\n", total_l);
 408:	00002597          	auipc	a1,0x2
 40c:	c185a583          	lw	a1,-1000(a1) # 2020 <total_l>
 410:	00001517          	auipc	a0,0x1
 414:	8e850513          	addi	a0,a0,-1816 # cf8 <malloc+0x132>
 418:	6fa000ef          	jal	b12 <printf>
 41c:	b749                	j	39e <main+0x16a>
        printf("  Words: %d\n", total_w);
 41e:	00002597          	auipc	a1,0x2
 422:	bfe5a583          	lw	a1,-1026(a1) # 201c <total_w>
 426:	00001517          	auipc	a0,0x1
 42a:	8e250513          	addi	a0,a0,-1822 # d08 <malloc+0x142>
 42e:	6e4000ef          	jal	b12 <printf>
 432:	bf9d                	j	3a8 <main+0x174>
        printf("  Characters: %d\n", total_c);
 434:	00002597          	auipc	a1,0x2
 438:	be45a583          	lw	a1,-1052(a1) # 2018 <total_c>
 43c:	00001517          	auipc	a0,0x1
 440:	8dc50513          	addi	a0,a0,-1828 # d18 <malloc+0x152>
 444:	6ce000ef          	jal	b12 <printf>
 448:	b7ad                	j	3b2 <main+0x17e>
        printf("  Longest line: %d\n", total_L);
 44a:	00002597          	auipc	a1,0x2
 44e:	bca5a583          	lw	a1,-1078(a1) # 2014 <total_L>
 452:	00001517          	auipc	a0,0x1
 456:	8de50513          	addi	a0,a0,-1826 # d30 <malloc+0x16a>
 45a:	6b8000ef          	jal	b12 <printf>
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

000000000000078a <rand>:
.global rand
rand:
 li a7, SYS_rand
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

000000000000079a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 79a:	1101                	addi	sp,sp,-32
 79c:	ec06                	sd	ra,24(sp)
 79e:	e822                	sd	s0,16(sp)
 7a0:	1000                	addi	s0,sp,32
 7a2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7a6:	4605                	li	a2,1
 7a8:	fef40593          	addi	a1,s0,-17
 7ac:	f3fff0ef          	jal	6ea <write>
}
 7b0:	60e2                	ld	ra,24(sp)
 7b2:	6442                	ld	s0,16(sp)
 7b4:	6105                	addi	sp,sp,32
 7b6:	8082                	ret

00000000000007b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7b8:	7139                	addi	sp,sp,-64
 7ba:	fc06                	sd	ra,56(sp)
 7bc:	f822                	sd	s0,48(sp)
 7be:	f426                	sd	s1,40(sp)
 7c0:	0080                	addi	s0,sp,64
 7c2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7c4:	c299                	beqz	a3,7ca <printint+0x12>
 7c6:	0805c963          	bltz	a1,858 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7ca:	2581                	sext.w	a1,a1
  neg = 0;
 7cc:	4881                	li	a7,0
 7ce:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7d2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7d4:	2601                	sext.w	a2,a2
 7d6:	00000517          	auipc	a0,0x0
 7da:	5fa50513          	addi	a0,a0,1530 # dd0 <digits>
 7de:	883a                	mv	a6,a4
 7e0:	2705                	addiw	a4,a4,1
 7e2:	02c5f7bb          	remuw	a5,a1,a2
 7e6:	1782                	slli	a5,a5,0x20
 7e8:	9381                	srli	a5,a5,0x20
 7ea:	97aa                	add	a5,a5,a0
 7ec:	0007c783          	lbu	a5,0(a5)
 7f0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7f4:	0005879b          	sext.w	a5,a1
 7f8:	02c5d5bb          	divuw	a1,a1,a2
 7fc:	0685                	addi	a3,a3,1
 7fe:	fec7f0e3          	bgeu	a5,a2,7de <printint+0x26>
  if(neg)
 802:	00088c63          	beqz	a7,81a <printint+0x62>
    buf[i++] = '-';
 806:	fd070793          	addi	a5,a4,-48
 80a:	00878733          	add	a4,a5,s0
 80e:	02d00793          	li	a5,45
 812:	fef70823          	sb	a5,-16(a4)
 816:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 81a:	02e05a63          	blez	a4,84e <printint+0x96>
 81e:	f04a                	sd	s2,32(sp)
 820:	ec4e                	sd	s3,24(sp)
 822:	fc040793          	addi	a5,s0,-64
 826:	00e78933          	add	s2,a5,a4
 82a:	fff78993          	addi	s3,a5,-1
 82e:	99ba                	add	s3,s3,a4
 830:	377d                	addiw	a4,a4,-1
 832:	1702                	slli	a4,a4,0x20
 834:	9301                	srli	a4,a4,0x20
 836:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 83a:	fff94583          	lbu	a1,-1(s2)
 83e:	8526                	mv	a0,s1
 840:	f5bff0ef          	jal	79a <putc>
  while(--i >= 0)
 844:	197d                	addi	s2,s2,-1
 846:	ff391ae3          	bne	s2,s3,83a <printint+0x82>
 84a:	7902                	ld	s2,32(sp)
 84c:	69e2                	ld	s3,24(sp)
}
 84e:	70e2                	ld	ra,56(sp)
 850:	7442                	ld	s0,48(sp)
 852:	74a2                	ld	s1,40(sp)
 854:	6121                	addi	sp,sp,64
 856:	8082                	ret
    x = -xx;
 858:	40b005bb          	negw	a1,a1
    neg = 1;
 85c:	4885                	li	a7,1
    x = -xx;
 85e:	bf85                	j	7ce <printint+0x16>

0000000000000860 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 860:	711d                	addi	sp,sp,-96
 862:	ec86                	sd	ra,88(sp)
 864:	e8a2                	sd	s0,80(sp)
 866:	e0ca                	sd	s2,64(sp)
 868:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 86a:	0005c903          	lbu	s2,0(a1)
 86e:	26090863          	beqz	s2,ade <vprintf+0x27e>
 872:	e4a6                	sd	s1,72(sp)
 874:	fc4e                	sd	s3,56(sp)
 876:	f852                	sd	s4,48(sp)
 878:	f456                	sd	s5,40(sp)
 87a:	f05a                	sd	s6,32(sp)
 87c:	ec5e                	sd	s7,24(sp)
 87e:	e862                	sd	s8,16(sp)
 880:	e466                	sd	s9,8(sp)
 882:	8b2a                	mv	s6,a0
 884:	8a2e                	mv	s4,a1
 886:	8bb2                	mv	s7,a2
  state = 0;
 888:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 88a:	4481                	li	s1,0
 88c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 88e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 892:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 896:	06c00c93          	li	s9,108
 89a:	a005                	j	8ba <vprintf+0x5a>
        putc(fd, c0);
 89c:	85ca                	mv	a1,s2
 89e:	855a                	mv	a0,s6
 8a0:	efbff0ef          	jal	79a <putc>
 8a4:	a019                	j	8aa <vprintf+0x4a>
    } else if(state == '%'){
 8a6:	03598263          	beq	s3,s5,8ca <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 8aa:	2485                	addiw	s1,s1,1
 8ac:	8726                	mv	a4,s1
 8ae:	009a07b3          	add	a5,s4,s1
 8b2:	0007c903          	lbu	s2,0(a5)
 8b6:	20090c63          	beqz	s2,ace <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 8ba:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8be:	fe0994e3          	bnez	s3,8a6 <vprintf+0x46>
      if(c0 == '%'){
 8c2:	fd579de3          	bne	a5,s5,89c <vprintf+0x3c>
        state = '%';
 8c6:	89be                	mv	s3,a5
 8c8:	b7cd                	j	8aa <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 8ca:	00ea06b3          	add	a3,s4,a4
 8ce:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 8d2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 8d4:	c681                	beqz	a3,8dc <vprintf+0x7c>
 8d6:	9752                	add	a4,a4,s4
 8d8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 8dc:	03878f63          	beq	a5,s8,91a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 8e0:	05978963          	beq	a5,s9,932 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 8e4:	07500713          	li	a4,117
 8e8:	0ee78363          	beq	a5,a4,9ce <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 8ec:	07800713          	li	a4,120
 8f0:	12e78563          	beq	a5,a4,a1a <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 8f4:	07000713          	li	a4,112
 8f8:	14e78a63          	beq	a5,a4,a4c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 8fc:	07300713          	li	a4,115
 900:	18e78a63          	beq	a5,a4,a94 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 904:	02500713          	li	a4,37
 908:	04e79563          	bne	a5,a4,952 <vprintf+0xf2>
        putc(fd, '%');
 90c:	02500593          	li	a1,37
 910:	855a                	mv	a0,s6
 912:	e89ff0ef          	jal	79a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 916:	4981                	li	s3,0
 918:	bf49                	j	8aa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 91a:	008b8913          	addi	s2,s7,8
 91e:	4685                	li	a3,1
 920:	4629                	li	a2,10
 922:	000ba583          	lw	a1,0(s7)
 926:	855a                	mv	a0,s6
 928:	e91ff0ef          	jal	7b8 <printint>
 92c:	8bca                	mv	s7,s2
      state = 0;
 92e:	4981                	li	s3,0
 930:	bfad                	j	8aa <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 932:	06400793          	li	a5,100
 936:	02f68963          	beq	a3,a5,968 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 93a:	06c00793          	li	a5,108
 93e:	04f68263          	beq	a3,a5,982 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 942:	07500793          	li	a5,117
 946:	0af68063          	beq	a3,a5,9e6 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 94a:	07800793          	li	a5,120
 94e:	0ef68263          	beq	a3,a5,a32 <vprintf+0x1d2>
        putc(fd, '%');
 952:	02500593          	li	a1,37
 956:	855a                	mv	a0,s6
 958:	e43ff0ef          	jal	79a <putc>
        putc(fd, c0);
 95c:	85ca                	mv	a1,s2
 95e:	855a                	mv	a0,s6
 960:	e3bff0ef          	jal	79a <putc>
      state = 0;
 964:	4981                	li	s3,0
 966:	b791                	j	8aa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 968:	008b8913          	addi	s2,s7,8
 96c:	4685                	li	a3,1
 96e:	4629                	li	a2,10
 970:	000ba583          	lw	a1,0(s7)
 974:	855a                	mv	a0,s6
 976:	e43ff0ef          	jal	7b8 <printint>
        i += 1;
 97a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 97c:	8bca                	mv	s7,s2
      state = 0;
 97e:	4981                	li	s3,0
        i += 1;
 980:	b72d                	j	8aa <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 982:	06400793          	li	a5,100
 986:	02f60763          	beq	a2,a5,9b4 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 98a:	07500793          	li	a5,117
 98e:	06f60963          	beq	a2,a5,a00 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 992:	07800793          	li	a5,120
 996:	faf61ee3          	bne	a2,a5,952 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 99a:	008b8913          	addi	s2,s7,8
 99e:	4681                	li	a3,0
 9a0:	4641                	li	a2,16
 9a2:	000ba583          	lw	a1,0(s7)
 9a6:	855a                	mv	a0,s6
 9a8:	e11ff0ef          	jal	7b8 <printint>
        i += 2;
 9ac:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 9ae:	8bca                	mv	s7,s2
      state = 0;
 9b0:	4981                	li	s3,0
        i += 2;
 9b2:	bde5                	j	8aa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9b4:	008b8913          	addi	s2,s7,8
 9b8:	4685                	li	a3,1
 9ba:	4629                	li	a2,10
 9bc:	000ba583          	lw	a1,0(s7)
 9c0:	855a                	mv	a0,s6
 9c2:	df7ff0ef          	jal	7b8 <printint>
        i += 2;
 9c6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 9c8:	8bca                	mv	s7,s2
      state = 0;
 9ca:	4981                	li	s3,0
        i += 2;
 9cc:	bdf9                	j	8aa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 9ce:	008b8913          	addi	s2,s7,8
 9d2:	4681                	li	a3,0
 9d4:	4629                	li	a2,10
 9d6:	000ba583          	lw	a1,0(s7)
 9da:	855a                	mv	a0,s6
 9dc:	dddff0ef          	jal	7b8 <printint>
 9e0:	8bca                	mv	s7,s2
      state = 0;
 9e2:	4981                	li	s3,0
 9e4:	b5d9                	j	8aa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9e6:	008b8913          	addi	s2,s7,8
 9ea:	4681                	li	a3,0
 9ec:	4629                	li	a2,10
 9ee:	000ba583          	lw	a1,0(s7)
 9f2:	855a                	mv	a0,s6
 9f4:	dc5ff0ef          	jal	7b8 <printint>
        i += 1;
 9f8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 9fa:	8bca                	mv	s7,s2
      state = 0;
 9fc:	4981                	li	s3,0
        i += 1;
 9fe:	b575                	j	8aa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a00:	008b8913          	addi	s2,s7,8
 a04:	4681                	li	a3,0
 a06:	4629                	li	a2,10
 a08:	000ba583          	lw	a1,0(s7)
 a0c:	855a                	mv	a0,s6
 a0e:	dabff0ef          	jal	7b8 <printint>
        i += 2;
 a12:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a14:	8bca                	mv	s7,s2
      state = 0;
 a16:	4981                	li	s3,0
        i += 2;
 a18:	bd49                	j	8aa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 a1a:	008b8913          	addi	s2,s7,8
 a1e:	4681                	li	a3,0
 a20:	4641                	li	a2,16
 a22:	000ba583          	lw	a1,0(s7)
 a26:	855a                	mv	a0,s6
 a28:	d91ff0ef          	jal	7b8 <printint>
 a2c:	8bca                	mv	s7,s2
      state = 0;
 a2e:	4981                	li	s3,0
 a30:	bdad                	j	8aa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a32:	008b8913          	addi	s2,s7,8
 a36:	4681                	li	a3,0
 a38:	4641                	li	a2,16
 a3a:	000ba583          	lw	a1,0(s7)
 a3e:	855a                	mv	a0,s6
 a40:	d79ff0ef          	jal	7b8 <printint>
        i += 1;
 a44:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a46:	8bca                	mv	s7,s2
      state = 0;
 a48:	4981                	li	s3,0
        i += 1;
 a4a:	b585                	j	8aa <vprintf+0x4a>
 a4c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 a4e:	008b8d13          	addi	s10,s7,8
 a52:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a56:	03000593          	li	a1,48
 a5a:	855a                	mv	a0,s6
 a5c:	d3fff0ef          	jal	79a <putc>
  putc(fd, 'x');
 a60:	07800593          	li	a1,120
 a64:	855a                	mv	a0,s6
 a66:	d35ff0ef          	jal	79a <putc>
 a6a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a6c:	00000b97          	auipc	s7,0x0
 a70:	364b8b93          	addi	s7,s7,868 # dd0 <digits>
 a74:	03c9d793          	srli	a5,s3,0x3c
 a78:	97de                	add	a5,a5,s7
 a7a:	0007c583          	lbu	a1,0(a5)
 a7e:	855a                	mv	a0,s6
 a80:	d1bff0ef          	jal	79a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a84:	0992                	slli	s3,s3,0x4
 a86:	397d                	addiw	s2,s2,-1
 a88:	fe0916e3          	bnez	s2,a74 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 a8c:	8bea                	mv	s7,s10
      state = 0;
 a8e:	4981                	li	s3,0
 a90:	6d02                	ld	s10,0(sp)
 a92:	bd21                	j	8aa <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 a94:	008b8993          	addi	s3,s7,8
 a98:	000bb903          	ld	s2,0(s7)
 a9c:	00090f63          	beqz	s2,aba <vprintf+0x25a>
        for(; *s; s++)
 aa0:	00094583          	lbu	a1,0(s2)
 aa4:	c195                	beqz	a1,ac8 <vprintf+0x268>
          putc(fd, *s);
 aa6:	855a                	mv	a0,s6
 aa8:	cf3ff0ef          	jal	79a <putc>
        for(; *s; s++)
 aac:	0905                	addi	s2,s2,1
 aae:	00094583          	lbu	a1,0(s2)
 ab2:	f9f5                	bnez	a1,aa6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 ab4:	8bce                	mv	s7,s3
      state = 0;
 ab6:	4981                	li	s3,0
 ab8:	bbcd                	j	8aa <vprintf+0x4a>
          s = "(null)";
 aba:	00000917          	auipc	s2,0x0
 abe:	30e90913          	addi	s2,s2,782 # dc8 <malloc+0x202>
        for(; *s; s++)
 ac2:	02800593          	li	a1,40
 ac6:	b7c5                	j	aa6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 ac8:	8bce                	mv	s7,s3
      state = 0;
 aca:	4981                	li	s3,0
 acc:	bbf9                	j	8aa <vprintf+0x4a>
 ace:	64a6                	ld	s1,72(sp)
 ad0:	79e2                	ld	s3,56(sp)
 ad2:	7a42                	ld	s4,48(sp)
 ad4:	7aa2                	ld	s5,40(sp)
 ad6:	7b02                	ld	s6,32(sp)
 ad8:	6be2                	ld	s7,24(sp)
 ada:	6c42                	ld	s8,16(sp)
 adc:	6ca2                	ld	s9,8(sp)
    }
  }
}
 ade:	60e6                	ld	ra,88(sp)
 ae0:	6446                	ld	s0,80(sp)
 ae2:	6906                	ld	s2,64(sp)
 ae4:	6125                	addi	sp,sp,96
 ae6:	8082                	ret

0000000000000ae8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 ae8:	715d                	addi	sp,sp,-80
 aea:	ec06                	sd	ra,24(sp)
 aec:	e822                	sd	s0,16(sp)
 aee:	1000                	addi	s0,sp,32
 af0:	e010                	sd	a2,0(s0)
 af2:	e414                	sd	a3,8(s0)
 af4:	e818                	sd	a4,16(s0)
 af6:	ec1c                	sd	a5,24(s0)
 af8:	03043023          	sd	a6,32(s0)
 afc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b00:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b04:	8622                	mv	a2,s0
 b06:	d5bff0ef          	jal	860 <vprintf>
}
 b0a:	60e2                	ld	ra,24(sp)
 b0c:	6442                	ld	s0,16(sp)
 b0e:	6161                	addi	sp,sp,80
 b10:	8082                	ret

0000000000000b12 <printf>:

void
printf(const char *fmt, ...)
{
 b12:	711d                	addi	sp,sp,-96
 b14:	ec06                	sd	ra,24(sp)
 b16:	e822                	sd	s0,16(sp)
 b18:	1000                	addi	s0,sp,32
 b1a:	e40c                	sd	a1,8(s0)
 b1c:	e810                	sd	a2,16(s0)
 b1e:	ec14                	sd	a3,24(s0)
 b20:	f018                	sd	a4,32(s0)
 b22:	f41c                	sd	a5,40(s0)
 b24:	03043823          	sd	a6,48(s0)
 b28:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b2c:	00840613          	addi	a2,s0,8
 b30:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b34:	85aa                	mv	a1,a0
 b36:	4505                	li	a0,1
 b38:	d29ff0ef          	jal	860 <vprintf>
}
 b3c:	60e2                	ld	ra,24(sp)
 b3e:	6442                	ld	s0,16(sp)
 b40:	6125                	addi	sp,sp,96
 b42:	8082                	ret

0000000000000b44 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b44:	1141                	addi	sp,sp,-16
 b46:	e422                	sd	s0,8(sp)
 b48:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b4a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b4e:	00001797          	auipc	a5,0x1
 b52:	4ea7b783          	ld	a5,1258(a5) # 2038 <freep>
 b56:	a02d                	j	b80 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b58:	4618                	lw	a4,8(a2)
 b5a:	9f2d                	addw	a4,a4,a1
 b5c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b60:	6398                	ld	a4,0(a5)
 b62:	6310                	ld	a2,0(a4)
 b64:	a83d                	j	ba2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b66:	ff852703          	lw	a4,-8(a0)
 b6a:	9f31                	addw	a4,a4,a2
 b6c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b6e:	ff053683          	ld	a3,-16(a0)
 b72:	a091                	j	bb6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b74:	6398                	ld	a4,0(a5)
 b76:	00e7e463          	bltu	a5,a4,b7e <free+0x3a>
 b7a:	00e6ea63          	bltu	a3,a4,b8e <free+0x4a>
{
 b7e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b80:	fed7fae3          	bgeu	a5,a3,b74 <free+0x30>
 b84:	6398                	ld	a4,0(a5)
 b86:	00e6e463          	bltu	a3,a4,b8e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b8a:	fee7eae3          	bltu	a5,a4,b7e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 b8e:	ff852583          	lw	a1,-8(a0)
 b92:	6390                	ld	a2,0(a5)
 b94:	02059813          	slli	a6,a1,0x20
 b98:	01c85713          	srli	a4,a6,0x1c
 b9c:	9736                	add	a4,a4,a3
 b9e:	fae60de3          	beq	a2,a4,b58 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 ba2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ba6:	4790                	lw	a2,8(a5)
 ba8:	02061593          	slli	a1,a2,0x20
 bac:	01c5d713          	srli	a4,a1,0x1c
 bb0:	973e                	add	a4,a4,a5
 bb2:	fae68ae3          	beq	a3,a4,b66 <free+0x22>
    p->s.ptr = bp->s.ptr;
 bb6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 bb8:	00001717          	auipc	a4,0x1
 bbc:	48f73023          	sd	a5,1152(a4) # 2038 <freep>
}
 bc0:	6422                	ld	s0,8(sp)
 bc2:	0141                	addi	sp,sp,16
 bc4:	8082                	ret

0000000000000bc6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 bc6:	7139                	addi	sp,sp,-64
 bc8:	fc06                	sd	ra,56(sp)
 bca:	f822                	sd	s0,48(sp)
 bcc:	f426                	sd	s1,40(sp)
 bce:	ec4e                	sd	s3,24(sp)
 bd0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bd2:	02051493          	slli	s1,a0,0x20
 bd6:	9081                	srli	s1,s1,0x20
 bd8:	04bd                	addi	s1,s1,15
 bda:	8091                	srli	s1,s1,0x4
 bdc:	0014899b          	addiw	s3,s1,1
 be0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 be2:	00001517          	auipc	a0,0x1
 be6:	45653503          	ld	a0,1110(a0) # 2038 <freep>
 bea:	c915                	beqz	a0,c1e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bee:	4798                	lw	a4,8(a5)
 bf0:	08977a63          	bgeu	a4,s1,c84 <malloc+0xbe>
 bf4:	f04a                	sd	s2,32(sp)
 bf6:	e852                	sd	s4,16(sp)
 bf8:	e456                	sd	s5,8(sp)
 bfa:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 bfc:	8a4e                	mv	s4,s3
 bfe:	0009871b          	sext.w	a4,s3
 c02:	6685                	lui	a3,0x1
 c04:	00d77363          	bgeu	a4,a3,c0a <malloc+0x44>
 c08:	6a05                	lui	s4,0x1
 c0a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c0e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c12:	00001917          	auipc	s2,0x1
 c16:	42690913          	addi	s2,s2,1062 # 2038 <freep>
  if(p == (char*)-1)
 c1a:	5afd                	li	s5,-1
 c1c:	a081                	j	c5c <malloc+0x96>
 c1e:	f04a                	sd	s2,32(sp)
 c20:	e852                	sd	s4,16(sp)
 c22:	e456                	sd	s5,8(sp)
 c24:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 c26:	00001797          	auipc	a5,0x1
 c2a:	61a78793          	addi	a5,a5,1562 # 2240 <base>
 c2e:	00001717          	auipc	a4,0x1
 c32:	40f73523          	sd	a5,1034(a4) # 2038 <freep>
 c36:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c38:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c3c:	b7c1                	j	bfc <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 c3e:	6398                	ld	a4,0(a5)
 c40:	e118                	sd	a4,0(a0)
 c42:	a8a9                	j	c9c <malloc+0xd6>
  hp->s.size = nu;
 c44:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c48:	0541                	addi	a0,a0,16
 c4a:	efbff0ef          	jal	b44 <free>
  return freep;
 c4e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c52:	c12d                	beqz	a0,cb4 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c54:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c56:	4798                	lw	a4,8(a5)
 c58:	02977263          	bgeu	a4,s1,c7c <malloc+0xb6>
    if(p == freep)
 c5c:	00093703          	ld	a4,0(s2)
 c60:	853e                	mv	a0,a5
 c62:	fef719e3          	bne	a4,a5,c54 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 c66:	8552                	mv	a0,s4
 c68:	aebff0ef          	jal	752 <sbrk>
  if(p == (char*)-1)
 c6c:	fd551ce3          	bne	a0,s5,c44 <malloc+0x7e>
        return 0;
 c70:	4501                	li	a0,0
 c72:	7902                	ld	s2,32(sp)
 c74:	6a42                	ld	s4,16(sp)
 c76:	6aa2                	ld	s5,8(sp)
 c78:	6b02                	ld	s6,0(sp)
 c7a:	a03d                	j	ca8 <malloc+0xe2>
 c7c:	7902                	ld	s2,32(sp)
 c7e:	6a42                	ld	s4,16(sp)
 c80:	6aa2                	ld	s5,8(sp)
 c82:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 c84:	fae48de3          	beq	s1,a4,c3e <malloc+0x78>
        p->s.size -= nunits;
 c88:	4137073b          	subw	a4,a4,s3
 c8c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c8e:	02071693          	slli	a3,a4,0x20
 c92:	01c6d713          	srli	a4,a3,0x1c
 c96:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c98:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c9c:	00001717          	auipc	a4,0x1
 ca0:	38a73e23          	sd	a0,924(a4) # 2038 <freep>
      return (void*)(p + 1);
 ca4:	01078513          	addi	a0,a5,16
  }
}
 ca8:	70e2                	ld	ra,56(sp)
 caa:	7442                	ld	s0,48(sp)
 cac:	74a2                	ld	s1,40(sp)
 cae:	69e2                	ld	s3,24(sp)
 cb0:	6121                	addi	sp,sp,64
 cb2:	8082                	ret
 cb4:	7902                	ld	s2,32(sp)
 cb6:	6a42                	ld	s4,16(sp)
 cb8:	6aa2                	ld	s5,8(sp)
 cba:	6b02                	ld	s6,0(sp)
 cbc:	b7f5                	j	ca8 <malloc+0xe2>
