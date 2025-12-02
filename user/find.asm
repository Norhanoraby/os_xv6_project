
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_help>:
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   8:	00001517          	auipc	a0,0x1
   c:	ac850513          	addi	a0,a0,-1336 # ad0 <malloc+0x104>
  10:	109000ef          	jal	918 <printf>
  14:	60a2                	ld	ra,8(sp)
  16:	6402                	ld	s0,0(sp)
  18:	0141                	addi	sp,sp,16
  1a:	8082                	ret

000000000000001c <same_name>:
  1c:	1141                	addi	sp,sp,-16
  1e:	e422                	sd	s0,8(sp)
  20:	0800                	addi	s0,sp,16
  22:	87aa                	mv	a5,a0
  24:	0539                	addi	a0,a0,14
  26:	a029                	j	30 <same_name+0x14>
  28:	0785                	addi	a5,a5,1
  2a:	0585                	addi	a1,a1,1
  2c:	00a78d63          	beq	a5,a0,46 <same_name+0x2a>
  30:	0007c703          	lbu	a4,0(a5)
  34:	0005c683          	lbu	a3,0(a1)
  38:	00e69963          	bne	a3,a4,4a <same_name+0x2e>
  3c:	f775                	bnez	a4,28 <same_name+0xc>
  3e:	4505                	li	a0,1
  40:	6422                	ld	s0,8(sp)
  42:	0141                	addi	sp,sp,16
  44:	8082                	ret
  46:	4505                	li	a0,1
  48:	bfe5                	j	40 <same_name+0x24>
  4a:	4501                	li	a0,0
  4c:	bfd5                	j	40 <same_name+0x24>

000000000000004e <find>:
  4e:	d8010113          	addi	sp,sp,-640
  52:	26113c23          	sd	ra,632(sp)
  56:	26813823          	sd	s0,624(sp)
  5a:	27213023          	sd	s2,608(sp)
  5e:	25313c23          	sd	s3,600(sp)
  62:	25513423          	sd	s5,584(sp)
  66:	0500                	addi	s0,sp,640
  68:	892a                	mv	s2,a0
  6a:	89ae                	mv	s3,a1
  6c:	4581                	li	a1,0
  6e:	4ba000ef          	jal	528 <open>
  72:	0c054863          	bltz	a0,142 <find+0xf4>
  76:	26913423          	sd	s1,616(sp)
  7a:	84aa                	mv	s1,a0
  7c:	f9840593          	addi	a1,s0,-104
  80:	4c0000ef          	jal	540 <fstat>
  84:	0c054863          	bltz	a0,154 <find+0x106>
  88:	fa041703          	lh	a4,-96(s0)
  8c:	4789                	li	a5,2
  8e:	4a81                	li	s5,0
  90:	0ef70063          	beq	a4,a5,170 <find+0x122>
  94:	25613023          	sd	s6,576(sp)
  98:	23713c23          	sd	s7,568(sp)
  9c:	00001b17          	auipc	s6,0x1
  a0:	a94b0b13          	addi	s6,s6,-1388 # b30 <malloc+0x164>
  a4:	00001b97          	auipc	s7,0x1
  a8:	a94b8b93          	addi	s7,s7,-1388 # b38 <malloc+0x16c>
  ac:	4641                	li	a2,16
  ae:	f8840593          	addi	a1,s0,-120
  b2:	8526                	mv	a0,s1
  b4:	44c000ef          	jal	500 <read>
  b8:	47c1                	li	a5,16
  ba:	12f51b63          	bne	a0,a5,1f0 <find+0x1a2>
  be:	f8845783          	lhu	a5,-120(s0)
  c2:	d7ed                	beqz	a5,ac <find+0x5e>
  c4:	85da                	mv	a1,s6
  c6:	f8a40513          	addi	a0,s0,-118
  ca:	1e2000ef          	jal	2ac <strcmp>
  ce:	dd79                	beqz	a0,ac <find+0x5e>
  d0:	85de                	mv	a1,s7
  d2:	f8a40513          	addi	a0,s0,-118
  d6:	1d6000ef          	jal	2ac <strcmp>
  da:	d969                	beqz	a0,ac <find+0x5e>
  dc:	25413823          	sd	s4,592(sp)
  e0:	85ca                	mv	a1,s2
  e2:	d8840513          	addi	a0,s0,-632
  e6:	1aa000ef          	jal	290 <strcpy>
  ea:	d8840513          	addi	a0,s0,-632
  ee:	1ea000ef          	jal	2d8 <strlen>
  f2:	1502                	slli	a0,a0,0x20
  f4:	9101                	srli	a0,a0,0x20
  f6:	d8840793          	addi	a5,s0,-632
  fa:	00a78a33          	add	s4,a5,a0
  fe:	02f00793          	li	a5,47
 102:	00fa0023          	sb	a5,0(s4)
 106:	4639                	li	a2,14
 108:	f8a40593          	addi	a1,s0,-118
 10c:	001a0513          	addi	a0,s4,1
 110:	32a000ef          	jal	43a <memmove>
 114:	000a07a3          	sb	zero,15(s4)
 118:	85ce                	mv	a1,s3
 11a:	f8a40513          	addi	a0,s0,-118
 11e:	18e000ef          	jal	2ac <strcmp>
 122:	cd49                	beqz	a0,1bc <find+0x16e>
 124:	f9840593          	addi	a1,s0,-104
 128:	d8840513          	addi	a0,s0,-632
 12c:	28c000ef          	jal	3b8 <stat>
 130:	e955                	bnez	a0,1e4 <find+0x196>
 132:	fa041703          	lh	a4,-96(s0)
 136:	4785                	li	a5,1
 138:	08f70c63          	beq	a4,a5,1d0 <find+0x182>
 13c:	25013a03          	ld	s4,592(sp)
 140:	b7b5                	j	ac <find+0x5e>
 142:	85ca                	mv	a1,s2
 144:	00001517          	auipc	a0,0x1
 148:	9b450513          	addi	a0,a0,-1612 # af8 <malloc+0x12c>
 14c:	7cc000ef          	jal	918 <printf>
 150:	4a81                	li	s5,0
 152:	a845                	j	202 <find+0x1b4>
 154:	85ca                	mv	a1,s2
 156:	00001517          	auipc	a0,0x1
 15a:	9ba50513          	addi	a0,a0,-1606 # b10 <malloc+0x144>
 15e:	7ba000ef          	jal	918 <printf>
 162:	8526                	mv	a0,s1
 164:	3ac000ef          	jal	510 <close>
 168:	4a81                	li	s5,0
 16a:	26813483          	ld	s1,616(sp)
 16e:	a851                	j	202 <find+0x1b4>
 170:	854a                	mv	a0,s2
 172:	166000ef          	jal	2d8 <strlen>
 176:	1502                	slli	a0,a0,0x20
 178:	9101                	srli	a0,a0,0x20
 17a:	954a                	add	a0,a0,s2
 17c:	02f00713          	li	a4,47
 180:	00a97a63          	bgeu	s2,a0,194 <find+0x146>
 184:	fff54783          	lbu	a5,-1(a0)
 188:	00e78663          	beq	a5,a4,194 <find+0x146>
 18c:	157d                	addi	a0,a0,-1
 18e:	fea91be3          	bne	s2,a0,184 <find+0x136>
 192:	854a                	mv	a0,s2
 194:	85ce                	mv	a1,s3
 196:	116000ef          	jal	2ac <strcmp>
 19a:	4a81                	li	s5,0
 19c:	c519                	beqz	a0,1aa <find+0x15c>
 19e:	8526                	mv	a0,s1
 1a0:	370000ef          	jal	510 <close>
 1a4:	26813483          	ld	s1,616(sp)
 1a8:	a8a9                	j	202 <find+0x1b4>
 1aa:	85ca                	mv	a1,s2
 1ac:	00001517          	auipc	a0,0x1
 1b0:	97c50513          	addi	a0,a0,-1668 # b28 <malloc+0x15c>
 1b4:	764000ef          	jal	918 <printf>
 1b8:	4a85                	li	s5,1
 1ba:	b7d5                	j	19e <find+0x150>
 1bc:	d8840593          	addi	a1,s0,-632
 1c0:	00001517          	auipc	a0,0x1
 1c4:	96850513          	addi	a0,a0,-1688 # b28 <malloc+0x15c>
 1c8:	750000ef          	jal	918 <printf>
 1cc:	4a85                	li	s5,1
 1ce:	bf99                	j	124 <find+0xd6>
 1d0:	85ce                	mv	a1,s3
 1d2:	d8840513          	addi	a0,s0,-632
 1d6:	e79ff0ef          	jal	4e <find>
 1da:	c901                	beqz	a0,1ea <find+0x19c>
 1dc:	4a85                	li	s5,1
 1de:	25013a03          	ld	s4,592(sp)
 1e2:	b5e9                	j	ac <find+0x5e>
 1e4:	25013a03          	ld	s4,592(sp)
 1e8:	b5d1                	j	ac <find+0x5e>
 1ea:	25013a03          	ld	s4,592(sp)
 1ee:	bd7d                	j	ac <find+0x5e>
 1f0:	8526                	mv	a0,s1
 1f2:	31e000ef          	jal	510 <close>
 1f6:	26813483          	ld	s1,616(sp)
 1fa:	24013b03          	ld	s6,576(sp)
 1fe:	23813b83          	ld	s7,568(sp)
 202:	8556                	mv	a0,s5
 204:	27813083          	ld	ra,632(sp)
 208:	27013403          	ld	s0,624(sp)
 20c:	26013903          	ld	s2,608(sp)
 210:	25813983          	ld	s3,600(sp)
 214:	24813a83          	ld	s5,584(sp)
 218:	28010113          	addi	sp,sp,640
 21c:	8082                	ret

