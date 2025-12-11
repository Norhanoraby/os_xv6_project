
user/_schedtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"
#include "kernel/fcntl.h"
#define SCHED_FCFS 1


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
  int k, nprocess = 10;
  int z, steps = 1000000;
  char buffer_src[1024], buffer_dst[1024];
  int status, tt, wt;
  int total_tt = 0, total_wt = 0;
  if (set_sched(SCHED_FCFS) < 0) {
  18:	4505                	li	a0,1
  1a:	4b2000ef          	jal	4cc <set_sched>
  1e:	06054d63          	bltz	a0,98 <main+0x98>
       printf("Error setting scheduler\n");
       exit(1);
  }
  printf("Scheduler set to FCFS. Creating 10 processes...\n");
  22:	00001517          	auipc	a0,0x1
  26:	9fe50513          	addi	a0,a0,-1538 # a20 <malloc+0x118>
  2a:	02b000ef          	jal	854 <printf>
  2e:	44a9                	li	s1,10


  for (k = 0; k < nprocess; k++) {
    // ensure different creation times (proc->ctime)
    // needed for properly testing FCFS scheduling
    sleep(2);
  30:	4509                	li	a0,2
  32:	452000ef          	jal	484 <sleep>

    pid = fork();
  36:	3b6000ef          	jal	3ec <fork>
    if (pid < 0) {
  3a:	06054863          	bltz	a0,aa <main+0xaa>
      printf("%d failed in fork!\n", getpid());
      exit(0);

    }
    else if (pid == 0) {
  3e:	c151                	beqz	a0,c2 <main+0xc2>
  for (k = 0; k < nprocess; k++) {
  40:	34fd                	addiw	s1,s1,-1
  42:	f4fd                	bnez	s1,30 <main+0x30>
  44:	44a9                	li	s1,10
  int total_tt = 0, total_wt = 0;
  46:	4981                	li	s3,0
  48:	4a01                	li	s4,0
      exit(0);
    }
  }

    for (k = 0; k < nprocess; k++) {
        pid = wait_sched(&status, &tt, &wt);
  4a:	77fd                	lui	a5,0xfffff
  4c:	7b478793          	addi	a5,a5,1972 # fffffffffffff7b4 <base+0xffffffffffffe7a4>
  50:	97a2                	add	a5,a5,s0
  52:	777d                	lui	a4,0xfffff
  54:	7a870693          	addi	a3,a4,1960 # fffffffffffff7a8 <base+0xffffffffffffe798>
  58:	96a2                	add	a3,a3,s0
  5a:	e29c                	sd	a5,0(a3)
  5c:	77fd                	lui	a5,0xfffff
  5e:	7b878793          	addi	a5,a5,1976 # fffffffffffff7b8 <base+0xffffffffffffe7a8>
  62:	97a2                	add	a5,a5,s0
  64:	7a070693          	addi	a3,a4,1952
  68:	96a2                	add	a3,a3,s0
  6a:	e29c                	sd	a5,0(a3)
  6c:	77fd                	lui	a5,0xfffff
  6e:	7bc78793          	addi	a5,a5,1980 # fffffffffffff7bc <base+0xffffffffffffe7ac>
  72:	97a2                	add	a5,a5,s0
  74:	79870713          	addi	a4,a4,1944
  78:	9722                	add	a4,a4,s0
  7a:	e31c                	sd	a5,0(a4)
            printf("[pid=%d] terminated. turnaround=%d, wait=%d\n", pid, tt, wt);
            // Sum them up for the average calculation
            total_tt += tt;
            total_wt += wt;
        } else {
            printf("Error in wait_sched\n");
  7c:	00001b17          	auipc	s6,0x1
  80:	a3cb0b13          	addi	s6,s6,-1476 # ab8 <malloc+0x1b0>
            printf("[pid=%d] terminated. turnaround=%d, wait=%d\n", pid, tt, wt);
  84:	797d                	lui	s2,0xfffff
  86:	fc090793          	addi	a5,s2,-64 # ffffffffffffefc0 <base+0xffffffffffffdfb0>
  8a:	00878933          	add	s2,a5,s0
  8e:	00001a97          	auipc	s5,0x1
  92:	9faa8a93          	addi	s5,s5,-1542 # a88 <malloc+0x180>
  96:	a041                	j	116 <main+0x116>
       printf("Error setting scheduler\n");
  98:	00001517          	auipc	a0,0x1
  9c:	96850513          	addi	a0,a0,-1688 # a00 <malloc+0xf8>
  a0:	7b4000ef          	jal	854 <printf>
       exit(1);
  a4:	4505                	li	a0,1
  a6:	34e000ef          	jal	3f4 <exit>
      printf("%d failed in fork!\n", getpid());
  aa:	3ca000ef          	jal	474 <getpid>
  ae:	85aa                	mv	a1,a0
  b0:	00001517          	auipc	a0,0x1
  b4:	9a850513          	addi	a0,a0,-1624 # a58 <malloc+0x150>
  b8:	79c000ef          	jal	854 <printf>
      exit(0);
  bc:	4501                	li	a0,0
  be:	336000ef          	jal	3f4 <exit>
      printf("[pid=%d] created\n", getpid());
  c2:	3b2000ef          	jal	474 <getpid>
  c6:	85aa                	mv	a1,a0
  c8:	00001517          	auipc	a0,0x1
  cc:	9a850513          	addi	a0,a0,-1624 # a70 <malloc+0x168>
  d0:	784000ef          	jal	854 <printf>
  d4:	000f44b7          	lui	s1,0xf4
  d8:	24048493          	addi	s1,s1,576 # f4240 <base+0xf3230>
         memmove(buffer_dst, buffer_src, 1024);
  dc:	40000613          	li	a2,1024
  e0:	bc040593          	addi	a1,s0,-1088
  e4:	797d                	lui	s2,0xfffff
  e6:	7c090513          	addi	a0,s2,1984 # fffffffffffff7c0 <base+0xffffffffffffe7b0>
  ea:	9522                	add	a0,a0,s0
  ec:	25a000ef          	jal	346 <memmove>
         memmove(buffer_src, buffer_dst, 1024);
  f0:	40000613          	li	a2,1024
  f4:	7c090593          	addi	a1,s2,1984
  f8:	95a2                	add	a1,a1,s0
  fa:	bc040513          	addi	a0,s0,-1088
  fe:	248000ef          	jal	346 <memmove>
      for (z = 0; z < steps; z += 1) {
 102:	34fd                	addiw	s1,s1,-1
 104:	fce1                	bnez	s1,dc <main+0xdc>
      exit(0);
 106:	4501                	li	a0,0
 108:	2ec000ef          	jal	3f4 <exit>
            printf("Error in wait_sched\n");
 10c:	855a                	mv	a0,s6
 10e:	746000ef          	jal	854 <printf>
    for (k = 0; k < nprocess; k++) {
 112:	34fd                	addiw	s1,s1,-1
 114:	c0b9                	beqz	s1,15a <main+0x15a>
        pid = wait_sched(&status, &tt, &wt);
 116:	77fd                	lui	a5,0xfffff
 118:	7a878713          	addi	a4,a5,1960 # fffffffffffff7a8 <base+0xffffffffffffe798>
 11c:	9722                	add	a4,a4,s0
 11e:	6310                	ld	a2,0(a4)
 120:	7a078713          	addi	a4,a5,1952
 124:	9722                	add	a4,a4,s0
 126:	630c                	ld	a1,0(a4)
 128:	79878793          	addi	a5,a5,1944
 12c:	97a2                	add	a5,a5,s0
 12e:	6388                	ld	a0,0(a5)
 130:	3a4000ef          	jal	4d4 <wait_sched>
 134:	85aa                	mv	a1,a0
        if(pid > 0) {
 136:	fca05be3          	blez	a0,10c <main+0x10c>
            printf("[pid=%d] terminated. turnaround=%d, wait=%d\n", pid, tt, wt);
 13a:	7f492683          	lw	a3,2036(s2)
 13e:	7f892603          	lw	a2,2040(s2)
 142:	8556                	mv	a0,s5
 144:	710000ef          	jal	854 <printf>
            total_tt += tt;
 148:	7f892783          	lw	a5,2040(s2)
 14c:	01478a3b          	addw	s4,a5,s4
            total_wt += wt;
 150:	7f492783          	lw	a5,2036(s2)
 154:	013789bb          	addw	s3,a5,s3
 158:	bf6d                	j	112 <main+0x112>
        }
    }
    
    // Calculate and Print Averages
    printf("Avg turnaround time:%d.%d\n", total_tt / nprocess, 
 15a:	44a9                	li	s1,10
 15c:	029a663b          	remw	a2,s4,s1
 160:	029a45bb          	divw	a1,s4,s1
 164:	00001517          	auipc	a0,0x1
 168:	96c50513          	addi	a0,a0,-1684 # ad0 <malloc+0x1c8>
 16c:	6e8000ef          	jal	854 <printf>
           (total_tt * 10 / nprocess) % 10);
    printf("Avg wait time:%d.%d\n", total_wt / nprocess,
 170:	0299e63b          	remw	a2,s3,s1
 174:	0299c5bb          	divw	a1,s3,s1
 178:	00001517          	auipc	a0,0x1
 17c:	97850513          	addi	a0,a0,-1672 # af0 <malloc+0x1e8>
 180:	6d4000ef          	jal	854 <printf>
           (total_wt * 10 / nprocess) % 10);
    
    exit(0);
 184:	4501                	li	a0,0
 186:	26e000ef          	jal	3f4 <exit>

000000000000018a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e406                	sd	ra,8(sp)
 18e:	e022                	sd	s0,0(sp)
 190:	0800                	addi	s0,sp,16
  extern int main();
  main();
 192:	e6fff0ef          	jal	0 <main>
  exit(0);
 196:	4501                	li	a0,0
 198:	25c000ef          	jal	3f4 <exit>

000000000000019c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1a2:	87aa                	mv	a5,a0
 1a4:	0585                	addi	a1,a1,1
 1a6:	0785                	addi	a5,a5,1
 1a8:	fff5c703          	lbu	a4,-1(a1)
 1ac:	fee78fa3          	sb	a4,-1(a5)
 1b0:	fb75                	bnez	a4,1a4 <strcpy+0x8>
    ;
  return os;
}
 1b2:	6422                	ld	s0,8(sp)
 1b4:	0141                	addi	sp,sp,16
 1b6:	8082                	ret

00000000000001b8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e422                	sd	s0,8(sp)
 1bc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	cb91                	beqz	a5,1d6 <strcmp+0x1e>
 1c4:	0005c703          	lbu	a4,0(a1)
 1c8:	00f71763          	bne	a4,a5,1d6 <strcmp+0x1e>
    p++, q++;
 1cc:	0505                	addi	a0,a0,1
 1ce:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1d0:	00054783          	lbu	a5,0(a0)
 1d4:	fbe5                	bnez	a5,1c4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1d6:	0005c503          	lbu	a0,0(a1)
}
 1da:	40a7853b          	subw	a0,a5,a0
 1de:	6422                	ld	s0,8(sp)
 1e0:	0141                	addi	sp,sp,16
 1e2:	8082                	ret

00000000000001e4 <strlen>:

uint
strlen(const char *s)
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e422                	sd	s0,8(sp)
 1e8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1ea:	00054783          	lbu	a5,0(a0)
 1ee:	cf91                	beqz	a5,20a <strlen+0x26>
 1f0:	0505                	addi	a0,a0,1
 1f2:	87aa                	mv	a5,a0
 1f4:	86be                	mv	a3,a5
 1f6:	0785                	addi	a5,a5,1
 1f8:	fff7c703          	lbu	a4,-1(a5)
 1fc:	ff65                	bnez	a4,1f4 <strlen+0x10>
 1fe:	40a6853b          	subw	a0,a3,a0
 202:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 204:	6422                	ld	s0,8(sp)
 206:	0141                	addi	sp,sp,16
 208:	8082                	ret
  for(n = 0; s[n]; n++)
 20a:	4501                	li	a0,0
 20c:	bfe5                	j	204 <strlen+0x20>

000000000000020e <memset>:

void*
memset(void *dst, int c, uint n)
{
 20e:	1141                	addi	sp,sp,-16
 210:	e422                	sd	s0,8(sp)
 212:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 214:	ca19                	beqz	a2,22a <memset+0x1c>
 216:	87aa                	mv	a5,a0
 218:	1602                	slli	a2,a2,0x20
 21a:	9201                	srli	a2,a2,0x20
 21c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 220:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 224:	0785                	addi	a5,a5,1
 226:	fee79de3          	bne	a5,a4,220 <memset+0x12>
  }
  return dst;
}
 22a:	6422                	ld	s0,8(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret

0000000000000230 <strchr>:

char*
strchr(const char *s, char c)
{
 230:	1141                	addi	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	addi	s0,sp,16
  for(; *s; s++)
 236:	00054783          	lbu	a5,0(a0)
 23a:	cb99                	beqz	a5,250 <strchr+0x20>
    if(*s == c)
 23c:	00f58763          	beq	a1,a5,24a <strchr+0x1a>
  for(; *s; s++)
 240:	0505                	addi	a0,a0,1
 242:	00054783          	lbu	a5,0(a0)
 246:	fbfd                	bnez	a5,23c <strchr+0xc>
      return (char*)s;
  return 0;
 248:	4501                	li	a0,0
}
 24a:	6422                	ld	s0,8(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret
  return 0;
 250:	4501                	li	a0,0
 252:	bfe5                	j	24a <strchr+0x1a>

0000000000000254 <gets>:

char*
gets(char *buf, int max)
{
 254:	711d                	addi	sp,sp,-96
 256:	ec86                	sd	ra,88(sp)
 258:	e8a2                	sd	s0,80(sp)
 25a:	e4a6                	sd	s1,72(sp)
 25c:	e0ca                	sd	s2,64(sp)
 25e:	fc4e                	sd	s3,56(sp)
 260:	f852                	sd	s4,48(sp)
 262:	f456                	sd	s5,40(sp)
 264:	f05a                	sd	s6,32(sp)
 266:	ec5e                	sd	s7,24(sp)
 268:	1080                	addi	s0,sp,96
 26a:	8baa                	mv	s7,a0
 26c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26e:	892a                	mv	s2,a0
 270:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 272:	4aa9                	li	s5,10
 274:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 276:	89a6                	mv	s3,s1
 278:	2485                	addiw	s1,s1,1
 27a:	0344d663          	bge	s1,s4,2a6 <gets+0x52>
    cc = read(0, &c, 1);
 27e:	4605                	li	a2,1
 280:	faf40593          	addi	a1,s0,-81
 284:	4501                	li	a0,0
 286:	186000ef          	jal	40c <read>
    if(cc < 1)
 28a:	00a05e63          	blez	a0,2a6 <gets+0x52>
    buf[i++] = c;
 28e:	faf44783          	lbu	a5,-81(s0)
 292:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 296:	01578763          	beq	a5,s5,2a4 <gets+0x50>
 29a:	0905                	addi	s2,s2,1
 29c:	fd679de3          	bne	a5,s6,276 <gets+0x22>
    buf[i++] = c;
 2a0:	89a6                	mv	s3,s1
 2a2:	a011                	j	2a6 <gets+0x52>
 2a4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2a6:	99de                	add	s3,s3,s7
 2a8:	00098023          	sb	zero,0(s3)
  return buf;
}
 2ac:	855e                	mv	a0,s7
 2ae:	60e6                	ld	ra,88(sp)
 2b0:	6446                	ld	s0,80(sp)
 2b2:	64a6                	ld	s1,72(sp)
 2b4:	6906                	ld	s2,64(sp)
 2b6:	79e2                	ld	s3,56(sp)
 2b8:	7a42                	ld	s4,48(sp)
 2ba:	7aa2                	ld	s5,40(sp)
 2bc:	7b02                	ld	s6,32(sp)
 2be:	6be2                	ld	s7,24(sp)
 2c0:	6125                	addi	sp,sp,96
 2c2:	8082                	ret

00000000000002c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c4:	1101                	addi	sp,sp,-32
 2c6:	ec06                	sd	ra,24(sp)
 2c8:	e822                	sd	s0,16(sp)
 2ca:	e04a                	sd	s2,0(sp)
 2cc:	1000                	addi	s0,sp,32
 2ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d0:	4581                	li	a1,0
 2d2:	162000ef          	jal	434 <open>
  if(fd < 0)
 2d6:	02054263          	bltz	a0,2fa <stat+0x36>
 2da:	e426                	sd	s1,8(sp)
 2dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2de:	85ca                	mv	a1,s2
 2e0:	16c000ef          	jal	44c <fstat>
 2e4:	892a                	mv	s2,a0
  close(fd);
 2e6:	8526                	mv	a0,s1
 2e8:	134000ef          	jal	41c <close>
  return r;
 2ec:	64a2                	ld	s1,8(sp)
}
 2ee:	854a                	mv	a0,s2
 2f0:	60e2                	ld	ra,24(sp)
 2f2:	6442                	ld	s0,16(sp)
 2f4:	6902                	ld	s2,0(sp)
 2f6:	6105                	addi	sp,sp,32
 2f8:	8082                	ret
    return -1;
 2fa:	597d                	li	s2,-1
 2fc:	bfcd                	j	2ee <stat+0x2a>

00000000000002fe <atoi>:

int
atoi(const char *s)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e422                	sd	s0,8(sp)
 302:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 304:	00054683          	lbu	a3,0(a0)
 308:	fd06879b          	addiw	a5,a3,-48
 30c:	0ff7f793          	zext.b	a5,a5
 310:	4625                	li	a2,9
 312:	02f66863          	bltu	a2,a5,342 <atoi+0x44>
 316:	872a                	mv	a4,a0
  n = 0;
 318:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 31a:	0705                	addi	a4,a4,1
 31c:	0025179b          	slliw	a5,a0,0x2
 320:	9fa9                	addw	a5,a5,a0
 322:	0017979b          	slliw	a5,a5,0x1
 326:	9fb5                	addw	a5,a5,a3
 328:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 32c:	00074683          	lbu	a3,0(a4)
 330:	fd06879b          	addiw	a5,a3,-48
 334:	0ff7f793          	zext.b	a5,a5
 338:	fef671e3          	bgeu	a2,a5,31a <atoi+0x1c>
  return n;
}
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
  n = 0;
 342:	4501                	li	a0,0
 344:	bfe5                	j	33c <atoi+0x3e>

