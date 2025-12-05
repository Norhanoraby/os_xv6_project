
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
  1a:	95a50513          	addi	a0,a0,-1702 # 970 <malloc+0x106>
  1e:	798000ef          	jal	7b6 <printf>
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
  48:	96450513          	addi	a0,a0,-1692 # 9a8 <malloc+0x13e>
  4c:	76a000ef          	jal	7b6 <printf>

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
  64:	93050513          	addi	a0,a0,-1744 # 990 <malloc+0x126>
  68:	74e000ef          	jal	7b6 <printf>
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
  ce:	92e50513          	addi	a0,a0,-1746 # 9f8 <malloc+0x18e>
  d2:	6e4000ef          	jal	7b6 <printf>
            break;
        }
    }

    close(fd);
  d6:	854e                	mv	a0,s3
  d8:	2be000ef          	jal	396 <close>
    printf("\nSaved %s\n", filename);
  dc:	85d2                	mv	a1,s4
  de:	00001517          	auipc	a0,0x1
  e2:	93250513          	addi	a0,a0,-1742 # a10 <malloc+0x1a6>
  e6:	6d0000ef          	jal	7b6 <printf>
    exit(0);
  ea:	4501                	li	a0,0
  ec:	282000ef          	jal	36e <exit>
        printf("nano: cannot reopen %s\n", filename);
  f0:	85d2                	mv	a1,s4
  f2:	00001517          	auipc	a0,0x1
  f6:	8ee50513          	addi	a0,a0,-1810 # 9e0 <malloc+0x176>
  fa:	6bc000ef          	jal	7b6 <printf>
        exit(1);
  fe:	4505                	li	a0,1
 100:	26e000ef          	jal	36e <exit>

0000000000000104 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 10c:	ef5ff0ef          	jal	0 <main>
  exit(0);
 110:	4501                	li	a0,0
 112:	25c000ef          	jal	36e <exit>

0000000000000116 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 116:	1141                	addi	sp,sp,-16
 118:	e422                	sd	s0,8(sp)
 11a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11c:	87aa                	mv	a5,a0
 11e:	0585                	addi	a1,a1,1
 120:	0785                	addi	a5,a5,1
 122:	fff5c703          	lbu	a4,-1(a1)
 126:	fee78fa3          	sb	a4,-1(a5)
 12a:	fb75                	bnez	a4,11e <strcpy+0x8>
    ;
  return os;
}
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 132:	1141                	addi	sp,sp,-16
 134:	e422                	sd	s0,8(sp)
 136:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 138:	00054783          	lbu	a5,0(a0)
 13c:	cb91                	beqz	a5,150 <strcmp+0x1e>
 13e:	0005c703          	lbu	a4,0(a1)
 142:	00f71763          	bne	a4,a5,150 <strcmp+0x1e>
    p++, q++;
 146:	0505                	addi	a0,a0,1
 148:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 14a:	00054783          	lbu	a5,0(a0)
 14e:	fbe5                	bnez	a5,13e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 150:	0005c503          	lbu	a0,0(a1)
}
 154:	40a7853b          	subw	a0,a5,a0
 158:	6422                	ld	s0,8(sp)
 15a:	0141                	addi	sp,sp,16
 15c:	8082                	ret

000000000000015e <strlen>:

uint
strlen(const char *s)
{
 15e:	1141                	addi	sp,sp,-16
 160:	e422                	sd	s0,8(sp)
 162:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
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
    ;
  return n;
}
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret
  for(n = 0; s[n]; n++)
 184:	4501                	li	a0,0
 186:	bfe5                	j	17e <strlen+0x20>

0000000000000188 <memset>:

void*
memset(void *dst, int c, uint n)
{
 188:	1141                	addi	sp,sp,-16
 18a:	e422                	sd	s0,8(sp)
 18c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18e:	ca19                	beqz	a2,1a4 <memset+0x1c>
 190:	87aa                	mv	a5,a0
 192:	1602                	slli	a2,a2,0x20
 194:	9201                	srli	a2,a2,0x20
 196:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 19a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19e:	0785                	addi	a5,a5,1
 1a0:	fee79de3          	bne	a5,a4,19a <memset+0x12>
  }
  return dst;
}
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret

00000000000001aa <strchr>:

char*
strchr(const char *s, char c)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	cb99                	beqz	a5,1ca <strchr+0x20>
    if(*s == c)
 1b6:	00f58763          	beq	a1,a5,1c4 <strchr+0x1a>
  for(; *s; s++)
 1ba:	0505                	addi	a0,a0,1
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	fbfd                	bnez	a5,1b6 <strchr+0xc>
      return (char*)s;
  return 0;
 1c2:	4501                	li	a0,0
}
 1c4:	6422                	ld	s0,8(sp)
 1c6:	0141                	addi	sp,sp,16
 1c8:	8082                	ret
  return 0;
 1ca:	4501                	li	a0,0
 1cc:	bfe5                	j	1c4 <strchr+0x1a>