000000000000021e <main>:
 21e:	1101                	addi	sp,sp,-32
 220:	ec06                	sd	ra,24(sp)
 222:	e822                	sd	s0,16(sp)
 224:	e426                	sd	s1,8(sp)
 226:	1000                	addi	s0,sp,32
 228:	84ae                	mv	s1,a1
 22a:	4789                	li	a5,2
 22c:	00f50a63          	beq	a0,a5,240 <main+0x22>
 230:	478d                	li	a5,3
 232:	02f50463          	beq	a0,a5,25a <main+0x3c>
 236:	dcbff0ef          	jal	0 <print_help>
 23a:	4505                	li	a0,1
 23c:	2ac000ef          	jal	4e8 <exit>
 240:	00001597          	auipc	a1,0x1
 244:	90058593          	addi	a1,a1,-1792 # b40 <malloc+0x174>
 248:	6488                	ld	a0,8(s1)
 24a:	062000ef          	jal	2ac <strcmp>
 24e:	f565                	bnez	a0,236 <main+0x18>
 250:	db1ff0ef          	jal	0 <print_help>
 254:	4501                	li	a0,0
 256:	292000ef          	jal	4e8 <exit>
 25a:	698c                	ld	a1,16(a1)
 25c:	6488                	ld	a0,8(s1)
 25e:	df1ff0ef          	jal	4e <find>
 262:	e919                	bnez	a0,278 <main+0x5a>
 264:	688c                	ld	a1,16(s1)
 266:	00001517          	auipc	a0,0x1
 26a:	8e250513          	addi	a0,a0,-1822 # b48 <malloc+0x17c>
 26e:	6aa000ef          	jal	918 <printf>
 272:	4505                	li	a0,1
 274:	274000ef          	jal	4e8 <exit>
 278:	4501                	li	a0,0
 27a:	26e000ef          	jal	4e8 <exit>

000000000000027e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 27e:	1141                	addi	sp,sp,-16
 280:	e406                	sd	ra,8(sp)
 282:	e022                	sd	s0,0(sp)
 284:	0800                	addi	s0,sp,16
  extern int main();
  main();
 286:	f99ff0ef          	jal	21e <main>
  exit(0);
 28a:	4501                	li	a0,0
 28c:	25c000ef          	jal	4e8 <exit>