0000000000000346 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 346:	1141                	addi	sp,sp,-16
 348:	e422                	sd	s0,8(sp)
 34a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 34c:	02b57463          	bgeu	a0,a1,374 <memmove+0x2e>
    while(n-- > 0)
 350:	00c05f63          	blez	a2,36e <memmove+0x28>
 354:	1602                	slli	a2,a2,0x20
 356:	9201                	srli	a2,a2,0x20
 358:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 35c:	872a                	mv	a4,a0
      *dst++ = *src++;
 35e:	0585                	addi	a1,a1,1
 360:	0705                	addi	a4,a4,1
 362:	fff5c683          	lbu	a3,-1(a1)
 366:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 36a:	fef71ae3          	bne	a4,a5,35e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 36e:	6422                	ld	s0,8(sp)
 370:	0141                	addi	sp,sp,16
 372:	8082                	ret
    dst += n;
 374:	00c50733          	add	a4,a0,a2
    src += n;
 378:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 37a:	fec05ae3          	blez	a2,36e <memmove+0x28>
 37e:	fff6079b          	addiw	a5,a2,-1
 382:	1782                	slli	a5,a5,0x20
 384:	9381                	srli	a5,a5,0x20
 386:	fff7c793          	not	a5,a5
 38a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 38c:	15fd                	addi	a1,a1,-1
 38e:	177d                	addi	a4,a4,-1
 390:	0005c683          	lbu	a3,0(a1)
 394:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 398:	fee79ae3          	bne	a5,a4,38c <memmove+0x46>
 39c:	bfc9                	j	36e <memmove+0x28>

