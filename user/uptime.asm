
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
  16:	87e50513          	addi	a0,a0,-1922 # 890 <malloc+0x102>
  1a:	6c0000ef          	jal	6da <printf>

    
    printf("Approx uptime: %d seconds\n", t / 100);//conert ticks to sec 
  1e:	06400593          	li	a1,100
  22:	02b4c5bb          	divw	a1,s1,a1
  26:	00001517          	auipc	a0,0x1
  2a:	88a50513          	addi	a0,a0,-1910 # 8b0 <malloc+0x122>
  2e:	6ac000ef          	jal	6da <printf>
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

0000000000000362 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 362:	1101                	addi	sp,sp,-32
 364:	ec06                	sd	ra,24(sp)
 366:	e822                	sd	s0,16(sp)
 368:	1000                	addi	s0,sp,32
 36a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 36e:	4605                	li	a2,1
 370:	fef40593          	addi	a1,s0,-17
 374:	f4fff0ef          	jal	2c2 <write>
}
 378:	60e2                	ld	ra,24(sp)
 37a:	6442                	ld	s0,16(sp)
 37c:	6105                	addi	sp,sp,32
 37e:	8082                	ret

0000000000000380 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 380:	7139                	addi	sp,sp,-64
 382:	fc06                	sd	ra,56(sp)
 384:	f822                	sd	s0,48(sp)
 386:	f426                	sd	s1,40(sp)
 388:	0080                	addi	s0,sp,64
 38a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 38c:	c299                	beqz	a3,392 <printint+0x12>
 38e:	0805c963          	bltz	a1,420 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 392:	2581                	sext.w	a1,a1
  neg = 0;
 394:	4881                	li	a7,0
 396:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 39a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 39c:	2601                	sext.w	a2,a2
 39e:	00000517          	auipc	a0,0x0
 3a2:	53a50513          	addi	a0,a0,1338 # 8d8 <digits>
 3a6:	883a                	mv	a6,a4
 3a8:	2705                	addiw	a4,a4,1
 3aa:	02c5f7bb          	remuw	a5,a1,a2
 3ae:	1782                	slli	a5,a5,0x20
 3b0:	9381                	srli	a5,a5,0x20
 3b2:	97aa                	add	a5,a5,a0
 3b4:	0007c783          	lbu	a5,0(a5)
 3b8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3bc:	0005879b          	sext.w	a5,a1
 3c0:	02c5d5bb          	divuw	a1,a1,a2
 3c4:	0685                	addi	a3,a3,1
 3c6:	fec7f0e3          	bgeu	a5,a2,3a6 <printint+0x26>
  if(neg)
 3ca:	00088c63          	beqz	a7,3e2 <printint+0x62>
    buf[i++] = '-';
 3ce:	fd070793          	addi	a5,a4,-48
 3d2:	00878733          	add	a4,a5,s0
 3d6:	02d00793          	li	a5,45
 3da:	fef70823          	sb	a5,-16(a4)
 3de:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3e2:	02e05a63          	blez	a4,416 <printint+0x96>
 3e6:	f04a                	sd	s2,32(sp)
 3e8:	ec4e                	sd	s3,24(sp)
 3ea:	fc040793          	addi	a5,s0,-64
 3ee:	00e78933          	add	s2,a5,a4
 3f2:	fff78993          	addi	s3,a5,-1
 3f6:	99ba                	add	s3,s3,a4
 3f8:	377d                	addiw	a4,a4,-1
 3fa:	1702                	slli	a4,a4,0x20
 3fc:	9301                	srli	a4,a4,0x20
 3fe:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 402:	fff94583          	lbu	a1,-1(s2)
 406:	8526                	mv	a0,s1
 408:	f5bff0ef          	jal	362 <putc>
  while(--i >= 0)
 40c:	197d                	addi	s2,s2,-1
 40e:	ff391ae3          	bne	s2,s3,402 <printint+0x82>
 412:	7902                	ld	s2,32(sp)
 414:	69e2                	ld	s3,24(sp)
}
 416:	70e2                	ld	ra,56(sp)
 418:	7442                	ld	s0,48(sp)
 41a:	74a2                	ld	s1,40(sp)
 41c:	6121                	addi	sp,sp,64
 41e:	8082                	ret
    x = -xx;
 420:	40b005bb          	negw	a1,a1
    neg = 1;
 424:	4885                	li	a7,1
    x = -xx;
 426:	bf85                	j	396 <printint+0x16>