0000000000000290 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 296:	87aa                	mv	a5,a0
 298:	0585                	addi	a1,a1,1
 29a:	0785                	addi	a5,a5,1
 29c:	fff5c703          	lbu	a4,-1(a1)
 2a0:	fee78fa3          	sb	a4,-1(a5)
 2a4:	fb75                	bnez	a4,298 <strcpy+0x8>
    ;
  return os;
}
 2a6:	6422                	ld	s0,8(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret

00000000000002ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ac:	1141                	addi	sp,sp,-16
 2ae:	e422                	sd	s0,8(sp)
 2b0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2b2:	00054783          	lbu	a5,0(a0)
 2b6:	cb91                	beqz	a5,2ca <strcmp+0x1e>
 2b8:	0005c703          	lbu	a4,0(a1)
 2bc:	00f71763          	bne	a4,a5,2ca <strcmp+0x1e>
    p++, q++;
 2c0:	0505                	addi	a0,a0,1
 2c2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	fbe5                	bnez	a5,2b8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2ca:	0005c503          	lbu	a0,0(a1)
}
 2ce:	40a7853b          	subw	a0,a5,a0
 2d2:	6422                	ld	s0,8(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret

00000000000002d8 <strlen>:

uint
strlen(const char *s)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2de:	00054783          	lbu	a5,0(a0)
 2e2:	cf91                	beqz	a5,2fe <strlen+0x26>
 2e4:	0505                	addi	a0,a0,1
 2e6:	87aa                	mv	a5,a0
 2e8:	86be                	mv	a3,a5
 2ea:	0785                	addi	a5,a5,1
 2ec:	fff7c703          	lbu	a4,-1(a5)
 2f0:	ff65                	bnez	a4,2e8 <strlen+0x10>
 2f2:	40a6853b          	subw	a0,a3,a0
 2f6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2f8:	6422                	ld	s0,8(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret
  for(n = 0; s[n]; n++)
 2fe:	4501                	li	a0,0
 300:	bfe5                	j	2f8 <strlen+0x20>

0000000000000302 <memset>:

void*
memset(void *dst, int c, uint n)
{
 302:	1141                	addi	sp,sp,-16
 304:	e422                	sd	s0,8(sp)
 306:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 308:	ca19                	beqz	a2,31e <memset+0x1c>
 30a:	87aa                	mv	a5,a0
 30c:	1602                	slli	a2,a2,0x20
 30e:	9201                	srli	a2,a2,0x20
 310:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 314:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 318:	0785                	addi	a5,a5,1
 31a:	fee79de3          	bne	a5,a4,314 <memset+0x12>
  }
  return dst;
}
 31e:	6422                	ld	s0,8(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret

0000000000000324 <strchr>:

char*
strchr(const char *s, char c)
{
 324:	1141                	addi	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	addi	s0,sp,16
  for(; *s; s++)
 32a:	00054783          	lbu	a5,0(a0)
 32e:	cb99                	beqz	a5,344 <strchr+0x20>
    if(*s == c)
 330:	00f58763          	beq	a1,a5,33e <strchr+0x1a>
  for(; *s; s++)
 334:	0505                	addi	a0,a0,1
 336:	00054783          	lbu	a5,0(a0)
 33a:	fbfd                	bnez	a5,330 <strchr+0xc>
      return (char*)s;
  return 0;
 33c:	4501                	li	a0,0
}
 33e:	6422                	ld	s0,8(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret
  return 0;
 344:	4501                	li	a0,0
 346:	bfe5                	j	33e <strchr+0x1a>

0000000000000348 <gets>:

char*
gets(char *buf, int max)
{
 348:	711d                	addi	sp,sp,-96
 34a:	ec86                	sd	ra,88(sp)
 34c:	e8a2                	sd	s0,80(sp)
 34e:	e4a6                	sd	s1,72(sp)
 350:	e0ca                	sd	s2,64(sp)
 352:	fc4e                	sd	s3,56(sp)
 354:	f852                	sd	s4,48(sp)
 356:	f456                	sd	s5,40(sp)
 358:	f05a                	sd	s6,32(sp)
 35a:	ec5e                	sd	s7,24(sp)
 35c:	1080                	addi	s0,sp,96
 35e:	8baa                	mv	s7,a0
 360:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 362:	892a                	mv	s2,a0
 364:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 366:	4aa9                	li	s5,10
 368:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 36a:	89a6                	mv	s3,s1
 36c:	2485                	addiw	s1,s1,1
 36e:	0344d663          	bge	s1,s4,39a <gets+0x52>
    cc = read(0, &c, 1);
 372:	4605                	li	a2,1
 374:	faf40593          	addi	a1,s0,-81
 378:	4501                	li	a0,0
 37a:	186000ef          	jal	500 <read>
    if(cc < 1)
 37e:	00a05e63          	blez	a0,39a <gets+0x52>
    buf[i++] = c;
 382:	faf44783          	lbu	a5,-81(s0)
 386:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 38a:	01578763          	beq	a5,s5,398 <gets+0x50>
 38e:	0905                	addi	s2,s2,1
 390:	fd679de3          	bne	a5,s6,36a <gets+0x22>
    buf[i++] = c;
 394:	89a6                	mv	s3,s1
 396:	a011                	j	39a <gets+0x52>
 398:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 39a:	99de                	add	s3,s3,s7
 39c:	00098023          	sb	zero,0(s3)
  return buf;
}
 3a0:	855e                	mv	a0,s7
 3a2:	60e6                	ld	ra,88(sp)
 3a4:	6446                	ld	s0,80(sp)
 3a6:	64a6                	ld	s1,72(sp)
 3a8:	6906                	ld	s2,64(sp)
 3aa:	79e2                	ld	s3,56(sp)
 3ac:	7a42                	ld	s4,48(sp)
 3ae:	7aa2                	ld	s5,40(sp)
 3b0:	7b02                	ld	s6,32(sp)
 3b2:	6be2                	ld	s7,24(sp)
 3b4:	6125                	addi	sp,sp,96
 3b6:	8082                	ret

00000000000003b8 <stat>:

int
stat(const char *n, struct stat *st)
{
 3b8:	1101                	addi	sp,sp,-32
 3ba:	ec06                	sd	ra,24(sp)
 3bc:	e822                	sd	s0,16(sp)
 3be:	e04a                	sd	s2,0(sp)
 3c0:	1000                	addi	s0,sp,32
 3c2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c4:	4581                	li	a1,0
 3c6:	162000ef          	jal	528 <open>
  if(fd < 0)
 3ca:	02054263          	bltz	a0,3ee <stat+0x36>
 3ce:	e426                	sd	s1,8(sp)
 3d0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3d2:	85ca                	mv	a1,s2
 3d4:	16c000ef          	jal	540 <fstat>
 3d8:	892a                	mv	s2,a0
  close(fd);
 3da:	8526                	mv	a0,s1
 3dc:	134000ef          	jal	510 <close>
  return r;
 3e0:	64a2                	ld	s1,8(sp)
}
 3e2:	854a                	mv	a0,s2
 3e4:	60e2                	ld	ra,24(sp)
 3e6:	6442                	ld	s0,16(sp)
 3e8:	6902                	ld	s2,0(sp)
 3ea:	6105                	addi	sp,sp,32
 3ec:	8082                	ret
    return -1;
 3ee:	597d                	li	s2,-1
 3f0:	bfcd                	j	3e2 <stat+0x2a>

00000000000003f2 <atoi>:

int
atoi(const char *s)
{
 3f2:	1141                	addi	sp,sp,-16
 3f4:	e422                	sd	s0,8(sp)
 3f6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3f8:	00054683          	lbu	a3,0(a0)
 3fc:	fd06879b          	addiw	a5,a3,-48
 400:	0ff7f793          	zext.b	a5,a5
 404:	4625                	li	a2,9
 406:	02f66863          	bltu	a2,a5,436 <atoi+0x44>
 40a:	872a                	mv	a4,a0
  n = 0;
 40c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 40e:	0705                	addi	a4,a4,1
 410:	0025179b          	slliw	a5,a0,0x2
 414:	9fa9                	addw	a5,a5,a0
 416:	0017979b          	slliw	a5,a5,0x1
 41a:	9fb5                	addw	a5,a5,a3
 41c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 420:	00074683          	lbu	a3,0(a4)
 424:	fd06879b          	addiw	a5,a3,-48
 428:	0ff7f793          	zext.b	a5,a5
 42c:	fef671e3          	bgeu	a2,a5,40e <atoi+0x1c>
  return n;
}
 430:	6422                	ld	s0,8(sp)
 432:	0141                	addi	sp,sp,16
 434:	8082                	ret
  n = 0;
 436:	4501                	li	a0,0
 438:	bfe5                	j	430 <atoi+0x3e>

000000000000043a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 43a:	1141                	addi	sp,sp,-16
 43c:	e422                	sd	s0,8(sp)
 43e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 440:	02b57463          	bgeu	a0,a1,468 <memmove+0x2e>
    while(n-- > 0)
 444:	00c05f63          	blez	a2,462 <memmove+0x28>
 448:	1602                	slli	a2,a2,0x20
 44a:	9201                	srli	a2,a2,0x20
 44c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 450:	872a                	mv	a4,a0
      *dst++ = *src++;
 452:	0585                	addi	a1,a1,1
 454:	0705                	addi	a4,a4,1
 456:	fff5c683          	lbu	a3,-1(a1)
 45a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 45e:	fef71ae3          	bne	a4,a5,452 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 462:	6422                	ld	s0,8(sp)
 464:	0141                	addi	sp,sp,16
 466:	8082                	ret
    dst += n;
 468:	00c50733          	add	a4,a0,a2
    src += n;
 46c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 46e:	fec05ae3          	blez	a2,462 <memmove+0x28>
 472:	fff6079b          	addiw	a5,a2,-1
 476:	1782                	slli	a5,a5,0x20
 478:	9381                	srli	a5,a5,0x20
 47a:	fff7c793          	not	a5,a5
 47e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 480:	15fd                	addi	a1,a1,-1
 482:	177d                	addi	a4,a4,-1
 484:	0005c683          	lbu	a3,0(a1)
 488:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 48c:	fee79ae3          	bne	a5,a4,480 <memmove+0x46>
 490:	bfc9                	j	462 <memmove+0x28>

0000000000000492 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 492:	1141                	addi	sp,sp,-16
 494:	e422                	sd	s0,8(sp)
 496:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 498:	ca05                	beqz	a2,4c8 <memcmp+0x36>
 49a:	fff6069b          	addiw	a3,a2,-1
 49e:	1682                	slli	a3,a3,0x20
 4a0:	9281                	srli	a3,a3,0x20
 4a2:	0685                	addi	a3,a3,1
 4a4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4a6:	00054783          	lbu	a5,0(a0)
 4aa:	0005c703          	lbu	a4,0(a1)
 4ae:	00e79863          	bne	a5,a4,4be <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4b2:	0505                	addi	a0,a0,1
    p2++;
 4b4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4b6:	fed518e3          	bne	a0,a3,4a6 <memcmp+0x14>
  }
  return 0;
 4ba:	4501                	li	a0,0
 4bc:	a019                	j	4c2 <memcmp+0x30>
      return *p1 - *p2;
 4be:	40e7853b          	subw	a0,a5,a4
}
 4c2:	6422                	ld	s0,8(sp)
 4c4:	0141                	addi	sp,sp,16
 4c6:	8082                	ret
  return 0;
 4c8:	4501                	li	a0,0
 4ca:	bfe5                	j	4c2 <memcmp+0x30>

00000000000004cc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4cc:	1141                	addi	sp,sp,-16
 4ce:	e406                	sd	ra,8(sp)
 4d0:	e022                	sd	s0,0(sp)
 4d2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4d4:	f67ff0ef          	jal	43a <memmove>
}
 4d8:	60a2                	ld	ra,8(sp)
 4da:	6402                	ld	s0,0(sp)
 4dc:	0141                	addi	sp,sp,16
 4de:	8082                	ret