00000000000001ce <gets>:

char*
gets(char *buf, int max)
{
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
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e8:	892a                	mv	s2,a0
 1ea:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ec:	4aa9                	li	s5,10
 1ee:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1f0:	89a6                	mv	s3,s1
 1f2:	2485                	addiw	s1,s1,1
 1f4:	0344d663          	bge	s1,s4,220 <gets+0x52>
    cc = read(0, &c, 1);
 1f8:	4605                	li	a2,1
 1fa:	faf40593          	addi	a1,s0,-81
 1fe:	4501                	li	a0,0
 200:	186000ef          	jal	386 <read>
    if(cc < 1)
 204:	00a05e63          	blez	a0,220 <gets+0x52>
    buf[i++] = c;
 208:	faf44783          	lbu	a5,-81(s0)
 20c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 210:	01578763          	beq	a5,s5,21e <gets+0x50>
 214:	0905                	addi	s2,s2,1
 216:	fd679de3          	bne	a5,s6,1f0 <gets+0x22>
    buf[i++] = c;
 21a:	89a6                	mv	s3,s1
 21c:	a011                	j	220 <gets+0x52>
 21e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 220:	99de                	add	s3,s3,s7
 222:	00098023          	sb	zero,0(s3)
  return buf;
}
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

int
stat(const char *n, struct stat *st)
{
 23e:	1101                	addi	sp,sp,-32
 240:	ec06                	sd	ra,24(sp)
 242:	e822                	sd	s0,16(sp)
 244:	e04a                	sd	s2,0(sp)
 246:	1000                	addi	s0,sp,32
 248:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24a:	4581                	li	a1,0
 24c:	162000ef          	jal	3ae <open>
  if(fd < 0)
 250:	02054263          	bltz	a0,274 <stat+0x36>
 254:	e426                	sd	s1,8(sp)
 256:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 258:	85ca                	mv	a1,s2
 25a:	16c000ef          	jal	3c6 <fstat>
 25e:	892a                	mv	s2,a0
  close(fd);
 260:	8526                	mv	a0,s1
 262:	134000ef          	jal	396 <close>
  return r;
 266:	64a2                	ld	s1,8(sp)
}
 268:	854a                	mv	a0,s2
 26a:	60e2                	ld	ra,24(sp)
 26c:	6442                	ld	s0,16(sp)
 26e:	6902                	ld	s2,0(sp)
 270:	6105                	addi	sp,sp,32
 272:	8082                	ret
    return -1;
 274:	597d                	li	s2,-1
 276:	bfcd                	j	268 <stat+0x2a>

0000000000000278 <atoi>:

