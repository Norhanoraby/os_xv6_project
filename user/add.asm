
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
  24:	85050513          	addi	a0,a0,-1968 # 870 <malloc+0x100>
  28:	694000ef          	jal	6bc <printf>

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
 294:	4885                	li	a7,1
 296:	00000073          	ecall
 29a:	8082                	ret

000000000000029c <exit>:
 29c:	4889                	li	a7,2
 29e:	00000073          	ecall
 2a2:	8082                	ret

00000000000002a4 <wait>:
 2a4:	488d                	li	a7,3
 2a6:	00000073          	ecall
 2aa:	8082                	ret

00000000000002ac <pipe>:
 2ac:	4891                	li	a7,4
 2ae:	00000073          	ecall
 2b2:	8082                	ret

00000000000002b4 <read>:
 2b4:	4895                	li	a7,5
 2b6:	00000073          	ecall
 2ba:	8082                	ret

00000000000002bc <write>:
 2bc:	48c1                	li	a7,16
 2be:	00000073          	ecall
 2c2:	8082                	ret

00000000000002c4 <close>:
 2c4:	48d5                	li	a7,21
 2c6:	00000073          	ecall
 2ca:	8082                	ret

00000000000002cc <kill>:
 2cc:	4899                	li	a7,6
 2ce:	00000073          	ecall
 2d2:	8082                	ret

00000000000002d4 <exec>:
 2d4:	489d                	li	a7,7
 2d6:	00000073          	ecall
 2da:	8082                	ret

00000000000002dc <open>:
 2dc:	48bd                	li	a7,15
 2de:	00000073          	ecall
 2e2:	8082                	ret

00000000000002e4 <mknod>:
 2e4:	48c5                	li	a7,17
 2e6:	00000073          	ecall
 2ea:	8082                	ret

00000000000002ec <unlink>:
 2ec:	48c9                	li	a7,18
 2ee:	00000073          	ecall
 2f2:	8082                	ret

00000000000002f4 <fstat>:
 2f4:	48a1                	li	a7,8
 2f6:	00000073          	ecall
 2fa:	8082                	ret

00000000000002fc <link>:
 2fc:	48cd                	li	a7,19
 2fe:	00000073          	ecall
 302:	8082                	ret

0000000000000304 <mkdir>:
 304:	48d1                	li	a7,20
 306:	00000073          	ecall
 30a:	8082                	ret

000000000000030c <chdir>:
 30c:	48a5                	li	a7,9
 30e:	00000073          	ecall
 312:	8082                	ret

0000000000000314 <dup>:
 314:	48a9                	li	a7,10
 316:	00000073          	ecall
 31a:	8082                	ret

000000000000031c <getpid>:
 31c:	48ad                	li	a7,11
 31e:	00000073          	ecall
 322:	8082                	ret

0000000000000324 <sbrk>:
 324:	48b1                	li	a7,12
 326:	00000073          	ecall
 32a:	8082                	ret

000000000000032c <sleep>:
 32c:	48b5                	li	a7,13
 32e:	00000073          	ecall
 332:	8082                	ret

0000000000000334 <uptime>:
 334:	48b9                	li	a7,14
 336:	00000073          	ecall
 33a:	8082                	ret

000000000000033c <kbdint>:
 33c:	48d9                	li	a7,22
 33e:	00000073          	ecall
 342:	8082                	ret

0000000000000344 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 344:	1101                	addi	sp,sp,-32
 346:	ec06                	sd	ra,24(sp)
 348:	e822                	sd	s0,16(sp)
 34a:	1000                	addi	s0,sp,32
 34c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 350:	4605                	li	a2,1
 352:	fef40593          	addi	a1,s0,-17
 356:	f67ff0ef          	jal	2bc <write>
}
 35a:	60e2                	ld	ra,24(sp)
 35c:	6442                	ld	s0,16(sp)
 35e:	6105                	addi	sp,sp,32
 360:	8082                	ret

