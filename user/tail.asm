
user/_tail:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fcntl.h"

#define BUF_SIZE 512
#define MAX_FILE_SIZE 10000  // assume files < 10 KB

int main(int argc, char *argv[]) {
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	0480                	addi	s0,sp,576
    if(argc < 2 || argc > 4) {
   e:	ffe5071b          	addiw	a4,a0,-2
  12:	4789                	li	a5,2
  14:	08e7e163          	bltu	a5,a4,96 <main+0x96>
  18:	22913423          	sd	s1,552(sp)
  1c:	23213023          	sd	s2,544(sp)
  20:	21513423          	sd	s5,520(sp)
  24:	84ae                	mv	s1,a1
        printf("Usage: tail <filename> [-n number]\n");
        exit(0);
    }

    char *filename = argv[1];
  26:	0085b903          	ld	s2,8(a1)
    int n = 10;  // default number of lines

    // Only allow "tail filename" or "tail filename -n number"
    if(argc == 4) {
  2a:	4791                	li	a5,4
  2c:	08f50a63          	beq	a0,a5,c0 <main+0xc0>
            exit(0);
        }
    }

    // Reject other invalid forms
    if(argc == 3) {
  30:	478d                	li	a5,3
  32:	4aa9                	li	s5,10
  34:	0ef50363          	beq	a0,a5,11a <main+0x11a>
  38:	21413823          	sd	s4,528(sp)
        printf("Usage: tail <filename> [-n number]\n");
        exit(0);
    }

    int fd = open(filename, O_RDONLY);
  3c:	4581                	li	a1,0
  3e:	854a                	mv	a0,s2
  40:	47e000ef          	jal	4be <open>
  44:	8a2a                	mv	s4,a0
    if(fd < 0) {
  46:	0e054963          	bltz	a0,138 <main+0x138>
  4a:	21313c23          	sd	s3,536(sp)
        printf("tail: cannot open %s\n", filename);
        exit(0);
    }

    char buf[BUF_SIZE];
    char *filebuf = malloc(MAX_FILE_SIZE);
  4e:	6509                	lui	a0,0x2
  50:	71050513          	addi	a0,a0,1808 # 2710 <base+0x1700>
  54:	0ff000ef          	jal	952 <malloc>
  58:	89aa                	mv	s3,a0
        printf("tail: memory error\n");
        close(fd);
        exit(0);
    }

    int size = 0;
  5a:	4481                	li	s1,0
    if(!filebuf) {
  5c:	0e050c63          	beqz	a0,154 <main+0x154>
  60:	21613023          	sd	s6,512(sp)
    int r;
    while((r = read(fd, buf, sizeof(buf))) > 0) {
        if(size + r > MAX_FILE_SIZE) {
  64:	6b09                	lui	s6,0x2
  66:	710b0b13          	addi	s6,s6,1808 # 2710 <base+0x1700>
    while((r = read(fd, buf, sizeof(buf))) > 0) {
  6a:	20000613          	li	a2,512
  6e:	dc040593          	addi	a1,s0,-576
  72:	8552                	mv	a0,s4
  74:	422000ef          	jal	496 <read>
  78:	862a                	mv	a2,a0
  7a:	10a05a63          	blez	a0,18e <main+0x18e>
        if(size + r > MAX_FILE_SIZE) {
  7e:	00c4893b          	addw	s2,s1,a2
  82:	0f2b4763          	blt	s6,s2,170 <main+0x170>
            printf("tail: file too large\n");
            free(filebuf);
            close(fd);
            exit(0);
        }
        memmove(filebuf + size, buf, r);
  86:	dc040593          	addi	a1,s0,-576
  8a:	00998533          	add	a0,s3,s1
  8e:	342000ef          	jal	3d0 <memmove>
        size += r;
  92:	84ca                	mv	s1,s2
  94:	bfd9                	j	6a <main+0x6a>
  96:	22913423          	sd	s1,552(sp)
  9a:	23213023          	sd	s2,544(sp)
  9e:	21313c23          	sd	s3,536(sp)
  a2:	21413823          	sd	s4,528(sp)
  a6:	21513423          	sd	s5,520(sp)
  aa:	21613023          	sd	s6,512(sp)
        printf("Usage: tail <filename> [-n number]\n");
  ae:	00001517          	auipc	a0,0x1
  b2:	9a250513          	addi	a0,a0,-1630 # a50 <malloc+0xfe>
  b6:	7e8000ef          	jal	89e <printf>
        exit(0);
  ba:	4501                	li	a0,0
  bc:	3c2000ef          	jal	47e <exit>
        if(strcmp(argv[2], "-n") != 0) {
  c0:	00001597          	auipc	a1,0x1
  c4:	9b858593          	addi	a1,a1,-1608 # a78 <malloc+0x126>
  c8:	6888                	ld	a0,16(s1)
  ca:	178000ef          	jal	242 <strcmp>
  ce:	c105                	beqz	a0,ee <main+0xee>
  d0:	21313c23          	sd	s3,536(sp)
  d4:	21413823          	sd	s4,528(sp)
  d8:	21613023          	sd	s6,512(sp)
            printf("Usage: tail <filename> [-n number]\n");
  dc:	00001517          	auipc	a0,0x1
  e0:	97450513          	addi	a0,a0,-1676 # a50 <malloc+0xfe>
  e4:	7ba000ef          	jal	89e <printf>
            exit(0);
  e8:	4501                	li	a0,0
  ea:	394000ef          	jal	47e <exit>
        n = atoi(argv[3]);
  ee:	6c88                	ld	a0,24(s1)
  f0:	298000ef          	jal	388 <atoi>
  f4:	8aaa                	mv	s5,a0
        if(n <= 0) {
  f6:	f4a041e3          	bgtz	a0,38 <main+0x38>
  fa:	21313c23          	sd	s3,536(sp)
  fe:	21413823          	sd	s4,528(sp)
 102:	21613023          	sd	s6,512(sp)
            printf("tail: invalid number of lines '%s'\n", argv[3]);
 106:	6c8c                	ld	a1,24(s1)
 108:	00001517          	auipc	a0,0x1
 10c:	97850513          	addi	a0,a0,-1672 # a80 <malloc+0x12e>
 110:	78e000ef          	jal	89e <printf>
            exit(0);
 114:	4501                	li	a0,0
 116:	368000ef          	jal	47e <exit>
 11a:	21313c23          	sd	s3,536(sp)
 11e:	21413823          	sd	s4,528(sp)
 122:	21613023          	sd	s6,512(sp)
        printf("Usage: tail <filename> [-n number]\n");
 126:	00001517          	auipc	a0,0x1
 12a:	92a50513          	addi	a0,a0,-1750 # a50 <malloc+0xfe>
 12e:	770000ef          	jal	89e <printf>
        exit(0);
 132:	4501                	li	a0,0
 134:	34a000ef          	jal	47e <exit>
 138:	21313c23          	sd	s3,536(sp)
 13c:	21613023          	sd	s6,512(sp)
        printf("tail: cannot open %s\n", filename);
 140:	85ca                	mv	a1,s2
 142:	00001517          	auipc	a0,0x1
 146:	96650513          	addi	a0,a0,-1690 # aa8 <malloc+0x156>
 14a:	754000ef          	jal	89e <printf>
        exit(0);
 14e:	4501                	li	a0,0
 150:	32e000ef          	jal	47e <exit>
 154:	21613023          	sd	s6,512(sp)
        printf("tail: memory error\n");
 158:	00001517          	auipc	a0,0x1
 15c:	96850513          	addi	a0,a0,-1688 # ac0 <malloc+0x16e>
 160:	73e000ef          	jal	89e <printf>
        close(fd);
 164:	8552                	mv	a0,s4
 166:	340000ef          	jal	4a6 <close>
        exit(0);
 16a:	4501                	li	a0,0
 16c:	312000ef          	jal	47e <exit>
            printf("tail: file too large\n");
 170:	00001517          	auipc	a0,0x1
 174:	96850513          	addi	a0,a0,-1688 # ad8 <malloc+0x186>
 178:	726000ef          	jal	89e <printf>
            free(filebuf);
 17c:	854e                	mv	a0,s3
 17e:	752000ef          	jal	8d0 <free>
            close(fd);
 182:	8552                	mv	a0,s4
 184:	322000ef          	jal	4a6 <close>
            exit(0);
 188:	4501                	li	a0,0
 18a:	2f4000ef          	jal	47e <exit>
    }
    close(fd);
 18e:	8552                	mv	a0,s4
 190:	316000ef          	jal	4a6 <close>

    // Count lines from the end
    int linecount = 0;
    int start = 0;
    for(int i = size-1; i >= 0; i--) {
 194:	fff4861b          	addiw	a2,s1,-1
 198:	06064163          	bltz	a2,1fa <main+0x1fa>
    int linecount = 0;
 19c:	4701                	li	a4,0
        if(filebuf[i] == '\n') linecount++;
 19e:	46a9                	li	a3,10
 1a0:	a801                	j	1b0 <main+0x1b0>
        if(linecount == n ) {
 1a2:	01570f63          	beq	a4,s5,1c0 <main+0x1c0>
    for(int i = size-1; i >= 0; i--) {
 1a6:	167d                	addi	a2,a2,-1
 1a8:	02061793          	slli	a5,a2,0x20
 1ac:	0407ce63          	bltz	a5,208 <main+0x208>
        if(filebuf[i] == '\n') linecount++;
 1b0:	00c987b3          	add	a5,s3,a2
 1b4:	0007c783          	lbu	a5,0(a5)
 1b8:	fed795e3          	bne	a5,a3,1a2 <main+0x1a2>
 1bc:	2705                	addiw	a4,a4,1
 1be:	b7d5                	j	1a2 <main+0x1a2>
            start = i + 1;
 1c0:	2605                	addiw	a2,a2,1
 1c2:	0006059b          	sext.w	a1,a2
            break;
        }
    }

    // Write last N lines
    write(1, filebuf + start, size - start);
 1c6:	40c4863b          	subw	a2,s1,a2
 1ca:	95ce                	add	a1,a1,s3
 1cc:	4505                	li	a0,1
 1ce:	2d0000ef          	jal	49e <write>

    // Ensure newline at the end
    if(size == 0 || filebuf[size-1] != '\n')
 1d2:	94ce                	add	s1,s1,s3
 1d4:	fff4c703          	lbu	a4,-1(s1)
 1d8:	47a9                	li	a5,10
 1da:	00f70a63          	beq	a4,a5,1ee <main+0x1ee>
        write(1, "\n", 1);
 1de:	4605                	li	a2,1
 1e0:	00001597          	auipc	a1,0x1
 1e4:	91058593          	addi	a1,a1,-1776 # af0 <malloc+0x19e>
 1e8:	4505                	li	a0,1
 1ea:	2b4000ef          	jal	49e <write>

    free(filebuf);
 1ee:	854e                	mv	a0,s3
 1f0:	6e0000ef          	jal	8d0 <free>
    exit(0);
 1f4:	4501                	li	a0,0
 1f6:	288000ef          	jal	47e <exit>
    write(1, filebuf + start, size - start);
 1fa:	8626                	mv	a2,s1
 1fc:	85ce                	mv	a1,s3
 1fe:	4505                	li	a0,1
 200:	29e000ef          	jal	49e <write>
    if(size == 0 || filebuf[size-1] != '\n')
 204:	dce9                	beqz	s1,1de <main+0x1de>
 206:	b7f1                	j	1d2 <main+0x1d2>
    write(1, filebuf + start, size - start);
 208:	8626                	mv	a2,s1
 20a:	85ce                	mv	a1,s3
 20c:	4505                	li	a0,1
 20e:	290000ef          	jal	49e <write>
    if(size == 0 || filebuf[size-1] != '\n')
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
 476:	4885                	li	a7,1
 478:	00000073          	ecall
 47c:	8082                	ret

000000000000047e <exit>:
 47e:	4889                	li	a7,2
 480:	00000073          	ecall
 484:	8082                	ret

0000000000000486 <wait>:
 486:	488d                	li	a7,3
 488:	00000073          	ecall
 48c:	8082                	ret

000000000000048e <pipe>:
 48e:	4891                	li	a7,4
 490:	00000073          	ecall
 494:	8082                	ret

0000000000000496 <read>:
 496:	4895                	li	a7,5
 498:	00000073          	ecall
 49c:	8082                	ret

000000000000049e <write>:
 49e:	48c1                	li	a7,16
 4a0:	00000073          	ecall
 4a4:	8082                	ret

00000000000004a6 <close>:
 4a6:	48d5                	li	a7,21
 4a8:	00000073          	ecall
 4ac:	8082                	ret

00000000000004ae <kill>:
 4ae:	4899                	li	a7,6
 4b0:	00000073          	ecall
 4b4:	8082                	ret

00000000000004b6 <exec>:
 4b6:	489d                	li	a7,7
 4b8:	00000073          	ecall
 4bc:	8082                	ret

00000000000004be <open>:
 4be:	48bd                	li	a7,15
 4c0:	00000073          	ecall
 4c4:	8082                	ret

00000000000004c6 <mknod>:
 4c6:	48c5                	li	a7,17
 4c8:	00000073          	ecall
 4cc:	8082                	ret

00000000000004ce <unlink>:
 4ce:	48c9                	li	a7,18
 4d0:	00000073          	ecall
 4d4:	8082                	ret

00000000000004d6 <fstat>:
 4d6:	48a1                	li	a7,8
 4d8:	00000073          	ecall
 4dc:	8082                	ret

00000000000004de <link>:
 4de:	48cd                	li	a7,19
 4e0:	00000073          	ecall
 4e4:	8082                	ret

00000000000004e6 <mkdir>:
 4e6:	48d1                	li	a7,20
 4e8:	00000073          	ecall
 4ec:	8082                	ret

00000000000004ee <chdir>:
 4ee:	48a5                	li	a7,9
 4f0:	00000073          	ecall
 4f4:	8082                	ret

00000000000004f6 <dup>:
 4f6:	48a9                	li	a7,10
 4f8:	00000073          	ecall
 4fc:	8082                	ret

00000000000004fe <getpid>:
 4fe:	48ad                	li	a7,11
 500:	00000073          	ecall
 504:	8082                	ret

0000000000000506 <sbrk>:
 506:	48b1                	li	a7,12
 508:	00000073          	ecall
 50c:	8082                	ret

000000000000050e <sleep>:
 50e:	48b5                	li	a7,13
 510:	00000073          	ecall
 514:	8082                	ret

0000000000000516 <uptime>:
 516:	48b9                	li	a7,14
 518:	00000073          	ecall
 51c:	8082                	ret

000000000000051e <kbdint>:
 51e:	48d9                	li	a7,22
 520:	00000073          	ecall
 524:	8082                	ret

0000000000000526 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 526:	1101                	addi	sp,sp,-32
 528:	ec06                	sd	ra,24(sp)
 52a:	e822                	sd	s0,16(sp)
 52c:	1000                	addi	s0,sp,32
 52e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 532:	4605                	li	a2,1
 534:	fef40593          	addi	a1,s0,-17
 538:	f67ff0ef          	jal	49e <write>
}
 53c:	60e2                	ld	ra,24(sp)
 53e:	6442                	ld	s0,16(sp)
 540:	6105                	addi	sp,sp,32
 542:	8082                	ret

0000000000000544 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 544:	7139                	addi	sp,sp,-64
 546:	fc06                	sd	ra,56(sp)
 548:	f822                	sd	s0,48(sp)
 54a:	f426                	sd	s1,40(sp)
 54c:	0080                	addi	s0,sp,64
 54e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 550:	c299                	beqz	a3,556 <printint+0x12>
 552:	0805c963          	bltz	a1,5e4 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 556:	2581                	sext.w	a1,a1
  neg = 0;
 558:	4881                	li	a7,0
 55a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 55e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 560:	2601                	sext.w	a2,a2
 562:	00000517          	auipc	a0,0x0
 566:	59e50513          	addi	a0,a0,1438 # b00 <digits>
 56a:	883a                	mv	a6,a4
 56c:	2705                	addiw	a4,a4,1
 56e:	02c5f7bb          	remuw	a5,a1,a2
 572:	1782                	slli	a5,a5,0x20
 574:	9381                	srli	a5,a5,0x20
 576:	97aa                	add	a5,a5,a0
 578:	0007c783          	lbu	a5,0(a5)
 57c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 580:	0005879b          	sext.w	a5,a1
 584:	02c5d5bb          	divuw	a1,a1,a2
 588:	0685                	addi	a3,a3,1
 58a:	fec7f0e3          	bgeu	a5,a2,56a <printint+0x26>
  if(neg)
 58e:	00088c63          	beqz	a7,5a6 <printint+0x62>
    buf[i++] = '-';
 592:	fd070793          	addi	a5,a4,-48
 596:	00878733          	add	a4,a5,s0
 59a:	02d00793          	li	a5,45
 59e:	fef70823          	sb	a5,-16(a4)
 5a2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5a6:	02e05a63          	blez	a4,5da <printint+0x96>
 5aa:	f04a                	sd	s2,32(sp)
 5ac:	ec4e                	sd	s3,24(sp)
 5ae:	fc040793          	addi	a5,s0,-64
 5b2:	00e78933          	add	s2,a5,a4
 5b6:	fff78993          	addi	s3,a5,-1
 5ba:	99ba                	add	s3,s3,a4
 5bc:	377d                	addiw	a4,a4,-1
 5be:	1702                	slli	a4,a4,0x20
 5c0:	9301                	srli	a4,a4,0x20
 5c2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5c6:	fff94583          	lbu	a1,-1(s2)
 5ca:	8526                	mv	a0,s1
 5cc:	f5bff0ef          	jal	526 <putc>
  while(--i >= 0)
 5d0:	197d                	addi	s2,s2,-1
 5d2:	ff391ae3          	bne	s2,s3,5c6 <printint+0x82>
 5d6:	7902                	ld	s2,32(sp)
 5d8:	69e2                	ld	s3,24(sp)
}
 5da:	70e2                	ld	ra,56(sp)
 5dc:	7442                	ld	s0,48(sp)
 5de:	74a2                	ld	s1,40(sp)
 5e0:	6121                	addi	sp,sp,64
 5e2:	8082                	ret
    x = -xx;
 5e4:	40b005bb          	negw	a1,a1
    neg = 1;
 5e8:	4885                	li	a7,1
    x = -xx;
 5ea:	bf85                	j	55a <printint+0x16>

00000000000005ec <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ec:	711d                	addi	sp,sp,-96
 5ee:	ec86                	sd	ra,88(sp)
 5f0:	e8a2                	sd	s0,80(sp)
 5f2:	e0ca                	sd	s2,64(sp)
 5f4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5f6:	0005c903          	lbu	s2,0(a1)
 5fa:	26090863          	beqz	s2,86a <vprintf+0x27e>
 5fe:	e4a6                	sd	s1,72(sp)
 600:	fc4e                	sd	s3,56(sp)
 602:	f852                	sd	s4,48(sp)
 604:	f456                	sd	s5,40(sp)
 606:	f05a                	sd	s6,32(sp)
 608:	ec5e                	sd	s7,24(sp)
 60a:	e862                	sd	s8,16(sp)
 60c:	e466                	sd	s9,8(sp)
 60e:	8b2a                	mv	s6,a0
 610:	8a2e                	mv	s4,a1
 612:	8bb2                	mv	s7,a2
  state = 0;
 614:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 616:	4481                	li	s1,0
 618:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 61a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 61e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 622:	06c00c93          	li	s9,108
 626:	a005                	j	646 <vprintf+0x5a>
        putc(fd, c0);
 628:	85ca                	mv	a1,s2
 62a:	855a                	mv	a0,s6
 62c:	efbff0ef          	jal	526 <putc>
 630:	a019                	j	636 <vprintf+0x4a>
    } else if(state == '%'){
 632:	03598263          	beq	s3,s5,656 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 636:	2485                	addiw	s1,s1,1
 638:	8726                	mv	a4,s1
 63a:	009a07b3          	add	a5,s4,s1
 63e:	0007c903          	lbu	s2,0(a5)
 642:	20090c63          	beqz	s2,85a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 646:	0009079b          	sext.w	a5,s2
    if(state == 0){
 64a:	fe0994e3          	bnez	s3,632 <vprintf+0x46>
      if(c0 == '%'){
 64e:	fd579de3          	bne	a5,s5,628 <vprintf+0x3c>
        state = '%';
 652:	89be                	mv	s3,a5
 654:	b7cd                	j	636 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 656:	00ea06b3          	add	a3,s4,a4
 65a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 65e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 660:	c681                	beqz	a3,668 <vprintf+0x7c>
 662:	9752                	add	a4,a4,s4
 664:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 668:	03878f63          	beq	a5,s8,6a6 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 66c:	05978963          	beq	a5,s9,6be <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 670:	07500713          	li	a4,117
 674:	0ee78363          	beq	a5,a4,75a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 678:	07800713          	li	a4,120
 67c:	12e78563          	beq	a5,a4,7a6 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 680:	07000713          	li	a4,112
 684:	14e78a63          	beq	a5,a4,7d8 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 688:	07300713          	li	a4,115
 68c:	18e78a63          	beq	a5,a4,820 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 690:	02500713          	li	a4,37
 694:	04e79563          	bne	a5,a4,6de <vprintf+0xf2>
        putc(fd, '%');
 698:	02500593          	li	a1,37
 69c:	855a                	mv	a0,s6
 69e:	e89ff0ef          	jal	526 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	bf49                	j	636 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6a6:	008b8913          	addi	s2,s7,8
 6aa:	4685                	li	a3,1
 6ac:	4629                	li	a2,10
 6ae:	000ba583          	lw	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	e91ff0ef          	jal	544 <printint>
 6b8:	8bca                	mv	s7,s2
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	bfad                	j	636 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6be:	06400793          	li	a5,100
 6c2:	02f68963          	beq	a3,a5,6f4 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6c6:	06c00793          	li	a5,108
 6ca:	04f68263          	beq	a3,a5,70e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6ce:	07500793          	li	a5,117
 6d2:	0af68063          	beq	a3,a5,772 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6d6:	07800793          	li	a5,120
 6da:	0ef68263          	beq	a3,a5,7be <vprintf+0x1d2>
        putc(fd, '%');
 6de:	02500593          	li	a1,37
 6e2:	855a                	mv	a0,s6
 6e4:	e43ff0ef          	jal	526 <putc>
        putc(fd, c0);
 6e8:	85ca                	mv	a1,s2
 6ea:	855a                	mv	a0,s6
 6ec:	e3bff0ef          	jal	526 <putc>
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	b791                	j	636 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f4:	008b8913          	addi	s2,s7,8
 6f8:	4685                	li	a3,1
 6fa:	4629                	li	a2,10
 6fc:	000ba583          	lw	a1,0(s7)
 700:	855a                	mv	a0,s6
 702:	e43ff0ef          	jal	544 <printint>
        i += 1;
 706:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 708:	8bca                	mv	s7,s2
      state = 0;
 70a:	4981                	li	s3,0
        i += 1;
 70c:	b72d                	j	636 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 70e:	06400793          	li	a5,100
 712:	02f60763          	beq	a2,a5,740 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 716:	07500793          	li	a5,117
 71a:	06f60963          	beq	a2,a5,78c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 71e:	07800793          	li	a5,120
 722:	faf61ee3          	bne	a2,a5,6de <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 726:	008b8913          	addi	s2,s7,8
 72a:	4681                	li	a3,0
 72c:	4641                	li	a2,16
 72e:	000ba583          	lw	a1,0(s7)
 732:	855a                	mv	a0,s6
 734:	e11ff0ef          	jal	544 <printint>
        i += 2;
 738:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 73a:	8bca                	mv	s7,s2
      state = 0;
 73c:	4981                	li	s3,0
        i += 2;
 73e:	bde5                	j	636 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 740:	008b8913          	addi	s2,s7,8
 744:	4685                	li	a3,1
 746:	4629                	li	a2,10
 748:	000ba583          	lw	a1,0(s7)
 74c:	855a                	mv	a0,s6
 74e:	df7ff0ef          	jal	544 <printint>
        i += 2;
 752:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 754:	8bca                	mv	s7,s2
      state = 0;
 756:	4981                	li	s3,0
        i += 2;
 758:	bdf9                	j	636 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 75a:	008b8913          	addi	s2,s7,8
 75e:	4681                	li	a3,0
 760:	4629                	li	a2,10
 762:	000ba583          	lw	a1,0(s7)
 766:	855a                	mv	a0,s6
 768:	dddff0ef          	jal	544 <printint>
 76c:	8bca                	mv	s7,s2
      state = 0;
 76e:	4981                	li	s3,0
 770:	b5d9                	j	636 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 772:	008b8913          	addi	s2,s7,8
 776:	4681                	li	a3,0
 778:	4629                	li	a2,10
 77a:	000ba583          	lw	a1,0(s7)
 77e:	855a                	mv	a0,s6
 780:	dc5ff0ef          	jal	544 <printint>
        i += 1;
 784:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 786:	8bca                	mv	s7,s2
      state = 0;
 788:	4981                	li	s3,0
        i += 1;
 78a:	b575                	j	636 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 78c:	008b8913          	addi	s2,s7,8
 790:	4681                	li	a3,0
 792:	4629                	li	a2,10
 794:	000ba583          	lw	a1,0(s7)
 798:	855a                	mv	a0,s6
 79a:	dabff0ef          	jal	544 <printint>
        i += 2;
 79e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a0:	8bca                	mv	s7,s2
      state = 0;
 7a2:	4981                	li	s3,0
        i += 2;
 7a4:	bd49                	j	636 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7a6:	008b8913          	addi	s2,s7,8
 7aa:	4681                	li	a3,0
 7ac:	4641                	li	a2,16
 7ae:	000ba583          	lw	a1,0(s7)
 7b2:	855a                	mv	a0,s6
 7b4:	d91ff0ef          	jal	544 <printint>
 7b8:	8bca                	mv	s7,s2
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	bdad                	j	636 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7be:	008b8913          	addi	s2,s7,8
 7c2:	4681                	li	a3,0
 7c4:	4641                	li	a2,16
 7c6:	000ba583          	lw	a1,0(s7)
 7ca:	855a                	mv	a0,s6
 7cc:	d79ff0ef          	jal	544 <printint>
        i += 1;
 7d0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d2:	8bca                	mv	s7,s2
      state = 0;
 7d4:	4981                	li	s3,0
        i += 1;
 7d6:	b585                	j	636 <vprintf+0x4a>
 7d8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7da:	008b8d13          	addi	s10,s7,8
 7de:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7e2:	03000593          	li	a1,48
 7e6:	855a                	mv	a0,s6
 7e8:	d3fff0ef          	jal	526 <putc>
  putc(fd, 'x');
 7ec:	07800593          	li	a1,120
 7f0:	855a                	mv	a0,s6
 7f2:	d35ff0ef          	jal	526 <putc>
 7f6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7f8:	00000b97          	auipc	s7,0x0
 7fc:	308b8b93          	addi	s7,s7,776 # b00 <digits>
 800:	03c9d793          	srli	a5,s3,0x3c
 804:	97de                	add	a5,a5,s7
 806:	0007c583          	lbu	a1,0(a5)
 80a:	855a                	mv	a0,s6
 80c:	d1bff0ef          	jal	526 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 810:	0992                	slli	s3,s3,0x4
 812:	397d                	addiw	s2,s2,-1
 814:	fe0916e3          	bnez	s2,800 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 818:	8bea                	mv	s7,s10
      state = 0;
 81a:	4981                	li	s3,0
 81c:	6d02                	ld	s10,0(sp)
 81e:	bd21                	j	636 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 820:	008b8993          	addi	s3,s7,8
 824:	000bb903          	ld	s2,0(s7)
 828:	00090f63          	beqz	s2,846 <vprintf+0x25a>
        for(; *s; s++)
 82c:	00094583          	lbu	a1,0(s2)
 830:	c195                	beqz	a1,854 <vprintf+0x268>
          putc(fd, *s);
 832:	855a                	mv	a0,s6
 834:	cf3ff0ef          	jal	526 <putc>
        for(; *s; s++)
 838:	0905                	addi	s2,s2,1
 83a:	00094583          	lbu	a1,0(s2)
 83e:	f9f5                	bnez	a1,832 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 840:	8bce                	mv	s7,s3
      state = 0;
 842:	4981                	li	s3,0
 844:	bbcd                	j	636 <vprintf+0x4a>
          s = "(null)";
 846:	00000917          	auipc	s2,0x0
 84a:	2b290913          	addi	s2,s2,690 # af8 <malloc+0x1a6>
        for(; *s; s++)
 84e:	02800593          	li	a1,40
 852:	b7c5                	j	832 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 854:	8bce                	mv	s7,s3
      state = 0;
 856:	4981                	li	s3,0
 858:	bbf9                	j	636 <vprintf+0x4a>
 85a:	64a6                	ld	s1,72(sp)
 85c:	79e2                	ld	s3,56(sp)
 85e:	7a42                	ld	s4,48(sp)
 860:	7aa2                	ld	s5,40(sp)
 862:	7b02                	ld	s6,32(sp)
 864:	6be2                	ld	s7,24(sp)
 866:	6c42                	ld	s8,16(sp)
 868:	6ca2                	ld	s9,8(sp)
    }
  }
}
 86a:	60e6                	ld	ra,88(sp)
 86c:	6446                	ld	s0,80(sp)
 86e:	6906                	ld	s2,64(sp)
 870:	6125                	addi	sp,sp,96
 872:	8082                	ret

0000000000000874 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 874:	715d                	addi	sp,sp,-80
 876:	ec06                	sd	ra,24(sp)
 878:	e822                	sd	s0,16(sp)
 87a:	1000                	addi	s0,sp,32
 87c:	e010                	sd	a2,0(s0)
 87e:	e414                	sd	a3,8(s0)
 880:	e818                	sd	a4,16(s0)
 882:	ec1c                	sd	a5,24(s0)
 884:	03043023          	sd	a6,32(s0)
 888:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 88c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 890:	8622                	mv	a2,s0
 892:	d5bff0ef          	jal	5ec <vprintf>
}
 896:	60e2                	ld	ra,24(sp)
 898:	6442                	ld	s0,16(sp)
 89a:	6161                	addi	sp,sp,80
 89c:	8082                	ret

000000000000089e <printf>:

void
printf(const char *fmt, ...)
{
 89e:	711d                	addi	sp,sp,-96
 8a0:	ec06                	sd	ra,24(sp)
 8a2:	e822                	sd	s0,16(sp)
 8a4:	1000                	addi	s0,sp,32
 8a6:	e40c                	sd	a1,8(s0)
 8a8:	e810                	sd	a2,16(s0)
 8aa:	ec14                	sd	a3,24(s0)
 8ac:	f018                	sd	a4,32(s0)
 8ae:	f41c                	sd	a5,40(s0)
 8b0:	03043823          	sd	a6,48(s0)
 8b4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8b8:	00840613          	addi	a2,s0,8
 8bc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8c0:	85aa                	mv	a1,a0
 8c2:	4505                	li	a0,1
 8c4:	d29ff0ef          	jal	5ec <vprintf>
}
 8c8:	60e2                	ld	ra,24(sp)
 8ca:	6442                	ld	s0,16(sp)
 8cc:	6125                	addi	sp,sp,96
 8ce:	8082                	ret

00000000000008d0 <free>:
 8d0:	1141                	addi	sp,sp,-16
 8d2:	e422                	sd	s0,8(sp)
 8d4:	0800                	addi	s0,sp,16
 8d6:	ff050693          	addi	a3,a0,-16
 8da:	00000797          	auipc	a5,0x0
 8de:	7267b783          	ld	a5,1830(a5) # 1000 <freep>
 8e2:	a02d                	j	90c <free+0x3c>
 8e4:	4618                	lw	a4,8(a2)
 8e6:	9f2d                	addw	a4,a4,a1
 8e8:	fee52c23          	sw	a4,-8(a0)
 8ec:	6398                	ld	a4,0(a5)
 8ee:	6310                	ld	a2,0(a4)
 8f0:	a83d                	j	92e <free+0x5e>
 8f2:	ff852703          	lw	a4,-8(a0)
 8f6:	9f31                	addw	a4,a4,a2
 8f8:	c798                	sw	a4,8(a5)
 8fa:	ff053683          	ld	a3,-16(a0)
 8fe:	a091                	j	942 <free+0x72>
 900:	6398                	ld	a4,0(a5)
 902:	00e7e463          	bltu	a5,a4,90a <free+0x3a>
 906:	00e6ea63          	bltu	a3,a4,91a <free+0x4a>
 90a:	87ba                	mv	a5,a4
 90c:	fed7fae3          	bgeu	a5,a3,900 <free+0x30>
 910:	6398                	ld	a4,0(a5)
 912:	00e6e463          	bltu	a3,a4,91a <free+0x4a>
 916:	fee7eae3          	bltu	a5,a4,90a <free+0x3a>
 91a:	ff852583          	lw	a1,-8(a0)
 91e:	6390                	ld	a2,0(a5)
 920:	02059813          	slli	a6,a1,0x20
 924:	01c85713          	srli	a4,a6,0x1c
 928:	9736                	add	a4,a4,a3
 92a:	fae60de3          	beq	a2,a4,8e4 <free+0x14>
 92e:	fec53823          	sd	a2,-16(a0)
 932:	4790                	lw	a2,8(a5)
 934:	02061593          	slli	a1,a2,0x20
 938:	01c5d713          	srli	a4,a1,0x1c
 93c:	973e                	add	a4,a4,a5
 93e:	fae68ae3          	beq	a3,a4,8f2 <free+0x22>
 942:	e394                	sd	a3,0(a5)
 944:	00000717          	auipc	a4,0x0
 948:	6af73e23          	sd	a5,1724(a4) # 1000 <freep>
 94c:	6422                	ld	s0,8(sp)
 94e:	0141                	addi	sp,sp,16
 950:	8082                	ret

0000000000000952 <malloc>:
 952:	7139                	addi	sp,sp,-64
 954:	fc06                	sd	ra,56(sp)
 956:	f822                	sd	s0,48(sp)
 958:	f426                	sd	s1,40(sp)
 95a:	ec4e                	sd	s3,24(sp)
 95c:	0080                	addi	s0,sp,64
 95e:	02051493          	slli	s1,a0,0x20
 962:	9081                	srli	s1,s1,0x20
 964:	04bd                	addi	s1,s1,15
 966:	8091                	srli	s1,s1,0x4
 968:	0014899b          	addiw	s3,s1,1
 96c:	0485                	addi	s1,s1,1
 96e:	00000517          	auipc	a0,0x0
 972:	69253503          	ld	a0,1682(a0) # 1000 <freep>
 976:	c915                	beqz	a0,9aa <malloc+0x58>
 978:	611c                	ld	a5,0(a0)
 97a:	4798                	lw	a4,8(a5)
 97c:	08977a63          	bgeu	a4,s1,a10 <malloc+0xbe>
 980:	f04a                	sd	s2,32(sp)
 982:	e852                	sd	s4,16(sp)
 984:	e456                	sd	s5,8(sp)
 986:	e05a                	sd	s6,0(sp)
 988:	8a4e                	mv	s4,s3
 98a:	0009871b          	sext.w	a4,s3
 98e:	6685                	lui	a3,0x1
 990:	00d77363          	bgeu	a4,a3,996 <malloc+0x44>
 994:	6a05                	lui	s4,0x1
 996:	000a0b1b          	sext.w	s6,s4
 99a:	004a1a1b          	slliw	s4,s4,0x4
 99e:	00000917          	auipc	s2,0x0
 9a2:	66290913          	addi	s2,s2,1634 # 1000 <freep>
 9a6:	5afd                	li	s5,-1
 9a8:	a081                	j	9e8 <malloc+0x96>
 9aa:	f04a                	sd	s2,32(sp)
 9ac:	e852                	sd	s4,16(sp)
 9ae:	e456                	sd	s5,8(sp)
 9b0:	e05a                	sd	s6,0(sp)
 9b2:	00000797          	auipc	a5,0x0
 9b6:	65e78793          	addi	a5,a5,1630 # 1010 <base>
 9ba:	00000717          	auipc	a4,0x0
 9be:	64f73323          	sd	a5,1606(a4) # 1000 <freep>
 9c2:	e39c                	sd	a5,0(a5)
 9c4:	0007a423          	sw	zero,8(a5)
 9c8:	b7c1                	j	988 <malloc+0x36>
 9ca:	6398                	ld	a4,0(a5)
 9cc:	e118                	sd	a4,0(a0)
 9ce:	a8a9                	j	a28 <malloc+0xd6>
 9d0:	01652423          	sw	s6,8(a0)
 9d4:	0541                	addi	a0,a0,16
 9d6:	efbff0ef          	jal	8d0 <free>
 9da:	00093503          	ld	a0,0(s2)
 9de:	c12d                	beqz	a0,a40 <malloc+0xee>
 9e0:	611c                	ld	a5,0(a0)
 9e2:	4798                	lw	a4,8(a5)
 9e4:	02977263          	bgeu	a4,s1,a08 <malloc+0xb6>
 9e8:	00093703          	ld	a4,0(s2)
 9ec:	853e                	mv	a0,a5
 9ee:	fef719e3          	bne	a4,a5,9e0 <malloc+0x8e>
 9f2:	8552                	mv	a0,s4
 9f4:	b13ff0ef          	jal	506 <sbrk>
 9f8:	fd551ce3          	bne	a0,s5,9d0 <malloc+0x7e>
 9fc:	4501                	li	a0,0
 9fe:	7902                	ld	s2,32(sp)
 a00:	6a42                	ld	s4,16(sp)
 a02:	6aa2                	ld	s5,8(sp)
 a04:	6b02                	ld	s6,0(sp)
 a06:	a03d                	j	a34 <malloc+0xe2>
 a08:	7902                	ld	s2,32(sp)
 a0a:	6a42                	ld	s4,16(sp)
 a0c:	6aa2                	ld	s5,8(sp)
 a0e:	6b02                	ld	s6,0(sp)
 a10:	fae48de3          	beq	s1,a4,9ca <malloc+0x78>
 a14:	4137073b          	subw	a4,a4,s3
 a18:	c798                	sw	a4,8(a5)
 a1a:	02071693          	slli	a3,a4,0x20
 a1e:	01c6d713          	srli	a4,a3,0x1c
 a22:	97ba                	add	a5,a5,a4
 a24:	0137a423          	sw	s3,8(a5)
 a28:	00000717          	auipc	a4,0x0
 a2c:	5ca73c23          	sd	a0,1496(a4) # 1000 <freep>
 a30:	01078513          	addi	a0,a5,16
 a34:	70e2                	ld	ra,56(sp)
 a36:	7442                	ld	s0,48(sp)
 a38:	74a2                	ld	s1,40(sp)
 a3a:	69e2                	ld	s3,24(sp)
 a3c:	6121                	addi	sp,sp,64
 a3e:	8082                	ret
 a40:	7902                	ld	s2,32(sp)
 a42:	6a42                	ld	s4,16(sp)
 a44:	6aa2                	ld	s5,8(sp)
 a46:	6b02                	ld	s6,0(sp)
 a48:	b7f5                	j	a34 <malloc+0xe2>
