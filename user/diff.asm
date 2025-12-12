
user/_diff:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <readline>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int readline(int fd, char *buf, int max)
{
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
    int n=0;
    char c;
    while(n < max-1){
  18:	892e                	mv	s2,a1
    int n=0;
  1a:	4481                	li	s1,0
    while(n < max-1){
  1c:	fff6099b          	addiw	s3,a2,-1
        if(read(fd, &c, 1) != 1)
            break;
        buf[n++] = c;
        if(c=='\n') break;
  20:	4aa9                	li	s5,10
    while(n < max-1){
  22:	0334d363          	bge	s1,s3,48 <readline+0x48>
        if(read(fd, &c, 1) != 1)
  26:	4605                	li	a2,1
  28:	fbf40593          	addi	a1,s0,-65
  2c:	8552                	mv	a0,s4
  2e:	4be000ef          	jal	4ec <read>
  32:	4785                	li	a5,1
  34:	00f51a63          	bne	a0,a5,48 <readline+0x48>
        buf[n++] = c;
  38:	2485                	addiw	s1,s1,1
  3a:	fbf44783          	lbu	a5,-65(s0)
  3e:	00f90023          	sb	a5,0(s2)
        if(c=='\n') break;
  42:	0905                	addi	s2,s2,1
  44:	fd579fe3          	bne	a5,s5,22 <readline+0x22>
    }
    buf[n] = 0;
  48:	9b26                	add	s6,s6,s1
  4a:	000b0023          	sb	zero,0(s6)
    return n;
}
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

void strip_newlines(char *buf)
{
  64:	1101                	addi	sp,sp,-32
  66:	ec06                	sd	ra,24(sp)
  68:	e822                	sd	s0,16(sp)
  6a:	e426                	sd	s1,8(sp)
  6c:	1000                	addi	s0,sp,32
  6e:	84aa                	mv	s1,a0
    int len = strlen(buf);
  70:	254000ef          	jal	2c4 <strlen>
  74:	0005079b          	sext.w	a5,a0
    if(len > 0 && buf[len-1] == '\n'){
  78:	00f05a63          	blez	a5,8c <strip_newlines+0x28>
  7c:	17fd                	addi	a5,a5,-1
  7e:	00f48533          	add	a0,s1,a5
  82:	00054703          	lbu	a4,0(a0)
  86:	47a9                	li	a5,10
  88:	00f70763          	beq	a4,a5,96 <strip_newlines+0x32>
        buf[len-1] = 0;
        len--;
    }

}
  8c:	60e2                	ld	ra,24(sp)
  8e:	6442                	ld	s0,16(sp)
  90:	64a2                	ld	s1,8(sp)
  92:	6105                	addi	sp,sp,32
  94:	8082                	ret
        buf[len-1] = 0;
  96:	00050023          	sb	zero,0(a0)
}
  9a:	bfcd                	j	8c <strip_newlines+0x28>

000000000000009c <main>:

int main(int argc, char *argv[])
{
  9c:	ba010113          	addi	sp,sp,-1120
  a0:	44113c23          	sd	ra,1112(sp)
  a4:	44813823          	sd	s0,1104(sp)
  a8:	43313c23          	sd	s3,1080(sp)
  ac:	46010413          	addi	s0,sp,1120
  b0:	89ae                	mv	s3,a1
    if(argc == 2 && strcmp(argv[1], "?") == 0){
  b2:	4789                	li	a5,2
  b4:	04f50063          	beq	a0,a5,f4 <main+0x58>
        printf("Usage: diff <file1> <file2>\n");
        exit(0);
    }

    if(argc != 3){
  b8:	478d                	li	a5,3
  ba:	08f50163          	beq	a0,a5,13c <main+0xa0>
  be:	44913423          	sd	s1,1096(sp)
  c2:	45213023          	sd	s2,1088(sp)
  c6:	43413823          	sd	s4,1072(sp)
  ca:	43513423          	sd	s5,1064(sp)
  ce:	43613023          	sd	s6,1056(sp)
  d2:	41713c23          	sd	s7,1048(sp)
  d6:	41813823          	sd	s8,1040(sp)
  da:	41913423          	sd	s9,1032(sp)
  de:	41a13023          	sd	s10,1024(sp)
        printf("Error: diff requires 2 files\n");
  e2:	00001517          	auipc	a0,0x1
  e6:	a2650513          	addi	a0,a0,-1498 # b08 <malloc+0x120>
  ea:	04b000ef          	jal	934 <printf>
        exit(1);
  ee:	4505                	li	a0,1
  f0:	3e4000ef          	jal	4d4 <exit>
    if(argc == 2 && strcmp(argv[1], "?") == 0){
  f4:	00001597          	auipc	a1,0x1
  f8:	9ec58593          	addi	a1,a1,-1556 # ae0 <malloc+0xf8>
  fc:	0089b503          	ld	a0,8(s3)
 100:	198000ef          	jal	298 <strcmp>
 104:	fd4d                	bnez	a0,be <main+0x22>
 106:	44913423          	sd	s1,1096(sp)
 10a:	45213023          	sd	s2,1088(sp)
 10e:	43413823          	sd	s4,1072(sp)
 112:	43513423          	sd	s5,1064(sp)
 116:	43613023          	sd	s6,1056(sp)
 11a:	41713c23          	sd	s7,1048(sp)
 11e:	41813823          	sd	s8,1040(sp)
 122:	41913423          	sd	s9,1032(sp)
 126:	41a13023          	sd	s10,1024(sp)
        printf("Usage: diff <file1> <file2>\n");
 12a:	00001517          	auipc	a0,0x1
 12e:	9be50513          	addi	a0,a0,-1602 # ae8 <malloc+0x100>
 132:	003000ef          	jal	934 <printf>
        exit(0);
 136:	4501                	li	a0,0
 138:	39c000ef          	jal	4d4 <exit>
 13c:	44913423          	sd	s1,1096(sp)
 140:	45213023          	sd	s2,1088(sp)
 144:	43413823          	sd	s4,1072(sp)
 148:	43513423          	sd	s5,1064(sp)
 14c:	43613023          	sd	s6,1056(sp)
 150:	41713c23          	sd	s7,1048(sp)
 154:	41813823          	sd	s8,1040(sp)
 158:	41913423          	sd	s9,1032(sp)
 15c:	41a13023          	sd	s10,1024(sp)
    }

    int fd1 = open(argv[1], 0);
 160:	4581                	li	a1,0
 162:	0089b503          	ld	a0,8(s3)
 166:	3ae000ef          	jal	514 <open>
 16a:	8b2a                	mv	s6,a0
    int fd2 = open(argv[2], 0);
 16c:	4581                	li	a1,0
 16e:	0109b503          	ld	a0,16(s3)
 172:	3a2000ef          	jal	514 <open>
 176:	8aaa                	mv	s5,a0

    if(fd1 < 0 || fd2 < 0){
 178:	00ab67b3          	or	a5,s6,a0
 17c:	02079713          	slli	a4,a5,0x20
 180:	00074e63          	bltz	a4,19c <main+0x100>
        exit(1);
    }

    char b1[512], b2[512];
    int line=1;
    int diff = 0;
 184:	4b81                	li	s7,0
    int line=1;
 186:	4a05                	li	s4,1
            diff=1;
            printf("Line %d only in %s:\n> %s\n", line, argv[2], b2);
        }
        else if(strcmp(b1, b2) != 0){
            diff=1;
            printf("Line %d differs:\n< %s\n> %s\n", line, b1, b2);
 188:	00001c97          	auipc	s9,0x1
 18c:	a00c8c93          	addi	s9,s9,-1536 # b88 <malloc+0x1a0>
            diff=1;
 190:	4c05                	li	s8,1
            printf("Line %d only in %s:\n< %s\n", line, argv[1], b1);
 192:	00001d17          	auipc	s10,0x1
 196:	9b6d0d13          	addi	s10,s10,-1610 # b48 <malloc+0x160>
 19a:	a091                	j	1de <main+0x142>
        printf("Error: cannot open files\n");
 19c:	00001517          	auipc	a0,0x1
 1a0:	98c50513          	addi	a0,a0,-1652 # b28 <malloc+0x140>
 1a4:	790000ef          	jal	934 <printf>
        exit(1);
 1a8:	4505                	li	a0,1
 1aa:	32a000ef          	jal	4d4 <exit>
        else if(n2 > 0 && n1 == 0){
 1ae:	03205063          	blez	s2,1ce <main+0x132>
 1b2:	ec91                	bnez	s1,1ce <main+0x132>
            printf("Line %d only in %s:\n> %s\n", line, argv[2], b2);
 1b4:	ba040693          	addi	a3,s0,-1120
 1b8:	0109b603          	ld	a2,16(s3)
 1bc:	85d2                	mv	a1,s4
 1be:	00001517          	auipc	a0,0x1
 1c2:	9aa50513          	addi	a0,a0,-1622 # b68 <malloc+0x180>
 1c6:	76e000ef          	jal	934 <printf>
            diff=1;
 1ca:	4b85                	li	s7,1
            printf("Line %d only in %s:\n> %s\n", line, argv[2], b2);
 1cc:	a801                	j	1dc <main+0x140>
        else if(strcmp(b1, b2) != 0){
 1ce:	ba040593          	addi	a1,s0,-1120
 1d2:	da040513          	addi	a0,s0,-608
 1d6:	0c2000ef          	jal	298 <strcmp>
 1da:	ed21                	bnez	a0,232 <main+0x196>
        }

        line++;
 1dc:	2a05                	addiw	s4,s4,1
        int n1 = readline(fd1, b1, sizeof(b1));
 1de:	20000613          	li	a2,512
 1e2:	da040593          	addi	a1,s0,-608
 1e6:	855a                	mv	a0,s6
 1e8:	e19ff0ef          	jal	0 <readline>
 1ec:	84aa                	mv	s1,a0
        int n2 = readline(fd2, b2, sizeof(b2));
 1ee:	20000613          	li	a2,512
 1f2:	ba040593          	addi	a1,s0,-1120
 1f6:	8556                	mv	a0,s5
 1f8:	e09ff0ef          	jal	0 <readline>
 1fc:	892a                	mv	s2,a0
        if(n1 == 0 && n2 == 0)
 1fe:	00a4e7b3          	or	a5,s1,a0
 202:	2781                	sext.w	a5,a5
 204:	c3a9                	beqz	a5,246 <main+0x1aa>
        strip_newlines(b1);
 206:	da040513          	addi	a0,s0,-608
 20a:	e5bff0ef          	jal	64 <strip_newlines>
        strip_newlines(b2);
 20e:	ba040513          	addi	a0,s0,-1120
 212:	e53ff0ef          	jal	64 <strip_newlines>
        if(n1 > 0 && n2 == 0){
 216:	f8905ce3          	blez	s1,1ae <main+0x112>
 21a:	fa091ae3          	bnez	s2,1ce <main+0x132>
            printf("Line %d only in %s:\n< %s\n", line, argv[1], b1);
 21e:	da040693          	addi	a3,s0,-608
 222:	0089b603          	ld	a2,8(s3)
 226:	85d2                	mv	a1,s4
 228:	856a                	mv	a0,s10
 22a:	70a000ef          	jal	934 <printf>
            diff=1;
 22e:	8be2                	mv	s7,s8
            printf("Line %d only in %s:\n< %s\n", line, argv[1], b1);
 230:	b775                	j	1dc <main+0x140>
            printf("Line %d differs:\n< %s\n> %s\n", line, b1, b2);
 232:	ba040693          	addi	a3,s0,-1120
 236:	da040613          	addi	a2,s0,-608
 23a:	85d2                	mv	a1,s4
 23c:	8566                	mv	a0,s9
 23e:	6f6000ef          	jal	934 <printf>
            diff=1;
 242:	8be2                	mv	s7,s8
 244:	bf61                	j	1dc <main+0x140>
    }

    if(!diff)
 246:	000b8b63          	beqz	s7,25c <main+0x1c0>
        printf("Files are identical\n");

    close(fd1);
 24a:	855a                	mv	a0,s6
 24c:	2b0000ef          	jal	4fc <close>
    close(fd2);
 250:	8556                	mv	a0,s5
 252:	2aa000ef          	jal	4fc <close>
    exit(0);
 256:	4501                	li	a0,0
 258:	27c000ef          	jal	4d4 <exit>
        printf("Files are identical\n");
 25c:	00001517          	auipc	a0,0x1
 260:	94c50513          	addi	a0,a0,-1716 # ba8 <malloc+0x1c0>
 264:	6d0000ef          	jal	934 <printf>
 268:	b7cd                	j	24a <main+0x1ae>

000000000000026a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e406                	sd	ra,8(sp)
 26e:	e022                	sd	s0,0(sp)
 270:	0800                	addi	s0,sp,16
  extern int main();
  main();
 272:	e2bff0ef          	jal	9c <main>
  exit(0);
 276:	4501                	li	a0,0
 278:	25c000ef          	jal	4d4 <exit>

000000000000027c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 27c:	1141                	addi	sp,sp,-16
 27e:	e422                	sd	s0,8(sp)
 280:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 282:	87aa                	mv	a5,a0
 284:	0585                	addi	a1,a1,1
 286:	0785                	addi	a5,a5,1
 288:	fff5c703          	lbu	a4,-1(a1)
 28c:	fee78fa3          	sb	a4,-1(a5)
 290:	fb75                	bnez	a4,284 <strcpy+0x8>
    ;
  return os;
}
 292:	6422                	ld	s0,8(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret

0000000000000298 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 29e:	00054783          	lbu	a5,0(a0)
 2a2:	cb91                	beqz	a5,2b6 <strcmp+0x1e>
 2a4:	0005c703          	lbu	a4,0(a1)
 2a8:	00f71763          	bne	a4,a5,2b6 <strcmp+0x1e>
    p++, q++;
 2ac:	0505                	addi	a0,a0,1
 2ae:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2b0:	00054783          	lbu	a5,0(a0)
 2b4:	fbe5                	bnez	a5,2a4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2b6:	0005c503          	lbu	a0,0(a1)
}
 2ba:	40a7853b          	subw	a0,a5,a0
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret

00000000000002c4 <strlen>:

uint
strlen(const char *s)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2ca:	00054783          	lbu	a5,0(a0)
 2ce:	cf91                	beqz	a5,2ea <strlen+0x26>
 2d0:	0505                	addi	a0,a0,1
 2d2:	87aa                	mv	a5,a0
 2d4:	86be                	mv	a3,a5
 2d6:	0785                	addi	a5,a5,1
 2d8:	fff7c703          	lbu	a4,-1(a5)
 2dc:	ff65                	bnez	a4,2d4 <strlen+0x10>
 2de:	40a6853b          	subw	a0,a3,a0
 2e2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2e4:	6422                	ld	s0,8(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret
  for(n = 0; s[n]; n++)
 2ea:	4501                	li	a0,0
 2ec:	bfe5                	j	2e4 <strlen+0x20>

00000000000002ee <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ee:	1141                	addi	sp,sp,-16
 2f0:	e422                	sd	s0,8(sp)
 2f2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2f4:	ca19                	beqz	a2,30a <memset+0x1c>
 2f6:	87aa                	mv	a5,a0
 2f8:	1602                	slli	a2,a2,0x20
 2fa:	9201                	srli	a2,a2,0x20
 2fc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 300:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 304:	0785                	addi	a5,a5,1
 306:	fee79de3          	bne	a5,a4,300 <memset+0x12>
  }
  return dst;
}
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret

0000000000000310 <strchr>:

char*
strchr(const char *s, char c)
{
 310:	1141                	addi	sp,sp,-16
 312:	e422                	sd	s0,8(sp)
 314:	0800                	addi	s0,sp,16
  for(; *s; s++)
 316:	00054783          	lbu	a5,0(a0)
 31a:	cb99                	beqz	a5,330 <strchr+0x20>
    if(*s == c)
 31c:	00f58763          	beq	a1,a5,32a <strchr+0x1a>
  for(; *s; s++)
 320:	0505                	addi	a0,a0,1
 322:	00054783          	lbu	a5,0(a0)
 326:	fbfd                	bnez	a5,31c <strchr+0xc>
      return (char*)s;
  return 0;
 328:	4501                	li	a0,0
}
 32a:	6422                	ld	s0,8(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret
  return 0;
 330:	4501                	li	a0,0
 332:	bfe5                	j	32a <strchr+0x1a>

0000000000000334 <gets>:

char*
gets(char *buf, int max)
{
 334:	711d                	addi	sp,sp,-96
 336:	ec86                	sd	ra,88(sp)
 338:	e8a2                	sd	s0,80(sp)
 33a:	e4a6                	sd	s1,72(sp)
 33c:	e0ca                	sd	s2,64(sp)
 33e:	fc4e                	sd	s3,56(sp)
 340:	f852                	sd	s4,48(sp)
 342:	f456                	sd	s5,40(sp)
 344:	f05a                	sd	s6,32(sp)
 346:	ec5e                	sd	s7,24(sp)
 348:	1080                	addi	s0,sp,96
 34a:	8baa                	mv	s7,a0
 34c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34e:	892a                	mv	s2,a0
 350:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 352:	4aa9                	li	s5,10
 354:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 356:	89a6                	mv	s3,s1
 358:	2485                	addiw	s1,s1,1
 35a:	0344d663          	bge	s1,s4,386 <gets+0x52>
    cc = read(0, &c, 1);
 35e:	4605                	li	a2,1
 360:	faf40593          	addi	a1,s0,-81
 364:	4501                	li	a0,0
 366:	186000ef          	jal	4ec <read>
    if(cc < 1)
 36a:	00a05e63          	blez	a0,386 <gets+0x52>
    buf[i++] = c;
 36e:	faf44783          	lbu	a5,-81(s0)
 372:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 376:	01578763          	beq	a5,s5,384 <gets+0x50>
 37a:	0905                	addi	s2,s2,1
 37c:	fd679de3          	bne	a5,s6,356 <gets+0x22>
    buf[i++] = c;
 380:	89a6                	mv	s3,s1
 382:	a011                	j	386 <gets+0x52>
 384:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 386:	99de                	add	s3,s3,s7
 388:	00098023          	sb	zero,0(s3)
  return buf;
}
 38c:	855e                	mv	a0,s7
 38e:	60e6                	ld	ra,88(sp)
 390:	6446                	ld	s0,80(sp)
 392:	64a6                	ld	s1,72(sp)
 394:	6906                	ld	s2,64(sp)
 396:	79e2                	ld	s3,56(sp)
 398:	7a42                	ld	s4,48(sp)
 39a:	7aa2                	ld	s5,40(sp)
 39c:	7b02                	ld	s6,32(sp)
 39e:	6be2                	ld	s7,24(sp)
 3a0:	6125                	addi	sp,sp,96
 3a2:	8082                	ret

00000000000003a4 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a4:	1101                	addi	sp,sp,-32
 3a6:	ec06                	sd	ra,24(sp)
 3a8:	e822                	sd	s0,16(sp)
 3aa:	e04a                	sd	s2,0(sp)
 3ac:	1000                	addi	s0,sp,32
 3ae:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b0:	4581                	li	a1,0
 3b2:	162000ef          	jal	514 <open>
  if(fd < 0)
 3b6:	02054263          	bltz	a0,3da <stat+0x36>
 3ba:	e426                	sd	s1,8(sp)
 3bc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3be:	85ca                	mv	a1,s2
 3c0:	16c000ef          	jal	52c <fstat>
 3c4:	892a                	mv	s2,a0
  close(fd);
 3c6:	8526                	mv	a0,s1
 3c8:	134000ef          	jal	4fc <close>
  return r;
 3cc:	64a2                	ld	s1,8(sp)
}
 3ce:	854a                	mv	a0,s2
 3d0:	60e2                	ld	ra,24(sp)
 3d2:	6442                	ld	s0,16(sp)
 3d4:	6902                	ld	s2,0(sp)
 3d6:	6105                	addi	sp,sp,32
 3d8:	8082                	ret
    return -1;
 3da:	597d                	li	s2,-1
 3dc:	bfcd                	j	3ce <stat+0x2a>

00000000000003de <atoi>:

int
atoi(const char *s)
{
 3de:	1141                	addi	sp,sp,-16
 3e0:	e422                	sd	s0,8(sp)
 3e2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e4:	00054683          	lbu	a3,0(a0)
 3e8:	fd06879b          	addiw	a5,a3,-48
 3ec:	0ff7f793          	zext.b	a5,a5
 3f0:	4625                	li	a2,9
 3f2:	02f66863          	bltu	a2,a5,422 <atoi+0x44>
 3f6:	872a                	mv	a4,a0
  n = 0;
 3f8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3fa:	0705                	addi	a4,a4,1
 3fc:	0025179b          	slliw	a5,a0,0x2
 400:	9fa9                	addw	a5,a5,a0
 402:	0017979b          	slliw	a5,a5,0x1
 406:	9fb5                	addw	a5,a5,a3
 408:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 40c:	00074683          	lbu	a3,0(a4)
 410:	fd06879b          	addiw	a5,a3,-48
 414:	0ff7f793          	zext.b	a5,a5
 418:	fef671e3          	bgeu	a2,a5,3fa <atoi+0x1c>
  return n;
}
 41c:	6422                	ld	s0,8(sp)
 41e:	0141                	addi	sp,sp,16
 420:	8082                	ret
  n = 0;
 422:	4501                	li	a0,0
 424:	bfe5                	j	41c <atoi+0x3e>

0000000000000426 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 426:	1141                	addi	sp,sp,-16
 428:	e422                	sd	s0,8(sp)
 42a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 42c:	02b57463          	bgeu	a0,a1,454 <memmove+0x2e>
    while(n-- > 0)
 430:	00c05f63          	blez	a2,44e <memmove+0x28>
 434:	1602                	slli	a2,a2,0x20
 436:	9201                	srli	a2,a2,0x20
 438:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 43c:	872a                	mv	a4,a0
      *dst++ = *src++;
 43e:	0585                	addi	a1,a1,1
 440:	0705                	addi	a4,a4,1
 442:	fff5c683          	lbu	a3,-1(a1)
 446:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 44a:	fef71ae3          	bne	a4,a5,43e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 44e:	6422                	ld	s0,8(sp)
 450:	0141                	addi	sp,sp,16
 452:	8082                	ret
    dst += n;
 454:	00c50733          	add	a4,a0,a2
    src += n;
 458:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 45a:	fec05ae3          	blez	a2,44e <memmove+0x28>
 45e:	fff6079b          	addiw	a5,a2,-1
 462:	1782                	slli	a5,a5,0x20
 464:	9381                	srli	a5,a5,0x20
 466:	fff7c793          	not	a5,a5
 46a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 46c:	15fd                	addi	a1,a1,-1
 46e:	177d                	addi	a4,a4,-1
 470:	0005c683          	lbu	a3,0(a1)
 474:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 478:	fee79ae3          	bne	a5,a4,46c <memmove+0x46>
 47c:	bfc9                	j	44e <memmove+0x28>

000000000000047e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 47e:	1141                	addi	sp,sp,-16
 480:	e422                	sd	s0,8(sp)
 482:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 484:	ca05                	beqz	a2,4b4 <memcmp+0x36>
 486:	fff6069b          	addiw	a3,a2,-1
 48a:	1682                	slli	a3,a3,0x20
 48c:	9281                	srli	a3,a3,0x20
 48e:	0685                	addi	a3,a3,1
 490:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 492:	00054783          	lbu	a5,0(a0)
 496:	0005c703          	lbu	a4,0(a1)
 49a:	00e79863          	bne	a5,a4,4aa <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 49e:	0505                	addi	a0,a0,1
    p2++;
 4a0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4a2:	fed518e3          	bne	a0,a3,492 <memcmp+0x14>
  }
  return 0;
 4a6:	4501                	li	a0,0
 4a8:	a019                	j	4ae <memcmp+0x30>
      return *p1 - *p2;
 4aa:	40e7853b          	subw	a0,a5,a4
}
 4ae:	6422                	ld	s0,8(sp)
 4b0:	0141                	addi	sp,sp,16
 4b2:	8082                	ret
  return 0;
 4b4:	4501                	li	a0,0
 4b6:	bfe5                	j	4ae <memcmp+0x30>

