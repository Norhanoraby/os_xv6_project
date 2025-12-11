
user/_mv:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <strcat>:
#include "kernel/stat.h"
#include "kernel/fs.h"
#include "user/user.h"

// Manual strcat implementation for xv6
char* strcat(char *dest, const char *src) {
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
    char *ptr = dest;
    while (*ptr != '\0') {
   6:	00054783          	lbu	a5,0(a0)
   a:	c78d                	beqz	a5,34 <strcat+0x34>
    char *ptr = dest;
   c:	87aa                	mv	a5,a0
        ptr++;
   e:	0785                	addi	a5,a5,1
    while (*ptr != '\0') {
  10:	0007c703          	lbu	a4,0(a5)
  14:	ff6d                	bnez	a4,e <strcat+0xe>
    }
    while (*src != '\0') {
  16:	0005c703          	lbu	a4,0(a1)
  1a:	cb01                	beqz	a4,2a <strcat+0x2a>
        *ptr++ = *src++;
  1c:	0585                	addi	a1,a1,1
  1e:	0785                	addi	a5,a5,1
  20:	fee78fa3          	sb	a4,-1(a5)
    while (*src != '\0') {
  24:	0005c703          	lbu	a4,0(a1)
  28:	fb75                	bnez	a4,1c <strcat+0x1c>
    }
    *ptr = '\0';
  2a:	00078023          	sb	zero,0(a5)
    return dest;
}
  2e:	6422                	ld	s0,8(sp)
  30:	0141                	addi	sp,sp,16
  32:	8082                	ret
    char *ptr = dest;
  34:	87aa                	mv	a5,a0
  36:	b7c5                	j	16 <strcat+0x16>

0000000000000038 <get_filename>:

// Extract filename from path
char* get_filename(char *path) {
  38:	1101                	addi	sp,sp,-32
  3a:	ec06                	sd	ra,24(sp)
  3c:	e822                	sd	s0,16(sp)
  3e:	e426                	sd	s1,8(sp)
  40:	1000                	addi	s0,sp,32
  42:	84aa                	mv	s1,a0
    char *p = path + strlen(path);
  44:	1ce000ef          	jal	212 <strlen>
  48:	02051793          	slli	a5,a0,0x20
  4c:	9381                	srli	a5,a5,0x20
  4e:	97a6                	add	a5,a5,s1
    while (p > path && *p != '/') {
  50:	02f00693          	li	a3,47
  54:	00f4fa63          	bgeu	s1,a5,68 <get_filename+0x30>
  58:	0007c703          	lbu	a4,0(a5)
  5c:	00d70663          	beq	a4,a3,68 <get_filename+0x30>
        p--;
  60:	17fd                	addi	a5,a5,-1
    while (p > path && *p != '/') {
  62:	fef49be3          	bne	s1,a5,58 <get_filename+0x20>
  66:	87a6                	mv	a5,s1
    }
    if (*p == '/') p++;
  68:	0007c503          	lbu	a0,0(a5)
  6c:	fd150513          	addi	a0,a0,-47
  70:	00153513          	seqz	a0,a0
    return p;
}
  74:	953e                	add	a0,a0,a5
  76:	60e2                	ld	ra,24(sp)
  78:	6442                	ld	s0,16(sp)
  7a:	64a2                	ld	s1,8(sp)
  7c:	6105                	addi	sp,sp,32
  7e:	8082                	ret

0000000000000080 <main>:

int main(int argc, char *argv[]) {
  80:	db010113          	addi	sp,sp,-592
  84:	24113423          	sd	ra,584(sp)
  88:	24813023          	sd	s0,576(sp)
  8c:	0c80                	addi	s0,sp,592
    struct stat st;
    char newpath[512];

    if (argc != 3) {
  8e:	478d                	li	a5,3
  90:	02f50263          	beq	a0,a5,b4 <main+0x34>
  94:	22913c23          	sd	s1,568(sp)
  98:	23213823          	sd	s2,560(sp)
  9c:	23313423          	sd	s3,552(sp)
        fprintf(2, "Usage: mv source destination\n");
  a0:	00001597          	auipc	a1,0x1
  a4:	99058593          	addi	a1,a1,-1648 # a30 <malloc+0xfa>
  a8:	4509                	li	a0,2
  aa:	7ae000ef          	jal	858 <fprintf>
        exit(1);
  ae:	4505                	li	a0,1
  b0:	372000ef          	jal	422 <exit>
  b4:	22913c23          	sd	s1,568(sp)
  b8:	23213823          	sd	s2,560(sp)
    }

    char *source = argv[1];
  bc:	6584                	ld	s1,8(a1)
    char *dest = argv[2];
  be:	0105b903          	ld	s2,16(a1)

    // Check if source exists
    if (stat(source, &st) < 0) {
  c2:	fb840593          	addi	a1,s0,-72
  c6:	8526                	mv	a0,s1
  c8:	22a000ef          	jal	2f2 <stat>
  cc:	04054363          	bltz	a0,112 <main+0x92>
  d0:	23313423          	sd	s3,552(sp)
        fprintf(2, "mv: cannot stat %s\n", source);
        exit(1);
    }

    // Check if destination is a directory
    if (stat(dest, &st) == 0 && st.type == T_DIR) {
  d4:	fb840593          	addi	a1,s0,-72
  d8:	854a                	mv	a0,s2
  da:	218000ef          	jal	2f2 <stat>
  de:	e511                	bnez	a0,ea <main+0x6a>
  e0:	fc041703          	lh	a4,-64(s0)
  e4:	4785                	li	a5,1
  e6:	04f70363          	beq	a4,a5,12c <main+0xac>
            strcat(newpath, "/");
        }
        strcat(newpath, filename);
    } else {
        // Destination is a file or doesn't exist
        strcpy(newpath, dest);
  ea:	85ca                	mv	a1,s2
  ec:	db840513          	addi	a0,s0,-584
  f0:	0da000ef          	jal	1ca <strcpy>
    }

    // Perform the move using link and unlink
    if (link(source, newpath) < 0) {
  f4:	db840593          	addi	a1,s0,-584
  f8:	8526                	mv	a0,s1
  fa:	388000ef          	jal	482 <link>
  fe:	08054563          	bltz	a0,188 <main+0x108>
        fprintf(2, "mv: link failed\n");
        exit(1);
    }

    if (unlink(source) < 0) {
 102:	8526                	mv	a0,s1
 104:	36e000ef          	jal	472 <unlink>
 108:	08054a63          	bltz	a0,19c <main+0x11c>
        fprintf(2, "mv: unlink failed\n");
        unlink(newpath); // Cleanup
        exit(1);
    }

    exit(0);
 10c:	4501                	li	a0,0
 10e:	314000ef          	jal	422 <exit>
 112:	23313423          	sd	s3,552(sp)
        fprintf(2, "mv: cannot stat %s\n", source);
 116:	8626                	mv	a2,s1
 118:	00001597          	auipc	a1,0x1
 11c:	93858593          	addi	a1,a1,-1736 # a50 <malloc+0x11a>
 120:	4509                	li	a0,2
 122:	736000ef          	jal	858 <fprintf>
        exit(1);
 126:	4505                	li	a0,1
 128:	2fa000ef          	jal	422 <exit>
        char *filename = get_filename(source);
 12c:	8526                	mv	a0,s1
 12e:	f0bff0ef          	jal	38 <get_filename>
 132:	89aa                	mv	s3,a0
        strcpy(newpath, dest);
 134:	85ca                	mv	a1,s2
 136:	db840513          	addi	a0,s0,-584
 13a:	090000ef          	jal	1ca <strcpy>
        if (newpath[strlen(newpath) - 1] != '/') {
 13e:	db840513          	addi	a0,s0,-584
 142:	0d0000ef          	jal	212 <strlen>
 146:	fff5079b          	addiw	a5,a0,-1
 14a:	1782                	slli	a5,a5,0x20
 14c:	9381                	srli	a5,a5,0x20
 14e:	fd078793          	addi	a5,a5,-48
 152:	97a2                	add	a5,a5,s0
 154:	de87c703          	lbu	a4,-536(a5)
 158:	02f00793          	li	a5,47
 15c:	00f71863          	bne	a4,a5,16c <main+0xec>
        strcat(newpath, filename);
 160:	85ce                	mv	a1,s3
 162:	db840513          	addi	a0,s0,-584
 166:	e9bff0ef          	jal	0 <strcat>
    if (stat(dest, &st) == 0 && st.type == T_DIR) {
 16a:	b769                	j	f4 <main+0x74>
            strcat(newpath, "/");
 16c:	db840513          	addi	a0,s0,-584
 170:	0a2000ef          	jal	212 <strlen>
 174:	db840793          	addi	a5,s0,-584
 178:	97aa                	add	a5,a5,a0
 17a:	02f00713          	li	a4,47
 17e:	00e78023          	sb	a4,0(a5)
 182:	000780a3          	sb	zero,1(a5)
 186:	bfe9                	j	160 <main+0xe0>
        fprintf(2, "mv: link failed\n");
 188:	00001597          	auipc	a1,0x1
 18c:	8e058593          	addi	a1,a1,-1824 # a68 <malloc+0x132>
 190:	4509                	li	a0,2
 192:	6c6000ef          	jal	858 <fprintf>
        exit(1);
 196:	4505                	li	a0,1
 198:	28a000ef          	jal	422 <exit>
        fprintf(2, "mv: unlink failed\n");
 19c:	00001597          	auipc	a1,0x1
 1a0:	8e458593          	addi	a1,a1,-1820 # a80 <malloc+0x14a>
 1a4:	4509                	li	a0,2
 1a6:	6b2000ef          	jal	858 <fprintf>
        unlink(newpath); // Cleanup
 1aa:	db840513          	addi	a0,s0,-584
 1ae:	2c4000ef          	jal	472 <unlink>
        exit(1);
 1b2:	4505                	li	a0,1
 1b4:	26e000ef          	jal	422 <exit>

00000000000001b8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e406                	sd	ra,8(sp)
 1bc:	e022                	sd	s0,0(sp)
 1be:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1c0:	ec1ff0ef          	jal	80 <main>
  exit(0);
 1c4:	4501                	li	a0,0
 1c6:	25c000ef          	jal	422 <exit>

00000000000001ca <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1ca:	1141                	addi	sp,sp,-16
 1cc:	e422                	sd	s0,8(sp)
 1ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1d0:	87aa                	mv	a5,a0
 1d2:	0585                	addi	a1,a1,1
 1d4:	0785                	addi	a5,a5,1
 1d6:	fff5c703          	lbu	a4,-1(a1)
 1da:	fee78fa3          	sb	a4,-1(a5)
 1de:	fb75                	bnez	a4,1d2 <strcpy+0x8>
    ;
  return os;
}
 1e0:	6422                	ld	s0,8(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret

00000000000001e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1ec:	00054783          	lbu	a5,0(a0)
 1f0:	cb91                	beqz	a5,204 <strcmp+0x1e>
 1f2:	0005c703          	lbu	a4,0(a1)
 1f6:	00f71763          	bne	a4,a5,204 <strcmp+0x1e>
    p++, q++;
 1fa:	0505                	addi	a0,a0,1
 1fc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1fe:	00054783          	lbu	a5,0(a0)
 202:	fbe5                	bnez	a5,1f2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 204:	0005c503          	lbu	a0,0(a1)
}
 208:	40a7853b          	subw	a0,a5,a0
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret

0000000000000212 <strlen>:

uint
strlen(const char *s)
{
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 218:	00054783          	lbu	a5,0(a0)
 21c:	cf91                	beqz	a5,238 <strlen+0x26>
 21e:	0505                	addi	a0,a0,1
 220:	87aa                	mv	a5,a0
 222:	86be                	mv	a3,a5
 224:	0785                	addi	a5,a5,1
 226:	fff7c703          	lbu	a4,-1(a5)
 22a:	ff65                	bnez	a4,222 <strlen+0x10>
 22c:	40a6853b          	subw	a0,a3,a0
 230:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret
  for(n = 0; s[n]; n++)
 238:	4501                	li	a0,0
 23a:	bfe5                	j	232 <strlen+0x20>

000000000000023c <memset>:

void*
memset(void *dst, int c, uint n)
{
 23c:	1141                	addi	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 242:	ca19                	beqz	a2,258 <memset+0x1c>
 244:	87aa                	mv	a5,a0
 246:	1602                	slli	a2,a2,0x20
 248:	9201                	srli	a2,a2,0x20
 24a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 24e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 252:	0785                	addi	a5,a5,1
 254:	fee79de3          	bne	a5,a4,24e <memset+0x12>
  }
  return dst;
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret

000000000000025e <strchr>:

char*
strchr(const char *s, char c)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
  for(; *s; s++)
 264:	00054783          	lbu	a5,0(a0)
 268:	cb99                	beqz	a5,27e <strchr+0x20>
    if(*s == c)
 26a:	00f58763          	beq	a1,a5,278 <strchr+0x1a>
  for(; *s; s++)
 26e:	0505                	addi	a0,a0,1
 270:	00054783          	lbu	a5,0(a0)
 274:	fbfd                	bnez	a5,26a <strchr+0xc>
      return (char*)s;
  return 0;
 276:	4501                	li	a0,0
}
 278:	6422                	ld	s0,8(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
  return 0;
 27e:	4501                	li	a0,0
 280:	bfe5                	j	278 <strchr+0x1a>

0000000000000282 <gets>:

char*
gets(char *buf, int max)
{
 282:	711d                	addi	sp,sp,-96
 284:	ec86                	sd	ra,88(sp)
 286:	e8a2                	sd	s0,80(sp)
 288:	e4a6                	sd	s1,72(sp)
 28a:	e0ca                	sd	s2,64(sp)
 28c:	fc4e                	sd	s3,56(sp)
 28e:	f852                	sd	s4,48(sp)
 290:	f456                	sd	s5,40(sp)
 292:	f05a                	sd	s6,32(sp)
 294:	ec5e                	sd	s7,24(sp)
 296:	1080                	addi	s0,sp,96
 298:	8baa                	mv	s7,a0
 29a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 29c:	892a                	mv	s2,a0
 29e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2a0:	4aa9                	li	s5,10
 2a2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2a4:	89a6                	mv	s3,s1
 2a6:	2485                	addiw	s1,s1,1
 2a8:	0344d663          	bge	s1,s4,2d4 <gets+0x52>
    cc = read(0, &c, 1);
 2ac:	4605                	li	a2,1
 2ae:	faf40593          	addi	a1,s0,-81
 2b2:	4501                	li	a0,0
 2b4:	186000ef          	jal	43a <read>
    if(cc < 1)
 2b8:	00a05e63          	blez	a0,2d4 <gets+0x52>
    buf[i++] = c;
 2bc:	faf44783          	lbu	a5,-81(s0)
 2c0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2c4:	01578763          	beq	a5,s5,2d2 <gets+0x50>
 2c8:	0905                	addi	s2,s2,1
 2ca:	fd679de3          	bne	a5,s6,2a4 <gets+0x22>
    buf[i++] = c;
 2ce:	89a6                	mv	s3,s1
 2d0:	a011                	j	2d4 <gets+0x52>
 2d2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2d4:	99de                	add	s3,s3,s7
 2d6:	00098023          	sb	zero,0(s3)
  return buf;
}
 2da:	855e                	mv	a0,s7
 2dc:	60e6                	ld	ra,88(sp)
 2de:	6446                	ld	s0,80(sp)
 2e0:	64a6                	ld	s1,72(sp)
 2e2:	6906                	ld	s2,64(sp)
 2e4:	79e2                	ld	s3,56(sp)
 2e6:	7a42                	ld	s4,48(sp)
 2e8:	7aa2                	ld	s5,40(sp)
 2ea:	7b02                	ld	s6,32(sp)
 2ec:	6be2                	ld	s7,24(sp)
 2ee:	6125                	addi	sp,sp,96
 2f0:	8082                	ret

00000000000002f2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2f2:	1101                	addi	sp,sp,-32
 2f4:	ec06                	sd	ra,24(sp)
 2f6:	e822                	sd	s0,16(sp)
 2f8:	e04a                	sd	s2,0(sp)
 2fa:	1000                	addi	s0,sp,32
 2fc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2fe:	4581                	li	a1,0
 300:	162000ef          	jal	462 <open>
  if(fd < 0)
 304:	02054263          	bltz	a0,328 <stat+0x36>
 308:	e426                	sd	s1,8(sp)
 30a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 30c:	85ca                	mv	a1,s2
 30e:	16c000ef          	jal	47a <fstat>
 312:	892a                	mv	s2,a0
  close(fd);
 314:	8526                	mv	a0,s1
 316:	134000ef          	jal	44a <close>
  return r;
 31a:	64a2                	ld	s1,8(sp)
}
 31c:	854a                	mv	a0,s2
 31e:	60e2                	ld	ra,24(sp)
 320:	6442                	ld	s0,16(sp)
 322:	6902                	ld	s2,0(sp)
 324:	6105                	addi	sp,sp,32
 326:	8082                	ret
    return -1;
 328:	597d                	li	s2,-1
 32a:	bfcd                	j	31c <stat+0x2a>

000000000000032c <atoi>:

int
atoi(const char *s)
{
 32c:	1141                	addi	sp,sp,-16
 32e:	e422                	sd	s0,8(sp)
 330:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 332:	00054683          	lbu	a3,0(a0)
 336:	fd06879b          	addiw	a5,a3,-48
 33a:	0ff7f793          	zext.b	a5,a5
 33e:	4625                	li	a2,9
 340:	02f66863          	bltu	a2,a5,370 <atoi+0x44>
 344:	872a                	mv	a4,a0
  n = 0;
 346:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 348:	0705                	addi	a4,a4,1
 34a:	0025179b          	slliw	a5,a0,0x2
 34e:	9fa9                	addw	a5,a5,a0
 350:	0017979b          	slliw	a5,a5,0x1
 354:	9fb5                	addw	a5,a5,a3
 356:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 35a:	00074683          	lbu	a3,0(a4)
 35e:	fd06879b          	addiw	a5,a3,-48
 362:	0ff7f793          	zext.b	a5,a5
 366:	fef671e3          	bgeu	a2,a5,348 <atoi+0x1c>
  return n;
}
 36a:	6422                	ld	s0,8(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret
  n = 0;
 370:	4501                	li	a0,0
 372:	bfe5                	j	36a <atoi+0x3e>

0000000000000374 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 374:	1141                	addi	sp,sp,-16
 376:	e422                	sd	s0,8(sp)
 378:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 37a:	02b57463          	bgeu	a0,a1,3a2 <memmove+0x2e>
    while(n-- > 0)
 37e:	00c05f63          	blez	a2,39c <memmove+0x28>
 382:	1602                	slli	a2,a2,0x20
 384:	9201                	srli	a2,a2,0x20
 386:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 38a:	872a                	mv	a4,a0
      *dst++ = *src++;
 38c:	0585                	addi	a1,a1,1
 38e:	0705                	addi	a4,a4,1
 390:	fff5c683          	lbu	a3,-1(a1)
 394:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 398:	fef71ae3          	bne	a4,a5,38c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 39c:	6422                	ld	s0,8(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret
    dst += n;
 3a2:	00c50733          	add	a4,a0,a2
    src += n;
 3a6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3a8:	fec05ae3          	blez	a2,39c <memmove+0x28>
 3ac:	fff6079b          	addiw	a5,a2,-1
 3b0:	1782                	slli	a5,a5,0x20
 3b2:	9381                	srli	a5,a5,0x20
 3b4:	fff7c793          	not	a5,a5
 3b8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3ba:	15fd                	addi	a1,a1,-1
 3bc:	177d                	addi	a4,a4,-1
 3be:	0005c683          	lbu	a3,0(a1)
 3c2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3c6:	fee79ae3          	bne	a5,a4,3ba <memmove+0x46>
 3ca:	bfc9                	j	39c <memmove+0x28>

00000000000003cc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3cc:	1141                	addi	sp,sp,-16
 3ce:	e422                	sd	s0,8(sp)
 3d0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3d2:	ca05                	beqz	a2,402 <memcmp+0x36>
 3d4:	fff6069b          	addiw	a3,a2,-1
 3d8:	1682                	slli	a3,a3,0x20
 3da:	9281                	srli	a3,a3,0x20
 3dc:	0685                	addi	a3,a3,1
 3de:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3e0:	00054783          	lbu	a5,0(a0)
 3e4:	0005c703          	lbu	a4,0(a1)
 3e8:	00e79863          	bne	a5,a4,3f8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3ec:	0505                	addi	a0,a0,1
    p2++;
 3ee:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3f0:	fed518e3          	bne	a0,a3,3e0 <memcmp+0x14>
  }
  return 0;
 3f4:	4501                	li	a0,0
 3f6:	a019                	j	3fc <memcmp+0x30>
      return *p1 - *p2;
 3f8:	40e7853b          	subw	a0,a5,a4
}
 3fc:	6422                	ld	s0,8(sp)
 3fe:	0141                	addi	sp,sp,16
 400:	8082                	ret
  return 0;
 402:	4501                	li	a0,0
 404:	bfe5                	j	3fc <memcmp+0x30>

0000000000000406 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 406:	1141                	addi	sp,sp,-16
 408:	e406                	sd	ra,8(sp)
 40a:	e022                	sd	s0,0(sp)
 40c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 40e:	f67ff0ef          	jal	374 <memmove>
}
 412:	60a2                	ld	ra,8(sp)
 414:	6402                	ld	s0,0(sp)
 416:	0141                	addi	sp,sp,16
 418:	8082                	ret

000000000000041a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 41a:	4885                	li	a7,1
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <exit>:
.global exit
exit:
 li a7, SYS_exit
 422:	4889                	li	a7,2
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <wait>:
.global wait
wait:
 li a7, SYS_wait
 42a:	488d                	li	a7,3
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 432:	4891                	li	a7,4
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <read>:
.global read
read:
 li a7, SYS_read
 43a:	4895                	li	a7,5
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <write>:
.global write
write:
 li a7, SYS_write
 442:	48c1                	li	a7,16
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <close>:
.global close
close:
 li a7, SYS_close
 44a:	48d5                	li	a7,21
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <kill>:
.global kill
kill:
 li a7, SYS_kill
 452:	4899                	li	a7,6
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <exec>:
.global exec
exec:
 li a7, SYS_exec
 45a:	489d                	li	a7,7
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <open>:
.global open
open:
 li a7, SYS_open
 462:	48bd                	li	a7,15
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 46a:	48c5                	li	a7,17
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 472:	48c9                	li	a7,18
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 47a:	48a1                	li	a7,8
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <link>:
.global link
link:
 li a7, SYS_link
 482:	48cd                	li	a7,19
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 48a:	48d1                	li	a7,20
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 492:	48a5                	li	a7,9
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <dup>:
.global dup
dup:
 li a7, SYS_dup
 49a:	48a9                	li	a7,10
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4a2:	48ad                	li	a7,11
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4aa:	48b1                	li	a7,12
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4b2:	48b5                	li	a7,13
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ba:	48b9                	li	a7,14
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 4c2:	48d9                	li	a7,22
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 4ca:	48dd                	li	a7,23
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 4d2:	48e1                	li	a7,24
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 4da:	48e5                	li	a7,25
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <random>:
.global random
random:
 li a7, SYS_random
 4e2:	48e9                	li	a7,26
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 4ea:	48ed                	li	a7,27
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 4f2:	48f1                	li	a7,28
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <set_sched>:
.global set_sched
set_sched:
 li a7, SYS_set_sched
 4fa:	48f5                	li	a7,29
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <wait_sched>:
.global wait_sched
wait_sched:
 li a7, SYS_wait_sched
 502:	48f9                	li	a7,30
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 50a:	1101                	addi	sp,sp,-32
 50c:	ec06                	sd	ra,24(sp)
 50e:	e822                	sd	s0,16(sp)
 510:	1000                	addi	s0,sp,32
 512:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 516:	4605                	li	a2,1
 518:	fef40593          	addi	a1,s0,-17
 51c:	f27ff0ef          	jal	442 <write>
}
 520:	60e2                	ld	ra,24(sp)
 522:	6442                	ld	s0,16(sp)
 524:	6105                	addi	sp,sp,32
 526:	8082                	ret

0000000000000528 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 528:	7139                	addi	sp,sp,-64
 52a:	fc06                	sd	ra,56(sp)
 52c:	f822                	sd	s0,48(sp)
 52e:	f426                	sd	s1,40(sp)
 530:	0080                	addi	s0,sp,64
 532:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 534:	c299                	beqz	a3,53a <printint+0x12>
 536:	0805c963          	bltz	a1,5c8 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 53a:	2581                	sext.w	a1,a1
  neg = 0;
 53c:	4881                	li	a7,0
 53e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 542:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 544:	2601                	sext.w	a2,a2
 546:	00000517          	auipc	a0,0x0
 54a:	55a50513          	addi	a0,a0,1370 # aa0 <digits>
 54e:	883a                	mv	a6,a4
 550:	2705                	addiw	a4,a4,1
 552:	02c5f7bb          	remuw	a5,a1,a2
 556:	1782                	slli	a5,a5,0x20
 558:	9381                	srli	a5,a5,0x20
 55a:	97aa                	add	a5,a5,a0
 55c:	0007c783          	lbu	a5,0(a5)
 560:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 564:	0005879b          	sext.w	a5,a1
 568:	02c5d5bb          	divuw	a1,a1,a2
 56c:	0685                	addi	a3,a3,1
 56e:	fec7f0e3          	bgeu	a5,a2,54e <printint+0x26>
  if(neg)
 572:	00088c63          	beqz	a7,58a <printint+0x62>
    buf[i++] = '-';
 576:	fd070793          	addi	a5,a4,-48
 57a:	00878733          	add	a4,a5,s0
 57e:	02d00793          	li	a5,45
 582:	fef70823          	sb	a5,-16(a4)
 586:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 58a:	02e05a63          	blez	a4,5be <printint+0x96>
 58e:	f04a                	sd	s2,32(sp)
 590:	ec4e                	sd	s3,24(sp)
 592:	fc040793          	addi	a5,s0,-64
 596:	00e78933          	add	s2,a5,a4
 59a:	fff78993          	addi	s3,a5,-1
 59e:	99ba                	add	s3,s3,a4
 5a0:	377d                	addiw	a4,a4,-1
 5a2:	1702                	slli	a4,a4,0x20
 5a4:	9301                	srli	a4,a4,0x20
 5a6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5aa:	fff94583          	lbu	a1,-1(s2)
 5ae:	8526                	mv	a0,s1
 5b0:	f5bff0ef          	jal	50a <putc>
  while(--i >= 0)
 5b4:	197d                	addi	s2,s2,-1
 5b6:	ff391ae3          	bne	s2,s3,5aa <printint+0x82>
 5ba:	7902                	ld	s2,32(sp)
 5bc:	69e2                	ld	s3,24(sp)
}
 5be:	70e2                	ld	ra,56(sp)
 5c0:	7442                	ld	s0,48(sp)
 5c2:	74a2                	ld	s1,40(sp)
 5c4:	6121                	addi	sp,sp,64
 5c6:	8082                	ret
    x = -xx;
 5c8:	40b005bb          	negw	a1,a1
    neg = 1;
 5cc:	4885                	li	a7,1
    x = -xx;
 5ce:	bf85                	j	53e <printint+0x16>

00000000000005d0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5d0:	711d                	addi	sp,sp,-96
 5d2:	ec86                	sd	ra,88(sp)
 5d4:	e8a2                	sd	s0,80(sp)
 5d6:	e0ca                	sd	s2,64(sp)
 5d8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5da:	0005c903          	lbu	s2,0(a1)
 5de:	26090863          	beqz	s2,84e <vprintf+0x27e>
 5e2:	e4a6                	sd	s1,72(sp)
 5e4:	fc4e                	sd	s3,56(sp)
 5e6:	f852                	sd	s4,48(sp)
 5e8:	f456                	sd	s5,40(sp)
 5ea:	f05a                	sd	s6,32(sp)
 5ec:	ec5e                	sd	s7,24(sp)
 5ee:	e862                	sd	s8,16(sp)
 5f0:	e466                	sd	s9,8(sp)
 5f2:	8b2a                	mv	s6,a0
 5f4:	8a2e                	mv	s4,a1
 5f6:	8bb2                	mv	s7,a2
  state = 0;
 5f8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5fa:	4481                	li	s1,0
 5fc:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5fe:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 602:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 606:	06c00c93          	li	s9,108
 60a:	a005                	j	62a <vprintf+0x5a>
        putc(fd, c0);
 60c:	85ca                	mv	a1,s2
 60e:	855a                	mv	a0,s6
 610:	efbff0ef          	jal	50a <putc>
 614:	a019                	j	61a <vprintf+0x4a>
    } else if(state == '%'){
 616:	03598263          	beq	s3,s5,63a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 61a:	2485                	addiw	s1,s1,1
 61c:	8726                	mv	a4,s1
 61e:	009a07b3          	add	a5,s4,s1
 622:	0007c903          	lbu	s2,0(a5)
 626:	20090c63          	beqz	s2,83e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 62a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 62e:	fe0994e3          	bnez	s3,616 <vprintf+0x46>
      if(c0 == '%'){
 632:	fd579de3          	bne	a5,s5,60c <vprintf+0x3c>
        state = '%';
 636:	89be                	mv	s3,a5
 638:	b7cd                	j	61a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 63a:	00ea06b3          	add	a3,s4,a4
 63e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 642:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 644:	c681                	beqz	a3,64c <vprintf+0x7c>
 646:	9752                	add	a4,a4,s4
 648:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 64c:	03878f63          	beq	a5,s8,68a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 650:	05978963          	beq	a5,s9,6a2 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 654:	07500713          	li	a4,117
 658:	0ee78363          	beq	a5,a4,73e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 65c:	07800713          	li	a4,120
 660:	12e78563          	beq	a5,a4,78a <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 664:	07000713          	li	a4,112
 668:	14e78a63          	beq	a5,a4,7bc <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 66c:	07300713          	li	a4,115
 670:	18e78a63          	beq	a5,a4,804 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 674:	02500713          	li	a4,37
 678:	04e79563          	bne	a5,a4,6c2 <vprintf+0xf2>
        putc(fd, '%');
 67c:	02500593          	li	a1,37
 680:	855a                	mv	a0,s6
 682:	e89ff0ef          	jal	50a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 686:	4981                	li	s3,0
 688:	bf49                	j	61a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 68a:	008b8913          	addi	s2,s7,8
 68e:	4685                	li	a3,1
 690:	4629                	li	a2,10
 692:	000ba583          	lw	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	e91ff0ef          	jal	528 <printint>
 69c:	8bca                	mv	s7,s2
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	bfad                	j	61a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6a2:	06400793          	li	a5,100
 6a6:	02f68963          	beq	a3,a5,6d8 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6aa:	06c00793          	li	a5,108
 6ae:	04f68263          	beq	a3,a5,6f2 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6b2:	07500793          	li	a5,117
 6b6:	0af68063          	beq	a3,a5,756 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6ba:	07800793          	li	a5,120
 6be:	0ef68263          	beq	a3,a5,7a2 <vprintf+0x1d2>
        putc(fd, '%');
 6c2:	02500593          	li	a1,37
 6c6:	855a                	mv	a0,s6
 6c8:	e43ff0ef          	jal	50a <putc>
        putc(fd, c0);
 6cc:	85ca                	mv	a1,s2
 6ce:	855a                	mv	a0,s6
 6d0:	e3bff0ef          	jal	50a <putc>
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	b791                	j	61a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d8:	008b8913          	addi	s2,s7,8
 6dc:	4685                	li	a3,1
 6de:	4629                	li	a2,10
 6e0:	000ba583          	lw	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	e43ff0ef          	jal	528 <printint>
        i += 1;
 6ea:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ec:	8bca                	mv	s7,s2
      state = 0;
 6ee:	4981                	li	s3,0
        i += 1;
 6f0:	b72d                	j	61a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6f2:	06400793          	li	a5,100
 6f6:	02f60763          	beq	a2,a5,724 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6fa:	07500793          	li	a5,117
 6fe:	06f60963          	beq	a2,a5,770 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 702:	07800793          	li	a5,120
 706:	faf61ee3          	bne	a2,a5,6c2 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 70a:	008b8913          	addi	s2,s7,8
 70e:	4681                	li	a3,0
 710:	4641                	li	a2,16
 712:	000ba583          	lw	a1,0(s7)
 716:	855a                	mv	a0,s6
 718:	e11ff0ef          	jal	528 <printint>
        i += 2;
 71c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 71e:	8bca                	mv	s7,s2
      state = 0;
 720:	4981                	li	s3,0
        i += 2;
 722:	bde5                	j	61a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 724:	008b8913          	addi	s2,s7,8
 728:	4685                	li	a3,1
 72a:	4629                	li	a2,10
 72c:	000ba583          	lw	a1,0(s7)
 730:	855a                	mv	a0,s6
 732:	df7ff0ef          	jal	528 <printint>
        i += 2;
 736:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 738:	8bca                	mv	s7,s2
      state = 0;
 73a:	4981                	li	s3,0
        i += 2;
 73c:	bdf9                	j	61a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 73e:	008b8913          	addi	s2,s7,8
 742:	4681                	li	a3,0
 744:	4629                	li	a2,10
 746:	000ba583          	lw	a1,0(s7)
 74a:	855a                	mv	a0,s6
 74c:	dddff0ef          	jal	528 <printint>
 750:	8bca                	mv	s7,s2
      state = 0;
 752:	4981                	li	s3,0
 754:	b5d9                	j	61a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 756:	008b8913          	addi	s2,s7,8
 75a:	4681                	li	a3,0
 75c:	4629                	li	a2,10
 75e:	000ba583          	lw	a1,0(s7)
 762:	855a                	mv	a0,s6
 764:	dc5ff0ef          	jal	528 <printint>
        i += 1;
 768:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 76a:	8bca                	mv	s7,s2
      state = 0;
 76c:	4981                	li	s3,0
        i += 1;
 76e:	b575                	j	61a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 770:	008b8913          	addi	s2,s7,8
 774:	4681                	li	a3,0
 776:	4629                	li	a2,10
 778:	000ba583          	lw	a1,0(s7)
 77c:	855a                	mv	a0,s6
 77e:	dabff0ef          	jal	528 <printint>
        i += 2;
 782:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 784:	8bca                	mv	s7,s2
      state = 0;
 786:	4981                	li	s3,0
        i += 2;
 788:	bd49                	j	61a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 78a:	008b8913          	addi	s2,s7,8
 78e:	4681                	li	a3,0
 790:	4641                	li	a2,16
 792:	000ba583          	lw	a1,0(s7)
 796:	855a                	mv	a0,s6
 798:	d91ff0ef          	jal	528 <printint>
 79c:	8bca                	mv	s7,s2
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	bdad                	j	61a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a2:	008b8913          	addi	s2,s7,8
 7a6:	4681                	li	a3,0
 7a8:	4641                	li	a2,16
 7aa:	000ba583          	lw	a1,0(s7)
 7ae:	855a                	mv	a0,s6
 7b0:	d79ff0ef          	jal	528 <printint>
        i += 1;
 7b4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b6:	8bca                	mv	s7,s2
      state = 0;
 7b8:	4981                	li	s3,0
        i += 1;
 7ba:	b585                	j	61a <vprintf+0x4a>
 7bc:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7be:	008b8d13          	addi	s10,s7,8
 7c2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7c6:	03000593          	li	a1,48
 7ca:	855a                	mv	a0,s6
 7cc:	d3fff0ef          	jal	50a <putc>
  putc(fd, 'x');
 7d0:	07800593          	li	a1,120
 7d4:	855a                	mv	a0,s6
 7d6:	d35ff0ef          	jal	50a <putc>
 7da:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7dc:	00000b97          	auipc	s7,0x0
 7e0:	2c4b8b93          	addi	s7,s7,708 # aa0 <digits>
 7e4:	03c9d793          	srli	a5,s3,0x3c
 7e8:	97de                	add	a5,a5,s7
 7ea:	0007c583          	lbu	a1,0(a5)
 7ee:	855a                	mv	a0,s6
 7f0:	d1bff0ef          	jal	50a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7f4:	0992                	slli	s3,s3,0x4
 7f6:	397d                	addiw	s2,s2,-1
 7f8:	fe0916e3          	bnez	s2,7e4 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7fc:	8bea                	mv	s7,s10
      state = 0;
 7fe:	4981                	li	s3,0
 800:	6d02                	ld	s10,0(sp)
 802:	bd21                	j	61a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 804:	008b8993          	addi	s3,s7,8
 808:	000bb903          	ld	s2,0(s7)
 80c:	00090f63          	beqz	s2,82a <vprintf+0x25a>
        for(; *s; s++)
 810:	00094583          	lbu	a1,0(s2)
 814:	c195                	beqz	a1,838 <vprintf+0x268>
          putc(fd, *s);
 816:	855a                	mv	a0,s6
 818:	cf3ff0ef          	jal	50a <putc>
        for(; *s; s++)
 81c:	0905                	addi	s2,s2,1
 81e:	00094583          	lbu	a1,0(s2)
 822:	f9f5                	bnez	a1,816 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 824:	8bce                	mv	s7,s3
      state = 0;
 826:	4981                	li	s3,0
 828:	bbcd                	j	61a <vprintf+0x4a>
          s = "(null)";
 82a:	00000917          	auipc	s2,0x0
 82e:	26e90913          	addi	s2,s2,622 # a98 <malloc+0x162>
        for(; *s; s++)
 832:	02800593          	li	a1,40
 836:	b7c5                	j	816 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 838:	8bce                	mv	s7,s3
      state = 0;
 83a:	4981                	li	s3,0
 83c:	bbf9                	j	61a <vprintf+0x4a>
 83e:	64a6                	ld	s1,72(sp)
 840:	79e2                	ld	s3,56(sp)
 842:	7a42                	ld	s4,48(sp)
 844:	7aa2                	ld	s5,40(sp)
 846:	7b02                	ld	s6,32(sp)
 848:	6be2                	ld	s7,24(sp)
 84a:	6c42                	ld	s8,16(sp)
 84c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 84e:	60e6                	ld	ra,88(sp)
 850:	6446                	ld	s0,80(sp)
 852:	6906                	ld	s2,64(sp)
 854:	6125                	addi	sp,sp,96
 856:	8082                	ret

0000000000000858 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 858:	715d                	addi	sp,sp,-80
 85a:	ec06                	sd	ra,24(sp)
 85c:	e822                	sd	s0,16(sp)
 85e:	1000                	addi	s0,sp,32
 860:	e010                	sd	a2,0(s0)
 862:	e414                	sd	a3,8(s0)
 864:	e818                	sd	a4,16(s0)
 866:	ec1c                	sd	a5,24(s0)
 868:	03043023          	sd	a6,32(s0)
 86c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 870:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 874:	8622                	mv	a2,s0
 876:	d5bff0ef          	jal	5d0 <vprintf>
}
 87a:	60e2                	ld	ra,24(sp)
 87c:	6442                	ld	s0,16(sp)
 87e:	6161                	addi	sp,sp,80
 880:	8082                	ret

0000000000000882 <printf>:

void
printf(const char *fmt, ...)
{
 882:	711d                	addi	sp,sp,-96
 884:	ec06                	sd	ra,24(sp)
 886:	e822                	sd	s0,16(sp)
 888:	1000                	addi	s0,sp,32
 88a:	e40c                	sd	a1,8(s0)
 88c:	e810                	sd	a2,16(s0)
 88e:	ec14                	sd	a3,24(s0)
 890:	f018                	sd	a4,32(s0)
 892:	f41c                	sd	a5,40(s0)
 894:	03043823          	sd	a6,48(s0)
 898:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 89c:	00840613          	addi	a2,s0,8
 8a0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8a4:	85aa                	mv	a1,a0
 8a6:	4505                	li	a0,1
 8a8:	d29ff0ef          	jal	5d0 <vprintf>
}
 8ac:	60e2                	ld	ra,24(sp)
 8ae:	6442                	ld	s0,16(sp)
 8b0:	6125                	addi	sp,sp,96
 8b2:	8082                	ret

00000000000008b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b4:	1141                	addi	sp,sp,-16
 8b6:	e422                	sd	s0,8(sp)
 8b8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ba:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8be:	00000797          	auipc	a5,0x0
 8c2:	7427b783          	ld	a5,1858(a5) # 1000 <freep>
 8c6:	a02d                	j	8f0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8c8:	4618                	lw	a4,8(a2)
 8ca:	9f2d                	addw	a4,a4,a1
 8cc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8d0:	6398                	ld	a4,0(a5)
 8d2:	6310                	ld	a2,0(a4)
 8d4:	a83d                	j	912 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8d6:	ff852703          	lw	a4,-8(a0)
 8da:	9f31                	addw	a4,a4,a2
 8dc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8de:	ff053683          	ld	a3,-16(a0)
 8e2:	a091                	j	926 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e4:	6398                	ld	a4,0(a5)
 8e6:	00e7e463          	bltu	a5,a4,8ee <free+0x3a>
 8ea:	00e6ea63          	bltu	a3,a4,8fe <free+0x4a>
{
 8ee:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f0:	fed7fae3          	bgeu	a5,a3,8e4 <free+0x30>
 8f4:	6398                	ld	a4,0(a5)
 8f6:	00e6e463          	bltu	a3,a4,8fe <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fa:	fee7eae3          	bltu	a5,a4,8ee <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8fe:	ff852583          	lw	a1,-8(a0)
 902:	6390                	ld	a2,0(a5)
 904:	02059813          	slli	a6,a1,0x20
 908:	01c85713          	srli	a4,a6,0x1c
 90c:	9736                	add	a4,a4,a3
 90e:	fae60de3          	beq	a2,a4,8c8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 912:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 916:	4790                	lw	a2,8(a5)
 918:	02061593          	slli	a1,a2,0x20
 91c:	01c5d713          	srli	a4,a1,0x1c
 920:	973e                	add	a4,a4,a5
 922:	fae68ae3          	beq	a3,a4,8d6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 926:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 928:	00000717          	auipc	a4,0x0
 92c:	6cf73c23          	sd	a5,1752(a4) # 1000 <freep>
}
 930:	6422                	ld	s0,8(sp)
 932:	0141                	addi	sp,sp,16
 934:	8082                	ret

0000000000000936 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 936:	7139                	addi	sp,sp,-64
 938:	fc06                	sd	ra,56(sp)
 93a:	f822                	sd	s0,48(sp)
 93c:	f426                	sd	s1,40(sp)
 93e:	ec4e                	sd	s3,24(sp)
 940:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 942:	02051493          	slli	s1,a0,0x20
 946:	9081                	srli	s1,s1,0x20
 948:	04bd                	addi	s1,s1,15
 94a:	8091                	srli	s1,s1,0x4
 94c:	0014899b          	addiw	s3,s1,1
 950:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 952:	00000517          	auipc	a0,0x0
 956:	6ae53503          	ld	a0,1710(a0) # 1000 <freep>
 95a:	c915                	beqz	a0,98e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 95e:	4798                	lw	a4,8(a5)
 960:	08977a63          	bgeu	a4,s1,9f4 <malloc+0xbe>
 964:	f04a                	sd	s2,32(sp)
 966:	e852                	sd	s4,16(sp)
 968:	e456                	sd	s5,8(sp)
 96a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 96c:	8a4e                	mv	s4,s3
 96e:	0009871b          	sext.w	a4,s3
 972:	6685                	lui	a3,0x1
 974:	00d77363          	bgeu	a4,a3,97a <malloc+0x44>
 978:	6a05                	lui	s4,0x1
 97a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 97e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 982:	00000917          	auipc	s2,0x0
 986:	67e90913          	addi	s2,s2,1662 # 1000 <freep>
  if(p == (char*)-1)
 98a:	5afd                	li	s5,-1
 98c:	a081                	j	9cc <malloc+0x96>
 98e:	f04a                	sd	s2,32(sp)
 990:	e852                	sd	s4,16(sp)
 992:	e456                	sd	s5,8(sp)
 994:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 996:	00000797          	auipc	a5,0x0
 99a:	67a78793          	addi	a5,a5,1658 # 1010 <base>
 99e:	00000717          	auipc	a4,0x0
 9a2:	66f73123          	sd	a5,1634(a4) # 1000 <freep>
 9a6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9a8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ac:	b7c1                	j	96c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9ae:	6398                	ld	a4,0(a5)
 9b0:	e118                	sd	a4,0(a0)
 9b2:	a8a9                	j	a0c <malloc+0xd6>
  hp->s.size = nu;
 9b4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9b8:	0541                	addi	a0,a0,16
 9ba:	efbff0ef          	jal	8b4 <free>
  return freep;
 9be:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9c2:	c12d                	beqz	a0,a24 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c6:	4798                	lw	a4,8(a5)
 9c8:	02977263          	bgeu	a4,s1,9ec <malloc+0xb6>
    if(p == freep)
 9cc:	00093703          	ld	a4,0(s2)
 9d0:	853e                	mv	a0,a5
 9d2:	fef719e3          	bne	a4,a5,9c4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9d6:	8552                	mv	a0,s4
 9d8:	ad3ff0ef          	jal	4aa <sbrk>
  if(p == (char*)-1)
 9dc:	fd551ce3          	bne	a0,s5,9b4 <malloc+0x7e>
        return 0;
 9e0:	4501                	li	a0,0
 9e2:	7902                	ld	s2,32(sp)
 9e4:	6a42                	ld	s4,16(sp)
 9e6:	6aa2                	ld	s5,8(sp)
 9e8:	6b02                	ld	s6,0(sp)
 9ea:	a03d                	j	a18 <malloc+0xe2>
 9ec:	7902                	ld	s2,32(sp)
 9ee:	6a42                	ld	s4,16(sp)
 9f0:	6aa2                	ld	s5,8(sp)
 9f2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9f4:	fae48de3          	beq	s1,a4,9ae <malloc+0x78>
        p->s.size -= nunits;
 9f8:	4137073b          	subw	a4,a4,s3
 9fc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9fe:	02071693          	slli	a3,a4,0x20
 a02:	01c6d713          	srli	a4,a3,0x1c
 a06:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a08:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a0c:	00000717          	auipc	a4,0x0
 a10:	5ea73a23          	sd	a0,1524(a4) # 1000 <freep>
      return (void*)(p + 1);
 a14:	01078513          	addi	a0,a5,16
  }
}
 a18:	70e2                	ld	ra,56(sp)
 a1a:	7442                	ld	s0,48(sp)
 a1c:	74a2                	ld	s1,40(sp)
 a1e:	69e2                	ld	s3,24(sp)
 a20:	6121                	addi	sp,sp,64
 a22:	8082                	ret
 a24:	7902                	ld	s2,32(sp)
 a26:	6a42                	ld	s4,16(sp)
 a28:	6aa2                	ld	s5,8(sp)
 a2a:	6b02                	ld	s6,0(sp)
 a2c:	b7f5                	j	a18 <malloc+0xe2>
