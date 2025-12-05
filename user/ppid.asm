
user/_ppid:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  printf("My PID: %d\n", getpid());
   8:	386000ef          	jal	38e <getpid>
   c:	85aa                	mv	a1,a0
   e:	00001517          	auipc	a0,0x1
  12:	90250513          	addi	a0,a0,-1790 # 910 <malloc+0x106>
  16:	740000ef          	jal	756 <printf>
  printf("My parent's PID: %d\n", getppid());
  1a:	3a4000ef          	jal	3be <getppid>
  1e:	85aa                	mv	a1,a0
  20:	00001517          	auipc	a0,0x1
  24:	90050513          	addi	a0,a0,-1792 # 920 <malloc+0x116>
  28:	72e000ef          	jal	756 <printf>
  
  int pid = fork();
  2c:	2da000ef          	jal	306 <fork>
  if(pid == 0) {
  30:	ed05                	bnez	a0,68 <main+0x68>
    // Child process
    printf("\nChild process:\n");
  32:	00001517          	auipc	a0,0x1
  36:	90650513          	addi	a0,a0,-1786 # 938 <malloc+0x12e>
  3a:	71c000ef          	jal	756 <printf>
    printf("  My PID: %d\n", getpid());
  3e:	350000ef          	jal	38e <getpid>
  42:	85aa                	mv	a1,a0
  44:	00001517          	auipc	a0,0x1
  48:	90c50513          	addi	a0,a0,-1780 # 950 <malloc+0x146>
  4c:	70a000ef          	jal	756 <printf>
    printf("  My parent's PID: %d\n", getppid());
  50:	36e000ef          	jal	3be <getppid>
  54:	85aa                	mv	a1,a0
  56:	00001517          	auipc	a0,0x1
  5a:	90a50513          	addi	a0,a0,-1782 # 960 <malloc+0x156>
  5e:	6f8000ef          	jal	756 <printf>
    exit(0);
  62:	4501                	li	a0,0
  64:	2aa000ef          	jal	30e <exit>
  } else {
    // Parent process
    wait(0);
  68:	4501                	li	a0,0
  6a:	2ac000ef          	jal	316 <wait>
    printf("\nParent after child exits:\n");
  6e:	00001517          	auipc	a0,0x1
  72:	90a50513          	addi	a0,a0,-1782 # 978 <malloc+0x16e>
  76:	6e0000ef          	jal	756 <printf>
    printf("  My PID: %d\n", getpid());
  7a:	314000ef          	jal	38e <getpid>
  7e:	85aa                	mv	a1,a0
  80:	00001517          	auipc	a0,0x1
  84:	8d050513          	addi	a0,a0,-1840 # 950 <malloc+0x146>
  88:	6ce000ef          	jal	756 <printf>
    printf("  My parent's PID: %d\n", getppid());
  8c:	332000ef          	jal	3be <getppid>
  90:	85aa                	mv	a1,a0
  92:	00001517          	auipc	a0,0x1
  96:	8ce50513          	addi	a0,a0,-1842 # 960 <malloc+0x156>
  9a:	6bc000ef          	jal	756 <printf>
  }
  
  exit(0);
  9e:	4501                	li	a0,0
  a0:	26e000ef          	jal	30e <exit>

00000000000000a4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  a4:	1141                	addi	sp,sp,-16
  a6:	e406                	sd	ra,8(sp)
  a8:	e022                	sd	s0,0(sp)
  aa:	0800                	addi	s0,sp,16
  extern int main();
  main();
  ac:	f55ff0ef          	jal	0 <main>
  exit(0);
  b0:	4501                	li	a0,0
  b2:	25c000ef          	jal	30e <exit>

00000000000000b6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  bc:	87aa                	mv	a5,a0
  be:	0585                	addi	a1,a1,1
  c0:	0785                	addi	a5,a5,1
  c2:	fff5c703          	lbu	a4,-1(a1)
  c6:	fee78fa3          	sb	a4,-1(a5)
  ca:	fb75                	bnez	a4,be <strcpy+0x8>
    ;
  return os;
}
  cc:	6422                	ld	s0,8(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret

00000000000000d2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  d8:	00054783          	lbu	a5,0(a0)
  dc:	cb91                	beqz	a5,f0 <strcmp+0x1e>
  de:	0005c703          	lbu	a4,0(a1)
  e2:	00f71763          	bne	a4,a5,f0 <strcmp+0x1e>
    p++, q++;
  e6:	0505                	addi	a0,a0,1
  e8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ea:	00054783          	lbu	a5,0(a0)
  ee:	fbe5                	bnez	a5,de <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  f0:	0005c503          	lbu	a0,0(a1)
}
  f4:	40a7853b          	subw	a0,a5,a0
  f8:	6422                	ld	s0,8(sp)
  fa:	0141                	addi	sp,sp,16
  fc:	8082                	ret

00000000000000fe <strlen>:

uint
strlen(const char *s)
{
  fe:	1141                	addi	sp,sp,-16
 100:	e422                	sd	s0,8(sp)
 102:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 104:	00054783          	lbu	a5,0(a0)
 108:	cf91                	beqz	a5,124 <strlen+0x26>
 10a:	0505                	addi	a0,a0,1
 10c:	87aa                	mv	a5,a0
 10e:	86be                	mv	a3,a5
 110:	0785                	addi	a5,a5,1
 112:	fff7c703          	lbu	a4,-1(a5)
 116:	ff65                	bnez	a4,10e <strlen+0x10>
 118:	40a6853b          	subw	a0,a3,a0
 11c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 11e:	6422                	ld	s0,8(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret
  for(n = 0; s[n]; n++)
 124:	4501                	li	a0,0
 126:	bfe5                	j	11e <strlen+0x20>

0000000000000128 <memset>:

void*
memset(void *dst, int c, uint n)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e422                	sd	s0,8(sp)
 12c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 12e:	ca19                	beqz	a2,144 <memset+0x1c>
 130:	87aa                	mv	a5,a0
 132:	1602                	slli	a2,a2,0x20
 134:	9201                	srli	a2,a2,0x20
 136:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 13a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 13e:	0785                	addi	a5,a5,1
 140:	fee79de3          	bne	a5,a4,13a <memset+0x12>
  }
  return dst;
}
 144:	6422                	ld	s0,8(sp)
 146:	0141                	addi	sp,sp,16
 148:	8082                	ret

000000000000014a <strchr>:

char*
strchr(const char *s, char c)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e422                	sd	s0,8(sp)
 14e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 150:	00054783          	lbu	a5,0(a0)
 154:	cb99                	beqz	a5,16a <strchr+0x20>
    if(*s == c)
 156:	00f58763          	beq	a1,a5,164 <strchr+0x1a>
  for(; *s; s++)
 15a:	0505                	addi	a0,a0,1
 15c:	00054783          	lbu	a5,0(a0)
 160:	fbfd                	bnez	a5,156 <strchr+0xc>
      return (char*)s;
  return 0;
 162:	4501                	li	a0,0
}
 164:	6422                	ld	s0,8(sp)
 166:	0141                	addi	sp,sp,16
 168:	8082                	ret
  return 0;
 16a:	4501                	li	a0,0
 16c:	bfe5                	j	164 <strchr+0x1a>

000000000000016e <gets>:

char*
gets(char *buf, int max)
{
 16e:	711d                	addi	sp,sp,-96
 170:	ec86                	sd	ra,88(sp)
 172:	e8a2                	sd	s0,80(sp)
 174:	e4a6                	sd	s1,72(sp)
 176:	e0ca                	sd	s2,64(sp)
 178:	fc4e                	sd	s3,56(sp)
 17a:	f852                	sd	s4,48(sp)
 17c:	f456                	sd	s5,40(sp)
 17e:	f05a                	sd	s6,32(sp)
 180:	ec5e                	sd	s7,24(sp)
 182:	1080                	addi	s0,sp,96
 184:	8baa                	mv	s7,a0
 186:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 188:	892a                	mv	s2,a0
 18a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 18c:	4aa9                	li	s5,10
 18e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 190:	89a6                	mv	s3,s1
 192:	2485                	addiw	s1,s1,1
 194:	0344d663          	bge	s1,s4,1c0 <gets+0x52>
    cc = read(0, &c, 1);
 198:	4605                	li	a2,1
 19a:	faf40593          	addi	a1,s0,-81
 19e:	4501                	li	a0,0
 1a0:	186000ef          	jal	326 <read>
    if(cc < 1)
 1a4:	00a05e63          	blez	a0,1c0 <gets+0x52>
    buf[i++] = c;
 1a8:	faf44783          	lbu	a5,-81(s0)
 1ac:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1b0:	01578763          	beq	a5,s5,1be <gets+0x50>
 1b4:	0905                	addi	s2,s2,1
 1b6:	fd679de3          	bne	a5,s6,190 <gets+0x22>
    buf[i++] = c;
 1ba:	89a6                	mv	s3,s1
 1bc:	a011                	j	1c0 <gets+0x52>
 1be:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1c0:	99de                	add	s3,s3,s7
 1c2:	00098023          	sb	zero,0(s3)
  return buf;
}
 1c6:	855e                	mv	a0,s7
 1c8:	60e6                	ld	ra,88(sp)
 1ca:	6446                	ld	s0,80(sp)
 1cc:	64a6                	ld	s1,72(sp)
 1ce:	6906                	ld	s2,64(sp)
 1d0:	79e2                	ld	s3,56(sp)
 1d2:	7a42                	ld	s4,48(sp)
 1d4:	7aa2                	ld	s5,40(sp)
 1d6:	7b02                	ld	s6,32(sp)
 1d8:	6be2                	ld	s7,24(sp)
 1da:	6125                	addi	sp,sp,96
 1dc:	8082                	ret

00000000000001de <stat>:

int
stat(const char *n, struct stat *st)
{
 1de:	1101                	addi	sp,sp,-32
 1e0:	ec06                	sd	ra,24(sp)
 1e2:	e822                	sd	s0,16(sp)
 1e4:	e04a                	sd	s2,0(sp)
 1e6:	1000                	addi	s0,sp,32
 1e8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ea:	4581                	li	a1,0
 1ec:	162000ef          	jal	34e <open>
  if(fd < 0)
 1f0:	02054263          	bltz	a0,214 <stat+0x36>
 1f4:	e426                	sd	s1,8(sp)
 1f6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f8:	85ca                	mv	a1,s2
 1fa:	16c000ef          	jal	366 <fstat>
 1fe:	892a                	mv	s2,a0
  close(fd);
 200:	8526                	mv	a0,s1
 202:	134000ef          	jal	336 <close>
  return r;
 206:	64a2                	ld	s1,8(sp)
}
 208:	854a                	mv	a0,s2
 20a:	60e2                	ld	ra,24(sp)
 20c:	6442                	ld	s0,16(sp)
 20e:	6902                	ld	s2,0(sp)
 210:	6105                	addi	sp,sp,32
 212:	8082                	ret
    return -1;
 214:	597d                	li	s2,-1
 216:	bfcd                	j	208 <stat+0x2a>

0000000000000218 <atoi>:

int
atoi(const char *s)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21e:	00054683          	lbu	a3,0(a0)
 222:	fd06879b          	addiw	a5,a3,-48
 226:	0ff7f793          	zext.b	a5,a5
 22a:	4625                	li	a2,9
 22c:	02f66863          	bltu	a2,a5,25c <atoi+0x44>
 230:	872a                	mv	a4,a0
  n = 0;
 232:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 234:	0705                	addi	a4,a4,1
 236:	0025179b          	slliw	a5,a0,0x2
 23a:	9fa9                	addw	a5,a5,a0
 23c:	0017979b          	slliw	a5,a5,0x1
 240:	9fb5                	addw	a5,a5,a3
 242:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 246:	00074683          	lbu	a3,0(a4)
 24a:	fd06879b          	addiw	a5,a3,-48
 24e:	0ff7f793          	zext.b	a5,a5
 252:	fef671e3          	bgeu	a2,a5,234 <atoi+0x1c>
  return n;
}
 256:	6422                	ld	s0,8(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret
  n = 0;
 25c:	4501                	li	a0,0
 25e:	bfe5                	j	256 <atoi+0x3e>

0000000000000260 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 260:	1141                	addi	sp,sp,-16
 262:	e422                	sd	s0,8(sp)
 264:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 266:	02b57463          	bgeu	a0,a1,28e <memmove+0x2e>
    while(n-- > 0)
 26a:	00c05f63          	blez	a2,288 <memmove+0x28>
 26e:	1602                	slli	a2,a2,0x20
 270:	9201                	srli	a2,a2,0x20
 272:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 276:	872a                	mv	a4,a0
      *dst++ = *src++;
 278:	0585                	addi	a1,a1,1
 27a:	0705                	addi	a4,a4,1
 27c:	fff5c683          	lbu	a3,-1(a1)
 280:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 284:	fef71ae3          	bne	a4,a5,278 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 288:	6422                	ld	s0,8(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret
    dst += n;
 28e:	00c50733          	add	a4,a0,a2
    src += n;
 292:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 294:	fec05ae3          	blez	a2,288 <memmove+0x28>
 298:	fff6079b          	addiw	a5,a2,-1
 29c:	1782                	slli	a5,a5,0x20
 29e:	9381                	srli	a5,a5,0x20
 2a0:	fff7c793          	not	a5,a5
 2a4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2a6:	15fd                	addi	a1,a1,-1
 2a8:	177d                	addi	a4,a4,-1
 2aa:	0005c683          	lbu	a3,0(a1)
 2ae:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2b2:	fee79ae3          	bne	a5,a4,2a6 <memmove+0x46>
 2b6:	bfc9                	j	288 <memmove+0x28>

00000000000002b8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e422                	sd	s0,8(sp)
 2bc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2be:	ca05                	beqz	a2,2ee <memcmp+0x36>
 2c0:	fff6069b          	addiw	a3,a2,-1
 2c4:	1682                	slli	a3,a3,0x20
 2c6:	9281                	srli	a3,a3,0x20
 2c8:	0685                	addi	a3,a3,1
 2ca:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2cc:	00054783          	lbu	a5,0(a0)
 2d0:	0005c703          	lbu	a4,0(a1)
 2d4:	00e79863          	bne	a5,a4,2e4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2d8:	0505                	addi	a0,a0,1
    p2++;
 2da:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2dc:	fed518e3          	bne	a0,a3,2cc <memcmp+0x14>
  }
  return 0;
 2e0:	4501                	li	a0,0
 2e2:	a019                	j	2e8 <memcmp+0x30>
      return *p1 - *p2;
 2e4:	40e7853b          	subw	a0,a5,a4
}
 2e8:	6422                	ld	s0,8(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret
  return 0;
 2ee:	4501                	li	a0,0
 2f0:	bfe5                	j	2e8 <memcmp+0x30>

00000000000002f2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e406                	sd	ra,8(sp)
 2f6:	e022                	sd	s0,0(sp)
 2f8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2fa:	f67ff0ef          	jal	260 <memmove>
}
 2fe:	60a2                	ld	ra,8(sp)
 300:	6402                	ld	s0,0(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret

0000000000000306 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 306:	4885                	li	a7,1
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <exit>:
.global exit
exit:
 li a7, SYS_exit
 30e:	4889                	li	a7,2
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <wait>:
.global wait
wait:
 li a7, SYS_wait
 316:	488d                	li	a7,3
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 31e:	4891                	li	a7,4
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <read>:
.global read
read:
 li a7, SYS_read
 326:	4895                	li	a7,5
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <write>:
.global write
write:
 li a7, SYS_write
 32e:	48c1                	li	a7,16
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <close>:
.global close
close:
 li a7, SYS_close
 336:	48d5                	li	a7,21
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <kill>:
.global kill
kill:
 li a7, SYS_kill
 33e:	4899                	li	a7,6
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <exec>:
.global exec
exec:
 li a7, SYS_exec
 346:	489d                	li	a7,7
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <open>:
.global open
open:
 li a7, SYS_open
 34e:	48bd                	li	a7,15
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 356:	48c5                	li	a7,17
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 35e:	48c9                	li	a7,18
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 366:	48a1                	li	a7,8
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <link>:
.global link
link:
 li a7, SYS_link
 36e:	48cd                	li	a7,19
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 376:	48d1                	li	a7,20
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 37e:	48a5                	li	a7,9
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <dup>:
.global dup
dup:
 li a7, SYS_dup
 386:	48a9                	li	a7,10
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 38e:	48ad                	li	a7,11
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 396:	48b1                	li	a7,12
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 39e:	48b5                	li	a7,13
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a6:	48b9                	li	a7,14
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 3ae:	48d9                	li	a7,22
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 3b6:	48dd                	li	a7,23
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3be:	48e1                	li	a7,24
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 3c6:	48e5                	li	a7,25
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <random>:
.global random
random:
 li a7, SYS_random
 3ce:	48e9                	li	a7,26
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 3d6:	48ed                	li	a7,27
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3de:	1101                	addi	sp,sp,-32
 3e0:	ec06                	sd	ra,24(sp)
 3e2:	e822                	sd	s0,16(sp)
 3e4:	1000                	addi	s0,sp,32
 3e6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ea:	4605                	li	a2,1
 3ec:	fef40593          	addi	a1,s0,-17
 3f0:	f3fff0ef          	jal	32e <write>
}
 3f4:	60e2                	ld	ra,24(sp)
 3f6:	6442                	ld	s0,16(sp)
 3f8:	6105                	addi	sp,sp,32
 3fa:	8082                	ret