0000000000000428 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 428:	711d                	addi	sp,sp,-96
 42a:	ec86                	sd	ra,88(sp)
 42c:	e8a2                	sd	s0,80(sp)
 42e:	e0ca                	sd	s2,64(sp)
 430:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 432:	0005c903          	lbu	s2,0(a1)
 436:	26090863          	beqz	s2,6a6 <vprintf+0x27e>
 43a:	e4a6                	sd	s1,72(sp)
 43c:	fc4e                	sd	s3,56(sp)
 43e:	f852                	sd	s4,48(sp)
 440:	f456                	sd	s5,40(sp)
 442:	f05a                	sd	s6,32(sp)
 444:	ec5e                	sd	s7,24(sp)
 446:	e862                	sd	s8,16(sp)
 448:	e466                	sd	s9,8(sp)
 44a:	8b2a                	mv	s6,a0
 44c:	8a2e                	mv	s4,a1
 44e:	8bb2                	mv	s7,a2
  state = 0;
 450:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 452:	4481                	li	s1,0
 454:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 456:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 45a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 45e:	06c00c93          	li	s9,108
 462:	a005                	j	482 <vprintf+0x5a>
        putc(fd, c0);
 464:	85ca                	mv	a1,s2
 466:	855a                	mv	a0,s6
 468:	efbff0ef          	jal	362 <putc>
 46c:	a019                	j	472 <vprintf+0x4a>
    } else if(state == '%'){
 46e:	03598263          	beq	s3,s5,492 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 472:	2485                	addiw	s1,s1,1
 474:	8726                	mv	a4,s1
 476:	009a07b3          	add	a5,s4,s1
 47a:	0007c903          	lbu	s2,0(a5)
 47e:	20090c63          	beqz	s2,696 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 482:	0009079b          	sext.w	a5,s2
    if(state == 0){
 486:	fe0994e3          	bnez	s3,46e <vprintf+0x46>
      if(c0 == '%'){
 48a:	fd579de3          	bne	a5,s5,464 <vprintf+0x3c>
        state = '%';
 48e:	89be                	mv	s3,a5
 490:	b7cd                	j	472 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 492:	00ea06b3          	add	a3,s4,a4
 496:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 49a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 49c:	c681                	beqz	a3,4a4 <vprintf+0x7c>
 49e:	9752                	add	a4,a4,s4
 4a0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4a4:	03878f63          	beq	a5,s8,4e2 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4a8:	05978963          	beq	a5,s9,4fa <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4ac:	07500713          	li	a4,117
 4b0:	0ee78363          	beq	a5,a4,596 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4b4:	07800713          	li	a4,120
 4b8:	12e78563          	beq	a5,a4,5e2 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4bc:	07000713          	li	a4,112
 4c0:	14e78a63          	beq	a5,a4,614 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4c4:	07300713          	li	a4,115
 4c8:	18e78a63          	beq	a5,a4,65c <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4cc:	02500713          	li	a4,37
 4d0:	04e79563          	bne	a5,a4,51a <vprintf+0xf2>
        putc(fd, '%');
 4d4:	02500593          	li	a1,37
 4d8:	855a                	mv	a0,s6
 4da:	e89ff0ef          	jal	362 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4de:	4981                	li	s3,0
 4e0:	bf49                	j	472 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4e2:	008b8913          	addi	s2,s7,8
 4e6:	4685                	li	a3,1
 4e8:	4629                	li	a2,10
 4ea:	000ba583          	lw	a1,0(s7)
 4ee:	855a                	mv	a0,s6
 4f0:	e91ff0ef          	jal	380 <printint>
 4f4:	8bca                	mv	s7,s2
      state = 0;
 4f6:	4981                	li	s3,0
 4f8:	bfad                	j	472 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4fa:	06400793          	li	a5,100
 4fe:	02f68963          	beq	a3,a5,530 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 502:	06c00793          	li	a5,108
 506:	04f68263          	beq	a3,a5,54a <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 50a:	07500793          	li	a5,117
 50e:	0af68063          	beq	a3,a5,5ae <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 512:	07800793          	li	a5,120
 516:	0ef68263          	beq	a3,a5,5fa <vprintf+0x1d2>
        putc(fd, '%');
 51a:	02500593          	li	a1,37
 51e:	855a                	mv	a0,s6
 520:	e43ff0ef          	jal	362 <putc>
        putc(fd, c0);
 524:	85ca                	mv	a1,s2
 526:	855a                	mv	a0,s6
 528:	e3bff0ef          	jal	362 <putc>
      state = 0;
 52c:	4981                	li	s3,0
 52e:	b791                	j	472 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 530:	008b8913          	addi	s2,s7,8
 534:	4685                	li	a3,1
 536:	4629                	li	a2,10
 538:	000ba583          	lw	a1,0(s7)
 53c:	855a                	mv	a0,s6
 53e:	e43ff0ef          	jal	380 <printint>
        i += 1;
 542:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 544:	8bca                	mv	s7,s2
      state = 0;
 546:	4981                	li	s3,0
        i += 1;
 548:	b72d                	j	472 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 54a:	06400793          	li	a5,100
 54e:	02f60763          	beq	a2,a5,57c <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 552:	07500793          	li	a5,117
 556:	06f60963          	beq	a2,a5,5c8 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 55a:	07800793          	li	a5,120
 55e:	faf61ee3          	bne	a2,a5,51a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 562:	008b8913          	addi	s2,s7,8
 566:	4681                	li	a3,0
 568:	4641                	li	a2,16
 56a:	000ba583          	lw	a1,0(s7)
 56e:	855a                	mv	a0,s6
 570:	e11ff0ef          	jal	380 <printint>
        i += 2;
 574:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 576:	8bca                	mv	s7,s2
      state = 0;
 578:	4981                	li	s3,0
        i += 2;
 57a:	bde5                	j	472 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 57c:	008b8913          	addi	s2,s7,8
 580:	4685                	li	a3,1
 582:	4629                	li	a2,10
 584:	000ba583          	lw	a1,0(s7)
 588:	855a                	mv	a0,s6
 58a:	df7ff0ef          	jal	380 <printint>
        i += 2;
 58e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 590:	8bca                	mv	s7,s2
      state = 0;
 592:	4981                	li	s3,0
        i += 2;
 594:	bdf9                	j	472 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 596:	008b8913          	addi	s2,s7,8
 59a:	4681                	li	a3,0
 59c:	4629                	li	a2,10
 59e:	000ba583          	lw	a1,0(s7)
 5a2:	855a                	mv	a0,s6
 5a4:	dddff0ef          	jal	380 <printint>
 5a8:	8bca                	mv	s7,s2
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	b5d9                	j	472 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ae:	008b8913          	addi	s2,s7,8
 5b2:	4681                	li	a3,0
 5b4:	4629                	li	a2,10
 5b6:	000ba583          	lw	a1,0(s7)
 5ba:	855a                	mv	a0,s6
 5bc:	dc5ff0ef          	jal	380 <printint>
        i += 1;
 5c0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c2:	8bca                	mv	s7,s2
      state = 0;
 5c4:	4981                	li	s3,0
        i += 1;
 5c6:	b575                	j	472 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c8:	008b8913          	addi	s2,s7,8
 5cc:	4681                	li	a3,0
 5ce:	4629                	li	a2,10
 5d0:	000ba583          	lw	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	dabff0ef          	jal	380 <printint>
        i += 2;
 5da:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5dc:	8bca                	mv	s7,s2
      state = 0;
 5de:	4981                	li	s3,0
        i += 2;
 5e0:	bd49                	j	472 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5e2:	008b8913          	addi	s2,s7,8
 5e6:	4681                	li	a3,0
 5e8:	4641                	li	a2,16
 5ea:	000ba583          	lw	a1,0(s7)
 5ee:	855a                	mv	a0,s6
 5f0:	d91ff0ef          	jal	380 <printint>
 5f4:	8bca                	mv	s7,s2
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	bdad                	j	472 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fa:	008b8913          	addi	s2,s7,8
 5fe:	4681                	li	a3,0
 600:	4641                	li	a2,16
 602:	000ba583          	lw	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	d79ff0ef          	jal	380 <printint>
        i += 1;
 60c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 60e:	8bca                	mv	s7,s2
      state = 0;
 610:	4981                	li	s3,0
        i += 1;
 612:	b585                	j	472 <vprintf+0x4a>
 614:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 616:	008b8d13          	addi	s10,s7,8
 61a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 61e:	03000593          	li	a1,48
 622:	855a                	mv	a0,s6
 624:	d3fff0ef          	jal	362 <putc>
  putc(fd, 'x');
 628:	07800593          	li	a1,120
 62c:	855a                	mv	a0,s6
 62e:	d35ff0ef          	jal	362 <putc>
 632:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 634:	00000b97          	auipc	s7,0x0
 638:	2a4b8b93          	addi	s7,s7,676 # 8d8 <digits>
 63c:	03c9d793          	srli	a5,s3,0x3c
 640:	97de                	add	a5,a5,s7
 642:	0007c583          	lbu	a1,0(a5)
 646:	855a                	mv	a0,s6
 648:	d1bff0ef          	jal	362 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 64c:	0992                	slli	s3,s3,0x4
 64e:	397d                	addiw	s2,s2,-1
 650:	fe0916e3          	bnez	s2,63c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 654:	8bea                	mv	s7,s10
      state = 0;
 656:	4981                	li	s3,0
 658:	6d02                	ld	s10,0(sp)
 65a:	bd21                	j	472 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 65c:	008b8993          	addi	s3,s7,8
 660:	000bb903          	ld	s2,0(s7)
 664:	00090f63          	beqz	s2,682 <vprintf+0x25a>
        for(; *s; s++)
 668:	00094583          	lbu	a1,0(s2)
 66c:	c195                	beqz	a1,690 <vprintf+0x268>
          putc(fd, *s);
 66e:	855a                	mv	a0,s6
 670:	cf3ff0ef          	jal	362 <putc>
        for(; *s; s++)
 674:	0905                	addi	s2,s2,1
 676:	00094583          	lbu	a1,0(s2)
 67a:	f9f5                	bnez	a1,66e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 67c:	8bce                	mv	s7,s3
      state = 0;
 67e:	4981                	li	s3,0
 680:	bbcd                	j	472 <vprintf+0x4a>
          s = "(null)";
 682:	00000917          	auipc	s2,0x0
 686:	24e90913          	addi	s2,s2,590 # 8d0 <malloc+0x142>
        for(; *s; s++)
 68a:	02800593          	li	a1,40
 68e:	b7c5                	j	66e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 690:	8bce                	mv	s7,s3
      state = 0;
 692:	4981                	li	s3,0
 694:	bbf9                	j	472 <vprintf+0x4a>
 696:	64a6                	ld	s1,72(sp)
 698:	79e2                	ld	s3,56(sp)
 69a:	7a42                	ld	s4,48(sp)
 69c:	7aa2                	ld	s5,40(sp)
 69e:	7b02                	ld	s6,32(sp)
 6a0:	6be2                	ld	s7,24(sp)
 6a2:	6c42                	ld	s8,16(sp)
 6a4:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6a6:	60e6                	ld	ra,88(sp)
 6a8:	6446                	ld	s0,80(sp)
 6aa:	6906                	ld	s2,64(sp)
 6ac:	6125                	addi	sp,sp,96
 6ae:	8082                	ret

00000000000006b0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b0:	715d                	addi	sp,sp,-80
 6b2:	ec06                	sd	ra,24(sp)
 6b4:	e822                	sd	s0,16(sp)
 6b6:	1000                	addi	s0,sp,32
 6b8:	e010                	sd	a2,0(s0)
 6ba:	e414                	sd	a3,8(s0)
 6bc:	e818                	sd	a4,16(s0)
 6be:	ec1c                	sd	a5,24(s0)
 6c0:	03043023          	sd	a6,32(s0)
 6c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6c8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6cc:	8622                	mv	a2,s0
 6ce:	d5bff0ef          	jal	428 <vprintf>
}
 6d2:	60e2                	ld	ra,24(sp)
 6d4:	6442                	ld	s0,16(sp)
 6d6:	6161                	addi	sp,sp,80
 6d8:	8082                	ret

00000000000006da <printf>:

void
printf(const char *fmt, ...)
{
 6da:	711d                	addi	sp,sp,-96
 6dc:	ec06                	sd	ra,24(sp)
 6de:	e822                	sd	s0,16(sp)
 6e0:	1000                	addi	s0,sp,32
 6e2:	e40c                	sd	a1,8(s0)
 6e4:	e810                	sd	a2,16(s0)
 6e6:	ec14                	sd	a3,24(s0)
 6e8:	f018                	sd	a4,32(s0)
 6ea:	f41c                	sd	a5,40(s0)
 6ec:	03043823          	sd	a6,48(s0)
 6f0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6f4:	00840613          	addi	a2,s0,8
 6f8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6fc:	85aa                	mv	a1,a0
 6fe:	4505                	li	a0,1
 700:	d29ff0ef          	jal	428 <vprintf>
}
 704:	60e2                	ld	ra,24(sp)
 706:	6442                	ld	s0,16(sp)
 708:	6125                	addi	sp,sp,96
 70a:	8082                	ret

000000000000070c <free>:
 70c:	1141                	addi	sp,sp,-16
 70e:	e422                	sd	s0,8(sp)
 710:	0800                	addi	s0,sp,16
 712:	ff050693          	addi	a3,a0,-16
 716:	00001797          	auipc	a5,0x1
 71a:	8ea7b783          	ld	a5,-1814(a5) # 1000 <freep>
 71e:	a02d                	j	748 <free+0x3c>
 720:	4618                	lw	a4,8(a2)
 722:	9f2d                	addw	a4,a4,a1
 724:	fee52c23          	sw	a4,-8(a0)
 728:	6398                	ld	a4,0(a5)
 72a:	6310                	ld	a2,0(a4)
 72c:	a83d                	j	76a <free+0x5e>
 72e:	ff852703          	lw	a4,-8(a0)
 732:	9f31                	addw	a4,a4,a2
 734:	c798                	sw	a4,8(a5)
 736:	ff053683          	ld	a3,-16(a0)
 73a:	a091                	j	77e <free+0x72>
 73c:	6398                	ld	a4,0(a5)
 73e:	00e7e463          	bltu	a5,a4,746 <free+0x3a>
 742:	00e6ea63          	bltu	a3,a4,756 <free+0x4a>
 746:	87ba                	mv	a5,a4
 748:	fed7fae3          	bgeu	a5,a3,73c <free+0x30>
 74c:	6398                	ld	a4,0(a5)
 74e:	00e6e463          	bltu	a3,a4,756 <free+0x4a>
 752:	fee7eae3          	bltu	a5,a4,746 <free+0x3a>
 756:	ff852583          	lw	a1,-8(a0)
 75a:	6390                	ld	a2,0(a5)
 75c:	02059813          	slli	a6,a1,0x20
 760:	01c85713          	srli	a4,a6,0x1c
 764:	9736                	add	a4,a4,a3
 766:	fae60de3          	beq	a2,a4,720 <free+0x14>
 76a:	fec53823          	sd	a2,-16(a0)
 76e:	4790                	lw	a2,8(a5)
 770:	02061593          	slli	a1,a2,0x20
 774:	01c5d713          	srli	a4,a1,0x1c
 778:	973e                	add	a4,a4,a5
 77a:	fae68ae3          	beq	a3,a4,72e <free+0x22>
 77e:	e394                	sd	a3,0(a5)
 780:	00001717          	auipc	a4,0x1
 784:	88f73023          	sd	a5,-1920(a4) # 1000 <freep>
 788:	6422                	ld	s0,8(sp)
 78a:	0141                	addi	sp,sp,16
 78c:	8082                	ret

000000000000078e <malloc>:
 78e:	7139                	addi	sp,sp,-64
 790:	fc06                	sd	ra,56(sp)
 792:	f822                	sd	s0,48(sp)
 794:	f426                	sd	s1,40(sp)
 796:	ec4e                	sd	s3,24(sp)
 798:	0080                	addi	s0,sp,64
 79a:	02051493          	slli	s1,a0,0x20
 79e:	9081                	srli	s1,s1,0x20
 7a0:	04bd                	addi	s1,s1,15
 7a2:	8091                	srli	s1,s1,0x4
 7a4:	0014899b          	addiw	s3,s1,1
 7a8:	0485                	addi	s1,s1,1
 7aa:	00001517          	auipc	a0,0x1
 7ae:	85653503          	ld	a0,-1962(a0) # 1000 <freep>
 7b2:	c915                	beqz	a0,7e6 <malloc+0x58>
 7b4:	611c                	ld	a5,0(a0)
 7b6:	4798                	lw	a4,8(a5)
 7b8:	08977a63          	bgeu	a4,s1,84c <malloc+0xbe>
 7bc:	f04a                	sd	s2,32(sp)
 7be:	e852                	sd	s4,16(sp)
 7c0:	e456                	sd	s5,8(sp)
 7c2:	e05a                	sd	s6,0(sp)
 7c4:	8a4e                	mv	s4,s3
 7c6:	0009871b          	sext.w	a4,s3
 7ca:	6685                	lui	a3,0x1
 7cc:	00d77363          	bgeu	a4,a3,7d2 <malloc+0x44>
 7d0:	6a05                	lui	s4,0x1
 7d2:	000a0b1b          	sext.w	s6,s4
 7d6:	004a1a1b          	slliw	s4,s4,0x4
 7da:	00001917          	auipc	s2,0x1
 7de:	82690913          	addi	s2,s2,-2010 # 1000 <freep>
 7e2:	5afd                	li	s5,-1
 7e4:	a081                	j	824 <malloc+0x96>
 7e6:	f04a                	sd	s2,32(sp)
 7e8:	e852                	sd	s4,16(sp)
 7ea:	e456                	sd	s5,8(sp)
 7ec:	e05a                	sd	s6,0(sp)
 7ee:	00001797          	auipc	a5,0x1
 7f2:	82278793          	addi	a5,a5,-2014 # 1010 <base>
 7f6:	00001717          	auipc	a4,0x1
 7fa:	80f73523          	sd	a5,-2038(a4) # 1000 <freep>
 7fe:	e39c                	sd	a5,0(a5)
 800:	0007a423          	sw	zero,8(a5)
 804:	b7c1                	j	7c4 <malloc+0x36>
 806:	6398                	ld	a4,0(a5)
 808:	e118                	sd	a4,0(a0)
 80a:	a8a9                	j	864 <malloc+0xd6>
 80c:	01652423          	sw	s6,8(a0)
 810:	0541                	addi	a0,a0,16
 812:	efbff0ef          	jal	70c <free>
 816:	00093503          	ld	a0,0(s2)
 81a:	c12d                	beqz	a0,87c <malloc+0xee>
 81c:	611c                	ld	a5,0(a0)
 81e:	4798                	lw	a4,8(a5)
 820:	02977263          	bgeu	a4,s1,844 <malloc+0xb6>
 824:	00093703          	ld	a4,0(s2)
 828:	853e                	mv	a0,a5
 82a:	fef719e3          	bne	a4,a5,81c <malloc+0x8e>
 82e:	8552                	mv	a0,s4
 830:	afbff0ef          	jal	32a <sbrk>
 834:	fd551ce3          	bne	a0,s5,80c <malloc+0x7e>
 838:	4501                	li	a0,0
 83a:	7902                	ld	s2,32(sp)
 83c:	6a42                	ld	s4,16(sp)
 83e:	6aa2                	ld	s5,8(sp)
 840:	6b02                	ld	s6,0(sp)
 842:	a03d                	j	870 <malloc+0xe2>
 844:	7902                	ld	s2,32(sp)
 846:	6a42                	ld	s4,16(sp)
 848:	6aa2                	ld	s5,8(sp)
 84a:	6b02                	ld	s6,0(sp)
 84c:	fae48de3          	beq	s1,a4,806 <malloc+0x78>
 850:	4137073b          	subw	a4,a4,s3
 854:	c798                	sw	a4,8(a5)
 856:	02071693          	slli	a3,a4,0x20
 85a:	01c6d713          	srli	a4,a3,0x1c
 85e:	97ba                	add	a5,a5,a4
 860:	0137a423          	sw	s3,8(a5)
 864:	00000717          	auipc	a4,0x0
 868:	78a73e23          	sd	a0,1948(a4) # 1000 <freep>
 86c:	01078513          	addi	a0,a5,16
 870:	70e2                	ld	ra,56(sp)
 872:	7442                	ld	s0,48(sp)
 874:	74a2                	ld	s1,40(sp)
 876:	69e2                	ld	s3,24(sp)
 878:	6121                	addi	sp,sp,64
 87a:	8082                	ret
 87c:	7902                	ld	s2,32(sp)
 87e:	6a42                	ld	s4,16(sp)
 880:	6aa2                	ld	s5,8(sp)
 882:	6b02                	ld	s6,0(sp)
 884:	b7f5                	j	870 <malloc+0xe2>
