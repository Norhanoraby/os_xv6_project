
user/_tail:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	0480                	addi	s0,sp,576
   e:	ffe5071b          	addiw	a4,a0,-2
  12:	4789                	li	a5,2
  14:	08e7e163          	bltu	a5,a4,96 <main+0x96>
  18:	22913423          	sd	s1,552(sp)
  1c:	23213023          	sd	s2,544(sp)
  20:	21513423          	sd	s5,520(sp)
  24:	84ae                	mv	s1,a1
  26:	0085b903          	ld	s2,8(a1)
  2a:	4791                	li	a5,4
  2c:	08f50a63          	beq	a0,a5,c0 <main+0xc0>
  30:	478d                	li	a5,3
  32:	4aa9                	li	s5,10
  34:	0ef50363          	beq	a0,a5,11a <main+0x11a>
  38:	21413823          	sd	s4,528(sp)
  3c:	4581                	li	a1,0
  3e:	854a                	mv	a0,s2
  40:	47e000ef          	jal	4be <open>
  44:	8a2a                	mv	s4,a0
  46:	0e054963          	bltz	a0,138 <main+0x138>
  4a:	21313c23          	sd	s3,536(sp)
  4e:	6509                	lui	a0,0x2
  50:	71050513          	addi	a0,a0,1808 # 2710 <base+0x1700>
  54:	11f000ef          	jal	972 <malloc>
  58:	89aa                	mv	s3,a0
  5a:	4481                	li	s1,0
  5c:	0e050c63          	beqz	a0,154 <main+0x154>
  60:	21613023          	sd	s6,512(sp)
  64:	6b09                	lui	s6,0x2
  66:	710b0b13          	addi	s6,s6,1808 # 2710 <base+0x1700>
  6a:	20000613          	li	a2,512
  6e:	dc040593          	addi	a1,s0,-576
  72:	8552                	mv	a0,s4
  74:	422000ef          	jal	496 <read>
  78:	862a                	mv	a2,a0
  7a:	10a05a63          	blez	a0,18e <main+0x18e>
  7e:	00c4893b          	addw	s2,s1,a2
  82:	0f2b4763          	blt	s6,s2,170 <main+0x170>
  86:	dc040593          	addi	a1,s0,-576
  8a:	00998533          	add	a0,s3,s1
  8e:	342000ef          	jal	3d0 <memmove>
  92:	84ca                	mv	s1,s2
  94:	bfd9                	j	6a <main+0x6a>
  96:	22913423          	sd	s1,552(sp)
  9a:	23213023          	sd	s2,544(sp)
  9e:	21313c23          	sd	s3,536(sp)
  a2:	21413823          	sd	s4,528(sp)
  a6:	21513423          	sd	s5,520(sp)
  aa:	21613023          	sd	s6,512(sp)
  ae:	00001517          	auipc	a0,0x1
  b2:	9c250513          	addi	a0,a0,-1598 # a70 <malloc+0xfe>
  b6:	009000ef          	jal	8be <printf>
  ba:	4501                	li	a0,0
  bc:	3c2000ef          	jal	47e <exit>
  c0:	00001597          	auipc	a1,0x1
  c4:	9d858593          	addi	a1,a1,-1576 # a98 <malloc+0x126>
  c8:	6888                	ld	a0,16(s1)
  ca:	178000ef          	jal	242 <strcmp>
  ce:	c105                	beqz	a0,ee <main+0xee>
  d0:	21313c23          	sd	s3,536(sp)
  d4:	21413823          	sd	s4,528(sp)
  d8:	21613023          	sd	s6,512(sp)
  dc:	00001517          	auipc	a0,0x1
  e0:	99450513          	addi	a0,a0,-1644 # a70 <malloc+0xfe>
  e4:	7da000ef          	jal	8be <printf>
  e8:	4501                	li	a0,0
  ea:	394000ef          	jal	47e <exit>
  ee:	6c88                	ld	a0,24(s1)
  f0:	298000ef          	jal	388 <atoi>
  f4:	8aaa                	mv	s5,a0
  f6:	f4a041e3          	bgtz	a0,38 <main+0x38>
  fa:	21313c23          	sd	s3,536(sp)
  fe:	21413823          	sd	s4,528(sp)
 102:	21613023          	sd	s6,512(sp)
 106:	6c8c                	ld	a1,24(s1)
 108:	00001517          	auipc	a0,0x1
 10c:	99850513          	addi	a0,a0,-1640 # aa0 <malloc+0x12e>
 110:	7ae000ef          	jal	8be <printf>
 114:	4501                	li	a0,0
 116:	368000ef          	jal	47e <exit>
 11a:	21313c23          	sd	s3,536(sp)
 11e:	21413823          	sd	s4,528(sp)
 122:	21613023          	sd	s6,512(sp)
 126:	00001517          	auipc	a0,0x1
 12a:	94a50513          	addi	a0,a0,-1718 # a70 <malloc+0xfe>
 12e:	790000ef          	jal	8be <printf>
 132:	4501                	li	a0,0
 134:	34a000ef          	jal	47e <exit>
 138:	21313c23          	sd	s3,536(sp)
 13c:	21613023          	sd	s6,512(sp)
 140:	85ca                	mv	a1,s2
 142:	00001517          	auipc	a0,0x1
 146:	98650513          	addi	a0,a0,-1658 # ac8 <malloc+0x156>
 14a:	774000ef          	jal	8be <printf>
 14e:	4501                	li	a0,0
 150:	32e000ef          	jal	47e <exit>
 154:	21613023          	sd	s6,512(sp)
 158:	00001517          	auipc	a0,0x1
 15c:	98850513          	addi	a0,a0,-1656 # ae0 <malloc+0x16e>
 160:	75e000ef          	jal	8be <printf>
 164:	8552                	mv	a0,s4
 166:	340000ef          	jal	4a6 <close>
 16a:	4501                	li	a0,0
 16c:	312000ef          	jal	47e <exit>
 170:	00001517          	auipc	a0,0x1
 174:	98850513          	addi	a0,a0,-1656 # af8 <malloc+0x186>
 178:	746000ef          	jal	8be <printf>
 17c:	854e                	mv	a0,s3
 17e:	772000ef          	jal	8f0 <free>
 182:	8552                	mv	a0,s4
 184:	322000ef          	jal	4a6 <close>
 188:	4501                	li	a0,0
 18a:	2f4000ef          	jal	47e <exit>
 18e:	8552                	mv	a0,s4
 190:	316000ef          	jal	4a6 <close>
 194:	fff4861b          	addiw	a2,s1,-1
 198:	06064163          	bltz	a2,1fa <main+0x1fa>
 19c:	4701                	li	a4,0
 19e:	46a9                	li	a3,10
 1a0:	a801                	j	1b0 <main+0x1b0>
 1a2:	01570f63          	beq	a4,s5,1c0 <main+0x1c0>
 1a6:	167d                	addi	a2,a2,-1
 1a8:	02061793          	slli	a5,a2,0x20
 1ac:	0407ce63          	bltz	a5,208 <main+0x208>
 1b0:	00c987b3          	add	a5,s3,a2
 1b4:	0007c783          	lbu	a5,0(a5)
 1b8:	fed795e3          	bne	a5,a3,1a2 <main+0x1a2>
 1bc:	2705                	addiw	a4,a4,1
 1be:	b7d5                	j	1a2 <main+0x1a2>
 1c0:	2605                	addiw	a2,a2,1
 1c2:	0006059b          	sext.w	a1,a2
 1c6:	40c4863b          	subw	a2,s1,a2
 1ca:	95ce                	add	a1,a1,s3
 1cc:	4505                	li	a0,1
 1ce:	2d0000ef          	jal	49e <write>
 1d2:	94ce                	add	s1,s1,s3
 1d4:	fff4c703          	lbu	a4,-1(s1)
 1d8:	47a9                	li	a5,10
 1da:	00f70a63          	beq	a4,a5,1ee <main+0x1ee>
 1de:	4605                	li	a2,1
 1e0:	00001597          	auipc	a1,0x1
 1e4:	93058593          	addi	a1,a1,-1744 # b10 <malloc+0x19e>
 1e8:	4505                	li	a0,1
 1ea:	2b4000ef          	jal	49e <write>
 1ee:	854e                	mv	a0,s3
 1f0:	700000ef          	jal	8f0 <free>
 1f4:	4501                	li	a0,0
 1f6:	288000ef          	jal	47e <exit>
 1fa:	8626                	mv	a2,s1
 1fc:	85ce                	mv	a1,s3
 1fe:	4505                	li	a0,1
 200:	29e000ef          	jal	49e <write>
 204:	dce9                	beqz	s1,1de <main+0x1de>
 206:	b7f1                	j	1d2 <main+0x1d2>
 208:	8626                	mv	a2,s1
 20a:	85ce                	mv	a1,s3
 20c:	4505                	li	a0,1
 20e:	290000ef          	jal	49e <write>
 212:	b7c1                	j	1d2 <main+0x1d2>

