
user/_add:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84ae                	mv	s1,a1

int num1 = atoi(argv[1]);
   e:	6588                	ld	a0,8(a1)
  10:	196000ef          	jal	1a6 <atoi>
  14:	892a                	mv	s2,a0
int num2 = atoi(argv[2]);
  16:	6888                	ld	a0,16(s1)
  18:	18e000ef          	jal	1a6 <atoi>
int sum = num1 + num2;
printf("%d ",sum);
  1c:	00a905bb          	addw	a1,s2,a0
  20:	00001517          	auipc	a0,0x1
  24:	86050513          	addi	a0,a0,-1952 # 880 <malloc+0xf8>
  28:	6ac000ef          	jal	6d4 <printf>

exit(0);
  2c:	4501                	li	a0,0
  2e:	26e000ef          	jal	29c <exit>

0000000000000032 <start>:
  32:	1141                	addi	sp,sp,-16
  34:	e406                	sd	ra,8(sp)
  36:	e022                	sd	s0,0(sp)
  38:	0800                	addi	s0,sp,16
  3a:	fc7ff0ef          	jal	0 <main>
  3e:	4501                	li	a0,0
  40:	25c000ef          	jal	29c <exit>

0000000000000044 <strcpy>:
  44:	1141                	addi	sp,sp,-16
  46:	e422                	sd	s0,8(sp)
  48:	0800                	addi	s0,sp,16
  4a:	87aa                	mv	a5,a0
  4c:	0585                	addi	a1,a1,1
  4e:	0785                	addi	a5,a5,1
  50:	fff5c703          	lbu	a4,-1(a1)
  54:	fee78fa3          	sb	a4,-1(a5)
  58:	fb75                	bnez	a4,4c <strcpy+0x8>
  5a:	6422                	ld	s0,8(sp)
  5c:	0141                	addi	sp,sp,16
  5e:	8082                	ret

