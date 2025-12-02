
user/_cp:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	1c00                	addi	s0,sp,560
   e:	478d                	li	a5,3
  10:	02f50163          	beq	a0,a5,32 <main+0x32>
  14:	20913c23          	sd	s1,536(sp)
  18:	21213823          	sd	s2,528(sp)
  1c:	21313423          	sd	s3,520(sp)
  20:	00001517          	auipc	a0,0x1
  24:	93050513          	addi	a0,a0,-1744 # 950 <malloc+0x104>
  28:	770000ef          	jal	798 <printf>
  2c:	4501                	li	a0,0
  2e:	332000ef          	jal	360 <exit>
  32:	20913c23          	sd	s1,536(sp)
  36:	21213823          	sd	s2,528(sp)
  3a:	84ae                	mv	s1,a1
  3c:	4581                	li	a1,0
  3e:	6488                	ld	a0,8(s1)
  40:	360000ef          	jal	3a0 <open>
  44:	892a                	mv	s2,a0
  46:	04054d63          	bltz	a0,a0 <main+0xa0>
  4a:	21313423          	sd	s3,520(sp)
  4e:	20100593          	li	a1,513
  52:	6888                	ld	a0,16(s1)
  54:	34c000ef          	jal	3a0 <open>
  58:	89aa                	mv	s3,a0
  5a:	04054f63          	bltz	a0,b8 <main+0xb8>
  5e:	20000613          	li	a2,512
  62:	dd040593          	addi	a1,s0,-560
  66:	854a                	mv	a0,s2
  68:	310000ef          	jal	378 <read>
  6c:	84aa                	mv	s1,a0
  6e:	06a05263          	blez	a0,d2 <main+0xd2>
  72:	8626                	mv	a2,s1
  74:	dd040593          	addi	a1,s0,-560
  78:	854e                	mv	a0,s3
  7a:	306000ef          	jal	380 <write>
  7e:	fea480e3          	beq	s1,a0,5e <main+0x5e>
  82:	00001517          	auipc	a0,0x1
  86:	93e50513          	addi	a0,a0,-1730 # 9c0 <malloc+0x174>
  8a:	70e000ef          	jal	798 <printf>
  8e:	854a                	mv	a0,s2
  90:	2f8000ef          	jal	388 <close>
  94:	854e                	mv	a0,s3
  96:	2f2000ef          	jal	388 <close>
  9a:	4501                	li	a0,0
  9c:	2c4000ef          	jal	360 <exit>
  a0:	21313423          	sd	s3,520(sp)
  a4:	648c                	ld	a1,8(s1)
  a6:	00001517          	auipc	a0,0x1
  aa:	8d250513          	addi	a0,a0,-1838 # 978 <malloc+0x12c>
  ae:	6ea000ef          	jal	798 <printf>
  b2:	4501                	li	a0,0
  b4:	2ac000ef          	jal	360 <exit>
  b8:	688c                	ld	a1,16(s1)
  ba:	00001517          	auipc	a0,0x1
  be:	8de50513          	addi	a0,a0,-1826 # 998 <malloc+0x14c>
  c2:	6d6000ef          	jal	798 <printf>
  c6:	854a                	mv	a0,s2
  c8:	2c0000ef          	jal	388 <close>
  cc:	4501                	li	a0,0
  ce:	292000ef          	jal	360 <exit>
  d2:	00054b63          	bltz	a0,e8 <main+0xe8>
  d6:	854a                	mv	a0,s2
  d8:	2b0000ef          	jal	388 <close>
  dc:	854e                	mv	a0,s3
  de:	2aa000ef          	jal	388 <close>
  e2:	4501                	li	a0,0
  e4:	27c000ef          	jal	360 <exit>
  e8:	00001517          	auipc	a0,0x1
  ec:	8f050513          	addi	a0,a0,-1808 # 9d8 <malloc+0x18c>
  f0:	6a8000ef          	jal	798 <printf>
  f4:	b7cd                	j	d6 <main+0xd6>

00000000000000f6 <start>:
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  fe:	f03ff0ef          	jal	0 <main>
 102:	4501                	li	a0,0
 104:	25c000ef          	jal	360 <exit>

