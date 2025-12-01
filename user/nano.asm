
user/_nano:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fcntl.h"
#include "user/user.h"

char buf[512];

int main(int argc, char *argv[]) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
    if(argc != 2){
   8:	4789                	li	a5,2
   a:	00f50f63          	beq	a0,a5,28 <main+0x28>
   e:	ec26                	sd	s1,24(sp)
  10:	e84a                	sd	s2,16(sp)
  12:	e44e                	sd	s3,8(sp)
  14:	e052                	sd	s4,0(sp)
        printf("Usage: nano filename\n");
  16:	00001517          	auipc	a0,0x1
  1a:	92a50513          	addi	a0,a0,-1750 # 940 <malloc+0xfe>
  1e:	770000ef          	jal	78e <printf>
        exit(1);
  22:	4505                	li	a0,1
  24:	34a000ef          	jal	36e <exit>
  28:	e84a                	sd	s2,16(sp)
  2a:	e052                	sd	s4,0(sp)
    }

    char *filename = argv[1];
  2c:	0085ba03          	ld	s4,8(a1)
    int fd = open(filename, O_CREATE | O_RDWR);
  30:	20200593          	li	a1,514
  34:	8552                	mv	a0,s4
  36:	378000ef          	jal	3ae <open>
  3a:	892a                	mv	s2,a0
    if(fd < 0){
  3c:	00054f63          	bltz	a0,5a <main+0x5a>
  40:	ec26                	sd	s1,24(sp)
  42:	e44e                	sd	s3,8(sp)
        exit(1);
    }

    int n;

    printf("Simple nano editor. Type lines and end with Ctrl+D\n");
  44:	00001517          	auipc	a0,0x1
  48:	93450513          	addi	a0,a0,-1740 # 978 <malloc+0x136>
  4c:	742000ef          	jal	78e <printf>

    // Read and display existing file content
    while((n = read(fd, buf, sizeof(buf))) > 0){
  50:	00001497          	auipc	s1,0x1
  54:	fc048493          	addi	s1,s1,-64 # 1010 <buf>
  58:	a00d                	j	7a <main+0x7a>
  5a:	ec26                	sd	s1,24(sp)
  5c:	e44e                	sd	s3,8(sp)
        printf("nano: cannot open %s\n", filename);
  5e:	85d2                	mv	a1,s4
  60:	00001517          	auipc	a0,0x1
  64:	90050513          	addi	a0,a0,-1792 # 960 <malloc+0x11e>
  68:	726000ef          	jal	78e <printf>
        exit(1);
  6c:	4505                	li	a0,1
  6e:	300000ef          	jal	36e <exit>
        write(1, buf, n);
  72:	85a6                	mv	a1,s1
  74:	4505                	li	a0,1
  76:	318000ef          	jal	38e <write>
    while((n = read(fd, buf, sizeof(buf))) > 0){
  7a:	20000613          	li	a2,512
  7e:	85a6                	mv	a1,s1
  80:	854a                	mv	a0,s2
  82:	304000ef          	jal	386 <read>
  86:	862a                	mv	a2,a0
  88:	fea045e3          	bgtz	a0,72 <main+0x72>
    }

    // xv6 doesn’t have lseek, so just close & reopen for writing at the end
    close(fd);
  8c:	854a                	mv	a0,s2
  8e:	308000ef          	jal	396 <close>
    fd = open(filename, O_CREATE | O_WRONLY);
  92:	20100593          	li	a1,513
  96:	8552                	mv	a0,s4
  98:	316000ef          	jal	3ae <open>
  9c:	89aa                	mv	s3,a0
        printf("nano: cannot reopen %s\n", filename);
        exit(1);
    }

    // Read from stdin and write to file
    while((n = read(0, buf, sizeof(buf))) > 0){
  9e:	00001917          	auipc	s2,0x1
  a2:	f7290913          	addi	s2,s2,-142 # 1010 <buf>
    if(fd < 0){
  a6:	04054563          	bltz	a0,f0 <main+0xf0>
    while((n = read(0, buf, sizeof(buf))) > 0){
  aa:	20000613          	li	a2,512
  ae:	85ca                	mv	a1,s2
  b0:	4501                	li	a0,0
  b2:	2d4000ef          	jal	386 <read>
  b6:	84aa                	mv	s1,a0
  b8:	00a05f63          	blez	a0,d6 <main+0xd6>
        if(write(fd, buf, n) != n){
  bc:	8626                	mv	a2,s1
  be:	85ca                	mv	a1,s2
  c0:	854e                	mv	a0,s3
  c2:	2cc000ef          	jal	38e <write>
  c6:	fe9502e3          	beq	a0,s1,aa <main+0xaa>
            printf("nano: write error\n");
  ca:	00001517          	auipc	a0,0x1
  ce:	8fe50513          	addi	a0,a0,-1794 # 9c8 <malloc+0x186>
  d2:	6bc000ef          	jal	78e <printf>
            break;
        }
    }

    close(fd);
  d6:	854e                	mv	a0,s3
  d8:	2be000ef          	jal	396 <close>
    printf("\nSaved %s\n", filename);
  dc:	85d2                	mv	a1,s4
  de:	00001517          	auipc	a0,0x1
  e2:	90250513          	addi	a0,a0,-1790 # 9e0 <malloc+0x19e>
  e6:	6a8000ef          	jal	78e <printf>
    exit(0);
  ea:	4501                	li	a0,0
  ec:	282000ef          	jal	36e <exit>
        printf("nano: cannot reopen %s\n", filename);
  f0:	85d2                	mv	a1,s4
  f2:	00001517          	auipc	a0,0x1
  f6:	8be50513          	addi	a0,a0,-1858 # 9b0 <malloc+0x16e>
  fa:	694000ef          	jal	78e <printf>
        exit(1);
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
 366:	4885                	li	a7,1
 368:	00000073          	ecall
 36c:	8082                	ret

000000000000036e <exit>:
 36e:	4889                	li	a7,2
 370:	00000073          	ecall
 374:	8082                	ret

0000000000000376 <wait>:
 376:	488d                	li	a7,3
 378:	00000073          	ecall
 37c:	8082                	ret

000000000000037e <pipe>:
 37e:	4891                	li	a7,4
 380:	00000073          	ecall
 384:	8082                	ret

0000000000000386 <read>:
 386:	4895                	li	a7,5
 388:	00000073          	ecall
 38c:	8082                	ret

000000000000038e <write>:
 38e:	48c1                	li	a7,16
 390:	00000073          	ecall
 394:	8082                	ret

0000000000000396 <close>:
 396:	48d5                	li	a7,21
 398:	00000073          	ecall
 39c:	8082                	ret

000000000000039e <kill>:
 39e:	4899                	li	a7,6
 3a0:	00000073          	ecall
 3a4:	8082                	ret

00000000000003a6 <exec>:
 3a6:	489d                	li	a7,7
 3a8:	00000073          	ecall
 3ac:	8082                	ret

00000000000003ae <open>:
 3ae:	48bd                	li	a7,15
 3b0:	00000073          	ecall
 3b4:	8082                	ret

00000000000003b6 <mknod>:
 3b6:	48c5                	li	a7,17
 3b8:	00000073          	ecall
 3bc:	8082                	ret

00000000000003be <unlink>:
 3be:	48c9                	li	a7,18
 3c0:	00000073          	ecall
 3c4:	8082                	ret

00000000000003c6 <fstat>:
 3c6:	48a1                	li	a7,8
 3c8:	00000073          	ecall
 3cc:	8082                	ret

00000000000003ce <link>:
 3ce:	48cd                	li	a7,19
 3d0:	00000073          	ecall
 3d4:	8082                	ret

00000000000003d6 <mkdir>:
 3d6:	48d1                	li	a7,20
 3d8:	00000073          	ecall
 3dc:	8082                	ret

00000000000003de <chdir>:
 3de:	48a5                	li	a7,9
 3e0:	00000073          	ecall
 3e4:	8082                	ret

00000000000003e6 <dup>:
 3e6:	48a9                	li	a7,10
 3e8:	00000073          	ecall
 3ec:	8082                	ret

00000000000003ee <getpid>:
 3ee:	48ad                	li	a7,11
 3f0:	00000073          	ecall
 3f4:	8082                	ret

00000000000003f6 <sbrk>:
 3f6:	48b1                	li	a7,12
 3f8:	00000073          	ecall
 3fc:	8082                	ret

00000000000003fe <sleep>:
 3fe:	48b5                	li	a7,13
 400:	00000073          	ecall
 404:	8082                	ret

0000000000000406 <uptime>:
 406:	48b9                	li	a7,14
 408:	00000073          	ecall
 40c:	8082                	ret

000000000000040e <kbdint>:
 40e:	48d9                	li	a7,22
 410:	00000073          	ecall
 414:	8082                	ret

0000000000000416 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 416:	1101                	addi	sp,sp,-32
 418:	ec06                	sd	ra,24(sp)
 41a:	e822                	sd	s0,16(sp)
 41c:	1000                	addi	s0,sp,32
 41e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 422:	4605                	li	a2,1
 424:	fef40593          	addi	a1,s0,-17
 428:	f67ff0ef          	jal	38e <write>
}
 42c:	60e2                	ld	ra,24(sp)
 42e:	6442                	ld	s0,16(sp)
 430:	6105                	addi	sp,sp,32
 432:	8082                	ret

0000000000000434 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 434:	7139                	addi	sp,sp,-64
 436:	fc06                	sd	ra,56(sp)
 438:	f822                	sd	s0,48(sp)
 43a:	f426                	sd	s1,40(sp)
 43c:	0080                	addi	s0,sp,64
 43e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 440:	c299                	beqz	a3,446 <printint+0x12>
 442:	0805c963          	bltz	a1,4d4 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 446:	2581                	sext.w	a1,a1
  neg = 0;
 448:	4881                	li	a7,0
 44a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 44e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 450:	2601                	sext.w	a2,a2
 452:	00000517          	auipc	a0,0x0
 456:	5a650513          	addi	a0,a0,1446 # 9f8 <digits>
 45a:	883a                	mv	a6,a4
 45c:	2705                	addiw	a4,a4,1
 45e:	02c5f7bb          	remuw	a5,a1,a2
 462:	1782                	slli	a5,a5,0x20
 464:	9381                	srli	a5,a5,0x20
 466:	97aa                	add	a5,a5,a0
 468:	0007c783          	lbu	a5,0(a5)
 46c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 470:	0005879b          	sext.w	a5,a1
 474:	02c5d5bb          	divuw	a1,a1,a2
 478:	0685                	addi	a3,a3,1
 47a:	fec7f0e3          	bgeu	a5,a2,45a <printint+0x26>
  if(neg)
 47e:	00088c63          	beqz	a7,496 <printint+0x62>
    buf[i++] = '-';
 482:	fd070793          	addi	a5,a4,-48
 486:	00878733          	add	a4,a5,s0
 48a:	02d00793          	li	a5,45
 48e:	fef70823          	sb	a5,-16(a4)
 492:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 496:	02e05a63          	blez	a4,4ca <printint+0x96>
 49a:	f04a                	sd	s2,32(sp)
 49c:	ec4e                	sd	s3,24(sp)
 49e:	fc040793          	addi	a5,s0,-64
 4a2:	00e78933          	add	s2,a5,a4
 4a6:	fff78993          	addi	s3,a5,-1
 4aa:	99ba                	add	s3,s3,a4
 4ac:	377d                	addiw	a4,a4,-1
 4ae:	1702                	slli	a4,a4,0x20
 4b0:	9301                	srli	a4,a4,0x20
 4b2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4b6:	fff94583          	lbu	a1,-1(s2)
 4ba:	8526                	mv	a0,s1
 4bc:	f5bff0ef          	jal	416 <putc>
  while(--i >= 0)
 4c0:	197d                	addi	s2,s2,-1
 4c2:	ff391ae3          	bne	s2,s3,4b6 <printint+0x82>
 4c6:	7902                	ld	s2,32(sp)
 4c8:	69e2                	ld	s3,24(sp)
}
 4ca:	70e2                	ld	ra,56(sp)
 4cc:	7442                	ld	s0,48(sp)
 4ce:	74a2                	ld	s1,40(sp)
 4d0:	6121                	addi	sp,sp,64
 4d2:	8082                	ret
    x = -xx;
 4d4:	40b005bb          	negw	a1,a1
    neg = 1;
 4d8:	4885                	li	a7,1
    x = -xx;
 4da:	bf85                	j	44a <printint+0x16>

