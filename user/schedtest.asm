
user/_schedtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"


int main(int argc, char *argv[]) {
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	0100                	addi	s0,sp,128
  14:	81010113          	addi	sp,sp,-2032
  int z, steps = 1000000;
  char buffer_src[1024], buffer_dst[1024];
  int status, tt, wt;
  int total_tt = 0, total_wt = 0;
  int mode = 0; // roundrobin
  if (argc >= 2) {
  18:	4785                	li	a5,1
  1a:	02a7c163          	blt	a5,a0,3c <main+0x3c>
      mode = atoi(argv[1]); // Read mode from command line (e.g., "2")
  }
  if (set_sched(mode) < 0) {
  1e:	4501                	li	a0,0
  20:	506000ef          	jal	526 <set_sched>
  24:	04054163          	bltz	a0,66 <main+0x66>
  int mode = 0; // roundrobin
  28:	4981                	li	s3,0
  if(mode == 1) 
      printf("Scheduler set to FCFS. Creating 10 processes...\n");
  else if (mode ==2)
      printf("Scheduler set to priority. Creating 10 processes...\n");
  else
  printf("Scheduler set to RoundRobin. Creating 10 processes...\n");
  2a:	00001517          	auipc	a0,0x1
  2e:	ace50513          	addi	a0,a0,-1330 # af8 <malloc+0x196>
  32:	07d000ef          	jal	8ae <printf>
  int mode = 0; // roundrobin
  36:	44a9                	li	s1,10


  for (k = 0; k < nprocess; k++) {
    // ensure different creation times (proc->ctime)
    // needed for properly testing FCFS scheduling
    if (mode == 2) 
  38:	4909                	li	s2,2
  3a:	a095                	j	9e <main+0x9e>
      mode = atoi(argv[1]); // Read mode from command line (e.g., "2")
  3c:	6588                	ld	a0,8(a1)
  3e:	31a000ef          	jal	358 <atoi>
  42:	89aa                	mv	s3,a0
  if (set_sched(mode) < 0) {
  44:	4e2000ef          	jal	526 <set_sched>
  48:	02054063          	bltz	a0,68 <main+0x68>
  if(mode == 1) 
  4c:	4785                	li	a5,1
  4e:	02f98763          	beq	s3,a5,7c <main+0x7c>
  else if (mode ==2)
  52:	4789                	li	a5,2
  54:	fcf99be3          	bne	s3,a5,2a <main+0x2a>
      printf("Scheduler set to priority. Creating 10 processes...\n");
  58:	00001517          	auipc	a0,0x1
  5c:	a6850513          	addi	a0,a0,-1432 # ac0 <malloc+0x15e>
  60:	04f000ef          	jal	8ae <printf>
  64:	bfc9                	j	36 <main+0x36>
  int mode = 0; // roundrobin
  66:	4981                	li	s3,0
       printf("Error setting scheduler (Mode %d)\n", mode);
  68:	85ce                	mv	a1,s3
  6a:	00001517          	auipc	a0,0x1
  6e:	9f650513          	addi	a0,a0,-1546 # a60 <malloc+0xfe>
  72:	03d000ef          	jal	8ae <printf>
       exit(1);
  76:	4505                	li	a0,1
  78:	3d6000ef          	jal	44e <exit>
      printf("Scheduler set to FCFS. Creating 10 processes...\n");
  7c:	00001517          	auipc	a0,0x1
  80:	a0c50513          	addi	a0,a0,-1524 # a88 <malloc+0x126>
  84:	02b000ef          	jal	8ae <printf>
  88:	b77d                	j	36 <main+0x36>
        sleep(1); // Faster creation for Priority
  8a:	4505                	li	a0,1
  8c:	452000ef          	jal	4de <sleep>
    else 
    sleep(2);

    pid = fork();
  90:	3b6000ef          	jal	446 <fork>
    if (pid < 0) {
  94:	00054b63          	bltz	a0,aa <main+0xaa>
      printf("%d failed in fork!\n", getpid());
      exit(0);

    }
    else if (pid == 0) {
  98:	c50d                	beqz	a0,c2 <main+0xc2>
  for (k = 0; k < nprocess; k++) {
  9a:	34fd                	addiw	s1,s1,-1
  9c:	c8a5                	beqz	s1,10c <main+0x10c>
    if (mode == 2) 
  9e:	ff2986e3          	beq	s3,s2,8a <main+0x8a>
    sleep(2);
  a2:	854a                	mv	a0,s2
  a4:	43a000ef          	jal	4de <sleep>
  a8:	b7e5                	j	90 <main+0x90>
      printf("%d failed in fork!\n", getpid());
  aa:	424000ef          	jal	4ce <getpid>
  ae:	85aa                	mv	a1,a0
  b0:	00001517          	auipc	a0,0x1
  b4:	a8050513          	addi	a0,a0,-1408 # b30 <malloc+0x1ce>
  b8:	7f6000ef          	jal	8ae <printf>
      exit(0);
  bc:	4501                	li	a0,0
  be:	390000ef          	jal	44e <exit>
      // child
      printf("[pid=%d] created\n", getpid());
  c2:	40c000ef          	jal	4ce <getpid>
  c6:	85aa                	mv	a1,a0
  c8:	00001517          	auipc	a0,0x1
  cc:	a8050513          	addi	a0,a0,-1408 # b48 <malloc+0x1e6>
  d0:	7de000ef          	jal	8ae <printf>
  d4:	000f44b7          	lui	s1,0xf4
  d8:	24048493          	addi	s1,s1,576 # f4240 <base+0xf3230>

      for (z = 0; z < steps; z += 1) {
         // copy buffers one inside the other and back
         // used for wasting cpu time
         memmove(buffer_dst, buffer_src, 1024);
  dc:	40000613          	li	a2,1024
  e0:	bc040593          	addi	a1,s0,-1088
  e4:	797d                	lui	s2,0xfffff
  e6:	7c090513          	addi	a0,s2,1984 # fffffffffffff7c0 <base+0xffffffffffffe7b0>
  ea:	9522                	add	a0,a0,s0
  ec:	2b4000ef          	jal	3a0 <memmove>
         memmove(buffer_src, buffer_dst, 1024);
  f0:	40000613          	li	a2,1024
  f4:	7c090593          	addi	a1,s2,1984
  f8:	95a2                	add	a1,a1,s0
  fa:	bc040513          	addi	a0,s0,-1088
  fe:	2a2000ef          	jal	3a0 <memmove>
      for (z = 0; z < steps; z += 1) {
 102:	34fd                	addiw	s1,s1,-1
 104:	fce1                	bnez	s1,dc <main+0xdc>
      }
      exit(0);
 106:	4501                	li	a0,0
 108:	346000ef          	jal	44e <exit>
 10c:	44a9                	li	s1,10
  int total_tt = 0, total_wt = 0;
 10e:	4981                	li	s3,0
 110:	4a01                	li	s4,0
    }
  }

    for (k = 0; k < nprocess; k++) {
        pid = wait_sched(&status, &tt, &wt);
 112:	77fd                	lui	a5,0xfffff
 114:	7b478793          	addi	a5,a5,1972 # fffffffffffff7b4 <base+0xffffffffffffe7a4>
 118:	97a2                	add	a5,a5,s0
 11a:	777d                	lui	a4,0xfffff
 11c:	7a870693          	addi	a3,a4,1960 # fffffffffffff7a8 <base+0xffffffffffffe798>
 120:	96a2                	add	a3,a3,s0
 122:	e29c                	sd	a5,0(a3)
 124:	77fd                	lui	a5,0xfffff
 126:	7b878793          	addi	a5,a5,1976 # fffffffffffff7b8 <base+0xffffffffffffe7a8>
 12a:	97a2                	add	a5,a5,s0
 12c:	7a070693          	addi	a3,a4,1952
 130:	96a2                	add	a3,a3,s0
 132:	e29c                	sd	a5,0(a3)
 134:	77fd                	lui	a5,0xfffff
 136:	7bc78793          	addi	a5,a5,1980 # fffffffffffff7bc <base+0xffffffffffffe7ac>
 13a:	97a2                	add	a5,a5,s0
 13c:	79870713          	addi	a4,a4,1944
 140:	9722                	add	a4,a4,s0
 142:	e31c                	sd	a5,0(a4)
            printf("[pid=%d] terminated. turnaround=%d, wait=%d\n", pid, tt, wt);
            // Sum them up for the average calculation
            total_tt += tt;
            total_wt += wt;
        } else {
            printf("Error in wait_sched\n");
 144:	00001b17          	auipc	s6,0x1
 148:	a4cb0b13          	addi	s6,s6,-1460 # b90 <malloc+0x22e>
            printf("[pid=%d] terminated. turnaround=%d, wait=%d\n", pid, tt, wt);
 14c:	797d                	lui	s2,0xfffff
 14e:	fc090793          	addi	a5,s2,-64 # ffffffffffffefc0 <base+0xffffffffffffdfb0>
 152:	00878933          	add	s2,a5,s0
 156:	00001a97          	auipc	s5,0x1
 15a:	a0aa8a93          	addi	s5,s5,-1526 # b60 <malloc+0x1fe>
 15e:	a031                	j	16a <main+0x16a>
            printf("Error in wait_sched\n");
 160:	855a                	mv	a0,s6
 162:	74c000ef          	jal	8ae <printf>
    for (k = 0; k < nprocess; k++) {
 166:	34fd                	addiw	s1,s1,-1
 168:	c0b9                	beqz	s1,1ae <main+0x1ae>
        pid = wait_sched(&status, &tt, &wt);
 16a:	77fd                	lui	a5,0xfffff
 16c:	7a878713          	addi	a4,a5,1960 # fffffffffffff7a8 <base+0xffffffffffffe798>
 170:	9722                	add	a4,a4,s0
 172:	6310                	ld	a2,0(a4)
 174:	7a078713          	addi	a4,a5,1952
 178:	9722                	add	a4,a4,s0
 17a:	630c                	ld	a1,0(a4)
 17c:	79878793          	addi	a5,a5,1944
 180:	97a2                	add	a5,a5,s0
 182:	6388                	ld	a0,0(a5)
 184:	3aa000ef          	jal	52e <wait_sched>
 188:	85aa                	mv	a1,a0
        if(pid > 0) {
 18a:	fca05be3          	blez	a0,160 <main+0x160>
            printf("[pid=%d] terminated. turnaround=%d, wait=%d\n", pid, tt, wt);
 18e:	7f492683          	lw	a3,2036(s2)
 192:	7f892603          	lw	a2,2040(s2)
 196:	8556                	mv	a0,s5
 198:	716000ef          	jal	8ae <printf>
            total_tt += tt;
 19c:	7f892783          	lw	a5,2040(s2)
 1a0:	01478a3b          	addw	s4,a5,s4
            total_wt += wt;
 1a4:	7f492783          	lw	a5,2036(s2)
 1a8:	013789bb          	addw	s3,a5,s3
 1ac:	bf6d                	j	166 <main+0x166>
        }
    }
    
    // Calculate and Print Averages
    printf("Avg turnaround time:%d.%d\n", total_tt / nprocess, 
 1ae:	44a9                	li	s1,10
 1b0:	029a663b          	remw	a2,s4,s1
 1b4:	029a45bb          	divw	a1,s4,s1
 1b8:	00001517          	auipc	a0,0x1
 1bc:	9f050513          	addi	a0,a0,-1552 # ba8 <malloc+0x246>
 1c0:	6ee000ef          	jal	8ae <printf>
           (total_tt * 10 / nprocess) % 10);
    printf("Avg wait time:%d.%d\n", total_wt / nprocess,
 1c4:	0299e63b          	remw	a2,s3,s1
 1c8:	0299c5bb          	divw	a1,s3,s1
 1cc:	00001517          	auipc	a0,0x1
 1d0:	9fc50513          	addi	a0,a0,-1540 # bc8 <malloc+0x266>
 1d4:	6da000ef          	jal	8ae <printf>
           (total_wt * 10 / nprocess) % 10);
           
    set_sched(0);
 1d8:	4501                	li	a0,0
 1da:	34c000ef          	jal	526 <set_sched>
    
    exit(0);
 1de:	4501                	li	a0,0
 1e0:	26e000ef          	jal	44e <exit>

00000000000001e4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e406                	sd	ra,8(sp)
 1e8:	e022                	sd	s0,0(sp)
 1ea:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1ec:	e15ff0ef          	jal	0 <main>
  exit(0);
 1f0:	4501                	li	a0,0
 1f2:	25c000ef          	jal	44e <exit>

00000000000001f6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e422                	sd	s0,8(sp)
 1fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1fc:	87aa                	mv	a5,a0
 1fe:	0585                	addi	a1,a1,1
 200:	0785                	addi	a5,a5,1
 202:	fff5c703          	lbu	a4,-1(a1)
 206:	fee78fa3          	sb	a4,-1(a5)
 20a:	fb75                	bnez	a4,1fe <strcpy+0x8>
    ;
  return os;
}
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret

0000000000000212 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 218:	00054783          	lbu	a5,0(a0)
 21c:	cb91                	beqz	a5,230 <strcmp+0x1e>
 21e:	0005c703          	lbu	a4,0(a1)
 222:	00f71763          	bne	a4,a5,230 <strcmp+0x1e>
    p++, q++;
 226:	0505                	addi	a0,a0,1
 228:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 22a:	00054783          	lbu	a5,0(a0)
 22e:	fbe5                	bnez	a5,21e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 230:	0005c503          	lbu	a0,0(a1)
}
 234:	40a7853b          	subw	a0,a5,a0
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret

000000000000023e <strlen>:

uint
strlen(const char *s)
{
 23e:	1141                	addi	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 244:	00054783          	lbu	a5,0(a0)
 248:	cf91                	beqz	a5,264 <strlen+0x26>
 24a:	0505                	addi	a0,a0,1
 24c:	87aa                	mv	a5,a0
 24e:	86be                	mv	a3,a5
 250:	0785                	addi	a5,a5,1
 252:	fff7c703          	lbu	a4,-1(a5)
 256:	ff65                	bnez	a4,24e <strlen+0x10>
 258:	40a6853b          	subw	a0,a3,a0
 25c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
  for(n = 0; s[n]; n++)
 264:	4501                	li	a0,0
 266:	bfe5                	j	25e <strlen+0x20>

0000000000000268 <memset>:

void*
memset(void *dst, int c, uint n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e422                	sd	s0,8(sp)
 26c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 26e:	ca19                	beqz	a2,284 <memset+0x1c>
 270:	87aa                	mv	a5,a0
 272:	1602                	slli	a2,a2,0x20
 274:	9201                	srli	a2,a2,0x20
 276:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 27a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 27e:	0785                	addi	a5,a5,1
 280:	fee79de3          	bne	a5,a4,27a <memset+0x12>
  }
  return dst;
}
 284:	6422                	ld	s0,8(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret

000000000000028a <strchr>:

char*
strchr(const char *s, char c)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e422                	sd	s0,8(sp)
 28e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 290:	00054783          	lbu	a5,0(a0)
 294:	cb99                	beqz	a5,2aa <strchr+0x20>
    if(*s == c)
 296:	00f58763          	beq	a1,a5,2a4 <strchr+0x1a>
  for(; *s; s++)
 29a:	0505                	addi	a0,a0,1
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	fbfd                	bnez	a5,296 <strchr+0xc>
      return (char*)s;
  return 0;
 2a2:	4501                	li	a0,0
}
 2a4:	6422                	ld	s0,8(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret
  return 0;
 2aa:	4501                	li	a0,0
 2ac:	bfe5                	j	2a4 <strchr+0x1a>

00000000000002ae <gets>:

char*
gets(char *buf, int max)
{
 2ae:	711d                	addi	sp,sp,-96
 2b0:	ec86                	sd	ra,88(sp)
 2b2:	e8a2                	sd	s0,80(sp)
 2b4:	e4a6                	sd	s1,72(sp)
 2b6:	e0ca                	sd	s2,64(sp)
 2b8:	fc4e                	sd	s3,56(sp)
 2ba:	f852                	sd	s4,48(sp)
 2bc:	f456                	sd	s5,40(sp)
 2be:	f05a                	sd	s6,32(sp)
 2c0:	ec5e                	sd	s7,24(sp)
 2c2:	1080                	addi	s0,sp,96
 2c4:	8baa                	mv	s7,a0
 2c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c8:	892a                	mv	s2,a0
 2ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2cc:	4aa9                	li	s5,10
 2ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2d0:	89a6                	mv	s3,s1
 2d2:	2485                	addiw	s1,s1,1
 2d4:	0344d663          	bge	s1,s4,300 <gets+0x52>
    cc = read(0, &c, 1);
 2d8:	4605                	li	a2,1
 2da:	faf40593          	addi	a1,s0,-81
 2de:	4501                	li	a0,0
 2e0:	186000ef          	jal	466 <read>
    if(cc < 1)
 2e4:	00a05e63          	blez	a0,300 <gets+0x52>
    buf[i++] = c;
 2e8:	faf44783          	lbu	a5,-81(s0)
 2ec:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2f0:	01578763          	beq	a5,s5,2fe <gets+0x50>
 2f4:	0905                	addi	s2,s2,1
 2f6:	fd679de3          	bne	a5,s6,2d0 <gets+0x22>
    buf[i++] = c;
 2fa:	89a6                	mv	s3,s1
 2fc:	a011                	j	300 <gets+0x52>
 2fe:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 300:	99de                	add	s3,s3,s7
 302:	00098023          	sb	zero,0(s3)
  return buf;
}
 306:	855e                	mv	a0,s7
 308:	60e6                	ld	ra,88(sp)
 30a:	6446                	ld	s0,80(sp)
 30c:	64a6                	ld	s1,72(sp)
 30e:	6906                	ld	s2,64(sp)
 310:	79e2                	ld	s3,56(sp)
 312:	7a42                	ld	s4,48(sp)
 314:	7aa2                	ld	s5,40(sp)
 316:	7b02                	ld	s6,32(sp)
 318:	6be2                	ld	s7,24(sp)
 31a:	6125                	addi	sp,sp,96
 31c:	8082                	ret

000000000000031e <stat>:

int
stat(const char *n, struct stat *st)
{
 31e:	1101                	addi	sp,sp,-32
 320:	ec06                	sd	ra,24(sp)
 322:	e822                	sd	s0,16(sp)
 324:	e04a                	sd	s2,0(sp)
 326:	1000                	addi	s0,sp,32
 328:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 32a:	4581                	li	a1,0
 32c:	162000ef          	jal	48e <open>
  if(fd < 0)
 330:	02054263          	bltz	a0,354 <stat+0x36>
 334:	e426                	sd	s1,8(sp)
 336:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 338:	85ca                	mv	a1,s2
 33a:	16c000ef          	jal	4a6 <fstat>
 33e:	892a                	mv	s2,a0
  close(fd);
 340:	8526                	mv	a0,s1
 342:	134000ef          	jal	476 <close>
  return r;
 346:	64a2                	ld	s1,8(sp)
}
 348:	854a                	mv	a0,s2
 34a:	60e2                	ld	ra,24(sp)
 34c:	6442                	ld	s0,16(sp)
 34e:	6902                	ld	s2,0(sp)
 350:	6105                	addi	sp,sp,32
 352:	8082                	ret
    return -1;
 354:	597d                	li	s2,-1
 356:	bfcd                	j	348 <stat+0x2a>

0000000000000358 <atoi>:

int
atoi(const char *s)
{
 358:	1141                	addi	sp,sp,-16
 35a:	e422                	sd	s0,8(sp)
 35c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 35e:	00054683          	lbu	a3,0(a0)
 362:	fd06879b          	addiw	a5,a3,-48
 366:	0ff7f793          	zext.b	a5,a5
 36a:	4625                	li	a2,9
 36c:	02f66863          	bltu	a2,a5,39c <atoi+0x44>
 370:	872a                	mv	a4,a0
  n = 0;
 372:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 374:	0705                	addi	a4,a4,1
 376:	0025179b          	slliw	a5,a0,0x2
 37a:	9fa9                	addw	a5,a5,a0
 37c:	0017979b          	slliw	a5,a5,0x1
 380:	9fb5                	addw	a5,a5,a3
 382:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 386:	00074683          	lbu	a3,0(a4)
 38a:	fd06879b          	addiw	a5,a3,-48
 38e:	0ff7f793          	zext.b	a5,a5
 392:	fef671e3          	bgeu	a2,a5,374 <atoi+0x1c>
  return n;
}
 396:	6422                	ld	s0,8(sp)
 398:	0141                	addi	sp,sp,16
 39a:	8082                	ret
  n = 0;
 39c:	4501                	li	a0,0
 39e:	bfe5                	j	396 <atoi+0x3e>

00000000000003a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3a0:	1141                	addi	sp,sp,-16
 3a2:	e422                	sd	s0,8(sp)
 3a4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3a6:	02b57463          	bgeu	a0,a1,3ce <memmove+0x2e>
    while(n-- > 0)
 3aa:	00c05f63          	blez	a2,3c8 <memmove+0x28>
 3ae:	1602                	slli	a2,a2,0x20
 3b0:	9201                	srli	a2,a2,0x20
 3b2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3b6:	872a                	mv	a4,a0
      *dst++ = *src++;
 3b8:	0585                	addi	a1,a1,1
 3ba:	0705                	addi	a4,a4,1
 3bc:	fff5c683          	lbu	a3,-1(a1)
 3c0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3c4:	fef71ae3          	bne	a4,a5,3b8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3c8:	6422                	ld	s0,8(sp)
 3ca:	0141                	addi	sp,sp,16
 3cc:	8082                	ret
    dst += n;
 3ce:	00c50733          	add	a4,a0,a2
    src += n;
 3d2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3d4:	fec05ae3          	blez	a2,3c8 <memmove+0x28>
 3d8:	fff6079b          	addiw	a5,a2,-1
 3dc:	1782                	slli	a5,a5,0x20
 3de:	9381                	srli	a5,a5,0x20
 3e0:	fff7c793          	not	a5,a5
 3e4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3e6:	15fd                	addi	a1,a1,-1
 3e8:	177d                	addi	a4,a4,-1
 3ea:	0005c683          	lbu	a3,0(a1)
 3ee:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3f2:	fee79ae3          	bne	a5,a4,3e6 <memmove+0x46>
 3f6:	bfc9                	j	3c8 <memmove+0x28>

00000000000003f8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3f8:	1141                	addi	sp,sp,-16
 3fa:	e422                	sd	s0,8(sp)
 3fc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3fe:	ca05                	beqz	a2,42e <memcmp+0x36>
 400:	fff6069b          	addiw	a3,a2,-1
 404:	1682                	slli	a3,a3,0x20
 406:	9281                	srli	a3,a3,0x20
 408:	0685                	addi	a3,a3,1
 40a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 40c:	00054783          	lbu	a5,0(a0)
 410:	0005c703          	lbu	a4,0(a1)
 414:	00e79863          	bne	a5,a4,424 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 418:	0505                	addi	a0,a0,1
    p2++;
 41a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 41c:	fed518e3          	bne	a0,a3,40c <memcmp+0x14>
  }
  return 0;
 420:	4501                	li	a0,0
 422:	a019                	j	428 <memcmp+0x30>
      return *p1 - *p2;
 424:	40e7853b          	subw	a0,a5,a4
}
 428:	6422                	ld	s0,8(sp)
 42a:	0141                	addi	sp,sp,16
 42c:	8082                	ret
  return 0;
 42e:	4501                	li	a0,0
 430:	bfe5                	j	428 <memcmp+0x30>

0000000000000432 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 432:	1141                	addi	sp,sp,-16
 434:	e406                	sd	ra,8(sp)
 436:	e022                	sd	s0,0(sp)
 438:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 43a:	f67ff0ef          	jal	3a0 <memmove>
}
 43e:	60a2                	ld	ra,8(sp)
 440:	6402                	ld	s0,0(sp)
 442:	0141                	addi	sp,sp,16
 444:	8082                	ret

0000000000000446 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 446:	4885                	li	a7,1
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <exit>:
.global exit
exit:
 li a7, SYS_exit
 44e:	4889                	li	a7,2
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <wait>:
.global wait
wait:
 li a7, SYS_wait
 456:	488d                	li	a7,3
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 45e:	4891                	li	a7,4
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <read>:
.global read
read:
 li a7, SYS_read
 466:	4895                	li	a7,5
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <write>:
.global write
write:
 li a7, SYS_write
 46e:	48c1                	li	a7,16
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <close>:
.global close
close:
 li a7, SYS_close
 476:	48d5                	li	a7,21
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <kill>:
.global kill
kill:
 li a7, SYS_kill
 47e:	4899                	li	a7,6
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <exec>:
.global exec
exec:
 li a7, SYS_exec
 486:	489d                	li	a7,7
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <open>:
.global open
open:
 li a7, SYS_open
 48e:	48bd                	li	a7,15
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 496:	48c5                	li	a7,17
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 49e:	48c9                	li	a7,18
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4a6:	48a1                	li	a7,8
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <link>:
.global link
link:
 li a7, SYS_link
 4ae:	48cd                	li	a7,19
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4b6:	48d1                	li	a7,20
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4be:	48a5                	li	a7,9
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4c6:	48a9                	li	a7,10
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ce:	48ad                	li	a7,11
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4d6:	48b1                	li	a7,12
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4de:	48b5                	li	a7,13
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4e6:	48b9                	li	a7,14
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 4ee:	48d9                	li	a7,22
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 4f6:	48dd                	li	a7,23
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 4fe:	48e1                	li	a7,24
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 506:	48e5                	li	a7,25
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <random>:
.global random
random:
 li a7, SYS_random
 50e:	48e9                	li	a7,26
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 516:	48ed                	li	a7,27
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 51e:	48f1                	li	a7,28
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <set_sched>:
.global set_sched
set_sched:
 li a7, SYS_set_sched
 526:	48f5                	li	a7,29
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <wait_sched>:
.global wait_sched
wait_sched:
 li a7, SYS_wait_sched
 52e:	48f9                	li	a7,30
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 536:	1101                	addi	sp,sp,-32
 538:	ec06                	sd	ra,24(sp)
 53a:	e822                	sd	s0,16(sp)
 53c:	1000                	addi	s0,sp,32
 53e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 542:	4605                	li	a2,1
 544:	fef40593          	addi	a1,s0,-17
 548:	f27ff0ef          	jal	46e <write>
}
 54c:	60e2                	ld	ra,24(sp)
 54e:	6442                	ld	s0,16(sp)
 550:	6105                	addi	sp,sp,32
 552:	8082                	ret

0000000000000554 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 554:	7139                	addi	sp,sp,-64
 556:	fc06                	sd	ra,56(sp)
 558:	f822                	sd	s0,48(sp)
 55a:	f426                	sd	s1,40(sp)
 55c:	0080                	addi	s0,sp,64
 55e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 560:	c299                	beqz	a3,566 <printint+0x12>
 562:	0805c963          	bltz	a1,5f4 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 566:	2581                	sext.w	a1,a1
  neg = 0;
 568:	4881                	li	a7,0
 56a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 56e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 570:	2601                	sext.w	a2,a2
 572:	00000517          	auipc	a0,0x0
 576:	67650513          	addi	a0,a0,1654 # be8 <digits>
 57a:	883a                	mv	a6,a4
 57c:	2705                	addiw	a4,a4,1
 57e:	02c5f7bb          	remuw	a5,a1,a2
 582:	1782                	slli	a5,a5,0x20
 584:	9381                	srli	a5,a5,0x20
 586:	97aa                	add	a5,a5,a0
 588:	0007c783          	lbu	a5,0(a5)
 58c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 590:	0005879b          	sext.w	a5,a1
 594:	02c5d5bb          	divuw	a1,a1,a2
 598:	0685                	addi	a3,a3,1
 59a:	fec7f0e3          	bgeu	a5,a2,57a <printint+0x26>
  if(neg)
 59e:	00088c63          	beqz	a7,5b6 <printint+0x62>
    buf[i++] = '-';
 5a2:	fd070793          	addi	a5,a4,-48
 5a6:	00878733          	add	a4,a5,s0
 5aa:	02d00793          	li	a5,45
 5ae:	fef70823          	sb	a5,-16(a4)
 5b2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5b6:	02e05a63          	blez	a4,5ea <printint+0x96>
 5ba:	f04a                	sd	s2,32(sp)
 5bc:	ec4e                	sd	s3,24(sp)
 5be:	fc040793          	addi	a5,s0,-64
 5c2:	00e78933          	add	s2,a5,a4
 5c6:	fff78993          	addi	s3,a5,-1
 5ca:	99ba                	add	s3,s3,a4
 5cc:	377d                	addiw	a4,a4,-1
 5ce:	1702                	slli	a4,a4,0x20
 5d0:	9301                	srli	a4,a4,0x20
 5d2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5d6:	fff94583          	lbu	a1,-1(s2)
 5da:	8526                	mv	a0,s1
 5dc:	f5bff0ef          	jal	536 <putc>
  while(--i >= 0)
 5e0:	197d                	addi	s2,s2,-1
 5e2:	ff391ae3          	bne	s2,s3,5d6 <printint+0x82>
 5e6:	7902                	ld	s2,32(sp)
 5e8:	69e2                	ld	s3,24(sp)
}
 5ea:	70e2                	ld	ra,56(sp)
 5ec:	7442                	ld	s0,48(sp)
 5ee:	74a2                	ld	s1,40(sp)
 5f0:	6121                	addi	sp,sp,64
 5f2:	8082                	ret
    x = -xx;
 5f4:	40b005bb          	negw	a1,a1
    neg = 1;
 5f8:	4885                	li	a7,1
    x = -xx;
 5fa:	bf85                	j	56a <printint+0x16>