000000000000039e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 39e:	1141                	addi	sp,sp,-16
 3a0:	e422                	sd	s0,8(sp)
 3a2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a4:	ca05                	beqz	a2,3d4 <memcmp+0x36>
 3a6:	fff6069b          	addiw	a3,a2,-1
 3aa:	1682                	slli	a3,a3,0x20
 3ac:	9281                	srli	a3,a3,0x20
 3ae:	0685                	addi	a3,a3,1
 3b0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3b2:	00054783          	lbu	a5,0(a0)
 3b6:	0005c703          	lbu	a4,0(a1)
 3ba:	00e79863          	bne	a5,a4,3ca <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3be:	0505                	addi	a0,a0,1
    p2++;
 3c0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3c2:	fed518e3          	bne	a0,a3,3b2 <memcmp+0x14>
  }
  return 0;
 3c6:	4501                	li	a0,0
 3c8:	a019                	j	3ce <memcmp+0x30>
      return *p1 - *p2;
 3ca:	40e7853b          	subw	a0,a5,a4
}
 3ce:	6422                	ld	s0,8(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret
  return 0;
 3d4:	4501                	li	a0,0
 3d6:	bfe5                	j	3ce <memcmp+0x30>

00000000000003d8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3d8:	1141                	addi	sp,sp,-16
 3da:	e406                	sd	ra,8(sp)
 3dc:	e022                	sd	s0,0(sp)
 3de:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3e0:	f67ff0ef          	jal	346 <memmove>
}
 3e4:	60a2                	ld	ra,8(sp)
 3e6:	6402                	ld	s0,0(sp)
 3e8:	0141                	addi	sp,sp,16
 3ea:	8082                	ret

