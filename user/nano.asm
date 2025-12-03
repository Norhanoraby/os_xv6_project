
user/_nano:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
   8:	4789                	li	a5,2
   a:	00f50f63          	beq	a0,a5,28 <main+0x28>
   e:	ec26                	sd	s1,24(sp)
  10:	e84a                	sd	s2,16(sp)
  12:	e44e                	sd	s3,8(sp)
  14:	e052                	sd	s4,0(sp)
  16:	00001517          	auipc	a0,0x1
  1a:	94a50513          	addi	a0,a0,-1718 # 960 <malloc+0xfe>
  1e:	790000ef          	jal	7ae <printf>
  22:	4505                	li	a0,1
  24:	34a000ef          	jal	36e <exit>
  28:	e84a                	sd	s2,16(sp)
  2a:	e052                	sd	s4,0(sp)
  2c:	0085ba03          	ld	s4,8(a1)
  30:	20200593          	li	a1,514
  34:	8552                	mv	a0,s4
  36:	378000ef          	jal	3ae <open>
  3a:	892a                	mv	s2,a0
  3c:	00054f63          	bltz	a0,5a <main+0x5a>
  40:	ec26                	sd	s1,24(sp)
  42:	e44e                	sd	s3,8(sp)
  44:	00001517          	auipc	a0,0x1
  48:	95450513          	addi	a0,a0,-1708 # 998 <malloc+0x136>
  4c:	762000ef          	jal	7ae <printf>
  50:	00001497          	auipc	s1,0x1
  54:	fc048493          	addi	s1,s1,-64 # 1010 <buf>
  58:	a00d                	j	7a <main+0x7a>
  5a:	ec26                	sd	s1,24(sp)
  5c:	e44e                	sd	s3,8(sp)
  5e:	85d2                	mv	a1,s4
  60:	00001517          	auipc	a0,0x1
  64:	92050513          	addi	a0,a0,-1760 # 980 <malloc+0x11e>
  68:	746000ef          	jal	7ae <printf>
  6c:	4505                	li	a0,1
  6e:	300000ef          	jal	36e <exit>
  72:	85a6                	mv	a1,s1
  74:	4505                	li	a0,1
  76:	318000ef          	jal	38e <write>
  7a:	20000613          	li	a2,512
  7e:	85a6                	mv	a1,s1
  80:	854a                	mv	a0,s2
  82:	304000ef          	jal	386 <read>
  86:	862a                	mv	a2,a0
  88:	fea045e3          	bgtz	a0,72 <main+0x72>
  8c:	854a                	mv	a0,s2
  8e:	308000ef          	jal	396 <close>
  92:	20100593          	li	a1,513
  96:	8552                	mv	a0,s4
  98:	316000ef          	jal	3ae <open>
  9c:	89aa                	mv	s3,a0
  9e:	00001917          	auipc	s2,0x1
  a2:	f7290913          	addi	s2,s2,-142 # 1010 <buf>
  a6:	04054563          	bltz	a0,f0 <main+0xf0>
  aa:	20000613          	li	a2,512
  ae:	85ca                	mv	a1,s2
  b0:	4501                	li	a0,0
  b2:	2d4000ef          	jal	386 <read>
  b6:	84aa                	mv	s1,a0
  b8:	00a05f63          	blez	a0,d6 <main+0xd6>
  bc:	8626                	mv	a2,s1
  be:	85ca                	mv	a1,s2
  c0:	854e                	mv	a0,s3
  c2:	2cc000ef          	jal	38e <write>
  c6:	fe9502e3          	beq	a0,s1,aa <main+0xaa>
  ca:	00001517          	auipc	a0,0x1
  ce:	91e50513          	addi	a0,a0,-1762 # 9e8 <malloc+0x186>
  d2:	6dc000ef          	jal	7ae <printf>
  d6:	854e                	mv	a0,s3
  d8:	2be000ef          	jal	396 <close>
  dc:	85d2                	mv	a1,s4
  de:	00001517          	auipc	a0,0x1
  e2:	92250513          	addi	a0,a0,-1758 # a00 <malloc+0x19e>
  e6:	6c8000ef          	jal	7ae <printf>
  ea:	4501                	li	a0,0
  ec:	282000ef          	jal	36e <exit>
  f0:	85d2                	mv	a1,s4
  f2:	00001517          	auipc	a0,0x1
  f6:	8de50513          	addi	a0,a0,-1826 # 9d0 <malloc+0x16e>
  fa:	6b4000ef          	jal	7ae <printf>
  fe:	4505                	li	a0,1
 100:	26e000ef          	jal	36e <exit>

0000000000000104 <start>:
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
 10c:	ef5ff0ef          	jal	0 <main>
 110:	4501                	li	a0,0
 112:	25c000ef          	jal	36e <exit>

