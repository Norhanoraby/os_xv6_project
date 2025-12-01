
user/_cp:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	1c00                	addi	s0,sp,560
 int fd_src, fd_dest;
    char buf[512];
    int n;
    int w;

    if (argc != 3) {
   e:	478d                	li	a5,3
  10:	02f50163          	beq	a0,a5,32 <main+0x32>
  14:	20913c23          	sd	s1,536(sp)
  18:	21213823          	sd	s2,528(sp)
  1c:	21313423          	sd	s3,520(sp)
        printf("Usage: cp source_file dest_file\n");
  20:	00001517          	auipc	a0,0x1
  24:	91050513          	addi	a0,a0,-1776 # 930 <malloc+0xfc>
  28:	758000ef          	jal	780 <printf>
        exit(0);
  2c:	4501                	li	a0,0
  2e:	332000ef          	jal	360 <exit>
  32:	20913c23          	sd	s1,536(sp)
  36:	21213823          	sd	s2,528(sp)
  3a:	84ae                	mv	s1,a1
    }

    // Open source file for reading
    fd_src = open(argv[1], O_RDONLY);
  3c:	4581                	li	a1,0
  3e:	6488                	ld	a0,8(s1)
  40:	360000ef          	jal	3a0 <open>
  44:	892a                	mv	s2,a0
    if (fd_src < 0) {
  46:	04054d63          	bltz	a0,a0 <main+0xa0>
  4a:	21313423          	sd	s3,520(sp)
        printf("cp: cannot open source file %s\n", argv[1]);
        exit(0);
    }

    // Open (or create) destination file for writing
    fd_dest = open(argv[2], O_CREATE | O_WRONLY);
  4e:	20100593          	li	a1,513
  52:	6888                	ld	a0,16(s1)
  54:	34c000ef          	jal	3a0 <open>
  58:	89aa                	mv	s3,a0
    if (fd_dest < 0) {
  5a:	04054f63          	bltz	a0,b8 <main+0xb8>
        close(fd_src);
        exit(0);
    }

    // Copy data from source to destination
    while ((n = read(fd_src, buf, sizeof(buf))) > 0) {
  5e:	20000613          	li	a2,512
  62:	dd040593          	addi	a1,s0,-560
  66:	854a                	mv	a0,s2
  68:	310000ef          	jal	378 <read>
  6c:	84aa                	mv	s1,a0
  6e:	06a05263          	blez	a0,d2 <main+0xd2>
      w = write(fd_dest, buf, n);
  72:	8626                	mv	a2,s1
  74:	dd040593          	addi	a1,s0,-560
  78:	854e                	mv	a0,s3
  7a:	306000ef          	jal	380 <write>
        if (w!= n) {
  7e:	fea480e3          	beq	s1,a0,5e <main+0x5e>
            printf("cp: write error\n");
  82:	00001517          	auipc	a0,0x1
  86:	91e50513          	addi	a0,a0,-1762 # 9a0 <malloc+0x16c>
  8a:	6f6000ef          	jal	780 <printf>
            close(fd_src);
  8e:	854a                	mv	a0,s2
  90:	2f8000ef          	jal	388 <close>
            close(fd_dest);
  94:	854e                	mv	a0,s3
  96:	2f2000ef          	jal	388 <close>
            exit(0);
  9a:	4501                	li	a0,0
  9c:	2c4000ef          	jal	360 <exit>
  a0:	21313423          	sd	s3,520(sp)
        printf("cp: cannot open source file %s\n", argv[1]);
  a4:	648c                	ld	a1,8(s1)
  a6:	00001517          	auipc	a0,0x1
  aa:	8b250513          	addi	a0,a0,-1870 # 958 <malloc+0x124>
  ae:	6d2000ef          	jal	780 <printf>
        exit(0);
  b2:	4501                	li	a0,0
  b4:	2ac000ef          	jal	360 <exit>
        printf("cp: cannot open destination file %s\n", argv[2]);
  b8:	688c                	ld	a1,16(s1)
  ba:	00001517          	auipc	a0,0x1
  be:	8be50513          	addi	a0,a0,-1858 # 978 <malloc+0x144>
  c2:	6be000ef          	jal	780 <printf>
        close(fd_src);
  c6:	854a                	mv	a0,s2
  c8:	2c0000ef          	jal	388 <close>
        exit(0);
  cc:	4501                	li	a0,0
  ce:	292000ef          	jal	360 <exit>
        }
    }

    if (n < 0) {
  d2:	00054b63          	bltz	a0,e8 <main+0xe8>
        printf("cp: read error\n");
    }

    close(fd_src);
  d6:	854a                	mv	a0,s2
  d8:	2b0000ef          	jal	388 <close>
    close(fd_dest);
  dc:	854e                	mv	a0,s3
  de:	2aa000ef          	jal	388 <close>
  exit(0);
  e2:	4501                	li	a0,0
  e4:	27c000ef          	jal	360 <exit>
        printf("cp: read error\n");
  e8:	00001517          	auipc	a0,0x1
  ec:	8d050513          	addi	a0,a0,-1840 # 9b8 <malloc+0x184>
  f0:	690000ef          	jal	780 <printf>
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
 358:	4885                	li	a7,1
 35a:	00000073          	ecall
 35e:	8082                	ret

