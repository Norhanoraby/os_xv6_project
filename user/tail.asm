
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
  54:	13f000ef          	jal	992 <malloc>
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
  b2:	9e250513          	addi	a0,a0,-1566 # a90 <malloc+0xfe>
  b6:	029000ef          	jal	8de <printf>
        exit(0);
  ba:	4501                	li	a0,0
  bc:	3c2000ef          	jal	47e <exit>
        if(strcmp(argv[2], "-n") != 0) {
  c0:	00001597          	auipc	a1,0x1
  c4:	9f858593          	addi	a1,a1,-1544 # ab8 <malloc+0x126>
  c8:	6888                	ld	a0,16(s1)
  ca:	178000ef          	jal	242 <strcmp>
  ce:	c105                	beqz	a0,ee <main+0xee>
  d0:	21313c23          	sd	s3,536(sp)
  d4:	21413823          	sd	s4,528(sp)
  d8:	21613023          	sd	s6,512(sp)
            printf("Usage: tail <filename> [-n number]\n");
  dc:	00001517          	auipc	a0,0x1
  e0:	9b450513          	addi	a0,a0,-1612 # a90 <malloc+0xfe>
  e4:	7fa000ef          	jal	8de <printf>
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
 10c:	9b850513          	addi	a0,a0,-1608 # ac0 <malloc+0x12e>
 110:	7ce000ef          	jal	8de <printf>
            exit(0);
 114:	4501                	li	a0,0
 116:	368000ef          	jal	47e <exit>
 11a:	21313c23          	sd	s3,536(sp)
 11e:	21413823          	sd	s4,528(sp)
 122:	21613023          	sd	s6,512(sp)
        printf("Usage: tail <filename> [-n number]\n");
 126:	00001517          	auipc	a0,0x1
 12a:	96a50513          	addi	a0,a0,-1686 # a90 <malloc+0xfe>
 12e:	7b0000ef          	jal	8de <printf>
        exit(0);
 132:	4501                	li	a0,0
 134:	34a000ef          	jal	47e <exit>
 138:	21313c23          	sd	s3,536(sp)
 13c:	21613023          	sd	s6,512(sp)
        printf("tail: cannot open %s\n", filename);
 140:	85ca                	mv	a1,s2
 142:	00001517          	auipc	a0,0x1
 146:	9a650513          	addi	a0,a0,-1626 # ae8 <malloc+0x156>
 14a:	794000ef          	jal	8de <printf>
        exit(0);
 14e:	4501                	li	a0,0
 150:	32e000ef          	jal	47e <exit>
 154:	21613023          	sd	s6,512(sp)
        printf("tail: memory error\n");
 158:	00001517          	auipc	a0,0x1
 15c:	9a850513          	addi	a0,a0,-1624 # b00 <malloc+0x16e>
 160:	77e000ef          	jal	8de <printf>
        close(fd);
 164:	8552                	mv	a0,s4
 166:	340000ef          	jal	4a6 <close>
        exit(0);
 16a:	4501                	li	a0,0
 16c:	312000ef          	jal	47e <exit>
            printf("tail: file too large\n");
 170:	00001517          	auipc	a0,0x1
 174:	9a850513          	addi	a0,a0,-1624 # b18 <malloc+0x186>
 178:	766000ef          	jal	8de <printf>
            free(filebuf);
 17c:	854e                	mv	a0,s3
 17e:	792000ef          	jal	910 <free>
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
        if(linecount == n) {
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
 1e4:	95058593          	addi	a1,a1,-1712 # b30 <malloc+0x19e>
 1e8:	4505                	li	a0,1
 1ea:	2b4000ef          	jal	49e <write>

    free(filebuf);
 1ee:	854e                	mv	a0,s3
 1f0:	720000ef          	jal	910 <free>
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
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 214:	1141                	addi	sp,sp,-16
 216:	e406                	sd	ra,8(sp)
 218:	e022                	sd	s0,0(sp)
 21a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 21c:	de5ff0ef          	jal	0 <main>
  exit(0);
 220:	4501                	li	a0,0
 222:	25c000ef          	jal	47e <exit>

0000000000000226 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 226:	1141                	addi	sp,sp,-16
 228:	e422                	sd	s0,8(sp)
 22a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 22c:	87aa                	mv	a5,a0
 22e:	0585                	addi	a1,a1,1
 230:	0785                	addi	a5,a5,1
 232:	fff5c703          	lbu	a4,-1(a1)
 236:	fee78fa3          	sb	a4,-1(a5)
 23a:	fb75                	bnez	a4,22e <strcpy+0x8>
    ;
  return os;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret

0000000000000242 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 248:	00054783          	lbu	a5,0(a0)
 24c:	cb91                	beqz	a5,260 <strcmp+0x1e>
 24e:	0005c703          	lbu	a4,0(a1)
 252:	00f71763          	bne	a4,a5,260 <strcmp+0x1e>
    p++, q++;
 256:	0505                	addi	a0,a0,1
 258:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 25a:	00054783          	lbu	a5,0(a0)
 25e:	fbe5                	bnez	a5,24e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 260:	0005c503          	lbu	a0,0(a1)
}
 264:	40a7853b          	subw	a0,a5,a0
 268:	6422                	ld	s0,8(sp)
 26a:	0141                	addi	sp,sp,16
 26c:	8082                	ret

000000000000026e <strlen>:

uint
strlen(const char *s)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
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
    ;
  return n;
}
 28e:	6422                	ld	s0,8(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
  for(n = 0; s[n]; n++)
 294:	4501                	li	a0,0
 296:	bfe5                	j	28e <strlen+0x20>

0000000000000298 <memset>:

void*
memset(void *dst, int c, uint n)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 29e:	ca19                	beqz	a2,2b4 <memset+0x1c>
 2a0:	87aa                	mv	a5,a0
 2a2:	1602                	slli	a2,a2,0x20
 2a4:	9201                	srli	a2,a2,0x20
 2a6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2aa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2ae:	0785                	addi	a5,a5,1
 2b0:	fee79de3          	bne	a5,a4,2aa <memset+0x12>
  }
  return dst;
}
 2b4:	6422                	ld	s0,8(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <strchr>:

char*
strchr(const char *s, char c)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	cb99                	beqz	a5,2da <strchr+0x20>
    if(*s == c)
 2c6:	00f58763          	beq	a1,a5,2d4 <strchr+0x1a>
  for(; *s; s++)
 2ca:	0505                	addi	a0,a0,1
 2cc:	00054783          	lbu	a5,0(a0)
 2d0:	fbfd                	bnez	a5,2c6 <strchr+0xc>
      return (char*)s;
  return 0;
 2d2:	4501                	li	a0,0
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  return 0;
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <strchr+0x1a>

00000000000002de <gets>:

char*
gets(char *buf, int max)
{
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
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f8:	892a                	mv	s2,a0
 2fa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2fc:	4aa9                	li	s5,10
 2fe:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 300:	89a6                	mv	s3,s1
 302:	2485                	addiw	s1,s1,1
 304:	0344d663          	bge	s1,s4,330 <gets+0x52>
    cc = read(0, &c, 1);
 308:	4605                	li	a2,1
 30a:	faf40593          	addi	a1,s0,-81
 30e:	4501                	li	a0,0
 310:	186000ef          	jal	496 <read>
    if(cc < 1)
 314:	00a05e63          	blez	a0,330 <gets+0x52>
    buf[i++] = c;
 318:	faf44783          	lbu	a5,-81(s0)
 31c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 320:	01578763          	beq	a5,s5,32e <gets+0x50>
 324:	0905                	addi	s2,s2,1
 326:	fd679de3          	bne	a5,s6,300 <gets+0x22>
    buf[i++] = c;
 32a:	89a6                	mv	s3,s1
 32c:	a011                	j	330 <gets+0x52>
 32e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 330:	99de                	add	s3,s3,s7
 332:	00098023          	sb	zero,0(s3)
  return buf;
}
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

int
stat(const char *n, struct stat *st)
{
 34e:	1101                	addi	sp,sp,-32
 350:	ec06                	sd	ra,24(sp)
 352:	e822                	sd	s0,16(sp)
 354:	e04a                	sd	s2,0(sp)
 356:	1000                	addi	s0,sp,32
 358:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 35a:	4581                	li	a1,0
 35c:	162000ef          	jal	4be <open>
  if(fd < 0)
 360:	02054263          	bltz	a0,384 <stat+0x36>
 364:	e426                	sd	s1,8(sp)
 366:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 368:	85ca                	mv	a1,s2
 36a:	16c000ef          	jal	4d6 <fstat>
 36e:	892a                	mv	s2,a0
  close(fd);
 370:	8526                	mv	a0,s1
 372:	134000ef          	jal	4a6 <close>
  return r;
 376:	64a2                	ld	s1,8(sp)
}
 378:	854a                	mv	a0,s2
 37a:	60e2                	ld	ra,24(sp)
 37c:	6442                	ld	s0,16(sp)
 37e:	6902                	ld	s2,0(sp)
 380:	6105                	addi	sp,sp,32
 382:	8082                	ret
    return -1;
 384:	597d                	li	s2,-1
 386:	bfcd                	j	378 <stat+0x2a>

0000000000000388 <atoi>:

int
atoi(const char *s)
{
 388:	1141                	addi	sp,sp,-16
 38a:	e422                	sd	s0,8(sp)
 38c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 38e:	00054683          	lbu	a3,0(a0)
 392:	fd06879b          	addiw	a5,a3,-48
 396:	0ff7f793          	zext.b	a5,a5
 39a:	4625                	li	a2,9
 39c:	02f66863          	bltu	a2,a5,3cc <atoi+0x44>
 3a0:	872a                	mv	a4,a0
  n = 0;
 3a2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3a4:	0705                	addi	a4,a4,1
 3a6:	0025179b          	slliw	a5,a0,0x2
 3aa:	9fa9                	addw	a5,a5,a0
 3ac:	0017979b          	slliw	a5,a5,0x1
 3b0:	9fb5                	addw	a5,a5,a3
 3b2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3b6:	00074683          	lbu	a3,0(a4)
 3ba:	fd06879b          	addiw	a5,a3,-48
 3be:	0ff7f793          	zext.b	a5,a5
 3c2:	fef671e3          	bgeu	a2,a5,3a4 <atoi+0x1c>
  return n;
}
 3c6:	6422                	ld	s0,8(sp)
 3c8:	0141                	addi	sp,sp,16
 3ca:	8082                	ret
  n = 0;
 3cc:	4501                	li	a0,0
 3ce:	bfe5                	j	3c6 <atoi+0x3e>

00000000000003d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d0:	1141                	addi	sp,sp,-16
 3d2:	e422                	sd	s0,8(sp)
 3d4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3d6:	02b57463          	bgeu	a0,a1,3fe <memmove+0x2e>
    while(n-- > 0)
 3da:	00c05f63          	blez	a2,3f8 <memmove+0x28>
 3de:	1602                	slli	a2,a2,0x20
 3e0:	9201                	srli	a2,a2,0x20
 3e2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3e6:	872a                	mv	a4,a0
      *dst++ = *src++;
 3e8:	0585                	addi	a1,a1,1
 3ea:	0705                	addi	a4,a4,1
 3ec:	fff5c683          	lbu	a3,-1(a1)
 3f0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3f4:	fef71ae3          	bne	a4,a5,3e8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3f8:	6422                	ld	s0,8(sp)
 3fa:	0141                	addi	sp,sp,16
 3fc:	8082                	ret
    dst += n;
 3fe:	00c50733          	add	a4,a0,a2
    src += n;
 402:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 404:	fec05ae3          	blez	a2,3f8 <memmove+0x28>
 408:	fff6079b          	addiw	a5,a2,-1
 40c:	1782                	slli	a5,a5,0x20
 40e:	9381                	srli	a5,a5,0x20
 410:	fff7c793          	not	a5,a5
 414:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 416:	15fd                	addi	a1,a1,-1
 418:	177d                	addi	a4,a4,-1
 41a:	0005c683          	lbu	a3,0(a1)
 41e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 422:	fee79ae3          	bne	a5,a4,416 <memmove+0x46>
 426:	bfc9                	j	3f8 <memmove+0x28>

0000000000000428 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 428:	1141                	addi	sp,sp,-16
 42a:	e422                	sd	s0,8(sp)
 42c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 42e:	ca05                	beqz	a2,45e <memcmp+0x36>
 430:	fff6069b          	addiw	a3,a2,-1
 434:	1682                	slli	a3,a3,0x20
 436:	9281                	srli	a3,a3,0x20
 438:	0685                	addi	a3,a3,1
 43a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 43c:	00054783          	lbu	a5,0(a0)
 440:	0005c703          	lbu	a4,0(a1)
 444:	00e79863          	bne	a5,a4,454 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 448:	0505                	addi	a0,a0,1
    p2++;
 44a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 44c:	fed518e3          	bne	a0,a3,43c <memcmp+0x14>
  }
  return 0;
 450:	4501                	li	a0,0
 452:	a019                	j	458 <memcmp+0x30>
      return *p1 - *p2;
 454:	40e7853b          	subw	a0,a5,a4
}
 458:	6422                	ld	s0,8(sp)
 45a:	0141                	addi	sp,sp,16
 45c:	8082                	ret
  return 0;
 45e:	4501                	li	a0,0
 460:	bfe5                	j	458 <memcmp+0x30>