0000000000000116 <strcpy>:
 116:	1141                	addi	sp,sp,-16
 118:	e422                	sd	s0,8(sp)
 11a:	0800                	addi	s0,sp,16
 11c:	87aa                	mv	a5,a0
 11e:	0585                	addi	a1,a1,1
 120:	0785                	addi	a5,a5,1
 122:	fff5c703          	lbu	a4,-1(a1)
 126:	fee78fa3          	sb	a4,-1(a5)
 12a:	fb75                	bnez	a4,11e <strcpy+0x8>
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strcmp>:
 132:	1141                	addi	sp,sp,-16
 134:	e422                	sd	s0,8(sp)
 136:	0800                	addi	s0,sp,16
 138:	00054783          	lbu	a5,0(a0)
 13c:	cb91                	beqz	a5,150 <strcmp+0x1e>
 13e:	0005c703          	lbu	a4,0(a1)
 142:	00f71763          	bne	a4,a5,150 <strcmp+0x1e>
 146:	0505                	addi	a0,a0,1
 148:	0585                	addi	a1,a1,1
 14a:	00054783          	lbu	a5,0(a0)
 14e:	fbe5                	bnez	a5,13e <strcmp+0xc>
 150:	0005c503          	lbu	a0,0(a1)
 154:	40a7853b          	subw	a0,a5,a0
 158:	6422                	ld	s0,8(sp)
 15a:	0141                	addi	sp,sp,16
 15c:	8082                	ret

000000000000015e <strlen>:
 15e:	1141                	addi	sp,sp,-16
 160:	e422                	sd	s0,8(sp)
 162:	0800                	addi	s0,sp,16
 164:	00054783          	lbu	a5,0(a0)
 168:	cf91                	beqz	a5,184 <strlen+0x26>
 16a:	0505                	addi	a0,a0,1
 16c:	87aa                	mv	a5,a0
 16e:	86be                	mv	a3,a5
 170:	0785                	addi	a5,a5,1
 172:	fff7c703          	lbu	a4,-1(a5)
 176:	ff65                	bnez	a4,16e <strlen+0x10>
 178:	40a6853b          	subw	a0,a3,a0
 17c:	2505                	addiw	a0,a0,1
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret
 184:	4501                	li	a0,0
 186:	bfe5                	j	17e <strlen+0x20>

0000000000000188 <memset>:
 188:	1141                	addi	sp,sp,-16
 18a:	e422                	sd	s0,8(sp)
 18c:	0800                	addi	s0,sp,16
 18e:	ca19                	beqz	a2,1a4 <memset+0x1c>
 190:	87aa                	mv	a5,a0
 192:	1602                	slli	a2,a2,0x20
 194:	9201                	srli	a2,a2,0x20
 196:	00a60733          	add	a4,a2,a0
 19a:	00b78023          	sb	a1,0(a5)
 19e:	0785                	addi	a5,a5,1
 1a0:	fee79de3          	bne	a5,a4,19a <memset+0x12>
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret

00000000000001aa <strchr>:
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	cb99                	beqz	a5,1ca <strchr+0x20>
 1b6:	00f58763          	beq	a1,a5,1c4 <strchr+0x1a>
 1ba:	0505                	addi	a0,a0,1
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	fbfd                	bnez	a5,1b6 <strchr+0xc>
 1c2:	4501                	li	a0,0
 1c4:	6422                	ld	s0,8(sp)
 1c6:	0141                	addi	sp,sp,16
 1c8:	8082                	ret
 1ca:	4501                	li	a0,0
 1cc:	bfe5                	j	1c4 <strchr+0x1a>

00000000000001ce <gets>:
 1ce:	711d                	addi	sp,sp,-96
 1d0:	ec86                	sd	ra,88(sp)
 1d2:	e8a2                	sd	s0,80(sp)
 1d4:	e4a6                	sd	s1,72(sp)
 1d6:	e0ca                	sd	s2,64(sp)
 1d8:	fc4e                	sd	s3,56(sp)
 1da:	f852                	sd	s4,48(sp)
 1dc:	f456                	sd	s5,40(sp)
 1de:	f05a                	sd	s6,32(sp)
 1e0:	ec5e                	sd	s7,24(sp)
 1e2:	1080                	addi	s0,sp,96
 1e4:	8baa                	mv	s7,a0
 1e6:	8a2e                	mv	s4,a1
 1e8:	892a                	mv	s2,a0
 1ea:	4481                	li	s1,0
 1ec:	4aa9                	li	s5,10
 1ee:	4b35                	li	s6,13
 1f0:	89a6                	mv	s3,s1
 1f2:	2485                	addiw	s1,s1,1
 1f4:	0344d663          	bge	s1,s4,220 <gets+0x52>
 1f8:	4605                	li	a2,1
 1fa:	faf40593          	addi	a1,s0,-81
 1fe:	4501                	li	a0,0
 200:	186000ef          	jal	386 <read>
 204:	00a05e63          	blez	a0,220 <gets+0x52>
 208:	faf44783          	lbu	a5,-81(s0)
 20c:	00f90023          	sb	a5,0(s2)
 210:	01578763          	beq	a5,s5,21e <gets+0x50>
 214:	0905                	addi	s2,s2,1
 216:	fd679de3          	bne	a5,s6,1f0 <gets+0x22>
 21a:	89a6                	mv	s3,s1
 21c:	a011                	j	220 <gets+0x52>
 21e:	89a6                	mv	s3,s1
 220:	99de                	add	s3,s3,s7
 222:	00098023          	sb	zero,0(s3)
 226:	855e                	mv	a0,s7
 228:	60e6                	ld	ra,88(sp)
 22a:	6446                	ld	s0,80(sp)
 22c:	64a6                	ld	s1,72(sp)
 22e:	6906                	ld	s2,64(sp)
 230:	79e2                	ld	s3,56(sp)
 232:	7a42                	ld	s4,48(sp)
 234:	7aa2                	ld	s5,40(sp)
 236:	7b02                	ld	s6,32(sp)
 238:	6be2                	ld	s7,24(sp)
 23a:	6125                	addi	sp,sp,96
 23c:	8082                	ret