0000000000000362 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 362:	7139                	addi	sp,sp,-64
 364:	fc06                	sd	ra,56(sp)
 366:	f822                	sd	s0,48(sp)
 368:	f426                	sd	s1,40(sp)
 36a:	0080                	addi	s0,sp,64
 36c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 36e:	c299                	beqz	a3,374 <printint+0x12>
 370:	0805c963          	bltz	a1,402 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 374:	2581                	sext.w	a1,a1
  neg = 0;
 376:	4881                	li	a7,0
 378:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 37c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 37e:	2601                	sext.w	a2,a2
 380:	00000517          	auipc	a0,0x0
 384:	50050513          	addi	a0,a0,1280 # 880 <digits>
 388:	883a                	mv	a6,a4
 38a:	2705                	addiw	a4,a4,1
 38c:	02c5f7bb          	remuw	a5,a1,a2
 390:	1782                	slli	a5,a5,0x20
 392:	9381                	srli	a5,a5,0x20
 394:	97aa                	add	a5,a5,a0
 396:	0007c783          	lbu	a5,0(a5)
 39a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 39e:	0005879b          	sext.w	a5,a1
 3a2:	02c5d5bb          	divuw	a1,a1,a2
 3a6:	0685                	addi	a3,a3,1
 3a8:	fec7f0e3          	bgeu	a5,a2,388 <printint+0x26>
  if(neg)
 3ac:	00088c63          	beqz	a7,3c4 <printint+0x62>
    buf[i++] = '-';
 3b0:	fd070793          	addi	a5,a4,-48
 3b4:	00878733          	add	a4,a5,s0
 3b8:	02d00793          	li	a5,45
 3bc:	fef70823          	sb	a5,-16(a4)
 3c0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3c4:	02e05a63          	blez	a4,3f8 <printint+0x96>
 3c8:	f04a                	sd	s2,32(sp)
 3ca:	ec4e                	sd	s3,24(sp)
 3cc:	fc040793          	addi	a5,s0,-64
 3d0:	00e78933          	add	s2,a5,a4
 3d4:	fff78993          	addi	s3,a5,-1
 3d8:	99ba                	add	s3,s3,a4
 3da:	377d                	addiw	a4,a4,-1
 3dc:	1702                	slli	a4,a4,0x20
 3de:	9301                	srli	a4,a4,0x20
 3e0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3e4:	fff94583          	lbu	a1,-1(s2)
 3e8:	8526                	mv	a0,s1
 3ea:	f5bff0ef          	jal	344 <putc>
  while(--i >= 0)
 3ee:	197d                	addi	s2,s2,-1
 3f0:	ff391ae3          	bne	s2,s3,3e4 <printint+0x82>
 3f4:	7902                	ld	s2,32(sp)
 3f6:	69e2                	ld	s3,24(sp)
}
 3f8:	70e2                	ld	ra,56(sp)
 3fa:	7442                	ld	s0,48(sp)
 3fc:	74a2                	ld	s1,40(sp)
 3fe:	6121                	addi	sp,sp,64
 400:	8082                	ret
    x = -xx;
 402:	40b005bb          	negw	a1,a1
    neg = 1;
 406:	4885                	li	a7,1
    x = -xx;
 408:	bf85                	j	378 <printint+0x16>

