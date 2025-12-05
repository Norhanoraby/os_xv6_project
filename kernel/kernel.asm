
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	40013103          	ld	sp,1024(sp) # 8000a400 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdae5f>
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
    800000fa:	300020ef          	jal	800023fa <either_copyin>
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
    80000158:	31c50513          	addi	a0,a0,796 # 80012470 <cons>
    8000015c:	2a7000ef          	jal	80000c02 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00012497          	auipc	s1,0x12
    80000164:	31048493          	addi	s1,s1,784 # 80012470 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00012917          	auipc	s2,0x12
    8000016c:	3a090913          	addi	s2,s2,928 # 80012508 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	792010ef          	jal	80001912 <myproc>
    80000184:	108020ef          	jal	8000228c <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	6c7010ef          	jal	80002054 <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	00012717          	auipc	a4,0x12
    800001a4:	2d070713          	addi	a4,a4,720 # 80012470 <cons>
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
    800001d2:	1de020ef          	jal	800023b0 <either_copyout>
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
    800001ee:	28650513          	addi	a0,a0,646 # 80012470 <cons>
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
    80000218:	2ef72a23          	sw	a5,756(a4) # 80012508 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	00012517          	auipc	a0,0x12
    8000022e:	24650513          	addi	a0,a0,582 # 80012470 <cons>
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
    80000282:	1f250513          	addi	a0,a0,498 # 80012470 <cons>
    80000286:	17d000ef          	jal	80000c02 <acquire>
  keyboard_int_cnt++;
    8000028a:	0000a717          	auipc	a4,0xa
    8000028e:	19670713          	addi	a4,a4,406 # 8000a420 <keyboard_int_cnt>
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
    800002ae:	196020ef          	jal	80002444 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002b2:	00012517          	auipc	a0,0x12
    800002b6:	1be50513          	addi	a0,a0,446 # 80012470 <cons>
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
    800002d4:	1a070713          	addi	a4,a4,416 # 80012470 <cons>
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
    800002fa:	17a78793          	addi	a5,a5,378 # 80012470 <cons>
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
    80000328:	1e47a783          	lw	a5,484(a5) # 80012508 <cons+0x98>
    8000032c:	9f1d                	subw	a4,a4,a5
    8000032e:	08000793          	li	a5,128
    80000332:	f8f710e3          	bne	a4,a5,800002b2 <consoleintr+0x40>
    80000336:	a07d                	j	800003e4 <consoleintr+0x172>
    80000338:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000033a:	00012717          	auipc	a4,0x12
    8000033e:	13670713          	addi	a4,a4,310 # 80012470 <cons>
    80000342:	0a072783          	lw	a5,160(a4)
    80000346:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	00012497          	auipc	s1,0x12
    8000034e:	12648493          	addi	s1,s1,294 # 80012470 <cons>
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
    80000390:	0e470713          	addi	a4,a4,228 # 80012470 <cons>
    80000394:	0a072783          	lw	a5,160(a4)
    80000398:	09c72703          	lw	a4,156(a4)
    8000039c:	f0f70be3          	beq	a4,a5,800002b2 <consoleintr+0x40>
      cons.e--;
    800003a0:	37fd                	addiw	a5,a5,-1
    800003a2:	00012717          	auipc	a4,0x12
    800003a6:	16f72723          	sw	a5,366(a4) # 80012510 <cons+0xa0>
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
    800003c4:	0b078793          	addi	a5,a5,176 # 80012470 <cons>
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
    800003e8:	12c7a423          	sw	a2,296(a5) # 8001250c <cons+0x9c>
        wakeup(&cons.r);
    800003ec:	00012517          	auipc	a0,0x12
    800003f0:	11c50513          	addi	a0,a0,284 # 80012508 <cons+0x98>
    800003f4:	4ad010ef          	jal	800020a0 <wakeup>
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
    8000040e:	06650513          	addi	a0,a0,102 # 80012470 <cons>
    80000412:	770000ef          	jal	80000b82 <initlock>

  uartinit();
    80000416:	3f4000ef          	jal	8000080a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000041a:	00022797          	auipc	a5,0x22
    8000041e:	3ee78793          	addi	a5,a5,1006 # 80022808 <devsw>
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
    800004f2:	0427a783          	lw	a5,66(a5) # 80012530 <pr+0x18>
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
    8000053e:	fde50513          	addi	a0,a0,-34 # 80012518 <pr>
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
    80000798:	d8450513          	addi	a0,a0,-636 # 80012518 <pr>
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
    800007b2:	d807a123          	sw	zero,-638(a5) # 80012530 <pr+0x18>
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
    800007d6:	c4f72923          	sw	a5,-942(a4) # 8000a424 <panicked>
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
    800007ea:	d3248493          	addi	s1,s1,-718 # 80012518 <pr>
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
    80000852:	cea50513          	addi	a0,a0,-790 # 80012538 <uart_tx_lock>
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
    80000876:	bb27a783          	lw	a5,-1102(a5) # 8000a424 <panicked>
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
    800008ac:	b807b783          	ld	a5,-1152(a5) # 8000a428 <uart_tx_r>
    800008b0:	0000a717          	auipc	a4,0xa
    800008b4:	b8073703          	ld	a4,-1152(a4) # 8000a430 <uart_tx_w>
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
    800008da:	c62a8a93          	addi	s5,s5,-926 # 80012538 <uart_tx_lock>
    uart_tx_r += 1;
    800008de:	0000a497          	auipc	s1,0xa
    800008e2:	b4a48493          	addi	s1,s1,-1206 # 8000a428 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008e6:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008ea:	0000a997          	auipc	s3,0xa
    800008ee:	b4698993          	addi	s3,s3,-1210 # 8000a430 <uart_tx_w>
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
    8000090c:	794010ef          	jal	800020a0 <wakeup>
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
    8000095e:	bde50513          	addi	a0,a0,-1058 # 80012538 <uart_tx_lock>
    80000962:	2a0000ef          	jal	80000c02 <acquire>
  if(panicked){
    80000966:	0000a797          	auipc	a5,0xa
    8000096a:	abe7a783          	lw	a5,-1346(a5) # 8000a424 <panicked>
    8000096e:	efbd                	bnez	a5,800009ec <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000970:	0000a717          	auipc	a4,0xa
    80000974:	ac073703          	ld	a4,-1344(a4) # 8000a430 <uart_tx_w>
    80000978:	0000a797          	auipc	a5,0xa
    8000097c:	ab07b783          	ld	a5,-1360(a5) # 8000a428 <uart_tx_r>
    80000980:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000984:	00012997          	auipc	s3,0x12
    80000988:	bb498993          	addi	s3,s3,-1100 # 80012538 <uart_tx_lock>
    8000098c:	0000a497          	auipc	s1,0xa
    80000990:	a9c48493          	addi	s1,s1,-1380 # 8000a428 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000994:	0000a917          	auipc	s2,0xa
    80000998:	a9c90913          	addi	s2,s2,-1380 # 8000a430 <uart_tx_w>
    8000099c:	00e79d63          	bne	a5,a4,800009b6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800009a0:	85ce                	mv	a1,s3
    800009a2:	8526                	mv	a0,s1
    800009a4:	6b0010ef          	jal	80002054 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800009a8:	00093703          	ld	a4,0(s2)
    800009ac:	609c                	ld	a5,0(s1)
    800009ae:	02078793          	addi	a5,a5,32
    800009b2:	fee787e3          	beq	a5,a4,800009a0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009b6:	00012497          	auipc	s1,0x12
    800009ba:	b8248493          	addi	s1,s1,-1150 # 80012538 <uart_tx_lock>
    800009be:	01f77793          	andi	a5,a4,31
    800009c2:	97a6                	add	a5,a5,s1
    800009c4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009c8:	0705                	addi	a4,a4,1
    800009ca:	0000a797          	auipc	a5,0xa
    800009ce:	a6e7b323          	sd	a4,-1434(a5) # 8000a430 <uart_tx_w>
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
    80000a32:	b0a48493          	addi	s1,s1,-1270 # 80012538 <uart_tx_lock>
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
    80000a68:	f3c78793          	addi	a5,a5,-196 # 800239a0 <end>
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
    80000a84:	af090913          	addi	s2,s2,-1296 # 80012570 <kmem>
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
    80000b12:	a6250513          	addi	a0,a0,-1438 # 80012570 <kmem>
    80000b16:	06c000ef          	jal	80000b82 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b1a:	45c5                	li	a1,17
    80000b1c:	05ee                	slli	a1,a1,0x1b
    80000b1e:	00023517          	auipc	a0,0x23
    80000b22:	e8250513          	addi	a0,a0,-382 # 800239a0 <end>
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
    80000b40:	a3448493          	addi	s1,s1,-1484 # 80012570 <kmem>
    80000b44:	8526                	mv	a0,s1
    80000b46:	0bc000ef          	jal	80000c02 <acquire>
  r = kmem.freelist;
    80000b4a:	6c84                	ld	s1,24(s1)
  if(r)
    80000b4c:	c485                	beqz	s1,80000b74 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b4e:	609c                	ld	a5,0(s1)
    80000b50:	00012517          	auipc	a0,0x12
    80000b54:	a2050513          	addi	a0,a0,-1504 # 80012570 <kmem>
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
    80000b78:	9fc50513          	addi	a0,a0,-1540 # 80012570 <kmem>
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
    80000d4a:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb661>
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
    80000e80:	5bc70713          	addi	a4,a4,1468 # 8000a438 <started>
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
    80000ea6:	6d0010ef          	jal	80002576 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000eaa:	63e040ef          	jal	800054e8 <plicinithart>
  }

  scheduler();        
    80000eae:	028010ef          	jal	80001ed6 <scheduler>
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
    80000eee:	664010ef          	jal	80002552 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ef2:	684010ef          	jal	80002576 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ef6:	5d8040ef          	jal	800054ce <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000efa:	5ee040ef          	jal	800054e8 <plicinithart>
    binit();         // buffer cache
    80000efe:	59d010ef          	jal	80002c9a <binit>
    iinit();         // inode table
    80000f02:	38e020ef          	jal	80003290 <iinit>
    fileinit();      // file table
    80000f06:	13a030ef          	jal	80004040 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f0a:	6ce040ef          	jal	800055d8 <virtio_disk_init>
    userinit();      // first user process
    80000f0e:	56d000ef          	jal	80001c7a <userinit>
    __sync_synchronize();
    80000f12:	0330000f          	fence	rw,rw
    started = 1;
    80000f16:	4785                	li	a5,1
    80000f18:	00009717          	auipc	a4,0x9
    80000f1c:	52f72023          	sw	a5,1312(a4) # 8000a438 <started>
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
    80000f30:	5147b783          	ld	a5,1300(a5) # 8000a440 <kernel_pagetable>
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
    80000f9e:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb657>
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
    800011e0:	26a7b223          	sd	a0,612(a5) # 8000a440 <kernel_pagetable>
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
    800017b2:	21248493          	addi	s1,s1,530 # 800129c0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800017b6:	8b26                	mv	s6,s1
    800017b8:	ff4df937          	lui	s2,0xff4df
    800017bc:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bb01d>
    800017c0:	0936                	slli	s2,s2,0xd
    800017c2:	6f590913          	addi	s2,s2,1781
    800017c6:	0936                	slli	s2,s2,0xd
    800017c8:	bd390913          	addi	s2,s2,-1069
    800017cc:	0932                	slli	s2,s2,0xc
    800017ce:	7a790913          	addi	s2,s2,1959
    800017d2:	040009b7          	lui	s3,0x4000
    800017d6:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017d8:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017da:	00017a97          	auipc	s5,0x17
    800017de:	de6a8a93          	addi	s5,s5,-538 # 800185c0 <tickslock>
    char *pa = kalloc();
    800017e2:	b50ff0ef          	jal	80000b32 <kalloc>
    800017e6:	862a                	mv	a2,a0
    if(pa == 0)
    800017e8:	cd15                	beqz	a0,80001824 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017ea:	416485b3          	sub	a1,s1,s6
    800017ee:	8591                	srai	a1,a1,0x4
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
    80001808:	17048493          	addi	s1,s1,368
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
    80001850:	d4450513          	addi	a0,a0,-700 # 80012590 <pid_lock>
    80001854:	b2eff0ef          	jal	80000b82 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001858:	00006597          	auipc	a1,0x6
    8000185c:	9b058593          	addi	a1,a1,-1616 # 80007208 <etext+0x208>
    80001860:	00011517          	auipc	a0,0x11
    80001864:	d4850513          	addi	a0,a0,-696 # 800125a8 <wait_lock>
    80001868:	b1aff0ef          	jal	80000b82 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000186c:	00011497          	auipc	s1,0x11
    80001870:	15448493          	addi	s1,s1,340 # 800129c0 <proc>
      initlock(&p->lock, "proc");
    80001874:	00006b17          	auipc	s6,0x6
    80001878:	9a4b0b13          	addi	s6,s6,-1628 # 80007218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000187c:	8aa6                	mv	s5,s1
    8000187e:	ff4df937          	lui	s2,0xff4df
    80001882:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bb01d>
    80001886:	0936                	slli	s2,s2,0xd
    80001888:	6f590913          	addi	s2,s2,1781
    8000188c:	0936                	slli	s2,s2,0xd
    8000188e:	bd390913          	addi	s2,s2,-1069
    80001892:	0932                	slli	s2,s2,0xc
    80001894:	7a790913          	addi	s2,s2,1959
    80001898:	040009b7          	lui	s3,0x4000
    8000189c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000189e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800018a0:	00017a17          	auipc	s4,0x17
    800018a4:	d20a0a13          	addi	s4,s4,-736 # 800185c0 <tickslock>
      initlock(&p->lock, "proc");
    800018a8:	85da                	mv	a1,s6
    800018aa:	8526                	mv	a0,s1
    800018ac:	ad6ff0ef          	jal	80000b82 <initlock>
      p->state = UNUSED;
    800018b0:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800018b4:	415487b3          	sub	a5,s1,s5
    800018b8:	8791                	srai	a5,a5,0x4
    800018ba:	032787b3          	mul	a5,a5,s2
    800018be:	2785                	addiw	a5,a5,1
    800018c0:	00d7979b          	slliw	a5,a5,0xd
    800018c4:	40f987b3          	sub	a5,s3,a5
    800018c8:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ca:	17048493          	addi	s1,s1,368
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
    80001906:	cbe50513          	addi	a0,a0,-834 # 800125c0 <cpus>
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
    8000192a:	c6a70713          	addi	a4,a4,-918 # 80012590 <pid_lock>
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
    8000197c:	04848493          	addi	s1,s1,72 # 800129c0 <proc>
      pinfo.ppid = (p->parent) ? p->parent->pid : 0;  // Handle init process
    80001980:	4b81                	li	s7,0
  for (p = proc; p < &proc[NPROC]; p++) {
    80001982:	00017a97          	auipc	s5,0x17
    80001986:	c3ea8a93          	addi	s5,s5,-962 # 800185c0 <tickslock>
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
    800019e6:	17048493          	addi	s1,s1,368
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
    80001a46:	96e7a783          	lw	a5,-1682(a5) # 8000a3b0 <first.1>
    80001a4a:	e799                	bnez	a5,80001a58 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001a4c:	343000ef          	jal	8000258e <usertrapret>
}
    80001a50:	60a2                	ld	ra,8(sp)
    80001a52:	6402                	ld	s0,0(sp)
    80001a54:	0141                	addi	sp,sp,16
    80001a56:	8082                	ret
    fsinit(ROOTDEV);
    80001a58:	4505                	li	a0,1
    80001a5a:	7ca010ef          	jal	80003224 <fsinit>
    first = 0;
    80001a5e:	00009797          	auipc	a5,0x9
    80001a62:	9407a923          	sw	zero,-1710(a5) # 8000a3b0 <first.1>
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
    80001a7c:	b1890913          	addi	s2,s2,-1256 # 80012590 <pid_lock>
    80001a80:	854a                	mv	a0,s2
    80001a82:	980ff0ef          	jal	80000c02 <acquire>
  pid = nextpid;
    80001a86:	00009797          	auipc	a5,0x9
    80001a8a:	92e78793          	addi	a5,a5,-1746 # 8000a3b4 <nextpid>
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
  p->state = UNUSED;
    80001bb6:	0004ac23          	sw	zero,24(s1)
}
    80001bba:	60e2                	ld	ra,24(sp)
    80001bbc:	6442                	ld	s0,16(sp)
    80001bbe:	64a2                	ld	s1,8(sp)
    80001bc0:	6105                	addi	sp,sp,32
    80001bc2:	8082                	ret

0000000080001bc4 <allocproc>:
{
    80001bc4:	1101                	addi	sp,sp,-32
    80001bc6:	ec06                	sd	ra,24(sp)
    80001bc8:	e822                	sd	s0,16(sp)
    80001bca:	e426                	sd	s1,8(sp)
    80001bcc:	e04a                	sd	s2,0(sp)
    80001bce:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bd0:	00011497          	auipc	s1,0x11
    80001bd4:	df048493          	addi	s1,s1,-528 # 800129c0 <proc>
    80001bd8:	00017917          	auipc	s2,0x17
    80001bdc:	9e890913          	addi	s2,s2,-1560 # 800185c0 <tickslock>
    acquire(&p->lock);
    80001be0:	8526                	mv	a0,s1
    80001be2:	820ff0ef          	jal	80000c02 <acquire>
    if(p->state == UNUSED) {
    80001be6:	4c9c                	lw	a5,24(s1)
    80001be8:	cb91                	beqz	a5,80001bfc <allocproc+0x38>
      release(&p->lock);
    80001bea:	8526                	mv	a0,s1
    80001bec:	8aeff0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bf0:	17048493          	addi	s1,s1,368
    80001bf4:	ff2496e3          	bne	s1,s2,80001be0 <allocproc+0x1c>
  return 0;
    80001bf8:	4481                	li	s1,0
    80001bfa:	a889                	j	80001c4c <allocproc+0x88>
  p->pid = allocpid();
    80001bfc:	e71ff0ef          	jal	80001a6c <allocpid>
    80001c00:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c02:	4785                	li	a5,1
    80001c04:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c06:	f2dfe0ef          	jal	80000b32 <kalloc>
    80001c0a:	892a                	mv	s2,a0
    80001c0c:	eca8                	sd	a0,88(s1)
    80001c0e:	c531                	beqz	a0,80001c5a <allocproc+0x96>
  p->pagetable = proc_pagetable(p);
    80001c10:	8526                	mv	a0,s1
    80001c12:	e99ff0ef          	jal	80001aaa <proc_pagetable>
    80001c16:	892a                	mv	s2,a0
    80001c18:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c1a:	c921                	beqz	a0,80001c6a <allocproc+0xa6>
  memset(&p->context, 0, sizeof(p->context));
    80001c1c:	07000613          	li	a2,112
    80001c20:	4581                	li	a1,0
    80001c22:	06048513          	addi	a0,s1,96
    80001c26:	8b0ff0ef          	jal	80000cd6 <memset>
  p->context.ra = (uint64)forkret;
    80001c2a:	00000797          	auipc	a5,0x0
    80001c2e:	e0878793          	addi	a5,a5,-504 # 80001a32 <forkret>
    80001c32:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c34:	60bc                	ld	a5,64(s1)
    80001c36:	6705                	lui	a4,0x1
    80001c38:	97ba                	add	a5,a5,a4
    80001c3a:	f4bc                	sd	a5,104(s1)
  p->creation_time = ticks;
    80001c3c:	00009797          	auipc	a5,0x9
    80001c40:	81c7a783          	lw	a5,-2020(a5) # 8000a458 <ticks>
    80001c44:	16f4a423          	sw	a5,360(s1)
  p->run_time = 0;
    80001c48:	1604a623          	sw	zero,364(s1)
}
    80001c4c:	8526                	mv	a0,s1
    80001c4e:	60e2                	ld	ra,24(sp)
    80001c50:	6442                	ld	s0,16(sp)
    80001c52:	64a2                	ld	s1,8(sp)
    80001c54:	6902                	ld	s2,0(sp)
    80001c56:	6105                	addi	sp,sp,32
    80001c58:	8082                	ret
    freeproc(p);
    80001c5a:	8526                	mv	a0,s1
    80001c5c:	f19ff0ef          	jal	80001b74 <freeproc>
    release(&p->lock);
    80001c60:	8526                	mv	a0,s1
    80001c62:	838ff0ef          	jal	80000c9a <release>
    return 0;
    80001c66:	84ca                	mv	s1,s2
    80001c68:	b7d5                	j	80001c4c <allocproc+0x88>
    freeproc(p);
    80001c6a:	8526                	mv	a0,s1
    80001c6c:	f09ff0ef          	jal	80001b74 <freeproc>
    release(&p->lock);
    80001c70:	8526                	mv	a0,s1
    80001c72:	828ff0ef          	jal	80000c9a <release>
    return 0;
    80001c76:	84ca                	mv	s1,s2
    80001c78:	bfd1                	j	80001c4c <allocproc+0x88>

0000000080001c7a <userinit>:
{
    80001c7a:	1101                	addi	sp,sp,-32
    80001c7c:	ec06                	sd	ra,24(sp)
    80001c7e:	e822                	sd	s0,16(sp)
    80001c80:	e426                	sd	s1,8(sp)
    80001c82:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c84:	f41ff0ef          	jal	80001bc4 <allocproc>
    80001c88:	84aa                	mv	s1,a0
  initproc = p;
    80001c8a:	00008797          	auipc	a5,0x8
    80001c8e:	7ca7b323          	sd	a0,1990(a5) # 8000a450 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001c92:	03400613          	li	a2,52
    80001c96:	00008597          	auipc	a1,0x8
    80001c9a:	72a58593          	addi	a1,a1,1834 # 8000a3c0 <initcode>
    80001c9e:	6928                	ld	a0,80(a0)
    80001ca0:	e2eff0ef          	jal	800012ce <uvmfirst>
  p->sz = PGSIZE;
    80001ca4:	6785                	lui	a5,0x1
    80001ca6:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001ca8:	6cb8                	ld	a4,88(s1)
    80001caa:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001cae:	6cb8                	ld	a4,88(s1)
    80001cb0:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001cb2:	4641                	li	a2,16
    80001cb4:	00005597          	auipc	a1,0x5
    80001cb8:	56c58593          	addi	a1,a1,1388 # 80007220 <etext+0x220>
    80001cbc:	15848513          	addi	a0,s1,344
    80001cc0:	954ff0ef          	jal	80000e14 <safestrcpy>
  p->cwd = namei("/");
    80001cc4:	00005517          	auipc	a0,0x5
    80001cc8:	56c50513          	addi	a0,a0,1388 # 80007230 <etext+0x230>
    80001ccc:	667010ef          	jal	80003b32 <namei>
    80001cd0:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001cd4:	478d                	li	a5,3
    80001cd6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001cd8:	8526                	mv	a0,s1
    80001cda:	fc1fe0ef          	jal	80000c9a <release>
}
    80001cde:	60e2                	ld	ra,24(sp)
    80001ce0:	6442                	ld	s0,16(sp)
    80001ce2:	64a2                	ld	s1,8(sp)
    80001ce4:	6105                	addi	sp,sp,32
    80001ce6:	8082                	ret

0000000080001ce8 <growproc>:
{
    80001ce8:	1101                	addi	sp,sp,-32
    80001cea:	ec06                	sd	ra,24(sp)
    80001cec:	e822                	sd	s0,16(sp)
    80001cee:	e426                	sd	s1,8(sp)
    80001cf0:	e04a                	sd	s2,0(sp)
    80001cf2:	1000                	addi	s0,sp,32
    80001cf4:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001cf6:	c1dff0ef          	jal	80001912 <myproc>
    80001cfa:	84aa                	mv	s1,a0
  sz = p->sz;
    80001cfc:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001cfe:	01204c63          	bgtz	s2,80001d16 <growproc+0x2e>
  } else if(n < 0){
    80001d02:	02094463          	bltz	s2,80001d2a <growproc+0x42>
  p->sz = sz;
    80001d06:	e4ac                	sd	a1,72(s1)
  return 0;
    80001d08:	4501                	li	a0,0
}
    80001d0a:	60e2                	ld	ra,24(sp)
    80001d0c:	6442                	ld	s0,16(sp)
    80001d0e:	64a2                	ld	s1,8(sp)
    80001d10:	6902                	ld	s2,0(sp)
    80001d12:	6105                	addi	sp,sp,32
    80001d14:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001d16:	4691                	li	a3,4
    80001d18:	00b90633          	add	a2,s2,a1
    80001d1c:	6928                	ld	a0,80(a0)
    80001d1e:	e52ff0ef          	jal	80001370 <uvmalloc>
    80001d22:	85aa                	mv	a1,a0
    80001d24:	f16d                	bnez	a0,80001d06 <growproc+0x1e>
      return -1;
    80001d26:	557d                	li	a0,-1
    80001d28:	b7cd                	j	80001d0a <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d2a:	00b90633          	add	a2,s2,a1
    80001d2e:	6928                	ld	a0,80(a0)
    80001d30:	dfcff0ef          	jal	8000132c <uvmdealloc>
    80001d34:	85aa                	mv	a1,a0
    80001d36:	bfc1                	j	80001d06 <growproc+0x1e>

0000000080001d38 <fork>:
{
    80001d38:	7139                	addi	sp,sp,-64
    80001d3a:	fc06                	sd	ra,56(sp)
    80001d3c:	f822                	sd	s0,48(sp)
    80001d3e:	f04a                	sd	s2,32(sp)
    80001d40:	e456                	sd	s5,8(sp)
    80001d42:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001d44:	bcfff0ef          	jal	80001912 <myproc>
    80001d48:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001d4a:	e7bff0ef          	jal	80001bc4 <allocproc>
    80001d4e:	0e050a63          	beqz	a0,80001e42 <fork+0x10a>
    80001d52:	e852                	sd	s4,16(sp)
    80001d54:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001d56:	048ab603          	ld	a2,72(s5)
    80001d5a:	692c                	ld	a1,80(a0)
    80001d5c:	050ab503          	ld	a0,80(s5)
    80001d60:	f48ff0ef          	jal	800014a8 <uvmcopy>
    80001d64:	04054a63          	bltz	a0,80001db8 <fork+0x80>
    80001d68:	f426                	sd	s1,40(sp)
    80001d6a:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001d6c:	048ab783          	ld	a5,72(s5)
    80001d70:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001d74:	058ab683          	ld	a3,88(s5)
    80001d78:	87b6                	mv	a5,a3
    80001d7a:	058a3703          	ld	a4,88(s4)
    80001d7e:	12068693          	addi	a3,a3,288
    80001d82:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001d86:	6788                	ld	a0,8(a5)
    80001d88:	6b8c                	ld	a1,16(a5)
    80001d8a:	6f90                	ld	a2,24(a5)
    80001d8c:	01073023          	sd	a6,0(a4)
    80001d90:	e708                	sd	a0,8(a4)
    80001d92:	eb0c                	sd	a1,16(a4)
    80001d94:	ef10                	sd	a2,24(a4)
    80001d96:	02078793          	addi	a5,a5,32
    80001d9a:	02070713          	addi	a4,a4,32
    80001d9e:	fed792e3          	bne	a5,a3,80001d82 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001da2:	058a3783          	ld	a5,88(s4)
    80001da6:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001daa:	0d0a8493          	addi	s1,s5,208
    80001dae:	0d0a0913          	addi	s2,s4,208
    80001db2:	150a8993          	addi	s3,s5,336
    80001db6:	a831                	j	80001dd2 <fork+0x9a>
    freeproc(np);
    80001db8:	8552                	mv	a0,s4
    80001dba:	dbbff0ef          	jal	80001b74 <freeproc>
    release(&np->lock);
    80001dbe:	8552                	mv	a0,s4
    80001dc0:	edbfe0ef          	jal	80000c9a <release>
    return -1;
    80001dc4:	597d                	li	s2,-1
    80001dc6:	6a42                	ld	s4,16(sp)
    80001dc8:	a0b5                	j	80001e34 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001dca:	04a1                	addi	s1,s1,8
    80001dcc:	0921                	addi	s2,s2,8
    80001dce:	01348963          	beq	s1,s3,80001de0 <fork+0xa8>
    if(p->ofile[i])
    80001dd2:	6088                	ld	a0,0(s1)
    80001dd4:	d97d                	beqz	a0,80001dca <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001dd6:	2ec020ef          	jal	800040c2 <filedup>
    80001dda:	00a93023          	sd	a0,0(s2)
    80001dde:	b7f5                	j	80001dca <fork+0x92>
  np->cwd = idup(p->cwd);
    80001de0:	150ab503          	ld	a0,336(s5)
    80001de4:	63e010ef          	jal	80003422 <idup>
    80001de8:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001dec:	4641                	li	a2,16
    80001dee:	158a8593          	addi	a1,s5,344
    80001df2:	158a0513          	addi	a0,s4,344
    80001df6:	81eff0ef          	jal	80000e14 <safestrcpy>
  pid = np->pid;
    80001dfa:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001dfe:	8552                	mv	a0,s4
    80001e00:	e9bfe0ef          	jal	80000c9a <release>
  acquire(&wait_lock);
    80001e04:	00010497          	auipc	s1,0x10
    80001e08:	7a448493          	addi	s1,s1,1956 # 800125a8 <wait_lock>
    80001e0c:	8526                	mv	a0,s1
    80001e0e:	df5fe0ef          	jal	80000c02 <acquire>
  np->parent = p;
    80001e12:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001e16:	8526                	mv	a0,s1
    80001e18:	e83fe0ef          	jal	80000c9a <release>
  acquire(&np->lock);
    80001e1c:	8552                	mv	a0,s4
    80001e1e:	de5fe0ef          	jal	80000c02 <acquire>
  np->state = RUNNABLE;
    80001e22:	478d                	li	a5,3
    80001e24:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e28:	8552                	mv	a0,s4
    80001e2a:	e71fe0ef          	jal	80000c9a <release>
  return pid;
    80001e2e:	74a2                	ld	s1,40(sp)
    80001e30:	69e2                	ld	s3,24(sp)
    80001e32:	6a42                	ld	s4,16(sp)
}
    80001e34:	854a                	mv	a0,s2
    80001e36:	70e2                	ld	ra,56(sp)
    80001e38:	7442                	ld	s0,48(sp)
    80001e3a:	7902                	ld	s2,32(sp)
    80001e3c:	6aa2                	ld	s5,8(sp)
    80001e3e:	6121                	addi	sp,sp,64
    80001e40:	8082                	ret
    return -1;
    80001e42:	597d                	li	s2,-1
    80001e44:	bfc5                	j	80001e34 <fork+0xfc>

0000000080001e46 <update_time>:
{
    80001e46:	7179                	addi	sp,sp,-48
    80001e48:	f406                	sd	ra,40(sp)
    80001e4a:	f022                	sd	s0,32(sp)
    80001e4c:	ec26                	sd	s1,24(sp)
    80001e4e:	e84a                	sd	s2,16(sp)
    80001e50:	e44e                	sd	s3,8(sp)
    80001e52:	1800                	addi	s0,sp,48
  for (p = proc; p < &proc[NPROC]; p++) {
    80001e54:	00011497          	auipc	s1,0x11
    80001e58:	b6c48493          	addi	s1,s1,-1172 # 800129c0 <proc>
    if (p->state == RUNNING) {
    80001e5c:	4991                	li	s3,4
  for (p = proc; p < &proc[NPROC]; p++) {
    80001e5e:	00016917          	auipc	s2,0x16
    80001e62:	76290913          	addi	s2,s2,1890 # 800185c0 <tickslock>
    80001e66:	a801                	j	80001e76 <update_time+0x30>
    release(&p->lock);//lehd hena
    80001e68:	8526                	mv	a0,s1
    80001e6a:	e31fe0ef          	jal	80000c9a <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001e6e:	17048493          	addi	s1,s1,368
    80001e72:	01248e63          	beq	s1,s2,80001e8e <update_time+0x48>
    acquire(&p->lock);//n3adel mn hena
    80001e76:	8526                	mv	a0,s1
    80001e78:	d8bfe0ef          	jal	80000c02 <acquire>
    if (p->state == RUNNING) {
    80001e7c:	4c9c                	lw	a5,24(s1)
    80001e7e:	ff3795e3          	bne	a5,s3,80001e68 <update_time+0x22>
      p->run_time++;
    80001e82:	16c4a783          	lw	a5,364(s1)
    80001e86:	2785                	addiw	a5,a5,1
    80001e88:	16f4a623          	sw	a5,364(s1)
    80001e8c:	bff1                	j	80001e68 <update_time+0x22>
}
    80001e8e:	70a2                	ld	ra,40(sp)
    80001e90:	7402                	ld	s0,32(sp)
    80001e92:	64e2                	ld	s1,24(sp)
    80001e94:	6942                	ld	s2,16(sp)
    80001e96:	69a2                	ld	s3,8(sp)
    80001e98:	6145                	addi	sp,sp,48
    80001e9a:	8082                	ret

0000000080001e9c <choose_next_process>:
struct proc *choose_next_process() {
    80001e9c:	1141                	addi	sp,sp,-16
    80001e9e:	e422                	sd	s0,8(sp)
    80001ea0:	0800                	addi	s0,sp,16
  if(sched_mode == SCHED_ROUND_ROBIN) {
    80001ea2:	00008797          	auipc	a5,0x8
    80001ea6:	5a67a783          	lw	a5,1446(a5) # 8000a448 <sched_mode>
  return 0;
    80001eaa:	4501                	li	a0,0
  if(sched_mode == SCHED_ROUND_ROBIN) {
    80001eac:	e395                	bnez	a5,80001ed0 <choose_next_process+0x34>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001eae:	00011517          	auipc	a0,0x11
    80001eb2:	b1250513          	addi	a0,a0,-1262 # 800129c0 <proc>
      if (p->state == RUNNABLE)
    80001eb6:	470d                	li	a4,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001eb8:	00016697          	auipc	a3,0x16
    80001ebc:	70868693          	addi	a3,a3,1800 # 800185c0 <tickslock>
      if (p->state == RUNNABLE)
    80001ec0:	4d1c                	lw	a5,24(a0)
    80001ec2:	00e78763          	beq	a5,a4,80001ed0 <choose_next_process+0x34>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ec6:	17050513          	addi	a0,a0,368
    80001eca:	fed51be3          	bne	a0,a3,80001ec0 <choose_next_process+0x24>
  return 0;
    80001ece:	4501                	li	a0,0
}
    80001ed0:	6422                	ld	s0,8(sp)
    80001ed2:	0141                	addi	sp,sp,16
    80001ed4:	8082                	ret

0000000080001ed6 <scheduler>:
{
    80001ed6:	7139                	addi	sp,sp,-64
    80001ed8:	fc06                	sd	ra,56(sp)
    80001eda:	f822                	sd	s0,48(sp)
    80001edc:	f426                	sd	s1,40(sp)
    80001ede:	f04a                	sd	s2,32(sp)
    80001ee0:	ec4e                	sd	s3,24(sp)
    80001ee2:	e852                	sd	s4,16(sp)
    80001ee4:	e456                	sd	s5,8(sp)
    80001ee6:	0080                	addi	s0,sp,64
    80001ee8:	8792                	mv	a5,tp
  int id = r_tp();
    80001eea:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001eec:	00779a13          	slli	s4,a5,0x7
    80001ef0:	00010717          	auipc	a4,0x10
    80001ef4:	6a070713          	addi	a4,a4,1696 # 80012590 <pid_lock>
    80001ef8:	9752                	add	a4,a4,s4
    80001efa:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001efe:	00010717          	auipc	a4,0x10
    80001f02:	6ca70713          	addi	a4,a4,1738 # 800125c8 <cpus+0x8>
    80001f06:	9a3a                	add	s4,s4,a4
      if (p->state == RUNNABLE) {
    80001f08:	490d                	li	s2,3
        p->state = RUNNING;
    80001f0a:	4a91                	li	s5,4
        c->proc = p;
    80001f0c:	079e                	slli	a5,a5,0x7
    80001f0e:	00010997          	auipc	s3,0x10
    80001f12:	68298993          	addi	s3,s3,1666 # 80012590 <pid_lock>
    80001f16:	99be                	add	s3,s3,a5
    80001f18:	a805                	j	80001f48 <scheduler+0x72>
        p->state = RUNNING;
    80001f1a:	0154ac23          	sw	s5,24(s1)
        c->proc = p;
    80001f1e:	0299b823          	sd	s1,48(s3)
        swtch(&c->context, &p->context);
    80001f22:	06048593          	addi	a1,s1,96
    80001f26:	8552                	mv	a0,s4
    80001f28:	5c0000ef          	jal	800024e8 <swtch>
        c->proc = 0;
    80001f2c:	0209b823          	sd	zero,48(s3)
      release(&p->lock);
    80001f30:	8526                	mv	a0,s1
    80001f32:	d69fe0ef          	jal	80000c9a <release>
    if(found == 0) {
    80001f36:	a809                	j	80001f48 <scheduler+0x72>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f38:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f3c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f40:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001f44:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f48:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f4c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f50:	10079073          	csrw	sstatus,a5
    p = choose_next_process();
    80001f54:	f49ff0ef          	jal	80001e9c <choose_next_process>
    80001f58:	84aa                	mv	s1,a0
    if(p != 0) {
    80001f5a:	dd79                	beqz	a0,80001f38 <scheduler+0x62>
      acquire(&p->lock);
    80001f5c:	ca7fe0ef          	jal	80000c02 <acquire>
      if (p->state == RUNNABLE) {
    80001f60:	4c9c                	lw	a5,24(s1)
    80001f62:	fb278ce3          	beq	a5,s2,80001f1a <scheduler+0x44>
      release(&p->lock);
    80001f66:	8526                	mv	a0,s1
    80001f68:	d33fe0ef          	jal	80000c9a <release>
    if(found == 0) {
    80001f6c:	b7f1                	j	80001f38 <scheduler+0x62>

0000000080001f6e <sched>:
{
    80001f6e:	7179                	addi	sp,sp,-48
    80001f70:	f406                	sd	ra,40(sp)
    80001f72:	f022                	sd	s0,32(sp)
    80001f74:	ec26                	sd	s1,24(sp)
    80001f76:	e84a                	sd	s2,16(sp)
    80001f78:	e44e                	sd	s3,8(sp)
    80001f7a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001f7c:	997ff0ef          	jal	80001912 <myproc>
    80001f80:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001f82:	c17fe0ef          	jal	80000b98 <holding>
    80001f86:	c92d                	beqz	a0,80001ff8 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f88:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001f8a:	2781                	sext.w	a5,a5
    80001f8c:	079e                	slli	a5,a5,0x7
    80001f8e:	00010717          	auipc	a4,0x10
    80001f92:	60270713          	addi	a4,a4,1538 # 80012590 <pid_lock>
    80001f96:	97ba                	add	a5,a5,a4
    80001f98:	0a87a703          	lw	a4,168(a5)
    80001f9c:	4785                	li	a5,1
    80001f9e:	06f71363          	bne	a4,a5,80002004 <sched+0x96>
  if(p->state == RUNNING)
    80001fa2:	4c98                	lw	a4,24(s1)
    80001fa4:	4791                	li	a5,4
    80001fa6:	06f70563          	beq	a4,a5,80002010 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001faa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001fae:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001fb0:	e7b5                	bnez	a5,8000201c <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fb2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001fb4:	00010917          	auipc	s2,0x10
    80001fb8:	5dc90913          	addi	s2,s2,1500 # 80012590 <pid_lock>
    80001fbc:	2781                	sext.w	a5,a5
    80001fbe:	079e                	slli	a5,a5,0x7
    80001fc0:	97ca                	add	a5,a5,s2
    80001fc2:	0ac7a983          	lw	s3,172(a5)
    80001fc6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001fc8:	2781                	sext.w	a5,a5
    80001fca:	079e                	slli	a5,a5,0x7
    80001fcc:	00010597          	auipc	a1,0x10
    80001fd0:	5fc58593          	addi	a1,a1,1532 # 800125c8 <cpus+0x8>
    80001fd4:	95be                	add	a1,a1,a5
    80001fd6:	06048513          	addi	a0,s1,96
    80001fda:	50e000ef          	jal	800024e8 <swtch>
    80001fde:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001fe0:	2781                	sext.w	a5,a5
    80001fe2:	079e                	slli	a5,a5,0x7
    80001fe4:	993e                	add	s2,s2,a5
    80001fe6:	0b392623          	sw	s3,172(s2)
}
    80001fea:	70a2                	ld	ra,40(sp)
    80001fec:	7402                	ld	s0,32(sp)
    80001fee:	64e2                	ld	s1,24(sp)
    80001ff0:	6942                	ld	s2,16(sp)
    80001ff2:	69a2                	ld	s3,8(sp)
    80001ff4:	6145                	addi	sp,sp,48
    80001ff6:	8082                	ret
    panic("sched p->lock");
    80001ff8:	00005517          	auipc	a0,0x5
    80001ffc:	24050513          	addi	a0,a0,576 # 80007238 <etext+0x238>
    80002000:	fa2fe0ef          	jal	800007a2 <panic>
    panic("sched locks");
    80002004:	00005517          	auipc	a0,0x5
    80002008:	24450513          	addi	a0,a0,580 # 80007248 <etext+0x248>
    8000200c:	f96fe0ef          	jal	800007a2 <panic>
    panic("sched running");
    80002010:	00005517          	auipc	a0,0x5
    80002014:	24850513          	addi	a0,a0,584 # 80007258 <etext+0x258>
    80002018:	f8afe0ef          	jal	800007a2 <panic>
    panic("sched interruptible");
    8000201c:	00005517          	auipc	a0,0x5
    80002020:	24c50513          	addi	a0,a0,588 # 80007268 <etext+0x268>
    80002024:	f7efe0ef          	jal	800007a2 <panic>

0000000080002028 <yield>:
{
    80002028:	1101                	addi	sp,sp,-32
    8000202a:	ec06                	sd	ra,24(sp)
    8000202c:	e822                	sd	s0,16(sp)
    8000202e:	e426                	sd	s1,8(sp)
    80002030:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002032:	8e1ff0ef          	jal	80001912 <myproc>
    80002036:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002038:	bcbfe0ef          	jal	80000c02 <acquire>
  p->state = RUNNABLE;
    8000203c:	478d                	li	a5,3
    8000203e:	cc9c                	sw	a5,24(s1)
  sched();
    80002040:	f2fff0ef          	jal	80001f6e <sched>
  release(&p->lock);
    80002044:	8526                	mv	a0,s1
    80002046:	c55fe0ef          	jal	80000c9a <release>
}
    8000204a:	60e2                	ld	ra,24(sp)
    8000204c:	6442                	ld	s0,16(sp)
    8000204e:	64a2                	ld	s1,8(sp)
    80002050:	6105                	addi	sp,sp,32
    80002052:	8082                	ret

0000000080002054 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002054:	7179                	addi	sp,sp,-48
    80002056:	f406                	sd	ra,40(sp)
    80002058:	f022                	sd	s0,32(sp)
    8000205a:	ec26                	sd	s1,24(sp)
    8000205c:	e84a                	sd	s2,16(sp)
    8000205e:	e44e                	sd	s3,8(sp)
    80002060:	1800                	addi	s0,sp,48
    80002062:	89aa                	mv	s3,a0
    80002064:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002066:	8adff0ef          	jal	80001912 <myproc>
    8000206a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000206c:	b97fe0ef          	jal	80000c02 <acquire>
  release(lk);
    80002070:	854a                	mv	a0,s2
    80002072:	c29fe0ef          	jal	80000c9a <release>

  // Go to sleep.
  p->chan = chan;
    80002076:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000207a:	4789                	li	a5,2
    8000207c:	cc9c                	sw	a5,24(s1)

  sched();
    8000207e:	ef1ff0ef          	jal	80001f6e <sched>

  // Tidy up.
  p->chan = 0;
    80002082:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002086:	8526                	mv	a0,s1
    80002088:	c13fe0ef          	jal	80000c9a <release>
  acquire(lk);
    8000208c:	854a                	mv	a0,s2
    8000208e:	b75fe0ef          	jal	80000c02 <acquire>
}
    80002092:	70a2                	ld	ra,40(sp)
    80002094:	7402                	ld	s0,32(sp)
    80002096:	64e2                	ld	s1,24(sp)
    80002098:	6942                	ld	s2,16(sp)
    8000209a:	69a2                	ld	s3,8(sp)
    8000209c:	6145                	addi	sp,sp,48
    8000209e:	8082                	ret

00000000800020a0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800020a0:	7139                	addi	sp,sp,-64
    800020a2:	fc06                	sd	ra,56(sp)
    800020a4:	f822                	sd	s0,48(sp)
    800020a6:	f426                	sd	s1,40(sp)
    800020a8:	f04a                	sd	s2,32(sp)
    800020aa:	ec4e                	sd	s3,24(sp)
    800020ac:	e852                	sd	s4,16(sp)
    800020ae:	e456                	sd	s5,8(sp)
    800020b0:	0080                	addi	s0,sp,64
    800020b2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800020b4:	00011497          	auipc	s1,0x11
    800020b8:	90c48493          	addi	s1,s1,-1780 # 800129c0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800020bc:	4989                	li	s3,2
        p->state = RUNNABLE;
    800020be:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800020c0:	00016917          	auipc	s2,0x16
    800020c4:	50090913          	addi	s2,s2,1280 # 800185c0 <tickslock>
    800020c8:	a801                	j	800020d8 <wakeup+0x38>
      }
      release(&p->lock);
    800020ca:	8526                	mv	a0,s1
    800020cc:	bcffe0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800020d0:	17048493          	addi	s1,s1,368
    800020d4:	03248263          	beq	s1,s2,800020f8 <wakeup+0x58>
    if(p != myproc()){
    800020d8:	83bff0ef          	jal	80001912 <myproc>
    800020dc:	fea48ae3          	beq	s1,a0,800020d0 <wakeup+0x30>
      acquire(&p->lock);
    800020e0:	8526                	mv	a0,s1
    800020e2:	b21fe0ef          	jal	80000c02 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800020e6:	4c9c                	lw	a5,24(s1)
    800020e8:	ff3791e3          	bne	a5,s3,800020ca <wakeup+0x2a>
    800020ec:	709c                	ld	a5,32(s1)
    800020ee:	fd479ee3          	bne	a5,s4,800020ca <wakeup+0x2a>
        p->state = RUNNABLE;
    800020f2:	0154ac23          	sw	s5,24(s1)
    800020f6:	bfd1                	j	800020ca <wakeup+0x2a>
    }
  }
}
    800020f8:	70e2                	ld	ra,56(sp)
    800020fa:	7442                	ld	s0,48(sp)
    800020fc:	74a2                	ld	s1,40(sp)
    800020fe:	7902                	ld	s2,32(sp)
    80002100:	69e2                	ld	s3,24(sp)
    80002102:	6a42                	ld	s4,16(sp)
    80002104:	6aa2                	ld	s5,8(sp)
    80002106:	6121                	addi	sp,sp,64
    80002108:	8082                	ret

000000008000210a <reparent>:
{
    8000210a:	7179                	addi	sp,sp,-48
    8000210c:	f406                	sd	ra,40(sp)
    8000210e:	f022                	sd	s0,32(sp)
    80002110:	ec26                	sd	s1,24(sp)
    80002112:	e84a                	sd	s2,16(sp)
    80002114:	e44e                	sd	s3,8(sp)
    80002116:	e052                	sd	s4,0(sp)
    80002118:	1800                	addi	s0,sp,48
    8000211a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000211c:	00011497          	auipc	s1,0x11
    80002120:	8a448493          	addi	s1,s1,-1884 # 800129c0 <proc>
      pp->parent = initproc;
    80002124:	00008a17          	auipc	s4,0x8
    80002128:	32ca0a13          	addi	s4,s4,812 # 8000a450 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000212c:	00016997          	auipc	s3,0x16
    80002130:	49498993          	addi	s3,s3,1172 # 800185c0 <tickslock>
    80002134:	a029                	j	8000213e <reparent+0x34>
    80002136:	17048493          	addi	s1,s1,368
    8000213a:	01348b63          	beq	s1,s3,80002150 <reparent+0x46>
    if(pp->parent == p){
    8000213e:	7c9c                	ld	a5,56(s1)
    80002140:	ff279be3          	bne	a5,s2,80002136 <reparent+0x2c>
      pp->parent = initproc;
    80002144:	000a3503          	ld	a0,0(s4)
    80002148:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000214a:	f57ff0ef          	jal	800020a0 <wakeup>
    8000214e:	b7e5                	j	80002136 <reparent+0x2c>
}
    80002150:	70a2                	ld	ra,40(sp)
    80002152:	7402                	ld	s0,32(sp)
    80002154:	64e2                	ld	s1,24(sp)
    80002156:	6942                	ld	s2,16(sp)
    80002158:	69a2                	ld	s3,8(sp)
    8000215a:	6a02                	ld	s4,0(sp)
    8000215c:	6145                	addi	sp,sp,48
    8000215e:	8082                	ret

0000000080002160 <exit>:
{
    80002160:	7179                	addi	sp,sp,-48
    80002162:	f406                	sd	ra,40(sp)
    80002164:	f022                	sd	s0,32(sp)
    80002166:	ec26                	sd	s1,24(sp)
    80002168:	e84a                	sd	s2,16(sp)
    8000216a:	e44e                	sd	s3,8(sp)
    8000216c:	e052                	sd	s4,0(sp)
    8000216e:	1800                	addi	s0,sp,48
    80002170:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002172:	fa0ff0ef          	jal	80001912 <myproc>
    80002176:	89aa                	mv	s3,a0
  if(p == initproc)
    80002178:	00008797          	auipc	a5,0x8
    8000217c:	2d87b783          	ld	a5,728(a5) # 8000a450 <initproc>
    80002180:	0d050493          	addi	s1,a0,208
    80002184:	15050913          	addi	s2,a0,336
    80002188:	00a79f63          	bne	a5,a0,800021a6 <exit+0x46>
    panic("init exiting");
    8000218c:	00005517          	auipc	a0,0x5
    80002190:	0f450513          	addi	a0,a0,244 # 80007280 <etext+0x280>
    80002194:	e0efe0ef          	jal	800007a2 <panic>
      fileclose(f);
    80002198:	771010ef          	jal	80004108 <fileclose>
      p->ofile[fd] = 0;
    8000219c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800021a0:	04a1                	addi	s1,s1,8
    800021a2:	01248563          	beq	s1,s2,800021ac <exit+0x4c>
    if(p->ofile[fd]){
    800021a6:	6088                	ld	a0,0(s1)
    800021a8:	f965                	bnez	a0,80002198 <exit+0x38>
    800021aa:	bfdd                	j	800021a0 <exit+0x40>
  begin_op();
    800021ac:	343010ef          	jal	80003cee <begin_op>
  iput(p->cwd);
    800021b0:	1509b503          	ld	a0,336(s3)
    800021b4:	426010ef          	jal	800035da <iput>
  end_op();
    800021b8:	3a1010ef          	jal	80003d58 <end_op>
  p->cwd = 0;
    800021bc:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800021c0:	00010497          	auipc	s1,0x10
    800021c4:	3e848493          	addi	s1,s1,1000 # 800125a8 <wait_lock>
    800021c8:	8526                	mv	a0,s1
    800021ca:	a39fe0ef          	jal	80000c02 <acquire>
  reparent(p);
    800021ce:	854e                	mv	a0,s3
    800021d0:	f3bff0ef          	jal	8000210a <reparent>
  wakeup(p->parent);
    800021d4:	0389b503          	ld	a0,56(s3)
    800021d8:	ec9ff0ef          	jal	800020a0 <wakeup>
  acquire(&p->lock);
    800021dc:	854e                	mv	a0,s3
    800021de:	a25fe0ef          	jal	80000c02 <acquire>
  p->xstate = status;
    800021e2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800021e6:	4795                	li	a5,5
    800021e8:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800021ec:	8526                	mv	a0,s1
    800021ee:	aadfe0ef          	jal	80000c9a <release>
  sched();
    800021f2:	d7dff0ef          	jal	80001f6e <sched>
  panic("zombie exit");
    800021f6:	00005517          	auipc	a0,0x5
    800021fa:	09a50513          	addi	a0,a0,154 # 80007290 <etext+0x290>
    800021fe:	da4fe0ef          	jal	800007a2 <panic>

0000000080002202 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002202:	7179                	addi	sp,sp,-48
    80002204:	f406                	sd	ra,40(sp)
    80002206:	f022                	sd	s0,32(sp)
    80002208:	ec26                	sd	s1,24(sp)
    8000220a:	e84a                	sd	s2,16(sp)
    8000220c:	e44e                	sd	s3,8(sp)
    8000220e:	1800                	addi	s0,sp,48
    80002210:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002212:	00010497          	auipc	s1,0x10
    80002216:	7ae48493          	addi	s1,s1,1966 # 800129c0 <proc>
    8000221a:	00016997          	auipc	s3,0x16
    8000221e:	3a698993          	addi	s3,s3,934 # 800185c0 <tickslock>
    acquire(&p->lock);
    80002222:	8526                	mv	a0,s1
    80002224:	9dffe0ef          	jal	80000c02 <acquire>
    if(p->pid == pid){
    80002228:	589c                	lw	a5,48(s1)
    8000222a:	01278b63          	beq	a5,s2,80002240 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000222e:	8526                	mv	a0,s1
    80002230:	a6bfe0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002234:	17048493          	addi	s1,s1,368
    80002238:	ff3495e3          	bne	s1,s3,80002222 <kill+0x20>
  }
  return -1;
    8000223c:	557d                	li	a0,-1
    8000223e:	a819                	j	80002254 <kill+0x52>
      p->killed = 1;
    80002240:	4785                	li	a5,1
    80002242:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002244:	4c98                	lw	a4,24(s1)
    80002246:	4789                	li	a5,2
    80002248:	00f70d63          	beq	a4,a5,80002262 <kill+0x60>
      release(&p->lock);
    8000224c:	8526                	mv	a0,s1
    8000224e:	a4dfe0ef          	jal	80000c9a <release>
      return 0;
    80002252:	4501                	li	a0,0
}
    80002254:	70a2                	ld	ra,40(sp)
    80002256:	7402                	ld	s0,32(sp)
    80002258:	64e2                	ld	s1,24(sp)
    8000225a:	6942                	ld	s2,16(sp)
    8000225c:	69a2                	ld	s3,8(sp)
    8000225e:	6145                	addi	sp,sp,48
    80002260:	8082                	ret
        p->state = RUNNABLE;
    80002262:	478d                	li	a5,3
    80002264:	cc9c                	sw	a5,24(s1)
    80002266:	b7dd                	j	8000224c <kill+0x4a>

0000000080002268 <setkilled>:

void
setkilled(struct proc *p)
{
    80002268:	1101                	addi	sp,sp,-32
    8000226a:	ec06                	sd	ra,24(sp)
    8000226c:	e822                	sd	s0,16(sp)
    8000226e:	e426                	sd	s1,8(sp)
    80002270:	1000                	addi	s0,sp,32
    80002272:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002274:	98ffe0ef          	jal	80000c02 <acquire>
  p->killed = 1;
    80002278:	4785                	li	a5,1
    8000227a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000227c:	8526                	mv	a0,s1
    8000227e:	a1dfe0ef          	jal	80000c9a <release>
}
    80002282:	60e2                	ld	ra,24(sp)
    80002284:	6442                	ld	s0,16(sp)
    80002286:	64a2                	ld	s1,8(sp)
    80002288:	6105                	addi	sp,sp,32
    8000228a:	8082                	ret

000000008000228c <killed>:

int
killed(struct proc *p)
{
    8000228c:	1101                	addi	sp,sp,-32
    8000228e:	ec06                	sd	ra,24(sp)
    80002290:	e822                	sd	s0,16(sp)
    80002292:	e426                	sd	s1,8(sp)
    80002294:	e04a                	sd	s2,0(sp)
    80002296:	1000                	addi	s0,sp,32
    80002298:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000229a:	969fe0ef          	jal	80000c02 <acquire>
  k = p->killed;
    8000229e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800022a2:	8526                	mv	a0,s1
    800022a4:	9f7fe0ef          	jal	80000c9a <release>
  return k;
}
    800022a8:	854a                	mv	a0,s2
    800022aa:	60e2                	ld	ra,24(sp)
    800022ac:	6442                	ld	s0,16(sp)
    800022ae:	64a2                	ld	s1,8(sp)
    800022b0:	6902                	ld	s2,0(sp)
    800022b2:	6105                	addi	sp,sp,32
    800022b4:	8082                	ret

00000000800022b6 <wait>:
{
    800022b6:	715d                	addi	sp,sp,-80
    800022b8:	e486                	sd	ra,72(sp)
    800022ba:	e0a2                	sd	s0,64(sp)
    800022bc:	fc26                	sd	s1,56(sp)
    800022be:	f84a                	sd	s2,48(sp)
    800022c0:	f44e                	sd	s3,40(sp)
    800022c2:	f052                	sd	s4,32(sp)
    800022c4:	ec56                	sd	s5,24(sp)
    800022c6:	e85a                	sd	s6,16(sp)
    800022c8:	e45e                	sd	s7,8(sp)
    800022ca:	e062                	sd	s8,0(sp)
    800022cc:	0880                	addi	s0,sp,80
    800022ce:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800022d0:	e42ff0ef          	jal	80001912 <myproc>
    800022d4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800022d6:	00010517          	auipc	a0,0x10
    800022da:	2d250513          	addi	a0,a0,722 # 800125a8 <wait_lock>
    800022de:	925fe0ef          	jal	80000c02 <acquire>
    havekids = 0;
    800022e2:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800022e4:	4a15                	li	s4,5
        havekids = 1;
    800022e6:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800022e8:	00016997          	auipc	s3,0x16
    800022ec:	2d898993          	addi	s3,s3,728 # 800185c0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800022f0:	00010c17          	auipc	s8,0x10
    800022f4:	2b8c0c13          	addi	s8,s8,696 # 800125a8 <wait_lock>
    800022f8:	a871                	j	80002394 <wait+0xde>
          pid = pp->pid;
    800022fa:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800022fe:	000b0c63          	beqz	s6,80002316 <wait+0x60>
    80002302:	4691                	li	a3,4
    80002304:	02c48613          	addi	a2,s1,44
    80002308:	85da                	mv	a1,s6
    8000230a:	05093503          	ld	a0,80(s2)
    8000230e:	a76ff0ef          	jal	80001584 <copyout>
    80002312:	02054b63          	bltz	a0,80002348 <wait+0x92>
          freeproc(pp);
    80002316:	8526                	mv	a0,s1
    80002318:	85dff0ef          	jal	80001b74 <freeproc>
          release(&pp->lock);
    8000231c:	8526                	mv	a0,s1
    8000231e:	97dfe0ef          	jal	80000c9a <release>
          release(&wait_lock);
    80002322:	00010517          	auipc	a0,0x10
    80002326:	28650513          	addi	a0,a0,646 # 800125a8 <wait_lock>
    8000232a:	971fe0ef          	jal	80000c9a <release>
}
    8000232e:	854e                	mv	a0,s3
    80002330:	60a6                	ld	ra,72(sp)
    80002332:	6406                	ld	s0,64(sp)
    80002334:	74e2                	ld	s1,56(sp)
    80002336:	7942                	ld	s2,48(sp)
    80002338:	79a2                	ld	s3,40(sp)
    8000233a:	7a02                	ld	s4,32(sp)
    8000233c:	6ae2                	ld	s5,24(sp)
    8000233e:	6b42                	ld	s6,16(sp)
    80002340:	6ba2                	ld	s7,8(sp)
    80002342:	6c02                	ld	s8,0(sp)
    80002344:	6161                	addi	sp,sp,80
    80002346:	8082                	ret
            release(&pp->lock);
    80002348:	8526                	mv	a0,s1
    8000234a:	951fe0ef          	jal	80000c9a <release>
            release(&wait_lock);
    8000234e:	00010517          	auipc	a0,0x10
    80002352:	25a50513          	addi	a0,a0,602 # 800125a8 <wait_lock>
    80002356:	945fe0ef          	jal	80000c9a <release>
            return -1;
    8000235a:	59fd                	li	s3,-1
    8000235c:	bfc9                	j	8000232e <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000235e:	17048493          	addi	s1,s1,368
    80002362:	03348063          	beq	s1,s3,80002382 <wait+0xcc>
      if(pp->parent == p){
    80002366:	7c9c                	ld	a5,56(s1)
    80002368:	ff279be3          	bne	a5,s2,8000235e <wait+0xa8>
        acquire(&pp->lock);
    8000236c:	8526                	mv	a0,s1
    8000236e:	895fe0ef          	jal	80000c02 <acquire>
        if(pp->state == ZOMBIE){
    80002372:	4c9c                	lw	a5,24(s1)
    80002374:	f94783e3          	beq	a5,s4,800022fa <wait+0x44>
        release(&pp->lock);
    80002378:	8526                	mv	a0,s1
    8000237a:	921fe0ef          	jal	80000c9a <release>
        havekids = 1;
    8000237e:	8756                	mv	a4,s5
    80002380:	bff9                	j	8000235e <wait+0xa8>
    if(!havekids || killed(p)){
    80002382:	cf19                	beqz	a4,800023a0 <wait+0xea>
    80002384:	854a                	mv	a0,s2
    80002386:	f07ff0ef          	jal	8000228c <killed>
    8000238a:	e919                	bnez	a0,800023a0 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000238c:	85e2                	mv	a1,s8
    8000238e:	854a                	mv	a0,s2
    80002390:	cc5ff0ef          	jal	80002054 <sleep>
    havekids = 0;
    80002394:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002396:	00010497          	auipc	s1,0x10
    8000239a:	62a48493          	addi	s1,s1,1578 # 800129c0 <proc>
    8000239e:	b7e1                	j	80002366 <wait+0xb0>
      release(&wait_lock);
    800023a0:	00010517          	auipc	a0,0x10
    800023a4:	20850513          	addi	a0,a0,520 # 800125a8 <wait_lock>
    800023a8:	8f3fe0ef          	jal	80000c9a <release>
      return -1;
    800023ac:	59fd                	li	s3,-1
    800023ae:	b741                	j	8000232e <wait+0x78>

00000000800023b0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800023b0:	7179                	addi	sp,sp,-48
    800023b2:	f406                	sd	ra,40(sp)
    800023b4:	f022                	sd	s0,32(sp)
    800023b6:	ec26                	sd	s1,24(sp)
    800023b8:	e84a                	sd	s2,16(sp)
    800023ba:	e44e                	sd	s3,8(sp)
    800023bc:	e052                	sd	s4,0(sp)
    800023be:	1800                	addi	s0,sp,48
    800023c0:	84aa                	mv	s1,a0
    800023c2:	892e                	mv	s2,a1
    800023c4:	89b2                	mv	s3,a2
    800023c6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800023c8:	d4aff0ef          	jal	80001912 <myproc>
  if(user_dst){
    800023cc:	cc99                	beqz	s1,800023ea <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800023ce:	86d2                	mv	a3,s4
    800023d0:	864e                	mv	a2,s3
    800023d2:	85ca                	mv	a1,s2
    800023d4:	6928                	ld	a0,80(a0)
    800023d6:	9aeff0ef          	jal	80001584 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800023da:	70a2                	ld	ra,40(sp)
    800023dc:	7402                	ld	s0,32(sp)
    800023de:	64e2                	ld	s1,24(sp)
    800023e0:	6942                	ld	s2,16(sp)
    800023e2:	69a2                	ld	s3,8(sp)
    800023e4:	6a02                	ld	s4,0(sp)
    800023e6:	6145                	addi	sp,sp,48
    800023e8:	8082                	ret
    memmove((char *)dst, src, len);
    800023ea:	000a061b          	sext.w	a2,s4
    800023ee:	85ce                	mv	a1,s3
    800023f0:	854a                	mv	a0,s2
    800023f2:	941fe0ef          	jal	80000d32 <memmove>
    return 0;
    800023f6:	8526                	mv	a0,s1
    800023f8:	b7cd                	j	800023da <either_copyout+0x2a>

00000000800023fa <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800023fa:	7179                	addi	sp,sp,-48
    800023fc:	f406                	sd	ra,40(sp)
    800023fe:	f022                	sd	s0,32(sp)
    80002400:	ec26                	sd	s1,24(sp)
    80002402:	e84a                	sd	s2,16(sp)
    80002404:	e44e                	sd	s3,8(sp)
    80002406:	e052                	sd	s4,0(sp)
    80002408:	1800                	addi	s0,sp,48
    8000240a:	892a                	mv	s2,a0
    8000240c:	84ae                	mv	s1,a1
    8000240e:	89b2                	mv	s3,a2
    80002410:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002412:	d00ff0ef          	jal	80001912 <myproc>
  if(user_src){
    80002416:	cc99                	beqz	s1,80002434 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002418:	86d2                	mv	a3,s4
    8000241a:	864e                	mv	a2,s3
    8000241c:	85ca                	mv	a1,s2
    8000241e:	6928                	ld	a0,80(a0)
    80002420:	a3aff0ef          	jal	8000165a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002424:	70a2                	ld	ra,40(sp)
    80002426:	7402                	ld	s0,32(sp)
    80002428:	64e2                	ld	s1,24(sp)
    8000242a:	6942                	ld	s2,16(sp)
    8000242c:	69a2                	ld	s3,8(sp)
    8000242e:	6a02                	ld	s4,0(sp)
    80002430:	6145                	addi	sp,sp,48
    80002432:	8082                	ret
    memmove(dst, (char*)src, len);
    80002434:	000a061b          	sext.w	a2,s4
    80002438:	85ce                	mv	a1,s3
    8000243a:	854a                	mv	a0,s2
    8000243c:	8f7fe0ef          	jal	80000d32 <memmove>
    return 0;
    80002440:	8526                	mv	a0,s1
    80002442:	b7cd                	j	80002424 <either_copyin+0x2a>

0000000080002444 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002444:	715d                	addi	sp,sp,-80
    80002446:	e486                	sd	ra,72(sp)
    80002448:	e0a2                	sd	s0,64(sp)
    8000244a:	fc26                	sd	s1,56(sp)
    8000244c:	f84a                	sd	s2,48(sp)
    8000244e:	f44e                	sd	s3,40(sp)
    80002450:	f052                	sd	s4,32(sp)
    80002452:	ec56                	sd	s5,24(sp)
    80002454:	e85a                	sd	s6,16(sp)
    80002456:	e45e                	sd	s7,8(sp)
    80002458:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000245a:	00005517          	auipc	a0,0x5
    8000245e:	c1e50513          	addi	a0,a0,-994 # 80007078 <etext+0x78>
    80002462:	86efe0ef          	jal	800004d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002466:	00010497          	auipc	s1,0x10
    8000246a:	6b248493          	addi	s1,s1,1714 # 80012b18 <proc+0x158>
    8000246e:	00016917          	auipc	s2,0x16
    80002472:	2aa90913          	addi	s2,s2,682 # 80018718 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002476:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002478:	00005997          	auipc	s3,0x5
    8000247c:	e2898993          	addi	s3,s3,-472 # 800072a0 <etext+0x2a0>
    printf("%d %s %s", p->pid, state, p->name);
    80002480:	00005a97          	auipc	s5,0x5
    80002484:	e28a8a93          	addi	s5,s5,-472 # 800072a8 <etext+0x2a8>
    printf("\n");
    80002488:	00005a17          	auipc	s4,0x5
    8000248c:	bf0a0a13          	addi	s4,s4,-1040 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002490:	00005b97          	auipc	s7,0x5
    80002494:	308b8b93          	addi	s7,s7,776 # 80007798 <states.0>
    80002498:	a829                	j	800024b2 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000249a:	ed86a583          	lw	a1,-296(a3)
    8000249e:	8556                	mv	a0,s5
    800024a0:	830fe0ef          	jal	800004d0 <printf>
    printf("\n");
    800024a4:	8552                	mv	a0,s4
    800024a6:	82afe0ef          	jal	800004d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800024aa:	17048493          	addi	s1,s1,368
    800024ae:	03248263          	beq	s1,s2,800024d2 <procdump+0x8e>
    if(p->state == UNUSED)
    800024b2:	86a6                	mv	a3,s1
    800024b4:	ec04a783          	lw	a5,-320(s1)
    800024b8:	dbed                	beqz	a5,800024aa <procdump+0x66>
      state = "???";
    800024ba:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800024bc:	fcfb6fe3          	bltu	s6,a5,8000249a <procdump+0x56>
    800024c0:	02079713          	slli	a4,a5,0x20
    800024c4:	01d75793          	srli	a5,a4,0x1d
    800024c8:	97de                	add	a5,a5,s7
    800024ca:	6390                	ld	a2,0(a5)
    800024cc:	f679                	bnez	a2,8000249a <procdump+0x56>
      state = "???";
    800024ce:	864e                	mv	a2,s3
    800024d0:	b7e9                	j	8000249a <procdump+0x56>
  }
    800024d2:	60a6                	ld	ra,72(sp)
    800024d4:	6406                	ld	s0,64(sp)
    800024d6:	74e2                	ld	s1,56(sp)
    800024d8:	7942                	ld	s2,48(sp)
    800024da:	79a2                	ld	s3,40(sp)
    800024dc:	7a02                	ld	s4,32(sp)
    800024de:	6ae2                	ld	s5,24(sp)
    800024e0:	6b42                	ld	s6,16(sp)
    800024e2:	6ba2                	ld	s7,8(sp)
    800024e4:	6161                	addi	sp,sp,80
    800024e6:	8082                	ret

00000000800024e8 <swtch>:
    800024e8:	00153023          	sd	ra,0(a0)
    800024ec:	00253423          	sd	sp,8(a0)
    800024f0:	e900                	sd	s0,16(a0)
    800024f2:	ed04                	sd	s1,24(a0)
    800024f4:	03253023          	sd	s2,32(a0)
    800024f8:	03353423          	sd	s3,40(a0)
    800024fc:	03453823          	sd	s4,48(a0)
    80002500:	03553c23          	sd	s5,56(a0)
    80002504:	05653023          	sd	s6,64(a0)
    80002508:	05753423          	sd	s7,72(a0)
    8000250c:	05853823          	sd	s8,80(a0)
    80002510:	05953c23          	sd	s9,88(a0)
    80002514:	07a53023          	sd	s10,96(a0)
    80002518:	07b53423          	sd	s11,104(a0)
    8000251c:	0005b083          	ld	ra,0(a1)
    80002520:	0085b103          	ld	sp,8(a1)
    80002524:	6980                	ld	s0,16(a1)
    80002526:	6d84                	ld	s1,24(a1)
    80002528:	0205b903          	ld	s2,32(a1)
    8000252c:	0285b983          	ld	s3,40(a1)
    80002530:	0305ba03          	ld	s4,48(a1)
    80002534:	0385ba83          	ld	s5,56(a1)
    80002538:	0405bb03          	ld	s6,64(a1)
    8000253c:	0485bb83          	ld	s7,72(a1)
    80002540:	0505bc03          	ld	s8,80(a1)
    80002544:	0585bc83          	ld	s9,88(a1)
    80002548:	0605bd03          	ld	s10,96(a1)
    8000254c:	0685bd83          	ld	s11,104(a1)
    80002550:	8082                	ret

0000000080002552 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002552:	1141                	addi	sp,sp,-16
    80002554:	e406                	sd	ra,8(sp)
    80002556:	e022                	sd	s0,0(sp)
    80002558:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000255a:	00005597          	auipc	a1,0x5
    8000255e:	d8e58593          	addi	a1,a1,-626 # 800072e8 <etext+0x2e8>
    80002562:	00016517          	auipc	a0,0x16
    80002566:	05e50513          	addi	a0,a0,94 # 800185c0 <tickslock>
    8000256a:	e18fe0ef          	jal	80000b82 <initlock>
}
    8000256e:	60a2                	ld	ra,8(sp)
    80002570:	6402                	ld	s0,0(sp)
    80002572:	0141                	addi	sp,sp,16
    80002574:	8082                	ret

0000000080002576 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002576:	1141                	addi	sp,sp,-16
    80002578:	e422                	sd	s0,8(sp)
    8000257a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000257c:	00003797          	auipc	a5,0x3
    80002580:	ef478793          	addi	a5,a5,-268 # 80005470 <kernelvec>
    80002584:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002588:	6422                	ld	s0,8(sp)
    8000258a:	0141                	addi	sp,sp,16
    8000258c:	8082                	ret

000000008000258e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000258e:	1141                	addi	sp,sp,-16
    80002590:	e406                	sd	ra,8(sp)
    80002592:	e022                	sd	s0,0(sp)
    80002594:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002596:	b7cff0ef          	jal	80001912 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000259a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000259e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025a0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800025a4:	00004697          	auipc	a3,0x4
    800025a8:	a5c68693          	addi	a3,a3,-1444 # 80006000 <_trampoline>
    800025ac:	00004717          	auipc	a4,0x4
    800025b0:	a5470713          	addi	a4,a4,-1452 # 80006000 <_trampoline>
    800025b4:	8f15                	sub	a4,a4,a3
    800025b6:	040007b7          	lui	a5,0x4000
    800025ba:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800025bc:	07b2                	slli	a5,a5,0xc
    800025be:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025c0:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800025c4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800025c6:	18002673          	csrr	a2,satp
    800025ca:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800025cc:	6d30                	ld	a2,88(a0)
    800025ce:	6138                	ld	a4,64(a0)
    800025d0:	6585                	lui	a1,0x1
    800025d2:	972e                	add	a4,a4,a1
    800025d4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800025d6:	6d38                	ld	a4,88(a0)
    800025d8:	00000617          	auipc	a2,0x0
    800025dc:	11a60613          	addi	a2,a2,282 # 800026f2 <usertrap>
    800025e0:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800025e2:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800025e4:	8612                	mv	a2,tp
    800025e6:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025e8:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800025ec:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800025f0:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025f4:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800025f8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800025fa:	6f18                	ld	a4,24(a4)
    800025fc:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002600:	6928                	ld	a0,80(a0)
    80002602:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002604:	00004717          	auipc	a4,0x4
    80002608:	a9870713          	addi	a4,a4,-1384 # 8000609c <userret>
    8000260c:	8f15                	sub	a4,a4,a3
    8000260e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002610:	577d                	li	a4,-1
    80002612:	177e                	slli	a4,a4,0x3f
    80002614:	8d59                	or	a0,a0,a4
    80002616:	9782                	jalr	a5
}
    80002618:	60a2                	ld	ra,8(sp)
    8000261a:	6402                	ld	s0,0(sp)
    8000261c:	0141                	addi	sp,sp,16
    8000261e:	8082                	ret

0000000080002620 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002620:	1101                	addi	sp,sp,-32
    80002622:	ec06                	sd	ra,24(sp)
    80002624:	e822                	sd	s0,16(sp)
    80002626:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80002628:	abeff0ef          	jal	800018e6 <cpuid>
    8000262c:	cd11                	beqz	a0,80002648 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000262e:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002632:	000f4737          	lui	a4,0xf4
    80002636:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000263a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000263c:	14d79073          	csrw	stimecmp,a5
}
    80002640:	60e2                	ld	ra,24(sp)
    80002642:	6442                	ld	s0,16(sp)
    80002644:	6105                	addi	sp,sp,32
    80002646:	8082                	ret
    80002648:	e426                	sd	s1,8(sp)
    8000264a:	e04a                	sd	s2,0(sp)
    acquire(&tickslock);
    8000264c:	00016917          	auipc	s2,0x16
    80002650:	f7490913          	addi	s2,s2,-140 # 800185c0 <tickslock>
    80002654:	854a                	mv	a0,s2
    80002656:	dacfe0ef          	jal	80000c02 <acquire>
    ticks++;
    8000265a:	00008497          	auipc	s1,0x8
    8000265e:	dfe48493          	addi	s1,s1,-514 # 8000a458 <ticks>
    80002662:	409c                	lw	a5,0(s1)
    80002664:	2785                	addiw	a5,a5,1
    80002666:	c09c                	sw	a5,0(s1)
    update_time();
    80002668:	fdeff0ef          	jal	80001e46 <update_time>
    wakeup(&ticks);
    8000266c:	8526                	mv	a0,s1
    8000266e:	a33ff0ef          	jal	800020a0 <wakeup>
    release(&tickslock);
    80002672:	854a                	mv	a0,s2
    80002674:	e26fe0ef          	jal	80000c9a <release>
    80002678:	64a2                	ld	s1,8(sp)
    8000267a:	6902                	ld	s2,0(sp)
    8000267c:	bf4d                	j	8000262e <clockintr+0xe>

000000008000267e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000267e:	1101                	addi	sp,sp,-32
    80002680:	ec06                	sd	ra,24(sp)
    80002682:	e822                	sd	s0,16(sp)
    80002684:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002686:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    8000268a:	57fd                	li	a5,-1
    8000268c:	17fe                	slli	a5,a5,0x3f
    8000268e:	07a5                	addi	a5,a5,9
    80002690:	00f70c63          	beq	a4,a5,800026a8 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002694:	57fd                	li	a5,-1
    80002696:	17fe                	slli	a5,a5,0x3f
    80002698:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000269a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000269c:	04f70763          	beq	a4,a5,800026ea <devintr+0x6c>
  }
}
    800026a0:	60e2                	ld	ra,24(sp)
    800026a2:	6442                	ld	s0,16(sp)
    800026a4:	6105                	addi	sp,sp,32
    800026a6:	8082                	ret
    800026a8:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800026aa:	673020ef          	jal	8000551c <plic_claim>
    800026ae:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800026b0:	47a9                	li	a5,10
    800026b2:	00f50963          	beq	a0,a5,800026c4 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800026b6:	4785                	li	a5,1
    800026b8:	00f50963          	beq	a0,a5,800026ca <devintr+0x4c>
    return 1;
    800026bc:	4505                	li	a0,1
    } else if(irq){
    800026be:	e889                	bnez	s1,800026d0 <devintr+0x52>
    800026c0:	64a2                	ld	s1,8(sp)
    800026c2:	bff9                	j	800026a0 <devintr+0x22>
      uartintr();
    800026c4:	b50fe0ef          	jal	80000a14 <uartintr>
    if(irq)
    800026c8:	a819                	j	800026de <devintr+0x60>
      virtio_disk_intr();
    800026ca:	318030ef          	jal	800059e2 <virtio_disk_intr>
    if(irq)
    800026ce:	a801                	j	800026de <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800026d0:	85a6                	mv	a1,s1
    800026d2:	00005517          	auipc	a0,0x5
    800026d6:	c1e50513          	addi	a0,a0,-994 # 800072f0 <etext+0x2f0>
    800026da:	df7fd0ef          	jal	800004d0 <printf>
      plic_complete(irq);
    800026de:	8526                	mv	a0,s1
    800026e0:	65d020ef          	jal	8000553c <plic_complete>
    return 1;
    800026e4:	4505                	li	a0,1
    800026e6:	64a2                	ld	s1,8(sp)
    800026e8:	bf65                	j	800026a0 <devintr+0x22>
    clockintr();
    800026ea:	f37ff0ef          	jal	80002620 <clockintr>
    return 2;
    800026ee:	4509                	li	a0,2
    800026f0:	bf45                	j	800026a0 <devintr+0x22>

00000000800026f2 <usertrap>:
{
    800026f2:	1101                	addi	sp,sp,-32
    800026f4:	ec06                	sd	ra,24(sp)
    800026f6:	e822                	sd	s0,16(sp)
    800026f8:	e426                	sd	s1,8(sp)
    800026fa:	e04a                	sd	s2,0(sp)
    800026fc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026fe:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002702:	1007f793          	andi	a5,a5,256
    80002706:	ef85                	bnez	a5,8000273e <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002708:	00003797          	auipc	a5,0x3
    8000270c:	d6878793          	addi	a5,a5,-664 # 80005470 <kernelvec>
    80002710:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002714:	9feff0ef          	jal	80001912 <myproc>
    80002718:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000271a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000271c:	14102773          	csrr	a4,sepc
    80002720:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002722:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002726:	47a1                	li	a5,8
    80002728:	02f70163          	beq	a4,a5,8000274a <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    8000272c:	f53ff0ef          	jal	8000267e <devintr>
    80002730:	892a                	mv	s2,a0
    80002732:	c135                	beqz	a0,80002796 <usertrap+0xa4>
  if(killed(p))
    80002734:	8526                	mv	a0,s1
    80002736:	b57ff0ef          	jal	8000228c <killed>
    8000273a:	cd1d                	beqz	a0,80002778 <usertrap+0x86>
    8000273c:	a81d                	j	80002772 <usertrap+0x80>
    panic("usertrap: not from user mode");
    8000273e:	00005517          	auipc	a0,0x5
    80002742:	bd250513          	addi	a0,a0,-1070 # 80007310 <etext+0x310>
    80002746:	85cfe0ef          	jal	800007a2 <panic>
    if(killed(p))
    8000274a:	b43ff0ef          	jal	8000228c <killed>
    8000274e:	e121                	bnez	a0,8000278e <usertrap+0x9c>
    p->trapframe->epc += 4;
    80002750:	6cb8                	ld	a4,88(s1)
    80002752:	6f1c                	ld	a5,24(a4)
    80002754:	0791                	addi	a5,a5,4
    80002756:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002758:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000275c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002760:	10079073          	csrw	sstatus,a5
    syscall();
    80002764:	24a000ef          	jal	800029ae <syscall>
  if(killed(p))
    80002768:	8526                	mv	a0,s1
    8000276a:	b23ff0ef          	jal	8000228c <killed>
    8000276e:	c901                	beqz	a0,8000277e <usertrap+0x8c>
    80002770:	4901                	li	s2,0
    exit(-1);
    80002772:	557d                	li	a0,-1
    80002774:	9edff0ef          	jal	80002160 <exit>
  if(which_dev == 2)
    80002778:	4789                	li	a5,2
    8000277a:	04f90563          	beq	s2,a5,800027c4 <usertrap+0xd2>
  usertrapret();
    8000277e:	e11ff0ef          	jal	8000258e <usertrapret>
}
    80002782:	60e2                	ld	ra,24(sp)
    80002784:	6442                	ld	s0,16(sp)
    80002786:	64a2                	ld	s1,8(sp)
    80002788:	6902                	ld	s2,0(sp)
    8000278a:	6105                	addi	sp,sp,32
    8000278c:	8082                	ret
      exit(-1);
    8000278e:	557d                	li	a0,-1
    80002790:	9d1ff0ef          	jal	80002160 <exit>
    80002794:	bf75                	j	80002750 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002796:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000279a:	5890                	lw	a2,48(s1)
    8000279c:	00005517          	auipc	a0,0x5
    800027a0:	b9450513          	addi	a0,a0,-1132 # 80007330 <etext+0x330>
    800027a4:	d2dfd0ef          	jal	800004d0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027a8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800027ac:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800027b0:	00005517          	auipc	a0,0x5
    800027b4:	bb050513          	addi	a0,a0,-1104 # 80007360 <etext+0x360>
    800027b8:	d19fd0ef          	jal	800004d0 <printf>
    setkilled(p);
    800027bc:	8526                	mv	a0,s1
    800027be:	aabff0ef          	jal	80002268 <setkilled>
    800027c2:	b75d                	j	80002768 <usertrap+0x76>
    yield();
    800027c4:	865ff0ef          	jal	80002028 <yield>
    800027c8:	bf5d                	j	8000277e <usertrap+0x8c>

00000000800027ca <kerneltrap>:
{
    800027ca:	7179                	addi	sp,sp,-48
    800027cc:	f406                	sd	ra,40(sp)
    800027ce:	f022                	sd	s0,32(sp)
    800027d0:	ec26                	sd	s1,24(sp)
    800027d2:	e84a                	sd	s2,16(sp)
    800027d4:	e44e                	sd	s3,8(sp)
    800027d6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027d8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027dc:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027e0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800027e4:	1004f793          	andi	a5,s1,256
    800027e8:	c795                	beqz	a5,80002814 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027ea:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800027ee:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800027f0:	eb85                	bnez	a5,80002820 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    800027f2:	e8dff0ef          	jal	8000267e <devintr>
    800027f6:	c91d                	beqz	a0,8000282c <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    800027f8:	4789                	li	a5,2
    800027fa:	04f50a63          	beq	a0,a5,8000284e <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800027fe:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002802:	10049073          	csrw	sstatus,s1
}
    80002806:	70a2                	ld	ra,40(sp)
    80002808:	7402                	ld	s0,32(sp)
    8000280a:	64e2                	ld	s1,24(sp)
    8000280c:	6942                	ld	s2,16(sp)
    8000280e:	69a2                	ld	s3,8(sp)
    80002810:	6145                	addi	sp,sp,48
    80002812:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002814:	00005517          	auipc	a0,0x5
    80002818:	b7450513          	addi	a0,a0,-1164 # 80007388 <etext+0x388>
    8000281c:	f87fd0ef          	jal	800007a2 <panic>
    panic("kerneltrap: interrupts enabled");
    80002820:	00005517          	auipc	a0,0x5
    80002824:	b9050513          	addi	a0,a0,-1136 # 800073b0 <etext+0x3b0>
    80002828:	f7bfd0ef          	jal	800007a2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000282c:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002830:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002834:	85ce                	mv	a1,s3
    80002836:	00005517          	auipc	a0,0x5
    8000283a:	b9a50513          	addi	a0,a0,-1126 # 800073d0 <etext+0x3d0>
    8000283e:	c93fd0ef          	jal	800004d0 <printf>
    panic("kerneltrap");
    80002842:	00005517          	auipc	a0,0x5
    80002846:	bb650513          	addi	a0,a0,-1098 # 800073f8 <etext+0x3f8>
    8000284a:	f59fd0ef          	jal	800007a2 <panic>
  if(which_dev == 2 && myproc() != 0)
    8000284e:	8c4ff0ef          	jal	80001912 <myproc>
    80002852:	d555                	beqz	a0,800027fe <kerneltrap+0x34>
    yield();
    80002854:	fd4ff0ef          	jal	80002028 <yield>
    80002858:	b75d                	j	800027fe <kerneltrap+0x34>

000000008000285a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000285a:	1101                	addi	sp,sp,-32
    8000285c:	ec06                	sd	ra,24(sp)
    8000285e:	e822                	sd	s0,16(sp)
    80002860:	e426                	sd	s1,8(sp)
    80002862:	1000                	addi	s0,sp,32
    80002864:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002866:	8acff0ef          	jal	80001912 <myproc>
  switch (n) {
    8000286a:	4795                	li	a5,5
    8000286c:	0497e163          	bltu	a5,s1,800028ae <argraw+0x54>
    80002870:	048a                	slli	s1,s1,0x2
    80002872:	00005717          	auipc	a4,0x5
    80002876:	f5670713          	addi	a4,a4,-170 # 800077c8 <states.0+0x30>
    8000287a:	94ba                	add	s1,s1,a4
    8000287c:	409c                	lw	a5,0(s1)
    8000287e:	97ba                	add	a5,a5,a4
    80002880:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002882:	6d3c                	ld	a5,88(a0)
    80002884:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002886:	60e2                	ld	ra,24(sp)
    80002888:	6442                	ld	s0,16(sp)
    8000288a:	64a2                	ld	s1,8(sp)
    8000288c:	6105                	addi	sp,sp,32
    8000288e:	8082                	ret
    return p->trapframe->a1;
    80002890:	6d3c                	ld	a5,88(a0)
    80002892:	7fa8                	ld	a0,120(a5)
    80002894:	bfcd                	j	80002886 <argraw+0x2c>
    return p->trapframe->a2;
    80002896:	6d3c                	ld	a5,88(a0)
    80002898:	63c8                	ld	a0,128(a5)
    8000289a:	b7f5                	j	80002886 <argraw+0x2c>
    return p->trapframe->a3;
    8000289c:	6d3c                	ld	a5,88(a0)
    8000289e:	67c8                	ld	a0,136(a5)
    800028a0:	b7dd                	j	80002886 <argraw+0x2c>
    return p->trapframe->a4;
    800028a2:	6d3c                	ld	a5,88(a0)
    800028a4:	6bc8                	ld	a0,144(a5)
    800028a6:	b7c5                	j	80002886 <argraw+0x2c>
    return p->trapframe->a5;
    800028a8:	6d3c                	ld	a5,88(a0)
    800028aa:	6fc8                	ld	a0,152(a5)
    800028ac:	bfe9                	j	80002886 <argraw+0x2c>
  panic("argraw");
    800028ae:	00005517          	auipc	a0,0x5
    800028b2:	b5a50513          	addi	a0,a0,-1190 # 80007408 <etext+0x408>
    800028b6:	eedfd0ef          	jal	800007a2 <panic>

00000000800028ba <fetchaddr>:
{
    800028ba:	1101                	addi	sp,sp,-32
    800028bc:	ec06                	sd	ra,24(sp)
    800028be:	e822                	sd	s0,16(sp)
    800028c0:	e426                	sd	s1,8(sp)
    800028c2:	e04a                	sd	s2,0(sp)
    800028c4:	1000                	addi	s0,sp,32
    800028c6:	84aa                	mv	s1,a0
    800028c8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800028ca:	848ff0ef          	jal	80001912 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800028ce:	653c                	ld	a5,72(a0)
    800028d0:	02f4f663          	bgeu	s1,a5,800028fc <fetchaddr+0x42>
    800028d4:	00848713          	addi	a4,s1,8
    800028d8:	02e7e463          	bltu	a5,a4,80002900 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800028dc:	46a1                	li	a3,8
    800028de:	8626                	mv	a2,s1
    800028e0:	85ca                	mv	a1,s2
    800028e2:	6928                	ld	a0,80(a0)
    800028e4:	d77fe0ef          	jal	8000165a <copyin>
    800028e8:	00a03533          	snez	a0,a0
    800028ec:	40a00533          	neg	a0,a0
}
    800028f0:	60e2                	ld	ra,24(sp)
    800028f2:	6442                	ld	s0,16(sp)
    800028f4:	64a2                	ld	s1,8(sp)
    800028f6:	6902                	ld	s2,0(sp)
    800028f8:	6105                	addi	sp,sp,32
    800028fa:	8082                	ret
    return -1;
    800028fc:	557d                	li	a0,-1
    800028fe:	bfcd                	j	800028f0 <fetchaddr+0x36>
    80002900:	557d                	li	a0,-1
    80002902:	b7fd                	j	800028f0 <fetchaddr+0x36>

0000000080002904 <fetchstr>:
{
    80002904:	7179                	addi	sp,sp,-48
    80002906:	f406                	sd	ra,40(sp)
    80002908:	f022                	sd	s0,32(sp)
    8000290a:	ec26                	sd	s1,24(sp)
    8000290c:	e84a                	sd	s2,16(sp)
    8000290e:	e44e                	sd	s3,8(sp)
    80002910:	1800                	addi	s0,sp,48
    80002912:	892a                	mv	s2,a0
    80002914:	84ae                	mv	s1,a1
    80002916:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002918:	ffbfe0ef          	jal	80001912 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000291c:	86ce                	mv	a3,s3
    8000291e:	864a                	mv	a2,s2
    80002920:	85a6                	mv	a1,s1
    80002922:	6928                	ld	a0,80(a0)
    80002924:	dbdfe0ef          	jal	800016e0 <copyinstr>
    80002928:	00054c63          	bltz	a0,80002940 <fetchstr+0x3c>
  return strlen(buf);
    8000292c:	8526                	mv	a0,s1
    8000292e:	d18fe0ef          	jal	80000e46 <strlen>
}
    80002932:	70a2                	ld	ra,40(sp)
    80002934:	7402                	ld	s0,32(sp)
    80002936:	64e2                	ld	s1,24(sp)
    80002938:	6942                	ld	s2,16(sp)
    8000293a:	69a2                	ld	s3,8(sp)
    8000293c:	6145                	addi	sp,sp,48
    8000293e:	8082                	ret
    return -1;
    80002940:	557d                	li	a0,-1
    80002942:	bfc5                	j	80002932 <fetchstr+0x2e>

0000000080002944 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002944:	1101                	addi	sp,sp,-32
    80002946:	ec06                	sd	ra,24(sp)
    80002948:	e822                	sd	s0,16(sp)
    8000294a:	e426                	sd	s1,8(sp)
    8000294c:	1000                	addi	s0,sp,32
    8000294e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002950:	f0bff0ef          	jal	8000285a <argraw>
    80002954:	c088                	sw	a0,0(s1)
}
    80002956:	60e2                	ld	ra,24(sp)
    80002958:	6442                	ld	s0,16(sp)
    8000295a:	64a2                	ld	s1,8(sp)
    8000295c:	6105                	addi	sp,sp,32
    8000295e:	8082                	ret

0000000080002960 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002960:	1101                	addi	sp,sp,-32
    80002962:	ec06                	sd	ra,24(sp)
    80002964:	e822                	sd	s0,16(sp)
    80002966:	e426                	sd	s1,8(sp)
    80002968:	1000                	addi	s0,sp,32
    8000296a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000296c:	eefff0ef          	jal	8000285a <argraw>
    80002970:	e088                	sd	a0,0(s1)
   return 0;
}
    80002972:	4501                	li	a0,0
    80002974:	60e2                	ld	ra,24(sp)
    80002976:	6442                	ld	s0,16(sp)
    80002978:	64a2                	ld	s1,8(sp)
    8000297a:	6105                	addi	sp,sp,32
    8000297c:	8082                	ret

000000008000297e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000297e:	7179                	addi	sp,sp,-48
    80002980:	f406                	sd	ra,40(sp)
    80002982:	f022                	sd	s0,32(sp)
    80002984:	ec26                	sd	s1,24(sp)
    80002986:	e84a                	sd	s2,16(sp)
    80002988:	1800                	addi	s0,sp,48
    8000298a:	84ae                	mv	s1,a1
    8000298c:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000298e:	fd840593          	addi	a1,s0,-40
    80002992:	fcfff0ef          	jal	80002960 <argaddr>
  return fetchstr(addr, buf, max);
    80002996:	864a                	mv	a2,s2
    80002998:	85a6                	mv	a1,s1
    8000299a:	fd843503          	ld	a0,-40(s0)
    8000299e:	f67ff0ef          	jal	80002904 <fetchstr>
}
    800029a2:	70a2                	ld	ra,40(sp)
    800029a4:	7402                	ld	s0,32(sp)
    800029a6:	64e2                	ld	s1,24(sp)
    800029a8:	6942                	ld	s2,16(sp)
    800029aa:	6145                	addi	sp,sp,48
    800029ac:	8082                	ret

00000000800029ae <syscall>:

};

void
syscall(void)
{
    800029ae:	1101                	addi	sp,sp,-32
    800029b0:	ec06                	sd	ra,24(sp)
    800029b2:	e822                	sd	s0,16(sp)
    800029b4:	e426                	sd	s1,8(sp)
    800029b6:	e04a                	sd	s2,0(sp)
    800029b8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800029ba:	f59fe0ef          	jal	80001912 <myproc>
    800029be:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800029c0:	05853903          	ld	s2,88(a0)
    800029c4:	0a893783          	ld	a5,168(s2)
    800029c8:	0007869b          	sext.w	a3,a5
  syscall_count++; 
    800029cc:	00008617          	auipc	a2,0x8
    800029d0:	a9460613          	addi	a2,a2,-1388 # 8000a460 <syscall_count>
    800029d4:	6218                	ld	a4,0(a2)
    800029d6:	0705                	addi	a4,a4,1
    800029d8:	e218                	sd	a4,0(a2)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800029da:	37fd                	addiw	a5,a5,-1
    800029dc:	476d                	li	a4,27
    800029de:	00f76f63          	bltu	a4,a5,800029fc <syscall+0x4e>
    800029e2:	00369713          	slli	a4,a3,0x3
    800029e6:	00005797          	auipc	a5,0x5
    800029ea:	dfa78793          	addi	a5,a5,-518 # 800077e0 <syscalls>
    800029ee:	97ba                	add	a5,a5,a4
    800029f0:	639c                	ld	a5,0(a5)
    800029f2:	c789                	beqz	a5,800029fc <syscall+0x4e>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800029f4:	9782                	jalr	a5
    800029f6:	06a93823          	sd	a0,112(s2)
    800029fa:	a829                	j	80002a14 <syscall+0x66>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800029fc:	15848613          	addi	a2,s1,344
    80002a00:	588c                	lw	a1,48(s1)
    80002a02:	00005517          	auipc	a0,0x5
    80002a06:	a0e50513          	addi	a0,a0,-1522 # 80007410 <etext+0x410>
    80002a0a:	ac7fd0ef          	jal	800004d0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002a0e:	6cbc                	ld	a5,88(s1)
    80002a10:	577d                	li	a4,-1
    80002a12:	fbb8                	sd	a4,112(a5)
  }
    80002a14:	60e2                	ld	ra,24(sp)
    80002a16:	6442                	ld	s0,16(sp)
    80002a18:	64a2                	ld	s1,8(sp)
    80002a1a:	6902                	ld	s2,0(sp)
    80002a1c:	6105                	addi	sp,sp,32
    80002a1e:	8082                	ret

0000000080002a20 <sys_exit>:
#include "proc.h"
//#include "date.h"   

uint64
sys_exit(void)
{
    80002a20:	1101                	addi	sp,sp,-32
    80002a22:	ec06                	sd	ra,24(sp)
    80002a24:	e822                	sd	s0,16(sp)
    80002a26:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002a28:	fec40593          	addi	a1,s0,-20
    80002a2c:	4501                	li	a0,0
    80002a2e:	f17ff0ef          	jal	80002944 <argint>
  exit(n);
    80002a32:	fec42503          	lw	a0,-20(s0)
    80002a36:	f2aff0ef          	jal	80002160 <exit>
  return 0;  // not reached
}
    80002a3a:	4501                	li	a0,0
    80002a3c:	60e2                	ld	ra,24(sp)
    80002a3e:	6442                	ld	s0,16(sp)
    80002a40:	6105                	addi	sp,sp,32
    80002a42:	8082                	ret

0000000080002a44 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002a44:	1141                	addi	sp,sp,-16
    80002a46:	e406                	sd	ra,8(sp)
    80002a48:	e022                	sd	s0,0(sp)
    80002a4a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002a4c:	ec7fe0ef          	jal	80001912 <myproc>
}
    80002a50:	5908                	lw	a0,48(a0)
    80002a52:	60a2                	ld	ra,8(sp)
    80002a54:	6402                	ld	s0,0(sp)
    80002a56:	0141                	addi	sp,sp,16
    80002a58:	8082                	ret

0000000080002a5a <sys_fork>:

uint64
sys_fork(void)
{
    80002a5a:	1141                	addi	sp,sp,-16
    80002a5c:	e406                	sd	ra,8(sp)
    80002a5e:	e022                	sd	s0,0(sp)
    80002a60:	0800                	addi	s0,sp,16
  return fork();
    80002a62:	ad6ff0ef          	jal	80001d38 <fork>
}
    80002a66:	60a2                	ld	ra,8(sp)
    80002a68:	6402                	ld	s0,0(sp)
    80002a6a:	0141                	addi	sp,sp,16
    80002a6c:	8082                	ret

0000000080002a6e <sys_wait>:

uint64
sys_wait(void)
{
    80002a6e:	1101                	addi	sp,sp,-32
    80002a70:	ec06                	sd	ra,24(sp)
    80002a72:	e822                	sd	s0,16(sp)
    80002a74:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002a76:	fe840593          	addi	a1,s0,-24
    80002a7a:	4501                	li	a0,0
    80002a7c:	ee5ff0ef          	jal	80002960 <argaddr>
  return wait(p);
    80002a80:	fe843503          	ld	a0,-24(s0)
    80002a84:	833ff0ef          	jal	800022b6 <wait>
}
    80002a88:	60e2                	ld	ra,24(sp)
    80002a8a:	6442                	ld	s0,16(sp)
    80002a8c:	6105                	addi	sp,sp,32
    80002a8e:	8082                	ret

0000000080002a90 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002a90:	7179                	addi	sp,sp,-48
    80002a92:	f406                	sd	ra,40(sp)
    80002a94:	f022                	sd	s0,32(sp)
    80002a96:	ec26                	sd	s1,24(sp)
    80002a98:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002a9a:	fdc40593          	addi	a1,s0,-36
    80002a9e:	4501                	li	a0,0
    80002aa0:	ea5ff0ef          	jal	80002944 <argint>
  addr = myproc()->sz;
    80002aa4:	e6ffe0ef          	jal	80001912 <myproc>
    80002aa8:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002aaa:	fdc42503          	lw	a0,-36(s0)
    80002aae:	a3aff0ef          	jal	80001ce8 <growproc>
    80002ab2:	00054863          	bltz	a0,80002ac2 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002ab6:	8526                	mv	a0,s1
    80002ab8:	70a2                	ld	ra,40(sp)
    80002aba:	7402                	ld	s0,32(sp)
    80002abc:	64e2                	ld	s1,24(sp)
    80002abe:	6145                	addi	sp,sp,48
    80002ac0:	8082                	ret
    return -1;
    80002ac2:	54fd                	li	s1,-1
    80002ac4:	bfcd                	j	80002ab6 <sys_sbrk+0x26>

0000000080002ac6 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002ac6:	7139                	addi	sp,sp,-64
    80002ac8:	fc06                	sd	ra,56(sp)
    80002aca:	f822                	sd	s0,48(sp)
    80002acc:	f04a                	sd	s2,32(sp)
    80002ace:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002ad0:	fcc40593          	addi	a1,s0,-52
    80002ad4:	4501                	li	a0,0
    80002ad6:	e6fff0ef          	jal	80002944 <argint>
  if(n < 0)
    80002ada:	fcc42783          	lw	a5,-52(s0)
    80002ade:	0607c763          	bltz	a5,80002b4c <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002ae2:	00016517          	auipc	a0,0x16
    80002ae6:	ade50513          	addi	a0,a0,-1314 # 800185c0 <tickslock>
    80002aea:	918fe0ef          	jal	80000c02 <acquire>
  ticks0 = ticks;
    80002aee:	00008917          	auipc	s2,0x8
    80002af2:	96a92903          	lw	s2,-1686(s2) # 8000a458 <ticks>
  while(ticks - ticks0 < n){
    80002af6:	fcc42783          	lw	a5,-52(s0)
    80002afa:	cf8d                	beqz	a5,80002b34 <sys_sleep+0x6e>
    80002afc:	f426                	sd	s1,40(sp)
    80002afe:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002b00:	00016997          	auipc	s3,0x16
    80002b04:	ac098993          	addi	s3,s3,-1344 # 800185c0 <tickslock>
    80002b08:	00008497          	auipc	s1,0x8
    80002b0c:	95048493          	addi	s1,s1,-1712 # 8000a458 <ticks>
    if(killed(myproc())){
    80002b10:	e03fe0ef          	jal	80001912 <myproc>
    80002b14:	f78ff0ef          	jal	8000228c <killed>
    80002b18:	ed0d                	bnez	a0,80002b52 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002b1a:	85ce                	mv	a1,s3
    80002b1c:	8526                	mv	a0,s1
    80002b1e:	d36ff0ef          	jal	80002054 <sleep>
  while(ticks - ticks0 < n){
    80002b22:	409c                	lw	a5,0(s1)
    80002b24:	412787bb          	subw	a5,a5,s2
    80002b28:	fcc42703          	lw	a4,-52(s0)
    80002b2c:	fee7e2e3          	bltu	a5,a4,80002b10 <sys_sleep+0x4a>
    80002b30:	74a2                	ld	s1,40(sp)
    80002b32:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002b34:	00016517          	auipc	a0,0x16
    80002b38:	a8c50513          	addi	a0,a0,-1396 # 800185c0 <tickslock>
    80002b3c:	95efe0ef          	jal	80000c9a <release>
  return 0;
    80002b40:	4501                	li	a0,0
}
    80002b42:	70e2                	ld	ra,56(sp)
    80002b44:	7442                	ld	s0,48(sp)
    80002b46:	7902                	ld	s2,32(sp)
    80002b48:	6121                	addi	sp,sp,64
    80002b4a:	8082                	ret
    n = 0;
    80002b4c:	fc042623          	sw	zero,-52(s0)
    80002b50:	bf49                	j	80002ae2 <sys_sleep+0x1c>
      release(&tickslock);
    80002b52:	00016517          	auipc	a0,0x16
    80002b56:	a6e50513          	addi	a0,a0,-1426 # 800185c0 <tickslock>
    80002b5a:	940fe0ef          	jal	80000c9a <release>
      return -1;
    80002b5e:	557d                	li	a0,-1
    80002b60:	74a2                	ld	s1,40(sp)
    80002b62:	69e2                	ld	s3,24(sp)
    80002b64:	bff9                	j	80002b42 <sys_sleep+0x7c>

0000000080002b66 <sys_kill>:

uint64
sys_kill(void)
{
    80002b66:	1101                	addi	sp,sp,-32
    80002b68:	ec06                	sd	ra,24(sp)
    80002b6a:	e822                	sd	s0,16(sp)
    80002b6c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002b6e:	fec40593          	addi	a1,s0,-20
    80002b72:	4501                	li	a0,0
    80002b74:	dd1ff0ef          	jal	80002944 <argint>
  return kill(pid);
    80002b78:	fec42503          	lw	a0,-20(s0)
    80002b7c:	e86ff0ef          	jal	80002202 <kill>
}
    80002b80:	60e2                	ld	ra,24(sp)
    80002b82:	6442                	ld	s0,16(sp)
    80002b84:	6105                	addi	sp,sp,32
    80002b86:	8082                	ret

0000000080002b88 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002b88:	1101                	addi	sp,sp,-32
    80002b8a:	ec06                	sd	ra,24(sp)
    80002b8c:	e822                	sd	s0,16(sp)
    80002b8e:	e426                	sd	s1,8(sp)
    80002b90:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002b92:	00016517          	auipc	a0,0x16
    80002b96:	a2e50513          	addi	a0,a0,-1490 # 800185c0 <tickslock>
    80002b9a:	868fe0ef          	jal	80000c02 <acquire>
  xticks = ticks;
    80002b9e:	00008497          	auipc	s1,0x8
    80002ba2:	8ba4a483          	lw	s1,-1862(s1) # 8000a458 <ticks>
  release(&tickslock);
    80002ba6:	00016517          	auipc	a0,0x16
    80002baa:	a1a50513          	addi	a0,a0,-1510 # 800185c0 <tickslock>
    80002bae:	8ecfe0ef          	jal	80000c9a <release>
  return xticks;
}
    80002bb2:	02049513          	slli	a0,s1,0x20
    80002bb6:	9101                	srli	a0,a0,0x20
    80002bb8:	60e2                	ld	ra,24(sp)
    80002bba:	6442                	ld	s0,16(sp)
    80002bbc:	64a2                	ld	s1,8(sp)
    80002bbe:	6105                	addi	sp,sp,32
    80002bc0:	8082                	ret

0000000080002bc2 <sys_countsyscall>:
uint64 syscall_count = 0;
uint64
sys_countsyscall(void)
{
    80002bc2:	1141                	addi	sp,sp,-16
    80002bc4:	e422                	sd	s0,8(sp)
    80002bc6:	0800                	addi	s0,sp,16
  return syscall_count;
}
    80002bc8:	00008517          	auipc	a0,0x8
    80002bcc:	89853503          	ld	a0,-1896(a0) # 8000a460 <syscall_count>
    80002bd0:	6422                	ld	s0,8(sp)
    80002bd2:	0141                	addi	sp,sp,16
    80002bd4:	8082                	ret

0000000080002bd6 <sys_getppid>:
uint64
sys_getppid(void)
{
    80002bd6:	1141                	addi	sp,sp,-16
    80002bd8:	e406                	sd	ra,8(sp)
    80002bda:	e022                	sd	s0,0(sp)
    80002bdc:	0800                	addi	s0,sp,16
  return myproc()->parent->pid;
    80002bde:	d35fe0ef          	jal	80001912 <myproc>
    80002be2:	7d1c                	ld	a5,56(a0)
}
    80002be4:	5b88                	lw	a0,48(a5)
    80002be6:	60a2                	ld	ra,8(sp)
    80002be8:	6402                	ld	s0,0(sp)
    80002bea:	0141                	addi	sp,sp,16
    80002bec:	8082                	ret

0000000080002bee <sys_shutdown>:
uint64
sys_shutdown(void)
{
    80002bee:	1141                	addi	sp,sp,-16
    80002bf0:	e406                	sd	ra,8(sp)
    80002bf2:	e022                	sd	s0,0(sp)
    80002bf4:	0800                	addi	s0,sp,16
  printf("shutting down \n");
    80002bf6:	00005517          	auipc	a0,0x5
    80002bfa:	83a50513          	addi	a0,a0,-1990 # 80007430 <etext+0x430>
    80002bfe:	8d3fd0ef          	jal	800004d0 <printf>
  volatile uint32 *shutdown_reg=(uint32 *)0x100000;
  *shutdown_reg=0x5555;
    80002c02:	6795                	lui	a5,0x5
    80002c04:	55578793          	addi	a5,a5,1365 # 5555 <_entry-0x7fffaaab>
    80002c08:	00100737          	lui	a4,0x100
    80002c0c:	c31c                	sw	a5,0(a4)
  return 0;
}
    80002c0e:	4501                	li	a0,0
    80002c10:	60a2                	ld	ra,8(sp)
    80002c12:	6402                	ld	s0,0(sp)
    80002c14:	0141                	addi	sp,sp,16
    80002c16:	8082                	ret

0000000080002c18 <sys_rand>:
// Simple kernel PRNG using LCG
static unsigned int lcg_state = 1;

uint64
sys_rand(void)
{
    80002c18:	1141                	addi	sp,sp,-16
    80002c1a:	e422                	sd	s0,8(sp)
    80002c1c:	0800                	addi	s0,sp,16
  // Seed only once using ticks (global variable provided by xv6)
  extern uint ticks;
  if (lcg_state == 1)
    80002c1e:	00007717          	auipc	a4,0x7
    80002c22:	79a72703          	lw	a4,1946(a4) # 8000a3b8 <lcg_state>
    80002c26:	4785                	li	a5,1
    80002c28:	02f70763          	beq	a4,a5,80002c56 <sys_rand+0x3e>
    lcg_state = ticks + 1;  // avoid 0 seed

  // LCG formula
  lcg_state = (1103515245 * lcg_state + 12345) & 0x7fffffff;
    80002c2c:	00007717          	auipc	a4,0x7
    80002c30:	78c70713          	addi	a4,a4,1932 # 8000a3b8 <lcg_state>
    80002c34:	4314                	lw	a3,0(a4)
    80002c36:	41c657b7          	lui	a5,0x41c65
    80002c3a:	e6d7879b          	addiw	a5,a5,-403 # 41c64e6d <_entry-0x3e39b193>
    80002c3e:	02d7853b          	mulw	a0,a5,a3
    80002c42:	678d                	lui	a5,0x3
    80002c44:	0397879b          	addiw	a5,a5,57 # 3039 <_entry-0x7fffcfc7>
    80002c48:	9d3d                	addw	a0,a0,a5
    80002c4a:	1506                	slli	a0,a0,0x21
    80002c4c:	9105                	srli	a0,a0,0x21
    80002c4e:	c308                	sw	a0,0(a4)

  return lcg_state;
}
    80002c50:	6422                	ld	s0,8(sp)
    80002c52:	0141                	addi	sp,sp,16
    80002c54:	8082                	ret
    lcg_state = ticks + 1;  // avoid 0 seed
    80002c56:	00008797          	auipc	a5,0x8
    80002c5a:	8027a783          	lw	a5,-2046(a5) # 8000a458 <ticks>
    80002c5e:	2785                	addiw	a5,a5,1
    80002c60:	00007717          	auipc	a4,0x7
    80002c64:	74f72c23          	sw	a5,1880(a4) # 8000a3b8 <lcg_state>
    80002c68:	b7d1                	j	80002c2c <sys_rand+0x14>

0000000080002c6a <sys_getptable>:

uint64
sys_getptable(void)
{
    80002c6a:	1101                	addi	sp,sp,-32
    80002c6c:	ec06                	sd	ra,24(sp)
    80002c6e:	e822                	sd	s0,16(sp)
    80002c70:	1000                	addi	s0,sp,32
  int nproc;
  uint64 buffer;
  
  argint(0, &nproc);
    80002c72:	fec40593          	addi	a1,s0,-20
    80002c76:	4501                	li	a0,0
    80002c78:	ccdff0ef          	jal	80002944 <argint>
  argaddr(1, &buffer);
    80002c7c:	fe040593          	addi	a1,s0,-32
    80002c80:	4505                	li	a0,1
    80002c82:	cdfff0ef          	jal	80002960 <argaddr>
  
  return getptable(nproc, buffer);
    80002c86:	fe043583          	ld	a1,-32(s0)
    80002c8a:	fec42503          	lw	a0,-20(s0)
    80002c8e:	cb5fe0ef          	jal	80001942 <getptable>
}
    80002c92:	60e2                	ld	ra,24(sp)
    80002c94:	6442                	ld	s0,16(sp)
    80002c96:	6105                	addi	sp,sp,32
    80002c98:	8082                	ret

0000000080002c9a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002c9a:	7179                	addi	sp,sp,-48
    80002c9c:	f406                	sd	ra,40(sp)
    80002c9e:	f022                	sd	s0,32(sp)
    80002ca0:	ec26                	sd	s1,24(sp)
    80002ca2:	e84a                	sd	s2,16(sp)
    80002ca4:	e44e                	sd	s3,8(sp)
    80002ca6:	e052                	sd	s4,0(sp)
    80002ca8:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002caa:	00004597          	auipc	a1,0x4
    80002cae:	79658593          	addi	a1,a1,1942 # 80007440 <etext+0x440>
    80002cb2:	00016517          	auipc	a0,0x16
    80002cb6:	92650513          	addi	a0,a0,-1754 # 800185d8 <bcache>
    80002cba:	ec9fd0ef          	jal	80000b82 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002cbe:	0001e797          	auipc	a5,0x1e
    80002cc2:	91a78793          	addi	a5,a5,-1766 # 800205d8 <bcache+0x8000>
    80002cc6:	0001e717          	auipc	a4,0x1e
    80002cca:	b7a70713          	addi	a4,a4,-1158 # 80020840 <bcache+0x8268>
    80002cce:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002cd2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002cd6:	00016497          	auipc	s1,0x16
    80002cda:	91a48493          	addi	s1,s1,-1766 # 800185f0 <bcache+0x18>
    b->next = bcache.head.next;
    80002cde:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002ce0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002ce2:	00004a17          	auipc	s4,0x4
    80002ce6:	766a0a13          	addi	s4,s4,1894 # 80007448 <etext+0x448>
    b->next = bcache.head.next;
    80002cea:	2b893783          	ld	a5,696(s2)
    80002cee:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002cf0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002cf4:	85d2                	mv	a1,s4
    80002cf6:	01048513          	addi	a0,s1,16
    80002cfa:	248010ef          	jal	80003f42 <initsleeplock>
    bcache.head.next->prev = b;
    80002cfe:	2b893783          	ld	a5,696(s2)
    80002d02:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002d04:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002d08:	45848493          	addi	s1,s1,1112
    80002d0c:	fd349fe3          	bne	s1,s3,80002cea <binit+0x50>
  }
}
    80002d10:	70a2                	ld	ra,40(sp)
    80002d12:	7402                	ld	s0,32(sp)
    80002d14:	64e2                	ld	s1,24(sp)
    80002d16:	6942                	ld	s2,16(sp)
    80002d18:	69a2                	ld	s3,8(sp)
    80002d1a:	6a02                	ld	s4,0(sp)
    80002d1c:	6145                	addi	sp,sp,48
    80002d1e:	8082                	ret

0000000080002d20 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002d20:	7179                	addi	sp,sp,-48
    80002d22:	f406                	sd	ra,40(sp)
    80002d24:	f022                	sd	s0,32(sp)
    80002d26:	ec26                	sd	s1,24(sp)
    80002d28:	e84a                	sd	s2,16(sp)
    80002d2a:	e44e                	sd	s3,8(sp)
    80002d2c:	1800                	addi	s0,sp,48
    80002d2e:	892a                	mv	s2,a0
    80002d30:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002d32:	00016517          	auipc	a0,0x16
    80002d36:	8a650513          	addi	a0,a0,-1882 # 800185d8 <bcache>
    80002d3a:	ec9fd0ef          	jal	80000c02 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002d3e:	0001e497          	auipc	s1,0x1e
    80002d42:	b524b483          	ld	s1,-1198(s1) # 80020890 <bcache+0x82b8>
    80002d46:	0001e797          	auipc	a5,0x1e
    80002d4a:	afa78793          	addi	a5,a5,-1286 # 80020840 <bcache+0x8268>
    80002d4e:	02f48b63          	beq	s1,a5,80002d84 <bread+0x64>
    80002d52:	873e                	mv	a4,a5
    80002d54:	a021                	j	80002d5c <bread+0x3c>
    80002d56:	68a4                	ld	s1,80(s1)
    80002d58:	02e48663          	beq	s1,a4,80002d84 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002d5c:	449c                	lw	a5,8(s1)
    80002d5e:	ff279ce3          	bne	a5,s2,80002d56 <bread+0x36>
    80002d62:	44dc                	lw	a5,12(s1)
    80002d64:	ff3799e3          	bne	a5,s3,80002d56 <bread+0x36>
      b->refcnt++;
    80002d68:	40bc                	lw	a5,64(s1)
    80002d6a:	2785                	addiw	a5,a5,1
    80002d6c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d6e:	00016517          	auipc	a0,0x16
    80002d72:	86a50513          	addi	a0,a0,-1942 # 800185d8 <bcache>
    80002d76:	f25fd0ef          	jal	80000c9a <release>
      acquiresleep(&b->lock);
    80002d7a:	01048513          	addi	a0,s1,16
    80002d7e:	1fa010ef          	jal	80003f78 <acquiresleep>
      return b;
    80002d82:	a889                	j	80002dd4 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002d84:	0001e497          	auipc	s1,0x1e
    80002d88:	b044b483          	ld	s1,-1276(s1) # 80020888 <bcache+0x82b0>
    80002d8c:	0001e797          	auipc	a5,0x1e
    80002d90:	ab478793          	addi	a5,a5,-1356 # 80020840 <bcache+0x8268>
    80002d94:	00f48863          	beq	s1,a5,80002da4 <bread+0x84>
    80002d98:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002d9a:	40bc                	lw	a5,64(s1)
    80002d9c:	cb91                	beqz	a5,80002db0 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002d9e:	64a4                	ld	s1,72(s1)
    80002da0:	fee49de3          	bne	s1,a4,80002d9a <bread+0x7a>
  panic("bget: no buffers");
    80002da4:	00004517          	auipc	a0,0x4
    80002da8:	6ac50513          	addi	a0,a0,1708 # 80007450 <etext+0x450>
    80002dac:	9f7fd0ef          	jal	800007a2 <panic>
      b->dev = dev;
    80002db0:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002db4:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002db8:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002dbc:	4785                	li	a5,1
    80002dbe:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002dc0:	00016517          	auipc	a0,0x16
    80002dc4:	81850513          	addi	a0,a0,-2024 # 800185d8 <bcache>
    80002dc8:	ed3fd0ef          	jal	80000c9a <release>
      acquiresleep(&b->lock);
    80002dcc:	01048513          	addi	a0,s1,16
    80002dd0:	1a8010ef          	jal	80003f78 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002dd4:	409c                	lw	a5,0(s1)
    80002dd6:	cb89                	beqz	a5,80002de8 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002dd8:	8526                	mv	a0,s1
    80002dda:	70a2                	ld	ra,40(sp)
    80002ddc:	7402                	ld	s0,32(sp)
    80002dde:	64e2                	ld	s1,24(sp)
    80002de0:	6942                	ld	s2,16(sp)
    80002de2:	69a2                	ld	s3,8(sp)
    80002de4:	6145                	addi	sp,sp,48
    80002de6:	8082                	ret
    virtio_disk_rw(b, 0);
    80002de8:	4581                	li	a1,0
    80002dea:	8526                	mv	a0,s1
    80002dec:	1e5020ef          	jal	800057d0 <virtio_disk_rw>
    b->valid = 1;
    80002df0:	4785                	li	a5,1
    80002df2:	c09c                	sw	a5,0(s1)
  return b;
    80002df4:	b7d5                	j	80002dd8 <bread+0xb8>

0000000080002df6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002df6:	1101                	addi	sp,sp,-32
    80002df8:	ec06                	sd	ra,24(sp)
    80002dfa:	e822                	sd	s0,16(sp)
    80002dfc:	e426                	sd	s1,8(sp)
    80002dfe:	1000                	addi	s0,sp,32
    80002e00:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002e02:	0541                	addi	a0,a0,16
    80002e04:	1f2010ef          	jal	80003ff6 <holdingsleep>
    80002e08:	c911                	beqz	a0,80002e1c <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002e0a:	4585                	li	a1,1
    80002e0c:	8526                	mv	a0,s1
    80002e0e:	1c3020ef          	jal	800057d0 <virtio_disk_rw>
}
    80002e12:	60e2                	ld	ra,24(sp)
    80002e14:	6442                	ld	s0,16(sp)
    80002e16:	64a2                	ld	s1,8(sp)
    80002e18:	6105                	addi	sp,sp,32
    80002e1a:	8082                	ret
    panic("bwrite");
    80002e1c:	00004517          	auipc	a0,0x4
    80002e20:	64c50513          	addi	a0,a0,1612 # 80007468 <etext+0x468>
    80002e24:	97ffd0ef          	jal	800007a2 <panic>

0000000080002e28 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002e28:	1101                	addi	sp,sp,-32
    80002e2a:	ec06                	sd	ra,24(sp)
    80002e2c:	e822                	sd	s0,16(sp)
    80002e2e:	e426                	sd	s1,8(sp)
    80002e30:	e04a                	sd	s2,0(sp)
    80002e32:	1000                	addi	s0,sp,32
    80002e34:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002e36:	01050913          	addi	s2,a0,16
    80002e3a:	854a                	mv	a0,s2
    80002e3c:	1ba010ef          	jal	80003ff6 <holdingsleep>
    80002e40:	c135                	beqz	a0,80002ea4 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002e42:	854a                	mv	a0,s2
    80002e44:	17a010ef          	jal	80003fbe <releasesleep>

  acquire(&bcache.lock);
    80002e48:	00015517          	auipc	a0,0x15
    80002e4c:	79050513          	addi	a0,a0,1936 # 800185d8 <bcache>
    80002e50:	db3fd0ef          	jal	80000c02 <acquire>
  b->refcnt--;
    80002e54:	40bc                	lw	a5,64(s1)
    80002e56:	37fd                	addiw	a5,a5,-1
    80002e58:	0007871b          	sext.w	a4,a5
    80002e5c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002e5e:	e71d                	bnez	a4,80002e8c <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002e60:	68b8                	ld	a4,80(s1)
    80002e62:	64bc                	ld	a5,72(s1)
    80002e64:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002e66:	68b8                	ld	a4,80(s1)
    80002e68:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002e6a:	0001d797          	auipc	a5,0x1d
    80002e6e:	76e78793          	addi	a5,a5,1902 # 800205d8 <bcache+0x8000>
    80002e72:	2b87b703          	ld	a4,696(a5)
    80002e76:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002e78:	0001e717          	auipc	a4,0x1e
    80002e7c:	9c870713          	addi	a4,a4,-1592 # 80020840 <bcache+0x8268>
    80002e80:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002e82:	2b87b703          	ld	a4,696(a5)
    80002e86:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002e88:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002e8c:	00015517          	auipc	a0,0x15
    80002e90:	74c50513          	addi	a0,a0,1868 # 800185d8 <bcache>
    80002e94:	e07fd0ef          	jal	80000c9a <release>
}
    80002e98:	60e2                	ld	ra,24(sp)
    80002e9a:	6442                	ld	s0,16(sp)
    80002e9c:	64a2                	ld	s1,8(sp)
    80002e9e:	6902                	ld	s2,0(sp)
    80002ea0:	6105                	addi	sp,sp,32
    80002ea2:	8082                	ret
    panic("brelse");
    80002ea4:	00004517          	auipc	a0,0x4
    80002ea8:	5cc50513          	addi	a0,a0,1484 # 80007470 <etext+0x470>
    80002eac:	8f7fd0ef          	jal	800007a2 <panic>

0000000080002eb0 <bpin>:

void
bpin(struct buf *b) {
    80002eb0:	1101                	addi	sp,sp,-32
    80002eb2:	ec06                	sd	ra,24(sp)
    80002eb4:	e822                	sd	s0,16(sp)
    80002eb6:	e426                	sd	s1,8(sp)
    80002eb8:	1000                	addi	s0,sp,32
    80002eba:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002ebc:	00015517          	auipc	a0,0x15
    80002ec0:	71c50513          	addi	a0,a0,1820 # 800185d8 <bcache>
    80002ec4:	d3ffd0ef          	jal	80000c02 <acquire>
  b->refcnt++;
    80002ec8:	40bc                	lw	a5,64(s1)
    80002eca:	2785                	addiw	a5,a5,1
    80002ecc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002ece:	00015517          	auipc	a0,0x15
    80002ed2:	70a50513          	addi	a0,a0,1802 # 800185d8 <bcache>
    80002ed6:	dc5fd0ef          	jal	80000c9a <release>
}
    80002eda:	60e2                	ld	ra,24(sp)
    80002edc:	6442                	ld	s0,16(sp)
    80002ede:	64a2                	ld	s1,8(sp)
    80002ee0:	6105                	addi	sp,sp,32
    80002ee2:	8082                	ret

0000000080002ee4 <bunpin>:

void
bunpin(struct buf *b) {
    80002ee4:	1101                	addi	sp,sp,-32
    80002ee6:	ec06                	sd	ra,24(sp)
    80002ee8:	e822                	sd	s0,16(sp)
    80002eea:	e426                	sd	s1,8(sp)
    80002eec:	1000                	addi	s0,sp,32
    80002eee:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002ef0:	00015517          	auipc	a0,0x15
    80002ef4:	6e850513          	addi	a0,a0,1768 # 800185d8 <bcache>
    80002ef8:	d0bfd0ef          	jal	80000c02 <acquire>
  b->refcnt--;
    80002efc:	40bc                	lw	a5,64(s1)
    80002efe:	37fd                	addiw	a5,a5,-1
    80002f00:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002f02:	00015517          	auipc	a0,0x15
    80002f06:	6d650513          	addi	a0,a0,1750 # 800185d8 <bcache>
    80002f0a:	d91fd0ef          	jal	80000c9a <release>
}
    80002f0e:	60e2                	ld	ra,24(sp)
    80002f10:	6442                	ld	s0,16(sp)
    80002f12:	64a2                	ld	s1,8(sp)
    80002f14:	6105                	addi	sp,sp,32
    80002f16:	8082                	ret

0000000080002f18 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002f18:	1101                	addi	sp,sp,-32
    80002f1a:	ec06                	sd	ra,24(sp)
    80002f1c:	e822                	sd	s0,16(sp)
    80002f1e:	e426                	sd	s1,8(sp)
    80002f20:	e04a                	sd	s2,0(sp)
    80002f22:	1000                	addi	s0,sp,32
    80002f24:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002f26:	00d5d59b          	srliw	a1,a1,0xd
    80002f2a:	0001e797          	auipc	a5,0x1e
    80002f2e:	d8a7a783          	lw	a5,-630(a5) # 80020cb4 <sb+0x1c>
    80002f32:	9dbd                	addw	a1,a1,a5
    80002f34:	dedff0ef          	jal	80002d20 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002f38:	0074f713          	andi	a4,s1,7
    80002f3c:	4785                	li	a5,1
    80002f3e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002f42:	14ce                	slli	s1,s1,0x33
    80002f44:	90d9                	srli	s1,s1,0x36
    80002f46:	00950733          	add	a4,a0,s1
    80002f4a:	05874703          	lbu	a4,88(a4)
    80002f4e:	00e7f6b3          	and	a3,a5,a4
    80002f52:	c29d                	beqz	a3,80002f78 <bfree+0x60>
    80002f54:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002f56:	94aa                	add	s1,s1,a0
    80002f58:	fff7c793          	not	a5,a5
    80002f5c:	8f7d                	and	a4,a4,a5
    80002f5e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002f62:	711000ef          	jal	80003e72 <log_write>
  brelse(bp);
    80002f66:	854a                	mv	a0,s2
    80002f68:	ec1ff0ef          	jal	80002e28 <brelse>
}
    80002f6c:	60e2                	ld	ra,24(sp)
    80002f6e:	6442                	ld	s0,16(sp)
    80002f70:	64a2                	ld	s1,8(sp)
    80002f72:	6902                	ld	s2,0(sp)
    80002f74:	6105                	addi	sp,sp,32
    80002f76:	8082                	ret
    panic("freeing free block");
    80002f78:	00004517          	auipc	a0,0x4
    80002f7c:	50050513          	addi	a0,a0,1280 # 80007478 <etext+0x478>
    80002f80:	823fd0ef          	jal	800007a2 <panic>

0000000080002f84 <balloc>:
{
    80002f84:	711d                	addi	sp,sp,-96
    80002f86:	ec86                	sd	ra,88(sp)
    80002f88:	e8a2                	sd	s0,80(sp)
    80002f8a:	e4a6                	sd	s1,72(sp)
    80002f8c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002f8e:	0001e797          	auipc	a5,0x1e
    80002f92:	d0e7a783          	lw	a5,-754(a5) # 80020c9c <sb+0x4>
    80002f96:	0e078f63          	beqz	a5,80003094 <balloc+0x110>
    80002f9a:	e0ca                	sd	s2,64(sp)
    80002f9c:	fc4e                	sd	s3,56(sp)
    80002f9e:	f852                	sd	s4,48(sp)
    80002fa0:	f456                	sd	s5,40(sp)
    80002fa2:	f05a                	sd	s6,32(sp)
    80002fa4:	ec5e                	sd	s7,24(sp)
    80002fa6:	e862                	sd	s8,16(sp)
    80002fa8:	e466                	sd	s9,8(sp)
    80002faa:	8baa                	mv	s7,a0
    80002fac:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002fae:	0001eb17          	auipc	s6,0x1e
    80002fb2:	ceab0b13          	addi	s6,s6,-790 # 80020c98 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002fb6:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002fb8:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002fba:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002fbc:	6c89                	lui	s9,0x2
    80002fbe:	a0b5                	j	8000302a <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002fc0:	97ca                	add	a5,a5,s2
    80002fc2:	8e55                	or	a2,a2,a3
    80002fc4:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002fc8:	854a                	mv	a0,s2
    80002fca:	6a9000ef          	jal	80003e72 <log_write>
        brelse(bp);
    80002fce:	854a                	mv	a0,s2
    80002fd0:	e59ff0ef          	jal	80002e28 <brelse>
  bp = bread(dev, bno);
    80002fd4:	85a6                	mv	a1,s1
    80002fd6:	855e                	mv	a0,s7
    80002fd8:	d49ff0ef          	jal	80002d20 <bread>
    80002fdc:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002fde:	40000613          	li	a2,1024
    80002fe2:	4581                	li	a1,0
    80002fe4:	05850513          	addi	a0,a0,88
    80002fe8:	ceffd0ef          	jal	80000cd6 <memset>
  log_write(bp);
    80002fec:	854a                	mv	a0,s2
    80002fee:	685000ef          	jal	80003e72 <log_write>
  brelse(bp);
    80002ff2:	854a                	mv	a0,s2
    80002ff4:	e35ff0ef          	jal	80002e28 <brelse>
}
    80002ff8:	6906                	ld	s2,64(sp)
    80002ffa:	79e2                	ld	s3,56(sp)
    80002ffc:	7a42                	ld	s4,48(sp)
    80002ffe:	7aa2                	ld	s5,40(sp)
    80003000:	7b02                	ld	s6,32(sp)
    80003002:	6be2                	ld	s7,24(sp)
    80003004:	6c42                	ld	s8,16(sp)
    80003006:	6ca2                	ld	s9,8(sp)
}
    80003008:	8526                	mv	a0,s1
    8000300a:	60e6                	ld	ra,88(sp)
    8000300c:	6446                	ld	s0,80(sp)
    8000300e:	64a6                	ld	s1,72(sp)
    80003010:	6125                	addi	sp,sp,96
    80003012:	8082                	ret
    brelse(bp);
    80003014:	854a                	mv	a0,s2
    80003016:	e13ff0ef          	jal	80002e28 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000301a:	015c87bb          	addw	a5,s9,s5
    8000301e:	00078a9b          	sext.w	s5,a5
    80003022:	004b2703          	lw	a4,4(s6)
    80003026:	04eaff63          	bgeu	s5,a4,80003084 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    8000302a:	41fad79b          	sraiw	a5,s5,0x1f
    8000302e:	0137d79b          	srliw	a5,a5,0x13
    80003032:	015787bb          	addw	a5,a5,s5
    80003036:	40d7d79b          	sraiw	a5,a5,0xd
    8000303a:	01cb2583          	lw	a1,28(s6)
    8000303e:	9dbd                	addw	a1,a1,a5
    80003040:	855e                	mv	a0,s7
    80003042:	cdfff0ef          	jal	80002d20 <bread>
    80003046:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003048:	004b2503          	lw	a0,4(s6)
    8000304c:	000a849b          	sext.w	s1,s5
    80003050:	8762                	mv	a4,s8
    80003052:	fca4f1e3          	bgeu	s1,a0,80003014 <balloc+0x90>
      m = 1 << (bi % 8);
    80003056:	00777693          	andi	a3,a4,7
    8000305a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000305e:	41f7579b          	sraiw	a5,a4,0x1f
    80003062:	01d7d79b          	srliw	a5,a5,0x1d
    80003066:	9fb9                	addw	a5,a5,a4
    80003068:	4037d79b          	sraiw	a5,a5,0x3
    8000306c:	00f90633          	add	a2,s2,a5
    80003070:	05864603          	lbu	a2,88(a2)
    80003074:	00c6f5b3          	and	a1,a3,a2
    80003078:	d5a1                	beqz	a1,80002fc0 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000307a:	2705                	addiw	a4,a4,1
    8000307c:	2485                	addiw	s1,s1,1
    8000307e:	fd471ae3          	bne	a4,s4,80003052 <balloc+0xce>
    80003082:	bf49                	j	80003014 <balloc+0x90>
    80003084:	6906                	ld	s2,64(sp)
    80003086:	79e2                	ld	s3,56(sp)
    80003088:	7a42                	ld	s4,48(sp)
    8000308a:	7aa2                	ld	s5,40(sp)
    8000308c:	7b02                	ld	s6,32(sp)
    8000308e:	6be2                	ld	s7,24(sp)
    80003090:	6c42                	ld	s8,16(sp)
    80003092:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80003094:	00004517          	auipc	a0,0x4
    80003098:	3fc50513          	addi	a0,a0,1020 # 80007490 <etext+0x490>
    8000309c:	c34fd0ef          	jal	800004d0 <printf>
  return 0;
    800030a0:	4481                	li	s1,0
    800030a2:	b79d                	j	80003008 <balloc+0x84>

00000000800030a4 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800030a4:	7179                	addi	sp,sp,-48
    800030a6:	f406                	sd	ra,40(sp)
    800030a8:	f022                	sd	s0,32(sp)
    800030aa:	ec26                	sd	s1,24(sp)
    800030ac:	e84a                	sd	s2,16(sp)
    800030ae:	e44e                	sd	s3,8(sp)
    800030b0:	1800                	addi	s0,sp,48
    800030b2:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800030b4:	47ad                	li	a5,11
    800030b6:	02b7e663          	bltu	a5,a1,800030e2 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800030ba:	02059793          	slli	a5,a1,0x20
    800030be:	01e7d593          	srli	a1,a5,0x1e
    800030c2:	00b504b3          	add	s1,a0,a1
    800030c6:	0504a903          	lw	s2,80(s1)
    800030ca:	06091a63          	bnez	s2,8000313e <bmap+0x9a>
      addr = balloc(ip->dev);
    800030ce:	4108                	lw	a0,0(a0)
    800030d0:	eb5ff0ef          	jal	80002f84 <balloc>
    800030d4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800030d8:	06090363          	beqz	s2,8000313e <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800030dc:	0524a823          	sw	s2,80(s1)
    800030e0:	a8b9                	j	8000313e <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800030e2:	ff45849b          	addiw	s1,a1,-12
    800030e6:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800030ea:	0ff00793          	li	a5,255
    800030ee:	06e7ee63          	bltu	a5,a4,8000316a <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800030f2:	08052903          	lw	s2,128(a0)
    800030f6:	00091d63          	bnez	s2,80003110 <bmap+0x6c>
      addr = balloc(ip->dev);
    800030fa:	4108                	lw	a0,0(a0)
    800030fc:	e89ff0ef          	jal	80002f84 <balloc>
    80003100:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003104:	02090d63          	beqz	s2,8000313e <bmap+0x9a>
    80003108:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000310a:	0929a023          	sw	s2,128(s3)
    8000310e:	a011                	j	80003112 <bmap+0x6e>
    80003110:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003112:	85ca                	mv	a1,s2
    80003114:	0009a503          	lw	a0,0(s3)
    80003118:	c09ff0ef          	jal	80002d20 <bread>
    8000311c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000311e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003122:	02049713          	slli	a4,s1,0x20
    80003126:	01e75593          	srli	a1,a4,0x1e
    8000312a:	00b784b3          	add	s1,a5,a1
    8000312e:	0004a903          	lw	s2,0(s1)
    80003132:	00090e63          	beqz	s2,8000314e <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003136:	8552                	mv	a0,s4
    80003138:	cf1ff0ef          	jal	80002e28 <brelse>
    return addr;
    8000313c:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000313e:	854a                	mv	a0,s2
    80003140:	70a2                	ld	ra,40(sp)
    80003142:	7402                	ld	s0,32(sp)
    80003144:	64e2                	ld	s1,24(sp)
    80003146:	6942                	ld	s2,16(sp)
    80003148:	69a2                	ld	s3,8(sp)
    8000314a:	6145                	addi	sp,sp,48
    8000314c:	8082                	ret
      addr = balloc(ip->dev);
    8000314e:	0009a503          	lw	a0,0(s3)
    80003152:	e33ff0ef          	jal	80002f84 <balloc>
    80003156:	0005091b          	sext.w	s2,a0
      if(addr){
    8000315a:	fc090ee3          	beqz	s2,80003136 <bmap+0x92>
        a[bn] = addr;
    8000315e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003162:	8552                	mv	a0,s4
    80003164:	50f000ef          	jal	80003e72 <log_write>
    80003168:	b7f9                	j	80003136 <bmap+0x92>
    8000316a:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000316c:	00004517          	auipc	a0,0x4
    80003170:	33c50513          	addi	a0,a0,828 # 800074a8 <etext+0x4a8>
    80003174:	e2efd0ef          	jal	800007a2 <panic>

0000000080003178 <iget>:
{
    80003178:	7179                	addi	sp,sp,-48
    8000317a:	f406                	sd	ra,40(sp)
    8000317c:	f022                	sd	s0,32(sp)
    8000317e:	ec26                	sd	s1,24(sp)
    80003180:	e84a                	sd	s2,16(sp)
    80003182:	e44e                	sd	s3,8(sp)
    80003184:	e052                	sd	s4,0(sp)
    80003186:	1800                	addi	s0,sp,48
    80003188:	89aa                	mv	s3,a0
    8000318a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000318c:	0001e517          	auipc	a0,0x1e
    80003190:	b2c50513          	addi	a0,a0,-1236 # 80020cb8 <itable>
    80003194:	a6ffd0ef          	jal	80000c02 <acquire>
  empty = 0;
    80003198:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000319a:	0001e497          	auipc	s1,0x1e
    8000319e:	b3648493          	addi	s1,s1,-1226 # 80020cd0 <itable+0x18>
    800031a2:	0001f697          	auipc	a3,0x1f
    800031a6:	5be68693          	addi	a3,a3,1470 # 80022760 <log>
    800031aa:	a039                	j	800031b8 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800031ac:	02090963          	beqz	s2,800031de <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800031b0:	08848493          	addi	s1,s1,136
    800031b4:	02d48863          	beq	s1,a3,800031e4 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800031b8:	449c                	lw	a5,8(s1)
    800031ba:	fef059e3          	blez	a5,800031ac <iget+0x34>
    800031be:	4098                	lw	a4,0(s1)
    800031c0:	ff3716e3          	bne	a4,s3,800031ac <iget+0x34>
    800031c4:	40d8                	lw	a4,4(s1)
    800031c6:	ff4713e3          	bne	a4,s4,800031ac <iget+0x34>
      ip->ref++;
    800031ca:	2785                	addiw	a5,a5,1
    800031cc:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800031ce:	0001e517          	auipc	a0,0x1e
    800031d2:	aea50513          	addi	a0,a0,-1302 # 80020cb8 <itable>
    800031d6:	ac5fd0ef          	jal	80000c9a <release>
      return ip;
    800031da:	8926                	mv	s2,s1
    800031dc:	a02d                	j	80003206 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800031de:	fbe9                	bnez	a5,800031b0 <iget+0x38>
      empty = ip;
    800031e0:	8926                	mv	s2,s1
    800031e2:	b7f9                	j	800031b0 <iget+0x38>
  if(empty == 0)
    800031e4:	02090a63          	beqz	s2,80003218 <iget+0xa0>
  ip->dev = dev;
    800031e8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800031ec:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800031f0:	4785                	li	a5,1
    800031f2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800031f6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800031fa:	0001e517          	auipc	a0,0x1e
    800031fe:	abe50513          	addi	a0,a0,-1346 # 80020cb8 <itable>
    80003202:	a99fd0ef          	jal	80000c9a <release>
}
    80003206:	854a                	mv	a0,s2
    80003208:	70a2                	ld	ra,40(sp)
    8000320a:	7402                	ld	s0,32(sp)
    8000320c:	64e2                	ld	s1,24(sp)
    8000320e:	6942                	ld	s2,16(sp)
    80003210:	69a2                	ld	s3,8(sp)
    80003212:	6a02                	ld	s4,0(sp)
    80003214:	6145                	addi	sp,sp,48
    80003216:	8082                	ret
    panic("iget: no inodes");
    80003218:	00004517          	auipc	a0,0x4
    8000321c:	2a850513          	addi	a0,a0,680 # 800074c0 <etext+0x4c0>
    80003220:	d82fd0ef          	jal	800007a2 <panic>

0000000080003224 <fsinit>:
fsinit(int dev) {
    80003224:	7179                	addi	sp,sp,-48
    80003226:	f406                	sd	ra,40(sp)
    80003228:	f022                	sd	s0,32(sp)
    8000322a:	ec26                	sd	s1,24(sp)
    8000322c:	e84a                	sd	s2,16(sp)
    8000322e:	e44e                	sd	s3,8(sp)
    80003230:	1800                	addi	s0,sp,48
    80003232:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003234:	4585                	li	a1,1
    80003236:	aebff0ef          	jal	80002d20 <bread>
    8000323a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000323c:	0001e997          	auipc	s3,0x1e
    80003240:	a5c98993          	addi	s3,s3,-1444 # 80020c98 <sb>
    80003244:	02000613          	li	a2,32
    80003248:	05850593          	addi	a1,a0,88
    8000324c:	854e                	mv	a0,s3
    8000324e:	ae5fd0ef          	jal	80000d32 <memmove>
  brelse(bp);
    80003252:	8526                	mv	a0,s1
    80003254:	bd5ff0ef          	jal	80002e28 <brelse>
  if(sb.magic != FSMAGIC)
    80003258:	0009a703          	lw	a4,0(s3)
    8000325c:	102037b7          	lui	a5,0x10203
    80003260:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003264:	02f71063          	bne	a4,a5,80003284 <fsinit+0x60>
  initlog(dev, &sb);
    80003268:	0001e597          	auipc	a1,0x1e
    8000326c:	a3058593          	addi	a1,a1,-1488 # 80020c98 <sb>
    80003270:	854a                	mv	a0,s2
    80003272:	1f9000ef          	jal	80003c6a <initlog>
}
    80003276:	70a2                	ld	ra,40(sp)
    80003278:	7402                	ld	s0,32(sp)
    8000327a:	64e2                	ld	s1,24(sp)
    8000327c:	6942                	ld	s2,16(sp)
    8000327e:	69a2                	ld	s3,8(sp)
    80003280:	6145                	addi	sp,sp,48
    80003282:	8082                	ret
    panic("invalid file system");
    80003284:	00004517          	auipc	a0,0x4
    80003288:	24c50513          	addi	a0,a0,588 # 800074d0 <etext+0x4d0>
    8000328c:	d16fd0ef          	jal	800007a2 <panic>

0000000080003290 <iinit>:
{
    80003290:	7179                	addi	sp,sp,-48
    80003292:	f406                	sd	ra,40(sp)
    80003294:	f022                	sd	s0,32(sp)
    80003296:	ec26                	sd	s1,24(sp)
    80003298:	e84a                	sd	s2,16(sp)
    8000329a:	e44e                	sd	s3,8(sp)
    8000329c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000329e:	00004597          	auipc	a1,0x4
    800032a2:	24a58593          	addi	a1,a1,586 # 800074e8 <etext+0x4e8>
    800032a6:	0001e517          	auipc	a0,0x1e
    800032aa:	a1250513          	addi	a0,a0,-1518 # 80020cb8 <itable>
    800032ae:	8d5fd0ef          	jal	80000b82 <initlock>
  for(i = 0; i < NINODE; i++) {
    800032b2:	0001e497          	auipc	s1,0x1e
    800032b6:	a2e48493          	addi	s1,s1,-1490 # 80020ce0 <itable+0x28>
    800032ba:	0001f997          	auipc	s3,0x1f
    800032be:	4b698993          	addi	s3,s3,1206 # 80022770 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800032c2:	00004917          	auipc	s2,0x4
    800032c6:	22e90913          	addi	s2,s2,558 # 800074f0 <etext+0x4f0>
    800032ca:	85ca                	mv	a1,s2
    800032cc:	8526                	mv	a0,s1
    800032ce:	475000ef          	jal	80003f42 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800032d2:	08848493          	addi	s1,s1,136
    800032d6:	ff349ae3          	bne	s1,s3,800032ca <iinit+0x3a>
}
    800032da:	70a2                	ld	ra,40(sp)
    800032dc:	7402                	ld	s0,32(sp)
    800032de:	64e2                	ld	s1,24(sp)
    800032e0:	6942                	ld	s2,16(sp)
    800032e2:	69a2                	ld	s3,8(sp)
    800032e4:	6145                	addi	sp,sp,48
    800032e6:	8082                	ret

00000000800032e8 <ialloc>:
{
    800032e8:	7139                	addi	sp,sp,-64
    800032ea:	fc06                	sd	ra,56(sp)
    800032ec:	f822                	sd	s0,48(sp)
    800032ee:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800032f0:	0001e717          	auipc	a4,0x1e
    800032f4:	9b472703          	lw	a4,-1612(a4) # 80020ca4 <sb+0xc>
    800032f8:	4785                	li	a5,1
    800032fa:	06e7f063          	bgeu	a5,a4,8000335a <ialloc+0x72>
    800032fe:	f426                	sd	s1,40(sp)
    80003300:	f04a                	sd	s2,32(sp)
    80003302:	ec4e                	sd	s3,24(sp)
    80003304:	e852                	sd	s4,16(sp)
    80003306:	e456                	sd	s5,8(sp)
    80003308:	e05a                	sd	s6,0(sp)
    8000330a:	8aaa                	mv	s5,a0
    8000330c:	8b2e                	mv	s6,a1
    8000330e:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003310:	0001ea17          	auipc	s4,0x1e
    80003314:	988a0a13          	addi	s4,s4,-1656 # 80020c98 <sb>
    80003318:	00495593          	srli	a1,s2,0x4
    8000331c:	018a2783          	lw	a5,24(s4)
    80003320:	9dbd                	addw	a1,a1,a5
    80003322:	8556                	mv	a0,s5
    80003324:	9fdff0ef          	jal	80002d20 <bread>
    80003328:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000332a:	05850993          	addi	s3,a0,88
    8000332e:	00f97793          	andi	a5,s2,15
    80003332:	079a                	slli	a5,a5,0x6
    80003334:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003336:	00099783          	lh	a5,0(s3)
    8000333a:	cb9d                	beqz	a5,80003370 <ialloc+0x88>
    brelse(bp);
    8000333c:	aedff0ef          	jal	80002e28 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003340:	0905                	addi	s2,s2,1
    80003342:	00ca2703          	lw	a4,12(s4)
    80003346:	0009079b          	sext.w	a5,s2
    8000334a:	fce7e7e3          	bltu	a5,a4,80003318 <ialloc+0x30>
    8000334e:	74a2                	ld	s1,40(sp)
    80003350:	7902                	ld	s2,32(sp)
    80003352:	69e2                	ld	s3,24(sp)
    80003354:	6a42                	ld	s4,16(sp)
    80003356:	6aa2                	ld	s5,8(sp)
    80003358:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000335a:	00004517          	auipc	a0,0x4
    8000335e:	19e50513          	addi	a0,a0,414 # 800074f8 <etext+0x4f8>
    80003362:	96efd0ef          	jal	800004d0 <printf>
  return 0;
    80003366:	4501                	li	a0,0
}
    80003368:	70e2                	ld	ra,56(sp)
    8000336a:	7442                	ld	s0,48(sp)
    8000336c:	6121                	addi	sp,sp,64
    8000336e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003370:	04000613          	li	a2,64
    80003374:	4581                	li	a1,0
    80003376:	854e                	mv	a0,s3
    80003378:	95ffd0ef          	jal	80000cd6 <memset>
      dip->type = type;
    8000337c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003380:	8526                	mv	a0,s1
    80003382:	2f1000ef          	jal	80003e72 <log_write>
      brelse(bp);
    80003386:	8526                	mv	a0,s1
    80003388:	aa1ff0ef          	jal	80002e28 <brelse>
      return iget(dev, inum);
    8000338c:	0009059b          	sext.w	a1,s2
    80003390:	8556                	mv	a0,s5
    80003392:	de7ff0ef          	jal	80003178 <iget>
    80003396:	74a2                	ld	s1,40(sp)
    80003398:	7902                	ld	s2,32(sp)
    8000339a:	69e2                	ld	s3,24(sp)
    8000339c:	6a42                	ld	s4,16(sp)
    8000339e:	6aa2                	ld	s5,8(sp)
    800033a0:	6b02                	ld	s6,0(sp)
    800033a2:	b7d9                	j	80003368 <ialloc+0x80>

00000000800033a4 <iupdate>:
{
    800033a4:	1101                	addi	sp,sp,-32
    800033a6:	ec06                	sd	ra,24(sp)
    800033a8:	e822                	sd	s0,16(sp)
    800033aa:	e426                	sd	s1,8(sp)
    800033ac:	e04a                	sd	s2,0(sp)
    800033ae:	1000                	addi	s0,sp,32
    800033b0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800033b2:	415c                	lw	a5,4(a0)
    800033b4:	0047d79b          	srliw	a5,a5,0x4
    800033b8:	0001e597          	auipc	a1,0x1e
    800033bc:	8f85a583          	lw	a1,-1800(a1) # 80020cb0 <sb+0x18>
    800033c0:	9dbd                	addw	a1,a1,a5
    800033c2:	4108                	lw	a0,0(a0)
    800033c4:	95dff0ef          	jal	80002d20 <bread>
    800033c8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800033ca:	05850793          	addi	a5,a0,88
    800033ce:	40d8                	lw	a4,4(s1)
    800033d0:	8b3d                	andi	a4,a4,15
    800033d2:	071a                	slli	a4,a4,0x6
    800033d4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800033d6:	04449703          	lh	a4,68(s1)
    800033da:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800033de:	04649703          	lh	a4,70(s1)
    800033e2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800033e6:	04849703          	lh	a4,72(s1)
    800033ea:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800033ee:	04a49703          	lh	a4,74(s1)
    800033f2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800033f6:	44f8                	lw	a4,76(s1)
    800033f8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800033fa:	03400613          	li	a2,52
    800033fe:	05048593          	addi	a1,s1,80
    80003402:	00c78513          	addi	a0,a5,12
    80003406:	92dfd0ef          	jal	80000d32 <memmove>
  log_write(bp);
    8000340a:	854a                	mv	a0,s2
    8000340c:	267000ef          	jal	80003e72 <log_write>
  brelse(bp);
    80003410:	854a                	mv	a0,s2
    80003412:	a17ff0ef          	jal	80002e28 <brelse>
}
    80003416:	60e2                	ld	ra,24(sp)
    80003418:	6442                	ld	s0,16(sp)
    8000341a:	64a2                	ld	s1,8(sp)
    8000341c:	6902                	ld	s2,0(sp)
    8000341e:	6105                	addi	sp,sp,32
    80003420:	8082                	ret

0000000080003422 <idup>:
{
    80003422:	1101                	addi	sp,sp,-32
    80003424:	ec06                	sd	ra,24(sp)
    80003426:	e822                	sd	s0,16(sp)
    80003428:	e426                	sd	s1,8(sp)
    8000342a:	1000                	addi	s0,sp,32
    8000342c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000342e:	0001e517          	auipc	a0,0x1e
    80003432:	88a50513          	addi	a0,a0,-1910 # 80020cb8 <itable>
    80003436:	fccfd0ef          	jal	80000c02 <acquire>
  ip->ref++;
    8000343a:	449c                	lw	a5,8(s1)
    8000343c:	2785                	addiw	a5,a5,1
    8000343e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003440:	0001e517          	auipc	a0,0x1e
    80003444:	87850513          	addi	a0,a0,-1928 # 80020cb8 <itable>
    80003448:	853fd0ef          	jal	80000c9a <release>
}
    8000344c:	8526                	mv	a0,s1
    8000344e:	60e2                	ld	ra,24(sp)
    80003450:	6442                	ld	s0,16(sp)
    80003452:	64a2                	ld	s1,8(sp)
    80003454:	6105                	addi	sp,sp,32
    80003456:	8082                	ret

0000000080003458 <ilock>:
{
    80003458:	1101                	addi	sp,sp,-32
    8000345a:	ec06                	sd	ra,24(sp)
    8000345c:	e822                	sd	s0,16(sp)
    8000345e:	e426                	sd	s1,8(sp)
    80003460:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003462:	cd19                	beqz	a0,80003480 <ilock+0x28>
    80003464:	84aa                	mv	s1,a0
    80003466:	451c                	lw	a5,8(a0)
    80003468:	00f05c63          	blez	a5,80003480 <ilock+0x28>
  acquiresleep(&ip->lock);
    8000346c:	0541                	addi	a0,a0,16
    8000346e:	30b000ef          	jal	80003f78 <acquiresleep>
  if(ip->valid == 0){
    80003472:	40bc                	lw	a5,64(s1)
    80003474:	cf89                	beqz	a5,8000348e <ilock+0x36>
}
    80003476:	60e2                	ld	ra,24(sp)
    80003478:	6442                	ld	s0,16(sp)
    8000347a:	64a2                	ld	s1,8(sp)
    8000347c:	6105                	addi	sp,sp,32
    8000347e:	8082                	ret
    80003480:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003482:	00004517          	auipc	a0,0x4
    80003486:	08e50513          	addi	a0,a0,142 # 80007510 <etext+0x510>
    8000348a:	b18fd0ef          	jal	800007a2 <panic>
    8000348e:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003490:	40dc                	lw	a5,4(s1)
    80003492:	0047d79b          	srliw	a5,a5,0x4
    80003496:	0001e597          	auipc	a1,0x1e
    8000349a:	81a5a583          	lw	a1,-2022(a1) # 80020cb0 <sb+0x18>
    8000349e:	9dbd                	addw	a1,a1,a5
    800034a0:	4088                	lw	a0,0(s1)
    800034a2:	87fff0ef          	jal	80002d20 <bread>
    800034a6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800034a8:	05850593          	addi	a1,a0,88
    800034ac:	40dc                	lw	a5,4(s1)
    800034ae:	8bbd                	andi	a5,a5,15
    800034b0:	079a                	slli	a5,a5,0x6
    800034b2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800034b4:	00059783          	lh	a5,0(a1)
    800034b8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800034bc:	00259783          	lh	a5,2(a1)
    800034c0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800034c4:	00459783          	lh	a5,4(a1)
    800034c8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800034cc:	00659783          	lh	a5,6(a1)
    800034d0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800034d4:	459c                	lw	a5,8(a1)
    800034d6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800034d8:	03400613          	li	a2,52
    800034dc:	05b1                	addi	a1,a1,12
    800034de:	05048513          	addi	a0,s1,80
    800034e2:	851fd0ef          	jal	80000d32 <memmove>
    brelse(bp);
    800034e6:	854a                	mv	a0,s2
    800034e8:	941ff0ef          	jal	80002e28 <brelse>
    ip->valid = 1;
    800034ec:	4785                	li	a5,1
    800034ee:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800034f0:	04449783          	lh	a5,68(s1)
    800034f4:	c399                	beqz	a5,800034fa <ilock+0xa2>
    800034f6:	6902                	ld	s2,0(sp)
    800034f8:	bfbd                	j	80003476 <ilock+0x1e>
      panic("ilock: no type");
    800034fa:	00004517          	auipc	a0,0x4
    800034fe:	01e50513          	addi	a0,a0,30 # 80007518 <etext+0x518>
    80003502:	aa0fd0ef          	jal	800007a2 <panic>

0000000080003506 <iunlock>:
{
    80003506:	1101                	addi	sp,sp,-32
    80003508:	ec06                	sd	ra,24(sp)
    8000350a:	e822                	sd	s0,16(sp)
    8000350c:	e426                	sd	s1,8(sp)
    8000350e:	e04a                	sd	s2,0(sp)
    80003510:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003512:	c505                	beqz	a0,8000353a <iunlock+0x34>
    80003514:	84aa                	mv	s1,a0
    80003516:	01050913          	addi	s2,a0,16
    8000351a:	854a                	mv	a0,s2
    8000351c:	2db000ef          	jal	80003ff6 <holdingsleep>
    80003520:	cd09                	beqz	a0,8000353a <iunlock+0x34>
    80003522:	449c                	lw	a5,8(s1)
    80003524:	00f05b63          	blez	a5,8000353a <iunlock+0x34>
  releasesleep(&ip->lock);
    80003528:	854a                	mv	a0,s2
    8000352a:	295000ef          	jal	80003fbe <releasesleep>
}
    8000352e:	60e2                	ld	ra,24(sp)
    80003530:	6442                	ld	s0,16(sp)
    80003532:	64a2                	ld	s1,8(sp)
    80003534:	6902                	ld	s2,0(sp)
    80003536:	6105                	addi	sp,sp,32
    80003538:	8082                	ret
    panic("iunlock");
    8000353a:	00004517          	auipc	a0,0x4
    8000353e:	fee50513          	addi	a0,a0,-18 # 80007528 <etext+0x528>
    80003542:	a60fd0ef          	jal	800007a2 <panic>

0000000080003546 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003546:	7179                	addi	sp,sp,-48
    80003548:	f406                	sd	ra,40(sp)
    8000354a:	f022                	sd	s0,32(sp)
    8000354c:	ec26                	sd	s1,24(sp)
    8000354e:	e84a                	sd	s2,16(sp)
    80003550:	e44e                	sd	s3,8(sp)
    80003552:	1800                	addi	s0,sp,48
    80003554:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003556:	05050493          	addi	s1,a0,80
    8000355a:	08050913          	addi	s2,a0,128
    8000355e:	a021                	j	80003566 <itrunc+0x20>
    80003560:	0491                	addi	s1,s1,4
    80003562:	01248b63          	beq	s1,s2,80003578 <itrunc+0x32>
    if(ip->addrs[i]){
    80003566:	408c                	lw	a1,0(s1)
    80003568:	dde5                	beqz	a1,80003560 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000356a:	0009a503          	lw	a0,0(s3)
    8000356e:	9abff0ef          	jal	80002f18 <bfree>
      ip->addrs[i] = 0;
    80003572:	0004a023          	sw	zero,0(s1)
    80003576:	b7ed                	j	80003560 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003578:	0809a583          	lw	a1,128(s3)
    8000357c:	ed89                	bnez	a1,80003596 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000357e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003582:	854e                	mv	a0,s3
    80003584:	e21ff0ef          	jal	800033a4 <iupdate>
}
    80003588:	70a2                	ld	ra,40(sp)
    8000358a:	7402                	ld	s0,32(sp)
    8000358c:	64e2                	ld	s1,24(sp)
    8000358e:	6942                	ld	s2,16(sp)
    80003590:	69a2                	ld	s3,8(sp)
    80003592:	6145                	addi	sp,sp,48
    80003594:	8082                	ret
    80003596:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003598:	0009a503          	lw	a0,0(s3)
    8000359c:	f84ff0ef          	jal	80002d20 <bread>
    800035a0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800035a2:	05850493          	addi	s1,a0,88
    800035a6:	45850913          	addi	s2,a0,1112
    800035aa:	a021                	j	800035b2 <itrunc+0x6c>
    800035ac:	0491                	addi	s1,s1,4
    800035ae:	01248963          	beq	s1,s2,800035c0 <itrunc+0x7a>
      if(a[j])
    800035b2:	408c                	lw	a1,0(s1)
    800035b4:	dde5                	beqz	a1,800035ac <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800035b6:	0009a503          	lw	a0,0(s3)
    800035ba:	95fff0ef          	jal	80002f18 <bfree>
    800035be:	b7fd                	j	800035ac <itrunc+0x66>
    brelse(bp);
    800035c0:	8552                	mv	a0,s4
    800035c2:	867ff0ef          	jal	80002e28 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800035c6:	0809a583          	lw	a1,128(s3)
    800035ca:	0009a503          	lw	a0,0(s3)
    800035ce:	94bff0ef          	jal	80002f18 <bfree>
    ip->addrs[NDIRECT] = 0;
    800035d2:	0809a023          	sw	zero,128(s3)
    800035d6:	6a02                	ld	s4,0(sp)
    800035d8:	b75d                	j	8000357e <itrunc+0x38>

00000000800035da <iput>:
{
    800035da:	1101                	addi	sp,sp,-32
    800035dc:	ec06                	sd	ra,24(sp)
    800035de:	e822                	sd	s0,16(sp)
    800035e0:	e426                	sd	s1,8(sp)
    800035e2:	1000                	addi	s0,sp,32
    800035e4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800035e6:	0001d517          	auipc	a0,0x1d
    800035ea:	6d250513          	addi	a0,a0,1746 # 80020cb8 <itable>
    800035ee:	e14fd0ef          	jal	80000c02 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800035f2:	4498                	lw	a4,8(s1)
    800035f4:	4785                	li	a5,1
    800035f6:	02f70063          	beq	a4,a5,80003616 <iput+0x3c>
  ip->ref--;
    800035fa:	449c                	lw	a5,8(s1)
    800035fc:	37fd                	addiw	a5,a5,-1
    800035fe:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003600:	0001d517          	auipc	a0,0x1d
    80003604:	6b850513          	addi	a0,a0,1720 # 80020cb8 <itable>
    80003608:	e92fd0ef          	jal	80000c9a <release>
}
    8000360c:	60e2                	ld	ra,24(sp)
    8000360e:	6442                	ld	s0,16(sp)
    80003610:	64a2                	ld	s1,8(sp)
    80003612:	6105                	addi	sp,sp,32
    80003614:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003616:	40bc                	lw	a5,64(s1)
    80003618:	d3ed                	beqz	a5,800035fa <iput+0x20>
    8000361a:	04a49783          	lh	a5,74(s1)
    8000361e:	fff1                	bnez	a5,800035fa <iput+0x20>
    80003620:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003622:	01048913          	addi	s2,s1,16
    80003626:	854a                	mv	a0,s2
    80003628:	151000ef          	jal	80003f78 <acquiresleep>
    release(&itable.lock);
    8000362c:	0001d517          	auipc	a0,0x1d
    80003630:	68c50513          	addi	a0,a0,1676 # 80020cb8 <itable>
    80003634:	e66fd0ef          	jal	80000c9a <release>
    itrunc(ip);
    80003638:	8526                	mv	a0,s1
    8000363a:	f0dff0ef          	jal	80003546 <itrunc>
    ip->type = 0;
    8000363e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003642:	8526                	mv	a0,s1
    80003644:	d61ff0ef          	jal	800033a4 <iupdate>
    ip->valid = 0;
    80003648:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000364c:	854a                	mv	a0,s2
    8000364e:	171000ef          	jal	80003fbe <releasesleep>
    acquire(&itable.lock);
    80003652:	0001d517          	auipc	a0,0x1d
    80003656:	66650513          	addi	a0,a0,1638 # 80020cb8 <itable>
    8000365a:	da8fd0ef          	jal	80000c02 <acquire>
    8000365e:	6902                	ld	s2,0(sp)
    80003660:	bf69                	j	800035fa <iput+0x20>

0000000080003662 <iunlockput>:
{
    80003662:	1101                	addi	sp,sp,-32
    80003664:	ec06                	sd	ra,24(sp)
    80003666:	e822                	sd	s0,16(sp)
    80003668:	e426                	sd	s1,8(sp)
    8000366a:	1000                	addi	s0,sp,32
    8000366c:	84aa                	mv	s1,a0
  iunlock(ip);
    8000366e:	e99ff0ef          	jal	80003506 <iunlock>
  iput(ip);
    80003672:	8526                	mv	a0,s1
    80003674:	f67ff0ef          	jal	800035da <iput>
}
    80003678:	60e2                	ld	ra,24(sp)
    8000367a:	6442                	ld	s0,16(sp)
    8000367c:	64a2                	ld	s1,8(sp)
    8000367e:	6105                	addi	sp,sp,32
    80003680:	8082                	ret

0000000080003682 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003682:	1141                	addi	sp,sp,-16
    80003684:	e422                	sd	s0,8(sp)
    80003686:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003688:	411c                	lw	a5,0(a0)
    8000368a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000368c:	415c                	lw	a5,4(a0)
    8000368e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003690:	04451783          	lh	a5,68(a0)
    80003694:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003698:	04a51783          	lh	a5,74(a0)
    8000369c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800036a0:	04c56783          	lwu	a5,76(a0)
    800036a4:	e99c                	sd	a5,16(a1)
}
    800036a6:	6422                	ld	s0,8(sp)
    800036a8:	0141                	addi	sp,sp,16
    800036aa:	8082                	ret

00000000800036ac <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800036ac:	457c                	lw	a5,76(a0)
    800036ae:	0ed7eb63          	bltu	a5,a3,800037a4 <readi+0xf8>
{
    800036b2:	7159                	addi	sp,sp,-112
    800036b4:	f486                	sd	ra,104(sp)
    800036b6:	f0a2                	sd	s0,96(sp)
    800036b8:	eca6                	sd	s1,88(sp)
    800036ba:	e0d2                	sd	s4,64(sp)
    800036bc:	fc56                	sd	s5,56(sp)
    800036be:	f85a                	sd	s6,48(sp)
    800036c0:	f45e                	sd	s7,40(sp)
    800036c2:	1880                	addi	s0,sp,112
    800036c4:	8b2a                	mv	s6,a0
    800036c6:	8bae                	mv	s7,a1
    800036c8:	8a32                	mv	s4,a2
    800036ca:	84b6                	mv	s1,a3
    800036cc:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800036ce:	9f35                	addw	a4,a4,a3
    return 0;
    800036d0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800036d2:	0cd76063          	bltu	a4,a3,80003792 <readi+0xe6>
    800036d6:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800036d8:	00e7f463          	bgeu	a5,a4,800036e0 <readi+0x34>
    n = ip->size - off;
    800036dc:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800036e0:	080a8f63          	beqz	s5,8000377e <readi+0xd2>
    800036e4:	e8ca                	sd	s2,80(sp)
    800036e6:	f062                	sd	s8,32(sp)
    800036e8:	ec66                	sd	s9,24(sp)
    800036ea:	e86a                	sd	s10,16(sp)
    800036ec:	e46e                	sd	s11,8(sp)
    800036ee:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800036f0:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800036f4:	5c7d                	li	s8,-1
    800036f6:	a80d                	j	80003728 <readi+0x7c>
    800036f8:	020d1d93          	slli	s11,s10,0x20
    800036fc:	020ddd93          	srli	s11,s11,0x20
    80003700:	05890613          	addi	a2,s2,88
    80003704:	86ee                	mv	a3,s11
    80003706:	963a                	add	a2,a2,a4
    80003708:	85d2                	mv	a1,s4
    8000370a:	855e                	mv	a0,s7
    8000370c:	ca5fe0ef          	jal	800023b0 <either_copyout>
    80003710:	05850763          	beq	a0,s8,8000375e <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003714:	854a                	mv	a0,s2
    80003716:	f12ff0ef          	jal	80002e28 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000371a:	013d09bb          	addw	s3,s10,s3
    8000371e:	009d04bb          	addw	s1,s10,s1
    80003722:	9a6e                	add	s4,s4,s11
    80003724:	0559f763          	bgeu	s3,s5,80003772 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80003728:	00a4d59b          	srliw	a1,s1,0xa
    8000372c:	855a                	mv	a0,s6
    8000372e:	977ff0ef          	jal	800030a4 <bmap>
    80003732:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003736:	c5b1                	beqz	a1,80003782 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80003738:	000b2503          	lw	a0,0(s6)
    8000373c:	de4ff0ef          	jal	80002d20 <bread>
    80003740:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003742:	3ff4f713          	andi	a4,s1,1023
    80003746:	40ec87bb          	subw	a5,s9,a4
    8000374a:	413a86bb          	subw	a3,s5,s3
    8000374e:	8d3e                	mv	s10,a5
    80003750:	2781                	sext.w	a5,a5
    80003752:	0006861b          	sext.w	a2,a3
    80003756:	faf671e3          	bgeu	a2,a5,800036f8 <readi+0x4c>
    8000375a:	8d36                	mv	s10,a3
    8000375c:	bf71                	j	800036f8 <readi+0x4c>
      brelse(bp);
    8000375e:	854a                	mv	a0,s2
    80003760:	ec8ff0ef          	jal	80002e28 <brelse>
      tot = -1;
    80003764:	59fd                	li	s3,-1
      break;
    80003766:	6946                	ld	s2,80(sp)
    80003768:	7c02                	ld	s8,32(sp)
    8000376a:	6ce2                	ld	s9,24(sp)
    8000376c:	6d42                	ld	s10,16(sp)
    8000376e:	6da2                	ld	s11,8(sp)
    80003770:	a831                	j	8000378c <readi+0xe0>
    80003772:	6946                	ld	s2,80(sp)
    80003774:	7c02                	ld	s8,32(sp)
    80003776:	6ce2                	ld	s9,24(sp)
    80003778:	6d42                	ld	s10,16(sp)
    8000377a:	6da2                	ld	s11,8(sp)
    8000377c:	a801                	j	8000378c <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000377e:	89d6                	mv	s3,s5
    80003780:	a031                	j	8000378c <readi+0xe0>
    80003782:	6946                	ld	s2,80(sp)
    80003784:	7c02                	ld	s8,32(sp)
    80003786:	6ce2                	ld	s9,24(sp)
    80003788:	6d42                	ld	s10,16(sp)
    8000378a:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000378c:	0009851b          	sext.w	a0,s3
    80003790:	69a6                	ld	s3,72(sp)
}
    80003792:	70a6                	ld	ra,104(sp)
    80003794:	7406                	ld	s0,96(sp)
    80003796:	64e6                	ld	s1,88(sp)
    80003798:	6a06                	ld	s4,64(sp)
    8000379a:	7ae2                	ld	s5,56(sp)
    8000379c:	7b42                	ld	s6,48(sp)
    8000379e:	7ba2                	ld	s7,40(sp)
    800037a0:	6165                	addi	sp,sp,112
    800037a2:	8082                	ret
    return 0;
    800037a4:	4501                	li	a0,0
}
    800037a6:	8082                	ret

00000000800037a8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800037a8:	457c                	lw	a5,76(a0)
    800037aa:	10d7e063          	bltu	a5,a3,800038aa <writei+0x102>
{
    800037ae:	7159                	addi	sp,sp,-112
    800037b0:	f486                	sd	ra,104(sp)
    800037b2:	f0a2                	sd	s0,96(sp)
    800037b4:	e8ca                	sd	s2,80(sp)
    800037b6:	e0d2                	sd	s4,64(sp)
    800037b8:	fc56                	sd	s5,56(sp)
    800037ba:	f85a                	sd	s6,48(sp)
    800037bc:	f45e                	sd	s7,40(sp)
    800037be:	1880                	addi	s0,sp,112
    800037c0:	8aaa                	mv	s5,a0
    800037c2:	8bae                	mv	s7,a1
    800037c4:	8a32                	mv	s4,a2
    800037c6:	8936                	mv	s2,a3
    800037c8:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800037ca:	00e687bb          	addw	a5,a3,a4
    800037ce:	0ed7e063          	bltu	a5,a3,800038ae <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800037d2:	00043737          	lui	a4,0x43
    800037d6:	0cf76e63          	bltu	a4,a5,800038b2 <writei+0x10a>
    800037da:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800037dc:	0a0b0f63          	beqz	s6,8000389a <writei+0xf2>
    800037e0:	eca6                	sd	s1,88(sp)
    800037e2:	f062                	sd	s8,32(sp)
    800037e4:	ec66                	sd	s9,24(sp)
    800037e6:	e86a                	sd	s10,16(sp)
    800037e8:	e46e                	sd	s11,8(sp)
    800037ea:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800037ec:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800037f0:	5c7d                	li	s8,-1
    800037f2:	a825                	j	8000382a <writei+0x82>
    800037f4:	020d1d93          	slli	s11,s10,0x20
    800037f8:	020ddd93          	srli	s11,s11,0x20
    800037fc:	05848513          	addi	a0,s1,88
    80003800:	86ee                	mv	a3,s11
    80003802:	8652                	mv	a2,s4
    80003804:	85de                	mv	a1,s7
    80003806:	953a                	add	a0,a0,a4
    80003808:	bf3fe0ef          	jal	800023fa <either_copyin>
    8000380c:	05850a63          	beq	a0,s8,80003860 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003810:	8526                	mv	a0,s1
    80003812:	660000ef          	jal	80003e72 <log_write>
    brelse(bp);
    80003816:	8526                	mv	a0,s1
    80003818:	e10ff0ef          	jal	80002e28 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000381c:	013d09bb          	addw	s3,s10,s3
    80003820:	012d093b          	addw	s2,s10,s2
    80003824:	9a6e                	add	s4,s4,s11
    80003826:	0569f063          	bgeu	s3,s6,80003866 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    8000382a:	00a9559b          	srliw	a1,s2,0xa
    8000382e:	8556                	mv	a0,s5
    80003830:	875ff0ef          	jal	800030a4 <bmap>
    80003834:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003838:	c59d                	beqz	a1,80003866 <writei+0xbe>
    bp = bread(ip->dev, addr);
    8000383a:	000aa503          	lw	a0,0(s5)
    8000383e:	ce2ff0ef          	jal	80002d20 <bread>
    80003842:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003844:	3ff97713          	andi	a4,s2,1023
    80003848:	40ec87bb          	subw	a5,s9,a4
    8000384c:	413b06bb          	subw	a3,s6,s3
    80003850:	8d3e                	mv	s10,a5
    80003852:	2781                	sext.w	a5,a5
    80003854:	0006861b          	sext.w	a2,a3
    80003858:	f8f67ee3          	bgeu	a2,a5,800037f4 <writei+0x4c>
    8000385c:	8d36                	mv	s10,a3
    8000385e:	bf59                	j	800037f4 <writei+0x4c>
      brelse(bp);
    80003860:	8526                	mv	a0,s1
    80003862:	dc6ff0ef          	jal	80002e28 <brelse>
  }

  if(off > ip->size)
    80003866:	04caa783          	lw	a5,76(s5)
    8000386a:	0327fa63          	bgeu	a5,s2,8000389e <writei+0xf6>
    ip->size = off;
    8000386e:	052aa623          	sw	s2,76(s5)
    80003872:	64e6                	ld	s1,88(sp)
    80003874:	7c02                	ld	s8,32(sp)
    80003876:	6ce2                	ld	s9,24(sp)
    80003878:	6d42                	ld	s10,16(sp)
    8000387a:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000387c:	8556                	mv	a0,s5
    8000387e:	b27ff0ef          	jal	800033a4 <iupdate>

  return tot;
    80003882:	0009851b          	sext.w	a0,s3
    80003886:	69a6                	ld	s3,72(sp)
}
    80003888:	70a6                	ld	ra,104(sp)
    8000388a:	7406                	ld	s0,96(sp)
    8000388c:	6946                	ld	s2,80(sp)
    8000388e:	6a06                	ld	s4,64(sp)
    80003890:	7ae2                	ld	s5,56(sp)
    80003892:	7b42                	ld	s6,48(sp)
    80003894:	7ba2                	ld	s7,40(sp)
    80003896:	6165                	addi	sp,sp,112
    80003898:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000389a:	89da                	mv	s3,s6
    8000389c:	b7c5                	j	8000387c <writei+0xd4>
    8000389e:	64e6                	ld	s1,88(sp)
    800038a0:	7c02                	ld	s8,32(sp)
    800038a2:	6ce2                	ld	s9,24(sp)
    800038a4:	6d42                	ld	s10,16(sp)
    800038a6:	6da2                	ld	s11,8(sp)
    800038a8:	bfd1                	j	8000387c <writei+0xd4>
    return -1;
    800038aa:	557d                	li	a0,-1
}
    800038ac:	8082                	ret
    return -1;
    800038ae:	557d                	li	a0,-1
    800038b0:	bfe1                	j	80003888 <writei+0xe0>
    return -1;
    800038b2:	557d                	li	a0,-1
    800038b4:	bfd1                	j	80003888 <writei+0xe0>

00000000800038b6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800038b6:	1141                	addi	sp,sp,-16
    800038b8:	e406                	sd	ra,8(sp)
    800038ba:	e022                	sd	s0,0(sp)
    800038bc:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800038be:	4639                	li	a2,14
    800038c0:	ce2fd0ef          	jal	80000da2 <strncmp>
}
    800038c4:	60a2                	ld	ra,8(sp)
    800038c6:	6402                	ld	s0,0(sp)
    800038c8:	0141                	addi	sp,sp,16
    800038ca:	8082                	ret

00000000800038cc <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800038cc:	7139                	addi	sp,sp,-64
    800038ce:	fc06                	sd	ra,56(sp)
    800038d0:	f822                	sd	s0,48(sp)
    800038d2:	f426                	sd	s1,40(sp)
    800038d4:	f04a                	sd	s2,32(sp)
    800038d6:	ec4e                	sd	s3,24(sp)
    800038d8:	e852                	sd	s4,16(sp)
    800038da:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800038dc:	04451703          	lh	a4,68(a0)
    800038e0:	4785                	li	a5,1
    800038e2:	00f71a63          	bne	a4,a5,800038f6 <dirlookup+0x2a>
    800038e6:	892a                	mv	s2,a0
    800038e8:	89ae                	mv	s3,a1
    800038ea:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800038ec:	457c                	lw	a5,76(a0)
    800038ee:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800038f0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800038f2:	e39d                	bnez	a5,80003918 <dirlookup+0x4c>
    800038f4:	a095                	j	80003958 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    800038f6:	00004517          	auipc	a0,0x4
    800038fa:	c3a50513          	addi	a0,a0,-966 # 80007530 <etext+0x530>
    800038fe:	ea5fc0ef          	jal	800007a2 <panic>
      panic("dirlookup read");
    80003902:	00004517          	auipc	a0,0x4
    80003906:	c4650513          	addi	a0,a0,-954 # 80007548 <etext+0x548>
    8000390a:	e99fc0ef          	jal	800007a2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000390e:	24c1                	addiw	s1,s1,16
    80003910:	04c92783          	lw	a5,76(s2)
    80003914:	04f4f163          	bgeu	s1,a5,80003956 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003918:	4741                	li	a4,16
    8000391a:	86a6                	mv	a3,s1
    8000391c:	fc040613          	addi	a2,s0,-64
    80003920:	4581                	li	a1,0
    80003922:	854a                	mv	a0,s2
    80003924:	d89ff0ef          	jal	800036ac <readi>
    80003928:	47c1                	li	a5,16
    8000392a:	fcf51ce3          	bne	a0,a5,80003902 <dirlookup+0x36>
    if(de.inum == 0)
    8000392e:	fc045783          	lhu	a5,-64(s0)
    80003932:	dff1                	beqz	a5,8000390e <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003934:	fc240593          	addi	a1,s0,-62
    80003938:	854e                	mv	a0,s3
    8000393a:	f7dff0ef          	jal	800038b6 <namecmp>
    8000393e:	f961                	bnez	a0,8000390e <dirlookup+0x42>
      if(poff)
    80003940:	000a0463          	beqz	s4,80003948 <dirlookup+0x7c>
        *poff = off;
    80003944:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003948:	fc045583          	lhu	a1,-64(s0)
    8000394c:	00092503          	lw	a0,0(s2)
    80003950:	829ff0ef          	jal	80003178 <iget>
    80003954:	a011                	j	80003958 <dirlookup+0x8c>
  return 0;
    80003956:	4501                	li	a0,0
}
    80003958:	70e2                	ld	ra,56(sp)
    8000395a:	7442                	ld	s0,48(sp)
    8000395c:	74a2                	ld	s1,40(sp)
    8000395e:	7902                	ld	s2,32(sp)
    80003960:	69e2                	ld	s3,24(sp)
    80003962:	6a42                	ld	s4,16(sp)
    80003964:	6121                	addi	sp,sp,64
    80003966:	8082                	ret

0000000080003968 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003968:	711d                	addi	sp,sp,-96
    8000396a:	ec86                	sd	ra,88(sp)
    8000396c:	e8a2                	sd	s0,80(sp)
    8000396e:	e4a6                	sd	s1,72(sp)
    80003970:	e0ca                	sd	s2,64(sp)
    80003972:	fc4e                	sd	s3,56(sp)
    80003974:	f852                	sd	s4,48(sp)
    80003976:	f456                	sd	s5,40(sp)
    80003978:	f05a                	sd	s6,32(sp)
    8000397a:	ec5e                	sd	s7,24(sp)
    8000397c:	e862                	sd	s8,16(sp)
    8000397e:	e466                	sd	s9,8(sp)
    80003980:	1080                	addi	s0,sp,96
    80003982:	84aa                	mv	s1,a0
    80003984:	8b2e                	mv	s6,a1
    80003986:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003988:	00054703          	lbu	a4,0(a0)
    8000398c:	02f00793          	li	a5,47
    80003990:	00f70e63          	beq	a4,a5,800039ac <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003994:	f7ffd0ef          	jal	80001912 <myproc>
    80003998:	15053503          	ld	a0,336(a0)
    8000399c:	a87ff0ef          	jal	80003422 <idup>
    800039a0:	8a2a                	mv	s4,a0
  while(*path == '/')
    800039a2:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800039a6:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800039a8:	4b85                	li	s7,1
    800039aa:	a871                	j	80003a46 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    800039ac:	4585                	li	a1,1
    800039ae:	4505                	li	a0,1
    800039b0:	fc8ff0ef          	jal	80003178 <iget>
    800039b4:	8a2a                	mv	s4,a0
    800039b6:	b7f5                	j	800039a2 <namex+0x3a>
      iunlockput(ip);
    800039b8:	8552                	mv	a0,s4
    800039ba:	ca9ff0ef          	jal	80003662 <iunlockput>
      return 0;
    800039be:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800039c0:	8552                	mv	a0,s4
    800039c2:	60e6                	ld	ra,88(sp)
    800039c4:	6446                	ld	s0,80(sp)
    800039c6:	64a6                	ld	s1,72(sp)
    800039c8:	6906                	ld	s2,64(sp)
    800039ca:	79e2                	ld	s3,56(sp)
    800039cc:	7a42                	ld	s4,48(sp)
    800039ce:	7aa2                	ld	s5,40(sp)
    800039d0:	7b02                	ld	s6,32(sp)
    800039d2:	6be2                	ld	s7,24(sp)
    800039d4:	6c42                	ld	s8,16(sp)
    800039d6:	6ca2                	ld	s9,8(sp)
    800039d8:	6125                	addi	sp,sp,96
    800039da:	8082                	ret
      iunlock(ip);
    800039dc:	8552                	mv	a0,s4
    800039de:	b29ff0ef          	jal	80003506 <iunlock>
      return ip;
    800039e2:	bff9                	j	800039c0 <namex+0x58>
      iunlockput(ip);
    800039e4:	8552                	mv	a0,s4
    800039e6:	c7dff0ef          	jal	80003662 <iunlockput>
      return 0;
    800039ea:	8a4e                	mv	s4,s3
    800039ec:	bfd1                	j	800039c0 <namex+0x58>
  len = path - s;
    800039ee:	40998633          	sub	a2,s3,s1
    800039f2:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800039f6:	099c5063          	bge	s8,s9,80003a76 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    800039fa:	4639                	li	a2,14
    800039fc:	85a6                	mv	a1,s1
    800039fe:	8556                	mv	a0,s5
    80003a00:	b32fd0ef          	jal	80000d32 <memmove>
    80003a04:	84ce                	mv	s1,s3
  while(*path == '/')
    80003a06:	0004c783          	lbu	a5,0(s1)
    80003a0a:	01279763          	bne	a5,s2,80003a18 <namex+0xb0>
    path++;
    80003a0e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003a10:	0004c783          	lbu	a5,0(s1)
    80003a14:	ff278de3          	beq	a5,s2,80003a0e <namex+0xa6>
    ilock(ip);
    80003a18:	8552                	mv	a0,s4
    80003a1a:	a3fff0ef          	jal	80003458 <ilock>
    if(ip->type != T_DIR){
    80003a1e:	044a1783          	lh	a5,68(s4)
    80003a22:	f9779be3          	bne	a5,s7,800039b8 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003a26:	000b0563          	beqz	s6,80003a30 <namex+0xc8>
    80003a2a:	0004c783          	lbu	a5,0(s1)
    80003a2e:	d7dd                	beqz	a5,800039dc <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003a30:	4601                	li	a2,0
    80003a32:	85d6                	mv	a1,s5
    80003a34:	8552                	mv	a0,s4
    80003a36:	e97ff0ef          	jal	800038cc <dirlookup>
    80003a3a:	89aa                	mv	s3,a0
    80003a3c:	d545                	beqz	a0,800039e4 <namex+0x7c>
    iunlockput(ip);
    80003a3e:	8552                	mv	a0,s4
    80003a40:	c23ff0ef          	jal	80003662 <iunlockput>
    ip = next;
    80003a44:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003a46:	0004c783          	lbu	a5,0(s1)
    80003a4a:	01279763          	bne	a5,s2,80003a58 <namex+0xf0>
    path++;
    80003a4e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003a50:	0004c783          	lbu	a5,0(s1)
    80003a54:	ff278de3          	beq	a5,s2,80003a4e <namex+0xe6>
  if(*path == 0)
    80003a58:	cb8d                	beqz	a5,80003a8a <namex+0x122>
  while(*path != '/' && *path != 0)
    80003a5a:	0004c783          	lbu	a5,0(s1)
    80003a5e:	89a6                	mv	s3,s1
  len = path - s;
    80003a60:	4c81                	li	s9,0
    80003a62:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003a64:	01278963          	beq	a5,s2,80003a76 <namex+0x10e>
    80003a68:	d3d9                	beqz	a5,800039ee <namex+0x86>
    path++;
    80003a6a:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003a6c:	0009c783          	lbu	a5,0(s3)
    80003a70:	ff279ce3          	bne	a5,s2,80003a68 <namex+0x100>
    80003a74:	bfad                	j	800039ee <namex+0x86>
    memmove(name, s, len);
    80003a76:	2601                	sext.w	a2,a2
    80003a78:	85a6                	mv	a1,s1
    80003a7a:	8556                	mv	a0,s5
    80003a7c:	ab6fd0ef          	jal	80000d32 <memmove>
    name[len] = 0;
    80003a80:	9cd6                	add	s9,s9,s5
    80003a82:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003a86:	84ce                	mv	s1,s3
    80003a88:	bfbd                	j	80003a06 <namex+0x9e>
  if(nameiparent){
    80003a8a:	f20b0be3          	beqz	s6,800039c0 <namex+0x58>
    iput(ip);
    80003a8e:	8552                	mv	a0,s4
    80003a90:	b4bff0ef          	jal	800035da <iput>
    return 0;
    80003a94:	4a01                	li	s4,0
    80003a96:	b72d                	j	800039c0 <namex+0x58>

0000000080003a98 <dirlink>:
{
    80003a98:	7139                	addi	sp,sp,-64
    80003a9a:	fc06                	sd	ra,56(sp)
    80003a9c:	f822                	sd	s0,48(sp)
    80003a9e:	f04a                	sd	s2,32(sp)
    80003aa0:	ec4e                	sd	s3,24(sp)
    80003aa2:	e852                	sd	s4,16(sp)
    80003aa4:	0080                	addi	s0,sp,64
    80003aa6:	892a                	mv	s2,a0
    80003aa8:	8a2e                	mv	s4,a1
    80003aaa:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003aac:	4601                	li	a2,0
    80003aae:	e1fff0ef          	jal	800038cc <dirlookup>
    80003ab2:	e535                	bnez	a0,80003b1e <dirlink+0x86>
    80003ab4:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ab6:	04c92483          	lw	s1,76(s2)
    80003aba:	c48d                	beqz	s1,80003ae4 <dirlink+0x4c>
    80003abc:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003abe:	4741                	li	a4,16
    80003ac0:	86a6                	mv	a3,s1
    80003ac2:	fc040613          	addi	a2,s0,-64
    80003ac6:	4581                	li	a1,0
    80003ac8:	854a                	mv	a0,s2
    80003aca:	be3ff0ef          	jal	800036ac <readi>
    80003ace:	47c1                	li	a5,16
    80003ad0:	04f51b63          	bne	a0,a5,80003b26 <dirlink+0x8e>
    if(de.inum == 0)
    80003ad4:	fc045783          	lhu	a5,-64(s0)
    80003ad8:	c791                	beqz	a5,80003ae4 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ada:	24c1                	addiw	s1,s1,16
    80003adc:	04c92783          	lw	a5,76(s2)
    80003ae0:	fcf4efe3          	bltu	s1,a5,80003abe <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003ae4:	4639                	li	a2,14
    80003ae6:	85d2                	mv	a1,s4
    80003ae8:	fc240513          	addi	a0,s0,-62
    80003aec:	aecfd0ef          	jal	80000dd8 <strncpy>
  de.inum = inum;
    80003af0:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003af4:	4741                	li	a4,16
    80003af6:	86a6                	mv	a3,s1
    80003af8:	fc040613          	addi	a2,s0,-64
    80003afc:	4581                	li	a1,0
    80003afe:	854a                	mv	a0,s2
    80003b00:	ca9ff0ef          	jal	800037a8 <writei>
    80003b04:	1541                	addi	a0,a0,-16
    80003b06:	00a03533          	snez	a0,a0
    80003b0a:	40a00533          	neg	a0,a0
    80003b0e:	74a2                	ld	s1,40(sp)
}
    80003b10:	70e2                	ld	ra,56(sp)
    80003b12:	7442                	ld	s0,48(sp)
    80003b14:	7902                	ld	s2,32(sp)
    80003b16:	69e2                	ld	s3,24(sp)
    80003b18:	6a42                	ld	s4,16(sp)
    80003b1a:	6121                	addi	sp,sp,64
    80003b1c:	8082                	ret
    iput(ip);
    80003b1e:	abdff0ef          	jal	800035da <iput>
    return -1;
    80003b22:	557d                	li	a0,-1
    80003b24:	b7f5                	j	80003b10 <dirlink+0x78>
      panic("dirlink read");
    80003b26:	00004517          	auipc	a0,0x4
    80003b2a:	a3250513          	addi	a0,a0,-1486 # 80007558 <etext+0x558>
    80003b2e:	c75fc0ef          	jal	800007a2 <panic>

0000000080003b32 <namei>:

struct inode*
namei(char *path)
{
    80003b32:	1101                	addi	sp,sp,-32
    80003b34:	ec06                	sd	ra,24(sp)
    80003b36:	e822                	sd	s0,16(sp)
    80003b38:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003b3a:	fe040613          	addi	a2,s0,-32
    80003b3e:	4581                	li	a1,0
    80003b40:	e29ff0ef          	jal	80003968 <namex>
}
    80003b44:	60e2                	ld	ra,24(sp)
    80003b46:	6442                	ld	s0,16(sp)
    80003b48:	6105                	addi	sp,sp,32
    80003b4a:	8082                	ret

0000000080003b4c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003b4c:	1141                	addi	sp,sp,-16
    80003b4e:	e406                	sd	ra,8(sp)
    80003b50:	e022                	sd	s0,0(sp)
    80003b52:	0800                	addi	s0,sp,16
    80003b54:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003b56:	4585                	li	a1,1
    80003b58:	e11ff0ef          	jal	80003968 <namex>
}
    80003b5c:	60a2                	ld	ra,8(sp)
    80003b5e:	6402                	ld	s0,0(sp)
    80003b60:	0141                	addi	sp,sp,16
    80003b62:	8082                	ret

0000000080003b64 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003b64:	1101                	addi	sp,sp,-32
    80003b66:	ec06                	sd	ra,24(sp)
    80003b68:	e822                	sd	s0,16(sp)
    80003b6a:	e426                	sd	s1,8(sp)
    80003b6c:	e04a                	sd	s2,0(sp)
    80003b6e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003b70:	0001f917          	auipc	s2,0x1f
    80003b74:	bf090913          	addi	s2,s2,-1040 # 80022760 <log>
    80003b78:	01892583          	lw	a1,24(s2)
    80003b7c:	02892503          	lw	a0,40(s2)
    80003b80:	9a0ff0ef          	jal	80002d20 <bread>
    80003b84:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003b86:	02c92603          	lw	a2,44(s2)
    80003b8a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003b8c:	00c05f63          	blez	a2,80003baa <write_head+0x46>
    80003b90:	0001f717          	auipc	a4,0x1f
    80003b94:	c0070713          	addi	a4,a4,-1024 # 80022790 <log+0x30>
    80003b98:	87aa                	mv	a5,a0
    80003b9a:	060a                	slli	a2,a2,0x2
    80003b9c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003b9e:	4314                	lw	a3,0(a4)
    80003ba0:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003ba2:	0711                	addi	a4,a4,4
    80003ba4:	0791                	addi	a5,a5,4
    80003ba6:	fec79ce3          	bne	a5,a2,80003b9e <write_head+0x3a>
  }
  bwrite(buf);
    80003baa:	8526                	mv	a0,s1
    80003bac:	a4aff0ef          	jal	80002df6 <bwrite>
  brelse(buf);
    80003bb0:	8526                	mv	a0,s1
    80003bb2:	a76ff0ef          	jal	80002e28 <brelse>
}
    80003bb6:	60e2                	ld	ra,24(sp)
    80003bb8:	6442                	ld	s0,16(sp)
    80003bba:	64a2                	ld	s1,8(sp)
    80003bbc:	6902                	ld	s2,0(sp)
    80003bbe:	6105                	addi	sp,sp,32
    80003bc0:	8082                	ret

0000000080003bc2 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bc2:	0001f797          	auipc	a5,0x1f
    80003bc6:	bca7a783          	lw	a5,-1078(a5) # 8002278c <log+0x2c>
    80003bca:	08f05f63          	blez	a5,80003c68 <install_trans+0xa6>
{
    80003bce:	7139                	addi	sp,sp,-64
    80003bd0:	fc06                	sd	ra,56(sp)
    80003bd2:	f822                	sd	s0,48(sp)
    80003bd4:	f426                	sd	s1,40(sp)
    80003bd6:	f04a                	sd	s2,32(sp)
    80003bd8:	ec4e                	sd	s3,24(sp)
    80003bda:	e852                	sd	s4,16(sp)
    80003bdc:	e456                	sd	s5,8(sp)
    80003bde:	e05a                	sd	s6,0(sp)
    80003be0:	0080                	addi	s0,sp,64
    80003be2:	8b2a                	mv	s6,a0
    80003be4:	0001fa97          	auipc	s5,0x1f
    80003be8:	baca8a93          	addi	s5,s5,-1108 # 80022790 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bec:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003bee:	0001f997          	auipc	s3,0x1f
    80003bf2:	b7298993          	addi	s3,s3,-1166 # 80022760 <log>
    80003bf6:	a829                	j	80003c10 <install_trans+0x4e>
    brelse(lbuf);
    80003bf8:	854a                	mv	a0,s2
    80003bfa:	a2eff0ef          	jal	80002e28 <brelse>
    brelse(dbuf);
    80003bfe:	8526                	mv	a0,s1
    80003c00:	a28ff0ef          	jal	80002e28 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c04:	2a05                	addiw	s4,s4,1
    80003c06:	0a91                	addi	s5,s5,4
    80003c08:	02c9a783          	lw	a5,44(s3)
    80003c0c:	04fa5463          	bge	s4,a5,80003c54 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003c10:	0189a583          	lw	a1,24(s3)
    80003c14:	014585bb          	addw	a1,a1,s4
    80003c18:	2585                	addiw	a1,a1,1
    80003c1a:	0289a503          	lw	a0,40(s3)
    80003c1e:	902ff0ef          	jal	80002d20 <bread>
    80003c22:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003c24:	000aa583          	lw	a1,0(s5)
    80003c28:	0289a503          	lw	a0,40(s3)
    80003c2c:	8f4ff0ef          	jal	80002d20 <bread>
    80003c30:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003c32:	40000613          	li	a2,1024
    80003c36:	05890593          	addi	a1,s2,88
    80003c3a:	05850513          	addi	a0,a0,88
    80003c3e:	8f4fd0ef          	jal	80000d32 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003c42:	8526                	mv	a0,s1
    80003c44:	9b2ff0ef          	jal	80002df6 <bwrite>
    if(recovering == 0)
    80003c48:	fa0b18e3          	bnez	s6,80003bf8 <install_trans+0x36>
      bunpin(dbuf);
    80003c4c:	8526                	mv	a0,s1
    80003c4e:	a96ff0ef          	jal	80002ee4 <bunpin>
    80003c52:	b75d                	j	80003bf8 <install_trans+0x36>
}
    80003c54:	70e2                	ld	ra,56(sp)
    80003c56:	7442                	ld	s0,48(sp)
    80003c58:	74a2                	ld	s1,40(sp)
    80003c5a:	7902                	ld	s2,32(sp)
    80003c5c:	69e2                	ld	s3,24(sp)
    80003c5e:	6a42                	ld	s4,16(sp)
    80003c60:	6aa2                	ld	s5,8(sp)
    80003c62:	6b02                	ld	s6,0(sp)
    80003c64:	6121                	addi	sp,sp,64
    80003c66:	8082                	ret
    80003c68:	8082                	ret

0000000080003c6a <initlog>:
{
    80003c6a:	7179                	addi	sp,sp,-48
    80003c6c:	f406                	sd	ra,40(sp)
    80003c6e:	f022                	sd	s0,32(sp)
    80003c70:	ec26                	sd	s1,24(sp)
    80003c72:	e84a                	sd	s2,16(sp)
    80003c74:	e44e                	sd	s3,8(sp)
    80003c76:	1800                	addi	s0,sp,48
    80003c78:	892a                	mv	s2,a0
    80003c7a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003c7c:	0001f497          	auipc	s1,0x1f
    80003c80:	ae448493          	addi	s1,s1,-1308 # 80022760 <log>
    80003c84:	00004597          	auipc	a1,0x4
    80003c88:	8e458593          	addi	a1,a1,-1820 # 80007568 <etext+0x568>
    80003c8c:	8526                	mv	a0,s1
    80003c8e:	ef5fc0ef          	jal	80000b82 <initlock>
  log.start = sb->logstart;
    80003c92:	0149a583          	lw	a1,20(s3)
    80003c96:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003c98:	0109a783          	lw	a5,16(s3)
    80003c9c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003c9e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003ca2:	854a                	mv	a0,s2
    80003ca4:	87cff0ef          	jal	80002d20 <bread>
  log.lh.n = lh->n;
    80003ca8:	4d30                	lw	a2,88(a0)
    80003caa:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003cac:	00c05f63          	blez	a2,80003cca <initlog+0x60>
    80003cb0:	87aa                	mv	a5,a0
    80003cb2:	0001f717          	auipc	a4,0x1f
    80003cb6:	ade70713          	addi	a4,a4,-1314 # 80022790 <log+0x30>
    80003cba:	060a                	slli	a2,a2,0x2
    80003cbc:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003cbe:	4ff4                	lw	a3,92(a5)
    80003cc0:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003cc2:	0791                	addi	a5,a5,4
    80003cc4:	0711                	addi	a4,a4,4
    80003cc6:	fec79ce3          	bne	a5,a2,80003cbe <initlog+0x54>
  brelse(buf);
    80003cca:	95eff0ef          	jal	80002e28 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003cce:	4505                	li	a0,1
    80003cd0:	ef3ff0ef          	jal	80003bc2 <install_trans>
  log.lh.n = 0;
    80003cd4:	0001f797          	auipc	a5,0x1f
    80003cd8:	aa07ac23          	sw	zero,-1352(a5) # 8002278c <log+0x2c>
  write_head(); // clear the log
    80003cdc:	e89ff0ef          	jal	80003b64 <write_head>
}
    80003ce0:	70a2                	ld	ra,40(sp)
    80003ce2:	7402                	ld	s0,32(sp)
    80003ce4:	64e2                	ld	s1,24(sp)
    80003ce6:	6942                	ld	s2,16(sp)
    80003ce8:	69a2                	ld	s3,8(sp)
    80003cea:	6145                	addi	sp,sp,48
    80003cec:	8082                	ret

0000000080003cee <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003cee:	1101                	addi	sp,sp,-32
    80003cf0:	ec06                	sd	ra,24(sp)
    80003cf2:	e822                	sd	s0,16(sp)
    80003cf4:	e426                	sd	s1,8(sp)
    80003cf6:	e04a                	sd	s2,0(sp)
    80003cf8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003cfa:	0001f517          	auipc	a0,0x1f
    80003cfe:	a6650513          	addi	a0,a0,-1434 # 80022760 <log>
    80003d02:	f01fc0ef          	jal	80000c02 <acquire>
  while(1){
    if(log.committing){
    80003d06:	0001f497          	auipc	s1,0x1f
    80003d0a:	a5a48493          	addi	s1,s1,-1446 # 80022760 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003d0e:	4979                	li	s2,30
    80003d10:	a029                	j	80003d1a <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003d12:	85a6                	mv	a1,s1
    80003d14:	8526                	mv	a0,s1
    80003d16:	b3efe0ef          	jal	80002054 <sleep>
    if(log.committing){
    80003d1a:	50dc                	lw	a5,36(s1)
    80003d1c:	fbfd                	bnez	a5,80003d12 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003d1e:	5098                	lw	a4,32(s1)
    80003d20:	2705                	addiw	a4,a4,1
    80003d22:	0027179b          	slliw	a5,a4,0x2
    80003d26:	9fb9                	addw	a5,a5,a4
    80003d28:	0017979b          	slliw	a5,a5,0x1
    80003d2c:	54d4                	lw	a3,44(s1)
    80003d2e:	9fb5                	addw	a5,a5,a3
    80003d30:	00f95763          	bge	s2,a5,80003d3e <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003d34:	85a6                	mv	a1,s1
    80003d36:	8526                	mv	a0,s1
    80003d38:	b1cfe0ef          	jal	80002054 <sleep>
    80003d3c:	bff9                	j	80003d1a <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003d3e:	0001f517          	auipc	a0,0x1f
    80003d42:	a2250513          	addi	a0,a0,-1502 # 80022760 <log>
    80003d46:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003d48:	f53fc0ef          	jal	80000c9a <release>
      break;
    }
  }
}
    80003d4c:	60e2                	ld	ra,24(sp)
    80003d4e:	6442                	ld	s0,16(sp)
    80003d50:	64a2                	ld	s1,8(sp)
    80003d52:	6902                	ld	s2,0(sp)
    80003d54:	6105                	addi	sp,sp,32
    80003d56:	8082                	ret

0000000080003d58 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003d58:	7139                	addi	sp,sp,-64
    80003d5a:	fc06                	sd	ra,56(sp)
    80003d5c:	f822                	sd	s0,48(sp)
    80003d5e:	f426                	sd	s1,40(sp)
    80003d60:	f04a                	sd	s2,32(sp)
    80003d62:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003d64:	0001f497          	auipc	s1,0x1f
    80003d68:	9fc48493          	addi	s1,s1,-1540 # 80022760 <log>
    80003d6c:	8526                	mv	a0,s1
    80003d6e:	e95fc0ef          	jal	80000c02 <acquire>
  log.outstanding -= 1;
    80003d72:	509c                	lw	a5,32(s1)
    80003d74:	37fd                	addiw	a5,a5,-1
    80003d76:	0007891b          	sext.w	s2,a5
    80003d7a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003d7c:	50dc                	lw	a5,36(s1)
    80003d7e:	ef9d                	bnez	a5,80003dbc <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003d80:	04091763          	bnez	s2,80003dce <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003d84:	0001f497          	auipc	s1,0x1f
    80003d88:	9dc48493          	addi	s1,s1,-1572 # 80022760 <log>
    80003d8c:	4785                	li	a5,1
    80003d8e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003d90:	8526                	mv	a0,s1
    80003d92:	f09fc0ef          	jal	80000c9a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003d96:	54dc                	lw	a5,44(s1)
    80003d98:	04f04b63          	bgtz	a5,80003dee <end_op+0x96>
    acquire(&log.lock);
    80003d9c:	0001f497          	auipc	s1,0x1f
    80003da0:	9c448493          	addi	s1,s1,-1596 # 80022760 <log>
    80003da4:	8526                	mv	a0,s1
    80003da6:	e5dfc0ef          	jal	80000c02 <acquire>
    log.committing = 0;
    80003daa:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003dae:	8526                	mv	a0,s1
    80003db0:	af0fe0ef          	jal	800020a0 <wakeup>
    release(&log.lock);
    80003db4:	8526                	mv	a0,s1
    80003db6:	ee5fc0ef          	jal	80000c9a <release>
}
    80003dba:	a025                	j	80003de2 <end_op+0x8a>
    80003dbc:	ec4e                	sd	s3,24(sp)
    80003dbe:	e852                	sd	s4,16(sp)
    80003dc0:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003dc2:	00003517          	auipc	a0,0x3
    80003dc6:	7ae50513          	addi	a0,a0,1966 # 80007570 <etext+0x570>
    80003dca:	9d9fc0ef          	jal	800007a2 <panic>
    wakeup(&log);
    80003dce:	0001f497          	auipc	s1,0x1f
    80003dd2:	99248493          	addi	s1,s1,-1646 # 80022760 <log>
    80003dd6:	8526                	mv	a0,s1
    80003dd8:	ac8fe0ef          	jal	800020a0 <wakeup>
  release(&log.lock);
    80003ddc:	8526                	mv	a0,s1
    80003dde:	ebdfc0ef          	jal	80000c9a <release>
}
    80003de2:	70e2                	ld	ra,56(sp)
    80003de4:	7442                	ld	s0,48(sp)
    80003de6:	74a2                	ld	s1,40(sp)
    80003de8:	7902                	ld	s2,32(sp)
    80003dea:	6121                	addi	sp,sp,64
    80003dec:	8082                	ret
    80003dee:	ec4e                	sd	s3,24(sp)
    80003df0:	e852                	sd	s4,16(sp)
    80003df2:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003df4:	0001fa97          	auipc	s5,0x1f
    80003df8:	99ca8a93          	addi	s5,s5,-1636 # 80022790 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003dfc:	0001fa17          	auipc	s4,0x1f
    80003e00:	964a0a13          	addi	s4,s4,-1692 # 80022760 <log>
    80003e04:	018a2583          	lw	a1,24(s4)
    80003e08:	012585bb          	addw	a1,a1,s2
    80003e0c:	2585                	addiw	a1,a1,1
    80003e0e:	028a2503          	lw	a0,40(s4)
    80003e12:	f0ffe0ef          	jal	80002d20 <bread>
    80003e16:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003e18:	000aa583          	lw	a1,0(s5)
    80003e1c:	028a2503          	lw	a0,40(s4)
    80003e20:	f01fe0ef          	jal	80002d20 <bread>
    80003e24:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003e26:	40000613          	li	a2,1024
    80003e2a:	05850593          	addi	a1,a0,88
    80003e2e:	05848513          	addi	a0,s1,88
    80003e32:	f01fc0ef          	jal	80000d32 <memmove>
    bwrite(to);  // write the log
    80003e36:	8526                	mv	a0,s1
    80003e38:	fbffe0ef          	jal	80002df6 <bwrite>
    brelse(from);
    80003e3c:	854e                	mv	a0,s3
    80003e3e:	febfe0ef          	jal	80002e28 <brelse>
    brelse(to);
    80003e42:	8526                	mv	a0,s1
    80003e44:	fe5fe0ef          	jal	80002e28 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e48:	2905                	addiw	s2,s2,1
    80003e4a:	0a91                	addi	s5,s5,4
    80003e4c:	02ca2783          	lw	a5,44(s4)
    80003e50:	faf94ae3          	blt	s2,a5,80003e04 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003e54:	d11ff0ef          	jal	80003b64 <write_head>
    install_trans(0); // Now install writes to home locations
    80003e58:	4501                	li	a0,0
    80003e5a:	d69ff0ef          	jal	80003bc2 <install_trans>
    log.lh.n = 0;
    80003e5e:	0001f797          	auipc	a5,0x1f
    80003e62:	9207a723          	sw	zero,-1746(a5) # 8002278c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003e66:	cffff0ef          	jal	80003b64 <write_head>
    80003e6a:	69e2                	ld	s3,24(sp)
    80003e6c:	6a42                	ld	s4,16(sp)
    80003e6e:	6aa2                	ld	s5,8(sp)
    80003e70:	b735                	j	80003d9c <end_op+0x44>

0000000080003e72 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003e72:	1101                	addi	sp,sp,-32
    80003e74:	ec06                	sd	ra,24(sp)
    80003e76:	e822                	sd	s0,16(sp)
    80003e78:	e426                	sd	s1,8(sp)
    80003e7a:	e04a                	sd	s2,0(sp)
    80003e7c:	1000                	addi	s0,sp,32
    80003e7e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003e80:	0001f917          	auipc	s2,0x1f
    80003e84:	8e090913          	addi	s2,s2,-1824 # 80022760 <log>
    80003e88:	854a                	mv	a0,s2
    80003e8a:	d79fc0ef          	jal	80000c02 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003e8e:	02c92603          	lw	a2,44(s2)
    80003e92:	47f5                	li	a5,29
    80003e94:	06c7c363          	blt	a5,a2,80003efa <log_write+0x88>
    80003e98:	0001f797          	auipc	a5,0x1f
    80003e9c:	8e47a783          	lw	a5,-1820(a5) # 8002277c <log+0x1c>
    80003ea0:	37fd                	addiw	a5,a5,-1
    80003ea2:	04f65c63          	bge	a2,a5,80003efa <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003ea6:	0001f797          	auipc	a5,0x1f
    80003eaa:	8da7a783          	lw	a5,-1830(a5) # 80022780 <log+0x20>
    80003eae:	04f05c63          	blez	a5,80003f06 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003eb2:	4781                	li	a5,0
    80003eb4:	04c05f63          	blez	a2,80003f12 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003eb8:	44cc                	lw	a1,12(s1)
    80003eba:	0001f717          	auipc	a4,0x1f
    80003ebe:	8d670713          	addi	a4,a4,-1834 # 80022790 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003ec2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003ec4:	4314                	lw	a3,0(a4)
    80003ec6:	04b68663          	beq	a3,a1,80003f12 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003eca:	2785                	addiw	a5,a5,1
    80003ecc:	0711                	addi	a4,a4,4
    80003ece:	fef61be3          	bne	a2,a5,80003ec4 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003ed2:	0621                	addi	a2,a2,8
    80003ed4:	060a                	slli	a2,a2,0x2
    80003ed6:	0001f797          	auipc	a5,0x1f
    80003eda:	88a78793          	addi	a5,a5,-1910 # 80022760 <log>
    80003ede:	97b2                	add	a5,a5,a2
    80003ee0:	44d8                	lw	a4,12(s1)
    80003ee2:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003ee4:	8526                	mv	a0,s1
    80003ee6:	fcbfe0ef          	jal	80002eb0 <bpin>
    log.lh.n++;
    80003eea:	0001f717          	auipc	a4,0x1f
    80003eee:	87670713          	addi	a4,a4,-1930 # 80022760 <log>
    80003ef2:	575c                	lw	a5,44(a4)
    80003ef4:	2785                	addiw	a5,a5,1
    80003ef6:	d75c                	sw	a5,44(a4)
    80003ef8:	a80d                	j	80003f2a <log_write+0xb8>
    panic("too big a transaction");
    80003efa:	00003517          	auipc	a0,0x3
    80003efe:	68650513          	addi	a0,a0,1670 # 80007580 <etext+0x580>
    80003f02:	8a1fc0ef          	jal	800007a2 <panic>
    panic("log_write outside of trans");
    80003f06:	00003517          	auipc	a0,0x3
    80003f0a:	69250513          	addi	a0,a0,1682 # 80007598 <etext+0x598>
    80003f0e:	895fc0ef          	jal	800007a2 <panic>
  log.lh.block[i] = b->blockno;
    80003f12:	00878693          	addi	a3,a5,8
    80003f16:	068a                	slli	a3,a3,0x2
    80003f18:	0001f717          	auipc	a4,0x1f
    80003f1c:	84870713          	addi	a4,a4,-1976 # 80022760 <log>
    80003f20:	9736                	add	a4,a4,a3
    80003f22:	44d4                	lw	a3,12(s1)
    80003f24:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003f26:	faf60fe3          	beq	a2,a5,80003ee4 <log_write+0x72>
  }
  release(&log.lock);
    80003f2a:	0001f517          	auipc	a0,0x1f
    80003f2e:	83650513          	addi	a0,a0,-1994 # 80022760 <log>
    80003f32:	d69fc0ef          	jal	80000c9a <release>
}
    80003f36:	60e2                	ld	ra,24(sp)
    80003f38:	6442                	ld	s0,16(sp)
    80003f3a:	64a2                	ld	s1,8(sp)
    80003f3c:	6902                	ld	s2,0(sp)
    80003f3e:	6105                	addi	sp,sp,32
    80003f40:	8082                	ret

0000000080003f42 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003f42:	1101                	addi	sp,sp,-32
    80003f44:	ec06                	sd	ra,24(sp)
    80003f46:	e822                	sd	s0,16(sp)
    80003f48:	e426                	sd	s1,8(sp)
    80003f4a:	e04a                	sd	s2,0(sp)
    80003f4c:	1000                	addi	s0,sp,32
    80003f4e:	84aa                	mv	s1,a0
    80003f50:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003f52:	00003597          	auipc	a1,0x3
    80003f56:	66658593          	addi	a1,a1,1638 # 800075b8 <etext+0x5b8>
    80003f5a:	0521                	addi	a0,a0,8
    80003f5c:	c27fc0ef          	jal	80000b82 <initlock>
  lk->name = name;
    80003f60:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003f64:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003f68:	0204a423          	sw	zero,40(s1)
}
    80003f6c:	60e2                	ld	ra,24(sp)
    80003f6e:	6442                	ld	s0,16(sp)
    80003f70:	64a2                	ld	s1,8(sp)
    80003f72:	6902                	ld	s2,0(sp)
    80003f74:	6105                	addi	sp,sp,32
    80003f76:	8082                	ret

0000000080003f78 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003f78:	1101                	addi	sp,sp,-32
    80003f7a:	ec06                	sd	ra,24(sp)
    80003f7c:	e822                	sd	s0,16(sp)
    80003f7e:	e426                	sd	s1,8(sp)
    80003f80:	e04a                	sd	s2,0(sp)
    80003f82:	1000                	addi	s0,sp,32
    80003f84:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003f86:	00850913          	addi	s2,a0,8
    80003f8a:	854a                	mv	a0,s2
    80003f8c:	c77fc0ef          	jal	80000c02 <acquire>
  while (lk->locked) {
    80003f90:	409c                	lw	a5,0(s1)
    80003f92:	c799                	beqz	a5,80003fa0 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003f94:	85ca                	mv	a1,s2
    80003f96:	8526                	mv	a0,s1
    80003f98:	8bcfe0ef          	jal	80002054 <sleep>
  while (lk->locked) {
    80003f9c:	409c                	lw	a5,0(s1)
    80003f9e:	fbfd                	bnez	a5,80003f94 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003fa0:	4785                	li	a5,1
    80003fa2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003fa4:	96ffd0ef          	jal	80001912 <myproc>
    80003fa8:	591c                	lw	a5,48(a0)
    80003faa:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003fac:	854a                	mv	a0,s2
    80003fae:	cedfc0ef          	jal	80000c9a <release>
}
    80003fb2:	60e2                	ld	ra,24(sp)
    80003fb4:	6442                	ld	s0,16(sp)
    80003fb6:	64a2                	ld	s1,8(sp)
    80003fb8:	6902                	ld	s2,0(sp)
    80003fba:	6105                	addi	sp,sp,32
    80003fbc:	8082                	ret

0000000080003fbe <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003fbe:	1101                	addi	sp,sp,-32
    80003fc0:	ec06                	sd	ra,24(sp)
    80003fc2:	e822                	sd	s0,16(sp)
    80003fc4:	e426                	sd	s1,8(sp)
    80003fc6:	e04a                	sd	s2,0(sp)
    80003fc8:	1000                	addi	s0,sp,32
    80003fca:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003fcc:	00850913          	addi	s2,a0,8
    80003fd0:	854a                	mv	a0,s2
    80003fd2:	c31fc0ef          	jal	80000c02 <acquire>
  lk->locked = 0;
    80003fd6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003fda:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003fde:	8526                	mv	a0,s1
    80003fe0:	8c0fe0ef          	jal	800020a0 <wakeup>
  release(&lk->lk);
    80003fe4:	854a                	mv	a0,s2
    80003fe6:	cb5fc0ef          	jal	80000c9a <release>
}
    80003fea:	60e2                	ld	ra,24(sp)
    80003fec:	6442                	ld	s0,16(sp)
    80003fee:	64a2                	ld	s1,8(sp)
    80003ff0:	6902                	ld	s2,0(sp)
    80003ff2:	6105                	addi	sp,sp,32
    80003ff4:	8082                	ret

0000000080003ff6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ff6:	7179                	addi	sp,sp,-48
    80003ff8:	f406                	sd	ra,40(sp)
    80003ffa:	f022                	sd	s0,32(sp)
    80003ffc:	ec26                	sd	s1,24(sp)
    80003ffe:	e84a                	sd	s2,16(sp)
    80004000:	1800                	addi	s0,sp,48
    80004002:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004004:	00850913          	addi	s2,a0,8
    80004008:	854a                	mv	a0,s2
    8000400a:	bf9fc0ef          	jal	80000c02 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000400e:	409c                	lw	a5,0(s1)
    80004010:	ef81                	bnez	a5,80004028 <holdingsleep+0x32>
    80004012:	4481                	li	s1,0
  release(&lk->lk);
    80004014:	854a                	mv	a0,s2
    80004016:	c85fc0ef          	jal	80000c9a <release>
  return r;
}
    8000401a:	8526                	mv	a0,s1
    8000401c:	70a2                	ld	ra,40(sp)
    8000401e:	7402                	ld	s0,32(sp)
    80004020:	64e2                	ld	s1,24(sp)
    80004022:	6942                	ld	s2,16(sp)
    80004024:	6145                	addi	sp,sp,48
    80004026:	8082                	ret
    80004028:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000402a:	0284a983          	lw	s3,40(s1)
    8000402e:	8e5fd0ef          	jal	80001912 <myproc>
    80004032:	5904                	lw	s1,48(a0)
    80004034:	413484b3          	sub	s1,s1,s3
    80004038:	0014b493          	seqz	s1,s1
    8000403c:	69a2                	ld	s3,8(sp)
    8000403e:	bfd9                	j	80004014 <holdingsleep+0x1e>

0000000080004040 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004040:	1141                	addi	sp,sp,-16
    80004042:	e406                	sd	ra,8(sp)
    80004044:	e022                	sd	s0,0(sp)
    80004046:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004048:	00003597          	auipc	a1,0x3
    8000404c:	58058593          	addi	a1,a1,1408 # 800075c8 <etext+0x5c8>
    80004050:	0001f517          	auipc	a0,0x1f
    80004054:	85850513          	addi	a0,a0,-1960 # 800228a8 <ftable>
    80004058:	b2bfc0ef          	jal	80000b82 <initlock>
}
    8000405c:	60a2                	ld	ra,8(sp)
    8000405e:	6402                	ld	s0,0(sp)
    80004060:	0141                	addi	sp,sp,16
    80004062:	8082                	ret

0000000080004064 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004064:	1101                	addi	sp,sp,-32
    80004066:	ec06                	sd	ra,24(sp)
    80004068:	e822                	sd	s0,16(sp)
    8000406a:	e426                	sd	s1,8(sp)
    8000406c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000406e:	0001f517          	auipc	a0,0x1f
    80004072:	83a50513          	addi	a0,a0,-1990 # 800228a8 <ftable>
    80004076:	b8dfc0ef          	jal	80000c02 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000407a:	0001f497          	auipc	s1,0x1f
    8000407e:	84648493          	addi	s1,s1,-1978 # 800228c0 <ftable+0x18>
    80004082:	0001f717          	auipc	a4,0x1f
    80004086:	7de70713          	addi	a4,a4,2014 # 80023860 <disk>
    if(f->ref == 0){
    8000408a:	40dc                	lw	a5,4(s1)
    8000408c:	cf89                	beqz	a5,800040a6 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000408e:	02848493          	addi	s1,s1,40
    80004092:	fee49ce3          	bne	s1,a4,8000408a <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004096:	0001f517          	auipc	a0,0x1f
    8000409a:	81250513          	addi	a0,a0,-2030 # 800228a8 <ftable>
    8000409e:	bfdfc0ef          	jal	80000c9a <release>
  return 0;
    800040a2:	4481                	li	s1,0
    800040a4:	a809                	j	800040b6 <filealloc+0x52>
      f->ref = 1;
    800040a6:	4785                	li	a5,1
    800040a8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800040aa:	0001e517          	auipc	a0,0x1e
    800040ae:	7fe50513          	addi	a0,a0,2046 # 800228a8 <ftable>
    800040b2:	be9fc0ef          	jal	80000c9a <release>
}
    800040b6:	8526                	mv	a0,s1
    800040b8:	60e2                	ld	ra,24(sp)
    800040ba:	6442                	ld	s0,16(sp)
    800040bc:	64a2                	ld	s1,8(sp)
    800040be:	6105                	addi	sp,sp,32
    800040c0:	8082                	ret

00000000800040c2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800040c2:	1101                	addi	sp,sp,-32
    800040c4:	ec06                	sd	ra,24(sp)
    800040c6:	e822                	sd	s0,16(sp)
    800040c8:	e426                	sd	s1,8(sp)
    800040ca:	1000                	addi	s0,sp,32
    800040cc:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800040ce:	0001e517          	auipc	a0,0x1e
    800040d2:	7da50513          	addi	a0,a0,2010 # 800228a8 <ftable>
    800040d6:	b2dfc0ef          	jal	80000c02 <acquire>
  if(f->ref < 1)
    800040da:	40dc                	lw	a5,4(s1)
    800040dc:	02f05063          	blez	a5,800040fc <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800040e0:	2785                	addiw	a5,a5,1
    800040e2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800040e4:	0001e517          	auipc	a0,0x1e
    800040e8:	7c450513          	addi	a0,a0,1988 # 800228a8 <ftable>
    800040ec:	baffc0ef          	jal	80000c9a <release>
  return f;
}
    800040f0:	8526                	mv	a0,s1
    800040f2:	60e2                	ld	ra,24(sp)
    800040f4:	6442                	ld	s0,16(sp)
    800040f6:	64a2                	ld	s1,8(sp)
    800040f8:	6105                	addi	sp,sp,32
    800040fa:	8082                	ret
    panic("filedup");
    800040fc:	00003517          	auipc	a0,0x3
    80004100:	4d450513          	addi	a0,a0,1236 # 800075d0 <etext+0x5d0>
    80004104:	e9efc0ef          	jal	800007a2 <panic>

0000000080004108 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004108:	7139                	addi	sp,sp,-64
    8000410a:	fc06                	sd	ra,56(sp)
    8000410c:	f822                	sd	s0,48(sp)
    8000410e:	f426                	sd	s1,40(sp)
    80004110:	0080                	addi	s0,sp,64
    80004112:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004114:	0001e517          	auipc	a0,0x1e
    80004118:	79450513          	addi	a0,a0,1940 # 800228a8 <ftable>
    8000411c:	ae7fc0ef          	jal	80000c02 <acquire>
  if(f->ref < 1)
    80004120:	40dc                	lw	a5,4(s1)
    80004122:	04f05a63          	blez	a5,80004176 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80004126:	37fd                	addiw	a5,a5,-1
    80004128:	0007871b          	sext.w	a4,a5
    8000412c:	c0dc                	sw	a5,4(s1)
    8000412e:	04e04e63          	bgtz	a4,8000418a <fileclose+0x82>
    80004132:	f04a                	sd	s2,32(sp)
    80004134:	ec4e                	sd	s3,24(sp)
    80004136:	e852                	sd	s4,16(sp)
    80004138:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000413a:	0004a903          	lw	s2,0(s1)
    8000413e:	0094ca83          	lbu	s5,9(s1)
    80004142:	0104ba03          	ld	s4,16(s1)
    80004146:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000414a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000414e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004152:	0001e517          	auipc	a0,0x1e
    80004156:	75650513          	addi	a0,a0,1878 # 800228a8 <ftable>
    8000415a:	b41fc0ef          	jal	80000c9a <release>

  if(ff.type == FD_PIPE){
    8000415e:	4785                	li	a5,1
    80004160:	04f90063          	beq	s2,a5,800041a0 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004164:	3979                	addiw	s2,s2,-2
    80004166:	4785                	li	a5,1
    80004168:	0527f563          	bgeu	a5,s2,800041b2 <fileclose+0xaa>
    8000416c:	7902                	ld	s2,32(sp)
    8000416e:	69e2                	ld	s3,24(sp)
    80004170:	6a42                	ld	s4,16(sp)
    80004172:	6aa2                	ld	s5,8(sp)
    80004174:	a00d                	j	80004196 <fileclose+0x8e>
    80004176:	f04a                	sd	s2,32(sp)
    80004178:	ec4e                	sd	s3,24(sp)
    8000417a:	e852                	sd	s4,16(sp)
    8000417c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000417e:	00003517          	auipc	a0,0x3
    80004182:	45a50513          	addi	a0,a0,1114 # 800075d8 <etext+0x5d8>
    80004186:	e1cfc0ef          	jal	800007a2 <panic>
    release(&ftable.lock);
    8000418a:	0001e517          	auipc	a0,0x1e
    8000418e:	71e50513          	addi	a0,a0,1822 # 800228a8 <ftable>
    80004192:	b09fc0ef          	jal	80000c9a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004196:	70e2                	ld	ra,56(sp)
    80004198:	7442                	ld	s0,48(sp)
    8000419a:	74a2                	ld	s1,40(sp)
    8000419c:	6121                	addi	sp,sp,64
    8000419e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800041a0:	85d6                	mv	a1,s5
    800041a2:	8552                	mv	a0,s4
    800041a4:	336000ef          	jal	800044da <pipeclose>
    800041a8:	7902                	ld	s2,32(sp)
    800041aa:	69e2                	ld	s3,24(sp)
    800041ac:	6a42                	ld	s4,16(sp)
    800041ae:	6aa2                	ld	s5,8(sp)
    800041b0:	b7dd                	j	80004196 <fileclose+0x8e>
    begin_op();
    800041b2:	b3dff0ef          	jal	80003cee <begin_op>
    iput(ff.ip);
    800041b6:	854e                	mv	a0,s3
    800041b8:	c22ff0ef          	jal	800035da <iput>
    end_op();
    800041bc:	b9dff0ef          	jal	80003d58 <end_op>
    800041c0:	7902                	ld	s2,32(sp)
    800041c2:	69e2                	ld	s3,24(sp)
    800041c4:	6a42                	ld	s4,16(sp)
    800041c6:	6aa2                	ld	s5,8(sp)
    800041c8:	b7f9                	j	80004196 <fileclose+0x8e>

00000000800041ca <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800041ca:	715d                	addi	sp,sp,-80
    800041cc:	e486                	sd	ra,72(sp)
    800041ce:	e0a2                	sd	s0,64(sp)
    800041d0:	fc26                	sd	s1,56(sp)
    800041d2:	f44e                	sd	s3,40(sp)
    800041d4:	0880                	addi	s0,sp,80
    800041d6:	84aa                	mv	s1,a0
    800041d8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800041da:	f38fd0ef          	jal	80001912 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800041de:	409c                	lw	a5,0(s1)
    800041e0:	37f9                	addiw	a5,a5,-2
    800041e2:	4705                	li	a4,1
    800041e4:	04f76063          	bltu	a4,a5,80004224 <filestat+0x5a>
    800041e8:	f84a                	sd	s2,48(sp)
    800041ea:	892a                	mv	s2,a0
    ilock(f->ip);
    800041ec:	6c88                	ld	a0,24(s1)
    800041ee:	a6aff0ef          	jal	80003458 <ilock>
    stati(f->ip, &st);
    800041f2:	fb840593          	addi	a1,s0,-72
    800041f6:	6c88                	ld	a0,24(s1)
    800041f8:	c8aff0ef          	jal	80003682 <stati>
    iunlock(f->ip);
    800041fc:	6c88                	ld	a0,24(s1)
    800041fe:	b08ff0ef          	jal	80003506 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004202:	46e1                	li	a3,24
    80004204:	fb840613          	addi	a2,s0,-72
    80004208:	85ce                	mv	a1,s3
    8000420a:	05093503          	ld	a0,80(s2)
    8000420e:	b76fd0ef          	jal	80001584 <copyout>
    80004212:	41f5551b          	sraiw	a0,a0,0x1f
    80004216:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004218:	60a6                	ld	ra,72(sp)
    8000421a:	6406                	ld	s0,64(sp)
    8000421c:	74e2                	ld	s1,56(sp)
    8000421e:	79a2                	ld	s3,40(sp)
    80004220:	6161                	addi	sp,sp,80
    80004222:	8082                	ret
  return -1;
    80004224:	557d                	li	a0,-1
    80004226:	bfcd                	j	80004218 <filestat+0x4e>

0000000080004228 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004228:	7179                	addi	sp,sp,-48
    8000422a:	f406                	sd	ra,40(sp)
    8000422c:	f022                	sd	s0,32(sp)
    8000422e:	e84a                	sd	s2,16(sp)
    80004230:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004232:	00854783          	lbu	a5,8(a0)
    80004236:	cfd1                	beqz	a5,800042d2 <fileread+0xaa>
    80004238:	ec26                	sd	s1,24(sp)
    8000423a:	e44e                	sd	s3,8(sp)
    8000423c:	84aa                	mv	s1,a0
    8000423e:	89ae                	mv	s3,a1
    80004240:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004242:	411c                	lw	a5,0(a0)
    80004244:	4705                	li	a4,1
    80004246:	04e78363          	beq	a5,a4,8000428c <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000424a:	470d                	li	a4,3
    8000424c:	04e78763          	beq	a5,a4,8000429a <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004250:	4709                	li	a4,2
    80004252:	06e79a63          	bne	a5,a4,800042c6 <fileread+0x9e>
    ilock(f->ip);
    80004256:	6d08                	ld	a0,24(a0)
    80004258:	a00ff0ef          	jal	80003458 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000425c:	874a                	mv	a4,s2
    8000425e:	5094                	lw	a3,32(s1)
    80004260:	864e                	mv	a2,s3
    80004262:	4585                	li	a1,1
    80004264:	6c88                	ld	a0,24(s1)
    80004266:	c46ff0ef          	jal	800036ac <readi>
    8000426a:	892a                	mv	s2,a0
    8000426c:	00a05563          	blez	a0,80004276 <fileread+0x4e>
      f->off += r;
    80004270:	509c                	lw	a5,32(s1)
    80004272:	9fa9                	addw	a5,a5,a0
    80004274:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004276:	6c88                	ld	a0,24(s1)
    80004278:	a8eff0ef          	jal	80003506 <iunlock>
    8000427c:	64e2                	ld	s1,24(sp)
    8000427e:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004280:	854a                	mv	a0,s2
    80004282:	70a2                	ld	ra,40(sp)
    80004284:	7402                	ld	s0,32(sp)
    80004286:	6942                	ld	s2,16(sp)
    80004288:	6145                	addi	sp,sp,48
    8000428a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000428c:	6908                	ld	a0,16(a0)
    8000428e:	388000ef          	jal	80004616 <piperead>
    80004292:	892a                	mv	s2,a0
    80004294:	64e2                	ld	s1,24(sp)
    80004296:	69a2                	ld	s3,8(sp)
    80004298:	b7e5                	j	80004280 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000429a:	02451783          	lh	a5,36(a0)
    8000429e:	03079693          	slli	a3,a5,0x30
    800042a2:	92c1                	srli	a3,a3,0x30
    800042a4:	4725                	li	a4,9
    800042a6:	02d76863          	bltu	a4,a3,800042d6 <fileread+0xae>
    800042aa:	0792                	slli	a5,a5,0x4
    800042ac:	0001e717          	auipc	a4,0x1e
    800042b0:	55c70713          	addi	a4,a4,1372 # 80022808 <devsw>
    800042b4:	97ba                	add	a5,a5,a4
    800042b6:	639c                	ld	a5,0(a5)
    800042b8:	c39d                	beqz	a5,800042de <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800042ba:	4505                	li	a0,1
    800042bc:	9782                	jalr	a5
    800042be:	892a                	mv	s2,a0
    800042c0:	64e2                	ld	s1,24(sp)
    800042c2:	69a2                	ld	s3,8(sp)
    800042c4:	bf75                	j	80004280 <fileread+0x58>
    panic("fileread");
    800042c6:	00003517          	auipc	a0,0x3
    800042ca:	32250513          	addi	a0,a0,802 # 800075e8 <etext+0x5e8>
    800042ce:	cd4fc0ef          	jal	800007a2 <panic>
    return -1;
    800042d2:	597d                	li	s2,-1
    800042d4:	b775                	j	80004280 <fileread+0x58>
      return -1;
    800042d6:	597d                	li	s2,-1
    800042d8:	64e2                	ld	s1,24(sp)
    800042da:	69a2                	ld	s3,8(sp)
    800042dc:	b755                	j	80004280 <fileread+0x58>
    800042de:	597d                	li	s2,-1
    800042e0:	64e2                	ld	s1,24(sp)
    800042e2:	69a2                	ld	s3,8(sp)
    800042e4:	bf71                	j	80004280 <fileread+0x58>

00000000800042e6 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800042e6:	00954783          	lbu	a5,9(a0)
    800042ea:	10078b63          	beqz	a5,80004400 <filewrite+0x11a>
{
    800042ee:	715d                	addi	sp,sp,-80
    800042f0:	e486                	sd	ra,72(sp)
    800042f2:	e0a2                	sd	s0,64(sp)
    800042f4:	f84a                	sd	s2,48(sp)
    800042f6:	f052                	sd	s4,32(sp)
    800042f8:	e85a                	sd	s6,16(sp)
    800042fa:	0880                	addi	s0,sp,80
    800042fc:	892a                	mv	s2,a0
    800042fe:	8b2e                	mv	s6,a1
    80004300:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004302:	411c                	lw	a5,0(a0)
    80004304:	4705                	li	a4,1
    80004306:	02e78763          	beq	a5,a4,80004334 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000430a:	470d                	li	a4,3
    8000430c:	02e78863          	beq	a5,a4,8000433c <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004310:	4709                	li	a4,2
    80004312:	0ce79c63          	bne	a5,a4,800043ea <filewrite+0x104>
    80004316:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004318:	0ac05863          	blez	a2,800043c8 <filewrite+0xe2>
    8000431c:	fc26                	sd	s1,56(sp)
    8000431e:	ec56                	sd	s5,24(sp)
    80004320:	e45e                	sd	s7,8(sp)
    80004322:	e062                	sd	s8,0(sp)
    int i = 0;
    80004324:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004326:	6b85                	lui	s7,0x1
    80004328:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000432c:	6c05                	lui	s8,0x1
    8000432e:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004332:	a8b5                	j	800043ae <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80004334:	6908                	ld	a0,16(a0)
    80004336:	1fc000ef          	jal	80004532 <pipewrite>
    8000433a:	a04d                	j	800043dc <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000433c:	02451783          	lh	a5,36(a0)
    80004340:	03079693          	slli	a3,a5,0x30
    80004344:	92c1                	srli	a3,a3,0x30
    80004346:	4725                	li	a4,9
    80004348:	0ad76e63          	bltu	a4,a3,80004404 <filewrite+0x11e>
    8000434c:	0792                	slli	a5,a5,0x4
    8000434e:	0001e717          	auipc	a4,0x1e
    80004352:	4ba70713          	addi	a4,a4,1210 # 80022808 <devsw>
    80004356:	97ba                	add	a5,a5,a4
    80004358:	679c                	ld	a5,8(a5)
    8000435a:	c7dd                	beqz	a5,80004408 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    8000435c:	4505                	li	a0,1
    8000435e:	9782                	jalr	a5
    80004360:	a8b5                	j	800043dc <filewrite+0xf6>
      if(n1 > max)
    80004362:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004366:	989ff0ef          	jal	80003cee <begin_op>
      ilock(f->ip);
    8000436a:	01893503          	ld	a0,24(s2)
    8000436e:	8eaff0ef          	jal	80003458 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004372:	8756                	mv	a4,s5
    80004374:	02092683          	lw	a3,32(s2)
    80004378:	01698633          	add	a2,s3,s6
    8000437c:	4585                	li	a1,1
    8000437e:	01893503          	ld	a0,24(s2)
    80004382:	c26ff0ef          	jal	800037a8 <writei>
    80004386:	84aa                	mv	s1,a0
    80004388:	00a05763          	blez	a0,80004396 <filewrite+0xb0>
        f->off += r;
    8000438c:	02092783          	lw	a5,32(s2)
    80004390:	9fa9                	addw	a5,a5,a0
    80004392:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004396:	01893503          	ld	a0,24(s2)
    8000439a:	96cff0ef          	jal	80003506 <iunlock>
      end_op();
    8000439e:	9bbff0ef          	jal	80003d58 <end_op>

      if(r != n1){
    800043a2:	029a9563          	bne	s5,s1,800043cc <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800043a6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800043aa:	0149da63          	bge	s3,s4,800043be <filewrite+0xd8>
      int n1 = n - i;
    800043ae:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800043b2:	0004879b          	sext.w	a5,s1
    800043b6:	fafbd6e3          	bge	s7,a5,80004362 <filewrite+0x7c>
    800043ba:	84e2                	mv	s1,s8
    800043bc:	b75d                	j	80004362 <filewrite+0x7c>
    800043be:	74e2                	ld	s1,56(sp)
    800043c0:	6ae2                	ld	s5,24(sp)
    800043c2:	6ba2                	ld	s7,8(sp)
    800043c4:	6c02                	ld	s8,0(sp)
    800043c6:	a039                	j	800043d4 <filewrite+0xee>
    int i = 0;
    800043c8:	4981                	li	s3,0
    800043ca:	a029                	j	800043d4 <filewrite+0xee>
    800043cc:	74e2                	ld	s1,56(sp)
    800043ce:	6ae2                	ld	s5,24(sp)
    800043d0:	6ba2                	ld	s7,8(sp)
    800043d2:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800043d4:	033a1c63          	bne	s4,s3,8000440c <filewrite+0x126>
    800043d8:	8552                	mv	a0,s4
    800043da:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800043dc:	60a6                	ld	ra,72(sp)
    800043de:	6406                	ld	s0,64(sp)
    800043e0:	7942                	ld	s2,48(sp)
    800043e2:	7a02                	ld	s4,32(sp)
    800043e4:	6b42                	ld	s6,16(sp)
    800043e6:	6161                	addi	sp,sp,80
    800043e8:	8082                	ret
    800043ea:	fc26                	sd	s1,56(sp)
    800043ec:	f44e                	sd	s3,40(sp)
    800043ee:	ec56                	sd	s5,24(sp)
    800043f0:	e45e                	sd	s7,8(sp)
    800043f2:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800043f4:	00003517          	auipc	a0,0x3
    800043f8:	20450513          	addi	a0,a0,516 # 800075f8 <etext+0x5f8>
    800043fc:	ba6fc0ef          	jal	800007a2 <panic>
    return -1;
    80004400:	557d                	li	a0,-1
}
    80004402:	8082                	ret
      return -1;
    80004404:	557d                	li	a0,-1
    80004406:	bfd9                	j	800043dc <filewrite+0xf6>
    80004408:	557d                	li	a0,-1
    8000440a:	bfc9                	j	800043dc <filewrite+0xf6>
    ret = (i == n ? n : -1);
    8000440c:	557d                	li	a0,-1
    8000440e:	79a2                	ld	s3,40(sp)
    80004410:	b7f1                	j	800043dc <filewrite+0xf6>

0000000080004412 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004412:	7179                	addi	sp,sp,-48
    80004414:	f406                	sd	ra,40(sp)
    80004416:	f022                	sd	s0,32(sp)
    80004418:	ec26                	sd	s1,24(sp)
    8000441a:	e052                	sd	s4,0(sp)
    8000441c:	1800                	addi	s0,sp,48
    8000441e:	84aa                	mv	s1,a0
    80004420:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004422:	0005b023          	sd	zero,0(a1)
    80004426:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000442a:	c3bff0ef          	jal	80004064 <filealloc>
    8000442e:	e088                	sd	a0,0(s1)
    80004430:	c549                	beqz	a0,800044ba <pipealloc+0xa8>
    80004432:	c33ff0ef          	jal	80004064 <filealloc>
    80004436:	00aa3023          	sd	a0,0(s4)
    8000443a:	cd25                	beqz	a0,800044b2 <pipealloc+0xa0>
    8000443c:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000443e:	ef4fc0ef          	jal	80000b32 <kalloc>
    80004442:	892a                	mv	s2,a0
    80004444:	c12d                	beqz	a0,800044a6 <pipealloc+0x94>
    80004446:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004448:	4985                	li	s3,1
    8000444a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000444e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004452:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004456:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000445a:	00003597          	auipc	a1,0x3
    8000445e:	1ae58593          	addi	a1,a1,430 # 80007608 <etext+0x608>
    80004462:	f20fc0ef          	jal	80000b82 <initlock>
  (*f0)->type = FD_PIPE;
    80004466:	609c                	ld	a5,0(s1)
    80004468:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000446c:	609c                	ld	a5,0(s1)
    8000446e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004472:	609c                	ld	a5,0(s1)
    80004474:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004478:	609c                	ld	a5,0(s1)
    8000447a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000447e:	000a3783          	ld	a5,0(s4)
    80004482:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004486:	000a3783          	ld	a5,0(s4)
    8000448a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000448e:	000a3783          	ld	a5,0(s4)
    80004492:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004496:	000a3783          	ld	a5,0(s4)
    8000449a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000449e:	4501                	li	a0,0
    800044a0:	6942                	ld	s2,16(sp)
    800044a2:	69a2                	ld	s3,8(sp)
    800044a4:	a01d                	j	800044ca <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800044a6:	6088                	ld	a0,0(s1)
    800044a8:	c119                	beqz	a0,800044ae <pipealloc+0x9c>
    800044aa:	6942                	ld	s2,16(sp)
    800044ac:	a029                	j	800044b6 <pipealloc+0xa4>
    800044ae:	6942                	ld	s2,16(sp)
    800044b0:	a029                	j	800044ba <pipealloc+0xa8>
    800044b2:	6088                	ld	a0,0(s1)
    800044b4:	c10d                	beqz	a0,800044d6 <pipealloc+0xc4>
    fileclose(*f0);
    800044b6:	c53ff0ef          	jal	80004108 <fileclose>
  if(*f1)
    800044ba:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800044be:	557d                	li	a0,-1
  if(*f1)
    800044c0:	c789                	beqz	a5,800044ca <pipealloc+0xb8>
    fileclose(*f1);
    800044c2:	853e                	mv	a0,a5
    800044c4:	c45ff0ef          	jal	80004108 <fileclose>
  return -1;
    800044c8:	557d                	li	a0,-1
}
    800044ca:	70a2                	ld	ra,40(sp)
    800044cc:	7402                	ld	s0,32(sp)
    800044ce:	64e2                	ld	s1,24(sp)
    800044d0:	6a02                	ld	s4,0(sp)
    800044d2:	6145                	addi	sp,sp,48
    800044d4:	8082                	ret
  return -1;
    800044d6:	557d                	li	a0,-1
    800044d8:	bfcd                	j	800044ca <pipealloc+0xb8>

00000000800044da <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800044da:	1101                	addi	sp,sp,-32
    800044dc:	ec06                	sd	ra,24(sp)
    800044de:	e822                	sd	s0,16(sp)
    800044e0:	e426                	sd	s1,8(sp)
    800044e2:	e04a                	sd	s2,0(sp)
    800044e4:	1000                	addi	s0,sp,32
    800044e6:	84aa                	mv	s1,a0
    800044e8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800044ea:	f18fc0ef          	jal	80000c02 <acquire>
  if(writable){
    800044ee:	02090763          	beqz	s2,8000451c <pipeclose+0x42>
    pi->writeopen = 0;
    800044f2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800044f6:	21848513          	addi	a0,s1,536
    800044fa:	ba7fd0ef          	jal	800020a0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800044fe:	2204b783          	ld	a5,544(s1)
    80004502:	e785                	bnez	a5,8000452a <pipeclose+0x50>
    release(&pi->lock);
    80004504:	8526                	mv	a0,s1
    80004506:	f94fc0ef          	jal	80000c9a <release>
    kfree((char*)pi);
    8000450a:	8526                	mv	a0,s1
    8000450c:	d44fc0ef          	jal	80000a50 <kfree>
  } else
    release(&pi->lock);
}
    80004510:	60e2                	ld	ra,24(sp)
    80004512:	6442                	ld	s0,16(sp)
    80004514:	64a2                	ld	s1,8(sp)
    80004516:	6902                	ld	s2,0(sp)
    80004518:	6105                	addi	sp,sp,32
    8000451a:	8082                	ret
    pi->readopen = 0;
    8000451c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004520:	21c48513          	addi	a0,s1,540
    80004524:	b7dfd0ef          	jal	800020a0 <wakeup>
    80004528:	bfd9                	j	800044fe <pipeclose+0x24>
    release(&pi->lock);
    8000452a:	8526                	mv	a0,s1
    8000452c:	f6efc0ef          	jal	80000c9a <release>
}
    80004530:	b7c5                	j	80004510 <pipeclose+0x36>

0000000080004532 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004532:	711d                	addi	sp,sp,-96
    80004534:	ec86                	sd	ra,88(sp)
    80004536:	e8a2                	sd	s0,80(sp)
    80004538:	e4a6                	sd	s1,72(sp)
    8000453a:	e0ca                	sd	s2,64(sp)
    8000453c:	fc4e                	sd	s3,56(sp)
    8000453e:	f852                	sd	s4,48(sp)
    80004540:	f456                	sd	s5,40(sp)
    80004542:	1080                	addi	s0,sp,96
    80004544:	84aa                	mv	s1,a0
    80004546:	8aae                	mv	s5,a1
    80004548:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000454a:	bc8fd0ef          	jal	80001912 <myproc>
    8000454e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004550:	8526                	mv	a0,s1
    80004552:	eb0fc0ef          	jal	80000c02 <acquire>
  while(i < n){
    80004556:	0b405a63          	blez	s4,8000460a <pipewrite+0xd8>
    8000455a:	f05a                	sd	s6,32(sp)
    8000455c:	ec5e                	sd	s7,24(sp)
    8000455e:	e862                	sd	s8,16(sp)
  int i = 0;
    80004560:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004562:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004564:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004568:	21c48b93          	addi	s7,s1,540
    8000456c:	a81d                	j	800045a2 <pipewrite+0x70>
      release(&pi->lock);
    8000456e:	8526                	mv	a0,s1
    80004570:	f2afc0ef          	jal	80000c9a <release>
      return -1;
    80004574:	597d                	li	s2,-1
    80004576:	7b02                	ld	s6,32(sp)
    80004578:	6be2                	ld	s7,24(sp)
    8000457a:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000457c:	854a                	mv	a0,s2
    8000457e:	60e6                	ld	ra,88(sp)
    80004580:	6446                	ld	s0,80(sp)
    80004582:	64a6                	ld	s1,72(sp)
    80004584:	6906                	ld	s2,64(sp)
    80004586:	79e2                	ld	s3,56(sp)
    80004588:	7a42                	ld	s4,48(sp)
    8000458a:	7aa2                	ld	s5,40(sp)
    8000458c:	6125                	addi	sp,sp,96
    8000458e:	8082                	ret
      wakeup(&pi->nread);
    80004590:	8562                	mv	a0,s8
    80004592:	b0ffd0ef          	jal	800020a0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004596:	85a6                	mv	a1,s1
    80004598:	855e                	mv	a0,s7
    8000459a:	abbfd0ef          	jal	80002054 <sleep>
  while(i < n){
    8000459e:	05495b63          	bge	s2,s4,800045f4 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    800045a2:	2204a783          	lw	a5,544(s1)
    800045a6:	d7e1                	beqz	a5,8000456e <pipewrite+0x3c>
    800045a8:	854e                	mv	a0,s3
    800045aa:	ce3fd0ef          	jal	8000228c <killed>
    800045ae:	f161                	bnez	a0,8000456e <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800045b0:	2184a783          	lw	a5,536(s1)
    800045b4:	21c4a703          	lw	a4,540(s1)
    800045b8:	2007879b          	addiw	a5,a5,512
    800045bc:	fcf70ae3          	beq	a4,a5,80004590 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800045c0:	4685                	li	a3,1
    800045c2:	01590633          	add	a2,s2,s5
    800045c6:	faf40593          	addi	a1,s0,-81
    800045ca:	0509b503          	ld	a0,80(s3)
    800045ce:	88cfd0ef          	jal	8000165a <copyin>
    800045d2:	03650e63          	beq	a0,s6,8000460e <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800045d6:	21c4a783          	lw	a5,540(s1)
    800045da:	0017871b          	addiw	a4,a5,1
    800045de:	20e4ae23          	sw	a4,540(s1)
    800045e2:	1ff7f793          	andi	a5,a5,511
    800045e6:	97a6                	add	a5,a5,s1
    800045e8:	faf44703          	lbu	a4,-81(s0)
    800045ec:	00e78c23          	sb	a4,24(a5)
      i++;
    800045f0:	2905                	addiw	s2,s2,1
    800045f2:	b775                	j	8000459e <pipewrite+0x6c>
    800045f4:	7b02                	ld	s6,32(sp)
    800045f6:	6be2                	ld	s7,24(sp)
    800045f8:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800045fa:	21848513          	addi	a0,s1,536
    800045fe:	aa3fd0ef          	jal	800020a0 <wakeup>
  release(&pi->lock);
    80004602:	8526                	mv	a0,s1
    80004604:	e96fc0ef          	jal	80000c9a <release>
  return i;
    80004608:	bf95                	j	8000457c <pipewrite+0x4a>
  int i = 0;
    8000460a:	4901                	li	s2,0
    8000460c:	b7fd                	j	800045fa <pipewrite+0xc8>
    8000460e:	7b02                	ld	s6,32(sp)
    80004610:	6be2                	ld	s7,24(sp)
    80004612:	6c42                	ld	s8,16(sp)
    80004614:	b7dd                	j	800045fa <pipewrite+0xc8>

0000000080004616 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004616:	715d                	addi	sp,sp,-80
    80004618:	e486                	sd	ra,72(sp)
    8000461a:	e0a2                	sd	s0,64(sp)
    8000461c:	fc26                	sd	s1,56(sp)
    8000461e:	f84a                	sd	s2,48(sp)
    80004620:	f44e                	sd	s3,40(sp)
    80004622:	f052                	sd	s4,32(sp)
    80004624:	ec56                	sd	s5,24(sp)
    80004626:	0880                	addi	s0,sp,80
    80004628:	84aa                	mv	s1,a0
    8000462a:	892e                	mv	s2,a1
    8000462c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000462e:	ae4fd0ef          	jal	80001912 <myproc>
    80004632:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004634:	8526                	mv	a0,s1
    80004636:	dccfc0ef          	jal	80000c02 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000463a:	2184a703          	lw	a4,536(s1)
    8000463e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004642:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004646:	02f71563          	bne	a4,a5,80004670 <piperead+0x5a>
    8000464a:	2244a783          	lw	a5,548(s1)
    8000464e:	cb85                	beqz	a5,8000467e <piperead+0x68>
    if(killed(pr)){
    80004650:	8552                	mv	a0,s4
    80004652:	c3bfd0ef          	jal	8000228c <killed>
    80004656:	ed19                	bnez	a0,80004674 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004658:	85a6                	mv	a1,s1
    8000465a:	854e                	mv	a0,s3
    8000465c:	9f9fd0ef          	jal	80002054 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004660:	2184a703          	lw	a4,536(s1)
    80004664:	21c4a783          	lw	a5,540(s1)
    80004668:	fef701e3          	beq	a4,a5,8000464a <piperead+0x34>
    8000466c:	e85a                	sd	s6,16(sp)
    8000466e:	a809                	j	80004680 <piperead+0x6a>
    80004670:	e85a                	sd	s6,16(sp)
    80004672:	a039                	j	80004680 <piperead+0x6a>
      release(&pi->lock);
    80004674:	8526                	mv	a0,s1
    80004676:	e24fc0ef          	jal	80000c9a <release>
      return -1;
    8000467a:	59fd                	li	s3,-1
    8000467c:	a8b1                	j	800046d8 <piperead+0xc2>
    8000467e:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004680:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004682:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004684:	05505263          	blez	s5,800046c8 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004688:	2184a783          	lw	a5,536(s1)
    8000468c:	21c4a703          	lw	a4,540(s1)
    80004690:	02f70c63          	beq	a4,a5,800046c8 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004694:	0017871b          	addiw	a4,a5,1
    80004698:	20e4ac23          	sw	a4,536(s1)
    8000469c:	1ff7f793          	andi	a5,a5,511
    800046a0:	97a6                	add	a5,a5,s1
    800046a2:	0187c783          	lbu	a5,24(a5)
    800046a6:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800046aa:	4685                	li	a3,1
    800046ac:	fbf40613          	addi	a2,s0,-65
    800046b0:	85ca                	mv	a1,s2
    800046b2:	050a3503          	ld	a0,80(s4)
    800046b6:	ecffc0ef          	jal	80001584 <copyout>
    800046ba:	01650763          	beq	a0,s6,800046c8 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800046be:	2985                	addiw	s3,s3,1
    800046c0:	0905                	addi	s2,s2,1
    800046c2:	fd3a93e3          	bne	s5,s3,80004688 <piperead+0x72>
    800046c6:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800046c8:	21c48513          	addi	a0,s1,540
    800046cc:	9d5fd0ef          	jal	800020a0 <wakeup>
  release(&pi->lock);
    800046d0:	8526                	mv	a0,s1
    800046d2:	dc8fc0ef          	jal	80000c9a <release>
    800046d6:	6b42                	ld	s6,16(sp)
  return i;
}
    800046d8:	854e                	mv	a0,s3
    800046da:	60a6                	ld	ra,72(sp)
    800046dc:	6406                	ld	s0,64(sp)
    800046de:	74e2                	ld	s1,56(sp)
    800046e0:	7942                	ld	s2,48(sp)
    800046e2:	79a2                	ld	s3,40(sp)
    800046e4:	7a02                	ld	s4,32(sp)
    800046e6:	6ae2                	ld	s5,24(sp)
    800046e8:	6161                	addi	sp,sp,80
    800046ea:	8082                	ret

00000000800046ec <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800046ec:	1141                	addi	sp,sp,-16
    800046ee:	e422                	sd	s0,8(sp)
    800046f0:	0800                	addi	s0,sp,16
    800046f2:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800046f4:	8905                	andi	a0,a0,1
    800046f6:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800046f8:	8b89                	andi	a5,a5,2
    800046fa:	c399                	beqz	a5,80004700 <flags2perm+0x14>
      perm |= PTE_W;
    800046fc:	00456513          	ori	a0,a0,4
    return perm;
}
    80004700:	6422                	ld	s0,8(sp)
    80004702:	0141                	addi	sp,sp,16
    80004704:	8082                	ret

0000000080004706 <exec>:

int
exec(char *path, char **argv)
{
    80004706:	df010113          	addi	sp,sp,-528
    8000470a:	20113423          	sd	ra,520(sp)
    8000470e:	20813023          	sd	s0,512(sp)
    80004712:	ffa6                	sd	s1,504(sp)
    80004714:	fbca                	sd	s2,496(sp)
    80004716:	0c00                	addi	s0,sp,528
    80004718:	892a                	mv	s2,a0
    8000471a:	dea43c23          	sd	a0,-520(s0)
    8000471e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004722:	9f0fd0ef          	jal	80001912 <myproc>
    80004726:	84aa                	mv	s1,a0

  begin_op();
    80004728:	dc6ff0ef          	jal	80003cee <begin_op>

  if((ip = namei(path)) == 0){
    8000472c:	854a                	mv	a0,s2
    8000472e:	c04ff0ef          	jal	80003b32 <namei>
    80004732:	c931                	beqz	a0,80004786 <exec+0x80>
    80004734:	f3d2                	sd	s4,480(sp)
    80004736:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004738:	d21fe0ef          	jal	80003458 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000473c:	04000713          	li	a4,64
    80004740:	4681                	li	a3,0
    80004742:	e5040613          	addi	a2,s0,-432
    80004746:	4581                	li	a1,0
    80004748:	8552                	mv	a0,s4
    8000474a:	f63fe0ef          	jal	800036ac <readi>
    8000474e:	04000793          	li	a5,64
    80004752:	00f51a63          	bne	a0,a5,80004766 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004756:	e5042703          	lw	a4,-432(s0)
    8000475a:	464c47b7          	lui	a5,0x464c4
    8000475e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004762:	02f70663          	beq	a4,a5,8000478e <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004766:	8552                	mv	a0,s4
    80004768:	efbfe0ef          	jal	80003662 <iunlockput>
    end_op();
    8000476c:	decff0ef          	jal	80003d58 <end_op>
  }
  return -1;
    80004770:	557d                	li	a0,-1
    80004772:	7a1e                	ld	s4,480(sp)
}
    80004774:	20813083          	ld	ra,520(sp)
    80004778:	20013403          	ld	s0,512(sp)
    8000477c:	74fe                	ld	s1,504(sp)
    8000477e:	795e                	ld	s2,496(sp)
    80004780:	21010113          	addi	sp,sp,528
    80004784:	8082                	ret
    end_op();
    80004786:	dd2ff0ef          	jal	80003d58 <end_op>
    return -1;
    8000478a:	557d                	li	a0,-1
    8000478c:	b7e5                	j	80004774 <exec+0x6e>
    8000478e:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004790:	8526                	mv	a0,s1
    80004792:	b18fd0ef          	jal	80001aaa <proc_pagetable>
    80004796:	8b2a                	mv	s6,a0
    80004798:	2c050b63          	beqz	a0,80004a6e <exec+0x368>
    8000479c:	f7ce                	sd	s3,488(sp)
    8000479e:	efd6                	sd	s5,472(sp)
    800047a0:	e7de                	sd	s7,456(sp)
    800047a2:	e3e2                	sd	s8,448(sp)
    800047a4:	ff66                	sd	s9,440(sp)
    800047a6:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800047a8:	e7042d03          	lw	s10,-400(s0)
    800047ac:	e8845783          	lhu	a5,-376(s0)
    800047b0:	12078963          	beqz	a5,800048e2 <exec+0x1dc>
    800047b4:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800047b6:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800047b8:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800047ba:	6c85                	lui	s9,0x1
    800047bc:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800047c0:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800047c4:	6a85                	lui	s5,0x1
    800047c6:	a085                	j	80004826 <exec+0x120>
      panic("loadseg: address should exist");
    800047c8:	00003517          	auipc	a0,0x3
    800047cc:	e4850513          	addi	a0,a0,-440 # 80007610 <etext+0x610>
    800047d0:	fd3fb0ef          	jal	800007a2 <panic>
    if(sz - i < PGSIZE)
    800047d4:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800047d6:	8726                	mv	a4,s1
    800047d8:	012c06bb          	addw	a3,s8,s2
    800047dc:	4581                	li	a1,0
    800047de:	8552                	mv	a0,s4
    800047e0:	ecdfe0ef          	jal	800036ac <readi>
    800047e4:	2501                	sext.w	a0,a0
    800047e6:	24a49a63          	bne	s1,a0,80004a3a <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    800047ea:	012a893b          	addw	s2,s5,s2
    800047ee:	03397363          	bgeu	s2,s3,80004814 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    800047f2:	02091593          	slli	a1,s2,0x20
    800047f6:	9181                	srli	a1,a1,0x20
    800047f8:	95de                	add	a1,a1,s7
    800047fa:	855a                	mv	a0,s6
    800047fc:	fe8fc0ef          	jal	80000fe4 <walkaddr>
    80004800:	862a                	mv	a2,a0
    if(pa == 0)
    80004802:	d179                	beqz	a0,800047c8 <exec+0xc2>
    if(sz - i < PGSIZE)
    80004804:	412984bb          	subw	s1,s3,s2
    80004808:	0004879b          	sext.w	a5,s1
    8000480c:	fcfcf4e3          	bgeu	s9,a5,800047d4 <exec+0xce>
    80004810:	84d6                	mv	s1,s5
    80004812:	b7c9                	j	800047d4 <exec+0xce>
    sz = sz1;
    80004814:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004818:	2d85                	addiw	s11,s11,1
    8000481a:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    8000481e:	e8845783          	lhu	a5,-376(s0)
    80004822:	08fdd063          	bge	s11,a5,800048a2 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004826:	2d01                	sext.w	s10,s10
    80004828:	03800713          	li	a4,56
    8000482c:	86ea                	mv	a3,s10
    8000482e:	e1840613          	addi	a2,s0,-488
    80004832:	4581                	li	a1,0
    80004834:	8552                	mv	a0,s4
    80004836:	e77fe0ef          	jal	800036ac <readi>
    8000483a:	03800793          	li	a5,56
    8000483e:	1cf51663          	bne	a0,a5,80004a0a <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004842:	e1842783          	lw	a5,-488(s0)
    80004846:	4705                	li	a4,1
    80004848:	fce798e3          	bne	a5,a4,80004818 <exec+0x112>
    if(ph.memsz < ph.filesz)
    8000484c:	e4043483          	ld	s1,-448(s0)
    80004850:	e3843783          	ld	a5,-456(s0)
    80004854:	1af4ef63          	bltu	s1,a5,80004a12 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004858:	e2843783          	ld	a5,-472(s0)
    8000485c:	94be                	add	s1,s1,a5
    8000485e:	1af4ee63          	bltu	s1,a5,80004a1a <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80004862:	df043703          	ld	a4,-528(s0)
    80004866:	8ff9                	and	a5,a5,a4
    80004868:	1a079d63          	bnez	a5,80004a22 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000486c:	e1c42503          	lw	a0,-484(s0)
    80004870:	e7dff0ef          	jal	800046ec <flags2perm>
    80004874:	86aa                	mv	a3,a0
    80004876:	8626                	mv	a2,s1
    80004878:	85ca                	mv	a1,s2
    8000487a:	855a                	mv	a0,s6
    8000487c:	af5fc0ef          	jal	80001370 <uvmalloc>
    80004880:	e0a43423          	sd	a0,-504(s0)
    80004884:	1a050363          	beqz	a0,80004a2a <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004888:	e2843b83          	ld	s7,-472(s0)
    8000488c:	e2042c03          	lw	s8,-480(s0)
    80004890:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004894:	00098463          	beqz	s3,8000489c <exec+0x196>
    80004898:	4901                	li	s2,0
    8000489a:	bfa1                	j	800047f2 <exec+0xec>
    sz = sz1;
    8000489c:	e0843903          	ld	s2,-504(s0)
    800048a0:	bfa5                	j	80004818 <exec+0x112>
    800048a2:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800048a4:	8552                	mv	a0,s4
    800048a6:	dbdfe0ef          	jal	80003662 <iunlockput>
  end_op();
    800048aa:	caeff0ef          	jal	80003d58 <end_op>
  p = myproc();
    800048ae:	864fd0ef          	jal	80001912 <myproc>
    800048b2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800048b4:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800048b8:	6985                	lui	s3,0x1
    800048ba:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800048bc:	99ca                	add	s3,s3,s2
    800048be:	77fd                	lui	a5,0xfffff
    800048c0:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800048c4:	4691                	li	a3,4
    800048c6:	6609                	lui	a2,0x2
    800048c8:	964e                	add	a2,a2,s3
    800048ca:	85ce                	mv	a1,s3
    800048cc:	855a                	mv	a0,s6
    800048ce:	aa3fc0ef          	jal	80001370 <uvmalloc>
    800048d2:	892a                	mv	s2,a0
    800048d4:	e0a43423          	sd	a0,-504(s0)
    800048d8:	e519                	bnez	a0,800048e6 <exec+0x1e0>
  if(pagetable)
    800048da:	e1343423          	sd	s3,-504(s0)
    800048de:	4a01                	li	s4,0
    800048e0:	aab1                	j	80004a3c <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800048e2:	4901                	li	s2,0
    800048e4:	b7c1                	j	800048a4 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800048e6:	75f9                	lui	a1,0xffffe
    800048e8:	95aa                	add	a1,a1,a0
    800048ea:	855a                	mv	a0,s6
    800048ec:	c6ffc0ef          	jal	8000155a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800048f0:	7bfd                	lui	s7,0xfffff
    800048f2:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800048f4:	e0043783          	ld	a5,-512(s0)
    800048f8:	6388                	ld	a0,0(a5)
    800048fa:	cd39                	beqz	a0,80004958 <exec+0x252>
    800048fc:	e9040993          	addi	s3,s0,-368
    80004900:	f9040c13          	addi	s8,s0,-112
    80004904:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004906:	d40fc0ef          	jal	80000e46 <strlen>
    8000490a:	0015079b          	addiw	a5,a0,1
    8000490e:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004912:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004916:	11796e63          	bltu	s2,s7,80004a32 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000491a:	e0043d03          	ld	s10,-512(s0)
    8000491e:	000d3a03          	ld	s4,0(s10)
    80004922:	8552                	mv	a0,s4
    80004924:	d22fc0ef          	jal	80000e46 <strlen>
    80004928:	0015069b          	addiw	a3,a0,1
    8000492c:	8652                	mv	a2,s4
    8000492e:	85ca                	mv	a1,s2
    80004930:	855a                	mv	a0,s6
    80004932:	c53fc0ef          	jal	80001584 <copyout>
    80004936:	10054063          	bltz	a0,80004a36 <exec+0x330>
    ustack[argc] = sp;
    8000493a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000493e:	0485                	addi	s1,s1,1
    80004940:	008d0793          	addi	a5,s10,8
    80004944:	e0f43023          	sd	a5,-512(s0)
    80004948:	008d3503          	ld	a0,8(s10)
    8000494c:	c909                	beqz	a0,8000495e <exec+0x258>
    if(argc >= MAXARG)
    8000494e:	09a1                	addi	s3,s3,8
    80004950:	fb899be3          	bne	s3,s8,80004906 <exec+0x200>
  ip = 0;
    80004954:	4a01                	li	s4,0
    80004956:	a0dd                	j	80004a3c <exec+0x336>
  sp = sz;
    80004958:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000495c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000495e:	00349793          	slli	a5,s1,0x3
    80004962:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb5f0>
    80004966:	97a2                	add	a5,a5,s0
    80004968:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000496c:	00148693          	addi	a3,s1,1
    80004970:	068e                	slli	a3,a3,0x3
    80004972:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004976:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000497a:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000497e:	f5796ee3          	bltu	s2,s7,800048da <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004982:	e9040613          	addi	a2,s0,-368
    80004986:	85ca                	mv	a1,s2
    80004988:	855a                	mv	a0,s6
    8000498a:	bfbfc0ef          	jal	80001584 <copyout>
    8000498e:	0e054263          	bltz	a0,80004a72 <exec+0x36c>
  p->trapframe->a1 = sp;
    80004992:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004996:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000499a:	df843783          	ld	a5,-520(s0)
    8000499e:	0007c703          	lbu	a4,0(a5)
    800049a2:	cf11                	beqz	a4,800049be <exec+0x2b8>
    800049a4:	0785                	addi	a5,a5,1
    if(*s == '/')
    800049a6:	02f00693          	li	a3,47
    800049aa:	a039                	j	800049b8 <exec+0x2b2>
      last = s+1;
    800049ac:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800049b0:	0785                	addi	a5,a5,1
    800049b2:	fff7c703          	lbu	a4,-1(a5)
    800049b6:	c701                	beqz	a4,800049be <exec+0x2b8>
    if(*s == '/')
    800049b8:	fed71ce3          	bne	a4,a3,800049b0 <exec+0x2aa>
    800049bc:	bfc5                	j	800049ac <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    800049be:	4641                	li	a2,16
    800049c0:	df843583          	ld	a1,-520(s0)
    800049c4:	158a8513          	addi	a0,s5,344
    800049c8:	c4cfc0ef          	jal	80000e14 <safestrcpy>
  oldpagetable = p->pagetable;
    800049cc:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800049d0:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800049d4:	e0843783          	ld	a5,-504(s0)
    800049d8:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800049dc:	058ab783          	ld	a5,88(s5)
    800049e0:	e6843703          	ld	a4,-408(s0)
    800049e4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800049e6:	058ab783          	ld	a5,88(s5)
    800049ea:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800049ee:	85e6                	mv	a1,s9
    800049f0:	93efd0ef          	jal	80001b2e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800049f4:	0004851b          	sext.w	a0,s1
    800049f8:	79be                	ld	s3,488(sp)
    800049fa:	7a1e                	ld	s4,480(sp)
    800049fc:	6afe                	ld	s5,472(sp)
    800049fe:	6b5e                	ld	s6,464(sp)
    80004a00:	6bbe                	ld	s7,456(sp)
    80004a02:	6c1e                	ld	s8,448(sp)
    80004a04:	7cfa                	ld	s9,440(sp)
    80004a06:	7d5a                	ld	s10,432(sp)
    80004a08:	b3b5                	j	80004774 <exec+0x6e>
    80004a0a:	e1243423          	sd	s2,-504(s0)
    80004a0e:	7dba                	ld	s11,424(sp)
    80004a10:	a035                	j	80004a3c <exec+0x336>
    80004a12:	e1243423          	sd	s2,-504(s0)
    80004a16:	7dba                	ld	s11,424(sp)
    80004a18:	a015                	j	80004a3c <exec+0x336>
    80004a1a:	e1243423          	sd	s2,-504(s0)
    80004a1e:	7dba                	ld	s11,424(sp)
    80004a20:	a831                	j	80004a3c <exec+0x336>
    80004a22:	e1243423          	sd	s2,-504(s0)
    80004a26:	7dba                	ld	s11,424(sp)
    80004a28:	a811                	j	80004a3c <exec+0x336>
    80004a2a:	e1243423          	sd	s2,-504(s0)
    80004a2e:	7dba                	ld	s11,424(sp)
    80004a30:	a031                	j	80004a3c <exec+0x336>
  ip = 0;
    80004a32:	4a01                	li	s4,0
    80004a34:	a021                	j	80004a3c <exec+0x336>
    80004a36:	4a01                	li	s4,0
  if(pagetable)
    80004a38:	a011                	j	80004a3c <exec+0x336>
    80004a3a:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004a3c:	e0843583          	ld	a1,-504(s0)
    80004a40:	855a                	mv	a0,s6
    80004a42:	8ecfd0ef          	jal	80001b2e <proc_freepagetable>
  return -1;
    80004a46:	557d                	li	a0,-1
  if(ip){
    80004a48:	000a1b63          	bnez	s4,80004a5e <exec+0x358>
    80004a4c:	79be                	ld	s3,488(sp)
    80004a4e:	7a1e                	ld	s4,480(sp)
    80004a50:	6afe                	ld	s5,472(sp)
    80004a52:	6b5e                	ld	s6,464(sp)
    80004a54:	6bbe                	ld	s7,456(sp)
    80004a56:	6c1e                	ld	s8,448(sp)
    80004a58:	7cfa                	ld	s9,440(sp)
    80004a5a:	7d5a                	ld	s10,432(sp)
    80004a5c:	bb21                	j	80004774 <exec+0x6e>
    80004a5e:	79be                	ld	s3,488(sp)
    80004a60:	6afe                	ld	s5,472(sp)
    80004a62:	6b5e                	ld	s6,464(sp)
    80004a64:	6bbe                	ld	s7,456(sp)
    80004a66:	6c1e                	ld	s8,448(sp)
    80004a68:	7cfa                	ld	s9,440(sp)
    80004a6a:	7d5a                	ld	s10,432(sp)
    80004a6c:	b9ed                	j	80004766 <exec+0x60>
    80004a6e:	6b5e                	ld	s6,464(sp)
    80004a70:	b9dd                	j	80004766 <exec+0x60>
  sz = sz1;
    80004a72:	e0843983          	ld	s3,-504(s0)
    80004a76:	b595                	j	800048da <exec+0x1d4>

0000000080004a78 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004a78:	7179                	addi	sp,sp,-48
    80004a7a:	f406                	sd	ra,40(sp)
    80004a7c:	f022                	sd	s0,32(sp)
    80004a7e:	ec26                	sd	s1,24(sp)
    80004a80:	e84a                	sd	s2,16(sp)
    80004a82:	1800                	addi	s0,sp,48
    80004a84:	892e                	mv	s2,a1
    80004a86:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004a88:	fdc40593          	addi	a1,s0,-36
    80004a8c:	eb9fd0ef          	jal	80002944 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004a90:	fdc42703          	lw	a4,-36(s0)
    80004a94:	47bd                	li	a5,15
    80004a96:	02e7e963          	bltu	a5,a4,80004ac8 <argfd+0x50>
    80004a9a:	e79fc0ef          	jal	80001912 <myproc>
    80004a9e:	fdc42703          	lw	a4,-36(s0)
    80004aa2:	01a70793          	addi	a5,a4,26
    80004aa6:	078e                	slli	a5,a5,0x3
    80004aa8:	953e                	add	a0,a0,a5
    80004aaa:	611c                	ld	a5,0(a0)
    80004aac:	c385                	beqz	a5,80004acc <argfd+0x54>
    return -1;
  if(pfd)
    80004aae:	00090463          	beqz	s2,80004ab6 <argfd+0x3e>
    *pfd = fd;
    80004ab2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004ab6:	4501                	li	a0,0
  if(pf)
    80004ab8:	c091                	beqz	s1,80004abc <argfd+0x44>
    *pf = f;
    80004aba:	e09c                	sd	a5,0(s1)
}
    80004abc:	70a2                	ld	ra,40(sp)
    80004abe:	7402                	ld	s0,32(sp)
    80004ac0:	64e2                	ld	s1,24(sp)
    80004ac2:	6942                	ld	s2,16(sp)
    80004ac4:	6145                	addi	sp,sp,48
    80004ac6:	8082                	ret
    return -1;
    80004ac8:	557d                	li	a0,-1
    80004aca:	bfcd                	j	80004abc <argfd+0x44>
    80004acc:	557d                	li	a0,-1
    80004ace:	b7fd                	j	80004abc <argfd+0x44>

0000000080004ad0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004ad0:	1101                	addi	sp,sp,-32
    80004ad2:	ec06                	sd	ra,24(sp)
    80004ad4:	e822                	sd	s0,16(sp)
    80004ad6:	e426                	sd	s1,8(sp)
    80004ad8:	1000                	addi	s0,sp,32
    80004ada:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004adc:	e37fc0ef          	jal	80001912 <myproc>
    80004ae0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004ae2:	0d050793          	addi	a5,a0,208
    80004ae6:	4501                	li	a0,0
    80004ae8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004aea:	6398                	ld	a4,0(a5)
    80004aec:	cb19                	beqz	a4,80004b02 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004aee:	2505                	addiw	a0,a0,1
    80004af0:	07a1                	addi	a5,a5,8
    80004af2:	fed51ce3          	bne	a0,a3,80004aea <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004af6:	557d                	li	a0,-1
}
    80004af8:	60e2                	ld	ra,24(sp)
    80004afa:	6442                	ld	s0,16(sp)
    80004afc:	64a2                	ld	s1,8(sp)
    80004afe:	6105                	addi	sp,sp,32
    80004b00:	8082                	ret
      p->ofile[fd] = f;
    80004b02:	01a50793          	addi	a5,a0,26
    80004b06:	078e                	slli	a5,a5,0x3
    80004b08:	963e                	add	a2,a2,a5
    80004b0a:	e204                	sd	s1,0(a2)
      return fd;
    80004b0c:	b7f5                	j	80004af8 <fdalloc+0x28>

0000000080004b0e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004b0e:	715d                	addi	sp,sp,-80
    80004b10:	e486                	sd	ra,72(sp)
    80004b12:	e0a2                	sd	s0,64(sp)
    80004b14:	fc26                	sd	s1,56(sp)
    80004b16:	f84a                	sd	s2,48(sp)
    80004b18:	f44e                	sd	s3,40(sp)
    80004b1a:	ec56                	sd	s5,24(sp)
    80004b1c:	e85a                	sd	s6,16(sp)
    80004b1e:	0880                	addi	s0,sp,80
    80004b20:	8b2e                	mv	s6,a1
    80004b22:	89b2                	mv	s3,a2
    80004b24:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004b26:	fb040593          	addi	a1,s0,-80
    80004b2a:	822ff0ef          	jal	80003b4c <nameiparent>
    80004b2e:	84aa                	mv	s1,a0
    80004b30:	10050a63          	beqz	a0,80004c44 <create+0x136>
    return 0;

  ilock(dp);
    80004b34:	925fe0ef          	jal	80003458 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004b38:	4601                	li	a2,0
    80004b3a:	fb040593          	addi	a1,s0,-80
    80004b3e:	8526                	mv	a0,s1
    80004b40:	d8dfe0ef          	jal	800038cc <dirlookup>
    80004b44:	8aaa                	mv	s5,a0
    80004b46:	c129                	beqz	a0,80004b88 <create+0x7a>
    iunlockput(dp);
    80004b48:	8526                	mv	a0,s1
    80004b4a:	b19fe0ef          	jal	80003662 <iunlockput>
    ilock(ip);
    80004b4e:	8556                	mv	a0,s5
    80004b50:	909fe0ef          	jal	80003458 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004b54:	4789                	li	a5,2
    80004b56:	02fb1463          	bne	s6,a5,80004b7e <create+0x70>
    80004b5a:	044ad783          	lhu	a5,68(s5)
    80004b5e:	37f9                	addiw	a5,a5,-2
    80004b60:	17c2                	slli	a5,a5,0x30
    80004b62:	93c1                	srli	a5,a5,0x30
    80004b64:	4705                	li	a4,1
    80004b66:	00f76c63          	bltu	a4,a5,80004b7e <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004b6a:	8556                	mv	a0,s5
    80004b6c:	60a6                	ld	ra,72(sp)
    80004b6e:	6406                	ld	s0,64(sp)
    80004b70:	74e2                	ld	s1,56(sp)
    80004b72:	7942                	ld	s2,48(sp)
    80004b74:	79a2                	ld	s3,40(sp)
    80004b76:	6ae2                	ld	s5,24(sp)
    80004b78:	6b42                	ld	s6,16(sp)
    80004b7a:	6161                	addi	sp,sp,80
    80004b7c:	8082                	ret
    iunlockput(ip);
    80004b7e:	8556                	mv	a0,s5
    80004b80:	ae3fe0ef          	jal	80003662 <iunlockput>
    return 0;
    80004b84:	4a81                	li	s5,0
    80004b86:	b7d5                	j	80004b6a <create+0x5c>
    80004b88:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004b8a:	85da                	mv	a1,s6
    80004b8c:	4088                	lw	a0,0(s1)
    80004b8e:	f5afe0ef          	jal	800032e8 <ialloc>
    80004b92:	8a2a                	mv	s4,a0
    80004b94:	cd15                	beqz	a0,80004bd0 <create+0xc2>
  ilock(ip);
    80004b96:	8c3fe0ef          	jal	80003458 <ilock>
  ip->major = major;
    80004b9a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004b9e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004ba2:	4905                	li	s2,1
    80004ba4:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004ba8:	8552                	mv	a0,s4
    80004baa:	ffafe0ef          	jal	800033a4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004bae:	032b0763          	beq	s6,s2,80004bdc <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004bb2:	004a2603          	lw	a2,4(s4)
    80004bb6:	fb040593          	addi	a1,s0,-80
    80004bba:	8526                	mv	a0,s1
    80004bbc:	eddfe0ef          	jal	80003a98 <dirlink>
    80004bc0:	06054563          	bltz	a0,80004c2a <create+0x11c>
  iunlockput(dp);
    80004bc4:	8526                	mv	a0,s1
    80004bc6:	a9dfe0ef          	jal	80003662 <iunlockput>
  return ip;
    80004bca:	8ad2                	mv	s5,s4
    80004bcc:	7a02                	ld	s4,32(sp)
    80004bce:	bf71                	j	80004b6a <create+0x5c>
    iunlockput(dp);
    80004bd0:	8526                	mv	a0,s1
    80004bd2:	a91fe0ef          	jal	80003662 <iunlockput>
    return 0;
    80004bd6:	8ad2                	mv	s5,s4
    80004bd8:	7a02                	ld	s4,32(sp)
    80004bda:	bf41                	j	80004b6a <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004bdc:	004a2603          	lw	a2,4(s4)
    80004be0:	00003597          	auipc	a1,0x3
    80004be4:	a5058593          	addi	a1,a1,-1456 # 80007630 <etext+0x630>
    80004be8:	8552                	mv	a0,s4
    80004bea:	eaffe0ef          	jal	80003a98 <dirlink>
    80004bee:	02054e63          	bltz	a0,80004c2a <create+0x11c>
    80004bf2:	40d0                	lw	a2,4(s1)
    80004bf4:	00003597          	auipc	a1,0x3
    80004bf8:	a4458593          	addi	a1,a1,-1468 # 80007638 <etext+0x638>
    80004bfc:	8552                	mv	a0,s4
    80004bfe:	e9bfe0ef          	jal	80003a98 <dirlink>
    80004c02:	02054463          	bltz	a0,80004c2a <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004c06:	004a2603          	lw	a2,4(s4)
    80004c0a:	fb040593          	addi	a1,s0,-80
    80004c0e:	8526                	mv	a0,s1
    80004c10:	e89fe0ef          	jal	80003a98 <dirlink>
    80004c14:	00054b63          	bltz	a0,80004c2a <create+0x11c>
    dp->nlink++;  // for ".."
    80004c18:	04a4d783          	lhu	a5,74(s1)
    80004c1c:	2785                	addiw	a5,a5,1
    80004c1e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c22:	8526                	mv	a0,s1
    80004c24:	f80fe0ef          	jal	800033a4 <iupdate>
    80004c28:	bf71                	j	80004bc4 <create+0xb6>
  ip->nlink = 0;
    80004c2a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004c2e:	8552                	mv	a0,s4
    80004c30:	f74fe0ef          	jal	800033a4 <iupdate>
  iunlockput(ip);
    80004c34:	8552                	mv	a0,s4
    80004c36:	a2dfe0ef          	jal	80003662 <iunlockput>
  iunlockput(dp);
    80004c3a:	8526                	mv	a0,s1
    80004c3c:	a27fe0ef          	jal	80003662 <iunlockput>
  return 0;
    80004c40:	7a02                	ld	s4,32(sp)
    80004c42:	b725                	j	80004b6a <create+0x5c>
    return 0;
    80004c44:	8aaa                	mv	s5,a0
    80004c46:	b715                	j	80004b6a <create+0x5c>

0000000080004c48 <sys_dup>:
{
    80004c48:	7179                	addi	sp,sp,-48
    80004c4a:	f406                	sd	ra,40(sp)
    80004c4c:	f022                	sd	s0,32(sp)
    80004c4e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004c50:	fd840613          	addi	a2,s0,-40
    80004c54:	4581                	li	a1,0
    80004c56:	4501                	li	a0,0
    80004c58:	e21ff0ef          	jal	80004a78 <argfd>
    return -1;
    80004c5c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004c5e:	02054363          	bltz	a0,80004c84 <sys_dup+0x3c>
    80004c62:	ec26                	sd	s1,24(sp)
    80004c64:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004c66:	fd843903          	ld	s2,-40(s0)
    80004c6a:	854a                	mv	a0,s2
    80004c6c:	e65ff0ef          	jal	80004ad0 <fdalloc>
    80004c70:	84aa                	mv	s1,a0
    return -1;
    80004c72:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004c74:	00054d63          	bltz	a0,80004c8e <sys_dup+0x46>
  filedup(f);
    80004c78:	854a                	mv	a0,s2
    80004c7a:	c48ff0ef          	jal	800040c2 <filedup>
  return fd;
    80004c7e:	87a6                	mv	a5,s1
    80004c80:	64e2                	ld	s1,24(sp)
    80004c82:	6942                	ld	s2,16(sp)
}
    80004c84:	853e                	mv	a0,a5
    80004c86:	70a2                	ld	ra,40(sp)
    80004c88:	7402                	ld	s0,32(sp)
    80004c8a:	6145                	addi	sp,sp,48
    80004c8c:	8082                	ret
    80004c8e:	64e2                	ld	s1,24(sp)
    80004c90:	6942                	ld	s2,16(sp)
    80004c92:	bfcd                	j	80004c84 <sys_dup+0x3c>

0000000080004c94 <sys_read>:
{
    80004c94:	7179                	addi	sp,sp,-48
    80004c96:	f406                	sd	ra,40(sp)
    80004c98:	f022                	sd	s0,32(sp)
    80004c9a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004c9c:	fd840593          	addi	a1,s0,-40
    80004ca0:	4505                	li	a0,1
    80004ca2:	cbffd0ef          	jal	80002960 <argaddr>
  argint(2, &n);
    80004ca6:	fe440593          	addi	a1,s0,-28
    80004caa:	4509                	li	a0,2
    80004cac:	c99fd0ef          	jal	80002944 <argint>
  if(argfd(0, 0, &f) < 0)
    80004cb0:	fe840613          	addi	a2,s0,-24
    80004cb4:	4581                	li	a1,0
    80004cb6:	4501                	li	a0,0
    80004cb8:	dc1ff0ef          	jal	80004a78 <argfd>
    80004cbc:	87aa                	mv	a5,a0
    return -1;
    80004cbe:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004cc0:	0007ca63          	bltz	a5,80004cd4 <sys_read+0x40>
  return fileread(f, p, n);
    80004cc4:	fe442603          	lw	a2,-28(s0)
    80004cc8:	fd843583          	ld	a1,-40(s0)
    80004ccc:	fe843503          	ld	a0,-24(s0)
    80004cd0:	d58ff0ef          	jal	80004228 <fileread>
}
    80004cd4:	70a2                	ld	ra,40(sp)
    80004cd6:	7402                	ld	s0,32(sp)
    80004cd8:	6145                	addi	sp,sp,48
    80004cda:	8082                	ret

0000000080004cdc <sys_write>:
{
    80004cdc:	7179                	addi	sp,sp,-48
    80004cde:	f406                	sd	ra,40(sp)
    80004ce0:	f022                	sd	s0,32(sp)
    80004ce2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004ce4:	fd840593          	addi	a1,s0,-40
    80004ce8:	4505                	li	a0,1
    80004cea:	c77fd0ef          	jal	80002960 <argaddr>
  argint(2, &n);
    80004cee:	fe440593          	addi	a1,s0,-28
    80004cf2:	4509                	li	a0,2
    80004cf4:	c51fd0ef          	jal	80002944 <argint>
  if(argfd(0, 0, &f) < 0)
    80004cf8:	fe840613          	addi	a2,s0,-24
    80004cfc:	4581                	li	a1,0
    80004cfe:	4501                	li	a0,0
    80004d00:	d79ff0ef          	jal	80004a78 <argfd>
    80004d04:	87aa                	mv	a5,a0
    return -1;
    80004d06:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004d08:	0007ca63          	bltz	a5,80004d1c <sys_write+0x40>
  return filewrite(f, p, n);
    80004d0c:	fe442603          	lw	a2,-28(s0)
    80004d10:	fd843583          	ld	a1,-40(s0)
    80004d14:	fe843503          	ld	a0,-24(s0)
    80004d18:	dceff0ef          	jal	800042e6 <filewrite>
}
    80004d1c:	70a2                	ld	ra,40(sp)
    80004d1e:	7402                	ld	s0,32(sp)
    80004d20:	6145                	addi	sp,sp,48
    80004d22:	8082                	ret

0000000080004d24 <sys_close>:
{
    80004d24:	1101                	addi	sp,sp,-32
    80004d26:	ec06                	sd	ra,24(sp)
    80004d28:	e822                	sd	s0,16(sp)
    80004d2a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004d2c:	fe040613          	addi	a2,s0,-32
    80004d30:	fec40593          	addi	a1,s0,-20
    80004d34:	4501                	li	a0,0
    80004d36:	d43ff0ef          	jal	80004a78 <argfd>
    return -1;
    80004d3a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004d3c:	02054063          	bltz	a0,80004d5c <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004d40:	bd3fc0ef          	jal	80001912 <myproc>
    80004d44:	fec42783          	lw	a5,-20(s0)
    80004d48:	07e9                	addi	a5,a5,26
    80004d4a:	078e                	slli	a5,a5,0x3
    80004d4c:	953e                	add	a0,a0,a5
    80004d4e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004d52:	fe043503          	ld	a0,-32(s0)
    80004d56:	bb2ff0ef          	jal	80004108 <fileclose>
  return 0;
    80004d5a:	4781                	li	a5,0
}
    80004d5c:	853e                	mv	a0,a5
    80004d5e:	60e2                	ld	ra,24(sp)
    80004d60:	6442                	ld	s0,16(sp)
    80004d62:	6105                	addi	sp,sp,32
    80004d64:	8082                	ret

0000000080004d66 <sys_fstat>:
{
    80004d66:	1101                	addi	sp,sp,-32
    80004d68:	ec06                	sd	ra,24(sp)
    80004d6a:	e822                	sd	s0,16(sp)
    80004d6c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004d6e:	fe040593          	addi	a1,s0,-32
    80004d72:	4505                	li	a0,1
    80004d74:	bedfd0ef          	jal	80002960 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004d78:	fe840613          	addi	a2,s0,-24
    80004d7c:	4581                	li	a1,0
    80004d7e:	4501                	li	a0,0
    80004d80:	cf9ff0ef          	jal	80004a78 <argfd>
    80004d84:	87aa                	mv	a5,a0
    return -1;
    80004d86:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004d88:	0007c863          	bltz	a5,80004d98 <sys_fstat+0x32>
  return filestat(f, st);
    80004d8c:	fe043583          	ld	a1,-32(s0)
    80004d90:	fe843503          	ld	a0,-24(s0)
    80004d94:	c36ff0ef          	jal	800041ca <filestat>
}
    80004d98:	60e2                	ld	ra,24(sp)
    80004d9a:	6442                	ld	s0,16(sp)
    80004d9c:	6105                	addi	sp,sp,32
    80004d9e:	8082                	ret

0000000080004da0 <sys_link>:
{
    80004da0:	7169                	addi	sp,sp,-304
    80004da2:	f606                	sd	ra,296(sp)
    80004da4:	f222                	sd	s0,288(sp)
    80004da6:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004da8:	08000613          	li	a2,128
    80004dac:	ed040593          	addi	a1,s0,-304
    80004db0:	4501                	li	a0,0
    80004db2:	bcdfd0ef          	jal	8000297e <argstr>
    return -1;
    80004db6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004db8:	0c054e63          	bltz	a0,80004e94 <sys_link+0xf4>
    80004dbc:	08000613          	li	a2,128
    80004dc0:	f5040593          	addi	a1,s0,-176
    80004dc4:	4505                	li	a0,1
    80004dc6:	bb9fd0ef          	jal	8000297e <argstr>
    return -1;
    80004dca:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004dcc:	0c054463          	bltz	a0,80004e94 <sys_link+0xf4>
    80004dd0:	ee26                	sd	s1,280(sp)
  begin_op();
    80004dd2:	f1dfe0ef          	jal	80003cee <begin_op>
  if((ip = namei(old)) == 0){
    80004dd6:	ed040513          	addi	a0,s0,-304
    80004dda:	d59fe0ef          	jal	80003b32 <namei>
    80004dde:	84aa                	mv	s1,a0
    80004de0:	c53d                	beqz	a0,80004e4e <sys_link+0xae>
  ilock(ip);
    80004de2:	e76fe0ef          	jal	80003458 <ilock>
  if(ip->type == T_DIR){
    80004de6:	04449703          	lh	a4,68(s1)
    80004dea:	4785                	li	a5,1
    80004dec:	06f70663          	beq	a4,a5,80004e58 <sys_link+0xb8>
    80004df0:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004df2:	04a4d783          	lhu	a5,74(s1)
    80004df6:	2785                	addiw	a5,a5,1
    80004df8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004dfc:	8526                	mv	a0,s1
    80004dfe:	da6fe0ef          	jal	800033a4 <iupdate>
  iunlock(ip);
    80004e02:	8526                	mv	a0,s1
    80004e04:	f02fe0ef          	jal	80003506 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004e08:	fd040593          	addi	a1,s0,-48
    80004e0c:	f5040513          	addi	a0,s0,-176
    80004e10:	d3dfe0ef          	jal	80003b4c <nameiparent>
    80004e14:	892a                	mv	s2,a0
    80004e16:	cd21                	beqz	a0,80004e6e <sys_link+0xce>
  ilock(dp);
    80004e18:	e40fe0ef          	jal	80003458 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004e1c:	00092703          	lw	a4,0(s2)
    80004e20:	409c                	lw	a5,0(s1)
    80004e22:	04f71363          	bne	a4,a5,80004e68 <sys_link+0xc8>
    80004e26:	40d0                	lw	a2,4(s1)
    80004e28:	fd040593          	addi	a1,s0,-48
    80004e2c:	854a                	mv	a0,s2
    80004e2e:	c6bfe0ef          	jal	80003a98 <dirlink>
    80004e32:	02054b63          	bltz	a0,80004e68 <sys_link+0xc8>
  iunlockput(dp);
    80004e36:	854a                	mv	a0,s2
    80004e38:	82bfe0ef          	jal	80003662 <iunlockput>
  iput(ip);
    80004e3c:	8526                	mv	a0,s1
    80004e3e:	f9cfe0ef          	jal	800035da <iput>
  end_op();
    80004e42:	f17fe0ef          	jal	80003d58 <end_op>
  return 0;
    80004e46:	4781                	li	a5,0
    80004e48:	64f2                	ld	s1,280(sp)
    80004e4a:	6952                	ld	s2,272(sp)
    80004e4c:	a0a1                	j	80004e94 <sys_link+0xf4>
    end_op();
    80004e4e:	f0bfe0ef          	jal	80003d58 <end_op>
    return -1;
    80004e52:	57fd                	li	a5,-1
    80004e54:	64f2                	ld	s1,280(sp)
    80004e56:	a83d                	j	80004e94 <sys_link+0xf4>
    iunlockput(ip);
    80004e58:	8526                	mv	a0,s1
    80004e5a:	809fe0ef          	jal	80003662 <iunlockput>
    end_op();
    80004e5e:	efbfe0ef          	jal	80003d58 <end_op>
    return -1;
    80004e62:	57fd                	li	a5,-1
    80004e64:	64f2                	ld	s1,280(sp)
    80004e66:	a03d                	j	80004e94 <sys_link+0xf4>
    iunlockput(dp);
    80004e68:	854a                	mv	a0,s2
    80004e6a:	ff8fe0ef          	jal	80003662 <iunlockput>
  ilock(ip);
    80004e6e:	8526                	mv	a0,s1
    80004e70:	de8fe0ef          	jal	80003458 <ilock>
  ip->nlink--;
    80004e74:	04a4d783          	lhu	a5,74(s1)
    80004e78:	37fd                	addiw	a5,a5,-1
    80004e7a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004e7e:	8526                	mv	a0,s1
    80004e80:	d24fe0ef          	jal	800033a4 <iupdate>
  iunlockput(ip);
    80004e84:	8526                	mv	a0,s1
    80004e86:	fdcfe0ef          	jal	80003662 <iunlockput>
  end_op();
    80004e8a:	ecffe0ef          	jal	80003d58 <end_op>
  return -1;
    80004e8e:	57fd                	li	a5,-1
    80004e90:	64f2                	ld	s1,280(sp)
    80004e92:	6952                	ld	s2,272(sp)
}
    80004e94:	853e                	mv	a0,a5
    80004e96:	70b2                	ld	ra,296(sp)
    80004e98:	7412                	ld	s0,288(sp)
    80004e9a:	6155                	addi	sp,sp,304
    80004e9c:	8082                	ret

0000000080004e9e <sys_unlink>:
{
    80004e9e:	7151                	addi	sp,sp,-240
    80004ea0:	f586                	sd	ra,232(sp)
    80004ea2:	f1a2                	sd	s0,224(sp)
    80004ea4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004ea6:	08000613          	li	a2,128
    80004eaa:	f3040593          	addi	a1,s0,-208
    80004eae:	4501                	li	a0,0
    80004eb0:	acffd0ef          	jal	8000297e <argstr>
    80004eb4:	16054063          	bltz	a0,80005014 <sys_unlink+0x176>
    80004eb8:	eda6                	sd	s1,216(sp)
  begin_op();
    80004eba:	e35fe0ef          	jal	80003cee <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ebe:	fb040593          	addi	a1,s0,-80
    80004ec2:	f3040513          	addi	a0,s0,-208
    80004ec6:	c87fe0ef          	jal	80003b4c <nameiparent>
    80004eca:	84aa                	mv	s1,a0
    80004ecc:	c945                	beqz	a0,80004f7c <sys_unlink+0xde>
  ilock(dp);
    80004ece:	d8afe0ef          	jal	80003458 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004ed2:	00002597          	auipc	a1,0x2
    80004ed6:	75e58593          	addi	a1,a1,1886 # 80007630 <etext+0x630>
    80004eda:	fb040513          	addi	a0,s0,-80
    80004ede:	9d9fe0ef          	jal	800038b6 <namecmp>
    80004ee2:	10050e63          	beqz	a0,80004ffe <sys_unlink+0x160>
    80004ee6:	00002597          	auipc	a1,0x2
    80004eea:	75258593          	addi	a1,a1,1874 # 80007638 <etext+0x638>
    80004eee:	fb040513          	addi	a0,s0,-80
    80004ef2:	9c5fe0ef          	jal	800038b6 <namecmp>
    80004ef6:	10050463          	beqz	a0,80004ffe <sys_unlink+0x160>
    80004efa:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004efc:	f2c40613          	addi	a2,s0,-212
    80004f00:	fb040593          	addi	a1,s0,-80
    80004f04:	8526                	mv	a0,s1
    80004f06:	9c7fe0ef          	jal	800038cc <dirlookup>
    80004f0a:	892a                	mv	s2,a0
    80004f0c:	0e050863          	beqz	a0,80004ffc <sys_unlink+0x15e>
  ilock(ip);
    80004f10:	d48fe0ef          	jal	80003458 <ilock>
  if(ip->nlink < 1)
    80004f14:	04a91783          	lh	a5,74(s2)
    80004f18:	06f05763          	blez	a5,80004f86 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004f1c:	04491703          	lh	a4,68(s2)
    80004f20:	4785                	li	a5,1
    80004f22:	06f70963          	beq	a4,a5,80004f94 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004f26:	4641                	li	a2,16
    80004f28:	4581                	li	a1,0
    80004f2a:	fc040513          	addi	a0,s0,-64
    80004f2e:	da9fb0ef          	jal	80000cd6 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004f32:	4741                	li	a4,16
    80004f34:	f2c42683          	lw	a3,-212(s0)
    80004f38:	fc040613          	addi	a2,s0,-64
    80004f3c:	4581                	li	a1,0
    80004f3e:	8526                	mv	a0,s1
    80004f40:	869fe0ef          	jal	800037a8 <writei>
    80004f44:	47c1                	li	a5,16
    80004f46:	08f51b63          	bne	a0,a5,80004fdc <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004f4a:	04491703          	lh	a4,68(s2)
    80004f4e:	4785                	li	a5,1
    80004f50:	08f70d63          	beq	a4,a5,80004fea <sys_unlink+0x14c>
  iunlockput(dp);
    80004f54:	8526                	mv	a0,s1
    80004f56:	f0cfe0ef          	jal	80003662 <iunlockput>
  ip->nlink--;
    80004f5a:	04a95783          	lhu	a5,74(s2)
    80004f5e:	37fd                	addiw	a5,a5,-1
    80004f60:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004f64:	854a                	mv	a0,s2
    80004f66:	c3efe0ef          	jal	800033a4 <iupdate>
  iunlockput(ip);
    80004f6a:	854a                	mv	a0,s2
    80004f6c:	ef6fe0ef          	jal	80003662 <iunlockput>
  end_op();
    80004f70:	de9fe0ef          	jal	80003d58 <end_op>
  return 0;
    80004f74:	4501                	li	a0,0
    80004f76:	64ee                	ld	s1,216(sp)
    80004f78:	694e                	ld	s2,208(sp)
    80004f7a:	a849                	j	8000500c <sys_unlink+0x16e>
    end_op();
    80004f7c:	dddfe0ef          	jal	80003d58 <end_op>
    return -1;
    80004f80:	557d                	li	a0,-1
    80004f82:	64ee                	ld	s1,216(sp)
    80004f84:	a061                	j	8000500c <sys_unlink+0x16e>
    80004f86:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004f88:	00002517          	auipc	a0,0x2
    80004f8c:	6b850513          	addi	a0,a0,1720 # 80007640 <etext+0x640>
    80004f90:	813fb0ef          	jal	800007a2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004f94:	04c92703          	lw	a4,76(s2)
    80004f98:	02000793          	li	a5,32
    80004f9c:	f8e7f5e3          	bgeu	a5,a4,80004f26 <sys_unlink+0x88>
    80004fa0:	e5ce                	sd	s3,200(sp)
    80004fa2:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004fa6:	4741                	li	a4,16
    80004fa8:	86ce                	mv	a3,s3
    80004faa:	f1840613          	addi	a2,s0,-232
    80004fae:	4581                	li	a1,0
    80004fb0:	854a                	mv	a0,s2
    80004fb2:	efafe0ef          	jal	800036ac <readi>
    80004fb6:	47c1                	li	a5,16
    80004fb8:	00f51c63          	bne	a0,a5,80004fd0 <sys_unlink+0x132>
    if(de.inum != 0)
    80004fbc:	f1845783          	lhu	a5,-232(s0)
    80004fc0:	efa1                	bnez	a5,80005018 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004fc2:	29c1                	addiw	s3,s3,16
    80004fc4:	04c92783          	lw	a5,76(s2)
    80004fc8:	fcf9efe3          	bltu	s3,a5,80004fa6 <sys_unlink+0x108>
    80004fcc:	69ae                	ld	s3,200(sp)
    80004fce:	bfa1                	j	80004f26 <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004fd0:	00002517          	auipc	a0,0x2
    80004fd4:	68850513          	addi	a0,a0,1672 # 80007658 <etext+0x658>
    80004fd8:	fcafb0ef          	jal	800007a2 <panic>
    80004fdc:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004fde:	00002517          	auipc	a0,0x2
    80004fe2:	69250513          	addi	a0,a0,1682 # 80007670 <etext+0x670>
    80004fe6:	fbcfb0ef          	jal	800007a2 <panic>
    dp->nlink--;
    80004fea:	04a4d783          	lhu	a5,74(s1)
    80004fee:	37fd                	addiw	a5,a5,-1
    80004ff0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ff4:	8526                	mv	a0,s1
    80004ff6:	baefe0ef          	jal	800033a4 <iupdate>
    80004ffa:	bfa9                	j	80004f54 <sys_unlink+0xb6>
    80004ffc:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004ffe:	8526                	mv	a0,s1
    80005000:	e62fe0ef          	jal	80003662 <iunlockput>
  end_op();
    80005004:	d55fe0ef          	jal	80003d58 <end_op>
  return -1;
    80005008:	557d                	li	a0,-1
    8000500a:	64ee                	ld	s1,216(sp)
}
    8000500c:	70ae                	ld	ra,232(sp)
    8000500e:	740e                	ld	s0,224(sp)
    80005010:	616d                	addi	sp,sp,240
    80005012:	8082                	ret
    return -1;
    80005014:	557d                	li	a0,-1
    80005016:	bfdd                	j	8000500c <sys_unlink+0x16e>
    iunlockput(ip);
    80005018:	854a                	mv	a0,s2
    8000501a:	e48fe0ef          	jal	80003662 <iunlockput>
    goto bad;
    8000501e:	694e                	ld	s2,208(sp)
    80005020:	69ae                	ld	s3,200(sp)
    80005022:	bff1                	j	80004ffe <sys_unlink+0x160>

0000000080005024 <sys_open>:

uint64
sys_open(void)
{
    80005024:	7131                	addi	sp,sp,-192
    80005026:	fd06                	sd	ra,184(sp)
    80005028:	f922                	sd	s0,176(sp)
    8000502a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000502c:	f4c40593          	addi	a1,s0,-180
    80005030:	4505                	li	a0,1
    80005032:	913fd0ef          	jal	80002944 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005036:	08000613          	li	a2,128
    8000503a:	f5040593          	addi	a1,s0,-176
    8000503e:	4501                	li	a0,0
    80005040:	93ffd0ef          	jal	8000297e <argstr>
    80005044:	87aa                	mv	a5,a0
    return -1;
    80005046:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005048:	0a07c263          	bltz	a5,800050ec <sys_open+0xc8>
    8000504c:	f526                	sd	s1,168(sp)

  begin_op();
    8000504e:	ca1fe0ef          	jal	80003cee <begin_op>

  if(omode & O_CREATE){
    80005052:	f4c42783          	lw	a5,-180(s0)
    80005056:	2007f793          	andi	a5,a5,512
    8000505a:	c3d5                	beqz	a5,800050fe <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    8000505c:	4681                	li	a3,0
    8000505e:	4601                	li	a2,0
    80005060:	4589                	li	a1,2
    80005062:	f5040513          	addi	a0,s0,-176
    80005066:	aa9ff0ef          	jal	80004b0e <create>
    8000506a:	84aa                	mv	s1,a0
    if(ip == 0){
    8000506c:	c541                	beqz	a0,800050f4 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000506e:	04449703          	lh	a4,68(s1)
    80005072:	478d                	li	a5,3
    80005074:	00f71763          	bne	a4,a5,80005082 <sys_open+0x5e>
    80005078:	0464d703          	lhu	a4,70(s1)
    8000507c:	47a5                	li	a5,9
    8000507e:	0ae7ed63          	bltu	a5,a4,80005138 <sys_open+0x114>
    80005082:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005084:	fe1fe0ef          	jal	80004064 <filealloc>
    80005088:	892a                	mv	s2,a0
    8000508a:	c179                	beqz	a0,80005150 <sys_open+0x12c>
    8000508c:	ed4e                	sd	s3,152(sp)
    8000508e:	a43ff0ef          	jal	80004ad0 <fdalloc>
    80005092:	89aa                	mv	s3,a0
    80005094:	0a054a63          	bltz	a0,80005148 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005098:	04449703          	lh	a4,68(s1)
    8000509c:	478d                	li	a5,3
    8000509e:	0cf70263          	beq	a4,a5,80005162 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800050a2:	4789                	li	a5,2
    800050a4:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800050a8:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800050ac:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800050b0:	f4c42783          	lw	a5,-180(s0)
    800050b4:	0017c713          	xori	a4,a5,1
    800050b8:	8b05                	andi	a4,a4,1
    800050ba:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800050be:	0037f713          	andi	a4,a5,3
    800050c2:	00e03733          	snez	a4,a4
    800050c6:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800050ca:	4007f793          	andi	a5,a5,1024
    800050ce:	c791                	beqz	a5,800050da <sys_open+0xb6>
    800050d0:	04449703          	lh	a4,68(s1)
    800050d4:	4789                	li	a5,2
    800050d6:	08f70d63          	beq	a4,a5,80005170 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800050da:	8526                	mv	a0,s1
    800050dc:	c2afe0ef          	jal	80003506 <iunlock>
  end_op();
    800050e0:	c79fe0ef          	jal	80003d58 <end_op>

  return fd;
    800050e4:	854e                	mv	a0,s3
    800050e6:	74aa                	ld	s1,168(sp)
    800050e8:	790a                	ld	s2,160(sp)
    800050ea:	69ea                	ld	s3,152(sp)
}
    800050ec:	70ea                	ld	ra,184(sp)
    800050ee:	744a                	ld	s0,176(sp)
    800050f0:	6129                	addi	sp,sp,192
    800050f2:	8082                	ret
      end_op();
    800050f4:	c65fe0ef          	jal	80003d58 <end_op>
      return -1;
    800050f8:	557d                	li	a0,-1
    800050fa:	74aa                	ld	s1,168(sp)
    800050fc:	bfc5                	j	800050ec <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800050fe:	f5040513          	addi	a0,s0,-176
    80005102:	a31fe0ef          	jal	80003b32 <namei>
    80005106:	84aa                	mv	s1,a0
    80005108:	c11d                	beqz	a0,8000512e <sys_open+0x10a>
    ilock(ip);
    8000510a:	b4efe0ef          	jal	80003458 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000510e:	04449703          	lh	a4,68(s1)
    80005112:	4785                	li	a5,1
    80005114:	f4f71de3          	bne	a4,a5,8000506e <sys_open+0x4a>
    80005118:	f4c42783          	lw	a5,-180(s0)
    8000511c:	d3bd                	beqz	a5,80005082 <sys_open+0x5e>
      iunlockput(ip);
    8000511e:	8526                	mv	a0,s1
    80005120:	d42fe0ef          	jal	80003662 <iunlockput>
      end_op();
    80005124:	c35fe0ef          	jal	80003d58 <end_op>
      return -1;
    80005128:	557d                	li	a0,-1
    8000512a:	74aa                	ld	s1,168(sp)
    8000512c:	b7c1                	j	800050ec <sys_open+0xc8>
      end_op();
    8000512e:	c2bfe0ef          	jal	80003d58 <end_op>
      return -1;
    80005132:	557d                	li	a0,-1
    80005134:	74aa                	ld	s1,168(sp)
    80005136:	bf5d                	j	800050ec <sys_open+0xc8>
    iunlockput(ip);
    80005138:	8526                	mv	a0,s1
    8000513a:	d28fe0ef          	jal	80003662 <iunlockput>
    end_op();
    8000513e:	c1bfe0ef          	jal	80003d58 <end_op>
    return -1;
    80005142:	557d                	li	a0,-1
    80005144:	74aa                	ld	s1,168(sp)
    80005146:	b75d                	j	800050ec <sys_open+0xc8>
      fileclose(f);
    80005148:	854a                	mv	a0,s2
    8000514a:	fbffe0ef          	jal	80004108 <fileclose>
    8000514e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005150:	8526                	mv	a0,s1
    80005152:	d10fe0ef          	jal	80003662 <iunlockput>
    end_op();
    80005156:	c03fe0ef          	jal	80003d58 <end_op>
    return -1;
    8000515a:	557d                	li	a0,-1
    8000515c:	74aa                	ld	s1,168(sp)
    8000515e:	790a                	ld	s2,160(sp)
    80005160:	b771                	j	800050ec <sys_open+0xc8>
    f->type = FD_DEVICE;
    80005162:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005166:	04649783          	lh	a5,70(s1)
    8000516a:	02f91223          	sh	a5,36(s2)
    8000516e:	bf3d                	j	800050ac <sys_open+0x88>
    itrunc(ip);
    80005170:	8526                	mv	a0,s1
    80005172:	bd4fe0ef          	jal	80003546 <itrunc>
    80005176:	b795                	j	800050da <sys_open+0xb6>

0000000080005178 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005178:	7175                	addi	sp,sp,-144
    8000517a:	e506                	sd	ra,136(sp)
    8000517c:	e122                	sd	s0,128(sp)
    8000517e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005180:	b6ffe0ef          	jal	80003cee <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005184:	08000613          	li	a2,128
    80005188:	f7040593          	addi	a1,s0,-144
    8000518c:	4501                	li	a0,0
    8000518e:	ff0fd0ef          	jal	8000297e <argstr>
    80005192:	02054363          	bltz	a0,800051b8 <sys_mkdir+0x40>
    80005196:	4681                	li	a3,0
    80005198:	4601                	li	a2,0
    8000519a:	4585                	li	a1,1
    8000519c:	f7040513          	addi	a0,s0,-144
    800051a0:	96fff0ef          	jal	80004b0e <create>
    800051a4:	c911                	beqz	a0,800051b8 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800051a6:	cbcfe0ef          	jal	80003662 <iunlockput>
  end_op();
    800051aa:	baffe0ef          	jal	80003d58 <end_op>
  return 0;
    800051ae:	4501                	li	a0,0
}
    800051b0:	60aa                	ld	ra,136(sp)
    800051b2:	640a                	ld	s0,128(sp)
    800051b4:	6149                	addi	sp,sp,144
    800051b6:	8082                	ret
    end_op();
    800051b8:	ba1fe0ef          	jal	80003d58 <end_op>
    return -1;
    800051bc:	557d                	li	a0,-1
    800051be:	bfcd                	j	800051b0 <sys_mkdir+0x38>

00000000800051c0 <sys_mknod>:

uint64
sys_mknod(void)
{
    800051c0:	7135                	addi	sp,sp,-160
    800051c2:	ed06                	sd	ra,152(sp)
    800051c4:	e922                	sd	s0,144(sp)
    800051c6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800051c8:	b27fe0ef          	jal	80003cee <begin_op>
  argint(1, &major);
    800051cc:	f6c40593          	addi	a1,s0,-148
    800051d0:	4505                	li	a0,1
    800051d2:	f72fd0ef          	jal	80002944 <argint>
  argint(2, &minor);
    800051d6:	f6840593          	addi	a1,s0,-152
    800051da:	4509                	li	a0,2
    800051dc:	f68fd0ef          	jal	80002944 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800051e0:	08000613          	li	a2,128
    800051e4:	f7040593          	addi	a1,s0,-144
    800051e8:	4501                	li	a0,0
    800051ea:	f94fd0ef          	jal	8000297e <argstr>
    800051ee:	02054563          	bltz	a0,80005218 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800051f2:	f6841683          	lh	a3,-152(s0)
    800051f6:	f6c41603          	lh	a2,-148(s0)
    800051fa:	458d                	li	a1,3
    800051fc:	f7040513          	addi	a0,s0,-144
    80005200:	90fff0ef          	jal	80004b0e <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005204:	c911                	beqz	a0,80005218 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005206:	c5cfe0ef          	jal	80003662 <iunlockput>
  end_op();
    8000520a:	b4ffe0ef          	jal	80003d58 <end_op>
  return 0;
    8000520e:	4501                	li	a0,0
}
    80005210:	60ea                	ld	ra,152(sp)
    80005212:	644a                	ld	s0,144(sp)
    80005214:	610d                	addi	sp,sp,160
    80005216:	8082                	ret
    end_op();
    80005218:	b41fe0ef          	jal	80003d58 <end_op>
    return -1;
    8000521c:	557d                	li	a0,-1
    8000521e:	bfcd                	j	80005210 <sys_mknod+0x50>

0000000080005220 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005220:	7135                	addi	sp,sp,-160
    80005222:	ed06                	sd	ra,152(sp)
    80005224:	e922                	sd	s0,144(sp)
    80005226:	e14a                	sd	s2,128(sp)
    80005228:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000522a:	ee8fc0ef          	jal	80001912 <myproc>
    8000522e:	892a                	mv	s2,a0
  
  begin_op();
    80005230:	abffe0ef          	jal	80003cee <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005234:	08000613          	li	a2,128
    80005238:	f6040593          	addi	a1,s0,-160
    8000523c:	4501                	li	a0,0
    8000523e:	f40fd0ef          	jal	8000297e <argstr>
    80005242:	04054363          	bltz	a0,80005288 <sys_chdir+0x68>
    80005246:	e526                	sd	s1,136(sp)
    80005248:	f6040513          	addi	a0,s0,-160
    8000524c:	8e7fe0ef          	jal	80003b32 <namei>
    80005250:	84aa                	mv	s1,a0
    80005252:	c915                	beqz	a0,80005286 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005254:	a04fe0ef          	jal	80003458 <ilock>
  if(ip->type != T_DIR){
    80005258:	04449703          	lh	a4,68(s1)
    8000525c:	4785                	li	a5,1
    8000525e:	02f71963          	bne	a4,a5,80005290 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005262:	8526                	mv	a0,s1
    80005264:	aa2fe0ef          	jal	80003506 <iunlock>
  iput(p->cwd);
    80005268:	15093503          	ld	a0,336(s2)
    8000526c:	b6efe0ef          	jal	800035da <iput>
  end_op();
    80005270:	ae9fe0ef          	jal	80003d58 <end_op>
  p->cwd = ip;
    80005274:	14993823          	sd	s1,336(s2)
  return 0;
    80005278:	4501                	li	a0,0
    8000527a:	64aa                	ld	s1,136(sp)
}
    8000527c:	60ea                	ld	ra,152(sp)
    8000527e:	644a                	ld	s0,144(sp)
    80005280:	690a                	ld	s2,128(sp)
    80005282:	610d                	addi	sp,sp,160
    80005284:	8082                	ret
    80005286:	64aa                	ld	s1,136(sp)
    end_op();
    80005288:	ad1fe0ef          	jal	80003d58 <end_op>
    return -1;
    8000528c:	557d                	li	a0,-1
    8000528e:	b7fd                	j	8000527c <sys_chdir+0x5c>
    iunlockput(ip);
    80005290:	8526                	mv	a0,s1
    80005292:	bd0fe0ef          	jal	80003662 <iunlockput>
    end_op();
    80005296:	ac3fe0ef          	jal	80003d58 <end_op>
    return -1;
    8000529a:	557d                	li	a0,-1
    8000529c:	64aa                	ld	s1,136(sp)
    8000529e:	bff9                	j	8000527c <sys_chdir+0x5c>

00000000800052a0 <sys_exec>:

uint64
sys_exec(void)
{
    800052a0:	7121                	addi	sp,sp,-448
    800052a2:	ff06                	sd	ra,440(sp)
    800052a4:	fb22                	sd	s0,432(sp)
    800052a6:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800052a8:	e4840593          	addi	a1,s0,-440
    800052ac:	4505                	li	a0,1
    800052ae:	eb2fd0ef          	jal	80002960 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800052b2:	08000613          	li	a2,128
    800052b6:	f5040593          	addi	a1,s0,-176
    800052ba:	4501                	li	a0,0
    800052bc:	ec2fd0ef          	jal	8000297e <argstr>
    800052c0:	87aa                	mv	a5,a0
    return -1;
    800052c2:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800052c4:	0c07c463          	bltz	a5,8000538c <sys_exec+0xec>
    800052c8:	f726                	sd	s1,424(sp)
    800052ca:	f34a                	sd	s2,416(sp)
    800052cc:	ef4e                	sd	s3,408(sp)
    800052ce:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800052d0:	10000613          	li	a2,256
    800052d4:	4581                	li	a1,0
    800052d6:	e5040513          	addi	a0,s0,-432
    800052da:	9fdfb0ef          	jal	80000cd6 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800052de:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800052e2:	89a6                	mv	s3,s1
    800052e4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800052e6:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800052ea:	00391513          	slli	a0,s2,0x3
    800052ee:	e4040593          	addi	a1,s0,-448
    800052f2:	e4843783          	ld	a5,-440(s0)
    800052f6:	953e                	add	a0,a0,a5
    800052f8:	dc2fd0ef          	jal	800028ba <fetchaddr>
    800052fc:	02054663          	bltz	a0,80005328 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80005300:	e4043783          	ld	a5,-448(s0)
    80005304:	c3a9                	beqz	a5,80005346 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005306:	82dfb0ef          	jal	80000b32 <kalloc>
    8000530a:	85aa                	mv	a1,a0
    8000530c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005310:	cd01                	beqz	a0,80005328 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005312:	6605                	lui	a2,0x1
    80005314:	e4043503          	ld	a0,-448(s0)
    80005318:	decfd0ef          	jal	80002904 <fetchstr>
    8000531c:	00054663          	bltz	a0,80005328 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80005320:	0905                	addi	s2,s2,1
    80005322:	09a1                	addi	s3,s3,8
    80005324:	fd4913e3          	bne	s2,s4,800052ea <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005328:	f5040913          	addi	s2,s0,-176
    8000532c:	6088                	ld	a0,0(s1)
    8000532e:	c931                	beqz	a0,80005382 <sys_exec+0xe2>
    kfree(argv[i]);
    80005330:	f20fb0ef          	jal	80000a50 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005334:	04a1                	addi	s1,s1,8
    80005336:	ff249be3          	bne	s1,s2,8000532c <sys_exec+0x8c>
  return -1;
    8000533a:	557d                	li	a0,-1
    8000533c:	74ba                	ld	s1,424(sp)
    8000533e:	791a                	ld	s2,416(sp)
    80005340:	69fa                	ld	s3,408(sp)
    80005342:	6a5a                	ld	s4,400(sp)
    80005344:	a0a1                	j	8000538c <sys_exec+0xec>
      argv[i] = 0;
    80005346:	0009079b          	sext.w	a5,s2
    8000534a:	078e                	slli	a5,a5,0x3
    8000534c:	fd078793          	addi	a5,a5,-48
    80005350:	97a2                	add	a5,a5,s0
    80005352:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005356:	e5040593          	addi	a1,s0,-432
    8000535a:	f5040513          	addi	a0,s0,-176
    8000535e:	ba8ff0ef          	jal	80004706 <exec>
    80005362:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005364:	f5040993          	addi	s3,s0,-176
    80005368:	6088                	ld	a0,0(s1)
    8000536a:	c511                	beqz	a0,80005376 <sys_exec+0xd6>
    kfree(argv[i]);
    8000536c:	ee4fb0ef          	jal	80000a50 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005370:	04a1                	addi	s1,s1,8
    80005372:	ff349be3          	bne	s1,s3,80005368 <sys_exec+0xc8>
  return ret;
    80005376:	854a                	mv	a0,s2
    80005378:	74ba                	ld	s1,424(sp)
    8000537a:	791a                	ld	s2,416(sp)
    8000537c:	69fa                	ld	s3,408(sp)
    8000537e:	6a5a                	ld	s4,400(sp)
    80005380:	a031                	j	8000538c <sys_exec+0xec>
  return -1;
    80005382:	557d                	li	a0,-1
    80005384:	74ba                	ld	s1,424(sp)
    80005386:	791a                	ld	s2,416(sp)
    80005388:	69fa                	ld	s3,408(sp)
    8000538a:	6a5a                	ld	s4,400(sp)
}
    8000538c:	70fa                	ld	ra,440(sp)
    8000538e:	745a                	ld	s0,432(sp)
    80005390:	6139                	addi	sp,sp,448
    80005392:	8082                	ret

0000000080005394 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005394:	7139                	addi	sp,sp,-64
    80005396:	fc06                	sd	ra,56(sp)
    80005398:	f822                	sd	s0,48(sp)
    8000539a:	f426                	sd	s1,40(sp)
    8000539c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000539e:	d74fc0ef          	jal	80001912 <myproc>
    800053a2:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800053a4:	fd840593          	addi	a1,s0,-40
    800053a8:	4501                	li	a0,0
    800053aa:	db6fd0ef          	jal	80002960 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800053ae:	fc840593          	addi	a1,s0,-56
    800053b2:	fd040513          	addi	a0,s0,-48
    800053b6:	85cff0ef          	jal	80004412 <pipealloc>
    return -1;
    800053ba:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800053bc:	0a054463          	bltz	a0,80005464 <sys_pipe+0xd0>
  fd0 = -1;
    800053c0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800053c4:	fd043503          	ld	a0,-48(s0)
    800053c8:	f08ff0ef          	jal	80004ad0 <fdalloc>
    800053cc:	fca42223          	sw	a0,-60(s0)
    800053d0:	08054163          	bltz	a0,80005452 <sys_pipe+0xbe>
    800053d4:	fc843503          	ld	a0,-56(s0)
    800053d8:	ef8ff0ef          	jal	80004ad0 <fdalloc>
    800053dc:	fca42023          	sw	a0,-64(s0)
    800053e0:	06054063          	bltz	a0,80005440 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800053e4:	4691                	li	a3,4
    800053e6:	fc440613          	addi	a2,s0,-60
    800053ea:	fd843583          	ld	a1,-40(s0)
    800053ee:	68a8                	ld	a0,80(s1)
    800053f0:	994fc0ef          	jal	80001584 <copyout>
    800053f4:	00054e63          	bltz	a0,80005410 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800053f8:	4691                	li	a3,4
    800053fa:	fc040613          	addi	a2,s0,-64
    800053fe:	fd843583          	ld	a1,-40(s0)
    80005402:	0591                	addi	a1,a1,4
    80005404:	68a8                	ld	a0,80(s1)
    80005406:	97efc0ef          	jal	80001584 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000540a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000540c:	04055c63          	bgez	a0,80005464 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005410:	fc442783          	lw	a5,-60(s0)
    80005414:	07e9                	addi	a5,a5,26
    80005416:	078e                	slli	a5,a5,0x3
    80005418:	97a6                	add	a5,a5,s1
    8000541a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000541e:	fc042783          	lw	a5,-64(s0)
    80005422:	07e9                	addi	a5,a5,26
    80005424:	078e                	slli	a5,a5,0x3
    80005426:	94be                	add	s1,s1,a5
    80005428:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000542c:	fd043503          	ld	a0,-48(s0)
    80005430:	cd9fe0ef          	jal	80004108 <fileclose>
    fileclose(wf);
    80005434:	fc843503          	ld	a0,-56(s0)
    80005438:	cd1fe0ef          	jal	80004108 <fileclose>
    return -1;
    8000543c:	57fd                	li	a5,-1
    8000543e:	a01d                	j	80005464 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005440:	fc442783          	lw	a5,-60(s0)
    80005444:	0007c763          	bltz	a5,80005452 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005448:	07e9                	addi	a5,a5,26
    8000544a:	078e                	slli	a5,a5,0x3
    8000544c:	97a6                	add	a5,a5,s1
    8000544e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005452:	fd043503          	ld	a0,-48(s0)
    80005456:	cb3fe0ef          	jal	80004108 <fileclose>
    fileclose(wf);
    8000545a:	fc843503          	ld	a0,-56(s0)
    8000545e:	cabfe0ef          	jal	80004108 <fileclose>
    return -1;
    80005462:	57fd                	li	a5,-1
}
    80005464:	853e                	mv	a0,a5
    80005466:	70e2                	ld	ra,56(sp)
    80005468:	7442                	ld	s0,48(sp)
    8000546a:	74a2                	ld	s1,40(sp)
    8000546c:	6121                	addi	sp,sp,64
    8000546e:	8082                	ret

0000000080005470 <kernelvec>:
    80005470:	7111                	addi	sp,sp,-256
    80005472:	e006                	sd	ra,0(sp)
    80005474:	e40a                	sd	sp,8(sp)
    80005476:	e80e                	sd	gp,16(sp)
    80005478:	ec12                	sd	tp,24(sp)
    8000547a:	f016                	sd	t0,32(sp)
    8000547c:	f41a                	sd	t1,40(sp)
    8000547e:	f81e                	sd	t2,48(sp)
    80005480:	e4aa                	sd	a0,72(sp)
    80005482:	e8ae                	sd	a1,80(sp)
    80005484:	ecb2                	sd	a2,88(sp)
    80005486:	f0b6                	sd	a3,96(sp)
    80005488:	f4ba                	sd	a4,104(sp)
    8000548a:	f8be                	sd	a5,112(sp)
    8000548c:	fcc2                	sd	a6,120(sp)
    8000548e:	e146                	sd	a7,128(sp)
    80005490:	edf2                	sd	t3,216(sp)
    80005492:	f1f6                	sd	t4,224(sp)
    80005494:	f5fa                	sd	t5,232(sp)
    80005496:	f9fe                	sd	t6,240(sp)
    80005498:	b32fd0ef          	jal	800027ca <kerneltrap>
    8000549c:	6082                	ld	ra,0(sp)
    8000549e:	6122                	ld	sp,8(sp)
    800054a0:	61c2                	ld	gp,16(sp)
    800054a2:	7282                	ld	t0,32(sp)
    800054a4:	7322                	ld	t1,40(sp)
    800054a6:	73c2                	ld	t2,48(sp)
    800054a8:	6526                	ld	a0,72(sp)
    800054aa:	65c6                	ld	a1,80(sp)
    800054ac:	6666                	ld	a2,88(sp)
    800054ae:	7686                	ld	a3,96(sp)
    800054b0:	7726                	ld	a4,104(sp)
    800054b2:	77c6                	ld	a5,112(sp)
    800054b4:	7866                	ld	a6,120(sp)
    800054b6:	688a                	ld	a7,128(sp)
    800054b8:	6e6e                	ld	t3,216(sp)
    800054ba:	7e8e                	ld	t4,224(sp)
    800054bc:	7f2e                	ld	t5,232(sp)
    800054be:	7fce                	ld	t6,240(sp)
    800054c0:	6111                	addi	sp,sp,256
    800054c2:	10200073          	sret
	...

00000000800054ce <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800054ce:	1141                	addi	sp,sp,-16
    800054d0:	e422                	sd	s0,8(sp)
    800054d2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800054d4:	0c0007b7          	lui	a5,0xc000
    800054d8:	4705                	li	a4,1
    800054da:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800054dc:	0c0007b7          	lui	a5,0xc000
    800054e0:	c3d8                	sw	a4,4(a5)
}
    800054e2:	6422                	ld	s0,8(sp)
    800054e4:	0141                	addi	sp,sp,16
    800054e6:	8082                	ret

00000000800054e8 <plicinithart>:

void
plicinithart(void)
{
    800054e8:	1141                	addi	sp,sp,-16
    800054ea:	e406                	sd	ra,8(sp)
    800054ec:	e022                	sd	s0,0(sp)
    800054ee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054f0:	bf6fc0ef          	jal	800018e6 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800054f4:	0085171b          	slliw	a4,a0,0x8
    800054f8:	0c0027b7          	lui	a5,0xc002
    800054fc:	97ba                	add	a5,a5,a4
    800054fe:	40200713          	li	a4,1026
    80005502:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005506:	00d5151b          	slliw	a0,a0,0xd
    8000550a:	0c2017b7          	lui	a5,0xc201
    8000550e:	97aa                	add	a5,a5,a0
    80005510:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005514:	60a2                	ld	ra,8(sp)
    80005516:	6402                	ld	s0,0(sp)
    80005518:	0141                	addi	sp,sp,16
    8000551a:	8082                	ret

000000008000551c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000551c:	1141                	addi	sp,sp,-16
    8000551e:	e406                	sd	ra,8(sp)
    80005520:	e022                	sd	s0,0(sp)
    80005522:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005524:	bc2fc0ef          	jal	800018e6 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005528:	00d5151b          	slliw	a0,a0,0xd
    8000552c:	0c2017b7          	lui	a5,0xc201
    80005530:	97aa                	add	a5,a5,a0
  return irq;
}
    80005532:	43c8                	lw	a0,4(a5)
    80005534:	60a2                	ld	ra,8(sp)
    80005536:	6402                	ld	s0,0(sp)
    80005538:	0141                	addi	sp,sp,16
    8000553a:	8082                	ret

000000008000553c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000553c:	1101                	addi	sp,sp,-32
    8000553e:	ec06                	sd	ra,24(sp)
    80005540:	e822                	sd	s0,16(sp)
    80005542:	e426                	sd	s1,8(sp)
    80005544:	1000                	addi	s0,sp,32
    80005546:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005548:	b9efc0ef          	jal	800018e6 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000554c:	00d5151b          	slliw	a0,a0,0xd
    80005550:	0c2017b7          	lui	a5,0xc201
    80005554:	97aa                	add	a5,a5,a0
    80005556:	c3c4                	sw	s1,4(a5)
}
    80005558:	60e2                	ld	ra,24(sp)
    8000555a:	6442                	ld	s0,16(sp)
    8000555c:	64a2                	ld	s1,8(sp)
    8000555e:	6105                	addi	sp,sp,32
    80005560:	8082                	ret

0000000080005562 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005562:	1141                	addi	sp,sp,-16
    80005564:	e406                	sd	ra,8(sp)
    80005566:	e022                	sd	s0,0(sp)
    80005568:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000556a:	479d                	li	a5,7
    8000556c:	04a7ca63          	blt	a5,a0,800055c0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005570:	0001e797          	auipc	a5,0x1e
    80005574:	2f078793          	addi	a5,a5,752 # 80023860 <disk>
    80005578:	97aa                	add	a5,a5,a0
    8000557a:	0187c783          	lbu	a5,24(a5)
    8000557e:	e7b9                	bnez	a5,800055cc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005580:	00451693          	slli	a3,a0,0x4
    80005584:	0001e797          	auipc	a5,0x1e
    80005588:	2dc78793          	addi	a5,a5,732 # 80023860 <disk>
    8000558c:	6398                	ld	a4,0(a5)
    8000558e:	9736                	add	a4,a4,a3
    80005590:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005594:	6398                	ld	a4,0(a5)
    80005596:	9736                	add	a4,a4,a3
    80005598:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000559c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800055a0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800055a4:	97aa                	add	a5,a5,a0
    800055a6:	4705                	li	a4,1
    800055a8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800055ac:	0001e517          	auipc	a0,0x1e
    800055b0:	2cc50513          	addi	a0,a0,716 # 80023878 <disk+0x18>
    800055b4:	aedfc0ef          	jal	800020a0 <wakeup>
}
    800055b8:	60a2                	ld	ra,8(sp)
    800055ba:	6402                	ld	s0,0(sp)
    800055bc:	0141                	addi	sp,sp,16
    800055be:	8082                	ret
    panic("free_desc 1");
    800055c0:	00002517          	auipc	a0,0x2
    800055c4:	0c050513          	addi	a0,a0,192 # 80007680 <etext+0x680>
    800055c8:	9dafb0ef          	jal	800007a2 <panic>
    panic("free_desc 2");
    800055cc:	00002517          	auipc	a0,0x2
    800055d0:	0c450513          	addi	a0,a0,196 # 80007690 <etext+0x690>
    800055d4:	9cefb0ef          	jal	800007a2 <panic>

00000000800055d8 <virtio_disk_init>:
{
    800055d8:	1101                	addi	sp,sp,-32
    800055da:	ec06                	sd	ra,24(sp)
    800055dc:	e822                	sd	s0,16(sp)
    800055de:	e426                	sd	s1,8(sp)
    800055e0:	e04a                	sd	s2,0(sp)
    800055e2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800055e4:	00002597          	auipc	a1,0x2
    800055e8:	0bc58593          	addi	a1,a1,188 # 800076a0 <etext+0x6a0>
    800055ec:	0001e517          	auipc	a0,0x1e
    800055f0:	39c50513          	addi	a0,a0,924 # 80023988 <disk+0x128>
    800055f4:	d8efb0ef          	jal	80000b82 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055f8:	100017b7          	lui	a5,0x10001
    800055fc:	4398                	lw	a4,0(a5)
    800055fe:	2701                	sext.w	a4,a4
    80005600:	747277b7          	lui	a5,0x74727
    80005604:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005608:	18f71063          	bne	a4,a5,80005788 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000560c:	100017b7          	lui	a5,0x10001
    80005610:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80005612:	439c                	lw	a5,0(a5)
    80005614:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005616:	4709                	li	a4,2
    80005618:	16e79863          	bne	a5,a4,80005788 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000561c:	100017b7          	lui	a5,0x10001
    80005620:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005622:	439c                	lw	a5,0(a5)
    80005624:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005626:	16e79163          	bne	a5,a4,80005788 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000562a:	100017b7          	lui	a5,0x10001
    8000562e:	47d8                	lw	a4,12(a5)
    80005630:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005632:	554d47b7          	lui	a5,0x554d4
    80005636:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000563a:	14f71763          	bne	a4,a5,80005788 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000563e:	100017b7          	lui	a5,0x10001
    80005642:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005646:	4705                	li	a4,1
    80005648:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000564a:	470d                	li	a4,3
    8000564c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000564e:	10001737          	lui	a4,0x10001
    80005652:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005654:	c7ffe737          	lui	a4,0xc7ffe
    80005658:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdadbf>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000565c:	8ef9                	and	a3,a3,a4
    8000565e:	10001737          	lui	a4,0x10001
    80005662:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005664:	472d                	li	a4,11
    80005666:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005668:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000566c:	439c                	lw	a5,0(a5)
    8000566e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005672:	8ba1                	andi	a5,a5,8
    80005674:	12078063          	beqz	a5,80005794 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005678:	100017b7          	lui	a5,0x10001
    8000567c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005680:	100017b7          	lui	a5,0x10001
    80005684:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005688:	439c                	lw	a5,0(a5)
    8000568a:	2781                	sext.w	a5,a5
    8000568c:	10079a63          	bnez	a5,800057a0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005690:	100017b7          	lui	a5,0x10001
    80005694:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005698:	439c                	lw	a5,0(a5)
    8000569a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000569c:	10078863          	beqz	a5,800057ac <virtio_disk_init+0x1d4>
  if(max < NUM)
    800056a0:	471d                	li	a4,7
    800056a2:	10f77b63          	bgeu	a4,a5,800057b8 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    800056a6:	c8cfb0ef          	jal	80000b32 <kalloc>
    800056aa:	0001e497          	auipc	s1,0x1e
    800056ae:	1b648493          	addi	s1,s1,438 # 80023860 <disk>
    800056b2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800056b4:	c7efb0ef          	jal	80000b32 <kalloc>
    800056b8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800056ba:	c78fb0ef          	jal	80000b32 <kalloc>
    800056be:	87aa                	mv	a5,a0
    800056c0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800056c2:	6088                	ld	a0,0(s1)
    800056c4:	10050063          	beqz	a0,800057c4 <virtio_disk_init+0x1ec>
    800056c8:	0001e717          	auipc	a4,0x1e
    800056cc:	1a073703          	ld	a4,416(a4) # 80023868 <disk+0x8>
    800056d0:	0e070a63          	beqz	a4,800057c4 <virtio_disk_init+0x1ec>
    800056d4:	0e078863          	beqz	a5,800057c4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    800056d8:	6605                	lui	a2,0x1
    800056da:	4581                	li	a1,0
    800056dc:	dfafb0ef          	jal	80000cd6 <memset>
  memset(disk.avail, 0, PGSIZE);
    800056e0:	0001e497          	auipc	s1,0x1e
    800056e4:	18048493          	addi	s1,s1,384 # 80023860 <disk>
    800056e8:	6605                	lui	a2,0x1
    800056ea:	4581                	li	a1,0
    800056ec:	6488                	ld	a0,8(s1)
    800056ee:	de8fb0ef          	jal	80000cd6 <memset>
  memset(disk.used, 0, PGSIZE);
    800056f2:	6605                	lui	a2,0x1
    800056f4:	4581                	li	a1,0
    800056f6:	6888                	ld	a0,16(s1)
    800056f8:	ddefb0ef          	jal	80000cd6 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800056fc:	100017b7          	lui	a5,0x10001
    80005700:	4721                	li	a4,8
    80005702:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005704:	4098                	lw	a4,0(s1)
    80005706:	100017b7          	lui	a5,0x10001
    8000570a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000570e:	40d8                	lw	a4,4(s1)
    80005710:	100017b7          	lui	a5,0x10001
    80005714:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005718:	649c                	ld	a5,8(s1)
    8000571a:	0007869b          	sext.w	a3,a5
    8000571e:	10001737          	lui	a4,0x10001
    80005722:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005726:	9781                	srai	a5,a5,0x20
    80005728:	10001737          	lui	a4,0x10001
    8000572c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005730:	689c                	ld	a5,16(s1)
    80005732:	0007869b          	sext.w	a3,a5
    80005736:	10001737          	lui	a4,0x10001
    8000573a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000573e:	9781                	srai	a5,a5,0x20
    80005740:	10001737          	lui	a4,0x10001
    80005744:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005748:	10001737          	lui	a4,0x10001
    8000574c:	4785                	li	a5,1
    8000574e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005750:	00f48c23          	sb	a5,24(s1)
    80005754:	00f48ca3          	sb	a5,25(s1)
    80005758:	00f48d23          	sb	a5,26(s1)
    8000575c:	00f48da3          	sb	a5,27(s1)
    80005760:	00f48e23          	sb	a5,28(s1)
    80005764:	00f48ea3          	sb	a5,29(s1)
    80005768:	00f48f23          	sb	a5,30(s1)
    8000576c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005770:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005774:	100017b7          	lui	a5,0x10001
    80005778:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000577c:	60e2                	ld	ra,24(sp)
    8000577e:	6442                	ld	s0,16(sp)
    80005780:	64a2                	ld	s1,8(sp)
    80005782:	6902                	ld	s2,0(sp)
    80005784:	6105                	addi	sp,sp,32
    80005786:	8082                	ret
    panic("could not find virtio disk");
    80005788:	00002517          	auipc	a0,0x2
    8000578c:	f2850513          	addi	a0,a0,-216 # 800076b0 <etext+0x6b0>
    80005790:	812fb0ef          	jal	800007a2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005794:	00002517          	auipc	a0,0x2
    80005798:	f3c50513          	addi	a0,a0,-196 # 800076d0 <etext+0x6d0>
    8000579c:	806fb0ef          	jal	800007a2 <panic>
    panic("virtio disk should not be ready");
    800057a0:	00002517          	auipc	a0,0x2
    800057a4:	f5050513          	addi	a0,a0,-176 # 800076f0 <etext+0x6f0>
    800057a8:	ffbfa0ef          	jal	800007a2 <panic>
    panic("virtio disk has no queue 0");
    800057ac:	00002517          	auipc	a0,0x2
    800057b0:	f6450513          	addi	a0,a0,-156 # 80007710 <etext+0x710>
    800057b4:	feffa0ef          	jal	800007a2 <panic>
    panic("virtio disk max queue too short");
    800057b8:	00002517          	auipc	a0,0x2
    800057bc:	f7850513          	addi	a0,a0,-136 # 80007730 <etext+0x730>
    800057c0:	fe3fa0ef          	jal	800007a2 <panic>
    panic("virtio disk kalloc");
    800057c4:	00002517          	auipc	a0,0x2
    800057c8:	f8c50513          	addi	a0,a0,-116 # 80007750 <etext+0x750>
    800057cc:	fd7fa0ef          	jal	800007a2 <panic>

00000000800057d0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800057d0:	7159                	addi	sp,sp,-112
    800057d2:	f486                	sd	ra,104(sp)
    800057d4:	f0a2                	sd	s0,96(sp)
    800057d6:	eca6                	sd	s1,88(sp)
    800057d8:	e8ca                	sd	s2,80(sp)
    800057da:	e4ce                	sd	s3,72(sp)
    800057dc:	e0d2                	sd	s4,64(sp)
    800057de:	fc56                	sd	s5,56(sp)
    800057e0:	f85a                	sd	s6,48(sp)
    800057e2:	f45e                	sd	s7,40(sp)
    800057e4:	f062                	sd	s8,32(sp)
    800057e6:	ec66                	sd	s9,24(sp)
    800057e8:	1880                	addi	s0,sp,112
    800057ea:	8a2a                	mv	s4,a0
    800057ec:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800057ee:	00c52c83          	lw	s9,12(a0)
    800057f2:	001c9c9b          	slliw	s9,s9,0x1
    800057f6:	1c82                	slli	s9,s9,0x20
    800057f8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800057fc:	0001e517          	auipc	a0,0x1e
    80005800:	18c50513          	addi	a0,a0,396 # 80023988 <disk+0x128>
    80005804:	bfefb0ef          	jal	80000c02 <acquire>
  for(int i = 0; i < 3; i++){
    80005808:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000580a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000580c:	0001eb17          	auipc	s6,0x1e
    80005810:	054b0b13          	addi	s6,s6,84 # 80023860 <disk>
  for(int i = 0; i < 3; i++){
    80005814:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005816:	0001ec17          	auipc	s8,0x1e
    8000581a:	172c0c13          	addi	s8,s8,370 # 80023988 <disk+0x128>
    8000581e:	a8b9                	j	8000587c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005820:	00fb0733          	add	a4,s6,a5
    80005824:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005828:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000582a:	0207c563          	bltz	a5,80005854 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    8000582e:	2905                	addiw	s2,s2,1
    80005830:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005832:	05590963          	beq	s2,s5,80005884 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005836:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005838:	0001e717          	auipc	a4,0x1e
    8000583c:	02870713          	addi	a4,a4,40 # 80023860 <disk>
    80005840:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005842:	01874683          	lbu	a3,24(a4)
    80005846:	fee9                	bnez	a3,80005820 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005848:	2785                	addiw	a5,a5,1
    8000584a:	0705                	addi	a4,a4,1
    8000584c:	fe979be3          	bne	a5,s1,80005842 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005850:	57fd                	li	a5,-1
    80005852:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005854:	01205d63          	blez	s2,8000586e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005858:	f9042503          	lw	a0,-112(s0)
    8000585c:	d07ff0ef          	jal	80005562 <free_desc>
      for(int j = 0; j < i; j++)
    80005860:	4785                	li	a5,1
    80005862:	0127d663          	bge	a5,s2,8000586e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005866:	f9442503          	lw	a0,-108(s0)
    8000586a:	cf9ff0ef          	jal	80005562 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000586e:	85e2                	mv	a1,s8
    80005870:	0001e517          	auipc	a0,0x1e
    80005874:	00850513          	addi	a0,a0,8 # 80023878 <disk+0x18>
    80005878:	fdcfc0ef          	jal	80002054 <sleep>
  for(int i = 0; i < 3; i++){
    8000587c:	f9040613          	addi	a2,s0,-112
    80005880:	894e                	mv	s2,s3
    80005882:	bf55                	j	80005836 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005884:	f9042503          	lw	a0,-112(s0)
    80005888:	00451693          	slli	a3,a0,0x4

  if(write)
    8000588c:	0001e797          	auipc	a5,0x1e
    80005890:	fd478793          	addi	a5,a5,-44 # 80023860 <disk>
    80005894:	00a50713          	addi	a4,a0,10
    80005898:	0712                	slli	a4,a4,0x4
    8000589a:	973e                	add	a4,a4,a5
    8000589c:	01703633          	snez	a2,s7
    800058a0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800058a2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800058a6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800058aa:	6398                	ld	a4,0(a5)
    800058ac:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058ae:	0a868613          	addi	a2,a3,168
    800058b2:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800058b4:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800058b6:	6390                	ld	a2,0(a5)
    800058b8:	00d605b3          	add	a1,a2,a3
    800058bc:	4741                	li	a4,16
    800058be:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800058c0:	4805                	li	a6,1
    800058c2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800058c6:	f9442703          	lw	a4,-108(s0)
    800058ca:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800058ce:	0712                	slli	a4,a4,0x4
    800058d0:	963a                	add	a2,a2,a4
    800058d2:	058a0593          	addi	a1,s4,88
    800058d6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800058d8:	0007b883          	ld	a7,0(a5)
    800058dc:	9746                	add	a4,a4,a7
    800058de:	40000613          	li	a2,1024
    800058e2:	c710                	sw	a2,8(a4)
  if(write)
    800058e4:	001bb613          	seqz	a2,s7
    800058e8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800058ec:	00166613          	ori	a2,a2,1
    800058f0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800058f4:	f9842583          	lw	a1,-104(s0)
    800058f8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800058fc:	00250613          	addi	a2,a0,2
    80005900:	0612                	slli	a2,a2,0x4
    80005902:	963e                	add	a2,a2,a5
    80005904:	577d                	li	a4,-1
    80005906:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000590a:	0592                	slli	a1,a1,0x4
    8000590c:	98ae                	add	a7,a7,a1
    8000590e:	03068713          	addi	a4,a3,48
    80005912:	973e                	add	a4,a4,a5
    80005914:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005918:	6398                	ld	a4,0(a5)
    8000591a:	972e                	add	a4,a4,a1
    8000591c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005920:	4689                	li	a3,2
    80005922:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005926:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000592a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    8000592e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005932:	6794                	ld	a3,8(a5)
    80005934:	0026d703          	lhu	a4,2(a3)
    80005938:	8b1d                	andi	a4,a4,7
    8000593a:	0706                	slli	a4,a4,0x1
    8000593c:	96ba                	add	a3,a3,a4
    8000593e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005942:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005946:	6798                	ld	a4,8(a5)
    80005948:	00275783          	lhu	a5,2(a4)
    8000594c:	2785                	addiw	a5,a5,1
    8000594e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005952:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005956:	100017b7          	lui	a5,0x10001
    8000595a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000595e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005962:	0001e917          	auipc	s2,0x1e
    80005966:	02690913          	addi	s2,s2,38 # 80023988 <disk+0x128>
  while(b->disk == 1) {
    8000596a:	4485                	li	s1,1
    8000596c:	01079a63          	bne	a5,a6,80005980 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005970:	85ca                	mv	a1,s2
    80005972:	8552                	mv	a0,s4
    80005974:	ee0fc0ef          	jal	80002054 <sleep>
  while(b->disk == 1) {
    80005978:	004a2783          	lw	a5,4(s4)
    8000597c:	fe978ae3          	beq	a5,s1,80005970 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005980:	f9042903          	lw	s2,-112(s0)
    80005984:	00290713          	addi	a4,s2,2
    80005988:	0712                	slli	a4,a4,0x4
    8000598a:	0001e797          	auipc	a5,0x1e
    8000598e:	ed678793          	addi	a5,a5,-298 # 80023860 <disk>
    80005992:	97ba                	add	a5,a5,a4
    80005994:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005998:	0001e997          	auipc	s3,0x1e
    8000599c:	ec898993          	addi	s3,s3,-312 # 80023860 <disk>
    800059a0:	00491713          	slli	a4,s2,0x4
    800059a4:	0009b783          	ld	a5,0(s3)
    800059a8:	97ba                	add	a5,a5,a4
    800059aa:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800059ae:	854a                	mv	a0,s2
    800059b0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800059b4:	bafff0ef          	jal	80005562 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800059b8:	8885                	andi	s1,s1,1
    800059ba:	f0fd                	bnez	s1,800059a0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800059bc:	0001e517          	auipc	a0,0x1e
    800059c0:	fcc50513          	addi	a0,a0,-52 # 80023988 <disk+0x128>
    800059c4:	ad6fb0ef          	jal	80000c9a <release>
}
    800059c8:	70a6                	ld	ra,104(sp)
    800059ca:	7406                	ld	s0,96(sp)
    800059cc:	64e6                	ld	s1,88(sp)
    800059ce:	6946                	ld	s2,80(sp)
    800059d0:	69a6                	ld	s3,72(sp)
    800059d2:	6a06                	ld	s4,64(sp)
    800059d4:	7ae2                	ld	s5,56(sp)
    800059d6:	7b42                	ld	s6,48(sp)
    800059d8:	7ba2                	ld	s7,40(sp)
    800059da:	7c02                	ld	s8,32(sp)
    800059dc:	6ce2                	ld	s9,24(sp)
    800059de:	6165                	addi	sp,sp,112
    800059e0:	8082                	ret

00000000800059e2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800059e2:	1101                	addi	sp,sp,-32
    800059e4:	ec06                	sd	ra,24(sp)
    800059e6:	e822                	sd	s0,16(sp)
    800059e8:	e426                	sd	s1,8(sp)
    800059ea:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800059ec:	0001e497          	auipc	s1,0x1e
    800059f0:	e7448493          	addi	s1,s1,-396 # 80023860 <disk>
    800059f4:	0001e517          	auipc	a0,0x1e
    800059f8:	f9450513          	addi	a0,a0,-108 # 80023988 <disk+0x128>
    800059fc:	a06fb0ef          	jal	80000c02 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005a00:	100017b7          	lui	a5,0x10001
    80005a04:	53b8                	lw	a4,96(a5)
    80005a06:	8b0d                	andi	a4,a4,3
    80005a08:	100017b7          	lui	a5,0x10001
    80005a0c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005a0e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005a12:	689c                	ld	a5,16(s1)
    80005a14:	0204d703          	lhu	a4,32(s1)
    80005a18:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005a1c:	04f70663          	beq	a4,a5,80005a68 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005a20:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a24:	6898                	ld	a4,16(s1)
    80005a26:	0204d783          	lhu	a5,32(s1)
    80005a2a:	8b9d                	andi	a5,a5,7
    80005a2c:	078e                	slli	a5,a5,0x3
    80005a2e:	97ba                	add	a5,a5,a4
    80005a30:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a32:	00278713          	addi	a4,a5,2
    80005a36:	0712                	slli	a4,a4,0x4
    80005a38:	9726                	add	a4,a4,s1
    80005a3a:	01074703          	lbu	a4,16(a4)
    80005a3e:	e321                	bnez	a4,80005a7e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a40:	0789                	addi	a5,a5,2
    80005a42:	0792                	slli	a5,a5,0x4
    80005a44:	97a6                	add	a5,a5,s1
    80005a46:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005a48:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a4c:	e54fc0ef          	jal	800020a0 <wakeup>

    disk.used_idx += 1;
    80005a50:	0204d783          	lhu	a5,32(s1)
    80005a54:	2785                	addiw	a5,a5,1
    80005a56:	17c2                	slli	a5,a5,0x30
    80005a58:	93c1                	srli	a5,a5,0x30
    80005a5a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a5e:	6898                	ld	a4,16(s1)
    80005a60:	00275703          	lhu	a4,2(a4)
    80005a64:	faf71ee3          	bne	a4,a5,80005a20 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005a68:	0001e517          	auipc	a0,0x1e
    80005a6c:	f2050513          	addi	a0,a0,-224 # 80023988 <disk+0x128>
    80005a70:	a2afb0ef          	jal	80000c9a <release>
}
    80005a74:	60e2                	ld	ra,24(sp)
    80005a76:	6442                	ld	s0,16(sp)
    80005a78:	64a2                	ld	s1,8(sp)
    80005a7a:	6105                	addi	sp,sp,32
    80005a7c:	8082                	ret
      panic("virtio_disk_intr status");
    80005a7e:	00002517          	auipc	a0,0x2
    80005a82:	cea50513          	addi	a0,a0,-790 # 80007768 <etext+0x768>
    80005a86:	d1dfa0ef          	jal	800007a2 <panic>

0000000080005a8a <sys_random>:
 
//Random
static unsigned int lcg_state=1; //PRNG state
uint64
sys_random(void)
{
    80005a8a:	1141                	addi	sp,sp,-16
    80005a8c:	e422                	sd	s0,8(sp)
    80005a8e:	0800                	addi	s0,sp,16
  // Seed only once using ticks (global variable provided by xv6)
  extern uint ticks;
  if (lcg_state == 1)
    80005a90:	00005717          	auipc	a4,0x5
    80005a94:	92c72703          	lw	a4,-1748(a4) # 8000a3bc <lcg_state>
    80005a98:	4785                	li	a5,1
    80005a9a:	02f70763          	beq	a4,a5,80005ac8 <sys_random+0x3e>
    lcg_state = ticks + 1;  // avoid 0 seed

  // LCG formula
  lcg_state = (1103515245 * lcg_state + 12345) & 0x7fffffff;
    80005a9e:	00005717          	auipc	a4,0x5
    80005aa2:	91e70713          	addi	a4,a4,-1762 # 8000a3bc <lcg_state>
    80005aa6:	4314                	lw	a3,0(a4)
    80005aa8:	41c657b7          	lui	a5,0x41c65
    80005aac:	e6d7879b          	addiw	a5,a5,-403 # 41c64e6d <_entry-0x3e39b193>
    80005ab0:	02d7853b          	mulw	a0,a5,a3
    80005ab4:	678d                	lui	a5,0x3
    80005ab6:	0397879b          	addiw	a5,a5,57 # 3039 <_entry-0x7fffcfc7>
    80005aba:	9d3d                	addw	a0,a0,a5
    80005abc:	1506                	slli	a0,a0,0x21
    80005abe:	9105                	srli	a0,a0,0x21
    80005ac0:	c308                	sw	a0,0(a4)

  return lcg_state;
}
    80005ac2:	6422                	ld	s0,8(sp)
    80005ac4:	0141                	addi	sp,sp,16
    80005ac6:	8082                	ret
    lcg_state = ticks + 1;  // avoid 0 seed
    80005ac8:	00005797          	auipc	a5,0x5
    80005acc:	9907a783          	lw	a5,-1648(a5) # 8000a458 <ticks>
    80005ad0:	2785                	addiw	a5,a5,1
    80005ad2:	00005717          	auipc	a4,0x5
    80005ad6:	8ef72523          	sw	a5,-1814(a4) # 8000a3bc <lcg_state>
    80005ada:	b7d1                	j	80005a9e <sys_random+0x14>

0000000080005adc <sys_datetime>:
  r->day = (int)day;
}

uint64
sys_datetime(void)
{
    80005adc:	7179                	addi	sp,sp,-48
    80005ade:	f406                	sd	ra,40(sp)
    80005ae0:	f022                	sd	s0,32(sp)
    80005ae2:	1800                	addi	s0,sp,48
  uint64 user_addr;
  struct rtcdate rd;

  // get user pointer argument 0
  if(argaddr(0, &user_addr) < 0)
    80005ae4:	fe840593          	addi	a1,s0,-24
    80005ae8:	4501                	li	a0,0
    80005aea:	e77fc0ef          	jal	80002960 <argaddr>
    80005aee:	87aa                	mv	a5,a0
    return -1;
    80005af0:	557d                	li	a0,-1
  if(argaddr(0, &user_addr) < 0)
    80005af2:	1207c363          	bltz	a5,80005c18 <sys_datetime+0x13c>

 volatile uint64 *mtime = (volatile uint64 *)CLINT_MTIME;
 uint64 mtime_val = *mtime;   // increments in cycles / platform timeunits
    80005af6:	0200c7b7          	lui	a5,0x200c
    80005afa:	ff87b703          	ld	a4,-8(a5) # 200bff8 <_entry-0x7dff4008>
// Now convert to seconds. The conversion constant depends on the platform's mtime frequency.
// On QEMU virt, mtime increments at the host timer frequency used by the platform (platform dependent).

uint64 unix_secs = BOOT_EPOCH + (mtime_val / MTIME_FREQ);
    80005afe:	009897b7          	lui	a5,0x989
    80005b02:	68078793          	addi	a5,a5,1664 # 989680 <_entry-0x7f676980>
    80005b06:	02f75733          	divu	a4,a4,a5


//TO adjust cairo 
unix_secs+=7200;
    80005b0a:	693317b7          	lui	a5,0x69331
    80005b0e:	26b78793          	addi	a5,a5,619 # 6933126b <_entry-0x16cced95>
    80005b12:	973e                	add	a4,a4,a5
  uint64 rem = secs % 86400;
    80005b14:	66d5                	lui	a3,0x15
    80005b16:	18068693          	addi	a3,a3,384 # 15180 <_entry-0x7ffeae80>
    80005b1a:	02d777b3          	remu	a5,a4,a3
  r->hour = rem / 3600;
    80005b1e:	6605                	lui	a2,0x1
    80005b20:	e1060613          	addi	a2,a2,-496 # e10 <_entry-0x7ffff1f0>
    80005b24:	02c7d5b3          	divu	a1,a5,a2
    80005b28:	fcb42c23          	sw	a1,-40(s0)
  rem %= 3600;
    80005b2c:	02c7f7b3          	remu	a5,a5,a2
  r->minute = rem / 60;
    80005b30:	03c00613          	li	a2,60
    80005b34:	02c7d5b3          	divu	a1,a5,a2
    80005b38:	fcb42a23          	sw	a1,-44(s0)
  r->second = rem % 60;
    80005b3c:	02c7f7b3          	remu	a5,a5,a2
    80005b40:	fcf42823          	sw	a5,-48(s0)
  uint64 days = secs / 86400;
    80005b44:	02d75733          	divu	a4,a4,a3
  int64_t z = (int64_t)days + 719468; // shift to 0000-03-01 epoch used by algorithm
    80005b48:	000b07b7          	lui	a5,0xb0
    80005b4c:	a6c78793          	addi	a5,a5,-1428 # afa6c <_entry-0x7ff50594>
    80005b50:	973e                	add	a4,a4,a5
  int64_t era = (z >= 0 ? z : z - 146096) / 146097;
    80005b52:	000247b7          	lui	a5,0x24
    80005b56:	ab178793          	addi	a5,a5,-1359 # 23ab1 <_entry-0x7ffdc54f>
    80005b5a:	02f748b3          	div	a7,a4,a5
  unsigned doe = (unsigned)(z - era * 146097);          // [0, 146096]
    80005b5e:	02f887bb          	mulw	a5,a7,a5
    80005b62:	9f1d                	subw	a4,a4,a5
  unsigned yoe = (doe - doe/1460 + doe/36524 - doe/146096) / 365; // [0, 399]
    80005b64:	66a5                	lui	a3,0x9
    80005b66:	eac6869b          	addiw	a3,a3,-340 # 8eac <_entry-0x7fff7154>
    80005b6a:	02d756bb          	divuw	a3,a4,a3
    80005b6e:	9eb9                	addw	a3,a3,a4
    80005b70:	5b400813          	li	a6,1460
    80005b74:	030757bb          	divuw	a5,a4,a6
    80005b78:	9e9d                	subw	a3,a3,a5
    80005b7a:	000247b7          	lui	a5,0x24
    80005b7e:	ab07879b          	addiw	a5,a5,-1360 # 23ab0 <_entry-0x7ffdc550>
    80005b82:	02f757bb          	divuw	a5,a4,a5
    80005b86:	9e9d                	subw	a3,a3,a5
    80005b88:	16d00593          	li	a1,365
    80005b8c:	02b6d53b          	divuw	a0,a3,a1
  int year = (int)(yoe + era * 400);
    80005b90:	19000613          	li	a2,400
    80005b94:	0316063b          	mulw	a2,a2,a7
    80005b98:	9e29                	addw	a2,a2,a0
  unsigned doy = doe - (365*yoe + yoe/4 - yoe/100);     // [0, 365]
    80005b9a:	67a5                	lui	a5,0x9
    80005b9c:	e947879b          	addiw	a5,a5,-364 # 8e94 <_entry-0x7fff716c>
    80005ba0:	02f6d7bb          	divuw	a5,a3,a5
    80005ba4:	9fb9                	addw	a5,a5,a4
    80005ba6:	0306d6bb          	divuw	a3,a3,a6
    80005baa:	9f95                	subw	a5,a5,a3
    80005bac:	02a585bb          	mulw	a1,a1,a0
    80005bb0:	9f8d                	subw	a5,a5,a1
  unsigned mp = (5*doy + 2) / 153;                      // [0, 11]
    80005bb2:	0027971b          	slliw	a4,a5,0x2
    80005bb6:	9f3d                	addw	a4,a4,a5
    80005bb8:	2709                	addiw	a4,a4,2
    80005bba:	0007051b          	sext.w	a0,a4
    80005bbe:	09900693          	li	a3,153
    80005bc2:	02d7573b          	divuw	a4,a4,a3
  unsigned day = doy - (153*mp+2)/5 + 1;                // [1, 31]
    80005bc6:	2785                	addiw	a5,a5,1
    80005bc8:	0037169b          	slliw	a3,a4,0x3
    80005bcc:	9eb9                	addw	a3,a3,a4
    80005bce:	0046959b          	slliw	a1,a3,0x4
    80005bd2:	9ead                	addw	a3,a3,a1
    80005bd4:	2689                	addiw	a3,a3,2
    80005bd6:	4595                	li	a1,5
    80005bd8:	02b6d6bb          	divuw	a3,a3,a1
    80005bdc:	9f95                	subw	a5,a5,a3
  unsigned month = mp + (mp < 10 ? 3 : -9);             // [1, 12]
    80005bde:	5f900593          	li	a1,1529
    80005be2:	56dd                	li	a3,-9
    80005be4:	00a5e363          	bltu	a1,a0,80005bea <sys_datetime+0x10e>
    80005be8:	468d                	li	a3,3
    80005bea:	9f35                	addw	a4,a4,a3
    80005bec:	0007069b          	sext.w	a3,a4
  year += (month <= 2);
    80005bf0:	0036b693          	sltiu	a3,a3,3
    80005bf4:	9eb1                	addw	a3,a3,a2
  r->year = year;
    80005bf6:	fed42223          	sw	a3,-28(s0)
  r->month = (int)month;
    80005bfa:	fee42023          	sw	a4,-32(s0)
  r->day = (int)day;
    80005bfe:	fcf42e23          	sw	a5,-36(s0)

  seconds_to_rtcdate(unix_secs, &rd);


  // copy to user space
  if(copyout(myproc()->pagetable, user_addr, (char *)&rd, sizeof(rd)) < 0)
    80005c02:	d11fb0ef          	jal	80001912 <myproc>
    80005c06:	46e1                	li	a3,24
    80005c08:	fd040613          	addi	a2,s0,-48
    80005c0c:	fe843583          	ld	a1,-24(s0)
    80005c10:	6928                	ld	a0,80(a0)
    80005c12:	973fb0ef          	jal	80001584 <copyout>
    80005c16:	957d                	srai	a0,a0,0x3f
    return -1;

  return 0;
}
    80005c18:	70a2                	ld	ra,40(sp)
    80005c1a:	7402                	ld	s0,32(sp)
    80005c1c:	6145                	addi	sp,sp,48
    80005c1e:	8082                	ret

0000000080005c20 <sys_kbdint>:
extern int keyboard_int_cnt;
uint64 sys_kbdint()
{
    80005c20:	1141                	addi	sp,sp,-16
    80005c22:	e422                	sd	s0,8(sp)
    80005c24:	0800                	addi	s0,sp,16

return keyboard_int_cnt;
}
    80005c26:	00004517          	auipc	a0,0x4
    80005c2a:	7fa52503          	lw	a0,2042(a0) # 8000a420 <keyboard_int_cnt>
    80005c2e:	6422                	ld	s0,8(sp)
    80005c30:	0141                	addi	sp,sp,16
    80005c32:	8082                	ret
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