0000000000000060 <strcmp>:
  60:	1141                	addi	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	addi	s0,sp,16
  66:	00054783          	lbu	a5,0(a0)
  6a:	cb91                	beqz	a5,7e <strcmp+0x1e>
  6c:	0005c703          	lbu	a4,0(a1)
  70:	00f71763          	bne	a4,a5,7e <strcmp+0x1e>
  74:	0505                	addi	a0,a0,1
  76:	0585                	addi	a1,a1,1
  78:	00054783          	lbu	a5,0(a0)
  7c:	fbe5                	bnez	a5,6c <strcmp+0xc>
  7e:	0005c503          	lbu	a0,0(a1)
  82:	40a7853b          	subw	a0,a5,a0
  86:	6422                	ld	s0,8(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret

000000000000008c <strlen>:
  8c:	1141                	addi	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	addi	s0,sp,16
  92:	00054783          	lbu	a5,0(a0)
  96:	cf91                	beqz	a5,b2 <strlen+0x26>
  98:	0505                	addi	a0,a0,1
  9a:	87aa                	mv	a5,a0
  9c:	86be                	mv	a3,a5
  9e:	0785                	addi	a5,a5,1
  a0:	fff7c703          	lbu	a4,-1(a5)
  a4:	ff65                	bnez	a4,9c <strlen+0x10>
  a6:	40a6853b          	subw	a0,a3,a0
  aa:	2505                	addiw	a0,a0,1
  ac:	6422                	ld	s0,8(sp)
  ae:	0141                	addi	sp,sp,16
  b0:	8082                	ret
  b2:	4501                	li	a0,0
  b4:	bfe5                	j	ac <strlen+0x20>

00000000000000b6 <memset>:
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  bc:	ca19                	beqz	a2,d2 <memset+0x1c>
  be:	87aa                	mv	a5,a0
  c0:	1602                	slli	a2,a2,0x20
  c2:	9201                	srli	a2,a2,0x20
  c4:	00a60733          	add	a4,a2,a0
  c8:	00b78023          	sb	a1,0(a5)
  cc:	0785                	addi	a5,a5,1
  ce:	fee79de3          	bne	a5,a4,c8 <memset+0x12>
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strchr>:
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  de:	00054783          	lbu	a5,0(a0)
  e2:	cb99                	beqz	a5,f8 <strchr+0x20>
  e4:	00f58763          	beq	a1,a5,f2 <strchr+0x1a>
  e8:	0505                	addi	a0,a0,1
  ea:	00054783          	lbu	a5,0(a0)
  ee:	fbfd                	bnez	a5,e4 <strchr+0xc>
  f0:	4501                	li	a0,0
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret
  f8:	4501                	li	a0,0
  fa:	bfe5                	j	f2 <strchr+0x1a>

00000000000000fc <gets>:
  fc:	711d                	addi	sp,sp,-96
  fe:	ec86                	sd	ra,88(sp)
 100:	e8a2                	sd	s0,80(sp)
 102:	e4a6                	sd	s1,72(sp)
 104:	e0ca                	sd	s2,64(sp)
 106:	fc4e                	sd	s3,56(sp)
 108:	f852                	sd	s4,48(sp)
 10a:	f456                	sd	s5,40(sp)
 10c:	f05a                	sd	s6,32(sp)
 10e:	ec5e                	sd	s7,24(sp)
 110:	1080                	addi	s0,sp,96
 112:	8baa                	mv	s7,a0
 114:	8a2e                	mv	s4,a1
 116:	892a                	mv	s2,a0
 118:	4481                	li	s1,0
 11a:	4aa9                	li	s5,10
 11c:	4b35                	li	s6,13
 11e:	89a6                	mv	s3,s1
 120:	2485                	addiw	s1,s1,1
 122:	0344d663          	bge	s1,s4,14e <gets+0x52>
 126:	4605                	li	a2,1
 128:	faf40593          	addi	a1,s0,-81
 12c:	4501                	li	a0,0
 12e:	186000ef          	jal	2b4 <read>
 132:	00a05e63          	blez	a0,14e <gets+0x52>
 136:	faf44783          	lbu	a5,-81(s0)
 13a:	00f90023          	sb	a5,0(s2)
 13e:	01578763          	beq	a5,s5,14c <gets+0x50>
 142:	0905                	addi	s2,s2,1
 144:	fd679de3          	bne	a5,s6,11e <gets+0x22>
 148:	89a6                	mv	s3,s1
 14a:	a011                	j	14e <gets+0x52>
 14c:	89a6                	mv	s3,s1
 14e:	99de                	add	s3,s3,s7
 150:	00098023          	sb	zero,0(s3)
 154:	855e                	mv	a0,s7
 156:	60e6                	ld	ra,88(sp)
 158:	6446                	ld	s0,80(sp)
 15a:	64a6                	ld	s1,72(sp)
 15c:	6906                	ld	s2,64(sp)
 15e:	79e2                	ld	s3,56(sp)
 160:	7a42                	ld	s4,48(sp)
 162:	7aa2                	ld	s5,40(sp)
 164:	7b02                	ld	s6,32(sp)
 166:	6be2                	ld	s7,24(sp)
 168:	6125                	addi	sp,sp,96
 16a:	8082                	ret

000000000000016c <stat>:
 16c:	1101                	addi	sp,sp,-32
 16e:	ec06                	sd	ra,24(sp)
 170:	e822                	sd	s0,16(sp)
 172:	e04a                	sd	s2,0(sp)
 174:	1000                	addi	s0,sp,32
 176:	892e                	mv	s2,a1
 178:	4581                	li	a1,0
 17a:	162000ef          	jal	2dc <open>
 17e:	02054263          	bltz	a0,1a2 <stat+0x36>
 182:	e426                	sd	s1,8(sp)
 184:	84aa                	mv	s1,a0
 186:	85ca                	mv	a1,s2
 188:	16c000ef          	jal	2f4 <fstat>
 18c:	892a                	mv	s2,a0
 18e:	8526                	mv	a0,s1
 190:	134000ef          	jal	2c4 <close>
 194:	64a2                	ld	s1,8(sp)
 196:	854a                	mv	a0,s2
 198:	60e2                	ld	ra,24(sp)
 19a:	6442                	ld	s0,16(sp)
 19c:	6902                	ld	s2,0(sp)
 19e:	6105                	addi	sp,sp,32
 1a0:	8082                	ret
 1a2:	597d                	li	s2,-1
 1a4:	bfcd                	j	196 <stat+0x2a>

00000000000001a6 <atoi>:
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
 1ac:	00054683          	lbu	a3,0(a0)
 1b0:	fd06879b          	addiw	a5,a3,-48
 1b4:	0ff7f793          	zext.b	a5,a5
 1b8:	4625                	li	a2,9
 1ba:	02f66863          	bltu	a2,a5,1ea <atoi+0x44>
 1be:	872a                	mv	a4,a0
 1c0:	4501                	li	a0,0
 1c2:	0705                	addi	a4,a4,1
 1c4:	0025179b          	slliw	a5,a0,0x2
 1c8:	9fa9                	addw	a5,a5,a0
 1ca:	0017979b          	slliw	a5,a5,0x1
 1ce:	9fb5                	addw	a5,a5,a3
 1d0:	fd07851b          	addiw	a0,a5,-48
 1d4:	00074683          	lbu	a3,0(a4)
 1d8:	fd06879b          	addiw	a5,a3,-48
 1dc:	0ff7f793          	zext.b	a5,a5
 1e0:	fef671e3          	bgeu	a2,a5,1c2 <atoi+0x1c>
 1e4:	6422                	ld	s0,8(sp)
 1e6:	0141                	addi	sp,sp,16
 1e8:	8082                	ret
 1ea:	4501                	li	a0,0
 1ec:	bfe5                	j	1e4 <atoi+0x3e>

00000000000001ee <memmove>:
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e422                	sd	s0,8(sp)
 1f2:	0800                	addi	s0,sp,16
 1f4:	02b57463          	bgeu	a0,a1,21c <memmove+0x2e>
 1f8:	00c05f63          	blez	a2,216 <memmove+0x28>
 1fc:	1602                	slli	a2,a2,0x20
 1fe:	9201                	srli	a2,a2,0x20
 200:	00c507b3          	add	a5,a0,a2
 204:	872a                	mv	a4,a0
 206:	0585                	addi	a1,a1,1
 208:	0705                	addi	a4,a4,1
 20a:	fff5c683          	lbu	a3,-1(a1)
 20e:	fed70fa3          	sb	a3,-1(a4)
 212:	fef71ae3          	bne	a4,a5,206 <memmove+0x18>
 216:	6422                	ld	s0,8(sp)
 218:	0141                	addi	sp,sp,16
 21a:	8082                	ret
 21c:	00c50733          	add	a4,a0,a2
 220:	95b2                	add	a1,a1,a2
 222:	fec05ae3          	blez	a2,216 <memmove+0x28>
 226:	fff6079b          	addiw	a5,a2,-1
 22a:	1782                	slli	a5,a5,0x20
 22c:	9381                	srli	a5,a5,0x20
 22e:	fff7c793          	not	a5,a5
 232:	97ba                	add	a5,a5,a4
 234:	15fd                	addi	a1,a1,-1
 236:	177d                	addi	a4,a4,-1
 238:	0005c683          	lbu	a3,0(a1)
 23c:	00d70023          	sb	a3,0(a4)
 240:	fee79ae3          	bne	a5,a4,234 <memmove+0x46>
 244:	bfc9                	j	216 <memmove+0x28>

0000000000000246 <memcmp>:
 246:	1141                	addi	sp,sp,-16
 248:	e422                	sd	s0,8(sp)
 24a:	0800                	addi	s0,sp,16
 24c:	ca05                	beqz	a2,27c <memcmp+0x36>
 24e:	fff6069b          	addiw	a3,a2,-1
 252:	1682                	slli	a3,a3,0x20
 254:	9281                	srli	a3,a3,0x20
 256:	0685                	addi	a3,a3,1
 258:	96aa                	add	a3,a3,a0
 25a:	00054783          	lbu	a5,0(a0)
 25e:	0005c703          	lbu	a4,0(a1)
 262:	00e79863          	bne	a5,a4,272 <memcmp+0x2c>
 266:	0505                	addi	a0,a0,1
 268:	0585                	addi	a1,a1,1
 26a:	fed518e3          	bne	a0,a3,25a <memcmp+0x14>
 26e:	4501                	li	a0,0
 270:	a019                	j	276 <memcmp+0x30>
 272:	40e7853b          	subw	a0,a5,a4
 276:	6422                	ld	s0,8(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
 27c:	4501                	li	a0,0
 27e:	bfe5                	j	276 <memcmp+0x30>

0000000000000280 <memcpy>:
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
 288:	f67ff0ef          	jal	1ee <memmove>
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret

0000000000000294 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 294:	4885                	li	a7,1
 ecall
 296:	00000073          	ecall
 ret
 29a:	8082                	ret

000000000000029c <exit>:
.global exit
exit:
 li a7, SYS_exit
 29c:	4889                	li	a7,2
 ecall
 29e:	00000073          	ecall
 ret
 2a2:	8082                	ret

00000000000002a4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2a4:	488d                	li	a7,3
 ecall
 2a6:	00000073          	ecall
 ret
 2aa:	8082                	ret

00000000000002ac <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ac:	4891                	li	a7,4
 ecall
 2ae:	00000073          	ecall
 ret
 2b2:	8082                	ret

00000000000002b4 <read>:
.global read
read:
 li a7, SYS_read
 2b4:	4895                	li	a7,5
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <write>:
.global write
write:
 li a7, SYS_write
 2bc:	48c1                	li	a7,16
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <close>:
.global close
close:
 li a7, SYS_close
 2c4:	48d5                	li	a7,21
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <kill>:
.global kill
kill:
 li a7, SYS_kill
 2cc:	4899                	li	a7,6
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2d4:	489d                	li	a7,7
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <open>:
.global open
open:
 li a7, SYS_open
 2dc:	48bd                	li	a7,15
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2e4:	48c5                	li	a7,17
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2ec:	48c9                	li	a7,18
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2f4:	48a1                	li	a7,8
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <link>:
.global link
link:
 li a7, SYS_link
 2fc:	48cd                	li	a7,19
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 304:	48d1                	li	a7,20
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 30c:	48a5                	li	a7,9
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <dup>:
.global dup
dup:
 li a7, SYS_dup
 314:	48a9                	li	a7,10
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 31c:	48ad                	li	a7,11
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 324:	48b1                	li	a7,12
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 32c:	48b5                	li	a7,13
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 334:	48b9                	li	a7,14
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 33c:	48d9                	li	a7,22
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 344:	48dd                	li	a7,23
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 34c:	48e1                	li	a7,24
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 354:	48e5                	li	a7,25
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 35c:	1101                	addi	sp,sp,-32
 35e:	ec06                	sd	ra,24(sp)
 360:	e822                	sd	s0,16(sp)
 362:	1000                	addi	s0,sp,32
 364:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 368:	4605                	li	a2,1
 36a:	fef40593          	addi	a1,s0,-17
 36e:	f4fff0ef          	jal	2bc <write>
}
 372:	60e2                	ld	ra,24(sp)
 374:	6442                	ld	s0,16(sp)
 376:	6105                	addi	sp,sp,32
 378:	8082                	ret

000000000000037a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 37a:	7139                	addi	sp,sp,-64
 37c:	fc06                	sd	ra,56(sp)
 37e:	f822                	sd	s0,48(sp)
 380:	f426                	sd	s1,40(sp)
 382:	0080                	addi	s0,sp,64
 384:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 386:	c299                	beqz	a3,38c <printint+0x12>
 388:	0805c963          	bltz	a1,41a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 38c:	2581                	sext.w	a1,a1
  neg = 0;
 38e:	4881                	li	a7,0
 390:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 394:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 396:	2601                	sext.w	a2,a2
 398:	00000517          	auipc	a0,0x0
 39c:	4f850513          	addi	a0,a0,1272 # 890 <digits>
 3a0:	883a                	mv	a6,a4
 3a2:	2705                	addiw	a4,a4,1
 3a4:	02c5f7bb          	remuw	a5,a1,a2
 3a8:	1782                	slli	a5,a5,0x20
 3aa:	9381                	srli	a5,a5,0x20
 3ac:	97aa                	add	a5,a5,a0
 3ae:	0007c783          	lbu	a5,0(a5)
 3b2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3b6:	0005879b          	sext.w	a5,a1
 3ba:	02c5d5bb          	divuw	a1,a1,a2
 3be:	0685                	addi	a3,a3,1
 3c0:	fec7f0e3          	bgeu	a5,a2,3a0 <printint+0x26>
  if(neg)
 3c4:	00088c63          	beqz	a7,3dc <printint+0x62>
    buf[i++] = '-';
 3c8:	fd070793          	addi	a5,a4,-48
 3cc:	00878733          	add	a4,a5,s0
 3d0:	02d00793          	li	a5,45
 3d4:	fef70823          	sb	a5,-16(a4)
 3d8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3dc:	02e05a63          	blez	a4,410 <printint+0x96>
 3e0:	f04a                	sd	s2,32(sp)
 3e2:	ec4e                	sd	s3,24(sp)
 3e4:	fc040793          	addi	a5,s0,-64
 3e8:	00e78933          	add	s2,a5,a4
 3ec:	fff78993          	addi	s3,a5,-1
 3f0:	99ba                	add	s3,s3,a4
 3f2:	377d                	addiw	a4,a4,-1
 3f4:	1702                	slli	a4,a4,0x20
 3f6:	9301                	srli	a4,a4,0x20
 3f8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3fc:	fff94583          	lbu	a1,-1(s2)
 400:	8526                	mv	a0,s1
 402:	f5bff0ef          	jal	35c <putc>
  while(--i >= 0)
 406:	197d                	addi	s2,s2,-1
 408:	ff391ae3          	bne	s2,s3,3fc <printint+0x82>
 40c:	7902                	ld	s2,32(sp)
 40e:	69e2                	ld	s3,24(sp)
}
 410:	70e2                	ld	ra,56(sp)
 412:	7442                	ld	s0,48(sp)
 414:	74a2                	ld	s1,40(sp)
 416:	6121                	addi	sp,sp,64
 418:	8082                	ret
    x = -xx;
 41a:	40b005bb          	negw	a1,a1
    neg = 1;
 41e:	4885                	li	a7,1
    x = -xx;
 420:	bf85                	j	390 <printint+0x16>

