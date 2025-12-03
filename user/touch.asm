
user/_touch:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_help>:
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   8:	00001517          	auipc	a0,0x1
   c:	91850513          	addi	a0,a0,-1768 # 920 <malloc+0xfe>
  10:	75e000ef          	jal	76e <printf>
  14:	00001517          	auipc	a0,0x1
  18:	92c50513          	addi	a0,a0,-1748 # 940 <malloc+0x11e>
  1c:	752000ef          	jal	76e <printf>
  20:	00001517          	auipc	a0,0x1
  24:	95050513          	addi	a0,a0,-1712 # 970 <malloc+0x14e>
  28:	746000ef          	jal	76e <printf>
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
  4a:	95a58593          	addi	a1,a1,-1702 # 9a0 <malloc+0x17e>
  4e:	8526                	mv	a0,s1
  50:	0a2000ef          	jal	f2 <strcmp>
  54:	e105                	bnez	a0,74 <main+0x40>
  56:	fabff0ef          	jal	0 <print_help>
  5a:	4501                	li	a0,0
  5c:	2d2000ef          	jal	32e <exit>
  60:	e426                	sd	s1,8(sp)
  62:	00001517          	auipc	a0,0x1
  66:	8be50513          	addi	a0,a0,-1858 # 920 <malloc+0xfe>
  6a:	704000ef          	jal	76e <printf>
  6e:	4505                	li	a0,1
  70:	2be000ef          	jal	32e <exit>
  74:	4581                	li	a1,0
  76:	8526                	mv	a0,s1
  78:	2f6000ef          	jal	36e <open>
  7c:	00054e63          	bltz	a0,98 <main+0x64>
  80:	2d6000ef          	jal	356 <close>
  84:	85a6                	mv	a1,s1
  86:	00001517          	auipc	a0,0x1
  8a:	92250513          	addi	a0,a0,-1758 # 9a8 <malloc+0x186>
  8e:	6e0000ef          	jal	76e <printf>
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
  b6:	91e50513          	addi	a0,a0,-1762 # 9d0 <malloc+0x1ae>
  ba:	6b4000ef          	jal	76e <printf>
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

00000000000003ee <rand>:
.global rand
rand:
 li a7, SYS_rand
 3ee:	48ed                	li	a7,27
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3f6:	1101                	addi	sp,sp,-32
 3f8:	ec06                	sd	ra,24(sp)
 3fa:	e822                	sd	s0,16(sp)
 3fc:	1000                	addi	s0,sp,32
 3fe:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 402:	4605                	li	a2,1
 404:	fef40593          	addi	a1,s0,-17
 408:	f47ff0ef          	jal	34e <write>
}
 40c:	60e2                	ld	ra,24(sp)
 40e:	6442                	ld	s0,16(sp)
 410:	6105                	addi	sp,sp,32
 412:	8082                	ret