00000000000004e0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4e0:	4885                	li	a7,1
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4e8:	4889                	li	a7,2
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4f0:	488d                	li	a7,3
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4f8:	4891                	li	a7,4
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <read>:
.global read
read:
 li a7, SYS_read
 500:	4895                	li	a7,5
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <write>:
.global write
write:
 li a7, SYS_write
 508:	48c1                	li	a7,16
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <close>:
.global close
close:
 li a7, SYS_close
 510:	48d5                	li	a7,21
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <kill>:
.global kill
kill:
 li a7, SYS_kill
 518:	4899                	li	a7,6
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <exec>:
.global exec
exec:
 li a7, SYS_exec
 520:	489d                	li	a7,7
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <open>:
.global open
open:
 li a7, SYS_open
 528:	48bd                	li	a7,15
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 530:	48c5                	li	a7,17
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 538:	48c9                	li	a7,18
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 540:	48a1                	li	a7,8
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <link>:
.global link
link:
 li a7, SYS_link
 548:	48cd                	li	a7,19
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 550:	48d1                	li	a7,20
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 558:	48a5                	li	a7,9
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <dup>:
.global dup
dup:
 li a7, SYS_dup
 560:	48a9                	li	a7,10
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 568:	48ad                	li	a7,11
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 570:	48b1                	li	a7,12
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 578:	48b5                	li	a7,13
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 580:	48b9                	li	a7,14
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 588:	48d9                	li	a7,22
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 590:	48dd                	li	a7,23
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 598:	48e1                	li	a7,24
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <putc>:
 5a0:	1101                	addi	sp,sp,-32
 5a2:	ec06                	sd	ra,24(sp)
 5a4:	e822                	sd	s0,16(sp)
 5a6:	1000                	addi	s0,sp,32
 5a8:	feb407a3          	sb	a1,-17(s0)
 5ac:	4605                	li	a2,1
 5ae:	fef40593          	addi	a1,s0,-17
 5b2:	f57ff0ef          	jal	508 <write>
 5b6:	60e2                	ld	ra,24(sp)
 5b8:	6442                	ld	s0,16(sp)
 5ba:	6105                	addi	sp,sp,32
 5bc:	8082                	ret

