
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
<<<<<<< Updated upstream
  24:	92050513          	addi	a0,a0,-1760 # 940 <malloc+0xfc>
  28:	768000ef          	jal	790 <printf>
=======
  24:	93050513          	addi	a0,a0,-1744 # 950 <malloc+0xfc>
  28:	778000ef          	jal	7a0 <printf>
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
  86:	92e50513          	addi	a0,a0,-1746 # 9b0 <malloc+0x16c>
  8a:	706000ef          	jal	790 <printf>
=======
  86:	93e50513          	addi	a0,a0,-1730 # 9c0 <malloc+0x16c>
  8a:	716000ef          	jal	7a0 <printf>
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
  aa:	8c250513          	addi	a0,a0,-1854 # 968 <malloc+0x124>
  ae:	6e2000ef          	jal	790 <printf>
=======
  aa:	8d250513          	addi	a0,a0,-1838 # 978 <malloc+0x124>
  ae:	6f2000ef          	jal	7a0 <printf>
>>>>>>> Stashed changes
        exit(0);
  b2:	4501                	li	a0,0
  b4:	2ac000ef          	jal	360 <exit>
        printf("cp: cannot open destination file %s\n", argv[2]);
  b8:	688c                	ld	a1,16(s1)
  ba:	00001517          	auipc	a0,0x1
<<<<<<< Updated upstream
  be:	8ce50513          	addi	a0,a0,-1842 # 988 <malloc+0x144>
  c2:	6ce000ef          	jal	790 <printf>
=======
  be:	8de50513          	addi	a0,a0,-1826 # 998 <malloc+0x144>
  c2:	6de000ef          	jal	7a0 <printf>
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
  ec:	8e050513          	addi	a0,a0,-1824 # 9c8 <malloc+0x184>
  f0:	6a0000ef          	jal	790 <printf>
=======
  ec:	8f050513          	addi	a0,a0,-1808 # 9d8 <malloc+0x184>
  f0:	6b0000ef          	jal	7a0 <printf>
>>>>>>> Stashed changes
  f4:	b7cd                	j	d6 <main+0xd6>

00000000000000f6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  extern int main();
  main();
  fe:	f03ff0ef          	jal	0 <main>
  exit(0);
 102:	4501                	li	a0,0
 104:	25c000ef          	jal	360 <exit>

0000000000000108 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e422                	sd	s0,8(sp)
 10c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 10e:	87aa                	mv	a5,a0
 110:	0585                	addi	a1,a1,1
 112:	0785                	addi	a5,a5,1
 114:	fff5c703          	lbu	a4,-1(a1)
 118:	fee78fa3          	sb	a4,-1(a5)
 11c:	fb75                	bnez	a4,110 <strcpy+0x8>
    ;
  return os;
}
 11e:	6422                	ld	s0,8(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret

0000000000000124 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 124:	1141                	addi	sp,sp,-16
 126:	e422                	sd	s0,8(sp)
 128:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 12a:	00054783          	lbu	a5,0(a0)
 12e:	cb91                	beqz	a5,142 <strcmp+0x1e>
 130:	0005c703          	lbu	a4,0(a1)
 134:	00f71763          	bne	a4,a5,142 <strcmp+0x1e>
    p++, q++;
 138:	0505                	addi	a0,a0,1
 13a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 13c:	00054783          	lbu	a5,0(a0)
 140:	fbe5                	bnez	a5,130 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 142:	0005c503          	lbu	a0,0(a1)
}
 146:	40a7853b          	subw	a0,a5,a0
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret

0000000000000150 <strlen>:

uint
strlen(const char *s)
{
 150:	1141                	addi	sp,sp,-16
 152:	e422                	sd	s0,8(sp)
 154:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
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
    ;
  return n;
}
 170:	6422                	ld	s0,8(sp)
 172:	0141                	addi	sp,sp,16
 174:	8082                	ret
  for(n = 0; s[n]; n++)
 176:	4501                	li	a0,0
 178:	bfe5                	j	170 <strlen+0x20>

000000000000017a <memset>:

void*
memset(void *dst, int c, uint n)
{
 17a:	1141                	addi	sp,sp,-16
 17c:	e422                	sd	s0,8(sp)
 17e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 180:	ca19                	beqz	a2,196 <memset+0x1c>
 182:	87aa                	mv	a5,a0
 184:	1602                	slli	a2,a2,0x20
 186:	9201                	srli	a2,a2,0x20
 188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 18c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 190:	0785                	addi	a5,a5,1
 192:	fee79de3          	bne	a5,a4,18c <memset+0x12>
  }
  return dst;
}
 196:	6422                	ld	s0,8(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret

000000000000019c <strchr>:

char*
strchr(const char *s, char c)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	cb99                	beqz	a5,1bc <strchr+0x20>
    if(*s == c)
 1a8:	00f58763          	beq	a1,a5,1b6 <strchr+0x1a>
  for(; *s; s++)
 1ac:	0505                	addi	a0,a0,1
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	fbfd                	bnez	a5,1a8 <strchr+0xc>
      return (char*)s;
  return 0;
 1b4:	4501                	li	a0,0
}
 1b6:	6422                	ld	s0,8(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret
  return 0;
 1bc:	4501                	li	a0,0
 1be:	bfe5                	j	1b6 <strchr+0x1a>

00000000000001c0 <gets>:

char*
gets(char *buf, int max)
{
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
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1da:	892a                	mv	s2,a0
 1dc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1de:	4aa9                	li	s5,10
 1e0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1e2:	89a6                	mv	s3,s1
 1e4:	2485                	addiw	s1,s1,1
 1e6:	0344d663          	bge	s1,s4,212 <gets+0x52>
    cc = read(0, &c, 1);
 1ea:	4605                	li	a2,1
 1ec:	faf40593          	addi	a1,s0,-81
 1f0:	4501                	li	a0,0
 1f2:	186000ef          	jal	378 <read>
    if(cc < 1)
 1f6:	00a05e63          	blez	a0,212 <gets+0x52>
    buf[i++] = c;
 1fa:	faf44783          	lbu	a5,-81(s0)
 1fe:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 202:	01578763          	beq	a5,s5,210 <gets+0x50>
 206:	0905                	addi	s2,s2,1
 208:	fd679de3          	bne	a5,s6,1e2 <gets+0x22>
    buf[i++] = c;
 20c:	89a6                	mv	s3,s1
 20e:	a011                	j	212 <gets+0x52>
 210:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 212:	99de                	add	s3,s3,s7
 214:	00098023          	sb	zero,0(s3)
  return buf;
}
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

int
stat(const char *n, struct stat *st)
{
 230:	1101                	addi	sp,sp,-32
 232:	ec06                	sd	ra,24(sp)
 234:	e822                	sd	s0,16(sp)
 236:	e04a                	sd	s2,0(sp)
 238:	1000                	addi	s0,sp,32
 23a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 23c:	4581                	li	a1,0
 23e:	162000ef          	jal	3a0 <open>
  if(fd < 0)
 242:	02054263          	bltz	a0,266 <stat+0x36>
 246:	e426                	sd	s1,8(sp)
 248:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 24a:	85ca                	mv	a1,s2
 24c:	16c000ef          	jal	3b8 <fstat>
 250:	892a                	mv	s2,a0
  close(fd);
 252:	8526                	mv	a0,s1
 254:	134000ef          	jal	388 <close>
  return r;
 258:	64a2                	ld	s1,8(sp)
}
 25a:	854a                	mv	a0,s2
 25c:	60e2                	ld	ra,24(sp)
 25e:	6442                	ld	s0,16(sp)
 260:	6902                	ld	s2,0(sp)
 262:	6105                	addi	sp,sp,32
 264:	8082                	ret
    return -1;
 266:	597d                	li	s2,-1
 268:	bfcd                	j	25a <stat+0x2a>

000000000000026a <atoi>:

int
atoi(const char *s)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 270:	00054683          	lbu	a3,0(a0)
 274:	fd06879b          	addiw	a5,a3,-48
 278:	0ff7f793          	zext.b	a5,a5
 27c:	4625                	li	a2,9
 27e:	02f66863          	bltu	a2,a5,2ae <atoi+0x44>
 282:	872a                	mv	a4,a0
  n = 0;
 284:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 286:	0705                	addi	a4,a4,1
 288:	0025179b          	slliw	a5,a0,0x2
 28c:	9fa9                	addw	a5,a5,a0
 28e:	0017979b          	slliw	a5,a5,0x1
 292:	9fb5                	addw	a5,a5,a3
 294:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 298:	00074683          	lbu	a3,0(a4)
 29c:	fd06879b          	addiw	a5,a3,-48
 2a0:	0ff7f793          	zext.b	a5,a5
 2a4:	fef671e3          	bgeu	a2,a5,286 <atoi+0x1c>
  return n;
}
 2a8:	6422                	ld	s0,8(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret
  n = 0;
 2ae:	4501                	li	a0,0
 2b0:	bfe5                	j	2a8 <atoi+0x3e>

00000000000002b2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b8:	02b57463          	bgeu	a0,a1,2e0 <memmove+0x2e>
    while(n-- > 0)
 2bc:	00c05f63          	blez	a2,2da <memmove+0x28>
 2c0:	1602                	slli	a2,a2,0x20
 2c2:	9201                	srli	a2,a2,0x20
 2c4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ca:	0585                	addi	a1,a1,1
 2cc:	0705                	addi	a4,a4,1
 2ce:	fff5c683          	lbu	a3,-1(a1)
 2d2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2d6:	fef71ae3          	bne	a4,a5,2ca <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
    dst += n;
 2e0:	00c50733          	add	a4,a0,a2
    src += n;
 2e4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2e6:	fec05ae3          	blez	a2,2da <memmove+0x28>
 2ea:	fff6079b          	addiw	a5,a2,-1
 2ee:	1782                	slli	a5,a5,0x20
 2f0:	9381                	srli	a5,a5,0x20
 2f2:	fff7c793          	not	a5,a5
 2f6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f8:	15fd                	addi	a1,a1,-1
 2fa:	177d                	addi	a4,a4,-1
 2fc:	0005c683          	lbu	a3,0(a1)
 300:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 304:	fee79ae3          	bne	a5,a4,2f8 <memmove+0x46>
 308:	bfc9                	j	2da <memmove+0x28>

000000000000030a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 310:	ca05                	beqz	a2,340 <memcmp+0x36>
 312:	fff6069b          	addiw	a3,a2,-1
 316:	1682                	slli	a3,a3,0x20
 318:	9281                	srli	a3,a3,0x20
 31a:	0685                	addi	a3,a3,1
 31c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 31e:	00054783          	lbu	a5,0(a0)
 322:	0005c703          	lbu	a4,0(a1)
 326:	00e79863          	bne	a5,a4,336 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 32a:	0505                	addi	a0,a0,1
    p2++;
 32c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 32e:	fed518e3          	bne	a0,a3,31e <memcmp+0x14>
  }
  return 0;
 332:	4501                	li	a0,0
 334:	a019                	j	33a <memcmp+0x30>
      return *p1 - *p2;
 336:	40e7853b          	subw	a0,a5,a4
}
 33a:	6422                	ld	s0,8(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret
  return 0;
 340:	4501                	li	a0,0
 342:	bfe5                	j	33a <memcmp+0x30>

0000000000000344 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 344:	1141                	addi	sp,sp,-16
 346:	e406                	sd	ra,8(sp)
 348:	e022                	sd	s0,0(sp)
 34a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 34c:	f67ff0ef          	jal	2b2 <memmove>
}
 350:	60a2                	ld	ra,8(sp)
 352:	6402                	ld	s0,0(sp)
 354:	0141                	addi	sp,sp,16
 356:	8082                	ret

0000000000000358 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 358:	4885                	li	a7,1
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <exit>:
.global exit
exit:
 li a7, SYS_exit
 360:	4889                	li	a7,2
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <wait>:
.global wait
wait:
 li a7, SYS_wait
 368:	488d                	li	a7,3
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 370:	4891                	li	a7,4
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <read>:
.global read
read:
 li a7, SYS_read
 378:	4895                	li	a7,5
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <write>:
.global write
write:
 li a7, SYS_write
 380:	48c1                	li	a7,16
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <close>:
.global close
close:
 li a7, SYS_close
 388:	48d5                	li	a7,21
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <kill>:
.global kill
kill:
 li a7, SYS_kill
 390:	4899                	li	a7,6
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <exec>:
.global exec
exec:
 li a7, SYS_exec
 398:	489d                	li	a7,7
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <open>:
.global open
open:
 li a7, SYS_open
 3a0:	48bd                	li	a7,15
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3a8:	48c5                	li	a7,17
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3b0:	48c9                	li	a7,18
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3b8:	48a1                	li	a7,8
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <link>:
.global link
link:
 li a7, SYS_link
 3c0:	48cd                	li	a7,19
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3c8:	48d1                	li	a7,20
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3d0:	48a5                	li	a7,9
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3d8:	48a9                	li	a7,10
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3e0:	48ad                	li	a7,11
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3e8:	48b1                	li	a7,12
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3f0:	48b5                	li	a7,13
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3f8:	48b9                	li	a7,14
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 400:	48d9                	li	a7,22
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 408:	48dd                	li	a7,23
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 410:	48e1                	li	a7,24
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <putc>:
 418:	1101                	addi	sp,sp,-32
 41a:	ec06                	sd	ra,24(sp)
 41c:	e822                	sd	s0,16(sp)
 41e:	1000                	addi	s0,sp,32
 420:	feb407a3          	sb	a1,-17(s0)
 424:	4605                	li	a2,1
 426:	fef40593          	addi	a1,s0,-17
 42a:	f57ff0ef          	jal	380 <write>
 42e:	60e2                	ld	ra,24(sp)
 430:	6442                	ld	s0,16(sp)
 432:	6105                	addi	sp,sp,32
 434:	8082                	ret