00000000000004dc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4dc:	711d                	addi	sp,sp,-96
 4de:	ec86                	sd	ra,88(sp)
 4e0:	e8a2                	sd	s0,80(sp)
 4e2:	e0ca                	sd	s2,64(sp)
 4e4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4e6:	0005c903          	lbu	s2,0(a1)
 4ea:	26090863          	beqz	s2,75a <vprintf+0x27e>
 4ee:	e4a6                	sd	s1,72(sp)
 4f0:	fc4e                	sd	s3,56(sp)
 4f2:	f852                	sd	s4,48(sp)
 4f4:	f456                	sd	s5,40(sp)
 4f6:	f05a                	sd	s6,32(sp)
 4f8:	ec5e                	sd	s7,24(sp)
 4fa:	e862                	sd	s8,16(sp)
 4fc:	e466                	sd	s9,8(sp)
 4fe:	8b2a                	mv	s6,a0
 500:	8a2e                	mv	s4,a1
 502:	8bb2                	mv	s7,a2
  state = 0;
 504:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 506:	4481                	li	s1,0
 508:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 50a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 50e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 512:	06c00c93          	li	s9,108
 516:	a005                	j	536 <vprintf+0x5a>
        putc(fd, c0);
 518:	85ca                	mv	a1,s2
 51a:	855a                	mv	a0,s6
 51c:	efbff0ef          	jal	416 <putc>
 520:	a019                	j	526 <vprintf+0x4a>
    } else if(state == '%'){
 522:	03598263          	beq	s3,s5,546 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 526:	2485                	addiw	s1,s1,1
 528:	8726                	mv	a4,s1
 52a:	009a07b3          	add	a5,s4,s1
 52e:	0007c903          	lbu	s2,0(a5)
 532:	20090c63          	beqz	s2,74a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 536:	0009079b          	sext.w	a5,s2
    if(state == 0){
 53a:	fe0994e3          	bnez	s3,522 <vprintf+0x46>
      if(c0 == '%'){
 53e:	fd579de3          	bne	a5,s5,518 <vprintf+0x3c>
        state = '%';
 542:	89be                	mv	s3,a5
 544:	b7cd                	j	526 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 546:	00ea06b3          	add	a3,s4,a4
 54a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 54e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 550:	c681                	beqz	a3,558 <vprintf+0x7c>
 552:	9752                	add	a4,a4,s4
 554:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 558:	03878f63          	beq	a5,s8,596 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 55c:	05978963          	beq	a5,s9,5ae <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 560:	07500713          	li	a4,117
 564:	0ee78363          	beq	a5,a4,64a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 568:	07800713          	li	a4,120
 56c:	12e78563          	beq	a5,a4,696 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 570:	07000713          	li	a4,112
 574:	14e78a63          	beq	a5,a4,6c8 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 578:	07300713          	li	a4,115
 57c:	18e78a63          	beq	a5,a4,710 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 580:	02500713          	li	a4,37
 584:	04e79563          	bne	a5,a4,5ce <vprintf+0xf2>
        putc(fd, '%');
 588:	02500593          	li	a1,37
 58c:	855a                	mv	a0,s6
 58e:	e89ff0ef          	jal	416 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 592:	4981                	li	s3,0
 594:	bf49                	j	526 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 596:	008b8913          	addi	s2,s7,8
 59a:	4685                	li	a3,1
 59c:	4629                	li	a2,10
 59e:	000ba583          	lw	a1,0(s7)
 5a2:	855a                	mv	a0,s6
 5a4:	e91ff0ef          	jal	434 <printint>
 5a8:	8bca                	mv	s7,s2
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	bfad                	j	526 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5ae:	06400793          	li	a5,100
 5b2:	02f68963          	beq	a3,a5,5e4 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5b6:	06c00793          	li	a5,108
 5ba:	04f68263          	beq	a3,a5,5fe <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5be:	07500793          	li	a5,117
 5c2:	0af68063          	beq	a3,a5,662 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5c6:	07800793          	li	a5,120
 5ca:	0ef68263          	beq	a3,a5,6ae <vprintf+0x1d2>
        putc(fd, '%');
 5ce:	02500593          	li	a1,37
 5d2:	855a                	mv	a0,s6
 5d4:	e43ff0ef          	jal	416 <putc>
        putc(fd, c0);
 5d8:	85ca                	mv	a1,s2
 5da:	855a                	mv	a0,s6
 5dc:	e3bff0ef          	jal	416 <putc>
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b791                	j	526 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e4:	008b8913          	addi	s2,s7,8
 5e8:	4685                	li	a3,1
 5ea:	4629                	li	a2,10
 5ec:	000ba583          	lw	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	e43ff0ef          	jal	434 <printint>
        i += 1;
 5f6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f8:	8bca                	mv	s7,s2
      state = 0;
 5fa:	4981                	li	s3,0
        i += 1;
 5fc:	b72d                	j	526 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5fe:	06400793          	li	a5,100
 602:	02f60763          	beq	a2,a5,630 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 606:	07500793          	li	a5,117
 60a:	06f60963          	beq	a2,a5,67c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 60e:	07800793          	li	a5,120
 612:	faf61ee3          	bne	a2,a5,5ce <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 616:	008b8913          	addi	s2,s7,8
 61a:	4681                	li	a3,0
 61c:	4641                	li	a2,16
 61e:	000ba583          	lw	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	e11ff0ef          	jal	434 <printint>
        i += 2;
 628:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 62a:	8bca                	mv	s7,s2
      state = 0;
 62c:	4981                	li	s3,0
        i += 2;
 62e:	bde5                	j	526 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 630:	008b8913          	addi	s2,s7,8
 634:	4685                	li	a3,1
 636:	4629                	li	a2,10
 638:	000ba583          	lw	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	df7ff0ef          	jal	434 <printint>
        i += 2;
 642:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 644:	8bca                	mv	s7,s2
      state = 0;
 646:	4981                	li	s3,0
        i += 2;
 648:	bdf9                	j	526 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 64a:	008b8913          	addi	s2,s7,8
 64e:	4681                	li	a3,0
 650:	4629                	li	a2,10
 652:	000ba583          	lw	a1,0(s7)
 656:	855a                	mv	a0,s6
 658:	dddff0ef          	jal	434 <printint>
 65c:	8bca                	mv	s7,s2
      state = 0;
 65e:	4981                	li	s3,0
 660:	b5d9                	j	526 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 662:	008b8913          	addi	s2,s7,8
 666:	4681                	li	a3,0
 668:	4629                	li	a2,10
 66a:	000ba583          	lw	a1,0(s7)
 66e:	855a                	mv	a0,s6
 670:	dc5ff0ef          	jal	434 <printint>
        i += 1;
 674:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 676:	8bca                	mv	s7,s2
      state = 0;
 678:	4981                	li	s3,0
        i += 1;
 67a:	b575                	j	526 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 67c:	008b8913          	addi	s2,s7,8
 680:	4681                	li	a3,0
 682:	4629                	li	a2,10
 684:	000ba583          	lw	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	dabff0ef          	jal	434 <printint>
        i += 2;
 68e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 690:	8bca                	mv	s7,s2
      state = 0;
 692:	4981                	li	s3,0
        i += 2;
 694:	bd49                	j	526 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 696:	008b8913          	addi	s2,s7,8
 69a:	4681                	li	a3,0
 69c:	4641                	li	a2,16
 69e:	000ba583          	lw	a1,0(s7)
 6a2:	855a                	mv	a0,s6
 6a4:	d91ff0ef          	jal	434 <printint>
 6a8:	8bca                	mv	s7,s2
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bdad                	j	526 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ae:	008b8913          	addi	s2,s7,8
 6b2:	4681                	li	a3,0
 6b4:	4641                	li	a2,16
 6b6:	000ba583          	lw	a1,0(s7)
 6ba:	855a                	mv	a0,s6
 6bc:	d79ff0ef          	jal	434 <printint>
        i += 1;
 6c0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c2:	8bca                	mv	s7,s2
      state = 0;
 6c4:	4981                	li	s3,0
        i += 1;
 6c6:	b585                	j	526 <vprintf+0x4a>
 6c8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6ca:	008b8d13          	addi	s10,s7,8
 6ce:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6d2:	03000593          	li	a1,48
 6d6:	855a                	mv	a0,s6
 6d8:	d3fff0ef          	jal	416 <putc>
  putc(fd, 'x');
 6dc:	07800593          	li	a1,120
 6e0:	855a                	mv	a0,s6
 6e2:	d35ff0ef          	jal	416 <putc>
 6e6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e8:	00000b97          	auipc	s7,0x0
 6ec:	310b8b93          	addi	s7,s7,784 # 9f8 <digits>
 6f0:	03c9d793          	srli	a5,s3,0x3c
 6f4:	97de                	add	a5,a5,s7
 6f6:	0007c583          	lbu	a1,0(a5)
 6fa:	855a                	mv	a0,s6
 6fc:	d1bff0ef          	jal	416 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 700:	0992                	slli	s3,s3,0x4
 702:	397d                	addiw	s2,s2,-1
 704:	fe0916e3          	bnez	s2,6f0 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 708:	8bea                	mv	s7,s10
      state = 0;
 70a:	4981                	li	s3,0
 70c:	6d02                	ld	s10,0(sp)
 70e:	bd21                	j	526 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 710:	008b8993          	addi	s3,s7,8
 714:	000bb903          	ld	s2,0(s7)
 718:	00090f63          	beqz	s2,736 <vprintf+0x25a>
        for(; *s; s++)
 71c:	00094583          	lbu	a1,0(s2)
 720:	c195                	beqz	a1,744 <vprintf+0x268>
          putc(fd, *s);
 722:	855a                	mv	a0,s6
 724:	cf3ff0ef          	jal	416 <putc>
        for(; *s; s++)
 728:	0905                	addi	s2,s2,1
 72a:	00094583          	lbu	a1,0(s2)
 72e:	f9f5                	bnez	a1,722 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 730:	8bce                	mv	s7,s3
      state = 0;
 732:	4981                	li	s3,0
 734:	bbcd                	j	526 <vprintf+0x4a>
          s = "(null)";
 736:	00000917          	auipc	s2,0x0
 73a:	2ba90913          	addi	s2,s2,698 # 9f0 <malloc+0x1ae>
        for(; *s; s++)
 73e:	02800593          	li	a1,40
 742:	b7c5                	j	722 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 744:	8bce                	mv	s7,s3
      state = 0;
 746:	4981                	li	s3,0
 748:	bbf9                	j	526 <vprintf+0x4a>
 74a:	64a6                	ld	s1,72(sp)
 74c:	79e2                	ld	s3,56(sp)
 74e:	7a42                	ld	s4,48(sp)
 750:	7aa2                	ld	s5,40(sp)
 752:	7b02                	ld	s6,32(sp)
 754:	6be2                	ld	s7,24(sp)
 756:	6c42                	ld	s8,16(sp)
 758:	6ca2                	ld	s9,8(sp)
    }
  }
}
 75a:	60e6                	ld	ra,88(sp)
 75c:	6446                	ld	s0,80(sp)
 75e:	6906                	ld	s2,64(sp)
 760:	6125                	addi	sp,sp,96
 762:	8082                	ret