int
atoi(const char *s)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 27e:	00054683          	lbu	a3,0(a0)
 282:	fd06879b          	addiw	a5,a3,-48
 286:	0ff7f793          	zext.b	a5,a5
 28a:	4625                	li	a2,9
 28c:	02f66863          	bltu	a2,a5,2bc <atoi+0x44>
 290:	872a                	mv	a4,a0
  n = 0;
 292:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 294:	0705                	addi	a4,a4,1
 296:	0025179b          	slliw	a5,a0,0x2
 29a:	9fa9                	addw	a5,a5,a0
 29c:	0017979b          	slliw	a5,a5,0x1
 2a0:	9fb5                	addw	a5,a5,a3
 2a2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2a6:	00074683          	lbu	a3,0(a4)
 2aa:	fd06879b          	addiw	a5,a3,-48
 2ae:	0ff7f793          	zext.b	a5,a5
 2b2:	fef671e3          	bgeu	a2,a5,294 <atoi+0x1c>
  return n;
}
 2b6:	6422                	ld	s0,8(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret
  n = 0;
 2bc:	4501                	li	a0,0
 2be:	bfe5                	j	2b6 <atoi+0x3e>

00000000000002c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e422                	sd	s0,8(sp)
 2c4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c6:	02b57463          	bgeu	a0,a1,2ee <memmove+0x2e>
    while(n-- > 0)
 2ca:	00c05f63          	blez	a2,2e8 <memmove+0x28>
 2ce:	1602                	slli	a2,a2,0x20
 2d0:	9201                	srli	a2,a2,0x20
 2d2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2d8:	0585                	addi	a1,a1,1
 2da:	0705                	addi	a4,a4,1
 2dc:	fff5c683          	lbu	a3,-1(a1)
 2e0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2e4:	fef71ae3          	bne	a4,a5,2d8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2e8:	6422                	ld	s0,8(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret
    dst += n;
 2ee:	00c50733          	add	a4,a0,a2
    src += n;
 2f2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2f4:	fec05ae3          	blez	a2,2e8 <memmove+0x28>
 2f8:	fff6079b          	addiw	a5,a2,-1
 2fc:	1782                	slli	a5,a5,0x20
 2fe:	9381                	srli	a5,a5,0x20
 300:	fff7c793          	not	a5,a5
 304:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 306:	15fd                	addi	a1,a1,-1
 308:	177d                	addi	a4,a4,-1
 30a:	0005c683          	lbu	a3,0(a1)
 30e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 312:	fee79ae3          	bne	a5,a4,306 <memmove+0x46>
 316:	bfc9                	j	2e8 <memmove+0x28>

0000000000000318 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 31e:	ca05                	beqz	a2,34e <memcmp+0x36>
 320:	fff6069b          	addiw	a3,a2,-1
 324:	1682                	slli	a3,a3,0x20
 326:	9281                	srli	a3,a3,0x20
 328:	0685                	addi	a3,a3,1
 32a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 32c:	00054783          	lbu	a5,0(a0)
 330:	0005c703          	lbu	a4,0(a1)
 334:	00e79863          	bne	a5,a4,344 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 338:	0505                	addi	a0,a0,1
    p2++;
 33a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 33c:	fed518e3          	bne	a0,a3,32c <memcmp+0x14>
  }
  return 0;
 340:	4501                	li	a0,0
 342:	a019                	j	348 <memcmp+0x30>
      return *p1 - *p2;
 344:	40e7853b          	subw	a0,a5,a4
}
 348:	6422                	ld	s0,8(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret
  return 0;
 34e:	4501                	li	a0,0
 350:	bfe5                	j	348 <memcmp+0x30>

0000000000000352 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 352:	1141                	addi	sp,sp,-16
 354:	e406                	sd	ra,8(sp)
 356:	e022                	sd	s0,0(sp)
 358:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 35a:	f67ff0ef          	jal	2c0 <memmove>
}
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret

0000000000000366 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 366:	4885                	li	a7,1
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <exit>:
.global exit
exit:
 li a7, SYS_exit
 36e:	4889                	li	a7,2
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <wait>:
.global wait
wait:
 li a7, SYS_wait
 376:	488d                	li	a7,3
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 37e:	4891                	li	a7,4
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <read>:
.global read
read:
 li a7, SYS_read
 386:	4895                	li	a7,5
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <write>:
.global write
write:
 li a7, SYS_write
 38e:	48c1                	li	a7,16
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <close>:
.global close
close:
 li a7, SYS_close
 396:	48d5                	li	a7,21
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <kill>:
.global kill
kill:
 li a7, SYS_kill
 39e:	4899                	li	a7,6
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3a6:	489d                	li	a7,7
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <open>:
.global open
open:
 li a7, SYS_open
 3ae:	48bd                	li	a7,15
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3b6:	48c5                	li	a7,17
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3be:	48c9                	li	a7,18
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3c6:	48a1                	li	a7,8
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <link>:
.global link
link:
 li a7, SYS_link
 3ce:	48cd                	li	a7,19
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3d6:	48d1                	li	a7,20
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3de:	48a5                	li	a7,9
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3e6:	48a9                	li	a7,10
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ee:	48ad                	li	a7,11
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3f6:	48b1                	li	a7,12
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3fe:	48b5                	li	a7,13
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 406:	48b9                	li	a7,14
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 40e:	48d9                	li	a7,22
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 416:	48dd                	li	a7,23
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 41e:	48e1                	li	a7,24
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 426:	48e5                	li	a7,25
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <random>:
.global random
random:
 li a7, SYS_random
 42e:	48e9                	li	a7,26
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 436:	48ed                	li	a7,27
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 43e:	1101                	addi	sp,sp,-32
 440:	ec06                	sd	ra,24(sp)
 442:	e822                	sd	s0,16(sp)
 444:	1000                	addi	s0,sp,32
 446:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 44a:	4605                	li	a2,1
 44c:	fef40593          	addi	a1,s0,-17
 450:	f3fff0ef          	jal	38e <write>
}
 454:	60e2                	ld	ra,24(sp)
 456:	6442                	ld	s0,16(sp)
 458:	6105                	addi	sp,sp,32
 45a:	8082                	ret

