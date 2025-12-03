
user/_uptime:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
    int t = uptime();  
   a:	330000ef          	jal	33a <uptime>
   e:	84aa                	mv	s1,a0
    printf("System uptime: %d ticks\n", t);
  10:	85aa                	mv	a1,a0
  12:	00001517          	auipc	a0,0x1
  16:	87e50513          	addi	a0,a0,-1922 # 890 <malloc+0xfa>
  1a:	6c8000ef          	jal	6e2 <printf>

    
    printf("Approx uptime: %d seconds\n", t / 100);//conert ticks to sec 
  1e:	06400593          	li	a1,100
  22:	02b4c5bb          	divw	a1,s1,a1
  26:	00001517          	auipc	a0,0x1
  2a:	88a50513          	addi	a0,a0,-1910 # 8b0 <malloc+0x11a>
  2e:	6b4000ef          	jal	6e2 <printf>
//ya3ne kol 100 tick = 1 sec
    exit(0);
  32:	4501                	li	a0,0
  34:	26e000ef          	jal	2a2 <exit>

0000000000000038 <start>:
  38:	1141                	addi	sp,sp,-16
  3a:	e406                	sd	ra,8(sp)
  3c:	e022                	sd	s0,0(sp)
  3e:	0800                	addi	s0,sp,16
  40:	fc1ff0ef          	jal	0 <main>
  44:	4501                	li	a0,0
  46:	25c000ef          	jal	2a2 <exit>

000000000000004a <strcpy>:
  4a:	1141                	addi	sp,sp,-16
  4c:	e422                	sd	s0,8(sp)
  4e:	0800                	addi	s0,sp,16
  50:	87aa                	mv	a5,a0
  52:	0585                	addi	a1,a1,1
  54:	0785                	addi	a5,a5,1
  56:	fff5c703          	lbu	a4,-1(a1)
  5a:	fee78fa3          	sb	a4,-1(a5)
  5e:	fb75                	bnez	a4,52 <strcpy+0x8>
  60:	6422                	ld	s0,8(sp)
  62:	0141                	addi	sp,sp,16
  64:	8082                	ret

0000000000000066 <strcmp>:
  66:	1141                	addi	sp,sp,-16
  68:	e422                	sd	s0,8(sp)
  6a:	0800                	addi	s0,sp,16
  6c:	00054783          	lbu	a5,0(a0)
  70:	cb91                	beqz	a5,84 <strcmp+0x1e>
  72:	0005c703          	lbu	a4,0(a1)
  76:	00f71763          	bne	a4,a5,84 <strcmp+0x1e>
  7a:	0505                	addi	a0,a0,1
  7c:	0585                	addi	a1,a1,1
  7e:	00054783          	lbu	a5,0(a0)
  82:	fbe5                	bnez	a5,72 <strcmp+0xc>
  84:	0005c503          	lbu	a0,0(a1)
  88:	40a7853b          	subw	a0,a5,a0
  8c:	6422                	ld	s0,8(sp)
  8e:	0141                	addi	sp,sp,16
  90:	8082                	ret

0000000000000092 <strlen>:
  92:	1141                	addi	sp,sp,-16
  94:	e422                	sd	s0,8(sp)
  96:	0800                	addi	s0,sp,16
  98:	00054783          	lbu	a5,0(a0)
  9c:	cf91                	beqz	a5,b8 <strlen+0x26>
  9e:	0505                	addi	a0,a0,1
  a0:	87aa                	mv	a5,a0
  a2:	86be                	mv	a3,a5
  a4:	0785                	addi	a5,a5,1
  a6:	fff7c703          	lbu	a4,-1(a5)
  aa:	ff65                	bnez	a4,a2 <strlen+0x10>
  ac:	40a6853b          	subw	a0,a3,a0
  b0:	2505                	addiw	a0,a0,1
  b2:	6422                	ld	s0,8(sp)
  b4:	0141                	addi	sp,sp,16
  b6:	8082                	ret
  b8:	4501                	li	a0,0
  ba:	bfe5                	j	b2 <strlen+0x20>

