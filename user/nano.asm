
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
  1a:	95a50513          	addi	a0,a0,-1702 # 970 <malloc+0xfe>
  1e:	7a0000ef          	jal	7be <printf>
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
  48:	96450513          	addi	a0,a0,-1692 # 9a8 <malloc+0x136>
  4c:	772000ef          	jal	7be <printf>

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
  64:	93050513          	addi	a0,a0,-1744 # 990 <malloc+0x11e>
  68:	756000ef          	jal	7be <printf>
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
  ce:	92e50513          	addi	a0,a0,-1746 # 9f8 <malloc+0x186>
  d2:	6ec000ef          	jal	7be <printf>
            break;
        }
    }

    close(fd);
  d6:	854e                	mv	a0,s3
  d8:	2be000ef          	jal	396 <close>
    printf("\nSaved %s\n", filename);
  dc:	85d2                	mv	a1,s4
  de:	00001517          	auipc	a0,0x1
  e2:	93250513          	addi	a0,a0,-1742 # a10 <malloc+0x19e>
  e6:	6d8000ef          	jal	7be <printf>
    exit(0);
  ea:	4501                	li	a0,0
  ec:	282000ef          	jal	36e <exit>
        printf("nano: cannot reopen %s\n", filename);
  f0:	85d2                	mv	a1,s4
  f2:	00001517          	auipc	a0,0x1
  f6:	8ee50513          	addi	a0,a0,-1810 # 9e0 <malloc+0x16e>
  fa:	6c4000ef          	jal	7be <printf>
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

0000000000000436 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 436:	48ed                	li	a7,27
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 43e:	48f1                	li	a7,28
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 446:	1101                	addi	sp,sp,-32
 448:	ec06                	sd	ra,24(sp)
 44a:	e822                	sd	s0,16(sp)
 44c:	1000                	addi	s0,sp,32
 44e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 452:	4605                	li	a2,1
 454:	fef40593          	addi	a1,s0,-17
 458:	f37ff0ef          	jal	38e <write>
}
 45c:	60e2                	ld	ra,24(sp)
 45e:	6442                	ld	s0,16(sp)
 460:	6105                	addi	sp,sp,32
 462:	8082                	ret

0000000000000464 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 464:	7139                	addi	sp,sp,-64
 466:	fc06                	sd	ra,56(sp)
 468:	f822                	sd	s0,48(sp)
 46a:	f426                	sd	s1,40(sp)
 46c:	0080                	addi	s0,sp,64
 46e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 470:	c299                	beqz	a3,476 <printint+0x12>
 472:	0805c963          	bltz	a1,504 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 476:	2581                	sext.w	a1,a1
  neg = 0;
 478:	4881                	li	a7,0
 47a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 47e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 480:	2601                	sext.w	a2,a2
 482:	00000517          	auipc	a0,0x0
 486:	5a650513          	addi	a0,a0,1446 # a28 <digits>
 48a:	883a                	mv	a6,a4
 48c:	2705                	addiw	a4,a4,1
 48e:	02c5f7bb          	remuw	a5,a1,a2
 492:	1782                	slli	a5,a5,0x20
 494:	9381                	srli	a5,a5,0x20
 496:	97aa                	add	a5,a5,a0
 498:	0007c783          	lbu	a5,0(a5)
 49c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4a0:	0005879b          	sext.w	a5,a1
 4a4:	02c5d5bb          	divuw	a1,a1,a2
 4a8:	0685                	addi	a3,a3,1
 4aa:	fec7f0e3          	bgeu	a5,a2,48a <printint+0x26>
  if(neg)
 4ae:	00088c63          	beqz	a7,4c6 <printint+0x62>
    buf[i++] = '-';
 4b2:	fd070793          	addi	a5,a4,-48
 4b6:	00878733          	add	a4,a5,s0
 4ba:	02d00793          	li	a5,45
 4be:	fef70823          	sb	a5,-16(a4)
 4c2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4c6:	02e05a63          	blez	a4,4fa <printint+0x96>
 4ca:	f04a                	sd	s2,32(sp)
 4cc:	ec4e                	sd	s3,24(sp)
 4ce:	fc040793          	addi	a5,s0,-64
 4d2:	00e78933          	add	s2,a5,a4
 4d6:	fff78993          	addi	s3,a5,-1
 4da:	99ba                	add	s3,s3,a4
 4dc:	377d                	addiw	a4,a4,-1
 4de:	1702                	slli	a4,a4,0x20
 4e0:	9301                	srli	a4,a4,0x20
 4e2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4e6:	fff94583          	lbu	a1,-1(s2)
 4ea:	8526                	mv	a0,s1
 4ec:	f5bff0ef          	jal	446 <putc>
  while(--i >= 0)
 4f0:	197d                	addi	s2,s2,-1
 4f2:	ff391ae3          	bne	s2,s3,4e6 <printint+0x82>
 4f6:	7902                	ld	s2,32(sp)
 4f8:	69e2                	ld	s3,24(sp)
}
 4fa:	70e2                	ld	ra,56(sp)
 4fc:	7442                	ld	s0,48(sp)
 4fe:	74a2                	ld	s1,40(sp)
 500:	6121                	addi	sp,sp,64
 502:	8082                	ret
    x = -xx;
 504:	40b005bb          	negw	a1,a1
    neg = 1;
 508:	4885                	li	a7,1
    x = -xx;
 50a:	bf85                	j	47a <printint+0x16>