00000000000005fc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5fc:	711d                	addi	sp,sp,-96
 5fe:	ec86                	sd	ra,88(sp)
 600:	e8a2                	sd	s0,80(sp)
 602:	e0ca                	sd	s2,64(sp)
 604:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 606:	0005c903          	lbu	s2,0(a1)
 60a:	26090863          	beqz	s2,87a <vprintf+0x27e>
 60e:	e4a6                	sd	s1,72(sp)
 610:	fc4e                	sd	s3,56(sp)
 612:	f852                	sd	s4,48(sp)
 614:	f456                	sd	s5,40(sp)
 616:	f05a                	sd	s6,32(sp)
 618:	ec5e                	sd	s7,24(sp)
 61a:	e862                	sd	s8,16(sp)
 61c:	e466                	sd	s9,8(sp)
 61e:	8b2a                	mv	s6,a0
 620:	8a2e                	mv	s4,a1
 622:	8bb2                	mv	s7,a2
  state = 0;
 624:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 626:	4481                	li	s1,0
 628:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 62a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 62e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 632:	06c00c93          	li	s9,108
 636:	a005                	j	656 <vprintf+0x5a>
        putc(fd, c0);
 638:	85ca                	mv	a1,s2
 63a:	855a                	mv	a0,s6
 63c:	efbff0ef          	jal	536 <putc>
 640:	a019                	j	646 <vprintf+0x4a>
    } else if(state == '%'){
 642:	03598263          	beq	s3,s5,666 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 646:	2485                	addiw	s1,s1,1
 648:	8726                	mv	a4,s1
 64a:	009a07b3          	add	a5,s4,s1
 64e:	0007c903          	lbu	s2,0(a5)
 652:	20090c63          	beqz	s2,86a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 656:	0009079b          	sext.w	a5,s2
    if(state == 0){
 65a:	fe0994e3          	bnez	s3,642 <vprintf+0x46>
      if(c0 == '%'){
 65e:	fd579de3          	bne	a5,s5,638 <vprintf+0x3c>
        state = '%';
 662:	89be                	mv	s3,a5
 664:	b7cd                	j	646 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 666:	00ea06b3          	add	a3,s4,a4
 66a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 66e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 670:	c681                	beqz	a3,678 <vprintf+0x7c>
 672:	9752                	add	a4,a4,s4
 674:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 678:	03878f63          	beq	a5,s8,6b6 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 67c:	05978963          	beq	a5,s9,6ce <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 680:	07500713          	li	a4,117
 684:	0ee78363          	beq	a5,a4,76a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 688:	07800713          	li	a4,120
 68c:	12e78563          	beq	a5,a4,7b6 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 690:	07000713          	li	a4,112
 694:	14e78a63          	beq	a5,a4,7e8 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 698:	07300713          	li	a4,115
 69c:	18e78a63          	beq	a5,a4,830 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6a0:	02500713          	li	a4,37
 6a4:	04e79563          	bne	a5,a4,6ee <vprintf+0xf2>
        putc(fd, '%');
 6a8:	02500593          	li	a1,37
 6ac:	855a                	mv	a0,s6
 6ae:	e89ff0ef          	jal	536 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	bf49                	j	646 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6b6:	008b8913          	addi	s2,s7,8
 6ba:	4685                	li	a3,1
 6bc:	4629                	li	a2,10
 6be:	000ba583          	lw	a1,0(s7)
 6c2:	855a                	mv	a0,s6
 6c4:	e91ff0ef          	jal	554 <printint>
 6c8:	8bca                	mv	s7,s2
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bfad                	j	646 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6ce:	06400793          	li	a5,100
 6d2:	02f68963          	beq	a3,a5,704 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6d6:	06c00793          	li	a5,108
 6da:	04f68263          	beq	a3,a5,71e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6de:	07500793          	li	a5,117
 6e2:	0af68063          	beq	a3,a5,782 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6e6:	07800793          	li	a5,120
 6ea:	0ef68263          	beq	a3,a5,7ce <vprintf+0x1d2>
        putc(fd, '%');
 6ee:	02500593          	li	a1,37
 6f2:	855a                	mv	a0,s6
 6f4:	e43ff0ef          	jal	536 <putc>
        putc(fd, c0);
 6f8:	85ca                	mv	a1,s2
 6fa:	855a                	mv	a0,s6
 6fc:	e3bff0ef          	jal	536 <putc>
      state = 0;
 700:	4981                	li	s3,0
 702:	b791                	j	646 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 704:	008b8913          	addi	s2,s7,8
 708:	4685                	li	a3,1
 70a:	4629                	li	a2,10
 70c:	000ba583          	lw	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	e43ff0ef          	jal	554 <printint>
        i += 1;
 716:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 718:	8bca                	mv	s7,s2
      state = 0;
 71a:	4981                	li	s3,0
        i += 1;
 71c:	b72d                	j	646 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 71e:	06400793          	li	a5,100
 722:	02f60763          	beq	a2,a5,750 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 726:	07500793          	li	a5,117
 72a:	06f60963          	beq	a2,a5,79c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 72e:	07800793          	li	a5,120
 732:	faf61ee3          	bne	a2,a5,6ee <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 736:	008b8913          	addi	s2,s7,8
 73a:	4681                	li	a3,0
 73c:	4641                	li	a2,16
 73e:	000ba583          	lw	a1,0(s7)
 742:	855a                	mv	a0,s6
 744:	e11ff0ef          	jal	554 <printint>
        i += 2;
 748:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 74a:	8bca                	mv	s7,s2
      state = 0;
 74c:	4981                	li	s3,0
        i += 2;
 74e:	bde5                	j	646 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 750:	008b8913          	addi	s2,s7,8
 754:	4685                	li	a3,1
 756:	4629                	li	a2,10
 758:	000ba583          	lw	a1,0(s7)
 75c:	855a                	mv	a0,s6
 75e:	df7ff0ef          	jal	554 <printint>
        i += 2;
 762:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 764:	8bca                	mv	s7,s2
      state = 0;
 766:	4981                	li	s3,0
        i += 2;
 768:	bdf9                	j	646 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 76a:	008b8913          	addi	s2,s7,8
 76e:	4681                	li	a3,0
 770:	4629                	li	a2,10
 772:	000ba583          	lw	a1,0(s7)
 776:	855a                	mv	a0,s6
 778:	dddff0ef          	jal	554 <printint>
 77c:	8bca                	mv	s7,s2
      state = 0;
 77e:	4981                	li	s3,0
 780:	b5d9                	j	646 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 782:	008b8913          	addi	s2,s7,8
 786:	4681                	li	a3,0
 788:	4629                	li	a2,10
 78a:	000ba583          	lw	a1,0(s7)
 78e:	855a                	mv	a0,s6
 790:	dc5ff0ef          	jal	554 <printint>
        i += 1;
 794:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 796:	8bca                	mv	s7,s2
      state = 0;
 798:	4981                	li	s3,0
        i += 1;
 79a:	b575                	j	646 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 79c:	008b8913          	addi	s2,s7,8
 7a0:	4681                	li	a3,0
 7a2:	4629                	li	a2,10
 7a4:	000ba583          	lw	a1,0(s7)
 7a8:	855a                	mv	a0,s6
 7aa:	dabff0ef          	jal	554 <printint>
        i += 2;
 7ae:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b0:	8bca                	mv	s7,s2
      state = 0;
 7b2:	4981                	li	s3,0
        i += 2;
 7b4:	bd49                	j	646 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7b6:	008b8913          	addi	s2,s7,8
 7ba:	4681                	li	a3,0
 7bc:	4641                	li	a2,16
 7be:	000ba583          	lw	a1,0(s7)
 7c2:	855a                	mv	a0,s6
 7c4:	d91ff0ef          	jal	554 <printint>
 7c8:	8bca                	mv	s7,s2
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	bdad                	j	646 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ce:	008b8913          	addi	s2,s7,8
 7d2:	4681                	li	a3,0
 7d4:	4641                	li	a2,16
 7d6:	000ba583          	lw	a1,0(s7)
 7da:	855a                	mv	a0,s6
 7dc:	d79ff0ef          	jal	554 <printint>
        i += 1;
 7e0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7e2:	8bca                	mv	s7,s2
      state = 0;
 7e4:	4981                	li	s3,0
        i += 1;
 7e6:	b585                	j	646 <vprintf+0x4a>
 7e8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7ea:	008b8d13          	addi	s10,s7,8
 7ee:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7f2:	03000593          	li	a1,48
 7f6:	855a                	mv	a0,s6
 7f8:	d3fff0ef          	jal	536 <putc>
  putc(fd, 'x');
 7fc:	07800593          	li	a1,120
 800:	855a                	mv	a0,s6
 802:	d35ff0ef          	jal	536 <putc>
 806:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 808:	00000b97          	auipc	s7,0x0
 80c:	3e0b8b93          	addi	s7,s7,992 # be8 <digits>
 810:	03c9d793          	srli	a5,s3,0x3c
 814:	97de                	add	a5,a5,s7
 816:	0007c583          	lbu	a1,0(a5)
 81a:	855a                	mv	a0,s6
 81c:	d1bff0ef          	jal	536 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 820:	0992                	slli	s3,s3,0x4
 822:	397d                	addiw	s2,s2,-1
 824:	fe0916e3          	bnez	s2,810 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 828:	8bea                	mv	s7,s10
      state = 0;
 82a:	4981                	li	s3,0
 82c:	6d02                	ld	s10,0(sp)
 82e:	bd21                	j	646 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 830:	008b8993          	addi	s3,s7,8
 834:	000bb903          	ld	s2,0(s7)
 838:	00090f63          	beqz	s2,856 <vprintf+0x25a>
        for(; *s; s++)
 83c:	00094583          	lbu	a1,0(s2)
 840:	c195                	beqz	a1,864 <vprintf+0x268>
          putc(fd, *s);
 842:	855a                	mv	a0,s6
 844:	cf3ff0ef          	jal	536 <putc>
        for(; *s; s++)
 848:	0905                	addi	s2,s2,1
 84a:	00094583          	lbu	a1,0(s2)
 84e:	f9f5                	bnez	a1,842 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 850:	8bce                	mv	s7,s3
      state = 0;
 852:	4981                	li	s3,0
 854:	bbcd                	j	646 <vprintf+0x4a>
          s = "(null)";
 856:	00000917          	auipc	s2,0x0
 85a:	38a90913          	addi	s2,s2,906 # be0 <malloc+0x27e>
        for(; *s; s++)
 85e:	02800593          	li	a1,40
 862:	b7c5                	j	842 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 864:	8bce                	mv	s7,s3
      state = 0;
 866:	4981                	li	s3,0
 868:	bbf9                	j	646 <vprintf+0x4a>
 86a:	64a6                	ld	s1,72(sp)
 86c:	79e2                	ld	s3,56(sp)
 86e:	7a42                	ld	s4,48(sp)
 870:	7aa2                	ld	s5,40(sp)
 872:	7b02                	ld	s6,32(sp)
 874:	6be2                	ld	s7,24(sp)
 876:	6c42                	ld	s8,16(sp)
 878:	6ca2                	ld	s9,8(sp)
    }
  }
}
 87a:	60e6                	ld	ra,88(sp)
 87c:	6446                	ld	s0,80(sp)
 87e:	6906                	ld	s2,64(sp)
 880:	6125                	addi	sp,sp,96
 882:	8082                	ret