000000000000040a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 40a:	711d                	addi	sp,sp,-96
 40c:	ec86                	sd	ra,88(sp)
 40e:	e8a2                	sd	s0,80(sp)
 410:	e0ca                	sd	s2,64(sp)
 412:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 414:	0005c903          	lbu	s2,0(a1)
 418:	26090863          	beqz	s2,688 <vprintf+0x27e>
 41c:	e4a6                	sd	s1,72(sp)
 41e:	fc4e                	sd	s3,56(sp)
 420:	f852                	sd	s4,48(sp)
 422:	f456                	sd	s5,40(sp)
 424:	f05a                	sd	s6,32(sp)
 426:	ec5e                	sd	s7,24(sp)
 428:	e862                	sd	s8,16(sp)
 42a:	e466                	sd	s9,8(sp)
 42c:	8b2a                	mv	s6,a0
 42e:	8a2e                	mv	s4,a1
 430:	8bb2                	mv	s7,a2
  state = 0;
 432:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 434:	4481                	li	s1,0
 436:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 438:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 43c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 440:	06c00c93          	li	s9,108
 444:	a005                	j	464 <vprintf+0x5a>
        putc(fd, c0);
 446:	85ca                	mv	a1,s2
 448:	855a                	mv	a0,s6
 44a:	efbff0ef          	jal	344 <putc>
 44e:	a019                	j	454 <vprintf+0x4a>
    } else if(state == '%'){
 450:	03598263          	beq	s3,s5,474 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 454:	2485                	addiw	s1,s1,1
 456:	8726                	mv	a4,s1
 458:	009a07b3          	add	a5,s4,s1
 45c:	0007c903          	lbu	s2,0(a5)
 460:	20090c63          	beqz	s2,678 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 464:	0009079b          	sext.w	a5,s2
    if(state == 0){
 468:	fe0994e3          	bnez	s3,450 <vprintf+0x46>
      if(c0 == '%'){
 46c:	fd579de3          	bne	a5,s5,446 <vprintf+0x3c>
        state = '%';
 470:	89be                	mv	s3,a5
 472:	b7cd                	j	454 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 474:	00ea06b3          	add	a3,s4,a4
 478:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 47c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 47e:	c681                	beqz	a3,486 <vprintf+0x7c>
 480:	9752                	add	a4,a4,s4
 482:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 486:	03878f63          	beq	a5,s8,4c4 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 48a:	05978963          	beq	a5,s9,4dc <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 48e:	07500713          	li	a4,117
 492:	0ee78363          	beq	a5,a4,578 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 496:	07800713          	li	a4,120
 49a:	12e78563          	beq	a5,a4,5c4 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 49e:	07000713          	li	a4,112
 4a2:	14e78a63          	beq	a5,a4,5f6 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4a6:	07300713          	li	a4,115
 4aa:	18e78a63          	beq	a5,a4,63e <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4ae:	02500713          	li	a4,37
 4b2:	04e79563          	bne	a5,a4,4fc <vprintf+0xf2>
        putc(fd, '%');
 4b6:	02500593          	li	a1,37
 4ba:	855a                	mv	a0,s6
 4bc:	e89ff0ef          	jal	344 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4c0:	4981                	li	s3,0
 4c2:	bf49                	j	454 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4c4:	008b8913          	addi	s2,s7,8
 4c8:	4685                	li	a3,1
 4ca:	4629                	li	a2,10
 4cc:	000ba583          	lw	a1,0(s7)
 4d0:	855a                	mv	a0,s6
 4d2:	e91ff0ef          	jal	362 <printint>
 4d6:	8bca                	mv	s7,s2
      state = 0;
 4d8:	4981                	li	s3,0
 4da:	bfad                	j	454 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4dc:	06400793          	li	a5,100
 4e0:	02f68963          	beq	a3,a5,512 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4e4:	06c00793          	li	a5,108
 4e8:	04f68263          	beq	a3,a5,52c <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 4ec:	07500793          	li	a5,117
 4f0:	0af68063          	beq	a3,a5,590 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 4f4:	07800793          	li	a5,120
 4f8:	0ef68263          	beq	a3,a5,5dc <vprintf+0x1d2>
        putc(fd, '%');
 4fc:	02500593          	li	a1,37
 500:	855a                	mv	a0,s6
 502:	e43ff0ef          	jal	344 <putc>
        putc(fd, c0);
 506:	85ca                	mv	a1,s2
 508:	855a                	mv	a0,s6
 50a:	e3bff0ef          	jal	344 <putc>
      state = 0;
 50e:	4981                	li	s3,0
 510:	b791                	j	454 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 512:	008b8913          	addi	s2,s7,8
 516:	4685                	li	a3,1
 518:	4629                	li	a2,10
 51a:	000ba583          	lw	a1,0(s7)
 51e:	855a                	mv	a0,s6
 520:	e43ff0ef          	jal	362 <printint>
        i += 1;
 524:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 526:	8bca                	mv	s7,s2
      state = 0;
 528:	4981                	li	s3,0
        i += 1;
 52a:	b72d                	j	454 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 52c:	06400793          	li	a5,100
 530:	02f60763          	beq	a2,a5,55e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 534:	07500793          	li	a5,117
 538:	06f60963          	beq	a2,a5,5aa <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 53c:	07800793          	li	a5,120
 540:	faf61ee3          	bne	a2,a5,4fc <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 544:	008b8913          	addi	s2,s7,8
 548:	4681                	li	a3,0
 54a:	4641                	li	a2,16
 54c:	000ba583          	lw	a1,0(s7)
 550:	855a                	mv	a0,s6
 552:	e11ff0ef          	jal	362 <printint>
        i += 2;
 556:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 558:	8bca                	mv	s7,s2
      state = 0;
 55a:	4981                	li	s3,0
        i += 2;
 55c:	bde5                	j	454 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 55e:	008b8913          	addi	s2,s7,8
 562:	4685                	li	a3,1
 564:	4629                	li	a2,10
 566:	000ba583          	lw	a1,0(s7)
 56a:	855a                	mv	a0,s6
 56c:	df7ff0ef          	jal	362 <printint>
        i += 2;
 570:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 572:	8bca                	mv	s7,s2
      state = 0;
 574:	4981                	li	s3,0
        i += 2;
 576:	bdf9                	j	454 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 578:	008b8913          	addi	s2,s7,8
 57c:	4681                	li	a3,0
 57e:	4629                	li	a2,10
 580:	000ba583          	lw	a1,0(s7)
 584:	855a                	mv	a0,s6
 586:	dddff0ef          	jal	362 <printint>
 58a:	8bca                	mv	s7,s2
      state = 0;
 58c:	4981                	li	s3,0
 58e:	b5d9                	j	454 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 590:	008b8913          	addi	s2,s7,8
 594:	4681                	li	a3,0
 596:	4629                	li	a2,10
 598:	000ba583          	lw	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	dc5ff0ef          	jal	362 <printint>
        i += 1;
 5a2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a4:	8bca                	mv	s7,s2
      state = 0;
 5a6:	4981                	li	s3,0
        i += 1;
 5a8:	b575                	j	454 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5aa:	008b8913          	addi	s2,s7,8
 5ae:	4681                	li	a3,0
 5b0:	4629                	li	a2,10
 5b2:	000ba583          	lw	a1,0(s7)
 5b6:	855a                	mv	a0,s6
 5b8:	dabff0ef          	jal	362 <printint>
        i += 2;
 5bc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5be:	8bca                	mv	s7,s2
      state = 0;
 5c0:	4981                	li	s3,0
        i += 2;
 5c2:	bd49                	j	454 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5c4:	008b8913          	addi	s2,s7,8
 5c8:	4681                	li	a3,0
 5ca:	4641                	li	a2,16
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	d91ff0ef          	jal	362 <printint>
 5d6:	8bca                	mv	s7,s2
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	bdad                	j	454 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5dc:	008b8913          	addi	s2,s7,8
 5e0:	4681                	li	a3,0
 5e2:	4641                	li	a2,16
 5e4:	000ba583          	lw	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	d79ff0ef          	jal	362 <printint>
        i += 1;
 5ee:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f0:	8bca                	mv	s7,s2
      state = 0;
 5f2:	4981                	li	s3,0
        i += 1;
 5f4:	b585                	j	454 <vprintf+0x4a>
 5f6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5f8:	008b8d13          	addi	s10,s7,8
 5fc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 600:	03000593          	li	a1,48
 604:	855a                	mv	a0,s6
 606:	d3fff0ef          	jal	344 <putc>
  putc(fd, 'x');
 60a:	07800593          	li	a1,120
 60e:	855a                	mv	a0,s6
 610:	d35ff0ef          	jal	344 <putc>
 614:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 616:	00000b97          	auipc	s7,0x0
 61a:	26ab8b93          	addi	s7,s7,618 # 880 <digits>
 61e:	03c9d793          	srli	a5,s3,0x3c
 622:	97de                	add	a5,a5,s7
 624:	0007c583          	lbu	a1,0(a5)
 628:	855a                	mv	a0,s6
 62a:	d1bff0ef          	jal	344 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 62e:	0992                	slli	s3,s3,0x4
 630:	397d                	addiw	s2,s2,-1
 632:	fe0916e3          	bnez	s2,61e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 636:	8bea                	mv	s7,s10
      state = 0;
 638:	4981                	li	s3,0
 63a:	6d02                	ld	s10,0(sp)
 63c:	bd21                	j	454 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 63e:	008b8993          	addi	s3,s7,8
 642:	000bb903          	ld	s2,0(s7)
 646:	00090f63          	beqz	s2,664 <vprintf+0x25a>
        for(; *s; s++)
 64a:	00094583          	lbu	a1,0(s2)
 64e:	c195                	beqz	a1,672 <vprintf+0x268>
          putc(fd, *s);
 650:	855a                	mv	a0,s6
 652:	cf3ff0ef          	jal	344 <putc>
        for(; *s; s++)
 656:	0905                	addi	s2,s2,1
 658:	00094583          	lbu	a1,0(s2)
 65c:	f9f5                	bnez	a1,650 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 65e:	8bce                	mv	s7,s3
      state = 0;
 660:	4981                	li	s3,0
 662:	bbcd                	j	454 <vprintf+0x4a>
          s = "(null)";
 664:	00000917          	auipc	s2,0x0
 668:	21490913          	addi	s2,s2,532 # 878 <malloc+0x108>
        for(; *s; s++)
 66c:	02800593          	li	a1,40
 670:	b7c5                	j	650 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 672:	8bce                	mv	s7,s3
      state = 0;
 674:	4981                	li	s3,0
 676:	bbf9                	j	454 <vprintf+0x4a>
 678:	64a6                	ld	s1,72(sp)
 67a:	79e2                	ld	s3,56(sp)
 67c:	7a42                	ld	s4,48(sp)
 67e:	7aa2                	ld	s5,40(sp)
 680:	7b02                	ld	s6,32(sp)
 682:	6be2                	ld	s7,24(sp)
 684:	6c42                	ld	s8,16(sp)
 686:	6ca2                	ld	s9,8(sp)
    }
  }
}
 688:	60e6                	ld	ra,88(sp)
 68a:	6446                	ld	s0,80(sp)
 68c:	6906                	ld	s2,64(sp)
 68e:	6125                	addi	sp,sp,96
 690:	8082                	ret