00000000000004b8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4b8:	1141                	addi	sp,sp,-16
 4ba:	e406                	sd	ra,8(sp)
 4bc:	e022                	sd	s0,0(sp)
 4be:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4c0:	f67ff0ef          	jal	426 <memmove>
}
 4c4:	60a2                	ld	ra,8(sp)
 4c6:	6402                	ld	s0,0(sp)
 4c8:	0141                	addi	sp,sp,16
 4ca:	8082                	ret

00000000000004cc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4cc:	4885                	li	a7,1
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d4:	4889                	li	a7,2
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <wait>:
.global wait
wait:
 li a7, SYS_wait
 4dc:	488d                	li	a7,3
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4e4:	4891                	li	a7,4
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <read>:
.global read
read:
 li a7, SYS_read
 4ec:	4895                	li	a7,5
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <write>:
.global write
write:
 li a7, SYS_write
 4f4:	48c1                	li	a7,16
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <close>:
.global close
close:
 li a7, SYS_close
 4fc:	48d5                	li	a7,21
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <kill>:
.global kill
kill:
 li a7, SYS_kill
 504:	4899                	li	a7,6
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <exec>:
.global exec
exec:
 li a7, SYS_exec
 50c:	489d                	li	a7,7
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <open>:
.global open
open:
 li a7, SYS_open
 514:	48bd                	li	a7,15
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 51c:	48c5                	li	a7,17
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 524:	48c9                	li	a7,18
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 52c:	48a1                	li	a7,8
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <link>:
.global link
link:
 li a7, SYS_link
 534:	48cd                	li	a7,19
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 53c:	48d1                	li	a7,20
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 544:	48a5                	li	a7,9
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <dup>:
.global dup
dup:
 li a7, SYS_dup
 54c:	48a9                	li	a7,10
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 554:	48ad                	li	a7,11
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 55c:	48b1                	li	a7,12
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 564:	48b5                	li	a7,13
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 56c:	48b9                	li	a7,14
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 574:	48d9                	li	a7,22
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 57c:	48dd                	li	a7,23
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 584:	48e1                	li	a7,24
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 58c:	48e5                	li	a7,25
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <random>:
.global random
random:
 li a7, SYS_random
 594:	48e9                	li	a7,26
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 59c:	48ed                	li	a7,27
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 5a4:	48f1                	li	a7,28
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <set_sched>:
.global set_sched
set_sched:
 li a7, SYS_set_sched
 5ac:	48f5                	li	a7,29
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <wait_sched>:
.global wait_sched
wait_sched:
 li a7, SYS_wait_sched
 5b4:	48f9                	li	a7,30
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5bc:	1101                	addi	sp,sp,-32
 5be:	ec06                	sd	ra,24(sp)
 5c0:	e822                	sd	s0,16(sp)
 5c2:	1000                	addi	s0,sp,32
 5c4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5c8:	4605                	li	a2,1
 5ca:	fef40593          	addi	a1,s0,-17
 5ce:	f27ff0ef          	jal	4f4 <write>
}
 5d2:	60e2                	ld	ra,24(sp)
 5d4:	6442                	ld	s0,16(sp)
 5d6:	6105                	addi	sp,sp,32
 5d8:	8082                	ret

