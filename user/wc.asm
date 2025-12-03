
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  26:	4901                	li	s2,0
  28:	4a81                	li	s5,0
  2a:	4981                	li	s3,0
  2c:	4d81                	li	s11,0
  2e:	4d01                	li	s10,0
  30:	4c81                	li	s9,0
  32:	4ba9                	li	s7,10
  34:	00001b17          	auipc	s6,0x1
  38:	bfcb0b13          	addi	s6,s6,-1028 # c30 <malloc+0x100>
  3c:	a835                	j	78 <wc+0x78>
  3e:	2c85                	addiw	s9,s9,1
  40:	87d6                	mv	a5,s5
  42:	012ad363          	bge	s5,s2,48 <wc+0x48>
  46:	87ca                	mv	a5,s2
  48:	00078a9b          	sext.w	s5,a5
  4c:	4901                	li	s2,0
  4e:	855a                	mv	a0,s6
  50:	428000ef          	jal	478 <strchr>
  54:	c919                	beqz	a0,6a <wc+0x6a>
  56:	4981                	li	s3,0
  58:	0485                	addi	s1,s1,1
  5a:	009a0d63          	beq	s4,s1,74 <wc+0x74>
  5e:	0004c583          	lbu	a1,0(s1)
  62:	fd758ee3          	beq	a1,s7,3e <wc+0x3e>
  66:	2905                	addiw	s2,s2,1
  68:	b7dd                	j	4e <wc+0x4e>
  6a:	fe0997e3          	bnez	s3,58 <wc+0x58>
  6e:	2d05                	addiw	s10,s10,1
  70:	4985                	li	s3,1
  72:	b7dd                	j	58 <wc+0x58>
  74:	01bc0dbb          	addw	s11,s8,s11
  78:	20000613          	li	a2,512
  7c:	00002597          	auipc	a1,0x2
  80:	fc458593          	addi	a1,a1,-60 # 2040 <buf>
  84:	f8843503          	ld	a0,-120(s0)
  88:	5cc000ef          	jal	654 <read>
  8c:	8c2a                	mv	s8,a0
  8e:	00a05963          	blez	a0,a0 <wc+0xa0>
  92:	00002497          	auipc	s1,0x2
  96:	fae48493          	addi	s1,s1,-82 # 2040 <buf>
  9a:	00950a33          	add	s4,a0,s1
  9e:	b7c1                	j	5e <wc+0x5e>
  a0:	01205863          	blez	s2,b0 <wc+0xb0>
  a4:	87d6                	mv	a5,s5
  a6:	012ad363          	bge	s5,s2,ac <wc+0xac>
  aa:	87ca                	mv	a5,s2
  ac:	00078a9b          	sext.w	s5,a5
  b0:	0a0c4b63          	bltz	s8,166 <wc+0x166>
  b4:	00002717          	auipc	a4,0x2
  b8:	f6c70713          	addi	a4,a4,-148 # 2020 <total_l>
  bc:	431c                	lw	a5,0(a4)
  be:	019787bb          	addw	a5,a5,s9
  c2:	c31c                	sw	a5,0(a4)
  c4:	00002717          	auipc	a4,0x2
  c8:	f5870713          	addi	a4,a4,-168 # 201c <total_w>
  cc:	431c                	lw	a5,0(a4)
  ce:	01a787bb          	addw	a5,a5,s10
  d2:	c31c                	sw	a5,0(a4)
  d4:	00002717          	auipc	a4,0x2
  d8:	f4470713          	addi	a4,a4,-188 # 2018 <total_c>
  dc:	431c                	lw	a5,0(a4)
  de:	01b787bb          	addw	a5,a5,s11
  e2:	c31c                	sw	a5,0(a4)
  e4:	00002797          	auipc	a5,0x2
  e8:	f307a783          	lw	a5,-208(a5) # 2014 <total_L>
  ec:	0157d663          	bge	a5,s5,f8 <wc+0xf8>
  f0:	00002797          	auipc	a5,0x2
  f4:	f357a223          	sw	s5,-220(a5) # 2014 <total_L>
  f8:	00002717          	auipc	a4,0x2
  fc:	f1870713          	addi	a4,a4,-232 # 2010 <file_count>
 100:	431c                	lw	a5,0(a4)
 102:	2785                	addiw	a5,a5,1
 104:	c31c                	sw	a5,0(a4)
 106:	00002797          	auipc	a5,0x2
 10a:	efa7a783          	lw	a5,-262(a5) # 2000 <show_all>
 10e:	e7ad                	bnez	a5,178 <wc+0x178>
 110:	00002797          	auipc	a5,0x2
 114:	f207a783          	lw	a5,-224(a5) # 2030 <flag_lines>
 118:	ebb5                	bnez	a5,18c <wc+0x18c>
 11a:	00002797          	auipc	a5,0x2
 11e:	f127a783          	lw	a5,-238(a5) # 202c <flag_words>
 122:	efad                	bnez	a5,19c <wc+0x19c>
 124:	00002797          	auipc	a5,0x2
 128:	f047a783          	lw	a5,-252(a5) # 2028 <flag_chars>
 12c:	e3c1                	bnez	a5,1ac <wc+0x1ac>
 12e:	00002797          	auipc	a5,0x2
 132:	ef67a783          	lw	a5,-266(a5) # 2024 <flag_longest>
 136:	e3d9                	bnez	a5,1bc <wc+0x1bc>
 138:	f8043583          	ld	a1,-128(s0)
 13c:	00001517          	auipc	a0,0x1
 140:	b8450513          	addi	a0,a0,-1148 # cc0 <malloc+0x190>
 144:	139000ef          	jal	a7c <printf>
 148:	70e6                	ld	ra,120(sp)
 14a:	7446                	ld	s0,112(sp)
 14c:	74a6                	ld	s1,104(sp)
 14e:	7906                	ld	s2,96(sp)
 150:	69e6                	ld	s3,88(sp)
 152:	6a46                	ld	s4,80(sp)
 154:	6aa6                	ld	s5,72(sp)
 156:	6b06                	ld	s6,64(sp)
 158:	7be2                	ld	s7,56(sp)
 15a:	7c42                	ld	s8,48(sp)
 15c:	7ca2                	ld	s9,40(sp)
 15e:	7d02                	ld	s10,32(sp)
 160:	6de2                	ld	s11,24(sp)
 162:	6109                	addi	sp,sp,128
 164:	8082                	ret
 166:	00001517          	auipc	a0,0x1
 16a:	ad250513          	addi	a0,a0,-1326 # c38 <malloc+0x108>
 16e:	10f000ef          	jal	a7c <printf>
 172:	4505                	li	a0,1
 174:	4c8000ef          	jal	63c <exit>
 178:	86ee                	mv	a3,s11
 17a:	866a                	mv	a2,s10
 17c:	85e6                	mv	a1,s9
 17e:	00001517          	auipc	a0,0x1
 182:	aca50513          	addi	a0,a0,-1334 # c48 <malloc+0x118>
 186:	0f7000ef          	jal	a7c <printf>
 18a:	b77d                	j	138 <wc+0x138>
 18c:	85e6                	mv	a1,s9
 18e:	00001517          	auipc	a0,0x1
 192:	aca50513          	addi	a0,a0,-1334 # c58 <malloc+0x128>
 196:	0e7000ef          	jal	a7c <printf>
 19a:	b741                	j	11a <wc+0x11a>
 19c:	85ea                	mv	a1,s10
 19e:	00001517          	auipc	a0,0x1
 1a2:	aba50513          	addi	a0,a0,-1350 # c58 <malloc+0x128>
 1a6:	0d7000ef          	jal	a7c <printf>
 1aa:	bfad                	j	124 <wc+0x124>
 1ac:	85ee                	mv	a1,s11
 1ae:	00001517          	auipc	a0,0x1
 1b2:	aaa50513          	addi	a0,a0,-1366 # c58 <malloc+0x128>
 1b6:	0c7000ef          	jal	a7c <printf>
 1ba:	bf95                	j	12e <wc+0x12e>
 1bc:	85d6                	mv	a1,s5
 1be:	00001517          	auipc	a0,0x1
 1c2:	a9a50513          	addi	a0,a0,-1382 # c58 <malloc+0x128>
 1c6:	0b7000ef          	jal	a7c <printf>
 1ca:	b7bd                	j	138 <wc+0x138>