000000000000050c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 50c:	711d                	addi	sp,sp,-96
 50e:	ec86                	sd	ra,88(sp)
 510:	e8a2                	sd	s0,80(sp)
 512:	e0ca                	sd	s2,64(sp)
 514:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 516:	0005c903          	lbu	s2,0(a1)
 51a:	26090863          	beqz	s2,78a <vprintf+0x27e>
 51e:	e4a6                	sd	s1,72(sp)
 520:	fc4e                	sd	s3,56(sp)
 522:	f852                	sd	s4,48(sp)
 524:	f456                	sd	s5,40(sp)
 526:	f05a                	sd	s6,32(sp)
 528:	ec5e                	sd	s7,24(sp)
 52a:	e862                	sd	s8,16(sp)
 52c:	e466                	sd	s9,8(sp)
 52e:	8b2a                	mv	s6,a0
 530:	8a2e                	mv	s4,a1
 532:	8bb2                	mv	s7,a2
  state = 0;
 534:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 536:	4481                	li	s1,0
 538:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 53a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 53e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 542:	06c00c93          	li	s9,108
 546:	a005                	j	566 <vprintf+0x5a>
        putc(fd, c0);
 548:	85ca                	mv	a1,s2
 54a:	855a                	mv	a0,s6
 54c:	efbff0ef          	jal	446 <putc>
 550:	a019                	j	556 <vprintf+0x4a>
    } else if(state == '%'){
 552:	03598263          	beq	s3,s5,576 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 556:	2485                	addiw	s1,s1,1
 558:	8726                	mv	a4,s1
 55a:	009a07b3          	add	a5,s4,s1
 55e:	0007c903          	lbu	s2,0(a5)
 562:	20090c63          	beqz	s2,77a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 566:	0009079b          	sext.w	a5,s2
    if(state == 0){
 56a:	fe0994e3          	bnez	s3,552 <vprintf+0x46>
      if(c0 == '%'){
 56e:	fd579de3          	bne	a5,s5,548 <vprintf+0x3c>
        state = '%';
 572:	89be                	mv	s3,a5
 574:	b7cd                	j	556 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 576:	00ea06b3          	add	a3,s4,a4
 57a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 57e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 580:	c681                	beqz	a3,588 <vprintf+0x7c>
 582:	9752                	add	a4,a4,s4
 584:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 588:	03878f63          	beq	a5,s8,5c6 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 58c:	05978963          	beq	a5,s9,5de <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 590:	07500713          	li	a4,117
 594:	0ee78363          	beq	a5,a4,67a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 598:	07800713          	li	a4,120
 59c:	12e78563          	beq	a5,a4,6c6 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5a0:	07000713          	li	a4,112
 5a4:	14e78a63          	beq	a5,a4,6f8 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5a8:	07300713          	li	a4,115
 5ac:	18e78a63          	beq	a5,a4,740 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5b0:	02500713          	li	a4,37
 5b4:	04e79563          	bne	a5,a4,5fe <vprintf+0xf2>
        putc(fd, '%');
 5b8:	02500593          	li	a1,37
 5bc:	855a                	mv	a0,s6
 5be:	e89ff0ef          	jal	446 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	bf49                	j	556 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5c6:	008b8913          	addi	s2,s7,8
 5ca:	4685                	li	a3,1
 5cc:	4629                	li	a2,10
 5ce:	000ba583          	lw	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	e91ff0ef          	jal	464 <printint>
 5d8:	8bca                	mv	s7,s2
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	bfad                	j	556 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5de:	06400793          	li	a5,100
 5e2:	02f68963          	beq	a3,a5,614 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5e6:	06c00793          	li	a5,108
 5ea:	04f68263          	beq	a3,a5,62e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5ee:	07500793          	li	a5,117
 5f2:	0af68063          	beq	a3,a5,692 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5f6:	07800793          	li	a5,120
 5fa:	0ef68263          	beq	a3,a5,6de <vprintf+0x1d2>
        putc(fd, '%');
 5fe:	02500593          	li	a1,37
 602:	855a                	mv	a0,s6
 604:	e43ff0ef          	jal	446 <putc>
        putc(fd, c0);
 608:	85ca                	mv	a1,s2
 60a:	855a                	mv	a0,s6
 60c:	e3bff0ef          	jal	446 <putc>
      state = 0;
 610:	4981                	li	s3,0
 612:	b791                	j	556 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 614:	008b8913          	addi	s2,s7,8
 618:	4685                	li	a3,1
 61a:	4629                	li	a2,10
 61c:	000ba583          	lw	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	e43ff0ef          	jal	464 <printint>
        i += 1;
 626:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 628:	8bca                	mv	s7,s2
      state = 0;
 62a:	4981                	li	s3,0
        i += 1;
 62c:	b72d                	j	556 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 62e:	06400793          	li	a5,100
 632:	02f60763          	beq	a2,a5,660 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 636:	07500793          	li	a5,117
 63a:	06f60963          	beq	a2,a5,6ac <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 63e:	07800793          	li	a5,120
 642:	faf61ee3          	bne	a2,a5,5fe <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 646:	008b8913          	addi	s2,s7,8
 64a:	4681                	li	a3,0
 64c:	4641                	li	a2,16
 64e:	000ba583          	lw	a1,0(s7)
 652:	855a                	mv	a0,s6
 654:	e11ff0ef          	jal	464 <printint>
        i += 2;
 658:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 65a:	8bca                	mv	s7,s2
      state = 0;
 65c:	4981                	li	s3,0
        i += 2;
 65e:	bde5                	j	556 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 660:	008b8913          	addi	s2,s7,8
 664:	4685                	li	a3,1
 666:	4629                	li	a2,10
 668:	000ba583          	lw	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	df7ff0ef          	jal	464 <printint>
        i += 2;
 672:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 674:	8bca                	mv	s7,s2
      state = 0;
 676:	4981                	li	s3,0
        i += 2;
 678:	bdf9                	j	556 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 67a:	008b8913          	addi	s2,s7,8
 67e:	4681                	li	a3,0
 680:	4629                	li	a2,10
 682:	000ba583          	lw	a1,0(s7)
 686:	855a                	mv	a0,s6
 688:	dddff0ef          	jal	464 <printint>
 68c:	8bca                	mv	s7,s2
      state = 0;
 68e:	4981                	li	s3,0
 690:	b5d9                	j	556 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 692:	008b8913          	addi	s2,s7,8
 696:	4681                	li	a3,0
 698:	4629                	li	a2,10
 69a:	000ba583          	lw	a1,0(s7)
 69e:	855a                	mv	a0,s6
 6a0:	dc5ff0ef          	jal	464 <printint>
        i += 1;
 6a4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a6:	8bca                	mv	s7,s2
      state = 0;
 6a8:	4981                	li	s3,0
        i += 1;
 6aa:	b575                	j	556 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ac:	008b8913          	addi	s2,s7,8
 6b0:	4681                	li	a3,0
 6b2:	4629                	li	a2,10
 6b4:	000ba583          	lw	a1,0(s7)
 6b8:	855a                	mv	a0,s6
 6ba:	dabff0ef          	jal	464 <printint>
        i += 2;
 6be:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c0:	8bca                	mv	s7,s2
      state = 0;
 6c2:	4981                	li	s3,0
        i += 2;
 6c4:	bd49                	j	556 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6c6:	008b8913          	addi	s2,s7,8
 6ca:	4681                	li	a3,0
 6cc:	4641                	li	a2,16
 6ce:	000ba583          	lw	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	d91ff0ef          	jal	464 <printint>
 6d8:	8bca                	mv	s7,s2
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	bdad                	j	556 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6de:	008b8913          	addi	s2,s7,8
 6e2:	4681                	li	a3,0
 6e4:	4641                	li	a2,16
 6e6:	000ba583          	lw	a1,0(s7)
 6ea:	855a                	mv	a0,s6
 6ec:	d79ff0ef          	jal	464 <printint>
        i += 1;
 6f0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f2:	8bca                	mv	s7,s2
      state = 0;
 6f4:	4981                	li	s3,0
        i += 1;
 6f6:	b585                	j	556 <vprintf+0x4a>
 6f8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6fa:	008b8d13          	addi	s10,s7,8
 6fe:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 702:	03000593          	li	a1,48
 706:	855a                	mv	a0,s6
 708:	d3fff0ef          	jal	446 <putc>
  putc(fd, 'x');
 70c:	07800593          	li	a1,120
 710:	855a                	mv	a0,s6
 712:	d35ff0ef          	jal	446 <putc>
 716:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 718:	00000b97          	auipc	s7,0x0
 71c:	310b8b93          	addi	s7,s7,784 # a28 <digits>
 720:	03c9d793          	srli	a5,s3,0x3c
 724:	97de                	add	a5,a5,s7
 726:	0007c583          	lbu	a1,0(a5)
 72a:	855a                	mv	a0,s6
 72c:	d1bff0ef          	jal	446 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 730:	0992                	slli	s3,s3,0x4
 732:	397d                	addiw	s2,s2,-1
 734:	fe0916e3          	bnez	s2,720 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 738:	8bea                	mv	s7,s10
      state = 0;
 73a:	4981                	li	s3,0
 73c:	6d02                	ld	s10,0(sp)
 73e:	bd21                	j	556 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 740:	008b8993          	addi	s3,s7,8
 744:	000bb903          	ld	s2,0(s7)
 748:	00090f63          	beqz	s2,766 <vprintf+0x25a>
        for(; *s; s++)
 74c:	00094583          	lbu	a1,0(s2)
 750:	c195                	beqz	a1,774 <vprintf+0x268>
          putc(fd, *s);
 752:	855a                	mv	a0,s6
 754:	cf3ff0ef          	jal	446 <putc>
        for(; *s; s++)
 758:	0905                	addi	s2,s2,1
 75a:	00094583          	lbu	a1,0(s2)
 75e:	f9f5                	bnez	a1,752 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 760:	8bce                	mv	s7,s3
      state = 0;
 762:	4981                	li	s3,0
 764:	bbcd                	j	556 <vprintf+0x4a>
          s = "(null)";
 766:	00000917          	auipc	s2,0x0
 76a:	2ba90913          	addi	s2,s2,698 # a20 <malloc+0x1ae>
        for(; *s; s++)
 76e:	02800593          	li	a1,40
 772:	b7c5                	j	752 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 774:	8bce                	mv	s7,s3
      state = 0;
 776:	4981                	li	s3,0
 778:	bbf9                	j	556 <vprintf+0x4a>
 77a:	64a6                	ld	s1,72(sp)
 77c:	79e2                	ld	s3,56(sp)
 77e:	7a42                	ld	s4,48(sp)
 780:	7aa2                	ld	s5,40(sp)
 782:	7b02                	ld	s6,32(sp)
 784:	6be2                	ld	s7,24(sp)
 786:	6c42                	ld	s8,16(sp)
 788:	6ca2                	ld	s9,8(sp)
    }
  }
}
 78a:	60e6                	ld	ra,88(sp)
 78c:	6446                	ld	s0,80(sp)
 78e:	6906                	ld	s2,64(sp)
 790:	6125                	addi	sp,sp,96
 792:	8082                	ret