<<<<<<< Updated upstream
0000000000000436 <printint>:
 436:	7139                	addi	sp,sp,-64
 438:	fc06                	sd	ra,56(sp)
 43a:	f822                	sd	s0,48(sp)
 43c:	f426                	sd	s1,40(sp)
 43e:	0080                	addi	s0,sp,64
 440:	84aa                	mv	s1,a0
 442:	c299                	beqz	a3,448 <printint+0x12>
 444:	0805c963          	bltz	a1,4d6 <printint+0xa0>
 448:	2581                	sext.w	a1,a1
 44a:	4881                	li	a7,0
 44c:	fc040693          	addi	a3,s0,-64
 450:	4701                	li	a4,0
 452:	2601                	sext.w	a2,a2
 454:	00000517          	auipc	a0,0x0
 458:	58c50513          	addi	a0,a0,1420 # 9e0 <digits>
 45c:	883a                	mv	a6,a4
 45e:	2705                	addiw	a4,a4,1
 460:	02c5f7bb          	remuw	a5,a1,a2
 464:	1782                	slli	a5,a5,0x20
 466:	9381                	srli	a5,a5,0x20
 468:	97aa                	add	a5,a5,a0
 46a:	0007c783          	lbu	a5,0(a5)
 46e:	00f68023          	sb	a5,0(a3)
 472:	0005879b          	sext.w	a5,a1
 476:	02c5d5bb          	divuw	a1,a1,a2
 47a:	0685                	addi	a3,a3,1
 47c:	fec7f0e3          	bgeu	a5,a2,45c <printint+0x26>
 480:	00088c63          	beqz	a7,498 <printint+0x62>
 484:	fd070793          	addi	a5,a4,-48
 488:	00878733          	add	a4,a5,s0
 48c:	02d00793          	li	a5,45
 490:	fef70823          	sb	a5,-16(a4)
 494:	0028071b          	addiw	a4,a6,2
 498:	02e05a63          	blez	a4,4cc <printint+0x96>
 49c:	f04a                	sd	s2,32(sp)
 49e:	ec4e                	sd	s3,24(sp)
 4a0:	fc040793          	addi	a5,s0,-64
 4a4:	00e78933          	add	s2,a5,a4
 4a8:	fff78993          	addi	s3,a5,-1
 4ac:	99ba                	add	s3,s3,a4
 4ae:	377d                	addiw	a4,a4,-1
 4b0:	1702                	slli	a4,a4,0x20
 4b2:	9301                	srli	a4,a4,0x20
 4b4:	40e989b3          	sub	s3,s3,a4
 4b8:	fff94583          	lbu	a1,-1(s2)
 4bc:	8526                	mv	a0,s1
 4be:	f5bff0ef          	jal	418 <putc>
 4c2:	197d                	addi	s2,s2,-1
 4c4:	ff391ae3          	bne	s2,s3,4b8 <printint+0x82>
 4c8:	7902                	ld	s2,32(sp)
 4ca:	69e2                	ld	s3,24(sp)
 4cc:	70e2                	ld	ra,56(sp)
 4ce:	7442                	ld	s0,48(sp)
 4d0:	74a2                	ld	s1,40(sp)
 4d2:	6121                	addi	sp,sp,64
 4d4:	8082                	ret
 4d6:	40b005bb          	negw	a1,a1
 4da:	4885                	li	a7,1
 4dc:	bf85                	j	44c <printint+0x16>