00000000000003ec <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ec:	4885                	li	a7,1
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3f4:	4889                	li	a7,2
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <wait>:
.global wait
wait:
 li a7, SYS_wait
 3fc:	488d                	li	a7,3
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 404:	4891                	li	a7,4
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <read>:
.global read
read:
 li a7, SYS_read
 40c:	4895                	li	a7,5
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <write>:
.global write
write:
 li a7, SYS_write
 414:	48c1                	li	a7,16
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <close>:
.global close
close:
 li a7, SYS_close
 41c:	48d5                	li	a7,21
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <kill>:
.global kill
kill:
 li a7, SYS_kill
 424:	4899                	li	a7,6
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <exec>:
.global exec
exec:
 li a7, SYS_exec
 42c:	489d                	li	a7,7
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <open>:
.global open
open:
 li a7, SYS_open
 434:	48bd                	li	a7,15
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 43c:	48c5                	li	a7,17
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 444:	48c9                	li	a7,18
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 44c:	48a1                	li	a7,8
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <link>:
.global link
link:
 li a7, SYS_link
 454:	48cd                	li	a7,19
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 45c:	48d1                	li	a7,20
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 464:	48a5                	li	a7,9
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <dup>:
.global dup
dup:
 li a7, SYS_dup
 46c:	48a9                	li	a7,10
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 474:	48ad                	li	a7,11
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 47c:	48b1                	li	a7,12
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 484:	48b5                	li	a7,13
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 48c:	48b9                	li	a7,14
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 494:	48d9                	li	a7,22
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 49c:	48dd                	li	a7,23
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 4a4:	48e1                	li	a7,24
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 4ac:	48e5                	li	a7,25
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <random>:
.global random
random:
 li a7, SYS_random
 4b4:	48e9                	li	a7,26
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 4bc:	48ed                	li	a7,27
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 4c4:	48f1                	li	a7,28
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <set_sched>:
.global set_sched
set_sched:
 li a7, SYS_set_sched
 4cc:	48f5                	li	a7,29
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <wait_sched>:
.global wait_sched
wait_sched:
 li a7, SYS_wait_sched
 4d4:	48f9                	li	a7,30
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4dc:	1101                	addi	sp,sp,-32
 4de:	ec06                	sd	ra,24(sp)
 4e0:	e822                	sd	s0,16(sp)
 4e2:	1000                	addi	s0,sp,32
 4e4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4e8:	4605                	li	a2,1
 4ea:	fef40593          	addi	a1,s0,-17
 4ee:	f27ff0ef          	jal	414 <write>
}
 4f2:	60e2                	ld	ra,24(sp)
 4f4:	6442                	ld	s0,16(sp)
 4f6:	6105                	addi	sp,sp,32
 4f8:	8082                	ret