0000000000000884 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 884:	715d                	addi	sp,sp,-80
 886:	ec06                	sd	ra,24(sp)
 888:	e822                	sd	s0,16(sp)
 88a:	1000                	addi	s0,sp,32
 88c:	e010                	sd	a2,0(s0)
 88e:	e414                	sd	a3,8(s0)
 890:	e818                	sd	a4,16(s0)
 892:	ec1c                	sd	a5,24(s0)
 894:	03043023          	sd	a6,32(s0)
 898:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 89c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8a0:	8622                	mv	a2,s0
 8a2:	d5bff0ef          	jal	5fc <vprintf>
}
 8a6:	60e2                	ld	ra,24(sp)
 8a8:	6442                	ld	s0,16(sp)
 8aa:	6161                	addi	sp,sp,80
 8ac:	8082                	ret

00000000000008ae <printf>:

void
printf(const char *fmt, ...)
{
 8ae:	711d                	addi	sp,sp,-96
 8b0:	ec06                	sd	ra,24(sp)
 8b2:	e822                	sd	s0,16(sp)
 8b4:	1000                	addi	s0,sp,32
 8b6:	e40c                	sd	a1,8(s0)
 8b8:	e810                	sd	a2,16(s0)
 8ba:	ec14                	sd	a3,24(s0)
 8bc:	f018                	sd	a4,32(s0)
 8be:	f41c                	sd	a5,40(s0)
 8c0:	03043823          	sd	a6,48(s0)
 8c4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8c8:	00840613          	addi	a2,s0,8
 8cc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8d0:	85aa                	mv	a1,a0
 8d2:	4505                	li	a0,1
 8d4:	d29ff0ef          	jal	5fc <vprintf>
}
 8d8:	60e2                	ld	ra,24(sp)
 8da:	6442                	ld	s0,16(sp)
 8dc:	6125                	addi	sp,sp,96
 8de:	8082                	ret