000000000000045c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 45c:	7139                	addi	sp,sp,-64
 45e:	fc06                	sd	ra,56(sp)
 460:	f822                	sd	s0,48(sp)
 462:	f426                	sd	s1,40(sp)
 464:	0080                	addi	s0,sp,64
 466:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 468:	c299                	beqz	a3,46e <printint+0x12>
 46a:	0805c963          	bltz	a1,4fc <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 46e:	2581                	sext.w	a1,a1
  neg = 0;
 470:	4881                	li	a7,0
 472:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 476:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 478:	2601                	sext.w	a2,a2
 47a:	00000517          	auipc	a0,0x0
 47e:	5ae50513          	addi	a0,a0,1454 # a28 <digits>
 482:	883a                	mv	a6,a4
 484:	2705                	addiw	a4,a4,1
 486:	02c5f7bb          	remuw	a5,a1,a2
 48a:	1782                	slli	a5,a5,0x20
 48c:	9381                	srli	a5,a5,0x20
 48e:	97aa                	add	a5,a5,a0
 490:	0007c783          	lbu	a5,0(a5)
 494:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 498:	0005879b          	sext.w	a5,a1
 49c:	02c5d5bb          	divuw	a1,a1,a2
 4a0:	0685                	addi	a3,a3,1
 4a2:	fec7f0e3          	bgeu	a5,a2,482 <printint+0x26>
  if(neg)
 4a6:	00088c63          	beqz	a7,4be <printint+0x62>
    buf[i++] = '-';
 4aa:	fd070793          	addi	a5,a4,-48
 4ae:	00878733          	add	a4,a5,s0
 4b2:	02d00793          	li	a5,45
 4b6:	fef70823          	sb	a5,-16(a4)
 4ba:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4be:	02e05a63          	blez	a4,4f2 <printint+0x96>
 4c2:	f04a                	sd	s2,32(sp)
 4c4:	ec4e                	sd	s3,24(sp)
 4c6:	fc040793          	addi	a5,s0,-64
 4ca:	00e78933          	add	s2,a5,a4
 4ce:	fff78993          	addi	s3,a5,-1
 4d2:	99ba                	add	s3,s3,a4
 4d4:	377d                	addiw	a4,a4,-1
 4d6:	1702                	slli	a4,a4,0x20
 4d8:	9301                	srli	a4,a4,0x20
 4da:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4de:	fff94583          	lbu	a1,-1(s2)
 4e2:	8526                	mv	a0,s1
 4e4:	f5bff0ef          	jal	43e <putc>
  while(--i >= 0)
 4e8:	197d                	addi	s2,s2,-1
 4ea:	ff391ae3          	bne	s2,s3,4de <printint+0x82>
 4ee:	7902                	ld	s2,32(sp)
 4f0:	69e2                	ld	s3,24(sp)
}
 4f2:	70e2                	ld	ra,56(sp)
 4f4:	7442                	ld	s0,48(sp)
 4f6:	74a2                	ld	s1,40(sp)
 4f8:	6121                	addi	sp,sp,64
 4fa:	8082                	ret
    x = -xx;
 4fc:	40b005bb          	negw	a1,a1
    neg = 1;
 500:	4885                	li	a7,1
    x = -xx;
 502:	bf85                	j	472 <printint+0x16>

