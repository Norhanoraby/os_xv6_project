
user/_add:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <is_valid_number>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int is_valid_number(char *str) {
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
    int i = 0;
    
    // Check for empty string
    if(str[0] == '\0') {
   6:	00054783          	lbu	a5,0(a0)
   a:	c7a1                	beqz	a5,52 <is_valid_number+0x52>
   c:	872a                	mv	a4,a0
        return 0;
    }
    
    // Allow leading '+' or '-'
    if(str[0] == '+' || str[0] == '-') {
   e:	fd57879b          	addiw	a5,a5,-43
  12:	0fd7f793          	andi	a5,a5,253
  16:	c785                	beqz	a5,3e <is_valid_number+0x3e>
            return 0;
        }
    }
    
    // Check if all remaining characters are digits
    while(str[i] != '\0') {
  18:	00054783          	lbu	a5,0(a0)
  1c:	4681                	li	a3,0
  1e:	0685                	addi	a3,a3,1
  20:	00d70533          	add	a0,a4,a3
        if(str[i] < '0' || str[i] > '9') {
  24:	4725                	li	a4,9
  26:	fd07879b          	addiw	a5,a5,-48
  2a:	0ff7f793          	zext.b	a5,a5
  2e:	02f76663          	bltu	a4,a5,5a <is_valid_number+0x5a>
    while(str[i] != '\0') {
  32:	0505                	addi	a0,a0,1
  34:	fff54783          	lbu	a5,-1(a0)
  38:	f7fd                	bnez	a5,26 <is_valid_number+0x26>
            return 0;  // Found a non-digit character
        }
        i++;
    }
    
    return 1;  // Valid number
  3a:	4505                	li	a0,1
  3c:	a821                	j	54 <is_valid_number+0x54>
        if(str[1] == '\0') {
  3e:	00154783          	lbu	a5,1(a0)
            return 0;
  42:	4501                	li	a0,0
        if(str[1] == '\0') {
  44:	cb81                	beqz	a5,54 <is_valid_number+0x54>
    while(str[i] != '\0') {
  46:	00174783          	lbu	a5,1(a4)
  4a:	4685                	li	a3,1
    return 1;  // Valid number
  4c:	4505                	li	a0,1
    while(str[i] != '\0') {
  4e:	fbe1                	bnez	a5,1e <is_valid_number+0x1e>
  50:	a011                	j	54 <is_valid_number+0x54>
        return 0;
  52:	4501                	li	a0,0
}
  54:	6422                	ld	s0,8(sp)
  56:	0141                	addi	sp,sp,16
  58:	8082                	ret
            return 0;  // Found a non-digit character
  5a:	4501                	li	a0,0
  5c:	bfe5                	j	54 <is_valid_number+0x54>

000000000000005e <my_atoi>:

int my_atoi(char *str) {
  5e:	1141                	addi	sp,sp,-16
  60:	e422                	sd	s0,8(sp)
  62:	0800                	addi	s0,sp,16
    int result = 0;
    int sign = 1;
    int i = 0;
    
    // Handle sign
    if(str[0] == '-') {
  64:	00054783          	lbu	a5,0(a0)
  68:	02d00713          	li	a4,45
  6c:	04e78263          	beq	a5,a4,b0 <my_atoi+0x52>
        sign = -1;
        i = 1;
    } else if(str[0] == '+') {
  70:	fd578793          	addi	a5,a5,-43
  74:	0017b793          	seqz	a5,a5
    int sign = 1;
  78:	4585                	li	a1,1
        i = 1;
    }
    
    // Convert digits
    while(str[i] != '\0') {
  7a:	00f50733          	add	a4,a0,a5
  7e:	00074703          	lbu	a4,0(a4)
  82:	0785                	addi	a5,a5,1
  84:	00f506b3          	add	a3,a0,a5
  88:	4501                	li	a0,0
  8a:	cf11                	beqz	a4,a6 <my_atoi+0x48>
        result = result * 10 + (str[i] - '0');
  8c:	0025179b          	slliw	a5,a0,0x2
  90:	9fa9                	addw	a5,a5,a0
  92:	0017979b          	slliw	a5,a5,0x1
  96:	fd07071b          	addiw	a4,a4,-48
  9a:	00f7053b          	addw	a0,a4,a5
    while(str[i] != '\0') {
  9e:	0685                	addi	a3,a3,1
  a0:	fff6c703          	lbu	a4,-1(a3)
  a4:	f765                	bnez	a4,8c <my_atoi+0x2e>
        i++;
    }
    
    return sign * result;
}
  a6:	02a5853b          	mulw	a0,a1,a0
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret
        i = 1;
  b0:	4785                	li	a5,1
        sign = -1;
  b2:	55fd                	li	a1,-1
  b4:	b7d9                	j	7a <my_atoi+0x1c>

00000000000000b6 <main>:

int
main(int argc, char *argv[])
{
  b6:	7179                	addi	sp,sp,-48
  b8:	f406                	sd	ra,40(sp)
  ba:	f022                	sd	s0,32(sp)
  bc:	ec26                	sd	s1,24(sp)
  be:	1800                	addi	s0,sp,48
  c0:	84ae                	mv	s1,a1
    if(argc == 2 && strcmp(argv[1], "?") == 0) {
  c2:	4789                	li	a5,2
  c4:	02f50c63          	beq	a0,a5,fc <main+0x46>
        printf("Usage: add number1 number2\n");
        exit(0);
    }
    
    if(argc != 3) {
  c8:	478d                	li	a5,3
  ca:	04f51163          	bne	a0,a5,10c <main+0x56>
  ce:	e84a                	sd	s2,16(sp)
  d0:	e44e                	sd	s3,8(sp)
        printf("You can only add two numbers\n");
        exit(0);
    }
    
    // Validate first argument
    if(!is_valid_number(argv[1])) {
  d2:	0085b903          	ld	s2,8(a1)
  d6:	854a                	mv	a0,s2
  d8:	f29ff0ef          	jal	0 <is_valid_number>
  dc:	cd31                	beqz	a0,138 <main+0x82>
        printf("needs numbers\n");
        exit(0);
    }
    
    // Validate second argument
    if(!is_valid_number(argv[2])) {
  de:	0104b983          	ld	s3,16(s1)
  e2:	854e                	mv	a0,s3
  e4:	f1dff0ef          	jal	0 <is_valid_number>
  e8:	e12d                	bnez	a0,14a <main+0x94>
        printf("needs numbers\n");
  ea:	00001517          	auipc	a0,0x1
  ee:	94e50513          	addi	a0,a0,-1714 # a38 <malloc+0x148>
  f2:	74a000ef          	jal	83c <printf>
        exit(0);
  f6:	4501                	li	a0,0
  f8:	2e4000ef          	jal	3dc <exit>
    if(argc == 2 && strcmp(argv[1], "?") == 0) {
  fc:	00001597          	auipc	a1,0x1
 100:	8f458593          	addi	a1,a1,-1804 # 9f0 <malloc+0x100>
 104:	6488                	ld	a0,8(s1)
 106:	09a000ef          	jal	1a0 <strcmp>
 10a:	cd01                	beqz	a0,122 <main+0x6c>
 10c:	e84a                	sd	s2,16(sp)
 10e:	e44e                	sd	s3,8(sp)
        printf("You can only add two numbers\n");
 110:	00001517          	auipc	a0,0x1
 114:	90850513          	addi	a0,a0,-1784 # a18 <malloc+0x128>
 118:	724000ef          	jal	83c <printf>
        exit(0);
 11c:	4501                	li	a0,0
 11e:	2be000ef          	jal	3dc <exit>
 122:	e84a                	sd	s2,16(sp)
 124:	e44e                	sd	s3,8(sp)
        printf("Usage: add number1 number2\n");
 126:	00001517          	auipc	a0,0x1
 12a:	8d250513          	addi	a0,a0,-1838 # 9f8 <malloc+0x108>
 12e:	70e000ef          	jal	83c <printf>
        exit(0);
 132:	4501                	li	a0,0
 134:	2a8000ef          	jal	3dc <exit>
        printf("needs numbers\n");
 138:	00001517          	auipc	a0,0x1
 13c:	90050513          	addi	a0,a0,-1792 # a38 <malloc+0x148>
 140:	6fc000ef          	jal	83c <printf>
        exit(0);
 144:	4501                	li	a0,0
 146:	296000ef          	jal	3dc <exit>
    }
    
    int num1 = my_atoi(argv[1]);
 14a:	854a                	mv	a0,s2
 14c:	f13ff0ef          	jal	5e <my_atoi>
 150:	84aa                	mv	s1,a0
    int num2 = my_atoi(argv[2]);
 152:	854e                	mv	a0,s3
 154:	f0bff0ef          	jal	5e <my_atoi>
 158:	862a                	mv	a2,a0
    int total = num1 + num2;
    
    printf("The sum of %d and %d is %d\n", num1, num2, total);
 15a:	00a486bb          	addw	a3,s1,a0
 15e:	85a6                	mv	a1,s1
 160:	00001517          	auipc	a0,0x1
 164:	8e850513          	addi	a0,a0,-1816 # a48 <malloc+0x158>
 168:	6d4000ef          	jal	83c <printf>
    exit(0);
 16c:	4501                	li	a0,0
 16e:	26e000ef          	jal	3dc <exit>

0000000000000172 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 172:	1141                	addi	sp,sp,-16
 174:	e406                	sd	ra,8(sp)
 176:	e022                	sd	s0,0(sp)
 178:	0800                	addi	s0,sp,16
  extern int main();
  main();
 17a:	f3dff0ef          	jal	b6 <main>
  exit(0);
 17e:	4501                	li	a0,0
 180:	25c000ef          	jal	3dc <exit>

0000000000000184 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 18a:	87aa                	mv	a5,a0
 18c:	0585                	addi	a1,a1,1
 18e:	0785                	addi	a5,a5,1
 190:	fff5c703          	lbu	a4,-1(a1)
 194:	fee78fa3          	sb	a4,-1(a5)
 198:	fb75                	bnez	a4,18c <strcpy+0x8>
    ;
  return os;
}
 19a:	6422                	ld	s0,8(sp)
 19c:	0141                	addi	sp,sp,16
 19e:	8082                	ret

00000000000001a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e422                	sd	s0,8(sp)
 1a4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1a6:	00054783          	lbu	a5,0(a0)
 1aa:	cb91                	beqz	a5,1be <strcmp+0x1e>
 1ac:	0005c703          	lbu	a4,0(a1)
 1b0:	00f71763          	bne	a4,a5,1be <strcmp+0x1e>
    p++, q++;
 1b4:	0505                	addi	a0,a0,1
 1b6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	fbe5                	bnez	a5,1ac <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1be:	0005c503          	lbu	a0,0(a1)
}
 1c2:	40a7853b          	subw	a0,a5,a0
 1c6:	6422                	ld	s0,8(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret

00000000000001cc <strlen>:

uint
strlen(const char *s)
{
 1cc:	1141                	addi	sp,sp,-16
 1ce:	e422                	sd	s0,8(sp)
 1d0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1d2:	00054783          	lbu	a5,0(a0)
 1d6:	cf91                	beqz	a5,1f2 <strlen+0x26>
 1d8:	0505                	addi	a0,a0,1
 1da:	87aa                	mv	a5,a0
 1dc:	86be                	mv	a3,a5
 1de:	0785                	addi	a5,a5,1
 1e0:	fff7c703          	lbu	a4,-1(a5)
 1e4:	ff65                	bnez	a4,1dc <strlen+0x10>
 1e6:	40a6853b          	subw	a0,a3,a0
 1ea:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1ec:	6422                	ld	s0,8(sp)
 1ee:	0141                	addi	sp,sp,16
 1f0:	8082                	ret
  for(n = 0; s[n]; n++)
 1f2:	4501                	li	a0,0
 1f4:	bfe5                	j	1ec <strlen+0x20>

00000000000001f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e422                	sd	s0,8(sp)
 1fa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1fc:	ca19                	beqz	a2,212 <memset+0x1c>
 1fe:	87aa                	mv	a5,a0
 200:	1602                	slli	a2,a2,0x20
 202:	9201                	srli	a2,a2,0x20
 204:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 208:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 20c:	0785                	addi	a5,a5,1
 20e:	fee79de3          	bne	a5,a4,208 <memset+0x12>
  }
  return dst;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret

0000000000000218 <strchr>:

char*
strchr(const char *s, char c)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 21e:	00054783          	lbu	a5,0(a0)
 222:	cb99                	beqz	a5,238 <strchr+0x20>
    if(*s == c)
 224:	00f58763          	beq	a1,a5,232 <strchr+0x1a>
  for(; *s; s++)
 228:	0505                	addi	a0,a0,1
 22a:	00054783          	lbu	a5,0(a0)
 22e:	fbfd                	bnez	a5,224 <strchr+0xc>
      return (char*)s;
  return 0;
 230:	4501                	li	a0,0
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret
  return 0;
 238:	4501                	li	a0,0
 23a:	bfe5                	j	232 <strchr+0x1a>

000000000000023c <gets>:

char*
gets(char *buf, int max)
{
 23c:	711d                	addi	sp,sp,-96
 23e:	ec86                	sd	ra,88(sp)
 240:	e8a2                	sd	s0,80(sp)
 242:	e4a6                	sd	s1,72(sp)
 244:	e0ca                	sd	s2,64(sp)
 246:	fc4e                	sd	s3,56(sp)
 248:	f852                	sd	s4,48(sp)
 24a:	f456                	sd	s5,40(sp)
 24c:	f05a                	sd	s6,32(sp)
 24e:	ec5e                	sd	s7,24(sp)
 250:	1080                	addi	s0,sp,96
 252:	8baa                	mv	s7,a0
 254:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 256:	892a                	mv	s2,a0
 258:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 25a:	4aa9                	li	s5,10
 25c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 25e:	89a6                	mv	s3,s1
 260:	2485                	addiw	s1,s1,1
 262:	0344d663          	bge	s1,s4,28e <gets+0x52>
    cc = read(0, &c, 1);
 266:	4605                	li	a2,1
 268:	faf40593          	addi	a1,s0,-81
 26c:	4501                	li	a0,0
 26e:	186000ef          	jal	3f4 <read>
    if(cc < 1)
 272:	00a05e63          	blez	a0,28e <gets+0x52>
    buf[i++] = c;
 276:	faf44783          	lbu	a5,-81(s0)
 27a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 27e:	01578763          	beq	a5,s5,28c <gets+0x50>
 282:	0905                	addi	s2,s2,1
 284:	fd679de3          	bne	a5,s6,25e <gets+0x22>
    buf[i++] = c;
 288:	89a6                	mv	s3,s1
 28a:	a011                	j	28e <gets+0x52>
 28c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 28e:	99de                	add	s3,s3,s7
 290:	00098023          	sb	zero,0(s3)
  return buf;
}
 294:	855e                	mv	a0,s7
 296:	60e6                	ld	ra,88(sp)
 298:	6446                	ld	s0,80(sp)
 29a:	64a6                	ld	s1,72(sp)
 29c:	6906                	ld	s2,64(sp)
 29e:	79e2                	ld	s3,56(sp)
 2a0:	7a42                	ld	s4,48(sp)
 2a2:	7aa2                	ld	s5,40(sp)
 2a4:	7b02                	ld	s6,32(sp)
 2a6:	6be2                	ld	s7,24(sp)
 2a8:	6125                	addi	sp,sp,96
 2aa:	8082                	ret

00000000000002ac <stat>:

int
stat(const char *n, struct stat *st)
{
 2ac:	1101                	addi	sp,sp,-32
 2ae:	ec06                	sd	ra,24(sp)
 2b0:	e822                	sd	s0,16(sp)
 2b2:	e04a                	sd	s2,0(sp)
 2b4:	1000                	addi	s0,sp,32
 2b6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b8:	4581                	li	a1,0
 2ba:	162000ef          	jal	41c <open>
  if(fd < 0)
 2be:	02054263          	bltz	a0,2e2 <stat+0x36>
 2c2:	e426                	sd	s1,8(sp)
 2c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2c6:	85ca                	mv	a1,s2
 2c8:	16c000ef          	jal	434 <fstat>
 2cc:	892a                	mv	s2,a0
  close(fd);
 2ce:	8526                	mv	a0,s1
 2d0:	134000ef          	jal	404 <close>
  return r;
 2d4:	64a2                	ld	s1,8(sp)
}
 2d6:	854a                	mv	a0,s2
 2d8:	60e2                	ld	ra,24(sp)
 2da:	6442                	ld	s0,16(sp)
 2dc:	6902                	ld	s2,0(sp)
 2de:	6105                	addi	sp,sp,32
 2e0:	8082                	ret
    return -1;
 2e2:	597d                	li	s2,-1
 2e4:	bfcd                	j	2d6 <stat+0x2a>

00000000000002e6 <atoi>:

int
atoi(const char *s)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e422                	sd	s0,8(sp)
 2ea:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ec:	00054683          	lbu	a3,0(a0)
 2f0:	fd06879b          	addiw	a5,a3,-48
 2f4:	0ff7f793          	zext.b	a5,a5
 2f8:	4625                	li	a2,9
 2fa:	02f66863          	bltu	a2,a5,32a <atoi+0x44>
 2fe:	872a                	mv	a4,a0
  n = 0;
 300:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 302:	0705                	addi	a4,a4,1
 304:	0025179b          	slliw	a5,a0,0x2
 308:	9fa9                	addw	a5,a5,a0
 30a:	0017979b          	slliw	a5,a5,0x1
 30e:	9fb5                	addw	a5,a5,a3
 310:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 314:	00074683          	lbu	a3,0(a4)
 318:	fd06879b          	addiw	a5,a3,-48
 31c:	0ff7f793          	zext.b	a5,a5
 320:	fef671e3          	bgeu	a2,a5,302 <atoi+0x1c>
  return n;
}
 324:	6422                	ld	s0,8(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret
  n = 0;
 32a:	4501                	li	a0,0
 32c:	bfe5                	j	324 <atoi+0x3e>

000000000000032e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 32e:	1141                	addi	sp,sp,-16
 330:	e422                	sd	s0,8(sp)
 332:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 334:	02b57463          	bgeu	a0,a1,35c <memmove+0x2e>
    while(n-- > 0)
 338:	00c05f63          	blez	a2,356 <memmove+0x28>
 33c:	1602                	slli	a2,a2,0x20
 33e:	9201                	srli	a2,a2,0x20
 340:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 344:	872a                	mv	a4,a0
      *dst++ = *src++;
 346:	0585                	addi	a1,a1,1
 348:	0705                	addi	a4,a4,1
 34a:	fff5c683          	lbu	a3,-1(a1)
 34e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 352:	fef71ae3          	bne	a4,a5,346 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 356:	6422                	ld	s0,8(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret
    dst += n;
 35c:	00c50733          	add	a4,a0,a2
    src += n;
 360:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 362:	fec05ae3          	blez	a2,356 <memmove+0x28>
 366:	fff6079b          	addiw	a5,a2,-1
 36a:	1782                	slli	a5,a5,0x20
 36c:	9381                	srli	a5,a5,0x20
 36e:	fff7c793          	not	a5,a5
 372:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 374:	15fd                	addi	a1,a1,-1
 376:	177d                	addi	a4,a4,-1
 378:	0005c683          	lbu	a3,0(a1)
 37c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 380:	fee79ae3          	bne	a5,a4,374 <memmove+0x46>
 384:	bfc9                	j	356 <memmove+0x28>

0000000000000386 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 386:	1141                	addi	sp,sp,-16
 388:	e422                	sd	s0,8(sp)
 38a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 38c:	ca05                	beqz	a2,3bc <memcmp+0x36>
 38e:	fff6069b          	addiw	a3,a2,-1
 392:	1682                	slli	a3,a3,0x20
 394:	9281                	srli	a3,a3,0x20
 396:	0685                	addi	a3,a3,1
 398:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 39a:	00054783          	lbu	a5,0(a0)
 39e:	0005c703          	lbu	a4,0(a1)
 3a2:	00e79863          	bne	a5,a4,3b2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3a6:	0505                	addi	a0,a0,1
    p2++;
 3a8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3aa:	fed518e3          	bne	a0,a3,39a <memcmp+0x14>
  }
  return 0;
 3ae:	4501                	li	a0,0
 3b0:	a019                	j	3b6 <memcmp+0x30>
      return *p1 - *p2;
 3b2:	40e7853b          	subw	a0,a5,a4
}
 3b6:	6422                	ld	s0,8(sp)
 3b8:	0141                	addi	sp,sp,16
 3ba:	8082                	ret
  return 0;
 3bc:	4501                	li	a0,0
 3be:	bfe5                	j	3b6 <memcmp+0x30>

00000000000003c0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3c0:	1141                	addi	sp,sp,-16
 3c2:	e406                	sd	ra,8(sp)
 3c4:	e022                	sd	s0,0(sp)
 3c6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3c8:	f67ff0ef          	jal	32e <memmove>
}
 3cc:	60a2                	ld	ra,8(sp)
 3ce:	6402                	ld	s0,0(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret

00000000000003d4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3d4:	4885                	li	a7,1
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <exit>:
.global exit
exit:
 li a7, SYS_exit
 3dc:	4889                	li	a7,2
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3e4:	488d                	li	a7,3
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ec:	4891                	li	a7,4
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <read>:
.global read
read:
 li a7, SYS_read
 3f4:	4895                	li	a7,5
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <write>:
.global write
write:
 li a7, SYS_write
 3fc:	48c1                	li	a7,16
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <close>:
.global close
close:
 li a7, SYS_close
 404:	48d5                	li	a7,21
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <kill>:
.global kill
kill:
 li a7, SYS_kill
 40c:	4899                	li	a7,6
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <exec>:
.global exec
exec:
 li a7, SYS_exec
 414:	489d                	li	a7,7
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <open>:
.global open
open:
 li a7, SYS_open
 41c:	48bd                	li	a7,15
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 424:	48c5                	li	a7,17
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 42c:	48c9                	li	a7,18
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 434:	48a1                	li	a7,8
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <link>:
.global link
link:
 li a7, SYS_link
 43c:	48cd                	li	a7,19
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 444:	48d1                	li	a7,20
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 44c:	48a5                	li	a7,9
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <dup>:
.global dup
dup:
 li a7, SYS_dup
 454:	48a9                	li	a7,10
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 45c:	48ad                	li	a7,11
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 464:	48b1                	li	a7,12
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 46c:	48b5                	li	a7,13
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 474:	48b9                	li	a7,14
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 47c:	48d9                	li	a7,22
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 484:	48dd                	li	a7,23
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 48c:	48e1                	li	a7,24
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 494:	48e5                	li	a7,25
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <random>:
.global random
random:
 li a7, SYS_random
 49c:	48e9                	li	a7,26
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 4a4:	48ed                	li	a7,27
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 4ac:	48f1                	li	a7,28
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <set_sched>:
.global set_sched
set_sched:
 li a7, SYS_set_sched
 4b4:	48f5                	li	a7,29
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <wait_sched>:
.global wait_sched
wait_sched:
 li a7, SYS_wait_sched
 4bc:	48f9                	li	a7,30
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4c4:	1101                	addi	sp,sp,-32
 4c6:	ec06                	sd	ra,24(sp)
 4c8:	e822                	sd	s0,16(sp)
 4ca:	1000                	addi	s0,sp,32
 4cc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4d0:	4605                	li	a2,1
 4d2:	fef40593          	addi	a1,s0,-17
 4d6:	f27ff0ef          	jal	3fc <write>
}
 4da:	60e2                	ld	ra,24(sp)
 4dc:	6442                	ld	s0,16(sp)
 4de:	6105                	addi	sp,sp,32
 4e0:	8082                	ret

00000000000004e2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4e2:	7139                	addi	sp,sp,-64
 4e4:	fc06                	sd	ra,56(sp)
 4e6:	f822                	sd	s0,48(sp)
 4e8:	f426                	sd	s1,40(sp)
 4ea:	0080                	addi	s0,sp,64
 4ec:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ee:	c299                	beqz	a3,4f4 <printint+0x12>
 4f0:	0805c963          	bltz	a1,582 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4f4:	2581                	sext.w	a1,a1
  neg = 0;
 4f6:	4881                	li	a7,0
 4f8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4fc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4fe:	2601                	sext.w	a2,a2
 500:	00000517          	auipc	a0,0x0
 504:	57050513          	addi	a0,a0,1392 # a70 <digits>
 508:	883a                	mv	a6,a4
 50a:	2705                	addiw	a4,a4,1
 50c:	02c5f7bb          	remuw	a5,a1,a2
 510:	1782                	slli	a5,a5,0x20
 512:	9381                	srli	a5,a5,0x20
 514:	97aa                	add	a5,a5,a0
 516:	0007c783          	lbu	a5,0(a5)
 51a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 51e:	0005879b          	sext.w	a5,a1
 522:	02c5d5bb          	divuw	a1,a1,a2
 526:	0685                	addi	a3,a3,1
 528:	fec7f0e3          	bgeu	a5,a2,508 <printint+0x26>
  if(neg)
 52c:	00088c63          	beqz	a7,544 <printint+0x62>
    buf[i++] = '-';
 530:	fd070793          	addi	a5,a4,-48
 534:	00878733          	add	a4,a5,s0
 538:	02d00793          	li	a5,45
 53c:	fef70823          	sb	a5,-16(a4)
 540:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 544:	02e05a63          	blez	a4,578 <printint+0x96>
 548:	f04a                	sd	s2,32(sp)
 54a:	ec4e                	sd	s3,24(sp)
 54c:	fc040793          	addi	a5,s0,-64
 550:	00e78933          	add	s2,a5,a4
 554:	fff78993          	addi	s3,a5,-1
 558:	99ba                	add	s3,s3,a4
 55a:	377d                	addiw	a4,a4,-1
 55c:	1702                	slli	a4,a4,0x20
 55e:	9301                	srli	a4,a4,0x20
 560:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 564:	fff94583          	lbu	a1,-1(s2)
 568:	8526                	mv	a0,s1
 56a:	f5bff0ef          	jal	4c4 <putc>
  while(--i >= 0)
 56e:	197d                	addi	s2,s2,-1
 570:	ff391ae3          	bne	s2,s3,564 <printint+0x82>
 574:	7902                	ld	s2,32(sp)
 576:	69e2                	ld	s3,24(sp)
}
 578:	70e2                	ld	ra,56(sp)
 57a:	7442                	ld	s0,48(sp)
 57c:	74a2                	ld	s1,40(sp)
 57e:	6121                	addi	sp,sp,64
 580:	8082                	ret
    x = -xx;
 582:	40b005bb          	negw	a1,a1
    neg = 1;
 586:	4885                	li	a7,1
    x = -xx;
 588:	bf85                	j	4f8 <printint+0x16>

000000000000058a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 58a:	711d                	addi	sp,sp,-96
 58c:	ec86                	sd	ra,88(sp)
 58e:	e8a2                	sd	s0,80(sp)
 590:	e0ca                	sd	s2,64(sp)
 592:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 594:	0005c903          	lbu	s2,0(a1)
 598:	26090863          	beqz	s2,808 <vprintf+0x27e>
 59c:	e4a6                	sd	s1,72(sp)
 59e:	fc4e                	sd	s3,56(sp)
 5a0:	f852                	sd	s4,48(sp)
 5a2:	f456                	sd	s5,40(sp)
 5a4:	f05a                	sd	s6,32(sp)
 5a6:	ec5e                	sd	s7,24(sp)
 5a8:	e862                	sd	s8,16(sp)
 5aa:	e466                	sd	s9,8(sp)
 5ac:	8b2a                	mv	s6,a0
 5ae:	8a2e                	mv	s4,a1
 5b0:	8bb2                	mv	s7,a2
  state = 0;
 5b2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5b4:	4481                	li	s1,0
 5b6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5b8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5bc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5c0:	06c00c93          	li	s9,108
 5c4:	a005                	j	5e4 <vprintf+0x5a>
        putc(fd, c0);
 5c6:	85ca                	mv	a1,s2
 5c8:	855a                	mv	a0,s6
 5ca:	efbff0ef          	jal	4c4 <putc>
 5ce:	a019                	j	5d4 <vprintf+0x4a>
    } else if(state == '%'){
 5d0:	03598263          	beq	s3,s5,5f4 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5d4:	2485                	addiw	s1,s1,1
 5d6:	8726                	mv	a4,s1
 5d8:	009a07b3          	add	a5,s4,s1
 5dc:	0007c903          	lbu	s2,0(a5)
 5e0:	20090c63          	beqz	s2,7f8 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 5e4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5e8:	fe0994e3          	bnez	s3,5d0 <vprintf+0x46>
      if(c0 == '%'){
 5ec:	fd579de3          	bne	a5,s5,5c6 <vprintf+0x3c>
        state = '%';
 5f0:	89be                	mv	s3,a5
 5f2:	b7cd                	j	5d4 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5f4:	00ea06b3          	add	a3,s4,a4
 5f8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5fc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5fe:	c681                	beqz	a3,606 <vprintf+0x7c>
 600:	9752                	add	a4,a4,s4
 602:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 606:	03878f63          	beq	a5,s8,644 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 60a:	05978963          	beq	a5,s9,65c <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 60e:	07500713          	li	a4,117
 612:	0ee78363          	beq	a5,a4,6f8 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 616:	07800713          	li	a4,120
 61a:	12e78563          	beq	a5,a4,744 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 61e:	07000713          	li	a4,112
 622:	14e78a63          	beq	a5,a4,776 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 626:	07300713          	li	a4,115
 62a:	18e78a63          	beq	a5,a4,7be <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 62e:	02500713          	li	a4,37
 632:	04e79563          	bne	a5,a4,67c <vprintf+0xf2>
        putc(fd, '%');
 636:	02500593          	li	a1,37
 63a:	855a                	mv	a0,s6
 63c:	e89ff0ef          	jal	4c4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 640:	4981                	li	s3,0
 642:	bf49                	j	5d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 644:	008b8913          	addi	s2,s7,8
 648:	4685                	li	a3,1
 64a:	4629                	li	a2,10
 64c:	000ba583          	lw	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	e91ff0ef          	jal	4e2 <printint>
 656:	8bca                	mv	s7,s2
      state = 0;
 658:	4981                	li	s3,0
 65a:	bfad                	j	5d4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 65c:	06400793          	li	a5,100
 660:	02f68963          	beq	a3,a5,692 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 664:	06c00793          	li	a5,108
 668:	04f68263          	beq	a3,a5,6ac <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 66c:	07500793          	li	a5,117
 670:	0af68063          	beq	a3,a5,710 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 674:	07800793          	li	a5,120
 678:	0ef68263          	beq	a3,a5,75c <vprintf+0x1d2>
        putc(fd, '%');
 67c:	02500593          	li	a1,37
 680:	855a                	mv	a0,s6
 682:	e43ff0ef          	jal	4c4 <putc>
        putc(fd, c0);
 686:	85ca                	mv	a1,s2
 688:	855a                	mv	a0,s6
 68a:	e3bff0ef          	jal	4c4 <putc>
      state = 0;
 68e:	4981                	li	s3,0
 690:	b791                	j	5d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 692:	008b8913          	addi	s2,s7,8
 696:	4685                	li	a3,1
 698:	4629                	li	a2,10
 69a:	000ba583          	lw	a1,0(s7)
 69e:	855a                	mv	a0,s6
 6a0:	e43ff0ef          	jal	4e2 <printint>
        i += 1;
 6a4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a6:	8bca                	mv	s7,s2
      state = 0;
 6a8:	4981                	li	s3,0
        i += 1;
 6aa:	b72d                	j	5d4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6ac:	06400793          	li	a5,100
 6b0:	02f60763          	beq	a2,a5,6de <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6b4:	07500793          	li	a5,117
 6b8:	06f60963          	beq	a2,a5,72a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6bc:	07800793          	li	a5,120
 6c0:	faf61ee3          	bne	a2,a5,67c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c4:	008b8913          	addi	s2,s7,8
 6c8:	4681                	li	a3,0
 6ca:	4641                	li	a2,16
 6cc:	000ba583          	lw	a1,0(s7)
 6d0:	855a                	mv	a0,s6
 6d2:	e11ff0ef          	jal	4e2 <printint>
        i += 2;
 6d6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d8:	8bca                	mv	s7,s2
      state = 0;
 6da:	4981                	li	s3,0
        i += 2;
 6dc:	bde5                	j	5d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6de:	008b8913          	addi	s2,s7,8
 6e2:	4685                	li	a3,1
 6e4:	4629                	li	a2,10
 6e6:	000ba583          	lw	a1,0(s7)
 6ea:	855a                	mv	a0,s6
 6ec:	df7ff0ef          	jal	4e2 <printint>
        i += 2;
 6f0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f2:	8bca                	mv	s7,s2
      state = 0;
 6f4:	4981                	li	s3,0
        i += 2;
 6f6:	bdf9                	j	5d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6f8:	008b8913          	addi	s2,s7,8
 6fc:	4681                	li	a3,0
 6fe:	4629                	li	a2,10
 700:	000ba583          	lw	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	dddff0ef          	jal	4e2 <printint>
 70a:	8bca                	mv	s7,s2
      state = 0;
 70c:	4981                	li	s3,0
 70e:	b5d9                	j	5d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 710:	008b8913          	addi	s2,s7,8
 714:	4681                	li	a3,0
 716:	4629                	li	a2,10
 718:	000ba583          	lw	a1,0(s7)
 71c:	855a                	mv	a0,s6
 71e:	dc5ff0ef          	jal	4e2 <printint>
        i += 1;
 722:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 724:	8bca                	mv	s7,s2
      state = 0;
 726:	4981                	li	s3,0
        i += 1;
 728:	b575                	j	5d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 72a:	008b8913          	addi	s2,s7,8
 72e:	4681                	li	a3,0
 730:	4629                	li	a2,10
 732:	000ba583          	lw	a1,0(s7)
 736:	855a                	mv	a0,s6
 738:	dabff0ef          	jal	4e2 <printint>
        i += 2;
 73c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 73e:	8bca                	mv	s7,s2
      state = 0;
 740:	4981                	li	s3,0
        i += 2;
 742:	bd49                	j	5d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 744:	008b8913          	addi	s2,s7,8
 748:	4681                	li	a3,0
 74a:	4641                	li	a2,16
 74c:	000ba583          	lw	a1,0(s7)
 750:	855a                	mv	a0,s6
 752:	d91ff0ef          	jal	4e2 <printint>
 756:	8bca                	mv	s7,s2
      state = 0;
 758:	4981                	li	s3,0
 75a:	bdad                	j	5d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 75c:	008b8913          	addi	s2,s7,8
 760:	4681                	li	a3,0
 762:	4641                	li	a2,16
 764:	000ba583          	lw	a1,0(s7)
 768:	855a                	mv	a0,s6
 76a:	d79ff0ef          	jal	4e2 <printint>
        i += 1;
 76e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 770:	8bca                	mv	s7,s2
      state = 0;
 772:	4981                	li	s3,0
        i += 1;
 774:	b585                	j	5d4 <vprintf+0x4a>
 776:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 778:	008b8d13          	addi	s10,s7,8
 77c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 780:	03000593          	li	a1,48
 784:	855a                	mv	a0,s6
 786:	d3fff0ef          	jal	4c4 <putc>
  putc(fd, 'x');
 78a:	07800593          	li	a1,120
 78e:	855a                	mv	a0,s6
 790:	d35ff0ef          	jal	4c4 <putc>
 794:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 796:	00000b97          	auipc	s7,0x0
 79a:	2dab8b93          	addi	s7,s7,730 # a70 <digits>
 79e:	03c9d793          	srli	a5,s3,0x3c
 7a2:	97de                	add	a5,a5,s7
 7a4:	0007c583          	lbu	a1,0(a5)
 7a8:	855a                	mv	a0,s6
 7aa:	d1bff0ef          	jal	4c4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7ae:	0992                	slli	s3,s3,0x4
 7b0:	397d                	addiw	s2,s2,-1
 7b2:	fe0916e3          	bnez	s2,79e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7b6:	8bea                	mv	s7,s10
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	6d02                	ld	s10,0(sp)
 7bc:	bd21                	j	5d4 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7be:	008b8993          	addi	s3,s7,8
 7c2:	000bb903          	ld	s2,0(s7)
 7c6:	00090f63          	beqz	s2,7e4 <vprintf+0x25a>
        for(; *s; s++)
 7ca:	00094583          	lbu	a1,0(s2)
 7ce:	c195                	beqz	a1,7f2 <vprintf+0x268>
          putc(fd, *s);
 7d0:	855a                	mv	a0,s6
 7d2:	cf3ff0ef          	jal	4c4 <putc>
        for(; *s; s++)
 7d6:	0905                	addi	s2,s2,1
 7d8:	00094583          	lbu	a1,0(s2)
 7dc:	f9f5                	bnez	a1,7d0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7de:	8bce                	mv	s7,s3
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	bbcd                	j	5d4 <vprintf+0x4a>
          s = "(null)";
 7e4:	00000917          	auipc	s2,0x0
 7e8:	28490913          	addi	s2,s2,644 # a68 <malloc+0x178>
        for(; *s; s++)
 7ec:	02800593          	li	a1,40
 7f0:	b7c5                	j	7d0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7f2:	8bce                	mv	s7,s3
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	bbf9                	j	5d4 <vprintf+0x4a>
 7f8:	64a6                	ld	s1,72(sp)
 7fa:	79e2                	ld	s3,56(sp)
 7fc:	7a42                	ld	s4,48(sp)
 7fe:	7aa2                	ld	s5,40(sp)
 800:	7b02                	ld	s6,32(sp)
 802:	6be2                	ld	s7,24(sp)
 804:	6c42                	ld	s8,16(sp)
 806:	6ca2                	ld	s9,8(sp)
    }
  }
}
 808:	60e6                	ld	ra,88(sp)
 80a:	6446                	ld	s0,80(sp)
 80c:	6906                	ld	s2,64(sp)
 80e:	6125                	addi	sp,sp,96
 810:	8082                	ret

0000000000000812 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 812:	715d                	addi	sp,sp,-80
 814:	ec06                	sd	ra,24(sp)
 816:	e822                	sd	s0,16(sp)
 818:	1000                	addi	s0,sp,32
 81a:	e010                	sd	a2,0(s0)
 81c:	e414                	sd	a3,8(s0)
 81e:	e818                	sd	a4,16(s0)
 820:	ec1c                	sd	a5,24(s0)
 822:	03043023          	sd	a6,32(s0)
 826:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 82a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 82e:	8622                	mv	a2,s0
 830:	d5bff0ef          	jal	58a <vprintf>
}
 834:	60e2                	ld	ra,24(sp)
 836:	6442                	ld	s0,16(sp)
 838:	6161                	addi	sp,sp,80
 83a:	8082                	ret