00000000000005be <printint>:
 5be:	7139                	addi	sp,sp,-64
 5c0:	fc06                	sd	ra,56(sp)
 5c2:	f822                	sd	s0,48(sp)
 5c4:	f426                	sd	s1,40(sp)
 5c6:	0080                	addi	s0,sp,64
 5c8:	84aa                	mv	s1,a0
 5ca:	c299                	beqz	a3,5d0 <printint+0x12>
 5cc:	0805c963          	bltz	a1,65e <printint+0xa0>
 5d0:	2581                	sext.w	a1,a1
 5d2:	4881                	li	a7,0
 5d4:	fc040693          	addi	a3,s0,-64
 5d8:	4701                	li	a4,0
 5da:	2601                	sext.w	a2,a2
 5dc:	00000517          	auipc	a0,0x0
 5e0:	59450513          	addi	a0,a0,1428 # b70 <digits>
 5e4:	883a                	mv	a6,a4
 5e6:	2705                	addiw	a4,a4,1
 5e8:	02c5f7bb          	remuw	a5,a1,a2
 5ec:	1782                	slli	a5,a5,0x20
 5ee:	9381                	srli	a5,a5,0x20
 5f0:	97aa                	add	a5,a5,a0
 5f2:	0007c783          	lbu	a5,0(a5)
 5f6:	00f68023          	sb	a5,0(a3)
 5fa:	0005879b          	sext.w	a5,a1
 5fe:	02c5d5bb          	divuw	a1,a1,a2
 602:	0685                	addi	a3,a3,1
 604:	fec7f0e3          	bgeu	a5,a2,5e4 <printint+0x26>
 608:	00088c63          	beqz	a7,620 <printint+0x62>
 60c:	fd070793          	addi	a5,a4,-48
 610:	00878733          	add	a4,a5,s0
 614:	02d00793          	li	a5,45
 618:	fef70823          	sb	a5,-16(a4)
 61c:	0028071b          	addiw	a4,a6,2
 620:	02e05a63          	blez	a4,654 <printint+0x96>
 624:	f04a                	sd	s2,32(sp)
 626:	ec4e                	sd	s3,24(sp)
 628:	fc040793          	addi	a5,s0,-64
 62c:	00e78933          	add	s2,a5,a4
 630:	fff78993          	addi	s3,a5,-1
 634:	99ba                	add	s3,s3,a4
 636:	377d                	addiw	a4,a4,-1
 638:	1702                	slli	a4,a4,0x20
 63a:	9301                	srli	a4,a4,0x20
 63c:	40e989b3          	sub	s3,s3,a4
 640:	fff94583          	lbu	a1,-1(s2)
 644:	8526                	mv	a0,s1
 646:	f5bff0ef          	jal	5a0 <putc>
 64a:	197d                	addi	s2,s2,-1
 64c:	ff391ae3          	bne	s2,s3,640 <printint+0x82>
 650:	7902                	ld	s2,32(sp)
 652:	69e2                	ld	s3,24(sp)
 654:	70e2                	ld	ra,56(sp)
 656:	7442                	ld	s0,48(sp)
 658:	74a2                	ld	s1,40(sp)
 65a:	6121                	addi	sp,sp,64
 65c:	8082                	ret
 65e:	40b005bb          	negw	a1,a1
 662:	4885                	li	a7,1
 664:	bf85                	j	5d4 <printint+0x16>