0000000000000692 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 692:	715d                	addi	sp,sp,-80
 694:	ec06                	sd	ra,24(sp)
 696:	e822                	sd	s0,16(sp)
 698:	1000                	addi	s0,sp,32
 69a:	e010                	sd	a2,0(s0)
 69c:	e414                	sd	a3,8(s0)
 69e:	e818                	sd	a4,16(s0)
 6a0:	ec1c                	sd	a5,24(s0)
 6a2:	03043023          	sd	a6,32(s0)
 6a6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6aa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ae:	8622                	mv	a2,s0
 6b0:	d5bff0ef          	jal	40a <vprintf>
}
 6b4:	60e2                	ld	ra,24(sp)
 6b6:	6442                	ld	s0,16(sp)
 6b8:	6161                	addi	sp,sp,80
 6ba:	8082                	ret

00000000000006bc <printf>:

void
printf(const char *fmt, ...)
{
 6bc:	711d                	addi	sp,sp,-96
 6be:	ec06                	sd	ra,24(sp)
 6c0:	e822                	sd	s0,16(sp)
 6c2:	1000                	addi	s0,sp,32
 6c4:	e40c                	sd	a1,8(s0)
 6c6:	e810                	sd	a2,16(s0)
 6c8:	ec14                	sd	a3,24(s0)
 6ca:	f018                	sd	a4,32(s0)
 6cc:	f41c                	sd	a5,40(s0)
 6ce:	03043823          	sd	a6,48(s0)
 6d2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6d6:	00840613          	addi	a2,s0,8
 6da:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6de:	85aa                	mv	a1,a0
 6e0:	4505                	li	a0,1
 6e2:	d29ff0ef          	jal	40a <vprintf>
}
 6e6:	60e2                	ld	ra,24(sp)
 6e8:	6442                	ld	s0,16(sp)
 6ea:	6125                	addi	sp,sp,96
 6ec:	8082                	ret