0000000000000214 <start>:
 214:	1141                	addi	sp,sp,-16
 216:	e406                	sd	ra,8(sp)
 218:	e022                	sd	s0,0(sp)
 21a:	0800                	addi	s0,sp,16
 21c:	de5ff0ef          	jal	0 <main>
 220:	4501                	li	a0,0
 222:	25c000ef          	jal	47e <exit>

0000000000000226 <strcpy>:
 226:	1141                	addi	sp,sp,-16
 228:	e422                	sd	s0,8(sp)
 22a:	0800                	addi	s0,sp,16
 22c:	87aa                	mv	a5,a0
 22e:	0585                	addi	a1,a1,1
 230:	0785                	addi	a5,a5,1
 232:	fff5c703          	lbu	a4,-1(a1)
 236:	fee78fa3          	sb	a4,-1(a5)
 23a:	fb75                	bnez	a4,22e <strcpy+0x8>
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret

0000000000000242 <strcmp>:
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
 248:	00054783          	lbu	a5,0(a0)
 24c:	cb91                	beqz	a5,260 <strcmp+0x1e>
 24e:	0005c703          	lbu	a4,0(a1)
 252:	00f71763          	bne	a4,a5,260 <strcmp+0x1e>
 256:	0505                	addi	a0,a0,1
 258:	0585                	addi	a1,a1,1
 25a:	00054783          	lbu	a5,0(a0)
 25e:	fbe5                	bnez	a5,24e <strcmp+0xc>
 260:	0005c503          	lbu	a0,0(a1)
 264:	40a7853b          	subw	a0,a5,a0
 268:	6422                	ld	s0,8(sp)
 26a:	0141                	addi	sp,sp,16
 26c:	8082                	ret

