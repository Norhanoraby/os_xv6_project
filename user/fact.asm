
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
  7c:	91858593          	addi	a1,a1,-1768 # 990 <malloc+0xf8>
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
  a0:	98450513          	addi	a0,a0,-1660 # a20 <malloc+0x188>
  a4:	740000ef          	jal	7e4 <printf>
        exit(0);
  a8:	4501                	li	a0,0
  aa:	2da000ef          	jal	384 <exit>
        printf("Usage: fact <positive number>\n");
  ae:	00001517          	auipc	a0,0x1
  b2:	8ea50513          	addi	a0,a0,-1814 # 998 <malloc+0x100>
  b6:	72e000ef          	jal	7e4 <printf>
        exit(0);
  ba:	4501                	li	a0,0
  bc:	2c8000ef          	jal	384 <exit>
  c0:	e426                	sd	s1,8(sp)
        printf("You can only calculate factorial for one number\n");
  c2:	00001517          	auipc	a0,0x1
  c6:	8f650513          	addi	a0,a0,-1802 # 9b8 <malloc+0x120>
  ca:	71a000ef          	jal	7e4 <printf>
        exit(0);
  ce:	4501                	li	a0,0
  d0:	2b4000ef          	jal	384 <exit>
        printf("Factorial is not defined for negative numbers\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	91c50513          	addi	a0,a0,-1764 # 9f0 <malloc+0x158>
  dc:	708000ef          	jal	7e4 <printf>
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
 108:	94c50513          	addi	a0,a0,-1716 # a50 <malloc+0x1b8>
 10c:	6d8000ef          	jal	7e4 <printf>
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

0000000000000444 <random>:
.global random
random:
 li a7, SYS_random
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

0000000000000454 <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 454:	48f1                	li	a7,28
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <set_sched>:
.global set_sched
set_sched:
 li a7, SYS_set_sched
 45c:	48f5                	li	a7,29
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <wait_sched>:
.global wait_sched
wait_sched:
 li a7, SYS_wait_sched
 464:	48f9                	li	a7,30
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 46c:	1101                	addi	sp,sp,-32
 46e:	ec06                	sd	ra,24(sp)
 470:	e822                	sd	s0,16(sp)
 472:	1000                	addi	s0,sp,32
 474:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 478:	4605                	li	a2,1
 47a:	fef40593          	addi	a1,s0,-17
 47e:	f27ff0ef          	jal	3a4 <write>
}
 482:	60e2                	ld	ra,24(sp)
 484:	6442                	ld	s0,16(sp)
 486:	6105                	addi	sp,sp,32
 488:	8082                	ret

000000000000048a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 48a:	7139                	addi	sp,sp,-64
 48c:	fc06                	sd	ra,56(sp)
 48e:	f822                	sd	s0,48(sp)
 490:	f426                	sd	s1,40(sp)
 492:	0080                	addi	s0,sp,64
 494:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 496:	c299                	beqz	a3,49c <printint+0x12>
 498:	0805c963          	bltz	a1,52a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 49c:	2581                	sext.w	a1,a1
  neg = 0;
 49e:	4881                	li	a7,0
 4a0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4a4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4a6:	2601                	sext.w	a2,a2
 4a8:	00000517          	auipc	a0,0x0
 4ac:	5c850513          	addi	a0,a0,1480 # a70 <digits>
 4b0:	883a                	mv	a6,a4
 4b2:	2705                	addiw	a4,a4,1
 4b4:	02c5f7bb          	remuw	a5,a1,a2
 4b8:	1782                	slli	a5,a5,0x20
 4ba:	9381                	srli	a5,a5,0x20
 4bc:	97aa                	add	a5,a5,a0
 4be:	0007c783          	lbu	a5,0(a5)
 4c2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4c6:	0005879b          	sext.w	a5,a1
 4ca:	02c5d5bb          	divuw	a1,a1,a2
 4ce:	0685                	addi	a3,a3,1
 4d0:	fec7f0e3          	bgeu	a5,a2,4b0 <printint+0x26>
  if(neg)
 4d4:	00088c63          	beqz	a7,4ec <printint+0x62>
    buf[i++] = '-';
 4d8:	fd070793          	addi	a5,a4,-48
 4dc:	00878733          	add	a4,a5,s0
 4e0:	02d00793          	li	a5,45
 4e4:	fef70823          	sb	a5,-16(a4)
 4e8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4ec:	02e05a63          	blez	a4,520 <printint+0x96>
 4f0:	f04a                	sd	s2,32(sp)
 4f2:	ec4e                	sd	s3,24(sp)
 4f4:	fc040793          	addi	a5,s0,-64
 4f8:	00e78933          	add	s2,a5,a4
 4fc:	fff78993          	addi	s3,a5,-1
 500:	99ba                	add	s3,s3,a4
 502:	377d                	addiw	a4,a4,-1
 504:	1702                	slli	a4,a4,0x20
 506:	9301                	srli	a4,a4,0x20
 508:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 50c:	fff94583          	lbu	a1,-1(s2)
 510:	8526                	mv	a0,s1
 512:	f5bff0ef          	jal	46c <putc>
  while(--i >= 0)
 516:	197d                	addi	s2,s2,-1
 518:	ff391ae3          	bne	s2,s3,50c <printint+0x82>
 51c:	7902                	ld	s2,32(sp)
 51e:	69e2                	ld	s3,24(sp)
}
 520:	70e2                	ld	ra,56(sp)
 522:	7442                	ld	s0,48(sp)
 524:	74a2                	ld	s1,40(sp)
 526:	6121                	addi	sp,sp,64
 528:	8082                	ret
    x = -xx;
 52a:	40b005bb          	negw	a1,a1
    neg = 1;
 52e:	4885                	li	a7,1
    x = -xx;
 530:	bf85                	j	4a0 <printint+0x16>