000000000000023e <stat>:
 23e:	1101                	addi	sp,sp,-32
 240:	ec06                	sd	ra,24(sp)
 242:	e822                	sd	s0,16(sp)
 244:	e04a                	sd	s2,0(sp)
 246:	1000                	addi	s0,sp,32
 248:	892e                	mv	s2,a1
 24a:	4581                	li	a1,0
 24c:	162000ef          	jal	3ae <open>
 250:	02054263          	bltz	a0,274 <stat+0x36>
 254:	e426                	sd	s1,8(sp)
 256:	84aa                	mv	s1,a0
 258:	85ca                	mv	a1,s2
 25a:	16c000ef          	jal	3c6 <fstat>
 25e:	892a                	mv	s2,a0
 260:	8526                	mv	a0,s1
 262:	134000ef          	jal	396 <close>
 266:	64a2                	ld	s1,8(sp)
 268:	854a                	mv	a0,s2
 26a:	60e2                	ld	ra,24(sp)
 26c:	6442                	ld	s0,16(sp)
 26e:	6902                	ld	s2,0(sp)
 270:	6105                	addi	sp,sp,32
 272:	8082                	ret
 274:	597d                	li	s2,-1
 276:	bfcd                	j	268 <stat+0x2a>

0000000000000278 <atoi>:
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
 27e:	00054683          	lbu	a3,0(a0)
 282:	fd06879b          	addiw	a5,a3,-48
 286:	0ff7f793          	zext.b	a5,a5
 28a:	4625                	li	a2,9
 28c:	02f66863          	bltu	a2,a5,2bc <atoi+0x44>
 290:	872a                	mv	a4,a0
 292:	4501                	li	a0,0
 294:	0705                	addi	a4,a4,1
 296:	0025179b          	slliw	a5,a0,0x2
 29a:	9fa9                	addw	a5,a5,a0
 29c:	0017979b          	slliw	a5,a5,0x1
 2a0:	9fb5                	addw	a5,a5,a3
 2a2:	fd07851b          	addiw	a0,a5,-48
 2a6:	00074683          	lbu	a3,0(a4)
 2aa:	fd06879b          	addiw	a5,a3,-48
 2ae:	0ff7f793          	zext.b	a5,a5
 2b2:	fef671e3          	bgeu	a2,a5,294 <atoi+0x1c>
 2b6:	6422                	ld	s0,8(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret
 2bc:	4501                	li	a0,0
 2be:	bfe5                	j	2b6 <atoi+0x3e>

00000000000002c0 <memmove>:
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e422                	sd	s0,8(sp)
 2c4:	0800                	addi	s0,sp,16
 2c6:	02b57463          	bgeu	a0,a1,2ee <memmove+0x2e>
 2ca:	00c05f63          	blez	a2,2e8 <memmove+0x28>
 2ce:	1602                	slli	a2,a2,0x20
 2d0:	9201                	srli	a2,a2,0x20
 2d2:	00c507b3          	add	a5,a0,a2
 2d6:	872a                	mv	a4,a0
 2d8:	0585                	addi	a1,a1,1
 2da:	0705                	addi	a4,a4,1
 2dc:	fff5c683          	lbu	a3,-1(a1)
 2e0:	fed70fa3          	sb	a3,-1(a4)
 2e4:	fef71ae3          	bne	a4,a5,2d8 <memmove+0x18>
 2e8:	6422                	ld	s0,8(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret
 2ee:	00c50733          	add	a4,a0,a2
 2f2:	95b2                	add	a1,a1,a2
 2f4:	fec05ae3          	blez	a2,2e8 <memmove+0x28>
 2f8:	fff6079b          	addiw	a5,a2,-1
 2fc:	1782                	slli	a5,a5,0x20
 2fe:	9381                	srli	a5,a5,0x20
 300:	fff7c793          	not	a5,a5
 304:	97ba                	add	a5,a5,a4
 306:	15fd                	addi	a1,a1,-1
 308:	177d                	addi	a4,a4,-1
 30a:	0005c683          	lbu	a3,0(a1)
 30e:	00d70023          	sb	a3,0(a4)
 312:	fee79ae3          	bne	a5,a4,306 <memmove+0x46>
 316:	bfc9                	j	2e8 <memmove+0x28>

0000000000000318 <memcmp>:
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
 31e:	ca05                	beqz	a2,34e <memcmp+0x36>
 320:	fff6069b          	addiw	a3,a2,-1
 324:	1682                	slli	a3,a3,0x20
 326:	9281                	srli	a3,a3,0x20
 328:	0685                	addi	a3,a3,1
 32a:	96aa                	add	a3,a3,a0
 32c:	00054783          	lbu	a5,0(a0)
 330:	0005c703          	lbu	a4,0(a1)
 334:	00e79863          	bne	a5,a4,344 <memcmp+0x2c>
 338:	0505                	addi	a0,a0,1
 33a:	0585                	addi	a1,a1,1
 33c:	fed518e3          	bne	a0,a3,32c <memcmp+0x14>
 340:	4501                	li	a0,0
 342:	a019                	j	348 <memcmp+0x30>
 344:	40e7853b          	subw	a0,a5,a4
 348:	6422                	ld	s0,8(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret
 34e:	4501                	li	a0,0
 350:	bfe5                	j	348 <memcmp+0x30>

0000000000000352 <memcpy>:
 352:	1141                	addi	sp,sp,-16
 354:	e406                	sd	ra,8(sp)
 356:	e022                	sd	s0,0(sp)
 358:	0800                	addi	s0,sp,16
 35a:	f67ff0ef          	jal	2c0 <memmove>
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret

0000000000000366 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 366:	4885                	li	a7,1
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <exit>:
.global exit
exit:
 li a7, SYS_exit
 36e:	4889                	li	a7,2
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <wait>:
.global wait
wait:
 li a7, SYS_wait
 376:	488d                	li	a7,3
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 37e:	4891                	li	a7,4
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <read>:
.global read
read:
 li a7, SYS_read
 386:	4895                	li	a7,5
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <write>:
.global write
write:
 li a7, SYS_write
 38e:	48c1                	li	a7,16
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <close>:
.global close
close:
 li a7, SYS_close
 396:	48d5                	li	a7,21
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <kill>:
.global kill
kill:
 li a7, SYS_kill
 39e:	4899                	li	a7,6
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3a6:	489d                	li	a7,7
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <open>:
.global open
open:
 li a7, SYS_open
 3ae:	48bd                	li	a7,15
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3b6:	48c5                	li	a7,17
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3be:	48c9                	li	a7,18
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3c6:	48a1                	li	a7,8
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <link>:
.global link
link:
 li a7, SYS_link
 3ce:	48cd                	li	a7,19
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3d6:	48d1                	li	a7,20
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3de:	48a5                	li	a7,9
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3e6:	48a9                	li	a7,10
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ee:	48ad                	li	a7,11
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3f6:	48b1                	li	a7,12
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3fe:	48b5                	li	a7,13
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 406:	48b9                	li	a7,14
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 40e:	48d9                	li	a7,22
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 416:	48dd                	li	a7,23
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 41e:	48e1                	li	a7,24
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 426:	48e5                	li	a7,25
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <rand>:
.global rand
rand:
 li a7, SYS_rand
 42e:	48ed                	li	a7,27
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 436:	1101                	addi	sp,sp,-32
 438:	ec06                	sd	ra,24(sp)
 43a:	e822                	sd	s0,16(sp)
 43c:	1000                	addi	s0,sp,32
 43e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 442:	4605                	li	a2,1
 444:	fef40593          	addi	a1,s0,-17
 448:	f47ff0ef          	jal	38e <write>
}
 44c:	60e2                	ld	ra,24(sp)
 44e:	6442                	ld	s0,16(sp)
 450:	6105                	addi	sp,sp,32
 452:	8082                	ret

0000000000000454 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 454:	7139                	addi	sp,sp,-64
 456:	fc06                	sd	ra,56(sp)
 458:	f822                	sd	s0,48(sp)
 45a:	f426                	sd	s1,40(sp)
 45c:	0080                	addi	s0,sp,64
 45e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 460:	c299                	beqz	a3,466 <printint+0x12>
 462:	0805c963          	bltz	a1,4f4 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 466:	2581                	sext.w	a1,a1
  neg = 0;
 468:	4881                	li	a7,0
 46a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 46e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 470:	2601                	sext.w	a2,a2
 472:	00000517          	auipc	a0,0x0
 476:	5a650513          	addi	a0,a0,1446 # a18 <digits>
 47a:	883a                	mv	a6,a4
 47c:	2705                	addiw	a4,a4,1
 47e:	02c5f7bb          	remuw	a5,a1,a2
 482:	1782                	slli	a5,a5,0x20
 484:	9381                	srli	a5,a5,0x20
 486:	97aa                	add	a5,a5,a0
 488:	0007c783          	lbu	a5,0(a5)
 48c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 490:	0005879b          	sext.w	a5,a1
 494:	02c5d5bb          	divuw	a1,a1,a2
 498:	0685                	addi	a3,a3,1
 49a:	fec7f0e3          	bgeu	a5,a2,47a <printint+0x26>
  if(neg)
 49e:	00088c63          	beqz	a7,4b6 <printint+0x62>
    buf[i++] = '-';
 4a2:	fd070793          	addi	a5,a4,-48
 4a6:	00878733          	add	a4,a5,s0
 4aa:	02d00793          	li	a5,45
 4ae:	fef70823          	sb	a5,-16(a4)
 4b2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4b6:	02e05a63          	blez	a4,4ea <printint+0x96>
 4ba:	f04a                	sd	s2,32(sp)
 4bc:	ec4e                	sd	s3,24(sp)
 4be:	fc040793          	addi	a5,s0,-64
 4c2:	00e78933          	add	s2,a5,a4
 4c6:	fff78993          	addi	s3,a5,-1
 4ca:	99ba                	add	s3,s3,a4
 4cc:	377d                	addiw	a4,a4,-1
 4ce:	1702                	slli	a4,a4,0x20
 4d0:	9301                	srli	a4,a4,0x20
 4d2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4d6:	fff94583          	lbu	a1,-1(s2)
 4da:	8526                	mv	a0,s1
 4dc:	f5bff0ef          	jal	436 <putc>
  while(--i >= 0)
 4e0:	197d                	addi	s2,s2,-1
 4e2:	ff391ae3          	bne	s2,s3,4d6 <printint+0x82>
 4e6:	7902                	ld	s2,32(sp)
 4e8:	69e2                	ld	s3,24(sp)
}
 4ea:	70e2                	ld	ra,56(sp)
 4ec:	7442                	ld	s0,48(sp)
 4ee:	74a2                	ld	s1,40(sp)
 4f0:	6121                	addi	sp,sp,64
 4f2:	8082                	ret
    x = -xx;
 4f4:	40b005bb          	negw	a1,a1
    neg = 1;
 4f8:	4885                	li	a7,1
    x = -xx;
 4fa:	bf85                	j	46a <printint+0x16>

00000000000004fc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4fc:	711d                	addi	sp,sp,-96
 4fe:	ec86                	sd	ra,88(sp)
 500:	e8a2                	sd	s0,80(sp)
 502:	e0ca                	sd	s2,64(sp)
 504:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 506:	0005c903          	lbu	s2,0(a1)
 50a:	26090863          	beqz	s2,77a <vprintf+0x27e>
 50e:	e4a6                	sd	s1,72(sp)
 510:	fc4e                	sd	s3,56(sp)
 512:	f852                	sd	s4,48(sp)
 514:	f456                	sd	s5,40(sp)
 516:	f05a                	sd	s6,32(sp)
 518:	ec5e                	sd	s7,24(sp)
 51a:	e862                	sd	s8,16(sp)
 51c:	e466                	sd	s9,8(sp)
 51e:	8b2a                	mv	s6,a0
 520:	8a2e                	mv	s4,a1
 522:	8bb2                	mv	s7,a2
  state = 0;
 524:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 526:	4481                	li	s1,0
 528:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 52a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 52e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 532:	06c00c93          	li	s9,108
 536:	a005                	j	556 <vprintf+0x5a>
        putc(fd, c0);
 538:	85ca                	mv	a1,s2
 53a:	855a                	mv	a0,s6
 53c:	efbff0ef          	jal	436 <putc>
 540:	a019                	j	546 <vprintf+0x4a>
    } else if(state == '%'){
 542:	03598263          	beq	s3,s5,566 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 546:	2485                	addiw	s1,s1,1
 548:	8726                	mv	a4,s1
 54a:	009a07b3          	add	a5,s4,s1
 54e:	0007c903          	lbu	s2,0(a5)
 552:	20090c63          	beqz	s2,76a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 556:	0009079b          	sext.w	a5,s2
    if(state == 0){
 55a:	fe0994e3          	bnez	s3,542 <vprintf+0x46>
      if(c0 == '%'){
 55e:	fd579de3          	bne	a5,s5,538 <vprintf+0x3c>
        state = '%';
 562:	89be                	mv	s3,a5
 564:	b7cd                	j	546 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 566:	00ea06b3          	add	a3,s4,a4
 56a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 56e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 570:	c681                	beqz	a3,578 <vprintf+0x7c>
 572:	9752                	add	a4,a4,s4
 574:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 578:	03878f63          	beq	a5,s8,5b6 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 57c:	05978963          	beq	a5,s9,5ce <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 580:	07500713          	li	a4,117
 584:	0ee78363          	beq	a5,a4,66a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 588:	07800713          	li	a4,120
 58c:	12e78563          	beq	a5,a4,6b6 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 590:	07000713          	li	a4,112
 594:	14e78a63          	beq	a5,a4,6e8 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 598:	07300713          	li	a4,115
 59c:	18e78a63          	beq	a5,a4,730 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5a0:	02500713          	li	a4,37
 5a4:	04e79563          	bne	a5,a4,5ee <vprintf+0xf2>
        putc(fd, '%');
 5a8:	02500593          	li	a1,37
 5ac:	855a                	mv	a0,s6
 5ae:	e89ff0ef          	jal	436 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	bf49                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5b6:	008b8913          	addi	s2,s7,8
 5ba:	4685                	li	a3,1
 5bc:	4629                	li	a2,10
 5be:	000ba583          	lw	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	e91ff0ef          	jal	454 <printint>
 5c8:	8bca                	mv	s7,s2
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	bfad                	j	546 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5ce:	06400793          	li	a5,100
 5d2:	02f68963          	beq	a3,a5,604 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d6:	06c00793          	li	a5,108
 5da:	04f68263          	beq	a3,a5,61e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5de:	07500793          	li	a5,117
 5e2:	0af68063          	beq	a3,a5,682 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5e6:	07800793          	li	a5,120
 5ea:	0ef68263          	beq	a3,a5,6ce <vprintf+0x1d2>
        putc(fd, '%');
 5ee:	02500593          	li	a1,37
 5f2:	855a                	mv	a0,s6
 5f4:	e43ff0ef          	jal	436 <putc>
        putc(fd, c0);
 5f8:	85ca                	mv	a1,s2
 5fa:	855a                	mv	a0,s6
 5fc:	e3bff0ef          	jal	436 <putc>
      state = 0;
 600:	4981                	li	s3,0
 602:	b791                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 604:	008b8913          	addi	s2,s7,8
 608:	4685                	li	a3,1
 60a:	4629                	li	a2,10
 60c:	000ba583          	lw	a1,0(s7)
 610:	855a                	mv	a0,s6
 612:	e43ff0ef          	jal	454 <printint>
        i += 1;
 616:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 618:	8bca                	mv	s7,s2
      state = 0;
 61a:	4981                	li	s3,0
        i += 1;
 61c:	b72d                	j	546 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 61e:	06400793          	li	a5,100
 622:	02f60763          	beq	a2,a5,650 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 626:	07500793          	li	a5,117
 62a:	06f60963          	beq	a2,a5,69c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 62e:	07800793          	li	a5,120
 632:	faf61ee3          	bne	a2,a5,5ee <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 636:	008b8913          	addi	s2,s7,8
 63a:	4681                	li	a3,0
 63c:	4641                	li	a2,16
 63e:	000ba583          	lw	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	e11ff0ef          	jal	454 <printint>
        i += 2;
 648:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 64a:	8bca                	mv	s7,s2
      state = 0;
 64c:	4981                	li	s3,0
        i += 2;
 64e:	bde5                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 650:	008b8913          	addi	s2,s7,8
 654:	4685                	li	a3,1
 656:	4629                	li	a2,10
 658:	000ba583          	lw	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	df7ff0ef          	jal	454 <printint>
        i += 2;
 662:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 664:	8bca                	mv	s7,s2
      state = 0;
 666:	4981                	li	s3,0
        i += 2;
 668:	bdf9                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 66a:	008b8913          	addi	s2,s7,8
 66e:	4681                	li	a3,0
 670:	4629                	li	a2,10
 672:	000ba583          	lw	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	dddff0ef          	jal	454 <printint>
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
 680:	b5d9                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 682:	008b8913          	addi	s2,s7,8
 686:	4681                	li	a3,0
 688:	4629                	li	a2,10
 68a:	000ba583          	lw	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	dc5ff0ef          	jal	454 <printint>
        i += 1;
 694:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
        i += 1;
 69a:	b575                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 69c:	008b8913          	addi	s2,s7,8
 6a0:	4681                	li	a3,0
 6a2:	4629                	li	a2,10
 6a4:	000ba583          	lw	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	dabff0ef          	jal	454 <printint>
        i += 2;
 6ae:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b0:	8bca                	mv	s7,s2
      state = 0;
 6b2:	4981                	li	s3,0
        i += 2;
 6b4:	bd49                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6b6:	008b8913          	addi	s2,s7,8
 6ba:	4681                	li	a3,0
 6bc:	4641                	li	a2,16
 6be:	000ba583          	lw	a1,0(s7)
 6c2:	855a                	mv	a0,s6
 6c4:	d91ff0ef          	jal	454 <printint>
 6c8:	8bca                	mv	s7,s2
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bdad                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4641                	li	a2,16
 6d6:	000ba583          	lw	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	d79ff0ef          	jal	454 <printint>
        i += 1;
 6e0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e2:	8bca                	mv	s7,s2
      state = 0;
 6e4:	4981                	li	s3,0
        i += 1;
 6e6:	b585                	j	546 <vprintf+0x4a>
 6e8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6ea:	008b8d13          	addi	s10,s7,8
 6ee:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6f2:	03000593          	li	a1,48
 6f6:	855a                	mv	a0,s6
 6f8:	d3fff0ef          	jal	436 <putc>
  putc(fd, 'x');
 6fc:	07800593          	li	a1,120
 700:	855a                	mv	a0,s6
 702:	d35ff0ef          	jal	436 <putc>
 706:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 708:	00000b97          	auipc	s7,0x0
 70c:	310b8b93          	addi	s7,s7,784 # a18 <digits>
 710:	03c9d793          	srli	a5,s3,0x3c
 714:	97de                	add	a5,a5,s7
 716:	0007c583          	lbu	a1,0(a5)
 71a:	855a                	mv	a0,s6
 71c:	d1bff0ef          	jal	436 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 720:	0992                	slli	s3,s3,0x4
 722:	397d                	addiw	s2,s2,-1
 724:	fe0916e3          	bnez	s2,710 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 728:	8bea                	mv	s7,s10
      state = 0;
 72a:	4981                	li	s3,0
 72c:	6d02                	ld	s10,0(sp)
 72e:	bd21                	j	546 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 730:	008b8993          	addi	s3,s7,8
 734:	000bb903          	ld	s2,0(s7)
 738:	00090f63          	beqz	s2,756 <vprintf+0x25a>
        for(; *s; s++)
 73c:	00094583          	lbu	a1,0(s2)
 740:	c195                	beqz	a1,764 <vprintf+0x268>
          putc(fd, *s);
 742:	855a                	mv	a0,s6
 744:	cf3ff0ef          	jal	436 <putc>
        for(; *s; s++)
 748:	0905                	addi	s2,s2,1
 74a:	00094583          	lbu	a1,0(s2)
 74e:	f9f5                	bnez	a1,742 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 750:	8bce                	mv	s7,s3
      state = 0;
 752:	4981                	li	s3,0
 754:	bbcd                	j	546 <vprintf+0x4a>
          s = "(null)";
 756:	00000917          	auipc	s2,0x0
 75a:	2ba90913          	addi	s2,s2,698 # a10 <malloc+0x1ae>
        for(; *s; s++)
 75e:	02800593          	li	a1,40
 762:	b7c5                	j	742 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 764:	8bce                	mv	s7,s3
      state = 0;
 766:	4981                	li	s3,0
 768:	bbf9                	j	546 <vprintf+0x4a>
 76a:	64a6                	ld	s1,72(sp)
 76c:	79e2                	ld	s3,56(sp)
 76e:	7a42                	ld	s4,48(sp)
 770:	7aa2                	ld	s5,40(sp)
 772:	7b02                	ld	s6,32(sp)
 774:	6be2                	ld	s7,24(sp)
 776:	6c42                	ld	s8,16(sp)
 778:	6ca2                	ld	s9,8(sp)
    }
  }
}
 77a:	60e6                	ld	ra,88(sp)
 77c:	6446                	ld	s0,80(sp)
 77e:	6906                	ld	s2,64(sp)
 780:	6125                	addi	sp,sp,96
 782:	8082                	ret