0000000000000462 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 462:	1141                	addi	sp,sp,-16
 464:	e406                	sd	ra,8(sp)
 466:	e022                	sd	s0,0(sp)
 468:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 46a:	f67ff0ef          	jal	3d0 <memmove>
}
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

000000000000053e <random>:
.global random
random:
 li a7, SYS_random
 53e:	48e9                	li	a7,26
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 546:	48ed                	li	a7,27
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 54e:	48f1                	li	a7,28
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <set_sched>:
.global set_sched
set_sched:
 li a7, SYS_set_sched
 556:	48f5                	li	a7,29
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <wait_sched>:
.global wait_sched
wait_sched:
 li a7, SYS_wait_sched
 55e:	48f9                	li	a7,30
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 566:	1101                	addi	sp,sp,-32
 568:	ec06                	sd	ra,24(sp)
 56a:	e822                	sd	s0,16(sp)
 56c:	1000                	addi	s0,sp,32
 56e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 572:	4605                	li	a2,1
 574:	fef40593          	addi	a1,s0,-17
 578:	f27ff0ef          	jal	49e <write>
}
 57c:	60e2                	ld	ra,24(sp)
 57e:	6442                	ld	s0,16(sp)
 580:	6105                	addi	sp,sp,32
 582:	8082                	ret