00000000000004de <vprintf>:
 4de:	711d                	addi	sp,sp,-96
 4e0:	ec86                	sd	ra,88(sp)
 4e2:	e8a2                	sd	s0,80(sp)
 4e4:	e0ca                	sd	s2,64(sp)
 4e6:	1080                	addi	s0,sp,96
 4e8:	0005c903          	lbu	s2,0(a1)
 4ec:	26090863          	beqz	s2,75c <vprintf+0x27e>
 4f0:	e4a6                	sd	s1,72(sp)
 4f2:	fc4e                	sd	s3,56(sp)
 4f4:	f852                	sd	s4,48(sp)
 4f6:	f456                	sd	s5,40(sp)
 4f8:	f05a                	sd	s6,32(sp)
 4fa:	ec5e                	sd	s7,24(sp)
 4fc:	e862                	sd	s8,16(sp)
 4fe:	e466                	sd	s9,8(sp)
 500:	8b2a                	mv	s6,a0
 502:	8a2e                	mv	s4,a1
 504:	8bb2                	mv	s7,a2
 506:	4981                	li	s3,0
 508:	4481                	li	s1,0
 50a:	4701                	li	a4,0
 50c:	02500a93          	li	s5,37
 510:	06400c13          	li	s8,100
 514:	06c00c93          	li	s9,108
 518:	a005                	j	538 <vprintf+0x5a>
 51a:	85ca                	mv	a1,s2
 51c:	855a                	mv	a0,s6
 51e:	efbff0ef          	jal	418 <putc>
 522:	a019                	j	528 <vprintf+0x4a>
 524:	03598263          	beq	s3,s5,548 <vprintf+0x6a>
 528:	2485                	addiw	s1,s1,1
 52a:	8726                	mv	a4,s1
 52c:	009a07b3          	add	a5,s4,s1
 530:	0007c903          	lbu	s2,0(a5)
 534:	20090c63          	beqz	s2,74c <vprintf+0x26e>
 538:	0009079b          	sext.w	a5,s2
 53c:	fe0994e3          	bnez	s3,524 <vprintf+0x46>
 540:	fd579de3          	bne	a5,s5,51a <vprintf+0x3c>
 544:	89be                	mv	s3,a5
 546:	b7cd                	j	528 <vprintf+0x4a>
 548:	00ea06b3          	add	a3,s4,a4
 54c:	0016c683          	lbu	a3,1(a3)
 550:	8636                	mv	a2,a3
 552:	c681                	beqz	a3,55a <vprintf+0x7c>
 554:	9752                	add	a4,a4,s4
 556:	00274603          	lbu	a2,2(a4)
 55a:	03878f63          	beq	a5,s8,598 <vprintf+0xba>
 55e:	05978963          	beq	a5,s9,5b0 <vprintf+0xd2>
 562:	07500713          	li	a4,117
 566:	0ee78363          	beq	a5,a4,64c <vprintf+0x16e>
 56a:	07800713          	li	a4,120
 56e:	12e78563          	beq	a5,a4,698 <vprintf+0x1ba>
 572:	07000713          	li	a4,112
 576:	14e78a63          	beq	a5,a4,6ca <vprintf+0x1ec>
 57a:	07300713          	li	a4,115
 57e:	18e78a63          	beq	a5,a4,712 <vprintf+0x234>
 582:	02500713          	li	a4,37
 586:	04e79563          	bne	a5,a4,5d0 <vprintf+0xf2>
 58a:	02500593          	li	a1,37
 58e:	855a                	mv	a0,s6
 590:	e89ff0ef          	jal	418 <putc>
 594:	4981                	li	s3,0
 596:	bf49                	j	528 <vprintf+0x4a>
 598:	008b8913          	addi	s2,s7,8
 59c:	4685                	li	a3,1
 59e:	4629                	li	a2,10
 5a0:	000ba583          	lw	a1,0(s7)
 5a4:	855a                	mv	a0,s6
 5a6:	e91ff0ef          	jal	436 <printint>
 5aa:	8bca                	mv	s7,s2
 5ac:	4981                	li	s3,0
 5ae:	bfad                	j	528 <vprintf+0x4a>
 5b0:	06400793          	li	a5,100
 5b4:	02f68963          	beq	a3,a5,5e6 <vprintf+0x108>
 5b8:	06c00793          	li	a5,108
 5bc:	04f68263          	beq	a3,a5,600 <vprintf+0x122>
 5c0:	07500793          	li	a5,117
 5c4:	0af68063          	beq	a3,a5,664 <vprintf+0x186>
 5c8:	07800793          	li	a5,120
 5cc:	0ef68263          	beq	a3,a5,6b0 <vprintf+0x1d2>
 5d0:	02500593          	li	a1,37
 5d4:	855a                	mv	a0,s6
 5d6:	e43ff0ef          	jal	418 <putc>
 5da:	85ca                	mv	a1,s2
 5dc:	855a                	mv	a0,s6
 5de:	e3bff0ef          	jal	418 <putc>
 5e2:	4981                	li	s3,0
 5e4:	b791                	j	528 <vprintf+0x4a>
 5e6:	008b8913          	addi	s2,s7,8
 5ea:	4685                	li	a3,1
 5ec:	4629                	li	a2,10
 5ee:	000ba583          	lw	a1,0(s7)
 5f2:	855a                	mv	a0,s6
 5f4:	e43ff0ef          	jal	436 <printint>
 5f8:	2485                	addiw	s1,s1,1
 5fa:	8bca                	mv	s7,s2
 5fc:	4981                	li	s3,0
 5fe:	b72d                	j	528 <vprintf+0x4a>
 600:	06400793          	li	a5,100
 604:	02f60763          	beq	a2,a5,632 <vprintf+0x154>
 608:	07500793          	li	a5,117
 60c:	06f60963          	beq	a2,a5,67e <vprintf+0x1a0>
 610:	07800793          	li	a5,120
 614:	faf61ee3          	bne	a2,a5,5d0 <vprintf+0xf2>
 618:	008b8913          	addi	s2,s7,8
 61c:	4681                	li	a3,0
 61e:	4641                	li	a2,16
 620:	000ba583          	lw	a1,0(s7)
 624:	855a                	mv	a0,s6
 626:	e11ff0ef          	jal	436 <printint>
 62a:	2489                	addiw	s1,s1,2
 62c:	8bca                	mv	s7,s2
 62e:	4981                	li	s3,0
 630:	bde5                	j	528 <vprintf+0x4a>
 632:	008b8913          	addi	s2,s7,8
 636:	4685                	li	a3,1
 638:	4629                	li	a2,10
 63a:	000ba583          	lw	a1,0(s7)
 63e:	855a                	mv	a0,s6
 640:	df7ff0ef          	jal	436 <printint>
 644:	2489                	addiw	s1,s1,2
 646:	8bca                	mv	s7,s2
 648:	4981                	li	s3,0
 64a:	bdf9                	j	528 <vprintf+0x4a>
 64c:	008b8913          	addi	s2,s7,8
 650:	4681                	li	a3,0
 652:	4629                	li	a2,10
 654:	000ba583          	lw	a1,0(s7)
 658:	855a                	mv	a0,s6
 65a:	dddff0ef          	jal	436 <printint>
 65e:	8bca                	mv	s7,s2
 660:	4981                	li	s3,0
 662:	b5d9                	j	528 <vprintf+0x4a>
 664:	008b8913          	addi	s2,s7,8
 668:	4681                	li	a3,0
 66a:	4629                	li	a2,10
 66c:	000ba583          	lw	a1,0(s7)
 670:	855a                	mv	a0,s6
 672:	dc5ff0ef          	jal	436 <printint>
 676:	2485                	addiw	s1,s1,1
 678:	8bca                	mv	s7,s2
 67a:	4981                	li	s3,0
 67c:	b575                	j	528 <vprintf+0x4a>
 67e:	008b8913          	addi	s2,s7,8
 682:	4681                	li	a3,0
 684:	4629                	li	a2,10
 686:	000ba583          	lw	a1,0(s7)
 68a:	855a                	mv	a0,s6
 68c:	dabff0ef          	jal	436 <printint>
 690:	2489                	addiw	s1,s1,2
 692:	8bca                	mv	s7,s2
 694:	4981                	li	s3,0
 696:	bd49                	j	528 <vprintf+0x4a>
 698:	008b8913          	addi	s2,s7,8
 69c:	4681                	li	a3,0
 69e:	4641                	li	a2,16
 6a0:	000ba583          	lw	a1,0(s7)
 6a4:	855a                	mv	a0,s6
 6a6:	d91ff0ef          	jal	436 <printint>
 6aa:	8bca                	mv	s7,s2
 6ac:	4981                	li	s3,0
 6ae:	bdad                	j	528 <vprintf+0x4a>
 6b0:	008b8913          	addi	s2,s7,8
 6b4:	4681                	li	a3,0
 6b6:	4641                	li	a2,16
 6b8:	000ba583          	lw	a1,0(s7)
 6bc:	855a                	mv	a0,s6
 6be:	d79ff0ef          	jal	436 <printint>
 6c2:	2485                	addiw	s1,s1,1
 6c4:	8bca                	mv	s7,s2
 6c6:	4981                	li	s3,0
 6c8:	b585                	j	528 <vprintf+0x4a>
 6ca:	e06a                	sd	s10,0(sp)
 6cc:	008b8d13          	addi	s10,s7,8
 6d0:	000bb983          	ld	s3,0(s7)
 6d4:	03000593          	li	a1,48
 6d8:	855a                	mv	a0,s6
 6da:	d3fff0ef          	jal	418 <putc>
 6de:	07800593          	li	a1,120
 6e2:	855a                	mv	a0,s6
 6e4:	d35ff0ef          	jal	418 <putc>
 6e8:	4941                	li	s2,16
 6ea:	00000b97          	auipc	s7,0x0
 6ee:	2f6b8b93          	addi	s7,s7,758 # 9e0 <digits>
 6f2:	03c9d793          	srli	a5,s3,0x3c
 6f6:	97de                	add	a5,a5,s7
 6f8:	0007c583          	lbu	a1,0(a5)
 6fc:	855a                	mv	a0,s6
 6fe:	d1bff0ef          	jal	418 <putc>
 702:	0992                	slli	s3,s3,0x4
 704:	397d                	addiw	s2,s2,-1
 706:	fe0916e3          	bnez	s2,6f2 <vprintf+0x214>
 70a:	8bea                	mv	s7,s10
 70c:	4981                	li	s3,0
 70e:	6d02                	ld	s10,0(sp)
 710:	bd21                	j	528 <vprintf+0x4a>
 712:	008b8993          	addi	s3,s7,8
 716:	000bb903          	ld	s2,0(s7)
 71a:	00090f63          	beqz	s2,738 <vprintf+0x25a>
 71e:	00094583          	lbu	a1,0(s2)
 722:	c195                	beqz	a1,746 <vprintf+0x268>
 724:	855a                	mv	a0,s6
 726:	cf3ff0ef          	jal	418 <putc>
 72a:	0905                	addi	s2,s2,1
 72c:	00094583          	lbu	a1,0(s2)
 730:	f9f5                	bnez	a1,724 <vprintf+0x246>
 732:	8bce                	mv	s7,s3
 734:	4981                	li	s3,0
 736:	bbcd                	j	528 <vprintf+0x4a>
 738:	00000917          	auipc	s2,0x0
 73c:	2a090913          	addi	s2,s2,672 # 9d8 <malloc+0x194>
 740:	02800593          	li	a1,40
 744:	b7c5                	j	724 <vprintf+0x246>
 746:	8bce                	mv	s7,s3
 748:	4981                	li	s3,0
 74a:	bbf9                	j	528 <vprintf+0x4a>
 74c:	64a6                	ld	s1,72(sp)
 74e:	79e2                	ld	s3,56(sp)
 750:	7a42                	ld	s4,48(sp)
 752:	7aa2                	ld	s5,40(sp)
 754:	7b02                	ld	s6,32(sp)
 756:	6be2                	ld	s7,24(sp)
 758:	6c42                	ld	s8,16(sp)
 75a:	6ca2                	ld	s9,8(sp)
 75c:	60e6                	ld	ra,88(sp)
 75e:	6446                	ld	s0,80(sp)
 760:	6906                	ld	s2,64(sp)
 762:	6125                	addi	sp,sp,96
 764:	8082                	ret

0000000000000766 <fprintf>:
 766:	715d                	addi	sp,sp,-80
 768:	ec06                	sd	ra,24(sp)
 76a:	e822                	sd	s0,16(sp)
 76c:	1000                	addi	s0,sp,32
 76e:	e010                	sd	a2,0(s0)
 770:	e414                	sd	a3,8(s0)
 772:	e818                	sd	a4,16(s0)
 774:	ec1c                	sd	a5,24(s0)
 776:	03043023          	sd	a6,32(s0)
 77a:	03143423          	sd	a7,40(s0)
 77e:	fe843423          	sd	s0,-24(s0)
 782:	8622                	mv	a2,s0
 784:	d5bff0ef          	jal	4de <vprintf>
 788:	60e2                	ld	ra,24(sp)
 78a:	6442                	ld	s0,16(sp)
 78c:	6161                	addi	sp,sp,80
 78e:	8082                	ret