00000000000003fc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3fc:	7139                	addi	sp,sp,-64
 3fe:	fc06                	sd	ra,56(sp)
 400:	f822                	sd	s0,48(sp)
 402:	f426                	sd	s1,40(sp)
 404:	0080                	addi	s0,sp,64
 406:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 408:	c299                	beqz	a3,40e <printint+0x12>
 40a:	0805c963          	bltz	a1,49c <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 40e:	2581                	sext.w	a1,a1
  neg = 0;
 410:	4881                	li	a7,0
 412:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 416:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 418:	2601                	sext.w	a2,a2
 41a:	00000517          	auipc	a0,0x0
 41e:	58650513          	addi	a0,a0,1414 # 9a0 <digits>
 422:	883a                	mv	a6,a4
 424:	2705                	addiw	a4,a4,1
 426:	02c5f7bb          	remuw	a5,a1,a2
 42a:	1782                	slli	a5,a5,0x20
 42c:	9381                	srli	a5,a5,0x20
 42e:	97aa                	add	a5,a5,a0
 430:	0007c783          	lbu	a5,0(a5)
 434:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 438:	0005879b          	sext.w	a5,a1
 43c:	02c5d5bb          	divuw	a1,a1,a2
 440:	0685                	addi	a3,a3,1
 442:	fec7f0e3          	bgeu	a5,a2,422 <printint+0x26>
  if(neg)
 446:	00088c63          	beqz	a7,45e <printint+0x62>
    buf[i++] = '-';
 44a:	fd070793          	addi	a5,a4,-48
 44e:	00878733          	add	a4,a5,s0
 452:	02d00793          	li	a5,45
 456:	fef70823          	sb	a5,-16(a4)
 45a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 45e:	02e05a63          	blez	a4,492 <printint+0x96>
 462:	f04a                	sd	s2,32(sp)
 464:	ec4e                	sd	s3,24(sp)
 466:	fc040793          	addi	a5,s0,-64
 46a:	00e78933          	add	s2,a5,a4
 46e:	fff78993          	addi	s3,a5,-1
 472:	99ba                	add	s3,s3,a4
 474:	377d                	addiw	a4,a4,-1
 476:	1702                	slli	a4,a4,0x20
 478:	9301                	srli	a4,a4,0x20
 47a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 47e:	fff94583          	lbu	a1,-1(s2)
 482:	8526                	mv	a0,s1
 484:	f5bff0ef          	jal	3de <putc>
  while(--i >= 0)
 488:	197d                	addi	s2,s2,-1
 48a:	ff391ae3          	bne	s2,s3,47e <printint+0x82>
 48e:	7902                	ld	s2,32(sp)
 490:	69e2                	ld	s3,24(sp)
}
 492:	70e2                	ld	ra,56(sp)
 494:	7442                	ld	s0,48(sp)
 496:	74a2                	ld	s1,40(sp)
 498:	6121                	addi	sp,sp,64
 49a:	8082                	ret
    x = -xx;
 49c:	40b005bb          	negw	a1,a1
    neg = 1;
 4a0:	4885                	li	a7,1
    x = -xx;
 4a2:	bf85                	j	412 <printint+0x16>

