
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	4e013103          	ld	sp,1248(sp) # 8000a4e0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffda97f>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	df078793          	addi	a5,a5,-528 # 80000e70 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	f84a                	sd	s2,48(sp)
    800000d8:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000da:	04c05263          	blez	a2,8000011e <consolewrite+0x4e>
    800000de:	fc26                	sd	s1,56(sp)
    800000e0:	f44e                	sd	s3,40(sp)
    800000e2:	f052                	sd	s4,32(sp)
    800000e4:	ec56                	sd	s5,24(sp)
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	532020ef          	jal	8000262c <either_copyin>
    800000fe:	03550263          	beq	a0,s5,80000122 <consolewrite+0x52>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	043000ef          	jal	80000948 <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addiw	s2,s2,1
    8000010c:	0485                	addi	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
    80000112:	894e                	mv	s2,s3
    80000114:	74e2                	ld	s1,56(sp)
    80000116:	79a2                	ld	s3,40(sp)
    80000118:	7a02                	ld	s4,32(sp)
    8000011a:	6ae2                	ld	s5,24(sp)
    8000011c:	a039                	j	8000012a <consolewrite+0x5a>
    8000011e:	4901                	li	s2,0
    80000120:	a029                	j	8000012a <consolewrite+0x5a>
    80000122:	74e2                	ld	s1,56(sp)
    80000124:	79a2                	ld	s3,40(sp)
    80000126:	7a02                	ld	s4,32(sp)
    80000128:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    8000012a:	854a                	mv	a0,s2
    8000012c:	60a6                	ld	ra,72(sp)
    8000012e:	6406                	ld	s0,64(sp)
    80000130:	7942                	ld	s2,48(sp)
    80000132:	6161                	addi	sp,sp,80
    80000134:	8082                	ret

0000000080000136 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000136:	711d                	addi	sp,sp,-96
    80000138:	ec86                	sd	ra,88(sp)
    8000013a:	e8a2                	sd	s0,80(sp)
    8000013c:	e4a6                	sd	s1,72(sp)
    8000013e:	e0ca                	sd	s2,64(sp)
    80000140:	fc4e                	sd	s3,56(sp)
    80000142:	f852                	sd	s4,48(sp)
    80000144:	f456                	sd	s5,40(sp)
    80000146:	f05a                	sd	s6,32(sp)
    80000148:	1080                	addi	s0,sp,96
    8000014a:	8aaa                	mv	s5,a0
    8000014c:	8a2e                	mv	s4,a1
    8000014e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000150:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000154:	00012517          	auipc	a0,0x12
    80000158:	3fc50513          	addi	a0,a0,1020 # 80012550 <cons>
    8000015c:	2a7000ef          	jal	80000c02 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00012497          	auipc	s1,0x12
    80000164:	3f048493          	addi	s1,s1,1008 # 80012550 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00012917          	auipc	s2,0x12
    8000016c:	48090913          	addi	s2,s2,1152 # 800125e8 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	792010ef          	jal	80001912 <myproc>
    80000184:	33a020ef          	jal	800024be <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	783010ef          	jal	80002110 <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	00012717          	auipc	a4,0x12
    800001a4:	3b070713          	addi	a4,a4,944 # 80012550 <cons>
    800001a8:	0017869b          	addiw	a3,a5,1
    800001ac:	08d72c23          	sw	a3,152(a4)
    800001b0:	07f7f693          	andi	a3,a5,127
    800001b4:	9736                	add	a4,a4,a3
    800001b6:	01874703          	lbu	a4,24(a4)
    800001ba:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001be:	4691                	li	a3,4
    800001c0:	04db8663          	beq	s7,a3,8000020c <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001c4:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001c8:	4685                	li	a3,1
    800001ca:	faf40613          	addi	a2,s0,-81
    800001ce:	85d2                	mv	a1,s4
    800001d0:	8556                	mv	a0,s5
    800001d2:	410020ef          	jal	800025e2 <either_copyout>
    800001d6:	57fd                	li	a5,-1
    800001d8:	04f50863          	beq	a0,a5,80000228 <consoleread+0xf2>
      break;

    dst++;
    800001dc:	0a05                	addi	s4,s4,1
    --n;
    800001de:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800001e0:	47a9                	li	a5,10
    800001e2:	04fb8d63          	beq	s7,a5,8000023c <consoleread+0x106>
    800001e6:	6be2                	ld	s7,24(sp)
    800001e8:	b761                	j	80000170 <consoleread+0x3a>
        release(&cons.lock);
    800001ea:	00012517          	auipc	a0,0x12
    800001ee:	36650513          	addi	a0,a0,870 # 80012550 <cons>
    800001f2:	2a9000ef          	jal	80000c9a <release>
        return -1;
    800001f6:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800001f8:	60e6                	ld	ra,88(sp)
    800001fa:	6446                	ld	s0,80(sp)
    800001fc:	64a6                	ld	s1,72(sp)
    800001fe:	6906                	ld	s2,64(sp)
    80000200:	79e2                	ld	s3,56(sp)
    80000202:	7a42                	ld	s4,48(sp)
    80000204:	7aa2                	ld	s5,40(sp)
    80000206:	7b02                	ld	s6,32(sp)
    80000208:	6125                	addi	sp,sp,96
    8000020a:	8082                	ret
      if(n < target){
    8000020c:	0009871b          	sext.w	a4,s3
    80000210:	01677a63          	bgeu	a4,s6,80000224 <consoleread+0xee>
        cons.r--;
    80000214:	00012717          	auipc	a4,0x12
    80000218:	3cf72a23          	sw	a5,980(a4) # 800125e8 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	00012517          	auipc	a0,0x12
    8000022e:	32650513          	addi	a0,a0,806 # 80012550 <cons>
    80000232:	269000ef          	jal	80000c9a <release>
  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	bf7d                	j	800001f8 <consoleread+0xc2>
    8000023c:	6be2                	ld	s7,24(sp)
    8000023e:	b7f5                	j	8000022a <consoleread+0xf4>

0000000080000240 <consputc>:
{
    80000240:	1141                	addi	sp,sp,-16
    80000242:	e406                	sd	ra,8(sp)
    80000244:	e022                	sd	s0,0(sp)
    80000246:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000248:	10000793          	li	a5,256
    8000024c:	00f50863          	beq	a0,a5,8000025c <consputc+0x1c>
    uartputc_sync(c);
    80000250:	612000ef          	jal	80000862 <uartputc_sync>
}
    80000254:	60a2                	ld	ra,8(sp)
    80000256:	6402                	ld	s0,0(sp)
    80000258:	0141                	addi	sp,sp,16
    8000025a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000025c:	4521                	li	a0,8
    8000025e:	604000ef          	jal	80000862 <uartputc_sync>
    80000262:	02000513          	li	a0,32
    80000266:	5fc000ef          	jal	80000862 <uartputc_sync>
    8000026a:	4521                	li	a0,8
    8000026c:	5f6000ef          	jal	80000862 <uartputc_sync>
    80000270:	b7d5                	j	80000254 <consputc+0x14>

0000000080000272 <consoleintr>:
// wake up consoleread() if a whole line has arrived.
//
  int keyboard_int_cnt =0;
void
consoleintr(int c)
{
    80000272:	1101                	addi	sp,sp,-32
    80000274:	ec06                	sd	ra,24(sp)
    80000276:	e822                	sd	s0,16(sp)
    80000278:	e426                	sd	s1,8(sp)
    8000027a:	1000                	addi	s0,sp,32
    8000027c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000027e:	00012517          	auipc	a0,0x12
    80000282:	2d250513          	addi	a0,a0,722 # 80012550 <cons>
    80000286:	17d000ef          	jal	80000c02 <acquire>
  keyboard_int_cnt++;
    8000028a:	0000a717          	auipc	a4,0xa
    8000028e:	27670713          	addi	a4,a4,630 # 8000a500 <keyboard_int_cnt>
    80000292:	431c                	lw	a5,0(a4)
    80000294:	2785                	addiw	a5,a5,1
    80000296:	c31c                	sw	a5,0(a4)
  switch(c){
    80000298:	47d5                	li	a5,21
    8000029a:	08f48f63          	beq	s1,a5,80000338 <consoleintr+0xc6>
    8000029e:	0297c563          	blt	a5,s1,800002c8 <consoleintr+0x56>
    800002a2:	47a1                	li	a5,8
    800002a4:	0ef48463          	beq	s1,a5,8000038c <consoleintr+0x11a>
    800002a8:	47c1                	li	a5,16
    800002aa:	10f49563          	bne	s1,a5,800003b4 <consoleintr+0x142>
  case C('P'):  // Print process list.
    procdump();
    800002ae:	3c8020ef          	jal	80002676 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002b2:	00012517          	auipc	a0,0x12
    800002b6:	29e50513          	addi	a0,a0,670 # 80012550 <cons>
    800002ba:	1e1000ef          	jal	80000c9a <release>
}
    800002be:	60e2                	ld	ra,24(sp)
    800002c0:	6442                	ld	s0,16(sp)
    800002c2:	64a2                	ld	s1,8(sp)
    800002c4:	6105                	addi	sp,sp,32
    800002c6:	8082                	ret
  switch(c){
    800002c8:	07f00793          	li	a5,127
    800002cc:	0cf48063          	beq	s1,a5,8000038c <consoleintr+0x11a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002d0:	00012717          	auipc	a4,0x12
    800002d4:	28070713          	addi	a4,a4,640 # 80012550 <cons>
    800002d8:	0a072783          	lw	a5,160(a4)
    800002dc:	09872703          	lw	a4,152(a4)
    800002e0:	9f99                	subw	a5,a5,a4
    800002e2:	07f00713          	li	a4,127
    800002e6:	fcf766e3          	bltu	a4,a5,800002b2 <consoleintr+0x40>
      c = (c == '\r') ? '\n' : c;
    800002ea:	47b5                	li	a5,13
    800002ec:	0cf48763          	beq	s1,a5,800003ba <consoleintr+0x148>
      consputc(c);
    800002f0:	8526                	mv	a0,s1
    800002f2:	f4fff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002f6:	00012797          	auipc	a5,0x12
    800002fa:	25a78793          	addi	a5,a5,602 # 80012550 <cons>
    800002fe:	0a07a683          	lw	a3,160(a5)
    80000302:	0016871b          	addiw	a4,a3,1
    80000306:	0007061b          	sext.w	a2,a4
    8000030a:	0ae7a023          	sw	a4,160(a5)
    8000030e:	07f6f693          	andi	a3,a3,127
    80000312:	97b6                	add	a5,a5,a3
    80000314:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000318:	47a9                	li	a5,10
    8000031a:	0cf48563          	beq	s1,a5,800003e4 <consoleintr+0x172>
    8000031e:	4791                	li	a5,4
    80000320:	0cf48263          	beq	s1,a5,800003e4 <consoleintr+0x172>
    80000324:	00012797          	auipc	a5,0x12
    80000328:	2c47a783          	lw	a5,708(a5) # 800125e8 <cons+0x98>
    8000032c:	9f1d                	subw	a4,a4,a5
    8000032e:	08000793          	li	a5,128
    80000332:	f8f710e3          	bne	a4,a5,800002b2 <consoleintr+0x40>
    80000336:	a07d                	j	800003e4 <consoleintr+0x172>
    80000338:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000033a:	00012717          	auipc	a4,0x12
    8000033e:	21670713          	addi	a4,a4,534 # 80012550 <cons>
    80000342:	0a072783          	lw	a5,160(a4)
    80000346:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	00012497          	auipc	s1,0x12
    8000034e:	20648493          	addi	s1,s1,518 # 80012550 <cons>
    while(cons.e != cons.w &&
    80000352:	4929                	li	s2,10
    80000354:	02f70863          	beq	a4,a5,80000384 <consoleintr+0x112>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000358:	37fd                	addiw	a5,a5,-1
    8000035a:	07f7f713          	andi	a4,a5,127
    8000035e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000360:	01874703          	lbu	a4,24(a4)
    80000364:	03270263          	beq	a4,s2,80000388 <consoleintr+0x116>
      cons.e--;
    80000368:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000036c:	10000513          	li	a0,256
    80000370:	ed1ff0ef          	jal	80000240 <consputc>
    while(cons.e != cons.w &&
    80000374:	0a04a783          	lw	a5,160(s1)
    80000378:	09c4a703          	lw	a4,156(s1)
    8000037c:	fcf71ee3          	bne	a4,a5,80000358 <consoleintr+0xe6>
    80000380:	6902                	ld	s2,0(sp)
    80000382:	bf05                	j	800002b2 <consoleintr+0x40>
    80000384:	6902                	ld	s2,0(sp)
    80000386:	b735                	j	800002b2 <consoleintr+0x40>
    80000388:	6902                	ld	s2,0(sp)
    8000038a:	b725                	j	800002b2 <consoleintr+0x40>
    if(cons.e != cons.w){
    8000038c:	00012717          	auipc	a4,0x12
    80000390:	1c470713          	addi	a4,a4,452 # 80012550 <cons>
    80000394:	0a072783          	lw	a5,160(a4)
    80000398:	09c72703          	lw	a4,156(a4)
    8000039c:	f0f70be3          	beq	a4,a5,800002b2 <consoleintr+0x40>
      cons.e--;
    800003a0:	37fd                	addiw	a5,a5,-1
    800003a2:	00012717          	auipc	a4,0x12
    800003a6:	24f72723          	sw	a5,590(a4) # 800125f0 <cons+0xa0>
      consputc(BACKSPACE);
    800003aa:	10000513          	li	a0,256
    800003ae:	e93ff0ef          	jal	80000240 <consputc>
    800003b2:	b701                	j	800002b2 <consoleintr+0x40>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003b4:	ee048fe3          	beqz	s1,800002b2 <consoleintr+0x40>
    800003b8:	bf21                	j	800002d0 <consoleintr+0x5e>
      consputc(c);
    800003ba:	4529                	li	a0,10
    800003bc:	e85ff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003c0:	00012797          	auipc	a5,0x12
    800003c4:	19078793          	addi	a5,a5,400 # 80012550 <cons>
    800003c8:	0a07a703          	lw	a4,160(a5)
    800003cc:	0017069b          	addiw	a3,a4,1
    800003d0:	0006861b          	sext.w	a2,a3
    800003d4:	0ad7a023          	sw	a3,160(a5)
    800003d8:	07f77713          	andi	a4,a4,127
    800003dc:	97ba                	add	a5,a5,a4
    800003de:	4729                	li	a4,10
    800003e0:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003e4:	00012797          	auipc	a5,0x12
    800003e8:	20c7a423          	sw	a2,520(a5) # 800125ec <cons+0x9c>
        wakeup(&cons.r);
    800003ec:	00012517          	auipc	a0,0x12
    800003f0:	1fc50513          	addi	a0,a0,508 # 800125e8 <cons+0x98>
    800003f4:	6c9010ef          	jal	800022bc <wakeup>
    800003f8:	bd6d                	j	800002b2 <consoleintr+0x40>

00000000800003fa <consoleinit>:

void
consoleinit(void)
{
    800003fa:	1141                	addi	sp,sp,-16
    800003fc:	e406                	sd	ra,8(sp)
    800003fe:	e022                	sd	s0,0(sp)
    80000400:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000402:	00007597          	auipc	a1,0x7
    80000406:	bfe58593          	addi	a1,a1,-1026 # 80007000 <etext>
    8000040a:	00012517          	auipc	a0,0x12
    8000040e:	14650513          	addi	a0,a0,326 # 80012550 <cons>
    80000412:	770000ef          	jal	80000b82 <initlock>

  uartinit();
    80000416:	3f4000ef          	jal	8000080a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000041a:	00023797          	auipc	a5,0x23
    8000041e:	8ce78793          	addi	a5,a5,-1842 # 80022ce8 <devsw>
    80000422:	00000717          	auipc	a4,0x0
    80000426:	d1470713          	addi	a4,a4,-748 # 80000136 <consoleread>
    8000042a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000042c:	00000717          	auipc	a4,0x0
    80000430:	ca470713          	addi	a4,a4,-860 # 800000d0 <consolewrite>
    80000434:	ef98                	sd	a4,24(a5)
}
    80000436:	60a2                	ld	ra,8(sp)
    80000438:	6402                	ld	s0,0(sp)
    8000043a:	0141                	addi	sp,sp,16
    8000043c:	8082                	ret

000000008000043e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000043e:	7179                	addi	sp,sp,-48
    80000440:	f406                	sd	ra,40(sp)
    80000442:	f022                	sd	s0,32(sp)
    80000444:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000446:	c219                	beqz	a2,8000044c <printint+0xe>
    80000448:	08054063          	bltz	a0,800004c8 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000044c:	4881                	li	a7,0
    8000044e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000452:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000454:	00007617          	auipc	a2,0x7
    80000458:	32c60613          	addi	a2,a2,812 # 80007780 <digits>
    8000045c:	883e                	mv	a6,a5
    8000045e:	2785                	addiw	a5,a5,1
    80000460:	02b57733          	remu	a4,a0,a1
    80000464:	9732                	add	a4,a4,a2
    80000466:	00074703          	lbu	a4,0(a4)
    8000046a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000046e:	872a                	mv	a4,a0
    80000470:	02b55533          	divu	a0,a0,a1
    80000474:	0685                	addi	a3,a3,1
    80000476:	feb773e3          	bgeu	a4,a1,8000045c <printint+0x1e>

  if(sign)
    8000047a:	00088a63          	beqz	a7,8000048e <printint+0x50>
    buf[i++] = '-';
    8000047e:	1781                	addi	a5,a5,-32
    80000480:	97a2                	add	a5,a5,s0
    80000482:	02d00713          	li	a4,45
    80000486:	fee78823          	sb	a4,-16(a5)
    8000048a:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    8000048e:	02f05963          	blez	a5,800004c0 <printint+0x82>
    80000492:	ec26                	sd	s1,24(sp)
    80000494:	e84a                	sd	s2,16(sp)
    80000496:	fd040713          	addi	a4,s0,-48
    8000049a:	00f704b3          	add	s1,a4,a5
    8000049e:	fff70913          	addi	s2,a4,-1
    800004a2:	993e                	add	s2,s2,a5
    800004a4:	37fd                	addiw	a5,a5,-1
    800004a6:	1782                	slli	a5,a5,0x20
    800004a8:	9381                	srli	a5,a5,0x20
    800004aa:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004ae:	fff4c503          	lbu	a0,-1(s1)
    800004b2:	d8fff0ef          	jal	80000240 <consputc>
  while(--i >= 0)
    800004b6:	14fd                	addi	s1,s1,-1
    800004b8:	ff249be3          	bne	s1,s2,800004ae <printint+0x70>
    800004bc:	64e2                	ld	s1,24(sp)
    800004be:	6942                	ld	s2,16(sp)
}
    800004c0:	70a2                	ld	ra,40(sp)
    800004c2:	7402                	ld	s0,32(sp)
    800004c4:	6145                	addi	sp,sp,48
    800004c6:	8082                	ret
    x = -xx;
    800004c8:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004cc:	4885                	li	a7,1
    x = -xx;
    800004ce:	b741                	j	8000044e <printint+0x10>

00000000800004d0 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004d0:	7155                	addi	sp,sp,-208
    800004d2:	e506                	sd	ra,136(sp)
    800004d4:	e122                	sd	s0,128(sp)
    800004d6:	f0d2                	sd	s4,96(sp)
    800004d8:	0900                	addi	s0,sp,144
    800004da:	8a2a                	mv	s4,a0
    800004dc:	e40c                	sd	a1,8(s0)
    800004de:	e810                	sd	a2,16(s0)
    800004e0:	ec14                	sd	a3,24(s0)
    800004e2:	f018                	sd	a4,32(s0)
    800004e4:	f41c                	sd	a5,40(s0)
    800004e6:	03043823          	sd	a6,48(s0)
    800004ea:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004ee:	00012797          	auipc	a5,0x12
    800004f2:	1227a783          	lw	a5,290(a5) # 80012610 <pr+0x18>
    800004f6:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004fa:	e3a1                	bnez	a5,8000053a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004fc:	00840793          	addi	a5,s0,8
    80000500:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000504:	00054503          	lbu	a0,0(a0)
    80000508:	26050763          	beqz	a0,80000776 <printf+0x2a6>
    8000050c:	fca6                	sd	s1,120(sp)
    8000050e:	f8ca                	sd	s2,112(sp)
    80000510:	f4ce                	sd	s3,104(sp)
    80000512:	ecd6                	sd	s5,88(sp)
    80000514:	e8da                	sd	s6,80(sp)
    80000516:	e0e2                	sd	s8,64(sp)
    80000518:	fc66                	sd	s9,56(sp)
    8000051a:	f86a                	sd	s10,48(sp)
    8000051c:	f46e                	sd	s11,40(sp)
    8000051e:	4981                	li	s3,0
    if(cx != '%'){
    80000520:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000524:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80000528:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000052c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000530:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000534:	07000d93          	li	s11,112
    80000538:	a815                	j	8000056c <printf+0x9c>
    acquire(&pr.lock);
    8000053a:	00012517          	auipc	a0,0x12
    8000053e:	0be50513          	addi	a0,a0,190 # 800125f8 <pr>
    80000542:	6c0000ef          	jal	80000c02 <acquire>
  va_start(ap, fmt);
    80000546:	00840793          	addi	a5,s0,8
    8000054a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054e:	000a4503          	lbu	a0,0(s4)
    80000552:	fd4d                	bnez	a0,8000050c <printf+0x3c>
    80000554:	a481                	j	80000794 <printf+0x2c4>
      consputc(cx);
    80000556:	cebff0ef          	jal	80000240 <consputc>
      continue;
    8000055a:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000055c:	0014899b          	addiw	s3,s1,1
    80000560:	013a07b3          	add	a5,s4,s3
    80000564:	0007c503          	lbu	a0,0(a5)
    80000568:	1e050b63          	beqz	a0,8000075e <printf+0x28e>
    if(cx != '%'){
    8000056c:	ff5515e3          	bne	a0,s5,80000556 <printf+0x86>
    i++;
    80000570:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000574:	009a07b3          	add	a5,s4,s1
    80000578:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000057c:	1e090163          	beqz	s2,8000075e <printf+0x28e>
    80000580:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000584:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000586:	c789                	beqz	a5,80000590 <printf+0xc0>
    80000588:	009a0733          	add	a4,s4,s1
    8000058c:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000590:	03690763          	beq	s2,s6,800005be <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80000594:	05890163          	beq	s2,s8,800005d6 <printf+0x106>
    } else if(c0 == 'u'){
    80000598:	0d990b63          	beq	s2,s9,8000066e <printf+0x19e>
    } else if(c0 == 'x'){
    8000059c:	13a90163          	beq	s2,s10,800006be <printf+0x1ee>
    } else if(c0 == 'p'){
    800005a0:	13b90b63          	beq	s2,s11,800006d6 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800005a4:	07300793          	li	a5,115
    800005a8:	16f90a63          	beq	s2,a5,8000071c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800005ac:	1b590463          	beq	s2,s5,80000754 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005b0:	8556                	mv	a0,s5
    800005b2:	c8fff0ef          	jal	80000240 <consputc>
      consputc(c0);
    800005b6:	854a                	mv	a0,s2
    800005b8:	c89ff0ef          	jal	80000240 <consputc>
    800005bc:	b745                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800005be:	f8843783          	ld	a5,-120(s0)
    800005c2:	00878713          	addi	a4,a5,8
    800005c6:	f8e43423          	sd	a4,-120(s0)
    800005ca:	4605                	li	a2,1
    800005cc:	45a9                	li	a1,10
    800005ce:	4388                	lw	a0,0(a5)
    800005d0:	e6fff0ef          	jal	8000043e <printint>
    800005d4:	b761                	j	8000055c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800005d6:	03678663          	beq	a5,s6,80000602 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005da:	05878263          	beq	a5,s8,8000061e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800005de:	0b978463          	beq	a5,s9,80000686 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800005e2:	fda797e3          	bne	a5,s10,800005b0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800005e6:	f8843783          	ld	a5,-120(s0)
    800005ea:	00878713          	addi	a4,a5,8
    800005ee:	f8e43423          	sd	a4,-120(s0)
    800005f2:	4601                	li	a2,0
    800005f4:	45c1                	li	a1,16
    800005f6:	6388                	ld	a0,0(a5)
    800005f8:	e47ff0ef          	jal	8000043e <printint>
      i += 1;
    800005fc:	0029849b          	addiw	s1,s3,2
    80000600:	bfb1                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80000602:	f8843783          	ld	a5,-120(s0)
    80000606:	00878713          	addi	a4,a5,8
    8000060a:	f8e43423          	sd	a4,-120(s0)
    8000060e:	4605                	li	a2,1
    80000610:	45a9                	li	a1,10
    80000612:	6388                	ld	a0,0(a5)
    80000614:	e2bff0ef          	jal	8000043e <printint>
      i += 1;
    80000618:	0029849b          	addiw	s1,s3,2
    8000061c:	b781                	j	8000055c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000061e:	06400793          	li	a5,100
    80000622:	02f68863          	beq	a3,a5,80000652 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000626:	07500793          	li	a5,117
    8000062a:	06f68c63          	beq	a3,a5,800006a2 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000062e:	07800793          	li	a5,120
    80000632:	f6f69fe3          	bne	a3,a5,800005b0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80000636:	f8843783          	ld	a5,-120(s0)
    8000063a:	00878713          	addi	a4,a5,8
    8000063e:	f8e43423          	sd	a4,-120(s0)
    80000642:	4601                	li	a2,0
    80000644:	45c1                	li	a1,16
    80000646:	6388                	ld	a0,0(a5)
    80000648:	df7ff0ef          	jal	8000043e <printint>
      i += 2;
    8000064c:	0039849b          	addiw	s1,s3,3
    80000650:	b731                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80000652:	f8843783          	ld	a5,-120(s0)
    80000656:	00878713          	addi	a4,a5,8
    8000065a:	f8e43423          	sd	a4,-120(s0)
    8000065e:	4605                	li	a2,1
    80000660:	45a9                	li	a1,10
    80000662:	6388                	ld	a0,0(a5)
    80000664:	ddbff0ef          	jal	8000043e <printint>
      i += 2;
    80000668:	0039849b          	addiw	s1,s3,3
    8000066c:	bdc5                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000066e:	f8843783          	ld	a5,-120(s0)
    80000672:	00878713          	addi	a4,a5,8
    80000676:	f8e43423          	sd	a4,-120(s0)
    8000067a:	4601                	li	a2,0
    8000067c:	45a9                	li	a1,10
    8000067e:	4388                	lw	a0,0(a5)
    80000680:	dbfff0ef          	jal	8000043e <printint>
    80000684:	bde1                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000686:	f8843783          	ld	a5,-120(s0)
    8000068a:	00878713          	addi	a4,a5,8
    8000068e:	f8e43423          	sd	a4,-120(s0)
    80000692:	4601                	li	a2,0
    80000694:	45a9                	li	a1,10
    80000696:	6388                	ld	a0,0(a5)
    80000698:	da7ff0ef          	jal	8000043e <printint>
      i += 1;
    8000069c:	0029849b          	addiw	s1,s3,2
    800006a0:	bd75                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	addi	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	4601                	li	a2,0
    800006b0:	45a9                	li	a1,10
    800006b2:	6388                	ld	a0,0(a5)
    800006b4:	d8bff0ef          	jal	8000043e <printint>
      i += 2;
    800006b8:	0039849b          	addiw	s1,s3,3
    800006bc:	b545                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800006be:	f8843783          	ld	a5,-120(s0)
    800006c2:	00878713          	addi	a4,a5,8
    800006c6:	f8e43423          	sd	a4,-120(s0)
    800006ca:	4601                	li	a2,0
    800006cc:	45c1                	li	a1,16
    800006ce:	4388                	lw	a0,0(a5)
    800006d0:	d6fff0ef          	jal	8000043e <printint>
    800006d4:	b561                	j	8000055c <printf+0x8c>
    800006d6:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800006d8:	f8843783          	ld	a5,-120(s0)
    800006dc:	00878713          	addi	a4,a5,8
    800006e0:	f8e43423          	sd	a4,-120(s0)
    800006e4:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006e8:	03000513          	li	a0,48
    800006ec:	b55ff0ef          	jal	80000240 <consputc>
  consputc('x');
    800006f0:	07800513          	li	a0,120
    800006f4:	b4dff0ef          	jal	80000240 <consputc>
    800006f8:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006fa:	00007b97          	auipc	s7,0x7
    800006fe:	086b8b93          	addi	s7,s7,134 # 80007780 <digits>
    80000702:	03c9d793          	srli	a5,s3,0x3c
    80000706:	97de                	add	a5,a5,s7
    80000708:	0007c503          	lbu	a0,0(a5)
    8000070c:	b35ff0ef          	jal	80000240 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000710:	0992                	slli	s3,s3,0x4
    80000712:	397d                	addiw	s2,s2,-1
    80000714:	fe0917e3          	bnez	s2,80000702 <printf+0x232>
    80000718:	6ba6                	ld	s7,72(sp)
    8000071a:	b589                	j	8000055c <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000071c:	f8843783          	ld	a5,-120(s0)
    80000720:	00878713          	addi	a4,a5,8
    80000724:	f8e43423          	sd	a4,-120(s0)
    80000728:	0007b903          	ld	s2,0(a5)
    8000072c:	00090d63          	beqz	s2,80000746 <printf+0x276>
      for(; *s; s++)
    80000730:	00094503          	lbu	a0,0(s2)
    80000734:	e20504e3          	beqz	a0,8000055c <printf+0x8c>
        consputc(*s);
    80000738:	b09ff0ef          	jal	80000240 <consputc>
      for(; *s; s++)
    8000073c:	0905                	addi	s2,s2,1
    8000073e:	00094503          	lbu	a0,0(s2)
    80000742:	f97d                	bnez	a0,80000738 <printf+0x268>
    80000744:	bd21                	j	8000055c <printf+0x8c>
        s = "(null)";
    80000746:	00007917          	auipc	s2,0x7
    8000074a:	8c290913          	addi	s2,s2,-1854 # 80007008 <etext+0x8>
      for(; *s; s++)
    8000074e:	02800513          	li	a0,40
    80000752:	b7dd                	j	80000738 <printf+0x268>
      consputc('%');
    80000754:	02500513          	li	a0,37
    80000758:	ae9ff0ef          	jal	80000240 <consputc>
    8000075c:	b501                	j	8000055c <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000075e:	f7843783          	ld	a5,-136(s0)
    80000762:	e385                	bnez	a5,80000782 <printf+0x2b2>
    80000764:	74e6                	ld	s1,120(sp)
    80000766:	7946                	ld	s2,112(sp)
    80000768:	79a6                	ld	s3,104(sp)
    8000076a:	6ae6                	ld	s5,88(sp)
    8000076c:	6b46                	ld	s6,80(sp)
    8000076e:	6c06                	ld	s8,64(sp)
    80000770:	7ce2                	ld	s9,56(sp)
    80000772:	7d42                	ld	s10,48(sp)
    80000774:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80000776:	4501                	li	a0,0
    80000778:	60aa                	ld	ra,136(sp)
    8000077a:	640a                	ld	s0,128(sp)
    8000077c:	7a06                	ld	s4,96(sp)
    8000077e:	6169                	addi	sp,sp,208
    80000780:	8082                	ret
    80000782:	74e6                	ld	s1,120(sp)
    80000784:	7946                	ld	s2,112(sp)
    80000786:	79a6                	ld	s3,104(sp)
    80000788:	6ae6                	ld	s5,88(sp)
    8000078a:	6b46                	ld	s6,80(sp)
    8000078c:	6c06                	ld	s8,64(sp)
    8000078e:	7ce2                	ld	s9,56(sp)
    80000790:	7d42                	ld	s10,48(sp)
    80000792:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80000794:	00012517          	auipc	a0,0x12
    80000798:	e6450513          	addi	a0,a0,-412 # 800125f8 <pr>
    8000079c:	4fe000ef          	jal	80000c9a <release>
    800007a0:	bfd9                	j	80000776 <printf+0x2a6>

00000000800007a2 <panic>:

void
panic(char *s)
{
    800007a2:	1101                	addi	sp,sp,-32
    800007a4:	ec06                	sd	ra,24(sp)
    800007a6:	e822                	sd	s0,16(sp)
    800007a8:	e426                	sd	s1,8(sp)
    800007aa:	1000                	addi	s0,sp,32
    800007ac:	84aa                	mv	s1,a0
  pr.locking = 0;
    800007ae:	00012797          	auipc	a5,0x12
    800007b2:	e607a123          	sw	zero,-414(a5) # 80012610 <pr+0x18>
  printf("panic: ");
    800007b6:	00007517          	auipc	a0,0x7
    800007ba:	86250513          	addi	a0,a0,-1950 # 80007018 <etext+0x18>
    800007be:	d13ff0ef          	jal	800004d0 <printf>
  printf("%s\n", s);
    800007c2:	85a6                	mv	a1,s1
    800007c4:	00007517          	auipc	a0,0x7
    800007c8:	85c50513          	addi	a0,a0,-1956 # 80007020 <etext+0x20>
    800007cc:	d05ff0ef          	jal	800004d0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007d0:	4785                	li	a5,1
    800007d2:	0000a717          	auipc	a4,0xa
    800007d6:	d2f72923          	sw	a5,-718(a4) # 8000a504 <panicked>
  for(;;)
    800007da:	a001                	j	800007da <panic+0x38>

00000000800007dc <printfinit>:
    ;
}

void
printfinit(void)
{
    800007dc:	1101                	addi	sp,sp,-32
    800007de:	ec06                	sd	ra,24(sp)
    800007e0:	e822                	sd	s0,16(sp)
    800007e2:	e426                	sd	s1,8(sp)
    800007e4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007e6:	00012497          	auipc	s1,0x12
    800007ea:	e1248493          	addi	s1,s1,-494 # 800125f8 <pr>
    800007ee:	00007597          	auipc	a1,0x7
    800007f2:	83a58593          	addi	a1,a1,-1990 # 80007028 <etext+0x28>
    800007f6:	8526                	mv	a0,s1
    800007f8:	38a000ef          	jal	80000b82 <initlock>
  pr.locking = 1;
    800007fc:	4785                	li	a5,1
    800007fe:	cc9c                	sw	a5,24(s1)
}
    80000800:	60e2                	ld	ra,24(sp)
    80000802:	6442                	ld	s0,16(sp)
    80000804:	64a2                	ld	s1,8(sp)
    80000806:	6105                	addi	sp,sp,32
    80000808:	8082                	ret

000000008000080a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000080a:	1141                	addi	sp,sp,-16
    8000080c:	e406                	sd	ra,8(sp)
    8000080e:	e022                	sd	s0,0(sp)
    80000810:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000812:	100007b7          	lui	a5,0x10000
    80000816:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000081a:	10000737          	lui	a4,0x10000
    8000081e:	f8000693          	li	a3,-128
    80000822:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000826:	468d                	li	a3,3
    80000828:	10000637          	lui	a2,0x10000
    8000082c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000830:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000834:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000838:	10000737          	lui	a4,0x10000
    8000083c:	461d                	li	a2,7
    8000083e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000842:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000846:	00006597          	auipc	a1,0x6
    8000084a:	7ea58593          	addi	a1,a1,2026 # 80007030 <etext+0x30>
    8000084e:	00012517          	auipc	a0,0x12
    80000852:	dca50513          	addi	a0,a0,-566 # 80012618 <uart_tx_lock>
    80000856:	32c000ef          	jal	80000b82 <initlock>
}
    8000085a:	60a2                	ld	ra,8(sp)
    8000085c:	6402                	ld	s0,0(sp)
    8000085e:	0141                	addi	sp,sp,16
    80000860:	8082                	ret

0000000080000862 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000862:	1101                	addi	sp,sp,-32
    80000864:	ec06                	sd	ra,24(sp)
    80000866:	e822                	sd	s0,16(sp)
    80000868:	e426                	sd	s1,8(sp)
    8000086a:	1000                	addi	s0,sp,32
    8000086c:	84aa                	mv	s1,a0
  push_off();
    8000086e:	354000ef          	jal	80000bc2 <push_off>

  if(panicked){
    80000872:	0000a797          	auipc	a5,0xa
    80000876:	c927a783          	lw	a5,-878(a5) # 8000a504 <panicked>
    8000087a:	e795                	bnez	a5,800008a6 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000087c:	10000737          	lui	a4,0x10000
    80000880:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000882:	00074783          	lbu	a5,0(a4)
    80000886:	0207f793          	andi	a5,a5,32
    8000088a:	dfe5                	beqz	a5,80000882 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000088c:	0ff4f513          	zext.b	a0,s1
    80000890:	100007b7          	lui	a5,0x10000
    80000894:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000898:	3ae000ef          	jal	80000c46 <pop_off>
}
    8000089c:	60e2                	ld	ra,24(sp)
    8000089e:	6442                	ld	s0,16(sp)
    800008a0:	64a2                	ld	s1,8(sp)
    800008a2:	6105                	addi	sp,sp,32
    800008a4:	8082                	ret
    for(;;)
    800008a6:	a001                	j	800008a6 <uartputc_sync+0x44>

00000000800008a8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800008a8:	0000a797          	auipc	a5,0xa
    800008ac:	c607b783          	ld	a5,-928(a5) # 8000a508 <uart_tx_r>
    800008b0:	0000a717          	auipc	a4,0xa
    800008b4:	c6073703          	ld	a4,-928(a4) # 8000a510 <uart_tx_w>
    800008b8:	08f70263          	beq	a4,a5,8000093c <uartstart+0x94>
{
    800008bc:	7139                	addi	sp,sp,-64
    800008be:	fc06                	sd	ra,56(sp)
    800008c0:	f822                	sd	s0,48(sp)
    800008c2:	f426                	sd	s1,40(sp)
    800008c4:	f04a                	sd	s2,32(sp)
    800008c6:	ec4e                	sd	s3,24(sp)
    800008c8:	e852                	sd	s4,16(sp)
    800008ca:	e456                	sd	s5,8(sp)
    800008cc:	e05a                	sd	s6,0(sp)
    800008ce:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008d0:	10000937          	lui	s2,0x10000
    800008d4:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008d6:	00012a97          	auipc	s5,0x12
    800008da:	d42a8a93          	addi	s5,s5,-702 # 80012618 <uart_tx_lock>
    uart_tx_r += 1;
    800008de:	0000a497          	auipc	s1,0xa
    800008e2:	c2a48493          	addi	s1,s1,-982 # 8000a508 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008e6:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008ea:	0000a997          	auipc	s3,0xa
    800008ee:	c2698993          	addi	s3,s3,-986 # 8000a510 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008f2:	00094703          	lbu	a4,0(s2)
    800008f6:	02077713          	andi	a4,a4,32
    800008fa:	c71d                	beqz	a4,80000928 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008fc:	01f7f713          	andi	a4,a5,31
    80000900:	9756                	add	a4,a4,s5
    80000902:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80000906:	0785                	addi	a5,a5,1
    80000908:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000090a:	8526                	mv	a0,s1
    8000090c:	1b1010ef          	jal	800022bc <wakeup>
    WriteReg(THR, c);
    80000910:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000914:	609c                	ld	a5,0(s1)
    80000916:	0009b703          	ld	a4,0(s3)
    8000091a:	fcf71ce3          	bne	a4,a5,800008f2 <uartstart+0x4a>
      ReadReg(ISR);
    8000091e:	100007b7          	lui	a5,0x10000
    80000922:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000924:	0007c783          	lbu	a5,0(a5)
  }
}
    80000928:	70e2                	ld	ra,56(sp)
    8000092a:	7442                	ld	s0,48(sp)
    8000092c:	74a2                	ld	s1,40(sp)
    8000092e:	7902                	ld	s2,32(sp)
    80000930:	69e2                	ld	s3,24(sp)
    80000932:	6a42                	ld	s4,16(sp)
    80000934:	6aa2                	ld	s5,8(sp)
    80000936:	6b02                	ld	s6,0(sp)
    80000938:	6121                	addi	sp,sp,64
    8000093a:	8082                	ret
      ReadReg(ISR);
    8000093c:	100007b7          	lui	a5,0x10000
    80000940:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000942:	0007c783          	lbu	a5,0(a5)
      return;
    80000946:	8082                	ret

0000000080000948 <uartputc>:
{
    80000948:	7179                	addi	sp,sp,-48
    8000094a:	f406                	sd	ra,40(sp)
    8000094c:	f022                	sd	s0,32(sp)
    8000094e:	ec26                	sd	s1,24(sp)
    80000950:	e84a                	sd	s2,16(sp)
    80000952:	e44e                	sd	s3,8(sp)
    80000954:	e052                	sd	s4,0(sp)
    80000956:	1800                	addi	s0,sp,48
    80000958:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000095a:	00012517          	auipc	a0,0x12
    8000095e:	cbe50513          	addi	a0,a0,-834 # 80012618 <uart_tx_lock>
    80000962:	2a0000ef          	jal	80000c02 <acquire>
  if(panicked){
    80000966:	0000a797          	auipc	a5,0xa
    8000096a:	b9e7a783          	lw	a5,-1122(a5) # 8000a504 <panicked>
    8000096e:	efbd                	bnez	a5,800009ec <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000970:	0000a717          	auipc	a4,0xa
    80000974:	ba073703          	ld	a4,-1120(a4) # 8000a510 <uart_tx_w>
    80000978:	0000a797          	auipc	a5,0xa
    8000097c:	b907b783          	ld	a5,-1136(a5) # 8000a508 <uart_tx_r>
    80000980:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000984:	00012997          	auipc	s3,0x12
    80000988:	c9498993          	addi	s3,s3,-876 # 80012618 <uart_tx_lock>
    8000098c:	0000a497          	auipc	s1,0xa
    80000990:	b7c48493          	addi	s1,s1,-1156 # 8000a508 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000994:	0000a917          	auipc	s2,0xa
    80000998:	b7c90913          	addi	s2,s2,-1156 # 8000a510 <uart_tx_w>
    8000099c:	00e79d63          	bne	a5,a4,800009b6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800009a0:	85ce                	mv	a1,s3
    800009a2:	8526                	mv	a0,s1
    800009a4:	76c010ef          	jal	80002110 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800009a8:	00093703          	ld	a4,0(s2)
    800009ac:	609c                	ld	a5,0(s1)
    800009ae:	02078793          	addi	a5,a5,32
    800009b2:	fee787e3          	beq	a5,a4,800009a0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009b6:	00012497          	auipc	s1,0x12
    800009ba:	c6248493          	addi	s1,s1,-926 # 80012618 <uart_tx_lock>
    800009be:	01f77793          	andi	a5,a4,31
    800009c2:	97a6                	add	a5,a5,s1
    800009c4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009c8:	0705                	addi	a4,a4,1
    800009ca:	0000a797          	auipc	a5,0xa
    800009ce:	b4e7b323          	sd	a4,-1210(a5) # 8000a510 <uart_tx_w>
  uartstart();
    800009d2:	ed7ff0ef          	jal	800008a8 <uartstart>
  release(&uart_tx_lock);
    800009d6:	8526                	mv	a0,s1
    800009d8:	2c2000ef          	jal	80000c9a <release>
}
    800009dc:	70a2                	ld	ra,40(sp)
    800009de:	7402                	ld	s0,32(sp)
    800009e0:	64e2                	ld	s1,24(sp)
    800009e2:	6942                	ld	s2,16(sp)
    800009e4:	69a2                	ld	s3,8(sp)
    800009e6:	6a02                	ld	s4,0(sp)
    800009e8:	6145                	addi	sp,sp,48
    800009ea:	8082                	ret
    for(;;)
    800009ec:	a001                	j	800009ec <uartputc+0xa4>

00000000800009ee <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009ee:	1141                	addi	sp,sp,-16
    800009f0:	e422                	sd	s0,8(sp)
    800009f2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009f4:	100007b7          	lui	a5,0x10000
    800009f8:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009fa:	0007c783          	lbu	a5,0(a5)
    800009fe:	8b85                	andi	a5,a5,1
    80000a00:	cb81                	beqz	a5,80000a10 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80000a02:	100007b7          	lui	a5,0x10000
    80000a06:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000a0a:	6422                	ld	s0,8(sp)
    80000a0c:	0141                	addi	sp,sp,16
    80000a0e:	8082                	ret
    return -1;
    80000a10:	557d                	li	a0,-1
    80000a12:	bfe5                	j	80000a0a <uartgetc+0x1c>

0000000080000a14 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a14:	1101                	addi	sp,sp,-32
    80000a16:	ec06                	sd	ra,24(sp)
    80000a18:	e822                	sd	s0,16(sp)
    80000a1a:	e426                	sd	s1,8(sp)
    80000a1c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a1e:	54fd                	li	s1,-1
    80000a20:	a019                	j	80000a26 <uartintr+0x12>
      break;
    consoleintr(c);
    80000a22:	851ff0ef          	jal	80000272 <consoleintr>
    int c = uartgetc();
    80000a26:	fc9ff0ef          	jal	800009ee <uartgetc>
    if(c == -1)
    80000a2a:	fe951ce3          	bne	a0,s1,80000a22 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a2e:	00012497          	auipc	s1,0x12
    80000a32:	bea48493          	addi	s1,s1,-1046 # 80012618 <uart_tx_lock>
    80000a36:	8526                	mv	a0,s1
    80000a38:	1ca000ef          	jal	80000c02 <acquire>
  uartstart();
    80000a3c:	e6dff0ef          	jal	800008a8 <uartstart>
  release(&uart_tx_lock);
    80000a40:	8526                	mv	a0,s1
    80000a42:	258000ef          	jal	80000c9a <release>
}
    80000a46:	60e2                	ld	ra,24(sp)
    80000a48:	6442                	ld	s0,16(sp)
    80000a4a:	64a2                	ld	s1,8(sp)
    80000a4c:	6105                	addi	sp,sp,32
    80000a4e:	8082                	ret

0000000080000a50 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a50:	1101                	addi	sp,sp,-32
    80000a52:	ec06                	sd	ra,24(sp)
    80000a54:	e822                	sd	s0,16(sp)
    80000a56:	e426                	sd	s1,8(sp)
    80000a58:	e04a                	sd	s2,0(sp)
    80000a5a:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a5c:	03451793          	slli	a5,a0,0x34
    80000a60:	e7a9                	bnez	a5,80000aaa <kfree+0x5a>
    80000a62:	84aa                	mv	s1,a0
    80000a64:	00023797          	auipc	a5,0x23
    80000a68:	41c78793          	addi	a5,a5,1052 # 80023e80 <end>
    80000a6c:	02f56f63          	bltu	a0,a5,80000aaa <kfree+0x5a>
    80000a70:	47c5                	li	a5,17
    80000a72:	07ee                	slli	a5,a5,0x1b
    80000a74:	02f57b63          	bgeu	a0,a5,80000aaa <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a78:	6605                	lui	a2,0x1
    80000a7a:	4585                	li	a1,1
    80000a7c:	25a000ef          	jal	80000cd6 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a80:	00012917          	auipc	s2,0x12
    80000a84:	bd090913          	addi	s2,s2,-1072 # 80012650 <kmem>
    80000a88:	854a                	mv	a0,s2
    80000a8a:	178000ef          	jal	80000c02 <acquire>
  r->next = kmem.freelist;
    80000a8e:	01893783          	ld	a5,24(s2)
    80000a92:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a94:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a98:	854a                	mv	a0,s2
    80000a9a:	200000ef          	jal	80000c9a <release>
}
    80000a9e:	60e2                	ld	ra,24(sp)
    80000aa0:	6442                	ld	s0,16(sp)
    80000aa2:	64a2                	ld	s1,8(sp)
    80000aa4:	6902                	ld	s2,0(sp)
    80000aa6:	6105                	addi	sp,sp,32
    80000aa8:	8082                	ret
    panic("kfree");
    80000aaa:	00006517          	auipc	a0,0x6
    80000aae:	58e50513          	addi	a0,a0,1422 # 80007038 <etext+0x38>
    80000ab2:	cf1ff0ef          	jal	800007a2 <panic>

0000000080000ab6 <freerange>:
{
    80000ab6:	7179                	addi	sp,sp,-48
    80000ab8:	f406                	sd	ra,40(sp)
    80000aba:	f022                	sd	s0,32(sp)
    80000abc:	ec26                	sd	s1,24(sp)
    80000abe:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ac0:	6785                	lui	a5,0x1
    80000ac2:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ac6:	00e504b3          	add	s1,a0,a4
    80000aca:	777d                	lui	a4,0xfffff
    80000acc:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ace:	94be                	add	s1,s1,a5
    80000ad0:	0295e263          	bltu	a1,s1,80000af4 <freerange+0x3e>
    80000ad4:	e84a                	sd	s2,16(sp)
    80000ad6:	e44e                	sd	s3,8(sp)
    80000ad8:	e052                	sd	s4,0(sp)
    80000ada:	892e                	mv	s2,a1
    kfree(p);
    80000adc:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ade:	6985                	lui	s3,0x1
    kfree(p);
    80000ae0:	01448533          	add	a0,s1,s4
    80000ae4:	f6dff0ef          	jal	80000a50 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae8:	94ce                	add	s1,s1,s3
    80000aea:	fe997be3          	bgeu	s2,s1,80000ae0 <freerange+0x2a>
    80000aee:	6942                	ld	s2,16(sp)
    80000af0:	69a2                	ld	s3,8(sp)
    80000af2:	6a02                	ld	s4,0(sp)
}
    80000af4:	70a2                	ld	ra,40(sp)
    80000af6:	7402                	ld	s0,32(sp)
    80000af8:	64e2                	ld	s1,24(sp)
    80000afa:	6145                	addi	sp,sp,48
    80000afc:	8082                	ret

0000000080000afe <kinit>:
{
    80000afe:	1141                	addi	sp,sp,-16
    80000b00:	e406                	sd	ra,8(sp)
    80000b02:	e022                	sd	s0,0(sp)
    80000b04:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b06:	00006597          	auipc	a1,0x6
    80000b0a:	53a58593          	addi	a1,a1,1338 # 80007040 <etext+0x40>
    80000b0e:	00012517          	auipc	a0,0x12
    80000b12:	b4250513          	addi	a0,a0,-1214 # 80012650 <kmem>
    80000b16:	06c000ef          	jal	80000b82 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b1a:	45c5                	li	a1,17
    80000b1c:	05ee                	slli	a1,a1,0x1b
    80000b1e:	00023517          	auipc	a0,0x23
    80000b22:	36250513          	addi	a0,a0,866 # 80023e80 <end>
    80000b26:	f91ff0ef          	jal	80000ab6 <freerange>
}
    80000b2a:	60a2                	ld	ra,8(sp)
    80000b2c:	6402                	ld	s0,0(sp)
    80000b2e:	0141                	addi	sp,sp,16
    80000b30:	8082                	ret

0000000080000b32 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b32:	1101                	addi	sp,sp,-32
    80000b34:	ec06                	sd	ra,24(sp)
    80000b36:	e822                	sd	s0,16(sp)
    80000b38:	e426                	sd	s1,8(sp)
    80000b3a:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b3c:	00012497          	auipc	s1,0x12
    80000b40:	b1448493          	addi	s1,s1,-1260 # 80012650 <kmem>
    80000b44:	8526                	mv	a0,s1
    80000b46:	0bc000ef          	jal	80000c02 <acquire>
  r = kmem.freelist;
    80000b4a:	6c84                	ld	s1,24(s1)
  if(r)
    80000b4c:	c485                	beqz	s1,80000b74 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b4e:	609c                	ld	a5,0(s1)
    80000b50:	00012517          	auipc	a0,0x12
    80000b54:	b0050513          	addi	a0,a0,-1280 # 80012650 <kmem>
    80000b58:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b5a:	140000ef          	jal	80000c9a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b5e:	6605                	lui	a2,0x1
    80000b60:	4595                	li	a1,5
    80000b62:	8526                	mv	a0,s1
    80000b64:	172000ef          	jal	80000cd6 <memset>
  return (void*)r;
}
    80000b68:	8526                	mv	a0,s1
    80000b6a:	60e2                	ld	ra,24(sp)
    80000b6c:	6442                	ld	s0,16(sp)
    80000b6e:	64a2                	ld	s1,8(sp)
    80000b70:	6105                	addi	sp,sp,32
    80000b72:	8082                	ret
  release(&kmem.lock);
    80000b74:	00012517          	auipc	a0,0x12
    80000b78:	adc50513          	addi	a0,a0,-1316 # 80012650 <kmem>
    80000b7c:	11e000ef          	jal	80000c9a <release>
  if(r)
    80000b80:	b7e5                	j	80000b68 <kalloc+0x36>

0000000080000b82 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b82:	1141                	addi	sp,sp,-16
    80000b84:	e422                	sd	s0,8(sp)
    80000b86:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b88:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b8a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b8e:	00053823          	sd	zero,16(a0)
}
    80000b92:	6422                	ld	s0,8(sp)
    80000b94:	0141                	addi	sp,sp,16
    80000b96:	8082                	ret

0000000080000b98 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b98:	411c                	lw	a5,0(a0)
    80000b9a:	e399                	bnez	a5,80000ba0 <holding+0x8>
    80000b9c:	4501                	li	a0,0
  return r;
}
    80000b9e:	8082                	ret
{
    80000ba0:	1101                	addi	sp,sp,-32
    80000ba2:	ec06                	sd	ra,24(sp)
    80000ba4:	e822                	sd	s0,16(sp)
    80000ba6:	e426                	sd	s1,8(sp)
    80000ba8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000baa:	6904                	ld	s1,16(a0)
    80000bac:	54b000ef          	jal	800018f6 <mycpu>
    80000bb0:	40a48533          	sub	a0,s1,a0
    80000bb4:	00153513          	seqz	a0,a0
}
    80000bb8:	60e2                	ld	ra,24(sp)
    80000bba:	6442                	ld	s0,16(sp)
    80000bbc:	64a2                	ld	s1,8(sp)
    80000bbe:	6105                	addi	sp,sp,32
    80000bc0:	8082                	ret

0000000080000bc2 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bc2:	1101                	addi	sp,sp,-32
    80000bc4:	ec06                	sd	ra,24(sp)
    80000bc6:	e822                	sd	s0,16(sp)
    80000bc8:	e426                	sd	s1,8(sp)
    80000bca:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bcc:	100024f3          	csrr	s1,sstatus
    80000bd0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bd4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bd6:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bda:	51d000ef          	jal	800018f6 <mycpu>
    80000bde:	5d3c                	lw	a5,120(a0)
    80000be0:	cb99                	beqz	a5,80000bf6 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000be2:	515000ef          	jal	800018f6 <mycpu>
    80000be6:	5d3c                	lw	a5,120(a0)
    80000be8:	2785                	addiw	a5,a5,1
    80000bea:	dd3c                	sw	a5,120(a0)
}
    80000bec:	60e2                	ld	ra,24(sp)
    80000bee:	6442                	ld	s0,16(sp)
    80000bf0:	64a2                	ld	s1,8(sp)
    80000bf2:	6105                	addi	sp,sp,32
    80000bf4:	8082                	ret
    mycpu()->intena = old;
    80000bf6:	501000ef          	jal	800018f6 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bfa:	8085                	srli	s1,s1,0x1
    80000bfc:	8885                	andi	s1,s1,1
    80000bfe:	dd64                	sw	s1,124(a0)
    80000c00:	b7cd                	j	80000be2 <push_off+0x20>

0000000080000c02 <acquire>:
{
    80000c02:	1101                	addi	sp,sp,-32
    80000c04:	ec06                	sd	ra,24(sp)
    80000c06:	e822                	sd	s0,16(sp)
    80000c08:	e426                	sd	s1,8(sp)
    80000c0a:	1000                	addi	s0,sp,32
    80000c0c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c0e:	fb5ff0ef          	jal	80000bc2 <push_off>
  if(holding(lk))
    80000c12:	8526                	mv	a0,s1
    80000c14:	f85ff0ef          	jal	80000b98 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c18:	4705                	li	a4,1
  if(holding(lk))
    80000c1a:	e105                	bnez	a0,80000c3a <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c1c:	87ba                	mv	a5,a4
    80000c1e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c22:	2781                	sext.w	a5,a5
    80000c24:	ffe5                	bnez	a5,80000c1c <acquire+0x1a>
  __sync_synchronize();
    80000c26:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c2a:	4cd000ef          	jal	800018f6 <mycpu>
    80000c2e:	e888                	sd	a0,16(s1)
}
    80000c30:	60e2                	ld	ra,24(sp)
    80000c32:	6442                	ld	s0,16(sp)
    80000c34:	64a2                	ld	s1,8(sp)
    80000c36:	6105                	addi	sp,sp,32
    80000c38:	8082                	ret
    panic("acquire");
    80000c3a:	00006517          	auipc	a0,0x6
    80000c3e:	40e50513          	addi	a0,a0,1038 # 80007048 <etext+0x48>
    80000c42:	b61ff0ef          	jal	800007a2 <panic>

0000000080000c46 <pop_off>:

void
pop_off(void)
{
    80000c46:	1141                	addi	sp,sp,-16
    80000c48:	e406                	sd	ra,8(sp)
    80000c4a:	e022                	sd	s0,0(sp)
    80000c4c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c4e:	4a9000ef          	jal	800018f6 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c52:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c56:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c58:	e78d                	bnez	a5,80000c82 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c5a:	5d3c                	lw	a5,120(a0)
    80000c5c:	02f05963          	blez	a5,80000c8e <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c60:	37fd                	addiw	a5,a5,-1
    80000c62:	0007871b          	sext.w	a4,a5
    80000c66:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c68:	eb09                	bnez	a4,80000c7a <pop_off+0x34>
    80000c6a:	5d7c                	lw	a5,124(a0)
    80000c6c:	c799                	beqz	a5,80000c7a <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c6e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c72:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c76:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c7a:	60a2                	ld	ra,8(sp)
    80000c7c:	6402                	ld	s0,0(sp)
    80000c7e:	0141                	addi	sp,sp,16
    80000c80:	8082                	ret
    panic("pop_off - interruptible");
    80000c82:	00006517          	auipc	a0,0x6
    80000c86:	3ce50513          	addi	a0,a0,974 # 80007050 <etext+0x50>
    80000c8a:	b19ff0ef          	jal	800007a2 <panic>
    panic("pop_off");
    80000c8e:	00006517          	auipc	a0,0x6
    80000c92:	3da50513          	addi	a0,a0,986 # 80007068 <etext+0x68>
    80000c96:	b0dff0ef          	jal	800007a2 <panic>

0000000080000c9a <release>:
{
    80000c9a:	1101                	addi	sp,sp,-32
    80000c9c:	ec06                	sd	ra,24(sp)
    80000c9e:	e822                	sd	s0,16(sp)
    80000ca0:	e426                	sd	s1,8(sp)
    80000ca2:	1000                	addi	s0,sp,32
    80000ca4:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000ca6:	ef3ff0ef          	jal	80000b98 <holding>
    80000caa:	c105                	beqz	a0,80000cca <release+0x30>
  lk->cpu = 0;
    80000cac:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cb0:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000cb4:	0310000f          	fence	rw,w
    80000cb8:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cbc:	f8bff0ef          	jal	80000c46 <pop_off>
}
    80000cc0:	60e2                	ld	ra,24(sp)
    80000cc2:	6442                	ld	s0,16(sp)
    80000cc4:	64a2                	ld	s1,8(sp)
    80000cc6:	6105                	addi	sp,sp,32
    80000cc8:	8082                	ret
    panic("release");
    80000cca:	00006517          	auipc	a0,0x6
    80000cce:	3a650513          	addi	a0,a0,934 # 80007070 <etext+0x70>
    80000cd2:	ad1ff0ef          	jal	800007a2 <panic>

0000000080000cd6 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cd6:	1141                	addi	sp,sp,-16
    80000cd8:	e422                	sd	s0,8(sp)
    80000cda:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cdc:	ca19                	beqz	a2,80000cf2 <memset+0x1c>
    80000cde:	87aa                	mv	a5,a0
    80000ce0:	1602                	slli	a2,a2,0x20
    80000ce2:	9201                	srli	a2,a2,0x20
    80000ce4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ce8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cec:	0785                	addi	a5,a5,1
    80000cee:	fee79de3          	bne	a5,a4,80000ce8 <memset+0x12>
  }
  return dst;
}
    80000cf2:	6422                	ld	s0,8(sp)
    80000cf4:	0141                	addi	sp,sp,16
    80000cf6:	8082                	ret

0000000080000cf8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cf8:	1141                	addi	sp,sp,-16
    80000cfa:	e422                	sd	s0,8(sp)
    80000cfc:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cfe:	ca05                	beqz	a2,80000d2e <memcmp+0x36>
    80000d00:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d04:	1682                	slli	a3,a3,0x20
    80000d06:	9281                	srli	a3,a3,0x20
    80000d08:	0685                	addi	a3,a3,1
    80000d0a:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d0c:	00054783          	lbu	a5,0(a0)
    80000d10:	0005c703          	lbu	a4,0(a1)
    80000d14:	00e79863          	bne	a5,a4,80000d24 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d18:	0505                	addi	a0,a0,1
    80000d1a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d1c:	fed518e3          	bne	a0,a3,80000d0c <memcmp+0x14>
  }

  return 0;
    80000d20:	4501                	li	a0,0
    80000d22:	a019                	j	80000d28 <memcmp+0x30>
      return *s1 - *s2;
    80000d24:	40e7853b          	subw	a0,a5,a4
}
    80000d28:	6422                	ld	s0,8(sp)
    80000d2a:	0141                	addi	sp,sp,16
    80000d2c:	8082                	ret
  return 0;
    80000d2e:	4501                	li	a0,0
    80000d30:	bfe5                	j	80000d28 <memcmp+0x30>

0000000080000d32 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d32:	1141                	addi	sp,sp,-16
    80000d34:	e422                	sd	s0,8(sp)
    80000d36:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d38:	c205                	beqz	a2,80000d58 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d3a:	02a5e263          	bltu	a1,a0,80000d5e <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d3e:	1602                	slli	a2,a2,0x20
    80000d40:	9201                	srli	a2,a2,0x20
    80000d42:	00c587b3          	add	a5,a1,a2
{
    80000d46:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d48:	0585                	addi	a1,a1,1
    80000d4a:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb181>
    80000d4c:	fff5c683          	lbu	a3,-1(a1)
    80000d50:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d54:	feb79ae3          	bne	a5,a1,80000d48 <memmove+0x16>

  return dst;
}
    80000d58:	6422                	ld	s0,8(sp)
    80000d5a:	0141                	addi	sp,sp,16
    80000d5c:	8082                	ret
  if(s < d && s + n > d){
    80000d5e:	02061693          	slli	a3,a2,0x20
    80000d62:	9281                	srli	a3,a3,0x20
    80000d64:	00d58733          	add	a4,a1,a3
    80000d68:	fce57be3          	bgeu	a0,a4,80000d3e <memmove+0xc>
    d += n;
    80000d6c:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d6e:	fff6079b          	addiw	a5,a2,-1
    80000d72:	1782                	slli	a5,a5,0x20
    80000d74:	9381                	srli	a5,a5,0x20
    80000d76:	fff7c793          	not	a5,a5
    80000d7a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d7c:	177d                	addi	a4,a4,-1
    80000d7e:	16fd                	addi	a3,a3,-1
    80000d80:	00074603          	lbu	a2,0(a4)
    80000d84:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d88:	fef71ae3          	bne	a4,a5,80000d7c <memmove+0x4a>
    80000d8c:	b7f1                	j	80000d58 <memmove+0x26>

0000000080000d8e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d8e:	1141                	addi	sp,sp,-16
    80000d90:	e406                	sd	ra,8(sp)
    80000d92:	e022                	sd	s0,0(sp)
    80000d94:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d96:	f9dff0ef          	jal	80000d32 <memmove>
}
    80000d9a:	60a2                	ld	ra,8(sp)
    80000d9c:	6402                	ld	s0,0(sp)
    80000d9e:	0141                	addi	sp,sp,16
    80000da0:	8082                	ret

0000000080000da2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000da2:	1141                	addi	sp,sp,-16
    80000da4:	e422                	sd	s0,8(sp)
    80000da6:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000da8:	ce11                	beqz	a2,80000dc4 <strncmp+0x22>
    80000daa:	00054783          	lbu	a5,0(a0)
    80000dae:	cf89                	beqz	a5,80000dc8 <strncmp+0x26>
    80000db0:	0005c703          	lbu	a4,0(a1)
    80000db4:	00f71a63          	bne	a4,a5,80000dc8 <strncmp+0x26>
    n--, p++, q++;
    80000db8:	367d                	addiw	a2,a2,-1
    80000dba:	0505                	addi	a0,a0,1
    80000dbc:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dbe:	f675                	bnez	a2,80000daa <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dc0:	4501                	li	a0,0
    80000dc2:	a801                	j	80000dd2 <strncmp+0x30>
    80000dc4:	4501                	li	a0,0
    80000dc6:	a031                	j	80000dd2 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000dc8:	00054503          	lbu	a0,0(a0)
    80000dcc:	0005c783          	lbu	a5,0(a1)
    80000dd0:	9d1d                	subw	a0,a0,a5
}
    80000dd2:	6422                	ld	s0,8(sp)
    80000dd4:	0141                	addi	sp,sp,16
    80000dd6:	8082                	ret

0000000080000dd8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dd8:	1141                	addi	sp,sp,-16
    80000dda:	e422                	sd	s0,8(sp)
    80000ddc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dde:	87aa                	mv	a5,a0
    80000de0:	86b2                	mv	a3,a2
    80000de2:	367d                	addiw	a2,a2,-1
    80000de4:	02d05563          	blez	a3,80000e0e <strncpy+0x36>
    80000de8:	0785                	addi	a5,a5,1
    80000dea:	0005c703          	lbu	a4,0(a1)
    80000dee:	fee78fa3          	sb	a4,-1(a5)
    80000df2:	0585                	addi	a1,a1,1
    80000df4:	f775                	bnez	a4,80000de0 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000df6:	873e                	mv	a4,a5
    80000df8:	9fb5                	addw	a5,a5,a3
    80000dfa:	37fd                	addiw	a5,a5,-1
    80000dfc:	00c05963          	blez	a2,80000e0e <strncpy+0x36>
    *s++ = 0;
    80000e00:	0705                	addi	a4,a4,1
    80000e02:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e06:	40e786bb          	subw	a3,a5,a4
    80000e0a:	fed04be3          	bgtz	a3,80000e00 <strncpy+0x28>
  return os;
}
    80000e0e:	6422                	ld	s0,8(sp)
    80000e10:	0141                	addi	sp,sp,16
    80000e12:	8082                	ret

0000000080000e14 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e14:	1141                	addi	sp,sp,-16
    80000e16:	e422                	sd	s0,8(sp)
    80000e18:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e1a:	02c05363          	blez	a2,80000e40 <safestrcpy+0x2c>
    80000e1e:	fff6069b          	addiw	a3,a2,-1
    80000e22:	1682                	slli	a3,a3,0x20
    80000e24:	9281                	srli	a3,a3,0x20
    80000e26:	96ae                	add	a3,a3,a1
    80000e28:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e2a:	00d58963          	beq	a1,a3,80000e3c <safestrcpy+0x28>
    80000e2e:	0585                	addi	a1,a1,1
    80000e30:	0785                	addi	a5,a5,1
    80000e32:	fff5c703          	lbu	a4,-1(a1)
    80000e36:	fee78fa3          	sb	a4,-1(a5)
    80000e3a:	fb65                	bnez	a4,80000e2a <safestrcpy+0x16>
    ;
  *s = 0;
    80000e3c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e40:	6422                	ld	s0,8(sp)
    80000e42:	0141                	addi	sp,sp,16
    80000e44:	8082                	ret

0000000080000e46 <strlen>:

int
strlen(const char *s)
{
    80000e46:	1141                	addi	sp,sp,-16
    80000e48:	e422                	sd	s0,8(sp)
    80000e4a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e4c:	00054783          	lbu	a5,0(a0)
    80000e50:	cf91                	beqz	a5,80000e6c <strlen+0x26>
    80000e52:	0505                	addi	a0,a0,1
    80000e54:	87aa                	mv	a5,a0
    80000e56:	86be                	mv	a3,a5
    80000e58:	0785                	addi	a5,a5,1
    80000e5a:	fff7c703          	lbu	a4,-1(a5)
    80000e5e:	ff65                	bnez	a4,80000e56 <strlen+0x10>
    80000e60:	40a6853b          	subw	a0,a3,a0
    80000e64:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e66:	6422                	ld	s0,8(sp)
    80000e68:	0141                	addi	sp,sp,16
    80000e6a:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e6c:	4501                	li	a0,0
    80000e6e:	bfe5                	j	80000e66 <strlen+0x20>

0000000080000e70 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e70:	1141                	addi	sp,sp,-16
    80000e72:	e406                	sd	ra,8(sp)
    80000e74:	e022                	sd	s0,0(sp)
    80000e76:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e78:	26f000ef          	jal	800018e6 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e7c:	00009717          	auipc	a4,0x9
    80000e80:	69c70713          	addi	a4,a4,1692 # 8000a518 <started>
  if(cpuid() == 0){
    80000e84:	c51d                	beqz	a0,80000eb2 <main+0x42>
    while(started == 0)
    80000e86:	431c                	lw	a5,0(a4)
    80000e88:	2781                	sext.w	a5,a5
    80000e8a:	dff5                	beqz	a5,80000e86 <main+0x16>
      ;
    __sync_synchronize();
    80000e8c:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000e90:	257000ef          	jal	800018e6 <cpuid>
    80000e94:	85aa                	mv	a1,a0
    80000e96:	00006517          	auipc	a0,0x6
    80000e9a:	20250513          	addi	a0,a0,514 # 80007098 <etext+0x98>
    80000e9e:	e32ff0ef          	jal	800004d0 <printf>
    kvminithart();    // turn on paging
    80000ea2:	080000ef          	jal	80000f22 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ea6:	103010ef          	jal	800027a8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000eaa:	0ff040ef          	jal	800057a8 <plicinithart>
  }

  scheduler();        
    80000eae:	0e4010ef          	jal	80001f92 <scheduler>
    consoleinit();
    80000eb2:	d48ff0ef          	jal	800003fa <consoleinit>
    printfinit();
    80000eb6:	927ff0ef          	jal	800007dc <printfinit>
    printf("\n");
    80000eba:	00006517          	auipc	a0,0x6
    80000ebe:	1be50513          	addi	a0,a0,446 # 80007078 <etext+0x78>
    80000ec2:	e0eff0ef          	jal	800004d0 <printf>
    printf("xv6 kernel is booting\n");
    80000ec6:	00006517          	auipc	a0,0x6
    80000eca:	1ba50513          	addi	a0,a0,442 # 80007080 <etext+0x80>
    80000ece:	e02ff0ef          	jal	800004d0 <printf>
    printf("\n");
    80000ed2:	00006517          	auipc	a0,0x6
    80000ed6:	1a650513          	addi	a0,a0,422 # 80007078 <etext+0x78>
    80000eda:	df6ff0ef          	jal	800004d0 <printf>
    kinit();         // physical page allocator
    80000ede:	c21ff0ef          	jal	80000afe <kinit>
    kvminit();       // create kernel page table
    80000ee2:	2ee000ef          	jal	800011d0 <kvminit>
    kvminithart();   // turn on paging
    80000ee6:	03c000ef          	jal	80000f22 <kvminithart>
    procinit();      // process table
    80000eea:	147000ef          	jal	80001830 <procinit>
    trapinit();      // trap vectors
    80000eee:	097010ef          	jal	80002784 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ef2:	0b7010ef          	jal	800027a8 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ef6:	099040ef          	jal	8000578e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000efa:	0af040ef          	jal	800057a8 <plicinithart>
    binit();         // buffer cache
    80000efe:	056020ef          	jal	80002f54 <binit>
    iinit();         // inode table
    80000f02:	648020ef          	jal	8000354a <iinit>
    fileinit();      // file table
    80000f06:	3f4030ef          	jal	800042fa <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f0a:	18f040ef          	jal	80005898 <virtio_disk_init>
    userinit();      // first user process
    80000f0e:	595000ef          	jal	80001ca2 <userinit>
    __sync_synchronize();
    80000f12:	0330000f          	fence	rw,rw
    started = 1;
    80000f16:	4785                	li	a5,1
    80000f18:	00009717          	auipc	a4,0x9
    80000f1c:	60f72023          	sw	a5,1536(a4) # 8000a518 <started>
    80000f20:	b779                	j	80000eae <main+0x3e>

0000000080000f22 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f22:	1141                	addi	sp,sp,-16
    80000f24:	e422                	sd	s0,8(sp)
    80000f26:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f28:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f2c:	00009797          	auipc	a5,0x9
    80000f30:	5f47b783          	ld	a5,1524(a5) # 8000a520 <kernel_pagetable>
    80000f34:	83b1                	srli	a5,a5,0xc
    80000f36:	577d                	li	a4,-1
    80000f38:	177e                	slli	a4,a4,0x3f
    80000f3a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f3c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f40:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f44:	6422                	ld	s0,8(sp)
    80000f46:	0141                	addi	sp,sp,16
    80000f48:	8082                	ret

0000000080000f4a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f4a:	7139                	addi	sp,sp,-64
    80000f4c:	fc06                	sd	ra,56(sp)
    80000f4e:	f822                	sd	s0,48(sp)
    80000f50:	f426                	sd	s1,40(sp)
    80000f52:	f04a                	sd	s2,32(sp)
    80000f54:	ec4e                	sd	s3,24(sp)
    80000f56:	e852                	sd	s4,16(sp)
    80000f58:	e456                	sd	s5,8(sp)
    80000f5a:	e05a                	sd	s6,0(sp)
    80000f5c:	0080                	addi	s0,sp,64
    80000f5e:	84aa                	mv	s1,a0
    80000f60:	89ae                	mv	s3,a1
    80000f62:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f64:	57fd                	li	a5,-1
    80000f66:	83e9                	srli	a5,a5,0x1a
    80000f68:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f6a:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f6c:	02b7fc63          	bgeu	a5,a1,80000fa4 <walk+0x5a>
    panic("walk");
    80000f70:	00006517          	auipc	a0,0x6
    80000f74:	14050513          	addi	a0,a0,320 # 800070b0 <etext+0xb0>
    80000f78:	82bff0ef          	jal	800007a2 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f7c:	060a8263          	beqz	s5,80000fe0 <walk+0x96>
    80000f80:	bb3ff0ef          	jal	80000b32 <kalloc>
    80000f84:	84aa                	mv	s1,a0
    80000f86:	c139                	beqz	a0,80000fcc <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f88:	6605                	lui	a2,0x1
    80000f8a:	4581                	li	a1,0
    80000f8c:	d4bff0ef          	jal	80000cd6 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f90:	00c4d793          	srli	a5,s1,0xc
    80000f94:	07aa                	slli	a5,a5,0xa
    80000f96:	0017e793          	ori	a5,a5,1
    80000f9a:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f9e:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb177>
    80000fa0:	036a0063          	beq	s4,s6,80000fc0 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000fa4:	0149d933          	srl	s2,s3,s4
    80000fa8:	1ff97913          	andi	s2,s2,511
    80000fac:	090e                	slli	s2,s2,0x3
    80000fae:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fb0:	00093483          	ld	s1,0(s2)
    80000fb4:	0014f793          	andi	a5,s1,1
    80000fb8:	d3f1                	beqz	a5,80000f7c <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fba:	80a9                	srli	s1,s1,0xa
    80000fbc:	04b2                	slli	s1,s1,0xc
    80000fbe:	b7c5                	j	80000f9e <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000fc0:	00c9d513          	srli	a0,s3,0xc
    80000fc4:	1ff57513          	andi	a0,a0,511
    80000fc8:	050e                	slli	a0,a0,0x3
    80000fca:	9526                	add	a0,a0,s1
}
    80000fcc:	70e2                	ld	ra,56(sp)
    80000fce:	7442                	ld	s0,48(sp)
    80000fd0:	74a2                	ld	s1,40(sp)
    80000fd2:	7902                	ld	s2,32(sp)
    80000fd4:	69e2                	ld	s3,24(sp)
    80000fd6:	6a42                	ld	s4,16(sp)
    80000fd8:	6aa2                	ld	s5,8(sp)
    80000fda:	6b02                	ld	s6,0(sp)
    80000fdc:	6121                	addi	sp,sp,64
    80000fde:	8082                	ret
        return 0;
    80000fe0:	4501                	li	a0,0
    80000fe2:	b7ed                	j	80000fcc <walk+0x82>

0000000080000fe4 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000fe4:	57fd                	li	a5,-1
    80000fe6:	83e9                	srli	a5,a5,0x1a
    80000fe8:	00b7f463          	bgeu	a5,a1,80000ff0 <walkaddr+0xc>
    return 0;
    80000fec:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fee:	8082                	ret
{
    80000ff0:	1141                	addi	sp,sp,-16
    80000ff2:	e406                	sd	ra,8(sp)
    80000ff4:	e022                	sd	s0,0(sp)
    80000ff6:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000ff8:	4601                	li	a2,0
    80000ffa:	f51ff0ef          	jal	80000f4a <walk>
  if(pte == 0)
    80000ffe:	c105                	beqz	a0,8000101e <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80001000:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001002:	0117f693          	andi	a3,a5,17
    80001006:	4745                	li	a4,17
    return 0;
    80001008:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000100a:	00e68663          	beq	a3,a4,80001016 <walkaddr+0x32>
}
    8000100e:	60a2                	ld	ra,8(sp)
    80001010:	6402                	ld	s0,0(sp)
    80001012:	0141                	addi	sp,sp,16
    80001014:	8082                	ret
  pa = PTE2PA(*pte);
    80001016:	83a9                	srli	a5,a5,0xa
    80001018:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000101c:	bfcd                	j	8000100e <walkaddr+0x2a>
    return 0;
    8000101e:	4501                	li	a0,0
    80001020:	b7fd                	j	8000100e <walkaddr+0x2a>

0000000080001022 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001022:	715d                	addi	sp,sp,-80
    80001024:	e486                	sd	ra,72(sp)
    80001026:	e0a2                	sd	s0,64(sp)
    80001028:	fc26                	sd	s1,56(sp)
    8000102a:	f84a                	sd	s2,48(sp)
    8000102c:	f44e                	sd	s3,40(sp)
    8000102e:	f052                	sd	s4,32(sp)
    80001030:	ec56                	sd	s5,24(sp)
    80001032:	e85a                	sd	s6,16(sp)
    80001034:	e45e                	sd	s7,8(sp)
    80001036:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001038:	03459793          	slli	a5,a1,0x34
    8000103c:	e7a9                	bnez	a5,80001086 <mappages+0x64>
    8000103e:	8aaa                	mv	s5,a0
    80001040:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001042:	03461793          	slli	a5,a2,0x34
    80001046:	e7b1                	bnez	a5,80001092 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80001048:	ca39                	beqz	a2,8000109e <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000104a:	77fd                	lui	a5,0xfffff
    8000104c:	963e                	add	a2,a2,a5
    8000104e:	00b609b3          	add	s3,a2,a1
  a = va;
    80001052:	892e                	mv	s2,a1
    80001054:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001058:	6b85                	lui	s7,0x1
    8000105a:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000105e:	4605                	li	a2,1
    80001060:	85ca                	mv	a1,s2
    80001062:	8556                	mv	a0,s5
    80001064:	ee7ff0ef          	jal	80000f4a <walk>
    80001068:	c539                	beqz	a0,800010b6 <mappages+0x94>
    if(*pte & PTE_V)
    8000106a:	611c                	ld	a5,0(a0)
    8000106c:	8b85                	andi	a5,a5,1
    8000106e:	ef95                	bnez	a5,800010aa <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001070:	80b1                	srli	s1,s1,0xc
    80001072:	04aa                	slli	s1,s1,0xa
    80001074:	0164e4b3          	or	s1,s1,s6
    80001078:	0014e493          	ori	s1,s1,1
    8000107c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000107e:	05390863          	beq	s2,s3,800010ce <mappages+0xac>
    a += PGSIZE;
    80001082:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001084:	bfd9                	j	8000105a <mappages+0x38>
    panic("mappages: va not aligned");
    80001086:	00006517          	auipc	a0,0x6
    8000108a:	03250513          	addi	a0,a0,50 # 800070b8 <etext+0xb8>
    8000108e:	f14ff0ef          	jal	800007a2 <panic>
    panic("mappages: size not aligned");
    80001092:	00006517          	auipc	a0,0x6
    80001096:	04650513          	addi	a0,a0,70 # 800070d8 <etext+0xd8>
    8000109a:	f08ff0ef          	jal	800007a2 <panic>
    panic("mappages: size");
    8000109e:	00006517          	auipc	a0,0x6
    800010a2:	05a50513          	addi	a0,a0,90 # 800070f8 <etext+0xf8>
    800010a6:	efcff0ef          	jal	800007a2 <panic>
      panic("mappages: remap");
    800010aa:	00006517          	auipc	a0,0x6
    800010ae:	05e50513          	addi	a0,a0,94 # 80007108 <etext+0x108>
    800010b2:	ef0ff0ef          	jal	800007a2 <panic>
      return -1;
    800010b6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010b8:	60a6                	ld	ra,72(sp)
    800010ba:	6406                	ld	s0,64(sp)
    800010bc:	74e2                	ld	s1,56(sp)
    800010be:	7942                	ld	s2,48(sp)
    800010c0:	79a2                	ld	s3,40(sp)
    800010c2:	7a02                	ld	s4,32(sp)
    800010c4:	6ae2                	ld	s5,24(sp)
    800010c6:	6b42                	ld	s6,16(sp)
    800010c8:	6ba2                	ld	s7,8(sp)
    800010ca:	6161                	addi	sp,sp,80
    800010cc:	8082                	ret
  return 0;
    800010ce:	4501                	li	a0,0
    800010d0:	b7e5                	j	800010b8 <mappages+0x96>

00000000800010d2 <kvmmap>:
{
    800010d2:	1141                	addi	sp,sp,-16
    800010d4:	e406                	sd	ra,8(sp)
    800010d6:	e022                	sd	s0,0(sp)
    800010d8:	0800                	addi	s0,sp,16
    800010da:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010dc:	86b2                	mv	a3,a2
    800010de:	863e                	mv	a2,a5
    800010e0:	f43ff0ef          	jal	80001022 <mappages>
    800010e4:	e509                	bnez	a0,800010ee <kvmmap+0x1c>
}
    800010e6:	60a2                	ld	ra,8(sp)
    800010e8:	6402                	ld	s0,0(sp)
    800010ea:	0141                	addi	sp,sp,16
    800010ec:	8082                	ret
    panic("kvmmap");
    800010ee:	00006517          	auipc	a0,0x6
    800010f2:	02a50513          	addi	a0,a0,42 # 80007118 <etext+0x118>
    800010f6:	eacff0ef          	jal	800007a2 <panic>

00000000800010fa <kvmmake>:
{
    800010fa:	1101                	addi	sp,sp,-32
    800010fc:	ec06                	sd	ra,24(sp)
    800010fe:	e822                	sd	s0,16(sp)
    80001100:	e426                	sd	s1,8(sp)
    80001102:	e04a                	sd	s2,0(sp)
    80001104:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001106:	a2dff0ef          	jal	80000b32 <kalloc>
    8000110a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000110c:	6605                	lui	a2,0x1
    8000110e:	4581                	li	a1,0
    80001110:	bc7ff0ef          	jal	80000cd6 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001114:	4719                	li	a4,6
    80001116:	6685                	lui	a3,0x1
    80001118:	10000637          	lui	a2,0x10000
    8000111c:	100005b7          	lui	a1,0x10000
    80001120:	8526                	mv	a0,s1
    80001122:	fb1ff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, 0x100000, 0x100000, PGSIZE, PTE_R | PTE_W);//added to shutdown
    80001126:	4719                	li	a4,6
    80001128:	6685                	lui	a3,0x1
    8000112a:	00100637          	lui	a2,0x100
    8000112e:	001005b7          	lui	a1,0x100
    80001132:	8526                	mv	a0,s1
    80001134:	f9fff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001138:	4719                	li	a4,6
    8000113a:	6685                	lui	a3,0x1
    8000113c:	10001637          	lui	a2,0x10001
    80001140:	100015b7          	lui	a1,0x10001
    80001144:	8526                	mv	a0,s1
    80001146:	f8dff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, CLINT, CLINT, 0x10000, PTE_R | PTE_W); //added to datetime
    8000114a:	4719                	li	a4,6
    8000114c:	66c1                	lui	a3,0x10
    8000114e:	02000637          	lui	a2,0x2000
    80001152:	020005b7          	lui	a1,0x2000
    80001156:	8526                	mv	a0,s1
    80001158:	f7bff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000115c:	4719                	li	a4,6
    8000115e:	040006b7          	lui	a3,0x4000
    80001162:	0c000637          	lui	a2,0xc000
    80001166:	0c0005b7          	lui	a1,0xc000
    8000116a:	8526                	mv	a0,s1
    8000116c:	f67ff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001170:	00006917          	auipc	s2,0x6
    80001174:	e9090913          	addi	s2,s2,-368 # 80007000 <etext>
    80001178:	4729                	li	a4,10
    8000117a:	80006697          	auipc	a3,0x80006
    8000117e:	e8668693          	addi	a3,a3,-378 # 7000 <_entry-0x7fff9000>
    80001182:	4605                	li	a2,1
    80001184:	067e                	slli	a2,a2,0x1f
    80001186:	85b2                	mv	a1,a2
    80001188:	8526                	mv	a0,s1
    8000118a:	f49ff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000118e:	46c5                	li	a3,17
    80001190:	06ee                	slli	a3,a3,0x1b
    80001192:	4719                	li	a4,6
    80001194:	412686b3          	sub	a3,a3,s2
    80001198:	864a                	mv	a2,s2
    8000119a:	85ca                	mv	a1,s2
    8000119c:	8526                	mv	a0,s1
    8000119e:	f35ff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011a2:	4729                	li	a4,10
    800011a4:	6685                	lui	a3,0x1
    800011a6:	00005617          	auipc	a2,0x5
    800011aa:	e5a60613          	addi	a2,a2,-422 # 80006000 <_trampoline>
    800011ae:	040005b7          	lui	a1,0x4000
    800011b2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011b4:	05b2                	slli	a1,a1,0xc
    800011b6:	8526                	mv	a0,s1
    800011b8:	f1bff0ef          	jal	800010d2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800011bc:	8526                	mv	a0,s1
    800011be:	5da000ef          	jal	80001798 <proc_mapstacks>
}
    800011c2:	8526                	mv	a0,s1
    800011c4:	60e2                	ld	ra,24(sp)
    800011c6:	6442                	ld	s0,16(sp)
    800011c8:	64a2                	ld	s1,8(sp)
    800011ca:	6902                	ld	s2,0(sp)
    800011cc:	6105                	addi	sp,sp,32
    800011ce:	8082                	ret

00000000800011d0 <kvminit>:
{
    800011d0:	1141                	addi	sp,sp,-16
    800011d2:	e406                	sd	ra,8(sp)
    800011d4:	e022                	sd	s0,0(sp)
    800011d6:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011d8:	f23ff0ef          	jal	800010fa <kvmmake>
    800011dc:	00009797          	auipc	a5,0x9
    800011e0:	34a7b223          	sd	a0,836(a5) # 8000a520 <kernel_pagetable>
}
    800011e4:	60a2                	ld	ra,8(sp)
    800011e6:	6402                	ld	s0,0(sp)
    800011e8:	0141                	addi	sp,sp,16
    800011ea:	8082                	ret

00000000800011ec <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011ec:	715d                	addi	sp,sp,-80
    800011ee:	e486                	sd	ra,72(sp)
    800011f0:	e0a2                	sd	s0,64(sp)
    800011f2:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011f4:	03459793          	slli	a5,a1,0x34
    800011f8:	e39d                	bnez	a5,8000121e <uvmunmap+0x32>
    800011fa:	f84a                	sd	s2,48(sp)
    800011fc:	f44e                	sd	s3,40(sp)
    800011fe:	f052                	sd	s4,32(sp)
    80001200:	ec56                	sd	s5,24(sp)
    80001202:	e85a                	sd	s6,16(sp)
    80001204:	e45e                	sd	s7,8(sp)
    80001206:	8a2a                	mv	s4,a0
    80001208:	892e                	mv	s2,a1
    8000120a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000120c:	0632                	slli	a2,a2,0xc
    8000120e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001212:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001214:	6b05                	lui	s6,0x1
    80001216:	0735ff63          	bgeu	a1,s3,80001294 <uvmunmap+0xa8>
    8000121a:	fc26                	sd	s1,56(sp)
    8000121c:	a0a9                	j	80001266 <uvmunmap+0x7a>
    8000121e:	fc26                	sd	s1,56(sp)
    80001220:	f84a                	sd	s2,48(sp)
    80001222:	f44e                	sd	s3,40(sp)
    80001224:	f052                	sd	s4,32(sp)
    80001226:	ec56                	sd	s5,24(sp)
    80001228:	e85a                	sd	s6,16(sp)
    8000122a:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000122c:	00006517          	auipc	a0,0x6
    80001230:	ef450513          	addi	a0,a0,-268 # 80007120 <etext+0x120>
    80001234:	d6eff0ef          	jal	800007a2 <panic>
      panic("uvmunmap: walk");
    80001238:	00006517          	auipc	a0,0x6
    8000123c:	f0050513          	addi	a0,a0,-256 # 80007138 <etext+0x138>
    80001240:	d62ff0ef          	jal	800007a2 <panic>
      panic("uvmunmap: not mapped");
    80001244:	00006517          	auipc	a0,0x6
    80001248:	f0450513          	addi	a0,a0,-252 # 80007148 <etext+0x148>
    8000124c:	d56ff0ef          	jal	800007a2 <panic>
      panic("uvmunmap: not a leaf");
    80001250:	00006517          	auipc	a0,0x6
    80001254:	f1050513          	addi	a0,a0,-240 # 80007160 <etext+0x160>
    80001258:	d4aff0ef          	jal	800007a2 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000125c:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001260:	995a                	add	s2,s2,s6
    80001262:	03397863          	bgeu	s2,s3,80001292 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001266:	4601                	li	a2,0
    80001268:	85ca                	mv	a1,s2
    8000126a:	8552                	mv	a0,s4
    8000126c:	cdfff0ef          	jal	80000f4a <walk>
    80001270:	84aa                	mv	s1,a0
    80001272:	d179                	beqz	a0,80001238 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001274:	6108                	ld	a0,0(a0)
    80001276:	00157793          	andi	a5,a0,1
    8000127a:	d7e9                	beqz	a5,80001244 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000127c:	3ff57793          	andi	a5,a0,1023
    80001280:	fd7788e3          	beq	a5,s7,80001250 <uvmunmap+0x64>
    if(do_free){
    80001284:	fc0a8ce3          	beqz	s5,8000125c <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    80001288:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000128a:	0532                	slli	a0,a0,0xc
    8000128c:	fc4ff0ef          	jal	80000a50 <kfree>
    80001290:	b7f1                	j	8000125c <uvmunmap+0x70>
    80001292:	74e2                	ld	s1,56(sp)
    80001294:	7942                	ld	s2,48(sp)
    80001296:	79a2                	ld	s3,40(sp)
    80001298:	7a02                	ld	s4,32(sp)
    8000129a:	6ae2                	ld	s5,24(sp)
    8000129c:	6b42                	ld	s6,16(sp)
    8000129e:	6ba2                	ld	s7,8(sp)
  }
}
    800012a0:	60a6                	ld	ra,72(sp)
    800012a2:	6406                	ld	s0,64(sp)
    800012a4:	6161                	addi	sp,sp,80
    800012a6:	8082                	ret

00000000800012a8 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800012a8:	1101                	addi	sp,sp,-32
    800012aa:	ec06                	sd	ra,24(sp)
    800012ac:	e822                	sd	s0,16(sp)
    800012ae:	e426                	sd	s1,8(sp)
    800012b0:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800012b2:	881ff0ef          	jal	80000b32 <kalloc>
    800012b6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800012b8:	c509                	beqz	a0,800012c2 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800012ba:	6605                	lui	a2,0x1
    800012bc:	4581                	li	a1,0
    800012be:	a19ff0ef          	jal	80000cd6 <memset>
  return pagetable;
}
    800012c2:	8526                	mv	a0,s1
    800012c4:	60e2                	ld	ra,24(sp)
    800012c6:	6442                	ld	s0,16(sp)
    800012c8:	64a2                	ld	s1,8(sp)
    800012ca:	6105                	addi	sp,sp,32
    800012cc:	8082                	ret

00000000800012ce <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800012ce:	7179                	addi	sp,sp,-48
    800012d0:	f406                	sd	ra,40(sp)
    800012d2:	f022                	sd	s0,32(sp)
    800012d4:	ec26                	sd	s1,24(sp)
    800012d6:	e84a                	sd	s2,16(sp)
    800012d8:	e44e                	sd	s3,8(sp)
    800012da:	e052                	sd	s4,0(sp)
    800012dc:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012de:	6785                	lui	a5,0x1
    800012e0:	04f67063          	bgeu	a2,a5,80001320 <uvmfirst+0x52>
    800012e4:	8a2a                	mv	s4,a0
    800012e6:	89ae                	mv	s3,a1
    800012e8:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012ea:	849ff0ef          	jal	80000b32 <kalloc>
    800012ee:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012f0:	6605                	lui	a2,0x1
    800012f2:	4581                	li	a1,0
    800012f4:	9e3ff0ef          	jal	80000cd6 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012f8:	4779                	li	a4,30
    800012fa:	86ca                	mv	a3,s2
    800012fc:	6605                	lui	a2,0x1
    800012fe:	4581                	li	a1,0
    80001300:	8552                	mv	a0,s4
    80001302:	d21ff0ef          	jal	80001022 <mappages>
  memmove(mem, src, sz);
    80001306:	8626                	mv	a2,s1
    80001308:	85ce                	mv	a1,s3
    8000130a:	854a                	mv	a0,s2
    8000130c:	a27ff0ef          	jal	80000d32 <memmove>
}
    80001310:	70a2                	ld	ra,40(sp)
    80001312:	7402                	ld	s0,32(sp)
    80001314:	64e2                	ld	s1,24(sp)
    80001316:	6942                	ld	s2,16(sp)
    80001318:	69a2                	ld	s3,8(sp)
    8000131a:	6a02                	ld	s4,0(sp)
    8000131c:	6145                	addi	sp,sp,48
    8000131e:	8082                	ret
    panic("uvmfirst: more than a page");
    80001320:	00006517          	auipc	a0,0x6
    80001324:	e5850513          	addi	a0,a0,-424 # 80007178 <etext+0x178>
    80001328:	c7aff0ef          	jal	800007a2 <panic>

000000008000132c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000132c:	1101                	addi	sp,sp,-32
    8000132e:	ec06                	sd	ra,24(sp)
    80001330:	e822                	sd	s0,16(sp)
    80001332:	e426                	sd	s1,8(sp)
    80001334:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001336:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001338:	00b67d63          	bgeu	a2,a1,80001352 <uvmdealloc+0x26>
    8000133c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000133e:	6785                	lui	a5,0x1
    80001340:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001342:	00f60733          	add	a4,a2,a5
    80001346:	76fd                	lui	a3,0xfffff
    80001348:	8f75                	and	a4,a4,a3
    8000134a:	97ae                	add	a5,a5,a1
    8000134c:	8ff5                	and	a5,a5,a3
    8000134e:	00f76863          	bltu	a4,a5,8000135e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001352:	8526                	mv	a0,s1
    80001354:	60e2                	ld	ra,24(sp)
    80001356:	6442                	ld	s0,16(sp)
    80001358:	64a2                	ld	s1,8(sp)
    8000135a:	6105                	addi	sp,sp,32
    8000135c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000135e:	8f99                	sub	a5,a5,a4
    80001360:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001362:	4685                	li	a3,1
    80001364:	0007861b          	sext.w	a2,a5
    80001368:	85ba                	mv	a1,a4
    8000136a:	e83ff0ef          	jal	800011ec <uvmunmap>
    8000136e:	b7d5                	j	80001352 <uvmdealloc+0x26>

0000000080001370 <uvmalloc>:
  if(newsz < oldsz)
    80001370:	08b66f63          	bltu	a2,a1,8000140e <uvmalloc+0x9e>
{
    80001374:	7139                	addi	sp,sp,-64
    80001376:	fc06                	sd	ra,56(sp)
    80001378:	f822                	sd	s0,48(sp)
    8000137a:	ec4e                	sd	s3,24(sp)
    8000137c:	e852                	sd	s4,16(sp)
    8000137e:	e456                	sd	s5,8(sp)
    80001380:	0080                	addi	s0,sp,64
    80001382:	8aaa                	mv	s5,a0
    80001384:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001386:	6785                	lui	a5,0x1
    80001388:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000138a:	95be                	add	a1,a1,a5
    8000138c:	77fd                	lui	a5,0xfffff
    8000138e:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001392:	08c9f063          	bgeu	s3,a2,80001412 <uvmalloc+0xa2>
    80001396:	f426                	sd	s1,40(sp)
    80001398:	f04a                	sd	s2,32(sp)
    8000139a:	e05a                	sd	s6,0(sp)
    8000139c:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000139e:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800013a2:	f90ff0ef          	jal	80000b32 <kalloc>
    800013a6:	84aa                	mv	s1,a0
    if(mem == 0){
    800013a8:	c515                	beqz	a0,800013d4 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800013aa:	6605                	lui	a2,0x1
    800013ac:	4581                	li	a1,0
    800013ae:	929ff0ef          	jal	80000cd6 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800013b2:	875a                	mv	a4,s6
    800013b4:	86a6                	mv	a3,s1
    800013b6:	6605                	lui	a2,0x1
    800013b8:	85ca                	mv	a1,s2
    800013ba:	8556                	mv	a0,s5
    800013bc:	c67ff0ef          	jal	80001022 <mappages>
    800013c0:	e915                	bnez	a0,800013f4 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800013c2:	6785                	lui	a5,0x1
    800013c4:	993e                	add	s2,s2,a5
    800013c6:	fd496ee3          	bltu	s2,s4,800013a2 <uvmalloc+0x32>
  return newsz;
    800013ca:	8552                	mv	a0,s4
    800013cc:	74a2                	ld	s1,40(sp)
    800013ce:	7902                	ld	s2,32(sp)
    800013d0:	6b02                	ld	s6,0(sp)
    800013d2:	a811                	j	800013e6 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800013d4:	864e                	mv	a2,s3
    800013d6:	85ca                	mv	a1,s2
    800013d8:	8556                	mv	a0,s5
    800013da:	f53ff0ef          	jal	8000132c <uvmdealloc>
      return 0;
    800013de:	4501                	li	a0,0
    800013e0:	74a2                	ld	s1,40(sp)
    800013e2:	7902                	ld	s2,32(sp)
    800013e4:	6b02                	ld	s6,0(sp)
}
    800013e6:	70e2                	ld	ra,56(sp)
    800013e8:	7442                	ld	s0,48(sp)
    800013ea:	69e2                	ld	s3,24(sp)
    800013ec:	6a42                	ld	s4,16(sp)
    800013ee:	6aa2                	ld	s5,8(sp)
    800013f0:	6121                	addi	sp,sp,64
    800013f2:	8082                	ret
      kfree(mem);
    800013f4:	8526                	mv	a0,s1
    800013f6:	e5aff0ef          	jal	80000a50 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013fa:	864e                	mv	a2,s3
    800013fc:	85ca                	mv	a1,s2
    800013fe:	8556                	mv	a0,s5
    80001400:	f2dff0ef          	jal	8000132c <uvmdealloc>
      return 0;
    80001404:	4501                	li	a0,0
    80001406:	74a2                	ld	s1,40(sp)
    80001408:	7902                	ld	s2,32(sp)
    8000140a:	6b02                	ld	s6,0(sp)
    8000140c:	bfe9                	j	800013e6 <uvmalloc+0x76>
    return oldsz;
    8000140e:	852e                	mv	a0,a1
}
    80001410:	8082                	ret
  return newsz;
    80001412:	8532                	mv	a0,a2
    80001414:	bfc9                	j	800013e6 <uvmalloc+0x76>

0000000080001416 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001416:	7179                	addi	sp,sp,-48
    80001418:	f406                	sd	ra,40(sp)
    8000141a:	f022                	sd	s0,32(sp)
    8000141c:	ec26                	sd	s1,24(sp)
    8000141e:	e84a                	sd	s2,16(sp)
    80001420:	e44e                	sd	s3,8(sp)
    80001422:	e052                	sd	s4,0(sp)
    80001424:	1800                	addi	s0,sp,48
    80001426:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001428:	84aa                	mv	s1,a0
    8000142a:	6905                	lui	s2,0x1
    8000142c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000142e:	4985                	li	s3,1
    80001430:	a819                	j	80001446 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001432:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001434:	00c79513          	slli	a0,a5,0xc
    80001438:	fdfff0ef          	jal	80001416 <freewalk>
      pagetable[i] = 0;
    8000143c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001440:	04a1                	addi	s1,s1,8
    80001442:	01248f63          	beq	s1,s2,80001460 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001446:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001448:	00f7f713          	andi	a4,a5,15
    8000144c:	ff3703e3          	beq	a4,s3,80001432 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001450:	8b85                	andi	a5,a5,1
    80001452:	d7fd                	beqz	a5,80001440 <freewalk+0x2a>
      panic("freewalk: leaf");
    80001454:	00006517          	auipc	a0,0x6
    80001458:	d4450513          	addi	a0,a0,-700 # 80007198 <etext+0x198>
    8000145c:	b46ff0ef          	jal	800007a2 <panic>
    }
  }
  kfree((void*)pagetable);
    80001460:	8552                	mv	a0,s4
    80001462:	deeff0ef          	jal	80000a50 <kfree>
}
    80001466:	70a2                	ld	ra,40(sp)
    80001468:	7402                	ld	s0,32(sp)
    8000146a:	64e2                	ld	s1,24(sp)
    8000146c:	6942                	ld	s2,16(sp)
    8000146e:	69a2                	ld	s3,8(sp)
    80001470:	6a02                	ld	s4,0(sp)
    80001472:	6145                	addi	sp,sp,48
    80001474:	8082                	ret

0000000080001476 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001476:	1101                	addi	sp,sp,-32
    80001478:	ec06                	sd	ra,24(sp)
    8000147a:	e822                	sd	s0,16(sp)
    8000147c:	e426                	sd	s1,8(sp)
    8000147e:	1000                	addi	s0,sp,32
    80001480:	84aa                	mv	s1,a0
  if(sz > 0)
    80001482:	e989                	bnez	a1,80001494 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001484:	8526                	mv	a0,s1
    80001486:	f91ff0ef          	jal	80001416 <freewalk>
}
    8000148a:	60e2                	ld	ra,24(sp)
    8000148c:	6442                	ld	s0,16(sp)
    8000148e:	64a2                	ld	s1,8(sp)
    80001490:	6105                	addi	sp,sp,32
    80001492:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001494:	6785                	lui	a5,0x1
    80001496:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001498:	95be                	add	a1,a1,a5
    8000149a:	4685                	li	a3,1
    8000149c:	00c5d613          	srli	a2,a1,0xc
    800014a0:	4581                	li	a1,0
    800014a2:	d4bff0ef          	jal	800011ec <uvmunmap>
    800014a6:	bff9                	j	80001484 <uvmfree+0xe>

00000000800014a8 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800014a8:	c65d                	beqz	a2,80001556 <uvmcopy+0xae>
{
    800014aa:	715d                	addi	sp,sp,-80
    800014ac:	e486                	sd	ra,72(sp)
    800014ae:	e0a2                	sd	s0,64(sp)
    800014b0:	fc26                	sd	s1,56(sp)
    800014b2:	f84a                	sd	s2,48(sp)
    800014b4:	f44e                	sd	s3,40(sp)
    800014b6:	f052                	sd	s4,32(sp)
    800014b8:	ec56                	sd	s5,24(sp)
    800014ba:	e85a                	sd	s6,16(sp)
    800014bc:	e45e                	sd	s7,8(sp)
    800014be:	0880                	addi	s0,sp,80
    800014c0:	8b2a                	mv	s6,a0
    800014c2:	8aae                	mv	s5,a1
    800014c4:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800014c6:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800014c8:	4601                	li	a2,0
    800014ca:	85ce                	mv	a1,s3
    800014cc:	855a                	mv	a0,s6
    800014ce:	a7dff0ef          	jal	80000f4a <walk>
    800014d2:	c121                	beqz	a0,80001512 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800014d4:	6118                	ld	a4,0(a0)
    800014d6:	00177793          	andi	a5,a4,1
    800014da:	c3b1                	beqz	a5,8000151e <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800014dc:	00a75593          	srli	a1,a4,0xa
    800014e0:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014e4:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014e8:	e4aff0ef          	jal	80000b32 <kalloc>
    800014ec:	892a                	mv	s2,a0
    800014ee:	c129                	beqz	a0,80001530 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014f0:	6605                	lui	a2,0x1
    800014f2:	85de                	mv	a1,s7
    800014f4:	83fff0ef          	jal	80000d32 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014f8:	8726                	mv	a4,s1
    800014fa:	86ca                	mv	a3,s2
    800014fc:	6605                	lui	a2,0x1
    800014fe:	85ce                	mv	a1,s3
    80001500:	8556                	mv	a0,s5
    80001502:	b21ff0ef          	jal	80001022 <mappages>
    80001506:	e115                	bnez	a0,8000152a <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    80001508:	6785                	lui	a5,0x1
    8000150a:	99be                	add	s3,s3,a5
    8000150c:	fb49eee3          	bltu	s3,s4,800014c8 <uvmcopy+0x20>
    80001510:	a805                	j	80001540 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80001512:	00006517          	auipc	a0,0x6
    80001516:	c9650513          	addi	a0,a0,-874 # 800071a8 <etext+0x1a8>
    8000151a:	a88ff0ef          	jal	800007a2 <panic>
      panic("uvmcopy: page not present");
    8000151e:	00006517          	auipc	a0,0x6
    80001522:	caa50513          	addi	a0,a0,-854 # 800071c8 <etext+0x1c8>
    80001526:	a7cff0ef          	jal	800007a2 <panic>
      kfree(mem);
    8000152a:	854a                	mv	a0,s2
    8000152c:	d24ff0ef          	jal	80000a50 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001530:	4685                	li	a3,1
    80001532:	00c9d613          	srli	a2,s3,0xc
    80001536:	4581                	li	a1,0
    80001538:	8556                	mv	a0,s5
    8000153a:	cb3ff0ef          	jal	800011ec <uvmunmap>
  return -1;
    8000153e:	557d                	li	a0,-1
}
    80001540:	60a6                	ld	ra,72(sp)
    80001542:	6406                	ld	s0,64(sp)
    80001544:	74e2                	ld	s1,56(sp)
    80001546:	7942                	ld	s2,48(sp)
    80001548:	79a2                	ld	s3,40(sp)
    8000154a:	7a02                	ld	s4,32(sp)
    8000154c:	6ae2                	ld	s5,24(sp)
    8000154e:	6b42                	ld	s6,16(sp)
    80001550:	6ba2                	ld	s7,8(sp)
    80001552:	6161                	addi	sp,sp,80
    80001554:	8082                	ret
  return 0;
    80001556:	4501                	li	a0,0
}
    80001558:	8082                	ret

000000008000155a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000155a:	1141                	addi	sp,sp,-16
    8000155c:	e406                	sd	ra,8(sp)
    8000155e:	e022                	sd	s0,0(sp)
    80001560:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001562:	4601                	li	a2,0
    80001564:	9e7ff0ef          	jal	80000f4a <walk>
  if(pte == 0)
    80001568:	c901                	beqz	a0,80001578 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000156a:	611c                	ld	a5,0(a0)
    8000156c:	9bbd                	andi	a5,a5,-17
    8000156e:	e11c                	sd	a5,0(a0)
}
    80001570:	60a2                	ld	ra,8(sp)
    80001572:	6402                	ld	s0,0(sp)
    80001574:	0141                	addi	sp,sp,16
    80001576:	8082                	ret
    panic("uvmclear");
    80001578:	00006517          	auipc	a0,0x6
    8000157c:	c7050513          	addi	a0,a0,-912 # 800071e8 <etext+0x1e8>
    80001580:	a22ff0ef          	jal	800007a2 <panic>

0000000080001584 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001584:	cad1                	beqz	a3,80001618 <copyout+0x94>
{
    80001586:	711d                	addi	sp,sp,-96
    80001588:	ec86                	sd	ra,88(sp)
    8000158a:	e8a2                	sd	s0,80(sp)
    8000158c:	e4a6                	sd	s1,72(sp)
    8000158e:	fc4e                	sd	s3,56(sp)
    80001590:	f456                	sd	s5,40(sp)
    80001592:	f05a                	sd	s6,32(sp)
    80001594:	ec5e                	sd	s7,24(sp)
    80001596:	1080                	addi	s0,sp,96
    80001598:	8baa                	mv	s7,a0
    8000159a:	8aae                	mv	s5,a1
    8000159c:	8b32                	mv	s6,a2
    8000159e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800015a0:	74fd                	lui	s1,0xfffff
    800015a2:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    800015a4:	57fd                	li	a5,-1
    800015a6:	83e9                	srli	a5,a5,0x1a
    800015a8:	0697ea63          	bltu	a5,s1,8000161c <copyout+0x98>
    800015ac:	e0ca                	sd	s2,64(sp)
    800015ae:	f852                	sd	s4,48(sp)
    800015b0:	e862                	sd	s8,16(sp)
    800015b2:	e466                	sd	s9,8(sp)
    800015b4:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015b6:	4cd5                	li	s9,21
    800015b8:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    800015ba:	8c3e                	mv	s8,a5
    800015bc:	a025                	j	800015e4 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    800015be:	83a9                	srli	a5,a5,0xa
    800015c0:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800015c2:	409a8533          	sub	a0,s5,s1
    800015c6:	0009061b          	sext.w	a2,s2
    800015ca:	85da                	mv	a1,s6
    800015cc:	953e                	add	a0,a0,a5
    800015ce:	f64ff0ef          	jal	80000d32 <memmove>

    len -= n;
    800015d2:	412989b3          	sub	s3,s3,s2
    src += n;
    800015d6:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800015d8:	02098963          	beqz	s3,8000160a <copyout+0x86>
    if(va0 >= MAXVA)
    800015dc:	054c6263          	bltu	s8,s4,80001620 <copyout+0x9c>
    800015e0:	84d2                	mv	s1,s4
    800015e2:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    800015e4:	4601                	li	a2,0
    800015e6:	85a6                	mv	a1,s1
    800015e8:	855e                	mv	a0,s7
    800015ea:	961ff0ef          	jal	80000f4a <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015ee:	c121                	beqz	a0,8000162e <copyout+0xaa>
    800015f0:	611c                	ld	a5,0(a0)
    800015f2:	0157f713          	andi	a4,a5,21
    800015f6:	05971b63          	bne	a4,s9,8000164c <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    800015fa:	01a48a33          	add	s4,s1,s10
    800015fe:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80001602:	fb29fee3          	bgeu	s3,s2,800015be <copyout+0x3a>
    80001606:	894e                	mv	s2,s3
    80001608:	bf5d                	j	800015be <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    8000160a:	4501                	li	a0,0
    8000160c:	6906                	ld	s2,64(sp)
    8000160e:	7a42                	ld	s4,48(sp)
    80001610:	6c42                	ld	s8,16(sp)
    80001612:	6ca2                	ld	s9,8(sp)
    80001614:	6d02                	ld	s10,0(sp)
    80001616:	a015                	j	8000163a <copyout+0xb6>
    80001618:	4501                	li	a0,0
}
    8000161a:	8082                	ret
      return -1;
    8000161c:	557d                	li	a0,-1
    8000161e:	a831                	j	8000163a <copyout+0xb6>
    80001620:	557d                	li	a0,-1
    80001622:	6906                	ld	s2,64(sp)
    80001624:	7a42                	ld	s4,48(sp)
    80001626:	6c42                	ld	s8,16(sp)
    80001628:	6ca2                	ld	s9,8(sp)
    8000162a:	6d02                	ld	s10,0(sp)
    8000162c:	a039                	j	8000163a <copyout+0xb6>
      return -1;
    8000162e:	557d                	li	a0,-1
    80001630:	6906                	ld	s2,64(sp)
    80001632:	7a42                	ld	s4,48(sp)
    80001634:	6c42                	ld	s8,16(sp)
    80001636:	6ca2                	ld	s9,8(sp)
    80001638:	6d02                	ld	s10,0(sp)
}
    8000163a:	60e6                	ld	ra,88(sp)
    8000163c:	6446                	ld	s0,80(sp)
    8000163e:	64a6                	ld	s1,72(sp)
    80001640:	79e2                	ld	s3,56(sp)
    80001642:	7aa2                	ld	s5,40(sp)
    80001644:	7b02                	ld	s6,32(sp)
    80001646:	6be2                	ld	s7,24(sp)
    80001648:	6125                	addi	sp,sp,96
    8000164a:	8082                	ret
      return -1;
    8000164c:	557d                	li	a0,-1
    8000164e:	6906                	ld	s2,64(sp)
    80001650:	7a42                	ld	s4,48(sp)
    80001652:	6c42                	ld	s8,16(sp)
    80001654:	6ca2                	ld	s9,8(sp)
    80001656:	6d02                	ld	s10,0(sp)
    80001658:	b7cd                	j	8000163a <copyout+0xb6>

000000008000165a <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000165a:	c6a5                	beqz	a3,800016c2 <copyin+0x68>
{
    8000165c:	715d                	addi	sp,sp,-80
    8000165e:	e486                	sd	ra,72(sp)
    80001660:	e0a2                	sd	s0,64(sp)
    80001662:	fc26                	sd	s1,56(sp)
    80001664:	f84a                	sd	s2,48(sp)
    80001666:	f44e                	sd	s3,40(sp)
    80001668:	f052                	sd	s4,32(sp)
    8000166a:	ec56                	sd	s5,24(sp)
    8000166c:	e85a                	sd	s6,16(sp)
    8000166e:	e45e                	sd	s7,8(sp)
    80001670:	e062                	sd	s8,0(sp)
    80001672:	0880                	addi	s0,sp,80
    80001674:	8b2a                	mv	s6,a0
    80001676:	8a2e                	mv	s4,a1
    80001678:	8c32                	mv	s8,a2
    8000167a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000167c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000167e:	6a85                	lui	s5,0x1
    80001680:	a00d                	j	800016a2 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001682:	018505b3          	add	a1,a0,s8
    80001686:	0004861b          	sext.w	a2,s1
    8000168a:	412585b3          	sub	a1,a1,s2
    8000168e:	8552                	mv	a0,s4
    80001690:	ea2ff0ef          	jal	80000d32 <memmove>

    len -= n;
    80001694:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001698:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000169a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000169e:	02098063          	beqz	s3,800016be <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    800016a2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016a6:	85ca                	mv	a1,s2
    800016a8:	855a                	mv	a0,s6
    800016aa:	93bff0ef          	jal	80000fe4 <walkaddr>
    if(pa0 == 0)
    800016ae:	cd01                	beqz	a0,800016c6 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    800016b0:	418904b3          	sub	s1,s2,s8
    800016b4:	94d6                	add	s1,s1,s5
    if(n > len)
    800016b6:	fc99f6e3          	bgeu	s3,s1,80001682 <copyin+0x28>
    800016ba:	84ce                	mv	s1,s3
    800016bc:	b7d9                	j	80001682 <copyin+0x28>
  }
  return 0;
    800016be:	4501                	li	a0,0
    800016c0:	a021                	j	800016c8 <copyin+0x6e>
    800016c2:	4501                	li	a0,0
}
    800016c4:	8082                	ret
      return -1;
    800016c6:	557d                	li	a0,-1
}
    800016c8:	60a6                	ld	ra,72(sp)
    800016ca:	6406                	ld	s0,64(sp)
    800016cc:	74e2                	ld	s1,56(sp)
    800016ce:	7942                	ld	s2,48(sp)
    800016d0:	79a2                	ld	s3,40(sp)
    800016d2:	7a02                	ld	s4,32(sp)
    800016d4:	6ae2                	ld	s5,24(sp)
    800016d6:	6b42                	ld	s6,16(sp)
    800016d8:	6ba2                	ld	s7,8(sp)
    800016da:	6c02                	ld	s8,0(sp)
    800016dc:	6161                	addi	sp,sp,80
    800016de:	8082                	ret

00000000800016e0 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800016e0:	c6dd                	beqz	a3,8000178e <copyinstr+0xae>
{
    800016e2:	715d                	addi	sp,sp,-80
    800016e4:	e486                	sd	ra,72(sp)
    800016e6:	e0a2                	sd	s0,64(sp)
    800016e8:	fc26                	sd	s1,56(sp)
    800016ea:	f84a                	sd	s2,48(sp)
    800016ec:	f44e                	sd	s3,40(sp)
    800016ee:	f052                	sd	s4,32(sp)
    800016f0:	ec56                	sd	s5,24(sp)
    800016f2:	e85a                	sd	s6,16(sp)
    800016f4:	e45e                	sd	s7,8(sp)
    800016f6:	0880                	addi	s0,sp,80
    800016f8:	8a2a                	mv	s4,a0
    800016fa:	8b2e                	mv	s6,a1
    800016fc:	8bb2                	mv	s7,a2
    800016fe:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80001700:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001702:	6985                	lui	s3,0x1
    80001704:	a825                	j	8000173c <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001706:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000170a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000170c:	37fd                	addiw	a5,a5,-1
    8000170e:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001712:	60a6                	ld	ra,72(sp)
    80001714:	6406                	ld	s0,64(sp)
    80001716:	74e2                	ld	s1,56(sp)
    80001718:	7942                	ld	s2,48(sp)
    8000171a:	79a2                	ld	s3,40(sp)
    8000171c:	7a02                	ld	s4,32(sp)
    8000171e:	6ae2                	ld	s5,24(sp)
    80001720:	6b42                	ld	s6,16(sp)
    80001722:	6ba2                	ld	s7,8(sp)
    80001724:	6161                	addi	sp,sp,80
    80001726:	8082                	ret
    80001728:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    8000172c:	9742                	add	a4,a4,a6
      --max;
    8000172e:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001732:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001736:	04e58463          	beq	a1,a4,8000177e <copyinstr+0x9e>
{
    8000173a:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    8000173c:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001740:	85a6                	mv	a1,s1
    80001742:	8552                	mv	a0,s4
    80001744:	8a1ff0ef          	jal	80000fe4 <walkaddr>
    if(pa0 == 0)
    80001748:	cd0d                	beqz	a0,80001782 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    8000174a:	417486b3          	sub	a3,s1,s7
    8000174e:	96ce                	add	a3,a3,s3
    if(n > max)
    80001750:	00d97363          	bgeu	s2,a3,80001756 <copyinstr+0x76>
    80001754:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001756:	955e                	add	a0,a0,s7
    80001758:	8d05                	sub	a0,a0,s1
    while(n > 0){
    8000175a:	c695                	beqz	a3,80001786 <copyinstr+0xa6>
    8000175c:	87da                	mv	a5,s6
    8000175e:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001760:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001764:	96da                	add	a3,a3,s6
    80001766:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001768:	00f60733          	add	a4,a2,a5
    8000176c:	00074703          	lbu	a4,0(a4)
    80001770:	db59                	beqz	a4,80001706 <copyinstr+0x26>
        *dst = *p;
    80001772:	00e78023          	sb	a4,0(a5)
      dst++;
    80001776:	0785                	addi	a5,a5,1
    while(n > 0){
    80001778:	fed797e3          	bne	a5,a3,80001766 <copyinstr+0x86>
    8000177c:	b775                	j	80001728 <copyinstr+0x48>
    8000177e:	4781                	li	a5,0
    80001780:	b771                	j	8000170c <copyinstr+0x2c>
      return -1;
    80001782:	557d                	li	a0,-1
    80001784:	b779                	j	80001712 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001786:	6b85                	lui	s7,0x1
    80001788:	9ba6                	add	s7,s7,s1
    8000178a:	87da                	mv	a5,s6
    8000178c:	b77d                	j	8000173a <copyinstr+0x5a>
  int got_null = 0;
    8000178e:	4781                	li	a5,0
  if(got_null){
    80001790:	37fd                	addiw	a5,a5,-1
    80001792:	0007851b          	sext.w	a0,a5
}
    80001796:	8082                	ret

0000000080001798 <proc_mapstacks>:
  
  return 1;  // Success
}
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001798:	7139                	addi	sp,sp,-64
    8000179a:	fc06                	sd	ra,56(sp)
    8000179c:	f822                	sd	s0,48(sp)
    8000179e:	f426                	sd	s1,40(sp)
    800017a0:	f04a                	sd	s2,32(sp)
    800017a2:	ec4e                	sd	s3,24(sp)
    800017a4:	e852                	sd	s4,16(sp)
    800017a6:	e456                	sd	s5,8(sp)
    800017a8:	e05a                	sd	s6,0(sp)
    800017aa:	0080                	addi	s0,sp,64
    800017ac:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800017ae:	00011497          	auipc	s1,0x11
    800017b2:	2f248493          	addi	s1,s1,754 # 80012aa0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800017b6:	8b26                	mv	s6,s1
    800017b8:	faaab937          	lui	s2,0xfaaab
    800017bc:	aab90913          	addi	s2,s2,-1365 # fffffffffaaaaaab <end+0xffffffff7aa86c2b>
    800017c0:	0932                	slli	s2,s2,0xc
    800017c2:	aab90913          	addi	s2,s2,-1365
    800017c6:	0932                	slli	s2,s2,0xc
    800017c8:	aab90913          	addi	s2,s2,-1365
    800017cc:	0932                	slli	s2,s2,0xc
    800017ce:	aab90913          	addi	s2,s2,-1365
    800017d2:	040009b7          	lui	s3,0x4000
    800017d6:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017d8:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017da:	00017a97          	auipc	s5,0x17
    800017de:	2c6a8a93          	addi	s5,s5,710 # 80018aa0 <tickslock>
    char *pa = kalloc();
    800017e2:	b50ff0ef          	jal	80000b32 <kalloc>
    800017e6:	862a                	mv	a2,a0
    if(pa == 0)
    800017e8:	cd15                	beqz	a0,80001824 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017ea:	416485b3          	sub	a1,s1,s6
    800017ee:	859d                	srai	a1,a1,0x7
    800017f0:	032585b3          	mul	a1,a1,s2
    800017f4:	2585                	addiw	a1,a1,1
    800017f6:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017fa:	4719                	li	a4,6
    800017fc:	6685                	lui	a3,0x1
    800017fe:	40b985b3          	sub	a1,s3,a1
    80001802:	8552                	mv	a0,s4
    80001804:	8cfff0ef          	jal	800010d2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001808:	18048493          	addi	s1,s1,384
    8000180c:	fd549be3          	bne	s1,s5,800017e2 <proc_mapstacks+0x4a>
  }
}
    80001810:	70e2                	ld	ra,56(sp)
    80001812:	7442                	ld	s0,48(sp)
    80001814:	74a2                	ld	s1,40(sp)
    80001816:	7902                	ld	s2,32(sp)
    80001818:	69e2                	ld	s3,24(sp)
    8000181a:	6a42                	ld	s4,16(sp)
    8000181c:	6aa2                	ld	s5,8(sp)
    8000181e:	6b02                	ld	s6,0(sp)
    80001820:	6121                	addi	sp,sp,64
    80001822:	8082                	ret
      panic("kalloc");
    80001824:	00006517          	auipc	a0,0x6
    80001828:	9d450513          	addi	a0,a0,-1580 # 800071f8 <etext+0x1f8>
    8000182c:	f77fe0ef          	jal	800007a2 <panic>

0000000080001830 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001830:	7139                	addi	sp,sp,-64
    80001832:	fc06                	sd	ra,56(sp)
    80001834:	f822                	sd	s0,48(sp)
    80001836:	f426                	sd	s1,40(sp)
    80001838:	f04a                	sd	s2,32(sp)
    8000183a:	ec4e                	sd	s3,24(sp)
    8000183c:	e852                	sd	s4,16(sp)
    8000183e:	e456                	sd	s5,8(sp)
    80001840:	e05a                	sd	s6,0(sp)
    80001842:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001844:	00006597          	auipc	a1,0x6
    80001848:	9bc58593          	addi	a1,a1,-1604 # 80007200 <etext+0x200>
    8000184c:	00011517          	auipc	a0,0x11
    80001850:	e2450513          	addi	a0,a0,-476 # 80012670 <pid_lock>
    80001854:	b2eff0ef          	jal	80000b82 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001858:	00006597          	auipc	a1,0x6
    8000185c:	9b058593          	addi	a1,a1,-1616 # 80007208 <etext+0x208>
    80001860:	00011517          	auipc	a0,0x11
    80001864:	e2850513          	addi	a0,a0,-472 # 80012688 <wait_lock>
    80001868:	b1aff0ef          	jal	80000b82 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000186c:	00011497          	auipc	s1,0x11
    80001870:	23448493          	addi	s1,s1,564 # 80012aa0 <proc>
      initlock(&p->lock, "proc");
    80001874:	00006b17          	auipc	s6,0x6
    80001878:	9a4b0b13          	addi	s6,s6,-1628 # 80007218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000187c:	8aa6                	mv	s5,s1
    8000187e:	faaab937          	lui	s2,0xfaaab
    80001882:	aab90913          	addi	s2,s2,-1365 # fffffffffaaaaaab <end+0xffffffff7aa86c2b>
    80001886:	0932                	slli	s2,s2,0xc
    80001888:	aab90913          	addi	s2,s2,-1365
    8000188c:	0932                	slli	s2,s2,0xc
    8000188e:	aab90913          	addi	s2,s2,-1365
    80001892:	0932                	slli	s2,s2,0xc
    80001894:	aab90913          	addi	s2,s2,-1365
    80001898:	040009b7          	lui	s3,0x4000
    8000189c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000189e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800018a0:	00017a17          	auipc	s4,0x17
    800018a4:	200a0a13          	addi	s4,s4,512 # 80018aa0 <tickslock>
      initlock(&p->lock, "proc");
    800018a8:	85da                	mv	a1,s6
    800018aa:	8526                	mv	a0,s1
    800018ac:	ad6ff0ef          	jal	80000b82 <initlock>
      p->state = UNUSED;
    800018b0:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800018b4:	415487b3          	sub	a5,s1,s5
    800018b8:	879d                	srai	a5,a5,0x7
    800018ba:	032787b3          	mul	a5,a5,s2
    800018be:	2785                	addiw	a5,a5,1
    800018c0:	00d7979b          	slliw	a5,a5,0xd
    800018c4:	40f987b3          	sub	a5,s3,a5
    800018c8:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ca:	18048493          	addi	s1,s1,384
    800018ce:	fd449de3          	bne	s1,s4,800018a8 <procinit+0x78>
  }
}
    800018d2:	70e2                	ld	ra,56(sp)
    800018d4:	7442                	ld	s0,48(sp)
    800018d6:	74a2                	ld	s1,40(sp)
    800018d8:	7902                	ld	s2,32(sp)
    800018da:	69e2                	ld	s3,24(sp)
    800018dc:	6a42                	ld	s4,16(sp)
    800018de:	6aa2                	ld	s5,8(sp)
    800018e0:	6b02                	ld	s6,0(sp)
    800018e2:	6121                	addi	sp,sp,64
    800018e4:	8082                	ret

00000000800018e6 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018e6:	1141                	addi	sp,sp,-16
    800018e8:	e422                	sd	s0,8(sp)
    800018ea:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018ec:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018ee:	2501                	sext.w	a0,a0
    800018f0:	6422                	ld	s0,8(sp)
    800018f2:	0141                	addi	sp,sp,16
    800018f4:	8082                	ret

00000000800018f6 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018f6:	1141                	addi	sp,sp,-16
    800018f8:	e422                	sd	s0,8(sp)
    800018fa:	0800                	addi	s0,sp,16
    800018fc:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018fe:	2781                	sext.w	a5,a5
    80001900:	079e                	slli	a5,a5,0x7
  return c;
}
    80001902:	00011517          	auipc	a0,0x11
    80001906:	d9e50513          	addi	a0,a0,-610 # 800126a0 <cpus>
    8000190a:	953e                	add	a0,a0,a5
    8000190c:	6422                	ld	s0,8(sp)
    8000190e:	0141                	addi	sp,sp,16
    80001910:	8082                	ret

0000000080001912 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001912:	1101                	addi	sp,sp,-32
    80001914:	ec06                	sd	ra,24(sp)
    80001916:	e822                	sd	s0,16(sp)
    80001918:	e426                	sd	s1,8(sp)
    8000191a:	1000                	addi	s0,sp,32
  push_off();
    8000191c:	aa6ff0ef          	jal	80000bc2 <push_off>
    80001920:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001922:	2781                	sext.w	a5,a5
    80001924:	079e                	slli	a5,a5,0x7
    80001926:	00011717          	auipc	a4,0x11
    8000192a:	d4a70713          	addi	a4,a4,-694 # 80012670 <pid_lock>
    8000192e:	97ba                	add	a5,a5,a4
    80001930:	7b84                	ld	s1,48(a5)
  pop_off();
    80001932:	b14ff0ef          	jal	80000c46 <pop_off>
  return p;
}
    80001936:	8526                	mv	a0,s1
    80001938:	60e2                	ld	ra,24(sp)
    8000193a:	6442                	ld	s0,16(sp)
    8000193c:	64a2                	ld	s1,8(sp)
    8000193e:	6105                	addi	sp,sp,32
    80001940:	8082                	ret

0000000080001942 <getptable>:
  if (nproc < 1 || buffer == 0) {
    80001942:	0ea05663          	blez	a0,80001a2e <getptable+0xec>
{
    80001946:	7119                	addi	sp,sp,-128
    80001948:	fc86                	sd	ra,120(sp)
    8000194a:	f8a2                	sd	s0,112(sp)
    8000194c:	ecce                	sd	s3,88(sp)
    8000194e:	e8d2                	sd	s4,80(sp)
    80001950:	0100                	addi	s0,sp,128
    80001952:	89aa                	mv	s3,a0
    80001954:	8a2e                	mv	s4,a1
    return 0;  // Failure: invalid parameters
    80001956:	4501                	li	a0,0
  if (nproc < 1 || buffer == 0) {
    80001958:	e599                	bnez	a1,80001966 <getptable+0x24>
}
    8000195a:	70e6                	ld	ra,120(sp)
    8000195c:	7446                	ld	s0,112(sp)
    8000195e:	69e6                	ld	s3,88(sp)
    80001960:	6a46                	ld	s4,80(sp)
    80001962:	6109                	addi	sp,sp,128
    80001964:	8082                	ret
    80001966:	f4a6                	sd	s1,104(sp)
    80001968:	f0ca                	sd	s2,96(sp)
    8000196a:	e4d6                	sd	s5,72(sp)
    8000196c:	e0da                	sd	s6,64(sp)
    8000196e:	fc5e                	sd	s7,56(sp)
  struct proc *curproc = myproc();
    80001970:	fa3ff0ef          	jal	80001912 <myproc>
    80001974:	8b2a                	mv	s6,a0
  int count = 0;
    80001976:	4901                	li	s2,0
  for (p = proc; p < &proc[NPROC]; p++) {
    80001978:	00011497          	auipc	s1,0x11
    8000197c:	12848493          	addi	s1,s1,296 # 80012aa0 <proc>
      pinfo.ppid = (p->parent) ? p->parent->pid : 0;  // Handle init process
    80001980:	4b81                	li	s7,0
  for (p = proc; p < &proc[NPROC]; p++) {
    80001982:	00017a97          	auipc	s5,0x17
    80001986:	11ea8a93          	addi	s5,s5,286 # 80018aa0 <tickslock>
    8000198a:	a095                	j	800019ee <getptable+0xac>
        release(&p->lock);
    8000198c:	8526                	mv	a0,s1
    8000198e:	b0cff0ef          	jal	80000c9a <release>
  return 1;  // Success
    80001992:	4505                	li	a0,1
        break;
    80001994:	74a6                	ld	s1,104(sp)
    80001996:	7906                	ld	s2,96(sp)
    80001998:	6aa6                	ld	s5,72(sp)
    8000199a:	6b06                	ld	s6,64(sp)
    8000199c:	7be2                	ld	s7,56(sp)
    8000199e:	bf75                	j	8000195a <getptable+0x18>
      pinfo.ppid = (p->parent) ? p->parent->pid : 0;  // Handle init process
    800019a0:	f8e42623          	sw	a4,-116(s0)
      pinfo.state = p->state;
    800019a4:	f8f42823          	sw	a5,-112(s0)
      strncpy(pinfo.name, p->name, 16);
    800019a8:	4641                	li	a2,16
    800019aa:	15848593          	addi	a1,s1,344
    800019ae:	f9440513          	addi	a0,s0,-108
    800019b2:	c26ff0ef          	jal	80000dd8 <strncpy>
      pinfo.name[15] = '\0';  // Ensure null termination
    800019b6:	fa0401a3          	sb	zero,-93(s0)
      pinfo.sz = p->sz;
    800019ba:	64bc                	ld	a5,72(s1)
    800019bc:	faf43423          	sd	a5,-88(s0)
      if (copyout(curproc->pagetable, buffer + (count * sizeof(struct proc_info)),
    800019c0:	00291593          	slli	a1,s2,0x2
    800019c4:	95ca                	add	a1,a1,s2
    800019c6:	058e                	slli	a1,a1,0x3
    800019c8:	02800693          	li	a3,40
    800019cc:	f8840613          	addi	a2,s0,-120
    800019d0:	95d2                	add	a1,a1,s4
    800019d2:	050b3503          	ld	a0,80(s6)
    800019d6:	bafff0ef          	jal	80001584 <copyout>
    800019da:	02054963          	bltz	a0,80001a0c <getptable+0xca>
      count++;
    800019de:	2905                	addiw	s2,s2,1
    release(&p->lock);
    800019e0:	8526                	mv	a0,s1
    800019e2:	ab8ff0ef          	jal	80000c9a <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800019e6:	18048493          	addi	s1,s1,384
    800019ea:	03548b63          	beq	s1,s5,80001a20 <getptable+0xde>
    acquire(&p->lock);
    800019ee:	8526                	mv	a0,s1
    800019f0:	a12ff0ef          	jal	80000c02 <acquire>
    if (p->state != UNUSED) {
    800019f4:	4c9c                	lw	a5,24(s1)
    800019f6:	d7ed                	beqz	a5,800019e0 <getptable+0x9e>
      if (count >= nproc) {
    800019f8:	f9395ae3          	bge	s2,s3,8000198c <getptable+0x4a>
      pinfo.pid = p->pid;
    800019fc:	5898                	lw	a4,48(s1)
    800019fe:	f8e42423          	sw	a4,-120(s0)
      pinfo.ppid = (p->parent) ? p->parent->pid : 0;  // Handle init process
    80001a02:	7c94                	ld	a3,56(s1)
    80001a04:	875e                	mv	a4,s7
    80001a06:	dec9                	beqz	a3,800019a0 <getptable+0x5e>
    80001a08:	5a98                	lw	a4,48(a3)
    80001a0a:	bf59                	j	800019a0 <getptable+0x5e>
        release(&p->lock);
    80001a0c:	8526                	mv	a0,s1
    80001a0e:	a8cff0ef          	jal	80000c9a <release>
        return 0;  // Failure: copyout failed
    80001a12:	4501                	li	a0,0
    80001a14:	74a6                	ld	s1,104(sp)
    80001a16:	7906                	ld	s2,96(sp)
    80001a18:	6aa6                	ld	s5,72(sp)
    80001a1a:	6b06                	ld	s6,64(sp)
    80001a1c:	7be2                	ld	s7,56(sp)
    80001a1e:	bf35                	j	8000195a <getptable+0x18>
  return 1;  // Success
    80001a20:	4505                	li	a0,1
    80001a22:	74a6                	ld	s1,104(sp)
    80001a24:	7906                	ld	s2,96(sp)
    80001a26:	6aa6                	ld	s5,72(sp)
    80001a28:	6b06                	ld	s6,64(sp)
    80001a2a:	7be2                	ld	s7,56(sp)
    80001a2c:	b73d                	j	8000195a <getptable+0x18>
    return 0;  // Failure: invalid parameters
    80001a2e:	4501                	li	a0,0
}
    80001a30:	8082                	ret

0000000080001a32 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001a32:	1141                	addi	sp,sp,-16
    80001a34:	e406                	sd	ra,8(sp)
    80001a36:	e022                	sd	s0,0(sp)
    80001a38:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001a3a:	ed9ff0ef          	jal	80001912 <myproc>
    80001a3e:	a5cff0ef          	jal	80000c9a <release>

  if (first) {
    80001a42:	00009797          	auipc	a5,0x9
    80001a46:	a4e7a783          	lw	a5,-1458(a5) # 8000a490 <first.1>
    80001a4a:	e799                	bnez	a5,80001a58 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001a4c:	575000ef          	jal	800027c0 <usertrapret>
}
    80001a50:	60a2                	ld	ra,8(sp)
    80001a52:	6402                	ld	s0,0(sp)
    80001a54:	0141                	addi	sp,sp,16
    80001a56:	8082                	ret
    fsinit(ROOTDEV);
    80001a58:	4505                	li	a0,1
    80001a5a:	285010ef          	jal	800034de <fsinit>
    first = 0;
    80001a5e:	00009797          	auipc	a5,0x9
    80001a62:	a207a923          	sw	zero,-1486(a5) # 8000a490 <first.1>
    __sync_synchronize();
    80001a66:	0330000f          	fence	rw,rw
    80001a6a:	b7cd                	j	80001a4c <forkret+0x1a>

0000000080001a6c <allocpid>:
{
    80001a6c:	1101                	addi	sp,sp,-32
    80001a6e:	ec06                	sd	ra,24(sp)
    80001a70:	e822                	sd	s0,16(sp)
    80001a72:	e426                	sd	s1,8(sp)
    80001a74:	e04a                	sd	s2,0(sp)
    80001a76:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a78:	00011917          	auipc	s2,0x11
    80001a7c:	bf890913          	addi	s2,s2,-1032 # 80012670 <pid_lock>
    80001a80:	854a                	mv	a0,s2
    80001a82:	980ff0ef          	jal	80000c02 <acquire>
  pid = nextpid;
    80001a86:	00009797          	auipc	a5,0x9
    80001a8a:	a0e78793          	addi	a5,a5,-1522 # 8000a494 <nextpid>
    80001a8e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a90:	0014871b          	addiw	a4,s1,1
    80001a94:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a96:	854a                	mv	a0,s2
    80001a98:	a02ff0ef          	jal	80000c9a <release>
}
    80001a9c:	8526                	mv	a0,s1
    80001a9e:	60e2                	ld	ra,24(sp)
    80001aa0:	6442                	ld	s0,16(sp)
    80001aa2:	64a2                	ld	s1,8(sp)
    80001aa4:	6902                	ld	s2,0(sp)
    80001aa6:	6105                	addi	sp,sp,32
    80001aa8:	8082                	ret

0000000080001aaa <proc_pagetable>:
{
    80001aaa:	1101                	addi	sp,sp,-32
    80001aac:	ec06                	sd	ra,24(sp)
    80001aae:	e822                	sd	s0,16(sp)
    80001ab0:	e426                	sd	s1,8(sp)
    80001ab2:	e04a                	sd	s2,0(sp)
    80001ab4:	1000                	addi	s0,sp,32
    80001ab6:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001ab8:	ff0ff0ef          	jal	800012a8 <uvmcreate>
    80001abc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001abe:	cd05                	beqz	a0,80001af6 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001ac0:	4729                	li	a4,10
    80001ac2:	00004697          	auipc	a3,0x4
    80001ac6:	53e68693          	addi	a3,a3,1342 # 80006000 <_trampoline>
    80001aca:	6605                	lui	a2,0x1
    80001acc:	040005b7          	lui	a1,0x4000
    80001ad0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ad2:	05b2                	slli	a1,a1,0xc
    80001ad4:	d4eff0ef          	jal	80001022 <mappages>
    80001ad8:	02054663          	bltz	a0,80001b04 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001adc:	4719                	li	a4,6
    80001ade:	05893683          	ld	a3,88(s2)
    80001ae2:	6605                	lui	a2,0x1
    80001ae4:	020005b7          	lui	a1,0x2000
    80001ae8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001aea:	05b6                	slli	a1,a1,0xd
    80001aec:	8526                	mv	a0,s1
    80001aee:	d34ff0ef          	jal	80001022 <mappages>
    80001af2:	00054f63          	bltz	a0,80001b10 <proc_pagetable+0x66>
}
    80001af6:	8526                	mv	a0,s1
    80001af8:	60e2                	ld	ra,24(sp)
    80001afa:	6442                	ld	s0,16(sp)
    80001afc:	64a2                	ld	s1,8(sp)
    80001afe:	6902                	ld	s2,0(sp)
    80001b00:	6105                	addi	sp,sp,32
    80001b02:	8082                	ret
    uvmfree(pagetable, 0);
    80001b04:	4581                	li	a1,0
    80001b06:	8526                	mv	a0,s1
    80001b08:	96fff0ef          	jal	80001476 <uvmfree>
    return 0;
    80001b0c:	4481                	li	s1,0
    80001b0e:	b7e5                	j	80001af6 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b10:	4681                	li	a3,0
    80001b12:	4605                	li	a2,1
    80001b14:	040005b7          	lui	a1,0x4000
    80001b18:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b1a:	05b2                	slli	a1,a1,0xc
    80001b1c:	8526                	mv	a0,s1
    80001b1e:	eceff0ef          	jal	800011ec <uvmunmap>
    uvmfree(pagetable, 0);
    80001b22:	4581                	li	a1,0
    80001b24:	8526                	mv	a0,s1
    80001b26:	951ff0ef          	jal	80001476 <uvmfree>
    return 0;
    80001b2a:	4481                	li	s1,0
    80001b2c:	b7e9                	j	80001af6 <proc_pagetable+0x4c>

0000000080001b2e <proc_freepagetable>:
{
    80001b2e:	1101                	addi	sp,sp,-32
    80001b30:	ec06                	sd	ra,24(sp)
    80001b32:	e822                	sd	s0,16(sp)
    80001b34:	e426                	sd	s1,8(sp)
    80001b36:	e04a                	sd	s2,0(sp)
    80001b38:	1000                	addi	s0,sp,32
    80001b3a:	84aa                	mv	s1,a0
    80001b3c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b3e:	4681                	li	a3,0
    80001b40:	4605                	li	a2,1
    80001b42:	040005b7          	lui	a1,0x4000
    80001b46:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b48:	05b2                	slli	a1,a1,0xc
    80001b4a:	ea2ff0ef          	jal	800011ec <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b4e:	4681                	li	a3,0
    80001b50:	4605                	li	a2,1
    80001b52:	020005b7          	lui	a1,0x2000
    80001b56:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b58:	05b6                	slli	a1,a1,0xd
    80001b5a:	8526                	mv	a0,s1
    80001b5c:	e90ff0ef          	jal	800011ec <uvmunmap>
  uvmfree(pagetable, sz);
    80001b60:	85ca                	mv	a1,s2
    80001b62:	8526                	mv	a0,s1
    80001b64:	913ff0ef          	jal	80001476 <uvmfree>
}
    80001b68:	60e2                	ld	ra,24(sp)
    80001b6a:	6442                	ld	s0,16(sp)
    80001b6c:	64a2                	ld	s1,8(sp)
    80001b6e:	6902                	ld	s2,0(sp)
    80001b70:	6105                	addi	sp,sp,32
    80001b72:	8082                	ret

0000000080001b74 <freeproc>:
{
    80001b74:	1101                	addi	sp,sp,-32
    80001b76:	ec06                	sd	ra,24(sp)
    80001b78:	e822                	sd	s0,16(sp)
    80001b7a:	e426                	sd	s1,8(sp)
    80001b7c:	1000                	addi	s0,sp,32
    80001b7e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b80:	6d28                	ld	a0,88(a0)
    80001b82:	c119                	beqz	a0,80001b88 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001b84:	ecdfe0ef          	jal	80000a50 <kfree>
  p->trapframe = 0;
    80001b88:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b8c:	68a8                	ld	a0,80(s1)
    80001b8e:	c501                	beqz	a0,80001b96 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001b90:	64ac                	ld	a1,72(s1)
    80001b92:	f9dff0ef          	jal	80001b2e <proc_freepagetable>
  p->pagetable = 0;
    80001b96:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b9a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b9e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001ba2:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001ba6:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001baa:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001bae:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001bb2:	0204a623          	sw	zero,44(s1)
   p->creation_time= ticks;
    80001bb6:	00009797          	auipc	a5,0x9
    80001bba:	9827a783          	lw	a5,-1662(a5) # 8000a538 <ticks>
    80001bbe:	16f4a423          	sw	a5,360(s1)
   p->run_time = 0;
    80001bc2:	1604a623          	sw	zero,364(s1)
  p->turnaround_time = 0;
    80001bc6:	1604aa23          	sw	zero,372(s1)
  p->waiting_time= 0;
    80001bca:	1604ac23          	sw	zero,376(s1)
  p->finish_time = 0;
    80001bce:	1604a823          	sw	zero,368(s1)
  p->state = UNUSED;
    80001bd2:	0004ac23          	sw	zero,24(s1)
}
    80001bd6:	60e2                	ld	ra,24(sp)
    80001bd8:	6442                	ld	s0,16(sp)
    80001bda:	64a2                	ld	s1,8(sp)
    80001bdc:	6105                	addi	sp,sp,32
    80001bde:	8082                	ret

0000000080001be0 <allocproc>:
{
    80001be0:	1101                	addi	sp,sp,-32
    80001be2:	ec06                	sd	ra,24(sp)
    80001be4:	e822                	sd	s0,16(sp)
    80001be6:	e426                	sd	s1,8(sp)
    80001be8:	e04a                	sd	s2,0(sp)
    80001bea:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bec:	00011497          	auipc	s1,0x11
    80001bf0:	eb448493          	addi	s1,s1,-332 # 80012aa0 <proc>
    80001bf4:	00017917          	auipc	s2,0x17
    80001bf8:	eac90913          	addi	s2,s2,-340 # 80018aa0 <tickslock>
    acquire(&p->lock);
    80001bfc:	8526                	mv	a0,s1
    80001bfe:	804ff0ef          	jal	80000c02 <acquire>
    if(p->state == UNUSED) {
    80001c02:	4c9c                	lw	a5,24(s1)
    80001c04:	cb91                	beqz	a5,80001c18 <allocproc+0x38>
      release(&p->lock);
    80001c06:	8526                	mv	a0,s1
    80001c08:	892ff0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c0c:	18048493          	addi	s1,s1,384
    80001c10:	ff2496e3          	bne	s1,s2,80001bfc <allocproc+0x1c>
  return 0;
    80001c14:	4481                	li	s1,0
    80001c16:	a8b9                	j	80001c74 <allocproc+0x94>
  p->pid = allocpid();
    80001c18:	e55ff0ef          	jal	80001a6c <allocpid>
    80001c1c:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c1e:	4785                	li	a5,1
    80001c20:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c22:	f11fe0ef          	jal	80000b32 <kalloc>
    80001c26:	892a                	mv	s2,a0
    80001c28:	eca8                	sd	a0,88(s1)
    80001c2a:	cd21                	beqz	a0,80001c82 <allocproc+0xa2>
  p->pagetable = proc_pagetable(p);
    80001c2c:	8526                	mv	a0,s1
    80001c2e:	e7dff0ef          	jal	80001aaa <proc_pagetable>
    80001c32:	892a                	mv	s2,a0
    80001c34:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c36:	cd31                	beqz	a0,80001c92 <allocproc+0xb2>
  memset(&p->context, 0, sizeof(p->context));
    80001c38:	07000613          	li	a2,112
    80001c3c:	4581                	li	a1,0
    80001c3e:	06048513          	addi	a0,s1,96
    80001c42:	894ff0ef          	jal	80000cd6 <memset>
  p->context.ra = (uint64)forkret;
    80001c46:	00000797          	auipc	a5,0x0
    80001c4a:	dec78793          	addi	a5,a5,-532 # 80001a32 <forkret>
    80001c4e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c50:	60bc                	ld	a5,64(s1)
    80001c52:	6705                	lui	a4,0x1
    80001c54:	97ba                	add	a5,a5,a4
    80001c56:	f4bc                	sd	a5,104(s1)
  p->creation_time = ticks;
    80001c58:	00009797          	auipc	a5,0x9
    80001c5c:	8e07a783          	lw	a5,-1824(a5) # 8000a538 <ticks>
    80001c60:	16f4a423          	sw	a5,360(s1)
  p->run_time = 0;
    80001c64:	1604a623          	sw	zero,364(s1)
  p->turnaround_time=0;
    80001c68:	1604aa23          	sw	zero,372(s1)
  p->waiting_time = 0;
    80001c6c:	1604ac23          	sw	zero,376(s1)
  p->finish_time = 0;
    80001c70:	1604a823          	sw	zero,368(s1)
}
    80001c74:	8526                	mv	a0,s1
    80001c76:	60e2                	ld	ra,24(sp)
    80001c78:	6442                	ld	s0,16(sp)
    80001c7a:	64a2                	ld	s1,8(sp)
    80001c7c:	6902                	ld	s2,0(sp)
    80001c7e:	6105                	addi	sp,sp,32
    80001c80:	8082                	ret
    freeproc(p);
    80001c82:	8526                	mv	a0,s1
    80001c84:	ef1ff0ef          	jal	80001b74 <freeproc>
    release(&p->lock);
    80001c88:	8526                	mv	a0,s1
    80001c8a:	810ff0ef          	jal	80000c9a <release>
    return 0;
    80001c8e:	84ca                	mv	s1,s2
    80001c90:	b7d5                	j	80001c74 <allocproc+0x94>
    freeproc(p);
    80001c92:	8526                	mv	a0,s1
    80001c94:	ee1ff0ef          	jal	80001b74 <freeproc>
    release(&p->lock);
    80001c98:	8526                	mv	a0,s1
    80001c9a:	800ff0ef          	jal	80000c9a <release>
    return 0;
    80001c9e:	84ca                	mv	s1,s2
    80001ca0:	bfd1                	j	80001c74 <allocproc+0x94>

0000000080001ca2 <userinit>:
{
    80001ca2:	1101                	addi	sp,sp,-32
    80001ca4:	ec06                	sd	ra,24(sp)
    80001ca6:	e822                	sd	s0,16(sp)
    80001ca8:	e426                	sd	s1,8(sp)
    80001caa:	1000                	addi	s0,sp,32
  p = allocproc();
    80001cac:	f35ff0ef          	jal	80001be0 <allocproc>
    80001cb0:	84aa                	mv	s1,a0
  initproc = p;
    80001cb2:	00009797          	auipc	a5,0x9
    80001cb6:	86a7bf23          	sd	a0,-1922(a5) # 8000a530 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001cba:	03400613          	li	a2,52
    80001cbe:	00008597          	auipc	a1,0x8
    80001cc2:	7e258593          	addi	a1,a1,2018 # 8000a4a0 <initcode>
    80001cc6:	6928                	ld	a0,80(a0)
    80001cc8:	e06ff0ef          	jal	800012ce <uvmfirst>
  p->sz = PGSIZE;
    80001ccc:	6785                	lui	a5,0x1
    80001cce:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001cd0:	6cb8                	ld	a4,88(s1)
    80001cd2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001cd6:	6cb8                	ld	a4,88(s1)
    80001cd8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001cda:	4641                	li	a2,16
    80001cdc:	00005597          	auipc	a1,0x5
    80001ce0:	54458593          	addi	a1,a1,1348 # 80007220 <etext+0x220>
    80001ce4:	15848513          	addi	a0,s1,344
    80001ce8:	92cff0ef          	jal	80000e14 <safestrcpy>
  p->cwd = namei("/");
    80001cec:	00005517          	auipc	a0,0x5
    80001cf0:	54450513          	addi	a0,a0,1348 # 80007230 <etext+0x230>
    80001cf4:	0f8020ef          	jal	80003dec <namei>
    80001cf8:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001cfc:	478d                	li	a5,3
    80001cfe:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d00:	8526                	mv	a0,s1
    80001d02:	f99fe0ef          	jal	80000c9a <release>
}
    80001d06:	60e2                	ld	ra,24(sp)
    80001d08:	6442                	ld	s0,16(sp)
    80001d0a:	64a2                	ld	s1,8(sp)
    80001d0c:	6105                	addi	sp,sp,32
    80001d0e:	8082                	ret

0000000080001d10 <growproc>:
{
    80001d10:	1101                	addi	sp,sp,-32
    80001d12:	ec06                	sd	ra,24(sp)
    80001d14:	e822                	sd	s0,16(sp)
    80001d16:	e426                	sd	s1,8(sp)
    80001d18:	e04a                	sd	s2,0(sp)
    80001d1a:	1000                	addi	s0,sp,32
    80001d1c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001d1e:	bf5ff0ef          	jal	80001912 <myproc>
    80001d22:	84aa                	mv	s1,a0
  sz = p->sz;
    80001d24:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001d26:	01204c63          	bgtz	s2,80001d3e <growproc+0x2e>
  } else if(n < 0){
    80001d2a:	02094463          	bltz	s2,80001d52 <growproc+0x42>
  p->sz = sz;
    80001d2e:	e4ac                	sd	a1,72(s1)
  return 0;
    80001d30:	4501                	li	a0,0
}
    80001d32:	60e2                	ld	ra,24(sp)
    80001d34:	6442                	ld	s0,16(sp)
    80001d36:	64a2                	ld	s1,8(sp)
    80001d38:	6902                	ld	s2,0(sp)
    80001d3a:	6105                	addi	sp,sp,32
    80001d3c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001d3e:	4691                	li	a3,4
    80001d40:	00b90633          	add	a2,s2,a1
    80001d44:	6928                	ld	a0,80(a0)
    80001d46:	e2aff0ef          	jal	80001370 <uvmalloc>
    80001d4a:	85aa                	mv	a1,a0
    80001d4c:	f16d                	bnez	a0,80001d2e <growproc+0x1e>
      return -1;
    80001d4e:	557d                	li	a0,-1
    80001d50:	b7cd                	j	80001d32 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d52:	00b90633          	add	a2,s2,a1
    80001d56:	6928                	ld	a0,80(a0)
    80001d58:	dd4ff0ef          	jal	8000132c <uvmdealloc>
    80001d5c:	85aa                	mv	a1,a0
    80001d5e:	bfc1                	j	80001d2e <growproc+0x1e>

0000000080001d60 <fork>:
{
    80001d60:	7139                	addi	sp,sp,-64
    80001d62:	fc06                	sd	ra,56(sp)
    80001d64:	f822                	sd	s0,48(sp)
    80001d66:	f04a                	sd	s2,32(sp)
    80001d68:	e456                	sd	s5,8(sp)
    80001d6a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001d6c:	ba7ff0ef          	jal	80001912 <myproc>
    80001d70:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001d72:	e6fff0ef          	jal	80001be0 <allocproc>
    80001d76:	0e050a63          	beqz	a0,80001e6a <fork+0x10a>
    80001d7a:	e852                	sd	s4,16(sp)
    80001d7c:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001d7e:	048ab603          	ld	a2,72(s5)
    80001d82:	692c                	ld	a1,80(a0)
    80001d84:	050ab503          	ld	a0,80(s5)
    80001d88:	f20ff0ef          	jal	800014a8 <uvmcopy>
    80001d8c:	04054a63          	bltz	a0,80001de0 <fork+0x80>
    80001d90:	f426                	sd	s1,40(sp)
    80001d92:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001d94:	048ab783          	ld	a5,72(s5)
    80001d98:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001d9c:	058ab683          	ld	a3,88(s5)
    80001da0:	87b6                	mv	a5,a3
    80001da2:	058a3703          	ld	a4,88(s4)
    80001da6:	12068693          	addi	a3,a3,288
    80001daa:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001dae:	6788                	ld	a0,8(a5)
    80001db0:	6b8c                	ld	a1,16(a5)
    80001db2:	6f90                	ld	a2,24(a5)
    80001db4:	01073023          	sd	a6,0(a4)
    80001db8:	e708                	sd	a0,8(a4)
    80001dba:	eb0c                	sd	a1,16(a4)
    80001dbc:	ef10                	sd	a2,24(a4)
    80001dbe:	02078793          	addi	a5,a5,32
    80001dc2:	02070713          	addi	a4,a4,32
    80001dc6:	fed792e3          	bne	a5,a3,80001daa <fork+0x4a>
  np->trapframe->a0 = 0;
    80001dca:	058a3783          	ld	a5,88(s4)
    80001dce:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001dd2:	0d0a8493          	addi	s1,s5,208
    80001dd6:	0d0a0913          	addi	s2,s4,208
    80001dda:	150a8993          	addi	s3,s5,336
    80001dde:	a831                	j	80001dfa <fork+0x9a>
    freeproc(np);
    80001de0:	8552                	mv	a0,s4
    80001de2:	d93ff0ef          	jal	80001b74 <freeproc>
    release(&np->lock);
    80001de6:	8552                	mv	a0,s4
    80001de8:	eb3fe0ef          	jal	80000c9a <release>
    return -1;
    80001dec:	597d                	li	s2,-1
    80001dee:	6a42                	ld	s4,16(sp)
    80001df0:	a0b5                	j	80001e5c <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001df2:	04a1                	addi	s1,s1,8
    80001df4:	0921                	addi	s2,s2,8
    80001df6:	01348963          	beq	s1,s3,80001e08 <fork+0xa8>
    if(p->ofile[i])
    80001dfa:	6088                	ld	a0,0(s1)
    80001dfc:	d97d                	beqz	a0,80001df2 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001dfe:	57e020ef          	jal	8000437c <filedup>
    80001e02:	00a93023          	sd	a0,0(s2)
    80001e06:	b7f5                	j	80001df2 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001e08:	150ab503          	ld	a0,336(s5)
    80001e0c:	0d1010ef          	jal	800036dc <idup>
    80001e10:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e14:	4641                	li	a2,16
    80001e16:	158a8593          	addi	a1,s5,344
    80001e1a:	158a0513          	addi	a0,s4,344
    80001e1e:	ff7fe0ef          	jal	80000e14 <safestrcpy>
  pid = np->pid;
    80001e22:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001e26:	8552                	mv	a0,s4
    80001e28:	e73fe0ef          	jal	80000c9a <release>
  acquire(&wait_lock);
    80001e2c:	00011497          	auipc	s1,0x11
    80001e30:	85c48493          	addi	s1,s1,-1956 # 80012688 <wait_lock>
    80001e34:	8526                	mv	a0,s1
    80001e36:	dcdfe0ef          	jal	80000c02 <acquire>
  np->parent = p;
    80001e3a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001e3e:	8526                	mv	a0,s1
    80001e40:	e5bfe0ef          	jal	80000c9a <release>
  acquire(&np->lock);
    80001e44:	8552                	mv	a0,s4
    80001e46:	dbdfe0ef          	jal	80000c02 <acquire>
  np->state = RUNNABLE;
    80001e4a:	478d                	li	a5,3
    80001e4c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e50:	8552                	mv	a0,s4
    80001e52:	e49fe0ef          	jal	80000c9a <release>
  return pid;
    80001e56:	74a2                	ld	s1,40(sp)
    80001e58:	69e2                	ld	s3,24(sp)
    80001e5a:	6a42                	ld	s4,16(sp)
}
    80001e5c:	854a                	mv	a0,s2
    80001e5e:	70e2                	ld	ra,56(sp)
    80001e60:	7442                	ld	s0,48(sp)
    80001e62:	7902                	ld	s2,32(sp)
    80001e64:	6aa2                	ld	s5,8(sp)
    80001e66:	6121                	addi	sp,sp,64
    80001e68:	8082                	ret
    return -1;
    80001e6a:	597d                	li	s2,-1
    80001e6c:	bfc5                	j	80001e5c <fork+0xfc>

0000000080001e6e <update_time>:
{
    80001e6e:	7179                	addi	sp,sp,-48
    80001e70:	f406                	sd	ra,40(sp)
    80001e72:	f022                	sd	s0,32(sp)
    80001e74:	ec26                	sd	s1,24(sp)
    80001e76:	e84a                	sd	s2,16(sp)
    80001e78:	e44e                	sd	s3,8(sp)
    80001e7a:	e052                	sd	s4,0(sp)
    80001e7c:	1800                	addi	s0,sp,48
  for (p = proc; p < &proc[NPROC]; p++) {
    80001e7e:	00011497          	auipc	s1,0x11
    80001e82:	c2248493          	addi	s1,s1,-990 # 80012aa0 <proc>
    if (p->state == RUNNING) {
    80001e86:	4991                	li	s3,4
    if (p->state == RUNNABLE) {
    80001e88:	4a0d                	li	s4,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001e8a:	00017917          	auipc	s2,0x17
    80001e8e:	c1690913          	addi	s2,s2,-1002 # 80018aa0 <tickslock>
    80001e92:	a829                	j	80001eac <update_time+0x3e>
      p->run_time++;
    80001e94:	16c4a783          	lw	a5,364(s1)
    80001e98:	2785                	addiw	a5,a5,1
    80001e9a:	16f4a623          	sw	a5,364(s1)
    release(&p->lock);//lehd hena
    80001e9e:	8526                	mv	a0,s1
    80001ea0:	dfbfe0ef          	jal	80000c9a <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001ea4:	18048493          	addi	s1,s1,384
    80001ea8:	03248063          	beq	s1,s2,80001ec8 <update_time+0x5a>
    acquire(&p->lock);//n3adel mn hena
    80001eac:	8526                	mv	a0,s1
    80001eae:	d55fe0ef          	jal	80000c02 <acquire>
    if (p->state == RUNNING) {
    80001eb2:	4c9c                	lw	a5,24(s1)
    80001eb4:	ff3780e3          	beq	a5,s3,80001e94 <update_time+0x26>
    if (p->state == RUNNABLE) {
    80001eb8:	ff4793e3          	bne	a5,s4,80001e9e <update_time+0x30>
      p->waiting_time++;
    80001ebc:	1784a783          	lw	a5,376(s1)
    80001ec0:	2785                	addiw	a5,a5,1
    80001ec2:	16f4ac23          	sw	a5,376(s1)
    80001ec6:	bfe1                	j	80001e9e <update_time+0x30>
}
    80001ec8:	70a2                	ld	ra,40(sp)
    80001eca:	7402                	ld	s0,32(sp)
    80001ecc:	64e2                	ld	s1,24(sp)
    80001ece:	6942                	ld	s2,16(sp)
    80001ed0:	69a2                	ld	s3,8(sp)
    80001ed2:	6a02                	ld	s4,0(sp)
    80001ed4:	6145                	addi	sp,sp,48
    80001ed6:	8082                	ret

0000000080001ed8 <choose_next_process>:
struct proc *choose_next_process() {
    80001ed8:	7179                	addi	sp,sp,-48
    80001eda:	f406                	sd	ra,40(sp)
    80001edc:	f022                	sd	s0,32(sp)
    80001ede:	e84a                	sd	s2,16(sp)
    80001ee0:	1800                	addi	s0,sp,48
  if(sched_mode == SCHED_ROUND_ROBIN) {
    80001ee2:	00008797          	auipc	a5,0x8
    80001ee6:	6467a783          	lw	a5,1606(a5) # 8000a528 <sched_mode>
    80001eea:	e785                	bnez	a5,80001f12 <choose_next_process+0x3a>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001eec:	00011917          	auipc	s2,0x11
    80001ef0:	bb490913          	addi	s2,s2,-1100 # 80012aa0 <proc>
      if (p->state == RUNNABLE)
    80001ef4:	470d                	li	a4,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ef6:	00017697          	auipc	a3,0x17
    80001efa:	baa68693          	addi	a3,a3,-1110 # 80018aa0 <tickslock>
      if (p->state == RUNNABLE)
    80001efe:	01892783          	lw	a5,24(s2)
    80001f02:	00e78c63          	beq	a5,a4,80001f1a <choose_next_process+0x42>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f06:	18090913          	addi	s2,s2,384
    80001f0a:	fed91ae3          	bne	s2,a3,80001efe <choose_next_process+0x26>
  return 0;
    80001f0e:	4901                	li	s2,0
    80001f10:	a029                	j	80001f1a <choose_next_process+0x42>
  else if (sched_mode == SCHED_FCFS) {
    80001f12:	4705                	li	a4,1
  return 0;
    80001f14:	4901                	li	s2,0
  else if (sched_mode == SCHED_FCFS) {
    80001f16:	00e78863          	beq	a5,a4,80001f26 <choose_next_process+0x4e>
}
    80001f1a:	854a                	mv	a0,s2
    80001f1c:	70a2                	ld	ra,40(sp)
    80001f1e:	7402                	ld	s0,32(sp)
    80001f20:	6942                	ld	s2,16(sp)
    80001f22:	6145                	addi	sp,sp,48
    80001f24:	8082                	ret
    80001f26:	ec26                	sd	s1,24(sp)
    80001f28:	e44e                	sd	s3,8(sp)
    80001f2a:	e052                	sd	s4,0(sp)
     for(p = proc; p < &proc[NPROC]; p++) {
    80001f2c:	00011497          	auipc	s1,0x11
    80001f30:	b7448493          	addi	s1,s1,-1164 # 80012aa0 <proc>
      if(p->state == RUNNABLE) {
    80001f34:	4a0d                	li	s4,3
     for(p = proc; p < &proc[NPROC]; p++) {
    80001f36:	00017997          	auipc	s3,0x17
    80001f3a:	b6a98993          	addi	s3,s3,-1174 # 80018aa0 <tickslock>
    80001f3e:	a801                	j	80001f4e <choose_next_process+0x76>
          release(&p->lock);
    80001f40:	8526                	mv	a0,s1
    80001f42:	d59fe0ef          	jal	80000c9a <release>
     for(p = proc; p < &proc[NPROC]; p++) {
    80001f46:	18048493          	addi	s1,s1,384
    80001f4a:	03348763          	beq	s1,s3,80001f78 <choose_next_process+0xa0>
      acquire(&p->lock);
    80001f4e:	8526                	mv	a0,s1
    80001f50:	cb3fe0ef          	jal	80000c02 <acquire>
      if(p->state == RUNNABLE) {
    80001f54:	4c9c                	lw	a5,24(s1)
    80001f56:	ff4795e3          	bne	a5,s4,80001f40 <choose_next_process+0x68>
            if(min_proc == 0 || p->creation_time < min_proc->creation_time) {
    80001f5a:	00090d63          	beqz	s2,80001f74 <choose_next_process+0x9c>
    80001f5e:	1684a703          	lw	a4,360(s1)
    80001f62:	16892783          	lw	a5,360(s2)
    80001f66:	fcf77de3          	bgeu	a4,a5,80001f40 <choose_next_process+0x68>
              if(min_proc != 0) release(&min_proc->lock); // Release prev candidate
    80001f6a:	854a                	mv	a0,s2
    80001f6c:	d2ffe0ef          	jal	80000c9a <release>
              min_proc= p; // Keep lock held for the new candidate
    80001f70:	8926                	mv	s2,s1
    80001f72:	bfd1                	j	80001f46 <choose_next_process+0x6e>
    80001f74:	8926                	mv	s2,s1
    80001f76:	bfc1                	j	80001f46 <choose_next_process+0x6e>
        if(min_proc!= 0) {
    80001f78:	00090963          	beqz	s2,80001f8a <choose_next_process+0xb2>
          release(&min_proc->lock);
    80001f7c:	854a                	mv	a0,s2
    80001f7e:	d1dfe0ef          	jal	80000c9a <release>
    80001f82:	64e2                	ld	s1,24(sp)
    80001f84:	69a2                	ld	s3,8(sp)
    80001f86:	6a02                	ld	s4,0(sp)
    80001f88:	bf49                	j	80001f1a <choose_next_process+0x42>
    80001f8a:	64e2                	ld	s1,24(sp)
    80001f8c:	69a2                	ld	s3,8(sp)
    80001f8e:	6a02                	ld	s4,0(sp)
    80001f90:	b769                	j	80001f1a <choose_next_process+0x42>

0000000080001f92 <scheduler>:
{
    80001f92:	7139                	addi	sp,sp,-64
    80001f94:	fc06                	sd	ra,56(sp)
    80001f96:	f822                	sd	s0,48(sp)
    80001f98:	f426                	sd	s1,40(sp)
    80001f9a:	f04a                	sd	s2,32(sp)
    80001f9c:	ec4e                	sd	s3,24(sp)
    80001f9e:	e852                	sd	s4,16(sp)
    80001fa0:	e456                	sd	s5,8(sp)
    80001fa2:	0080                	addi	s0,sp,64
    80001fa4:	8792                	mv	a5,tp
  int id = r_tp();
    80001fa6:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001fa8:	00779a13          	slli	s4,a5,0x7
    80001fac:	00010717          	auipc	a4,0x10
    80001fb0:	6c470713          	addi	a4,a4,1732 # 80012670 <pid_lock>
    80001fb4:	9752                	add	a4,a4,s4
    80001fb6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001fba:	00010717          	auipc	a4,0x10
    80001fbe:	6ee70713          	addi	a4,a4,1774 # 800126a8 <cpus+0x8>
    80001fc2:	9a3a                	add	s4,s4,a4
      if (p->state == RUNNABLE) {
    80001fc4:	490d                	li	s2,3
        p->state = RUNNING;
    80001fc6:	4a91                	li	s5,4
        c->proc = p;
    80001fc8:	079e                	slli	a5,a5,0x7
    80001fca:	00010997          	auipc	s3,0x10
    80001fce:	6a698993          	addi	s3,s3,1702 # 80012670 <pid_lock>
    80001fd2:	99be                	add	s3,s3,a5
    80001fd4:	a805                	j	80002004 <scheduler+0x72>
        p->state = RUNNING;
    80001fd6:	0154ac23          	sw	s5,24(s1)
        c->proc = p;
    80001fda:	0299b823          	sd	s1,48(s3)
        swtch(&c->context, &p->context);
    80001fde:	06048593          	addi	a1,s1,96
    80001fe2:	8552                	mv	a0,s4
    80001fe4:	736000ef          	jal	8000271a <swtch>
        c->proc = 0;
    80001fe8:	0209b823          	sd	zero,48(s3)
      release(&p->lock);
    80001fec:	8526                	mv	a0,s1
    80001fee:	cadfe0ef          	jal	80000c9a <release>
    if(found == 0) {
    80001ff2:	a809                	j	80002004 <scheduler+0x72>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ff4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ff8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ffc:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80002000:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002004:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002008:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000200c:	10079073          	csrw	sstatus,a5
    p = choose_next_process();
    80002010:	ec9ff0ef          	jal	80001ed8 <choose_next_process>
    80002014:	84aa                	mv	s1,a0
    if(p != 0) {
    80002016:	dd79                	beqz	a0,80001ff4 <scheduler+0x62>
      acquire(&p->lock);
    80002018:	bebfe0ef          	jal	80000c02 <acquire>
      if (p->state == RUNNABLE) {
    8000201c:	4c9c                	lw	a5,24(s1)
    8000201e:	fb278ce3          	beq	a5,s2,80001fd6 <scheduler+0x44>
      release(&p->lock);
    80002022:	8526                	mv	a0,s1
    80002024:	c77fe0ef          	jal	80000c9a <release>
    if(found == 0) {
    80002028:	b7f1                	j	80001ff4 <scheduler+0x62>

000000008000202a <sched>:
{
    8000202a:	7179                	addi	sp,sp,-48
    8000202c:	f406                	sd	ra,40(sp)
    8000202e:	f022                	sd	s0,32(sp)
    80002030:	ec26                	sd	s1,24(sp)
    80002032:	e84a                	sd	s2,16(sp)
    80002034:	e44e                	sd	s3,8(sp)
    80002036:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002038:	8dbff0ef          	jal	80001912 <myproc>
    8000203c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000203e:	b5bfe0ef          	jal	80000b98 <holding>
    80002042:	c92d                	beqz	a0,800020b4 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002044:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002046:	2781                	sext.w	a5,a5
    80002048:	079e                	slli	a5,a5,0x7
    8000204a:	00010717          	auipc	a4,0x10
    8000204e:	62670713          	addi	a4,a4,1574 # 80012670 <pid_lock>
    80002052:	97ba                	add	a5,a5,a4
    80002054:	0a87a703          	lw	a4,168(a5)
    80002058:	4785                	li	a5,1
    8000205a:	06f71363          	bne	a4,a5,800020c0 <sched+0x96>
  if(p->state == RUNNING)
    8000205e:	4c98                	lw	a4,24(s1)
    80002060:	4791                	li	a5,4
    80002062:	06f70563          	beq	a4,a5,800020cc <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002066:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000206a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000206c:	e7b5                	bnez	a5,800020d8 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000206e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002070:	00010917          	auipc	s2,0x10
    80002074:	60090913          	addi	s2,s2,1536 # 80012670 <pid_lock>
    80002078:	2781                	sext.w	a5,a5
    8000207a:	079e                	slli	a5,a5,0x7
    8000207c:	97ca                	add	a5,a5,s2
    8000207e:	0ac7a983          	lw	s3,172(a5)
    80002082:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002084:	2781                	sext.w	a5,a5
    80002086:	079e                	slli	a5,a5,0x7
    80002088:	00010597          	auipc	a1,0x10
    8000208c:	62058593          	addi	a1,a1,1568 # 800126a8 <cpus+0x8>
    80002090:	95be                	add	a1,a1,a5
    80002092:	06048513          	addi	a0,s1,96
    80002096:	684000ef          	jal	8000271a <swtch>
    8000209a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000209c:	2781                	sext.w	a5,a5
    8000209e:	079e                	slli	a5,a5,0x7
    800020a0:	993e                	add	s2,s2,a5
    800020a2:	0b392623          	sw	s3,172(s2)
}
    800020a6:	70a2                	ld	ra,40(sp)
    800020a8:	7402                	ld	s0,32(sp)
    800020aa:	64e2                	ld	s1,24(sp)
    800020ac:	6942                	ld	s2,16(sp)
    800020ae:	69a2                	ld	s3,8(sp)
    800020b0:	6145                	addi	sp,sp,48
    800020b2:	8082                	ret
    panic("sched p->lock");
    800020b4:	00005517          	auipc	a0,0x5
    800020b8:	18450513          	addi	a0,a0,388 # 80007238 <etext+0x238>
    800020bc:	ee6fe0ef          	jal	800007a2 <panic>
    panic("sched locks");
    800020c0:	00005517          	auipc	a0,0x5
    800020c4:	18850513          	addi	a0,a0,392 # 80007248 <etext+0x248>
    800020c8:	edafe0ef          	jal	800007a2 <panic>
    panic("sched running");
    800020cc:	00005517          	auipc	a0,0x5
    800020d0:	18c50513          	addi	a0,a0,396 # 80007258 <etext+0x258>
    800020d4:	ecefe0ef          	jal	800007a2 <panic>
    panic("sched interruptible");
    800020d8:	00005517          	auipc	a0,0x5
    800020dc:	19050513          	addi	a0,a0,400 # 80007268 <etext+0x268>
    800020e0:	ec2fe0ef          	jal	800007a2 <panic>

00000000800020e4 <yield>:
{
    800020e4:	1101                	addi	sp,sp,-32
    800020e6:	ec06                	sd	ra,24(sp)
    800020e8:	e822                	sd	s0,16(sp)
    800020ea:	e426                	sd	s1,8(sp)
    800020ec:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800020ee:	825ff0ef          	jal	80001912 <myproc>
    800020f2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020f4:	b0ffe0ef          	jal	80000c02 <acquire>
  p->state = RUNNABLE;
    800020f8:	478d                	li	a5,3
    800020fa:	cc9c                	sw	a5,24(s1)
  sched();
    800020fc:	f2fff0ef          	jal	8000202a <sched>
  release(&p->lock);
    80002100:	8526                	mv	a0,s1
    80002102:	b99fe0ef          	jal	80000c9a <release>
}
    80002106:	60e2                	ld	ra,24(sp)
    80002108:	6442                	ld	s0,16(sp)
    8000210a:	64a2                	ld	s1,8(sp)
    8000210c:	6105                	addi	sp,sp,32
    8000210e:	8082                	ret

0000000080002110 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002110:	7179                	addi	sp,sp,-48
    80002112:	f406                	sd	ra,40(sp)
    80002114:	f022                	sd	s0,32(sp)
    80002116:	ec26                	sd	s1,24(sp)
    80002118:	e84a                	sd	s2,16(sp)
    8000211a:	e44e                	sd	s3,8(sp)
    8000211c:	1800                	addi	s0,sp,48
    8000211e:	89aa                	mv	s3,a0
    80002120:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002122:	ff0ff0ef          	jal	80001912 <myproc>
    80002126:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002128:	adbfe0ef          	jal	80000c02 <acquire>
  release(lk);
    8000212c:	854a                	mv	a0,s2
    8000212e:	b6dfe0ef          	jal	80000c9a <release>

  // Go to sleep.
  p->chan = chan;
    80002132:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002136:	4789                	li	a5,2
    80002138:	cc9c                	sw	a5,24(s1)

  sched();
    8000213a:	ef1ff0ef          	jal	8000202a <sched>

  // Tidy up.
  p->chan = 0;
    8000213e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002142:	8526                	mv	a0,s1
    80002144:	b57fe0ef          	jal	80000c9a <release>
  acquire(lk);
    80002148:	854a                	mv	a0,s2
    8000214a:	ab9fe0ef          	jal	80000c02 <acquire>
}
    8000214e:	70a2                	ld	ra,40(sp)
    80002150:	7402                	ld	s0,32(sp)
    80002152:	64e2                	ld	s1,24(sp)
    80002154:	6942                	ld	s2,16(sp)
    80002156:	69a2                	ld	s3,8(sp)
    80002158:	6145                	addi	sp,sp,48
    8000215a:	8082                	ret

000000008000215c <wait_sched>:
{
    8000215c:	711d                	addi	sp,sp,-96
    8000215e:	ec86                	sd	ra,88(sp)
    80002160:	e8a2                	sd	s0,80(sp)
    80002162:	e4a6                	sd	s1,72(sp)
    80002164:	e0ca                	sd	s2,64(sp)
    80002166:	fc4e                	sd	s3,56(sp)
    80002168:	f852                	sd	s4,48(sp)
    8000216a:	f456                	sd	s5,40(sp)
    8000216c:	f05a                	sd	s6,32(sp)
    8000216e:	ec5e                	sd	s7,24(sp)
    80002170:	e862                	sd	s8,16(sp)
    80002172:	e466                	sd	s9,8(sp)
    80002174:	e06a                	sd	s10,0(sp)
    80002176:	1080                	addi	s0,sp,96
    80002178:	8c2a                	mv	s8,a0
    8000217a:	8bae                	mv	s7,a1
    8000217c:	8b32                	mv	s6,a2
  struct proc *p = myproc();
    8000217e:	f94ff0ef          	jal	80001912 <myproc>
    80002182:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002184:	00010517          	auipc	a0,0x10
    80002188:	50450513          	addi	a0,a0,1284 # 80012688 <wait_lock>
    8000218c:	a77fe0ef          	jal	80000c02 <acquire>
    havekids = 0;
    80002190:	4c81                	li	s9,0
        if(np->state == ZOMBIE){
    80002192:	4a15                	li	s4,5
        havekids = 1;
    80002194:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80002196:	00017997          	auipc	s3,0x17
    8000219a:	90a98993          	addi	s3,s3,-1782 # 80018aa0 <tickslock>
    sleep(p, &wait_lock);  
    8000219e:	00010d17          	auipc	s10,0x10
    800021a2:	4ead0d13          	addi	s10,s10,1258 # 80012688 <wait_lock>
    800021a6:	a8ed                	j	800022a0 <wait_sched+0x144>
          pid = np->pid;
    800021a8:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800021ac:	040c1b63          	bnez	s8,80002202 <wait_sched+0xa6>
          if(addr_tt != 0 && copyout(p->pagetable, addr_tt, (char *)&np->turnaround_time,
    800021b0:	060b9e63          	bnez	s7,8000222c <wait_sched+0xd0>
          if(addr_wt != 0 && copyout(p->pagetable, addr_wt, (char *)&np->waiting_time,
    800021b4:	000b0c63          	beqz	s6,800021cc <wait_sched+0x70>
    800021b8:	4691                	li	a3,4
    800021ba:	17848613          	addi	a2,s1,376
    800021be:	85da                	mv	a1,s6
    800021c0:	05093503          	ld	a0,80(s2)
    800021c4:	bc0ff0ef          	jal	80001584 <copyout>
    800021c8:	08054763          	bltz	a0,80002256 <wait_sched+0xfa>
          freeproc(np);
    800021cc:	8526                	mv	a0,s1
    800021ce:	9a7ff0ef          	jal	80001b74 <freeproc>
          release(&np->lock);
    800021d2:	8526                	mv	a0,s1
    800021d4:	ac7fe0ef          	jal	80000c9a <release>
          release(&wait_lock);
    800021d8:	00010517          	auipc	a0,0x10
    800021dc:	4b050513          	addi	a0,a0,1200 # 80012688 <wait_lock>
    800021e0:	abbfe0ef          	jal	80000c9a <release>
}
    800021e4:	854e                	mv	a0,s3
    800021e6:	60e6                	ld	ra,88(sp)
    800021e8:	6446                	ld	s0,80(sp)
    800021ea:	64a6                	ld	s1,72(sp)
    800021ec:	6906                	ld	s2,64(sp)
    800021ee:	79e2                	ld	s3,56(sp)
    800021f0:	7a42                	ld	s4,48(sp)
    800021f2:	7aa2                	ld	s5,40(sp)
    800021f4:	7b02                	ld	s6,32(sp)
    800021f6:	6be2                	ld	s7,24(sp)
    800021f8:	6c42                	ld	s8,16(sp)
    800021fa:	6ca2                	ld	s9,8(sp)
    800021fc:	6d02                	ld	s10,0(sp)
    800021fe:	6125                	addi	sp,sp,96
    80002200:	8082                	ret
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002202:	4691                	li	a3,4
    80002204:	02c48613          	addi	a2,s1,44
    80002208:	85e2                	mv	a1,s8
    8000220a:	05093503          	ld	a0,80(s2)
    8000220e:	b76ff0ef          	jal	80001584 <copyout>
    80002212:	f8055fe3          	bgez	a0,800021b0 <wait_sched+0x54>
            release(&np->lock);
    80002216:	8526                	mv	a0,s1
    80002218:	a83fe0ef          	jal	80000c9a <release>
            release(&wait_lock);
    8000221c:	00010517          	auipc	a0,0x10
    80002220:	46c50513          	addi	a0,a0,1132 # 80012688 <wait_lock>
    80002224:	a77fe0ef          	jal	80000c9a <release>
            return -1;
    80002228:	59fd                	li	s3,-1
    8000222a:	bf6d                	j	800021e4 <wait_sched+0x88>
          if(addr_tt != 0 && copyout(p->pagetable, addr_tt, (char *)&np->turnaround_time,
    8000222c:	4691                	li	a3,4
    8000222e:	17448613          	addi	a2,s1,372
    80002232:	85de                	mv	a1,s7
    80002234:	05093503          	ld	a0,80(s2)
    80002238:	b4cff0ef          	jal	80001584 <copyout>
    8000223c:	f6055ce3          	bgez	a0,800021b4 <wait_sched+0x58>
            release(&np->lock);
    80002240:	8526                	mv	a0,s1
    80002242:	a59fe0ef          	jal	80000c9a <release>
            release(&wait_lock);
    80002246:	00010517          	auipc	a0,0x10
    8000224a:	44250513          	addi	a0,a0,1090 # 80012688 <wait_lock>
    8000224e:	a4dfe0ef          	jal	80000c9a <release>
            return -1;
    80002252:	59fd                	li	s3,-1
    80002254:	bf41                	j	800021e4 <wait_sched+0x88>
             release(&np->lock);
    80002256:	8526                	mv	a0,s1
    80002258:	a43fe0ef          	jal	80000c9a <release>
             release(&wait_lock);
    8000225c:	00010517          	auipc	a0,0x10
    80002260:	42c50513          	addi	a0,a0,1068 # 80012688 <wait_lock>
    80002264:	a37fe0ef          	jal	80000c9a <release>
             return -1;
    80002268:	59fd                	li	s3,-1
    8000226a:	bfad                	j	800021e4 <wait_sched+0x88>
    for(np = proc; np < &proc[NPROC]; np++){
    8000226c:	18048493          	addi	s1,s1,384
    80002270:	03348063          	beq	s1,s3,80002290 <wait_sched+0x134>
      if(np->parent == p){
    80002274:	7c9c                	ld	a5,56(s1)
    80002276:	ff279be3          	bne	a5,s2,8000226c <wait_sched+0x110>
        acquire(&np->lock);
    8000227a:	8526                	mv	a0,s1
    8000227c:	987fe0ef          	jal	80000c02 <acquire>
        if(np->state == ZOMBIE){
    80002280:	4c9c                	lw	a5,24(s1)
    80002282:	f34783e3          	beq	a5,s4,800021a8 <wait_sched+0x4c>
        release(&np->lock);
    80002286:	8526                	mv	a0,s1
    80002288:	a13fe0ef          	jal	80000c9a <release>
        havekids = 1;
    8000228c:	8756                	mv	a4,s5
    8000228e:	bff9                	j	8000226c <wait_sched+0x110>
    if(!havekids || p->killed){
    80002290:	cf11                	beqz	a4,800022ac <wait_sched+0x150>
    80002292:	02892783          	lw	a5,40(s2)
    80002296:	eb99                	bnez	a5,800022ac <wait_sched+0x150>
    sleep(p, &wait_lock);  
    80002298:	85ea                	mv	a1,s10
    8000229a:	854a                	mv	a0,s2
    8000229c:	e75ff0ef          	jal	80002110 <sleep>
    havekids = 0;
    800022a0:	8766                	mv	a4,s9
    for(np = proc; np < &proc[NPROC]; np++){
    800022a2:	00010497          	auipc	s1,0x10
    800022a6:	7fe48493          	addi	s1,s1,2046 # 80012aa0 <proc>
    800022aa:	b7e9                	j	80002274 <wait_sched+0x118>
      release(&wait_lock);
    800022ac:	00010517          	auipc	a0,0x10
    800022b0:	3dc50513          	addi	a0,a0,988 # 80012688 <wait_lock>
    800022b4:	9e7fe0ef          	jal	80000c9a <release>
      return -1;
    800022b8:	59fd                	li	s3,-1
    800022ba:	b72d                	j	800021e4 <wait_sched+0x88>

00000000800022bc <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800022bc:	7139                	addi	sp,sp,-64
    800022be:	fc06                	sd	ra,56(sp)
    800022c0:	f822                	sd	s0,48(sp)
    800022c2:	f426                	sd	s1,40(sp)
    800022c4:	f04a                	sd	s2,32(sp)
    800022c6:	ec4e                	sd	s3,24(sp)
    800022c8:	e852                	sd	s4,16(sp)
    800022ca:	e456                	sd	s5,8(sp)
    800022cc:	0080                	addi	s0,sp,64
    800022ce:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800022d0:	00010497          	auipc	s1,0x10
    800022d4:	7d048493          	addi	s1,s1,2000 # 80012aa0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800022d8:	4989                	li	s3,2
        p->state = RUNNABLE;
    800022da:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800022dc:	00016917          	auipc	s2,0x16
    800022e0:	7c490913          	addi	s2,s2,1988 # 80018aa0 <tickslock>
    800022e4:	a801                	j	800022f4 <wakeup+0x38>
      }
      release(&p->lock);
    800022e6:	8526                	mv	a0,s1
    800022e8:	9b3fe0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800022ec:	18048493          	addi	s1,s1,384
    800022f0:	03248263          	beq	s1,s2,80002314 <wakeup+0x58>
    if(p != myproc()){
    800022f4:	e1eff0ef          	jal	80001912 <myproc>
    800022f8:	fea48ae3          	beq	s1,a0,800022ec <wakeup+0x30>
      acquire(&p->lock);
    800022fc:	8526                	mv	a0,s1
    800022fe:	905fe0ef          	jal	80000c02 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002302:	4c9c                	lw	a5,24(s1)
    80002304:	ff3791e3          	bne	a5,s3,800022e6 <wakeup+0x2a>
    80002308:	709c                	ld	a5,32(s1)
    8000230a:	fd479ee3          	bne	a5,s4,800022e6 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000230e:	0154ac23          	sw	s5,24(s1)
    80002312:	bfd1                	j	800022e6 <wakeup+0x2a>
    }
  }
}
    80002314:	70e2                	ld	ra,56(sp)
    80002316:	7442                	ld	s0,48(sp)
    80002318:	74a2                	ld	s1,40(sp)
    8000231a:	7902                	ld	s2,32(sp)
    8000231c:	69e2                	ld	s3,24(sp)
    8000231e:	6a42                	ld	s4,16(sp)
    80002320:	6aa2                	ld	s5,8(sp)
    80002322:	6121                	addi	sp,sp,64
    80002324:	8082                	ret

0000000080002326 <reparent>:
{
    80002326:	7179                	addi	sp,sp,-48
    80002328:	f406                	sd	ra,40(sp)
    8000232a:	f022                	sd	s0,32(sp)
    8000232c:	ec26                	sd	s1,24(sp)
    8000232e:	e84a                	sd	s2,16(sp)
    80002330:	e44e                	sd	s3,8(sp)
    80002332:	e052                	sd	s4,0(sp)
    80002334:	1800                	addi	s0,sp,48
    80002336:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002338:	00010497          	auipc	s1,0x10
    8000233c:	76848493          	addi	s1,s1,1896 # 80012aa0 <proc>
      pp->parent = initproc;
    80002340:	00008a17          	auipc	s4,0x8
    80002344:	1f0a0a13          	addi	s4,s4,496 # 8000a530 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002348:	00016997          	auipc	s3,0x16
    8000234c:	75898993          	addi	s3,s3,1880 # 80018aa0 <tickslock>
    80002350:	a029                	j	8000235a <reparent+0x34>
    80002352:	18048493          	addi	s1,s1,384
    80002356:	01348b63          	beq	s1,s3,8000236c <reparent+0x46>
    if(pp->parent == p){
    8000235a:	7c9c                	ld	a5,56(s1)
    8000235c:	ff279be3          	bne	a5,s2,80002352 <reparent+0x2c>
      pp->parent = initproc;
    80002360:	000a3503          	ld	a0,0(s4)
    80002364:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002366:	f57ff0ef          	jal	800022bc <wakeup>
    8000236a:	b7e5                	j	80002352 <reparent+0x2c>
}
    8000236c:	70a2                	ld	ra,40(sp)
    8000236e:	7402                	ld	s0,32(sp)
    80002370:	64e2                	ld	s1,24(sp)
    80002372:	6942                	ld	s2,16(sp)
    80002374:	69a2                	ld	s3,8(sp)
    80002376:	6a02                	ld	s4,0(sp)
    80002378:	6145                	addi	sp,sp,48
    8000237a:	8082                	ret

000000008000237c <exit>:
{
    8000237c:	7179                	addi	sp,sp,-48
    8000237e:	f406                	sd	ra,40(sp)
    80002380:	f022                	sd	s0,32(sp)
    80002382:	ec26                	sd	s1,24(sp)
    80002384:	e84a                	sd	s2,16(sp)
    80002386:	e44e                	sd	s3,8(sp)
    80002388:	e052                	sd	s4,0(sp)
    8000238a:	1800                	addi	s0,sp,48
    8000238c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000238e:	d84ff0ef          	jal	80001912 <myproc>
    80002392:	89aa                	mv	s3,a0
  if(p == initproc)
    80002394:	00008797          	auipc	a5,0x8
    80002398:	19c7b783          	ld	a5,412(a5) # 8000a530 <initproc>
    8000239c:	0d050493          	addi	s1,a0,208
    800023a0:	15050913          	addi	s2,a0,336
    800023a4:	00a79f63          	bne	a5,a0,800023c2 <exit+0x46>
    panic("init exiting");
    800023a8:	00005517          	auipc	a0,0x5
    800023ac:	ed850513          	addi	a0,a0,-296 # 80007280 <etext+0x280>
    800023b0:	bf2fe0ef          	jal	800007a2 <panic>
      fileclose(f);
    800023b4:	00e020ef          	jal	800043c2 <fileclose>
      p->ofile[fd] = 0;
    800023b8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800023bc:	04a1                	addi	s1,s1,8
    800023be:	01248563          	beq	s1,s2,800023c8 <exit+0x4c>
    if(p->ofile[fd]){
    800023c2:	6088                	ld	a0,0(s1)
    800023c4:	f965                	bnez	a0,800023b4 <exit+0x38>
    800023c6:	bfdd                	j	800023bc <exit+0x40>
  begin_op();
    800023c8:	3e1010ef          	jal	80003fa8 <begin_op>
  iput(p->cwd);
    800023cc:	1509b503          	ld	a0,336(s3)
    800023d0:	4c4010ef          	jal	80003894 <iput>
  end_op();
    800023d4:	43f010ef          	jal	80004012 <end_op>
  p->cwd = 0;
    800023d8:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800023dc:	00010497          	auipc	s1,0x10
    800023e0:	2ac48493          	addi	s1,s1,684 # 80012688 <wait_lock>
    800023e4:	8526                	mv	a0,s1
    800023e6:	81dfe0ef          	jal	80000c02 <acquire>
  reparent(p);
    800023ea:	854e                	mv	a0,s3
    800023ec:	f3bff0ef          	jal	80002326 <reparent>
  wakeup(p->parent);
    800023f0:	0389b503          	ld	a0,56(s3)
    800023f4:	ec9ff0ef          	jal	800022bc <wakeup>
  acquire(&p->lock);
    800023f8:	854e                	mv	a0,s3
    800023fa:	809fe0ef          	jal	80000c02 <acquire>
  p->finish_time = ticks;
    800023fe:	00008797          	auipc	a5,0x8
    80002402:	13a7a783          	lw	a5,314(a5) # 8000a538 <ticks>
    80002406:	16f9a823          	sw	a5,368(s3)
  p->turnaround_time = p->finish_time - p->creation_time;
    8000240a:	1689a703          	lw	a4,360(s3)
    8000240e:	9f99                	subw	a5,a5,a4
    80002410:	16f9aa23          	sw	a5,372(s3)
  p->xstate = status;
    80002414:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002418:	4795                	li	a5,5
    8000241a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000241e:	8526                	mv	a0,s1
    80002420:	87bfe0ef          	jal	80000c9a <release>
  sched();
    80002424:	c07ff0ef          	jal	8000202a <sched>
  panic("zombie exit");
    80002428:	00005517          	auipc	a0,0x5
    8000242c:	e6850513          	addi	a0,a0,-408 # 80007290 <etext+0x290>
    80002430:	b72fe0ef          	jal	800007a2 <panic>

0000000080002434 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002434:	7179                	addi	sp,sp,-48
    80002436:	f406                	sd	ra,40(sp)
    80002438:	f022                	sd	s0,32(sp)
    8000243a:	ec26                	sd	s1,24(sp)
    8000243c:	e84a                	sd	s2,16(sp)
    8000243e:	e44e                	sd	s3,8(sp)
    80002440:	1800                	addi	s0,sp,48
    80002442:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002444:	00010497          	auipc	s1,0x10
    80002448:	65c48493          	addi	s1,s1,1628 # 80012aa0 <proc>
    8000244c:	00016997          	auipc	s3,0x16
    80002450:	65498993          	addi	s3,s3,1620 # 80018aa0 <tickslock>
    acquire(&p->lock);
    80002454:	8526                	mv	a0,s1
    80002456:	facfe0ef          	jal	80000c02 <acquire>
    if(p->pid == pid){
    8000245a:	589c                	lw	a5,48(s1)
    8000245c:	01278b63          	beq	a5,s2,80002472 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002460:	8526                	mv	a0,s1
    80002462:	839fe0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002466:	18048493          	addi	s1,s1,384
    8000246a:	ff3495e3          	bne	s1,s3,80002454 <kill+0x20>
  }
  return -1;
    8000246e:	557d                	li	a0,-1
    80002470:	a819                	j	80002486 <kill+0x52>
      p->killed = 1;
    80002472:	4785                	li	a5,1
    80002474:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002476:	4c98                	lw	a4,24(s1)
    80002478:	4789                	li	a5,2
    8000247a:	00f70d63          	beq	a4,a5,80002494 <kill+0x60>
      release(&p->lock);
    8000247e:	8526                	mv	a0,s1
    80002480:	81bfe0ef          	jal	80000c9a <release>
      return 0;
    80002484:	4501                	li	a0,0
}
    80002486:	70a2                	ld	ra,40(sp)
    80002488:	7402                	ld	s0,32(sp)
    8000248a:	64e2                	ld	s1,24(sp)
    8000248c:	6942                	ld	s2,16(sp)
    8000248e:	69a2                	ld	s3,8(sp)
    80002490:	6145                	addi	sp,sp,48
    80002492:	8082                	ret
        p->state = RUNNABLE;
    80002494:	478d                	li	a5,3
    80002496:	cc9c                	sw	a5,24(s1)
    80002498:	b7dd                	j	8000247e <kill+0x4a>

000000008000249a <setkilled>:

void
setkilled(struct proc *p)
{
    8000249a:	1101                	addi	sp,sp,-32
    8000249c:	ec06                	sd	ra,24(sp)
    8000249e:	e822                	sd	s0,16(sp)
    800024a0:	e426                	sd	s1,8(sp)
    800024a2:	1000                	addi	s0,sp,32
    800024a4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800024a6:	f5cfe0ef          	jal	80000c02 <acquire>
  p->killed = 1;
    800024aa:	4785                	li	a5,1
    800024ac:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800024ae:	8526                	mv	a0,s1
    800024b0:	feafe0ef          	jal	80000c9a <release>
}
    800024b4:	60e2                	ld	ra,24(sp)
    800024b6:	6442                	ld	s0,16(sp)
    800024b8:	64a2                	ld	s1,8(sp)
    800024ba:	6105                	addi	sp,sp,32
    800024bc:	8082                	ret

00000000800024be <killed>:

int
killed(struct proc *p)
{
    800024be:	1101                	addi	sp,sp,-32
    800024c0:	ec06                	sd	ra,24(sp)
    800024c2:	e822                	sd	s0,16(sp)
    800024c4:	e426                	sd	s1,8(sp)
    800024c6:	e04a                	sd	s2,0(sp)
    800024c8:	1000                	addi	s0,sp,32
    800024ca:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800024cc:	f36fe0ef          	jal	80000c02 <acquire>
  k = p->killed;
    800024d0:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800024d4:	8526                	mv	a0,s1
    800024d6:	fc4fe0ef          	jal	80000c9a <release>
  return k;
}
    800024da:	854a                	mv	a0,s2
    800024dc:	60e2                	ld	ra,24(sp)
    800024de:	6442                	ld	s0,16(sp)
    800024e0:	64a2                	ld	s1,8(sp)
    800024e2:	6902                	ld	s2,0(sp)
    800024e4:	6105                	addi	sp,sp,32
    800024e6:	8082                	ret

00000000800024e8 <wait>:
{
    800024e8:	715d                	addi	sp,sp,-80
    800024ea:	e486                	sd	ra,72(sp)
    800024ec:	e0a2                	sd	s0,64(sp)
    800024ee:	fc26                	sd	s1,56(sp)
    800024f0:	f84a                	sd	s2,48(sp)
    800024f2:	f44e                	sd	s3,40(sp)
    800024f4:	f052                	sd	s4,32(sp)
    800024f6:	ec56                	sd	s5,24(sp)
    800024f8:	e85a                	sd	s6,16(sp)
    800024fa:	e45e                	sd	s7,8(sp)
    800024fc:	e062                	sd	s8,0(sp)
    800024fe:	0880                	addi	s0,sp,80
    80002500:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002502:	c10ff0ef          	jal	80001912 <myproc>
    80002506:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002508:	00010517          	auipc	a0,0x10
    8000250c:	18050513          	addi	a0,a0,384 # 80012688 <wait_lock>
    80002510:	ef2fe0ef          	jal	80000c02 <acquire>
    havekids = 0;
    80002514:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002516:	4a15                	li	s4,5
        havekids = 1;
    80002518:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000251a:	00016997          	auipc	s3,0x16
    8000251e:	58698993          	addi	s3,s3,1414 # 80018aa0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002522:	00010c17          	auipc	s8,0x10
    80002526:	166c0c13          	addi	s8,s8,358 # 80012688 <wait_lock>
    8000252a:	a871                	j	800025c6 <wait+0xde>
          pid = pp->pid;
    8000252c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002530:	000b0c63          	beqz	s6,80002548 <wait+0x60>
    80002534:	4691                	li	a3,4
    80002536:	02c48613          	addi	a2,s1,44
    8000253a:	85da                	mv	a1,s6
    8000253c:	05093503          	ld	a0,80(s2)
    80002540:	844ff0ef          	jal	80001584 <copyout>
    80002544:	02054b63          	bltz	a0,8000257a <wait+0x92>
          freeproc(pp);
    80002548:	8526                	mv	a0,s1
    8000254a:	e2aff0ef          	jal	80001b74 <freeproc>
          release(&pp->lock);
    8000254e:	8526                	mv	a0,s1
    80002550:	f4afe0ef          	jal	80000c9a <release>
          release(&wait_lock);
    80002554:	00010517          	auipc	a0,0x10
    80002558:	13450513          	addi	a0,a0,308 # 80012688 <wait_lock>
    8000255c:	f3efe0ef          	jal	80000c9a <release>
}
    80002560:	854e                	mv	a0,s3
    80002562:	60a6                	ld	ra,72(sp)
    80002564:	6406                	ld	s0,64(sp)
    80002566:	74e2                	ld	s1,56(sp)
    80002568:	7942                	ld	s2,48(sp)
    8000256a:	79a2                	ld	s3,40(sp)
    8000256c:	7a02                	ld	s4,32(sp)
    8000256e:	6ae2                	ld	s5,24(sp)
    80002570:	6b42                	ld	s6,16(sp)
    80002572:	6ba2                	ld	s7,8(sp)
    80002574:	6c02                	ld	s8,0(sp)
    80002576:	6161                	addi	sp,sp,80
    80002578:	8082                	ret
            release(&pp->lock);
    8000257a:	8526                	mv	a0,s1
    8000257c:	f1efe0ef          	jal	80000c9a <release>
            release(&wait_lock);
    80002580:	00010517          	auipc	a0,0x10
    80002584:	10850513          	addi	a0,a0,264 # 80012688 <wait_lock>
    80002588:	f12fe0ef          	jal	80000c9a <release>
            return -1;
    8000258c:	59fd                	li	s3,-1
    8000258e:	bfc9                	j	80002560 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002590:	18048493          	addi	s1,s1,384
    80002594:	03348063          	beq	s1,s3,800025b4 <wait+0xcc>
      if(pp->parent == p){
    80002598:	7c9c                	ld	a5,56(s1)
    8000259a:	ff279be3          	bne	a5,s2,80002590 <wait+0xa8>
        acquire(&pp->lock);
    8000259e:	8526                	mv	a0,s1
    800025a0:	e62fe0ef          	jal	80000c02 <acquire>
        if(pp->state == ZOMBIE){
    800025a4:	4c9c                	lw	a5,24(s1)
    800025a6:	f94783e3          	beq	a5,s4,8000252c <wait+0x44>
        release(&pp->lock);
    800025aa:	8526                	mv	a0,s1
    800025ac:	eeefe0ef          	jal	80000c9a <release>
        havekids = 1;
    800025b0:	8756                	mv	a4,s5
    800025b2:	bff9                	j	80002590 <wait+0xa8>
    if(!havekids || killed(p)){
    800025b4:	cf19                	beqz	a4,800025d2 <wait+0xea>
    800025b6:	854a                	mv	a0,s2
    800025b8:	f07ff0ef          	jal	800024be <killed>
    800025bc:	e919                	bnez	a0,800025d2 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800025be:	85e2                	mv	a1,s8
    800025c0:	854a                	mv	a0,s2
    800025c2:	b4fff0ef          	jal	80002110 <sleep>
    havekids = 0;
    800025c6:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800025c8:	00010497          	auipc	s1,0x10
    800025cc:	4d848493          	addi	s1,s1,1240 # 80012aa0 <proc>
    800025d0:	b7e1                	j	80002598 <wait+0xb0>
      release(&wait_lock);
    800025d2:	00010517          	auipc	a0,0x10
    800025d6:	0b650513          	addi	a0,a0,182 # 80012688 <wait_lock>
    800025da:	ec0fe0ef          	jal	80000c9a <release>
      return -1;
    800025de:	59fd                	li	s3,-1
    800025e0:	b741                	j	80002560 <wait+0x78>

00000000800025e2 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800025e2:	7179                	addi	sp,sp,-48
    800025e4:	f406                	sd	ra,40(sp)
    800025e6:	f022                	sd	s0,32(sp)
    800025e8:	ec26                	sd	s1,24(sp)
    800025ea:	e84a                	sd	s2,16(sp)
    800025ec:	e44e                	sd	s3,8(sp)
    800025ee:	e052                	sd	s4,0(sp)
    800025f0:	1800                	addi	s0,sp,48
    800025f2:	84aa                	mv	s1,a0
    800025f4:	892e                	mv	s2,a1
    800025f6:	89b2                	mv	s3,a2
    800025f8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800025fa:	b18ff0ef          	jal	80001912 <myproc>
  if(user_dst){
    800025fe:	cc99                	beqz	s1,8000261c <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002600:	86d2                	mv	a3,s4
    80002602:	864e                	mv	a2,s3
    80002604:	85ca                	mv	a1,s2
    80002606:	6928                	ld	a0,80(a0)
    80002608:	f7dfe0ef          	jal	80001584 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000260c:	70a2                	ld	ra,40(sp)
    8000260e:	7402                	ld	s0,32(sp)
    80002610:	64e2                	ld	s1,24(sp)
    80002612:	6942                	ld	s2,16(sp)
    80002614:	69a2                	ld	s3,8(sp)
    80002616:	6a02                	ld	s4,0(sp)
    80002618:	6145                	addi	sp,sp,48
    8000261a:	8082                	ret
    memmove((char *)dst, src, len);
    8000261c:	000a061b          	sext.w	a2,s4
    80002620:	85ce                	mv	a1,s3
    80002622:	854a                	mv	a0,s2
    80002624:	f0efe0ef          	jal	80000d32 <memmove>
    return 0;
    80002628:	8526                	mv	a0,s1
    8000262a:	b7cd                	j	8000260c <either_copyout+0x2a>

000000008000262c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000262c:	7179                	addi	sp,sp,-48
    8000262e:	f406                	sd	ra,40(sp)
    80002630:	f022                	sd	s0,32(sp)
    80002632:	ec26                	sd	s1,24(sp)
    80002634:	e84a                	sd	s2,16(sp)
    80002636:	e44e                	sd	s3,8(sp)
    80002638:	e052                	sd	s4,0(sp)
    8000263a:	1800                	addi	s0,sp,48
    8000263c:	892a                	mv	s2,a0
    8000263e:	84ae                	mv	s1,a1
    80002640:	89b2                	mv	s3,a2
    80002642:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002644:	aceff0ef          	jal	80001912 <myproc>
  if(user_src){
    80002648:	cc99                	beqz	s1,80002666 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000264a:	86d2                	mv	a3,s4
    8000264c:	864e                	mv	a2,s3
    8000264e:	85ca                	mv	a1,s2
    80002650:	6928                	ld	a0,80(a0)
    80002652:	808ff0ef          	jal	8000165a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002656:	70a2                	ld	ra,40(sp)
    80002658:	7402                	ld	s0,32(sp)
    8000265a:	64e2                	ld	s1,24(sp)
    8000265c:	6942                	ld	s2,16(sp)
    8000265e:	69a2                	ld	s3,8(sp)
    80002660:	6a02                	ld	s4,0(sp)
    80002662:	6145                	addi	sp,sp,48
    80002664:	8082                	ret
    memmove(dst, (char*)src, len);
    80002666:	000a061b          	sext.w	a2,s4
    8000266a:	85ce                	mv	a1,s3
    8000266c:	854a                	mv	a0,s2
    8000266e:	ec4fe0ef          	jal	80000d32 <memmove>
    return 0;
    80002672:	8526                	mv	a0,s1
    80002674:	b7cd                	j	80002656 <either_copyin+0x2a>

0000000080002676 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002676:	715d                	addi	sp,sp,-80
    80002678:	e486                	sd	ra,72(sp)
    8000267a:	e0a2                	sd	s0,64(sp)
    8000267c:	fc26                	sd	s1,56(sp)
    8000267e:	f84a                	sd	s2,48(sp)
    80002680:	f44e                	sd	s3,40(sp)
    80002682:	f052                	sd	s4,32(sp)
    80002684:	ec56                	sd	s5,24(sp)
    80002686:	e85a                	sd	s6,16(sp)
    80002688:	e45e                	sd	s7,8(sp)
    8000268a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000268c:	00005517          	auipc	a0,0x5
    80002690:	9ec50513          	addi	a0,a0,-1556 # 80007078 <etext+0x78>
    80002694:	e3dfd0ef          	jal	800004d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002698:	00010497          	auipc	s1,0x10
    8000269c:	56048493          	addi	s1,s1,1376 # 80012bf8 <proc+0x158>
    800026a0:	00016917          	auipc	s2,0x16
    800026a4:	55890913          	addi	s2,s2,1368 # 80018bf8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026a8:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800026aa:	00005997          	auipc	s3,0x5
    800026ae:	bf698993          	addi	s3,s3,-1034 # 800072a0 <etext+0x2a0>
    printf("%d %s %s", p->pid, state, p->name);
    800026b2:	00005a97          	auipc	s5,0x5
    800026b6:	bf6a8a93          	addi	s5,s5,-1034 # 800072a8 <etext+0x2a8>
    printf("\n");
    800026ba:	00005a17          	auipc	s4,0x5
    800026be:	9bea0a13          	addi	s4,s4,-1602 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026c2:	00005b97          	auipc	s7,0x5
    800026c6:	0d6b8b93          	addi	s7,s7,214 # 80007798 <states.0>
    800026ca:	a829                	j	800026e4 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800026cc:	ed86a583          	lw	a1,-296(a3)
    800026d0:	8556                	mv	a0,s5
    800026d2:	dfffd0ef          	jal	800004d0 <printf>
    printf("\n");
    800026d6:	8552                	mv	a0,s4
    800026d8:	df9fd0ef          	jal	800004d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800026dc:	18048493          	addi	s1,s1,384
    800026e0:	03248263          	beq	s1,s2,80002704 <procdump+0x8e>
    if(p->state == UNUSED)
    800026e4:	86a6                	mv	a3,s1
    800026e6:	ec04a783          	lw	a5,-320(s1)
    800026ea:	dbed                	beqz	a5,800026dc <procdump+0x66>
      state = "???";
    800026ec:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026ee:	fcfb6fe3          	bltu	s6,a5,800026cc <procdump+0x56>
    800026f2:	02079713          	slli	a4,a5,0x20
    800026f6:	01d75793          	srli	a5,a4,0x1d
    800026fa:	97de                	add	a5,a5,s7
    800026fc:	6390                	ld	a2,0(a5)
    800026fe:	f679                	bnez	a2,800026cc <procdump+0x56>
      state = "???";
    80002700:	864e                	mv	a2,s3
    80002702:	b7e9                	j	800026cc <procdump+0x56>
  }
    80002704:	60a6                	ld	ra,72(sp)
    80002706:	6406                	ld	s0,64(sp)
    80002708:	74e2                	ld	s1,56(sp)
    8000270a:	7942                	ld	s2,48(sp)
    8000270c:	79a2                	ld	s3,40(sp)
    8000270e:	7a02                	ld	s4,32(sp)
    80002710:	6ae2                	ld	s5,24(sp)
    80002712:	6b42                	ld	s6,16(sp)
    80002714:	6ba2                	ld	s7,8(sp)
    80002716:	6161                	addi	sp,sp,80
    80002718:	8082                	ret

000000008000271a <swtch>:
    8000271a:	00153023          	sd	ra,0(a0)
    8000271e:	00253423          	sd	sp,8(a0)
    80002722:	e900                	sd	s0,16(a0)
    80002724:	ed04                	sd	s1,24(a0)
    80002726:	03253023          	sd	s2,32(a0)
    8000272a:	03353423          	sd	s3,40(a0)
    8000272e:	03453823          	sd	s4,48(a0)
    80002732:	03553c23          	sd	s5,56(a0)
    80002736:	05653023          	sd	s6,64(a0)
    8000273a:	05753423          	sd	s7,72(a0)
    8000273e:	05853823          	sd	s8,80(a0)
    80002742:	05953c23          	sd	s9,88(a0)
    80002746:	07a53023          	sd	s10,96(a0)
    8000274a:	07b53423          	sd	s11,104(a0)
    8000274e:	0005b083          	ld	ra,0(a1)
    80002752:	0085b103          	ld	sp,8(a1)
    80002756:	6980                	ld	s0,16(a1)
    80002758:	6d84                	ld	s1,24(a1)
    8000275a:	0205b903          	ld	s2,32(a1)
    8000275e:	0285b983          	ld	s3,40(a1)
    80002762:	0305ba03          	ld	s4,48(a1)
    80002766:	0385ba83          	ld	s5,56(a1)
    8000276a:	0405bb03          	ld	s6,64(a1)
    8000276e:	0485bb83          	ld	s7,72(a1)
    80002772:	0505bc03          	ld	s8,80(a1)
    80002776:	0585bc83          	ld	s9,88(a1)
    8000277a:	0605bd03          	ld	s10,96(a1)
    8000277e:	0685bd83          	ld	s11,104(a1)
    80002782:	8082                	ret

0000000080002784 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002784:	1141                	addi	sp,sp,-16
    80002786:	e406                	sd	ra,8(sp)
    80002788:	e022                	sd	s0,0(sp)
    8000278a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000278c:	00005597          	auipc	a1,0x5
    80002790:	b5c58593          	addi	a1,a1,-1188 # 800072e8 <etext+0x2e8>
    80002794:	00016517          	auipc	a0,0x16
    80002798:	30c50513          	addi	a0,a0,780 # 80018aa0 <tickslock>
    8000279c:	be6fe0ef          	jal	80000b82 <initlock>
}
    800027a0:	60a2                	ld	ra,8(sp)
    800027a2:	6402                	ld	s0,0(sp)
    800027a4:	0141                	addi	sp,sp,16
    800027a6:	8082                	ret

00000000800027a8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800027a8:	1141                	addi	sp,sp,-16
    800027aa:	e422                	sd	s0,8(sp)
    800027ac:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027ae:	00003797          	auipc	a5,0x3
    800027b2:	f8278793          	addi	a5,a5,-126 # 80005730 <kernelvec>
    800027b6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800027ba:	6422                	ld	s0,8(sp)
    800027bc:	0141                	addi	sp,sp,16
    800027be:	8082                	ret

00000000800027c0 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800027c0:	1141                	addi	sp,sp,-16
    800027c2:	e406                	sd	ra,8(sp)
    800027c4:	e022                	sd	s0,0(sp)
    800027c6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800027c8:	94aff0ef          	jal	80001912 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027cc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800027d0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027d2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800027d6:	00004697          	auipc	a3,0x4
    800027da:	82a68693          	addi	a3,a3,-2006 # 80006000 <_trampoline>
    800027de:	00004717          	auipc	a4,0x4
    800027e2:	82270713          	addi	a4,a4,-2014 # 80006000 <_trampoline>
    800027e6:	8f15                	sub	a4,a4,a3
    800027e8:	040007b7          	lui	a5,0x4000
    800027ec:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800027ee:	07b2                	slli	a5,a5,0xc
    800027f0:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027f2:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800027f6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800027f8:	18002673          	csrr	a2,satp
    800027fc:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800027fe:	6d30                	ld	a2,88(a0)
    80002800:	6138                	ld	a4,64(a0)
    80002802:	6585                	lui	a1,0x1
    80002804:	972e                	add	a4,a4,a1
    80002806:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002808:	6d38                	ld	a4,88(a0)
    8000280a:	00000617          	auipc	a2,0x0
    8000280e:	11a60613          	addi	a2,a2,282 # 80002924 <usertrap>
    80002812:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002814:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002816:	8612                	mv	a2,tp
    80002818:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000281a:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000281e:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002822:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002826:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000282a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000282c:	6f18                	ld	a4,24(a4)
    8000282e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002832:	6928                	ld	a0,80(a0)
    80002834:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002836:	00004717          	auipc	a4,0x4
    8000283a:	86670713          	addi	a4,a4,-1946 # 8000609c <userret>
    8000283e:	8f15                	sub	a4,a4,a3
    80002840:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002842:	577d                	li	a4,-1
    80002844:	177e                	slli	a4,a4,0x3f
    80002846:	8d59                	or	a0,a0,a4
    80002848:	9782                	jalr	a5
}
    8000284a:	60a2                	ld	ra,8(sp)
    8000284c:	6402                	ld	s0,0(sp)
    8000284e:	0141                	addi	sp,sp,16
    80002850:	8082                	ret

0000000080002852 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002852:	1101                	addi	sp,sp,-32
    80002854:	ec06                	sd	ra,24(sp)
    80002856:	e822                	sd	s0,16(sp)
    80002858:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000285a:	88cff0ef          	jal	800018e6 <cpuid>
    8000285e:	cd11                	beqz	a0,8000287a <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002860:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002864:	000f4737          	lui	a4,0xf4
    80002868:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000286c:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000286e:	14d79073          	csrw	stimecmp,a5
}
    80002872:	60e2                	ld	ra,24(sp)
    80002874:	6442                	ld	s0,16(sp)
    80002876:	6105                	addi	sp,sp,32
    80002878:	8082                	ret
    8000287a:	e426                	sd	s1,8(sp)
    8000287c:	e04a                	sd	s2,0(sp)
    acquire(&tickslock);
    8000287e:	00016917          	auipc	s2,0x16
    80002882:	22290913          	addi	s2,s2,546 # 80018aa0 <tickslock>
    80002886:	854a                	mv	a0,s2
    80002888:	b7afe0ef          	jal	80000c02 <acquire>
    ticks++;
    8000288c:	00008497          	auipc	s1,0x8
    80002890:	cac48493          	addi	s1,s1,-852 # 8000a538 <ticks>
    80002894:	409c                	lw	a5,0(s1)
    80002896:	2785                	addiw	a5,a5,1
    80002898:	c09c                	sw	a5,0(s1)
    update_time();
    8000289a:	dd4ff0ef          	jal	80001e6e <update_time>
    wakeup(&ticks);
    8000289e:	8526                	mv	a0,s1
    800028a0:	a1dff0ef          	jal	800022bc <wakeup>
    release(&tickslock);
    800028a4:	854a                	mv	a0,s2
    800028a6:	bf4fe0ef          	jal	80000c9a <release>
    800028aa:	64a2                	ld	s1,8(sp)
    800028ac:	6902                	ld	s2,0(sp)
    800028ae:	bf4d                	j	80002860 <clockintr+0xe>

00000000800028b0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800028b0:	1101                	addi	sp,sp,-32
    800028b2:	ec06                	sd	ra,24(sp)
    800028b4:	e822                	sd	s0,16(sp)
    800028b6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028b8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800028bc:	57fd                	li	a5,-1
    800028be:	17fe                	slli	a5,a5,0x3f
    800028c0:	07a5                	addi	a5,a5,9
    800028c2:	00f70c63          	beq	a4,a5,800028da <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800028c6:	57fd                	li	a5,-1
    800028c8:	17fe                	slli	a5,a5,0x3f
    800028ca:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800028cc:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800028ce:	04f70763          	beq	a4,a5,8000291c <devintr+0x6c>
  }
}
    800028d2:	60e2                	ld	ra,24(sp)
    800028d4:	6442                	ld	s0,16(sp)
    800028d6:	6105                	addi	sp,sp,32
    800028d8:	8082                	ret
    800028da:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800028dc:	701020ef          	jal	800057dc <plic_claim>
    800028e0:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800028e2:	47a9                	li	a5,10
    800028e4:	00f50963          	beq	a0,a5,800028f6 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800028e8:	4785                	li	a5,1
    800028ea:	00f50963          	beq	a0,a5,800028fc <devintr+0x4c>
    return 1;
    800028ee:	4505                	li	a0,1
    } else if(irq){
    800028f0:	e889                	bnez	s1,80002902 <devintr+0x52>
    800028f2:	64a2                	ld	s1,8(sp)
    800028f4:	bff9                	j	800028d2 <devintr+0x22>
      uartintr();
    800028f6:	91efe0ef          	jal	80000a14 <uartintr>
    if(irq)
    800028fa:	a819                	j	80002910 <devintr+0x60>
      virtio_disk_intr();
    800028fc:	3a6030ef          	jal	80005ca2 <virtio_disk_intr>
    if(irq)
    80002900:	a801                	j	80002910 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80002902:	85a6                	mv	a1,s1
    80002904:	00005517          	auipc	a0,0x5
    80002908:	9ec50513          	addi	a0,a0,-1556 # 800072f0 <etext+0x2f0>
    8000290c:	bc5fd0ef          	jal	800004d0 <printf>
      plic_complete(irq);
    80002910:	8526                	mv	a0,s1
    80002912:	6eb020ef          	jal	800057fc <plic_complete>
    return 1;
    80002916:	4505                	li	a0,1
    80002918:	64a2                	ld	s1,8(sp)
    8000291a:	bf65                	j	800028d2 <devintr+0x22>
    clockintr();
    8000291c:	f37ff0ef          	jal	80002852 <clockintr>
    return 2;
    80002920:	4509                	li	a0,2
    80002922:	bf45                	j	800028d2 <devintr+0x22>

0000000080002924 <usertrap>:
{
    80002924:	1101                	addi	sp,sp,-32
    80002926:	ec06                	sd	ra,24(sp)
    80002928:	e822                	sd	s0,16(sp)
    8000292a:	e426                	sd	s1,8(sp)
    8000292c:	e04a                	sd	s2,0(sp)
    8000292e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002930:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002934:	1007f793          	andi	a5,a5,256
    80002938:	ef85                	bnez	a5,80002970 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000293a:	00003797          	auipc	a5,0x3
    8000293e:	df678793          	addi	a5,a5,-522 # 80005730 <kernelvec>
    80002942:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002946:	fcdfe0ef          	jal	80001912 <myproc>
    8000294a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000294c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000294e:	14102773          	csrr	a4,sepc
    80002952:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002954:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002958:	47a1                	li	a5,8
    8000295a:	02f70163          	beq	a4,a5,8000297c <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    8000295e:	f53ff0ef          	jal	800028b0 <devintr>
    80002962:	892a                	mv	s2,a0
    80002964:	c135                	beqz	a0,800029c8 <usertrap+0xa4>
  if(killed(p))
    80002966:	8526                	mv	a0,s1
    80002968:	b57ff0ef          	jal	800024be <killed>
    8000296c:	cd1d                	beqz	a0,800029aa <usertrap+0x86>
    8000296e:	a81d                	j	800029a4 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80002970:	00005517          	auipc	a0,0x5
    80002974:	9a050513          	addi	a0,a0,-1632 # 80007310 <etext+0x310>
    80002978:	e2bfd0ef          	jal	800007a2 <panic>
    if(killed(p))
    8000297c:	b43ff0ef          	jal	800024be <killed>
    80002980:	e121                	bnez	a0,800029c0 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80002982:	6cb8                	ld	a4,88(s1)
    80002984:	6f1c                	ld	a5,24(a4)
    80002986:	0791                	addi	a5,a5,4
    80002988:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000298a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000298e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002992:	10079073          	csrw	sstatus,a5
    syscall();
    80002996:	24a000ef          	jal	80002be0 <syscall>
  if(killed(p))
    8000299a:	8526                	mv	a0,s1
    8000299c:	b23ff0ef          	jal	800024be <killed>
    800029a0:	c901                	beqz	a0,800029b0 <usertrap+0x8c>
    800029a2:	4901                	li	s2,0
    exit(-1);
    800029a4:	557d                	li	a0,-1
    800029a6:	9d7ff0ef          	jal	8000237c <exit>
  if(which_dev == 2)
    800029aa:	4789                	li	a5,2
    800029ac:	04f90563          	beq	s2,a5,800029f6 <usertrap+0xd2>
  usertrapret();
    800029b0:	e11ff0ef          	jal	800027c0 <usertrapret>
}
    800029b4:	60e2                	ld	ra,24(sp)
    800029b6:	6442                	ld	s0,16(sp)
    800029b8:	64a2                	ld	s1,8(sp)
    800029ba:	6902                	ld	s2,0(sp)
    800029bc:	6105                	addi	sp,sp,32
    800029be:	8082                	ret
      exit(-1);
    800029c0:	557d                	li	a0,-1
    800029c2:	9bbff0ef          	jal	8000237c <exit>
    800029c6:	bf75                	j	80002982 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029c8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800029cc:	5890                	lw	a2,48(s1)
    800029ce:	00005517          	auipc	a0,0x5
    800029d2:	96250513          	addi	a0,a0,-1694 # 80007330 <etext+0x330>
    800029d6:	afbfd0ef          	jal	800004d0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029da:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800029de:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800029e2:	00005517          	auipc	a0,0x5
    800029e6:	97e50513          	addi	a0,a0,-1666 # 80007360 <etext+0x360>
    800029ea:	ae7fd0ef          	jal	800004d0 <printf>
    setkilled(p);
    800029ee:	8526                	mv	a0,s1
    800029f0:	aabff0ef          	jal	8000249a <setkilled>
    800029f4:	b75d                	j	8000299a <usertrap+0x76>
    yield();
    800029f6:	eeeff0ef          	jal	800020e4 <yield>
    800029fa:	bf5d                	j	800029b0 <usertrap+0x8c>

00000000800029fc <kerneltrap>:
{
    800029fc:	7179                	addi	sp,sp,-48
    800029fe:	f406                	sd	ra,40(sp)
    80002a00:	f022                	sd	s0,32(sp)
    80002a02:	ec26                	sd	s1,24(sp)
    80002a04:	e84a                	sd	s2,16(sp)
    80002a06:	e44e                	sd	s3,8(sp)
    80002a08:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a0a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a0e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a12:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002a16:	1004f793          	andi	a5,s1,256
    80002a1a:	c795                	beqz	a5,80002a46 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a1c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002a20:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002a22:	eb85                	bnez	a5,80002a52 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002a24:	e8dff0ef          	jal	800028b0 <devintr>
    80002a28:	c91d                	beqz	a0,80002a5e <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002a2a:	4789                	li	a5,2
    80002a2c:	04f50a63          	beq	a0,a5,80002a80 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a30:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a34:	10049073          	csrw	sstatus,s1
}
    80002a38:	70a2                	ld	ra,40(sp)
    80002a3a:	7402                	ld	s0,32(sp)
    80002a3c:	64e2                	ld	s1,24(sp)
    80002a3e:	6942                	ld	s2,16(sp)
    80002a40:	69a2                	ld	s3,8(sp)
    80002a42:	6145                	addi	sp,sp,48
    80002a44:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002a46:	00005517          	auipc	a0,0x5
    80002a4a:	94250513          	addi	a0,a0,-1726 # 80007388 <etext+0x388>
    80002a4e:	d55fd0ef          	jal	800007a2 <panic>
    panic("kerneltrap: interrupts enabled");
    80002a52:	00005517          	auipc	a0,0x5
    80002a56:	95e50513          	addi	a0,a0,-1698 # 800073b0 <etext+0x3b0>
    80002a5a:	d49fd0ef          	jal	800007a2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a5e:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a62:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002a66:	85ce                	mv	a1,s3
    80002a68:	00005517          	auipc	a0,0x5
    80002a6c:	96850513          	addi	a0,a0,-1688 # 800073d0 <etext+0x3d0>
    80002a70:	a61fd0ef          	jal	800004d0 <printf>
    panic("kerneltrap");
    80002a74:	00005517          	auipc	a0,0x5
    80002a78:	98450513          	addi	a0,a0,-1660 # 800073f8 <etext+0x3f8>
    80002a7c:	d27fd0ef          	jal	800007a2 <panic>
  if(which_dev == 2 && myproc() != 0)
    80002a80:	e93fe0ef          	jal	80001912 <myproc>
    80002a84:	d555                	beqz	a0,80002a30 <kerneltrap+0x34>
    yield();
    80002a86:	e5eff0ef          	jal	800020e4 <yield>
    80002a8a:	b75d                	j	80002a30 <kerneltrap+0x34>

0000000080002a8c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002a8c:	1101                	addi	sp,sp,-32
    80002a8e:	ec06                	sd	ra,24(sp)
    80002a90:	e822                	sd	s0,16(sp)
    80002a92:	e426                	sd	s1,8(sp)
    80002a94:	1000                	addi	s0,sp,32
    80002a96:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002a98:	e7bfe0ef          	jal	80001912 <myproc>
  switch (n) {
    80002a9c:	4795                	li	a5,5
    80002a9e:	0497e163          	bltu	a5,s1,80002ae0 <argraw+0x54>
    80002aa2:	048a                	slli	s1,s1,0x2
    80002aa4:	00005717          	auipc	a4,0x5
    80002aa8:	d2470713          	addi	a4,a4,-732 # 800077c8 <states.0+0x30>
    80002aac:	94ba                	add	s1,s1,a4
    80002aae:	409c                	lw	a5,0(s1)
    80002ab0:	97ba                	add	a5,a5,a4
    80002ab2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002ab4:	6d3c                	ld	a5,88(a0)
    80002ab6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002ab8:	60e2                	ld	ra,24(sp)
    80002aba:	6442                	ld	s0,16(sp)
    80002abc:	64a2                	ld	s1,8(sp)
    80002abe:	6105                	addi	sp,sp,32
    80002ac0:	8082                	ret
    return p->trapframe->a1;
    80002ac2:	6d3c                	ld	a5,88(a0)
    80002ac4:	7fa8                	ld	a0,120(a5)
    80002ac6:	bfcd                	j	80002ab8 <argraw+0x2c>
    return p->trapframe->a2;
    80002ac8:	6d3c                	ld	a5,88(a0)
    80002aca:	63c8                	ld	a0,128(a5)
    80002acc:	b7f5                	j	80002ab8 <argraw+0x2c>
    return p->trapframe->a3;
    80002ace:	6d3c                	ld	a5,88(a0)
    80002ad0:	67c8                	ld	a0,136(a5)
    80002ad2:	b7dd                	j	80002ab8 <argraw+0x2c>
    return p->trapframe->a4;
    80002ad4:	6d3c                	ld	a5,88(a0)
    80002ad6:	6bc8                	ld	a0,144(a5)
    80002ad8:	b7c5                	j	80002ab8 <argraw+0x2c>
    return p->trapframe->a5;
    80002ada:	6d3c                	ld	a5,88(a0)
    80002adc:	6fc8                	ld	a0,152(a5)
    80002ade:	bfe9                	j	80002ab8 <argraw+0x2c>
  panic("argraw");
    80002ae0:	00005517          	auipc	a0,0x5
    80002ae4:	92850513          	addi	a0,a0,-1752 # 80007408 <etext+0x408>
    80002ae8:	cbbfd0ef          	jal	800007a2 <panic>

0000000080002aec <fetchaddr>:
{
    80002aec:	1101                	addi	sp,sp,-32
    80002aee:	ec06                	sd	ra,24(sp)
    80002af0:	e822                	sd	s0,16(sp)
    80002af2:	e426                	sd	s1,8(sp)
    80002af4:	e04a                	sd	s2,0(sp)
    80002af6:	1000                	addi	s0,sp,32
    80002af8:	84aa                	mv	s1,a0
    80002afa:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002afc:	e17fe0ef          	jal	80001912 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002b00:	653c                	ld	a5,72(a0)
    80002b02:	02f4f663          	bgeu	s1,a5,80002b2e <fetchaddr+0x42>
    80002b06:	00848713          	addi	a4,s1,8
    80002b0a:	02e7e463          	bltu	a5,a4,80002b32 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002b0e:	46a1                	li	a3,8
    80002b10:	8626                	mv	a2,s1
    80002b12:	85ca                	mv	a1,s2
    80002b14:	6928                	ld	a0,80(a0)
    80002b16:	b45fe0ef          	jal	8000165a <copyin>
    80002b1a:	00a03533          	snez	a0,a0
    80002b1e:	40a00533          	neg	a0,a0
}
    80002b22:	60e2                	ld	ra,24(sp)
    80002b24:	6442                	ld	s0,16(sp)
    80002b26:	64a2                	ld	s1,8(sp)
    80002b28:	6902                	ld	s2,0(sp)
    80002b2a:	6105                	addi	sp,sp,32
    80002b2c:	8082                	ret
    return -1;
    80002b2e:	557d                	li	a0,-1
    80002b30:	bfcd                	j	80002b22 <fetchaddr+0x36>
    80002b32:	557d                	li	a0,-1
    80002b34:	b7fd                	j	80002b22 <fetchaddr+0x36>

0000000080002b36 <fetchstr>:
{
    80002b36:	7179                	addi	sp,sp,-48
    80002b38:	f406                	sd	ra,40(sp)
    80002b3a:	f022                	sd	s0,32(sp)
    80002b3c:	ec26                	sd	s1,24(sp)
    80002b3e:	e84a                	sd	s2,16(sp)
    80002b40:	e44e                	sd	s3,8(sp)
    80002b42:	1800                	addi	s0,sp,48
    80002b44:	892a                	mv	s2,a0
    80002b46:	84ae                	mv	s1,a1
    80002b48:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002b4a:	dc9fe0ef          	jal	80001912 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002b4e:	86ce                	mv	a3,s3
    80002b50:	864a                	mv	a2,s2
    80002b52:	85a6                	mv	a1,s1
    80002b54:	6928                	ld	a0,80(a0)
    80002b56:	b8bfe0ef          	jal	800016e0 <copyinstr>
    80002b5a:	00054c63          	bltz	a0,80002b72 <fetchstr+0x3c>
  return strlen(buf);
    80002b5e:	8526                	mv	a0,s1
    80002b60:	ae6fe0ef          	jal	80000e46 <strlen>
}
    80002b64:	70a2                	ld	ra,40(sp)
    80002b66:	7402                	ld	s0,32(sp)
    80002b68:	64e2                	ld	s1,24(sp)
    80002b6a:	6942                	ld	s2,16(sp)
    80002b6c:	69a2                	ld	s3,8(sp)
    80002b6e:	6145                	addi	sp,sp,48
    80002b70:	8082                	ret
    return -1;
    80002b72:	557d                	li	a0,-1
    80002b74:	bfc5                	j	80002b64 <fetchstr+0x2e>

0000000080002b76 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002b76:	1101                	addi	sp,sp,-32
    80002b78:	ec06                	sd	ra,24(sp)
    80002b7a:	e822                	sd	s0,16(sp)
    80002b7c:	e426                	sd	s1,8(sp)
    80002b7e:	1000                	addi	s0,sp,32
    80002b80:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b82:	f0bff0ef          	jal	80002a8c <argraw>
    80002b86:	c088                	sw	a0,0(s1)
}
    80002b88:	60e2                	ld	ra,24(sp)
    80002b8a:	6442                	ld	s0,16(sp)
    80002b8c:	64a2                	ld	s1,8(sp)
    80002b8e:	6105                	addi	sp,sp,32
    80002b90:	8082                	ret

0000000080002b92 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002b92:	1101                	addi	sp,sp,-32
    80002b94:	ec06                	sd	ra,24(sp)
    80002b96:	e822                	sd	s0,16(sp)
    80002b98:	e426                	sd	s1,8(sp)
    80002b9a:	1000                	addi	s0,sp,32
    80002b9c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b9e:	eefff0ef          	jal	80002a8c <argraw>
    80002ba2:	e088                	sd	a0,0(s1)
   return 0;
}
    80002ba4:	4501                	li	a0,0
    80002ba6:	60e2                	ld	ra,24(sp)
    80002ba8:	6442                	ld	s0,16(sp)
    80002baa:	64a2                	ld	s1,8(sp)
    80002bac:	6105                	addi	sp,sp,32
    80002bae:	8082                	ret

0000000080002bb0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002bb0:	7179                	addi	sp,sp,-48
    80002bb2:	f406                	sd	ra,40(sp)
    80002bb4:	f022                	sd	s0,32(sp)
    80002bb6:	ec26                	sd	s1,24(sp)
    80002bb8:	e84a                	sd	s2,16(sp)
    80002bba:	1800                	addi	s0,sp,48
    80002bbc:	84ae                	mv	s1,a1
    80002bbe:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002bc0:	fd840593          	addi	a1,s0,-40
    80002bc4:	fcfff0ef          	jal	80002b92 <argaddr>
  return fetchstr(addr, buf, max);
    80002bc8:	864a                	mv	a2,s2
    80002bca:	85a6                	mv	a1,s1
    80002bcc:	fd843503          	ld	a0,-40(s0)
    80002bd0:	f67ff0ef          	jal	80002b36 <fetchstr>
}
    80002bd4:	70a2                	ld	ra,40(sp)
    80002bd6:	7402                	ld	s0,32(sp)
    80002bd8:	64e2                	ld	s1,24(sp)
    80002bda:	6942                	ld	s2,16(sp)
    80002bdc:	6145                	addi	sp,sp,48
    80002bde:	8082                	ret

0000000080002be0 <syscall>:

};

void
syscall(void)
{
    80002be0:	1101                	addi	sp,sp,-32
    80002be2:	ec06                	sd	ra,24(sp)
    80002be4:	e822                	sd	s0,16(sp)
    80002be6:	e426                	sd	s1,8(sp)
    80002be8:	e04a                	sd	s2,0(sp)
    80002bea:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002bec:	d27fe0ef          	jal	80001912 <myproc>
    80002bf0:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002bf2:	05853903          	ld	s2,88(a0)
    80002bf6:	0a893783          	ld	a5,168(s2)
    80002bfa:	0007869b          	sext.w	a3,a5
  syscall_count++; 
    80002bfe:	00008617          	auipc	a2,0x8
    80002c02:	94260613          	addi	a2,a2,-1726 # 8000a540 <syscall_count>
    80002c06:	6218                	ld	a4,0(a2)
    80002c08:	0705                	addi	a4,a4,1
    80002c0a:	e218                	sd	a4,0(a2)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002c0c:	37fd                	addiw	a5,a5,-1
    80002c0e:	4775                	li	a4,29
    80002c10:	00f76f63          	bltu	a4,a5,80002c2e <syscall+0x4e>
    80002c14:	00369713          	slli	a4,a3,0x3
    80002c18:	00005797          	auipc	a5,0x5
    80002c1c:	bc878793          	addi	a5,a5,-1080 # 800077e0 <syscalls>
    80002c20:	97ba                	add	a5,a5,a4
    80002c22:	639c                	ld	a5,0(a5)
    80002c24:	c789                	beqz	a5,80002c2e <syscall+0x4e>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002c26:	9782                	jalr	a5
    80002c28:	06a93823          	sd	a0,112(s2)
    80002c2c:	a829                	j	80002c46 <syscall+0x66>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002c2e:	15848613          	addi	a2,s1,344
    80002c32:	588c                	lw	a1,48(s1)
    80002c34:	00004517          	auipc	a0,0x4
    80002c38:	7dc50513          	addi	a0,a0,2012 # 80007410 <etext+0x410>
    80002c3c:	895fd0ef          	jal	800004d0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002c40:	6cbc                	ld	a5,88(s1)
    80002c42:	577d                	li	a4,-1
    80002c44:	fbb8                	sd	a4,112(a5)
  }
    80002c46:	60e2                	ld	ra,24(sp)
    80002c48:	6442                	ld	s0,16(sp)
    80002c4a:	64a2                	ld	s1,8(sp)
    80002c4c:	6902                	ld	s2,0(sp)
    80002c4e:	6105                	addi	sp,sp,32
    80002c50:	8082                	ret

0000000080002c52 <sys_exit>:
#include "proc.h"
//#include "date.h"   

uint64
sys_exit(void)
{
    80002c52:	1101                	addi	sp,sp,-32
    80002c54:	ec06                	sd	ra,24(sp)
    80002c56:	e822                	sd	s0,16(sp)
    80002c58:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002c5a:	fec40593          	addi	a1,s0,-20
    80002c5e:	4501                	li	a0,0
    80002c60:	f17ff0ef          	jal	80002b76 <argint>
  exit(n);
    80002c64:	fec42503          	lw	a0,-20(s0)
    80002c68:	f14ff0ef          	jal	8000237c <exit>
  return 0;  // not reached
}
    80002c6c:	4501                	li	a0,0
    80002c6e:	60e2                	ld	ra,24(sp)
    80002c70:	6442                	ld	s0,16(sp)
    80002c72:	6105                	addi	sp,sp,32
    80002c74:	8082                	ret

0000000080002c76 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002c76:	1141                	addi	sp,sp,-16
    80002c78:	e406                	sd	ra,8(sp)
    80002c7a:	e022                	sd	s0,0(sp)
    80002c7c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002c7e:	c95fe0ef          	jal	80001912 <myproc>
}
    80002c82:	5908                	lw	a0,48(a0)
    80002c84:	60a2                	ld	ra,8(sp)
    80002c86:	6402                	ld	s0,0(sp)
    80002c88:	0141                	addi	sp,sp,16
    80002c8a:	8082                	ret

0000000080002c8c <sys_fork>:

uint64
sys_fork(void)
{
    80002c8c:	1141                	addi	sp,sp,-16
    80002c8e:	e406                	sd	ra,8(sp)
    80002c90:	e022                	sd	s0,0(sp)
    80002c92:	0800                	addi	s0,sp,16
  return fork();
    80002c94:	8ccff0ef          	jal	80001d60 <fork>
}
    80002c98:	60a2                	ld	ra,8(sp)
    80002c9a:	6402                	ld	s0,0(sp)
    80002c9c:	0141                	addi	sp,sp,16
    80002c9e:	8082                	ret

0000000080002ca0 <sys_wait>:

uint64
sys_wait(void)
{
    80002ca0:	1101                	addi	sp,sp,-32
    80002ca2:	ec06                	sd	ra,24(sp)
    80002ca4:	e822                	sd	s0,16(sp)
    80002ca6:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002ca8:	fe840593          	addi	a1,s0,-24
    80002cac:	4501                	li	a0,0
    80002cae:	ee5ff0ef          	jal	80002b92 <argaddr>
  return wait(p);
    80002cb2:	fe843503          	ld	a0,-24(s0)
    80002cb6:	833ff0ef          	jal	800024e8 <wait>
}
    80002cba:	60e2                	ld	ra,24(sp)
    80002cbc:	6442                	ld	s0,16(sp)
    80002cbe:	6105                	addi	sp,sp,32
    80002cc0:	8082                	ret

0000000080002cc2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002cc2:	7179                	addi	sp,sp,-48
    80002cc4:	f406                	sd	ra,40(sp)
    80002cc6:	f022                	sd	s0,32(sp)
    80002cc8:	ec26                	sd	s1,24(sp)
    80002cca:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002ccc:	fdc40593          	addi	a1,s0,-36
    80002cd0:	4501                	li	a0,0
    80002cd2:	ea5ff0ef          	jal	80002b76 <argint>
  addr = myproc()->sz;
    80002cd6:	c3dfe0ef          	jal	80001912 <myproc>
    80002cda:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002cdc:	fdc42503          	lw	a0,-36(s0)
    80002ce0:	830ff0ef          	jal	80001d10 <growproc>
    80002ce4:	00054863          	bltz	a0,80002cf4 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002ce8:	8526                	mv	a0,s1
    80002cea:	70a2                	ld	ra,40(sp)
    80002cec:	7402                	ld	s0,32(sp)
    80002cee:	64e2                	ld	s1,24(sp)
    80002cf0:	6145                	addi	sp,sp,48
    80002cf2:	8082                	ret
    return -1;
    80002cf4:	54fd                	li	s1,-1
    80002cf6:	bfcd                	j	80002ce8 <sys_sbrk+0x26>

0000000080002cf8 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002cf8:	7139                	addi	sp,sp,-64
    80002cfa:	fc06                	sd	ra,56(sp)
    80002cfc:	f822                	sd	s0,48(sp)
    80002cfe:	f04a                	sd	s2,32(sp)
    80002d00:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002d02:	fcc40593          	addi	a1,s0,-52
    80002d06:	4501                	li	a0,0
    80002d08:	e6fff0ef          	jal	80002b76 <argint>
  if(n < 0)
    80002d0c:	fcc42783          	lw	a5,-52(s0)
    80002d10:	0607c763          	bltz	a5,80002d7e <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002d14:	00016517          	auipc	a0,0x16
    80002d18:	d8c50513          	addi	a0,a0,-628 # 80018aa0 <tickslock>
    80002d1c:	ee7fd0ef          	jal	80000c02 <acquire>
  ticks0 = ticks;
    80002d20:	00008917          	auipc	s2,0x8
    80002d24:	81892903          	lw	s2,-2024(s2) # 8000a538 <ticks>
  while(ticks - ticks0 < n){
    80002d28:	fcc42783          	lw	a5,-52(s0)
    80002d2c:	cf8d                	beqz	a5,80002d66 <sys_sleep+0x6e>
    80002d2e:	f426                	sd	s1,40(sp)
    80002d30:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002d32:	00016997          	auipc	s3,0x16
    80002d36:	d6e98993          	addi	s3,s3,-658 # 80018aa0 <tickslock>
    80002d3a:	00007497          	auipc	s1,0x7
    80002d3e:	7fe48493          	addi	s1,s1,2046 # 8000a538 <ticks>
    if(killed(myproc())){
    80002d42:	bd1fe0ef          	jal	80001912 <myproc>
    80002d46:	f78ff0ef          	jal	800024be <killed>
    80002d4a:	ed0d                	bnez	a0,80002d84 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002d4c:	85ce                	mv	a1,s3
    80002d4e:	8526                	mv	a0,s1
    80002d50:	bc0ff0ef          	jal	80002110 <sleep>
  while(ticks - ticks0 < n){
    80002d54:	409c                	lw	a5,0(s1)
    80002d56:	412787bb          	subw	a5,a5,s2
    80002d5a:	fcc42703          	lw	a4,-52(s0)
    80002d5e:	fee7e2e3          	bltu	a5,a4,80002d42 <sys_sleep+0x4a>
    80002d62:	74a2                	ld	s1,40(sp)
    80002d64:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002d66:	00016517          	auipc	a0,0x16
    80002d6a:	d3a50513          	addi	a0,a0,-710 # 80018aa0 <tickslock>
    80002d6e:	f2dfd0ef          	jal	80000c9a <release>
  return 0;
    80002d72:	4501                	li	a0,0
}
    80002d74:	70e2                	ld	ra,56(sp)
    80002d76:	7442                	ld	s0,48(sp)
    80002d78:	7902                	ld	s2,32(sp)
    80002d7a:	6121                	addi	sp,sp,64
    80002d7c:	8082                	ret
    n = 0;
    80002d7e:	fc042623          	sw	zero,-52(s0)
    80002d82:	bf49                	j	80002d14 <sys_sleep+0x1c>
      release(&tickslock);
    80002d84:	00016517          	auipc	a0,0x16
    80002d88:	d1c50513          	addi	a0,a0,-740 # 80018aa0 <tickslock>
    80002d8c:	f0ffd0ef          	jal	80000c9a <release>
      return -1;
    80002d90:	557d                	li	a0,-1
    80002d92:	74a2                	ld	s1,40(sp)
    80002d94:	69e2                	ld	s3,24(sp)
    80002d96:	bff9                	j	80002d74 <sys_sleep+0x7c>

0000000080002d98 <sys_kill>:

uint64
sys_kill(void)
{
    80002d98:	1101                	addi	sp,sp,-32
    80002d9a:	ec06                	sd	ra,24(sp)
    80002d9c:	e822                	sd	s0,16(sp)
    80002d9e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002da0:	fec40593          	addi	a1,s0,-20
    80002da4:	4501                	li	a0,0
    80002da6:	dd1ff0ef          	jal	80002b76 <argint>
  return kill(pid);
    80002daa:	fec42503          	lw	a0,-20(s0)
    80002dae:	e86ff0ef          	jal	80002434 <kill>
}
    80002db2:	60e2                	ld	ra,24(sp)
    80002db4:	6442                	ld	s0,16(sp)
    80002db6:	6105                	addi	sp,sp,32
    80002db8:	8082                	ret

0000000080002dba <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002dba:	1101                	addi	sp,sp,-32
    80002dbc:	ec06                	sd	ra,24(sp)
    80002dbe:	e822                	sd	s0,16(sp)
    80002dc0:	e426                	sd	s1,8(sp)
    80002dc2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002dc4:	00016517          	auipc	a0,0x16
    80002dc8:	cdc50513          	addi	a0,a0,-804 # 80018aa0 <tickslock>
    80002dcc:	e37fd0ef          	jal	80000c02 <acquire>
  xticks = ticks;
    80002dd0:	00007497          	auipc	s1,0x7
    80002dd4:	7684a483          	lw	s1,1896(s1) # 8000a538 <ticks>
  release(&tickslock);
    80002dd8:	00016517          	auipc	a0,0x16
    80002ddc:	cc850513          	addi	a0,a0,-824 # 80018aa0 <tickslock>
    80002de0:	ebbfd0ef          	jal	80000c9a <release>
  return xticks;
}
    80002de4:	02049513          	slli	a0,s1,0x20
    80002de8:	9101                	srli	a0,a0,0x20
    80002dea:	60e2                	ld	ra,24(sp)
    80002dec:	6442                	ld	s0,16(sp)
    80002dee:	64a2                	ld	s1,8(sp)
    80002df0:	6105                	addi	sp,sp,32
    80002df2:	8082                	ret

0000000080002df4 <sys_countsyscall>:
uint64 syscall_count = 0;
uint64
sys_countsyscall(void)
{
    80002df4:	1141                	addi	sp,sp,-16
    80002df6:	e422                	sd	s0,8(sp)
    80002df8:	0800                	addi	s0,sp,16
  return syscall_count;
}
    80002dfa:	00007517          	auipc	a0,0x7
    80002dfe:	74653503          	ld	a0,1862(a0) # 8000a540 <syscall_count>
    80002e02:	6422                	ld	s0,8(sp)
    80002e04:	0141                	addi	sp,sp,16
    80002e06:	8082                	ret

0000000080002e08 <sys_getppid>:
uint64
sys_getppid(void)
{
    80002e08:	1141                	addi	sp,sp,-16
    80002e0a:	e406                	sd	ra,8(sp)
    80002e0c:	e022                	sd	s0,0(sp)
    80002e0e:	0800                	addi	s0,sp,16
  return myproc()->parent->pid;
    80002e10:	b03fe0ef          	jal	80001912 <myproc>
    80002e14:	7d1c                	ld	a5,56(a0)
}
    80002e16:	5b88                	lw	a0,48(a5)
    80002e18:	60a2                	ld	ra,8(sp)
    80002e1a:	6402                	ld	s0,0(sp)
    80002e1c:	0141                	addi	sp,sp,16
    80002e1e:	8082                	ret

0000000080002e20 <sys_shutdown>:
uint64
sys_shutdown(void)
{
    80002e20:	1141                	addi	sp,sp,-16
    80002e22:	e406                	sd	ra,8(sp)
    80002e24:	e022                	sd	s0,0(sp)
    80002e26:	0800                	addi	s0,sp,16
  printf("shutting down \n");
    80002e28:	00004517          	auipc	a0,0x4
    80002e2c:	60850513          	addi	a0,a0,1544 # 80007430 <etext+0x430>
    80002e30:	ea0fd0ef          	jal	800004d0 <printf>
  volatile uint32 *shutdown_reg=(uint32 *)0x100000;
  *shutdown_reg=0x5555;
    80002e34:	6795                	lui	a5,0x5
    80002e36:	55578793          	addi	a5,a5,1365 # 5555 <_entry-0x7fffaaab>
    80002e3a:	00100737          	lui	a4,0x100
    80002e3e:	c31c                	sw	a5,0(a4)
  return 0;
}
    80002e40:	4501                	li	a0,0
    80002e42:	60a2                	ld	ra,8(sp)
    80002e44:	6402                	ld	s0,0(sp)
    80002e46:	0141                	addi	sp,sp,16
    80002e48:	8082                	ret

0000000080002e4a <sys_rand>:
// Simple kernel PRNG using LCG
static unsigned int lcg_state = 1;

uint64
sys_rand(void)
{
    80002e4a:	1141                	addi	sp,sp,-16
    80002e4c:	e422                	sd	s0,8(sp)
    80002e4e:	0800                	addi	s0,sp,16
  // Seed only once using ticks (global variable provided by xv6)
  extern uint ticks;
  if (lcg_state == 1)
    80002e50:	00007717          	auipc	a4,0x7
    80002e54:	64872703          	lw	a4,1608(a4) # 8000a498 <lcg_state>
    80002e58:	4785                	li	a5,1
    80002e5a:	02f70763          	beq	a4,a5,80002e88 <sys_rand+0x3e>
    lcg_state = ticks + 1;  // avoid 0 seed

  // LCG formula
  lcg_state = (1103515245 * lcg_state + 12345) & 0x7fffffff;
    80002e5e:	00007717          	auipc	a4,0x7
    80002e62:	63a70713          	addi	a4,a4,1594 # 8000a498 <lcg_state>
    80002e66:	4314                	lw	a3,0(a4)
    80002e68:	41c657b7          	lui	a5,0x41c65
    80002e6c:	e6d7879b          	addiw	a5,a5,-403 # 41c64e6d <_entry-0x3e39b193>
    80002e70:	02d7853b          	mulw	a0,a5,a3
    80002e74:	678d                	lui	a5,0x3
    80002e76:	0397879b          	addiw	a5,a5,57 # 3039 <_entry-0x7fffcfc7>
    80002e7a:	9d3d                	addw	a0,a0,a5
    80002e7c:	1506                	slli	a0,a0,0x21
    80002e7e:	9105                	srli	a0,a0,0x21
    80002e80:	c308                	sw	a0,0(a4)

  return lcg_state;
}
    80002e82:	6422                	ld	s0,8(sp)
    80002e84:	0141                	addi	sp,sp,16
    80002e86:	8082                	ret
    lcg_state = ticks + 1;  // avoid 0 seed
    80002e88:	00007797          	auipc	a5,0x7
    80002e8c:	6b07a783          	lw	a5,1712(a5) # 8000a538 <ticks>
    80002e90:	2785                	addiw	a5,a5,1
    80002e92:	00007717          	auipc	a4,0x7
    80002e96:	60f72323          	sw	a5,1542(a4) # 8000a498 <lcg_state>
    80002e9a:	b7d1                	j	80002e5e <sys_rand+0x14>

0000000080002e9c <sys_getptable>:

uint64
sys_getptable(void)
{
    80002e9c:	1101                	addi	sp,sp,-32
    80002e9e:	ec06                	sd	ra,24(sp)
    80002ea0:	e822                	sd	s0,16(sp)
    80002ea2:	1000                	addi	s0,sp,32
  int nproc;
  uint64 buffer;
  
  argint(0, &nproc);
    80002ea4:	fec40593          	addi	a1,s0,-20
    80002ea8:	4501                	li	a0,0
    80002eaa:	ccdff0ef          	jal	80002b76 <argint>
  argaddr(1, &buffer);
    80002eae:	fe040593          	addi	a1,s0,-32
    80002eb2:	4505                	li	a0,1
    80002eb4:	cdfff0ef          	jal	80002b92 <argaddr>
  
  return getptable(nproc, buffer);
    80002eb8:	fe043583          	ld	a1,-32(s0)
    80002ebc:	fec42503          	lw	a0,-20(s0)
    80002ec0:	a83fe0ef          	jal	80001942 <getptable>
}
    80002ec4:	60e2                	ld	ra,24(sp)
    80002ec6:	6442                	ld	s0,16(sp)
    80002ec8:	6105                	addi	sp,sp,32
    80002eca:	8082                	ret

0000000080002ecc <sys_set_sched>:
// Import the global variable
extern int sched_mode; 

uint64
sys_set_sched(void)
{
    80002ecc:	1101                	addi	sp,sp,-32
    80002ece:	ec06                	sd	ra,24(sp)
    80002ed0:	e822                	sd	s0,16(sp)
    80002ed2:	1000                	addi	s0,sp,32
  int mode;
  // Read the 1st argument passed to the syscall
 argint(0, &mode);
    80002ed4:	fec40593          	addi	a1,s0,-20
    80002ed8:	4501                	li	a0,0
    80002eda:	c9dff0ef          	jal	80002b76 <argint>
  
  // Validations
  if(mode != 0 && mode != 1) // 0=RR, 1=FCFS
    80002ede:	fec42783          	lw	a5,-20(s0)
    80002ee2:	0007869b          	sext.w	a3,a5
    80002ee6:	4705                	li	a4,1
      return -1;
    80002ee8:	557d                	li	a0,-1
  if(mode != 0 && mode != 1) // 0=RR, 1=FCFS
    80002eea:	00d76763          	bltu	a4,a3,80002ef8 <sys_set_sched+0x2c>

  sched_mode = mode; // UPDATE THE GLOBAL VARIABLE
    80002eee:	00007717          	auipc	a4,0x7
    80002ef2:	62f72d23          	sw	a5,1594(a4) # 8000a528 <sched_mode>
  return 0; // Success
    80002ef6:	4501                	li	a0,0
}
    80002ef8:	60e2                	ld	ra,24(sp)
    80002efa:	6442                	ld	s0,16(sp)
    80002efc:	6105                	addi	sp,sp,32
    80002efe:	8082                	ret

0000000080002f00 <sys_wait_sched>:
uint64
sys_wait_sched(void)
{
    80002f00:	7179                	addi	sp,sp,-48
    80002f02:	f406                	sd	ra,40(sp)
    80002f04:	f022                	sd	s0,32(sp)
    80002f06:	1800                	addi	s0,sp,48
  uint64 p_status; // Pointer for status
  uint64 p_tt;     // Pointer for Turnaround Time
  uint64 p_wt;     // Pointer for Waiting Time

  // Retrieve the 3 addresses passed by the user
  if(argaddr(0, &p_status) < 0) return -1;
    80002f08:	fe840593          	addi	a1,s0,-24
    80002f0c:	4501                	li	a0,0
    80002f0e:	c85ff0ef          	jal	80002b92 <argaddr>
    80002f12:	57fd                	li	a5,-1
    80002f14:	02054b63          	bltz	a0,80002f4a <sys_wait_sched+0x4a>
  if(argaddr(1, &p_tt) < 0)     return -1;
    80002f18:	fe040593          	addi	a1,s0,-32
    80002f1c:	4505                	li	a0,1
    80002f1e:	c75ff0ef          	jal	80002b92 <argaddr>
    80002f22:	57fd                	li	a5,-1
    80002f24:	02054363          	bltz	a0,80002f4a <sys_wait_sched+0x4a>
  if(argaddr(2, &p_wt) < 0)     return -1;
    80002f28:	fd840593          	addi	a1,s0,-40
    80002f2c:	4509                	li	a0,2
    80002f2e:	c65ff0ef          	jal	80002b92 <argaddr>
    80002f32:	57fd                	li	a5,-1
    80002f34:	00054b63          	bltz	a0,80002f4a <sys_wait_sched+0x4a>

  return wait_sched(p_status, p_tt, p_wt);
    80002f38:	fd843603          	ld	a2,-40(s0)
    80002f3c:	fe043583          	ld	a1,-32(s0)
    80002f40:	fe843503          	ld	a0,-24(s0)
    80002f44:	a18ff0ef          	jal	8000215c <wait_sched>
    80002f48:	87aa                	mv	a5,a0
}
    80002f4a:	853e                	mv	a0,a5
    80002f4c:	70a2                	ld	ra,40(sp)
    80002f4e:	7402                	ld	s0,32(sp)
    80002f50:	6145                	addi	sp,sp,48
    80002f52:	8082                	ret

0000000080002f54 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002f54:	7179                	addi	sp,sp,-48
    80002f56:	f406                	sd	ra,40(sp)
    80002f58:	f022                	sd	s0,32(sp)
    80002f5a:	ec26                	sd	s1,24(sp)
    80002f5c:	e84a                	sd	s2,16(sp)
    80002f5e:	e44e                	sd	s3,8(sp)
    80002f60:	e052                	sd	s4,0(sp)
    80002f62:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002f64:	00004597          	auipc	a1,0x4
    80002f68:	4dc58593          	addi	a1,a1,1244 # 80007440 <etext+0x440>
    80002f6c:	00016517          	auipc	a0,0x16
    80002f70:	b4c50513          	addi	a0,a0,-1204 # 80018ab8 <bcache>
    80002f74:	c0ffd0ef          	jal	80000b82 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002f78:	0001e797          	auipc	a5,0x1e
    80002f7c:	b4078793          	addi	a5,a5,-1216 # 80020ab8 <bcache+0x8000>
    80002f80:	0001e717          	auipc	a4,0x1e
    80002f84:	da070713          	addi	a4,a4,-608 # 80020d20 <bcache+0x8268>
    80002f88:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002f8c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f90:	00016497          	auipc	s1,0x16
    80002f94:	b4048493          	addi	s1,s1,-1216 # 80018ad0 <bcache+0x18>
    b->next = bcache.head.next;
    80002f98:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002f9a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002f9c:	00004a17          	auipc	s4,0x4
    80002fa0:	4aca0a13          	addi	s4,s4,1196 # 80007448 <etext+0x448>
    b->next = bcache.head.next;
    80002fa4:	2b893783          	ld	a5,696(s2)
    80002fa8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002faa:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002fae:	85d2                	mv	a1,s4
    80002fb0:	01048513          	addi	a0,s1,16
    80002fb4:	248010ef          	jal	800041fc <initsleeplock>
    bcache.head.next->prev = b;
    80002fb8:	2b893783          	ld	a5,696(s2)
    80002fbc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002fbe:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002fc2:	45848493          	addi	s1,s1,1112
    80002fc6:	fd349fe3          	bne	s1,s3,80002fa4 <binit+0x50>
  }
}
    80002fca:	70a2                	ld	ra,40(sp)
    80002fcc:	7402                	ld	s0,32(sp)
    80002fce:	64e2                	ld	s1,24(sp)
    80002fd0:	6942                	ld	s2,16(sp)
    80002fd2:	69a2                	ld	s3,8(sp)
    80002fd4:	6a02                	ld	s4,0(sp)
    80002fd6:	6145                	addi	sp,sp,48
    80002fd8:	8082                	ret

0000000080002fda <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002fda:	7179                	addi	sp,sp,-48
    80002fdc:	f406                	sd	ra,40(sp)
    80002fde:	f022                	sd	s0,32(sp)
    80002fe0:	ec26                	sd	s1,24(sp)
    80002fe2:	e84a                	sd	s2,16(sp)
    80002fe4:	e44e                	sd	s3,8(sp)
    80002fe6:	1800                	addi	s0,sp,48
    80002fe8:	892a                	mv	s2,a0
    80002fea:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002fec:	00016517          	auipc	a0,0x16
    80002ff0:	acc50513          	addi	a0,a0,-1332 # 80018ab8 <bcache>
    80002ff4:	c0ffd0ef          	jal	80000c02 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002ff8:	0001e497          	auipc	s1,0x1e
    80002ffc:	d784b483          	ld	s1,-648(s1) # 80020d70 <bcache+0x82b8>
    80003000:	0001e797          	auipc	a5,0x1e
    80003004:	d2078793          	addi	a5,a5,-736 # 80020d20 <bcache+0x8268>
    80003008:	02f48b63          	beq	s1,a5,8000303e <bread+0x64>
    8000300c:	873e                	mv	a4,a5
    8000300e:	a021                	j	80003016 <bread+0x3c>
    80003010:	68a4                	ld	s1,80(s1)
    80003012:	02e48663          	beq	s1,a4,8000303e <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80003016:	449c                	lw	a5,8(s1)
    80003018:	ff279ce3          	bne	a5,s2,80003010 <bread+0x36>
    8000301c:	44dc                	lw	a5,12(s1)
    8000301e:	ff3799e3          	bne	a5,s3,80003010 <bread+0x36>
      b->refcnt++;
    80003022:	40bc                	lw	a5,64(s1)
    80003024:	2785                	addiw	a5,a5,1
    80003026:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003028:	00016517          	auipc	a0,0x16
    8000302c:	a9050513          	addi	a0,a0,-1392 # 80018ab8 <bcache>
    80003030:	c6bfd0ef          	jal	80000c9a <release>
      acquiresleep(&b->lock);
    80003034:	01048513          	addi	a0,s1,16
    80003038:	1fa010ef          	jal	80004232 <acquiresleep>
      return b;
    8000303c:	a889                	j	8000308e <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000303e:	0001e497          	auipc	s1,0x1e
    80003042:	d2a4b483          	ld	s1,-726(s1) # 80020d68 <bcache+0x82b0>
    80003046:	0001e797          	auipc	a5,0x1e
    8000304a:	cda78793          	addi	a5,a5,-806 # 80020d20 <bcache+0x8268>
    8000304e:	00f48863          	beq	s1,a5,8000305e <bread+0x84>
    80003052:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003054:	40bc                	lw	a5,64(s1)
    80003056:	cb91                	beqz	a5,8000306a <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003058:	64a4                	ld	s1,72(s1)
    8000305a:	fee49de3          	bne	s1,a4,80003054 <bread+0x7a>
  panic("bget: no buffers");
    8000305e:	00004517          	auipc	a0,0x4
    80003062:	3f250513          	addi	a0,a0,1010 # 80007450 <etext+0x450>
    80003066:	f3cfd0ef          	jal	800007a2 <panic>
      b->dev = dev;
    8000306a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000306e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003072:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003076:	4785                	li	a5,1
    80003078:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000307a:	00016517          	auipc	a0,0x16
    8000307e:	a3e50513          	addi	a0,a0,-1474 # 80018ab8 <bcache>
    80003082:	c19fd0ef          	jal	80000c9a <release>
      acquiresleep(&b->lock);
    80003086:	01048513          	addi	a0,s1,16
    8000308a:	1a8010ef          	jal	80004232 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000308e:	409c                	lw	a5,0(s1)
    80003090:	cb89                	beqz	a5,800030a2 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003092:	8526                	mv	a0,s1
    80003094:	70a2                	ld	ra,40(sp)
    80003096:	7402                	ld	s0,32(sp)
    80003098:	64e2                	ld	s1,24(sp)
    8000309a:	6942                	ld	s2,16(sp)
    8000309c:	69a2                	ld	s3,8(sp)
    8000309e:	6145                	addi	sp,sp,48
    800030a0:	8082                	ret
    virtio_disk_rw(b, 0);
    800030a2:	4581                	li	a1,0
    800030a4:	8526                	mv	a0,s1
    800030a6:	1eb020ef          	jal	80005a90 <virtio_disk_rw>
    b->valid = 1;
    800030aa:	4785                	li	a5,1
    800030ac:	c09c                	sw	a5,0(s1)
  return b;
    800030ae:	b7d5                	j	80003092 <bread+0xb8>

00000000800030b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800030b0:	1101                	addi	sp,sp,-32
    800030b2:	ec06                	sd	ra,24(sp)
    800030b4:	e822                	sd	s0,16(sp)
    800030b6:	e426                	sd	s1,8(sp)
    800030b8:	1000                	addi	s0,sp,32
    800030ba:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800030bc:	0541                	addi	a0,a0,16
    800030be:	1f2010ef          	jal	800042b0 <holdingsleep>
    800030c2:	c911                	beqz	a0,800030d6 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800030c4:	4585                	li	a1,1
    800030c6:	8526                	mv	a0,s1
    800030c8:	1c9020ef          	jal	80005a90 <virtio_disk_rw>
}
    800030cc:	60e2                	ld	ra,24(sp)
    800030ce:	6442                	ld	s0,16(sp)
    800030d0:	64a2                	ld	s1,8(sp)
    800030d2:	6105                	addi	sp,sp,32
    800030d4:	8082                	ret
    panic("bwrite");
    800030d6:	00004517          	auipc	a0,0x4
    800030da:	39250513          	addi	a0,a0,914 # 80007468 <etext+0x468>
    800030de:	ec4fd0ef          	jal	800007a2 <panic>

00000000800030e2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800030e2:	1101                	addi	sp,sp,-32
    800030e4:	ec06                	sd	ra,24(sp)
    800030e6:	e822                	sd	s0,16(sp)
    800030e8:	e426                	sd	s1,8(sp)
    800030ea:	e04a                	sd	s2,0(sp)
    800030ec:	1000                	addi	s0,sp,32
    800030ee:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800030f0:	01050913          	addi	s2,a0,16
    800030f4:	854a                	mv	a0,s2
    800030f6:	1ba010ef          	jal	800042b0 <holdingsleep>
    800030fa:	c135                	beqz	a0,8000315e <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    800030fc:	854a                	mv	a0,s2
    800030fe:	17a010ef          	jal	80004278 <releasesleep>

  acquire(&bcache.lock);
    80003102:	00016517          	auipc	a0,0x16
    80003106:	9b650513          	addi	a0,a0,-1610 # 80018ab8 <bcache>
    8000310a:	af9fd0ef          	jal	80000c02 <acquire>
  b->refcnt--;
    8000310e:	40bc                	lw	a5,64(s1)
    80003110:	37fd                	addiw	a5,a5,-1
    80003112:	0007871b          	sext.w	a4,a5
    80003116:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003118:	e71d                	bnez	a4,80003146 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000311a:	68b8                	ld	a4,80(s1)
    8000311c:	64bc                	ld	a5,72(s1)
    8000311e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003120:	68b8                	ld	a4,80(s1)
    80003122:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003124:	0001e797          	auipc	a5,0x1e
    80003128:	99478793          	addi	a5,a5,-1644 # 80020ab8 <bcache+0x8000>
    8000312c:	2b87b703          	ld	a4,696(a5)
    80003130:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003132:	0001e717          	auipc	a4,0x1e
    80003136:	bee70713          	addi	a4,a4,-1042 # 80020d20 <bcache+0x8268>
    8000313a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000313c:	2b87b703          	ld	a4,696(a5)
    80003140:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003142:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003146:	00016517          	auipc	a0,0x16
    8000314a:	97250513          	addi	a0,a0,-1678 # 80018ab8 <bcache>
    8000314e:	b4dfd0ef          	jal	80000c9a <release>
}
    80003152:	60e2                	ld	ra,24(sp)
    80003154:	6442                	ld	s0,16(sp)
    80003156:	64a2                	ld	s1,8(sp)
    80003158:	6902                	ld	s2,0(sp)
    8000315a:	6105                	addi	sp,sp,32
    8000315c:	8082                	ret
    panic("brelse");
    8000315e:	00004517          	auipc	a0,0x4
    80003162:	31250513          	addi	a0,a0,786 # 80007470 <etext+0x470>
    80003166:	e3cfd0ef          	jal	800007a2 <panic>

000000008000316a <bpin>:

void
bpin(struct buf *b) {
    8000316a:	1101                	addi	sp,sp,-32
    8000316c:	ec06                	sd	ra,24(sp)
    8000316e:	e822                	sd	s0,16(sp)
    80003170:	e426                	sd	s1,8(sp)
    80003172:	1000                	addi	s0,sp,32
    80003174:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003176:	00016517          	auipc	a0,0x16
    8000317a:	94250513          	addi	a0,a0,-1726 # 80018ab8 <bcache>
    8000317e:	a85fd0ef          	jal	80000c02 <acquire>
  b->refcnt++;
    80003182:	40bc                	lw	a5,64(s1)
    80003184:	2785                	addiw	a5,a5,1
    80003186:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003188:	00016517          	auipc	a0,0x16
    8000318c:	93050513          	addi	a0,a0,-1744 # 80018ab8 <bcache>
    80003190:	b0bfd0ef          	jal	80000c9a <release>
}
    80003194:	60e2                	ld	ra,24(sp)
    80003196:	6442                	ld	s0,16(sp)
    80003198:	64a2                	ld	s1,8(sp)
    8000319a:	6105                	addi	sp,sp,32
    8000319c:	8082                	ret

000000008000319e <bunpin>:

void
bunpin(struct buf *b) {
    8000319e:	1101                	addi	sp,sp,-32
    800031a0:	ec06                	sd	ra,24(sp)
    800031a2:	e822                	sd	s0,16(sp)
    800031a4:	e426                	sd	s1,8(sp)
    800031a6:	1000                	addi	s0,sp,32
    800031a8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800031aa:	00016517          	auipc	a0,0x16
    800031ae:	90e50513          	addi	a0,a0,-1778 # 80018ab8 <bcache>
    800031b2:	a51fd0ef          	jal	80000c02 <acquire>
  b->refcnt--;
    800031b6:	40bc                	lw	a5,64(s1)
    800031b8:	37fd                	addiw	a5,a5,-1
    800031ba:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800031bc:	00016517          	auipc	a0,0x16
    800031c0:	8fc50513          	addi	a0,a0,-1796 # 80018ab8 <bcache>
    800031c4:	ad7fd0ef          	jal	80000c9a <release>
}
    800031c8:	60e2                	ld	ra,24(sp)
    800031ca:	6442                	ld	s0,16(sp)
    800031cc:	64a2                	ld	s1,8(sp)
    800031ce:	6105                	addi	sp,sp,32
    800031d0:	8082                	ret

00000000800031d2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800031d2:	1101                	addi	sp,sp,-32
    800031d4:	ec06                	sd	ra,24(sp)
    800031d6:	e822                	sd	s0,16(sp)
    800031d8:	e426                	sd	s1,8(sp)
    800031da:	e04a                	sd	s2,0(sp)
    800031dc:	1000                	addi	s0,sp,32
    800031de:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800031e0:	00d5d59b          	srliw	a1,a1,0xd
    800031e4:	0001e797          	auipc	a5,0x1e
    800031e8:	fb07a783          	lw	a5,-80(a5) # 80021194 <sb+0x1c>
    800031ec:	9dbd                	addw	a1,a1,a5
    800031ee:	dedff0ef          	jal	80002fda <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800031f2:	0074f713          	andi	a4,s1,7
    800031f6:	4785                	li	a5,1
    800031f8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800031fc:	14ce                	slli	s1,s1,0x33
    800031fe:	90d9                	srli	s1,s1,0x36
    80003200:	00950733          	add	a4,a0,s1
    80003204:	05874703          	lbu	a4,88(a4)
    80003208:	00e7f6b3          	and	a3,a5,a4
    8000320c:	c29d                	beqz	a3,80003232 <bfree+0x60>
    8000320e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003210:	94aa                	add	s1,s1,a0
    80003212:	fff7c793          	not	a5,a5
    80003216:	8f7d                	and	a4,a4,a5
    80003218:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000321c:	711000ef          	jal	8000412c <log_write>
  brelse(bp);
    80003220:	854a                	mv	a0,s2
    80003222:	ec1ff0ef          	jal	800030e2 <brelse>
}
    80003226:	60e2                	ld	ra,24(sp)
    80003228:	6442                	ld	s0,16(sp)
    8000322a:	64a2                	ld	s1,8(sp)
    8000322c:	6902                	ld	s2,0(sp)
    8000322e:	6105                	addi	sp,sp,32
    80003230:	8082                	ret
    panic("freeing free block");
    80003232:	00004517          	auipc	a0,0x4
    80003236:	24650513          	addi	a0,a0,582 # 80007478 <etext+0x478>
    8000323a:	d68fd0ef          	jal	800007a2 <panic>

000000008000323e <balloc>:
{
    8000323e:	711d                	addi	sp,sp,-96
    80003240:	ec86                	sd	ra,88(sp)
    80003242:	e8a2                	sd	s0,80(sp)
    80003244:	e4a6                	sd	s1,72(sp)
    80003246:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003248:	0001e797          	auipc	a5,0x1e
    8000324c:	f347a783          	lw	a5,-204(a5) # 8002117c <sb+0x4>
    80003250:	0e078f63          	beqz	a5,8000334e <balloc+0x110>
    80003254:	e0ca                	sd	s2,64(sp)
    80003256:	fc4e                	sd	s3,56(sp)
    80003258:	f852                	sd	s4,48(sp)
    8000325a:	f456                	sd	s5,40(sp)
    8000325c:	f05a                	sd	s6,32(sp)
    8000325e:	ec5e                	sd	s7,24(sp)
    80003260:	e862                	sd	s8,16(sp)
    80003262:	e466                	sd	s9,8(sp)
    80003264:	8baa                	mv	s7,a0
    80003266:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003268:	0001eb17          	auipc	s6,0x1e
    8000326c:	f10b0b13          	addi	s6,s6,-240 # 80021178 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003270:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003272:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003274:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003276:	6c89                	lui	s9,0x2
    80003278:	a0b5                	j	800032e4 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000327a:	97ca                	add	a5,a5,s2
    8000327c:	8e55                	or	a2,a2,a3
    8000327e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003282:	854a                	mv	a0,s2
    80003284:	6a9000ef          	jal	8000412c <log_write>
        brelse(bp);
    80003288:	854a                	mv	a0,s2
    8000328a:	e59ff0ef          	jal	800030e2 <brelse>
  bp = bread(dev, bno);
    8000328e:	85a6                	mv	a1,s1
    80003290:	855e                	mv	a0,s7
    80003292:	d49ff0ef          	jal	80002fda <bread>
    80003296:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003298:	40000613          	li	a2,1024
    8000329c:	4581                	li	a1,0
    8000329e:	05850513          	addi	a0,a0,88
    800032a2:	a35fd0ef          	jal	80000cd6 <memset>
  log_write(bp);
    800032a6:	854a                	mv	a0,s2
    800032a8:	685000ef          	jal	8000412c <log_write>
  brelse(bp);
    800032ac:	854a                	mv	a0,s2
    800032ae:	e35ff0ef          	jal	800030e2 <brelse>
}
    800032b2:	6906                	ld	s2,64(sp)
    800032b4:	79e2                	ld	s3,56(sp)
    800032b6:	7a42                	ld	s4,48(sp)
    800032b8:	7aa2                	ld	s5,40(sp)
    800032ba:	7b02                	ld	s6,32(sp)
    800032bc:	6be2                	ld	s7,24(sp)
    800032be:	6c42                	ld	s8,16(sp)
    800032c0:	6ca2                	ld	s9,8(sp)
}
    800032c2:	8526                	mv	a0,s1
    800032c4:	60e6                	ld	ra,88(sp)
    800032c6:	6446                	ld	s0,80(sp)
    800032c8:	64a6                	ld	s1,72(sp)
    800032ca:	6125                	addi	sp,sp,96
    800032cc:	8082                	ret
    brelse(bp);
    800032ce:	854a                	mv	a0,s2
    800032d0:	e13ff0ef          	jal	800030e2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800032d4:	015c87bb          	addw	a5,s9,s5
    800032d8:	00078a9b          	sext.w	s5,a5
    800032dc:	004b2703          	lw	a4,4(s6)
    800032e0:	04eaff63          	bgeu	s5,a4,8000333e <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800032e4:	41fad79b          	sraiw	a5,s5,0x1f
    800032e8:	0137d79b          	srliw	a5,a5,0x13
    800032ec:	015787bb          	addw	a5,a5,s5
    800032f0:	40d7d79b          	sraiw	a5,a5,0xd
    800032f4:	01cb2583          	lw	a1,28(s6)
    800032f8:	9dbd                	addw	a1,a1,a5
    800032fa:	855e                	mv	a0,s7
    800032fc:	cdfff0ef          	jal	80002fda <bread>
    80003300:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003302:	004b2503          	lw	a0,4(s6)
    80003306:	000a849b          	sext.w	s1,s5
    8000330a:	8762                	mv	a4,s8
    8000330c:	fca4f1e3          	bgeu	s1,a0,800032ce <balloc+0x90>
      m = 1 << (bi % 8);
    80003310:	00777693          	andi	a3,a4,7
    80003314:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003318:	41f7579b          	sraiw	a5,a4,0x1f
    8000331c:	01d7d79b          	srliw	a5,a5,0x1d
    80003320:	9fb9                	addw	a5,a5,a4
    80003322:	4037d79b          	sraiw	a5,a5,0x3
    80003326:	00f90633          	add	a2,s2,a5
    8000332a:	05864603          	lbu	a2,88(a2)
    8000332e:	00c6f5b3          	and	a1,a3,a2
    80003332:	d5a1                	beqz	a1,8000327a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003334:	2705                	addiw	a4,a4,1
    80003336:	2485                	addiw	s1,s1,1
    80003338:	fd471ae3          	bne	a4,s4,8000330c <balloc+0xce>
    8000333c:	bf49                	j	800032ce <balloc+0x90>
    8000333e:	6906                	ld	s2,64(sp)
    80003340:	79e2                	ld	s3,56(sp)
    80003342:	7a42                	ld	s4,48(sp)
    80003344:	7aa2                	ld	s5,40(sp)
    80003346:	7b02                	ld	s6,32(sp)
    80003348:	6be2                	ld	s7,24(sp)
    8000334a:	6c42                	ld	s8,16(sp)
    8000334c:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000334e:	00004517          	auipc	a0,0x4
    80003352:	14250513          	addi	a0,a0,322 # 80007490 <etext+0x490>
    80003356:	97afd0ef          	jal	800004d0 <printf>
  return 0;
    8000335a:	4481                	li	s1,0
    8000335c:	b79d                	j	800032c2 <balloc+0x84>

000000008000335e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000335e:	7179                	addi	sp,sp,-48
    80003360:	f406                	sd	ra,40(sp)
    80003362:	f022                	sd	s0,32(sp)
    80003364:	ec26                	sd	s1,24(sp)
    80003366:	e84a                	sd	s2,16(sp)
    80003368:	e44e                	sd	s3,8(sp)
    8000336a:	1800                	addi	s0,sp,48
    8000336c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000336e:	47ad                	li	a5,11
    80003370:	02b7e663          	bltu	a5,a1,8000339c <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80003374:	02059793          	slli	a5,a1,0x20
    80003378:	01e7d593          	srli	a1,a5,0x1e
    8000337c:	00b504b3          	add	s1,a0,a1
    80003380:	0504a903          	lw	s2,80(s1)
    80003384:	06091a63          	bnez	s2,800033f8 <bmap+0x9a>
      addr = balloc(ip->dev);
    80003388:	4108                	lw	a0,0(a0)
    8000338a:	eb5ff0ef          	jal	8000323e <balloc>
    8000338e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003392:	06090363          	beqz	s2,800033f8 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80003396:	0524a823          	sw	s2,80(s1)
    8000339a:	a8b9                	j	800033f8 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000339c:	ff45849b          	addiw	s1,a1,-12
    800033a0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800033a4:	0ff00793          	li	a5,255
    800033a8:	06e7ee63          	bltu	a5,a4,80003424 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800033ac:	08052903          	lw	s2,128(a0)
    800033b0:	00091d63          	bnez	s2,800033ca <bmap+0x6c>
      addr = balloc(ip->dev);
    800033b4:	4108                	lw	a0,0(a0)
    800033b6:	e89ff0ef          	jal	8000323e <balloc>
    800033ba:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800033be:	02090d63          	beqz	s2,800033f8 <bmap+0x9a>
    800033c2:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800033c4:	0929a023          	sw	s2,128(s3)
    800033c8:	a011                	j	800033cc <bmap+0x6e>
    800033ca:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800033cc:	85ca                	mv	a1,s2
    800033ce:	0009a503          	lw	a0,0(s3)
    800033d2:	c09ff0ef          	jal	80002fda <bread>
    800033d6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800033d8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800033dc:	02049713          	slli	a4,s1,0x20
    800033e0:	01e75593          	srli	a1,a4,0x1e
    800033e4:	00b784b3          	add	s1,a5,a1
    800033e8:	0004a903          	lw	s2,0(s1)
    800033ec:	00090e63          	beqz	s2,80003408 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800033f0:	8552                	mv	a0,s4
    800033f2:	cf1ff0ef          	jal	800030e2 <brelse>
    return addr;
    800033f6:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800033f8:	854a                	mv	a0,s2
    800033fa:	70a2                	ld	ra,40(sp)
    800033fc:	7402                	ld	s0,32(sp)
    800033fe:	64e2                	ld	s1,24(sp)
    80003400:	6942                	ld	s2,16(sp)
    80003402:	69a2                	ld	s3,8(sp)
    80003404:	6145                	addi	sp,sp,48
    80003406:	8082                	ret
      addr = balloc(ip->dev);
    80003408:	0009a503          	lw	a0,0(s3)
    8000340c:	e33ff0ef          	jal	8000323e <balloc>
    80003410:	0005091b          	sext.w	s2,a0
      if(addr){
    80003414:	fc090ee3          	beqz	s2,800033f0 <bmap+0x92>
        a[bn] = addr;
    80003418:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000341c:	8552                	mv	a0,s4
    8000341e:	50f000ef          	jal	8000412c <log_write>
    80003422:	b7f9                	j	800033f0 <bmap+0x92>
    80003424:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003426:	00004517          	auipc	a0,0x4
    8000342a:	08250513          	addi	a0,a0,130 # 800074a8 <etext+0x4a8>
    8000342e:	b74fd0ef          	jal	800007a2 <panic>

0000000080003432 <iget>:
{
    80003432:	7179                	addi	sp,sp,-48
    80003434:	f406                	sd	ra,40(sp)
    80003436:	f022                	sd	s0,32(sp)
    80003438:	ec26                	sd	s1,24(sp)
    8000343a:	e84a                	sd	s2,16(sp)
    8000343c:	e44e                	sd	s3,8(sp)
    8000343e:	e052                	sd	s4,0(sp)
    80003440:	1800                	addi	s0,sp,48
    80003442:	89aa                	mv	s3,a0
    80003444:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003446:	0001e517          	auipc	a0,0x1e
    8000344a:	d5250513          	addi	a0,a0,-686 # 80021198 <itable>
    8000344e:	fb4fd0ef          	jal	80000c02 <acquire>
  empty = 0;
    80003452:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003454:	0001e497          	auipc	s1,0x1e
    80003458:	d5c48493          	addi	s1,s1,-676 # 800211b0 <itable+0x18>
    8000345c:	0001f697          	auipc	a3,0x1f
    80003460:	7e468693          	addi	a3,a3,2020 # 80022c40 <log>
    80003464:	a039                	j	80003472 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003466:	02090963          	beqz	s2,80003498 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000346a:	08848493          	addi	s1,s1,136
    8000346e:	02d48863          	beq	s1,a3,8000349e <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003472:	449c                	lw	a5,8(s1)
    80003474:	fef059e3          	blez	a5,80003466 <iget+0x34>
    80003478:	4098                	lw	a4,0(s1)
    8000347a:	ff3716e3          	bne	a4,s3,80003466 <iget+0x34>
    8000347e:	40d8                	lw	a4,4(s1)
    80003480:	ff4713e3          	bne	a4,s4,80003466 <iget+0x34>
      ip->ref++;
    80003484:	2785                	addiw	a5,a5,1
    80003486:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003488:	0001e517          	auipc	a0,0x1e
    8000348c:	d1050513          	addi	a0,a0,-752 # 80021198 <itable>
    80003490:	80bfd0ef          	jal	80000c9a <release>
      return ip;
    80003494:	8926                	mv	s2,s1
    80003496:	a02d                	j	800034c0 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003498:	fbe9                	bnez	a5,8000346a <iget+0x38>
      empty = ip;
    8000349a:	8926                	mv	s2,s1
    8000349c:	b7f9                	j	8000346a <iget+0x38>
  if(empty == 0)
    8000349e:	02090a63          	beqz	s2,800034d2 <iget+0xa0>
  ip->dev = dev;
    800034a2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800034a6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800034aa:	4785                	li	a5,1
    800034ac:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800034b0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800034b4:	0001e517          	auipc	a0,0x1e
    800034b8:	ce450513          	addi	a0,a0,-796 # 80021198 <itable>
    800034bc:	fdefd0ef          	jal	80000c9a <release>
}
    800034c0:	854a                	mv	a0,s2
    800034c2:	70a2                	ld	ra,40(sp)
    800034c4:	7402                	ld	s0,32(sp)
    800034c6:	64e2                	ld	s1,24(sp)
    800034c8:	6942                	ld	s2,16(sp)
    800034ca:	69a2                	ld	s3,8(sp)
    800034cc:	6a02                	ld	s4,0(sp)
    800034ce:	6145                	addi	sp,sp,48
    800034d0:	8082                	ret
    panic("iget: no inodes");
    800034d2:	00004517          	auipc	a0,0x4
    800034d6:	fee50513          	addi	a0,a0,-18 # 800074c0 <etext+0x4c0>
    800034da:	ac8fd0ef          	jal	800007a2 <panic>

00000000800034de <fsinit>:
fsinit(int dev) {
    800034de:	7179                	addi	sp,sp,-48
    800034e0:	f406                	sd	ra,40(sp)
    800034e2:	f022                	sd	s0,32(sp)
    800034e4:	ec26                	sd	s1,24(sp)
    800034e6:	e84a                	sd	s2,16(sp)
    800034e8:	e44e                	sd	s3,8(sp)
    800034ea:	1800                	addi	s0,sp,48
    800034ec:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800034ee:	4585                	li	a1,1
    800034f0:	aebff0ef          	jal	80002fda <bread>
    800034f4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800034f6:	0001e997          	auipc	s3,0x1e
    800034fa:	c8298993          	addi	s3,s3,-894 # 80021178 <sb>
    800034fe:	02000613          	li	a2,32
    80003502:	05850593          	addi	a1,a0,88
    80003506:	854e                	mv	a0,s3
    80003508:	82bfd0ef          	jal	80000d32 <memmove>
  brelse(bp);
    8000350c:	8526                	mv	a0,s1
    8000350e:	bd5ff0ef          	jal	800030e2 <brelse>
  if(sb.magic != FSMAGIC)
    80003512:	0009a703          	lw	a4,0(s3)
    80003516:	102037b7          	lui	a5,0x10203
    8000351a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000351e:	02f71063          	bne	a4,a5,8000353e <fsinit+0x60>
  initlog(dev, &sb);
    80003522:	0001e597          	auipc	a1,0x1e
    80003526:	c5658593          	addi	a1,a1,-938 # 80021178 <sb>
    8000352a:	854a                	mv	a0,s2
    8000352c:	1f9000ef          	jal	80003f24 <initlog>
}
    80003530:	70a2                	ld	ra,40(sp)
    80003532:	7402                	ld	s0,32(sp)
    80003534:	64e2                	ld	s1,24(sp)
    80003536:	6942                	ld	s2,16(sp)
    80003538:	69a2                	ld	s3,8(sp)
    8000353a:	6145                	addi	sp,sp,48
    8000353c:	8082                	ret
    panic("invalid file system");
    8000353e:	00004517          	auipc	a0,0x4
    80003542:	f9250513          	addi	a0,a0,-110 # 800074d0 <etext+0x4d0>
    80003546:	a5cfd0ef          	jal	800007a2 <panic>

000000008000354a <iinit>:
{
    8000354a:	7179                	addi	sp,sp,-48
    8000354c:	f406                	sd	ra,40(sp)
    8000354e:	f022                	sd	s0,32(sp)
    80003550:	ec26                	sd	s1,24(sp)
    80003552:	e84a                	sd	s2,16(sp)
    80003554:	e44e                	sd	s3,8(sp)
    80003556:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003558:	00004597          	auipc	a1,0x4
    8000355c:	f9058593          	addi	a1,a1,-112 # 800074e8 <etext+0x4e8>
    80003560:	0001e517          	auipc	a0,0x1e
    80003564:	c3850513          	addi	a0,a0,-968 # 80021198 <itable>
    80003568:	e1afd0ef          	jal	80000b82 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000356c:	0001e497          	auipc	s1,0x1e
    80003570:	c5448493          	addi	s1,s1,-940 # 800211c0 <itable+0x28>
    80003574:	0001f997          	auipc	s3,0x1f
    80003578:	6dc98993          	addi	s3,s3,1756 # 80022c50 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000357c:	00004917          	auipc	s2,0x4
    80003580:	f7490913          	addi	s2,s2,-140 # 800074f0 <etext+0x4f0>
    80003584:	85ca                	mv	a1,s2
    80003586:	8526                	mv	a0,s1
    80003588:	475000ef          	jal	800041fc <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000358c:	08848493          	addi	s1,s1,136
    80003590:	ff349ae3          	bne	s1,s3,80003584 <iinit+0x3a>
}
    80003594:	70a2                	ld	ra,40(sp)
    80003596:	7402                	ld	s0,32(sp)
    80003598:	64e2                	ld	s1,24(sp)
    8000359a:	6942                	ld	s2,16(sp)
    8000359c:	69a2                	ld	s3,8(sp)
    8000359e:	6145                	addi	sp,sp,48
    800035a0:	8082                	ret

00000000800035a2 <ialloc>:
{
    800035a2:	7139                	addi	sp,sp,-64
    800035a4:	fc06                	sd	ra,56(sp)
    800035a6:	f822                	sd	s0,48(sp)
    800035a8:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800035aa:	0001e717          	auipc	a4,0x1e
    800035ae:	bda72703          	lw	a4,-1062(a4) # 80021184 <sb+0xc>
    800035b2:	4785                	li	a5,1
    800035b4:	06e7f063          	bgeu	a5,a4,80003614 <ialloc+0x72>
    800035b8:	f426                	sd	s1,40(sp)
    800035ba:	f04a                	sd	s2,32(sp)
    800035bc:	ec4e                	sd	s3,24(sp)
    800035be:	e852                	sd	s4,16(sp)
    800035c0:	e456                	sd	s5,8(sp)
    800035c2:	e05a                	sd	s6,0(sp)
    800035c4:	8aaa                	mv	s5,a0
    800035c6:	8b2e                	mv	s6,a1
    800035c8:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800035ca:	0001ea17          	auipc	s4,0x1e
    800035ce:	baea0a13          	addi	s4,s4,-1106 # 80021178 <sb>
    800035d2:	00495593          	srli	a1,s2,0x4
    800035d6:	018a2783          	lw	a5,24(s4)
    800035da:	9dbd                	addw	a1,a1,a5
    800035dc:	8556                	mv	a0,s5
    800035de:	9fdff0ef          	jal	80002fda <bread>
    800035e2:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800035e4:	05850993          	addi	s3,a0,88
    800035e8:	00f97793          	andi	a5,s2,15
    800035ec:	079a                	slli	a5,a5,0x6
    800035ee:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800035f0:	00099783          	lh	a5,0(s3)
    800035f4:	cb9d                	beqz	a5,8000362a <ialloc+0x88>
    brelse(bp);
    800035f6:	aedff0ef          	jal	800030e2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800035fa:	0905                	addi	s2,s2,1
    800035fc:	00ca2703          	lw	a4,12(s4)
    80003600:	0009079b          	sext.w	a5,s2
    80003604:	fce7e7e3          	bltu	a5,a4,800035d2 <ialloc+0x30>
    80003608:	74a2                	ld	s1,40(sp)
    8000360a:	7902                	ld	s2,32(sp)
    8000360c:	69e2                	ld	s3,24(sp)
    8000360e:	6a42                	ld	s4,16(sp)
    80003610:	6aa2                	ld	s5,8(sp)
    80003612:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003614:	00004517          	auipc	a0,0x4
    80003618:	ee450513          	addi	a0,a0,-284 # 800074f8 <etext+0x4f8>
    8000361c:	eb5fc0ef          	jal	800004d0 <printf>
  return 0;
    80003620:	4501                	li	a0,0
}
    80003622:	70e2                	ld	ra,56(sp)
    80003624:	7442                	ld	s0,48(sp)
    80003626:	6121                	addi	sp,sp,64
    80003628:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000362a:	04000613          	li	a2,64
    8000362e:	4581                	li	a1,0
    80003630:	854e                	mv	a0,s3
    80003632:	ea4fd0ef          	jal	80000cd6 <memset>
      dip->type = type;
    80003636:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000363a:	8526                	mv	a0,s1
    8000363c:	2f1000ef          	jal	8000412c <log_write>
      brelse(bp);
    80003640:	8526                	mv	a0,s1
    80003642:	aa1ff0ef          	jal	800030e2 <brelse>
      return iget(dev, inum);
    80003646:	0009059b          	sext.w	a1,s2
    8000364a:	8556                	mv	a0,s5
    8000364c:	de7ff0ef          	jal	80003432 <iget>
    80003650:	74a2                	ld	s1,40(sp)
    80003652:	7902                	ld	s2,32(sp)
    80003654:	69e2                	ld	s3,24(sp)
    80003656:	6a42                	ld	s4,16(sp)
    80003658:	6aa2                	ld	s5,8(sp)
    8000365a:	6b02                	ld	s6,0(sp)
    8000365c:	b7d9                	j	80003622 <ialloc+0x80>

000000008000365e <iupdate>:
{
    8000365e:	1101                	addi	sp,sp,-32
    80003660:	ec06                	sd	ra,24(sp)
    80003662:	e822                	sd	s0,16(sp)
    80003664:	e426                	sd	s1,8(sp)
    80003666:	e04a                	sd	s2,0(sp)
    80003668:	1000                	addi	s0,sp,32
    8000366a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000366c:	415c                	lw	a5,4(a0)
    8000366e:	0047d79b          	srliw	a5,a5,0x4
    80003672:	0001e597          	auipc	a1,0x1e
    80003676:	b1e5a583          	lw	a1,-1250(a1) # 80021190 <sb+0x18>
    8000367a:	9dbd                	addw	a1,a1,a5
    8000367c:	4108                	lw	a0,0(a0)
    8000367e:	95dff0ef          	jal	80002fda <bread>
    80003682:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003684:	05850793          	addi	a5,a0,88
    80003688:	40d8                	lw	a4,4(s1)
    8000368a:	8b3d                	andi	a4,a4,15
    8000368c:	071a                	slli	a4,a4,0x6
    8000368e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003690:	04449703          	lh	a4,68(s1)
    80003694:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003698:	04649703          	lh	a4,70(s1)
    8000369c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800036a0:	04849703          	lh	a4,72(s1)
    800036a4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800036a8:	04a49703          	lh	a4,74(s1)
    800036ac:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800036b0:	44f8                	lw	a4,76(s1)
    800036b2:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800036b4:	03400613          	li	a2,52
    800036b8:	05048593          	addi	a1,s1,80
    800036bc:	00c78513          	addi	a0,a5,12
    800036c0:	e72fd0ef          	jal	80000d32 <memmove>
  log_write(bp);
    800036c4:	854a                	mv	a0,s2
    800036c6:	267000ef          	jal	8000412c <log_write>
  brelse(bp);
    800036ca:	854a                	mv	a0,s2
    800036cc:	a17ff0ef          	jal	800030e2 <brelse>
}
    800036d0:	60e2                	ld	ra,24(sp)
    800036d2:	6442                	ld	s0,16(sp)
    800036d4:	64a2                	ld	s1,8(sp)
    800036d6:	6902                	ld	s2,0(sp)
    800036d8:	6105                	addi	sp,sp,32
    800036da:	8082                	ret

00000000800036dc <idup>:
{
    800036dc:	1101                	addi	sp,sp,-32
    800036de:	ec06                	sd	ra,24(sp)
    800036e0:	e822                	sd	s0,16(sp)
    800036e2:	e426                	sd	s1,8(sp)
    800036e4:	1000                	addi	s0,sp,32
    800036e6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800036e8:	0001e517          	auipc	a0,0x1e
    800036ec:	ab050513          	addi	a0,a0,-1360 # 80021198 <itable>
    800036f0:	d12fd0ef          	jal	80000c02 <acquire>
  ip->ref++;
    800036f4:	449c                	lw	a5,8(s1)
    800036f6:	2785                	addiw	a5,a5,1
    800036f8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800036fa:	0001e517          	auipc	a0,0x1e
    800036fe:	a9e50513          	addi	a0,a0,-1378 # 80021198 <itable>
    80003702:	d98fd0ef          	jal	80000c9a <release>
}
    80003706:	8526                	mv	a0,s1
    80003708:	60e2                	ld	ra,24(sp)
    8000370a:	6442                	ld	s0,16(sp)
    8000370c:	64a2                	ld	s1,8(sp)
    8000370e:	6105                	addi	sp,sp,32
    80003710:	8082                	ret

0000000080003712 <ilock>:
{
    80003712:	1101                	addi	sp,sp,-32
    80003714:	ec06                	sd	ra,24(sp)
    80003716:	e822                	sd	s0,16(sp)
    80003718:	e426                	sd	s1,8(sp)
    8000371a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000371c:	cd19                	beqz	a0,8000373a <ilock+0x28>
    8000371e:	84aa                	mv	s1,a0
    80003720:	451c                	lw	a5,8(a0)
    80003722:	00f05c63          	blez	a5,8000373a <ilock+0x28>
  acquiresleep(&ip->lock);
    80003726:	0541                	addi	a0,a0,16
    80003728:	30b000ef          	jal	80004232 <acquiresleep>
  if(ip->valid == 0){
    8000372c:	40bc                	lw	a5,64(s1)
    8000372e:	cf89                	beqz	a5,80003748 <ilock+0x36>
}
    80003730:	60e2                	ld	ra,24(sp)
    80003732:	6442                	ld	s0,16(sp)
    80003734:	64a2                	ld	s1,8(sp)
    80003736:	6105                	addi	sp,sp,32
    80003738:	8082                	ret
    8000373a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000373c:	00004517          	auipc	a0,0x4
    80003740:	dd450513          	addi	a0,a0,-556 # 80007510 <etext+0x510>
    80003744:	85efd0ef          	jal	800007a2 <panic>
    80003748:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000374a:	40dc                	lw	a5,4(s1)
    8000374c:	0047d79b          	srliw	a5,a5,0x4
    80003750:	0001e597          	auipc	a1,0x1e
    80003754:	a405a583          	lw	a1,-1472(a1) # 80021190 <sb+0x18>
    80003758:	9dbd                	addw	a1,a1,a5
    8000375a:	4088                	lw	a0,0(s1)
    8000375c:	87fff0ef          	jal	80002fda <bread>
    80003760:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003762:	05850593          	addi	a1,a0,88
    80003766:	40dc                	lw	a5,4(s1)
    80003768:	8bbd                	andi	a5,a5,15
    8000376a:	079a                	slli	a5,a5,0x6
    8000376c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000376e:	00059783          	lh	a5,0(a1)
    80003772:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003776:	00259783          	lh	a5,2(a1)
    8000377a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000377e:	00459783          	lh	a5,4(a1)
    80003782:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003786:	00659783          	lh	a5,6(a1)
    8000378a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000378e:	459c                	lw	a5,8(a1)
    80003790:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003792:	03400613          	li	a2,52
    80003796:	05b1                	addi	a1,a1,12
    80003798:	05048513          	addi	a0,s1,80
    8000379c:	d96fd0ef          	jal	80000d32 <memmove>
    brelse(bp);
    800037a0:	854a                	mv	a0,s2
    800037a2:	941ff0ef          	jal	800030e2 <brelse>
    ip->valid = 1;
    800037a6:	4785                	li	a5,1
    800037a8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800037aa:	04449783          	lh	a5,68(s1)
    800037ae:	c399                	beqz	a5,800037b4 <ilock+0xa2>
    800037b0:	6902                	ld	s2,0(sp)
    800037b2:	bfbd                	j	80003730 <ilock+0x1e>
      panic("ilock: no type");
    800037b4:	00004517          	auipc	a0,0x4
    800037b8:	d6450513          	addi	a0,a0,-668 # 80007518 <etext+0x518>
    800037bc:	fe7fc0ef          	jal	800007a2 <panic>

00000000800037c0 <iunlock>:
{
    800037c0:	1101                	addi	sp,sp,-32
    800037c2:	ec06                	sd	ra,24(sp)
    800037c4:	e822                	sd	s0,16(sp)
    800037c6:	e426                	sd	s1,8(sp)
    800037c8:	e04a                	sd	s2,0(sp)
    800037ca:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800037cc:	c505                	beqz	a0,800037f4 <iunlock+0x34>
    800037ce:	84aa                	mv	s1,a0
    800037d0:	01050913          	addi	s2,a0,16
    800037d4:	854a                	mv	a0,s2
    800037d6:	2db000ef          	jal	800042b0 <holdingsleep>
    800037da:	cd09                	beqz	a0,800037f4 <iunlock+0x34>
    800037dc:	449c                	lw	a5,8(s1)
    800037de:	00f05b63          	blez	a5,800037f4 <iunlock+0x34>
  releasesleep(&ip->lock);
    800037e2:	854a                	mv	a0,s2
    800037e4:	295000ef          	jal	80004278 <releasesleep>
}
    800037e8:	60e2                	ld	ra,24(sp)
    800037ea:	6442                	ld	s0,16(sp)
    800037ec:	64a2                	ld	s1,8(sp)
    800037ee:	6902                	ld	s2,0(sp)
    800037f0:	6105                	addi	sp,sp,32
    800037f2:	8082                	ret
    panic("iunlock");
    800037f4:	00004517          	auipc	a0,0x4
    800037f8:	d3450513          	addi	a0,a0,-716 # 80007528 <etext+0x528>
    800037fc:	fa7fc0ef          	jal	800007a2 <panic>

0000000080003800 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003800:	7179                	addi	sp,sp,-48
    80003802:	f406                	sd	ra,40(sp)
    80003804:	f022                	sd	s0,32(sp)
    80003806:	ec26                	sd	s1,24(sp)
    80003808:	e84a                	sd	s2,16(sp)
    8000380a:	e44e                	sd	s3,8(sp)
    8000380c:	1800                	addi	s0,sp,48
    8000380e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003810:	05050493          	addi	s1,a0,80
    80003814:	08050913          	addi	s2,a0,128
    80003818:	a021                	j	80003820 <itrunc+0x20>
    8000381a:	0491                	addi	s1,s1,4
    8000381c:	01248b63          	beq	s1,s2,80003832 <itrunc+0x32>
    if(ip->addrs[i]){
    80003820:	408c                	lw	a1,0(s1)
    80003822:	dde5                	beqz	a1,8000381a <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003824:	0009a503          	lw	a0,0(s3)
    80003828:	9abff0ef          	jal	800031d2 <bfree>
      ip->addrs[i] = 0;
    8000382c:	0004a023          	sw	zero,0(s1)
    80003830:	b7ed                	j	8000381a <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003832:	0809a583          	lw	a1,128(s3)
    80003836:	ed89                	bnez	a1,80003850 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003838:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000383c:	854e                	mv	a0,s3
    8000383e:	e21ff0ef          	jal	8000365e <iupdate>
}
    80003842:	70a2                	ld	ra,40(sp)
    80003844:	7402                	ld	s0,32(sp)
    80003846:	64e2                	ld	s1,24(sp)
    80003848:	6942                	ld	s2,16(sp)
    8000384a:	69a2                	ld	s3,8(sp)
    8000384c:	6145                	addi	sp,sp,48
    8000384e:	8082                	ret
    80003850:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003852:	0009a503          	lw	a0,0(s3)
    80003856:	f84ff0ef          	jal	80002fda <bread>
    8000385a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000385c:	05850493          	addi	s1,a0,88
    80003860:	45850913          	addi	s2,a0,1112
    80003864:	a021                	j	8000386c <itrunc+0x6c>
    80003866:	0491                	addi	s1,s1,4
    80003868:	01248963          	beq	s1,s2,8000387a <itrunc+0x7a>
      if(a[j])
    8000386c:	408c                	lw	a1,0(s1)
    8000386e:	dde5                	beqz	a1,80003866 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003870:	0009a503          	lw	a0,0(s3)
    80003874:	95fff0ef          	jal	800031d2 <bfree>
    80003878:	b7fd                	j	80003866 <itrunc+0x66>
    brelse(bp);
    8000387a:	8552                	mv	a0,s4
    8000387c:	867ff0ef          	jal	800030e2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003880:	0809a583          	lw	a1,128(s3)
    80003884:	0009a503          	lw	a0,0(s3)
    80003888:	94bff0ef          	jal	800031d2 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000388c:	0809a023          	sw	zero,128(s3)
    80003890:	6a02                	ld	s4,0(sp)
    80003892:	b75d                	j	80003838 <itrunc+0x38>

0000000080003894 <iput>:
{
    80003894:	1101                	addi	sp,sp,-32
    80003896:	ec06                	sd	ra,24(sp)
    80003898:	e822                	sd	s0,16(sp)
    8000389a:	e426                	sd	s1,8(sp)
    8000389c:	1000                	addi	s0,sp,32
    8000389e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800038a0:	0001e517          	auipc	a0,0x1e
    800038a4:	8f850513          	addi	a0,a0,-1800 # 80021198 <itable>
    800038a8:	b5afd0ef          	jal	80000c02 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800038ac:	4498                	lw	a4,8(s1)
    800038ae:	4785                	li	a5,1
    800038b0:	02f70063          	beq	a4,a5,800038d0 <iput+0x3c>
  ip->ref--;
    800038b4:	449c                	lw	a5,8(s1)
    800038b6:	37fd                	addiw	a5,a5,-1
    800038b8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800038ba:	0001e517          	auipc	a0,0x1e
    800038be:	8de50513          	addi	a0,a0,-1826 # 80021198 <itable>
    800038c2:	bd8fd0ef          	jal	80000c9a <release>
}
    800038c6:	60e2                	ld	ra,24(sp)
    800038c8:	6442                	ld	s0,16(sp)
    800038ca:	64a2                	ld	s1,8(sp)
    800038cc:	6105                	addi	sp,sp,32
    800038ce:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800038d0:	40bc                	lw	a5,64(s1)
    800038d2:	d3ed                	beqz	a5,800038b4 <iput+0x20>
    800038d4:	04a49783          	lh	a5,74(s1)
    800038d8:	fff1                	bnez	a5,800038b4 <iput+0x20>
    800038da:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800038dc:	01048913          	addi	s2,s1,16
    800038e0:	854a                	mv	a0,s2
    800038e2:	151000ef          	jal	80004232 <acquiresleep>
    release(&itable.lock);
    800038e6:	0001e517          	auipc	a0,0x1e
    800038ea:	8b250513          	addi	a0,a0,-1870 # 80021198 <itable>
    800038ee:	bacfd0ef          	jal	80000c9a <release>
    itrunc(ip);
    800038f2:	8526                	mv	a0,s1
    800038f4:	f0dff0ef          	jal	80003800 <itrunc>
    ip->type = 0;
    800038f8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800038fc:	8526                	mv	a0,s1
    800038fe:	d61ff0ef          	jal	8000365e <iupdate>
    ip->valid = 0;
    80003902:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003906:	854a                	mv	a0,s2
    80003908:	171000ef          	jal	80004278 <releasesleep>
    acquire(&itable.lock);
    8000390c:	0001e517          	auipc	a0,0x1e
    80003910:	88c50513          	addi	a0,a0,-1908 # 80021198 <itable>
    80003914:	aeefd0ef          	jal	80000c02 <acquire>
    80003918:	6902                	ld	s2,0(sp)
    8000391a:	bf69                	j	800038b4 <iput+0x20>

000000008000391c <iunlockput>:
{
    8000391c:	1101                	addi	sp,sp,-32
    8000391e:	ec06                	sd	ra,24(sp)
    80003920:	e822                	sd	s0,16(sp)
    80003922:	e426                	sd	s1,8(sp)
    80003924:	1000                	addi	s0,sp,32
    80003926:	84aa                	mv	s1,a0
  iunlock(ip);
    80003928:	e99ff0ef          	jal	800037c0 <iunlock>
  iput(ip);
    8000392c:	8526                	mv	a0,s1
    8000392e:	f67ff0ef          	jal	80003894 <iput>
}
    80003932:	60e2                	ld	ra,24(sp)
    80003934:	6442                	ld	s0,16(sp)
    80003936:	64a2                	ld	s1,8(sp)
    80003938:	6105                	addi	sp,sp,32
    8000393a:	8082                	ret

000000008000393c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000393c:	1141                	addi	sp,sp,-16
    8000393e:	e422                	sd	s0,8(sp)
    80003940:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003942:	411c                	lw	a5,0(a0)
    80003944:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003946:	415c                	lw	a5,4(a0)
    80003948:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000394a:	04451783          	lh	a5,68(a0)
    8000394e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003952:	04a51783          	lh	a5,74(a0)
    80003956:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000395a:	04c56783          	lwu	a5,76(a0)
    8000395e:	e99c                	sd	a5,16(a1)
}
    80003960:	6422                	ld	s0,8(sp)
    80003962:	0141                	addi	sp,sp,16
    80003964:	8082                	ret

0000000080003966 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003966:	457c                	lw	a5,76(a0)
    80003968:	0ed7eb63          	bltu	a5,a3,80003a5e <readi+0xf8>
{
    8000396c:	7159                	addi	sp,sp,-112
    8000396e:	f486                	sd	ra,104(sp)
    80003970:	f0a2                	sd	s0,96(sp)
    80003972:	eca6                	sd	s1,88(sp)
    80003974:	e0d2                	sd	s4,64(sp)
    80003976:	fc56                	sd	s5,56(sp)
    80003978:	f85a                	sd	s6,48(sp)
    8000397a:	f45e                	sd	s7,40(sp)
    8000397c:	1880                	addi	s0,sp,112
    8000397e:	8b2a                	mv	s6,a0
    80003980:	8bae                	mv	s7,a1
    80003982:	8a32                	mv	s4,a2
    80003984:	84b6                	mv	s1,a3
    80003986:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003988:	9f35                	addw	a4,a4,a3
    return 0;
    8000398a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000398c:	0cd76063          	bltu	a4,a3,80003a4c <readi+0xe6>
    80003990:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003992:	00e7f463          	bgeu	a5,a4,8000399a <readi+0x34>
    n = ip->size - off;
    80003996:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000399a:	080a8f63          	beqz	s5,80003a38 <readi+0xd2>
    8000399e:	e8ca                	sd	s2,80(sp)
    800039a0:	f062                	sd	s8,32(sp)
    800039a2:	ec66                	sd	s9,24(sp)
    800039a4:	e86a                	sd	s10,16(sp)
    800039a6:	e46e                	sd	s11,8(sp)
    800039a8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800039aa:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800039ae:	5c7d                	li	s8,-1
    800039b0:	a80d                	j	800039e2 <readi+0x7c>
    800039b2:	020d1d93          	slli	s11,s10,0x20
    800039b6:	020ddd93          	srli	s11,s11,0x20
    800039ba:	05890613          	addi	a2,s2,88
    800039be:	86ee                	mv	a3,s11
    800039c0:	963a                	add	a2,a2,a4
    800039c2:	85d2                	mv	a1,s4
    800039c4:	855e                	mv	a0,s7
    800039c6:	c1dfe0ef          	jal	800025e2 <either_copyout>
    800039ca:	05850763          	beq	a0,s8,80003a18 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800039ce:	854a                	mv	a0,s2
    800039d0:	f12ff0ef          	jal	800030e2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800039d4:	013d09bb          	addw	s3,s10,s3
    800039d8:	009d04bb          	addw	s1,s10,s1
    800039dc:	9a6e                	add	s4,s4,s11
    800039de:	0559f763          	bgeu	s3,s5,80003a2c <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    800039e2:	00a4d59b          	srliw	a1,s1,0xa
    800039e6:	855a                	mv	a0,s6
    800039e8:	977ff0ef          	jal	8000335e <bmap>
    800039ec:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800039f0:	c5b1                	beqz	a1,80003a3c <readi+0xd6>
    bp = bread(ip->dev, addr);
    800039f2:	000b2503          	lw	a0,0(s6)
    800039f6:	de4ff0ef          	jal	80002fda <bread>
    800039fa:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800039fc:	3ff4f713          	andi	a4,s1,1023
    80003a00:	40ec87bb          	subw	a5,s9,a4
    80003a04:	413a86bb          	subw	a3,s5,s3
    80003a08:	8d3e                	mv	s10,a5
    80003a0a:	2781                	sext.w	a5,a5
    80003a0c:	0006861b          	sext.w	a2,a3
    80003a10:	faf671e3          	bgeu	a2,a5,800039b2 <readi+0x4c>
    80003a14:	8d36                	mv	s10,a3
    80003a16:	bf71                	j	800039b2 <readi+0x4c>
      brelse(bp);
    80003a18:	854a                	mv	a0,s2
    80003a1a:	ec8ff0ef          	jal	800030e2 <brelse>
      tot = -1;
    80003a1e:	59fd                	li	s3,-1
      break;
    80003a20:	6946                	ld	s2,80(sp)
    80003a22:	7c02                	ld	s8,32(sp)
    80003a24:	6ce2                	ld	s9,24(sp)
    80003a26:	6d42                	ld	s10,16(sp)
    80003a28:	6da2                	ld	s11,8(sp)
    80003a2a:	a831                	j	80003a46 <readi+0xe0>
    80003a2c:	6946                	ld	s2,80(sp)
    80003a2e:	7c02                	ld	s8,32(sp)
    80003a30:	6ce2                	ld	s9,24(sp)
    80003a32:	6d42                	ld	s10,16(sp)
    80003a34:	6da2                	ld	s11,8(sp)
    80003a36:	a801                	j	80003a46 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a38:	89d6                	mv	s3,s5
    80003a3a:	a031                	j	80003a46 <readi+0xe0>
    80003a3c:	6946                	ld	s2,80(sp)
    80003a3e:	7c02                	ld	s8,32(sp)
    80003a40:	6ce2                	ld	s9,24(sp)
    80003a42:	6d42                	ld	s10,16(sp)
    80003a44:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003a46:	0009851b          	sext.w	a0,s3
    80003a4a:	69a6                	ld	s3,72(sp)
}
    80003a4c:	70a6                	ld	ra,104(sp)
    80003a4e:	7406                	ld	s0,96(sp)
    80003a50:	64e6                	ld	s1,88(sp)
    80003a52:	6a06                	ld	s4,64(sp)
    80003a54:	7ae2                	ld	s5,56(sp)
    80003a56:	7b42                	ld	s6,48(sp)
    80003a58:	7ba2                	ld	s7,40(sp)
    80003a5a:	6165                	addi	sp,sp,112
    80003a5c:	8082                	ret
    return 0;
    80003a5e:	4501                	li	a0,0
}
    80003a60:	8082                	ret

0000000080003a62 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a62:	457c                	lw	a5,76(a0)
    80003a64:	10d7e063          	bltu	a5,a3,80003b64 <writei+0x102>
{
    80003a68:	7159                	addi	sp,sp,-112
    80003a6a:	f486                	sd	ra,104(sp)
    80003a6c:	f0a2                	sd	s0,96(sp)
    80003a6e:	e8ca                	sd	s2,80(sp)
    80003a70:	e0d2                	sd	s4,64(sp)
    80003a72:	fc56                	sd	s5,56(sp)
    80003a74:	f85a                	sd	s6,48(sp)
    80003a76:	f45e                	sd	s7,40(sp)
    80003a78:	1880                	addi	s0,sp,112
    80003a7a:	8aaa                	mv	s5,a0
    80003a7c:	8bae                	mv	s7,a1
    80003a7e:	8a32                	mv	s4,a2
    80003a80:	8936                	mv	s2,a3
    80003a82:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003a84:	00e687bb          	addw	a5,a3,a4
    80003a88:	0ed7e063          	bltu	a5,a3,80003b68 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003a8c:	00043737          	lui	a4,0x43
    80003a90:	0cf76e63          	bltu	a4,a5,80003b6c <writei+0x10a>
    80003a94:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003a96:	0a0b0f63          	beqz	s6,80003b54 <writei+0xf2>
    80003a9a:	eca6                	sd	s1,88(sp)
    80003a9c:	f062                	sd	s8,32(sp)
    80003a9e:	ec66                	sd	s9,24(sp)
    80003aa0:	e86a                	sd	s10,16(sp)
    80003aa2:	e46e                	sd	s11,8(sp)
    80003aa4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003aa6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003aaa:	5c7d                	li	s8,-1
    80003aac:	a825                	j	80003ae4 <writei+0x82>
    80003aae:	020d1d93          	slli	s11,s10,0x20
    80003ab2:	020ddd93          	srli	s11,s11,0x20
    80003ab6:	05848513          	addi	a0,s1,88
    80003aba:	86ee                	mv	a3,s11
    80003abc:	8652                	mv	a2,s4
    80003abe:	85de                	mv	a1,s7
    80003ac0:	953a                	add	a0,a0,a4
    80003ac2:	b6bfe0ef          	jal	8000262c <either_copyin>
    80003ac6:	05850a63          	beq	a0,s8,80003b1a <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003aca:	8526                	mv	a0,s1
    80003acc:	660000ef          	jal	8000412c <log_write>
    brelse(bp);
    80003ad0:	8526                	mv	a0,s1
    80003ad2:	e10ff0ef          	jal	800030e2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ad6:	013d09bb          	addw	s3,s10,s3
    80003ada:	012d093b          	addw	s2,s10,s2
    80003ade:	9a6e                	add	s4,s4,s11
    80003ae0:	0569f063          	bgeu	s3,s6,80003b20 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003ae4:	00a9559b          	srliw	a1,s2,0xa
    80003ae8:	8556                	mv	a0,s5
    80003aea:	875ff0ef          	jal	8000335e <bmap>
    80003aee:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003af2:	c59d                	beqz	a1,80003b20 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003af4:	000aa503          	lw	a0,0(s5)
    80003af8:	ce2ff0ef          	jal	80002fda <bread>
    80003afc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003afe:	3ff97713          	andi	a4,s2,1023
    80003b02:	40ec87bb          	subw	a5,s9,a4
    80003b06:	413b06bb          	subw	a3,s6,s3
    80003b0a:	8d3e                	mv	s10,a5
    80003b0c:	2781                	sext.w	a5,a5
    80003b0e:	0006861b          	sext.w	a2,a3
    80003b12:	f8f67ee3          	bgeu	a2,a5,80003aae <writei+0x4c>
    80003b16:	8d36                	mv	s10,a3
    80003b18:	bf59                	j	80003aae <writei+0x4c>
      brelse(bp);
    80003b1a:	8526                	mv	a0,s1
    80003b1c:	dc6ff0ef          	jal	800030e2 <brelse>
  }

  if(off > ip->size)
    80003b20:	04caa783          	lw	a5,76(s5)
    80003b24:	0327fa63          	bgeu	a5,s2,80003b58 <writei+0xf6>
    ip->size = off;
    80003b28:	052aa623          	sw	s2,76(s5)
    80003b2c:	64e6                	ld	s1,88(sp)
    80003b2e:	7c02                	ld	s8,32(sp)
    80003b30:	6ce2                	ld	s9,24(sp)
    80003b32:	6d42                	ld	s10,16(sp)
    80003b34:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003b36:	8556                	mv	a0,s5
    80003b38:	b27ff0ef          	jal	8000365e <iupdate>

  return tot;
    80003b3c:	0009851b          	sext.w	a0,s3
    80003b40:	69a6                	ld	s3,72(sp)
}
    80003b42:	70a6                	ld	ra,104(sp)
    80003b44:	7406                	ld	s0,96(sp)
    80003b46:	6946                	ld	s2,80(sp)
    80003b48:	6a06                	ld	s4,64(sp)
    80003b4a:	7ae2                	ld	s5,56(sp)
    80003b4c:	7b42                	ld	s6,48(sp)
    80003b4e:	7ba2                	ld	s7,40(sp)
    80003b50:	6165                	addi	sp,sp,112
    80003b52:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b54:	89da                	mv	s3,s6
    80003b56:	b7c5                	j	80003b36 <writei+0xd4>
    80003b58:	64e6                	ld	s1,88(sp)
    80003b5a:	7c02                	ld	s8,32(sp)
    80003b5c:	6ce2                	ld	s9,24(sp)
    80003b5e:	6d42                	ld	s10,16(sp)
    80003b60:	6da2                	ld	s11,8(sp)
    80003b62:	bfd1                	j	80003b36 <writei+0xd4>
    return -1;
    80003b64:	557d                	li	a0,-1
}
    80003b66:	8082                	ret
    return -1;
    80003b68:	557d                	li	a0,-1
    80003b6a:	bfe1                	j	80003b42 <writei+0xe0>
    return -1;
    80003b6c:	557d                	li	a0,-1
    80003b6e:	bfd1                	j	80003b42 <writei+0xe0>

0000000080003b70 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003b70:	1141                	addi	sp,sp,-16
    80003b72:	e406                	sd	ra,8(sp)
    80003b74:	e022                	sd	s0,0(sp)
    80003b76:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003b78:	4639                	li	a2,14
    80003b7a:	a28fd0ef          	jal	80000da2 <strncmp>
}
    80003b7e:	60a2                	ld	ra,8(sp)
    80003b80:	6402                	ld	s0,0(sp)
    80003b82:	0141                	addi	sp,sp,16
    80003b84:	8082                	ret

0000000080003b86 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003b86:	7139                	addi	sp,sp,-64
    80003b88:	fc06                	sd	ra,56(sp)
    80003b8a:	f822                	sd	s0,48(sp)
    80003b8c:	f426                	sd	s1,40(sp)
    80003b8e:	f04a                	sd	s2,32(sp)
    80003b90:	ec4e                	sd	s3,24(sp)
    80003b92:	e852                	sd	s4,16(sp)
    80003b94:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003b96:	04451703          	lh	a4,68(a0)
    80003b9a:	4785                	li	a5,1
    80003b9c:	00f71a63          	bne	a4,a5,80003bb0 <dirlookup+0x2a>
    80003ba0:	892a                	mv	s2,a0
    80003ba2:	89ae                	mv	s3,a1
    80003ba4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ba6:	457c                	lw	a5,76(a0)
    80003ba8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003baa:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003bac:	e39d                	bnez	a5,80003bd2 <dirlookup+0x4c>
    80003bae:	a095                	j	80003c12 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003bb0:	00004517          	auipc	a0,0x4
    80003bb4:	98050513          	addi	a0,a0,-1664 # 80007530 <etext+0x530>
    80003bb8:	bebfc0ef          	jal	800007a2 <panic>
      panic("dirlookup read");
    80003bbc:	00004517          	auipc	a0,0x4
    80003bc0:	98c50513          	addi	a0,a0,-1652 # 80007548 <etext+0x548>
    80003bc4:	bdffc0ef          	jal	800007a2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003bc8:	24c1                	addiw	s1,s1,16
    80003bca:	04c92783          	lw	a5,76(s2)
    80003bce:	04f4f163          	bgeu	s1,a5,80003c10 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003bd2:	4741                	li	a4,16
    80003bd4:	86a6                	mv	a3,s1
    80003bd6:	fc040613          	addi	a2,s0,-64
    80003bda:	4581                	li	a1,0
    80003bdc:	854a                	mv	a0,s2
    80003bde:	d89ff0ef          	jal	80003966 <readi>
    80003be2:	47c1                	li	a5,16
    80003be4:	fcf51ce3          	bne	a0,a5,80003bbc <dirlookup+0x36>
    if(de.inum == 0)
    80003be8:	fc045783          	lhu	a5,-64(s0)
    80003bec:	dff1                	beqz	a5,80003bc8 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003bee:	fc240593          	addi	a1,s0,-62
    80003bf2:	854e                	mv	a0,s3
    80003bf4:	f7dff0ef          	jal	80003b70 <namecmp>
    80003bf8:	f961                	bnez	a0,80003bc8 <dirlookup+0x42>
      if(poff)
    80003bfa:	000a0463          	beqz	s4,80003c02 <dirlookup+0x7c>
        *poff = off;
    80003bfe:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003c02:	fc045583          	lhu	a1,-64(s0)
    80003c06:	00092503          	lw	a0,0(s2)
    80003c0a:	829ff0ef          	jal	80003432 <iget>
    80003c0e:	a011                	j	80003c12 <dirlookup+0x8c>
  return 0;
    80003c10:	4501                	li	a0,0
}
    80003c12:	70e2                	ld	ra,56(sp)
    80003c14:	7442                	ld	s0,48(sp)
    80003c16:	74a2                	ld	s1,40(sp)
    80003c18:	7902                	ld	s2,32(sp)
    80003c1a:	69e2                	ld	s3,24(sp)
    80003c1c:	6a42                	ld	s4,16(sp)
    80003c1e:	6121                	addi	sp,sp,64
    80003c20:	8082                	ret

0000000080003c22 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003c22:	711d                	addi	sp,sp,-96
    80003c24:	ec86                	sd	ra,88(sp)
    80003c26:	e8a2                	sd	s0,80(sp)
    80003c28:	e4a6                	sd	s1,72(sp)
    80003c2a:	e0ca                	sd	s2,64(sp)
    80003c2c:	fc4e                	sd	s3,56(sp)
    80003c2e:	f852                	sd	s4,48(sp)
    80003c30:	f456                	sd	s5,40(sp)
    80003c32:	f05a                	sd	s6,32(sp)
    80003c34:	ec5e                	sd	s7,24(sp)
    80003c36:	e862                	sd	s8,16(sp)
    80003c38:	e466                	sd	s9,8(sp)
    80003c3a:	1080                	addi	s0,sp,96
    80003c3c:	84aa                	mv	s1,a0
    80003c3e:	8b2e                	mv	s6,a1
    80003c40:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003c42:	00054703          	lbu	a4,0(a0)
    80003c46:	02f00793          	li	a5,47
    80003c4a:	00f70e63          	beq	a4,a5,80003c66 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003c4e:	cc5fd0ef          	jal	80001912 <myproc>
    80003c52:	15053503          	ld	a0,336(a0)
    80003c56:	a87ff0ef          	jal	800036dc <idup>
    80003c5a:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003c5c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003c60:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003c62:	4b85                	li	s7,1
    80003c64:	a871                	j	80003d00 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003c66:	4585                	li	a1,1
    80003c68:	4505                	li	a0,1
    80003c6a:	fc8ff0ef          	jal	80003432 <iget>
    80003c6e:	8a2a                	mv	s4,a0
    80003c70:	b7f5                	j	80003c5c <namex+0x3a>
      iunlockput(ip);
    80003c72:	8552                	mv	a0,s4
    80003c74:	ca9ff0ef          	jal	8000391c <iunlockput>
      return 0;
    80003c78:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003c7a:	8552                	mv	a0,s4
    80003c7c:	60e6                	ld	ra,88(sp)
    80003c7e:	6446                	ld	s0,80(sp)
    80003c80:	64a6                	ld	s1,72(sp)
    80003c82:	6906                	ld	s2,64(sp)
    80003c84:	79e2                	ld	s3,56(sp)
    80003c86:	7a42                	ld	s4,48(sp)
    80003c88:	7aa2                	ld	s5,40(sp)
    80003c8a:	7b02                	ld	s6,32(sp)
    80003c8c:	6be2                	ld	s7,24(sp)
    80003c8e:	6c42                	ld	s8,16(sp)
    80003c90:	6ca2                	ld	s9,8(sp)
    80003c92:	6125                	addi	sp,sp,96
    80003c94:	8082                	ret
      iunlock(ip);
    80003c96:	8552                	mv	a0,s4
    80003c98:	b29ff0ef          	jal	800037c0 <iunlock>
      return ip;
    80003c9c:	bff9                	j	80003c7a <namex+0x58>
      iunlockput(ip);
    80003c9e:	8552                	mv	a0,s4
    80003ca0:	c7dff0ef          	jal	8000391c <iunlockput>
      return 0;
    80003ca4:	8a4e                	mv	s4,s3
    80003ca6:	bfd1                	j	80003c7a <namex+0x58>
  len = path - s;
    80003ca8:	40998633          	sub	a2,s3,s1
    80003cac:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003cb0:	099c5063          	bge	s8,s9,80003d30 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003cb4:	4639                	li	a2,14
    80003cb6:	85a6                	mv	a1,s1
    80003cb8:	8556                	mv	a0,s5
    80003cba:	878fd0ef          	jal	80000d32 <memmove>
    80003cbe:	84ce                	mv	s1,s3
  while(*path == '/')
    80003cc0:	0004c783          	lbu	a5,0(s1)
    80003cc4:	01279763          	bne	a5,s2,80003cd2 <namex+0xb0>
    path++;
    80003cc8:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003cca:	0004c783          	lbu	a5,0(s1)
    80003cce:	ff278de3          	beq	a5,s2,80003cc8 <namex+0xa6>
    ilock(ip);
    80003cd2:	8552                	mv	a0,s4
    80003cd4:	a3fff0ef          	jal	80003712 <ilock>
    if(ip->type != T_DIR){
    80003cd8:	044a1783          	lh	a5,68(s4)
    80003cdc:	f9779be3          	bne	a5,s7,80003c72 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003ce0:	000b0563          	beqz	s6,80003cea <namex+0xc8>
    80003ce4:	0004c783          	lbu	a5,0(s1)
    80003ce8:	d7dd                	beqz	a5,80003c96 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003cea:	4601                	li	a2,0
    80003cec:	85d6                	mv	a1,s5
    80003cee:	8552                	mv	a0,s4
    80003cf0:	e97ff0ef          	jal	80003b86 <dirlookup>
    80003cf4:	89aa                	mv	s3,a0
    80003cf6:	d545                	beqz	a0,80003c9e <namex+0x7c>
    iunlockput(ip);
    80003cf8:	8552                	mv	a0,s4
    80003cfa:	c23ff0ef          	jal	8000391c <iunlockput>
    ip = next;
    80003cfe:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003d00:	0004c783          	lbu	a5,0(s1)
    80003d04:	01279763          	bne	a5,s2,80003d12 <namex+0xf0>
    path++;
    80003d08:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003d0a:	0004c783          	lbu	a5,0(s1)
    80003d0e:	ff278de3          	beq	a5,s2,80003d08 <namex+0xe6>
  if(*path == 0)
    80003d12:	cb8d                	beqz	a5,80003d44 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003d14:	0004c783          	lbu	a5,0(s1)
    80003d18:	89a6                	mv	s3,s1
  len = path - s;
    80003d1a:	4c81                	li	s9,0
    80003d1c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003d1e:	01278963          	beq	a5,s2,80003d30 <namex+0x10e>
    80003d22:	d3d9                	beqz	a5,80003ca8 <namex+0x86>
    path++;
    80003d24:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003d26:	0009c783          	lbu	a5,0(s3)
    80003d2a:	ff279ce3          	bne	a5,s2,80003d22 <namex+0x100>
    80003d2e:	bfad                	j	80003ca8 <namex+0x86>
    memmove(name, s, len);
    80003d30:	2601                	sext.w	a2,a2
    80003d32:	85a6                	mv	a1,s1
    80003d34:	8556                	mv	a0,s5
    80003d36:	ffdfc0ef          	jal	80000d32 <memmove>
    name[len] = 0;
    80003d3a:	9cd6                	add	s9,s9,s5
    80003d3c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003d40:	84ce                	mv	s1,s3
    80003d42:	bfbd                	j	80003cc0 <namex+0x9e>
  if(nameiparent){
    80003d44:	f20b0be3          	beqz	s6,80003c7a <namex+0x58>
    iput(ip);
    80003d48:	8552                	mv	a0,s4
    80003d4a:	b4bff0ef          	jal	80003894 <iput>
    return 0;
    80003d4e:	4a01                	li	s4,0
    80003d50:	b72d                	j	80003c7a <namex+0x58>

0000000080003d52 <dirlink>:
{
    80003d52:	7139                	addi	sp,sp,-64
    80003d54:	fc06                	sd	ra,56(sp)
    80003d56:	f822                	sd	s0,48(sp)
    80003d58:	f04a                	sd	s2,32(sp)
    80003d5a:	ec4e                	sd	s3,24(sp)
    80003d5c:	e852                	sd	s4,16(sp)
    80003d5e:	0080                	addi	s0,sp,64
    80003d60:	892a                	mv	s2,a0
    80003d62:	8a2e                	mv	s4,a1
    80003d64:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003d66:	4601                	li	a2,0
    80003d68:	e1fff0ef          	jal	80003b86 <dirlookup>
    80003d6c:	e535                	bnez	a0,80003dd8 <dirlink+0x86>
    80003d6e:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d70:	04c92483          	lw	s1,76(s2)
    80003d74:	c48d                	beqz	s1,80003d9e <dirlink+0x4c>
    80003d76:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d78:	4741                	li	a4,16
    80003d7a:	86a6                	mv	a3,s1
    80003d7c:	fc040613          	addi	a2,s0,-64
    80003d80:	4581                	li	a1,0
    80003d82:	854a                	mv	a0,s2
    80003d84:	be3ff0ef          	jal	80003966 <readi>
    80003d88:	47c1                	li	a5,16
    80003d8a:	04f51b63          	bne	a0,a5,80003de0 <dirlink+0x8e>
    if(de.inum == 0)
    80003d8e:	fc045783          	lhu	a5,-64(s0)
    80003d92:	c791                	beqz	a5,80003d9e <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d94:	24c1                	addiw	s1,s1,16
    80003d96:	04c92783          	lw	a5,76(s2)
    80003d9a:	fcf4efe3          	bltu	s1,a5,80003d78 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003d9e:	4639                	li	a2,14
    80003da0:	85d2                	mv	a1,s4
    80003da2:	fc240513          	addi	a0,s0,-62
    80003da6:	832fd0ef          	jal	80000dd8 <strncpy>
  de.inum = inum;
    80003daa:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003dae:	4741                	li	a4,16
    80003db0:	86a6                	mv	a3,s1
    80003db2:	fc040613          	addi	a2,s0,-64
    80003db6:	4581                	li	a1,0
    80003db8:	854a                	mv	a0,s2
    80003dba:	ca9ff0ef          	jal	80003a62 <writei>
    80003dbe:	1541                	addi	a0,a0,-16
    80003dc0:	00a03533          	snez	a0,a0
    80003dc4:	40a00533          	neg	a0,a0
    80003dc8:	74a2                	ld	s1,40(sp)
}
    80003dca:	70e2                	ld	ra,56(sp)
    80003dcc:	7442                	ld	s0,48(sp)
    80003dce:	7902                	ld	s2,32(sp)
    80003dd0:	69e2                	ld	s3,24(sp)
    80003dd2:	6a42                	ld	s4,16(sp)
    80003dd4:	6121                	addi	sp,sp,64
    80003dd6:	8082                	ret
    iput(ip);
    80003dd8:	abdff0ef          	jal	80003894 <iput>
    return -1;
    80003ddc:	557d                	li	a0,-1
    80003dde:	b7f5                	j	80003dca <dirlink+0x78>
      panic("dirlink read");
    80003de0:	00003517          	auipc	a0,0x3
    80003de4:	77850513          	addi	a0,a0,1912 # 80007558 <etext+0x558>
    80003de8:	9bbfc0ef          	jal	800007a2 <panic>

0000000080003dec <namei>:

struct inode*
namei(char *path)
{
    80003dec:	1101                	addi	sp,sp,-32
    80003dee:	ec06                	sd	ra,24(sp)
    80003df0:	e822                	sd	s0,16(sp)
    80003df2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003df4:	fe040613          	addi	a2,s0,-32
    80003df8:	4581                	li	a1,0
    80003dfa:	e29ff0ef          	jal	80003c22 <namex>
}
    80003dfe:	60e2                	ld	ra,24(sp)
    80003e00:	6442                	ld	s0,16(sp)
    80003e02:	6105                	addi	sp,sp,32
    80003e04:	8082                	ret

0000000080003e06 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003e06:	1141                	addi	sp,sp,-16
    80003e08:	e406                	sd	ra,8(sp)
    80003e0a:	e022                	sd	s0,0(sp)
    80003e0c:	0800                	addi	s0,sp,16
    80003e0e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003e10:	4585                	li	a1,1
    80003e12:	e11ff0ef          	jal	80003c22 <namex>
}
    80003e16:	60a2                	ld	ra,8(sp)
    80003e18:	6402                	ld	s0,0(sp)
    80003e1a:	0141                	addi	sp,sp,16
    80003e1c:	8082                	ret

0000000080003e1e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003e1e:	1101                	addi	sp,sp,-32
    80003e20:	ec06                	sd	ra,24(sp)
    80003e22:	e822                	sd	s0,16(sp)
    80003e24:	e426                	sd	s1,8(sp)
    80003e26:	e04a                	sd	s2,0(sp)
    80003e28:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003e2a:	0001f917          	auipc	s2,0x1f
    80003e2e:	e1690913          	addi	s2,s2,-490 # 80022c40 <log>
    80003e32:	01892583          	lw	a1,24(s2)
    80003e36:	02892503          	lw	a0,40(s2)
    80003e3a:	9a0ff0ef          	jal	80002fda <bread>
    80003e3e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003e40:	02c92603          	lw	a2,44(s2)
    80003e44:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003e46:	00c05f63          	blez	a2,80003e64 <write_head+0x46>
    80003e4a:	0001f717          	auipc	a4,0x1f
    80003e4e:	e2670713          	addi	a4,a4,-474 # 80022c70 <log+0x30>
    80003e52:	87aa                	mv	a5,a0
    80003e54:	060a                	slli	a2,a2,0x2
    80003e56:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003e58:	4314                	lw	a3,0(a4)
    80003e5a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003e5c:	0711                	addi	a4,a4,4
    80003e5e:	0791                	addi	a5,a5,4
    80003e60:	fec79ce3          	bne	a5,a2,80003e58 <write_head+0x3a>
  }
  bwrite(buf);
    80003e64:	8526                	mv	a0,s1
    80003e66:	a4aff0ef          	jal	800030b0 <bwrite>
  brelse(buf);
    80003e6a:	8526                	mv	a0,s1
    80003e6c:	a76ff0ef          	jal	800030e2 <brelse>
}
    80003e70:	60e2                	ld	ra,24(sp)
    80003e72:	6442                	ld	s0,16(sp)
    80003e74:	64a2                	ld	s1,8(sp)
    80003e76:	6902                	ld	s2,0(sp)
    80003e78:	6105                	addi	sp,sp,32
    80003e7a:	8082                	ret

0000000080003e7c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e7c:	0001f797          	auipc	a5,0x1f
    80003e80:	df07a783          	lw	a5,-528(a5) # 80022c6c <log+0x2c>
    80003e84:	08f05f63          	blez	a5,80003f22 <install_trans+0xa6>
{
    80003e88:	7139                	addi	sp,sp,-64
    80003e8a:	fc06                	sd	ra,56(sp)
    80003e8c:	f822                	sd	s0,48(sp)
    80003e8e:	f426                	sd	s1,40(sp)
    80003e90:	f04a                	sd	s2,32(sp)
    80003e92:	ec4e                	sd	s3,24(sp)
    80003e94:	e852                	sd	s4,16(sp)
    80003e96:	e456                	sd	s5,8(sp)
    80003e98:	e05a                	sd	s6,0(sp)
    80003e9a:	0080                	addi	s0,sp,64
    80003e9c:	8b2a                	mv	s6,a0
    80003e9e:	0001fa97          	auipc	s5,0x1f
    80003ea2:	dd2a8a93          	addi	s5,s5,-558 # 80022c70 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ea6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003ea8:	0001f997          	auipc	s3,0x1f
    80003eac:	d9898993          	addi	s3,s3,-616 # 80022c40 <log>
    80003eb0:	a829                	j	80003eca <install_trans+0x4e>
    brelse(lbuf);
    80003eb2:	854a                	mv	a0,s2
    80003eb4:	a2eff0ef          	jal	800030e2 <brelse>
    brelse(dbuf);
    80003eb8:	8526                	mv	a0,s1
    80003eba:	a28ff0ef          	jal	800030e2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ebe:	2a05                	addiw	s4,s4,1
    80003ec0:	0a91                	addi	s5,s5,4
    80003ec2:	02c9a783          	lw	a5,44(s3)
    80003ec6:	04fa5463          	bge	s4,a5,80003f0e <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003eca:	0189a583          	lw	a1,24(s3)
    80003ece:	014585bb          	addw	a1,a1,s4
    80003ed2:	2585                	addiw	a1,a1,1
    80003ed4:	0289a503          	lw	a0,40(s3)
    80003ed8:	902ff0ef          	jal	80002fda <bread>
    80003edc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003ede:	000aa583          	lw	a1,0(s5)
    80003ee2:	0289a503          	lw	a0,40(s3)
    80003ee6:	8f4ff0ef          	jal	80002fda <bread>
    80003eea:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003eec:	40000613          	li	a2,1024
    80003ef0:	05890593          	addi	a1,s2,88
    80003ef4:	05850513          	addi	a0,a0,88
    80003ef8:	e3bfc0ef          	jal	80000d32 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003efc:	8526                	mv	a0,s1
    80003efe:	9b2ff0ef          	jal	800030b0 <bwrite>
    if(recovering == 0)
    80003f02:	fa0b18e3          	bnez	s6,80003eb2 <install_trans+0x36>
      bunpin(dbuf);
    80003f06:	8526                	mv	a0,s1
    80003f08:	a96ff0ef          	jal	8000319e <bunpin>
    80003f0c:	b75d                	j	80003eb2 <install_trans+0x36>
}
    80003f0e:	70e2                	ld	ra,56(sp)
    80003f10:	7442                	ld	s0,48(sp)
    80003f12:	74a2                	ld	s1,40(sp)
    80003f14:	7902                	ld	s2,32(sp)
    80003f16:	69e2                	ld	s3,24(sp)
    80003f18:	6a42                	ld	s4,16(sp)
    80003f1a:	6aa2                	ld	s5,8(sp)
    80003f1c:	6b02                	ld	s6,0(sp)
    80003f1e:	6121                	addi	sp,sp,64
    80003f20:	8082                	ret
    80003f22:	8082                	ret

0000000080003f24 <initlog>:
{
    80003f24:	7179                	addi	sp,sp,-48
    80003f26:	f406                	sd	ra,40(sp)
    80003f28:	f022                	sd	s0,32(sp)
    80003f2a:	ec26                	sd	s1,24(sp)
    80003f2c:	e84a                	sd	s2,16(sp)
    80003f2e:	e44e                	sd	s3,8(sp)
    80003f30:	1800                	addi	s0,sp,48
    80003f32:	892a                	mv	s2,a0
    80003f34:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003f36:	0001f497          	auipc	s1,0x1f
    80003f3a:	d0a48493          	addi	s1,s1,-758 # 80022c40 <log>
    80003f3e:	00003597          	auipc	a1,0x3
    80003f42:	62a58593          	addi	a1,a1,1578 # 80007568 <etext+0x568>
    80003f46:	8526                	mv	a0,s1
    80003f48:	c3bfc0ef          	jal	80000b82 <initlock>
  log.start = sb->logstart;
    80003f4c:	0149a583          	lw	a1,20(s3)
    80003f50:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003f52:	0109a783          	lw	a5,16(s3)
    80003f56:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003f58:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003f5c:	854a                	mv	a0,s2
    80003f5e:	87cff0ef          	jal	80002fda <bread>
  log.lh.n = lh->n;
    80003f62:	4d30                	lw	a2,88(a0)
    80003f64:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003f66:	00c05f63          	blez	a2,80003f84 <initlog+0x60>
    80003f6a:	87aa                	mv	a5,a0
    80003f6c:	0001f717          	auipc	a4,0x1f
    80003f70:	d0470713          	addi	a4,a4,-764 # 80022c70 <log+0x30>
    80003f74:	060a                	slli	a2,a2,0x2
    80003f76:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003f78:	4ff4                	lw	a3,92(a5)
    80003f7a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003f7c:	0791                	addi	a5,a5,4
    80003f7e:	0711                	addi	a4,a4,4
    80003f80:	fec79ce3          	bne	a5,a2,80003f78 <initlog+0x54>
  brelse(buf);
    80003f84:	95eff0ef          	jal	800030e2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003f88:	4505                	li	a0,1
    80003f8a:	ef3ff0ef          	jal	80003e7c <install_trans>
  log.lh.n = 0;
    80003f8e:	0001f797          	auipc	a5,0x1f
    80003f92:	cc07af23          	sw	zero,-802(a5) # 80022c6c <log+0x2c>
  write_head(); // clear the log
    80003f96:	e89ff0ef          	jal	80003e1e <write_head>
}
    80003f9a:	70a2                	ld	ra,40(sp)
    80003f9c:	7402                	ld	s0,32(sp)
    80003f9e:	64e2                	ld	s1,24(sp)
    80003fa0:	6942                	ld	s2,16(sp)
    80003fa2:	69a2                	ld	s3,8(sp)
    80003fa4:	6145                	addi	sp,sp,48
    80003fa6:	8082                	ret

0000000080003fa8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003fa8:	1101                	addi	sp,sp,-32
    80003faa:	ec06                	sd	ra,24(sp)
    80003fac:	e822                	sd	s0,16(sp)
    80003fae:	e426                	sd	s1,8(sp)
    80003fb0:	e04a                	sd	s2,0(sp)
    80003fb2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003fb4:	0001f517          	auipc	a0,0x1f
    80003fb8:	c8c50513          	addi	a0,a0,-884 # 80022c40 <log>
    80003fbc:	c47fc0ef          	jal	80000c02 <acquire>
  while(1){
    if(log.committing){
    80003fc0:	0001f497          	auipc	s1,0x1f
    80003fc4:	c8048493          	addi	s1,s1,-896 # 80022c40 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003fc8:	4979                	li	s2,30
    80003fca:	a029                	j	80003fd4 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003fcc:	85a6                	mv	a1,s1
    80003fce:	8526                	mv	a0,s1
    80003fd0:	940fe0ef          	jal	80002110 <sleep>
    if(log.committing){
    80003fd4:	50dc                	lw	a5,36(s1)
    80003fd6:	fbfd                	bnez	a5,80003fcc <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003fd8:	5098                	lw	a4,32(s1)
    80003fda:	2705                	addiw	a4,a4,1
    80003fdc:	0027179b          	slliw	a5,a4,0x2
    80003fe0:	9fb9                	addw	a5,a5,a4
    80003fe2:	0017979b          	slliw	a5,a5,0x1
    80003fe6:	54d4                	lw	a3,44(s1)
    80003fe8:	9fb5                	addw	a5,a5,a3
    80003fea:	00f95763          	bge	s2,a5,80003ff8 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003fee:	85a6                	mv	a1,s1
    80003ff0:	8526                	mv	a0,s1
    80003ff2:	91efe0ef          	jal	80002110 <sleep>
    80003ff6:	bff9                	j	80003fd4 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003ff8:	0001f517          	auipc	a0,0x1f
    80003ffc:	c4850513          	addi	a0,a0,-952 # 80022c40 <log>
    80004000:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004002:	c99fc0ef          	jal	80000c9a <release>
      break;
    }
  }
}
    80004006:	60e2                	ld	ra,24(sp)
    80004008:	6442                	ld	s0,16(sp)
    8000400a:	64a2                	ld	s1,8(sp)
    8000400c:	6902                	ld	s2,0(sp)
    8000400e:	6105                	addi	sp,sp,32
    80004010:	8082                	ret

0000000080004012 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004012:	7139                	addi	sp,sp,-64
    80004014:	fc06                	sd	ra,56(sp)
    80004016:	f822                	sd	s0,48(sp)
    80004018:	f426                	sd	s1,40(sp)
    8000401a:	f04a                	sd	s2,32(sp)
    8000401c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000401e:	0001f497          	auipc	s1,0x1f
    80004022:	c2248493          	addi	s1,s1,-990 # 80022c40 <log>
    80004026:	8526                	mv	a0,s1
    80004028:	bdbfc0ef          	jal	80000c02 <acquire>
  log.outstanding -= 1;
    8000402c:	509c                	lw	a5,32(s1)
    8000402e:	37fd                	addiw	a5,a5,-1
    80004030:	0007891b          	sext.w	s2,a5
    80004034:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004036:	50dc                	lw	a5,36(s1)
    80004038:	ef9d                	bnez	a5,80004076 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    8000403a:	04091763          	bnez	s2,80004088 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    8000403e:	0001f497          	auipc	s1,0x1f
    80004042:	c0248493          	addi	s1,s1,-1022 # 80022c40 <log>
    80004046:	4785                	li	a5,1
    80004048:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000404a:	8526                	mv	a0,s1
    8000404c:	c4ffc0ef          	jal	80000c9a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004050:	54dc                	lw	a5,44(s1)
    80004052:	04f04b63          	bgtz	a5,800040a8 <end_op+0x96>
    acquire(&log.lock);
    80004056:	0001f497          	auipc	s1,0x1f
    8000405a:	bea48493          	addi	s1,s1,-1046 # 80022c40 <log>
    8000405e:	8526                	mv	a0,s1
    80004060:	ba3fc0ef          	jal	80000c02 <acquire>
    log.committing = 0;
    80004064:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004068:	8526                	mv	a0,s1
    8000406a:	a52fe0ef          	jal	800022bc <wakeup>
    release(&log.lock);
    8000406e:	8526                	mv	a0,s1
    80004070:	c2bfc0ef          	jal	80000c9a <release>
}
    80004074:	a025                	j	8000409c <end_op+0x8a>
    80004076:	ec4e                	sd	s3,24(sp)
    80004078:	e852                	sd	s4,16(sp)
    8000407a:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000407c:	00003517          	auipc	a0,0x3
    80004080:	4f450513          	addi	a0,a0,1268 # 80007570 <etext+0x570>
    80004084:	f1efc0ef          	jal	800007a2 <panic>
    wakeup(&log);
    80004088:	0001f497          	auipc	s1,0x1f
    8000408c:	bb848493          	addi	s1,s1,-1096 # 80022c40 <log>
    80004090:	8526                	mv	a0,s1
    80004092:	a2afe0ef          	jal	800022bc <wakeup>
  release(&log.lock);
    80004096:	8526                	mv	a0,s1
    80004098:	c03fc0ef          	jal	80000c9a <release>
}
    8000409c:	70e2                	ld	ra,56(sp)
    8000409e:	7442                	ld	s0,48(sp)
    800040a0:	74a2                	ld	s1,40(sp)
    800040a2:	7902                	ld	s2,32(sp)
    800040a4:	6121                	addi	sp,sp,64
    800040a6:	8082                	ret
    800040a8:	ec4e                	sd	s3,24(sp)
    800040aa:	e852                	sd	s4,16(sp)
    800040ac:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800040ae:	0001fa97          	auipc	s5,0x1f
    800040b2:	bc2a8a93          	addi	s5,s5,-1086 # 80022c70 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800040b6:	0001fa17          	auipc	s4,0x1f
    800040ba:	b8aa0a13          	addi	s4,s4,-1142 # 80022c40 <log>
    800040be:	018a2583          	lw	a1,24(s4)
    800040c2:	012585bb          	addw	a1,a1,s2
    800040c6:	2585                	addiw	a1,a1,1
    800040c8:	028a2503          	lw	a0,40(s4)
    800040cc:	f0ffe0ef          	jal	80002fda <bread>
    800040d0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800040d2:	000aa583          	lw	a1,0(s5)
    800040d6:	028a2503          	lw	a0,40(s4)
    800040da:	f01fe0ef          	jal	80002fda <bread>
    800040de:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800040e0:	40000613          	li	a2,1024
    800040e4:	05850593          	addi	a1,a0,88
    800040e8:	05848513          	addi	a0,s1,88
    800040ec:	c47fc0ef          	jal	80000d32 <memmove>
    bwrite(to);  // write the log
    800040f0:	8526                	mv	a0,s1
    800040f2:	fbffe0ef          	jal	800030b0 <bwrite>
    brelse(from);
    800040f6:	854e                	mv	a0,s3
    800040f8:	febfe0ef          	jal	800030e2 <brelse>
    brelse(to);
    800040fc:	8526                	mv	a0,s1
    800040fe:	fe5fe0ef          	jal	800030e2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004102:	2905                	addiw	s2,s2,1
    80004104:	0a91                	addi	s5,s5,4
    80004106:	02ca2783          	lw	a5,44(s4)
    8000410a:	faf94ae3          	blt	s2,a5,800040be <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000410e:	d11ff0ef          	jal	80003e1e <write_head>
    install_trans(0); // Now install writes to home locations
    80004112:	4501                	li	a0,0
    80004114:	d69ff0ef          	jal	80003e7c <install_trans>
    log.lh.n = 0;
    80004118:	0001f797          	auipc	a5,0x1f
    8000411c:	b407aa23          	sw	zero,-1196(a5) # 80022c6c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004120:	cffff0ef          	jal	80003e1e <write_head>
    80004124:	69e2                	ld	s3,24(sp)
    80004126:	6a42                	ld	s4,16(sp)
    80004128:	6aa2                	ld	s5,8(sp)
    8000412a:	b735                	j	80004056 <end_op+0x44>

000000008000412c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000412c:	1101                	addi	sp,sp,-32
    8000412e:	ec06                	sd	ra,24(sp)
    80004130:	e822                	sd	s0,16(sp)
    80004132:	e426                	sd	s1,8(sp)
    80004134:	e04a                	sd	s2,0(sp)
    80004136:	1000                	addi	s0,sp,32
    80004138:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000413a:	0001f917          	auipc	s2,0x1f
    8000413e:	b0690913          	addi	s2,s2,-1274 # 80022c40 <log>
    80004142:	854a                	mv	a0,s2
    80004144:	abffc0ef          	jal	80000c02 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004148:	02c92603          	lw	a2,44(s2)
    8000414c:	47f5                	li	a5,29
    8000414e:	06c7c363          	blt	a5,a2,800041b4 <log_write+0x88>
    80004152:	0001f797          	auipc	a5,0x1f
    80004156:	b0a7a783          	lw	a5,-1270(a5) # 80022c5c <log+0x1c>
    8000415a:	37fd                	addiw	a5,a5,-1
    8000415c:	04f65c63          	bge	a2,a5,800041b4 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004160:	0001f797          	auipc	a5,0x1f
    80004164:	b007a783          	lw	a5,-1280(a5) # 80022c60 <log+0x20>
    80004168:	04f05c63          	blez	a5,800041c0 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000416c:	4781                	li	a5,0
    8000416e:	04c05f63          	blez	a2,800041cc <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004172:	44cc                	lw	a1,12(s1)
    80004174:	0001f717          	auipc	a4,0x1f
    80004178:	afc70713          	addi	a4,a4,-1284 # 80022c70 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000417c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000417e:	4314                	lw	a3,0(a4)
    80004180:	04b68663          	beq	a3,a1,800041cc <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80004184:	2785                	addiw	a5,a5,1
    80004186:	0711                	addi	a4,a4,4
    80004188:	fef61be3          	bne	a2,a5,8000417e <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000418c:	0621                	addi	a2,a2,8
    8000418e:	060a                	slli	a2,a2,0x2
    80004190:	0001f797          	auipc	a5,0x1f
    80004194:	ab078793          	addi	a5,a5,-1360 # 80022c40 <log>
    80004198:	97b2                	add	a5,a5,a2
    8000419a:	44d8                	lw	a4,12(s1)
    8000419c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000419e:	8526                	mv	a0,s1
    800041a0:	fcbfe0ef          	jal	8000316a <bpin>
    log.lh.n++;
    800041a4:	0001f717          	auipc	a4,0x1f
    800041a8:	a9c70713          	addi	a4,a4,-1380 # 80022c40 <log>
    800041ac:	575c                	lw	a5,44(a4)
    800041ae:	2785                	addiw	a5,a5,1
    800041b0:	d75c                	sw	a5,44(a4)
    800041b2:	a80d                	j	800041e4 <log_write+0xb8>
    panic("too big a transaction");
    800041b4:	00003517          	auipc	a0,0x3
    800041b8:	3cc50513          	addi	a0,a0,972 # 80007580 <etext+0x580>
    800041bc:	de6fc0ef          	jal	800007a2 <panic>
    panic("log_write outside of trans");
    800041c0:	00003517          	auipc	a0,0x3
    800041c4:	3d850513          	addi	a0,a0,984 # 80007598 <etext+0x598>
    800041c8:	ddafc0ef          	jal	800007a2 <panic>
  log.lh.block[i] = b->blockno;
    800041cc:	00878693          	addi	a3,a5,8
    800041d0:	068a                	slli	a3,a3,0x2
    800041d2:	0001f717          	auipc	a4,0x1f
    800041d6:	a6e70713          	addi	a4,a4,-1426 # 80022c40 <log>
    800041da:	9736                	add	a4,a4,a3
    800041dc:	44d4                	lw	a3,12(s1)
    800041de:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800041e0:	faf60fe3          	beq	a2,a5,8000419e <log_write+0x72>
  }
  release(&log.lock);
    800041e4:	0001f517          	auipc	a0,0x1f
    800041e8:	a5c50513          	addi	a0,a0,-1444 # 80022c40 <log>
    800041ec:	aaffc0ef          	jal	80000c9a <release>
}
    800041f0:	60e2                	ld	ra,24(sp)
    800041f2:	6442                	ld	s0,16(sp)
    800041f4:	64a2                	ld	s1,8(sp)
    800041f6:	6902                	ld	s2,0(sp)
    800041f8:	6105                	addi	sp,sp,32
    800041fa:	8082                	ret

00000000800041fc <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800041fc:	1101                	addi	sp,sp,-32
    800041fe:	ec06                	sd	ra,24(sp)
    80004200:	e822                	sd	s0,16(sp)
    80004202:	e426                	sd	s1,8(sp)
    80004204:	e04a                	sd	s2,0(sp)
    80004206:	1000                	addi	s0,sp,32
    80004208:	84aa                	mv	s1,a0
    8000420a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000420c:	00003597          	auipc	a1,0x3
    80004210:	3ac58593          	addi	a1,a1,940 # 800075b8 <etext+0x5b8>
    80004214:	0521                	addi	a0,a0,8
    80004216:	96dfc0ef          	jal	80000b82 <initlock>
  lk->name = name;
    8000421a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000421e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004222:	0204a423          	sw	zero,40(s1)
}
    80004226:	60e2                	ld	ra,24(sp)
    80004228:	6442                	ld	s0,16(sp)
    8000422a:	64a2                	ld	s1,8(sp)
    8000422c:	6902                	ld	s2,0(sp)
    8000422e:	6105                	addi	sp,sp,32
    80004230:	8082                	ret

0000000080004232 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004232:	1101                	addi	sp,sp,-32
    80004234:	ec06                	sd	ra,24(sp)
    80004236:	e822                	sd	s0,16(sp)
    80004238:	e426                	sd	s1,8(sp)
    8000423a:	e04a                	sd	s2,0(sp)
    8000423c:	1000                	addi	s0,sp,32
    8000423e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004240:	00850913          	addi	s2,a0,8
    80004244:	854a                	mv	a0,s2
    80004246:	9bdfc0ef          	jal	80000c02 <acquire>
  while (lk->locked) {
    8000424a:	409c                	lw	a5,0(s1)
    8000424c:	c799                	beqz	a5,8000425a <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000424e:	85ca                	mv	a1,s2
    80004250:	8526                	mv	a0,s1
    80004252:	ebffd0ef          	jal	80002110 <sleep>
  while (lk->locked) {
    80004256:	409c                	lw	a5,0(s1)
    80004258:	fbfd                	bnez	a5,8000424e <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000425a:	4785                	li	a5,1
    8000425c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000425e:	eb4fd0ef          	jal	80001912 <myproc>
    80004262:	591c                	lw	a5,48(a0)
    80004264:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004266:	854a                	mv	a0,s2
    80004268:	a33fc0ef          	jal	80000c9a <release>
}
    8000426c:	60e2                	ld	ra,24(sp)
    8000426e:	6442                	ld	s0,16(sp)
    80004270:	64a2                	ld	s1,8(sp)
    80004272:	6902                	ld	s2,0(sp)
    80004274:	6105                	addi	sp,sp,32
    80004276:	8082                	ret

0000000080004278 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004278:	1101                	addi	sp,sp,-32
    8000427a:	ec06                	sd	ra,24(sp)
    8000427c:	e822                	sd	s0,16(sp)
    8000427e:	e426                	sd	s1,8(sp)
    80004280:	e04a                	sd	s2,0(sp)
    80004282:	1000                	addi	s0,sp,32
    80004284:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004286:	00850913          	addi	s2,a0,8
    8000428a:	854a                	mv	a0,s2
    8000428c:	977fc0ef          	jal	80000c02 <acquire>
  lk->locked = 0;
    80004290:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004294:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004298:	8526                	mv	a0,s1
    8000429a:	822fe0ef          	jal	800022bc <wakeup>
  release(&lk->lk);
    8000429e:	854a                	mv	a0,s2
    800042a0:	9fbfc0ef          	jal	80000c9a <release>
}
    800042a4:	60e2                	ld	ra,24(sp)
    800042a6:	6442                	ld	s0,16(sp)
    800042a8:	64a2                	ld	s1,8(sp)
    800042aa:	6902                	ld	s2,0(sp)
    800042ac:	6105                	addi	sp,sp,32
    800042ae:	8082                	ret

00000000800042b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800042b0:	7179                	addi	sp,sp,-48
    800042b2:	f406                	sd	ra,40(sp)
    800042b4:	f022                	sd	s0,32(sp)
    800042b6:	ec26                	sd	s1,24(sp)
    800042b8:	e84a                	sd	s2,16(sp)
    800042ba:	1800                	addi	s0,sp,48
    800042bc:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800042be:	00850913          	addi	s2,a0,8
    800042c2:	854a                	mv	a0,s2
    800042c4:	93ffc0ef          	jal	80000c02 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800042c8:	409c                	lw	a5,0(s1)
    800042ca:	ef81                	bnez	a5,800042e2 <holdingsleep+0x32>
    800042cc:	4481                	li	s1,0
  release(&lk->lk);
    800042ce:	854a                	mv	a0,s2
    800042d0:	9cbfc0ef          	jal	80000c9a <release>
  return r;
}
    800042d4:	8526                	mv	a0,s1
    800042d6:	70a2                	ld	ra,40(sp)
    800042d8:	7402                	ld	s0,32(sp)
    800042da:	64e2                	ld	s1,24(sp)
    800042dc:	6942                	ld	s2,16(sp)
    800042de:	6145                	addi	sp,sp,48
    800042e0:	8082                	ret
    800042e2:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800042e4:	0284a983          	lw	s3,40(s1)
    800042e8:	e2afd0ef          	jal	80001912 <myproc>
    800042ec:	5904                	lw	s1,48(a0)
    800042ee:	413484b3          	sub	s1,s1,s3
    800042f2:	0014b493          	seqz	s1,s1
    800042f6:	69a2                	ld	s3,8(sp)
    800042f8:	bfd9                	j	800042ce <holdingsleep+0x1e>

00000000800042fa <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800042fa:	1141                	addi	sp,sp,-16
    800042fc:	e406                	sd	ra,8(sp)
    800042fe:	e022                	sd	s0,0(sp)
    80004300:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004302:	00003597          	auipc	a1,0x3
    80004306:	2c658593          	addi	a1,a1,710 # 800075c8 <etext+0x5c8>
    8000430a:	0001f517          	auipc	a0,0x1f
    8000430e:	a7e50513          	addi	a0,a0,-1410 # 80022d88 <ftable>
    80004312:	871fc0ef          	jal	80000b82 <initlock>
}
    80004316:	60a2                	ld	ra,8(sp)
    80004318:	6402                	ld	s0,0(sp)
    8000431a:	0141                	addi	sp,sp,16
    8000431c:	8082                	ret

000000008000431e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000431e:	1101                	addi	sp,sp,-32
    80004320:	ec06                	sd	ra,24(sp)
    80004322:	e822                	sd	s0,16(sp)
    80004324:	e426                	sd	s1,8(sp)
    80004326:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004328:	0001f517          	auipc	a0,0x1f
    8000432c:	a6050513          	addi	a0,a0,-1440 # 80022d88 <ftable>
    80004330:	8d3fc0ef          	jal	80000c02 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004334:	0001f497          	auipc	s1,0x1f
    80004338:	a6c48493          	addi	s1,s1,-1428 # 80022da0 <ftable+0x18>
    8000433c:	00020717          	auipc	a4,0x20
    80004340:	a0470713          	addi	a4,a4,-1532 # 80023d40 <disk>
    if(f->ref == 0){
    80004344:	40dc                	lw	a5,4(s1)
    80004346:	cf89                	beqz	a5,80004360 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004348:	02848493          	addi	s1,s1,40
    8000434c:	fee49ce3          	bne	s1,a4,80004344 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004350:	0001f517          	auipc	a0,0x1f
    80004354:	a3850513          	addi	a0,a0,-1480 # 80022d88 <ftable>
    80004358:	943fc0ef          	jal	80000c9a <release>
  return 0;
    8000435c:	4481                	li	s1,0
    8000435e:	a809                	j	80004370 <filealloc+0x52>
      f->ref = 1;
    80004360:	4785                	li	a5,1
    80004362:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004364:	0001f517          	auipc	a0,0x1f
    80004368:	a2450513          	addi	a0,a0,-1500 # 80022d88 <ftable>
    8000436c:	92ffc0ef          	jal	80000c9a <release>
}
    80004370:	8526                	mv	a0,s1
    80004372:	60e2                	ld	ra,24(sp)
    80004374:	6442                	ld	s0,16(sp)
    80004376:	64a2                	ld	s1,8(sp)
    80004378:	6105                	addi	sp,sp,32
    8000437a:	8082                	ret

000000008000437c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000437c:	1101                	addi	sp,sp,-32
    8000437e:	ec06                	sd	ra,24(sp)
    80004380:	e822                	sd	s0,16(sp)
    80004382:	e426                	sd	s1,8(sp)
    80004384:	1000                	addi	s0,sp,32
    80004386:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004388:	0001f517          	auipc	a0,0x1f
    8000438c:	a0050513          	addi	a0,a0,-1536 # 80022d88 <ftable>
    80004390:	873fc0ef          	jal	80000c02 <acquire>
  if(f->ref < 1)
    80004394:	40dc                	lw	a5,4(s1)
    80004396:	02f05063          	blez	a5,800043b6 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000439a:	2785                	addiw	a5,a5,1
    8000439c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000439e:	0001f517          	auipc	a0,0x1f
    800043a2:	9ea50513          	addi	a0,a0,-1558 # 80022d88 <ftable>
    800043a6:	8f5fc0ef          	jal	80000c9a <release>
  return f;
}
    800043aa:	8526                	mv	a0,s1
    800043ac:	60e2                	ld	ra,24(sp)
    800043ae:	6442                	ld	s0,16(sp)
    800043b0:	64a2                	ld	s1,8(sp)
    800043b2:	6105                	addi	sp,sp,32
    800043b4:	8082                	ret
    panic("filedup");
    800043b6:	00003517          	auipc	a0,0x3
    800043ba:	21a50513          	addi	a0,a0,538 # 800075d0 <etext+0x5d0>
    800043be:	be4fc0ef          	jal	800007a2 <panic>

00000000800043c2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800043c2:	7139                	addi	sp,sp,-64
    800043c4:	fc06                	sd	ra,56(sp)
    800043c6:	f822                	sd	s0,48(sp)
    800043c8:	f426                	sd	s1,40(sp)
    800043ca:	0080                	addi	s0,sp,64
    800043cc:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800043ce:	0001f517          	auipc	a0,0x1f
    800043d2:	9ba50513          	addi	a0,a0,-1606 # 80022d88 <ftable>
    800043d6:	82dfc0ef          	jal	80000c02 <acquire>
  if(f->ref < 1)
    800043da:	40dc                	lw	a5,4(s1)
    800043dc:	04f05a63          	blez	a5,80004430 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800043e0:	37fd                	addiw	a5,a5,-1
    800043e2:	0007871b          	sext.w	a4,a5
    800043e6:	c0dc                	sw	a5,4(s1)
    800043e8:	04e04e63          	bgtz	a4,80004444 <fileclose+0x82>
    800043ec:	f04a                	sd	s2,32(sp)
    800043ee:	ec4e                	sd	s3,24(sp)
    800043f0:	e852                	sd	s4,16(sp)
    800043f2:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800043f4:	0004a903          	lw	s2,0(s1)
    800043f8:	0094ca83          	lbu	s5,9(s1)
    800043fc:	0104ba03          	ld	s4,16(s1)
    80004400:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004404:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004408:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000440c:	0001f517          	auipc	a0,0x1f
    80004410:	97c50513          	addi	a0,a0,-1668 # 80022d88 <ftable>
    80004414:	887fc0ef          	jal	80000c9a <release>

  if(ff.type == FD_PIPE){
    80004418:	4785                	li	a5,1
    8000441a:	04f90063          	beq	s2,a5,8000445a <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000441e:	3979                	addiw	s2,s2,-2
    80004420:	4785                	li	a5,1
    80004422:	0527f563          	bgeu	a5,s2,8000446c <fileclose+0xaa>
    80004426:	7902                	ld	s2,32(sp)
    80004428:	69e2                	ld	s3,24(sp)
    8000442a:	6a42                	ld	s4,16(sp)
    8000442c:	6aa2                	ld	s5,8(sp)
    8000442e:	a00d                	j	80004450 <fileclose+0x8e>
    80004430:	f04a                	sd	s2,32(sp)
    80004432:	ec4e                	sd	s3,24(sp)
    80004434:	e852                	sd	s4,16(sp)
    80004436:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004438:	00003517          	auipc	a0,0x3
    8000443c:	1a050513          	addi	a0,a0,416 # 800075d8 <etext+0x5d8>
    80004440:	b62fc0ef          	jal	800007a2 <panic>
    release(&ftable.lock);
    80004444:	0001f517          	auipc	a0,0x1f
    80004448:	94450513          	addi	a0,a0,-1724 # 80022d88 <ftable>
    8000444c:	84ffc0ef          	jal	80000c9a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004450:	70e2                	ld	ra,56(sp)
    80004452:	7442                	ld	s0,48(sp)
    80004454:	74a2                	ld	s1,40(sp)
    80004456:	6121                	addi	sp,sp,64
    80004458:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000445a:	85d6                	mv	a1,s5
    8000445c:	8552                	mv	a0,s4
    8000445e:	336000ef          	jal	80004794 <pipeclose>
    80004462:	7902                	ld	s2,32(sp)
    80004464:	69e2                	ld	s3,24(sp)
    80004466:	6a42                	ld	s4,16(sp)
    80004468:	6aa2                	ld	s5,8(sp)
    8000446a:	b7dd                	j	80004450 <fileclose+0x8e>
    begin_op();
    8000446c:	b3dff0ef          	jal	80003fa8 <begin_op>
    iput(ff.ip);
    80004470:	854e                	mv	a0,s3
    80004472:	c22ff0ef          	jal	80003894 <iput>
    end_op();
    80004476:	b9dff0ef          	jal	80004012 <end_op>
    8000447a:	7902                	ld	s2,32(sp)
    8000447c:	69e2                	ld	s3,24(sp)
    8000447e:	6a42                	ld	s4,16(sp)
    80004480:	6aa2                	ld	s5,8(sp)
    80004482:	b7f9                	j	80004450 <fileclose+0x8e>

0000000080004484 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004484:	715d                	addi	sp,sp,-80
    80004486:	e486                	sd	ra,72(sp)
    80004488:	e0a2                	sd	s0,64(sp)
    8000448a:	fc26                	sd	s1,56(sp)
    8000448c:	f44e                	sd	s3,40(sp)
    8000448e:	0880                	addi	s0,sp,80
    80004490:	84aa                	mv	s1,a0
    80004492:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004494:	c7efd0ef          	jal	80001912 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004498:	409c                	lw	a5,0(s1)
    8000449a:	37f9                	addiw	a5,a5,-2
    8000449c:	4705                	li	a4,1
    8000449e:	04f76063          	bltu	a4,a5,800044de <filestat+0x5a>
    800044a2:	f84a                	sd	s2,48(sp)
    800044a4:	892a                	mv	s2,a0
    ilock(f->ip);
    800044a6:	6c88                	ld	a0,24(s1)
    800044a8:	a6aff0ef          	jal	80003712 <ilock>
    stati(f->ip, &st);
    800044ac:	fb840593          	addi	a1,s0,-72
    800044b0:	6c88                	ld	a0,24(s1)
    800044b2:	c8aff0ef          	jal	8000393c <stati>
    iunlock(f->ip);
    800044b6:	6c88                	ld	a0,24(s1)
    800044b8:	b08ff0ef          	jal	800037c0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800044bc:	46e1                	li	a3,24
    800044be:	fb840613          	addi	a2,s0,-72
    800044c2:	85ce                	mv	a1,s3
    800044c4:	05093503          	ld	a0,80(s2)
    800044c8:	8bcfd0ef          	jal	80001584 <copyout>
    800044cc:	41f5551b          	sraiw	a0,a0,0x1f
    800044d0:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800044d2:	60a6                	ld	ra,72(sp)
    800044d4:	6406                	ld	s0,64(sp)
    800044d6:	74e2                	ld	s1,56(sp)
    800044d8:	79a2                	ld	s3,40(sp)
    800044da:	6161                	addi	sp,sp,80
    800044dc:	8082                	ret
  return -1;
    800044de:	557d                	li	a0,-1
    800044e0:	bfcd                	j	800044d2 <filestat+0x4e>

00000000800044e2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800044e2:	7179                	addi	sp,sp,-48
    800044e4:	f406                	sd	ra,40(sp)
    800044e6:	f022                	sd	s0,32(sp)
    800044e8:	e84a                	sd	s2,16(sp)
    800044ea:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800044ec:	00854783          	lbu	a5,8(a0)
    800044f0:	cfd1                	beqz	a5,8000458c <fileread+0xaa>
    800044f2:	ec26                	sd	s1,24(sp)
    800044f4:	e44e                	sd	s3,8(sp)
    800044f6:	84aa                	mv	s1,a0
    800044f8:	89ae                	mv	s3,a1
    800044fa:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800044fc:	411c                	lw	a5,0(a0)
    800044fe:	4705                	li	a4,1
    80004500:	04e78363          	beq	a5,a4,80004546 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004504:	470d                	li	a4,3
    80004506:	04e78763          	beq	a5,a4,80004554 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000450a:	4709                	li	a4,2
    8000450c:	06e79a63          	bne	a5,a4,80004580 <fileread+0x9e>
    ilock(f->ip);
    80004510:	6d08                	ld	a0,24(a0)
    80004512:	a00ff0ef          	jal	80003712 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004516:	874a                	mv	a4,s2
    80004518:	5094                	lw	a3,32(s1)
    8000451a:	864e                	mv	a2,s3
    8000451c:	4585                	li	a1,1
    8000451e:	6c88                	ld	a0,24(s1)
    80004520:	c46ff0ef          	jal	80003966 <readi>
    80004524:	892a                	mv	s2,a0
    80004526:	00a05563          	blez	a0,80004530 <fileread+0x4e>
      f->off += r;
    8000452a:	509c                	lw	a5,32(s1)
    8000452c:	9fa9                	addw	a5,a5,a0
    8000452e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004530:	6c88                	ld	a0,24(s1)
    80004532:	a8eff0ef          	jal	800037c0 <iunlock>
    80004536:	64e2                	ld	s1,24(sp)
    80004538:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000453a:	854a                	mv	a0,s2
    8000453c:	70a2                	ld	ra,40(sp)
    8000453e:	7402                	ld	s0,32(sp)
    80004540:	6942                	ld	s2,16(sp)
    80004542:	6145                	addi	sp,sp,48
    80004544:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004546:	6908                	ld	a0,16(a0)
    80004548:	388000ef          	jal	800048d0 <piperead>
    8000454c:	892a                	mv	s2,a0
    8000454e:	64e2                	ld	s1,24(sp)
    80004550:	69a2                	ld	s3,8(sp)
    80004552:	b7e5                	j	8000453a <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004554:	02451783          	lh	a5,36(a0)
    80004558:	03079693          	slli	a3,a5,0x30
    8000455c:	92c1                	srli	a3,a3,0x30
    8000455e:	4725                	li	a4,9
    80004560:	02d76863          	bltu	a4,a3,80004590 <fileread+0xae>
    80004564:	0792                	slli	a5,a5,0x4
    80004566:	0001e717          	auipc	a4,0x1e
    8000456a:	78270713          	addi	a4,a4,1922 # 80022ce8 <devsw>
    8000456e:	97ba                	add	a5,a5,a4
    80004570:	639c                	ld	a5,0(a5)
    80004572:	c39d                	beqz	a5,80004598 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004574:	4505                	li	a0,1
    80004576:	9782                	jalr	a5
    80004578:	892a                	mv	s2,a0
    8000457a:	64e2                	ld	s1,24(sp)
    8000457c:	69a2                	ld	s3,8(sp)
    8000457e:	bf75                	j	8000453a <fileread+0x58>
    panic("fileread");
    80004580:	00003517          	auipc	a0,0x3
    80004584:	06850513          	addi	a0,a0,104 # 800075e8 <etext+0x5e8>
    80004588:	a1afc0ef          	jal	800007a2 <panic>
    return -1;
    8000458c:	597d                	li	s2,-1
    8000458e:	b775                	j	8000453a <fileread+0x58>
      return -1;
    80004590:	597d                	li	s2,-1
    80004592:	64e2                	ld	s1,24(sp)
    80004594:	69a2                	ld	s3,8(sp)
    80004596:	b755                	j	8000453a <fileread+0x58>
    80004598:	597d                	li	s2,-1
    8000459a:	64e2                	ld	s1,24(sp)
    8000459c:	69a2                	ld	s3,8(sp)
    8000459e:	bf71                	j	8000453a <fileread+0x58>

00000000800045a0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800045a0:	00954783          	lbu	a5,9(a0)
    800045a4:	10078b63          	beqz	a5,800046ba <filewrite+0x11a>
{
    800045a8:	715d                	addi	sp,sp,-80
    800045aa:	e486                	sd	ra,72(sp)
    800045ac:	e0a2                	sd	s0,64(sp)
    800045ae:	f84a                	sd	s2,48(sp)
    800045b0:	f052                	sd	s4,32(sp)
    800045b2:	e85a                	sd	s6,16(sp)
    800045b4:	0880                	addi	s0,sp,80
    800045b6:	892a                	mv	s2,a0
    800045b8:	8b2e                	mv	s6,a1
    800045ba:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800045bc:	411c                	lw	a5,0(a0)
    800045be:	4705                	li	a4,1
    800045c0:	02e78763          	beq	a5,a4,800045ee <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800045c4:	470d                	li	a4,3
    800045c6:	02e78863          	beq	a5,a4,800045f6 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800045ca:	4709                	li	a4,2
    800045cc:	0ce79c63          	bne	a5,a4,800046a4 <filewrite+0x104>
    800045d0:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800045d2:	0ac05863          	blez	a2,80004682 <filewrite+0xe2>
    800045d6:	fc26                	sd	s1,56(sp)
    800045d8:	ec56                	sd	s5,24(sp)
    800045da:	e45e                	sd	s7,8(sp)
    800045dc:	e062                	sd	s8,0(sp)
    int i = 0;
    800045de:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800045e0:	6b85                	lui	s7,0x1
    800045e2:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800045e6:	6c05                	lui	s8,0x1
    800045e8:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800045ec:	a8b5                	j	80004668 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800045ee:	6908                	ld	a0,16(a0)
    800045f0:	1fc000ef          	jal	800047ec <pipewrite>
    800045f4:	a04d                	j	80004696 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800045f6:	02451783          	lh	a5,36(a0)
    800045fa:	03079693          	slli	a3,a5,0x30
    800045fe:	92c1                	srli	a3,a3,0x30
    80004600:	4725                	li	a4,9
    80004602:	0ad76e63          	bltu	a4,a3,800046be <filewrite+0x11e>
    80004606:	0792                	slli	a5,a5,0x4
    80004608:	0001e717          	auipc	a4,0x1e
    8000460c:	6e070713          	addi	a4,a4,1760 # 80022ce8 <devsw>
    80004610:	97ba                	add	a5,a5,a4
    80004612:	679c                	ld	a5,8(a5)
    80004614:	c7dd                	beqz	a5,800046c2 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80004616:	4505                	li	a0,1
    80004618:	9782                	jalr	a5
    8000461a:	a8b5                	j	80004696 <filewrite+0xf6>
      if(n1 > max)
    8000461c:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004620:	989ff0ef          	jal	80003fa8 <begin_op>
      ilock(f->ip);
    80004624:	01893503          	ld	a0,24(s2)
    80004628:	8eaff0ef          	jal	80003712 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000462c:	8756                	mv	a4,s5
    8000462e:	02092683          	lw	a3,32(s2)
    80004632:	01698633          	add	a2,s3,s6
    80004636:	4585                	li	a1,1
    80004638:	01893503          	ld	a0,24(s2)
    8000463c:	c26ff0ef          	jal	80003a62 <writei>
    80004640:	84aa                	mv	s1,a0
    80004642:	00a05763          	blez	a0,80004650 <filewrite+0xb0>
        f->off += r;
    80004646:	02092783          	lw	a5,32(s2)
    8000464a:	9fa9                	addw	a5,a5,a0
    8000464c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004650:	01893503          	ld	a0,24(s2)
    80004654:	96cff0ef          	jal	800037c0 <iunlock>
      end_op();
    80004658:	9bbff0ef          	jal	80004012 <end_op>

      if(r != n1){
    8000465c:	029a9563          	bne	s5,s1,80004686 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004660:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004664:	0149da63          	bge	s3,s4,80004678 <filewrite+0xd8>
      int n1 = n - i;
    80004668:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000466c:	0004879b          	sext.w	a5,s1
    80004670:	fafbd6e3          	bge	s7,a5,8000461c <filewrite+0x7c>
    80004674:	84e2                	mv	s1,s8
    80004676:	b75d                	j	8000461c <filewrite+0x7c>
    80004678:	74e2                	ld	s1,56(sp)
    8000467a:	6ae2                	ld	s5,24(sp)
    8000467c:	6ba2                	ld	s7,8(sp)
    8000467e:	6c02                	ld	s8,0(sp)
    80004680:	a039                	j	8000468e <filewrite+0xee>
    int i = 0;
    80004682:	4981                	li	s3,0
    80004684:	a029                	j	8000468e <filewrite+0xee>
    80004686:	74e2                	ld	s1,56(sp)
    80004688:	6ae2                	ld	s5,24(sp)
    8000468a:	6ba2                	ld	s7,8(sp)
    8000468c:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000468e:	033a1c63          	bne	s4,s3,800046c6 <filewrite+0x126>
    80004692:	8552                	mv	a0,s4
    80004694:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004696:	60a6                	ld	ra,72(sp)
    80004698:	6406                	ld	s0,64(sp)
    8000469a:	7942                	ld	s2,48(sp)
    8000469c:	7a02                	ld	s4,32(sp)
    8000469e:	6b42                	ld	s6,16(sp)
    800046a0:	6161                	addi	sp,sp,80
    800046a2:	8082                	ret
    800046a4:	fc26                	sd	s1,56(sp)
    800046a6:	f44e                	sd	s3,40(sp)
    800046a8:	ec56                	sd	s5,24(sp)
    800046aa:	e45e                	sd	s7,8(sp)
    800046ac:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800046ae:	00003517          	auipc	a0,0x3
    800046b2:	f4a50513          	addi	a0,a0,-182 # 800075f8 <etext+0x5f8>
    800046b6:	8ecfc0ef          	jal	800007a2 <panic>
    return -1;
    800046ba:	557d                	li	a0,-1
}
    800046bc:	8082                	ret
      return -1;
    800046be:	557d                	li	a0,-1
    800046c0:	bfd9                	j	80004696 <filewrite+0xf6>
    800046c2:	557d                	li	a0,-1
    800046c4:	bfc9                	j	80004696 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800046c6:	557d                	li	a0,-1
    800046c8:	79a2                	ld	s3,40(sp)
    800046ca:	b7f1                	j	80004696 <filewrite+0xf6>

00000000800046cc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800046cc:	7179                	addi	sp,sp,-48
    800046ce:	f406                	sd	ra,40(sp)
    800046d0:	f022                	sd	s0,32(sp)
    800046d2:	ec26                	sd	s1,24(sp)
    800046d4:	e052                	sd	s4,0(sp)
    800046d6:	1800                	addi	s0,sp,48
    800046d8:	84aa                	mv	s1,a0
    800046da:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800046dc:	0005b023          	sd	zero,0(a1)
    800046e0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800046e4:	c3bff0ef          	jal	8000431e <filealloc>
    800046e8:	e088                	sd	a0,0(s1)
    800046ea:	c549                	beqz	a0,80004774 <pipealloc+0xa8>
    800046ec:	c33ff0ef          	jal	8000431e <filealloc>
    800046f0:	00aa3023          	sd	a0,0(s4)
    800046f4:	cd25                	beqz	a0,8000476c <pipealloc+0xa0>
    800046f6:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800046f8:	c3afc0ef          	jal	80000b32 <kalloc>
    800046fc:	892a                	mv	s2,a0
    800046fe:	c12d                	beqz	a0,80004760 <pipealloc+0x94>
    80004700:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004702:	4985                	li	s3,1
    80004704:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004708:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000470c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004710:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004714:	00003597          	auipc	a1,0x3
    80004718:	ef458593          	addi	a1,a1,-268 # 80007608 <etext+0x608>
    8000471c:	c66fc0ef          	jal	80000b82 <initlock>
  (*f0)->type = FD_PIPE;
    80004720:	609c                	ld	a5,0(s1)
    80004722:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004726:	609c                	ld	a5,0(s1)
    80004728:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000472c:	609c                	ld	a5,0(s1)
    8000472e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004732:	609c                	ld	a5,0(s1)
    80004734:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004738:	000a3783          	ld	a5,0(s4)
    8000473c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004740:	000a3783          	ld	a5,0(s4)
    80004744:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004748:	000a3783          	ld	a5,0(s4)
    8000474c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004750:	000a3783          	ld	a5,0(s4)
    80004754:	0127b823          	sd	s2,16(a5)
  return 0;
    80004758:	4501                	li	a0,0
    8000475a:	6942                	ld	s2,16(sp)
    8000475c:	69a2                	ld	s3,8(sp)
    8000475e:	a01d                	j	80004784 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004760:	6088                	ld	a0,0(s1)
    80004762:	c119                	beqz	a0,80004768 <pipealloc+0x9c>
    80004764:	6942                	ld	s2,16(sp)
    80004766:	a029                	j	80004770 <pipealloc+0xa4>
    80004768:	6942                	ld	s2,16(sp)
    8000476a:	a029                	j	80004774 <pipealloc+0xa8>
    8000476c:	6088                	ld	a0,0(s1)
    8000476e:	c10d                	beqz	a0,80004790 <pipealloc+0xc4>
    fileclose(*f0);
    80004770:	c53ff0ef          	jal	800043c2 <fileclose>
  if(*f1)
    80004774:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004778:	557d                	li	a0,-1
  if(*f1)
    8000477a:	c789                	beqz	a5,80004784 <pipealloc+0xb8>
    fileclose(*f1);
    8000477c:	853e                	mv	a0,a5
    8000477e:	c45ff0ef          	jal	800043c2 <fileclose>
  return -1;
    80004782:	557d                	li	a0,-1
}
    80004784:	70a2                	ld	ra,40(sp)
    80004786:	7402                	ld	s0,32(sp)
    80004788:	64e2                	ld	s1,24(sp)
    8000478a:	6a02                	ld	s4,0(sp)
    8000478c:	6145                	addi	sp,sp,48
    8000478e:	8082                	ret
  return -1;
    80004790:	557d                	li	a0,-1
    80004792:	bfcd                	j	80004784 <pipealloc+0xb8>

0000000080004794 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004794:	1101                	addi	sp,sp,-32
    80004796:	ec06                	sd	ra,24(sp)
    80004798:	e822                	sd	s0,16(sp)
    8000479a:	e426                	sd	s1,8(sp)
    8000479c:	e04a                	sd	s2,0(sp)
    8000479e:	1000                	addi	s0,sp,32
    800047a0:	84aa                	mv	s1,a0
    800047a2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800047a4:	c5efc0ef          	jal	80000c02 <acquire>
  if(writable){
    800047a8:	02090763          	beqz	s2,800047d6 <pipeclose+0x42>
    pi->writeopen = 0;
    800047ac:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800047b0:	21848513          	addi	a0,s1,536
    800047b4:	b09fd0ef          	jal	800022bc <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800047b8:	2204b783          	ld	a5,544(s1)
    800047bc:	e785                	bnez	a5,800047e4 <pipeclose+0x50>
    release(&pi->lock);
    800047be:	8526                	mv	a0,s1
    800047c0:	cdafc0ef          	jal	80000c9a <release>
    kfree((char*)pi);
    800047c4:	8526                	mv	a0,s1
    800047c6:	a8afc0ef          	jal	80000a50 <kfree>
  } else
    release(&pi->lock);
}
    800047ca:	60e2                	ld	ra,24(sp)
    800047cc:	6442                	ld	s0,16(sp)
    800047ce:	64a2                	ld	s1,8(sp)
    800047d0:	6902                	ld	s2,0(sp)
    800047d2:	6105                	addi	sp,sp,32
    800047d4:	8082                	ret
    pi->readopen = 0;
    800047d6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800047da:	21c48513          	addi	a0,s1,540
    800047de:	adffd0ef          	jal	800022bc <wakeup>
    800047e2:	bfd9                	j	800047b8 <pipeclose+0x24>
    release(&pi->lock);
    800047e4:	8526                	mv	a0,s1
    800047e6:	cb4fc0ef          	jal	80000c9a <release>
}
    800047ea:	b7c5                	j	800047ca <pipeclose+0x36>

00000000800047ec <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800047ec:	711d                	addi	sp,sp,-96
    800047ee:	ec86                	sd	ra,88(sp)
    800047f0:	e8a2                	sd	s0,80(sp)
    800047f2:	e4a6                	sd	s1,72(sp)
    800047f4:	e0ca                	sd	s2,64(sp)
    800047f6:	fc4e                	sd	s3,56(sp)
    800047f8:	f852                	sd	s4,48(sp)
    800047fa:	f456                	sd	s5,40(sp)
    800047fc:	1080                	addi	s0,sp,96
    800047fe:	84aa                	mv	s1,a0
    80004800:	8aae                	mv	s5,a1
    80004802:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004804:	90efd0ef          	jal	80001912 <myproc>
    80004808:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000480a:	8526                	mv	a0,s1
    8000480c:	bf6fc0ef          	jal	80000c02 <acquire>
  while(i < n){
    80004810:	0b405a63          	blez	s4,800048c4 <pipewrite+0xd8>
    80004814:	f05a                	sd	s6,32(sp)
    80004816:	ec5e                	sd	s7,24(sp)
    80004818:	e862                	sd	s8,16(sp)
  int i = 0;
    8000481a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000481c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000481e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004822:	21c48b93          	addi	s7,s1,540
    80004826:	a81d                	j	8000485c <pipewrite+0x70>
      release(&pi->lock);
    80004828:	8526                	mv	a0,s1
    8000482a:	c70fc0ef          	jal	80000c9a <release>
      return -1;
    8000482e:	597d                	li	s2,-1
    80004830:	7b02                	ld	s6,32(sp)
    80004832:	6be2                	ld	s7,24(sp)
    80004834:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004836:	854a                	mv	a0,s2
    80004838:	60e6                	ld	ra,88(sp)
    8000483a:	6446                	ld	s0,80(sp)
    8000483c:	64a6                	ld	s1,72(sp)
    8000483e:	6906                	ld	s2,64(sp)
    80004840:	79e2                	ld	s3,56(sp)
    80004842:	7a42                	ld	s4,48(sp)
    80004844:	7aa2                	ld	s5,40(sp)
    80004846:	6125                	addi	sp,sp,96
    80004848:	8082                	ret
      wakeup(&pi->nread);
    8000484a:	8562                	mv	a0,s8
    8000484c:	a71fd0ef          	jal	800022bc <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004850:	85a6                	mv	a1,s1
    80004852:	855e                	mv	a0,s7
    80004854:	8bdfd0ef          	jal	80002110 <sleep>
  while(i < n){
    80004858:	05495b63          	bge	s2,s4,800048ae <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    8000485c:	2204a783          	lw	a5,544(s1)
    80004860:	d7e1                	beqz	a5,80004828 <pipewrite+0x3c>
    80004862:	854e                	mv	a0,s3
    80004864:	c5bfd0ef          	jal	800024be <killed>
    80004868:	f161                	bnez	a0,80004828 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000486a:	2184a783          	lw	a5,536(s1)
    8000486e:	21c4a703          	lw	a4,540(s1)
    80004872:	2007879b          	addiw	a5,a5,512
    80004876:	fcf70ae3          	beq	a4,a5,8000484a <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000487a:	4685                	li	a3,1
    8000487c:	01590633          	add	a2,s2,s5
    80004880:	faf40593          	addi	a1,s0,-81
    80004884:	0509b503          	ld	a0,80(s3)
    80004888:	dd3fc0ef          	jal	8000165a <copyin>
    8000488c:	03650e63          	beq	a0,s6,800048c8 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004890:	21c4a783          	lw	a5,540(s1)
    80004894:	0017871b          	addiw	a4,a5,1
    80004898:	20e4ae23          	sw	a4,540(s1)
    8000489c:	1ff7f793          	andi	a5,a5,511
    800048a0:	97a6                	add	a5,a5,s1
    800048a2:	faf44703          	lbu	a4,-81(s0)
    800048a6:	00e78c23          	sb	a4,24(a5)
      i++;
    800048aa:	2905                	addiw	s2,s2,1
    800048ac:	b775                	j	80004858 <pipewrite+0x6c>
    800048ae:	7b02                	ld	s6,32(sp)
    800048b0:	6be2                	ld	s7,24(sp)
    800048b2:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800048b4:	21848513          	addi	a0,s1,536
    800048b8:	a05fd0ef          	jal	800022bc <wakeup>
  release(&pi->lock);
    800048bc:	8526                	mv	a0,s1
    800048be:	bdcfc0ef          	jal	80000c9a <release>
  return i;
    800048c2:	bf95                	j	80004836 <pipewrite+0x4a>
  int i = 0;
    800048c4:	4901                	li	s2,0
    800048c6:	b7fd                	j	800048b4 <pipewrite+0xc8>
    800048c8:	7b02                	ld	s6,32(sp)
    800048ca:	6be2                	ld	s7,24(sp)
    800048cc:	6c42                	ld	s8,16(sp)
    800048ce:	b7dd                	j	800048b4 <pipewrite+0xc8>

00000000800048d0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800048d0:	715d                	addi	sp,sp,-80
    800048d2:	e486                	sd	ra,72(sp)
    800048d4:	e0a2                	sd	s0,64(sp)
    800048d6:	fc26                	sd	s1,56(sp)
    800048d8:	f84a                	sd	s2,48(sp)
    800048da:	f44e                	sd	s3,40(sp)
    800048dc:	f052                	sd	s4,32(sp)
    800048de:	ec56                	sd	s5,24(sp)
    800048e0:	0880                	addi	s0,sp,80
    800048e2:	84aa                	mv	s1,a0
    800048e4:	892e                	mv	s2,a1
    800048e6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800048e8:	82afd0ef          	jal	80001912 <myproc>
    800048ec:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800048ee:	8526                	mv	a0,s1
    800048f0:	b12fc0ef          	jal	80000c02 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800048f4:	2184a703          	lw	a4,536(s1)
    800048f8:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800048fc:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004900:	02f71563          	bne	a4,a5,8000492a <piperead+0x5a>
    80004904:	2244a783          	lw	a5,548(s1)
    80004908:	cb85                	beqz	a5,80004938 <piperead+0x68>
    if(killed(pr)){
    8000490a:	8552                	mv	a0,s4
    8000490c:	bb3fd0ef          	jal	800024be <killed>
    80004910:	ed19                	bnez	a0,8000492e <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004912:	85a6                	mv	a1,s1
    80004914:	854e                	mv	a0,s3
    80004916:	ffafd0ef          	jal	80002110 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000491a:	2184a703          	lw	a4,536(s1)
    8000491e:	21c4a783          	lw	a5,540(s1)
    80004922:	fef701e3          	beq	a4,a5,80004904 <piperead+0x34>
    80004926:	e85a                	sd	s6,16(sp)
    80004928:	a809                	j	8000493a <piperead+0x6a>
    8000492a:	e85a                	sd	s6,16(sp)
    8000492c:	a039                	j	8000493a <piperead+0x6a>
      release(&pi->lock);
    8000492e:	8526                	mv	a0,s1
    80004930:	b6afc0ef          	jal	80000c9a <release>
      return -1;
    80004934:	59fd                	li	s3,-1
    80004936:	a8b1                	j	80004992 <piperead+0xc2>
    80004938:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000493a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000493c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000493e:	05505263          	blez	s5,80004982 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004942:	2184a783          	lw	a5,536(s1)
    80004946:	21c4a703          	lw	a4,540(s1)
    8000494a:	02f70c63          	beq	a4,a5,80004982 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000494e:	0017871b          	addiw	a4,a5,1
    80004952:	20e4ac23          	sw	a4,536(s1)
    80004956:	1ff7f793          	andi	a5,a5,511
    8000495a:	97a6                	add	a5,a5,s1
    8000495c:	0187c783          	lbu	a5,24(a5)
    80004960:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004964:	4685                	li	a3,1
    80004966:	fbf40613          	addi	a2,s0,-65
    8000496a:	85ca                	mv	a1,s2
    8000496c:	050a3503          	ld	a0,80(s4)
    80004970:	c15fc0ef          	jal	80001584 <copyout>
    80004974:	01650763          	beq	a0,s6,80004982 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004978:	2985                	addiw	s3,s3,1
    8000497a:	0905                	addi	s2,s2,1
    8000497c:	fd3a93e3          	bne	s5,s3,80004942 <piperead+0x72>
    80004980:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004982:	21c48513          	addi	a0,s1,540
    80004986:	937fd0ef          	jal	800022bc <wakeup>
  release(&pi->lock);
    8000498a:	8526                	mv	a0,s1
    8000498c:	b0efc0ef          	jal	80000c9a <release>
    80004990:	6b42                	ld	s6,16(sp)
  return i;
}
    80004992:	854e                	mv	a0,s3
    80004994:	60a6                	ld	ra,72(sp)
    80004996:	6406                	ld	s0,64(sp)
    80004998:	74e2                	ld	s1,56(sp)
    8000499a:	7942                	ld	s2,48(sp)
    8000499c:	79a2                	ld	s3,40(sp)
    8000499e:	7a02                	ld	s4,32(sp)
    800049a0:	6ae2                	ld	s5,24(sp)
    800049a2:	6161                	addi	sp,sp,80
    800049a4:	8082                	ret

00000000800049a6 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800049a6:	1141                	addi	sp,sp,-16
    800049a8:	e422                	sd	s0,8(sp)
    800049aa:	0800                	addi	s0,sp,16
    800049ac:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800049ae:	8905                	andi	a0,a0,1
    800049b0:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800049b2:	8b89                	andi	a5,a5,2
    800049b4:	c399                	beqz	a5,800049ba <flags2perm+0x14>
      perm |= PTE_W;
    800049b6:	00456513          	ori	a0,a0,4
    return perm;
}
    800049ba:	6422                	ld	s0,8(sp)
    800049bc:	0141                	addi	sp,sp,16
    800049be:	8082                	ret

00000000800049c0 <exec>:

int
exec(char *path, char **argv)
{
    800049c0:	df010113          	addi	sp,sp,-528
    800049c4:	20113423          	sd	ra,520(sp)
    800049c8:	20813023          	sd	s0,512(sp)
    800049cc:	ffa6                	sd	s1,504(sp)
    800049ce:	fbca                	sd	s2,496(sp)
    800049d0:	0c00                	addi	s0,sp,528
    800049d2:	892a                	mv	s2,a0
    800049d4:	dea43c23          	sd	a0,-520(s0)
    800049d8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800049dc:	f37fc0ef          	jal	80001912 <myproc>
    800049e0:	84aa                	mv	s1,a0

  begin_op();
    800049e2:	dc6ff0ef          	jal	80003fa8 <begin_op>

  if((ip = namei(path)) == 0){
    800049e6:	854a                	mv	a0,s2
    800049e8:	c04ff0ef          	jal	80003dec <namei>
    800049ec:	c931                	beqz	a0,80004a40 <exec+0x80>
    800049ee:	f3d2                	sd	s4,480(sp)
    800049f0:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800049f2:	d21fe0ef          	jal	80003712 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800049f6:	04000713          	li	a4,64
    800049fa:	4681                	li	a3,0
    800049fc:	e5040613          	addi	a2,s0,-432
    80004a00:	4581                	li	a1,0
    80004a02:	8552                	mv	a0,s4
    80004a04:	f63fe0ef          	jal	80003966 <readi>
    80004a08:	04000793          	li	a5,64
    80004a0c:	00f51a63          	bne	a0,a5,80004a20 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004a10:	e5042703          	lw	a4,-432(s0)
    80004a14:	464c47b7          	lui	a5,0x464c4
    80004a18:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004a1c:	02f70663          	beq	a4,a5,80004a48 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004a20:	8552                	mv	a0,s4
    80004a22:	efbfe0ef          	jal	8000391c <iunlockput>
    end_op();
    80004a26:	decff0ef          	jal	80004012 <end_op>
  }
  return -1;
    80004a2a:	557d                	li	a0,-1
    80004a2c:	7a1e                	ld	s4,480(sp)
}
    80004a2e:	20813083          	ld	ra,520(sp)
    80004a32:	20013403          	ld	s0,512(sp)
    80004a36:	74fe                	ld	s1,504(sp)
    80004a38:	795e                	ld	s2,496(sp)
    80004a3a:	21010113          	addi	sp,sp,528
    80004a3e:	8082                	ret
    end_op();
    80004a40:	dd2ff0ef          	jal	80004012 <end_op>
    return -1;
    80004a44:	557d                	li	a0,-1
    80004a46:	b7e5                	j	80004a2e <exec+0x6e>
    80004a48:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004a4a:	8526                	mv	a0,s1
    80004a4c:	85efd0ef          	jal	80001aaa <proc_pagetable>
    80004a50:	8b2a                	mv	s6,a0
    80004a52:	2c050b63          	beqz	a0,80004d28 <exec+0x368>
    80004a56:	f7ce                	sd	s3,488(sp)
    80004a58:	efd6                	sd	s5,472(sp)
    80004a5a:	e7de                	sd	s7,456(sp)
    80004a5c:	e3e2                	sd	s8,448(sp)
    80004a5e:	ff66                	sd	s9,440(sp)
    80004a60:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004a62:	e7042d03          	lw	s10,-400(s0)
    80004a66:	e8845783          	lhu	a5,-376(s0)
    80004a6a:	12078963          	beqz	a5,80004b9c <exec+0x1dc>
    80004a6e:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004a70:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004a72:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004a74:	6c85                	lui	s9,0x1
    80004a76:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004a7a:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004a7e:	6a85                	lui	s5,0x1
    80004a80:	a085                	j	80004ae0 <exec+0x120>
      panic("loadseg: address should exist");
    80004a82:	00003517          	auipc	a0,0x3
    80004a86:	b8e50513          	addi	a0,a0,-1138 # 80007610 <etext+0x610>
    80004a8a:	d19fb0ef          	jal	800007a2 <panic>
    if(sz - i < PGSIZE)
    80004a8e:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004a90:	8726                	mv	a4,s1
    80004a92:	012c06bb          	addw	a3,s8,s2
    80004a96:	4581                	li	a1,0
    80004a98:	8552                	mv	a0,s4
    80004a9a:	ecdfe0ef          	jal	80003966 <readi>
    80004a9e:	2501                	sext.w	a0,a0
    80004aa0:	24a49a63          	bne	s1,a0,80004cf4 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80004aa4:	012a893b          	addw	s2,s5,s2
    80004aa8:	03397363          	bgeu	s2,s3,80004ace <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80004aac:	02091593          	slli	a1,s2,0x20
    80004ab0:	9181                	srli	a1,a1,0x20
    80004ab2:	95de                	add	a1,a1,s7
    80004ab4:	855a                	mv	a0,s6
    80004ab6:	d2efc0ef          	jal	80000fe4 <walkaddr>
    80004aba:	862a                	mv	a2,a0
    if(pa == 0)
    80004abc:	d179                	beqz	a0,80004a82 <exec+0xc2>
    if(sz - i < PGSIZE)
    80004abe:	412984bb          	subw	s1,s3,s2
    80004ac2:	0004879b          	sext.w	a5,s1
    80004ac6:	fcfcf4e3          	bgeu	s9,a5,80004a8e <exec+0xce>
    80004aca:	84d6                	mv	s1,s5
    80004acc:	b7c9                	j	80004a8e <exec+0xce>
    sz = sz1;
    80004ace:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004ad2:	2d85                	addiw	s11,s11,1
    80004ad4:	038d0d1b          	addiw	s10,s10,56
    80004ad8:	e8845783          	lhu	a5,-376(s0)
    80004adc:	08fdd063          	bge	s11,a5,80004b5c <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004ae0:	2d01                	sext.w	s10,s10
    80004ae2:	03800713          	li	a4,56
    80004ae6:	86ea                	mv	a3,s10
    80004ae8:	e1840613          	addi	a2,s0,-488
    80004aec:	4581                	li	a1,0
    80004aee:	8552                	mv	a0,s4
    80004af0:	e77fe0ef          	jal	80003966 <readi>
    80004af4:	03800793          	li	a5,56
    80004af8:	1cf51663          	bne	a0,a5,80004cc4 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004afc:	e1842783          	lw	a5,-488(s0)
    80004b00:	4705                	li	a4,1
    80004b02:	fce798e3          	bne	a5,a4,80004ad2 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80004b06:	e4043483          	ld	s1,-448(s0)
    80004b0a:	e3843783          	ld	a5,-456(s0)
    80004b0e:	1af4ef63          	bltu	s1,a5,80004ccc <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004b12:	e2843783          	ld	a5,-472(s0)
    80004b16:	94be                	add	s1,s1,a5
    80004b18:	1af4ee63          	bltu	s1,a5,80004cd4 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80004b1c:	df043703          	ld	a4,-528(s0)
    80004b20:	8ff9                	and	a5,a5,a4
    80004b22:	1a079d63          	bnez	a5,80004cdc <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004b26:	e1c42503          	lw	a0,-484(s0)
    80004b2a:	e7dff0ef          	jal	800049a6 <flags2perm>
    80004b2e:	86aa                	mv	a3,a0
    80004b30:	8626                	mv	a2,s1
    80004b32:	85ca                	mv	a1,s2
    80004b34:	855a                	mv	a0,s6
    80004b36:	83bfc0ef          	jal	80001370 <uvmalloc>
    80004b3a:	e0a43423          	sd	a0,-504(s0)
    80004b3e:	1a050363          	beqz	a0,80004ce4 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004b42:	e2843b83          	ld	s7,-472(s0)
    80004b46:	e2042c03          	lw	s8,-480(s0)
    80004b4a:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004b4e:	00098463          	beqz	s3,80004b56 <exec+0x196>
    80004b52:	4901                	li	s2,0
    80004b54:	bfa1                	j	80004aac <exec+0xec>
    sz = sz1;
    80004b56:	e0843903          	ld	s2,-504(s0)
    80004b5a:	bfa5                	j	80004ad2 <exec+0x112>
    80004b5c:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004b5e:	8552                	mv	a0,s4
    80004b60:	dbdfe0ef          	jal	8000391c <iunlockput>
  end_op();
    80004b64:	caeff0ef          	jal	80004012 <end_op>
  p = myproc();
    80004b68:	dabfc0ef          	jal	80001912 <myproc>
    80004b6c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004b6e:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004b72:	6985                	lui	s3,0x1
    80004b74:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004b76:	99ca                	add	s3,s3,s2
    80004b78:	77fd                	lui	a5,0xfffff
    80004b7a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004b7e:	4691                	li	a3,4
    80004b80:	6609                	lui	a2,0x2
    80004b82:	964e                	add	a2,a2,s3
    80004b84:	85ce                	mv	a1,s3
    80004b86:	855a                	mv	a0,s6
    80004b88:	fe8fc0ef          	jal	80001370 <uvmalloc>
    80004b8c:	892a                	mv	s2,a0
    80004b8e:	e0a43423          	sd	a0,-504(s0)
    80004b92:	e519                	bnez	a0,80004ba0 <exec+0x1e0>
  if(pagetable)
    80004b94:	e1343423          	sd	s3,-504(s0)
    80004b98:	4a01                	li	s4,0
    80004b9a:	aab1                	j	80004cf6 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004b9c:	4901                	li	s2,0
    80004b9e:	b7c1                	j	80004b5e <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004ba0:	75f9                	lui	a1,0xffffe
    80004ba2:	95aa                	add	a1,a1,a0
    80004ba4:	855a                	mv	a0,s6
    80004ba6:	9b5fc0ef          	jal	8000155a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004baa:	7bfd                	lui	s7,0xfffff
    80004bac:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004bae:	e0043783          	ld	a5,-512(s0)
    80004bb2:	6388                	ld	a0,0(a5)
    80004bb4:	cd39                	beqz	a0,80004c12 <exec+0x252>
    80004bb6:	e9040993          	addi	s3,s0,-368
    80004bba:	f9040c13          	addi	s8,s0,-112
    80004bbe:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004bc0:	a86fc0ef          	jal	80000e46 <strlen>
    80004bc4:	0015079b          	addiw	a5,a0,1
    80004bc8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004bcc:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004bd0:	11796e63          	bltu	s2,s7,80004cec <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004bd4:	e0043d03          	ld	s10,-512(s0)
    80004bd8:	000d3a03          	ld	s4,0(s10)
    80004bdc:	8552                	mv	a0,s4
    80004bde:	a68fc0ef          	jal	80000e46 <strlen>
    80004be2:	0015069b          	addiw	a3,a0,1
    80004be6:	8652                	mv	a2,s4
    80004be8:	85ca                	mv	a1,s2
    80004bea:	855a                	mv	a0,s6
    80004bec:	999fc0ef          	jal	80001584 <copyout>
    80004bf0:	10054063          	bltz	a0,80004cf0 <exec+0x330>
    ustack[argc] = sp;
    80004bf4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004bf8:	0485                	addi	s1,s1,1
    80004bfa:	008d0793          	addi	a5,s10,8
    80004bfe:	e0f43023          	sd	a5,-512(s0)
    80004c02:	008d3503          	ld	a0,8(s10)
    80004c06:	c909                	beqz	a0,80004c18 <exec+0x258>
    if(argc >= MAXARG)
    80004c08:	09a1                	addi	s3,s3,8
    80004c0a:	fb899be3          	bne	s3,s8,80004bc0 <exec+0x200>
  ip = 0;
    80004c0e:	4a01                	li	s4,0
    80004c10:	a0dd                	j	80004cf6 <exec+0x336>
  sp = sz;
    80004c12:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004c16:	4481                	li	s1,0
  ustack[argc] = 0;
    80004c18:	00349793          	slli	a5,s1,0x3
    80004c1c:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb110>
    80004c20:	97a2                	add	a5,a5,s0
    80004c22:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004c26:	00148693          	addi	a3,s1,1
    80004c2a:	068e                	slli	a3,a3,0x3
    80004c2c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004c30:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004c34:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004c38:	f5796ee3          	bltu	s2,s7,80004b94 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004c3c:	e9040613          	addi	a2,s0,-368
    80004c40:	85ca                	mv	a1,s2
    80004c42:	855a                	mv	a0,s6
    80004c44:	941fc0ef          	jal	80001584 <copyout>
    80004c48:	0e054263          	bltz	a0,80004d2c <exec+0x36c>
  p->trapframe->a1 = sp;
    80004c4c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004c50:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004c54:	df843783          	ld	a5,-520(s0)
    80004c58:	0007c703          	lbu	a4,0(a5)
    80004c5c:	cf11                	beqz	a4,80004c78 <exec+0x2b8>
    80004c5e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004c60:	02f00693          	li	a3,47
    80004c64:	a039                	j	80004c72 <exec+0x2b2>
      last = s+1;
    80004c66:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004c6a:	0785                	addi	a5,a5,1
    80004c6c:	fff7c703          	lbu	a4,-1(a5)
    80004c70:	c701                	beqz	a4,80004c78 <exec+0x2b8>
    if(*s == '/')
    80004c72:	fed71ce3          	bne	a4,a3,80004c6a <exec+0x2aa>
    80004c76:	bfc5                	j	80004c66 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004c78:	4641                	li	a2,16
    80004c7a:	df843583          	ld	a1,-520(s0)
    80004c7e:	158a8513          	addi	a0,s5,344
    80004c82:	992fc0ef          	jal	80000e14 <safestrcpy>
  oldpagetable = p->pagetable;
    80004c86:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004c8a:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004c8e:	e0843783          	ld	a5,-504(s0)
    80004c92:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004c96:	058ab783          	ld	a5,88(s5)
    80004c9a:	e6843703          	ld	a4,-408(s0)
    80004c9e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004ca0:	058ab783          	ld	a5,88(s5)
    80004ca4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004ca8:	85e6                	mv	a1,s9
    80004caa:	e85fc0ef          	jal	80001b2e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004cae:	0004851b          	sext.w	a0,s1
    80004cb2:	79be                	ld	s3,488(sp)
    80004cb4:	7a1e                	ld	s4,480(sp)
    80004cb6:	6afe                	ld	s5,472(sp)
    80004cb8:	6b5e                	ld	s6,464(sp)
    80004cba:	6bbe                	ld	s7,456(sp)
    80004cbc:	6c1e                	ld	s8,448(sp)
    80004cbe:	7cfa                	ld	s9,440(sp)
    80004cc0:	7d5a                	ld	s10,432(sp)
    80004cc2:	b3b5                	j	80004a2e <exec+0x6e>
    80004cc4:	e1243423          	sd	s2,-504(s0)
    80004cc8:	7dba                	ld	s11,424(sp)
    80004cca:	a035                	j	80004cf6 <exec+0x336>
    80004ccc:	e1243423          	sd	s2,-504(s0)
    80004cd0:	7dba                	ld	s11,424(sp)
    80004cd2:	a015                	j	80004cf6 <exec+0x336>
    80004cd4:	e1243423          	sd	s2,-504(s0)
    80004cd8:	7dba                	ld	s11,424(sp)
    80004cda:	a831                	j	80004cf6 <exec+0x336>
    80004cdc:	e1243423          	sd	s2,-504(s0)
    80004ce0:	7dba                	ld	s11,424(sp)
    80004ce2:	a811                	j	80004cf6 <exec+0x336>
    80004ce4:	e1243423          	sd	s2,-504(s0)
    80004ce8:	7dba                	ld	s11,424(sp)
    80004cea:	a031                	j	80004cf6 <exec+0x336>
  ip = 0;
    80004cec:	4a01                	li	s4,0
    80004cee:	a021                	j	80004cf6 <exec+0x336>
    80004cf0:	4a01                	li	s4,0
  if(pagetable)
    80004cf2:	a011                	j	80004cf6 <exec+0x336>
    80004cf4:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004cf6:	e0843583          	ld	a1,-504(s0)
    80004cfa:	855a                	mv	a0,s6
    80004cfc:	e33fc0ef          	jal	80001b2e <proc_freepagetable>
  return -1;
    80004d00:	557d                	li	a0,-1
  if(ip){
    80004d02:	000a1b63          	bnez	s4,80004d18 <exec+0x358>
    80004d06:	79be                	ld	s3,488(sp)
    80004d08:	7a1e                	ld	s4,480(sp)
    80004d0a:	6afe                	ld	s5,472(sp)
    80004d0c:	6b5e                	ld	s6,464(sp)
    80004d0e:	6bbe                	ld	s7,456(sp)
    80004d10:	6c1e                	ld	s8,448(sp)
    80004d12:	7cfa                	ld	s9,440(sp)
    80004d14:	7d5a                	ld	s10,432(sp)
    80004d16:	bb21                	j	80004a2e <exec+0x6e>
    80004d18:	79be                	ld	s3,488(sp)
    80004d1a:	6afe                	ld	s5,472(sp)
    80004d1c:	6b5e                	ld	s6,464(sp)
    80004d1e:	6bbe                	ld	s7,456(sp)
    80004d20:	6c1e                	ld	s8,448(sp)
    80004d22:	7cfa                	ld	s9,440(sp)
    80004d24:	7d5a                	ld	s10,432(sp)
    80004d26:	b9ed                	j	80004a20 <exec+0x60>
    80004d28:	6b5e                	ld	s6,464(sp)
    80004d2a:	b9dd                	j	80004a20 <exec+0x60>
  sz = sz1;
    80004d2c:	e0843983          	ld	s3,-504(s0)
    80004d30:	b595                	j	80004b94 <exec+0x1d4>

0000000080004d32 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004d32:	7179                	addi	sp,sp,-48
    80004d34:	f406                	sd	ra,40(sp)
    80004d36:	f022                	sd	s0,32(sp)
    80004d38:	ec26                	sd	s1,24(sp)
    80004d3a:	e84a                	sd	s2,16(sp)
    80004d3c:	1800                	addi	s0,sp,48
    80004d3e:	892e                	mv	s2,a1
    80004d40:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004d42:	fdc40593          	addi	a1,s0,-36
    80004d46:	e31fd0ef          	jal	80002b76 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004d4a:	fdc42703          	lw	a4,-36(s0)
    80004d4e:	47bd                	li	a5,15
    80004d50:	02e7e963          	bltu	a5,a4,80004d82 <argfd+0x50>
    80004d54:	bbffc0ef          	jal	80001912 <myproc>
    80004d58:	fdc42703          	lw	a4,-36(s0)
    80004d5c:	01a70793          	addi	a5,a4,26
    80004d60:	078e                	slli	a5,a5,0x3
    80004d62:	953e                	add	a0,a0,a5
    80004d64:	611c                	ld	a5,0(a0)
    80004d66:	c385                	beqz	a5,80004d86 <argfd+0x54>
    return -1;
  if(pfd)
    80004d68:	00090463          	beqz	s2,80004d70 <argfd+0x3e>
    *pfd = fd;
    80004d6c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004d70:	4501                	li	a0,0
  if(pf)
    80004d72:	c091                	beqz	s1,80004d76 <argfd+0x44>
    *pf = f;
    80004d74:	e09c                	sd	a5,0(s1)
}
    80004d76:	70a2                	ld	ra,40(sp)
    80004d78:	7402                	ld	s0,32(sp)
    80004d7a:	64e2                	ld	s1,24(sp)
    80004d7c:	6942                	ld	s2,16(sp)
    80004d7e:	6145                	addi	sp,sp,48
    80004d80:	8082                	ret
    return -1;
    80004d82:	557d                	li	a0,-1
    80004d84:	bfcd                	j	80004d76 <argfd+0x44>
    80004d86:	557d                	li	a0,-1
    80004d88:	b7fd                	j	80004d76 <argfd+0x44>

0000000080004d8a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004d8a:	1101                	addi	sp,sp,-32
    80004d8c:	ec06                	sd	ra,24(sp)
    80004d8e:	e822                	sd	s0,16(sp)
    80004d90:	e426                	sd	s1,8(sp)
    80004d92:	1000                	addi	s0,sp,32
    80004d94:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004d96:	b7dfc0ef          	jal	80001912 <myproc>
    80004d9a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004d9c:	0d050793          	addi	a5,a0,208
    80004da0:	4501                	li	a0,0
    80004da2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004da4:	6398                	ld	a4,0(a5)
    80004da6:	cb19                	beqz	a4,80004dbc <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004da8:	2505                	addiw	a0,a0,1
    80004daa:	07a1                	addi	a5,a5,8
    80004dac:	fed51ce3          	bne	a0,a3,80004da4 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004db0:	557d                	li	a0,-1
}
    80004db2:	60e2                	ld	ra,24(sp)
    80004db4:	6442                	ld	s0,16(sp)
    80004db6:	64a2                	ld	s1,8(sp)
    80004db8:	6105                	addi	sp,sp,32
    80004dba:	8082                	ret
      p->ofile[fd] = f;
    80004dbc:	01a50793          	addi	a5,a0,26
    80004dc0:	078e                	slli	a5,a5,0x3
    80004dc2:	963e                	add	a2,a2,a5
    80004dc4:	e204                	sd	s1,0(a2)
      return fd;
    80004dc6:	b7f5                	j	80004db2 <fdalloc+0x28>

0000000080004dc8 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004dc8:	715d                	addi	sp,sp,-80
    80004dca:	e486                	sd	ra,72(sp)
    80004dcc:	e0a2                	sd	s0,64(sp)
    80004dce:	fc26                	sd	s1,56(sp)
    80004dd0:	f84a                	sd	s2,48(sp)
    80004dd2:	f44e                	sd	s3,40(sp)
    80004dd4:	ec56                	sd	s5,24(sp)
    80004dd6:	e85a                	sd	s6,16(sp)
    80004dd8:	0880                	addi	s0,sp,80
    80004dda:	8b2e                	mv	s6,a1
    80004ddc:	89b2                	mv	s3,a2
    80004dde:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004de0:	fb040593          	addi	a1,s0,-80
    80004de4:	822ff0ef          	jal	80003e06 <nameiparent>
    80004de8:	84aa                	mv	s1,a0
    80004dea:	10050a63          	beqz	a0,80004efe <create+0x136>
    return 0;

  ilock(dp);
    80004dee:	925fe0ef          	jal	80003712 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004df2:	4601                	li	a2,0
    80004df4:	fb040593          	addi	a1,s0,-80
    80004df8:	8526                	mv	a0,s1
    80004dfa:	d8dfe0ef          	jal	80003b86 <dirlookup>
    80004dfe:	8aaa                	mv	s5,a0
    80004e00:	c129                	beqz	a0,80004e42 <create+0x7a>
    iunlockput(dp);
    80004e02:	8526                	mv	a0,s1
    80004e04:	b19fe0ef          	jal	8000391c <iunlockput>
    ilock(ip);
    80004e08:	8556                	mv	a0,s5
    80004e0a:	909fe0ef          	jal	80003712 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004e0e:	4789                	li	a5,2
    80004e10:	02fb1463          	bne	s6,a5,80004e38 <create+0x70>
    80004e14:	044ad783          	lhu	a5,68(s5)
    80004e18:	37f9                	addiw	a5,a5,-2
    80004e1a:	17c2                	slli	a5,a5,0x30
    80004e1c:	93c1                	srli	a5,a5,0x30
    80004e1e:	4705                	li	a4,1
    80004e20:	00f76c63          	bltu	a4,a5,80004e38 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004e24:	8556                	mv	a0,s5
    80004e26:	60a6                	ld	ra,72(sp)
    80004e28:	6406                	ld	s0,64(sp)
    80004e2a:	74e2                	ld	s1,56(sp)
    80004e2c:	7942                	ld	s2,48(sp)
    80004e2e:	79a2                	ld	s3,40(sp)
    80004e30:	6ae2                	ld	s5,24(sp)
    80004e32:	6b42                	ld	s6,16(sp)
    80004e34:	6161                	addi	sp,sp,80
    80004e36:	8082                	ret
    iunlockput(ip);
    80004e38:	8556                	mv	a0,s5
    80004e3a:	ae3fe0ef          	jal	8000391c <iunlockput>
    return 0;
    80004e3e:	4a81                	li	s5,0
    80004e40:	b7d5                	j	80004e24 <create+0x5c>
    80004e42:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004e44:	85da                	mv	a1,s6
    80004e46:	4088                	lw	a0,0(s1)
    80004e48:	f5afe0ef          	jal	800035a2 <ialloc>
    80004e4c:	8a2a                	mv	s4,a0
    80004e4e:	cd15                	beqz	a0,80004e8a <create+0xc2>
  ilock(ip);
    80004e50:	8c3fe0ef          	jal	80003712 <ilock>
  ip->major = major;
    80004e54:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004e58:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004e5c:	4905                	li	s2,1
    80004e5e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004e62:	8552                	mv	a0,s4
    80004e64:	ffafe0ef          	jal	8000365e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004e68:	032b0763          	beq	s6,s2,80004e96 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004e6c:	004a2603          	lw	a2,4(s4)
    80004e70:	fb040593          	addi	a1,s0,-80
    80004e74:	8526                	mv	a0,s1
    80004e76:	eddfe0ef          	jal	80003d52 <dirlink>
    80004e7a:	06054563          	bltz	a0,80004ee4 <create+0x11c>
  iunlockput(dp);
    80004e7e:	8526                	mv	a0,s1
    80004e80:	a9dfe0ef          	jal	8000391c <iunlockput>
  return ip;
    80004e84:	8ad2                	mv	s5,s4
    80004e86:	7a02                	ld	s4,32(sp)
    80004e88:	bf71                	j	80004e24 <create+0x5c>
    iunlockput(dp);
    80004e8a:	8526                	mv	a0,s1
    80004e8c:	a91fe0ef          	jal	8000391c <iunlockput>
    return 0;
    80004e90:	8ad2                	mv	s5,s4
    80004e92:	7a02                	ld	s4,32(sp)
    80004e94:	bf41                	j	80004e24 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004e96:	004a2603          	lw	a2,4(s4)
    80004e9a:	00002597          	auipc	a1,0x2
    80004e9e:	79658593          	addi	a1,a1,1942 # 80007630 <etext+0x630>
    80004ea2:	8552                	mv	a0,s4
    80004ea4:	eaffe0ef          	jal	80003d52 <dirlink>
    80004ea8:	02054e63          	bltz	a0,80004ee4 <create+0x11c>
    80004eac:	40d0                	lw	a2,4(s1)
    80004eae:	00002597          	auipc	a1,0x2
    80004eb2:	78a58593          	addi	a1,a1,1930 # 80007638 <etext+0x638>
    80004eb6:	8552                	mv	a0,s4
    80004eb8:	e9bfe0ef          	jal	80003d52 <dirlink>
    80004ebc:	02054463          	bltz	a0,80004ee4 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004ec0:	004a2603          	lw	a2,4(s4)
    80004ec4:	fb040593          	addi	a1,s0,-80
    80004ec8:	8526                	mv	a0,s1
    80004eca:	e89fe0ef          	jal	80003d52 <dirlink>
    80004ece:	00054b63          	bltz	a0,80004ee4 <create+0x11c>
    dp->nlink++;  // for ".."
    80004ed2:	04a4d783          	lhu	a5,74(s1)
    80004ed6:	2785                	addiw	a5,a5,1
    80004ed8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004edc:	8526                	mv	a0,s1
    80004ede:	f80fe0ef          	jal	8000365e <iupdate>
    80004ee2:	bf71                	j	80004e7e <create+0xb6>
  ip->nlink = 0;
    80004ee4:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004ee8:	8552                	mv	a0,s4
    80004eea:	f74fe0ef          	jal	8000365e <iupdate>
  iunlockput(ip);
    80004eee:	8552                	mv	a0,s4
    80004ef0:	a2dfe0ef          	jal	8000391c <iunlockput>
  iunlockput(dp);
    80004ef4:	8526                	mv	a0,s1
    80004ef6:	a27fe0ef          	jal	8000391c <iunlockput>
  return 0;
    80004efa:	7a02                	ld	s4,32(sp)
    80004efc:	b725                	j	80004e24 <create+0x5c>
    return 0;
    80004efe:	8aaa                	mv	s5,a0
    80004f00:	b715                	j	80004e24 <create+0x5c>

0000000080004f02 <sys_dup>:
{
    80004f02:	7179                	addi	sp,sp,-48
    80004f04:	f406                	sd	ra,40(sp)
    80004f06:	f022                	sd	s0,32(sp)
    80004f08:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004f0a:	fd840613          	addi	a2,s0,-40
    80004f0e:	4581                	li	a1,0
    80004f10:	4501                	li	a0,0
    80004f12:	e21ff0ef          	jal	80004d32 <argfd>
    return -1;
    80004f16:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004f18:	02054363          	bltz	a0,80004f3e <sys_dup+0x3c>
    80004f1c:	ec26                	sd	s1,24(sp)
    80004f1e:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004f20:	fd843903          	ld	s2,-40(s0)
    80004f24:	854a                	mv	a0,s2
    80004f26:	e65ff0ef          	jal	80004d8a <fdalloc>
    80004f2a:	84aa                	mv	s1,a0
    return -1;
    80004f2c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004f2e:	00054d63          	bltz	a0,80004f48 <sys_dup+0x46>
  filedup(f);
    80004f32:	854a                	mv	a0,s2
    80004f34:	c48ff0ef          	jal	8000437c <filedup>
  return fd;
    80004f38:	87a6                	mv	a5,s1
    80004f3a:	64e2                	ld	s1,24(sp)
    80004f3c:	6942                	ld	s2,16(sp)
}
    80004f3e:	853e                	mv	a0,a5
    80004f40:	70a2                	ld	ra,40(sp)
    80004f42:	7402                	ld	s0,32(sp)
    80004f44:	6145                	addi	sp,sp,48
    80004f46:	8082                	ret
    80004f48:	64e2                	ld	s1,24(sp)
    80004f4a:	6942                	ld	s2,16(sp)
    80004f4c:	bfcd                	j	80004f3e <sys_dup+0x3c>

0000000080004f4e <sys_read>:
{
    80004f4e:	7179                	addi	sp,sp,-48
    80004f50:	f406                	sd	ra,40(sp)
    80004f52:	f022                	sd	s0,32(sp)
    80004f54:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004f56:	fd840593          	addi	a1,s0,-40
    80004f5a:	4505                	li	a0,1
    80004f5c:	c37fd0ef          	jal	80002b92 <argaddr>
  argint(2, &n);
    80004f60:	fe440593          	addi	a1,s0,-28
    80004f64:	4509                	li	a0,2
    80004f66:	c11fd0ef          	jal	80002b76 <argint>
  if(argfd(0, 0, &f) < 0)
    80004f6a:	fe840613          	addi	a2,s0,-24
    80004f6e:	4581                	li	a1,0
    80004f70:	4501                	li	a0,0
    80004f72:	dc1ff0ef          	jal	80004d32 <argfd>
    80004f76:	87aa                	mv	a5,a0
    return -1;
    80004f78:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004f7a:	0007ca63          	bltz	a5,80004f8e <sys_read+0x40>
  return fileread(f, p, n);
    80004f7e:	fe442603          	lw	a2,-28(s0)
    80004f82:	fd843583          	ld	a1,-40(s0)
    80004f86:	fe843503          	ld	a0,-24(s0)
    80004f8a:	d58ff0ef          	jal	800044e2 <fileread>
}
    80004f8e:	70a2                	ld	ra,40(sp)
    80004f90:	7402                	ld	s0,32(sp)
    80004f92:	6145                	addi	sp,sp,48
    80004f94:	8082                	ret

0000000080004f96 <sys_write>:
{
    80004f96:	7179                	addi	sp,sp,-48
    80004f98:	f406                	sd	ra,40(sp)
    80004f9a:	f022                	sd	s0,32(sp)
    80004f9c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004f9e:	fd840593          	addi	a1,s0,-40
    80004fa2:	4505                	li	a0,1
    80004fa4:	beffd0ef          	jal	80002b92 <argaddr>
  argint(2, &n);
    80004fa8:	fe440593          	addi	a1,s0,-28
    80004fac:	4509                	li	a0,2
    80004fae:	bc9fd0ef          	jal	80002b76 <argint>
  if(argfd(0, 0, &f) < 0)
    80004fb2:	fe840613          	addi	a2,s0,-24
    80004fb6:	4581                	li	a1,0
    80004fb8:	4501                	li	a0,0
    80004fba:	d79ff0ef          	jal	80004d32 <argfd>
    80004fbe:	87aa                	mv	a5,a0
    return -1;
    80004fc0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004fc2:	0007ca63          	bltz	a5,80004fd6 <sys_write+0x40>
  return filewrite(f, p, n);
    80004fc6:	fe442603          	lw	a2,-28(s0)
    80004fca:	fd843583          	ld	a1,-40(s0)
    80004fce:	fe843503          	ld	a0,-24(s0)
    80004fd2:	dceff0ef          	jal	800045a0 <filewrite>
}
    80004fd6:	70a2                	ld	ra,40(sp)
    80004fd8:	7402                	ld	s0,32(sp)
    80004fda:	6145                	addi	sp,sp,48
    80004fdc:	8082                	ret

0000000080004fde <sys_close>:
{
    80004fde:	1101                	addi	sp,sp,-32
    80004fe0:	ec06                	sd	ra,24(sp)
    80004fe2:	e822                	sd	s0,16(sp)
    80004fe4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004fe6:	fe040613          	addi	a2,s0,-32
    80004fea:	fec40593          	addi	a1,s0,-20
    80004fee:	4501                	li	a0,0
    80004ff0:	d43ff0ef          	jal	80004d32 <argfd>
    return -1;
    80004ff4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004ff6:	02054063          	bltz	a0,80005016 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004ffa:	919fc0ef          	jal	80001912 <myproc>
    80004ffe:	fec42783          	lw	a5,-20(s0)
    80005002:	07e9                	addi	a5,a5,26
    80005004:	078e                	slli	a5,a5,0x3
    80005006:	953e                	add	a0,a0,a5
    80005008:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000500c:	fe043503          	ld	a0,-32(s0)
    80005010:	bb2ff0ef          	jal	800043c2 <fileclose>
  return 0;
    80005014:	4781                	li	a5,0
}
    80005016:	853e                	mv	a0,a5
    80005018:	60e2                	ld	ra,24(sp)
    8000501a:	6442                	ld	s0,16(sp)
    8000501c:	6105                	addi	sp,sp,32
    8000501e:	8082                	ret

0000000080005020 <sys_fstat>:
{
    80005020:	1101                	addi	sp,sp,-32
    80005022:	ec06                	sd	ra,24(sp)
    80005024:	e822                	sd	s0,16(sp)
    80005026:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005028:	fe040593          	addi	a1,s0,-32
    8000502c:	4505                	li	a0,1
    8000502e:	b65fd0ef          	jal	80002b92 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005032:	fe840613          	addi	a2,s0,-24
    80005036:	4581                	li	a1,0
    80005038:	4501                	li	a0,0
    8000503a:	cf9ff0ef          	jal	80004d32 <argfd>
    8000503e:	87aa                	mv	a5,a0
    return -1;
    80005040:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005042:	0007c863          	bltz	a5,80005052 <sys_fstat+0x32>
  return filestat(f, st);
    80005046:	fe043583          	ld	a1,-32(s0)
    8000504a:	fe843503          	ld	a0,-24(s0)
    8000504e:	c36ff0ef          	jal	80004484 <filestat>
}
    80005052:	60e2                	ld	ra,24(sp)
    80005054:	6442                	ld	s0,16(sp)
    80005056:	6105                	addi	sp,sp,32
    80005058:	8082                	ret

000000008000505a <sys_link>:
{
    8000505a:	7169                	addi	sp,sp,-304
    8000505c:	f606                	sd	ra,296(sp)
    8000505e:	f222                	sd	s0,288(sp)
    80005060:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005062:	08000613          	li	a2,128
    80005066:	ed040593          	addi	a1,s0,-304
    8000506a:	4501                	li	a0,0
    8000506c:	b45fd0ef          	jal	80002bb0 <argstr>
    return -1;
    80005070:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005072:	0c054e63          	bltz	a0,8000514e <sys_link+0xf4>
    80005076:	08000613          	li	a2,128
    8000507a:	f5040593          	addi	a1,s0,-176
    8000507e:	4505                	li	a0,1
    80005080:	b31fd0ef          	jal	80002bb0 <argstr>
    return -1;
    80005084:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005086:	0c054463          	bltz	a0,8000514e <sys_link+0xf4>
    8000508a:	ee26                	sd	s1,280(sp)
  begin_op();
    8000508c:	f1dfe0ef          	jal	80003fa8 <begin_op>
  if((ip = namei(old)) == 0){
    80005090:	ed040513          	addi	a0,s0,-304
    80005094:	d59fe0ef          	jal	80003dec <namei>
    80005098:	84aa                	mv	s1,a0
    8000509a:	c53d                	beqz	a0,80005108 <sys_link+0xae>
  ilock(ip);
    8000509c:	e76fe0ef          	jal	80003712 <ilock>
  if(ip->type == T_DIR){
    800050a0:	04449703          	lh	a4,68(s1)
    800050a4:	4785                	li	a5,1
    800050a6:	06f70663          	beq	a4,a5,80005112 <sys_link+0xb8>
    800050aa:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800050ac:	04a4d783          	lhu	a5,74(s1)
    800050b0:	2785                	addiw	a5,a5,1
    800050b2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800050b6:	8526                	mv	a0,s1
    800050b8:	da6fe0ef          	jal	8000365e <iupdate>
  iunlock(ip);
    800050bc:	8526                	mv	a0,s1
    800050be:	f02fe0ef          	jal	800037c0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800050c2:	fd040593          	addi	a1,s0,-48
    800050c6:	f5040513          	addi	a0,s0,-176
    800050ca:	d3dfe0ef          	jal	80003e06 <nameiparent>
    800050ce:	892a                	mv	s2,a0
    800050d0:	cd21                	beqz	a0,80005128 <sys_link+0xce>
  ilock(dp);
    800050d2:	e40fe0ef          	jal	80003712 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800050d6:	00092703          	lw	a4,0(s2)
    800050da:	409c                	lw	a5,0(s1)
    800050dc:	04f71363          	bne	a4,a5,80005122 <sys_link+0xc8>
    800050e0:	40d0                	lw	a2,4(s1)
    800050e2:	fd040593          	addi	a1,s0,-48
    800050e6:	854a                	mv	a0,s2
    800050e8:	c6bfe0ef          	jal	80003d52 <dirlink>
    800050ec:	02054b63          	bltz	a0,80005122 <sys_link+0xc8>
  iunlockput(dp);
    800050f0:	854a                	mv	a0,s2
    800050f2:	82bfe0ef          	jal	8000391c <iunlockput>
  iput(ip);
    800050f6:	8526                	mv	a0,s1
    800050f8:	f9cfe0ef          	jal	80003894 <iput>
  end_op();
    800050fc:	f17fe0ef          	jal	80004012 <end_op>
  return 0;
    80005100:	4781                	li	a5,0
    80005102:	64f2                	ld	s1,280(sp)
    80005104:	6952                	ld	s2,272(sp)
    80005106:	a0a1                	j	8000514e <sys_link+0xf4>
    end_op();
    80005108:	f0bfe0ef          	jal	80004012 <end_op>
    return -1;
    8000510c:	57fd                	li	a5,-1
    8000510e:	64f2                	ld	s1,280(sp)
    80005110:	a83d                	j	8000514e <sys_link+0xf4>
    iunlockput(ip);
    80005112:	8526                	mv	a0,s1
    80005114:	809fe0ef          	jal	8000391c <iunlockput>
    end_op();
    80005118:	efbfe0ef          	jal	80004012 <end_op>
    return -1;
    8000511c:	57fd                	li	a5,-1
    8000511e:	64f2                	ld	s1,280(sp)
    80005120:	a03d                	j	8000514e <sys_link+0xf4>
    iunlockput(dp);
    80005122:	854a                	mv	a0,s2
    80005124:	ff8fe0ef          	jal	8000391c <iunlockput>
  ilock(ip);
    80005128:	8526                	mv	a0,s1
    8000512a:	de8fe0ef          	jal	80003712 <ilock>
  ip->nlink--;
    8000512e:	04a4d783          	lhu	a5,74(s1)
    80005132:	37fd                	addiw	a5,a5,-1
    80005134:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005138:	8526                	mv	a0,s1
    8000513a:	d24fe0ef          	jal	8000365e <iupdate>
  iunlockput(ip);
    8000513e:	8526                	mv	a0,s1
    80005140:	fdcfe0ef          	jal	8000391c <iunlockput>
  end_op();
    80005144:	ecffe0ef          	jal	80004012 <end_op>
  return -1;
    80005148:	57fd                	li	a5,-1
    8000514a:	64f2                	ld	s1,280(sp)
    8000514c:	6952                	ld	s2,272(sp)
}
    8000514e:	853e                	mv	a0,a5
    80005150:	70b2                	ld	ra,296(sp)
    80005152:	7412                	ld	s0,288(sp)
    80005154:	6155                	addi	sp,sp,304
    80005156:	8082                	ret

0000000080005158 <sys_unlink>:
{
    80005158:	7151                	addi	sp,sp,-240
    8000515a:	f586                	sd	ra,232(sp)
    8000515c:	f1a2                	sd	s0,224(sp)
    8000515e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005160:	08000613          	li	a2,128
    80005164:	f3040593          	addi	a1,s0,-208
    80005168:	4501                	li	a0,0
    8000516a:	a47fd0ef          	jal	80002bb0 <argstr>
    8000516e:	16054063          	bltz	a0,800052ce <sys_unlink+0x176>
    80005172:	eda6                	sd	s1,216(sp)
  begin_op();
    80005174:	e35fe0ef          	jal	80003fa8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005178:	fb040593          	addi	a1,s0,-80
    8000517c:	f3040513          	addi	a0,s0,-208
    80005180:	c87fe0ef          	jal	80003e06 <nameiparent>
    80005184:	84aa                	mv	s1,a0
    80005186:	c945                	beqz	a0,80005236 <sys_unlink+0xde>
  ilock(dp);
    80005188:	d8afe0ef          	jal	80003712 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000518c:	00002597          	auipc	a1,0x2
    80005190:	4a458593          	addi	a1,a1,1188 # 80007630 <etext+0x630>
    80005194:	fb040513          	addi	a0,s0,-80
    80005198:	9d9fe0ef          	jal	80003b70 <namecmp>
    8000519c:	10050e63          	beqz	a0,800052b8 <sys_unlink+0x160>
    800051a0:	00002597          	auipc	a1,0x2
    800051a4:	49858593          	addi	a1,a1,1176 # 80007638 <etext+0x638>
    800051a8:	fb040513          	addi	a0,s0,-80
    800051ac:	9c5fe0ef          	jal	80003b70 <namecmp>
    800051b0:	10050463          	beqz	a0,800052b8 <sys_unlink+0x160>
    800051b4:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800051b6:	f2c40613          	addi	a2,s0,-212
    800051ba:	fb040593          	addi	a1,s0,-80
    800051be:	8526                	mv	a0,s1
    800051c0:	9c7fe0ef          	jal	80003b86 <dirlookup>
    800051c4:	892a                	mv	s2,a0
    800051c6:	0e050863          	beqz	a0,800052b6 <sys_unlink+0x15e>
  ilock(ip);
    800051ca:	d48fe0ef          	jal	80003712 <ilock>
  if(ip->nlink < 1)
    800051ce:	04a91783          	lh	a5,74(s2)
    800051d2:	06f05763          	blez	a5,80005240 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800051d6:	04491703          	lh	a4,68(s2)
    800051da:	4785                	li	a5,1
    800051dc:	06f70963          	beq	a4,a5,8000524e <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800051e0:	4641                	li	a2,16
    800051e2:	4581                	li	a1,0
    800051e4:	fc040513          	addi	a0,s0,-64
    800051e8:	aeffb0ef          	jal	80000cd6 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800051ec:	4741                	li	a4,16
    800051ee:	f2c42683          	lw	a3,-212(s0)
    800051f2:	fc040613          	addi	a2,s0,-64
    800051f6:	4581                	li	a1,0
    800051f8:	8526                	mv	a0,s1
    800051fa:	869fe0ef          	jal	80003a62 <writei>
    800051fe:	47c1                	li	a5,16
    80005200:	08f51b63          	bne	a0,a5,80005296 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80005204:	04491703          	lh	a4,68(s2)
    80005208:	4785                	li	a5,1
    8000520a:	08f70d63          	beq	a4,a5,800052a4 <sys_unlink+0x14c>
  iunlockput(dp);
    8000520e:	8526                	mv	a0,s1
    80005210:	f0cfe0ef          	jal	8000391c <iunlockput>
  ip->nlink--;
    80005214:	04a95783          	lhu	a5,74(s2)
    80005218:	37fd                	addiw	a5,a5,-1
    8000521a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000521e:	854a                	mv	a0,s2
    80005220:	c3efe0ef          	jal	8000365e <iupdate>
  iunlockput(ip);
    80005224:	854a                	mv	a0,s2
    80005226:	ef6fe0ef          	jal	8000391c <iunlockput>
  end_op();
    8000522a:	de9fe0ef          	jal	80004012 <end_op>
  return 0;
    8000522e:	4501                	li	a0,0
    80005230:	64ee                	ld	s1,216(sp)
    80005232:	694e                	ld	s2,208(sp)
    80005234:	a849                	j	800052c6 <sys_unlink+0x16e>
    end_op();
    80005236:	dddfe0ef          	jal	80004012 <end_op>
    return -1;
    8000523a:	557d                	li	a0,-1
    8000523c:	64ee                	ld	s1,216(sp)
    8000523e:	a061                	j	800052c6 <sys_unlink+0x16e>
    80005240:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005242:	00002517          	auipc	a0,0x2
    80005246:	3fe50513          	addi	a0,a0,1022 # 80007640 <etext+0x640>
    8000524a:	d58fb0ef          	jal	800007a2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000524e:	04c92703          	lw	a4,76(s2)
    80005252:	02000793          	li	a5,32
    80005256:	f8e7f5e3          	bgeu	a5,a4,800051e0 <sys_unlink+0x88>
    8000525a:	e5ce                	sd	s3,200(sp)
    8000525c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005260:	4741                	li	a4,16
    80005262:	86ce                	mv	a3,s3
    80005264:	f1840613          	addi	a2,s0,-232
    80005268:	4581                	li	a1,0
    8000526a:	854a                	mv	a0,s2
    8000526c:	efafe0ef          	jal	80003966 <readi>
    80005270:	47c1                	li	a5,16
    80005272:	00f51c63          	bne	a0,a5,8000528a <sys_unlink+0x132>
    if(de.inum != 0)
    80005276:	f1845783          	lhu	a5,-232(s0)
    8000527a:	efa1                	bnez	a5,800052d2 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000527c:	29c1                	addiw	s3,s3,16
    8000527e:	04c92783          	lw	a5,76(s2)
    80005282:	fcf9efe3          	bltu	s3,a5,80005260 <sys_unlink+0x108>
    80005286:	69ae                	ld	s3,200(sp)
    80005288:	bfa1                	j	800051e0 <sys_unlink+0x88>
      panic("isdirempty: readi");
    8000528a:	00002517          	auipc	a0,0x2
    8000528e:	3ce50513          	addi	a0,a0,974 # 80007658 <etext+0x658>
    80005292:	d10fb0ef          	jal	800007a2 <panic>
    80005296:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005298:	00002517          	auipc	a0,0x2
    8000529c:	3d850513          	addi	a0,a0,984 # 80007670 <etext+0x670>
    800052a0:	d02fb0ef          	jal	800007a2 <panic>
    dp->nlink--;
    800052a4:	04a4d783          	lhu	a5,74(s1)
    800052a8:	37fd                	addiw	a5,a5,-1
    800052aa:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800052ae:	8526                	mv	a0,s1
    800052b0:	baefe0ef          	jal	8000365e <iupdate>
    800052b4:	bfa9                	j	8000520e <sys_unlink+0xb6>
    800052b6:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800052b8:	8526                	mv	a0,s1
    800052ba:	e62fe0ef          	jal	8000391c <iunlockput>
  end_op();
    800052be:	d55fe0ef          	jal	80004012 <end_op>
  return -1;
    800052c2:	557d                	li	a0,-1
    800052c4:	64ee                	ld	s1,216(sp)
}
    800052c6:	70ae                	ld	ra,232(sp)
    800052c8:	740e                	ld	s0,224(sp)
    800052ca:	616d                	addi	sp,sp,240
    800052cc:	8082                	ret
    return -1;
    800052ce:	557d                	li	a0,-1
    800052d0:	bfdd                	j	800052c6 <sys_unlink+0x16e>
    iunlockput(ip);
    800052d2:	854a                	mv	a0,s2
    800052d4:	e48fe0ef          	jal	8000391c <iunlockput>
    goto bad;
    800052d8:	694e                	ld	s2,208(sp)
    800052da:	69ae                	ld	s3,200(sp)
    800052dc:	bff1                	j	800052b8 <sys_unlink+0x160>

00000000800052de <sys_open>:

uint64
sys_open(void)
{
    800052de:	7131                	addi	sp,sp,-192
    800052e0:	fd06                	sd	ra,184(sp)
    800052e2:	f922                	sd	s0,176(sp)
    800052e4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800052e6:	f4c40593          	addi	a1,s0,-180
    800052ea:	4505                	li	a0,1
    800052ec:	88bfd0ef          	jal	80002b76 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800052f0:	08000613          	li	a2,128
    800052f4:	f5040593          	addi	a1,s0,-176
    800052f8:	4501                	li	a0,0
    800052fa:	8b7fd0ef          	jal	80002bb0 <argstr>
    800052fe:	87aa                	mv	a5,a0
    return -1;
    80005300:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005302:	0a07c263          	bltz	a5,800053a6 <sys_open+0xc8>
    80005306:	f526                	sd	s1,168(sp)

  begin_op();
    80005308:	ca1fe0ef          	jal	80003fa8 <begin_op>

  if(omode & O_CREATE){
    8000530c:	f4c42783          	lw	a5,-180(s0)
    80005310:	2007f793          	andi	a5,a5,512
    80005314:	c3d5                	beqz	a5,800053b8 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80005316:	4681                	li	a3,0
    80005318:	4601                	li	a2,0
    8000531a:	4589                	li	a1,2
    8000531c:	f5040513          	addi	a0,s0,-176
    80005320:	aa9ff0ef          	jal	80004dc8 <create>
    80005324:	84aa                	mv	s1,a0
    if(ip == 0){
    80005326:	c541                	beqz	a0,800053ae <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005328:	04449703          	lh	a4,68(s1)
    8000532c:	478d                	li	a5,3
    8000532e:	00f71763          	bne	a4,a5,8000533c <sys_open+0x5e>
    80005332:	0464d703          	lhu	a4,70(s1)
    80005336:	47a5                	li	a5,9
    80005338:	0ae7ed63          	bltu	a5,a4,800053f2 <sys_open+0x114>
    8000533c:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000533e:	fe1fe0ef          	jal	8000431e <filealloc>
    80005342:	892a                	mv	s2,a0
    80005344:	c179                	beqz	a0,8000540a <sys_open+0x12c>
    80005346:	ed4e                	sd	s3,152(sp)
    80005348:	a43ff0ef          	jal	80004d8a <fdalloc>
    8000534c:	89aa                	mv	s3,a0
    8000534e:	0a054a63          	bltz	a0,80005402 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005352:	04449703          	lh	a4,68(s1)
    80005356:	478d                	li	a5,3
    80005358:	0cf70263          	beq	a4,a5,8000541c <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000535c:	4789                	li	a5,2
    8000535e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005362:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005366:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000536a:	f4c42783          	lw	a5,-180(s0)
    8000536e:	0017c713          	xori	a4,a5,1
    80005372:	8b05                	andi	a4,a4,1
    80005374:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005378:	0037f713          	andi	a4,a5,3
    8000537c:	00e03733          	snez	a4,a4
    80005380:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005384:	4007f793          	andi	a5,a5,1024
    80005388:	c791                	beqz	a5,80005394 <sys_open+0xb6>
    8000538a:	04449703          	lh	a4,68(s1)
    8000538e:	4789                	li	a5,2
    80005390:	08f70d63          	beq	a4,a5,8000542a <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80005394:	8526                	mv	a0,s1
    80005396:	c2afe0ef          	jal	800037c0 <iunlock>
  end_op();
    8000539a:	c79fe0ef          	jal	80004012 <end_op>

  return fd;
    8000539e:	854e                	mv	a0,s3
    800053a0:	74aa                	ld	s1,168(sp)
    800053a2:	790a                	ld	s2,160(sp)
    800053a4:	69ea                	ld	s3,152(sp)
}
    800053a6:	70ea                	ld	ra,184(sp)
    800053a8:	744a                	ld	s0,176(sp)
    800053aa:	6129                	addi	sp,sp,192
    800053ac:	8082                	ret
      end_op();
    800053ae:	c65fe0ef          	jal	80004012 <end_op>
      return -1;
    800053b2:	557d                	li	a0,-1
    800053b4:	74aa                	ld	s1,168(sp)
    800053b6:	bfc5                	j	800053a6 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800053b8:	f5040513          	addi	a0,s0,-176
    800053bc:	a31fe0ef          	jal	80003dec <namei>
    800053c0:	84aa                	mv	s1,a0
    800053c2:	c11d                	beqz	a0,800053e8 <sys_open+0x10a>
    ilock(ip);
    800053c4:	b4efe0ef          	jal	80003712 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800053c8:	04449703          	lh	a4,68(s1)
    800053cc:	4785                	li	a5,1
    800053ce:	f4f71de3          	bne	a4,a5,80005328 <sys_open+0x4a>
    800053d2:	f4c42783          	lw	a5,-180(s0)
    800053d6:	d3bd                	beqz	a5,8000533c <sys_open+0x5e>
      iunlockput(ip);
    800053d8:	8526                	mv	a0,s1
    800053da:	d42fe0ef          	jal	8000391c <iunlockput>
      end_op();
    800053de:	c35fe0ef          	jal	80004012 <end_op>
      return -1;
    800053e2:	557d                	li	a0,-1
    800053e4:	74aa                	ld	s1,168(sp)
    800053e6:	b7c1                	j	800053a6 <sys_open+0xc8>
      end_op();
    800053e8:	c2bfe0ef          	jal	80004012 <end_op>
      return -1;
    800053ec:	557d                	li	a0,-1
    800053ee:	74aa                	ld	s1,168(sp)
    800053f0:	bf5d                	j	800053a6 <sys_open+0xc8>
    iunlockput(ip);
    800053f2:	8526                	mv	a0,s1
    800053f4:	d28fe0ef          	jal	8000391c <iunlockput>
    end_op();
    800053f8:	c1bfe0ef          	jal	80004012 <end_op>
    return -1;
    800053fc:	557d                	li	a0,-1
    800053fe:	74aa                	ld	s1,168(sp)
    80005400:	b75d                	j	800053a6 <sys_open+0xc8>
      fileclose(f);
    80005402:	854a                	mv	a0,s2
    80005404:	fbffe0ef          	jal	800043c2 <fileclose>
    80005408:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000540a:	8526                	mv	a0,s1
    8000540c:	d10fe0ef          	jal	8000391c <iunlockput>
    end_op();
    80005410:	c03fe0ef          	jal	80004012 <end_op>
    return -1;
    80005414:	557d                	li	a0,-1
    80005416:	74aa                	ld	s1,168(sp)
    80005418:	790a                	ld	s2,160(sp)
    8000541a:	b771                	j	800053a6 <sys_open+0xc8>
    f->type = FD_DEVICE;
    8000541c:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005420:	04649783          	lh	a5,70(s1)
    80005424:	02f91223          	sh	a5,36(s2)
    80005428:	bf3d                	j	80005366 <sys_open+0x88>
    itrunc(ip);
    8000542a:	8526                	mv	a0,s1
    8000542c:	bd4fe0ef          	jal	80003800 <itrunc>
    80005430:	b795                	j	80005394 <sys_open+0xb6>

0000000080005432 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005432:	7175                	addi	sp,sp,-144
    80005434:	e506                	sd	ra,136(sp)
    80005436:	e122                	sd	s0,128(sp)
    80005438:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000543a:	b6ffe0ef          	jal	80003fa8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000543e:	08000613          	li	a2,128
    80005442:	f7040593          	addi	a1,s0,-144
    80005446:	4501                	li	a0,0
    80005448:	f68fd0ef          	jal	80002bb0 <argstr>
    8000544c:	02054363          	bltz	a0,80005472 <sys_mkdir+0x40>
    80005450:	4681                	li	a3,0
    80005452:	4601                	li	a2,0
    80005454:	4585                	li	a1,1
    80005456:	f7040513          	addi	a0,s0,-144
    8000545a:	96fff0ef          	jal	80004dc8 <create>
    8000545e:	c911                	beqz	a0,80005472 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005460:	cbcfe0ef          	jal	8000391c <iunlockput>
  end_op();
    80005464:	baffe0ef          	jal	80004012 <end_op>
  return 0;
    80005468:	4501                	li	a0,0
}
    8000546a:	60aa                	ld	ra,136(sp)
    8000546c:	640a                	ld	s0,128(sp)
    8000546e:	6149                	addi	sp,sp,144
    80005470:	8082                	ret
    end_op();
    80005472:	ba1fe0ef          	jal	80004012 <end_op>
    return -1;
    80005476:	557d                	li	a0,-1
    80005478:	bfcd                	j	8000546a <sys_mkdir+0x38>

000000008000547a <sys_mknod>:

uint64
sys_mknod(void)
{
    8000547a:	7135                	addi	sp,sp,-160
    8000547c:	ed06                	sd	ra,152(sp)
    8000547e:	e922                	sd	s0,144(sp)
    80005480:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005482:	b27fe0ef          	jal	80003fa8 <begin_op>
  argint(1, &major);
    80005486:	f6c40593          	addi	a1,s0,-148
    8000548a:	4505                	li	a0,1
    8000548c:	eeafd0ef          	jal	80002b76 <argint>
  argint(2, &minor);
    80005490:	f6840593          	addi	a1,s0,-152
    80005494:	4509                	li	a0,2
    80005496:	ee0fd0ef          	jal	80002b76 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000549a:	08000613          	li	a2,128
    8000549e:	f7040593          	addi	a1,s0,-144
    800054a2:	4501                	li	a0,0
    800054a4:	f0cfd0ef          	jal	80002bb0 <argstr>
    800054a8:	02054563          	bltz	a0,800054d2 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800054ac:	f6841683          	lh	a3,-152(s0)
    800054b0:	f6c41603          	lh	a2,-148(s0)
    800054b4:	458d                	li	a1,3
    800054b6:	f7040513          	addi	a0,s0,-144
    800054ba:	90fff0ef          	jal	80004dc8 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800054be:	c911                	beqz	a0,800054d2 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800054c0:	c5cfe0ef          	jal	8000391c <iunlockput>
  end_op();
    800054c4:	b4ffe0ef          	jal	80004012 <end_op>
  return 0;
    800054c8:	4501                	li	a0,0
}
    800054ca:	60ea                	ld	ra,152(sp)
    800054cc:	644a                	ld	s0,144(sp)
    800054ce:	610d                	addi	sp,sp,160
    800054d0:	8082                	ret
    end_op();
    800054d2:	b41fe0ef          	jal	80004012 <end_op>
    return -1;
    800054d6:	557d                	li	a0,-1
    800054d8:	bfcd                	j	800054ca <sys_mknod+0x50>

00000000800054da <sys_chdir>:

uint64
sys_chdir(void)
{
    800054da:	7135                	addi	sp,sp,-160
    800054dc:	ed06                	sd	ra,152(sp)
    800054de:	e922                	sd	s0,144(sp)
    800054e0:	e14a                	sd	s2,128(sp)
    800054e2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800054e4:	c2efc0ef          	jal	80001912 <myproc>
    800054e8:	892a                	mv	s2,a0
  
  begin_op();
    800054ea:	abffe0ef          	jal	80003fa8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800054ee:	08000613          	li	a2,128
    800054f2:	f6040593          	addi	a1,s0,-160
    800054f6:	4501                	li	a0,0
    800054f8:	eb8fd0ef          	jal	80002bb0 <argstr>
    800054fc:	04054363          	bltz	a0,80005542 <sys_chdir+0x68>
    80005500:	e526                	sd	s1,136(sp)
    80005502:	f6040513          	addi	a0,s0,-160
    80005506:	8e7fe0ef          	jal	80003dec <namei>
    8000550a:	84aa                	mv	s1,a0
    8000550c:	c915                	beqz	a0,80005540 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000550e:	a04fe0ef          	jal	80003712 <ilock>
  if(ip->type != T_DIR){
    80005512:	04449703          	lh	a4,68(s1)
    80005516:	4785                	li	a5,1
    80005518:	02f71963          	bne	a4,a5,8000554a <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000551c:	8526                	mv	a0,s1
    8000551e:	aa2fe0ef          	jal	800037c0 <iunlock>
  iput(p->cwd);
    80005522:	15093503          	ld	a0,336(s2)
    80005526:	b6efe0ef          	jal	80003894 <iput>
  end_op();
    8000552a:	ae9fe0ef          	jal	80004012 <end_op>
  p->cwd = ip;
    8000552e:	14993823          	sd	s1,336(s2)
  return 0;
    80005532:	4501                	li	a0,0
    80005534:	64aa                	ld	s1,136(sp)
}
    80005536:	60ea                	ld	ra,152(sp)
    80005538:	644a                	ld	s0,144(sp)
    8000553a:	690a                	ld	s2,128(sp)
    8000553c:	610d                	addi	sp,sp,160
    8000553e:	8082                	ret
    80005540:	64aa                	ld	s1,136(sp)
    end_op();
    80005542:	ad1fe0ef          	jal	80004012 <end_op>
    return -1;
    80005546:	557d                	li	a0,-1
    80005548:	b7fd                	j	80005536 <sys_chdir+0x5c>
    iunlockput(ip);
    8000554a:	8526                	mv	a0,s1
    8000554c:	bd0fe0ef          	jal	8000391c <iunlockput>
    end_op();
    80005550:	ac3fe0ef          	jal	80004012 <end_op>
    return -1;
    80005554:	557d                	li	a0,-1
    80005556:	64aa                	ld	s1,136(sp)
    80005558:	bff9                	j	80005536 <sys_chdir+0x5c>

000000008000555a <sys_exec>:

uint64
sys_exec(void)
{
    8000555a:	7121                	addi	sp,sp,-448
    8000555c:	ff06                	sd	ra,440(sp)
    8000555e:	fb22                	sd	s0,432(sp)
    80005560:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005562:	e4840593          	addi	a1,s0,-440
    80005566:	4505                	li	a0,1
    80005568:	e2afd0ef          	jal	80002b92 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000556c:	08000613          	li	a2,128
    80005570:	f5040593          	addi	a1,s0,-176
    80005574:	4501                	li	a0,0
    80005576:	e3afd0ef          	jal	80002bb0 <argstr>
    8000557a:	87aa                	mv	a5,a0
    return -1;
    8000557c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000557e:	0c07c463          	bltz	a5,80005646 <sys_exec+0xec>
    80005582:	f726                	sd	s1,424(sp)
    80005584:	f34a                	sd	s2,416(sp)
    80005586:	ef4e                	sd	s3,408(sp)
    80005588:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000558a:	10000613          	li	a2,256
    8000558e:	4581                	li	a1,0
    80005590:	e5040513          	addi	a0,s0,-432
    80005594:	f42fb0ef          	jal	80000cd6 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005598:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000559c:	89a6                	mv	s3,s1
    8000559e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800055a0:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800055a4:	00391513          	slli	a0,s2,0x3
    800055a8:	e4040593          	addi	a1,s0,-448
    800055ac:	e4843783          	ld	a5,-440(s0)
    800055b0:	953e                	add	a0,a0,a5
    800055b2:	d3afd0ef          	jal	80002aec <fetchaddr>
    800055b6:	02054663          	bltz	a0,800055e2 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800055ba:	e4043783          	ld	a5,-448(s0)
    800055be:	c3a9                	beqz	a5,80005600 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800055c0:	d72fb0ef          	jal	80000b32 <kalloc>
    800055c4:	85aa                	mv	a1,a0
    800055c6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800055ca:	cd01                	beqz	a0,800055e2 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800055cc:	6605                	lui	a2,0x1
    800055ce:	e4043503          	ld	a0,-448(s0)
    800055d2:	d64fd0ef          	jal	80002b36 <fetchstr>
    800055d6:	00054663          	bltz	a0,800055e2 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800055da:	0905                	addi	s2,s2,1
    800055dc:	09a1                	addi	s3,s3,8
    800055de:	fd4913e3          	bne	s2,s4,800055a4 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800055e2:	f5040913          	addi	s2,s0,-176
    800055e6:	6088                	ld	a0,0(s1)
    800055e8:	c931                	beqz	a0,8000563c <sys_exec+0xe2>
    kfree(argv[i]);
    800055ea:	c66fb0ef          	jal	80000a50 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800055ee:	04a1                	addi	s1,s1,8
    800055f0:	ff249be3          	bne	s1,s2,800055e6 <sys_exec+0x8c>
  return -1;
    800055f4:	557d                	li	a0,-1
    800055f6:	74ba                	ld	s1,424(sp)
    800055f8:	791a                	ld	s2,416(sp)
    800055fa:	69fa                	ld	s3,408(sp)
    800055fc:	6a5a                	ld	s4,400(sp)
    800055fe:	a0a1                	j	80005646 <sys_exec+0xec>
      argv[i] = 0;
    80005600:	0009079b          	sext.w	a5,s2
    80005604:	078e                	slli	a5,a5,0x3
    80005606:	fd078793          	addi	a5,a5,-48
    8000560a:	97a2                	add	a5,a5,s0
    8000560c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005610:	e5040593          	addi	a1,s0,-432
    80005614:	f5040513          	addi	a0,s0,-176
    80005618:	ba8ff0ef          	jal	800049c0 <exec>
    8000561c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000561e:	f5040993          	addi	s3,s0,-176
    80005622:	6088                	ld	a0,0(s1)
    80005624:	c511                	beqz	a0,80005630 <sys_exec+0xd6>
    kfree(argv[i]);
    80005626:	c2afb0ef          	jal	80000a50 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000562a:	04a1                	addi	s1,s1,8
    8000562c:	ff349be3          	bne	s1,s3,80005622 <sys_exec+0xc8>
  return ret;
    80005630:	854a                	mv	a0,s2
    80005632:	74ba                	ld	s1,424(sp)
    80005634:	791a                	ld	s2,416(sp)
    80005636:	69fa                	ld	s3,408(sp)
    80005638:	6a5a                	ld	s4,400(sp)
    8000563a:	a031                	j	80005646 <sys_exec+0xec>
  return -1;
    8000563c:	557d                	li	a0,-1
    8000563e:	74ba                	ld	s1,424(sp)
    80005640:	791a                	ld	s2,416(sp)
    80005642:	69fa                	ld	s3,408(sp)
    80005644:	6a5a                	ld	s4,400(sp)
}
    80005646:	70fa                	ld	ra,440(sp)
    80005648:	745a                	ld	s0,432(sp)
    8000564a:	6139                	addi	sp,sp,448
    8000564c:	8082                	ret

000000008000564e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000564e:	7139                	addi	sp,sp,-64
    80005650:	fc06                	sd	ra,56(sp)
    80005652:	f822                	sd	s0,48(sp)
    80005654:	f426                	sd	s1,40(sp)
    80005656:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005658:	abafc0ef          	jal	80001912 <myproc>
    8000565c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000565e:	fd840593          	addi	a1,s0,-40
    80005662:	4501                	li	a0,0
    80005664:	d2efd0ef          	jal	80002b92 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005668:	fc840593          	addi	a1,s0,-56
    8000566c:	fd040513          	addi	a0,s0,-48
    80005670:	85cff0ef          	jal	800046cc <pipealloc>
    return -1;
    80005674:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005676:	0a054463          	bltz	a0,8000571e <sys_pipe+0xd0>
  fd0 = -1;
    8000567a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000567e:	fd043503          	ld	a0,-48(s0)
    80005682:	f08ff0ef          	jal	80004d8a <fdalloc>
    80005686:	fca42223          	sw	a0,-60(s0)
    8000568a:	08054163          	bltz	a0,8000570c <sys_pipe+0xbe>
    8000568e:	fc843503          	ld	a0,-56(s0)
    80005692:	ef8ff0ef          	jal	80004d8a <fdalloc>
    80005696:	fca42023          	sw	a0,-64(s0)
    8000569a:	06054063          	bltz	a0,800056fa <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000569e:	4691                	li	a3,4
    800056a0:	fc440613          	addi	a2,s0,-60
    800056a4:	fd843583          	ld	a1,-40(s0)
    800056a8:	68a8                	ld	a0,80(s1)
    800056aa:	edbfb0ef          	jal	80001584 <copyout>
    800056ae:	00054e63          	bltz	a0,800056ca <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800056b2:	4691                	li	a3,4
    800056b4:	fc040613          	addi	a2,s0,-64
    800056b8:	fd843583          	ld	a1,-40(s0)
    800056bc:	0591                	addi	a1,a1,4
    800056be:	68a8                	ld	a0,80(s1)
    800056c0:	ec5fb0ef          	jal	80001584 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800056c4:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800056c6:	04055c63          	bgez	a0,8000571e <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800056ca:	fc442783          	lw	a5,-60(s0)
    800056ce:	07e9                	addi	a5,a5,26
    800056d0:	078e                	slli	a5,a5,0x3
    800056d2:	97a6                	add	a5,a5,s1
    800056d4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800056d8:	fc042783          	lw	a5,-64(s0)
    800056dc:	07e9                	addi	a5,a5,26
    800056de:	078e                	slli	a5,a5,0x3
    800056e0:	94be                	add	s1,s1,a5
    800056e2:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800056e6:	fd043503          	ld	a0,-48(s0)
    800056ea:	cd9fe0ef          	jal	800043c2 <fileclose>
    fileclose(wf);
    800056ee:	fc843503          	ld	a0,-56(s0)
    800056f2:	cd1fe0ef          	jal	800043c2 <fileclose>
    return -1;
    800056f6:	57fd                	li	a5,-1
    800056f8:	a01d                	j	8000571e <sys_pipe+0xd0>
    if(fd0 >= 0)
    800056fa:	fc442783          	lw	a5,-60(s0)
    800056fe:	0007c763          	bltz	a5,8000570c <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005702:	07e9                	addi	a5,a5,26
    80005704:	078e                	slli	a5,a5,0x3
    80005706:	97a6                	add	a5,a5,s1
    80005708:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000570c:	fd043503          	ld	a0,-48(s0)
    80005710:	cb3fe0ef          	jal	800043c2 <fileclose>
    fileclose(wf);
    80005714:	fc843503          	ld	a0,-56(s0)
    80005718:	cabfe0ef          	jal	800043c2 <fileclose>
    return -1;
    8000571c:	57fd                	li	a5,-1
}
    8000571e:	853e                	mv	a0,a5
    80005720:	70e2                	ld	ra,56(sp)
    80005722:	7442                	ld	s0,48(sp)
    80005724:	74a2                	ld	s1,40(sp)
    80005726:	6121                	addi	sp,sp,64
    80005728:	8082                	ret
    8000572a:	0000                	unimp
    8000572c:	0000                	unimp
	...

0000000080005730 <kernelvec>:
    80005730:	7111                	addi	sp,sp,-256
    80005732:	e006                	sd	ra,0(sp)
    80005734:	e40a                	sd	sp,8(sp)
    80005736:	e80e                	sd	gp,16(sp)
    80005738:	ec12                	sd	tp,24(sp)
    8000573a:	f016                	sd	t0,32(sp)
    8000573c:	f41a                	sd	t1,40(sp)
    8000573e:	f81e                	sd	t2,48(sp)
    80005740:	e4aa                	sd	a0,72(sp)
    80005742:	e8ae                	sd	a1,80(sp)
    80005744:	ecb2                	sd	a2,88(sp)
    80005746:	f0b6                	sd	a3,96(sp)
    80005748:	f4ba                	sd	a4,104(sp)
    8000574a:	f8be                	sd	a5,112(sp)
    8000574c:	fcc2                	sd	a6,120(sp)
    8000574e:	e146                	sd	a7,128(sp)
    80005750:	edf2                	sd	t3,216(sp)
    80005752:	f1f6                	sd	t4,224(sp)
    80005754:	f5fa                	sd	t5,232(sp)
    80005756:	f9fe                	sd	t6,240(sp)
    80005758:	aa4fd0ef          	jal	800029fc <kerneltrap>
    8000575c:	6082                	ld	ra,0(sp)
    8000575e:	6122                	ld	sp,8(sp)
    80005760:	61c2                	ld	gp,16(sp)
    80005762:	7282                	ld	t0,32(sp)
    80005764:	7322                	ld	t1,40(sp)
    80005766:	73c2                	ld	t2,48(sp)
    80005768:	6526                	ld	a0,72(sp)
    8000576a:	65c6                	ld	a1,80(sp)
    8000576c:	6666                	ld	a2,88(sp)
    8000576e:	7686                	ld	a3,96(sp)
    80005770:	7726                	ld	a4,104(sp)
    80005772:	77c6                	ld	a5,112(sp)
    80005774:	7866                	ld	a6,120(sp)
    80005776:	688a                	ld	a7,128(sp)
    80005778:	6e6e                	ld	t3,216(sp)
    8000577a:	7e8e                	ld	t4,224(sp)
    8000577c:	7f2e                	ld	t5,232(sp)
    8000577e:	7fce                	ld	t6,240(sp)
    80005780:	6111                	addi	sp,sp,256
    80005782:	10200073          	sret
	...

000000008000578e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000578e:	1141                	addi	sp,sp,-16
    80005790:	e422                	sd	s0,8(sp)
    80005792:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005794:	0c0007b7          	lui	a5,0xc000
    80005798:	4705                	li	a4,1
    8000579a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000579c:	0c0007b7          	lui	a5,0xc000
    800057a0:	c3d8                	sw	a4,4(a5)
}
    800057a2:	6422                	ld	s0,8(sp)
    800057a4:	0141                	addi	sp,sp,16
    800057a6:	8082                	ret

00000000800057a8 <plicinithart>:

void
plicinithart(void)
{
    800057a8:	1141                	addi	sp,sp,-16
    800057aa:	e406                	sd	ra,8(sp)
    800057ac:	e022                	sd	s0,0(sp)
    800057ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800057b0:	936fc0ef          	jal	800018e6 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800057b4:	0085171b          	slliw	a4,a0,0x8
    800057b8:	0c0027b7          	lui	a5,0xc002
    800057bc:	97ba                	add	a5,a5,a4
    800057be:	40200713          	li	a4,1026
    800057c2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800057c6:	00d5151b          	slliw	a0,a0,0xd
    800057ca:	0c2017b7          	lui	a5,0xc201
    800057ce:	97aa                	add	a5,a5,a0
    800057d0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800057d4:	60a2                	ld	ra,8(sp)
    800057d6:	6402                	ld	s0,0(sp)
    800057d8:	0141                	addi	sp,sp,16
    800057da:	8082                	ret

00000000800057dc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800057dc:	1141                	addi	sp,sp,-16
    800057de:	e406                	sd	ra,8(sp)
    800057e0:	e022                	sd	s0,0(sp)
    800057e2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800057e4:	902fc0ef          	jal	800018e6 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800057e8:	00d5151b          	slliw	a0,a0,0xd
    800057ec:	0c2017b7          	lui	a5,0xc201
    800057f0:	97aa                	add	a5,a5,a0
  return irq;
}
    800057f2:	43c8                	lw	a0,4(a5)
    800057f4:	60a2                	ld	ra,8(sp)
    800057f6:	6402                	ld	s0,0(sp)
    800057f8:	0141                	addi	sp,sp,16
    800057fa:	8082                	ret

00000000800057fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800057fc:	1101                	addi	sp,sp,-32
    800057fe:	ec06                	sd	ra,24(sp)
    80005800:	e822                	sd	s0,16(sp)
    80005802:	e426                	sd	s1,8(sp)
    80005804:	1000                	addi	s0,sp,32
    80005806:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005808:	8defc0ef          	jal	800018e6 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000580c:	00d5151b          	slliw	a0,a0,0xd
    80005810:	0c2017b7          	lui	a5,0xc201
    80005814:	97aa                	add	a5,a5,a0
    80005816:	c3c4                	sw	s1,4(a5)
}
    80005818:	60e2                	ld	ra,24(sp)
    8000581a:	6442                	ld	s0,16(sp)
    8000581c:	64a2                	ld	s1,8(sp)
    8000581e:	6105                	addi	sp,sp,32
    80005820:	8082                	ret

0000000080005822 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005822:	1141                	addi	sp,sp,-16
    80005824:	e406                	sd	ra,8(sp)
    80005826:	e022                	sd	s0,0(sp)
    80005828:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000582a:	479d                	li	a5,7
    8000582c:	04a7ca63          	blt	a5,a0,80005880 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005830:	0001e797          	auipc	a5,0x1e
    80005834:	51078793          	addi	a5,a5,1296 # 80023d40 <disk>
    80005838:	97aa                	add	a5,a5,a0
    8000583a:	0187c783          	lbu	a5,24(a5)
    8000583e:	e7b9                	bnez	a5,8000588c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005840:	00451693          	slli	a3,a0,0x4
    80005844:	0001e797          	auipc	a5,0x1e
    80005848:	4fc78793          	addi	a5,a5,1276 # 80023d40 <disk>
    8000584c:	6398                	ld	a4,0(a5)
    8000584e:	9736                	add	a4,a4,a3
    80005850:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005854:	6398                	ld	a4,0(a5)
    80005856:	9736                	add	a4,a4,a3
    80005858:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000585c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005860:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005864:	97aa                	add	a5,a5,a0
    80005866:	4705                	li	a4,1
    80005868:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000586c:	0001e517          	auipc	a0,0x1e
    80005870:	4ec50513          	addi	a0,a0,1260 # 80023d58 <disk+0x18>
    80005874:	a49fc0ef          	jal	800022bc <wakeup>
}
    80005878:	60a2                	ld	ra,8(sp)
    8000587a:	6402                	ld	s0,0(sp)
    8000587c:	0141                	addi	sp,sp,16
    8000587e:	8082                	ret
    panic("free_desc 1");
    80005880:	00002517          	auipc	a0,0x2
    80005884:	e0050513          	addi	a0,a0,-512 # 80007680 <etext+0x680>
    80005888:	f1bfa0ef          	jal	800007a2 <panic>
    panic("free_desc 2");
    8000588c:	00002517          	auipc	a0,0x2
    80005890:	e0450513          	addi	a0,a0,-508 # 80007690 <etext+0x690>
    80005894:	f0ffa0ef          	jal	800007a2 <panic>

0000000080005898 <virtio_disk_init>:
{
    80005898:	1101                	addi	sp,sp,-32
    8000589a:	ec06                	sd	ra,24(sp)
    8000589c:	e822                	sd	s0,16(sp)
    8000589e:	e426                	sd	s1,8(sp)
    800058a0:	e04a                	sd	s2,0(sp)
    800058a2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800058a4:	00002597          	auipc	a1,0x2
    800058a8:	dfc58593          	addi	a1,a1,-516 # 800076a0 <etext+0x6a0>
    800058ac:	0001e517          	auipc	a0,0x1e
    800058b0:	5bc50513          	addi	a0,a0,1468 # 80023e68 <disk+0x128>
    800058b4:	acefb0ef          	jal	80000b82 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800058b8:	100017b7          	lui	a5,0x10001
    800058bc:	4398                	lw	a4,0(a5)
    800058be:	2701                	sext.w	a4,a4
    800058c0:	747277b7          	lui	a5,0x74727
    800058c4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800058c8:	18f71063          	bne	a4,a5,80005a48 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800058cc:	100017b7          	lui	a5,0x10001
    800058d0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800058d2:	439c                	lw	a5,0(a5)
    800058d4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800058d6:	4709                	li	a4,2
    800058d8:	16e79863          	bne	a5,a4,80005a48 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800058dc:	100017b7          	lui	a5,0x10001
    800058e0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800058e2:	439c                	lw	a5,0(a5)
    800058e4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800058e6:	16e79163          	bne	a5,a4,80005a48 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800058ea:	100017b7          	lui	a5,0x10001
    800058ee:	47d8                	lw	a4,12(a5)
    800058f0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800058f2:	554d47b7          	lui	a5,0x554d4
    800058f6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800058fa:	14f71763          	bne	a4,a5,80005a48 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800058fe:	100017b7          	lui	a5,0x10001
    80005902:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005906:	4705                	li	a4,1
    80005908:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000590a:	470d                	li	a4,3
    8000590c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000590e:	10001737          	lui	a4,0x10001
    80005912:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005914:	c7ffe737          	lui	a4,0xc7ffe
    80005918:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fda8df>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000591c:	8ef9                	and	a3,a3,a4
    8000591e:	10001737          	lui	a4,0x10001
    80005922:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005924:	472d                	li	a4,11
    80005926:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005928:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000592c:	439c                	lw	a5,0(a5)
    8000592e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005932:	8ba1                	andi	a5,a5,8
    80005934:	12078063          	beqz	a5,80005a54 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005938:	100017b7          	lui	a5,0x10001
    8000593c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005940:	100017b7          	lui	a5,0x10001
    80005944:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005948:	439c                	lw	a5,0(a5)
    8000594a:	2781                	sext.w	a5,a5
    8000594c:	10079a63          	bnez	a5,80005a60 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005950:	100017b7          	lui	a5,0x10001
    80005954:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005958:	439c                	lw	a5,0(a5)
    8000595a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000595c:	10078863          	beqz	a5,80005a6c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005960:	471d                	li	a4,7
    80005962:	10f77b63          	bgeu	a4,a5,80005a78 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005966:	9ccfb0ef          	jal	80000b32 <kalloc>
    8000596a:	0001e497          	auipc	s1,0x1e
    8000596e:	3d648493          	addi	s1,s1,982 # 80023d40 <disk>
    80005972:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005974:	9befb0ef          	jal	80000b32 <kalloc>
    80005978:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000597a:	9b8fb0ef          	jal	80000b32 <kalloc>
    8000597e:	87aa                	mv	a5,a0
    80005980:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005982:	6088                	ld	a0,0(s1)
    80005984:	10050063          	beqz	a0,80005a84 <virtio_disk_init+0x1ec>
    80005988:	0001e717          	auipc	a4,0x1e
    8000598c:	3c073703          	ld	a4,960(a4) # 80023d48 <disk+0x8>
    80005990:	0e070a63          	beqz	a4,80005a84 <virtio_disk_init+0x1ec>
    80005994:	0e078863          	beqz	a5,80005a84 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005998:	6605                	lui	a2,0x1
    8000599a:	4581                	li	a1,0
    8000599c:	b3afb0ef          	jal	80000cd6 <memset>
  memset(disk.avail, 0, PGSIZE);
    800059a0:	0001e497          	auipc	s1,0x1e
    800059a4:	3a048493          	addi	s1,s1,928 # 80023d40 <disk>
    800059a8:	6605                	lui	a2,0x1
    800059aa:	4581                	li	a1,0
    800059ac:	6488                	ld	a0,8(s1)
    800059ae:	b28fb0ef          	jal	80000cd6 <memset>
  memset(disk.used, 0, PGSIZE);
    800059b2:	6605                	lui	a2,0x1
    800059b4:	4581                	li	a1,0
    800059b6:	6888                	ld	a0,16(s1)
    800059b8:	b1efb0ef          	jal	80000cd6 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800059bc:	100017b7          	lui	a5,0x10001
    800059c0:	4721                	li	a4,8
    800059c2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800059c4:	4098                	lw	a4,0(s1)
    800059c6:	100017b7          	lui	a5,0x10001
    800059ca:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800059ce:	40d8                	lw	a4,4(s1)
    800059d0:	100017b7          	lui	a5,0x10001
    800059d4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800059d8:	649c                	ld	a5,8(s1)
    800059da:	0007869b          	sext.w	a3,a5
    800059de:	10001737          	lui	a4,0x10001
    800059e2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800059e6:	9781                	srai	a5,a5,0x20
    800059e8:	10001737          	lui	a4,0x10001
    800059ec:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800059f0:	689c                	ld	a5,16(s1)
    800059f2:	0007869b          	sext.w	a3,a5
    800059f6:	10001737          	lui	a4,0x10001
    800059fa:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800059fe:	9781                	srai	a5,a5,0x20
    80005a00:	10001737          	lui	a4,0x10001
    80005a04:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005a08:	10001737          	lui	a4,0x10001
    80005a0c:	4785                	li	a5,1
    80005a0e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005a10:	00f48c23          	sb	a5,24(s1)
    80005a14:	00f48ca3          	sb	a5,25(s1)
    80005a18:	00f48d23          	sb	a5,26(s1)
    80005a1c:	00f48da3          	sb	a5,27(s1)
    80005a20:	00f48e23          	sb	a5,28(s1)
    80005a24:	00f48ea3          	sb	a5,29(s1)
    80005a28:	00f48f23          	sb	a5,30(s1)
    80005a2c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005a30:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a34:	100017b7          	lui	a5,0x10001
    80005a38:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80005a3c:	60e2                	ld	ra,24(sp)
    80005a3e:	6442                	ld	s0,16(sp)
    80005a40:	64a2                	ld	s1,8(sp)
    80005a42:	6902                	ld	s2,0(sp)
    80005a44:	6105                	addi	sp,sp,32
    80005a46:	8082                	ret
    panic("could not find virtio disk");
    80005a48:	00002517          	auipc	a0,0x2
    80005a4c:	c6850513          	addi	a0,a0,-920 # 800076b0 <etext+0x6b0>
    80005a50:	d53fa0ef          	jal	800007a2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005a54:	00002517          	auipc	a0,0x2
    80005a58:	c7c50513          	addi	a0,a0,-900 # 800076d0 <etext+0x6d0>
    80005a5c:	d47fa0ef          	jal	800007a2 <panic>
    panic("virtio disk should not be ready");
    80005a60:	00002517          	auipc	a0,0x2
    80005a64:	c9050513          	addi	a0,a0,-880 # 800076f0 <etext+0x6f0>
    80005a68:	d3bfa0ef          	jal	800007a2 <panic>
    panic("virtio disk has no queue 0");
    80005a6c:	00002517          	auipc	a0,0x2
    80005a70:	ca450513          	addi	a0,a0,-860 # 80007710 <etext+0x710>
    80005a74:	d2ffa0ef          	jal	800007a2 <panic>
    panic("virtio disk max queue too short");
    80005a78:	00002517          	auipc	a0,0x2
    80005a7c:	cb850513          	addi	a0,a0,-840 # 80007730 <etext+0x730>
    80005a80:	d23fa0ef          	jal	800007a2 <panic>
    panic("virtio disk kalloc");
    80005a84:	00002517          	auipc	a0,0x2
    80005a88:	ccc50513          	addi	a0,a0,-820 # 80007750 <etext+0x750>
    80005a8c:	d17fa0ef          	jal	800007a2 <panic>

0000000080005a90 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005a90:	7159                	addi	sp,sp,-112
    80005a92:	f486                	sd	ra,104(sp)
    80005a94:	f0a2                	sd	s0,96(sp)
    80005a96:	eca6                	sd	s1,88(sp)
    80005a98:	e8ca                	sd	s2,80(sp)
    80005a9a:	e4ce                	sd	s3,72(sp)
    80005a9c:	e0d2                	sd	s4,64(sp)
    80005a9e:	fc56                	sd	s5,56(sp)
    80005aa0:	f85a                	sd	s6,48(sp)
    80005aa2:	f45e                	sd	s7,40(sp)
    80005aa4:	f062                	sd	s8,32(sp)
    80005aa6:	ec66                	sd	s9,24(sp)
    80005aa8:	1880                	addi	s0,sp,112
    80005aaa:	8a2a                	mv	s4,a0
    80005aac:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005aae:	00c52c83          	lw	s9,12(a0)
    80005ab2:	001c9c9b          	slliw	s9,s9,0x1
    80005ab6:	1c82                	slli	s9,s9,0x20
    80005ab8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005abc:	0001e517          	auipc	a0,0x1e
    80005ac0:	3ac50513          	addi	a0,a0,940 # 80023e68 <disk+0x128>
    80005ac4:	93efb0ef          	jal	80000c02 <acquire>
  for(int i = 0; i < 3; i++){
    80005ac8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005aca:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005acc:	0001eb17          	auipc	s6,0x1e
    80005ad0:	274b0b13          	addi	s6,s6,628 # 80023d40 <disk>
  for(int i = 0; i < 3; i++){
    80005ad4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005ad6:	0001ec17          	auipc	s8,0x1e
    80005ada:	392c0c13          	addi	s8,s8,914 # 80023e68 <disk+0x128>
    80005ade:	a8b9                	j	80005b3c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005ae0:	00fb0733          	add	a4,s6,a5
    80005ae4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005ae8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005aea:	0207c563          	bltz	a5,80005b14 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005aee:	2905                	addiw	s2,s2,1
    80005af0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005af2:	05590963          	beq	s2,s5,80005b44 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005af6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005af8:	0001e717          	auipc	a4,0x1e
    80005afc:	24870713          	addi	a4,a4,584 # 80023d40 <disk>
    80005b00:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005b02:	01874683          	lbu	a3,24(a4)
    80005b06:	fee9                	bnez	a3,80005ae0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005b08:	2785                	addiw	a5,a5,1
    80005b0a:	0705                	addi	a4,a4,1
    80005b0c:	fe979be3          	bne	a5,s1,80005b02 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005b10:	57fd                	li	a5,-1
    80005b12:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005b14:	01205d63          	blez	s2,80005b2e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005b18:	f9042503          	lw	a0,-112(s0)
    80005b1c:	d07ff0ef          	jal	80005822 <free_desc>
      for(int j = 0; j < i; j++)
    80005b20:	4785                	li	a5,1
    80005b22:	0127d663          	bge	a5,s2,80005b2e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005b26:	f9442503          	lw	a0,-108(s0)
    80005b2a:	cf9ff0ef          	jal	80005822 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005b2e:	85e2                	mv	a1,s8
    80005b30:	0001e517          	auipc	a0,0x1e
    80005b34:	22850513          	addi	a0,a0,552 # 80023d58 <disk+0x18>
    80005b38:	dd8fc0ef          	jal	80002110 <sleep>
  for(int i = 0; i < 3; i++){
    80005b3c:	f9040613          	addi	a2,s0,-112
    80005b40:	894e                	mv	s2,s3
    80005b42:	bf55                	j	80005af6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005b44:	f9042503          	lw	a0,-112(s0)
    80005b48:	00451693          	slli	a3,a0,0x4

  if(write)
    80005b4c:	0001e797          	auipc	a5,0x1e
    80005b50:	1f478793          	addi	a5,a5,500 # 80023d40 <disk>
    80005b54:	00a50713          	addi	a4,a0,10
    80005b58:	0712                	slli	a4,a4,0x4
    80005b5a:	973e                	add	a4,a4,a5
    80005b5c:	01703633          	snez	a2,s7
    80005b60:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005b62:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005b66:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005b6a:	6398                	ld	a4,0(a5)
    80005b6c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005b6e:	0a868613          	addi	a2,a3,168
    80005b72:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005b74:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005b76:	6390                	ld	a2,0(a5)
    80005b78:	00d605b3          	add	a1,a2,a3
    80005b7c:	4741                	li	a4,16
    80005b7e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005b80:	4805                	li	a6,1
    80005b82:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005b86:	f9442703          	lw	a4,-108(s0)
    80005b8a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005b8e:	0712                	slli	a4,a4,0x4
    80005b90:	963a                	add	a2,a2,a4
    80005b92:	058a0593          	addi	a1,s4,88
    80005b96:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005b98:	0007b883          	ld	a7,0(a5)
    80005b9c:	9746                	add	a4,a4,a7
    80005b9e:	40000613          	li	a2,1024
    80005ba2:	c710                	sw	a2,8(a4)
  if(write)
    80005ba4:	001bb613          	seqz	a2,s7
    80005ba8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005bac:	00166613          	ori	a2,a2,1
    80005bb0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005bb4:	f9842583          	lw	a1,-104(s0)
    80005bb8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005bbc:	00250613          	addi	a2,a0,2
    80005bc0:	0612                	slli	a2,a2,0x4
    80005bc2:	963e                	add	a2,a2,a5
    80005bc4:	577d                	li	a4,-1
    80005bc6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005bca:	0592                	slli	a1,a1,0x4
    80005bcc:	98ae                	add	a7,a7,a1
    80005bce:	03068713          	addi	a4,a3,48
    80005bd2:	973e                	add	a4,a4,a5
    80005bd4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005bd8:	6398                	ld	a4,0(a5)
    80005bda:	972e                	add	a4,a4,a1
    80005bdc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005be0:	4689                	li	a3,2
    80005be2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005be6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005bea:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005bee:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005bf2:	6794                	ld	a3,8(a5)
    80005bf4:	0026d703          	lhu	a4,2(a3)
    80005bf8:	8b1d                	andi	a4,a4,7
    80005bfa:	0706                	slli	a4,a4,0x1
    80005bfc:	96ba                	add	a3,a3,a4
    80005bfe:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005c02:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005c06:	6798                	ld	a4,8(a5)
    80005c08:	00275783          	lhu	a5,2(a4)
    80005c0c:	2785                	addiw	a5,a5,1
    80005c0e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005c12:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005c16:	100017b7          	lui	a5,0x10001
    80005c1a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005c1e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005c22:	0001e917          	auipc	s2,0x1e
    80005c26:	24690913          	addi	s2,s2,582 # 80023e68 <disk+0x128>
  while(b->disk == 1) {
    80005c2a:	4485                	li	s1,1
    80005c2c:	01079a63          	bne	a5,a6,80005c40 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005c30:	85ca                	mv	a1,s2
    80005c32:	8552                	mv	a0,s4
    80005c34:	cdcfc0ef          	jal	80002110 <sleep>
  while(b->disk == 1) {
    80005c38:	004a2783          	lw	a5,4(s4)
    80005c3c:	fe978ae3          	beq	a5,s1,80005c30 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005c40:	f9042903          	lw	s2,-112(s0)
    80005c44:	00290713          	addi	a4,s2,2
    80005c48:	0712                	slli	a4,a4,0x4
    80005c4a:	0001e797          	auipc	a5,0x1e
    80005c4e:	0f678793          	addi	a5,a5,246 # 80023d40 <disk>
    80005c52:	97ba                	add	a5,a5,a4
    80005c54:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005c58:	0001e997          	auipc	s3,0x1e
    80005c5c:	0e898993          	addi	s3,s3,232 # 80023d40 <disk>
    80005c60:	00491713          	slli	a4,s2,0x4
    80005c64:	0009b783          	ld	a5,0(s3)
    80005c68:	97ba                	add	a5,a5,a4
    80005c6a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005c6e:	854a                	mv	a0,s2
    80005c70:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005c74:	bafff0ef          	jal	80005822 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005c78:	8885                	andi	s1,s1,1
    80005c7a:	f0fd                	bnez	s1,80005c60 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005c7c:	0001e517          	auipc	a0,0x1e
    80005c80:	1ec50513          	addi	a0,a0,492 # 80023e68 <disk+0x128>
    80005c84:	816fb0ef          	jal	80000c9a <release>
}
    80005c88:	70a6                	ld	ra,104(sp)
    80005c8a:	7406                	ld	s0,96(sp)
    80005c8c:	64e6                	ld	s1,88(sp)
    80005c8e:	6946                	ld	s2,80(sp)
    80005c90:	69a6                	ld	s3,72(sp)
    80005c92:	6a06                	ld	s4,64(sp)
    80005c94:	7ae2                	ld	s5,56(sp)
    80005c96:	7b42                	ld	s6,48(sp)
    80005c98:	7ba2                	ld	s7,40(sp)
    80005c9a:	7c02                	ld	s8,32(sp)
    80005c9c:	6ce2                	ld	s9,24(sp)
    80005c9e:	6165                	addi	sp,sp,112
    80005ca0:	8082                	ret

0000000080005ca2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005ca2:	1101                	addi	sp,sp,-32
    80005ca4:	ec06                	sd	ra,24(sp)
    80005ca6:	e822                	sd	s0,16(sp)
    80005ca8:	e426                	sd	s1,8(sp)
    80005caa:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005cac:	0001e497          	auipc	s1,0x1e
    80005cb0:	09448493          	addi	s1,s1,148 # 80023d40 <disk>
    80005cb4:	0001e517          	auipc	a0,0x1e
    80005cb8:	1b450513          	addi	a0,a0,436 # 80023e68 <disk+0x128>
    80005cbc:	f47fa0ef          	jal	80000c02 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005cc0:	100017b7          	lui	a5,0x10001
    80005cc4:	53b8                	lw	a4,96(a5)
    80005cc6:	8b0d                	andi	a4,a4,3
    80005cc8:	100017b7          	lui	a5,0x10001
    80005ccc:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005cce:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005cd2:	689c                	ld	a5,16(s1)
    80005cd4:	0204d703          	lhu	a4,32(s1)
    80005cd8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005cdc:	04f70663          	beq	a4,a5,80005d28 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005ce0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005ce4:	6898                	ld	a4,16(s1)
    80005ce6:	0204d783          	lhu	a5,32(s1)
    80005cea:	8b9d                	andi	a5,a5,7
    80005cec:	078e                	slli	a5,a5,0x3
    80005cee:	97ba                	add	a5,a5,a4
    80005cf0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005cf2:	00278713          	addi	a4,a5,2
    80005cf6:	0712                	slli	a4,a4,0x4
    80005cf8:	9726                	add	a4,a4,s1
    80005cfa:	01074703          	lbu	a4,16(a4)
    80005cfe:	e321                	bnez	a4,80005d3e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005d00:	0789                	addi	a5,a5,2
    80005d02:	0792                	slli	a5,a5,0x4
    80005d04:	97a6                	add	a5,a5,s1
    80005d06:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005d08:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005d0c:	db0fc0ef          	jal	800022bc <wakeup>

    disk.used_idx += 1;
    80005d10:	0204d783          	lhu	a5,32(s1)
    80005d14:	2785                	addiw	a5,a5,1
    80005d16:	17c2                	slli	a5,a5,0x30
    80005d18:	93c1                	srli	a5,a5,0x30
    80005d1a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005d1e:	6898                	ld	a4,16(s1)
    80005d20:	00275703          	lhu	a4,2(a4)
    80005d24:	faf71ee3          	bne	a4,a5,80005ce0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005d28:	0001e517          	auipc	a0,0x1e
    80005d2c:	14050513          	addi	a0,a0,320 # 80023e68 <disk+0x128>
    80005d30:	f6bfa0ef          	jal	80000c9a <release>
}
    80005d34:	60e2                	ld	ra,24(sp)
    80005d36:	6442                	ld	s0,16(sp)
    80005d38:	64a2                	ld	s1,8(sp)
    80005d3a:	6105                	addi	sp,sp,32
    80005d3c:	8082                	ret
      panic("virtio_disk_intr status");
    80005d3e:	00002517          	auipc	a0,0x2
    80005d42:	a2a50513          	addi	a0,a0,-1494 # 80007768 <etext+0x768>
    80005d46:	a5dfa0ef          	jal	800007a2 <panic>

0000000080005d4a <sys_random>:
 
//Random
static unsigned int lcg_state=1; //PRNG state
uint64
sys_random(void)
{
    80005d4a:	1141                	addi	sp,sp,-16
    80005d4c:	e422                	sd	s0,8(sp)
    80005d4e:	0800                	addi	s0,sp,16
  // Seed only once using ticks (global variable provided by xv6)
  extern uint ticks;
  if (lcg_state == 1)
    80005d50:	00004717          	auipc	a4,0x4
    80005d54:	74c72703          	lw	a4,1868(a4) # 8000a49c <lcg_state>
    80005d58:	4785                	li	a5,1
    80005d5a:	02f70763          	beq	a4,a5,80005d88 <sys_random+0x3e>
    lcg_state = ticks + 1;  // avoid 0 seed

  // LCG formula
  lcg_state = (1103515245 * lcg_state + 12345) & 0x7fffffff;
    80005d5e:	00004717          	auipc	a4,0x4
    80005d62:	73e70713          	addi	a4,a4,1854 # 8000a49c <lcg_state>
    80005d66:	4314                	lw	a3,0(a4)
    80005d68:	41c657b7          	lui	a5,0x41c65
    80005d6c:	e6d7879b          	addiw	a5,a5,-403 # 41c64e6d <_entry-0x3e39b193>
    80005d70:	02d7853b          	mulw	a0,a5,a3
    80005d74:	678d                	lui	a5,0x3
    80005d76:	0397879b          	addiw	a5,a5,57 # 3039 <_entry-0x7fffcfc7>
    80005d7a:	9d3d                	addw	a0,a0,a5
    80005d7c:	1506                	slli	a0,a0,0x21
    80005d7e:	9105                	srli	a0,a0,0x21
    80005d80:	c308                	sw	a0,0(a4)

  return lcg_state;
}
    80005d82:	6422                	ld	s0,8(sp)
    80005d84:	0141                	addi	sp,sp,16
    80005d86:	8082                	ret
    lcg_state = ticks + 1;  // avoid 0 seed
    80005d88:	00004797          	auipc	a5,0x4
    80005d8c:	7b07a783          	lw	a5,1968(a5) # 8000a538 <ticks>
    80005d90:	2785                	addiw	a5,a5,1
    80005d92:	00004717          	auipc	a4,0x4
    80005d96:	70f72523          	sw	a5,1802(a4) # 8000a49c <lcg_state>
    80005d9a:	b7d1                	j	80005d5e <sys_random+0x14>

0000000080005d9c <sys_datetime>:
  r->day = (int)day;
}

uint64
sys_datetime(void)
{
    80005d9c:	7179                	addi	sp,sp,-48
    80005d9e:	f406                	sd	ra,40(sp)
    80005da0:	f022                	sd	s0,32(sp)
    80005da2:	1800                	addi	s0,sp,48
  uint64 user_addr;
  struct rtcdate rd;

  // get user pointer argument 0
  if(argaddr(0, &user_addr) < 0)
    80005da4:	fe840593          	addi	a1,s0,-24
    80005da8:	4501                	li	a0,0
    80005daa:	de9fc0ef          	jal	80002b92 <argaddr>
    80005dae:	87aa                	mv	a5,a0
    return -1;
    80005db0:	557d                	li	a0,-1
  if(argaddr(0, &user_addr) < 0)
    80005db2:	1207c363          	bltz	a5,80005ed8 <sys_datetime+0x13c>

 volatile uint64 *mtime = (volatile uint64 *)CLINT_MTIME;
 uint64 mtime_val = *mtime;   // increments in cycles / platform timeunits
    80005db6:	0200c7b7          	lui	a5,0x200c
    80005dba:	ff87b703          	ld	a4,-8(a5) # 200bff8 <_entry-0x7dff4008>
// Now convert to seconds. The conversion constant depends on the platform's mtime frequency.
// On QEMU virt, mtime increments at the host timer frequency used by the platform (platform dependent).

uint64 unix_secs = BOOT_EPOCH + (mtime_val / MTIME_FREQ);
    80005dbe:	009897b7          	lui	a5,0x989
    80005dc2:	68078793          	addi	a5,a5,1664 # 989680 <_entry-0x7f676980>
    80005dc6:	02f75733          	divu	a4,a4,a5


//TO adjust cairo 
unix_secs+=7200;
    80005dca:	693b07b7          	lui	a5,0x693b0
    80005dce:	02a78793          	addi	a5,a5,42 # 693b002a <_entry-0x16c4ffd6>
    80005dd2:	973e                	add	a4,a4,a5
  uint64 rem = secs % 86400;
    80005dd4:	66d5                	lui	a3,0x15
    80005dd6:	18068693          	addi	a3,a3,384 # 15180 <_entry-0x7ffeae80>
    80005dda:	02d777b3          	remu	a5,a4,a3
  r->hour = rem / 3600;
    80005dde:	6605                	lui	a2,0x1
    80005de0:	e1060613          	addi	a2,a2,-496 # e10 <_entry-0x7ffff1f0>
    80005de4:	02c7d5b3          	divu	a1,a5,a2
    80005de8:	fcb42c23          	sw	a1,-40(s0)
  rem %= 3600;
    80005dec:	02c7f7b3          	remu	a5,a5,a2
  r->minute = rem / 60;
    80005df0:	03c00613          	li	a2,60
    80005df4:	02c7d5b3          	divu	a1,a5,a2
    80005df8:	fcb42a23          	sw	a1,-44(s0)
  r->second = rem % 60;
    80005dfc:	02c7f7b3          	remu	a5,a5,a2
    80005e00:	fcf42823          	sw	a5,-48(s0)
  uint64 days = secs / 86400;
    80005e04:	02d75733          	divu	a4,a4,a3
  int64_t z = (int64_t)days + 719468; // shift to 0000-03-01 epoch used by algorithm
    80005e08:	000b07b7          	lui	a5,0xb0
    80005e0c:	a6c78793          	addi	a5,a5,-1428 # afa6c <_entry-0x7ff50594>
    80005e10:	973e                	add	a4,a4,a5
  int64_t era = (z >= 0 ? z : z - 146096) / 146097;
    80005e12:	000247b7          	lui	a5,0x24
    80005e16:	ab178793          	addi	a5,a5,-1359 # 23ab1 <_entry-0x7ffdc54f>
    80005e1a:	02f748b3          	div	a7,a4,a5
  unsigned doe = (unsigned)(z - era * 146097);          // [0, 146096]
    80005e1e:	02f887bb          	mulw	a5,a7,a5
    80005e22:	9f1d                	subw	a4,a4,a5
  unsigned yoe = (doe - doe/1460 + doe/36524 - doe/146096) / 365; // [0, 399]
    80005e24:	66a5                	lui	a3,0x9
    80005e26:	eac6869b          	addiw	a3,a3,-340 # 8eac <_entry-0x7fff7154>
    80005e2a:	02d756bb          	divuw	a3,a4,a3
    80005e2e:	9eb9                	addw	a3,a3,a4
    80005e30:	5b400813          	li	a6,1460
    80005e34:	030757bb          	divuw	a5,a4,a6
    80005e38:	9e9d                	subw	a3,a3,a5
    80005e3a:	000247b7          	lui	a5,0x24
    80005e3e:	ab07879b          	addiw	a5,a5,-1360 # 23ab0 <_entry-0x7ffdc550>
    80005e42:	02f757bb          	divuw	a5,a4,a5
    80005e46:	9e9d                	subw	a3,a3,a5
    80005e48:	16d00593          	li	a1,365
    80005e4c:	02b6d53b          	divuw	a0,a3,a1
  int year = (int)(yoe + era * 400);
    80005e50:	19000613          	li	a2,400
    80005e54:	0316063b          	mulw	a2,a2,a7
    80005e58:	9e29                	addw	a2,a2,a0
  unsigned doy = doe - (365*yoe + yoe/4 - yoe/100);     // [0, 365]
    80005e5a:	67a5                	lui	a5,0x9
    80005e5c:	e947879b          	addiw	a5,a5,-364 # 8e94 <_entry-0x7fff716c>
    80005e60:	02f6d7bb          	divuw	a5,a3,a5
    80005e64:	9fb9                	addw	a5,a5,a4
    80005e66:	0306d6bb          	divuw	a3,a3,a6
    80005e6a:	9f95                	subw	a5,a5,a3
    80005e6c:	02a585bb          	mulw	a1,a1,a0
    80005e70:	9f8d                	subw	a5,a5,a1
  unsigned mp = (5*doy + 2) / 153;                      // [0, 11]
    80005e72:	0027971b          	slliw	a4,a5,0x2
    80005e76:	9f3d                	addw	a4,a4,a5
    80005e78:	2709                	addiw	a4,a4,2
    80005e7a:	0007051b          	sext.w	a0,a4
    80005e7e:	09900693          	li	a3,153
    80005e82:	02d7573b          	divuw	a4,a4,a3
  unsigned day = doy - (153*mp+2)/5 + 1;                // [1, 31]
    80005e86:	2785                	addiw	a5,a5,1
    80005e88:	0037169b          	slliw	a3,a4,0x3
    80005e8c:	9eb9                	addw	a3,a3,a4
    80005e8e:	0046959b          	slliw	a1,a3,0x4
    80005e92:	9ead                	addw	a3,a3,a1
    80005e94:	2689                	addiw	a3,a3,2
    80005e96:	4595                	li	a1,5
    80005e98:	02b6d6bb          	divuw	a3,a3,a1
    80005e9c:	9f95                	subw	a5,a5,a3
  unsigned month = mp + (mp < 10 ? 3 : -9);             // [1, 12]
    80005e9e:	5f900593          	li	a1,1529
    80005ea2:	56dd                	li	a3,-9
    80005ea4:	00a5e363          	bltu	a1,a0,80005eaa <sys_datetime+0x10e>
    80005ea8:	468d                	li	a3,3
    80005eaa:	9f35                	addw	a4,a4,a3
    80005eac:	0007069b          	sext.w	a3,a4
  year += (month <= 2);
    80005eb0:	0036b693          	sltiu	a3,a3,3
    80005eb4:	9eb1                	addw	a3,a3,a2
  r->year = year;
    80005eb6:	fed42223          	sw	a3,-28(s0)
  r->month = (int)month;
    80005eba:	fee42023          	sw	a4,-32(s0)
  r->day = (int)day;
    80005ebe:	fcf42e23          	sw	a5,-36(s0)

  seconds_to_rtcdate(unix_secs, &rd);


  // copy to user space
  if(copyout(myproc()->pagetable, user_addr, (char *)&rd, sizeof(rd)) < 0)
    80005ec2:	a51fb0ef          	jal	80001912 <myproc>
    80005ec6:	46e1                	li	a3,24
    80005ec8:	fd040613          	addi	a2,s0,-48
    80005ecc:	fe843583          	ld	a1,-24(s0)
    80005ed0:	6928                	ld	a0,80(a0)
    80005ed2:	eb2fb0ef          	jal	80001584 <copyout>
    80005ed6:	957d                	srai	a0,a0,0x3f
    return -1;

  return 0;
}
    80005ed8:	70a2                	ld	ra,40(sp)
    80005eda:	7402                	ld	s0,32(sp)
    80005edc:	6145                	addi	sp,sp,48
    80005ede:	8082                	ret

0000000080005ee0 <sys_kbdint>:
extern int keyboard_int_cnt;
uint64 sys_kbdint()
{
    80005ee0:	1141                	addi	sp,sp,-16
    80005ee2:	e422                	sd	s0,8(sp)
    80005ee4:	0800                	addi	s0,sp,16

return keyboard_int_cnt;
}
    80005ee6:	00004517          	auipc	a0,0x4
    80005eea:	61a52503          	lw	a0,1562(a0) # 8000a500 <keyboard_int_cnt>
    80005eee:	6422                	ld	s0,8(sp)
    80005ef0:	0141                	addi	sp,sp,16
    80005ef2:	8082                	ret
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