0000000000000764 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 764:	715d                	addi	sp,sp,-80
 766:	ec06                	sd	ra,24(sp)
 768:	e822                	sd	s0,16(sp)
 76a:	1000                	addi	s0,sp,32
 76c:	e010                	sd	a2,0(s0)
 76e:	e414                	sd	a3,8(s0)
 770:	e818                	sd	a4,16(s0)
 772:	ec1c                	sd	a5,24(s0)
 774:	03043023          	sd	a6,32(s0)
 778:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 77c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 780:	8622                	mv	a2,s0
 782:	d5bff0ef          	jal	4dc <vprintf>
}
 786:	60e2                	ld	ra,24(sp)
 788:	6442                	ld	s0,16(sp)
 78a:	6161                	addi	sp,sp,80
 78c:	8082                	ret

000000000000078e <printf>:

void
printf(const char *fmt, ...)
{
 78e:	711d                	addi	sp,sp,-96
 790:	ec06                	sd	ra,24(sp)
 792:	e822                	sd	s0,16(sp)
 794:	1000                	addi	s0,sp,32
 796:	e40c                	sd	a1,8(s0)
 798:	e810                	sd	a2,16(s0)
 79a:	ec14                	sd	a3,24(s0)
 79c:	f018                	sd	a4,32(s0)
 79e:	f41c                	sd	a5,40(s0)
 7a0:	03043823          	sd	a6,48(s0)
 7a4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7a8:	00840613          	addi	a2,s0,8
 7ac:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7b0:	85aa                	mv	a1,a0
 7b2:	4505                	li	a0,1
 7b4:	d29ff0ef          	jal	4dc <vprintf>
}
 7b8:	60e2                	ld	ra,24(sp)
 7ba:	6442                	ld	s0,16(sp)
 7bc:	6125                	addi	sp,sp,96
 7be:	8082                	ret

