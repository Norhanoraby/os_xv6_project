
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
  ee:	92e50513          	addi	a0,a0,-1746 # a18 <malloc+0x140>
  f2:	732000ef          	jal	824 <printf>
        exit(0);
  f6:	4501                	li	a0,0
  f8:	2e4000ef          	jal	3dc <exit>
    if(argc == 2 && strcmp(argv[1], "?") == 0) {
  fc:	00001597          	auipc	a1,0x1
 100:	8d458593          	addi	a1,a1,-1836 # 9d0 <malloc+0xf8>
 104:	6488                	ld	a0,8(s1)
 106:	09a000ef          	jal	1a0 <strcmp>
 10a:	cd01                	beqz	a0,122 <main+0x6c>
 10c:	e84a                	sd	s2,16(sp)
 10e:	e44e                	sd	s3,8(sp)
        printf("You can only add two numbers\n");
 110:	00001517          	auipc	a0,0x1
 114:	8e850513          	addi	a0,a0,-1816 # 9f8 <malloc+0x120>
 118:	70c000ef          	jal	824 <printf>
        exit(0);
 11c:	4501                	li	a0,0
 11e:	2be000ef          	jal	3dc <exit>
 122:	e84a                	sd	s2,16(sp)
 124:	e44e                	sd	s3,8(sp)
        printf("Usage: add number1 number2\n");
 126:	00001517          	auipc	a0,0x1
 12a:	8b250513          	addi	a0,a0,-1870 # 9d8 <malloc+0x100>
 12e:	6f6000ef          	jal	824 <printf>
        exit(0);
 132:	4501                	li	a0,0
 134:	2a8000ef          	jal	3dc <exit>
        printf("needs numbers\n");
 138:	00001517          	auipc	a0,0x1
 13c:	8e050513          	addi	a0,a0,-1824 # a18 <malloc+0x140>
 140:	6e4000ef          	jal	824 <printf>
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
 164:	8c850513          	addi	a0,a0,-1848 # a28 <malloc+0x150>
 168:	6bc000ef          	jal	824 <printf>
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

000000000000049c <rand>:
.global rand
rand:
 li a7, SYS_rand
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

00000000000004ac <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ac:	1101                	addi	sp,sp,-32
 4ae:	ec06                	sd	ra,24(sp)
 4b0:	e822                	sd	s0,16(sp)
 4b2:	1000                	addi	s0,sp,32
 4b4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4b8:	4605                	li	a2,1
 4ba:	fef40593          	addi	a1,s0,-17
 4be:	f3fff0ef          	jal	3fc <write>
}
 4c2:	60e2                	ld	ra,24(sp)
 4c4:	6442                	ld	s0,16(sp)
 4c6:	6105                	addi	sp,sp,32
 4c8:	8082                	ret