0000000000000794 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 794:	715d                	addi	sp,sp,-80
 796:	ec06                	sd	ra,24(sp)
 798:	e822                	sd	s0,16(sp)
 79a:	1000                	addi	s0,sp,32
 79c:	e010                	sd	a2,0(s0)
 79e:	e414                	sd	a3,8(s0)
 7a0:	e818                	sd	a4,16(s0)
 7a2:	ec1c                	sd	a5,24(s0)
 7a4:	03043023          	sd	a6,32(s0)
 7a8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ac:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7b0:	8622                	mv	a2,s0
 7b2:	d5bff0ef          	jal	50c <vprintf>
}
 7b6:	60e2                	ld	ra,24(sp)
 7b8:	6442                	ld	s0,16(sp)
 7ba:	6161                	addi	sp,sp,80
 7bc:	8082                	ret

00000000000007be <printf>:

void
printf(const char *fmt, ...)
{
 7be:	711d                	addi	sp,sp,-96
 7c0:	ec06                	sd	ra,24(sp)
 7c2:	e822                	sd	s0,16(sp)
 7c4:	1000                	addi	s0,sp,32
 7c6:	e40c                	sd	a1,8(s0)
 7c8:	e810                	sd	a2,16(s0)
 7ca:	ec14                	sd	a3,24(s0)
 7cc:	f018                	sd	a4,32(s0)
 7ce:	f41c                	sd	a5,40(s0)
 7d0:	03043823          	sd	a6,48(s0)
 7d4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7d8:	00840613          	addi	a2,s0,8
 7dc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7e0:	85aa                	mv	a1,a0
 7e2:	4505                	li	a0,1
 7e4:	d29ff0ef          	jal	50c <vprintf>
}
 7e8:	60e2                	ld	ra,24(sp)
 7ea:	6442                	ld	s0,16(sp)
 7ec:	6125                	addi	sp,sp,96
 7ee:	8082                	ret