00000000000008e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e0:	1141                	addi	sp,sp,-16
 8e2:	e422                	sd	s0,8(sp)
 8e4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8e6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ea:	00000797          	auipc	a5,0x0
 8ee:	7167b783          	ld	a5,1814(a5) # 1000 <freep>
 8f2:	a02d                	j	91c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8f4:	4618                	lw	a4,8(a2)
 8f6:	9f2d                	addw	a4,a4,a1
 8f8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8fc:	6398                	ld	a4,0(a5)
 8fe:	6310                	ld	a2,0(a4)
 900:	a83d                	j	93e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 902:	ff852703          	lw	a4,-8(a0)
 906:	9f31                	addw	a4,a4,a2
 908:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 90a:	ff053683          	ld	a3,-16(a0)
 90e:	a091                	j	952 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 910:	6398                	ld	a4,0(a5)
 912:	00e7e463          	bltu	a5,a4,91a <free+0x3a>
 916:	00e6ea63          	bltu	a3,a4,92a <free+0x4a>
{
 91a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91c:	fed7fae3          	bgeu	a5,a3,910 <free+0x30>
 920:	6398                	ld	a4,0(a5)
 922:	00e6e463          	bltu	a3,a4,92a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 926:	fee7eae3          	bltu	a5,a4,91a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 92a:	ff852583          	lw	a1,-8(a0)
 92e:	6390                	ld	a2,0(a5)
 930:	02059813          	slli	a6,a1,0x20
 934:	01c85713          	srli	a4,a6,0x1c
 938:	9736                	add	a4,a4,a3
 93a:	fae60de3          	beq	a2,a4,8f4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 93e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 942:	4790                	lw	a2,8(a5)
 944:	02061593          	slli	a1,a2,0x20
 948:	01c5d713          	srli	a4,a1,0x1c
 94c:	973e                	add	a4,a4,a5
 94e:	fae68ae3          	beq	a3,a4,902 <free+0x22>
    p->s.ptr = bp->s.ptr;
 952:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 954:	00000717          	auipc	a4,0x0
 958:	6af73623          	sd	a5,1708(a4) # 1000 <freep>
}
 95c:	6422                	ld	s0,8(sp)
 95e:	0141                	addi	sp,sp,16
 960:	8082                	ret