00000000000001cc <main>:
 1cc:	7179                	addi	sp,sp,-48
 1ce:	f406                	sd	ra,40(sp)
 1d0:	f022                	sd	s0,32(sp)
 1d2:	ec26                	sd	s1,24(sp)
 1d4:	e84a                	sd	s2,16(sp)
 1d6:	1800                	addi	s0,sp,48
 1d8:	4785                	li	a5,1
 1da:	14a7d763          	bge	a5,a0,328 <main+0x15c>
 1de:	80ae                	mv	ra,a1
 1e0:	00858f93          	addi	t6,a1,8
 1e4:	4285                	li	t0,1
 1e6:	02d00913          	li	s2,45
 1ea:	06c00713          	li	a4,108
 1ee:	07700813          	li	a6,119
 1f2:	06300893          	li	a7,99
 1f6:	04c00e13          	li	t3,76
 1fa:	00002e97          	auipc	t4,0x2
 1fe:	e2ae8e93          	addi	t4,t4,-470 # 2024 <flag_longest>
 202:	4605                	li	a2,1
 204:	00002397          	auipc	t2,0x2
 208:	e2438393          	addi	t2,t2,-476 # 2028 <flag_chars>
 20c:	00002f17          	auipc	t5,0x2
 210:	e20f0f13          	addi	t5,t5,-480 # 202c <flag_words>
 214:	00002317          	auipc	t1,0x2
 218:	e1c30313          	addi	t1,t1,-484 # 2030 <flag_lines>
 21c:	00002697          	auipc	a3,0x2
 220:	de468693          	addi	a3,a3,-540 # 2000 <show_all>
 224:	a8b1                	j	280 <main+0xb4>
 226:	00c32023          	sw	a2,0(t1)
 22a:	0006a023          	sw	zero,0(a3)
 22e:	0785                	addi	a5,a5,1
 230:	fff7c583          	lbu	a1,-1(a5)
 234:	c1b1                	beqz	a1,278 <main+0xac>
 236:	fee588e3          	beq	a1,a4,226 <main+0x5a>
 23a:	01058963          	beq	a1,a6,24c <main+0x80>
 23e:	01158a63          	beq	a1,a7,252 <main+0x86>
 242:	01c59b63          	bne	a1,t3,258 <main+0x8c>
 246:	00cea023          	sw	a2,0(t4)
 24a:	b7c5                	j	22a <main+0x5e>
 24c:	00cf2023          	sw	a2,0(t5)
 250:	bfe9                	j	22a <main+0x5e>
 252:	00c3a023          	sw	a2,0(t2)
 256:	bfd1                	j	22a <main+0x5e>
 258:	e44e                	sd	s3,8(sp)
 25a:	00001517          	auipc	a0,0x1
 25e:	a0650513          	addi	a0,a0,-1530 # c60 <malloc+0x130>
 262:	01b000ef          	jal	a7c <printf>
 266:	00001517          	auipc	a0,0x1
 26a:	a1a50513          	addi	a0,a0,-1510 # c80 <malloc+0x150>
 26e:	00f000ef          	jal	a7c <printf>
 272:	4505                	li	a0,1
 274:	3c8000ef          	jal	63c <exit>
 278:	2285                	addiw	t0,t0,1
 27a:	0fa1                	addi	t6,t6,8
 27c:	0a550663          	beq	a0,t0,328 <main+0x15c>
 280:	000fb783          	ld	a5,0(t6)
 284:	0007c483          	lbu	s1,0(a5)
 288:	01249763          	bne	s1,s2,296 <main+0xca>
 28c:	0017c583          	lbu	a1,1(a5)
 290:	0789                	addi	a5,a5,2
 292:	f1d5                	bnez	a1,236 <main+0x6a>
 294:	b7d5                	j	278 <main+0xac>
 296:	08a2d963          	bge	t0,a0,328 <main+0x15c>
 29a:	e44e                	sd	s3,8(sp)
 29c:	00329913          	slli	s2,t0,0x3
 2a0:	9906                	add	s2,s2,ra
 2a2:	405507bb          	subw	a5,a0,t0
 2a6:	1782                	slli	a5,a5,0x20
 2a8:	9381                	srli	a5,a5,0x20
 2aa:	9796                	add	a5,a5,t0
 2ac:	078e                	slli	a5,a5,0x3
 2ae:	00f089b3          	add	s3,ra,a5
 2b2:	4581                	li	a1,0
 2b4:	00093503          	ld	a0,0(s2)
 2b8:	3c4000ef          	jal	67c <open>
 2bc:	84aa                	mv	s1,a0
 2be:	08054063          	bltz	a0,33e <main+0x172>
 2c2:	00093583          	ld	a1,0(s2)
 2c6:	d3bff0ef          	jal	0 <wc>
 2ca:	8526                	mv	a0,s1
 2cc:	398000ef          	jal	664 <close>
 2d0:	0921                	addi	s2,s2,8
 2d2:	ff3910e3          	bne	s2,s3,2b2 <main+0xe6>
 2d6:	00002717          	auipc	a4,0x2
 2da:	d3a72703          	lw	a4,-710(a4) # 2010 <file_count>
 2de:	4785                	li	a5,1
 2e0:	04e7d163          	bge	a5,a4,322 <main+0x156>
 2e4:	00002797          	auipc	a5,0x2
 2e8:	d1c7a783          	lw	a5,-740(a5) # 2000 <show_all>
 2ec:	e7a5                	bnez	a5,354 <main+0x188>
 2ee:	00002797          	auipc	a5,0x2
 2f2:	d427a783          	lw	a5,-702(a5) # 2030 <flag_lines>
 2f6:	e3d1                	bnez	a5,37a <main+0x1ae>
 2f8:	00002797          	auipc	a5,0x2
 2fc:	d347a783          	lw	a5,-716(a5) # 202c <flag_words>
 300:	ebc1                	bnez	a5,390 <main+0x1c4>
 302:	00002797          	auipc	a5,0x2
 306:	d267a783          	lw	a5,-730(a5) # 2028 <flag_chars>
 30a:	efd1                	bnez	a5,3a6 <main+0x1da>
 30c:	00002797          	auipc	a5,0x2
 310:	d187a783          	lw	a5,-744(a5) # 2024 <flag_longest>
 314:	e7c5                	bnez	a5,3bc <main+0x1f0>
 316:	00001517          	auipc	a0,0x1
 31a:	9b250513          	addi	a0,a0,-1614 # cc8 <malloc+0x198>
 31e:	75e000ef          	jal	a7c <printf>
 322:	4501                	li	a0,0
 324:	318000ef          	jal	63c <exit>
 328:	e44e                	sd	s3,8(sp)
 32a:	00001597          	auipc	a1,0x1
 32e:	92658593          	addi	a1,a1,-1754 # c50 <malloc+0x120>
 332:	4501                	li	a0,0
 334:	ccdff0ef          	jal	0 <wc>
 338:	4501                	li	a0,0
 33a:	302000ef          	jal	63c <exit>
 33e:	00093583          	ld	a1,0(s2)
 342:	00001517          	auipc	a0,0x1
 346:	96e50513          	addi	a0,a0,-1682 # cb0 <malloc+0x180>
 34a:	732000ef          	jal	a7c <printf>
 34e:	4505                	li	a0,1
 350:	2ec000ef          	jal	63c <exit>
 354:	00002697          	auipc	a3,0x2
 358:	cc46a683          	lw	a3,-828(a3) # 2018 <total_c>
 35c:	00002617          	auipc	a2,0x2
 360:	cc062603          	lw	a2,-832(a2) # 201c <total_w>
 364:	00002597          	auipc	a1,0x2
 368:	cbc5a583          	lw	a1,-836(a1) # 2020 <total_l>
 36c:	00001517          	auipc	a0,0x1
 370:	8dc50513          	addi	a0,a0,-1828 # c48 <malloc+0x118>
 374:	708000ef          	jal	a7c <printf>
 378:	bf79                	j	316 <main+0x14a>
 37a:	00002597          	auipc	a1,0x2
 37e:	ca65a583          	lw	a1,-858(a1) # 2020 <total_l>
 382:	00001517          	auipc	a0,0x1
 386:	8d650513          	addi	a0,a0,-1834 # c58 <malloc+0x128>
 38a:	6f2000ef          	jal	a7c <printf>
 38e:	b7ad                	j	2f8 <main+0x12c>
 390:	00002597          	auipc	a1,0x2
 394:	c8c5a583          	lw	a1,-884(a1) # 201c <total_w>
 398:	00001517          	auipc	a0,0x1
 39c:	8c050513          	addi	a0,a0,-1856 # c58 <malloc+0x128>
 3a0:	6dc000ef          	jal	a7c <printf>
 3a4:	bfb9                	j	302 <main+0x136>
 3a6:	00002597          	auipc	a1,0x2
 3aa:	c725a583          	lw	a1,-910(a1) # 2018 <total_c>
 3ae:	00001517          	auipc	a0,0x1
 3b2:	8aa50513          	addi	a0,a0,-1878 # c58 <malloc+0x128>
 3b6:	6c6000ef          	jal	a7c <printf>
 3ba:	bf89                	j	30c <main+0x140>
 3bc:	00002597          	auipc	a1,0x2
 3c0:	c585a583          	lw	a1,-936(a1) # 2014 <total_L>
 3c4:	00001517          	auipc	a0,0x1
 3c8:	89450513          	addi	a0,a0,-1900 # c58 <malloc+0x128>
 3cc:	6b0000ef          	jal	a7c <printf>
 3d0:	b799                	j	316 <main+0x14a>

