
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
  2e:	4d8000ef          	jal	506 <read>
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
  70:	26e000ef          	jal	2de <strlen>
  74:	0005079b          	sext.w	a5,a0

    // Remove trailing newline
    if(len > 0 && buf[len-1] == '\n'){
  78:	02f05a63          	blez	a5,ac <strip_newlines+0x48>
  7c:	fff78713          	addi	a4,a5,-1
  80:	9726                	add	a4,a4,s1
  82:	00074603          	lbu	a2,0(a4)
  86:	46a9                	li	a3,10
  88:	00d60d63          	beq	a2,a3,a2 <strip_newlines+0x3e>
        buf[len-1] = 0;
        len--;
    }

    // Remove trailing carriage return
    if(len > 0 && buf[len-1] == '\r'){
  8c:	17fd                	addi	a5,a5,-1
  8e:	00f48533          	add	a0,s1,a5
  92:	00054703          	lbu	a4,0(a0)
  96:	47b5                	li	a5,13
  98:	00f71a63          	bne	a4,a5,ac <strip_newlines+0x48>
        buf[len-1] = 0;
  9c:	00050023          	sb	zero,0(a0)
        len--;
    }
}
  a0:	a031                	j	ac <strip_newlines+0x48>
        buf[len-1] = 0;
  a2:	00070023          	sb	zero,0(a4)
        len--;
  a6:	37fd                	addiw	a5,a5,-1
    if(len > 0 && buf[len-1] == '\r'){
  a8:	fef042e3          	bgtz	a5,8c <strip_newlines+0x28>
}
  ac:	60e2                	ld	ra,24(sp)
  ae:	6442                	ld	s0,16(sp)
  b0:	64a2                	ld	s1,8(sp)
  b2:	6105                	addi	sp,sp,32
  b4:	8082                	ret

00000000000000b6 <main>:

int main(int argc, char *argv[])
{
  b6:	ba010113          	addi	sp,sp,-1120
  ba:	44113c23          	sd	ra,1112(sp)
  be:	44813823          	sd	s0,1104(sp)
  c2:	43313c23          	sd	s3,1080(sp)
  c6:	46010413          	addi	s0,sp,1120
  ca:	89ae                	mv	s3,a1
    if(argc == 2 && strcmp(argv[1], "?") == 0){
  cc:	4789                	li	a5,2
  ce:	04f50063          	beq	a0,a5,10e <main+0x58>
        printf("Usage: diff <file1> <file2>\n");
        exit(0);
    }

    if(argc != 3){
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
        printf("Error: diff requires 2 files\n");
  fc:	00001517          	auipc	a0,0x1
 100:	9ec50513          	addi	a0,a0,-1556 # ae8 <malloc+0x126>
 104:	00b000ef          	jal	90e <printf>
        exit(1);
 108:	4505                	li	a0,1
 10a:	3e4000ef          	jal	4ee <exit>
    if(argc == 2 && strcmp(argv[1], "?") == 0){
 10e:	00001597          	auipc	a1,0x1
 112:	9b258593          	addi	a1,a1,-1614 # ac0 <malloc+0xfe>
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
        printf("Usage: diff <file1> <file2>\n");
 144:	00001517          	auipc	a0,0x1
 148:	98450513          	addi	a0,a0,-1660 # ac8 <malloc+0x106>
 14c:	7c2000ef          	jal	90e <printf>
        exit(0);
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
    }

    int fd1 = open(argv[1], 0);
 17a:	4581                	li	a1,0
 17c:	0089b503          	ld	a0,8(s3)
 180:	3ae000ef          	jal	52e <open>
 184:	8b2a                	mv	s6,a0
    int fd2 = open(argv[2], 0);
 186:	4581                	li	a1,0
 188:	0109b503          	ld	a0,16(s3)
 18c:	3a2000ef          	jal	52e <open>
 190:	8aaa                	mv	s5,a0

    if(fd1 < 0 || fd2 < 0){
 192:	00ab67b3          	or	a5,s6,a0
 196:	02079713          	slli	a4,a5,0x20
 19a:	00074e63          	bltz	a4,1b6 <main+0x100>
        exit(1);
    }

    char b1[512], b2[512];
    int line=1;
    int diff = 0;
 19e:	4b81                	li	s7,0
    int line=1;
 1a0:	4a05                	li	s4,1
            diff=1;
            printf("Line %d only in %s:\n> %s\n", line, argv[2], b2);
        }
        else if(strcmp(b1, b2) != 0){
            diff=1;
            printf("Line %d differs:\n< %s\n> %s\n", line, b1, b2);
 1a2:	00001c97          	auipc	s9,0x1
 1a6:	9c6c8c93          	addi	s9,s9,-1594 # b68 <malloc+0x1a6>
            diff=1;
 1aa:	4c05                	li	s8,1
            printf("Line %d only in %s:\n< %s\n", line, argv[1], b1);
 1ac:	00001d17          	auipc	s10,0x1
 1b0:	97cd0d13          	addi	s10,s10,-1668 # b28 <malloc+0x166>
 1b4:	a091                	j	1f8 <main+0x142>
        printf("Error: cannot open files\n");
 1b6:	00001517          	auipc	a0,0x1
 1ba:	95250513          	addi	a0,a0,-1710 # b08 <malloc+0x146>
 1be:	750000ef          	jal	90e <printf>
        exit(1);
 1c2:	4505                	li	a0,1
 1c4:	32a000ef          	jal	4ee <exit>
        else if(n2 > 0 && n1 == 0){
 1c8:	03205063          	blez	s2,1e8 <main+0x132>
 1cc:	ec91                	bnez	s1,1e8 <main+0x132>
            printf("Line %d only in %s:\n> %s\n", line, argv[2], b2);
 1ce:	ba040693          	addi	a3,s0,-1120
 1d2:	0109b603          	ld	a2,16(s3)
 1d6:	85d2                	mv	a1,s4
 1d8:	00001517          	auipc	a0,0x1
 1dc:	97050513          	addi	a0,a0,-1680 # b48 <malloc+0x186>
 1e0:	72e000ef          	jal	90e <printf>
            diff=1;
 1e4:	4b85                	li	s7,1
            printf("Line %d only in %s:\n> %s\n", line, argv[2], b2);
 1e6:	a801                	j	1f6 <main+0x140>
        else if(strcmp(b1, b2) != 0){
 1e8:	ba040593          	addi	a1,s0,-1120
 1ec:	da040513          	addi	a0,s0,-608
 1f0:	0c2000ef          	jal	2b2 <strcmp>
 1f4:	ed21                	bnez	a0,24c <main+0x196>
        }

        line++;
 1f6:	2a05                	addiw	s4,s4,1
        int n1 = readline(fd1, b1, sizeof(b1));
 1f8:	20000613          	li	a2,512
 1fc:	da040593          	addi	a1,s0,-608
 200:	855a                	mv	a0,s6
 202:	dffff0ef          	jal	0 <readline>
 206:	84aa                	mv	s1,a0
        int n2 = readline(fd2, b2, sizeof(b2));
 208:	20000613          	li	a2,512
 20c:	ba040593          	addi	a1,s0,-1120
 210:	8556                	mv	a0,s5
 212:	defff0ef          	jal	0 <readline>
 216:	892a                	mv	s2,a0
        if(n1 == 0 && n2 == 0)
 218:	00a4e7b3          	or	a5,s1,a0
 21c:	2781                	sext.w	a5,a5
 21e:	c3a9                	beqz	a5,260 <main+0x1aa>
        strip_newlines(b1);
 220:	da040513          	addi	a0,s0,-608
 224:	e41ff0ef          	jal	64 <strip_newlines>
        strip_newlines(b2);
 228:	ba040513          	addi	a0,s0,-1120
 22c:	e39ff0ef          	jal	64 <strip_newlines>
        if(n1 > 0 && n2 == 0){
 230:	f8905ce3          	blez	s1,1c8 <main+0x112>
 234:	fa091ae3          	bnez	s2,1e8 <main+0x132>
            printf("Line %d only in %s:\n< %s\n", line, argv[1], b1);
 238:	da040693          	addi	a3,s0,-608
 23c:	0089b603          	ld	a2,8(s3)
 240:	85d2                	mv	a1,s4
 242:	856a                	mv	a0,s10
 244:	6ca000ef          	jal	90e <printf>
            diff=1;
 248:	8be2                	mv	s7,s8
            printf("Line %d only in %s:\n< %s\n", line, argv[1], b1);
 24a:	b775                	j	1f6 <main+0x140>
            printf("Line %d differs:\n< %s\n> %s\n", line, b1, b2);
 24c:	ba040693          	addi	a3,s0,-1120
 250:	da040613          	addi	a2,s0,-608
 254:	85d2                	mv	a1,s4
 256:	8566                	mv	a0,s9
 258:	6b6000ef          	jal	90e <printf>
            diff=1;
 25c:	8be2                	mv	s7,s8
 25e:	bf61                	j	1f6 <main+0x140>
    }

    if(!diff)
 260:	000b8b63          	beqz	s7,276 <main+0x1c0>
        printf("Files are identical\n");

    close(fd1);
 264:	855a                	mv	a0,s6
 266:	2b0000ef          	jal	516 <close>
    close(fd2);
 26a:	8556                	mv	a0,s5
 26c:	2aa000ef          	jal	516 <close>
    exit(0);
 270:	4501                	li	a0,0
 272:	27c000ef          	jal	4ee <exit>
        printf("Files are identical\n");
 276:	00001517          	auipc	a0,0x1
 27a:	91250513          	addi	a0,a0,-1774 # b88 <malloc+0x1c6>
 27e:	690000ef          	jal	90e <printf>
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
 4e6:	4885                	li	a7,1
 4e8:	00000073          	ecall
 4ec:	8082                	ret

00000000000004ee <exit>:
 4ee:	4889                	li	a7,2
 4f0:	00000073          	ecall
 4f4:	8082                	ret

00000000000004f6 <wait>:
 4f6:	488d                	li	a7,3
 4f8:	00000073          	ecall
 4fc:	8082                	ret

00000000000004fe <pipe>:
 4fe:	4891                	li	a7,4
 500:	00000073          	ecall
 504:	8082                	ret

0000000000000506 <read>:
 506:	4895                	li	a7,5
 508:	00000073          	ecall
 50c:	8082                	ret

000000000000050e <write>:
 50e:	48c1                	li	a7,16
 510:	00000073          	ecall
 514:	8082                	ret

0000000000000516 <close>:
 516:	48d5                	li	a7,21
 518:	00000073          	ecall
 51c:	8082                	ret

000000000000051e <kill>:
 51e:	4899                	li	a7,6
 520:	00000073          	ecall
 524:	8082                	ret

0000000000000526 <exec>:
 526:	489d                	li	a7,7
 528:	00000073          	ecall
 52c:	8082                	ret

000000000000052e <open>:
 52e:	48bd                	li	a7,15
 530:	00000073          	ecall
 534:	8082                	ret

0000000000000536 <mknod>:
 536:	48c5                	li	a7,17
 538:	00000073          	ecall
 53c:	8082                	ret

000000000000053e <unlink>:
 53e:	48c9                	li	a7,18
 540:	00000073          	ecall
 544:	8082                	ret

0000000000000546 <fstat>:
 546:	48a1                	li	a7,8
 548:	00000073          	ecall
 54c:	8082                	ret

000000000000054e <link>:
 54e:	48cd                	li	a7,19
 550:	00000073          	ecall
 554:	8082                	ret

0000000000000556 <mkdir>:
 556:	48d1                	li	a7,20
 558:	00000073          	ecall
 55c:	8082                	ret

000000000000055e <chdir>:
 55e:	48a5                	li	a7,9
 560:	00000073          	ecall
 564:	8082                	ret

0000000000000566 <dup>:
 566:	48a9                	li	a7,10
 568:	00000073          	ecall
 56c:	8082                	ret

000000000000056e <getpid>:
 56e:	48ad                	li	a7,11
 570:	00000073          	ecall
 574:	8082                	ret

0000000000000576 <sbrk>:
 576:	48b1                	li	a7,12
 578:	00000073          	ecall
 57c:	8082                	ret

000000000000057e <sleep>:
 57e:	48b5                	li	a7,13
 580:	00000073          	ecall
 584:	8082                	ret

0000000000000586 <uptime>:
 586:	48b9                	li	a7,14
 588:	00000073          	ecall
 58c:	8082                	ret

000000000000058e <kbdint>:
 58e:	48d9                	li	a7,22
 590:	00000073          	ecall
 594:	8082                	ret

0000000000000596 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 596:	1101                	addi	sp,sp,-32
 598:	ec06                	sd	ra,24(sp)
 59a:	e822                	sd	s0,16(sp)
 59c:	1000                	addi	s0,sp,32
 59e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5a2:	4605                	li	a2,1
 5a4:	fef40593          	addi	a1,s0,-17
 5a8:	f67ff0ef          	jal	50e <write>
}
 5ac:	60e2                	ld	ra,24(sp)
 5ae:	6442                	ld	s0,16(sp)
 5b0:	6105                	addi	sp,sp,32
 5b2:	8082                	ret

00000000000005b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5b4:	7139                	addi	sp,sp,-64
 5b6:	fc06                	sd	ra,56(sp)
 5b8:	f822                	sd	s0,48(sp)
 5ba:	f426                	sd	s1,40(sp)
 5bc:	0080                	addi	s0,sp,64
 5be:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5c0:	c299                	beqz	a3,5c6 <printint+0x12>
 5c2:	0805c963          	bltz	a1,654 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5c6:	2581                	sext.w	a1,a1
  neg = 0;
 5c8:	4881                	li	a7,0
 5ca:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5ce:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5d0:	2601                	sext.w	a2,a2
 5d2:	00000517          	auipc	a0,0x0
 5d6:	5d650513          	addi	a0,a0,1494 # ba8 <digits>
 5da:	883a                	mv	a6,a4
 5dc:	2705                	addiw	a4,a4,1
 5de:	02c5f7bb          	remuw	a5,a1,a2
 5e2:	1782                	slli	a5,a5,0x20
 5e4:	9381                	srli	a5,a5,0x20
 5e6:	97aa                	add	a5,a5,a0
 5e8:	0007c783          	lbu	a5,0(a5)
 5ec:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5f0:	0005879b          	sext.w	a5,a1
 5f4:	02c5d5bb          	divuw	a1,a1,a2
 5f8:	0685                	addi	a3,a3,1
 5fa:	fec7f0e3          	bgeu	a5,a2,5da <printint+0x26>
  if(neg)
 5fe:	00088c63          	beqz	a7,616 <printint+0x62>
    buf[i++] = '-';
 602:	fd070793          	addi	a5,a4,-48
 606:	00878733          	add	a4,a5,s0
 60a:	02d00793          	li	a5,45
 60e:	fef70823          	sb	a5,-16(a4)
 612:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 616:	02e05a63          	blez	a4,64a <printint+0x96>
 61a:	f04a                	sd	s2,32(sp)
 61c:	ec4e                	sd	s3,24(sp)
 61e:	fc040793          	addi	a5,s0,-64
 622:	00e78933          	add	s2,a5,a4
 626:	fff78993          	addi	s3,a5,-1
 62a:	99ba                	add	s3,s3,a4
 62c:	377d                	addiw	a4,a4,-1
 62e:	1702                	slli	a4,a4,0x20
 630:	9301                	srli	a4,a4,0x20
 632:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 636:	fff94583          	lbu	a1,-1(s2)
 63a:	8526                	mv	a0,s1
 63c:	f5bff0ef          	jal	596 <putc>
  while(--i >= 0)
 640:	197d                	addi	s2,s2,-1
 642:	ff391ae3          	bne	s2,s3,636 <printint+0x82>
 646:	7902                	ld	s2,32(sp)
 648:	69e2                	ld	s3,24(sp)
}
 64a:	70e2                	ld	ra,56(sp)
 64c:	7442                	ld	s0,48(sp)
 64e:	74a2                	ld	s1,40(sp)
 650:	6121                	addi	sp,sp,64
 652:	8082                	ret
    x = -xx;
 654:	40b005bb          	negw	a1,a1
    neg = 1;
 658:	4885                	li	a7,1
    x = -xx;
 65a:	bf85                	j	5ca <printint+0x16>

000000000000065c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 65c:	711d                	addi	sp,sp,-96
 65e:	ec86                	sd	ra,88(sp)
 660:	e8a2                	sd	s0,80(sp)
 662:	e0ca                	sd	s2,64(sp)
 664:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 666:	0005c903          	lbu	s2,0(a1)
 66a:	26090863          	beqz	s2,8da <vprintf+0x27e>
 66e:	e4a6                	sd	s1,72(sp)
 670:	fc4e                	sd	s3,56(sp)
 672:	f852                	sd	s4,48(sp)
 674:	f456                	sd	s5,40(sp)
 676:	f05a                	sd	s6,32(sp)
 678:	ec5e                	sd	s7,24(sp)
 67a:	e862                	sd	s8,16(sp)
 67c:	e466                	sd	s9,8(sp)
 67e:	8b2a                	mv	s6,a0
 680:	8a2e                	mv	s4,a1
 682:	8bb2                	mv	s7,a2
  state = 0;
 684:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 686:	4481                	li	s1,0
 688:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 68a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 68e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 692:	06c00c93          	li	s9,108
 696:	a005                	j	6b6 <vprintf+0x5a>
        putc(fd, c0);
 698:	85ca                	mv	a1,s2
 69a:	855a                	mv	a0,s6
 69c:	efbff0ef          	jal	596 <putc>
 6a0:	a019                	j	6a6 <vprintf+0x4a>
    } else if(state == '%'){
 6a2:	03598263          	beq	s3,s5,6c6 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6a6:	2485                	addiw	s1,s1,1
 6a8:	8726                	mv	a4,s1
 6aa:	009a07b3          	add	a5,s4,s1
 6ae:	0007c903          	lbu	s2,0(a5)
 6b2:	20090c63          	beqz	s2,8ca <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 6b6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6ba:	fe0994e3          	bnez	s3,6a2 <vprintf+0x46>
      if(c0 == '%'){
 6be:	fd579de3          	bne	a5,s5,698 <vprintf+0x3c>
        state = '%';
 6c2:	89be                	mv	s3,a5
 6c4:	b7cd                	j	6a6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6c6:	00ea06b3          	add	a3,s4,a4
 6ca:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6ce:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6d0:	c681                	beqz	a3,6d8 <vprintf+0x7c>
 6d2:	9752                	add	a4,a4,s4
 6d4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6d8:	03878f63          	beq	a5,s8,716 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6dc:	05978963          	beq	a5,s9,72e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6e0:	07500713          	li	a4,117
 6e4:	0ee78363          	beq	a5,a4,7ca <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6e8:	07800713          	li	a4,120
 6ec:	12e78563          	beq	a5,a4,816 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6f0:	07000713          	li	a4,112
 6f4:	14e78a63          	beq	a5,a4,848 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6f8:	07300713          	li	a4,115
 6fc:	18e78a63          	beq	a5,a4,890 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 700:	02500713          	li	a4,37
 704:	04e79563          	bne	a5,a4,74e <vprintf+0xf2>
        putc(fd, '%');
 708:	02500593          	li	a1,37
 70c:	855a                	mv	a0,s6
 70e:	e89ff0ef          	jal	596 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 712:	4981                	li	s3,0
 714:	bf49                	j	6a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 716:	008b8913          	addi	s2,s7,8
 71a:	4685                	li	a3,1
 71c:	4629                	li	a2,10
 71e:	000ba583          	lw	a1,0(s7)
 722:	855a                	mv	a0,s6
 724:	e91ff0ef          	jal	5b4 <printint>
 728:	8bca                	mv	s7,s2
      state = 0;
 72a:	4981                	li	s3,0
 72c:	bfad                	j	6a6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 72e:	06400793          	li	a5,100
 732:	02f68963          	beq	a3,a5,764 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 736:	06c00793          	li	a5,108
 73a:	04f68263          	beq	a3,a5,77e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 73e:	07500793          	li	a5,117
 742:	0af68063          	beq	a3,a5,7e2 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 746:	07800793          	li	a5,120
 74a:	0ef68263          	beq	a3,a5,82e <vprintf+0x1d2>
        putc(fd, '%');
 74e:	02500593          	li	a1,37
 752:	855a                	mv	a0,s6
 754:	e43ff0ef          	jal	596 <putc>
        putc(fd, c0);
 758:	85ca                	mv	a1,s2
 75a:	855a                	mv	a0,s6
 75c:	e3bff0ef          	jal	596 <putc>
      state = 0;
 760:	4981                	li	s3,0
 762:	b791                	j	6a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 764:	008b8913          	addi	s2,s7,8
 768:	4685                	li	a3,1
 76a:	4629                	li	a2,10
 76c:	000ba583          	lw	a1,0(s7)
 770:	855a                	mv	a0,s6
 772:	e43ff0ef          	jal	5b4 <printint>
        i += 1;
 776:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 778:	8bca                	mv	s7,s2
      state = 0;
 77a:	4981                	li	s3,0
        i += 1;
 77c:	b72d                	j	6a6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 77e:	06400793          	li	a5,100
 782:	02f60763          	beq	a2,a5,7b0 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 786:	07500793          	li	a5,117
 78a:	06f60963          	beq	a2,a5,7fc <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 78e:	07800793          	li	a5,120
 792:	faf61ee3          	bne	a2,a5,74e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 796:	008b8913          	addi	s2,s7,8
 79a:	4681                	li	a3,0
 79c:	4641                	li	a2,16
 79e:	000ba583          	lw	a1,0(s7)
 7a2:	855a                	mv	a0,s6
 7a4:	e11ff0ef          	jal	5b4 <printint>
        i += 2;
 7a8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7aa:	8bca                	mv	s7,s2
      state = 0;
 7ac:	4981                	li	s3,0
        i += 2;
 7ae:	bde5                	j	6a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b0:	008b8913          	addi	s2,s7,8
 7b4:	4685                	li	a3,1
 7b6:	4629                	li	a2,10
 7b8:	000ba583          	lw	a1,0(s7)
 7bc:	855a                	mv	a0,s6
 7be:	df7ff0ef          	jal	5b4 <printint>
        i += 2;
 7c2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c4:	8bca                	mv	s7,s2
      state = 0;
 7c6:	4981                	li	s3,0
        i += 2;
 7c8:	bdf9                	j	6a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7ca:	008b8913          	addi	s2,s7,8
 7ce:	4681                	li	a3,0
 7d0:	4629                	li	a2,10
 7d2:	000ba583          	lw	a1,0(s7)
 7d6:	855a                	mv	a0,s6
 7d8:	dddff0ef          	jal	5b4 <printint>
 7dc:	8bca                	mv	s7,s2
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	b5d9                	j	6a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e2:	008b8913          	addi	s2,s7,8
 7e6:	4681                	li	a3,0
 7e8:	4629                	li	a2,10
 7ea:	000ba583          	lw	a1,0(s7)
 7ee:	855a                	mv	a0,s6
 7f0:	dc5ff0ef          	jal	5b4 <printint>
        i += 1;
 7f4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f6:	8bca                	mv	s7,s2
      state = 0;
 7f8:	4981                	li	s3,0
        i += 1;
 7fa:	b575                	j	6a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7fc:	008b8913          	addi	s2,s7,8
 800:	4681                	li	a3,0
 802:	4629                	li	a2,10
 804:	000ba583          	lw	a1,0(s7)
 808:	855a                	mv	a0,s6
 80a:	dabff0ef          	jal	5b4 <printint>
        i += 2;
 80e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 810:	8bca                	mv	s7,s2
      state = 0;
 812:	4981                	li	s3,0
        i += 2;
 814:	bd49                	j	6a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 816:	008b8913          	addi	s2,s7,8
 81a:	4681                	li	a3,0
 81c:	4641                	li	a2,16
 81e:	000ba583          	lw	a1,0(s7)
 822:	855a                	mv	a0,s6
 824:	d91ff0ef          	jal	5b4 <printint>
 828:	8bca                	mv	s7,s2
      state = 0;
 82a:	4981                	li	s3,0
 82c:	bdad                	j	6a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 82e:	008b8913          	addi	s2,s7,8
 832:	4681                	li	a3,0
 834:	4641                	li	a2,16
 836:	000ba583          	lw	a1,0(s7)
 83a:	855a                	mv	a0,s6
 83c:	d79ff0ef          	jal	5b4 <printint>
        i += 1;
 840:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 842:	8bca                	mv	s7,s2
      state = 0;
 844:	4981                	li	s3,0
        i += 1;
 846:	b585                	j	6a6 <vprintf+0x4a>
 848:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 84a:	008b8d13          	addi	s10,s7,8
 84e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 852:	03000593          	li	a1,48
 856:	855a                	mv	a0,s6
 858:	d3fff0ef          	jal	596 <putc>
  putc(fd, 'x');
 85c:	07800593          	li	a1,120
 860:	855a                	mv	a0,s6
 862:	d35ff0ef          	jal	596 <putc>
 866:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 868:	00000b97          	auipc	s7,0x0
 86c:	340b8b93          	addi	s7,s7,832 # ba8 <digits>
 870:	03c9d793          	srli	a5,s3,0x3c
 874:	97de                	add	a5,a5,s7
 876:	0007c583          	lbu	a1,0(a5)
 87a:	855a                	mv	a0,s6
 87c:	d1bff0ef          	jal	596 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 880:	0992                	slli	s3,s3,0x4
 882:	397d                	addiw	s2,s2,-1
 884:	fe0916e3          	bnez	s2,870 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 888:	8bea                	mv	s7,s10
      state = 0;
 88a:	4981                	li	s3,0
 88c:	6d02                	ld	s10,0(sp)
 88e:	bd21                	j	6a6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 890:	008b8993          	addi	s3,s7,8
 894:	000bb903          	ld	s2,0(s7)
 898:	00090f63          	beqz	s2,8b6 <vprintf+0x25a>
        for(; *s; s++)
 89c:	00094583          	lbu	a1,0(s2)
 8a0:	c195                	beqz	a1,8c4 <vprintf+0x268>
          putc(fd, *s);
 8a2:	855a                	mv	a0,s6
 8a4:	cf3ff0ef          	jal	596 <putc>
        for(; *s; s++)
 8a8:	0905                	addi	s2,s2,1
 8aa:	00094583          	lbu	a1,0(s2)
 8ae:	f9f5                	bnez	a1,8a2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8b0:	8bce                	mv	s7,s3
      state = 0;
 8b2:	4981                	li	s3,0
 8b4:	bbcd                	j	6a6 <vprintf+0x4a>
          s = "(null)";
 8b6:	00000917          	auipc	s2,0x0
 8ba:	2ea90913          	addi	s2,s2,746 # ba0 <malloc+0x1de>
        for(; *s; s++)
 8be:	02800593          	li	a1,40
 8c2:	b7c5                	j	8a2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8c4:	8bce                	mv	s7,s3
      state = 0;
 8c6:	4981                	li	s3,0
 8c8:	bbf9                	j	6a6 <vprintf+0x4a>
 8ca:	64a6                	ld	s1,72(sp)
 8cc:	79e2                	ld	s3,56(sp)
 8ce:	7a42                	ld	s4,48(sp)
 8d0:	7aa2                	ld	s5,40(sp)
 8d2:	7b02                	ld	s6,32(sp)
 8d4:	6be2                	ld	s7,24(sp)
 8d6:	6c42                	ld	s8,16(sp)
 8d8:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8da:	60e6                	ld	ra,88(sp)
 8dc:	6446                	ld	s0,80(sp)
 8de:	6906                	ld	s2,64(sp)
 8e0:	6125                	addi	sp,sp,96
 8e2:	8082                	ret

00000000000008e4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8e4:	715d                	addi	sp,sp,-80
 8e6:	ec06                	sd	ra,24(sp)
 8e8:	e822                	sd	s0,16(sp)
 8ea:	1000                	addi	s0,sp,32
 8ec:	e010                	sd	a2,0(s0)
 8ee:	e414                	sd	a3,8(s0)
 8f0:	e818                	sd	a4,16(s0)
 8f2:	ec1c                	sd	a5,24(s0)
 8f4:	03043023          	sd	a6,32(s0)
 8f8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8fc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 900:	8622                	mv	a2,s0
 902:	d5bff0ef          	jal	65c <vprintf>
}
 906:	60e2                	ld	ra,24(sp)
 908:	6442                	ld	s0,16(sp)
 90a:	6161                	addi	sp,sp,80
 90c:	8082                	ret

000000000000090e <printf>:

void
printf(const char *fmt, ...)
{
 90e:	711d                	addi	sp,sp,-96
 910:	ec06                	sd	ra,24(sp)
 912:	e822                	sd	s0,16(sp)
 914:	1000                	addi	s0,sp,32
 916:	e40c                	sd	a1,8(s0)
 918:	e810                	sd	a2,16(s0)
 91a:	ec14                	sd	a3,24(s0)
 91c:	f018                	sd	a4,32(s0)
 91e:	f41c                	sd	a5,40(s0)
 920:	03043823          	sd	a6,48(s0)
 924:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 928:	00840613          	addi	a2,s0,8
 92c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 930:	85aa                	mv	a1,a0
 932:	4505                	li	a0,1
 934:	d29ff0ef          	jal	65c <vprintf>
}
 938:	60e2                	ld	ra,24(sp)
 93a:	6442                	ld	s0,16(sp)
 93c:	6125                	addi	sp,sp,96
 93e:	8082                	ret

0000000000000940 <free>:
 940:	1141                	addi	sp,sp,-16
 942:	e422                	sd	s0,8(sp)
 944:	0800                	addi	s0,sp,16
 946:	ff050693          	addi	a3,a0,-16
 94a:	00001797          	auipc	a5,0x1
 94e:	6b67b783          	ld	a5,1718(a5) # 2000 <freep>
 952:	a02d                	j	97c <free+0x3c>
 954:	4618                	lw	a4,8(a2)
 956:	9f2d                	addw	a4,a4,a1
 958:	fee52c23          	sw	a4,-8(a0)
 95c:	6398                	ld	a4,0(a5)
 95e:	6310                	ld	a2,0(a4)
 960:	a83d                	j	99e <free+0x5e>
 962:	ff852703          	lw	a4,-8(a0)
 966:	9f31                	addw	a4,a4,a2
 968:	c798                	sw	a4,8(a5)
 96a:	ff053683          	ld	a3,-16(a0)
 96e:	a091                	j	9b2 <free+0x72>
 970:	6398                	ld	a4,0(a5)
 972:	00e7e463          	bltu	a5,a4,97a <free+0x3a>
 976:	00e6ea63          	bltu	a3,a4,98a <free+0x4a>
 97a:	87ba                	mv	a5,a4
 97c:	fed7fae3          	bgeu	a5,a3,970 <free+0x30>
 980:	6398                	ld	a4,0(a5)
 982:	00e6e463          	bltu	a3,a4,98a <free+0x4a>
 986:	fee7eae3          	bltu	a5,a4,97a <free+0x3a>
 98a:	ff852583          	lw	a1,-8(a0)
 98e:	6390                	ld	a2,0(a5)
 990:	02059813          	slli	a6,a1,0x20
 994:	01c85713          	srli	a4,a6,0x1c
 998:	9736                	add	a4,a4,a3
 99a:	fae60de3          	beq	a2,a4,954 <free+0x14>
 99e:	fec53823          	sd	a2,-16(a0)
 9a2:	4790                	lw	a2,8(a5)
 9a4:	02061593          	slli	a1,a2,0x20
 9a8:	01c5d713          	srli	a4,a1,0x1c
 9ac:	973e                	add	a4,a4,a5
 9ae:	fae68ae3          	beq	a3,a4,962 <free+0x22>
 9b2:	e394                	sd	a3,0(a5)
 9b4:	00001717          	auipc	a4,0x1
 9b8:	64f73623          	sd	a5,1612(a4) # 2000 <freep>
 9bc:	6422                	ld	s0,8(sp)
 9be:	0141                	addi	sp,sp,16
 9c0:	8082                	ret

00000000000009c2 <malloc>:
 9c2:	7139                	addi	sp,sp,-64
 9c4:	fc06                	sd	ra,56(sp)
 9c6:	f822                	sd	s0,48(sp)
 9c8:	f426                	sd	s1,40(sp)
 9ca:	ec4e                	sd	s3,24(sp)
 9cc:	0080                	addi	s0,sp,64
 9ce:	02051493          	slli	s1,a0,0x20
 9d2:	9081                	srli	s1,s1,0x20
 9d4:	04bd                	addi	s1,s1,15
 9d6:	8091                	srli	s1,s1,0x4
 9d8:	0014899b          	addiw	s3,s1,1
 9dc:	0485                	addi	s1,s1,1
 9de:	00001517          	auipc	a0,0x1
 9e2:	62253503          	ld	a0,1570(a0) # 2000 <freep>
 9e6:	c915                	beqz	a0,a1a <malloc+0x58>
 9e8:	611c                	ld	a5,0(a0)
 9ea:	4798                	lw	a4,8(a5)
 9ec:	08977a63          	bgeu	a4,s1,a80 <malloc+0xbe>
 9f0:	f04a                	sd	s2,32(sp)
 9f2:	e852                	sd	s4,16(sp)
 9f4:	e456                	sd	s5,8(sp)
 9f6:	e05a                	sd	s6,0(sp)
 9f8:	8a4e                	mv	s4,s3
 9fa:	0009871b          	sext.w	a4,s3
 9fe:	6685                	lui	a3,0x1
 a00:	00d77363          	bgeu	a4,a3,a06 <malloc+0x44>
 a04:	6a05                	lui	s4,0x1
 a06:	000a0b1b          	sext.w	s6,s4
 a0a:	004a1a1b          	slliw	s4,s4,0x4
 a0e:	00001917          	auipc	s2,0x1
 a12:	5f290913          	addi	s2,s2,1522 # 2000 <freep>
 a16:	5afd                	li	s5,-1
 a18:	a081                	j	a58 <malloc+0x96>
 a1a:	f04a                	sd	s2,32(sp)
 a1c:	e852                	sd	s4,16(sp)
 a1e:	e456                	sd	s5,8(sp)
 a20:	e05a                	sd	s6,0(sp)
 a22:	00001797          	auipc	a5,0x1
 a26:	5ee78793          	addi	a5,a5,1518 # 2010 <base>
 a2a:	00001717          	auipc	a4,0x1
 a2e:	5cf73b23          	sd	a5,1494(a4) # 2000 <freep>
 a32:	e39c                	sd	a5,0(a5)
 a34:	0007a423          	sw	zero,8(a5)
 a38:	b7c1                	j	9f8 <malloc+0x36>
 a3a:	6398                	ld	a4,0(a5)
 a3c:	e118                	sd	a4,0(a0)
 a3e:	a8a9                	j	a98 <malloc+0xd6>
 a40:	01652423          	sw	s6,8(a0)
 a44:	0541                	addi	a0,a0,16
 a46:	efbff0ef          	jal	940 <free>
 a4a:	00093503          	ld	a0,0(s2)
 a4e:	c12d                	beqz	a0,ab0 <malloc+0xee>
 a50:	611c                	ld	a5,0(a0)
 a52:	4798                	lw	a4,8(a5)
 a54:	02977263          	bgeu	a4,s1,a78 <malloc+0xb6>
 a58:	00093703          	ld	a4,0(s2)
 a5c:	853e                	mv	a0,a5
 a5e:	fef719e3          	bne	a4,a5,a50 <malloc+0x8e>
 a62:	8552                	mv	a0,s4
 a64:	b13ff0ef          	jal	576 <sbrk>
 a68:	fd551ce3          	bne	a0,s5,a40 <malloc+0x7e>
 a6c:	4501                	li	a0,0
 a6e:	7902                	ld	s2,32(sp)
 a70:	6a42                	ld	s4,16(sp)
 a72:	6aa2                	ld	s5,8(sp)
 a74:	6b02                	ld	s6,0(sp)
 a76:	a03d                	j	aa4 <malloc+0xe2>
 a78:	7902                	ld	s2,32(sp)
 a7a:	6a42                	ld	s4,16(sp)
 a7c:	6aa2                	ld	s5,8(sp)
 a7e:	6b02                	ld	s6,0(sp)
 a80:	fae48de3          	beq	s1,a4,a3a <malloc+0x78>
 a84:	4137073b          	subw	a4,a4,s3
 a88:	c798                	sw	a4,8(a5)
 a8a:	02071693          	slli	a3,a4,0x20
 a8e:	01c6d713          	srli	a4,a3,0x1c
 a92:	97ba                	add	a5,a5,a4
 a94:	0137a423          	sw	s3,8(a5)
 a98:	00001717          	auipc	a4,0x1
 a9c:	56a73423          	sd	a0,1384(a4) # 2000 <freep>
 aa0:	01078513          	addi	a0,a5,16
 aa4:	70e2                	ld	ra,56(sp)
 aa6:	7442                	ld	s0,48(sp)
 aa8:	74a2                	ld	s1,40(sp)
 aaa:	69e2                	ld	s3,24(sp)
 aac:	6121                	addi	sp,sp,64
 aae:	8082                	ret
 ab0:	7902                	ld	s2,32(sp)
 ab2:	6a42                	ld	s4,16(sp)
 ab4:	6aa2                	ld	s5,8(sp)
 ab6:	6b02                	ld	s6,0(sp)
 ab8:	b7f5                	j	aa4 <malloc+0xe2>
