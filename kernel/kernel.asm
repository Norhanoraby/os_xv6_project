
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	2f013103          	ld	sp,752(sp) # 8000a2f0 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb17f>
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
    800000fa:	18c020ef          	jal	80002286 <either_copyin>
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
    80000158:	1fc50513          	addi	a0,a0,508 # 80012350 <cons>
    8000015c:	2a7000ef          	jal	80000c02 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00012497          	auipc	s1,0x12
    80000164:	1f048493          	addi	s1,s1,496 # 80012350 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00012917          	auipc	s2,0x12
    8000016c:	28090913          	addi	s2,s2,640 # 800123e8 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	792010ef          	jal	80001912 <myproc>
    80000184:	795010ef          	jal	80002118 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	553010ef          	jal	80001ee0 <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	00012717          	auipc	a4,0x12
    800001a4:	1b070713          	addi	a4,a4,432 # 80012350 <cons>
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
    800001d2:	06a020ef          	jal	8000223c <either_copyout>
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
    800001ee:	16650513          	addi	a0,a0,358 # 80012350 <cons>
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
    80000218:	1cf72a23          	sw	a5,468(a4) # 800123e8 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	00012517          	auipc	a0,0x12
    8000022e:	12650513          	addi	a0,a0,294 # 80012350 <cons>
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
    80000282:	0d250513          	addi	a0,a0,210 # 80012350 <cons>
    80000286:	17d000ef          	jal	80000c02 <acquire>
  keyboard_int_cnt++;
    8000028a:	0000a717          	auipc	a4,0xa
    8000028e:	08670713          	addi	a4,a4,134 # 8000a310 <keyboard_int_cnt>
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
    800002ae:	022020ef          	jal	800022d0 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002b2:	00012517          	auipc	a0,0x12
    800002b6:	09e50513          	addi	a0,a0,158 # 80012350 <cons>
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
    800002d4:	08070713          	addi	a4,a4,128 # 80012350 <cons>
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
    800002fa:	05a78793          	addi	a5,a5,90 # 80012350 <cons>
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
    80000328:	0c47a783          	lw	a5,196(a5) # 800123e8 <cons+0x98>
    8000032c:	9f1d                	subw	a4,a4,a5
    8000032e:	08000793          	li	a5,128
    80000332:	f8f710e3          	bne	a4,a5,800002b2 <consoleintr+0x40>
    80000336:	a07d                	j	800003e4 <consoleintr+0x172>
    80000338:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000033a:	00012717          	auipc	a4,0x12
    8000033e:	01670713          	addi	a4,a4,22 # 80012350 <cons>
    80000342:	0a072783          	lw	a5,160(a4)
    80000346:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	00012497          	auipc	s1,0x12
    8000034e:	00648493          	addi	s1,s1,6 # 80012350 <cons>
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
    80000390:	fc470713          	addi	a4,a4,-60 # 80012350 <cons>
    80000394:	0a072783          	lw	a5,160(a4)
    80000398:	09c72703          	lw	a4,156(a4)
    8000039c:	f0f70be3          	beq	a4,a5,800002b2 <consoleintr+0x40>
      cons.e--;
    800003a0:	37fd                	addiw	a5,a5,-1
    800003a2:	00012717          	auipc	a4,0x12
    800003a6:	04f72723          	sw	a5,78(a4) # 800123f0 <cons+0xa0>
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
    800003c4:	f9078793          	addi	a5,a5,-112 # 80012350 <cons>
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
    800003e8:	00c7a423          	sw	a2,8(a5) # 800123ec <cons+0x9c>
        wakeup(&cons.r);
    800003ec:	00012517          	auipc	a0,0x12
    800003f0:	ffc50513          	addi	a0,a0,-4 # 800123e8 <cons+0x98>
    800003f4:	339010ef          	jal	80001f2c <wakeup>
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
    8000040e:	f4650513          	addi	a0,a0,-186 # 80012350 <cons>
    80000412:	770000ef          	jal	80000b82 <initlock>

  uartinit();
    80000416:	3f4000ef          	jal	8000080a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000041a:	00022797          	auipc	a5,0x22
    8000041e:	0ce78793          	addi	a5,a5,206 # 800224e8 <devsw>
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
    800004f2:	f227a783          	lw	a5,-222(a5) # 80012410 <pr+0x18>
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
    8000053e:	ebe50513          	addi	a0,a0,-322 # 800123f8 <pr>
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
    80000798:	c6450513          	addi	a0,a0,-924 # 800123f8 <pr>
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
    800007b2:	c607a123          	sw	zero,-926(a5) # 80012410 <pr+0x18>
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
    800007d6:	b4f72123          	sw	a5,-1214(a4) # 8000a314 <panicked>
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
    800007ea:	c1248493          	addi	s1,s1,-1006 # 800123f8 <pr>
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
    80000852:	bca50513          	addi	a0,a0,-1078 # 80012418 <uart_tx_lock>
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
    80000876:	aa27a783          	lw	a5,-1374(a5) # 8000a314 <panicked>
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
    800008ac:	a707b783          	ld	a5,-1424(a5) # 8000a318 <uart_tx_r>
    800008b0:	0000a717          	auipc	a4,0xa
    800008b4:	a7073703          	ld	a4,-1424(a4) # 8000a320 <uart_tx_w>
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
    800008da:	b42a8a93          	addi	s5,s5,-1214 # 80012418 <uart_tx_lock>
    uart_tx_r += 1;
    800008de:	0000a497          	auipc	s1,0xa
    800008e2:	a3a48493          	addi	s1,s1,-1478 # 8000a318 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008e6:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008ea:	0000a997          	auipc	s3,0xa
    800008ee:	a3698993          	addi	s3,s3,-1482 # 8000a320 <uart_tx_w>
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
    8000090c:	620010ef          	jal	80001f2c <wakeup>
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
    8000095e:	abe50513          	addi	a0,a0,-1346 # 80012418 <uart_tx_lock>
    80000962:	2a0000ef          	jal	80000c02 <acquire>
  if(panicked){
    80000966:	0000a797          	auipc	a5,0xa
    8000096a:	9ae7a783          	lw	a5,-1618(a5) # 8000a314 <panicked>
    8000096e:	efbd                	bnez	a5,800009ec <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000970:	0000a717          	auipc	a4,0xa
    80000974:	9b073703          	ld	a4,-1616(a4) # 8000a320 <uart_tx_w>
    80000978:	0000a797          	auipc	a5,0xa
    8000097c:	9a07b783          	ld	a5,-1632(a5) # 8000a318 <uart_tx_r>
    80000980:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000984:	00012997          	auipc	s3,0x12
    80000988:	a9498993          	addi	s3,s3,-1388 # 80012418 <uart_tx_lock>
    8000098c:	0000a497          	auipc	s1,0xa
    80000990:	98c48493          	addi	s1,s1,-1652 # 8000a318 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000994:	0000a917          	auipc	s2,0xa
    80000998:	98c90913          	addi	s2,s2,-1652 # 8000a320 <uart_tx_w>
    8000099c:	00e79d63          	bne	a5,a4,800009b6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800009a0:	85ce                	mv	a1,s3
    800009a2:	8526                	mv	a0,s1
    800009a4:	53c010ef          	jal	80001ee0 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800009a8:	00093703          	ld	a4,0(s2)
    800009ac:	609c                	ld	a5,0(s1)
    800009ae:	02078793          	addi	a5,a5,32
    800009b2:	fee787e3          	beq	a5,a4,800009a0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009b6:	00012497          	auipc	s1,0x12
    800009ba:	a6248493          	addi	s1,s1,-1438 # 80012418 <uart_tx_lock>
    800009be:	01f77793          	andi	a5,a4,31
    800009c2:	97a6                	add	a5,a5,s1
    800009c4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009c8:	0705                	addi	a4,a4,1
    800009ca:	0000a797          	auipc	a5,0xa
    800009ce:	94e7bb23          	sd	a4,-1706(a5) # 8000a320 <uart_tx_w>
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
    80000a32:	9ea48493          	addi	s1,s1,-1558 # 80012418 <uart_tx_lock>
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
    80000a68:	c1c78793          	addi	a5,a5,-996 # 80023680 <end>
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
    80000a84:	9d090913          	addi	s2,s2,-1584 # 80012450 <kmem>
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
    80000b12:	94250513          	addi	a0,a0,-1726 # 80012450 <kmem>
    80000b16:	06c000ef          	jal	80000b82 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b1a:	45c5                	li	a1,17
    80000b1c:	05ee                	slli	a1,a1,0x1b
    80000b1e:	00023517          	auipc	a0,0x23
    80000b22:	b6250513          	addi	a0,a0,-1182 # 80023680 <end>
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
    80000b40:	91448493          	addi	s1,s1,-1772 # 80012450 <kmem>
    80000b44:	8526                	mv	a0,s1
    80000b46:	0bc000ef          	jal	80000c02 <acquire>
  r = kmem.freelist;
    80000b4a:	6c84                	ld	s1,24(s1)
  if(r)
    80000b4c:	c485                	beqz	s1,80000b74 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b4e:	609c                	ld	a5,0(s1)
    80000b50:	00012517          	auipc	a0,0x12
    80000b54:	90050513          	addi	a0,a0,-1792 # 80012450 <kmem>
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
    80000b78:	8dc50513          	addi	a0,a0,-1828 # 80012450 <kmem>
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
    80000d4a:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb981>
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
    80000e80:	4ac70713          	addi	a4,a4,1196 # 8000a328 <started>
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
    80000ea6:	55c010ef          	jal	80002402 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000eaa:	43e040ef          	jal	800052e8 <plicinithart>
  }

  scheduler();        
    80000eae:	699000ef          	jal	80001d46 <scheduler>
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
    80000eee:	4f0010ef          	jal	800023de <trapinit>
    trapinithart();  // install kernel trap vector
    80000ef2:	510010ef          	jal	80002402 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ef6:	3d8040ef          	jal	800052ce <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000efa:	3ee040ef          	jal	800052e8 <plicinithart>
    binit();         // buffer cache
    80000efe:	39d010ef          	jal	80002a9a <binit>
    iinit();         // inode table
    80000f02:	18e020ef          	jal	80003090 <iinit>
    fileinit();      // file table
    80000f06:	73b020ef          	jal	80003e40 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f0a:	4ce040ef          	jal	800053d8 <virtio_disk_init>
    userinit();      // first user process
    80000f0e:	46d000ef          	jal	80001b7a <userinit>
    __sync_synchronize();
    80000f12:	0330000f          	fence	rw,rw
    started = 1;
    80000f16:	4785                	li	a5,1
    80000f18:	00009717          	auipc	a4,0x9
    80000f1c:	40f72823          	sw	a5,1040(a4) # 8000a328 <started>
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
    80000f30:	4047b783          	ld	a5,1028(a5) # 8000a330 <kernel_pagetable>
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
    80000f9e:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb977>
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
  kvmmap(kpgtbl, CLINT, CLINT, 0x10000, PTE_R | PTE_W);
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
    800011e0:	14a7ba23          	sd	a0,340(a5) # 8000a330 <kernel_pagetable>
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
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
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
    800017b2:	0f248493          	addi	s1,s1,242 # 800128a0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800017b6:	8b26                	mv	s6,s1
    800017b8:	04fa5937          	lui	s2,0x4fa5
    800017bc:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    800017c0:	0932                	slli	s2,s2,0xc
    800017c2:	fa590913          	addi	s2,s2,-91
    800017c6:	0932                	slli	s2,s2,0xc
    800017c8:	fa590913          	addi	s2,s2,-91
    800017cc:	0932                	slli	s2,s2,0xc
    800017ce:	fa590913          	addi	s2,s2,-91
    800017d2:	040009b7          	lui	s3,0x4000
    800017d6:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017d8:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017da:	00017a97          	auipc	s5,0x17
    800017de:	ac6a8a93          	addi	s5,s5,-1338 # 800182a0 <tickslock>
    char *pa = kalloc();
    800017e2:	b50ff0ef          	jal	80000b32 <kalloc>
    800017e6:	862a                	mv	a2,a0
    if(pa == 0)
    800017e8:	cd15                	beqz	a0,80001824 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017ea:	416485b3          	sub	a1,s1,s6
    800017ee:	858d                	srai	a1,a1,0x3
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
    80001808:	16848493          	addi	s1,s1,360
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
    80001850:	c2450513          	addi	a0,a0,-988 # 80012470 <pid_lock>
    80001854:	b2eff0ef          	jal	80000b82 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001858:	00006597          	auipc	a1,0x6
    8000185c:	9b058593          	addi	a1,a1,-1616 # 80007208 <etext+0x208>
    80001860:	00011517          	auipc	a0,0x11
    80001864:	c2850513          	addi	a0,a0,-984 # 80012488 <wait_lock>
    80001868:	b1aff0ef          	jal	80000b82 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000186c:	00011497          	auipc	s1,0x11
    80001870:	03448493          	addi	s1,s1,52 # 800128a0 <proc>
      initlock(&p->lock, "proc");
    80001874:	00006b17          	auipc	s6,0x6
    80001878:	9a4b0b13          	addi	s6,s6,-1628 # 80007218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000187c:	8aa6                	mv	s5,s1
    8000187e:	04fa5937          	lui	s2,0x4fa5
    80001882:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001886:	0932                	slli	s2,s2,0xc
    80001888:	fa590913          	addi	s2,s2,-91
    8000188c:	0932                	slli	s2,s2,0xc
    8000188e:	fa590913          	addi	s2,s2,-91
    80001892:	0932                	slli	s2,s2,0xc
    80001894:	fa590913          	addi	s2,s2,-91
    80001898:	040009b7          	lui	s3,0x4000
    8000189c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000189e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800018a0:	00017a17          	auipc	s4,0x17
    800018a4:	a00a0a13          	addi	s4,s4,-1536 # 800182a0 <tickslock>
      initlock(&p->lock, "proc");
    800018a8:	85da                	mv	a1,s6
    800018aa:	8526                	mv	a0,s1
    800018ac:	ad6ff0ef          	jal	80000b82 <initlock>
      p->state = UNUSED;
    800018b0:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800018b4:	415487b3          	sub	a5,s1,s5
    800018b8:	878d                	srai	a5,a5,0x3
    800018ba:	032787b3          	mul	a5,a5,s2
    800018be:	2785                	addiw	a5,a5,1
    800018c0:	00d7979b          	slliw	a5,a5,0xd
    800018c4:	40f987b3          	sub	a5,s3,a5
    800018c8:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ca:	16848493          	addi	s1,s1,360
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
    80001906:	b9e50513          	addi	a0,a0,-1122 # 800124a0 <cpus>
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
    8000192a:	b4a70713          	addi	a4,a4,-1206 # 80012470 <pid_lock>
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

0000000080001942 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001942:	1141                	addi	sp,sp,-16
    80001944:	e406                	sd	ra,8(sp)
    80001946:	e022                	sd	s0,0(sp)
    80001948:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000194a:	fc9ff0ef          	jal	80001912 <myproc>
    8000194e:	b4cff0ef          	jal	80000c9a <release>

  if (first) {
    80001952:	00009797          	auipc	a5,0x9
    80001956:	94e7a783          	lw	a5,-1714(a5) # 8000a2a0 <first.1>
    8000195a:	e799                	bnez	a5,80001968 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    8000195c:	2bf000ef          	jal	8000241a <usertrapret>
}
    80001960:	60a2                	ld	ra,8(sp)
    80001962:	6402                	ld	s0,0(sp)
    80001964:	0141                	addi	sp,sp,16
    80001966:	8082                	ret
    fsinit(ROOTDEV);
    80001968:	4505                	li	a0,1
    8000196a:	6ba010ef          	jal	80003024 <fsinit>
    first = 0;
    8000196e:	00009797          	auipc	a5,0x9
    80001972:	9207a923          	sw	zero,-1742(a5) # 8000a2a0 <first.1>
    __sync_synchronize();
    80001976:	0330000f          	fence	rw,rw
    8000197a:	b7cd                	j	8000195c <forkret+0x1a>

000000008000197c <allocpid>:
{
    8000197c:	1101                	addi	sp,sp,-32
    8000197e:	ec06                	sd	ra,24(sp)
    80001980:	e822                	sd	s0,16(sp)
    80001982:	e426                	sd	s1,8(sp)
    80001984:	e04a                	sd	s2,0(sp)
    80001986:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001988:	00011917          	auipc	s2,0x11
    8000198c:	ae890913          	addi	s2,s2,-1304 # 80012470 <pid_lock>
    80001990:	854a                	mv	a0,s2
    80001992:	a70ff0ef          	jal	80000c02 <acquire>
  pid = nextpid;
    80001996:	00009797          	auipc	a5,0x9
    8000199a:	90e78793          	addi	a5,a5,-1778 # 8000a2a4 <nextpid>
    8000199e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800019a0:	0014871b          	addiw	a4,s1,1
    800019a4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800019a6:	854a                	mv	a0,s2
    800019a8:	af2ff0ef          	jal	80000c9a <release>
}
    800019ac:	8526                	mv	a0,s1
    800019ae:	60e2                	ld	ra,24(sp)
    800019b0:	6442                	ld	s0,16(sp)
    800019b2:	64a2                	ld	s1,8(sp)
    800019b4:	6902                	ld	s2,0(sp)
    800019b6:	6105                	addi	sp,sp,32
    800019b8:	8082                	ret

00000000800019ba <proc_pagetable>:
{
    800019ba:	1101                	addi	sp,sp,-32
    800019bc:	ec06                	sd	ra,24(sp)
    800019be:	e822                	sd	s0,16(sp)
    800019c0:	e426                	sd	s1,8(sp)
    800019c2:	e04a                	sd	s2,0(sp)
    800019c4:	1000                	addi	s0,sp,32
    800019c6:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800019c8:	8e1ff0ef          	jal	800012a8 <uvmcreate>
    800019cc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800019ce:	cd05                	beqz	a0,80001a06 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800019d0:	4729                	li	a4,10
    800019d2:	00004697          	auipc	a3,0x4
    800019d6:	62e68693          	addi	a3,a3,1582 # 80006000 <_trampoline>
    800019da:	6605                	lui	a2,0x1
    800019dc:	040005b7          	lui	a1,0x4000
    800019e0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019e2:	05b2                	slli	a1,a1,0xc
    800019e4:	e3eff0ef          	jal	80001022 <mappages>
    800019e8:	02054663          	bltz	a0,80001a14 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800019ec:	4719                	li	a4,6
    800019ee:	05893683          	ld	a3,88(s2)
    800019f2:	6605                	lui	a2,0x1
    800019f4:	020005b7          	lui	a1,0x2000
    800019f8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800019fa:	05b6                	slli	a1,a1,0xd
    800019fc:	8526                	mv	a0,s1
    800019fe:	e24ff0ef          	jal	80001022 <mappages>
    80001a02:	00054f63          	bltz	a0,80001a20 <proc_pagetable+0x66>
}
    80001a06:	8526                	mv	a0,s1
    80001a08:	60e2                	ld	ra,24(sp)
    80001a0a:	6442                	ld	s0,16(sp)
    80001a0c:	64a2                	ld	s1,8(sp)
    80001a0e:	6902                	ld	s2,0(sp)
    80001a10:	6105                	addi	sp,sp,32
    80001a12:	8082                	ret
    uvmfree(pagetable, 0);
    80001a14:	4581                	li	a1,0
    80001a16:	8526                	mv	a0,s1
    80001a18:	a5fff0ef          	jal	80001476 <uvmfree>
    return 0;
    80001a1c:	4481                	li	s1,0
    80001a1e:	b7e5                	j	80001a06 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a20:	4681                	li	a3,0
    80001a22:	4605                	li	a2,1
    80001a24:	040005b7          	lui	a1,0x4000
    80001a28:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a2a:	05b2                	slli	a1,a1,0xc
    80001a2c:	8526                	mv	a0,s1
    80001a2e:	fbeff0ef          	jal	800011ec <uvmunmap>
    uvmfree(pagetable, 0);
    80001a32:	4581                	li	a1,0
    80001a34:	8526                	mv	a0,s1
    80001a36:	a41ff0ef          	jal	80001476 <uvmfree>
    return 0;
    80001a3a:	4481                	li	s1,0
    80001a3c:	b7e9                	j	80001a06 <proc_pagetable+0x4c>

0000000080001a3e <proc_freepagetable>:
{
    80001a3e:	1101                	addi	sp,sp,-32
    80001a40:	ec06                	sd	ra,24(sp)
    80001a42:	e822                	sd	s0,16(sp)
    80001a44:	e426                	sd	s1,8(sp)
    80001a46:	e04a                	sd	s2,0(sp)
    80001a48:	1000                	addi	s0,sp,32
    80001a4a:	84aa                	mv	s1,a0
    80001a4c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a4e:	4681                	li	a3,0
    80001a50:	4605                	li	a2,1
    80001a52:	040005b7          	lui	a1,0x4000
    80001a56:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a58:	05b2                	slli	a1,a1,0xc
    80001a5a:	f92ff0ef          	jal	800011ec <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a5e:	4681                	li	a3,0
    80001a60:	4605                	li	a2,1
    80001a62:	020005b7          	lui	a1,0x2000
    80001a66:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a68:	05b6                	slli	a1,a1,0xd
    80001a6a:	8526                	mv	a0,s1
    80001a6c:	f80ff0ef          	jal	800011ec <uvmunmap>
  uvmfree(pagetable, sz);
    80001a70:	85ca                	mv	a1,s2
    80001a72:	8526                	mv	a0,s1
    80001a74:	a03ff0ef          	jal	80001476 <uvmfree>
}
    80001a78:	60e2                	ld	ra,24(sp)
    80001a7a:	6442                	ld	s0,16(sp)
    80001a7c:	64a2                	ld	s1,8(sp)
    80001a7e:	6902                	ld	s2,0(sp)
    80001a80:	6105                	addi	sp,sp,32
    80001a82:	8082                	ret

0000000080001a84 <freeproc>:
{
    80001a84:	1101                	addi	sp,sp,-32
    80001a86:	ec06                	sd	ra,24(sp)
    80001a88:	e822                	sd	s0,16(sp)
    80001a8a:	e426                	sd	s1,8(sp)
    80001a8c:	1000                	addi	s0,sp,32
    80001a8e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001a90:	6d28                	ld	a0,88(a0)
    80001a92:	c119                	beqz	a0,80001a98 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001a94:	fbdfe0ef          	jal	80000a50 <kfree>
  p->trapframe = 0;
    80001a98:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001a9c:	68a8                	ld	a0,80(s1)
    80001a9e:	c501                	beqz	a0,80001aa6 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001aa0:	64ac                	ld	a1,72(s1)
    80001aa2:	f9dff0ef          	jal	80001a3e <proc_freepagetable>
  p->pagetable = 0;
    80001aa6:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001aaa:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001aae:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001ab2:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001ab6:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001aba:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001abe:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001ac2:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001ac6:	0004ac23          	sw	zero,24(s1)
}
    80001aca:	60e2                	ld	ra,24(sp)
    80001acc:	6442                	ld	s0,16(sp)
    80001ace:	64a2                	ld	s1,8(sp)
    80001ad0:	6105                	addi	sp,sp,32
    80001ad2:	8082                	ret

0000000080001ad4 <allocproc>:
{
    80001ad4:	1101                	addi	sp,sp,-32
    80001ad6:	ec06                	sd	ra,24(sp)
    80001ad8:	e822                	sd	s0,16(sp)
    80001ada:	e426                	sd	s1,8(sp)
    80001adc:	e04a                	sd	s2,0(sp)
    80001ade:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ae0:	00011497          	auipc	s1,0x11
    80001ae4:	dc048493          	addi	s1,s1,-576 # 800128a0 <proc>
    80001ae8:	00016917          	auipc	s2,0x16
    80001aec:	7b890913          	addi	s2,s2,1976 # 800182a0 <tickslock>
    acquire(&p->lock);
    80001af0:	8526                	mv	a0,s1
    80001af2:	910ff0ef          	jal	80000c02 <acquire>
    if(p->state == UNUSED) {
    80001af6:	4c9c                	lw	a5,24(s1)
    80001af8:	cb91                	beqz	a5,80001b0c <allocproc+0x38>
      release(&p->lock);
    80001afa:	8526                	mv	a0,s1
    80001afc:	99eff0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b00:	16848493          	addi	s1,s1,360
    80001b04:	ff2496e3          	bne	s1,s2,80001af0 <allocproc+0x1c>
  return 0;
    80001b08:	4481                	li	s1,0
    80001b0a:	a089                	j	80001b4c <allocproc+0x78>
  p->pid = allocpid();
    80001b0c:	e71ff0ef          	jal	8000197c <allocpid>
    80001b10:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b12:	4785                	li	a5,1
    80001b14:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001b16:	81cff0ef          	jal	80000b32 <kalloc>
    80001b1a:	892a                	mv	s2,a0
    80001b1c:	eca8                	sd	a0,88(s1)
    80001b1e:	cd15                	beqz	a0,80001b5a <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001b20:	8526                	mv	a0,s1
    80001b22:	e99ff0ef          	jal	800019ba <proc_pagetable>
    80001b26:	892a                	mv	s2,a0
    80001b28:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001b2a:	c121                	beqz	a0,80001b6a <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001b2c:	07000613          	li	a2,112
    80001b30:	4581                	li	a1,0
    80001b32:	06048513          	addi	a0,s1,96
    80001b36:	9a0ff0ef          	jal	80000cd6 <memset>
  p->context.ra = (uint64)forkret;
    80001b3a:	00000797          	auipc	a5,0x0
    80001b3e:	e0878793          	addi	a5,a5,-504 # 80001942 <forkret>
    80001b42:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b44:	60bc                	ld	a5,64(s1)
    80001b46:	6705                	lui	a4,0x1
    80001b48:	97ba                	add	a5,a5,a4
    80001b4a:	f4bc                	sd	a5,104(s1)
}
    80001b4c:	8526                	mv	a0,s1
    80001b4e:	60e2                	ld	ra,24(sp)
    80001b50:	6442                	ld	s0,16(sp)
    80001b52:	64a2                	ld	s1,8(sp)
    80001b54:	6902                	ld	s2,0(sp)
    80001b56:	6105                	addi	sp,sp,32
    80001b58:	8082                	ret
    freeproc(p);
    80001b5a:	8526                	mv	a0,s1
    80001b5c:	f29ff0ef          	jal	80001a84 <freeproc>
    release(&p->lock);
    80001b60:	8526                	mv	a0,s1
    80001b62:	938ff0ef          	jal	80000c9a <release>
    return 0;
    80001b66:	84ca                	mv	s1,s2
    80001b68:	b7d5                	j	80001b4c <allocproc+0x78>
    freeproc(p);
    80001b6a:	8526                	mv	a0,s1
    80001b6c:	f19ff0ef          	jal	80001a84 <freeproc>
    release(&p->lock);
    80001b70:	8526                	mv	a0,s1
    80001b72:	928ff0ef          	jal	80000c9a <release>
    return 0;
    80001b76:	84ca                	mv	s1,s2
    80001b78:	bfd1                	j	80001b4c <allocproc+0x78>

0000000080001b7a <userinit>:
{
    80001b7a:	1101                	addi	sp,sp,-32
    80001b7c:	ec06                	sd	ra,24(sp)
    80001b7e:	e822                	sd	s0,16(sp)
    80001b80:	e426                	sd	s1,8(sp)
    80001b82:	1000                	addi	s0,sp,32
  p = allocproc();
    80001b84:	f51ff0ef          	jal	80001ad4 <allocproc>
    80001b88:	84aa                	mv	s1,a0
  initproc = p;
    80001b8a:	00008797          	auipc	a5,0x8
    80001b8e:	7aa7b723          	sd	a0,1966(a5) # 8000a338 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001b92:	03400613          	li	a2,52
    80001b96:	00008597          	auipc	a1,0x8
    80001b9a:	71a58593          	addi	a1,a1,1818 # 8000a2b0 <initcode>
    80001b9e:	6928                	ld	a0,80(a0)
    80001ba0:	f2eff0ef          	jal	800012ce <uvmfirst>
  p->sz = PGSIZE;
    80001ba4:	6785                	lui	a5,0x1
    80001ba6:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001ba8:	6cb8                	ld	a4,88(s1)
    80001baa:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001bae:	6cb8                	ld	a4,88(s1)
    80001bb0:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001bb2:	4641                	li	a2,16
    80001bb4:	00005597          	auipc	a1,0x5
    80001bb8:	66c58593          	addi	a1,a1,1644 # 80007220 <etext+0x220>
    80001bbc:	15848513          	addi	a0,s1,344
    80001bc0:	a54ff0ef          	jal	80000e14 <safestrcpy>
  p->cwd = namei("/");
    80001bc4:	00005517          	auipc	a0,0x5
    80001bc8:	66c50513          	addi	a0,a0,1644 # 80007230 <etext+0x230>
    80001bcc:	567010ef          	jal	80003932 <namei>
    80001bd0:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001bd4:	478d                	li	a5,3
    80001bd6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001bd8:	8526                	mv	a0,s1
    80001bda:	8c0ff0ef          	jal	80000c9a <release>
}
    80001bde:	60e2                	ld	ra,24(sp)
    80001be0:	6442                	ld	s0,16(sp)
    80001be2:	64a2                	ld	s1,8(sp)
    80001be4:	6105                	addi	sp,sp,32
    80001be6:	8082                	ret

0000000080001be8 <growproc>:
{
    80001be8:	1101                	addi	sp,sp,-32
    80001bea:	ec06                	sd	ra,24(sp)
    80001bec:	e822                	sd	s0,16(sp)
    80001bee:	e426                	sd	s1,8(sp)
    80001bf0:	e04a                	sd	s2,0(sp)
    80001bf2:	1000                	addi	s0,sp,32
    80001bf4:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001bf6:	d1dff0ef          	jal	80001912 <myproc>
    80001bfa:	84aa                	mv	s1,a0
  sz = p->sz;
    80001bfc:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001bfe:	01204c63          	bgtz	s2,80001c16 <growproc+0x2e>
  } else if(n < 0){
    80001c02:	02094463          	bltz	s2,80001c2a <growproc+0x42>
  p->sz = sz;
    80001c06:	e4ac                	sd	a1,72(s1)
  return 0;
    80001c08:	4501                	li	a0,0
}
    80001c0a:	60e2                	ld	ra,24(sp)
    80001c0c:	6442                	ld	s0,16(sp)
    80001c0e:	64a2                	ld	s1,8(sp)
    80001c10:	6902                	ld	s2,0(sp)
    80001c12:	6105                	addi	sp,sp,32
    80001c14:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c16:	4691                	li	a3,4
    80001c18:	00b90633          	add	a2,s2,a1
    80001c1c:	6928                	ld	a0,80(a0)
    80001c1e:	f52ff0ef          	jal	80001370 <uvmalloc>
    80001c22:	85aa                	mv	a1,a0
    80001c24:	f16d                	bnez	a0,80001c06 <growproc+0x1e>
      return -1;
    80001c26:	557d                	li	a0,-1
    80001c28:	b7cd                	j	80001c0a <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c2a:	00b90633          	add	a2,s2,a1
    80001c2e:	6928                	ld	a0,80(a0)
    80001c30:	efcff0ef          	jal	8000132c <uvmdealloc>
    80001c34:	85aa                	mv	a1,a0
    80001c36:	bfc1                	j	80001c06 <growproc+0x1e>

0000000080001c38 <fork>:
{
    80001c38:	7139                	addi	sp,sp,-64
    80001c3a:	fc06                	sd	ra,56(sp)
    80001c3c:	f822                	sd	s0,48(sp)
    80001c3e:	f04a                	sd	s2,32(sp)
    80001c40:	e456                	sd	s5,8(sp)
    80001c42:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c44:	ccfff0ef          	jal	80001912 <myproc>
    80001c48:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001c4a:	e8bff0ef          	jal	80001ad4 <allocproc>
    80001c4e:	0e050a63          	beqz	a0,80001d42 <fork+0x10a>
    80001c52:	e852                	sd	s4,16(sp)
    80001c54:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001c56:	048ab603          	ld	a2,72(s5)
    80001c5a:	692c                	ld	a1,80(a0)
    80001c5c:	050ab503          	ld	a0,80(s5)
    80001c60:	849ff0ef          	jal	800014a8 <uvmcopy>
    80001c64:	04054a63          	bltz	a0,80001cb8 <fork+0x80>
    80001c68:	f426                	sd	s1,40(sp)
    80001c6a:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001c6c:	048ab783          	ld	a5,72(s5)
    80001c70:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001c74:	058ab683          	ld	a3,88(s5)
    80001c78:	87b6                	mv	a5,a3
    80001c7a:	058a3703          	ld	a4,88(s4)
    80001c7e:	12068693          	addi	a3,a3,288
    80001c82:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001c86:	6788                	ld	a0,8(a5)
    80001c88:	6b8c                	ld	a1,16(a5)
    80001c8a:	6f90                	ld	a2,24(a5)
    80001c8c:	01073023          	sd	a6,0(a4)
    80001c90:	e708                	sd	a0,8(a4)
    80001c92:	eb0c                	sd	a1,16(a4)
    80001c94:	ef10                	sd	a2,24(a4)
    80001c96:	02078793          	addi	a5,a5,32
    80001c9a:	02070713          	addi	a4,a4,32
    80001c9e:	fed792e3          	bne	a5,a3,80001c82 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001ca2:	058a3783          	ld	a5,88(s4)
    80001ca6:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001caa:	0d0a8493          	addi	s1,s5,208
    80001cae:	0d0a0913          	addi	s2,s4,208
    80001cb2:	150a8993          	addi	s3,s5,336
    80001cb6:	a831                	j	80001cd2 <fork+0x9a>
    freeproc(np);
    80001cb8:	8552                	mv	a0,s4
    80001cba:	dcbff0ef          	jal	80001a84 <freeproc>
    release(&np->lock);
    80001cbe:	8552                	mv	a0,s4
    80001cc0:	fdbfe0ef          	jal	80000c9a <release>
    return -1;
    80001cc4:	597d                	li	s2,-1
    80001cc6:	6a42                	ld	s4,16(sp)
    80001cc8:	a0b5                	j	80001d34 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001cca:	04a1                	addi	s1,s1,8
    80001ccc:	0921                	addi	s2,s2,8
    80001cce:	01348963          	beq	s1,s3,80001ce0 <fork+0xa8>
    if(p->ofile[i])
    80001cd2:	6088                	ld	a0,0(s1)
    80001cd4:	d97d                	beqz	a0,80001cca <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001cd6:	1ec020ef          	jal	80003ec2 <filedup>
    80001cda:	00a93023          	sd	a0,0(s2)
    80001cde:	b7f5                	j	80001cca <fork+0x92>
  np->cwd = idup(p->cwd);
    80001ce0:	150ab503          	ld	a0,336(s5)
    80001ce4:	53e010ef          	jal	80003222 <idup>
    80001ce8:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001cec:	4641                	li	a2,16
    80001cee:	158a8593          	addi	a1,s5,344
    80001cf2:	158a0513          	addi	a0,s4,344
    80001cf6:	91eff0ef          	jal	80000e14 <safestrcpy>
  pid = np->pid;
    80001cfa:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001cfe:	8552                	mv	a0,s4
    80001d00:	f9bfe0ef          	jal	80000c9a <release>
  acquire(&wait_lock);
    80001d04:	00010497          	auipc	s1,0x10
    80001d08:	78448493          	addi	s1,s1,1924 # 80012488 <wait_lock>
    80001d0c:	8526                	mv	a0,s1
    80001d0e:	ef5fe0ef          	jal	80000c02 <acquire>
  np->parent = p;
    80001d12:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001d16:	8526                	mv	a0,s1
    80001d18:	f83fe0ef          	jal	80000c9a <release>
  acquire(&np->lock);
    80001d1c:	8552                	mv	a0,s4
    80001d1e:	ee5fe0ef          	jal	80000c02 <acquire>
  np->state = RUNNABLE;
    80001d22:	478d                	li	a5,3
    80001d24:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001d28:	8552                	mv	a0,s4
    80001d2a:	f71fe0ef          	jal	80000c9a <release>
  return pid;
    80001d2e:	74a2                	ld	s1,40(sp)
    80001d30:	69e2                	ld	s3,24(sp)
    80001d32:	6a42                	ld	s4,16(sp)
}
    80001d34:	854a                	mv	a0,s2
    80001d36:	70e2                	ld	ra,56(sp)
    80001d38:	7442                	ld	s0,48(sp)
    80001d3a:	7902                	ld	s2,32(sp)
    80001d3c:	6aa2                	ld	s5,8(sp)
    80001d3e:	6121                	addi	sp,sp,64
    80001d40:	8082                	ret
    return -1;
    80001d42:	597d                	li	s2,-1
    80001d44:	bfc5                	j	80001d34 <fork+0xfc>

0000000080001d46 <scheduler>:
{
    80001d46:	715d                	addi	sp,sp,-80
    80001d48:	e486                	sd	ra,72(sp)
    80001d4a:	e0a2                	sd	s0,64(sp)
    80001d4c:	fc26                	sd	s1,56(sp)
    80001d4e:	f84a                	sd	s2,48(sp)
    80001d50:	f44e                	sd	s3,40(sp)
    80001d52:	f052                	sd	s4,32(sp)
    80001d54:	ec56                	sd	s5,24(sp)
    80001d56:	e85a                	sd	s6,16(sp)
    80001d58:	e45e                	sd	s7,8(sp)
    80001d5a:	e062                	sd	s8,0(sp)
    80001d5c:	0880                	addi	s0,sp,80
    80001d5e:	8792                	mv	a5,tp
  int id = r_tp();
    80001d60:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d62:	00779b13          	slli	s6,a5,0x7
    80001d66:	00010717          	auipc	a4,0x10
    80001d6a:	70a70713          	addi	a4,a4,1802 # 80012470 <pid_lock>
    80001d6e:	975a                	add	a4,a4,s6
    80001d70:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001d74:	00010717          	auipc	a4,0x10
    80001d78:	73470713          	addi	a4,a4,1844 # 800124a8 <cpus+0x8>
    80001d7c:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001d7e:	4c11                	li	s8,4
        c->proc = p;
    80001d80:	079e                	slli	a5,a5,0x7
    80001d82:	00010a17          	auipc	s4,0x10
    80001d86:	6eea0a13          	addi	s4,s4,1774 # 80012470 <pid_lock>
    80001d8a:	9a3e                	add	s4,s4,a5
        found = 1;
    80001d8c:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d8e:	00016997          	auipc	s3,0x16
    80001d92:	51298993          	addi	s3,s3,1298 # 800182a0 <tickslock>
    80001d96:	a0a9                	j	80001de0 <scheduler+0x9a>
      release(&p->lock);
    80001d98:	8526                	mv	a0,s1
    80001d9a:	f01fe0ef          	jal	80000c9a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d9e:	16848493          	addi	s1,s1,360
    80001da2:	03348563          	beq	s1,s3,80001dcc <scheduler+0x86>
      acquire(&p->lock);
    80001da6:	8526                	mv	a0,s1
    80001da8:	e5bfe0ef          	jal	80000c02 <acquire>
      if(p->state == RUNNABLE) {
    80001dac:	4c9c                	lw	a5,24(s1)
    80001dae:	ff2795e3          	bne	a5,s2,80001d98 <scheduler+0x52>
        p->state = RUNNING;
    80001db2:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001db6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001dba:	06048593          	addi	a1,s1,96
    80001dbe:	855a                	mv	a0,s6
    80001dc0:	5b4000ef          	jal	80002374 <swtch>
        c->proc = 0;
    80001dc4:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001dc8:	8ade                	mv	s5,s7
    80001dca:	b7f9                	j	80001d98 <scheduler+0x52>
    if(found == 0) {
    80001dcc:	000a9a63          	bnez	s5,80001de0 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dd0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001dd4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dd8:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001ddc:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001de0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001de4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001de8:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001dec:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001dee:	00011497          	auipc	s1,0x11
    80001df2:	ab248493          	addi	s1,s1,-1358 # 800128a0 <proc>
      if(p->state == RUNNABLE) {
    80001df6:	490d                	li	s2,3
    80001df8:	b77d                	j	80001da6 <scheduler+0x60>

0000000080001dfa <sched>:
{
    80001dfa:	7179                	addi	sp,sp,-48
    80001dfc:	f406                	sd	ra,40(sp)
    80001dfe:	f022                	sd	s0,32(sp)
    80001e00:	ec26                	sd	s1,24(sp)
    80001e02:	e84a                	sd	s2,16(sp)
    80001e04:	e44e                	sd	s3,8(sp)
    80001e06:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e08:	b0bff0ef          	jal	80001912 <myproc>
    80001e0c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001e0e:	d8bfe0ef          	jal	80000b98 <holding>
    80001e12:	c92d                	beqz	a0,80001e84 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e14:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001e16:	2781                	sext.w	a5,a5
    80001e18:	079e                	slli	a5,a5,0x7
    80001e1a:	00010717          	auipc	a4,0x10
    80001e1e:	65670713          	addi	a4,a4,1622 # 80012470 <pid_lock>
    80001e22:	97ba                	add	a5,a5,a4
    80001e24:	0a87a703          	lw	a4,168(a5)
    80001e28:	4785                	li	a5,1
    80001e2a:	06f71363          	bne	a4,a5,80001e90 <sched+0x96>
  if(p->state == RUNNING)
    80001e2e:	4c98                	lw	a4,24(s1)
    80001e30:	4791                	li	a5,4
    80001e32:	06f70563          	beq	a4,a5,80001e9c <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e36:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e3a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e3c:	e7b5                	bnez	a5,80001ea8 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e3e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e40:	00010917          	auipc	s2,0x10
    80001e44:	63090913          	addi	s2,s2,1584 # 80012470 <pid_lock>
    80001e48:	2781                	sext.w	a5,a5
    80001e4a:	079e                	slli	a5,a5,0x7
    80001e4c:	97ca                	add	a5,a5,s2
    80001e4e:	0ac7a983          	lw	s3,172(a5)
    80001e52:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e54:	2781                	sext.w	a5,a5
    80001e56:	079e                	slli	a5,a5,0x7
    80001e58:	00010597          	auipc	a1,0x10
    80001e5c:	65058593          	addi	a1,a1,1616 # 800124a8 <cpus+0x8>
    80001e60:	95be                	add	a1,a1,a5
    80001e62:	06048513          	addi	a0,s1,96
    80001e66:	50e000ef          	jal	80002374 <swtch>
    80001e6a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001e6c:	2781                	sext.w	a5,a5
    80001e6e:	079e                	slli	a5,a5,0x7
    80001e70:	993e                	add	s2,s2,a5
    80001e72:	0b392623          	sw	s3,172(s2)
}
    80001e76:	70a2                	ld	ra,40(sp)
    80001e78:	7402                	ld	s0,32(sp)
    80001e7a:	64e2                	ld	s1,24(sp)
    80001e7c:	6942                	ld	s2,16(sp)
    80001e7e:	69a2                	ld	s3,8(sp)
    80001e80:	6145                	addi	sp,sp,48
    80001e82:	8082                	ret
    panic("sched p->lock");
    80001e84:	00005517          	auipc	a0,0x5
    80001e88:	3b450513          	addi	a0,a0,948 # 80007238 <etext+0x238>
    80001e8c:	917fe0ef          	jal	800007a2 <panic>
    panic("sched locks");
    80001e90:	00005517          	auipc	a0,0x5
    80001e94:	3b850513          	addi	a0,a0,952 # 80007248 <etext+0x248>
    80001e98:	90bfe0ef          	jal	800007a2 <panic>
    panic("sched running");
    80001e9c:	00005517          	auipc	a0,0x5
    80001ea0:	3bc50513          	addi	a0,a0,956 # 80007258 <etext+0x258>
    80001ea4:	8fffe0ef          	jal	800007a2 <panic>
    panic("sched interruptible");
    80001ea8:	00005517          	auipc	a0,0x5
    80001eac:	3c050513          	addi	a0,a0,960 # 80007268 <etext+0x268>
    80001eb0:	8f3fe0ef          	jal	800007a2 <panic>

0000000080001eb4 <yield>:
{
    80001eb4:	1101                	addi	sp,sp,-32
    80001eb6:	ec06                	sd	ra,24(sp)
    80001eb8:	e822                	sd	s0,16(sp)
    80001eba:	e426                	sd	s1,8(sp)
    80001ebc:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001ebe:	a55ff0ef          	jal	80001912 <myproc>
    80001ec2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001ec4:	d3ffe0ef          	jal	80000c02 <acquire>
  p->state = RUNNABLE;
    80001ec8:	478d                	li	a5,3
    80001eca:	cc9c                	sw	a5,24(s1)
  sched();
    80001ecc:	f2fff0ef          	jal	80001dfa <sched>
  release(&p->lock);
    80001ed0:	8526                	mv	a0,s1
    80001ed2:	dc9fe0ef          	jal	80000c9a <release>
}
    80001ed6:	60e2                	ld	ra,24(sp)
    80001ed8:	6442                	ld	s0,16(sp)
    80001eda:	64a2                	ld	s1,8(sp)
    80001edc:	6105                	addi	sp,sp,32
    80001ede:	8082                	ret

0000000080001ee0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001ee0:	7179                	addi	sp,sp,-48
    80001ee2:	f406                	sd	ra,40(sp)
    80001ee4:	f022                	sd	s0,32(sp)
    80001ee6:	ec26                	sd	s1,24(sp)
    80001ee8:	e84a                	sd	s2,16(sp)
    80001eea:	e44e                	sd	s3,8(sp)
    80001eec:	1800                	addi	s0,sp,48
    80001eee:	89aa                	mv	s3,a0
    80001ef0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ef2:	a21ff0ef          	jal	80001912 <myproc>
    80001ef6:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001ef8:	d0bfe0ef          	jal	80000c02 <acquire>
  release(lk);
    80001efc:	854a                	mv	a0,s2
    80001efe:	d9dfe0ef          	jal	80000c9a <release>

  // Go to sleep.
  p->chan = chan;
    80001f02:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001f06:	4789                	li	a5,2
    80001f08:	cc9c                	sw	a5,24(s1)

  sched();
    80001f0a:	ef1ff0ef          	jal	80001dfa <sched>

  // Tidy up.
  p->chan = 0;
    80001f0e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001f12:	8526                	mv	a0,s1
    80001f14:	d87fe0ef          	jal	80000c9a <release>
  acquire(lk);
    80001f18:	854a                	mv	a0,s2
    80001f1a:	ce9fe0ef          	jal	80000c02 <acquire>
}
    80001f1e:	70a2                	ld	ra,40(sp)
    80001f20:	7402                	ld	s0,32(sp)
    80001f22:	64e2                	ld	s1,24(sp)
    80001f24:	6942                	ld	s2,16(sp)
    80001f26:	69a2                	ld	s3,8(sp)
    80001f28:	6145                	addi	sp,sp,48
    80001f2a:	8082                	ret

0000000080001f2c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001f2c:	7139                	addi	sp,sp,-64
    80001f2e:	fc06                	sd	ra,56(sp)
    80001f30:	f822                	sd	s0,48(sp)
    80001f32:	f426                	sd	s1,40(sp)
    80001f34:	f04a                	sd	s2,32(sp)
    80001f36:	ec4e                	sd	s3,24(sp)
    80001f38:	e852                	sd	s4,16(sp)
    80001f3a:	e456                	sd	s5,8(sp)
    80001f3c:	0080                	addi	s0,sp,64
    80001f3e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001f40:	00011497          	auipc	s1,0x11
    80001f44:	96048493          	addi	s1,s1,-1696 # 800128a0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001f48:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001f4a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f4c:	00016917          	auipc	s2,0x16
    80001f50:	35490913          	addi	s2,s2,852 # 800182a0 <tickslock>
    80001f54:	a801                	j	80001f64 <wakeup+0x38>
      }
      release(&p->lock);
    80001f56:	8526                	mv	a0,s1
    80001f58:	d43fe0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f5c:	16848493          	addi	s1,s1,360
    80001f60:	03248263          	beq	s1,s2,80001f84 <wakeup+0x58>
    if(p != myproc()){
    80001f64:	9afff0ef          	jal	80001912 <myproc>
    80001f68:	fea48ae3          	beq	s1,a0,80001f5c <wakeup+0x30>
      acquire(&p->lock);
    80001f6c:	8526                	mv	a0,s1
    80001f6e:	c95fe0ef          	jal	80000c02 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001f72:	4c9c                	lw	a5,24(s1)
    80001f74:	ff3791e3          	bne	a5,s3,80001f56 <wakeup+0x2a>
    80001f78:	709c                	ld	a5,32(s1)
    80001f7a:	fd479ee3          	bne	a5,s4,80001f56 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001f7e:	0154ac23          	sw	s5,24(s1)
    80001f82:	bfd1                	j	80001f56 <wakeup+0x2a>
    }
  }
}
    80001f84:	70e2                	ld	ra,56(sp)
    80001f86:	7442                	ld	s0,48(sp)
    80001f88:	74a2                	ld	s1,40(sp)
    80001f8a:	7902                	ld	s2,32(sp)
    80001f8c:	69e2                	ld	s3,24(sp)
    80001f8e:	6a42                	ld	s4,16(sp)
    80001f90:	6aa2                	ld	s5,8(sp)
    80001f92:	6121                	addi	sp,sp,64
    80001f94:	8082                	ret

0000000080001f96 <reparent>:
{
    80001f96:	7179                	addi	sp,sp,-48
    80001f98:	f406                	sd	ra,40(sp)
    80001f9a:	f022                	sd	s0,32(sp)
    80001f9c:	ec26                	sd	s1,24(sp)
    80001f9e:	e84a                	sd	s2,16(sp)
    80001fa0:	e44e                	sd	s3,8(sp)
    80001fa2:	e052                	sd	s4,0(sp)
    80001fa4:	1800                	addi	s0,sp,48
    80001fa6:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001fa8:	00011497          	auipc	s1,0x11
    80001fac:	8f848493          	addi	s1,s1,-1800 # 800128a0 <proc>
      pp->parent = initproc;
    80001fb0:	00008a17          	auipc	s4,0x8
    80001fb4:	388a0a13          	addi	s4,s4,904 # 8000a338 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001fb8:	00016997          	auipc	s3,0x16
    80001fbc:	2e898993          	addi	s3,s3,744 # 800182a0 <tickslock>
    80001fc0:	a029                	j	80001fca <reparent+0x34>
    80001fc2:	16848493          	addi	s1,s1,360
    80001fc6:	01348b63          	beq	s1,s3,80001fdc <reparent+0x46>
    if(pp->parent == p){
    80001fca:	7c9c                	ld	a5,56(s1)
    80001fcc:	ff279be3          	bne	a5,s2,80001fc2 <reparent+0x2c>
      pp->parent = initproc;
    80001fd0:	000a3503          	ld	a0,0(s4)
    80001fd4:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001fd6:	f57ff0ef          	jal	80001f2c <wakeup>
    80001fda:	b7e5                	j	80001fc2 <reparent+0x2c>
}
    80001fdc:	70a2                	ld	ra,40(sp)
    80001fde:	7402                	ld	s0,32(sp)
    80001fe0:	64e2                	ld	s1,24(sp)
    80001fe2:	6942                	ld	s2,16(sp)
    80001fe4:	69a2                	ld	s3,8(sp)
    80001fe6:	6a02                	ld	s4,0(sp)
    80001fe8:	6145                	addi	sp,sp,48
    80001fea:	8082                	ret

0000000080001fec <exit>:
{
    80001fec:	7179                	addi	sp,sp,-48
    80001fee:	f406                	sd	ra,40(sp)
    80001ff0:	f022                	sd	s0,32(sp)
    80001ff2:	ec26                	sd	s1,24(sp)
    80001ff4:	e84a                	sd	s2,16(sp)
    80001ff6:	e44e                	sd	s3,8(sp)
    80001ff8:	e052                	sd	s4,0(sp)
    80001ffa:	1800                	addi	s0,sp,48
    80001ffc:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001ffe:	915ff0ef          	jal	80001912 <myproc>
    80002002:	89aa                	mv	s3,a0
  if(p == initproc)
    80002004:	00008797          	auipc	a5,0x8
    80002008:	3347b783          	ld	a5,820(a5) # 8000a338 <initproc>
    8000200c:	0d050493          	addi	s1,a0,208
    80002010:	15050913          	addi	s2,a0,336
    80002014:	00a79f63          	bne	a5,a0,80002032 <exit+0x46>
    panic("init exiting");
    80002018:	00005517          	auipc	a0,0x5
    8000201c:	26850513          	addi	a0,a0,616 # 80007280 <etext+0x280>
    80002020:	f82fe0ef          	jal	800007a2 <panic>
      fileclose(f);
    80002024:	6e5010ef          	jal	80003f08 <fileclose>
      p->ofile[fd] = 0;
    80002028:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000202c:	04a1                	addi	s1,s1,8
    8000202e:	01248563          	beq	s1,s2,80002038 <exit+0x4c>
    if(p->ofile[fd]){
    80002032:	6088                	ld	a0,0(s1)
    80002034:	f965                	bnez	a0,80002024 <exit+0x38>
    80002036:	bfdd                	j	8000202c <exit+0x40>
  begin_op();
    80002038:	2b7010ef          	jal	80003aee <begin_op>
  iput(p->cwd);
    8000203c:	1509b503          	ld	a0,336(s3)
    80002040:	39a010ef          	jal	800033da <iput>
  end_op();
    80002044:	315010ef          	jal	80003b58 <end_op>
  p->cwd = 0;
    80002048:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000204c:	00010497          	auipc	s1,0x10
    80002050:	43c48493          	addi	s1,s1,1084 # 80012488 <wait_lock>
    80002054:	8526                	mv	a0,s1
    80002056:	badfe0ef          	jal	80000c02 <acquire>
  reparent(p);
    8000205a:	854e                	mv	a0,s3
    8000205c:	f3bff0ef          	jal	80001f96 <reparent>
  wakeup(p->parent);
    80002060:	0389b503          	ld	a0,56(s3)
    80002064:	ec9ff0ef          	jal	80001f2c <wakeup>
  acquire(&p->lock);
    80002068:	854e                	mv	a0,s3
    8000206a:	b99fe0ef          	jal	80000c02 <acquire>
  p->xstate = status;
    8000206e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002072:	4795                	li	a5,5
    80002074:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002078:	8526                	mv	a0,s1
    8000207a:	c21fe0ef          	jal	80000c9a <release>
  sched();
    8000207e:	d7dff0ef          	jal	80001dfa <sched>
  panic("zombie exit");
    80002082:	00005517          	auipc	a0,0x5
    80002086:	20e50513          	addi	a0,a0,526 # 80007290 <etext+0x290>
    8000208a:	f18fe0ef          	jal	800007a2 <panic>

000000008000208e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000208e:	7179                	addi	sp,sp,-48
    80002090:	f406                	sd	ra,40(sp)
    80002092:	f022                	sd	s0,32(sp)
    80002094:	ec26                	sd	s1,24(sp)
    80002096:	e84a                	sd	s2,16(sp)
    80002098:	e44e                	sd	s3,8(sp)
    8000209a:	1800                	addi	s0,sp,48
    8000209c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000209e:	00011497          	auipc	s1,0x11
    800020a2:	80248493          	addi	s1,s1,-2046 # 800128a0 <proc>
    800020a6:	00016997          	auipc	s3,0x16
    800020aa:	1fa98993          	addi	s3,s3,506 # 800182a0 <tickslock>
    acquire(&p->lock);
    800020ae:	8526                	mv	a0,s1
    800020b0:	b53fe0ef          	jal	80000c02 <acquire>
    if(p->pid == pid){
    800020b4:	589c                	lw	a5,48(s1)
    800020b6:	01278b63          	beq	a5,s2,800020cc <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800020ba:	8526                	mv	a0,s1
    800020bc:	bdffe0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800020c0:	16848493          	addi	s1,s1,360
    800020c4:	ff3495e3          	bne	s1,s3,800020ae <kill+0x20>
  }
  return -1;
    800020c8:	557d                	li	a0,-1
    800020ca:	a819                	j	800020e0 <kill+0x52>
      p->killed = 1;
    800020cc:	4785                	li	a5,1
    800020ce:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800020d0:	4c98                	lw	a4,24(s1)
    800020d2:	4789                	li	a5,2
    800020d4:	00f70d63          	beq	a4,a5,800020ee <kill+0x60>
      release(&p->lock);
    800020d8:	8526                	mv	a0,s1
    800020da:	bc1fe0ef          	jal	80000c9a <release>
      return 0;
    800020de:	4501                	li	a0,0
}
    800020e0:	70a2                	ld	ra,40(sp)
    800020e2:	7402                	ld	s0,32(sp)
    800020e4:	64e2                	ld	s1,24(sp)
    800020e6:	6942                	ld	s2,16(sp)
    800020e8:	69a2                	ld	s3,8(sp)
    800020ea:	6145                	addi	sp,sp,48
    800020ec:	8082                	ret
        p->state = RUNNABLE;
    800020ee:	478d                	li	a5,3
    800020f0:	cc9c                	sw	a5,24(s1)
    800020f2:	b7dd                	j	800020d8 <kill+0x4a>

00000000800020f4 <setkilled>:

void
setkilled(struct proc *p)
{
    800020f4:	1101                	addi	sp,sp,-32
    800020f6:	ec06                	sd	ra,24(sp)
    800020f8:	e822                	sd	s0,16(sp)
    800020fa:	e426                	sd	s1,8(sp)
    800020fc:	1000                	addi	s0,sp,32
    800020fe:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002100:	b03fe0ef          	jal	80000c02 <acquire>
  p->killed = 1;
    80002104:	4785                	li	a5,1
    80002106:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002108:	8526                	mv	a0,s1
    8000210a:	b91fe0ef          	jal	80000c9a <release>
}
    8000210e:	60e2                	ld	ra,24(sp)
    80002110:	6442                	ld	s0,16(sp)
    80002112:	64a2                	ld	s1,8(sp)
    80002114:	6105                	addi	sp,sp,32
    80002116:	8082                	ret

0000000080002118 <killed>:

int
killed(struct proc *p)
{
    80002118:	1101                	addi	sp,sp,-32
    8000211a:	ec06                	sd	ra,24(sp)
    8000211c:	e822                	sd	s0,16(sp)
    8000211e:	e426                	sd	s1,8(sp)
    80002120:	e04a                	sd	s2,0(sp)
    80002122:	1000                	addi	s0,sp,32
    80002124:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002126:	addfe0ef          	jal	80000c02 <acquire>
  k = p->killed;
    8000212a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000212e:	8526                	mv	a0,s1
    80002130:	b6bfe0ef          	jal	80000c9a <release>
  return k;
}
    80002134:	854a                	mv	a0,s2
    80002136:	60e2                	ld	ra,24(sp)
    80002138:	6442                	ld	s0,16(sp)
    8000213a:	64a2                	ld	s1,8(sp)
    8000213c:	6902                	ld	s2,0(sp)
    8000213e:	6105                	addi	sp,sp,32
    80002140:	8082                	ret

0000000080002142 <wait>:
{
    80002142:	715d                	addi	sp,sp,-80
    80002144:	e486                	sd	ra,72(sp)
    80002146:	e0a2                	sd	s0,64(sp)
    80002148:	fc26                	sd	s1,56(sp)
    8000214a:	f84a                	sd	s2,48(sp)
    8000214c:	f44e                	sd	s3,40(sp)
    8000214e:	f052                	sd	s4,32(sp)
    80002150:	ec56                	sd	s5,24(sp)
    80002152:	e85a                	sd	s6,16(sp)
    80002154:	e45e                	sd	s7,8(sp)
    80002156:	e062                	sd	s8,0(sp)
    80002158:	0880                	addi	s0,sp,80
    8000215a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000215c:	fb6ff0ef          	jal	80001912 <myproc>
    80002160:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002162:	00010517          	auipc	a0,0x10
    80002166:	32650513          	addi	a0,a0,806 # 80012488 <wait_lock>
    8000216a:	a99fe0ef          	jal	80000c02 <acquire>
    havekids = 0;
    8000216e:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002170:	4a15                	li	s4,5
        havekids = 1;
    80002172:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002174:	00016997          	auipc	s3,0x16
    80002178:	12c98993          	addi	s3,s3,300 # 800182a0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000217c:	00010c17          	auipc	s8,0x10
    80002180:	30cc0c13          	addi	s8,s8,780 # 80012488 <wait_lock>
    80002184:	a871                	j	80002220 <wait+0xde>
          pid = pp->pid;
    80002186:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000218a:	000b0c63          	beqz	s6,800021a2 <wait+0x60>
    8000218e:	4691                	li	a3,4
    80002190:	02c48613          	addi	a2,s1,44
    80002194:	85da                	mv	a1,s6
    80002196:	05093503          	ld	a0,80(s2)
    8000219a:	beaff0ef          	jal	80001584 <copyout>
    8000219e:	02054b63          	bltz	a0,800021d4 <wait+0x92>
          freeproc(pp);
    800021a2:	8526                	mv	a0,s1
    800021a4:	8e1ff0ef          	jal	80001a84 <freeproc>
          release(&pp->lock);
    800021a8:	8526                	mv	a0,s1
    800021aa:	af1fe0ef          	jal	80000c9a <release>
          release(&wait_lock);
    800021ae:	00010517          	auipc	a0,0x10
    800021b2:	2da50513          	addi	a0,a0,730 # 80012488 <wait_lock>
    800021b6:	ae5fe0ef          	jal	80000c9a <release>
}
    800021ba:	854e                	mv	a0,s3
    800021bc:	60a6                	ld	ra,72(sp)
    800021be:	6406                	ld	s0,64(sp)
    800021c0:	74e2                	ld	s1,56(sp)
    800021c2:	7942                	ld	s2,48(sp)
    800021c4:	79a2                	ld	s3,40(sp)
    800021c6:	7a02                	ld	s4,32(sp)
    800021c8:	6ae2                	ld	s5,24(sp)
    800021ca:	6b42                	ld	s6,16(sp)
    800021cc:	6ba2                	ld	s7,8(sp)
    800021ce:	6c02                	ld	s8,0(sp)
    800021d0:	6161                	addi	sp,sp,80
    800021d2:	8082                	ret
            release(&pp->lock);
    800021d4:	8526                	mv	a0,s1
    800021d6:	ac5fe0ef          	jal	80000c9a <release>
            release(&wait_lock);
    800021da:	00010517          	auipc	a0,0x10
    800021de:	2ae50513          	addi	a0,a0,686 # 80012488 <wait_lock>
    800021e2:	ab9fe0ef          	jal	80000c9a <release>
            return -1;
    800021e6:	59fd                	li	s3,-1
    800021e8:	bfc9                	j	800021ba <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021ea:	16848493          	addi	s1,s1,360
    800021ee:	03348063          	beq	s1,s3,8000220e <wait+0xcc>
      if(pp->parent == p){
    800021f2:	7c9c                	ld	a5,56(s1)
    800021f4:	ff279be3          	bne	a5,s2,800021ea <wait+0xa8>
        acquire(&pp->lock);
    800021f8:	8526                	mv	a0,s1
    800021fa:	a09fe0ef          	jal	80000c02 <acquire>
        if(pp->state == ZOMBIE){
    800021fe:	4c9c                	lw	a5,24(s1)
    80002200:	f94783e3          	beq	a5,s4,80002186 <wait+0x44>
        release(&pp->lock);
    80002204:	8526                	mv	a0,s1
    80002206:	a95fe0ef          	jal	80000c9a <release>
        havekids = 1;
    8000220a:	8756                	mv	a4,s5
    8000220c:	bff9                	j	800021ea <wait+0xa8>
    if(!havekids || killed(p)){
    8000220e:	cf19                	beqz	a4,8000222c <wait+0xea>
    80002210:	854a                	mv	a0,s2
    80002212:	f07ff0ef          	jal	80002118 <killed>
    80002216:	e919                	bnez	a0,8000222c <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002218:	85e2                	mv	a1,s8
    8000221a:	854a                	mv	a0,s2
    8000221c:	cc5ff0ef          	jal	80001ee0 <sleep>
    havekids = 0;
    80002220:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002222:	00010497          	auipc	s1,0x10
    80002226:	67e48493          	addi	s1,s1,1662 # 800128a0 <proc>
    8000222a:	b7e1                	j	800021f2 <wait+0xb0>
      release(&wait_lock);
    8000222c:	00010517          	auipc	a0,0x10
    80002230:	25c50513          	addi	a0,a0,604 # 80012488 <wait_lock>
    80002234:	a67fe0ef          	jal	80000c9a <release>
      return -1;
    80002238:	59fd                	li	s3,-1
    8000223a:	b741                	j	800021ba <wait+0x78>

000000008000223c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000223c:	7179                	addi	sp,sp,-48
    8000223e:	f406                	sd	ra,40(sp)
    80002240:	f022                	sd	s0,32(sp)
    80002242:	ec26                	sd	s1,24(sp)
    80002244:	e84a                	sd	s2,16(sp)
    80002246:	e44e                	sd	s3,8(sp)
    80002248:	e052                	sd	s4,0(sp)
    8000224a:	1800                	addi	s0,sp,48
    8000224c:	84aa                	mv	s1,a0
    8000224e:	892e                	mv	s2,a1
    80002250:	89b2                	mv	s3,a2
    80002252:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002254:	ebeff0ef          	jal	80001912 <myproc>
  if(user_dst){
    80002258:	cc99                	beqz	s1,80002276 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000225a:	86d2                	mv	a3,s4
    8000225c:	864e                	mv	a2,s3
    8000225e:	85ca                	mv	a1,s2
    80002260:	6928                	ld	a0,80(a0)
    80002262:	b22ff0ef          	jal	80001584 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002266:	70a2                	ld	ra,40(sp)
    80002268:	7402                	ld	s0,32(sp)
    8000226a:	64e2                	ld	s1,24(sp)
    8000226c:	6942                	ld	s2,16(sp)
    8000226e:	69a2                	ld	s3,8(sp)
    80002270:	6a02                	ld	s4,0(sp)
    80002272:	6145                	addi	sp,sp,48
    80002274:	8082                	ret
    memmove((char *)dst, src, len);
    80002276:	000a061b          	sext.w	a2,s4
    8000227a:	85ce                	mv	a1,s3
    8000227c:	854a                	mv	a0,s2
    8000227e:	ab5fe0ef          	jal	80000d32 <memmove>
    return 0;
    80002282:	8526                	mv	a0,s1
    80002284:	b7cd                	j	80002266 <either_copyout+0x2a>

0000000080002286 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002286:	7179                	addi	sp,sp,-48
    80002288:	f406                	sd	ra,40(sp)
    8000228a:	f022                	sd	s0,32(sp)
    8000228c:	ec26                	sd	s1,24(sp)
    8000228e:	e84a                	sd	s2,16(sp)
    80002290:	e44e                	sd	s3,8(sp)
    80002292:	e052                	sd	s4,0(sp)
    80002294:	1800                	addi	s0,sp,48
    80002296:	892a                	mv	s2,a0
    80002298:	84ae                	mv	s1,a1
    8000229a:	89b2                	mv	s3,a2
    8000229c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000229e:	e74ff0ef          	jal	80001912 <myproc>
  if(user_src){
    800022a2:	cc99                	beqz	s1,800022c0 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800022a4:	86d2                	mv	a3,s4
    800022a6:	864e                	mv	a2,s3
    800022a8:	85ca                	mv	a1,s2
    800022aa:	6928                	ld	a0,80(a0)
    800022ac:	baeff0ef          	jal	8000165a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800022b0:	70a2                	ld	ra,40(sp)
    800022b2:	7402                	ld	s0,32(sp)
    800022b4:	64e2                	ld	s1,24(sp)
    800022b6:	6942                	ld	s2,16(sp)
    800022b8:	69a2                	ld	s3,8(sp)
    800022ba:	6a02                	ld	s4,0(sp)
    800022bc:	6145                	addi	sp,sp,48
    800022be:	8082                	ret
    memmove(dst, (char*)src, len);
    800022c0:	000a061b          	sext.w	a2,s4
    800022c4:	85ce                	mv	a1,s3
    800022c6:	854a                	mv	a0,s2
    800022c8:	a6bfe0ef          	jal	80000d32 <memmove>
    return 0;
    800022cc:	8526                	mv	a0,s1
    800022ce:	b7cd                	j	800022b0 <either_copyin+0x2a>

00000000800022d0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800022d0:	715d                	addi	sp,sp,-80
    800022d2:	e486                	sd	ra,72(sp)
    800022d4:	e0a2                	sd	s0,64(sp)
    800022d6:	fc26                	sd	s1,56(sp)
    800022d8:	f84a                	sd	s2,48(sp)
    800022da:	f44e                	sd	s3,40(sp)
    800022dc:	f052                	sd	s4,32(sp)
    800022de:	ec56                	sd	s5,24(sp)
    800022e0:	e85a                	sd	s6,16(sp)
    800022e2:	e45e                	sd	s7,8(sp)
    800022e4:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800022e6:	00005517          	auipc	a0,0x5
    800022ea:	d9250513          	addi	a0,a0,-622 # 80007078 <etext+0x78>
    800022ee:	9e2fe0ef          	jal	800004d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800022f2:	00010497          	auipc	s1,0x10
    800022f6:	70648493          	addi	s1,s1,1798 # 800129f8 <proc+0x158>
    800022fa:	00016917          	auipc	s2,0x16
    800022fe:	0fe90913          	addi	s2,s2,254 # 800183f8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002302:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002304:	00005997          	auipc	s3,0x5
    80002308:	f9c98993          	addi	s3,s3,-100 # 800072a0 <etext+0x2a0>
    printf("%d %s %s", p->pid, state, p->name);
    8000230c:	00005a97          	auipc	s5,0x5
    80002310:	f9ca8a93          	addi	s5,s5,-100 # 800072a8 <etext+0x2a8>
    printf("\n");
    80002314:	00005a17          	auipc	s4,0x5
    80002318:	d64a0a13          	addi	s4,s4,-668 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000231c:	00005b97          	auipc	s7,0x5
    80002320:	47cb8b93          	addi	s7,s7,1148 # 80007798 <states.0>
    80002324:	a829                	j	8000233e <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002326:	ed86a583          	lw	a1,-296(a3)
    8000232a:	8556                	mv	a0,s5
    8000232c:	9a4fe0ef          	jal	800004d0 <printf>
    printf("\n");
    80002330:	8552                	mv	a0,s4
    80002332:	99efe0ef          	jal	800004d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002336:	16848493          	addi	s1,s1,360
    8000233a:	03248263          	beq	s1,s2,8000235e <procdump+0x8e>
    if(p->state == UNUSED)
    8000233e:	86a6                	mv	a3,s1
    80002340:	ec04a783          	lw	a5,-320(s1)
    80002344:	dbed                	beqz	a5,80002336 <procdump+0x66>
      state = "???";
    80002346:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002348:	fcfb6fe3          	bltu	s6,a5,80002326 <procdump+0x56>
    8000234c:	02079713          	slli	a4,a5,0x20
    80002350:	01d75793          	srli	a5,a4,0x1d
    80002354:	97de                	add	a5,a5,s7
    80002356:	6390                	ld	a2,0(a5)
    80002358:	f679                	bnez	a2,80002326 <procdump+0x56>
      state = "???";
    8000235a:	864e                	mv	a2,s3
    8000235c:	b7e9                	j	80002326 <procdump+0x56>
  }
}
    8000235e:	60a6                	ld	ra,72(sp)
    80002360:	6406                	ld	s0,64(sp)
    80002362:	74e2                	ld	s1,56(sp)
    80002364:	7942                	ld	s2,48(sp)
    80002366:	79a2                	ld	s3,40(sp)
    80002368:	7a02                	ld	s4,32(sp)
    8000236a:	6ae2                	ld	s5,24(sp)
    8000236c:	6b42                	ld	s6,16(sp)
    8000236e:	6ba2                	ld	s7,8(sp)
    80002370:	6161                	addi	sp,sp,80
    80002372:	8082                	ret

0000000080002374 <swtch>:
    80002374:	00153023          	sd	ra,0(a0)
    80002378:	00253423          	sd	sp,8(a0)
    8000237c:	e900                	sd	s0,16(a0)
    8000237e:	ed04                	sd	s1,24(a0)
    80002380:	03253023          	sd	s2,32(a0)
    80002384:	03353423          	sd	s3,40(a0)
    80002388:	03453823          	sd	s4,48(a0)
    8000238c:	03553c23          	sd	s5,56(a0)
    80002390:	05653023          	sd	s6,64(a0)
    80002394:	05753423          	sd	s7,72(a0)
    80002398:	05853823          	sd	s8,80(a0)
    8000239c:	05953c23          	sd	s9,88(a0)
    800023a0:	07a53023          	sd	s10,96(a0)
    800023a4:	07b53423          	sd	s11,104(a0)
    800023a8:	0005b083          	ld	ra,0(a1)
    800023ac:	0085b103          	ld	sp,8(a1)
    800023b0:	6980                	ld	s0,16(a1)
    800023b2:	6d84                	ld	s1,24(a1)
    800023b4:	0205b903          	ld	s2,32(a1)
    800023b8:	0285b983          	ld	s3,40(a1)
    800023bc:	0305ba03          	ld	s4,48(a1)
    800023c0:	0385ba83          	ld	s5,56(a1)
    800023c4:	0405bb03          	ld	s6,64(a1)
    800023c8:	0485bb83          	ld	s7,72(a1)
    800023cc:	0505bc03          	ld	s8,80(a1)
    800023d0:	0585bc83          	ld	s9,88(a1)
    800023d4:	0605bd03          	ld	s10,96(a1)
    800023d8:	0685bd83          	ld	s11,104(a1)
    800023dc:	8082                	ret

00000000800023de <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800023de:	1141                	addi	sp,sp,-16
    800023e0:	e406                	sd	ra,8(sp)
    800023e2:	e022                	sd	s0,0(sp)
    800023e4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800023e6:	00005597          	auipc	a1,0x5
    800023ea:	f0258593          	addi	a1,a1,-254 # 800072e8 <etext+0x2e8>
    800023ee:	00016517          	auipc	a0,0x16
    800023f2:	eb250513          	addi	a0,a0,-334 # 800182a0 <tickslock>
    800023f6:	f8cfe0ef          	jal	80000b82 <initlock>
}
    800023fa:	60a2                	ld	ra,8(sp)
    800023fc:	6402                	ld	s0,0(sp)
    800023fe:	0141                	addi	sp,sp,16
    80002400:	8082                	ret

0000000080002402 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002402:	1141                	addi	sp,sp,-16
    80002404:	e422                	sd	s0,8(sp)
    80002406:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002408:	00003797          	auipc	a5,0x3
    8000240c:	e6878793          	addi	a5,a5,-408 # 80005270 <kernelvec>
    80002410:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002414:	6422                	ld	s0,8(sp)
    80002416:	0141                	addi	sp,sp,16
    80002418:	8082                	ret

000000008000241a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000241a:	1141                	addi	sp,sp,-16
    8000241c:	e406                	sd	ra,8(sp)
    8000241e:	e022                	sd	s0,0(sp)
    80002420:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002422:	cf0ff0ef          	jal	80001912 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002426:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000242a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000242c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002430:	00004697          	auipc	a3,0x4
    80002434:	bd068693          	addi	a3,a3,-1072 # 80006000 <_trampoline>
    80002438:	00004717          	auipc	a4,0x4
    8000243c:	bc870713          	addi	a4,a4,-1080 # 80006000 <_trampoline>
    80002440:	8f15                	sub	a4,a4,a3
    80002442:	040007b7          	lui	a5,0x4000
    80002446:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002448:	07b2                	slli	a5,a5,0xc
    8000244a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000244c:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002450:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002452:	18002673          	csrr	a2,satp
    80002456:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002458:	6d30                	ld	a2,88(a0)
    8000245a:	6138                	ld	a4,64(a0)
    8000245c:	6585                	lui	a1,0x1
    8000245e:	972e                	add	a4,a4,a1
    80002460:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002462:	6d38                	ld	a4,88(a0)
    80002464:	00000617          	auipc	a2,0x0
    80002468:	11060613          	addi	a2,a2,272 # 80002574 <usertrap>
    8000246c:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000246e:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002470:	8612                	mv	a2,tp
    80002472:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002474:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002478:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000247c:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002480:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002484:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002486:	6f18                	ld	a4,24(a4)
    80002488:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000248c:	6928                	ld	a0,80(a0)
    8000248e:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002490:	00004717          	auipc	a4,0x4
    80002494:	c0c70713          	addi	a4,a4,-1012 # 8000609c <userret>
    80002498:	8f15                	sub	a4,a4,a3
    8000249a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000249c:	577d                	li	a4,-1
    8000249e:	177e                	slli	a4,a4,0x3f
    800024a0:	8d59                	or	a0,a0,a4
    800024a2:	9782                	jalr	a5
}
    800024a4:	60a2                	ld	ra,8(sp)
    800024a6:	6402                	ld	s0,0(sp)
    800024a8:	0141                	addi	sp,sp,16
    800024aa:	8082                	ret

00000000800024ac <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800024ac:	1101                	addi	sp,sp,-32
    800024ae:	ec06                	sd	ra,24(sp)
    800024b0:	e822                	sd	s0,16(sp)
    800024b2:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800024b4:	c32ff0ef          	jal	800018e6 <cpuid>
    800024b8:	cd11                	beqz	a0,800024d4 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800024ba:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800024be:	000f4737          	lui	a4,0xf4
    800024c2:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800024c6:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800024c8:	14d79073          	csrw	stimecmp,a5
}
    800024cc:	60e2                	ld	ra,24(sp)
    800024ce:	6442                	ld	s0,16(sp)
    800024d0:	6105                	addi	sp,sp,32
    800024d2:	8082                	ret
    800024d4:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800024d6:	00016497          	auipc	s1,0x16
    800024da:	dca48493          	addi	s1,s1,-566 # 800182a0 <tickslock>
    800024de:	8526                	mv	a0,s1
    800024e0:	f22fe0ef          	jal	80000c02 <acquire>
    ticks++;
    800024e4:	00008517          	auipc	a0,0x8
    800024e8:	e5c50513          	addi	a0,a0,-420 # 8000a340 <ticks>
    800024ec:	411c                	lw	a5,0(a0)
    800024ee:	2785                	addiw	a5,a5,1
    800024f0:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800024f2:	a3bff0ef          	jal	80001f2c <wakeup>
    release(&tickslock);
    800024f6:	8526                	mv	a0,s1
    800024f8:	fa2fe0ef          	jal	80000c9a <release>
    800024fc:	64a2                	ld	s1,8(sp)
    800024fe:	bf75                	j	800024ba <clockintr+0xe>

0000000080002500 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002500:	1101                	addi	sp,sp,-32
    80002502:	ec06                	sd	ra,24(sp)
    80002504:	e822                	sd	s0,16(sp)
    80002506:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002508:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    8000250c:	57fd                	li	a5,-1
    8000250e:	17fe                	slli	a5,a5,0x3f
    80002510:	07a5                	addi	a5,a5,9
    80002512:	00f70c63          	beq	a4,a5,8000252a <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002516:	57fd                	li	a5,-1
    80002518:	17fe                	slli	a5,a5,0x3f
    8000251a:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000251c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000251e:	04f70763          	beq	a4,a5,8000256c <devintr+0x6c>
  }
}
    80002522:	60e2                	ld	ra,24(sp)
    80002524:	6442                	ld	s0,16(sp)
    80002526:	6105                	addi	sp,sp,32
    80002528:	8082                	ret
    8000252a:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    8000252c:	5f1020ef          	jal	8000531c <plic_claim>
    80002530:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002532:	47a9                	li	a5,10
    80002534:	00f50963          	beq	a0,a5,80002546 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80002538:	4785                	li	a5,1
    8000253a:	00f50963          	beq	a0,a5,8000254c <devintr+0x4c>
    return 1;
    8000253e:	4505                	li	a0,1
    } else if(irq){
    80002540:	e889                	bnez	s1,80002552 <devintr+0x52>
    80002542:	64a2                	ld	s1,8(sp)
    80002544:	bff9                	j	80002522 <devintr+0x22>
      uartintr();
    80002546:	ccefe0ef          	jal	80000a14 <uartintr>
    if(irq)
    8000254a:	a819                	j	80002560 <devintr+0x60>
      virtio_disk_intr();
    8000254c:	296030ef          	jal	800057e2 <virtio_disk_intr>
    if(irq)
    80002550:	a801                	j	80002560 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80002552:	85a6                	mv	a1,s1
    80002554:	00005517          	auipc	a0,0x5
    80002558:	d9c50513          	addi	a0,a0,-612 # 800072f0 <etext+0x2f0>
    8000255c:	f75fd0ef          	jal	800004d0 <printf>
      plic_complete(irq);
    80002560:	8526                	mv	a0,s1
    80002562:	5db020ef          	jal	8000533c <plic_complete>
    return 1;
    80002566:	4505                	li	a0,1
    80002568:	64a2                	ld	s1,8(sp)
    8000256a:	bf65                	j	80002522 <devintr+0x22>
    clockintr();
    8000256c:	f41ff0ef          	jal	800024ac <clockintr>
    return 2;
    80002570:	4509                	li	a0,2
    80002572:	bf45                	j	80002522 <devintr+0x22>

0000000080002574 <usertrap>:
{
    80002574:	1101                	addi	sp,sp,-32
    80002576:	ec06                	sd	ra,24(sp)
    80002578:	e822                	sd	s0,16(sp)
    8000257a:	e426                	sd	s1,8(sp)
    8000257c:	e04a                	sd	s2,0(sp)
    8000257e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002580:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002584:	1007f793          	andi	a5,a5,256
    80002588:	ef85                	bnez	a5,800025c0 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000258a:	00003797          	auipc	a5,0x3
    8000258e:	ce678793          	addi	a5,a5,-794 # 80005270 <kernelvec>
    80002592:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002596:	b7cff0ef          	jal	80001912 <myproc>
    8000259a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000259c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000259e:	14102773          	csrr	a4,sepc
    800025a2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800025a4:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800025a8:	47a1                	li	a5,8
    800025aa:	02f70163          	beq	a4,a5,800025cc <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800025ae:	f53ff0ef          	jal	80002500 <devintr>
    800025b2:	892a                	mv	s2,a0
    800025b4:	c135                	beqz	a0,80002618 <usertrap+0xa4>
  if(killed(p))
    800025b6:	8526                	mv	a0,s1
    800025b8:	b61ff0ef          	jal	80002118 <killed>
    800025bc:	cd1d                	beqz	a0,800025fa <usertrap+0x86>
    800025be:	a81d                	j	800025f4 <usertrap+0x80>
    panic("usertrap: not from user mode");
    800025c0:	00005517          	auipc	a0,0x5
    800025c4:	d5050513          	addi	a0,a0,-688 # 80007310 <etext+0x310>
    800025c8:	9dafe0ef          	jal	800007a2 <panic>
    if(killed(p))
    800025cc:	b4dff0ef          	jal	80002118 <killed>
    800025d0:	e121                	bnez	a0,80002610 <usertrap+0x9c>
    p->trapframe->epc += 4;
    800025d2:	6cb8                	ld	a4,88(s1)
    800025d4:	6f1c                	ld	a5,24(a4)
    800025d6:	0791                	addi	a5,a5,4
    800025d8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025da:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800025de:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025e2:	10079073          	csrw	sstatus,a5
    syscall();
    800025e6:	24a000ef          	jal	80002830 <syscall>
  if(killed(p))
    800025ea:	8526                	mv	a0,s1
    800025ec:	b2dff0ef          	jal	80002118 <killed>
    800025f0:	c901                	beqz	a0,80002600 <usertrap+0x8c>
    800025f2:	4901                	li	s2,0
    exit(-1);
    800025f4:	557d                	li	a0,-1
    800025f6:	9f7ff0ef          	jal	80001fec <exit>
  if(which_dev == 2)
    800025fa:	4789                	li	a5,2
    800025fc:	04f90563          	beq	s2,a5,80002646 <usertrap+0xd2>
  usertrapret();
    80002600:	e1bff0ef          	jal	8000241a <usertrapret>
}
    80002604:	60e2                	ld	ra,24(sp)
    80002606:	6442                	ld	s0,16(sp)
    80002608:	64a2                	ld	s1,8(sp)
    8000260a:	6902                	ld	s2,0(sp)
    8000260c:	6105                	addi	sp,sp,32
    8000260e:	8082                	ret
      exit(-1);
    80002610:	557d                	li	a0,-1
    80002612:	9dbff0ef          	jal	80001fec <exit>
    80002616:	bf75                	j	800025d2 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002618:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000261c:	5890                	lw	a2,48(s1)
    8000261e:	00005517          	auipc	a0,0x5
    80002622:	d1250513          	addi	a0,a0,-750 # 80007330 <etext+0x330>
    80002626:	eabfd0ef          	jal	800004d0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000262a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000262e:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002632:	00005517          	auipc	a0,0x5
    80002636:	d2e50513          	addi	a0,a0,-722 # 80007360 <etext+0x360>
    8000263a:	e97fd0ef          	jal	800004d0 <printf>
    setkilled(p);
    8000263e:	8526                	mv	a0,s1
    80002640:	ab5ff0ef          	jal	800020f4 <setkilled>
    80002644:	b75d                	j	800025ea <usertrap+0x76>
    yield();
    80002646:	86fff0ef          	jal	80001eb4 <yield>
    8000264a:	bf5d                	j	80002600 <usertrap+0x8c>

000000008000264c <kerneltrap>:
{
    8000264c:	7179                	addi	sp,sp,-48
    8000264e:	f406                	sd	ra,40(sp)
    80002650:	f022                	sd	s0,32(sp)
    80002652:	ec26                	sd	s1,24(sp)
    80002654:	e84a                	sd	s2,16(sp)
    80002656:	e44e                	sd	s3,8(sp)
    80002658:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000265a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000265e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002662:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002666:	1004f793          	andi	a5,s1,256
    8000266a:	c795                	beqz	a5,80002696 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000266c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002670:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002672:	eb85                	bnez	a5,800026a2 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002674:	e8dff0ef          	jal	80002500 <devintr>
    80002678:	c91d                	beqz	a0,800026ae <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    8000267a:	4789                	li	a5,2
    8000267c:	04f50a63          	beq	a0,a5,800026d0 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002680:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002684:	10049073          	csrw	sstatus,s1
}
    80002688:	70a2                	ld	ra,40(sp)
    8000268a:	7402                	ld	s0,32(sp)
    8000268c:	64e2                	ld	s1,24(sp)
    8000268e:	6942                	ld	s2,16(sp)
    80002690:	69a2                	ld	s3,8(sp)
    80002692:	6145                	addi	sp,sp,48
    80002694:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002696:	00005517          	auipc	a0,0x5
    8000269a:	cf250513          	addi	a0,a0,-782 # 80007388 <etext+0x388>
    8000269e:	904fe0ef          	jal	800007a2 <panic>
    panic("kerneltrap: interrupts enabled");
    800026a2:	00005517          	auipc	a0,0x5
    800026a6:	d0e50513          	addi	a0,a0,-754 # 800073b0 <etext+0x3b0>
    800026aa:	8f8fe0ef          	jal	800007a2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026ae:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800026b2:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800026b6:	85ce                	mv	a1,s3
    800026b8:	00005517          	auipc	a0,0x5
    800026bc:	d1850513          	addi	a0,a0,-744 # 800073d0 <etext+0x3d0>
    800026c0:	e11fd0ef          	jal	800004d0 <printf>
    panic("kerneltrap");
    800026c4:	00005517          	auipc	a0,0x5
    800026c8:	d3450513          	addi	a0,a0,-716 # 800073f8 <etext+0x3f8>
    800026cc:	8d6fe0ef          	jal	800007a2 <panic>
  if(which_dev == 2 && myproc() != 0)
    800026d0:	a42ff0ef          	jal	80001912 <myproc>
    800026d4:	d555                	beqz	a0,80002680 <kerneltrap+0x34>
    yield();
    800026d6:	fdeff0ef          	jal	80001eb4 <yield>
    800026da:	b75d                	j	80002680 <kerneltrap+0x34>

00000000800026dc <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800026dc:	1101                	addi	sp,sp,-32
    800026de:	ec06                	sd	ra,24(sp)
    800026e0:	e822                	sd	s0,16(sp)
    800026e2:	e426                	sd	s1,8(sp)
    800026e4:	1000                	addi	s0,sp,32
    800026e6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800026e8:	a2aff0ef          	jal	80001912 <myproc>
  switch (n) {
    800026ec:	4795                	li	a5,5
    800026ee:	0497e163          	bltu	a5,s1,80002730 <argraw+0x54>
    800026f2:	048a                	slli	s1,s1,0x2
    800026f4:	00005717          	auipc	a4,0x5
    800026f8:	0d470713          	addi	a4,a4,212 # 800077c8 <states.0+0x30>
    800026fc:	94ba                	add	s1,s1,a4
    800026fe:	409c                	lw	a5,0(s1)
    80002700:	97ba                	add	a5,a5,a4
    80002702:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002704:	6d3c                	ld	a5,88(a0)
    80002706:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002708:	60e2                	ld	ra,24(sp)
    8000270a:	6442                	ld	s0,16(sp)
    8000270c:	64a2                	ld	s1,8(sp)
    8000270e:	6105                	addi	sp,sp,32
    80002710:	8082                	ret
    return p->trapframe->a1;
    80002712:	6d3c                	ld	a5,88(a0)
    80002714:	7fa8                	ld	a0,120(a5)
    80002716:	bfcd                	j	80002708 <argraw+0x2c>
    return p->trapframe->a2;
    80002718:	6d3c                	ld	a5,88(a0)
    8000271a:	63c8                	ld	a0,128(a5)
    8000271c:	b7f5                	j	80002708 <argraw+0x2c>
    return p->trapframe->a3;
    8000271e:	6d3c                	ld	a5,88(a0)
    80002720:	67c8                	ld	a0,136(a5)
    80002722:	b7dd                	j	80002708 <argraw+0x2c>
    return p->trapframe->a4;
    80002724:	6d3c                	ld	a5,88(a0)
    80002726:	6bc8                	ld	a0,144(a5)
    80002728:	b7c5                	j	80002708 <argraw+0x2c>
    return p->trapframe->a5;
    8000272a:	6d3c                	ld	a5,88(a0)
    8000272c:	6fc8                	ld	a0,152(a5)
    8000272e:	bfe9                	j	80002708 <argraw+0x2c>
  panic("argraw");
    80002730:	00005517          	auipc	a0,0x5
    80002734:	cd850513          	addi	a0,a0,-808 # 80007408 <etext+0x408>
    80002738:	86afe0ef          	jal	800007a2 <panic>

000000008000273c <fetchaddr>:
{
    8000273c:	1101                	addi	sp,sp,-32
    8000273e:	ec06                	sd	ra,24(sp)
    80002740:	e822                	sd	s0,16(sp)
    80002742:	e426                	sd	s1,8(sp)
    80002744:	e04a                	sd	s2,0(sp)
    80002746:	1000                	addi	s0,sp,32
    80002748:	84aa                	mv	s1,a0
    8000274a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000274c:	9c6ff0ef          	jal	80001912 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002750:	653c                	ld	a5,72(a0)
    80002752:	02f4f663          	bgeu	s1,a5,8000277e <fetchaddr+0x42>
    80002756:	00848713          	addi	a4,s1,8
    8000275a:	02e7e463          	bltu	a5,a4,80002782 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000275e:	46a1                	li	a3,8
    80002760:	8626                	mv	a2,s1
    80002762:	85ca                	mv	a1,s2
    80002764:	6928                	ld	a0,80(a0)
    80002766:	ef5fe0ef          	jal	8000165a <copyin>
    8000276a:	00a03533          	snez	a0,a0
    8000276e:	40a00533          	neg	a0,a0
}
    80002772:	60e2                	ld	ra,24(sp)
    80002774:	6442                	ld	s0,16(sp)
    80002776:	64a2                	ld	s1,8(sp)
    80002778:	6902                	ld	s2,0(sp)
    8000277a:	6105                	addi	sp,sp,32
    8000277c:	8082                	ret
    return -1;
    8000277e:	557d                	li	a0,-1
    80002780:	bfcd                	j	80002772 <fetchaddr+0x36>
    80002782:	557d                	li	a0,-1
    80002784:	b7fd                	j	80002772 <fetchaddr+0x36>

0000000080002786 <fetchstr>:
{
    80002786:	7179                	addi	sp,sp,-48
    80002788:	f406                	sd	ra,40(sp)
    8000278a:	f022                	sd	s0,32(sp)
    8000278c:	ec26                	sd	s1,24(sp)
    8000278e:	e84a                	sd	s2,16(sp)
    80002790:	e44e                	sd	s3,8(sp)
    80002792:	1800                	addi	s0,sp,48
    80002794:	892a                	mv	s2,a0
    80002796:	84ae                	mv	s1,a1
    80002798:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000279a:	978ff0ef          	jal	80001912 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000279e:	86ce                	mv	a3,s3
    800027a0:	864a                	mv	a2,s2
    800027a2:	85a6                	mv	a1,s1
    800027a4:	6928                	ld	a0,80(a0)
    800027a6:	f3bfe0ef          	jal	800016e0 <copyinstr>
    800027aa:	00054c63          	bltz	a0,800027c2 <fetchstr+0x3c>
  return strlen(buf);
    800027ae:	8526                	mv	a0,s1
    800027b0:	e96fe0ef          	jal	80000e46 <strlen>
}
    800027b4:	70a2                	ld	ra,40(sp)
    800027b6:	7402                	ld	s0,32(sp)
    800027b8:	64e2                	ld	s1,24(sp)
    800027ba:	6942                	ld	s2,16(sp)
    800027bc:	69a2                	ld	s3,8(sp)
    800027be:	6145                	addi	sp,sp,48
    800027c0:	8082                	ret
    return -1;
    800027c2:	557d                	li	a0,-1
    800027c4:	bfc5                	j	800027b4 <fetchstr+0x2e>

00000000800027c6 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800027c6:	1101                	addi	sp,sp,-32
    800027c8:	ec06                	sd	ra,24(sp)
    800027ca:	e822                	sd	s0,16(sp)
    800027cc:	e426                	sd	s1,8(sp)
    800027ce:	1000                	addi	s0,sp,32
    800027d0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027d2:	f0bff0ef          	jal	800026dc <argraw>
    800027d6:	c088                	sw	a0,0(s1)
}
    800027d8:	60e2                	ld	ra,24(sp)
    800027da:	6442                	ld	s0,16(sp)
    800027dc:	64a2                	ld	s1,8(sp)
    800027de:	6105                	addi	sp,sp,32
    800027e0:	8082                	ret

00000000800027e2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800027e2:	1101                	addi	sp,sp,-32
    800027e4:	ec06                	sd	ra,24(sp)
    800027e6:	e822                	sd	s0,16(sp)
    800027e8:	e426                	sd	s1,8(sp)
    800027ea:	1000                	addi	s0,sp,32
    800027ec:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027ee:	eefff0ef          	jal	800026dc <argraw>
    800027f2:	e088                	sd	a0,0(s1)
  return 0;
}
    800027f4:	4501                	li	a0,0
    800027f6:	60e2                	ld	ra,24(sp)
    800027f8:	6442                	ld	s0,16(sp)
    800027fa:	64a2                	ld	s1,8(sp)
    800027fc:	6105                	addi	sp,sp,32
    800027fe:	8082                	ret

0000000080002800 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002800:	7179                	addi	sp,sp,-48
    80002802:	f406                	sd	ra,40(sp)
    80002804:	f022                	sd	s0,32(sp)
    80002806:	ec26                	sd	s1,24(sp)
    80002808:	e84a                	sd	s2,16(sp)
    8000280a:	1800                	addi	s0,sp,48
    8000280c:	84ae                	mv	s1,a1
    8000280e:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002810:	fd840593          	addi	a1,s0,-40
    80002814:	fcfff0ef          	jal	800027e2 <argaddr>
  return fetchstr(addr, buf, max);
    80002818:	864a                	mv	a2,s2
    8000281a:	85a6                	mv	a1,s1
    8000281c:	fd843503          	ld	a0,-40(s0)
    80002820:	f67ff0ef          	jal	80002786 <fetchstr>
}
    80002824:	70a2                	ld	ra,40(sp)
    80002826:	7402                	ld	s0,32(sp)
    80002828:	64e2                	ld	s1,24(sp)
    8000282a:	6942                	ld	s2,16(sp)
    8000282c:	6145                	addi	sp,sp,48
    8000282e:	8082                	ret

0000000080002830 <syscall>:
[SYS_datetime] sys_datetime,
};

void
syscall(void)
{
    80002830:	1101                	addi	sp,sp,-32
    80002832:	ec06                	sd	ra,24(sp)
    80002834:	e822                	sd	s0,16(sp)
    80002836:	e426                	sd	s1,8(sp)
    80002838:	e04a                	sd	s2,0(sp)
    8000283a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000283c:	8d6ff0ef          	jal	80001912 <myproc>
    80002840:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002842:	05853903          	ld	s2,88(a0)
    80002846:	0a893783          	ld	a5,168(s2)
    8000284a:	0007869b          	sext.w	a3,a5
  syscall_count++; 
    8000284e:	00008617          	auipc	a2,0x8
    80002852:	afa60613          	addi	a2,a2,-1286 # 8000a348 <syscall_count>
    80002856:	6218                	ld	a4,0(a2)
    80002858:	0705                	addi	a4,a4,1
    8000285a:	e218                	sd	a4,0(a2)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000285c:	37fd                	addiw	a5,a5,-1
    8000285e:	4769                	li	a4,26
    80002860:	00f76f63          	bltu	a4,a5,8000287e <syscall+0x4e>
    80002864:	00369713          	slli	a4,a3,0x3
    80002868:	00005797          	auipc	a5,0x5
    8000286c:	f7878793          	addi	a5,a5,-136 # 800077e0 <syscalls>
    80002870:	97ba                	add	a5,a5,a4
    80002872:	639c                	ld	a5,0(a5)
    80002874:	c789                	beqz	a5,8000287e <syscall+0x4e>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002876:	9782                	jalr	a5
    80002878:	06a93823          	sd	a0,112(s2)
    8000287c:	a829                	j	80002896 <syscall+0x66>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000287e:	15848613          	addi	a2,s1,344
    80002882:	588c                	lw	a1,48(s1)
    80002884:	00005517          	auipc	a0,0x5
    80002888:	b8c50513          	addi	a0,a0,-1140 # 80007410 <etext+0x410>
    8000288c:	c45fd0ef          	jal	800004d0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002890:	6cbc                	ld	a5,88(s1)
    80002892:	577d                	li	a4,-1
    80002894:	fbb8                	sd	a4,112(a5)
  }
}
    80002896:	60e2                	ld	ra,24(sp)
    80002898:	6442                	ld	s0,16(sp)
    8000289a:	64a2                	ld	s1,8(sp)
    8000289c:	6902                	ld	s2,0(sp)
    8000289e:	6105                	addi	sp,sp,32
    800028a0:	8082                	ret

00000000800028a2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800028a2:	1101                	addi	sp,sp,-32
    800028a4:	ec06                	sd	ra,24(sp)
    800028a6:	e822                	sd	s0,16(sp)
    800028a8:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800028aa:	fec40593          	addi	a1,s0,-20
    800028ae:	4501                	li	a0,0
    800028b0:	f17ff0ef          	jal	800027c6 <argint>
  exit(n);
    800028b4:	fec42503          	lw	a0,-20(s0)
    800028b8:	f34ff0ef          	jal	80001fec <exit>
  return 0;  // not reached
}
    800028bc:	4501                	li	a0,0
    800028be:	60e2                	ld	ra,24(sp)
    800028c0:	6442                	ld	s0,16(sp)
    800028c2:	6105                	addi	sp,sp,32
    800028c4:	8082                	ret

00000000800028c6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800028c6:	1141                	addi	sp,sp,-16
    800028c8:	e406                	sd	ra,8(sp)
    800028ca:	e022                	sd	s0,0(sp)
    800028cc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800028ce:	844ff0ef          	jal	80001912 <myproc>
}
    800028d2:	5908                	lw	a0,48(a0)
    800028d4:	60a2                	ld	ra,8(sp)
    800028d6:	6402                	ld	s0,0(sp)
    800028d8:	0141                	addi	sp,sp,16
    800028da:	8082                	ret

00000000800028dc <sys_fork>:

uint64
sys_fork(void)
{
    800028dc:	1141                	addi	sp,sp,-16
    800028de:	e406                	sd	ra,8(sp)
    800028e0:	e022                	sd	s0,0(sp)
    800028e2:	0800                	addi	s0,sp,16
  return fork();
    800028e4:	b54ff0ef          	jal	80001c38 <fork>
}
    800028e8:	60a2                	ld	ra,8(sp)
    800028ea:	6402                	ld	s0,0(sp)
    800028ec:	0141                	addi	sp,sp,16
    800028ee:	8082                	ret

00000000800028f0 <sys_wait>:

uint64
sys_wait(void)
{
    800028f0:	1101                	addi	sp,sp,-32
    800028f2:	ec06                	sd	ra,24(sp)
    800028f4:	e822                	sd	s0,16(sp)
    800028f6:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800028f8:	fe840593          	addi	a1,s0,-24
    800028fc:	4501                	li	a0,0
    800028fe:	ee5ff0ef          	jal	800027e2 <argaddr>
  return wait(p);
    80002902:	fe843503          	ld	a0,-24(s0)
    80002906:	83dff0ef          	jal	80002142 <wait>
}
    8000290a:	60e2                	ld	ra,24(sp)
    8000290c:	6442                	ld	s0,16(sp)
    8000290e:	6105                	addi	sp,sp,32
    80002910:	8082                	ret

0000000080002912 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002912:	7179                	addi	sp,sp,-48
    80002914:	f406                	sd	ra,40(sp)
    80002916:	f022                	sd	s0,32(sp)
    80002918:	ec26                	sd	s1,24(sp)
    8000291a:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000291c:	fdc40593          	addi	a1,s0,-36
    80002920:	4501                	li	a0,0
    80002922:	ea5ff0ef          	jal	800027c6 <argint>
  addr = myproc()->sz;
    80002926:	fedfe0ef          	jal	80001912 <myproc>
    8000292a:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000292c:	fdc42503          	lw	a0,-36(s0)
    80002930:	ab8ff0ef          	jal	80001be8 <growproc>
    80002934:	00054863          	bltz	a0,80002944 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002938:	8526                	mv	a0,s1
    8000293a:	70a2                	ld	ra,40(sp)
    8000293c:	7402                	ld	s0,32(sp)
    8000293e:	64e2                	ld	s1,24(sp)
    80002940:	6145                	addi	sp,sp,48
    80002942:	8082                	ret
    return -1;
    80002944:	54fd                	li	s1,-1
    80002946:	bfcd                	j	80002938 <sys_sbrk+0x26>

0000000080002948 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002948:	7139                	addi	sp,sp,-64
    8000294a:	fc06                	sd	ra,56(sp)
    8000294c:	f822                	sd	s0,48(sp)
    8000294e:	f04a                	sd	s2,32(sp)
    80002950:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002952:	fcc40593          	addi	a1,s0,-52
    80002956:	4501                	li	a0,0
    80002958:	e6fff0ef          	jal	800027c6 <argint>
  if(n < 0)
    8000295c:	fcc42783          	lw	a5,-52(s0)
    80002960:	0607c763          	bltz	a5,800029ce <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002964:	00016517          	auipc	a0,0x16
    80002968:	93c50513          	addi	a0,a0,-1732 # 800182a0 <tickslock>
    8000296c:	a96fe0ef          	jal	80000c02 <acquire>
  ticks0 = ticks;
    80002970:	00008917          	auipc	s2,0x8
    80002974:	9d092903          	lw	s2,-1584(s2) # 8000a340 <ticks>
  while(ticks - ticks0 < n){
    80002978:	fcc42783          	lw	a5,-52(s0)
    8000297c:	cf8d                	beqz	a5,800029b6 <sys_sleep+0x6e>
    8000297e:	f426                	sd	s1,40(sp)
    80002980:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002982:	00016997          	auipc	s3,0x16
    80002986:	91e98993          	addi	s3,s3,-1762 # 800182a0 <tickslock>
    8000298a:	00008497          	auipc	s1,0x8
    8000298e:	9b648493          	addi	s1,s1,-1610 # 8000a340 <ticks>
    if(killed(myproc())){
    80002992:	f81fe0ef          	jal	80001912 <myproc>
    80002996:	f82ff0ef          	jal	80002118 <killed>
    8000299a:	ed0d                	bnez	a0,800029d4 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    8000299c:	85ce                	mv	a1,s3
    8000299e:	8526                	mv	a0,s1
    800029a0:	d40ff0ef          	jal	80001ee0 <sleep>
  while(ticks - ticks0 < n){
    800029a4:	409c                	lw	a5,0(s1)
    800029a6:	412787bb          	subw	a5,a5,s2
    800029aa:	fcc42703          	lw	a4,-52(s0)
    800029ae:	fee7e2e3          	bltu	a5,a4,80002992 <sys_sleep+0x4a>
    800029b2:	74a2                	ld	s1,40(sp)
    800029b4:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800029b6:	00016517          	auipc	a0,0x16
    800029ba:	8ea50513          	addi	a0,a0,-1814 # 800182a0 <tickslock>
    800029be:	adcfe0ef          	jal	80000c9a <release>
  return 0;
    800029c2:	4501                	li	a0,0
}
    800029c4:	70e2                	ld	ra,56(sp)
    800029c6:	7442                	ld	s0,48(sp)
    800029c8:	7902                	ld	s2,32(sp)
    800029ca:	6121                	addi	sp,sp,64
    800029cc:	8082                	ret
    n = 0;
    800029ce:	fc042623          	sw	zero,-52(s0)
    800029d2:	bf49                	j	80002964 <sys_sleep+0x1c>
      release(&tickslock);
    800029d4:	00016517          	auipc	a0,0x16
    800029d8:	8cc50513          	addi	a0,a0,-1844 # 800182a0 <tickslock>
    800029dc:	abefe0ef          	jal	80000c9a <release>
      return -1;
    800029e0:	557d                	li	a0,-1
    800029e2:	74a2                	ld	s1,40(sp)
    800029e4:	69e2                	ld	s3,24(sp)
    800029e6:	bff9                	j	800029c4 <sys_sleep+0x7c>

00000000800029e8 <sys_kill>:

uint64
sys_kill(void)
{
    800029e8:	1101                	addi	sp,sp,-32
    800029ea:	ec06                	sd	ra,24(sp)
    800029ec:	e822                	sd	s0,16(sp)
    800029ee:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800029f0:	fec40593          	addi	a1,s0,-20
    800029f4:	4501                	li	a0,0
    800029f6:	dd1ff0ef          	jal	800027c6 <argint>
  return kill(pid);
    800029fa:	fec42503          	lw	a0,-20(s0)
    800029fe:	e90ff0ef          	jal	8000208e <kill>
}
    80002a02:	60e2                	ld	ra,24(sp)
    80002a04:	6442                	ld	s0,16(sp)
    80002a06:	6105                	addi	sp,sp,32
    80002a08:	8082                	ret

0000000080002a0a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002a0a:	1101                	addi	sp,sp,-32
    80002a0c:	ec06                	sd	ra,24(sp)
    80002a0e:	e822                	sd	s0,16(sp)
    80002a10:	e426                	sd	s1,8(sp)
    80002a12:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002a14:	00016517          	auipc	a0,0x16
    80002a18:	88c50513          	addi	a0,a0,-1908 # 800182a0 <tickslock>
    80002a1c:	9e6fe0ef          	jal	80000c02 <acquire>
  xticks = ticks;
    80002a20:	00008497          	auipc	s1,0x8
    80002a24:	9204a483          	lw	s1,-1760(s1) # 8000a340 <ticks>
  release(&tickslock);
    80002a28:	00016517          	auipc	a0,0x16
    80002a2c:	87850513          	addi	a0,a0,-1928 # 800182a0 <tickslock>
    80002a30:	a6afe0ef          	jal	80000c9a <release>
  return xticks;
}
    80002a34:	02049513          	slli	a0,s1,0x20
    80002a38:	9101                	srli	a0,a0,0x20
    80002a3a:	60e2                	ld	ra,24(sp)
    80002a3c:	6442                	ld	s0,16(sp)
    80002a3e:	64a2                	ld	s1,8(sp)
    80002a40:	6105                	addi	sp,sp,32
    80002a42:	8082                	ret

0000000080002a44 <sys_countsyscall>:
uint64 syscall_count = 0;
uint64
sys_countsyscall(void)
{
    80002a44:	1141                	addi	sp,sp,-16
    80002a46:	e422                	sd	s0,8(sp)
    80002a48:	0800                	addi	s0,sp,16
  return syscall_count;
}
    80002a4a:	00008517          	auipc	a0,0x8
    80002a4e:	8fe53503          	ld	a0,-1794(a0) # 8000a348 <syscall_count>
    80002a52:	6422                	ld	s0,8(sp)
    80002a54:	0141                	addi	sp,sp,16
    80002a56:	8082                	ret

0000000080002a58 <sys_getppid>:
uint64
sys_getppid(void)
{
    80002a58:	1141                	addi	sp,sp,-16
    80002a5a:	e406                	sd	ra,8(sp)
    80002a5c:	e022                	sd	s0,0(sp)
    80002a5e:	0800                	addi	s0,sp,16
  return myproc()->parent->pid;
    80002a60:	eb3fe0ef          	jal	80001912 <myproc>
    80002a64:	7d1c                	ld	a5,56(a0)
}
    80002a66:	5b88                	lw	a0,48(a5)
    80002a68:	60a2                	ld	ra,8(sp)
    80002a6a:	6402                	ld	s0,0(sp)
    80002a6c:	0141                	addi	sp,sp,16
    80002a6e:	8082                	ret

0000000080002a70 <sys_shutdown>:
uint64
sys_shutdown(void)
{
    80002a70:	1141                	addi	sp,sp,-16
    80002a72:	e406                	sd	ra,8(sp)
    80002a74:	e022                	sd	s0,0(sp)
    80002a76:	0800                	addi	s0,sp,16
  printf("shutting down \n");
    80002a78:	00005517          	auipc	a0,0x5
    80002a7c:	9b850513          	addi	a0,a0,-1608 # 80007430 <etext+0x430>
    80002a80:	a51fd0ef          	jal	800004d0 <printf>
  volatile uint32 *shutdown_reg=(uint32 *)0x100000;
  *shutdown_reg=0x5555;
    80002a84:	6795                	lui	a5,0x5
    80002a86:	55578793          	addi	a5,a5,1365 # 5555 <_entry-0x7fffaaab>
    80002a8a:	00100737          	lui	a4,0x100
    80002a8e:	c31c                	sw	a5,0(a4)
  return 0;
}
    80002a90:	4501                	li	a0,0
    80002a92:	60a2                	ld	ra,8(sp)
    80002a94:	6402                	ld	s0,0(sp)
    80002a96:	0141                	addi	sp,sp,16
    80002a98:	8082                	ret

0000000080002a9a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002a9a:	7179                	addi	sp,sp,-48
    80002a9c:	f406                	sd	ra,40(sp)
    80002a9e:	f022                	sd	s0,32(sp)
    80002aa0:	ec26                	sd	s1,24(sp)
    80002aa2:	e84a                	sd	s2,16(sp)
    80002aa4:	e44e                	sd	s3,8(sp)
    80002aa6:	e052                	sd	s4,0(sp)
    80002aa8:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002aaa:	00005597          	auipc	a1,0x5
    80002aae:	99658593          	addi	a1,a1,-1642 # 80007440 <etext+0x440>
    80002ab2:	00016517          	auipc	a0,0x16
    80002ab6:	80650513          	addi	a0,a0,-2042 # 800182b8 <bcache>
    80002aba:	8c8fe0ef          	jal	80000b82 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002abe:	0001d797          	auipc	a5,0x1d
    80002ac2:	7fa78793          	addi	a5,a5,2042 # 800202b8 <bcache+0x8000>
    80002ac6:	0001e717          	auipc	a4,0x1e
    80002aca:	a5a70713          	addi	a4,a4,-1446 # 80020520 <bcache+0x8268>
    80002ace:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002ad2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ad6:	00015497          	auipc	s1,0x15
    80002ada:	7fa48493          	addi	s1,s1,2042 # 800182d0 <bcache+0x18>
    b->next = bcache.head.next;
    80002ade:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002ae0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002ae2:	00005a17          	auipc	s4,0x5
    80002ae6:	966a0a13          	addi	s4,s4,-1690 # 80007448 <etext+0x448>
    b->next = bcache.head.next;
    80002aea:	2b893783          	ld	a5,696(s2)
    80002aee:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002af0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002af4:	85d2                	mv	a1,s4
    80002af6:	01048513          	addi	a0,s1,16
    80002afa:	248010ef          	jal	80003d42 <initsleeplock>
    bcache.head.next->prev = b;
    80002afe:	2b893783          	ld	a5,696(s2)
    80002b02:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002b04:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b08:	45848493          	addi	s1,s1,1112
    80002b0c:	fd349fe3          	bne	s1,s3,80002aea <binit+0x50>
  }
}
    80002b10:	70a2                	ld	ra,40(sp)
    80002b12:	7402                	ld	s0,32(sp)
    80002b14:	64e2                	ld	s1,24(sp)
    80002b16:	6942                	ld	s2,16(sp)
    80002b18:	69a2                	ld	s3,8(sp)
    80002b1a:	6a02                	ld	s4,0(sp)
    80002b1c:	6145                	addi	sp,sp,48
    80002b1e:	8082                	ret

0000000080002b20 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002b20:	7179                	addi	sp,sp,-48
    80002b22:	f406                	sd	ra,40(sp)
    80002b24:	f022                	sd	s0,32(sp)
    80002b26:	ec26                	sd	s1,24(sp)
    80002b28:	e84a                	sd	s2,16(sp)
    80002b2a:	e44e                	sd	s3,8(sp)
    80002b2c:	1800                	addi	s0,sp,48
    80002b2e:	892a                	mv	s2,a0
    80002b30:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002b32:	00015517          	auipc	a0,0x15
    80002b36:	78650513          	addi	a0,a0,1926 # 800182b8 <bcache>
    80002b3a:	8c8fe0ef          	jal	80000c02 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002b3e:	0001e497          	auipc	s1,0x1e
    80002b42:	a324b483          	ld	s1,-1486(s1) # 80020570 <bcache+0x82b8>
    80002b46:	0001e797          	auipc	a5,0x1e
    80002b4a:	9da78793          	addi	a5,a5,-1574 # 80020520 <bcache+0x8268>
    80002b4e:	02f48b63          	beq	s1,a5,80002b84 <bread+0x64>
    80002b52:	873e                	mv	a4,a5
    80002b54:	a021                	j	80002b5c <bread+0x3c>
    80002b56:	68a4                	ld	s1,80(s1)
    80002b58:	02e48663          	beq	s1,a4,80002b84 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002b5c:	449c                	lw	a5,8(s1)
    80002b5e:	ff279ce3          	bne	a5,s2,80002b56 <bread+0x36>
    80002b62:	44dc                	lw	a5,12(s1)
    80002b64:	ff3799e3          	bne	a5,s3,80002b56 <bread+0x36>
      b->refcnt++;
    80002b68:	40bc                	lw	a5,64(s1)
    80002b6a:	2785                	addiw	a5,a5,1
    80002b6c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002b6e:	00015517          	auipc	a0,0x15
    80002b72:	74a50513          	addi	a0,a0,1866 # 800182b8 <bcache>
    80002b76:	924fe0ef          	jal	80000c9a <release>
      acquiresleep(&b->lock);
    80002b7a:	01048513          	addi	a0,s1,16
    80002b7e:	1fa010ef          	jal	80003d78 <acquiresleep>
      return b;
    80002b82:	a889                	j	80002bd4 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002b84:	0001e497          	auipc	s1,0x1e
    80002b88:	9e44b483          	ld	s1,-1564(s1) # 80020568 <bcache+0x82b0>
    80002b8c:	0001e797          	auipc	a5,0x1e
    80002b90:	99478793          	addi	a5,a5,-1644 # 80020520 <bcache+0x8268>
    80002b94:	00f48863          	beq	s1,a5,80002ba4 <bread+0x84>
    80002b98:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002b9a:	40bc                	lw	a5,64(s1)
    80002b9c:	cb91                	beqz	a5,80002bb0 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002b9e:	64a4                	ld	s1,72(s1)
    80002ba0:	fee49de3          	bne	s1,a4,80002b9a <bread+0x7a>
  panic("bget: no buffers");
    80002ba4:	00005517          	auipc	a0,0x5
    80002ba8:	8ac50513          	addi	a0,a0,-1876 # 80007450 <etext+0x450>
    80002bac:	bf7fd0ef          	jal	800007a2 <panic>
      b->dev = dev;
    80002bb0:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002bb4:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002bb8:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002bbc:	4785                	li	a5,1
    80002bbe:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002bc0:	00015517          	auipc	a0,0x15
    80002bc4:	6f850513          	addi	a0,a0,1784 # 800182b8 <bcache>
    80002bc8:	8d2fe0ef          	jal	80000c9a <release>
      acquiresleep(&b->lock);
    80002bcc:	01048513          	addi	a0,s1,16
    80002bd0:	1a8010ef          	jal	80003d78 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002bd4:	409c                	lw	a5,0(s1)
    80002bd6:	cb89                	beqz	a5,80002be8 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002bd8:	8526                	mv	a0,s1
    80002bda:	70a2                	ld	ra,40(sp)
    80002bdc:	7402                	ld	s0,32(sp)
    80002bde:	64e2                	ld	s1,24(sp)
    80002be0:	6942                	ld	s2,16(sp)
    80002be2:	69a2                	ld	s3,8(sp)
    80002be4:	6145                	addi	sp,sp,48
    80002be6:	8082                	ret
    virtio_disk_rw(b, 0);
    80002be8:	4581                	li	a1,0
    80002bea:	8526                	mv	a0,s1
    80002bec:	1e5020ef          	jal	800055d0 <virtio_disk_rw>
    b->valid = 1;
    80002bf0:	4785                	li	a5,1
    80002bf2:	c09c                	sw	a5,0(s1)
  return b;
    80002bf4:	b7d5                	j	80002bd8 <bread+0xb8>

0000000080002bf6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002bf6:	1101                	addi	sp,sp,-32
    80002bf8:	ec06                	sd	ra,24(sp)
    80002bfa:	e822                	sd	s0,16(sp)
    80002bfc:	e426                	sd	s1,8(sp)
    80002bfe:	1000                	addi	s0,sp,32
    80002c00:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002c02:	0541                	addi	a0,a0,16
    80002c04:	1f2010ef          	jal	80003df6 <holdingsleep>
    80002c08:	c911                	beqz	a0,80002c1c <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002c0a:	4585                	li	a1,1
    80002c0c:	8526                	mv	a0,s1
    80002c0e:	1c3020ef          	jal	800055d0 <virtio_disk_rw>
}
    80002c12:	60e2                	ld	ra,24(sp)
    80002c14:	6442                	ld	s0,16(sp)
    80002c16:	64a2                	ld	s1,8(sp)
    80002c18:	6105                	addi	sp,sp,32
    80002c1a:	8082                	ret
    panic("bwrite");
    80002c1c:	00005517          	auipc	a0,0x5
    80002c20:	84c50513          	addi	a0,a0,-1972 # 80007468 <etext+0x468>
    80002c24:	b7ffd0ef          	jal	800007a2 <panic>

0000000080002c28 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002c28:	1101                	addi	sp,sp,-32
    80002c2a:	ec06                	sd	ra,24(sp)
    80002c2c:	e822                	sd	s0,16(sp)
    80002c2e:	e426                	sd	s1,8(sp)
    80002c30:	e04a                	sd	s2,0(sp)
    80002c32:	1000                	addi	s0,sp,32
    80002c34:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002c36:	01050913          	addi	s2,a0,16
    80002c3a:	854a                	mv	a0,s2
    80002c3c:	1ba010ef          	jal	80003df6 <holdingsleep>
    80002c40:	c135                	beqz	a0,80002ca4 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002c42:	854a                	mv	a0,s2
    80002c44:	17a010ef          	jal	80003dbe <releasesleep>

  acquire(&bcache.lock);
    80002c48:	00015517          	auipc	a0,0x15
    80002c4c:	67050513          	addi	a0,a0,1648 # 800182b8 <bcache>
    80002c50:	fb3fd0ef          	jal	80000c02 <acquire>
  b->refcnt--;
    80002c54:	40bc                	lw	a5,64(s1)
    80002c56:	37fd                	addiw	a5,a5,-1
    80002c58:	0007871b          	sext.w	a4,a5
    80002c5c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002c5e:	e71d                	bnez	a4,80002c8c <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002c60:	68b8                	ld	a4,80(s1)
    80002c62:	64bc                	ld	a5,72(s1)
    80002c64:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002c66:	68b8                	ld	a4,80(s1)
    80002c68:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002c6a:	0001d797          	auipc	a5,0x1d
    80002c6e:	64e78793          	addi	a5,a5,1614 # 800202b8 <bcache+0x8000>
    80002c72:	2b87b703          	ld	a4,696(a5)
    80002c76:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002c78:	0001e717          	auipc	a4,0x1e
    80002c7c:	8a870713          	addi	a4,a4,-1880 # 80020520 <bcache+0x8268>
    80002c80:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002c82:	2b87b703          	ld	a4,696(a5)
    80002c86:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002c88:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002c8c:	00015517          	auipc	a0,0x15
    80002c90:	62c50513          	addi	a0,a0,1580 # 800182b8 <bcache>
    80002c94:	806fe0ef          	jal	80000c9a <release>
}
    80002c98:	60e2                	ld	ra,24(sp)
    80002c9a:	6442                	ld	s0,16(sp)
    80002c9c:	64a2                	ld	s1,8(sp)
    80002c9e:	6902                	ld	s2,0(sp)
    80002ca0:	6105                	addi	sp,sp,32
    80002ca2:	8082                	ret
    panic("brelse");
    80002ca4:	00004517          	auipc	a0,0x4
    80002ca8:	7cc50513          	addi	a0,a0,1996 # 80007470 <etext+0x470>
    80002cac:	af7fd0ef          	jal	800007a2 <panic>

0000000080002cb0 <bpin>:

void
bpin(struct buf *b) {
    80002cb0:	1101                	addi	sp,sp,-32
    80002cb2:	ec06                	sd	ra,24(sp)
    80002cb4:	e822                	sd	s0,16(sp)
    80002cb6:	e426                	sd	s1,8(sp)
    80002cb8:	1000                	addi	s0,sp,32
    80002cba:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002cbc:	00015517          	auipc	a0,0x15
    80002cc0:	5fc50513          	addi	a0,a0,1532 # 800182b8 <bcache>
    80002cc4:	f3ffd0ef          	jal	80000c02 <acquire>
  b->refcnt++;
    80002cc8:	40bc                	lw	a5,64(s1)
    80002cca:	2785                	addiw	a5,a5,1
    80002ccc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002cce:	00015517          	auipc	a0,0x15
    80002cd2:	5ea50513          	addi	a0,a0,1514 # 800182b8 <bcache>
    80002cd6:	fc5fd0ef          	jal	80000c9a <release>
}
    80002cda:	60e2                	ld	ra,24(sp)
    80002cdc:	6442                	ld	s0,16(sp)
    80002cde:	64a2                	ld	s1,8(sp)
    80002ce0:	6105                	addi	sp,sp,32
    80002ce2:	8082                	ret

0000000080002ce4 <bunpin>:

void
bunpin(struct buf *b) {
    80002ce4:	1101                	addi	sp,sp,-32
    80002ce6:	ec06                	sd	ra,24(sp)
    80002ce8:	e822                	sd	s0,16(sp)
    80002cea:	e426                	sd	s1,8(sp)
    80002cec:	1000                	addi	s0,sp,32
    80002cee:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002cf0:	00015517          	auipc	a0,0x15
    80002cf4:	5c850513          	addi	a0,a0,1480 # 800182b8 <bcache>
    80002cf8:	f0bfd0ef          	jal	80000c02 <acquire>
  b->refcnt--;
    80002cfc:	40bc                	lw	a5,64(s1)
    80002cfe:	37fd                	addiw	a5,a5,-1
    80002d00:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d02:	00015517          	auipc	a0,0x15
    80002d06:	5b650513          	addi	a0,a0,1462 # 800182b8 <bcache>
    80002d0a:	f91fd0ef          	jal	80000c9a <release>
}
    80002d0e:	60e2                	ld	ra,24(sp)
    80002d10:	6442                	ld	s0,16(sp)
    80002d12:	64a2                	ld	s1,8(sp)
    80002d14:	6105                	addi	sp,sp,32
    80002d16:	8082                	ret

0000000080002d18 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002d18:	1101                	addi	sp,sp,-32
    80002d1a:	ec06                	sd	ra,24(sp)
    80002d1c:	e822                	sd	s0,16(sp)
    80002d1e:	e426                	sd	s1,8(sp)
    80002d20:	e04a                	sd	s2,0(sp)
    80002d22:	1000                	addi	s0,sp,32
    80002d24:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002d26:	00d5d59b          	srliw	a1,a1,0xd
    80002d2a:	0001e797          	auipc	a5,0x1e
    80002d2e:	c6a7a783          	lw	a5,-918(a5) # 80020994 <sb+0x1c>
    80002d32:	9dbd                	addw	a1,a1,a5
    80002d34:	dedff0ef          	jal	80002b20 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002d38:	0074f713          	andi	a4,s1,7
    80002d3c:	4785                	li	a5,1
    80002d3e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002d42:	14ce                	slli	s1,s1,0x33
    80002d44:	90d9                	srli	s1,s1,0x36
    80002d46:	00950733          	add	a4,a0,s1
    80002d4a:	05874703          	lbu	a4,88(a4)
    80002d4e:	00e7f6b3          	and	a3,a5,a4
    80002d52:	c29d                	beqz	a3,80002d78 <bfree+0x60>
    80002d54:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002d56:	94aa                	add	s1,s1,a0
    80002d58:	fff7c793          	not	a5,a5
    80002d5c:	8f7d                	and	a4,a4,a5
    80002d5e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002d62:	711000ef          	jal	80003c72 <log_write>
  brelse(bp);
    80002d66:	854a                	mv	a0,s2
    80002d68:	ec1ff0ef          	jal	80002c28 <brelse>
}
    80002d6c:	60e2                	ld	ra,24(sp)
    80002d6e:	6442                	ld	s0,16(sp)
    80002d70:	64a2                	ld	s1,8(sp)
    80002d72:	6902                	ld	s2,0(sp)
    80002d74:	6105                	addi	sp,sp,32
    80002d76:	8082                	ret
    panic("freeing free block");
    80002d78:	00004517          	auipc	a0,0x4
    80002d7c:	70050513          	addi	a0,a0,1792 # 80007478 <etext+0x478>
    80002d80:	a23fd0ef          	jal	800007a2 <panic>

0000000080002d84 <balloc>:
{
    80002d84:	711d                	addi	sp,sp,-96
    80002d86:	ec86                	sd	ra,88(sp)
    80002d88:	e8a2                	sd	s0,80(sp)
    80002d8a:	e4a6                	sd	s1,72(sp)
    80002d8c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002d8e:	0001e797          	auipc	a5,0x1e
    80002d92:	bee7a783          	lw	a5,-1042(a5) # 8002097c <sb+0x4>
    80002d96:	0e078f63          	beqz	a5,80002e94 <balloc+0x110>
    80002d9a:	e0ca                	sd	s2,64(sp)
    80002d9c:	fc4e                	sd	s3,56(sp)
    80002d9e:	f852                	sd	s4,48(sp)
    80002da0:	f456                	sd	s5,40(sp)
    80002da2:	f05a                	sd	s6,32(sp)
    80002da4:	ec5e                	sd	s7,24(sp)
    80002da6:	e862                	sd	s8,16(sp)
    80002da8:	e466                	sd	s9,8(sp)
    80002daa:	8baa                	mv	s7,a0
    80002dac:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002dae:	0001eb17          	auipc	s6,0x1e
    80002db2:	bcab0b13          	addi	s6,s6,-1078 # 80020978 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002db6:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002db8:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002dba:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002dbc:	6c89                	lui	s9,0x2
    80002dbe:	a0b5                	j	80002e2a <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002dc0:	97ca                	add	a5,a5,s2
    80002dc2:	8e55                	or	a2,a2,a3
    80002dc4:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002dc8:	854a                	mv	a0,s2
    80002dca:	6a9000ef          	jal	80003c72 <log_write>
        brelse(bp);
    80002dce:	854a                	mv	a0,s2
    80002dd0:	e59ff0ef          	jal	80002c28 <brelse>
  bp = bread(dev, bno);
    80002dd4:	85a6                	mv	a1,s1
    80002dd6:	855e                	mv	a0,s7
    80002dd8:	d49ff0ef          	jal	80002b20 <bread>
    80002ddc:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002dde:	40000613          	li	a2,1024
    80002de2:	4581                	li	a1,0
    80002de4:	05850513          	addi	a0,a0,88
    80002de8:	eeffd0ef          	jal	80000cd6 <memset>
  log_write(bp);
    80002dec:	854a                	mv	a0,s2
    80002dee:	685000ef          	jal	80003c72 <log_write>
  brelse(bp);
    80002df2:	854a                	mv	a0,s2
    80002df4:	e35ff0ef          	jal	80002c28 <brelse>
}
    80002df8:	6906                	ld	s2,64(sp)
    80002dfa:	79e2                	ld	s3,56(sp)
    80002dfc:	7a42                	ld	s4,48(sp)
    80002dfe:	7aa2                	ld	s5,40(sp)
    80002e00:	7b02                	ld	s6,32(sp)
    80002e02:	6be2                	ld	s7,24(sp)
    80002e04:	6c42                	ld	s8,16(sp)
    80002e06:	6ca2                	ld	s9,8(sp)
}
    80002e08:	8526                	mv	a0,s1
    80002e0a:	60e6                	ld	ra,88(sp)
    80002e0c:	6446                	ld	s0,80(sp)
    80002e0e:	64a6                	ld	s1,72(sp)
    80002e10:	6125                	addi	sp,sp,96
    80002e12:	8082                	ret
    brelse(bp);
    80002e14:	854a                	mv	a0,s2
    80002e16:	e13ff0ef          	jal	80002c28 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002e1a:	015c87bb          	addw	a5,s9,s5
    80002e1e:	00078a9b          	sext.w	s5,a5
    80002e22:	004b2703          	lw	a4,4(s6)
    80002e26:	04eaff63          	bgeu	s5,a4,80002e84 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002e2a:	41fad79b          	sraiw	a5,s5,0x1f
    80002e2e:	0137d79b          	srliw	a5,a5,0x13
    80002e32:	015787bb          	addw	a5,a5,s5
    80002e36:	40d7d79b          	sraiw	a5,a5,0xd
    80002e3a:	01cb2583          	lw	a1,28(s6)
    80002e3e:	9dbd                	addw	a1,a1,a5
    80002e40:	855e                	mv	a0,s7
    80002e42:	cdfff0ef          	jal	80002b20 <bread>
    80002e46:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e48:	004b2503          	lw	a0,4(s6)
    80002e4c:	000a849b          	sext.w	s1,s5
    80002e50:	8762                	mv	a4,s8
    80002e52:	fca4f1e3          	bgeu	s1,a0,80002e14 <balloc+0x90>
      m = 1 << (bi % 8);
    80002e56:	00777693          	andi	a3,a4,7
    80002e5a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002e5e:	41f7579b          	sraiw	a5,a4,0x1f
    80002e62:	01d7d79b          	srliw	a5,a5,0x1d
    80002e66:	9fb9                	addw	a5,a5,a4
    80002e68:	4037d79b          	sraiw	a5,a5,0x3
    80002e6c:	00f90633          	add	a2,s2,a5
    80002e70:	05864603          	lbu	a2,88(a2)
    80002e74:	00c6f5b3          	and	a1,a3,a2
    80002e78:	d5a1                	beqz	a1,80002dc0 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e7a:	2705                	addiw	a4,a4,1
    80002e7c:	2485                	addiw	s1,s1,1
    80002e7e:	fd471ae3          	bne	a4,s4,80002e52 <balloc+0xce>
    80002e82:	bf49                	j	80002e14 <balloc+0x90>
    80002e84:	6906                	ld	s2,64(sp)
    80002e86:	79e2                	ld	s3,56(sp)
    80002e88:	7a42                	ld	s4,48(sp)
    80002e8a:	7aa2                	ld	s5,40(sp)
    80002e8c:	7b02                	ld	s6,32(sp)
    80002e8e:	6be2                	ld	s7,24(sp)
    80002e90:	6c42                	ld	s8,16(sp)
    80002e92:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002e94:	00004517          	auipc	a0,0x4
    80002e98:	5fc50513          	addi	a0,a0,1532 # 80007490 <etext+0x490>
    80002e9c:	e34fd0ef          	jal	800004d0 <printf>
  return 0;
    80002ea0:	4481                	li	s1,0
    80002ea2:	b79d                	j	80002e08 <balloc+0x84>

0000000080002ea4 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002ea4:	7179                	addi	sp,sp,-48
    80002ea6:	f406                	sd	ra,40(sp)
    80002ea8:	f022                	sd	s0,32(sp)
    80002eaa:	ec26                	sd	s1,24(sp)
    80002eac:	e84a                	sd	s2,16(sp)
    80002eae:	e44e                	sd	s3,8(sp)
    80002eb0:	1800                	addi	s0,sp,48
    80002eb2:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002eb4:	47ad                	li	a5,11
    80002eb6:	02b7e663          	bltu	a5,a1,80002ee2 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002eba:	02059793          	slli	a5,a1,0x20
    80002ebe:	01e7d593          	srli	a1,a5,0x1e
    80002ec2:	00b504b3          	add	s1,a0,a1
    80002ec6:	0504a903          	lw	s2,80(s1)
    80002eca:	06091a63          	bnez	s2,80002f3e <bmap+0x9a>
      addr = balloc(ip->dev);
    80002ece:	4108                	lw	a0,0(a0)
    80002ed0:	eb5ff0ef          	jal	80002d84 <balloc>
    80002ed4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002ed8:	06090363          	beqz	s2,80002f3e <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002edc:	0524a823          	sw	s2,80(s1)
    80002ee0:	a8b9                	j	80002f3e <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002ee2:	ff45849b          	addiw	s1,a1,-12
    80002ee6:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002eea:	0ff00793          	li	a5,255
    80002eee:	06e7ee63          	bltu	a5,a4,80002f6a <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002ef2:	08052903          	lw	s2,128(a0)
    80002ef6:	00091d63          	bnez	s2,80002f10 <bmap+0x6c>
      addr = balloc(ip->dev);
    80002efa:	4108                	lw	a0,0(a0)
    80002efc:	e89ff0ef          	jal	80002d84 <balloc>
    80002f00:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002f04:	02090d63          	beqz	s2,80002f3e <bmap+0x9a>
    80002f08:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002f0a:	0929a023          	sw	s2,128(s3)
    80002f0e:	a011                	j	80002f12 <bmap+0x6e>
    80002f10:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002f12:	85ca                	mv	a1,s2
    80002f14:	0009a503          	lw	a0,0(s3)
    80002f18:	c09ff0ef          	jal	80002b20 <bread>
    80002f1c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002f1e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002f22:	02049713          	slli	a4,s1,0x20
    80002f26:	01e75593          	srli	a1,a4,0x1e
    80002f2a:	00b784b3          	add	s1,a5,a1
    80002f2e:	0004a903          	lw	s2,0(s1)
    80002f32:	00090e63          	beqz	s2,80002f4e <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002f36:	8552                	mv	a0,s4
    80002f38:	cf1ff0ef          	jal	80002c28 <brelse>
    return addr;
    80002f3c:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002f3e:	854a                	mv	a0,s2
    80002f40:	70a2                	ld	ra,40(sp)
    80002f42:	7402                	ld	s0,32(sp)
    80002f44:	64e2                	ld	s1,24(sp)
    80002f46:	6942                	ld	s2,16(sp)
    80002f48:	69a2                	ld	s3,8(sp)
    80002f4a:	6145                	addi	sp,sp,48
    80002f4c:	8082                	ret
      addr = balloc(ip->dev);
    80002f4e:	0009a503          	lw	a0,0(s3)
    80002f52:	e33ff0ef          	jal	80002d84 <balloc>
    80002f56:	0005091b          	sext.w	s2,a0
      if(addr){
    80002f5a:	fc090ee3          	beqz	s2,80002f36 <bmap+0x92>
        a[bn] = addr;
    80002f5e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002f62:	8552                	mv	a0,s4
    80002f64:	50f000ef          	jal	80003c72 <log_write>
    80002f68:	b7f9                	j	80002f36 <bmap+0x92>
    80002f6a:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002f6c:	00004517          	auipc	a0,0x4
    80002f70:	53c50513          	addi	a0,a0,1340 # 800074a8 <etext+0x4a8>
    80002f74:	82ffd0ef          	jal	800007a2 <panic>

0000000080002f78 <iget>:
{
    80002f78:	7179                	addi	sp,sp,-48
    80002f7a:	f406                	sd	ra,40(sp)
    80002f7c:	f022                	sd	s0,32(sp)
    80002f7e:	ec26                	sd	s1,24(sp)
    80002f80:	e84a                	sd	s2,16(sp)
    80002f82:	e44e                	sd	s3,8(sp)
    80002f84:	e052                	sd	s4,0(sp)
    80002f86:	1800                	addi	s0,sp,48
    80002f88:	89aa                	mv	s3,a0
    80002f8a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002f8c:	0001e517          	auipc	a0,0x1e
    80002f90:	a0c50513          	addi	a0,a0,-1524 # 80020998 <itable>
    80002f94:	c6ffd0ef          	jal	80000c02 <acquire>
  empty = 0;
    80002f98:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002f9a:	0001e497          	auipc	s1,0x1e
    80002f9e:	a1648493          	addi	s1,s1,-1514 # 800209b0 <itable+0x18>
    80002fa2:	0001f697          	auipc	a3,0x1f
    80002fa6:	49e68693          	addi	a3,a3,1182 # 80022440 <log>
    80002faa:	a039                	j	80002fb8 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002fac:	02090963          	beqz	s2,80002fde <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002fb0:	08848493          	addi	s1,s1,136
    80002fb4:	02d48863          	beq	s1,a3,80002fe4 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002fb8:	449c                	lw	a5,8(s1)
    80002fba:	fef059e3          	blez	a5,80002fac <iget+0x34>
    80002fbe:	4098                	lw	a4,0(s1)
    80002fc0:	ff3716e3          	bne	a4,s3,80002fac <iget+0x34>
    80002fc4:	40d8                	lw	a4,4(s1)
    80002fc6:	ff4713e3          	bne	a4,s4,80002fac <iget+0x34>
      ip->ref++;
    80002fca:	2785                	addiw	a5,a5,1
    80002fcc:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002fce:	0001e517          	auipc	a0,0x1e
    80002fd2:	9ca50513          	addi	a0,a0,-1590 # 80020998 <itable>
    80002fd6:	cc5fd0ef          	jal	80000c9a <release>
      return ip;
    80002fda:	8926                	mv	s2,s1
    80002fdc:	a02d                	j	80003006 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002fde:	fbe9                	bnez	a5,80002fb0 <iget+0x38>
      empty = ip;
    80002fe0:	8926                	mv	s2,s1
    80002fe2:	b7f9                	j	80002fb0 <iget+0x38>
  if(empty == 0)
    80002fe4:	02090a63          	beqz	s2,80003018 <iget+0xa0>
  ip->dev = dev;
    80002fe8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002fec:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002ff0:	4785                	li	a5,1
    80002ff2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002ff6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002ffa:	0001e517          	auipc	a0,0x1e
    80002ffe:	99e50513          	addi	a0,a0,-1634 # 80020998 <itable>
    80003002:	c99fd0ef          	jal	80000c9a <release>
}
    80003006:	854a                	mv	a0,s2
    80003008:	70a2                	ld	ra,40(sp)
    8000300a:	7402                	ld	s0,32(sp)
    8000300c:	64e2                	ld	s1,24(sp)
    8000300e:	6942                	ld	s2,16(sp)
    80003010:	69a2                	ld	s3,8(sp)
    80003012:	6a02                	ld	s4,0(sp)
    80003014:	6145                	addi	sp,sp,48
    80003016:	8082                	ret
    panic("iget: no inodes");
    80003018:	00004517          	auipc	a0,0x4
    8000301c:	4a850513          	addi	a0,a0,1192 # 800074c0 <etext+0x4c0>
    80003020:	f82fd0ef          	jal	800007a2 <panic>

0000000080003024 <fsinit>:
fsinit(int dev) {
    80003024:	7179                	addi	sp,sp,-48
    80003026:	f406                	sd	ra,40(sp)
    80003028:	f022                	sd	s0,32(sp)
    8000302a:	ec26                	sd	s1,24(sp)
    8000302c:	e84a                	sd	s2,16(sp)
    8000302e:	e44e                	sd	s3,8(sp)
    80003030:	1800                	addi	s0,sp,48
    80003032:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003034:	4585                	li	a1,1
    80003036:	aebff0ef          	jal	80002b20 <bread>
    8000303a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000303c:	0001e997          	auipc	s3,0x1e
    80003040:	93c98993          	addi	s3,s3,-1732 # 80020978 <sb>
    80003044:	02000613          	li	a2,32
    80003048:	05850593          	addi	a1,a0,88
    8000304c:	854e                	mv	a0,s3
    8000304e:	ce5fd0ef          	jal	80000d32 <memmove>
  brelse(bp);
    80003052:	8526                	mv	a0,s1
    80003054:	bd5ff0ef          	jal	80002c28 <brelse>
  if(sb.magic != FSMAGIC)
    80003058:	0009a703          	lw	a4,0(s3)
    8000305c:	102037b7          	lui	a5,0x10203
    80003060:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003064:	02f71063          	bne	a4,a5,80003084 <fsinit+0x60>
  initlog(dev, &sb);
    80003068:	0001e597          	auipc	a1,0x1e
    8000306c:	91058593          	addi	a1,a1,-1776 # 80020978 <sb>
    80003070:	854a                	mv	a0,s2
    80003072:	1f9000ef          	jal	80003a6a <initlog>
}
    80003076:	70a2                	ld	ra,40(sp)
    80003078:	7402                	ld	s0,32(sp)
    8000307a:	64e2                	ld	s1,24(sp)
    8000307c:	6942                	ld	s2,16(sp)
    8000307e:	69a2                	ld	s3,8(sp)
    80003080:	6145                	addi	sp,sp,48
    80003082:	8082                	ret
    panic("invalid file system");
    80003084:	00004517          	auipc	a0,0x4
    80003088:	44c50513          	addi	a0,a0,1100 # 800074d0 <etext+0x4d0>
    8000308c:	f16fd0ef          	jal	800007a2 <panic>

0000000080003090 <iinit>:
{
    80003090:	7179                	addi	sp,sp,-48
    80003092:	f406                	sd	ra,40(sp)
    80003094:	f022                	sd	s0,32(sp)
    80003096:	ec26                	sd	s1,24(sp)
    80003098:	e84a                	sd	s2,16(sp)
    8000309a:	e44e                	sd	s3,8(sp)
    8000309c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000309e:	00004597          	auipc	a1,0x4
    800030a2:	44a58593          	addi	a1,a1,1098 # 800074e8 <etext+0x4e8>
    800030a6:	0001e517          	auipc	a0,0x1e
    800030aa:	8f250513          	addi	a0,a0,-1806 # 80020998 <itable>
    800030ae:	ad5fd0ef          	jal	80000b82 <initlock>
  for(i = 0; i < NINODE; i++) {
    800030b2:	0001e497          	auipc	s1,0x1e
    800030b6:	90e48493          	addi	s1,s1,-1778 # 800209c0 <itable+0x28>
    800030ba:	0001f997          	auipc	s3,0x1f
    800030be:	39698993          	addi	s3,s3,918 # 80022450 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800030c2:	00004917          	auipc	s2,0x4
    800030c6:	42e90913          	addi	s2,s2,1070 # 800074f0 <etext+0x4f0>
    800030ca:	85ca                	mv	a1,s2
    800030cc:	8526                	mv	a0,s1
    800030ce:	475000ef          	jal	80003d42 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800030d2:	08848493          	addi	s1,s1,136
    800030d6:	ff349ae3          	bne	s1,s3,800030ca <iinit+0x3a>
}
    800030da:	70a2                	ld	ra,40(sp)
    800030dc:	7402                	ld	s0,32(sp)
    800030de:	64e2                	ld	s1,24(sp)
    800030e0:	6942                	ld	s2,16(sp)
    800030e2:	69a2                	ld	s3,8(sp)
    800030e4:	6145                	addi	sp,sp,48
    800030e6:	8082                	ret

00000000800030e8 <ialloc>:
{
    800030e8:	7139                	addi	sp,sp,-64
    800030ea:	fc06                	sd	ra,56(sp)
    800030ec:	f822                	sd	s0,48(sp)
    800030ee:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800030f0:	0001e717          	auipc	a4,0x1e
    800030f4:	89472703          	lw	a4,-1900(a4) # 80020984 <sb+0xc>
    800030f8:	4785                	li	a5,1
    800030fa:	06e7f063          	bgeu	a5,a4,8000315a <ialloc+0x72>
    800030fe:	f426                	sd	s1,40(sp)
    80003100:	f04a                	sd	s2,32(sp)
    80003102:	ec4e                	sd	s3,24(sp)
    80003104:	e852                	sd	s4,16(sp)
    80003106:	e456                	sd	s5,8(sp)
    80003108:	e05a                	sd	s6,0(sp)
    8000310a:	8aaa                	mv	s5,a0
    8000310c:	8b2e                	mv	s6,a1
    8000310e:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003110:	0001ea17          	auipc	s4,0x1e
    80003114:	868a0a13          	addi	s4,s4,-1944 # 80020978 <sb>
    80003118:	00495593          	srli	a1,s2,0x4
    8000311c:	018a2783          	lw	a5,24(s4)
    80003120:	9dbd                	addw	a1,a1,a5
    80003122:	8556                	mv	a0,s5
    80003124:	9fdff0ef          	jal	80002b20 <bread>
    80003128:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000312a:	05850993          	addi	s3,a0,88
    8000312e:	00f97793          	andi	a5,s2,15
    80003132:	079a                	slli	a5,a5,0x6
    80003134:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003136:	00099783          	lh	a5,0(s3)
    8000313a:	cb9d                	beqz	a5,80003170 <ialloc+0x88>
    brelse(bp);
    8000313c:	aedff0ef          	jal	80002c28 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003140:	0905                	addi	s2,s2,1
    80003142:	00ca2703          	lw	a4,12(s4)
    80003146:	0009079b          	sext.w	a5,s2
    8000314a:	fce7e7e3          	bltu	a5,a4,80003118 <ialloc+0x30>
    8000314e:	74a2                	ld	s1,40(sp)
    80003150:	7902                	ld	s2,32(sp)
    80003152:	69e2                	ld	s3,24(sp)
    80003154:	6a42                	ld	s4,16(sp)
    80003156:	6aa2                	ld	s5,8(sp)
    80003158:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000315a:	00004517          	auipc	a0,0x4
    8000315e:	39e50513          	addi	a0,a0,926 # 800074f8 <etext+0x4f8>
    80003162:	b6efd0ef          	jal	800004d0 <printf>
  return 0;
    80003166:	4501                	li	a0,0
}
    80003168:	70e2                	ld	ra,56(sp)
    8000316a:	7442                	ld	s0,48(sp)
    8000316c:	6121                	addi	sp,sp,64
    8000316e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003170:	04000613          	li	a2,64
    80003174:	4581                	li	a1,0
    80003176:	854e                	mv	a0,s3
    80003178:	b5ffd0ef          	jal	80000cd6 <memset>
      dip->type = type;
    8000317c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003180:	8526                	mv	a0,s1
    80003182:	2f1000ef          	jal	80003c72 <log_write>
      brelse(bp);
    80003186:	8526                	mv	a0,s1
    80003188:	aa1ff0ef          	jal	80002c28 <brelse>
      return iget(dev, inum);
    8000318c:	0009059b          	sext.w	a1,s2
    80003190:	8556                	mv	a0,s5
    80003192:	de7ff0ef          	jal	80002f78 <iget>
    80003196:	74a2                	ld	s1,40(sp)
    80003198:	7902                	ld	s2,32(sp)
    8000319a:	69e2                	ld	s3,24(sp)
    8000319c:	6a42                	ld	s4,16(sp)
    8000319e:	6aa2                	ld	s5,8(sp)
    800031a0:	6b02                	ld	s6,0(sp)
    800031a2:	b7d9                	j	80003168 <ialloc+0x80>

00000000800031a4 <iupdate>:
{
    800031a4:	1101                	addi	sp,sp,-32
    800031a6:	ec06                	sd	ra,24(sp)
    800031a8:	e822                	sd	s0,16(sp)
    800031aa:	e426                	sd	s1,8(sp)
    800031ac:	e04a                	sd	s2,0(sp)
    800031ae:	1000                	addi	s0,sp,32
    800031b0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800031b2:	415c                	lw	a5,4(a0)
    800031b4:	0047d79b          	srliw	a5,a5,0x4
    800031b8:	0001d597          	auipc	a1,0x1d
    800031bc:	7d85a583          	lw	a1,2008(a1) # 80020990 <sb+0x18>
    800031c0:	9dbd                	addw	a1,a1,a5
    800031c2:	4108                	lw	a0,0(a0)
    800031c4:	95dff0ef          	jal	80002b20 <bread>
    800031c8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800031ca:	05850793          	addi	a5,a0,88
    800031ce:	40d8                	lw	a4,4(s1)
    800031d0:	8b3d                	andi	a4,a4,15
    800031d2:	071a                	slli	a4,a4,0x6
    800031d4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800031d6:	04449703          	lh	a4,68(s1)
    800031da:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800031de:	04649703          	lh	a4,70(s1)
    800031e2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800031e6:	04849703          	lh	a4,72(s1)
    800031ea:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800031ee:	04a49703          	lh	a4,74(s1)
    800031f2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800031f6:	44f8                	lw	a4,76(s1)
    800031f8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800031fa:	03400613          	li	a2,52
    800031fe:	05048593          	addi	a1,s1,80
    80003202:	00c78513          	addi	a0,a5,12
    80003206:	b2dfd0ef          	jal	80000d32 <memmove>
  log_write(bp);
    8000320a:	854a                	mv	a0,s2
    8000320c:	267000ef          	jal	80003c72 <log_write>
  brelse(bp);
    80003210:	854a                	mv	a0,s2
    80003212:	a17ff0ef          	jal	80002c28 <brelse>
}
    80003216:	60e2                	ld	ra,24(sp)
    80003218:	6442                	ld	s0,16(sp)
    8000321a:	64a2                	ld	s1,8(sp)
    8000321c:	6902                	ld	s2,0(sp)
    8000321e:	6105                	addi	sp,sp,32
    80003220:	8082                	ret

0000000080003222 <idup>:
{
    80003222:	1101                	addi	sp,sp,-32
    80003224:	ec06                	sd	ra,24(sp)
    80003226:	e822                	sd	s0,16(sp)
    80003228:	e426                	sd	s1,8(sp)
    8000322a:	1000                	addi	s0,sp,32
    8000322c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000322e:	0001d517          	auipc	a0,0x1d
    80003232:	76a50513          	addi	a0,a0,1898 # 80020998 <itable>
    80003236:	9cdfd0ef          	jal	80000c02 <acquire>
  ip->ref++;
    8000323a:	449c                	lw	a5,8(s1)
    8000323c:	2785                	addiw	a5,a5,1
    8000323e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003240:	0001d517          	auipc	a0,0x1d
    80003244:	75850513          	addi	a0,a0,1880 # 80020998 <itable>
    80003248:	a53fd0ef          	jal	80000c9a <release>
}
    8000324c:	8526                	mv	a0,s1
    8000324e:	60e2                	ld	ra,24(sp)
    80003250:	6442                	ld	s0,16(sp)
    80003252:	64a2                	ld	s1,8(sp)
    80003254:	6105                	addi	sp,sp,32
    80003256:	8082                	ret

0000000080003258 <ilock>:
{
    80003258:	1101                	addi	sp,sp,-32
    8000325a:	ec06                	sd	ra,24(sp)
    8000325c:	e822                	sd	s0,16(sp)
    8000325e:	e426                	sd	s1,8(sp)
    80003260:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003262:	cd19                	beqz	a0,80003280 <ilock+0x28>
    80003264:	84aa                	mv	s1,a0
    80003266:	451c                	lw	a5,8(a0)
    80003268:	00f05c63          	blez	a5,80003280 <ilock+0x28>
  acquiresleep(&ip->lock);
    8000326c:	0541                	addi	a0,a0,16
    8000326e:	30b000ef          	jal	80003d78 <acquiresleep>
  if(ip->valid == 0){
    80003272:	40bc                	lw	a5,64(s1)
    80003274:	cf89                	beqz	a5,8000328e <ilock+0x36>
}
    80003276:	60e2                	ld	ra,24(sp)
    80003278:	6442                	ld	s0,16(sp)
    8000327a:	64a2                	ld	s1,8(sp)
    8000327c:	6105                	addi	sp,sp,32
    8000327e:	8082                	ret
    80003280:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003282:	00004517          	auipc	a0,0x4
    80003286:	28e50513          	addi	a0,a0,654 # 80007510 <etext+0x510>
    8000328a:	d18fd0ef          	jal	800007a2 <panic>
    8000328e:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003290:	40dc                	lw	a5,4(s1)
    80003292:	0047d79b          	srliw	a5,a5,0x4
    80003296:	0001d597          	auipc	a1,0x1d
    8000329a:	6fa5a583          	lw	a1,1786(a1) # 80020990 <sb+0x18>
    8000329e:	9dbd                	addw	a1,a1,a5
    800032a0:	4088                	lw	a0,0(s1)
    800032a2:	87fff0ef          	jal	80002b20 <bread>
    800032a6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800032a8:	05850593          	addi	a1,a0,88
    800032ac:	40dc                	lw	a5,4(s1)
    800032ae:	8bbd                	andi	a5,a5,15
    800032b0:	079a                	slli	a5,a5,0x6
    800032b2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800032b4:	00059783          	lh	a5,0(a1)
    800032b8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800032bc:	00259783          	lh	a5,2(a1)
    800032c0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800032c4:	00459783          	lh	a5,4(a1)
    800032c8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800032cc:	00659783          	lh	a5,6(a1)
    800032d0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800032d4:	459c                	lw	a5,8(a1)
    800032d6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800032d8:	03400613          	li	a2,52
    800032dc:	05b1                	addi	a1,a1,12
    800032de:	05048513          	addi	a0,s1,80
    800032e2:	a51fd0ef          	jal	80000d32 <memmove>
    brelse(bp);
    800032e6:	854a                	mv	a0,s2
    800032e8:	941ff0ef          	jal	80002c28 <brelse>
    ip->valid = 1;
    800032ec:	4785                	li	a5,1
    800032ee:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800032f0:	04449783          	lh	a5,68(s1)
    800032f4:	c399                	beqz	a5,800032fa <ilock+0xa2>
    800032f6:	6902                	ld	s2,0(sp)
    800032f8:	bfbd                	j	80003276 <ilock+0x1e>
      panic("ilock: no type");
    800032fa:	00004517          	auipc	a0,0x4
    800032fe:	21e50513          	addi	a0,a0,542 # 80007518 <etext+0x518>
    80003302:	ca0fd0ef          	jal	800007a2 <panic>

0000000080003306 <iunlock>:
{
    80003306:	1101                	addi	sp,sp,-32
    80003308:	ec06                	sd	ra,24(sp)
    8000330a:	e822                	sd	s0,16(sp)
    8000330c:	e426                	sd	s1,8(sp)
    8000330e:	e04a                	sd	s2,0(sp)
    80003310:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003312:	c505                	beqz	a0,8000333a <iunlock+0x34>
    80003314:	84aa                	mv	s1,a0
    80003316:	01050913          	addi	s2,a0,16
    8000331a:	854a                	mv	a0,s2
    8000331c:	2db000ef          	jal	80003df6 <holdingsleep>
    80003320:	cd09                	beqz	a0,8000333a <iunlock+0x34>
    80003322:	449c                	lw	a5,8(s1)
    80003324:	00f05b63          	blez	a5,8000333a <iunlock+0x34>
  releasesleep(&ip->lock);
    80003328:	854a                	mv	a0,s2
    8000332a:	295000ef          	jal	80003dbe <releasesleep>
}
    8000332e:	60e2                	ld	ra,24(sp)
    80003330:	6442                	ld	s0,16(sp)
    80003332:	64a2                	ld	s1,8(sp)
    80003334:	6902                	ld	s2,0(sp)
    80003336:	6105                	addi	sp,sp,32
    80003338:	8082                	ret
    panic("iunlock");
    8000333a:	00004517          	auipc	a0,0x4
    8000333e:	1ee50513          	addi	a0,a0,494 # 80007528 <etext+0x528>
    80003342:	c60fd0ef          	jal	800007a2 <panic>

0000000080003346 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003346:	7179                	addi	sp,sp,-48
    80003348:	f406                	sd	ra,40(sp)
    8000334a:	f022                	sd	s0,32(sp)
    8000334c:	ec26                	sd	s1,24(sp)
    8000334e:	e84a                	sd	s2,16(sp)
    80003350:	e44e                	sd	s3,8(sp)
    80003352:	1800                	addi	s0,sp,48
    80003354:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003356:	05050493          	addi	s1,a0,80
    8000335a:	08050913          	addi	s2,a0,128
    8000335e:	a021                	j	80003366 <itrunc+0x20>
    80003360:	0491                	addi	s1,s1,4
    80003362:	01248b63          	beq	s1,s2,80003378 <itrunc+0x32>
    if(ip->addrs[i]){
    80003366:	408c                	lw	a1,0(s1)
    80003368:	dde5                	beqz	a1,80003360 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000336a:	0009a503          	lw	a0,0(s3)
    8000336e:	9abff0ef          	jal	80002d18 <bfree>
      ip->addrs[i] = 0;
    80003372:	0004a023          	sw	zero,0(s1)
    80003376:	b7ed                	j	80003360 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003378:	0809a583          	lw	a1,128(s3)
    8000337c:	ed89                	bnez	a1,80003396 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000337e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003382:	854e                	mv	a0,s3
    80003384:	e21ff0ef          	jal	800031a4 <iupdate>
}
    80003388:	70a2                	ld	ra,40(sp)
    8000338a:	7402                	ld	s0,32(sp)
    8000338c:	64e2                	ld	s1,24(sp)
    8000338e:	6942                	ld	s2,16(sp)
    80003390:	69a2                	ld	s3,8(sp)
    80003392:	6145                	addi	sp,sp,48
    80003394:	8082                	ret
    80003396:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003398:	0009a503          	lw	a0,0(s3)
    8000339c:	f84ff0ef          	jal	80002b20 <bread>
    800033a0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800033a2:	05850493          	addi	s1,a0,88
    800033a6:	45850913          	addi	s2,a0,1112
    800033aa:	a021                	j	800033b2 <itrunc+0x6c>
    800033ac:	0491                	addi	s1,s1,4
    800033ae:	01248963          	beq	s1,s2,800033c0 <itrunc+0x7a>
      if(a[j])
    800033b2:	408c                	lw	a1,0(s1)
    800033b4:	dde5                	beqz	a1,800033ac <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800033b6:	0009a503          	lw	a0,0(s3)
    800033ba:	95fff0ef          	jal	80002d18 <bfree>
    800033be:	b7fd                	j	800033ac <itrunc+0x66>
    brelse(bp);
    800033c0:	8552                	mv	a0,s4
    800033c2:	867ff0ef          	jal	80002c28 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800033c6:	0809a583          	lw	a1,128(s3)
    800033ca:	0009a503          	lw	a0,0(s3)
    800033ce:	94bff0ef          	jal	80002d18 <bfree>
    ip->addrs[NDIRECT] = 0;
    800033d2:	0809a023          	sw	zero,128(s3)
    800033d6:	6a02                	ld	s4,0(sp)
    800033d8:	b75d                	j	8000337e <itrunc+0x38>

00000000800033da <iput>:
{
    800033da:	1101                	addi	sp,sp,-32
    800033dc:	ec06                	sd	ra,24(sp)
    800033de:	e822                	sd	s0,16(sp)
    800033e0:	e426                	sd	s1,8(sp)
    800033e2:	1000                	addi	s0,sp,32
    800033e4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800033e6:	0001d517          	auipc	a0,0x1d
    800033ea:	5b250513          	addi	a0,a0,1458 # 80020998 <itable>
    800033ee:	815fd0ef          	jal	80000c02 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800033f2:	4498                	lw	a4,8(s1)
    800033f4:	4785                	li	a5,1
    800033f6:	02f70063          	beq	a4,a5,80003416 <iput+0x3c>
  ip->ref--;
    800033fa:	449c                	lw	a5,8(s1)
    800033fc:	37fd                	addiw	a5,a5,-1
    800033fe:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003400:	0001d517          	auipc	a0,0x1d
    80003404:	59850513          	addi	a0,a0,1432 # 80020998 <itable>
    80003408:	893fd0ef          	jal	80000c9a <release>
}
    8000340c:	60e2                	ld	ra,24(sp)
    8000340e:	6442                	ld	s0,16(sp)
    80003410:	64a2                	ld	s1,8(sp)
    80003412:	6105                	addi	sp,sp,32
    80003414:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003416:	40bc                	lw	a5,64(s1)
    80003418:	d3ed                	beqz	a5,800033fa <iput+0x20>
    8000341a:	04a49783          	lh	a5,74(s1)
    8000341e:	fff1                	bnez	a5,800033fa <iput+0x20>
    80003420:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003422:	01048913          	addi	s2,s1,16
    80003426:	854a                	mv	a0,s2
    80003428:	151000ef          	jal	80003d78 <acquiresleep>
    release(&itable.lock);
    8000342c:	0001d517          	auipc	a0,0x1d
    80003430:	56c50513          	addi	a0,a0,1388 # 80020998 <itable>
    80003434:	867fd0ef          	jal	80000c9a <release>
    itrunc(ip);
    80003438:	8526                	mv	a0,s1
    8000343a:	f0dff0ef          	jal	80003346 <itrunc>
    ip->type = 0;
    8000343e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003442:	8526                	mv	a0,s1
    80003444:	d61ff0ef          	jal	800031a4 <iupdate>
    ip->valid = 0;
    80003448:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000344c:	854a                	mv	a0,s2
    8000344e:	171000ef          	jal	80003dbe <releasesleep>
    acquire(&itable.lock);
    80003452:	0001d517          	auipc	a0,0x1d
    80003456:	54650513          	addi	a0,a0,1350 # 80020998 <itable>
    8000345a:	fa8fd0ef          	jal	80000c02 <acquire>
    8000345e:	6902                	ld	s2,0(sp)
    80003460:	bf69                	j	800033fa <iput+0x20>

0000000080003462 <iunlockput>:
{
    80003462:	1101                	addi	sp,sp,-32
    80003464:	ec06                	sd	ra,24(sp)
    80003466:	e822                	sd	s0,16(sp)
    80003468:	e426                	sd	s1,8(sp)
    8000346a:	1000                	addi	s0,sp,32
    8000346c:	84aa                	mv	s1,a0
  iunlock(ip);
    8000346e:	e99ff0ef          	jal	80003306 <iunlock>
  iput(ip);
    80003472:	8526                	mv	a0,s1
    80003474:	f67ff0ef          	jal	800033da <iput>
}
    80003478:	60e2                	ld	ra,24(sp)
    8000347a:	6442                	ld	s0,16(sp)
    8000347c:	64a2                	ld	s1,8(sp)
    8000347e:	6105                	addi	sp,sp,32
    80003480:	8082                	ret

0000000080003482 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003482:	1141                	addi	sp,sp,-16
    80003484:	e422                	sd	s0,8(sp)
    80003486:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003488:	411c                	lw	a5,0(a0)
    8000348a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000348c:	415c                	lw	a5,4(a0)
    8000348e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003490:	04451783          	lh	a5,68(a0)
    80003494:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003498:	04a51783          	lh	a5,74(a0)
    8000349c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800034a0:	04c56783          	lwu	a5,76(a0)
    800034a4:	e99c                	sd	a5,16(a1)
}
    800034a6:	6422                	ld	s0,8(sp)
    800034a8:	0141                	addi	sp,sp,16
    800034aa:	8082                	ret

00000000800034ac <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800034ac:	457c                	lw	a5,76(a0)
    800034ae:	0ed7eb63          	bltu	a5,a3,800035a4 <readi+0xf8>
{
    800034b2:	7159                	addi	sp,sp,-112
    800034b4:	f486                	sd	ra,104(sp)
    800034b6:	f0a2                	sd	s0,96(sp)
    800034b8:	eca6                	sd	s1,88(sp)
    800034ba:	e0d2                	sd	s4,64(sp)
    800034bc:	fc56                	sd	s5,56(sp)
    800034be:	f85a                	sd	s6,48(sp)
    800034c0:	f45e                	sd	s7,40(sp)
    800034c2:	1880                	addi	s0,sp,112
    800034c4:	8b2a                	mv	s6,a0
    800034c6:	8bae                	mv	s7,a1
    800034c8:	8a32                	mv	s4,a2
    800034ca:	84b6                	mv	s1,a3
    800034cc:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800034ce:	9f35                	addw	a4,a4,a3
    return 0;
    800034d0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800034d2:	0cd76063          	bltu	a4,a3,80003592 <readi+0xe6>
    800034d6:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800034d8:	00e7f463          	bgeu	a5,a4,800034e0 <readi+0x34>
    n = ip->size - off;
    800034dc:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800034e0:	080a8f63          	beqz	s5,8000357e <readi+0xd2>
    800034e4:	e8ca                	sd	s2,80(sp)
    800034e6:	f062                	sd	s8,32(sp)
    800034e8:	ec66                	sd	s9,24(sp)
    800034ea:	e86a                	sd	s10,16(sp)
    800034ec:	e46e                	sd	s11,8(sp)
    800034ee:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800034f0:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800034f4:	5c7d                	li	s8,-1
    800034f6:	a80d                	j	80003528 <readi+0x7c>
    800034f8:	020d1d93          	slli	s11,s10,0x20
    800034fc:	020ddd93          	srli	s11,s11,0x20
    80003500:	05890613          	addi	a2,s2,88
    80003504:	86ee                	mv	a3,s11
    80003506:	963a                	add	a2,a2,a4
    80003508:	85d2                	mv	a1,s4
    8000350a:	855e                	mv	a0,s7
    8000350c:	d31fe0ef          	jal	8000223c <either_copyout>
    80003510:	05850763          	beq	a0,s8,8000355e <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003514:	854a                	mv	a0,s2
    80003516:	f12ff0ef          	jal	80002c28 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000351a:	013d09bb          	addw	s3,s10,s3
    8000351e:	009d04bb          	addw	s1,s10,s1
    80003522:	9a6e                	add	s4,s4,s11
    80003524:	0559f763          	bgeu	s3,s5,80003572 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80003528:	00a4d59b          	srliw	a1,s1,0xa
    8000352c:	855a                	mv	a0,s6
    8000352e:	977ff0ef          	jal	80002ea4 <bmap>
    80003532:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003536:	c5b1                	beqz	a1,80003582 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80003538:	000b2503          	lw	a0,0(s6)
    8000353c:	de4ff0ef          	jal	80002b20 <bread>
    80003540:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003542:	3ff4f713          	andi	a4,s1,1023
    80003546:	40ec87bb          	subw	a5,s9,a4
    8000354a:	413a86bb          	subw	a3,s5,s3
    8000354e:	8d3e                	mv	s10,a5
    80003550:	2781                	sext.w	a5,a5
    80003552:	0006861b          	sext.w	a2,a3
    80003556:	faf671e3          	bgeu	a2,a5,800034f8 <readi+0x4c>
    8000355a:	8d36                	mv	s10,a3
    8000355c:	bf71                	j	800034f8 <readi+0x4c>
      brelse(bp);
    8000355e:	854a                	mv	a0,s2
    80003560:	ec8ff0ef          	jal	80002c28 <brelse>
      tot = -1;
    80003564:	59fd                	li	s3,-1
      break;
    80003566:	6946                	ld	s2,80(sp)
    80003568:	7c02                	ld	s8,32(sp)
    8000356a:	6ce2                	ld	s9,24(sp)
    8000356c:	6d42                	ld	s10,16(sp)
    8000356e:	6da2                	ld	s11,8(sp)
    80003570:	a831                	j	8000358c <readi+0xe0>
    80003572:	6946                	ld	s2,80(sp)
    80003574:	7c02                	ld	s8,32(sp)
    80003576:	6ce2                	ld	s9,24(sp)
    80003578:	6d42                	ld	s10,16(sp)
    8000357a:	6da2                	ld	s11,8(sp)
    8000357c:	a801                	j	8000358c <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000357e:	89d6                	mv	s3,s5
    80003580:	a031                	j	8000358c <readi+0xe0>
    80003582:	6946                	ld	s2,80(sp)
    80003584:	7c02                	ld	s8,32(sp)
    80003586:	6ce2                	ld	s9,24(sp)
    80003588:	6d42                	ld	s10,16(sp)
    8000358a:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000358c:	0009851b          	sext.w	a0,s3
    80003590:	69a6                	ld	s3,72(sp)
}
    80003592:	70a6                	ld	ra,104(sp)
    80003594:	7406                	ld	s0,96(sp)
    80003596:	64e6                	ld	s1,88(sp)
    80003598:	6a06                	ld	s4,64(sp)
    8000359a:	7ae2                	ld	s5,56(sp)
    8000359c:	7b42                	ld	s6,48(sp)
    8000359e:	7ba2                	ld	s7,40(sp)
    800035a0:	6165                	addi	sp,sp,112
    800035a2:	8082                	ret
    return 0;
    800035a4:	4501                	li	a0,0
}
    800035a6:	8082                	ret

00000000800035a8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800035a8:	457c                	lw	a5,76(a0)
    800035aa:	10d7e063          	bltu	a5,a3,800036aa <writei+0x102>
{
    800035ae:	7159                	addi	sp,sp,-112
    800035b0:	f486                	sd	ra,104(sp)
    800035b2:	f0a2                	sd	s0,96(sp)
    800035b4:	e8ca                	sd	s2,80(sp)
    800035b6:	e0d2                	sd	s4,64(sp)
    800035b8:	fc56                	sd	s5,56(sp)
    800035ba:	f85a                	sd	s6,48(sp)
    800035bc:	f45e                	sd	s7,40(sp)
    800035be:	1880                	addi	s0,sp,112
    800035c0:	8aaa                	mv	s5,a0
    800035c2:	8bae                	mv	s7,a1
    800035c4:	8a32                	mv	s4,a2
    800035c6:	8936                	mv	s2,a3
    800035c8:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800035ca:	00e687bb          	addw	a5,a3,a4
    800035ce:	0ed7e063          	bltu	a5,a3,800036ae <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800035d2:	00043737          	lui	a4,0x43
    800035d6:	0cf76e63          	bltu	a4,a5,800036b2 <writei+0x10a>
    800035da:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800035dc:	0a0b0f63          	beqz	s6,8000369a <writei+0xf2>
    800035e0:	eca6                	sd	s1,88(sp)
    800035e2:	f062                	sd	s8,32(sp)
    800035e4:	ec66                	sd	s9,24(sp)
    800035e6:	e86a                	sd	s10,16(sp)
    800035e8:	e46e                	sd	s11,8(sp)
    800035ea:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800035ec:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800035f0:	5c7d                	li	s8,-1
    800035f2:	a825                	j	8000362a <writei+0x82>
    800035f4:	020d1d93          	slli	s11,s10,0x20
    800035f8:	020ddd93          	srli	s11,s11,0x20
    800035fc:	05848513          	addi	a0,s1,88
    80003600:	86ee                	mv	a3,s11
    80003602:	8652                	mv	a2,s4
    80003604:	85de                	mv	a1,s7
    80003606:	953a                	add	a0,a0,a4
    80003608:	c7ffe0ef          	jal	80002286 <either_copyin>
    8000360c:	05850a63          	beq	a0,s8,80003660 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003610:	8526                	mv	a0,s1
    80003612:	660000ef          	jal	80003c72 <log_write>
    brelse(bp);
    80003616:	8526                	mv	a0,s1
    80003618:	e10ff0ef          	jal	80002c28 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000361c:	013d09bb          	addw	s3,s10,s3
    80003620:	012d093b          	addw	s2,s10,s2
    80003624:	9a6e                	add	s4,s4,s11
    80003626:	0569f063          	bgeu	s3,s6,80003666 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    8000362a:	00a9559b          	srliw	a1,s2,0xa
    8000362e:	8556                	mv	a0,s5
    80003630:	875ff0ef          	jal	80002ea4 <bmap>
    80003634:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003638:	c59d                	beqz	a1,80003666 <writei+0xbe>
    bp = bread(ip->dev, addr);
    8000363a:	000aa503          	lw	a0,0(s5)
    8000363e:	ce2ff0ef          	jal	80002b20 <bread>
    80003642:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003644:	3ff97713          	andi	a4,s2,1023
    80003648:	40ec87bb          	subw	a5,s9,a4
    8000364c:	413b06bb          	subw	a3,s6,s3
    80003650:	8d3e                	mv	s10,a5
    80003652:	2781                	sext.w	a5,a5
    80003654:	0006861b          	sext.w	a2,a3
    80003658:	f8f67ee3          	bgeu	a2,a5,800035f4 <writei+0x4c>
    8000365c:	8d36                	mv	s10,a3
    8000365e:	bf59                	j	800035f4 <writei+0x4c>
      brelse(bp);
    80003660:	8526                	mv	a0,s1
    80003662:	dc6ff0ef          	jal	80002c28 <brelse>
  }

  if(off > ip->size)
    80003666:	04caa783          	lw	a5,76(s5)
    8000366a:	0327fa63          	bgeu	a5,s2,8000369e <writei+0xf6>
    ip->size = off;
    8000366e:	052aa623          	sw	s2,76(s5)
    80003672:	64e6                	ld	s1,88(sp)
    80003674:	7c02                	ld	s8,32(sp)
    80003676:	6ce2                	ld	s9,24(sp)
    80003678:	6d42                	ld	s10,16(sp)
    8000367a:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000367c:	8556                	mv	a0,s5
    8000367e:	b27ff0ef          	jal	800031a4 <iupdate>

  return tot;
    80003682:	0009851b          	sext.w	a0,s3
    80003686:	69a6                	ld	s3,72(sp)
}
    80003688:	70a6                	ld	ra,104(sp)
    8000368a:	7406                	ld	s0,96(sp)
    8000368c:	6946                	ld	s2,80(sp)
    8000368e:	6a06                	ld	s4,64(sp)
    80003690:	7ae2                	ld	s5,56(sp)
    80003692:	7b42                	ld	s6,48(sp)
    80003694:	7ba2                	ld	s7,40(sp)
    80003696:	6165                	addi	sp,sp,112
    80003698:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000369a:	89da                	mv	s3,s6
    8000369c:	b7c5                	j	8000367c <writei+0xd4>
    8000369e:	64e6                	ld	s1,88(sp)
    800036a0:	7c02                	ld	s8,32(sp)
    800036a2:	6ce2                	ld	s9,24(sp)
    800036a4:	6d42                	ld	s10,16(sp)
    800036a6:	6da2                	ld	s11,8(sp)
    800036a8:	bfd1                	j	8000367c <writei+0xd4>
    return -1;
    800036aa:	557d                	li	a0,-1
}
    800036ac:	8082                	ret
    return -1;
    800036ae:	557d                	li	a0,-1
    800036b0:	bfe1                	j	80003688 <writei+0xe0>
    return -1;
    800036b2:	557d                	li	a0,-1
    800036b4:	bfd1                	j	80003688 <writei+0xe0>

00000000800036b6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800036b6:	1141                	addi	sp,sp,-16
    800036b8:	e406                	sd	ra,8(sp)
    800036ba:	e022                	sd	s0,0(sp)
    800036bc:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800036be:	4639                	li	a2,14
    800036c0:	ee2fd0ef          	jal	80000da2 <strncmp>
}
    800036c4:	60a2                	ld	ra,8(sp)
    800036c6:	6402                	ld	s0,0(sp)
    800036c8:	0141                	addi	sp,sp,16
    800036ca:	8082                	ret

00000000800036cc <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800036cc:	7139                	addi	sp,sp,-64
    800036ce:	fc06                	sd	ra,56(sp)
    800036d0:	f822                	sd	s0,48(sp)
    800036d2:	f426                	sd	s1,40(sp)
    800036d4:	f04a                	sd	s2,32(sp)
    800036d6:	ec4e                	sd	s3,24(sp)
    800036d8:	e852                	sd	s4,16(sp)
    800036da:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800036dc:	04451703          	lh	a4,68(a0)
    800036e0:	4785                	li	a5,1
    800036e2:	00f71a63          	bne	a4,a5,800036f6 <dirlookup+0x2a>
    800036e6:	892a                	mv	s2,a0
    800036e8:	89ae                	mv	s3,a1
    800036ea:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800036ec:	457c                	lw	a5,76(a0)
    800036ee:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800036f0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800036f2:	e39d                	bnez	a5,80003718 <dirlookup+0x4c>
    800036f4:	a095                	j	80003758 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    800036f6:	00004517          	auipc	a0,0x4
    800036fa:	e3a50513          	addi	a0,a0,-454 # 80007530 <etext+0x530>
    800036fe:	8a4fd0ef          	jal	800007a2 <panic>
      panic("dirlookup read");
    80003702:	00004517          	auipc	a0,0x4
    80003706:	e4650513          	addi	a0,a0,-442 # 80007548 <etext+0x548>
    8000370a:	898fd0ef          	jal	800007a2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000370e:	24c1                	addiw	s1,s1,16
    80003710:	04c92783          	lw	a5,76(s2)
    80003714:	04f4f163          	bgeu	s1,a5,80003756 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003718:	4741                	li	a4,16
    8000371a:	86a6                	mv	a3,s1
    8000371c:	fc040613          	addi	a2,s0,-64
    80003720:	4581                	li	a1,0
    80003722:	854a                	mv	a0,s2
    80003724:	d89ff0ef          	jal	800034ac <readi>
    80003728:	47c1                	li	a5,16
    8000372a:	fcf51ce3          	bne	a0,a5,80003702 <dirlookup+0x36>
    if(de.inum == 0)
    8000372e:	fc045783          	lhu	a5,-64(s0)
    80003732:	dff1                	beqz	a5,8000370e <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003734:	fc240593          	addi	a1,s0,-62
    80003738:	854e                	mv	a0,s3
    8000373a:	f7dff0ef          	jal	800036b6 <namecmp>
    8000373e:	f961                	bnez	a0,8000370e <dirlookup+0x42>
      if(poff)
    80003740:	000a0463          	beqz	s4,80003748 <dirlookup+0x7c>
        *poff = off;
    80003744:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003748:	fc045583          	lhu	a1,-64(s0)
    8000374c:	00092503          	lw	a0,0(s2)
    80003750:	829ff0ef          	jal	80002f78 <iget>
    80003754:	a011                	j	80003758 <dirlookup+0x8c>
  return 0;
    80003756:	4501                	li	a0,0
}
    80003758:	70e2                	ld	ra,56(sp)
    8000375a:	7442                	ld	s0,48(sp)
    8000375c:	74a2                	ld	s1,40(sp)
    8000375e:	7902                	ld	s2,32(sp)
    80003760:	69e2                	ld	s3,24(sp)
    80003762:	6a42                	ld	s4,16(sp)
    80003764:	6121                	addi	sp,sp,64
    80003766:	8082                	ret

0000000080003768 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003768:	711d                	addi	sp,sp,-96
    8000376a:	ec86                	sd	ra,88(sp)
    8000376c:	e8a2                	sd	s0,80(sp)
    8000376e:	e4a6                	sd	s1,72(sp)
    80003770:	e0ca                	sd	s2,64(sp)
    80003772:	fc4e                	sd	s3,56(sp)
    80003774:	f852                	sd	s4,48(sp)
    80003776:	f456                	sd	s5,40(sp)
    80003778:	f05a                	sd	s6,32(sp)
    8000377a:	ec5e                	sd	s7,24(sp)
    8000377c:	e862                	sd	s8,16(sp)
    8000377e:	e466                	sd	s9,8(sp)
    80003780:	1080                	addi	s0,sp,96
    80003782:	84aa                	mv	s1,a0
    80003784:	8b2e                	mv	s6,a1
    80003786:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003788:	00054703          	lbu	a4,0(a0)
    8000378c:	02f00793          	li	a5,47
    80003790:	00f70e63          	beq	a4,a5,800037ac <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003794:	97efe0ef          	jal	80001912 <myproc>
    80003798:	15053503          	ld	a0,336(a0)
    8000379c:	a87ff0ef          	jal	80003222 <idup>
    800037a0:	8a2a                	mv	s4,a0
  while(*path == '/')
    800037a2:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800037a6:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800037a8:	4b85                	li	s7,1
    800037aa:	a871                	j	80003846 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    800037ac:	4585                	li	a1,1
    800037ae:	4505                	li	a0,1
    800037b0:	fc8ff0ef          	jal	80002f78 <iget>
    800037b4:	8a2a                	mv	s4,a0
    800037b6:	b7f5                	j	800037a2 <namex+0x3a>
      iunlockput(ip);
    800037b8:	8552                	mv	a0,s4
    800037ba:	ca9ff0ef          	jal	80003462 <iunlockput>
      return 0;
    800037be:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800037c0:	8552                	mv	a0,s4
    800037c2:	60e6                	ld	ra,88(sp)
    800037c4:	6446                	ld	s0,80(sp)
    800037c6:	64a6                	ld	s1,72(sp)
    800037c8:	6906                	ld	s2,64(sp)
    800037ca:	79e2                	ld	s3,56(sp)
    800037cc:	7a42                	ld	s4,48(sp)
    800037ce:	7aa2                	ld	s5,40(sp)
    800037d0:	7b02                	ld	s6,32(sp)
    800037d2:	6be2                	ld	s7,24(sp)
    800037d4:	6c42                	ld	s8,16(sp)
    800037d6:	6ca2                	ld	s9,8(sp)
    800037d8:	6125                	addi	sp,sp,96
    800037da:	8082                	ret
      iunlock(ip);
    800037dc:	8552                	mv	a0,s4
    800037de:	b29ff0ef          	jal	80003306 <iunlock>
      return ip;
    800037e2:	bff9                	j	800037c0 <namex+0x58>
      iunlockput(ip);
    800037e4:	8552                	mv	a0,s4
    800037e6:	c7dff0ef          	jal	80003462 <iunlockput>
      return 0;
    800037ea:	8a4e                	mv	s4,s3
    800037ec:	bfd1                	j	800037c0 <namex+0x58>
  len = path - s;
    800037ee:	40998633          	sub	a2,s3,s1
    800037f2:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800037f6:	099c5063          	bge	s8,s9,80003876 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    800037fa:	4639                	li	a2,14
    800037fc:	85a6                	mv	a1,s1
    800037fe:	8556                	mv	a0,s5
    80003800:	d32fd0ef          	jal	80000d32 <memmove>
    80003804:	84ce                	mv	s1,s3
  while(*path == '/')
    80003806:	0004c783          	lbu	a5,0(s1)
    8000380a:	01279763          	bne	a5,s2,80003818 <namex+0xb0>
    path++;
    8000380e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003810:	0004c783          	lbu	a5,0(s1)
    80003814:	ff278de3          	beq	a5,s2,8000380e <namex+0xa6>
    ilock(ip);
    80003818:	8552                	mv	a0,s4
    8000381a:	a3fff0ef          	jal	80003258 <ilock>
    if(ip->type != T_DIR){
    8000381e:	044a1783          	lh	a5,68(s4)
    80003822:	f9779be3          	bne	a5,s7,800037b8 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003826:	000b0563          	beqz	s6,80003830 <namex+0xc8>
    8000382a:	0004c783          	lbu	a5,0(s1)
    8000382e:	d7dd                	beqz	a5,800037dc <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003830:	4601                	li	a2,0
    80003832:	85d6                	mv	a1,s5
    80003834:	8552                	mv	a0,s4
    80003836:	e97ff0ef          	jal	800036cc <dirlookup>
    8000383a:	89aa                	mv	s3,a0
    8000383c:	d545                	beqz	a0,800037e4 <namex+0x7c>
    iunlockput(ip);
    8000383e:	8552                	mv	a0,s4
    80003840:	c23ff0ef          	jal	80003462 <iunlockput>
    ip = next;
    80003844:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003846:	0004c783          	lbu	a5,0(s1)
    8000384a:	01279763          	bne	a5,s2,80003858 <namex+0xf0>
    path++;
    8000384e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003850:	0004c783          	lbu	a5,0(s1)
    80003854:	ff278de3          	beq	a5,s2,8000384e <namex+0xe6>
  if(*path == 0)
    80003858:	cb8d                	beqz	a5,8000388a <namex+0x122>
  while(*path != '/' && *path != 0)
    8000385a:	0004c783          	lbu	a5,0(s1)
    8000385e:	89a6                	mv	s3,s1
  len = path - s;
    80003860:	4c81                	li	s9,0
    80003862:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003864:	01278963          	beq	a5,s2,80003876 <namex+0x10e>
    80003868:	d3d9                	beqz	a5,800037ee <namex+0x86>
    path++;
    8000386a:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000386c:	0009c783          	lbu	a5,0(s3)
    80003870:	ff279ce3          	bne	a5,s2,80003868 <namex+0x100>
    80003874:	bfad                	j	800037ee <namex+0x86>
    memmove(name, s, len);
    80003876:	2601                	sext.w	a2,a2
    80003878:	85a6                	mv	a1,s1
    8000387a:	8556                	mv	a0,s5
    8000387c:	cb6fd0ef          	jal	80000d32 <memmove>
    name[len] = 0;
    80003880:	9cd6                	add	s9,s9,s5
    80003882:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003886:	84ce                	mv	s1,s3
    80003888:	bfbd                	j	80003806 <namex+0x9e>
  if(nameiparent){
    8000388a:	f20b0be3          	beqz	s6,800037c0 <namex+0x58>
    iput(ip);
    8000388e:	8552                	mv	a0,s4
    80003890:	b4bff0ef          	jal	800033da <iput>
    return 0;
    80003894:	4a01                	li	s4,0
    80003896:	b72d                	j	800037c0 <namex+0x58>

0000000080003898 <dirlink>:
{
    80003898:	7139                	addi	sp,sp,-64
    8000389a:	fc06                	sd	ra,56(sp)
    8000389c:	f822                	sd	s0,48(sp)
    8000389e:	f04a                	sd	s2,32(sp)
    800038a0:	ec4e                	sd	s3,24(sp)
    800038a2:	e852                	sd	s4,16(sp)
    800038a4:	0080                	addi	s0,sp,64
    800038a6:	892a                	mv	s2,a0
    800038a8:	8a2e                	mv	s4,a1
    800038aa:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800038ac:	4601                	li	a2,0
    800038ae:	e1fff0ef          	jal	800036cc <dirlookup>
    800038b2:	e535                	bnez	a0,8000391e <dirlink+0x86>
    800038b4:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800038b6:	04c92483          	lw	s1,76(s2)
    800038ba:	c48d                	beqz	s1,800038e4 <dirlink+0x4c>
    800038bc:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800038be:	4741                	li	a4,16
    800038c0:	86a6                	mv	a3,s1
    800038c2:	fc040613          	addi	a2,s0,-64
    800038c6:	4581                	li	a1,0
    800038c8:	854a                	mv	a0,s2
    800038ca:	be3ff0ef          	jal	800034ac <readi>
    800038ce:	47c1                	li	a5,16
    800038d0:	04f51b63          	bne	a0,a5,80003926 <dirlink+0x8e>
    if(de.inum == 0)
    800038d4:	fc045783          	lhu	a5,-64(s0)
    800038d8:	c791                	beqz	a5,800038e4 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800038da:	24c1                	addiw	s1,s1,16
    800038dc:	04c92783          	lw	a5,76(s2)
    800038e0:	fcf4efe3          	bltu	s1,a5,800038be <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    800038e4:	4639                	li	a2,14
    800038e6:	85d2                	mv	a1,s4
    800038e8:	fc240513          	addi	a0,s0,-62
    800038ec:	cecfd0ef          	jal	80000dd8 <strncpy>
  de.inum = inum;
    800038f0:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800038f4:	4741                	li	a4,16
    800038f6:	86a6                	mv	a3,s1
    800038f8:	fc040613          	addi	a2,s0,-64
    800038fc:	4581                	li	a1,0
    800038fe:	854a                	mv	a0,s2
    80003900:	ca9ff0ef          	jal	800035a8 <writei>
    80003904:	1541                	addi	a0,a0,-16
    80003906:	00a03533          	snez	a0,a0
    8000390a:	40a00533          	neg	a0,a0
    8000390e:	74a2                	ld	s1,40(sp)
}
    80003910:	70e2                	ld	ra,56(sp)
    80003912:	7442                	ld	s0,48(sp)
    80003914:	7902                	ld	s2,32(sp)
    80003916:	69e2                	ld	s3,24(sp)
    80003918:	6a42                	ld	s4,16(sp)
    8000391a:	6121                	addi	sp,sp,64
    8000391c:	8082                	ret
    iput(ip);
    8000391e:	abdff0ef          	jal	800033da <iput>
    return -1;
    80003922:	557d                	li	a0,-1
    80003924:	b7f5                	j	80003910 <dirlink+0x78>
      panic("dirlink read");
    80003926:	00004517          	auipc	a0,0x4
    8000392a:	c3250513          	addi	a0,a0,-974 # 80007558 <etext+0x558>
    8000392e:	e75fc0ef          	jal	800007a2 <panic>

0000000080003932 <namei>:

struct inode*
namei(char *path)
{
    80003932:	1101                	addi	sp,sp,-32
    80003934:	ec06                	sd	ra,24(sp)
    80003936:	e822                	sd	s0,16(sp)
    80003938:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000393a:	fe040613          	addi	a2,s0,-32
    8000393e:	4581                	li	a1,0
    80003940:	e29ff0ef          	jal	80003768 <namex>
}
    80003944:	60e2                	ld	ra,24(sp)
    80003946:	6442                	ld	s0,16(sp)
    80003948:	6105                	addi	sp,sp,32
    8000394a:	8082                	ret

000000008000394c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000394c:	1141                	addi	sp,sp,-16
    8000394e:	e406                	sd	ra,8(sp)
    80003950:	e022                	sd	s0,0(sp)
    80003952:	0800                	addi	s0,sp,16
    80003954:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003956:	4585                	li	a1,1
    80003958:	e11ff0ef          	jal	80003768 <namex>
}
    8000395c:	60a2                	ld	ra,8(sp)
    8000395e:	6402                	ld	s0,0(sp)
    80003960:	0141                	addi	sp,sp,16
    80003962:	8082                	ret

0000000080003964 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003964:	1101                	addi	sp,sp,-32
    80003966:	ec06                	sd	ra,24(sp)
    80003968:	e822                	sd	s0,16(sp)
    8000396a:	e426                	sd	s1,8(sp)
    8000396c:	e04a                	sd	s2,0(sp)
    8000396e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003970:	0001f917          	auipc	s2,0x1f
    80003974:	ad090913          	addi	s2,s2,-1328 # 80022440 <log>
    80003978:	01892583          	lw	a1,24(s2)
    8000397c:	02892503          	lw	a0,40(s2)
    80003980:	9a0ff0ef          	jal	80002b20 <bread>
    80003984:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003986:	02c92603          	lw	a2,44(s2)
    8000398a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000398c:	00c05f63          	blez	a2,800039aa <write_head+0x46>
    80003990:	0001f717          	auipc	a4,0x1f
    80003994:	ae070713          	addi	a4,a4,-1312 # 80022470 <log+0x30>
    80003998:	87aa                	mv	a5,a0
    8000399a:	060a                	slli	a2,a2,0x2
    8000399c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000399e:	4314                	lw	a3,0(a4)
    800039a0:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800039a2:	0711                	addi	a4,a4,4
    800039a4:	0791                	addi	a5,a5,4
    800039a6:	fec79ce3          	bne	a5,a2,8000399e <write_head+0x3a>
  }
  bwrite(buf);
    800039aa:	8526                	mv	a0,s1
    800039ac:	a4aff0ef          	jal	80002bf6 <bwrite>
  brelse(buf);
    800039b0:	8526                	mv	a0,s1
    800039b2:	a76ff0ef          	jal	80002c28 <brelse>
}
    800039b6:	60e2                	ld	ra,24(sp)
    800039b8:	6442                	ld	s0,16(sp)
    800039ba:	64a2                	ld	s1,8(sp)
    800039bc:	6902                	ld	s2,0(sp)
    800039be:	6105                	addi	sp,sp,32
    800039c0:	8082                	ret

00000000800039c2 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800039c2:	0001f797          	auipc	a5,0x1f
    800039c6:	aaa7a783          	lw	a5,-1366(a5) # 8002246c <log+0x2c>
    800039ca:	08f05f63          	blez	a5,80003a68 <install_trans+0xa6>
{
    800039ce:	7139                	addi	sp,sp,-64
    800039d0:	fc06                	sd	ra,56(sp)
    800039d2:	f822                	sd	s0,48(sp)
    800039d4:	f426                	sd	s1,40(sp)
    800039d6:	f04a                	sd	s2,32(sp)
    800039d8:	ec4e                	sd	s3,24(sp)
    800039da:	e852                	sd	s4,16(sp)
    800039dc:	e456                	sd	s5,8(sp)
    800039de:	e05a                	sd	s6,0(sp)
    800039e0:	0080                	addi	s0,sp,64
    800039e2:	8b2a                	mv	s6,a0
    800039e4:	0001fa97          	auipc	s5,0x1f
    800039e8:	a8ca8a93          	addi	s5,s5,-1396 # 80022470 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039ec:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800039ee:	0001f997          	auipc	s3,0x1f
    800039f2:	a5298993          	addi	s3,s3,-1454 # 80022440 <log>
    800039f6:	a829                	j	80003a10 <install_trans+0x4e>
    brelse(lbuf);
    800039f8:	854a                	mv	a0,s2
    800039fa:	a2eff0ef          	jal	80002c28 <brelse>
    brelse(dbuf);
    800039fe:	8526                	mv	a0,s1
    80003a00:	a28ff0ef          	jal	80002c28 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a04:	2a05                	addiw	s4,s4,1
    80003a06:	0a91                	addi	s5,s5,4
    80003a08:	02c9a783          	lw	a5,44(s3)
    80003a0c:	04fa5463          	bge	s4,a5,80003a54 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003a10:	0189a583          	lw	a1,24(s3)
    80003a14:	014585bb          	addw	a1,a1,s4
    80003a18:	2585                	addiw	a1,a1,1
    80003a1a:	0289a503          	lw	a0,40(s3)
    80003a1e:	902ff0ef          	jal	80002b20 <bread>
    80003a22:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003a24:	000aa583          	lw	a1,0(s5)
    80003a28:	0289a503          	lw	a0,40(s3)
    80003a2c:	8f4ff0ef          	jal	80002b20 <bread>
    80003a30:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003a32:	40000613          	li	a2,1024
    80003a36:	05890593          	addi	a1,s2,88
    80003a3a:	05850513          	addi	a0,a0,88
    80003a3e:	af4fd0ef          	jal	80000d32 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003a42:	8526                	mv	a0,s1
    80003a44:	9b2ff0ef          	jal	80002bf6 <bwrite>
    if(recovering == 0)
    80003a48:	fa0b18e3          	bnez	s6,800039f8 <install_trans+0x36>
      bunpin(dbuf);
    80003a4c:	8526                	mv	a0,s1
    80003a4e:	a96ff0ef          	jal	80002ce4 <bunpin>
    80003a52:	b75d                	j	800039f8 <install_trans+0x36>
}
    80003a54:	70e2                	ld	ra,56(sp)
    80003a56:	7442                	ld	s0,48(sp)
    80003a58:	74a2                	ld	s1,40(sp)
    80003a5a:	7902                	ld	s2,32(sp)
    80003a5c:	69e2                	ld	s3,24(sp)
    80003a5e:	6a42                	ld	s4,16(sp)
    80003a60:	6aa2                	ld	s5,8(sp)
    80003a62:	6b02                	ld	s6,0(sp)
    80003a64:	6121                	addi	sp,sp,64
    80003a66:	8082                	ret
    80003a68:	8082                	ret

0000000080003a6a <initlog>:
{
    80003a6a:	7179                	addi	sp,sp,-48
    80003a6c:	f406                	sd	ra,40(sp)
    80003a6e:	f022                	sd	s0,32(sp)
    80003a70:	ec26                	sd	s1,24(sp)
    80003a72:	e84a                	sd	s2,16(sp)
    80003a74:	e44e                	sd	s3,8(sp)
    80003a76:	1800                	addi	s0,sp,48
    80003a78:	892a                	mv	s2,a0
    80003a7a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003a7c:	0001f497          	auipc	s1,0x1f
    80003a80:	9c448493          	addi	s1,s1,-1596 # 80022440 <log>
    80003a84:	00004597          	auipc	a1,0x4
    80003a88:	ae458593          	addi	a1,a1,-1308 # 80007568 <etext+0x568>
    80003a8c:	8526                	mv	a0,s1
    80003a8e:	8f4fd0ef          	jal	80000b82 <initlock>
  log.start = sb->logstart;
    80003a92:	0149a583          	lw	a1,20(s3)
    80003a96:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003a98:	0109a783          	lw	a5,16(s3)
    80003a9c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003a9e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003aa2:	854a                	mv	a0,s2
    80003aa4:	87cff0ef          	jal	80002b20 <bread>
  log.lh.n = lh->n;
    80003aa8:	4d30                	lw	a2,88(a0)
    80003aaa:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003aac:	00c05f63          	blez	a2,80003aca <initlog+0x60>
    80003ab0:	87aa                	mv	a5,a0
    80003ab2:	0001f717          	auipc	a4,0x1f
    80003ab6:	9be70713          	addi	a4,a4,-1602 # 80022470 <log+0x30>
    80003aba:	060a                	slli	a2,a2,0x2
    80003abc:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003abe:	4ff4                	lw	a3,92(a5)
    80003ac0:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003ac2:	0791                	addi	a5,a5,4
    80003ac4:	0711                	addi	a4,a4,4
    80003ac6:	fec79ce3          	bne	a5,a2,80003abe <initlog+0x54>
  brelse(buf);
    80003aca:	95eff0ef          	jal	80002c28 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003ace:	4505                	li	a0,1
    80003ad0:	ef3ff0ef          	jal	800039c2 <install_trans>
  log.lh.n = 0;
    80003ad4:	0001f797          	auipc	a5,0x1f
    80003ad8:	9807ac23          	sw	zero,-1640(a5) # 8002246c <log+0x2c>
  write_head(); // clear the log
    80003adc:	e89ff0ef          	jal	80003964 <write_head>
}
    80003ae0:	70a2                	ld	ra,40(sp)
    80003ae2:	7402                	ld	s0,32(sp)
    80003ae4:	64e2                	ld	s1,24(sp)
    80003ae6:	6942                	ld	s2,16(sp)
    80003ae8:	69a2                	ld	s3,8(sp)
    80003aea:	6145                	addi	sp,sp,48
    80003aec:	8082                	ret

0000000080003aee <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003aee:	1101                	addi	sp,sp,-32
    80003af0:	ec06                	sd	ra,24(sp)
    80003af2:	e822                	sd	s0,16(sp)
    80003af4:	e426                	sd	s1,8(sp)
    80003af6:	e04a                	sd	s2,0(sp)
    80003af8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003afa:	0001f517          	auipc	a0,0x1f
    80003afe:	94650513          	addi	a0,a0,-1722 # 80022440 <log>
    80003b02:	900fd0ef          	jal	80000c02 <acquire>
  while(1){
    if(log.committing){
    80003b06:	0001f497          	auipc	s1,0x1f
    80003b0a:	93a48493          	addi	s1,s1,-1734 # 80022440 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003b0e:	4979                	li	s2,30
    80003b10:	a029                	j	80003b1a <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003b12:	85a6                	mv	a1,s1
    80003b14:	8526                	mv	a0,s1
    80003b16:	bcafe0ef          	jal	80001ee0 <sleep>
    if(log.committing){
    80003b1a:	50dc                	lw	a5,36(s1)
    80003b1c:	fbfd                	bnez	a5,80003b12 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003b1e:	5098                	lw	a4,32(s1)
    80003b20:	2705                	addiw	a4,a4,1
    80003b22:	0027179b          	slliw	a5,a4,0x2
    80003b26:	9fb9                	addw	a5,a5,a4
    80003b28:	0017979b          	slliw	a5,a5,0x1
    80003b2c:	54d4                	lw	a3,44(s1)
    80003b2e:	9fb5                	addw	a5,a5,a3
    80003b30:	00f95763          	bge	s2,a5,80003b3e <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003b34:	85a6                	mv	a1,s1
    80003b36:	8526                	mv	a0,s1
    80003b38:	ba8fe0ef          	jal	80001ee0 <sleep>
    80003b3c:	bff9                	j	80003b1a <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003b3e:	0001f517          	auipc	a0,0x1f
    80003b42:	90250513          	addi	a0,a0,-1790 # 80022440 <log>
    80003b46:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003b48:	952fd0ef          	jal	80000c9a <release>
      break;
    }
  }
}
    80003b4c:	60e2                	ld	ra,24(sp)
    80003b4e:	6442                	ld	s0,16(sp)
    80003b50:	64a2                	ld	s1,8(sp)
    80003b52:	6902                	ld	s2,0(sp)
    80003b54:	6105                	addi	sp,sp,32
    80003b56:	8082                	ret

0000000080003b58 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003b58:	7139                	addi	sp,sp,-64
    80003b5a:	fc06                	sd	ra,56(sp)
    80003b5c:	f822                	sd	s0,48(sp)
    80003b5e:	f426                	sd	s1,40(sp)
    80003b60:	f04a                	sd	s2,32(sp)
    80003b62:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003b64:	0001f497          	auipc	s1,0x1f
    80003b68:	8dc48493          	addi	s1,s1,-1828 # 80022440 <log>
    80003b6c:	8526                	mv	a0,s1
    80003b6e:	894fd0ef          	jal	80000c02 <acquire>
  log.outstanding -= 1;
    80003b72:	509c                	lw	a5,32(s1)
    80003b74:	37fd                	addiw	a5,a5,-1
    80003b76:	0007891b          	sext.w	s2,a5
    80003b7a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003b7c:	50dc                	lw	a5,36(s1)
    80003b7e:	ef9d                	bnez	a5,80003bbc <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003b80:	04091763          	bnez	s2,80003bce <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003b84:	0001f497          	auipc	s1,0x1f
    80003b88:	8bc48493          	addi	s1,s1,-1860 # 80022440 <log>
    80003b8c:	4785                	li	a5,1
    80003b8e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003b90:	8526                	mv	a0,s1
    80003b92:	908fd0ef          	jal	80000c9a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003b96:	54dc                	lw	a5,44(s1)
    80003b98:	04f04b63          	bgtz	a5,80003bee <end_op+0x96>
    acquire(&log.lock);
    80003b9c:	0001f497          	auipc	s1,0x1f
    80003ba0:	8a448493          	addi	s1,s1,-1884 # 80022440 <log>
    80003ba4:	8526                	mv	a0,s1
    80003ba6:	85cfd0ef          	jal	80000c02 <acquire>
    log.committing = 0;
    80003baa:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003bae:	8526                	mv	a0,s1
    80003bb0:	b7cfe0ef          	jal	80001f2c <wakeup>
    release(&log.lock);
    80003bb4:	8526                	mv	a0,s1
    80003bb6:	8e4fd0ef          	jal	80000c9a <release>
}
    80003bba:	a025                	j	80003be2 <end_op+0x8a>
    80003bbc:	ec4e                	sd	s3,24(sp)
    80003bbe:	e852                	sd	s4,16(sp)
    80003bc0:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003bc2:	00004517          	auipc	a0,0x4
    80003bc6:	9ae50513          	addi	a0,a0,-1618 # 80007570 <etext+0x570>
    80003bca:	bd9fc0ef          	jal	800007a2 <panic>
    wakeup(&log);
    80003bce:	0001f497          	auipc	s1,0x1f
    80003bd2:	87248493          	addi	s1,s1,-1934 # 80022440 <log>
    80003bd6:	8526                	mv	a0,s1
    80003bd8:	b54fe0ef          	jal	80001f2c <wakeup>
  release(&log.lock);
    80003bdc:	8526                	mv	a0,s1
    80003bde:	8bcfd0ef          	jal	80000c9a <release>
}
    80003be2:	70e2                	ld	ra,56(sp)
    80003be4:	7442                	ld	s0,48(sp)
    80003be6:	74a2                	ld	s1,40(sp)
    80003be8:	7902                	ld	s2,32(sp)
    80003bea:	6121                	addi	sp,sp,64
    80003bec:	8082                	ret
    80003bee:	ec4e                	sd	s3,24(sp)
    80003bf0:	e852                	sd	s4,16(sp)
    80003bf2:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bf4:	0001fa97          	auipc	s5,0x1f
    80003bf8:	87ca8a93          	addi	s5,s5,-1924 # 80022470 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003bfc:	0001fa17          	auipc	s4,0x1f
    80003c00:	844a0a13          	addi	s4,s4,-1980 # 80022440 <log>
    80003c04:	018a2583          	lw	a1,24(s4)
    80003c08:	012585bb          	addw	a1,a1,s2
    80003c0c:	2585                	addiw	a1,a1,1
    80003c0e:	028a2503          	lw	a0,40(s4)
    80003c12:	f0ffe0ef          	jal	80002b20 <bread>
    80003c16:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003c18:	000aa583          	lw	a1,0(s5)
    80003c1c:	028a2503          	lw	a0,40(s4)
    80003c20:	f01fe0ef          	jal	80002b20 <bread>
    80003c24:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003c26:	40000613          	li	a2,1024
    80003c2a:	05850593          	addi	a1,a0,88
    80003c2e:	05848513          	addi	a0,s1,88
    80003c32:	900fd0ef          	jal	80000d32 <memmove>
    bwrite(to);  // write the log
    80003c36:	8526                	mv	a0,s1
    80003c38:	fbffe0ef          	jal	80002bf6 <bwrite>
    brelse(from);
    80003c3c:	854e                	mv	a0,s3
    80003c3e:	febfe0ef          	jal	80002c28 <brelse>
    brelse(to);
    80003c42:	8526                	mv	a0,s1
    80003c44:	fe5fe0ef          	jal	80002c28 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c48:	2905                	addiw	s2,s2,1
    80003c4a:	0a91                	addi	s5,s5,4
    80003c4c:	02ca2783          	lw	a5,44(s4)
    80003c50:	faf94ae3          	blt	s2,a5,80003c04 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003c54:	d11ff0ef          	jal	80003964 <write_head>
    install_trans(0); // Now install writes to home locations
    80003c58:	4501                	li	a0,0
    80003c5a:	d69ff0ef          	jal	800039c2 <install_trans>
    log.lh.n = 0;
    80003c5e:	0001f797          	auipc	a5,0x1f
    80003c62:	8007a723          	sw	zero,-2034(a5) # 8002246c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003c66:	cffff0ef          	jal	80003964 <write_head>
    80003c6a:	69e2                	ld	s3,24(sp)
    80003c6c:	6a42                	ld	s4,16(sp)
    80003c6e:	6aa2                	ld	s5,8(sp)
    80003c70:	b735                	j	80003b9c <end_op+0x44>

0000000080003c72 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003c72:	1101                	addi	sp,sp,-32
    80003c74:	ec06                	sd	ra,24(sp)
    80003c76:	e822                	sd	s0,16(sp)
    80003c78:	e426                	sd	s1,8(sp)
    80003c7a:	e04a                	sd	s2,0(sp)
    80003c7c:	1000                	addi	s0,sp,32
    80003c7e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003c80:	0001e917          	auipc	s2,0x1e
    80003c84:	7c090913          	addi	s2,s2,1984 # 80022440 <log>
    80003c88:	854a                	mv	a0,s2
    80003c8a:	f79fc0ef          	jal	80000c02 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003c8e:	02c92603          	lw	a2,44(s2)
    80003c92:	47f5                	li	a5,29
    80003c94:	06c7c363          	blt	a5,a2,80003cfa <log_write+0x88>
    80003c98:	0001e797          	auipc	a5,0x1e
    80003c9c:	7c47a783          	lw	a5,1988(a5) # 8002245c <log+0x1c>
    80003ca0:	37fd                	addiw	a5,a5,-1
    80003ca2:	04f65c63          	bge	a2,a5,80003cfa <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003ca6:	0001e797          	auipc	a5,0x1e
    80003caa:	7ba7a783          	lw	a5,1978(a5) # 80022460 <log+0x20>
    80003cae:	04f05c63          	blez	a5,80003d06 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003cb2:	4781                	li	a5,0
    80003cb4:	04c05f63          	blez	a2,80003d12 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003cb8:	44cc                	lw	a1,12(s1)
    80003cba:	0001e717          	auipc	a4,0x1e
    80003cbe:	7b670713          	addi	a4,a4,1974 # 80022470 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003cc2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003cc4:	4314                	lw	a3,0(a4)
    80003cc6:	04b68663          	beq	a3,a1,80003d12 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003cca:	2785                	addiw	a5,a5,1
    80003ccc:	0711                	addi	a4,a4,4
    80003cce:	fef61be3          	bne	a2,a5,80003cc4 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003cd2:	0621                	addi	a2,a2,8
    80003cd4:	060a                	slli	a2,a2,0x2
    80003cd6:	0001e797          	auipc	a5,0x1e
    80003cda:	76a78793          	addi	a5,a5,1898 # 80022440 <log>
    80003cde:	97b2                	add	a5,a5,a2
    80003ce0:	44d8                	lw	a4,12(s1)
    80003ce2:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003ce4:	8526                	mv	a0,s1
    80003ce6:	fcbfe0ef          	jal	80002cb0 <bpin>
    log.lh.n++;
    80003cea:	0001e717          	auipc	a4,0x1e
    80003cee:	75670713          	addi	a4,a4,1878 # 80022440 <log>
    80003cf2:	575c                	lw	a5,44(a4)
    80003cf4:	2785                	addiw	a5,a5,1
    80003cf6:	d75c                	sw	a5,44(a4)
    80003cf8:	a80d                	j	80003d2a <log_write+0xb8>
    panic("too big a transaction");
    80003cfa:	00004517          	auipc	a0,0x4
    80003cfe:	88650513          	addi	a0,a0,-1914 # 80007580 <etext+0x580>
    80003d02:	aa1fc0ef          	jal	800007a2 <panic>
    panic("log_write outside of trans");
    80003d06:	00004517          	auipc	a0,0x4
    80003d0a:	89250513          	addi	a0,a0,-1902 # 80007598 <etext+0x598>
    80003d0e:	a95fc0ef          	jal	800007a2 <panic>
  log.lh.block[i] = b->blockno;
    80003d12:	00878693          	addi	a3,a5,8
    80003d16:	068a                	slli	a3,a3,0x2
    80003d18:	0001e717          	auipc	a4,0x1e
    80003d1c:	72870713          	addi	a4,a4,1832 # 80022440 <log>
    80003d20:	9736                	add	a4,a4,a3
    80003d22:	44d4                	lw	a3,12(s1)
    80003d24:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003d26:	faf60fe3          	beq	a2,a5,80003ce4 <log_write+0x72>
  }
  release(&log.lock);
    80003d2a:	0001e517          	auipc	a0,0x1e
    80003d2e:	71650513          	addi	a0,a0,1814 # 80022440 <log>
    80003d32:	f69fc0ef          	jal	80000c9a <release>
}
    80003d36:	60e2                	ld	ra,24(sp)
    80003d38:	6442                	ld	s0,16(sp)
    80003d3a:	64a2                	ld	s1,8(sp)
    80003d3c:	6902                	ld	s2,0(sp)
    80003d3e:	6105                	addi	sp,sp,32
    80003d40:	8082                	ret

0000000080003d42 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003d42:	1101                	addi	sp,sp,-32
    80003d44:	ec06                	sd	ra,24(sp)
    80003d46:	e822                	sd	s0,16(sp)
    80003d48:	e426                	sd	s1,8(sp)
    80003d4a:	e04a                	sd	s2,0(sp)
    80003d4c:	1000                	addi	s0,sp,32
    80003d4e:	84aa                	mv	s1,a0
    80003d50:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003d52:	00004597          	auipc	a1,0x4
    80003d56:	86658593          	addi	a1,a1,-1946 # 800075b8 <etext+0x5b8>
    80003d5a:	0521                	addi	a0,a0,8
    80003d5c:	e27fc0ef          	jal	80000b82 <initlock>
  lk->name = name;
    80003d60:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003d64:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003d68:	0204a423          	sw	zero,40(s1)
}
    80003d6c:	60e2                	ld	ra,24(sp)
    80003d6e:	6442                	ld	s0,16(sp)
    80003d70:	64a2                	ld	s1,8(sp)
    80003d72:	6902                	ld	s2,0(sp)
    80003d74:	6105                	addi	sp,sp,32
    80003d76:	8082                	ret

0000000080003d78 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003d78:	1101                	addi	sp,sp,-32
    80003d7a:	ec06                	sd	ra,24(sp)
    80003d7c:	e822                	sd	s0,16(sp)
    80003d7e:	e426                	sd	s1,8(sp)
    80003d80:	e04a                	sd	s2,0(sp)
    80003d82:	1000                	addi	s0,sp,32
    80003d84:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003d86:	00850913          	addi	s2,a0,8
    80003d8a:	854a                	mv	a0,s2
    80003d8c:	e77fc0ef          	jal	80000c02 <acquire>
  while (lk->locked) {
    80003d90:	409c                	lw	a5,0(s1)
    80003d92:	c799                	beqz	a5,80003da0 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003d94:	85ca                	mv	a1,s2
    80003d96:	8526                	mv	a0,s1
    80003d98:	948fe0ef          	jal	80001ee0 <sleep>
  while (lk->locked) {
    80003d9c:	409c                	lw	a5,0(s1)
    80003d9e:	fbfd                	bnez	a5,80003d94 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003da0:	4785                	li	a5,1
    80003da2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003da4:	b6ffd0ef          	jal	80001912 <myproc>
    80003da8:	591c                	lw	a5,48(a0)
    80003daa:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003dac:	854a                	mv	a0,s2
    80003dae:	eedfc0ef          	jal	80000c9a <release>
}
    80003db2:	60e2                	ld	ra,24(sp)
    80003db4:	6442                	ld	s0,16(sp)
    80003db6:	64a2                	ld	s1,8(sp)
    80003db8:	6902                	ld	s2,0(sp)
    80003dba:	6105                	addi	sp,sp,32
    80003dbc:	8082                	ret

0000000080003dbe <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003dbe:	1101                	addi	sp,sp,-32
    80003dc0:	ec06                	sd	ra,24(sp)
    80003dc2:	e822                	sd	s0,16(sp)
    80003dc4:	e426                	sd	s1,8(sp)
    80003dc6:	e04a                	sd	s2,0(sp)
    80003dc8:	1000                	addi	s0,sp,32
    80003dca:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003dcc:	00850913          	addi	s2,a0,8
    80003dd0:	854a                	mv	a0,s2
    80003dd2:	e31fc0ef          	jal	80000c02 <acquire>
  lk->locked = 0;
    80003dd6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003dda:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003dde:	8526                	mv	a0,s1
    80003de0:	94cfe0ef          	jal	80001f2c <wakeup>
  release(&lk->lk);
    80003de4:	854a                	mv	a0,s2
    80003de6:	eb5fc0ef          	jal	80000c9a <release>
}
    80003dea:	60e2                	ld	ra,24(sp)
    80003dec:	6442                	ld	s0,16(sp)
    80003dee:	64a2                	ld	s1,8(sp)
    80003df0:	6902                	ld	s2,0(sp)
    80003df2:	6105                	addi	sp,sp,32
    80003df4:	8082                	ret

0000000080003df6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003df6:	7179                	addi	sp,sp,-48
    80003df8:	f406                	sd	ra,40(sp)
    80003dfa:	f022                	sd	s0,32(sp)
    80003dfc:	ec26                	sd	s1,24(sp)
    80003dfe:	e84a                	sd	s2,16(sp)
    80003e00:	1800                	addi	s0,sp,48
    80003e02:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003e04:	00850913          	addi	s2,a0,8
    80003e08:	854a                	mv	a0,s2
    80003e0a:	df9fc0ef          	jal	80000c02 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003e0e:	409c                	lw	a5,0(s1)
    80003e10:	ef81                	bnez	a5,80003e28 <holdingsleep+0x32>
    80003e12:	4481                	li	s1,0
  release(&lk->lk);
    80003e14:	854a                	mv	a0,s2
    80003e16:	e85fc0ef          	jal	80000c9a <release>
  return r;
}
    80003e1a:	8526                	mv	a0,s1
    80003e1c:	70a2                	ld	ra,40(sp)
    80003e1e:	7402                	ld	s0,32(sp)
    80003e20:	64e2                	ld	s1,24(sp)
    80003e22:	6942                	ld	s2,16(sp)
    80003e24:	6145                	addi	sp,sp,48
    80003e26:	8082                	ret
    80003e28:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003e2a:	0284a983          	lw	s3,40(s1)
    80003e2e:	ae5fd0ef          	jal	80001912 <myproc>
    80003e32:	5904                	lw	s1,48(a0)
    80003e34:	413484b3          	sub	s1,s1,s3
    80003e38:	0014b493          	seqz	s1,s1
    80003e3c:	69a2                	ld	s3,8(sp)
    80003e3e:	bfd9                	j	80003e14 <holdingsleep+0x1e>

0000000080003e40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003e40:	1141                	addi	sp,sp,-16
    80003e42:	e406                	sd	ra,8(sp)
    80003e44:	e022                	sd	s0,0(sp)
    80003e46:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003e48:	00003597          	auipc	a1,0x3
    80003e4c:	78058593          	addi	a1,a1,1920 # 800075c8 <etext+0x5c8>
    80003e50:	0001e517          	auipc	a0,0x1e
    80003e54:	73850513          	addi	a0,a0,1848 # 80022588 <ftable>
    80003e58:	d2bfc0ef          	jal	80000b82 <initlock>
}
    80003e5c:	60a2                	ld	ra,8(sp)
    80003e5e:	6402                	ld	s0,0(sp)
    80003e60:	0141                	addi	sp,sp,16
    80003e62:	8082                	ret

0000000080003e64 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003e64:	1101                	addi	sp,sp,-32
    80003e66:	ec06                	sd	ra,24(sp)
    80003e68:	e822                	sd	s0,16(sp)
    80003e6a:	e426                	sd	s1,8(sp)
    80003e6c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003e6e:	0001e517          	auipc	a0,0x1e
    80003e72:	71a50513          	addi	a0,a0,1818 # 80022588 <ftable>
    80003e76:	d8dfc0ef          	jal	80000c02 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003e7a:	0001e497          	auipc	s1,0x1e
    80003e7e:	72648493          	addi	s1,s1,1830 # 800225a0 <ftable+0x18>
    80003e82:	0001f717          	auipc	a4,0x1f
    80003e86:	6be70713          	addi	a4,a4,1726 # 80023540 <disk>
    if(f->ref == 0){
    80003e8a:	40dc                	lw	a5,4(s1)
    80003e8c:	cf89                	beqz	a5,80003ea6 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003e8e:	02848493          	addi	s1,s1,40
    80003e92:	fee49ce3          	bne	s1,a4,80003e8a <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003e96:	0001e517          	auipc	a0,0x1e
    80003e9a:	6f250513          	addi	a0,a0,1778 # 80022588 <ftable>
    80003e9e:	dfdfc0ef          	jal	80000c9a <release>
  return 0;
    80003ea2:	4481                	li	s1,0
    80003ea4:	a809                	j	80003eb6 <filealloc+0x52>
      f->ref = 1;
    80003ea6:	4785                	li	a5,1
    80003ea8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003eaa:	0001e517          	auipc	a0,0x1e
    80003eae:	6de50513          	addi	a0,a0,1758 # 80022588 <ftable>
    80003eb2:	de9fc0ef          	jal	80000c9a <release>
}
    80003eb6:	8526                	mv	a0,s1
    80003eb8:	60e2                	ld	ra,24(sp)
    80003eba:	6442                	ld	s0,16(sp)
    80003ebc:	64a2                	ld	s1,8(sp)
    80003ebe:	6105                	addi	sp,sp,32
    80003ec0:	8082                	ret

0000000080003ec2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003ec2:	1101                	addi	sp,sp,-32
    80003ec4:	ec06                	sd	ra,24(sp)
    80003ec6:	e822                	sd	s0,16(sp)
    80003ec8:	e426                	sd	s1,8(sp)
    80003eca:	1000                	addi	s0,sp,32
    80003ecc:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ece:	0001e517          	auipc	a0,0x1e
    80003ed2:	6ba50513          	addi	a0,a0,1722 # 80022588 <ftable>
    80003ed6:	d2dfc0ef          	jal	80000c02 <acquire>
  if(f->ref < 1)
    80003eda:	40dc                	lw	a5,4(s1)
    80003edc:	02f05063          	blez	a5,80003efc <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003ee0:	2785                	addiw	a5,a5,1
    80003ee2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ee4:	0001e517          	auipc	a0,0x1e
    80003ee8:	6a450513          	addi	a0,a0,1700 # 80022588 <ftable>
    80003eec:	daffc0ef          	jal	80000c9a <release>
  return f;
}
    80003ef0:	8526                	mv	a0,s1
    80003ef2:	60e2                	ld	ra,24(sp)
    80003ef4:	6442                	ld	s0,16(sp)
    80003ef6:	64a2                	ld	s1,8(sp)
    80003ef8:	6105                	addi	sp,sp,32
    80003efa:	8082                	ret
    panic("filedup");
    80003efc:	00003517          	auipc	a0,0x3
    80003f00:	6d450513          	addi	a0,a0,1748 # 800075d0 <etext+0x5d0>
    80003f04:	89ffc0ef          	jal	800007a2 <panic>

0000000080003f08 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003f08:	7139                	addi	sp,sp,-64
    80003f0a:	fc06                	sd	ra,56(sp)
    80003f0c:	f822                	sd	s0,48(sp)
    80003f0e:	f426                	sd	s1,40(sp)
    80003f10:	0080                	addi	s0,sp,64
    80003f12:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003f14:	0001e517          	auipc	a0,0x1e
    80003f18:	67450513          	addi	a0,a0,1652 # 80022588 <ftable>
    80003f1c:	ce7fc0ef          	jal	80000c02 <acquire>
  if(f->ref < 1)
    80003f20:	40dc                	lw	a5,4(s1)
    80003f22:	04f05a63          	blez	a5,80003f76 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003f26:	37fd                	addiw	a5,a5,-1
    80003f28:	0007871b          	sext.w	a4,a5
    80003f2c:	c0dc                	sw	a5,4(s1)
    80003f2e:	04e04e63          	bgtz	a4,80003f8a <fileclose+0x82>
    80003f32:	f04a                	sd	s2,32(sp)
    80003f34:	ec4e                	sd	s3,24(sp)
    80003f36:	e852                	sd	s4,16(sp)
    80003f38:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003f3a:	0004a903          	lw	s2,0(s1)
    80003f3e:	0094ca83          	lbu	s5,9(s1)
    80003f42:	0104ba03          	ld	s4,16(s1)
    80003f46:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003f4a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003f4e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003f52:	0001e517          	auipc	a0,0x1e
    80003f56:	63650513          	addi	a0,a0,1590 # 80022588 <ftable>
    80003f5a:	d41fc0ef          	jal	80000c9a <release>

  if(ff.type == FD_PIPE){
    80003f5e:	4785                	li	a5,1
    80003f60:	04f90063          	beq	s2,a5,80003fa0 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003f64:	3979                	addiw	s2,s2,-2
    80003f66:	4785                	li	a5,1
    80003f68:	0527f563          	bgeu	a5,s2,80003fb2 <fileclose+0xaa>
    80003f6c:	7902                	ld	s2,32(sp)
    80003f6e:	69e2                	ld	s3,24(sp)
    80003f70:	6a42                	ld	s4,16(sp)
    80003f72:	6aa2                	ld	s5,8(sp)
    80003f74:	a00d                	j	80003f96 <fileclose+0x8e>
    80003f76:	f04a                	sd	s2,32(sp)
    80003f78:	ec4e                	sd	s3,24(sp)
    80003f7a:	e852                	sd	s4,16(sp)
    80003f7c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003f7e:	00003517          	auipc	a0,0x3
    80003f82:	65a50513          	addi	a0,a0,1626 # 800075d8 <etext+0x5d8>
    80003f86:	81dfc0ef          	jal	800007a2 <panic>
    release(&ftable.lock);
    80003f8a:	0001e517          	auipc	a0,0x1e
    80003f8e:	5fe50513          	addi	a0,a0,1534 # 80022588 <ftable>
    80003f92:	d09fc0ef          	jal	80000c9a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003f96:	70e2                	ld	ra,56(sp)
    80003f98:	7442                	ld	s0,48(sp)
    80003f9a:	74a2                	ld	s1,40(sp)
    80003f9c:	6121                	addi	sp,sp,64
    80003f9e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003fa0:	85d6                	mv	a1,s5
    80003fa2:	8552                	mv	a0,s4
    80003fa4:	336000ef          	jal	800042da <pipeclose>
    80003fa8:	7902                	ld	s2,32(sp)
    80003faa:	69e2                	ld	s3,24(sp)
    80003fac:	6a42                	ld	s4,16(sp)
    80003fae:	6aa2                	ld	s5,8(sp)
    80003fb0:	b7dd                	j	80003f96 <fileclose+0x8e>
    begin_op();
    80003fb2:	b3dff0ef          	jal	80003aee <begin_op>
    iput(ff.ip);
    80003fb6:	854e                	mv	a0,s3
    80003fb8:	c22ff0ef          	jal	800033da <iput>
    end_op();
    80003fbc:	b9dff0ef          	jal	80003b58 <end_op>
    80003fc0:	7902                	ld	s2,32(sp)
    80003fc2:	69e2                	ld	s3,24(sp)
    80003fc4:	6a42                	ld	s4,16(sp)
    80003fc6:	6aa2                	ld	s5,8(sp)
    80003fc8:	b7f9                	j	80003f96 <fileclose+0x8e>

0000000080003fca <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003fca:	715d                	addi	sp,sp,-80
    80003fcc:	e486                	sd	ra,72(sp)
    80003fce:	e0a2                	sd	s0,64(sp)
    80003fd0:	fc26                	sd	s1,56(sp)
    80003fd2:	f44e                	sd	s3,40(sp)
    80003fd4:	0880                	addi	s0,sp,80
    80003fd6:	84aa                	mv	s1,a0
    80003fd8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003fda:	939fd0ef          	jal	80001912 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003fde:	409c                	lw	a5,0(s1)
    80003fe0:	37f9                	addiw	a5,a5,-2
    80003fe2:	4705                	li	a4,1
    80003fe4:	04f76063          	bltu	a4,a5,80004024 <filestat+0x5a>
    80003fe8:	f84a                	sd	s2,48(sp)
    80003fea:	892a                	mv	s2,a0
    ilock(f->ip);
    80003fec:	6c88                	ld	a0,24(s1)
    80003fee:	a6aff0ef          	jal	80003258 <ilock>
    stati(f->ip, &st);
    80003ff2:	fb840593          	addi	a1,s0,-72
    80003ff6:	6c88                	ld	a0,24(s1)
    80003ff8:	c8aff0ef          	jal	80003482 <stati>
    iunlock(f->ip);
    80003ffc:	6c88                	ld	a0,24(s1)
    80003ffe:	b08ff0ef          	jal	80003306 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004002:	46e1                	li	a3,24
    80004004:	fb840613          	addi	a2,s0,-72
    80004008:	85ce                	mv	a1,s3
    8000400a:	05093503          	ld	a0,80(s2)
    8000400e:	d76fd0ef          	jal	80001584 <copyout>
    80004012:	41f5551b          	sraiw	a0,a0,0x1f
    80004016:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004018:	60a6                	ld	ra,72(sp)
    8000401a:	6406                	ld	s0,64(sp)
    8000401c:	74e2                	ld	s1,56(sp)
    8000401e:	79a2                	ld	s3,40(sp)
    80004020:	6161                	addi	sp,sp,80
    80004022:	8082                	ret
  return -1;
    80004024:	557d                	li	a0,-1
    80004026:	bfcd                	j	80004018 <filestat+0x4e>

0000000080004028 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004028:	7179                	addi	sp,sp,-48
    8000402a:	f406                	sd	ra,40(sp)
    8000402c:	f022                	sd	s0,32(sp)
    8000402e:	e84a                	sd	s2,16(sp)
    80004030:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004032:	00854783          	lbu	a5,8(a0)
    80004036:	cfd1                	beqz	a5,800040d2 <fileread+0xaa>
    80004038:	ec26                	sd	s1,24(sp)
    8000403a:	e44e                	sd	s3,8(sp)
    8000403c:	84aa                	mv	s1,a0
    8000403e:	89ae                	mv	s3,a1
    80004040:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004042:	411c                	lw	a5,0(a0)
    80004044:	4705                	li	a4,1
    80004046:	04e78363          	beq	a5,a4,8000408c <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000404a:	470d                	li	a4,3
    8000404c:	04e78763          	beq	a5,a4,8000409a <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004050:	4709                	li	a4,2
    80004052:	06e79a63          	bne	a5,a4,800040c6 <fileread+0x9e>
    ilock(f->ip);
    80004056:	6d08                	ld	a0,24(a0)
    80004058:	a00ff0ef          	jal	80003258 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000405c:	874a                	mv	a4,s2
    8000405e:	5094                	lw	a3,32(s1)
    80004060:	864e                	mv	a2,s3
    80004062:	4585                	li	a1,1
    80004064:	6c88                	ld	a0,24(s1)
    80004066:	c46ff0ef          	jal	800034ac <readi>
    8000406a:	892a                	mv	s2,a0
    8000406c:	00a05563          	blez	a0,80004076 <fileread+0x4e>
      f->off += r;
    80004070:	509c                	lw	a5,32(s1)
    80004072:	9fa9                	addw	a5,a5,a0
    80004074:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004076:	6c88                	ld	a0,24(s1)
    80004078:	a8eff0ef          	jal	80003306 <iunlock>
    8000407c:	64e2                	ld	s1,24(sp)
    8000407e:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004080:	854a                	mv	a0,s2
    80004082:	70a2                	ld	ra,40(sp)
    80004084:	7402                	ld	s0,32(sp)
    80004086:	6942                	ld	s2,16(sp)
    80004088:	6145                	addi	sp,sp,48
    8000408a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000408c:	6908                	ld	a0,16(a0)
    8000408e:	388000ef          	jal	80004416 <piperead>
    80004092:	892a                	mv	s2,a0
    80004094:	64e2                	ld	s1,24(sp)
    80004096:	69a2                	ld	s3,8(sp)
    80004098:	b7e5                	j	80004080 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000409a:	02451783          	lh	a5,36(a0)
    8000409e:	03079693          	slli	a3,a5,0x30
    800040a2:	92c1                	srli	a3,a3,0x30
    800040a4:	4725                	li	a4,9
    800040a6:	02d76863          	bltu	a4,a3,800040d6 <fileread+0xae>
    800040aa:	0792                	slli	a5,a5,0x4
    800040ac:	0001e717          	auipc	a4,0x1e
    800040b0:	43c70713          	addi	a4,a4,1084 # 800224e8 <devsw>
    800040b4:	97ba                	add	a5,a5,a4
    800040b6:	639c                	ld	a5,0(a5)
    800040b8:	c39d                	beqz	a5,800040de <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800040ba:	4505                	li	a0,1
    800040bc:	9782                	jalr	a5
    800040be:	892a                	mv	s2,a0
    800040c0:	64e2                	ld	s1,24(sp)
    800040c2:	69a2                	ld	s3,8(sp)
    800040c4:	bf75                	j	80004080 <fileread+0x58>
    panic("fileread");
    800040c6:	00003517          	auipc	a0,0x3
    800040ca:	52250513          	addi	a0,a0,1314 # 800075e8 <etext+0x5e8>
    800040ce:	ed4fc0ef          	jal	800007a2 <panic>
    return -1;
    800040d2:	597d                	li	s2,-1
    800040d4:	b775                	j	80004080 <fileread+0x58>
      return -1;
    800040d6:	597d                	li	s2,-1
    800040d8:	64e2                	ld	s1,24(sp)
    800040da:	69a2                	ld	s3,8(sp)
    800040dc:	b755                	j	80004080 <fileread+0x58>
    800040de:	597d                	li	s2,-1
    800040e0:	64e2                	ld	s1,24(sp)
    800040e2:	69a2                	ld	s3,8(sp)
    800040e4:	bf71                	j	80004080 <fileread+0x58>

00000000800040e6 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800040e6:	00954783          	lbu	a5,9(a0)
    800040ea:	10078b63          	beqz	a5,80004200 <filewrite+0x11a>
{
    800040ee:	715d                	addi	sp,sp,-80
    800040f0:	e486                	sd	ra,72(sp)
    800040f2:	e0a2                	sd	s0,64(sp)
    800040f4:	f84a                	sd	s2,48(sp)
    800040f6:	f052                	sd	s4,32(sp)
    800040f8:	e85a                	sd	s6,16(sp)
    800040fa:	0880                	addi	s0,sp,80
    800040fc:	892a                	mv	s2,a0
    800040fe:	8b2e                	mv	s6,a1
    80004100:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004102:	411c                	lw	a5,0(a0)
    80004104:	4705                	li	a4,1
    80004106:	02e78763          	beq	a5,a4,80004134 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000410a:	470d                	li	a4,3
    8000410c:	02e78863          	beq	a5,a4,8000413c <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004110:	4709                	li	a4,2
    80004112:	0ce79c63          	bne	a5,a4,800041ea <filewrite+0x104>
    80004116:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004118:	0ac05863          	blez	a2,800041c8 <filewrite+0xe2>
    8000411c:	fc26                	sd	s1,56(sp)
    8000411e:	ec56                	sd	s5,24(sp)
    80004120:	e45e                	sd	s7,8(sp)
    80004122:	e062                	sd	s8,0(sp)
    int i = 0;
    80004124:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004126:	6b85                	lui	s7,0x1
    80004128:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000412c:	6c05                	lui	s8,0x1
    8000412e:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004132:	a8b5                	j	800041ae <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80004134:	6908                	ld	a0,16(a0)
    80004136:	1fc000ef          	jal	80004332 <pipewrite>
    8000413a:	a04d                	j	800041dc <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000413c:	02451783          	lh	a5,36(a0)
    80004140:	03079693          	slli	a3,a5,0x30
    80004144:	92c1                	srli	a3,a3,0x30
    80004146:	4725                	li	a4,9
    80004148:	0ad76e63          	bltu	a4,a3,80004204 <filewrite+0x11e>
    8000414c:	0792                	slli	a5,a5,0x4
    8000414e:	0001e717          	auipc	a4,0x1e
    80004152:	39a70713          	addi	a4,a4,922 # 800224e8 <devsw>
    80004156:	97ba                	add	a5,a5,a4
    80004158:	679c                	ld	a5,8(a5)
    8000415a:	c7dd                	beqz	a5,80004208 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    8000415c:	4505                	li	a0,1
    8000415e:	9782                	jalr	a5
    80004160:	a8b5                	j	800041dc <filewrite+0xf6>
      if(n1 > max)
    80004162:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004166:	989ff0ef          	jal	80003aee <begin_op>
      ilock(f->ip);
    8000416a:	01893503          	ld	a0,24(s2)
    8000416e:	8eaff0ef          	jal	80003258 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004172:	8756                	mv	a4,s5
    80004174:	02092683          	lw	a3,32(s2)
    80004178:	01698633          	add	a2,s3,s6
    8000417c:	4585                	li	a1,1
    8000417e:	01893503          	ld	a0,24(s2)
    80004182:	c26ff0ef          	jal	800035a8 <writei>
    80004186:	84aa                	mv	s1,a0
    80004188:	00a05763          	blez	a0,80004196 <filewrite+0xb0>
        f->off += r;
    8000418c:	02092783          	lw	a5,32(s2)
    80004190:	9fa9                	addw	a5,a5,a0
    80004192:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004196:	01893503          	ld	a0,24(s2)
    8000419a:	96cff0ef          	jal	80003306 <iunlock>
      end_op();
    8000419e:	9bbff0ef          	jal	80003b58 <end_op>

      if(r != n1){
    800041a2:	029a9563          	bne	s5,s1,800041cc <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800041a6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800041aa:	0149da63          	bge	s3,s4,800041be <filewrite+0xd8>
      int n1 = n - i;
    800041ae:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800041b2:	0004879b          	sext.w	a5,s1
    800041b6:	fafbd6e3          	bge	s7,a5,80004162 <filewrite+0x7c>
    800041ba:	84e2                	mv	s1,s8
    800041bc:	b75d                	j	80004162 <filewrite+0x7c>
    800041be:	74e2                	ld	s1,56(sp)
    800041c0:	6ae2                	ld	s5,24(sp)
    800041c2:	6ba2                	ld	s7,8(sp)
    800041c4:	6c02                	ld	s8,0(sp)
    800041c6:	a039                	j	800041d4 <filewrite+0xee>
    int i = 0;
    800041c8:	4981                	li	s3,0
    800041ca:	a029                	j	800041d4 <filewrite+0xee>
    800041cc:	74e2                	ld	s1,56(sp)
    800041ce:	6ae2                	ld	s5,24(sp)
    800041d0:	6ba2                	ld	s7,8(sp)
    800041d2:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800041d4:	033a1c63          	bne	s4,s3,8000420c <filewrite+0x126>
    800041d8:	8552                	mv	a0,s4
    800041da:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800041dc:	60a6                	ld	ra,72(sp)
    800041de:	6406                	ld	s0,64(sp)
    800041e0:	7942                	ld	s2,48(sp)
    800041e2:	7a02                	ld	s4,32(sp)
    800041e4:	6b42                	ld	s6,16(sp)
    800041e6:	6161                	addi	sp,sp,80
    800041e8:	8082                	ret
    800041ea:	fc26                	sd	s1,56(sp)
    800041ec:	f44e                	sd	s3,40(sp)
    800041ee:	ec56                	sd	s5,24(sp)
    800041f0:	e45e                	sd	s7,8(sp)
    800041f2:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800041f4:	00003517          	auipc	a0,0x3
    800041f8:	40450513          	addi	a0,a0,1028 # 800075f8 <etext+0x5f8>
    800041fc:	da6fc0ef          	jal	800007a2 <panic>
    return -1;
    80004200:	557d                	li	a0,-1
}
    80004202:	8082                	ret
      return -1;
    80004204:	557d                	li	a0,-1
    80004206:	bfd9                	j	800041dc <filewrite+0xf6>
    80004208:	557d                	li	a0,-1
    8000420a:	bfc9                	j	800041dc <filewrite+0xf6>
    ret = (i == n ? n : -1);
    8000420c:	557d                	li	a0,-1
    8000420e:	79a2                	ld	s3,40(sp)
    80004210:	b7f1                	j	800041dc <filewrite+0xf6>

0000000080004212 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004212:	7179                	addi	sp,sp,-48
    80004214:	f406                	sd	ra,40(sp)
    80004216:	f022                	sd	s0,32(sp)
    80004218:	ec26                	sd	s1,24(sp)
    8000421a:	e052                	sd	s4,0(sp)
    8000421c:	1800                	addi	s0,sp,48
    8000421e:	84aa                	mv	s1,a0
    80004220:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004222:	0005b023          	sd	zero,0(a1)
    80004226:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000422a:	c3bff0ef          	jal	80003e64 <filealloc>
    8000422e:	e088                	sd	a0,0(s1)
    80004230:	c549                	beqz	a0,800042ba <pipealloc+0xa8>
    80004232:	c33ff0ef          	jal	80003e64 <filealloc>
    80004236:	00aa3023          	sd	a0,0(s4)
    8000423a:	cd25                	beqz	a0,800042b2 <pipealloc+0xa0>
    8000423c:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000423e:	8f5fc0ef          	jal	80000b32 <kalloc>
    80004242:	892a                	mv	s2,a0
    80004244:	c12d                	beqz	a0,800042a6 <pipealloc+0x94>
    80004246:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004248:	4985                	li	s3,1
    8000424a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000424e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004252:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004256:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000425a:	00003597          	auipc	a1,0x3
    8000425e:	3ae58593          	addi	a1,a1,942 # 80007608 <etext+0x608>
    80004262:	921fc0ef          	jal	80000b82 <initlock>
  (*f0)->type = FD_PIPE;
    80004266:	609c                	ld	a5,0(s1)
    80004268:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000426c:	609c                	ld	a5,0(s1)
    8000426e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004272:	609c                	ld	a5,0(s1)
    80004274:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004278:	609c                	ld	a5,0(s1)
    8000427a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000427e:	000a3783          	ld	a5,0(s4)
    80004282:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004286:	000a3783          	ld	a5,0(s4)
    8000428a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000428e:	000a3783          	ld	a5,0(s4)
    80004292:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004296:	000a3783          	ld	a5,0(s4)
    8000429a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000429e:	4501                	li	a0,0
    800042a0:	6942                	ld	s2,16(sp)
    800042a2:	69a2                	ld	s3,8(sp)
    800042a4:	a01d                	j	800042ca <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800042a6:	6088                	ld	a0,0(s1)
    800042a8:	c119                	beqz	a0,800042ae <pipealloc+0x9c>
    800042aa:	6942                	ld	s2,16(sp)
    800042ac:	a029                	j	800042b6 <pipealloc+0xa4>
    800042ae:	6942                	ld	s2,16(sp)
    800042b0:	a029                	j	800042ba <pipealloc+0xa8>
    800042b2:	6088                	ld	a0,0(s1)
    800042b4:	c10d                	beqz	a0,800042d6 <pipealloc+0xc4>
    fileclose(*f0);
    800042b6:	c53ff0ef          	jal	80003f08 <fileclose>
  if(*f1)
    800042ba:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800042be:	557d                	li	a0,-1
  if(*f1)
    800042c0:	c789                	beqz	a5,800042ca <pipealloc+0xb8>
    fileclose(*f1);
    800042c2:	853e                	mv	a0,a5
    800042c4:	c45ff0ef          	jal	80003f08 <fileclose>
  return -1;
    800042c8:	557d                	li	a0,-1
}
    800042ca:	70a2                	ld	ra,40(sp)
    800042cc:	7402                	ld	s0,32(sp)
    800042ce:	64e2                	ld	s1,24(sp)
    800042d0:	6a02                	ld	s4,0(sp)
    800042d2:	6145                	addi	sp,sp,48
    800042d4:	8082                	ret
  return -1;
    800042d6:	557d                	li	a0,-1
    800042d8:	bfcd                	j	800042ca <pipealloc+0xb8>

00000000800042da <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800042da:	1101                	addi	sp,sp,-32
    800042dc:	ec06                	sd	ra,24(sp)
    800042de:	e822                	sd	s0,16(sp)
    800042e0:	e426                	sd	s1,8(sp)
    800042e2:	e04a                	sd	s2,0(sp)
    800042e4:	1000                	addi	s0,sp,32
    800042e6:	84aa                	mv	s1,a0
    800042e8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800042ea:	919fc0ef          	jal	80000c02 <acquire>
  if(writable){
    800042ee:	02090763          	beqz	s2,8000431c <pipeclose+0x42>
    pi->writeopen = 0;
    800042f2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800042f6:	21848513          	addi	a0,s1,536
    800042fa:	c33fd0ef          	jal	80001f2c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800042fe:	2204b783          	ld	a5,544(s1)
    80004302:	e785                	bnez	a5,8000432a <pipeclose+0x50>
    release(&pi->lock);
    80004304:	8526                	mv	a0,s1
    80004306:	995fc0ef          	jal	80000c9a <release>
    kfree((char*)pi);
    8000430a:	8526                	mv	a0,s1
    8000430c:	f44fc0ef          	jal	80000a50 <kfree>
  } else
    release(&pi->lock);
}
    80004310:	60e2                	ld	ra,24(sp)
    80004312:	6442                	ld	s0,16(sp)
    80004314:	64a2                	ld	s1,8(sp)
    80004316:	6902                	ld	s2,0(sp)
    80004318:	6105                	addi	sp,sp,32
    8000431a:	8082                	ret
    pi->readopen = 0;
    8000431c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004320:	21c48513          	addi	a0,s1,540
    80004324:	c09fd0ef          	jal	80001f2c <wakeup>
    80004328:	bfd9                	j	800042fe <pipeclose+0x24>
    release(&pi->lock);
    8000432a:	8526                	mv	a0,s1
    8000432c:	96ffc0ef          	jal	80000c9a <release>
}
    80004330:	b7c5                	j	80004310 <pipeclose+0x36>

0000000080004332 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004332:	711d                	addi	sp,sp,-96
    80004334:	ec86                	sd	ra,88(sp)
    80004336:	e8a2                	sd	s0,80(sp)
    80004338:	e4a6                	sd	s1,72(sp)
    8000433a:	e0ca                	sd	s2,64(sp)
    8000433c:	fc4e                	sd	s3,56(sp)
    8000433e:	f852                	sd	s4,48(sp)
    80004340:	f456                	sd	s5,40(sp)
    80004342:	1080                	addi	s0,sp,96
    80004344:	84aa                	mv	s1,a0
    80004346:	8aae                	mv	s5,a1
    80004348:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000434a:	dc8fd0ef          	jal	80001912 <myproc>
    8000434e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004350:	8526                	mv	a0,s1
    80004352:	8b1fc0ef          	jal	80000c02 <acquire>
  while(i < n){
    80004356:	0b405a63          	blez	s4,8000440a <pipewrite+0xd8>
    8000435a:	f05a                	sd	s6,32(sp)
    8000435c:	ec5e                	sd	s7,24(sp)
    8000435e:	e862                	sd	s8,16(sp)
  int i = 0;
    80004360:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004362:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004364:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004368:	21c48b93          	addi	s7,s1,540
    8000436c:	a81d                	j	800043a2 <pipewrite+0x70>
      release(&pi->lock);
    8000436e:	8526                	mv	a0,s1
    80004370:	92bfc0ef          	jal	80000c9a <release>
      return -1;
    80004374:	597d                	li	s2,-1
    80004376:	7b02                	ld	s6,32(sp)
    80004378:	6be2                	ld	s7,24(sp)
    8000437a:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000437c:	854a                	mv	a0,s2
    8000437e:	60e6                	ld	ra,88(sp)
    80004380:	6446                	ld	s0,80(sp)
    80004382:	64a6                	ld	s1,72(sp)
    80004384:	6906                	ld	s2,64(sp)
    80004386:	79e2                	ld	s3,56(sp)
    80004388:	7a42                	ld	s4,48(sp)
    8000438a:	7aa2                	ld	s5,40(sp)
    8000438c:	6125                	addi	sp,sp,96
    8000438e:	8082                	ret
      wakeup(&pi->nread);
    80004390:	8562                	mv	a0,s8
    80004392:	b9bfd0ef          	jal	80001f2c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004396:	85a6                	mv	a1,s1
    80004398:	855e                	mv	a0,s7
    8000439a:	b47fd0ef          	jal	80001ee0 <sleep>
  while(i < n){
    8000439e:	05495b63          	bge	s2,s4,800043f4 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    800043a2:	2204a783          	lw	a5,544(s1)
    800043a6:	d7e1                	beqz	a5,8000436e <pipewrite+0x3c>
    800043a8:	854e                	mv	a0,s3
    800043aa:	d6ffd0ef          	jal	80002118 <killed>
    800043ae:	f161                	bnez	a0,8000436e <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800043b0:	2184a783          	lw	a5,536(s1)
    800043b4:	21c4a703          	lw	a4,540(s1)
    800043b8:	2007879b          	addiw	a5,a5,512
    800043bc:	fcf70ae3          	beq	a4,a5,80004390 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800043c0:	4685                	li	a3,1
    800043c2:	01590633          	add	a2,s2,s5
    800043c6:	faf40593          	addi	a1,s0,-81
    800043ca:	0509b503          	ld	a0,80(s3)
    800043ce:	a8cfd0ef          	jal	8000165a <copyin>
    800043d2:	03650e63          	beq	a0,s6,8000440e <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800043d6:	21c4a783          	lw	a5,540(s1)
    800043da:	0017871b          	addiw	a4,a5,1
    800043de:	20e4ae23          	sw	a4,540(s1)
    800043e2:	1ff7f793          	andi	a5,a5,511
    800043e6:	97a6                	add	a5,a5,s1
    800043e8:	faf44703          	lbu	a4,-81(s0)
    800043ec:	00e78c23          	sb	a4,24(a5)
      i++;
    800043f0:	2905                	addiw	s2,s2,1
    800043f2:	b775                	j	8000439e <pipewrite+0x6c>
    800043f4:	7b02                	ld	s6,32(sp)
    800043f6:	6be2                	ld	s7,24(sp)
    800043f8:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800043fa:	21848513          	addi	a0,s1,536
    800043fe:	b2ffd0ef          	jal	80001f2c <wakeup>
  release(&pi->lock);
    80004402:	8526                	mv	a0,s1
    80004404:	897fc0ef          	jal	80000c9a <release>
  return i;
    80004408:	bf95                	j	8000437c <pipewrite+0x4a>
  int i = 0;
    8000440a:	4901                	li	s2,0
    8000440c:	b7fd                	j	800043fa <pipewrite+0xc8>
    8000440e:	7b02                	ld	s6,32(sp)
    80004410:	6be2                	ld	s7,24(sp)
    80004412:	6c42                	ld	s8,16(sp)
    80004414:	b7dd                	j	800043fa <pipewrite+0xc8>

0000000080004416 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004416:	715d                	addi	sp,sp,-80
    80004418:	e486                	sd	ra,72(sp)
    8000441a:	e0a2                	sd	s0,64(sp)
    8000441c:	fc26                	sd	s1,56(sp)
    8000441e:	f84a                	sd	s2,48(sp)
    80004420:	f44e                	sd	s3,40(sp)
    80004422:	f052                	sd	s4,32(sp)
    80004424:	ec56                	sd	s5,24(sp)
    80004426:	0880                	addi	s0,sp,80
    80004428:	84aa                	mv	s1,a0
    8000442a:	892e                	mv	s2,a1
    8000442c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000442e:	ce4fd0ef          	jal	80001912 <myproc>
    80004432:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004434:	8526                	mv	a0,s1
    80004436:	fccfc0ef          	jal	80000c02 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000443a:	2184a703          	lw	a4,536(s1)
    8000443e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004442:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004446:	02f71563          	bne	a4,a5,80004470 <piperead+0x5a>
    8000444a:	2244a783          	lw	a5,548(s1)
    8000444e:	cb85                	beqz	a5,8000447e <piperead+0x68>
    if(killed(pr)){
    80004450:	8552                	mv	a0,s4
    80004452:	cc7fd0ef          	jal	80002118 <killed>
    80004456:	ed19                	bnez	a0,80004474 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004458:	85a6                	mv	a1,s1
    8000445a:	854e                	mv	a0,s3
    8000445c:	a85fd0ef          	jal	80001ee0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004460:	2184a703          	lw	a4,536(s1)
    80004464:	21c4a783          	lw	a5,540(s1)
    80004468:	fef701e3          	beq	a4,a5,8000444a <piperead+0x34>
    8000446c:	e85a                	sd	s6,16(sp)
    8000446e:	a809                	j	80004480 <piperead+0x6a>
    80004470:	e85a                	sd	s6,16(sp)
    80004472:	a039                	j	80004480 <piperead+0x6a>
      release(&pi->lock);
    80004474:	8526                	mv	a0,s1
    80004476:	825fc0ef          	jal	80000c9a <release>
      return -1;
    8000447a:	59fd                	li	s3,-1
    8000447c:	a8b1                	j	800044d8 <piperead+0xc2>
    8000447e:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004480:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004482:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004484:	05505263          	blez	s5,800044c8 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004488:	2184a783          	lw	a5,536(s1)
    8000448c:	21c4a703          	lw	a4,540(s1)
    80004490:	02f70c63          	beq	a4,a5,800044c8 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004494:	0017871b          	addiw	a4,a5,1
    80004498:	20e4ac23          	sw	a4,536(s1)
    8000449c:	1ff7f793          	andi	a5,a5,511
    800044a0:	97a6                	add	a5,a5,s1
    800044a2:	0187c783          	lbu	a5,24(a5)
    800044a6:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800044aa:	4685                	li	a3,1
    800044ac:	fbf40613          	addi	a2,s0,-65
    800044b0:	85ca                	mv	a1,s2
    800044b2:	050a3503          	ld	a0,80(s4)
    800044b6:	8cefd0ef          	jal	80001584 <copyout>
    800044ba:	01650763          	beq	a0,s6,800044c8 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800044be:	2985                	addiw	s3,s3,1
    800044c0:	0905                	addi	s2,s2,1
    800044c2:	fd3a93e3          	bne	s5,s3,80004488 <piperead+0x72>
    800044c6:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800044c8:	21c48513          	addi	a0,s1,540
    800044cc:	a61fd0ef          	jal	80001f2c <wakeup>
  release(&pi->lock);
    800044d0:	8526                	mv	a0,s1
    800044d2:	fc8fc0ef          	jal	80000c9a <release>
    800044d6:	6b42                	ld	s6,16(sp)
  return i;
}
    800044d8:	854e                	mv	a0,s3
    800044da:	60a6                	ld	ra,72(sp)
    800044dc:	6406                	ld	s0,64(sp)
    800044de:	74e2                	ld	s1,56(sp)
    800044e0:	7942                	ld	s2,48(sp)
    800044e2:	79a2                	ld	s3,40(sp)
    800044e4:	7a02                	ld	s4,32(sp)
    800044e6:	6ae2                	ld	s5,24(sp)
    800044e8:	6161                	addi	sp,sp,80
    800044ea:	8082                	ret

00000000800044ec <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800044ec:	1141                	addi	sp,sp,-16
    800044ee:	e422                	sd	s0,8(sp)
    800044f0:	0800                	addi	s0,sp,16
    800044f2:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800044f4:	8905                	andi	a0,a0,1
    800044f6:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800044f8:	8b89                	andi	a5,a5,2
    800044fa:	c399                	beqz	a5,80004500 <flags2perm+0x14>
      perm |= PTE_W;
    800044fc:	00456513          	ori	a0,a0,4
    return perm;
}
    80004500:	6422                	ld	s0,8(sp)
    80004502:	0141                	addi	sp,sp,16
    80004504:	8082                	ret

0000000080004506 <exec>:

int
exec(char *path, char **argv)
{
    80004506:	df010113          	addi	sp,sp,-528
    8000450a:	20113423          	sd	ra,520(sp)
    8000450e:	20813023          	sd	s0,512(sp)
    80004512:	ffa6                	sd	s1,504(sp)
    80004514:	fbca                	sd	s2,496(sp)
    80004516:	0c00                	addi	s0,sp,528
    80004518:	892a                	mv	s2,a0
    8000451a:	dea43c23          	sd	a0,-520(s0)
    8000451e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004522:	bf0fd0ef          	jal	80001912 <myproc>
    80004526:	84aa                	mv	s1,a0

  begin_op();
    80004528:	dc6ff0ef          	jal	80003aee <begin_op>

  if((ip = namei(path)) == 0){
    8000452c:	854a                	mv	a0,s2
    8000452e:	c04ff0ef          	jal	80003932 <namei>
    80004532:	c931                	beqz	a0,80004586 <exec+0x80>
    80004534:	f3d2                	sd	s4,480(sp)
    80004536:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004538:	d21fe0ef          	jal	80003258 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000453c:	04000713          	li	a4,64
    80004540:	4681                	li	a3,0
    80004542:	e5040613          	addi	a2,s0,-432
    80004546:	4581                	li	a1,0
    80004548:	8552                	mv	a0,s4
    8000454a:	f63fe0ef          	jal	800034ac <readi>
    8000454e:	04000793          	li	a5,64
    80004552:	00f51a63          	bne	a0,a5,80004566 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004556:	e5042703          	lw	a4,-432(s0)
    8000455a:	464c47b7          	lui	a5,0x464c4
    8000455e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004562:	02f70663          	beq	a4,a5,8000458e <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004566:	8552                	mv	a0,s4
    80004568:	efbfe0ef          	jal	80003462 <iunlockput>
    end_op();
    8000456c:	decff0ef          	jal	80003b58 <end_op>
  }
  return -1;
    80004570:	557d                	li	a0,-1
    80004572:	7a1e                	ld	s4,480(sp)
}
    80004574:	20813083          	ld	ra,520(sp)
    80004578:	20013403          	ld	s0,512(sp)
    8000457c:	74fe                	ld	s1,504(sp)
    8000457e:	795e                	ld	s2,496(sp)
    80004580:	21010113          	addi	sp,sp,528
    80004584:	8082                	ret
    end_op();
    80004586:	dd2ff0ef          	jal	80003b58 <end_op>
    return -1;
    8000458a:	557d                	li	a0,-1
    8000458c:	b7e5                	j	80004574 <exec+0x6e>
    8000458e:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004590:	8526                	mv	a0,s1
    80004592:	c28fd0ef          	jal	800019ba <proc_pagetable>
    80004596:	8b2a                	mv	s6,a0
    80004598:	2c050b63          	beqz	a0,8000486e <exec+0x368>
    8000459c:	f7ce                	sd	s3,488(sp)
    8000459e:	efd6                	sd	s5,472(sp)
    800045a0:	e7de                	sd	s7,456(sp)
    800045a2:	e3e2                	sd	s8,448(sp)
    800045a4:	ff66                	sd	s9,440(sp)
    800045a6:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045a8:	e7042d03          	lw	s10,-400(s0)
    800045ac:	e8845783          	lhu	a5,-376(s0)
    800045b0:	12078963          	beqz	a5,800046e2 <exec+0x1dc>
    800045b4:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800045b6:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045b8:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800045ba:	6c85                	lui	s9,0x1
    800045bc:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800045c0:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800045c4:	6a85                	lui	s5,0x1
    800045c6:	a085                	j	80004626 <exec+0x120>
      panic("loadseg: address should exist");
    800045c8:	00003517          	auipc	a0,0x3
    800045cc:	04850513          	addi	a0,a0,72 # 80007610 <etext+0x610>
    800045d0:	9d2fc0ef          	jal	800007a2 <panic>
    if(sz - i < PGSIZE)
    800045d4:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800045d6:	8726                	mv	a4,s1
    800045d8:	012c06bb          	addw	a3,s8,s2
    800045dc:	4581                	li	a1,0
    800045de:	8552                	mv	a0,s4
    800045e0:	ecdfe0ef          	jal	800034ac <readi>
    800045e4:	2501                	sext.w	a0,a0
    800045e6:	24a49a63          	bne	s1,a0,8000483a <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    800045ea:	012a893b          	addw	s2,s5,s2
    800045ee:	03397363          	bgeu	s2,s3,80004614 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    800045f2:	02091593          	slli	a1,s2,0x20
    800045f6:	9181                	srli	a1,a1,0x20
    800045f8:	95de                	add	a1,a1,s7
    800045fa:	855a                	mv	a0,s6
    800045fc:	9e9fc0ef          	jal	80000fe4 <walkaddr>
    80004600:	862a                	mv	a2,a0
    if(pa == 0)
    80004602:	d179                	beqz	a0,800045c8 <exec+0xc2>
    if(sz - i < PGSIZE)
    80004604:	412984bb          	subw	s1,s3,s2
    80004608:	0004879b          	sext.w	a5,s1
    8000460c:	fcfcf4e3          	bgeu	s9,a5,800045d4 <exec+0xce>
    80004610:	84d6                	mv	s1,s5
    80004612:	b7c9                	j	800045d4 <exec+0xce>
    sz = sz1;
    80004614:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004618:	2d85                	addiw	s11,s11,1
    8000461a:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    8000461e:	e8845783          	lhu	a5,-376(s0)
    80004622:	08fdd063          	bge	s11,a5,800046a2 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004626:	2d01                	sext.w	s10,s10
    80004628:	03800713          	li	a4,56
    8000462c:	86ea                	mv	a3,s10
    8000462e:	e1840613          	addi	a2,s0,-488
    80004632:	4581                	li	a1,0
    80004634:	8552                	mv	a0,s4
    80004636:	e77fe0ef          	jal	800034ac <readi>
    8000463a:	03800793          	li	a5,56
    8000463e:	1cf51663          	bne	a0,a5,8000480a <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004642:	e1842783          	lw	a5,-488(s0)
    80004646:	4705                	li	a4,1
    80004648:	fce798e3          	bne	a5,a4,80004618 <exec+0x112>
    if(ph.memsz < ph.filesz)
    8000464c:	e4043483          	ld	s1,-448(s0)
    80004650:	e3843783          	ld	a5,-456(s0)
    80004654:	1af4ef63          	bltu	s1,a5,80004812 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004658:	e2843783          	ld	a5,-472(s0)
    8000465c:	94be                	add	s1,s1,a5
    8000465e:	1af4ee63          	bltu	s1,a5,8000481a <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80004662:	df043703          	ld	a4,-528(s0)
    80004666:	8ff9                	and	a5,a5,a4
    80004668:	1a079d63          	bnez	a5,80004822 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000466c:	e1c42503          	lw	a0,-484(s0)
    80004670:	e7dff0ef          	jal	800044ec <flags2perm>
    80004674:	86aa                	mv	a3,a0
    80004676:	8626                	mv	a2,s1
    80004678:	85ca                	mv	a1,s2
    8000467a:	855a                	mv	a0,s6
    8000467c:	cf5fc0ef          	jal	80001370 <uvmalloc>
    80004680:	e0a43423          	sd	a0,-504(s0)
    80004684:	1a050363          	beqz	a0,8000482a <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004688:	e2843b83          	ld	s7,-472(s0)
    8000468c:	e2042c03          	lw	s8,-480(s0)
    80004690:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004694:	00098463          	beqz	s3,8000469c <exec+0x196>
    80004698:	4901                	li	s2,0
    8000469a:	bfa1                	j	800045f2 <exec+0xec>
    sz = sz1;
    8000469c:	e0843903          	ld	s2,-504(s0)
    800046a0:	bfa5                	j	80004618 <exec+0x112>
    800046a2:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800046a4:	8552                	mv	a0,s4
    800046a6:	dbdfe0ef          	jal	80003462 <iunlockput>
  end_op();
    800046aa:	caeff0ef          	jal	80003b58 <end_op>
  p = myproc();
    800046ae:	a64fd0ef          	jal	80001912 <myproc>
    800046b2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800046b4:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800046b8:	6985                	lui	s3,0x1
    800046ba:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800046bc:	99ca                	add	s3,s3,s2
    800046be:	77fd                	lui	a5,0xfffff
    800046c0:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800046c4:	4691                	li	a3,4
    800046c6:	6609                	lui	a2,0x2
    800046c8:	964e                	add	a2,a2,s3
    800046ca:	85ce                	mv	a1,s3
    800046cc:	855a                	mv	a0,s6
    800046ce:	ca3fc0ef          	jal	80001370 <uvmalloc>
    800046d2:	892a                	mv	s2,a0
    800046d4:	e0a43423          	sd	a0,-504(s0)
    800046d8:	e519                	bnez	a0,800046e6 <exec+0x1e0>
  if(pagetable)
    800046da:	e1343423          	sd	s3,-504(s0)
    800046de:	4a01                	li	s4,0
    800046e0:	aab1                	j	8000483c <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800046e2:	4901                	li	s2,0
    800046e4:	b7c1                	j	800046a4 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800046e6:	75f9                	lui	a1,0xffffe
    800046e8:	95aa                	add	a1,a1,a0
    800046ea:	855a                	mv	a0,s6
    800046ec:	e6ffc0ef          	jal	8000155a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800046f0:	7bfd                	lui	s7,0xfffff
    800046f2:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800046f4:	e0043783          	ld	a5,-512(s0)
    800046f8:	6388                	ld	a0,0(a5)
    800046fa:	cd39                	beqz	a0,80004758 <exec+0x252>
    800046fc:	e9040993          	addi	s3,s0,-368
    80004700:	f9040c13          	addi	s8,s0,-112
    80004704:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004706:	f40fc0ef          	jal	80000e46 <strlen>
    8000470a:	0015079b          	addiw	a5,a0,1
    8000470e:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004712:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004716:	11796e63          	bltu	s2,s7,80004832 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000471a:	e0043d03          	ld	s10,-512(s0)
    8000471e:	000d3a03          	ld	s4,0(s10)
    80004722:	8552                	mv	a0,s4
    80004724:	f22fc0ef          	jal	80000e46 <strlen>
    80004728:	0015069b          	addiw	a3,a0,1
    8000472c:	8652                	mv	a2,s4
    8000472e:	85ca                	mv	a1,s2
    80004730:	855a                	mv	a0,s6
    80004732:	e53fc0ef          	jal	80001584 <copyout>
    80004736:	10054063          	bltz	a0,80004836 <exec+0x330>
    ustack[argc] = sp;
    8000473a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000473e:	0485                	addi	s1,s1,1
    80004740:	008d0793          	addi	a5,s10,8
    80004744:	e0f43023          	sd	a5,-512(s0)
    80004748:	008d3503          	ld	a0,8(s10)
    8000474c:	c909                	beqz	a0,8000475e <exec+0x258>
    if(argc >= MAXARG)
    8000474e:	09a1                	addi	s3,s3,8
    80004750:	fb899be3          	bne	s3,s8,80004706 <exec+0x200>
  ip = 0;
    80004754:	4a01                	li	s4,0
    80004756:	a0dd                	j	8000483c <exec+0x336>
  sp = sz;
    80004758:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000475c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000475e:	00349793          	slli	a5,s1,0x3
    80004762:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb910>
    80004766:	97a2                	add	a5,a5,s0
    80004768:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000476c:	00148693          	addi	a3,s1,1
    80004770:	068e                	slli	a3,a3,0x3
    80004772:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004776:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000477a:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000477e:	f5796ee3          	bltu	s2,s7,800046da <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004782:	e9040613          	addi	a2,s0,-368
    80004786:	85ca                	mv	a1,s2
    80004788:	855a                	mv	a0,s6
    8000478a:	dfbfc0ef          	jal	80001584 <copyout>
    8000478e:	0e054263          	bltz	a0,80004872 <exec+0x36c>
  p->trapframe->a1 = sp;
    80004792:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004796:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000479a:	df843783          	ld	a5,-520(s0)
    8000479e:	0007c703          	lbu	a4,0(a5)
    800047a2:	cf11                	beqz	a4,800047be <exec+0x2b8>
    800047a4:	0785                	addi	a5,a5,1
    if(*s == '/')
    800047a6:	02f00693          	li	a3,47
    800047aa:	a039                	j	800047b8 <exec+0x2b2>
      last = s+1;
    800047ac:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800047b0:	0785                	addi	a5,a5,1
    800047b2:	fff7c703          	lbu	a4,-1(a5)
    800047b6:	c701                	beqz	a4,800047be <exec+0x2b8>
    if(*s == '/')
    800047b8:	fed71ce3          	bne	a4,a3,800047b0 <exec+0x2aa>
    800047bc:	bfc5                	j	800047ac <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    800047be:	4641                	li	a2,16
    800047c0:	df843583          	ld	a1,-520(s0)
    800047c4:	158a8513          	addi	a0,s5,344
    800047c8:	e4cfc0ef          	jal	80000e14 <safestrcpy>
  oldpagetable = p->pagetable;
    800047cc:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800047d0:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800047d4:	e0843783          	ld	a5,-504(s0)
    800047d8:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800047dc:	058ab783          	ld	a5,88(s5)
    800047e0:	e6843703          	ld	a4,-408(s0)
    800047e4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800047e6:	058ab783          	ld	a5,88(s5)
    800047ea:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800047ee:	85e6                	mv	a1,s9
    800047f0:	a4efd0ef          	jal	80001a3e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800047f4:	0004851b          	sext.w	a0,s1
    800047f8:	79be                	ld	s3,488(sp)
    800047fa:	7a1e                	ld	s4,480(sp)
    800047fc:	6afe                	ld	s5,472(sp)
    800047fe:	6b5e                	ld	s6,464(sp)
    80004800:	6bbe                	ld	s7,456(sp)
    80004802:	6c1e                	ld	s8,448(sp)
    80004804:	7cfa                	ld	s9,440(sp)
    80004806:	7d5a                	ld	s10,432(sp)
    80004808:	b3b5                	j	80004574 <exec+0x6e>
    8000480a:	e1243423          	sd	s2,-504(s0)
    8000480e:	7dba                	ld	s11,424(sp)
    80004810:	a035                	j	8000483c <exec+0x336>
    80004812:	e1243423          	sd	s2,-504(s0)
    80004816:	7dba                	ld	s11,424(sp)
    80004818:	a015                	j	8000483c <exec+0x336>
    8000481a:	e1243423          	sd	s2,-504(s0)
    8000481e:	7dba                	ld	s11,424(sp)
    80004820:	a831                	j	8000483c <exec+0x336>
    80004822:	e1243423          	sd	s2,-504(s0)
    80004826:	7dba                	ld	s11,424(sp)
    80004828:	a811                	j	8000483c <exec+0x336>
    8000482a:	e1243423          	sd	s2,-504(s0)
    8000482e:	7dba                	ld	s11,424(sp)
    80004830:	a031                	j	8000483c <exec+0x336>
  ip = 0;
    80004832:	4a01                	li	s4,0
    80004834:	a021                	j	8000483c <exec+0x336>
    80004836:	4a01                	li	s4,0
  if(pagetable)
    80004838:	a011                	j	8000483c <exec+0x336>
    8000483a:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    8000483c:	e0843583          	ld	a1,-504(s0)
    80004840:	855a                	mv	a0,s6
    80004842:	9fcfd0ef          	jal	80001a3e <proc_freepagetable>
  return -1;
    80004846:	557d                	li	a0,-1
  if(ip){
    80004848:	000a1b63          	bnez	s4,8000485e <exec+0x358>
    8000484c:	79be                	ld	s3,488(sp)
    8000484e:	7a1e                	ld	s4,480(sp)
    80004850:	6afe                	ld	s5,472(sp)
    80004852:	6b5e                	ld	s6,464(sp)
    80004854:	6bbe                	ld	s7,456(sp)
    80004856:	6c1e                	ld	s8,448(sp)
    80004858:	7cfa                	ld	s9,440(sp)
    8000485a:	7d5a                	ld	s10,432(sp)
    8000485c:	bb21                	j	80004574 <exec+0x6e>
    8000485e:	79be                	ld	s3,488(sp)
    80004860:	6afe                	ld	s5,472(sp)
    80004862:	6b5e                	ld	s6,464(sp)
    80004864:	6bbe                	ld	s7,456(sp)
    80004866:	6c1e                	ld	s8,448(sp)
    80004868:	7cfa                	ld	s9,440(sp)
    8000486a:	7d5a                	ld	s10,432(sp)
    8000486c:	b9ed                	j	80004566 <exec+0x60>
    8000486e:	6b5e                	ld	s6,464(sp)
    80004870:	b9dd                	j	80004566 <exec+0x60>
  sz = sz1;
    80004872:	e0843983          	ld	s3,-504(s0)
    80004876:	b595                	j	800046da <exec+0x1d4>

0000000080004878 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004878:	7179                	addi	sp,sp,-48
    8000487a:	f406                	sd	ra,40(sp)
    8000487c:	f022                	sd	s0,32(sp)
    8000487e:	ec26                	sd	s1,24(sp)
    80004880:	e84a                	sd	s2,16(sp)
    80004882:	1800                	addi	s0,sp,48
    80004884:	892e                	mv	s2,a1
    80004886:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004888:	fdc40593          	addi	a1,s0,-36
    8000488c:	f3bfd0ef          	jal	800027c6 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004890:	fdc42703          	lw	a4,-36(s0)
    80004894:	47bd                	li	a5,15
    80004896:	02e7e963          	bltu	a5,a4,800048c8 <argfd+0x50>
    8000489a:	878fd0ef          	jal	80001912 <myproc>
    8000489e:	fdc42703          	lw	a4,-36(s0)
    800048a2:	01a70793          	addi	a5,a4,26
    800048a6:	078e                	slli	a5,a5,0x3
    800048a8:	953e                	add	a0,a0,a5
    800048aa:	611c                	ld	a5,0(a0)
    800048ac:	c385                	beqz	a5,800048cc <argfd+0x54>
    return -1;
  if(pfd)
    800048ae:	00090463          	beqz	s2,800048b6 <argfd+0x3e>
    *pfd = fd;
    800048b2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800048b6:	4501                	li	a0,0
  if(pf)
    800048b8:	c091                	beqz	s1,800048bc <argfd+0x44>
    *pf = f;
    800048ba:	e09c                	sd	a5,0(s1)
}
    800048bc:	70a2                	ld	ra,40(sp)
    800048be:	7402                	ld	s0,32(sp)
    800048c0:	64e2                	ld	s1,24(sp)
    800048c2:	6942                	ld	s2,16(sp)
    800048c4:	6145                	addi	sp,sp,48
    800048c6:	8082                	ret
    return -1;
    800048c8:	557d                	li	a0,-1
    800048ca:	bfcd                	j	800048bc <argfd+0x44>
    800048cc:	557d                	li	a0,-1
    800048ce:	b7fd                	j	800048bc <argfd+0x44>

00000000800048d0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800048d0:	1101                	addi	sp,sp,-32
    800048d2:	ec06                	sd	ra,24(sp)
    800048d4:	e822                	sd	s0,16(sp)
    800048d6:	e426                	sd	s1,8(sp)
    800048d8:	1000                	addi	s0,sp,32
    800048da:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800048dc:	836fd0ef          	jal	80001912 <myproc>
    800048e0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800048e2:	0d050793          	addi	a5,a0,208
    800048e6:	4501                	li	a0,0
    800048e8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800048ea:	6398                	ld	a4,0(a5)
    800048ec:	cb19                	beqz	a4,80004902 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    800048ee:	2505                	addiw	a0,a0,1
    800048f0:	07a1                	addi	a5,a5,8
    800048f2:	fed51ce3          	bne	a0,a3,800048ea <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800048f6:	557d                	li	a0,-1
}
    800048f8:	60e2                	ld	ra,24(sp)
    800048fa:	6442                	ld	s0,16(sp)
    800048fc:	64a2                	ld	s1,8(sp)
    800048fe:	6105                	addi	sp,sp,32
    80004900:	8082                	ret
      p->ofile[fd] = f;
    80004902:	01a50793          	addi	a5,a0,26
    80004906:	078e                	slli	a5,a5,0x3
    80004908:	963e                	add	a2,a2,a5
    8000490a:	e204                	sd	s1,0(a2)
      return fd;
    8000490c:	b7f5                	j	800048f8 <fdalloc+0x28>

000000008000490e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000490e:	715d                	addi	sp,sp,-80
    80004910:	e486                	sd	ra,72(sp)
    80004912:	e0a2                	sd	s0,64(sp)
    80004914:	fc26                	sd	s1,56(sp)
    80004916:	f84a                	sd	s2,48(sp)
    80004918:	f44e                	sd	s3,40(sp)
    8000491a:	ec56                	sd	s5,24(sp)
    8000491c:	e85a                	sd	s6,16(sp)
    8000491e:	0880                	addi	s0,sp,80
    80004920:	8b2e                	mv	s6,a1
    80004922:	89b2                	mv	s3,a2
    80004924:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004926:	fb040593          	addi	a1,s0,-80
    8000492a:	822ff0ef          	jal	8000394c <nameiparent>
    8000492e:	84aa                	mv	s1,a0
    80004930:	10050a63          	beqz	a0,80004a44 <create+0x136>
    return 0;

  ilock(dp);
    80004934:	925fe0ef          	jal	80003258 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004938:	4601                	li	a2,0
    8000493a:	fb040593          	addi	a1,s0,-80
    8000493e:	8526                	mv	a0,s1
    80004940:	d8dfe0ef          	jal	800036cc <dirlookup>
    80004944:	8aaa                	mv	s5,a0
    80004946:	c129                	beqz	a0,80004988 <create+0x7a>
    iunlockput(dp);
    80004948:	8526                	mv	a0,s1
    8000494a:	b19fe0ef          	jal	80003462 <iunlockput>
    ilock(ip);
    8000494e:	8556                	mv	a0,s5
    80004950:	909fe0ef          	jal	80003258 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004954:	4789                	li	a5,2
    80004956:	02fb1463          	bne	s6,a5,8000497e <create+0x70>
    8000495a:	044ad783          	lhu	a5,68(s5)
    8000495e:	37f9                	addiw	a5,a5,-2
    80004960:	17c2                	slli	a5,a5,0x30
    80004962:	93c1                	srli	a5,a5,0x30
    80004964:	4705                	li	a4,1
    80004966:	00f76c63          	bltu	a4,a5,8000497e <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000496a:	8556                	mv	a0,s5
    8000496c:	60a6                	ld	ra,72(sp)
    8000496e:	6406                	ld	s0,64(sp)
    80004970:	74e2                	ld	s1,56(sp)
    80004972:	7942                	ld	s2,48(sp)
    80004974:	79a2                	ld	s3,40(sp)
    80004976:	6ae2                	ld	s5,24(sp)
    80004978:	6b42                	ld	s6,16(sp)
    8000497a:	6161                	addi	sp,sp,80
    8000497c:	8082                	ret
    iunlockput(ip);
    8000497e:	8556                	mv	a0,s5
    80004980:	ae3fe0ef          	jal	80003462 <iunlockput>
    return 0;
    80004984:	4a81                	li	s5,0
    80004986:	b7d5                	j	8000496a <create+0x5c>
    80004988:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    8000498a:	85da                	mv	a1,s6
    8000498c:	4088                	lw	a0,0(s1)
    8000498e:	f5afe0ef          	jal	800030e8 <ialloc>
    80004992:	8a2a                	mv	s4,a0
    80004994:	cd15                	beqz	a0,800049d0 <create+0xc2>
  ilock(ip);
    80004996:	8c3fe0ef          	jal	80003258 <ilock>
  ip->major = major;
    8000499a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000499e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800049a2:	4905                	li	s2,1
    800049a4:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800049a8:	8552                	mv	a0,s4
    800049aa:	ffafe0ef          	jal	800031a4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800049ae:	032b0763          	beq	s6,s2,800049dc <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    800049b2:	004a2603          	lw	a2,4(s4)
    800049b6:	fb040593          	addi	a1,s0,-80
    800049ba:	8526                	mv	a0,s1
    800049bc:	eddfe0ef          	jal	80003898 <dirlink>
    800049c0:	06054563          	bltz	a0,80004a2a <create+0x11c>
  iunlockput(dp);
    800049c4:	8526                	mv	a0,s1
    800049c6:	a9dfe0ef          	jal	80003462 <iunlockput>
  return ip;
    800049ca:	8ad2                	mv	s5,s4
    800049cc:	7a02                	ld	s4,32(sp)
    800049ce:	bf71                	j	8000496a <create+0x5c>
    iunlockput(dp);
    800049d0:	8526                	mv	a0,s1
    800049d2:	a91fe0ef          	jal	80003462 <iunlockput>
    return 0;
    800049d6:	8ad2                	mv	s5,s4
    800049d8:	7a02                	ld	s4,32(sp)
    800049da:	bf41                	j	8000496a <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800049dc:	004a2603          	lw	a2,4(s4)
    800049e0:	00003597          	auipc	a1,0x3
    800049e4:	c5058593          	addi	a1,a1,-944 # 80007630 <etext+0x630>
    800049e8:	8552                	mv	a0,s4
    800049ea:	eaffe0ef          	jal	80003898 <dirlink>
    800049ee:	02054e63          	bltz	a0,80004a2a <create+0x11c>
    800049f2:	40d0                	lw	a2,4(s1)
    800049f4:	00003597          	auipc	a1,0x3
    800049f8:	c4458593          	addi	a1,a1,-956 # 80007638 <etext+0x638>
    800049fc:	8552                	mv	a0,s4
    800049fe:	e9bfe0ef          	jal	80003898 <dirlink>
    80004a02:	02054463          	bltz	a0,80004a2a <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004a06:	004a2603          	lw	a2,4(s4)
    80004a0a:	fb040593          	addi	a1,s0,-80
    80004a0e:	8526                	mv	a0,s1
    80004a10:	e89fe0ef          	jal	80003898 <dirlink>
    80004a14:	00054b63          	bltz	a0,80004a2a <create+0x11c>
    dp->nlink++;  // for ".."
    80004a18:	04a4d783          	lhu	a5,74(s1)
    80004a1c:	2785                	addiw	a5,a5,1
    80004a1e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a22:	8526                	mv	a0,s1
    80004a24:	f80fe0ef          	jal	800031a4 <iupdate>
    80004a28:	bf71                	j	800049c4 <create+0xb6>
  ip->nlink = 0;
    80004a2a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004a2e:	8552                	mv	a0,s4
    80004a30:	f74fe0ef          	jal	800031a4 <iupdate>
  iunlockput(ip);
    80004a34:	8552                	mv	a0,s4
    80004a36:	a2dfe0ef          	jal	80003462 <iunlockput>
  iunlockput(dp);
    80004a3a:	8526                	mv	a0,s1
    80004a3c:	a27fe0ef          	jal	80003462 <iunlockput>
  return 0;
    80004a40:	7a02                	ld	s4,32(sp)
    80004a42:	b725                	j	8000496a <create+0x5c>
    return 0;
    80004a44:	8aaa                	mv	s5,a0
    80004a46:	b715                	j	8000496a <create+0x5c>

0000000080004a48 <sys_dup>:
{
    80004a48:	7179                	addi	sp,sp,-48
    80004a4a:	f406                	sd	ra,40(sp)
    80004a4c:	f022                	sd	s0,32(sp)
    80004a4e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004a50:	fd840613          	addi	a2,s0,-40
    80004a54:	4581                	li	a1,0
    80004a56:	4501                	li	a0,0
    80004a58:	e21ff0ef          	jal	80004878 <argfd>
    return -1;
    80004a5c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004a5e:	02054363          	bltz	a0,80004a84 <sys_dup+0x3c>
    80004a62:	ec26                	sd	s1,24(sp)
    80004a64:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004a66:	fd843903          	ld	s2,-40(s0)
    80004a6a:	854a                	mv	a0,s2
    80004a6c:	e65ff0ef          	jal	800048d0 <fdalloc>
    80004a70:	84aa                	mv	s1,a0
    return -1;
    80004a72:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004a74:	00054d63          	bltz	a0,80004a8e <sys_dup+0x46>
  filedup(f);
    80004a78:	854a                	mv	a0,s2
    80004a7a:	c48ff0ef          	jal	80003ec2 <filedup>
  return fd;
    80004a7e:	87a6                	mv	a5,s1
    80004a80:	64e2                	ld	s1,24(sp)
    80004a82:	6942                	ld	s2,16(sp)
}
    80004a84:	853e                	mv	a0,a5
    80004a86:	70a2                	ld	ra,40(sp)
    80004a88:	7402                	ld	s0,32(sp)
    80004a8a:	6145                	addi	sp,sp,48
    80004a8c:	8082                	ret
    80004a8e:	64e2                	ld	s1,24(sp)
    80004a90:	6942                	ld	s2,16(sp)
    80004a92:	bfcd                	j	80004a84 <sys_dup+0x3c>

0000000080004a94 <sys_read>:
{
    80004a94:	7179                	addi	sp,sp,-48
    80004a96:	f406                	sd	ra,40(sp)
    80004a98:	f022                	sd	s0,32(sp)
    80004a9a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004a9c:	fd840593          	addi	a1,s0,-40
    80004aa0:	4505                	li	a0,1
    80004aa2:	d41fd0ef          	jal	800027e2 <argaddr>
  argint(2, &n);
    80004aa6:	fe440593          	addi	a1,s0,-28
    80004aaa:	4509                	li	a0,2
    80004aac:	d1bfd0ef          	jal	800027c6 <argint>
  if(argfd(0, 0, &f) < 0)
    80004ab0:	fe840613          	addi	a2,s0,-24
    80004ab4:	4581                	li	a1,0
    80004ab6:	4501                	li	a0,0
    80004ab8:	dc1ff0ef          	jal	80004878 <argfd>
    80004abc:	87aa                	mv	a5,a0
    return -1;
    80004abe:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004ac0:	0007ca63          	bltz	a5,80004ad4 <sys_read+0x40>
  return fileread(f, p, n);
    80004ac4:	fe442603          	lw	a2,-28(s0)
    80004ac8:	fd843583          	ld	a1,-40(s0)
    80004acc:	fe843503          	ld	a0,-24(s0)
    80004ad0:	d58ff0ef          	jal	80004028 <fileread>
}
    80004ad4:	70a2                	ld	ra,40(sp)
    80004ad6:	7402                	ld	s0,32(sp)
    80004ad8:	6145                	addi	sp,sp,48
    80004ada:	8082                	ret

0000000080004adc <sys_write>:
{
    80004adc:	7179                	addi	sp,sp,-48
    80004ade:	f406                	sd	ra,40(sp)
    80004ae0:	f022                	sd	s0,32(sp)
    80004ae2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004ae4:	fd840593          	addi	a1,s0,-40
    80004ae8:	4505                	li	a0,1
    80004aea:	cf9fd0ef          	jal	800027e2 <argaddr>
  argint(2, &n);
    80004aee:	fe440593          	addi	a1,s0,-28
    80004af2:	4509                	li	a0,2
    80004af4:	cd3fd0ef          	jal	800027c6 <argint>
  if(argfd(0, 0, &f) < 0)
    80004af8:	fe840613          	addi	a2,s0,-24
    80004afc:	4581                	li	a1,0
    80004afe:	4501                	li	a0,0
    80004b00:	d79ff0ef          	jal	80004878 <argfd>
    80004b04:	87aa                	mv	a5,a0
    return -1;
    80004b06:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b08:	0007ca63          	bltz	a5,80004b1c <sys_write+0x40>
  return filewrite(f, p, n);
    80004b0c:	fe442603          	lw	a2,-28(s0)
    80004b10:	fd843583          	ld	a1,-40(s0)
    80004b14:	fe843503          	ld	a0,-24(s0)
    80004b18:	dceff0ef          	jal	800040e6 <filewrite>
}
    80004b1c:	70a2                	ld	ra,40(sp)
    80004b1e:	7402                	ld	s0,32(sp)
    80004b20:	6145                	addi	sp,sp,48
    80004b22:	8082                	ret

0000000080004b24 <sys_close>:
{
    80004b24:	1101                	addi	sp,sp,-32
    80004b26:	ec06                	sd	ra,24(sp)
    80004b28:	e822                	sd	s0,16(sp)
    80004b2a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004b2c:	fe040613          	addi	a2,s0,-32
    80004b30:	fec40593          	addi	a1,s0,-20
    80004b34:	4501                	li	a0,0
    80004b36:	d43ff0ef          	jal	80004878 <argfd>
    return -1;
    80004b3a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004b3c:	02054063          	bltz	a0,80004b5c <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004b40:	dd3fc0ef          	jal	80001912 <myproc>
    80004b44:	fec42783          	lw	a5,-20(s0)
    80004b48:	07e9                	addi	a5,a5,26
    80004b4a:	078e                	slli	a5,a5,0x3
    80004b4c:	953e                	add	a0,a0,a5
    80004b4e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004b52:	fe043503          	ld	a0,-32(s0)
    80004b56:	bb2ff0ef          	jal	80003f08 <fileclose>
  return 0;
    80004b5a:	4781                	li	a5,0
}
    80004b5c:	853e                	mv	a0,a5
    80004b5e:	60e2                	ld	ra,24(sp)
    80004b60:	6442                	ld	s0,16(sp)
    80004b62:	6105                	addi	sp,sp,32
    80004b64:	8082                	ret

0000000080004b66 <sys_fstat>:
{
    80004b66:	1101                	addi	sp,sp,-32
    80004b68:	ec06                	sd	ra,24(sp)
    80004b6a:	e822                	sd	s0,16(sp)
    80004b6c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004b6e:	fe040593          	addi	a1,s0,-32
    80004b72:	4505                	li	a0,1
    80004b74:	c6ffd0ef          	jal	800027e2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004b78:	fe840613          	addi	a2,s0,-24
    80004b7c:	4581                	li	a1,0
    80004b7e:	4501                	li	a0,0
    80004b80:	cf9ff0ef          	jal	80004878 <argfd>
    80004b84:	87aa                	mv	a5,a0
    return -1;
    80004b86:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b88:	0007c863          	bltz	a5,80004b98 <sys_fstat+0x32>
  return filestat(f, st);
    80004b8c:	fe043583          	ld	a1,-32(s0)
    80004b90:	fe843503          	ld	a0,-24(s0)
    80004b94:	c36ff0ef          	jal	80003fca <filestat>
}
    80004b98:	60e2                	ld	ra,24(sp)
    80004b9a:	6442                	ld	s0,16(sp)
    80004b9c:	6105                	addi	sp,sp,32
    80004b9e:	8082                	ret

0000000080004ba0 <sys_link>:
{
    80004ba0:	7169                	addi	sp,sp,-304
    80004ba2:	f606                	sd	ra,296(sp)
    80004ba4:	f222                	sd	s0,288(sp)
    80004ba6:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ba8:	08000613          	li	a2,128
    80004bac:	ed040593          	addi	a1,s0,-304
    80004bb0:	4501                	li	a0,0
    80004bb2:	c4ffd0ef          	jal	80002800 <argstr>
    return -1;
    80004bb6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004bb8:	0c054e63          	bltz	a0,80004c94 <sys_link+0xf4>
    80004bbc:	08000613          	li	a2,128
    80004bc0:	f5040593          	addi	a1,s0,-176
    80004bc4:	4505                	li	a0,1
    80004bc6:	c3bfd0ef          	jal	80002800 <argstr>
    return -1;
    80004bca:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004bcc:	0c054463          	bltz	a0,80004c94 <sys_link+0xf4>
    80004bd0:	ee26                	sd	s1,280(sp)
  begin_op();
    80004bd2:	f1dfe0ef          	jal	80003aee <begin_op>
  if((ip = namei(old)) == 0){
    80004bd6:	ed040513          	addi	a0,s0,-304
    80004bda:	d59fe0ef          	jal	80003932 <namei>
    80004bde:	84aa                	mv	s1,a0
    80004be0:	c53d                	beqz	a0,80004c4e <sys_link+0xae>
  ilock(ip);
    80004be2:	e76fe0ef          	jal	80003258 <ilock>
  if(ip->type == T_DIR){
    80004be6:	04449703          	lh	a4,68(s1)
    80004bea:	4785                	li	a5,1
    80004bec:	06f70663          	beq	a4,a5,80004c58 <sys_link+0xb8>
    80004bf0:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004bf2:	04a4d783          	lhu	a5,74(s1)
    80004bf6:	2785                	addiw	a5,a5,1
    80004bf8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004bfc:	8526                	mv	a0,s1
    80004bfe:	da6fe0ef          	jal	800031a4 <iupdate>
  iunlock(ip);
    80004c02:	8526                	mv	a0,s1
    80004c04:	f02fe0ef          	jal	80003306 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004c08:	fd040593          	addi	a1,s0,-48
    80004c0c:	f5040513          	addi	a0,s0,-176
    80004c10:	d3dfe0ef          	jal	8000394c <nameiparent>
    80004c14:	892a                	mv	s2,a0
    80004c16:	cd21                	beqz	a0,80004c6e <sys_link+0xce>
  ilock(dp);
    80004c18:	e40fe0ef          	jal	80003258 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004c1c:	00092703          	lw	a4,0(s2)
    80004c20:	409c                	lw	a5,0(s1)
    80004c22:	04f71363          	bne	a4,a5,80004c68 <sys_link+0xc8>
    80004c26:	40d0                	lw	a2,4(s1)
    80004c28:	fd040593          	addi	a1,s0,-48
    80004c2c:	854a                	mv	a0,s2
    80004c2e:	c6bfe0ef          	jal	80003898 <dirlink>
    80004c32:	02054b63          	bltz	a0,80004c68 <sys_link+0xc8>
  iunlockput(dp);
    80004c36:	854a                	mv	a0,s2
    80004c38:	82bfe0ef          	jal	80003462 <iunlockput>
  iput(ip);
    80004c3c:	8526                	mv	a0,s1
    80004c3e:	f9cfe0ef          	jal	800033da <iput>
  end_op();
    80004c42:	f17fe0ef          	jal	80003b58 <end_op>
  return 0;
    80004c46:	4781                	li	a5,0
    80004c48:	64f2                	ld	s1,280(sp)
    80004c4a:	6952                	ld	s2,272(sp)
    80004c4c:	a0a1                	j	80004c94 <sys_link+0xf4>
    end_op();
    80004c4e:	f0bfe0ef          	jal	80003b58 <end_op>
    return -1;
    80004c52:	57fd                	li	a5,-1
    80004c54:	64f2                	ld	s1,280(sp)
    80004c56:	a83d                	j	80004c94 <sys_link+0xf4>
    iunlockput(ip);
    80004c58:	8526                	mv	a0,s1
    80004c5a:	809fe0ef          	jal	80003462 <iunlockput>
    end_op();
    80004c5e:	efbfe0ef          	jal	80003b58 <end_op>
    return -1;
    80004c62:	57fd                	li	a5,-1
    80004c64:	64f2                	ld	s1,280(sp)
    80004c66:	a03d                	j	80004c94 <sys_link+0xf4>
    iunlockput(dp);
    80004c68:	854a                	mv	a0,s2
    80004c6a:	ff8fe0ef          	jal	80003462 <iunlockput>
  ilock(ip);
    80004c6e:	8526                	mv	a0,s1
    80004c70:	de8fe0ef          	jal	80003258 <ilock>
  ip->nlink--;
    80004c74:	04a4d783          	lhu	a5,74(s1)
    80004c78:	37fd                	addiw	a5,a5,-1
    80004c7a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c7e:	8526                	mv	a0,s1
    80004c80:	d24fe0ef          	jal	800031a4 <iupdate>
  iunlockput(ip);
    80004c84:	8526                	mv	a0,s1
    80004c86:	fdcfe0ef          	jal	80003462 <iunlockput>
  end_op();
    80004c8a:	ecffe0ef          	jal	80003b58 <end_op>
  return -1;
    80004c8e:	57fd                	li	a5,-1
    80004c90:	64f2                	ld	s1,280(sp)
    80004c92:	6952                	ld	s2,272(sp)
}
    80004c94:	853e                	mv	a0,a5
    80004c96:	70b2                	ld	ra,296(sp)
    80004c98:	7412                	ld	s0,288(sp)
    80004c9a:	6155                	addi	sp,sp,304
    80004c9c:	8082                	ret

0000000080004c9e <sys_unlink>:
{
    80004c9e:	7151                	addi	sp,sp,-240
    80004ca0:	f586                	sd	ra,232(sp)
    80004ca2:	f1a2                	sd	s0,224(sp)
    80004ca4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004ca6:	08000613          	li	a2,128
    80004caa:	f3040593          	addi	a1,s0,-208
    80004cae:	4501                	li	a0,0
    80004cb0:	b51fd0ef          	jal	80002800 <argstr>
    80004cb4:	16054063          	bltz	a0,80004e14 <sys_unlink+0x176>
    80004cb8:	eda6                	sd	s1,216(sp)
  begin_op();
    80004cba:	e35fe0ef          	jal	80003aee <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004cbe:	fb040593          	addi	a1,s0,-80
    80004cc2:	f3040513          	addi	a0,s0,-208
    80004cc6:	c87fe0ef          	jal	8000394c <nameiparent>
    80004cca:	84aa                	mv	s1,a0
    80004ccc:	c945                	beqz	a0,80004d7c <sys_unlink+0xde>
  ilock(dp);
    80004cce:	d8afe0ef          	jal	80003258 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004cd2:	00003597          	auipc	a1,0x3
    80004cd6:	95e58593          	addi	a1,a1,-1698 # 80007630 <etext+0x630>
    80004cda:	fb040513          	addi	a0,s0,-80
    80004cde:	9d9fe0ef          	jal	800036b6 <namecmp>
    80004ce2:	10050e63          	beqz	a0,80004dfe <sys_unlink+0x160>
    80004ce6:	00003597          	auipc	a1,0x3
    80004cea:	95258593          	addi	a1,a1,-1710 # 80007638 <etext+0x638>
    80004cee:	fb040513          	addi	a0,s0,-80
    80004cf2:	9c5fe0ef          	jal	800036b6 <namecmp>
    80004cf6:	10050463          	beqz	a0,80004dfe <sys_unlink+0x160>
    80004cfa:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004cfc:	f2c40613          	addi	a2,s0,-212
    80004d00:	fb040593          	addi	a1,s0,-80
    80004d04:	8526                	mv	a0,s1
    80004d06:	9c7fe0ef          	jal	800036cc <dirlookup>
    80004d0a:	892a                	mv	s2,a0
    80004d0c:	0e050863          	beqz	a0,80004dfc <sys_unlink+0x15e>
  ilock(ip);
    80004d10:	d48fe0ef          	jal	80003258 <ilock>
  if(ip->nlink < 1)
    80004d14:	04a91783          	lh	a5,74(s2)
    80004d18:	06f05763          	blez	a5,80004d86 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004d1c:	04491703          	lh	a4,68(s2)
    80004d20:	4785                	li	a5,1
    80004d22:	06f70963          	beq	a4,a5,80004d94 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004d26:	4641                	li	a2,16
    80004d28:	4581                	li	a1,0
    80004d2a:	fc040513          	addi	a0,s0,-64
    80004d2e:	fa9fb0ef          	jal	80000cd6 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d32:	4741                	li	a4,16
    80004d34:	f2c42683          	lw	a3,-212(s0)
    80004d38:	fc040613          	addi	a2,s0,-64
    80004d3c:	4581                	li	a1,0
    80004d3e:	8526                	mv	a0,s1
    80004d40:	869fe0ef          	jal	800035a8 <writei>
    80004d44:	47c1                	li	a5,16
    80004d46:	08f51b63          	bne	a0,a5,80004ddc <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004d4a:	04491703          	lh	a4,68(s2)
    80004d4e:	4785                	li	a5,1
    80004d50:	08f70d63          	beq	a4,a5,80004dea <sys_unlink+0x14c>
  iunlockput(dp);
    80004d54:	8526                	mv	a0,s1
    80004d56:	f0cfe0ef          	jal	80003462 <iunlockput>
  ip->nlink--;
    80004d5a:	04a95783          	lhu	a5,74(s2)
    80004d5e:	37fd                	addiw	a5,a5,-1
    80004d60:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004d64:	854a                	mv	a0,s2
    80004d66:	c3efe0ef          	jal	800031a4 <iupdate>
  iunlockput(ip);
    80004d6a:	854a                	mv	a0,s2
    80004d6c:	ef6fe0ef          	jal	80003462 <iunlockput>
  end_op();
    80004d70:	de9fe0ef          	jal	80003b58 <end_op>
  return 0;
    80004d74:	4501                	li	a0,0
    80004d76:	64ee                	ld	s1,216(sp)
    80004d78:	694e                	ld	s2,208(sp)
    80004d7a:	a849                	j	80004e0c <sys_unlink+0x16e>
    end_op();
    80004d7c:	dddfe0ef          	jal	80003b58 <end_op>
    return -1;
    80004d80:	557d                	li	a0,-1
    80004d82:	64ee                	ld	s1,216(sp)
    80004d84:	a061                	j	80004e0c <sys_unlink+0x16e>
    80004d86:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004d88:	00003517          	auipc	a0,0x3
    80004d8c:	8b850513          	addi	a0,a0,-1864 # 80007640 <etext+0x640>
    80004d90:	a13fb0ef          	jal	800007a2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d94:	04c92703          	lw	a4,76(s2)
    80004d98:	02000793          	li	a5,32
    80004d9c:	f8e7f5e3          	bgeu	a5,a4,80004d26 <sys_unlink+0x88>
    80004da0:	e5ce                	sd	s3,200(sp)
    80004da2:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004da6:	4741                	li	a4,16
    80004da8:	86ce                	mv	a3,s3
    80004daa:	f1840613          	addi	a2,s0,-232
    80004dae:	4581                	li	a1,0
    80004db0:	854a                	mv	a0,s2
    80004db2:	efafe0ef          	jal	800034ac <readi>
    80004db6:	47c1                	li	a5,16
    80004db8:	00f51c63          	bne	a0,a5,80004dd0 <sys_unlink+0x132>
    if(de.inum != 0)
    80004dbc:	f1845783          	lhu	a5,-232(s0)
    80004dc0:	efa1                	bnez	a5,80004e18 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004dc2:	29c1                	addiw	s3,s3,16
    80004dc4:	04c92783          	lw	a5,76(s2)
    80004dc8:	fcf9efe3          	bltu	s3,a5,80004da6 <sys_unlink+0x108>
    80004dcc:	69ae                	ld	s3,200(sp)
    80004dce:	bfa1                	j	80004d26 <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004dd0:	00003517          	auipc	a0,0x3
    80004dd4:	88850513          	addi	a0,a0,-1912 # 80007658 <etext+0x658>
    80004dd8:	9cbfb0ef          	jal	800007a2 <panic>
    80004ddc:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004dde:	00003517          	auipc	a0,0x3
    80004de2:	89250513          	addi	a0,a0,-1902 # 80007670 <etext+0x670>
    80004de6:	9bdfb0ef          	jal	800007a2 <panic>
    dp->nlink--;
    80004dea:	04a4d783          	lhu	a5,74(s1)
    80004dee:	37fd                	addiw	a5,a5,-1
    80004df0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004df4:	8526                	mv	a0,s1
    80004df6:	baefe0ef          	jal	800031a4 <iupdate>
    80004dfa:	bfa9                	j	80004d54 <sys_unlink+0xb6>
    80004dfc:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004dfe:	8526                	mv	a0,s1
    80004e00:	e62fe0ef          	jal	80003462 <iunlockput>
  end_op();
    80004e04:	d55fe0ef          	jal	80003b58 <end_op>
  return -1;
    80004e08:	557d                	li	a0,-1
    80004e0a:	64ee                	ld	s1,216(sp)
}
    80004e0c:	70ae                	ld	ra,232(sp)
    80004e0e:	740e                	ld	s0,224(sp)
    80004e10:	616d                	addi	sp,sp,240
    80004e12:	8082                	ret
    return -1;
    80004e14:	557d                	li	a0,-1
    80004e16:	bfdd                	j	80004e0c <sys_unlink+0x16e>
    iunlockput(ip);
    80004e18:	854a                	mv	a0,s2
    80004e1a:	e48fe0ef          	jal	80003462 <iunlockput>
    goto bad;
    80004e1e:	694e                	ld	s2,208(sp)
    80004e20:	69ae                	ld	s3,200(sp)
    80004e22:	bff1                	j	80004dfe <sys_unlink+0x160>

0000000080004e24 <sys_open>:

uint64
sys_open(void)
{
    80004e24:	7131                	addi	sp,sp,-192
    80004e26:	fd06                	sd	ra,184(sp)
    80004e28:	f922                	sd	s0,176(sp)
    80004e2a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004e2c:	f4c40593          	addi	a1,s0,-180
    80004e30:	4505                	li	a0,1
    80004e32:	995fd0ef          	jal	800027c6 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004e36:	08000613          	li	a2,128
    80004e3a:	f5040593          	addi	a1,s0,-176
    80004e3e:	4501                	li	a0,0
    80004e40:	9c1fd0ef          	jal	80002800 <argstr>
    80004e44:	87aa                	mv	a5,a0
    return -1;
    80004e46:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004e48:	0a07c263          	bltz	a5,80004eec <sys_open+0xc8>
    80004e4c:	f526                	sd	s1,168(sp)

  begin_op();
    80004e4e:	ca1fe0ef          	jal	80003aee <begin_op>

  if(omode & O_CREATE){
    80004e52:	f4c42783          	lw	a5,-180(s0)
    80004e56:	2007f793          	andi	a5,a5,512
    80004e5a:	c3d5                	beqz	a5,80004efe <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004e5c:	4681                	li	a3,0
    80004e5e:	4601                	li	a2,0
    80004e60:	4589                	li	a1,2
    80004e62:	f5040513          	addi	a0,s0,-176
    80004e66:	aa9ff0ef          	jal	8000490e <create>
    80004e6a:	84aa                	mv	s1,a0
    if(ip == 0){
    80004e6c:	c541                	beqz	a0,80004ef4 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004e6e:	04449703          	lh	a4,68(s1)
    80004e72:	478d                	li	a5,3
    80004e74:	00f71763          	bne	a4,a5,80004e82 <sys_open+0x5e>
    80004e78:	0464d703          	lhu	a4,70(s1)
    80004e7c:	47a5                	li	a5,9
    80004e7e:	0ae7ed63          	bltu	a5,a4,80004f38 <sys_open+0x114>
    80004e82:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004e84:	fe1fe0ef          	jal	80003e64 <filealloc>
    80004e88:	892a                	mv	s2,a0
    80004e8a:	c179                	beqz	a0,80004f50 <sys_open+0x12c>
    80004e8c:	ed4e                	sd	s3,152(sp)
    80004e8e:	a43ff0ef          	jal	800048d0 <fdalloc>
    80004e92:	89aa                	mv	s3,a0
    80004e94:	0a054a63          	bltz	a0,80004f48 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004e98:	04449703          	lh	a4,68(s1)
    80004e9c:	478d                	li	a5,3
    80004e9e:	0cf70263          	beq	a4,a5,80004f62 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004ea2:	4789                	li	a5,2
    80004ea4:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004ea8:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004eac:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004eb0:	f4c42783          	lw	a5,-180(s0)
    80004eb4:	0017c713          	xori	a4,a5,1
    80004eb8:	8b05                	andi	a4,a4,1
    80004eba:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004ebe:	0037f713          	andi	a4,a5,3
    80004ec2:	00e03733          	snez	a4,a4
    80004ec6:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004eca:	4007f793          	andi	a5,a5,1024
    80004ece:	c791                	beqz	a5,80004eda <sys_open+0xb6>
    80004ed0:	04449703          	lh	a4,68(s1)
    80004ed4:	4789                	li	a5,2
    80004ed6:	08f70d63          	beq	a4,a5,80004f70 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004eda:	8526                	mv	a0,s1
    80004edc:	c2afe0ef          	jal	80003306 <iunlock>
  end_op();
    80004ee0:	c79fe0ef          	jal	80003b58 <end_op>

  return fd;
    80004ee4:	854e                	mv	a0,s3
    80004ee6:	74aa                	ld	s1,168(sp)
    80004ee8:	790a                	ld	s2,160(sp)
    80004eea:	69ea                	ld	s3,152(sp)
}
    80004eec:	70ea                	ld	ra,184(sp)
    80004eee:	744a                	ld	s0,176(sp)
    80004ef0:	6129                	addi	sp,sp,192
    80004ef2:	8082                	ret
      end_op();
    80004ef4:	c65fe0ef          	jal	80003b58 <end_op>
      return -1;
    80004ef8:	557d                	li	a0,-1
    80004efa:	74aa                	ld	s1,168(sp)
    80004efc:	bfc5                	j	80004eec <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004efe:	f5040513          	addi	a0,s0,-176
    80004f02:	a31fe0ef          	jal	80003932 <namei>
    80004f06:	84aa                	mv	s1,a0
    80004f08:	c11d                	beqz	a0,80004f2e <sys_open+0x10a>
    ilock(ip);
    80004f0a:	b4efe0ef          	jal	80003258 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004f0e:	04449703          	lh	a4,68(s1)
    80004f12:	4785                	li	a5,1
    80004f14:	f4f71de3          	bne	a4,a5,80004e6e <sys_open+0x4a>
    80004f18:	f4c42783          	lw	a5,-180(s0)
    80004f1c:	d3bd                	beqz	a5,80004e82 <sys_open+0x5e>
      iunlockput(ip);
    80004f1e:	8526                	mv	a0,s1
    80004f20:	d42fe0ef          	jal	80003462 <iunlockput>
      end_op();
    80004f24:	c35fe0ef          	jal	80003b58 <end_op>
      return -1;
    80004f28:	557d                	li	a0,-1
    80004f2a:	74aa                	ld	s1,168(sp)
    80004f2c:	b7c1                	j	80004eec <sys_open+0xc8>
      end_op();
    80004f2e:	c2bfe0ef          	jal	80003b58 <end_op>
      return -1;
    80004f32:	557d                	li	a0,-1
    80004f34:	74aa                	ld	s1,168(sp)
    80004f36:	bf5d                	j	80004eec <sys_open+0xc8>
    iunlockput(ip);
    80004f38:	8526                	mv	a0,s1
    80004f3a:	d28fe0ef          	jal	80003462 <iunlockput>
    end_op();
    80004f3e:	c1bfe0ef          	jal	80003b58 <end_op>
    return -1;
    80004f42:	557d                	li	a0,-1
    80004f44:	74aa                	ld	s1,168(sp)
    80004f46:	b75d                	j	80004eec <sys_open+0xc8>
      fileclose(f);
    80004f48:	854a                	mv	a0,s2
    80004f4a:	fbffe0ef          	jal	80003f08 <fileclose>
    80004f4e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004f50:	8526                	mv	a0,s1
    80004f52:	d10fe0ef          	jal	80003462 <iunlockput>
    end_op();
    80004f56:	c03fe0ef          	jal	80003b58 <end_op>
    return -1;
    80004f5a:	557d                	li	a0,-1
    80004f5c:	74aa                	ld	s1,168(sp)
    80004f5e:	790a                	ld	s2,160(sp)
    80004f60:	b771                	j	80004eec <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004f62:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004f66:	04649783          	lh	a5,70(s1)
    80004f6a:	02f91223          	sh	a5,36(s2)
    80004f6e:	bf3d                	j	80004eac <sys_open+0x88>
    itrunc(ip);
    80004f70:	8526                	mv	a0,s1
    80004f72:	bd4fe0ef          	jal	80003346 <itrunc>
    80004f76:	b795                	j	80004eda <sys_open+0xb6>

0000000080004f78 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f78:	7175                	addi	sp,sp,-144
    80004f7a:	e506                	sd	ra,136(sp)
    80004f7c:	e122                	sd	s0,128(sp)
    80004f7e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f80:	b6ffe0ef          	jal	80003aee <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f84:	08000613          	li	a2,128
    80004f88:	f7040593          	addi	a1,s0,-144
    80004f8c:	4501                	li	a0,0
    80004f8e:	873fd0ef          	jal	80002800 <argstr>
    80004f92:	02054363          	bltz	a0,80004fb8 <sys_mkdir+0x40>
    80004f96:	4681                	li	a3,0
    80004f98:	4601                	li	a2,0
    80004f9a:	4585                	li	a1,1
    80004f9c:	f7040513          	addi	a0,s0,-144
    80004fa0:	96fff0ef          	jal	8000490e <create>
    80004fa4:	c911                	beqz	a0,80004fb8 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fa6:	cbcfe0ef          	jal	80003462 <iunlockput>
  end_op();
    80004faa:	baffe0ef          	jal	80003b58 <end_op>
  return 0;
    80004fae:	4501                	li	a0,0
}
    80004fb0:	60aa                	ld	ra,136(sp)
    80004fb2:	640a                	ld	s0,128(sp)
    80004fb4:	6149                	addi	sp,sp,144
    80004fb6:	8082                	ret
    end_op();
    80004fb8:	ba1fe0ef          	jal	80003b58 <end_op>
    return -1;
    80004fbc:	557d                	li	a0,-1
    80004fbe:	bfcd                	j	80004fb0 <sys_mkdir+0x38>

0000000080004fc0 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004fc0:	7135                	addi	sp,sp,-160
    80004fc2:	ed06                	sd	ra,152(sp)
    80004fc4:	e922                	sd	s0,144(sp)
    80004fc6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004fc8:	b27fe0ef          	jal	80003aee <begin_op>
  argint(1, &major);
    80004fcc:	f6c40593          	addi	a1,s0,-148
    80004fd0:	4505                	li	a0,1
    80004fd2:	ff4fd0ef          	jal	800027c6 <argint>
  argint(2, &minor);
    80004fd6:	f6840593          	addi	a1,s0,-152
    80004fda:	4509                	li	a0,2
    80004fdc:	feafd0ef          	jal	800027c6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fe0:	08000613          	li	a2,128
    80004fe4:	f7040593          	addi	a1,s0,-144
    80004fe8:	4501                	li	a0,0
    80004fea:	817fd0ef          	jal	80002800 <argstr>
    80004fee:	02054563          	bltz	a0,80005018 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ff2:	f6841683          	lh	a3,-152(s0)
    80004ff6:	f6c41603          	lh	a2,-148(s0)
    80004ffa:	458d                	li	a1,3
    80004ffc:	f7040513          	addi	a0,s0,-144
    80005000:	90fff0ef          	jal	8000490e <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005004:	c911                	beqz	a0,80005018 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005006:	c5cfe0ef          	jal	80003462 <iunlockput>
  end_op();
    8000500a:	b4ffe0ef          	jal	80003b58 <end_op>
  return 0;
    8000500e:	4501                	li	a0,0
}
    80005010:	60ea                	ld	ra,152(sp)
    80005012:	644a                	ld	s0,144(sp)
    80005014:	610d                	addi	sp,sp,160
    80005016:	8082                	ret
    end_op();
    80005018:	b41fe0ef          	jal	80003b58 <end_op>
    return -1;
    8000501c:	557d                	li	a0,-1
    8000501e:	bfcd                	j	80005010 <sys_mknod+0x50>

0000000080005020 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005020:	7135                	addi	sp,sp,-160
    80005022:	ed06                	sd	ra,152(sp)
    80005024:	e922                	sd	s0,144(sp)
    80005026:	e14a                	sd	s2,128(sp)
    80005028:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000502a:	8e9fc0ef          	jal	80001912 <myproc>
    8000502e:	892a                	mv	s2,a0
  
  begin_op();
    80005030:	abffe0ef          	jal	80003aee <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005034:	08000613          	li	a2,128
    80005038:	f6040593          	addi	a1,s0,-160
    8000503c:	4501                	li	a0,0
    8000503e:	fc2fd0ef          	jal	80002800 <argstr>
    80005042:	04054363          	bltz	a0,80005088 <sys_chdir+0x68>
    80005046:	e526                	sd	s1,136(sp)
    80005048:	f6040513          	addi	a0,s0,-160
    8000504c:	8e7fe0ef          	jal	80003932 <namei>
    80005050:	84aa                	mv	s1,a0
    80005052:	c915                	beqz	a0,80005086 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005054:	a04fe0ef          	jal	80003258 <ilock>
  if(ip->type != T_DIR){
    80005058:	04449703          	lh	a4,68(s1)
    8000505c:	4785                	li	a5,1
    8000505e:	02f71963          	bne	a4,a5,80005090 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005062:	8526                	mv	a0,s1
    80005064:	aa2fe0ef          	jal	80003306 <iunlock>
  iput(p->cwd);
    80005068:	15093503          	ld	a0,336(s2)
    8000506c:	b6efe0ef          	jal	800033da <iput>
  end_op();
    80005070:	ae9fe0ef          	jal	80003b58 <end_op>
  p->cwd = ip;
    80005074:	14993823          	sd	s1,336(s2)
  return 0;
    80005078:	4501                	li	a0,0
    8000507a:	64aa                	ld	s1,136(sp)
}
    8000507c:	60ea                	ld	ra,152(sp)
    8000507e:	644a                	ld	s0,144(sp)
    80005080:	690a                	ld	s2,128(sp)
    80005082:	610d                	addi	sp,sp,160
    80005084:	8082                	ret
    80005086:	64aa                	ld	s1,136(sp)
    end_op();
    80005088:	ad1fe0ef          	jal	80003b58 <end_op>
    return -1;
    8000508c:	557d                	li	a0,-1
    8000508e:	b7fd                	j	8000507c <sys_chdir+0x5c>
    iunlockput(ip);
    80005090:	8526                	mv	a0,s1
    80005092:	bd0fe0ef          	jal	80003462 <iunlockput>
    end_op();
    80005096:	ac3fe0ef          	jal	80003b58 <end_op>
    return -1;
    8000509a:	557d                	li	a0,-1
    8000509c:	64aa                	ld	s1,136(sp)
    8000509e:	bff9                	j	8000507c <sys_chdir+0x5c>

00000000800050a0 <sys_exec>:

uint64
sys_exec(void)
{
    800050a0:	7121                	addi	sp,sp,-448
    800050a2:	ff06                	sd	ra,440(sp)
    800050a4:	fb22                	sd	s0,432(sp)
    800050a6:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800050a8:	e4840593          	addi	a1,s0,-440
    800050ac:	4505                	li	a0,1
    800050ae:	f34fd0ef          	jal	800027e2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800050b2:	08000613          	li	a2,128
    800050b6:	f5040593          	addi	a1,s0,-176
    800050ba:	4501                	li	a0,0
    800050bc:	f44fd0ef          	jal	80002800 <argstr>
    800050c0:	87aa                	mv	a5,a0
    return -1;
    800050c2:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800050c4:	0c07c463          	bltz	a5,8000518c <sys_exec+0xec>
    800050c8:	f726                	sd	s1,424(sp)
    800050ca:	f34a                	sd	s2,416(sp)
    800050cc:	ef4e                	sd	s3,408(sp)
    800050ce:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800050d0:	10000613          	li	a2,256
    800050d4:	4581                	li	a1,0
    800050d6:	e5040513          	addi	a0,s0,-432
    800050da:	bfdfb0ef          	jal	80000cd6 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050de:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800050e2:	89a6                	mv	s3,s1
    800050e4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050e6:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050ea:	00391513          	slli	a0,s2,0x3
    800050ee:	e4040593          	addi	a1,s0,-448
    800050f2:	e4843783          	ld	a5,-440(s0)
    800050f6:	953e                	add	a0,a0,a5
    800050f8:	e44fd0ef          	jal	8000273c <fetchaddr>
    800050fc:	02054663          	bltz	a0,80005128 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80005100:	e4043783          	ld	a5,-448(s0)
    80005104:	c3a9                	beqz	a5,80005146 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005106:	a2dfb0ef          	jal	80000b32 <kalloc>
    8000510a:	85aa                	mv	a1,a0
    8000510c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005110:	cd01                	beqz	a0,80005128 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005112:	6605                	lui	a2,0x1
    80005114:	e4043503          	ld	a0,-448(s0)
    80005118:	e6efd0ef          	jal	80002786 <fetchstr>
    8000511c:	00054663          	bltz	a0,80005128 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80005120:	0905                	addi	s2,s2,1
    80005122:	09a1                	addi	s3,s3,8
    80005124:	fd4913e3          	bne	s2,s4,800050ea <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005128:	f5040913          	addi	s2,s0,-176
    8000512c:	6088                	ld	a0,0(s1)
    8000512e:	c931                	beqz	a0,80005182 <sys_exec+0xe2>
    kfree(argv[i]);
    80005130:	921fb0ef          	jal	80000a50 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005134:	04a1                	addi	s1,s1,8
    80005136:	ff249be3          	bne	s1,s2,8000512c <sys_exec+0x8c>
  return -1;
    8000513a:	557d                	li	a0,-1
    8000513c:	74ba                	ld	s1,424(sp)
    8000513e:	791a                	ld	s2,416(sp)
    80005140:	69fa                	ld	s3,408(sp)
    80005142:	6a5a                	ld	s4,400(sp)
    80005144:	a0a1                	j	8000518c <sys_exec+0xec>
      argv[i] = 0;
    80005146:	0009079b          	sext.w	a5,s2
    8000514a:	078e                	slli	a5,a5,0x3
    8000514c:	fd078793          	addi	a5,a5,-48
    80005150:	97a2                	add	a5,a5,s0
    80005152:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005156:	e5040593          	addi	a1,s0,-432
    8000515a:	f5040513          	addi	a0,s0,-176
    8000515e:	ba8ff0ef          	jal	80004506 <exec>
    80005162:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005164:	f5040993          	addi	s3,s0,-176
    80005168:	6088                	ld	a0,0(s1)
    8000516a:	c511                	beqz	a0,80005176 <sys_exec+0xd6>
    kfree(argv[i]);
    8000516c:	8e5fb0ef          	jal	80000a50 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005170:	04a1                	addi	s1,s1,8
    80005172:	ff349be3          	bne	s1,s3,80005168 <sys_exec+0xc8>
  return ret;
    80005176:	854a                	mv	a0,s2
    80005178:	74ba                	ld	s1,424(sp)
    8000517a:	791a                	ld	s2,416(sp)
    8000517c:	69fa                	ld	s3,408(sp)
    8000517e:	6a5a                	ld	s4,400(sp)
    80005180:	a031                	j	8000518c <sys_exec+0xec>
  return -1;
    80005182:	557d                	li	a0,-1
    80005184:	74ba                	ld	s1,424(sp)
    80005186:	791a                	ld	s2,416(sp)
    80005188:	69fa                	ld	s3,408(sp)
    8000518a:	6a5a                	ld	s4,400(sp)
}
    8000518c:	70fa                	ld	ra,440(sp)
    8000518e:	745a                	ld	s0,432(sp)
    80005190:	6139                	addi	sp,sp,448
    80005192:	8082                	ret

0000000080005194 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005194:	7139                	addi	sp,sp,-64
    80005196:	fc06                	sd	ra,56(sp)
    80005198:	f822                	sd	s0,48(sp)
    8000519a:	f426                	sd	s1,40(sp)
    8000519c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000519e:	f74fc0ef          	jal	80001912 <myproc>
    800051a2:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800051a4:	fd840593          	addi	a1,s0,-40
    800051a8:	4501                	li	a0,0
    800051aa:	e38fd0ef          	jal	800027e2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800051ae:	fc840593          	addi	a1,s0,-56
    800051b2:	fd040513          	addi	a0,s0,-48
    800051b6:	85cff0ef          	jal	80004212 <pipealloc>
    return -1;
    800051ba:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051bc:	0a054463          	bltz	a0,80005264 <sys_pipe+0xd0>
  fd0 = -1;
    800051c0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051c4:	fd043503          	ld	a0,-48(s0)
    800051c8:	f08ff0ef          	jal	800048d0 <fdalloc>
    800051cc:	fca42223          	sw	a0,-60(s0)
    800051d0:	08054163          	bltz	a0,80005252 <sys_pipe+0xbe>
    800051d4:	fc843503          	ld	a0,-56(s0)
    800051d8:	ef8ff0ef          	jal	800048d0 <fdalloc>
    800051dc:	fca42023          	sw	a0,-64(s0)
    800051e0:	06054063          	bltz	a0,80005240 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051e4:	4691                	li	a3,4
    800051e6:	fc440613          	addi	a2,s0,-60
    800051ea:	fd843583          	ld	a1,-40(s0)
    800051ee:	68a8                	ld	a0,80(s1)
    800051f0:	b94fc0ef          	jal	80001584 <copyout>
    800051f4:	00054e63          	bltz	a0,80005210 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051f8:	4691                	li	a3,4
    800051fa:	fc040613          	addi	a2,s0,-64
    800051fe:	fd843583          	ld	a1,-40(s0)
    80005202:	0591                	addi	a1,a1,4
    80005204:	68a8                	ld	a0,80(s1)
    80005206:	b7efc0ef          	jal	80001584 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000520a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000520c:	04055c63          	bgez	a0,80005264 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005210:	fc442783          	lw	a5,-60(s0)
    80005214:	07e9                	addi	a5,a5,26
    80005216:	078e                	slli	a5,a5,0x3
    80005218:	97a6                	add	a5,a5,s1
    8000521a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000521e:	fc042783          	lw	a5,-64(s0)
    80005222:	07e9                	addi	a5,a5,26
    80005224:	078e                	slli	a5,a5,0x3
    80005226:	94be                	add	s1,s1,a5
    80005228:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000522c:	fd043503          	ld	a0,-48(s0)
    80005230:	cd9fe0ef          	jal	80003f08 <fileclose>
    fileclose(wf);
    80005234:	fc843503          	ld	a0,-56(s0)
    80005238:	cd1fe0ef          	jal	80003f08 <fileclose>
    return -1;
    8000523c:	57fd                	li	a5,-1
    8000523e:	a01d                	j	80005264 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005240:	fc442783          	lw	a5,-60(s0)
    80005244:	0007c763          	bltz	a5,80005252 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005248:	07e9                	addi	a5,a5,26
    8000524a:	078e                	slli	a5,a5,0x3
    8000524c:	97a6                	add	a5,a5,s1
    8000524e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005252:	fd043503          	ld	a0,-48(s0)
    80005256:	cb3fe0ef          	jal	80003f08 <fileclose>
    fileclose(wf);
    8000525a:	fc843503          	ld	a0,-56(s0)
    8000525e:	cabfe0ef          	jal	80003f08 <fileclose>
    return -1;
    80005262:	57fd                	li	a5,-1
}
    80005264:	853e                	mv	a0,a5
    80005266:	70e2                	ld	ra,56(sp)
    80005268:	7442                	ld	s0,48(sp)
    8000526a:	74a2                	ld	s1,40(sp)
    8000526c:	6121                	addi	sp,sp,64
    8000526e:	8082                	ret

0000000080005270 <kernelvec>:
    80005270:	7111                	addi	sp,sp,-256
    80005272:	e006                	sd	ra,0(sp)
    80005274:	e40a                	sd	sp,8(sp)
    80005276:	e80e                	sd	gp,16(sp)
    80005278:	ec12                	sd	tp,24(sp)
    8000527a:	f016                	sd	t0,32(sp)
    8000527c:	f41a                	sd	t1,40(sp)
    8000527e:	f81e                	sd	t2,48(sp)
    80005280:	e4aa                	sd	a0,72(sp)
    80005282:	e8ae                	sd	a1,80(sp)
    80005284:	ecb2                	sd	a2,88(sp)
    80005286:	f0b6                	sd	a3,96(sp)
    80005288:	f4ba                	sd	a4,104(sp)
    8000528a:	f8be                	sd	a5,112(sp)
    8000528c:	fcc2                	sd	a6,120(sp)
    8000528e:	e146                	sd	a7,128(sp)
    80005290:	edf2                	sd	t3,216(sp)
    80005292:	f1f6                	sd	t4,224(sp)
    80005294:	f5fa                	sd	t5,232(sp)
    80005296:	f9fe                	sd	t6,240(sp)
    80005298:	bb4fd0ef          	jal	8000264c <kerneltrap>
    8000529c:	6082                	ld	ra,0(sp)
    8000529e:	6122                	ld	sp,8(sp)
    800052a0:	61c2                	ld	gp,16(sp)
    800052a2:	7282                	ld	t0,32(sp)
    800052a4:	7322                	ld	t1,40(sp)
    800052a6:	73c2                	ld	t2,48(sp)
    800052a8:	6526                	ld	a0,72(sp)
    800052aa:	65c6                	ld	a1,80(sp)
    800052ac:	6666                	ld	a2,88(sp)
    800052ae:	7686                	ld	a3,96(sp)
    800052b0:	7726                	ld	a4,104(sp)
    800052b2:	77c6                	ld	a5,112(sp)
    800052b4:	7866                	ld	a6,120(sp)
    800052b6:	688a                	ld	a7,128(sp)
    800052b8:	6e6e                	ld	t3,216(sp)
    800052ba:	7e8e                	ld	t4,224(sp)
    800052bc:	7f2e                	ld	t5,232(sp)
    800052be:	7fce                	ld	t6,240(sp)
    800052c0:	6111                	addi	sp,sp,256
    800052c2:	10200073          	sret
	...

00000000800052ce <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052ce:	1141                	addi	sp,sp,-16
    800052d0:	e422                	sd	s0,8(sp)
    800052d2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052d4:	0c0007b7          	lui	a5,0xc000
    800052d8:	4705                	li	a4,1
    800052da:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052dc:	0c0007b7          	lui	a5,0xc000
    800052e0:	c3d8                	sw	a4,4(a5)
}
    800052e2:	6422                	ld	s0,8(sp)
    800052e4:	0141                	addi	sp,sp,16
    800052e6:	8082                	ret

00000000800052e8 <plicinithart>:

void
plicinithart(void)
{
    800052e8:	1141                	addi	sp,sp,-16
    800052ea:	e406                	sd	ra,8(sp)
    800052ec:	e022                	sd	s0,0(sp)
    800052ee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052f0:	df6fc0ef          	jal	800018e6 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052f4:	0085171b          	slliw	a4,a0,0x8
    800052f8:	0c0027b7          	lui	a5,0xc002
    800052fc:	97ba                	add	a5,a5,a4
    800052fe:	40200713          	li	a4,1026
    80005302:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005306:	00d5151b          	slliw	a0,a0,0xd
    8000530a:	0c2017b7          	lui	a5,0xc201
    8000530e:	97aa                	add	a5,a5,a0
    80005310:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005314:	60a2                	ld	ra,8(sp)
    80005316:	6402                	ld	s0,0(sp)
    80005318:	0141                	addi	sp,sp,16
    8000531a:	8082                	ret

000000008000531c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000531c:	1141                	addi	sp,sp,-16
    8000531e:	e406                	sd	ra,8(sp)
    80005320:	e022                	sd	s0,0(sp)
    80005322:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005324:	dc2fc0ef          	jal	800018e6 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005328:	00d5151b          	slliw	a0,a0,0xd
    8000532c:	0c2017b7          	lui	a5,0xc201
    80005330:	97aa                	add	a5,a5,a0
  return irq;
}
    80005332:	43c8                	lw	a0,4(a5)
    80005334:	60a2                	ld	ra,8(sp)
    80005336:	6402                	ld	s0,0(sp)
    80005338:	0141                	addi	sp,sp,16
    8000533a:	8082                	ret

000000008000533c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000533c:	1101                	addi	sp,sp,-32
    8000533e:	ec06                	sd	ra,24(sp)
    80005340:	e822                	sd	s0,16(sp)
    80005342:	e426                	sd	s1,8(sp)
    80005344:	1000                	addi	s0,sp,32
    80005346:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005348:	d9efc0ef          	jal	800018e6 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000534c:	00d5151b          	slliw	a0,a0,0xd
    80005350:	0c2017b7          	lui	a5,0xc201
    80005354:	97aa                	add	a5,a5,a0
    80005356:	c3c4                	sw	s1,4(a5)
}
    80005358:	60e2                	ld	ra,24(sp)
    8000535a:	6442                	ld	s0,16(sp)
    8000535c:	64a2                	ld	s1,8(sp)
    8000535e:	6105                	addi	sp,sp,32
    80005360:	8082                	ret

0000000080005362 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005362:	1141                	addi	sp,sp,-16
    80005364:	e406                	sd	ra,8(sp)
    80005366:	e022                	sd	s0,0(sp)
    80005368:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000536a:	479d                	li	a5,7
    8000536c:	04a7ca63          	blt	a5,a0,800053c0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005370:	0001e797          	auipc	a5,0x1e
    80005374:	1d078793          	addi	a5,a5,464 # 80023540 <disk>
    80005378:	97aa                	add	a5,a5,a0
    8000537a:	0187c783          	lbu	a5,24(a5)
    8000537e:	e7b9                	bnez	a5,800053cc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005380:	00451693          	slli	a3,a0,0x4
    80005384:	0001e797          	auipc	a5,0x1e
    80005388:	1bc78793          	addi	a5,a5,444 # 80023540 <disk>
    8000538c:	6398                	ld	a4,0(a5)
    8000538e:	9736                	add	a4,a4,a3
    80005390:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005394:	6398                	ld	a4,0(a5)
    80005396:	9736                	add	a4,a4,a3
    80005398:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000539c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800053a0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800053a4:	97aa                	add	a5,a5,a0
    800053a6:	4705                	li	a4,1
    800053a8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800053ac:	0001e517          	auipc	a0,0x1e
    800053b0:	1ac50513          	addi	a0,a0,428 # 80023558 <disk+0x18>
    800053b4:	b79fc0ef          	jal	80001f2c <wakeup>
}
    800053b8:	60a2                	ld	ra,8(sp)
    800053ba:	6402                	ld	s0,0(sp)
    800053bc:	0141                	addi	sp,sp,16
    800053be:	8082                	ret
    panic("free_desc 1");
    800053c0:	00002517          	auipc	a0,0x2
    800053c4:	2c050513          	addi	a0,a0,704 # 80007680 <etext+0x680>
    800053c8:	bdafb0ef          	jal	800007a2 <panic>
    panic("free_desc 2");
    800053cc:	00002517          	auipc	a0,0x2
    800053d0:	2c450513          	addi	a0,a0,708 # 80007690 <etext+0x690>
    800053d4:	bcefb0ef          	jal	800007a2 <panic>

00000000800053d8 <virtio_disk_init>:
{
    800053d8:	1101                	addi	sp,sp,-32
    800053da:	ec06                	sd	ra,24(sp)
    800053dc:	e822                	sd	s0,16(sp)
    800053de:	e426                	sd	s1,8(sp)
    800053e0:	e04a                	sd	s2,0(sp)
    800053e2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053e4:	00002597          	auipc	a1,0x2
    800053e8:	2bc58593          	addi	a1,a1,700 # 800076a0 <etext+0x6a0>
    800053ec:	0001e517          	auipc	a0,0x1e
    800053f0:	27c50513          	addi	a0,a0,636 # 80023668 <disk+0x128>
    800053f4:	f8efb0ef          	jal	80000b82 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053f8:	100017b7          	lui	a5,0x10001
    800053fc:	4398                	lw	a4,0(a5)
    800053fe:	2701                	sext.w	a4,a4
    80005400:	747277b7          	lui	a5,0x74727
    80005404:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005408:	18f71063          	bne	a4,a5,80005588 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000540c:	100017b7          	lui	a5,0x10001
    80005410:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80005412:	439c                	lw	a5,0(a5)
    80005414:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005416:	4709                	li	a4,2
    80005418:	16e79863          	bne	a5,a4,80005588 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000541c:	100017b7          	lui	a5,0x10001
    80005420:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005422:	439c                	lw	a5,0(a5)
    80005424:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005426:	16e79163          	bne	a5,a4,80005588 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000542a:	100017b7          	lui	a5,0x10001
    8000542e:	47d8                	lw	a4,12(a5)
    80005430:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005432:	554d47b7          	lui	a5,0x554d4
    80005436:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000543a:	14f71763          	bne	a4,a5,80005588 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000543e:	100017b7          	lui	a5,0x10001
    80005442:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005446:	4705                	li	a4,1
    80005448:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000544a:	470d                	li	a4,3
    8000544c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000544e:	10001737          	lui	a4,0x10001
    80005452:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005454:	c7ffe737          	lui	a4,0xc7ffe
    80005458:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb0df>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000545c:	8ef9                	and	a3,a3,a4
    8000545e:	10001737          	lui	a4,0x10001
    80005462:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005464:	472d                	li	a4,11
    80005466:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005468:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000546c:	439c                	lw	a5,0(a5)
    8000546e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005472:	8ba1                	andi	a5,a5,8
    80005474:	12078063          	beqz	a5,80005594 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005478:	100017b7          	lui	a5,0x10001
    8000547c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005480:	100017b7          	lui	a5,0x10001
    80005484:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005488:	439c                	lw	a5,0(a5)
    8000548a:	2781                	sext.w	a5,a5
    8000548c:	10079a63          	bnez	a5,800055a0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005490:	100017b7          	lui	a5,0x10001
    80005494:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005498:	439c                	lw	a5,0(a5)
    8000549a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000549c:	10078863          	beqz	a5,800055ac <virtio_disk_init+0x1d4>
  if(max < NUM)
    800054a0:	471d                	li	a4,7
    800054a2:	10f77b63          	bgeu	a4,a5,800055b8 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    800054a6:	e8cfb0ef          	jal	80000b32 <kalloc>
    800054aa:	0001e497          	auipc	s1,0x1e
    800054ae:	09648493          	addi	s1,s1,150 # 80023540 <disk>
    800054b2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800054b4:	e7efb0ef          	jal	80000b32 <kalloc>
    800054b8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800054ba:	e78fb0ef          	jal	80000b32 <kalloc>
    800054be:	87aa                	mv	a5,a0
    800054c0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800054c2:	6088                	ld	a0,0(s1)
    800054c4:	10050063          	beqz	a0,800055c4 <virtio_disk_init+0x1ec>
    800054c8:	0001e717          	auipc	a4,0x1e
    800054cc:	08073703          	ld	a4,128(a4) # 80023548 <disk+0x8>
    800054d0:	0e070a63          	beqz	a4,800055c4 <virtio_disk_init+0x1ec>
    800054d4:	0e078863          	beqz	a5,800055c4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    800054d8:	6605                	lui	a2,0x1
    800054da:	4581                	li	a1,0
    800054dc:	ffafb0ef          	jal	80000cd6 <memset>
  memset(disk.avail, 0, PGSIZE);
    800054e0:	0001e497          	auipc	s1,0x1e
    800054e4:	06048493          	addi	s1,s1,96 # 80023540 <disk>
    800054e8:	6605                	lui	a2,0x1
    800054ea:	4581                	li	a1,0
    800054ec:	6488                	ld	a0,8(s1)
    800054ee:	fe8fb0ef          	jal	80000cd6 <memset>
  memset(disk.used, 0, PGSIZE);
    800054f2:	6605                	lui	a2,0x1
    800054f4:	4581                	li	a1,0
    800054f6:	6888                	ld	a0,16(s1)
    800054f8:	fdefb0ef          	jal	80000cd6 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054fc:	100017b7          	lui	a5,0x10001
    80005500:	4721                	li	a4,8
    80005502:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005504:	4098                	lw	a4,0(s1)
    80005506:	100017b7          	lui	a5,0x10001
    8000550a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000550e:	40d8                	lw	a4,4(s1)
    80005510:	100017b7          	lui	a5,0x10001
    80005514:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005518:	649c                	ld	a5,8(s1)
    8000551a:	0007869b          	sext.w	a3,a5
    8000551e:	10001737          	lui	a4,0x10001
    80005522:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005526:	9781                	srai	a5,a5,0x20
    80005528:	10001737          	lui	a4,0x10001
    8000552c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005530:	689c                	ld	a5,16(s1)
    80005532:	0007869b          	sext.w	a3,a5
    80005536:	10001737          	lui	a4,0x10001
    8000553a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000553e:	9781                	srai	a5,a5,0x20
    80005540:	10001737          	lui	a4,0x10001
    80005544:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005548:	10001737          	lui	a4,0x10001
    8000554c:	4785                	li	a5,1
    8000554e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005550:	00f48c23          	sb	a5,24(s1)
    80005554:	00f48ca3          	sb	a5,25(s1)
    80005558:	00f48d23          	sb	a5,26(s1)
    8000555c:	00f48da3          	sb	a5,27(s1)
    80005560:	00f48e23          	sb	a5,28(s1)
    80005564:	00f48ea3          	sb	a5,29(s1)
    80005568:	00f48f23          	sb	a5,30(s1)
    8000556c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005570:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005574:	100017b7          	lui	a5,0x10001
    80005578:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000557c:	60e2                	ld	ra,24(sp)
    8000557e:	6442                	ld	s0,16(sp)
    80005580:	64a2                	ld	s1,8(sp)
    80005582:	6902                	ld	s2,0(sp)
    80005584:	6105                	addi	sp,sp,32
    80005586:	8082                	ret
    panic("could not find virtio disk");
    80005588:	00002517          	auipc	a0,0x2
    8000558c:	12850513          	addi	a0,a0,296 # 800076b0 <etext+0x6b0>
    80005590:	a12fb0ef          	jal	800007a2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005594:	00002517          	auipc	a0,0x2
    80005598:	13c50513          	addi	a0,a0,316 # 800076d0 <etext+0x6d0>
    8000559c:	a06fb0ef          	jal	800007a2 <panic>
    panic("virtio disk should not be ready");
    800055a0:	00002517          	auipc	a0,0x2
    800055a4:	15050513          	addi	a0,a0,336 # 800076f0 <etext+0x6f0>
    800055a8:	9fafb0ef          	jal	800007a2 <panic>
    panic("virtio disk has no queue 0");
    800055ac:	00002517          	auipc	a0,0x2
    800055b0:	16450513          	addi	a0,a0,356 # 80007710 <etext+0x710>
    800055b4:	9eefb0ef          	jal	800007a2 <panic>
    panic("virtio disk max queue too short");
    800055b8:	00002517          	auipc	a0,0x2
    800055bc:	17850513          	addi	a0,a0,376 # 80007730 <etext+0x730>
    800055c0:	9e2fb0ef          	jal	800007a2 <panic>
    panic("virtio disk kalloc");
    800055c4:	00002517          	auipc	a0,0x2
    800055c8:	18c50513          	addi	a0,a0,396 # 80007750 <etext+0x750>
    800055cc:	9d6fb0ef          	jal	800007a2 <panic>

00000000800055d0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055d0:	7159                	addi	sp,sp,-112
    800055d2:	f486                	sd	ra,104(sp)
    800055d4:	f0a2                	sd	s0,96(sp)
    800055d6:	eca6                	sd	s1,88(sp)
    800055d8:	e8ca                	sd	s2,80(sp)
    800055da:	e4ce                	sd	s3,72(sp)
    800055dc:	e0d2                	sd	s4,64(sp)
    800055de:	fc56                	sd	s5,56(sp)
    800055e0:	f85a                	sd	s6,48(sp)
    800055e2:	f45e                	sd	s7,40(sp)
    800055e4:	f062                	sd	s8,32(sp)
    800055e6:	ec66                	sd	s9,24(sp)
    800055e8:	1880                	addi	s0,sp,112
    800055ea:	8a2a                	mv	s4,a0
    800055ec:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800055ee:	00c52c83          	lw	s9,12(a0)
    800055f2:	001c9c9b          	slliw	s9,s9,0x1
    800055f6:	1c82                	slli	s9,s9,0x20
    800055f8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800055fc:	0001e517          	auipc	a0,0x1e
    80005600:	06c50513          	addi	a0,a0,108 # 80023668 <disk+0x128>
    80005604:	dfefb0ef          	jal	80000c02 <acquire>
  for(int i = 0; i < 3; i++){
    80005608:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000560a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000560c:	0001eb17          	auipc	s6,0x1e
    80005610:	f34b0b13          	addi	s6,s6,-204 # 80023540 <disk>
  for(int i = 0; i < 3; i++){
    80005614:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005616:	0001ec17          	auipc	s8,0x1e
    8000561a:	052c0c13          	addi	s8,s8,82 # 80023668 <disk+0x128>
    8000561e:	a8b9                	j	8000567c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005620:	00fb0733          	add	a4,s6,a5
    80005624:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005628:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000562a:	0207c563          	bltz	a5,80005654 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    8000562e:	2905                	addiw	s2,s2,1
    80005630:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005632:	05590963          	beq	s2,s5,80005684 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005636:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005638:	0001e717          	auipc	a4,0x1e
    8000563c:	f0870713          	addi	a4,a4,-248 # 80023540 <disk>
    80005640:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005642:	01874683          	lbu	a3,24(a4)
    80005646:	fee9                	bnez	a3,80005620 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005648:	2785                	addiw	a5,a5,1
    8000564a:	0705                	addi	a4,a4,1
    8000564c:	fe979be3          	bne	a5,s1,80005642 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005650:	57fd                	li	a5,-1
    80005652:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005654:	01205d63          	blez	s2,8000566e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005658:	f9042503          	lw	a0,-112(s0)
    8000565c:	d07ff0ef          	jal	80005362 <free_desc>
      for(int j = 0; j < i; j++)
    80005660:	4785                	li	a5,1
    80005662:	0127d663          	bge	a5,s2,8000566e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005666:	f9442503          	lw	a0,-108(s0)
    8000566a:	cf9ff0ef          	jal	80005362 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000566e:	85e2                	mv	a1,s8
    80005670:	0001e517          	auipc	a0,0x1e
    80005674:	ee850513          	addi	a0,a0,-280 # 80023558 <disk+0x18>
    80005678:	869fc0ef          	jal	80001ee0 <sleep>
  for(int i = 0; i < 3; i++){
    8000567c:	f9040613          	addi	a2,s0,-112
    80005680:	894e                	mv	s2,s3
    80005682:	bf55                	j	80005636 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005684:	f9042503          	lw	a0,-112(s0)
    80005688:	00451693          	slli	a3,a0,0x4

  if(write)
    8000568c:	0001e797          	auipc	a5,0x1e
    80005690:	eb478793          	addi	a5,a5,-332 # 80023540 <disk>
    80005694:	00a50713          	addi	a4,a0,10
    80005698:	0712                	slli	a4,a4,0x4
    8000569a:	973e                	add	a4,a4,a5
    8000569c:	01703633          	snez	a2,s7
    800056a0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800056a2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800056a6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800056aa:	6398                	ld	a4,0(a5)
    800056ac:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056ae:	0a868613          	addi	a2,a3,168
    800056b2:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800056b4:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800056b6:	6390                	ld	a2,0(a5)
    800056b8:	00d605b3          	add	a1,a2,a3
    800056bc:	4741                	li	a4,16
    800056be:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800056c0:	4805                	li	a6,1
    800056c2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800056c6:	f9442703          	lw	a4,-108(s0)
    800056ca:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800056ce:	0712                	slli	a4,a4,0x4
    800056d0:	963a                	add	a2,a2,a4
    800056d2:	058a0593          	addi	a1,s4,88
    800056d6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800056d8:	0007b883          	ld	a7,0(a5)
    800056dc:	9746                	add	a4,a4,a7
    800056de:	40000613          	li	a2,1024
    800056e2:	c710                	sw	a2,8(a4)
  if(write)
    800056e4:	001bb613          	seqz	a2,s7
    800056e8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056ec:	00166613          	ori	a2,a2,1
    800056f0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800056f4:	f9842583          	lw	a1,-104(s0)
    800056f8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056fc:	00250613          	addi	a2,a0,2
    80005700:	0612                	slli	a2,a2,0x4
    80005702:	963e                	add	a2,a2,a5
    80005704:	577d                	li	a4,-1
    80005706:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000570a:	0592                	slli	a1,a1,0x4
    8000570c:	98ae                	add	a7,a7,a1
    8000570e:	03068713          	addi	a4,a3,48
    80005712:	973e                	add	a4,a4,a5
    80005714:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005718:	6398                	ld	a4,0(a5)
    8000571a:	972e                	add	a4,a4,a1
    8000571c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005720:	4689                	li	a3,2
    80005722:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005726:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000572a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    8000572e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005732:	6794                	ld	a3,8(a5)
    80005734:	0026d703          	lhu	a4,2(a3)
    80005738:	8b1d                	andi	a4,a4,7
    8000573a:	0706                	slli	a4,a4,0x1
    8000573c:	96ba                	add	a3,a3,a4
    8000573e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005742:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005746:	6798                	ld	a4,8(a5)
    80005748:	00275783          	lhu	a5,2(a4)
    8000574c:	2785                	addiw	a5,a5,1
    8000574e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005752:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005756:	100017b7          	lui	a5,0x10001
    8000575a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000575e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005762:	0001e917          	auipc	s2,0x1e
    80005766:	f0690913          	addi	s2,s2,-250 # 80023668 <disk+0x128>
  while(b->disk == 1) {
    8000576a:	4485                	li	s1,1
    8000576c:	01079a63          	bne	a5,a6,80005780 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005770:	85ca                	mv	a1,s2
    80005772:	8552                	mv	a0,s4
    80005774:	f6cfc0ef          	jal	80001ee0 <sleep>
  while(b->disk == 1) {
    80005778:	004a2783          	lw	a5,4(s4)
    8000577c:	fe978ae3          	beq	a5,s1,80005770 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005780:	f9042903          	lw	s2,-112(s0)
    80005784:	00290713          	addi	a4,s2,2
    80005788:	0712                	slli	a4,a4,0x4
    8000578a:	0001e797          	auipc	a5,0x1e
    8000578e:	db678793          	addi	a5,a5,-586 # 80023540 <disk>
    80005792:	97ba                	add	a5,a5,a4
    80005794:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005798:	0001e997          	auipc	s3,0x1e
    8000579c:	da898993          	addi	s3,s3,-600 # 80023540 <disk>
    800057a0:	00491713          	slli	a4,s2,0x4
    800057a4:	0009b783          	ld	a5,0(s3)
    800057a8:	97ba                	add	a5,a5,a4
    800057aa:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057ae:	854a                	mv	a0,s2
    800057b0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057b4:	bafff0ef          	jal	80005362 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057b8:	8885                	andi	s1,s1,1
    800057ba:	f0fd                	bnez	s1,800057a0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057bc:	0001e517          	auipc	a0,0x1e
    800057c0:	eac50513          	addi	a0,a0,-340 # 80023668 <disk+0x128>
    800057c4:	cd6fb0ef          	jal	80000c9a <release>
}
    800057c8:	70a6                	ld	ra,104(sp)
    800057ca:	7406                	ld	s0,96(sp)
    800057cc:	64e6                	ld	s1,88(sp)
    800057ce:	6946                	ld	s2,80(sp)
    800057d0:	69a6                	ld	s3,72(sp)
    800057d2:	6a06                	ld	s4,64(sp)
    800057d4:	7ae2                	ld	s5,56(sp)
    800057d6:	7b42                	ld	s6,48(sp)
    800057d8:	7ba2                	ld	s7,40(sp)
    800057da:	7c02                	ld	s8,32(sp)
    800057dc:	6ce2                	ld	s9,24(sp)
    800057de:	6165                	addi	sp,sp,112
    800057e0:	8082                	ret

00000000800057e2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057e2:	1101                	addi	sp,sp,-32
    800057e4:	ec06                	sd	ra,24(sp)
    800057e6:	e822                	sd	s0,16(sp)
    800057e8:	e426                	sd	s1,8(sp)
    800057ea:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057ec:	0001e497          	auipc	s1,0x1e
    800057f0:	d5448493          	addi	s1,s1,-684 # 80023540 <disk>
    800057f4:	0001e517          	auipc	a0,0x1e
    800057f8:	e7450513          	addi	a0,a0,-396 # 80023668 <disk+0x128>
    800057fc:	c06fb0ef          	jal	80000c02 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005800:	100017b7          	lui	a5,0x10001
    80005804:	53b8                	lw	a4,96(a5)
    80005806:	8b0d                	andi	a4,a4,3
    80005808:	100017b7          	lui	a5,0x10001
    8000580c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    8000580e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005812:	689c                	ld	a5,16(s1)
    80005814:	0204d703          	lhu	a4,32(s1)
    80005818:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000581c:	04f70663          	beq	a4,a5,80005868 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005820:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005824:	6898                	ld	a4,16(s1)
    80005826:	0204d783          	lhu	a5,32(s1)
    8000582a:	8b9d                	andi	a5,a5,7
    8000582c:	078e                	slli	a5,a5,0x3
    8000582e:	97ba                	add	a5,a5,a4
    80005830:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005832:	00278713          	addi	a4,a5,2
    80005836:	0712                	slli	a4,a4,0x4
    80005838:	9726                	add	a4,a4,s1
    8000583a:	01074703          	lbu	a4,16(a4)
    8000583e:	e321                	bnez	a4,8000587e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005840:	0789                	addi	a5,a5,2
    80005842:	0792                	slli	a5,a5,0x4
    80005844:	97a6                	add	a5,a5,s1
    80005846:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005848:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000584c:	ee0fc0ef          	jal	80001f2c <wakeup>

    disk.used_idx += 1;
    80005850:	0204d783          	lhu	a5,32(s1)
    80005854:	2785                	addiw	a5,a5,1
    80005856:	17c2                	slli	a5,a5,0x30
    80005858:	93c1                	srli	a5,a5,0x30
    8000585a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000585e:	6898                	ld	a4,16(s1)
    80005860:	00275703          	lhu	a4,2(a4)
    80005864:	faf71ee3          	bne	a4,a5,80005820 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005868:	0001e517          	auipc	a0,0x1e
    8000586c:	e0050513          	addi	a0,a0,-512 # 80023668 <disk+0x128>
    80005870:	c2afb0ef          	jal	80000c9a <release>
}
    80005874:	60e2                	ld	ra,24(sp)
    80005876:	6442                	ld	s0,16(sp)
    80005878:	64a2                	ld	s1,8(sp)
    8000587a:	6105                	addi	sp,sp,32
    8000587c:	8082                	ret
      panic("virtio_disk_intr status");
    8000587e:	00002517          	auipc	a0,0x2
    80005882:	eea50513          	addi	a0,a0,-278 # 80007768 <etext+0x768>
    80005886:	f1dfa0ef          	jal	800007a2 <panic>

000000008000588a <sys_kbdint>:
#endif
 

extern int keyboard_int_cnt;
uint64 sys_kbdint()
{
    8000588a:	1141                	addi	sp,sp,-16
    8000588c:	e422                	sd	s0,8(sp)
    8000588e:	0800                	addi	s0,sp,16

return keyboard_int_cnt;
}
    80005890:	00005517          	auipc	a0,0x5
    80005894:	a8052503          	lw	a0,-1408(a0) # 8000a310 <keyboard_int_cnt>
    80005898:	6422                	ld	s0,8(sp)
    8000589a:	0141                	addi	sp,sp,16
    8000589c:	8082                	ret

000000008000589e <sys_random>:

//Random
static unsigned int lcg_state=1; //PRNG state
uint64
sys_random(void)
{
    8000589e:	1141                	addi	sp,sp,-16
    800058a0:	e422                	sd	s0,8(sp)
    800058a2:	0800                	addi	s0,sp,16
  // Seed only once using ticks (global variable provided by xv6)
  extern uint ticks;
  if (lcg_state == 1)
    800058a4:	00005717          	auipc	a4,0x5
    800058a8:	a0472703          	lw	a4,-1532(a4) # 8000a2a8 <lcg_state>
    800058ac:	4785                	li	a5,1
    800058ae:	02f70763          	beq	a4,a5,800058dc <sys_random+0x3e>
    lcg_state = ticks + 1;  // avoid 0 seed

  // LCG formula
  lcg_state = (1103515245 * lcg_state + 12345) & 0x7fffffff;
    800058b2:	00005717          	auipc	a4,0x5
    800058b6:	9f670713          	addi	a4,a4,-1546 # 8000a2a8 <lcg_state>
    800058ba:	4314                	lw	a3,0(a4)
    800058bc:	41c657b7          	lui	a5,0x41c65
    800058c0:	e6d7879b          	addiw	a5,a5,-403 # 41c64e6d <_entry-0x3e39b193>
    800058c4:	02d7853b          	mulw	a0,a5,a3
    800058c8:	678d                	lui	a5,0x3
    800058ca:	0397879b          	addiw	a5,a5,57 # 3039 <_entry-0x7fffcfc7>
    800058ce:	9d3d                	addw	a0,a0,a5
    800058d0:	1506                	slli	a0,a0,0x21
    800058d2:	9105                	srli	a0,a0,0x21
    800058d4:	c308                	sw	a0,0(a4)

  return lcg_state;
}
    800058d6:	6422                	ld	s0,8(sp)
    800058d8:	0141                	addi	sp,sp,16
    800058da:	8082                	ret
    lcg_state = ticks + 1;  // avoid 0 seed
    800058dc:	00005797          	auipc	a5,0x5
    800058e0:	a647a783          	lw	a5,-1436(a5) # 8000a340 <ticks>
    800058e4:	2785                	addiw	a5,a5,1
    800058e6:	00005717          	auipc	a4,0x5
    800058ea:	9cf72123          	sw	a5,-1598(a4) # 8000a2a8 <lcg_state>
    800058ee:	b7d1                	j	800058b2 <sys_random+0x14>

00000000800058f0 <sys_datetime>:
  r->day = (int)day;
}

uint64
sys_datetime(void)
{
    800058f0:	7179                	addi	sp,sp,-48
    800058f2:	f406                	sd	ra,40(sp)
    800058f4:	f022                	sd	s0,32(sp)
    800058f6:	1800                	addi	s0,sp,48
  uint64 user_addr;
  struct rtcdate rd;

  // get user pointer argument 0
  if(argaddr(0, &user_addr) < 0)
    800058f8:	fe840593          	addi	a1,s0,-24
    800058fc:	4501                	li	a0,0
    800058fe:	ee5fc0ef          	jal	800027e2 <argaddr>
    80005902:	87aa                	mv	a5,a0
    return -1;
    80005904:	557d                	li	a0,-1
  if(argaddr(0, &user_addr) < 0)
    80005906:	1207c363          	bltz	a5,80005a2c <sys_datetime+0x13c>

 volatile uint64 *mtime = (volatile uint64 *)CLINT_MTIME;
 uint64 mtime_val = *mtime;   // increments in cycles / platform timeunits
    8000590a:	0200c7b7          	lui	a5,0x200c
    8000590e:	ff87b703          	ld	a4,-8(a5) # 200bff8 <_entry-0x7dff4008>
// Now convert to seconds. The conversion constant depends on the platform's mtime frequency.
// On QEMU virt, mtime increments at the host timer frequency used by the platform (platform dependent).
 

uint64 unix_secs = BOOT_EPOCH + (mtime_val / MTIME_FREQ);
    80005912:	009897b7          	lui	a5,0x989
    80005916:	68078793          	addi	a5,a5,1664 # 989680 <_entry-0x7f676980>
    8000591a:	02f75733          	divu	a4,a4,a5


//TO adjust cairo 
unix_secs+=7200;
    8000591e:	693217b7          	lui	a5,0x69321
    80005922:	70978793          	addi	a5,a5,1801 # 69321709 <_entry-0x16cde8f7>
    80005926:	973e                	add	a4,a4,a5
  uint64 rem = secs % 86400;
    80005928:	66d5                	lui	a3,0x15
    8000592a:	18068693          	addi	a3,a3,384 # 15180 <_entry-0x7ffeae80>
    8000592e:	02d777b3          	remu	a5,a4,a3
  r->hour = rem / 3600;
    80005932:	6605                	lui	a2,0x1
    80005934:	e1060613          	addi	a2,a2,-496 # e10 <_entry-0x7ffff1f0>
    80005938:	02c7d5b3          	divu	a1,a5,a2
    8000593c:	fcb42c23          	sw	a1,-40(s0)
  rem %= 3600;
    80005940:	02c7f7b3          	remu	a5,a5,a2
  r->minute = rem / 60;
    80005944:	03c00613          	li	a2,60
    80005948:	02c7d5b3          	divu	a1,a5,a2
    8000594c:	fcb42a23          	sw	a1,-44(s0)
  r->second = rem % 60;
    80005950:	02c7f7b3          	remu	a5,a5,a2
    80005954:	fcf42823          	sw	a5,-48(s0)
  uint64 days = secs / 86400;
    80005958:	02d75733          	divu	a4,a4,a3
  int64_t z = (int64_t)days + 719468; // shift to 0000-03-01 epoch used by algorithm
    8000595c:	000b07b7          	lui	a5,0xb0
    80005960:	a6c78793          	addi	a5,a5,-1428 # afa6c <_entry-0x7ff50594>
    80005964:	973e                	add	a4,a4,a5
  int64_t era = (z >= 0 ? z : z - 146096) / 146097;
    80005966:	000247b7          	lui	a5,0x24
    8000596a:	ab178793          	addi	a5,a5,-1359 # 23ab1 <_entry-0x7ffdc54f>
    8000596e:	02f748b3          	div	a7,a4,a5
  unsigned doe = (unsigned)(z - era * 146097);          // [0, 146096]
    80005972:	02f887bb          	mulw	a5,a7,a5
    80005976:	9f1d                	subw	a4,a4,a5
  unsigned yoe = (doe - doe/1460 + doe/36524 - doe/146096) / 365; // [0, 399]
    80005978:	66a5                	lui	a3,0x9
    8000597a:	eac6869b          	addiw	a3,a3,-340 # 8eac <_entry-0x7fff7154>
    8000597e:	02d756bb          	divuw	a3,a4,a3
    80005982:	9eb9                	addw	a3,a3,a4
    80005984:	5b400813          	li	a6,1460
    80005988:	030757bb          	divuw	a5,a4,a6
    8000598c:	9e9d                	subw	a3,a3,a5
    8000598e:	000247b7          	lui	a5,0x24
    80005992:	ab07879b          	addiw	a5,a5,-1360 # 23ab0 <_entry-0x7ffdc550>
    80005996:	02f757bb          	divuw	a5,a4,a5
    8000599a:	9e9d                	subw	a3,a3,a5
    8000599c:	16d00593          	li	a1,365
    800059a0:	02b6d53b          	divuw	a0,a3,a1
  int year = (int)(yoe + era * 400);
    800059a4:	19000613          	li	a2,400
    800059a8:	0316063b          	mulw	a2,a2,a7
    800059ac:	9e29                	addw	a2,a2,a0
  unsigned doy = doe - (365*yoe + yoe/4 - yoe/100);     // [0, 365]
    800059ae:	67a5                	lui	a5,0x9
    800059b0:	e947879b          	addiw	a5,a5,-364 # 8e94 <_entry-0x7fff716c>
    800059b4:	02f6d7bb          	divuw	a5,a3,a5
    800059b8:	9fb9                	addw	a5,a5,a4
    800059ba:	0306d6bb          	divuw	a3,a3,a6
    800059be:	9f95                	subw	a5,a5,a3
    800059c0:	02a585bb          	mulw	a1,a1,a0
    800059c4:	9f8d                	subw	a5,a5,a1
  unsigned mp = (5*doy + 2) / 153;                      // [0, 11]
    800059c6:	0027971b          	slliw	a4,a5,0x2
    800059ca:	9f3d                	addw	a4,a4,a5
    800059cc:	2709                	addiw	a4,a4,2
    800059ce:	0007051b          	sext.w	a0,a4
    800059d2:	09900693          	li	a3,153
    800059d6:	02d7573b          	divuw	a4,a4,a3
  unsigned day = doy - (153*mp+2)/5 + 1;                // [1, 31]
    800059da:	2785                	addiw	a5,a5,1
    800059dc:	0037169b          	slliw	a3,a4,0x3
    800059e0:	9eb9                	addw	a3,a3,a4
    800059e2:	0046959b          	slliw	a1,a3,0x4
    800059e6:	9ead                	addw	a3,a3,a1
    800059e8:	2689                	addiw	a3,a3,2
    800059ea:	4595                	li	a1,5
    800059ec:	02b6d6bb          	divuw	a3,a3,a1
    800059f0:	9f95                	subw	a5,a5,a3
  unsigned month = mp + (mp < 10 ? 3 : -9);             // [1, 12]
    800059f2:	5f900593          	li	a1,1529
    800059f6:	56dd                	li	a3,-9
    800059f8:	00a5e363          	bltu	a1,a0,800059fe <sys_datetime+0x10e>
    800059fc:	468d                	li	a3,3
    800059fe:	9f35                	addw	a4,a4,a3
    80005a00:	0007069b          	sext.w	a3,a4
  year += (month <= 2);
    80005a04:	0036b693          	sltiu	a3,a3,3
    80005a08:	9eb1                	addw	a3,a3,a2
  r->year = year;
    80005a0a:	fed42223          	sw	a3,-28(s0)
  r->month = (int)month;
    80005a0e:	fee42023          	sw	a4,-32(s0)
  r->day = (int)day;
    80005a12:	fcf42e23          	sw	a5,-36(s0)

  seconds_to_rtcdate(unix_secs, &rd);


  // copy to user space
  if(copyout(myproc()->pagetable, user_addr, (char *)&rd, sizeof(rd)) < 0)
    80005a16:	efdfb0ef          	jal	80001912 <myproc>
    80005a1a:	46e1                	li	a3,24
    80005a1c:	fd040613          	addi	a2,s0,-48
    80005a20:	fe843583          	ld	a1,-24(s0)
    80005a24:	6928                	ld	a0,80(a0)
    80005a26:	b5ffb0ef          	jal	80001584 <copyout>
    80005a2a:	957d                	srai	a0,a0,0x3f
    return -1;

  return 0;
}
    80005a2c:	70a2                	ld	ra,40(sp)
    80005a2e:	7402                	ld	s0,32(sp)
    80005a30:	6145                	addi	sp,sp,48
    80005a32:	8082                	ret
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
