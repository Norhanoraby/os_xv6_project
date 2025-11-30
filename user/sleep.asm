
user/_sleep:     file format elf64-littleriscv


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

int num1 = atoi(argv[1]);
   8:	6588                	ld	a0,8(a1)
   a:	182000ef          	jal	18c <atoi>
sleep(num1);
   e:	304000ef          	jal	312 <sleep>

exit(0);
  12:	4501                	li	a0,0
  14:	26e000ef          	jal	282 <exit>

0000000000000018 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  18:	1141                	addi	sp,sp,-16
  1a:	e406                	sd	ra,8(sp)
  1c:	e022                	sd	s0,0(sp)
  1e:	0800                	addi	s0,sp,16
  extern int main();
  main();
  20:	fe1ff0ef          	jal	0 <main>
  exit(0);
  24:	4501                	li	a0,0
  26:	25c000ef          	jal	282 <exit>

000000000000002a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e422                	sd	s0,8(sp)
  2e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  30:	87aa                	mv	a5,a0
  32:	0585                	addi	a1,a1,1
  34:	0785                	addi	a5,a5,1
  36:	fff5c703          	lbu	a4,-1(a1)
  3a:	fee78fa3          	sb	a4,-1(a5)
  3e:	fb75                	bnez	a4,32 <strcpy+0x8>
    ;
  return os;
}
  40:	6422                	ld	s0,8(sp)
  42:	0141                	addi	sp,sp,16
  44:	8082                	ret

0000000000000046 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  46:	1141                	addi	sp,sp,-16
  48:	e422                	sd	s0,8(sp)
  4a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4c:	00054783          	lbu	a5,0(a0)
  50:	cb91                	beqz	a5,64 <strcmp+0x1e>
  52:	0005c703          	lbu	a4,0(a1)
  56:	00f71763          	bne	a4,a5,64 <strcmp+0x1e>
    p++, q++;
  5a:	0505                	addi	a0,a0,1
  5c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	fbe5                	bnez	a5,52 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  64:	0005c503          	lbu	a0,0(a1)
}
  68:	40a7853b          	subw	a0,a5,a0
  6c:	6422                	ld	s0,8(sp)
  6e:	0141                	addi	sp,sp,16
  70:	8082                	ret

0000000000000072 <strlen>:

uint
strlen(const char *s)
{
  72:	1141                	addi	sp,sp,-16
  74:	e422                	sd	s0,8(sp)
  76:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  78:	00054783          	lbu	a5,0(a0)
  7c:	cf91                	beqz	a5,98 <strlen+0x26>
  7e:	0505                	addi	a0,a0,1
  80:	87aa                	mv	a5,a0
  82:	86be                	mv	a3,a5
  84:	0785                	addi	a5,a5,1
  86:	fff7c703          	lbu	a4,-1(a5)
  8a:	ff65                	bnez	a4,82 <strlen+0x10>
  8c:	40a6853b          	subw	a0,a3,a0
  90:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  92:	6422                	ld	s0,8(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret
  for(n = 0; s[n]; n++)
  98:	4501                	li	a0,0
  9a:	bfe5                	j	92 <strlen+0x20>

000000000000009c <memset>:

void*
memset(void *dst, int c, uint n)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a2:	ca19                	beqz	a2,b8 <memset+0x1c>
  a4:	87aa                	mv	a5,a0
  a6:	1602                	slli	a2,a2,0x20
  a8:	9201                	srli	a2,a2,0x20
  aa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ae:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b2:	0785                	addi	a5,a5,1
  b4:	fee79de3          	bne	a5,a4,ae <memset+0x12>
  }
  return dst;
}
  b8:	6422                	ld	s0,8(sp)
  ba:	0141                	addi	sp,sp,16
  bc:	8082                	ret

00000000000000be <strchr>:

char*
strchr(const char *s, char c)
{
  be:	1141                	addi	sp,sp,-16
  c0:	e422                	sd	s0,8(sp)
  c2:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cb99                	beqz	a5,de <strchr+0x20>
    if(*s == c)
  ca:	00f58763          	beq	a1,a5,d8 <strchr+0x1a>
  for(; *s; s++)
  ce:	0505                	addi	a0,a0,1
  d0:	00054783          	lbu	a5,0(a0)
  d4:	fbfd                	bnez	a5,ca <strchr+0xc>
      return (char*)s;
  return 0;
  d6:	4501                	li	a0,0
}
  d8:	6422                	ld	s0,8(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret
  return 0;
  de:	4501                	li	a0,0
  e0:	bfe5                	j	d8 <strchr+0x1a>

00000000000000e2 <gets>:

char*
gets(char *buf, int max)
{
  e2:	711d                	addi	sp,sp,-96
  e4:	ec86                	sd	ra,88(sp)
  e6:	e8a2                	sd	s0,80(sp)
  e8:	e4a6                	sd	s1,72(sp)
  ea:	e0ca                	sd	s2,64(sp)
  ec:	fc4e                	sd	s3,56(sp)
  ee:	f852                	sd	s4,48(sp)
  f0:	f456                	sd	s5,40(sp)
  f2:	f05a                	sd	s6,32(sp)
  f4:	ec5e                	sd	s7,24(sp)
  f6:	1080                	addi	s0,sp,96
  f8:	8baa                	mv	s7,a0
  fa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fc:	892a                	mv	s2,a0
  fe:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 100:	4aa9                	li	s5,10
 102:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 104:	89a6                	mv	s3,s1
 106:	2485                	addiw	s1,s1,1
 108:	0344d663          	bge	s1,s4,134 <gets+0x52>
    cc = read(0, &c, 1);
 10c:	4605                	li	a2,1
 10e:	faf40593          	addi	a1,s0,-81
 112:	4501                	li	a0,0
 114:	186000ef          	jal	29a <read>
    if(cc < 1)
 118:	00a05e63          	blez	a0,134 <gets+0x52>
    buf[i++] = c;
 11c:	faf44783          	lbu	a5,-81(s0)
 120:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 124:	01578763          	beq	a5,s5,132 <gets+0x50>
 128:	0905                	addi	s2,s2,1
 12a:	fd679de3          	bne	a5,s6,104 <gets+0x22>
    buf[i++] = c;
 12e:	89a6                	mv	s3,s1
 130:	a011                	j	134 <gets+0x52>
 132:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 134:	99de                	add	s3,s3,s7
 136:	00098023          	sb	zero,0(s3)
  return buf;
}
 13a:	855e                	mv	a0,s7
 13c:	60e6                	ld	ra,88(sp)
 13e:	6446                	ld	s0,80(sp)
 140:	64a6                	ld	s1,72(sp)
 142:	6906                	ld	s2,64(sp)
 144:	79e2                	ld	s3,56(sp)
 146:	7a42                	ld	s4,48(sp)
 148:	7aa2                	ld	s5,40(sp)
 14a:	7b02                	ld	s6,32(sp)
 14c:	6be2                	ld	s7,24(sp)
 14e:	6125                	addi	sp,sp,96
 150:	8082                	ret

0000000000000152 <stat>:

int
stat(const char *n, struct stat *st)
{
 152:	1101                	addi	sp,sp,-32
 154:	ec06                	sd	ra,24(sp)
 156:	e822                	sd	s0,16(sp)
 158:	e04a                	sd	s2,0(sp)
 15a:	1000                	addi	s0,sp,32
 15c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 15e:	4581                	li	a1,0
 160:	162000ef          	jal	2c2 <open>
  if(fd < 0)
 164:	02054263          	bltz	a0,188 <stat+0x36>
 168:	e426                	sd	s1,8(sp)
 16a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 16c:	85ca                	mv	a1,s2
 16e:	16c000ef          	jal	2da <fstat>
 172:	892a                	mv	s2,a0
  close(fd);
 174:	8526                	mv	a0,s1
 176:	134000ef          	jal	2aa <close>
  return r;
 17a:	64a2                	ld	s1,8(sp)
}
 17c:	854a                	mv	a0,s2
 17e:	60e2                	ld	ra,24(sp)
 180:	6442                	ld	s0,16(sp)
 182:	6902                	ld	s2,0(sp)
 184:	6105                	addi	sp,sp,32
 186:	8082                	ret
    return -1;
 188:	597d                	li	s2,-1
 18a:	bfcd                	j	17c <stat+0x2a>

000000000000018c <atoi>:

int
atoi(const char *s)
{
 18c:	1141                	addi	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 192:	00054683          	lbu	a3,0(a0)
 196:	fd06879b          	addiw	a5,a3,-48
 19a:	0ff7f793          	zext.b	a5,a5
 19e:	4625                	li	a2,9
 1a0:	02f66863          	bltu	a2,a5,1d0 <atoi+0x44>
 1a4:	872a                	mv	a4,a0
  n = 0;
 1a6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1a8:	0705                	addi	a4,a4,1
 1aa:	0025179b          	slliw	a5,a0,0x2
 1ae:	9fa9                	addw	a5,a5,a0
 1b0:	0017979b          	slliw	a5,a5,0x1
 1b4:	9fb5                	addw	a5,a5,a3
 1b6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ba:	00074683          	lbu	a3,0(a4)
 1be:	fd06879b          	addiw	a5,a3,-48
 1c2:	0ff7f793          	zext.b	a5,a5
 1c6:	fef671e3          	bgeu	a2,a5,1a8 <atoi+0x1c>
  return n;
}
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	addi	sp,sp,16
 1ce:	8082                	ret
  n = 0;
 1d0:	4501                	li	a0,0
 1d2:	bfe5                	j	1ca <atoi+0x3e>

00000000000001d4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1d4:	1141                	addi	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1da:	02b57463          	bgeu	a0,a1,202 <memmove+0x2e>
    while(n-- > 0)
 1de:	00c05f63          	blez	a2,1fc <memmove+0x28>
 1e2:	1602                	slli	a2,a2,0x20
 1e4:	9201                	srli	a2,a2,0x20
 1e6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1ea:	872a                	mv	a4,a0
      *dst++ = *src++;
 1ec:	0585                	addi	a1,a1,1
 1ee:	0705                	addi	a4,a4,1
 1f0:	fff5c683          	lbu	a3,-1(a1)
 1f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1f8:	fef71ae3          	bne	a4,a5,1ec <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 1fc:	6422                	ld	s0,8(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret
    dst += n;
 202:	00c50733          	add	a4,a0,a2
    src += n;
 206:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 208:	fec05ae3          	blez	a2,1fc <memmove+0x28>
 20c:	fff6079b          	addiw	a5,a2,-1
 210:	1782                	slli	a5,a5,0x20
 212:	9381                	srli	a5,a5,0x20
 214:	fff7c793          	not	a5,a5
 218:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 21a:	15fd                	addi	a1,a1,-1
 21c:	177d                	addi	a4,a4,-1
 21e:	0005c683          	lbu	a3,0(a1)
 222:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 226:	fee79ae3          	bne	a5,a4,21a <memmove+0x46>
 22a:	bfc9                	j	1fc <memmove+0x28>

000000000000022c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 22c:	1141                	addi	sp,sp,-16
 22e:	e422                	sd	s0,8(sp)
 230:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 232:	ca05                	beqz	a2,262 <memcmp+0x36>
 234:	fff6069b          	addiw	a3,a2,-1
 238:	1682                	slli	a3,a3,0x20
 23a:	9281                	srli	a3,a3,0x20
 23c:	0685                	addi	a3,a3,1
 23e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 240:	00054783          	lbu	a5,0(a0)
 244:	0005c703          	lbu	a4,0(a1)
 248:	00e79863          	bne	a5,a4,258 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 24c:	0505                	addi	a0,a0,1
    p2++;
 24e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 250:	fed518e3          	bne	a0,a3,240 <memcmp+0x14>
  }
  return 0;
 254:	4501                	li	a0,0
 256:	a019                	j	25c <memcmp+0x30>
      return *p1 - *p2;
 258:	40e7853b          	subw	a0,a5,a4
}
 25c:	6422                	ld	s0,8(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
  return 0;
 262:	4501                	li	a0,0
 264:	bfe5                	j	25c <memcmp+0x30>

0000000000000266 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 266:	1141                	addi	sp,sp,-16
 268:	e406                	sd	ra,8(sp)
 26a:	e022                	sd	s0,0(sp)
 26c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 26e:	f67ff0ef          	jal	1d4 <memmove>
}
 272:	60a2                	ld	ra,8(sp)
 274:	6402                	ld	s0,0(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret

000000000000027a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 27a:	4885                	li	a7,1
 ecall
 27c:	00000073          	ecall
 ret
 280:	8082                	ret

0000000000000282 <exit>:
.global exit
exit:
 li a7, SYS_exit
 282:	4889                	li	a7,2
 ecall
 284:	00000073          	ecall
 ret
 288:	8082                	ret

000000000000028a <wait>:
.global wait
wait:
 li a7, SYS_wait
 28a:	488d                	li	a7,3
 ecall
 28c:	00000073          	ecall
 ret
 290:	8082                	ret

0000000000000292 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 292:	4891                	li	a7,4
 ecall
 294:	00000073          	ecall
 ret
 298:	8082                	ret

000000000000029a <read>:
.global read
read:
 li a7, SYS_read
 29a:	4895                	li	a7,5
 ecall
 29c:	00000073          	ecall
 ret
 2a0:	8082                	ret

00000000000002a2 <write>:
.global write
write:
 li a7, SYS_write
 2a2:	48c1                	li	a7,16
 ecall
 2a4:	00000073          	ecall
 ret
 2a8:	8082                	ret

00000000000002aa <close>:
.global close
close:
 li a7, SYS_close
 2aa:	48d5                	li	a7,21
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2b2:	4899                	li	a7,6
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <exec>:
.global exec
exec:
 li a7, SYS_exec
 2ba:	489d                	li	a7,7
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <open>:
.global open
open:
 li a7, SYS_open
 2c2:	48bd                	li	a7,15
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2ca:	48c5                	li	a7,17
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2d2:	48c9                	li	a7,18
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2da:	48a1                	li	a7,8
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <link>:
.global link
link:
 li a7, SYS_link
 2e2:	48cd                	li	a7,19
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2ea:	48d1                	li	a7,20
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2f2:	48a5                	li	a7,9
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <dup>:
.global dup
dup:
 li a7, SYS_dup
 2fa:	48a9                	li	a7,10
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 302:	48ad                	li	a7,11
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 30a:	48b1                	li	a7,12
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 312:	48b5                	li	a7,13
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 31a:	48b9                	li	a7,14
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 322:	48d9                	li	a7,22
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 32a:	1101                	addi	sp,sp,-32
 32c:	ec06                	sd	ra,24(sp)
 32e:	e822                	sd	s0,16(sp)
 330:	1000                	addi	s0,sp,32
 332:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 336:	4605                	li	a2,1
 338:	fef40593          	addi	a1,s0,-17
 33c:	f67ff0ef          	jal	2a2 <write>
}
 340:	60e2                	ld	ra,24(sp)
 342:	6442                	ld	s0,16(sp)
 344:	6105                	addi	sp,sp,32
 346:	8082                	ret