000000000000026e <strlen>:
 26e:	1141                	addi	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	addi	s0,sp,16
 274:	00054783          	lbu	a5,0(a0)
 278:	cf91                	beqz	a5,294 <strlen+0x26>
 27a:	0505                	addi	a0,a0,1
 27c:	87aa                	mv	a5,a0
 27e:	86be                	mv	a3,a5
 280:	0785                	addi	a5,a5,1
 282:	fff7c703          	lbu	a4,-1(a5)
 286:	ff65                	bnez	a4,27e <strlen+0x10>
 288:	40a6853b          	subw	a0,a3,a0
 28c:	2505                	addiw	a0,a0,1
 28e:	6422                	ld	s0,8(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
 294:	4501                	li	a0,0
 296:	bfe5                	j	28e <strlen+0x20>

0000000000000298 <memset>:
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
 29e:	ca19                	beqz	a2,2b4 <memset+0x1c>
 2a0:	87aa                	mv	a5,a0
 2a2:	1602                	slli	a2,a2,0x20
 2a4:	9201                	srli	a2,a2,0x20
 2a6:	00a60733          	add	a4,a2,a0
 2aa:	00b78023          	sb	a1,0(a5)
 2ae:	0785                	addi	a5,a5,1
 2b0:	fee79de3          	bne	a5,a4,2aa <memset+0x12>
 2b4:	6422                	ld	s0,8(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <strchr>:
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	cb99                	beqz	a5,2da <strchr+0x20>
 2c6:	00f58763          	beq	a1,a5,2d4 <strchr+0x1a>
 2ca:	0505                	addi	a0,a0,1
 2cc:	00054783          	lbu	a5,0(a0)
 2d0:	fbfd                	bnez	a5,2c6 <strchr+0xc>
 2d2:	4501                	li	a0,0
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <strchr+0x1a>

00000000000002de <gets>:
 2de:	711d                	addi	sp,sp,-96
 2e0:	ec86                	sd	ra,88(sp)
 2e2:	e8a2                	sd	s0,80(sp)
 2e4:	e4a6                	sd	s1,72(sp)
 2e6:	e0ca                	sd	s2,64(sp)
 2e8:	fc4e                	sd	s3,56(sp)
 2ea:	f852                	sd	s4,48(sp)
 2ec:	f456                	sd	s5,40(sp)
 2ee:	f05a                	sd	s6,32(sp)
 2f0:	ec5e                	sd	s7,24(sp)
 2f2:	1080                	addi	s0,sp,96
 2f4:	8baa                	mv	s7,a0
 2f6:	8a2e                	mv	s4,a1
 2f8:	892a                	mv	s2,a0
 2fa:	4481                	li	s1,0
 2fc:	4aa9                	li	s5,10
 2fe:	4b35                	li	s6,13
 300:	89a6                	mv	s3,s1
 302:	2485                	addiw	s1,s1,1
 304:	0344d663          	bge	s1,s4,330 <gets+0x52>
 308:	4605                	li	a2,1
 30a:	faf40593          	addi	a1,s0,-81
 30e:	4501                	li	a0,0
 310:	186000ef          	jal	496 <read>
 314:	00a05e63          	blez	a0,330 <gets+0x52>
 318:	faf44783          	lbu	a5,-81(s0)
 31c:	00f90023          	sb	a5,0(s2)
 320:	01578763          	beq	a5,s5,32e <gets+0x50>
 324:	0905                	addi	s2,s2,1
 326:	fd679de3          	bne	a5,s6,300 <gets+0x22>
 32a:	89a6                	mv	s3,s1
 32c:	a011                	j	330 <gets+0x52>
 32e:	89a6                	mv	s3,s1
 330:	99de                	add	s3,s3,s7
 332:	00098023          	sb	zero,0(s3)
 336:	855e                	mv	a0,s7
 338:	60e6                	ld	ra,88(sp)
 33a:	6446                	ld	s0,80(sp)
 33c:	64a6                	ld	s1,72(sp)
 33e:	6906                	ld	s2,64(sp)
 340:	79e2                	ld	s3,56(sp)
 342:	7a42                	ld	s4,48(sp)
 344:	7aa2                	ld	s5,40(sp)
 346:	7b02                	ld	s6,32(sp)
 348:	6be2                	ld	s7,24(sp)
 34a:	6125                	addi	sp,sp,96
 34c:	8082                	ret

000000000000034e <stat>:
 34e:	1101                	addi	sp,sp,-32
 350:	ec06                	sd	ra,24(sp)
 352:	e822                	sd	s0,16(sp)
 354:	e04a                	sd	s2,0(sp)
 356:	1000                	addi	s0,sp,32
 358:	892e                	mv	s2,a1
 35a:	4581                	li	a1,0
 35c:	162000ef          	jal	4be <open>
 360:	02054263          	bltz	a0,384 <stat+0x36>
 364:	e426                	sd	s1,8(sp)
 366:	84aa                	mv	s1,a0
 368:	85ca                	mv	a1,s2
 36a:	16c000ef          	jal	4d6 <fstat>
 36e:	892a                	mv	s2,a0
 370:	8526                	mv	a0,s1
 372:	134000ef          	jal	4a6 <close>
 376:	64a2                	ld	s1,8(sp)
 378:	854a                	mv	a0,s2
 37a:	60e2                	ld	ra,24(sp)
 37c:	6442                	ld	s0,16(sp)
 37e:	6902                	ld	s2,0(sp)
 380:	6105                	addi	sp,sp,32
 382:	8082                	ret
 384:	597d                	li	s2,-1
 386:	bfcd                	j	378 <stat+0x2a>

0000000000000388 <atoi>:
 388:	1141                	addi	sp,sp,-16
 38a:	e422                	sd	s0,8(sp)
 38c:	0800                	addi	s0,sp,16
 38e:	00054683          	lbu	a3,0(a0)
 392:	fd06879b          	addiw	a5,a3,-48
 396:	0ff7f793          	zext.b	a5,a5
 39a:	4625                	li	a2,9
 39c:	02f66863          	bltu	a2,a5,3cc <atoi+0x44>
 3a0:	872a                	mv	a4,a0
 3a2:	4501                	li	a0,0
 3a4:	0705                	addi	a4,a4,1
 3a6:	0025179b          	slliw	a5,a0,0x2
 3aa:	9fa9                	addw	a5,a5,a0
 3ac:	0017979b          	slliw	a5,a5,0x1
 3b0:	9fb5                	addw	a5,a5,a3
 3b2:	fd07851b          	addiw	a0,a5,-48
 3b6:	00074683          	lbu	a3,0(a4)
 3ba:	fd06879b          	addiw	a5,a3,-48
 3be:	0ff7f793          	zext.b	a5,a5
 3c2:	fef671e3          	bgeu	a2,a5,3a4 <atoi+0x1c>
 3c6:	6422                	ld	s0,8(sp)
 3c8:	0141                	addi	sp,sp,16
 3ca:	8082                	ret
 3cc:	4501                	li	a0,0
 3ce:	bfe5                	j	3c6 <atoi+0x3e>

00000000000003d0 <memmove>:
 3d0:	1141                	addi	sp,sp,-16
 3d2:	e422                	sd	s0,8(sp)
 3d4:	0800                	addi	s0,sp,16
 3d6:	02b57463          	bgeu	a0,a1,3fe <memmove+0x2e>
 3da:	00c05f63          	blez	a2,3f8 <memmove+0x28>
 3de:	1602                	slli	a2,a2,0x20
 3e0:	9201                	srli	a2,a2,0x20
 3e2:	00c507b3          	add	a5,a0,a2
 3e6:	872a                	mv	a4,a0
 3e8:	0585                	addi	a1,a1,1
 3ea:	0705                	addi	a4,a4,1
 3ec:	fff5c683          	lbu	a3,-1(a1)
 3f0:	fed70fa3          	sb	a3,-1(a4)
 3f4:	fef71ae3          	bne	a4,a5,3e8 <memmove+0x18>
 3f8:	6422                	ld	s0,8(sp)
 3fa:	0141                	addi	sp,sp,16
 3fc:	8082                	ret
 3fe:	00c50733          	add	a4,a0,a2
 402:	95b2                	add	a1,a1,a2
 404:	fec05ae3          	blez	a2,3f8 <memmove+0x28>
 408:	fff6079b          	addiw	a5,a2,-1
 40c:	1782                	slli	a5,a5,0x20
 40e:	9381                	srli	a5,a5,0x20
 410:	fff7c793          	not	a5,a5
 414:	97ba                	add	a5,a5,a4
 416:	15fd                	addi	a1,a1,-1
 418:	177d                	addi	a4,a4,-1
 41a:	0005c683          	lbu	a3,0(a1)
 41e:	00d70023          	sb	a3,0(a4)
 422:	fee79ae3          	bne	a5,a4,416 <memmove+0x46>
 426:	bfc9                	j	3f8 <memmove+0x28>

0000000000000428 <memcmp>:
 428:	1141                	addi	sp,sp,-16
 42a:	e422                	sd	s0,8(sp)
 42c:	0800                	addi	s0,sp,16
 42e:	ca05                	beqz	a2,45e <memcmp+0x36>
 430:	fff6069b          	addiw	a3,a2,-1
 434:	1682                	slli	a3,a3,0x20
 436:	9281                	srli	a3,a3,0x20
 438:	0685                	addi	a3,a3,1
 43a:	96aa                	add	a3,a3,a0
 43c:	00054783          	lbu	a5,0(a0)
 440:	0005c703          	lbu	a4,0(a1)
 444:	00e79863          	bne	a5,a4,454 <memcmp+0x2c>
 448:	0505                	addi	a0,a0,1
 44a:	0585                	addi	a1,a1,1
 44c:	fed518e3          	bne	a0,a3,43c <memcmp+0x14>
 450:	4501                	li	a0,0
 452:	a019                	j	458 <memcmp+0x30>
 454:	40e7853b          	subw	a0,a5,a4
 458:	6422                	ld	s0,8(sp)
 45a:	0141                	addi	sp,sp,16
 45c:	8082                	ret
 45e:	4501                	li	a0,0
 460:	bfe5                	j	458 <memcmp+0x30>

0000000000000462 <memcpy>:
 462:	1141                	addi	sp,sp,-16
 464:	e406                	sd	ra,8(sp)
 466:	e022                	sd	s0,0(sp)
 468:	0800                	addi	s0,sp,16
 46a:	f67ff0ef          	jal	3d0 <memmove>
 46e:	60a2                	ld	ra,8(sp)
 470:	6402                	ld	s0,0(sp)
 472:	0141                	addi	sp,sp,16
 474:	8082                	ret

0000000000000476 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 476:	4885                	li	a7,1
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <exit>:
.global exit
exit:
 li a7, SYS_exit
 47e:	4889                	li	a7,2
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <wait>:
.global wait
wait:
 li a7, SYS_wait
 486:	488d                	li	a7,3
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 48e:	4891                	li	a7,4
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <read>:
.global read
read:
 li a7, SYS_read
 496:	4895                	li	a7,5
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <write>:
.global write
write:
 li a7, SYS_write
 49e:	48c1                	li	a7,16
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <close>:
.global close
close:
 li a7, SYS_close
 4a6:	48d5                	li	a7,21
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ae:	4899                	li	a7,6
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4b6:	489d                	li	a7,7
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <open>:
.global open
open:
 li a7, SYS_open
 4be:	48bd                	li	a7,15
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4c6:	48c5                	li	a7,17
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4ce:	48c9                	li	a7,18
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4d6:	48a1                	li	a7,8
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <link>:
.global link
link:
 li a7, SYS_link
 4de:	48cd                	li	a7,19
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4e6:	48d1                	li	a7,20
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ee:	48a5                	li	a7,9
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4f6:	48a9                	li	a7,10
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4fe:	48ad                	li	a7,11
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 506:	48b1                	li	a7,12
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 50e:	48b5                	li	a7,13
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 516:	48b9                	li	a7,14
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 51e:	48d9                	li	a7,22
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 526:	48dd                	li	a7,23
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 52e:	48e1                	li	a7,24
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 536:	48e5                	li	a7,25
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <rand>:
.global rand
rand:
 li a7, SYS_rand
 53e:	48ed                	li	a7,27
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 546:	1101                	addi	sp,sp,-32
 548:	ec06                	sd	ra,24(sp)
 54a:	e822                	sd	s0,16(sp)
 54c:	1000                	addi	s0,sp,32
 54e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 552:	4605                	li	a2,1
 554:	fef40593          	addi	a1,s0,-17
 558:	f47ff0ef          	jal	49e <write>
}
 55c:	60e2                	ld	ra,24(sp)
 55e:	6442                	ld	s0,16(sp)
 560:	6105                	addi	sp,sp,32
 562:	8082                	ret

0000000000000564 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 564:	7139                	addi	sp,sp,-64
 566:	fc06                	sd	ra,56(sp)
 568:	f822                	sd	s0,48(sp)
 56a:	f426                	sd	s1,40(sp)
 56c:	0080                	addi	s0,sp,64
 56e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 570:	c299                	beqz	a3,576 <printint+0x12>
 572:	0805c963          	bltz	a1,604 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 576:	2581                	sext.w	a1,a1
  neg = 0;
 578:	4881                	li	a7,0
 57a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 57e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 580:	2601                	sext.w	a2,a2
 582:	00000517          	auipc	a0,0x0
 586:	59e50513          	addi	a0,a0,1438 # b20 <digits>
 58a:	883a                	mv	a6,a4
 58c:	2705                	addiw	a4,a4,1
 58e:	02c5f7bb          	remuw	a5,a1,a2
 592:	1782                	slli	a5,a5,0x20
 594:	9381                	srli	a5,a5,0x20
 596:	97aa                	add	a5,a5,a0
 598:	0007c783          	lbu	a5,0(a5)
 59c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5a0:	0005879b          	sext.w	a5,a1
 5a4:	02c5d5bb          	divuw	a1,a1,a2
 5a8:	0685                	addi	a3,a3,1
 5aa:	fec7f0e3          	bgeu	a5,a2,58a <printint+0x26>
  if(neg)
 5ae:	00088c63          	beqz	a7,5c6 <printint+0x62>
    buf[i++] = '-';
 5b2:	fd070793          	addi	a5,a4,-48
 5b6:	00878733          	add	a4,a5,s0
 5ba:	02d00793          	li	a5,45
 5be:	fef70823          	sb	a5,-16(a4)
 5c2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5c6:	02e05a63          	blez	a4,5fa <printint+0x96>
 5ca:	f04a                	sd	s2,32(sp)
 5cc:	ec4e                	sd	s3,24(sp)
 5ce:	fc040793          	addi	a5,s0,-64
 5d2:	00e78933          	add	s2,a5,a4
 5d6:	fff78993          	addi	s3,a5,-1
 5da:	99ba                	add	s3,s3,a4
 5dc:	377d                	addiw	a4,a4,-1
 5de:	1702                	slli	a4,a4,0x20
 5e0:	9301                	srli	a4,a4,0x20
 5e2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5e6:	fff94583          	lbu	a1,-1(s2)
 5ea:	8526                	mv	a0,s1
 5ec:	f5bff0ef          	jal	546 <putc>
  while(--i >= 0)
 5f0:	197d                	addi	s2,s2,-1
 5f2:	ff391ae3          	bne	s2,s3,5e6 <printint+0x82>
 5f6:	7902                	ld	s2,32(sp)
 5f8:	69e2                	ld	s3,24(sp)
}
 5fa:	70e2                	ld	ra,56(sp)
 5fc:	7442                	ld	s0,48(sp)
 5fe:	74a2                	ld	s1,40(sp)
 600:	6121                	addi	sp,sp,64
 602:	8082                	ret
    x = -xx;
 604:	40b005bb          	negw	a1,a1
    neg = 1;
 608:	4885                	li	a7,1
    x = -xx;
 60a:	bf85                	j	57a <printint+0x16>