00000000000004a4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4a4:	711d                	addi	sp,sp,-96
 4a6:	ec86                	sd	ra,88(sp)
 4a8:	e8a2                	sd	s0,80(sp)
 4aa:	e0ca                	sd	s2,64(sp)
 4ac:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ae:	0005c903          	lbu	s2,0(a1)
 4b2:	26090863          	beqz	s2,722 <vprintf+0x27e>
 4b6:	e4a6                	sd	s1,72(sp)
 4b8:	fc4e                	sd	s3,56(sp)
 4ba:	f852                	sd	s4,48(sp)
 4bc:	f456                	sd	s5,40(sp)
 4be:	f05a                	sd	s6,32(sp)
 4c0:	ec5e                	sd	s7,24(sp)
 4c2:	e862                	sd	s8,16(sp)
 4c4:	e466                	sd	s9,8(sp)
 4c6:	8b2a                	mv	s6,a0
 4c8:	8a2e                	mv	s4,a1
 4ca:	8bb2                	mv	s7,a2
  state = 0;
 4cc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4ce:	4481                	li	s1,0
 4d0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4d2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4d6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4da:	06c00c93          	li	s9,108
 4de:	a005                	j	4fe <vprintf+0x5a>
        putc(fd, c0);
 4e0:	85ca                	mv	a1,s2
 4e2:	855a                	mv	a0,s6
 4e4:	efbff0ef          	jal	3de <putc>
 4e8:	a019                	j	4ee <vprintf+0x4a>
    } else if(state == '%'){
 4ea:	03598263          	beq	s3,s5,50e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4ee:	2485                	addiw	s1,s1,1
 4f0:	8726                	mv	a4,s1
 4f2:	009a07b3          	add	a5,s4,s1
 4f6:	0007c903          	lbu	s2,0(a5)
 4fa:	20090c63          	beqz	s2,712 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 4fe:	0009079b          	sext.w	a5,s2
    if(state == 0){
 502:	fe0994e3          	bnez	s3,4ea <vprintf+0x46>
      if(c0 == '%'){
 506:	fd579de3          	bne	a5,s5,4e0 <vprintf+0x3c>
        state = '%';
 50a:	89be                	mv	s3,a5
 50c:	b7cd                	j	4ee <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 50e:	00ea06b3          	add	a3,s4,a4
 512:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 516:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 518:	c681                	beqz	a3,520 <vprintf+0x7c>
 51a:	9752                	add	a4,a4,s4
 51c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 520:	03878f63          	beq	a5,s8,55e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 524:	05978963          	beq	a5,s9,576 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 528:	07500713          	li	a4,117
 52c:	0ee78363          	beq	a5,a4,612 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 530:	07800713          	li	a4,120
 534:	12e78563          	beq	a5,a4,65e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 538:	07000713          	li	a4,112
 53c:	14e78a63          	beq	a5,a4,690 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 540:	07300713          	li	a4,115
 544:	18e78a63          	beq	a5,a4,6d8 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 548:	02500713          	li	a4,37
 54c:	04e79563          	bne	a5,a4,596 <vprintf+0xf2>
        putc(fd, '%');
 550:	02500593          	li	a1,37
 554:	855a                	mv	a0,s6
 556:	e89ff0ef          	jal	3de <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 55a:	4981                	li	s3,0
 55c:	bf49                	j	4ee <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 55e:	008b8913          	addi	s2,s7,8
 562:	4685                	li	a3,1
 564:	4629                	li	a2,10
 566:	000ba583          	lw	a1,0(s7)
 56a:	855a                	mv	a0,s6
 56c:	e91ff0ef          	jal	3fc <printint>
 570:	8bca                	mv	s7,s2
      state = 0;
 572:	4981                	li	s3,0
 574:	bfad                	j	4ee <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 576:	06400793          	li	a5,100
 57a:	02f68963          	beq	a3,a5,5ac <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 57e:	06c00793          	li	a5,108
 582:	04f68263          	beq	a3,a5,5c6 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 586:	07500793          	li	a5,117
 58a:	0af68063          	beq	a3,a5,62a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 58e:	07800793          	li	a5,120
 592:	0ef68263          	beq	a3,a5,676 <vprintf+0x1d2>
        putc(fd, '%');
 596:	02500593          	li	a1,37
 59a:	855a                	mv	a0,s6
 59c:	e43ff0ef          	jal	3de <putc>
        putc(fd, c0);
 5a0:	85ca                	mv	a1,s2
 5a2:	855a                	mv	a0,s6
 5a4:	e3bff0ef          	jal	3de <putc>
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	b791                	j	4ee <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ac:	008b8913          	addi	s2,s7,8
 5b0:	4685                	li	a3,1
 5b2:	4629                	li	a2,10
 5b4:	000ba583          	lw	a1,0(s7)
 5b8:	855a                	mv	a0,s6
 5ba:	e43ff0ef          	jal	3fc <printint>
        i += 1;
 5be:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c0:	8bca                	mv	s7,s2
      state = 0;
 5c2:	4981                	li	s3,0
        i += 1;
 5c4:	b72d                	j	4ee <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5c6:	06400793          	li	a5,100
 5ca:	02f60763          	beq	a2,a5,5f8 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5ce:	07500793          	li	a5,117
 5d2:	06f60963          	beq	a2,a5,644 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5d6:	07800793          	li	a5,120
 5da:	faf61ee3          	bne	a2,a5,596 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5de:	008b8913          	addi	s2,s7,8
 5e2:	4681                	li	a3,0
 5e4:	4641                	li	a2,16
 5e6:	000ba583          	lw	a1,0(s7)
 5ea:	855a                	mv	a0,s6
 5ec:	e11ff0ef          	jal	3fc <printint>
        i += 2;
 5f0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f2:	8bca                	mv	s7,s2
      state = 0;
 5f4:	4981                	li	s3,0
        i += 2;
 5f6:	bde5                	j	4ee <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f8:	008b8913          	addi	s2,s7,8
 5fc:	4685                	li	a3,1
 5fe:	4629                	li	a2,10
 600:	000ba583          	lw	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	df7ff0ef          	jal	3fc <printint>
        i += 2;
 60a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 60c:	8bca                	mv	s7,s2
      state = 0;
 60e:	4981                	li	s3,0
        i += 2;
 610:	bdf9                	j	4ee <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 612:	008b8913          	addi	s2,s7,8
 616:	4681                	li	a3,0
 618:	4629                	li	a2,10
 61a:	000ba583          	lw	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	dddff0ef          	jal	3fc <printint>
 624:	8bca                	mv	s7,s2
      state = 0;
 626:	4981                	li	s3,0
 628:	b5d9                	j	4ee <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62a:	008b8913          	addi	s2,s7,8
 62e:	4681                	li	a3,0
 630:	4629                	li	a2,10
 632:	000ba583          	lw	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	dc5ff0ef          	jal	3fc <printint>
        i += 1;
 63c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 63e:	8bca                	mv	s7,s2
      state = 0;
 640:	4981                	li	s3,0
        i += 1;
 642:	b575                	j	4ee <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 644:	008b8913          	addi	s2,s7,8
 648:	4681                	li	a3,0
 64a:	4629                	li	a2,10
 64c:	000ba583          	lw	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	dabff0ef          	jal	3fc <printint>
        i += 2;
 656:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 658:	8bca                	mv	s7,s2
      state = 0;
 65a:	4981                	li	s3,0
        i += 2;
 65c:	bd49                	j	4ee <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 65e:	008b8913          	addi	s2,s7,8
 662:	4681                	li	a3,0
 664:	4641                	li	a2,16
 666:	000ba583          	lw	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	d91ff0ef          	jal	3fc <printint>
 670:	8bca                	mv	s7,s2
      state = 0;
 672:	4981                	li	s3,0
 674:	bdad                	j	4ee <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 676:	008b8913          	addi	s2,s7,8
 67a:	4681                	li	a3,0
 67c:	4641                	li	a2,16
 67e:	000ba583          	lw	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	d79ff0ef          	jal	3fc <printint>
        i += 1;
 688:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 68a:	8bca                	mv	s7,s2
      state = 0;
 68c:	4981                	li	s3,0
        i += 1;
 68e:	b585                	j	4ee <vprintf+0x4a>
 690:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 692:	008b8d13          	addi	s10,s7,8
 696:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 69a:	03000593          	li	a1,48
 69e:	855a                	mv	a0,s6
 6a0:	d3fff0ef          	jal	3de <putc>
  putc(fd, 'x');
 6a4:	07800593          	li	a1,120
 6a8:	855a                	mv	a0,s6
 6aa:	d35ff0ef          	jal	3de <putc>
 6ae:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6b0:	00000b97          	auipc	s7,0x0
 6b4:	2f0b8b93          	addi	s7,s7,752 # 9a0 <digits>
 6b8:	03c9d793          	srli	a5,s3,0x3c
 6bc:	97de                	add	a5,a5,s7
 6be:	0007c583          	lbu	a1,0(a5)
 6c2:	855a                	mv	a0,s6
 6c4:	d1bff0ef          	jal	3de <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6c8:	0992                	slli	s3,s3,0x4
 6ca:	397d                	addiw	s2,s2,-1
 6cc:	fe0916e3          	bnez	s2,6b8 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6d0:	8bea                	mv	s7,s10
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	6d02                	ld	s10,0(sp)
 6d6:	bd21                	j	4ee <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6d8:	008b8993          	addi	s3,s7,8
 6dc:	000bb903          	ld	s2,0(s7)
 6e0:	00090f63          	beqz	s2,6fe <vprintf+0x25a>
        for(; *s; s++)
 6e4:	00094583          	lbu	a1,0(s2)
 6e8:	c195                	beqz	a1,70c <vprintf+0x268>
          putc(fd, *s);
 6ea:	855a                	mv	a0,s6
 6ec:	cf3ff0ef          	jal	3de <putc>
        for(; *s; s++)
 6f0:	0905                	addi	s2,s2,1
 6f2:	00094583          	lbu	a1,0(s2)
 6f6:	f9f5                	bnez	a1,6ea <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6f8:	8bce                	mv	s7,s3
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	bbcd                	j	4ee <vprintf+0x4a>
          s = "(null)";
 6fe:	00000917          	auipc	s2,0x0
 702:	29a90913          	addi	s2,s2,666 # 998 <malloc+0x18e>
        for(; *s; s++)
 706:	02800593          	li	a1,40
 70a:	b7c5                	j	6ea <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 70c:	8bce                	mv	s7,s3
      state = 0;
 70e:	4981                	li	s3,0
 710:	bbf9                	j	4ee <vprintf+0x4a>
 712:	64a6                	ld	s1,72(sp)
 714:	79e2                	ld	s3,56(sp)
 716:	7a42                	ld	s4,48(sp)
 718:	7aa2                	ld	s5,40(sp)
 71a:	7b02                	ld	s6,32(sp)
 71c:	6be2                	ld	s7,24(sp)
 71e:	6c42                	ld	s8,16(sp)
 720:	6ca2                	ld	s9,8(sp)
    }
  }
}
 722:	60e6                	ld	ra,88(sp)
 724:	6446                	ld	s0,80(sp)
 726:	6906                	ld	s2,64(sp)
 728:	6125                	addi	sp,sp,96
 72a:	8082                	ret

