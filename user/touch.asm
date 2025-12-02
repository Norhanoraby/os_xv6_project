
user/_touch:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_help>:
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   8:	00001517          	auipc	a0,0x1
   c:	91850513          	addi	a0,a0,-1768 # 920 <malloc+0x106>
  10:	756000ef          	jal	766 <printf>
  14:	00001517          	auipc	a0,0x1
  18:	92c50513          	addi	a0,a0,-1748 # 940 <malloc+0x126>
  1c:	74a000ef          	jal	766 <printf>
  20:	00001517          	auipc	a0,0x1
  24:	95050513          	addi	a0,a0,-1712 # 970 <malloc+0x156>
  28:	73e000ef          	jal	766 <printf>
  2c:	60a2                	ld	ra,8(sp)
  2e:	6402                	ld	s0,0(sp)
  30:	0141                	addi	sp,sp,16
  32:	8082                	ret

0000000000000034 <main>:
  34:	1101                	addi	sp,sp,-32
  36:	ec06                	sd	ra,24(sp)
  38:	e822                	sd	s0,16(sp)
  3a:	1000                	addi	s0,sp,32
  3c:	4789                	li	a5,2
  3e:	02f51163          	bne	a0,a5,60 <main+0x2c>
  42:	e426                	sd	s1,8(sp)
  44:	6584                	ld	s1,8(a1)
  46:	00001597          	auipc	a1,0x1
  4a:	95a58593          	addi	a1,a1,-1702 # 9a0 <malloc+0x186>
  4e:	8526                	mv	a0,s1
  50:	0a2000ef          	jal	f2 <strcmp>
  54:	e105                	bnez	a0,74 <main+0x40>
  56:	fabff0ef          	jal	0 <print_help>
  5a:	4501                	li	a0,0
  5c:	2d2000ef          	jal	32e <exit>
  60:	e426                	sd	s1,8(sp)
  62:	00001517          	auipc	a0,0x1
  66:	8be50513          	addi	a0,a0,-1858 # 920 <malloc+0x106>
  6a:	6fc000ef          	jal	766 <printf>
  6e:	4505                	li	a0,1
  70:	2be000ef          	jal	32e <exit>
  74:	4581                	li	a1,0
  76:	8526                	mv	a0,s1
  78:	2f6000ef          	jal	36e <open>
  7c:	00054e63          	bltz	a0,98 <main+0x64>
  80:	2d6000ef          	jal	356 <close>
  84:	85a6                	mv	a1,s1
  86:	00001517          	auipc	a0,0x1
  8a:	92250513          	addi	a0,a0,-1758 # 9a8 <malloc+0x18e>
  8e:	6d8000ef          	jal	766 <printf>
  92:	4505                	li	a0,1
  94:	29a000ef          	jal	32e <exit>
  98:	20200593          	li	a1,514
  9c:	8526                	mv	a0,s1
  9e:	2d0000ef          	jal	36e <open>
  a2:	00054763          	bltz	a0,b0 <main+0x7c>
  a6:	2b0000ef          	jal	356 <close>
  aa:	4501                	li	a0,0
  ac:	282000ef          	jal	32e <exit>
  b0:	85a6                	mv	a1,s1
  b2:	00001517          	auipc	a0,0x1
  b6:	91e50513          	addi	a0,a0,-1762 # 9d0 <malloc+0x1b6>
  ba:	6ac000ef          	jal	766 <printf>
  be:	4505                	li	a0,1
  c0:	26e000ef          	jal	32e <exit>

00000000000000c4 <start>:
  c4:	1141                	addi	sp,sp,-16
  c6:	e406                	sd	ra,8(sp)
  c8:	e022                	sd	s0,0(sp)
  ca:	0800                	addi	s0,sp,16
  cc:	f69ff0ef          	jal	34 <main>
  d0:	4501                	li	a0,0
  d2:	25c000ef          	jal	32e <exit>

