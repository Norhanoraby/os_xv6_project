
user/_diff:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <readline>:
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	e85a                	sd	s6,16(sp)
  12:	0880                	addi	s0,sp,80
  14:	8a2a                	mv	s4,a0
  16:	8b2e                	mv	s6,a1
  18:	892e                	mv	s2,a1
  1a:	4481                	li	s1,0
  1c:	fff6099b          	addiw	s3,a2,-1
  20:	4aa9                	li	s5,10
  22:	0334d363          	bge	s1,s3,48 <readline+0x48>
  26:	4605                	li	a2,1
  28:	fbf40593          	addi	a1,s0,-65
  2c:	8552                	mv	a0,s4
  2e:	4d8000ef          	jal	506 <read>
  32:	4785                	li	a5,1
  34:	00f51a63          	bne	a0,a5,48 <readline+0x48>
  38:	2485                	addiw	s1,s1,1
  3a:	fbf44783          	lbu	a5,-65(s0)
  3e:	00f90023          	sb	a5,0(s2)
  42:	0905                	addi	s2,s2,1
  44:	fd579fe3          	bne	a5,s5,22 <readline+0x22>
  48:	9b26                	add	s6,s6,s1
  4a:	000b0023          	sb	zero,0(s6)
  4e:	8526                	mv	a0,s1
  50:	60a6                	ld	ra,72(sp)
  52:	6406                	ld	s0,64(sp)
  54:	74e2                	ld	s1,56(sp)
  56:	7942                	ld	s2,48(sp)
  58:	79a2                	ld	s3,40(sp)
  5a:	7a02                	ld	s4,32(sp)
  5c:	6ae2                	ld	s5,24(sp)
  5e:	6b42                	ld	s6,16(sp)
  60:	6161                	addi	sp,sp,80
  62:	8082                	ret

0000000000000064 <strip_newlines>:
  64:	1101                	addi	sp,sp,-32
  66:	ec06                	sd	ra,24(sp)
  68:	e822                	sd	s0,16(sp)
  6a:	e426                	sd	s1,8(sp)
  6c:	1000                	addi	s0,sp,32
  6e:	84aa                	mv	s1,a0
  70:	26e000ef          	jal	2de <strlen>
  74:	0005079b          	sext.w	a5,a0
  78:	02f05a63          	blez	a5,ac <strip_newlines+0x48>
  7c:	fff78713          	addi	a4,a5,-1
  80:	9726                	add	a4,a4,s1
  82:	00074603          	lbu	a2,0(a4)
  86:	46a9                	li	a3,10
  88:	00d60d63          	beq	a2,a3,a2 <strip_newlines+0x3e>
  8c:	17fd                	addi	a5,a5,-1
  8e:	00f48533          	add	a0,s1,a5
  92:	00054703          	lbu	a4,0(a0)
  96:	47b5                	li	a5,13
  98:	00f71a63          	bne	a4,a5,ac <strip_newlines+0x48>
  9c:	00050023          	sb	zero,0(a0)
  a0:	a031                	j	ac <strip_newlines+0x48>
  a2:	00070023          	sb	zero,0(a4)
  a6:	37fd                	addiw	a5,a5,-1
  a8:	fef042e3          	bgtz	a5,8c <strip_newlines+0x28>
  ac:	60e2                	ld	ra,24(sp)
  ae:	6442                	ld	s0,16(sp)
  b0:	64a2                	ld	s1,8(sp)
  b2:	6105                	addi	sp,sp,32
  b4:	8082                	ret