0000000000000414 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 414:	7139                	addi	sp,sp,-64
 416:	fc06                	sd	ra,56(sp)
 418:	f822                	sd	s0,48(sp)
 41a:	f426                	sd	s1,40(sp)
 41c:	0080                	addi	s0,sp,64
 41e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 420:	c299                	beqz	a3,426 <printint+0x12>
 422:	0805c963          	bltz	a1,4b4 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 426:	2581                	sext.w	a1,a1
  neg = 0;
 428:	4881                	li	a7,0
 42a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 42e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 430:	2601                	sext.w	a2,a2
 432:	00000517          	auipc	a0,0x0
 436:	5ce50513          	addi	a0,a0,1486 # a00 <digits>
 43a:	883a                	mv	a6,a4
 43c:	2705                	addiw	a4,a4,1
 43e:	02c5f7bb          	remuw	a5,a1,a2
 442:	1782                	slli	a5,a5,0x20
 444:	9381                	srli	a5,a5,0x20
 446:	97aa                	add	a5,a5,a0
 448:	0007c783          	lbu	a5,0(a5)
 44c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 450:	0005879b          	sext.w	a5,a1
 454:	02c5d5bb          	divuw	a1,a1,a2
 458:	0685                	addi	a3,a3,1
 45a:	fec7f0e3          	bgeu	a5,a2,43a <printint+0x26>
  if(neg)
 45e:	00088c63          	beqz	a7,476 <printint+0x62>
    buf[i++] = '-';
 462:	fd070793          	addi	a5,a4,-48
 466:	00878733          	add	a4,a5,s0
 46a:	02d00793          	li	a5,45
 46e:	fef70823          	sb	a5,-16(a4)
 472:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 476:	02e05a63          	blez	a4,4aa <printint+0x96>
 47a:	f04a                	sd	s2,32(sp)
 47c:	ec4e                	sd	s3,24(sp)
 47e:	fc040793          	addi	a5,s0,-64
 482:	00e78933          	add	s2,a5,a4
 486:	fff78993          	addi	s3,a5,-1
 48a:	99ba                	add	s3,s3,a4
 48c:	377d                	addiw	a4,a4,-1
 48e:	1702                	slli	a4,a4,0x20
 490:	9301                	srli	a4,a4,0x20
 492:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 496:	fff94583          	lbu	a1,-1(s2)
 49a:	8526                	mv	a0,s1
 49c:	f5bff0ef          	jal	3f6 <putc>
  while(--i >= 0)
 4a0:	197d                	addi	s2,s2,-1
 4a2:	ff391ae3          	bne	s2,s3,496 <printint+0x82>
 4a6:	7902                	ld	s2,32(sp)
 4a8:	69e2                	ld	s3,24(sp)
}
 4aa:	70e2                	ld	ra,56(sp)
 4ac:	7442                	ld	s0,48(sp)
 4ae:	74a2                	ld	s1,40(sp)
 4b0:	6121                	addi	sp,sp,64
 4b2:	8082                	ret
    x = -xx;
 4b4:	40b005bb          	negw	a1,a1
    neg = 1;
 4b8:	4885                	li	a7,1
    x = -xx;
 4ba:	bf85                	j	42a <printint+0x16>

