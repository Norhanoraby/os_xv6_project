
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

    // Remove trailing newline
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
  e6:	a1650513          	addi	a0,a0,-1514 # af8 <malloc+0x128>
  ea:	033000ef          	jal	91c <printf>
        exit(1);
  ee:	4505                	li	a0,1
  f0:	3e4000ef          	jal	4d4 <exit>
    if(argc == 2 && strcmp(argv[1], "?") == 0){
  f4:	00001597          	auipc	a1,0x1
  f8:	9dc58593          	addi	a1,a1,-1572 # ad0 <malloc+0x100>
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
 12e:	9ae50513          	addi	a0,a0,-1618 # ad8 <malloc+0x108>
 132:	7ea000ef          	jal	91c <printf>
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
 18c:	9f0c8c93          	addi	s9,s9,-1552 # b78 <malloc+0x1a8>
            diff=1;
 190:	4c05                	li	s8,1
            printf("Line %d only in %s:\n< %s\n", line, argv[1], b1);
 192:	00001d17          	auipc	s10,0x1
 196:	9a6d0d13          	addi	s10,s10,-1626 # b38 <malloc+0x168>
 19a:	a091                	j	1de <main+0x142>
        printf("Error: cannot open files\n");
 19c:	00001517          	auipc	a0,0x1
 1a0:	97c50513          	addi	a0,a0,-1668 # b18 <malloc+0x148>
 1a4:	778000ef          	jal	91c <printf>
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
 1c2:	99a50513          	addi	a0,a0,-1638 # b58 <malloc+0x188>
 1c6:	756000ef          	jal	91c <printf>
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
 22a:	6f2000ef          	jal	91c <printf>
            diff=1;
 22e:	8be2                	mv	s7,s8
            printf("Line %d only in %s:\n< %s\n", line, argv[1], b1);
 230:	b775                	j	1dc <main+0x140>
            printf("Line %d differs:\n< %s\n> %s\n", line, b1, b2);
 232:	ba040693          	addi	a3,s0,-1120
 236:	da040613          	addi	a2,s0,-608
 23a:	85d2                	mv	a1,s4
 23c:	8566                	mv	a0,s9
 23e:	6de000ef          	jal	91c <printf>
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
 260:	93c50513          	addi	a0,a0,-1732 # b98 <malloc+0x1c8>
 264:	6b8000ef          	jal	91c <printf>
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

000000000000059c <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 59c:	48ed                	li	a7,27
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5a4:	1101                	addi	sp,sp,-32
 5a6:	ec06                	sd	ra,24(sp)
 5a8:	e822                	sd	s0,16(sp)
 5aa:	1000                	addi	s0,sp,32
 5ac:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5b0:	4605                	li	a2,1
 5b2:	fef40593          	addi	a1,s0,-17
 5b6:	f3fff0ef          	jal	4f4 <write>
}
 5ba:	60e2                	ld	ra,24(sp)
 5bc:	6442                	ld	s0,16(sp)
 5be:	6105                	addi	sp,sp,32
 5c0:	8082                	ret