000000000000060c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 60c:	711d                	addi	sp,sp,-96
 60e:	ec86                	sd	ra,88(sp)
 610:	e8a2                	sd	s0,80(sp)
 612:	e0ca                	sd	s2,64(sp)
 614:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 616:	0005c903          	lbu	s2,0(a1)
 61a:	26090863          	beqz	s2,88a <vprintf+0x27e>
 61e:	e4a6                	sd	s1,72(sp)
 620:	fc4e                	sd	s3,56(sp)
 622:	f852                	sd	s4,48(sp)
 624:	f456                	sd	s5,40(sp)
 626:	f05a                	sd	s6,32(sp)
 628:	ec5e                	sd	s7,24(sp)
 62a:	e862                	sd	s8,16(sp)
 62c:	e466                	sd	s9,8(sp)
 62e:	8b2a                	mv	s6,a0
 630:	8a2e                	mv	s4,a1
 632:	8bb2                	mv	s7,a2
  state = 0;
 634:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 636:	4481                	li	s1,0
 638:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 63a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 63e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 642:	06c00c93          	li	s9,108
 646:	a005                	j	666 <vprintf+0x5a>
        putc(fd, c0);
 648:	85ca                	mv	a1,s2
 64a:	855a                	mv	a0,s6
 64c:	efbff0ef          	jal	546 <putc>
 650:	a019                	j	656 <vprintf+0x4a>
    } else if(state == '%'){
 652:	03598263          	beq	s3,s5,676 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 656:	2485                	addiw	s1,s1,1
 658:	8726                	mv	a4,s1
 65a:	009a07b3          	add	a5,s4,s1
 65e:	0007c903          	lbu	s2,0(a5)
 662:	20090c63          	beqz	s2,87a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 666:	0009079b          	sext.w	a5,s2
    if(state == 0){
 66a:	fe0994e3          	bnez	s3,652 <vprintf+0x46>
      if(c0 == '%'){
 66e:	fd579de3          	bne	a5,s5,648 <vprintf+0x3c>
        state = '%';
 672:	89be                	mv	s3,a5
 674:	b7cd                	j	656 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 676:	00ea06b3          	add	a3,s4,a4
 67a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 67e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 680:	c681                	beqz	a3,688 <vprintf+0x7c>
 682:	9752                	add	a4,a4,s4
 684:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 688:	03878f63          	beq	a5,s8,6c6 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 68c:	05978963          	beq	a5,s9,6de <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 690:	07500713          	li	a4,117
 694:	0ee78363          	beq	a5,a4,77a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 698:	07800713          	li	a4,120
 69c:	12e78563          	beq	a5,a4,7c6 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6a0:	07000713          	li	a4,112
 6a4:	14e78a63          	beq	a5,a4,7f8 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6a8:	07300713          	li	a4,115
 6ac:	18e78a63          	beq	a5,a4,840 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6b0:	02500713          	li	a4,37
 6b4:	04e79563          	bne	a5,a4,6fe <vprintf+0xf2>
        putc(fd, '%');
 6b8:	02500593          	li	a1,37
 6bc:	855a                	mv	a0,s6
 6be:	e89ff0ef          	jal	546 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	bf49                	j	656 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6c6:	008b8913          	addi	s2,s7,8
 6ca:	4685                	li	a3,1
 6cc:	4629                	li	a2,10
 6ce:	000ba583          	lw	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	e91ff0ef          	jal	564 <printint>
 6d8:	8bca                	mv	s7,s2
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	bfad                	j	656 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6de:	06400793          	li	a5,100
 6e2:	02f68963          	beq	a3,a5,714 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6e6:	06c00793          	li	a5,108
 6ea:	04f68263          	beq	a3,a5,72e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6ee:	07500793          	li	a5,117
 6f2:	0af68063          	beq	a3,a5,792 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6f6:	07800793          	li	a5,120
 6fa:	0ef68263          	beq	a3,a5,7de <vprintf+0x1d2>
        putc(fd, '%');
 6fe:	02500593          	li	a1,37
 702:	855a                	mv	a0,s6
 704:	e43ff0ef          	jal	546 <putc>
        putc(fd, c0);
 708:	85ca                	mv	a1,s2
 70a:	855a                	mv	a0,s6
 70c:	e3bff0ef          	jal	546 <putc>
      state = 0;
 710:	4981                	li	s3,0
 712:	b791                	j	656 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 714:	008b8913          	addi	s2,s7,8
 718:	4685                	li	a3,1
 71a:	4629                	li	a2,10
 71c:	000ba583          	lw	a1,0(s7)
 720:	855a                	mv	a0,s6
 722:	e43ff0ef          	jal	564 <printint>
        i += 1;
 726:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 728:	8bca                	mv	s7,s2
      state = 0;
 72a:	4981                	li	s3,0
        i += 1;
 72c:	b72d                	j	656 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 72e:	06400793          	li	a5,100
 732:	02f60763          	beq	a2,a5,760 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 736:	07500793          	li	a5,117
 73a:	06f60963          	beq	a2,a5,7ac <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 73e:	07800793          	li	a5,120
 742:	faf61ee3          	bne	a2,a5,6fe <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 746:	008b8913          	addi	s2,s7,8
 74a:	4681                	li	a3,0
 74c:	4641                	li	a2,16
 74e:	000ba583          	lw	a1,0(s7)
 752:	855a                	mv	a0,s6
 754:	e11ff0ef          	jal	564 <printint>
        i += 2;
 758:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 75a:	8bca                	mv	s7,s2
      state = 0;
 75c:	4981                	li	s3,0
        i += 2;
 75e:	bde5                	j	656 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 760:	008b8913          	addi	s2,s7,8
 764:	4685                	li	a3,1
 766:	4629                	li	a2,10
 768:	000ba583          	lw	a1,0(s7)
 76c:	855a                	mv	a0,s6
 76e:	df7ff0ef          	jal	564 <printint>
        i += 2;
 772:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 774:	8bca                	mv	s7,s2
      state = 0;
 776:	4981                	li	s3,0
        i += 2;
 778:	bdf9                	j	656 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 77a:	008b8913          	addi	s2,s7,8
 77e:	4681                	li	a3,0
 780:	4629                	li	a2,10
 782:	000ba583          	lw	a1,0(s7)
 786:	855a                	mv	a0,s6
 788:	dddff0ef          	jal	564 <printint>
 78c:	8bca                	mv	s7,s2
      state = 0;
 78e:	4981                	li	s3,0
 790:	b5d9                	j	656 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 792:	008b8913          	addi	s2,s7,8
 796:	4681                	li	a3,0
 798:	4629                	li	a2,10
 79a:	000ba583          	lw	a1,0(s7)
 79e:	855a                	mv	a0,s6
 7a0:	dc5ff0ef          	jal	564 <printint>
        i += 1;
 7a4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a6:	8bca                	mv	s7,s2
      state = 0;
 7a8:	4981                	li	s3,0
        i += 1;
 7aa:	b575                	j	656 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ac:	008b8913          	addi	s2,s7,8
 7b0:	4681                	li	a3,0
 7b2:	4629                	li	a2,10
 7b4:	000ba583          	lw	a1,0(s7)
 7b8:	855a                	mv	a0,s6
 7ba:	dabff0ef          	jal	564 <printint>
        i += 2;
 7be:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c0:	8bca                	mv	s7,s2
      state = 0;
 7c2:	4981                	li	s3,0
        i += 2;
 7c4:	bd49                	j	656 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7c6:	008b8913          	addi	s2,s7,8
 7ca:	4681                	li	a3,0
 7cc:	4641                	li	a2,16
 7ce:	000ba583          	lw	a1,0(s7)
 7d2:	855a                	mv	a0,s6
 7d4:	d91ff0ef          	jal	564 <printint>
 7d8:	8bca                	mv	s7,s2
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	bdad                	j	656 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7de:	008b8913          	addi	s2,s7,8
 7e2:	4681                	li	a3,0
 7e4:	4641                	li	a2,16
 7e6:	000ba583          	lw	a1,0(s7)
 7ea:	855a                	mv	a0,s6
 7ec:	d79ff0ef          	jal	564 <printint>
        i += 1;
 7f0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f2:	8bca                	mv	s7,s2
      state = 0;
 7f4:	4981                	li	s3,0
        i += 1;
 7f6:	b585                	j	656 <vprintf+0x4a>
 7f8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7fa:	008b8d13          	addi	s10,s7,8
 7fe:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 802:	03000593          	li	a1,48
 806:	855a                	mv	a0,s6
 808:	d3fff0ef          	jal	546 <putc>
  putc(fd, 'x');
 80c:	07800593          	li	a1,120
 810:	855a                	mv	a0,s6
 812:	d35ff0ef          	jal	546 <putc>
 816:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 818:	00000b97          	auipc	s7,0x0
 81c:	308b8b93          	addi	s7,s7,776 # b20 <digits>
 820:	03c9d793          	srli	a5,s3,0x3c
 824:	97de                	add	a5,a5,s7
 826:	0007c583          	lbu	a1,0(a5)
 82a:	855a                	mv	a0,s6
 82c:	d1bff0ef          	jal	546 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 830:	0992                	slli	s3,s3,0x4
 832:	397d                	addiw	s2,s2,-1
 834:	fe0916e3          	bnez	s2,820 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 838:	8bea                	mv	s7,s10
      state = 0;
 83a:	4981                	li	s3,0
 83c:	6d02                	ld	s10,0(sp)
 83e:	bd21                	j	656 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 840:	008b8993          	addi	s3,s7,8
 844:	000bb903          	ld	s2,0(s7)
 848:	00090f63          	beqz	s2,866 <vprintf+0x25a>
        for(; *s; s++)
 84c:	00094583          	lbu	a1,0(s2)
 850:	c195                	beqz	a1,874 <vprintf+0x268>
          putc(fd, *s);
 852:	855a                	mv	a0,s6
 854:	cf3ff0ef          	jal	546 <putc>
        for(; *s; s++)
 858:	0905                	addi	s2,s2,1
 85a:	00094583          	lbu	a1,0(s2)
 85e:	f9f5                	bnez	a1,852 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 860:	8bce                	mv	s7,s3
      state = 0;
 862:	4981                	li	s3,0
 864:	bbcd                	j	656 <vprintf+0x4a>
          s = "(null)";
 866:	00000917          	auipc	s2,0x0
 86a:	2b290913          	addi	s2,s2,690 # b18 <malloc+0x1a6>
        for(; *s; s++)
 86e:	02800593          	li	a1,40
 872:	b7c5                	j	852 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 874:	8bce                	mv	s7,s3
      state = 0;
 876:	4981                	li	s3,0
 878:	bbf9                	j	656 <vprintf+0x4a>
 87a:	64a6                	ld	s1,72(sp)
 87c:	79e2                	ld	s3,56(sp)
 87e:	7a42                	ld	s4,48(sp)
 880:	7aa2                	ld	s5,40(sp)
 882:	7b02                	ld	s6,32(sp)
 884:	6be2                	ld	s7,24(sp)
 886:	6c42                	ld	s8,16(sp)
 888:	6ca2                	ld	s9,8(sp)
    }
  }
}
 88a:	60e6                	ld	ra,88(sp)
 88c:	6446                	ld	s0,80(sp)
 88e:	6906                	ld	s2,64(sp)
 890:	6125                	addi	sp,sp,96
 892:	8082                	ret