00000000000004bc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4bc:	711d                	addi	sp,sp,-96
 4be:	ec86                	sd	ra,88(sp)
 4c0:	e8a2                	sd	s0,80(sp)
 4c2:	e0ca                	sd	s2,64(sp)
 4c4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4c6:	0005c903          	lbu	s2,0(a1)
 4ca:	26090863          	beqz	s2,73a <vprintf+0x27e>
 4ce:	e4a6                	sd	s1,72(sp)
 4d0:	fc4e                	sd	s3,56(sp)
 4d2:	f852                	sd	s4,48(sp)
 4d4:	f456                	sd	s5,40(sp)
 4d6:	f05a                	sd	s6,32(sp)
 4d8:	ec5e                	sd	s7,24(sp)
 4da:	e862                	sd	s8,16(sp)
 4dc:	e466                	sd	s9,8(sp)
 4de:	8b2a                	mv	s6,a0
 4e0:	8a2e                	mv	s4,a1
 4e2:	8bb2                	mv	s7,a2
  state = 0;
 4e4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4e6:	4481                	li	s1,0
 4e8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4ea:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4ee:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4f2:	06c00c93          	li	s9,108
 4f6:	a005                	j	516 <vprintf+0x5a>
        putc(fd, c0);
 4f8:	85ca                	mv	a1,s2
 4fa:	855a                	mv	a0,s6
 4fc:	efbff0ef          	jal	3f6 <putc>
 500:	a019                	j	506 <vprintf+0x4a>
    } else if(state == '%'){
 502:	03598263          	beq	s3,s5,526 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 506:	2485                	addiw	s1,s1,1
 508:	8726                	mv	a4,s1
 50a:	009a07b3          	add	a5,s4,s1
 50e:	0007c903          	lbu	s2,0(a5)
 512:	20090c63          	beqz	s2,72a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 516:	0009079b          	sext.w	a5,s2
    if(state == 0){
 51a:	fe0994e3          	bnez	s3,502 <vprintf+0x46>
      if(c0 == '%'){
 51e:	fd579de3          	bne	a5,s5,4f8 <vprintf+0x3c>
        state = '%';
 522:	89be                	mv	s3,a5
 524:	b7cd                	j	506 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 526:	00ea06b3          	add	a3,s4,a4
 52a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 52e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 530:	c681                	beqz	a3,538 <vprintf+0x7c>
 532:	9752                	add	a4,a4,s4
 534:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 538:	03878f63          	beq	a5,s8,576 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 53c:	05978963          	beq	a5,s9,58e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 540:	07500713          	li	a4,117
 544:	0ee78363          	beq	a5,a4,62a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 548:	07800713          	li	a4,120
 54c:	12e78563          	beq	a5,a4,676 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 550:	07000713          	li	a4,112
 554:	14e78a63          	beq	a5,a4,6a8 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 558:	07300713          	li	a4,115
 55c:	18e78a63          	beq	a5,a4,6f0 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 560:	02500713          	li	a4,37
 564:	04e79563          	bne	a5,a4,5ae <vprintf+0xf2>
        putc(fd, '%');
 568:	02500593          	li	a1,37
 56c:	855a                	mv	a0,s6
 56e:	e89ff0ef          	jal	3f6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 572:	4981                	li	s3,0
 574:	bf49                	j	506 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 576:	008b8913          	addi	s2,s7,8
 57a:	4685                	li	a3,1
 57c:	4629                	li	a2,10
 57e:	000ba583          	lw	a1,0(s7)
 582:	855a                	mv	a0,s6
 584:	e91ff0ef          	jal	414 <printint>
 588:	8bca                	mv	s7,s2
      state = 0;
 58a:	4981                	li	s3,0
 58c:	bfad                	j	506 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 58e:	06400793          	li	a5,100
 592:	02f68963          	beq	a3,a5,5c4 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 596:	06c00793          	li	a5,108
 59a:	04f68263          	beq	a3,a5,5de <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 59e:	07500793          	li	a5,117
 5a2:	0af68063          	beq	a3,a5,642 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5a6:	07800793          	li	a5,120
 5aa:	0ef68263          	beq	a3,a5,68e <vprintf+0x1d2>
        putc(fd, '%');
 5ae:	02500593          	li	a1,37
 5b2:	855a                	mv	a0,s6
 5b4:	e43ff0ef          	jal	3f6 <putc>
        putc(fd, c0);
 5b8:	85ca                	mv	a1,s2
 5ba:	855a                	mv	a0,s6
 5bc:	e3bff0ef          	jal	3f6 <putc>
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	b791                	j	506 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c4:	008b8913          	addi	s2,s7,8
 5c8:	4685                	li	a3,1
 5ca:	4629                	li	a2,10
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	e43ff0ef          	jal	414 <printint>
        i += 1;
 5d6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d8:	8bca                	mv	s7,s2
      state = 0;
 5da:	4981                	li	s3,0
        i += 1;
 5dc:	b72d                	j	506 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5de:	06400793          	li	a5,100
 5e2:	02f60763          	beq	a2,a5,610 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5e6:	07500793          	li	a5,117
 5ea:	06f60963          	beq	a2,a5,65c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5ee:	07800793          	li	a5,120
 5f2:	faf61ee3          	bne	a2,a5,5ae <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f6:	008b8913          	addi	s2,s7,8
 5fa:	4681                	li	a3,0
 5fc:	4641                	li	a2,16
 5fe:	000ba583          	lw	a1,0(s7)
 602:	855a                	mv	a0,s6
 604:	e11ff0ef          	jal	414 <printint>
        i += 2;
 608:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 60a:	8bca                	mv	s7,s2
      state = 0;
 60c:	4981                	li	s3,0
        i += 2;
 60e:	bde5                	j	506 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 610:	008b8913          	addi	s2,s7,8
 614:	4685                	li	a3,1
 616:	4629                	li	a2,10
 618:	000ba583          	lw	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	df7ff0ef          	jal	414 <printint>
        i += 2;
 622:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 624:	8bca                	mv	s7,s2
      state = 0;
 626:	4981                	li	s3,0
        i += 2;
 628:	bdf9                	j	506 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 62a:	008b8913          	addi	s2,s7,8
 62e:	4681                	li	a3,0
 630:	4629                	li	a2,10
 632:	000ba583          	lw	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	dddff0ef          	jal	414 <printint>
 63c:	8bca                	mv	s7,s2
      state = 0;
 63e:	4981                	li	s3,0
 640:	b5d9                	j	506 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 642:	008b8913          	addi	s2,s7,8
 646:	4681                	li	a3,0
 648:	4629                	li	a2,10
 64a:	000ba583          	lw	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	dc5ff0ef          	jal	414 <printint>
        i += 1;
 654:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 656:	8bca                	mv	s7,s2
      state = 0;
 658:	4981                	li	s3,0
        i += 1;
 65a:	b575                	j	506 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65c:	008b8913          	addi	s2,s7,8
 660:	4681                	li	a3,0
 662:	4629                	li	a2,10
 664:	000ba583          	lw	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	dabff0ef          	jal	414 <printint>
        i += 2;
 66e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 670:	8bca                	mv	s7,s2
      state = 0;
 672:	4981                	li	s3,0
        i += 2;
 674:	bd49                	j	506 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 676:	008b8913          	addi	s2,s7,8
 67a:	4681                	li	a3,0
 67c:	4641                	li	a2,16
 67e:	000ba583          	lw	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	d91ff0ef          	jal	414 <printint>
 688:	8bca                	mv	s7,s2
      state = 0;
 68a:	4981                	li	s3,0
 68c:	bdad                	j	506 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 68e:	008b8913          	addi	s2,s7,8
 692:	4681                	li	a3,0
 694:	4641                	li	a2,16
 696:	000ba583          	lw	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	d79ff0ef          	jal	414 <printint>
        i += 1;
 6a0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a2:	8bca                	mv	s7,s2
      state = 0;
 6a4:	4981                	li	s3,0
        i += 1;
 6a6:	b585                	j	506 <vprintf+0x4a>
 6a8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6aa:	008b8d13          	addi	s10,s7,8
 6ae:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6b2:	03000593          	li	a1,48
 6b6:	855a                	mv	a0,s6
 6b8:	d3fff0ef          	jal	3f6 <putc>
  putc(fd, 'x');
 6bc:	07800593          	li	a1,120
 6c0:	855a                	mv	a0,s6
 6c2:	d35ff0ef          	jal	3f6 <putc>
 6c6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c8:	00000b97          	auipc	s7,0x0
 6cc:	338b8b93          	addi	s7,s7,824 # a00 <digits>
 6d0:	03c9d793          	srli	a5,s3,0x3c
 6d4:	97de                	add	a5,a5,s7
 6d6:	0007c583          	lbu	a1,0(a5)
 6da:	855a                	mv	a0,s6
 6dc:	d1bff0ef          	jal	3f6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e0:	0992                	slli	s3,s3,0x4
 6e2:	397d                	addiw	s2,s2,-1
 6e4:	fe0916e3          	bnez	s2,6d0 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6e8:	8bea                	mv	s7,s10
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	6d02                	ld	s10,0(sp)
 6ee:	bd21                	j	506 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6f0:	008b8993          	addi	s3,s7,8
 6f4:	000bb903          	ld	s2,0(s7)
 6f8:	00090f63          	beqz	s2,716 <vprintf+0x25a>
        for(; *s; s++)
 6fc:	00094583          	lbu	a1,0(s2)
 700:	c195                	beqz	a1,724 <vprintf+0x268>
          putc(fd, *s);
 702:	855a                	mv	a0,s6
 704:	cf3ff0ef          	jal	3f6 <putc>
        for(; *s; s++)
 708:	0905                	addi	s2,s2,1
 70a:	00094583          	lbu	a1,0(s2)
 70e:	f9f5                	bnez	a1,702 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 710:	8bce                	mv	s7,s3
      state = 0;
 712:	4981                	li	s3,0
 714:	bbcd                	j	506 <vprintf+0x4a>
          s = "(null)";
 716:	00000917          	auipc	s2,0x0
 71a:	2e290913          	addi	s2,s2,738 # 9f8 <malloc+0x1d6>
        for(; *s; s++)
 71e:	02800593          	li	a1,40
 722:	b7c5                	j	702 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 724:	8bce                	mv	s7,s3
      state = 0;
 726:	4981                	li	s3,0
 728:	bbf9                	j	506 <vprintf+0x4a>
 72a:	64a6                	ld	s1,72(sp)
 72c:	79e2                	ld	s3,56(sp)
 72e:	7a42                	ld	s4,48(sp)
 730:	7aa2                	ld	s5,40(sp)
 732:	7b02                	ld	s6,32(sp)
 734:	6be2                	ld	s7,24(sp)
 736:	6c42                	ld	s8,16(sp)
 738:	6ca2                	ld	s9,8(sp)
    }
  }
}
 73a:	60e6                	ld	ra,88(sp)
 73c:	6446                	ld	s0,80(sp)
 73e:	6906                	ld	s2,64(sp)
 740:	6125                	addi	sp,sp,96
 742:	8082                	ret

