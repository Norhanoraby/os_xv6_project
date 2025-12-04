
user/_fact:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <is_valid_positive_number>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int is_valid_positive_number(char *str) {
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
    int i = 0;
    
    // Check for empty string
    if(str[0] == '\0') {
   6:	00054783          	lbu	a5,0(a0)
   a:	cba1                	beqz	a5,5a <is_valid_positive_number+0x5a>
   c:	872a                	mv	a4,a0
        return 0;
    }
    
    // Check if starts with a sign (negative not allowed, positive optional)
    if(str[0] == '-') {
   e:	02d00693          	li	a3,45
        return 0;  // Negative numbers not allowed
  12:	4501                	li	a0,0
    if(str[0] == '-') {
  14:	04d78463          	beq	a5,a3,5c <is_valid_positive_number+0x5c>
    }
    
    if(str[0] == '+') {
  18:	02b00693          	li	a3,43
  1c:	02d78563          	beq	a5,a3,46 <is_valid_positive_number+0x46>
            return 0;
        }
    }
    
    // Check if all remaining characters are digits
    while(str[i] != '\0') {
  20:	00074783          	lbu	a5,0(a4)
  24:	4681                	li	a3,0
  26:	0685                	addi	a3,a3,1
  28:	00d70533          	add	a0,a4,a3
        if(str[i] < '0' || str[i] > '9') {
  2c:	4725                	li	a4,9
  2e:	fd07879b          	addiw	a5,a5,-48
  32:	0ff7f793          	zext.b	a5,a5
  36:	02f76663          	bltu	a4,a5,62 <is_valid_positive_number+0x62>
    while(str[i] != '\0') {
  3a:	0505                	addi	a0,a0,1
  3c:	fff54783          	lbu	a5,-1(a0)
  40:	f7fd                	bnez	a5,2e <is_valid_positive_number+0x2e>
            return 0;  // Found a non-digit character
        }
        i++;
    }
    
    return 1;  // Valid positive number
  42:	4505                	li	a0,1
  44:	a821                	j	5c <is_valid_positive_number+0x5c>
        if(str[1] == '\0') {
  46:	00174783          	lbu	a5,1(a4)
            return 0;
  4a:	4501                	li	a0,0
        if(str[1] == '\0') {
  4c:	cb81                	beqz	a5,5c <is_valid_positive_number+0x5c>
    while(str[i] != '\0') {
  4e:	00174783          	lbu	a5,1(a4)
  52:	4685                	li	a3,1
    return 1;  // Valid positive number
  54:	4505                	li	a0,1
    while(str[i] != '\0') {
  56:	fbe1                	bnez	a5,26 <is_valid_positive_number+0x26>
  58:	a011                	j	5c <is_valid_positive_number+0x5c>
        return 0;
  5a:	4501                	li	a0,0
}
  5c:	6422                	ld	s0,8(sp)
  5e:	0141                	addi	sp,sp,16
  60:	8082                	ret
            return 0;  // Found a non-digit character
  62:	4501                	li	a0,0
  64:	bfe5                	j	5c <is_valid_positive_number+0x5c>

0000000000000066 <main>:

int
main(int argc, char *argv[])
{
  66:	1101                	addi	sp,sp,-32
  68:	ec06                	sd	ra,24(sp)
  6a:	e822                	sd	s0,16(sp)
  6c:	1000                	addi	s0,sp,32
    if (argc == 2 && strcmp(argv[1], "?") == 0) {
  6e:	4789                	li	a5,2
  70:	04f51863          	bne	a0,a5,c0 <main+0x5a>
  74:	e426                	sd	s1,8(sp)
  76:	6584                	ld	s1,8(a1)
  78:	00001597          	auipc	a1,0x1
  7c:	90858593          	addi	a1,a1,-1784 # 980 <malloc+0x100>
  80:	8526                	mv	a0,s1
  82:	0c6000ef          	jal	148 <strcmp>
  86:	c505                	beqz	a0,ae <main+0x48>
        printf("You can only calculate factorial for one number\n");
        exit(0);
    }
    
    // Check for negative numbers first
    if (argv[1][0] == '-') {
  88:	0004c703          	lbu	a4,0(s1)
  8c:	02d00793          	li	a5,45
  90:	04f70263          	beq	a4,a5,d4 <main+0x6e>
        printf("Factorial is not defined for negative numbers\n");
        exit(0);
    }
    
    // Validate input for letters and special characters
    if (!is_valid_positive_number(argv[1])) {
  94:	8526                	mv	a0,s1
  96:	f6bff0ef          	jal	0 <is_valid_positive_number>
  9a:	e531                	bnez	a0,e6 <main+0x80>
        printf("Invalid input: please enter a positive number\n");
  9c:	00001517          	auipc	a0,0x1
  a0:	97450513          	addi	a0,a0,-1676 # a10 <malloc+0x190>
  a4:	728000ef          	jal	7cc <printf>
        exit(0);
  a8:	4501                	li	a0,0
  aa:	2da000ef          	jal	384 <exit>
        printf("Usage: fact <positive number>\n");
  ae:	00001517          	auipc	a0,0x1
  b2:	8da50513          	addi	a0,a0,-1830 # 988 <malloc+0x108>
  b6:	716000ef          	jal	7cc <printf>
        exit(0);
  ba:	4501                	li	a0,0
  bc:	2c8000ef          	jal	384 <exit>
  c0:	e426                	sd	s1,8(sp)
        printf("You can only calculate factorial for one number\n");
  c2:	00001517          	auipc	a0,0x1
  c6:	8e650513          	addi	a0,a0,-1818 # 9a8 <malloc+0x128>
  ca:	702000ef          	jal	7cc <printf>
        exit(0);
  ce:	4501                	li	a0,0
  d0:	2b4000ef          	jal	384 <exit>
        printf("Factorial is not defined for negative numbers\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	90c50513          	addi	a0,a0,-1780 # 9e0 <malloc+0x160>
  dc:	6f0000ef          	jal	7cc <printf>
        exit(0);
  e0:	4501                	li	a0,0
  e2:	2a2000ef          	jal	384 <exit>
    }
    
    int num = atoi(argv[1]);
  e6:	8526                	mv	a0,s1
  e8:	1a6000ef          	jal	28e <atoi>
  ec:	85aa                	mv	a1,a0
    int result = 1;
    
    for (int i = 1; i <= num; i++) {
  ee:	02a05463          	blez	a0,116 <main+0xb0>
  f2:	0015071b          	addiw	a4,a0,1
  f6:	4785                	li	a5,1
    int result = 1;
  f8:	4605                	li	a2,1
        result = result * i;
  fa:	02f6063b          	mulw	a2,a2,a5
    for (int i = 1; i <= num; i++) {
  fe:	2785                	addiw	a5,a5,1
 100:	fee79de3          	bne	a5,a4,fa <main+0x94>
    }
    
    printf("Factorial of %d = %d\n", num, result);
 104:	00001517          	auipc	a0,0x1
 108:	93c50513          	addi	a0,a0,-1732 # a40 <malloc+0x1c0>
 10c:	6c0000ef          	jal	7cc <printf>
    exit(0);
 110:	4501                	li	a0,0
 112:	272000ef          	jal	384 <exit>
    int result = 1;
 116:	4605                	li	a2,1
 118:	b7f5                	j	104 <main+0x9e>

000000000000011a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e406                	sd	ra,8(sp)
 11e:	e022                	sd	s0,0(sp)
 120:	0800                	addi	s0,sp,16
  extern int main();
  main();
 122:	f45ff0ef          	jal	66 <main>
  exit(0);
 126:	4501                	li	a0,0
 128:	25c000ef          	jal	384 <exit>

000000000000012c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e422                	sd	s0,8(sp)
 130:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 132:	87aa                	mv	a5,a0
 134:	0585                	addi	a1,a1,1
 136:	0785                	addi	a5,a5,1
 138:	fff5c703          	lbu	a4,-1(a1)
 13c:	fee78fa3          	sb	a4,-1(a5)
 140:	fb75                	bnez	a4,134 <strcpy+0x8>
    ;
  return os;
}
 142:	6422                	ld	s0,8(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret

0000000000000148 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e422                	sd	s0,8(sp)
 14c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 14e:	00054783          	lbu	a5,0(a0)
 152:	cb91                	beqz	a5,166 <strcmp+0x1e>
 154:	0005c703          	lbu	a4,0(a1)
 158:	00f71763          	bne	a4,a5,166 <strcmp+0x1e>
    p++, q++;
 15c:	0505                	addi	a0,a0,1
 15e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 160:	00054783          	lbu	a5,0(a0)
 164:	fbe5                	bnez	a5,154 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 166:	0005c503          	lbu	a0,0(a1)
}
 16a:	40a7853b          	subw	a0,a5,a0
 16e:	6422                	ld	s0,8(sp)
 170:	0141                	addi	sp,sp,16
 172:	8082                	ret

0000000000000174 <strlen>:

uint
strlen(const char *s)
{
 174:	1141                	addi	sp,sp,-16
 176:	e422                	sd	s0,8(sp)
 178:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 17a:	00054783          	lbu	a5,0(a0)
 17e:	cf91                	beqz	a5,19a <strlen+0x26>
 180:	0505                	addi	a0,a0,1
 182:	87aa                	mv	a5,a0
 184:	86be                	mv	a3,a5
 186:	0785                	addi	a5,a5,1
 188:	fff7c703          	lbu	a4,-1(a5)
 18c:	ff65                	bnez	a4,184 <strlen+0x10>
 18e:	40a6853b          	subw	a0,a3,a0
 192:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 194:	6422                	ld	s0,8(sp)
 196:	0141                	addi	sp,sp,16
 198:	8082                	ret
  for(n = 0; s[n]; n++)
 19a:	4501                	li	a0,0
 19c:	bfe5                	j	194 <strlen+0x20>

000000000000019e <memset>:

void*
memset(void *dst, int c, uint n)
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e422                	sd	s0,8(sp)
 1a2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1a4:	ca19                	beqz	a2,1ba <memset+0x1c>
 1a6:	87aa                	mv	a5,a0
 1a8:	1602                	slli	a2,a2,0x20
 1aa:	9201                	srli	a2,a2,0x20
 1ac:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1b0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1b4:	0785                	addi	a5,a5,1
 1b6:	fee79de3          	bne	a5,a4,1b0 <memset+0x12>
  }
  return dst;
}
 1ba:	6422                	ld	s0,8(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret

00000000000001c0 <strchr>:

char*
strchr(const char *s, char c)
{
 1c0:	1141                	addi	sp,sp,-16
 1c2:	e422                	sd	s0,8(sp)
 1c4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1c6:	00054783          	lbu	a5,0(a0)
 1ca:	cb99                	beqz	a5,1e0 <strchr+0x20>
    if(*s == c)
 1cc:	00f58763          	beq	a1,a5,1da <strchr+0x1a>
  for(; *s; s++)
 1d0:	0505                	addi	a0,a0,1
 1d2:	00054783          	lbu	a5,0(a0)
 1d6:	fbfd                	bnez	a5,1cc <strchr+0xc>
      return (char*)s;
  return 0;
 1d8:	4501                	li	a0,0
}
 1da:	6422                	ld	s0,8(sp)
 1dc:	0141                	addi	sp,sp,16
 1de:	8082                	ret
  return 0;
 1e0:	4501                	li	a0,0
 1e2:	bfe5                	j	1da <strchr+0x1a>

00000000000001e4 <gets>:

char*
gets(char *buf, int max)
{
 1e4:	711d                	addi	sp,sp,-96
 1e6:	ec86                	sd	ra,88(sp)
 1e8:	e8a2                	sd	s0,80(sp)
 1ea:	e4a6                	sd	s1,72(sp)
 1ec:	e0ca                	sd	s2,64(sp)
 1ee:	fc4e                	sd	s3,56(sp)
 1f0:	f852                	sd	s4,48(sp)
 1f2:	f456                	sd	s5,40(sp)
 1f4:	f05a                	sd	s6,32(sp)
 1f6:	ec5e                	sd	s7,24(sp)
 1f8:	1080                	addi	s0,sp,96
 1fa:	8baa                	mv	s7,a0
 1fc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fe:	892a                	mv	s2,a0
 200:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 202:	4aa9                	li	s5,10
 204:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 206:	89a6                	mv	s3,s1
 208:	2485                	addiw	s1,s1,1
 20a:	0344d663          	bge	s1,s4,236 <gets+0x52>
    cc = read(0, &c, 1);
 20e:	4605                	li	a2,1
 210:	faf40593          	addi	a1,s0,-81
 214:	4501                	li	a0,0
 216:	186000ef          	jal	39c <read>
    if(cc < 1)
 21a:	00a05e63          	blez	a0,236 <gets+0x52>
    buf[i++] = c;
 21e:	faf44783          	lbu	a5,-81(s0)
 222:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 226:	01578763          	beq	a5,s5,234 <gets+0x50>
 22a:	0905                	addi	s2,s2,1
 22c:	fd679de3          	bne	a5,s6,206 <gets+0x22>
    buf[i++] = c;
 230:	89a6                	mv	s3,s1
 232:	a011                	j	236 <gets+0x52>
 234:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 236:	99de                	add	s3,s3,s7
 238:	00098023          	sb	zero,0(s3)
  return buf;
}
 23c:	855e                	mv	a0,s7
 23e:	60e6                	ld	ra,88(sp)
 240:	6446                	ld	s0,80(sp)
 242:	64a6                	ld	s1,72(sp)
 244:	6906                	ld	s2,64(sp)
 246:	79e2                	ld	s3,56(sp)
 248:	7a42                	ld	s4,48(sp)
 24a:	7aa2                	ld	s5,40(sp)
 24c:	7b02                	ld	s6,32(sp)
 24e:	6be2                	ld	s7,24(sp)
 250:	6125                	addi	sp,sp,96
 252:	8082                	ret

0000000000000254 <stat>:

int
stat(const char *n, struct stat *st)
{
 254:	1101                	addi	sp,sp,-32
 256:	ec06                	sd	ra,24(sp)
 258:	e822                	sd	s0,16(sp)
 25a:	e04a                	sd	s2,0(sp)
 25c:	1000                	addi	s0,sp,32
 25e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 260:	4581                	li	a1,0
 262:	162000ef          	jal	3c4 <open>
  if(fd < 0)
 266:	02054263          	bltz	a0,28a <stat+0x36>
 26a:	e426                	sd	s1,8(sp)
 26c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 26e:	85ca                	mv	a1,s2
 270:	16c000ef          	jal	3dc <fstat>
 274:	892a                	mv	s2,a0
  close(fd);
 276:	8526                	mv	a0,s1
 278:	134000ef          	jal	3ac <close>
  return r;
 27c:	64a2                	ld	s1,8(sp)
}
 27e:	854a                	mv	a0,s2
 280:	60e2                	ld	ra,24(sp)
 282:	6442                	ld	s0,16(sp)
 284:	6902                	ld	s2,0(sp)
 286:	6105                	addi	sp,sp,32
 288:	8082                	ret
    return -1;
 28a:	597d                	li	s2,-1
 28c:	bfcd                	j	27e <stat+0x2a>

000000000000028e <atoi>:

int
atoi(const char *s)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 294:	00054683          	lbu	a3,0(a0)
 298:	fd06879b          	addiw	a5,a3,-48
 29c:	0ff7f793          	zext.b	a5,a5
 2a0:	4625                	li	a2,9
 2a2:	02f66863          	bltu	a2,a5,2d2 <atoi+0x44>
 2a6:	872a                	mv	a4,a0
  n = 0;
 2a8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2aa:	0705                	addi	a4,a4,1
 2ac:	0025179b          	slliw	a5,a0,0x2
 2b0:	9fa9                	addw	a5,a5,a0
 2b2:	0017979b          	slliw	a5,a5,0x1
 2b6:	9fb5                	addw	a5,a5,a3
 2b8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2bc:	00074683          	lbu	a3,0(a4)
 2c0:	fd06879b          	addiw	a5,a3,-48
 2c4:	0ff7f793          	zext.b	a5,a5
 2c8:	fef671e3          	bgeu	a2,a5,2aa <atoi+0x1c>
  return n;
}
 2cc:	6422                	ld	s0,8(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
  n = 0;
 2d2:	4501                	li	a0,0
 2d4:	bfe5                	j	2cc <atoi+0x3e>

00000000000002d6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e422                	sd	s0,8(sp)
 2da:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2dc:	02b57463          	bgeu	a0,a1,304 <memmove+0x2e>
    while(n-- > 0)
 2e0:	00c05f63          	blez	a2,2fe <memmove+0x28>
 2e4:	1602                	slli	a2,a2,0x20
 2e6:	9201                	srli	a2,a2,0x20
 2e8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ec:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ee:	0585                	addi	a1,a1,1
 2f0:	0705                	addi	a4,a4,1
 2f2:	fff5c683          	lbu	a3,-1(a1)
 2f6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2fa:	fef71ae3          	bne	a4,a5,2ee <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2fe:	6422                	ld	s0,8(sp)
 300:	0141                	addi	sp,sp,16
 302:	8082                	ret
    dst += n;
 304:	00c50733          	add	a4,a0,a2
    src += n;
 308:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 30a:	fec05ae3          	blez	a2,2fe <memmove+0x28>
 30e:	fff6079b          	addiw	a5,a2,-1
 312:	1782                	slli	a5,a5,0x20
 314:	9381                	srli	a5,a5,0x20
 316:	fff7c793          	not	a5,a5
 31a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 31c:	15fd                	addi	a1,a1,-1
 31e:	177d                	addi	a4,a4,-1
 320:	0005c683          	lbu	a3,0(a1)
 324:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 328:	fee79ae3          	bne	a5,a4,31c <memmove+0x46>
 32c:	bfc9                	j	2fe <memmove+0x28>

000000000000032e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 32e:	1141                	addi	sp,sp,-16
 330:	e422                	sd	s0,8(sp)
 332:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 334:	ca05                	beqz	a2,364 <memcmp+0x36>
 336:	fff6069b          	addiw	a3,a2,-1
 33a:	1682                	slli	a3,a3,0x20
 33c:	9281                	srli	a3,a3,0x20
 33e:	0685                	addi	a3,a3,1
 340:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 342:	00054783          	lbu	a5,0(a0)
 346:	0005c703          	lbu	a4,0(a1)
 34a:	00e79863          	bne	a5,a4,35a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 34e:	0505                	addi	a0,a0,1
    p2++;
 350:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 352:	fed518e3          	bne	a0,a3,342 <memcmp+0x14>
  }
  return 0;
 356:	4501                	li	a0,0
 358:	a019                	j	35e <memcmp+0x30>
      return *p1 - *p2;
 35a:	40e7853b          	subw	a0,a5,a4
}
 35e:	6422                	ld	s0,8(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret
  return 0;
 364:	4501                	li	a0,0
 366:	bfe5                	j	35e <memcmp+0x30>

0000000000000368 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e406                	sd	ra,8(sp)
 36c:	e022                	sd	s0,0(sp)
 36e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 370:	f67ff0ef          	jal	2d6 <memmove>
}
 374:	60a2                	ld	ra,8(sp)
 376:	6402                	ld	s0,0(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret

000000000000037c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 37c:	4885                	li	a7,1
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <exit>:
.global exit
exit:
 li a7, SYS_exit
 384:	4889                	li	a7,2
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <wait>:
.global wait
wait:
 li a7, SYS_wait
 38c:	488d                	li	a7,3
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 394:	4891                	li	a7,4
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <read>:
.global read
read:
 li a7, SYS_read
 39c:	4895                	li	a7,5
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <write>:
.global write
write:
 li a7, SYS_write
 3a4:	48c1                	li	a7,16
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <close>:
.global close
close:
 li a7, SYS_close
 3ac:	48d5                	li	a7,21
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3b4:	4899                	li	a7,6
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <exec>:
.global exec
exec:
 li a7, SYS_exec
 3bc:	489d                	li	a7,7
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <open>:
.global open
open:
 li a7, SYS_open
 3c4:	48bd                	li	a7,15
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3cc:	48c5                	li	a7,17
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3d4:	48c9                	li	a7,18
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3dc:	48a1                	li	a7,8
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <link>:
.global link
link:
 li a7, SYS_link
 3e4:	48cd                	li	a7,19
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3ec:	48d1                	li	a7,20
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3f4:	48a5                	li	a7,9
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <dup>:
.global dup
dup:
 li a7, SYS_dup
 3fc:	48a9                	li	a7,10
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 404:	48ad                	li	a7,11
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 40c:	48b1                	li	a7,12
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 414:	48b5                	li	a7,13
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 41c:	48b9                	li	a7,14
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 424:	48d9                	li	a7,22
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 42c:	48dd                	li	a7,23
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 434:	48e1                	li	a7,24
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 43c:	48e5                	li	a7,25
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <rand>:
.global rand
rand:
 li a7, SYS_rand
 444:	48e9                	li	a7,26
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 44c:	48ed                	li	a7,27
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 454:	1101                	addi	sp,sp,-32
 456:	ec06                	sd	ra,24(sp)
 458:	e822                	sd	s0,16(sp)
 45a:	1000                	addi	s0,sp,32
 45c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 460:	4605                	li	a2,1
 462:	fef40593          	addi	a1,s0,-17
 466:	f3fff0ef          	jal	3a4 <write>
}
 46a:	60e2                	ld	ra,24(sp)
 46c:	6442                	ld	s0,16(sp)
 46e:	6105                	addi	sp,sp,32
 470:	8082                	ret

0000000000000472 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 472:	7139                	addi	sp,sp,-64
 474:	fc06                	sd	ra,56(sp)
 476:	f822                	sd	s0,48(sp)
 478:	f426                	sd	s1,40(sp)
 47a:	0080                	addi	s0,sp,64
 47c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 47e:	c299                	beqz	a3,484 <printint+0x12>
 480:	0805c963          	bltz	a1,512 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 484:	2581                	sext.w	a1,a1
  neg = 0;
 486:	4881                	li	a7,0
 488:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 48c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 48e:	2601                	sext.w	a2,a2
 490:	00000517          	auipc	a0,0x0
 494:	5d050513          	addi	a0,a0,1488 # a60 <digits>
 498:	883a                	mv	a6,a4
 49a:	2705                	addiw	a4,a4,1
 49c:	02c5f7bb          	remuw	a5,a1,a2
 4a0:	1782                	slli	a5,a5,0x20
 4a2:	9381                	srli	a5,a5,0x20
 4a4:	97aa                	add	a5,a5,a0
 4a6:	0007c783          	lbu	a5,0(a5)
 4aa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ae:	0005879b          	sext.w	a5,a1
 4b2:	02c5d5bb          	divuw	a1,a1,a2
 4b6:	0685                	addi	a3,a3,1
 4b8:	fec7f0e3          	bgeu	a5,a2,498 <printint+0x26>
  if(neg)
 4bc:	00088c63          	beqz	a7,4d4 <printint+0x62>
    buf[i++] = '-';
 4c0:	fd070793          	addi	a5,a4,-48
 4c4:	00878733          	add	a4,a5,s0
 4c8:	02d00793          	li	a5,45
 4cc:	fef70823          	sb	a5,-16(a4)
 4d0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4d4:	02e05a63          	blez	a4,508 <printint+0x96>
 4d8:	f04a                	sd	s2,32(sp)
 4da:	ec4e                	sd	s3,24(sp)
 4dc:	fc040793          	addi	a5,s0,-64
 4e0:	00e78933          	add	s2,a5,a4
 4e4:	fff78993          	addi	s3,a5,-1
 4e8:	99ba                	add	s3,s3,a4
 4ea:	377d                	addiw	a4,a4,-1
 4ec:	1702                	slli	a4,a4,0x20
 4ee:	9301                	srli	a4,a4,0x20
 4f0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f4:	fff94583          	lbu	a1,-1(s2)
 4f8:	8526                	mv	a0,s1
 4fa:	f5bff0ef          	jal	454 <putc>
  while(--i >= 0)
 4fe:	197d                	addi	s2,s2,-1
 500:	ff391ae3          	bne	s2,s3,4f4 <printint+0x82>
 504:	7902                	ld	s2,32(sp)
 506:	69e2                	ld	s3,24(sp)
}
 508:	70e2                	ld	ra,56(sp)
 50a:	7442                	ld	s0,48(sp)
 50c:	74a2                	ld	s1,40(sp)
 50e:	6121                	addi	sp,sp,64
 510:	8082                	ret
    x = -xx;
 512:	40b005bb          	negw	a1,a1
    neg = 1;
 516:	4885                	li	a7,1
    x = -xx;
 518:	bf85                	j	488 <printint+0x16>

000000000000051a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 51a:	711d                	addi	sp,sp,-96
 51c:	ec86                	sd	ra,88(sp)
 51e:	e8a2                	sd	s0,80(sp)
 520:	e0ca                	sd	s2,64(sp)
 522:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 524:	0005c903          	lbu	s2,0(a1)
 528:	26090863          	beqz	s2,798 <vprintf+0x27e>
 52c:	e4a6                	sd	s1,72(sp)
 52e:	fc4e                	sd	s3,56(sp)
 530:	f852                	sd	s4,48(sp)
 532:	f456                	sd	s5,40(sp)
 534:	f05a                	sd	s6,32(sp)
 536:	ec5e                	sd	s7,24(sp)
 538:	e862                	sd	s8,16(sp)
 53a:	e466                	sd	s9,8(sp)
 53c:	8b2a                	mv	s6,a0
 53e:	8a2e                	mv	s4,a1
 540:	8bb2                	mv	s7,a2
  state = 0;
 542:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 544:	4481                	li	s1,0
 546:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 548:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 54c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 550:	06c00c93          	li	s9,108
 554:	a005                	j	574 <vprintf+0x5a>
        putc(fd, c0);
 556:	85ca                	mv	a1,s2
 558:	855a                	mv	a0,s6
 55a:	efbff0ef          	jal	454 <putc>
 55e:	a019                	j	564 <vprintf+0x4a>
    } else if(state == '%'){
 560:	03598263          	beq	s3,s5,584 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 564:	2485                	addiw	s1,s1,1
 566:	8726                	mv	a4,s1
 568:	009a07b3          	add	a5,s4,s1
 56c:	0007c903          	lbu	s2,0(a5)
 570:	20090c63          	beqz	s2,788 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 574:	0009079b          	sext.w	a5,s2
    if(state == 0){
 578:	fe0994e3          	bnez	s3,560 <vprintf+0x46>
      if(c0 == '%'){
 57c:	fd579de3          	bne	a5,s5,556 <vprintf+0x3c>
        state = '%';
 580:	89be                	mv	s3,a5
 582:	b7cd                	j	564 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 584:	00ea06b3          	add	a3,s4,a4
 588:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 58c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 58e:	c681                	beqz	a3,596 <vprintf+0x7c>
 590:	9752                	add	a4,a4,s4
 592:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 596:	03878f63          	beq	a5,s8,5d4 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 59a:	05978963          	beq	a5,s9,5ec <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 59e:	07500713          	li	a4,117
 5a2:	0ee78363          	beq	a5,a4,688 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5a6:	07800713          	li	a4,120
 5aa:	12e78563          	beq	a5,a4,6d4 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5ae:	07000713          	li	a4,112
 5b2:	14e78a63          	beq	a5,a4,706 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5b6:	07300713          	li	a4,115
 5ba:	18e78a63          	beq	a5,a4,74e <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5be:	02500713          	li	a4,37
 5c2:	04e79563          	bne	a5,a4,60c <vprintf+0xf2>
        putc(fd, '%');
 5c6:	02500593          	li	a1,37
 5ca:	855a                	mv	a0,s6
 5cc:	e89ff0ef          	jal	454 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	bf49                	j	564 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5d4:	008b8913          	addi	s2,s7,8
 5d8:	4685                	li	a3,1
 5da:	4629                	li	a2,10
 5dc:	000ba583          	lw	a1,0(s7)
 5e0:	855a                	mv	a0,s6
 5e2:	e91ff0ef          	jal	472 <printint>
 5e6:	8bca                	mv	s7,s2
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	bfad                	j	564 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5ec:	06400793          	li	a5,100
 5f0:	02f68963          	beq	a3,a5,622 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5f4:	06c00793          	li	a5,108
 5f8:	04f68263          	beq	a3,a5,63c <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5fc:	07500793          	li	a5,117
 600:	0af68063          	beq	a3,a5,6a0 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 604:	07800793          	li	a5,120
 608:	0ef68263          	beq	a3,a5,6ec <vprintf+0x1d2>
        putc(fd, '%');
 60c:	02500593          	li	a1,37
 610:	855a                	mv	a0,s6
 612:	e43ff0ef          	jal	454 <putc>
        putc(fd, c0);
 616:	85ca                	mv	a1,s2
 618:	855a                	mv	a0,s6
 61a:	e3bff0ef          	jal	454 <putc>
      state = 0;
 61e:	4981                	li	s3,0
 620:	b791                	j	564 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 622:	008b8913          	addi	s2,s7,8
 626:	4685                	li	a3,1
 628:	4629                	li	a2,10
 62a:	000ba583          	lw	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	e43ff0ef          	jal	472 <printint>
        i += 1;
 634:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 636:	8bca                	mv	s7,s2
      state = 0;
 638:	4981                	li	s3,0
        i += 1;
 63a:	b72d                	j	564 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 63c:	06400793          	li	a5,100
 640:	02f60763          	beq	a2,a5,66e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 644:	07500793          	li	a5,117
 648:	06f60963          	beq	a2,a5,6ba <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 64c:	07800793          	li	a5,120
 650:	faf61ee3          	bne	a2,a5,60c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 654:	008b8913          	addi	s2,s7,8
 658:	4681                	li	a3,0
 65a:	4641                	li	a2,16
 65c:	000ba583          	lw	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	e11ff0ef          	jal	472 <printint>
        i += 2;
 666:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 668:	8bca                	mv	s7,s2
      state = 0;
 66a:	4981                	li	s3,0
        i += 2;
 66c:	bde5                	j	564 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 66e:	008b8913          	addi	s2,s7,8
 672:	4685                	li	a3,1
 674:	4629                	li	a2,10
 676:	000ba583          	lw	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	df7ff0ef          	jal	472 <printint>
        i += 2;
 680:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 682:	8bca                	mv	s7,s2
      state = 0;
 684:	4981                	li	s3,0
        i += 2;
 686:	bdf9                	j	564 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 688:	008b8913          	addi	s2,s7,8
 68c:	4681                	li	a3,0
 68e:	4629                	li	a2,10
 690:	000ba583          	lw	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	dddff0ef          	jal	472 <printint>
 69a:	8bca                	mv	s7,s2
      state = 0;
 69c:	4981                	li	s3,0
 69e:	b5d9                	j	564 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a0:	008b8913          	addi	s2,s7,8
 6a4:	4681                	li	a3,0
 6a6:	4629                	li	a2,10
 6a8:	000ba583          	lw	a1,0(s7)
 6ac:	855a                	mv	a0,s6
 6ae:	dc5ff0ef          	jal	472 <printint>
        i += 1;
 6b2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b4:	8bca                	mv	s7,s2
      state = 0;
 6b6:	4981                	li	s3,0
        i += 1;
 6b8:	b575                	j	564 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ba:	008b8913          	addi	s2,s7,8
 6be:	4681                	li	a3,0
 6c0:	4629                	li	a2,10
 6c2:	000ba583          	lw	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	dabff0ef          	jal	472 <printint>
        i += 2;
 6cc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ce:	8bca                	mv	s7,s2
      state = 0;
 6d0:	4981                	li	s3,0
        i += 2;
 6d2:	bd49                	j	564 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6d4:	008b8913          	addi	s2,s7,8
 6d8:	4681                	li	a3,0
 6da:	4641                	li	a2,16
 6dc:	000ba583          	lw	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	d91ff0ef          	jal	472 <printint>
 6e6:	8bca                	mv	s7,s2
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bdad                	j	564 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ec:	008b8913          	addi	s2,s7,8
 6f0:	4681                	li	a3,0
 6f2:	4641                	li	a2,16
 6f4:	000ba583          	lw	a1,0(s7)
 6f8:	855a                	mv	a0,s6
 6fa:	d79ff0ef          	jal	472 <printint>
        i += 1;
 6fe:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 700:	8bca                	mv	s7,s2
      state = 0;
 702:	4981                	li	s3,0
        i += 1;
 704:	b585                	j	564 <vprintf+0x4a>
 706:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 708:	008b8d13          	addi	s10,s7,8
 70c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 710:	03000593          	li	a1,48
 714:	855a                	mv	a0,s6
 716:	d3fff0ef          	jal	454 <putc>
  putc(fd, 'x');
 71a:	07800593          	li	a1,120
 71e:	855a                	mv	a0,s6
 720:	d35ff0ef          	jal	454 <putc>
 724:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 726:	00000b97          	auipc	s7,0x0
 72a:	33ab8b93          	addi	s7,s7,826 # a60 <digits>
 72e:	03c9d793          	srli	a5,s3,0x3c
 732:	97de                	add	a5,a5,s7
 734:	0007c583          	lbu	a1,0(a5)
 738:	855a                	mv	a0,s6
 73a:	d1bff0ef          	jal	454 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 73e:	0992                	slli	s3,s3,0x4
 740:	397d                	addiw	s2,s2,-1
 742:	fe0916e3          	bnez	s2,72e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 746:	8bea                	mv	s7,s10
      state = 0;
 748:	4981                	li	s3,0
 74a:	6d02                	ld	s10,0(sp)
 74c:	bd21                	j	564 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 74e:	008b8993          	addi	s3,s7,8
 752:	000bb903          	ld	s2,0(s7)
 756:	00090f63          	beqz	s2,774 <vprintf+0x25a>
        for(; *s; s++)
 75a:	00094583          	lbu	a1,0(s2)
 75e:	c195                	beqz	a1,782 <vprintf+0x268>
          putc(fd, *s);
 760:	855a                	mv	a0,s6
 762:	cf3ff0ef          	jal	454 <putc>
        for(; *s; s++)
 766:	0905                	addi	s2,s2,1
 768:	00094583          	lbu	a1,0(s2)
 76c:	f9f5                	bnez	a1,760 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 76e:	8bce                	mv	s7,s3
      state = 0;
 770:	4981                	li	s3,0
 772:	bbcd                	j	564 <vprintf+0x4a>
          s = "(null)";
 774:	00000917          	auipc	s2,0x0
 778:	2e490913          	addi	s2,s2,740 # a58 <malloc+0x1d8>
        for(; *s; s++)
 77c:	02800593          	li	a1,40
 780:	b7c5                	j	760 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 782:	8bce                	mv	s7,s3
      state = 0;
 784:	4981                	li	s3,0
 786:	bbf9                	j	564 <vprintf+0x4a>
 788:	64a6                	ld	s1,72(sp)
 78a:	79e2                	ld	s3,56(sp)
 78c:	7a42                	ld	s4,48(sp)
 78e:	7aa2                	ld	s5,40(sp)
 790:	7b02                	ld	s6,32(sp)
 792:	6be2                	ld	s7,24(sp)
 794:	6c42                	ld	s8,16(sp)
 796:	6ca2                	ld	s9,8(sp)
    }
  }
}
 798:	60e6                	ld	ra,88(sp)
 79a:	6446                	ld	s0,80(sp)
 79c:	6906                	ld	s2,64(sp)
 79e:	6125                	addi	sp,sp,96
 7a0:	8082                	ret

00000000000007a2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a2:	715d                	addi	sp,sp,-80
 7a4:	ec06                	sd	ra,24(sp)
 7a6:	e822                	sd	s0,16(sp)
 7a8:	1000                	addi	s0,sp,32
 7aa:	e010                	sd	a2,0(s0)
 7ac:	e414                	sd	a3,8(s0)
 7ae:	e818                	sd	a4,16(s0)
 7b0:	ec1c                	sd	a5,24(s0)
 7b2:	03043023          	sd	a6,32(s0)
 7b6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ba:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7be:	8622                	mv	a2,s0
 7c0:	d5bff0ef          	jal	51a <vprintf>
}
 7c4:	60e2                	ld	ra,24(sp)
 7c6:	6442                	ld	s0,16(sp)
 7c8:	6161                	addi	sp,sp,80
 7ca:	8082                	ret

00000000000007cc <printf>:

void
printf(const char *fmt, ...)
{
 7cc:	711d                	addi	sp,sp,-96
 7ce:	ec06                	sd	ra,24(sp)
 7d0:	e822                	sd	s0,16(sp)
 7d2:	1000                	addi	s0,sp,32
 7d4:	e40c                	sd	a1,8(s0)
 7d6:	e810                	sd	a2,16(s0)
 7d8:	ec14                	sd	a3,24(s0)
 7da:	f018                	sd	a4,32(s0)
 7dc:	f41c                	sd	a5,40(s0)
 7de:	03043823          	sd	a6,48(s0)
 7e2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7e6:	00840613          	addi	a2,s0,8
 7ea:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ee:	85aa                	mv	a1,a0
 7f0:	4505                	li	a0,1
 7f2:	d29ff0ef          	jal	51a <vprintf>
}
 7f6:	60e2                	ld	ra,24(sp)
 7f8:	6442                	ld	s0,16(sp)
 7fa:	6125                	addi	sp,sp,96
 7fc:	8082                	ret

00000000000007fe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7fe:	1141                	addi	sp,sp,-16
 800:	e422                	sd	s0,8(sp)
 802:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 804:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 808:	00000797          	auipc	a5,0x0
 80c:	7f87b783          	ld	a5,2040(a5) # 1000 <freep>
 810:	a02d                	j	83a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 812:	4618                	lw	a4,8(a2)
 814:	9f2d                	addw	a4,a4,a1
 816:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 81a:	6398                	ld	a4,0(a5)
 81c:	6310                	ld	a2,0(a4)
 81e:	a83d                	j	85c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 820:	ff852703          	lw	a4,-8(a0)
 824:	9f31                	addw	a4,a4,a2
 826:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 828:	ff053683          	ld	a3,-16(a0)
 82c:	a091                	j	870 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82e:	6398                	ld	a4,0(a5)
 830:	00e7e463          	bltu	a5,a4,838 <free+0x3a>
 834:	00e6ea63          	bltu	a3,a4,848 <free+0x4a>
{
 838:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 83a:	fed7fae3          	bgeu	a5,a3,82e <free+0x30>
 83e:	6398                	ld	a4,0(a5)
 840:	00e6e463          	bltu	a3,a4,848 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 844:	fee7eae3          	bltu	a5,a4,838 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 848:	ff852583          	lw	a1,-8(a0)
 84c:	6390                	ld	a2,0(a5)
 84e:	02059813          	slli	a6,a1,0x20
 852:	01c85713          	srli	a4,a6,0x1c
 856:	9736                	add	a4,a4,a3
 858:	fae60de3          	beq	a2,a4,812 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 85c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 860:	4790                	lw	a2,8(a5)
 862:	02061593          	slli	a1,a2,0x20
 866:	01c5d713          	srli	a4,a1,0x1c
 86a:	973e                	add	a4,a4,a5
 86c:	fae68ae3          	beq	a3,a4,820 <free+0x22>
    p->s.ptr = bp->s.ptr;
 870:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 872:	00000717          	auipc	a4,0x0
 876:	78f73723          	sd	a5,1934(a4) # 1000 <freep>
}
 87a:	6422                	ld	s0,8(sp)
 87c:	0141                	addi	sp,sp,16
 87e:	8082                	ret

0000000000000880 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 880:	7139                	addi	sp,sp,-64
 882:	fc06                	sd	ra,56(sp)
 884:	f822                	sd	s0,48(sp)
 886:	f426                	sd	s1,40(sp)
 888:	ec4e                	sd	s3,24(sp)
 88a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88c:	02051493          	slli	s1,a0,0x20
 890:	9081                	srli	s1,s1,0x20
 892:	04bd                	addi	s1,s1,15
 894:	8091                	srli	s1,s1,0x4
 896:	0014899b          	addiw	s3,s1,1
 89a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 89c:	00000517          	auipc	a0,0x0
 8a0:	76453503          	ld	a0,1892(a0) # 1000 <freep>
 8a4:	c915                	beqz	a0,8d8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a8:	4798                	lw	a4,8(a5)
 8aa:	08977a63          	bgeu	a4,s1,93e <malloc+0xbe>
 8ae:	f04a                	sd	s2,32(sp)
 8b0:	e852                	sd	s4,16(sp)
 8b2:	e456                	sd	s5,8(sp)
 8b4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8b6:	8a4e                	mv	s4,s3
 8b8:	0009871b          	sext.w	a4,s3
 8bc:	6685                	lui	a3,0x1
 8be:	00d77363          	bgeu	a4,a3,8c4 <malloc+0x44>
 8c2:	6a05                	lui	s4,0x1
 8c4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8c8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8cc:	00000917          	auipc	s2,0x0
 8d0:	73490913          	addi	s2,s2,1844 # 1000 <freep>
  if(p == (char*)-1)
 8d4:	5afd                	li	s5,-1
 8d6:	a081                	j	916 <malloc+0x96>
 8d8:	f04a                	sd	s2,32(sp)
 8da:	e852                	sd	s4,16(sp)
 8dc:	e456                	sd	s5,8(sp)
 8de:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8e0:	00000797          	auipc	a5,0x0
 8e4:	73078793          	addi	a5,a5,1840 # 1010 <base>
 8e8:	00000717          	auipc	a4,0x0
 8ec:	70f73c23          	sd	a5,1816(a4) # 1000 <freep>
 8f0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8f6:	b7c1                	j	8b6 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8f8:	6398                	ld	a4,0(a5)
 8fa:	e118                	sd	a4,0(a0)
 8fc:	a8a9                	j	956 <malloc+0xd6>
  hp->s.size = nu;
 8fe:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 902:	0541                	addi	a0,a0,16
 904:	efbff0ef          	jal	7fe <free>
  return freep;
 908:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 90c:	c12d                	beqz	a0,96e <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 910:	4798                	lw	a4,8(a5)
 912:	02977263          	bgeu	a4,s1,936 <malloc+0xb6>
    if(p == freep)
 916:	00093703          	ld	a4,0(s2)
 91a:	853e                	mv	a0,a5
 91c:	fef719e3          	bne	a4,a5,90e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 920:	8552                	mv	a0,s4
 922:	aebff0ef          	jal	40c <sbrk>
  if(p == (char*)-1)
 926:	fd551ce3          	bne	a0,s5,8fe <malloc+0x7e>
        return 0;
 92a:	4501                	li	a0,0
 92c:	7902                	ld	s2,32(sp)
 92e:	6a42                	ld	s4,16(sp)
 930:	6aa2                	ld	s5,8(sp)
 932:	6b02                	ld	s6,0(sp)
 934:	a03d                	j	962 <malloc+0xe2>
 936:	7902                	ld	s2,32(sp)
 938:	6a42                	ld	s4,16(sp)
 93a:	6aa2                	ld	s5,8(sp)
 93c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 93e:	fae48de3          	beq	s1,a4,8f8 <malloc+0x78>
        p->s.size -= nunits;
 942:	4137073b          	subw	a4,a4,s3
 946:	c798                	sw	a4,8(a5)
        p += p->s.size;
 948:	02071693          	slli	a3,a4,0x20
 94c:	01c6d713          	srli	a4,a3,0x1c
 950:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 952:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 956:	00000717          	auipc	a4,0x0
 95a:	6aa73523          	sd	a0,1706(a4) # 1000 <freep>
      return (void*)(p + 1);
 95e:	01078513          	addi	a0,a5,16
  }
}
 962:	70e2                	ld	ra,56(sp)
 964:	7442                	ld	s0,48(sp)
 966:	74a2                	ld	s1,40(sp)
 968:	69e2                	ld	s3,24(sp)
 96a:	6121                	addi	sp,sp,64
 96c:	8082                	ret
 96e:	7902                	ld	s2,32(sp)
 970:	6a42                	ld	s4,16(sp)
 972:	6aa2                	ld	s5,8(sp)
 974:	6b02                	ld	s6,0(sp)
 976:	b7f5                	j	962 <malloc+0xe2>