00000000000005c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5c2:	7139                	addi	sp,sp,-64
 5c4:	fc06                	sd	ra,56(sp)
 5c6:	f822                	sd	s0,48(sp)
 5c8:	f426                	sd	s1,40(sp)
 5ca:	0080                	addi	s0,sp,64
 5cc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5ce:	c299                	beqz	a3,5d4 <printint+0x12>
 5d0:	0805c963          	bltz	a1,662 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5d4:	2581                	sext.w	a1,a1
  neg = 0;
 5d6:	4881                	li	a7,0
 5d8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5dc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5de:	2601                	sext.w	a2,a2
 5e0:	00000517          	auipc	a0,0x0
 5e4:	5d850513          	addi	a0,a0,1496 # bb8 <digits>
 5e8:	883a                	mv	a6,a4
 5ea:	2705                	addiw	a4,a4,1
 5ec:	02c5f7bb          	remuw	a5,a1,a2
 5f0:	1782                	slli	a5,a5,0x20
 5f2:	9381                	srli	a5,a5,0x20
 5f4:	97aa                	add	a5,a5,a0
 5f6:	0007c783          	lbu	a5,0(a5)
 5fa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5fe:	0005879b          	sext.w	a5,a1
 602:	02c5d5bb          	divuw	a1,a1,a2
 606:	0685                	addi	a3,a3,1
 608:	fec7f0e3          	bgeu	a5,a2,5e8 <printint+0x26>
  if(neg)
 60c:	00088c63          	beqz	a7,624 <printint+0x62>
    buf[i++] = '-';
 610:	fd070793          	addi	a5,a4,-48
 614:	00878733          	add	a4,a5,s0
 618:	02d00793          	li	a5,45
 61c:	fef70823          	sb	a5,-16(a4)
 620:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 624:	02e05a63          	blez	a4,658 <printint+0x96>
 628:	f04a                	sd	s2,32(sp)
 62a:	ec4e                	sd	s3,24(sp)
 62c:	fc040793          	addi	a5,s0,-64
 630:	00e78933          	add	s2,a5,a4
 634:	fff78993          	addi	s3,a5,-1
 638:	99ba                	add	s3,s3,a4
 63a:	377d                	addiw	a4,a4,-1
 63c:	1702                	slli	a4,a4,0x20
 63e:	9301                	srli	a4,a4,0x20
 640:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 644:	fff94583          	lbu	a1,-1(s2)
 648:	8526                	mv	a0,s1
 64a:	f5bff0ef          	jal	5a4 <putc>
  while(--i >= 0)
 64e:	197d                	addi	s2,s2,-1
 650:	ff391ae3          	bne	s2,s3,644 <printint+0x82>
 654:	7902                	ld	s2,32(sp)
 656:	69e2                	ld	s3,24(sp)
}
 658:	70e2                	ld	ra,56(sp)
 65a:	7442                	ld	s0,48(sp)
 65c:	74a2                	ld	s1,40(sp)
 65e:	6121                	addi	sp,sp,64
 660:	8082                	ret
    x = -xx;
 662:	40b005bb          	negw	a1,a1
    neg = 1;
 666:	4885                	li	a7,1
    x = -xx;
 668:	bf85                	j	5d8 <printint+0x16>