00000000000005da <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5da:	7139                	addi	sp,sp,-64
 5dc:	fc06                	sd	ra,56(sp)
 5de:	f822                	sd	s0,48(sp)
 5e0:	f426                	sd	s1,40(sp)
 5e2:	0080                	addi	s0,sp,64
 5e4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5e6:	c299                	beqz	a3,5ec <printint+0x12>
 5e8:	0805c963          	bltz	a1,67a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5ec:	2581                	sext.w	a1,a1
  neg = 0;
 5ee:	4881                	li	a7,0
 5f0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5f4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5f6:	2601                	sext.w	a2,a2
 5f8:	00000517          	auipc	a0,0x0
 5fc:	5d050513          	addi	a0,a0,1488 # bc8 <digits>
 600:	883a                	mv	a6,a4
 602:	2705                	addiw	a4,a4,1
 604:	02c5f7bb          	remuw	a5,a1,a2
 608:	1782                	slli	a5,a5,0x20
 60a:	9381                	srli	a5,a5,0x20
 60c:	97aa                	add	a5,a5,a0
 60e:	0007c783          	lbu	a5,0(a5)
 612:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 616:	0005879b          	sext.w	a5,a1
 61a:	02c5d5bb          	divuw	a1,a1,a2
 61e:	0685                	addi	a3,a3,1
 620:	fec7f0e3          	bgeu	a5,a2,600 <printint+0x26>
  if(neg)
 624:	00088c63          	beqz	a7,63c <printint+0x62>
    buf[i++] = '-';
 628:	fd070793          	addi	a5,a4,-48
 62c:	00878733          	add	a4,a5,s0
 630:	02d00793          	li	a5,45
 634:	fef70823          	sb	a5,-16(a4)
 638:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 63c:	02e05a63          	blez	a4,670 <printint+0x96>
 640:	f04a                	sd	s2,32(sp)
 642:	ec4e                	sd	s3,24(sp)
 644:	fc040793          	addi	a5,s0,-64
 648:	00e78933          	add	s2,a5,a4
 64c:	fff78993          	addi	s3,a5,-1
 650:	99ba                	add	s3,s3,a4
 652:	377d                	addiw	a4,a4,-1
 654:	1702                	slli	a4,a4,0x20
 656:	9301                	srli	a4,a4,0x20
 658:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 65c:	fff94583          	lbu	a1,-1(s2)
 660:	8526                	mv	a0,s1
 662:	f5bff0ef          	jal	5bc <putc>
  while(--i >= 0)
 666:	197d                	addi	s2,s2,-1
 668:	ff391ae3          	bne	s2,s3,65c <printint+0x82>
 66c:	7902                	ld	s2,32(sp)
 66e:	69e2                	ld	s3,24(sp)
}
 670:	70e2                	ld	ra,56(sp)
 672:	7442                	ld	s0,48(sp)
 674:	74a2                	ld	s1,40(sp)
 676:	6121                	addi	sp,sp,64
 678:	8082                	ret
    x = -xx;
 67a:	40b005bb          	negw	a1,a1
    neg = 1;
 67e:	4885                	li	a7,1
    x = -xx;
 680:	bf85                	j	5f0 <printint+0x16>