0000000000000790 <printf>:
 790:	711d                	addi	sp,sp,-96
 792:	ec06                	sd	ra,24(sp)
 794:	e822                	sd	s0,16(sp)
 796:	1000                	addi	s0,sp,32
 798:	e40c                	sd	a1,8(s0)
 79a:	e810                	sd	a2,16(s0)
 79c:	ec14                	sd	a3,24(s0)
 79e:	f018                	sd	a4,32(s0)
 7a0:	f41c                	sd	a5,40(s0)
 7a2:	03043823          	sd	a6,48(s0)
 7a6:	03143c23          	sd	a7,56(s0)
 7aa:	00840613          	addi	a2,s0,8
 7ae:	fec43423          	sd	a2,-24(s0)
 7b2:	85aa                	mv	a1,a0
 7b4:	4505                	li	a0,1
 7b6:	d29ff0ef          	jal	4de <vprintf>
 7ba:	60e2                	ld	ra,24(sp)
 7bc:	6442                	ld	s0,16(sp)
 7be:	6125                	addi	sp,sp,96
 7c0:	8082                	ret

00000000000007c2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c2:	1141                	addi	sp,sp,-16
 7c4:	e422                	sd	s0,8(sp)
 7c6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7cc:	00001797          	auipc	a5,0x1
 7d0:	8347b783          	ld	a5,-1996(a5) # 1000 <freep>
 7d4:	a02d                	j	7fe <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7d6:	4618                	lw	a4,8(a2)
 7d8:	9f2d                	addw	a4,a4,a1
 7da:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7de:	6398                	ld	a4,0(a5)
 7e0:	6310                	ld	a2,0(a4)
 7e2:	a83d                	j	820 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7e4:	ff852703          	lw	a4,-8(a0)
 7e8:	9f31                	addw	a4,a4,a2
 7ea:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ec:	ff053683          	ld	a3,-16(a0)
 7f0:	a091                	j	834 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f2:	6398                	ld	a4,0(a5)
 7f4:	00e7e463          	bltu	a5,a4,7fc <free+0x3a>
 7f8:	00e6ea63          	bltu	a3,a4,80c <free+0x4a>
{
 7fc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fe:	fed7fae3          	bgeu	a5,a3,7f2 <free+0x30>
 802:	6398                	ld	a4,0(a5)
 804:	00e6e463          	bltu	a3,a4,80c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 808:	fee7eae3          	bltu	a5,a4,7fc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 80c:	ff852583          	lw	a1,-8(a0)
 810:	6390                	ld	a2,0(a5)
 812:	02059813          	slli	a6,a1,0x20
 816:	01c85713          	srli	a4,a6,0x1c
 81a:	9736                	add	a4,a4,a3
 81c:	fae60de3          	beq	a2,a4,7d6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 820:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 824:	4790                	lw	a2,8(a5)
 826:	02061593          	slli	a1,a2,0x20
 82a:	01c5d713          	srli	a4,a1,0x1c
 82e:	973e                	add	a4,a4,a5
 830:	fae68ae3          	beq	a3,a4,7e4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 834:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 836:	00000717          	auipc	a4,0x0
 83a:	7cf73523          	sd	a5,1994(a4) # 1000 <freep>
}
 83e:	6422                	ld	s0,8(sp)
 840:	0141                	addi	sp,sp,16
 842:	8082                	ret

0000000000000844 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 844:	7139                	addi	sp,sp,-64
 846:	fc06                	sd	ra,56(sp)
 848:	f822                	sd	s0,48(sp)
 84a:	f426                	sd	s1,40(sp)
 84c:	ec4e                	sd	s3,24(sp)
 84e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 850:	02051493          	slli	s1,a0,0x20
 854:	9081                	srli	s1,s1,0x20
 856:	04bd                	addi	s1,s1,15
 858:	8091                	srli	s1,s1,0x4
 85a:	0014899b          	addiw	s3,s1,1
 85e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 860:	00000517          	auipc	a0,0x0
 864:	7a053503          	ld	a0,1952(a0) # 1000 <freep>
 868:	c915                	beqz	a0,89c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86c:	4798                	lw	a4,8(a5)
 86e:	08977a63          	bgeu	a4,s1,902 <malloc+0xbe>
 872:	f04a                	sd	s2,32(sp)
 874:	e852                	sd	s4,16(sp)
 876:	e456                	sd	s5,8(sp)
 878:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 87a:	8a4e                	mv	s4,s3
 87c:	0009871b          	sext.w	a4,s3
 880:	6685                	lui	a3,0x1
 882:	00d77363          	bgeu	a4,a3,888 <malloc+0x44>
 886:	6a05                	lui	s4,0x1
 888:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 88c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
=======
0000000000000420 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 420:	48e9                	li	a7,26
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 428:	1101                	addi	sp,sp,-32
 42a:	ec06                	sd	ra,24(sp)
 42c:	e822                	sd	s0,16(sp)
 42e:	1000                	addi	s0,sp,32
 430:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 434:	4605                	li	a2,1
 436:	fef40593          	addi	a1,s0,-17
 43a:	f47ff0ef          	jal	380 <write>
}
 43e:	60e2                	ld	ra,24(sp)
 440:	6442                	ld	s0,16(sp)
 442:	6105                	addi	sp,sp,32
 444:	8082                	ret

0000000000000446 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 446:	7139                	addi	sp,sp,-64
 448:	fc06                	sd	ra,56(sp)
 44a:	f822                	sd	s0,48(sp)
 44c:	f426                	sd	s1,40(sp)
 44e:	0080                	addi	s0,sp,64
 450:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 452:	c299                	beqz	a3,458 <printint+0x12>
 454:	0805c963          	bltz	a1,4e6 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 458:	2581                	sext.w	a1,a1
  neg = 0;
 45a:	4881                	li	a7,0
 45c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 460:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 462:	2601                	sext.w	a2,a2
 464:	00000517          	auipc	a0,0x0
 468:	58c50513          	addi	a0,a0,1420 # 9f0 <digits>
 46c:	883a                	mv	a6,a4
 46e:	2705                	addiw	a4,a4,1
 470:	02c5f7bb          	remuw	a5,a1,a2
 474:	1782                	slli	a5,a5,0x20
 476:	9381                	srli	a5,a5,0x20
 478:	97aa                	add	a5,a5,a0
 47a:	0007c783          	lbu	a5,0(a5)
 47e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 482:	0005879b          	sext.w	a5,a1
 486:	02c5d5bb          	divuw	a1,a1,a2
 48a:	0685                	addi	a3,a3,1
 48c:	fec7f0e3          	bgeu	a5,a2,46c <printint+0x26>
  if(neg)
 490:	00088c63          	beqz	a7,4a8 <printint+0x62>
    buf[i++] = '-';
 494:	fd070793          	addi	a5,a4,-48
 498:	00878733          	add	a4,a5,s0
 49c:	02d00793          	li	a5,45
 4a0:	fef70823          	sb	a5,-16(a4)
 4a4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4a8:	02e05a63          	blez	a4,4dc <printint+0x96>
 4ac:	f04a                	sd	s2,32(sp)
 4ae:	ec4e                	sd	s3,24(sp)
 4b0:	fc040793          	addi	a5,s0,-64
 4b4:	00e78933          	add	s2,a5,a4
 4b8:	fff78993          	addi	s3,a5,-1
 4bc:	99ba                	add	s3,s3,a4
 4be:	377d                	addiw	a4,a4,-1
 4c0:	1702                	slli	a4,a4,0x20
 4c2:	9301                	srli	a4,a4,0x20
 4c4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4c8:	fff94583          	lbu	a1,-1(s2)
 4cc:	8526                	mv	a0,s1
 4ce:	f5bff0ef          	jal	428 <putc>
  while(--i >= 0)
 4d2:	197d                	addi	s2,s2,-1
 4d4:	ff391ae3          	bne	s2,s3,4c8 <printint+0x82>
 4d8:	7902                	ld	s2,32(sp)
 4da:	69e2                	ld	s3,24(sp)
}
 4dc:	70e2                	ld	ra,56(sp)
 4de:	7442                	ld	s0,48(sp)
 4e0:	74a2                	ld	s1,40(sp)
 4e2:	6121                	addi	sp,sp,64
 4e4:	8082                	ret
    x = -xx;
 4e6:	40b005bb          	negw	a1,a1
    neg = 1;
 4ea:	4885                	li	a7,1
    x = -xx;
 4ec:	bf85                	j	45c <printint+0x16>