00000000000003d2 <start>:
 3d2:	1141                	addi	sp,sp,-16
 3d4:	e406                	sd	ra,8(sp)
 3d6:	e022                	sd	s0,0(sp)
 3d8:	0800                	addi	s0,sp,16
 3da:	df3ff0ef          	jal	1cc <main>
 3de:	4501                	li	a0,0
 3e0:	25c000ef          	jal	63c <exit>

00000000000003e4 <strcpy>:
 3e4:	1141                	addi	sp,sp,-16
 3e6:	e422                	sd	s0,8(sp)
 3e8:	0800                	addi	s0,sp,16
 3ea:	87aa                	mv	a5,a0
 3ec:	0585                	addi	a1,a1,1
 3ee:	0785                	addi	a5,a5,1
 3f0:	fff5c703          	lbu	a4,-1(a1)
 3f4:	fee78fa3          	sb	a4,-1(a5)
 3f8:	fb75                	bnez	a4,3ec <strcpy+0x8>
 3fa:	6422                	ld	s0,8(sp)
 3fc:	0141                	addi	sp,sp,16
 3fe:	8082                	ret

0000000000000400 <strcmp>:
 400:	1141                	addi	sp,sp,-16
 402:	e422                	sd	s0,8(sp)
 404:	0800                	addi	s0,sp,16
 406:	00054783          	lbu	a5,0(a0)
 40a:	cb91                	beqz	a5,41e <strcmp+0x1e>
 40c:	0005c703          	lbu	a4,0(a1)
 410:	00f71763          	bne	a4,a5,41e <strcmp+0x1e>
 414:	0505                	addi	a0,a0,1
 416:	0585                	addi	a1,a1,1
 418:	00054783          	lbu	a5,0(a0)
 41c:	fbe5                	bnez	a5,40c <strcmp+0xc>
 41e:	0005c503          	lbu	a0,0(a1)
 422:	40a7853b          	subw	a0,a5,a0
 426:	6422                	ld	s0,8(sp)
 428:	0141                	addi	sp,sp,16
 42a:	8082                	ret

000000000000042c <strlen>:
 42c:	1141                	addi	sp,sp,-16
 42e:	e422                	sd	s0,8(sp)
 430:	0800                	addi	s0,sp,16
 432:	00054783          	lbu	a5,0(a0)
 436:	cf91                	beqz	a5,452 <strlen+0x26>
 438:	0505                	addi	a0,a0,1
 43a:	87aa                	mv	a5,a0
 43c:	86be                	mv	a3,a5
 43e:	0785                	addi	a5,a5,1
 440:	fff7c703          	lbu	a4,-1(a5)
 444:	ff65                	bnez	a4,43c <strlen+0x10>
 446:	40a6853b          	subw	a0,a3,a0
 44a:	2505                	addiw	a0,a0,1
 44c:	6422                	ld	s0,8(sp)
 44e:	0141                	addi	sp,sp,16
 450:	8082                	ret
 452:	4501                	li	a0,0
 454:	bfe5                	j	44c <strlen+0x20>

0000000000000456 <memset>:
 456:	1141                	addi	sp,sp,-16
 458:	e422                	sd	s0,8(sp)
 45a:	0800                	addi	s0,sp,16
 45c:	ca19                	beqz	a2,472 <memset+0x1c>
 45e:	87aa                	mv	a5,a0
 460:	1602                	slli	a2,a2,0x20
 462:	9201                	srli	a2,a2,0x20
 464:	00a60733          	add	a4,a2,a0
 468:	00b78023          	sb	a1,0(a5)
 46c:	0785                	addi	a5,a5,1
 46e:	fee79de3          	bne	a5,a4,468 <memset+0x12>
 472:	6422                	ld	s0,8(sp)
 474:	0141                	addi	sp,sp,16
 476:	8082                	ret

0000000000000478 <strchr>:
 478:	1141                	addi	sp,sp,-16
 47a:	e422                	sd	s0,8(sp)
 47c:	0800                	addi	s0,sp,16
 47e:	00054783          	lbu	a5,0(a0)
 482:	cb99                	beqz	a5,498 <strchr+0x20>
 484:	00f58763          	beq	a1,a5,492 <strchr+0x1a>
 488:	0505                	addi	a0,a0,1
 48a:	00054783          	lbu	a5,0(a0)
 48e:	fbfd                	bnez	a5,484 <strchr+0xc>
 490:	4501                	li	a0,0
 492:	6422                	ld	s0,8(sp)
 494:	0141                	addi	sp,sp,16
 496:	8082                	ret
 498:	4501                	li	a0,0
 49a:	bfe5                	j	492 <strchr+0x1a>