000000000000072c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 72c:	715d                	addi	sp,sp,-80
 72e:	ec06                	sd	ra,24(sp)
 730:	e822                	sd	s0,16(sp)
 732:	1000                	addi	s0,sp,32
 734:	e010                	sd	a2,0(s0)
 736:	e414                	sd	a3,8(s0)
 738:	e818                	sd	a4,16(s0)
 73a:	ec1c                	sd	a5,24(s0)
 73c:	03043023          	sd	a6,32(s0)
 740:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 744:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 748:	8622                	mv	a2,s0
 74a:	d5bff0ef          	jal	4a4 <vprintf>
}
 74e:	60e2                	ld	ra,24(sp)
 750:	6442                	ld	s0,16(sp)
 752:	6161                	addi	sp,sp,80
 754:	8082                	ret

0000000000000756 <printf>:

void
printf(const char *fmt, ...)
{
 756:	711d                	addi	sp,sp,-96
 758:	ec06                	sd	ra,24(sp)
 75a:	e822                	sd	s0,16(sp)
 75c:	1000                	addi	s0,sp,32
 75e:	e40c                	sd	a1,8(s0)
 760:	e810                	sd	a2,16(s0)
 762:	ec14                	sd	a3,24(s0)
 764:	f018                	sd	a4,32(s0)
 766:	f41c                	sd	a5,40(s0)
 768:	03043823          	sd	a6,48(s0)
 76c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 770:	00840613          	addi	a2,s0,8
 774:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 778:	85aa                	mv	a1,a0
 77a:	4505                	li	a0,1
 77c:	d29ff0ef          	jal	4a4 <vprintf>
}
 780:	60e2                	ld	ra,24(sp)
 782:	6442                	ld	s0,16(sp)
 784:	6125                	addi	sp,sp,96
 786:	8082                	ret