0000000000000744 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 744:	715d                	addi	sp,sp,-80
 746:	ec06                	sd	ra,24(sp)
 748:	e822                	sd	s0,16(sp)
 74a:	1000                	addi	s0,sp,32
 74c:	e010                	sd	a2,0(s0)
 74e:	e414                	sd	a3,8(s0)
 750:	e818                	sd	a4,16(s0)
 752:	ec1c                	sd	a5,24(s0)
 754:	03043023          	sd	a6,32(s0)
 758:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 75c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 760:	8622                	mv	a2,s0
 762:	d5bff0ef          	jal	4bc <vprintf>
}
 766:	60e2                	ld	ra,24(sp)
 768:	6442                	ld	s0,16(sp)
 76a:	6161                	addi	sp,sp,80
 76c:	8082                	ret

000000000000076e <printf>:

void
printf(const char *fmt, ...)
{
 76e:	711d                	addi	sp,sp,-96
 770:	ec06                	sd	ra,24(sp)
 772:	e822                	sd	s0,16(sp)
 774:	1000                	addi	s0,sp,32
 776:	e40c                	sd	a1,8(s0)
 778:	e810                	sd	a2,16(s0)
 77a:	ec14                	sd	a3,24(s0)
 77c:	f018                	sd	a4,32(s0)
 77e:	f41c                	sd	a5,40(s0)
 780:	03043823          	sd	a6,48(s0)
 784:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 788:	00840613          	addi	a2,s0,8
 78c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 790:	85aa                	mv	a1,a0
 792:	4505                	li	a0,1
 794:	d29ff0ef          	jal	4bc <vprintf>
}
 798:	60e2                	ld	ra,24(sp)
 79a:	6442                	ld	s0,16(sp)
 79c:	6125                	addi	sp,sp,96
 79e:	8082                	ret