00000000000007c0 <free>:
 7c0:	1141                	addi	sp,sp,-16
 7c2:	e422                	sd	s0,8(sp)
 7c4:	0800                	addi	s0,sp,16
 7c6:	ff050693          	addi	a3,a0,-16
 7ca:	00001797          	auipc	a5,0x1
 7ce:	8367b783          	ld	a5,-1994(a5) # 1000 <freep>
 7d2:	a02d                	j	7fc <free+0x3c>
 7d4:	4618                	lw	a4,8(a2)
 7d6:	9f2d                	addw	a4,a4,a1
 7d8:	fee52c23          	sw	a4,-8(a0)
 7dc:	6398                	ld	a4,0(a5)
 7de:	6310                	ld	a2,0(a4)
 7e0:	a83d                	j	81e <free+0x5e>
 7e2:	ff852703          	lw	a4,-8(a0)
 7e6:	9f31                	addw	a4,a4,a2
 7e8:	c798                	sw	a4,8(a5)
 7ea:	ff053683          	ld	a3,-16(a0)
 7ee:	a091                	j	832 <free+0x72>
 7f0:	6398                	ld	a4,0(a5)
 7f2:	00e7e463          	bltu	a5,a4,7fa <free+0x3a>
 7f6:	00e6ea63          	bltu	a3,a4,80a <free+0x4a>
 7fa:	87ba                	mv	a5,a4
 7fc:	fed7fae3          	bgeu	a5,a3,7f0 <free+0x30>
 800:	6398                	ld	a4,0(a5)
 802:	00e6e463          	bltu	a3,a4,80a <free+0x4a>
 806:	fee7eae3          	bltu	a5,a4,7fa <free+0x3a>
 80a:	ff852583          	lw	a1,-8(a0)
 80e:	6390                	ld	a2,0(a5)
 810:	02059813          	slli	a6,a1,0x20
 814:	01c85713          	srli	a4,a6,0x1c
 818:	9736                	add	a4,a4,a3
 81a:	fae60de3          	beq	a2,a4,7d4 <free+0x14>
 81e:	fec53823          	sd	a2,-16(a0)
 822:	4790                	lw	a2,8(a5)
 824:	02061593          	slli	a1,a2,0x20
 828:	01c5d713          	srli	a4,a1,0x1c
 82c:	973e                	add	a4,a4,a5
 82e:	fae68ae3          	beq	a3,a4,7e2 <free+0x22>
 832:	e394                	sd	a3,0(a5)
 834:	00000717          	auipc	a4,0x0
 838:	7cf73623          	sd	a5,1996(a4) # 1000 <freep>
 83c:	6422                	ld	s0,8(sp)
 83e:	0141                	addi	sp,sp,16
 840:	8082                	ret