0000000000000584 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 584:	7139                	addi	sp,sp,-64
 586:	fc06                	sd	ra,56(sp)
 588:	f822                	sd	s0,48(sp)
 58a:	f426                	sd	s1,40(sp)
 58c:	0080                	addi	s0,sp,64
 58e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 590:	c299                	beqz	a3,596 <printint+0x12>
 592:	0805c963          	bltz	a1,624 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 596:	2581                	sext.w	a1,a1
  neg = 0;
 598:	4881                	li	a7,0
 59a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 59e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5a0:	2601                	sext.w	a2,a2
 5a2:	00000517          	auipc	a0,0x0
 5a6:	59e50513          	addi	a0,a0,1438 # b40 <digits>
 5aa:	883a                	mv	a6,a4
 5ac:	2705                	addiw	a4,a4,1
 5ae:	02c5f7bb          	remuw	a5,a1,a2
 5b2:	1782                	slli	a5,a5,0x20
 5b4:	9381                	srli	a5,a5,0x20
 5b6:	97aa                	add	a5,a5,a0
 5b8:	0007c783          	lbu	a5,0(a5)
 5bc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5c0:	0005879b          	sext.w	a5,a1
 5c4:	02c5d5bb          	divuw	a1,a1,a2
 5c8:	0685                	addi	a3,a3,1
 5ca:	fec7f0e3          	bgeu	a5,a2,5aa <printint+0x26>
  if(neg)
 5ce:	00088c63          	beqz	a7,5e6 <printint+0x62>
    buf[i++] = '-';
 5d2:	fd070793          	addi	a5,a4,-48
 5d6:	00878733          	add	a4,a5,s0
 5da:	02d00793          	li	a5,45
 5de:	fef70823          	sb	a5,-16(a4)
 5e2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5e6:	02e05a63          	blez	a4,61a <printint+0x96>
 5ea:	f04a                	sd	s2,32(sp)
 5ec:	ec4e                	sd	s3,24(sp)
 5ee:	fc040793          	addi	a5,s0,-64
 5f2:	00e78933          	add	s2,a5,a4
 5f6:	fff78993          	addi	s3,a5,-1
 5fa:	99ba                	add	s3,s3,a4
 5fc:	377d                	addiw	a4,a4,-1
 5fe:	1702                	slli	a4,a4,0x20
 600:	9301                	srli	a4,a4,0x20
 602:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 606:	fff94583          	lbu	a1,-1(s2)
 60a:	8526                	mv	a0,s1
 60c:	f5bff0ef          	jal	566 <putc>
  while(--i >= 0)
 610:	197d                	addi	s2,s2,-1
 612:	ff391ae3          	bne	s2,s3,606 <printint+0x82>
 616:	7902                	ld	s2,32(sp)
 618:	69e2                	ld	s3,24(sp)
}
 61a:	70e2                	ld	ra,56(sp)
 61c:	7442                	ld	s0,48(sp)
 61e:	74a2                	ld	s1,40(sp)
 620:	6121                	addi	sp,sp,64
 622:	8082                	ret
    x = -xx;
 624:	40b005bb          	negw	a1,a1
    neg = 1;
 628:	4885                	li	a7,1
    x = -xx;
 62a:	bf85                	j	59a <printint+0x16>

