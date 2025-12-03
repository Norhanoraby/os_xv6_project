
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
  24:	87050513          	addi	a0,a0,-1936 # 890 <malloc+0x100>
  28:	6b4000ef          	jal	6dc <printf>

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

000000000000035c <rand>:
.global rand
rand:
 li a7, SYS_rand
 35c:	48ed                	li	a7,27
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 364:	1101                	addi	sp,sp,-32
 366:	ec06                	sd	ra,24(sp)
 368:	e822                	sd	s0,16(sp)
 36a:	1000                	addi	s0,sp,32
 36c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 370:	4605                	li	a2,1
 372:	fef40593          	addi	a1,s0,-17
 376:	f47ff0ef          	jal	2bc <write>
}
 37a:	60e2                	ld	ra,24(sp)
 37c:	6442                	ld	s0,16(sp)
 37e:	6105                	addi	sp,sp,32
 380:	8082                	ret

0000000000000382 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 382:	7139                	addi	sp,sp,-64
 384:	fc06                	sd	ra,56(sp)
 386:	f822                	sd	s0,48(sp)
 388:	f426                	sd	s1,40(sp)
 38a:	0080                	addi	s0,sp,64
 38c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 38e:	c299                	beqz	a3,394 <printint+0x12>
 390:	0805c963          	bltz	a1,422 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 394:	2581                	sext.w	a1,a1
  neg = 0;
 396:	4881                	li	a7,0
 398:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 39c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 39e:	2601                	sext.w	a2,a2
 3a0:	00000517          	auipc	a0,0x0
 3a4:	50050513          	addi	a0,a0,1280 # 8a0 <digits>
 3a8:	883a                	mv	a6,a4
 3aa:	2705                	addiw	a4,a4,1
 3ac:	02c5f7bb          	remuw	a5,a1,a2
 3b0:	1782                	slli	a5,a5,0x20
 3b2:	9381                	srli	a5,a5,0x20
 3b4:	97aa                	add	a5,a5,a0
 3b6:	0007c783          	lbu	a5,0(a5)
 3ba:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3be:	0005879b          	sext.w	a5,a1
 3c2:	02c5d5bb          	divuw	a1,a1,a2
 3c6:	0685                	addi	a3,a3,1
 3c8:	fec7f0e3          	bgeu	a5,a2,3a8 <printint+0x26>
  if(neg)
 3cc:	00088c63          	beqz	a7,3e4 <printint+0x62>
    buf[i++] = '-';
 3d0:	fd070793          	addi	a5,a4,-48
 3d4:	00878733          	add	a4,a5,s0
 3d8:	02d00793          	li	a5,45
 3dc:	fef70823          	sb	a5,-16(a4)
 3e0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3e4:	02e05a63          	blez	a4,418 <printint+0x96>
 3e8:	f04a                	sd	s2,32(sp)
 3ea:	ec4e                	sd	s3,24(sp)
 3ec:	fc040793          	addi	a5,s0,-64
 3f0:	00e78933          	add	s2,a5,a4
 3f4:	fff78993          	addi	s3,a5,-1
 3f8:	99ba                	add	s3,s3,a4
 3fa:	377d                	addiw	a4,a4,-1
 3fc:	1702                	slli	a4,a4,0x20
 3fe:	9301                	srli	a4,a4,0x20
 400:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 404:	fff94583          	lbu	a1,-1(s2)
 408:	8526                	mv	a0,s1
 40a:	f5bff0ef          	jal	364 <putc>
  while(--i >= 0)
 40e:	197d                	addi	s2,s2,-1
 410:	ff391ae3          	bne	s2,s3,404 <printint+0x82>
 414:	7902                	ld	s2,32(sp)
 416:	69e2                	ld	s3,24(sp)
}
 418:	70e2                	ld	ra,56(sp)
 41a:	7442                	ld	s0,48(sp)
 41c:	74a2                	ld	s1,40(sp)
 41e:	6121                	addi	sp,sp,64
 420:	8082                	ret
    x = -xx;
 422:	40b005bb          	negw	a1,a1
    neg = 1;
 426:	4885                	li	a7,1
    x = -xx;
 428:	bf85                	j	398 <printint+0x16>