0000000000000504 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 504:	711d                	addi	sp,sp,-96
 506:	ec86                	sd	ra,88(sp)
 508:	e8a2                	sd	s0,80(sp)
 50a:	e0ca                	sd	s2,64(sp)
 50c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 50e:	0005c903          	lbu	s2,0(a1)
 512:	26090863          	beqz	s2,782 <vprintf+0x27e>
 516:	e4a6                	sd	s1,72(sp)
 518:	fc4e                	sd	s3,56(sp)
 51a:	f852                	sd	s4,48(sp)
 51c:	f456                	sd	s5,40(sp)
 51e:	f05a                	sd	s6,32(sp)
 520:	ec5e                	sd	s7,24(sp)
 522:	e862                	sd	s8,16(sp)
 524:	e466                	sd	s9,8(sp)
 526:	8b2a                	mv	s6,a0
 528:	8a2e                	mv	s4,a1
 52a:	8bb2                	mv	s7,a2
  state = 0;
 52c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 52e:	4481                	li	s1,0
 530:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 532:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 536:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 53a:	06c00c93          	li	s9,108
 53e:	a005                	j	55e <vprintf+0x5a>
        putc(fd, c0);
 540:	85ca                	mv	a1,s2
 542:	855a                	mv	a0,s6
 544:	efbff0ef          	jal	43e <putc>
 548:	a019                	j	54e <vprintf+0x4a>
    } else if(state == '%'){
 54a:	03598263          	beq	s3,s5,56e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 54e:	2485                	addiw	s1,s1,1
 550:	8726                	mv	a4,s1
 552:	009a07b3          	add	a5,s4,s1
 556:	0007c903          	lbu	s2,0(a5)
 55a:	20090c63          	beqz	s2,772 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 55e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 562:	fe0994e3          	bnez	s3,54a <vprintf+0x46>
      if(c0 == '%'){
 566:	fd579de3          	bne	a5,s5,540 <vprintf+0x3c>
        state = '%';
 56a:	89be                	mv	s3,a5
 56c:	b7cd                	j	54e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 56e:	00ea06b3          	add	a3,s4,a4
 572:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 576:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 578:	c681                	beqz	a3,580 <vprintf+0x7c>
 57a:	9752                	add	a4,a4,s4
 57c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 580:	03878f63          	beq	a5,s8,5be <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 584:	05978963          	beq	a5,s9,5d6 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 588:	07500713          	li	a4,117
 58c:	0ee78363          	beq	a5,a4,672 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 590:	07800713          	li	a4,120
 594:	12e78563          	beq	a5,a4,6be <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 598:	07000713          	li	a4,112
 59c:	14e78a63          	beq	a5,a4,6f0 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5a0:	07300713          	li	a4,115
 5a4:	18e78a63          	beq	a5,a4,738 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5a8:	02500713          	li	a4,37
 5ac:	04e79563          	bne	a5,a4,5f6 <vprintf+0xf2>
        putc(fd, '%');
 5b0:	02500593          	li	a1,37
 5b4:	855a                	mv	a0,s6
 5b6:	e89ff0ef          	jal	43e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	bf49                	j	54e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5be:	008b8913          	addi	s2,s7,8
 5c2:	4685                	li	a3,1
 5c4:	4629                	li	a2,10
 5c6:	000ba583          	lw	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	e91ff0ef          	jal	45c <printint>
 5d0:	8bca                	mv	s7,s2
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	bfad                	j	54e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5d6:	06400793          	li	a5,100
 5da:	02f68963          	beq	a3,a5,60c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5de:	06c00793          	li	a5,108
 5e2:	04f68263          	beq	a3,a5,626 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5e6:	07500793          	li	a5,117
 5ea:	0af68063          	beq	a3,a5,68a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5ee:	07800793          	li	a5,120
 5f2:	0ef68263          	beq	a3,a5,6d6 <vprintf+0x1d2>
        putc(fd, '%');
 5f6:	02500593          	li	a1,37
 5fa:	855a                	mv	a0,s6
 5fc:	e43ff0ef          	jal	43e <putc>
        putc(fd, c0);
 600:	85ca                	mv	a1,s2
 602:	855a                	mv	a0,s6
 604:	e3bff0ef          	jal	43e <putc>
      state = 0;
 608:	4981                	li	s3,0
 60a:	b791                	j	54e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60c:	008b8913          	addi	s2,s7,8
 610:	4685                	li	a3,1
 612:	4629                	li	a2,10
 614:	000ba583          	lw	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	e43ff0ef          	jal	45c <printint>
        i += 1;
 61e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 620:	8bca                	mv	s7,s2
      state = 0;
 622:	4981                	li	s3,0
        i += 1;
 624:	b72d                	j	54e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 626:	06400793          	li	a5,100
 62a:	02f60763          	beq	a2,a5,658 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 62e:	07500793          	li	a5,117
 632:	06f60963          	beq	a2,a5,6a4 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 636:	07800793          	li	a5,120
 63a:	faf61ee3          	bne	a2,a5,5f6 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 63e:	008b8913          	addi	s2,s7,8
 642:	4681                	li	a3,0
 644:	4641                	li	a2,16
 646:	000ba583          	lw	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	e11ff0ef          	jal	45c <printint>
        i += 2;
 650:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 652:	8bca                	mv	s7,s2
      state = 0;
 654:	4981                	li	s3,0
        i += 2;
 656:	bde5                	j	54e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 658:	008b8913          	addi	s2,s7,8
 65c:	4685                	li	a3,1
 65e:	4629                	li	a2,10
 660:	000ba583          	lw	a1,0(s7)
 664:	855a                	mv	a0,s6
 666:	df7ff0ef          	jal	45c <printint>
        i += 2;
 66a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 66c:	8bca                	mv	s7,s2
      state = 0;
 66e:	4981                	li	s3,0
        i += 2;
 670:	bdf9                	j	54e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 672:	008b8913          	addi	s2,s7,8
 676:	4681                	li	a3,0
 678:	4629                	li	a2,10
 67a:	000ba583          	lw	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	dddff0ef          	jal	45c <printint>
 684:	8bca                	mv	s7,s2
      state = 0;
 686:	4981                	li	s3,0
 688:	b5d9                	j	54e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68a:	008b8913          	addi	s2,s7,8
 68e:	4681                	li	a3,0
 690:	4629                	li	a2,10
 692:	000ba583          	lw	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	dc5ff0ef          	jal	45c <printint>
        i += 1;
 69c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 69e:	8bca                	mv	s7,s2
      state = 0;
 6a0:	4981                	li	s3,0
        i += 1;
 6a2:	b575                	j	54e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a4:	008b8913          	addi	s2,s7,8
 6a8:	4681                	li	a3,0
 6aa:	4629                	li	a2,10
 6ac:	000ba583          	lw	a1,0(s7)
 6b0:	855a                	mv	a0,s6
 6b2:	dabff0ef          	jal	45c <printint>
        i += 2;
 6b6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b8:	8bca                	mv	s7,s2
      state = 0;
 6ba:	4981                	li	s3,0
        i += 2;
 6bc:	bd49                	j	54e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6be:	008b8913          	addi	s2,s7,8
 6c2:	4681                	li	a3,0
 6c4:	4641                	li	a2,16
 6c6:	000ba583          	lw	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	d91ff0ef          	jal	45c <printint>
 6d0:	8bca                	mv	s7,s2
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bdad                	j	54e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d6:	008b8913          	addi	s2,s7,8
 6da:	4681                	li	a3,0
 6dc:	4641                	li	a2,16
 6de:	000ba583          	lw	a1,0(s7)
 6e2:	855a                	mv	a0,s6
 6e4:	d79ff0ef          	jal	45c <printint>
        i += 1;
 6e8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ea:	8bca                	mv	s7,s2
      state = 0;
 6ec:	4981                	li	s3,0
        i += 1;
 6ee:	b585                	j	54e <vprintf+0x4a>
 6f0:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6f2:	008b8d13          	addi	s10,s7,8
 6f6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6fa:	03000593          	li	a1,48
 6fe:	855a                	mv	a0,s6
 700:	d3fff0ef          	jal	43e <putc>
  putc(fd, 'x');
 704:	07800593          	li	a1,120
 708:	855a                	mv	a0,s6
 70a:	d35ff0ef          	jal	43e <putc>
 70e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 710:	00000b97          	auipc	s7,0x0
 714:	318b8b93          	addi	s7,s7,792 # a28 <digits>
 718:	03c9d793          	srli	a5,s3,0x3c
 71c:	97de                	add	a5,a5,s7
 71e:	0007c583          	lbu	a1,0(a5)
 722:	855a                	mv	a0,s6
 724:	d1bff0ef          	jal	43e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 728:	0992                	slli	s3,s3,0x4
 72a:	397d                	addiw	s2,s2,-1
 72c:	fe0916e3          	bnez	s2,718 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 730:	8bea                	mv	s7,s10
      state = 0;
 732:	4981                	li	s3,0
 734:	6d02                	ld	s10,0(sp)
 736:	bd21                	j	54e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 738:	008b8993          	addi	s3,s7,8
 73c:	000bb903          	ld	s2,0(s7)
 740:	00090f63          	beqz	s2,75e <vprintf+0x25a>
        for(; *s; s++)
 744:	00094583          	lbu	a1,0(s2)
 748:	c195                	beqz	a1,76c <vprintf+0x268>
          putc(fd, *s);
 74a:	855a                	mv	a0,s6
 74c:	cf3ff0ef          	jal	43e <putc>
        for(; *s; s++)
 750:	0905                	addi	s2,s2,1
 752:	00094583          	lbu	a1,0(s2)
 756:	f9f5                	bnez	a1,74a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 758:	8bce                	mv	s7,s3
      state = 0;
 75a:	4981                	li	s3,0
 75c:	bbcd                	j	54e <vprintf+0x4a>
          s = "(null)";
 75e:	00000917          	auipc	s2,0x0
 762:	2c290913          	addi	s2,s2,706 # a20 <malloc+0x1b6>
        for(; *s; s++)
 766:	02800593          	li	a1,40
 76a:	b7c5                	j	74a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 76c:	8bce                	mv	s7,s3
      state = 0;
 76e:	4981                	li	s3,0
 770:	bbf9                	j	54e <vprintf+0x4a>
 772:	64a6                	ld	s1,72(sp)
 774:	79e2                	ld	s3,56(sp)
 776:	7a42                	ld	s4,48(sp)
 778:	7aa2                	ld	s5,40(sp)
 77a:	7b02                	ld	s6,32(sp)
 77c:	6be2                	ld	s7,24(sp)
 77e:	6c42                	ld	s8,16(sp)
 780:	6ca2                	ld	s9,8(sp)
    }
  }
}
 782:	60e6                	ld	ra,88(sp)
 784:	6446                	ld	s0,80(sp)
 786:	6906                	ld	s2,64(sp)
 788:	6125                	addi	sp,sp,96
 78a:	8082                	ret