00000000000007a0 <free>:
 7a0:	1141                	addi	sp,sp,-16
 7a2:	e422                	sd	s0,8(sp)
 7a4:	0800                	addi	s0,sp,16
 7a6:	ff050693          	addi	a3,a0,-16
 7aa:	00001797          	auipc	a5,0x1
 7ae:	8567b783          	ld	a5,-1962(a5) # 1000 <freep>
 7b2:	a02d                	j	7dc <free+0x3c>
 7b4:	4618                	lw	a4,8(a2)
 7b6:	9f2d                	addw	a4,a4,a1
 7b8:	fee52c23          	sw	a4,-8(a0)
 7bc:	6398                	ld	a4,0(a5)
 7be:	6310                	ld	a2,0(a4)
 7c0:	a83d                	j	7fe <free+0x5e>
 7c2:	ff852703          	lw	a4,-8(a0)
 7c6:	9f31                	addw	a4,a4,a2
 7c8:	c798                	sw	a4,8(a5)
 7ca:	ff053683          	ld	a3,-16(a0)
 7ce:	a091                	j	812 <free+0x72>
 7d0:	6398                	ld	a4,0(a5)
 7d2:	00e7e463          	bltu	a5,a4,7da <free+0x3a>
 7d6:	00e6ea63          	bltu	a3,a4,7ea <free+0x4a>
 7da:	87ba                	mv	a5,a4
 7dc:	fed7fae3          	bgeu	a5,a3,7d0 <free+0x30>
 7e0:	6398                	ld	a4,0(a5)
 7e2:	00e6e463          	bltu	a3,a4,7ea <free+0x4a>
 7e6:	fee7eae3          	bltu	a5,a4,7da <free+0x3a>
 7ea:	ff852583          	lw	a1,-8(a0)
 7ee:	6390                	ld	a2,0(a5)
 7f0:	02059813          	slli	a6,a1,0x20
 7f4:	01c85713          	srli	a4,a6,0x1c
 7f8:	9736                	add	a4,a4,a3
 7fa:	fae60de3          	beq	a2,a4,7b4 <free+0x14>
 7fe:	fec53823          	sd	a2,-16(a0)
 802:	4790                	lw	a2,8(a5)
 804:	02061593          	slli	a1,a2,0x20
 808:	01c5d713          	srli	a4,a1,0x1c
 80c:	973e                	add	a4,a4,a5
 80e:	fae68ae3          	beq	a3,a4,7c2 <free+0x22>
 812:	e394                	sd	a3,0(a5)
 814:	00000717          	auipc	a4,0x0
 818:	7ef73623          	sd	a5,2028(a4) # 1000 <freep>
 81c:	6422                	ld	s0,8(sp)
 81e:	0141                	addi	sp,sp,16
 820:	8082                	ret

