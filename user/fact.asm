
user/_fact:     file format elf64-littleriscv


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
   8:	1000                	addi	s0,sp,32
  if (argc == 2 && strcmp(argv[1], "?") == 0) {
   a:	4789                	li	a5,2
   c:	06f51263          	bne	a0,a5,70 <main+0x70>
  10:	6584                	ld	s1,8(a1)
  12:	00001597          	auipc	a1,0x1
  16:	8be58593          	addi	a1,a1,-1858 # 8d0 <malloc+0xfa>
  1a:	8526                	mv	a0,s1
  1c:	0aa000ef          	jal	c6 <strcmp>
  20:	cd1d                	beqz	a0,5e <main+0x5e>
  if (argc != 2) {
    printf("You can only calculate factorial for one number\n");
    exit(0);
  }

  if (argv[1][0] == '-') {
  22:	0004c703          	lbu	a4,0(s1)
  26:	02d00793          	li	a5,45
  2a:	04f70c63          	beq	a4,a5,82 <main+0x82>
    printf("Factorial is not defined for negative numbers\n");
    exit(0);
  }

  int num = atoi(argv[1]);
  2e:	8526                	mv	a0,s1
  30:	1dc000ef          	jal	20c <atoi>
  34:	85aa                	mv	a1,a0

  int result = 1;

  for (int i = 1; i <= num; i++) {
  36:	04a05f63          	blez	a0,94 <main+0x94>
  3a:	0015071b          	addiw	a4,a0,1
  3e:	4785                	li	a5,1
  int result = 1;
  40:	4605                	li	a2,1
    result = result * i;
  42:	02f6063b          	mulw	a2,a2,a5
  for (int i = 1; i <= num; i++) {
  46:	2785                	addiw	a5,a5,1
  48:	fee79de3          	bne	a5,a4,42 <main+0x42>
  }

  printf("Factorial of %d = %d\n", num, result);
  4c:	00001517          	auipc	a0,0x1
  50:	91450513          	addi	a0,a0,-1772 # 960 <malloc+0x18a>
  54:	6ce000ef          	jal	722 <printf>

  exit(0);
  58:	4501                	li	a0,0
  5a:	2a8000ef          	jal	302 <exit>
    printf("Usage: fact <positive number>\n");
  5e:	00001517          	auipc	a0,0x1
  62:	87a50513          	addi	a0,a0,-1926 # 8d8 <malloc+0x102>
  66:	6bc000ef          	jal	722 <printf>
    exit(0);
  6a:	4501                	li	a0,0
  6c:	296000ef          	jal	302 <exit>
    printf("You can only calculate factorial for one number\n");
  70:	00001517          	auipc	a0,0x1
  74:	88850513          	addi	a0,a0,-1912 # 8f8 <malloc+0x122>
  78:	6aa000ef          	jal	722 <printf>
    exit(0);
  7c:	4501                	li	a0,0
  7e:	284000ef          	jal	302 <exit>
    printf("Factorial is not defined for negative numbers\n");
  82:	00001517          	auipc	a0,0x1
  86:	8ae50513          	addi	a0,a0,-1874 # 930 <malloc+0x15a>
  8a:	698000ef          	jal	722 <printf>
    exit(0);
  8e:	4501                	li	a0,0
  90:	272000ef          	jal	302 <exit>
  int result = 1;
  94:	4605                	li	a2,1
  96:	bf5d                	j	4c <main+0x4c>

0000000000000098 <start>:
  98:	1141                	addi	sp,sp,-16
  9a:	e406                	sd	ra,8(sp)
  9c:	e022                	sd	s0,0(sp)
  9e:	0800                	addi	s0,sp,16
  a0:	f61ff0ef          	jal	0 <main>
  a4:	4501                	li	a0,0
  a6:	25c000ef          	jal	302 <exit>

00000000000000aa <strcpy>:
  aa:	1141                	addi	sp,sp,-16
  ac:	e422                	sd	s0,8(sp)
  ae:	0800                	addi	s0,sp,16
  b0:	87aa                	mv	a5,a0
  b2:	0585                	addi	a1,a1,1
  b4:	0785                	addi	a5,a5,1
  b6:	fff5c703          	lbu	a4,-1(a1)
  ba:	fee78fa3          	sb	a4,-1(a5)
  be:	fb75                	bnez	a4,b2 <strcpy+0x8>
  c0:	6422                	ld	s0,8(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strcmp>:
  c6:	1141                	addi	sp,sp,-16
  c8:	e422                	sd	s0,8(sp)
  ca:	0800                	addi	s0,sp,16
  cc:	00054783          	lbu	a5,0(a0)
  d0:	cb91                	beqz	a5,e4 <strcmp+0x1e>
  d2:	0005c703          	lbu	a4,0(a1)
  d6:	00f71763          	bne	a4,a5,e4 <strcmp+0x1e>
  da:	0505                	addi	a0,a0,1
  dc:	0585                	addi	a1,a1,1
  de:	00054783          	lbu	a5,0(a0)
  e2:	fbe5                	bnez	a5,d2 <strcmp+0xc>
  e4:	0005c503          	lbu	a0,0(a1)
  e8:	40a7853b          	subw	a0,a5,a0
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <strlen>:
  f2:	1141                	addi	sp,sp,-16
  f4:	e422                	sd	s0,8(sp)
  f6:	0800                	addi	s0,sp,16
  f8:	00054783          	lbu	a5,0(a0)
  fc:	cf91                	beqz	a5,118 <strlen+0x26>
  fe:	0505                	addi	a0,a0,1
 100:	87aa                	mv	a5,a0
 102:	86be                	mv	a3,a5
 104:	0785                	addi	a5,a5,1
 106:	fff7c703          	lbu	a4,-1(a5)
 10a:	ff65                	bnez	a4,102 <strlen+0x10>
 10c:	40a6853b          	subw	a0,a3,a0
 110:	2505                	addiw	a0,a0,1
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret
 118:	4501                	li	a0,0
 11a:	bfe5                	j	112 <strlen+0x20>

000000000000011c <memset>:
 11c:	1141                	addi	sp,sp,-16
 11e:	e422                	sd	s0,8(sp)
 120:	0800                	addi	s0,sp,16
 122:	ca19                	beqz	a2,138 <memset+0x1c>
 124:	87aa                	mv	a5,a0
 126:	1602                	slli	a2,a2,0x20
 128:	9201                	srli	a2,a2,0x20
 12a:	00a60733          	add	a4,a2,a0
 12e:	00b78023          	sb	a1,0(a5)
 132:	0785                	addi	a5,a5,1
 134:	fee79de3          	bne	a5,a4,12e <memset+0x12>
 138:	6422                	ld	s0,8(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret

000000000000013e <strchr>:
 13e:	1141                	addi	sp,sp,-16
 140:	e422                	sd	s0,8(sp)
 142:	0800                	addi	s0,sp,16
 144:	00054783          	lbu	a5,0(a0)
 148:	cb99                	beqz	a5,15e <strchr+0x20>
 14a:	00f58763          	beq	a1,a5,158 <strchr+0x1a>
 14e:	0505                	addi	a0,a0,1
 150:	00054783          	lbu	a5,0(a0)
 154:	fbfd                	bnez	a5,14a <strchr+0xc>
 156:	4501                	li	a0,0
 158:	6422                	ld	s0,8(sp)
 15a:	0141                	addi	sp,sp,16
 15c:	8082                	ret
 15e:	4501                	li	a0,0
 160:	bfe5                	j	158 <strchr+0x1a>

0000000000000162 <gets>:
 162:	711d                	addi	sp,sp,-96
 164:	ec86                	sd	ra,88(sp)
 166:	e8a2                	sd	s0,80(sp)
 168:	e4a6                	sd	s1,72(sp)
 16a:	e0ca                	sd	s2,64(sp)
 16c:	fc4e                	sd	s3,56(sp)
 16e:	f852                	sd	s4,48(sp)
 170:	f456                	sd	s5,40(sp)
 172:	f05a                	sd	s6,32(sp)
 174:	ec5e                	sd	s7,24(sp)
 176:	1080                	addi	s0,sp,96
 178:	8baa                	mv	s7,a0
 17a:	8a2e                	mv	s4,a1
 17c:	892a                	mv	s2,a0
 17e:	4481                	li	s1,0
 180:	4aa9                	li	s5,10
 182:	4b35                	li	s6,13
 184:	89a6                	mv	s3,s1
 186:	2485                	addiw	s1,s1,1
 188:	0344d663          	bge	s1,s4,1b4 <gets+0x52>
 18c:	4605                	li	a2,1
 18e:	faf40593          	addi	a1,s0,-81
 192:	4501                	li	a0,0
 194:	186000ef          	jal	31a <read>
 198:	00a05e63          	blez	a0,1b4 <gets+0x52>
 19c:	faf44783          	lbu	a5,-81(s0)
 1a0:	00f90023          	sb	a5,0(s2)
 1a4:	01578763          	beq	a5,s5,1b2 <gets+0x50>
 1a8:	0905                	addi	s2,s2,1
 1aa:	fd679de3          	bne	a5,s6,184 <gets+0x22>
 1ae:	89a6                	mv	s3,s1
 1b0:	a011                	j	1b4 <gets+0x52>
 1b2:	89a6                	mv	s3,s1
 1b4:	99de                	add	s3,s3,s7
 1b6:	00098023          	sb	zero,0(s3)
 1ba:	855e                	mv	a0,s7
 1bc:	60e6                	ld	ra,88(sp)
 1be:	6446                	ld	s0,80(sp)
 1c0:	64a6                	ld	s1,72(sp)
 1c2:	6906                	ld	s2,64(sp)
 1c4:	79e2                	ld	s3,56(sp)
 1c6:	7a42                	ld	s4,48(sp)
 1c8:	7aa2                	ld	s5,40(sp)
 1ca:	7b02                	ld	s6,32(sp)
 1cc:	6be2                	ld	s7,24(sp)
 1ce:	6125                	addi	sp,sp,96
 1d0:	8082                	ret

00000000000001d2 <stat>:
 1d2:	1101                	addi	sp,sp,-32
 1d4:	ec06                	sd	ra,24(sp)
 1d6:	e822                	sd	s0,16(sp)
 1d8:	e04a                	sd	s2,0(sp)
 1da:	1000                	addi	s0,sp,32
 1dc:	892e                	mv	s2,a1
 1de:	4581                	li	a1,0
 1e0:	162000ef          	jal	342 <open>
 1e4:	02054263          	bltz	a0,208 <stat+0x36>
 1e8:	e426                	sd	s1,8(sp)
 1ea:	84aa                	mv	s1,a0
 1ec:	85ca                	mv	a1,s2
 1ee:	16c000ef          	jal	35a <fstat>
 1f2:	892a                	mv	s2,a0
 1f4:	8526                	mv	a0,s1
 1f6:	134000ef          	jal	32a <close>
 1fa:	64a2                	ld	s1,8(sp)
 1fc:	854a                	mv	a0,s2
 1fe:	60e2                	ld	ra,24(sp)
 200:	6442                	ld	s0,16(sp)
 202:	6902                	ld	s2,0(sp)
 204:	6105                	addi	sp,sp,32
 206:	8082                	ret
 208:	597d                	li	s2,-1
 20a:	bfcd                	j	1fc <stat+0x2a>

000000000000020c <atoi>:
 20c:	1141                	addi	sp,sp,-16
 20e:	e422                	sd	s0,8(sp)
 210:	0800                	addi	s0,sp,16
 212:	00054683          	lbu	a3,0(a0)
 216:	fd06879b          	addiw	a5,a3,-48
 21a:	0ff7f793          	zext.b	a5,a5
 21e:	4625                	li	a2,9
 220:	02f66863          	bltu	a2,a5,250 <atoi+0x44>
 224:	872a                	mv	a4,a0
 226:	4501                	li	a0,0
 228:	0705                	addi	a4,a4,1
 22a:	0025179b          	slliw	a5,a0,0x2
 22e:	9fa9                	addw	a5,a5,a0
 230:	0017979b          	slliw	a5,a5,0x1
 234:	9fb5                	addw	a5,a5,a3
 236:	fd07851b          	addiw	a0,a5,-48
 23a:	00074683          	lbu	a3,0(a4)
 23e:	fd06879b          	addiw	a5,a3,-48
 242:	0ff7f793          	zext.b	a5,a5
 246:	fef671e3          	bgeu	a2,a5,228 <atoi+0x1c>
 24a:	6422                	ld	s0,8(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret
 250:	4501                	li	a0,0
 252:	bfe5                	j	24a <atoi+0x3e>

0000000000000254 <memmove>:
 254:	1141                	addi	sp,sp,-16
 256:	e422                	sd	s0,8(sp)
 258:	0800                	addi	s0,sp,16
 25a:	02b57463          	bgeu	a0,a1,282 <memmove+0x2e>
 25e:	00c05f63          	blez	a2,27c <memmove+0x28>
 262:	1602                	slli	a2,a2,0x20
 264:	9201                	srli	a2,a2,0x20
 266:	00c507b3          	add	a5,a0,a2
 26a:	872a                	mv	a4,a0
 26c:	0585                	addi	a1,a1,1
 26e:	0705                	addi	a4,a4,1
 270:	fff5c683          	lbu	a3,-1(a1)
 274:	fed70fa3          	sb	a3,-1(a4)
 278:	fef71ae3          	bne	a4,a5,26c <memmove+0x18>
 27c:	6422                	ld	s0,8(sp)
 27e:	0141                	addi	sp,sp,16
 280:	8082                	ret
 282:	00c50733          	add	a4,a0,a2
 286:	95b2                	add	a1,a1,a2
 288:	fec05ae3          	blez	a2,27c <memmove+0x28>
 28c:	fff6079b          	addiw	a5,a2,-1
 290:	1782                	slli	a5,a5,0x20
 292:	9381                	srli	a5,a5,0x20
 294:	fff7c793          	not	a5,a5
 298:	97ba                	add	a5,a5,a4
 29a:	15fd                	addi	a1,a1,-1
 29c:	177d                	addi	a4,a4,-1
 29e:	0005c683          	lbu	a3,0(a1)
 2a2:	00d70023          	sb	a3,0(a4)
 2a6:	fee79ae3          	bne	a5,a4,29a <memmove+0x46>
 2aa:	bfc9                	j	27c <memmove+0x28>

00000000000002ac <memcmp>:
 2ac:	1141                	addi	sp,sp,-16
 2ae:	e422                	sd	s0,8(sp)
 2b0:	0800                	addi	s0,sp,16
 2b2:	ca05                	beqz	a2,2e2 <memcmp+0x36>
 2b4:	fff6069b          	addiw	a3,a2,-1
 2b8:	1682                	slli	a3,a3,0x20
 2ba:	9281                	srli	a3,a3,0x20
 2bc:	0685                	addi	a3,a3,1
 2be:	96aa                	add	a3,a3,a0
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	0005c703          	lbu	a4,0(a1)
 2c8:	00e79863          	bne	a5,a4,2d8 <memcmp+0x2c>
 2cc:	0505                	addi	a0,a0,1
 2ce:	0585                	addi	a1,a1,1
 2d0:	fed518e3          	bne	a0,a3,2c0 <memcmp+0x14>
 2d4:	4501                	li	a0,0
 2d6:	a019                	j	2dc <memcmp+0x30>
 2d8:	40e7853b          	subw	a0,a5,a4
 2dc:	6422                	ld	s0,8(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
 2e2:	4501                	li	a0,0
 2e4:	bfe5                	j	2dc <memcmp+0x30>

00000000000002e6 <memcpy>:
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
 2ee:	f67ff0ef          	jal	254 <memmove>
 2f2:	60a2                	ld	ra,8(sp)
 2f4:	6402                	ld	s0,0(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret

00000000000002fa <fork>:
 2fa:	4885                	li	a7,1
 2fc:	00000073          	ecall
 300:	8082                	ret

0000000000000302 <exit>:
 302:	4889                	li	a7,2
 304:	00000073          	ecall
 308:	8082                	ret

000000000000030a <wait>:
 30a:	488d                	li	a7,3
 30c:	00000073          	ecall
 310:	8082                	ret

0000000000000312 <pipe>:
 312:	4891                	li	a7,4
 314:	00000073          	ecall
 318:	8082                	ret

000000000000031a <read>:
 31a:	4895                	li	a7,5
 31c:	00000073          	ecall
 320:	8082                	ret

0000000000000322 <write>:
 322:	48c1                	li	a7,16
 324:	00000073          	ecall
 328:	8082                	ret

000000000000032a <close>:
 32a:	48d5                	li	a7,21
 32c:	00000073          	ecall
 330:	8082                	ret

0000000000000332 <kill>:
 332:	4899                	li	a7,6
 334:	00000073          	ecall
 338:	8082                	ret

000000000000033a <exec>:
 33a:	489d                	li	a7,7
 33c:	00000073          	ecall
 340:	8082                	ret

0000000000000342 <open>:
 342:	48bd                	li	a7,15
 344:	00000073          	ecall
 348:	8082                	ret

000000000000034a <mknod>:
 34a:	48c5                	li	a7,17
 34c:	00000073          	ecall
 350:	8082                	ret

0000000000000352 <unlink>:
 352:	48c9                	li	a7,18
 354:	00000073          	ecall
 358:	8082                	ret

000000000000035a <fstat>:
 35a:	48a1                	li	a7,8
 35c:	00000073          	ecall
 360:	8082                	ret

0000000000000362 <link>:
 362:	48cd                	li	a7,19
 364:	00000073          	ecall
 368:	8082                	ret

000000000000036a <mkdir>:
 36a:	48d1                	li	a7,20
 36c:	00000073          	ecall
 370:	8082                	ret

0000000000000372 <chdir>:
 372:	48a5                	li	a7,9
 374:	00000073          	ecall
 378:	8082                	ret

000000000000037a <dup>:
 37a:	48a9                	li	a7,10
 37c:	00000073          	ecall
 380:	8082                	ret

0000000000000382 <getpid>:
 382:	48ad                	li	a7,11
 384:	00000073          	ecall
 388:	8082                	ret

000000000000038a <sbrk>:
 38a:	48b1                	li	a7,12
 38c:	00000073          	ecall
 390:	8082                	ret

0000000000000392 <sleep>:
 392:	48b5                	li	a7,13
 394:	00000073          	ecall
 398:	8082                	ret

000000000000039a <uptime>:
 39a:	48b9                	li	a7,14
 39c:	00000073          	ecall
 3a0:	8082                	ret

00000000000003a2 <kbdint>:
 3a2:	48d9                	li	a7,22
 3a4:	00000073          	ecall
 3a8:	8082                	ret

00000000000003aa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3aa:	1101                	addi	sp,sp,-32
 3ac:	ec06                	sd	ra,24(sp)
 3ae:	e822                	sd	s0,16(sp)
 3b0:	1000                	addi	s0,sp,32
 3b2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b6:	4605                	li	a2,1
 3b8:	fef40593          	addi	a1,s0,-17
 3bc:	f67ff0ef          	jal	322 <write>
}
 3c0:	60e2                	ld	ra,24(sp)
 3c2:	6442                	ld	s0,16(sp)
 3c4:	6105                	addi	sp,sp,32
 3c6:	8082                	ret

00000000000003c8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c8:	7139                	addi	sp,sp,-64
 3ca:	fc06                	sd	ra,56(sp)
 3cc:	f822                	sd	s0,48(sp)
 3ce:	f426                	sd	s1,40(sp)
 3d0:	0080                	addi	s0,sp,64
 3d2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3d4:	c299                	beqz	a3,3da <printint+0x12>
 3d6:	0805c963          	bltz	a1,468 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3da:	2581                	sext.w	a1,a1
  neg = 0;
 3dc:	4881                	li	a7,0
 3de:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3e2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3e4:	2601                	sext.w	a2,a2
 3e6:	00000517          	auipc	a0,0x0
 3ea:	59a50513          	addi	a0,a0,1434 # 980 <digits>
 3ee:	883a                	mv	a6,a4
 3f0:	2705                	addiw	a4,a4,1
 3f2:	02c5f7bb          	remuw	a5,a1,a2
 3f6:	1782                	slli	a5,a5,0x20
 3f8:	9381                	srli	a5,a5,0x20
 3fa:	97aa                	add	a5,a5,a0
 3fc:	0007c783          	lbu	a5,0(a5)
 400:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 404:	0005879b          	sext.w	a5,a1
 408:	02c5d5bb          	divuw	a1,a1,a2
 40c:	0685                	addi	a3,a3,1
 40e:	fec7f0e3          	bgeu	a5,a2,3ee <printint+0x26>
  if(neg)
 412:	00088c63          	beqz	a7,42a <printint+0x62>
    buf[i++] = '-';
 416:	fd070793          	addi	a5,a4,-48
 41a:	00878733          	add	a4,a5,s0
 41e:	02d00793          	li	a5,45
 422:	fef70823          	sb	a5,-16(a4)
 426:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 42a:	02e05a63          	blez	a4,45e <printint+0x96>
 42e:	f04a                	sd	s2,32(sp)
 430:	ec4e                	sd	s3,24(sp)
 432:	fc040793          	addi	a5,s0,-64
 436:	00e78933          	add	s2,a5,a4
 43a:	fff78993          	addi	s3,a5,-1
 43e:	99ba                	add	s3,s3,a4
 440:	377d                	addiw	a4,a4,-1
 442:	1702                	slli	a4,a4,0x20
 444:	9301                	srli	a4,a4,0x20
 446:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 44a:	fff94583          	lbu	a1,-1(s2)
 44e:	8526                	mv	a0,s1
 450:	f5bff0ef          	jal	3aa <putc>
  while(--i >= 0)
 454:	197d                	addi	s2,s2,-1
 456:	ff391ae3          	bne	s2,s3,44a <printint+0x82>
 45a:	7902                	ld	s2,32(sp)
 45c:	69e2                	ld	s3,24(sp)
}
 45e:	70e2                	ld	ra,56(sp)
 460:	7442                	ld	s0,48(sp)
 462:	74a2                	ld	s1,40(sp)
 464:	6121                	addi	sp,sp,64
 466:	8082                	ret
    x = -xx;
 468:	40b005bb          	negw	a1,a1
    neg = 1;
 46c:	4885                	li	a7,1
    x = -xx;
 46e:	bf85                	j	3de <printint+0x16>

0000000000000470 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 470:	711d                	addi	sp,sp,-96
 472:	ec86                	sd	ra,88(sp)
 474:	e8a2                	sd	s0,80(sp)
 476:	e0ca                	sd	s2,64(sp)
 478:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 47a:	0005c903          	lbu	s2,0(a1)
 47e:	26090863          	beqz	s2,6ee <vprintf+0x27e>
 482:	e4a6                	sd	s1,72(sp)
 484:	fc4e                	sd	s3,56(sp)
 486:	f852                	sd	s4,48(sp)
 488:	f456                	sd	s5,40(sp)
 48a:	f05a                	sd	s6,32(sp)
 48c:	ec5e                	sd	s7,24(sp)
 48e:	e862                	sd	s8,16(sp)
 490:	e466                	sd	s9,8(sp)
 492:	8b2a                	mv	s6,a0
 494:	8a2e                	mv	s4,a1
 496:	8bb2                	mv	s7,a2
  state = 0;
 498:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 49a:	4481                	li	s1,0
 49c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 49e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4a2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4a6:	06c00c93          	li	s9,108
 4aa:	a005                	j	4ca <vprintf+0x5a>
        putc(fd, c0);
 4ac:	85ca                	mv	a1,s2
 4ae:	855a                	mv	a0,s6
 4b0:	efbff0ef          	jal	3aa <putc>
 4b4:	a019                	j	4ba <vprintf+0x4a>
    } else if(state == '%'){
 4b6:	03598263          	beq	s3,s5,4da <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4ba:	2485                	addiw	s1,s1,1
 4bc:	8726                	mv	a4,s1
 4be:	009a07b3          	add	a5,s4,s1
 4c2:	0007c903          	lbu	s2,0(a5)
 4c6:	20090c63          	beqz	s2,6de <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 4ca:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4ce:	fe0994e3          	bnez	s3,4b6 <vprintf+0x46>
      if(c0 == '%'){
 4d2:	fd579de3          	bne	a5,s5,4ac <vprintf+0x3c>
        state = '%';
 4d6:	89be                	mv	s3,a5
 4d8:	b7cd                	j	4ba <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4da:	00ea06b3          	add	a3,s4,a4
 4de:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4e2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4e4:	c681                	beqz	a3,4ec <vprintf+0x7c>
 4e6:	9752                	add	a4,a4,s4
 4e8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4ec:	03878f63          	beq	a5,s8,52a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4f0:	05978963          	beq	a5,s9,542 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4f4:	07500713          	li	a4,117
 4f8:	0ee78363          	beq	a5,a4,5de <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4fc:	07800713          	li	a4,120
 500:	12e78563          	beq	a5,a4,62a <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 504:	07000713          	li	a4,112
 508:	14e78a63          	beq	a5,a4,65c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 50c:	07300713          	li	a4,115
 510:	18e78a63          	beq	a5,a4,6a4 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 514:	02500713          	li	a4,37
 518:	04e79563          	bne	a5,a4,562 <vprintf+0xf2>
        putc(fd, '%');
 51c:	02500593          	li	a1,37
 520:	855a                	mv	a0,s6
 522:	e89ff0ef          	jal	3aa <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 526:	4981                	li	s3,0
 528:	bf49                	j	4ba <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 52a:	008b8913          	addi	s2,s7,8
 52e:	4685                	li	a3,1
 530:	4629                	li	a2,10
 532:	000ba583          	lw	a1,0(s7)
 536:	855a                	mv	a0,s6
 538:	e91ff0ef          	jal	3c8 <printint>
 53c:	8bca                	mv	s7,s2
      state = 0;
 53e:	4981                	li	s3,0
 540:	bfad                	j	4ba <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 542:	06400793          	li	a5,100
 546:	02f68963          	beq	a3,a5,578 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 54a:	06c00793          	li	a5,108
 54e:	04f68263          	beq	a3,a5,592 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 552:	07500793          	li	a5,117
 556:	0af68063          	beq	a3,a5,5f6 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 55a:	07800793          	li	a5,120
 55e:	0ef68263          	beq	a3,a5,642 <vprintf+0x1d2>
        putc(fd, '%');
 562:	02500593          	li	a1,37
 566:	855a                	mv	a0,s6
 568:	e43ff0ef          	jal	3aa <putc>
        putc(fd, c0);
 56c:	85ca                	mv	a1,s2
 56e:	855a                	mv	a0,s6
 570:	e3bff0ef          	jal	3aa <putc>
      state = 0;
 574:	4981                	li	s3,0
 576:	b791                	j	4ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 578:	008b8913          	addi	s2,s7,8
 57c:	4685                	li	a3,1
 57e:	4629                	li	a2,10
 580:	000ba583          	lw	a1,0(s7)
 584:	855a                	mv	a0,s6
 586:	e43ff0ef          	jal	3c8 <printint>
        i += 1;
 58a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 58c:	8bca                	mv	s7,s2
      state = 0;
 58e:	4981                	li	s3,0
        i += 1;
 590:	b72d                	j	4ba <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 592:	06400793          	li	a5,100
 596:	02f60763          	beq	a2,a5,5c4 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 59a:	07500793          	li	a5,117
 59e:	06f60963          	beq	a2,a5,610 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5a2:	07800793          	li	a5,120
 5a6:	faf61ee3          	bne	a2,a5,562 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5aa:	008b8913          	addi	s2,s7,8
 5ae:	4681                	li	a3,0
 5b0:	4641                	li	a2,16
 5b2:	000ba583          	lw	a1,0(s7)
 5b6:	855a                	mv	a0,s6
 5b8:	e11ff0ef          	jal	3c8 <printint>
        i += 2;
 5bc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5be:	8bca                	mv	s7,s2
      state = 0;
 5c0:	4981                	li	s3,0
        i += 2;
 5c2:	bde5                	j	4ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c4:	008b8913          	addi	s2,s7,8
 5c8:	4685                	li	a3,1
 5ca:	4629                	li	a2,10
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	df7ff0ef          	jal	3c8 <printint>
        i += 2;
 5d6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d8:	8bca                	mv	s7,s2
      state = 0;
 5da:	4981                	li	s3,0
        i += 2;
 5dc:	bdf9                	j	4ba <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5de:	008b8913          	addi	s2,s7,8
 5e2:	4681                	li	a3,0
 5e4:	4629                	li	a2,10
 5e6:	000ba583          	lw	a1,0(s7)
 5ea:	855a                	mv	a0,s6
 5ec:	dddff0ef          	jal	3c8 <printint>
 5f0:	8bca                	mv	s7,s2
      state = 0;
 5f2:	4981                	li	s3,0
 5f4:	b5d9                	j	4ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f6:	008b8913          	addi	s2,s7,8
 5fa:	4681                	li	a3,0
 5fc:	4629                	li	a2,10
 5fe:	000ba583          	lw	a1,0(s7)
 602:	855a                	mv	a0,s6
 604:	dc5ff0ef          	jal	3c8 <printint>
        i += 1;
 608:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 60a:	8bca                	mv	s7,s2
      state = 0;
 60c:	4981                	li	s3,0
        i += 1;
 60e:	b575                	j	4ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 610:	008b8913          	addi	s2,s7,8
 614:	4681                	li	a3,0
 616:	4629                	li	a2,10
 618:	000ba583          	lw	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	dabff0ef          	jal	3c8 <printint>
        i += 2;
 622:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 624:	8bca                	mv	s7,s2
      state = 0;
 626:	4981                	li	s3,0
        i += 2;
 628:	bd49                	j	4ba <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 62a:	008b8913          	addi	s2,s7,8
 62e:	4681                	li	a3,0
 630:	4641                	li	a2,16
 632:	000ba583          	lw	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	d91ff0ef          	jal	3c8 <printint>
 63c:	8bca                	mv	s7,s2
      state = 0;
 63e:	4981                	li	s3,0
 640:	bdad                	j	4ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 642:	008b8913          	addi	s2,s7,8
 646:	4681                	li	a3,0
 648:	4641                	li	a2,16
 64a:	000ba583          	lw	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	d79ff0ef          	jal	3c8 <printint>
        i += 1;
 654:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 656:	8bca                	mv	s7,s2
      state = 0;
 658:	4981                	li	s3,0
        i += 1;
 65a:	b585                	j	4ba <vprintf+0x4a>
 65c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 65e:	008b8d13          	addi	s10,s7,8
 662:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 666:	03000593          	li	a1,48
 66a:	855a                	mv	a0,s6
 66c:	d3fff0ef          	jal	3aa <putc>
  putc(fd, 'x');
 670:	07800593          	li	a1,120
 674:	855a                	mv	a0,s6
 676:	d35ff0ef          	jal	3aa <putc>
 67a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67c:	00000b97          	auipc	s7,0x0
 680:	304b8b93          	addi	s7,s7,772 # 980 <digits>
 684:	03c9d793          	srli	a5,s3,0x3c
 688:	97de                	add	a5,a5,s7
 68a:	0007c583          	lbu	a1,0(a5)
 68e:	855a                	mv	a0,s6
 690:	d1bff0ef          	jal	3aa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 694:	0992                	slli	s3,s3,0x4
 696:	397d                	addiw	s2,s2,-1
 698:	fe0916e3          	bnez	s2,684 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 69c:	8bea                	mv	s7,s10
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	6d02                	ld	s10,0(sp)
 6a2:	bd21                	j	4ba <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6a4:	008b8993          	addi	s3,s7,8
 6a8:	000bb903          	ld	s2,0(s7)
 6ac:	00090f63          	beqz	s2,6ca <vprintf+0x25a>
        for(; *s; s++)
 6b0:	00094583          	lbu	a1,0(s2)
 6b4:	c195                	beqz	a1,6d8 <vprintf+0x268>
          putc(fd, *s);
 6b6:	855a                	mv	a0,s6
 6b8:	cf3ff0ef          	jal	3aa <putc>
        for(; *s; s++)
 6bc:	0905                	addi	s2,s2,1
 6be:	00094583          	lbu	a1,0(s2)
 6c2:	f9f5                	bnez	a1,6b6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6c4:	8bce                	mv	s7,s3
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	bbcd                	j	4ba <vprintf+0x4a>
          s = "(null)";
 6ca:	00000917          	auipc	s2,0x0
 6ce:	2ae90913          	addi	s2,s2,686 # 978 <malloc+0x1a2>
        for(; *s; s++)
 6d2:	02800593          	li	a1,40
 6d6:	b7c5                	j	6b6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6d8:	8bce                	mv	s7,s3
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	bbf9                	j	4ba <vprintf+0x4a>
 6de:	64a6                	ld	s1,72(sp)
 6e0:	79e2                	ld	s3,56(sp)
 6e2:	7a42                	ld	s4,48(sp)
 6e4:	7aa2                	ld	s5,40(sp)
 6e6:	7b02                	ld	s6,32(sp)
 6e8:	6be2                	ld	s7,24(sp)
 6ea:	6c42                	ld	s8,16(sp)
 6ec:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6ee:	60e6                	ld	ra,88(sp)
 6f0:	6446                	ld	s0,80(sp)
 6f2:	6906                	ld	s2,64(sp)
 6f4:	6125                	addi	sp,sp,96
 6f6:	8082                	ret

00000000000006f8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f8:	715d                	addi	sp,sp,-80
 6fa:	ec06                	sd	ra,24(sp)
 6fc:	e822                	sd	s0,16(sp)
 6fe:	1000                	addi	s0,sp,32
 700:	e010                	sd	a2,0(s0)
 702:	e414                	sd	a3,8(s0)
 704:	e818                	sd	a4,16(s0)
 706:	ec1c                	sd	a5,24(s0)
 708:	03043023          	sd	a6,32(s0)
 70c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 710:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 714:	8622                	mv	a2,s0
 716:	d5bff0ef          	jal	470 <vprintf>
}
 71a:	60e2                	ld	ra,24(sp)
 71c:	6442                	ld	s0,16(sp)
 71e:	6161                	addi	sp,sp,80
 720:	8082                	ret

0000000000000722 <printf>:

void
printf(const char *fmt, ...)
{
 722:	711d                	addi	sp,sp,-96
 724:	ec06                	sd	ra,24(sp)
 726:	e822                	sd	s0,16(sp)
 728:	1000                	addi	s0,sp,32
 72a:	e40c                	sd	a1,8(s0)
 72c:	e810                	sd	a2,16(s0)
 72e:	ec14                	sd	a3,24(s0)
 730:	f018                	sd	a4,32(s0)
 732:	f41c                	sd	a5,40(s0)
 734:	03043823          	sd	a6,48(s0)
 738:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 73c:	00840613          	addi	a2,s0,8
 740:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 744:	85aa                	mv	a1,a0
 746:	4505                	li	a0,1
 748:	d29ff0ef          	jal	470 <vprintf>
}
 74c:	60e2                	ld	ra,24(sp)
 74e:	6442                	ld	s0,16(sp)
 750:	6125                	addi	sp,sp,96
 752:	8082                	ret

0000000000000754 <free>:
 754:	1141                	addi	sp,sp,-16
 756:	e422                	sd	s0,8(sp)
 758:	0800                	addi	s0,sp,16
 75a:	ff050693          	addi	a3,a0,-16
 75e:	00001797          	auipc	a5,0x1
 762:	8a27b783          	ld	a5,-1886(a5) # 1000 <freep>
 766:	a02d                	j	790 <free+0x3c>
 768:	4618                	lw	a4,8(a2)
 76a:	9f2d                	addw	a4,a4,a1
 76c:	fee52c23          	sw	a4,-8(a0)
 770:	6398                	ld	a4,0(a5)
 772:	6310                	ld	a2,0(a4)
 774:	a83d                	j	7b2 <free+0x5e>
 776:	ff852703          	lw	a4,-8(a0)
 77a:	9f31                	addw	a4,a4,a2
 77c:	c798                	sw	a4,8(a5)
 77e:	ff053683          	ld	a3,-16(a0)
 782:	a091                	j	7c6 <free+0x72>
 784:	6398                	ld	a4,0(a5)
 786:	00e7e463          	bltu	a5,a4,78e <free+0x3a>
 78a:	00e6ea63          	bltu	a3,a4,79e <free+0x4a>
 78e:	87ba                	mv	a5,a4
 790:	fed7fae3          	bgeu	a5,a3,784 <free+0x30>
 794:	6398                	ld	a4,0(a5)
 796:	00e6e463          	bltu	a3,a4,79e <free+0x4a>
 79a:	fee7eae3          	bltu	a5,a4,78e <free+0x3a>
 79e:	ff852583          	lw	a1,-8(a0)
 7a2:	6390                	ld	a2,0(a5)
 7a4:	02059813          	slli	a6,a1,0x20
 7a8:	01c85713          	srli	a4,a6,0x1c
 7ac:	9736                	add	a4,a4,a3
 7ae:	fae60de3          	beq	a2,a4,768 <free+0x14>
 7b2:	fec53823          	sd	a2,-16(a0)
 7b6:	4790                	lw	a2,8(a5)
 7b8:	02061593          	slli	a1,a2,0x20
 7bc:	01c5d713          	srli	a4,a1,0x1c
 7c0:	973e                	add	a4,a4,a5
 7c2:	fae68ae3          	beq	a3,a4,776 <free+0x22>
 7c6:	e394                	sd	a3,0(a5)
 7c8:	00001717          	auipc	a4,0x1
 7cc:	82f73c23          	sd	a5,-1992(a4) # 1000 <freep>
 7d0:	6422                	ld	s0,8(sp)
 7d2:	0141                	addi	sp,sp,16
 7d4:	8082                	ret

00000000000007d6 <malloc>:
 7d6:	7139                	addi	sp,sp,-64
 7d8:	fc06                	sd	ra,56(sp)
 7da:	f822                	sd	s0,48(sp)
 7dc:	f426                	sd	s1,40(sp)
 7de:	ec4e                	sd	s3,24(sp)
 7e0:	0080                	addi	s0,sp,64
 7e2:	02051493          	slli	s1,a0,0x20
 7e6:	9081                	srli	s1,s1,0x20
 7e8:	04bd                	addi	s1,s1,15
 7ea:	8091                	srli	s1,s1,0x4
 7ec:	0014899b          	addiw	s3,s1,1
 7f0:	0485                	addi	s1,s1,1
 7f2:	00001517          	auipc	a0,0x1
 7f6:	80e53503          	ld	a0,-2034(a0) # 1000 <freep>
 7fa:	c915                	beqz	a0,82e <malloc+0x58>
 7fc:	611c                	ld	a5,0(a0)
 7fe:	4798                	lw	a4,8(a5)
 800:	08977a63          	bgeu	a4,s1,894 <malloc+0xbe>
 804:	f04a                	sd	s2,32(sp)
 806:	e852                	sd	s4,16(sp)
 808:	e456                	sd	s5,8(sp)
 80a:	e05a                	sd	s6,0(sp)
 80c:	8a4e                	mv	s4,s3
 80e:	0009871b          	sext.w	a4,s3
 812:	6685                	lui	a3,0x1
 814:	00d77363          	bgeu	a4,a3,81a <malloc+0x44>
 818:	6a05                	lui	s4,0x1
 81a:	000a0b1b          	sext.w	s6,s4
 81e:	004a1a1b          	slliw	s4,s4,0x4
 822:	00000917          	auipc	s2,0x0
 826:	7de90913          	addi	s2,s2,2014 # 1000 <freep>
 82a:	5afd                	li	s5,-1
 82c:	a081                	j	86c <malloc+0x96>
 82e:	f04a                	sd	s2,32(sp)
 830:	e852                	sd	s4,16(sp)
 832:	e456                	sd	s5,8(sp)
 834:	e05a                	sd	s6,0(sp)
 836:	00000797          	auipc	a5,0x0
 83a:	7da78793          	addi	a5,a5,2010 # 1010 <base>
 83e:	00000717          	auipc	a4,0x0
 842:	7cf73123          	sd	a5,1986(a4) # 1000 <freep>
 846:	e39c                	sd	a5,0(a5)
 848:	0007a423          	sw	zero,8(a5)
 84c:	b7c1                	j	80c <malloc+0x36>
 84e:	6398                	ld	a4,0(a5)
 850:	e118                	sd	a4,0(a0)
 852:	a8a9                	j	8ac <malloc+0xd6>
 854:	01652423          	sw	s6,8(a0)
 858:	0541                	addi	a0,a0,16
 85a:	efbff0ef          	jal	754 <free>
 85e:	00093503          	ld	a0,0(s2)
 862:	c12d                	beqz	a0,8c4 <malloc+0xee>
 864:	611c                	ld	a5,0(a0)
 866:	4798                	lw	a4,8(a5)
 868:	02977263          	bgeu	a4,s1,88c <malloc+0xb6>
 86c:	00093703          	ld	a4,0(s2)
 870:	853e                	mv	a0,a5
 872:	fef719e3          	bne	a4,a5,864 <malloc+0x8e>
 876:	8552                	mv	a0,s4
 878:	b13ff0ef          	jal	38a <sbrk>
 87c:	fd551ce3          	bne	a0,s5,854 <malloc+0x7e>
 880:	4501                	li	a0,0
 882:	7902                	ld	s2,32(sp)
 884:	6a42                	ld	s4,16(sp)
 886:	6aa2                	ld	s5,8(sp)
 888:	6b02                	ld	s6,0(sp)
 88a:	a03d                	j	8b8 <malloc+0xe2>
 88c:	7902                	ld	s2,32(sp)
 88e:	6a42                	ld	s4,16(sp)
 890:	6aa2                	ld	s5,8(sp)
 892:	6b02                	ld	s6,0(sp)
 894:	fae48de3          	beq	s1,a4,84e <malloc+0x78>
 898:	4137073b          	subw	a4,a4,s3
 89c:	c798                	sw	a4,8(a5)
 89e:	02071693          	slli	a3,a4,0x20
 8a2:	01c6d713          	srli	a4,a3,0x1c
 8a6:	97ba                	add	a5,a5,a4
 8a8:	0137a423          	sw	s3,8(a5)
 8ac:	00000717          	auipc	a4,0x0
 8b0:	74a73a23          	sd	a0,1876(a4) # 1000 <freep>
 8b4:	01078513          	addi	a0,a5,16
 8b8:	70e2                	ld	ra,56(sp)
 8ba:	7442                	ld	s0,48(sp)
 8bc:	74a2                	ld	s1,40(sp)
 8be:	69e2                	ld	s3,24(sp)
 8c0:	6121                	addi	sp,sp,64
 8c2:	8082                	ret
 8c4:	7902                	ld	s2,32(sp)
 8c6:	6a42                	ld	s4,16(sp)
 8c8:	6aa2                	ld	s5,8(sp)
 8ca:	6b02                	ld	s6,0(sp)
 8cc:	b7f5                	j	8b8 <malloc+0xe2>