000000000000078c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 78c:	715d                	addi	sp,sp,-80
 78e:	ec06                	sd	ra,24(sp)
 790:	e822                	sd	s0,16(sp)
 792:	1000                	addi	s0,sp,32
 794:	e010                	sd	a2,0(s0)
 796:	e414                	sd	a3,8(s0)
 798:	e818                	sd	a4,16(s0)
 79a:	ec1c                	sd	a5,24(s0)
 79c:	03043023          	sd	a6,32(s0)
 7a0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7a4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a8:	8622                	mv	a2,s0
 7aa:	d5bff0ef          	jal	504 <vprintf>
}
 7ae:	60e2                	ld	ra,24(sp)
 7b0:	6442                	ld	s0,16(sp)
 7b2:	6161                	addi	sp,sp,80
 7b4:	8082                	ret

00000000000007b6 <printf>:

void
printf(const char *fmt, ...)
{
 7b6:	711d                	addi	sp,sp,-96
 7b8:	ec06                	sd	ra,24(sp)
 7ba:	e822                	sd	s0,16(sp)
 7bc:	1000                	addi	s0,sp,32
 7be:	e40c                	sd	a1,8(s0)
 7c0:	e810                	sd	a2,16(s0)
 7c2:	ec14                	sd	a3,24(s0)
 7c4:	f018                	sd	a4,32(s0)
 7c6:	f41c                	sd	a5,40(s0)
 7c8:	03043823          	sd	a6,48(s0)
 7cc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7d0:	00840613          	addi	a2,s0,8
 7d4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d8:	85aa                	mv	a1,a0
 7da:	4505                	li	a0,1
 7dc:	d29ff0ef          	jal	504 <vprintf>
}
 7e0:	60e2                	ld	ra,24(sp)
 7e2:	6442                	ld	s0,16(sp)
 7e4:	6125                	addi	sp,sp,96
 7e6:	8082                	ret

