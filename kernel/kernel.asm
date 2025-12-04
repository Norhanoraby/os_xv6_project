
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	3b013103          	ld	sp,944(sp) # 8000a3b0 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdaeaf>
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
    800000fa:	2ee020ef          	jal	800023e8 <either_copyin>
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
    80000158:	2cc50513          	addi	a0,a0,716 # 80012420 <cons>
    8000015c:	2a7000ef          	jal	80000c02 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00012497          	auipc	s1,0x12
    80000164:	2c048493          	addi	s1,s1,704 # 80012420 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00012917          	auipc	s2,0x12
    8000016c:	35090913          	addi	s2,s2,848 # 800124b8 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	780010ef          	jal	80001900 <myproc>
    80000184:	0f6020ef          	jal	8000227a <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	6b5010ef          	jal	80002042 <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	00012717          	auipc	a4,0x12
    800001a4:	28070713          	addi	a4,a4,640 # 80012420 <cons>
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
    800001d2:	1cc020ef          	jal	8000239e <either_copyout>
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
    800001ee:	23650513          	addi	a0,a0,566 # 80012420 <cons>
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
    80000218:	2af72223          	sw	a5,676(a4) # 800124b8 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	00012517          	auipc	a0,0x12
    8000022e:	1f650513          	addi	a0,a0,502 # 80012420 <cons>
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
    80000282:	1a250513          	addi	a0,a0,418 # 80012420 <cons>
    80000286:	17d000ef          	jal	80000c02 <acquire>
  keyboard_int_cnt++;
    8000028a:	0000a717          	auipc	a4,0xa
    8000028e:	14670713          	addi	a4,a4,326 # 8000a3d0 <keyboard_int_cnt>
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
    800002ae:	184020ef          	jal	80002432 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002b2:	00012517          	auipc	a0,0x12
    800002b6:	16e50513          	addi	a0,a0,366 # 80012420 <cons>
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
    800002d4:	15070713          	addi	a4,a4,336 # 80012420 <cons>
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
    800002fa:	12a78793          	addi	a5,a5,298 # 80012420 <cons>
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
    80000328:	1947a783          	lw	a5,404(a5) # 800124b8 <cons+0x98>
    8000032c:	9f1d                	subw	a4,a4,a5
    8000032e:	08000793          	li	a5,128
    80000332:	f8f710e3          	bne	a4,a5,800002b2 <consoleintr+0x40>
    80000336:	a07d                	j	800003e4 <consoleintr+0x172>
    80000338:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000033a:	00012717          	auipc	a4,0x12
    8000033e:	0e670713          	addi	a4,a4,230 # 80012420 <cons>
    80000342:	0a072783          	lw	a5,160(a4)
    80000346:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	00012497          	auipc	s1,0x12
    8000034e:	0d648493          	addi	s1,s1,214 # 80012420 <cons>
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
    80000390:	09470713          	addi	a4,a4,148 # 80012420 <cons>
    80000394:	0a072783          	lw	a5,160(a4)
    80000398:	09c72703          	lw	a4,156(a4)
    8000039c:	f0f70be3          	beq	a4,a5,800002b2 <consoleintr+0x40>
      cons.e--;
    800003a0:	37fd                	addiw	a5,a5,-1
    800003a2:	00012717          	auipc	a4,0x12
    800003a6:	10f72f23          	sw	a5,286(a4) # 800124c0 <cons+0xa0>
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
    800003c4:	06078793          	addi	a5,a5,96 # 80012420 <cons>
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
    800003e8:	0cc7ac23          	sw	a2,216(a5) # 800124bc <cons+0x9c>
        wakeup(&cons.r);
    800003ec:	00012517          	auipc	a0,0x12
    800003f0:	0cc50513          	addi	a0,a0,204 # 800124b8 <cons+0x98>
    800003f4:	49b010ef          	jal	8000208e <wakeup>
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
    8000040e:	01650513          	addi	a0,a0,22 # 80012420 <cons>
    80000412:	770000ef          	jal	80000b82 <initlock>

  uartinit();
    80000416:	3f4000ef          	jal	8000080a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000041a:	00022797          	auipc	a5,0x22
    8000041e:	39e78793          	addi	a5,a5,926 # 800227b8 <devsw>
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
    800004f2:	ff27a783          	lw	a5,-14(a5) # 800124e0 <pr+0x18>
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
    8000053e:	f8e50513          	addi	a0,a0,-114 # 800124c8 <pr>
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
    80000798:	d3450513          	addi	a0,a0,-716 # 800124c8 <pr>
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
    800007b2:	d207a923          	sw	zero,-718(a5) # 800124e0 <pr+0x18>
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
    800007d6:	c0f72123          	sw	a5,-1022(a4) # 8000a3d4 <panicked>
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
    800007ea:	ce248493          	addi	s1,s1,-798 # 800124c8 <pr>
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
    80000852:	c9a50513          	addi	a0,a0,-870 # 800124e8 <uart_tx_lock>
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
    80000876:	b627a783          	lw	a5,-1182(a5) # 8000a3d4 <panicked>
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
    800008ac:	b307b783          	ld	a5,-1232(a5) # 8000a3d8 <uart_tx_r>
    800008b0:	0000a717          	auipc	a4,0xa
    800008b4:	b3073703          	ld	a4,-1232(a4) # 8000a3e0 <uart_tx_w>
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
    800008da:	c12a8a93          	addi	s5,s5,-1006 # 800124e8 <uart_tx_lock>
    uart_tx_r += 1;
    800008de:	0000a497          	auipc	s1,0xa
    800008e2:	afa48493          	addi	s1,s1,-1286 # 8000a3d8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008e6:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008ea:	0000a997          	auipc	s3,0xa
    800008ee:	af698993          	addi	s3,s3,-1290 # 8000a3e0 <uart_tx_w>
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
    8000090c:	782010ef          	jal	8000208e <wakeup>
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
    8000095e:	b8e50513          	addi	a0,a0,-1138 # 800124e8 <uart_tx_lock>
    80000962:	2a0000ef          	jal	80000c02 <acquire>
  if(panicked){
    80000966:	0000a797          	auipc	a5,0xa
    8000096a:	a6e7a783          	lw	a5,-1426(a5) # 8000a3d4 <panicked>
    8000096e:	efbd                	bnez	a5,800009ec <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000970:	0000a717          	auipc	a4,0xa
    80000974:	a7073703          	ld	a4,-1424(a4) # 8000a3e0 <uart_tx_w>
    80000978:	0000a797          	auipc	a5,0xa
    8000097c:	a607b783          	ld	a5,-1440(a5) # 8000a3d8 <uart_tx_r>
    80000980:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000984:	00012997          	auipc	s3,0x12
    80000988:	b6498993          	addi	s3,s3,-1180 # 800124e8 <uart_tx_lock>
    8000098c:	0000a497          	auipc	s1,0xa
    80000990:	a4c48493          	addi	s1,s1,-1460 # 8000a3d8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000994:	0000a917          	auipc	s2,0xa
    80000998:	a4c90913          	addi	s2,s2,-1460 # 8000a3e0 <uart_tx_w>
    8000099c:	00e79d63          	bne	a5,a4,800009b6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800009a0:	85ce                	mv	a1,s3
    800009a2:	8526                	mv	a0,s1
    800009a4:	69e010ef          	jal	80002042 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800009a8:	00093703          	ld	a4,0(s2)
    800009ac:	609c                	ld	a5,0(s1)
    800009ae:	02078793          	addi	a5,a5,32
    800009b2:	fee787e3          	beq	a5,a4,800009a0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009b6:	00012497          	auipc	s1,0x12
    800009ba:	b3248493          	addi	s1,s1,-1230 # 800124e8 <uart_tx_lock>
    800009be:	01f77793          	andi	a5,a4,31
    800009c2:	97a6                	add	a5,a5,s1
    800009c4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009c8:	0705                	addi	a4,a4,1
    800009ca:	0000a797          	auipc	a5,0xa
    800009ce:	a0e7bb23          	sd	a4,-1514(a5) # 8000a3e0 <uart_tx_w>
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
    80000a32:	aba48493          	addi	s1,s1,-1350 # 800124e8 <uart_tx_lock>
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
    80000a68:	eec78793          	addi	a5,a5,-276 # 80023950 <end>
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
    80000a84:	aa090913          	addi	s2,s2,-1376 # 80012520 <kmem>
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
    80000b12:	a1250513          	addi	a0,a0,-1518 # 80012520 <kmem>
    80000b16:	06c000ef          	jal	80000b82 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b1a:	45c5                	li	a1,17
    80000b1c:	05ee                	slli	a1,a1,0x1b
    80000b1e:	00023517          	auipc	a0,0x23
    80000b22:	e3250513          	addi	a0,a0,-462 # 80023950 <end>
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
    80000b40:	9e448493          	addi	s1,s1,-1564 # 80012520 <kmem>
    80000b44:	8526                	mv	a0,s1
    80000b46:	0bc000ef          	jal	80000c02 <acquire>
  r = kmem.freelist;
    80000b4a:	6c84                	ld	s1,24(s1)
  if(r)
    80000b4c:	c485                	beqz	s1,80000b74 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b4e:	609c                	ld	a5,0(s1)
    80000b50:	00012517          	auipc	a0,0x12
    80000b54:	9d050513          	addi	a0,a0,-1584 # 80012520 <kmem>
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
    80000b78:	9ac50513          	addi	a0,a0,-1620 # 80012520 <kmem>
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
    80000bac:	539000ef          	jal	800018e4 <mycpu>
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
    80000bda:	50b000ef          	jal	800018e4 <mycpu>
    80000bde:	5d3c                	lw	a5,120(a0)
    80000be0:	cb99                	beqz	a5,80000bf6 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000be2:	503000ef          	jal	800018e4 <mycpu>
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
    80000bf6:	4ef000ef          	jal	800018e4 <mycpu>
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
    80000c2a:	4bb000ef          	jal	800018e4 <mycpu>
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
    80000c4e:	497000ef          	jal	800018e4 <mycpu>
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
    80000d4a:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb6b1>
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
    80000e78:	25d000ef          	jal	800018d4 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e7c:	00009717          	auipc	a4,0x9
    80000e80:	56c70713          	addi	a4,a4,1388 # 8000a3e8 <started>
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
    80000e90:	245000ef          	jal	800018d4 <cpuid>
    80000e94:	85aa                	mv	a1,a0
    80000e96:	00006517          	auipc	a0,0x6
    80000e9a:	20250513          	addi	a0,a0,514 # 80007098 <etext+0x98>
    80000e9e:	e32ff0ef          	jal	800004d0 <printf>
    kvminithart();    // turn on paging
    80000ea2:	080000ef          	jal	80000f22 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ea6:	6be010ef          	jal	80002564 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000eaa:	62e040ef          	jal	800054d8 <plicinithart>
  }

  scheduler();        
    80000eae:	016010ef          	jal	80001ec4 <scheduler>
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
    80000ee2:	2dc000ef          	jal	800011be <kvminit>
    kvminithart();   // turn on paging
    80000ee6:	03c000ef          	jal	80000f22 <kvminithart>
    procinit();      // process table
    80000eea:	135000ef          	jal	8000181e <procinit>
    trapinit();      // trap vectors
    80000eee:	652010ef          	jal	80002540 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ef2:	672010ef          	jal	80002564 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ef6:	5c8040ef          	jal	800054be <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000efa:	5de040ef          	jal	800054d8 <plicinithart>
    binit();         // buffer cache
    80000efe:	589010ef          	jal	80002c86 <binit>
    iinit();         // inode table
    80000f02:	37a020ef          	jal	8000327c <iinit>
    fileinit();      // file table
    80000f06:	126030ef          	jal	8000402c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f0a:	6be040ef          	jal	800055c8 <virtio_disk_init>
    userinit();      // first user process
    80000f0e:	55b000ef          	jal	80001c68 <userinit>
    __sync_synchronize();
    80000f12:	0330000f          	fence	rw,rw
    started = 1;
    80000f16:	4785                	li	a5,1
    80000f18:	00009717          	auipc	a4,0x9
    80000f1c:	4cf72823          	sw	a5,1232(a4) # 8000a3e8 <started>
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
    80000f30:	4c47b783          	ld	a5,1220(a5) # 8000a3f0 <kernel_pagetable>
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
    80000f9e:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb6a7>
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
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000114a:	4719                	li	a4,6
    8000114c:	040006b7          	lui	a3,0x4000
    80001150:	0c000637          	lui	a2,0xc000
    80001154:	0c0005b7          	lui	a1,0xc000
    80001158:	8526                	mv	a0,s1
    8000115a:	f79ff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000115e:	00006917          	auipc	s2,0x6
    80001162:	ea290913          	addi	s2,s2,-350 # 80007000 <etext>
    80001166:	4729                	li	a4,10
    80001168:	80006697          	auipc	a3,0x80006
    8000116c:	e9868693          	addi	a3,a3,-360 # 7000 <_entry-0x7fff9000>
    80001170:	4605                	li	a2,1
    80001172:	067e                	slli	a2,a2,0x1f
    80001174:	85b2                	mv	a1,a2
    80001176:	8526                	mv	a0,s1
    80001178:	f5bff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000117c:	46c5                	li	a3,17
    8000117e:	06ee                	slli	a3,a3,0x1b
    80001180:	4719                	li	a4,6
    80001182:	412686b3          	sub	a3,a3,s2
    80001186:	864a                	mv	a2,s2
    80001188:	85ca                	mv	a1,s2
    8000118a:	8526                	mv	a0,s1
    8000118c:	f47ff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001190:	4729                	li	a4,10
    80001192:	6685                	lui	a3,0x1
    80001194:	00005617          	auipc	a2,0x5
    80001198:	e6c60613          	addi	a2,a2,-404 # 80006000 <_trampoline>
    8000119c:	040005b7          	lui	a1,0x4000
    800011a0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011a2:	05b2                	slli	a1,a1,0xc
    800011a4:	8526                	mv	a0,s1
    800011a6:	f2dff0ef          	jal	800010d2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800011aa:	8526                	mv	a0,s1
    800011ac:	5da000ef          	jal	80001786 <proc_mapstacks>
}
    800011b0:	8526                	mv	a0,s1
    800011b2:	60e2                	ld	ra,24(sp)
    800011b4:	6442                	ld	s0,16(sp)
    800011b6:	64a2                	ld	s1,8(sp)
    800011b8:	6902                	ld	s2,0(sp)
    800011ba:	6105                	addi	sp,sp,32
    800011bc:	8082                	ret

00000000800011be <kvminit>:
{
    800011be:	1141                	addi	sp,sp,-16
    800011c0:	e406                	sd	ra,8(sp)
    800011c2:	e022                	sd	s0,0(sp)
    800011c4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011c6:	f35ff0ef          	jal	800010fa <kvmmake>
    800011ca:	00009797          	auipc	a5,0x9
    800011ce:	22a7b323          	sd	a0,550(a5) # 8000a3f0 <kernel_pagetable>
}
    800011d2:	60a2                	ld	ra,8(sp)
    800011d4:	6402                	ld	s0,0(sp)
    800011d6:	0141                	addi	sp,sp,16
    800011d8:	8082                	ret

00000000800011da <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011da:	715d                	addi	sp,sp,-80
    800011dc:	e486                	sd	ra,72(sp)
    800011de:	e0a2                	sd	s0,64(sp)
    800011e0:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011e2:	03459793          	slli	a5,a1,0x34
    800011e6:	e39d                	bnez	a5,8000120c <uvmunmap+0x32>
    800011e8:	f84a                	sd	s2,48(sp)
    800011ea:	f44e                	sd	s3,40(sp)
    800011ec:	f052                	sd	s4,32(sp)
    800011ee:	ec56                	sd	s5,24(sp)
    800011f0:	e85a                	sd	s6,16(sp)
    800011f2:	e45e                	sd	s7,8(sp)
    800011f4:	8a2a                	mv	s4,a0
    800011f6:	892e                	mv	s2,a1
    800011f8:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011fa:	0632                	slli	a2,a2,0xc
    800011fc:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001200:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001202:	6b05                	lui	s6,0x1
    80001204:	0735ff63          	bgeu	a1,s3,80001282 <uvmunmap+0xa8>
    80001208:	fc26                	sd	s1,56(sp)
    8000120a:	a0a9                	j	80001254 <uvmunmap+0x7a>
    8000120c:	fc26                	sd	s1,56(sp)
    8000120e:	f84a                	sd	s2,48(sp)
    80001210:	f44e                	sd	s3,40(sp)
    80001212:	f052                	sd	s4,32(sp)
    80001214:	ec56                	sd	s5,24(sp)
    80001216:	e85a                	sd	s6,16(sp)
    80001218:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000121a:	00006517          	auipc	a0,0x6
    8000121e:	f0650513          	addi	a0,a0,-250 # 80007120 <etext+0x120>
    80001222:	d80ff0ef          	jal	800007a2 <panic>
      panic("uvmunmap: walk");
    80001226:	00006517          	auipc	a0,0x6
    8000122a:	f1250513          	addi	a0,a0,-238 # 80007138 <etext+0x138>
    8000122e:	d74ff0ef          	jal	800007a2 <panic>
      panic("uvmunmap: not mapped");
    80001232:	00006517          	auipc	a0,0x6
    80001236:	f1650513          	addi	a0,a0,-234 # 80007148 <etext+0x148>
    8000123a:	d68ff0ef          	jal	800007a2 <panic>
      panic("uvmunmap: not a leaf");
    8000123e:	00006517          	auipc	a0,0x6
    80001242:	f2250513          	addi	a0,a0,-222 # 80007160 <etext+0x160>
    80001246:	d5cff0ef          	jal	800007a2 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000124a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000124e:	995a                	add	s2,s2,s6
    80001250:	03397863          	bgeu	s2,s3,80001280 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001254:	4601                	li	a2,0
    80001256:	85ca                	mv	a1,s2
    80001258:	8552                	mv	a0,s4
    8000125a:	cf1ff0ef          	jal	80000f4a <walk>
    8000125e:	84aa                	mv	s1,a0
    80001260:	d179                	beqz	a0,80001226 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001262:	6108                	ld	a0,0(a0)
    80001264:	00157793          	andi	a5,a0,1
    80001268:	d7e9                	beqz	a5,80001232 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000126a:	3ff57793          	andi	a5,a0,1023
    8000126e:	fd7788e3          	beq	a5,s7,8000123e <uvmunmap+0x64>
    if(do_free){
    80001272:	fc0a8ce3          	beqz	s5,8000124a <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    80001276:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001278:	0532                	slli	a0,a0,0xc
    8000127a:	fd6ff0ef          	jal	80000a50 <kfree>
    8000127e:	b7f1                	j	8000124a <uvmunmap+0x70>
    80001280:	74e2                	ld	s1,56(sp)
    80001282:	7942                	ld	s2,48(sp)
    80001284:	79a2                	ld	s3,40(sp)
    80001286:	7a02                	ld	s4,32(sp)
    80001288:	6ae2                	ld	s5,24(sp)
    8000128a:	6b42                	ld	s6,16(sp)
    8000128c:	6ba2                	ld	s7,8(sp)
  }
}
    8000128e:	60a6                	ld	ra,72(sp)
    80001290:	6406                	ld	s0,64(sp)
    80001292:	6161                	addi	sp,sp,80
    80001294:	8082                	ret

0000000080001296 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001296:	1101                	addi	sp,sp,-32
    80001298:	ec06                	sd	ra,24(sp)
    8000129a:	e822                	sd	s0,16(sp)
    8000129c:	e426                	sd	s1,8(sp)
    8000129e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800012a0:	893ff0ef          	jal	80000b32 <kalloc>
    800012a4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800012a6:	c509                	beqz	a0,800012b0 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800012a8:	6605                	lui	a2,0x1
    800012aa:	4581                	li	a1,0
    800012ac:	a2bff0ef          	jal	80000cd6 <memset>
  return pagetable;
}
    800012b0:	8526                	mv	a0,s1
    800012b2:	60e2                	ld	ra,24(sp)
    800012b4:	6442                	ld	s0,16(sp)
    800012b6:	64a2                	ld	s1,8(sp)
    800012b8:	6105                	addi	sp,sp,32
    800012ba:	8082                	ret

00000000800012bc <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800012bc:	7179                	addi	sp,sp,-48
    800012be:	f406                	sd	ra,40(sp)
    800012c0:	f022                	sd	s0,32(sp)
    800012c2:	ec26                	sd	s1,24(sp)
    800012c4:	e84a                	sd	s2,16(sp)
    800012c6:	e44e                	sd	s3,8(sp)
    800012c8:	e052                	sd	s4,0(sp)
    800012ca:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012cc:	6785                	lui	a5,0x1
    800012ce:	04f67063          	bgeu	a2,a5,8000130e <uvmfirst+0x52>
    800012d2:	8a2a                	mv	s4,a0
    800012d4:	89ae                	mv	s3,a1
    800012d6:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012d8:	85bff0ef          	jal	80000b32 <kalloc>
    800012dc:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012de:	6605                	lui	a2,0x1
    800012e0:	4581                	li	a1,0
    800012e2:	9f5ff0ef          	jal	80000cd6 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012e6:	4779                	li	a4,30
    800012e8:	86ca                	mv	a3,s2
    800012ea:	6605                	lui	a2,0x1
    800012ec:	4581                	li	a1,0
    800012ee:	8552                	mv	a0,s4
    800012f0:	d33ff0ef          	jal	80001022 <mappages>
  memmove(mem, src, sz);
    800012f4:	8626                	mv	a2,s1
    800012f6:	85ce                	mv	a1,s3
    800012f8:	854a                	mv	a0,s2
    800012fa:	a39ff0ef          	jal	80000d32 <memmove>
}
    800012fe:	70a2                	ld	ra,40(sp)
    80001300:	7402                	ld	s0,32(sp)
    80001302:	64e2                	ld	s1,24(sp)
    80001304:	6942                	ld	s2,16(sp)
    80001306:	69a2                	ld	s3,8(sp)
    80001308:	6a02                	ld	s4,0(sp)
    8000130a:	6145                	addi	sp,sp,48
    8000130c:	8082                	ret
    panic("uvmfirst: more than a page");
    8000130e:	00006517          	auipc	a0,0x6
    80001312:	e6a50513          	addi	a0,a0,-406 # 80007178 <etext+0x178>
    80001316:	c8cff0ef          	jal	800007a2 <panic>

000000008000131a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000131a:	1101                	addi	sp,sp,-32
    8000131c:	ec06                	sd	ra,24(sp)
    8000131e:	e822                	sd	s0,16(sp)
    80001320:	e426                	sd	s1,8(sp)
    80001322:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001324:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001326:	00b67d63          	bgeu	a2,a1,80001340 <uvmdealloc+0x26>
    8000132a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000132c:	6785                	lui	a5,0x1
    8000132e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001330:	00f60733          	add	a4,a2,a5
    80001334:	76fd                	lui	a3,0xfffff
    80001336:	8f75                	and	a4,a4,a3
    80001338:	97ae                	add	a5,a5,a1
    8000133a:	8ff5                	and	a5,a5,a3
    8000133c:	00f76863          	bltu	a4,a5,8000134c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001340:	8526                	mv	a0,s1
    80001342:	60e2                	ld	ra,24(sp)
    80001344:	6442                	ld	s0,16(sp)
    80001346:	64a2                	ld	s1,8(sp)
    80001348:	6105                	addi	sp,sp,32
    8000134a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000134c:	8f99                	sub	a5,a5,a4
    8000134e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001350:	4685                	li	a3,1
    80001352:	0007861b          	sext.w	a2,a5
    80001356:	85ba                	mv	a1,a4
    80001358:	e83ff0ef          	jal	800011da <uvmunmap>
    8000135c:	b7d5                	j	80001340 <uvmdealloc+0x26>

000000008000135e <uvmalloc>:
  if(newsz < oldsz)
    8000135e:	08b66f63          	bltu	a2,a1,800013fc <uvmalloc+0x9e>
{
    80001362:	7139                	addi	sp,sp,-64
    80001364:	fc06                	sd	ra,56(sp)
    80001366:	f822                	sd	s0,48(sp)
    80001368:	ec4e                	sd	s3,24(sp)
    8000136a:	e852                	sd	s4,16(sp)
    8000136c:	e456                	sd	s5,8(sp)
    8000136e:	0080                	addi	s0,sp,64
    80001370:	8aaa                	mv	s5,a0
    80001372:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001374:	6785                	lui	a5,0x1
    80001376:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001378:	95be                	add	a1,a1,a5
    8000137a:	77fd                	lui	a5,0xfffff
    8000137c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001380:	08c9f063          	bgeu	s3,a2,80001400 <uvmalloc+0xa2>
    80001384:	f426                	sd	s1,40(sp)
    80001386:	f04a                	sd	s2,32(sp)
    80001388:	e05a                	sd	s6,0(sp)
    8000138a:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000138c:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001390:	fa2ff0ef          	jal	80000b32 <kalloc>
    80001394:	84aa                	mv	s1,a0
    if(mem == 0){
    80001396:	c515                	beqz	a0,800013c2 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001398:	6605                	lui	a2,0x1
    8000139a:	4581                	li	a1,0
    8000139c:	93bff0ef          	jal	80000cd6 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800013a0:	875a                	mv	a4,s6
    800013a2:	86a6                	mv	a3,s1
    800013a4:	6605                	lui	a2,0x1
    800013a6:	85ca                	mv	a1,s2
    800013a8:	8556                	mv	a0,s5
    800013aa:	c79ff0ef          	jal	80001022 <mappages>
    800013ae:	e915                	bnez	a0,800013e2 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800013b0:	6785                	lui	a5,0x1
    800013b2:	993e                	add	s2,s2,a5
    800013b4:	fd496ee3          	bltu	s2,s4,80001390 <uvmalloc+0x32>
  return newsz;
    800013b8:	8552                	mv	a0,s4
    800013ba:	74a2                	ld	s1,40(sp)
    800013bc:	7902                	ld	s2,32(sp)
    800013be:	6b02                	ld	s6,0(sp)
    800013c0:	a811                	j	800013d4 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800013c2:	864e                	mv	a2,s3
    800013c4:	85ca                	mv	a1,s2
    800013c6:	8556                	mv	a0,s5
    800013c8:	f53ff0ef          	jal	8000131a <uvmdealloc>
      return 0;
    800013cc:	4501                	li	a0,0
    800013ce:	74a2                	ld	s1,40(sp)
    800013d0:	7902                	ld	s2,32(sp)
    800013d2:	6b02                	ld	s6,0(sp)
}
    800013d4:	70e2                	ld	ra,56(sp)
    800013d6:	7442                	ld	s0,48(sp)
    800013d8:	69e2                	ld	s3,24(sp)
    800013da:	6a42                	ld	s4,16(sp)
    800013dc:	6aa2                	ld	s5,8(sp)
    800013de:	6121                	addi	sp,sp,64
    800013e0:	8082                	ret
      kfree(mem);
    800013e2:	8526                	mv	a0,s1
    800013e4:	e6cff0ef          	jal	80000a50 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013e8:	864e                	mv	a2,s3
    800013ea:	85ca                	mv	a1,s2
    800013ec:	8556                	mv	a0,s5
    800013ee:	f2dff0ef          	jal	8000131a <uvmdealloc>
      return 0;
    800013f2:	4501                	li	a0,0
    800013f4:	74a2                	ld	s1,40(sp)
    800013f6:	7902                	ld	s2,32(sp)
    800013f8:	6b02                	ld	s6,0(sp)
    800013fa:	bfe9                	j	800013d4 <uvmalloc+0x76>
    return oldsz;
    800013fc:	852e                	mv	a0,a1
}
    800013fe:	8082                	ret
  return newsz;
    80001400:	8532                	mv	a0,a2
    80001402:	bfc9                	j	800013d4 <uvmalloc+0x76>

0000000080001404 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001404:	7179                	addi	sp,sp,-48
    80001406:	f406                	sd	ra,40(sp)
    80001408:	f022                	sd	s0,32(sp)
    8000140a:	ec26                	sd	s1,24(sp)
    8000140c:	e84a                	sd	s2,16(sp)
    8000140e:	e44e                	sd	s3,8(sp)
    80001410:	e052                	sd	s4,0(sp)
    80001412:	1800                	addi	s0,sp,48
    80001414:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001416:	84aa                	mv	s1,a0
    80001418:	6905                	lui	s2,0x1
    8000141a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000141c:	4985                	li	s3,1
    8000141e:	a819                	j	80001434 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001420:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001422:	00c79513          	slli	a0,a5,0xc
    80001426:	fdfff0ef          	jal	80001404 <freewalk>
      pagetable[i] = 0;
    8000142a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000142e:	04a1                	addi	s1,s1,8
    80001430:	01248f63          	beq	s1,s2,8000144e <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001434:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001436:	00f7f713          	andi	a4,a5,15
    8000143a:	ff3703e3          	beq	a4,s3,80001420 <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000143e:	8b85                	andi	a5,a5,1
    80001440:	d7fd                	beqz	a5,8000142e <freewalk+0x2a>
      panic("freewalk: leaf");
    80001442:	00006517          	auipc	a0,0x6
    80001446:	d5650513          	addi	a0,a0,-682 # 80007198 <etext+0x198>
    8000144a:	b58ff0ef          	jal	800007a2 <panic>
    }
  }
  kfree((void*)pagetable);
    8000144e:	8552                	mv	a0,s4
    80001450:	e00ff0ef          	jal	80000a50 <kfree>
}
    80001454:	70a2                	ld	ra,40(sp)
    80001456:	7402                	ld	s0,32(sp)
    80001458:	64e2                	ld	s1,24(sp)
    8000145a:	6942                	ld	s2,16(sp)
    8000145c:	69a2                	ld	s3,8(sp)
    8000145e:	6a02                	ld	s4,0(sp)
    80001460:	6145                	addi	sp,sp,48
    80001462:	8082                	ret

0000000080001464 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001464:	1101                	addi	sp,sp,-32
    80001466:	ec06                	sd	ra,24(sp)
    80001468:	e822                	sd	s0,16(sp)
    8000146a:	e426                	sd	s1,8(sp)
    8000146c:	1000                	addi	s0,sp,32
    8000146e:	84aa                	mv	s1,a0
  if(sz > 0)
    80001470:	e989                	bnez	a1,80001482 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001472:	8526                	mv	a0,s1
    80001474:	f91ff0ef          	jal	80001404 <freewalk>
}
    80001478:	60e2                	ld	ra,24(sp)
    8000147a:	6442                	ld	s0,16(sp)
    8000147c:	64a2                	ld	s1,8(sp)
    8000147e:	6105                	addi	sp,sp,32
    80001480:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001482:	6785                	lui	a5,0x1
    80001484:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001486:	95be                	add	a1,a1,a5
    80001488:	4685                	li	a3,1
    8000148a:	00c5d613          	srli	a2,a1,0xc
    8000148e:	4581                	li	a1,0
    80001490:	d4bff0ef          	jal	800011da <uvmunmap>
    80001494:	bff9                	j	80001472 <uvmfree+0xe>

0000000080001496 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001496:	c65d                	beqz	a2,80001544 <uvmcopy+0xae>
{
    80001498:	715d                	addi	sp,sp,-80
    8000149a:	e486                	sd	ra,72(sp)
    8000149c:	e0a2                	sd	s0,64(sp)
    8000149e:	fc26                	sd	s1,56(sp)
    800014a0:	f84a                	sd	s2,48(sp)
    800014a2:	f44e                	sd	s3,40(sp)
    800014a4:	f052                	sd	s4,32(sp)
    800014a6:	ec56                	sd	s5,24(sp)
    800014a8:	e85a                	sd	s6,16(sp)
    800014aa:	e45e                	sd	s7,8(sp)
    800014ac:	0880                	addi	s0,sp,80
    800014ae:	8b2a                	mv	s6,a0
    800014b0:	8aae                	mv	s5,a1
    800014b2:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800014b4:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800014b6:	4601                	li	a2,0
    800014b8:	85ce                	mv	a1,s3
    800014ba:	855a                	mv	a0,s6
    800014bc:	a8fff0ef          	jal	80000f4a <walk>
    800014c0:	c121                	beqz	a0,80001500 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800014c2:	6118                	ld	a4,0(a0)
    800014c4:	00177793          	andi	a5,a4,1
    800014c8:	c3b1                	beqz	a5,8000150c <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800014ca:	00a75593          	srli	a1,a4,0xa
    800014ce:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014d2:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014d6:	e5cff0ef          	jal	80000b32 <kalloc>
    800014da:	892a                	mv	s2,a0
    800014dc:	c129                	beqz	a0,8000151e <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014de:	6605                	lui	a2,0x1
    800014e0:	85de                	mv	a1,s7
    800014e2:	851ff0ef          	jal	80000d32 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014e6:	8726                	mv	a4,s1
    800014e8:	86ca                	mv	a3,s2
    800014ea:	6605                	lui	a2,0x1
    800014ec:	85ce                	mv	a1,s3
    800014ee:	8556                	mv	a0,s5
    800014f0:	b33ff0ef          	jal	80001022 <mappages>
    800014f4:	e115                	bnez	a0,80001518 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    800014f6:	6785                	lui	a5,0x1
    800014f8:	99be                	add	s3,s3,a5
    800014fa:	fb49eee3          	bltu	s3,s4,800014b6 <uvmcopy+0x20>
    800014fe:	a805                	j	8000152e <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80001500:	00006517          	auipc	a0,0x6
    80001504:	ca850513          	addi	a0,a0,-856 # 800071a8 <etext+0x1a8>
    80001508:	a9aff0ef          	jal	800007a2 <panic>
      panic("uvmcopy: page not present");
    8000150c:	00006517          	auipc	a0,0x6
    80001510:	cbc50513          	addi	a0,a0,-836 # 800071c8 <etext+0x1c8>
    80001514:	a8eff0ef          	jal	800007a2 <panic>
      kfree(mem);
    80001518:	854a                	mv	a0,s2
    8000151a:	d36ff0ef          	jal	80000a50 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000151e:	4685                	li	a3,1
    80001520:	00c9d613          	srli	a2,s3,0xc
    80001524:	4581                	li	a1,0
    80001526:	8556                	mv	a0,s5
    80001528:	cb3ff0ef          	jal	800011da <uvmunmap>
  return -1;
    8000152c:	557d                	li	a0,-1
}
    8000152e:	60a6                	ld	ra,72(sp)
    80001530:	6406                	ld	s0,64(sp)
    80001532:	74e2                	ld	s1,56(sp)
    80001534:	7942                	ld	s2,48(sp)
    80001536:	79a2                	ld	s3,40(sp)
    80001538:	7a02                	ld	s4,32(sp)
    8000153a:	6ae2                	ld	s5,24(sp)
    8000153c:	6b42                	ld	s6,16(sp)
    8000153e:	6ba2                	ld	s7,8(sp)
    80001540:	6161                	addi	sp,sp,80
    80001542:	8082                	ret
  return 0;
    80001544:	4501                	li	a0,0
}
    80001546:	8082                	ret

0000000080001548 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001548:	1141                	addi	sp,sp,-16
    8000154a:	e406                	sd	ra,8(sp)
    8000154c:	e022                	sd	s0,0(sp)
    8000154e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001550:	4601                	li	a2,0
    80001552:	9f9ff0ef          	jal	80000f4a <walk>
  if(pte == 0)
    80001556:	c901                	beqz	a0,80001566 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001558:	611c                	ld	a5,0(a0)
    8000155a:	9bbd                	andi	a5,a5,-17
    8000155c:	e11c                	sd	a5,0(a0)
}
    8000155e:	60a2                	ld	ra,8(sp)
    80001560:	6402                	ld	s0,0(sp)
    80001562:	0141                	addi	sp,sp,16
    80001564:	8082                	ret
    panic("uvmclear");
    80001566:	00006517          	auipc	a0,0x6
    8000156a:	c8250513          	addi	a0,a0,-894 # 800071e8 <etext+0x1e8>
    8000156e:	a34ff0ef          	jal	800007a2 <panic>

0000000080001572 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001572:	cad1                	beqz	a3,80001606 <copyout+0x94>
{
    80001574:	711d                	addi	sp,sp,-96
    80001576:	ec86                	sd	ra,88(sp)
    80001578:	e8a2                	sd	s0,80(sp)
    8000157a:	e4a6                	sd	s1,72(sp)
    8000157c:	fc4e                	sd	s3,56(sp)
    8000157e:	f456                	sd	s5,40(sp)
    80001580:	f05a                	sd	s6,32(sp)
    80001582:	ec5e                	sd	s7,24(sp)
    80001584:	1080                	addi	s0,sp,96
    80001586:	8baa                	mv	s7,a0
    80001588:	8aae                	mv	s5,a1
    8000158a:	8b32                	mv	s6,a2
    8000158c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000158e:	74fd                	lui	s1,0xfffff
    80001590:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001592:	57fd                	li	a5,-1
    80001594:	83e9                	srli	a5,a5,0x1a
    80001596:	0697ea63          	bltu	a5,s1,8000160a <copyout+0x98>
    8000159a:	e0ca                	sd	s2,64(sp)
    8000159c:	f852                	sd	s4,48(sp)
    8000159e:	e862                	sd	s8,16(sp)
    800015a0:	e466                	sd	s9,8(sp)
    800015a2:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015a4:	4cd5                	li	s9,21
    800015a6:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    800015a8:	8c3e                	mv	s8,a5
    800015aa:	a025                	j	800015d2 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    800015ac:	83a9                	srli	a5,a5,0xa
    800015ae:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800015b0:	409a8533          	sub	a0,s5,s1
    800015b4:	0009061b          	sext.w	a2,s2
    800015b8:	85da                	mv	a1,s6
    800015ba:	953e                	add	a0,a0,a5
    800015bc:	f76ff0ef          	jal	80000d32 <memmove>

    len -= n;
    800015c0:	412989b3          	sub	s3,s3,s2
    src += n;
    800015c4:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800015c6:	02098963          	beqz	s3,800015f8 <copyout+0x86>
    if(va0 >= MAXVA)
    800015ca:	054c6263          	bltu	s8,s4,8000160e <copyout+0x9c>
    800015ce:	84d2                	mv	s1,s4
    800015d0:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    800015d2:	4601                	li	a2,0
    800015d4:	85a6                	mv	a1,s1
    800015d6:	855e                	mv	a0,s7
    800015d8:	973ff0ef          	jal	80000f4a <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015dc:	c121                	beqz	a0,8000161c <copyout+0xaa>
    800015de:	611c                	ld	a5,0(a0)
    800015e0:	0157f713          	andi	a4,a5,21
    800015e4:	05971b63          	bne	a4,s9,8000163a <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    800015e8:	01a48a33          	add	s4,s1,s10
    800015ec:	415a0933          	sub	s2,s4,s5
    if(n > len)
    800015f0:	fb29fee3          	bgeu	s3,s2,800015ac <copyout+0x3a>
    800015f4:	894e                	mv	s2,s3
    800015f6:	bf5d                	j	800015ac <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    800015f8:	4501                	li	a0,0
    800015fa:	6906                	ld	s2,64(sp)
    800015fc:	7a42                	ld	s4,48(sp)
    800015fe:	6c42                	ld	s8,16(sp)
    80001600:	6ca2                	ld	s9,8(sp)
    80001602:	6d02                	ld	s10,0(sp)
    80001604:	a015                	j	80001628 <copyout+0xb6>
    80001606:	4501                	li	a0,0
}
    80001608:	8082                	ret
      return -1;
    8000160a:	557d                	li	a0,-1
    8000160c:	a831                	j	80001628 <copyout+0xb6>
    8000160e:	557d                	li	a0,-1
    80001610:	6906                	ld	s2,64(sp)
    80001612:	7a42                	ld	s4,48(sp)
    80001614:	6c42                	ld	s8,16(sp)
    80001616:	6ca2                	ld	s9,8(sp)
    80001618:	6d02                	ld	s10,0(sp)
    8000161a:	a039                	j	80001628 <copyout+0xb6>
      return -1;
    8000161c:	557d                	li	a0,-1
    8000161e:	6906                	ld	s2,64(sp)
    80001620:	7a42                	ld	s4,48(sp)
    80001622:	6c42                	ld	s8,16(sp)
    80001624:	6ca2                	ld	s9,8(sp)
    80001626:	6d02                	ld	s10,0(sp)
}
    80001628:	60e6                	ld	ra,88(sp)
    8000162a:	6446                	ld	s0,80(sp)
    8000162c:	64a6                	ld	s1,72(sp)
    8000162e:	79e2                	ld	s3,56(sp)
    80001630:	7aa2                	ld	s5,40(sp)
    80001632:	7b02                	ld	s6,32(sp)
    80001634:	6be2                	ld	s7,24(sp)
    80001636:	6125                	addi	sp,sp,96
    80001638:	8082                	ret
      return -1;
    8000163a:	557d                	li	a0,-1
    8000163c:	6906                	ld	s2,64(sp)
    8000163e:	7a42                	ld	s4,48(sp)
    80001640:	6c42                	ld	s8,16(sp)
    80001642:	6ca2                	ld	s9,8(sp)
    80001644:	6d02                	ld	s10,0(sp)
    80001646:	b7cd                	j	80001628 <copyout+0xb6>

0000000080001648 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001648:	c6a5                	beqz	a3,800016b0 <copyin+0x68>
{
    8000164a:	715d                	addi	sp,sp,-80
    8000164c:	e486                	sd	ra,72(sp)
    8000164e:	e0a2                	sd	s0,64(sp)
    80001650:	fc26                	sd	s1,56(sp)
    80001652:	f84a                	sd	s2,48(sp)
    80001654:	f44e                	sd	s3,40(sp)
    80001656:	f052                	sd	s4,32(sp)
    80001658:	ec56                	sd	s5,24(sp)
    8000165a:	e85a                	sd	s6,16(sp)
    8000165c:	e45e                	sd	s7,8(sp)
    8000165e:	e062                	sd	s8,0(sp)
    80001660:	0880                	addi	s0,sp,80
    80001662:	8b2a                	mv	s6,a0
    80001664:	8a2e                	mv	s4,a1
    80001666:	8c32                	mv	s8,a2
    80001668:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000166a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000166c:	6a85                	lui	s5,0x1
    8000166e:	a00d                	j	80001690 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001670:	018505b3          	add	a1,a0,s8
    80001674:	0004861b          	sext.w	a2,s1
    80001678:	412585b3          	sub	a1,a1,s2
    8000167c:	8552                	mv	a0,s4
    8000167e:	eb4ff0ef          	jal	80000d32 <memmove>

    len -= n;
    80001682:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001686:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001688:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000168c:	02098063          	beqz	s3,800016ac <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80001690:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001694:	85ca                	mv	a1,s2
    80001696:	855a                	mv	a0,s6
    80001698:	94dff0ef          	jal	80000fe4 <walkaddr>
    if(pa0 == 0)
    8000169c:	cd01                	beqz	a0,800016b4 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    8000169e:	418904b3          	sub	s1,s2,s8
    800016a2:	94d6                	add	s1,s1,s5
    if(n > len)
    800016a4:	fc99f6e3          	bgeu	s3,s1,80001670 <copyin+0x28>
    800016a8:	84ce                	mv	s1,s3
    800016aa:	b7d9                	j	80001670 <copyin+0x28>
  }
  return 0;
    800016ac:	4501                	li	a0,0
    800016ae:	a021                	j	800016b6 <copyin+0x6e>
    800016b0:	4501                	li	a0,0
}
    800016b2:	8082                	ret
      return -1;
    800016b4:	557d                	li	a0,-1
}
    800016b6:	60a6                	ld	ra,72(sp)
    800016b8:	6406                	ld	s0,64(sp)
    800016ba:	74e2                	ld	s1,56(sp)
    800016bc:	7942                	ld	s2,48(sp)
    800016be:	79a2                	ld	s3,40(sp)
    800016c0:	7a02                	ld	s4,32(sp)
    800016c2:	6ae2                	ld	s5,24(sp)
    800016c4:	6b42                	ld	s6,16(sp)
    800016c6:	6ba2                	ld	s7,8(sp)
    800016c8:	6c02                	ld	s8,0(sp)
    800016ca:	6161                	addi	sp,sp,80
    800016cc:	8082                	ret

00000000800016ce <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800016ce:	c6dd                	beqz	a3,8000177c <copyinstr+0xae>
{
    800016d0:	715d                	addi	sp,sp,-80
    800016d2:	e486                	sd	ra,72(sp)
    800016d4:	e0a2                	sd	s0,64(sp)
    800016d6:	fc26                	sd	s1,56(sp)
    800016d8:	f84a                	sd	s2,48(sp)
    800016da:	f44e                	sd	s3,40(sp)
    800016dc:	f052                	sd	s4,32(sp)
    800016de:	ec56                	sd	s5,24(sp)
    800016e0:	e85a                	sd	s6,16(sp)
    800016e2:	e45e                	sd	s7,8(sp)
    800016e4:	0880                	addi	s0,sp,80
    800016e6:	8a2a                	mv	s4,a0
    800016e8:	8b2e                	mv	s6,a1
    800016ea:	8bb2                	mv	s7,a2
    800016ec:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800016ee:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016f0:	6985                	lui	s3,0x1
    800016f2:	a825                	j	8000172a <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016f4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800016f8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016fa:	37fd                	addiw	a5,a5,-1
    800016fc:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001700:	60a6                	ld	ra,72(sp)
    80001702:	6406                	ld	s0,64(sp)
    80001704:	74e2                	ld	s1,56(sp)
    80001706:	7942                	ld	s2,48(sp)
    80001708:	79a2                	ld	s3,40(sp)
    8000170a:	7a02                	ld	s4,32(sp)
    8000170c:	6ae2                	ld	s5,24(sp)
    8000170e:	6b42                	ld	s6,16(sp)
    80001710:	6ba2                	ld	s7,8(sp)
    80001712:	6161                	addi	sp,sp,80
    80001714:	8082                	ret
    80001716:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    8000171a:	9742                	add	a4,a4,a6
      --max;
    8000171c:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001720:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001724:	04e58463          	beq	a1,a4,8000176c <copyinstr+0x9e>
{
    80001728:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    8000172a:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000172e:	85a6                	mv	a1,s1
    80001730:	8552                	mv	a0,s4
    80001732:	8b3ff0ef          	jal	80000fe4 <walkaddr>
    if(pa0 == 0)
    80001736:	cd0d                	beqz	a0,80001770 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001738:	417486b3          	sub	a3,s1,s7
    8000173c:	96ce                	add	a3,a3,s3
    if(n > max)
    8000173e:	00d97363          	bgeu	s2,a3,80001744 <copyinstr+0x76>
    80001742:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001744:	955e                	add	a0,a0,s7
    80001746:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001748:	c695                	beqz	a3,80001774 <copyinstr+0xa6>
    8000174a:	87da                	mv	a5,s6
    8000174c:	885a                	mv	a6,s6
      if(*p == '\0'){
    8000174e:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001752:	96da                	add	a3,a3,s6
    80001754:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001756:	00f60733          	add	a4,a2,a5
    8000175a:	00074703          	lbu	a4,0(a4)
    8000175e:	db59                	beqz	a4,800016f4 <copyinstr+0x26>
        *dst = *p;
    80001760:	00e78023          	sb	a4,0(a5)
      dst++;
    80001764:	0785                	addi	a5,a5,1
    while(n > 0){
    80001766:	fed797e3          	bne	a5,a3,80001754 <copyinstr+0x86>
    8000176a:	b775                	j	80001716 <copyinstr+0x48>
    8000176c:	4781                	li	a5,0
    8000176e:	b771                	j	800016fa <copyinstr+0x2c>
      return -1;
    80001770:	557d                	li	a0,-1
    80001772:	b779                	j	80001700 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001774:	6b85                	lui	s7,0x1
    80001776:	9ba6                	add	s7,s7,s1
    80001778:	87da                	mv	a5,s6
    8000177a:	b77d                	j	80001728 <copyinstr+0x5a>
  int got_null = 0;
    8000177c:	4781                	li	a5,0
  if(got_null){
    8000177e:	37fd                	addiw	a5,a5,-1
    80001780:	0007851b          	sext.w	a0,a5
}
    80001784:	8082                	ret

0000000080001786 <proc_mapstacks>:
  
  return 1;  // Success
}
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001786:	7139                	addi	sp,sp,-64
    80001788:	fc06                	sd	ra,56(sp)
    8000178a:	f822                	sd	s0,48(sp)
    8000178c:	f426                	sd	s1,40(sp)
    8000178e:	f04a                	sd	s2,32(sp)
    80001790:	ec4e                	sd	s3,24(sp)
    80001792:	e852                	sd	s4,16(sp)
    80001794:	e456                	sd	s5,8(sp)
    80001796:	e05a                	sd	s6,0(sp)
    80001798:	0080                	addi	s0,sp,64
    8000179a:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000179c:	00011497          	auipc	s1,0x11
    800017a0:	1d448493          	addi	s1,s1,468 # 80012970 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800017a4:	8b26                	mv	s6,s1
    800017a6:	ff4df937          	lui	s2,0xff4df
    800017aa:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bb06d>
    800017ae:	0936                	slli	s2,s2,0xd
    800017b0:	6f590913          	addi	s2,s2,1781
    800017b4:	0936                	slli	s2,s2,0xd
    800017b6:	bd390913          	addi	s2,s2,-1069
    800017ba:	0932                	slli	s2,s2,0xc
    800017bc:	7a790913          	addi	s2,s2,1959
    800017c0:	040009b7          	lui	s3,0x4000
    800017c4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017c6:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017c8:	00017a97          	auipc	s5,0x17
    800017cc:	da8a8a93          	addi	s5,s5,-600 # 80018570 <tickslock>
    char *pa = kalloc();
    800017d0:	b62ff0ef          	jal	80000b32 <kalloc>
    800017d4:	862a                	mv	a2,a0
    if(pa == 0)
    800017d6:	cd15                	beqz	a0,80001812 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017d8:	416485b3          	sub	a1,s1,s6
    800017dc:	8591                	srai	a1,a1,0x4
    800017de:	032585b3          	mul	a1,a1,s2
    800017e2:	2585                	addiw	a1,a1,1
    800017e4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017e8:	4719                	li	a4,6
    800017ea:	6685                	lui	a3,0x1
    800017ec:	40b985b3          	sub	a1,s3,a1
    800017f0:	8552                	mv	a0,s4
    800017f2:	8e1ff0ef          	jal	800010d2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017f6:	17048493          	addi	s1,s1,368
    800017fa:	fd549be3          	bne	s1,s5,800017d0 <proc_mapstacks+0x4a>
  }
}
    800017fe:	70e2                	ld	ra,56(sp)
    80001800:	7442                	ld	s0,48(sp)
    80001802:	74a2                	ld	s1,40(sp)
    80001804:	7902                	ld	s2,32(sp)
    80001806:	69e2                	ld	s3,24(sp)
    80001808:	6a42                	ld	s4,16(sp)
    8000180a:	6aa2                	ld	s5,8(sp)
    8000180c:	6b02                	ld	s6,0(sp)
    8000180e:	6121                	addi	sp,sp,64
    80001810:	8082                	ret
      panic("kalloc");
    80001812:	00006517          	auipc	a0,0x6
    80001816:	9e650513          	addi	a0,a0,-1562 # 800071f8 <etext+0x1f8>
    8000181a:	f89fe0ef          	jal	800007a2 <panic>

000000008000181e <procinit>:

// initialize the proc table.
void
procinit(void)
{
    8000181e:	7139                	addi	sp,sp,-64
    80001820:	fc06                	sd	ra,56(sp)
    80001822:	f822                	sd	s0,48(sp)
    80001824:	f426                	sd	s1,40(sp)
    80001826:	f04a                	sd	s2,32(sp)
    80001828:	ec4e                	sd	s3,24(sp)
    8000182a:	e852                	sd	s4,16(sp)
    8000182c:	e456                	sd	s5,8(sp)
    8000182e:	e05a                	sd	s6,0(sp)
    80001830:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001832:	00006597          	auipc	a1,0x6
    80001836:	9ce58593          	addi	a1,a1,-1586 # 80007200 <etext+0x200>
    8000183a:	00011517          	auipc	a0,0x11
    8000183e:	d0650513          	addi	a0,a0,-762 # 80012540 <pid_lock>
    80001842:	b40ff0ef          	jal	80000b82 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001846:	00006597          	auipc	a1,0x6
    8000184a:	9c258593          	addi	a1,a1,-1598 # 80007208 <etext+0x208>
    8000184e:	00011517          	auipc	a0,0x11
    80001852:	d0a50513          	addi	a0,a0,-758 # 80012558 <wait_lock>
    80001856:	b2cff0ef          	jal	80000b82 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000185a:	00011497          	auipc	s1,0x11
    8000185e:	11648493          	addi	s1,s1,278 # 80012970 <proc>
      initlock(&p->lock, "proc");
    80001862:	00006b17          	auipc	s6,0x6
    80001866:	9b6b0b13          	addi	s6,s6,-1610 # 80007218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000186a:	8aa6                	mv	s5,s1
    8000186c:	ff4df937          	lui	s2,0xff4df
    80001870:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bb06d>
    80001874:	0936                	slli	s2,s2,0xd
    80001876:	6f590913          	addi	s2,s2,1781
    8000187a:	0936                	slli	s2,s2,0xd
    8000187c:	bd390913          	addi	s2,s2,-1069
    80001880:	0932                	slli	s2,s2,0xc
    80001882:	7a790913          	addi	s2,s2,1959
    80001886:	040009b7          	lui	s3,0x4000
    8000188a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000188c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000188e:	00017a17          	auipc	s4,0x17
    80001892:	ce2a0a13          	addi	s4,s4,-798 # 80018570 <tickslock>
      initlock(&p->lock, "proc");
    80001896:	85da                	mv	a1,s6
    80001898:	8526                	mv	a0,s1
    8000189a:	ae8ff0ef          	jal	80000b82 <initlock>
      p->state = UNUSED;
    8000189e:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800018a2:	415487b3          	sub	a5,s1,s5
    800018a6:	8791                	srai	a5,a5,0x4
    800018a8:	032787b3          	mul	a5,a5,s2
    800018ac:	2785                	addiw	a5,a5,1
    800018ae:	00d7979b          	slliw	a5,a5,0xd
    800018b2:	40f987b3          	sub	a5,s3,a5
    800018b6:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018b8:	17048493          	addi	s1,s1,368
    800018bc:	fd449de3          	bne	s1,s4,80001896 <procinit+0x78>
  }
}
    800018c0:	70e2                	ld	ra,56(sp)
    800018c2:	7442                	ld	s0,48(sp)
    800018c4:	74a2                	ld	s1,40(sp)
    800018c6:	7902                	ld	s2,32(sp)
    800018c8:	69e2                	ld	s3,24(sp)
    800018ca:	6a42                	ld	s4,16(sp)
    800018cc:	6aa2                	ld	s5,8(sp)
    800018ce:	6b02                	ld	s6,0(sp)
    800018d0:	6121                	addi	sp,sp,64
    800018d2:	8082                	ret

00000000800018d4 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018d4:	1141                	addi	sp,sp,-16
    800018d6:	e422                	sd	s0,8(sp)
    800018d8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018da:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018dc:	2501                	sext.w	a0,a0
    800018de:	6422                	ld	s0,8(sp)
    800018e0:	0141                	addi	sp,sp,16
    800018e2:	8082                	ret

00000000800018e4 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018e4:	1141                	addi	sp,sp,-16
    800018e6:	e422                	sd	s0,8(sp)
    800018e8:	0800                	addi	s0,sp,16
    800018ea:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018ec:	2781                	sext.w	a5,a5
    800018ee:	079e                	slli	a5,a5,0x7
  return c;
}
    800018f0:	00011517          	auipc	a0,0x11
    800018f4:	c8050513          	addi	a0,a0,-896 # 80012570 <cpus>
    800018f8:	953e                	add	a0,a0,a5
    800018fa:	6422                	ld	s0,8(sp)
    800018fc:	0141                	addi	sp,sp,16
    800018fe:	8082                	ret

0000000080001900 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001900:	1101                	addi	sp,sp,-32
    80001902:	ec06                	sd	ra,24(sp)
    80001904:	e822                	sd	s0,16(sp)
    80001906:	e426                	sd	s1,8(sp)
    80001908:	1000                	addi	s0,sp,32
  push_off();
    8000190a:	ab8ff0ef          	jal	80000bc2 <push_off>
    8000190e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001910:	2781                	sext.w	a5,a5
    80001912:	079e                	slli	a5,a5,0x7
    80001914:	00011717          	auipc	a4,0x11
    80001918:	c2c70713          	addi	a4,a4,-980 # 80012540 <pid_lock>
    8000191c:	97ba                	add	a5,a5,a4
    8000191e:	7b84                	ld	s1,48(a5)
  pop_off();
    80001920:	b26ff0ef          	jal	80000c46 <pop_off>
  return p;
}
    80001924:	8526                	mv	a0,s1
    80001926:	60e2                	ld	ra,24(sp)
    80001928:	6442                	ld	s0,16(sp)
    8000192a:	64a2                	ld	s1,8(sp)
    8000192c:	6105                	addi	sp,sp,32
    8000192e:	8082                	ret

0000000080001930 <getptable>:
  if (nproc < 1 || buffer == 0) {
    80001930:	0ea05663          	blez	a0,80001a1c <getptable+0xec>
{
    80001934:	7119                	addi	sp,sp,-128
    80001936:	fc86                	sd	ra,120(sp)
    80001938:	f8a2                	sd	s0,112(sp)
    8000193a:	ecce                	sd	s3,88(sp)
    8000193c:	e8d2                	sd	s4,80(sp)
    8000193e:	0100                	addi	s0,sp,128
    80001940:	89aa                	mv	s3,a0
    80001942:	8a2e                	mv	s4,a1
    return 0;  // Failure: invalid parameters
    80001944:	4501                	li	a0,0
  if (nproc < 1 || buffer == 0) {
    80001946:	e599                	bnez	a1,80001954 <getptable+0x24>
}
    80001948:	70e6                	ld	ra,120(sp)
    8000194a:	7446                	ld	s0,112(sp)
    8000194c:	69e6                	ld	s3,88(sp)
    8000194e:	6a46                	ld	s4,80(sp)
    80001950:	6109                	addi	sp,sp,128
    80001952:	8082                	ret
    80001954:	f4a6                	sd	s1,104(sp)
    80001956:	f0ca                	sd	s2,96(sp)
    80001958:	e4d6                	sd	s5,72(sp)
    8000195a:	e0da                	sd	s6,64(sp)
    8000195c:	fc5e                	sd	s7,56(sp)
  struct proc *curproc = myproc();
    8000195e:	fa3ff0ef          	jal	80001900 <myproc>
    80001962:	8b2a                	mv	s6,a0
  int count = 0;
    80001964:	4901                	li	s2,0
  for (p = proc; p < &proc[NPROC]; p++) {
    80001966:	00011497          	auipc	s1,0x11
    8000196a:	00a48493          	addi	s1,s1,10 # 80012970 <proc>
      pinfo.ppid = (p->parent) ? p->parent->pid : 0;  // Handle init process
    8000196e:	4b81                	li	s7,0
  for (p = proc; p < &proc[NPROC]; p++) {
    80001970:	00017a97          	auipc	s5,0x17
    80001974:	c00a8a93          	addi	s5,s5,-1024 # 80018570 <tickslock>
    80001978:	a095                	j	800019dc <getptable+0xac>
        release(&p->lock);
    8000197a:	8526                	mv	a0,s1
    8000197c:	b1eff0ef          	jal	80000c9a <release>
  return 1;  // Success
    80001980:	4505                	li	a0,1
        break;
    80001982:	74a6                	ld	s1,104(sp)
    80001984:	7906                	ld	s2,96(sp)
    80001986:	6aa6                	ld	s5,72(sp)
    80001988:	6b06                	ld	s6,64(sp)
    8000198a:	7be2                	ld	s7,56(sp)
    8000198c:	bf75                	j	80001948 <getptable+0x18>
      pinfo.ppid = (p->parent) ? p->parent->pid : 0;  // Handle init process
    8000198e:	f8e42623          	sw	a4,-116(s0)
      pinfo.state = p->state;
    80001992:	f8f42823          	sw	a5,-112(s0)
      strncpy(pinfo.name, p->name, 16);
    80001996:	4641                	li	a2,16
    80001998:	15848593          	addi	a1,s1,344
    8000199c:	f9440513          	addi	a0,s0,-108
    800019a0:	c38ff0ef          	jal	80000dd8 <strncpy>
      pinfo.name[15] = '\0';  // Ensure null termination
    800019a4:	fa0401a3          	sb	zero,-93(s0)
      pinfo.sz = p->sz;
    800019a8:	64bc                	ld	a5,72(s1)
    800019aa:	faf43423          	sd	a5,-88(s0)
      if (copyout(curproc->pagetable, buffer + (count * sizeof(struct proc_info)),
    800019ae:	00291593          	slli	a1,s2,0x2
    800019b2:	95ca                	add	a1,a1,s2
    800019b4:	058e                	slli	a1,a1,0x3
    800019b6:	02800693          	li	a3,40
    800019ba:	f8840613          	addi	a2,s0,-120
    800019be:	95d2                	add	a1,a1,s4
    800019c0:	050b3503          	ld	a0,80(s6)
    800019c4:	bafff0ef          	jal	80001572 <copyout>
    800019c8:	02054963          	bltz	a0,800019fa <getptable+0xca>
      count++;
    800019cc:	2905                	addiw	s2,s2,1
    release(&p->lock);
    800019ce:	8526                	mv	a0,s1
    800019d0:	acaff0ef          	jal	80000c9a <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800019d4:	17048493          	addi	s1,s1,368
    800019d8:	03548b63          	beq	s1,s5,80001a0e <getptable+0xde>
    acquire(&p->lock);
    800019dc:	8526                	mv	a0,s1
    800019de:	a24ff0ef          	jal	80000c02 <acquire>
    if (p->state != UNUSED) {
    800019e2:	4c9c                	lw	a5,24(s1)
    800019e4:	d7ed                	beqz	a5,800019ce <getptable+0x9e>
      if (count >= nproc) {
    800019e6:	f9395ae3          	bge	s2,s3,8000197a <getptable+0x4a>
      pinfo.pid = p->pid;
    800019ea:	5898                	lw	a4,48(s1)
    800019ec:	f8e42423          	sw	a4,-120(s0)
      pinfo.ppid = (p->parent) ? p->parent->pid : 0;  // Handle init process
    800019f0:	7c94                	ld	a3,56(s1)
    800019f2:	875e                	mv	a4,s7
    800019f4:	dec9                	beqz	a3,8000198e <getptable+0x5e>
    800019f6:	5a98                	lw	a4,48(a3)
    800019f8:	bf59                	j	8000198e <getptable+0x5e>
        release(&p->lock);
    800019fa:	8526                	mv	a0,s1
    800019fc:	a9eff0ef          	jal	80000c9a <release>
        return 0;  // Failure: copyout failed
    80001a00:	4501                	li	a0,0
    80001a02:	74a6                	ld	s1,104(sp)
    80001a04:	7906                	ld	s2,96(sp)
    80001a06:	6aa6                	ld	s5,72(sp)
    80001a08:	6b06                	ld	s6,64(sp)
    80001a0a:	7be2                	ld	s7,56(sp)
    80001a0c:	bf35                	j	80001948 <getptable+0x18>
  return 1;  // Success
    80001a0e:	4505                	li	a0,1
    80001a10:	74a6                	ld	s1,104(sp)
    80001a12:	7906                	ld	s2,96(sp)
    80001a14:	6aa6                	ld	s5,72(sp)
    80001a16:	6b06                	ld	s6,64(sp)
    80001a18:	7be2                	ld	s7,56(sp)
    80001a1a:	b73d                	j	80001948 <getptable+0x18>
    return 0;  // Failure: invalid parameters
    80001a1c:	4501                	li	a0,0
}
    80001a1e:	8082                	ret

0000000080001a20 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001a20:	1141                	addi	sp,sp,-16
    80001a22:	e406                	sd	ra,8(sp)
    80001a24:	e022                	sd	s0,0(sp)
    80001a26:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001a28:	ed9ff0ef          	jal	80001900 <myproc>
    80001a2c:	a6eff0ef          	jal	80000c9a <release>

  if (first) {
    80001a30:	00009797          	auipc	a5,0x9
    80001a34:	9307a783          	lw	a5,-1744(a5) # 8000a360 <first.1>
    80001a38:	e799                	bnez	a5,80001a46 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001a3a:	343000ef          	jal	8000257c <usertrapret>
}
    80001a3e:	60a2                	ld	ra,8(sp)
    80001a40:	6402                	ld	s0,0(sp)
    80001a42:	0141                	addi	sp,sp,16
    80001a44:	8082                	ret
    fsinit(ROOTDEV);
    80001a46:	4505                	li	a0,1
    80001a48:	7c8010ef          	jal	80003210 <fsinit>
    first = 0;
    80001a4c:	00009797          	auipc	a5,0x9
    80001a50:	9007aa23          	sw	zero,-1772(a5) # 8000a360 <first.1>
    __sync_synchronize();
    80001a54:	0330000f          	fence	rw,rw
    80001a58:	b7cd                	j	80001a3a <forkret+0x1a>

0000000080001a5a <allocpid>:
{
    80001a5a:	1101                	addi	sp,sp,-32
    80001a5c:	ec06                	sd	ra,24(sp)
    80001a5e:	e822                	sd	s0,16(sp)
    80001a60:	e426                	sd	s1,8(sp)
    80001a62:	e04a                	sd	s2,0(sp)
    80001a64:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a66:	00011917          	auipc	s2,0x11
    80001a6a:	ada90913          	addi	s2,s2,-1318 # 80012540 <pid_lock>
    80001a6e:	854a                	mv	a0,s2
    80001a70:	992ff0ef          	jal	80000c02 <acquire>
  pid = nextpid;
    80001a74:	00009797          	auipc	a5,0x9
    80001a78:	8f078793          	addi	a5,a5,-1808 # 8000a364 <nextpid>
    80001a7c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a7e:	0014871b          	addiw	a4,s1,1
    80001a82:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a84:	854a                	mv	a0,s2
    80001a86:	a14ff0ef          	jal	80000c9a <release>
}
    80001a8a:	8526                	mv	a0,s1
    80001a8c:	60e2                	ld	ra,24(sp)
    80001a8e:	6442                	ld	s0,16(sp)
    80001a90:	64a2                	ld	s1,8(sp)
    80001a92:	6902                	ld	s2,0(sp)
    80001a94:	6105                	addi	sp,sp,32
    80001a96:	8082                	ret

0000000080001a98 <proc_pagetable>:
{
    80001a98:	1101                	addi	sp,sp,-32
    80001a9a:	ec06                	sd	ra,24(sp)
    80001a9c:	e822                	sd	s0,16(sp)
    80001a9e:	e426                	sd	s1,8(sp)
    80001aa0:	e04a                	sd	s2,0(sp)
    80001aa2:	1000                	addi	s0,sp,32
    80001aa4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001aa6:	ff0ff0ef          	jal	80001296 <uvmcreate>
    80001aaa:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001aac:	cd05                	beqz	a0,80001ae4 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001aae:	4729                	li	a4,10
    80001ab0:	00004697          	auipc	a3,0x4
    80001ab4:	55068693          	addi	a3,a3,1360 # 80006000 <_trampoline>
    80001ab8:	6605                	lui	a2,0x1
    80001aba:	040005b7          	lui	a1,0x4000
    80001abe:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ac0:	05b2                	slli	a1,a1,0xc
    80001ac2:	d60ff0ef          	jal	80001022 <mappages>
    80001ac6:	02054663          	bltz	a0,80001af2 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001aca:	4719                	li	a4,6
    80001acc:	05893683          	ld	a3,88(s2)
    80001ad0:	6605                	lui	a2,0x1
    80001ad2:	020005b7          	lui	a1,0x2000
    80001ad6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ad8:	05b6                	slli	a1,a1,0xd
    80001ada:	8526                	mv	a0,s1
    80001adc:	d46ff0ef          	jal	80001022 <mappages>
    80001ae0:	00054f63          	bltz	a0,80001afe <proc_pagetable+0x66>
}
    80001ae4:	8526                	mv	a0,s1
    80001ae6:	60e2                	ld	ra,24(sp)
    80001ae8:	6442                	ld	s0,16(sp)
    80001aea:	64a2                	ld	s1,8(sp)
    80001aec:	6902                	ld	s2,0(sp)
    80001aee:	6105                	addi	sp,sp,32
    80001af0:	8082                	ret
    uvmfree(pagetable, 0);
    80001af2:	4581                	li	a1,0
    80001af4:	8526                	mv	a0,s1
    80001af6:	96fff0ef          	jal	80001464 <uvmfree>
    return 0;
    80001afa:	4481                	li	s1,0
    80001afc:	b7e5                	j	80001ae4 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001afe:	4681                	li	a3,0
    80001b00:	4605                	li	a2,1
    80001b02:	040005b7          	lui	a1,0x4000
    80001b06:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b08:	05b2                	slli	a1,a1,0xc
    80001b0a:	8526                	mv	a0,s1
    80001b0c:	eceff0ef          	jal	800011da <uvmunmap>
    uvmfree(pagetable, 0);
    80001b10:	4581                	li	a1,0
    80001b12:	8526                	mv	a0,s1
    80001b14:	951ff0ef          	jal	80001464 <uvmfree>
    return 0;
    80001b18:	4481                	li	s1,0
    80001b1a:	b7e9                	j	80001ae4 <proc_pagetable+0x4c>

0000000080001b1c <proc_freepagetable>:
{
    80001b1c:	1101                	addi	sp,sp,-32
    80001b1e:	ec06                	sd	ra,24(sp)
    80001b20:	e822                	sd	s0,16(sp)
    80001b22:	e426                	sd	s1,8(sp)
    80001b24:	e04a                	sd	s2,0(sp)
    80001b26:	1000                	addi	s0,sp,32
    80001b28:	84aa                	mv	s1,a0
    80001b2a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b2c:	4681                	li	a3,0
    80001b2e:	4605                	li	a2,1
    80001b30:	040005b7          	lui	a1,0x4000
    80001b34:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b36:	05b2                	slli	a1,a1,0xc
    80001b38:	ea2ff0ef          	jal	800011da <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b3c:	4681                	li	a3,0
    80001b3e:	4605                	li	a2,1
    80001b40:	020005b7          	lui	a1,0x2000
    80001b44:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b46:	05b6                	slli	a1,a1,0xd
    80001b48:	8526                	mv	a0,s1
    80001b4a:	e90ff0ef          	jal	800011da <uvmunmap>
  uvmfree(pagetable, sz);
    80001b4e:	85ca                	mv	a1,s2
    80001b50:	8526                	mv	a0,s1
    80001b52:	913ff0ef          	jal	80001464 <uvmfree>
}
    80001b56:	60e2                	ld	ra,24(sp)
    80001b58:	6442                	ld	s0,16(sp)
    80001b5a:	64a2                	ld	s1,8(sp)
    80001b5c:	6902                	ld	s2,0(sp)
    80001b5e:	6105                	addi	sp,sp,32
    80001b60:	8082                	ret

0000000080001b62 <freeproc>:
{
    80001b62:	1101                	addi	sp,sp,-32
    80001b64:	ec06                	sd	ra,24(sp)
    80001b66:	e822                	sd	s0,16(sp)
    80001b68:	e426                	sd	s1,8(sp)
    80001b6a:	1000                	addi	s0,sp,32
    80001b6c:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b6e:	6d28                	ld	a0,88(a0)
    80001b70:	c119                	beqz	a0,80001b76 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001b72:	edffe0ef          	jal	80000a50 <kfree>
  p->trapframe = 0;
    80001b76:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b7a:	68a8                	ld	a0,80(s1)
    80001b7c:	c501                	beqz	a0,80001b84 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001b7e:	64ac                	ld	a1,72(s1)
    80001b80:	f9dff0ef          	jal	80001b1c <proc_freepagetable>
  p->pagetable = 0;
    80001b84:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b88:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b8c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001b90:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001b94:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b98:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b9c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001ba0:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001ba4:	0004ac23          	sw	zero,24(s1)
}
    80001ba8:	60e2                	ld	ra,24(sp)
    80001baa:	6442                	ld	s0,16(sp)
    80001bac:	64a2                	ld	s1,8(sp)
    80001bae:	6105                	addi	sp,sp,32
    80001bb0:	8082                	ret

0000000080001bb2 <allocproc>:
{
    80001bb2:	1101                	addi	sp,sp,-32
    80001bb4:	ec06                	sd	ra,24(sp)
    80001bb6:	e822                	sd	s0,16(sp)
    80001bb8:	e426                	sd	s1,8(sp)
    80001bba:	e04a                	sd	s2,0(sp)
    80001bbc:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bbe:	00011497          	auipc	s1,0x11
    80001bc2:	db248493          	addi	s1,s1,-590 # 80012970 <proc>
    80001bc6:	00017917          	auipc	s2,0x17
    80001bca:	9aa90913          	addi	s2,s2,-1622 # 80018570 <tickslock>
    acquire(&p->lock);
    80001bce:	8526                	mv	a0,s1
    80001bd0:	832ff0ef          	jal	80000c02 <acquire>
    if(p->state == UNUSED) {
    80001bd4:	4c9c                	lw	a5,24(s1)
    80001bd6:	cb91                	beqz	a5,80001bea <allocproc+0x38>
      release(&p->lock);
    80001bd8:	8526                	mv	a0,s1
    80001bda:	8c0ff0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bde:	17048493          	addi	s1,s1,368
    80001be2:	ff2496e3          	bne	s1,s2,80001bce <allocproc+0x1c>
  return 0;
    80001be6:	4481                	li	s1,0
    80001be8:	a889                	j	80001c3a <allocproc+0x88>
  p->pid = allocpid();
    80001bea:	e71ff0ef          	jal	80001a5a <allocpid>
    80001bee:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001bf0:	4785                	li	a5,1
    80001bf2:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001bf4:	f3ffe0ef          	jal	80000b32 <kalloc>
    80001bf8:	892a                	mv	s2,a0
    80001bfa:	eca8                	sd	a0,88(s1)
    80001bfc:	c531                	beqz	a0,80001c48 <allocproc+0x96>
  p->pagetable = proc_pagetable(p);
    80001bfe:	8526                	mv	a0,s1
    80001c00:	e99ff0ef          	jal	80001a98 <proc_pagetable>
    80001c04:	892a                	mv	s2,a0
    80001c06:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c08:	c921                	beqz	a0,80001c58 <allocproc+0xa6>
  memset(&p->context, 0, sizeof(p->context));
    80001c0a:	07000613          	li	a2,112
    80001c0e:	4581                	li	a1,0
    80001c10:	06048513          	addi	a0,s1,96
    80001c14:	8c2ff0ef          	jal	80000cd6 <memset>
  p->context.ra = (uint64)forkret;
    80001c18:	00000797          	auipc	a5,0x0
    80001c1c:	e0878793          	addi	a5,a5,-504 # 80001a20 <forkret>
    80001c20:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c22:	60bc                	ld	a5,64(s1)
    80001c24:	6705                	lui	a4,0x1
    80001c26:	97ba                	add	a5,a5,a4
    80001c28:	f4bc                	sd	a5,104(s1)
  p->creation_time = ticks;
    80001c2a:	00008797          	auipc	a5,0x8
    80001c2e:	7de7a783          	lw	a5,2014(a5) # 8000a408 <ticks>
    80001c32:	16f4a423          	sw	a5,360(s1)
  p->run_time = 0;
    80001c36:	1604a623          	sw	zero,364(s1)
}
    80001c3a:	8526                	mv	a0,s1
    80001c3c:	60e2                	ld	ra,24(sp)
    80001c3e:	6442                	ld	s0,16(sp)
    80001c40:	64a2                	ld	s1,8(sp)
    80001c42:	6902                	ld	s2,0(sp)
    80001c44:	6105                	addi	sp,sp,32
    80001c46:	8082                	ret
    freeproc(p);
    80001c48:	8526                	mv	a0,s1
    80001c4a:	f19ff0ef          	jal	80001b62 <freeproc>
    release(&p->lock);
    80001c4e:	8526                	mv	a0,s1
    80001c50:	84aff0ef          	jal	80000c9a <release>
    return 0;
    80001c54:	84ca                	mv	s1,s2
    80001c56:	b7d5                	j	80001c3a <allocproc+0x88>
    freeproc(p);
    80001c58:	8526                	mv	a0,s1
    80001c5a:	f09ff0ef          	jal	80001b62 <freeproc>
    release(&p->lock);
    80001c5e:	8526                	mv	a0,s1
    80001c60:	83aff0ef          	jal	80000c9a <release>
    return 0;
    80001c64:	84ca                	mv	s1,s2
    80001c66:	bfd1                	j	80001c3a <allocproc+0x88>

0000000080001c68 <userinit>:
{
    80001c68:	1101                	addi	sp,sp,-32
    80001c6a:	ec06                	sd	ra,24(sp)
    80001c6c:	e822                	sd	s0,16(sp)
    80001c6e:	e426                	sd	s1,8(sp)
    80001c70:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c72:	f41ff0ef          	jal	80001bb2 <allocproc>
    80001c76:	84aa                	mv	s1,a0
  initproc = p;
    80001c78:	00008797          	auipc	a5,0x8
    80001c7c:	78a7b423          	sd	a0,1928(a5) # 8000a400 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001c80:	03400613          	li	a2,52
    80001c84:	00008597          	auipc	a1,0x8
    80001c88:	6ec58593          	addi	a1,a1,1772 # 8000a370 <initcode>
    80001c8c:	6928                	ld	a0,80(a0)
    80001c8e:	e2eff0ef          	jal	800012bc <uvmfirst>
  p->sz = PGSIZE;
    80001c92:	6785                	lui	a5,0x1
    80001c94:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001c96:	6cb8                	ld	a4,88(s1)
    80001c98:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001c9c:	6cb8                	ld	a4,88(s1)
    80001c9e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001ca0:	4641                	li	a2,16
    80001ca2:	00005597          	auipc	a1,0x5
    80001ca6:	57e58593          	addi	a1,a1,1406 # 80007220 <etext+0x220>
    80001caa:	15848513          	addi	a0,s1,344
    80001cae:	966ff0ef          	jal	80000e14 <safestrcpy>
  p->cwd = namei("/");
    80001cb2:	00005517          	auipc	a0,0x5
    80001cb6:	57e50513          	addi	a0,a0,1406 # 80007230 <etext+0x230>
    80001cba:	665010ef          	jal	80003b1e <namei>
    80001cbe:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001cc2:	478d                	li	a5,3
    80001cc4:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001cc6:	8526                	mv	a0,s1
    80001cc8:	fd3fe0ef          	jal	80000c9a <release>
}
    80001ccc:	60e2                	ld	ra,24(sp)
    80001cce:	6442                	ld	s0,16(sp)
    80001cd0:	64a2                	ld	s1,8(sp)
    80001cd2:	6105                	addi	sp,sp,32
    80001cd4:	8082                	ret

0000000080001cd6 <growproc>:
{
    80001cd6:	1101                	addi	sp,sp,-32
    80001cd8:	ec06                	sd	ra,24(sp)
    80001cda:	e822                	sd	s0,16(sp)
    80001cdc:	e426                	sd	s1,8(sp)
    80001cde:	e04a                	sd	s2,0(sp)
    80001ce0:	1000                	addi	s0,sp,32
    80001ce2:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001ce4:	c1dff0ef          	jal	80001900 <myproc>
    80001ce8:	84aa                	mv	s1,a0
  sz = p->sz;
    80001cea:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001cec:	01204c63          	bgtz	s2,80001d04 <growproc+0x2e>
  } else if(n < 0){
    80001cf0:	02094463          	bltz	s2,80001d18 <growproc+0x42>
  p->sz = sz;
    80001cf4:	e4ac                	sd	a1,72(s1)
  return 0;
    80001cf6:	4501                	li	a0,0
}
    80001cf8:	60e2                	ld	ra,24(sp)
    80001cfa:	6442                	ld	s0,16(sp)
    80001cfc:	64a2                	ld	s1,8(sp)
    80001cfe:	6902                	ld	s2,0(sp)
    80001d00:	6105                	addi	sp,sp,32
    80001d02:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001d04:	4691                	li	a3,4
    80001d06:	00b90633          	add	a2,s2,a1
    80001d0a:	6928                	ld	a0,80(a0)
    80001d0c:	e52ff0ef          	jal	8000135e <uvmalloc>
    80001d10:	85aa                	mv	a1,a0
    80001d12:	f16d                	bnez	a0,80001cf4 <growproc+0x1e>
      return -1;
    80001d14:	557d                	li	a0,-1
    80001d16:	b7cd                	j	80001cf8 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d18:	00b90633          	add	a2,s2,a1
    80001d1c:	6928                	ld	a0,80(a0)
    80001d1e:	dfcff0ef          	jal	8000131a <uvmdealloc>
    80001d22:	85aa                	mv	a1,a0
    80001d24:	bfc1                	j	80001cf4 <growproc+0x1e>

0000000080001d26 <fork>:
{
    80001d26:	7139                	addi	sp,sp,-64
    80001d28:	fc06                	sd	ra,56(sp)
    80001d2a:	f822                	sd	s0,48(sp)
    80001d2c:	f04a                	sd	s2,32(sp)
    80001d2e:	e456                	sd	s5,8(sp)
    80001d30:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001d32:	bcfff0ef          	jal	80001900 <myproc>
    80001d36:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001d38:	e7bff0ef          	jal	80001bb2 <allocproc>
    80001d3c:	0e050a63          	beqz	a0,80001e30 <fork+0x10a>
    80001d40:	e852                	sd	s4,16(sp)
    80001d42:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001d44:	048ab603          	ld	a2,72(s5)
    80001d48:	692c                	ld	a1,80(a0)
    80001d4a:	050ab503          	ld	a0,80(s5)
    80001d4e:	f48ff0ef          	jal	80001496 <uvmcopy>
    80001d52:	04054a63          	bltz	a0,80001da6 <fork+0x80>
    80001d56:	f426                	sd	s1,40(sp)
    80001d58:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001d5a:	048ab783          	ld	a5,72(s5)
    80001d5e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001d62:	058ab683          	ld	a3,88(s5)
    80001d66:	87b6                	mv	a5,a3
    80001d68:	058a3703          	ld	a4,88(s4)
    80001d6c:	12068693          	addi	a3,a3,288
    80001d70:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001d74:	6788                	ld	a0,8(a5)
    80001d76:	6b8c                	ld	a1,16(a5)
    80001d78:	6f90                	ld	a2,24(a5)
    80001d7a:	01073023          	sd	a6,0(a4)
    80001d7e:	e708                	sd	a0,8(a4)
    80001d80:	eb0c                	sd	a1,16(a4)
    80001d82:	ef10                	sd	a2,24(a4)
    80001d84:	02078793          	addi	a5,a5,32
    80001d88:	02070713          	addi	a4,a4,32
    80001d8c:	fed792e3          	bne	a5,a3,80001d70 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001d90:	058a3783          	ld	a5,88(s4)
    80001d94:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001d98:	0d0a8493          	addi	s1,s5,208
    80001d9c:	0d0a0913          	addi	s2,s4,208
    80001da0:	150a8993          	addi	s3,s5,336
    80001da4:	a831                	j	80001dc0 <fork+0x9a>
    freeproc(np);
    80001da6:	8552                	mv	a0,s4
    80001da8:	dbbff0ef          	jal	80001b62 <freeproc>
    release(&np->lock);
    80001dac:	8552                	mv	a0,s4
    80001dae:	eedfe0ef          	jal	80000c9a <release>
    return -1;
    80001db2:	597d                	li	s2,-1
    80001db4:	6a42                	ld	s4,16(sp)
    80001db6:	a0b5                	j	80001e22 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001db8:	04a1                	addi	s1,s1,8
    80001dba:	0921                	addi	s2,s2,8
    80001dbc:	01348963          	beq	s1,s3,80001dce <fork+0xa8>
    if(p->ofile[i])
    80001dc0:	6088                	ld	a0,0(s1)
    80001dc2:	d97d                	beqz	a0,80001db8 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001dc4:	2ea020ef          	jal	800040ae <filedup>
    80001dc8:	00a93023          	sd	a0,0(s2)
    80001dcc:	b7f5                	j	80001db8 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001dce:	150ab503          	ld	a0,336(s5)
    80001dd2:	63c010ef          	jal	8000340e <idup>
    80001dd6:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001dda:	4641                	li	a2,16
    80001ddc:	158a8593          	addi	a1,s5,344
    80001de0:	158a0513          	addi	a0,s4,344
    80001de4:	830ff0ef          	jal	80000e14 <safestrcpy>
  pid = np->pid;
    80001de8:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001dec:	8552                	mv	a0,s4
    80001dee:	eadfe0ef          	jal	80000c9a <release>
  acquire(&wait_lock);
    80001df2:	00010497          	auipc	s1,0x10
    80001df6:	76648493          	addi	s1,s1,1894 # 80012558 <wait_lock>
    80001dfa:	8526                	mv	a0,s1
    80001dfc:	e07fe0ef          	jal	80000c02 <acquire>
  np->parent = p;
    80001e00:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001e04:	8526                	mv	a0,s1
    80001e06:	e95fe0ef          	jal	80000c9a <release>
  acquire(&np->lock);
    80001e0a:	8552                	mv	a0,s4
    80001e0c:	df7fe0ef          	jal	80000c02 <acquire>
  np->state = RUNNABLE;
    80001e10:	478d                	li	a5,3
    80001e12:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e16:	8552                	mv	a0,s4
    80001e18:	e83fe0ef          	jal	80000c9a <release>
  return pid;
    80001e1c:	74a2                	ld	s1,40(sp)
    80001e1e:	69e2                	ld	s3,24(sp)
    80001e20:	6a42                	ld	s4,16(sp)
}
    80001e22:	854a                	mv	a0,s2
    80001e24:	70e2                	ld	ra,56(sp)
    80001e26:	7442                	ld	s0,48(sp)
    80001e28:	7902                	ld	s2,32(sp)
    80001e2a:	6aa2                	ld	s5,8(sp)
    80001e2c:	6121                	addi	sp,sp,64
    80001e2e:	8082                	ret
    return -1;
    80001e30:	597d                	li	s2,-1
    80001e32:	bfc5                	j	80001e22 <fork+0xfc>

0000000080001e34 <update_time>:
{
    80001e34:	7179                	addi	sp,sp,-48
    80001e36:	f406                	sd	ra,40(sp)
    80001e38:	f022                	sd	s0,32(sp)
    80001e3a:	ec26                	sd	s1,24(sp)
    80001e3c:	e84a                	sd	s2,16(sp)
    80001e3e:	e44e                	sd	s3,8(sp)
    80001e40:	1800                	addi	s0,sp,48
  for (p = proc; p < &proc[NPROC]; p++) {
    80001e42:	00011497          	auipc	s1,0x11
    80001e46:	b2e48493          	addi	s1,s1,-1234 # 80012970 <proc>
    if (p->state == RUNNING) {
    80001e4a:	4991                	li	s3,4
  for (p = proc; p < &proc[NPROC]; p++) {
    80001e4c:	00016917          	auipc	s2,0x16
    80001e50:	72490913          	addi	s2,s2,1828 # 80018570 <tickslock>
    80001e54:	a801                	j	80001e64 <update_time+0x30>
    release(&p->lock);//lehd hena
    80001e56:	8526                	mv	a0,s1
    80001e58:	e43fe0ef          	jal	80000c9a <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001e5c:	17048493          	addi	s1,s1,368
    80001e60:	01248e63          	beq	s1,s2,80001e7c <update_time+0x48>
    acquire(&p->lock);//n3adel mn hena
    80001e64:	8526                	mv	a0,s1
    80001e66:	d9dfe0ef          	jal	80000c02 <acquire>
    if (p->state == RUNNING) {
    80001e6a:	4c9c                	lw	a5,24(s1)
    80001e6c:	ff3795e3          	bne	a5,s3,80001e56 <update_time+0x22>
      p->run_time++;
    80001e70:	16c4a783          	lw	a5,364(s1)
    80001e74:	2785                	addiw	a5,a5,1
    80001e76:	16f4a623          	sw	a5,364(s1)
    80001e7a:	bff1                	j	80001e56 <update_time+0x22>
}
    80001e7c:	70a2                	ld	ra,40(sp)
    80001e7e:	7402                	ld	s0,32(sp)
    80001e80:	64e2                	ld	s1,24(sp)
    80001e82:	6942                	ld	s2,16(sp)
    80001e84:	69a2                	ld	s3,8(sp)
    80001e86:	6145                	addi	sp,sp,48
    80001e88:	8082                	ret

0000000080001e8a <choose_next_process>:
struct proc *choose_next_process() {
    80001e8a:	1141                	addi	sp,sp,-16
    80001e8c:	e422                	sd	s0,8(sp)
    80001e8e:	0800                	addi	s0,sp,16
  if(sched_mode == SCHED_ROUND_ROBIN) {
    80001e90:	00008797          	auipc	a5,0x8
    80001e94:	5687a783          	lw	a5,1384(a5) # 8000a3f8 <sched_mode>
  return 0;
    80001e98:	4501                	li	a0,0
  if(sched_mode == SCHED_ROUND_ROBIN) {
    80001e9a:	e395                	bnez	a5,80001ebe <choose_next_process+0x34>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e9c:	00011517          	auipc	a0,0x11
    80001ea0:	ad450513          	addi	a0,a0,-1324 # 80012970 <proc>
      if (p->state == RUNNABLE)
    80001ea4:	470d                	li	a4,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ea6:	00016697          	auipc	a3,0x16
    80001eaa:	6ca68693          	addi	a3,a3,1738 # 80018570 <tickslock>
      if (p->state == RUNNABLE)
    80001eae:	4d1c                	lw	a5,24(a0)
    80001eb0:	00e78763          	beq	a5,a4,80001ebe <choose_next_process+0x34>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001eb4:	17050513          	addi	a0,a0,368
    80001eb8:	fed51be3          	bne	a0,a3,80001eae <choose_next_process+0x24>
  return 0;
    80001ebc:	4501                	li	a0,0
}
    80001ebe:	6422                	ld	s0,8(sp)
    80001ec0:	0141                	addi	sp,sp,16
    80001ec2:	8082                	ret

0000000080001ec4 <scheduler>:
{
    80001ec4:	7139                	addi	sp,sp,-64
    80001ec6:	fc06                	sd	ra,56(sp)
    80001ec8:	f822                	sd	s0,48(sp)
    80001eca:	f426                	sd	s1,40(sp)
    80001ecc:	f04a                	sd	s2,32(sp)
    80001ece:	ec4e                	sd	s3,24(sp)
    80001ed0:	e852                	sd	s4,16(sp)
    80001ed2:	e456                	sd	s5,8(sp)
    80001ed4:	0080                	addi	s0,sp,64
    80001ed6:	8792                	mv	a5,tp
  int id = r_tp();
    80001ed8:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001eda:	00779a13          	slli	s4,a5,0x7
    80001ede:	00010717          	auipc	a4,0x10
    80001ee2:	66270713          	addi	a4,a4,1634 # 80012540 <pid_lock>
    80001ee6:	9752                	add	a4,a4,s4
    80001ee8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001eec:	00010717          	auipc	a4,0x10
    80001ef0:	68c70713          	addi	a4,a4,1676 # 80012578 <cpus+0x8>
    80001ef4:	9a3a                	add	s4,s4,a4
      if (p->state == RUNNABLE) {
    80001ef6:	490d                	li	s2,3
        p->state = RUNNING;
    80001ef8:	4a91                	li	s5,4
        c->proc = p;
    80001efa:	079e                	slli	a5,a5,0x7
    80001efc:	00010997          	auipc	s3,0x10
    80001f00:	64498993          	addi	s3,s3,1604 # 80012540 <pid_lock>
    80001f04:	99be                	add	s3,s3,a5
    80001f06:	a805                	j	80001f36 <scheduler+0x72>
        p->state = RUNNING;
    80001f08:	0154ac23          	sw	s5,24(s1)
        c->proc = p;
    80001f0c:	0299b823          	sd	s1,48(s3)
        swtch(&c->context, &p->context);
    80001f10:	06048593          	addi	a1,s1,96
    80001f14:	8552                	mv	a0,s4
    80001f16:	5c0000ef          	jal	800024d6 <swtch>
        c->proc = 0;
    80001f1a:	0209b823          	sd	zero,48(s3)
      release(&p->lock);
    80001f1e:	8526                	mv	a0,s1
    80001f20:	d7bfe0ef          	jal	80000c9a <release>
    if(found == 0) {
    80001f24:	a809                	j	80001f36 <scheduler+0x72>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f26:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f2a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f2e:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001f32:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f36:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f3a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f3e:	10079073          	csrw	sstatus,a5
    p = choose_next_process();
    80001f42:	f49ff0ef          	jal	80001e8a <choose_next_process>
    80001f46:	84aa                	mv	s1,a0
    if(p != 0) {
    80001f48:	dd79                	beqz	a0,80001f26 <scheduler+0x62>
      acquire(&p->lock);
    80001f4a:	cb9fe0ef          	jal	80000c02 <acquire>
      if (p->state == RUNNABLE) {
    80001f4e:	4c9c                	lw	a5,24(s1)
    80001f50:	fb278ce3          	beq	a5,s2,80001f08 <scheduler+0x44>
      release(&p->lock);
    80001f54:	8526                	mv	a0,s1
    80001f56:	d45fe0ef          	jal	80000c9a <release>
    if(found == 0) {
    80001f5a:	b7f1                	j	80001f26 <scheduler+0x62>

0000000080001f5c <sched>:
{
    80001f5c:	7179                	addi	sp,sp,-48
    80001f5e:	f406                	sd	ra,40(sp)
    80001f60:	f022                	sd	s0,32(sp)
    80001f62:	ec26                	sd	s1,24(sp)
    80001f64:	e84a                	sd	s2,16(sp)
    80001f66:	e44e                	sd	s3,8(sp)
    80001f68:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001f6a:	997ff0ef          	jal	80001900 <myproc>
    80001f6e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001f70:	c29fe0ef          	jal	80000b98 <holding>
    80001f74:	c92d                	beqz	a0,80001fe6 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f76:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001f78:	2781                	sext.w	a5,a5
    80001f7a:	079e                	slli	a5,a5,0x7
    80001f7c:	00010717          	auipc	a4,0x10
    80001f80:	5c470713          	addi	a4,a4,1476 # 80012540 <pid_lock>
    80001f84:	97ba                	add	a5,a5,a4
    80001f86:	0a87a703          	lw	a4,168(a5)
    80001f8a:	4785                	li	a5,1
    80001f8c:	06f71363          	bne	a4,a5,80001ff2 <sched+0x96>
  if(p->state == RUNNING)
    80001f90:	4c98                	lw	a4,24(s1)
    80001f92:	4791                	li	a5,4
    80001f94:	06f70563          	beq	a4,a5,80001ffe <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f98:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f9c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001f9e:	e7b5                	bnez	a5,8000200a <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fa0:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001fa2:	00010917          	auipc	s2,0x10
    80001fa6:	59e90913          	addi	s2,s2,1438 # 80012540 <pid_lock>
    80001faa:	2781                	sext.w	a5,a5
    80001fac:	079e                	slli	a5,a5,0x7
    80001fae:	97ca                	add	a5,a5,s2
    80001fb0:	0ac7a983          	lw	s3,172(a5)
    80001fb4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001fb6:	2781                	sext.w	a5,a5
    80001fb8:	079e                	slli	a5,a5,0x7
    80001fba:	00010597          	auipc	a1,0x10
    80001fbe:	5be58593          	addi	a1,a1,1470 # 80012578 <cpus+0x8>
    80001fc2:	95be                	add	a1,a1,a5
    80001fc4:	06048513          	addi	a0,s1,96
    80001fc8:	50e000ef          	jal	800024d6 <swtch>
    80001fcc:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001fce:	2781                	sext.w	a5,a5
    80001fd0:	079e                	slli	a5,a5,0x7
    80001fd2:	993e                	add	s2,s2,a5
    80001fd4:	0b392623          	sw	s3,172(s2)
}
    80001fd8:	70a2                	ld	ra,40(sp)
    80001fda:	7402                	ld	s0,32(sp)
    80001fdc:	64e2                	ld	s1,24(sp)
    80001fde:	6942                	ld	s2,16(sp)
    80001fe0:	69a2                	ld	s3,8(sp)
    80001fe2:	6145                	addi	sp,sp,48
    80001fe4:	8082                	ret
    panic("sched p->lock");
    80001fe6:	00005517          	auipc	a0,0x5
    80001fea:	25250513          	addi	a0,a0,594 # 80007238 <etext+0x238>
    80001fee:	fb4fe0ef          	jal	800007a2 <panic>
    panic("sched locks");
    80001ff2:	00005517          	auipc	a0,0x5
    80001ff6:	25650513          	addi	a0,a0,598 # 80007248 <etext+0x248>
    80001ffa:	fa8fe0ef          	jal	800007a2 <panic>
    panic("sched running");
    80001ffe:	00005517          	auipc	a0,0x5
    80002002:	25a50513          	addi	a0,a0,602 # 80007258 <etext+0x258>
    80002006:	f9cfe0ef          	jal	800007a2 <panic>
    panic("sched interruptible");
    8000200a:	00005517          	auipc	a0,0x5
    8000200e:	25e50513          	addi	a0,a0,606 # 80007268 <etext+0x268>
    80002012:	f90fe0ef          	jal	800007a2 <panic>

0000000080002016 <yield>:
{
    80002016:	1101                	addi	sp,sp,-32
    80002018:	ec06                	sd	ra,24(sp)
    8000201a:	e822                	sd	s0,16(sp)
    8000201c:	e426                	sd	s1,8(sp)
    8000201e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002020:	8e1ff0ef          	jal	80001900 <myproc>
    80002024:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002026:	bddfe0ef          	jal	80000c02 <acquire>
  p->state = RUNNABLE;
    8000202a:	478d                	li	a5,3
    8000202c:	cc9c                	sw	a5,24(s1)
  sched();
    8000202e:	f2fff0ef          	jal	80001f5c <sched>
  release(&p->lock);
    80002032:	8526                	mv	a0,s1
    80002034:	c67fe0ef          	jal	80000c9a <release>
}
    80002038:	60e2                	ld	ra,24(sp)
    8000203a:	6442                	ld	s0,16(sp)
    8000203c:	64a2                	ld	s1,8(sp)
    8000203e:	6105                	addi	sp,sp,32
    80002040:	8082                	ret

0000000080002042 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002042:	7179                	addi	sp,sp,-48
    80002044:	f406                	sd	ra,40(sp)
    80002046:	f022                	sd	s0,32(sp)
    80002048:	ec26                	sd	s1,24(sp)
    8000204a:	e84a                	sd	s2,16(sp)
    8000204c:	e44e                	sd	s3,8(sp)
    8000204e:	1800                	addi	s0,sp,48
    80002050:	89aa                	mv	s3,a0
    80002052:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002054:	8adff0ef          	jal	80001900 <myproc>
    80002058:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000205a:	ba9fe0ef          	jal	80000c02 <acquire>
  release(lk);
    8000205e:	854a                	mv	a0,s2
    80002060:	c3bfe0ef          	jal	80000c9a <release>

  // Go to sleep.
  p->chan = chan;
    80002064:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002068:	4789                	li	a5,2
    8000206a:	cc9c                	sw	a5,24(s1)

  sched();
    8000206c:	ef1ff0ef          	jal	80001f5c <sched>

  // Tidy up.
  p->chan = 0;
    80002070:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002074:	8526                	mv	a0,s1
    80002076:	c25fe0ef          	jal	80000c9a <release>
  acquire(lk);
    8000207a:	854a                	mv	a0,s2
    8000207c:	b87fe0ef          	jal	80000c02 <acquire>
}
    80002080:	70a2                	ld	ra,40(sp)
    80002082:	7402                	ld	s0,32(sp)
    80002084:	64e2                	ld	s1,24(sp)
    80002086:	6942                	ld	s2,16(sp)
    80002088:	69a2                	ld	s3,8(sp)
    8000208a:	6145                	addi	sp,sp,48
    8000208c:	8082                	ret

000000008000208e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000208e:	7139                	addi	sp,sp,-64
    80002090:	fc06                	sd	ra,56(sp)
    80002092:	f822                	sd	s0,48(sp)
    80002094:	f426                	sd	s1,40(sp)
    80002096:	f04a                	sd	s2,32(sp)
    80002098:	ec4e                	sd	s3,24(sp)
    8000209a:	e852                	sd	s4,16(sp)
    8000209c:	e456                	sd	s5,8(sp)
    8000209e:	0080                	addi	s0,sp,64
    800020a0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800020a2:	00011497          	auipc	s1,0x11
    800020a6:	8ce48493          	addi	s1,s1,-1842 # 80012970 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800020aa:	4989                	li	s3,2
        p->state = RUNNABLE;
    800020ac:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800020ae:	00016917          	auipc	s2,0x16
    800020b2:	4c290913          	addi	s2,s2,1218 # 80018570 <tickslock>
    800020b6:	a801                	j	800020c6 <wakeup+0x38>
      }
      release(&p->lock);
    800020b8:	8526                	mv	a0,s1
    800020ba:	be1fe0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800020be:	17048493          	addi	s1,s1,368
    800020c2:	03248263          	beq	s1,s2,800020e6 <wakeup+0x58>
    if(p != myproc()){
    800020c6:	83bff0ef          	jal	80001900 <myproc>
    800020ca:	fea48ae3          	beq	s1,a0,800020be <wakeup+0x30>
      acquire(&p->lock);
    800020ce:	8526                	mv	a0,s1
    800020d0:	b33fe0ef          	jal	80000c02 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800020d4:	4c9c                	lw	a5,24(s1)
    800020d6:	ff3791e3          	bne	a5,s3,800020b8 <wakeup+0x2a>
    800020da:	709c                	ld	a5,32(s1)
    800020dc:	fd479ee3          	bne	a5,s4,800020b8 <wakeup+0x2a>
        p->state = RUNNABLE;
    800020e0:	0154ac23          	sw	s5,24(s1)
    800020e4:	bfd1                	j	800020b8 <wakeup+0x2a>
    }
  }
}
    800020e6:	70e2                	ld	ra,56(sp)
    800020e8:	7442                	ld	s0,48(sp)
    800020ea:	74a2                	ld	s1,40(sp)
    800020ec:	7902                	ld	s2,32(sp)
    800020ee:	69e2                	ld	s3,24(sp)
    800020f0:	6a42                	ld	s4,16(sp)
    800020f2:	6aa2                	ld	s5,8(sp)
    800020f4:	6121                	addi	sp,sp,64
    800020f6:	8082                	ret

00000000800020f8 <reparent>:
{
    800020f8:	7179                	addi	sp,sp,-48
    800020fa:	f406                	sd	ra,40(sp)
    800020fc:	f022                	sd	s0,32(sp)
    800020fe:	ec26                	sd	s1,24(sp)
    80002100:	e84a                	sd	s2,16(sp)
    80002102:	e44e                	sd	s3,8(sp)
    80002104:	e052                	sd	s4,0(sp)
    80002106:	1800                	addi	s0,sp,48
    80002108:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000210a:	00011497          	auipc	s1,0x11
    8000210e:	86648493          	addi	s1,s1,-1946 # 80012970 <proc>
      pp->parent = initproc;
    80002112:	00008a17          	auipc	s4,0x8
    80002116:	2eea0a13          	addi	s4,s4,750 # 8000a400 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000211a:	00016997          	auipc	s3,0x16
    8000211e:	45698993          	addi	s3,s3,1110 # 80018570 <tickslock>
    80002122:	a029                	j	8000212c <reparent+0x34>
    80002124:	17048493          	addi	s1,s1,368
    80002128:	01348b63          	beq	s1,s3,8000213e <reparent+0x46>
    if(pp->parent == p){
    8000212c:	7c9c                	ld	a5,56(s1)
    8000212e:	ff279be3          	bne	a5,s2,80002124 <reparent+0x2c>
      pp->parent = initproc;
    80002132:	000a3503          	ld	a0,0(s4)
    80002136:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002138:	f57ff0ef          	jal	8000208e <wakeup>
    8000213c:	b7e5                	j	80002124 <reparent+0x2c>
}
    8000213e:	70a2                	ld	ra,40(sp)
    80002140:	7402                	ld	s0,32(sp)
    80002142:	64e2                	ld	s1,24(sp)
    80002144:	6942                	ld	s2,16(sp)
    80002146:	69a2                	ld	s3,8(sp)
    80002148:	6a02                	ld	s4,0(sp)
    8000214a:	6145                	addi	sp,sp,48
    8000214c:	8082                	ret

000000008000214e <exit>:
{
    8000214e:	7179                	addi	sp,sp,-48
    80002150:	f406                	sd	ra,40(sp)
    80002152:	f022                	sd	s0,32(sp)
    80002154:	ec26                	sd	s1,24(sp)
    80002156:	e84a                	sd	s2,16(sp)
    80002158:	e44e                	sd	s3,8(sp)
    8000215a:	e052                	sd	s4,0(sp)
    8000215c:	1800                	addi	s0,sp,48
    8000215e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002160:	fa0ff0ef          	jal	80001900 <myproc>
    80002164:	89aa                	mv	s3,a0
  if(p == initproc)
    80002166:	00008797          	auipc	a5,0x8
    8000216a:	29a7b783          	ld	a5,666(a5) # 8000a400 <initproc>
    8000216e:	0d050493          	addi	s1,a0,208
    80002172:	15050913          	addi	s2,a0,336
    80002176:	00a79f63          	bne	a5,a0,80002194 <exit+0x46>
    panic("init exiting");
    8000217a:	00005517          	auipc	a0,0x5
    8000217e:	10650513          	addi	a0,a0,262 # 80007280 <etext+0x280>
    80002182:	e20fe0ef          	jal	800007a2 <panic>
      fileclose(f);
    80002186:	76f010ef          	jal	800040f4 <fileclose>
      p->ofile[fd] = 0;
    8000218a:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000218e:	04a1                	addi	s1,s1,8
    80002190:	01248563          	beq	s1,s2,8000219a <exit+0x4c>
    if(p->ofile[fd]){
    80002194:	6088                	ld	a0,0(s1)
    80002196:	f965                	bnez	a0,80002186 <exit+0x38>
    80002198:	bfdd                	j	8000218e <exit+0x40>
  begin_op();
    8000219a:	341010ef          	jal	80003cda <begin_op>
  iput(p->cwd);
    8000219e:	1509b503          	ld	a0,336(s3)
    800021a2:	424010ef          	jal	800035c6 <iput>
  end_op();
    800021a6:	39f010ef          	jal	80003d44 <end_op>
  p->cwd = 0;
    800021aa:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800021ae:	00010497          	auipc	s1,0x10
    800021b2:	3aa48493          	addi	s1,s1,938 # 80012558 <wait_lock>
    800021b6:	8526                	mv	a0,s1
    800021b8:	a4bfe0ef          	jal	80000c02 <acquire>
  reparent(p);
    800021bc:	854e                	mv	a0,s3
    800021be:	f3bff0ef          	jal	800020f8 <reparent>
  wakeup(p->parent);
    800021c2:	0389b503          	ld	a0,56(s3)
    800021c6:	ec9ff0ef          	jal	8000208e <wakeup>
  acquire(&p->lock);
    800021ca:	854e                	mv	a0,s3
    800021cc:	a37fe0ef          	jal	80000c02 <acquire>
  p->xstate = status;
    800021d0:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800021d4:	4795                	li	a5,5
    800021d6:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800021da:	8526                	mv	a0,s1
    800021dc:	abffe0ef          	jal	80000c9a <release>
  sched();
    800021e0:	d7dff0ef          	jal	80001f5c <sched>
  panic("zombie exit");
    800021e4:	00005517          	auipc	a0,0x5
    800021e8:	0ac50513          	addi	a0,a0,172 # 80007290 <etext+0x290>
    800021ec:	db6fe0ef          	jal	800007a2 <panic>

00000000800021f0 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800021f0:	7179                	addi	sp,sp,-48
    800021f2:	f406                	sd	ra,40(sp)
    800021f4:	f022                	sd	s0,32(sp)
    800021f6:	ec26                	sd	s1,24(sp)
    800021f8:	e84a                	sd	s2,16(sp)
    800021fa:	e44e                	sd	s3,8(sp)
    800021fc:	1800                	addi	s0,sp,48
    800021fe:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002200:	00010497          	auipc	s1,0x10
    80002204:	77048493          	addi	s1,s1,1904 # 80012970 <proc>
    80002208:	00016997          	auipc	s3,0x16
    8000220c:	36898993          	addi	s3,s3,872 # 80018570 <tickslock>
    acquire(&p->lock);
    80002210:	8526                	mv	a0,s1
    80002212:	9f1fe0ef          	jal	80000c02 <acquire>
    if(p->pid == pid){
    80002216:	589c                	lw	a5,48(s1)
    80002218:	01278b63          	beq	a5,s2,8000222e <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000221c:	8526                	mv	a0,s1
    8000221e:	a7dfe0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002222:	17048493          	addi	s1,s1,368
    80002226:	ff3495e3          	bne	s1,s3,80002210 <kill+0x20>
  }
  return -1;
    8000222a:	557d                	li	a0,-1
    8000222c:	a819                	j	80002242 <kill+0x52>
      p->killed = 1;
    8000222e:	4785                	li	a5,1
    80002230:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002232:	4c98                	lw	a4,24(s1)
    80002234:	4789                	li	a5,2
    80002236:	00f70d63          	beq	a4,a5,80002250 <kill+0x60>
      release(&p->lock);
    8000223a:	8526                	mv	a0,s1
    8000223c:	a5ffe0ef          	jal	80000c9a <release>
      return 0;
    80002240:	4501                	li	a0,0
}
    80002242:	70a2                	ld	ra,40(sp)
    80002244:	7402                	ld	s0,32(sp)
    80002246:	64e2                	ld	s1,24(sp)
    80002248:	6942                	ld	s2,16(sp)
    8000224a:	69a2                	ld	s3,8(sp)
    8000224c:	6145                	addi	sp,sp,48
    8000224e:	8082                	ret
        p->state = RUNNABLE;
    80002250:	478d                	li	a5,3
    80002252:	cc9c                	sw	a5,24(s1)
    80002254:	b7dd                	j	8000223a <kill+0x4a>

0000000080002256 <setkilled>:

void
setkilled(struct proc *p)
{
    80002256:	1101                	addi	sp,sp,-32
    80002258:	ec06                	sd	ra,24(sp)
    8000225a:	e822                	sd	s0,16(sp)
    8000225c:	e426                	sd	s1,8(sp)
    8000225e:	1000                	addi	s0,sp,32
    80002260:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002262:	9a1fe0ef          	jal	80000c02 <acquire>
  p->killed = 1;
    80002266:	4785                	li	a5,1
    80002268:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000226a:	8526                	mv	a0,s1
    8000226c:	a2ffe0ef          	jal	80000c9a <release>
}
    80002270:	60e2                	ld	ra,24(sp)
    80002272:	6442                	ld	s0,16(sp)
    80002274:	64a2                	ld	s1,8(sp)
    80002276:	6105                	addi	sp,sp,32
    80002278:	8082                	ret

000000008000227a <killed>:

int
killed(struct proc *p)
{
    8000227a:	1101                	addi	sp,sp,-32
    8000227c:	ec06                	sd	ra,24(sp)
    8000227e:	e822                	sd	s0,16(sp)
    80002280:	e426                	sd	s1,8(sp)
    80002282:	e04a                	sd	s2,0(sp)
    80002284:	1000                	addi	s0,sp,32
    80002286:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002288:	97bfe0ef          	jal	80000c02 <acquire>
  k = p->killed;
    8000228c:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002290:	8526                	mv	a0,s1
    80002292:	a09fe0ef          	jal	80000c9a <release>
  return k;
}
    80002296:	854a                	mv	a0,s2
    80002298:	60e2                	ld	ra,24(sp)
    8000229a:	6442                	ld	s0,16(sp)
    8000229c:	64a2                	ld	s1,8(sp)
    8000229e:	6902                	ld	s2,0(sp)
    800022a0:	6105                	addi	sp,sp,32
    800022a2:	8082                	ret

00000000800022a4 <wait>:
{
    800022a4:	715d                	addi	sp,sp,-80
    800022a6:	e486                	sd	ra,72(sp)
    800022a8:	e0a2                	sd	s0,64(sp)
    800022aa:	fc26                	sd	s1,56(sp)
    800022ac:	f84a                	sd	s2,48(sp)
    800022ae:	f44e                	sd	s3,40(sp)
    800022b0:	f052                	sd	s4,32(sp)
    800022b2:	ec56                	sd	s5,24(sp)
    800022b4:	e85a                	sd	s6,16(sp)
    800022b6:	e45e                	sd	s7,8(sp)
    800022b8:	e062                	sd	s8,0(sp)
    800022ba:	0880                	addi	s0,sp,80
    800022bc:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800022be:	e42ff0ef          	jal	80001900 <myproc>
    800022c2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800022c4:	00010517          	auipc	a0,0x10
    800022c8:	29450513          	addi	a0,a0,660 # 80012558 <wait_lock>
    800022cc:	937fe0ef          	jal	80000c02 <acquire>
    havekids = 0;
    800022d0:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800022d2:	4a15                	li	s4,5
        havekids = 1;
    800022d4:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800022d6:	00016997          	auipc	s3,0x16
    800022da:	29a98993          	addi	s3,s3,666 # 80018570 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800022de:	00010c17          	auipc	s8,0x10
    800022e2:	27ac0c13          	addi	s8,s8,634 # 80012558 <wait_lock>
    800022e6:	a871                	j	80002382 <wait+0xde>
          pid = pp->pid;
    800022e8:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800022ec:	000b0c63          	beqz	s6,80002304 <wait+0x60>
    800022f0:	4691                	li	a3,4
    800022f2:	02c48613          	addi	a2,s1,44
    800022f6:	85da                	mv	a1,s6
    800022f8:	05093503          	ld	a0,80(s2)
    800022fc:	a76ff0ef          	jal	80001572 <copyout>
    80002300:	02054b63          	bltz	a0,80002336 <wait+0x92>
          freeproc(pp);
    80002304:	8526                	mv	a0,s1
    80002306:	85dff0ef          	jal	80001b62 <freeproc>
          release(&pp->lock);
    8000230a:	8526                	mv	a0,s1
    8000230c:	98ffe0ef          	jal	80000c9a <release>
          release(&wait_lock);
    80002310:	00010517          	auipc	a0,0x10
    80002314:	24850513          	addi	a0,a0,584 # 80012558 <wait_lock>
    80002318:	983fe0ef          	jal	80000c9a <release>
}
    8000231c:	854e                	mv	a0,s3
    8000231e:	60a6                	ld	ra,72(sp)
    80002320:	6406                	ld	s0,64(sp)
    80002322:	74e2                	ld	s1,56(sp)
    80002324:	7942                	ld	s2,48(sp)
    80002326:	79a2                	ld	s3,40(sp)
    80002328:	7a02                	ld	s4,32(sp)
    8000232a:	6ae2                	ld	s5,24(sp)
    8000232c:	6b42                	ld	s6,16(sp)
    8000232e:	6ba2                	ld	s7,8(sp)
    80002330:	6c02                	ld	s8,0(sp)
    80002332:	6161                	addi	sp,sp,80
    80002334:	8082                	ret
            release(&pp->lock);
    80002336:	8526                	mv	a0,s1
    80002338:	963fe0ef          	jal	80000c9a <release>
            release(&wait_lock);
    8000233c:	00010517          	auipc	a0,0x10
    80002340:	21c50513          	addi	a0,a0,540 # 80012558 <wait_lock>
    80002344:	957fe0ef          	jal	80000c9a <release>
            return -1;
    80002348:	59fd                	li	s3,-1
    8000234a:	bfc9                	j	8000231c <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000234c:	17048493          	addi	s1,s1,368
    80002350:	03348063          	beq	s1,s3,80002370 <wait+0xcc>
      if(pp->parent == p){
    80002354:	7c9c                	ld	a5,56(s1)
    80002356:	ff279be3          	bne	a5,s2,8000234c <wait+0xa8>
        acquire(&pp->lock);
    8000235a:	8526                	mv	a0,s1
    8000235c:	8a7fe0ef          	jal	80000c02 <acquire>
        if(pp->state == ZOMBIE){
    80002360:	4c9c                	lw	a5,24(s1)
    80002362:	f94783e3          	beq	a5,s4,800022e8 <wait+0x44>
        release(&pp->lock);
    80002366:	8526                	mv	a0,s1
    80002368:	933fe0ef          	jal	80000c9a <release>
        havekids = 1;
    8000236c:	8756                	mv	a4,s5
    8000236e:	bff9                	j	8000234c <wait+0xa8>
    if(!havekids || killed(p)){
    80002370:	cf19                	beqz	a4,8000238e <wait+0xea>
    80002372:	854a                	mv	a0,s2
    80002374:	f07ff0ef          	jal	8000227a <killed>
    80002378:	e919                	bnez	a0,8000238e <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000237a:	85e2                	mv	a1,s8
    8000237c:	854a                	mv	a0,s2
    8000237e:	cc5ff0ef          	jal	80002042 <sleep>
    havekids = 0;
    80002382:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002384:	00010497          	auipc	s1,0x10
    80002388:	5ec48493          	addi	s1,s1,1516 # 80012970 <proc>
    8000238c:	b7e1                	j	80002354 <wait+0xb0>
      release(&wait_lock);
    8000238e:	00010517          	auipc	a0,0x10
    80002392:	1ca50513          	addi	a0,a0,458 # 80012558 <wait_lock>
    80002396:	905fe0ef          	jal	80000c9a <release>
      return -1;
    8000239a:	59fd                	li	s3,-1
    8000239c:	b741                	j	8000231c <wait+0x78>

000000008000239e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000239e:	7179                	addi	sp,sp,-48
    800023a0:	f406                	sd	ra,40(sp)
    800023a2:	f022                	sd	s0,32(sp)
    800023a4:	ec26                	sd	s1,24(sp)
    800023a6:	e84a                	sd	s2,16(sp)
    800023a8:	e44e                	sd	s3,8(sp)
    800023aa:	e052                	sd	s4,0(sp)
    800023ac:	1800                	addi	s0,sp,48
    800023ae:	84aa                	mv	s1,a0
    800023b0:	892e                	mv	s2,a1
    800023b2:	89b2                	mv	s3,a2
    800023b4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800023b6:	d4aff0ef          	jal	80001900 <myproc>
  if(user_dst){
    800023ba:	cc99                	beqz	s1,800023d8 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800023bc:	86d2                	mv	a3,s4
    800023be:	864e                	mv	a2,s3
    800023c0:	85ca                	mv	a1,s2
    800023c2:	6928                	ld	a0,80(a0)
    800023c4:	9aeff0ef          	jal	80001572 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800023c8:	70a2                	ld	ra,40(sp)
    800023ca:	7402                	ld	s0,32(sp)
    800023cc:	64e2                	ld	s1,24(sp)
    800023ce:	6942                	ld	s2,16(sp)
    800023d0:	69a2                	ld	s3,8(sp)
    800023d2:	6a02                	ld	s4,0(sp)
    800023d4:	6145                	addi	sp,sp,48
    800023d6:	8082                	ret
    memmove((char *)dst, src, len);
    800023d8:	000a061b          	sext.w	a2,s4
    800023dc:	85ce                	mv	a1,s3
    800023de:	854a                	mv	a0,s2
    800023e0:	953fe0ef          	jal	80000d32 <memmove>
    return 0;
    800023e4:	8526                	mv	a0,s1
    800023e6:	b7cd                	j	800023c8 <either_copyout+0x2a>

00000000800023e8 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800023e8:	7179                	addi	sp,sp,-48
    800023ea:	f406                	sd	ra,40(sp)
    800023ec:	f022                	sd	s0,32(sp)
    800023ee:	ec26                	sd	s1,24(sp)
    800023f0:	e84a                	sd	s2,16(sp)
    800023f2:	e44e                	sd	s3,8(sp)
    800023f4:	e052                	sd	s4,0(sp)
    800023f6:	1800                	addi	s0,sp,48
    800023f8:	892a                	mv	s2,a0
    800023fa:	84ae                	mv	s1,a1
    800023fc:	89b2                	mv	s3,a2
    800023fe:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002400:	d00ff0ef          	jal	80001900 <myproc>
  if(user_src){
    80002404:	cc99                	beqz	s1,80002422 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002406:	86d2                	mv	a3,s4
    80002408:	864e                	mv	a2,s3
    8000240a:	85ca                	mv	a1,s2
    8000240c:	6928                	ld	a0,80(a0)
    8000240e:	a3aff0ef          	jal	80001648 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002412:	70a2                	ld	ra,40(sp)
    80002414:	7402                	ld	s0,32(sp)
    80002416:	64e2                	ld	s1,24(sp)
    80002418:	6942                	ld	s2,16(sp)
    8000241a:	69a2                	ld	s3,8(sp)
    8000241c:	6a02                	ld	s4,0(sp)
    8000241e:	6145                	addi	sp,sp,48
    80002420:	8082                	ret
    memmove(dst, (char*)src, len);
    80002422:	000a061b          	sext.w	a2,s4
    80002426:	85ce                	mv	a1,s3
    80002428:	854a                	mv	a0,s2
    8000242a:	909fe0ef          	jal	80000d32 <memmove>
    return 0;
    8000242e:	8526                	mv	a0,s1
    80002430:	b7cd                	j	80002412 <either_copyin+0x2a>

0000000080002432 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002432:	715d                	addi	sp,sp,-80
    80002434:	e486                	sd	ra,72(sp)
    80002436:	e0a2                	sd	s0,64(sp)
    80002438:	fc26                	sd	s1,56(sp)
    8000243a:	f84a                	sd	s2,48(sp)
    8000243c:	f44e                	sd	s3,40(sp)
    8000243e:	f052                	sd	s4,32(sp)
    80002440:	ec56                	sd	s5,24(sp)
    80002442:	e85a                	sd	s6,16(sp)
    80002444:	e45e                	sd	s7,8(sp)
    80002446:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002448:	00005517          	auipc	a0,0x5
    8000244c:	c3050513          	addi	a0,a0,-976 # 80007078 <etext+0x78>
    80002450:	880fe0ef          	jal	800004d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002454:	00010497          	auipc	s1,0x10
    80002458:	67448493          	addi	s1,s1,1652 # 80012ac8 <proc+0x158>
    8000245c:	00016917          	auipc	s2,0x16
    80002460:	26c90913          	addi	s2,s2,620 # 800186c8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002464:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002466:	00005997          	auipc	s3,0x5
    8000246a:	e3a98993          	addi	s3,s3,-454 # 800072a0 <etext+0x2a0>
    printf("%d %s %s", p->pid, state, p->name);
    8000246e:	00005a97          	auipc	s5,0x5
    80002472:	e3aa8a93          	addi	s5,s5,-454 # 800072a8 <etext+0x2a8>
    printf("\n");
    80002476:	00005a17          	auipc	s4,0x5
    8000247a:	c02a0a13          	addi	s4,s4,-1022 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000247e:	00005b97          	auipc	s7,0x5
    80002482:	31ab8b93          	addi	s7,s7,794 # 80007798 <states.0>
    80002486:	a829                	j	800024a0 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002488:	ed86a583          	lw	a1,-296(a3)
    8000248c:	8556                	mv	a0,s5
    8000248e:	842fe0ef          	jal	800004d0 <printf>
    printf("\n");
    80002492:	8552                	mv	a0,s4
    80002494:	83cfe0ef          	jal	800004d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002498:	17048493          	addi	s1,s1,368
    8000249c:	03248263          	beq	s1,s2,800024c0 <procdump+0x8e>
    if(p->state == UNUSED)
    800024a0:	86a6                	mv	a3,s1
    800024a2:	ec04a783          	lw	a5,-320(s1)
    800024a6:	dbed                	beqz	a5,80002498 <procdump+0x66>
      state = "???";
    800024a8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800024aa:	fcfb6fe3          	bltu	s6,a5,80002488 <procdump+0x56>
    800024ae:	02079713          	slli	a4,a5,0x20
    800024b2:	01d75793          	srli	a5,a4,0x1d
    800024b6:	97de                	add	a5,a5,s7
    800024b8:	6390                	ld	a2,0(a5)
    800024ba:	f679                	bnez	a2,80002488 <procdump+0x56>
      state = "???";
    800024bc:	864e                	mv	a2,s3
    800024be:	b7e9                	j	80002488 <procdump+0x56>
  }
    800024c0:	60a6                	ld	ra,72(sp)
    800024c2:	6406                	ld	s0,64(sp)
    800024c4:	74e2                	ld	s1,56(sp)
    800024c6:	7942                	ld	s2,48(sp)
    800024c8:	79a2                	ld	s3,40(sp)
    800024ca:	7a02                	ld	s4,32(sp)
    800024cc:	6ae2                	ld	s5,24(sp)
    800024ce:	6b42                	ld	s6,16(sp)
    800024d0:	6ba2                	ld	s7,8(sp)
    800024d2:	6161                	addi	sp,sp,80
    800024d4:	8082                	ret

00000000800024d6 <swtch>:
    800024d6:	00153023          	sd	ra,0(a0)
    800024da:	00253423          	sd	sp,8(a0)
    800024de:	e900                	sd	s0,16(a0)
    800024e0:	ed04                	sd	s1,24(a0)
    800024e2:	03253023          	sd	s2,32(a0)
    800024e6:	03353423          	sd	s3,40(a0)
    800024ea:	03453823          	sd	s4,48(a0)
    800024ee:	03553c23          	sd	s5,56(a0)
    800024f2:	05653023          	sd	s6,64(a0)
    800024f6:	05753423          	sd	s7,72(a0)
    800024fa:	05853823          	sd	s8,80(a0)
    800024fe:	05953c23          	sd	s9,88(a0)
    80002502:	07a53023          	sd	s10,96(a0)
    80002506:	07b53423          	sd	s11,104(a0)
    8000250a:	0005b083          	ld	ra,0(a1)
    8000250e:	0085b103          	ld	sp,8(a1)
    80002512:	6980                	ld	s0,16(a1)
    80002514:	6d84                	ld	s1,24(a1)
    80002516:	0205b903          	ld	s2,32(a1)
    8000251a:	0285b983          	ld	s3,40(a1)
    8000251e:	0305ba03          	ld	s4,48(a1)
    80002522:	0385ba83          	ld	s5,56(a1)
    80002526:	0405bb03          	ld	s6,64(a1)
    8000252a:	0485bb83          	ld	s7,72(a1)
    8000252e:	0505bc03          	ld	s8,80(a1)
    80002532:	0585bc83          	ld	s9,88(a1)
    80002536:	0605bd03          	ld	s10,96(a1)
    8000253a:	0685bd83          	ld	s11,104(a1)
    8000253e:	8082                	ret

0000000080002540 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002540:	1141                	addi	sp,sp,-16
    80002542:	e406                	sd	ra,8(sp)
    80002544:	e022                	sd	s0,0(sp)
    80002546:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002548:	00005597          	auipc	a1,0x5
    8000254c:	da058593          	addi	a1,a1,-608 # 800072e8 <etext+0x2e8>
    80002550:	00016517          	auipc	a0,0x16
    80002554:	02050513          	addi	a0,a0,32 # 80018570 <tickslock>
    80002558:	e2afe0ef          	jal	80000b82 <initlock>
}
    8000255c:	60a2                	ld	ra,8(sp)
    8000255e:	6402                	ld	s0,0(sp)
    80002560:	0141                	addi	sp,sp,16
    80002562:	8082                	ret

0000000080002564 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002564:	1141                	addi	sp,sp,-16
    80002566:	e422                	sd	s0,8(sp)
    80002568:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000256a:	00003797          	auipc	a5,0x3
    8000256e:	ef678793          	addi	a5,a5,-266 # 80005460 <kernelvec>
    80002572:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002576:	6422                	ld	s0,8(sp)
    80002578:	0141                	addi	sp,sp,16
    8000257a:	8082                	ret

000000008000257c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000257c:	1141                	addi	sp,sp,-16
    8000257e:	e406                	sd	ra,8(sp)
    80002580:	e022                	sd	s0,0(sp)
    80002582:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002584:	b7cff0ef          	jal	80001900 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002588:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000258c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000258e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002592:	00004697          	auipc	a3,0x4
    80002596:	a6e68693          	addi	a3,a3,-1426 # 80006000 <_trampoline>
    8000259a:	00004717          	auipc	a4,0x4
    8000259e:	a6670713          	addi	a4,a4,-1434 # 80006000 <_trampoline>
    800025a2:	8f15                	sub	a4,a4,a3
    800025a4:	040007b7          	lui	a5,0x4000
    800025a8:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800025aa:	07b2                	slli	a5,a5,0xc
    800025ac:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025ae:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800025b2:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800025b4:	18002673          	csrr	a2,satp
    800025b8:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800025ba:	6d30                	ld	a2,88(a0)
    800025bc:	6138                	ld	a4,64(a0)
    800025be:	6585                	lui	a1,0x1
    800025c0:	972e                	add	a4,a4,a1
    800025c2:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800025c4:	6d38                	ld	a4,88(a0)
    800025c6:	00000617          	auipc	a2,0x0
    800025ca:	11a60613          	addi	a2,a2,282 # 800026e0 <usertrap>
    800025ce:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800025d0:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800025d2:	8612                	mv	a2,tp
    800025d4:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025d6:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800025da:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800025de:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025e2:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800025e6:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800025e8:	6f18                	ld	a4,24(a4)
    800025ea:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800025ee:	6928                	ld	a0,80(a0)
    800025f0:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800025f2:	00004717          	auipc	a4,0x4
    800025f6:	aaa70713          	addi	a4,a4,-1366 # 8000609c <userret>
    800025fa:	8f15                	sub	a4,a4,a3
    800025fc:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800025fe:	577d                	li	a4,-1
    80002600:	177e                	slli	a4,a4,0x3f
    80002602:	8d59                	or	a0,a0,a4
    80002604:	9782                	jalr	a5
}
    80002606:	60a2                	ld	ra,8(sp)
    80002608:	6402                	ld	s0,0(sp)
    8000260a:	0141                	addi	sp,sp,16
    8000260c:	8082                	ret

000000008000260e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000260e:	1101                	addi	sp,sp,-32
    80002610:	ec06                	sd	ra,24(sp)
    80002612:	e822                	sd	s0,16(sp)
    80002614:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80002616:	abeff0ef          	jal	800018d4 <cpuid>
    8000261a:	cd11                	beqz	a0,80002636 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000261c:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002620:	000f4737          	lui	a4,0xf4
    80002624:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002628:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000262a:	14d79073          	csrw	stimecmp,a5
}
    8000262e:	60e2                	ld	ra,24(sp)
    80002630:	6442                	ld	s0,16(sp)
    80002632:	6105                	addi	sp,sp,32
    80002634:	8082                	ret
    80002636:	e426                	sd	s1,8(sp)
    80002638:	e04a                	sd	s2,0(sp)
    acquire(&tickslock);
    8000263a:	00016917          	auipc	s2,0x16
    8000263e:	f3690913          	addi	s2,s2,-202 # 80018570 <tickslock>
    80002642:	854a                	mv	a0,s2
    80002644:	dbefe0ef          	jal	80000c02 <acquire>
    ticks++;
    80002648:	00008497          	auipc	s1,0x8
    8000264c:	dc048493          	addi	s1,s1,-576 # 8000a408 <ticks>
    80002650:	409c                	lw	a5,0(s1)
    80002652:	2785                	addiw	a5,a5,1
    80002654:	c09c                	sw	a5,0(s1)
    update_time();
    80002656:	fdeff0ef          	jal	80001e34 <update_time>
    wakeup(&ticks);
    8000265a:	8526                	mv	a0,s1
    8000265c:	a33ff0ef          	jal	8000208e <wakeup>
    release(&tickslock);
    80002660:	854a                	mv	a0,s2
    80002662:	e38fe0ef          	jal	80000c9a <release>
    80002666:	64a2                	ld	s1,8(sp)
    80002668:	6902                	ld	s2,0(sp)
    8000266a:	bf4d                	j	8000261c <clockintr+0xe>

000000008000266c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000266c:	1101                	addi	sp,sp,-32
    8000266e:	ec06                	sd	ra,24(sp)
    80002670:	e822                	sd	s0,16(sp)
    80002672:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002674:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002678:	57fd                	li	a5,-1
    8000267a:	17fe                	slli	a5,a5,0x3f
    8000267c:	07a5                	addi	a5,a5,9
    8000267e:	00f70c63          	beq	a4,a5,80002696 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002682:	57fd                	li	a5,-1
    80002684:	17fe                	slli	a5,a5,0x3f
    80002686:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002688:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000268a:	04f70763          	beq	a4,a5,800026d8 <devintr+0x6c>
  }
}
    8000268e:	60e2                	ld	ra,24(sp)
    80002690:	6442                	ld	s0,16(sp)
    80002692:	6105                	addi	sp,sp,32
    80002694:	8082                	ret
    80002696:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002698:	675020ef          	jal	8000550c <plic_claim>
    8000269c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000269e:	47a9                	li	a5,10
    800026a0:	00f50963          	beq	a0,a5,800026b2 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800026a4:	4785                	li	a5,1
    800026a6:	00f50963          	beq	a0,a5,800026b8 <devintr+0x4c>
    return 1;
    800026aa:	4505                	li	a0,1
    } else if(irq){
    800026ac:	e889                	bnez	s1,800026be <devintr+0x52>
    800026ae:	64a2                	ld	s1,8(sp)
    800026b0:	bff9                	j	8000268e <devintr+0x22>
      uartintr();
    800026b2:	b62fe0ef          	jal	80000a14 <uartintr>
    if(irq)
    800026b6:	a819                	j	800026cc <devintr+0x60>
      virtio_disk_intr();
    800026b8:	31a030ef          	jal	800059d2 <virtio_disk_intr>
    if(irq)
    800026bc:	a801                	j	800026cc <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800026be:	85a6                	mv	a1,s1
    800026c0:	00005517          	auipc	a0,0x5
    800026c4:	c3050513          	addi	a0,a0,-976 # 800072f0 <etext+0x2f0>
    800026c8:	e09fd0ef          	jal	800004d0 <printf>
      plic_complete(irq);
    800026cc:	8526                	mv	a0,s1
    800026ce:	65f020ef          	jal	8000552c <plic_complete>
    return 1;
    800026d2:	4505                	li	a0,1
    800026d4:	64a2                	ld	s1,8(sp)
    800026d6:	bf65                	j	8000268e <devintr+0x22>
    clockintr();
    800026d8:	f37ff0ef          	jal	8000260e <clockintr>
    return 2;
    800026dc:	4509                	li	a0,2
    800026de:	bf45                	j	8000268e <devintr+0x22>

00000000800026e0 <usertrap>:
{
    800026e0:	1101                	addi	sp,sp,-32
    800026e2:	ec06                	sd	ra,24(sp)
    800026e4:	e822                	sd	s0,16(sp)
    800026e6:	e426                	sd	s1,8(sp)
    800026e8:	e04a                	sd	s2,0(sp)
    800026ea:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026ec:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800026f0:	1007f793          	andi	a5,a5,256
    800026f4:	ef85                	bnez	a5,8000272c <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026f6:	00003797          	auipc	a5,0x3
    800026fa:	d6a78793          	addi	a5,a5,-662 # 80005460 <kernelvec>
    800026fe:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002702:	9feff0ef          	jal	80001900 <myproc>
    80002706:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002708:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000270a:	14102773          	csrr	a4,sepc
    8000270e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002710:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002714:	47a1                	li	a5,8
    80002716:	02f70163          	beq	a4,a5,80002738 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    8000271a:	f53ff0ef          	jal	8000266c <devintr>
    8000271e:	892a                	mv	s2,a0
    80002720:	c135                	beqz	a0,80002784 <usertrap+0xa4>
  if(killed(p))
    80002722:	8526                	mv	a0,s1
    80002724:	b57ff0ef          	jal	8000227a <killed>
    80002728:	cd1d                	beqz	a0,80002766 <usertrap+0x86>
    8000272a:	a81d                	j	80002760 <usertrap+0x80>
    panic("usertrap: not from user mode");
    8000272c:	00005517          	auipc	a0,0x5
    80002730:	be450513          	addi	a0,a0,-1052 # 80007310 <etext+0x310>
    80002734:	86efe0ef          	jal	800007a2 <panic>
    if(killed(p))
    80002738:	b43ff0ef          	jal	8000227a <killed>
    8000273c:	e121                	bnez	a0,8000277c <usertrap+0x9c>
    p->trapframe->epc += 4;
    8000273e:	6cb8                	ld	a4,88(s1)
    80002740:	6f1c                	ld	a5,24(a4)
    80002742:	0791                	addi	a5,a5,4
    80002744:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002746:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000274a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000274e:	10079073          	csrw	sstatus,a5
    syscall();
    80002752:	248000ef          	jal	8000299a <syscall>
  if(killed(p))
    80002756:	8526                	mv	a0,s1
    80002758:	b23ff0ef          	jal	8000227a <killed>
    8000275c:	c901                	beqz	a0,8000276c <usertrap+0x8c>
    8000275e:	4901                	li	s2,0
    exit(-1);
    80002760:	557d                	li	a0,-1
    80002762:	9edff0ef          	jal	8000214e <exit>
  if(which_dev == 2)
    80002766:	4789                	li	a5,2
    80002768:	04f90563          	beq	s2,a5,800027b2 <usertrap+0xd2>
  usertrapret();
    8000276c:	e11ff0ef          	jal	8000257c <usertrapret>
}
    80002770:	60e2                	ld	ra,24(sp)
    80002772:	6442                	ld	s0,16(sp)
    80002774:	64a2                	ld	s1,8(sp)
    80002776:	6902                	ld	s2,0(sp)
    80002778:	6105                	addi	sp,sp,32
    8000277a:	8082                	ret
      exit(-1);
    8000277c:	557d                	li	a0,-1
    8000277e:	9d1ff0ef          	jal	8000214e <exit>
    80002782:	bf75                	j	8000273e <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002784:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002788:	5890                	lw	a2,48(s1)
    8000278a:	00005517          	auipc	a0,0x5
    8000278e:	ba650513          	addi	a0,a0,-1114 # 80007330 <etext+0x330>
    80002792:	d3ffd0ef          	jal	800004d0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002796:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000279a:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    8000279e:	00005517          	auipc	a0,0x5
    800027a2:	bc250513          	addi	a0,a0,-1086 # 80007360 <etext+0x360>
    800027a6:	d2bfd0ef          	jal	800004d0 <printf>
    setkilled(p);
    800027aa:	8526                	mv	a0,s1
    800027ac:	aabff0ef          	jal	80002256 <setkilled>
    800027b0:	b75d                	j	80002756 <usertrap+0x76>
    yield();
    800027b2:	865ff0ef          	jal	80002016 <yield>
    800027b6:	bf5d                	j	8000276c <usertrap+0x8c>

00000000800027b8 <kerneltrap>:
{
    800027b8:	7179                	addi	sp,sp,-48
    800027ba:	f406                	sd	ra,40(sp)
    800027bc:	f022                	sd	s0,32(sp)
    800027be:	ec26                	sd	s1,24(sp)
    800027c0:	e84a                	sd	s2,16(sp)
    800027c2:	e44e                	sd	s3,8(sp)
    800027c4:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027c6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027ca:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027ce:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800027d2:	1004f793          	andi	a5,s1,256
    800027d6:	c795                	beqz	a5,80002802 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027d8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800027dc:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800027de:	eb85                	bnez	a5,8000280e <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    800027e0:	e8dff0ef          	jal	8000266c <devintr>
    800027e4:	c91d                	beqz	a0,8000281a <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    800027e6:	4789                	li	a5,2
    800027e8:	04f50a63          	beq	a0,a5,8000283c <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800027ec:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027f0:	10049073          	csrw	sstatus,s1
}
    800027f4:	70a2                	ld	ra,40(sp)
    800027f6:	7402                	ld	s0,32(sp)
    800027f8:	64e2                	ld	s1,24(sp)
    800027fa:	6942                	ld	s2,16(sp)
    800027fc:	69a2                	ld	s3,8(sp)
    800027fe:	6145                	addi	sp,sp,48
    80002800:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002802:	00005517          	auipc	a0,0x5
    80002806:	b8650513          	addi	a0,a0,-1146 # 80007388 <etext+0x388>
    8000280a:	f99fd0ef          	jal	800007a2 <panic>
    panic("kerneltrap: interrupts enabled");
    8000280e:	00005517          	auipc	a0,0x5
    80002812:	ba250513          	addi	a0,a0,-1118 # 800073b0 <etext+0x3b0>
    80002816:	f8dfd0ef          	jal	800007a2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000281a:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000281e:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002822:	85ce                	mv	a1,s3
    80002824:	00005517          	auipc	a0,0x5
    80002828:	bac50513          	addi	a0,a0,-1108 # 800073d0 <etext+0x3d0>
    8000282c:	ca5fd0ef          	jal	800004d0 <printf>
    panic("kerneltrap");
    80002830:	00005517          	auipc	a0,0x5
    80002834:	bc850513          	addi	a0,a0,-1080 # 800073f8 <etext+0x3f8>
    80002838:	f6bfd0ef          	jal	800007a2 <panic>
  if(which_dev == 2 && myproc() != 0)
    8000283c:	8c4ff0ef          	jal	80001900 <myproc>
    80002840:	d555                	beqz	a0,800027ec <kerneltrap+0x34>
    yield();
    80002842:	fd4ff0ef          	jal	80002016 <yield>
    80002846:	b75d                	j	800027ec <kerneltrap+0x34>

0000000080002848 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002848:	1101                	addi	sp,sp,-32
    8000284a:	ec06                	sd	ra,24(sp)
    8000284c:	e822                	sd	s0,16(sp)
    8000284e:	e426                	sd	s1,8(sp)
    80002850:	1000                	addi	s0,sp,32
    80002852:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002854:	8acff0ef          	jal	80001900 <myproc>
  switch (n) {
    80002858:	4795                	li	a5,5
    8000285a:	0497e163          	bltu	a5,s1,8000289c <argraw+0x54>
    8000285e:	048a                	slli	s1,s1,0x2
    80002860:	00005717          	auipc	a4,0x5
    80002864:	f6870713          	addi	a4,a4,-152 # 800077c8 <states.0+0x30>
    80002868:	94ba                	add	s1,s1,a4
    8000286a:	409c                	lw	a5,0(s1)
    8000286c:	97ba                	add	a5,a5,a4
    8000286e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002870:	6d3c                	ld	a5,88(a0)
    80002872:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002874:	60e2                	ld	ra,24(sp)
    80002876:	6442                	ld	s0,16(sp)
    80002878:	64a2                	ld	s1,8(sp)
    8000287a:	6105                	addi	sp,sp,32
    8000287c:	8082                	ret
    return p->trapframe->a1;
    8000287e:	6d3c                	ld	a5,88(a0)
    80002880:	7fa8                	ld	a0,120(a5)
    80002882:	bfcd                	j	80002874 <argraw+0x2c>
    return p->trapframe->a2;
    80002884:	6d3c                	ld	a5,88(a0)
    80002886:	63c8                	ld	a0,128(a5)
    80002888:	b7f5                	j	80002874 <argraw+0x2c>
    return p->trapframe->a3;
    8000288a:	6d3c                	ld	a5,88(a0)
    8000288c:	67c8                	ld	a0,136(a5)
    8000288e:	b7dd                	j	80002874 <argraw+0x2c>
    return p->trapframe->a4;
    80002890:	6d3c                	ld	a5,88(a0)
    80002892:	6bc8                	ld	a0,144(a5)
    80002894:	b7c5                	j	80002874 <argraw+0x2c>
    return p->trapframe->a5;
    80002896:	6d3c                	ld	a5,88(a0)
    80002898:	6fc8                	ld	a0,152(a5)
    8000289a:	bfe9                	j	80002874 <argraw+0x2c>
  panic("argraw");
    8000289c:	00005517          	auipc	a0,0x5
    800028a0:	b6c50513          	addi	a0,a0,-1172 # 80007408 <etext+0x408>
    800028a4:	efffd0ef          	jal	800007a2 <panic>

00000000800028a8 <fetchaddr>:
{
    800028a8:	1101                	addi	sp,sp,-32
    800028aa:	ec06                	sd	ra,24(sp)
    800028ac:	e822                	sd	s0,16(sp)
    800028ae:	e426                	sd	s1,8(sp)
    800028b0:	e04a                	sd	s2,0(sp)
    800028b2:	1000                	addi	s0,sp,32
    800028b4:	84aa                	mv	s1,a0
    800028b6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800028b8:	848ff0ef          	jal	80001900 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800028bc:	653c                	ld	a5,72(a0)
    800028be:	02f4f663          	bgeu	s1,a5,800028ea <fetchaddr+0x42>
    800028c2:	00848713          	addi	a4,s1,8
    800028c6:	02e7e463          	bltu	a5,a4,800028ee <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800028ca:	46a1                	li	a3,8
    800028cc:	8626                	mv	a2,s1
    800028ce:	85ca                	mv	a1,s2
    800028d0:	6928                	ld	a0,80(a0)
    800028d2:	d77fe0ef          	jal	80001648 <copyin>
    800028d6:	00a03533          	snez	a0,a0
    800028da:	40a00533          	neg	a0,a0
}
    800028de:	60e2                	ld	ra,24(sp)
    800028e0:	6442                	ld	s0,16(sp)
    800028e2:	64a2                	ld	s1,8(sp)
    800028e4:	6902                	ld	s2,0(sp)
    800028e6:	6105                	addi	sp,sp,32
    800028e8:	8082                	ret
    return -1;
    800028ea:	557d                	li	a0,-1
    800028ec:	bfcd                	j	800028de <fetchaddr+0x36>
    800028ee:	557d                	li	a0,-1
    800028f0:	b7fd                	j	800028de <fetchaddr+0x36>

00000000800028f2 <fetchstr>:
{
    800028f2:	7179                	addi	sp,sp,-48
    800028f4:	f406                	sd	ra,40(sp)
    800028f6:	f022                	sd	s0,32(sp)
    800028f8:	ec26                	sd	s1,24(sp)
    800028fa:	e84a                	sd	s2,16(sp)
    800028fc:	e44e                	sd	s3,8(sp)
    800028fe:	1800                	addi	s0,sp,48
    80002900:	892a                	mv	s2,a0
    80002902:	84ae                	mv	s1,a1
    80002904:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002906:	ffbfe0ef          	jal	80001900 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000290a:	86ce                	mv	a3,s3
    8000290c:	864a                	mv	a2,s2
    8000290e:	85a6                	mv	a1,s1
    80002910:	6928                	ld	a0,80(a0)
    80002912:	dbdfe0ef          	jal	800016ce <copyinstr>
    80002916:	00054c63          	bltz	a0,8000292e <fetchstr+0x3c>
  return strlen(buf);
    8000291a:	8526                	mv	a0,s1
    8000291c:	d2afe0ef          	jal	80000e46 <strlen>
}
    80002920:	70a2                	ld	ra,40(sp)
    80002922:	7402                	ld	s0,32(sp)
    80002924:	64e2                	ld	s1,24(sp)
    80002926:	6942                	ld	s2,16(sp)
    80002928:	69a2                	ld	s3,8(sp)
    8000292a:	6145                	addi	sp,sp,48
    8000292c:	8082                	ret
    return -1;
    8000292e:	557d                	li	a0,-1
    80002930:	bfc5                	j	80002920 <fetchstr+0x2e>

0000000080002932 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002932:	1101                	addi	sp,sp,-32
    80002934:	ec06                	sd	ra,24(sp)
    80002936:	e822                	sd	s0,16(sp)
    80002938:	e426                	sd	s1,8(sp)
    8000293a:	1000                	addi	s0,sp,32
    8000293c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000293e:	f0bff0ef          	jal	80002848 <argraw>
    80002942:	c088                	sw	a0,0(s1)
}
    80002944:	60e2                	ld	ra,24(sp)
    80002946:	6442                	ld	s0,16(sp)
    80002948:	64a2                	ld	s1,8(sp)
    8000294a:	6105                	addi	sp,sp,32
    8000294c:	8082                	ret

000000008000294e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000294e:	1101                	addi	sp,sp,-32
    80002950:	ec06                	sd	ra,24(sp)
    80002952:	e822                	sd	s0,16(sp)
    80002954:	e426                	sd	s1,8(sp)
    80002956:	1000                	addi	s0,sp,32
    80002958:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000295a:	eefff0ef          	jal	80002848 <argraw>
    8000295e:	e088                	sd	a0,0(s1)
}
    80002960:	60e2                	ld	ra,24(sp)
    80002962:	6442                	ld	s0,16(sp)
    80002964:	64a2                	ld	s1,8(sp)
    80002966:	6105                	addi	sp,sp,32
    80002968:	8082                	ret

000000008000296a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000296a:	7179                	addi	sp,sp,-48
    8000296c:	f406                	sd	ra,40(sp)
    8000296e:	f022                	sd	s0,32(sp)
    80002970:	ec26                	sd	s1,24(sp)
    80002972:	e84a                	sd	s2,16(sp)
    80002974:	1800                	addi	s0,sp,48
    80002976:	84ae                	mv	s1,a1
    80002978:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000297a:	fd840593          	addi	a1,s0,-40
    8000297e:	fd1ff0ef          	jal	8000294e <argaddr>
  return fetchstr(addr, buf, max);
    80002982:	864a                	mv	a2,s2
    80002984:	85a6                	mv	a1,s1
    80002986:	fd843503          	ld	a0,-40(s0)
    8000298a:	f69ff0ef          	jal	800028f2 <fetchstr>
}
    8000298e:	70a2                	ld	ra,40(sp)
    80002990:	7402                	ld	s0,32(sp)
    80002992:	64e2                	ld	s1,24(sp)
    80002994:	6942                	ld	s2,16(sp)
    80002996:	6145                	addi	sp,sp,48
    80002998:	8082                	ret

000000008000299a <syscall>:

};

void
syscall(void)
{
    8000299a:	1101                	addi	sp,sp,-32
    8000299c:	ec06                	sd	ra,24(sp)
    8000299e:	e822                	sd	s0,16(sp)
    800029a0:	e426                	sd	s1,8(sp)
    800029a2:	e04a                	sd	s2,0(sp)
    800029a4:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800029a6:	f5bfe0ef          	jal	80001900 <myproc>
    800029aa:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800029ac:	05853903          	ld	s2,88(a0)
    800029b0:	0a893783          	ld	a5,168(s2)
    800029b4:	0007869b          	sext.w	a3,a5
  syscall_count++; 
    800029b8:	00008617          	auipc	a2,0x8
    800029bc:	a5860613          	addi	a2,a2,-1448 # 8000a410 <syscall_count>
    800029c0:	6218                	ld	a4,0(a2)
    800029c2:	0705                	addi	a4,a4,1
    800029c4:	e218                	sd	a4,0(a2)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800029c6:	37fd                	addiw	a5,a5,-1
    800029c8:	4769                	li	a4,26
    800029ca:	00f76f63          	bltu	a4,a5,800029e8 <syscall+0x4e>
    800029ce:	00369713          	slli	a4,a3,0x3
    800029d2:	00005797          	auipc	a5,0x5
    800029d6:	e0e78793          	addi	a5,a5,-498 # 800077e0 <syscalls>
    800029da:	97ba                	add	a5,a5,a4
    800029dc:	639c                	ld	a5,0(a5)
    800029de:	c789                	beqz	a5,800029e8 <syscall+0x4e>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800029e0:	9782                	jalr	a5
    800029e2:	06a93823          	sd	a0,112(s2)
    800029e6:	a829                	j	80002a00 <syscall+0x66>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800029e8:	15848613          	addi	a2,s1,344
    800029ec:	588c                	lw	a1,48(s1)
    800029ee:	00005517          	auipc	a0,0x5
    800029f2:	a2250513          	addi	a0,a0,-1502 # 80007410 <etext+0x410>
    800029f6:	adbfd0ef          	jal	800004d0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800029fa:	6cbc                	ld	a5,88(s1)
    800029fc:	577d                	li	a4,-1
    800029fe:	fbb8                	sd	a4,112(a5)
  }
    80002a00:	60e2                	ld	ra,24(sp)
    80002a02:	6442                	ld	s0,16(sp)
    80002a04:	64a2                	ld	s1,8(sp)
    80002a06:	6902                	ld	s2,0(sp)
    80002a08:	6105                	addi	sp,sp,32
    80002a0a:	8082                	ret

0000000080002a0c <sys_exit>:
#include "proc.h"
//#include "date.h"   

uint64
sys_exit(void)
{
    80002a0c:	1101                	addi	sp,sp,-32
    80002a0e:	ec06                	sd	ra,24(sp)
    80002a10:	e822                	sd	s0,16(sp)
    80002a12:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002a14:	fec40593          	addi	a1,s0,-20
    80002a18:	4501                	li	a0,0
    80002a1a:	f19ff0ef          	jal	80002932 <argint>
  exit(n);
    80002a1e:	fec42503          	lw	a0,-20(s0)
    80002a22:	f2cff0ef          	jal	8000214e <exit>
  return 0;  // not reached
}
    80002a26:	4501                	li	a0,0
    80002a28:	60e2                	ld	ra,24(sp)
    80002a2a:	6442                	ld	s0,16(sp)
    80002a2c:	6105                	addi	sp,sp,32
    80002a2e:	8082                	ret

0000000080002a30 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002a30:	1141                	addi	sp,sp,-16
    80002a32:	e406                	sd	ra,8(sp)
    80002a34:	e022                	sd	s0,0(sp)
    80002a36:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002a38:	ec9fe0ef          	jal	80001900 <myproc>
}
    80002a3c:	5908                	lw	a0,48(a0)
    80002a3e:	60a2                	ld	ra,8(sp)
    80002a40:	6402                	ld	s0,0(sp)
    80002a42:	0141                	addi	sp,sp,16
    80002a44:	8082                	ret

0000000080002a46 <sys_fork>:

uint64
sys_fork(void)
{
    80002a46:	1141                	addi	sp,sp,-16
    80002a48:	e406                	sd	ra,8(sp)
    80002a4a:	e022                	sd	s0,0(sp)
    80002a4c:	0800                	addi	s0,sp,16
  return fork();
    80002a4e:	ad8ff0ef          	jal	80001d26 <fork>
}
    80002a52:	60a2                	ld	ra,8(sp)
    80002a54:	6402                	ld	s0,0(sp)
    80002a56:	0141                	addi	sp,sp,16
    80002a58:	8082                	ret

0000000080002a5a <sys_wait>:

uint64
sys_wait(void)
{
    80002a5a:	1101                	addi	sp,sp,-32
    80002a5c:	ec06                	sd	ra,24(sp)
    80002a5e:	e822                	sd	s0,16(sp)
    80002a60:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002a62:	fe840593          	addi	a1,s0,-24
    80002a66:	4501                	li	a0,0
    80002a68:	ee7ff0ef          	jal	8000294e <argaddr>
  return wait(p);
    80002a6c:	fe843503          	ld	a0,-24(s0)
    80002a70:	835ff0ef          	jal	800022a4 <wait>
}
    80002a74:	60e2                	ld	ra,24(sp)
    80002a76:	6442                	ld	s0,16(sp)
    80002a78:	6105                	addi	sp,sp,32
    80002a7a:	8082                	ret

0000000080002a7c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002a7c:	7179                	addi	sp,sp,-48
    80002a7e:	f406                	sd	ra,40(sp)
    80002a80:	f022                	sd	s0,32(sp)
    80002a82:	ec26                	sd	s1,24(sp)
    80002a84:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002a86:	fdc40593          	addi	a1,s0,-36
    80002a8a:	4501                	li	a0,0
    80002a8c:	ea7ff0ef          	jal	80002932 <argint>
  addr = myproc()->sz;
    80002a90:	e71fe0ef          	jal	80001900 <myproc>
    80002a94:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002a96:	fdc42503          	lw	a0,-36(s0)
    80002a9a:	a3cff0ef          	jal	80001cd6 <growproc>
    80002a9e:	00054863          	bltz	a0,80002aae <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002aa2:	8526                	mv	a0,s1
    80002aa4:	70a2                	ld	ra,40(sp)
    80002aa6:	7402                	ld	s0,32(sp)
    80002aa8:	64e2                	ld	s1,24(sp)
    80002aaa:	6145                	addi	sp,sp,48
    80002aac:	8082                	ret
    return -1;
    80002aae:	54fd                	li	s1,-1
    80002ab0:	bfcd                	j	80002aa2 <sys_sbrk+0x26>

0000000080002ab2 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002ab2:	7139                	addi	sp,sp,-64
    80002ab4:	fc06                	sd	ra,56(sp)
    80002ab6:	f822                	sd	s0,48(sp)
    80002ab8:	f04a                	sd	s2,32(sp)
    80002aba:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002abc:	fcc40593          	addi	a1,s0,-52
    80002ac0:	4501                	li	a0,0
    80002ac2:	e71ff0ef          	jal	80002932 <argint>
  if(n < 0)
    80002ac6:	fcc42783          	lw	a5,-52(s0)
    80002aca:	0607c763          	bltz	a5,80002b38 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002ace:	00016517          	auipc	a0,0x16
    80002ad2:	aa250513          	addi	a0,a0,-1374 # 80018570 <tickslock>
    80002ad6:	92cfe0ef          	jal	80000c02 <acquire>
  ticks0 = ticks;
    80002ada:	00008917          	auipc	s2,0x8
    80002ade:	92e92903          	lw	s2,-1746(s2) # 8000a408 <ticks>
  while(ticks - ticks0 < n){
    80002ae2:	fcc42783          	lw	a5,-52(s0)
    80002ae6:	cf8d                	beqz	a5,80002b20 <sys_sleep+0x6e>
    80002ae8:	f426                	sd	s1,40(sp)
    80002aea:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002aec:	00016997          	auipc	s3,0x16
    80002af0:	a8498993          	addi	s3,s3,-1404 # 80018570 <tickslock>
    80002af4:	00008497          	auipc	s1,0x8
    80002af8:	91448493          	addi	s1,s1,-1772 # 8000a408 <ticks>
    if(killed(myproc())){
    80002afc:	e05fe0ef          	jal	80001900 <myproc>
    80002b00:	f7aff0ef          	jal	8000227a <killed>
    80002b04:	ed0d                	bnez	a0,80002b3e <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002b06:	85ce                	mv	a1,s3
    80002b08:	8526                	mv	a0,s1
    80002b0a:	d38ff0ef          	jal	80002042 <sleep>
  while(ticks - ticks0 < n){
    80002b0e:	409c                	lw	a5,0(s1)
    80002b10:	412787bb          	subw	a5,a5,s2
    80002b14:	fcc42703          	lw	a4,-52(s0)
    80002b18:	fee7e2e3          	bltu	a5,a4,80002afc <sys_sleep+0x4a>
    80002b1c:	74a2                	ld	s1,40(sp)
    80002b1e:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002b20:	00016517          	auipc	a0,0x16
    80002b24:	a5050513          	addi	a0,a0,-1456 # 80018570 <tickslock>
    80002b28:	972fe0ef          	jal	80000c9a <release>
  return 0;
    80002b2c:	4501                	li	a0,0
}
    80002b2e:	70e2                	ld	ra,56(sp)
    80002b30:	7442                	ld	s0,48(sp)
    80002b32:	7902                	ld	s2,32(sp)
    80002b34:	6121                	addi	sp,sp,64
    80002b36:	8082                	ret
    n = 0;
    80002b38:	fc042623          	sw	zero,-52(s0)
    80002b3c:	bf49                	j	80002ace <sys_sleep+0x1c>
      release(&tickslock);
    80002b3e:	00016517          	auipc	a0,0x16
    80002b42:	a3250513          	addi	a0,a0,-1486 # 80018570 <tickslock>
    80002b46:	954fe0ef          	jal	80000c9a <release>
      return -1;
    80002b4a:	557d                	li	a0,-1
    80002b4c:	74a2                	ld	s1,40(sp)
    80002b4e:	69e2                	ld	s3,24(sp)
    80002b50:	bff9                	j	80002b2e <sys_sleep+0x7c>

0000000080002b52 <sys_kill>:

uint64
sys_kill(void)
{
    80002b52:	1101                	addi	sp,sp,-32
    80002b54:	ec06                	sd	ra,24(sp)
    80002b56:	e822                	sd	s0,16(sp)
    80002b58:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002b5a:	fec40593          	addi	a1,s0,-20
    80002b5e:	4501                	li	a0,0
    80002b60:	dd3ff0ef          	jal	80002932 <argint>
  return kill(pid);
    80002b64:	fec42503          	lw	a0,-20(s0)
    80002b68:	e88ff0ef          	jal	800021f0 <kill>
}
    80002b6c:	60e2                	ld	ra,24(sp)
    80002b6e:	6442                	ld	s0,16(sp)
    80002b70:	6105                	addi	sp,sp,32
    80002b72:	8082                	ret

0000000080002b74 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002b74:	1101                	addi	sp,sp,-32
    80002b76:	ec06                	sd	ra,24(sp)
    80002b78:	e822                	sd	s0,16(sp)
    80002b7a:	e426                	sd	s1,8(sp)
    80002b7c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002b7e:	00016517          	auipc	a0,0x16
    80002b82:	9f250513          	addi	a0,a0,-1550 # 80018570 <tickslock>
    80002b86:	87cfe0ef          	jal	80000c02 <acquire>
  xticks = ticks;
    80002b8a:	00008497          	auipc	s1,0x8
    80002b8e:	87e4a483          	lw	s1,-1922(s1) # 8000a408 <ticks>
  release(&tickslock);
    80002b92:	00016517          	auipc	a0,0x16
    80002b96:	9de50513          	addi	a0,a0,-1570 # 80018570 <tickslock>
    80002b9a:	900fe0ef          	jal	80000c9a <release>
  return xticks;
}
    80002b9e:	02049513          	slli	a0,s1,0x20
    80002ba2:	9101                	srli	a0,a0,0x20
    80002ba4:	60e2                	ld	ra,24(sp)
    80002ba6:	6442                	ld	s0,16(sp)
    80002ba8:	64a2                	ld	s1,8(sp)
    80002baa:	6105                	addi	sp,sp,32
    80002bac:	8082                	ret

0000000080002bae <sys_countsyscall>:
uint64 syscall_count = 0;
uint64
sys_countsyscall(void)
{
    80002bae:	1141                	addi	sp,sp,-16
    80002bb0:	e422                	sd	s0,8(sp)
    80002bb2:	0800                	addi	s0,sp,16
  return syscall_count;
}
    80002bb4:	00008517          	auipc	a0,0x8
    80002bb8:	85c53503          	ld	a0,-1956(a0) # 8000a410 <syscall_count>
    80002bbc:	6422                	ld	s0,8(sp)
    80002bbe:	0141                	addi	sp,sp,16
    80002bc0:	8082                	ret

0000000080002bc2 <sys_getppid>:
uint64
sys_getppid(void)
{
    80002bc2:	1141                	addi	sp,sp,-16
    80002bc4:	e406                	sd	ra,8(sp)
    80002bc6:	e022                	sd	s0,0(sp)
    80002bc8:	0800                	addi	s0,sp,16
  return myproc()->parent->pid;
    80002bca:	d37fe0ef          	jal	80001900 <myproc>
    80002bce:	7d1c                	ld	a5,56(a0)
}
    80002bd0:	5b88                	lw	a0,48(a5)
    80002bd2:	60a2                	ld	ra,8(sp)
    80002bd4:	6402                	ld	s0,0(sp)
    80002bd6:	0141                	addi	sp,sp,16
    80002bd8:	8082                	ret

0000000080002bda <sys_shutdown>:
uint64
sys_shutdown(void)
{
    80002bda:	1141                	addi	sp,sp,-16
    80002bdc:	e406                	sd	ra,8(sp)
    80002bde:	e022                	sd	s0,0(sp)
    80002be0:	0800                	addi	s0,sp,16
  printf("shutting down \n");
    80002be2:	00005517          	auipc	a0,0x5
    80002be6:	84e50513          	addi	a0,a0,-1970 # 80007430 <etext+0x430>
    80002bea:	8e7fd0ef          	jal	800004d0 <printf>
  volatile uint32 *shutdown_reg=(uint32 *)0x100000;
  *shutdown_reg=0x5555;
    80002bee:	6795                	lui	a5,0x5
    80002bf0:	55578793          	addi	a5,a5,1365 # 5555 <_entry-0x7fffaaab>
    80002bf4:	00100737          	lui	a4,0x100
    80002bf8:	c31c                	sw	a5,0(a4)
  return 0;
}
    80002bfa:	4501                	li	a0,0
    80002bfc:	60a2                	ld	ra,8(sp)
    80002bfe:	6402                	ld	s0,0(sp)
    80002c00:	0141                	addi	sp,sp,16
    80002c02:	8082                	ret

0000000080002c04 <sys_rand>:
// Simple kernel PRNG using LCG
static unsigned int lcg_state = 1;

uint64
sys_rand(void)
{
    80002c04:	1141                	addi	sp,sp,-16
    80002c06:	e422                	sd	s0,8(sp)
    80002c08:	0800                	addi	s0,sp,16
  // Seed only once using ticks (global variable provided by xv6)
  extern uint ticks;
  if (lcg_state == 1)
    80002c0a:	00007717          	auipc	a4,0x7
    80002c0e:	75e72703          	lw	a4,1886(a4) # 8000a368 <lcg_state>
    80002c12:	4785                	li	a5,1
    80002c14:	02f70763          	beq	a4,a5,80002c42 <sys_rand+0x3e>
    lcg_state = ticks + 1;  // avoid 0 seed

  // LCG formula
  lcg_state = (1103515245 * lcg_state + 12345) & 0x7fffffff;
    80002c18:	00007717          	auipc	a4,0x7
    80002c1c:	75070713          	addi	a4,a4,1872 # 8000a368 <lcg_state>
    80002c20:	4314                	lw	a3,0(a4)
    80002c22:	41c657b7          	lui	a5,0x41c65
    80002c26:	e6d7879b          	addiw	a5,a5,-403 # 41c64e6d <_entry-0x3e39b193>
    80002c2a:	02d7853b          	mulw	a0,a5,a3
    80002c2e:	678d                	lui	a5,0x3
    80002c30:	0397879b          	addiw	a5,a5,57 # 3039 <_entry-0x7fffcfc7>
    80002c34:	9d3d                	addw	a0,a0,a5
    80002c36:	1506                	slli	a0,a0,0x21
    80002c38:	9105                	srli	a0,a0,0x21
    80002c3a:	c308                	sw	a0,0(a4)

  return lcg_state;
}
    80002c3c:	6422                	ld	s0,8(sp)
    80002c3e:	0141                	addi	sp,sp,16
    80002c40:	8082                	ret
    lcg_state = ticks + 1;  // avoid 0 seed
    80002c42:	00007797          	auipc	a5,0x7
    80002c46:	7c67a783          	lw	a5,1990(a5) # 8000a408 <ticks>
    80002c4a:	2785                	addiw	a5,a5,1
    80002c4c:	00007717          	auipc	a4,0x7
    80002c50:	70f72e23          	sw	a5,1820(a4) # 8000a368 <lcg_state>
    80002c54:	b7d1                	j	80002c18 <sys_rand+0x14>

0000000080002c56 <sys_getptable>:

uint64
sys_getptable(void)
{
    80002c56:	1101                	addi	sp,sp,-32
    80002c58:	ec06                	sd	ra,24(sp)
    80002c5a:	e822                	sd	s0,16(sp)
    80002c5c:	1000                	addi	s0,sp,32
  int nproc;
  uint64 buffer;
  
  argint(0, &nproc);
    80002c5e:	fec40593          	addi	a1,s0,-20
    80002c62:	4501                	li	a0,0
    80002c64:	ccfff0ef          	jal	80002932 <argint>
  argaddr(1, &buffer);
    80002c68:	fe040593          	addi	a1,s0,-32
    80002c6c:	4505                	li	a0,1
    80002c6e:	ce1ff0ef          	jal	8000294e <argaddr>
  
  return getptable(nproc, buffer);
    80002c72:	fe043583          	ld	a1,-32(s0)
    80002c76:	fec42503          	lw	a0,-20(s0)
    80002c7a:	cb7fe0ef          	jal	80001930 <getptable>
}
    80002c7e:	60e2                	ld	ra,24(sp)
    80002c80:	6442                	ld	s0,16(sp)
    80002c82:	6105                	addi	sp,sp,32
    80002c84:	8082                	ret

0000000080002c86 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002c86:	7179                	addi	sp,sp,-48
    80002c88:	f406                	sd	ra,40(sp)
    80002c8a:	f022                	sd	s0,32(sp)
    80002c8c:	ec26                	sd	s1,24(sp)
    80002c8e:	e84a                	sd	s2,16(sp)
    80002c90:	e44e                	sd	s3,8(sp)
    80002c92:	e052                	sd	s4,0(sp)
    80002c94:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002c96:	00004597          	auipc	a1,0x4
    80002c9a:	7aa58593          	addi	a1,a1,1962 # 80007440 <etext+0x440>
    80002c9e:	00016517          	auipc	a0,0x16
    80002ca2:	8ea50513          	addi	a0,a0,-1814 # 80018588 <bcache>
    80002ca6:	eddfd0ef          	jal	80000b82 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002caa:	0001e797          	auipc	a5,0x1e
    80002cae:	8de78793          	addi	a5,a5,-1826 # 80020588 <bcache+0x8000>
    80002cb2:	0001e717          	auipc	a4,0x1e
    80002cb6:	b3e70713          	addi	a4,a4,-1218 # 800207f0 <bcache+0x8268>
    80002cba:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002cbe:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002cc2:	00016497          	auipc	s1,0x16
    80002cc6:	8de48493          	addi	s1,s1,-1826 # 800185a0 <bcache+0x18>
    b->next = bcache.head.next;
    80002cca:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002ccc:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002cce:	00004a17          	auipc	s4,0x4
    80002cd2:	77aa0a13          	addi	s4,s4,1914 # 80007448 <etext+0x448>
    b->next = bcache.head.next;
    80002cd6:	2b893783          	ld	a5,696(s2)
    80002cda:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002cdc:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002ce0:	85d2                	mv	a1,s4
    80002ce2:	01048513          	addi	a0,s1,16
    80002ce6:	248010ef          	jal	80003f2e <initsleeplock>
    bcache.head.next->prev = b;
    80002cea:	2b893783          	ld	a5,696(s2)
    80002cee:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002cf0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002cf4:	45848493          	addi	s1,s1,1112
    80002cf8:	fd349fe3          	bne	s1,s3,80002cd6 <binit+0x50>
  }
}
    80002cfc:	70a2                	ld	ra,40(sp)
    80002cfe:	7402                	ld	s0,32(sp)
    80002d00:	64e2                	ld	s1,24(sp)
    80002d02:	6942                	ld	s2,16(sp)
    80002d04:	69a2                	ld	s3,8(sp)
    80002d06:	6a02                	ld	s4,0(sp)
    80002d08:	6145                	addi	sp,sp,48
    80002d0a:	8082                	ret

0000000080002d0c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002d0c:	7179                	addi	sp,sp,-48
    80002d0e:	f406                	sd	ra,40(sp)
    80002d10:	f022                	sd	s0,32(sp)
    80002d12:	ec26                	sd	s1,24(sp)
    80002d14:	e84a                	sd	s2,16(sp)
    80002d16:	e44e                	sd	s3,8(sp)
    80002d18:	1800                	addi	s0,sp,48
    80002d1a:	892a                	mv	s2,a0
    80002d1c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002d1e:	00016517          	auipc	a0,0x16
    80002d22:	86a50513          	addi	a0,a0,-1942 # 80018588 <bcache>
    80002d26:	eddfd0ef          	jal	80000c02 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002d2a:	0001e497          	auipc	s1,0x1e
    80002d2e:	b164b483          	ld	s1,-1258(s1) # 80020840 <bcache+0x82b8>
    80002d32:	0001e797          	auipc	a5,0x1e
    80002d36:	abe78793          	addi	a5,a5,-1346 # 800207f0 <bcache+0x8268>
    80002d3a:	02f48b63          	beq	s1,a5,80002d70 <bread+0x64>
    80002d3e:	873e                	mv	a4,a5
    80002d40:	a021                	j	80002d48 <bread+0x3c>
    80002d42:	68a4                	ld	s1,80(s1)
    80002d44:	02e48663          	beq	s1,a4,80002d70 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002d48:	449c                	lw	a5,8(s1)
    80002d4a:	ff279ce3          	bne	a5,s2,80002d42 <bread+0x36>
    80002d4e:	44dc                	lw	a5,12(s1)
    80002d50:	ff3799e3          	bne	a5,s3,80002d42 <bread+0x36>
      b->refcnt++;
    80002d54:	40bc                	lw	a5,64(s1)
    80002d56:	2785                	addiw	a5,a5,1
    80002d58:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d5a:	00016517          	auipc	a0,0x16
    80002d5e:	82e50513          	addi	a0,a0,-2002 # 80018588 <bcache>
    80002d62:	f39fd0ef          	jal	80000c9a <release>
      acquiresleep(&b->lock);
    80002d66:	01048513          	addi	a0,s1,16
    80002d6a:	1fa010ef          	jal	80003f64 <acquiresleep>
      return b;
    80002d6e:	a889                	j	80002dc0 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002d70:	0001e497          	auipc	s1,0x1e
    80002d74:	ac84b483          	ld	s1,-1336(s1) # 80020838 <bcache+0x82b0>
    80002d78:	0001e797          	auipc	a5,0x1e
    80002d7c:	a7878793          	addi	a5,a5,-1416 # 800207f0 <bcache+0x8268>
    80002d80:	00f48863          	beq	s1,a5,80002d90 <bread+0x84>
    80002d84:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002d86:	40bc                	lw	a5,64(s1)
    80002d88:	cb91                	beqz	a5,80002d9c <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002d8a:	64a4                	ld	s1,72(s1)
    80002d8c:	fee49de3          	bne	s1,a4,80002d86 <bread+0x7a>
  panic("bget: no buffers");
    80002d90:	00004517          	auipc	a0,0x4
    80002d94:	6c050513          	addi	a0,a0,1728 # 80007450 <etext+0x450>
    80002d98:	a0bfd0ef          	jal	800007a2 <panic>
      b->dev = dev;
    80002d9c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002da0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002da4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002da8:	4785                	li	a5,1
    80002daa:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002dac:	00015517          	auipc	a0,0x15
    80002db0:	7dc50513          	addi	a0,a0,2012 # 80018588 <bcache>
    80002db4:	ee7fd0ef          	jal	80000c9a <release>
      acquiresleep(&b->lock);
    80002db8:	01048513          	addi	a0,s1,16
    80002dbc:	1a8010ef          	jal	80003f64 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002dc0:	409c                	lw	a5,0(s1)
    80002dc2:	cb89                	beqz	a5,80002dd4 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002dc4:	8526                	mv	a0,s1
    80002dc6:	70a2                	ld	ra,40(sp)
    80002dc8:	7402                	ld	s0,32(sp)
    80002dca:	64e2                	ld	s1,24(sp)
    80002dcc:	6942                	ld	s2,16(sp)
    80002dce:	69a2                	ld	s3,8(sp)
    80002dd0:	6145                	addi	sp,sp,48
    80002dd2:	8082                	ret
    virtio_disk_rw(b, 0);
    80002dd4:	4581                	li	a1,0
    80002dd6:	8526                	mv	a0,s1
    80002dd8:	1e9020ef          	jal	800057c0 <virtio_disk_rw>
    b->valid = 1;
    80002ddc:	4785                	li	a5,1
    80002dde:	c09c                	sw	a5,0(s1)
  return b;
    80002de0:	b7d5                	j	80002dc4 <bread+0xb8>

0000000080002de2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002de2:	1101                	addi	sp,sp,-32
    80002de4:	ec06                	sd	ra,24(sp)
    80002de6:	e822                	sd	s0,16(sp)
    80002de8:	e426                	sd	s1,8(sp)
    80002dea:	1000                	addi	s0,sp,32
    80002dec:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002dee:	0541                	addi	a0,a0,16
    80002df0:	1f2010ef          	jal	80003fe2 <holdingsleep>
    80002df4:	c911                	beqz	a0,80002e08 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002df6:	4585                	li	a1,1
    80002df8:	8526                	mv	a0,s1
    80002dfa:	1c7020ef          	jal	800057c0 <virtio_disk_rw>
}
    80002dfe:	60e2                	ld	ra,24(sp)
    80002e00:	6442                	ld	s0,16(sp)
    80002e02:	64a2                	ld	s1,8(sp)
    80002e04:	6105                	addi	sp,sp,32
    80002e06:	8082                	ret
    panic("bwrite");
    80002e08:	00004517          	auipc	a0,0x4
    80002e0c:	66050513          	addi	a0,a0,1632 # 80007468 <etext+0x468>
    80002e10:	993fd0ef          	jal	800007a2 <panic>

0000000080002e14 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002e14:	1101                	addi	sp,sp,-32
    80002e16:	ec06                	sd	ra,24(sp)
    80002e18:	e822                	sd	s0,16(sp)
    80002e1a:	e426                	sd	s1,8(sp)
    80002e1c:	e04a                	sd	s2,0(sp)
    80002e1e:	1000                	addi	s0,sp,32
    80002e20:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002e22:	01050913          	addi	s2,a0,16
    80002e26:	854a                	mv	a0,s2
    80002e28:	1ba010ef          	jal	80003fe2 <holdingsleep>
    80002e2c:	c135                	beqz	a0,80002e90 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002e2e:	854a                	mv	a0,s2
    80002e30:	17a010ef          	jal	80003faa <releasesleep>

  acquire(&bcache.lock);
    80002e34:	00015517          	auipc	a0,0x15
    80002e38:	75450513          	addi	a0,a0,1876 # 80018588 <bcache>
    80002e3c:	dc7fd0ef          	jal	80000c02 <acquire>
  b->refcnt--;
    80002e40:	40bc                	lw	a5,64(s1)
    80002e42:	37fd                	addiw	a5,a5,-1
    80002e44:	0007871b          	sext.w	a4,a5
    80002e48:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002e4a:	e71d                	bnez	a4,80002e78 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002e4c:	68b8                	ld	a4,80(s1)
    80002e4e:	64bc                	ld	a5,72(s1)
    80002e50:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002e52:	68b8                	ld	a4,80(s1)
    80002e54:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002e56:	0001d797          	auipc	a5,0x1d
    80002e5a:	73278793          	addi	a5,a5,1842 # 80020588 <bcache+0x8000>
    80002e5e:	2b87b703          	ld	a4,696(a5)
    80002e62:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002e64:	0001e717          	auipc	a4,0x1e
    80002e68:	98c70713          	addi	a4,a4,-1652 # 800207f0 <bcache+0x8268>
    80002e6c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002e6e:	2b87b703          	ld	a4,696(a5)
    80002e72:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002e74:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002e78:	00015517          	auipc	a0,0x15
    80002e7c:	71050513          	addi	a0,a0,1808 # 80018588 <bcache>
    80002e80:	e1bfd0ef          	jal	80000c9a <release>
}
    80002e84:	60e2                	ld	ra,24(sp)
    80002e86:	6442                	ld	s0,16(sp)
    80002e88:	64a2                	ld	s1,8(sp)
    80002e8a:	6902                	ld	s2,0(sp)
    80002e8c:	6105                	addi	sp,sp,32
    80002e8e:	8082                	ret
    panic("brelse");
    80002e90:	00004517          	auipc	a0,0x4
    80002e94:	5e050513          	addi	a0,a0,1504 # 80007470 <etext+0x470>
    80002e98:	90bfd0ef          	jal	800007a2 <panic>

0000000080002e9c <bpin>:

void
bpin(struct buf *b) {
    80002e9c:	1101                	addi	sp,sp,-32
    80002e9e:	ec06                	sd	ra,24(sp)
    80002ea0:	e822                	sd	s0,16(sp)
    80002ea2:	e426                	sd	s1,8(sp)
    80002ea4:	1000                	addi	s0,sp,32
    80002ea6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002ea8:	00015517          	auipc	a0,0x15
    80002eac:	6e050513          	addi	a0,a0,1760 # 80018588 <bcache>
    80002eb0:	d53fd0ef          	jal	80000c02 <acquire>
  b->refcnt++;
    80002eb4:	40bc                	lw	a5,64(s1)
    80002eb6:	2785                	addiw	a5,a5,1
    80002eb8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002eba:	00015517          	auipc	a0,0x15
    80002ebe:	6ce50513          	addi	a0,a0,1742 # 80018588 <bcache>
    80002ec2:	dd9fd0ef          	jal	80000c9a <release>
}
    80002ec6:	60e2                	ld	ra,24(sp)
    80002ec8:	6442                	ld	s0,16(sp)
    80002eca:	64a2                	ld	s1,8(sp)
    80002ecc:	6105                	addi	sp,sp,32
    80002ece:	8082                	ret

0000000080002ed0 <bunpin>:

void
bunpin(struct buf *b) {
    80002ed0:	1101                	addi	sp,sp,-32
    80002ed2:	ec06                	sd	ra,24(sp)
    80002ed4:	e822                	sd	s0,16(sp)
    80002ed6:	e426                	sd	s1,8(sp)
    80002ed8:	1000                	addi	s0,sp,32
    80002eda:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002edc:	00015517          	auipc	a0,0x15
    80002ee0:	6ac50513          	addi	a0,a0,1708 # 80018588 <bcache>
    80002ee4:	d1ffd0ef          	jal	80000c02 <acquire>
  b->refcnt--;
    80002ee8:	40bc                	lw	a5,64(s1)
    80002eea:	37fd                	addiw	a5,a5,-1
    80002eec:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002eee:	00015517          	auipc	a0,0x15
    80002ef2:	69a50513          	addi	a0,a0,1690 # 80018588 <bcache>
    80002ef6:	da5fd0ef          	jal	80000c9a <release>
}
    80002efa:	60e2                	ld	ra,24(sp)
    80002efc:	6442                	ld	s0,16(sp)
    80002efe:	64a2                	ld	s1,8(sp)
    80002f00:	6105                	addi	sp,sp,32
    80002f02:	8082                	ret

0000000080002f04 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002f04:	1101                	addi	sp,sp,-32
    80002f06:	ec06                	sd	ra,24(sp)
    80002f08:	e822                	sd	s0,16(sp)
    80002f0a:	e426                	sd	s1,8(sp)
    80002f0c:	e04a                	sd	s2,0(sp)
    80002f0e:	1000                	addi	s0,sp,32
    80002f10:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002f12:	00d5d59b          	srliw	a1,a1,0xd
    80002f16:	0001e797          	auipc	a5,0x1e
    80002f1a:	d4e7a783          	lw	a5,-690(a5) # 80020c64 <sb+0x1c>
    80002f1e:	9dbd                	addw	a1,a1,a5
    80002f20:	dedff0ef          	jal	80002d0c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002f24:	0074f713          	andi	a4,s1,7
    80002f28:	4785                	li	a5,1
    80002f2a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002f2e:	14ce                	slli	s1,s1,0x33
    80002f30:	90d9                	srli	s1,s1,0x36
    80002f32:	00950733          	add	a4,a0,s1
    80002f36:	05874703          	lbu	a4,88(a4)
    80002f3a:	00e7f6b3          	and	a3,a5,a4
    80002f3e:	c29d                	beqz	a3,80002f64 <bfree+0x60>
    80002f40:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002f42:	94aa                	add	s1,s1,a0
    80002f44:	fff7c793          	not	a5,a5
    80002f48:	8f7d                	and	a4,a4,a5
    80002f4a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002f4e:	711000ef          	jal	80003e5e <log_write>
  brelse(bp);
    80002f52:	854a                	mv	a0,s2
    80002f54:	ec1ff0ef          	jal	80002e14 <brelse>
}
    80002f58:	60e2                	ld	ra,24(sp)
    80002f5a:	6442                	ld	s0,16(sp)
    80002f5c:	64a2                	ld	s1,8(sp)
    80002f5e:	6902                	ld	s2,0(sp)
    80002f60:	6105                	addi	sp,sp,32
    80002f62:	8082                	ret
    panic("freeing free block");
    80002f64:	00004517          	auipc	a0,0x4
    80002f68:	51450513          	addi	a0,a0,1300 # 80007478 <etext+0x478>
    80002f6c:	837fd0ef          	jal	800007a2 <panic>

0000000080002f70 <balloc>:
{
    80002f70:	711d                	addi	sp,sp,-96
    80002f72:	ec86                	sd	ra,88(sp)
    80002f74:	e8a2                	sd	s0,80(sp)
    80002f76:	e4a6                	sd	s1,72(sp)
    80002f78:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002f7a:	0001e797          	auipc	a5,0x1e
    80002f7e:	cd27a783          	lw	a5,-814(a5) # 80020c4c <sb+0x4>
    80002f82:	0e078f63          	beqz	a5,80003080 <balloc+0x110>
    80002f86:	e0ca                	sd	s2,64(sp)
    80002f88:	fc4e                	sd	s3,56(sp)
    80002f8a:	f852                	sd	s4,48(sp)
    80002f8c:	f456                	sd	s5,40(sp)
    80002f8e:	f05a                	sd	s6,32(sp)
    80002f90:	ec5e                	sd	s7,24(sp)
    80002f92:	e862                	sd	s8,16(sp)
    80002f94:	e466                	sd	s9,8(sp)
    80002f96:	8baa                	mv	s7,a0
    80002f98:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002f9a:	0001eb17          	auipc	s6,0x1e
    80002f9e:	caeb0b13          	addi	s6,s6,-850 # 80020c48 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002fa2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002fa4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002fa6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002fa8:	6c89                	lui	s9,0x2
    80002faa:	a0b5                	j	80003016 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002fac:	97ca                	add	a5,a5,s2
    80002fae:	8e55                	or	a2,a2,a3
    80002fb0:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002fb4:	854a                	mv	a0,s2
    80002fb6:	6a9000ef          	jal	80003e5e <log_write>
        brelse(bp);
    80002fba:	854a                	mv	a0,s2
    80002fbc:	e59ff0ef          	jal	80002e14 <brelse>
  bp = bread(dev, bno);
    80002fc0:	85a6                	mv	a1,s1
    80002fc2:	855e                	mv	a0,s7
    80002fc4:	d49ff0ef          	jal	80002d0c <bread>
    80002fc8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002fca:	40000613          	li	a2,1024
    80002fce:	4581                	li	a1,0
    80002fd0:	05850513          	addi	a0,a0,88
    80002fd4:	d03fd0ef          	jal	80000cd6 <memset>
  log_write(bp);
    80002fd8:	854a                	mv	a0,s2
    80002fda:	685000ef          	jal	80003e5e <log_write>
  brelse(bp);
    80002fde:	854a                	mv	a0,s2
    80002fe0:	e35ff0ef          	jal	80002e14 <brelse>
}
    80002fe4:	6906                	ld	s2,64(sp)
    80002fe6:	79e2                	ld	s3,56(sp)
    80002fe8:	7a42                	ld	s4,48(sp)
    80002fea:	7aa2                	ld	s5,40(sp)
    80002fec:	7b02                	ld	s6,32(sp)
    80002fee:	6be2                	ld	s7,24(sp)
    80002ff0:	6c42                	ld	s8,16(sp)
    80002ff2:	6ca2                	ld	s9,8(sp)
}
    80002ff4:	8526                	mv	a0,s1
    80002ff6:	60e6                	ld	ra,88(sp)
    80002ff8:	6446                	ld	s0,80(sp)
    80002ffa:	64a6                	ld	s1,72(sp)
    80002ffc:	6125                	addi	sp,sp,96
    80002ffe:	8082                	ret
    brelse(bp);
    80003000:	854a                	mv	a0,s2
    80003002:	e13ff0ef          	jal	80002e14 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003006:	015c87bb          	addw	a5,s9,s5
    8000300a:	00078a9b          	sext.w	s5,a5
    8000300e:	004b2703          	lw	a4,4(s6)
    80003012:	04eaff63          	bgeu	s5,a4,80003070 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80003016:	41fad79b          	sraiw	a5,s5,0x1f
    8000301a:	0137d79b          	srliw	a5,a5,0x13
    8000301e:	015787bb          	addw	a5,a5,s5
    80003022:	40d7d79b          	sraiw	a5,a5,0xd
    80003026:	01cb2583          	lw	a1,28(s6)
    8000302a:	9dbd                	addw	a1,a1,a5
    8000302c:	855e                	mv	a0,s7
    8000302e:	cdfff0ef          	jal	80002d0c <bread>
    80003032:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003034:	004b2503          	lw	a0,4(s6)
    80003038:	000a849b          	sext.w	s1,s5
    8000303c:	8762                	mv	a4,s8
    8000303e:	fca4f1e3          	bgeu	s1,a0,80003000 <balloc+0x90>
      m = 1 << (bi % 8);
    80003042:	00777693          	andi	a3,a4,7
    80003046:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000304a:	41f7579b          	sraiw	a5,a4,0x1f
    8000304e:	01d7d79b          	srliw	a5,a5,0x1d
    80003052:	9fb9                	addw	a5,a5,a4
    80003054:	4037d79b          	sraiw	a5,a5,0x3
    80003058:	00f90633          	add	a2,s2,a5
    8000305c:	05864603          	lbu	a2,88(a2)
    80003060:	00c6f5b3          	and	a1,a3,a2
    80003064:	d5a1                	beqz	a1,80002fac <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003066:	2705                	addiw	a4,a4,1
    80003068:	2485                	addiw	s1,s1,1
    8000306a:	fd471ae3          	bne	a4,s4,8000303e <balloc+0xce>
    8000306e:	bf49                	j	80003000 <balloc+0x90>
    80003070:	6906                	ld	s2,64(sp)
    80003072:	79e2                	ld	s3,56(sp)
    80003074:	7a42                	ld	s4,48(sp)
    80003076:	7aa2                	ld	s5,40(sp)
    80003078:	7b02                	ld	s6,32(sp)
    8000307a:	6be2                	ld	s7,24(sp)
    8000307c:	6c42                	ld	s8,16(sp)
    8000307e:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80003080:	00004517          	auipc	a0,0x4
    80003084:	41050513          	addi	a0,a0,1040 # 80007490 <etext+0x490>
    80003088:	c48fd0ef          	jal	800004d0 <printf>
  return 0;
    8000308c:	4481                	li	s1,0
    8000308e:	b79d                	j	80002ff4 <balloc+0x84>

0000000080003090 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003090:	7179                	addi	sp,sp,-48
    80003092:	f406                	sd	ra,40(sp)
    80003094:	f022                	sd	s0,32(sp)
    80003096:	ec26                	sd	s1,24(sp)
    80003098:	e84a                	sd	s2,16(sp)
    8000309a:	e44e                	sd	s3,8(sp)
    8000309c:	1800                	addi	s0,sp,48
    8000309e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800030a0:	47ad                	li	a5,11
    800030a2:	02b7e663          	bltu	a5,a1,800030ce <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800030a6:	02059793          	slli	a5,a1,0x20
    800030aa:	01e7d593          	srli	a1,a5,0x1e
    800030ae:	00b504b3          	add	s1,a0,a1
    800030b2:	0504a903          	lw	s2,80(s1)
    800030b6:	06091a63          	bnez	s2,8000312a <bmap+0x9a>
      addr = balloc(ip->dev);
    800030ba:	4108                	lw	a0,0(a0)
    800030bc:	eb5ff0ef          	jal	80002f70 <balloc>
    800030c0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800030c4:	06090363          	beqz	s2,8000312a <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800030c8:	0524a823          	sw	s2,80(s1)
    800030cc:	a8b9                	j	8000312a <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800030ce:	ff45849b          	addiw	s1,a1,-12
    800030d2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800030d6:	0ff00793          	li	a5,255
    800030da:	06e7ee63          	bltu	a5,a4,80003156 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800030de:	08052903          	lw	s2,128(a0)
    800030e2:	00091d63          	bnez	s2,800030fc <bmap+0x6c>
      addr = balloc(ip->dev);
    800030e6:	4108                	lw	a0,0(a0)
    800030e8:	e89ff0ef          	jal	80002f70 <balloc>
    800030ec:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800030f0:	02090d63          	beqz	s2,8000312a <bmap+0x9a>
    800030f4:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800030f6:	0929a023          	sw	s2,128(s3)
    800030fa:	a011                	j	800030fe <bmap+0x6e>
    800030fc:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800030fe:	85ca                	mv	a1,s2
    80003100:	0009a503          	lw	a0,0(s3)
    80003104:	c09ff0ef          	jal	80002d0c <bread>
    80003108:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000310a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000310e:	02049713          	slli	a4,s1,0x20
    80003112:	01e75593          	srli	a1,a4,0x1e
    80003116:	00b784b3          	add	s1,a5,a1
    8000311a:	0004a903          	lw	s2,0(s1)
    8000311e:	00090e63          	beqz	s2,8000313a <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003122:	8552                	mv	a0,s4
    80003124:	cf1ff0ef          	jal	80002e14 <brelse>
    return addr;
    80003128:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000312a:	854a                	mv	a0,s2
    8000312c:	70a2                	ld	ra,40(sp)
    8000312e:	7402                	ld	s0,32(sp)
    80003130:	64e2                	ld	s1,24(sp)
    80003132:	6942                	ld	s2,16(sp)
    80003134:	69a2                	ld	s3,8(sp)
    80003136:	6145                	addi	sp,sp,48
    80003138:	8082                	ret
      addr = balloc(ip->dev);
    8000313a:	0009a503          	lw	a0,0(s3)
    8000313e:	e33ff0ef          	jal	80002f70 <balloc>
    80003142:	0005091b          	sext.w	s2,a0
      if(addr){
    80003146:	fc090ee3          	beqz	s2,80003122 <bmap+0x92>
        a[bn] = addr;
    8000314a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000314e:	8552                	mv	a0,s4
    80003150:	50f000ef          	jal	80003e5e <log_write>
    80003154:	b7f9                	j	80003122 <bmap+0x92>
    80003156:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003158:	00004517          	auipc	a0,0x4
    8000315c:	35050513          	addi	a0,a0,848 # 800074a8 <etext+0x4a8>
    80003160:	e42fd0ef          	jal	800007a2 <panic>

0000000080003164 <iget>:
{
    80003164:	7179                	addi	sp,sp,-48
    80003166:	f406                	sd	ra,40(sp)
    80003168:	f022                	sd	s0,32(sp)
    8000316a:	ec26                	sd	s1,24(sp)
    8000316c:	e84a                	sd	s2,16(sp)
    8000316e:	e44e                	sd	s3,8(sp)
    80003170:	e052                	sd	s4,0(sp)
    80003172:	1800                	addi	s0,sp,48
    80003174:	89aa                	mv	s3,a0
    80003176:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003178:	0001e517          	auipc	a0,0x1e
    8000317c:	af050513          	addi	a0,a0,-1296 # 80020c68 <itable>
    80003180:	a83fd0ef          	jal	80000c02 <acquire>
  empty = 0;
    80003184:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003186:	0001e497          	auipc	s1,0x1e
    8000318a:	afa48493          	addi	s1,s1,-1286 # 80020c80 <itable+0x18>
    8000318e:	0001f697          	auipc	a3,0x1f
    80003192:	58268693          	addi	a3,a3,1410 # 80022710 <log>
    80003196:	a039                	j	800031a4 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003198:	02090963          	beqz	s2,800031ca <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000319c:	08848493          	addi	s1,s1,136
    800031a0:	02d48863          	beq	s1,a3,800031d0 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800031a4:	449c                	lw	a5,8(s1)
    800031a6:	fef059e3          	blez	a5,80003198 <iget+0x34>
    800031aa:	4098                	lw	a4,0(s1)
    800031ac:	ff3716e3          	bne	a4,s3,80003198 <iget+0x34>
    800031b0:	40d8                	lw	a4,4(s1)
    800031b2:	ff4713e3          	bne	a4,s4,80003198 <iget+0x34>
      ip->ref++;
    800031b6:	2785                	addiw	a5,a5,1
    800031b8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800031ba:	0001e517          	auipc	a0,0x1e
    800031be:	aae50513          	addi	a0,a0,-1362 # 80020c68 <itable>
    800031c2:	ad9fd0ef          	jal	80000c9a <release>
      return ip;
    800031c6:	8926                	mv	s2,s1
    800031c8:	a02d                	j	800031f2 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800031ca:	fbe9                	bnez	a5,8000319c <iget+0x38>
      empty = ip;
    800031cc:	8926                	mv	s2,s1
    800031ce:	b7f9                	j	8000319c <iget+0x38>
  if(empty == 0)
    800031d0:	02090a63          	beqz	s2,80003204 <iget+0xa0>
  ip->dev = dev;
    800031d4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800031d8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800031dc:	4785                	li	a5,1
    800031de:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800031e2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800031e6:	0001e517          	auipc	a0,0x1e
    800031ea:	a8250513          	addi	a0,a0,-1406 # 80020c68 <itable>
    800031ee:	aadfd0ef          	jal	80000c9a <release>
}
    800031f2:	854a                	mv	a0,s2
    800031f4:	70a2                	ld	ra,40(sp)
    800031f6:	7402                	ld	s0,32(sp)
    800031f8:	64e2                	ld	s1,24(sp)
    800031fa:	6942                	ld	s2,16(sp)
    800031fc:	69a2                	ld	s3,8(sp)
    800031fe:	6a02                	ld	s4,0(sp)
    80003200:	6145                	addi	sp,sp,48
    80003202:	8082                	ret
    panic("iget: no inodes");
    80003204:	00004517          	auipc	a0,0x4
    80003208:	2bc50513          	addi	a0,a0,700 # 800074c0 <etext+0x4c0>
    8000320c:	d96fd0ef          	jal	800007a2 <panic>

0000000080003210 <fsinit>:
fsinit(int dev) {
    80003210:	7179                	addi	sp,sp,-48
    80003212:	f406                	sd	ra,40(sp)
    80003214:	f022                	sd	s0,32(sp)
    80003216:	ec26                	sd	s1,24(sp)
    80003218:	e84a                	sd	s2,16(sp)
    8000321a:	e44e                	sd	s3,8(sp)
    8000321c:	1800                	addi	s0,sp,48
    8000321e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003220:	4585                	li	a1,1
    80003222:	aebff0ef          	jal	80002d0c <bread>
    80003226:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003228:	0001e997          	auipc	s3,0x1e
    8000322c:	a2098993          	addi	s3,s3,-1504 # 80020c48 <sb>
    80003230:	02000613          	li	a2,32
    80003234:	05850593          	addi	a1,a0,88
    80003238:	854e                	mv	a0,s3
    8000323a:	af9fd0ef          	jal	80000d32 <memmove>
  brelse(bp);
    8000323e:	8526                	mv	a0,s1
    80003240:	bd5ff0ef          	jal	80002e14 <brelse>
  if(sb.magic != FSMAGIC)
    80003244:	0009a703          	lw	a4,0(s3)
    80003248:	102037b7          	lui	a5,0x10203
    8000324c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003250:	02f71063          	bne	a4,a5,80003270 <fsinit+0x60>
  initlog(dev, &sb);
    80003254:	0001e597          	auipc	a1,0x1e
    80003258:	9f458593          	addi	a1,a1,-1548 # 80020c48 <sb>
    8000325c:	854a                	mv	a0,s2
    8000325e:	1f9000ef          	jal	80003c56 <initlog>
}
    80003262:	70a2                	ld	ra,40(sp)
    80003264:	7402                	ld	s0,32(sp)
    80003266:	64e2                	ld	s1,24(sp)
    80003268:	6942                	ld	s2,16(sp)
    8000326a:	69a2                	ld	s3,8(sp)
    8000326c:	6145                	addi	sp,sp,48
    8000326e:	8082                	ret
    panic("invalid file system");
    80003270:	00004517          	auipc	a0,0x4
    80003274:	26050513          	addi	a0,a0,608 # 800074d0 <etext+0x4d0>
    80003278:	d2afd0ef          	jal	800007a2 <panic>

000000008000327c <iinit>:
{
    8000327c:	7179                	addi	sp,sp,-48
    8000327e:	f406                	sd	ra,40(sp)
    80003280:	f022                	sd	s0,32(sp)
    80003282:	ec26                	sd	s1,24(sp)
    80003284:	e84a                	sd	s2,16(sp)
    80003286:	e44e                	sd	s3,8(sp)
    80003288:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000328a:	00004597          	auipc	a1,0x4
    8000328e:	25e58593          	addi	a1,a1,606 # 800074e8 <etext+0x4e8>
    80003292:	0001e517          	auipc	a0,0x1e
    80003296:	9d650513          	addi	a0,a0,-1578 # 80020c68 <itable>
    8000329a:	8e9fd0ef          	jal	80000b82 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000329e:	0001e497          	auipc	s1,0x1e
    800032a2:	9f248493          	addi	s1,s1,-1550 # 80020c90 <itable+0x28>
    800032a6:	0001f997          	auipc	s3,0x1f
    800032aa:	47a98993          	addi	s3,s3,1146 # 80022720 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800032ae:	00004917          	auipc	s2,0x4
    800032b2:	24290913          	addi	s2,s2,578 # 800074f0 <etext+0x4f0>
    800032b6:	85ca                	mv	a1,s2
    800032b8:	8526                	mv	a0,s1
    800032ba:	475000ef          	jal	80003f2e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800032be:	08848493          	addi	s1,s1,136
    800032c2:	ff349ae3          	bne	s1,s3,800032b6 <iinit+0x3a>
}
    800032c6:	70a2                	ld	ra,40(sp)
    800032c8:	7402                	ld	s0,32(sp)
    800032ca:	64e2                	ld	s1,24(sp)
    800032cc:	6942                	ld	s2,16(sp)
    800032ce:	69a2                	ld	s3,8(sp)
    800032d0:	6145                	addi	sp,sp,48
    800032d2:	8082                	ret

00000000800032d4 <ialloc>:
{
    800032d4:	7139                	addi	sp,sp,-64
    800032d6:	fc06                	sd	ra,56(sp)
    800032d8:	f822                	sd	s0,48(sp)
    800032da:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800032dc:	0001e717          	auipc	a4,0x1e
    800032e0:	97872703          	lw	a4,-1672(a4) # 80020c54 <sb+0xc>
    800032e4:	4785                	li	a5,1
    800032e6:	06e7f063          	bgeu	a5,a4,80003346 <ialloc+0x72>
    800032ea:	f426                	sd	s1,40(sp)
    800032ec:	f04a                	sd	s2,32(sp)
    800032ee:	ec4e                	sd	s3,24(sp)
    800032f0:	e852                	sd	s4,16(sp)
    800032f2:	e456                	sd	s5,8(sp)
    800032f4:	e05a                	sd	s6,0(sp)
    800032f6:	8aaa                	mv	s5,a0
    800032f8:	8b2e                	mv	s6,a1
    800032fa:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800032fc:	0001ea17          	auipc	s4,0x1e
    80003300:	94ca0a13          	addi	s4,s4,-1716 # 80020c48 <sb>
    80003304:	00495593          	srli	a1,s2,0x4
    80003308:	018a2783          	lw	a5,24(s4)
    8000330c:	9dbd                	addw	a1,a1,a5
    8000330e:	8556                	mv	a0,s5
    80003310:	9fdff0ef          	jal	80002d0c <bread>
    80003314:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003316:	05850993          	addi	s3,a0,88
    8000331a:	00f97793          	andi	a5,s2,15
    8000331e:	079a                	slli	a5,a5,0x6
    80003320:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003322:	00099783          	lh	a5,0(s3)
    80003326:	cb9d                	beqz	a5,8000335c <ialloc+0x88>
    brelse(bp);
    80003328:	aedff0ef          	jal	80002e14 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000332c:	0905                	addi	s2,s2,1
    8000332e:	00ca2703          	lw	a4,12(s4)
    80003332:	0009079b          	sext.w	a5,s2
    80003336:	fce7e7e3          	bltu	a5,a4,80003304 <ialloc+0x30>
    8000333a:	74a2                	ld	s1,40(sp)
    8000333c:	7902                	ld	s2,32(sp)
    8000333e:	69e2                	ld	s3,24(sp)
    80003340:	6a42                	ld	s4,16(sp)
    80003342:	6aa2                	ld	s5,8(sp)
    80003344:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003346:	00004517          	auipc	a0,0x4
    8000334a:	1b250513          	addi	a0,a0,434 # 800074f8 <etext+0x4f8>
    8000334e:	982fd0ef          	jal	800004d0 <printf>
  return 0;
    80003352:	4501                	li	a0,0
}
    80003354:	70e2                	ld	ra,56(sp)
    80003356:	7442                	ld	s0,48(sp)
    80003358:	6121                	addi	sp,sp,64
    8000335a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000335c:	04000613          	li	a2,64
    80003360:	4581                	li	a1,0
    80003362:	854e                	mv	a0,s3
    80003364:	973fd0ef          	jal	80000cd6 <memset>
      dip->type = type;
    80003368:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000336c:	8526                	mv	a0,s1
    8000336e:	2f1000ef          	jal	80003e5e <log_write>
      brelse(bp);
    80003372:	8526                	mv	a0,s1
    80003374:	aa1ff0ef          	jal	80002e14 <brelse>
      return iget(dev, inum);
    80003378:	0009059b          	sext.w	a1,s2
    8000337c:	8556                	mv	a0,s5
    8000337e:	de7ff0ef          	jal	80003164 <iget>
    80003382:	74a2                	ld	s1,40(sp)
    80003384:	7902                	ld	s2,32(sp)
    80003386:	69e2                	ld	s3,24(sp)
    80003388:	6a42                	ld	s4,16(sp)
    8000338a:	6aa2                	ld	s5,8(sp)
    8000338c:	6b02                	ld	s6,0(sp)
    8000338e:	b7d9                	j	80003354 <ialloc+0x80>

0000000080003390 <iupdate>:
{
    80003390:	1101                	addi	sp,sp,-32
    80003392:	ec06                	sd	ra,24(sp)
    80003394:	e822                	sd	s0,16(sp)
    80003396:	e426                	sd	s1,8(sp)
    80003398:	e04a                	sd	s2,0(sp)
    8000339a:	1000                	addi	s0,sp,32
    8000339c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000339e:	415c                	lw	a5,4(a0)
    800033a0:	0047d79b          	srliw	a5,a5,0x4
    800033a4:	0001e597          	auipc	a1,0x1e
    800033a8:	8bc5a583          	lw	a1,-1860(a1) # 80020c60 <sb+0x18>
    800033ac:	9dbd                	addw	a1,a1,a5
    800033ae:	4108                	lw	a0,0(a0)
    800033b0:	95dff0ef          	jal	80002d0c <bread>
    800033b4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800033b6:	05850793          	addi	a5,a0,88
    800033ba:	40d8                	lw	a4,4(s1)
    800033bc:	8b3d                	andi	a4,a4,15
    800033be:	071a                	slli	a4,a4,0x6
    800033c0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800033c2:	04449703          	lh	a4,68(s1)
    800033c6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800033ca:	04649703          	lh	a4,70(s1)
    800033ce:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800033d2:	04849703          	lh	a4,72(s1)
    800033d6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800033da:	04a49703          	lh	a4,74(s1)
    800033de:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800033e2:	44f8                	lw	a4,76(s1)
    800033e4:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800033e6:	03400613          	li	a2,52
    800033ea:	05048593          	addi	a1,s1,80
    800033ee:	00c78513          	addi	a0,a5,12
    800033f2:	941fd0ef          	jal	80000d32 <memmove>
  log_write(bp);
    800033f6:	854a                	mv	a0,s2
    800033f8:	267000ef          	jal	80003e5e <log_write>
  brelse(bp);
    800033fc:	854a                	mv	a0,s2
    800033fe:	a17ff0ef          	jal	80002e14 <brelse>
}
    80003402:	60e2                	ld	ra,24(sp)
    80003404:	6442                	ld	s0,16(sp)
    80003406:	64a2                	ld	s1,8(sp)
    80003408:	6902                	ld	s2,0(sp)
    8000340a:	6105                	addi	sp,sp,32
    8000340c:	8082                	ret

000000008000340e <idup>:
{
    8000340e:	1101                	addi	sp,sp,-32
    80003410:	ec06                	sd	ra,24(sp)
    80003412:	e822                	sd	s0,16(sp)
    80003414:	e426                	sd	s1,8(sp)
    80003416:	1000                	addi	s0,sp,32
    80003418:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000341a:	0001e517          	auipc	a0,0x1e
    8000341e:	84e50513          	addi	a0,a0,-1970 # 80020c68 <itable>
    80003422:	fe0fd0ef          	jal	80000c02 <acquire>
  ip->ref++;
    80003426:	449c                	lw	a5,8(s1)
    80003428:	2785                	addiw	a5,a5,1
    8000342a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000342c:	0001e517          	auipc	a0,0x1e
    80003430:	83c50513          	addi	a0,a0,-1988 # 80020c68 <itable>
    80003434:	867fd0ef          	jal	80000c9a <release>
}
    80003438:	8526                	mv	a0,s1
    8000343a:	60e2                	ld	ra,24(sp)
    8000343c:	6442                	ld	s0,16(sp)
    8000343e:	64a2                	ld	s1,8(sp)
    80003440:	6105                	addi	sp,sp,32
    80003442:	8082                	ret

0000000080003444 <ilock>:
{
    80003444:	1101                	addi	sp,sp,-32
    80003446:	ec06                	sd	ra,24(sp)
    80003448:	e822                	sd	s0,16(sp)
    8000344a:	e426                	sd	s1,8(sp)
    8000344c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000344e:	cd19                	beqz	a0,8000346c <ilock+0x28>
    80003450:	84aa                	mv	s1,a0
    80003452:	451c                	lw	a5,8(a0)
    80003454:	00f05c63          	blez	a5,8000346c <ilock+0x28>
  acquiresleep(&ip->lock);
    80003458:	0541                	addi	a0,a0,16
    8000345a:	30b000ef          	jal	80003f64 <acquiresleep>
  if(ip->valid == 0){
    8000345e:	40bc                	lw	a5,64(s1)
    80003460:	cf89                	beqz	a5,8000347a <ilock+0x36>
}
    80003462:	60e2                	ld	ra,24(sp)
    80003464:	6442                	ld	s0,16(sp)
    80003466:	64a2                	ld	s1,8(sp)
    80003468:	6105                	addi	sp,sp,32
    8000346a:	8082                	ret
    8000346c:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000346e:	00004517          	auipc	a0,0x4
    80003472:	0a250513          	addi	a0,a0,162 # 80007510 <etext+0x510>
    80003476:	b2cfd0ef          	jal	800007a2 <panic>
    8000347a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000347c:	40dc                	lw	a5,4(s1)
    8000347e:	0047d79b          	srliw	a5,a5,0x4
    80003482:	0001d597          	auipc	a1,0x1d
    80003486:	7de5a583          	lw	a1,2014(a1) # 80020c60 <sb+0x18>
    8000348a:	9dbd                	addw	a1,a1,a5
    8000348c:	4088                	lw	a0,0(s1)
    8000348e:	87fff0ef          	jal	80002d0c <bread>
    80003492:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003494:	05850593          	addi	a1,a0,88
    80003498:	40dc                	lw	a5,4(s1)
    8000349a:	8bbd                	andi	a5,a5,15
    8000349c:	079a                	slli	a5,a5,0x6
    8000349e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800034a0:	00059783          	lh	a5,0(a1)
    800034a4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800034a8:	00259783          	lh	a5,2(a1)
    800034ac:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800034b0:	00459783          	lh	a5,4(a1)
    800034b4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800034b8:	00659783          	lh	a5,6(a1)
    800034bc:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800034c0:	459c                	lw	a5,8(a1)
    800034c2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800034c4:	03400613          	li	a2,52
    800034c8:	05b1                	addi	a1,a1,12
    800034ca:	05048513          	addi	a0,s1,80
    800034ce:	865fd0ef          	jal	80000d32 <memmove>
    brelse(bp);
    800034d2:	854a                	mv	a0,s2
    800034d4:	941ff0ef          	jal	80002e14 <brelse>
    ip->valid = 1;
    800034d8:	4785                	li	a5,1
    800034da:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800034dc:	04449783          	lh	a5,68(s1)
    800034e0:	c399                	beqz	a5,800034e6 <ilock+0xa2>
    800034e2:	6902                	ld	s2,0(sp)
    800034e4:	bfbd                	j	80003462 <ilock+0x1e>
      panic("ilock: no type");
    800034e6:	00004517          	auipc	a0,0x4
    800034ea:	03250513          	addi	a0,a0,50 # 80007518 <etext+0x518>
    800034ee:	ab4fd0ef          	jal	800007a2 <panic>

00000000800034f2 <iunlock>:
{
    800034f2:	1101                	addi	sp,sp,-32
    800034f4:	ec06                	sd	ra,24(sp)
    800034f6:	e822                	sd	s0,16(sp)
    800034f8:	e426                	sd	s1,8(sp)
    800034fa:	e04a                	sd	s2,0(sp)
    800034fc:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800034fe:	c505                	beqz	a0,80003526 <iunlock+0x34>
    80003500:	84aa                	mv	s1,a0
    80003502:	01050913          	addi	s2,a0,16
    80003506:	854a                	mv	a0,s2
    80003508:	2db000ef          	jal	80003fe2 <holdingsleep>
    8000350c:	cd09                	beqz	a0,80003526 <iunlock+0x34>
    8000350e:	449c                	lw	a5,8(s1)
    80003510:	00f05b63          	blez	a5,80003526 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003514:	854a                	mv	a0,s2
    80003516:	295000ef          	jal	80003faa <releasesleep>
}
    8000351a:	60e2                	ld	ra,24(sp)
    8000351c:	6442                	ld	s0,16(sp)
    8000351e:	64a2                	ld	s1,8(sp)
    80003520:	6902                	ld	s2,0(sp)
    80003522:	6105                	addi	sp,sp,32
    80003524:	8082                	ret
    panic("iunlock");
    80003526:	00004517          	auipc	a0,0x4
    8000352a:	00250513          	addi	a0,a0,2 # 80007528 <etext+0x528>
    8000352e:	a74fd0ef          	jal	800007a2 <panic>

0000000080003532 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003532:	7179                	addi	sp,sp,-48
    80003534:	f406                	sd	ra,40(sp)
    80003536:	f022                	sd	s0,32(sp)
    80003538:	ec26                	sd	s1,24(sp)
    8000353a:	e84a                	sd	s2,16(sp)
    8000353c:	e44e                	sd	s3,8(sp)
    8000353e:	1800                	addi	s0,sp,48
    80003540:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003542:	05050493          	addi	s1,a0,80
    80003546:	08050913          	addi	s2,a0,128
    8000354a:	a021                	j	80003552 <itrunc+0x20>
    8000354c:	0491                	addi	s1,s1,4
    8000354e:	01248b63          	beq	s1,s2,80003564 <itrunc+0x32>
    if(ip->addrs[i]){
    80003552:	408c                	lw	a1,0(s1)
    80003554:	dde5                	beqz	a1,8000354c <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003556:	0009a503          	lw	a0,0(s3)
    8000355a:	9abff0ef          	jal	80002f04 <bfree>
      ip->addrs[i] = 0;
    8000355e:	0004a023          	sw	zero,0(s1)
    80003562:	b7ed                	j	8000354c <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003564:	0809a583          	lw	a1,128(s3)
    80003568:	ed89                	bnez	a1,80003582 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000356a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000356e:	854e                	mv	a0,s3
    80003570:	e21ff0ef          	jal	80003390 <iupdate>
}
    80003574:	70a2                	ld	ra,40(sp)
    80003576:	7402                	ld	s0,32(sp)
    80003578:	64e2                	ld	s1,24(sp)
    8000357a:	6942                	ld	s2,16(sp)
    8000357c:	69a2                	ld	s3,8(sp)
    8000357e:	6145                	addi	sp,sp,48
    80003580:	8082                	ret
    80003582:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003584:	0009a503          	lw	a0,0(s3)
    80003588:	f84ff0ef          	jal	80002d0c <bread>
    8000358c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000358e:	05850493          	addi	s1,a0,88
    80003592:	45850913          	addi	s2,a0,1112
    80003596:	a021                	j	8000359e <itrunc+0x6c>
    80003598:	0491                	addi	s1,s1,4
    8000359a:	01248963          	beq	s1,s2,800035ac <itrunc+0x7a>
      if(a[j])
    8000359e:	408c                	lw	a1,0(s1)
    800035a0:	dde5                	beqz	a1,80003598 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800035a2:	0009a503          	lw	a0,0(s3)
    800035a6:	95fff0ef          	jal	80002f04 <bfree>
    800035aa:	b7fd                	j	80003598 <itrunc+0x66>
    brelse(bp);
    800035ac:	8552                	mv	a0,s4
    800035ae:	867ff0ef          	jal	80002e14 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800035b2:	0809a583          	lw	a1,128(s3)
    800035b6:	0009a503          	lw	a0,0(s3)
    800035ba:	94bff0ef          	jal	80002f04 <bfree>
    ip->addrs[NDIRECT] = 0;
    800035be:	0809a023          	sw	zero,128(s3)
    800035c2:	6a02                	ld	s4,0(sp)
    800035c4:	b75d                	j	8000356a <itrunc+0x38>

00000000800035c6 <iput>:
{
    800035c6:	1101                	addi	sp,sp,-32
    800035c8:	ec06                	sd	ra,24(sp)
    800035ca:	e822                	sd	s0,16(sp)
    800035cc:	e426                	sd	s1,8(sp)
    800035ce:	1000                	addi	s0,sp,32
    800035d0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800035d2:	0001d517          	auipc	a0,0x1d
    800035d6:	69650513          	addi	a0,a0,1686 # 80020c68 <itable>
    800035da:	e28fd0ef          	jal	80000c02 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800035de:	4498                	lw	a4,8(s1)
    800035e0:	4785                	li	a5,1
    800035e2:	02f70063          	beq	a4,a5,80003602 <iput+0x3c>
  ip->ref--;
    800035e6:	449c                	lw	a5,8(s1)
    800035e8:	37fd                	addiw	a5,a5,-1
    800035ea:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800035ec:	0001d517          	auipc	a0,0x1d
    800035f0:	67c50513          	addi	a0,a0,1660 # 80020c68 <itable>
    800035f4:	ea6fd0ef          	jal	80000c9a <release>
}
    800035f8:	60e2                	ld	ra,24(sp)
    800035fa:	6442                	ld	s0,16(sp)
    800035fc:	64a2                	ld	s1,8(sp)
    800035fe:	6105                	addi	sp,sp,32
    80003600:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003602:	40bc                	lw	a5,64(s1)
    80003604:	d3ed                	beqz	a5,800035e6 <iput+0x20>
    80003606:	04a49783          	lh	a5,74(s1)
    8000360a:	fff1                	bnez	a5,800035e6 <iput+0x20>
    8000360c:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000360e:	01048913          	addi	s2,s1,16
    80003612:	854a                	mv	a0,s2
    80003614:	151000ef          	jal	80003f64 <acquiresleep>
    release(&itable.lock);
    80003618:	0001d517          	auipc	a0,0x1d
    8000361c:	65050513          	addi	a0,a0,1616 # 80020c68 <itable>
    80003620:	e7afd0ef          	jal	80000c9a <release>
    itrunc(ip);
    80003624:	8526                	mv	a0,s1
    80003626:	f0dff0ef          	jal	80003532 <itrunc>
    ip->type = 0;
    8000362a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000362e:	8526                	mv	a0,s1
    80003630:	d61ff0ef          	jal	80003390 <iupdate>
    ip->valid = 0;
    80003634:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003638:	854a                	mv	a0,s2
    8000363a:	171000ef          	jal	80003faa <releasesleep>
    acquire(&itable.lock);
    8000363e:	0001d517          	auipc	a0,0x1d
    80003642:	62a50513          	addi	a0,a0,1578 # 80020c68 <itable>
    80003646:	dbcfd0ef          	jal	80000c02 <acquire>
    8000364a:	6902                	ld	s2,0(sp)
    8000364c:	bf69                	j	800035e6 <iput+0x20>

000000008000364e <iunlockput>:
{
    8000364e:	1101                	addi	sp,sp,-32
    80003650:	ec06                	sd	ra,24(sp)
    80003652:	e822                	sd	s0,16(sp)
    80003654:	e426                	sd	s1,8(sp)
    80003656:	1000                	addi	s0,sp,32
    80003658:	84aa                	mv	s1,a0
  iunlock(ip);
    8000365a:	e99ff0ef          	jal	800034f2 <iunlock>
  iput(ip);
    8000365e:	8526                	mv	a0,s1
    80003660:	f67ff0ef          	jal	800035c6 <iput>
}
    80003664:	60e2                	ld	ra,24(sp)
    80003666:	6442                	ld	s0,16(sp)
    80003668:	64a2                	ld	s1,8(sp)
    8000366a:	6105                	addi	sp,sp,32
    8000366c:	8082                	ret

000000008000366e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000366e:	1141                	addi	sp,sp,-16
    80003670:	e422                	sd	s0,8(sp)
    80003672:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003674:	411c                	lw	a5,0(a0)
    80003676:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003678:	415c                	lw	a5,4(a0)
    8000367a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000367c:	04451783          	lh	a5,68(a0)
    80003680:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003684:	04a51783          	lh	a5,74(a0)
    80003688:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000368c:	04c56783          	lwu	a5,76(a0)
    80003690:	e99c                	sd	a5,16(a1)
}
    80003692:	6422                	ld	s0,8(sp)
    80003694:	0141                	addi	sp,sp,16
    80003696:	8082                	ret

0000000080003698 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003698:	457c                	lw	a5,76(a0)
    8000369a:	0ed7eb63          	bltu	a5,a3,80003790 <readi+0xf8>
{
    8000369e:	7159                	addi	sp,sp,-112
    800036a0:	f486                	sd	ra,104(sp)
    800036a2:	f0a2                	sd	s0,96(sp)
    800036a4:	eca6                	sd	s1,88(sp)
    800036a6:	e0d2                	sd	s4,64(sp)
    800036a8:	fc56                	sd	s5,56(sp)
    800036aa:	f85a                	sd	s6,48(sp)
    800036ac:	f45e                	sd	s7,40(sp)
    800036ae:	1880                	addi	s0,sp,112
    800036b0:	8b2a                	mv	s6,a0
    800036b2:	8bae                	mv	s7,a1
    800036b4:	8a32                	mv	s4,a2
    800036b6:	84b6                	mv	s1,a3
    800036b8:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800036ba:	9f35                	addw	a4,a4,a3
    return 0;
    800036bc:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800036be:	0cd76063          	bltu	a4,a3,8000377e <readi+0xe6>
    800036c2:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800036c4:	00e7f463          	bgeu	a5,a4,800036cc <readi+0x34>
    n = ip->size - off;
    800036c8:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800036cc:	080a8f63          	beqz	s5,8000376a <readi+0xd2>
    800036d0:	e8ca                	sd	s2,80(sp)
    800036d2:	f062                	sd	s8,32(sp)
    800036d4:	ec66                	sd	s9,24(sp)
    800036d6:	e86a                	sd	s10,16(sp)
    800036d8:	e46e                	sd	s11,8(sp)
    800036da:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800036dc:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800036e0:	5c7d                	li	s8,-1
    800036e2:	a80d                	j	80003714 <readi+0x7c>
    800036e4:	020d1d93          	slli	s11,s10,0x20
    800036e8:	020ddd93          	srli	s11,s11,0x20
    800036ec:	05890613          	addi	a2,s2,88
    800036f0:	86ee                	mv	a3,s11
    800036f2:	963a                	add	a2,a2,a4
    800036f4:	85d2                	mv	a1,s4
    800036f6:	855e                	mv	a0,s7
    800036f8:	ca7fe0ef          	jal	8000239e <either_copyout>
    800036fc:	05850763          	beq	a0,s8,8000374a <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003700:	854a                	mv	a0,s2
    80003702:	f12ff0ef          	jal	80002e14 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003706:	013d09bb          	addw	s3,s10,s3
    8000370a:	009d04bb          	addw	s1,s10,s1
    8000370e:	9a6e                	add	s4,s4,s11
    80003710:	0559f763          	bgeu	s3,s5,8000375e <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80003714:	00a4d59b          	srliw	a1,s1,0xa
    80003718:	855a                	mv	a0,s6
    8000371a:	977ff0ef          	jal	80003090 <bmap>
    8000371e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003722:	c5b1                	beqz	a1,8000376e <readi+0xd6>
    bp = bread(ip->dev, addr);
    80003724:	000b2503          	lw	a0,0(s6)
    80003728:	de4ff0ef          	jal	80002d0c <bread>
    8000372c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000372e:	3ff4f713          	andi	a4,s1,1023
    80003732:	40ec87bb          	subw	a5,s9,a4
    80003736:	413a86bb          	subw	a3,s5,s3
    8000373a:	8d3e                	mv	s10,a5
    8000373c:	2781                	sext.w	a5,a5
    8000373e:	0006861b          	sext.w	a2,a3
    80003742:	faf671e3          	bgeu	a2,a5,800036e4 <readi+0x4c>
    80003746:	8d36                	mv	s10,a3
    80003748:	bf71                	j	800036e4 <readi+0x4c>
      brelse(bp);
    8000374a:	854a                	mv	a0,s2
    8000374c:	ec8ff0ef          	jal	80002e14 <brelse>
      tot = -1;
    80003750:	59fd                	li	s3,-1
      break;
    80003752:	6946                	ld	s2,80(sp)
    80003754:	7c02                	ld	s8,32(sp)
    80003756:	6ce2                	ld	s9,24(sp)
    80003758:	6d42                	ld	s10,16(sp)
    8000375a:	6da2                	ld	s11,8(sp)
    8000375c:	a831                	j	80003778 <readi+0xe0>
    8000375e:	6946                	ld	s2,80(sp)
    80003760:	7c02                	ld	s8,32(sp)
    80003762:	6ce2                	ld	s9,24(sp)
    80003764:	6d42                	ld	s10,16(sp)
    80003766:	6da2                	ld	s11,8(sp)
    80003768:	a801                	j	80003778 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000376a:	89d6                	mv	s3,s5
    8000376c:	a031                	j	80003778 <readi+0xe0>
    8000376e:	6946                	ld	s2,80(sp)
    80003770:	7c02                	ld	s8,32(sp)
    80003772:	6ce2                	ld	s9,24(sp)
    80003774:	6d42                	ld	s10,16(sp)
    80003776:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003778:	0009851b          	sext.w	a0,s3
    8000377c:	69a6                	ld	s3,72(sp)
}
    8000377e:	70a6                	ld	ra,104(sp)
    80003780:	7406                	ld	s0,96(sp)
    80003782:	64e6                	ld	s1,88(sp)
    80003784:	6a06                	ld	s4,64(sp)
    80003786:	7ae2                	ld	s5,56(sp)
    80003788:	7b42                	ld	s6,48(sp)
    8000378a:	7ba2                	ld	s7,40(sp)
    8000378c:	6165                	addi	sp,sp,112
    8000378e:	8082                	ret
    return 0;
    80003790:	4501                	li	a0,0
}
    80003792:	8082                	ret

0000000080003794 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003794:	457c                	lw	a5,76(a0)
    80003796:	10d7e063          	bltu	a5,a3,80003896 <writei+0x102>
{
    8000379a:	7159                	addi	sp,sp,-112
    8000379c:	f486                	sd	ra,104(sp)
    8000379e:	f0a2                	sd	s0,96(sp)
    800037a0:	e8ca                	sd	s2,80(sp)
    800037a2:	e0d2                	sd	s4,64(sp)
    800037a4:	fc56                	sd	s5,56(sp)
    800037a6:	f85a                	sd	s6,48(sp)
    800037a8:	f45e                	sd	s7,40(sp)
    800037aa:	1880                	addi	s0,sp,112
    800037ac:	8aaa                	mv	s5,a0
    800037ae:	8bae                	mv	s7,a1
    800037b0:	8a32                	mv	s4,a2
    800037b2:	8936                	mv	s2,a3
    800037b4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800037b6:	00e687bb          	addw	a5,a3,a4
    800037ba:	0ed7e063          	bltu	a5,a3,8000389a <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800037be:	00043737          	lui	a4,0x43
    800037c2:	0cf76e63          	bltu	a4,a5,8000389e <writei+0x10a>
    800037c6:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800037c8:	0a0b0f63          	beqz	s6,80003886 <writei+0xf2>
    800037cc:	eca6                	sd	s1,88(sp)
    800037ce:	f062                	sd	s8,32(sp)
    800037d0:	ec66                	sd	s9,24(sp)
    800037d2:	e86a                	sd	s10,16(sp)
    800037d4:	e46e                	sd	s11,8(sp)
    800037d6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800037d8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800037dc:	5c7d                	li	s8,-1
    800037de:	a825                	j	80003816 <writei+0x82>
    800037e0:	020d1d93          	slli	s11,s10,0x20
    800037e4:	020ddd93          	srli	s11,s11,0x20
    800037e8:	05848513          	addi	a0,s1,88
    800037ec:	86ee                	mv	a3,s11
    800037ee:	8652                	mv	a2,s4
    800037f0:	85de                	mv	a1,s7
    800037f2:	953a                	add	a0,a0,a4
    800037f4:	bf5fe0ef          	jal	800023e8 <either_copyin>
    800037f8:	05850a63          	beq	a0,s8,8000384c <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800037fc:	8526                	mv	a0,s1
    800037fe:	660000ef          	jal	80003e5e <log_write>
    brelse(bp);
    80003802:	8526                	mv	a0,s1
    80003804:	e10ff0ef          	jal	80002e14 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003808:	013d09bb          	addw	s3,s10,s3
    8000380c:	012d093b          	addw	s2,s10,s2
    80003810:	9a6e                	add	s4,s4,s11
    80003812:	0569f063          	bgeu	s3,s6,80003852 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003816:	00a9559b          	srliw	a1,s2,0xa
    8000381a:	8556                	mv	a0,s5
    8000381c:	875ff0ef          	jal	80003090 <bmap>
    80003820:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003824:	c59d                	beqz	a1,80003852 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003826:	000aa503          	lw	a0,0(s5)
    8000382a:	ce2ff0ef          	jal	80002d0c <bread>
    8000382e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003830:	3ff97713          	andi	a4,s2,1023
    80003834:	40ec87bb          	subw	a5,s9,a4
    80003838:	413b06bb          	subw	a3,s6,s3
    8000383c:	8d3e                	mv	s10,a5
    8000383e:	2781                	sext.w	a5,a5
    80003840:	0006861b          	sext.w	a2,a3
    80003844:	f8f67ee3          	bgeu	a2,a5,800037e0 <writei+0x4c>
    80003848:	8d36                	mv	s10,a3
    8000384a:	bf59                	j	800037e0 <writei+0x4c>
      brelse(bp);
    8000384c:	8526                	mv	a0,s1
    8000384e:	dc6ff0ef          	jal	80002e14 <brelse>
  }

  if(off > ip->size)
    80003852:	04caa783          	lw	a5,76(s5)
    80003856:	0327fa63          	bgeu	a5,s2,8000388a <writei+0xf6>
    ip->size = off;
    8000385a:	052aa623          	sw	s2,76(s5)
    8000385e:	64e6                	ld	s1,88(sp)
    80003860:	7c02                	ld	s8,32(sp)
    80003862:	6ce2                	ld	s9,24(sp)
    80003864:	6d42                	ld	s10,16(sp)
    80003866:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003868:	8556                	mv	a0,s5
    8000386a:	b27ff0ef          	jal	80003390 <iupdate>

  return tot;
    8000386e:	0009851b          	sext.w	a0,s3
    80003872:	69a6                	ld	s3,72(sp)
}
    80003874:	70a6                	ld	ra,104(sp)
    80003876:	7406                	ld	s0,96(sp)
    80003878:	6946                	ld	s2,80(sp)
    8000387a:	6a06                	ld	s4,64(sp)
    8000387c:	7ae2                	ld	s5,56(sp)
    8000387e:	7b42                	ld	s6,48(sp)
    80003880:	7ba2                	ld	s7,40(sp)
    80003882:	6165                	addi	sp,sp,112
    80003884:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003886:	89da                	mv	s3,s6
    80003888:	b7c5                	j	80003868 <writei+0xd4>
    8000388a:	64e6                	ld	s1,88(sp)
    8000388c:	7c02                	ld	s8,32(sp)
    8000388e:	6ce2                	ld	s9,24(sp)
    80003890:	6d42                	ld	s10,16(sp)
    80003892:	6da2                	ld	s11,8(sp)
    80003894:	bfd1                	j	80003868 <writei+0xd4>
    return -1;
    80003896:	557d                	li	a0,-1
}
    80003898:	8082                	ret
    return -1;
    8000389a:	557d                	li	a0,-1
    8000389c:	bfe1                	j	80003874 <writei+0xe0>
    return -1;
    8000389e:	557d                	li	a0,-1
    800038a0:	bfd1                	j	80003874 <writei+0xe0>

00000000800038a2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800038a2:	1141                	addi	sp,sp,-16
    800038a4:	e406                	sd	ra,8(sp)
    800038a6:	e022                	sd	s0,0(sp)
    800038a8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800038aa:	4639                	li	a2,14
    800038ac:	cf6fd0ef          	jal	80000da2 <strncmp>
}
    800038b0:	60a2                	ld	ra,8(sp)
    800038b2:	6402                	ld	s0,0(sp)
    800038b4:	0141                	addi	sp,sp,16
    800038b6:	8082                	ret

00000000800038b8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800038b8:	7139                	addi	sp,sp,-64
    800038ba:	fc06                	sd	ra,56(sp)
    800038bc:	f822                	sd	s0,48(sp)
    800038be:	f426                	sd	s1,40(sp)
    800038c0:	f04a                	sd	s2,32(sp)
    800038c2:	ec4e                	sd	s3,24(sp)
    800038c4:	e852                	sd	s4,16(sp)
    800038c6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800038c8:	04451703          	lh	a4,68(a0)
    800038cc:	4785                	li	a5,1
    800038ce:	00f71a63          	bne	a4,a5,800038e2 <dirlookup+0x2a>
    800038d2:	892a                	mv	s2,a0
    800038d4:	89ae                	mv	s3,a1
    800038d6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800038d8:	457c                	lw	a5,76(a0)
    800038da:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800038dc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800038de:	e39d                	bnez	a5,80003904 <dirlookup+0x4c>
    800038e0:	a095                	j	80003944 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    800038e2:	00004517          	auipc	a0,0x4
    800038e6:	c4e50513          	addi	a0,a0,-946 # 80007530 <etext+0x530>
    800038ea:	eb9fc0ef          	jal	800007a2 <panic>
      panic("dirlookup read");
    800038ee:	00004517          	auipc	a0,0x4
    800038f2:	c5a50513          	addi	a0,a0,-934 # 80007548 <etext+0x548>
    800038f6:	eadfc0ef          	jal	800007a2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800038fa:	24c1                	addiw	s1,s1,16
    800038fc:	04c92783          	lw	a5,76(s2)
    80003900:	04f4f163          	bgeu	s1,a5,80003942 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003904:	4741                	li	a4,16
    80003906:	86a6                	mv	a3,s1
    80003908:	fc040613          	addi	a2,s0,-64
    8000390c:	4581                	li	a1,0
    8000390e:	854a                	mv	a0,s2
    80003910:	d89ff0ef          	jal	80003698 <readi>
    80003914:	47c1                	li	a5,16
    80003916:	fcf51ce3          	bne	a0,a5,800038ee <dirlookup+0x36>
    if(de.inum == 0)
    8000391a:	fc045783          	lhu	a5,-64(s0)
    8000391e:	dff1                	beqz	a5,800038fa <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003920:	fc240593          	addi	a1,s0,-62
    80003924:	854e                	mv	a0,s3
    80003926:	f7dff0ef          	jal	800038a2 <namecmp>
    8000392a:	f961                	bnez	a0,800038fa <dirlookup+0x42>
      if(poff)
    8000392c:	000a0463          	beqz	s4,80003934 <dirlookup+0x7c>
        *poff = off;
    80003930:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003934:	fc045583          	lhu	a1,-64(s0)
    80003938:	00092503          	lw	a0,0(s2)
    8000393c:	829ff0ef          	jal	80003164 <iget>
    80003940:	a011                	j	80003944 <dirlookup+0x8c>
  return 0;
    80003942:	4501                	li	a0,0
}
    80003944:	70e2                	ld	ra,56(sp)
    80003946:	7442                	ld	s0,48(sp)
    80003948:	74a2                	ld	s1,40(sp)
    8000394a:	7902                	ld	s2,32(sp)
    8000394c:	69e2                	ld	s3,24(sp)
    8000394e:	6a42                	ld	s4,16(sp)
    80003950:	6121                	addi	sp,sp,64
    80003952:	8082                	ret

0000000080003954 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003954:	711d                	addi	sp,sp,-96
    80003956:	ec86                	sd	ra,88(sp)
    80003958:	e8a2                	sd	s0,80(sp)
    8000395a:	e4a6                	sd	s1,72(sp)
    8000395c:	e0ca                	sd	s2,64(sp)
    8000395e:	fc4e                	sd	s3,56(sp)
    80003960:	f852                	sd	s4,48(sp)
    80003962:	f456                	sd	s5,40(sp)
    80003964:	f05a                	sd	s6,32(sp)
    80003966:	ec5e                	sd	s7,24(sp)
    80003968:	e862                	sd	s8,16(sp)
    8000396a:	e466                	sd	s9,8(sp)
    8000396c:	1080                	addi	s0,sp,96
    8000396e:	84aa                	mv	s1,a0
    80003970:	8b2e                	mv	s6,a1
    80003972:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003974:	00054703          	lbu	a4,0(a0)
    80003978:	02f00793          	li	a5,47
    8000397c:	00f70e63          	beq	a4,a5,80003998 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003980:	f81fd0ef          	jal	80001900 <myproc>
    80003984:	15053503          	ld	a0,336(a0)
    80003988:	a87ff0ef          	jal	8000340e <idup>
    8000398c:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000398e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003992:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003994:	4b85                	li	s7,1
    80003996:	a871                	j	80003a32 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003998:	4585                	li	a1,1
    8000399a:	4505                	li	a0,1
    8000399c:	fc8ff0ef          	jal	80003164 <iget>
    800039a0:	8a2a                	mv	s4,a0
    800039a2:	b7f5                	j	8000398e <namex+0x3a>
      iunlockput(ip);
    800039a4:	8552                	mv	a0,s4
    800039a6:	ca9ff0ef          	jal	8000364e <iunlockput>
      return 0;
    800039aa:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800039ac:	8552                	mv	a0,s4
    800039ae:	60e6                	ld	ra,88(sp)
    800039b0:	6446                	ld	s0,80(sp)
    800039b2:	64a6                	ld	s1,72(sp)
    800039b4:	6906                	ld	s2,64(sp)
    800039b6:	79e2                	ld	s3,56(sp)
    800039b8:	7a42                	ld	s4,48(sp)
    800039ba:	7aa2                	ld	s5,40(sp)
    800039bc:	7b02                	ld	s6,32(sp)
    800039be:	6be2                	ld	s7,24(sp)
    800039c0:	6c42                	ld	s8,16(sp)
    800039c2:	6ca2                	ld	s9,8(sp)
    800039c4:	6125                	addi	sp,sp,96
    800039c6:	8082                	ret
      iunlock(ip);
    800039c8:	8552                	mv	a0,s4
    800039ca:	b29ff0ef          	jal	800034f2 <iunlock>
      return ip;
    800039ce:	bff9                	j	800039ac <namex+0x58>
      iunlockput(ip);
    800039d0:	8552                	mv	a0,s4
    800039d2:	c7dff0ef          	jal	8000364e <iunlockput>
      return 0;
    800039d6:	8a4e                	mv	s4,s3
    800039d8:	bfd1                	j	800039ac <namex+0x58>
  len = path - s;
    800039da:	40998633          	sub	a2,s3,s1
    800039de:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800039e2:	099c5063          	bge	s8,s9,80003a62 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    800039e6:	4639                	li	a2,14
    800039e8:	85a6                	mv	a1,s1
    800039ea:	8556                	mv	a0,s5
    800039ec:	b46fd0ef          	jal	80000d32 <memmove>
    800039f0:	84ce                	mv	s1,s3
  while(*path == '/')
    800039f2:	0004c783          	lbu	a5,0(s1)
    800039f6:	01279763          	bne	a5,s2,80003a04 <namex+0xb0>
    path++;
    800039fa:	0485                	addi	s1,s1,1
  while(*path == '/')
    800039fc:	0004c783          	lbu	a5,0(s1)
    80003a00:	ff278de3          	beq	a5,s2,800039fa <namex+0xa6>
    ilock(ip);
    80003a04:	8552                	mv	a0,s4
    80003a06:	a3fff0ef          	jal	80003444 <ilock>
    if(ip->type != T_DIR){
    80003a0a:	044a1783          	lh	a5,68(s4)
    80003a0e:	f9779be3          	bne	a5,s7,800039a4 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003a12:	000b0563          	beqz	s6,80003a1c <namex+0xc8>
    80003a16:	0004c783          	lbu	a5,0(s1)
    80003a1a:	d7dd                	beqz	a5,800039c8 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003a1c:	4601                	li	a2,0
    80003a1e:	85d6                	mv	a1,s5
    80003a20:	8552                	mv	a0,s4
    80003a22:	e97ff0ef          	jal	800038b8 <dirlookup>
    80003a26:	89aa                	mv	s3,a0
    80003a28:	d545                	beqz	a0,800039d0 <namex+0x7c>
    iunlockput(ip);
    80003a2a:	8552                	mv	a0,s4
    80003a2c:	c23ff0ef          	jal	8000364e <iunlockput>
    ip = next;
    80003a30:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003a32:	0004c783          	lbu	a5,0(s1)
    80003a36:	01279763          	bne	a5,s2,80003a44 <namex+0xf0>
    path++;
    80003a3a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003a3c:	0004c783          	lbu	a5,0(s1)
    80003a40:	ff278de3          	beq	a5,s2,80003a3a <namex+0xe6>
  if(*path == 0)
    80003a44:	cb8d                	beqz	a5,80003a76 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003a46:	0004c783          	lbu	a5,0(s1)
    80003a4a:	89a6                	mv	s3,s1
  len = path - s;
    80003a4c:	4c81                	li	s9,0
    80003a4e:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003a50:	01278963          	beq	a5,s2,80003a62 <namex+0x10e>
    80003a54:	d3d9                	beqz	a5,800039da <namex+0x86>
    path++;
    80003a56:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003a58:	0009c783          	lbu	a5,0(s3)
    80003a5c:	ff279ce3          	bne	a5,s2,80003a54 <namex+0x100>
    80003a60:	bfad                	j	800039da <namex+0x86>
    memmove(name, s, len);
    80003a62:	2601                	sext.w	a2,a2
    80003a64:	85a6                	mv	a1,s1
    80003a66:	8556                	mv	a0,s5
    80003a68:	acafd0ef          	jal	80000d32 <memmove>
    name[len] = 0;
    80003a6c:	9cd6                	add	s9,s9,s5
    80003a6e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003a72:	84ce                	mv	s1,s3
    80003a74:	bfbd                	j	800039f2 <namex+0x9e>
  if(nameiparent){
    80003a76:	f20b0be3          	beqz	s6,800039ac <namex+0x58>
    iput(ip);
    80003a7a:	8552                	mv	a0,s4
    80003a7c:	b4bff0ef          	jal	800035c6 <iput>
    return 0;
    80003a80:	4a01                	li	s4,0
    80003a82:	b72d                	j	800039ac <namex+0x58>

0000000080003a84 <dirlink>:
{
    80003a84:	7139                	addi	sp,sp,-64
    80003a86:	fc06                	sd	ra,56(sp)
    80003a88:	f822                	sd	s0,48(sp)
    80003a8a:	f04a                	sd	s2,32(sp)
    80003a8c:	ec4e                	sd	s3,24(sp)
    80003a8e:	e852                	sd	s4,16(sp)
    80003a90:	0080                	addi	s0,sp,64
    80003a92:	892a                	mv	s2,a0
    80003a94:	8a2e                	mv	s4,a1
    80003a96:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003a98:	4601                	li	a2,0
    80003a9a:	e1fff0ef          	jal	800038b8 <dirlookup>
    80003a9e:	e535                	bnez	a0,80003b0a <dirlink+0x86>
    80003aa0:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003aa2:	04c92483          	lw	s1,76(s2)
    80003aa6:	c48d                	beqz	s1,80003ad0 <dirlink+0x4c>
    80003aa8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003aaa:	4741                	li	a4,16
    80003aac:	86a6                	mv	a3,s1
    80003aae:	fc040613          	addi	a2,s0,-64
    80003ab2:	4581                	li	a1,0
    80003ab4:	854a                	mv	a0,s2
    80003ab6:	be3ff0ef          	jal	80003698 <readi>
    80003aba:	47c1                	li	a5,16
    80003abc:	04f51b63          	bne	a0,a5,80003b12 <dirlink+0x8e>
    if(de.inum == 0)
    80003ac0:	fc045783          	lhu	a5,-64(s0)
    80003ac4:	c791                	beqz	a5,80003ad0 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ac6:	24c1                	addiw	s1,s1,16
    80003ac8:	04c92783          	lw	a5,76(s2)
    80003acc:	fcf4efe3          	bltu	s1,a5,80003aaa <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003ad0:	4639                	li	a2,14
    80003ad2:	85d2                	mv	a1,s4
    80003ad4:	fc240513          	addi	a0,s0,-62
    80003ad8:	b00fd0ef          	jal	80000dd8 <strncpy>
  de.inum = inum;
    80003adc:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ae0:	4741                	li	a4,16
    80003ae2:	86a6                	mv	a3,s1
    80003ae4:	fc040613          	addi	a2,s0,-64
    80003ae8:	4581                	li	a1,0
    80003aea:	854a                	mv	a0,s2
    80003aec:	ca9ff0ef          	jal	80003794 <writei>
    80003af0:	1541                	addi	a0,a0,-16
    80003af2:	00a03533          	snez	a0,a0
    80003af6:	40a00533          	neg	a0,a0
    80003afa:	74a2                	ld	s1,40(sp)
}
    80003afc:	70e2                	ld	ra,56(sp)
    80003afe:	7442                	ld	s0,48(sp)
    80003b00:	7902                	ld	s2,32(sp)
    80003b02:	69e2                	ld	s3,24(sp)
    80003b04:	6a42                	ld	s4,16(sp)
    80003b06:	6121                	addi	sp,sp,64
    80003b08:	8082                	ret
    iput(ip);
    80003b0a:	abdff0ef          	jal	800035c6 <iput>
    return -1;
    80003b0e:	557d                	li	a0,-1
    80003b10:	b7f5                	j	80003afc <dirlink+0x78>
      panic("dirlink read");
    80003b12:	00004517          	auipc	a0,0x4
    80003b16:	a4650513          	addi	a0,a0,-1466 # 80007558 <etext+0x558>
    80003b1a:	c89fc0ef          	jal	800007a2 <panic>

0000000080003b1e <namei>:

struct inode*
namei(char *path)
{
    80003b1e:	1101                	addi	sp,sp,-32
    80003b20:	ec06                	sd	ra,24(sp)
    80003b22:	e822                	sd	s0,16(sp)
    80003b24:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003b26:	fe040613          	addi	a2,s0,-32
    80003b2a:	4581                	li	a1,0
    80003b2c:	e29ff0ef          	jal	80003954 <namex>
}
    80003b30:	60e2                	ld	ra,24(sp)
    80003b32:	6442                	ld	s0,16(sp)
    80003b34:	6105                	addi	sp,sp,32
    80003b36:	8082                	ret

0000000080003b38 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003b38:	1141                	addi	sp,sp,-16
    80003b3a:	e406                	sd	ra,8(sp)
    80003b3c:	e022                	sd	s0,0(sp)
    80003b3e:	0800                	addi	s0,sp,16
    80003b40:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003b42:	4585                	li	a1,1
    80003b44:	e11ff0ef          	jal	80003954 <namex>
}
    80003b48:	60a2                	ld	ra,8(sp)
    80003b4a:	6402                	ld	s0,0(sp)
    80003b4c:	0141                	addi	sp,sp,16
    80003b4e:	8082                	ret

0000000080003b50 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003b50:	1101                	addi	sp,sp,-32
    80003b52:	ec06                	sd	ra,24(sp)
    80003b54:	e822                	sd	s0,16(sp)
    80003b56:	e426                	sd	s1,8(sp)
    80003b58:	e04a                	sd	s2,0(sp)
    80003b5a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003b5c:	0001f917          	auipc	s2,0x1f
    80003b60:	bb490913          	addi	s2,s2,-1100 # 80022710 <log>
    80003b64:	01892583          	lw	a1,24(s2)
    80003b68:	02892503          	lw	a0,40(s2)
    80003b6c:	9a0ff0ef          	jal	80002d0c <bread>
    80003b70:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003b72:	02c92603          	lw	a2,44(s2)
    80003b76:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003b78:	00c05f63          	blez	a2,80003b96 <write_head+0x46>
    80003b7c:	0001f717          	auipc	a4,0x1f
    80003b80:	bc470713          	addi	a4,a4,-1084 # 80022740 <log+0x30>
    80003b84:	87aa                	mv	a5,a0
    80003b86:	060a                	slli	a2,a2,0x2
    80003b88:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003b8a:	4314                	lw	a3,0(a4)
    80003b8c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003b8e:	0711                	addi	a4,a4,4
    80003b90:	0791                	addi	a5,a5,4
    80003b92:	fec79ce3          	bne	a5,a2,80003b8a <write_head+0x3a>
  }
  bwrite(buf);
    80003b96:	8526                	mv	a0,s1
    80003b98:	a4aff0ef          	jal	80002de2 <bwrite>
  brelse(buf);
    80003b9c:	8526                	mv	a0,s1
    80003b9e:	a76ff0ef          	jal	80002e14 <brelse>
}
    80003ba2:	60e2                	ld	ra,24(sp)
    80003ba4:	6442                	ld	s0,16(sp)
    80003ba6:	64a2                	ld	s1,8(sp)
    80003ba8:	6902                	ld	s2,0(sp)
    80003baa:	6105                	addi	sp,sp,32
    80003bac:	8082                	ret

0000000080003bae <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bae:	0001f797          	auipc	a5,0x1f
    80003bb2:	b8e7a783          	lw	a5,-1138(a5) # 8002273c <log+0x2c>
    80003bb6:	08f05f63          	blez	a5,80003c54 <install_trans+0xa6>
{
    80003bba:	7139                	addi	sp,sp,-64
    80003bbc:	fc06                	sd	ra,56(sp)
    80003bbe:	f822                	sd	s0,48(sp)
    80003bc0:	f426                	sd	s1,40(sp)
    80003bc2:	f04a                	sd	s2,32(sp)
    80003bc4:	ec4e                	sd	s3,24(sp)
    80003bc6:	e852                	sd	s4,16(sp)
    80003bc8:	e456                	sd	s5,8(sp)
    80003bca:	e05a                	sd	s6,0(sp)
    80003bcc:	0080                	addi	s0,sp,64
    80003bce:	8b2a                	mv	s6,a0
    80003bd0:	0001fa97          	auipc	s5,0x1f
    80003bd4:	b70a8a93          	addi	s5,s5,-1168 # 80022740 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bd8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003bda:	0001f997          	auipc	s3,0x1f
    80003bde:	b3698993          	addi	s3,s3,-1226 # 80022710 <log>
    80003be2:	a829                	j	80003bfc <install_trans+0x4e>
    brelse(lbuf);
    80003be4:	854a                	mv	a0,s2
    80003be6:	a2eff0ef          	jal	80002e14 <brelse>
    brelse(dbuf);
    80003bea:	8526                	mv	a0,s1
    80003bec:	a28ff0ef          	jal	80002e14 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bf0:	2a05                	addiw	s4,s4,1
    80003bf2:	0a91                	addi	s5,s5,4
    80003bf4:	02c9a783          	lw	a5,44(s3)
    80003bf8:	04fa5463          	bge	s4,a5,80003c40 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003bfc:	0189a583          	lw	a1,24(s3)
    80003c00:	014585bb          	addw	a1,a1,s4
    80003c04:	2585                	addiw	a1,a1,1
    80003c06:	0289a503          	lw	a0,40(s3)
    80003c0a:	902ff0ef          	jal	80002d0c <bread>
    80003c0e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003c10:	000aa583          	lw	a1,0(s5)
    80003c14:	0289a503          	lw	a0,40(s3)
    80003c18:	8f4ff0ef          	jal	80002d0c <bread>
    80003c1c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003c1e:	40000613          	li	a2,1024
    80003c22:	05890593          	addi	a1,s2,88
    80003c26:	05850513          	addi	a0,a0,88
    80003c2a:	908fd0ef          	jal	80000d32 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003c2e:	8526                	mv	a0,s1
    80003c30:	9b2ff0ef          	jal	80002de2 <bwrite>
    if(recovering == 0)
    80003c34:	fa0b18e3          	bnez	s6,80003be4 <install_trans+0x36>
      bunpin(dbuf);
    80003c38:	8526                	mv	a0,s1
    80003c3a:	a96ff0ef          	jal	80002ed0 <bunpin>
    80003c3e:	b75d                	j	80003be4 <install_trans+0x36>
}
    80003c40:	70e2                	ld	ra,56(sp)
    80003c42:	7442                	ld	s0,48(sp)
    80003c44:	74a2                	ld	s1,40(sp)
    80003c46:	7902                	ld	s2,32(sp)
    80003c48:	69e2                	ld	s3,24(sp)
    80003c4a:	6a42                	ld	s4,16(sp)
    80003c4c:	6aa2                	ld	s5,8(sp)
    80003c4e:	6b02                	ld	s6,0(sp)
    80003c50:	6121                	addi	sp,sp,64
    80003c52:	8082                	ret
    80003c54:	8082                	ret

0000000080003c56 <initlog>:
{
    80003c56:	7179                	addi	sp,sp,-48
    80003c58:	f406                	sd	ra,40(sp)
    80003c5a:	f022                	sd	s0,32(sp)
    80003c5c:	ec26                	sd	s1,24(sp)
    80003c5e:	e84a                	sd	s2,16(sp)
    80003c60:	e44e                	sd	s3,8(sp)
    80003c62:	1800                	addi	s0,sp,48
    80003c64:	892a                	mv	s2,a0
    80003c66:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003c68:	0001f497          	auipc	s1,0x1f
    80003c6c:	aa848493          	addi	s1,s1,-1368 # 80022710 <log>
    80003c70:	00004597          	auipc	a1,0x4
    80003c74:	8f858593          	addi	a1,a1,-1800 # 80007568 <etext+0x568>
    80003c78:	8526                	mv	a0,s1
    80003c7a:	f09fc0ef          	jal	80000b82 <initlock>
  log.start = sb->logstart;
    80003c7e:	0149a583          	lw	a1,20(s3)
    80003c82:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003c84:	0109a783          	lw	a5,16(s3)
    80003c88:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003c8a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003c8e:	854a                	mv	a0,s2
    80003c90:	87cff0ef          	jal	80002d0c <bread>
  log.lh.n = lh->n;
    80003c94:	4d30                	lw	a2,88(a0)
    80003c96:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003c98:	00c05f63          	blez	a2,80003cb6 <initlog+0x60>
    80003c9c:	87aa                	mv	a5,a0
    80003c9e:	0001f717          	auipc	a4,0x1f
    80003ca2:	aa270713          	addi	a4,a4,-1374 # 80022740 <log+0x30>
    80003ca6:	060a                	slli	a2,a2,0x2
    80003ca8:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003caa:	4ff4                	lw	a3,92(a5)
    80003cac:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003cae:	0791                	addi	a5,a5,4
    80003cb0:	0711                	addi	a4,a4,4
    80003cb2:	fec79ce3          	bne	a5,a2,80003caa <initlog+0x54>
  brelse(buf);
    80003cb6:	95eff0ef          	jal	80002e14 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003cba:	4505                	li	a0,1
    80003cbc:	ef3ff0ef          	jal	80003bae <install_trans>
  log.lh.n = 0;
    80003cc0:	0001f797          	auipc	a5,0x1f
    80003cc4:	a607ae23          	sw	zero,-1412(a5) # 8002273c <log+0x2c>
  write_head(); // clear the log
    80003cc8:	e89ff0ef          	jal	80003b50 <write_head>
}
    80003ccc:	70a2                	ld	ra,40(sp)
    80003cce:	7402                	ld	s0,32(sp)
    80003cd0:	64e2                	ld	s1,24(sp)
    80003cd2:	6942                	ld	s2,16(sp)
    80003cd4:	69a2                	ld	s3,8(sp)
    80003cd6:	6145                	addi	sp,sp,48
    80003cd8:	8082                	ret

0000000080003cda <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003cda:	1101                	addi	sp,sp,-32
    80003cdc:	ec06                	sd	ra,24(sp)
    80003cde:	e822                	sd	s0,16(sp)
    80003ce0:	e426                	sd	s1,8(sp)
    80003ce2:	e04a                	sd	s2,0(sp)
    80003ce4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003ce6:	0001f517          	auipc	a0,0x1f
    80003cea:	a2a50513          	addi	a0,a0,-1494 # 80022710 <log>
    80003cee:	f15fc0ef          	jal	80000c02 <acquire>
  while(1){
    if(log.committing){
    80003cf2:	0001f497          	auipc	s1,0x1f
    80003cf6:	a1e48493          	addi	s1,s1,-1506 # 80022710 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003cfa:	4979                	li	s2,30
    80003cfc:	a029                	j	80003d06 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003cfe:	85a6                	mv	a1,s1
    80003d00:	8526                	mv	a0,s1
    80003d02:	b40fe0ef          	jal	80002042 <sleep>
    if(log.committing){
    80003d06:	50dc                	lw	a5,36(s1)
    80003d08:	fbfd                	bnez	a5,80003cfe <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003d0a:	5098                	lw	a4,32(s1)
    80003d0c:	2705                	addiw	a4,a4,1
    80003d0e:	0027179b          	slliw	a5,a4,0x2
    80003d12:	9fb9                	addw	a5,a5,a4
    80003d14:	0017979b          	slliw	a5,a5,0x1
    80003d18:	54d4                	lw	a3,44(s1)
    80003d1a:	9fb5                	addw	a5,a5,a3
    80003d1c:	00f95763          	bge	s2,a5,80003d2a <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003d20:	85a6                	mv	a1,s1
    80003d22:	8526                	mv	a0,s1
    80003d24:	b1efe0ef          	jal	80002042 <sleep>
    80003d28:	bff9                	j	80003d06 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003d2a:	0001f517          	auipc	a0,0x1f
    80003d2e:	9e650513          	addi	a0,a0,-1562 # 80022710 <log>
    80003d32:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003d34:	f67fc0ef          	jal	80000c9a <release>
      break;
    }
  }
}
    80003d38:	60e2                	ld	ra,24(sp)
    80003d3a:	6442                	ld	s0,16(sp)
    80003d3c:	64a2                	ld	s1,8(sp)
    80003d3e:	6902                	ld	s2,0(sp)
    80003d40:	6105                	addi	sp,sp,32
    80003d42:	8082                	ret

0000000080003d44 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003d44:	7139                	addi	sp,sp,-64
    80003d46:	fc06                	sd	ra,56(sp)
    80003d48:	f822                	sd	s0,48(sp)
    80003d4a:	f426                	sd	s1,40(sp)
    80003d4c:	f04a                	sd	s2,32(sp)
    80003d4e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003d50:	0001f497          	auipc	s1,0x1f
    80003d54:	9c048493          	addi	s1,s1,-1600 # 80022710 <log>
    80003d58:	8526                	mv	a0,s1
    80003d5a:	ea9fc0ef          	jal	80000c02 <acquire>
  log.outstanding -= 1;
    80003d5e:	509c                	lw	a5,32(s1)
    80003d60:	37fd                	addiw	a5,a5,-1
    80003d62:	0007891b          	sext.w	s2,a5
    80003d66:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003d68:	50dc                	lw	a5,36(s1)
    80003d6a:	ef9d                	bnez	a5,80003da8 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003d6c:	04091763          	bnez	s2,80003dba <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003d70:	0001f497          	auipc	s1,0x1f
    80003d74:	9a048493          	addi	s1,s1,-1632 # 80022710 <log>
    80003d78:	4785                	li	a5,1
    80003d7a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003d7c:	8526                	mv	a0,s1
    80003d7e:	f1dfc0ef          	jal	80000c9a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003d82:	54dc                	lw	a5,44(s1)
    80003d84:	04f04b63          	bgtz	a5,80003dda <end_op+0x96>
    acquire(&log.lock);
    80003d88:	0001f497          	auipc	s1,0x1f
    80003d8c:	98848493          	addi	s1,s1,-1656 # 80022710 <log>
    80003d90:	8526                	mv	a0,s1
    80003d92:	e71fc0ef          	jal	80000c02 <acquire>
    log.committing = 0;
    80003d96:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003d9a:	8526                	mv	a0,s1
    80003d9c:	af2fe0ef          	jal	8000208e <wakeup>
    release(&log.lock);
    80003da0:	8526                	mv	a0,s1
    80003da2:	ef9fc0ef          	jal	80000c9a <release>
}
    80003da6:	a025                	j	80003dce <end_op+0x8a>
    80003da8:	ec4e                	sd	s3,24(sp)
    80003daa:	e852                	sd	s4,16(sp)
    80003dac:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003dae:	00003517          	auipc	a0,0x3
    80003db2:	7c250513          	addi	a0,a0,1986 # 80007570 <etext+0x570>
    80003db6:	9edfc0ef          	jal	800007a2 <panic>
    wakeup(&log);
    80003dba:	0001f497          	auipc	s1,0x1f
    80003dbe:	95648493          	addi	s1,s1,-1706 # 80022710 <log>
    80003dc2:	8526                	mv	a0,s1
    80003dc4:	acafe0ef          	jal	8000208e <wakeup>
  release(&log.lock);
    80003dc8:	8526                	mv	a0,s1
    80003dca:	ed1fc0ef          	jal	80000c9a <release>
}
    80003dce:	70e2                	ld	ra,56(sp)
    80003dd0:	7442                	ld	s0,48(sp)
    80003dd2:	74a2                	ld	s1,40(sp)
    80003dd4:	7902                	ld	s2,32(sp)
    80003dd6:	6121                	addi	sp,sp,64
    80003dd8:	8082                	ret
    80003dda:	ec4e                	sd	s3,24(sp)
    80003ddc:	e852                	sd	s4,16(sp)
    80003dde:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003de0:	0001fa97          	auipc	s5,0x1f
    80003de4:	960a8a93          	addi	s5,s5,-1696 # 80022740 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003de8:	0001fa17          	auipc	s4,0x1f
    80003dec:	928a0a13          	addi	s4,s4,-1752 # 80022710 <log>
    80003df0:	018a2583          	lw	a1,24(s4)
    80003df4:	012585bb          	addw	a1,a1,s2
    80003df8:	2585                	addiw	a1,a1,1
    80003dfa:	028a2503          	lw	a0,40(s4)
    80003dfe:	f0ffe0ef          	jal	80002d0c <bread>
    80003e02:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003e04:	000aa583          	lw	a1,0(s5)
    80003e08:	028a2503          	lw	a0,40(s4)
    80003e0c:	f01fe0ef          	jal	80002d0c <bread>
    80003e10:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003e12:	40000613          	li	a2,1024
    80003e16:	05850593          	addi	a1,a0,88
    80003e1a:	05848513          	addi	a0,s1,88
    80003e1e:	f15fc0ef          	jal	80000d32 <memmove>
    bwrite(to);  // write the log
    80003e22:	8526                	mv	a0,s1
    80003e24:	fbffe0ef          	jal	80002de2 <bwrite>
    brelse(from);
    80003e28:	854e                	mv	a0,s3
    80003e2a:	febfe0ef          	jal	80002e14 <brelse>
    brelse(to);
    80003e2e:	8526                	mv	a0,s1
    80003e30:	fe5fe0ef          	jal	80002e14 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e34:	2905                	addiw	s2,s2,1
    80003e36:	0a91                	addi	s5,s5,4
    80003e38:	02ca2783          	lw	a5,44(s4)
    80003e3c:	faf94ae3          	blt	s2,a5,80003df0 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003e40:	d11ff0ef          	jal	80003b50 <write_head>
    install_trans(0); // Now install writes to home locations
    80003e44:	4501                	li	a0,0
    80003e46:	d69ff0ef          	jal	80003bae <install_trans>
    log.lh.n = 0;
    80003e4a:	0001f797          	auipc	a5,0x1f
    80003e4e:	8e07a923          	sw	zero,-1806(a5) # 8002273c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003e52:	cffff0ef          	jal	80003b50 <write_head>
    80003e56:	69e2                	ld	s3,24(sp)
    80003e58:	6a42                	ld	s4,16(sp)
    80003e5a:	6aa2                	ld	s5,8(sp)
    80003e5c:	b735                	j	80003d88 <end_op+0x44>

0000000080003e5e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003e5e:	1101                	addi	sp,sp,-32
    80003e60:	ec06                	sd	ra,24(sp)
    80003e62:	e822                	sd	s0,16(sp)
    80003e64:	e426                	sd	s1,8(sp)
    80003e66:	e04a                	sd	s2,0(sp)
    80003e68:	1000                	addi	s0,sp,32
    80003e6a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003e6c:	0001f917          	auipc	s2,0x1f
    80003e70:	8a490913          	addi	s2,s2,-1884 # 80022710 <log>
    80003e74:	854a                	mv	a0,s2
    80003e76:	d8dfc0ef          	jal	80000c02 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003e7a:	02c92603          	lw	a2,44(s2)
    80003e7e:	47f5                	li	a5,29
    80003e80:	06c7c363          	blt	a5,a2,80003ee6 <log_write+0x88>
    80003e84:	0001f797          	auipc	a5,0x1f
    80003e88:	8a87a783          	lw	a5,-1880(a5) # 8002272c <log+0x1c>
    80003e8c:	37fd                	addiw	a5,a5,-1
    80003e8e:	04f65c63          	bge	a2,a5,80003ee6 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003e92:	0001f797          	auipc	a5,0x1f
    80003e96:	89e7a783          	lw	a5,-1890(a5) # 80022730 <log+0x20>
    80003e9a:	04f05c63          	blez	a5,80003ef2 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003e9e:	4781                	li	a5,0
    80003ea0:	04c05f63          	blez	a2,80003efe <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003ea4:	44cc                	lw	a1,12(s1)
    80003ea6:	0001f717          	auipc	a4,0x1f
    80003eaa:	89a70713          	addi	a4,a4,-1894 # 80022740 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003eae:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003eb0:	4314                	lw	a3,0(a4)
    80003eb2:	04b68663          	beq	a3,a1,80003efe <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003eb6:	2785                	addiw	a5,a5,1
    80003eb8:	0711                	addi	a4,a4,4
    80003eba:	fef61be3          	bne	a2,a5,80003eb0 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003ebe:	0621                	addi	a2,a2,8
    80003ec0:	060a                	slli	a2,a2,0x2
    80003ec2:	0001f797          	auipc	a5,0x1f
    80003ec6:	84e78793          	addi	a5,a5,-1970 # 80022710 <log>
    80003eca:	97b2                	add	a5,a5,a2
    80003ecc:	44d8                	lw	a4,12(s1)
    80003ece:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003ed0:	8526                	mv	a0,s1
    80003ed2:	fcbfe0ef          	jal	80002e9c <bpin>
    log.lh.n++;
    80003ed6:	0001f717          	auipc	a4,0x1f
    80003eda:	83a70713          	addi	a4,a4,-1990 # 80022710 <log>
    80003ede:	575c                	lw	a5,44(a4)
    80003ee0:	2785                	addiw	a5,a5,1
    80003ee2:	d75c                	sw	a5,44(a4)
    80003ee4:	a80d                	j	80003f16 <log_write+0xb8>
    panic("too big a transaction");
    80003ee6:	00003517          	auipc	a0,0x3
    80003eea:	69a50513          	addi	a0,a0,1690 # 80007580 <etext+0x580>
    80003eee:	8b5fc0ef          	jal	800007a2 <panic>
    panic("log_write outside of trans");
    80003ef2:	00003517          	auipc	a0,0x3
    80003ef6:	6a650513          	addi	a0,a0,1702 # 80007598 <etext+0x598>
    80003efa:	8a9fc0ef          	jal	800007a2 <panic>
  log.lh.block[i] = b->blockno;
    80003efe:	00878693          	addi	a3,a5,8
    80003f02:	068a                	slli	a3,a3,0x2
    80003f04:	0001f717          	auipc	a4,0x1f
    80003f08:	80c70713          	addi	a4,a4,-2036 # 80022710 <log>
    80003f0c:	9736                	add	a4,a4,a3
    80003f0e:	44d4                	lw	a3,12(s1)
    80003f10:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003f12:	faf60fe3          	beq	a2,a5,80003ed0 <log_write+0x72>
  }
  release(&log.lock);
    80003f16:	0001e517          	auipc	a0,0x1e
    80003f1a:	7fa50513          	addi	a0,a0,2042 # 80022710 <log>
    80003f1e:	d7dfc0ef          	jal	80000c9a <release>
}
    80003f22:	60e2                	ld	ra,24(sp)
    80003f24:	6442                	ld	s0,16(sp)
    80003f26:	64a2                	ld	s1,8(sp)
    80003f28:	6902                	ld	s2,0(sp)
    80003f2a:	6105                	addi	sp,sp,32
    80003f2c:	8082                	ret

0000000080003f2e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003f2e:	1101                	addi	sp,sp,-32
    80003f30:	ec06                	sd	ra,24(sp)
    80003f32:	e822                	sd	s0,16(sp)
    80003f34:	e426                	sd	s1,8(sp)
    80003f36:	e04a                	sd	s2,0(sp)
    80003f38:	1000                	addi	s0,sp,32
    80003f3a:	84aa                	mv	s1,a0
    80003f3c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003f3e:	00003597          	auipc	a1,0x3
    80003f42:	67a58593          	addi	a1,a1,1658 # 800075b8 <etext+0x5b8>
    80003f46:	0521                	addi	a0,a0,8
    80003f48:	c3bfc0ef          	jal	80000b82 <initlock>
  lk->name = name;
    80003f4c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003f50:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003f54:	0204a423          	sw	zero,40(s1)
}
    80003f58:	60e2                	ld	ra,24(sp)
    80003f5a:	6442                	ld	s0,16(sp)
    80003f5c:	64a2                	ld	s1,8(sp)
    80003f5e:	6902                	ld	s2,0(sp)
    80003f60:	6105                	addi	sp,sp,32
    80003f62:	8082                	ret

0000000080003f64 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003f64:	1101                	addi	sp,sp,-32
    80003f66:	ec06                	sd	ra,24(sp)
    80003f68:	e822                	sd	s0,16(sp)
    80003f6a:	e426                	sd	s1,8(sp)
    80003f6c:	e04a                	sd	s2,0(sp)
    80003f6e:	1000                	addi	s0,sp,32
    80003f70:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003f72:	00850913          	addi	s2,a0,8
    80003f76:	854a                	mv	a0,s2
    80003f78:	c8bfc0ef          	jal	80000c02 <acquire>
  while (lk->locked) {
    80003f7c:	409c                	lw	a5,0(s1)
    80003f7e:	c799                	beqz	a5,80003f8c <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003f80:	85ca                	mv	a1,s2
    80003f82:	8526                	mv	a0,s1
    80003f84:	8befe0ef          	jal	80002042 <sleep>
  while (lk->locked) {
    80003f88:	409c                	lw	a5,0(s1)
    80003f8a:	fbfd                	bnez	a5,80003f80 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003f8c:	4785                	li	a5,1
    80003f8e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003f90:	971fd0ef          	jal	80001900 <myproc>
    80003f94:	591c                	lw	a5,48(a0)
    80003f96:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003f98:	854a                	mv	a0,s2
    80003f9a:	d01fc0ef          	jal	80000c9a <release>
}
    80003f9e:	60e2                	ld	ra,24(sp)
    80003fa0:	6442                	ld	s0,16(sp)
    80003fa2:	64a2                	ld	s1,8(sp)
    80003fa4:	6902                	ld	s2,0(sp)
    80003fa6:	6105                	addi	sp,sp,32
    80003fa8:	8082                	ret

0000000080003faa <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003faa:	1101                	addi	sp,sp,-32
    80003fac:	ec06                	sd	ra,24(sp)
    80003fae:	e822                	sd	s0,16(sp)
    80003fb0:	e426                	sd	s1,8(sp)
    80003fb2:	e04a                	sd	s2,0(sp)
    80003fb4:	1000                	addi	s0,sp,32
    80003fb6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003fb8:	00850913          	addi	s2,a0,8
    80003fbc:	854a                	mv	a0,s2
    80003fbe:	c45fc0ef          	jal	80000c02 <acquire>
  lk->locked = 0;
    80003fc2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003fc6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003fca:	8526                	mv	a0,s1
    80003fcc:	8c2fe0ef          	jal	8000208e <wakeup>
  release(&lk->lk);
    80003fd0:	854a                	mv	a0,s2
    80003fd2:	cc9fc0ef          	jal	80000c9a <release>
}
    80003fd6:	60e2                	ld	ra,24(sp)
    80003fd8:	6442                	ld	s0,16(sp)
    80003fda:	64a2                	ld	s1,8(sp)
    80003fdc:	6902                	ld	s2,0(sp)
    80003fde:	6105                	addi	sp,sp,32
    80003fe0:	8082                	ret

0000000080003fe2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003fe2:	7179                	addi	sp,sp,-48
    80003fe4:	f406                	sd	ra,40(sp)
    80003fe6:	f022                	sd	s0,32(sp)
    80003fe8:	ec26                	sd	s1,24(sp)
    80003fea:	e84a                	sd	s2,16(sp)
    80003fec:	1800                	addi	s0,sp,48
    80003fee:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003ff0:	00850913          	addi	s2,a0,8
    80003ff4:	854a                	mv	a0,s2
    80003ff6:	c0dfc0ef          	jal	80000c02 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ffa:	409c                	lw	a5,0(s1)
    80003ffc:	ef81                	bnez	a5,80004014 <holdingsleep+0x32>
    80003ffe:	4481                	li	s1,0
  release(&lk->lk);
    80004000:	854a                	mv	a0,s2
    80004002:	c99fc0ef          	jal	80000c9a <release>
  return r;
}
    80004006:	8526                	mv	a0,s1
    80004008:	70a2                	ld	ra,40(sp)
    8000400a:	7402                	ld	s0,32(sp)
    8000400c:	64e2                	ld	s1,24(sp)
    8000400e:	6942                	ld	s2,16(sp)
    80004010:	6145                	addi	sp,sp,48
    80004012:	8082                	ret
    80004014:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004016:	0284a983          	lw	s3,40(s1)
    8000401a:	8e7fd0ef          	jal	80001900 <myproc>
    8000401e:	5904                	lw	s1,48(a0)
    80004020:	413484b3          	sub	s1,s1,s3
    80004024:	0014b493          	seqz	s1,s1
    80004028:	69a2                	ld	s3,8(sp)
    8000402a:	bfd9                	j	80004000 <holdingsleep+0x1e>

000000008000402c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000402c:	1141                	addi	sp,sp,-16
    8000402e:	e406                	sd	ra,8(sp)
    80004030:	e022                	sd	s0,0(sp)
    80004032:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004034:	00003597          	auipc	a1,0x3
    80004038:	59458593          	addi	a1,a1,1428 # 800075c8 <etext+0x5c8>
    8000403c:	0001f517          	auipc	a0,0x1f
    80004040:	81c50513          	addi	a0,a0,-2020 # 80022858 <ftable>
    80004044:	b3ffc0ef          	jal	80000b82 <initlock>
}
    80004048:	60a2                	ld	ra,8(sp)
    8000404a:	6402                	ld	s0,0(sp)
    8000404c:	0141                	addi	sp,sp,16
    8000404e:	8082                	ret

0000000080004050 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004050:	1101                	addi	sp,sp,-32
    80004052:	ec06                	sd	ra,24(sp)
    80004054:	e822                	sd	s0,16(sp)
    80004056:	e426                	sd	s1,8(sp)
    80004058:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000405a:	0001e517          	auipc	a0,0x1e
    8000405e:	7fe50513          	addi	a0,a0,2046 # 80022858 <ftable>
    80004062:	ba1fc0ef          	jal	80000c02 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004066:	0001f497          	auipc	s1,0x1f
    8000406a:	80a48493          	addi	s1,s1,-2038 # 80022870 <ftable+0x18>
    8000406e:	0001f717          	auipc	a4,0x1f
    80004072:	7a270713          	addi	a4,a4,1954 # 80023810 <disk>
    if(f->ref == 0){
    80004076:	40dc                	lw	a5,4(s1)
    80004078:	cf89                	beqz	a5,80004092 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000407a:	02848493          	addi	s1,s1,40
    8000407e:	fee49ce3          	bne	s1,a4,80004076 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004082:	0001e517          	auipc	a0,0x1e
    80004086:	7d650513          	addi	a0,a0,2006 # 80022858 <ftable>
    8000408a:	c11fc0ef          	jal	80000c9a <release>
  return 0;
    8000408e:	4481                	li	s1,0
    80004090:	a809                	j	800040a2 <filealloc+0x52>
      f->ref = 1;
    80004092:	4785                	li	a5,1
    80004094:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004096:	0001e517          	auipc	a0,0x1e
    8000409a:	7c250513          	addi	a0,a0,1986 # 80022858 <ftable>
    8000409e:	bfdfc0ef          	jal	80000c9a <release>
}
    800040a2:	8526                	mv	a0,s1
    800040a4:	60e2                	ld	ra,24(sp)
    800040a6:	6442                	ld	s0,16(sp)
    800040a8:	64a2                	ld	s1,8(sp)
    800040aa:	6105                	addi	sp,sp,32
    800040ac:	8082                	ret

00000000800040ae <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800040ae:	1101                	addi	sp,sp,-32
    800040b0:	ec06                	sd	ra,24(sp)
    800040b2:	e822                	sd	s0,16(sp)
    800040b4:	e426                	sd	s1,8(sp)
    800040b6:	1000                	addi	s0,sp,32
    800040b8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800040ba:	0001e517          	auipc	a0,0x1e
    800040be:	79e50513          	addi	a0,a0,1950 # 80022858 <ftable>
    800040c2:	b41fc0ef          	jal	80000c02 <acquire>
  if(f->ref < 1)
    800040c6:	40dc                	lw	a5,4(s1)
    800040c8:	02f05063          	blez	a5,800040e8 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800040cc:	2785                	addiw	a5,a5,1
    800040ce:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800040d0:	0001e517          	auipc	a0,0x1e
    800040d4:	78850513          	addi	a0,a0,1928 # 80022858 <ftable>
    800040d8:	bc3fc0ef          	jal	80000c9a <release>
  return f;
}
    800040dc:	8526                	mv	a0,s1
    800040de:	60e2                	ld	ra,24(sp)
    800040e0:	6442                	ld	s0,16(sp)
    800040e2:	64a2                	ld	s1,8(sp)
    800040e4:	6105                	addi	sp,sp,32
    800040e6:	8082                	ret
    panic("filedup");
    800040e8:	00003517          	auipc	a0,0x3
    800040ec:	4e850513          	addi	a0,a0,1256 # 800075d0 <etext+0x5d0>
    800040f0:	eb2fc0ef          	jal	800007a2 <panic>

00000000800040f4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800040f4:	7139                	addi	sp,sp,-64
    800040f6:	fc06                	sd	ra,56(sp)
    800040f8:	f822                	sd	s0,48(sp)
    800040fa:	f426                	sd	s1,40(sp)
    800040fc:	0080                	addi	s0,sp,64
    800040fe:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004100:	0001e517          	auipc	a0,0x1e
    80004104:	75850513          	addi	a0,a0,1880 # 80022858 <ftable>
    80004108:	afbfc0ef          	jal	80000c02 <acquire>
  if(f->ref < 1)
    8000410c:	40dc                	lw	a5,4(s1)
    8000410e:	04f05a63          	blez	a5,80004162 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80004112:	37fd                	addiw	a5,a5,-1
    80004114:	0007871b          	sext.w	a4,a5
    80004118:	c0dc                	sw	a5,4(s1)
    8000411a:	04e04e63          	bgtz	a4,80004176 <fileclose+0x82>
    8000411e:	f04a                	sd	s2,32(sp)
    80004120:	ec4e                	sd	s3,24(sp)
    80004122:	e852                	sd	s4,16(sp)
    80004124:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004126:	0004a903          	lw	s2,0(s1)
    8000412a:	0094ca83          	lbu	s5,9(s1)
    8000412e:	0104ba03          	ld	s4,16(s1)
    80004132:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004136:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000413a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000413e:	0001e517          	auipc	a0,0x1e
    80004142:	71a50513          	addi	a0,a0,1818 # 80022858 <ftable>
    80004146:	b55fc0ef          	jal	80000c9a <release>

  if(ff.type == FD_PIPE){
    8000414a:	4785                	li	a5,1
    8000414c:	04f90063          	beq	s2,a5,8000418c <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004150:	3979                	addiw	s2,s2,-2
    80004152:	4785                	li	a5,1
    80004154:	0527f563          	bgeu	a5,s2,8000419e <fileclose+0xaa>
    80004158:	7902                	ld	s2,32(sp)
    8000415a:	69e2                	ld	s3,24(sp)
    8000415c:	6a42                	ld	s4,16(sp)
    8000415e:	6aa2                	ld	s5,8(sp)
    80004160:	a00d                	j	80004182 <fileclose+0x8e>
    80004162:	f04a                	sd	s2,32(sp)
    80004164:	ec4e                	sd	s3,24(sp)
    80004166:	e852                	sd	s4,16(sp)
    80004168:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000416a:	00003517          	auipc	a0,0x3
    8000416e:	46e50513          	addi	a0,a0,1134 # 800075d8 <etext+0x5d8>
    80004172:	e30fc0ef          	jal	800007a2 <panic>
    release(&ftable.lock);
    80004176:	0001e517          	auipc	a0,0x1e
    8000417a:	6e250513          	addi	a0,a0,1762 # 80022858 <ftable>
    8000417e:	b1dfc0ef          	jal	80000c9a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004182:	70e2                	ld	ra,56(sp)
    80004184:	7442                	ld	s0,48(sp)
    80004186:	74a2                	ld	s1,40(sp)
    80004188:	6121                	addi	sp,sp,64
    8000418a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000418c:	85d6                	mv	a1,s5
    8000418e:	8552                	mv	a0,s4
    80004190:	336000ef          	jal	800044c6 <pipeclose>
    80004194:	7902                	ld	s2,32(sp)
    80004196:	69e2                	ld	s3,24(sp)
    80004198:	6a42                	ld	s4,16(sp)
    8000419a:	6aa2                	ld	s5,8(sp)
    8000419c:	b7dd                	j	80004182 <fileclose+0x8e>
    begin_op();
    8000419e:	b3dff0ef          	jal	80003cda <begin_op>
    iput(ff.ip);
    800041a2:	854e                	mv	a0,s3
    800041a4:	c22ff0ef          	jal	800035c6 <iput>
    end_op();
    800041a8:	b9dff0ef          	jal	80003d44 <end_op>
    800041ac:	7902                	ld	s2,32(sp)
    800041ae:	69e2                	ld	s3,24(sp)
    800041b0:	6a42                	ld	s4,16(sp)
    800041b2:	6aa2                	ld	s5,8(sp)
    800041b4:	b7f9                	j	80004182 <fileclose+0x8e>

00000000800041b6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800041b6:	715d                	addi	sp,sp,-80
    800041b8:	e486                	sd	ra,72(sp)
    800041ba:	e0a2                	sd	s0,64(sp)
    800041bc:	fc26                	sd	s1,56(sp)
    800041be:	f44e                	sd	s3,40(sp)
    800041c0:	0880                	addi	s0,sp,80
    800041c2:	84aa                	mv	s1,a0
    800041c4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800041c6:	f3afd0ef          	jal	80001900 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800041ca:	409c                	lw	a5,0(s1)
    800041cc:	37f9                	addiw	a5,a5,-2
    800041ce:	4705                	li	a4,1
    800041d0:	04f76063          	bltu	a4,a5,80004210 <filestat+0x5a>
    800041d4:	f84a                	sd	s2,48(sp)
    800041d6:	892a                	mv	s2,a0
    ilock(f->ip);
    800041d8:	6c88                	ld	a0,24(s1)
    800041da:	a6aff0ef          	jal	80003444 <ilock>
    stati(f->ip, &st);
    800041de:	fb840593          	addi	a1,s0,-72
    800041e2:	6c88                	ld	a0,24(s1)
    800041e4:	c8aff0ef          	jal	8000366e <stati>
    iunlock(f->ip);
    800041e8:	6c88                	ld	a0,24(s1)
    800041ea:	b08ff0ef          	jal	800034f2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800041ee:	46e1                	li	a3,24
    800041f0:	fb840613          	addi	a2,s0,-72
    800041f4:	85ce                	mv	a1,s3
    800041f6:	05093503          	ld	a0,80(s2)
    800041fa:	b78fd0ef          	jal	80001572 <copyout>
    800041fe:	41f5551b          	sraiw	a0,a0,0x1f
    80004202:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004204:	60a6                	ld	ra,72(sp)
    80004206:	6406                	ld	s0,64(sp)
    80004208:	74e2                	ld	s1,56(sp)
    8000420a:	79a2                	ld	s3,40(sp)
    8000420c:	6161                	addi	sp,sp,80
    8000420e:	8082                	ret
  return -1;
    80004210:	557d                	li	a0,-1
    80004212:	bfcd                	j	80004204 <filestat+0x4e>

0000000080004214 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004214:	7179                	addi	sp,sp,-48
    80004216:	f406                	sd	ra,40(sp)
    80004218:	f022                	sd	s0,32(sp)
    8000421a:	e84a                	sd	s2,16(sp)
    8000421c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000421e:	00854783          	lbu	a5,8(a0)
    80004222:	cfd1                	beqz	a5,800042be <fileread+0xaa>
    80004224:	ec26                	sd	s1,24(sp)
    80004226:	e44e                	sd	s3,8(sp)
    80004228:	84aa                	mv	s1,a0
    8000422a:	89ae                	mv	s3,a1
    8000422c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000422e:	411c                	lw	a5,0(a0)
    80004230:	4705                	li	a4,1
    80004232:	04e78363          	beq	a5,a4,80004278 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004236:	470d                	li	a4,3
    80004238:	04e78763          	beq	a5,a4,80004286 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000423c:	4709                	li	a4,2
    8000423e:	06e79a63          	bne	a5,a4,800042b2 <fileread+0x9e>
    ilock(f->ip);
    80004242:	6d08                	ld	a0,24(a0)
    80004244:	a00ff0ef          	jal	80003444 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004248:	874a                	mv	a4,s2
    8000424a:	5094                	lw	a3,32(s1)
    8000424c:	864e                	mv	a2,s3
    8000424e:	4585                	li	a1,1
    80004250:	6c88                	ld	a0,24(s1)
    80004252:	c46ff0ef          	jal	80003698 <readi>
    80004256:	892a                	mv	s2,a0
    80004258:	00a05563          	blez	a0,80004262 <fileread+0x4e>
      f->off += r;
    8000425c:	509c                	lw	a5,32(s1)
    8000425e:	9fa9                	addw	a5,a5,a0
    80004260:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004262:	6c88                	ld	a0,24(s1)
    80004264:	a8eff0ef          	jal	800034f2 <iunlock>
    80004268:	64e2                	ld	s1,24(sp)
    8000426a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000426c:	854a                	mv	a0,s2
    8000426e:	70a2                	ld	ra,40(sp)
    80004270:	7402                	ld	s0,32(sp)
    80004272:	6942                	ld	s2,16(sp)
    80004274:	6145                	addi	sp,sp,48
    80004276:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004278:	6908                	ld	a0,16(a0)
    8000427a:	388000ef          	jal	80004602 <piperead>
    8000427e:	892a                	mv	s2,a0
    80004280:	64e2                	ld	s1,24(sp)
    80004282:	69a2                	ld	s3,8(sp)
    80004284:	b7e5                	j	8000426c <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004286:	02451783          	lh	a5,36(a0)
    8000428a:	03079693          	slli	a3,a5,0x30
    8000428e:	92c1                	srli	a3,a3,0x30
    80004290:	4725                	li	a4,9
    80004292:	02d76863          	bltu	a4,a3,800042c2 <fileread+0xae>
    80004296:	0792                	slli	a5,a5,0x4
    80004298:	0001e717          	auipc	a4,0x1e
    8000429c:	52070713          	addi	a4,a4,1312 # 800227b8 <devsw>
    800042a0:	97ba                	add	a5,a5,a4
    800042a2:	639c                	ld	a5,0(a5)
    800042a4:	c39d                	beqz	a5,800042ca <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800042a6:	4505                	li	a0,1
    800042a8:	9782                	jalr	a5
    800042aa:	892a                	mv	s2,a0
    800042ac:	64e2                	ld	s1,24(sp)
    800042ae:	69a2                	ld	s3,8(sp)
    800042b0:	bf75                	j	8000426c <fileread+0x58>
    panic("fileread");
    800042b2:	00003517          	auipc	a0,0x3
    800042b6:	33650513          	addi	a0,a0,822 # 800075e8 <etext+0x5e8>
    800042ba:	ce8fc0ef          	jal	800007a2 <panic>
    return -1;
    800042be:	597d                	li	s2,-1
    800042c0:	b775                	j	8000426c <fileread+0x58>
      return -1;
    800042c2:	597d                	li	s2,-1
    800042c4:	64e2                	ld	s1,24(sp)
    800042c6:	69a2                	ld	s3,8(sp)
    800042c8:	b755                	j	8000426c <fileread+0x58>
    800042ca:	597d                	li	s2,-1
    800042cc:	64e2                	ld	s1,24(sp)
    800042ce:	69a2                	ld	s3,8(sp)
    800042d0:	bf71                	j	8000426c <fileread+0x58>

00000000800042d2 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800042d2:	00954783          	lbu	a5,9(a0)
    800042d6:	10078b63          	beqz	a5,800043ec <filewrite+0x11a>
{
    800042da:	715d                	addi	sp,sp,-80
    800042dc:	e486                	sd	ra,72(sp)
    800042de:	e0a2                	sd	s0,64(sp)
    800042e0:	f84a                	sd	s2,48(sp)
    800042e2:	f052                	sd	s4,32(sp)
    800042e4:	e85a                	sd	s6,16(sp)
    800042e6:	0880                	addi	s0,sp,80
    800042e8:	892a                	mv	s2,a0
    800042ea:	8b2e                	mv	s6,a1
    800042ec:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800042ee:	411c                	lw	a5,0(a0)
    800042f0:	4705                	li	a4,1
    800042f2:	02e78763          	beq	a5,a4,80004320 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800042f6:	470d                	li	a4,3
    800042f8:	02e78863          	beq	a5,a4,80004328 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800042fc:	4709                	li	a4,2
    800042fe:	0ce79c63          	bne	a5,a4,800043d6 <filewrite+0x104>
    80004302:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004304:	0ac05863          	blez	a2,800043b4 <filewrite+0xe2>
    80004308:	fc26                	sd	s1,56(sp)
    8000430a:	ec56                	sd	s5,24(sp)
    8000430c:	e45e                	sd	s7,8(sp)
    8000430e:	e062                	sd	s8,0(sp)
    int i = 0;
    80004310:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004312:	6b85                	lui	s7,0x1
    80004314:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004318:	6c05                	lui	s8,0x1
    8000431a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000431e:	a8b5                	j	8000439a <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80004320:	6908                	ld	a0,16(a0)
    80004322:	1fc000ef          	jal	8000451e <pipewrite>
    80004326:	a04d                	j	800043c8 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004328:	02451783          	lh	a5,36(a0)
    8000432c:	03079693          	slli	a3,a5,0x30
    80004330:	92c1                	srli	a3,a3,0x30
    80004332:	4725                	li	a4,9
    80004334:	0ad76e63          	bltu	a4,a3,800043f0 <filewrite+0x11e>
    80004338:	0792                	slli	a5,a5,0x4
    8000433a:	0001e717          	auipc	a4,0x1e
    8000433e:	47e70713          	addi	a4,a4,1150 # 800227b8 <devsw>
    80004342:	97ba                	add	a5,a5,a4
    80004344:	679c                	ld	a5,8(a5)
    80004346:	c7dd                	beqz	a5,800043f4 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80004348:	4505                	li	a0,1
    8000434a:	9782                	jalr	a5
    8000434c:	a8b5                	j	800043c8 <filewrite+0xf6>
      if(n1 > max)
    8000434e:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004352:	989ff0ef          	jal	80003cda <begin_op>
      ilock(f->ip);
    80004356:	01893503          	ld	a0,24(s2)
    8000435a:	8eaff0ef          	jal	80003444 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000435e:	8756                	mv	a4,s5
    80004360:	02092683          	lw	a3,32(s2)
    80004364:	01698633          	add	a2,s3,s6
    80004368:	4585                	li	a1,1
    8000436a:	01893503          	ld	a0,24(s2)
    8000436e:	c26ff0ef          	jal	80003794 <writei>
    80004372:	84aa                	mv	s1,a0
    80004374:	00a05763          	blez	a0,80004382 <filewrite+0xb0>
        f->off += r;
    80004378:	02092783          	lw	a5,32(s2)
    8000437c:	9fa9                	addw	a5,a5,a0
    8000437e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004382:	01893503          	ld	a0,24(s2)
    80004386:	96cff0ef          	jal	800034f2 <iunlock>
      end_op();
    8000438a:	9bbff0ef          	jal	80003d44 <end_op>

      if(r != n1){
    8000438e:	029a9563          	bne	s5,s1,800043b8 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004392:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004396:	0149da63          	bge	s3,s4,800043aa <filewrite+0xd8>
      int n1 = n - i;
    8000439a:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000439e:	0004879b          	sext.w	a5,s1
    800043a2:	fafbd6e3          	bge	s7,a5,8000434e <filewrite+0x7c>
    800043a6:	84e2                	mv	s1,s8
    800043a8:	b75d                	j	8000434e <filewrite+0x7c>
    800043aa:	74e2                	ld	s1,56(sp)
    800043ac:	6ae2                	ld	s5,24(sp)
    800043ae:	6ba2                	ld	s7,8(sp)
    800043b0:	6c02                	ld	s8,0(sp)
    800043b2:	a039                	j	800043c0 <filewrite+0xee>
    int i = 0;
    800043b4:	4981                	li	s3,0
    800043b6:	a029                	j	800043c0 <filewrite+0xee>
    800043b8:	74e2                	ld	s1,56(sp)
    800043ba:	6ae2                	ld	s5,24(sp)
    800043bc:	6ba2                	ld	s7,8(sp)
    800043be:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800043c0:	033a1c63          	bne	s4,s3,800043f8 <filewrite+0x126>
    800043c4:	8552                	mv	a0,s4
    800043c6:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800043c8:	60a6                	ld	ra,72(sp)
    800043ca:	6406                	ld	s0,64(sp)
    800043cc:	7942                	ld	s2,48(sp)
    800043ce:	7a02                	ld	s4,32(sp)
    800043d0:	6b42                	ld	s6,16(sp)
    800043d2:	6161                	addi	sp,sp,80
    800043d4:	8082                	ret
    800043d6:	fc26                	sd	s1,56(sp)
    800043d8:	f44e                	sd	s3,40(sp)
    800043da:	ec56                	sd	s5,24(sp)
    800043dc:	e45e                	sd	s7,8(sp)
    800043de:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800043e0:	00003517          	auipc	a0,0x3
    800043e4:	21850513          	addi	a0,a0,536 # 800075f8 <etext+0x5f8>
    800043e8:	bbafc0ef          	jal	800007a2 <panic>
    return -1;
    800043ec:	557d                	li	a0,-1
}
    800043ee:	8082                	ret
      return -1;
    800043f0:	557d                	li	a0,-1
    800043f2:	bfd9                	j	800043c8 <filewrite+0xf6>
    800043f4:	557d                	li	a0,-1
    800043f6:	bfc9                	j	800043c8 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800043f8:	557d                	li	a0,-1
    800043fa:	79a2                	ld	s3,40(sp)
    800043fc:	b7f1                	j	800043c8 <filewrite+0xf6>

00000000800043fe <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800043fe:	7179                	addi	sp,sp,-48
    80004400:	f406                	sd	ra,40(sp)
    80004402:	f022                	sd	s0,32(sp)
    80004404:	ec26                	sd	s1,24(sp)
    80004406:	e052                	sd	s4,0(sp)
    80004408:	1800                	addi	s0,sp,48
    8000440a:	84aa                	mv	s1,a0
    8000440c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000440e:	0005b023          	sd	zero,0(a1)
    80004412:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004416:	c3bff0ef          	jal	80004050 <filealloc>
    8000441a:	e088                	sd	a0,0(s1)
    8000441c:	c549                	beqz	a0,800044a6 <pipealloc+0xa8>
    8000441e:	c33ff0ef          	jal	80004050 <filealloc>
    80004422:	00aa3023          	sd	a0,0(s4)
    80004426:	cd25                	beqz	a0,8000449e <pipealloc+0xa0>
    80004428:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000442a:	f08fc0ef          	jal	80000b32 <kalloc>
    8000442e:	892a                	mv	s2,a0
    80004430:	c12d                	beqz	a0,80004492 <pipealloc+0x94>
    80004432:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004434:	4985                	li	s3,1
    80004436:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000443a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000443e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004442:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004446:	00003597          	auipc	a1,0x3
    8000444a:	1c258593          	addi	a1,a1,450 # 80007608 <etext+0x608>
    8000444e:	f34fc0ef          	jal	80000b82 <initlock>
  (*f0)->type = FD_PIPE;
    80004452:	609c                	ld	a5,0(s1)
    80004454:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004458:	609c                	ld	a5,0(s1)
    8000445a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000445e:	609c                	ld	a5,0(s1)
    80004460:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004464:	609c                	ld	a5,0(s1)
    80004466:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000446a:	000a3783          	ld	a5,0(s4)
    8000446e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004472:	000a3783          	ld	a5,0(s4)
    80004476:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000447a:	000a3783          	ld	a5,0(s4)
    8000447e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004482:	000a3783          	ld	a5,0(s4)
    80004486:	0127b823          	sd	s2,16(a5)
  return 0;
    8000448a:	4501                	li	a0,0
    8000448c:	6942                	ld	s2,16(sp)
    8000448e:	69a2                	ld	s3,8(sp)
    80004490:	a01d                	j	800044b6 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004492:	6088                	ld	a0,0(s1)
    80004494:	c119                	beqz	a0,8000449a <pipealloc+0x9c>
    80004496:	6942                	ld	s2,16(sp)
    80004498:	a029                	j	800044a2 <pipealloc+0xa4>
    8000449a:	6942                	ld	s2,16(sp)
    8000449c:	a029                	j	800044a6 <pipealloc+0xa8>
    8000449e:	6088                	ld	a0,0(s1)
    800044a0:	c10d                	beqz	a0,800044c2 <pipealloc+0xc4>
    fileclose(*f0);
    800044a2:	c53ff0ef          	jal	800040f4 <fileclose>
  if(*f1)
    800044a6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800044aa:	557d                	li	a0,-1
  if(*f1)
    800044ac:	c789                	beqz	a5,800044b6 <pipealloc+0xb8>
    fileclose(*f1);
    800044ae:	853e                	mv	a0,a5
    800044b0:	c45ff0ef          	jal	800040f4 <fileclose>
  return -1;
    800044b4:	557d                	li	a0,-1
}
    800044b6:	70a2                	ld	ra,40(sp)
    800044b8:	7402                	ld	s0,32(sp)
    800044ba:	64e2                	ld	s1,24(sp)
    800044bc:	6a02                	ld	s4,0(sp)
    800044be:	6145                	addi	sp,sp,48
    800044c0:	8082                	ret
  return -1;
    800044c2:	557d                	li	a0,-1
    800044c4:	bfcd                	j	800044b6 <pipealloc+0xb8>

00000000800044c6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800044c6:	1101                	addi	sp,sp,-32
    800044c8:	ec06                	sd	ra,24(sp)
    800044ca:	e822                	sd	s0,16(sp)
    800044cc:	e426                	sd	s1,8(sp)
    800044ce:	e04a                	sd	s2,0(sp)
    800044d0:	1000                	addi	s0,sp,32
    800044d2:	84aa                	mv	s1,a0
    800044d4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800044d6:	f2cfc0ef          	jal	80000c02 <acquire>
  if(writable){
    800044da:	02090763          	beqz	s2,80004508 <pipeclose+0x42>
    pi->writeopen = 0;
    800044de:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800044e2:	21848513          	addi	a0,s1,536
    800044e6:	ba9fd0ef          	jal	8000208e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800044ea:	2204b783          	ld	a5,544(s1)
    800044ee:	e785                	bnez	a5,80004516 <pipeclose+0x50>
    release(&pi->lock);
    800044f0:	8526                	mv	a0,s1
    800044f2:	fa8fc0ef          	jal	80000c9a <release>
    kfree((char*)pi);
    800044f6:	8526                	mv	a0,s1
    800044f8:	d58fc0ef          	jal	80000a50 <kfree>
  } else
    release(&pi->lock);
}
    800044fc:	60e2                	ld	ra,24(sp)
    800044fe:	6442                	ld	s0,16(sp)
    80004500:	64a2                	ld	s1,8(sp)
    80004502:	6902                	ld	s2,0(sp)
    80004504:	6105                	addi	sp,sp,32
    80004506:	8082                	ret
    pi->readopen = 0;
    80004508:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000450c:	21c48513          	addi	a0,s1,540
    80004510:	b7ffd0ef          	jal	8000208e <wakeup>
    80004514:	bfd9                	j	800044ea <pipeclose+0x24>
    release(&pi->lock);
    80004516:	8526                	mv	a0,s1
    80004518:	f82fc0ef          	jal	80000c9a <release>
}
    8000451c:	b7c5                	j	800044fc <pipeclose+0x36>

000000008000451e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000451e:	711d                	addi	sp,sp,-96
    80004520:	ec86                	sd	ra,88(sp)
    80004522:	e8a2                	sd	s0,80(sp)
    80004524:	e4a6                	sd	s1,72(sp)
    80004526:	e0ca                	sd	s2,64(sp)
    80004528:	fc4e                	sd	s3,56(sp)
    8000452a:	f852                	sd	s4,48(sp)
    8000452c:	f456                	sd	s5,40(sp)
    8000452e:	1080                	addi	s0,sp,96
    80004530:	84aa                	mv	s1,a0
    80004532:	8aae                	mv	s5,a1
    80004534:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004536:	bcafd0ef          	jal	80001900 <myproc>
    8000453a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000453c:	8526                	mv	a0,s1
    8000453e:	ec4fc0ef          	jal	80000c02 <acquire>
  while(i < n){
    80004542:	0b405a63          	blez	s4,800045f6 <pipewrite+0xd8>
    80004546:	f05a                	sd	s6,32(sp)
    80004548:	ec5e                	sd	s7,24(sp)
    8000454a:	e862                	sd	s8,16(sp)
  int i = 0;
    8000454c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000454e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004550:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004554:	21c48b93          	addi	s7,s1,540
    80004558:	a81d                	j	8000458e <pipewrite+0x70>
      release(&pi->lock);
    8000455a:	8526                	mv	a0,s1
    8000455c:	f3efc0ef          	jal	80000c9a <release>
      return -1;
    80004560:	597d                	li	s2,-1
    80004562:	7b02                	ld	s6,32(sp)
    80004564:	6be2                	ld	s7,24(sp)
    80004566:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004568:	854a                	mv	a0,s2
    8000456a:	60e6                	ld	ra,88(sp)
    8000456c:	6446                	ld	s0,80(sp)
    8000456e:	64a6                	ld	s1,72(sp)
    80004570:	6906                	ld	s2,64(sp)
    80004572:	79e2                	ld	s3,56(sp)
    80004574:	7a42                	ld	s4,48(sp)
    80004576:	7aa2                	ld	s5,40(sp)
    80004578:	6125                	addi	sp,sp,96
    8000457a:	8082                	ret
      wakeup(&pi->nread);
    8000457c:	8562                	mv	a0,s8
    8000457e:	b11fd0ef          	jal	8000208e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004582:	85a6                	mv	a1,s1
    80004584:	855e                	mv	a0,s7
    80004586:	abdfd0ef          	jal	80002042 <sleep>
  while(i < n){
    8000458a:	05495b63          	bge	s2,s4,800045e0 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    8000458e:	2204a783          	lw	a5,544(s1)
    80004592:	d7e1                	beqz	a5,8000455a <pipewrite+0x3c>
    80004594:	854e                	mv	a0,s3
    80004596:	ce5fd0ef          	jal	8000227a <killed>
    8000459a:	f161                	bnez	a0,8000455a <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000459c:	2184a783          	lw	a5,536(s1)
    800045a0:	21c4a703          	lw	a4,540(s1)
    800045a4:	2007879b          	addiw	a5,a5,512
    800045a8:	fcf70ae3          	beq	a4,a5,8000457c <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800045ac:	4685                	li	a3,1
    800045ae:	01590633          	add	a2,s2,s5
    800045b2:	faf40593          	addi	a1,s0,-81
    800045b6:	0509b503          	ld	a0,80(s3)
    800045ba:	88efd0ef          	jal	80001648 <copyin>
    800045be:	03650e63          	beq	a0,s6,800045fa <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800045c2:	21c4a783          	lw	a5,540(s1)
    800045c6:	0017871b          	addiw	a4,a5,1
    800045ca:	20e4ae23          	sw	a4,540(s1)
    800045ce:	1ff7f793          	andi	a5,a5,511
    800045d2:	97a6                	add	a5,a5,s1
    800045d4:	faf44703          	lbu	a4,-81(s0)
    800045d8:	00e78c23          	sb	a4,24(a5)
      i++;
    800045dc:	2905                	addiw	s2,s2,1
    800045de:	b775                	j	8000458a <pipewrite+0x6c>
    800045e0:	7b02                	ld	s6,32(sp)
    800045e2:	6be2                	ld	s7,24(sp)
    800045e4:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800045e6:	21848513          	addi	a0,s1,536
    800045ea:	aa5fd0ef          	jal	8000208e <wakeup>
  release(&pi->lock);
    800045ee:	8526                	mv	a0,s1
    800045f0:	eaafc0ef          	jal	80000c9a <release>
  return i;
    800045f4:	bf95                	j	80004568 <pipewrite+0x4a>
  int i = 0;
    800045f6:	4901                	li	s2,0
    800045f8:	b7fd                	j	800045e6 <pipewrite+0xc8>
    800045fa:	7b02                	ld	s6,32(sp)
    800045fc:	6be2                	ld	s7,24(sp)
    800045fe:	6c42                	ld	s8,16(sp)
    80004600:	b7dd                	j	800045e6 <pipewrite+0xc8>

0000000080004602 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004602:	715d                	addi	sp,sp,-80
    80004604:	e486                	sd	ra,72(sp)
    80004606:	e0a2                	sd	s0,64(sp)
    80004608:	fc26                	sd	s1,56(sp)
    8000460a:	f84a                	sd	s2,48(sp)
    8000460c:	f44e                	sd	s3,40(sp)
    8000460e:	f052                	sd	s4,32(sp)
    80004610:	ec56                	sd	s5,24(sp)
    80004612:	0880                	addi	s0,sp,80
    80004614:	84aa                	mv	s1,a0
    80004616:	892e                	mv	s2,a1
    80004618:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000461a:	ae6fd0ef          	jal	80001900 <myproc>
    8000461e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004620:	8526                	mv	a0,s1
    80004622:	de0fc0ef          	jal	80000c02 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004626:	2184a703          	lw	a4,536(s1)
    8000462a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000462e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004632:	02f71563          	bne	a4,a5,8000465c <piperead+0x5a>
    80004636:	2244a783          	lw	a5,548(s1)
    8000463a:	cb85                	beqz	a5,8000466a <piperead+0x68>
    if(killed(pr)){
    8000463c:	8552                	mv	a0,s4
    8000463e:	c3dfd0ef          	jal	8000227a <killed>
    80004642:	ed19                	bnez	a0,80004660 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004644:	85a6                	mv	a1,s1
    80004646:	854e                	mv	a0,s3
    80004648:	9fbfd0ef          	jal	80002042 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000464c:	2184a703          	lw	a4,536(s1)
    80004650:	21c4a783          	lw	a5,540(s1)
    80004654:	fef701e3          	beq	a4,a5,80004636 <piperead+0x34>
    80004658:	e85a                	sd	s6,16(sp)
    8000465a:	a809                	j	8000466c <piperead+0x6a>
    8000465c:	e85a                	sd	s6,16(sp)
    8000465e:	a039                	j	8000466c <piperead+0x6a>
      release(&pi->lock);
    80004660:	8526                	mv	a0,s1
    80004662:	e38fc0ef          	jal	80000c9a <release>
      return -1;
    80004666:	59fd                	li	s3,-1
    80004668:	a8b1                	j	800046c4 <piperead+0xc2>
    8000466a:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000466c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000466e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004670:	05505263          	blez	s5,800046b4 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004674:	2184a783          	lw	a5,536(s1)
    80004678:	21c4a703          	lw	a4,540(s1)
    8000467c:	02f70c63          	beq	a4,a5,800046b4 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004680:	0017871b          	addiw	a4,a5,1
    80004684:	20e4ac23          	sw	a4,536(s1)
    80004688:	1ff7f793          	andi	a5,a5,511
    8000468c:	97a6                	add	a5,a5,s1
    8000468e:	0187c783          	lbu	a5,24(a5)
    80004692:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004696:	4685                	li	a3,1
    80004698:	fbf40613          	addi	a2,s0,-65
    8000469c:	85ca                	mv	a1,s2
    8000469e:	050a3503          	ld	a0,80(s4)
    800046a2:	ed1fc0ef          	jal	80001572 <copyout>
    800046a6:	01650763          	beq	a0,s6,800046b4 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800046aa:	2985                	addiw	s3,s3,1
    800046ac:	0905                	addi	s2,s2,1
    800046ae:	fd3a93e3          	bne	s5,s3,80004674 <piperead+0x72>
    800046b2:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800046b4:	21c48513          	addi	a0,s1,540
    800046b8:	9d7fd0ef          	jal	8000208e <wakeup>
  release(&pi->lock);
    800046bc:	8526                	mv	a0,s1
    800046be:	ddcfc0ef          	jal	80000c9a <release>
    800046c2:	6b42                	ld	s6,16(sp)
  return i;
}
    800046c4:	854e                	mv	a0,s3
    800046c6:	60a6                	ld	ra,72(sp)
    800046c8:	6406                	ld	s0,64(sp)
    800046ca:	74e2                	ld	s1,56(sp)
    800046cc:	7942                	ld	s2,48(sp)
    800046ce:	79a2                	ld	s3,40(sp)
    800046d0:	7a02                	ld	s4,32(sp)
    800046d2:	6ae2                	ld	s5,24(sp)
    800046d4:	6161                	addi	sp,sp,80
    800046d6:	8082                	ret

00000000800046d8 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800046d8:	1141                	addi	sp,sp,-16
    800046da:	e422                	sd	s0,8(sp)
    800046dc:	0800                	addi	s0,sp,16
    800046de:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800046e0:	8905                	andi	a0,a0,1
    800046e2:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800046e4:	8b89                	andi	a5,a5,2
    800046e6:	c399                	beqz	a5,800046ec <flags2perm+0x14>
      perm |= PTE_W;
    800046e8:	00456513          	ori	a0,a0,4
    return perm;
}
    800046ec:	6422                	ld	s0,8(sp)
    800046ee:	0141                	addi	sp,sp,16
    800046f0:	8082                	ret

00000000800046f2 <exec>:

int
exec(char *path, char **argv)
{
    800046f2:	df010113          	addi	sp,sp,-528
    800046f6:	20113423          	sd	ra,520(sp)
    800046fa:	20813023          	sd	s0,512(sp)
    800046fe:	ffa6                	sd	s1,504(sp)
    80004700:	fbca                	sd	s2,496(sp)
    80004702:	0c00                	addi	s0,sp,528
    80004704:	892a                	mv	s2,a0
    80004706:	dea43c23          	sd	a0,-520(s0)
    8000470a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000470e:	9f2fd0ef          	jal	80001900 <myproc>
    80004712:	84aa                	mv	s1,a0

  begin_op();
    80004714:	dc6ff0ef          	jal	80003cda <begin_op>

  if((ip = namei(path)) == 0){
    80004718:	854a                	mv	a0,s2
    8000471a:	c04ff0ef          	jal	80003b1e <namei>
    8000471e:	c931                	beqz	a0,80004772 <exec+0x80>
    80004720:	f3d2                	sd	s4,480(sp)
    80004722:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004724:	d21fe0ef          	jal	80003444 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004728:	04000713          	li	a4,64
    8000472c:	4681                	li	a3,0
    8000472e:	e5040613          	addi	a2,s0,-432
    80004732:	4581                	li	a1,0
    80004734:	8552                	mv	a0,s4
    80004736:	f63fe0ef          	jal	80003698 <readi>
    8000473a:	04000793          	li	a5,64
    8000473e:	00f51a63          	bne	a0,a5,80004752 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004742:	e5042703          	lw	a4,-432(s0)
    80004746:	464c47b7          	lui	a5,0x464c4
    8000474a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000474e:	02f70663          	beq	a4,a5,8000477a <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004752:	8552                	mv	a0,s4
    80004754:	efbfe0ef          	jal	8000364e <iunlockput>
    end_op();
    80004758:	decff0ef          	jal	80003d44 <end_op>
  }
  return -1;
    8000475c:	557d                	li	a0,-1
    8000475e:	7a1e                	ld	s4,480(sp)
}
    80004760:	20813083          	ld	ra,520(sp)
    80004764:	20013403          	ld	s0,512(sp)
    80004768:	74fe                	ld	s1,504(sp)
    8000476a:	795e                	ld	s2,496(sp)
    8000476c:	21010113          	addi	sp,sp,528
    80004770:	8082                	ret
    end_op();
    80004772:	dd2ff0ef          	jal	80003d44 <end_op>
    return -1;
    80004776:	557d                	li	a0,-1
    80004778:	b7e5                	j	80004760 <exec+0x6e>
    8000477a:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000477c:	8526                	mv	a0,s1
    8000477e:	b1afd0ef          	jal	80001a98 <proc_pagetable>
    80004782:	8b2a                	mv	s6,a0
    80004784:	2c050b63          	beqz	a0,80004a5a <exec+0x368>
    80004788:	f7ce                	sd	s3,488(sp)
    8000478a:	efd6                	sd	s5,472(sp)
    8000478c:	e7de                	sd	s7,456(sp)
    8000478e:	e3e2                	sd	s8,448(sp)
    80004790:	ff66                	sd	s9,440(sp)
    80004792:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004794:	e7042d03          	lw	s10,-400(s0)
    80004798:	e8845783          	lhu	a5,-376(s0)
    8000479c:	12078963          	beqz	a5,800048ce <exec+0x1dc>
    800047a0:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800047a2:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800047a4:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800047a6:	6c85                	lui	s9,0x1
    800047a8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800047ac:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800047b0:	6a85                	lui	s5,0x1
    800047b2:	a085                	j	80004812 <exec+0x120>
      panic("loadseg: address should exist");
    800047b4:	00003517          	auipc	a0,0x3
    800047b8:	e5c50513          	addi	a0,a0,-420 # 80007610 <etext+0x610>
    800047bc:	fe7fb0ef          	jal	800007a2 <panic>
    if(sz - i < PGSIZE)
    800047c0:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800047c2:	8726                	mv	a4,s1
    800047c4:	012c06bb          	addw	a3,s8,s2
    800047c8:	4581                	li	a1,0
    800047ca:	8552                	mv	a0,s4
    800047cc:	ecdfe0ef          	jal	80003698 <readi>
    800047d0:	2501                	sext.w	a0,a0
    800047d2:	24a49a63          	bne	s1,a0,80004a26 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    800047d6:	012a893b          	addw	s2,s5,s2
    800047da:	03397363          	bgeu	s2,s3,80004800 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    800047de:	02091593          	slli	a1,s2,0x20
    800047e2:	9181                	srli	a1,a1,0x20
    800047e4:	95de                	add	a1,a1,s7
    800047e6:	855a                	mv	a0,s6
    800047e8:	ffcfc0ef          	jal	80000fe4 <walkaddr>
    800047ec:	862a                	mv	a2,a0
    if(pa == 0)
    800047ee:	d179                	beqz	a0,800047b4 <exec+0xc2>
    if(sz - i < PGSIZE)
    800047f0:	412984bb          	subw	s1,s3,s2
    800047f4:	0004879b          	sext.w	a5,s1
    800047f8:	fcfcf4e3          	bgeu	s9,a5,800047c0 <exec+0xce>
    800047fc:	84d6                	mv	s1,s5
    800047fe:	b7c9                	j	800047c0 <exec+0xce>
    sz = sz1;
    80004800:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004804:	2d85                	addiw	s11,s11,1
    80004806:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    8000480a:	e8845783          	lhu	a5,-376(s0)
    8000480e:	08fdd063          	bge	s11,a5,8000488e <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004812:	2d01                	sext.w	s10,s10
    80004814:	03800713          	li	a4,56
    80004818:	86ea                	mv	a3,s10
    8000481a:	e1840613          	addi	a2,s0,-488
    8000481e:	4581                	li	a1,0
    80004820:	8552                	mv	a0,s4
    80004822:	e77fe0ef          	jal	80003698 <readi>
    80004826:	03800793          	li	a5,56
    8000482a:	1cf51663          	bne	a0,a5,800049f6 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    8000482e:	e1842783          	lw	a5,-488(s0)
    80004832:	4705                	li	a4,1
    80004834:	fce798e3          	bne	a5,a4,80004804 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80004838:	e4043483          	ld	s1,-448(s0)
    8000483c:	e3843783          	ld	a5,-456(s0)
    80004840:	1af4ef63          	bltu	s1,a5,800049fe <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004844:	e2843783          	ld	a5,-472(s0)
    80004848:	94be                	add	s1,s1,a5
    8000484a:	1af4ee63          	bltu	s1,a5,80004a06 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    8000484e:	df043703          	ld	a4,-528(s0)
    80004852:	8ff9                	and	a5,a5,a4
    80004854:	1a079d63          	bnez	a5,80004a0e <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004858:	e1c42503          	lw	a0,-484(s0)
    8000485c:	e7dff0ef          	jal	800046d8 <flags2perm>
    80004860:	86aa                	mv	a3,a0
    80004862:	8626                	mv	a2,s1
    80004864:	85ca                	mv	a1,s2
    80004866:	855a                	mv	a0,s6
    80004868:	af7fc0ef          	jal	8000135e <uvmalloc>
    8000486c:	e0a43423          	sd	a0,-504(s0)
    80004870:	1a050363          	beqz	a0,80004a16 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004874:	e2843b83          	ld	s7,-472(s0)
    80004878:	e2042c03          	lw	s8,-480(s0)
    8000487c:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004880:	00098463          	beqz	s3,80004888 <exec+0x196>
    80004884:	4901                	li	s2,0
    80004886:	bfa1                	j	800047de <exec+0xec>
    sz = sz1;
    80004888:	e0843903          	ld	s2,-504(s0)
    8000488c:	bfa5                	j	80004804 <exec+0x112>
    8000488e:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004890:	8552                	mv	a0,s4
    80004892:	dbdfe0ef          	jal	8000364e <iunlockput>
  end_op();
    80004896:	caeff0ef          	jal	80003d44 <end_op>
  p = myproc();
    8000489a:	866fd0ef          	jal	80001900 <myproc>
    8000489e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800048a0:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800048a4:	6985                	lui	s3,0x1
    800048a6:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800048a8:	99ca                	add	s3,s3,s2
    800048aa:	77fd                	lui	a5,0xfffff
    800048ac:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800048b0:	4691                	li	a3,4
    800048b2:	6609                	lui	a2,0x2
    800048b4:	964e                	add	a2,a2,s3
    800048b6:	85ce                	mv	a1,s3
    800048b8:	855a                	mv	a0,s6
    800048ba:	aa5fc0ef          	jal	8000135e <uvmalloc>
    800048be:	892a                	mv	s2,a0
    800048c0:	e0a43423          	sd	a0,-504(s0)
    800048c4:	e519                	bnez	a0,800048d2 <exec+0x1e0>
  if(pagetable)
    800048c6:	e1343423          	sd	s3,-504(s0)
    800048ca:	4a01                	li	s4,0
    800048cc:	aab1                	j	80004a28 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800048ce:	4901                	li	s2,0
    800048d0:	b7c1                	j	80004890 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800048d2:	75f9                	lui	a1,0xffffe
    800048d4:	95aa                	add	a1,a1,a0
    800048d6:	855a                	mv	a0,s6
    800048d8:	c71fc0ef          	jal	80001548 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800048dc:	7bfd                	lui	s7,0xfffff
    800048de:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800048e0:	e0043783          	ld	a5,-512(s0)
    800048e4:	6388                	ld	a0,0(a5)
    800048e6:	cd39                	beqz	a0,80004944 <exec+0x252>
    800048e8:	e9040993          	addi	s3,s0,-368
    800048ec:	f9040c13          	addi	s8,s0,-112
    800048f0:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800048f2:	d54fc0ef          	jal	80000e46 <strlen>
    800048f6:	0015079b          	addiw	a5,a0,1
    800048fa:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800048fe:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004902:	11796e63          	bltu	s2,s7,80004a1e <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004906:	e0043d03          	ld	s10,-512(s0)
    8000490a:	000d3a03          	ld	s4,0(s10)
    8000490e:	8552                	mv	a0,s4
    80004910:	d36fc0ef          	jal	80000e46 <strlen>
    80004914:	0015069b          	addiw	a3,a0,1
    80004918:	8652                	mv	a2,s4
    8000491a:	85ca                	mv	a1,s2
    8000491c:	855a                	mv	a0,s6
    8000491e:	c55fc0ef          	jal	80001572 <copyout>
    80004922:	10054063          	bltz	a0,80004a22 <exec+0x330>
    ustack[argc] = sp;
    80004926:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000492a:	0485                	addi	s1,s1,1
    8000492c:	008d0793          	addi	a5,s10,8
    80004930:	e0f43023          	sd	a5,-512(s0)
    80004934:	008d3503          	ld	a0,8(s10)
    80004938:	c909                	beqz	a0,8000494a <exec+0x258>
    if(argc >= MAXARG)
    8000493a:	09a1                	addi	s3,s3,8
    8000493c:	fb899be3          	bne	s3,s8,800048f2 <exec+0x200>
  ip = 0;
    80004940:	4a01                	li	s4,0
    80004942:	a0dd                	j	80004a28 <exec+0x336>
  sp = sz;
    80004944:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004948:	4481                	li	s1,0
  ustack[argc] = 0;
    8000494a:	00349793          	slli	a5,s1,0x3
    8000494e:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb640>
    80004952:	97a2                	add	a5,a5,s0
    80004954:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004958:	00148693          	addi	a3,s1,1
    8000495c:	068e                	slli	a3,a3,0x3
    8000495e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004962:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004966:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000496a:	f5796ee3          	bltu	s2,s7,800048c6 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000496e:	e9040613          	addi	a2,s0,-368
    80004972:	85ca                	mv	a1,s2
    80004974:	855a                	mv	a0,s6
    80004976:	bfdfc0ef          	jal	80001572 <copyout>
    8000497a:	0e054263          	bltz	a0,80004a5e <exec+0x36c>
  p->trapframe->a1 = sp;
    8000497e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004982:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004986:	df843783          	ld	a5,-520(s0)
    8000498a:	0007c703          	lbu	a4,0(a5)
    8000498e:	cf11                	beqz	a4,800049aa <exec+0x2b8>
    80004990:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004992:	02f00693          	li	a3,47
    80004996:	a039                	j	800049a4 <exec+0x2b2>
      last = s+1;
    80004998:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000499c:	0785                	addi	a5,a5,1
    8000499e:	fff7c703          	lbu	a4,-1(a5)
    800049a2:	c701                	beqz	a4,800049aa <exec+0x2b8>
    if(*s == '/')
    800049a4:	fed71ce3          	bne	a4,a3,8000499c <exec+0x2aa>
    800049a8:	bfc5                	j	80004998 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    800049aa:	4641                	li	a2,16
    800049ac:	df843583          	ld	a1,-520(s0)
    800049b0:	158a8513          	addi	a0,s5,344
    800049b4:	c60fc0ef          	jal	80000e14 <safestrcpy>
  oldpagetable = p->pagetable;
    800049b8:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800049bc:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800049c0:	e0843783          	ld	a5,-504(s0)
    800049c4:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800049c8:	058ab783          	ld	a5,88(s5)
    800049cc:	e6843703          	ld	a4,-408(s0)
    800049d0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800049d2:	058ab783          	ld	a5,88(s5)
    800049d6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800049da:	85e6                	mv	a1,s9
    800049dc:	940fd0ef          	jal	80001b1c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800049e0:	0004851b          	sext.w	a0,s1
    800049e4:	79be                	ld	s3,488(sp)
    800049e6:	7a1e                	ld	s4,480(sp)
    800049e8:	6afe                	ld	s5,472(sp)
    800049ea:	6b5e                	ld	s6,464(sp)
    800049ec:	6bbe                	ld	s7,456(sp)
    800049ee:	6c1e                	ld	s8,448(sp)
    800049f0:	7cfa                	ld	s9,440(sp)
    800049f2:	7d5a                	ld	s10,432(sp)
    800049f4:	b3b5                	j	80004760 <exec+0x6e>
    800049f6:	e1243423          	sd	s2,-504(s0)
    800049fa:	7dba                	ld	s11,424(sp)
    800049fc:	a035                	j	80004a28 <exec+0x336>
    800049fe:	e1243423          	sd	s2,-504(s0)
    80004a02:	7dba                	ld	s11,424(sp)
    80004a04:	a015                	j	80004a28 <exec+0x336>
    80004a06:	e1243423          	sd	s2,-504(s0)
    80004a0a:	7dba                	ld	s11,424(sp)
    80004a0c:	a831                	j	80004a28 <exec+0x336>
    80004a0e:	e1243423          	sd	s2,-504(s0)
    80004a12:	7dba                	ld	s11,424(sp)
    80004a14:	a811                	j	80004a28 <exec+0x336>
    80004a16:	e1243423          	sd	s2,-504(s0)
    80004a1a:	7dba                	ld	s11,424(sp)
    80004a1c:	a031                	j	80004a28 <exec+0x336>
  ip = 0;
    80004a1e:	4a01                	li	s4,0
    80004a20:	a021                	j	80004a28 <exec+0x336>
    80004a22:	4a01                	li	s4,0
  if(pagetable)
    80004a24:	a011                	j	80004a28 <exec+0x336>
    80004a26:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004a28:	e0843583          	ld	a1,-504(s0)
    80004a2c:	855a                	mv	a0,s6
    80004a2e:	8eefd0ef          	jal	80001b1c <proc_freepagetable>
  return -1;
    80004a32:	557d                	li	a0,-1
  if(ip){
    80004a34:	000a1b63          	bnez	s4,80004a4a <exec+0x358>
    80004a38:	79be                	ld	s3,488(sp)
    80004a3a:	7a1e                	ld	s4,480(sp)
    80004a3c:	6afe                	ld	s5,472(sp)
    80004a3e:	6b5e                	ld	s6,464(sp)
    80004a40:	6bbe                	ld	s7,456(sp)
    80004a42:	6c1e                	ld	s8,448(sp)
    80004a44:	7cfa                	ld	s9,440(sp)
    80004a46:	7d5a                	ld	s10,432(sp)
    80004a48:	bb21                	j	80004760 <exec+0x6e>
    80004a4a:	79be                	ld	s3,488(sp)
    80004a4c:	6afe                	ld	s5,472(sp)
    80004a4e:	6b5e                	ld	s6,464(sp)
    80004a50:	6bbe                	ld	s7,456(sp)
    80004a52:	6c1e                	ld	s8,448(sp)
    80004a54:	7cfa                	ld	s9,440(sp)
    80004a56:	7d5a                	ld	s10,432(sp)
    80004a58:	b9ed                	j	80004752 <exec+0x60>
    80004a5a:	6b5e                	ld	s6,464(sp)
    80004a5c:	b9dd                	j	80004752 <exec+0x60>
  sz = sz1;
    80004a5e:	e0843983          	ld	s3,-504(s0)
    80004a62:	b595                	j	800048c6 <exec+0x1d4>

0000000080004a64 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004a64:	7179                	addi	sp,sp,-48
    80004a66:	f406                	sd	ra,40(sp)
    80004a68:	f022                	sd	s0,32(sp)
    80004a6a:	ec26                	sd	s1,24(sp)
    80004a6c:	e84a                	sd	s2,16(sp)
    80004a6e:	1800                	addi	s0,sp,48
    80004a70:	892e                	mv	s2,a1
    80004a72:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004a74:	fdc40593          	addi	a1,s0,-36
    80004a78:	ebbfd0ef          	jal	80002932 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004a7c:	fdc42703          	lw	a4,-36(s0)
    80004a80:	47bd                	li	a5,15
    80004a82:	02e7e963          	bltu	a5,a4,80004ab4 <argfd+0x50>
    80004a86:	e7bfc0ef          	jal	80001900 <myproc>
    80004a8a:	fdc42703          	lw	a4,-36(s0)
    80004a8e:	01a70793          	addi	a5,a4,26
    80004a92:	078e                	slli	a5,a5,0x3
    80004a94:	953e                	add	a0,a0,a5
    80004a96:	611c                	ld	a5,0(a0)
    80004a98:	c385                	beqz	a5,80004ab8 <argfd+0x54>
    return -1;
  if(pfd)
    80004a9a:	00090463          	beqz	s2,80004aa2 <argfd+0x3e>
    *pfd = fd;
    80004a9e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004aa2:	4501                	li	a0,0
  if(pf)
    80004aa4:	c091                	beqz	s1,80004aa8 <argfd+0x44>
    *pf = f;
    80004aa6:	e09c                	sd	a5,0(s1)
}
    80004aa8:	70a2                	ld	ra,40(sp)
    80004aaa:	7402                	ld	s0,32(sp)
    80004aac:	64e2                	ld	s1,24(sp)
    80004aae:	6942                	ld	s2,16(sp)
    80004ab0:	6145                	addi	sp,sp,48
    80004ab2:	8082                	ret
    return -1;
    80004ab4:	557d                	li	a0,-1
    80004ab6:	bfcd                	j	80004aa8 <argfd+0x44>
    80004ab8:	557d                	li	a0,-1
    80004aba:	b7fd                	j	80004aa8 <argfd+0x44>

0000000080004abc <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004abc:	1101                	addi	sp,sp,-32
    80004abe:	ec06                	sd	ra,24(sp)
    80004ac0:	e822                	sd	s0,16(sp)
    80004ac2:	e426                	sd	s1,8(sp)
    80004ac4:	1000                	addi	s0,sp,32
    80004ac6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004ac8:	e39fc0ef          	jal	80001900 <myproc>
    80004acc:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004ace:	0d050793          	addi	a5,a0,208
    80004ad2:	4501                	li	a0,0
    80004ad4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004ad6:	6398                	ld	a4,0(a5)
    80004ad8:	cb19                	beqz	a4,80004aee <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004ada:	2505                	addiw	a0,a0,1
    80004adc:	07a1                	addi	a5,a5,8
    80004ade:	fed51ce3          	bne	a0,a3,80004ad6 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004ae2:	557d                	li	a0,-1
}
    80004ae4:	60e2                	ld	ra,24(sp)
    80004ae6:	6442                	ld	s0,16(sp)
    80004ae8:	64a2                	ld	s1,8(sp)
    80004aea:	6105                	addi	sp,sp,32
    80004aec:	8082                	ret
      p->ofile[fd] = f;
    80004aee:	01a50793          	addi	a5,a0,26
    80004af2:	078e                	slli	a5,a5,0x3
    80004af4:	963e                	add	a2,a2,a5
    80004af6:	e204                	sd	s1,0(a2)
      return fd;
    80004af8:	b7f5                	j	80004ae4 <fdalloc+0x28>

0000000080004afa <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004afa:	715d                	addi	sp,sp,-80
    80004afc:	e486                	sd	ra,72(sp)
    80004afe:	e0a2                	sd	s0,64(sp)
    80004b00:	fc26                	sd	s1,56(sp)
    80004b02:	f84a                	sd	s2,48(sp)
    80004b04:	f44e                	sd	s3,40(sp)
    80004b06:	ec56                	sd	s5,24(sp)
    80004b08:	e85a                	sd	s6,16(sp)
    80004b0a:	0880                	addi	s0,sp,80
    80004b0c:	8b2e                	mv	s6,a1
    80004b0e:	89b2                	mv	s3,a2
    80004b10:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004b12:	fb040593          	addi	a1,s0,-80
    80004b16:	822ff0ef          	jal	80003b38 <nameiparent>
    80004b1a:	84aa                	mv	s1,a0
    80004b1c:	10050a63          	beqz	a0,80004c30 <create+0x136>
    return 0;

  ilock(dp);
    80004b20:	925fe0ef          	jal	80003444 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004b24:	4601                	li	a2,0
    80004b26:	fb040593          	addi	a1,s0,-80
    80004b2a:	8526                	mv	a0,s1
    80004b2c:	d8dfe0ef          	jal	800038b8 <dirlookup>
    80004b30:	8aaa                	mv	s5,a0
    80004b32:	c129                	beqz	a0,80004b74 <create+0x7a>
    iunlockput(dp);
    80004b34:	8526                	mv	a0,s1
    80004b36:	b19fe0ef          	jal	8000364e <iunlockput>
    ilock(ip);
    80004b3a:	8556                	mv	a0,s5
    80004b3c:	909fe0ef          	jal	80003444 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004b40:	4789                	li	a5,2
    80004b42:	02fb1463          	bne	s6,a5,80004b6a <create+0x70>
    80004b46:	044ad783          	lhu	a5,68(s5)
    80004b4a:	37f9                	addiw	a5,a5,-2
    80004b4c:	17c2                	slli	a5,a5,0x30
    80004b4e:	93c1                	srli	a5,a5,0x30
    80004b50:	4705                	li	a4,1
    80004b52:	00f76c63          	bltu	a4,a5,80004b6a <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004b56:	8556                	mv	a0,s5
    80004b58:	60a6                	ld	ra,72(sp)
    80004b5a:	6406                	ld	s0,64(sp)
    80004b5c:	74e2                	ld	s1,56(sp)
    80004b5e:	7942                	ld	s2,48(sp)
    80004b60:	79a2                	ld	s3,40(sp)
    80004b62:	6ae2                	ld	s5,24(sp)
    80004b64:	6b42                	ld	s6,16(sp)
    80004b66:	6161                	addi	sp,sp,80
    80004b68:	8082                	ret
    iunlockput(ip);
    80004b6a:	8556                	mv	a0,s5
    80004b6c:	ae3fe0ef          	jal	8000364e <iunlockput>
    return 0;
    80004b70:	4a81                	li	s5,0
    80004b72:	b7d5                	j	80004b56 <create+0x5c>
    80004b74:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004b76:	85da                	mv	a1,s6
    80004b78:	4088                	lw	a0,0(s1)
    80004b7a:	f5afe0ef          	jal	800032d4 <ialloc>
    80004b7e:	8a2a                	mv	s4,a0
    80004b80:	cd15                	beqz	a0,80004bbc <create+0xc2>
  ilock(ip);
    80004b82:	8c3fe0ef          	jal	80003444 <ilock>
  ip->major = major;
    80004b86:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004b8a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004b8e:	4905                	li	s2,1
    80004b90:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004b94:	8552                	mv	a0,s4
    80004b96:	ffafe0ef          	jal	80003390 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004b9a:	032b0763          	beq	s6,s2,80004bc8 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004b9e:	004a2603          	lw	a2,4(s4)
    80004ba2:	fb040593          	addi	a1,s0,-80
    80004ba6:	8526                	mv	a0,s1
    80004ba8:	eddfe0ef          	jal	80003a84 <dirlink>
    80004bac:	06054563          	bltz	a0,80004c16 <create+0x11c>
  iunlockput(dp);
    80004bb0:	8526                	mv	a0,s1
    80004bb2:	a9dfe0ef          	jal	8000364e <iunlockput>
  return ip;
    80004bb6:	8ad2                	mv	s5,s4
    80004bb8:	7a02                	ld	s4,32(sp)
    80004bba:	bf71                	j	80004b56 <create+0x5c>
    iunlockput(dp);
    80004bbc:	8526                	mv	a0,s1
    80004bbe:	a91fe0ef          	jal	8000364e <iunlockput>
    return 0;
    80004bc2:	8ad2                	mv	s5,s4
    80004bc4:	7a02                	ld	s4,32(sp)
    80004bc6:	bf41                	j	80004b56 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004bc8:	004a2603          	lw	a2,4(s4)
    80004bcc:	00003597          	auipc	a1,0x3
    80004bd0:	a6458593          	addi	a1,a1,-1436 # 80007630 <etext+0x630>
    80004bd4:	8552                	mv	a0,s4
    80004bd6:	eaffe0ef          	jal	80003a84 <dirlink>
    80004bda:	02054e63          	bltz	a0,80004c16 <create+0x11c>
    80004bde:	40d0                	lw	a2,4(s1)
    80004be0:	00003597          	auipc	a1,0x3
    80004be4:	a5858593          	addi	a1,a1,-1448 # 80007638 <etext+0x638>
    80004be8:	8552                	mv	a0,s4
    80004bea:	e9bfe0ef          	jal	80003a84 <dirlink>
    80004bee:	02054463          	bltz	a0,80004c16 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004bf2:	004a2603          	lw	a2,4(s4)
    80004bf6:	fb040593          	addi	a1,s0,-80
    80004bfa:	8526                	mv	a0,s1
    80004bfc:	e89fe0ef          	jal	80003a84 <dirlink>
    80004c00:	00054b63          	bltz	a0,80004c16 <create+0x11c>
    dp->nlink++;  // for ".."
    80004c04:	04a4d783          	lhu	a5,74(s1)
    80004c08:	2785                	addiw	a5,a5,1
    80004c0a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c0e:	8526                	mv	a0,s1
    80004c10:	f80fe0ef          	jal	80003390 <iupdate>
    80004c14:	bf71                	j	80004bb0 <create+0xb6>
  ip->nlink = 0;
    80004c16:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004c1a:	8552                	mv	a0,s4
    80004c1c:	f74fe0ef          	jal	80003390 <iupdate>
  iunlockput(ip);
    80004c20:	8552                	mv	a0,s4
    80004c22:	a2dfe0ef          	jal	8000364e <iunlockput>
  iunlockput(dp);
    80004c26:	8526                	mv	a0,s1
    80004c28:	a27fe0ef          	jal	8000364e <iunlockput>
  return 0;
    80004c2c:	7a02                	ld	s4,32(sp)
    80004c2e:	b725                	j	80004b56 <create+0x5c>
    return 0;
    80004c30:	8aaa                	mv	s5,a0
    80004c32:	b715                	j	80004b56 <create+0x5c>

0000000080004c34 <sys_dup>:
{
    80004c34:	7179                	addi	sp,sp,-48
    80004c36:	f406                	sd	ra,40(sp)
    80004c38:	f022                	sd	s0,32(sp)
    80004c3a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004c3c:	fd840613          	addi	a2,s0,-40
    80004c40:	4581                	li	a1,0
    80004c42:	4501                	li	a0,0
    80004c44:	e21ff0ef          	jal	80004a64 <argfd>
    return -1;
    80004c48:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004c4a:	02054363          	bltz	a0,80004c70 <sys_dup+0x3c>
    80004c4e:	ec26                	sd	s1,24(sp)
    80004c50:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004c52:	fd843903          	ld	s2,-40(s0)
    80004c56:	854a                	mv	a0,s2
    80004c58:	e65ff0ef          	jal	80004abc <fdalloc>
    80004c5c:	84aa                	mv	s1,a0
    return -1;
    80004c5e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004c60:	00054d63          	bltz	a0,80004c7a <sys_dup+0x46>
  filedup(f);
    80004c64:	854a                	mv	a0,s2
    80004c66:	c48ff0ef          	jal	800040ae <filedup>
  return fd;
    80004c6a:	87a6                	mv	a5,s1
    80004c6c:	64e2                	ld	s1,24(sp)
    80004c6e:	6942                	ld	s2,16(sp)
}
    80004c70:	853e                	mv	a0,a5
    80004c72:	70a2                	ld	ra,40(sp)
    80004c74:	7402                	ld	s0,32(sp)
    80004c76:	6145                	addi	sp,sp,48
    80004c78:	8082                	ret
    80004c7a:	64e2                	ld	s1,24(sp)
    80004c7c:	6942                	ld	s2,16(sp)
    80004c7e:	bfcd                	j	80004c70 <sys_dup+0x3c>

0000000080004c80 <sys_read>:
{
    80004c80:	7179                	addi	sp,sp,-48
    80004c82:	f406                	sd	ra,40(sp)
    80004c84:	f022                	sd	s0,32(sp)
    80004c86:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004c88:	fd840593          	addi	a1,s0,-40
    80004c8c:	4505                	li	a0,1
    80004c8e:	cc1fd0ef          	jal	8000294e <argaddr>
  argint(2, &n);
    80004c92:	fe440593          	addi	a1,s0,-28
    80004c96:	4509                	li	a0,2
    80004c98:	c9bfd0ef          	jal	80002932 <argint>
  if(argfd(0, 0, &f) < 0)
    80004c9c:	fe840613          	addi	a2,s0,-24
    80004ca0:	4581                	li	a1,0
    80004ca2:	4501                	li	a0,0
    80004ca4:	dc1ff0ef          	jal	80004a64 <argfd>
    80004ca8:	87aa                	mv	a5,a0
    return -1;
    80004caa:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004cac:	0007ca63          	bltz	a5,80004cc0 <sys_read+0x40>
  return fileread(f, p, n);
    80004cb0:	fe442603          	lw	a2,-28(s0)
    80004cb4:	fd843583          	ld	a1,-40(s0)
    80004cb8:	fe843503          	ld	a0,-24(s0)
    80004cbc:	d58ff0ef          	jal	80004214 <fileread>
}
    80004cc0:	70a2                	ld	ra,40(sp)
    80004cc2:	7402                	ld	s0,32(sp)
    80004cc4:	6145                	addi	sp,sp,48
    80004cc6:	8082                	ret

0000000080004cc8 <sys_write>:
{
    80004cc8:	7179                	addi	sp,sp,-48
    80004cca:	f406                	sd	ra,40(sp)
    80004ccc:	f022                	sd	s0,32(sp)
    80004cce:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004cd0:	fd840593          	addi	a1,s0,-40
    80004cd4:	4505                	li	a0,1
    80004cd6:	c79fd0ef          	jal	8000294e <argaddr>
  argint(2, &n);
    80004cda:	fe440593          	addi	a1,s0,-28
    80004cde:	4509                	li	a0,2
    80004ce0:	c53fd0ef          	jal	80002932 <argint>
  if(argfd(0, 0, &f) < 0)
    80004ce4:	fe840613          	addi	a2,s0,-24
    80004ce8:	4581                	li	a1,0
    80004cea:	4501                	li	a0,0
    80004cec:	d79ff0ef          	jal	80004a64 <argfd>
    80004cf0:	87aa                	mv	a5,a0
    return -1;
    80004cf2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004cf4:	0007ca63          	bltz	a5,80004d08 <sys_write+0x40>
  return filewrite(f, p, n);
    80004cf8:	fe442603          	lw	a2,-28(s0)
    80004cfc:	fd843583          	ld	a1,-40(s0)
    80004d00:	fe843503          	ld	a0,-24(s0)
    80004d04:	dceff0ef          	jal	800042d2 <filewrite>
}
    80004d08:	70a2                	ld	ra,40(sp)
    80004d0a:	7402                	ld	s0,32(sp)
    80004d0c:	6145                	addi	sp,sp,48
    80004d0e:	8082                	ret

0000000080004d10 <sys_close>:
{
    80004d10:	1101                	addi	sp,sp,-32
    80004d12:	ec06                	sd	ra,24(sp)
    80004d14:	e822                	sd	s0,16(sp)
    80004d16:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004d18:	fe040613          	addi	a2,s0,-32
    80004d1c:	fec40593          	addi	a1,s0,-20
    80004d20:	4501                	li	a0,0
    80004d22:	d43ff0ef          	jal	80004a64 <argfd>
    return -1;
    80004d26:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004d28:	02054063          	bltz	a0,80004d48 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004d2c:	bd5fc0ef          	jal	80001900 <myproc>
    80004d30:	fec42783          	lw	a5,-20(s0)
    80004d34:	07e9                	addi	a5,a5,26
    80004d36:	078e                	slli	a5,a5,0x3
    80004d38:	953e                	add	a0,a0,a5
    80004d3a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004d3e:	fe043503          	ld	a0,-32(s0)
    80004d42:	bb2ff0ef          	jal	800040f4 <fileclose>
  return 0;
    80004d46:	4781                	li	a5,0
}
    80004d48:	853e                	mv	a0,a5
    80004d4a:	60e2                	ld	ra,24(sp)
    80004d4c:	6442                	ld	s0,16(sp)
    80004d4e:	6105                	addi	sp,sp,32
    80004d50:	8082                	ret

0000000080004d52 <sys_fstat>:
{
    80004d52:	1101                	addi	sp,sp,-32
    80004d54:	ec06                	sd	ra,24(sp)
    80004d56:	e822                	sd	s0,16(sp)
    80004d58:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004d5a:	fe040593          	addi	a1,s0,-32
    80004d5e:	4505                	li	a0,1
    80004d60:	beffd0ef          	jal	8000294e <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004d64:	fe840613          	addi	a2,s0,-24
    80004d68:	4581                	li	a1,0
    80004d6a:	4501                	li	a0,0
    80004d6c:	cf9ff0ef          	jal	80004a64 <argfd>
    80004d70:	87aa                	mv	a5,a0
    return -1;
    80004d72:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004d74:	0007c863          	bltz	a5,80004d84 <sys_fstat+0x32>
  return filestat(f, st);
    80004d78:	fe043583          	ld	a1,-32(s0)
    80004d7c:	fe843503          	ld	a0,-24(s0)
    80004d80:	c36ff0ef          	jal	800041b6 <filestat>
}
    80004d84:	60e2                	ld	ra,24(sp)
    80004d86:	6442                	ld	s0,16(sp)
    80004d88:	6105                	addi	sp,sp,32
    80004d8a:	8082                	ret

0000000080004d8c <sys_link>:
{
    80004d8c:	7169                	addi	sp,sp,-304
    80004d8e:	f606                	sd	ra,296(sp)
    80004d90:	f222                	sd	s0,288(sp)
    80004d92:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004d94:	08000613          	li	a2,128
    80004d98:	ed040593          	addi	a1,s0,-304
    80004d9c:	4501                	li	a0,0
    80004d9e:	bcdfd0ef          	jal	8000296a <argstr>
    return -1;
    80004da2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004da4:	0c054e63          	bltz	a0,80004e80 <sys_link+0xf4>
    80004da8:	08000613          	li	a2,128
    80004dac:	f5040593          	addi	a1,s0,-176
    80004db0:	4505                	li	a0,1
    80004db2:	bb9fd0ef          	jal	8000296a <argstr>
    return -1;
    80004db6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004db8:	0c054463          	bltz	a0,80004e80 <sys_link+0xf4>
    80004dbc:	ee26                	sd	s1,280(sp)
  begin_op();
    80004dbe:	f1dfe0ef          	jal	80003cda <begin_op>
  if((ip = namei(old)) == 0){
    80004dc2:	ed040513          	addi	a0,s0,-304
    80004dc6:	d59fe0ef          	jal	80003b1e <namei>
    80004dca:	84aa                	mv	s1,a0
    80004dcc:	c53d                	beqz	a0,80004e3a <sys_link+0xae>
  ilock(ip);
    80004dce:	e76fe0ef          	jal	80003444 <ilock>
  if(ip->type == T_DIR){
    80004dd2:	04449703          	lh	a4,68(s1)
    80004dd6:	4785                	li	a5,1
    80004dd8:	06f70663          	beq	a4,a5,80004e44 <sys_link+0xb8>
    80004ddc:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004dde:	04a4d783          	lhu	a5,74(s1)
    80004de2:	2785                	addiw	a5,a5,1
    80004de4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004de8:	8526                	mv	a0,s1
    80004dea:	da6fe0ef          	jal	80003390 <iupdate>
  iunlock(ip);
    80004dee:	8526                	mv	a0,s1
    80004df0:	f02fe0ef          	jal	800034f2 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004df4:	fd040593          	addi	a1,s0,-48
    80004df8:	f5040513          	addi	a0,s0,-176
    80004dfc:	d3dfe0ef          	jal	80003b38 <nameiparent>
    80004e00:	892a                	mv	s2,a0
    80004e02:	cd21                	beqz	a0,80004e5a <sys_link+0xce>
  ilock(dp);
    80004e04:	e40fe0ef          	jal	80003444 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004e08:	00092703          	lw	a4,0(s2)
    80004e0c:	409c                	lw	a5,0(s1)
    80004e0e:	04f71363          	bne	a4,a5,80004e54 <sys_link+0xc8>
    80004e12:	40d0                	lw	a2,4(s1)
    80004e14:	fd040593          	addi	a1,s0,-48
    80004e18:	854a                	mv	a0,s2
    80004e1a:	c6bfe0ef          	jal	80003a84 <dirlink>
    80004e1e:	02054b63          	bltz	a0,80004e54 <sys_link+0xc8>
  iunlockput(dp);
    80004e22:	854a                	mv	a0,s2
    80004e24:	82bfe0ef          	jal	8000364e <iunlockput>
  iput(ip);
    80004e28:	8526                	mv	a0,s1
    80004e2a:	f9cfe0ef          	jal	800035c6 <iput>
  end_op();
    80004e2e:	f17fe0ef          	jal	80003d44 <end_op>
  return 0;
    80004e32:	4781                	li	a5,0
    80004e34:	64f2                	ld	s1,280(sp)
    80004e36:	6952                	ld	s2,272(sp)
    80004e38:	a0a1                	j	80004e80 <sys_link+0xf4>
    end_op();
    80004e3a:	f0bfe0ef          	jal	80003d44 <end_op>
    return -1;
    80004e3e:	57fd                	li	a5,-1
    80004e40:	64f2                	ld	s1,280(sp)
    80004e42:	a83d                	j	80004e80 <sys_link+0xf4>
    iunlockput(ip);
    80004e44:	8526                	mv	a0,s1
    80004e46:	809fe0ef          	jal	8000364e <iunlockput>
    end_op();
    80004e4a:	efbfe0ef          	jal	80003d44 <end_op>
    return -1;
    80004e4e:	57fd                	li	a5,-1
    80004e50:	64f2                	ld	s1,280(sp)
    80004e52:	a03d                	j	80004e80 <sys_link+0xf4>
    iunlockput(dp);
    80004e54:	854a                	mv	a0,s2
    80004e56:	ff8fe0ef          	jal	8000364e <iunlockput>
  ilock(ip);
    80004e5a:	8526                	mv	a0,s1
    80004e5c:	de8fe0ef          	jal	80003444 <ilock>
  ip->nlink--;
    80004e60:	04a4d783          	lhu	a5,74(s1)
    80004e64:	37fd                	addiw	a5,a5,-1
    80004e66:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004e6a:	8526                	mv	a0,s1
    80004e6c:	d24fe0ef          	jal	80003390 <iupdate>
  iunlockput(ip);
    80004e70:	8526                	mv	a0,s1
    80004e72:	fdcfe0ef          	jal	8000364e <iunlockput>
  end_op();
    80004e76:	ecffe0ef          	jal	80003d44 <end_op>
  return -1;
    80004e7a:	57fd                	li	a5,-1
    80004e7c:	64f2                	ld	s1,280(sp)
    80004e7e:	6952                	ld	s2,272(sp)
}
    80004e80:	853e                	mv	a0,a5
    80004e82:	70b2                	ld	ra,296(sp)
    80004e84:	7412                	ld	s0,288(sp)
    80004e86:	6155                	addi	sp,sp,304
    80004e88:	8082                	ret

0000000080004e8a <sys_unlink>:
{
    80004e8a:	7151                	addi	sp,sp,-240
    80004e8c:	f586                	sd	ra,232(sp)
    80004e8e:	f1a2                	sd	s0,224(sp)
    80004e90:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004e92:	08000613          	li	a2,128
    80004e96:	f3040593          	addi	a1,s0,-208
    80004e9a:	4501                	li	a0,0
    80004e9c:	acffd0ef          	jal	8000296a <argstr>
    80004ea0:	16054063          	bltz	a0,80005000 <sys_unlink+0x176>
    80004ea4:	eda6                	sd	s1,216(sp)
  begin_op();
    80004ea6:	e35fe0ef          	jal	80003cda <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004eaa:	fb040593          	addi	a1,s0,-80
    80004eae:	f3040513          	addi	a0,s0,-208
    80004eb2:	c87fe0ef          	jal	80003b38 <nameiparent>
    80004eb6:	84aa                	mv	s1,a0
    80004eb8:	c945                	beqz	a0,80004f68 <sys_unlink+0xde>
  ilock(dp);
    80004eba:	d8afe0ef          	jal	80003444 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004ebe:	00002597          	auipc	a1,0x2
    80004ec2:	77258593          	addi	a1,a1,1906 # 80007630 <etext+0x630>
    80004ec6:	fb040513          	addi	a0,s0,-80
    80004eca:	9d9fe0ef          	jal	800038a2 <namecmp>
    80004ece:	10050e63          	beqz	a0,80004fea <sys_unlink+0x160>
    80004ed2:	00002597          	auipc	a1,0x2
    80004ed6:	76658593          	addi	a1,a1,1894 # 80007638 <etext+0x638>
    80004eda:	fb040513          	addi	a0,s0,-80
    80004ede:	9c5fe0ef          	jal	800038a2 <namecmp>
    80004ee2:	10050463          	beqz	a0,80004fea <sys_unlink+0x160>
    80004ee6:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004ee8:	f2c40613          	addi	a2,s0,-212
    80004eec:	fb040593          	addi	a1,s0,-80
    80004ef0:	8526                	mv	a0,s1
    80004ef2:	9c7fe0ef          	jal	800038b8 <dirlookup>
    80004ef6:	892a                	mv	s2,a0
    80004ef8:	0e050863          	beqz	a0,80004fe8 <sys_unlink+0x15e>
  ilock(ip);
    80004efc:	d48fe0ef          	jal	80003444 <ilock>
  if(ip->nlink < 1)
    80004f00:	04a91783          	lh	a5,74(s2)
    80004f04:	06f05763          	blez	a5,80004f72 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004f08:	04491703          	lh	a4,68(s2)
    80004f0c:	4785                	li	a5,1
    80004f0e:	06f70963          	beq	a4,a5,80004f80 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004f12:	4641                	li	a2,16
    80004f14:	4581                	li	a1,0
    80004f16:	fc040513          	addi	a0,s0,-64
    80004f1a:	dbdfb0ef          	jal	80000cd6 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004f1e:	4741                	li	a4,16
    80004f20:	f2c42683          	lw	a3,-212(s0)
    80004f24:	fc040613          	addi	a2,s0,-64
    80004f28:	4581                	li	a1,0
    80004f2a:	8526                	mv	a0,s1
    80004f2c:	869fe0ef          	jal	80003794 <writei>
    80004f30:	47c1                	li	a5,16
    80004f32:	08f51b63          	bne	a0,a5,80004fc8 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004f36:	04491703          	lh	a4,68(s2)
    80004f3a:	4785                	li	a5,1
    80004f3c:	08f70d63          	beq	a4,a5,80004fd6 <sys_unlink+0x14c>
  iunlockput(dp);
    80004f40:	8526                	mv	a0,s1
    80004f42:	f0cfe0ef          	jal	8000364e <iunlockput>
  ip->nlink--;
    80004f46:	04a95783          	lhu	a5,74(s2)
    80004f4a:	37fd                	addiw	a5,a5,-1
    80004f4c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004f50:	854a                	mv	a0,s2
    80004f52:	c3efe0ef          	jal	80003390 <iupdate>
  iunlockput(ip);
    80004f56:	854a                	mv	a0,s2
    80004f58:	ef6fe0ef          	jal	8000364e <iunlockput>
  end_op();
    80004f5c:	de9fe0ef          	jal	80003d44 <end_op>
  return 0;
    80004f60:	4501                	li	a0,0
    80004f62:	64ee                	ld	s1,216(sp)
    80004f64:	694e                	ld	s2,208(sp)
    80004f66:	a849                	j	80004ff8 <sys_unlink+0x16e>
    end_op();
    80004f68:	dddfe0ef          	jal	80003d44 <end_op>
    return -1;
    80004f6c:	557d                	li	a0,-1
    80004f6e:	64ee                	ld	s1,216(sp)
    80004f70:	a061                	j	80004ff8 <sys_unlink+0x16e>
    80004f72:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004f74:	00002517          	auipc	a0,0x2
    80004f78:	6cc50513          	addi	a0,a0,1740 # 80007640 <etext+0x640>
    80004f7c:	827fb0ef          	jal	800007a2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004f80:	04c92703          	lw	a4,76(s2)
    80004f84:	02000793          	li	a5,32
    80004f88:	f8e7f5e3          	bgeu	a5,a4,80004f12 <sys_unlink+0x88>
    80004f8c:	e5ce                	sd	s3,200(sp)
    80004f8e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004f92:	4741                	li	a4,16
    80004f94:	86ce                	mv	a3,s3
    80004f96:	f1840613          	addi	a2,s0,-232
    80004f9a:	4581                	li	a1,0
    80004f9c:	854a                	mv	a0,s2
    80004f9e:	efafe0ef          	jal	80003698 <readi>
    80004fa2:	47c1                	li	a5,16
    80004fa4:	00f51c63          	bne	a0,a5,80004fbc <sys_unlink+0x132>
    if(de.inum != 0)
    80004fa8:	f1845783          	lhu	a5,-232(s0)
    80004fac:	efa1                	bnez	a5,80005004 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004fae:	29c1                	addiw	s3,s3,16
    80004fb0:	04c92783          	lw	a5,76(s2)
    80004fb4:	fcf9efe3          	bltu	s3,a5,80004f92 <sys_unlink+0x108>
    80004fb8:	69ae                	ld	s3,200(sp)
    80004fba:	bfa1                	j	80004f12 <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004fbc:	00002517          	auipc	a0,0x2
    80004fc0:	69c50513          	addi	a0,a0,1692 # 80007658 <etext+0x658>
    80004fc4:	fdefb0ef          	jal	800007a2 <panic>
    80004fc8:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004fca:	00002517          	auipc	a0,0x2
    80004fce:	6a650513          	addi	a0,a0,1702 # 80007670 <etext+0x670>
    80004fd2:	fd0fb0ef          	jal	800007a2 <panic>
    dp->nlink--;
    80004fd6:	04a4d783          	lhu	a5,74(s1)
    80004fda:	37fd                	addiw	a5,a5,-1
    80004fdc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004fe0:	8526                	mv	a0,s1
    80004fe2:	baefe0ef          	jal	80003390 <iupdate>
    80004fe6:	bfa9                	j	80004f40 <sys_unlink+0xb6>
    80004fe8:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004fea:	8526                	mv	a0,s1
    80004fec:	e62fe0ef          	jal	8000364e <iunlockput>
  end_op();
    80004ff0:	d55fe0ef          	jal	80003d44 <end_op>
  return -1;
    80004ff4:	557d                	li	a0,-1
    80004ff6:	64ee                	ld	s1,216(sp)
}
    80004ff8:	70ae                	ld	ra,232(sp)
    80004ffa:	740e                	ld	s0,224(sp)
    80004ffc:	616d                	addi	sp,sp,240
    80004ffe:	8082                	ret
    return -1;
    80005000:	557d                	li	a0,-1
    80005002:	bfdd                	j	80004ff8 <sys_unlink+0x16e>
    iunlockput(ip);
    80005004:	854a                	mv	a0,s2
    80005006:	e48fe0ef          	jal	8000364e <iunlockput>
    goto bad;
    8000500a:	694e                	ld	s2,208(sp)
    8000500c:	69ae                	ld	s3,200(sp)
    8000500e:	bff1                	j	80004fea <sys_unlink+0x160>

0000000080005010 <sys_open>:

uint64
sys_open(void)
{
    80005010:	7131                	addi	sp,sp,-192
    80005012:	fd06                	sd	ra,184(sp)
    80005014:	f922                	sd	s0,176(sp)
    80005016:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005018:	f4c40593          	addi	a1,s0,-180
    8000501c:	4505                	li	a0,1
    8000501e:	915fd0ef          	jal	80002932 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005022:	08000613          	li	a2,128
    80005026:	f5040593          	addi	a1,s0,-176
    8000502a:	4501                	li	a0,0
    8000502c:	93ffd0ef          	jal	8000296a <argstr>
    80005030:	87aa                	mv	a5,a0
    return -1;
    80005032:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005034:	0a07c263          	bltz	a5,800050d8 <sys_open+0xc8>
    80005038:	f526                	sd	s1,168(sp)

  begin_op();
    8000503a:	ca1fe0ef          	jal	80003cda <begin_op>

  if(omode & O_CREATE){
    8000503e:	f4c42783          	lw	a5,-180(s0)
    80005042:	2007f793          	andi	a5,a5,512
    80005046:	c3d5                	beqz	a5,800050ea <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80005048:	4681                	li	a3,0
    8000504a:	4601                	li	a2,0
    8000504c:	4589                	li	a1,2
    8000504e:	f5040513          	addi	a0,s0,-176
    80005052:	aa9ff0ef          	jal	80004afa <create>
    80005056:	84aa                	mv	s1,a0
    if(ip == 0){
    80005058:	c541                	beqz	a0,800050e0 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000505a:	04449703          	lh	a4,68(s1)
    8000505e:	478d                	li	a5,3
    80005060:	00f71763          	bne	a4,a5,8000506e <sys_open+0x5e>
    80005064:	0464d703          	lhu	a4,70(s1)
    80005068:	47a5                	li	a5,9
    8000506a:	0ae7ed63          	bltu	a5,a4,80005124 <sys_open+0x114>
    8000506e:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005070:	fe1fe0ef          	jal	80004050 <filealloc>
    80005074:	892a                	mv	s2,a0
    80005076:	c179                	beqz	a0,8000513c <sys_open+0x12c>
    80005078:	ed4e                	sd	s3,152(sp)
    8000507a:	a43ff0ef          	jal	80004abc <fdalloc>
    8000507e:	89aa                	mv	s3,a0
    80005080:	0a054a63          	bltz	a0,80005134 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005084:	04449703          	lh	a4,68(s1)
    80005088:	478d                	li	a5,3
    8000508a:	0cf70263          	beq	a4,a5,8000514e <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000508e:	4789                	li	a5,2
    80005090:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005094:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005098:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000509c:	f4c42783          	lw	a5,-180(s0)
    800050a0:	0017c713          	xori	a4,a5,1
    800050a4:	8b05                	andi	a4,a4,1
    800050a6:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800050aa:	0037f713          	andi	a4,a5,3
    800050ae:	00e03733          	snez	a4,a4
    800050b2:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800050b6:	4007f793          	andi	a5,a5,1024
    800050ba:	c791                	beqz	a5,800050c6 <sys_open+0xb6>
    800050bc:	04449703          	lh	a4,68(s1)
    800050c0:	4789                	li	a5,2
    800050c2:	08f70d63          	beq	a4,a5,8000515c <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800050c6:	8526                	mv	a0,s1
    800050c8:	c2afe0ef          	jal	800034f2 <iunlock>
  end_op();
    800050cc:	c79fe0ef          	jal	80003d44 <end_op>

  return fd;
    800050d0:	854e                	mv	a0,s3
    800050d2:	74aa                	ld	s1,168(sp)
    800050d4:	790a                	ld	s2,160(sp)
    800050d6:	69ea                	ld	s3,152(sp)
}
    800050d8:	70ea                	ld	ra,184(sp)
    800050da:	744a                	ld	s0,176(sp)
    800050dc:	6129                	addi	sp,sp,192
    800050de:	8082                	ret
      end_op();
    800050e0:	c65fe0ef          	jal	80003d44 <end_op>
      return -1;
    800050e4:	557d                	li	a0,-1
    800050e6:	74aa                	ld	s1,168(sp)
    800050e8:	bfc5                	j	800050d8 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800050ea:	f5040513          	addi	a0,s0,-176
    800050ee:	a31fe0ef          	jal	80003b1e <namei>
    800050f2:	84aa                	mv	s1,a0
    800050f4:	c11d                	beqz	a0,8000511a <sys_open+0x10a>
    ilock(ip);
    800050f6:	b4efe0ef          	jal	80003444 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800050fa:	04449703          	lh	a4,68(s1)
    800050fe:	4785                	li	a5,1
    80005100:	f4f71de3          	bne	a4,a5,8000505a <sys_open+0x4a>
    80005104:	f4c42783          	lw	a5,-180(s0)
    80005108:	d3bd                	beqz	a5,8000506e <sys_open+0x5e>
      iunlockput(ip);
    8000510a:	8526                	mv	a0,s1
    8000510c:	d42fe0ef          	jal	8000364e <iunlockput>
      end_op();
    80005110:	c35fe0ef          	jal	80003d44 <end_op>
      return -1;
    80005114:	557d                	li	a0,-1
    80005116:	74aa                	ld	s1,168(sp)
    80005118:	b7c1                	j	800050d8 <sys_open+0xc8>
      end_op();
    8000511a:	c2bfe0ef          	jal	80003d44 <end_op>
      return -1;
    8000511e:	557d                	li	a0,-1
    80005120:	74aa                	ld	s1,168(sp)
    80005122:	bf5d                	j	800050d8 <sys_open+0xc8>
    iunlockput(ip);
    80005124:	8526                	mv	a0,s1
    80005126:	d28fe0ef          	jal	8000364e <iunlockput>
    end_op();
    8000512a:	c1bfe0ef          	jal	80003d44 <end_op>
    return -1;
    8000512e:	557d                	li	a0,-1
    80005130:	74aa                	ld	s1,168(sp)
    80005132:	b75d                	j	800050d8 <sys_open+0xc8>
      fileclose(f);
    80005134:	854a                	mv	a0,s2
    80005136:	fbffe0ef          	jal	800040f4 <fileclose>
    8000513a:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000513c:	8526                	mv	a0,s1
    8000513e:	d10fe0ef          	jal	8000364e <iunlockput>
    end_op();
    80005142:	c03fe0ef          	jal	80003d44 <end_op>
    return -1;
    80005146:	557d                	li	a0,-1
    80005148:	74aa                	ld	s1,168(sp)
    8000514a:	790a                	ld	s2,160(sp)
    8000514c:	b771                	j	800050d8 <sys_open+0xc8>
    f->type = FD_DEVICE;
    8000514e:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005152:	04649783          	lh	a5,70(s1)
    80005156:	02f91223          	sh	a5,36(s2)
    8000515a:	bf3d                	j	80005098 <sys_open+0x88>
    itrunc(ip);
    8000515c:	8526                	mv	a0,s1
    8000515e:	bd4fe0ef          	jal	80003532 <itrunc>
    80005162:	b795                	j	800050c6 <sys_open+0xb6>

0000000080005164 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005164:	7175                	addi	sp,sp,-144
    80005166:	e506                	sd	ra,136(sp)
    80005168:	e122                	sd	s0,128(sp)
    8000516a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000516c:	b6ffe0ef          	jal	80003cda <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005170:	08000613          	li	a2,128
    80005174:	f7040593          	addi	a1,s0,-144
    80005178:	4501                	li	a0,0
    8000517a:	ff0fd0ef          	jal	8000296a <argstr>
    8000517e:	02054363          	bltz	a0,800051a4 <sys_mkdir+0x40>
    80005182:	4681                	li	a3,0
    80005184:	4601                	li	a2,0
    80005186:	4585                	li	a1,1
    80005188:	f7040513          	addi	a0,s0,-144
    8000518c:	96fff0ef          	jal	80004afa <create>
    80005190:	c911                	beqz	a0,800051a4 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005192:	cbcfe0ef          	jal	8000364e <iunlockput>
  end_op();
    80005196:	baffe0ef          	jal	80003d44 <end_op>
  return 0;
    8000519a:	4501                	li	a0,0
}
    8000519c:	60aa                	ld	ra,136(sp)
    8000519e:	640a                	ld	s0,128(sp)
    800051a0:	6149                	addi	sp,sp,144
    800051a2:	8082                	ret
    end_op();
    800051a4:	ba1fe0ef          	jal	80003d44 <end_op>
    return -1;
    800051a8:	557d                	li	a0,-1
    800051aa:	bfcd                	j	8000519c <sys_mkdir+0x38>

00000000800051ac <sys_mknod>:

uint64
sys_mknod(void)
{
    800051ac:	7135                	addi	sp,sp,-160
    800051ae:	ed06                	sd	ra,152(sp)
    800051b0:	e922                	sd	s0,144(sp)
    800051b2:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800051b4:	b27fe0ef          	jal	80003cda <begin_op>
  argint(1, &major);
    800051b8:	f6c40593          	addi	a1,s0,-148
    800051bc:	4505                	li	a0,1
    800051be:	f74fd0ef          	jal	80002932 <argint>
  argint(2, &minor);
    800051c2:	f6840593          	addi	a1,s0,-152
    800051c6:	4509                	li	a0,2
    800051c8:	f6afd0ef          	jal	80002932 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800051cc:	08000613          	li	a2,128
    800051d0:	f7040593          	addi	a1,s0,-144
    800051d4:	4501                	li	a0,0
    800051d6:	f94fd0ef          	jal	8000296a <argstr>
    800051da:	02054563          	bltz	a0,80005204 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800051de:	f6841683          	lh	a3,-152(s0)
    800051e2:	f6c41603          	lh	a2,-148(s0)
    800051e6:	458d                	li	a1,3
    800051e8:	f7040513          	addi	a0,s0,-144
    800051ec:	90fff0ef          	jal	80004afa <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800051f0:	c911                	beqz	a0,80005204 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800051f2:	c5cfe0ef          	jal	8000364e <iunlockput>
  end_op();
    800051f6:	b4ffe0ef          	jal	80003d44 <end_op>
  return 0;
    800051fa:	4501                	li	a0,0
}
    800051fc:	60ea                	ld	ra,152(sp)
    800051fe:	644a                	ld	s0,144(sp)
    80005200:	610d                	addi	sp,sp,160
    80005202:	8082                	ret
    end_op();
    80005204:	b41fe0ef          	jal	80003d44 <end_op>
    return -1;
    80005208:	557d                	li	a0,-1
    8000520a:	bfcd                	j	800051fc <sys_mknod+0x50>

000000008000520c <sys_chdir>:

uint64
sys_chdir(void)
{
    8000520c:	7135                	addi	sp,sp,-160
    8000520e:	ed06                	sd	ra,152(sp)
    80005210:	e922                	sd	s0,144(sp)
    80005212:	e14a                	sd	s2,128(sp)
    80005214:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005216:	eeafc0ef          	jal	80001900 <myproc>
    8000521a:	892a                	mv	s2,a0
  
  begin_op();
    8000521c:	abffe0ef          	jal	80003cda <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005220:	08000613          	li	a2,128
    80005224:	f6040593          	addi	a1,s0,-160
    80005228:	4501                	li	a0,0
    8000522a:	f40fd0ef          	jal	8000296a <argstr>
    8000522e:	04054363          	bltz	a0,80005274 <sys_chdir+0x68>
    80005232:	e526                	sd	s1,136(sp)
    80005234:	f6040513          	addi	a0,s0,-160
    80005238:	8e7fe0ef          	jal	80003b1e <namei>
    8000523c:	84aa                	mv	s1,a0
    8000523e:	c915                	beqz	a0,80005272 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005240:	a04fe0ef          	jal	80003444 <ilock>
  if(ip->type != T_DIR){
    80005244:	04449703          	lh	a4,68(s1)
    80005248:	4785                	li	a5,1
    8000524a:	02f71963          	bne	a4,a5,8000527c <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000524e:	8526                	mv	a0,s1
    80005250:	aa2fe0ef          	jal	800034f2 <iunlock>
  iput(p->cwd);
    80005254:	15093503          	ld	a0,336(s2)
    80005258:	b6efe0ef          	jal	800035c6 <iput>
  end_op();
    8000525c:	ae9fe0ef          	jal	80003d44 <end_op>
  p->cwd = ip;
    80005260:	14993823          	sd	s1,336(s2)
  return 0;
    80005264:	4501                	li	a0,0
    80005266:	64aa                	ld	s1,136(sp)
}
    80005268:	60ea                	ld	ra,152(sp)
    8000526a:	644a                	ld	s0,144(sp)
    8000526c:	690a                	ld	s2,128(sp)
    8000526e:	610d                	addi	sp,sp,160
    80005270:	8082                	ret
    80005272:	64aa                	ld	s1,136(sp)
    end_op();
    80005274:	ad1fe0ef          	jal	80003d44 <end_op>
    return -1;
    80005278:	557d                	li	a0,-1
    8000527a:	b7fd                	j	80005268 <sys_chdir+0x5c>
    iunlockput(ip);
    8000527c:	8526                	mv	a0,s1
    8000527e:	bd0fe0ef          	jal	8000364e <iunlockput>
    end_op();
    80005282:	ac3fe0ef          	jal	80003d44 <end_op>
    return -1;
    80005286:	557d                	li	a0,-1
    80005288:	64aa                	ld	s1,136(sp)
    8000528a:	bff9                	j	80005268 <sys_chdir+0x5c>

000000008000528c <sys_exec>:

uint64
sys_exec(void)
{
    8000528c:	7121                	addi	sp,sp,-448
    8000528e:	ff06                	sd	ra,440(sp)
    80005290:	fb22                	sd	s0,432(sp)
    80005292:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005294:	e4840593          	addi	a1,s0,-440
    80005298:	4505                	li	a0,1
    8000529a:	eb4fd0ef          	jal	8000294e <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000529e:	08000613          	li	a2,128
    800052a2:	f5040593          	addi	a1,s0,-176
    800052a6:	4501                	li	a0,0
    800052a8:	ec2fd0ef          	jal	8000296a <argstr>
    800052ac:	87aa                	mv	a5,a0
    return -1;
    800052ae:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800052b0:	0c07c463          	bltz	a5,80005378 <sys_exec+0xec>
    800052b4:	f726                	sd	s1,424(sp)
    800052b6:	f34a                	sd	s2,416(sp)
    800052b8:	ef4e                	sd	s3,408(sp)
    800052ba:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800052bc:	10000613          	li	a2,256
    800052c0:	4581                	li	a1,0
    800052c2:	e5040513          	addi	a0,s0,-432
    800052c6:	a11fb0ef          	jal	80000cd6 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800052ca:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800052ce:	89a6                	mv	s3,s1
    800052d0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800052d2:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800052d6:	00391513          	slli	a0,s2,0x3
    800052da:	e4040593          	addi	a1,s0,-448
    800052de:	e4843783          	ld	a5,-440(s0)
    800052e2:	953e                	add	a0,a0,a5
    800052e4:	dc4fd0ef          	jal	800028a8 <fetchaddr>
    800052e8:	02054663          	bltz	a0,80005314 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800052ec:	e4043783          	ld	a5,-448(s0)
    800052f0:	c3a9                	beqz	a5,80005332 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800052f2:	841fb0ef          	jal	80000b32 <kalloc>
    800052f6:	85aa                	mv	a1,a0
    800052f8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800052fc:	cd01                	beqz	a0,80005314 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800052fe:	6605                	lui	a2,0x1
    80005300:	e4043503          	ld	a0,-448(s0)
    80005304:	deefd0ef          	jal	800028f2 <fetchstr>
    80005308:	00054663          	bltz	a0,80005314 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    8000530c:	0905                	addi	s2,s2,1
    8000530e:	09a1                	addi	s3,s3,8
    80005310:	fd4913e3          	bne	s2,s4,800052d6 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005314:	f5040913          	addi	s2,s0,-176
    80005318:	6088                	ld	a0,0(s1)
    8000531a:	c931                	beqz	a0,8000536e <sys_exec+0xe2>
    kfree(argv[i]);
    8000531c:	f34fb0ef          	jal	80000a50 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005320:	04a1                	addi	s1,s1,8
    80005322:	ff249be3          	bne	s1,s2,80005318 <sys_exec+0x8c>
  return -1;
    80005326:	557d                	li	a0,-1
    80005328:	74ba                	ld	s1,424(sp)
    8000532a:	791a                	ld	s2,416(sp)
    8000532c:	69fa                	ld	s3,408(sp)
    8000532e:	6a5a                	ld	s4,400(sp)
    80005330:	a0a1                	j	80005378 <sys_exec+0xec>
      argv[i] = 0;
    80005332:	0009079b          	sext.w	a5,s2
    80005336:	078e                	slli	a5,a5,0x3
    80005338:	fd078793          	addi	a5,a5,-48
    8000533c:	97a2                	add	a5,a5,s0
    8000533e:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005342:	e5040593          	addi	a1,s0,-432
    80005346:	f5040513          	addi	a0,s0,-176
    8000534a:	ba8ff0ef          	jal	800046f2 <exec>
    8000534e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005350:	f5040993          	addi	s3,s0,-176
    80005354:	6088                	ld	a0,0(s1)
    80005356:	c511                	beqz	a0,80005362 <sys_exec+0xd6>
    kfree(argv[i]);
    80005358:	ef8fb0ef          	jal	80000a50 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000535c:	04a1                	addi	s1,s1,8
    8000535e:	ff349be3          	bne	s1,s3,80005354 <sys_exec+0xc8>
  return ret;
    80005362:	854a                	mv	a0,s2
    80005364:	74ba                	ld	s1,424(sp)
    80005366:	791a                	ld	s2,416(sp)
    80005368:	69fa                	ld	s3,408(sp)
    8000536a:	6a5a                	ld	s4,400(sp)
    8000536c:	a031                	j	80005378 <sys_exec+0xec>
  return -1;
    8000536e:	557d                	li	a0,-1
    80005370:	74ba                	ld	s1,424(sp)
    80005372:	791a                	ld	s2,416(sp)
    80005374:	69fa                	ld	s3,408(sp)
    80005376:	6a5a                	ld	s4,400(sp)
}
    80005378:	70fa                	ld	ra,440(sp)
    8000537a:	745a                	ld	s0,432(sp)
    8000537c:	6139                	addi	sp,sp,448
    8000537e:	8082                	ret

0000000080005380 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005380:	7139                	addi	sp,sp,-64
    80005382:	fc06                	sd	ra,56(sp)
    80005384:	f822                	sd	s0,48(sp)
    80005386:	f426                	sd	s1,40(sp)
    80005388:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000538a:	d76fc0ef          	jal	80001900 <myproc>
    8000538e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005390:	fd840593          	addi	a1,s0,-40
    80005394:	4501                	li	a0,0
    80005396:	db8fd0ef          	jal	8000294e <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000539a:	fc840593          	addi	a1,s0,-56
    8000539e:	fd040513          	addi	a0,s0,-48
    800053a2:	85cff0ef          	jal	800043fe <pipealloc>
    return -1;
    800053a6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800053a8:	0a054463          	bltz	a0,80005450 <sys_pipe+0xd0>
  fd0 = -1;
    800053ac:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800053b0:	fd043503          	ld	a0,-48(s0)
    800053b4:	f08ff0ef          	jal	80004abc <fdalloc>
    800053b8:	fca42223          	sw	a0,-60(s0)
    800053bc:	08054163          	bltz	a0,8000543e <sys_pipe+0xbe>
    800053c0:	fc843503          	ld	a0,-56(s0)
    800053c4:	ef8ff0ef          	jal	80004abc <fdalloc>
    800053c8:	fca42023          	sw	a0,-64(s0)
    800053cc:	06054063          	bltz	a0,8000542c <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800053d0:	4691                	li	a3,4
    800053d2:	fc440613          	addi	a2,s0,-60
    800053d6:	fd843583          	ld	a1,-40(s0)
    800053da:	68a8                	ld	a0,80(s1)
    800053dc:	996fc0ef          	jal	80001572 <copyout>
    800053e0:	00054e63          	bltz	a0,800053fc <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800053e4:	4691                	li	a3,4
    800053e6:	fc040613          	addi	a2,s0,-64
    800053ea:	fd843583          	ld	a1,-40(s0)
    800053ee:	0591                	addi	a1,a1,4
    800053f0:	68a8                	ld	a0,80(s1)
    800053f2:	980fc0ef          	jal	80001572 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800053f6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800053f8:	04055c63          	bgez	a0,80005450 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800053fc:	fc442783          	lw	a5,-60(s0)
    80005400:	07e9                	addi	a5,a5,26
    80005402:	078e                	slli	a5,a5,0x3
    80005404:	97a6                	add	a5,a5,s1
    80005406:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000540a:	fc042783          	lw	a5,-64(s0)
    8000540e:	07e9                	addi	a5,a5,26
    80005410:	078e                	slli	a5,a5,0x3
    80005412:	94be                	add	s1,s1,a5
    80005414:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005418:	fd043503          	ld	a0,-48(s0)
    8000541c:	cd9fe0ef          	jal	800040f4 <fileclose>
    fileclose(wf);
    80005420:	fc843503          	ld	a0,-56(s0)
    80005424:	cd1fe0ef          	jal	800040f4 <fileclose>
    return -1;
    80005428:	57fd                	li	a5,-1
    8000542a:	a01d                	j	80005450 <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000542c:	fc442783          	lw	a5,-60(s0)
    80005430:	0007c763          	bltz	a5,8000543e <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005434:	07e9                	addi	a5,a5,26
    80005436:	078e                	slli	a5,a5,0x3
    80005438:	97a6                	add	a5,a5,s1
    8000543a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000543e:	fd043503          	ld	a0,-48(s0)
    80005442:	cb3fe0ef          	jal	800040f4 <fileclose>
    fileclose(wf);
    80005446:	fc843503          	ld	a0,-56(s0)
    8000544a:	cabfe0ef          	jal	800040f4 <fileclose>
    return -1;
    8000544e:	57fd                	li	a5,-1
}
    80005450:	853e                	mv	a0,a5
    80005452:	70e2                	ld	ra,56(sp)
    80005454:	7442                	ld	s0,48(sp)
    80005456:	74a2                	ld	s1,40(sp)
    80005458:	6121                	addi	sp,sp,64
    8000545a:	8082                	ret
    8000545c:	0000                	unimp
	...

0000000080005460 <kernelvec>:
    80005460:	7111                	addi	sp,sp,-256
    80005462:	e006                	sd	ra,0(sp)
    80005464:	e40a                	sd	sp,8(sp)
    80005466:	e80e                	sd	gp,16(sp)
    80005468:	ec12                	sd	tp,24(sp)
    8000546a:	f016                	sd	t0,32(sp)
    8000546c:	f41a                	sd	t1,40(sp)
    8000546e:	f81e                	sd	t2,48(sp)
    80005470:	e4aa                	sd	a0,72(sp)
    80005472:	e8ae                	sd	a1,80(sp)
    80005474:	ecb2                	sd	a2,88(sp)
    80005476:	f0b6                	sd	a3,96(sp)
    80005478:	f4ba                	sd	a4,104(sp)
    8000547a:	f8be                	sd	a5,112(sp)
    8000547c:	fcc2                	sd	a6,120(sp)
    8000547e:	e146                	sd	a7,128(sp)
    80005480:	edf2                	sd	t3,216(sp)
    80005482:	f1f6                	sd	t4,224(sp)
    80005484:	f5fa                	sd	t5,232(sp)
    80005486:	f9fe                	sd	t6,240(sp)
    80005488:	b30fd0ef          	jal	800027b8 <kerneltrap>
    8000548c:	6082                	ld	ra,0(sp)
    8000548e:	6122                	ld	sp,8(sp)
    80005490:	61c2                	ld	gp,16(sp)
    80005492:	7282                	ld	t0,32(sp)
    80005494:	7322                	ld	t1,40(sp)
    80005496:	73c2                	ld	t2,48(sp)
    80005498:	6526                	ld	a0,72(sp)
    8000549a:	65c6                	ld	a1,80(sp)
    8000549c:	6666                	ld	a2,88(sp)
    8000549e:	7686                	ld	a3,96(sp)
    800054a0:	7726                	ld	a4,104(sp)
    800054a2:	77c6                	ld	a5,112(sp)
    800054a4:	7866                	ld	a6,120(sp)
    800054a6:	688a                	ld	a7,128(sp)
    800054a8:	6e6e                	ld	t3,216(sp)
    800054aa:	7e8e                	ld	t4,224(sp)
    800054ac:	7f2e                	ld	t5,232(sp)
    800054ae:	7fce                	ld	t6,240(sp)
    800054b0:	6111                	addi	sp,sp,256
    800054b2:	10200073          	sret
	...

00000000800054be <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800054be:	1141                	addi	sp,sp,-16
    800054c0:	e422                	sd	s0,8(sp)
    800054c2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800054c4:	0c0007b7          	lui	a5,0xc000
    800054c8:	4705                	li	a4,1
    800054ca:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800054cc:	0c0007b7          	lui	a5,0xc000
    800054d0:	c3d8                	sw	a4,4(a5)
}
    800054d2:	6422                	ld	s0,8(sp)
    800054d4:	0141                	addi	sp,sp,16
    800054d6:	8082                	ret

00000000800054d8 <plicinithart>:

void
plicinithart(void)
{
    800054d8:	1141                	addi	sp,sp,-16
    800054da:	e406                	sd	ra,8(sp)
    800054dc:	e022                	sd	s0,0(sp)
    800054de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054e0:	bf4fc0ef          	jal	800018d4 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800054e4:	0085171b          	slliw	a4,a0,0x8
    800054e8:	0c0027b7          	lui	a5,0xc002
    800054ec:	97ba                	add	a5,a5,a4
    800054ee:	40200713          	li	a4,1026
    800054f2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800054f6:	00d5151b          	slliw	a0,a0,0xd
    800054fa:	0c2017b7          	lui	a5,0xc201
    800054fe:	97aa                	add	a5,a5,a0
    80005500:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005504:	60a2                	ld	ra,8(sp)
    80005506:	6402                	ld	s0,0(sp)
    80005508:	0141                	addi	sp,sp,16
    8000550a:	8082                	ret

000000008000550c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000550c:	1141                	addi	sp,sp,-16
    8000550e:	e406                	sd	ra,8(sp)
    80005510:	e022                	sd	s0,0(sp)
    80005512:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005514:	bc0fc0ef          	jal	800018d4 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005518:	00d5151b          	slliw	a0,a0,0xd
    8000551c:	0c2017b7          	lui	a5,0xc201
    80005520:	97aa                	add	a5,a5,a0
  return irq;
}
    80005522:	43c8                	lw	a0,4(a5)
    80005524:	60a2                	ld	ra,8(sp)
    80005526:	6402                	ld	s0,0(sp)
    80005528:	0141                	addi	sp,sp,16
    8000552a:	8082                	ret

000000008000552c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000552c:	1101                	addi	sp,sp,-32
    8000552e:	ec06                	sd	ra,24(sp)
    80005530:	e822                	sd	s0,16(sp)
    80005532:	e426                	sd	s1,8(sp)
    80005534:	1000                	addi	s0,sp,32
    80005536:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005538:	b9cfc0ef          	jal	800018d4 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000553c:	00d5151b          	slliw	a0,a0,0xd
    80005540:	0c2017b7          	lui	a5,0xc201
    80005544:	97aa                	add	a5,a5,a0
    80005546:	c3c4                	sw	s1,4(a5)
}
    80005548:	60e2                	ld	ra,24(sp)
    8000554a:	6442                	ld	s0,16(sp)
    8000554c:	64a2                	ld	s1,8(sp)
    8000554e:	6105                	addi	sp,sp,32
    80005550:	8082                	ret

0000000080005552 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005552:	1141                	addi	sp,sp,-16
    80005554:	e406                	sd	ra,8(sp)
    80005556:	e022                	sd	s0,0(sp)
    80005558:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000555a:	479d                	li	a5,7
    8000555c:	04a7ca63          	blt	a5,a0,800055b0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005560:	0001e797          	auipc	a5,0x1e
    80005564:	2b078793          	addi	a5,a5,688 # 80023810 <disk>
    80005568:	97aa                	add	a5,a5,a0
    8000556a:	0187c783          	lbu	a5,24(a5)
    8000556e:	e7b9                	bnez	a5,800055bc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005570:	00451693          	slli	a3,a0,0x4
    80005574:	0001e797          	auipc	a5,0x1e
    80005578:	29c78793          	addi	a5,a5,668 # 80023810 <disk>
    8000557c:	6398                	ld	a4,0(a5)
    8000557e:	9736                	add	a4,a4,a3
    80005580:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005584:	6398                	ld	a4,0(a5)
    80005586:	9736                	add	a4,a4,a3
    80005588:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000558c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005590:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005594:	97aa                	add	a5,a5,a0
    80005596:	4705                	li	a4,1
    80005598:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000559c:	0001e517          	auipc	a0,0x1e
    800055a0:	28c50513          	addi	a0,a0,652 # 80023828 <disk+0x18>
    800055a4:	aebfc0ef          	jal	8000208e <wakeup>
}
    800055a8:	60a2                	ld	ra,8(sp)
    800055aa:	6402                	ld	s0,0(sp)
    800055ac:	0141                	addi	sp,sp,16
    800055ae:	8082                	ret
    panic("free_desc 1");
    800055b0:	00002517          	auipc	a0,0x2
    800055b4:	0d050513          	addi	a0,a0,208 # 80007680 <etext+0x680>
    800055b8:	9eafb0ef          	jal	800007a2 <panic>
    panic("free_desc 2");
    800055bc:	00002517          	auipc	a0,0x2
    800055c0:	0d450513          	addi	a0,a0,212 # 80007690 <etext+0x690>
    800055c4:	9defb0ef          	jal	800007a2 <panic>

00000000800055c8 <virtio_disk_init>:
{
    800055c8:	1101                	addi	sp,sp,-32
    800055ca:	ec06                	sd	ra,24(sp)
    800055cc:	e822                	sd	s0,16(sp)
    800055ce:	e426                	sd	s1,8(sp)
    800055d0:	e04a                	sd	s2,0(sp)
    800055d2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800055d4:	00002597          	auipc	a1,0x2
    800055d8:	0cc58593          	addi	a1,a1,204 # 800076a0 <etext+0x6a0>
    800055dc:	0001e517          	auipc	a0,0x1e
    800055e0:	35c50513          	addi	a0,a0,860 # 80023938 <disk+0x128>
    800055e4:	d9efb0ef          	jal	80000b82 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055e8:	100017b7          	lui	a5,0x10001
    800055ec:	4398                	lw	a4,0(a5)
    800055ee:	2701                	sext.w	a4,a4
    800055f0:	747277b7          	lui	a5,0x74727
    800055f4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800055f8:	18f71063          	bne	a4,a5,80005778 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800055fc:	100017b7          	lui	a5,0x10001
    80005600:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80005602:	439c                	lw	a5,0(a5)
    80005604:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005606:	4709                	li	a4,2
    80005608:	16e79863          	bne	a5,a4,80005778 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000560c:	100017b7          	lui	a5,0x10001
    80005610:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005612:	439c                	lw	a5,0(a5)
    80005614:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005616:	16e79163          	bne	a5,a4,80005778 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000561a:	100017b7          	lui	a5,0x10001
    8000561e:	47d8                	lw	a4,12(a5)
    80005620:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005622:	554d47b7          	lui	a5,0x554d4
    80005626:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000562a:	14f71763          	bne	a4,a5,80005778 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000562e:	100017b7          	lui	a5,0x10001
    80005632:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005636:	4705                	li	a4,1
    80005638:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000563a:	470d                	li	a4,3
    8000563c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000563e:	10001737          	lui	a4,0x10001
    80005642:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005644:	c7ffe737          	lui	a4,0xc7ffe
    80005648:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdae0f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000564c:	8ef9                	and	a3,a3,a4
    8000564e:	10001737          	lui	a4,0x10001
    80005652:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005654:	472d                	li	a4,11
    80005656:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005658:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000565c:	439c                	lw	a5,0(a5)
    8000565e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005662:	8ba1                	andi	a5,a5,8
    80005664:	12078063          	beqz	a5,80005784 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005668:	100017b7          	lui	a5,0x10001
    8000566c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005670:	100017b7          	lui	a5,0x10001
    80005674:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005678:	439c                	lw	a5,0(a5)
    8000567a:	2781                	sext.w	a5,a5
    8000567c:	10079a63          	bnez	a5,80005790 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005680:	100017b7          	lui	a5,0x10001
    80005684:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005688:	439c                	lw	a5,0(a5)
    8000568a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000568c:	10078863          	beqz	a5,8000579c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005690:	471d                	li	a4,7
    80005692:	10f77b63          	bgeu	a4,a5,800057a8 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005696:	c9cfb0ef          	jal	80000b32 <kalloc>
    8000569a:	0001e497          	auipc	s1,0x1e
    8000569e:	17648493          	addi	s1,s1,374 # 80023810 <disk>
    800056a2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800056a4:	c8efb0ef          	jal	80000b32 <kalloc>
    800056a8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800056aa:	c88fb0ef          	jal	80000b32 <kalloc>
    800056ae:	87aa                	mv	a5,a0
    800056b0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800056b2:	6088                	ld	a0,0(s1)
    800056b4:	10050063          	beqz	a0,800057b4 <virtio_disk_init+0x1ec>
    800056b8:	0001e717          	auipc	a4,0x1e
    800056bc:	16073703          	ld	a4,352(a4) # 80023818 <disk+0x8>
    800056c0:	0e070a63          	beqz	a4,800057b4 <virtio_disk_init+0x1ec>
    800056c4:	0e078863          	beqz	a5,800057b4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    800056c8:	6605                	lui	a2,0x1
    800056ca:	4581                	li	a1,0
    800056cc:	e0afb0ef          	jal	80000cd6 <memset>
  memset(disk.avail, 0, PGSIZE);
    800056d0:	0001e497          	auipc	s1,0x1e
    800056d4:	14048493          	addi	s1,s1,320 # 80023810 <disk>
    800056d8:	6605                	lui	a2,0x1
    800056da:	4581                	li	a1,0
    800056dc:	6488                	ld	a0,8(s1)
    800056de:	df8fb0ef          	jal	80000cd6 <memset>
  memset(disk.used, 0, PGSIZE);
    800056e2:	6605                	lui	a2,0x1
    800056e4:	4581                	li	a1,0
    800056e6:	6888                	ld	a0,16(s1)
    800056e8:	deefb0ef          	jal	80000cd6 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800056ec:	100017b7          	lui	a5,0x10001
    800056f0:	4721                	li	a4,8
    800056f2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800056f4:	4098                	lw	a4,0(s1)
    800056f6:	100017b7          	lui	a5,0x10001
    800056fa:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800056fe:	40d8                	lw	a4,4(s1)
    80005700:	100017b7          	lui	a5,0x10001
    80005704:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005708:	649c                	ld	a5,8(s1)
    8000570a:	0007869b          	sext.w	a3,a5
    8000570e:	10001737          	lui	a4,0x10001
    80005712:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005716:	9781                	srai	a5,a5,0x20
    80005718:	10001737          	lui	a4,0x10001
    8000571c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005720:	689c                	ld	a5,16(s1)
    80005722:	0007869b          	sext.w	a3,a5
    80005726:	10001737          	lui	a4,0x10001
    8000572a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000572e:	9781                	srai	a5,a5,0x20
    80005730:	10001737          	lui	a4,0x10001
    80005734:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005738:	10001737          	lui	a4,0x10001
    8000573c:	4785                	li	a5,1
    8000573e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005740:	00f48c23          	sb	a5,24(s1)
    80005744:	00f48ca3          	sb	a5,25(s1)
    80005748:	00f48d23          	sb	a5,26(s1)
    8000574c:	00f48da3          	sb	a5,27(s1)
    80005750:	00f48e23          	sb	a5,28(s1)
    80005754:	00f48ea3          	sb	a5,29(s1)
    80005758:	00f48f23          	sb	a5,30(s1)
    8000575c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005760:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005764:	100017b7          	lui	a5,0x10001
    80005768:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000576c:	60e2                	ld	ra,24(sp)
    8000576e:	6442                	ld	s0,16(sp)
    80005770:	64a2                	ld	s1,8(sp)
    80005772:	6902                	ld	s2,0(sp)
    80005774:	6105                	addi	sp,sp,32
    80005776:	8082                	ret
    panic("could not find virtio disk");
    80005778:	00002517          	auipc	a0,0x2
    8000577c:	f3850513          	addi	a0,a0,-200 # 800076b0 <etext+0x6b0>
    80005780:	822fb0ef          	jal	800007a2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005784:	00002517          	auipc	a0,0x2
    80005788:	f4c50513          	addi	a0,a0,-180 # 800076d0 <etext+0x6d0>
    8000578c:	816fb0ef          	jal	800007a2 <panic>
    panic("virtio disk should not be ready");
    80005790:	00002517          	auipc	a0,0x2
    80005794:	f6050513          	addi	a0,a0,-160 # 800076f0 <etext+0x6f0>
    80005798:	80afb0ef          	jal	800007a2 <panic>
    panic("virtio disk has no queue 0");
    8000579c:	00002517          	auipc	a0,0x2
    800057a0:	f7450513          	addi	a0,a0,-140 # 80007710 <etext+0x710>
    800057a4:	ffffa0ef          	jal	800007a2 <panic>
    panic("virtio disk max queue too short");
    800057a8:	00002517          	auipc	a0,0x2
    800057ac:	f8850513          	addi	a0,a0,-120 # 80007730 <etext+0x730>
    800057b0:	ff3fa0ef          	jal	800007a2 <panic>
    panic("virtio disk kalloc");
    800057b4:	00002517          	auipc	a0,0x2
    800057b8:	f9c50513          	addi	a0,a0,-100 # 80007750 <etext+0x750>
    800057bc:	fe7fa0ef          	jal	800007a2 <panic>

00000000800057c0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800057c0:	7159                	addi	sp,sp,-112
    800057c2:	f486                	sd	ra,104(sp)
    800057c4:	f0a2                	sd	s0,96(sp)
    800057c6:	eca6                	sd	s1,88(sp)
    800057c8:	e8ca                	sd	s2,80(sp)
    800057ca:	e4ce                	sd	s3,72(sp)
    800057cc:	e0d2                	sd	s4,64(sp)
    800057ce:	fc56                	sd	s5,56(sp)
    800057d0:	f85a                	sd	s6,48(sp)
    800057d2:	f45e                	sd	s7,40(sp)
    800057d4:	f062                	sd	s8,32(sp)
    800057d6:	ec66                	sd	s9,24(sp)
    800057d8:	1880                	addi	s0,sp,112
    800057da:	8a2a                	mv	s4,a0
    800057dc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800057de:	00c52c83          	lw	s9,12(a0)
    800057e2:	001c9c9b          	slliw	s9,s9,0x1
    800057e6:	1c82                	slli	s9,s9,0x20
    800057e8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800057ec:	0001e517          	auipc	a0,0x1e
    800057f0:	14c50513          	addi	a0,a0,332 # 80023938 <disk+0x128>
    800057f4:	c0efb0ef          	jal	80000c02 <acquire>
  for(int i = 0; i < 3; i++){
    800057f8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800057fa:	44a1                	li	s1,8
      disk.free[i] = 0;
    800057fc:	0001eb17          	auipc	s6,0x1e
    80005800:	014b0b13          	addi	s6,s6,20 # 80023810 <disk>
  for(int i = 0; i < 3; i++){
    80005804:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005806:	0001ec17          	auipc	s8,0x1e
    8000580a:	132c0c13          	addi	s8,s8,306 # 80023938 <disk+0x128>
    8000580e:	a8b9                	j	8000586c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005810:	00fb0733          	add	a4,s6,a5
    80005814:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005818:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000581a:	0207c563          	bltz	a5,80005844 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    8000581e:	2905                	addiw	s2,s2,1
    80005820:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005822:	05590963          	beq	s2,s5,80005874 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005826:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005828:	0001e717          	auipc	a4,0x1e
    8000582c:	fe870713          	addi	a4,a4,-24 # 80023810 <disk>
    80005830:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005832:	01874683          	lbu	a3,24(a4)
    80005836:	fee9                	bnez	a3,80005810 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005838:	2785                	addiw	a5,a5,1
    8000583a:	0705                	addi	a4,a4,1
    8000583c:	fe979be3          	bne	a5,s1,80005832 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005840:	57fd                	li	a5,-1
    80005842:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005844:	01205d63          	blez	s2,8000585e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005848:	f9042503          	lw	a0,-112(s0)
    8000584c:	d07ff0ef          	jal	80005552 <free_desc>
      for(int j = 0; j < i; j++)
    80005850:	4785                	li	a5,1
    80005852:	0127d663          	bge	a5,s2,8000585e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005856:	f9442503          	lw	a0,-108(s0)
    8000585a:	cf9ff0ef          	jal	80005552 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000585e:	85e2                	mv	a1,s8
    80005860:	0001e517          	auipc	a0,0x1e
    80005864:	fc850513          	addi	a0,a0,-56 # 80023828 <disk+0x18>
    80005868:	fdafc0ef          	jal	80002042 <sleep>
  for(int i = 0; i < 3; i++){
    8000586c:	f9040613          	addi	a2,s0,-112
    80005870:	894e                	mv	s2,s3
    80005872:	bf55                	j	80005826 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005874:	f9042503          	lw	a0,-112(s0)
    80005878:	00451693          	slli	a3,a0,0x4

  if(write)
    8000587c:	0001e797          	auipc	a5,0x1e
    80005880:	f9478793          	addi	a5,a5,-108 # 80023810 <disk>
    80005884:	00a50713          	addi	a4,a0,10
    80005888:	0712                	slli	a4,a4,0x4
    8000588a:	973e                	add	a4,a4,a5
    8000588c:	01703633          	snez	a2,s7
    80005890:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005892:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005896:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000589a:	6398                	ld	a4,0(a5)
    8000589c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000589e:	0a868613          	addi	a2,a3,168
    800058a2:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800058a4:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800058a6:	6390                	ld	a2,0(a5)
    800058a8:	00d605b3          	add	a1,a2,a3
    800058ac:	4741                	li	a4,16
    800058ae:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800058b0:	4805                	li	a6,1
    800058b2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800058b6:	f9442703          	lw	a4,-108(s0)
    800058ba:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800058be:	0712                	slli	a4,a4,0x4
    800058c0:	963a                	add	a2,a2,a4
    800058c2:	058a0593          	addi	a1,s4,88
    800058c6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800058c8:	0007b883          	ld	a7,0(a5)
    800058cc:	9746                	add	a4,a4,a7
    800058ce:	40000613          	li	a2,1024
    800058d2:	c710                	sw	a2,8(a4)
  if(write)
    800058d4:	001bb613          	seqz	a2,s7
    800058d8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800058dc:	00166613          	ori	a2,a2,1
    800058e0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800058e4:	f9842583          	lw	a1,-104(s0)
    800058e8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800058ec:	00250613          	addi	a2,a0,2
    800058f0:	0612                	slli	a2,a2,0x4
    800058f2:	963e                	add	a2,a2,a5
    800058f4:	577d                	li	a4,-1
    800058f6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800058fa:	0592                	slli	a1,a1,0x4
    800058fc:	98ae                	add	a7,a7,a1
    800058fe:	03068713          	addi	a4,a3,48
    80005902:	973e                	add	a4,a4,a5
    80005904:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005908:	6398                	ld	a4,0(a5)
    8000590a:	972e                	add	a4,a4,a1
    8000590c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005910:	4689                	li	a3,2
    80005912:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005916:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000591a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    8000591e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005922:	6794                	ld	a3,8(a5)
    80005924:	0026d703          	lhu	a4,2(a3)
    80005928:	8b1d                	andi	a4,a4,7
    8000592a:	0706                	slli	a4,a4,0x1
    8000592c:	96ba                	add	a3,a3,a4
    8000592e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005932:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005936:	6798                	ld	a4,8(a5)
    80005938:	00275783          	lhu	a5,2(a4)
    8000593c:	2785                	addiw	a5,a5,1
    8000593e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005942:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005946:	100017b7          	lui	a5,0x10001
    8000594a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000594e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005952:	0001e917          	auipc	s2,0x1e
    80005956:	fe690913          	addi	s2,s2,-26 # 80023938 <disk+0x128>
  while(b->disk == 1) {
    8000595a:	4485                	li	s1,1
    8000595c:	01079a63          	bne	a5,a6,80005970 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005960:	85ca                	mv	a1,s2
    80005962:	8552                	mv	a0,s4
    80005964:	edefc0ef          	jal	80002042 <sleep>
  while(b->disk == 1) {
    80005968:	004a2783          	lw	a5,4(s4)
    8000596c:	fe978ae3          	beq	a5,s1,80005960 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005970:	f9042903          	lw	s2,-112(s0)
    80005974:	00290713          	addi	a4,s2,2
    80005978:	0712                	slli	a4,a4,0x4
    8000597a:	0001e797          	auipc	a5,0x1e
    8000597e:	e9678793          	addi	a5,a5,-362 # 80023810 <disk>
    80005982:	97ba                	add	a5,a5,a4
    80005984:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005988:	0001e997          	auipc	s3,0x1e
    8000598c:	e8898993          	addi	s3,s3,-376 # 80023810 <disk>
    80005990:	00491713          	slli	a4,s2,0x4
    80005994:	0009b783          	ld	a5,0(s3)
    80005998:	97ba                	add	a5,a5,a4
    8000599a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000599e:	854a                	mv	a0,s2
    800059a0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800059a4:	bafff0ef          	jal	80005552 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800059a8:	8885                	andi	s1,s1,1
    800059aa:	f0fd                	bnez	s1,80005990 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800059ac:	0001e517          	auipc	a0,0x1e
    800059b0:	f8c50513          	addi	a0,a0,-116 # 80023938 <disk+0x128>
    800059b4:	ae6fb0ef          	jal	80000c9a <release>
}
    800059b8:	70a6                	ld	ra,104(sp)
    800059ba:	7406                	ld	s0,96(sp)
    800059bc:	64e6                	ld	s1,88(sp)
    800059be:	6946                	ld	s2,80(sp)
    800059c0:	69a6                	ld	s3,72(sp)
    800059c2:	6a06                	ld	s4,64(sp)
    800059c4:	7ae2                	ld	s5,56(sp)
    800059c6:	7b42                	ld	s6,48(sp)
    800059c8:	7ba2                	ld	s7,40(sp)
    800059ca:	7c02                	ld	s8,32(sp)
    800059cc:	6ce2                	ld	s9,24(sp)
    800059ce:	6165                	addi	sp,sp,112
    800059d0:	8082                	ret

00000000800059d2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800059d2:	1101                	addi	sp,sp,-32
    800059d4:	ec06                	sd	ra,24(sp)
    800059d6:	e822                	sd	s0,16(sp)
    800059d8:	e426                	sd	s1,8(sp)
    800059da:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800059dc:	0001e497          	auipc	s1,0x1e
    800059e0:	e3448493          	addi	s1,s1,-460 # 80023810 <disk>
    800059e4:	0001e517          	auipc	a0,0x1e
    800059e8:	f5450513          	addi	a0,a0,-172 # 80023938 <disk+0x128>
    800059ec:	a16fb0ef          	jal	80000c02 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800059f0:	100017b7          	lui	a5,0x10001
    800059f4:	53b8                	lw	a4,96(a5)
    800059f6:	8b0d                	andi	a4,a4,3
    800059f8:	100017b7          	lui	a5,0x10001
    800059fc:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800059fe:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005a02:	689c                	ld	a5,16(s1)
    80005a04:	0204d703          	lhu	a4,32(s1)
    80005a08:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005a0c:	04f70663          	beq	a4,a5,80005a58 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005a10:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a14:	6898                	ld	a4,16(s1)
    80005a16:	0204d783          	lhu	a5,32(s1)
    80005a1a:	8b9d                	andi	a5,a5,7
    80005a1c:	078e                	slli	a5,a5,0x3
    80005a1e:	97ba                	add	a5,a5,a4
    80005a20:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a22:	00278713          	addi	a4,a5,2
    80005a26:	0712                	slli	a4,a4,0x4
    80005a28:	9726                	add	a4,a4,s1
    80005a2a:	01074703          	lbu	a4,16(a4)
    80005a2e:	e321                	bnez	a4,80005a6e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a30:	0789                	addi	a5,a5,2
    80005a32:	0792                	slli	a5,a5,0x4
    80005a34:	97a6                	add	a5,a5,s1
    80005a36:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005a38:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a3c:	e52fc0ef          	jal	8000208e <wakeup>

    disk.used_idx += 1;
    80005a40:	0204d783          	lhu	a5,32(s1)
    80005a44:	2785                	addiw	a5,a5,1
    80005a46:	17c2                	slli	a5,a5,0x30
    80005a48:	93c1                	srli	a5,a5,0x30
    80005a4a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a4e:	6898                	ld	a4,16(s1)
    80005a50:	00275703          	lhu	a4,2(a4)
    80005a54:	faf71ee3          	bne	a4,a5,80005a10 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005a58:	0001e517          	auipc	a0,0x1e
    80005a5c:	ee050513          	addi	a0,a0,-288 # 80023938 <disk+0x128>
    80005a60:	a3afb0ef          	jal	80000c9a <release>
}
    80005a64:	60e2                	ld	ra,24(sp)
    80005a66:	6442                	ld	s0,16(sp)
    80005a68:	64a2                	ld	s1,8(sp)
    80005a6a:	6105                	addi	sp,sp,32
    80005a6c:	8082                	ret
      panic("virtio_disk_intr status");
    80005a6e:	00002517          	auipc	a0,0x2
    80005a72:	cfa50513          	addi	a0,a0,-774 # 80007768 <etext+0x768>
    80005a76:	d2dfa0ef          	jal	800007a2 <panic>

0000000080005a7a <sys_kbdint>:
#include "types.h"
extern int keyboard_int_cnt;
uint64 sys_kbdint()
{
    80005a7a:	1141                	addi	sp,sp,-16
    80005a7c:	e422                	sd	s0,8(sp)
    80005a7e:	0800                	addi	s0,sp,16

return keyboard_int_cnt;
}
    80005a80:	00005517          	auipc	a0,0x5
    80005a84:	95052503          	lw	a0,-1712(a0) # 8000a3d0 <keyboard_int_cnt>
    80005a88:	6422                	ld	s0,8(sp)
    80005a8a:	0141                	addi	sp,sp,16
    80005a8c:	8082                	ret
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