0000000000000894 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 894:	715d                	addi	sp,sp,-80
 896:	ec06                	sd	ra,24(sp)
 898:	e822                	sd	s0,16(sp)
 89a:	1000                	addi	s0,sp,32
 89c:	e010                	sd	a2,0(s0)
 89e:	e414                	sd	a3,8(s0)
 8a0:	e818                	sd	a4,16(s0)
 8a2:	ec1c                	sd	a5,24(s0)
 8a4:	03043023          	sd	a6,32(s0)
 8a8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ac:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8b0:	8622                	mv	a2,s0
 8b2:	d5bff0ef          	jal	60c <vprintf>
}
 8b6:	60e2                	ld	ra,24(sp)
 8b8:	6442                	ld	s0,16(sp)
 8ba:	6161                	addi	sp,sp,80
 8bc:	8082                	ret

00000000000008be <printf>:

void
printf(const char *fmt, ...)
{
 8be:	711d                	addi	sp,sp,-96
 8c0:	ec06                	sd	ra,24(sp)
 8c2:	e822                	sd	s0,16(sp)
 8c4:	1000                	addi	s0,sp,32
 8c6:	e40c                	sd	a1,8(s0)
 8c8:	e810                	sd	a2,16(s0)
 8ca:	ec14                	sd	a3,24(s0)
 8cc:	f018                	sd	a4,32(s0)
 8ce:	f41c                	sd	a5,40(s0)
 8d0:	03043823          	sd	a6,48(s0)
 8d4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8d8:	00840613          	addi	a2,s0,8
 8dc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8e0:	85aa                	mv	a1,a0
 8e2:	4505                	li	a0,1
 8e4:	d29ff0ef          	jal	60c <vprintf>
}
 8e8:	60e2                	ld	ra,24(sp)
 8ea:	6442                	ld	s0,16(sp)
 8ec:	6125                	addi	sp,sp,96
 8ee:	8082                	ret