00000000000000d6 <strcpy>:
  d6:	1141                	addi	sp,sp,-16
  d8:	e422                	sd	s0,8(sp)
  da:	0800                	addi	s0,sp,16
  dc:	87aa                	mv	a5,a0
  de:	0585                	addi	a1,a1,1
  e0:	0785                	addi	a5,a5,1
  e2:	fff5c703          	lbu	a4,-1(a1)
  e6:	fee78fa3          	sb	a4,-1(a5)
  ea:	fb75                	bnez	a4,de <strcpy+0x8>
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <strcmp>:
  f2:	1141                	addi	sp,sp,-16
  f4:	e422                	sd	s0,8(sp)
  f6:	0800                	addi	s0,sp,16
  f8:	00054783          	lbu	a5,0(a0)
  fc:	cb91                	beqz	a5,110 <strcmp+0x1e>
  fe:	0005c703          	lbu	a4,0(a1)
 102:	00f71763          	bne	a4,a5,110 <strcmp+0x1e>
 106:	0505                	addi	a0,a0,1
 108:	0585                	addi	a1,a1,1
 10a:	00054783          	lbu	a5,0(a0)
 10e:	fbe5                	bnez	a5,fe <strcmp+0xc>
 110:	0005c503          	lbu	a0,0(a1)
 114:	40a7853b          	subw	a0,a5,a0
 118:	6422                	ld	s0,8(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strlen>:
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
 124:	00054783          	lbu	a5,0(a0)
 128:	cf91                	beqz	a5,144 <strlen+0x26>
 12a:	0505                	addi	a0,a0,1
 12c:	87aa                	mv	a5,a0
 12e:	86be                	mv	a3,a5
 130:	0785                	addi	a5,a5,1
 132:	fff7c703          	lbu	a4,-1(a5)
 136:	ff65                	bnez	a4,12e <strlen+0x10>
 138:	40a6853b          	subw	a0,a3,a0
 13c:	2505                	addiw	a0,a0,1
 13e:	6422                	ld	s0,8(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret
 144:	4501                	li	a0,0
 146:	bfe5                	j	13e <strlen+0x20>

0000000000000148 <memset>:
 148:	1141                	addi	sp,sp,-16
 14a:	e422                	sd	s0,8(sp)
 14c:	0800                	addi	s0,sp,16
 14e:	ca19                	beqz	a2,164 <memset+0x1c>
 150:	87aa                	mv	a5,a0
 152:	1602                	slli	a2,a2,0x20
 154:	9201                	srli	a2,a2,0x20
 156:	00a60733          	add	a4,a2,a0
 15a:	00b78023          	sb	a1,0(a5)
 15e:	0785                	addi	a5,a5,1
 160:	fee79de3          	bne	a5,a4,15a <memset+0x12>
 164:	6422                	ld	s0,8(sp)
 166:	0141                	addi	sp,sp,16
 168:	8082                	ret

000000000000016a <strchr>:
 16a:	1141                	addi	sp,sp,-16
 16c:	e422                	sd	s0,8(sp)
 16e:	0800                	addi	s0,sp,16
 170:	00054783          	lbu	a5,0(a0)
 174:	cb99                	beqz	a5,18a <strchr+0x20>
 176:	00f58763          	beq	a1,a5,184 <strchr+0x1a>
 17a:	0505                	addi	a0,a0,1
 17c:	00054783          	lbu	a5,0(a0)
 180:	fbfd                	bnez	a5,176 <strchr+0xc>
 182:	4501                	li	a0,0
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret
 18a:	4501                	li	a0,0
 18c:	bfe5                	j	184 <strchr+0x1a>

000000000000018e <gets>:
 18e:	711d                	addi	sp,sp,-96
 190:	ec86                	sd	ra,88(sp)
 192:	e8a2                	sd	s0,80(sp)
 194:	e4a6                	sd	s1,72(sp)
 196:	e0ca                	sd	s2,64(sp)
 198:	fc4e                	sd	s3,56(sp)
 19a:	f852                	sd	s4,48(sp)
 19c:	f456                	sd	s5,40(sp)
 19e:	f05a                	sd	s6,32(sp)
 1a0:	ec5e                	sd	s7,24(sp)
 1a2:	1080                	addi	s0,sp,96
 1a4:	8baa                	mv	s7,a0
 1a6:	8a2e                	mv	s4,a1
 1a8:	892a                	mv	s2,a0
 1aa:	4481                	li	s1,0
 1ac:	4aa9                	li	s5,10
 1ae:	4b35                	li	s6,13
 1b0:	89a6                	mv	s3,s1
 1b2:	2485                	addiw	s1,s1,1
 1b4:	0344d663          	bge	s1,s4,1e0 <gets+0x52>
 1b8:	4605                	li	a2,1
 1ba:	faf40593          	addi	a1,s0,-81
 1be:	4501                	li	a0,0
 1c0:	186000ef          	jal	346 <read>
 1c4:	00a05e63          	blez	a0,1e0 <gets+0x52>
 1c8:	faf44783          	lbu	a5,-81(s0)
 1cc:	00f90023          	sb	a5,0(s2)
 1d0:	01578763          	beq	a5,s5,1de <gets+0x50>
 1d4:	0905                	addi	s2,s2,1
 1d6:	fd679de3          	bne	a5,s6,1b0 <gets+0x22>
 1da:	89a6                	mv	s3,s1
 1dc:	a011                	j	1e0 <gets+0x52>
 1de:	89a6                	mv	s3,s1
 1e0:	99de                	add	s3,s3,s7
 1e2:	00098023          	sb	zero,0(s3)
 1e6:	855e                	mv	a0,s7
 1e8:	60e6                	ld	ra,88(sp)
 1ea:	6446                	ld	s0,80(sp)
 1ec:	64a6                	ld	s1,72(sp)
 1ee:	6906                	ld	s2,64(sp)
 1f0:	79e2                	ld	s3,56(sp)
 1f2:	7a42                	ld	s4,48(sp)
 1f4:	7aa2                	ld	s5,40(sp)
 1f6:	7b02                	ld	s6,32(sp)
 1f8:	6be2                	ld	s7,24(sp)
 1fa:	6125                	addi	sp,sp,96
 1fc:	8082                	ret

00000000000001fe <stat>:
 1fe:	1101                	addi	sp,sp,-32
 200:	ec06                	sd	ra,24(sp)
 202:	e822                	sd	s0,16(sp)
 204:	e04a                	sd	s2,0(sp)
 206:	1000                	addi	s0,sp,32
 208:	892e                	mv	s2,a1
 20a:	4581                	li	a1,0
 20c:	162000ef          	jal	36e <open>
 210:	02054263          	bltz	a0,234 <stat+0x36>
 214:	e426                	sd	s1,8(sp)
 216:	84aa                	mv	s1,a0
 218:	85ca                	mv	a1,s2
 21a:	16c000ef          	jal	386 <fstat>
 21e:	892a                	mv	s2,a0
 220:	8526                	mv	a0,s1
 222:	134000ef          	jal	356 <close>
 226:	64a2                	ld	s1,8(sp)
 228:	854a                	mv	a0,s2
 22a:	60e2                	ld	ra,24(sp)
 22c:	6442                	ld	s0,16(sp)
 22e:	6902                	ld	s2,0(sp)
 230:	6105                	addi	sp,sp,32
 232:	8082                	ret
 234:	597d                	li	s2,-1
 236:	bfcd                	j	228 <stat+0x2a>

0000000000000238 <atoi>:
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
 23e:	00054683          	lbu	a3,0(a0)
 242:	fd06879b          	addiw	a5,a3,-48
 246:	0ff7f793          	zext.b	a5,a5
 24a:	4625                	li	a2,9
 24c:	02f66863          	bltu	a2,a5,27c <atoi+0x44>
 250:	872a                	mv	a4,a0
 252:	4501                	li	a0,0
 254:	0705                	addi	a4,a4,1
 256:	0025179b          	slliw	a5,a0,0x2
 25a:	9fa9                	addw	a5,a5,a0
 25c:	0017979b          	slliw	a5,a5,0x1
 260:	9fb5                	addw	a5,a5,a3
 262:	fd07851b          	addiw	a0,a5,-48
 266:	00074683          	lbu	a3,0(a4)
 26a:	fd06879b          	addiw	a5,a3,-48
 26e:	0ff7f793          	zext.b	a5,a5
 272:	fef671e3          	bgeu	a2,a5,254 <atoi+0x1c>
 276:	6422                	ld	s0,8(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
 27c:	4501                	li	a0,0
 27e:	bfe5                	j	276 <atoi+0x3e>

0000000000000280 <memmove>:
 280:	1141                	addi	sp,sp,-16
 282:	e422                	sd	s0,8(sp)
 284:	0800                	addi	s0,sp,16
 286:	02b57463          	bgeu	a0,a1,2ae <memmove+0x2e>
 28a:	00c05f63          	blez	a2,2a8 <memmove+0x28>
 28e:	1602                	slli	a2,a2,0x20
 290:	9201                	srli	a2,a2,0x20
 292:	00c507b3          	add	a5,a0,a2
 296:	872a                	mv	a4,a0
 298:	0585                	addi	a1,a1,1
 29a:	0705                	addi	a4,a4,1
 29c:	fff5c683          	lbu	a3,-1(a1)
 2a0:	fed70fa3          	sb	a3,-1(a4)
 2a4:	fef71ae3          	bne	a4,a5,298 <memmove+0x18>
 2a8:	6422                	ld	s0,8(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret
 2ae:	00c50733          	add	a4,a0,a2
 2b2:	95b2                	add	a1,a1,a2
 2b4:	fec05ae3          	blez	a2,2a8 <memmove+0x28>
 2b8:	fff6079b          	addiw	a5,a2,-1
 2bc:	1782                	slli	a5,a5,0x20
 2be:	9381                	srli	a5,a5,0x20
 2c0:	fff7c793          	not	a5,a5
 2c4:	97ba                	add	a5,a5,a4
 2c6:	15fd                	addi	a1,a1,-1
 2c8:	177d                	addi	a4,a4,-1
 2ca:	0005c683          	lbu	a3,0(a1)
 2ce:	00d70023          	sb	a3,0(a4)
 2d2:	fee79ae3          	bne	a5,a4,2c6 <memmove+0x46>
 2d6:	bfc9                	j	2a8 <memmove+0x28>

00000000000002d8 <memcmp>:
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
 2de:	ca05                	beqz	a2,30e <memcmp+0x36>
 2e0:	fff6069b          	addiw	a3,a2,-1
 2e4:	1682                	slli	a3,a3,0x20
 2e6:	9281                	srli	a3,a3,0x20
 2e8:	0685                	addi	a3,a3,1
 2ea:	96aa                	add	a3,a3,a0
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	0005c703          	lbu	a4,0(a1)
 2f4:	00e79863          	bne	a5,a4,304 <memcmp+0x2c>
 2f8:	0505                	addi	a0,a0,1
 2fa:	0585                	addi	a1,a1,1
 2fc:	fed518e3          	bne	a0,a3,2ec <memcmp+0x14>
 300:	4501                	li	a0,0
 302:	a019                	j	308 <memcmp+0x30>
 304:	40e7853b          	subw	a0,a5,a4
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret
 30e:	4501                	li	a0,0
 310:	bfe5                	j	308 <memcmp+0x30>

0000000000000312 <memcpy>:
 312:	1141                	addi	sp,sp,-16
 314:	e406                	sd	ra,8(sp)
 316:	e022                	sd	s0,0(sp)
 318:	0800                	addi	s0,sp,16
 31a:	f67ff0ef          	jal	280 <memmove>
 31e:	60a2                	ld	ra,8(sp)
 320:	6402                	ld	s0,0(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret

0000000000000326 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 326:	4885                	li	a7,1
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <exit>:
.global exit
exit:
 li a7, SYS_exit
 32e:	4889                	li	a7,2
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <wait>:
.global wait
wait:
 li a7, SYS_wait
 336:	488d                	li	a7,3
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 33e:	4891                	li	a7,4
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <read>:
.global read
read:
 li a7, SYS_read
 346:	4895                	li	a7,5
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <write>:
.global write
write:
 li a7, SYS_write
 34e:	48c1                	li	a7,16
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <close>:
.global close
close:
 li a7, SYS_close
 356:	48d5                	li	a7,21
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <kill>:
.global kill
kill:
 li a7, SYS_kill
 35e:	4899                	li	a7,6
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <exec>:
.global exec
exec:
 li a7, SYS_exec
 366:	489d                	li	a7,7
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <open>:
.global open
open:
 li a7, SYS_open
 36e:	48bd                	li	a7,15
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 376:	48c5                	li	a7,17
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 37e:	48c9                	li	a7,18
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 386:	48a1                	li	a7,8
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <link>:
.global link
link:
 li a7, SYS_link
 38e:	48cd                	li	a7,19
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 396:	48d1                	li	a7,20
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 39e:	48a5                	li	a7,9
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3a6:	48a9                	li	a7,10
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ae:	48ad                	li	a7,11
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3b6:	48b1                	li	a7,12
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3be:	48b5                	li	a7,13
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3c6:	48b9                	li	a7,14
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 3ce:	48d9                	li	a7,22
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 3d6:	48dd                	li	a7,23
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3de:	48e1                	li	a7,24
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 3e6:	48e5                	li	a7,25
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ee:	1101                	addi	sp,sp,-32
 3f0:	ec06                	sd	ra,24(sp)
 3f2:	e822                	sd	s0,16(sp)
 3f4:	1000                	addi	s0,sp,32
 3f6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3fa:	4605                	li	a2,1
 3fc:	fef40593          	addi	a1,s0,-17
 400:	f4fff0ef          	jal	34e <write>
}
 404:	60e2                	ld	ra,24(sp)
 406:	6442                	ld	s0,16(sp)
 408:	6105                	addi	sp,sp,32
 40a:	8082                	ret

000000000000040c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40c:	7139                	addi	sp,sp,-64
 40e:	fc06                	sd	ra,56(sp)
 410:	f822                	sd	s0,48(sp)
 412:	f426                	sd	s1,40(sp)
 414:	0080                	addi	s0,sp,64
 416:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 418:	c299                	beqz	a3,41e <printint+0x12>
 41a:	0805c963          	bltz	a1,4ac <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 41e:	2581                	sext.w	a1,a1
  neg = 0;
 420:	4881                	li	a7,0
 422:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 426:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 428:	2601                	sext.w	a2,a2
 42a:	00000517          	auipc	a0,0x0
 42e:	5d650513          	addi	a0,a0,1494 # a00 <digits>
 432:	883a                	mv	a6,a4
 434:	2705                	addiw	a4,a4,1
 436:	02c5f7bb          	remuw	a5,a1,a2
 43a:	1782                	slli	a5,a5,0x20
 43c:	9381                	srli	a5,a5,0x20
 43e:	97aa                	add	a5,a5,a0
 440:	0007c783          	lbu	a5,0(a5)
 444:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 448:	0005879b          	sext.w	a5,a1
 44c:	02c5d5bb          	divuw	a1,a1,a2
 450:	0685                	addi	a3,a3,1
 452:	fec7f0e3          	bgeu	a5,a2,432 <printint+0x26>
  if(neg)
 456:	00088c63          	beqz	a7,46e <printint+0x62>
    buf[i++] = '-';
 45a:	fd070793          	addi	a5,a4,-48
 45e:	00878733          	add	a4,a5,s0
 462:	02d00793          	li	a5,45
 466:	fef70823          	sb	a5,-16(a4)
 46a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 46e:	02e05a63          	blez	a4,4a2 <printint+0x96>
 472:	f04a                	sd	s2,32(sp)
 474:	ec4e                	sd	s3,24(sp)
 476:	fc040793          	addi	a5,s0,-64
 47a:	00e78933          	add	s2,a5,a4
 47e:	fff78993          	addi	s3,a5,-1
 482:	99ba                	add	s3,s3,a4
 484:	377d                	addiw	a4,a4,-1
 486:	1702                	slli	a4,a4,0x20
 488:	9301                	srli	a4,a4,0x20
 48a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 48e:	fff94583          	lbu	a1,-1(s2)
 492:	8526                	mv	a0,s1
 494:	f5bff0ef          	jal	3ee <putc>
  while(--i >= 0)
 498:	197d                	addi	s2,s2,-1
 49a:	ff391ae3          	bne	s2,s3,48e <printint+0x82>
 49e:	7902                	ld	s2,32(sp)
 4a0:	69e2                	ld	s3,24(sp)
}
 4a2:	70e2                	ld	ra,56(sp)
 4a4:	7442                	ld	s0,48(sp)
 4a6:	74a2                	ld	s1,40(sp)
 4a8:	6121                	addi	sp,sp,64
 4aa:	8082                	ret
    x = -xx;
 4ac:	40b005bb          	negw	a1,a1
    neg = 1;
 4b0:	4885                	li	a7,1
    x = -xx;
 4b2:	bf85                	j	422 <printint+0x16>

00000000000004b4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b4:	711d                	addi	sp,sp,-96
 4b6:	ec86                	sd	ra,88(sp)
 4b8:	e8a2                	sd	s0,80(sp)
 4ba:	e0ca                	sd	s2,64(sp)
 4bc:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4be:	0005c903          	lbu	s2,0(a1)
 4c2:	26090863          	beqz	s2,732 <vprintf+0x27e>
 4c6:	e4a6                	sd	s1,72(sp)
 4c8:	fc4e                	sd	s3,56(sp)
 4ca:	f852                	sd	s4,48(sp)
 4cc:	f456                	sd	s5,40(sp)
 4ce:	f05a                	sd	s6,32(sp)
 4d0:	ec5e                	sd	s7,24(sp)
 4d2:	e862                	sd	s8,16(sp)
 4d4:	e466                	sd	s9,8(sp)
 4d6:	8b2a                	mv	s6,a0
 4d8:	8a2e                	mv	s4,a1
 4da:	8bb2                	mv	s7,a2
  state = 0;
 4dc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4de:	4481                	li	s1,0
 4e0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4e2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4e6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4ea:	06c00c93          	li	s9,108
 4ee:	a005                	j	50e <vprintf+0x5a>
        putc(fd, c0);
 4f0:	85ca                	mv	a1,s2
 4f2:	855a                	mv	a0,s6
 4f4:	efbff0ef          	jal	3ee <putc>
 4f8:	a019                	j	4fe <vprintf+0x4a>
    } else if(state == '%'){
 4fa:	03598263          	beq	s3,s5,51e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4fe:	2485                	addiw	s1,s1,1
 500:	8726                	mv	a4,s1
 502:	009a07b3          	add	a5,s4,s1
 506:	0007c903          	lbu	s2,0(a5)
 50a:	20090c63          	beqz	s2,722 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 50e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 512:	fe0994e3          	bnez	s3,4fa <vprintf+0x46>
      if(c0 == '%'){
 516:	fd579de3          	bne	a5,s5,4f0 <vprintf+0x3c>
        state = '%';
 51a:	89be                	mv	s3,a5
 51c:	b7cd                	j	4fe <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 51e:	00ea06b3          	add	a3,s4,a4
 522:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 526:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 528:	c681                	beqz	a3,530 <vprintf+0x7c>
 52a:	9752                	add	a4,a4,s4
 52c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 530:	03878f63          	beq	a5,s8,56e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 534:	05978963          	beq	a5,s9,586 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 538:	07500713          	li	a4,117
 53c:	0ee78363          	beq	a5,a4,622 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 540:	07800713          	li	a4,120
 544:	12e78563          	beq	a5,a4,66e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 548:	07000713          	li	a4,112
 54c:	14e78a63          	beq	a5,a4,6a0 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 550:	07300713          	li	a4,115
 554:	18e78a63          	beq	a5,a4,6e8 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 558:	02500713          	li	a4,37
 55c:	04e79563          	bne	a5,a4,5a6 <vprintf+0xf2>
        putc(fd, '%');
 560:	02500593          	li	a1,37
 564:	855a                	mv	a0,s6
 566:	e89ff0ef          	jal	3ee <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 56a:	4981                	li	s3,0
 56c:	bf49                	j	4fe <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 56e:	008b8913          	addi	s2,s7,8
 572:	4685                	li	a3,1
 574:	4629                	li	a2,10
 576:	000ba583          	lw	a1,0(s7)
 57a:	855a                	mv	a0,s6
 57c:	e91ff0ef          	jal	40c <printint>
 580:	8bca                	mv	s7,s2
      state = 0;
 582:	4981                	li	s3,0
 584:	bfad                	j	4fe <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 586:	06400793          	li	a5,100
 58a:	02f68963          	beq	a3,a5,5bc <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 58e:	06c00793          	li	a5,108
 592:	04f68263          	beq	a3,a5,5d6 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 596:	07500793          	li	a5,117
 59a:	0af68063          	beq	a3,a5,63a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 59e:	07800793          	li	a5,120
 5a2:	0ef68263          	beq	a3,a5,686 <vprintf+0x1d2>
        putc(fd, '%');
 5a6:	02500593          	li	a1,37
 5aa:	855a                	mv	a0,s6
 5ac:	e43ff0ef          	jal	3ee <putc>
        putc(fd, c0);
 5b0:	85ca                	mv	a1,s2
 5b2:	855a                	mv	a0,s6
 5b4:	e3bff0ef          	jal	3ee <putc>
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b791                	j	4fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5bc:	008b8913          	addi	s2,s7,8
 5c0:	4685                	li	a3,1
 5c2:	4629                	li	a2,10
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	e43ff0ef          	jal	40c <printint>
        i += 1;
 5ce:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d0:	8bca                	mv	s7,s2
      state = 0;
 5d2:	4981                	li	s3,0
        i += 1;
 5d4:	b72d                	j	4fe <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d6:	06400793          	li	a5,100
 5da:	02f60763          	beq	a2,a5,608 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5de:	07500793          	li	a5,117
 5e2:	06f60963          	beq	a2,a5,654 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5e6:	07800793          	li	a5,120
 5ea:	faf61ee3          	bne	a2,a5,5a6 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ee:	008b8913          	addi	s2,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4641                	li	a2,16
 5f6:	000ba583          	lw	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	e11ff0ef          	jal	40c <printint>
        i += 2;
 600:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 602:	8bca                	mv	s7,s2
      state = 0;
 604:	4981                	li	s3,0
        i += 2;
 606:	bde5                	j	4fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 608:	008b8913          	addi	s2,s7,8
 60c:	4685                	li	a3,1
 60e:	4629                	li	a2,10
 610:	000ba583          	lw	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	df7ff0ef          	jal	40c <printint>
        i += 2;
 61a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 61c:	8bca                	mv	s7,s2
      state = 0;
 61e:	4981                	li	s3,0
        i += 2;
 620:	bdf9                	j	4fe <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 622:	008b8913          	addi	s2,s7,8
 626:	4681                	li	a3,0
 628:	4629                	li	a2,10
 62a:	000ba583          	lw	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	dddff0ef          	jal	40c <printint>
 634:	8bca                	mv	s7,s2
      state = 0;
 636:	4981                	li	s3,0
 638:	b5d9                	j	4fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63a:	008b8913          	addi	s2,s7,8
 63e:	4681                	li	a3,0
 640:	4629                	li	a2,10
 642:	000ba583          	lw	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	dc5ff0ef          	jal	40c <printint>
        i += 1;
 64c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 64e:	8bca                	mv	s7,s2
      state = 0;
 650:	4981                	li	s3,0
        i += 1;
 652:	b575                	j	4fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 654:	008b8913          	addi	s2,s7,8
 658:	4681                	li	a3,0
 65a:	4629                	li	a2,10
 65c:	000ba583          	lw	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	dabff0ef          	jal	40c <printint>
        i += 2;
 666:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 668:	8bca                	mv	s7,s2
      state = 0;
 66a:	4981                	li	s3,0
        i += 2;
 66c:	bd49                	j	4fe <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 66e:	008b8913          	addi	s2,s7,8
 672:	4681                	li	a3,0
 674:	4641                	li	a2,16
 676:	000ba583          	lw	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	d91ff0ef          	jal	40c <printint>
 680:	8bca                	mv	s7,s2
      state = 0;
 682:	4981                	li	s3,0
 684:	bdad                	j	4fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 686:	008b8913          	addi	s2,s7,8
 68a:	4681                	li	a3,0
 68c:	4641                	li	a2,16
 68e:	000ba583          	lw	a1,0(s7)
 692:	855a                	mv	a0,s6
 694:	d79ff0ef          	jal	40c <printint>
        i += 1;
 698:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 69a:	8bca                	mv	s7,s2
      state = 0;
 69c:	4981                	li	s3,0
        i += 1;
 69e:	b585                	j	4fe <vprintf+0x4a>
 6a0:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6a2:	008b8d13          	addi	s10,s7,8
 6a6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6aa:	03000593          	li	a1,48
 6ae:	855a                	mv	a0,s6
 6b0:	d3fff0ef          	jal	3ee <putc>
  putc(fd, 'x');
 6b4:	07800593          	li	a1,120
 6b8:	855a                	mv	a0,s6
 6ba:	d35ff0ef          	jal	3ee <putc>
 6be:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c0:	00000b97          	auipc	s7,0x0
 6c4:	340b8b93          	addi	s7,s7,832 # a00 <digits>
 6c8:	03c9d793          	srli	a5,s3,0x3c
 6cc:	97de                	add	a5,a5,s7
 6ce:	0007c583          	lbu	a1,0(a5)
 6d2:	855a                	mv	a0,s6
 6d4:	d1bff0ef          	jal	3ee <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d8:	0992                	slli	s3,s3,0x4
 6da:	397d                	addiw	s2,s2,-1
 6dc:	fe0916e3          	bnez	s2,6c8 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6e0:	8bea                	mv	s7,s10
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	6d02                	ld	s10,0(sp)
 6e6:	bd21                	j	4fe <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6e8:	008b8993          	addi	s3,s7,8
 6ec:	000bb903          	ld	s2,0(s7)
 6f0:	00090f63          	beqz	s2,70e <vprintf+0x25a>
        for(; *s; s++)
 6f4:	00094583          	lbu	a1,0(s2)
 6f8:	c195                	beqz	a1,71c <vprintf+0x268>
          putc(fd, *s);
 6fa:	855a                	mv	a0,s6
 6fc:	cf3ff0ef          	jal	3ee <putc>
        for(; *s; s++)
 700:	0905                	addi	s2,s2,1
 702:	00094583          	lbu	a1,0(s2)
 706:	f9f5                	bnez	a1,6fa <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 708:	8bce                	mv	s7,s3
      state = 0;
 70a:	4981                	li	s3,0
 70c:	bbcd                	j	4fe <vprintf+0x4a>
          s = "(null)";
 70e:	00000917          	auipc	s2,0x0
 712:	2ea90913          	addi	s2,s2,746 # 9f8 <malloc+0x1de>
        for(; *s; s++)
 716:	02800593          	li	a1,40
 71a:	b7c5                	j	6fa <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 71c:	8bce                	mv	s7,s3
      state = 0;
 71e:	4981                	li	s3,0
 720:	bbf9                	j	4fe <vprintf+0x4a>
 722:	64a6                	ld	s1,72(sp)
 724:	79e2                	ld	s3,56(sp)
 726:	7a42                	ld	s4,48(sp)
 728:	7aa2                	ld	s5,40(sp)
 72a:	7b02                	ld	s6,32(sp)
 72c:	6be2                	ld	s7,24(sp)
 72e:	6c42                	ld	s8,16(sp)
 730:	6ca2                	ld	s9,8(sp)
    }
  }
}
 732:	60e6                	ld	ra,88(sp)
 734:	6446                	ld	s0,80(sp)
 736:	6906                	ld	s2,64(sp)
 738:	6125                	addi	sp,sp,96
 73a:	8082                	ret

000000000000073c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 73c:	715d                	addi	sp,sp,-80
 73e:	ec06                	sd	ra,24(sp)
 740:	e822                	sd	s0,16(sp)
 742:	1000                	addi	s0,sp,32
 744:	e010                	sd	a2,0(s0)
 746:	e414                	sd	a3,8(s0)
 748:	e818                	sd	a4,16(s0)
 74a:	ec1c                	sd	a5,24(s0)
 74c:	03043023          	sd	a6,32(s0)
 750:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 754:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 758:	8622                	mv	a2,s0
 75a:	d5bff0ef          	jal	4b4 <vprintf>
}
 75e:	60e2                	ld	ra,24(sp)
 760:	6442                	ld	s0,16(sp)
 762:	6161                	addi	sp,sp,80
 764:	8082                	ret