0000000000000360 <exit>:
 360:	4889                	li	a7,2
 362:	00000073          	ecall
 366:	8082                	ret

0000000000000368 <wait>:
 368:	488d                	li	a7,3
 36a:	00000073          	ecall
 36e:	8082                	ret

0000000000000370 <pipe>:
 370:	4891                	li	a7,4
 372:	00000073          	ecall
 376:	8082                	ret

0000000000000378 <read>:
 378:	4895                	li	a7,5
 37a:	00000073          	ecall
 37e:	8082                	ret

0000000000000380 <write>:
 380:	48c1                	li	a7,16
 382:	00000073          	ecall
 386:	8082                	ret

0000000000000388 <close>:
 388:	48d5                	li	a7,21
 38a:	00000073          	ecall
 38e:	8082                	ret

0000000000000390 <kill>:
 390:	4899                	li	a7,6
 392:	00000073          	ecall
 396:	8082                	ret

0000000000000398 <exec>:
 398:	489d                	li	a7,7
 39a:	00000073          	ecall
 39e:	8082                	ret

00000000000003a0 <open>:
 3a0:	48bd                	li	a7,15
 3a2:	00000073          	ecall
 3a6:	8082                	ret

00000000000003a8 <mknod>:
 3a8:	48c5                	li	a7,17
 3aa:	00000073          	ecall
 3ae:	8082                	ret

00000000000003b0 <unlink>:
 3b0:	48c9                	li	a7,18
 3b2:	00000073          	ecall
 3b6:	8082                	ret

00000000000003b8 <fstat>:
 3b8:	48a1                	li	a7,8
 3ba:	00000073          	ecall
 3be:	8082                	ret

00000000000003c0 <link>:
 3c0:	48cd                	li	a7,19
 3c2:	00000073          	ecall
 3c6:	8082                	ret

00000000000003c8 <mkdir>:
 3c8:	48d1                	li	a7,20
 3ca:	00000073          	ecall
 3ce:	8082                	ret

00000000000003d0 <chdir>:
 3d0:	48a5                	li	a7,9
 3d2:	00000073          	ecall
 3d6:	8082                	ret

00000000000003d8 <dup>:
 3d8:	48a9                	li	a7,10
 3da:	00000073          	ecall
 3de:	8082                	ret

00000000000003e0 <getpid>:
 3e0:	48ad                	li	a7,11
 3e2:	00000073          	ecall
 3e6:	8082                	ret

00000000000003e8 <sbrk>:
 3e8:	48b1                	li	a7,12
 3ea:	00000073          	ecall
 3ee:	8082                	ret

00000000000003f0 <sleep>:
 3f0:	48b5                	li	a7,13
 3f2:	00000073          	ecall
 3f6:	8082                	ret

00000000000003f8 <uptime>:
 3f8:	48b9                	li	a7,14
 3fa:	00000073          	ecall
 3fe:	8082                	ret

0000000000000400 <kbdint>:
 400:	48d9                	li	a7,22
 402:	00000073          	ecall
 406:	8082                	ret