000000000000049c <gets>:
 49c:	711d                	addi	sp,sp,-96
 49e:	ec86                	sd	ra,88(sp)
 4a0:	e8a2                	sd	s0,80(sp)
 4a2:	e4a6                	sd	s1,72(sp)
 4a4:	e0ca                	sd	s2,64(sp)
 4a6:	fc4e                	sd	s3,56(sp)
 4a8:	f852                	sd	s4,48(sp)
 4aa:	f456                	sd	s5,40(sp)
 4ac:	f05a                	sd	s6,32(sp)
 4ae:	ec5e                	sd	s7,24(sp)
 4b0:	1080                	addi	s0,sp,96
 4b2:	8baa                	mv	s7,a0
 4b4:	8a2e                	mv	s4,a1
 4b6:	892a                	mv	s2,a0
 4b8:	4481                	li	s1,0
 4ba:	4aa9                	li	s5,10
 4bc:	4b35                	li	s6,13
 4be:	89a6                	mv	s3,s1
 4c0:	2485                	addiw	s1,s1,1
 4c2:	0344d663          	bge	s1,s4,4ee <gets+0x52>
 4c6:	4605                	li	a2,1
 4c8:	faf40593          	addi	a1,s0,-81
 4cc:	4501                	li	a0,0
 4ce:	186000ef          	jal	654 <read>
 4d2:	00a05e63          	blez	a0,4ee <gets+0x52>
 4d6:	faf44783          	lbu	a5,-81(s0)
 4da:	00f90023          	sb	a5,0(s2)
 4de:	01578763          	beq	a5,s5,4ec <gets+0x50>
 4e2:	0905                	addi	s2,s2,1
 4e4:	fd679de3          	bne	a5,s6,4be <gets+0x22>
 4e8:	89a6                	mv	s3,s1
 4ea:	a011                	j	4ee <gets+0x52>
 4ec:	89a6                	mv	s3,s1
 4ee:	99de                	add	s3,s3,s7
 4f0:	00098023          	sb	zero,0(s3)
 4f4:	855e                	mv	a0,s7
 4f6:	60e6                	ld	ra,88(sp)
 4f8:	6446                	ld	s0,80(sp)
 4fa:	64a6                	ld	s1,72(sp)
 4fc:	6906                	ld	s2,64(sp)
 4fe:	79e2                	ld	s3,56(sp)
 500:	7a42                	ld	s4,48(sp)
 502:	7aa2                	ld	s5,40(sp)
 504:	7b02                	ld	s6,32(sp)
 506:	6be2                	ld	s7,24(sp)
 508:	6125                	addi	sp,sp,96
 50a:	8082                	ret

000000000000050c <stat>:
 50c:	1101                	addi	sp,sp,-32
 50e:	ec06                	sd	ra,24(sp)
 510:	e822                	sd	s0,16(sp)
 512:	e04a                	sd	s2,0(sp)
 514:	1000                	addi	s0,sp,32
 516:	892e                	mv	s2,a1
 518:	4581                	li	a1,0
 51a:	162000ef          	jal	67c <open>
 51e:	02054263          	bltz	a0,542 <stat+0x36>
 522:	e426                	sd	s1,8(sp)
 524:	84aa                	mv	s1,a0
 526:	85ca                	mv	a1,s2
 528:	16c000ef          	jal	694 <fstat>
 52c:	892a                	mv	s2,a0
 52e:	8526                	mv	a0,s1
 530:	134000ef          	jal	664 <close>
 534:	64a2                	ld	s1,8(sp)
 536:	854a                	mv	a0,s2
 538:	60e2                	ld	ra,24(sp)
 53a:	6442                	ld	s0,16(sp)
 53c:	6902                	ld	s2,0(sp)
 53e:	6105                	addi	sp,sp,32
 540:	8082                	ret
 542:	597d                	li	s2,-1
 544:	bfcd                	j	536 <stat+0x2a>

0000000000000546 <atoi>:
 546:	1141                	addi	sp,sp,-16
 548:	e422                	sd	s0,8(sp)
 54a:	0800                	addi	s0,sp,16
 54c:	00054683          	lbu	a3,0(a0)
 550:	fd06879b          	addiw	a5,a3,-48
 554:	0ff7f793          	zext.b	a5,a5
 558:	4625                	li	a2,9
 55a:	02f66863          	bltu	a2,a5,58a <atoi+0x44>
 55e:	872a                	mv	a4,a0
 560:	4501                	li	a0,0
 562:	0705                	addi	a4,a4,1
 564:	0025179b          	slliw	a5,a0,0x2
 568:	9fa9                	addw	a5,a5,a0
 56a:	0017979b          	slliw	a5,a5,0x1
 56e:	9fb5                	addw	a5,a5,a3
 570:	fd07851b          	addiw	a0,a5,-48
 574:	00074683          	lbu	a3,0(a4)
 578:	fd06879b          	addiw	a5,a3,-48
 57c:	0ff7f793          	zext.b	a5,a5
 580:	fef671e3          	bgeu	a2,a5,562 <atoi+0x1c>
 584:	6422                	ld	s0,8(sp)
 586:	0141                	addi	sp,sp,16
 588:	8082                	ret
 58a:	4501                	li	a0,0
 58c:	bfe5                	j	584 <atoi+0x3e>

000000000000058e <memmove>:
 58e:	1141                	addi	sp,sp,-16
 590:	e422                	sd	s0,8(sp)
 592:	0800                	addi	s0,sp,16
 594:	02b57463          	bgeu	a0,a1,5bc <memmove+0x2e>
 598:	00c05f63          	blez	a2,5b6 <memmove+0x28>
 59c:	1602                	slli	a2,a2,0x20
 59e:	9201                	srli	a2,a2,0x20
 5a0:	00c507b3          	add	a5,a0,a2
 5a4:	872a                	mv	a4,a0
 5a6:	0585                	addi	a1,a1,1
 5a8:	0705                	addi	a4,a4,1
 5aa:	fff5c683          	lbu	a3,-1(a1)
 5ae:	fed70fa3          	sb	a3,-1(a4)
 5b2:	fef71ae3          	bne	a4,a5,5a6 <memmove+0x18>
 5b6:	6422                	ld	s0,8(sp)
 5b8:	0141                	addi	sp,sp,16
 5ba:	8082                	ret
 5bc:	00c50733          	add	a4,a0,a2
 5c0:	95b2                	add	a1,a1,a2
 5c2:	fec05ae3          	blez	a2,5b6 <memmove+0x28>
 5c6:	fff6079b          	addiw	a5,a2,-1
 5ca:	1782                	slli	a5,a5,0x20
 5cc:	9381                	srli	a5,a5,0x20
 5ce:	fff7c793          	not	a5,a5
 5d2:	97ba                	add	a5,a5,a4
 5d4:	15fd                	addi	a1,a1,-1
 5d6:	177d                	addi	a4,a4,-1
 5d8:	0005c683          	lbu	a3,0(a1)
 5dc:	00d70023          	sb	a3,0(a4)
 5e0:	fee79ae3          	bne	a5,a4,5d4 <memmove+0x46>
 5e4:	bfc9                	j	5b6 <memmove+0x28>