0000000000000666 <vprintf>:
 666:	711d                	addi	sp,sp,-96
 668:	ec86                	sd	ra,88(sp)
 66a:	e8a2                	sd	s0,80(sp)
 66c:	e0ca                	sd	s2,64(sp)
 66e:	1080                	addi	s0,sp,96
 670:	0005c903          	lbu	s2,0(a1)
 674:	26090863          	beqz	s2,8e4 <vprintf+0x27e>
 678:	e4a6                	sd	s1,72(sp)
 67a:	fc4e                	sd	s3,56(sp)
 67c:	f852                	sd	s4,48(sp)
 67e:	f456                	sd	s5,40(sp)
 680:	f05a                	sd	s6,32(sp)
 682:	ec5e                	sd	s7,24(sp)
 684:	e862                	sd	s8,16(sp)
 686:	e466                	sd	s9,8(sp)
 688:	8b2a                	mv	s6,a0
 68a:	8a2e                	mv	s4,a1
 68c:	8bb2                	mv	s7,a2
 68e:	4981                	li	s3,0
 690:	4481                	li	s1,0
 692:	4701                	li	a4,0
 694:	02500a93          	li	s5,37
 698:	06400c13          	li	s8,100
 69c:	06c00c93          	li	s9,108
 6a0:	a005                	j	6c0 <vprintf+0x5a>
 6a2:	85ca                	mv	a1,s2
 6a4:	855a                	mv	a0,s6
 6a6:	efbff0ef          	jal	5a0 <putc>
 6aa:	a019                	j	6b0 <vprintf+0x4a>
 6ac:	03598263          	beq	s3,s5,6d0 <vprintf+0x6a>
 6b0:	2485                	addiw	s1,s1,1
 6b2:	8726                	mv	a4,s1
 6b4:	009a07b3          	add	a5,s4,s1
 6b8:	0007c903          	lbu	s2,0(a5)
 6bc:	20090c63          	beqz	s2,8d4 <vprintf+0x26e>
 6c0:	0009079b          	sext.w	a5,s2
 6c4:	fe0994e3          	bnez	s3,6ac <vprintf+0x46>
 6c8:	fd579de3          	bne	a5,s5,6a2 <vprintf+0x3c>
 6cc:	89be                	mv	s3,a5
 6ce:	b7cd                	j	6b0 <vprintf+0x4a>
 6d0:	00ea06b3          	add	a3,s4,a4
 6d4:	0016c683          	lbu	a3,1(a3)
 6d8:	8636                	mv	a2,a3
 6da:	c681                	beqz	a3,6e2 <vprintf+0x7c>
 6dc:	9752                	add	a4,a4,s4
 6de:	00274603          	lbu	a2,2(a4)
 6e2:	03878f63          	beq	a5,s8,720 <vprintf+0xba>
 6e6:	05978963          	beq	a5,s9,738 <vprintf+0xd2>
 6ea:	07500713          	li	a4,117
 6ee:	0ee78363          	beq	a5,a4,7d4 <vprintf+0x16e>
 6f2:	07800713          	li	a4,120
 6f6:	12e78563          	beq	a5,a4,820 <vprintf+0x1ba>
 6fa:	07000713          	li	a4,112
 6fe:	14e78a63          	beq	a5,a4,852 <vprintf+0x1ec>
 702:	07300713          	li	a4,115
 706:	18e78a63          	beq	a5,a4,89a <vprintf+0x234>
 70a:	02500713          	li	a4,37
 70e:	04e79563          	bne	a5,a4,758 <vprintf+0xf2>
 712:	02500593          	li	a1,37
 716:	855a                	mv	a0,s6
 718:	e89ff0ef          	jal	5a0 <putc>
 71c:	4981                	li	s3,0
 71e:	bf49                	j	6b0 <vprintf+0x4a>
 720:	008b8913          	addi	s2,s7,8
 724:	4685                	li	a3,1
 726:	4629                	li	a2,10
 728:	000ba583          	lw	a1,0(s7)
 72c:	855a                	mv	a0,s6
 72e:	e91ff0ef          	jal	5be <printint>
 732:	8bca                	mv	s7,s2
 734:	4981                	li	s3,0
 736:	bfad                	j	6b0 <vprintf+0x4a>
 738:	06400793          	li	a5,100
 73c:	02f68963          	beq	a3,a5,76e <vprintf+0x108>
 740:	06c00793          	li	a5,108
 744:	04f68263          	beq	a3,a5,788 <vprintf+0x122>
 748:	07500793          	li	a5,117
 74c:	0af68063          	beq	a3,a5,7ec <vprintf+0x186>
 750:	07800793          	li	a5,120
 754:	0ef68263          	beq	a3,a5,838 <vprintf+0x1d2>
 758:	02500593          	li	a1,37
 75c:	855a                	mv	a0,s6
 75e:	e43ff0ef          	jal	5a0 <putc>
 762:	85ca                	mv	a1,s2
 764:	855a                	mv	a0,s6
 766:	e3bff0ef          	jal	5a0 <putc>
 76a:	4981                	li	s3,0
 76c:	b791                	j	6b0 <vprintf+0x4a>
 76e:	008b8913          	addi	s2,s7,8
 772:	4685                	li	a3,1
 774:	4629                	li	a2,10
 776:	000ba583          	lw	a1,0(s7)
 77a:	855a                	mv	a0,s6
 77c:	e43ff0ef          	jal	5be <printint>
 780:	2485                	addiw	s1,s1,1
 782:	8bca                	mv	s7,s2
 784:	4981                	li	s3,0
 786:	b72d                	j	6b0 <vprintf+0x4a>
 788:	06400793          	li	a5,100
 78c:	02f60763          	beq	a2,a5,7ba <vprintf+0x154>
 790:	07500793          	li	a5,117
 794:	06f60963          	beq	a2,a5,806 <vprintf+0x1a0>
 798:	07800793          	li	a5,120
 79c:	faf61ee3          	bne	a2,a5,758 <vprintf+0xf2>
 7a0:	008b8913          	addi	s2,s7,8
 7a4:	4681                	li	a3,0
 7a6:	4641                	li	a2,16
 7a8:	000ba583          	lw	a1,0(s7)
 7ac:	855a                	mv	a0,s6
 7ae:	e11ff0ef          	jal	5be <printint>
 7b2:	2489                	addiw	s1,s1,2
 7b4:	8bca                	mv	s7,s2
 7b6:	4981                	li	s3,0
 7b8:	bde5                	j	6b0 <vprintf+0x4a>
 7ba:	008b8913          	addi	s2,s7,8
 7be:	4685                	li	a3,1
 7c0:	4629                	li	a2,10
 7c2:	000ba583          	lw	a1,0(s7)
 7c6:	855a                	mv	a0,s6
 7c8:	df7ff0ef          	jal	5be <printint>
 7cc:	2489                	addiw	s1,s1,2
 7ce:	8bca                	mv	s7,s2
 7d0:	4981                	li	s3,0
 7d2:	bdf9                	j	6b0 <vprintf+0x4a>
 7d4:	008b8913          	addi	s2,s7,8
 7d8:	4681                	li	a3,0
 7da:	4629                	li	a2,10
 7dc:	000ba583          	lw	a1,0(s7)
 7e0:	855a                	mv	a0,s6
 7e2:	dddff0ef          	jal	5be <printint>
 7e6:	8bca                	mv	s7,s2
 7e8:	4981                	li	s3,0
 7ea:	b5d9                	j	6b0 <vprintf+0x4a>
 7ec:	008b8913          	addi	s2,s7,8
 7f0:	4681                	li	a3,0
 7f2:	4629                	li	a2,10
 7f4:	000ba583          	lw	a1,0(s7)
 7f8:	855a                	mv	a0,s6
 7fa:	dc5ff0ef          	jal	5be <printint>
 7fe:	2485                	addiw	s1,s1,1
 800:	8bca                	mv	s7,s2
 802:	4981                	li	s3,0
 804:	b575                	j	6b0 <vprintf+0x4a>
 806:	008b8913          	addi	s2,s7,8
 80a:	4681                	li	a3,0
 80c:	4629                	li	a2,10
 80e:	000ba583          	lw	a1,0(s7)
 812:	855a                	mv	a0,s6
 814:	dabff0ef          	jal	5be <printint>
 818:	2489                	addiw	s1,s1,2
 81a:	8bca                	mv	s7,s2
 81c:	4981                	li	s3,0
 81e:	bd49                	j	6b0 <vprintf+0x4a>
 820:	008b8913          	addi	s2,s7,8
 824:	4681                	li	a3,0
 826:	4641                	li	a2,16
 828:	000ba583          	lw	a1,0(s7)
 82c:	855a                	mv	a0,s6
 82e:	d91ff0ef          	jal	5be <printint>
 832:	8bca                	mv	s7,s2
 834:	4981                	li	s3,0
 836:	bdad                	j	6b0 <vprintf+0x4a>
 838:	008b8913          	addi	s2,s7,8
 83c:	4681                	li	a3,0
 83e:	4641                	li	a2,16
 840:	000ba583          	lw	a1,0(s7)
 844:	855a                	mv	a0,s6
 846:	d79ff0ef          	jal	5be <printint>
 84a:	2485                	addiw	s1,s1,1
 84c:	8bca                	mv	s7,s2
 84e:	4981                	li	s3,0
 850:	b585                	j	6b0 <vprintf+0x4a>
 852:	e06a                	sd	s10,0(sp)
 854:	008b8d13          	addi	s10,s7,8
 858:	000bb983          	ld	s3,0(s7)
 85c:	03000593          	li	a1,48
 860:	855a                	mv	a0,s6
 862:	d3fff0ef          	jal	5a0 <putc>
 866:	07800593          	li	a1,120
 86a:	855a                	mv	a0,s6
 86c:	d35ff0ef          	jal	5a0 <putc>
 870:	4941                	li	s2,16
 872:	00000b97          	auipc	s7,0x0
 876:	2feb8b93          	addi	s7,s7,766 # b70 <digits>
 87a:	03c9d793          	srli	a5,s3,0x3c
 87e:	97de                	add	a5,a5,s7
 880:	0007c583          	lbu	a1,0(a5)
 884:	855a                	mv	a0,s6
 886:	d1bff0ef          	jal	5a0 <putc>
 88a:	0992                	slli	s3,s3,0x4
 88c:	397d                	addiw	s2,s2,-1
 88e:	fe0916e3          	bnez	s2,87a <vprintf+0x214>
 892:	8bea                	mv	s7,s10
 894:	4981                	li	s3,0
 896:	6d02                	ld	s10,0(sp)
 898:	bd21                	j	6b0 <vprintf+0x4a>
 89a:	008b8993          	addi	s3,s7,8
 89e:	000bb903          	ld	s2,0(s7)
 8a2:	00090f63          	beqz	s2,8c0 <vprintf+0x25a>
 8a6:	00094583          	lbu	a1,0(s2)
 8aa:	c195                	beqz	a1,8ce <vprintf+0x268>
 8ac:	855a                	mv	a0,s6
 8ae:	cf3ff0ef          	jal	5a0 <putc>
 8b2:	0905                	addi	s2,s2,1
 8b4:	00094583          	lbu	a1,0(s2)
 8b8:	f9f5                	bnez	a1,8ac <vprintf+0x246>
 8ba:	8bce                	mv	s7,s3
 8bc:	4981                	li	s3,0
 8be:	bbcd                	j	6b0 <vprintf+0x4a>
 8c0:	00000917          	auipc	s2,0x0
 8c4:	2a890913          	addi	s2,s2,680 # b68 <malloc+0x19c>
 8c8:	02800593          	li	a1,40
 8cc:	b7c5                	j	8ac <vprintf+0x246>
 8ce:	8bce                	mv	s7,s3
 8d0:	4981                	li	s3,0
 8d2:	bbf9                	j	6b0 <vprintf+0x4a>
 8d4:	64a6                	ld	s1,72(sp)
 8d6:	79e2                	ld	s3,56(sp)
 8d8:	7a42                	ld	s4,48(sp)
 8da:	7aa2                	ld	s5,40(sp)
 8dc:	7b02                	ld	s6,32(sp)
 8de:	6be2                	ld	s7,24(sp)
 8e0:	6c42                	ld	s8,16(sp)
 8e2:	6ca2                	ld	s9,8(sp)
 8e4:	60e6                	ld	ra,88(sp)
 8e6:	6446                	ld	s0,80(sp)
 8e8:	6906                	ld	s2,64(sp)
 8ea:	6125                	addi	sp,sp,96
 8ec:	8082                	ret