0000000000000842 <malloc>:
 842:	7139                	addi	sp,sp,-64
 844:	fc06                	sd	ra,56(sp)
 846:	f822                	sd	s0,48(sp)
 848:	f426                	sd	s1,40(sp)
 84a:	ec4e                	sd	s3,24(sp)
 84c:	0080                	addi	s0,sp,64
 84e:	02051493          	slli	s1,a0,0x20
 852:	9081                	srli	s1,s1,0x20
 854:	04bd                	addi	s1,s1,15
 856:	8091                	srli	s1,s1,0x4
 858:	0014899b          	addiw	s3,s1,1
 85c:	0485                	addi	s1,s1,1
 85e:	00000517          	auipc	a0,0x0
 862:	7a253503          	ld	a0,1954(a0) # 1000 <freep>
 866:	c915                	beqz	a0,89a <malloc+0x58>
 868:	611c                	ld	a5,0(a0)
 86a:	4798                	lw	a4,8(a5)
 86c:	08977a63          	bgeu	a4,s1,900 <malloc+0xbe>
 870:	f04a                	sd	s2,32(sp)
 872:	e852                	sd	s4,16(sp)
 874:	e456                	sd	s5,8(sp)
 876:	e05a                	sd	s6,0(sp)
 878:	8a4e                	mv	s4,s3
 87a:	0009871b          	sext.w	a4,s3
 87e:	6685                	lui	a3,0x1
 880:	00d77363          	bgeu	a4,a3,886 <malloc+0x44>
 884:	6a05                	lui	s4,0x1
 886:	000a0b1b          	sext.w	s6,s4
 88a:	004a1a1b          	slliw	s4,s4,0x4
 88e:	00000917          	auipc	s2,0x0
 892:	77290913          	addi	s2,s2,1906 # 1000 <freep>
 896:	5afd                	li	s5,-1
 898:	a081                	j	8d8 <malloc+0x96>
 89a:	f04a                	sd	s2,32(sp)
 89c:	e852                	sd	s4,16(sp)
 89e:	e456                	sd	s5,8(sp)
 8a0:	e05a                	sd	s6,0(sp)
 8a2:	00001797          	auipc	a5,0x1
 8a6:	96e78793          	addi	a5,a5,-1682 # 1210 <base>
 8aa:	00000717          	auipc	a4,0x0
 8ae:	74f73b23          	sd	a5,1878(a4) # 1000 <freep>
 8b2:	e39c                	sd	a5,0(a5)
 8b4:	0007a423          	sw	zero,8(a5)
 8b8:	b7c1                	j	878 <malloc+0x36>
 8ba:	6398                	ld	a4,0(a5)
 8bc:	e118                	sd	a4,0(a0)
 8be:	a8a9                	j	918 <malloc+0xd6>
 8c0:	01652423          	sw	s6,8(a0)
 8c4:	0541                	addi	a0,a0,16
 8c6:	efbff0ef          	jal	7c0 <free>
 8ca:	00093503          	ld	a0,0(s2)
 8ce:	c12d                	beqz	a0,930 <malloc+0xee>
 8d0:	611c                	ld	a5,0(a0)
 8d2:	4798                	lw	a4,8(a5)
 8d4:	02977263          	bgeu	a4,s1,8f8 <malloc+0xb6>
 8d8:	00093703          	ld	a4,0(s2)
 8dc:	853e                	mv	a0,a5
 8de:	fef719e3          	bne	a4,a5,8d0 <malloc+0x8e>
 8e2:	8552                	mv	a0,s4
 8e4:	b13ff0ef          	jal	3f6 <sbrk>
 8e8:	fd551ce3          	bne	a0,s5,8c0 <malloc+0x7e>
 8ec:	4501                	li	a0,0
 8ee:	7902                	ld	s2,32(sp)
 8f0:	6a42                	ld	s4,16(sp)
 8f2:	6aa2                	ld	s5,8(sp)
 8f4:	6b02                	ld	s6,0(sp)
 8f6:	a03d                	j	924 <malloc+0xe2>
 8f8:	7902                	ld	s2,32(sp)
 8fa:	6a42                	ld	s4,16(sp)
 8fc:	6aa2                	ld	s5,8(sp)
 8fe:	6b02                	ld	s6,0(sp)
 900:	fae48de3          	beq	s1,a4,8ba <malloc+0x78>
 904:	4137073b          	subw	a4,a4,s3
 908:	c798                	sw	a4,8(a5)
 90a:	02071693          	slli	a3,a4,0x20
 90e:	01c6d713          	srli	a4,a3,0x1c
 912:	97ba                	add	a5,a5,a4
 914:	0137a423          	sw	s3,8(a5)
 918:	00000717          	auipc	a4,0x0
 91c:	6ea73423          	sd	a0,1768(a4) # 1000 <freep>
 920:	01078513          	addi	a0,a5,16
 924:	70e2                	ld	ra,56(sp)
 926:	7442                	ld	s0,48(sp)
 928:	74a2                	ld	s1,40(sp)
 92a:	69e2                	ld	s3,24(sp)
 92c:	6121                	addi	sp,sp,64
 92e:	8082                	ret
 930:	7902                	ld	s2,32(sp)
 932:	6a42                	ld	s4,16(sp)
 934:	6aa2                	ld	s5,8(sp)
 936:	6b02                	ld	s6,0(sp)
 938:	b7f5                	j	924 <malloc+0xe2>