00000000000006ee <free>:
 6ee:	1141                	addi	sp,sp,-16
 6f0:	e422                	sd	s0,8(sp)
 6f2:	0800                	addi	s0,sp,16
 6f4:	ff050693          	addi	a3,a0,-16
 6f8:	00001797          	auipc	a5,0x1
 6fc:	9087b783          	ld	a5,-1784(a5) # 1000 <freep>
 700:	a02d                	j	72a <free+0x3c>
 702:	4618                	lw	a4,8(a2)
 704:	9f2d                	addw	a4,a4,a1
 706:	fee52c23          	sw	a4,-8(a0)
 70a:	6398                	ld	a4,0(a5)
 70c:	6310                	ld	a2,0(a4)
 70e:	a83d                	j	74c <free+0x5e>
 710:	ff852703          	lw	a4,-8(a0)
 714:	9f31                	addw	a4,a4,a2
 716:	c798                	sw	a4,8(a5)
 718:	ff053683          	ld	a3,-16(a0)
 71c:	a091                	j	760 <free+0x72>
 71e:	6398                	ld	a4,0(a5)
 720:	00e7e463          	bltu	a5,a4,728 <free+0x3a>
 724:	00e6ea63          	bltu	a3,a4,738 <free+0x4a>
 728:	87ba                	mv	a5,a4
 72a:	fed7fae3          	bgeu	a5,a3,71e <free+0x30>
 72e:	6398                	ld	a4,0(a5)
 730:	00e6e463          	bltu	a3,a4,738 <free+0x4a>
 734:	fee7eae3          	bltu	a5,a4,728 <free+0x3a>
 738:	ff852583          	lw	a1,-8(a0)
 73c:	6390                	ld	a2,0(a5)
 73e:	02059813          	slli	a6,a1,0x20
 742:	01c85713          	srli	a4,a6,0x1c
 746:	9736                	add	a4,a4,a3
 748:	fae60de3          	beq	a2,a4,702 <free+0x14>
 74c:	fec53823          	sd	a2,-16(a0)
 750:	4790                	lw	a2,8(a5)
 752:	02061593          	slli	a1,a2,0x20
 756:	01c5d713          	srli	a4,a1,0x1c
 75a:	973e                	add	a4,a4,a5
 75c:	fae68ae3          	beq	a3,a4,710 <free+0x22>
 760:	e394                	sd	a3,0(a5)
 762:	00001717          	auipc	a4,0x1
 766:	88f73f23          	sd	a5,-1890(a4) # 1000 <freep>
 76a:	6422                	ld	s0,8(sp)
 76c:	0141                	addi	sp,sp,16
 76e:	8082                	ret