0000000000000766 <printf>:

void
printf(const char *fmt, ...)
{
 766:	711d                	addi	sp,sp,-96
 768:	ec06                	sd	ra,24(sp)
 76a:	e822                	sd	s0,16(sp)
 76c:	1000                	addi	s0,sp,32
 76e:	e40c                	sd	a1,8(s0)
 770:	e810                	sd	a2,16(s0)
 772:	ec14                	sd	a3,24(s0)
 774:	f018                	sd	a4,32(s0)
 776:	f41c                	sd	a5,40(s0)
 778:	03043823          	sd	a6,48(s0)
 77c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 780:	00840613          	addi	a2,s0,8
 784:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 788:	85aa                	mv	a1,a0
 78a:	4505                	li	a0,1
 78c:	d29ff0ef          	jal	4b4 <vprintf>
}
 790:	60e2                	ld	ra,24(sp)
 792:	6442                	ld	s0,16(sp)
 794:	6125                	addi	sp,sp,96
 796:	8082                	ret

0000000000000798 <free>:
 798:	1141                	addi	sp,sp,-16
 79a:	e422                	sd	s0,8(sp)
 79c:	0800                	addi	s0,sp,16
 79e:	ff050693          	addi	a3,a0,-16
 7a2:	00001797          	auipc	a5,0x1
 7a6:	85e7b783          	ld	a5,-1954(a5) # 1000 <freep>
 7aa:	a02d                	j	7d4 <free+0x3c>
 7ac:	4618                	lw	a4,8(a2)
 7ae:	9f2d                	addw	a4,a4,a1
 7b0:	fee52c23          	sw	a4,-8(a0)
 7b4:	6398                	ld	a4,0(a5)
 7b6:	6310                	ld	a2,0(a4)
 7b8:	a83d                	j	7f6 <free+0x5e>
 7ba:	ff852703          	lw	a4,-8(a0)
 7be:	9f31                	addw	a4,a4,a2
 7c0:	c798                	sw	a4,8(a5)
 7c2:	ff053683          	ld	a3,-16(a0)
 7c6:	a091                	j	80a <free+0x72>
 7c8:	6398                	ld	a4,0(a5)
 7ca:	00e7e463          	bltu	a5,a4,7d2 <free+0x3a>
 7ce:	00e6ea63          	bltu	a3,a4,7e2 <free+0x4a>
 7d2:	87ba                	mv	a5,a4
 7d4:	fed7fae3          	bgeu	a5,a3,7c8 <free+0x30>
 7d8:	6398                	ld	a4,0(a5)
 7da:	00e6e463          	bltu	a3,a4,7e2 <free+0x4a>
 7de:	fee7eae3          	bltu	a5,a4,7d2 <free+0x3a>
 7e2:	ff852583          	lw	a1,-8(a0)
 7e6:	6390                	ld	a2,0(a5)
 7e8:	02059813          	slli	a6,a1,0x20
 7ec:	01c85713          	srli	a4,a6,0x1c
 7f0:	9736                	add	a4,a4,a3
 7f2:	fae60de3          	beq	a2,a4,7ac <free+0x14>
 7f6:	fec53823          	sd	a2,-16(a0)
 7fa:	4790                	lw	a2,8(a5)
 7fc:	02061593          	slli	a1,a2,0x20
 800:	01c5d713          	srli	a4,a1,0x1c
 804:	973e                	add	a4,a4,a5
 806:	fae68ae3          	beq	a3,a4,7ba <free+0x22>
 80a:	e394                	sd	a3,0(a5)
 80c:	00000717          	auipc	a4,0x0
 810:	7ef73a23          	sd	a5,2036(a4) # 1000 <freep>
 814:	6422                	ld	s0,8(sp)
 816:	0141                	addi	sp,sp,16
 818:	8082                	ret