00000000000000bc <memset>:
  bc:	1141                	addi	sp,sp,-16
  be:	e422                	sd	s0,8(sp)
  c0:	0800                	addi	s0,sp,16
  c2:	ca19                	beqz	a2,d8 <memset+0x1c>
  c4:	87aa                	mv	a5,a0
  c6:	1602                	slli	a2,a2,0x20
  c8:	9201                	srli	a2,a2,0x20
  ca:	00a60733          	add	a4,a2,a0
  ce:	00b78023          	sb	a1,0(a5)
  d2:	0785                	addi	a5,a5,1
  d4:	fee79de3          	bne	a5,a4,ce <memset+0x12>
  d8:	6422                	ld	s0,8(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret

00000000000000de <strchr>:
  de:	1141                	addi	sp,sp,-16
  e0:	e422                	sd	s0,8(sp)
  e2:	0800                	addi	s0,sp,16
  e4:	00054783          	lbu	a5,0(a0)
  e8:	cb99                	beqz	a5,fe <strchr+0x20>
  ea:	00f58763          	beq	a1,a5,f8 <strchr+0x1a>
  ee:	0505                	addi	a0,a0,1
  f0:	00054783          	lbu	a5,0(a0)
  f4:	fbfd                	bnez	a5,ea <strchr+0xc>
  f6:	4501                	li	a0,0
  f8:	6422                	ld	s0,8(sp)
  fa:	0141                	addi	sp,sp,16
  fc:	8082                	ret
  fe:	4501                	li	a0,0
 100:	bfe5                	j	f8 <strchr+0x1a>

0000000000000102 <gets>:
 102:	711d                	addi	sp,sp,-96
 104:	ec86                	sd	ra,88(sp)
 106:	e8a2                	sd	s0,80(sp)
 108:	e4a6                	sd	s1,72(sp)
 10a:	e0ca                	sd	s2,64(sp)
 10c:	fc4e                	sd	s3,56(sp)
 10e:	f852                	sd	s4,48(sp)
 110:	f456                	sd	s5,40(sp)
 112:	f05a                	sd	s6,32(sp)
 114:	ec5e                	sd	s7,24(sp)
 116:	1080                	addi	s0,sp,96
 118:	8baa                	mv	s7,a0
 11a:	8a2e                	mv	s4,a1
 11c:	892a                	mv	s2,a0
 11e:	4481                	li	s1,0
 120:	4aa9                	li	s5,10
 122:	4b35                	li	s6,13
 124:	89a6                	mv	s3,s1
 126:	2485                	addiw	s1,s1,1
 128:	0344d663          	bge	s1,s4,154 <gets+0x52>
 12c:	4605                	li	a2,1
 12e:	faf40593          	addi	a1,s0,-81
 132:	4501                	li	a0,0
 134:	186000ef          	jal	2ba <read>
 138:	00a05e63          	blez	a0,154 <gets+0x52>
 13c:	faf44783          	lbu	a5,-81(s0)
 140:	00f90023          	sb	a5,0(s2)
 144:	01578763          	beq	a5,s5,152 <gets+0x50>
 148:	0905                	addi	s2,s2,1
 14a:	fd679de3          	bne	a5,s6,124 <gets+0x22>
 14e:	89a6                	mv	s3,s1
 150:	a011                	j	154 <gets+0x52>
 152:	89a6                	mv	s3,s1
 154:	99de                	add	s3,s3,s7
 156:	00098023          	sb	zero,0(s3)
 15a:	855e                	mv	a0,s7
 15c:	60e6                	ld	ra,88(sp)
 15e:	6446                	ld	s0,80(sp)
 160:	64a6                	ld	s1,72(sp)
 162:	6906                	ld	s2,64(sp)
 164:	79e2                	ld	s3,56(sp)
 166:	7a42                	ld	s4,48(sp)
 168:	7aa2                	ld	s5,40(sp)
 16a:	7b02                	ld	s6,32(sp)
 16c:	6be2                	ld	s7,24(sp)
 16e:	6125                	addi	sp,sp,96
 170:	8082                	ret

0000000000000172 <stat>:
 172:	1101                	addi	sp,sp,-32
 174:	ec06                	sd	ra,24(sp)
 176:	e822                	sd	s0,16(sp)
 178:	e04a                	sd	s2,0(sp)
 17a:	1000                	addi	s0,sp,32
 17c:	892e                	mv	s2,a1
 17e:	4581                	li	a1,0
 180:	162000ef          	jal	2e2 <open>
 184:	02054263          	bltz	a0,1a8 <stat+0x36>
 188:	e426                	sd	s1,8(sp)
 18a:	84aa                	mv	s1,a0
 18c:	85ca                	mv	a1,s2
 18e:	16c000ef          	jal	2fa <fstat>
 192:	892a                	mv	s2,a0
 194:	8526                	mv	a0,s1
 196:	134000ef          	jal	2ca <close>
 19a:	64a2                	ld	s1,8(sp)
 19c:	854a                	mv	a0,s2
 19e:	60e2                	ld	ra,24(sp)
 1a0:	6442                	ld	s0,16(sp)
 1a2:	6902                	ld	s2,0(sp)
 1a4:	6105                	addi	sp,sp,32
 1a6:	8082                	ret
 1a8:	597d                	li	s2,-1
 1aa:	bfcd                	j	19c <stat+0x2a>

00000000000001ac <atoi>:
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e422                	sd	s0,8(sp)
 1b0:	0800                	addi	s0,sp,16
 1b2:	00054683          	lbu	a3,0(a0)
 1b6:	fd06879b          	addiw	a5,a3,-48
 1ba:	0ff7f793          	zext.b	a5,a5
 1be:	4625                	li	a2,9
 1c0:	02f66863          	bltu	a2,a5,1f0 <atoi+0x44>
 1c4:	872a                	mv	a4,a0
 1c6:	4501                	li	a0,0
 1c8:	0705                	addi	a4,a4,1
 1ca:	0025179b          	slliw	a5,a0,0x2
 1ce:	9fa9                	addw	a5,a5,a0
 1d0:	0017979b          	slliw	a5,a5,0x1
 1d4:	9fb5                	addw	a5,a5,a3
 1d6:	fd07851b          	addiw	a0,a5,-48
 1da:	00074683          	lbu	a3,0(a4)
 1de:	fd06879b          	addiw	a5,a3,-48
 1e2:	0ff7f793          	zext.b	a5,a5
 1e6:	fef671e3          	bgeu	a2,a5,1c8 <atoi+0x1c>
 1ea:	6422                	ld	s0,8(sp)
 1ec:	0141                	addi	sp,sp,16
 1ee:	8082                	ret
 1f0:	4501                	li	a0,0
 1f2:	bfe5                	j	1ea <atoi+0x3e>

00000000000001f4 <memmove>:
 1f4:	1141                	addi	sp,sp,-16
 1f6:	e422                	sd	s0,8(sp)
 1f8:	0800                	addi	s0,sp,16
 1fa:	02b57463          	bgeu	a0,a1,222 <memmove+0x2e>
 1fe:	00c05f63          	blez	a2,21c <memmove+0x28>
 202:	1602                	slli	a2,a2,0x20
 204:	9201                	srli	a2,a2,0x20
 206:	00c507b3          	add	a5,a0,a2
 20a:	872a                	mv	a4,a0
 20c:	0585                	addi	a1,a1,1
 20e:	0705                	addi	a4,a4,1
 210:	fff5c683          	lbu	a3,-1(a1)
 214:	fed70fa3          	sb	a3,-1(a4)
 218:	fef71ae3          	bne	a4,a5,20c <memmove+0x18>
 21c:	6422                	ld	s0,8(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret
 222:	00c50733          	add	a4,a0,a2
 226:	95b2                	add	a1,a1,a2
 228:	fec05ae3          	blez	a2,21c <memmove+0x28>
 22c:	fff6079b          	addiw	a5,a2,-1
 230:	1782                	slli	a5,a5,0x20
 232:	9381                	srli	a5,a5,0x20
 234:	fff7c793          	not	a5,a5
 238:	97ba                	add	a5,a5,a4
 23a:	15fd                	addi	a1,a1,-1
 23c:	177d                	addi	a4,a4,-1
 23e:	0005c683          	lbu	a3,0(a1)
 242:	00d70023          	sb	a3,0(a4)
 246:	fee79ae3          	bne	a5,a4,23a <memmove+0x46>
 24a:	bfc9                	j	21c <memmove+0x28>

000000000000024c <memcmp>:
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
 252:	ca05                	beqz	a2,282 <memcmp+0x36>
 254:	fff6069b          	addiw	a3,a2,-1
 258:	1682                	slli	a3,a3,0x20
 25a:	9281                	srli	a3,a3,0x20
 25c:	0685                	addi	a3,a3,1
 25e:	96aa                	add	a3,a3,a0
 260:	00054783          	lbu	a5,0(a0)
 264:	0005c703          	lbu	a4,0(a1)
 268:	00e79863          	bne	a5,a4,278 <memcmp+0x2c>
 26c:	0505                	addi	a0,a0,1
 26e:	0585                	addi	a1,a1,1
 270:	fed518e3          	bne	a0,a3,260 <memcmp+0x14>
 274:	4501                	li	a0,0
 276:	a019                	j	27c <memcmp+0x30>
 278:	40e7853b          	subw	a0,a5,a4
 27c:	6422                	ld	s0,8(sp)
 27e:	0141                	addi	sp,sp,16
 280:	8082                	ret
 282:	4501                	li	a0,0
 284:	bfe5                	j	27c <memcmp+0x30>

0000000000000286 <memcpy>:
 286:	1141                	addi	sp,sp,-16
 288:	e406                	sd	ra,8(sp)
 28a:	e022                	sd	s0,0(sp)
 28c:	0800                	addi	s0,sp,16
 28e:	f67ff0ef          	jal	1f4 <memmove>
 292:	60a2                	ld	ra,8(sp)
 294:	6402                	ld	s0,0(sp)
 296:	0141                	addi	sp,sp,16
 298:	8082                	ret

000000000000029a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 29a:	4885                	li	a7,1
 ecall
 29c:	00000073          	ecall
 ret
 2a0:	8082                	ret

00000000000002a2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2a2:	4889                	li	a7,2
 ecall
 2a4:	00000073          	ecall
 ret
 2a8:	8082                	ret

00000000000002aa <wait>:
.global wait
wait:
 li a7, SYS_wait
 2aa:	488d                	li	a7,3
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2b2:	4891                	li	a7,4
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <read>:
.global read
read:
 li a7, SYS_read
 2ba:	4895                	li	a7,5
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <write>:
.global write
write:
 li a7, SYS_write
 2c2:	48c1                	li	a7,16
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <close>:
.global close
close:
 li a7, SYS_close
 2ca:	48d5                	li	a7,21
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2d2:	4899                	li	a7,6
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <exec>:
.global exec
exec:
 li a7, SYS_exec
 2da:	489d                	li	a7,7
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <open>:
.global open
open:
 li a7, SYS_open
 2e2:	48bd                	li	a7,15
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2ea:	48c5                	li	a7,17
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2f2:	48c9                	li	a7,18
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2fa:	48a1                	li	a7,8
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <link>:
.global link
link:
 li a7, SYS_link
 302:	48cd                	li	a7,19
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 30a:	48d1                	li	a7,20
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 312:	48a5                	li	a7,9
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <dup>:
.global dup
dup:
 li a7, SYS_dup
 31a:	48a9                	li	a7,10
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 322:	48ad                	li	a7,11
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 32a:	48b1                	li	a7,12
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 332:	48b5                	li	a7,13
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 33a:	48b9                	li	a7,14
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 342:	48d9                	li	a7,22
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 34a:	48dd                	li	a7,23
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 352:	48e1                	li	a7,24
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 35a:	48e5                	li	a7,25
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <rand>:
.global rand
rand:
 li a7, SYS_rand
 362:	48ed                	li	a7,27
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 36a:	1101                	addi	sp,sp,-32
 36c:	ec06                	sd	ra,24(sp)
 36e:	e822                	sd	s0,16(sp)
 370:	1000                	addi	s0,sp,32
 372:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 376:	4605                	li	a2,1
 378:	fef40593          	addi	a1,s0,-17
 37c:	f47ff0ef          	jal	2c2 <write>
}
 380:	60e2                	ld	ra,24(sp)
 382:	6442                	ld	s0,16(sp)
 384:	6105                	addi	sp,sp,32
 386:	8082                	ret

0000000000000388 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 388:	7139                	addi	sp,sp,-64
 38a:	fc06                	sd	ra,56(sp)
 38c:	f822                	sd	s0,48(sp)
 38e:	f426                	sd	s1,40(sp)
 390:	0080                	addi	s0,sp,64
 392:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 394:	c299                	beqz	a3,39a <printint+0x12>
 396:	0805c963          	bltz	a1,428 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 39a:	2581                	sext.w	a1,a1
  neg = 0;
 39c:	4881                	li	a7,0
 39e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3a2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a4:	2601                	sext.w	a2,a2
 3a6:	00000517          	auipc	a0,0x0
 3aa:	53250513          	addi	a0,a0,1330 # 8d8 <digits>
 3ae:	883a                	mv	a6,a4
 3b0:	2705                	addiw	a4,a4,1
 3b2:	02c5f7bb          	remuw	a5,a1,a2
 3b6:	1782                	slli	a5,a5,0x20
 3b8:	9381                	srli	a5,a5,0x20
 3ba:	97aa                	add	a5,a5,a0
 3bc:	0007c783          	lbu	a5,0(a5)
 3c0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c4:	0005879b          	sext.w	a5,a1
 3c8:	02c5d5bb          	divuw	a1,a1,a2
 3cc:	0685                	addi	a3,a3,1
 3ce:	fec7f0e3          	bgeu	a5,a2,3ae <printint+0x26>
  if(neg)
 3d2:	00088c63          	beqz	a7,3ea <printint+0x62>
    buf[i++] = '-';
 3d6:	fd070793          	addi	a5,a4,-48
 3da:	00878733          	add	a4,a5,s0
 3de:	02d00793          	li	a5,45
 3e2:	fef70823          	sb	a5,-16(a4)
 3e6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3ea:	02e05a63          	blez	a4,41e <printint+0x96>
 3ee:	f04a                	sd	s2,32(sp)
 3f0:	ec4e                	sd	s3,24(sp)
 3f2:	fc040793          	addi	a5,s0,-64
 3f6:	00e78933          	add	s2,a5,a4
 3fa:	fff78993          	addi	s3,a5,-1
 3fe:	99ba                	add	s3,s3,a4
 400:	377d                	addiw	a4,a4,-1
 402:	1702                	slli	a4,a4,0x20
 404:	9301                	srli	a4,a4,0x20
 406:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 40a:	fff94583          	lbu	a1,-1(s2)
 40e:	8526                	mv	a0,s1
 410:	f5bff0ef          	jal	36a <putc>
  while(--i >= 0)
 414:	197d                	addi	s2,s2,-1
 416:	ff391ae3          	bne	s2,s3,40a <printint+0x82>
 41a:	7902                	ld	s2,32(sp)
 41c:	69e2                	ld	s3,24(sp)
}
 41e:	70e2                	ld	ra,56(sp)
 420:	7442                	ld	s0,48(sp)
 422:	74a2                	ld	s1,40(sp)
 424:	6121                	addi	sp,sp,64
 426:	8082                	ret
    x = -xx;
 428:	40b005bb          	negw	a1,a1
    neg = 1;
 42c:	4885                	li	a7,1
    x = -xx;
 42e:	bf85                	j	39e <printint+0x16>

