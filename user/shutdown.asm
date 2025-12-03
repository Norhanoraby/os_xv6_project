
user/_shutdown:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    printf("Calling shutdown...\n");
   8:	00001517          	auipc	a0,0x1
   c:	87850513          	addi	a0,a0,-1928 # 880 <malloc+0xf8>
  10:	6c4000ef          	jal	6d4 <printf>
    shutdown();
  14:	338000ef          	jal	34c <shutdown>
    // If shutdown works, you will NEVER see this line:
    printf("Shutdown failed (you should not see this).\n");
  18:	00001517          	auipc	a0,0x1
  1c:	88050513          	addi	a0,a0,-1920 # 898 <malloc+0x110>
  20:	6b4000ef          	jal	6d4 <printf>
    exit(0);
  24:	4501                	li	a0,0
  26:	26e000ef          	jal	294 <exit>

000000000000002a <start>:
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
  32:	fcfff0ef          	jal	0 <main>
  36:	4501                	li	a0,0
  38:	25c000ef          	jal	294 <exit>

000000000000003c <strcpy>:
  3c:	1141                	addi	sp,sp,-16
  3e:	e422                	sd	s0,8(sp)
  40:	0800                	addi	s0,sp,16
  42:	87aa                	mv	a5,a0
  44:	0585                	addi	a1,a1,1
  46:	0785                	addi	a5,a5,1
  48:	fff5c703          	lbu	a4,-1(a1)
  4c:	fee78fa3          	sb	a4,-1(a5)
  50:	fb75                	bnez	a4,44 <strcpy+0x8>
  52:	6422                	ld	s0,8(sp)
  54:	0141                	addi	sp,sp,16
  56:	8082                	ret

0000000000000058 <strcmp>:
  58:	1141                	addi	sp,sp,-16
  5a:	e422                	sd	s0,8(sp)
  5c:	0800                	addi	s0,sp,16
  5e:	00054783          	lbu	a5,0(a0)
  62:	cb91                	beqz	a5,76 <strcmp+0x1e>
  64:	0005c703          	lbu	a4,0(a1)
  68:	00f71763          	bne	a4,a5,76 <strcmp+0x1e>
  6c:	0505                	addi	a0,a0,1
  6e:	0585                	addi	a1,a1,1
  70:	00054783          	lbu	a5,0(a0)
  74:	fbe5                	bnez	a5,64 <strcmp+0xc>
  76:	0005c503          	lbu	a0,0(a1)
  7a:	40a7853b          	subw	a0,a5,a0
  7e:	6422                	ld	s0,8(sp)
  80:	0141                	addi	sp,sp,16
  82:	8082                	ret

0000000000000084 <strlen>:
  84:	1141                	addi	sp,sp,-16
  86:	e422                	sd	s0,8(sp)
  88:	0800                	addi	s0,sp,16
  8a:	00054783          	lbu	a5,0(a0)
  8e:	cf91                	beqz	a5,aa <strlen+0x26>
  90:	0505                	addi	a0,a0,1
  92:	87aa                	mv	a5,a0
  94:	86be                	mv	a3,a5
  96:	0785                	addi	a5,a5,1
  98:	fff7c703          	lbu	a4,-1(a5)
  9c:	ff65                	bnez	a4,94 <strlen+0x10>
  9e:	40a6853b          	subw	a0,a3,a0
  a2:	2505                	addiw	a0,a0,1
  a4:	6422                	ld	s0,8(sp)
  a6:	0141                	addi	sp,sp,16
  a8:	8082                	ret
  aa:	4501                	li	a0,0
  ac:	bfe5                	j	a4 <strlen+0x20>