00000000000007e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e8:	1141                	addi	sp,sp,-16
 7ea:	e422                	sd	s0,8(sp)
 7ec:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ee:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f2:	00001797          	auipc	a5,0x1
 7f6:	80e7b783          	ld	a5,-2034(a5) # 1000 <freep>
 7fa:	a02d                	j	824 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7fc:	4618                	lw	a4,8(a2)
 7fe:	9f2d                	addw	a4,a4,a1
 800:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 804:	6398                	ld	a4,0(a5)
 806:	6310                	ld	a2,0(a4)
 808:	a83d                	j	846 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 80a:	ff852703          	lw	a4,-8(a0)
 80e:	9f31                	addw	a4,a4,a2
 810:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 812:	ff053683          	ld	a3,-16(a0)
 816:	a091                	j	85a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 818:	6398                	ld	a4,0(a5)
 81a:	00e7e463          	bltu	a5,a4,822 <free+0x3a>
 81e:	00e6ea63          	bltu	a3,a4,832 <free+0x4a>
{
 822:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 824:	fed7fae3          	bgeu	a5,a3,818 <free+0x30>
 828:	6398                	ld	a4,0(a5)
 82a:	00e6e463          	bltu	a3,a4,832 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82e:	fee7eae3          	bltu	a5,a4,822 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 832:	ff852583          	lw	a1,-8(a0)
 836:	6390                	ld	a2,0(a5)
 838:	02059813          	slli	a6,a1,0x20
 83c:	01c85713          	srli	a4,a6,0x1c
 840:	9736                	add	a4,a4,a3
 842:	fae60de3          	beq	a2,a4,7fc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 846:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 84a:	4790                	lw	a2,8(a5)
 84c:	02061593          	slli	a1,a2,0x20
 850:	01c5d713          	srli	a4,a1,0x1c
 854:	973e                	add	a4,a4,a5
 856:	fae68ae3          	beq	a3,a4,80a <free+0x22>
    p->s.ptr = bp->s.ptr;
 85a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 85c:	00000717          	auipc	a4,0x0
 860:	7af73223          	sd	a5,1956(a4) # 1000 <freep>
}
 864:	6422                	ld	s0,8(sp)
 866:	0141                	addi	sp,sp,16
 868:	8082                	ret