00000000000000b6 <main>:
  b6:	ba010113          	addi	sp,sp,-1120
  ba:	44113c23          	sd	ra,1112(sp)
  be:	44813823          	sd	s0,1104(sp)
  c2:	43313c23          	sd	s3,1080(sp)
  c6:	46010413          	addi	s0,sp,1120
  ca:	89ae                	mv	s3,a1
  cc:	4789                	li	a5,2
  ce:	04f50063          	beq	a0,a5,10e <main+0x58>
  d2:	478d                	li	a5,3
  d4:	08f50163          	beq	a0,a5,156 <main+0xa0>
  d8:	44913423          	sd	s1,1096(sp)
  dc:	45213023          	sd	s2,1088(sp)
  e0:	43413823          	sd	s4,1072(sp)
  e4:	43513423          	sd	s5,1064(sp)
  e8:	43613023          	sd	s6,1056(sp)
  ec:	41713c23          	sd	s7,1048(sp)
  f0:	41813823          	sd	s8,1040(sp)
  f4:	41913423          	sd	s9,1032(sp)
  f8:	41a13023          	sd	s10,1024(sp)
  fc:	00001517          	auipc	a0,0x1
 100:	a0c50513          	addi	a0,a0,-1524 # b08 <malloc+0x12e>
 104:	023000ef          	jal	926 <printf>
 108:	4505                	li	a0,1
 10a:	3e4000ef          	jal	4ee <exit>
 10e:	00001597          	auipc	a1,0x1
 112:	9d258593          	addi	a1,a1,-1582 # ae0 <malloc+0x106>
 116:	0089b503          	ld	a0,8(s3)
 11a:	198000ef          	jal	2b2 <strcmp>
 11e:	fd4d                	bnez	a0,d8 <main+0x22>
 120:	44913423          	sd	s1,1096(sp)
 124:	45213023          	sd	s2,1088(sp)
 128:	43413823          	sd	s4,1072(sp)
 12c:	43513423          	sd	s5,1064(sp)
 130:	43613023          	sd	s6,1056(sp)
 134:	41713c23          	sd	s7,1048(sp)
 138:	41813823          	sd	s8,1040(sp)
 13c:	41913423          	sd	s9,1032(sp)
 140:	41a13023          	sd	s10,1024(sp)
 144:	00001517          	auipc	a0,0x1
 148:	9a450513          	addi	a0,a0,-1628 # ae8 <malloc+0x10e>
 14c:	7da000ef          	jal	926 <printf>
 150:	4501                	li	a0,0
 152:	39c000ef          	jal	4ee <exit>
 156:	44913423          	sd	s1,1096(sp)
 15a:	45213023          	sd	s2,1088(sp)
 15e:	43413823          	sd	s4,1072(sp)
 162:	43513423          	sd	s5,1064(sp)
 166:	43613023          	sd	s6,1056(sp)
 16a:	41713c23          	sd	s7,1048(sp)
 16e:	41813823          	sd	s8,1040(sp)
 172:	41913423          	sd	s9,1032(sp)
 176:	41a13023          	sd	s10,1024(sp)
 17a:	4581                	li	a1,0
 17c:	0089b503          	ld	a0,8(s3)
 180:	3ae000ef          	jal	52e <open>
 184:	8b2a                	mv	s6,a0
 186:	4581                	li	a1,0
 188:	0109b503          	ld	a0,16(s3)
 18c:	3a2000ef          	jal	52e <open>
 190:	8aaa                	mv	s5,a0
 192:	00ab67b3          	or	a5,s6,a0
 196:	02079713          	slli	a4,a5,0x20
 19a:	00074e63          	bltz	a4,1b6 <main+0x100>
 19e:	4b81                	li	s7,0
 1a0:	4a05                	li	s4,1
 1a2:	00001c97          	auipc	s9,0x1
 1a6:	9e6c8c93          	addi	s9,s9,-1562 # b88 <malloc+0x1ae>
 1aa:	4c05                	li	s8,1
 1ac:	00001d17          	auipc	s10,0x1
 1b0:	99cd0d13          	addi	s10,s10,-1636 # b48 <malloc+0x16e>
 1b4:	a091                	j	1f8 <main+0x142>
 1b6:	00001517          	auipc	a0,0x1
 1ba:	97250513          	addi	a0,a0,-1678 # b28 <malloc+0x14e>
 1be:	768000ef          	jal	926 <printf>
 1c2:	4505                	li	a0,1
 1c4:	32a000ef          	jal	4ee <exit>
 1c8:	03205063          	blez	s2,1e8 <main+0x132>
 1cc:	ec91                	bnez	s1,1e8 <main+0x132>
 1ce:	ba040693          	addi	a3,s0,-1120
 1d2:	0109b603          	ld	a2,16(s3)
 1d6:	85d2                	mv	a1,s4
 1d8:	00001517          	auipc	a0,0x1
 1dc:	99050513          	addi	a0,a0,-1648 # b68 <malloc+0x18e>
 1e0:	746000ef          	jal	926 <printf>
 1e4:	4b85                	li	s7,1
 1e6:	a801                	j	1f6 <main+0x140>
 1e8:	ba040593          	addi	a1,s0,-1120
 1ec:	da040513          	addi	a0,s0,-608
 1f0:	0c2000ef          	jal	2b2 <strcmp>
 1f4:	ed21                	bnez	a0,24c <main+0x196>
 1f6:	2a05                	addiw	s4,s4,1
 1f8:	20000613          	li	a2,512
 1fc:	da040593          	addi	a1,s0,-608
 200:	855a                	mv	a0,s6
 202:	dffff0ef          	jal	0 <readline>
 206:	84aa                	mv	s1,a0
 208:	20000613          	li	a2,512
 20c:	ba040593          	addi	a1,s0,-1120
 210:	8556                	mv	a0,s5
 212:	defff0ef          	jal	0 <readline>
 216:	892a                	mv	s2,a0
 218:	00a4e7b3          	or	a5,s1,a0
 21c:	2781                	sext.w	a5,a5
 21e:	c3a9                	beqz	a5,260 <main+0x1aa>
 220:	da040513          	addi	a0,s0,-608
 224:	e41ff0ef          	jal	64 <strip_newlines>
 228:	ba040513          	addi	a0,s0,-1120
 22c:	e39ff0ef          	jal	64 <strip_newlines>
 230:	f8905ce3          	blez	s1,1c8 <main+0x112>
 234:	fa091ae3          	bnez	s2,1e8 <main+0x132>
 238:	da040693          	addi	a3,s0,-608
 23c:	0089b603          	ld	a2,8(s3)
 240:	85d2                	mv	a1,s4
 242:	856a                	mv	a0,s10
 244:	6e2000ef          	jal	926 <printf>
 248:	8be2                	mv	s7,s8
 24a:	b775                	j	1f6 <main+0x140>
 24c:	ba040693          	addi	a3,s0,-1120
 250:	da040613          	addi	a2,s0,-608
 254:	85d2                	mv	a1,s4
 256:	8566                	mv	a0,s9
 258:	6ce000ef          	jal	926 <printf>
 25c:	8be2                	mv	s7,s8
 25e:	bf61                	j	1f6 <main+0x140>
 260:	000b8b63          	beqz	s7,276 <main+0x1c0>
 264:	855a                	mv	a0,s6
 266:	2b0000ef          	jal	516 <close>
 26a:	8556                	mv	a0,s5
 26c:	2aa000ef          	jal	516 <close>
 270:	4501                	li	a0,0
 272:	27c000ef          	jal	4ee <exit>
 276:	00001517          	auipc	a0,0x1
 27a:	93250513          	addi	a0,a0,-1742 # ba8 <malloc+0x1ce>
 27e:	6a8000ef          	jal	926 <printf>
 282:	b7cd                	j	264 <main+0x1ae>

0000000000000284 <start>:
 284:	1141                	addi	sp,sp,-16
 286:	e406                	sd	ra,8(sp)
 288:	e022                	sd	s0,0(sp)
 28a:	0800                	addi	s0,sp,16
 28c:	e2bff0ef          	jal	b6 <main>
 290:	4501                	li	a0,0
 292:	25c000ef          	jal	4ee <exit>