000000000000083c <printf>:

void
printf(const char *fmt, ...)
{
 83c:	711d                	addi	sp,sp,-96
 83e:	ec06                	sd	ra,24(sp)
 840:	e822                	sd	s0,16(sp)
 842:	1000                	addi	s0,sp,32
 844:	e40c                	sd	a1,8(s0)
 846:	e810                	sd	a2,16(s0)
 848:	ec14                	sd	a3,24(s0)
 84a:	f018                	sd	a4,32(s0)
 84c:	f41c                	sd	a5,40(s0)
 84e:	03043823          	sd	a6,48(s0)
 852:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 856:	00840613          	addi	a2,s0,8
 85a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 85e:	85aa                	mv	a1,a0
 860:	4505                	li	a0,1
 862:	d29ff0ef          	jal	58a <vprintf>
}
 866:	60e2                	ld	ra,24(sp)
 868:	6442                	ld	s0,16(sp)
 86a:	6125                	addi	sp,sp,96
 86c:	8082                	ret

000000000000086e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 86e:	1141                	addi	sp,sp,-16
 870:	e422                	sd	s0,8(sp)
 872:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 874:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 878:	00000797          	auipc	a5,0x0
 87c:	7887b783          	ld	a5,1928(a5) # 1000 <freep>
 880:	a02d                	j	8aa <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 882:	4618                	lw	a4,8(a2)
 884:	9f2d                	addw	a4,a4,a1
 886:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 88a:	6398                	ld	a4,0(a5)
 88c:	6310                	ld	a2,0(a4)
 88e:	a83d                	j	8cc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 890:	ff852703          	lw	a4,-8(a0)
 894:	9f31                	addw	a4,a4,a2
 896:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 898:	ff053683          	ld	a3,-16(a0)
 89c:	a091                	j	8e0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89e:	6398                	ld	a4,0(a5)
 8a0:	00e7e463          	bltu	a5,a4,8a8 <free+0x3a>
 8a4:	00e6ea63          	bltu	a3,a4,8b8 <free+0x4a>
{
 8a8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8aa:	fed7fae3          	bgeu	a5,a3,89e <free+0x30>
 8ae:	6398                	ld	a4,0(a5)
 8b0:	00e6e463          	bltu	a3,a4,8b8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b4:	fee7eae3          	bltu	a5,a4,8a8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8b8:	ff852583          	lw	a1,-8(a0)
 8bc:	6390                	ld	a2,0(a5)
 8be:	02059813          	slli	a6,a1,0x20
 8c2:	01c85713          	srli	a4,a6,0x1c
 8c6:	9736                	add	a4,a4,a3
 8c8:	fae60de3          	beq	a2,a4,882 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8cc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8d0:	4790                	lw	a2,8(a5)
 8d2:	02061593          	slli	a1,a2,0x20
 8d6:	01c5d713          	srli	a4,a1,0x1c
 8da:	973e                	add	a4,a4,a5
 8dc:	fae68ae3          	beq	a3,a4,890 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8e0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8e2:	00000717          	auipc	a4,0x0
 8e6:	70f73f23          	sd	a5,1822(a4) # 1000 <freep>
}
 8ea:	6422                	ld	s0,8(sp)
 8ec:	0141                	addi	sp,sp,16
 8ee:	8082                	ret