0000000000000784 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 784:	715d                	addi	sp,sp,-80
 786:	ec06                	sd	ra,24(sp)
 788:	e822                	sd	s0,16(sp)
 78a:	1000                	addi	s0,sp,32
 78c:	e010                	sd	a2,0(s0)
 78e:	e414                	sd	a3,8(s0)
 790:	e818                	sd	a4,16(s0)
 792:	ec1c                	sd	a5,24(s0)
 794:	03043023          	sd	a6,32(s0)
 798:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 79c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a0:	8622                	mv	a2,s0
 7a2:	d5bff0ef          	jal	4fc <vprintf>
}
 7a6:	60e2                	ld	ra,24(sp)
 7a8:	6442                	ld	s0,16(sp)
 7aa:	6161                	addi	sp,sp,80
 7ac:	8082                	ret

00000000000007ae <printf>:

void
printf(const char *fmt, ...)
{
 7ae:	711d                	addi	sp,sp,-96
 7b0:	ec06                	sd	ra,24(sp)
 7b2:	e822                	sd	s0,16(sp)
 7b4:	1000                	addi	s0,sp,32
 7b6:	e40c                	sd	a1,8(s0)
 7b8:	e810                	sd	a2,16(s0)
 7ba:	ec14                	sd	a3,24(s0)
 7bc:	f018                	sd	a4,32(s0)
 7be:	f41c                	sd	a5,40(s0)
 7c0:	03043823          	sd	a6,48(s0)
 7c4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c8:	00840613          	addi	a2,s0,8
 7cc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d0:	85aa                	mv	a1,a0
 7d2:	4505                	li	a0,1
 7d4:	d29ff0ef          	jal	4fc <vprintf>
}
 7d8:	60e2                	ld	ra,24(sp)
 7da:	6442                	ld	s0,16(sp)
 7dc:	6125                	addi	sp,sp,96
 7de:	8082                	ret

