
user/_getptable:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
  "ZOMBIE"
};

int
main(int argc, char *argv[])
{
   0:	81010113          	addi	sp,sp,-2032
   4:	7e113423          	sd	ra,2024(sp)
   8:	7e813023          	sd	s0,2016(sp)
   c:	7c913c23          	sd	s1,2008(sp)
  10:	7d213823          	sd	s2,2000(sp)
  14:	7d313423          	sd	s3,1992(sp)
  18:	7d413023          	sd	s4,1984(sp)
  1c:	7b513c23          	sd	s5,1976(sp)
  20:	7b613823          	sd	s6,1968(sp)
  24:	7b713423          	sd	s7,1960(sp)
  28:	7f010413          	addi	s0,sp,2032
  2c:	d9010113          	addi	sp,sp,-624
  struct proc_info ptable[MAX_PROC];
  int result;
  int i;
  int count = 0;
  
  printf("Testing getptable system call...\n");
  30:	00001517          	auipc	a0,0x1
  34:	95850513          	addi	a0,a0,-1704 # 988 <malloc+0x100>
  38:	79c000ef          	jal	7d4 <printf>
  printf("================================\n\n");
  3c:	00001517          	auipc	a0,0x1
  40:	97450513          	addi	a0,a0,-1676 # 9b0 <malloc+0x128>
  44:	790000ef          	jal	7d4 <printf>
  
  // Call the system call
  result = getptable(MAX_PROC, (uint64)ptable);
  48:	77fd                	lui	a5,0xfffff
  4a:	5b078793          	addi	a5,a5,1456 # fffffffffffff5b0 <base+0xffffffffffffe570>
  4e:	97a2                	add	a5,a5,s0
  50:	76fd                	lui	a3,0xfffff
  52:	5a868713          	addi	a4,a3,1448 # fffffffffffff5a8 <base+0xffffffffffffe568>
  56:	9722                	add	a4,a4,s0
  58:	e31c                	sd	a5,0(a4)
  5a:	630c                	ld	a1,0(a4)
  5c:	04000513          	li	a0,64
  60:	3f4000ef          	jal	454 <getptable>
  
  if (result == 0) {
  64:	e911                	bnez	a0,78 <main+0x78>
    printf("ERROR: getptable failed!\n");
  66:	00001517          	auipc	a0,0x1
  6a:	97250513          	addi	a0,a0,-1678 # 9d8 <malloc+0x150>
  6e:	766000ef          	jal	7d4 <printf>
    exit(1);
  72:	4505                	li	a0,1
  74:	318000ef          	jal	38c <exit>
  }
  
  printf("getptable succeeded!\n\n");
  78:	00001517          	auipc	a0,0x1
  7c:	98050513          	addi	a0,a0,-1664 # 9f8 <malloc+0x170>
  80:	754000ef          	jal	7d4 <printf>
  
  // Print header - simpler format for xv6 printf
  printf("PID  PPID STATE      NAME             SIZE\n");
  84:	00001517          	auipc	a0,0x1
  88:	98c50513          	addi	a0,a0,-1652 # a10 <malloc+0x188>
  8c:	748000ef          	jal	7d4 <printf>
  printf("---  ---- -----      ----             ----\n");
  90:	00001517          	auipc	a0,0x1
  94:	9b050513          	addi	a0,a0,-1616 # a40 <malloc+0x1b8>
  98:	73c000ef          	jal	7d4 <printf>
  
  // Display process information
  for (i = 0; i < MAX_PROC; i++) {
  9c:	74fd                	lui	s1,0xfffff
  9e:	5bc48793          	addi	a5,s1,1468 # fffffffffffff5bc <base+0xffffffffffffe57c>
  a2:	008784b3          	add	s1,a5,s0
  a6:	6785                	lui	a5,0x1
  a8:	a0c78793          	addi	a5,a5,-1524 # a0c <malloc+0x184>
  ac:	777d                	lui	a4,0xfffff
  ae:	5a870713          	addi	a4,a4,1448 # fffffffffffff5a8 <base+0xffffffffffffe568>
  b2:	9722                	add	a4,a4,s0
  b4:	6318                	ld	a4,0(a4)
  b6:	00f709b3          	add	s3,a4,a5
  int count = 0;
  ba:	4901                	li	s2,0
    // Check if this is a valid process entry
    if (ptable[i].pid > 0) {
      const char *state_str = "UNKNOWN";
      if (ptable[i].state >= 0 && ptable[i].state <= 5) {
  bc:	4b15                	li	s6,5
      const char *state_str = "UNKNOWN";
  be:	00001a97          	auipc	s5,0x1
  c2:	8c2a8a93          	addi	s5,s5,-1854 # 980 <malloc+0xf8>
        state_str = state_names[ptable[i].state];
      }
      
      // Simple format without width specifiers
      printf("%d\t %d\t %s\t %s\t %d\n",
  c6:	00001a17          	auipc	s4,0x1
  ca:	9aaa0a13          	addi	s4,s4,-1622 # a70 <malloc+0x1e8>
        state_str = state_names[ptable[i].state];
  ce:	00001b97          	auipc	s7,0x1
  d2:	f32b8b93          	addi	s7,s7,-206 # 1000 <state_names>
  d6:	a821                	j	ee <main+0xee>
      printf("%d\t %d\t %s\t %s\t %d\n",
  d8:	4b5c                	lw	a5,20(a4)
  da:	ff872603          	lw	a2,-8(a4)
  de:	8552                	mv	a0,s4
  e0:	6f4000ef          	jal	7d4 <printf>
             ptable[i].pid,
             ptable[i].ppid,
             state_str,
             ptable[i].name,
             (int)ptable[i].sz);
      count++;
  e4:	2905                	addiw	s2,s2,1
  for (i = 0; i < MAX_PROC; i++) {
  e6:	02848493          	addi	s1,s1,40
  ea:	03348263          	beq	s1,s3,10e <main+0x10e>
    if (ptable[i].pid > 0) {
  ee:	8726                	mv	a4,s1
  f0:	ff44a583          	lw	a1,-12(s1)
  f4:	feb059e3          	blez	a1,e6 <main+0xe6>
      if (ptable[i].state >= 0 && ptable[i].state <= 5) {
  f8:	ffc4a783          	lw	a5,-4(s1)
  fc:	0007861b          	sext.w	a2,a5
      const char *state_str = "UNKNOWN";
 100:	86d6                	mv	a3,s5
      if (ptable[i].state >= 0 && ptable[i].state <= 5) {
 102:	fccb6be3          	bltu	s6,a2,d8 <main+0xd8>
        state_str = state_names[ptable[i].state];
 106:	078e                	slli	a5,a5,0x3
 108:	97de                	add	a5,a5,s7
 10a:	6394                	ld	a3,0(a5)
 10c:	b7f1                	j	d8 <main+0xd8>
    }
  }
  
  printf("\nTotal processes: %d\n", count);
 10e:	85ca                	mv	a1,s2
 110:	00001517          	auipc	a0,0x1
 114:	97850513          	addi	a0,a0,-1672 # a88 <malloc+0x200>
 118:	6bc000ef          	jal	7d4 <printf>
  
  exit(0);
 11c:	4501                	li	a0,0
 11e:	26e000ef          	jal	38c <exit>

0000000000000122 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 122:	1141                	addi	sp,sp,-16
 124:	e406                	sd	ra,8(sp)
 126:	e022                	sd	s0,0(sp)
 128:	0800                	addi	s0,sp,16
  extern int main();
  main();
 12a:	ed7ff0ef          	jal	0 <main>
  exit(0);
 12e:	4501                	li	a0,0
 130:	25c000ef          	jal	38c <exit>

0000000000000134 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 134:	1141                	addi	sp,sp,-16
 136:	e422                	sd	s0,8(sp)
 138:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 13a:	87aa                	mv	a5,a0
 13c:	0585                	addi	a1,a1,1
 13e:	0785                	addi	a5,a5,1
 140:	fff5c703          	lbu	a4,-1(a1)
 144:	fee78fa3          	sb	a4,-1(a5)
 148:	fb75                	bnez	a4,13c <strcpy+0x8>
    ;
  return os;
}
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret

0000000000000150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 150:	1141                	addi	sp,sp,-16
 152:	e422                	sd	s0,8(sp)
 154:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 156:	00054783          	lbu	a5,0(a0)
 15a:	cb91                	beqz	a5,16e <strcmp+0x1e>
 15c:	0005c703          	lbu	a4,0(a1)
 160:	00f71763          	bne	a4,a5,16e <strcmp+0x1e>
    p++, q++;
 164:	0505                	addi	a0,a0,1
 166:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 168:	00054783          	lbu	a5,0(a0)
 16c:	fbe5                	bnez	a5,15c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 16e:	0005c503          	lbu	a0,0(a1)
}
 172:	40a7853b          	subw	a0,a5,a0
 176:	6422                	ld	s0,8(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret

000000000000017c <strlen>:

uint
strlen(const char *s)
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e422                	sd	s0,8(sp)
 180:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 182:	00054783          	lbu	a5,0(a0)
 186:	cf91                	beqz	a5,1a2 <strlen+0x26>
 188:	0505                	addi	a0,a0,1
 18a:	87aa                	mv	a5,a0
 18c:	86be                	mv	a3,a5
 18e:	0785                	addi	a5,a5,1
 190:	fff7c703          	lbu	a4,-1(a5)
 194:	ff65                	bnez	a4,18c <strlen+0x10>
 196:	40a6853b          	subw	a0,a3,a0
 19a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 19c:	6422                	ld	s0,8(sp)
 19e:	0141                	addi	sp,sp,16
 1a0:	8082                	ret
  for(n = 0; s[n]; n++)
 1a2:	4501                	li	a0,0
 1a4:	bfe5                	j	19c <strlen+0x20>

00000000000001a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ac:	ca19                	beqz	a2,1c2 <memset+0x1c>
 1ae:	87aa                	mv	a5,a0
 1b0:	1602                	slli	a2,a2,0x20
 1b2:	9201                	srli	a2,a2,0x20
 1b4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1b8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1bc:	0785                	addi	a5,a5,1
 1be:	fee79de3          	bne	a5,a4,1b8 <memset+0x12>
  }
  return dst;
}
 1c2:	6422                	ld	s0,8(sp)
 1c4:	0141                	addi	sp,sp,16
 1c6:	8082                	ret

00000000000001c8 <strchr>:

char*
strchr(const char *s, char c)
{
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1ce:	00054783          	lbu	a5,0(a0)
 1d2:	cb99                	beqz	a5,1e8 <strchr+0x20>
    if(*s == c)
 1d4:	00f58763          	beq	a1,a5,1e2 <strchr+0x1a>
  for(; *s; s++)
 1d8:	0505                	addi	a0,a0,1
 1da:	00054783          	lbu	a5,0(a0)
 1de:	fbfd                	bnez	a5,1d4 <strchr+0xc>
      return (char*)s;
  return 0;
 1e0:	4501                	li	a0,0
}
 1e2:	6422                	ld	s0,8(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret
  return 0;
 1e8:	4501                	li	a0,0
 1ea:	bfe5                	j	1e2 <strchr+0x1a>

00000000000001ec <gets>:

char*
gets(char *buf, int max)
{
 1ec:	711d                	addi	sp,sp,-96
 1ee:	ec86                	sd	ra,88(sp)
 1f0:	e8a2                	sd	s0,80(sp)
 1f2:	e4a6                	sd	s1,72(sp)
 1f4:	e0ca                	sd	s2,64(sp)
 1f6:	fc4e                	sd	s3,56(sp)
 1f8:	f852                	sd	s4,48(sp)
 1fa:	f456                	sd	s5,40(sp)
 1fc:	f05a                	sd	s6,32(sp)
 1fe:	ec5e                	sd	s7,24(sp)
 200:	1080                	addi	s0,sp,96
 202:	8baa                	mv	s7,a0
 204:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 206:	892a                	mv	s2,a0
 208:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 20a:	4aa9                	li	s5,10
 20c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 20e:	89a6                	mv	s3,s1
 210:	2485                	addiw	s1,s1,1
 212:	0344d663          	bge	s1,s4,23e <gets+0x52>
    cc = read(0, &c, 1);
 216:	4605                	li	a2,1
 218:	faf40593          	addi	a1,s0,-81
 21c:	4501                	li	a0,0
 21e:	186000ef          	jal	3a4 <read>
    if(cc < 1)
 222:	00a05e63          	blez	a0,23e <gets+0x52>
    buf[i++] = c;
 226:	faf44783          	lbu	a5,-81(s0)
 22a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 22e:	01578763          	beq	a5,s5,23c <gets+0x50>
 232:	0905                	addi	s2,s2,1
 234:	fd679de3          	bne	a5,s6,20e <gets+0x22>
    buf[i++] = c;
 238:	89a6                	mv	s3,s1
 23a:	a011                	j	23e <gets+0x52>
 23c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 23e:	99de                	add	s3,s3,s7
 240:	00098023          	sb	zero,0(s3)
  return buf;
}
 244:	855e                	mv	a0,s7
 246:	60e6                	ld	ra,88(sp)
 248:	6446                	ld	s0,80(sp)
 24a:	64a6                	ld	s1,72(sp)
 24c:	6906                	ld	s2,64(sp)
 24e:	79e2                	ld	s3,56(sp)
 250:	7a42                	ld	s4,48(sp)
 252:	7aa2                	ld	s5,40(sp)
 254:	7b02                	ld	s6,32(sp)
 256:	6be2                	ld	s7,24(sp)
 258:	6125                	addi	sp,sp,96
 25a:	8082                	ret

000000000000025c <stat>:

int
stat(const char *n, struct stat *st)
{
 25c:	1101                	addi	sp,sp,-32
 25e:	ec06                	sd	ra,24(sp)
 260:	e822                	sd	s0,16(sp)
 262:	e04a                	sd	s2,0(sp)
 264:	1000                	addi	s0,sp,32
 266:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 268:	4581                	li	a1,0
 26a:	162000ef          	jal	3cc <open>
  if(fd < 0)
 26e:	02054263          	bltz	a0,292 <stat+0x36>
 272:	e426                	sd	s1,8(sp)
 274:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 276:	85ca                	mv	a1,s2
 278:	16c000ef          	jal	3e4 <fstat>
 27c:	892a                	mv	s2,a0
  close(fd);
 27e:	8526                	mv	a0,s1
 280:	134000ef          	jal	3b4 <close>
  return r;
 284:	64a2                	ld	s1,8(sp)
}
 286:	854a                	mv	a0,s2
 288:	60e2                	ld	ra,24(sp)
 28a:	6442                	ld	s0,16(sp)
 28c:	6902                	ld	s2,0(sp)
 28e:	6105                	addi	sp,sp,32
 290:	8082                	ret
    return -1;
 292:	597d                	li	s2,-1
 294:	bfcd                	j	286 <stat+0x2a>

0000000000000296 <atoi>:

int
atoi(const char *s)
{
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29c:	00054683          	lbu	a3,0(a0)
 2a0:	fd06879b          	addiw	a5,a3,-48
 2a4:	0ff7f793          	zext.b	a5,a5
 2a8:	4625                	li	a2,9
 2aa:	02f66863          	bltu	a2,a5,2da <atoi+0x44>
 2ae:	872a                	mv	a4,a0
  n = 0;
 2b0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2b2:	0705                	addi	a4,a4,1
 2b4:	0025179b          	slliw	a5,a0,0x2
 2b8:	9fa9                	addw	a5,a5,a0
 2ba:	0017979b          	slliw	a5,a5,0x1
 2be:	9fb5                	addw	a5,a5,a3
 2c0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c4:	00074683          	lbu	a3,0(a4)
 2c8:	fd06879b          	addiw	a5,a3,-48
 2cc:	0ff7f793          	zext.b	a5,a5
 2d0:	fef671e3          	bgeu	a2,a5,2b2 <atoi+0x1c>
  return n;
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  n = 0;
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <atoi+0x3e>

00000000000002de <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e4:	02b57463          	bgeu	a0,a1,30c <memmove+0x2e>
    while(n-- > 0)
 2e8:	00c05f63          	blez	a2,306 <memmove+0x28>
 2ec:	1602                	slli	a2,a2,0x20
 2ee:	9201                	srli	a2,a2,0x20
 2f0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f6:	0585                	addi	a1,a1,1
 2f8:	0705                	addi	a4,a4,1
 2fa:	fff5c683          	lbu	a3,-1(a1)
 2fe:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 302:	fef71ae3          	bne	a4,a5,2f6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 306:	6422                	ld	s0,8(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret
    dst += n;
 30c:	00c50733          	add	a4,a0,a2
    src += n;
 310:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 312:	fec05ae3          	blez	a2,306 <memmove+0x28>
 316:	fff6079b          	addiw	a5,a2,-1
 31a:	1782                	slli	a5,a5,0x20
 31c:	9381                	srli	a5,a5,0x20
 31e:	fff7c793          	not	a5,a5
 322:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 324:	15fd                	addi	a1,a1,-1
 326:	177d                	addi	a4,a4,-1
 328:	0005c683          	lbu	a3,0(a1)
 32c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 330:	fee79ae3          	bne	a5,a4,324 <memmove+0x46>
 334:	bfc9                	j	306 <memmove+0x28>

0000000000000336 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 33c:	ca05                	beqz	a2,36c <memcmp+0x36>
 33e:	fff6069b          	addiw	a3,a2,-1
 342:	1682                	slli	a3,a3,0x20
 344:	9281                	srli	a3,a3,0x20
 346:	0685                	addi	a3,a3,1
 348:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 34a:	00054783          	lbu	a5,0(a0)
 34e:	0005c703          	lbu	a4,0(a1)
 352:	00e79863          	bne	a5,a4,362 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 356:	0505                	addi	a0,a0,1
    p2++;
 358:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 35a:	fed518e3          	bne	a0,a3,34a <memcmp+0x14>
  }
  return 0;
 35e:	4501                	li	a0,0
 360:	a019                	j	366 <memcmp+0x30>
      return *p1 - *p2;
 362:	40e7853b          	subw	a0,a5,a4
}
 366:	6422                	ld	s0,8(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret
  return 0;
 36c:	4501                	li	a0,0
 36e:	bfe5                	j	366 <memcmp+0x30>

0000000000000370 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e406                	sd	ra,8(sp)
 374:	e022                	sd	s0,0(sp)
 376:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 378:	f67ff0ef          	jal	2de <memmove>
}
 37c:	60a2                	ld	ra,8(sp)
 37e:	6402                	ld	s0,0(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret

0000000000000384 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 384:	4885                	li	a7,1
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <exit>:
.global exit
exit:
 li a7, SYS_exit
 38c:	4889                	li	a7,2
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <wait>:
.global wait
wait:
 li a7, SYS_wait
 394:	488d                	li	a7,3
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 39c:	4891                	li	a7,4
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <read>:
.global read
read:
 li a7, SYS_read
 3a4:	4895                	li	a7,5
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <write>:
.global write
write:
 li a7, SYS_write
 3ac:	48c1                	li	a7,16
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <close>:
.global close
close:
 li a7, SYS_close
 3b4:	48d5                	li	a7,21
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <kill>:
.global kill
kill:
 li a7, SYS_kill
 3bc:	4899                	li	a7,6
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c4:	489d                	li	a7,7
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <open>:
.global open
open:
 li a7, SYS_open
 3cc:	48bd                	li	a7,15
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d4:	48c5                	li	a7,17
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3dc:	48c9                	li	a7,18
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e4:	48a1                	li	a7,8
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <link>:
.global link
link:
 li a7, SYS_link
 3ec:	48cd                	li	a7,19
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f4:	48d1                	li	a7,20
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3fc:	48a5                	li	a7,9
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <dup>:
.global dup
dup:
 li a7, SYS_dup
 404:	48a9                	li	a7,10
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 40c:	48ad                	li	a7,11
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 414:	48b1                	li	a7,12
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 41c:	48b5                	li	a7,13
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 424:	48b9                	li	a7,14
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 42c:	48d9                	li	a7,22
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 434:	48dd                	li	a7,23
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 43c:	48e1                	li	a7,24
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 444:	48e5                	li	a7,25
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <rand>:
.global rand
rand:
 li a7, SYS_rand
 44c:	48e9                	li	a7,26
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 454:	48ed                	li	a7,27
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 45c:	1101                	addi	sp,sp,-32
 45e:	ec06                	sd	ra,24(sp)
 460:	e822                	sd	s0,16(sp)
 462:	1000                	addi	s0,sp,32
 464:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 468:	4605                	li	a2,1
 46a:	fef40593          	addi	a1,s0,-17
 46e:	f3fff0ef          	jal	3ac <write>
}
 472:	60e2                	ld	ra,24(sp)
 474:	6442                	ld	s0,16(sp)
 476:	6105                	addi	sp,sp,32
 478:	8082                	ret

000000000000047a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 47a:	7139                	addi	sp,sp,-64
 47c:	fc06                	sd	ra,56(sp)
 47e:	f822                	sd	s0,48(sp)
 480:	f426                	sd	s1,40(sp)
 482:	0080                	addi	s0,sp,64
 484:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 486:	c299                	beqz	a3,48c <printint+0x12>
 488:	0805c963          	bltz	a1,51a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 48c:	2581                	sext.w	a1,a1
  neg = 0;
 48e:	4881                	li	a7,0
 490:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 494:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 496:	2601                	sext.w	a2,a2
 498:	00000517          	auipc	a0,0x0
 49c:	65050513          	addi	a0,a0,1616 # ae8 <digits>
 4a0:	883a                	mv	a6,a4
 4a2:	2705                	addiw	a4,a4,1
 4a4:	02c5f7bb          	remuw	a5,a1,a2
 4a8:	1782                	slli	a5,a5,0x20
 4aa:	9381                	srli	a5,a5,0x20
 4ac:	97aa                	add	a5,a5,a0
 4ae:	0007c783          	lbu	a5,0(a5)
 4b2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4b6:	0005879b          	sext.w	a5,a1
 4ba:	02c5d5bb          	divuw	a1,a1,a2
 4be:	0685                	addi	a3,a3,1
 4c0:	fec7f0e3          	bgeu	a5,a2,4a0 <printint+0x26>
  if(neg)
 4c4:	00088c63          	beqz	a7,4dc <printint+0x62>
    buf[i++] = '-';
 4c8:	fd070793          	addi	a5,a4,-48
 4cc:	00878733          	add	a4,a5,s0
 4d0:	02d00793          	li	a5,45
 4d4:	fef70823          	sb	a5,-16(a4)
 4d8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4dc:	02e05a63          	blez	a4,510 <printint+0x96>
 4e0:	f04a                	sd	s2,32(sp)
 4e2:	ec4e                	sd	s3,24(sp)
 4e4:	fc040793          	addi	a5,s0,-64
 4e8:	00e78933          	add	s2,a5,a4
 4ec:	fff78993          	addi	s3,a5,-1
 4f0:	99ba                	add	s3,s3,a4
 4f2:	377d                	addiw	a4,a4,-1
 4f4:	1702                	slli	a4,a4,0x20
 4f6:	9301                	srli	a4,a4,0x20
 4f8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4fc:	fff94583          	lbu	a1,-1(s2)
 500:	8526                	mv	a0,s1
 502:	f5bff0ef          	jal	45c <putc>
  while(--i >= 0)
 506:	197d                	addi	s2,s2,-1
 508:	ff391ae3          	bne	s2,s3,4fc <printint+0x82>
 50c:	7902                	ld	s2,32(sp)
 50e:	69e2                	ld	s3,24(sp)
}
 510:	70e2                	ld	ra,56(sp)
 512:	7442                	ld	s0,48(sp)
 514:	74a2                	ld	s1,40(sp)
 516:	6121                	addi	sp,sp,64
 518:	8082                	ret
    x = -xx;
 51a:	40b005bb          	negw	a1,a1
    neg = 1;
 51e:	4885                	li	a7,1
    x = -xx;
 520:	bf85                	j	490 <printint+0x16>

0000000000000522 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 522:	711d                	addi	sp,sp,-96
 524:	ec86                	sd	ra,88(sp)
 526:	e8a2                	sd	s0,80(sp)
 528:	e0ca                	sd	s2,64(sp)
 52a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52c:	0005c903          	lbu	s2,0(a1)
 530:	26090863          	beqz	s2,7a0 <vprintf+0x27e>
 534:	e4a6                	sd	s1,72(sp)
 536:	fc4e                	sd	s3,56(sp)
 538:	f852                	sd	s4,48(sp)
 53a:	f456                	sd	s5,40(sp)
 53c:	f05a                	sd	s6,32(sp)
 53e:	ec5e                	sd	s7,24(sp)
 540:	e862                	sd	s8,16(sp)
 542:	e466                	sd	s9,8(sp)
 544:	8b2a                	mv	s6,a0
 546:	8a2e                	mv	s4,a1
 548:	8bb2                	mv	s7,a2
  state = 0;
 54a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 54c:	4481                	li	s1,0
 54e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 550:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 554:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 558:	06c00c93          	li	s9,108
 55c:	a005                	j	57c <vprintf+0x5a>
        putc(fd, c0);
 55e:	85ca                	mv	a1,s2
 560:	855a                	mv	a0,s6
 562:	efbff0ef          	jal	45c <putc>
 566:	a019                	j	56c <vprintf+0x4a>
    } else if(state == '%'){
 568:	03598263          	beq	s3,s5,58c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 56c:	2485                	addiw	s1,s1,1
 56e:	8726                	mv	a4,s1
 570:	009a07b3          	add	a5,s4,s1
 574:	0007c903          	lbu	s2,0(a5)
 578:	20090c63          	beqz	s2,790 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 57c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 580:	fe0994e3          	bnez	s3,568 <vprintf+0x46>
      if(c0 == '%'){
 584:	fd579de3          	bne	a5,s5,55e <vprintf+0x3c>
        state = '%';
 588:	89be                	mv	s3,a5
 58a:	b7cd                	j	56c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 58c:	00ea06b3          	add	a3,s4,a4
 590:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 594:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 596:	c681                	beqz	a3,59e <vprintf+0x7c>
 598:	9752                	add	a4,a4,s4
 59a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 59e:	03878f63          	beq	a5,s8,5dc <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5a2:	05978963          	beq	a5,s9,5f4 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5a6:	07500713          	li	a4,117
 5aa:	0ee78363          	beq	a5,a4,690 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5ae:	07800713          	li	a4,120
 5b2:	12e78563          	beq	a5,a4,6dc <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5b6:	07000713          	li	a4,112
 5ba:	14e78a63          	beq	a5,a4,70e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5be:	07300713          	li	a4,115
 5c2:	18e78a63          	beq	a5,a4,756 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5c6:	02500713          	li	a4,37
 5ca:	04e79563          	bne	a5,a4,614 <vprintf+0xf2>
        putc(fd, '%');
 5ce:	02500593          	li	a1,37
 5d2:	855a                	mv	a0,s6
 5d4:	e89ff0ef          	jal	45c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	bf49                	j	56c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5dc:	008b8913          	addi	s2,s7,8
 5e0:	4685                	li	a3,1
 5e2:	4629                	li	a2,10
 5e4:	000ba583          	lw	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	e91ff0ef          	jal	47a <printint>
 5ee:	8bca                	mv	s7,s2
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	bfad                	j	56c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5f4:	06400793          	li	a5,100
 5f8:	02f68963          	beq	a3,a5,62a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5fc:	06c00793          	li	a5,108
 600:	04f68263          	beq	a3,a5,644 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 604:	07500793          	li	a5,117
 608:	0af68063          	beq	a3,a5,6a8 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 60c:	07800793          	li	a5,120
 610:	0ef68263          	beq	a3,a5,6f4 <vprintf+0x1d2>
        putc(fd, '%');
 614:	02500593          	li	a1,37
 618:	855a                	mv	a0,s6
 61a:	e43ff0ef          	jal	45c <putc>
        putc(fd, c0);
 61e:	85ca                	mv	a1,s2
 620:	855a                	mv	a0,s6
 622:	e3bff0ef          	jal	45c <putc>
      state = 0;
 626:	4981                	li	s3,0
 628:	b791                	j	56c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 62a:	008b8913          	addi	s2,s7,8
 62e:	4685                	li	a3,1
 630:	4629                	li	a2,10
 632:	000ba583          	lw	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	e43ff0ef          	jal	47a <printint>
        i += 1;
 63c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 63e:	8bca                	mv	s7,s2
      state = 0;
 640:	4981                	li	s3,0
        i += 1;
 642:	b72d                	j	56c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 644:	06400793          	li	a5,100
 648:	02f60763          	beq	a2,a5,676 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 64c:	07500793          	li	a5,117
 650:	06f60963          	beq	a2,a5,6c2 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 654:	07800793          	li	a5,120
 658:	faf61ee3          	bne	a2,a5,614 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65c:	008b8913          	addi	s2,s7,8
 660:	4681                	li	a3,0
 662:	4641                	li	a2,16
 664:	000ba583          	lw	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	e11ff0ef          	jal	47a <printint>
        i += 2;
 66e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 670:	8bca                	mv	s7,s2
      state = 0;
 672:	4981                	li	s3,0
        i += 2;
 674:	bde5                	j	56c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 676:	008b8913          	addi	s2,s7,8
 67a:	4685                	li	a3,1
 67c:	4629                	li	a2,10
 67e:	000ba583          	lw	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	df7ff0ef          	jal	47a <printint>
        i += 2;
 688:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 68a:	8bca                	mv	s7,s2
      state = 0;
 68c:	4981                	li	s3,0
        i += 2;
 68e:	bdf9                	j	56c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 690:	008b8913          	addi	s2,s7,8
 694:	4681                	li	a3,0
 696:	4629                	li	a2,10
 698:	000ba583          	lw	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	dddff0ef          	jal	47a <printint>
 6a2:	8bca                	mv	s7,s2
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b5d9                	j	56c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a8:	008b8913          	addi	s2,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4629                	li	a2,10
 6b0:	000ba583          	lw	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	dc5ff0ef          	jal	47a <printint>
        i += 1;
 6ba:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6bc:	8bca                	mv	s7,s2
      state = 0;
 6be:	4981                	li	s3,0
        i += 1;
 6c0:	b575                	j	56c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c2:	008b8913          	addi	s2,s7,8
 6c6:	4681                	li	a3,0
 6c8:	4629                	li	a2,10
 6ca:	000ba583          	lw	a1,0(s7)
 6ce:	855a                	mv	a0,s6
 6d0:	dabff0ef          	jal	47a <printint>
        i += 2;
 6d4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d6:	8bca                	mv	s7,s2
      state = 0;
 6d8:	4981                	li	s3,0
        i += 2;
 6da:	bd49                	j	56c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6dc:	008b8913          	addi	s2,s7,8
 6e0:	4681                	li	a3,0
 6e2:	4641                	li	a2,16
 6e4:	000ba583          	lw	a1,0(s7)
 6e8:	855a                	mv	a0,s6
 6ea:	d91ff0ef          	jal	47a <printint>
 6ee:	8bca                	mv	s7,s2
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	bdad                	j	56c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f4:	008b8913          	addi	s2,s7,8
 6f8:	4681                	li	a3,0
 6fa:	4641                	li	a2,16
 6fc:	000ba583          	lw	a1,0(s7)
 700:	855a                	mv	a0,s6
 702:	d79ff0ef          	jal	47a <printint>
        i += 1;
 706:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 708:	8bca                	mv	s7,s2
      state = 0;
 70a:	4981                	li	s3,0
        i += 1;
 70c:	b585                	j	56c <vprintf+0x4a>
 70e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 710:	008b8d13          	addi	s10,s7,8
 714:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 718:	03000593          	li	a1,48
 71c:	855a                	mv	a0,s6
 71e:	d3fff0ef          	jal	45c <putc>
  putc(fd, 'x');
 722:	07800593          	li	a1,120
 726:	855a                	mv	a0,s6
 728:	d35ff0ef          	jal	45c <putc>
 72c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 72e:	00000b97          	auipc	s7,0x0
 732:	3bab8b93          	addi	s7,s7,954 # ae8 <digits>
 736:	03c9d793          	srli	a5,s3,0x3c
 73a:	97de                	add	a5,a5,s7
 73c:	0007c583          	lbu	a1,0(a5)
 740:	855a                	mv	a0,s6
 742:	d1bff0ef          	jal	45c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 746:	0992                	slli	s3,s3,0x4
 748:	397d                	addiw	s2,s2,-1
 74a:	fe0916e3          	bnez	s2,736 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 74e:	8bea                	mv	s7,s10
      state = 0;
 750:	4981                	li	s3,0
 752:	6d02                	ld	s10,0(sp)
 754:	bd21                	j	56c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 756:	008b8993          	addi	s3,s7,8
 75a:	000bb903          	ld	s2,0(s7)
 75e:	00090f63          	beqz	s2,77c <vprintf+0x25a>
        for(; *s; s++)
 762:	00094583          	lbu	a1,0(s2)
 766:	c195                	beqz	a1,78a <vprintf+0x268>
          putc(fd, *s);
 768:	855a                	mv	a0,s6
 76a:	cf3ff0ef          	jal	45c <putc>
        for(; *s; s++)
 76e:	0905                	addi	s2,s2,1
 770:	00094583          	lbu	a1,0(s2)
 774:	f9f5                	bnez	a1,768 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 776:	8bce                	mv	s7,s3
      state = 0;
 778:	4981                	li	s3,0
 77a:	bbcd                	j	56c <vprintf+0x4a>
          s = "(null)";
 77c:	00000917          	auipc	s2,0x0
 780:	36490913          	addi	s2,s2,868 # ae0 <malloc+0x258>
        for(; *s; s++)
 784:	02800593          	li	a1,40
 788:	b7c5                	j	768 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 78a:	8bce                	mv	s7,s3
      state = 0;
 78c:	4981                	li	s3,0
 78e:	bbf9                	j	56c <vprintf+0x4a>
 790:	64a6                	ld	s1,72(sp)
 792:	79e2                	ld	s3,56(sp)
 794:	7a42                	ld	s4,48(sp)
 796:	7aa2                	ld	s5,40(sp)
 798:	7b02                	ld	s6,32(sp)
 79a:	6be2                	ld	s7,24(sp)
 79c:	6c42                	ld	s8,16(sp)
 79e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7a0:	60e6                	ld	ra,88(sp)
 7a2:	6446                	ld	s0,80(sp)
 7a4:	6906                	ld	s2,64(sp)
 7a6:	6125                	addi	sp,sp,96
 7a8:	8082                	ret

00000000000007aa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7aa:	715d                	addi	sp,sp,-80
 7ac:	ec06                	sd	ra,24(sp)
 7ae:	e822                	sd	s0,16(sp)
 7b0:	1000                	addi	s0,sp,32
 7b2:	e010                	sd	a2,0(s0)
 7b4:	e414                	sd	a3,8(s0)
 7b6:	e818                	sd	a4,16(s0)
 7b8:	ec1c                	sd	a5,24(s0)
 7ba:	03043023          	sd	a6,32(s0)
 7be:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7c2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7c6:	8622                	mv	a2,s0
 7c8:	d5bff0ef          	jal	522 <vprintf>
}
 7cc:	60e2                	ld	ra,24(sp)
 7ce:	6442                	ld	s0,16(sp)
 7d0:	6161                	addi	sp,sp,80
 7d2:	8082                	ret

00000000000007d4 <printf>:

void
printf(const char *fmt, ...)
{
 7d4:	711d                	addi	sp,sp,-96
 7d6:	ec06                	sd	ra,24(sp)
 7d8:	e822                	sd	s0,16(sp)
 7da:	1000                	addi	s0,sp,32
 7dc:	e40c                	sd	a1,8(s0)
 7de:	e810                	sd	a2,16(s0)
 7e0:	ec14                	sd	a3,24(s0)
 7e2:	f018                	sd	a4,32(s0)
 7e4:	f41c                	sd	a5,40(s0)
 7e6:	03043823          	sd	a6,48(s0)
 7ea:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ee:	00840613          	addi	a2,s0,8
 7f2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f6:	85aa                	mv	a1,a0
 7f8:	4505                	li	a0,1
 7fa:	d29ff0ef          	jal	522 <vprintf>
}
 7fe:	60e2                	ld	ra,24(sp)
 800:	6442                	ld	s0,16(sp)
 802:	6125                	addi	sp,sp,96
 804:	8082                	ret

0000000000000806 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 806:	1141                	addi	sp,sp,-16
 808:	e422                	sd	s0,8(sp)
 80a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 80c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 810:	00001797          	auipc	a5,0x1
 814:	8207b783          	ld	a5,-2016(a5) # 1030 <freep>
 818:	a02d                	j	842 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 81a:	4618                	lw	a4,8(a2)
 81c:	9f2d                	addw	a4,a4,a1
 81e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 822:	6398                	ld	a4,0(a5)
 824:	6310                	ld	a2,0(a4)
 826:	a83d                	j	864 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 828:	ff852703          	lw	a4,-8(a0)
 82c:	9f31                	addw	a4,a4,a2
 82e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 830:	ff053683          	ld	a3,-16(a0)
 834:	a091                	j	878 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 836:	6398                	ld	a4,0(a5)
 838:	00e7e463          	bltu	a5,a4,840 <free+0x3a>
 83c:	00e6ea63          	bltu	a3,a4,850 <free+0x4a>
{
 840:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 842:	fed7fae3          	bgeu	a5,a3,836 <free+0x30>
 846:	6398                	ld	a4,0(a5)
 848:	00e6e463          	bltu	a3,a4,850 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84c:	fee7eae3          	bltu	a5,a4,840 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 850:	ff852583          	lw	a1,-8(a0)
 854:	6390                	ld	a2,0(a5)
 856:	02059813          	slli	a6,a1,0x20
 85a:	01c85713          	srli	a4,a6,0x1c
 85e:	9736                	add	a4,a4,a3
 860:	fae60de3          	beq	a2,a4,81a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 864:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 868:	4790                	lw	a2,8(a5)
 86a:	02061593          	slli	a1,a2,0x20
 86e:	01c5d713          	srli	a4,a1,0x1c
 872:	973e                	add	a4,a4,a5
 874:	fae68ae3          	beq	a3,a4,828 <free+0x22>
    p->s.ptr = bp->s.ptr;
 878:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 87a:	00000717          	auipc	a4,0x0
 87e:	7af73b23          	sd	a5,1974(a4) # 1030 <freep>
}
 882:	6422                	ld	s0,8(sp)
 884:	0141                	addi	sp,sp,16
 886:	8082                	ret

0000000000000888 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 888:	7139                	addi	sp,sp,-64
 88a:	fc06                	sd	ra,56(sp)
 88c:	f822                	sd	s0,48(sp)
 88e:	f426                	sd	s1,40(sp)
 890:	ec4e                	sd	s3,24(sp)
 892:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 894:	02051493          	slli	s1,a0,0x20
 898:	9081                	srli	s1,s1,0x20
 89a:	04bd                	addi	s1,s1,15
 89c:	8091                	srli	s1,s1,0x4
 89e:	0014899b          	addiw	s3,s1,1
 8a2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8a4:	00000517          	auipc	a0,0x0
 8a8:	78c53503          	ld	a0,1932(a0) # 1030 <freep>
 8ac:	c915                	beqz	a0,8e0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b0:	4798                	lw	a4,8(a5)
 8b2:	08977a63          	bgeu	a4,s1,946 <malloc+0xbe>
 8b6:	f04a                	sd	s2,32(sp)
 8b8:	e852                	sd	s4,16(sp)
 8ba:	e456                	sd	s5,8(sp)
 8bc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8be:	8a4e                	mv	s4,s3
 8c0:	0009871b          	sext.w	a4,s3
 8c4:	6685                	lui	a3,0x1
 8c6:	00d77363          	bgeu	a4,a3,8cc <malloc+0x44>
 8ca:	6a05                	lui	s4,0x1
 8cc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8d0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d4:	00000917          	auipc	s2,0x0
 8d8:	75c90913          	addi	s2,s2,1884 # 1030 <freep>
  if(p == (char*)-1)
 8dc:	5afd                	li	s5,-1
 8de:	a081                	j	91e <malloc+0x96>
 8e0:	f04a                	sd	s2,32(sp)
 8e2:	e852                	sd	s4,16(sp)
 8e4:	e456                	sd	s5,8(sp)
 8e6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8e8:	00000797          	auipc	a5,0x0
 8ec:	75878793          	addi	a5,a5,1880 # 1040 <base>
 8f0:	00000717          	auipc	a4,0x0
 8f4:	74f73023          	sd	a5,1856(a4) # 1030 <freep>
 8f8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8fa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8fe:	b7c1                	j	8be <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 900:	6398                	ld	a4,0(a5)
 902:	e118                	sd	a4,0(a0)
 904:	a8a9                	j	95e <malloc+0xd6>
  hp->s.size = nu;
 906:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 90a:	0541                	addi	a0,a0,16
 90c:	efbff0ef          	jal	806 <free>
  return freep;
 910:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 914:	c12d                	beqz	a0,976 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 916:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 918:	4798                	lw	a4,8(a5)
 91a:	02977263          	bgeu	a4,s1,93e <malloc+0xb6>
    if(p == freep)
 91e:	00093703          	ld	a4,0(s2)
 922:	853e                	mv	a0,a5
 924:	fef719e3          	bne	a4,a5,916 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 928:	8552                	mv	a0,s4
 92a:	aebff0ef          	jal	414 <sbrk>
  if(p == (char*)-1)
 92e:	fd551ce3          	bne	a0,s5,906 <malloc+0x7e>
        return 0;
 932:	4501                	li	a0,0
 934:	7902                	ld	s2,32(sp)
 936:	6a42                	ld	s4,16(sp)
 938:	6aa2                	ld	s5,8(sp)
 93a:	6b02                	ld	s6,0(sp)
 93c:	a03d                	j	96a <malloc+0xe2>
 93e:	7902                	ld	s2,32(sp)
 940:	6a42                	ld	s4,16(sp)
 942:	6aa2                	ld	s5,8(sp)
 944:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 946:	fae48de3          	beq	s1,a4,900 <malloc+0x78>
        p->s.size -= nunits;
 94a:	4137073b          	subw	a4,a4,s3
 94e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 950:	02071693          	slli	a3,a4,0x20
 954:	01c6d713          	srli	a4,a3,0x1c
 958:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 95a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 95e:	00000717          	auipc	a4,0x0
 962:	6ca73923          	sd	a0,1746(a4) # 1030 <freep>
      return (void*)(p + 1);
 966:	01078513          	addi	a0,a5,16
  }
}
 96a:	70e2                	ld	ra,56(sp)
 96c:	7442                	ld	s0,48(sp)
 96e:	74a2                	ld	s1,40(sp)
 970:	69e2                	ld	s3,24(sp)
 972:	6121                	addi	sp,sp,64
 974:	8082                	ret
 976:	7902                	ld	s2,32(sp)
 978:	6a42                	ld	s4,16(sp)
 97a:	6aa2                	ld	s5,8(sp)
 97c:	6b02                	ld	s6,0(sp)
 97e:	b7f5                	j	96a <malloc+0xe2>