00000000000008f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8f0:	7139                	addi	sp,sp,-64
 8f2:	fc06                	sd	ra,56(sp)
 8f4:	f822                	sd	s0,48(sp)
 8f6:	f426                	sd	s1,40(sp)
 8f8:	ec4e                	sd	s3,24(sp)
 8fa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8fc:	02051493          	slli	s1,a0,0x20
 900:	9081                	srli	s1,s1,0x20
 902:	04bd                	addi	s1,s1,15
 904:	8091                	srli	s1,s1,0x4
 906:	0014899b          	addiw	s3,s1,1
 90a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 90c:	00000517          	auipc	a0,0x0
 910:	6f453503          	ld	a0,1780(a0) # 1000 <freep>
 914:	c915                	beqz	a0,948 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 916:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 918:	4798                	lw	a4,8(a5)
 91a:	08977a63          	bgeu	a4,s1,9ae <malloc+0xbe>
 91e:	f04a                	sd	s2,32(sp)
 920:	e852                	sd	s4,16(sp)
 922:	e456                	sd	s5,8(sp)
 924:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 926:	8a4e                	mv	s4,s3
 928:	0009871b          	sext.w	a4,s3
 92c:	6685                	lui	a3,0x1
 92e:	00d77363          	bgeu	a4,a3,934 <malloc+0x44>
 932:	6a05                	lui	s4,0x1
 934:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 938:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 93c:	00000917          	auipc	s2,0x0
 940:	6c490913          	addi	s2,s2,1732 # 1000 <freep>
  if(p == (char*)-1)
 944:	5afd                	li	s5,-1
 946:	a081                	j	986 <malloc+0x96>
 948:	f04a                	sd	s2,32(sp)
 94a:	e852                	sd	s4,16(sp)
 94c:	e456                	sd	s5,8(sp)
 94e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 950:	00000797          	auipc	a5,0x0
 954:	6c078793          	addi	a5,a5,1728 # 1010 <base>
 958:	00000717          	auipc	a4,0x0
 95c:	6af73423          	sd	a5,1704(a4) # 1000 <freep>
 960:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 962:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 966:	b7c1                	j	926 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 968:	6398                	ld	a4,0(a5)
 96a:	e118                	sd	a4,0(a0)
 96c:	a8a9                	j	9c6 <malloc+0xd6>
  hp->s.size = nu;
 96e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 972:	0541                	addi	a0,a0,16
 974:	efbff0ef          	jal	86e <free>
  return freep;
 978:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 97c:	c12d                	beqz	a0,9de <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 980:	4798                	lw	a4,8(a5)
 982:	02977263          	bgeu	a4,s1,9a6 <malloc+0xb6>
    if(p == freep)
 986:	00093703          	ld	a4,0(s2)
 98a:	853e                	mv	a0,a5
 98c:	fef719e3          	bne	a4,a5,97e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 990:	8552                	mv	a0,s4
 992:	ad3ff0ef          	jal	464 <sbrk>
  if(p == (char*)-1)
 996:	fd551ce3          	bne	a0,s5,96e <malloc+0x7e>
        return 0;
 99a:	4501                	li	a0,0
 99c:	7902                	ld	s2,32(sp)
 99e:	6a42                	ld	s4,16(sp)
 9a0:	6aa2                	ld	s5,8(sp)
 9a2:	6b02                	ld	s6,0(sp)
 9a4:	a03d                	j	9d2 <malloc+0xe2>
 9a6:	7902                	ld	s2,32(sp)
 9a8:	6a42                	ld	s4,16(sp)
 9aa:	6aa2                	ld	s5,8(sp)
 9ac:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9ae:	fae48de3          	beq	s1,a4,968 <malloc+0x78>
        p->s.size -= nunits;
 9b2:	4137073b          	subw	a4,a4,s3
 9b6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9b8:	02071693          	slli	a3,a4,0x20
 9bc:	01c6d713          	srli	a4,a3,0x1c
 9c0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9c2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9c6:	00000717          	auipc	a4,0x0
 9ca:	62a73d23          	sd	a0,1594(a4) # 1000 <freep>
      return (void*)(p + 1);
 9ce:	01078513          	addi	a0,a5,16
  }
}
 9d2:	70e2                	ld	ra,56(sp)
 9d4:	7442                	ld	s0,48(sp)
 9d6:	74a2                	ld	s1,40(sp)
 9d8:	69e2                	ld	s3,24(sp)
 9da:	6121                	addi	sp,sp,64
 9dc:	8082                	ret
 9de:	7902                	ld	s2,32(sp)
 9e0:	6a42                	ld	s4,16(sp)
 9e2:	6aa2                	ld	s5,8(sp)
 9e4:	6b02                	ld	s6,0(sp)
 9e6:	b7f5                	j	9d2 <malloc+0xe2>