00000000000005e6 <memcmp>:
 5e6:	1141                	addi	sp,sp,-16
 5e8:	e422                	sd	s0,8(sp)
 5ea:	0800                	addi	s0,sp,16
 5ec:	ca05                	beqz	a2,61c <memcmp+0x36>
 5ee:	fff6069b          	addiw	a3,a2,-1
 5f2:	1682                	slli	a3,a3,0x20
 5f4:	9281                	srli	a3,a3,0x20
 5f6:	0685                	addi	a3,a3,1
 5f8:	96aa                	add	a3,a3,a0
 5fa:	00054783          	lbu	a5,0(a0)
 5fe:	0005c703          	lbu	a4,0(a1)
 602:	00e79863          	bne	a5,a4,612 <memcmp+0x2c>
 606:	0505                	addi	a0,a0,1
 608:	0585                	addi	a1,a1,1
 60a:	fed518e3          	bne	a0,a3,5fa <memcmp+0x14>
 60e:	4501                	li	a0,0
 610:	a019                	j	616 <memcmp+0x30>
 612:	40e7853b          	subw	a0,a5,a4
 616:	6422                	ld	s0,8(sp)
 618:	0141                	addi	sp,sp,16
 61a:	8082                	ret
 61c:	4501                	li	a0,0
 61e:	bfe5                	j	616 <memcmp+0x30>

0000000000000620 <memcpy>:
 620:	1141                	addi	sp,sp,-16
 622:	e406                	sd	ra,8(sp)
 624:	e022                	sd	s0,0(sp)
 626:	0800                	addi	s0,sp,16
 628:	f67ff0ef          	jal	58e <memmove>
 62c:	60a2                	ld	ra,8(sp)
 62e:	6402                	ld	s0,0(sp)
 630:	0141                	addi	sp,sp,16
 632:	8082                	ret

0000000000000634 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 634:	4885                	li	a7,1
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <exit>:
.global exit
exit:
 li a7, SYS_exit
 63c:	4889                	li	a7,2
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <wait>:
.global wait
wait:
 li a7, SYS_wait
 644:	488d                	li	a7,3
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 64c:	4891                	li	a7,4
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <read>:
.global read
read:
 li a7, SYS_read
 654:	4895                	li	a7,5
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <write>:
.global write
write:
 li a7, SYS_write
 65c:	48c1                	li	a7,16
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <close>:
.global close
close:
 li a7, SYS_close
 664:	48d5                	li	a7,21
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <kill>:
.global kill
kill:
 li a7, SYS_kill
 66c:	4899                	li	a7,6
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <exec>:
.global exec
exec:
 li a7, SYS_exec
 674:	489d                	li	a7,7
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <open>:
.global open
open:
 li a7, SYS_open
 67c:	48bd                	li	a7,15
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 684:	48c5                	li	a7,17
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 68c:	48c9                	li	a7,18
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 694:	48a1                	li	a7,8
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <link>:
.global link
link:
 li a7, SYS_link
 69c:	48cd                	li	a7,19
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6a4:	48d1                	li	a7,20
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6ac:	48a5                	li	a7,9
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6b4:	48a9                	li	a7,10
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6bc:	48ad                	li	a7,11
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6c4:	48b1                	li	a7,12
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6cc:	48b5                	li	a7,13
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6d4:	48b9                	li	a7,14
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 6dc:	48d9                	li	a7,22
 ecall
 6de:	00000073          	ecall
 ret
 6e2:	8082                	ret

00000000000006e4 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 6e4:	48dd                	li	a7,23
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 6ec:	48e1                	li	a7,24
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 6f4:	48e5                	li	a7,25
 ecall
 6f6:	00000073          	ecall
 ret
 6fa:	8082                	ret

00000000000006fc <rand>:
.global rand
rand:
 li a7, SYS_rand
 6fc:	48ed                	li	a7,27
 ecall
 6fe:	00000073          	ecall
 ret
 702:	8082                	ret

0000000000000704 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 704:	1101                	addi	sp,sp,-32
 706:	ec06                	sd	ra,24(sp)
 708:	e822                	sd	s0,16(sp)
 70a:	1000                	addi	s0,sp,32
 70c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 710:	4605                	li	a2,1
 712:	fef40593          	addi	a1,s0,-17
 716:	f47ff0ef          	jal	65c <write>
}
 71a:	60e2                	ld	ra,24(sp)
 71c:	6442                	ld	s0,16(sp)
 71e:	6105                	addi	sp,sp,32
 720:	8082                	ret

0000000000000722 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 722:	7139                	addi	sp,sp,-64
 724:	fc06                	sd	ra,56(sp)
 726:	f822                	sd	s0,48(sp)
 728:	f426                	sd	s1,40(sp)
 72a:	0080                	addi	s0,sp,64
 72c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 72e:	c299                	beqz	a3,734 <printint+0x12>
 730:	0805c963          	bltz	a1,7c2 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 734:	2581                	sext.w	a1,a1
  neg = 0;
 736:	4881                	li	a7,0
 738:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 73c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 73e:	2601                	sext.w	a2,a2
 740:	00000517          	auipc	a0,0x0
 744:	59850513          	addi	a0,a0,1432 # cd8 <digits>
 748:	883a                	mv	a6,a4
 74a:	2705                	addiw	a4,a4,1
 74c:	02c5f7bb          	remuw	a5,a1,a2
 750:	1782                	slli	a5,a5,0x20
 752:	9381                	srli	a5,a5,0x20
 754:	97aa                	add	a5,a5,a0
 756:	0007c783          	lbu	a5,0(a5)
 75a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 75e:	0005879b          	sext.w	a5,a1
 762:	02c5d5bb          	divuw	a1,a1,a2
 766:	0685                	addi	a3,a3,1
 768:	fec7f0e3          	bgeu	a5,a2,748 <printint+0x26>
  if(neg)
 76c:	00088c63          	beqz	a7,784 <printint+0x62>
    buf[i++] = '-';
 770:	fd070793          	addi	a5,a4,-48
 774:	00878733          	add	a4,a5,s0
 778:	02d00793          	li	a5,45
 77c:	fef70823          	sb	a5,-16(a4)
 780:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 784:	02e05a63          	blez	a4,7b8 <printint+0x96>
 788:	f04a                	sd	s2,32(sp)
 78a:	ec4e                	sd	s3,24(sp)
 78c:	fc040793          	addi	a5,s0,-64
 790:	00e78933          	add	s2,a5,a4
 794:	fff78993          	addi	s3,a5,-1
 798:	99ba                	add	s3,s3,a4
 79a:	377d                	addiw	a4,a4,-1
 79c:	1702                	slli	a4,a4,0x20
 79e:	9301                	srli	a4,a4,0x20
 7a0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 7a4:	fff94583          	lbu	a1,-1(s2)
 7a8:	8526                	mv	a0,s1
 7aa:	f5bff0ef          	jal	704 <putc>
  while(--i >= 0)
 7ae:	197d                	addi	s2,s2,-1
 7b0:	ff391ae3          	bne	s2,s3,7a4 <printint+0x82>
 7b4:	7902                	ld	s2,32(sp)
 7b6:	69e2                	ld	s3,24(sp)
}
 7b8:	70e2                	ld	ra,56(sp)
 7ba:	7442                	ld	s0,48(sp)
 7bc:	74a2                	ld	s1,40(sp)
 7be:	6121                	addi	sp,sp,64
 7c0:	8082                	ret
    x = -xx;
 7c2:	40b005bb          	negw	a1,a1
    neg = 1;
 7c6:	4885                	li	a7,1
    x = -xx;
 7c8:	bf85                	j	738 <printint+0x16>