0000000000000408 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 408:	1101                	addi	sp,sp,-32
 40a:	ec06                	sd	ra,24(sp)
 40c:	e822                	sd	s0,16(sp)
 40e:	1000                	addi	s0,sp,32
 410:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 414:	4605                	li	a2,1
 416:	fef40593          	addi	a1,s0,-17
 41a:	f67ff0ef          	jal	380 <write>
}
 41e:	60e2                	ld	ra,24(sp)
 420:	6442                	ld	s0,16(sp)
 422:	6105                	addi	sp,sp,32
 424:	8082                	ret

0000000000000426 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 426:	7139                	addi	sp,sp,-64
 428:	fc06                	sd	ra,56(sp)
 42a:	f822                	sd	s0,48(sp)
 42c:	f426                	sd	s1,40(sp)
 42e:	0080                	addi	s0,sp,64
 430:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 432:	c299                	beqz	a3,438 <printint+0x12>
 434:	0805c963          	bltz	a1,4c6 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 438:	2581                	sext.w	a1,a1
  neg = 0;
 43a:	4881                	li	a7,0
 43c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 440:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 442:	2601                	sext.w	a2,a2
 444:	00000517          	auipc	a0,0x0
 448:	58c50513          	addi	a0,a0,1420 # 9d0 <digits>
 44c:	883a                	mv	a6,a4
 44e:	2705                	addiw	a4,a4,1
 450:	02c5f7bb          	remuw	a5,a1,a2
 454:	1782                	slli	a5,a5,0x20
 456:	9381                	srli	a5,a5,0x20
 458:	97aa                	add	a5,a5,a0
 45a:	0007c783          	lbu	a5,0(a5)
 45e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 462:	0005879b          	sext.w	a5,a1
 466:	02c5d5bb          	divuw	a1,a1,a2
 46a:	0685                	addi	a3,a3,1
 46c:	fec7f0e3          	bgeu	a5,a2,44c <printint+0x26>
  if(neg)
 470:	00088c63          	beqz	a7,488 <printint+0x62>
    buf[i++] = '-';
 474:	fd070793          	addi	a5,a4,-48
 478:	00878733          	add	a4,a5,s0
 47c:	02d00793          	li	a5,45
 480:	fef70823          	sb	a5,-16(a4)
 484:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 488:	02e05a63          	blez	a4,4bc <printint+0x96>
 48c:	f04a                	sd	s2,32(sp)
 48e:	ec4e                	sd	s3,24(sp)
 490:	fc040793          	addi	a5,s0,-64
 494:	00e78933          	add	s2,a5,a4
 498:	fff78993          	addi	s3,a5,-1
 49c:	99ba                	add	s3,s3,a4
 49e:	377d                	addiw	a4,a4,-1
 4a0:	1702                	slli	a4,a4,0x20
 4a2:	9301                	srli	a4,a4,0x20
 4a4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4a8:	fff94583          	lbu	a1,-1(s2)
 4ac:	8526                	mv	a0,s1
 4ae:	f5bff0ef          	jal	408 <putc>
  while(--i >= 0)
 4b2:	197d                	addi	s2,s2,-1
 4b4:	ff391ae3          	bne	s2,s3,4a8 <printint+0x82>
 4b8:	7902                	ld	s2,32(sp)
 4ba:	69e2                	ld	s3,24(sp)
}
 4bc:	70e2                	ld	ra,56(sp)
 4be:	7442                	ld	s0,48(sp)
 4c0:	74a2                	ld	s1,40(sp)
 4c2:	6121                	addi	sp,sp,64
 4c4:	8082                	ret
    x = -xx;
 4c6:	40b005bb          	negw	a1,a1
    neg = 1;
 4ca:	4885                	li	a7,1
    x = -xx;
 4cc:	bf85                	j	43c <printint+0x16>