0000000000000770 <malloc>:
 770:	7139                	addi	sp,sp,-64
 772:	fc06                	sd	ra,56(sp)
 774:	f822                	sd	s0,48(sp)
 776:	f426                	sd	s1,40(sp)
 778:	ec4e                	sd	s3,24(sp)
 77a:	0080                	addi	s0,sp,64
 77c:	02051493          	slli	s1,a0,0x20
 780:	9081                	srli	s1,s1,0x20
 782:	04bd                	addi	s1,s1,15
 784:	8091                	srli	s1,s1,0x4
 786:	0014899b          	addiw	s3,s1,1
 78a:	0485                	addi	s1,s1,1
 78c:	00001517          	auipc	a0,0x1
 790:	87453503          	ld	a0,-1932(a0) # 1000 <freep>
 794:	c915                	beqz	a0,7c8 <malloc+0x58>
 796:	611c                	ld	a5,0(a0)
 798:	4798                	lw	a4,8(a5)
 79a:	08977a63          	bgeu	a4,s1,82e <malloc+0xbe>
 79e:	f04a                	sd	s2,32(sp)
 7a0:	e852                	sd	s4,16(sp)
 7a2:	e456                	sd	s5,8(sp)
 7a4:	e05a                	sd	s6,0(sp)
 7a6:	8a4e                	mv	s4,s3
 7a8:	0009871b          	sext.w	a4,s3
 7ac:	6685                	lui	a3,0x1
 7ae:	00d77363          	bgeu	a4,a3,7b4 <malloc+0x44>
 7b2:	6a05                	lui	s4,0x1
 7b4:	000a0b1b          	sext.w	s6,s4
 7b8:	004a1a1b          	slliw	s4,s4,0x4
 7bc:	00001917          	auipc	s2,0x1
 7c0:	84490913          	addi	s2,s2,-1980 # 1000 <freep>
 7c4:	5afd                	li	s5,-1
 7c6:	a081                	j	806 <malloc+0x96>
 7c8:	f04a                	sd	s2,32(sp)
 7ca:	e852                	sd	s4,16(sp)
 7cc:	e456                	sd	s5,8(sp)
 7ce:	e05a                	sd	s6,0(sp)
 7d0:	00001797          	auipc	a5,0x1
 7d4:	84078793          	addi	a5,a5,-1984 # 1010 <base>
 7d8:	00001717          	auipc	a4,0x1
 7dc:	82f73423          	sd	a5,-2008(a4) # 1000 <freep>
 7e0:	e39c                	sd	a5,0(a5)
 7e2:	0007a423          	sw	zero,8(a5)
 7e6:	b7c1                	j	7a6 <malloc+0x36>
 7e8:	6398                	ld	a4,0(a5)
 7ea:	e118                	sd	a4,0(a0)
 7ec:	a8a9                	j	846 <malloc+0xd6>
 7ee:	01652423          	sw	s6,8(a0)
 7f2:	0541                	addi	a0,a0,16
 7f4:	efbff0ef          	jal	6ee <free>
 7f8:	00093503          	ld	a0,0(s2)
 7fc:	c12d                	beqz	a0,85e <malloc+0xee>
 7fe:	611c                	ld	a5,0(a0)
 800:	4798                	lw	a4,8(a5)
 802:	02977263          	bgeu	a4,s1,826 <malloc+0xb6>
 806:	00093703          	ld	a4,0(s2)
 80a:	853e                	mv	a0,a5
 80c:	fef719e3          	bne	a4,a5,7fe <malloc+0x8e>
 810:	8552                	mv	a0,s4
 812:	b13ff0ef          	jal	324 <sbrk>
 816:	fd551ce3          	bne	a0,s5,7ee <malloc+0x7e>
 81a:	4501                	li	a0,0
 81c:	7902                	ld	s2,32(sp)
 81e:	6a42                	ld	s4,16(sp)
 820:	6aa2                	ld	s5,8(sp)
 822:	6b02                	ld	s6,0(sp)
 824:	a03d                	j	852 <malloc+0xe2>
 826:	7902                	ld	s2,32(sp)
 828:	6a42                	ld	s4,16(sp)
 82a:	6aa2                	ld	s5,8(sp)
 82c:	6b02                	ld	s6,0(sp)
 82e:	fae48de3          	beq	s1,a4,7e8 <malloc+0x78>
 832:	4137073b          	subw	a4,a4,s3
 836:	c798                	sw	a4,8(a5)
 838:	02071693          	slli	a3,a4,0x20
 83c:	01c6d713          	srli	a4,a3,0x1c
 840:	97ba                	add	a5,a5,a4
 842:	0137a423          	sw	s3,8(a5)
 846:	00000717          	auipc	a4,0x0
 84a:	7aa73d23          	sd	a0,1978(a4) # 1000 <freep>
 84e:	01078513          	addi	a0,a5,16
 852:	70e2                	ld	ra,56(sp)
 854:	7442                	ld	s0,48(sp)
 856:	74a2                	ld	s1,40(sp)
 858:	69e2                	ld	s3,24(sp)
 85a:	6121                	addi	sp,sp,64
 85c:	8082                	ret
 85e:	7902                	ld	s2,32(sp)
 860:	6a42                	ld	s4,16(sp)
 862:	6aa2                	ld	s5,8(sp)
 864:	6b02                	ld	s6,0(sp)
 866:	b7f5                	j	852 <malloc+0xe2>