00000000000004ee <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ee:	711d                	addi	sp,sp,-96
 4f0:	ec86                	sd	ra,88(sp)
 4f2:	e8a2                	sd	s0,80(sp)
 4f4:	e0ca                	sd	s2,64(sp)
 4f6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f8:	0005c903          	lbu	s2,0(a1)
 4fc:	26090863          	beqz	s2,76c <vprintf+0x27e>
 500:	e4a6                	sd	s1,72(sp)
 502:	fc4e                	sd	s3,56(sp)
 504:	f852                	sd	s4,48(sp)
 506:	f456                	sd	s5,40(sp)
 508:	f05a                	sd	s6,32(sp)
 50a:	ec5e                	sd	s7,24(sp)
 50c:	e862                	sd	s8,16(sp)
 50e:	e466                	sd	s9,8(sp)
 510:	8b2a                	mv	s6,a0
 512:	8a2e                	mv	s4,a1
 514:	8bb2                	mv	s7,a2
  state = 0;
 516:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 518:	4481                	li	s1,0
 51a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 51c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 520:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 524:	06c00c93          	li	s9,108
 528:	a005                	j	548 <vprintf+0x5a>
        putc(fd, c0);
 52a:	85ca                	mv	a1,s2
 52c:	855a                	mv	a0,s6
 52e:	efbff0ef          	jal	428 <putc>
 532:	a019                	j	538 <vprintf+0x4a>
    } else if(state == '%'){
 534:	03598263          	beq	s3,s5,558 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 538:	2485                	addiw	s1,s1,1
 53a:	8726                	mv	a4,s1
 53c:	009a07b3          	add	a5,s4,s1
 540:	0007c903          	lbu	s2,0(a5)
 544:	20090c63          	beqz	s2,75c <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 548:	0009079b          	sext.w	a5,s2
    if(state == 0){
 54c:	fe0994e3          	bnez	s3,534 <vprintf+0x46>
      if(c0 == '%'){
 550:	fd579de3          	bne	a5,s5,52a <vprintf+0x3c>
        state = '%';
 554:	89be                	mv	s3,a5
 556:	b7cd                	j	538 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 558:	00ea06b3          	add	a3,s4,a4
 55c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 560:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 562:	c681                	beqz	a3,56a <vprintf+0x7c>
 564:	9752                	add	a4,a4,s4
 566:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 56a:	03878f63          	beq	a5,s8,5a8 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 56e:	05978963          	beq	a5,s9,5c0 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 572:	07500713          	li	a4,117
 576:	0ee78363          	beq	a5,a4,65c <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 57a:	07800713          	li	a4,120
 57e:	12e78563          	beq	a5,a4,6a8 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 582:	07000713          	li	a4,112
 586:	14e78a63          	beq	a5,a4,6da <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 58a:	07300713          	li	a4,115
 58e:	18e78a63          	beq	a5,a4,722 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 592:	02500713          	li	a4,37
 596:	04e79563          	bne	a5,a4,5e0 <vprintf+0xf2>
        putc(fd, '%');
 59a:	02500593          	li	a1,37
 59e:	855a                	mv	a0,s6
 5a0:	e89ff0ef          	jal	428 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	bf49                	j	538 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5a8:	008b8913          	addi	s2,s7,8
 5ac:	4685                	li	a3,1
 5ae:	4629                	li	a2,10
 5b0:	000ba583          	lw	a1,0(s7)
 5b4:	855a                	mv	a0,s6
 5b6:	e91ff0ef          	jal	446 <printint>
 5ba:	8bca                	mv	s7,s2
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	bfad                	j	538 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5c0:	06400793          	li	a5,100
 5c4:	02f68963          	beq	a3,a5,5f6 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5c8:	06c00793          	li	a5,108
 5cc:	04f68263          	beq	a3,a5,610 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5d0:	07500793          	li	a5,117
 5d4:	0af68063          	beq	a3,a5,674 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5d8:	07800793          	li	a5,120
 5dc:	0ef68263          	beq	a3,a5,6c0 <vprintf+0x1d2>
        putc(fd, '%');
 5e0:	02500593          	li	a1,37
 5e4:	855a                	mv	a0,s6
 5e6:	e43ff0ef          	jal	428 <putc>
        putc(fd, c0);
 5ea:	85ca                	mv	a1,s2
 5ec:	855a                	mv	a0,s6
 5ee:	e3bff0ef          	jal	428 <putc>
      state = 0;
 5f2:	4981                	li	s3,0
 5f4:	b791                	j	538 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f6:	008b8913          	addi	s2,s7,8
 5fa:	4685                	li	a3,1
 5fc:	4629                	li	a2,10
 5fe:	000ba583          	lw	a1,0(s7)
 602:	855a                	mv	a0,s6
 604:	e43ff0ef          	jal	446 <printint>
        i += 1;
 608:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 60a:	8bca                	mv	s7,s2
      state = 0;
 60c:	4981                	li	s3,0
        i += 1;
 60e:	b72d                	j	538 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 610:	06400793          	li	a5,100
 614:	02f60763          	beq	a2,a5,642 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 618:	07500793          	li	a5,117
 61c:	06f60963          	beq	a2,a5,68e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 620:	07800793          	li	a5,120
 624:	faf61ee3          	bne	a2,a5,5e0 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 628:	008b8913          	addi	s2,s7,8
 62c:	4681                	li	a3,0
 62e:	4641                	li	a2,16
 630:	000ba583          	lw	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	e11ff0ef          	jal	446 <printint>
        i += 2;
 63a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 63c:	8bca                	mv	s7,s2
      state = 0;
 63e:	4981                	li	s3,0
        i += 2;
 640:	bde5                	j	538 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 642:	008b8913          	addi	s2,s7,8
 646:	4685                	li	a3,1
 648:	4629                	li	a2,10
 64a:	000ba583          	lw	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	df7ff0ef          	jal	446 <printint>
        i += 2;
 654:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 656:	8bca                	mv	s7,s2
      state = 0;
 658:	4981                	li	s3,0
        i += 2;
 65a:	bdf9                	j	538 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 65c:	008b8913          	addi	s2,s7,8
 660:	4681                	li	a3,0
 662:	4629                	li	a2,10
 664:	000ba583          	lw	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	dddff0ef          	jal	446 <printint>
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
 672:	b5d9                	j	538 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 674:	008b8913          	addi	s2,s7,8
 678:	4681                	li	a3,0
 67a:	4629                	li	a2,10
 67c:	000ba583          	lw	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	dc5ff0ef          	jal	446 <printint>
        i += 1;
 686:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 688:	8bca                	mv	s7,s2
      state = 0;
 68a:	4981                	li	s3,0
        i += 1;
 68c:	b575                	j	538 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68e:	008b8913          	addi	s2,s7,8
 692:	4681                	li	a3,0
 694:	4629                	li	a2,10
 696:	000ba583          	lw	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	dabff0ef          	jal	446 <printint>
        i += 2;
 6a0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a2:	8bca                	mv	s7,s2
      state = 0;
 6a4:	4981                	li	s3,0
        i += 2;
 6a6:	bd49                	j	538 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6a8:	008b8913          	addi	s2,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4641                	li	a2,16
 6b0:	000ba583          	lw	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	d91ff0ef          	jal	446 <printint>
 6ba:	8bca                	mv	s7,s2
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	bdad                	j	538 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c0:	008b8913          	addi	s2,s7,8
 6c4:	4681                	li	a3,0
 6c6:	4641                	li	a2,16
 6c8:	000ba583          	lw	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	d79ff0ef          	jal	446 <printint>
        i += 1;
 6d2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d4:	8bca                	mv	s7,s2
      state = 0;
 6d6:	4981                	li	s3,0
        i += 1;
 6d8:	b585                	j	538 <vprintf+0x4a>
 6da:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6dc:	008b8d13          	addi	s10,s7,8
 6e0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6e4:	03000593          	li	a1,48
 6e8:	855a                	mv	a0,s6
 6ea:	d3fff0ef          	jal	428 <putc>
  putc(fd, 'x');
 6ee:	07800593          	li	a1,120
 6f2:	855a                	mv	a0,s6
 6f4:	d35ff0ef          	jal	428 <putc>
 6f8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6fa:	00000b97          	auipc	s7,0x0
 6fe:	2f6b8b93          	addi	s7,s7,758 # 9f0 <digits>
 702:	03c9d793          	srli	a5,s3,0x3c
 706:	97de                	add	a5,a5,s7
 708:	0007c583          	lbu	a1,0(a5)
 70c:	855a                	mv	a0,s6
 70e:	d1bff0ef          	jal	428 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 712:	0992                	slli	s3,s3,0x4
 714:	397d                	addiw	s2,s2,-1
 716:	fe0916e3          	bnez	s2,702 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 71a:	8bea                	mv	s7,s10
      state = 0;
 71c:	4981                	li	s3,0
 71e:	6d02                	ld	s10,0(sp)
 720:	bd21                	j	538 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 722:	008b8993          	addi	s3,s7,8
 726:	000bb903          	ld	s2,0(s7)
 72a:	00090f63          	beqz	s2,748 <vprintf+0x25a>
        for(; *s; s++)
 72e:	00094583          	lbu	a1,0(s2)
 732:	c195                	beqz	a1,756 <vprintf+0x268>
          putc(fd, *s);
 734:	855a                	mv	a0,s6
 736:	cf3ff0ef          	jal	428 <putc>
        for(; *s; s++)
 73a:	0905                	addi	s2,s2,1
 73c:	00094583          	lbu	a1,0(s2)
 740:	f9f5                	bnez	a1,734 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 742:	8bce                	mv	s7,s3
      state = 0;
 744:	4981                	li	s3,0
 746:	bbcd                	j	538 <vprintf+0x4a>
          s = "(null)";
 748:	00000917          	auipc	s2,0x0
 74c:	2a090913          	addi	s2,s2,672 # 9e8 <malloc+0x194>
        for(; *s; s++)
 750:	02800593          	li	a1,40
 754:	b7c5                	j	734 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 756:	8bce                	mv	s7,s3
      state = 0;
 758:	4981                	li	s3,0
 75a:	bbf9                	j	538 <vprintf+0x4a>
 75c:	64a6                	ld	s1,72(sp)
 75e:	79e2                	ld	s3,56(sp)
 760:	7a42                	ld	s4,48(sp)
 762:	7aa2                	ld	s5,40(sp)
 764:	7b02                	ld	s6,32(sp)
 766:	6be2                	ld	s7,24(sp)
 768:	6c42                	ld	s8,16(sp)
 76a:	6ca2                	ld	s9,8(sp)
>>>>>>> Stashed changes
    }
    if(p == freep)
 890:	00000917          	auipc	s2,0x0
 894:	77090913          	addi	s2,s2,1904 # 1000 <freep>
  if(p == (char*)-1)
 898:	5afd                	li	s5,-1
 89a:	a081                	j	8da <malloc+0x96>
 89c:	f04a                	sd	s2,32(sp)
 89e:	e852                	sd	s4,16(sp)
 8a0:	e456                	sd	s5,8(sp)
 8a2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8a4:	00000797          	auipc	a5,0x0
 8a8:	76c78793          	addi	a5,a5,1900 # 1010 <base>
 8ac:	00000717          	auipc	a4,0x0
 8b0:	74f73a23          	sd	a5,1876(a4) # 1000 <freep>
 8b4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ba:	b7c1                	j	87a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8bc:	6398                	ld	a4,0(a5)
 8be:	e118                	sd	a4,0(a0)
 8c0:	a8a9                	j	91a <malloc+0xd6>
  hp->s.size = nu;
 8c2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8c6:	0541                	addi	a0,a0,16
 8c8:	efbff0ef          	jal	7c2 <free>
  return freep;
 8cc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8d0:	c12d                	beqz	a0,932 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d4:	4798                	lw	a4,8(a5)
 8d6:	02977263          	bgeu	a4,s1,8fa <malloc+0xb6>
    if(p == freep)
 8da:	00093703          	ld	a4,0(s2)
 8de:	853e                	mv	a0,a5
 8e0:	fef719e3          	bne	a4,a5,8d2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8e4:	8552                	mv	a0,s4
 8e6:	b03ff0ef          	jal	3e8 <sbrk>
  if(p == (char*)-1)
 8ea:	fd551ce3          	bne	a0,s5,8c2 <malloc+0x7e>
        return 0;
 8ee:	4501                	li	a0,0
 8f0:	7902                	ld	s2,32(sp)
 8f2:	6a42                	ld	s4,16(sp)
 8f4:	6aa2                	ld	s5,8(sp)
 8f6:	6b02                	ld	s6,0(sp)
 8f8:	a03d                	j	926 <malloc+0xe2>
 8fa:	7902                	ld	s2,32(sp)
 8fc:	6a42                	ld	s4,16(sp)
 8fe:	6aa2                	ld	s5,8(sp)
 900:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 902:	fae48de3          	beq	s1,a4,8bc <malloc+0x78>
        p->s.size -= nunits;
 906:	4137073b          	subw	a4,a4,s3
 90a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 90c:	02071693          	slli	a3,a4,0x20
 910:	01c6d713          	srli	a4,a3,0x1c
 914:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 916:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 91a:	00000717          	auipc	a4,0x0
 91e:	6ea73323          	sd	a0,1766(a4) # 1000 <freep>
      return (void*)(p + 1);
 922:	01078513          	addi	a0,a5,16
  }
}
<<<<<<< Updated upstream
 926:	70e2                	ld	ra,56(sp)
 928:	7442                	ld	s0,48(sp)
 92a:	74a2                	ld	s1,40(sp)
 92c:	69e2                	ld	s3,24(sp)
 92e:	6121                	addi	sp,sp,64
 930:	8082                	ret
 932:	7902                	ld	s2,32(sp)
 934:	6a42                	ld	s4,16(sp)
 936:	6aa2                	ld	s5,8(sp)
 938:	6b02                	ld	s6,0(sp)
 93a:	b7f5                	j	926 <malloc+0xe2>