00000000000007e0 <free>:
 7e0:	1141                	addi	sp,sp,-16
 7e2:	e422                	sd	s0,8(sp)
 7e4:	0800                	addi	s0,sp,16
 7e6:	ff050693          	addi	a3,a0,-16
 7ea:	00001797          	auipc	a5,0x1
 7ee:	8167b783          	ld	a5,-2026(a5) # 1000 <freep>
 7f2:	a02d                	j	81c <free+0x3c>
 7f4:	4618                	lw	a4,8(a2)
 7f6:	9f2d                	addw	a4,a4,a1
 7f8:	fee52c23          	sw	a4,-8(a0)
 7fc:	6398                	ld	a4,0(a5)
 7fe:	6310                	ld	a2,0(a4)
 800:	a83d                	j	83e <free+0x5e>
 802:	ff852703          	lw	a4,-8(a0)
 806:	9f31                	addw	a4,a4,a2
 808:	c798                	sw	a4,8(a5)
 80a:	ff053683          	ld	a3,-16(a0)
 80e:	a091                	j	852 <free+0x72>
 810:	6398                	ld	a4,0(a5)
 812:	00e7e463          	bltu	a5,a4,81a <free+0x3a>
 816:	00e6ea63          	bltu	a3,a4,82a <free+0x4a>
 81a:	87ba                	mv	a5,a4
 81c:	fed7fae3          	bgeu	a5,a3,810 <free+0x30>
 820:	6398                	ld	a4,0(a5)
 822:	00e6e463          	bltu	a3,a4,82a <free+0x4a>
 826:	fee7eae3          	bltu	a5,a4,81a <free+0x3a>
 82a:	ff852583          	lw	a1,-8(a0)
 82e:	6390                	ld	a2,0(a5)
 830:	02059813          	slli	a6,a1,0x20
 834:	01c85713          	srli	a4,a6,0x1c
 838:	9736                	add	a4,a4,a3
 83a:	fae60de3          	beq	a2,a4,7f4 <free+0x14>
 83e:	fec53823          	sd	a2,-16(a0)
 842:	4790                	lw	a2,8(a5)
 844:	02061593          	slli	a1,a2,0x20
 848:	01c5d713          	srli	a4,a1,0x1c
 84c:	973e                	add	a4,a4,a5
 84e:	fae68ae3          	beq	a3,a4,802 <free+0x22>
 852:	e394                	sd	a3,0(a5)
 854:	00000717          	auipc	a4,0x0
 858:	7af73623          	sd	a5,1964(a4) # 1000 <freep>
 85c:	6422                	ld	s0,8(sp)
 85e:	0141                	addi	sp,sp,16
 860:	8082                	ret