0000000000000682 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 682:	711d                	addi	sp,sp,-96
 684:	ec86                	sd	ra,88(sp)
 686:	e8a2                	sd	s0,80(sp)
 688:	e0ca                	sd	s2,64(sp)
 68a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 68c:	0005c903          	lbu	s2,0(a1)
 690:	26090863          	beqz	s2,900 <vprintf+0x27e>
 694:	e4a6                	sd	s1,72(sp)
 696:	fc4e                	sd	s3,56(sp)
 698:	f852                	sd	s4,48(sp)
 69a:	f456                	sd	s5,40(sp)
 69c:	f05a                	sd	s6,32(sp)
 69e:	ec5e                	sd	s7,24(sp)
 6a0:	e862                	sd	s8,16(sp)
 6a2:	e466                	sd	s9,8(sp)
 6a4:	8b2a                	mv	s6,a0
 6a6:	8a2e                	mv	s4,a1
 6a8:	8bb2                	mv	s7,a2
  state = 0;
 6aa:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6ac:	4481                	li	s1,0
 6ae:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6b0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6b4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6b8:	06c00c93          	li	s9,108
 6bc:	a005                	j	6dc <vprintf+0x5a>
        putc(fd, c0);
 6be:	85ca                	mv	a1,s2
 6c0:	855a                	mv	a0,s6
 6c2:	efbff0ef          	jal	5bc <putc>
 6c6:	a019                	j	6cc <vprintf+0x4a>
    } else if(state == '%'){
 6c8:	03598263          	beq	s3,s5,6ec <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6cc:	2485                	addiw	s1,s1,1
 6ce:	8726                	mv	a4,s1
 6d0:	009a07b3          	add	a5,s4,s1
 6d4:	0007c903          	lbu	s2,0(a5)
 6d8:	20090c63          	beqz	s2,8f0 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 6dc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6e0:	fe0994e3          	bnez	s3,6c8 <vprintf+0x46>
      if(c0 == '%'){
 6e4:	fd579de3          	bne	a5,s5,6be <vprintf+0x3c>
        state = '%';
 6e8:	89be                	mv	s3,a5
 6ea:	b7cd                	j	6cc <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6ec:	00ea06b3          	add	a3,s4,a4
 6f0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6f4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6f6:	c681                	beqz	a3,6fe <vprintf+0x7c>
 6f8:	9752                	add	a4,a4,s4
 6fa:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6fe:	03878f63          	beq	a5,s8,73c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 702:	05978963          	beq	a5,s9,754 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 706:	07500713          	li	a4,117
 70a:	0ee78363          	beq	a5,a4,7f0 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 70e:	07800713          	li	a4,120
 712:	12e78563          	beq	a5,a4,83c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 716:	07000713          	li	a4,112
 71a:	14e78a63          	beq	a5,a4,86e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 71e:	07300713          	li	a4,115
 722:	18e78a63          	beq	a5,a4,8b6 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 726:	02500713          	li	a4,37
 72a:	04e79563          	bne	a5,a4,774 <vprintf+0xf2>
        putc(fd, '%');
 72e:	02500593          	li	a1,37
 732:	855a                	mv	a0,s6
 734:	e89ff0ef          	jal	5bc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 738:	4981                	li	s3,0
 73a:	bf49                	j	6cc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 73c:	008b8913          	addi	s2,s7,8
 740:	4685                	li	a3,1
 742:	4629                	li	a2,10
 744:	000ba583          	lw	a1,0(s7)
 748:	855a                	mv	a0,s6
 74a:	e91ff0ef          	jal	5da <printint>
 74e:	8bca                	mv	s7,s2
      state = 0;
 750:	4981                	li	s3,0
 752:	bfad                	j	6cc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 754:	06400793          	li	a5,100
 758:	02f68963          	beq	a3,a5,78a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 75c:	06c00793          	li	a5,108
 760:	04f68263          	beq	a3,a5,7a4 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 764:	07500793          	li	a5,117
 768:	0af68063          	beq	a3,a5,808 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 76c:	07800793          	li	a5,120
 770:	0ef68263          	beq	a3,a5,854 <vprintf+0x1d2>
        putc(fd, '%');
 774:	02500593          	li	a1,37
 778:	855a                	mv	a0,s6
 77a:	e43ff0ef          	jal	5bc <putc>
        putc(fd, c0);
 77e:	85ca                	mv	a1,s2
 780:	855a                	mv	a0,s6
 782:	e3bff0ef          	jal	5bc <putc>
      state = 0;
 786:	4981                	li	s3,0
 788:	b791                	j	6cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 78a:	008b8913          	addi	s2,s7,8
 78e:	4685                	li	a3,1
 790:	4629                	li	a2,10
 792:	000ba583          	lw	a1,0(s7)
 796:	855a                	mv	a0,s6
 798:	e43ff0ef          	jal	5da <printint>
        i += 1;
 79c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 79e:	8bca                	mv	s7,s2
      state = 0;
 7a0:	4981                	li	s3,0
        i += 1;
 7a2:	b72d                	j	6cc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7a4:	06400793          	li	a5,100
 7a8:	02f60763          	beq	a2,a5,7d6 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7ac:	07500793          	li	a5,117
 7b0:	06f60963          	beq	a2,a5,822 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7b4:	07800793          	li	a5,120
 7b8:	faf61ee3          	bne	a2,a5,774 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7bc:	008b8913          	addi	s2,s7,8
 7c0:	4681                	li	a3,0
 7c2:	4641                	li	a2,16
 7c4:	000ba583          	lw	a1,0(s7)
 7c8:	855a                	mv	a0,s6
 7ca:	e11ff0ef          	jal	5da <printint>
        i += 2;
 7ce:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d0:	8bca                	mv	s7,s2
      state = 0;
 7d2:	4981                	li	s3,0
        i += 2;
 7d4:	bde5                	j	6cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d6:	008b8913          	addi	s2,s7,8
 7da:	4685                	li	a3,1
 7dc:	4629                	li	a2,10
 7de:	000ba583          	lw	a1,0(s7)
 7e2:	855a                	mv	a0,s6
 7e4:	df7ff0ef          	jal	5da <printint>
        i += 2;
 7e8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ea:	8bca                	mv	s7,s2
      state = 0;
 7ec:	4981                	li	s3,0
        i += 2;
 7ee:	bdf9                	j	6cc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7f0:	008b8913          	addi	s2,s7,8
 7f4:	4681                	li	a3,0
 7f6:	4629                	li	a2,10
 7f8:	000ba583          	lw	a1,0(s7)
 7fc:	855a                	mv	a0,s6
 7fe:	dddff0ef          	jal	5da <printint>
 802:	8bca                	mv	s7,s2
      state = 0;
 804:	4981                	li	s3,0
 806:	b5d9                	j	6cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 808:	008b8913          	addi	s2,s7,8
 80c:	4681                	li	a3,0
 80e:	4629                	li	a2,10
 810:	000ba583          	lw	a1,0(s7)
 814:	855a                	mv	a0,s6
 816:	dc5ff0ef          	jal	5da <printint>
        i += 1;
 81a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 81c:	8bca                	mv	s7,s2
      state = 0;
 81e:	4981                	li	s3,0
        i += 1;
 820:	b575                	j	6cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 822:	008b8913          	addi	s2,s7,8
 826:	4681                	li	a3,0
 828:	4629                	li	a2,10
 82a:	000ba583          	lw	a1,0(s7)
 82e:	855a                	mv	a0,s6
 830:	dabff0ef          	jal	5da <printint>
        i += 2;
 834:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 836:	8bca                	mv	s7,s2
      state = 0;
 838:	4981                	li	s3,0
        i += 2;
 83a:	bd49                	j	6cc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 83c:	008b8913          	addi	s2,s7,8
 840:	4681                	li	a3,0
 842:	4641                	li	a2,16
 844:	000ba583          	lw	a1,0(s7)
 848:	855a                	mv	a0,s6
 84a:	d91ff0ef          	jal	5da <printint>
 84e:	8bca                	mv	s7,s2
      state = 0;
 850:	4981                	li	s3,0
 852:	bdad                	j	6cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 854:	008b8913          	addi	s2,s7,8
 858:	4681                	li	a3,0
 85a:	4641                	li	a2,16
 85c:	000ba583          	lw	a1,0(s7)
 860:	855a                	mv	a0,s6
 862:	d79ff0ef          	jal	5da <printint>
        i += 1;
 866:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 868:	8bca                	mv	s7,s2
      state = 0;
 86a:	4981                	li	s3,0
        i += 1;
 86c:	b585                	j	6cc <vprintf+0x4a>
 86e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 870:	008b8d13          	addi	s10,s7,8
 874:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 878:	03000593          	li	a1,48
 87c:	855a                	mv	a0,s6
 87e:	d3fff0ef          	jal	5bc <putc>
  putc(fd, 'x');
 882:	07800593          	li	a1,120
 886:	855a                	mv	a0,s6
 888:	d35ff0ef          	jal	5bc <putc>
 88c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 88e:	00000b97          	auipc	s7,0x0
 892:	33ab8b93          	addi	s7,s7,826 # bc8 <digits>
 896:	03c9d793          	srli	a5,s3,0x3c
 89a:	97de                	add	a5,a5,s7
 89c:	0007c583          	lbu	a1,0(a5)
 8a0:	855a                	mv	a0,s6
 8a2:	d1bff0ef          	jal	5bc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8a6:	0992                	slli	s3,s3,0x4
 8a8:	397d                	addiw	s2,s2,-1
 8aa:	fe0916e3          	bnez	s2,896 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 8ae:	8bea                	mv	s7,s10
      state = 0;
 8b0:	4981                	li	s3,0
 8b2:	6d02                	ld	s10,0(sp)
 8b4:	bd21                	j	6cc <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8b6:	008b8993          	addi	s3,s7,8
 8ba:	000bb903          	ld	s2,0(s7)
 8be:	00090f63          	beqz	s2,8dc <vprintf+0x25a>
        for(; *s; s++)
 8c2:	00094583          	lbu	a1,0(s2)
 8c6:	c195                	beqz	a1,8ea <vprintf+0x268>
          putc(fd, *s);
 8c8:	855a                	mv	a0,s6
 8ca:	cf3ff0ef          	jal	5bc <putc>
        for(; *s; s++)
 8ce:	0905                	addi	s2,s2,1
 8d0:	00094583          	lbu	a1,0(s2)
 8d4:	f9f5                	bnez	a1,8c8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8d6:	8bce                	mv	s7,s3
      state = 0;
 8d8:	4981                	li	s3,0
 8da:	bbcd                	j	6cc <vprintf+0x4a>
          s = "(null)";
 8dc:	00000917          	auipc	s2,0x0
 8e0:	2e490913          	addi	s2,s2,740 # bc0 <malloc+0x1d8>
        for(; *s; s++)
 8e4:	02800593          	li	a1,40
 8e8:	b7c5                	j	8c8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8ea:	8bce                	mv	s7,s3
      state = 0;
 8ec:	4981                	li	s3,0
 8ee:	bbf9                	j	6cc <vprintf+0x4a>
 8f0:	64a6                	ld	s1,72(sp)
 8f2:	79e2                	ld	s3,56(sp)
 8f4:	7a42                	ld	s4,48(sp)
 8f6:	7aa2                	ld	s5,40(sp)
 8f8:	7b02                	ld	s6,32(sp)
 8fa:	6be2                	ld	s7,24(sp)
 8fc:	6c42                	ld	s8,16(sp)
 8fe:	6ca2                	ld	s9,8(sp)
    }
  }
}
 900:	60e6                	ld	ra,88(sp)
 902:	6446                	ld	s0,80(sp)
 904:	6906                	ld	s2,64(sp)
 906:	6125                	addi	sp,sp,96
 908:	8082                	ret