=======
 76c:	60e6                	ld	ra,88(sp)
 76e:	6446                	ld	s0,80(sp)
 770:	6906                	ld	s2,64(sp)
 772:	6125                	addi	sp,sp,96
 774:	8082                	ret

0000000000000776 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 776:	715d                	addi	sp,sp,-80
 778:	ec06                	sd	ra,24(sp)
 77a:	e822                	sd	s0,16(sp)
 77c:	1000                	addi	s0,sp,32
 77e:	e010                	sd	a2,0(s0)
 780:	e414                	sd	a3,8(s0)
 782:	e818                	sd	a4,16(s0)
 784:	ec1c                	sd	a5,24(s0)
 786:	03043023          	sd	a6,32(s0)
 78a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 78e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 792:	8622                	mv	a2,s0
 794:	d5bff0ef          	jal	4ee <vprintf>
}
 798:	60e2                	ld	ra,24(sp)
 79a:	6442                	ld	s0,16(sp)
 79c:	6161                	addi	sp,sp,80
 79e:	8082                	ret

00000000000007a0 <printf>:

void
printf(const char *fmt, ...)
{
 7a0:	711d                	addi	sp,sp,-96
 7a2:	ec06                	sd	ra,24(sp)
 7a4:	e822                	sd	s0,16(sp)
 7a6:	1000                	addi	s0,sp,32
 7a8:	e40c                	sd	a1,8(s0)
 7aa:	e810                	sd	a2,16(s0)
 7ac:	ec14                	sd	a3,24(s0)
 7ae:	f018                	sd	a4,32(s0)
 7b0:	f41c                	sd	a5,40(s0)
 7b2:	03043823          	sd	a6,48(s0)
 7b6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ba:	00840613          	addi	a2,s0,8
 7be:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c2:	85aa                	mv	a1,a0
 7c4:	4505                	li	a0,1
 7c6:	d29ff0ef          	jal	4ee <vprintf>
}
 7ca:	60e2                	ld	ra,24(sp)
 7cc:	6442                	ld	s0,16(sp)
 7ce:	6125                	addi	sp,sp,96
 7d0:	8082                	ret