0000000000000962 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 962:	7139                	addi	sp,sp,-64
 964:	fc06                	sd	ra,56(sp)
 966:	f822                	sd	s0,48(sp)
 968:	f426                	sd	s1,40(sp)
 96a:	ec4e                	sd	s3,24(sp)
 96c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 96e:	02051493          	slli	s1,a0,0x20
 972:	9081                	srli	s1,s1,0x20
 974:	04bd                	addi	s1,s1,15
 976:	8091                	srli	s1,s1,0x4
 978:	0014899b          	addiw	s3,s1,1
 97c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 97e:	00000517          	auipc	a0,0x0
 982:	68253503          	ld	a0,1666(a0) # 1000 <freep>
 986:	c915                	beqz	a0,9ba <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 988:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 98a:	4798                	lw	a4,8(a5)
 98c:	08977a63          	bgeu	a4,s1,a20 <malloc+0xbe>
 990:	f04a                	sd	s2,32(sp)
 992:	e852                	sd	s4,16(sp)
 994:	e456                	sd	s5,8(sp)
 996:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 998:	8a4e                	mv	s4,s3
 99a:	0009871b          	sext.w	a4,s3
 99e:	6685                	lui	a3,0x1
 9a0:	00d77363          	bgeu	a4,a3,9a6 <malloc+0x44>
 9a4:	6a05                	lui	s4,0x1
 9a6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9aa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9ae:	00000917          	auipc	s2,0x0
 9b2:	65290913          	addi	s2,s2,1618 # 1000 <freep>
  if(p == (char*)-1)
 9b6:	5afd                	li	s5,-1
 9b8:	a081                	j	9f8 <malloc+0x96>
 9ba:	f04a                	sd	s2,32(sp)
 9bc:	e852                	sd	s4,16(sp)
 9be:	e456                	sd	s5,8(sp)
 9c0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9c2:	00000797          	auipc	a5,0x0
 9c6:	64e78793          	addi	a5,a5,1614 # 1010 <base>
 9ca:	00000717          	auipc	a4,0x0
 9ce:	62f73b23          	sd	a5,1590(a4) # 1000 <freep>
 9d2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9d4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9d8:	b7c1                	j	998 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9da:	6398                	ld	a4,0(a5)
 9dc:	e118                	sd	a4,0(a0)
 9de:	a8a9                	j	a38 <malloc+0xd6>
  hp->s.size = nu;
 9e0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9e4:	0541                	addi	a0,a0,16
 9e6:	efbff0ef          	jal	8e0 <free>
  return freep;
 9ea:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9ee:	c12d                	beqz	a0,a50 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f2:	4798                	lw	a4,8(a5)
 9f4:	02977263          	bgeu	a4,s1,a18 <malloc+0xb6>
    if(p == freep)
 9f8:	00093703          	ld	a4,0(s2)
 9fc:	853e                	mv	a0,a5
 9fe:	fef719e3          	bne	a4,a5,9f0 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a02:	8552                	mv	a0,s4
 a04:	ad3ff0ef          	jal	4d6 <sbrk>
  if(p == (char*)-1)
 a08:	fd551ce3          	bne	a0,s5,9e0 <malloc+0x7e>
        return 0;
 a0c:	4501                	li	a0,0
 a0e:	7902                	ld	s2,32(sp)
 a10:	6a42                	ld	s4,16(sp)
 a12:	6aa2                	ld	s5,8(sp)
 a14:	6b02                	ld	s6,0(sp)
 a16:	a03d                	j	a44 <malloc+0xe2>
 a18:	7902                	ld	s2,32(sp)
 a1a:	6a42                	ld	s4,16(sp)
 a1c:	6aa2                	ld	s5,8(sp)
 a1e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a20:	fae48de3          	beq	s1,a4,9da <malloc+0x78>
        p->s.size -= nunits;
 a24:	4137073b          	subw	a4,a4,s3
 a28:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a2a:	02071693          	slli	a3,a4,0x20
 a2e:	01c6d713          	srli	a4,a3,0x1c
 a32:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a34:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a38:	00000717          	auipc	a4,0x0
 a3c:	5ca73423          	sd	a0,1480(a4) # 1000 <freep>
      return (void*)(p + 1);
 a40:	01078513          	addi	a0,a5,16
  }
}
 a44:	70e2                	ld	ra,56(sp)
 a46:	7442                	ld	s0,48(sp)
 a48:	74a2                	ld	s1,40(sp)
 a4a:	69e2                	ld	s3,24(sp)
 a4c:	6121                	addi	sp,sp,64
 a4e:	8082                	ret
 a50:	7902                	ld	s2,32(sp)
 a52:	6a42                	ld	s4,16(sp)
 a54:	6aa2                	ld	s5,8(sp)
 a56:	6b02                	ld	s6,0(sp)
 a58:	b7f5                	j	a44 <malloc+0xe2>