00000000000007ca <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7ca:	711d                	addi	sp,sp,-96
 7cc:	ec86                	sd	ra,88(sp)
 7ce:	e8a2                	sd	s0,80(sp)
 7d0:	e0ca                	sd	s2,64(sp)
 7d2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7d4:	0005c903          	lbu	s2,0(a1)
 7d8:	26090863          	beqz	s2,a48 <vprintf+0x27e>
 7dc:	e4a6                	sd	s1,72(sp)
 7de:	fc4e                	sd	s3,56(sp)
 7e0:	f852                	sd	s4,48(sp)
 7e2:	f456                	sd	s5,40(sp)
 7e4:	f05a                	sd	s6,32(sp)
 7e6:	ec5e                	sd	s7,24(sp)
 7e8:	e862                	sd	s8,16(sp)
 7ea:	e466                	sd	s9,8(sp)
 7ec:	8b2a                	mv	s6,a0
 7ee:	8a2e                	mv	s4,a1
 7f0:	8bb2                	mv	s7,a2
  state = 0;
 7f2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 7f4:	4481                	li	s1,0
 7f6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 7f8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 7fc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 800:	06c00c93          	li	s9,108
 804:	a005                	j	824 <vprintf+0x5a>
        putc(fd, c0);
 806:	85ca                	mv	a1,s2
 808:	855a                	mv	a0,s6
 80a:	efbff0ef          	jal	704 <putc>
 80e:	a019                	j	814 <vprintf+0x4a>
    } else if(state == '%'){
 810:	03598263          	beq	s3,s5,834 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 814:	2485                	addiw	s1,s1,1
 816:	8726                	mv	a4,s1
 818:	009a07b3          	add	a5,s4,s1
 81c:	0007c903          	lbu	s2,0(a5)
 820:	20090c63          	beqz	s2,a38 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 824:	0009079b          	sext.w	a5,s2
    if(state == 0){
 828:	fe0994e3          	bnez	s3,810 <vprintf+0x46>
      if(c0 == '%'){
 82c:	fd579de3          	bne	a5,s5,806 <vprintf+0x3c>
        state = '%';
 830:	89be                	mv	s3,a5
 832:	b7cd                	j	814 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 834:	00ea06b3          	add	a3,s4,a4
 838:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 83c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 83e:	c681                	beqz	a3,846 <vprintf+0x7c>
 840:	9752                	add	a4,a4,s4
 842:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 846:	03878f63          	beq	a5,s8,884 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 84a:	05978963          	beq	a5,s9,89c <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 84e:	07500713          	li	a4,117
 852:	0ee78363          	beq	a5,a4,938 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 856:	07800713          	li	a4,120
 85a:	12e78563          	beq	a5,a4,984 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 85e:	07000713          	li	a4,112
 862:	14e78a63          	beq	a5,a4,9b6 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 866:	07300713          	li	a4,115
 86a:	18e78a63          	beq	a5,a4,9fe <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 86e:	02500713          	li	a4,37
 872:	04e79563          	bne	a5,a4,8bc <vprintf+0xf2>
        putc(fd, '%');
 876:	02500593          	li	a1,37
 87a:	855a                	mv	a0,s6
 87c:	e89ff0ef          	jal	704 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 880:	4981                	li	s3,0
 882:	bf49                	j	814 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 884:	008b8913          	addi	s2,s7,8
 888:	4685                	li	a3,1
 88a:	4629                	li	a2,10
 88c:	000ba583          	lw	a1,0(s7)
 890:	855a                	mv	a0,s6
 892:	e91ff0ef          	jal	722 <printint>
 896:	8bca                	mv	s7,s2
      state = 0;
 898:	4981                	li	s3,0
 89a:	bfad                	j	814 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 89c:	06400793          	li	a5,100
 8a0:	02f68963          	beq	a3,a5,8d2 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8a4:	06c00793          	li	a5,108
 8a8:	04f68263          	beq	a3,a5,8ec <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 8ac:	07500793          	li	a5,117
 8b0:	0af68063          	beq	a3,a5,950 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 8b4:	07800793          	li	a5,120
 8b8:	0ef68263          	beq	a3,a5,99c <vprintf+0x1d2>
        putc(fd, '%');
 8bc:	02500593          	li	a1,37
 8c0:	855a                	mv	a0,s6
 8c2:	e43ff0ef          	jal	704 <putc>
        putc(fd, c0);
 8c6:	85ca                	mv	a1,s2
 8c8:	855a                	mv	a0,s6
 8ca:	e3bff0ef          	jal	704 <putc>
      state = 0;
 8ce:	4981                	li	s3,0
 8d0:	b791                	j	814 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8d2:	008b8913          	addi	s2,s7,8
 8d6:	4685                	li	a3,1
 8d8:	4629                	li	a2,10
 8da:	000ba583          	lw	a1,0(s7)
 8de:	855a                	mv	a0,s6
 8e0:	e43ff0ef          	jal	722 <printint>
        i += 1;
 8e4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 8e6:	8bca                	mv	s7,s2
      state = 0;
 8e8:	4981                	li	s3,0
        i += 1;
 8ea:	b72d                	j	814 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8ec:	06400793          	li	a5,100
 8f0:	02f60763          	beq	a2,a5,91e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8f4:	07500793          	li	a5,117
 8f8:	06f60963          	beq	a2,a5,96a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8fc:	07800793          	li	a5,120
 900:	faf61ee3          	bne	a2,a5,8bc <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 904:	008b8913          	addi	s2,s7,8
 908:	4681                	li	a3,0
 90a:	4641                	li	a2,16
 90c:	000ba583          	lw	a1,0(s7)
 910:	855a                	mv	a0,s6
 912:	e11ff0ef          	jal	722 <printint>
        i += 2;
 916:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 918:	8bca                	mv	s7,s2
      state = 0;
 91a:	4981                	li	s3,0
        i += 2;
 91c:	bde5                	j	814 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 91e:	008b8913          	addi	s2,s7,8
 922:	4685                	li	a3,1
 924:	4629                	li	a2,10
 926:	000ba583          	lw	a1,0(s7)
 92a:	855a                	mv	a0,s6
 92c:	df7ff0ef          	jal	722 <printint>
        i += 2;
 930:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 932:	8bca                	mv	s7,s2
      state = 0;
 934:	4981                	li	s3,0
        i += 2;
 936:	bdf9                	j	814 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 938:	008b8913          	addi	s2,s7,8
 93c:	4681                	li	a3,0
 93e:	4629                	li	a2,10
 940:	000ba583          	lw	a1,0(s7)
 944:	855a                	mv	a0,s6
 946:	dddff0ef          	jal	722 <printint>
 94a:	8bca                	mv	s7,s2
      state = 0;
 94c:	4981                	li	s3,0
 94e:	b5d9                	j	814 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 950:	008b8913          	addi	s2,s7,8
 954:	4681                	li	a3,0
 956:	4629                	li	a2,10
 958:	000ba583          	lw	a1,0(s7)
 95c:	855a                	mv	a0,s6
 95e:	dc5ff0ef          	jal	722 <printint>
        i += 1;
 962:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 964:	8bca                	mv	s7,s2
      state = 0;
 966:	4981                	li	s3,0
        i += 1;
 968:	b575                	j	814 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 96a:	008b8913          	addi	s2,s7,8
 96e:	4681                	li	a3,0
 970:	4629                	li	a2,10
 972:	000ba583          	lw	a1,0(s7)
 976:	855a                	mv	a0,s6
 978:	dabff0ef          	jal	722 <printint>
        i += 2;
 97c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 97e:	8bca                	mv	s7,s2
      state = 0;
 980:	4981                	li	s3,0
        i += 2;
 982:	bd49                	j	814 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 984:	008b8913          	addi	s2,s7,8
 988:	4681                	li	a3,0
 98a:	4641                	li	a2,16
 98c:	000ba583          	lw	a1,0(s7)
 990:	855a                	mv	a0,s6
 992:	d91ff0ef          	jal	722 <printint>
 996:	8bca                	mv	s7,s2
      state = 0;
 998:	4981                	li	s3,0
 99a:	bdad                	j	814 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 99c:	008b8913          	addi	s2,s7,8
 9a0:	4681                	li	a3,0
 9a2:	4641                	li	a2,16
 9a4:	000ba583          	lw	a1,0(s7)
 9a8:	855a                	mv	a0,s6
 9aa:	d79ff0ef          	jal	722 <printint>
        i += 1;
 9ae:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 9b0:	8bca                	mv	s7,s2
      state = 0;
 9b2:	4981                	li	s3,0
        i += 1;
 9b4:	b585                	j	814 <vprintf+0x4a>
 9b6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 9b8:	008b8d13          	addi	s10,s7,8
 9bc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 9c0:	03000593          	li	a1,48
 9c4:	855a                	mv	a0,s6
 9c6:	d3fff0ef          	jal	704 <putc>
  putc(fd, 'x');
 9ca:	07800593          	li	a1,120
 9ce:	855a                	mv	a0,s6
 9d0:	d35ff0ef          	jal	704 <putc>
 9d4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9d6:	00000b97          	auipc	s7,0x0
 9da:	302b8b93          	addi	s7,s7,770 # cd8 <digits>
 9de:	03c9d793          	srli	a5,s3,0x3c
 9e2:	97de                	add	a5,a5,s7
 9e4:	0007c583          	lbu	a1,0(a5)
 9e8:	855a                	mv	a0,s6
 9ea:	d1bff0ef          	jal	704 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9ee:	0992                	slli	s3,s3,0x4
 9f0:	397d                	addiw	s2,s2,-1
 9f2:	fe0916e3          	bnez	s2,9de <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 9f6:	8bea                	mv	s7,s10
      state = 0;
 9f8:	4981                	li	s3,0
 9fa:	6d02                	ld	s10,0(sp)
 9fc:	bd21                	j	814 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 9fe:	008b8993          	addi	s3,s7,8
 a02:	000bb903          	ld	s2,0(s7)
 a06:	00090f63          	beqz	s2,a24 <vprintf+0x25a>
        for(; *s; s++)
 a0a:	00094583          	lbu	a1,0(s2)
 a0e:	c195                	beqz	a1,a32 <vprintf+0x268>
          putc(fd, *s);
 a10:	855a                	mv	a0,s6
 a12:	cf3ff0ef          	jal	704 <putc>
        for(; *s; s++)
 a16:	0905                	addi	s2,s2,1
 a18:	00094583          	lbu	a1,0(s2)
 a1c:	f9f5                	bnez	a1,a10 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 a1e:	8bce                	mv	s7,s3
      state = 0;
 a20:	4981                	li	s3,0
 a22:	bbcd                	j	814 <vprintf+0x4a>
          s = "(null)";
 a24:	00000917          	auipc	s2,0x0
 a28:	2ac90913          	addi	s2,s2,684 # cd0 <malloc+0x1a0>
        for(; *s; s++)
 a2c:	02800593          	li	a1,40
 a30:	b7c5                	j	a10 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 a32:	8bce                	mv	s7,s3
      state = 0;
 a34:	4981                	li	s3,0
 a36:	bbf9                	j	814 <vprintf+0x4a>
 a38:	64a6                	ld	s1,72(sp)
 a3a:	79e2                	ld	s3,56(sp)
 a3c:	7a42                	ld	s4,48(sp)
 a3e:	7aa2                	ld	s5,40(sp)
 a40:	7b02                	ld	s6,32(sp)
 a42:	6be2                	ld	s7,24(sp)
 a44:	6c42                	ld	s8,16(sp)
 a46:	6ca2                	ld	s9,8(sp)
    }
  }
}
 a48:	60e6                	ld	ra,88(sp)
 a4a:	6446                	ld	s0,80(sp)
 a4c:	6906                	ld	s2,64(sp)
 a4e:	6125                	addi	sp,sp,96
 a50:	8082                	ret