0000000000000862 <malloc>:
 862:	7139                	addi	sp,sp,-64
 864:	fc06                	sd	ra,56(sp)
 866:	f822                	sd	s0,48(sp)
 868:	f426                	sd	s1,40(sp)
 86a:	ec4e                	sd	s3,24(sp)
 86c:	0080                	addi	s0,sp,64
 86e:	02051493          	slli	s1,a0,0x20
 872:	9081                	srli	s1,s1,0x20
 874:	04bd                	addi	s1,s1,15
 876:	8091                	srli	s1,s1,0x4
 878:	0014899b          	addiw	s3,s1,1
 87c:	0485                	addi	s1,s1,1
 87e:	00000517          	auipc	a0,0x0
 882:	78253503          	ld	a0,1922(a0) # 1000 <freep>
 886:	c915                	beqz	a0,8ba <malloc+0x58>
 888:	611c                	ld	a5,0(a0)
 88a:	4798                	lw	a4,8(a5)
 88c:	08977a63          	bgeu	a4,s1,920 <malloc+0xbe>
 890:	f04a                	sd	s2,32(sp)
 892:	e852                	sd	s4,16(sp)
 894:	e456                	sd	s5,8(sp)
 896:	e05a                	sd	s6,0(sp)
 898:	8a4e                	mv	s4,s3
 89a:	0009871b          	sext.w	a4,s3
 89e:	6685                	lui	a3,0x1
 8a0:	00d77363          	bgeu	a4,a3,8a6 <malloc+0x44>
 8a4:	6a05                	lui	s4,0x1
 8a6:	000a0b1b          	sext.w	s6,s4
 8aa:	004a1a1b          	slliw	s4,s4,0x4
 8ae:	00000917          	auipc	s2,0x0
 8b2:	75290913          	addi	s2,s2,1874 # 1000 <freep>
 8b6:	5afd                	li	s5,-1
 8b8:	a081                	j	8f8 <malloc+0x96>
 8ba:	f04a                	sd	s2,32(sp)
 8bc:	e852                	sd	s4,16(sp)
 8be:	e456                	sd	s5,8(sp)
 8c0:	e05a                	sd	s6,0(sp)
 8c2:	00001797          	auipc	a5,0x1
 8c6:	94e78793          	addi	a5,a5,-1714 # 1210 <base>
 8ca:	00000717          	auipc	a4,0x0
 8ce:	72f73b23          	sd	a5,1846(a4) # 1000 <freep>
 8d2:	e39c                	sd	a5,0(a5)
 8d4:	0007a423          	sw	zero,8(a5)
 8d8:	b7c1                	j	898 <malloc+0x36>
 8da:	6398                	ld	a4,0(a5)
 8dc:	e118                	sd	a4,0(a0)
 8de:	a8a9                	j	938 <malloc+0xd6>
 8e0:	01652423          	sw	s6,8(a0)
 8e4:	0541                	addi	a0,a0,16
 8e6:	efbff0ef          	jal	7e0 <free>
 8ea:	00093503          	ld	a0,0(s2)
 8ee:	c12d                	beqz	a0,950 <malloc+0xee>
 8f0:	611c                	ld	a5,0(a0)
 8f2:	4798                	lw	a4,8(a5)
 8f4:	02977263          	bgeu	a4,s1,918 <malloc+0xb6>
 8f8:	00093703          	ld	a4,0(s2)
 8fc:	853e                	mv	a0,a5
 8fe:	fef719e3          	bne	a4,a5,8f0 <malloc+0x8e>
 902:	8552                	mv	a0,s4
 904:	af3ff0ef          	jal	3f6 <sbrk>
 908:	fd551ce3          	bne	a0,s5,8e0 <malloc+0x7e>
 90c:	4501                	li	a0,0
 90e:	7902                	ld	s2,32(sp)
 910:	6a42                	ld	s4,16(sp)
 912:	6aa2                	ld	s5,8(sp)
 914:	6b02                	ld	s6,0(sp)
 916:	a03d                	j	944 <malloc+0xe2>
 918:	7902                	ld	s2,32(sp)
 91a:	6a42                	ld	s4,16(sp)
 91c:	6aa2                	ld	s5,8(sp)
 91e:	6b02                	ld	s6,0(sp)
 920:	fae48de3          	beq	s1,a4,8da <malloc+0x78>
 924:	4137073b          	subw	a4,a4,s3
 928:	c798                	sw	a4,8(a5)
 92a:	02071693          	slli	a3,a4,0x20
 92e:	01c6d713          	srli	a4,a3,0x1c
 932:	97ba                	add	a5,a5,a4
 934:	0137a423          	sw	s3,8(a5)
 938:	00000717          	auipc	a4,0x0
 93c:	6ca73423          	sd	a0,1736(a4) # 1000 <freep>
 940:	01078513          	addi	a0,a5,16
 944:	70e2                	ld	ra,56(sp)
 946:	7442                	ld	s0,48(sp)
 948:	74a2                	ld	s1,40(sp)
 94a:	69e2                	ld	s3,24(sp)
 94c:	6121                	addi	sp,sp,64
 94e:	8082                	ret
 950:	7902                	ld	s2,32(sp)
 952:	6a42                	ld	s4,16(sp)
 954:	6aa2                	ld	s5,8(sp)
 956:	6b02                	ld	s6,0(sp)
 958:	b7f5                	j	944 <malloc+0xe2>