000000000000090a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 90a:	715d                	addi	sp,sp,-80
 90c:	ec06                	sd	ra,24(sp)
 90e:	e822                	sd	s0,16(sp)
 910:	1000                	addi	s0,sp,32
 912:	e010                	sd	a2,0(s0)
 914:	e414                	sd	a3,8(s0)
 916:	e818                	sd	a4,16(s0)
 918:	ec1c                	sd	a5,24(s0)
 91a:	03043023          	sd	a6,32(s0)
 91e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 922:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 926:	8622                	mv	a2,s0
 928:	d5bff0ef          	jal	682 <vprintf>
}
 92c:	60e2                	ld	ra,24(sp)
 92e:	6442                	ld	s0,16(sp)
 930:	6161                	addi	sp,sp,80
 932:	8082                	ret

0000000000000934 <printf>:

void
printf(const char *fmt, ...)
{
 934:	711d                	addi	sp,sp,-96
 936:	ec06                	sd	ra,24(sp)
 938:	e822                	sd	s0,16(sp)
 93a:	1000                	addi	s0,sp,32
 93c:	e40c                	sd	a1,8(s0)
 93e:	e810                	sd	a2,16(s0)
 940:	ec14                	sd	a3,24(s0)
 942:	f018                	sd	a4,32(s0)
 944:	f41c                	sd	a5,40(s0)
 946:	03043823          	sd	a6,48(s0)
 94a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 94e:	00840613          	addi	a2,s0,8
 952:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 956:	85aa                	mv	a1,a0
 958:	4505                	li	a0,1
 95a:	d29ff0ef          	jal	682 <vprintf>
}
 95e:	60e2                	ld	ra,24(sp)
 960:	6442                	ld	s0,16(sp)
 962:	6125                	addi	sp,sp,96
 964:	8082                	ret