00000000000008ee <fprintf>:
 8ee:	715d                	addi	sp,sp,-80
 8f0:	ec06                	sd	ra,24(sp)
 8f2:	e822                	sd	s0,16(sp)
 8f4:	1000                	addi	s0,sp,32
 8f6:	e010                	sd	a2,0(s0)
 8f8:	e414                	sd	a3,8(s0)
 8fa:	e818                	sd	a4,16(s0)
 8fc:	ec1c                	sd	a5,24(s0)
 8fe:	03043023          	sd	a6,32(s0)
 902:	03143423          	sd	a7,40(s0)
 906:	fe843423          	sd	s0,-24(s0)
 90a:	8622                	mv	a2,s0
 90c:	d5bff0ef          	jal	666 <vprintf>
 910:	60e2                	ld	ra,24(sp)
 912:	6442                	ld	s0,16(sp)
 914:	6161                	addi	sp,sp,80
 916:	8082                	ret

0000000000000918 <printf>:
 918:	711d                	addi	sp,sp,-96
 91a:	ec06                	sd	ra,24(sp)
 91c:	e822                	sd	s0,16(sp)
 91e:	1000                	addi	s0,sp,32
 920:	e40c                	sd	a1,8(s0)
 922:	e810                	sd	a2,16(s0)
 924:	ec14                	sd	a3,24(s0)
 926:	f018                	sd	a4,32(s0)
 928:	f41c                	sd	a5,40(s0)
 92a:	03043823          	sd	a6,48(s0)
 92e:	03143c23          	sd	a7,56(s0)
 932:	00840613          	addi	a2,s0,8
 936:	fec43423          	sd	a2,-24(s0)
 93a:	85aa                	mv	a1,a0
 93c:	4505                	li	a0,1
 93e:	d29ff0ef          	jal	666 <vprintf>
 942:	60e2                	ld	ra,24(sp)
 944:	6442                	ld	s0,16(sp)
 946:	6125                	addi	sp,sp,96
 948:	8082                	ret