00000000000008f0 <free>:
 8f0:	1141                	addi	sp,sp,-16
 8f2:	e422                	sd	s0,8(sp)
 8f4:	0800                	addi	s0,sp,16
 8f6:	ff050693          	addi	a3,a0,-16
 8fa:	00000797          	auipc	a5,0x0
 8fe:	7067b783          	ld	a5,1798(a5) # 1000 <freep>
 902:	a02d                	j	92c <free+0x3c>
 904:	4618                	lw	a4,8(a2)
 906:	9f2d                	addw	a4,a4,a1
 908:	fee52c23          	sw	a4,-8(a0)
 90c:	6398                	ld	a4,0(a5)
 90e:	6310                	ld	a2,0(a4)
 910:	a83d                	j	94e <free+0x5e>
 912:	ff852703          	lw	a4,-8(a0)
 916:	9f31                	addw	a4,a4,a2
 918:	c798                	sw	a4,8(a5)
 91a:	ff053683          	ld	a3,-16(a0)
 91e:	a091                	j	962 <free+0x72>
 920:	6398                	ld	a4,0(a5)
 922:	00e7e463          	bltu	a5,a4,92a <free+0x3a>
 926:	00e6ea63          	bltu	a3,a4,93a <free+0x4a>
 92a:	87ba                	mv	a5,a4
 92c:	fed7fae3          	bgeu	a5,a3,920 <free+0x30>
 930:	6398                	ld	a4,0(a5)
 932:	00e6e463          	bltu	a3,a4,93a <free+0x4a>
 936:	fee7eae3          	bltu	a5,a4,92a <free+0x3a>
 93a:	ff852583          	lw	a1,-8(a0)
 93e:	6390                	ld	a2,0(a5)
 940:	02059813          	slli	a6,a1,0x20
 944:	01c85713          	srli	a4,a6,0x1c
 948:	9736                	add	a4,a4,a3
 94a:	fae60de3          	beq	a2,a4,904 <free+0x14>
 94e:	fec53823          	sd	a2,-16(a0)
 952:	4790                	lw	a2,8(a5)
 954:	02061593          	slli	a1,a2,0x20
 958:	01c5d713          	srli	a4,a1,0x1c
 95c:	973e                	add	a4,a4,a5
 95e:	fae68ae3          	beq	a3,a4,912 <free+0x22>
 962:	e394                	sd	a3,0(a5)
 964:	00000717          	auipc	a4,0x0
 968:	68f73e23          	sd	a5,1692(a4) # 1000 <freep>
 96c:	6422                	ld	s0,8(sp)
 96e:	0141                	addi	sp,sp,16
 970:	8082                	ret