00000000000004fa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4fa:	7139                	addi	sp,sp,-64
 4fc:	fc06                	sd	ra,56(sp)
 4fe:	f822                	sd	s0,48(sp)
 500:	f426                	sd	s1,40(sp)
 502:	0080                	addi	s0,sp,64
 504:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 506:	c299                	beqz	a3,50c <printint+0x12>
 508:	0805c963          	bltz	a1,59a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 50c:	2581                	sext.w	a1,a1
  neg = 0;
 50e:	4881                	li	a7,0
 510:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 514:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 516:	2601                	sext.w	a2,a2
 518:	00000517          	auipc	a0,0x0
 51c:	5f850513          	addi	a0,a0,1528 # b10 <digits>
 520:	883a                	mv	a6,a4
 522:	2705                	addiw	a4,a4,1
 524:	02c5f7bb          	remuw	a5,a1,a2
 528:	1782                	slli	a5,a5,0x20
 52a:	9381                	srli	a5,a5,0x20
 52c:	97aa                	add	a5,a5,a0
 52e:	0007c783          	lbu	a5,0(a5)
 532:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 536:	0005879b          	sext.w	a5,a1
 53a:	02c5d5bb          	divuw	a1,a1,a2
 53e:	0685                	addi	a3,a3,1
 540:	fec7f0e3          	bgeu	a5,a2,520 <printint+0x26>
  if(neg)
 544:	00088c63          	beqz	a7,55c <printint+0x62>
    buf[i++] = '-';
 548:	fd070793          	addi	a5,a4,-48
 54c:	00878733          	add	a4,a5,s0
 550:	02d00793          	li	a5,45
 554:	fef70823          	sb	a5,-16(a4)
 558:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 55c:	02e05a63          	blez	a4,590 <printint+0x96>
 560:	f04a                	sd	s2,32(sp)
 562:	ec4e                	sd	s3,24(sp)
 564:	fc040793          	addi	a5,s0,-64
 568:	00e78933          	add	s2,a5,a4
 56c:	fff78993          	addi	s3,a5,-1
 570:	99ba                	add	s3,s3,a4
 572:	377d                	addiw	a4,a4,-1
 574:	1702                	slli	a4,a4,0x20
 576:	9301                	srli	a4,a4,0x20
 578:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 57c:	fff94583          	lbu	a1,-1(s2)
 580:	8526                	mv	a0,s1
 582:	f5bff0ef          	jal	4dc <putc>
  while(--i >= 0)
 586:	197d                	addi	s2,s2,-1
 588:	ff391ae3          	bne	s2,s3,57c <printint+0x82>
 58c:	7902                	ld	s2,32(sp)
 58e:	69e2                	ld	s3,24(sp)
}
 590:	70e2                	ld	ra,56(sp)
 592:	7442                	ld	s0,48(sp)
 594:	74a2                	ld	s1,40(sp)
 596:	6121                	addi	sp,sp,64
 598:	8082                	ret
    x = -xx;
 59a:	40b005bb          	negw	a1,a1
    neg = 1;
 59e:	4885                	li	a7,1
    x = -xx;
 5a0:	bf85                	j	510 <printint+0x16>