0000000000000a52 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a52:	715d                	addi	sp,sp,-80
 a54:	ec06                	sd	ra,24(sp)
 a56:	e822                	sd	s0,16(sp)
 a58:	1000                	addi	s0,sp,32
 a5a:	e010                	sd	a2,0(s0)
 a5c:	e414                	sd	a3,8(s0)
 a5e:	e818                	sd	a4,16(s0)
 a60:	ec1c                	sd	a5,24(s0)
 a62:	03043023          	sd	a6,32(s0)
 a66:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a6a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a6e:	8622                	mv	a2,s0
 a70:	d5bff0ef          	jal	7ca <vprintf>
}
 a74:	60e2                	ld	ra,24(sp)
 a76:	6442                	ld	s0,16(sp)
 a78:	6161                	addi	sp,sp,80
 a7a:	8082                	ret

0000000000000a7c <printf>:

void
printf(const char *fmt, ...)
{
 a7c:	711d                	addi	sp,sp,-96
 a7e:	ec06                	sd	ra,24(sp)
 a80:	e822                	sd	s0,16(sp)
 a82:	1000                	addi	s0,sp,32
 a84:	e40c                	sd	a1,8(s0)
 a86:	e810                	sd	a2,16(s0)
 a88:	ec14                	sd	a3,24(s0)
 a8a:	f018                	sd	a4,32(s0)
 a8c:	f41c                	sd	a5,40(s0)
 a8e:	03043823          	sd	a6,48(s0)
 a92:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a96:	00840613          	addi	a2,s0,8
 a9a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a9e:	85aa                	mv	a1,a0
 aa0:	4505                	li	a0,1
 aa2:	d29ff0ef          	jal	7ca <vprintf>
}
 aa6:	60e2                	ld	ra,24(sp)
 aa8:	6442                	ld	s0,16(sp)
 aaa:	6125                	addi	sp,sp,96
 aac:	8082                	ret