00000000000004ce <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ce:	711d                	addi	sp,sp,-96
 4d0:	ec86                	sd	ra,88(sp)
 4d2:	e8a2                	sd	s0,80(sp)
 4d4:	e0ca                	sd	s2,64(sp)
 4d6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d8:	0005c903          	lbu	s2,0(a1)
 4dc:	26090863          	beqz	s2,74c <vprintf+0x27e>
 4e0:	e4a6                	sd	s1,72(sp)
 4e2:	fc4e                	sd	s3,56(sp)
 4e4:	f852                	sd	s4,48(sp)
 4e6:	f456                	sd	s5,40(sp)
 4e8:	f05a                	sd	s6,32(sp)
 4ea:	ec5e                	sd	s7,24(sp)
 4ec:	e862                	sd	s8,16(sp)
 4ee:	e466                	sd	s9,8(sp)
 4f0:	8b2a                	mv	s6,a0
 4f2:	8a2e                	mv	s4,a1
 4f4:	8bb2                	mv	s7,a2
  state = 0;
 4f6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4f8:	4481                	li	s1,0
 4fa:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4fc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 500:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 504:	06c00c93          	li	s9,108
 508:	a005                	j	528 <vprintf+0x5a>
        putc(fd, c0);
 50a:	85ca                	mv	a1,s2
 50c:	855a                	mv	a0,s6
 50e:	efbff0ef          	jal	408 <putc>
 512:	a019                	j	518 <vprintf+0x4a>
    } else if(state == '%'){
 514:	03598263          	beq	s3,s5,538 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 518:	2485                	addiw	s1,s1,1
 51a:	8726                	mv	a4,s1
 51c:	009a07b3          	add	a5,s4,s1
 520:	0007c903          	lbu	s2,0(a5)
 524:	20090c63          	beqz	s2,73c <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 528:	0009079b          	sext.w	a5,s2
    if(state == 0){
 52c:	fe0994e3          	bnez	s3,514 <vprintf+0x46>
      if(c0 == '%'){
 530:	fd579de3          	bne	a5,s5,50a <vprintf+0x3c>
        state = '%';
 534:	89be                	mv	s3,a5
 536:	b7cd                	j	518 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 538:	00ea06b3          	add	a3,s4,a4
 53c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 540:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 542:	c681                	beqz	a3,54a <vprintf+0x7c>
 544:	9752                	add	a4,a4,s4
 546:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 54a:	03878f63          	beq	a5,s8,588 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 54e:	05978963          	beq	a5,s9,5a0 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 552:	07500713          	li	a4,117
 556:	0ee78363          	beq	a5,a4,63c <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 55a:	07800713          	li	a4,120
 55e:	12e78563          	beq	a5,a4,688 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 562:	07000713          	li	a4,112
 566:	14e78a63          	beq	a5,a4,6ba <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 56a:	07300713          	li	a4,115
 56e:	18e78a63          	beq	a5,a4,702 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 572:	02500713          	li	a4,37
 576:	04e79563          	bne	a5,a4,5c0 <vprintf+0xf2>
        putc(fd, '%');
 57a:	02500593          	li	a1,37
 57e:	855a                	mv	a0,s6
 580:	e89ff0ef          	jal	408 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 584:	4981                	li	s3,0
 586:	bf49                	j	518 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 588:	008b8913          	addi	s2,s7,8
 58c:	4685                	li	a3,1
 58e:	4629                	li	a2,10
 590:	000ba583          	lw	a1,0(s7)
 594:	855a                	mv	a0,s6
 596:	e91ff0ef          	jal	426 <printint>
 59a:	8bca                	mv	s7,s2
      state = 0;
 59c:	4981                	li	s3,0
 59e:	bfad                	j	518 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5a0:	06400793          	li	a5,100
 5a4:	02f68963          	beq	a3,a5,5d6 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5a8:	06c00793          	li	a5,108
 5ac:	04f68263          	beq	a3,a5,5f0 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5b0:	07500793          	li	a5,117
 5b4:	0af68063          	beq	a3,a5,654 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5b8:	07800793          	li	a5,120
 5bc:	0ef68263          	beq	a3,a5,6a0 <vprintf+0x1d2>
        putc(fd, '%');
 5c0:	02500593          	li	a1,37
 5c4:	855a                	mv	a0,s6
 5c6:	e43ff0ef          	jal	408 <putc>
        putc(fd, c0);
 5ca:	85ca                	mv	a1,s2
 5cc:	855a                	mv	a0,s6
 5ce:	e3bff0ef          	jal	408 <putc>
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	b791                	j	518 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d6:	008b8913          	addi	s2,s7,8
 5da:	4685                	li	a3,1
 5dc:	4629                	li	a2,10
 5de:	000ba583          	lw	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	e43ff0ef          	jal	426 <printint>
        i += 1;
 5e8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ea:	8bca                	mv	s7,s2
      state = 0;
 5ec:	4981                	li	s3,0
        i += 1;
 5ee:	b72d                	j	518 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5f0:	06400793          	li	a5,100
 5f4:	02f60763          	beq	a2,a5,622 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5f8:	07500793          	li	a5,117
 5fc:	06f60963          	beq	a2,a5,66e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 600:	07800793          	li	a5,120
 604:	faf61ee3          	bne	a2,a5,5c0 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 608:	008b8913          	addi	s2,s7,8
 60c:	4681                	li	a3,0
 60e:	4641                	li	a2,16
 610:	000ba583          	lw	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	e11ff0ef          	jal	426 <printint>
        i += 2;
 61a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 61c:	8bca                	mv	s7,s2
      state = 0;
 61e:	4981                	li	s3,0
        i += 2;
 620:	bde5                	j	518 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 622:	008b8913          	addi	s2,s7,8
 626:	4685                	li	a3,1
 628:	4629                	li	a2,10
 62a:	000ba583          	lw	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	df7ff0ef          	jal	426 <printint>
        i += 2;
 634:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 636:	8bca                	mv	s7,s2
      state = 0;
 638:	4981                	li	s3,0
        i += 2;
 63a:	bdf9                	j	518 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 63c:	008b8913          	addi	s2,s7,8
 640:	4681                	li	a3,0
 642:	4629                	li	a2,10
 644:	000ba583          	lw	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	dddff0ef          	jal	426 <printint>
 64e:	8bca                	mv	s7,s2
      state = 0;
 650:	4981                	li	s3,0
 652:	b5d9                	j	518 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 654:	008b8913          	addi	s2,s7,8
 658:	4681                	li	a3,0
 65a:	4629                	li	a2,10
 65c:	000ba583          	lw	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	dc5ff0ef          	jal	426 <printint>
        i += 1;
 666:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 668:	8bca                	mv	s7,s2
      state = 0;
 66a:	4981                	li	s3,0
        i += 1;
 66c:	b575                	j	518 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 66e:	008b8913          	addi	s2,s7,8
 672:	4681                	li	a3,0
 674:	4629                	li	a2,10
 676:	000ba583          	lw	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	dabff0ef          	jal	426 <printint>
        i += 2;
 680:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 682:	8bca                	mv	s7,s2
      state = 0;
 684:	4981                	li	s3,0
        i += 2;
 686:	bd49                	j	518 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 688:	008b8913          	addi	s2,s7,8
 68c:	4681                	li	a3,0
 68e:	4641                	li	a2,16
 690:	000ba583          	lw	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	d91ff0ef          	jal	426 <printint>
 69a:	8bca                	mv	s7,s2
      state = 0;
 69c:	4981                	li	s3,0
 69e:	bdad                	j	518 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a0:	008b8913          	addi	s2,s7,8
 6a4:	4681                	li	a3,0
 6a6:	4641                	li	a2,16
 6a8:	000ba583          	lw	a1,0(s7)
 6ac:	855a                	mv	a0,s6
 6ae:	d79ff0ef          	jal	426 <printint>
        i += 1;
 6b2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b4:	8bca                	mv	s7,s2
      state = 0;
 6b6:	4981                	li	s3,0
        i += 1;
 6b8:	b585                	j	518 <vprintf+0x4a>
 6ba:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6bc:	008b8d13          	addi	s10,s7,8
 6c0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6c4:	03000593          	li	a1,48
 6c8:	855a                	mv	a0,s6
 6ca:	d3fff0ef          	jal	408 <putc>
  putc(fd, 'x');
 6ce:	07800593          	li	a1,120
 6d2:	855a                	mv	a0,s6
 6d4:	d35ff0ef          	jal	408 <putc>
 6d8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6da:	00000b97          	auipc	s7,0x0
 6de:	2f6b8b93          	addi	s7,s7,758 # 9d0 <digits>
 6e2:	03c9d793          	srli	a5,s3,0x3c
 6e6:	97de                	add	a5,a5,s7
 6e8:	0007c583          	lbu	a1,0(a5)
 6ec:	855a                	mv	a0,s6
 6ee:	d1bff0ef          	jal	408 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f2:	0992                	slli	s3,s3,0x4
 6f4:	397d                	addiw	s2,s2,-1
 6f6:	fe0916e3          	bnez	s2,6e2 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6fa:	8bea                	mv	s7,s10
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	6d02                	ld	s10,0(sp)
 700:	bd21                	j	518 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 702:	008b8993          	addi	s3,s7,8
 706:	000bb903          	ld	s2,0(s7)
 70a:	00090f63          	beqz	s2,728 <vprintf+0x25a>
        for(; *s; s++)
 70e:	00094583          	lbu	a1,0(s2)
 712:	c195                	beqz	a1,736 <vprintf+0x268>
          putc(fd, *s);
 714:	855a                	mv	a0,s6
 716:	cf3ff0ef          	jal	408 <putc>
        for(; *s; s++)
 71a:	0905                	addi	s2,s2,1
 71c:	00094583          	lbu	a1,0(s2)
 720:	f9f5                	bnez	a1,714 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 722:	8bce                	mv	s7,s3
      state = 0;
 724:	4981                	li	s3,0
 726:	bbcd                	j	518 <vprintf+0x4a>
          s = "(null)";
 728:	00000917          	auipc	s2,0x0
 72c:	2a090913          	addi	s2,s2,672 # 9c8 <malloc+0x194>
        for(; *s; s++)
 730:	02800593          	li	a1,40
 734:	b7c5                	j	714 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 736:	8bce                	mv	s7,s3
      state = 0;
 738:	4981                	li	s3,0
 73a:	bbf9                	j	518 <vprintf+0x4a>
 73c:	64a6                	ld	s1,72(sp)
 73e:	79e2                	ld	s3,56(sp)
 740:	7a42                	ld	s4,48(sp)
 742:	7aa2                	ld	s5,40(sp)
 744:	7b02                	ld	s6,32(sp)
 746:	6be2                	ld	s7,24(sp)
 748:	6c42                	ld	s8,16(sp)
 74a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 74c:	60e6                	ld	ra,88(sp)
 74e:	6446                	ld	s0,80(sp)
 750:	6906                	ld	s2,64(sp)
 752:	6125                	addi	sp,sp,96
 754:	8082                	ret

0000000000000756 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 756:	715d                	addi	sp,sp,-80
 758:	ec06                	sd	ra,24(sp)
 75a:	e822                	sd	s0,16(sp)
 75c:	1000                	addi	s0,sp,32
 75e:	e010                	sd	a2,0(s0)
 760:	e414                	sd	a3,8(s0)
 762:	e818                	sd	a4,16(s0)
 764:	ec1c                	sd	a5,24(s0)
 766:	03043023          	sd	a6,32(s0)
 76a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 76e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 772:	8622                	mv	a2,s0
 774:	d5bff0ef          	jal	4ce <vprintf>
}
 778:	60e2                	ld	ra,24(sp)
 77a:	6442                	ld	s0,16(sp)
 77c:	6161                	addi	sp,sp,80
 77e:	8082                	ret

0000000000000780 <printf>:

void
printf(const char *fmt, ...)
{
 780:	711d                	addi	sp,sp,-96
 782:	ec06                	sd	ra,24(sp)
 784:	e822                	sd	s0,16(sp)
 786:	1000                	addi	s0,sp,32
 788:	e40c                	sd	a1,8(s0)
 78a:	e810                	sd	a2,16(s0)
 78c:	ec14                	sd	a3,24(s0)
 78e:	f018                	sd	a4,32(s0)
 790:	f41c                	sd	a5,40(s0)
 792:	03043823          	sd	a6,48(s0)
 796:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 79a:	00840613          	addi	a2,s0,8
 79e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a2:	85aa                	mv	a1,a0
 7a4:	4505                	li	a0,1
 7a6:	d29ff0ef          	jal	4ce <vprintf>
}
 7aa:	60e2                	ld	ra,24(sp)
 7ac:	6442                	ld	s0,16(sp)
 7ae:	6125                	addi	sp,sp,96
 7b0:	8082                	ret

00000000000007b2 <free>:
 7b2:	1141                	addi	sp,sp,-16
 7b4:	e422                	sd	s0,8(sp)
 7b6:	0800                	addi	s0,sp,16
 7b8:	ff050693          	addi	a3,a0,-16
 7bc:	00001797          	auipc	a5,0x1
 7c0:	8447b783          	ld	a5,-1980(a5) # 1000 <freep>
 7c4:	a02d                	j	7ee <free+0x3c>
 7c6:	4618                	lw	a4,8(a2)
 7c8:	9f2d                	addw	a4,a4,a1
 7ca:	fee52c23          	sw	a4,-8(a0)
 7ce:	6398                	ld	a4,0(a5)
 7d0:	6310                	ld	a2,0(a4)
 7d2:	a83d                	j	810 <free+0x5e>
 7d4:	ff852703          	lw	a4,-8(a0)
 7d8:	9f31                	addw	a4,a4,a2
 7da:	c798                	sw	a4,8(a5)
 7dc:	ff053683          	ld	a3,-16(a0)
 7e0:	a091                	j	824 <free+0x72>
 7e2:	6398                	ld	a4,0(a5)
 7e4:	00e7e463          	bltu	a5,a4,7ec <free+0x3a>
 7e8:	00e6ea63          	bltu	a3,a4,7fc <free+0x4a>
 7ec:	87ba                	mv	a5,a4
 7ee:	fed7fae3          	bgeu	a5,a3,7e2 <free+0x30>
 7f2:	6398                	ld	a4,0(a5)
 7f4:	00e6e463          	bltu	a3,a4,7fc <free+0x4a>
 7f8:	fee7eae3          	bltu	a5,a4,7ec <free+0x3a>
 7fc:	ff852583          	lw	a1,-8(a0)
 800:	6390                	ld	a2,0(a5)
 802:	02059813          	slli	a6,a1,0x20
 806:	01c85713          	srli	a4,a6,0x1c
 80a:	9736                	add	a4,a4,a3
 80c:	fae60de3          	beq	a2,a4,7c6 <free+0x14>
 810:	fec53823          	sd	a2,-16(a0)
 814:	4790                	lw	a2,8(a5)
 816:	02061593          	slli	a1,a2,0x20
 81a:	01c5d713          	srli	a4,a1,0x1c
 81e:	973e                	add	a4,a4,a5
 820:	fae68ae3          	beq	a3,a4,7d4 <free+0x22>
 824:	e394                	sd	a3,0(a5)
 826:	00000717          	auipc	a4,0x0
 82a:	7cf73d23          	sd	a5,2010(a4) # 1000 <freep>
 82e:	6422                	ld	s0,8(sp)
 830:	0141                	addi	sp,sp,16
 832:	8082                	ret

0000000000000834 <malloc>:
 834:	7139                	addi	sp,sp,-64
 836:	fc06                	sd	ra,56(sp)
 838:	f822                	sd	s0,48(sp)
 83a:	f426                	sd	s1,40(sp)
 83c:	ec4e                	sd	s3,24(sp)
 83e:	0080                	addi	s0,sp,64
 840:	02051493          	slli	s1,a0,0x20
 844:	9081                	srli	s1,s1,0x20
 846:	04bd                	addi	s1,s1,15
 848:	8091                	srli	s1,s1,0x4
 84a:	0014899b          	addiw	s3,s1,1
 84e:	0485                	addi	s1,s1,1
 850:	00000517          	auipc	a0,0x0
 854:	7b053503          	ld	a0,1968(a0) # 1000 <freep>
 858:	c915                	beqz	a0,88c <malloc+0x58>
 85a:	611c                	ld	a5,0(a0)
 85c:	4798                	lw	a4,8(a5)
 85e:	08977a63          	bgeu	a4,s1,8f2 <malloc+0xbe>
 862:	f04a                	sd	s2,32(sp)
 864:	e852                	sd	s4,16(sp)
 866:	e456                	sd	s5,8(sp)
 868:	e05a                	sd	s6,0(sp)
 86a:	8a4e                	mv	s4,s3
 86c:	0009871b          	sext.w	a4,s3
 870:	6685                	lui	a3,0x1
 872:	00d77363          	bgeu	a4,a3,878 <malloc+0x44>
 876:	6a05                	lui	s4,0x1
 878:	000a0b1b          	sext.w	s6,s4
 87c:	004a1a1b          	slliw	s4,s4,0x4
 880:	00000917          	auipc	s2,0x0
 884:	78090913          	addi	s2,s2,1920 # 1000 <freep>
 888:	5afd                	li	s5,-1
 88a:	a081                	j	8ca <malloc+0x96>
 88c:	f04a                	sd	s2,32(sp)
 88e:	e852                	sd	s4,16(sp)
 890:	e456                	sd	s5,8(sp)
 892:	e05a                	sd	s6,0(sp)
 894:	00000797          	auipc	a5,0x0
 898:	77c78793          	addi	a5,a5,1916 # 1010 <base>
 89c:	00000717          	auipc	a4,0x0
 8a0:	76f73223          	sd	a5,1892(a4) # 1000 <freep>
 8a4:	e39c                	sd	a5,0(a5)
 8a6:	0007a423          	sw	zero,8(a5)
 8aa:	b7c1                	j	86a <malloc+0x36>
 8ac:	6398                	ld	a4,0(a5)
 8ae:	e118                	sd	a4,0(a0)
 8b0:	a8a9                	j	90a <malloc+0xd6>
 8b2:	01652423          	sw	s6,8(a0)
 8b6:	0541                	addi	a0,a0,16
 8b8:	efbff0ef          	jal	7b2 <free>
 8bc:	00093503          	ld	a0,0(s2)
 8c0:	c12d                	beqz	a0,922 <malloc+0xee>
 8c2:	611c                	ld	a5,0(a0)
 8c4:	4798                	lw	a4,8(a5)
 8c6:	02977263          	bgeu	a4,s1,8ea <malloc+0xb6>
 8ca:	00093703          	ld	a4,0(s2)
 8ce:	853e                	mv	a0,a5
 8d0:	fef719e3          	bne	a4,a5,8c2 <malloc+0x8e>
 8d4:	8552                	mv	a0,s4
 8d6:	b13ff0ef          	jal	3e8 <sbrk>
 8da:	fd551ce3          	bne	a0,s5,8b2 <malloc+0x7e>
 8de:	4501                	li	a0,0
 8e0:	7902                	ld	s2,32(sp)
 8e2:	6a42                	ld	s4,16(sp)
 8e4:	6aa2                	ld	s5,8(sp)
 8e6:	6b02                	ld	s6,0(sp)
 8e8:	a03d                	j	916 <malloc+0xe2>
 8ea:	7902                	ld	s2,32(sp)
 8ec:	6a42                	ld	s4,16(sp)
 8ee:	6aa2                	ld	s5,8(sp)
 8f0:	6b02                	ld	s6,0(sp)
 8f2:	fae48de3          	beq	s1,a4,8ac <malloc+0x78>
 8f6:	4137073b          	subw	a4,a4,s3
 8fa:	c798                	sw	a4,8(a5)
 8fc:	02071693          	slli	a3,a4,0x20
 900:	01c6d713          	srli	a4,a3,0x1c
 904:	97ba                	add	a5,a5,a4
 906:	0137a423          	sw	s3,8(a5)
 90a:	00000717          	auipc	a4,0x0
 90e:	6ea73b23          	sd	a0,1782(a4) # 1000 <freep>
 912:	01078513          	addi	a0,a5,16
 916:	70e2                	ld	ra,56(sp)
 918:	7442                	ld	s0,48(sp)
 91a:	74a2                	ld	s1,40(sp)
 91c:	69e2                	ld	s3,24(sp)
 91e:	6121                	addi	sp,sp,64
 920:	8082                	ret
 922:	7902                	ld	s2,32(sp)
 924:	6a42                	ld	s4,16(sp)
 926:	6aa2                	ld	s5,8(sp)
 928:	6b02                	ld	s6,0(sp)
 92a:	b7f5                	j	916 <malloc+0xe2>