000000000000042a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 42a:	711d                	addi	sp,sp,-96
 42c:	ec86                	sd	ra,88(sp)
 42e:	e8a2                	sd	s0,80(sp)
 430:	e0ca                	sd	s2,64(sp)
 432:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 434:	0005c903          	lbu	s2,0(a1)
 438:	26090863          	beqz	s2,6a8 <vprintf+0x27e>
 43c:	e4a6                	sd	s1,72(sp)
 43e:	fc4e                	sd	s3,56(sp)
 440:	f852                	sd	s4,48(sp)
 442:	f456                	sd	s5,40(sp)
 444:	f05a                	sd	s6,32(sp)
 446:	ec5e                	sd	s7,24(sp)
 448:	e862                	sd	s8,16(sp)
 44a:	e466                	sd	s9,8(sp)
 44c:	8b2a                	mv	s6,a0
 44e:	8a2e                	mv	s4,a1
 450:	8bb2                	mv	s7,a2
  state = 0;
 452:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 454:	4481                	li	s1,0
 456:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 458:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 45c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 460:	06c00c93          	li	s9,108
 464:	a005                	j	484 <vprintf+0x5a>
        putc(fd, c0);
 466:	85ca                	mv	a1,s2
 468:	855a                	mv	a0,s6
 46a:	efbff0ef          	jal	364 <putc>
 46e:	a019                	j	474 <vprintf+0x4a>
    } else if(state == '%'){
 470:	03598263          	beq	s3,s5,494 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 474:	2485                	addiw	s1,s1,1
 476:	8726                	mv	a4,s1
 478:	009a07b3          	add	a5,s4,s1
 47c:	0007c903          	lbu	s2,0(a5)
 480:	20090c63          	beqz	s2,698 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 484:	0009079b          	sext.w	a5,s2
    if(state == 0){
 488:	fe0994e3          	bnez	s3,470 <vprintf+0x46>
      if(c0 == '%'){
 48c:	fd579de3          	bne	a5,s5,466 <vprintf+0x3c>
        state = '%';
 490:	89be                	mv	s3,a5
 492:	b7cd                	j	474 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 494:	00ea06b3          	add	a3,s4,a4
 498:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 49c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 49e:	c681                	beqz	a3,4a6 <vprintf+0x7c>
 4a0:	9752                	add	a4,a4,s4
 4a2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4a6:	03878f63          	beq	a5,s8,4e4 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4aa:	05978963          	beq	a5,s9,4fc <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4ae:	07500713          	li	a4,117
 4b2:	0ee78363          	beq	a5,a4,598 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4b6:	07800713          	li	a4,120
 4ba:	12e78563          	beq	a5,a4,5e4 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4be:	07000713          	li	a4,112
 4c2:	14e78a63          	beq	a5,a4,616 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4c6:	07300713          	li	a4,115
 4ca:	18e78a63          	beq	a5,a4,65e <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4ce:	02500713          	li	a4,37
 4d2:	04e79563          	bne	a5,a4,51c <vprintf+0xf2>
        putc(fd, '%');
 4d6:	02500593          	li	a1,37
 4da:	855a                	mv	a0,s6
 4dc:	e89ff0ef          	jal	364 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4e0:	4981                	li	s3,0
 4e2:	bf49                	j	474 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4e4:	008b8913          	addi	s2,s7,8
 4e8:	4685                	li	a3,1
 4ea:	4629                	li	a2,10
 4ec:	000ba583          	lw	a1,0(s7)
 4f0:	855a                	mv	a0,s6
 4f2:	e91ff0ef          	jal	382 <printint>
 4f6:	8bca                	mv	s7,s2
      state = 0;
 4f8:	4981                	li	s3,0
 4fa:	bfad                	j	474 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4fc:	06400793          	li	a5,100
 500:	02f68963          	beq	a3,a5,532 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 504:	06c00793          	li	a5,108
 508:	04f68263          	beq	a3,a5,54c <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 50c:	07500793          	li	a5,117
 510:	0af68063          	beq	a3,a5,5b0 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 514:	07800793          	li	a5,120
 518:	0ef68263          	beq	a3,a5,5fc <vprintf+0x1d2>
        putc(fd, '%');
 51c:	02500593          	li	a1,37
 520:	855a                	mv	a0,s6
 522:	e43ff0ef          	jal	364 <putc>
        putc(fd, c0);
 526:	85ca                	mv	a1,s2
 528:	855a                	mv	a0,s6
 52a:	e3bff0ef          	jal	364 <putc>
      state = 0;
 52e:	4981                	li	s3,0
 530:	b791                	j	474 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 532:	008b8913          	addi	s2,s7,8
 536:	4685                	li	a3,1
 538:	4629                	li	a2,10
 53a:	000ba583          	lw	a1,0(s7)
 53e:	855a                	mv	a0,s6
 540:	e43ff0ef          	jal	382 <printint>
        i += 1;
 544:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 546:	8bca                	mv	s7,s2
      state = 0;
 548:	4981                	li	s3,0
        i += 1;
 54a:	b72d                	j	474 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 54c:	06400793          	li	a5,100
 550:	02f60763          	beq	a2,a5,57e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 554:	07500793          	li	a5,117
 558:	06f60963          	beq	a2,a5,5ca <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 55c:	07800793          	li	a5,120
 560:	faf61ee3          	bne	a2,a5,51c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 564:	008b8913          	addi	s2,s7,8
 568:	4681                	li	a3,0
 56a:	4641                	li	a2,16
 56c:	000ba583          	lw	a1,0(s7)
 570:	855a                	mv	a0,s6
 572:	e11ff0ef          	jal	382 <printint>
        i += 2;
 576:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 578:	8bca                	mv	s7,s2
      state = 0;
 57a:	4981                	li	s3,0
        i += 2;
 57c:	bde5                	j	474 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 57e:	008b8913          	addi	s2,s7,8
 582:	4685                	li	a3,1
 584:	4629                	li	a2,10
 586:	000ba583          	lw	a1,0(s7)
 58a:	855a                	mv	a0,s6
 58c:	df7ff0ef          	jal	382 <printint>
        i += 2;
 590:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 592:	8bca                	mv	s7,s2
      state = 0;
 594:	4981                	li	s3,0
        i += 2;
 596:	bdf9                	j	474 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 598:	008b8913          	addi	s2,s7,8
 59c:	4681                	li	a3,0
 59e:	4629                	li	a2,10
 5a0:	000ba583          	lw	a1,0(s7)
 5a4:	855a                	mv	a0,s6
 5a6:	dddff0ef          	jal	382 <printint>
 5aa:	8bca                	mv	s7,s2
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	b5d9                	j	474 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b0:	008b8913          	addi	s2,s7,8
 5b4:	4681                	li	a3,0
 5b6:	4629                	li	a2,10
 5b8:	000ba583          	lw	a1,0(s7)
 5bc:	855a                	mv	a0,s6
 5be:	dc5ff0ef          	jal	382 <printint>
        i += 1;
 5c2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c4:	8bca                	mv	s7,s2
      state = 0;
 5c6:	4981                	li	s3,0
        i += 1;
 5c8:	b575                	j	474 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ca:	008b8913          	addi	s2,s7,8
 5ce:	4681                	li	a3,0
 5d0:	4629                	li	a2,10
 5d2:	000ba583          	lw	a1,0(s7)
 5d6:	855a                	mv	a0,s6
 5d8:	dabff0ef          	jal	382 <printint>
        i += 2;
 5dc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5de:	8bca                	mv	s7,s2
      state = 0;
 5e0:	4981                	li	s3,0
        i += 2;
 5e2:	bd49                	j	474 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5e4:	008b8913          	addi	s2,s7,8
 5e8:	4681                	li	a3,0
 5ea:	4641                	li	a2,16
 5ec:	000ba583          	lw	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	d91ff0ef          	jal	382 <printint>
 5f6:	8bca                	mv	s7,s2
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	bdad                	j	474 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fc:	008b8913          	addi	s2,s7,8
 600:	4681                	li	a3,0
 602:	4641                	li	a2,16
 604:	000ba583          	lw	a1,0(s7)
 608:	855a                	mv	a0,s6
 60a:	d79ff0ef          	jal	382 <printint>
        i += 1;
 60e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 610:	8bca                	mv	s7,s2
      state = 0;
 612:	4981                	li	s3,0
        i += 1;
 614:	b585                	j	474 <vprintf+0x4a>
 616:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 618:	008b8d13          	addi	s10,s7,8
 61c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 620:	03000593          	li	a1,48
 624:	855a                	mv	a0,s6
 626:	d3fff0ef          	jal	364 <putc>
  putc(fd, 'x');
 62a:	07800593          	li	a1,120
 62e:	855a                	mv	a0,s6
 630:	d35ff0ef          	jal	364 <putc>
 634:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 636:	00000b97          	auipc	s7,0x0
 63a:	26ab8b93          	addi	s7,s7,618 # 8a0 <digits>
 63e:	03c9d793          	srli	a5,s3,0x3c
 642:	97de                	add	a5,a5,s7
 644:	0007c583          	lbu	a1,0(a5)
 648:	855a                	mv	a0,s6
 64a:	d1bff0ef          	jal	364 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 64e:	0992                	slli	s3,s3,0x4
 650:	397d                	addiw	s2,s2,-1
 652:	fe0916e3          	bnez	s2,63e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 656:	8bea                	mv	s7,s10
      state = 0;
 658:	4981                	li	s3,0
 65a:	6d02                	ld	s10,0(sp)
 65c:	bd21                	j	474 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 65e:	008b8993          	addi	s3,s7,8
 662:	000bb903          	ld	s2,0(s7)
 666:	00090f63          	beqz	s2,684 <vprintf+0x25a>
        for(; *s; s++)
 66a:	00094583          	lbu	a1,0(s2)
 66e:	c195                	beqz	a1,692 <vprintf+0x268>
          putc(fd, *s);
 670:	855a                	mv	a0,s6
 672:	cf3ff0ef          	jal	364 <putc>
        for(; *s; s++)
 676:	0905                	addi	s2,s2,1
 678:	00094583          	lbu	a1,0(s2)
 67c:	f9f5                	bnez	a1,670 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 67e:	8bce                	mv	s7,s3
      state = 0;
 680:	4981                	li	s3,0
 682:	bbcd                	j	474 <vprintf+0x4a>
          s = "(null)";
 684:	00000917          	auipc	s2,0x0
 688:	21490913          	addi	s2,s2,532 # 898 <malloc+0x108>
        for(; *s; s++)
 68c:	02800593          	li	a1,40
 690:	b7c5                	j	670 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 692:	8bce                	mv	s7,s3
      state = 0;
 694:	4981                	li	s3,0
 696:	bbf9                	j	474 <vprintf+0x4a>
 698:	64a6                	ld	s1,72(sp)
 69a:	79e2                	ld	s3,56(sp)
 69c:	7a42                	ld	s4,48(sp)
 69e:	7aa2                	ld	s5,40(sp)
 6a0:	7b02                	ld	s6,32(sp)
 6a2:	6be2                	ld	s7,24(sp)
 6a4:	6c42                	ld	s8,16(sp)
 6a6:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6a8:	60e6                	ld	ra,88(sp)
 6aa:	6446                	ld	s0,80(sp)
 6ac:	6906                	ld	s2,64(sp)
 6ae:	6125                	addi	sp,sp,96
 6b0:	8082                	ret

00000000000006b2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b2:	715d                	addi	sp,sp,-80
 6b4:	ec06                	sd	ra,24(sp)
 6b6:	e822                	sd	s0,16(sp)
 6b8:	1000                	addi	s0,sp,32
 6ba:	e010                	sd	a2,0(s0)
 6bc:	e414                	sd	a3,8(s0)
 6be:	e818                	sd	a4,16(s0)
 6c0:	ec1c                	sd	a5,24(s0)
 6c2:	03043023          	sd	a6,32(s0)
 6c6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ca:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ce:	8622                	mv	a2,s0
 6d0:	d5bff0ef          	jal	42a <vprintf>
}
 6d4:	60e2                	ld	ra,24(sp)
 6d6:	6442                	ld	s0,16(sp)
 6d8:	6161                	addi	sp,sp,80
 6da:	8082                	ret

00000000000006dc <printf>:

void
printf(const char *fmt, ...)
{
 6dc:	711d                	addi	sp,sp,-96
 6de:	ec06                	sd	ra,24(sp)
 6e0:	e822                	sd	s0,16(sp)
 6e2:	1000                	addi	s0,sp,32
 6e4:	e40c                	sd	a1,8(s0)
 6e6:	e810                	sd	a2,16(s0)
 6e8:	ec14                	sd	a3,24(s0)
 6ea:	f018                	sd	a4,32(s0)
 6ec:	f41c                	sd	a5,40(s0)
 6ee:	03043823          	sd	a6,48(s0)
 6f2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6f6:	00840613          	addi	a2,s0,8
 6fa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6fe:	85aa                	mv	a1,a0
 700:	4505                	li	a0,1
 702:	d29ff0ef          	jal	42a <vprintf>
}
 706:	60e2                	ld	ra,24(sp)
 708:	6442                	ld	s0,16(sp)
 70a:	6125                	addi	sp,sp,96
 70c:	8082                	ret

000000000000070e <free>:
 70e:	1141                	addi	sp,sp,-16
 710:	e422                	sd	s0,8(sp)
 712:	0800                	addi	s0,sp,16
 714:	ff050693          	addi	a3,a0,-16
 718:	00001797          	auipc	a5,0x1
 71c:	8e87b783          	ld	a5,-1816(a5) # 1000 <freep>
 720:	a02d                	j	74a <free+0x3c>
 722:	4618                	lw	a4,8(a2)
 724:	9f2d                	addw	a4,a4,a1
 726:	fee52c23          	sw	a4,-8(a0)
 72a:	6398                	ld	a4,0(a5)
 72c:	6310                	ld	a2,0(a4)
 72e:	a83d                	j	76c <free+0x5e>
 730:	ff852703          	lw	a4,-8(a0)
 734:	9f31                	addw	a4,a4,a2
 736:	c798                	sw	a4,8(a5)
 738:	ff053683          	ld	a3,-16(a0)
 73c:	a091                	j	780 <free+0x72>
 73e:	6398                	ld	a4,0(a5)
 740:	00e7e463          	bltu	a5,a4,748 <free+0x3a>
 744:	00e6ea63          	bltu	a3,a4,758 <free+0x4a>
 748:	87ba                	mv	a5,a4
 74a:	fed7fae3          	bgeu	a5,a3,73e <free+0x30>
 74e:	6398                	ld	a4,0(a5)
 750:	00e6e463          	bltu	a3,a4,758 <free+0x4a>
 754:	fee7eae3          	bltu	a5,a4,748 <free+0x3a>
 758:	ff852583          	lw	a1,-8(a0)
 75c:	6390                	ld	a2,0(a5)
 75e:	02059813          	slli	a6,a1,0x20
 762:	01c85713          	srli	a4,a6,0x1c
 766:	9736                	add	a4,a4,a3
 768:	fae60de3          	beq	a2,a4,722 <free+0x14>
 76c:	fec53823          	sd	a2,-16(a0)
 770:	4790                	lw	a2,8(a5)
 772:	02061593          	slli	a1,a2,0x20
 776:	01c5d713          	srli	a4,a1,0x1c
 77a:	973e                	add	a4,a4,a5
 77c:	fae68ae3          	beq	a3,a4,730 <free+0x22>
 780:	e394                	sd	a3,0(a5)
 782:	00001717          	auipc	a4,0x1
 786:	86f73f23          	sd	a5,-1922(a4) # 1000 <freep>
 78a:	6422                	ld	s0,8(sp)
 78c:	0141                	addi	sp,sp,16
 78e:	8082                	ret

0000000000000790 <malloc>:
 790:	7139                	addi	sp,sp,-64
 792:	fc06                	sd	ra,56(sp)
 794:	f822                	sd	s0,48(sp)
 796:	f426                	sd	s1,40(sp)
 798:	ec4e                	sd	s3,24(sp)
 79a:	0080                	addi	s0,sp,64
 79c:	02051493          	slli	s1,a0,0x20
 7a0:	9081                	srli	s1,s1,0x20
 7a2:	04bd                	addi	s1,s1,15
 7a4:	8091                	srli	s1,s1,0x4
 7a6:	0014899b          	addiw	s3,s1,1
 7aa:	0485                	addi	s1,s1,1
 7ac:	00001517          	auipc	a0,0x1
 7b0:	85453503          	ld	a0,-1964(a0) # 1000 <freep>
 7b4:	c915                	beqz	a0,7e8 <malloc+0x58>
 7b6:	611c                	ld	a5,0(a0)
 7b8:	4798                	lw	a4,8(a5)
 7ba:	08977a63          	bgeu	a4,s1,84e <malloc+0xbe>
 7be:	f04a                	sd	s2,32(sp)
 7c0:	e852                	sd	s4,16(sp)
 7c2:	e456                	sd	s5,8(sp)
 7c4:	e05a                	sd	s6,0(sp)
 7c6:	8a4e                	mv	s4,s3
 7c8:	0009871b          	sext.w	a4,s3
 7cc:	6685                	lui	a3,0x1
 7ce:	00d77363          	bgeu	a4,a3,7d4 <malloc+0x44>
 7d2:	6a05                	lui	s4,0x1
 7d4:	000a0b1b          	sext.w	s6,s4
 7d8:	004a1a1b          	slliw	s4,s4,0x4
 7dc:	00001917          	auipc	s2,0x1
 7e0:	82490913          	addi	s2,s2,-2012 # 1000 <freep>
 7e4:	5afd                	li	s5,-1
 7e6:	a081                	j	826 <malloc+0x96>
 7e8:	f04a                	sd	s2,32(sp)
 7ea:	e852                	sd	s4,16(sp)
 7ec:	e456                	sd	s5,8(sp)
 7ee:	e05a                	sd	s6,0(sp)
 7f0:	00001797          	auipc	a5,0x1
 7f4:	82078793          	addi	a5,a5,-2016 # 1010 <base>
 7f8:	00001717          	auipc	a4,0x1
 7fc:	80f73423          	sd	a5,-2040(a4) # 1000 <freep>
 800:	e39c                	sd	a5,0(a5)
 802:	0007a423          	sw	zero,8(a5)
 806:	b7c1                	j	7c6 <malloc+0x36>
 808:	6398                	ld	a4,0(a5)
 80a:	e118                	sd	a4,0(a0)
 80c:	a8a9                	j	866 <malloc+0xd6>
 80e:	01652423          	sw	s6,8(a0)
 812:	0541                	addi	a0,a0,16
 814:	efbff0ef          	jal	70e <free>
 818:	00093503          	ld	a0,0(s2)
 81c:	c12d                	beqz	a0,87e <malloc+0xee>
 81e:	611c                	ld	a5,0(a0)
 820:	4798                	lw	a4,8(a5)
 822:	02977263          	bgeu	a4,s1,846 <malloc+0xb6>
 826:	00093703          	ld	a4,0(s2)
 82a:	853e                	mv	a0,a5
 82c:	fef719e3          	bne	a4,a5,81e <malloc+0x8e>
 830:	8552                	mv	a0,s4
 832:	af3ff0ef          	jal	324 <sbrk>
 836:	fd551ce3          	bne	a0,s5,80e <malloc+0x7e>
 83a:	4501                	li	a0,0
 83c:	7902                	ld	s2,32(sp)
 83e:	6a42                	ld	s4,16(sp)
 840:	6aa2                	ld	s5,8(sp)
 842:	6b02                	ld	s6,0(sp)
 844:	a03d                	j	872 <malloc+0xe2>
 846:	7902                	ld	s2,32(sp)
 848:	6a42                	ld	s4,16(sp)
 84a:	6aa2                	ld	s5,8(sp)
 84c:	6b02                	ld	s6,0(sp)
 84e:	fae48de3          	beq	s1,a4,808 <malloc+0x78>
 852:	4137073b          	subw	a4,a4,s3
 856:	c798                	sw	a4,8(a5)
 858:	02071693          	slli	a3,a4,0x20
 85c:	01c6d713          	srli	a4,a3,0x1c
 860:	97ba                	add	a5,a5,a4
 862:	0137a423          	sw	s3,8(a5)
 866:	00000717          	auipc	a4,0x0
 86a:	78a73d23          	sd	a0,1946(a4) # 1000 <freep>
 86e:	01078513          	addi	a0,a5,16
 872:	70e2                	ld	ra,56(sp)
 874:	7442                	ld	s0,48(sp)
 876:	74a2                	ld	s1,40(sp)
 878:	69e2                	ld	s3,24(sp)
 87a:	6121                	addi	sp,sp,64
 87c:	8082                	ret
 87e:	7902                	ld	s2,32(sp)
 880:	6a42                	ld	s4,16(sp)
 882:	6aa2                	ld	s5,8(sp)
 884:	6b02                	ld	s6,0(sp)
 886:	b7f5                	j	872 <malloc+0xe2>