0000000000000108 <strcpy>:
 108:	1141                	addi	sp,sp,-16
 10a:	e422                	sd	s0,8(sp)
 10c:	0800                	addi	s0,sp,16
 10e:	87aa                	mv	a5,a0
 110:	0585                	addi	a1,a1,1
 112:	0785                	addi	a5,a5,1
 114:	fff5c703          	lbu	a4,-1(a1)
 118:	fee78fa3          	sb	a4,-1(a5)
 11c:	fb75                	bnez	a4,110 <strcpy+0x8>
 11e:	6422                	ld	s0,8(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret

0000000000000124 <strcmp>:
 124:	1141                	addi	sp,sp,-16
 126:	e422                	sd	s0,8(sp)
 128:	0800                	addi	s0,sp,16
 12a:	00054783          	lbu	a5,0(a0)
 12e:	cb91                	beqz	a5,142 <strcmp+0x1e>
 130:	0005c703          	lbu	a4,0(a1)
 134:	00f71763          	bne	a4,a5,142 <strcmp+0x1e>
 138:	0505                	addi	a0,a0,1
 13a:	0585                	addi	a1,a1,1
 13c:	00054783          	lbu	a5,0(a0)
 140:	fbe5                	bnez	a5,130 <strcmp+0xc>
 142:	0005c503          	lbu	a0,0(a1)
 146:	40a7853b          	subw	a0,a5,a0
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret

0000000000000150 <strlen>:
 150:	1141                	addi	sp,sp,-16
 152:	e422                	sd	s0,8(sp)
 154:	0800                	addi	s0,sp,16
 156:	00054783          	lbu	a5,0(a0)
 15a:	cf91                	beqz	a5,176 <strlen+0x26>
 15c:	0505                	addi	a0,a0,1
 15e:	87aa                	mv	a5,a0
 160:	86be                	mv	a3,a5
 162:	0785                	addi	a5,a5,1
 164:	fff7c703          	lbu	a4,-1(a5)
 168:	ff65                	bnez	a4,160 <strlen+0x10>
 16a:	40a6853b          	subw	a0,a3,a0
 16e:	2505                	addiw	a0,a0,1
 170:	6422                	ld	s0,8(sp)
 172:	0141                	addi	sp,sp,16
 174:	8082                	ret
 176:	4501                	li	a0,0
 178:	bfe5                	j	170 <strlen+0x20>

000000000000017a <memset>:
 17a:	1141                	addi	sp,sp,-16
 17c:	e422                	sd	s0,8(sp)
 17e:	0800                	addi	s0,sp,16
 180:	ca19                	beqz	a2,196 <memset+0x1c>
 182:	87aa                	mv	a5,a0
 184:	1602                	slli	a2,a2,0x20
 186:	9201                	srli	a2,a2,0x20
 188:	00a60733          	add	a4,a2,a0
 18c:	00b78023          	sb	a1,0(a5)
 190:	0785                	addi	a5,a5,1
 192:	fee79de3          	bne	a5,a4,18c <memset+0x12>
 196:	6422                	ld	s0,8(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret

000000000000019c <strchr>:
 19c:	1141                	addi	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	addi	s0,sp,16
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	cb99                	beqz	a5,1bc <strchr+0x20>
 1a8:	00f58763          	beq	a1,a5,1b6 <strchr+0x1a>
 1ac:	0505                	addi	a0,a0,1
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	fbfd                	bnez	a5,1a8 <strchr+0xc>
 1b4:	4501                	li	a0,0
 1b6:	6422                	ld	s0,8(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret
 1bc:	4501                	li	a0,0
 1be:	bfe5                	j	1b6 <strchr+0x1a>

00000000000001c0 <gets>:
 1c0:	711d                	addi	sp,sp,-96
 1c2:	ec86                	sd	ra,88(sp)
 1c4:	e8a2                	sd	s0,80(sp)
 1c6:	e4a6                	sd	s1,72(sp)
 1c8:	e0ca                	sd	s2,64(sp)
 1ca:	fc4e                	sd	s3,56(sp)
 1cc:	f852                	sd	s4,48(sp)
 1ce:	f456                	sd	s5,40(sp)
 1d0:	f05a                	sd	s6,32(sp)
 1d2:	ec5e                	sd	s7,24(sp)
 1d4:	1080                	addi	s0,sp,96
 1d6:	8baa                	mv	s7,a0
 1d8:	8a2e                	mv	s4,a1
 1da:	892a                	mv	s2,a0
 1dc:	4481                	li	s1,0
 1de:	4aa9                	li	s5,10
 1e0:	4b35                	li	s6,13
 1e2:	89a6                	mv	s3,s1
 1e4:	2485                	addiw	s1,s1,1
 1e6:	0344d663          	bge	s1,s4,212 <gets+0x52>
 1ea:	4605                	li	a2,1
 1ec:	faf40593          	addi	a1,s0,-81
 1f0:	4501                	li	a0,0
 1f2:	186000ef          	jal	378 <read>
 1f6:	00a05e63          	blez	a0,212 <gets+0x52>
 1fa:	faf44783          	lbu	a5,-81(s0)
 1fe:	00f90023          	sb	a5,0(s2)
 202:	01578763          	beq	a5,s5,210 <gets+0x50>
 206:	0905                	addi	s2,s2,1
 208:	fd679de3          	bne	a5,s6,1e2 <gets+0x22>
 20c:	89a6                	mv	s3,s1
 20e:	a011                	j	212 <gets+0x52>
 210:	89a6                	mv	s3,s1
 212:	99de                	add	s3,s3,s7
 214:	00098023          	sb	zero,0(s3)
 218:	855e                	mv	a0,s7
 21a:	60e6                	ld	ra,88(sp)
 21c:	6446                	ld	s0,80(sp)
 21e:	64a6                	ld	s1,72(sp)
 220:	6906                	ld	s2,64(sp)
 222:	79e2                	ld	s3,56(sp)
 224:	7a42                	ld	s4,48(sp)
 226:	7aa2                	ld	s5,40(sp)
 228:	7b02                	ld	s6,32(sp)
 22a:	6be2                	ld	s7,24(sp)
 22c:	6125                	addi	sp,sp,96
 22e:	8082                	ret

0000000000000230 <stat>:
 230:	1101                	addi	sp,sp,-32
 232:	ec06                	sd	ra,24(sp)
 234:	e822                	sd	s0,16(sp)
 236:	e04a                	sd	s2,0(sp)
 238:	1000                	addi	s0,sp,32
 23a:	892e                	mv	s2,a1
 23c:	4581                	li	a1,0
 23e:	162000ef          	jal	3a0 <open>
 242:	02054263          	bltz	a0,266 <stat+0x36>
 246:	e426                	sd	s1,8(sp)
 248:	84aa                	mv	s1,a0
 24a:	85ca                	mv	a1,s2
 24c:	16c000ef          	jal	3b8 <fstat>
 250:	892a                	mv	s2,a0
 252:	8526                	mv	a0,s1
 254:	134000ef          	jal	388 <close>
 258:	64a2                	ld	s1,8(sp)
 25a:	854a                	mv	a0,s2
 25c:	60e2                	ld	ra,24(sp)
 25e:	6442                	ld	s0,16(sp)
 260:	6902                	ld	s2,0(sp)
 262:	6105                	addi	sp,sp,32
 264:	8082                	ret
 266:	597d                	li	s2,-1
 268:	bfcd                	j	25a <stat+0x2a>

000000000000026a <atoi>:
 26a:	1141                	addi	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	addi	s0,sp,16
 270:	00054683          	lbu	a3,0(a0)
 274:	fd06879b          	addiw	a5,a3,-48
 278:	0ff7f793          	zext.b	a5,a5
 27c:	4625                	li	a2,9
 27e:	02f66863          	bltu	a2,a5,2ae <atoi+0x44>
 282:	872a                	mv	a4,a0
 284:	4501                	li	a0,0
 286:	0705                	addi	a4,a4,1
 288:	0025179b          	slliw	a5,a0,0x2
 28c:	9fa9                	addw	a5,a5,a0
 28e:	0017979b          	slliw	a5,a5,0x1
 292:	9fb5                	addw	a5,a5,a3
 294:	fd07851b          	addiw	a0,a5,-48
 298:	00074683          	lbu	a3,0(a4)
 29c:	fd06879b          	addiw	a5,a3,-48
 2a0:	0ff7f793          	zext.b	a5,a5
 2a4:	fef671e3          	bgeu	a2,a5,286 <atoi+0x1c>
 2a8:	6422                	ld	s0,8(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret
 2ae:	4501                	li	a0,0
 2b0:	bfe5                	j	2a8 <atoi+0x3e>

00000000000002b2 <memmove>:
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
 2b8:	02b57463          	bgeu	a0,a1,2e0 <memmove+0x2e>
 2bc:	00c05f63          	blez	a2,2da <memmove+0x28>
 2c0:	1602                	slli	a2,a2,0x20
 2c2:	9201                	srli	a2,a2,0x20
 2c4:	00c507b3          	add	a5,a0,a2
 2c8:	872a                	mv	a4,a0
 2ca:	0585                	addi	a1,a1,1
 2cc:	0705                	addi	a4,a4,1
 2ce:	fff5c683          	lbu	a3,-1(a1)
 2d2:	fed70fa3          	sb	a3,-1(a4)
 2d6:	fef71ae3          	bne	a4,a5,2ca <memmove+0x18>
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
 2e0:	00c50733          	add	a4,a0,a2
 2e4:	95b2                	add	a1,a1,a2
 2e6:	fec05ae3          	blez	a2,2da <memmove+0x28>
 2ea:	fff6079b          	addiw	a5,a2,-1
 2ee:	1782                	slli	a5,a5,0x20
 2f0:	9381                	srli	a5,a5,0x20
 2f2:	fff7c793          	not	a5,a5
 2f6:	97ba                	add	a5,a5,a4
 2f8:	15fd                	addi	a1,a1,-1
 2fa:	177d                	addi	a4,a4,-1
 2fc:	0005c683          	lbu	a3,0(a1)
 300:	00d70023          	sb	a3,0(a4)
 304:	fee79ae3          	bne	a5,a4,2f8 <memmove+0x46>
 308:	bfc9                	j	2da <memmove+0x28>

000000000000030a <memcmp>:
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
 310:	ca05                	beqz	a2,340 <memcmp+0x36>
 312:	fff6069b          	addiw	a3,a2,-1
 316:	1682                	slli	a3,a3,0x20
 318:	9281                	srli	a3,a3,0x20
 31a:	0685                	addi	a3,a3,1
 31c:	96aa                	add	a3,a3,a0
 31e:	00054783          	lbu	a5,0(a0)
 322:	0005c703          	lbu	a4,0(a1)
 326:	00e79863          	bne	a5,a4,336 <memcmp+0x2c>
 32a:	0505                	addi	a0,a0,1
 32c:	0585                	addi	a1,a1,1
 32e:	fed518e3          	bne	a0,a3,31e <memcmp+0x14>
 332:	4501                	li	a0,0
 334:	a019                	j	33a <memcmp+0x30>
 336:	40e7853b          	subw	a0,a5,a4
 33a:	6422                	ld	s0,8(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret
 340:	4501                	li	a0,0
 342:	bfe5                	j	33a <memcmp+0x30>

0000000000000344 <memcpy>:
 344:	1141                	addi	sp,sp,-16
 346:	e406                	sd	ra,8(sp)
 348:	e022                	sd	s0,0(sp)
 34a:	0800                	addi	s0,sp,16
 34c:	f67ff0ef          	jal	2b2 <memmove>
 350:	60a2                	ld	ra,8(sp)
 352:	6402                	ld	s0,0(sp)
 354:	0141                	addi	sp,sp,16
 356:	8082                	ret

0000000000000358 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 358:	4885                	li	a7,1
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <exit>:
.global exit
exit:
 li a7, SYS_exit
 360:	4889                	li	a7,2
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <wait>:
.global wait
wait:
 li a7, SYS_wait
 368:	488d                	li	a7,3
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 370:	4891                	li	a7,4
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <read>:
.global read
read:
 li a7, SYS_read
 378:	4895                	li	a7,5
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <write>:
.global write
write:
 li a7, SYS_write
 380:	48c1                	li	a7,16
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <close>:
.global close
close:
 li a7, SYS_close
 388:	48d5                	li	a7,21
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <kill>:
.global kill
kill:
 li a7, SYS_kill
 390:	4899                	li	a7,6
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <exec>:
.global exec
exec:
 li a7, SYS_exec
 398:	489d                	li	a7,7
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <open>:
.global open
open:
 li a7, SYS_open
 3a0:	48bd                	li	a7,15
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3a8:	48c5                	li	a7,17
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3b0:	48c9                	li	a7,18
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3b8:	48a1                	li	a7,8
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <link>:
.global link
link:
 li a7, SYS_link
 3c0:	48cd                	li	a7,19
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3c8:	48d1                	li	a7,20
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3d0:	48a5                	li	a7,9
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3d8:	48a9                	li	a7,10
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3e0:	48ad                	li	a7,11
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3e8:	48b1                	li	a7,12
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3f0:	48b5                	li	a7,13
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3f8:	48b9                	li	a7,14
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 400:	48d9                	li	a7,22
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 408:	48dd                	li	a7,23
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 410:	48e1                	li	a7,24
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 418:	48e5                	li	a7,25
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 420:	1101                	addi	sp,sp,-32
 422:	ec06                	sd	ra,24(sp)
 424:	e822                	sd	s0,16(sp)
 426:	1000                	addi	s0,sp,32
 428:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 42c:	4605                	li	a2,1
 42e:	fef40593          	addi	a1,s0,-17
 432:	f4fff0ef          	jal	380 <write>
}
 436:	60e2                	ld	ra,24(sp)
 438:	6442                	ld	s0,16(sp)
 43a:	6105                	addi	sp,sp,32
 43c:	8082                	ret

000000000000043e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43e:	7139                	addi	sp,sp,-64
 440:	fc06                	sd	ra,56(sp)
 442:	f822                	sd	s0,48(sp)
 444:	f426                	sd	s1,40(sp)
 446:	0080                	addi	s0,sp,64
 448:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44a:	c299                	beqz	a3,450 <printint+0x12>
 44c:	0805c963          	bltz	a1,4de <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 450:	2581                	sext.w	a1,a1
  neg = 0;
 452:	4881                	li	a7,0
 454:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 458:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 45a:	2601                	sext.w	a2,a2
 45c:	00000517          	auipc	a0,0x0
 460:	59450513          	addi	a0,a0,1428 # 9f0 <digits>
 464:	883a                	mv	a6,a4
 466:	2705                	addiw	a4,a4,1
 468:	02c5f7bb          	remuw	a5,a1,a2
 46c:	1782                	slli	a5,a5,0x20
 46e:	9381                	srli	a5,a5,0x20
 470:	97aa                	add	a5,a5,a0
 472:	0007c783          	lbu	a5,0(a5)
 476:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 47a:	0005879b          	sext.w	a5,a1
 47e:	02c5d5bb          	divuw	a1,a1,a2
 482:	0685                	addi	a3,a3,1
 484:	fec7f0e3          	bgeu	a5,a2,464 <printint+0x26>
  if(neg)
 488:	00088c63          	beqz	a7,4a0 <printint+0x62>
    buf[i++] = '-';
 48c:	fd070793          	addi	a5,a4,-48
 490:	00878733          	add	a4,a5,s0
 494:	02d00793          	li	a5,45
 498:	fef70823          	sb	a5,-16(a4)
 49c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4a0:	02e05a63          	blez	a4,4d4 <printint+0x96>
 4a4:	f04a                	sd	s2,32(sp)
 4a6:	ec4e                	sd	s3,24(sp)
 4a8:	fc040793          	addi	a5,s0,-64
 4ac:	00e78933          	add	s2,a5,a4
 4b0:	fff78993          	addi	s3,a5,-1
 4b4:	99ba                	add	s3,s3,a4
 4b6:	377d                	addiw	a4,a4,-1
 4b8:	1702                	slli	a4,a4,0x20
 4ba:	9301                	srli	a4,a4,0x20
 4bc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4c0:	fff94583          	lbu	a1,-1(s2)
 4c4:	8526                	mv	a0,s1
 4c6:	f5bff0ef          	jal	420 <putc>
  while(--i >= 0)
 4ca:	197d                	addi	s2,s2,-1
 4cc:	ff391ae3          	bne	s2,s3,4c0 <printint+0x82>
 4d0:	7902                	ld	s2,32(sp)
 4d2:	69e2                	ld	s3,24(sp)
}
 4d4:	70e2                	ld	ra,56(sp)
 4d6:	7442                	ld	s0,48(sp)
 4d8:	74a2                	ld	s1,40(sp)
 4da:	6121                	addi	sp,sp,64
 4dc:	8082                	ret
    x = -xx;
 4de:	40b005bb          	negw	a1,a1
    neg = 1;
 4e2:	4885                	li	a7,1
    x = -xx;
 4e4:	bf85                	j	454 <printint+0x16>

00000000000004e6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e6:	711d                	addi	sp,sp,-96
 4e8:	ec86                	sd	ra,88(sp)
 4ea:	e8a2                	sd	s0,80(sp)
 4ec:	e0ca                	sd	s2,64(sp)
 4ee:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f0:	0005c903          	lbu	s2,0(a1)
 4f4:	26090863          	beqz	s2,764 <vprintf+0x27e>
 4f8:	e4a6                	sd	s1,72(sp)
 4fa:	fc4e                	sd	s3,56(sp)
 4fc:	f852                	sd	s4,48(sp)
 4fe:	f456                	sd	s5,40(sp)
 500:	f05a                	sd	s6,32(sp)
 502:	ec5e                	sd	s7,24(sp)
 504:	e862                	sd	s8,16(sp)
 506:	e466                	sd	s9,8(sp)
 508:	8b2a                	mv	s6,a0
 50a:	8a2e                	mv	s4,a1
 50c:	8bb2                	mv	s7,a2
  state = 0;
 50e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 510:	4481                	li	s1,0
 512:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 514:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 518:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 51c:	06c00c93          	li	s9,108
 520:	a005                	j	540 <vprintf+0x5a>
        putc(fd, c0);
 522:	85ca                	mv	a1,s2
 524:	855a                	mv	a0,s6
 526:	efbff0ef          	jal	420 <putc>
 52a:	a019                	j	530 <vprintf+0x4a>
    } else if(state == '%'){
 52c:	03598263          	beq	s3,s5,550 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 530:	2485                	addiw	s1,s1,1
 532:	8726                	mv	a4,s1
 534:	009a07b3          	add	a5,s4,s1
 538:	0007c903          	lbu	s2,0(a5)
 53c:	20090c63          	beqz	s2,754 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 540:	0009079b          	sext.w	a5,s2
    if(state == 0){
 544:	fe0994e3          	bnez	s3,52c <vprintf+0x46>
      if(c0 == '%'){
 548:	fd579de3          	bne	a5,s5,522 <vprintf+0x3c>
        state = '%';
 54c:	89be                	mv	s3,a5
 54e:	b7cd                	j	530 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 550:	00ea06b3          	add	a3,s4,a4
 554:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 558:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 55a:	c681                	beqz	a3,562 <vprintf+0x7c>
 55c:	9752                	add	a4,a4,s4
 55e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 562:	03878f63          	beq	a5,s8,5a0 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 566:	05978963          	beq	a5,s9,5b8 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 56a:	07500713          	li	a4,117
 56e:	0ee78363          	beq	a5,a4,654 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 572:	07800713          	li	a4,120
 576:	12e78563          	beq	a5,a4,6a0 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 57a:	07000713          	li	a4,112
 57e:	14e78a63          	beq	a5,a4,6d2 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 582:	07300713          	li	a4,115
 586:	18e78a63          	beq	a5,a4,71a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 58a:	02500713          	li	a4,37
 58e:	04e79563          	bne	a5,a4,5d8 <vprintf+0xf2>
        putc(fd, '%');
 592:	02500593          	li	a1,37
 596:	855a                	mv	a0,s6
 598:	e89ff0ef          	jal	420 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 59c:	4981                	li	s3,0
 59e:	bf49                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5a0:	008b8913          	addi	s2,s7,8
 5a4:	4685                	li	a3,1
 5a6:	4629                	li	a2,10
 5a8:	000ba583          	lw	a1,0(s7)
 5ac:	855a                	mv	a0,s6
 5ae:	e91ff0ef          	jal	43e <printint>
 5b2:	8bca                	mv	s7,s2
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	bfad                	j	530 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5b8:	06400793          	li	a5,100
 5bc:	02f68963          	beq	a3,a5,5ee <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5c0:	06c00793          	li	a5,108
 5c4:	04f68263          	beq	a3,a5,608 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5c8:	07500793          	li	a5,117
 5cc:	0af68063          	beq	a3,a5,66c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5d0:	07800793          	li	a5,120
 5d4:	0ef68263          	beq	a3,a5,6b8 <vprintf+0x1d2>
        putc(fd, '%');
 5d8:	02500593          	li	a1,37
 5dc:	855a                	mv	a0,s6
 5de:	e43ff0ef          	jal	420 <putc>
        putc(fd, c0);
 5e2:	85ca                	mv	a1,s2
 5e4:	855a                	mv	a0,s6
 5e6:	e3bff0ef          	jal	420 <putc>
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	b791                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ee:	008b8913          	addi	s2,s7,8
 5f2:	4685                	li	a3,1
 5f4:	4629                	li	a2,10
 5f6:	000ba583          	lw	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	e43ff0ef          	jal	43e <printint>
        i += 1;
 600:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 602:	8bca                	mv	s7,s2
      state = 0;
 604:	4981                	li	s3,0
        i += 1;
 606:	b72d                	j	530 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 608:	06400793          	li	a5,100
 60c:	02f60763          	beq	a2,a5,63a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 610:	07500793          	li	a5,117
 614:	06f60963          	beq	a2,a5,686 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 618:	07800793          	li	a5,120
 61c:	faf61ee3          	bne	a2,a5,5d8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 620:	008b8913          	addi	s2,s7,8
 624:	4681                	li	a3,0
 626:	4641                	li	a2,16
 628:	000ba583          	lw	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	e11ff0ef          	jal	43e <printint>
        i += 2;
 632:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 634:	8bca                	mv	s7,s2
      state = 0;
 636:	4981                	li	s3,0
        i += 2;
 638:	bde5                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 63a:	008b8913          	addi	s2,s7,8
 63e:	4685                	li	a3,1
 640:	4629                	li	a2,10
 642:	000ba583          	lw	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	df7ff0ef          	jal	43e <printint>
        i += 2;
 64c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 64e:	8bca                	mv	s7,s2
      state = 0;
 650:	4981                	li	s3,0
        i += 2;
 652:	bdf9                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 654:	008b8913          	addi	s2,s7,8
 658:	4681                	li	a3,0
 65a:	4629                	li	a2,10
 65c:	000ba583          	lw	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	dddff0ef          	jal	43e <printint>
 666:	8bca                	mv	s7,s2
      state = 0;
 668:	4981                	li	s3,0
 66a:	b5d9                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 66c:	008b8913          	addi	s2,s7,8
 670:	4681                	li	a3,0
 672:	4629                	li	a2,10
 674:	000ba583          	lw	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	dc5ff0ef          	jal	43e <printint>
        i += 1;
 67e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 680:	8bca                	mv	s7,s2
      state = 0;
 682:	4981                	li	s3,0
        i += 1;
 684:	b575                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 686:	008b8913          	addi	s2,s7,8
 68a:	4681                	li	a3,0
 68c:	4629                	li	a2,10
 68e:	000ba583          	lw	a1,0(s7)
 692:	855a                	mv	a0,s6
 694:	dabff0ef          	jal	43e <printint>
        i += 2;
 698:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 69a:	8bca                	mv	s7,s2
      state = 0;
 69c:	4981                	li	s3,0
        i += 2;
 69e:	bd49                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6a0:	008b8913          	addi	s2,s7,8
 6a4:	4681                	li	a3,0
 6a6:	4641                	li	a2,16
 6a8:	000ba583          	lw	a1,0(s7)
 6ac:	855a                	mv	a0,s6
 6ae:	d91ff0ef          	jal	43e <printint>
 6b2:	8bca                	mv	s7,s2
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	bdad                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b8:	008b8913          	addi	s2,s7,8
 6bc:	4681                	li	a3,0
 6be:	4641                	li	a2,16
 6c0:	000ba583          	lw	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	d79ff0ef          	jal	43e <printint>
        i += 1;
 6ca:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6cc:	8bca                	mv	s7,s2
      state = 0;
 6ce:	4981                	li	s3,0
        i += 1;
 6d0:	b585                	j	530 <vprintf+0x4a>
 6d2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6d4:	008b8d13          	addi	s10,s7,8
 6d8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6dc:	03000593          	li	a1,48
 6e0:	855a                	mv	a0,s6
 6e2:	d3fff0ef          	jal	420 <putc>
  putc(fd, 'x');
 6e6:	07800593          	li	a1,120
 6ea:	855a                	mv	a0,s6
 6ec:	d35ff0ef          	jal	420 <putc>
 6f0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f2:	00000b97          	auipc	s7,0x0
 6f6:	2feb8b93          	addi	s7,s7,766 # 9f0 <digits>
 6fa:	03c9d793          	srli	a5,s3,0x3c
 6fe:	97de                	add	a5,a5,s7
 700:	0007c583          	lbu	a1,0(a5)
 704:	855a                	mv	a0,s6
 706:	d1bff0ef          	jal	420 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 70a:	0992                	slli	s3,s3,0x4
 70c:	397d                	addiw	s2,s2,-1
 70e:	fe0916e3          	bnez	s2,6fa <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 712:	8bea                	mv	s7,s10
      state = 0;
 714:	4981                	li	s3,0
 716:	6d02                	ld	s10,0(sp)
 718:	bd21                	j	530 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 71a:	008b8993          	addi	s3,s7,8
 71e:	000bb903          	ld	s2,0(s7)
 722:	00090f63          	beqz	s2,740 <vprintf+0x25a>
        for(; *s; s++)
 726:	00094583          	lbu	a1,0(s2)
 72a:	c195                	beqz	a1,74e <vprintf+0x268>
          putc(fd, *s);
 72c:	855a                	mv	a0,s6
 72e:	cf3ff0ef          	jal	420 <putc>
        for(; *s; s++)
 732:	0905                	addi	s2,s2,1
 734:	00094583          	lbu	a1,0(s2)
 738:	f9f5                	bnez	a1,72c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 73a:	8bce                	mv	s7,s3
      state = 0;
 73c:	4981                	li	s3,0
 73e:	bbcd                	j	530 <vprintf+0x4a>
          s = "(null)";
 740:	00000917          	auipc	s2,0x0
 744:	2a890913          	addi	s2,s2,680 # 9e8 <malloc+0x19c>
        for(; *s; s++)
 748:	02800593          	li	a1,40
 74c:	b7c5                	j	72c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 74e:	8bce                	mv	s7,s3
      state = 0;
 750:	4981                	li	s3,0
 752:	bbf9                	j	530 <vprintf+0x4a>
 754:	64a6                	ld	s1,72(sp)
 756:	79e2                	ld	s3,56(sp)
 758:	7a42                	ld	s4,48(sp)
 75a:	7aa2                	ld	s5,40(sp)
 75c:	7b02                	ld	s6,32(sp)
 75e:	6be2                	ld	s7,24(sp)
 760:	6c42                	ld	s8,16(sp)
 762:	6ca2                	ld	s9,8(sp)
    }
  }
}
 764:	60e6                	ld	ra,88(sp)
 766:	6446                	ld	s0,80(sp)
 768:	6906                	ld	s2,64(sp)
 76a:	6125                	addi	sp,sp,96
 76c:	8082                	ret

000000000000076e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 76e:	715d                	addi	sp,sp,-80
 770:	ec06                	sd	ra,24(sp)
 772:	e822                	sd	s0,16(sp)
 774:	1000                	addi	s0,sp,32
 776:	e010                	sd	a2,0(s0)
 778:	e414                	sd	a3,8(s0)
 77a:	e818                	sd	a4,16(s0)
 77c:	ec1c                	sd	a5,24(s0)
 77e:	03043023          	sd	a6,32(s0)
 782:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 786:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 78a:	8622                	mv	a2,s0
 78c:	d5bff0ef          	jal	4e6 <vprintf>
}
 790:	60e2                	ld	ra,24(sp)
 792:	6442                	ld	s0,16(sp)
 794:	6161                	addi	sp,sp,80
 796:	8082                	ret

0000000000000798 <printf>:

void
printf(const char *fmt, ...)
{
 798:	711d                	addi	sp,sp,-96
 79a:	ec06                	sd	ra,24(sp)
 79c:	e822                	sd	s0,16(sp)
 79e:	1000                	addi	s0,sp,32
 7a0:	e40c                	sd	a1,8(s0)
 7a2:	e810                	sd	a2,16(s0)
 7a4:	ec14                	sd	a3,24(s0)
 7a6:	f018                	sd	a4,32(s0)
 7a8:	f41c                	sd	a5,40(s0)
 7aa:	03043823          	sd	a6,48(s0)
 7ae:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7b2:	00840613          	addi	a2,s0,8
 7b6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ba:	85aa                	mv	a1,a0
 7bc:	4505                	li	a0,1
 7be:	d29ff0ef          	jal	4e6 <vprintf>
}
 7c2:	60e2                	ld	ra,24(sp)
 7c4:	6442                	ld	s0,16(sp)
 7c6:	6125                	addi	sp,sp,96
 7c8:	8082                	ret

00000000000007ca <free>:
 7ca:	1141                	addi	sp,sp,-16
 7cc:	e422                	sd	s0,8(sp)
 7ce:	0800                	addi	s0,sp,16
 7d0:	ff050693          	addi	a3,a0,-16
 7d4:	00001797          	auipc	a5,0x1
 7d8:	82c7b783          	ld	a5,-2004(a5) # 1000 <freep>
 7dc:	a02d                	j	806 <free+0x3c>
 7de:	4618                	lw	a4,8(a2)
 7e0:	9f2d                	addw	a4,a4,a1
 7e2:	fee52c23          	sw	a4,-8(a0)
 7e6:	6398                	ld	a4,0(a5)
 7e8:	6310                	ld	a2,0(a4)
 7ea:	a83d                	j	828 <free+0x5e>
 7ec:	ff852703          	lw	a4,-8(a0)
 7f0:	9f31                	addw	a4,a4,a2
 7f2:	c798                	sw	a4,8(a5)
 7f4:	ff053683          	ld	a3,-16(a0)
 7f8:	a091                	j	83c <free+0x72>
 7fa:	6398                	ld	a4,0(a5)
 7fc:	00e7e463          	bltu	a5,a4,804 <free+0x3a>
 800:	00e6ea63          	bltu	a3,a4,814 <free+0x4a>
 804:	87ba                	mv	a5,a4
 806:	fed7fae3          	bgeu	a5,a3,7fa <free+0x30>
 80a:	6398                	ld	a4,0(a5)
 80c:	00e6e463          	bltu	a3,a4,814 <free+0x4a>
 810:	fee7eae3          	bltu	a5,a4,804 <free+0x3a>
 814:	ff852583          	lw	a1,-8(a0)
 818:	6390                	ld	a2,0(a5)
 81a:	02059813          	slli	a6,a1,0x20
 81e:	01c85713          	srli	a4,a6,0x1c
 822:	9736                	add	a4,a4,a3
 824:	fae60de3          	beq	a2,a4,7de <free+0x14>
 828:	fec53823          	sd	a2,-16(a0)
 82c:	4790                	lw	a2,8(a5)
 82e:	02061593          	slli	a1,a2,0x20
 832:	01c5d713          	srli	a4,a1,0x1c
 836:	973e                	add	a4,a4,a5
 838:	fae68ae3          	beq	a3,a4,7ec <free+0x22>
 83c:	e394                	sd	a3,0(a5)
 83e:	00000717          	auipc	a4,0x0
 842:	7cf73123          	sd	a5,1986(a4) # 1000 <freep>
 846:	6422                	ld	s0,8(sp)
 848:	0141                	addi	sp,sp,16
 84a:	8082                	ret

000000000000084c <malloc>:
 84c:	7139                	addi	sp,sp,-64
 84e:	fc06                	sd	ra,56(sp)
 850:	f822                	sd	s0,48(sp)
 852:	f426                	sd	s1,40(sp)
 854:	ec4e                	sd	s3,24(sp)
 856:	0080                	addi	s0,sp,64
 858:	02051493          	slli	s1,a0,0x20
 85c:	9081                	srli	s1,s1,0x20
 85e:	04bd                	addi	s1,s1,15
 860:	8091                	srli	s1,s1,0x4
 862:	0014899b          	addiw	s3,s1,1
 866:	0485                	addi	s1,s1,1
 868:	00000517          	auipc	a0,0x0
 86c:	79853503          	ld	a0,1944(a0) # 1000 <freep>
 870:	c915                	beqz	a0,8a4 <malloc+0x58>
 872:	611c                	ld	a5,0(a0)
 874:	4798                	lw	a4,8(a5)
 876:	08977a63          	bgeu	a4,s1,90a <malloc+0xbe>
 87a:	f04a                	sd	s2,32(sp)
 87c:	e852                	sd	s4,16(sp)
 87e:	e456                	sd	s5,8(sp)
 880:	e05a                	sd	s6,0(sp)
 882:	8a4e                	mv	s4,s3
 884:	0009871b          	sext.w	a4,s3
 888:	6685                	lui	a3,0x1
 88a:	00d77363          	bgeu	a4,a3,890 <malloc+0x44>
 88e:	6a05                	lui	s4,0x1
 890:	000a0b1b          	sext.w	s6,s4
 894:	004a1a1b          	slliw	s4,s4,0x4
 898:	00000917          	auipc	s2,0x0
 89c:	76890913          	addi	s2,s2,1896 # 1000 <freep>
 8a0:	5afd                	li	s5,-1
 8a2:	a081                	j	8e2 <malloc+0x96>
 8a4:	f04a                	sd	s2,32(sp)
 8a6:	e852                	sd	s4,16(sp)
 8a8:	e456                	sd	s5,8(sp)
 8aa:	e05a                	sd	s6,0(sp)
 8ac:	00000797          	auipc	a5,0x0
 8b0:	76478793          	addi	a5,a5,1892 # 1010 <base>
 8b4:	00000717          	auipc	a4,0x0
 8b8:	74f73623          	sd	a5,1868(a4) # 1000 <freep>
 8bc:	e39c                	sd	a5,0(a5)
 8be:	0007a423          	sw	zero,8(a5)
 8c2:	b7c1                	j	882 <malloc+0x36>
 8c4:	6398                	ld	a4,0(a5)
 8c6:	e118                	sd	a4,0(a0)
 8c8:	a8a9                	j	922 <malloc+0xd6>
 8ca:	01652423          	sw	s6,8(a0)
 8ce:	0541                	addi	a0,a0,16
 8d0:	efbff0ef          	jal	7ca <free>
 8d4:	00093503          	ld	a0,0(s2)
 8d8:	c12d                	beqz	a0,93a <malloc+0xee>
 8da:	611c                	ld	a5,0(a0)
 8dc:	4798                	lw	a4,8(a5)
 8de:	02977263          	bgeu	a4,s1,902 <malloc+0xb6>
 8e2:	00093703          	ld	a4,0(s2)
 8e6:	853e                	mv	a0,a5
 8e8:	fef719e3          	bne	a4,a5,8da <malloc+0x8e>
 8ec:	8552                	mv	a0,s4
 8ee:	afbff0ef          	jal	3e8 <sbrk>
 8f2:	fd551ce3          	bne	a0,s5,8ca <malloc+0x7e>
 8f6:	4501                	li	a0,0
 8f8:	7902                	ld	s2,32(sp)
 8fa:	6a42                	ld	s4,16(sp)
 8fc:	6aa2                	ld	s5,8(sp)
 8fe:	6b02                	ld	s6,0(sp)
 900:	a03d                	j	92e <malloc+0xe2>
 902:	7902                	ld	s2,32(sp)
 904:	6a42                	ld	s4,16(sp)
 906:	6aa2                	ld	s5,8(sp)
 908:	6b02                	ld	s6,0(sp)
 90a:	fae48de3          	beq	s1,a4,8c4 <malloc+0x78>
 90e:	4137073b          	subw	a4,a4,s3
 912:	c798                	sw	a4,8(a5)
 914:	02071693          	slli	a3,a4,0x20
 918:	01c6d713          	srli	a4,a3,0x1c
 91c:	97ba                	add	a5,a5,a4
 91e:	0137a423          	sw	s3,8(a5)
 922:	00000717          	auipc	a4,0x0
 926:	6ca73f23          	sd	a0,1758(a4) # 1000 <freep>
 92a:	01078513          	addi	a0,a5,16
 92e:	70e2                	ld	ra,56(sp)
 930:	7442                	ld	s0,48(sp)
 932:	74a2                	ld	s1,40(sp)
 934:	69e2                	ld	s3,24(sp)
 936:	6121                	addi	sp,sp,64
 938:	8082                	ret
 93a:	7902                	ld	s2,32(sp)
 93c:	6a42                	ld	s4,16(sp)
 93e:	6aa2                	ld	s5,8(sp)
 940:	6b02                	ld	s6,0(sp)
 942:	b7f5                	j	92e <malloc+0xe2>