00000000000007f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f0:	1141                	addi	sp,sp,-16
 7f2:	e422                	sd	s0,8(sp)
 7f4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7f6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fa:	00001797          	auipc	a5,0x1
 7fe:	8067b783          	ld	a5,-2042(a5) # 1000 <freep>
 802:	a02d                	j	82c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 804:	4618                	lw	a4,8(a2)
 806:	9f2d                	addw	a4,a4,a1
 808:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 80c:	6398                	ld	a4,0(a5)
 80e:	6310                	ld	a2,0(a4)
 810:	a83d                	j	84e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 812:	ff852703          	lw	a4,-8(a0)
 816:	9f31                	addw	a4,a4,a2
 818:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 81a:	ff053683          	ld	a3,-16(a0)
 81e:	a091                	j	862 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 820:	6398                	ld	a4,0(a5)
 822:	00e7e463          	bltu	a5,a4,82a <free+0x3a>
 826:	00e6ea63          	bltu	a3,a4,83a <free+0x4a>
{
 82a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82c:	fed7fae3          	bgeu	a5,a3,820 <free+0x30>
 830:	6398                	ld	a4,0(a5)
 832:	00e6e463          	bltu	a3,a4,83a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 836:	fee7eae3          	bltu	a5,a4,82a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 83a:	ff852583          	lw	a1,-8(a0)
 83e:	6390                	ld	a2,0(a5)
 840:	02059813          	slli	a6,a1,0x20
 844:	01c85713          	srli	a4,a6,0x1c
 848:	9736                	add	a4,a4,a3
 84a:	fae60de3          	beq	a2,a4,804 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 84e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 852:	4790                	lw	a2,8(a5)
 854:	02061593          	slli	a1,a2,0x20
 858:	01c5d713          	srli	a4,a1,0x1c
 85c:	973e                	add	a4,a4,a5
 85e:	fae68ae3          	beq	a3,a4,812 <free+0x22>
    p->s.ptr = bp->s.ptr;
 862:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 864:	00000717          	auipc	a4,0x0
 868:	78f73e23          	sd	a5,1948(a4) # 1000 <freep>
}
 86c:	6422                	ld	s0,8(sp)
 86e:	0141                	addi	sp,sp,16
 870:	8082                	ret