000000000000066a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 66a:	711d                	addi	sp,sp,-96
 66c:	ec86                	sd	ra,88(sp)
 66e:	e8a2                	sd	s0,80(sp)
 670:	e0ca                	sd	s2,64(sp)
 672:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 674:	0005c903          	lbu	s2,0(a1)
 678:	26090863          	beqz	s2,8e8 <vprintf+0x27e>
 67c:	e4a6                	sd	s1,72(sp)
 67e:	fc4e                	sd	s3,56(sp)
 680:	f852                	sd	s4,48(sp)
 682:	f456                	sd	s5,40(sp)
 684:	f05a                	sd	s6,32(sp)
 686:	ec5e                	sd	s7,24(sp)
 688:	e862                	sd	s8,16(sp)
 68a:	e466                	sd	s9,8(sp)
 68c:	8b2a                	mv	s6,a0
 68e:	8a2e                	mv	s4,a1
 690:	8bb2                	mv	s7,a2
  state = 0;
 692:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 694:	4481                	li	s1,0
 696:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 698:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 69c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6a0:	06c00c93          	li	s9,108
 6a4:	a005                	j	6c4 <vprintf+0x5a>
        putc(fd, c0);
 6a6:	85ca                	mv	a1,s2
 6a8:	855a                	mv	a0,s6
 6aa:	efbff0ef          	jal	5a4 <putc>
 6ae:	a019                	j	6b4 <vprintf+0x4a>
    } else if(state == '%'){
 6b0:	03598263          	beq	s3,s5,6d4 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6b4:	2485                	addiw	s1,s1,1
 6b6:	8726                	mv	a4,s1
 6b8:	009a07b3          	add	a5,s4,s1
 6bc:	0007c903          	lbu	s2,0(a5)
 6c0:	20090c63          	beqz	s2,8d8 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 6c4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6c8:	fe0994e3          	bnez	s3,6b0 <vprintf+0x46>
      if(c0 == '%'){
 6cc:	fd579de3          	bne	a5,s5,6a6 <vprintf+0x3c>
        state = '%';
 6d0:	89be                	mv	s3,a5
 6d2:	b7cd                	j	6b4 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6d4:	00ea06b3          	add	a3,s4,a4
 6d8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6dc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6de:	c681                	beqz	a3,6e6 <vprintf+0x7c>
 6e0:	9752                	add	a4,a4,s4
 6e2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6e6:	03878f63          	beq	a5,s8,724 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6ea:	05978963          	beq	a5,s9,73c <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6ee:	07500713          	li	a4,117
 6f2:	0ee78363          	beq	a5,a4,7d8 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6f6:	07800713          	li	a4,120
 6fa:	12e78563          	beq	a5,a4,824 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6fe:	07000713          	li	a4,112
 702:	14e78a63          	beq	a5,a4,856 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 706:	07300713          	li	a4,115
 70a:	18e78a63          	beq	a5,a4,89e <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 70e:	02500713          	li	a4,37
 712:	04e79563          	bne	a5,a4,75c <vprintf+0xf2>
        putc(fd, '%');
 716:	02500593          	li	a1,37
 71a:	855a                	mv	a0,s6
 71c:	e89ff0ef          	jal	5a4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 720:	4981                	li	s3,0
 722:	bf49                	j	6b4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 724:	008b8913          	addi	s2,s7,8
 728:	4685                	li	a3,1
 72a:	4629                	li	a2,10
 72c:	000ba583          	lw	a1,0(s7)
 730:	855a                	mv	a0,s6
 732:	e91ff0ef          	jal	5c2 <printint>
 736:	8bca                	mv	s7,s2
      state = 0;
 738:	4981                	li	s3,0
 73a:	bfad                	j	6b4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 73c:	06400793          	li	a5,100
 740:	02f68963          	beq	a3,a5,772 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 744:	06c00793          	li	a5,108
 748:	04f68263          	beq	a3,a5,78c <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 74c:	07500793          	li	a5,117
 750:	0af68063          	beq	a3,a5,7f0 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 754:	07800793          	li	a5,120
 758:	0ef68263          	beq	a3,a5,83c <vprintf+0x1d2>
        putc(fd, '%');
 75c:	02500593          	li	a1,37
 760:	855a                	mv	a0,s6
 762:	e43ff0ef          	jal	5a4 <putc>
        putc(fd, c0);
 766:	85ca                	mv	a1,s2
 768:	855a                	mv	a0,s6
 76a:	e3bff0ef          	jal	5a4 <putc>
      state = 0;
 76e:	4981                	li	s3,0
 770:	b791                	j	6b4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 772:	008b8913          	addi	s2,s7,8
 776:	4685                	li	a3,1
 778:	4629                	li	a2,10
 77a:	000ba583          	lw	a1,0(s7)
 77e:	855a                	mv	a0,s6
 780:	e43ff0ef          	jal	5c2 <printint>
        i += 1;
 784:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 786:	8bca                	mv	s7,s2
      state = 0;
 788:	4981                	li	s3,0
        i += 1;
 78a:	b72d                	j	6b4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 78c:	06400793          	li	a5,100
 790:	02f60763          	beq	a2,a5,7be <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 794:	07500793          	li	a5,117
 798:	06f60963          	beq	a2,a5,80a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 79c:	07800793          	li	a5,120
 7a0:	faf61ee3          	bne	a2,a5,75c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a4:	008b8913          	addi	s2,s7,8
 7a8:	4681                	li	a3,0
 7aa:	4641                	li	a2,16
 7ac:	000ba583          	lw	a1,0(s7)
 7b0:	855a                	mv	a0,s6
 7b2:	e11ff0ef          	jal	5c2 <printint>
        i += 2;
 7b6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b8:	8bca                	mv	s7,s2
      state = 0;
 7ba:	4981                	li	s3,0
        i += 2;
 7bc:	bde5                	j	6b4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7be:	008b8913          	addi	s2,s7,8
 7c2:	4685                	li	a3,1
 7c4:	4629                	li	a2,10
 7c6:	000ba583          	lw	a1,0(s7)
 7ca:	855a                	mv	a0,s6
 7cc:	df7ff0ef          	jal	5c2 <printint>
        i += 2;
 7d0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d2:	8bca                	mv	s7,s2
      state = 0;
 7d4:	4981                	li	s3,0
        i += 2;
 7d6:	bdf9                	j	6b4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7d8:	008b8913          	addi	s2,s7,8
 7dc:	4681                	li	a3,0
 7de:	4629                	li	a2,10
 7e0:	000ba583          	lw	a1,0(s7)
 7e4:	855a                	mv	a0,s6
 7e6:	dddff0ef          	jal	5c2 <printint>
 7ea:	8bca                	mv	s7,s2
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	b5d9                	j	6b4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f0:	008b8913          	addi	s2,s7,8
 7f4:	4681                	li	a3,0
 7f6:	4629                	li	a2,10
 7f8:	000ba583          	lw	a1,0(s7)
 7fc:	855a                	mv	a0,s6
 7fe:	dc5ff0ef          	jal	5c2 <printint>
        i += 1;
 802:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 804:	8bca                	mv	s7,s2
      state = 0;
 806:	4981                	li	s3,0
        i += 1;
 808:	b575                	j	6b4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 80a:	008b8913          	addi	s2,s7,8
 80e:	4681                	li	a3,0
 810:	4629                	li	a2,10
 812:	000ba583          	lw	a1,0(s7)
 816:	855a                	mv	a0,s6
 818:	dabff0ef          	jal	5c2 <printint>
        i += 2;
 81c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 81e:	8bca                	mv	s7,s2
      state = 0;
 820:	4981                	li	s3,0
        i += 2;
 822:	bd49                	j	6b4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 824:	008b8913          	addi	s2,s7,8
 828:	4681                	li	a3,0
 82a:	4641                	li	a2,16
 82c:	000ba583          	lw	a1,0(s7)
 830:	855a                	mv	a0,s6
 832:	d91ff0ef          	jal	5c2 <printint>
 836:	8bca                	mv	s7,s2
      state = 0;
 838:	4981                	li	s3,0
 83a:	bdad                	j	6b4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 83c:	008b8913          	addi	s2,s7,8
 840:	4681                	li	a3,0
 842:	4641                	li	a2,16
 844:	000ba583          	lw	a1,0(s7)
 848:	855a                	mv	a0,s6
 84a:	d79ff0ef          	jal	5c2 <printint>
        i += 1;
 84e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 850:	8bca                	mv	s7,s2
      state = 0;
 852:	4981                	li	s3,0
        i += 1;
 854:	b585                	j	6b4 <vprintf+0x4a>
 856:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 858:	008b8d13          	addi	s10,s7,8
 85c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 860:	03000593          	li	a1,48
 864:	855a                	mv	a0,s6
 866:	d3fff0ef          	jal	5a4 <putc>
  putc(fd, 'x');
 86a:	07800593          	li	a1,120
 86e:	855a                	mv	a0,s6
 870:	d35ff0ef          	jal	5a4 <putc>
 874:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 876:	00000b97          	auipc	s7,0x0
 87a:	342b8b93          	addi	s7,s7,834 # bb8 <digits>
 87e:	03c9d793          	srli	a5,s3,0x3c
 882:	97de                	add	a5,a5,s7
 884:	0007c583          	lbu	a1,0(a5)
 888:	855a                	mv	a0,s6
 88a:	d1bff0ef          	jal	5a4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 88e:	0992                	slli	s3,s3,0x4
 890:	397d                	addiw	s2,s2,-1
 892:	fe0916e3          	bnez	s2,87e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 896:	8bea                	mv	s7,s10
      state = 0;
 898:	4981                	li	s3,0
 89a:	6d02                	ld	s10,0(sp)
 89c:	bd21                	j	6b4 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 89e:	008b8993          	addi	s3,s7,8
 8a2:	000bb903          	ld	s2,0(s7)
 8a6:	00090f63          	beqz	s2,8c4 <vprintf+0x25a>
        for(; *s; s++)
 8aa:	00094583          	lbu	a1,0(s2)
 8ae:	c195                	beqz	a1,8d2 <vprintf+0x268>
          putc(fd, *s);
 8b0:	855a                	mv	a0,s6
 8b2:	cf3ff0ef          	jal	5a4 <putc>
        for(; *s; s++)
 8b6:	0905                	addi	s2,s2,1
 8b8:	00094583          	lbu	a1,0(s2)
 8bc:	f9f5                	bnez	a1,8b0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8be:	8bce                	mv	s7,s3
      state = 0;
 8c0:	4981                	li	s3,0
 8c2:	bbcd                	j	6b4 <vprintf+0x4a>
          s = "(null)";
 8c4:	00000917          	auipc	s2,0x0
 8c8:	2ec90913          	addi	s2,s2,748 # bb0 <malloc+0x1e0>
        for(; *s; s++)
 8cc:	02800593          	li	a1,40
 8d0:	b7c5                	j	8b0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8d2:	8bce                	mv	s7,s3
      state = 0;
 8d4:	4981                	li	s3,0
 8d6:	bbf9                	j	6b4 <vprintf+0x4a>
 8d8:	64a6                	ld	s1,72(sp)
 8da:	79e2                	ld	s3,56(sp)
 8dc:	7a42                	ld	s4,48(sp)
 8de:	7aa2                	ld	s5,40(sp)
 8e0:	7b02                	ld	s6,32(sp)
 8e2:	6be2                	ld	s7,24(sp)
 8e4:	6c42                	ld	s8,16(sp)
 8e6:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8e8:	60e6                	ld	ra,88(sp)
 8ea:	6446                	ld	s0,80(sp)
 8ec:	6906                	ld	s2,64(sp)
 8ee:	6125                	addi	sp,sp,96
 8f0:	8082                	ret

00000000000008f2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8f2:	715d                	addi	sp,sp,-80
 8f4:	ec06                	sd	ra,24(sp)
 8f6:	e822                	sd	s0,16(sp)
 8f8:	1000                	addi	s0,sp,32
 8fa:	e010                	sd	a2,0(s0)
 8fc:	e414                	sd	a3,8(s0)
 8fe:	e818                	sd	a4,16(s0)
 900:	ec1c                	sd	a5,24(s0)
 902:	03043023          	sd	a6,32(s0)
 906:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 90a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 90e:	8622                	mv	a2,s0
 910:	d5bff0ef          	jal	66a <vprintf>
}
 914:	60e2                	ld	ra,24(sp)
 916:	6442                	ld	s0,16(sp)
 918:	6161                	addi	sp,sp,80
 91a:	8082                	ret

000000000000091c <printf>:

void
printf(const char *fmt, ...)
{
 91c:	711d                	addi	sp,sp,-96
 91e:	ec06                	sd	ra,24(sp)
 920:	e822                	sd	s0,16(sp)
 922:	1000                	addi	s0,sp,32
 924:	e40c                	sd	a1,8(s0)
 926:	e810                	sd	a2,16(s0)
 928:	ec14                	sd	a3,24(s0)
 92a:	f018                	sd	a4,32(s0)
 92c:	f41c                	sd	a5,40(s0)
 92e:	03043823          	sd	a6,48(s0)
 932:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 936:	00840613          	addi	a2,s0,8
 93a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 93e:	85aa                	mv	a1,a0
 940:	4505                	li	a0,1
 942:	d29ff0ef          	jal	66a <vprintf>
}
 946:	60e2                	ld	ra,24(sp)
 948:	6442                	ld	s0,16(sp)
 94a:	6125                	addi	sp,sp,96
 94c:	8082                	ret

000000000000094e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 94e:	1141                	addi	sp,sp,-16
 950:	e422                	sd	s0,8(sp)
 952:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 954:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 958:	00001797          	auipc	a5,0x1
 95c:	6a87b783          	ld	a5,1704(a5) # 2000 <freep>
 960:	a02d                	j	98a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 962:	4618                	lw	a4,8(a2)
 964:	9f2d                	addw	a4,a4,a1
 966:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 96a:	6398                	ld	a4,0(a5)
 96c:	6310                	ld	a2,0(a4)
 96e:	a83d                	j	9ac <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 970:	ff852703          	lw	a4,-8(a0)
 974:	9f31                	addw	a4,a4,a2
 976:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 978:	ff053683          	ld	a3,-16(a0)
 97c:	a091                	j	9c0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 97e:	6398                	ld	a4,0(a5)
 980:	00e7e463          	bltu	a5,a4,988 <free+0x3a>
 984:	00e6ea63          	bltu	a3,a4,998 <free+0x4a>
{
 988:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 98a:	fed7fae3          	bgeu	a5,a3,97e <free+0x30>
 98e:	6398                	ld	a4,0(a5)
 990:	00e6e463          	bltu	a3,a4,998 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 994:	fee7eae3          	bltu	a5,a4,988 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 998:	ff852583          	lw	a1,-8(a0)
 99c:	6390                	ld	a2,0(a5)
 99e:	02059813          	slli	a6,a1,0x20
 9a2:	01c85713          	srli	a4,a6,0x1c
 9a6:	9736                	add	a4,a4,a3
 9a8:	fae60de3          	beq	a2,a4,962 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9ac:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9b0:	4790                	lw	a2,8(a5)
 9b2:	02061593          	slli	a1,a2,0x20
 9b6:	01c5d713          	srli	a4,a1,0x1c
 9ba:	973e                	add	a4,a4,a5
 9bc:	fae68ae3          	beq	a3,a4,970 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9c0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9c2:	00001717          	auipc	a4,0x1
 9c6:	62f73f23          	sd	a5,1598(a4) # 2000 <freep>
}
 9ca:	6422                	ld	s0,8(sp)
 9cc:	0141                	addi	sp,sp,16
 9ce:	8082                	ret

00000000000009d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9d0:	7139                	addi	sp,sp,-64
 9d2:	fc06                	sd	ra,56(sp)
 9d4:	f822                	sd	s0,48(sp)
 9d6:	f426                	sd	s1,40(sp)
 9d8:	ec4e                	sd	s3,24(sp)
 9da:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9dc:	02051493          	slli	s1,a0,0x20
 9e0:	9081                	srli	s1,s1,0x20
 9e2:	04bd                	addi	s1,s1,15
 9e4:	8091                	srli	s1,s1,0x4
 9e6:	0014899b          	addiw	s3,s1,1
 9ea:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9ec:	00001517          	auipc	a0,0x1
 9f0:	61453503          	ld	a0,1556(a0) # 2000 <freep>
 9f4:	c915                	beqz	a0,a28 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f8:	4798                	lw	a4,8(a5)
 9fa:	08977a63          	bgeu	a4,s1,a8e <malloc+0xbe>
 9fe:	f04a                	sd	s2,32(sp)
 a00:	e852                	sd	s4,16(sp)
 a02:	e456                	sd	s5,8(sp)
 a04:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a06:	8a4e                	mv	s4,s3
 a08:	0009871b          	sext.w	a4,s3
 a0c:	6685                	lui	a3,0x1
 a0e:	00d77363          	bgeu	a4,a3,a14 <malloc+0x44>
 a12:	6a05                	lui	s4,0x1
 a14:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a18:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a1c:	00001917          	auipc	s2,0x1
 a20:	5e490913          	addi	s2,s2,1508 # 2000 <freep>
  if(p == (char*)-1)
 a24:	5afd                	li	s5,-1
 a26:	a081                	j	a66 <malloc+0x96>
 a28:	f04a                	sd	s2,32(sp)
 a2a:	e852                	sd	s4,16(sp)
 a2c:	e456                	sd	s5,8(sp)
 a2e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a30:	00001797          	auipc	a5,0x1
 a34:	5e078793          	addi	a5,a5,1504 # 2010 <base>
 a38:	00001717          	auipc	a4,0x1
 a3c:	5cf73423          	sd	a5,1480(a4) # 2000 <freep>
 a40:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a42:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a46:	b7c1                	j	a06 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a48:	6398                	ld	a4,0(a5)
 a4a:	e118                	sd	a4,0(a0)
 a4c:	a8a9                	j	aa6 <malloc+0xd6>
  hp->s.size = nu;
 a4e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a52:	0541                	addi	a0,a0,16
 a54:	efbff0ef          	jal	94e <free>
  return freep;
 a58:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a5c:	c12d                	beqz	a0,abe <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a5e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a60:	4798                	lw	a4,8(a5)
 a62:	02977263          	bgeu	a4,s1,a86 <malloc+0xb6>
    if(p == freep)
 a66:	00093703          	ld	a4,0(s2)
 a6a:	853e                	mv	a0,a5
 a6c:	fef719e3          	bne	a4,a5,a5e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a70:	8552                	mv	a0,s4
 a72:	aebff0ef          	jal	55c <sbrk>
  if(p == (char*)-1)
 a76:	fd551ce3          	bne	a0,s5,a4e <malloc+0x7e>
        return 0;
 a7a:	4501                	li	a0,0
 a7c:	7902                	ld	s2,32(sp)
 a7e:	6a42                	ld	s4,16(sp)
 a80:	6aa2                	ld	s5,8(sp)
 a82:	6b02                	ld	s6,0(sp)
 a84:	a03d                	j	ab2 <malloc+0xe2>
 a86:	7902                	ld	s2,32(sp)
 a88:	6a42                	ld	s4,16(sp)
 a8a:	6aa2                	ld	s5,8(sp)
 a8c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a8e:	fae48de3          	beq	s1,a4,a48 <malloc+0x78>
        p->s.size -= nunits;
 a92:	4137073b          	subw	a4,a4,s3
 a96:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a98:	02071693          	slli	a3,a4,0x20
 a9c:	01c6d713          	srli	a4,a3,0x1c
 aa0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aa2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aa6:	00001717          	auipc	a4,0x1
 aaa:	54a73d23          	sd	a0,1370(a4) # 2000 <freep>
      return (void*)(p + 1);
 aae:	01078513          	addi	a0,a5,16
  }
}
 ab2:	70e2                	ld	ra,56(sp)
 ab4:	7442                	ld	s0,48(sp)
 ab6:	74a2                	ld	s1,40(sp)
 ab8:	69e2                	ld	s3,24(sp)
 aba:	6121                	addi	sp,sp,64
 abc:	8082                	ret
 abe:	7902                	ld	s2,32(sp)
 ac0:	6a42                	ld	s4,16(sp)
 ac2:	6aa2                	ld	s5,8(sp)
 ac4:	6b02                	ld	s6,0(sp)
 ac6:	b7f5                	j	ab2 <malloc+0xe2>