000000000000081a <malloc>:
 81a:	7139                	addi	sp,sp,-64
 81c:	fc06                	sd	ra,56(sp)
 81e:	f822                	sd	s0,48(sp)
 820:	f426                	sd	s1,40(sp)
 822:	ec4e                	sd	s3,24(sp)
 824:	0080                	addi	s0,sp,64
 826:	02051493          	slli	s1,a0,0x20
 82a:	9081                	srli	s1,s1,0x20
 82c:	04bd                	addi	s1,s1,15
 82e:	8091                	srli	s1,s1,0x4
 830:	0014899b          	addiw	s3,s1,1
 834:	0485                	addi	s1,s1,1
 836:	00000517          	auipc	a0,0x0
 83a:	7ca53503          	ld	a0,1994(a0) # 1000 <freep>
 83e:	c915                	beqz	a0,872 <malloc+0x58>
 840:	611c                	ld	a5,0(a0)
 842:	4798                	lw	a4,8(a5)
 844:	08977a63          	bgeu	a4,s1,8d8 <malloc+0xbe>
 848:	f04a                	sd	s2,32(sp)
 84a:	e852                	sd	s4,16(sp)
 84c:	e456                	sd	s5,8(sp)
 84e:	e05a                	sd	s6,0(sp)
 850:	8a4e                	mv	s4,s3
 852:	0009871b          	sext.w	a4,s3
 856:	6685                	lui	a3,0x1
 858:	00d77363          	bgeu	a4,a3,85e <malloc+0x44>
 85c:	6a05                	lui	s4,0x1
 85e:	000a0b1b          	sext.w	s6,s4
 862:	004a1a1b          	slliw	s4,s4,0x4
 866:	00000917          	auipc	s2,0x0
 86a:	79a90913          	addi	s2,s2,1946 # 1000 <freep>
 86e:	5afd                	li	s5,-1
 870:	a081                	j	8b0 <malloc+0x96>
 872:	f04a                	sd	s2,32(sp)
 874:	e852                	sd	s4,16(sp)
 876:	e456                	sd	s5,8(sp)
 878:	e05a                	sd	s6,0(sp)
 87a:	00000797          	auipc	a5,0x0
 87e:	79678793          	addi	a5,a5,1942 # 1010 <base>
 882:	00000717          	auipc	a4,0x0
 886:	76f73f23          	sd	a5,1918(a4) # 1000 <freep>
 88a:	e39c                	sd	a5,0(a5)
 88c:	0007a423          	sw	zero,8(a5)
 890:	b7c1                	j	850 <malloc+0x36>
 892:	6398                	ld	a4,0(a5)
 894:	e118                	sd	a4,0(a0)
 896:	a8a9                	j	8f0 <malloc+0xd6>
 898:	01652423          	sw	s6,8(a0)
 89c:	0541                	addi	a0,a0,16
 89e:	efbff0ef          	jal	798 <free>
 8a2:	00093503          	ld	a0,0(s2)
 8a6:	c12d                	beqz	a0,908 <malloc+0xee>
 8a8:	611c                	ld	a5,0(a0)
 8aa:	4798                	lw	a4,8(a5)
 8ac:	02977263          	bgeu	a4,s1,8d0 <malloc+0xb6>
 8b0:	00093703          	ld	a4,0(s2)
 8b4:	853e                	mv	a0,a5
 8b6:	fef719e3          	bne	a4,a5,8a8 <malloc+0x8e>
 8ba:	8552                	mv	a0,s4
 8bc:	afbff0ef          	jal	3b6 <sbrk>
 8c0:	fd551ce3          	bne	a0,s5,898 <malloc+0x7e>
 8c4:	4501                	li	a0,0
 8c6:	7902                	ld	s2,32(sp)
 8c8:	6a42                	ld	s4,16(sp)
 8ca:	6aa2                	ld	s5,8(sp)
 8cc:	6b02                	ld	s6,0(sp)
 8ce:	a03d                	j	8fc <malloc+0xe2>
 8d0:	7902                	ld	s2,32(sp)
 8d2:	6a42                	ld	s4,16(sp)
 8d4:	6aa2                	ld	s5,8(sp)
 8d6:	6b02                	ld	s6,0(sp)
 8d8:	fae48de3          	beq	s1,a4,892 <malloc+0x78>
 8dc:	4137073b          	subw	a4,a4,s3
 8e0:	c798                	sw	a4,8(a5)
 8e2:	02071693          	slli	a3,a4,0x20
 8e6:	01c6d713          	srli	a4,a3,0x1c
 8ea:	97ba                	add	a5,a5,a4
 8ec:	0137a423          	sw	s3,8(a5)
 8f0:	00000717          	auipc	a4,0x0
 8f4:	70a73823          	sd	a0,1808(a4) # 1000 <freep>
 8f8:	01078513          	addi	a0,a5,16
 8fc:	70e2                	ld	ra,56(sp)
 8fe:	7442                	ld	s0,48(sp)
 900:	74a2                	ld	s1,40(sp)
 902:	69e2                	ld	s3,24(sp)
 904:	6121                	addi	sp,sp,64
 906:	8082                	ret
 908:	7902                	ld	s2,32(sp)
 90a:	6a42                	ld	s4,16(sp)
 90c:	6aa2                	ld	s5,8(sp)
 90e:	6b02                	ld	s6,0(sp)
 910:	b7f5                	j	8fc <malloc+0xe2>