00000000000007d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d2:	1141                	addi	sp,sp,-16
 7d4:	e422                	sd	s0,8(sp)
 7d6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7d8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7dc:	00001797          	auipc	a5,0x1
 7e0:	8247b783          	ld	a5,-2012(a5) # 1000 <freep>
 7e4:	a02d                	j	80e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7e6:	4618                	lw	a4,8(a2)
 7e8:	9f2d                	addw	a4,a4,a1
 7ea:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ee:	6398                	ld	a4,0(a5)
 7f0:	6310                	ld	a2,0(a4)
 7f2:	a83d                	j	830 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7f4:	ff852703          	lw	a4,-8(a0)
 7f8:	9f31                	addw	a4,a4,a2
 7fa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7fc:	ff053683          	ld	a3,-16(a0)
 800:	a091                	j	844 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 802:	6398                	ld	a4,0(a5)
 804:	00e7e463          	bltu	a5,a4,80c <free+0x3a>
 808:	00e6ea63          	bltu	a3,a4,81c <free+0x4a>
{
 80c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80e:	fed7fae3          	bgeu	a5,a3,802 <free+0x30>
 812:	6398                	ld	a4,0(a5)
 814:	00e6e463          	bltu	a3,a4,81c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 818:	fee7eae3          	bltu	a5,a4,80c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 81c:	ff852583          	lw	a1,-8(a0)
 820:	6390                	ld	a2,0(a5)
 822:	02059813          	slli	a6,a1,0x20
 826:	01c85713          	srli	a4,a6,0x1c
 82a:	9736                	add	a4,a4,a3
 82c:	fae60de3          	beq	a2,a4,7e6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 830:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 834:	4790                	lw	a2,8(a5)
 836:	02061593          	slli	a1,a2,0x20
 83a:	01c5d713          	srli	a4,a1,0x1c
 83e:	973e                	add	a4,a4,a5
 840:	fae68ae3          	beq	a3,a4,7f4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 844:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 846:	00000717          	auipc	a4,0x0
 84a:	7af73d23          	sd	a5,1978(a4) # 1000 <freep>
}
 84e:	6422                	ld	s0,8(sp)
 850:	0141                	addi	sp,sp,16
 852:	8082                	ret

0000000000000854 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 854:	7139                	addi	sp,sp,-64
 856:	fc06                	sd	ra,56(sp)
 858:	f822                	sd	s0,48(sp)
 85a:	f426                	sd	s1,40(sp)
 85c:	ec4e                	sd	s3,24(sp)
 85e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 860:	02051493          	slli	s1,a0,0x20
 864:	9081                	srli	s1,s1,0x20
 866:	04bd                	addi	s1,s1,15
 868:	8091                	srli	s1,s1,0x4
 86a:	0014899b          	addiw	s3,s1,1
 86e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 870:	00000517          	auipc	a0,0x0
 874:	79053503          	ld	a0,1936(a0) # 1000 <freep>
 878:	c915                	beqz	a0,8ac <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87c:	4798                	lw	a4,8(a5)
 87e:	08977a63          	bgeu	a4,s1,912 <malloc+0xbe>
 882:	f04a                	sd	s2,32(sp)
 884:	e852                	sd	s4,16(sp)
 886:	e456                	sd	s5,8(sp)
 888:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 88a:	8a4e                	mv	s4,s3
 88c:	0009871b          	sext.w	a4,s3
 890:	6685                	lui	a3,0x1
 892:	00d77363          	bgeu	a4,a3,898 <malloc+0x44>
 896:	6a05                	lui	s4,0x1
 898:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 89c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a0:	00000917          	auipc	s2,0x0
 8a4:	76090913          	addi	s2,s2,1888 # 1000 <freep>
  if(p == (char*)-1)
 8a8:	5afd                	li	s5,-1
 8aa:	a081                	j	8ea <malloc+0x96>
 8ac:	f04a                	sd	s2,32(sp)
 8ae:	e852                	sd	s4,16(sp)
 8b0:	e456                	sd	s5,8(sp)
 8b2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8b4:	00000797          	auipc	a5,0x0
 8b8:	75c78793          	addi	a5,a5,1884 # 1010 <base>
 8bc:	00000717          	auipc	a4,0x0
 8c0:	74f73223          	sd	a5,1860(a4) # 1000 <freep>
 8c4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ca:	b7c1                	j	88a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8cc:	6398                	ld	a4,0(a5)
 8ce:	e118                	sd	a4,0(a0)
 8d0:	a8a9                	j	92a <malloc+0xd6>
  hp->s.size = nu;
 8d2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8d6:	0541                	addi	a0,a0,16
 8d8:	efbff0ef          	jal	7d2 <free>
  return freep;
 8dc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8e0:	c12d                	beqz	a0,942 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e4:	4798                	lw	a4,8(a5)
 8e6:	02977263          	bgeu	a4,s1,90a <malloc+0xb6>
    if(p == freep)
 8ea:	00093703          	ld	a4,0(s2)
 8ee:	853e                	mv	a0,a5
 8f0:	fef719e3          	bne	a4,a5,8e2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8f4:	8552                	mv	a0,s4
 8f6:	af3ff0ef          	jal	3e8 <sbrk>
  if(p == (char*)-1)
 8fa:	fd551ce3          	bne	a0,s5,8d2 <malloc+0x7e>
        return 0;
 8fe:	4501                	li	a0,0
 900:	7902                	ld	s2,32(sp)
 902:	6a42                	ld	s4,16(sp)
 904:	6aa2                	ld	s5,8(sp)
 906:	6b02                	ld	s6,0(sp)
 908:	a03d                	j	936 <malloc+0xe2>
 90a:	7902                	ld	s2,32(sp)
 90c:	6a42                	ld	s4,16(sp)
 90e:	6aa2                	ld	s5,8(sp)
 910:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 912:	fae48de3          	beq	s1,a4,8cc <malloc+0x78>
        p->s.size -= nunits;
 916:	4137073b          	subw	a4,a4,s3
 91a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 91c:	02071693          	slli	a3,a4,0x20
 920:	01c6d713          	srli	a4,a3,0x1c
 924:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 926:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 92a:	00000717          	auipc	a4,0x0
 92e:	6ca73b23          	sd	a0,1750(a4) # 1000 <freep>
      return (void*)(p + 1);
 932:	01078513          	addi	a0,a5,16
  }
}
 936:	70e2                	ld	ra,56(sp)
 938:	7442                	ld	s0,48(sp)
 93a:	74a2                	ld	s1,40(sp)
 93c:	69e2                	ld	s3,24(sp)
 93e:	6121                	addi	sp,sp,64
 940:	8082                	ret
 942:	7902                	ld	s2,32(sp)
 944:	6a42                	ld	s4,16(sp)
 946:	6aa2                	ld	s5,8(sp)
 948:	6b02                	ld	s6,0(sp)
 94a:	b7f5                	j	936 <malloc+0xe2>
>>>>>>> Stashed changes