00000000000004ca <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ca:	7139                	addi	sp,sp,-64
 4cc:	fc06                	sd	ra,56(sp)
 4ce:	f822                	sd	s0,48(sp)
 4d0:	f426                	sd	s1,40(sp)
 4d2:	0080                	addi	s0,sp,64
 4d4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4d6:	c299                	beqz	a3,4dc <printint+0x12>
 4d8:	0805c963          	bltz	a1,56a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4dc:	2581                	sext.w	a1,a1
  neg = 0;
 4de:	4881                	li	a7,0
 4e0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4e4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4e6:	2601                	sext.w	a2,a2
 4e8:	00000517          	auipc	a0,0x0
 4ec:	56850513          	addi	a0,a0,1384 # a50 <digits>
 4f0:	883a                	mv	a6,a4
 4f2:	2705                	addiw	a4,a4,1
 4f4:	02c5f7bb          	remuw	a5,a1,a2
 4f8:	1782                	slli	a5,a5,0x20
 4fa:	9381                	srli	a5,a5,0x20
 4fc:	97aa                	add	a5,a5,a0
 4fe:	0007c783          	lbu	a5,0(a5)
 502:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 506:	0005879b          	sext.w	a5,a1
 50a:	02c5d5bb          	divuw	a1,a1,a2
 50e:	0685                	addi	a3,a3,1
 510:	fec7f0e3          	bgeu	a5,a2,4f0 <printint+0x26>
  if(neg)
 514:	00088c63          	beqz	a7,52c <printint+0x62>
    buf[i++] = '-';
 518:	fd070793          	addi	a5,a4,-48
 51c:	00878733          	add	a4,a5,s0
 520:	02d00793          	li	a5,45
 524:	fef70823          	sb	a5,-16(a4)
 528:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 52c:	02e05a63          	blez	a4,560 <printint+0x96>
 530:	f04a                	sd	s2,32(sp)
 532:	ec4e                	sd	s3,24(sp)
 534:	fc040793          	addi	a5,s0,-64
 538:	00e78933          	add	s2,a5,a4
 53c:	fff78993          	addi	s3,a5,-1
 540:	99ba                	add	s3,s3,a4
 542:	377d                	addiw	a4,a4,-1
 544:	1702                	slli	a4,a4,0x20
 546:	9301                	srli	a4,a4,0x20
 548:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 54c:	fff94583          	lbu	a1,-1(s2)
 550:	8526                	mv	a0,s1
 552:	f5bff0ef          	jal	4ac <putc>
  while(--i >= 0)
 556:	197d                	addi	s2,s2,-1
 558:	ff391ae3          	bne	s2,s3,54c <printint+0x82>
 55c:	7902                	ld	s2,32(sp)
 55e:	69e2                	ld	s3,24(sp)
}
 560:	70e2                	ld	ra,56(sp)
 562:	7442                	ld	s0,48(sp)
 564:	74a2                	ld	s1,40(sp)
 566:	6121                	addi	sp,sp,64
 568:	8082                	ret
    x = -xx;
 56a:	40b005bb          	negw	a1,a1
    neg = 1;
 56e:	4885                	li	a7,1
    x = -xx;
 570:	bf85                	j	4e0 <printint+0x16>