0000000000000872 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 872:	7139                	addi	sp,sp,-64
 874:	fc06                	sd	ra,56(sp)
 876:	f822                	sd	s0,48(sp)
 878:	f426                	sd	s1,40(sp)
 87a:	ec4e                	sd	s3,24(sp)
 87c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87e:	02051493          	slli	s1,a0,0x20
 882:	9081                	srli	s1,s1,0x20
 884:	04bd                	addi	s1,s1,15
 886:	8091                	srli	s1,s1,0x4
 888:	0014899b          	addiw	s3,s1,1
 88c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 88e:	00000517          	auipc	a0,0x0
 892:	77253503          	ld	a0,1906(a0) # 1000 <freep>
 896:	c915                	beqz	a0,8ca <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 898:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89a:	4798                	lw	a4,8(a5)
 89c:	08977a63          	bgeu	a4,s1,930 <malloc+0xbe>
 8a0:	f04a                	sd	s2,32(sp)
 8a2:	e852                	sd	s4,16(sp)
 8a4:	e456                	sd	s5,8(sp)
 8a6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8a8:	8a4e                	mv	s4,s3
 8aa:	0009871b          	sext.w	a4,s3
 8ae:	6685                	lui	a3,0x1
 8b0:	00d77363          	bgeu	a4,a3,8b6 <malloc+0x44>
 8b4:	6a05                	lui	s4,0x1
 8b6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ba:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8be:	00000917          	auipc	s2,0x0
 8c2:	74290913          	addi	s2,s2,1858 # 1000 <freep>
  if(p == (char*)-1)
 8c6:	5afd                	li	s5,-1
 8c8:	a081                	j	908 <malloc+0x96>
 8ca:	f04a                	sd	s2,32(sp)
 8cc:	e852                	sd	s4,16(sp)
 8ce:	e456                	sd	s5,8(sp)
 8d0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8d2:	00001797          	auipc	a5,0x1
 8d6:	93e78793          	addi	a5,a5,-1730 # 1210 <base>
 8da:	00000717          	auipc	a4,0x0
 8de:	72f73323          	sd	a5,1830(a4) # 1000 <freep>
 8e2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8e4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8e8:	b7c1                	j	8a8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8ea:	6398                	ld	a4,0(a5)
 8ec:	e118                	sd	a4,0(a0)
 8ee:	a8a9                	j	948 <malloc+0xd6>
  hp->s.size = nu;
 8f0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8f4:	0541                	addi	a0,a0,16
 8f6:	efbff0ef          	jal	7f0 <free>
  return freep;
 8fa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8fe:	c12d                	beqz	a0,960 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 900:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 902:	4798                	lw	a4,8(a5)
 904:	02977263          	bgeu	a4,s1,928 <malloc+0xb6>
    if(p == freep)
 908:	00093703          	ld	a4,0(s2)
 90c:	853e                	mv	a0,a5
 90e:	fef719e3          	bne	a4,a5,900 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 912:	8552                	mv	a0,s4
 914:	ae3ff0ef          	jal	3f6 <sbrk>
  if(p == (char*)-1)
 918:	fd551ce3          	bne	a0,s5,8f0 <malloc+0x7e>
        return 0;
 91c:	4501                	li	a0,0
 91e:	7902                	ld	s2,32(sp)
 920:	6a42                	ld	s4,16(sp)
 922:	6aa2                	ld	s5,8(sp)
 924:	6b02                	ld	s6,0(sp)
 926:	a03d                	j	954 <malloc+0xe2>
 928:	7902                	ld	s2,32(sp)
 92a:	6a42                	ld	s4,16(sp)
 92c:	6aa2                	ld	s5,8(sp)
 92e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 930:	fae48de3          	beq	s1,a4,8ea <malloc+0x78>
        p->s.size -= nunits;
 934:	4137073b          	subw	a4,a4,s3
 938:	c798                	sw	a4,8(a5)
        p += p->s.size;
 93a:	02071693          	slli	a3,a4,0x20
 93e:	01c6d713          	srli	a4,a3,0x1c
 942:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 944:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 948:	00000717          	auipc	a4,0x0
 94c:	6aa73c23          	sd	a0,1720(a4) # 1000 <freep>
      return (void*)(p + 1);
 950:	01078513          	addi	a0,a5,16
  }
}
 954:	70e2                	ld	ra,56(sp)
 956:	7442                	ld	s0,48(sp)
 958:	74a2                	ld	s1,40(sp)
 95a:	69e2                	ld	s3,24(sp)
 95c:	6121                	addi	sp,sp,64
 95e:	8082                	ret
 960:	7902                	ld	s2,32(sp)
 962:	6a42                	ld	s4,16(sp)
 964:	6aa2                	ld	s5,8(sp)
 966:	6b02                	ld	s6,0(sp)
 968:	b7f5                	j	954 <malloc+0xe2>