0000000000000422 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 422:	711d                	addi	sp,sp,-96
 424:	ec86                	sd	ra,88(sp)
 426:	e8a2                	sd	s0,80(sp)
 428:	e0ca                	sd	s2,64(sp)
 42a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 42c:	0005c903          	lbu	s2,0(a1)
 430:	26090863          	beqz	s2,6a0 <vprintf+0x27e>
 434:	e4a6                	sd	s1,72(sp)
 436:	fc4e                	sd	s3,56(sp)
 438:	f852                	sd	s4,48(sp)
 43a:	f456                	sd	s5,40(sp)
 43c:	f05a                	sd	s6,32(sp)
 43e:	ec5e                	sd	s7,24(sp)
 440:	e862                	sd	s8,16(sp)
 442:	e466                	sd	s9,8(sp)
 444:	8b2a                	mv	s6,a0
 446:	8a2e                	mv	s4,a1
 448:	8bb2                	mv	s7,a2
  state = 0;
 44a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 44c:	4481                	li	s1,0
 44e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 450:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 454:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 458:	06c00c93          	li	s9,108
 45c:	a005                	j	47c <vprintf+0x5a>
        putc(fd, c0);
 45e:	85ca                	mv	a1,s2
 460:	855a                	mv	a0,s6
 462:	efbff0ef          	jal	35c <putc>
 466:	a019                	j	46c <vprintf+0x4a>
    } else if(state == '%'){
 468:	03598263          	beq	s3,s5,48c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 46c:	2485                	addiw	s1,s1,1
 46e:	8726                	mv	a4,s1
 470:	009a07b3          	add	a5,s4,s1
 474:	0007c903          	lbu	s2,0(a5)
 478:	20090c63          	beqz	s2,690 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 47c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 480:	fe0994e3          	bnez	s3,468 <vprintf+0x46>
      if(c0 == '%'){
 484:	fd579de3          	bne	a5,s5,45e <vprintf+0x3c>
        state = '%';
 488:	89be                	mv	s3,a5
 48a:	b7cd                	j	46c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 48c:	00ea06b3          	add	a3,s4,a4
 490:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 494:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 496:	c681                	beqz	a3,49e <vprintf+0x7c>
 498:	9752                	add	a4,a4,s4
 49a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 49e:	03878f63          	beq	a5,s8,4dc <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4a2:	05978963          	beq	a5,s9,4f4 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4a6:	07500713          	li	a4,117
 4aa:	0ee78363          	beq	a5,a4,590 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4ae:	07800713          	li	a4,120
 4b2:	12e78563          	beq	a5,a4,5dc <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4b6:	07000713          	li	a4,112
 4ba:	14e78a63          	beq	a5,a4,60e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4be:	07300713          	li	a4,115
 4c2:	18e78a63          	beq	a5,a4,656 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4c6:	02500713          	li	a4,37
 4ca:	04e79563          	bne	a5,a4,514 <vprintf+0xf2>
        putc(fd, '%');
 4ce:	02500593          	li	a1,37
 4d2:	855a                	mv	a0,s6
 4d4:	e89ff0ef          	jal	35c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4d8:	4981                	li	s3,0
 4da:	bf49                	j	46c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4dc:	008b8913          	addi	s2,s7,8
 4e0:	4685                	li	a3,1
 4e2:	4629                	li	a2,10
 4e4:	000ba583          	lw	a1,0(s7)
 4e8:	855a                	mv	a0,s6
 4ea:	e91ff0ef          	jal	37a <printint>
 4ee:	8bca                	mv	s7,s2
      state = 0;
 4f0:	4981                	li	s3,0
 4f2:	bfad                	j	46c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4f4:	06400793          	li	a5,100
 4f8:	02f68963          	beq	a3,a5,52a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4fc:	06c00793          	li	a5,108
 500:	04f68263          	beq	a3,a5,544 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 504:	07500793          	li	a5,117
 508:	0af68063          	beq	a3,a5,5a8 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 50c:	07800793          	li	a5,120
 510:	0ef68263          	beq	a3,a5,5f4 <vprintf+0x1d2>
        putc(fd, '%');
 514:	02500593          	li	a1,37
 518:	855a                	mv	a0,s6
 51a:	e43ff0ef          	jal	35c <putc>
        putc(fd, c0);
 51e:	85ca                	mv	a1,s2
 520:	855a                	mv	a0,s6
 522:	e3bff0ef          	jal	35c <putc>
      state = 0;
 526:	4981                	li	s3,0
 528:	b791                	j	46c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 52a:	008b8913          	addi	s2,s7,8
 52e:	4685                	li	a3,1
 530:	4629                	li	a2,10
 532:	000ba583          	lw	a1,0(s7)
 536:	855a                	mv	a0,s6
 538:	e43ff0ef          	jal	37a <printint>
        i += 1;
 53c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 53e:	8bca                	mv	s7,s2
      state = 0;
 540:	4981                	li	s3,0
        i += 1;
 542:	b72d                	j	46c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 544:	06400793          	li	a5,100
 548:	02f60763          	beq	a2,a5,576 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 54c:	07500793          	li	a5,117
 550:	06f60963          	beq	a2,a5,5c2 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 554:	07800793          	li	a5,120
 558:	faf61ee3          	bne	a2,a5,514 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 55c:	008b8913          	addi	s2,s7,8
 560:	4681                	li	a3,0
 562:	4641                	li	a2,16
 564:	000ba583          	lw	a1,0(s7)
 568:	855a                	mv	a0,s6
 56a:	e11ff0ef          	jal	37a <printint>
        i += 2;
 56e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 570:	8bca                	mv	s7,s2
      state = 0;
 572:	4981                	li	s3,0
        i += 2;
 574:	bde5                	j	46c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 576:	008b8913          	addi	s2,s7,8
 57a:	4685                	li	a3,1
 57c:	4629                	li	a2,10
 57e:	000ba583          	lw	a1,0(s7)
 582:	855a                	mv	a0,s6
 584:	df7ff0ef          	jal	37a <printint>
        i += 2;
 588:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 58a:	8bca                	mv	s7,s2
      state = 0;
 58c:	4981                	li	s3,0
        i += 2;
 58e:	bdf9                	j	46c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 590:	008b8913          	addi	s2,s7,8
 594:	4681                	li	a3,0
 596:	4629                	li	a2,10
 598:	000ba583          	lw	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	dddff0ef          	jal	37a <printint>
 5a2:	8bca                	mv	s7,s2
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	b5d9                	j	46c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a8:	008b8913          	addi	s2,s7,8
 5ac:	4681                	li	a3,0
 5ae:	4629                	li	a2,10
 5b0:	000ba583          	lw	a1,0(s7)
 5b4:	855a                	mv	a0,s6
 5b6:	dc5ff0ef          	jal	37a <printint>
        i += 1;
 5ba:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5bc:	8bca                	mv	s7,s2
      state = 0;
 5be:	4981                	li	s3,0
        i += 1;
 5c0:	b575                	j	46c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c2:	008b8913          	addi	s2,s7,8
 5c6:	4681                	li	a3,0
 5c8:	4629                	li	a2,10
 5ca:	000ba583          	lw	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	dabff0ef          	jal	37a <printint>
        i += 2;
 5d4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d6:	8bca                	mv	s7,s2
      state = 0;
 5d8:	4981                	li	s3,0
        i += 2;
 5da:	bd49                	j	46c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5dc:	008b8913          	addi	s2,s7,8
 5e0:	4681                	li	a3,0
 5e2:	4641                	li	a2,16
 5e4:	000ba583          	lw	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	d91ff0ef          	jal	37a <printint>
 5ee:	8bca                	mv	s7,s2
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	bdad                	j	46c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f4:	008b8913          	addi	s2,s7,8
 5f8:	4681                	li	a3,0
 5fa:	4641                	li	a2,16
 5fc:	000ba583          	lw	a1,0(s7)
 600:	855a                	mv	a0,s6
 602:	d79ff0ef          	jal	37a <printint>
        i += 1;
 606:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 608:	8bca                	mv	s7,s2
      state = 0;
 60a:	4981                	li	s3,0
        i += 1;
 60c:	b585                	j	46c <vprintf+0x4a>
 60e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 610:	008b8d13          	addi	s10,s7,8
 614:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 618:	03000593          	li	a1,48
 61c:	855a                	mv	a0,s6
 61e:	d3fff0ef          	jal	35c <putc>
  putc(fd, 'x');
 622:	07800593          	li	a1,120
 626:	855a                	mv	a0,s6
 628:	d35ff0ef          	jal	35c <putc>
 62c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 62e:	00000b97          	auipc	s7,0x0
 632:	262b8b93          	addi	s7,s7,610 # 890 <digits>
 636:	03c9d793          	srli	a5,s3,0x3c
 63a:	97de                	add	a5,a5,s7
 63c:	0007c583          	lbu	a1,0(a5)
 640:	855a                	mv	a0,s6
 642:	d1bff0ef          	jal	35c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 646:	0992                	slli	s3,s3,0x4
 648:	397d                	addiw	s2,s2,-1
 64a:	fe0916e3          	bnez	s2,636 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 64e:	8bea                	mv	s7,s10
      state = 0;
 650:	4981                	li	s3,0
 652:	6d02                	ld	s10,0(sp)
 654:	bd21                	j	46c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 656:	008b8993          	addi	s3,s7,8
 65a:	000bb903          	ld	s2,0(s7)
 65e:	00090f63          	beqz	s2,67c <vprintf+0x25a>
        for(; *s; s++)
 662:	00094583          	lbu	a1,0(s2)
 666:	c195                	beqz	a1,68a <vprintf+0x268>
          putc(fd, *s);
 668:	855a                	mv	a0,s6
 66a:	cf3ff0ef          	jal	35c <putc>
        for(; *s; s++)
 66e:	0905                	addi	s2,s2,1
 670:	00094583          	lbu	a1,0(s2)
 674:	f9f5                	bnez	a1,668 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 676:	8bce                	mv	s7,s3
      state = 0;
 678:	4981                	li	s3,0
 67a:	bbcd                	j	46c <vprintf+0x4a>
          s = "(null)";
 67c:	00000917          	auipc	s2,0x0
 680:	20c90913          	addi	s2,s2,524 # 888 <malloc+0x100>
        for(; *s; s++)
 684:	02800593          	li	a1,40
 688:	b7c5                	j	668 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 68a:	8bce                	mv	s7,s3
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bbf9                	j	46c <vprintf+0x4a>
 690:	64a6                	ld	s1,72(sp)
 692:	79e2                	ld	s3,56(sp)
 694:	7a42                	ld	s4,48(sp)
 696:	7aa2                	ld	s5,40(sp)
 698:	7b02                	ld	s6,32(sp)
 69a:	6be2                	ld	s7,24(sp)
 69c:	6c42                	ld	s8,16(sp)
 69e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6a0:	60e6                	ld	ra,88(sp)
 6a2:	6446                	ld	s0,80(sp)
 6a4:	6906                	ld	s2,64(sp)
 6a6:	6125                	addi	sp,sp,96
 6a8:	8082                	ret

00000000000006aa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6aa:	715d                	addi	sp,sp,-80
 6ac:	ec06                	sd	ra,24(sp)
 6ae:	e822                	sd	s0,16(sp)
 6b0:	1000                	addi	s0,sp,32
 6b2:	e010                	sd	a2,0(s0)
 6b4:	e414                	sd	a3,8(s0)
 6b6:	e818                	sd	a4,16(s0)
 6b8:	ec1c                	sd	a5,24(s0)
 6ba:	03043023          	sd	a6,32(s0)
 6be:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6c2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6c6:	8622                	mv	a2,s0
 6c8:	d5bff0ef          	jal	422 <vprintf>
}
 6cc:	60e2                	ld	ra,24(sp)
 6ce:	6442                	ld	s0,16(sp)
 6d0:	6161                	addi	sp,sp,80
 6d2:	8082                	ret

00000000000006d4 <printf>:

void
printf(const char *fmt, ...)
{
 6d4:	711d                	addi	sp,sp,-96
 6d6:	ec06                	sd	ra,24(sp)
 6d8:	e822                	sd	s0,16(sp)
 6da:	1000                	addi	s0,sp,32
 6dc:	e40c                	sd	a1,8(s0)
 6de:	e810                	sd	a2,16(s0)
 6e0:	ec14                	sd	a3,24(s0)
 6e2:	f018                	sd	a4,32(s0)
 6e4:	f41c                	sd	a5,40(s0)
 6e6:	03043823          	sd	a6,48(s0)
 6ea:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ee:	00840613          	addi	a2,s0,8
 6f2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6f6:	85aa                	mv	a1,a0
 6f8:	4505                	li	a0,1
 6fa:	d29ff0ef          	jal	422 <vprintf>
}
 6fe:	60e2                	ld	ra,24(sp)
 700:	6442                	ld	s0,16(sp)
 702:	6125                	addi	sp,sp,96
 704:	8082                	ret

0000000000000706 <free>:
 706:	1141                	addi	sp,sp,-16
 708:	e422                	sd	s0,8(sp)
 70a:	0800                	addi	s0,sp,16
 70c:	ff050693          	addi	a3,a0,-16
 710:	00001797          	auipc	a5,0x1
 714:	8f07b783          	ld	a5,-1808(a5) # 1000 <freep>
 718:	a02d                	j	742 <free+0x3c>
 71a:	4618                	lw	a4,8(a2)
 71c:	9f2d                	addw	a4,a4,a1
 71e:	fee52c23          	sw	a4,-8(a0)
 722:	6398                	ld	a4,0(a5)
 724:	6310                	ld	a2,0(a4)
 726:	a83d                	j	764 <free+0x5e>
 728:	ff852703          	lw	a4,-8(a0)
 72c:	9f31                	addw	a4,a4,a2
 72e:	c798                	sw	a4,8(a5)
 730:	ff053683          	ld	a3,-16(a0)
 734:	a091                	j	778 <free+0x72>
 736:	6398                	ld	a4,0(a5)
 738:	00e7e463          	bltu	a5,a4,740 <free+0x3a>
 73c:	00e6ea63          	bltu	a3,a4,750 <free+0x4a>
 740:	87ba                	mv	a5,a4
 742:	fed7fae3          	bgeu	a5,a3,736 <free+0x30>
 746:	6398                	ld	a4,0(a5)
 748:	00e6e463          	bltu	a3,a4,750 <free+0x4a>
 74c:	fee7eae3          	bltu	a5,a4,740 <free+0x3a>
 750:	ff852583          	lw	a1,-8(a0)
 754:	6390                	ld	a2,0(a5)
 756:	02059813          	slli	a6,a1,0x20
 75a:	01c85713          	srli	a4,a6,0x1c
 75e:	9736                	add	a4,a4,a3
 760:	fae60de3          	beq	a2,a4,71a <free+0x14>
 764:	fec53823          	sd	a2,-16(a0)
 768:	4790                	lw	a2,8(a5)
 76a:	02061593          	slli	a1,a2,0x20
 76e:	01c5d713          	srli	a4,a1,0x1c
 772:	973e                	add	a4,a4,a5
 774:	fae68ae3          	beq	a3,a4,728 <free+0x22>
 778:	e394                	sd	a3,0(a5)
 77a:	00001717          	auipc	a4,0x1
 77e:	88f73323          	sd	a5,-1914(a4) # 1000 <freep>
 782:	6422                	ld	s0,8(sp)
 784:	0141                	addi	sp,sp,16
 786:	8082                	ret

0000000000000788 <malloc>:
 788:	7139                	addi	sp,sp,-64
 78a:	fc06                	sd	ra,56(sp)
 78c:	f822                	sd	s0,48(sp)
 78e:	f426                	sd	s1,40(sp)
 790:	ec4e                	sd	s3,24(sp)
 792:	0080                	addi	s0,sp,64
 794:	02051493          	slli	s1,a0,0x20
 798:	9081                	srli	s1,s1,0x20
 79a:	04bd                	addi	s1,s1,15
 79c:	8091                	srli	s1,s1,0x4
 79e:	0014899b          	addiw	s3,s1,1
 7a2:	0485                	addi	s1,s1,1
 7a4:	00001517          	auipc	a0,0x1
 7a8:	85c53503          	ld	a0,-1956(a0) # 1000 <freep>
 7ac:	c915                	beqz	a0,7e0 <malloc+0x58>
 7ae:	611c                	ld	a5,0(a0)
 7b0:	4798                	lw	a4,8(a5)
 7b2:	08977a63          	bgeu	a4,s1,846 <malloc+0xbe>
 7b6:	f04a                	sd	s2,32(sp)
 7b8:	e852                	sd	s4,16(sp)
 7ba:	e456                	sd	s5,8(sp)
 7bc:	e05a                	sd	s6,0(sp)
 7be:	8a4e                	mv	s4,s3
 7c0:	0009871b          	sext.w	a4,s3
 7c4:	6685                	lui	a3,0x1
 7c6:	00d77363          	bgeu	a4,a3,7cc <malloc+0x44>
 7ca:	6a05                	lui	s4,0x1
 7cc:	000a0b1b          	sext.w	s6,s4
 7d0:	004a1a1b          	slliw	s4,s4,0x4
 7d4:	00001917          	auipc	s2,0x1
 7d8:	82c90913          	addi	s2,s2,-2004 # 1000 <freep>
 7dc:	5afd                	li	s5,-1
 7de:	a081                	j	81e <malloc+0x96>
 7e0:	f04a                	sd	s2,32(sp)
 7e2:	e852                	sd	s4,16(sp)
 7e4:	e456                	sd	s5,8(sp)
 7e6:	e05a                	sd	s6,0(sp)
 7e8:	00001797          	auipc	a5,0x1
 7ec:	82878793          	addi	a5,a5,-2008 # 1010 <base>
 7f0:	00001717          	auipc	a4,0x1
 7f4:	80f73823          	sd	a5,-2032(a4) # 1000 <freep>
 7f8:	e39c                	sd	a5,0(a5)
 7fa:	0007a423          	sw	zero,8(a5)
 7fe:	b7c1                	j	7be <malloc+0x36>
 800:	6398                	ld	a4,0(a5)
 802:	e118                	sd	a4,0(a0)
 804:	a8a9                	j	85e <malloc+0xd6>
 806:	01652423          	sw	s6,8(a0)
 80a:	0541                	addi	a0,a0,16
 80c:	efbff0ef          	jal	706 <free>
 810:	00093503          	ld	a0,0(s2)
 814:	c12d                	beqz	a0,876 <malloc+0xee>
 816:	611c                	ld	a5,0(a0)
 818:	4798                	lw	a4,8(a5)
 81a:	02977263          	bgeu	a4,s1,83e <malloc+0xb6>
 81e:	00093703          	ld	a4,0(s2)
 822:	853e                	mv	a0,a5
 824:	fef719e3          	bne	a4,a5,816 <malloc+0x8e>
 828:	8552                	mv	a0,s4
 82a:	afbff0ef          	jal	324 <sbrk>
 82e:	fd551ce3          	bne	a0,s5,806 <malloc+0x7e>
 832:	4501                	li	a0,0
 834:	7902                	ld	s2,32(sp)
 836:	6a42                	ld	s4,16(sp)
 838:	6aa2                	ld	s5,8(sp)
 83a:	6b02                	ld	s6,0(sp)
 83c:	a03d                	j	86a <malloc+0xe2>
 83e:	7902                	ld	s2,32(sp)
 840:	6a42                	ld	s4,16(sp)
 842:	6aa2                	ld	s5,8(sp)
 844:	6b02                	ld	s6,0(sp)
 846:	fae48de3          	beq	s1,a4,800 <malloc+0x78>
 84a:	4137073b          	subw	a4,a4,s3
 84e:	c798                	sw	a4,8(a5)
 850:	02071693          	slli	a3,a4,0x20
 854:	01c6d713          	srli	a4,a3,0x1c
 858:	97ba                	add	a5,a5,a4
 85a:	0137a423          	sw	s3,8(a5)
 85e:	00000717          	auipc	a4,0x0
 862:	7aa73123          	sd	a0,1954(a4) # 1000 <freep>
 866:	01078513          	addi	a0,a5,16
 86a:	70e2                	ld	ra,56(sp)
 86c:	7442                	ld	s0,48(sp)
 86e:	74a2                	ld	s1,40(sp)
 870:	69e2                	ld	s3,24(sp)
 872:	6121                	addi	sp,sp,64
 874:	8082                	ret
 876:	7902                	ld	s2,32(sp)
 878:	6a42                	ld	s4,16(sp)
 87a:	6aa2                	ld	s5,8(sp)
 87c:	6b02                	ld	s6,0(sp)
 87e:	b7f5                	j	86a <malloc+0xe2>