0000000000000788 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 788:	1141                	addi	sp,sp,-16
 78a:	e422                	sd	s0,8(sp)
 78c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 78e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 792:	00001797          	auipc	a5,0x1
 796:	86e7b783          	ld	a5,-1938(a5) # 1000 <freep>
 79a:	a02d                	j	7c4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 79c:	4618                	lw	a4,8(a2)
 79e:	9f2d                	addw	a4,a4,a1
 7a0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a4:	6398                	ld	a4,0(a5)
 7a6:	6310                	ld	a2,0(a4)
 7a8:	a83d                	j	7e6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7aa:	ff852703          	lw	a4,-8(a0)
 7ae:	9f31                	addw	a4,a4,a2
 7b0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7b2:	ff053683          	ld	a3,-16(a0)
 7b6:	a091                	j	7fa <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b8:	6398                	ld	a4,0(a5)
 7ba:	00e7e463          	bltu	a5,a4,7c2 <free+0x3a>
 7be:	00e6ea63          	bltu	a3,a4,7d2 <free+0x4a>
{
 7c2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c4:	fed7fae3          	bgeu	a5,a3,7b8 <free+0x30>
 7c8:	6398                	ld	a4,0(a5)
 7ca:	00e6e463          	bltu	a3,a4,7d2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ce:	fee7eae3          	bltu	a5,a4,7c2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7d2:	ff852583          	lw	a1,-8(a0)
 7d6:	6390                	ld	a2,0(a5)
 7d8:	02059813          	slli	a6,a1,0x20
 7dc:	01c85713          	srli	a4,a6,0x1c
 7e0:	9736                	add	a4,a4,a3
 7e2:	fae60de3          	beq	a2,a4,79c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7e6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ea:	4790                	lw	a2,8(a5)
 7ec:	02061593          	slli	a1,a2,0x20
 7f0:	01c5d713          	srli	a4,a1,0x1c
 7f4:	973e                	add	a4,a4,a5
 7f6:	fae68ae3          	beq	a3,a4,7aa <free+0x22>
    p->s.ptr = bp->s.ptr;
 7fa:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7fc:	00001717          	auipc	a4,0x1
 800:	80f73223          	sd	a5,-2044(a4) # 1000 <freep>
}
 804:	6422                	ld	s0,8(sp)
 806:	0141                	addi	sp,sp,16
 808:	8082                	ret