00000000000005a2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5a2:	711d                	addi	sp,sp,-96
 5a4:	ec86                	sd	ra,88(sp)
 5a6:	e8a2                	sd	s0,80(sp)
 5a8:	e0ca                	sd	s2,64(sp)
 5aa:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5ac:	0005c903          	lbu	s2,0(a1)
 5b0:	26090863          	beqz	s2,820 <vprintf+0x27e>
 5b4:	e4a6                	sd	s1,72(sp)
 5b6:	fc4e                	sd	s3,56(sp)
 5b8:	f852                	sd	s4,48(sp)
 5ba:	f456                	sd	s5,40(sp)
 5bc:	f05a                	sd	s6,32(sp)
 5be:	ec5e                	sd	s7,24(sp)
 5c0:	e862                	sd	s8,16(sp)
 5c2:	e466                	sd	s9,8(sp)
 5c4:	8b2a                	mv	s6,a0
 5c6:	8a2e                	mv	s4,a1
 5c8:	8bb2                	mv	s7,a2
  state = 0;
 5ca:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5cc:	4481                	li	s1,0
 5ce:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5d0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5d4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5d8:	06c00c93          	li	s9,108
 5dc:	a005                	j	5fc <vprintf+0x5a>
        putc(fd, c0);
 5de:	85ca                	mv	a1,s2
 5e0:	855a                	mv	a0,s6
 5e2:	efbff0ef          	jal	4dc <putc>
 5e6:	a019                	j	5ec <vprintf+0x4a>
    } else if(state == '%'){
 5e8:	03598263          	beq	s3,s5,60c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5ec:	2485                	addiw	s1,s1,1
 5ee:	8726                	mv	a4,s1
 5f0:	009a07b3          	add	a5,s4,s1
 5f4:	0007c903          	lbu	s2,0(a5)
 5f8:	20090c63          	beqz	s2,810 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 5fc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 600:	fe0994e3          	bnez	s3,5e8 <vprintf+0x46>
      if(c0 == '%'){
 604:	fd579de3          	bne	a5,s5,5de <vprintf+0x3c>
        state = '%';
 608:	89be                	mv	s3,a5
 60a:	b7cd                	j	5ec <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 60c:	00ea06b3          	add	a3,s4,a4
 610:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 614:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 616:	c681                	beqz	a3,61e <vprintf+0x7c>
 618:	9752                	add	a4,a4,s4
 61a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 61e:	03878f63          	beq	a5,s8,65c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 622:	05978963          	beq	a5,s9,674 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 626:	07500713          	li	a4,117
 62a:	0ee78363          	beq	a5,a4,710 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 62e:	07800713          	li	a4,120
 632:	12e78563          	beq	a5,a4,75c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 636:	07000713          	li	a4,112
 63a:	14e78a63          	beq	a5,a4,78e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 63e:	07300713          	li	a4,115
 642:	18e78a63          	beq	a5,a4,7d6 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 646:	02500713          	li	a4,37
 64a:	04e79563          	bne	a5,a4,694 <vprintf+0xf2>
        putc(fd, '%');
 64e:	02500593          	li	a1,37
 652:	855a                	mv	a0,s6
 654:	e89ff0ef          	jal	4dc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 658:	4981                	li	s3,0
 65a:	bf49                	j	5ec <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 65c:	008b8913          	addi	s2,s7,8
 660:	4685                	li	a3,1
 662:	4629                	li	a2,10
 664:	000ba583          	lw	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	e91ff0ef          	jal	4fa <printint>
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
 672:	bfad                	j	5ec <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 674:	06400793          	li	a5,100
 678:	02f68963          	beq	a3,a5,6aa <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 67c:	06c00793          	li	a5,108
 680:	04f68263          	beq	a3,a5,6c4 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 684:	07500793          	li	a5,117
 688:	0af68063          	beq	a3,a5,728 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 68c:	07800793          	li	a5,120
 690:	0ef68263          	beq	a3,a5,774 <vprintf+0x1d2>
        putc(fd, '%');
 694:	02500593          	li	a1,37
 698:	855a                	mv	a0,s6
 69a:	e43ff0ef          	jal	4dc <putc>
        putc(fd, c0);
 69e:	85ca                	mv	a1,s2
 6a0:	855a                	mv	a0,s6
 6a2:	e3bff0ef          	jal	4dc <putc>
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	b791                	j	5ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6aa:	008b8913          	addi	s2,s7,8
 6ae:	4685                	li	a3,1
 6b0:	4629                	li	a2,10
 6b2:	000ba583          	lw	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	e43ff0ef          	jal	4fa <printint>
        i += 1;
 6bc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6be:	8bca                	mv	s7,s2
      state = 0;
 6c0:	4981                	li	s3,0
        i += 1;
 6c2:	b72d                	j	5ec <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6c4:	06400793          	li	a5,100
 6c8:	02f60763          	beq	a2,a5,6f6 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6cc:	07500793          	li	a5,117
 6d0:	06f60963          	beq	a2,a5,742 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6d4:	07800793          	li	a5,120
 6d8:	faf61ee3          	bne	a2,a5,694 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6dc:	008b8913          	addi	s2,s7,8
 6e0:	4681                	li	a3,0
 6e2:	4641                	li	a2,16
 6e4:	000ba583          	lw	a1,0(s7)
 6e8:	855a                	mv	a0,s6
 6ea:	e11ff0ef          	jal	4fa <printint>
        i += 2;
 6ee:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f0:	8bca                	mv	s7,s2
      state = 0;
 6f2:	4981                	li	s3,0
        i += 2;
 6f4:	bde5                	j	5ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f6:	008b8913          	addi	s2,s7,8
 6fa:	4685                	li	a3,1
 6fc:	4629                	li	a2,10
 6fe:	000ba583          	lw	a1,0(s7)
 702:	855a                	mv	a0,s6
 704:	df7ff0ef          	jal	4fa <printint>
        i += 2;
 708:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 70a:	8bca                	mv	s7,s2
      state = 0;
 70c:	4981                	li	s3,0
        i += 2;
 70e:	bdf9                	j	5ec <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 710:	008b8913          	addi	s2,s7,8
 714:	4681                	li	a3,0
 716:	4629                	li	a2,10
 718:	000ba583          	lw	a1,0(s7)
 71c:	855a                	mv	a0,s6
 71e:	dddff0ef          	jal	4fa <printint>
 722:	8bca                	mv	s7,s2
      state = 0;
 724:	4981                	li	s3,0
 726:	b5d9                	j	5ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 728:	008b8913          	addi	s2,s7,8
 72c:	4681                	li	a3,0
 72e:	4629                	li	a2,10
 730:	000ba583          	lw	a1,0(s7)
 734:	855a                	mv	a0,s6
 736:	dc5ff0ef          	jal	4fa <printint>
        i += 1;
 73a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 73c:	8bca                	mv	s7,s2
      state = 0;
 73e:	4981                	li	s3,0
        i += 1;
 740:	b575                	j	5ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 742:	008b8913          	addi	s2,s7,8
 746:	4681                	li	a3,0
 748:	4629                	li	a2,10
 74a:	000ba583          	lw	a1,0(s7)
 74e:	855a                	mv	a0,s6
 750:	dabff0ef          	jal	4fa <printint>
        i += 2;
 754:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 756:	8bca                	mv	s7,s2
      state = 0;
 758:	4981                	li	s3,0
        i += 2;
 75a:	bd49                	j	5ec <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 75c:	008b8913          	addi	s2,s7,8
 760:	4681                	li	a3,0
 762:	4641                	li	a2,16
 764:	000ba583          	lw	a1,0(s7)
 768:	855a                	mv	a0,s6
 76a:	d91ff0ef          	jal	4fa <printint>
 76e:	8bca                	mv	s7,s2
      state = 0;
 770:	4981                	li	s3,0
 772:	bdad                	j	5ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 774:	008b8913          	addi	s2,s7,8
 778:	4681                	li	a3,0
 77a:	4641                	li	a2,16
 77c:	000ba583          	lw	a1,0(s7)
 780:	855a                	mv	a0,s6
 782:	d79ff0ef          	jal	4fa <printint>
        i += 1;
 786:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 788:	8bca                	mv	s7,s2
      state = 0;
 78a:	4981                	li	s3,0
        i += 1;
 78c:	b585                	j	5ec <vprintf+0x4a>
 78e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 790:	008b8d13          	addi	s10,s7,8
 794:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 798:	03000593          	li	a1,48
 79c:	855a                	mv	a0,s6
 79e:	d3fff0ef          	jal	4dc <putc>
  putc(fd, 'x');
 7a2:	07800593          	li	a1,120
 7a6:	855a                	mv	a0,s6
 7a8:	d35ff0ef          	jal	4dc <putc>
 7ac:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ae:	00000b97          	auipc	s7,0x0
 7b2:	362b8b93          	addi	s7,s7,866 # b10 <digits>
 7b6:	03c9d793          	srli	a5,s3,0x3c
 7ba:	97de                	add	a5,a5,s7
 7bc:	0007c583          	lbu	a1,0(a5)
 7c0:	855a                	mv	a0,s6
 7c2:	d1bff0ef          	jal	4dc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7c6:	0992                	slli	s3,s3,0x4
 7c8:	397d                	addiw	s2,s2,-1
 7ca:	fe0916e3          	bnez	s2,7b6 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7ce:	8bea                	mv	s7,s10
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	6d02                	ld	s10,0(sp)
 7d4:	bd21                	j	5ec <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7d6:	008b8993          	addi	s3,s7,8
 7da:	000bb903          	ld	s2,0(s7)
 7de:	00090f63          	beqz	s2,7fc <vprintf+0x25a>
        for(; *s; s++)
 7e2:	00094583          	lbu	a1,0(s2)
 7e6:	c195                	beqz	a1,80a <vprintf+0x268>
          putc(fd, *s);
 7e8:	855a                	mv	a0,s6
 7ea:	cf3ff0ef          	jal	4dc <putc>
        for(; *s; s++)
 7ee:	0905                	addi	s2,s2,1
 7f0:	00094583          	lbu	a1,0(s2)
 7f4:	f9f5                	bnez	a1,7e8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7f6:	8bce                	mv	s7,s3
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	bbcd                	j	5ec <vprintf+0x4a>
          s = "(null)";
 7fc:	00000917          	auipc	s2,0x0
 800:	30c90913          	addi	s2,s2,780 # b08 <malloc+0x200>
        for(; *s; s++)
 804:	02800593          	li	a1,40
 808:	b7c5                	j	7e8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 80a:	8bce                	mv	s7,s3
      state = 0;
 80c:	4981                	li	s3,0
 80e:	bbf9                	j	5ec <vprintf+0x4a>
 810:	64a6                	ld	s1,72(sp)
 812:	79e2                	ld	s3,56(sp)
 814:	7a42                	ld	s4,48(sp)
 816:	7aa2                	ld	s5,40(sp)
 818:	7b02                	ld	s6,32(sp)
 81a:	6be2                	ld	s7,24(sp)
 81c:	6c42                	ld	s8,16(sp)
 81e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 820:	60e6                	ld	ra,88(sp)
 822:	6446                	ld	s0,80(sp)
 824:	6906                	ld	s2,64(sp)
 826:	6125                	addi	sp,sp,96
 828:	8082                	ret

000000000000082a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 82a:	715d                	addi	sp,sp,-80
 82c:	ec06                	sd	ra,24(sp)
 82e:	e822                	sd	s0,16(sp)
 830:	1000                	addi	s0,sp,32
 832:	e010                	sd	a2,0(s0)
 834:	e414                	sd	a3,8(s0)
 836:	e818                	sd	a4,16(s0)
 838:	ec1c                	sd	a5,24(s0)
 83a:	03043023          	sd	a6,32(s0)
 83e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 842:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 846:	8622                	mv	a2,s0
 848:	d5bff0ef          	jal	5a2 <vprintf>
}
 84c:	60e2                	ld	ra,24(sp)
 84e:	6442                	ld	s0,16(sp)
 850:	6161                	addi	sp,sp,80
 852:	8082                	ret

0000000000000854 <printf>:

void
printf(const char *fmt, ...)
{
 854:	711d                	addi	sp,sp,-96
 856:	ec06                	sd	ra,24(sp)
 858:	e822                	sd	s0,16(sp)
 85a:	1000                	addi	s0,sp,32
 85c:	e40c                	sd	a1,8(s0)
 85e:	e810                	sd	a2,16(s0)
 860:	ec14                	sd	a3,24(s0)
 862:	f018                	sd	a4,32(s0)
 864:	f41c                	sd	a5,40(s0)
 866:	03043823          	sd	a6,48(s0)
 86a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 86e:	00840613          	addi	a2,s0,8
 872:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 876:	85aa                	mv	a1,a0
 878:	4505                	li	a0,1
 87a:	d29ff0ef          	jal	5a2 <vprintf>
}
 87e:	60e2                	ld	ra,24(sp)
 880:	6442                	ld	s0,16(sp)
 882:	6125                	addi	sp,sp,96
 884:	8082                	ret

0000000000000886 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 886:	1141                	addi	sp,sp,-16
 888:	e422                	sd	s0,8(sp)
 88a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 88c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 890:	00000797          	auipc	a5,0x0
 894:	7707b783          	ld	a5,1904(a5) # 1000 <freep>
 898:	a02d                	j	8c2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 89a:	4618                	lw	a4,8(a2)
 89c:	9f2d                	addw	a4,a4,a1
 89e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a2:	6398                	ld	a4,0(a5)
 8a4:	6310                	ld	a2,0(a4)
 8a6:	a83d                	j	8e4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8a8:	ff852703          	lw	a4,-8(a0)
 8ac:	9f31                	addw	a4,a4,a2
 8ae:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8b0:	ff053683          	ld	a3,-16(a0)
 8b4:	a091                	j	8f8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b6:	6398                	ld	a4,0(a5)
 8b8:	00e7e463          	bltu	a5,a4,8c0 <free+0x3a>
 8bc:	00e6ea63          	bltu	a3,a4,8d0 <free+0x4a>
{
 8c0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c2:	fed7fae3          	bgeu	a5,a3,8b6 <free+0x30>
 8c6:	6398                	ld	a4,0(a5)
 8c8:	00e6e463          	bltu	a3,a4,8d0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8cc:	fee7eae3          	bltu	a5,a4,8c0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8d0:	ff852583          	lw	a1,-8(a0)
 8d4:	6390                	ld	a2,0(a5)
 8d6:	02059813          	slli	a6,a1,0x20
 8da:	01c85713          	srli	a4,a6,0x1c
 8de:	9736                	add	a4,a4,a3
 8e0:	fae60de3          	beq	a2,a4,89a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8e4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8e8:	4790                	lw	a2,8(a5)
 8ea:	02061593          	slli	a1,a2,0x20
 8ee:	01c5d713          	srli	a4,a1,0x1c
 8f2:	973e                	add	a4,a4,a5
 8f4:	fae68ae3          	beq	a3,a4,8a8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8f8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8fa:	00000717          	auipc	a4,0x0
 8fe:	70f73323          	sd	a5,1798(a4) # 1000 <freep>
}
 902:	6422                	ld	s0,8(sp)
 904:	0141                	addi	sp,sp,16
 906:	8082                	ret

0000000000000908 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 908:	7139                	addi	sp,sp,-64
 90a:	fc06                	sd	ra,56(sp)
 90c:	f822                	sd	s0,48(sp)
 90e:	f426                	sd	s1,40(sp)
 910:	ec4e                	sd	s3,24(sp)
 912:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 914:	02051493          	slli	s1,a0,0x20
 918:	9081                	srli	s1,s1,0x20
 91a:	04bd                	addi	s1,s1,15
 91c:	8091                	srli	s1,s1,0x4
 91e:	0014899b          	addiw	s3,s1,1
 922:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 924:	00000517          	auipc	a0,0x0
 928:	6dc53503          	ld	a0,1756(a0) # 1000 <freep>
 92c:	c915                	beqz	a0,960 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 930:	4798                	lw	a4,8(a5)
 932:	08977a63          	bgeu	a4,s1,9c6 <malloc+0xbe>
 936:	f04a                	sd	s2,32(sp)
 938:	e852                	sd	s4,16(sp)
 93a:	e456                	sd	s5,8(sp)
 93c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 93e:	8a4e                	mv	s4,s3
 940:	0009871b          	sext.w	a4,s3
 944:	6685                	lui	a3,0x1
 946:	00d77363          	bgeu	a4,a3,94c <malloc+0x44>
 94a:	6a05                	lui	s4,0x1
 94c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 950:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 954:	00000917          	auipc	s2,0x0
 958:	6ac90913          	addi	s2,s2,1708 # 1000 <freep>
  if(p == (char*)-1)
 95c:	5afd                	li	s5,-1
 95e:	a081                	j	99e <malloc+0x96>
 960:	f04a                	sd	s2,32(sp)
 962:	e852                	sd	s4,16(sp)
 964:	e456                	sd	s5,8(sp)
 966:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 968:	00000797          	auipc	a5,0x0
 96c:	6a878793          	addi	a5,a5,1704 # 1010 <base>
 970:	00000717          	auipc	a4,0x0
 974:	68f73823          	sd	a5,1680(a4) # 1000 <freep>
 978:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 97a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 97e:	b7c1                	j	93e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 980:	6398                	ld	a4,0(a5)
 982:	e118                	sd	a4,0(a0)
 984:	a8a9                	j	9de <malloc+0xd6>
  hp->s.size = nu;
 986:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 98a:	0541                	addi	a0,a0,16
 98c:	efbff0ef          	jal	886 <free>
  return freep;
 990:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 994:	c12d                	beqz	a0,9f6 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 996:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 998:	4798                	lw	a4,8(a5)
 99a:	02977263          	bgeu	a4,s1,9be <malloc+0xb6>
    if(p == freep)
 99e:	00093703          	ld	a4,0(s2)
 9a2:	853e                	mv	a0,a5
 9a4:	fef719e3          	bne	a4,a5,996 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9a8:	8552                	mv	a0,s4
 9aa:	ad3ff0ef          	jal	47c <sbrk>
  if(p == (char*)-1)
 9ae:	fd551ce3          	bne	a0,s5,986 <malloc+0x7e>
        return 0;
 9b2:	4501                	li	a0,0
 9b4:	7902                	ld	s2,32(sp)
 9b6:	6a42                	ld	s4,16(sp)
 9b8:	6aa2                	ld	s5,8(sp)
 9ba:	6b02                	ld	s6,0(sp)
 9bc:	a03d                	j	9ea <malloc+0xe2>
 9be:	7902                	ld	s2,32(sp)
 9c0:	6a42                	ld	s4,16(sp)
 9c2:	6aa2                	ld	s5,8(sp)
 9c4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9c6:	fae48de3          	beq	s1,a4,980 <malloc+0x78>
        p->s.size -= nunits;
 9ca:	4137073b          	subw	a4,a4,s3
 9ce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9d0:	02071693          	slli	a3,a4,0x20
 9d4:	01c6d713          	srli	a4,a3,0x1c
 9d8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9da:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9de:	00000717          	auipc	a4,0x0
 9e2:	62a73123          	sd	a0,1570(a4) # 1000 <freep>
      return (void*)(p + 1);
 9e6:	01078513          	addi	a0,a5,16
  }
}
 9ea:	70e2                	ld	ra,56(sp)
 9ec:	7442                	ld	s0,48(sp)
 9ee:	74a2                	ld	s1,40(sp)
 9f0:	69e2                	ld	s3,24(sp)
 9f2:	6121                	addi	sp,sp,64
 9f4:	8082                	ret
 9f6:	7902                	ld	s2,32(sp)
 9f8:	6a42                	ld	s4,16(sp)
 9fa:	6aa2                	ld	s5,8(sp)
 9fc:	6b02                	ld	s6,0(sp)
 9fe:	b7f5                	j	9ea <malloc+0xe2>