0000000000000572 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 572:	711d                	addi	sp,sp,-96
 574:	ec86                	sd	ra,88(sp)
 576:	e8a2                	sd	s0,80(sp)
 578:	e0ca                	sd	s2,64(sp)
 57a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 57c:	0005c903          	lbu	s2,0(a1)
 580:	26090863          	beqz	s2,7f0 <vprintf+0x27e>
 584:	e4a6                	sd	s1,72(sp)
 586:	fc4e                	sd	s3,56(sp)
 588:	f852                	sd	s4,48(sp)
 58a:	f456                	sd	s5,40(sp)
 58c:	f05a                	sd	s6,32(sp)
 58e:	ec5e                	sd	s7,24(sp)
 590:	e862                	sd	s8,16(sp)
 592:	e466                	sd	s9,8(sp)
 594:	8b2a                	mv	s6,a0
 596:	8a2e                	mv	s4,a1
 598:	8bb2                	mv	s7,a2
  state = 0;
 59a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 59c:	4481                	li	s1,0
 59e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5a0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5a4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5a8:	06c00c93          	li	s9,108
 5ac:	a005                	j	5cc <vprintf+0x5a>
        putc(fd, c0);
 5ae:	85ca                	mv	a1,s2
 5b0:	855a                	mv	a0,s6
 5b2:	efbff0ef          	jal	4ac <putc>
 5b6:	a019                	j	5bc <vprintf+0x4a>
    } else if(state == '%'){
 5b8:	03598263          	beq	s3,s5,5dc <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5bc:	2485                	addiw	s1,s1,1
 5be:	8726                	mv	a4,s1
 5c0:	009a07b3          	add	a5,s4,s1
 5c4:	0007c903          	lbu	s2,0(a5)
 5c8:	20090c63          	beqz	s2,7e0 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 5cc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5d0:	fe0994e3          	bnez	s3,5b8 <vprintf+0x46>
      if(c0 == '%'){
 5d4:	fd579de3          	bne	a5,s5,5ae <vprintf+0x3c>
        state = '%';
 5d8:	89be                	mv	s3,a5
 5da:	b7cd                	j	5bc <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5dc:	00ea06b3          	add	a3,s4,a4
 5e0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5e4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5e6:	c681                	beqz	a3,5ee <vprintf+0x7c>
 5e8:	9752                	add	a4,a4,s4
 5ea:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5ee:	03878f63          	beq	a5,s8,62c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5f2:	05978963          	beq	a5,s9,644 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5f6:	07500713          	li	a4,117
 5fa:	0ee78363          	beq	a5,a4,6e0 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5fe:	07800713          	li	a4,120
 602:	12e78563          	beq	a5,a4,72c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 606:	07000713          	li	a4,112
 60a:	14e78a63          	beq	a5,a4,75e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 60e:	07300713          	li	a4,115
 612:	18e78a63          	beq	a5,a4,7a6 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 616:	02500713          	li	a4,37
 61a:	04e79563          	bne	a5,a4,664 <vprintf+0xf2>
        putc(fd, '%');
 61e:	02500593          	li	a1,37
 622:	855a                	mv	a0,s6
 624:	e89ff0ef          	jal	4ac <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 628:	4981                	li	s3,0
 62a:	bf49                	j	5bc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 62c:	008b8913          	addi	s2,s7,8
 630:	4685                	li	a3,1
 632:	4629                	li	a2,10
 634:	000ba583          	lw	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	e91ff0ef          	jal	4ca <printint>
 63e:	8bca                	mv	s7,s2
      state = 0;
 640:	4981                	li	s3,0
 642:	bfad                	j	5bc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 644:	06400793          	li	a5,100
 648:	02f68963          	beq	a3,a5,67a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 64c:	06c00793          	li	a5,108
 650:	04f68263          	beq	a3,a5,694 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 654:	07500793          	li	a5,117
 658:	0af68063          	beq	a3,a5,6f8 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 65c:	07800793          	li	a5,120
 660:	0ef68263          	beq	a3,a5,744 <vprintf+0x1d2>
        putc(fd, '%');
 664:	02500593          	li	a1,37
 668:	855a                	mv	a0,s6
 66a:	e43ff0ef          	jal	4ac <putc>
        putc(fd, c0);
 66e:	85ca                	mv	a1,s2
 670:	855a                	mv	a0,s6
 672:	e3bff0ef          	jal	4ac <putc>
      state = 0;
 676:	4981                	li	s3,0
 678:	b791                	j	5bc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 67a:	008b8913          	addi	s2,s7,8
 67e:	4685                	li	a3,1
 680:	4629                	li	a2,10
 682:	000ba583          	lw	a1,0(s7)
 686:	855a                	mv	a0,s6
 688:	e43ff0ef          	jal	4ca <printint>
        i += 1;
 68c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 68e:	8bca                	mv	s7,s2
      state = 0;
 690:	4981                	li	s3,0
        i += 1;
 692:	b72d                	j	5bc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 694:	06400793          	li	a5,100
 698:	02f60763          	beq	a2,a5,6c6 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 69c:	07500793          	li	a5,117
 6a0:	06f60963          	beq	a2,a5,712 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6a4:	07800793          	li	a5,120
 6a8:	faf61ee3          	bne	a2,a5,664 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ac:	008b8913          	addi	s2,s7,8
 6b0:	4681                	li	a3,0
 6b2:	4641                	li	a2,16
 6b4:	000ba583          	lw	a1,0(s7)
 6b8:	855a                	mv	a0,s6
 6ba:	e11ff0ef          	jal	4ca <printint>
        i += 2;
 6be:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c0:	8bca                	mv	s7,s2
      state = 0;
 6c2:	4981                	li	s3,0
        i += 2;
 6c4:	bde5                	j	5bc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c6:	008b8913          	addi	s2,s7,8
 6ca:	4685                	li	a3,1
 6cc:	4629                	li	a2,10
 6ce:	000ba583          	lw	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	df7ff0ef          	jal	4ca <printint>
        i += 2;
 6d8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6da:	8bca                	mv	s7,s2
      state = 0;
 6dc:	4981                	li	s3,0
        i += 2;
 6de:	bdf9                	j	5bc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6e0:	008b8913          	addi	s2,s7,8
 6e4:	4681                	li	a3,0
 6e6:	4629                	li	a2,10
 6e8:	000ba583          	lw	a1,0(s7)
 6ec:	855a                	mv	a0,s6
 6ee:	dddff0ef          	jal	4ca <printint>
 6f2:	8bca                	mv	s7,s2
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b5d9                	j	5bc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f8:	008b8913          	addi	s2,s7,8
 6fc:	4681                	li	a3,0
 6fe:	4629                	li	a2,10
 700:	000ba583          	lw	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	dc5ff0ef          	jal	4ca <printint>
        i += 1;
 70a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 70c:	8bca                	mv	s7,s2
      state = 0;
 70e:	4981                	li	s3,0
        i += 1;
 710:	b575                	j	5bc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 712:	008b8913          	addi	s2,s7,8
 716:	4681                	li	a3,0
 718:	4629                	li	a2,10
 71a:	000ba583          	lw	a1,0(s7)
 71e:	855a                	mv	a0,s6
 720:	dabff0ef          	jal	4ca <printint>
        i += 2;
 724:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 726:	8bca                	mv	s7,s2
      state = 0;
 728:	4981                	li	s3,0
        i += 2;
 72a:	bd49                	j	5bc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 72c:	008b8913          	addi	s2,s7,8
 730:	4681                	li	a3,0
 732:	4641                	li	a2,16
 734:	000ba583          	lw	a1,0(s7)
 738:	855a                	mv	a0,s6
 73a:	d91ff0ef          	jal	4ca <printint>
 73e:	8bca                	mv	s7,s2
      state = 0;
 740:	4981                	li	s3,0
 742:	bdad                	j	5bc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 744:	008b8913          	addi	s2,s7,8
 748:	4681                	li	a3,0
 74a:	4641                	li	a2,16
 74c:	000ba583          	lw	a1,0(s7)
 750:	855a                	mv	a0,s6
 752:	d79ff0ef          	jal	4ca <printint>
        i += 1;
 756:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 758:	8bca                	mv	s7,s2
      state = 0;
 75a:	4981                	li	s3,0
        i += 1;
 75c:	b585                	j	5bc <vprintf+0x4a>
 75e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 760:	008b8d13          	addi	s10,s7,8
 764:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 768:	03000593          	li	a1,48
 76c:	855a                	mv	a0,s6
 76e:	d3fff0ef          	jal	4ac <putc>
  putc(fd, 'x');
 772:	07800593          	li	a1,120
 776:	855a                	mv	a0,s6
 778:	d35ff0ef          	jal	4ac <putc>
 77c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 77e:	00000b97          	auipc	s7,0x0
 782:	2d2b8b93          	addi	s7,s7,722 # a50 <digits>
 786:	03c9d793          	srli	a5,s3,0x3c
 78a:	97de                	add	a5,a5,s7
 78c:	0007c583          	lbu	a1,0(a5)
 790:	855a                	mv	a0,s6
 792:	d1bff0ef          	jal	4ac <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 796:	0992                	slli	s3,s3,0x4
 798:	397d                	addiw	s2,s2,-1
 79a:	fe0916e3          	bnez	s2,786 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 79e:	8bea                	mv	s7,s10
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	6d02                	ld	s10,0(sp)
 7a4:	bd21                	j	5bc <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7a6:	008b8993          	addi	s3,s7,8
 7aa:	000bb903          	ld	s2,0(s7)
 7ae:	00090f63          	beqz	s2,7cc <vprintf+0x25a>
        for(; *s; s++)
 7b2:	00094583          	lbu	a1,0(s2)
 7b6:	c195                	beqz	a1,7da <vprintf+0x268>
          putc(fd, *s);
 7b8:	855a                	mv	a0,s6
 7ba:	cf3ff0ef          	jal	4ac <putc>
        for(; *s; s++)
 7be:	0905                	addi	s2,s2,1
 7c0:	00094583          	lbu	a1,0(s2)
 7c4:	f9f5                	bnez	a1,7b8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7c6:	8bce                	mv	s7,s3
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	bbcd                	j	5bc <vprintf+0x4a>
          s = "(null)";
 7cc:	00000917          	auipc	s2,0x0
 7d0:	27c90913          	addi	s2,s2,636 # a48 <malloc+0x170>
        for(; *s; s++)
 7d4:	02800593          	li	a1,40
 7d8:	b7c5                	j	7b8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7da:	8bce                	mv	s7,s3
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	bbf9                	j	5bc <vprintf+0x4a>
 7e0:	64a6                	ld	s1,72(sp)
 7e2:	79e2                	ld	s3,56(sp)
 7e4:	7a42                	ld	s4,48(sp)
 7e6:	7aa2                	ld	s5,40(sp)
 7e8:	7b02                	ld	s6,32(sp)
 7ea:	6be2                	ld	s7,24(sp)
 7ec:	6c42                	ld	s8,16(sp)
 7ee:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7f0:	60e6                	ld	ra,88(sp)
 7f2:	6446                	ld	s0,80(sp)
 7f4:	6906                	ld	s2,64(sp)
 7f6:	6125                	addi	sp,sp,96
 7f8:	8082                	ret

00000000000007fa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7fa:	715d                	addi	sp,sp,-80
 7fc:	ec06                	sd	ra,24(sp)
 7fe:	e822                	sd	s0,16(sp)
 800:	1000                	addi	s0,sp,32
 802:	e010                	sd	a2,0(s0)
 804:	e414                	sd	a3,8(s0)
 806:	e818                	sd	a4,16(s0)
 808:	ec1c                	sd	a5,24(s0)
 80a:	03043023          	sd	a6,32(s0)
 80e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 812:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 816:	8622                	mv	a2,s0
 818:	d5bff0ef          	jal	572 <vprintf>
}
 81c:	60e2                	ld	ra,24(sp)
 81e:	6442                	ld	s0,16(sp)
 820:	6161                	addi	sp,sp,80
 822:	8082                	ret

0000000000000824 <printf>:

void
printf(const char *fmt, ...)
{
 824:	711d                	addi	sp,sp,-96
 826:	ec06                	sd	ra,24(sp)
 828:	e822                	sd	s0,16(sp)
 82a:	1000                	addi	s0,sp,32
 82c:	e40c                	sd	a1,8(s0)
 82e:	e810                	sd	a2,16(s0)
 830:	ec14                	sd	a3,24(s0)
 832:	f018                	sd	a4,32(s0)
 834:	f41c                	sd	a5,40(s0)
 836:	03043823          	sd	a6,48(s0)
 83a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 83e:	00840613          	addi	a2,s0,8
 842:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 846:	85aa                	mv	a1,a0
 848:	4505                	li	a0,1
 84a:	d29ff0ef          	jal	572 <vprintf>
}
 84e:	60e2                	ld	ra,24(sp)
 850:	6442                	ld	s0,16(sp)
 852:	6125                	addi	sp,sp,96
 854:	8082                	ret

0000000000000856 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 856:	1141                	addi	sp,sp,-16
 858:	e422                	sd	s0,8(sp)
 85a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 85c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 860:	00000797          	auipc	a5,0x0
 864:	7a07b783          	ld	a5,1952(a5) # 1000 <freep>
 868:	a02d                	j	892 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 86a:	4618                	lw	a4,8(a2)
 86c:	9f2d                	addw	a4,a4,a1
 86e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 872:	6398                	ld	a4,0(a5)
 874:	6310                	ld	a2,0(a4)
 876:	a83d                	j	8b4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 878:	ff852703          	lw	a4,-8(a0)
 87c:	9f31                	addw	a4,a4,a2
 87e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 880:	ff053683          	ld	a3,-16(a0)
 884:	a091                	j	8c8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 886:	6398                	ld	a4,0(a5)
 888:	00e7e463          	bltu	a5,a4,890 <free+0x3a>
 88c:	00e6ea63          	bltu	a3,a4,8a0 <free+0x4a>
{
 890:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 892:	fed7fae3          	bgeu	a5,a3,886 <free+0x30>
 896:	6398                	ld	a4,0(a5)
 898:	00e6e463          	bltu	a3,a4,8a0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89c:	fee7eae3          	bltu	a5,a4,890 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8a0:	ff852583          	lw	a1,-8(a0)
 8a4:	6390                	ld	a2,0(a5)
 8a6:	02059813          	slli	a6,a1,0x20
 8aa:	01c85713          	srli	a4,a6,0x1c
 8ae:	9736                	add	a4,a4,a3
 8b0:	fae60de3          	beq	a2,a4,86a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8b4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8b8:	4790                	lw	a2,8(a5)
 8ba:	02061593          	slli	a1,a2,0x20
 8be:	01c5d713          	srli	a4,a1,0x1c
 8c2:	973e                	add	a4,a4,a5
 8c4:	fae68ae3          	beq	a3,a4,878 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8c8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ca:	00000717          	auipc	a4,0x0
 8ce:	72f73b23          	sd	a5,1846(a4) # 1000 <freep>
}
 8d2:	6422                	ld	s0,8(sp)
 8d4:	0141                	addi	sp,sp,16
 8d6:	8082                	ret

00000000000008d8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8d8:	7139                	addi	sp,sp,-64
 8da:	fc06                	sd	ra,56(sp)
 8dc:	f822                	sd	s0,48(sp)
 8de:	f426                	sd	s1,40(sp)
 8e0:	ec4e                	sd	s3,24(sp)
 8e2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e4:	02051493          	slli	s1,a0,0x20
 8e8:	9081                	srli	s1,s1,0x20
 8ea:	04bd                	addi	s1,s1,15
 8ec:	8091                	srli	s1,s1,0x4
 8ee:	0014899b          	addiw	s3,s1,1
 8f2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8f4:	00000517          	auipc	a0,0x0
 8f8:	70c53503          	ld	a0,1804(a0) # 1000 <freep>
 8fc:	c915                	beqz	a0,930 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 900:	4798                	lw	a4,8(a5)
 902:	08977a63          	bgeu	a4,s1,996 <malloc+0xbe>
 906:	f04a                	sd	s2,32(sp)
 908:	e852                	sd	s4,16(sp)
 90a:	e456                	sd	s5,8(sp)
 90c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 90e:	8a4e                	mv	s4,s3
 910:	0009871b          	sext.w	a4,s3
 914:	6685                	lui	a3,0x1
 916:	00d77363          	bgeu	a4,a3,91c <malloc+0x44>
 91a:	6a05                	lui	s4,0x1
 91c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 920:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 924:	00000917          	auipc	s2,0x0
 928:	6dc90913          	addi	s2,s2,1756 # 1000 <freep>
  if(p == (char*)-1)
 92c:	5afd                	li	s5,-1
 92e:	a081                	j	96e <malloc+0x96>
 930:	f04a                	sd	s2,32(sp)
 932:	e852                	sd	s4,16(sp)
 934:	e456                	sd	s5,8(sp)
 936:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 938:	00000797          	auipc	a5,0x0
 93c:	6d878793          	addi	a5,a5,1752 # 1010 <base>
 940:	00000717          	auipc	a4,0x0
 944:	6cf73023          	sd	a5,1728(a4) # 1000 <freep>
 948:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 94a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 94e:	b7c1                	j	90e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 950:	6398                	ld	a4,0(a5)
 952:	e118                	sd	a4,0(a0)
 954:	a8a9                	j	9ae <malloc+0xd6>
  hp->s.size = nu;
 956:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 95a:	0541                	addi	a0,a0,16
 95c:	efbff0ef          	jal	856 <free>
  return freep;
 960:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 964:	c12d                	beqz	a0,9c6 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 966:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 968:	4798                	lw	a4,8(a5)
 96a:	02977263          	bgeu	a4,s1,98e <malloc+0xb6>
    if(p == freep)
 96e:	00093703          	ld	a4,0(s2)
 972:	853e                	mv	a0,a5
 974:	fef719e3          	bne	a4,a5,966 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 978:	8552                	mv	a0,s4
 97a:	aebff0ef          	jal	464 <sbrk>
  if(p == (char*)-1)
 97e:	fd551ce3          	bne	a0,s5,956 <malloc+0x7e>
        return 0;
 982:	4501                	li	a0,0
 984:	7902                	ld	s2,32(sp)
 986:	6a42                	ld	s4,16(sp)
 988:	6aa2                	ld	s5,8(sp)
 98a:	6b02                	ld	s6,0(sp)
 98c:	a03d                	j	9ba <malloc+0xe2>
 98e:	7902                	ld	s2,32(sp)
 990:	6a42                	ld	s4,16(sp)
 992:	6aa2                	ld	s5,8(sp)
 994:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 996:	fae48de3          	beq	s1,a4,950 <malloc+0x78>
        p->s.size -= nunits;
 99a:	4137073b          	subw	a4,a4,s3
 99e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9a0:	02071693          	slli	a3,a4,0x20
 9a4:	01c6d713          	srli	a4,a3,0x1c
 9a8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9aa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ae:	00000717          	auipc	a4,0x0
 9b2:	64a73923          	sd	a0,1618(a4) # 1000 <freep>
      return (void*)(p + 1);
 9b6:	01078513          	addi	a0,a5,16
  }
}
 9ba:	70e2                	ld	ra,56(sp)
 9bc:	7442                	ld	s0,48(sp)
 9be:	74a2                	ld	s1,40(sp)
 9c0:	69e2                	ld	s3,24(sp)
 9c2:	6121                	addi	sp,sp,64
 9c4:	8082                	ret
 9c6:	7902                	ld	s2,32(sp)
 9c8:	6a42                	ld	s4,16(sp)
 9ca:	6aa2                	ld	s5,8(sp)
 9cc:	6b02                	ld	s6,0(sp)
 9ce:	b7f5                	j	9ba <malloc+0xe2>
