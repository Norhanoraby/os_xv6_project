
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
  34:	96850513          	addi	a0,a0,-1688 # 998 <malloc+0x108>
  38:	7a4000ef          	jal	7dc <printf>
  printf("================================\n\n");
  3c:	00001517          	auipc	a0,0x1
  40:	98450513          	addi	a0,a0,-1660 # 9c0 <malloc+0x130>
  44:	798000ef          	jal	7dc <printf>
  
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
  6a:	98250513          	addi	a0,a0,-1662 # 9e8 <malloc+0x158>
  6e:	76e000ef          	jal	7dc <printf>
    exit(1);
  72:	4505                	li	a0,1
  74:	318000ef          	jal	38c <exit>
  }
  
  printf("getptable succeeded!\n\n");
  78:	00001517          	auipc	a0,0x1
  7c:	99050513          	addi	a0,a0,-1648 # a08 <malloc+0x178>
  80:	75c000ef          	jal	7dc <printf>
  
  // Print header - simpler format for xv6 printf
  printf("PID  PPID STATE      NAME             SIZE\n");
  84:	00001517          	auipc	a0,0x1
  88:	99c50513          	addi	a0,a0,-1636 # a20 <malloc+0x190>
  8c:	750000ef          	jal	7dc <printf>
  printf("---  ---- -----      ----             ----\n");
  90:	00001517          	auipc	a0,0x1
  94:	9c050513          	addi	a0,a0,-1600 # a50 <malloc+0x1c0>
  98:	744000ef          	jal	7dc <printf>
  
  // Display process information
  for (i = 0; i < MAX_PROC; i++) {
  9c:	74fd                	lui	s1,0xfffff
  9e:	5bc48793          	addi	a5,s1,1468 # fffffffffffff5bc <base+0xffffffffffffe57c>
  a2:	008784b3          	add	s1,a5,s0
  a6:	6785                	lui	a5,0x1
  a8:	a0c78793          	addi	a5,a5,-1524 # a0c <malloc+0x17c>
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
  c2:	8d2a8a93          	addi	s5,s5,-1838 # 990 <malloc+0x100>
        state_str = state_names[ptable[i].state];
      }
      
      // Simple format without width specifiers
      printf("%d\t %d\t %s\t %s\t %d\n",
  c6:	00001a17          	auipc	s4,0x1
  ca:	9baa0a13          	addi	s4,s4,-1606 # a80 <malloc+0x1f0>
        state_str = state_names[ptable[i].state];
  ce:	00001b97          	auipc	s7,0x1
  d2:	f32b8b93          	addi	s7,s7,-206 # 1000 <state_names>
  d6:	a821                	j	ee <main+0xee>
      printf("%d\t %d\t %s\t %s\t %d\n",
  d8:	4b5c                	lw	a5,20(a4)
  da:	ff872603          	lw	a2,-8(a4)
  de:	8552                	mv	a0,s4
  e0:	6fc000ef          	jal	7dc <printf>
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
 114:	98850513          	addi	a0,a0,-1656 # a98 <malloc+0x208>
 118:	6c4000ef          	jal	7dc <printf>
  
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

000000000000044c <random>:
.global random
random:
 li a7, SYS_random
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

000000000000045c <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 45c:	48f1                	li	a7,28
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 464:	1101                	addi	sp,sp,-32
 466:	ec06                	sd	ra,24(sp)
 468:	e822                	sd	s0,16(sp)
 46a:	1000                	addi	s0,sp,32
 46c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 470:	4605                	li	a2,1
 472:	fef40593          	addi	a1,s0,-17
 476:	f37ff0ef          	jal	3ac <write>
}
 47a:	60e2                	ld	ra,24(sp)
 47c:	6442                	ld	s0,16(sp)
 47e:	6105                	addi	sp,sp,32
 480:	8082                	ret

0000000000000482 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 482:	7139                	addi	sp,sp,-64
 484:	fc06                	sd	ra,56(sp)
 486:	f822                	sd	s0,48(sp)
 488:	f426                	sd	s1,40(sp)
 48a:	0080                	addi	s0,sp,64
 48c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 48e:	c299                	beqz	a3,494 <printint+0x12>
 490:	0805c963          	bltz	a1,522 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 494:	2581                	sext.w	a1,a1
  neg = 0;
 496:	4881                	li	a7,0
 498:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 49c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 49e:	2601                	sext.w	a2,a2
 4a0:	00000517          	auipc	a0,0x0
 4a4:	65850513          	addi	a0,a0,1624 # af8 <digits>
 4a8:	883a                	mv	a6,a4
 4aa:	2705                	addiw	a4,a4,1
 4ac:	02c5f7bb          	remuw	a5,a1,a2
 4b0:	1782                	slli	a5,a5,0x20
 4b2:	9381                	srli	a5,a5,0x20
 4b4:	97aa                	add	a5,a5,a0
 4b6:	0007c783          	lbu	a5,0(a5)
 4ba:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4be:	0005879b          	sext.w	a5,a1
 4c2:	02c5d5bb          	divuw	a1,a1,a2
 4c6:	0685                	addi	a3,a3,1
 4c8:	fec7f0e3          	bgeu	a5,a2,4a8 <printint+0x26>
  if(neg)
 4cc:	00088c63          	beqz	a7,4e4 <printint+0x62>
    buf[i++] = '-';
 4d0:	fd070793          	addi	a5,a4,-48
 4d4:	00878733          	add	a4,a5,s0
 4d8:	02d00793          	li	a5,45
 4dc:	fef70823          	sb	a5,-16(a4)
 4e0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4e4:	02e05a63          	blez	a4,518 <printint+0x96>
 4e8:	f04a                	sd	s2,32(sp)
 4ea:	ec4e                	sd	s3,24(sp)
 4ec:	fc040793          	addi	a5,s0,-64
 4f0:	00e78933          	add	s2,a5,a4
 4f4:	fff78993          	addi	s3,a5,-1
 4f8:	99ba                	add	s3,s3,a4
 4fa:	377d                	addiw	a4,a4,-1
 4fc:	1702                	slli	a4,a4,0x20
 4fe:	9301                	srli	a4,a4,0x20
 500:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 504:	fff94583          	lbu	a1,-1(s2)
 508:	8526                	mv	a0,s1
 50a:	f5bff0ef          	jal	464 <putc>
  while(--i >= 0)
 50e:	197d                	addi	s2,s2,-1
 510:	ff391ae3          	bne	s2,s3,504 <printint+0x82>
 514:	7902                	ld	s2,32(sp)
 516:	69e2                	ld	s3,24(sp)
}
 518:	70e2                	ld	ra,56(sp)
 51a:	7442                	ld	s0,48(sp)
 51c:	74a2                	ld	s1,40(sp)
 51e:	6121                	addi	sp,sp,64
 520:	8082                	ret
    x = -xx;
 522:	40b005bb          	negw	a1,a1
    neg = 1;
 526:	4885                	li	a7,1
    x = -xx;
 528:	bf85                	j	498 <printint+0x16>