0000000000000348 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 348:	7139                	addi	sp,sp,-64
 34a:	fc06                	sd	ra,56(sp)
 34c:	f822                	sd	s0,48(sp)
 34e:	f426                	sd	s1,40(sp)
 350:	0080                	addi	s0,sp,64
 352:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 354:	c299                	beqz	a3,35a <printint+0x12>
 356:	0805c963          	bltz	a1,3e8 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 35a:	2581                	sext.w	a1,a1
  neg = 0;
 35c:	4881                	li	a7,0
 35e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 362:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 364:	2601                	sext.w	a2,a2
 366:	00000517          	auipc	a0,0x0
 36a:	4f250513          	addi	a0,a0,1266 # 858 <digits>
 36e:	883a                	mv	a6,a4
 370:	2705                	addiw	a4,a4,1
 372:	02c5f7bb          	remuw	a5,a1,a2
 376:	1782                	slli	a5,a5,0x20
 378:	9381                	srli	a5,a5,0x20
 37a:	97aa                	add	a5,a5,a0
 37c:	0007c783          	lbu	a5,0(a5)
 380:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 384:	0005879b          	sext.w	a5,a1
 388:	02c5d5bb          	divuw	a1,a1,a2
 38c:	0685                	addi	a3,a3,1
 38e:	fec7f0e3          	bgeu	a5,a2,36e <printint+0x26>
  if(neg)
 392:	00088c63          	beqz	a7,3aa <printint+0x62>
    buf[i++] = '-';
 396:	fd070793          	addi	a5,a4,-48
 39a:	00878733          	add	a4,a5,s0
 39e:	02d00793          	li	a5,45
 3a2:	fef70823          	sb	a5,-16(a4)
 3a6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3aa:	02e05a63          	blez	a4,3de <printint+0x96>
 3ae:	f04a                	sd	s2,32(sp)
 3b0:	ec4e                	sd	s3,24(sp)
 3b2:	fc040793          	addi	a5,s0,-64
 3b6:	00e78933          	add	s2,a5,a4
 3ba:	fff78993          	addi	s3,a5,-1
 3be:	99ba                	add	s3,s3,a4
 3c0:	377d                	addiw	a4,a4,-1
 3c2:	1702                	slli	a4,a4,0x20
 3c4:	9301                	srli	a4,a4,0x20
 3c6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3ca:	fff94583          	lbu	a1,-1(s2)
 3ce:	8526                	mv	a0,s1
 3d0:	f5bff0ef          	jal	32a <putc>
  while(--i >= 0)
 3d4:	197d                	addi	s2,s2,-1
 3d6:	ff391ae3          	bne	s2,s3,3ca <printint+0x82>
 3da:	7902                	ld	s2,32(sp)
 3dc:	69e2                	ld	s3,24(sp)
}
 3de:	70e2                	ld	ra,56(sp)
 3e0:	7442                	ld	s0,48(sp)
 3e2:	74a2                	ld	s1,40(sp)
 3e4:	6121                	addi	sp,sp,64
 3e6:	8082                	ret
    x = -xx;
 3e8:	40b005bb          	negw	a1,a1
    neg = 1;
 3ec:	4885                	li	a7,1
    x = -xx;
 3ee:	bf85                	j	35e <printint+0x16>