0000000000000822 <malloc>:
 822:	7139                	addi	sp,sp,-64
 824:	fc06                	sd	ra,56(sp)
 826:	f822                	sd	s0,48(sp)
 828:	f426                	sd	s1,40(sp)
 82a:	ec4e                	sd	s3,24(sp)
 82c:	0080                	addi	s0,sp,64
 82e:	02051493          	slli	s1,a0,0x20
 832:	9081                	srli	s1,s1,0x20
 834:	04bd                	addi	s1,s1,15
 836:	8091                	srli	s1,s1,0x4
 838:	0014899b          	addiw	s3,s1,1
 83c:	0485                	addi	s1,s1,1
 83e:	00000517          	auipc	a0,0x0
 842:	7c253503          	ld	a0,1986(a0) # 1000 <freep>
 846:	c915                	beqz	a0,87a <malloc+0x58>
 848:	611c                	ld	a5,0(a0)
 84a:	4798                	lw	a4,8(a5)
 84c:	08977a63          	bgeu	a4,s1,8e0 <malloc+0xbe>
 850:	f04a                	sd	s2,32(sp)
 852:	e852                	sd	s4,16(sp)
 854:	e456                	sd	s5,8(sp)
 856:	e05a                	sd	s6,0(sp)
 858:	8a4e                	mv	s4,s3
 85a:	0009871b          	sext.w	a4,s3
 85e:	6685                	lui	a3,0x1
 860:	00d77363          	bgeu	a4,a3,866 <malloc+0x44>
 864:	6a05                	lui	s4,0x1
 866:	000a0b1b          	sext.w	s6,s4
 86a:	004a1a1b          	slliw	s4,s4,0x4
 86e:	00000917          	auipc	s2,0x0
 872:	79290913          	addi	s2,s2,1938 # 1000 <freep>
 876:	5afd                	li	s5,-1
 878:	a081                	j	8b8 <malloc+0x96>
 87a:	f04a                	sd	s2,32(sp)
 87c:	e852                	sd	s4,16(sp)
 87e:	e456                	sd	s5,8(sp)
 880:	e05a                	sd	s6,0(sp)
 882:	00000797          	auipc	a5,0x0
 886:	78e78793          	addi	a5,a5,1934 # 1010 <base>
 88a:	00000717          	auipc	a4,0x0
 88e:	76f73b23          	sd	a5,1910(a4) # 1000 <freep>
 892:	e39c                	sd	a5,0(a5)
 894:	0007a423          	sw	zero,8(a5)
 898:	b7c1                	j	858 <malloc+0x36>
 89a:	6398                	ld	a4,0(a5)
 89c:	e118                	sd	a4,0(a0)
 89e:	a8a9                	j	8f8 <malloc+0xd6>
 8a0:	01652423          	sw	s6,8(a0)
 8a4:	0541                	addi	a0,a0,16
 8a6:	efbff0ef          	jal	7a0 <free>
 8aa:	00093503          	ld	a0,0(s2)
 8ae:	c12d                	beqz	a0,910 <malloc+0xee>
 8b0:	611c                	ld	a5,0(a0)
 8b2:	4798                	lw	a4,8(a5)
 8b4:	02977263          	bgeu	a4,s1,8d8 <malloc+0xb6>
 8b8:	00093703          	ld	a4,0(s2)
 8bc:	853e                	mv	a0,a5
 8be:	fef719e3          	bne	a4,a5,8b0 <malloc+0x8e>
 8c2:	8552                	mv	a0,s4
 8c4:	af3ff0ef          	jal	3b6 <sbrk>
 8c8:	fd551ce3          	bne	a0,s5,8a0 <malloc+0x7e>
 8cc:	4501                	li	a0,0
 8ce:	7902                	ld	s2,32(sp)
 8d0:	6a42                	ld	s4,16(sp)
 8d2:	6aa2                	ld	s5,8(sp)
 8d4:	6b02                	ld	s6,0(sp)
 8d6:	a03d                	j	904 <malloc+0xe2>
 8d8:	7902                	ld	s2,32(sp)
 8da:	6a42                	ld	s4,16(sp)
 8dc:	6aa2                	ld	s5,8(sp)
 8de:	6b02                	ld	s6,0(sp)
 8e0:	fae48de3          	beq	s1,a4,89a <malloc+0x78>
 8e4:	4137073b          	subw	a4,a4,s3
 8e8:	c798                	sw	a4,8(a5)
 8ea:	02071693          	slli	a3,a4,0x20
 8ee:	01c6d713          	srli	a4,a3,0x1c
 8f2:	97ba                	add	a5,a5,a4
 8f4:	0137a423          	sw	s3,8(a5)
 8f8:	00000717          	auipc	a4,0x0
 8fc:	70a73423          	sd	a0,1800(a4) # 1000 <freep>
 900:	01078513          	addi	a0,a5,16
 904:	70e2                	ld	ra,56(sp)
 906:	7442                	ld	s0,48(sp)
 908:	74a2                	ld	s1,40(sp)
 90a:	69e2                	ld	s3,24(sp)
 90c:	6121                	addi	sp,sp,64
 90e:	8082                	ret
 910:	7902                	ld	s2,32(sp)
 912:	6a42                	ld	s4,16(sp)
 914:	6aa2                	ld	s5,8(sp)
 916:	6b02                	ld	s6,0(sp)
 918:	b7f5                	j	904 <malloc+0xe2>