000000000000052a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 52a:	711d                	addi	sp,sp,-96
 52c:	ec86                	sd	ra,88(sp)
 52e:	e8a2                	sd	s0,80(sp)
 530:	e0ca                	sd	s2,64(sp)
 532:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 534:	0005c903          	lbu	s2,0(a1)
 538:	26090863          	beqz	s2,7a8 <vprintf+0x27e>
 53c:	e4a6                	sd	s1,72(sp)
 53e:	fc4e                	sd	s3,56(sp)
 540:	f852                	sd	s4,48(sp)
 542:	f456                	sd	s5,40(sp)
 544:	f05a                	sd	s6,32(sp)
 546:	ec5e                	sd	s7,24(sp)
 548:	e862                	sd	s8,16(sp)
 54a:	e466                	sd	s9,8(sp)
 54c:	8b2a                	mv	s6,a0
 54e:	8a2e                	mv	s4,a1
 550:	8bb2                	mv	s7,a2
  state = 0;
 552:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 554:	4481                	li	s1,0
 556:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 558:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 55c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 560:	06c00c93          	li	s9,108
 564:	a005                	j	584 <vprintf+0x5a>
        putc(fd, c0);
 566:	85ca                	mv	a1,s2
 568:	855a                	mv	a0,s6
 56a:	efbff0ef          	jal	464 <putc>
 56e:	a019                	j	574 <vprintf+0x4a>
    } else if(state == '%'){
 570:	03598263          	beq	s3,s5,594 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 574:	2485                	addiw	s1,s1,1
 576:	8726                	mv	a4,s1
 578:	009a07b3          	add	a5,s4,s1
 57c:	0007c903          	lbu	s2,0(a5)
 580:	20090c63          	beqz	s2,798 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 584:	0009079b          	sext.w	a5,s2
    if(state == 0){
 588:	fe0994e3          	bnez	s3,570 <vprintf+0x46>
      if(c0 == '%'){
 58c:	fd579de3          	bne	a5,s5,566 <vprintf+0x3c>
        state = '%';
 590:	89be                	mv	s3,a5
 592:	b7cd                	j	574 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 594:	00ea06b3          	add	a3,s4,a4
 598:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 59c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 59e:	c681                	beqz	a3,5a6 <vprintf+0x7c>
 5a0:	9752                	add	a4,a4,s4
 5a2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5a6:	03878f63          	beq	a5,s8,5e4 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5aa:	05978963          	beq	a5,s9,5fc <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5ae:	07500713          	li	a4,117
 5b2:	0ee78363          	beq	a5,a4,698 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5b6:	07800713          	li	a4,120
 5ba:	12e78563          	beq	a5,a4,6e4 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5be:	07000713          	li	a4,112
 5c2:	14e78a63          	beq	a5,a4,716 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5c6:	07300713          	li	a4,115
 5ca:	18e78a63          	beq	a5,a4,75e <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5ce:	02500713          	li	a4,37
 5d2:	04e79563          	bne	a5,a4,61c <vprintf+0xf2>
        putc(fd, '%');
 5d6:	02500593          	li	a1,37
 5da:	855a                	mv	a0,s6
 5dc:	e89ff0ef          	jal	464 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	bf49                	j	574 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5e4:	008b8913          	addi	s2,s7,8
 5e8:	4685                	li	a3,1
 5ea:	4629                	li	a2,10
 5ec:	000ba583          	lw	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	e91ff0ef          	jal	482 <printint>
 5f6:	8bca                	mv	s7,s2
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	bfad                	j	574 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5fc:	06400793          	li	a5,100
 600:	02f68963          	beq	a3,a5,632 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 604:	06c00793          	li	a5,108
 608:	04f68263          	beq	a3,a5,64c <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 60c:	07500793          	li	a5,117
 610:	0af68063          	beq	a3,a5,6b0 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 614:	07800793          	li	a5,120
 618:	0ef68263          	beq	a3,a5,6fc <vprintf+0x1d2>
        putc(fd, '%');
 61c:	02500593          	li	a1,37
 620:	855a                	mv	a0,s6
 622:	e43ff0ef          	jal	464 <putc>
        putc(fd, c0);
 626:	85ca                	mv	a1,s2
 628:	855a                	mv	a0,s6
 62a:	e3bff0ef          	jal	464 <putc>
      state = 0;
 62e:	4981                	li	s3,0
 630:	b791                	j	574 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 632:	008b8913          	addi	s2,s7,8
 636:	4685                	li	a3,1
 638:	4629                	li	a2,10
 63a:	000ba583          	lw	a1,0(s7)
 63e:	855a                	mv	a0,s6
 640:	e43ff0ef          	jal	482 <printint>
        i += 1;
 644:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 646:	8bca                	mv	s7,s2
      state = 0;
 648:	4981                	li	s3,0
        i += 1;
 64a:	b72d                	j	574 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 64c:	06400793          	li	a5,100
 650:	02f60763          	beq	a2,a5,67e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 654:	07500793          	li	a5,117
 658:	06f60963          	beq	a2,a5,6ca <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 65c:	07800793          	li	a5,120
 660:	faf61ee3          	bne	a2,a5,61c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 664:	008b8913          	addi	s2,s7,8
 668:	4681                	li	a3,0
 66a:	4641                	li	a2,16
 66c:	000ba583          	lw	a1,0(s7)
 670:	855a                	mv	a0,s6
 672:	e11ff0ef          	jal	482 <printint>
        i += 2;
 676:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 678:	8bca                	mv	s7,s2
      state = 0;
 67a:	4981                	li	s3,0
        i += 2;
 67c:	bde5                	j	574 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 67e:	008b8913          	addi	s2,s7,8
 682:	4685                	li	a3,1
 684:	4629                	li	a2,10
 686:	000ba583          	lw	a1,0(s7)
 68a:	855a                	mv	a0,s6
 68c:	df7ff0ef          	jal	482 <printint>
        i += 2;
 690:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 692:	8bca                	mv	s7,s2
      state = 0;
 694:	4981                	li	s3,0
        i += 2;
 696:	bdf9                	j	574 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 698:	008b8913          	addi	s2,s7,8
 69c:	4681                	li	a3,0
 69e:	4629                	li	a2,10
 6a0:	000ba583          	lw	a1,0(s7)
 6a4:	855a                	mv	a0,s6
 6a6:	dddff0ef          	jal	482 <printint>
 6aa:	8bca                	mv	s7,s2
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	b5d9                	j	574 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b0:	008b8913          	addi	s2,s7,8
 6b4:	4681                	li	a3,0
 6b6:	4629                	li	a2,10
 6b8:	000ba583          	lw	a1,0(s7)
 6bc:	855a                	mv	a0,s6
 6be:	dc5ff0ef          	jal	482 <printint>
        i += 1;
 6c2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c4:	8bca                	mv	s7,s2
      state = 0;
 6c6:	4981                	li	s3,0
        i += 1;
 6c8:	b575                	j	574 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ca:	008b8913          	addi	s2,s7,8
 6ce:	4681                	li	a3,0
 6d0:	4629                	li	a2,10
 6d2:	000ba583          	lw	a1,0(s7)
 6d6:	855a                	mv	a0,s6
 6d8:	dabff0ef          	jal	482 <printint>
        i += 2;
 6dc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6de:	8bca                	mv	s7,s2
      state = 0;
 6e0:	4981                	li	s3,0
        i += 2;
 6e2:	bd49                	j	574 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6e4:	008b8913          	addi	s2,s7,8
 6e8:	4681                	li	a3,0
 6ea:	4641                	li	a2,16
 6ec:	000ba583          	lw	a1,0(s7)
 6f0:	855a                	mv	a0,s6
 6f2:	d91ff0ef          	jal	482 <printint>
 6f6:	8bca                	mv	s7,s2
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	bdad                	j	574 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fc:	008b8913          	addi	s2,s7,8
 700:	4681                	li	a3,0
 702:	4641                	li	a2,16
 704:	000ba583          	lw	a1,0(s7)
 708:	855a                	mv	a0,s6
 70a:	d79ff0ef          	jal	482 <printint>
        i += 1;
 70e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 710:	8bca                	mv	s7,s2
      state = 0;
 712:	4981                	li	s3,0
        i += 1;
 714:	b585                	j	574 <vprintf+0x4a>
 716:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 718:	008b8d13          	addi	s10,s7,8
 71c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 720:	03000593          	li	a1,48
 724:	855a                	mv	a0,s6
 726:	d3fff0ef          	jal	464 <putc>
  putc(fd, 'x');
 72a:	07800593          	li	a1,120
 72e:	855a                	mv	a0,s6
 730:	d35ff0ef          	jal	464 <putc>
 734:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 736:	00000b97          	auipc	s7,0x0
 73a:	3c2b8b93          	addi	s7,s7,962 # af8 <digits>
 73e:	03c9d793          	srli	a5,s3,0x3c
 742:	97de                	add	a5,a5,s7
 744:	0007c583          	lbu	a1,0(a5)
 748:	855a                	mv	a0,s6
 74a:	d1bff0ef          	jal	464 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 74e:	0992                	slli	s3,s3,0x4
 750:	397d                	addiw	s2,s2,-1
 752:	fe0916e3          	bnez	s2,73e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 756:	8bea                	mv	s7,s10
      state = 0;
 758:	4981                	li	s3,0
 75a:	6d02                	ld	s10,0(sp)
 75c:	bd21                	j	574 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 75e:	008b8993          	addi	s3,s7,8
 762:	000bb903          	ld	s2,0(s7)
 766:	00090f63          	beqz	s2,784 <vprintf+0x25a>
        for(; *s; s++)
 76a:	00094583          	lbu	a1,0(s2)
 76e:	c195                	beqz	a1,792 <vprintf+0x268>
          putc(fd, *s);
 770:	855a                	mv	a0,s6
 772:	cf3ff0ef          	jal	464 <putc>
        for(; *s; s++)
 776:	0905                	addi	s2,s2,1
 778:	00094583          	lbu	a1,0(s2)
 77c:	f9f5                	bnez	a1,770 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 77e:	8bce                	mv	s7,s3
      state = 0;
 780:	4981                	li	s3,0
 782:	bbcd                	j	574 <vprintf+0x4a>
          s = "(null)";
 784:	00000917          	auipc	s2,0x0
 788:	36c90913          	addi	s2,s2,876 # af0 <malloc+0x260>
        for(; *s; s++)
 78c:	02800593          	li	a1,40
 790:	b7c5                	j	770 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 792:	8bce                	mv	s7,s3
      state = 0;
 794:	4981                	li	s3,0
 796:	bbf9                	j	574 <vprintf+0x4a>
 798:	64a6                	ld	s1,72(sp)
 79a:	79e2                	ld	s3,56(sp)
 79c:	7a42                	ld	s4,48(sp)
 79e:	7aa2                	ld	s5,40(sp)
 7a0:	7b02                	ld	s6,32(sp)
 7a2:	6be2                	ld	s7,24(sp)
 7a4:	6c42                	ld	s8,16(sp)
 7a6:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7a8:	60e6                	ld	ra,88(sp)
 7aa:	6446                	ld	s0,80(sp)
 7ac:	6906                	ld	s2,64(sp)
 7ae:	6125                	addi	sp,sp,96
 7b0:	8082                	ret

00000000000007b2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b2:	715d                	addi	sp,sp,-80
 7b4:	ec06                	sd	ra,24(sp)
 7b6:	e822                	sd	s0,16(sp)
 7b8:	1000                	addi	s0,sp,32
 7ba:	e010                	sd	a2,0(s0)
 7bc:	e414                	sd	a3,8(s0)
 7be:	e818                	sd	a4,16(s0)
 7c0:	ec1c                	sd	a5,24(s0)
 7c2:	03043023          	sd	a6,32(s0)
 7c6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ca:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ce:	8622                	mv	a2,s0
 7d0:	d5bff0ef          	jal	52a <vprintf>
}
 7d4:	60e2                	ld	ra,24(sp)
 7d6:	6442                	ld	s0,16(sp)
 7d8:	6161                	addi	sp,sp,80
 7da:	8082                	ret

00000000000007dc <printf>:

void
printf(const char *fmt, ...)
{
 7dc:	711d                	addi	sp,sp,-96
 7de:	ec06                	sd	ra,24(sp)
 7e0:	e822                	sd	s0,16(sp)
 7e2:	1000                	addi	s0,sp,32
 7e4:	e40c                	sd	a1,8(s0)
 7e6:	e810                	sd	a2,16(s0)
 7e8:	ec14                	sd	a3,24(s0)
 7ea:	f018                	sd	a4,32(s0)
 7ec:	f41c                	sd	a5,40(s0)
 7ee:	03043823          	sd	a6,48(s0)
 7f2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7f6:	00840613          	addi	a2,s0,8
 7fa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7fe:	85aa                	mv	a1,a0
 800:	4505                	li	a0,1
 802:	d29ff0ef          	jal	52a <vprintf>
}
 806:	60e2                	ld	ra,24(sp)
 808:	6442                	ld	s0,16(sp)
 80a:	6125                	addi	sp,sp,96
 80c:	8082                	ret

000000000000080e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 80e:	1141                	addi	sp,sp,-16
 810:	e422                	sd	s0,8(sp)
 812:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 814:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 818:	00001797          	auipc	a5,0x1
 81c:	8187b783          	ld	a5,-2024(a5) # 1030 <freep>
 820:	a02d                	j	84a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 822:	4618                	lw	a4,8(a2)
 824:	9f2d                	addw	a4,a4,a1
 826:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 82a:	6398                	ld	a4,0(a5)
 82c:	6310                	ld	a2,0(a4)
 82e:	a83d                	j	86c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 830:	ff852703          	lw	a4,-8(a0)
 834:	9f31                	addw	a4,a4,a2
 836:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 838:	ff053683          	ld	a3,-16(a0)
 83c:	a091                	j	880 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83e:	6398                	ld	a4,0(a5)
 840:	00e7e463          	bltu	a5,a4,848 <free+0x3a>
 844:	00e6ea63          	bltu	a3,a4,858 <free+0x4a>
{
 848:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84a:	fed7fae3          	bgeu	a5,a3,83e <free+0x30>
 84e:	6398                	ld	a4,0(a5)
 850:	00e6e463          	bltu	a3,a4,858 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 854:	fee7eae3          	bltu	a5,a4,848 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 858:	ff852583          	lw	a1,-8(a0)
 85c:	6390                	ld	a2,0(a5)
 85e:	02059813          	slli	a6,a1,0x20
 862:	01c85713          	srli	a4,a6,0x1c
 866:	9736                	add	a4,a4,a3
 868:	fae60de3          	beq	a2,a4,822 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 86c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 870:	4790                	lw	a2,8(a5)
 872:	02061593          	slli	a1,a2,0x20
 876:	01c5d713          	srli	a4,a1,0x1c
 87a:	973e                	add	a4,a4,a5
 87c:	fae68ae3          	beq	a3,a4,830 <free+0x22>
    p->s.ptr = bp->s.ptr;
 880:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 882:	00000717          	auipc	a4,0x0
 886:	7af73723          	sd	a5,1966(a4) # 1030 <freep>
}
 88a:	6422                	ld	s0,8(sp)
 88c:	0141                	addi	sp,sp,16
 88e:	8082                	ret

0000000000000890 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 890:	7139                	addi	sp,sp,-64
 892:	fc06                	sd	ra,56(sp)
 894:	f822                	sd	s0,48(sp)
 896:	f426                	sd	s1,40(sp)
 898:	ec4e                	sd	s3,24(sp)
 89a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 89c:	02051493          	slli	s1,a0,0x20
 8a0:	9081                	srli	s1,s1,0x20
 8a2:	04bd                	addi	s1,s1,15
 8a4:	8091                	srli	s1,s1,0x4
 8a6:	0014899b          	addiw	s3,s1,1
 8aa:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8ac:	00000517          	auipc	a0,0x0
 8b0:	78453503          	ld	a0,1924(a0) # 1030 <freep>
 8b4:	c915                	beqz	a0,8e8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b8:	4798                	lw	a4,8(a5)
 8ba:	08977a63          	bgeu	a4,s1,94e <malloc+0xbe>
 8be:	f04a                	sd	s2,32(sp)
 8c0:	e852                	sd	s4,16(sp)
 8c2:	e456                	sd	s5,8(sp)
 8c4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8c6:	8a4e                	mv	s4,s3
 8c8:	0009871b          	sext.w	a4,s3
 8cc:	6685                	lui	a3,0x1
 8ce:	00d77363          	bgeu	a4,a3,8d4 <malloc+0x44>
 8d2:	6a05                	lui	s4,0x1
 8d4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8d8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8dc:	00000917          	auipc	s2,0x0
 8e0:	75490913          	addi	s2,s2,1876 # 1030 <freep>
  if(p == (char*)-1)
 8e4:	5afd                	li	s5,-1
 8e6:	a081                	j	926 <malloc+0x96>
 8e8:	f04a                	sd	s2,32(sp)
 8ea:	e852                	sd	s4,16(sp)
 8ec:	e456                	sd	s5,8(sp)
 8ee:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8f0:	00000797          	auipc	a5,0x0
 8f4:	75078793          	addi	a5,a5,1872 # 1040 <base>
 8f8:	00000717          	auipc	a4,0x0
 8fc:	72f73c23          	sd	a5,1848(a4) # 1030 <freep>
 900:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 902:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 906:	b7c1                	j	8c6 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 908:	6398                	ld	a4,0(a5)
 90a:	e118                	sd	a4,0(a0)
 90c:	a8a9                	j	966 <malloc+0xd6>
  hp->s.size = nu;
 90e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 912:	0541                	addi	a0,a0,16
 914:	efbff0ef          	jal	80e <free>
  return freep;
 918:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 91c:	c12d                	beqz	a0,97e <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 920:	4798                	lw	a4,8(a5)
 922:	02977263          	bgeu	a4,s1,946 <malloc+0xb6>
    if(p == freep)
 926:	00093703          	ld	a4,0(s2)
 92a:	853e                	mv	a0,a5
 92c:	fef719e3          	bne	a4,a5,91e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 930:	8552                	mv	a0,s4
 932:	ae3ff0ef          	jal	414 <sbrk>
  if(p == (char*)-1)
 936:	fd551ce3          	bne	a0,s5,90e <malloc+0x7e>
        return 0;
 93a:	4501                	li	a0,0
 93c:	7902                	ld	s2,32(sp)
 93e:	6a42                	ld	s4,16(sp)
 940:	6aa2                	ld	s5,8(sp)
 942:	6b02                	ld	s6,0(sp)
 944:	a03d                	j	972 <malloc+0xe2>
 946:	7902                	ld	s2,32(sp)
 948:	6a42                	ld	s4,16(sp)
 94a:	6aa2                	ld	s5,8(sp)
 94c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 94e:	fae48de3          	beq	s1,a4,908 <malloc+0x78>
        p->s.size -= nunits;
 952:	4137073b          	subw	a4,a4,s3
 956:	c798                	sw	a4,8(a5)
        p += p->s.size;
 958:	02071693          	slli	a3,a4,0x20
 95c:	01c6d713          	srli	a4,a3,0x1c
 960:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 962:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 966:	00000717          	auipc	a4,0x0
 96a:	6ca73523          	sd	a0,1738(a4) # 1030 <freep>
      return (void*)(p + 1);
 96e:	01078513          	addi	a0,a5,16
  }
}
 972:	70e2                	ld	ra,56(sp)
 974:	7442                	ld	s0,48(sp)
 976:	74a2                	ld	s1,40(sp)
 978:	69e2                	ld	s3,24(sp)
 97a:	6121                	addi	sp,sp,64
 97c:	8082                	ret
 97e:	7902                	ld	s2,32(sp)
 980:	6a42                	ld	s4,16(sp)
 982:	6aa2                	ld	s5,8(sp)
 984:	6b02                	ld	s6,0(sp)
 986:	b7f5                	j	972 <malloc+0xe2>