000000000000062c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 62c:	711d                	addi	sp,sp,-96
 62e:	ec86                	sd	ra,88(sp)
 630:	e8a2                	sd	s0,80(sp)
 632:	e0ca                	sd	s2,64(sp)
 634:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 636:	0005c903          	lbu	s2,0(a1)
 63a:	26090863          	beqz	s2,8aa <vprintf+0x27e>
 63e:	e4a6                	sd	s1,72(sp)
 640:	fc4e                	sd	s3,56(sp)
 642:	f852                	sd	s4,48(sp)
 644:	f456                	sd	s5,40(sp)
 646:	f05a                	sd	s6,32(sp)
 648:	ec5e                	sd	s7,24(sp)
 64a:	e862                	sd	s8,16(sp)
 64c:	e466                	sd	s9,8(sp)
 64e:	8b2a                	mv	s6,a0
 650:	8a2e                	mv	s4,a1
 652:	8bb2                	mv	s7,a2
  state = 0;
 654:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 656:	4481                	li	s1,0
 658:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 65a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 65e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 662:	06c00c93          	li	s9,108
 666:	a005                	j	686 <vprintf+0x5a>
        putc(fd, c0);
 668:	85ca                	mv	a1,s2
 66a:	855a                	mv	a0,s6
 66c:	efbff0ef          	jal	566 <putc>
 670:	a019                	j	676 <vprintf+0x4a>
    } else if(state == '%'){
 672:	03598263          	beq	s3,s5,696 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 676:	2485                	addiw	s1,s1,1
 678:	8726                	mv	a4,s1
 67a:	009a07b3          	add	a5,s4,s1
 67e:	0007c903          	lbu	s2,0(a5)
 682:	20090c63          	beqz	s2,89a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 686:	0009079b          	sext.w	a5,s2
    if(state == 0){
 68a:	fe0994e3          	bnez	s3,672 <vprintf+0x46>
      if(c0 == '%'){
 68e:	fd579de3          	bne	a5,s5,668 <vprintf+0x3c>
        state = '%';
 692:	89be                	mv	s3,a5
 694:	b7cd                	j	676 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 696:	00ea06b3          	add	a3,s4,a4
 69a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 69e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6a0:	c681                	beqz	a3,6a8 <vprintf+0x7c>
 6a2:	9752                	add	a4,a4,s4
 6a4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6a8:	03878f63          	beq	a5,s8,6e6 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6ac:	05978963          	beq	a5,s9,6fe <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6b0:	07500713          	li	a4,117
 6b4:	0ee78363          	beq	a5,a4,79a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6b8:	07800713          	li	a4,120
 6bc:	12e78563          	beq	a5,a4,7e6 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6c0:	07000713          	li	a4,112
 6c4:	14e78a63          	beq	a5,a4,818 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6c8:	07300713          	li	a4,115
 6cc:	18e78a63          	beq	a5,a4,860 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6d0:	02500713          	li	a4,37
 6d4:	04e79563          	bne	a5,a4,71e <vprintf+0xf2>
        putc(fd, '%');
 6d8:	02500593          	li	a1,37
 6dc:	855a                	mv	a0,s6
 6de:	e89ff0ef          	jal	566 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	bf49                	j	676 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6e6:	008b8913          	addi	s2,s7,8
 6ea:	4685                	li	a3,1
 6ec:	4629                	li	a2,10
 6ee:	000ba583          	lw	a1,0(s7)
 6f2:	855a                	mv	a0,s6
 6f4:	e91ff0ef          	jal	584 <printint>
 6f8:	8bca                	mv	s7,s2
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	bfad                	j	676 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6fe:	06400793          	li	a5,100
 702:	02f68963          	beq	a3,a5,734 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 706:	06c00793          	li	a5,108
 70a:	04f68263          	beq	a3,a5,74e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 70e:	07500793          	li	a5,117
 712:	0af68063          	beq	a3,a5,7b2 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 716:	07800793          	li	a5,120
 71a:	0ef68263          	beq	a3,a5,7fe <vprintf+0x1d2>
        putc(fd, '%');
 71e:	02500593          	li	a1,37
 722:	855a                	mv	a0,s6
 724:	e43ff0ef          	jal	566 <putc>
        putc(fd, c0);
 728:	85ca                	mv	a1,s2
 72a:	855a                	mv	a0,s6
 72c:	e3bff0ef          	jal	566 <putc>
      state = 0;
 730:	4981                	li	s3,0
 732:	b791                	j	676 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 734:	008b8913          	addi	s2,s7,8
 738:	4685                	li	a3,1
 73a:	4629                	li	a2,10
 73c:	000ba583          	lw	a1,0(s7)
 740:	855a                	mv	a0,s6
 742:	e43ff0ef          	jal	584 <printint>
        i += 1;
 746:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 748:	8bca                	mv	s7,s2
      state = 0;
 74a:	4981                	li	s3,0
        i += 1;
 74c:	b72d                	j	676 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 74e:	06400793          	li	a5,100
 752:	02f60763          	beq	a2,a5,780 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 756:	07500793          	li	a5,117
 75a:	06f60963          	beq	a2,a5,7cc <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 75e:	07800793          	li	a5,120
 762:	faf61ee3          	bne	a2,a5,71e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 766:	008b8913          	addi	s2,s7,8
 76a:	4681                	li	a3,0
 76c:	4641                	li	a2,16
 76e:	000ba583          	lw	a1,0(s7)
 772:	855a                	mv	a0,s6
 774:	e11ff0ef          	jal	584 <printint>
        i += 2;
 778:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 77a:	8bca                	mv	s7,s2
      state = 0;
 77c:	4981                	li	s3,0
        i += 2;
 77e:	bde5                	j	676 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 780:	008b8913          	addi	s2,s7,8
 784:	4685                	li	a3,1
 786:	4629                	li	a2,10
 788:	000ba583          	lw	a1,0(s7)
 78c:	855a                	mv	a0,s6
 78e:	df7ff0ef          	jal	584 <printint>
        i += 2;
 792:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 794:	8bca                	mv	s7,s2
      state = 0;
 796:	4981                	li	s3,0
        i += 2;
 798:	bdf9                	j	676 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 79a:	008b8913          	addi	s2,s7,8
 79e:	4681                	li	a3,0
 7a0:	4629                	li	a2,10
 7a2:	000ba583          	lw	a1,0(s7)
 7a6:	855a                	mv	a0,s6
 7a8:	dddff0ef          	jal	584 <printint>
 7ac:	8bca                	mv	s7,s2
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	b5d9                	j	676 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b2:	008b8913          	addi	s2,s7,8
 7b6:	4681                	li	a3,0
 7b8:	4629                	li	a2,10
 7ba:	000ba583          	lw	a1,0(s7)
 7be:	855a                	mv	a0,s6
 7c0:	dc5ff0ef          	jal	584 <printint>
        i += 1;
 7c4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c6:	8bca                	mv	s7,s2
      state = 0;
 7c8:	4981                	li	s3,0
        i += 1;
 7ca:	b575                	j	676 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7cc:	008b8913          	addi	s2,s7,8
 7d0:	4681                	li	a3,0
 7d2:	4629                	li	a2,10
 7d4:	000ba583          	lw	a1,0(s7)
 7d8:	855a                	mv	a0,s6
 7da:	dabff0ef          	jal	584 <printint>
        i += 2;
 7de:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e0:	8bca                	mv	s7,s2
      state = 0;
 7e2:	4981                	li	s3,0
        i += 2;
 7e4:	bd49                	j	676 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7e6:	008b8913          	addi	s2,s7,8
 7ea:	4681                	li	a3,0
 7ec:	4641                	li	a2,16
 7ee:	000ba583          	lw	a1,0(s7)
 7f2:	855a                	mv	a0,s6
 7f4:	d91ff0ef          	jal	584 <printint>
 7f8:	8bca                	mv	s7,s2
      state = 0;
 7fa:	4981                	li	s3,0
 7fc:	bdad                	j	676 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7fe:	008b8913          	addi	s2,s7,8
 802:	4681                	li	a3,0
 804:	4641                	li	a2,16
 806:	000ba583          	lw	a1,0(s7)
 80a:	855a                	mv	a0,s6
 80c:	d79ff0ef          	jal	584 <printint>
        i += 1;
 810:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 812:	8bca                	mv	s7,s2
      state = 0;
 814:	4981                	li	s3,0
        i += 1;
 816:	b585                	j	676 <vprintf+0x4a>
 818:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 81a:	008b8d13          	addi	s10,s7,8
 81e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 822:	03000593          	li	a1,48
 826:	855a                	mv	a0,s6
 828:	d3fff0ef          	jal	566 <putc>
  putc(fd, 'x');
 82c:	07800593          	li	a1,120
 830:	855a                	mv	a0,s6
 832:	d35ff0ef          	jal	566 <putc>
 836:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 838:	00000b97          	auipc	s7,0x0
 83c:	308b8b93          	addi	s7,s7,776 # b40 <digits>
 840:	03c9d793          	srli	a5,s3,0x3c
 844:	97de                	add	a5,a5,s7
 846:	0007c583          	lbu	a1,0(a5)
 84a:	855a                	mv	a0,s6
 84c:	d1bff0ef          	jal	566 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 850:	0992                	slli	s3,s3,0x4
 852:	397d                	addiw	s2,s2,-1
 854:	fe0916e3          	bnez	s2,840 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 858:	8bea                	mv	s7,s10
      state = 0;
 85a:	4981                	li	s3,0
 85c:	6d02                	ld	s10,0(sp)
 85e:	bd21                	j	676 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 860:	008b8993          	addi	s3,s7,8
 864:	000bb903          	ld	s2,0(s7)
 868:	00090f63          	beqz	s2,886 <vprintf+0x25a>
        for(; *s; s++)
 86c:	00094583          	lbu	a1,0(s2)
 870:	c195                	beqz	a1,894 <vprintf+0x268>
          putc(fd, *s);
 872:	855a                	mv	a0,s6
 874:	cf3ff0ef          	jal	566 <putc>
        for(; *s; s++)
 878:	0905                	addi	s2,s2,1
 87a:	00094583          	lbu	a1,0(s2)
 87e:	f9f5                	bnez	a1,872 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 880:	8bce                	mv	s7,s3
      state = 0;
 882:	4981                	li	s3,0
 884:	bbcd                	j	676 <vprintf+0x4a>
          s = "(null)";
 886:	00000917          	auipc	s2,0x0
 88a:	2b290913          	addi	s2,s2,690 # b38 <malloc+0x1a6>
        for(; *s; s++)
 88e:	02800593          	li	a1,40
 892:	b7c5                	j	872 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 894:	8bce                	mv	s7,s3
      state = 0;
 896:	4981                	li	s3,0
 898:	bbf9                	j	676 <vprintf+0x4a>
 89a:	64a6                	ld	s1,72(sp)
 89c:	79e2                	ld	s3,56(sp)
 89e:	7a42                	ld	s4,48(sp)
 8a0:	7aa2                	ld	s5,40(sp)
 8a2:	7b02                	ld	s6,32(sp)
 8a4:	6be2                	ld	s7,24(sp)
 8a6:	6c42                	ld	s8,16(sp)
 8a8:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8aa:	60e6                	ld	ra,88(sp)
 8ac:	6446                	ld	s0,80(sp)
 8ae:	6906                	ld	s2,64(sp)
 8b0:	6125                	addi	sp,sp,96
 8b2:	8082                	ret

00000000000008b4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8b4:	715d                	addi	sp,sp,-80
 8b6:	ec06                	sd	ra,24(sp)
 8b8:	e822                	sd	s0,16(sp)
 8ba:	1000                	addi	s0,sp,32
 8bc:	e010                	sd	a2,0(s0)
 8be:	e414                	sd	a3,8(s0)
 8c0:	e818                	sd	a4,16(s0)
 8c2:	ec1c                	sd	a5,24(s0)
 8c4:	03043023          	sd	a6,32(s0)
 8c8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8cc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8d0:	8622                	mv	a2,s0
 8d2:	d5bff0ef          	jal	62c <vprintf>
}
 8d6:	60e2                	ld	ra,24(sp)
 8d8:	6442                	ld	s0,16(sp)
 8da:	6161                	addi	sp,sp,80
 8dc:	8082                	ret

00000000000008de <printf>:

void
printf(const char *fmt, ...)
{
 8de:	711d                	addi	sp,sp,-96
 8e0:	ec06                	sd	ra,24(sp)
 8e2:	e822                	sd	s0,16(sp)
 8e4:	1000                	addi	s0,sp,32
 8e6:	e40c                	sd	a1,8(s0)
 8e8:	e810                	sd	a2,16(s0)
 8ea:	ec14                	sd	a3,24(s0)
 8ec:	f018                	sd	a4,32(s0)
 8ee:	f41c                	sd	a5,40(s0)
 8f0:	03043823          	sd	a6,48(s0)
 8f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8f8:	00840613          	addi	a2,s0,8
 8fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 900:	85aa                	mv	a1,a0
 902:	4505                	li	a0,1
 904:	d29ff0ef          	jal	62c <vprintf>
}
 908:	60e2                	ld	ra,24(sp)
 90a:	6442                	ld	s0,16(sp)
 90c:	6125                	addi	sp,sp,96
 90e:	8082                	ret

0000000000000910 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 910:	1141                	addi	sp,sp,-16
 912:	e422                	sd	s0,8(sp)
 914:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 916:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91a:	00000797          	auipc	a5,0x0
 91e:	6e67b783          	ld	a5,1766(a5) # 1000 <freep>
 922:	a02d                	j	94c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 924:	4618                	lw	a4,8(a2)
 926:	9f2d                	addw	a4,a4,a1
 928:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 92c:	6398                	ld	a4,0(a5)
 92e:	6310                	ld	a2,0(a4)
 930:	a83d                	j	96e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 932:	ff852703          	lw	a4,-8(a0)
 936:	9f31                	addw	a4,a4,a2
 938:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 93a:	ff053683          	ld	a3,-16(a0)
 93e:	a091                	j	982 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 940:	6398                	ld	a4,0(a5)
 942:	00e7e463          	bltu	a5,a4,94a <free+0x3a>
 946:	00e6ea63          	bltu	a3,a4,95a <free+0x4a>
{
 94a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94c:	fed7fae3          	bgeu	a5,a3,940 <free+0x30>
 950:	6398                	ld	a4,0(a5)
 952:	00e6e463          	bltu	a3,a4,95a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 956:	fee7eae3          	bltu	a5,a4,94a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 95a:	ff852583          	lw	a1,-8(a0)
 95e:	6390                	ld	a2,0(a5)
 960:	02059813          	slli	a6,a1,0x20
 964:	01c85713          	srli	a4,a6,0x1c
 968:	9736                	add	a4,a4,a3
 96a:	fae60de3          	beq	a2,a4,924 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 96e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 972:	4790                	lw	a2,8(a5)
 974:	02061593          	slli	a1,a2,0x20
 978:	01c5d713          	srli	a4,a1,0x1c
 97c:	973e                	add	a4,a4,a5
 97e:	fae68ae3          	beq	a3,a4,932 <free+0x22>
    p->s.ptr = bp->s.ptr;
 982:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 984:	00000717          	auipc	a4,0x0
 988:	66f73e23          	sd	a5,1660(a4) # 1000 <freep>
}
 98c:	6422                	ld	s0,8(sp)
 98e:	0141                	addi	sp,sp,16
 990:	8082                	ret

0000000000000992 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 992:	7139                	addi	sp,sp,-64
 994:	fc06                	sd	ra,56(sp)
 996:	f822                	sd	s0,48(sp)
 998:	f426                	sd	s1,40(sp)
 99a:	ec4e                	sd	s3,24(sp)
 99c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 99e:	02051493          	slli	s1,a0,0x20
 9a2:	9081                	srli	s1,s1,0x20
 9a4:	04bd                	addi	s1,s1,15
 9a6:	8091                	srli	s1,s1,0x4
 9a8:	0014899b          	addiw	s3,s1,1
 9ac:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9ae:	00000517          	auipc	a0,0x0
 9b2:	65253503          	ld	a0,1618(a0) # 1000 <freep>
 9b6:	c915                	beqz	a0,9ea <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ba:	4798                	lw	a4,8(a5)
 9bc:	08977a63          	bgeu	a4,s1,a50 <malloc+0xbe>
 9c0:	f04a                	sd	s2,32(sp)
 9c2:	e852                	sd	s4,16(sp)
 9c4:	e456                	sd	s5,8(sp)
 9c6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9c8:	8a4e                	mv	s4,s3
 9ca:	0009871b          	sext.w	a4,s3
 9ce:	6685                	lui	a3,0x1
 9d0:	00d77363          	bgeu	a4,a3,9d6 <malloc+0x44>
 9d4:	6a05                	lui	s4,0x1
 9d6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9da:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9de:	00000917          	auipc	s2,0x0
 9e2:	62290913          	addi	s2,s2,1570 # 1000 <freep>
  if(p == (char*)-1)
 9e6:	5afd                	li	s5,-1
 9e8:	a081                	j	a28 <malloc+0x96>
 9ea:	f04a                	sd	s2,32(sp)
 9ec:	e852                	sd	s4,16(sp)
 9ee:	e456                	sd	s5,8(sp)
 9f0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9f2:	00000797          	auipc	a5,0x0
 9f6:	61e78793          	addi	a5,a5,1566 # 1010 <base>
 9fa:	00000717          	auipc	a4,0x0
 9fe:	60f73323          	sd	a5,1542(a4) # 1000 <freep>
 a02:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a04:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a08:	b7c1                	j	9c8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a0a:	6398                	ld	a4,0(a5)
 a0c:	e118                	sd	a4,0(a0)
 a0e:	a8a9                	j	a68 <malloc+0xd6>
  hp->s.size = nu;
 a10:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a14:	0541                	addi	a0,a0,16
 a16:	efbff0ef          	jal	910 <free>
  return freep;
 a1a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a1e:	c12d                	beqz	a0,a80 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a20:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a22:	4798                	lw	a4,8(a5)
 a24:	02977263          	bgeu	a4,s1,a48 <malloc+0xb6>
    if(p == freep)
 a28:	00093703          	ld	a4,0(s2)
 a2c:	853e                	mv	a0,a5
 a2e:	fef719e3          	bne	a4,a5,a20 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a32:	8552                	mv	a0,s4
 a34:	ad3ff0ef          	jal	506 <sbrk>
  if(p == (char*)-1)
 a38:	fd551ce3          	bne	a0,s5,a10 <malloc+0x7e>
        return 0;
 a3c:	4501                	li	a0,0
 a3e:	7902                	ld	s2,32(sp)
 a40:	6a42                	ld	s4,16(sp)
 a42:	6aa2                	ld	s5,8(sp)
 a44:	6b02                	ld	s6,0(sp)
 a46:	a03d                	j	a74 <malloc+0xe2>
 a48:	7902                	ld	s2,32(sp)
 a4a:	6a42                	ld	s4,16(sp)
 a4c:	6aa2                	ld	s5,8(sp)
 a4e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a50:	fae48de3          	beq	s1,a4,a0a <malloc+0x78>
        p->s.size -= nunits;
 a54:	4137073b          	subw	a4,a4,s3
 a58:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a5a:	02071693          	slli	a3,a4,0x20
 a5e:	01c6d713          	srli	a4,a3,0x1c
 a62:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a64:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a68:	00000717          	auipc	a4,0x0
 a6c:	58a73c23          	sd	a0,1432(a4) # 1000 <freep>
      return (void*)(p + 1);
 a70:	01078513          	addi	a0,a5,16
  }
}
 a74:	70e2                	ld	ra,56(sp)
 a76:	7442                	ld	s0,48(sp)
 a78:	74a2                	ld	s1,40(sp)
 a7a:	69e2                	ld	s3,24(sp)
 a7c:	6121                	addi	sp,sp,64
 a7e:	8082                	ret
 a80:	7902                	ld	s2,32(sp)
 a82:	6a42                	ld	s4,16(sp)
 a84:	6aa2                	ld	s5,8(sp)
 a86:	6b02                	ld	s6,0(sp)
 a88:	b7f5                	j	a74 <malloc+0xe2>