000000000000080a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 80a:	7139                	addi	sp,sp,-64
 80c:	fc06                	sd	ra,56(sp)
 80e:	f822                	sd	s0,48(sp)
 810:	f426                	sd	s1,40(sp)
 812:	ec4e                	sd	s3,24(sp)
 814:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 816:	02051493          	slli	s1,a0,0x20
 81a:	9081                	srli	s1,s1,0x20
 81c:	04bd                	addi	s1,s1,15
 81e:	8091                	srli	s1,s1,0x4
 820:	0014899b          	addiw	s3,s1,1
 824:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 826:	00000517          	auipc	a0,0x0
 82a:	7da53503          	ld	a0,2010(a0) # 1000 <freep>
 82e:	c915                	beqz	a0,862 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 830:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 832:	4798                	lw	a4,8(a5)
 834:	08977a63          	bgeu	a4,s1,8c8 <malloc+0xbe>
 838:	f04a                	sd	s2,32(sp)
 83a:	e852                	sd	s4,16(sp)
 83c:	e456                	sd	s5,8(sp)
 83e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 840:	8a4e                	mv	s4,s3
 842:	0009871b          	sext.w	a4,s3
 846:	6685                	lui	a3,0x1
 848:	00d77363          	bgeu	a4,a3,84e <malloc+0x44>
 84c:	6a05                	lui	s4,0x1
 84e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 852:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 856:	00000917          	auipc	s2,0x0
 85a:	7aa90913          	addi	s2,s2,1962 # 1000 <freep>
  if(p == (char*)-1)
 85e:	5afd                	li	s5,-1
 860:	a081                	j	8a0 <malloc+0x96>
 862:	f04a                	sd	s2,32(sp)
 864:	e852                	sd	s4,16(sp)
 866:	e456                	sd	s5,8(sp)
 868:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 86a:	00000797          	auipc	a5,0x0
 86e:	7a678793          	addi	a5,a5,1958 # 1010 <base>
 872:	00000717          	auipc	a4,0x0
 876:	78f73723          	sd	a5,1934(a4) # 1000 <freep>
 87a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 87c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 880:	b7c1                	j	840 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 882:	6398                	ld	a4,0(a5)
 884:	e118                	sd	a4,0(a0)
 886:	a8a9                	j	8e0 <malloc+0xd6>
  hp->s.size = nu;
 888:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 88c:	0541                	addi	a0,a0,16
 88e:	efbff0ef          	jal	788 <free>
  return freep;
 892:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 896:	c12d                	beqz	a0,8f8 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 898:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89a:	4798                	lw	a4,8(a5)
 89c:	02977263          	bgeu	a4,s1,8c0 <malloc+0xb6>
    if(p == freep)
 8a0:	00093703          	ld	a4,0(s2)
 8a4:	853e                	mv	a0,a5
 8a6:	fef719e3          	bne	a4,a5,898 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8aa:	8552                	mv	a0,s4
 8ac:	aebff0ef          	jal	396 <sbrk>
  if(p == (char*)-1)
 8b0:	fd551ce3          	bne	a0,s5,888 <malloc+0x7e>
        return 0;
 8b4:	4501                	li	a0,0
 8b6:	7902                	ld	s2,32(sp)
 8b8:	6a42                	ld	s4,16(sp)
 8ba:	6aa2                	ld	s5,8(sp)
 8bc:	6b02                	ld	s6,0(sp)
 8be:	a03d                	j	8ec <malloc+0xe2>
 8c0:	7902                	ld	s2,32(sp)
 8c2:	6a42                	ld	s4,16(sp)
 8c4:	6aa2                	ld	s5,8(sp)
 8c6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8c8:	fae48de3          	beq	s1,a4,882 <malloc+0x78>
        p->s.size -= nunits;
 8cc:	4137073b          	subw	a4,a4,s3
 8d0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d2:	02071693          	slli	a3,a4,0x20
 8d6:	01c6d713          	srli	a4,a3,0x1c
 8da:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8dc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e0:	00000717          	auipc	a4,0x0
 8e4:	72a73023          	sd	a0,1824(a4) # 1000 <freep>
      return (void*)(p + 1);
 8e8:	01078513          	addi	a0,a5,16
  }
}
 8ec:	70e2                	ld	ra,56(sp)
 8ee:	7442                	ld	s0,48(sp)
 8f0:	74a2                	ld	s1,40(sp)
 8f2:	69e2                	ld	s3,24(sp)
 8f4:	6121                	addi	sp,sp,64
 8f6:	8082                	ret
 8f8:	7902                	ld	s2,32(sp)
 8fa:	6a42                	ld	s4,16(sp)
 8fc:	6aa2                	ld	s5,8(sp)
 8fe:	6b02                	ld	s6,0(sp)
 900:	b7f5                	j	8ec <malloc+0xe2>