0000000000000972 <malloc>:
 972:	7139                	addi	sp,sp,-64
 974:	fc06                	sd	ra,56(sp)
 976:	f822                	sd	s0,48(sp)
 978:	f426                	sd	s1,40(sp)
 97a:	ec4e                	sd	s3,24(sp)
 97c:	0080                	addi	s0,sp,64
 97e:	02051493          	slli	s1,a0,0x20
 982:	9081                	srli	s1,s1,0x20
 984:	04bd                	addi	s1,s1,15
 986:	8091                	srli	s1,s1,0x4
 988:	0014899b          	addiw	s3,s1,1
 98c:	0485                	addi	s1,s1,1
 98e:	00000517          	auipc	a0,0x0
 992:	67253503          	ld	a0,1650(a0) # 1000 <freep>
 996:	c915                	beqz	a0,9ca <malloc+0x58>
 998:	611c                	ld	a5,0(a0)
 99a:	4798                	lw	a4,8(a5)
 99c:	08977a63          	bgeu	a4,s1,a30 <malloc+0xbe>
 9a0:	f04a                	sd	s2,32(sp)
 9a2:	e852                	sd	s4,16(sp)
 9a4:	e456                	sd	s5,8(sp)
 9a6:	e05a                	sd	s6,0(sp)
 9a8:	8a4e                	mv	s4,s3
 9aa:	0009871b          	sext.w	a4,s3
 9ae:	6685                	lui	a3,0x1
 9b0:	00d77363          	bgeu	a4,a3,9b6 <malloc+0x44>
 9b4:	6a05                	lui	s4,0x1
 9b6:	000a0b1b          	sext.w	s6,s4
 9ba:	004a1a1b          	slliw	s4,s4,0x4
 9be:	00000917          	auipc	s2,0x0
 9c2:	64290913          	addi	s2,s2,1602 # 1000 <freep>
 9c6:	5afd                	li	s5,-1
 9c8:	a081                	j	a08 <malloc+0x96>
 9ca:	f04a                	sd	s2,32(sp)
 9cc:	e852                	sd	s4,16(sp)
 9ce:	e456                	sd	s5,8(sp)
 9d0:	e05a                	sd	s6,0(sp)
 9d2:	00000797          	auipc	a5,0x0
 9d6:	63e78793          	addi	a5,a5,1598 # 1010 <base>
 9da:	00000717          	auipc	a4,0x0
 9de:	62f73323          	sd	a5,1574(a4) # 1000 <freep>
 9e2:	e39c                	sd	a5,0(a5)
 9e4:	0007a423          	sw	zero,8(a5)
 9e8:	b7c1                	j	9a8 <malloc+0x36>
 9ea:	6398                	ld	a4,0(a5)
 9ec:	e118                	sd	a4,0(a0)
 9ee:	a8a9                	j	a48 <malloc+0xd6>
 9f0:	01652423          	sw	s6,8(a0)
 9f4:	0541                	addi	a0,a0,16
 9f6:	efbff0ef          	jal	8f0 <free>
 9fa:	00093503          	ld	a0,0(s2)
 9fe:	c12d                	beqz	a0,a60 <malloc+0xee>
 a00:	611c                	ld	a5,0(a0)
 a02:	4798                	lw	a4,8(a5)
 a04:	02977263          	bgeu	a4,s1,a28 <malloc+0xb6>
 a08:	00093703          	ld	a4,0(s2)
 a0c:	853e                	mv	a0,a5
 a0e:	fef719e3          	bne	a4,a5,a00 <malloc+0x8e>
 a12:	8552                	mv	a0,s4
 a14:	af3ff0ef          	jal	506 <sbrk>
 a18:	fd551ce3          	bne	a0,s5,9f0 <malloc+0x7e>
 a1c:	4501                	li	a0,0
 a1e:	7902                	ld	s2,32(sp)
 a20:	6a42                	ld	s4,16(sp)
 a22:	6aa2                	ld	s5,8(sp)
 a24:	6b02                	ld	s6,0(sp)
 a26:	a03d                	j	a54 <malloc+0xe2>
 a28:	7902                	ld	s2,32(sp)
 a2a:	6a42                	ld	s4,16(sp)
 a2c:	6aa2                	ld	s5,8(sp)
 a2e:	6b02                	ld	s6,0(sp)
 a30:	fae48de3          	beq	s1,a4,9ea <malloc+0x78>
 a34:	4137073b          	subw	a4,a4,s3
 a38:	c798                	sw	a4,8(a5)
 a3a:	02071693          	slli	a3,a4,0x20
 a3e:	01c6d713          	srli	a4,a3,0x1c
 a42:	97ba                	add	a5,a5,a4
 a44:	0137a423          	sw	s3,8(a5)
 a48:	00000717          	auipc	a4,0x0
 a4c:	5aa73c23          	sd	a0,1464(a4) # 1000 <freep>
 a50:	01078513          	addi	a0,a5,16
 a54:	70e2                	ld	ra,56(sp)
 a56:	7442                	ld	s0,48(sp)
 a58:	74a2                	ld	s1,40(sp)
 a5a:	69e2                	ld	s3,24(sp)
 a5c:	6121                	addi	sp,sp,64
 a5e:	8082                	ret
 a60:	7902                	ld	s2,32(sp)
 a62:	6a42                	ld	s4,16(sp)
 a64:	6aa2                	ld	s5,8(sp)
 a66:	6b02                	ld	s6,0(sp)
 a68:	b7f5                	j	a54 <malloc+0xe2>