0000000000000296 <strcpy>:
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
 29c:	87aa                	mv	a5,a0
 29e:	0585                	addi	a1,a1,1
 2a0:	0785                	addi	a5,a5,1
 2a2:	fff5c703          	lbu	a4,-1(a1)
 2a6:	fee78fa3          	sb	a4,-1(a5)
 2aa:	fb75                	bnez	a4,29e <strcpy+0x8>
 2ac:	6422                	ld	s0,8(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <strcmp>:
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	cb91                	beqz	a5,2d0 <strcmp+0x1e>
 2be:	0005c703          	lbu	a4,0(a1)
 2c2:	00f71763          	bne	a4,a5,2d0 <strcmp+0x1e>
 2c6:	0505                	addi	a0,a0,1
 2c8:	0585                	addi	a1,a1,1
 2ca:	00054783          	lbu	a5,0(a0)
 2ce:	fbe5                	bnez	a5,2be <strcmp+0xc>
 2d0:	0005c503          	lbu	a0,0(a1)
 2d4:	40a7853b          	subw	a0,a5,a0
 2d8:	6422                	ld	s0,8(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <strlen>:
 2de:	1141                	addi	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	addi	s0,sp,16
 2e4:	00054783          	lbu	a5,0(a0)
 2e8:	cf91                	beqz	a5,304 <strlen+0x26>
 2ea:	0505                	addi	a0,a0,1
 2ec:	87aa                	mv	a5,a0
 2ee:	86be                	mv	a3,a5
 2f0:	0785                	addi	a5,a5,1
 2f2:	fff7c703          	lbu	a4,-1(a5)
 2f6:	ff65                	bnez	a4,2ee <strlen+0x10>
 2f8:	40a6853b          	subw	a0,a3,a0
 2fc:	2505                	addiw	a0,a0,1
 2fe:	6422                	ld	s0,8(sp)
 300:	0141                	addi	sp,sp,16
 302:	8082                	ret
 304:	4501                	li	a0,0
 306:	bfe5                	j	2fe <strlen+0x20>

0000000000000308 <memset>:
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
 30e:	ca19                	beqz	a2,324 <memset+0x1c>
 310:	87aa                	mv	a5,a0
 312:	1602                	slli	a2,a2,0x20
 314:	9201                	srli	a2,a2,0x20
 316:	00a60733          	add	a4,a2,a0
 31a:	00b78023          	sb	a1,0(a5)
 31e:	0785                	addi	a5,a5,1
 320:	fee79de3          	bne	a5,a4,31a <memset+0x12>
 324:	6422                	ld	s0,8(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret

000000000000032a <strchr>:
 32a:	1141                	addi	sp,sp,-16
 32c:	e422                	sd	s0,8(sp)
 32e:	0800                	addi	s0,sp,16
 330:	00054783          	lbu	a5,0(a0)
 334:	cb99                	beqz	a5,34a <strchr+0x20>
 336:	00f58763          	beq	a1,a5,344 <strchr+0x1a>
 33a:	0505                	addi	a0,a0,1
 33c:	00054783          	lbu	a5,0(a0)
 340:	fbfd                	bnez	a5,336 <strchr+0xc>
 342:	4501                	li	a0,0
 344:	6422                	ld	s0,8(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret
 34a:	4501                	li	a0,0
 34c:	bfe5                	j	344 <strchr+0x1a>

000000000000034e <gets>:
 34e:	711d                	addi	sp,sp,-96
 350:	ec86                	sd	ra,88(sp)
 352:	e8a2                	sd	s0,80(sp)
 354:	e4a6                	sd	s1,72(sp)
 356:	e0ca                	sd	s2,64(sp)
 358:	fc4e                	sd	s3,56(sp)
 35a:	f852                	sd	s4,48(sp)
 35c:	f456                	sd	s5,40(sp)
 35e:	f05a                	sd	s6,32(sp)
 360:	ec5e                	sd	s7,24(sp)
 362:	1080                	addi	s0,sp,96
 364:	8baa                	mv	s7,a0
 366:	8a2e                	mv	s4,a1
 368:	892a                	mv	s2,a0
 36a:	4481                	li	s1,0
 36c:	4aa9                	li	s5,10
 36e:	4b35                	li	s6,13
 370:	89a6                	mv	s3,s1
 372:	2485                	addiw	s1,s1,1
 374:	0344d663          	bge	s1,s4,3a0 <gets+0x52>
 378:	4605                	li	a2,1
 37a:	faf40593          	addi	a1,s0,-81
 37e:	4501                	li	a0,0
 380:	186000ef          	jal	506 <read>
 384:	00a05e63          	blez	a0,3a0 <gets+0x52>
 388:	faf44783          	lbu	a5,-81(s0)
 38c:	00f90023          	sb	a5,0(s2)
 390:	01578763          	beq	a5,s5,39e <gets+0x50>
 394:	0905                	addi	s2,s2,1
 396:	fd679de3          	bne	a5,s6,370 <gets+0x22>
 39a:	89a6                	mv	s3,s1
 39c:	a011                	j	3a0 <gets+0x52>
 39e:	89a6                	mv	s3,s1
 3a0:	99de                	add	s3,s3,s7
 3a2:	00098023          	sb	zero,0(s3)
 3a6:	855e                	mv	a0,s7
 3a8:	60e6                	ld	ra,88(sp)
 3aa:	6446                	ld	s0,80(sp)
 3ac:	64a6                	ld	s1,72(sp)
 3ae:	6906                	ld	s2,64(sp)
 3b0:	79e2                	ld	s3,56(sp)
 3b2:	7a42                	ld	s4,48(sp)
 3b4:	7aa2                	ld	s5,40(sp)
 3b6:	7b02                	ld	s6,32(sp)
 3b8:	6be2                	ld	s7,24(sp)
 3ba:	6125                	addi	sp,sp,96
 3bc:	8082                	ret

00000000000003be <stat>:
 3be:	1101                	addi	sp,sp,-32
 3c0:	ec06                	sd	ra,24(sp)
 3c2:	e822                	sd	s0,16(sp)
 3c4:	e04a                	sd	s2,0(sp)
 3c6:	1000                	addi	s0,sp,32
 3c8:	892e                	mv	s2,a1
 3ca:	4581                	li	a1,0
 3cc:	162000ef          	jal	52e <open>
 3d0:	02054263          	bltz	a0,3f4 <stat+0x36>
 3d4:	e426                	sd	s1,8(sp)
 3d6:	84aa                	mv	s1,a0
 3d8:	85ca                	mv	a1,s2
 3da:	16c000ef          	jal	546 <fstat>
 3de:	892a                	mv	s2,a0
 3e0:	8526                	mv	a0,s1
 3e2:	134000ef          	jal	516 <close>
 3e6:	64a2                	ld	s1,8(sp)
 3e8:	854a                	mv	a0,s2
 3ea:	60e2                	ld	ra,24(sp)
 3ec:	6442                	ld	s0,16(sp)
 3ee:	6902                	ld	s2,0(sp)
 3f0:	6105                	addi	sp,sp,32
 3f2:	8082                	ret
 3f4:	597d                	li	s2,-1
 3f6:	bfcd                	j	3e8 <stat+0x2a>

00000000000003f8 <atoi>:
 3f8:	1141                	addi	sp,sp,-16
 3fa:	e422                	sd	s0,8(sp)
 3fc:	0800                	addi	s0,sp,16
 3fe:	00054683          	lbu	a3,0(a0)
 402:	fd06879b          	addiw	a5,a3,-48
 406:	0ff7f793          	zext.b	a5,a5
 40a:	4625                	li	a2,9
 40c:	02f66863          	bltu	a2,a5,43c <atoi+0x44>
 410:	872a                	mv	a4,a0
 412:	4501                	li	a0,0
 414:	0705                	addi	a4,a4,1
 416:	0025179b          	slliw	a5,a0,0x2
 41a:	9fa9                	addw	a5,a5,a0
 41c:	0017979b          	slliw	a5,a5,0x1
 420:	9fb5                	addw	a5,a5,a3
 422:	fd07851b          	addiw	a0,a5,-48
 426:	00074683          	lbu	a3,0(a4)
 42a:	fd06879b          	addiw	a5,a3,-48
 42e:	0ff7f793          	zext.b	a5,a5
 432:	fef671e3          	bgeu	a2,a5,414 <atoi+0x1c>
 436:	6422                	ld	s0,8(sp)
 438:	0141                	addi	sp,sp,16
 43a:	8082                	ret
 43c:	4501                	li	a0,0
 43e:	bfe5                	j	436 <atoi+0x3e>

0000000000000440 <memmove>:
 440:	1141                	addi	sp,sp,-16
 442:	e422                	sd	s0,8(sp)
 444:	0800                	addi	s0,sp,16
 446:	02b57463          	bgeu	a0,a1,46e <memmove+0x2e>
 44a:	00c05f63          	blez	a2,468 <memmove+0x28>
 44e:	1602                	slli	a2,a2,0x20
 450:	9201                	srli	a2,a2,0x20
 452:	00c507b3          	add	a5,a0,a2
 456:	872a                	mv	a4,a0
 458:	0585                	addi	a1,a1,1
 45a:	0705                	addi	a4,a4,1
 45c:	fff5c683          	lbu	a3,-1(a1)
 460:	fed70fa3          	sb	a3,-1(a4)
 464:	fef71ae3          	bne	a4,a5,458 <memmove+0x18>
 468:	6422                	ld	s0,8(sp)
 46a:	0141                	addi	sp,sp,16
 46c:	8082                	ret
 46e:	00c50733          	add	a4,a0,a2
 472:	95b2                	add	a1,a1,a2
 474:	fec05ae3          	blez	a2,468 <memmove+0x28>
 478:	fff6079b          	addiw	a5,a2,-1
 47c:	1782                	slli	a5,a5,0x20
 47e:	9381                	srli	a5,a5,0x20
 480:	fff7c793          	not	a5,a5
 484:	97ba                	add	a5,a5,a4
 486:	15fd                	addi	a1,a1,-1
 488:	177d                	addi	a4,a4,-1
 48a:	0005c683          	lbu	a3,0(a1)
 48e:	00d70023          	sb	a3,0(a4)
 492:	fee79ae3          	bne	a5,a4,486 <memmove+0x46>
 496:	bfc9                	j	468 <memmove+0x28>

0000000000000498 <memcmp>:
 498:	1141                	addi	sp,sp,-16
 49a:	e422                	sd	s0,8(sp)
 49c:	0800                	addi	s0,sp,16
 49e:	ca05                	beqz	a2,4ce <memcmp+0x36>
 4a0:	fff6069b          	addiw	a3,a2,-1
 4a4:	1682                	slli	a3,a3,0x20
 4a6:	9281                	srli	a3,a3,0x20
 4a8:	0685                	addi	a3,a3,1
 4aa:	96aa                	add	a3,a3,a0
 4ac:	00054783          	lbu	a5,0(a0)
 4b0:	0005c703          	lbu	a4,0(a1)
 4b4:	00e79863          	bne	a5,a4,4c4 <memcmp+0x2c>
 4b8:	0505                	addi	a0,a0,1
 4ba:	0585                	addi	a1,a1,1
 4bc:	fed518e3          	bne	a0,a3,4ac <memcmp+0x14>
 4c0:	4501                	li	a0,0
 4c2:	a019                	j	4c8 <memcmp+0x30>
 4c4:	40e7853b          	subw	a0,a5,a4
 4c8:	6422                	ld	s0,8(sp)
 4ca:	0141                	addi	sp,sp,16
 4cc:	8082                	ret
 4ce:	4501                	li	a0,0
 4d0:	bfe5                	j	4c8 <memcmp+0x30>

00000000000004d2 <memcpy>:
 4d2:	1141                	addi	sp,sp,-16
 4d4:	e406                	sd	ra,8(sp)
 4d6:	e022                	sd	s0,0(sp)
 4d8:	0800                	addi	s0,sp,16
 4da:	f67ff0ef          	jal	440 <memmove>
 4de:	60a2                	ld	ra,8(sp)
 4e0:	6402                	ld	s0,0(sp)
 4e2:	0141                	addi	sp,sp,16
 4e4:	8082                	ret

00000000000004e6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4e6:	4885                	li	a7,1
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <exit>:
.global exit
exit:
 li a7, SYS_exit
 4ee:	4889                	li	a7,2
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4f6:	488d                	li	a7,3
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4fe:	4891                	li	a7,4
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <read>:
.global read
read:
 li a7, SYS_read
 506:	4895                	li	a7,5
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <write>:
.global write
write:
 li a7, SYS_write
 50e:	48c1                	li	a7,16
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <close>:
.global close
close:
 li a7, SYS_close
 516:	48d5                	li	a7,21
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <kill>:
.global kill
kill:
 li a7, SYS_kill
 51e:	4899                	li	a7,6
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <exec>:
.global exec
exec:
 li a7, SYS_exec
 526:	489d                	li	a7,7
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <open>:
.global open
open:
 li a7, SYS_open
 52e:	48bd                	li	a7,15
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 536:	48c5                	li	a7,17
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 53e:	48c9                	li	a7,18
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 546:	48a1                	li	a7,8
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <link>:
.global link
link:
 li a7, SYS_link
 54e:	48cd                	li	a7,19
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 556:	48d1                	li	a7,20
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 55e:	48a5                	li	a7,9
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <dup>:
.global dup
dup:
 li a7, SYS_dup
 566:	48a9                	li	a7,10
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 56e:	48ad                	li	a7,11
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 576:	48b1                	li	a7,12
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 57e:	48b5                	li	a7,13
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 586:	48b9                	li	a7,14
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 58e:	48d9                	li	a7,22
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 596:	48dd                	li	a7,23
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 59e:	48e1                	li	a7,24
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 5a6:	48e5                	li	a7,25
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ae:	1101                	addi	sp,sp,-32
 5b0:	ec06                	sd	ra,24(sp)
 5b2:	e822                	sd	s0,16(sp)
 5b4:	1000                	addi	s0,sp,32
 5b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ba:	4605                	li	a2,1
 5bc:	fef40593          	addi	a1,s0,-17
 5c0:	f4fff0ef          	jal	50e <write>
}
 5c4:	60e2                	ld	ra,24(sp)
 5c6:	6442                	ld	s0,16(sp)
 5c8:	6105                	addi	sp,sp,32
 5ca:	8082                	ret

00000000000005cc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5cc:	7139                	addi	sp,sp,-64
 5ce:	fc06                	sd	ra,56(sp)
 5d0:	f822                	sd	s0,48(sp)
 5d2:	f426                	sd	s1,40(sp)
 5d4:	0080                	addi	s0,sp,64
 5d6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5d8:	c299                	beqz	a3,5de <printint+0x12>
 5da:	0805c963          	bltz	a1,66c <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5de:	2581                	sext.w	a1,a1
  neg = 0;
 5e0:	4881                	li	a7,0
 5e2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5e6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5e8:	2601                	sext.w	a2,a2
 5ea:	00000517          	auipc	a0,0x0
 5ee:	5de50513          	addi	a0,a0,1502 # bc8 <digits>
 5f2:	883a                	mv	a6,a4
 5f4:	2705                	addiw	a4,a4,1
 5f6:	02c5f7bb          	remuw	a5,a1,a2
 5fa:	1782                	slli	a5,a5,0x20
 5fc:	9381                	srli	a5,a5,0x20
 5fe:	97aa                	add	a5,a5,a0
 600:	0007c783          	lbu	a5,0(a5)
 604:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 608:	0005879b          	sext.w	a5,a1
 60c:	02c5d5bb          	divuw	a1,a1,a2
 610:	0685                	addi	a3,a3,1
 612:	fec7f0e3          	bgeu	a5,a2,5f2 <printint+0x26>
  if(neg)
 616:	00088c63          	beqz	a7,62e <printint+0x62>
    buf[i++] = '-';
 61a:	fd070793          	addi	a5,a4,-48
 61e:	00878733          	add	a4,a5,s0
 622:	02d00793          	li	a5,45
 626:	fef70823          	sb	a5,-16(a4)
 62a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 62e:	02e05a63          	blez	a4,662 <printint+0x96>
 632:	f04a                	sd	s2,32(sp)
 634:	ec4e                	sd	s3,24(sp)
 636:	fc040793          	addi	a5,s0,-64
 63a:	00e78933          	add	s2,a5,a4
 63e:	fff78993          	addi	s3,a5,-1
 642:	99ba                	add	s3,s3,a4
 644:	377d                	addiw	a4,a4,-1
 646:	1702                	slli	a4,a4,0x20
 648:	9301                	srli	a4,a4,0x20
 64a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 64e:	fff94583          	lbu	a1,-1(s2)
 652:	8526                	mv	a0,s1
 654:	f5bff0ef          	jal	5ae <putc>
  while(--i >= 0)
 658:	197d                	addi	s2,s2,-1
 65a:	ff391ae3          	bne	s2,s3,64e <printint+0x82>
 65e:	7902                	ld	s2,32(sp)
 660:	69e2                	ld	s3,24(sp)
}
 662:	70e2                	ld	ra,56(sp)
 664:	7442                	ld	s0,48(sp)
 666:	74a2                	ld	s1,40(sp)
 668:	6121                	addi	sp,sp,64
 66a:	8082                	ret
    x = -xx;
 66c:	40b005bb          	negw	a1,a1
    neg = 1;
 670:	4885                	li	a7,1
    x = -xx;
 672:	bf85                	j	5e2 <printint+0x16>

0000000000000674 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 674:	711d                	addi	sp,sp,-96
 676:	ec86                	sd	ra,88(sp)
 678:	e8a2                	sd	s0,80(sp)
 67a:	e0ca                	sd	s2,64(sp)
 67c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 67e:	0005c903          	lbu	s2,0(a1)
 682:	26090863          	beqz	s2,8f2 <vprintf+0x27e>
 686:	e4a6                	sd	s1,72(sp)
 688:	fc4e                	sd	s3,56(sp)
 68a:	f852                	sd	s4,48(sp)
 68c:	f456                	sd	s5,40(sp)
 68e:	f05a                	sd	s6,32(sp)
 690:	ec5e                	sd	s7,24(sp)
 692:	e862                	sd	s8,16(sp)
 694:	e466                	sd	s9,8(sp)
 696:	8b2a                	mv	s6,a0
 698:	8a2e                	mv	s4,a1
 69a:	8bb2                	mv	s7,a2
  state = 0;
 69c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 69e:	4481                	li	s1,0
 6a0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6a2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6a6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6aa:	06c00c93          	li	s9,108
 6ae:	a005                	j	6ce <vprintf+0x5a>
        putc(fd, c0);
 6b0:	85ca                	mv	a1,s2
 6b2:	855a                	mv	a0,s6
 6b4:	efbff0ef          	jal	5ae <putc>
 6b8:	a019                	j	6be <vprintf+0x4a>
    } else if(state == '%'){
 6ba:	03598263          	beq	s3,s5,6de <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6be:	2485                	addiw	s1,s1,1
 6c0:	8726                	mv	a4,s1
 6c2:	009a07b3          	add	a5,s4,s1
 6c6:	0007c903          	lbu	s2,0(a5)
 6ca:	20090c63          	beqz	s2,8e2 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 6ce:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6d2:	fe0994e3          	bnez	s3,6ba <vprintf+0x46>
      if(c0 == '%'){
 6d6:	fd579de3          	bne	a5,s5,6b0 <vprintf+0x3c>
        state = '%';
 6da:	89be                	mv	s3,a5
 6dc:	b7cd                	j	6be <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6de:	00ea06b3          	add	a3,s4,a4
 6e2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6e6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6e8:	c681                	beqz	a3,6f0 <vprintf+0x7c>
 6ea:	9752                	add	a4,a4,s4
 6ec:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6f0:	03878f63          	beq	a5,s8,72e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6f4:	05978963          	beq	a5,s9,746 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6f8:	07500713          	li	a4,117
 6fc:	0ee78363          	beq	a5,a4,7e2 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 700:	07800713          	li	a4,120
 704:	12e78563          	beq	a5,a4,82e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 708:	07000713          	li	a4,112
 70c:	14e78a63          	beq	a5,a4,860 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 710:	07300713          	li	a4,115
 714:	18e78a63          	beq	a5,a4,8a8 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 718:	02500713          	li	a4,37
 71c:	04e79563          	bne	a5,a4,766 <vprintf+0xf2>
        putc(fd, '%');
 720:	02500593          	li	a1,37
 724:	855a                	mv	a0,s6
 726:	e89ff0ef          	jal	5ae <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 72a:	4981                	li	s3,0
 72c:	bf49                	j	6be <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 72e:	008b8913          	addi	s2,s7,8
 732:	4685                	li	a3,1
 734:	4629                	li	a2,10
 736:	000ba583          	lw	a1,0(s7)
 73a:	855a                	mv	a0,s6
 73c:	e91ff0ef          	jal	5cc <printint>
 740:	8bca                	mv	s7,s2
      state = 0;
 742:	4981                	li	s3,0
 744:	bfad                	j	6be <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 746:	06400793          	li	a5,100
 74a:	02f68963          	beq	a3,a5,77c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 74e:	06c00793          	li	a5,108
 752:	04f68263          	beq	a3,a5,796 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 756:	07500793          	li	a5,117
 75a:	0af68063          	beq	a3,a5,7fa <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 75e:	07800793          	li	a5,120
 762:	0ef68263          	beq	a3,a5,846 <vprintf+0x1d2>
        putc(fd, '%');
 766:	02500593          	li	a1,37
 76a:	855a                	mv	a0,s6
 76c:	e43ff0ef          	jal	5ae <putc>
        putc(fd, c0);
 770:	85ca                	mv	a1,s2
 772:	855a                	mv	a0,s6
 774:	e3bff0ef          	jal	5ae <putc>
      state = 0;
 778:	4981                	li	s3,0
 77a:	b791                	j	6be <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 77c:	008b8913          	addi	s2,s7,8
 780:	4685                	li	a3,1
 782:	4629                	li	a2,10
 784:	000ba583          	lw	a1,0(s7)
 788:	855a                	mv	a0,s6
 78a:	e43ff0ef          	jal	5cc <printint>
        i += 1;
 78e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 790:	8bca                	mv	s7,s2
      state = 0;
 792:	4981                	li	s3,0
        i += 1;
 794:	b72d                	j	6be <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 796:	06400793          	li	a5,100
 79a:	02f60763          	beq	a2,a5,7c8 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 79e:	07500793          	li	a5,117
 7a2:	06f60963          	beq	a2,a5,814 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7a6:	07800793          	li	a5,120
 7aa:	faf61ee3          	bne	a2,a5,766 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ae:	008b8913          	addi	s2,s7,8
 7b2:	4681                	li	a3,0
 7b4:	4641                	li	a2,16
 7b6:	000ba583          	lw	a1,0(s7)
 7ba:	855a                	mv	a0,s6
 7bc:	e11ff0ef          	jal	5cc <printint>
        i += 2;
 7c0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c2:	8bca                	mv	s7,s2
      state = 0;
 7c4:	4981                	li	s3,0
        i += 2;
 7c6:	bde5                	j	6be <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c8:	008b8913          	addi	s2,s7,8
 7cc:	4685                	li	a3,1
 7ce:	4629                	li	a2,10
 7d0:	000ba583          	lw	a1,0(s7)
 7d4:	855a                	mv	a0,s6
 7d6:	df7ff0ef          	jal	5cc <printint>
        i += 2;
 7da:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7dc:	8bca                	mv	s7,s2
      state = 0;
 7de:	4981                	li	s3,0
        i += 2;
 7e0:	bdf9                	j	6be <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7e2:	008b8913          	addi	s2,s7,8
 7e6:	4681                	li	a3,0
 7e8:	4629                	li	a2,10
 7ea:	000ba583          	lw	a1,0(s7)
 7ee:	855a                	mv	a0,s6
 7f0:	dddff0ef          	jal	5cc <printint>
 7f4:	8bca                	mv	s7,s2
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	b5d9                	j	6be <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7fa:	008b8913          	addi	s2,s7,8
 7fe:	4681                	li	a3,0
 800:	4629                	li	a2,10
 802:	000ba583          	lw	a1,0(s7)
 806:	855a                	mv	a0,s6
 808:	dc5ff0ef          	jal	5cc <printint>
        i += 1;
 80c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 80e:	8bca                	mv	s7,s2
      state = 0;
 810:	4981                	li	s3,0
        i += 1;
 812:	b575                	j	6be <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 814:	008b8913          	addi	s2,s7,8
 818:	4681                	li	a3,0
 81a:	4629                	li	a2,10
 81c:	000ba583          	lw	a1,0(s7)
 820:	855a                	mv	a0,s6
 822:	dabff0ef          	jal	5cc <printint>
        i += 2;
 826:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 828:	8bca                	mv	s7,s2
      state = 0;
 82a:	4981                	li	s3,0
        i += 2;
 82c:	bd49                	j	6be <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 82e:	008b8913          	addi	s2,s7,8
 832:	4681                	li	a3,0
 834:	4641                	li	a2,16
 836:	000ba583          	lw	a1,0(s7)
 83a:	855a                	mv	a0,s6
 83c:	d91ff0ef          	jal	5cc <printint>
 840:	8bca                	mv	s7,s2
      state = 0;
 842:	4981                	li	s3,0
 844:	bdad                	j	6be <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 846:	008b8913          	addi	s2,s7,8
 84a:	4681                	li	a3,0
 84c:	4641                	li	a2,16
 84e:	000ba583          	lw	a1,0(s7)
 852:	855a                	mv	a0,s6
 854:	d79ff0ef          	jal	5cc <printint>
        i += 1;
 858:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 85a:	8bca                	mv	s7,s2
      state = 0;
 85c:	4981                	li	s3,0
        i += 1;
 85e:	b585                	j	6be <vprintf+0x4a>
 860:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 862:	008b8d13          	addi	s10,s7,8
 866:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 86a:	03000593          	li	a1,48
 86e:	855a                	mv	a0,s6
 870:	d3fff0ef          	jal	5ae <putc>
  putc(fd, 'x');
 874:	07800593          	li	a1,120
 878:	855a                	mv	a0,s6
 87a:	d35ff0ef          	jal	5ae <putc>
 87e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 880:	00000b97          	auipc	s7,0x0
 884:	348b8b93          	addi	s7,s7,840 # bc8 <digits>
 888:	03c9d793          	srli	a5,s3,0x3c
 88c:	97de                	add	a5,a5,s7
 88e:	0007c583          	lbu	a1,0(a5)
 892:	855a                	mv	a0,s6
 894:	d1bff0ef          	jal	5ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 898:	0992                	slli	s3,s3,0x4
 89a:	397d                	addiw	s2,s2,-1
 89c:	fe0916e3          	bnez	s2,888 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 8a0:	8bea                	mv	s7,s10
      state = 0;
 8a2:	4981                	li	s3,0
 8a4:	6d02                	ld	s10,0(sp)
 8a6:	bd21                	j	6be <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8a8:	008b8993          	addi	s3,s7,8
 8ac:	000bb903          	ld	s2,0(s7)
 8b0:	00090f63          	beqz	s2,8ce <vprintf+0x25a>
        for(; *s; s++)
 8b4:	00094583          	lbu	a1,0(s2)
 8b8:	c195                	beqz	a1,8dc <vprintf+0x268>
          putc(fd, *s);
 8ba:	855a                	mv	a0,s6
 8bc:	cf3ff0ef          	jal	5ae <putc>
        for(; *s; s++)
 8c0:	0905                	addi	s2,s2,1
 8c2:	00094583          	lbu	a1,0(s2)
 8c6:	f9f5                	bnez	a1,8ba <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8c8:	8bce                	mv	s7,s3
      state = 0;
 8ca:	4981                	li	s3,0
 8cc:	bbcd                	j	6be <vprintf+0x4a>
          s = "(null)";
 8ce:	00000917          	auipc	s2,0x0
 8d2:	2f290913          	addi	s2,s2,754 # bc0 <malloc+0x1e6>
        for(; *s; s++)
 8d6:	02800593          	li	a1,40
 8da:	b7c5                	j	8ba <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8dc:	8bce                	mv	s7,s3
      state = 0;
 8de:	4981                	li	s3,0
 8e0:	bbf9                	j	6be <vprintf+0x4a>
 8e2:	64a6                	ld	s1,72(sp)
 8e4:	79e2                	ld	s3,56(sp)
 8e6:	7a42                	ld	s4,48(sp)
 8e8:	7aa2                	ld	s5,40(sp)
 8ea:	7b02                	ld	s6,32(sp)
 8ec:	6be2                	ld	s7,24(sp)
 8ee:	6c42                	ld	s8,16(sp)
 8f0:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8f2:	60e6                	ld	ra,88(sp)
 8f4:	6446                	ld	s0,80(sp)
 8f6:	6906                	ld	s2,64(sp)
 8f8:	6125                	addi	sp,sp,96
 8fa:	8082                	ret

00000000000008fc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8fc:	715d                	addi	sp,sp,-80
 8fe:	ec06                	sd	ra,24(sp)
 900:	e822                	sd	s0,16(sp)
 902:	1000                	addi	s0,sp,32
 904:	e010                	sd	a2,0(s0)
 906:	e414                	sd	a3,8(s0)
 908:	e818                	sd	a4,16(s0)
 90a:	ec1c                	sd	a5,24(s0)
 90c:	03043023          	sd	a6,32(s0)
 910:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 914:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 918:	8622                	mv	a2,s0
 91a:	d5bff0ef          	jal	674 <vprintf>
}
 91e:	60e2                	ld	ra,24(sp)
 920:	6442                	ld	s0,16(sp)
 922:	6161                	addi	sp,sp,80
 924:	8082                	ret

0000000000000926 <printf>:

void
printf(const char *fmt, ...)
{
 926:	711d                	addi	sp,sp,-96
 928:	ec06                	sd	ra,24(sp)
 92a:	e822                	sd	s0,16(sp)
 92c:	1000                	addi	s0,sp,32
 92e:	e40c                	sd	a1,8(s0)
 930:	e810                	sd	a2,16(s0)
 932:	ec14                	sd	a3,24(s0)
 934:	f018                	sd	a4,32(s0)
 936:	f41c                	sd	a5,40(s0)
 938:	03043823          	sd	a6,48(s0)
 93c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 940:	00840613          	addi	a2,s0,8
 944:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 948:	85aa                	mv	a1,a0
 94a:	4505                	li	a0,1
 94c:	d29ff0ef          	jal	674 <vprintf>
}
 950:	60e2                	ld	ra,24(sp)
 952:	6442                	ld	s0,16(sp)
 954:	6125                	addi	sp,sp,96
 956:	8082                	ret

0000000000000958 <free>:
 958:	1141                	addi	sp,sp,-16
 95a:	e422                	sd	s0,8(sp)
 95c:	0800                	addi	s0,sp,16
 95e:	ff050693          	addi	a3,a0,-16
 962:	00001797          	auipc	a5,0x1
 966:	69e7b783          	ld	a5,1694(a5) # 2000 <freep>
 96a:	a02d                	j	994 <free+0x3c>
 96c:	4618                	lw	a4,8(a2)
 96e:	9f2d                	addw	a4,a4,a1
 970:	fee52c23          	sw	a4,-8(a0)
 974:	6398                	ld	a4,0(a5)
 976:	6310                	ld	a2,0(a4)
 978:	a83d                	j	9b6 <free+0x5e>
 97a:	ff852703          	lw	a4,-8(a0)
 97e:	9f31                	addw	a4,a4,a2
 980:	c798                	sw	a4,8(a5)
 982:	ff053683          	ld	a3,-16(a0)
 986:	a091                	j	9ca <free+0x72>
 988:	6398                	ld	a4,0(a5)
 98a:	00e7e463          	bltu	a5,a4,992 <free+0x3a>
 98e:	00e6ea63          	bltu	a3,a4,9a2 <free+0x4a>
 992:	87ba                	mv	a5,a4
 994:	fed7fae3          	bgeu	a5,a3,988 <free+0x30>
 998:	6398                	ld	a4,0(a5)
 99a:	00e6e463          	bltu	a3,a4,9a2 <free+0x4a>
 99e:	fee7eae3          	bltu	a5,a4,992 <free+0x3a>
 9a2:	ff852583          	lw	a1,-8(a0)
 9a6:	6390                	ld	a2,0(a5)
 9a8:	02059813          	slli	a6,a1,0x20
 9ac:	01c85713          	srli	a4,a6,0x1c
 9b0:	9736                	add	a4,a4,a3
 9b2:	fae60de3          	beq	a2,a4,96c <free+0x14>
 9b6:	fec53823          	sd	a2,-16(a0)
 9ba:	4790                	lw	a2,8(a5)
 9bc:	02061593          	slli	a1,a2,0x20
 9c0:	01c5d713          	srli	a4,a1,0x1c
 9c4:	973e                	add	a4,a4,a5
 9c6:	fae68ae3          	beq	a3,a4,97a <free+0x22>
 9ca:	e394                	sd	a3,0(a5)
 9cc:	00001717          	auipc	a4,0x1
 9d0:	62f73a23          	sd	a5,1588(a4) # 2000 <freep>
 9d4:	6422                	ld	s0,8(sp)
 9d6:	0141                	addi	sp,sp,16
 9d8:	8082                	ret

00000000000009da <malloc>:
 9da:	7139                	addi	sp,sp,-64
 9dc:	fc06                	sd	ra,56(sp)
 9de:	f822                	sd	s0,48(sp)
 9e0:	f426                	sd	s1,40(sp)
 9e2:	ec4e                	sd	s3,24(sp)
 9e4:	0080                	addi	s0,sp,64
 9e6:	02051493          	slli	s1,a0,0x20
 9ea:	9081                	srli	s1,s1,0x20
 9ec:	04bd                	addi	s1,s1,15
 9ee:	8091                	srli	s1,s1,0x4
 9f0:	0014899b          	addiw	s3,s1,1
 9f4:	0485                	addi	s1,s1,1
 9f6:	00001517          	auipc	a0,0x1
 9fa:	60a53503          	ld	a0,1546(a0) # 2000 <freep>
 9fe:	c915                	beqz	a0,a32 <malloc+0x58>
 a00:	611c                	ld	a5,0(a0)
 a02:	4798                	lw	a4,8(a5)
 a04:	08977a63          	bgeu	a4,s1,a98 <malloc+0xbe>
 a08:	f04a                	sd	s2,32(sp)
 a0a:	e852                	sd	s4,16(sp)
 a0c:	e456                	sd	s5,8(sp)
 a0e:	e05a                	sd	s6,0(sp)
 a10:	8a4e                	mv	s4,s3
 a12:	0009871b          	sext.w	a4,s3
 a16:	6685                	lui	a3,0x1
 a18:	00d77363          	bgeu	a4,a3,a1e <malloc+0x44>
 a1c:	6a05                	lui	s4,0x1
 a1e:	000a0b1b          	sext.w	s6,s4
 a22:	004a1a1b          	slliw	s4,s4,0x4
 a26:	00001917          	auipc	s2,0x1
 a2a:	5da90913          	addi	s2,s2,1498 # 2000 <freep>
 a2e:	5afd                	li	s5,-1
 a30:	a081                	j	a70 <malloc+0x96>
 a32:	f04a                	sd	s2,32(sp)
 a34:	e852                	sd	s4,16(sp)
 a36:	e456                	sd	s5,8(sp)
 a38:	e05a                	sd	s6,0(sp)
 a3a:	00001797          	auipc	a5,0x1
 a3e:	5d678793          	addi	a5,a5,1494 # 2010 <base>
 a42:	00001717          	auipc	a4,0x1
 a46:	5af73f23          	sd	a5,1470(a4) # 2000 <freep>
 a4a:	e39c                	sd	a5,0(a5)
 a4c:	0007a423          	sw	zero,8(a5)
 a50:	b7c1                	j	a10 <malloc+0x36>
 a52:	6398                	ld	a4,0(a5)
 a54:	e118                	sd	a4,0(a0)
 a56:	a8a9                	j	ab0 <malloc+0xd6>
 a58:	01652423          	sw	s6,8(a0)
 a5c:	0541                	addi	a0,a0,16
 a5e:	efbff0ef          	jal	958 <free>
 a62:	00093503          	ld	a0,0(s2)
 a66:	c12d                	beqz	a0,ac8 <malloc+0xee>
 a68:	611c                	ld	a5,0(a0)
 a6a:	4798                	lw	a4,8(a5)
 a6c:	02977263          	bgeu	a4,s1,a90 <malloc+0xb6>
 a70:	00093703          	ld	a4,0(s2)
 a74:	853e                	mv	a0,a5
 a76:	fef719e3          	bne	a4,a5,a68 <malloc+0x8e>
 a7a:	8552                	mv	a0,s4
 a7c:	afbff0ef          	jal	576 <sbrk>
 a80:	fd551ce3          	bne	a0,s5,a58 <malloc+0x7e>
 a84:	4501                	li	a0,0
 a86:	7902                	ld	s2,32(sp)
 a88:	6a42                	ld	s4,16(sp)
 a8a:	6aa2                	ld	s5,8(sp)
 a8c:	6b02                	ld	s6,0(sp)
 a8e:	a03d                	j	abc <malloc+0xe2>
 a90:	7902                	ld	s2,32(sp)
 a92:	6a42                	ld	s4,16(sp)
 a94:	6aa2                	ld	s5,8(sp)
 a96:	6b02                	ld	s6,0(sp)
 a98:	fae48de3          	beq	s1,a4,a52 <malloc+0x78>
 a9c:	4137073b          	subw	a4,a4,s3
 aa0:	c798                	sw	a4,8(a5)
 aa2:	02071693          	slli	a3,a4,0x20
 aa6:	01c6d713          	srli	a4,a3,0x1c
 aaa:	97ba                	add	a5,a5,a4
 aac:	0137a423          	sw	s3,8(a5)
 ab0:	00001717          	auipc	a4,0x1
 ab4:	54a73823          	sd	a0,1360(a4) # 2000 <freep>
 ab8:	01078513          	addi	a0,a5,16
 abc:	70e2                	ld	ra,56(sp)
 abe:	7442                	ld	s0,48(sp)
 ac0:	74a2                	ld	s1,40(sp)
 ac2:	69e2                	ld	s3,24(sp)
 ac4:	6121                	addi	sp,sp,64
 ac6:	8082                	ret
 ac8:	7902                	ld	s2,32(sp)
 aca:	6a42                	ld	s4,16(sp)
 acc:	6aa2                	ld	s5,8(sp)
 ace:	6b02                	ld	s6,0(sp)
 ad0:	b7f5                	j	abc <malloc+0xe2>