0000000000000966 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 966:	1141                	addi	sp,sp,-16
 968:	e422                	sd	s0,8(sp)
 96a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 96c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 970:	00001797          	auipc	a5,0x1
 974:	6907b783          	ld	a5,1680(a5) # 2000 <freep>
 978:	a02d                	j	9a2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 97a:	4618                	lw	a4,8(a2)
 97c:	9f2d                	addw	a4,a4,a1
 97e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 982:	6398                	ld	a4,0(a5)
 984:	6310                	ld	a2,0(a4)
 986:	a83d                	j	9c4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 988:	ff852703          	lw	a4,-8(a0)
 98c:	9f31                	addw	a4,a4,a2
 98e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 990:	ff053683          	ld	a3,-16(a0)
 994:	a091                	j	9d8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 996:	6398                	ld	a4,0(a5)
 998:	00e7e463          	bltu	a5,a4,9a0 <free+0x3a>
 99c:	00e6ea63          	bltu	a3,a4,9b0 <free+0x4a>
{
 9a0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a2:	fed7fae3          	bgeu	a5,a3,996 <free+0x30>
 9a6:	6398                	ld	a4,0(a5)
 9a8:	00e6e463          	bltu	a3,a4,9b0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ac:	fee7eae3          	bltu	a5,a4,9a0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9b0:	ff852583          	lw	a1,-8(a0)
 9b4:	6390                	ld	a2,0(a5)
 9b6:	02059813          	slli	a6,a1,0x20
 9ba:	01c85713          	srli	a4,a6,0x1c
 9be:	9736                	add	a4,a4,a3
 9c0:	fae60de3          	beq	a2,a4,97a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9c4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9c8:	4790                	lw	a2,8(a5)
 9ca:	02061593          	slli	a1,a2,0x20
 9ce:	01c5d713          	srli	a4,a1,0x1c
 9d2:	973e                	add	a4,a4,a5
 9d4:	fae68ae3          	beq	a3,a4,988 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9d8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9da:	00001717          	auipc	a4,0x1
 9de:	62f73323          	sd	a5,1574(a4) # 2000 <freep>
}
 9e2:	6422                	ld	s0,8(sp)
 9e4:	0141                	addi	sp,sp,16
 9e6:	8082                	ret