0000000000000430 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 430:	711d                	addi	sp,sp,-96
 432:	ec86                	sd	ra,88(sp)
 434:	e8a2                	sd	s0,80(sp)
 436:	e0ca                	sd	s2,64(sp)
 438:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 43a:	0005c903          	lbu	s2,0(a1)
 43e:	26090863          	beqz	s2,6ae <vprintf+0x27e>
 442:	e4a6                	sd	s1,72(sp)
 444:	fc4e                	sd	s3,56(sp)
 446:	f852                	sd	s4,48(sp)
 448:	f456                	sd	s5,40(sp)
 44a:	f05a                	sd	s6,32(sp)
 44c:	ec5e                	sd	s7,24(sp)
 44e:	e862                	sd	s8,16(sp)
 450:	e466                	sd	s9,8(sp)
 452:	8b2a                	mv	s6,a0
 454:	8a2e                	mv	s4,a1
 456:	8bb2                	mv	s7,a2
  state = 0;
 458:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 45a:	4481                	li	s1,0
 45c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 45e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 462:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 466:	06c00c93          	li	s9,108
 46a:	a005                	j	48a <vprintf+0x5a>
        putc(fd, c0);
 46c:	85ca                	mv	a1,s2
 46e:	855a                	mv	a0,s6
 470:	efbff0ef          	jal	36a <putc>
 474:	a019                	j	47a <vprintf+0x4a>
    } else if(state == '%'){
 476:	03598263          	beq	s3,s5,49a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 47a:	2485                	addiw	s1,s1,1
 47c:	8726                	mv	a4,s1
 47e:	009a07b3          	add	a5,s4,s1
 482:	0007c903          	lbu	s2,0(a5)
 486:	20090c63          	beqz	s2,69e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 48a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 48e:	fe0994e3          	bnez	s3,476 <vprintf+0x46>
      if(c0 == '%'){
 492:	fd579de3          	bne	a5,s5,46c <vprintf+0x3c>
        state = '%';
 496:	89be                	mv	s3,a5
 498:	b7cd                	j	47a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 49a:	00ea06b3          	add	a3,s4,a4
 49e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4a2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4a4:	c681                	beqz	a3,4ac <vprintf+0x7c>
 4a6:	9752                	add	a4,a4,s4
 4a8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4ac:	03878f63          	beq	a5,s8,4ea <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4b0:	05978963          	beq	a5,s9,502 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4b4:	07500713          	li	a4,117
 4b8:	0ee78363          	beq	a5,a4,59e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4bc:	07800713          	li	a4,120
 4c0:	12e78563          	beq	a5,a4,5ea <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4c4:	07000713          	li	a4,112
 4c8:	14e78a63          	beq	a5,a4,61c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4cc:	07300713          	li	a4,115
 4d0:	18e78a63          	beq	a5,a4,664 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4d4:	02500713          	li	a4,37
 4d8:	04e79563          	bne	a5,a4,522 <vprintf+0xf2>
        putc(fd, '%');
 4dc:	02500593          	li	a1,37
 4e0:	855a                	mv	a0,s6
 4e2:	e89ff0ef          	jal	36a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4e6:	4981                	li	s3,0
 4e8:	bf49                	j	47a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4ea:	008b8913          	addi	s2,s7,8
 4ee:	4685                	li	a3,1
 4f0:	4629                	li	a2,10
 4f2:	000ba583          	lw	a1,0(s7)
 4f6:	855a                	mv	a0,s6
 4f8:	e91ff0ef          	jal	388 <printint>
 4fc:	8bca                	mv	s7,s2
      state = 0;
 4fe:	4981                	li	s3,0
 500:	bfad                	j	47a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 502:	06400793          	li	a5,100
 506:	02f68963          	beq	a3,a5,538 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 50a:	06c00793          	li	a5,108
 50e:	04f68263          	beq	a3,a5,552 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 512:	07500793          	li	a5,117
 516:	0af68063          	beq	a3,a5,5b6 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 51a:	07800793          	li	a5,120
 51e:	0ef68263          	beq	a3,a5,602 <vprintf+0x1d2>
        putc(fd, '%');
 522:	02500593          	li	a1,37
 526:	855a                	mv	a0,s6
 528:	e43ff0ef          	jal	36a <putc>
        putc(fd, c0);
 52c:	85ca                	mv	a1,s2
 52e:	855a                	mv	a0,s6
 530:	e3bff0ef          	jal	36a <putc>
      state = 0;
 534:	4981                	li	s3,0
 536:	b791                	j	47a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 538:	008b8913          	addi	s2,s7,8
 53c:	4685                	li	a3,1
 53e:	4629                	li	a2,10
 540:	000ba583          	lw	a1,0(s7)
 544:	855a                	mv	a0,s6
 546:	e43ff0ef          	jal	388 <printint>
        i += 1;
 54a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 54c:	8bca                	mv	s7,s2
      state = 0;
 54e:	4981                	li	s3,0
        i += 1;
 550:	b72d                	j	47a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 552:	06400793          	li	a5,100
 556:	02f60763          	beq	a2,a5,584 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 55a:	07500793          	li	a5,117
 55e:	06f60963          	beq	a2,a5,5d0 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 562:	07800793          	li	a5,120
 566:	faf61ee3          	bne	a2,a5,522 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 56a:	008b8913          	addi	s2,s7,8
 56e:	4681                	li	a3,0
 570:	4641                	li	a2,16
 572:	000ba583          	lw	a1,0(s7)
 576:	855a                	mv	a0,s6
 578:	e11ff0ef          	jal	388 <printint>
        i += 2;
 57c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 57e:	8bca                	mv	s7,s2
      state = 0;
 580:	4981                	li	s3,0
        i += 2;
 582:	bde5                	j	47a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 584:	008b8913          	addi	s2,s7,8
 588:	4685                	li	a3,1
 58a:	4629                	li	a2,10
 58c:	000ba583          	lw	a1,0(s7)
 590:	855a                	mv	a0,s6
 592:	df7ff0ef          	jal	388 <printint>
        i += 2;
 596:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 598:	8bca                	mv	s7,s2
      state = 0;
 59a:	4981                	li	s3,0
        i += 2;
 59c:	bdf9                	j	47a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 59e:	008b8913          	addi	s2,s7,8
 5a2:	4681                	li	a3,0
 5a4:	4629                	li	a2,10
 5a6:	000ba583          	lw	a1,0(s7)
 5aa:	855a                	mv	a0,s6
 5ac:	dddff0ef          	jal	388 <printint>
 5b0:	8bca                	mv	s7,s2
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	b5d9                	j	47a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b6:	008b8913          	addi	s2,s7,8
 5ba:	4681                	li	a3,0
 5bc:	4629                	li	a2,10
 5be:	000ba583          	lw	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	dc5ff0ef          	jal	388 <printint>
        i += 1;
 5c8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ca:	8bca                	mv	s7,s2
      state = 0;
 5cc:	4981                	li	s3,0
        i += 1;
 5ce:	b575                	j	47a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d0:	008b8913          	addi	s2,s7,8
 5d4:	4681                	li	a3,0
 5d6:	4629                	li	a2,10
 5d8:	000ba583          	lw	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	dabff0ef          	jal	388 <printint>
        i += 2;
 5e2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e4:	8bca                	mv	s7,s2
      state = 0;
 5e6:	4981                	li	s3,0
        i += 2;
 5e8:	bd49                	j	47a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5ea:	008b8913          	addi	s2,s7,8
 5ee:	4681                	li	a3,0
 5f0:	4641                	li	a2,16
 5f2:	000ba583          	lw	a1,0(s7)
 5f6:	855a                	mv	a0,s6
 5f8:	d91ff0ef          	jal	388 <printint>
 5fc:	8bca                	mv	s7,s2
      state = 0;
 5fe:	4981                	li	s3,0
 600:	bdad                	j	47a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 602:	008b8913          	addi	s2,s7,8
 606:	4681                	li	a3,0
 608:	4641                	li	a2,16
 60a:	000ba583          	lw	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	d79ff0ef          	jal	388 <printint>
        i += 1;
 614:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 616:	8bca                	mv	s7,s2
      state = 0;
 618:	4981                	li	s3,0
        i += 1;
 61a:	b585                	j	47a <vprintf+0x4a>
 61c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 61e:	008b8d13          	addi	s10,s7,8
 622:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 626:	03000593          	li	a1,48
 62a:	855a                	mv	a0,s6
 62c:	d3fff0ef          	jal	36a <putc>
  putc(fd, 'x');
 630:	07800593          	li	a1,120
 634:	855a                	mv	a0,s6
 636:	d35ff0ef          	jal	36a <putc>
 63a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 63c:	00000b97          	auipc	s7,0x0
 640:	29cb8b93          	addi	s7,s7,668 # 8d8 <digits>
 644:	03c9d793          	srli	a5,s3,0x3c
 648:	97de                	add	a5,a5,s7
 64a:	0007c583          	lbu	a1,0(a5)
 64e:	855a                	mv	a0,s6
 650:	d1bff0ef          	jal	36a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 654:	0992                	slli	s3,s3,0x4
 656:	397d                	addiw	s2,s2,-1
 658:	fe0916e3          	bnez	s2,644 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 65c:	8bea                	mv	s7,s10
      state = 0;
 65e:	4981                	li	s3,0
 660:	6d02                	ld	s10,0(sp)
 662:	bd21                	j	47a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 664:	008b8993          	addi	s3,s7,8
 668:	000bb903          	ld	s2,0(s7)
 66c:	00090f63          	beqz	s2,68a <vprintf+0x25a>
        for(; *s; s++)
 670:	00094583          	lbu	a1,0(s2)
 674:	c195                	beqz	a1,698 <vprintf+0x268>
          putc(fd, *s);
 676:	855a                	mv	a0,s6
 678:	cf3ff0ef          	jal	36a <putc>
        for(; *s; s++)
 67c:	0905                	addi	s2,s2,1
 67e:	00094583          	lbu	a1,0(s2)
 682:	f9f5                	bnez	a1,676 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 684:	8bce                	mv	s7,s3
      state = 0;
 686:	4981                	li	s3,0
 688:	bbcd                	j	47a <vprintf+0x4a>
          s = "(null)";
 68a:	00000917          	auipc	s2,0x0
 68e:	24690913          	addi	s2,s2,582 # 8d0 <malloc+0x13a>
        for(; *s; s++)
 692:	02800593          	li	a1,40
 696:	b7c5                	j	676 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 698:	8bce                	mv	s7,s3
      state = 0;
 69a:	4981                	li	s3,0
 69c:	bbf9                	j	47a <vprintf+0x4a>
 69e:	64a6                	ld	s1,72(sp)
 6a0:	79e2                	ld	s3,56(sp)
 6a2:	7a42                	ld	s4,48(sp)
 6a4:	7aa2                	ld	s5,40(sp)
 6a6:	7b02                	ld	s6,32(sp)
 6a8:	6be2                	ld	s7,24(sp)
 6aa:	6c42                	ld	s8,16(sp)
 6ac:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6ae:	60e6                	ld	ra,88(sp)
 6b0:	6446                	ld	s0,80(sp)
 6b2:	6906                	ld	s2,64(sp)
 6b4:	6125                	addi	sp,sp,96
 6b6:	8082                	ret

00000000000006b8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b8:	715d                	addi	sp,sp,-80
 6ba:	ec06                	sd	ra,24(sp)
 6bc:	e822                	sd	s0,16(sp)
 6be:	1000                	addi	s0,sp,32
 6c0:	e010                	sd	a2,0(s0)
 6c2:	e414                	sd	a3,8(s0)
 6c4:	e818                	sd	a4,16(s0)
 6c6:	ec1c                	sd	a5,24(s0)
 6c8:	03043023          	sd	a6,32(s0)
 6cc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6d0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6d4:	8622                	mv	a2,s0
 6d6:	d5bff0ef          	jal	430 <vprintf>
}
 6da:	60e2                	ld	ra,24(sp)
 6dc:	6442                	ld	s0,16(sp)
 6de:	6161                	addi	sp,sp,80
 6e0:	8082                	ret

00000000000006e2 <printf>:

void
printf(const char *fmt, ...)
{
 6e2:	711d                	addi	sp,sp,-96
 6e4:	ec06                	sd	ra,24(sp)
 6e6:	e822                	sd	s0,16(sp)
 6e8:	1000                	addi	s0,sp,32
 6ea:	e40c                	sd	a1,8(s0)
 6ec:	e810                	sd	a2,16(s0)
 6ee:	ec14                	sd	a3,24(s0)
 6f0:	f018                	sd	a4,32(s0)
 6f2:	f41c                	sd	a5,40(s0)
 6f4:	03043823          	sd	a6,48(s0)
 6f8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6fc:	00840613          	addi	a2,s0,8
 700:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 704:	85aa                	mv	a1,a0
 706:	4505                	li	a0,1
 708:	d29ff0ef          	jal	430 <vprintf>
}
 70c:	60e2                	ld	ra,24(sp)
 70e:	6442                	ld	s0,16(sp)
 710:	6125                	addi	sp,sp,96
 712:	8082                	ret

0000000000000714 <free>:
 714:	1141                	addi	sp,sp,-16
 716:	e422                	sd	s0,8(sp)
 718:	0800                	addi	s0,sp,16
 71a:	ff050693          	addi	a3,a0,-16
 71e:	00001797          	auipc	a5,0x1
 722:	8e27b783          	ld	a5,-1822(a5) # 1000 <freep>
 726:	a02d                	j	750 <free+0x3c>
 728:	4618                	lw	a4,8(a2)
 72a:	9f2d                	addw	a4,a4,a1
 72c:	fee52c23          	sw	a4,-8(a0)
 730:	6398                	ld	a4,0(a5)
 732:	6310                	ld	a2,0(a4)
 734:	a83d                	j	772 <free+0x5e>
 736:	ff852703          	lw	a4,-8(a0)
 73a:	9f31                	addw	a4,a4,a2
 73c:	c798                	sw	a4,8(a5)
 73e:	ff053683          	ld	a3,-16(a0)
 742:	a091                	j	786 <free+0x72>
 744:	6398                	ld	a4,0(a5)
 746:	00e7e463          	bltu	a5,a4,74e <free+0x3a>
 74a:	00e6ea63          	bltu	a3,a4,75e <free+0x4a>
 74e:	87ba                	mv	a5,a4
 750:	fed7fae3          	bgeu	a5,a3,744 <free+0x30>
 754:	6398                	ld	a4,0(a5)
 756:	00e6e463          	bltu	a3,a4,75e <free+0x4a>
 75a:	fee7eae3          	bltu	a5,a4,74e <free+0x3a>
 75e:	ff852583          	lw	a1,-8(a0)
 762:	6390                	ld	a2,0(a5)
 764:	02059813          	slli	a6,a1,0x20
 768:	01c85713          	srli	a4,a6,0x1c
 76c:	9736                	add	a4,a4,a3
 76e:	fae60de3          	beq	a2,a4,728 <free+0x14>
 772:	fec53823          	sd	a2,-16(a0)
 776:	4790                	lw	a2,8(a5)
 778:	02061593          	slli	a1,a2,0x20
 77c:	01c5d713          	srli	a4,a1,0x1c
 780:	973e                	add	a4,a4,a5
 782:	fae68ae3          	beq	a3,a4,736 <free+0x22>
 786:	e394                	sd	a3,0(a5)
 788:	00001717          	auipc	a4,0x1
 78c:	86f73c23          	sd	a5,-1928(a4) # 1000 <freep>
 790:	6422                	ld	s0,8(sp)
 792:	0141                	addi	sp,sp,16
 794:	8082                	ret

0000000000000796 <malloc>:
 796:	7139                	addi	sp,sp,-64
 798:	fc06                	sd	ra,56(sp)
 79a:	f822                	sd	s0,48(sp)
 79c:	f426                	sd	s1,40(sp)
 79e:	ec4e                	sd	s3,24(sp)
 7a0:	0080                	addi	s0,sp,64
 7a2:	02051493          	slli	s1,a0,0x20
 7a6:	9081                	srli	s1,s1,0x20
 7a8:	04bd                	addi	s1,s1,15
 7aa:	8091                	srli	s1,s1,0x4
 7ac:	0014899b          	addiw	s3,s1,1
 7b0:	0485                	addi	s1,s1,1
 7b2:	00001517          	auipc	a0,0x1
 7b6:	84e53503          	ld	a0,-1970(a0) # 1000 <freep>
 7ba:	c915                	beqz	a0,7ee <malloc+0x58>
 7bc:	611c                	ld	a5,0(a0)
 7be:	4798                	lw	a4,8(a5)
 7c0:	08977a63          	bgeu	a4,s1,854 <malloc+0xbe>
 7c4:	f04a                	sd	s2,32(sp)
 7c6:	e852                	sd	s4,16(sp)
 7c8:	e456                	sd	s5,8(sp)
 7ca:	e05a                	sd	s6,0(sp)
 7cc:	8a4e                	mv	s4,s3
 7ce:	0009871b          	sext.w	a4,s3
 7d2:	6685                	lui	a3,0x1
 7d4:	00d77363          	bgeu	a4,a3,7da <malloc+0x44>
 7d8:	6a05                	lui	s4,0x1
 7da:	000a0b1b          	sext.w	s6,s4
 7de:	004a1a1b          	slliw	s4,s4,0x4
 7e2:	00001917          	auipc	s2,0x1
 7e6:	81e90913          	addi	s2,s2,-2018 # 1000 <freep>
 7ea:	5afd                	li	s5,-1
 7ec:	a081                	j	82c <malloc+0x96>
 7ee:	f04a                	sd	s2,32(sp)
 7f0:	e852                	sd	s4,16(sp)
 7f2:	e456                	sd	s5,8(sp)
 7f4:	e05a                	sd	s6,0(sp)
 7f6:	00001797          	auipc	a5,0x1
 7fa:	81a78793          	addi	a5,a5,-2022 # 1010 <base>
 7fe:	00001717          	auipc	a4,0x1
 802:	80f73123          	sd	a5,-2046(a4) # 1000 <freep>
 806:	e39c                	sd	a5,0(a5)
 808:	0007a423          	sw	zero,8(a5)
 80c:	b7c1                	j	7cc <malloc+0x36>
 80e:	6398                	ld	a4,0(a5)
 810:	e118                	sd	a4,0(a0)
 812:	a8a9                	j	86c <malloc+0xd6>
 814:	01652423          	sw	s6,8(a0)
 818:	0541                	addi	a0,a0,16
 81a:	efbff0ef          	jal	714 <free>
 81e:	00093503          	ld	a0,0(s2)
 822:	c12d                	beqz	a0,884 <malloc+0xee>
 824:	611c                	ld	a5,0(a0)
 826:	4798                	lw	a4,8(a5)
 828:	02977263          	bgeu	a4,s1,84c <malloc+0xb6>
 82c:	00093703          	ld	a4,0(s2)
 830:	853e                	mv	a0,a5
 832:	fef719e3          	bne	a4,a5,824 <malloc+0x8e>
 836:	8552                	mv	a0,s4
 838:	af3ff0ef          	jal	32a <sbrk>
 83c:	fd551ce3          	bne	a0,s5,814 <malloc+0x7e>
 840:	4501                	li	a0,0
 842:	7902                	ld	s2,32(sp)
 844:	6a42                	ld	s4,16(sp)
 846:	6aa2                	ld	s5,8(sp)
 848:	6b02                	ld	s6,0(sp)
 84a:	a03d                	j	878 <malloc+0xe2>
 84c:	7902                	ld	s2,32(sp)
 84e:	6a42                	ld	s4,16(sp)
 850:	6aa2                	ld	s5,8(sp)
 852:	6b02                	ld	s6,0(sp)
 854:	fae48de3          	beq	s1,a4,80e <malloc+0x78>
 858:	4137073b          	subw	a4,a4,s3
 85c:	c798                	sw	a4,8(a5)
 85e:	02071693          	slli	a3,a4,0x20
 862:	01c6d713          	srli	a4,a3,0x1c
 866:	97ba                	add	a5,a5,a4
 868:	0137a423          	sw	s3,8(a5)
 86c:	00000717          	auipc	a4,0x0
 870:	78a73a23          	sd	a0,1940(a4) # 1000 <freep>
 874:	01078513          	addi	a0,a5,16
 878:	70e2                	ld	ra,56(sp)
 87a:	7442                	ld	s0,48(sp)
 87c:	74a2                	ld	s1,40(sp)
 87e:	69e2                	ld	s3,24(sp)
 880:	6121                	addi	sp,sp,64
 882:	8082                	ret
 884:	7902                	ld	s2,32(sp)
 886:	6a42                	ld	s4,16(sp)
 888:	6aa2                	ld	s5,8(sp)
 88a:	6b02                	ld	s6,0(sp)
 88c:	b7f5                	j	878 <malloc+0xe2>