000000000000086a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 86a:	7139                	addi	sp,sp,-64
 86c:	fc06                	sd	ra,56(sp)
 86e:	f822                	sd	s0,48(sp)
 870:	f426                	sd	s1,40(sp)
 872:	ec4e                	sd	s3,24(sp)
 874:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 876:	02051493          	slli	s1,a0,0x20
 87a:	9081                	srli	s1,s1,0x20
 87c:	04bd                	addi	s1,s1,15
 87e:	8091                	srli	s1,s1,0x4
 880:	0014899b          	addiw	s3,s1,1
 884:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 886:	00000517          	auipc	a0,0x0
 88a:	77a53503          	ld	a0,1914(a0) # 1000 <freep>
 88e:	c915                	beqz	a0,8c2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 890:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 892:	4798                	lw	a4,8(a5)
 894:	08977a63          	bgeu	a4,s1,928 <malloc+0xbe>
 898:	f04a                	sd	s2,32(sp)
 89a:	e852                	sd	s4,16(sp)
 89c:	e456                	sd	s5,8(sp)
 89e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8a0:	8a4e                	mv	s4,s3
 8a2:	0009871b          	sext.w	a4,s3
 8a6:	6685                	lui	a3,0x1
 8a8:	00d77363          	bgeu	a4,a3,8ae <malloc+0x44>
 8ac:	6a05                	lui	s4,0x1
 8ae:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b6:	00000917          	auipc	s2,0x0
 8ba:	74a90913          	addi	s2,s2,1866 # 1000 <freep>
  if(p == (char*)-1)
 8be:	5afd                	li	s5,-1
 8c0:	a081                	j	900 <malloc+0x96>
 8c2:	f04a                	sd	s2,32(sp)
 8c4:	e852                	sd	s4,16(sp)
 8c6:	e456                	sd	s5,8(sp)
 8c8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8ca:	00001797          	auipc	a5,0x1
 8ce:	94678793          	addi	a5,a5,-1722 # 1210 <base>
 8d2:	00000717          	auipc	a4,0x0
 8d6:	72f73723          	sd	a5,1838(a4) # 1000 <freep>
 8da:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8dc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8e0:	b7c1                	j	8a0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8e2:	6398                	ld	a4,0(a5)
 8e4:	e118                	sd	a4,0(a0)
 8e6:	a8a9                	j	940 <malloc+0xd6>
  hp->s.size = nu;
 8e8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ec:	0541                	addi	a0,a0,16
 8ee:	efbff0ef          	jal	7e8 <free>
  return freep;
 8f2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8f6:	c12d                	beqz	a0,958 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8fa:	4798                	lw	a4,8(a5)
 8fc:	02977263          	bgeu	a4,s1,920 <malloc+0xb6>
    if(p == freep)
 900:	00093703          	ld	a4,0(s2)
 904:	853e                	mv	a0,a5
 906:	fef719e3          	bne	a4,a5,8f8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 90a:	8552                	mv	a0,s4
 90c:	aebff0ef          	jal	3f6 <sbrk>
  if(p == (char*)-1)
 910:	fd551ce3          	bne	a0,s5,8e8 <malloc+0x7e>
        return 0;
 914:	4501                	li	a0,0
 916:	7902                	ld	s2,32(sp)
 918:	6a42                	ld	s4,16(sp)
 91a:	6aa2                	ld	s5,8(sp)
 91c:	6b02                	ld	s6,0(sp)
 91e:	a03d                	j	94c <malloc+0xe2>
 920:	7902                	ld	s2,32(sp)
 922:	6a42                	ld	s4,16(sp)
 924:	6aa2                	ld	s5,8(sp)
 926:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 928:	fae48de3          	beq	s1,a4,8e2 <malloc+0x78>
        p->s.size -= nunits;
 92c:	4137073b          	subw	a4,a4,s3
 930:	c798                	sw	a4,8(a5)
        p += p->s.size;
 932:	02071693          	slli	a3,a4,0x20
 936:	01c6d713          	srli	a4,a3,0x1c
 93a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 93c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 940:	00000717          	auipc	a4,0x0
 944:	6ca73023          	sd	a0,1728(a4) # 1000 <freep>
      return (void*)(p + 1);
 948:	01078513          	addi	a0,a5,16
  }
}
 94c:	70e2                	ld	ra,56(sp)
 94e:	7442                	ld	s0,48(sp)
 950:	74a2                	ld	s1,40(sp)
 952:	69e2                	ld	s3,24(sp)
 954:	6121                	addi	sp,sp,64
 956:	8082                	ret
 958:	7902                	ld	s2,32(sp)
 95a:	6a42                	ld	s4,16(sp)
 95c:	6aa2                	ld	s5,8(sp)
 95e:	6b02                	ld	s6,0(sp)
 960:	b7f5                	j	94c <malloc+0xe2>