00000000000000ae <memset>:
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  b4:	ca19                	beqz	a2,ca <memset+0x1c>
  b6:	87aa                	mv	a5,a0
  b8:	1602                	slli	a2,a2,0x20
  ba:	9201                	srli	a2,a2,0x20
  bc:	00a60733          	add	a4,a2,a0
  c0:	00b78023          	sb	a1,0(a5)
  c4:	0785                	addi	a5,a5,1
  c6:	fee79de3          	bne	a5,a4,c0 <memset+0x12>
  ca:	6422                	ld	s0,8(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret

00000000000000d0 <strchr>:
  d0:	1141                	addi	sp,sp,-16
  d2:	e422                	sd	s0,8(sp)
  d4:	0800                	addi	s0,sp,16
  d6:	00054783          	lbu	a5,0(a0)
  da:	cb99                	beqz	a5,f0 <strchr+0x20>
  dc:	00f58763          	beq	a1,a5,ea <strchr+0x1a>
  e0:	0505                	addi	a0,a0,1
  e2:	00054783          	lbu	a5,0(a0)
  e6:	fbfd                	bnez	a5,dc <strchr+0xc>
  e8:	4501                	li	a0,0
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret
  f0:	4501                	li	a0,0
  f2:	bfe5                	j	ea <strchr+0x1a>

00000000000000f4 <gets>:
  f4:	711d                	addi	sp,sp,-96
  f6:	ec86                	sd	ra,88(sp)
  f8:	e8a2                	sd	s0,80(sp)
  fa:	e4a6                	sd	s1,72(sp)
  fc:	e0ca                	sd	s2,64(sp)
  fe:	fc4e                	sd	s3,56(sp)
 100:	f852                	sd	s4,48(sp)
 102:	f456                	sd	s5,40(sp)
 104:	f05a                	sd	s6,32(sp)
 106:	ec5e                	sd	s7,24(sp)
 108:	1080                	addi	s0,sp,96
 10a:	8baa                	mv	s7,a0
 10c:	8a2e                	mv	s4,a1
 10e:	892a                	mv	s2,a0
 110:	4481                	li	s1,0
 112:	4aa9                	li	s5,10
 114:	4b35                	li	s6,13
 116:	89a6                	mv	s3,s1
 118:	2485                	addiw	s1,s1,1
 11a:	0344d663          	bge	s1,s4,146 <gets+0x52>
 11e:	4605                	li	a2,1
 120:	faf40593          	addi	a1,s0,-81
 124:	4501                	li	a0,0
 126:	186000ef          	jal	2ac <read>
 12a:	00a05e63          	blez	a0,146 <gets+0x52>
 12e:	faf44783          	lbu	a5,-81(s0)
 132:	00f90023          	sb	a5,0(s2)
 136:	01578763          	beq	a5,s5,144 <gets+0x50>
 13a:	0905                	addi	s2,s2,1
 13c:	fd679de3          	bne	a5,s6,116 <gets+0x22>
 140:	89a6                	mv	s3,s1
 142:	a011                	j	146 <gets+0x52>
 144:	89a6                	mv	s3,s1
 146:	99de                	add	s3,s3,s7
 148:	00098023          	sb	zero,0(s3)
 14c:	855e                	mv	a0,s7
 14e:	60e6                	ld	ra,88(sp)
 150:	6446                	ld	s0,80(sp)
 152:	64a6                	ld	s1,72(sp)
 154:	6906                	ld	s2,64(sp)
 156:	79e2                	ld	s3,56(sp)
 158:	7a42                	ld	s4,48(sp)
 15a:	7aa2                	ld	s5,40(sp)
 15c:	7b02                	ld	s6,32(sp)
 15e:	6be2                	ld	s7,24(sp)
 160:	6125                	addi	sp,sp,96
 162:	8082                	ret

0000000000000164 <stat>:
 164:	1101                	addi	sp,sp,-32
 166:	ec06                	sd	ra,24(sp)
 168:	e822                	sd	s0,16(sp)
 16a:	e04a                	sd	s2,0(sp)
 16c:	1000                	addi	s0,sp,32
 16e:	892e                	mv	s2,a1
 170:	4581                	li	a1,0
 172:	162000ef          	jal	2d4 <open>
 176:	02054263          	bltz	a0,19a <stat+0x36>
 17a:	e426                	sd	s1,8(sp)
 17c:	84aa                	mv	s1,a0
 17e:	85ca                	mv	a1,s2
 180:	16c000ef          	jal	2ec <fstat>
 184:	892a                	mv	s2,a0
 186:	8526                	mv	a0,s1
 188:	134000ef          	jal	2bc <close>
 18c:	64a2                	ld	s1,8(sp)
 18e:	854a                	mv	a0,s2
 190:	60e2                	ld	ra,24(sp)
 192:	6442                	ld	s0,16(sp)
 194:	6902                	ld	s2,0(sp)
 196:	6105                	addi	sp,sp,32
 198:	8082                	ret
 19a:	597d                	li	s2,-1
 19c:	bfcd                	j	18e <stat+0x2a>

000000000000019e <atoi>:
 19e:	1141                	addi	sp,sp,-16
 1a0:	e422                	sd	s0,8(sp)
 1a2:	0800                	addi	s0,sp,16
 1a4:	00054683          	lbu	a3,0(a0)
 1a8:	fd06879b          	addiw	a5,a3,-48
 1ac:	0ff7f793          	zext.b	a5,a5
 1b0:	4625                	li	a2,9
 1b2:	02f66863          	bltu	a2,a5,1e2 <atoi+0x44>
 1b6:	872a                	mv	a4,a0
 1b8:	4501                	li	a0,0
 1ba:	0705                	addi	a4,a4,1
 1bc:	0025179b          	slliw	a5,a0,0x2
 1c0:	9fa9                	addw	a5,a5,a0
 1c2:	0017979b          	slliw	a5,a5,0x1
 1c6:	9fb5                	addw	a5,a5,a3
 1c8:	fd07851b          	addiw	a0,a5,-48
 1cc:	00074683          	lbu	a3,0(a4)
 1d0:	fd06879b          	addiw	a5,a3,-48
 1d4:	0ff7f793          	zext.b	a5,a5
 1d8:	fef671e3          	bgeu	a2,a5,1ba <atoi+0x1c>
 1dc:	6422                	ld	s0,8(sp)
 1de:	0141                	addi	sp,sp,16
 1e0:	8082                	ret
 1e2:	4501                	li	a0,0
 1e4:	bfe5                	j	1dc <atoi+0x3e>

00000000000001e6 <memmove>:
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
 1ec:	02b57463          	bgeu	a0,a1,214 <memmove+0x2e>
 1f0:	00c05f63          	blez	a2,20e <memmove+0x28>
 1f4:	1602                	slli	a2,a2,0x20
 1f6:	9201                	srli	a2,a2,0x20
 1f8:	00c507b3          	add	a5,a0,a2
 1fc:	872a                	mv	a4,a0
 1fe:	0585                	addi	a1,a1,1
 200:	0705                	addi	a4,a4,1
 202:	fff5c683          	lbu	a3,-1(a1)
 206:	fed70fa3          	sb	a3,-1(a4)
 20a:	fef71ae3          	bne	a4,a5,1fe <memmove+0x18>
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret
 214:	00c50733          	add	a4,a0,a2
 218:	95b2                	add	a1,a1,a2
 21a:	fec05ae3          	blez	a2,20e <memmove+0x28>
 21e:	fff6079b          	addiw	a5,a2,-1
 222:	1782                	slli	a5,a5,0x20
 224:	9381                	srli	a5,a5,0x20
 226:	fff7c793          	not	a5,a5
 22a:	97ba                	add	a5,a5,a4
 22c:	15fd                	addi	a1,a1,-1
 22e:	177d                	addi	a4,a4,-1
 230:	0005c683          	lbu	a3,0(a1)
 234:	00d70023          	sb	a3,0(a4)
 238:	fee79ae3          	bne	a5,a4,22c <memmove+0x46>
 23c:	bfc9                	j	20e <memmove+0x28>

000000000000023e <memcmp>:
 23e:	1141                	addi	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	addi	s0,sp,16
 244:	ca05                	beqz	a2,274 <memcmp+0x36>
 246:	fff6069b          	addiw	a3,a2,-1
 24a:	1682                	slli	a3,a3,0x20
 24c:	9281                	srli	a3,a3,0x20
 24e:	0685                	addi	a3,a3,1
 250:	96aa                	add	a3,a3,a0
 252:	00054783          	lbu	a5,0(a0)
 256:	0005c703          	lbu	a4,0(a1)
 25a:	00e79863          	bne	a5,a4,26a <memcmp+0x2c>
 25e:	0505                	addi	a0,a0,1
 260:	0585                	addi	a1,a1,1
 262:	fed518e3          	bne	a0,a3,252 <memcmp+0x14>
 266:	4501                	li	a0,0
 268:	a019                	j	26e <memcmp+0x30>
 26a:	40e7853b          	subw	a0,a5,a4
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
 274:	4501                	li	a0,0
 276:	bfe5                	j	26e <memcmp+0x30>

0000000000000278 <memcpy>:
 278:	1141                	addi	sp,sp,-16
 27a:	e406                	sd	ra,8(sp)
 27c:	e022                	sd	s0,0(sp)
 27e:	0800                	addi	s0,sp,16
 280:	f67ff0ef          	jal	1e6 <memmove>
 284:	60a2                	ld	ra,8(sp)
 286:	6402                	ld	s0,0(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret

000000000000028c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 28c:	4885                	li	a7,1
 ecall
 28e:	00000073          	ecall
 ret
 292:	8082                	ret

0000000000000294 <exit>:
.global exit
exit:
 li a7, SYS_exit
 294:	4889                	li	a7,2
 ecall
 296:	00000073          	ecall
 ret
 29a:	8082                	ret

000000000000029c <wait>:
.global wait
wait:
 li a7, SYS_wait
 29c:	488d                	li	a7,3
 ecall
 29e:	00000073          	ecall
 ret
 2a2:	8082                	ret

00000000000002a4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2a4:	4891                	li	a7,4
 ecall
 2a6:	00000073          	ecall
 ret
 2aa:	8082                	ret

00000000000002ac <read>:
.global read
read:
 li a7, SYS_read
 2ac:	4895                	li	a7,5
 ecall
 2ae:	00000073          	ecall
 ret
 2b2:	8082                	ret

00000000000002b4 <write>:
.global write
write:
 li a7, SYS_write
 2b4:	48c1                	li	a7,16
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <close>:
.global close
close:
 li a7, SYS_close
 2bc:	48d5                	li	a7,21
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2c4:	4899                	li	a7,6
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <exec>:
.global exec
exec:
 li a7, SYS_exec
 2cc:	489d                	li	a7,7
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <open>:
.global open
open:
 li a7, SYS_open
 2d4:	48bd                	li	a7,15
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2dc:	48c5                	li	a7,17
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2e4:	48c9                	li	a7,18
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2ec:	48a1                	li	a7,8
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <link>:
.global link
link:
 li a7, SYS_link
 2f4:	48cd                	li	a7,19
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2fc:	48d1                	li	a7,20
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 304:	48a5                	li	a7,9
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <dup>:
.global dup
dup:
 li a7, SYS_dup
 30c:	48a9                	li	a7,10
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 314:	48ad                	li	a7,11
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 31c:	48b1                	li	a7,12
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 324:	48b5                	li	a7,13
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 32c:	48b9                	li	a7,14
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 334:	48d9                	li	a7,22
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 33c:	48dd                	li	a7,23
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 344:	48e1                	li	a7,24
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 34c:	48e5                	li	a7,25
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <rand>:
.global rand
rand:
 li a7, SYS_rand
 354:	48ed                	li	a7,27
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
 36e:	f47ff0ef          	jal	2b4 <write>
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
 39c:	53850513          	addi	a0,a0,1336 # 8d0 <digits>
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
 632:	2a2b8b93          	addi	s7,s7,674 # 8d0 <digits>
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
 680:	24c90913          	addi	s2,s2,588 # 8c8 <malloc+0x140>
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
 82a:	af3ff0ef          	jal	31c <sbrk>
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