0000000000000532 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 532:	711d                	addi	sp,sp,-96
 534:	ec86                	sd	ra,88(sp)
 536:	e8a2                	sd	s0,80(sp)
 538:	e0ca                	sd	s2,64(sp)
 53a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 53c:	0005c903          	lbu	s2,0(a1)
 540:	26090863          	beqz	s2,7b0 <vprintf+0x27e>
 544:	e4a6                	sd	s1,72(sp)
 546:	fc4e                	sd	s3,56(sp)
 548:	f852                	sd	s4,48(sp)
 54a:	f456                	sd	s5,40(sp)
 54c:	f05a                	sd	s6,32(sp)
 54e:	ec5e                	sd	s7,24(sp)
 550:	e862                	sd	s8,16(sp)
 552:	e466                	sd	s9,8(sp)
 554:	8b2a                	mv	s6,a0
 556:	8a2e                	mv	s4,a1
 558:	8bb2                	mv	s7,a2
  state = 0;
 55a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 55c:	4481                	li	s1,0
 55e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 560:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 564:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 568:	06c00c93          	li	s9,108
 56c:	a005                	j	58c <vprintf+0x5a>
        putc(fd, c0);
 56e:	85ca                	mv	a1,s2
 570:	855a                	mv	a0,s6
 572:	efbff0ef          	jal	46c <putc>
 576:	a019                	j	57c <vprintf+0x4a>
    } else if(state == '%'){
 578:	03598263          	beq	s3,s5,59c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 57c:	2485                	addiw	s1,s1,1
 57e:	8726                	mv	a4,s1
 580:	009a07b3          	add	a5,s4,s1
 584:	0007c903          	lbu	s2,0(a5)
 588:	20090c63          	beqz	s2,7a0 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 58c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 590:	fe0994e3          	bnez	s3,578 <vprintf+0x46>
      if(c0 == '%'){
 594:	fd579de3          	bne	a5,s5,56e <vprintf+0x3c>
        state = '%';
 598:	89be                	mv	s3,a5
 59a:	b7cd                	j	57c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 59c:	00ea06b3          	add	a3,s4,a4
 5a0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5a4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5a6:	c681                	beqz	a3,5ae <vprintf+0x7c>
 5a8:	9752                	add	a4,a4,s4
 5aa:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5ae:	03878f63          	beq	a5,s8,5ec <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5b2:	05978963          	beq	a5,s9,604 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5b6:	07500713          	li	a4,117
 5ba:	0ee78363          	beq	a5,a4,6a0 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5be:	07800713          	li	a4,120
 5c2:	12e78563          	beq	a5,a4,6ec <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5c6:	07000713          	li	a4,112
 5ca:	14e78a63          	beq	a5,a4,71e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5ce:	07300713          	li	a4,115
 5d2:	18e78a63          	beq	a5,a4,766 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5d6:	02500713          	li	a4,37
 5da:	04e79563          	bne	a5,a4,624 <vprintf+0xf2>
        putc(fd, '%');
 5de:	02500593          	li	a1,37
 5e2:	855a                	mv	a0,s6
 5e4:	e89ff0ef          	jal	46c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	bf49                	j	57c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5ec:	008b8913          	addi	s2,s7,8
 5f0:	4685                	li	a3,1
 5f2:	4629                	li	a2,10
 5f4:	000ba583          	lw	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	e91ff0ef          	jal	48a <printint>
 5fe:	8bca                	mv	s7,s2
      state = 0;
 600:	4981                	li	s3,0
 602:	bfad                	j	57c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 604:	06400793          	li	a5,100
 608:	02f68963          	beq	a3,a5,63a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 60c:	06c00793          	li	a5,108
 610:	04f68263          	beq	a3,a5,654 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 614:	07500793          	li	a5,117
 618:	0af68063          	beq	a3,a5,6b8 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 61c:	07800793          	li	a5,120
 620:	0ef68263          	beq	a3,a5,704 <vprintf+0x1d2>
        putc(fd, '%');
 624:	02500593          	li	a1,37
 628:	855a                	mv	a0,s6
 62a:	e43ff0ef          	jal	46c <putc>
        putc(fd, c0);
 62e:	85ca                	mv	a1,s2
 630:	855a                	mv	a0,s6
 632:	e3bff0ef          	jal	46c <putc>
      state = 0;
 636:	4981                	li	s3,0
 638:	b791                	j	57c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 63a:	008b8913          	addi	s2,s7,8
 63e:	4685                	li	a3,1
 640:	4629                	li	a2,10
 642:	000ba583          	lw	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	e43ff0ef          	jal	48a <printint>
        i += 1;
 64c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 64e:	8bca                	mv	s7,s2
      state = 0;
 650:	4981                	li	s3,0
        i += 1;
 652:	b72d                	j	57c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 654:	06400793          	li	a5,100
 658:	02f60763          	beq	a2,a5,686 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 65c:	07500793          	li	a5,117
 660:	06f60963          	beq	a2,a5,6d2 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 664:	07800793          	li	a5,120
 668:	faf61ee3          	bne	a2,a5,624 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 66c:	008b8913          	addi	s2,s7,8
 670:	4681                	li	a3,0
 672:	4641                	li	a2,16
 674:	000ba583          	lw	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	e11ff0ef          	jal	48a <printint>
        i += 2;
 67e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 680:	8bca                	mv	s7,s2
      state = 0;
 682:	4981                	li	s3,0
        i += 2;
 684:	bde5                	j	57c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 686:	008b8913          	addi	s2,s7,8
 68a:	4685                	li	a3,1
 68c:	4629                	li	a2,10
 68e:	000ba583          	lw	a1,0(s7)
 692:	855a                	mv	a0,s6
 694:	df7ff0ef          	jal	48a <printint>
        i += 2;
 698:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 69a:	8bca                	mv	s7,s2
      state = 0;
 69c:	4981                	li	s3,0
        i += 2;
 69e:	bdf9                	j	57c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6a0:	008b8913          	addi	s2,s7,8
 6a4:	4681                	li	a3,0
 6a6:	4629                	li	a2,10
 6a8:	000ba583          	lw	a1,0(s7)
 6ac:	855a                	mv	a0,s6
 6ae:	dddff0ef          	jal	48a <printint>
 6b2:	8bca                	mv	s7,s2
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	b5d9                	j	57c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b8:	008b8913          	addi	s2,s7,8
 6bc:	4681                	li	a3,0
 6be:	4629                	li	a2,10
 6c0:	000ba583          	lw	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	dc5ff0ef          	jal	48a <printint>
        i += 1;
 6ca:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6cc:	8bca                	mv	s7,s2
      state = 0;
 6ce:	4981                	li	s3,0
        i += 1;
 6d0:	b575                	j	57c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d2:	008b8913          	addi	s2,s7,8
 6d6:	4681                	li	a3,0
 6d8:	4629                	li	a2,10
 6da:	000ba583          	lw	a1,0(s7)
 6de:	855a                	mv	a0,s6
 6e0:	dabff0ef          	jal	48a <printint>
        i += 2;
 6e4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e6:	8bca                	mv	s7,s2
      state = 0;
 6e8:	4981                	li	s3,0
        i += 2;
 6ea:	bd49                	j	57c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6ec:	008b8913          	addi	s2,s7,8
 6f0:	4681                	li	a3,0
 6f2:	4641                	li	a2,16
 6f4:	000ba583          	lw	a1,0(s7)
 6f8:	855a                	mv	a0,s6
 6fa:	d91ff0ef          	jal	48a <printint>
 6fe:	8bca                	mv	s7,s2
      state = 0;
 700:	4981                	li	s3,0
 702:	bdad                	j	57c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 704:	008b8913          	addi	s2,s7,8
 708:	4681                	li	a3,0
 70a:	4641                	li	a2,16
 70c:	000ba583          	lw	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	d79ff0ef          	jal	48a <printint>
        i += 1;
 716:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 718:	8bca                	mv	s7,s2
      state = 0;
 71a:	4981                	li	s3,0
        i += 1;
 71c:	b585                	j	57c <vprintf+0x4a>
 71e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 720:	008b8d13          	addi	s10,s7,8
 724:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 728:	03000593          	li	a1,48
 72c:	855a                	mv	a0,s6
 72e:	d3fff0ef          	jal	46c <putc>
  putc(fd, 'x');
 732:	07800593          	li	a1,120
 736:	855a                	mv	a0,s6
 738:	d35ff0ef          	jal	46c <putc>
 73c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 73e:	00000b97          	auipc	s7,0x0
 742:	332b8b93          	addi	s7,s7,818 # a70 <digits>
 746:	03c9d793          	srli	a5,s3,0x3c
 74a:	97de                	add	a5,a5,s7
 74c:	0007c583          	lbu	a1,0(a5)
 750:	855a                	mv	a0,s6
 752:	d1bff0ef          	jal	46c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 756:	0992                	slli	s3,s3,0x4
 758:	397d                	addiw	s2,s2,-1
 75a:	fe0916e3          	bnez	s2,746 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 75e:	8bea                	mv	s7,s10
      state = 0;
 760:	4981                	li	s3,0
 762:	6d02                	ld	s10,0(sp)
 764:	bd21                	j	57c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 766:	008b8993          	addi	s3,s7,8
 76a:	000bb903          	ld	s2,0(s7)
 76e:	00090f63          	beqz	s2,78c <vprintf+0x25a>
        for(; *s; s++)
 772:	00094583          	lbu	a1,0(s2)
 776:	c195                	beqz	a1,79a <vprintf+0x268>
          putc(fd, *s);
 778:	855a                	mv	a0,s6
 77a:	cf3ff0ef          	jal	46c <putc>
        for(; *s; s++)
 77e:	0905                	addi	s2,s2,1
 780:	00094583          	lbu	a1,0(s2)
 784:	f9f5                	bnez	a1,778 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 786:	8bce                	mv	s7,s3
      state = 0;
 788:	4981                	li	s3,0
 78a:	bbcd                	j	57c <vprintf+0x4a>
          s = "(null)";
 78c:	00000917          	auipc	s2,0x0
 790:	2dc90913          	addi	s2,s2,732 # a68 <malloc+0x1d0>
        for(; *s; s++)
 794:	02800593          	li	a1,40
 798:	b7c5                	j	778 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 79a:	8bce                	mv	s7,s3
      state = 0;
 79c:	4981                	li	s3,0
 79e:	bbf9                	j	57c <vprintf+0x4a>
 7a0:	64a6                	ld	s1,72(sp)
 7a2:	79e2                	ld	s3,56(sp)
 7a4:	7a42                	ld	s4,48(sp)
 7a6:	7aa2                	ld	s5,40(sp)
 7a8:	7b02                	ld	s6,32(sp)
 7aa:	6be2                	ld	s7,24(sp)
 7ac:	6c42                	ld	s8,16(sp)
 7ae:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7b0:	60e6                	ld	ra,88(sp)
 7b2:	6446                	ld	s0,80(sp)
 7b4:	6906                	ld	s2,64(sp)
 7b6:	6125                	addi	sp,sp,96
 7b8:	8082                	ret

00000000000007ba <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ba:	715d                	addi	sp,sp,-80
 7bc:	ec06                	sd	ra,24(sp)
 7be:	e822                	sd	s0,16(sp)
 7c0:	1000                	addi	s0,sp,32
 7c2:	e010                	sd	a2,0(s0)
 7c4:	e414                	sd	a3,8(s0)
 7c6:	e818                	sd	a4,16(s0)
 7c8:	ec1c                	sd	a5,24(s0)
 7ca:	03043023          	sd	a6,32(s0)
 7ce:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d6:	8622                	mv	a2,s0
 7d8:	d5bff0ef          	jal	532 <vprintf>
}
 7dc:	60e2                	ld	ra,24(sp)
 7de:	6442                	ld	s0,16(sp)
 7e0:	6161                	addi	sp,sp,80
 7e2:	8082                	ret

00000000000007e4 <printf>:

void
printf(const char *fmt, ...)
{
 7e4:	711d                	addi	sp,sp,-96
 7e6:	ec06                	sd	ra,24(sp)
 7e8:	e822                	sd	s0,16(sp)
 7ea:	1000                	addi	s0,sp,32
 7ec:	e40c                	sd	a1,8(s0)
 7ee:	e810                	sd	a2,16(s0)
 7f0:	ec14                	sd	a3,24(s0)
 7f2:	f018                	sd	a4,32(s0)
 7f4:	f41c                	sd	a5,40(s0)
 7f6:	03043823          	sd	a6,48(s0)
 7fa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7fe:	00840613          	addi	a2,s0,8
 802:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 806:	85aa                	mv	a1,a0
 808:	4505                	li	a0,1
 80a:	d29ff0ef          	jal	532 <vprintf>
}
 80e:	60e2                	ld	ra,24(sp)
 810:	6442                	ld	s0,16(sp)
 812:	6125                	addi	sp,sp,96
 814:	8082                	ret

0000000000000816 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 816:	1141                	addi	sp,sp,-16
 818:	e422                	sd	s0,8(sp)
 81a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 81c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 820:	00000797          	auipc	a5,0x0
 824:	7e07b783          	ld	a5,2016(a5) # 1000 <freep>
 828:	a02d                	j	852 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 82a:	4618                	lw	a4,8(a2)
 82c:	9f2d                	addw	a4,a4,a1
 82e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 832:	6398                	ld	a4,0(a5)
 834:	6310                	ld	a2,0(a4)
 836:	a83d                	j	874 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 838:	ff852703          	lw	a4,-8(a0)
 83c:	9f31                	addw	a4,a4,a2
 83e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 840:	ff053683          	ld	a3,-16(a0)
 844:	a091                	j	888 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 846:	6398                	ld	a4,0(a5)
 848:	00e7e463          	bltu	a5,a4,850 <free+0x3a>
 84c:	00e6ea63          	bltu	a3,a4,860 <free+0x4a>
{
 850:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 852:	fed7fae3          	bgeu	a5,a3,846 <free+0x30>
 856:	6398                	ld	a4,0(a5)
 858:	00e6e463          	bltu	a3,a4,860 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85c:	fee7eae3          	bltu	a5,a4,850 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 860:	ff852583          	lw	a1,-8(a0)
 864:	6390                	ld	a2,0(a5)
 866:	02059813          	slli	a6,a1,0x20
 86a:	01c85713          	srli	a4,a6,0x1c
 86e:	9736                	add	a4,a4,a3
 870:	fae60de3          	beq	a2,a4,82a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 874:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 878:	4790                	lw	a2,8(a5)
 87a:	02061593          	slli	a1,a2,0x20
 87e:	01c5d713          	srli	a4,a1,0x1c
 882:	973e                	add	a4,a4,a5
 884:	fae68ae3          	beq	a3,a4,838 <free+0x22>
    p->s.ptr = bp->s.ptr;
 888:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 88a:	00000717          	auipc	a4,0x0
 88e:	76f73b23          	sd	a5,1910(a4) # 1000 <freep>
}
 892:	6422                	ld	s0,8(sp)
 894:	0141                	addi	sp,sp,16
 896:	8082                	ret

0000000000000898 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 898:	7139                	addi	sp,sp,-64
 89a:	fc06                	sd	ra,56(sp)
 89c:	f822                	sd	s0,48(sp)
 89e:	f426                	sd	s1,40(sp)
 8a0:	ec4e                	sd	s3,24(sp)
 8a2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a4:	02051493          	slli	s1,a0,0x20
 8a8:	9081                	srli	s1,s1,0x20
 8aa:	04bd                	addi	s1,s1,15
 8ac:	8091                	srli	s1,s1,0x4
 8ae:	0014899b          	addiw	s3,s1,1
 8b2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8b4:	00000517          	auipc	a0,0x0
 8b8:	74c53503          	ld	a0,1868(a0) # 1000 <freep>
 8bc:	c915                	beqz	a0,8f0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c0:	4798                	lw	a4,8(a5)
 8c2:	08977a63          	bgeu	a4,s1,956 <malloc+0xbe>
 8c6:	f04a                	sd	s2,32(sp)
 8c8:	e852                	sd	s4,16(sp)
 8ca:	e456                	sd	s5,8(sp)
 8cc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8ce:	8a4e                	mv	s4,s3
 8d0:	0009871b          	sext.w	a4,s3
 8d4:	6685                	lui	a3,0x1
 8d6:	00d77363          	bgeu	a4,a3,8dc <malloc+0x44>
 8da:	6a05                	lui	s4,0x1
 8dc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8e4:	00000917          	auipc	s2,0x0
 8e8:	71c90913          	addi	s2,s2,1820 # 1000 <freep>
  if(p == (char*)-1)
 8ec:	5afd                	li	s5,-1
 8ee:	a081                	j	92e <malloc+0x96>
 8f0:	f04a                	sd	s2,32(sp)
 8f2:	e852                	sd	s4,16(sp)
 8f4:	e456                	sd	s5,8(sp)
 8f6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8f8:	00000797          	auipc	a5,0x0
 8fc:	71878793          	addi	a5,a5,1816 # 1010 <base>
 900:	00000717          	auipc	a4,0x0
 904:	70f73023          	sd	a5,1792(a4) # 1000 <freep>
 908:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 90a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 90e:	b7c1                	j	8ce <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 910:	6398                	ld	a4,0(a5)
 912:	e118                	sd	a4,0(a0)
 914:	a8a9                	j	96e <malloc+0xd6>
  hp->s.size = nu;
 916:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 91a:	0541                	addi	a0,a0,16
 91c:	efbff0ef          	jal	816 <free>
  return freep;
 920:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 924:	c12d                	beqz	a0,986 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 926:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 928:	4798                	lw	a4,8(a5)
 92a:	02977263          	bgeu	a4,s1,94e <malloc+0xb6>
    if(p == freep)
 92e:	00093703          	ld	a4,0(s2)
 932:	853e                	mv	a0,a5
 934:	fef719e3          	bne	a4,a5,926 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 938:	8552                	mv	a0,s4
 93a:	ad3ff0ef          	jal	40c <sbrk>
  if(p == (char*)-1)
 93e:	fd551ce3          	bne	a0,s5,916 <malloc+0x7e>
        return 0;
 942:	4501                	li	a0,0
 944:	7902                	ld	s2,32(sp)
 946:	6a42                	ld	s4,16(sp)
 948:	6aa2                	ld	s5,8(sp)
 94a:	6b02                	ld	s6,0(sp)
 94c:	a03d                	j	97a <malloc+0xe2>
 94e:	7902                	ld	s2,32(sp)
 950:	6a42                	ld	s4,16(sp)
 952:	6aa2                	ld	s5,8(sp)
 954:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 956:	fae48de3          	beq	s1,a4,910 <malloc+0x78>
        p->s.size -= nunits;
 95a:	4137073b          	subw	a4,a4,s3
 95e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 960:	02071693          	slli	a3,a4,0x20
 964:	01c6d713          	srli	a4,a3,0x1c
 968:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 96a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 96e:	00000717          	auipc	a4,0x0
 972:	68a73923          	sd	a0,1682(a4) # 1000 <freep>
      return (void*)(p + 1);
 976:	01078513          	addi	a0,a5,16
  }
}
 97a:	70e2                	ld	ra,56(sp)
 97c:	7442                	ld	s0,48(sp)
 97e:	74a2                	ld	s1,40(sp)
 980:	69e2                	ld	s3,24(sp)
 982:	6121                	addi	sp,sp,64
 984:	8082                	ret
 986:	7902                	ld	s2,32(sp)
 988:	6a42                	ld	s4,16(sp)
 98a:	6aa2                	ld	s5,8(sp)
 98c:	6b02                	ld	s6,0(sp)
 98e:	b7f5                	j	97a <malloc+0xe2>