00000000000003f0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3f0:	711d                	addi	sp,sp,-96
 3f2:	ec86                	sd	ra,88(sp)
 3f4:	e8a2                	sd	s0,80(sp)
 3f6:	e0ca                	sd	s2,64(sp)
 3f8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3fa:	0005c903          	lbu	s2,0(a1)
 3fe:	26090863          	beqz	s2,66e <vprintf+0x27e>
 402:	e4a6                	sd	s1,72(sp)
 404:	fc4e                	sd	s3,56(sp)
 406:	f852                	sd	s4,48(sp)
 408:	f456                	sd	s5,40(sp)
 40a:	f05a                	sd	s6,32(sp)
 40c:	ec5e                	sd	s7,24(sp)
 40e:	e862                	sd	s8,16(sp)
 410:	e466                	sd	s9,8(sp)
 412:	8b2a                	mv	s6,a0
 414:	8a2e                	mv	s4,a1
 416:	8bb2                	mv	s7,a2
  state = 0;
 418:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 41a:	4481                	li	s1,0
 41c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 41e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 422:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 426:	06c00c93          	li	s9,108
 42a:	a005                	j	44a <vprintf+0x5a>
        putc(fd, c0);
 42c:	85ca                	mv	a1,s2
 42e:	855a                	mv	a0,s6
 430:	efbff0ef          	jal	32a <putc>
 434:	a019                	j	43a <vprintf+0x4a>
    } else if(state == '%'){
 436:	03598263          	beq	s3,s5,45a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 43a:	2485                	addiw	s1,s1,1
 43c:	8726                	mv	a4,s1
 43e:	009a07b3          	add	a5,s4,s1
 442:	0007c903          	lbu	s2,0(a5)
 446:	20090c63          	beqz	s2,65e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 44a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 44e:	fe0994e3          	bnez	s3,436 <vprintf+0x46>
      if(c0 == '%'){
 452:	fd579de3          	bne	a5,s5,42c <vprintf+0x3c>
        state = '%';
 456:	89be                	mv	s3,a5
 458:	b7cd                	j	43a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 45a:	00ea06b3          	add	a3,s4,a4
 45e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 462:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 464:	c681                	beqz	a3,46c <vprintf+0x7c>
 466:	9752                	add	a4,a4,s4
 468:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 46c:	03878f63          	beq	a5,s8,4aa <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 470:	05978963          	beq	a5,s9,4c2 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 474:	07500713          	li	a4,117
 478:	0ee78363          	beq	a5,a4,55e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 47c:	07800713          	li	a4,120
 480:	12e78563          	beq	a5,a4,5aa <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 484:	07000713          	li	a4,112
 488:	14e78a63          	beq	a5,a4,5dc <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 48c:	07300713          	li	a4,115
 490:	18e78a63          	beq	a5,a4,624 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 494:	02500713          	li	a4,37
 498:	04e79563          	bne	a5,a4,4e2 <vprintf+0xf2>
        putc(fd, '%');
 49c:	02500593          	li	a1,37
 4a0:	855a                	mv	a0,s6
 4a2:	e89ff0ef          	jal	32a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4a6:	4981                	li	s3,0
 4a8:	bf49                	j	43a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4aa:	008b8913          	addi	s2,s7,8
 4ae:	4685                	li	a3,1
 4b0:	4629                	li	a2,10
 4b2:	000ba583          	lw	a1,0(s7)
 4b6:	855a                	mv	a0,s6
 4b8:	e91ff0ef          	jal	348 <printint>
 4bc:	8bca                	mv	s7,s2
      state = 0;
 4be:	4981                	li	s3,0
 4c0:	bfad                	j	43a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4c2:	06400793          	li	a5,100
 4c6:	02f68963          	beq	a3,a5,4f8 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4ca:	06c00793          	li	a5,108
 4ce:	04f68263          	beq	a3,a5,512 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 4d2:	07500793          	li	a5,117
 4d6:	0af68063          	beq	a3,a5,576 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 4da:	07800793          	li	a5,120
 4de:	0ef68263          	beq	a3,a5,5c2 <vprintf+0x1d2>
        putc(fd, '%');
 4e2:	02500593          	li	a1,37
 4e6:	855a                	mv	a0,s6
 4e8:	e43ff0ef          	jal	32a <putc>
        putc(fd, c0);
 4ec:	85ca                	mv	a1,s2
 4ee:	855a                	mv	a0,s6
 4f0:	e3bff0ef          	jal	32a <putc>
      state = 0;
 4f4:	4981                	li	s3,0
 4f6:	b791                	j	43a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4f8:	008b8913          	addi	s2,s7,8
 4fc:	4685                	li	a3,1
 4fe:	4629                	li	a2,10
 500:	000ba583          	lw	a1,0(s7)
 504:	855a                	mv	a0,s6
 506:	e43ff0ef          	jal	348 <printint>
        i += 1;
 50a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 50c:	8bca                	mv	s7,s2
      state = 0;
 50e:	4981                	li	s3,0
        i += 1;
 510:	b72d                	j	43a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 512:	06400793          	li	a5,100
 516:	02f60763          	beq	a2,a5,544 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 51a:	07500793          	li	a5,117
 51e:	06f60963          	beq	a2,a5,590 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 522:	07800793          	li	a5,120
 526:	faf61ee3          	bne	a2,a5,4e2 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 52a:	008b8913          	addi	s2,s7,8
 52e:	4681                	li	a3,0
 530:	4641                	li	a2,16
 532:	000ba583          	lw	a1,0(s7)
 536:	855a                	mv	a0,s6
 538:	e11ff0ef          	jal	348 <printint>
        i += 2;
 53c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 53e:	8bca                	mv	s7,s2
      state = 0;
 540:	4981                	li	s3,0
        i += 2;
 542:	bde5                	j	43a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 544:	008b8913          	addi	s2,s7,8
 548:	4685                	li	a3,1
 54a:	4629                	li	a2,10
 54c:	000ba583          	lw	a1,0(s7)
 550:	855a                	mv	a0,s6
 552:	df7ff0ef          	jal	348 <printint>
        i += 2;
 556:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 558:	8bca                	mv	s7,s2
      state = 0;
 55a:	4981                	li	s3,0
        i += 2;
 55c:	bdf9                	j	43a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 55e:	008b8913          	addi	s2,s7,8
 562:	4681                	li	a3,0
 564:	4629                	li	a2,10
 566:	000ba583          	lw	a1,0(s7)
 56a:	855a                	mv	a0,s6
 56c:	dddff0ef          	jal	348 <printint>
 570:	8bca                	mv	s7,s2
      state = 0;
 572:	4981                	li	s3,0
 574:	b5d9                	j	43a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 576:	008b8913          	addi	s2,s7,8
 57a:	4681                	li	a3,0
 57c:	4629                	li	a2,10
 57e:	000ba583          	lw	a1,0(s7)
 582:	855a                	mv	a0,s6
 584:	dc5ff0ef          	jal	348 <printint>
        i += 1;
 588:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 58a:	8bca                	mv	s7,s2
      state = 0;
 58c:	4981                	li	s3,0
        i += 1;
 58e:	b575                	j	43a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 590:	008b8913          	addi	s2,s7,8
 594:	4681                	li	a3,0
 596:	4629                	li	a2,10
 598:	000ba583          	lw	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	dabff0ef          	jal	348 <printint>
        i += 2;
 5a2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a4:	8bca                	mv	s7,s2
      state = 0;
 5a6:	4981                	li	s3,0
        i += 2;
 5a8:	bd49                	j	43a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5aa:	008b8913          	addi	s2,s7,8
 5ae:	4681                	li	a3,0
 5b0:	4641                	li	a2,16
 5b2:	000ba583          	lw	a1,0(s7)
 5b6:	855a                	mv	a0,s6
 5b8:	d91ff0ef          	jal	348 <printint>
 5bc:	8bca                	mv	s7,s2
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	bdad                	j	43a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c2:	008b8913          	addi	s2,s7,8
 5c6:	4681                	li	a3,0
 5c8:	4641                	li	a2,16
 5ca:	000ba583          	lw	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	d79ff0ef          	jal	348 <printint>
        i += 1;
 5d4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d6:	8bca                	mv	s7,s2
      state = 0;
 5d8:	4981                	li	s3,0
        i += 1;
 5da:	b585                	j	43a <vprintf+0x4a>
 5dc:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5de:	008b8d13          	addi	s10,s7,8
 5e2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5e6:	03000593          	li	a1,48
 5ea:	855a                	mv	a0,s6
 5ec:	d3fff0ef          	jal	32a <putc>
  putc(fd, 'x');
 5f0:	07800593          	li	a1,120
 5f4:	855a                	mv	a0,s6
 5f6:	d35ff0ef          	jal	32a <putc>
 5fa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5fc:	00000b97          	auipc	s7,0x0
 600:	25cb8b93          	addi	s7,s7,604 # 858 <digits>
 604:	03c9d793          	srli	a5,s3,0x3c
 608:	97de                	add	a5,a5,s7
 60a:	0007c583          	lbu	a1,0(a5)
 60e:	855a                	mv	a0,s6
 610:	d1bff0ef          	jal	32a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 614:	0992                	slli	s3,s3,0x4
 616:	397d                	addiw	s2,s2,-1
 618:	fe0916e3          	bnez	s2,604 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 61c:	8bea                	mv	s7,s10
      state = 0;
 61e:	4981                	li	s3,0
 620:	6d02                	ld	s10,0(sp)
 622:	bd21                	j	43a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 624:	008b8993          	addi	s3,s7,8
 628:	000bb903          	ld	s2,0(s7)
 62c:	00090f63          	beqz	s2,64a <vprintf+0x25a>
        for(; *s; s++)
 630:	00094583          	lbu	a1,0(s2)
 634:	c195                	beqz	a1,658 <vprintf+0x268>
          putc(fd, *s);
 636:	855a                	mv	a0,s6
 638:	cf3ff0ef          	jal	32a <putc>
        for(; *s; s++)
 63c:	0905                	addi	s2,s2,1
 63e:	00094583          	lbu	a1,0(s2)
 642:	f9f5                	bnez	a1,636 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 644:	8bce                	mv	s7,s3
      state = 0;
 646:	4981                	li	s3,0
 648:	bbcd                	j	43a <vprintf+0x4a>
          s = "(null)";
 64a:	00000917          	auipc	s2,0x0
 64e:	20690913          	addi	s2,s2,518 # 850 <malloc+0xfa>
        for(; *s; s++)
 652:	02800593          	li	a1,40
 656:	b7c5                	j	636 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 658:	8bce                	mv	s7,s3
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bbf9                	j	43a <vprintf+0x4a>
 65e:	64a6                	ld	s1,72(sp)
 660:	79e2                	ld	s3,56(sp)
 662:	7a42                	ld	s4,48(sp)
 664:	7aa2                	ld	s5,40(sp)
 666:	7b02                	ld	s6,32(sp)
 668:	6be2                	ld	s7,24(sp)
 66a:	6c42                	ld	s8,16(sp)
 66c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 66e:	60e6                	ld	ra,88(sp)
 670:	6446                	ld	s0,80(sp)
 672:	6906                	ld	s2,64(sp)
 674:	6125                	addi	sp,sp,96
 676:	8082                	ret

0000000000000678 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 678:	715d                	addi	sp,sp,-80
 67a:	ec06                	sd	ra,24(sp)
 67c:	e822                	sd	s0,16(sp)
 67e:	1000                	addi	s0,sp,32
 680:	e010                	sd	a2,0(s0)
 682:	e414                	sd	a3,8(s0)
 684:	e818                	sd	a4,16(s0)
 686:	ec1c                	sd	a5,24(s0)
 688:	03043023          	sd	a6,32(s0)
 68c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 690:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 694:	8622                	mv	a2,s0
 696:	d5bff0ef          	jal	3f0 <vprintf>
}
 69a:	60e2                	ld	ra,24(sp)
 69c:	6442                	ld	s0,16(sp)
 69e:	6161                	addi	sp,sp,80
 6a0:	8082                	ret

00000000000006a2 <printf>:

void
printf(const char *fmt, ...)
{
 6a2:	711d                	addi	sp,sp,-96
 6a4:	ec06                	sd	ra,24(sp)
 6a6:	e822                	sd	s0,16(sp)
 6a8:	1000                	addi	s0,sp,32
 6aa:	e40c                	sd	a1,8(s0)
 6ac:	e810                	sd	a2,16(s0)
 6ae:	ec14                	sd	a3,24(s0)
 6b0:	f018                	sd	a4,32(s0)
 6b2:	f41c                	sd	a5,40(s0)
 6b4:	03043823          	sd	a6,48(s0)
 6b8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6bc:	00840613          	addi	a2,s0,8
 6c0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6c4:	85aa                	mv	a1,a0
 6c6:	4505                	li	a0,1
 6c8:	d29ff0ef          	jal	3f0 <vprintf>
}
 6cc:	60e2                	ld	ra,24(sp)
 6ce:	6442                	ld	s0,16(sp)
 6d0:	6125                	addi	sp,sp,96
 6d2:	8082                	ret

00000000000006d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d4:	1141                	addi	sp,sp,-16
 6d6:	e422                	sd	s0,8(sp)
 6d8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6da:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6de:	00001797          	auipc	a5,0x1
 6e2:	9227b783          	ld	a5,-1758(a5) # 1000 <freep>
 6e6:	a02d                	j	710 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6e8:	4618                	lw	a4,8(a2)
 6ea:	9f2d                	addw	a4,a4,a1
 6ec:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f0:	6398                	ld	a4,0(a5)
 6f2:	6310                	ld	a2,0(a4)
 6f4:	a83d                	j	732 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6f6:	ff852703          	lw	a4,-8(a0)
 6fa:	9f31                	addw	a4,a4,a2
 6fc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6fe:	ff053683          	ld	a3,-16(a0)
 702:	a091                	j	746 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 704:	6398                	ld	a4,0(a5)
 706:	00e7e463          	bltu	a5,a4,70e <free+0x3a>
 70a:	00e6ea63          	bltu	a3,a4,71e <free+0x4a>
{
 70e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 710:	fed7fae3          	bgeu	a5,a3,704 <free+0x30>
 714:	6398                	ld	a4,0(a5)
 716:	00e6e463          	bltu	a3,a4,71e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71a:	fee7eae3          	bltu	a5,a4,70e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 71e:	ff852583          	lw	a1,-8(a0)
 722:	6390                	ld	a2,0(a5)
 724:	02059813          	slli	a6,a1,0x20
 728:	01c85713          	srli	a4,a6,0x1c
 72c:	9736                	add	a4,a4,a3
 72e:	fae60de3          	beq	a2,a4,6e8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 732:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 736:	4790                	lw	a2,8(a5)
 738:	02061593          	slli	a1,a2,0x20
 73c:	01c5d713          	srli	a4,a1,0x1c
 740:	973e                	add	a4,a4,a5
 742:	fae68ae3          	beq	a3,a4,6f6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 746:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 748:	00001717          	auipc	a4,0x1
 74c:	8af73c23          	sd	a5,-1864(a4) # 1000 <freep>
}
 750:	6422                	ld	s0,8(sp)
 752:	0141                	addi	sp,sp,16
 754:	8082                	ret

0000000000000756 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 756:	7139                	addi	sp,sp,-64
 758:	fc06                	sd	ra,56(sp)
 75a:	f822                	sd	s0,48(sp)
 75c:	f426                	sd	s1,40(sp)
 75e:	ec4e                	sd	s3,24(sp)
 760:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 762:	02051493          	slli	s1,a0,0x20
 766:	9081                	srli	s1,s1,0x20
 768:	04bd                	addi	s1,s1,15
 76a:	8091                	srli	s1,s1,0x4
 76c:	0014899b          	addiw	s3,s1,1
 770:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 772:	00001517          	auipc	a0,0x1
 776:	88e53503          	ld	a0,-1906(a0) # 1000 <freep>
 77a:	c915                	beqz	a0,7ae <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 77e:	4798                	lw	a4,8(a5)
 780:	08977a63          	bgeu	a4,s1,814 <malloc+0xbe>
 784:	f04a                	sd	s2,32(sp)
 786:	e852                	sd	s4,16(sp)
 788:	e456                	sd	s5,8(sp)
 78a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 78c:	8a4e                	mv	s4,s3
 78e:	0009871b          	sext.w	a4,s3
 792:	6685                	lui	a3,0x1
 794:	00d77363          	bgeu	a4,a3,79a <malloc+0x44>
 798:	6a05                	lui	s4,0x1
 79a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 79e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a2:	00001917          	auipc	s2,0x1
 7a6:	85e90913          	addi	s2,s2,-1954 # 1000 <freep>
  if(p == (char*)-1)
 7aa:	5afd                	li	s5,-1
 7ac:	a081                	j	7ec <malloc+0x96>
 7ae:	f04a                	sd	s2,32(sp)
 7b0:	e852                	sd	s4,16(sp)
 7b2:	e456                	sd	s5,8(sp)
 7b4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7b6:	00001797          	auipc	a5,0x1
 7ba:	85a78793          	addi	a5,a5,-1958 # 1010 <base>
 7be:	00001717          	auipc	a4,0x1
 7c2:	84f73123          	sd	a5,-1982(a4) # 1000 <freep>
 7c6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7c8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7cc:	b7c1                	j	78c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7ce:	6398                	ld	a4,0(a5)
 7d0:	e118                	sd	a4,0(a0)
 7d2:	a8a9                	j	82c <malloc+0xd6>
  hp->s.size = nu;
 7d4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7d8:	0541                	addi	a0,a0,16
 7da:	efbff0ef          	jal	6d4 <free>
  return freep;
 7de:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7e2:	c12d                	beqz	a0,844 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e6:	4798                	lw	a4,8(a5)
 7e8:	02977263          	bgeu	a4,s1,80c <malloc+0xb6>
    if(p == freep)
 7ec:	00093703          	ld	a4,0(s2)
 7f0:	853e                	mv	a0,a5
 7f2:	fef719e3          	bne	a4,a5,7e4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7f6:	8552                	mv	a0,s4
 7f8:	b13ff0ef          	jal	30a <sbrk>
  if(p == (char*)-1)
 7fc:	fd551ce3          	bne	a0,s5,7d4 <malloc+0x7e>
        return 0;
 800:	4501                	li	a0,0
 802:	7902                	ld	s2,32(sp)
 804:	6a42                	ld	s4,16(sp)
 806:	6aa2                	ld	s5,8(sp)
 808:	6b02                	ld	s6,0(sp)
 80a:	a03d                	j	838 <malloc+0xe2>
 80c:	7902                	ld	s2,32(sp)
 80e:	6a42                	ld	s4,16(sp)
 810:	6aa2                	ld	s5,8(sp)
 812:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 814:	fae48de3          	beq	s1,a4,7ce <malloc+0x78>
        p->s.size -= nunits;
 818:	4137073b          	subw	a4,a4,s3
 81c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 81e:	02071693          	slli	a3,a4,0x20
 822:	01c6d713          	srli	a4,a3,0x1c
 826:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 828:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 82c:	00000717          	auipc	a4,0x0
 830:	7ca73a23          	sd	a0,2004(a4) # 1000 <freep>
      return (void*)(p + 1);
 834:	01078513          	addi	a0,a5,16
  }
}
 838:	70e2                	ld	ra,56(sp)
 83a:	7442                	ld	s0,48(sp)
 83c:	74a2                	ld	s1,40(sp)
 83e:	69e2                	ld	s3,24(sp)
 840:	6121                	addi	sp,sp,64
 842:	8082                	ret
 844:	7902                	ld	s2,32(sp)
 846:	6a42                	ld	s4,16(sp)
 848:	6aa2                	ld	s5,8(sp)
 84a:	6b02                	ld	s6,0(sp)
 84c:	b7f5                	j	838 <malloc+0xe2>