0000000000000aae <free>:
 aae:	1141                	addi	sp,sp,-16
 ab0:	e422                	sd	s0,8(sp)
 ab2:	0800                	addi	s0,sp,16
 ab4:	ff050693          	addi	a3,a0,-16
 ab8:	00001797          	auipc	a5,0x1
 abc:	5807b783          	ld	a5,1408(a5) # 2038 <freep>
 ac0:	a02d                	j	aea <free+0x3c>
 ac2:	4618                	lw	a4,8(a2)
 ac4:	9f2d                	addw	a4,a4,a1
 ac6:	fee52c23          	sw	a4,-8(a0)
 aca:	6398                	ld	a4,0(a5)
 acc:	6310                	ld	a2,0(a4)
 ace:	a83d                	j	b0c <free+0x5e>
 ad0:	ff852703          	lw	a4,-8(a0)
 ad4:	9f31                	addw	a4,a4,a2
 ad6:	c798                	sw	a4,8(a5)
 ad8:	ff053683          	ld	a3,-16(a0)
 adc:	a091                	j	b20 <free+0x72>
 ade:	6398                	ld	a4,0(a5)
 ae0:	00e7e463          	bltu	a5,a4,ae8 <free+0x3a>
 ae4:	00e6ea63          	bltu	a3,a4,af8 <free+0x4a>
 ae8:	87ba                	mv	a5,a4
 aea:	fed7fae3          	bgeu	a5,a3,ade <free+0x30>
 aee:	6398                	ld	a4,0(a5)
 af0:	00e6e463          	bltu	a3,a4,af8 <free+0x4a>
 af4:	fee7eae3          	bltu	a5,a4,ae8 <free+0x3a>
 af8:	ff852583          	lw	a1,-8(a0)
 afc:	6390                	ld	a2,0(a5)
 afe:	02059813          	slli	a6,a1,0x20
 b02:	01c85713          	srli	a4,a6,0x1c
 b06:	9736                	add	a4,a4,a3
 b08:	fae60de3          	beq	a2,a4,ac2 <free+0x14>
 b0c:	fec53823          	sd	a2,-16(a0)
 b10:	4790                	lw	a2,8(a5)
 b12:	02061593          	slli	a1,a2,0x20
 b16:	01c5d713          	srli	a4,a1,0x1c
 b1a:	973e                	add	a4,a4,a5
 b1c:	fae68ae3          	beq	a3,a4,ad0 <free+0x22>
 b20:	e394                	sd	a3,0(a5)
 b22:	00001717          	auipc	a4,0x1
 b26:	50f73b23          	sd	a5,1302(a4) # 2038 <freep>
 b2a:	6422                	ld	s0,8(sp)
 b2c:	0141                	addi	sp,sp,16
 b2e:	8082                	ret

0000000000000b30 <malloc>:
 b30:	7139                	addi	sp,sp,-64
 b32:	fc06                	sd	ra,56(sp)
 b34:	f822                	sd	s0,48(sp)
 b36:	f426                	sd	s1,40(sp)
 b38:	ec4e                	sd	s3,24(sp)
 b3a:	0080                	addi	s0,sp,64
 b3c:	02051493          	slli	s1,a0,0x20
 b40:	9081                	srli	s1,s1,0x20
 b42:	04bd                	addi	s1,s1,15
 b44:	8091                	srli	s1,s1,0x4
 b46:	0014899b          	addiw	s3,s1,1
 b4a:	0485                	addi	s1,s1,1
 b4c:	00001517          	auipc	a0,0x1
 b50:	4ec53503          	ld	a0,1260(a0) # 2038 <freep>
 b54:	c915                	beqz	a0,b88 <malloc+0x58>
 b56:	611c                	ld	a5,0(a0)
 b58:	4798                	lw	a4,8(a5)
 b5a:	08977a63          	bgeu	a4,s1,bee <malloc+0xbe>
 b5e:	f04a                	sd	s2,32(sp)
 b60:	e852                	sd	s4,16(sp)
 b62:	e456                	sd	s5,8(sp)
 b64:	e05a                	sd	s6,0(sp)
 b66:	8a4e                	mv	s4,s3
 b68:	0009871b          	sext.w	a4,s3
 b6c:	6685                	lui	a3,0x1
 b6e:	00d77363          	bgeu	a4,a3,b74 <malloc+0x44>
 b72:	6a05                	lui	s4,0x1
 b74:	000a0b1b          	sext.w	s6,s4
 b78:	004a1a1b          	slliw	s4,s4,0x4
 b7c:	00001917          	auipc	s2,0x1
 b80:	4bc90913          	addi	s2,s2,1212 # 2038 <freep>
 b84:	5afd                	li	s5,-1
 b86:	a081                	j	bc6 <malloc+0x96>
 b88:	f04a                	sd	s2,32(sp)
 b8a:	e852                	sd	s4,16(sp)
 b8c:	e456                	sd	s5,8(sp)
 b8e:	e05a                	sd	s6,0(sp)
 b90:	00001797          	auipc	a5,0x1
 b94:	6b078793          	addi	a5,a5,1712 # 2240 <base>
 b98:	00001717          	auipc	a4,0x1
 b9c:	4af73023          	sd	a5,1184(a4) # 2038 <freep>
 ba0:	e39c                	sd	a5,0(a5)
 ba2:	0007a423          	sw	zero,8(a5)
 ba6:	b7c1                	j	b66 <malloc+0x36>
 ba8:	6398                	ld	a4,0(a5)
 baa:	e118                	sd	a4,0(a0)
 bac:	a8a9                	j	c06 <malloc+0xd6>
 bae:	01652423          	sw	s6,8(a0)
 bb2:	0541                	addi	a0,a0,16
 bb4:	efbff0ef          	jal	aae <free>
 bb8:	00093503          	ld	a0,0(s2)
 bbc:	c12d                	beqz	a0,c1e <malloc+0xee>
 bbe:	611c                	ld	a5,0(a0)
 bc0:	4798                	lw	a4,8(a5)
 bc2:	02977263          	bgeu	a4,s1,be6 <malloc+0xb6>
 bc6:	00093703          	ld	a4,0(s2)
 bca:	853e                	mv	a0,a5
 bcc:	fef719e3          	bne	a4,a5,bbe <malloc+0x8e>
 bd0:	8552                	mv	a0,s4
 bd2:	af3ff0ef          	jal	6c4 <sbrk>
 bd6:	fd551ce3          	bne	a0,s5,bae <malloc+0x7e>
 bda:	4501                	li	a0,0
 bdc:	7902                	ld	s2,32(sp)
 bde:	6a42                	ld	s4,16(sp)
 be0:	6aa2                	ld	s5,8(sp)
 be2:	6b02                	ld	s6,0(sp)
 be4:	a03d                	j	c12 <malloc+0xe2>
 be6:	7902                	ld	s2,32(sp)
 be8:	6a42                	ld	s4,16(sp)
 bea:	6aa2                	ld	s5,8(sp)
 bec:	6b02                	ld	s6,0(sp)
 bee:	fae48de3          	beq	s1,a4,ba8 <malloc+0x78>
 bf2:	4137073b          	subw	a4,a4,s3
 bf6:	c798                	sw	a4,8(a5)
 bf8:	02071693          	slli	a3,a4,0x20
 bfc:	01c6d713          	srli	a4,a3,0x1c
 c00:	97ba                	add	a5,a5,a4
 c02:	0137a423          	sw	s3,8(a5)
 c06:	00001717          	auipc	a4,0x1
 c0a:	42a73923          	sd	a0,1074(a4) # 2038 <freep>
 c0e:	01078513          	addi	a0,a5,16
 c12:	70e2                	ld	ra,56(sp)
 c14:	7442                	ld	s0,48(sp)
 c16:	74a2                	ld	s1,40(sp)
 c18:	69e2                	ld	s3,24(sp)
 c1a:	6121                	addi	sp,sp,64
 c1c:	8082                	ret
 c1e:	7902                	ld	s2,32(sp)
 c20:	6a42                	ld	s4,16(sp)
 c22:	6aa2                	ld	s5,8(sp)
 c24:	6b02                	ld	s6,0(sp)
 c26:	b7f5                	j	c12 <malloc+0xe2>