00000000000009e8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9e8:	7139                	addi	sp,sp,-64
 9ea:	fc06                	sd	ra,56(sp)
 9ec:	f822                	sd	s0,48(sp)
 9ee:	f426                	sd	s1,40(sp)
 9f0:	ec4e                	sd	s3,24(sp)
 9f2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f4:	02051493          	slli	s1,a0,0x20
 9f8:	9081                	srli	s1,s1,0x20
 9fa:	04bd                	addi	s1,s1,15
 9fc:	8091                	srli	s1,s1,0x4
 9fe:	0014899b          	addiw	s3,s1,1
 a02:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a04:	00001517          	auipc	a0,0x1
 a08:	5fc53503          	ld	a0,1532(a0) # 2000 <freep>
 a0c:	c915                	beqz	a0,a40 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a10:	4798                	lw	a4,8(a5)
 a12:	08977a63          	bgeu	a4,s1,aa6 <malloc+0xbe>
 a16:	f04a                	sd	s2,32(sp)
 a18:	e852                	sd	s4,16(sp)
 a1a:	e456                	sd	s5,8(sp)
 a1c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a1e:	8a4e                	mv	s4,s3
 a20:	0009871b          	sext.w	a4,s3
 a24:	6685                	lui	a3,0x1
 a26:	00d77363          	bgeu	a4,a3,a2c <malloc+0x44>
 a2a:	6a05                	lui	s4,0x1
 a2c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a30:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a34:	00001917          	auipc	s2,0x1
 a38:	5cc90913          	addi	s2,s2,1484 # 2000 <freep>
  if(p == (char*)-1)
 a3c:	5afd                	li	s5,-1
 a3e:	a081                	j	a7e <malloc+0x96>
 a40:	f04a                	sd	s2,32(sp)
 a42:	e852                	sd	s4,16(sp)
 a44:	e456                	sd	s5,8(sp)
 a46:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a48:	00001797          	auipc	a5,0x1
 a4c:	5c878793          	addi	a5,a5,1480 # 2010 <base>
 a50:	00001717          	auipc	a4,0x1
 a54:	5af73823          	sd	a5,1456(a4) # 2000 <freep>
 a58:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a5a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a5e:	b7c1                	j	a1e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a60:	6398                	ld	a4,0(a5)
 a62:	e118                	sd	a4,0(a0)
 a64:	a8a9                	j	abe <malloc+0xd6>
  hp->s.size = nu;
 a66:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a6a:	0541                	addi	a0,a0,16
 a6c:	efbff0ef          	jal	966 <free>
  return freep;
 a70:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a74:	c12d                	beqz	a0,ad6 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a76:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a78:	4798                	lw	a4,8(a5)
 a7a:	02977263          	bgeu	a4,s1,a9e <malloc+0xb6>
    if(p == freep)
 a7e:	00093703          	ld	a4,0(s2)
 a82:	853e                	mv	a0,a5
 a84:	fef719e3          	bne	a4,a5,a76 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a88:	8552                	mv	a0,s4
 a8a:	ad3ff0ef          	jal	55c <sbrk>
  if(p == (char*)-1)
 a8e:	fd551ce3          	bne	a0,s5,a66 <malloc+0x7e>
        return 0;
 a92:	4501                	li	a0,0
 a94:	7902                	ld	s2,32(sp)
 a96:	6a42                	ld	s4,16(sp)
 a98:	6aa2                	ld	s5,8(sp)
 a9a:	6b02                	ld	s6,0(sp)
 a9c:	a03d                	j	aca <malloc+0xe2>
 a9e:	7902                	ld	s2,32(sp)
 aa0:	6a42                	ld	s4,16(sp)
 aa2:	6aa2                	ld	s5,8(sp)
 aa4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 aa6:	fae48de3          	beq	s1,a4,a60 <malloc+0x78>
        p->s.size -= nunits;
 aaa:	4137073b          	subw	a4,a4,s3
 aae:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ab0:	02071693          	slli	a3,a4,0x20
 ab4:	01c6d713          	srli	a4,a3,0x1c
 ab8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aba:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 abe:	00001717          	auipc	a4,0x1
 ac2:	54a73123          	sd	a0,1346(a4) # 2000 <freep>
      return (void*)(p + 1);
 ac6:	01078513          	addi	a0,a5,16
  }
}
 aca:	70e2                	ld	ra,56(sp)
 acc:	7442                	ld	s0,48(sp)
 ace:	74a2                	ld	s1,40(sp)
 ad0:	69e2                	ld	s3,24(sp)
 ad2:	6121                	addi	sp,sp,64
 ad4:	8082                	ret
 ad6:	7902                	ld	s2,32(sp)
 ad8:	6a42                	ld	s4,16(sp)
 ada:	6aa2                	ld	s5,8(sp)
 adc:	6b02                	ld	s6,0(sp)
 ade:	b7f5                	j	aca <malloc+0xe2>