000000000000094a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 94a:	1141                	addi	sp,sp,-16
 94c:	e422                	sd	s0,8(sp)
 94e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 950:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 954:	00001797          	auipc	a5,0x1
 958:	6ac7b783          	ld	a5,1708(a5) # 2000 <freep>
 95c:	a02d                	j	986 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 95e:	4618                	lw	a4,8(a2)
 960:	9f2d                	addw	a4,a4,a1
 962:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 966:	6398                	ld	a4,0(a5)
 968:	6310                	ld	a2,0(a4)
 96a:	a83d                	j	9a8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 96c:	ff852703          	lw	a4,-8(a0)
 970:	9f31                	addw	a4,a4,a2
 972:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 974:	ff053683          	ld	a3,-16(a0)
 978:	a091                	j	9bc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 97a:	6398                	ld	a4,0(a5)
 97c:	00e7e463          	bltu	a5,a4,984 <free+0x3a>
 980:	00e6ea63          	bltu	a3,a4,994 <free+0x4a>
{
 984:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 986:	fed7fae3          	bgeu	a5,a3,97a <free+0x30>
 98a:	6398                	ld	a4,0(a5)
 98c:	00e6e463          	bltu	a3,a4,994 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 990:	fee7eae3          	bltu	a5,a4,984 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 994:	ff852583          	lw	a1,-8(a0)
 998:	6390                	ld	a2,0(a5)
 99a:	02059813          	slli	a6,a1,0x20
 99e:	01c85713          	srli	a4,a6,0x1c
 9a2:	9736                	add	a4,a4,a3
 9a4:	fae60de3          	beq	a2,a4,95e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9a8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9ac:	4790                	lw	a2,8(a5)
 9ae:	02061593          	slli	a1,a2,0x20
 9b2:	01c5d713          	srli	a4,a1,0x1c
 9b6:	973e                	add	a4,a4,a5
 9b8:	fae68ae3          	beq	a3,a4,96c <free+0x22>
    p->s.ptr = bp->s.ptr;
 9bc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9be:	00001717          	auipc	a4,0x1
 9c2:	64f73123          	sd	a5,1602(a4) # 2000 <freep>
}
 9c6:	6422                	ld	s0,8(sp)
 9c8:	0141                	addi	sp,sp,16
 9ca:	8082                	ret

00000000000009cc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9cc:	7139                	addi	sp,sp,-64
 9ce:	fc06                	sd	ra,56(sp)
 9d0:	f822                	sd	s0,48(sp)
 9d2:	f426                	sd	s1,40(sp)
 9d4:	ec4e                	sd	s3,24(sp)
 9d6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d8:	02051493          	slli	s1,a0,0x20
 9dc:	9081                	srli	s1,s1,0x20
 9de:	04bd                	addi	s1,s1,15
 9e0:	8091                	srli	s1,s1,0x4
 9e2:	0014899b          	addiw	s3,s1,1
 9e6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9e8:	00001517          	auipc	a0,0x1
 9ec:	61853503          	ld	a0,1560(a0) # 2000 <freep>
 9f0:	c915                	beqz	a0,a24 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f4:	4798                	lw	a4,8(a5)
 9f6:	08977a63          	bgeu	a4,s1,a8a <malloc+0xbe>
 9fa:	f04a                	sd	s2,32(sp)
 9fc:	e852                	sd	s4,16(sp)
 9fe:	e456                	sd	s5,8(sp)
 a00:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a02:	8a4e                	mv	s4,s3
 a04:	0009871b          	sext.w	a4,s3
 a08:	6685                	lui	a3,0x1
 a0a:	00d77363          	bgeu	a4,a3,a10 <malloc+0x44>
 a0e:	6a05                	lui	s4,0x1
 a10:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a14:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a18:	00001917          	auipc	s2,0x1
 a1c:	5e890913          	addi	s2,s2,1512 # 2000 <freep>
  if(p == (char*)-1)
 a20:	5afd                	li	s5,-1
 a22:	a081                	j	a62 <malloc+0x96>
 a24:	f04a                	sd	s2,32(sp)
 a26:	e852                	sd	s4,16(sp)
 a28:	e456                	sd	s5,8(sp)
 a2a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a2c:	00001797          	auipc	a5,0x1
 a30:	5e478793          	addi	a5,a5,1508 # 2010 <base>
 a34:	00001717          	auipc	a4,0x1
 a38:	5cf73623          	sd	a5,1484(a4) # 2000 <freep>
 a3c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a3e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a42:	b7c1                	j	a02 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a44:	6398                	ld	a4,0(a5)
 a46:	e118                	sd	a4,0(a0)
 a48:	a8a9                	j	aa2 <malloc+0xd6>
  hp->s.size = nu;
 a4a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a4e:	0541                	addi	a0,a0,16
 a50:	efbff0ef          	jal	94a <free>
  return freep;
 a54:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a58:	c12d                	beqz	a0,aba <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a5a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a5c:	4798                	lw	a4,8(a5)
 a5e:	02977263          	bgeu	a4,s1,a82 <malloc+0xb6>
    if(p == freep)
 a62:	00093703          	ld	a4,0(s2)
 a66:	853e                	mv	a0,a5
 a68:	fef719e3          	bne	a4,a5,a5a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a6c:	8552                	mv	a0,s4
 a6e:	b03ff0ef          	jal	570 <sbrk>
  if(p == (char*)-1)
 a72:	fd551ce3          	bne	a0,s5,a4a <malloc+0x7e>
        return 0;
 a76:	4501                	li	a0,0
 a78:	7902                	ld	s2,32(sp)
 a7a:	6a42                	ld	s4,16(sp)
 a7c:	6aa2                	ld	s5,8(sp)
 a7e:	6b02                	ld	s6,0(sp)
 a80:	a03d                	j	aae <malloc+0xe2>
 a82:	7902                	ld	s2,32(sp)
 a84:	6a42                	ld	s4,16(sp)
 a86:	6aa2                	ld	s5,8(sp)
 a88:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a8a:	fae48de3          	beq	s1,a4,a44 <malloc+0x78>
        p->s.size -= nunits;
 a8e:	4137073b          	subw	a4,a4,s3
 a92:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a94:	02071693          	slli	a3,a4,0x20
 a98:	01c6d713          	srli	a4,a3,0x1c
 a9c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a9e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aa2:	00001717          	auipc	a4,0x1
 aa6:	54a73f23          	sd	a0,1374(a4) # 2000 <freep>
      return (void*)(p + 1);
 aaa:	01078513          	addi	a0,a5,16
  }
}
 aae:	70e2                	ld	ra,56(sp)
 ab0:	7442                	ld	s0,48(sp)
 ab2:	74a2                	ld	s1,40(sp)
 ab4:	69e2                	ld	s3,24(sp)
 ab6:	6121                	addi	sp,sp,64
 ab8:	8082                	ret
 aba:	7902                	ld	s2,32(sp)
 abc:	6a42                	ld	s4,16(sp)
 abe:	6aa2                	ld	s5,8(sp)
 ac0:	6b02                	ld	s6,0(sp)
 ac2:	b7f5                	j	aae <malloc+0xe2>
