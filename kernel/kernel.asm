
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	1f013103          	ld	sp,496(sp) # 8000a1f0 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb27f>
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
    800000fa:	168020ef          	jal	80002262 <either_copyin>
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
    80000158:	0fc50513          	addi	a0,a0,252 # 80012250 <cons>
    8000015c:	2a7000ef          	jal	80000c02 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00012497          	auipc	s1,0x12
    80000164:	0f048493          	addi	s1,s1,240 # 80012250 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00012917          	auipc	s2,0x12
    8000016c:	18090913          	addi	s2,s2,384 # 800122e8 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	76e010ef          	jal	800018ee <myproc>
    80000184:	771010ef          	jal	800020f4 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	52f010ef          	jal	80001ebc <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	00012717          	auipc	a4,0x12
    800001a4:	0b070713          	addi	a4,a4,176 # 80012250 <cons>
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
    800001d2:	046020ef          	jal	80002218 <either_copyout>
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
    800001ee:	06650513          	addi	a0,a0,102 # 80012250 <cons>
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
    80000218:	0cf72a23          	sw	a5,212(a4) # 800122e8 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	00012517          	auipc	a0,0x12
    8000022e:	02650513          	addi	a0,a0,38 # 80012250 <cons>
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
    80000282:	fd250513          	addi	a0,a0,-46 # 80012250 <cons>
    80000286:	17d000ef          	jal	80000c02 <acquire>
  keyboard_int_cnt++;
    8000028a:	0000a717          	auipc	a4,0xa
    8000028e:	f8670713          	addi	a4,a4,-122 # 8000a210 <keyboard_int_cnt>
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
    800002ae:	7ff010ef          	jal	800022ac <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002b2:	00012517          	auipc	a0,0x12
    800002b6:	f9e50513          	addi	a0,a0,-98 # 80012250 <cons>
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
    800002d4:	f8070713          	addi	a4,a4,-128 # 80012250 <cons>
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
    800002fa:	f5a78793          	addi	a5,a5,-166 # 80012250 <cons>
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
    80000328:	fc47a783          	lw	a5,-60(a5) # 800122e8 <cons+0x98>
    8000032c:	9f1d                	subw	a4,a4,a5
    8000032e:	08000793          	li	a5,128
    80000332:	f8f710e3          	bne	a4,a5,800002b2 <consoleintr+0x40>
    80000336:	a07d                	j	800003e4 <consoleintr+0x172>
    80000338:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000033a:	00012717          	auipc	a4,0x12
    8000033e:	f1670713          	addi	a4,a4,-234 # 80012250 <cons>
    80000342:	0a072783          	lw	a5,160(a4)
    80000346:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	00012497          	auipc	s1,0x12
    8000034e:	f0648493          	addi	s1,s1,-250 # 80012250 <cons>
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
    80000390:	ec470713          	addi	a4,a4,-316 # 80012250 <cons>
    80000394:	0a072783          	lw	a5,160(a4)
    80000398:	09c72703          	lw	a4,156(a4)
    8000039c:	f0f70be3          	beq	a4,a5,800002b2 <consoleintr+0x40>
      cons.e--;
    800003a0:	37fd                	addiw	a5,a5,-1
    800003a2:	00012717          	auipc	a4,0x12
    800003a6:	f4f72723          	sw	a5,-178(a4) # 800122f0 <cons+0xa0>
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
    800003c4:	e9078793          	addi	a5,a5,-368 # 80012250 <cons>
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
    800003e8:	f0c7a423          	sw	a2,-248(a5) # 800122ec <cons+0x9c>
        wakeup(&cons.r);
    800003ec:	00012517          	auipc	a0,0x12
    800003f0:	efc50513          	addi	a0,a0,-260 # 800122e8 <cons+0x98>
    800003f4:	315010ef          	jal	80001f08 <wakeup>
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
    8000040e:	e4650513          	addi	a0,a0,-442 # 80012250 <cons>
    80000412:	770000ef          	jal	80000b82 <initlock>

  uartinit();
    80000416:	3f4000ef          	jal	8000080a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000041a:	00022797          	auipc	a5,0x22
    8000041e:	fce78793          	addi	a5,a5,-50 # 800223e8 <devsw>
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
    80000458:	31c60613          	addi	a2,a2,796 # 80007770 <digits>
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
    800004f2:	e227a783          	lw	a5,-478(a5) # 80012310 <pr+0x18>
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
    8000053e:	dbe50513          	addi	a0,a0,-578 # 800122f8 <pr>
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
    800006fe:	076b8b93          	addi	s7,s7,118 # 80007770 <digits>
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
    80000798:	b6450513          	addi	a0,a0,-1180 # 800122f8 <pr>
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
    800007b2:	b607a123          	sw	zero,-1182(a5) # 80012310 <pr+0x18>
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
    800007d6:	a4f72123          	sw	a5,-1470(a4) # 8000a214 <panicked>
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
    800007ea:	b1248493          	addi	s1,s1,-1262 # 800122f8 <pr>
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
    8000080a:	1141                	addi	sp,sp,-16
    8000080c:	e406                	sd	ra,8(sp)
    8000080e:	e022                	sd	s0,0(sp)
    80000810:	0800                	addi	s0,sp,16
    80000812:	100007b7          	lui	a5,0x10000
    80000816:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>
    8000081a:	10000737          	lui	a4,0x10000
    8000081e:	f8000693          	li	a3,-128
    80000822:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>
    80000826:	468d                	li	a3,3
    80000828:	10000637          	lui	a2,0x10000
    8000082c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>
    80000830:	000780a3          	sb	zero,1(a5)
    80000834:	00d701a3          	sb	a3,3(a4)
    80000838:	10000737          	lui	a4,0x10000
    8000083c:	461d                	li	a2,7
    8000083e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>
    80000842:	00d780a3          	sb	a3,1(a5)
    80000846:	00006597          	auipc	a1,0x6
    8000084a:	7ea58593          	addi	a1,a1,2026 # 80007030 <etext+0x30>
    8000084e:	00012517          	auipc	a0,0x12
    80000852:	aca50513          	addi	a0,a0,-1334 # 80012318 <uart_tx_lock>
    80000856:	32c000ef          	jal	80000b82 <initlock>
    8000085a:	60a2                	ld	ra,8(sp)
    8000085c:	6402                	ld	s0,0(sp)
    8000085e:	0141                	addi	sp,sp,16
    80000860:	8082                	ret

0000000080000862 <uartputc_sync>:
    80000862:	1101                	addi	sp,sp,-32
    80000864:	ec06                	sd	ra,24(sp)
    80000866:	e822                	sd	s0,16(sp)
    80000868:	e426                	sd	s1,8(sp)
    8000086a:	1000                	addi	s0,sp,32
    8000086c:	84aa                	mv	s1,a0
    8000086e:	354000ef          	jal	80000bc2 <push_off>
    80000872:	0000a797          	auipc	a5,0xa
    80000876:	9a27a783          	lw	a5,-1630(a5) # 8000a214 <panicked>
    8000087a:	e795                	bnez	a5,800008a6 <uartputc_sync+0x44>
    8000087c:	10000737          	lui	a4,0x10000
    80000880:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000882:	00074783          	lbu	a5,0(a4)
    80000886:	0207f793          	andi	a5,a5,32
    8000088a:	dfe5                	beqz	a5,80000882 <uartputc_sync+0x20>
    8000088c:	0ff4f513          	zext.b	a0,s1
    80000890:	100007b7          	lui	a5,0x10000
    80000894:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000898:	3ae000ef          	jal	80000c46 <pop_off>
    8000089c:	60e2                	ld	ra,24(sp)
    8000089e:	6442                	ld	s0,16(sp)
    800008a0:	64a2                	ld	s1,8(sp)
    800008a2:	6105                	addi	sp,sp,32
    800008a4:	8082                	ret
    800008a6:	a001                	j	800008a6 <uartputc_sync+0x44>

00000000800008a8 <uartstart>:
    800008a8:	0000a797          	auipc	a5,0xa
    800008ac:	9707b783          	ld	a5,-1680(a5) # 8000a218 <uart_tx_r>
    800008b0:	0000a717          	auipc	a4,0xa
    800008b4:	97073703          	ld	a4,-1680(a4) # 8000a220 <uart_tx_w>
    800008b8:	08f70263          	beq	a4,a5,8000093c <uartstart+0x94>
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
    800008d0:	10000937          	lui	s2,0x10000
    800008d4:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
    800008d6:	00012a97          	auipc	s5,0x12
    800008da:	a42a8a93          	addi	s5,s5,-1470 # 80012318 <uart_tx_lock>
    800008de:	0000a497          	auipc	s1,0xa
    800008e2:	93a48493          	addi	s1,s1,-1734 # 8000a218 <uart_tx_r>
    800008e6:	10000a37          	lui	s4,0x10000
    800008ea:	0000a997          	auipc	s3,0xa
    800008ee:	93698993          	addi	s3,s3,-1738 # 8000a220 <uart_tx_w>
    800008f2:	00094703          	lbu	a4,0(s2)
    800008f6:	02077713          	andi	a4,a4,32
    800008fa:	c71d                	beqz	a4,80000928 <uartstart+0x80>
    800008fc:	01f7f713          	andi	a4,a5,31
    80000900:	9756                	add	a4,a4,s5
    80000902:	01874b03          	lbu	s6,24(a4)
    80000906:	0785                	addi	a5,a5,1
    80000908:	e09c                	sd	a5,0(s1)
    8000090a:	8526                	mv	a0,s1
    8000090c:	5fc010ef          	jal	80001f08 <wakeup>
    80000910:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    80000914:	609c                	ld	a5,0(s1)
    80000916:	0009b703          	ld	a4,0(s3)
    8000091a:	fcf71ce3          	bne	a4,a5,800008f2 <uartstart+0x4a>
    8000091e:	100007b7          	lui	a5,0x10000
    80000922:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000924:	0007c783          	lbu	a5,0(a5)
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
    8000093c:	100007b7          	lui	a5,0x10000
    80000940:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000942:	0007c783          	lbu	a5,0(a5)
    80000946:	8082                	ret

0000000080000948 <uartputc>:
    80000948:	7179                	addi	sp,sp,-48
    8000094a:	f406                	sd	ra,40(sp)
    8000094c:	f022                	sd	s0,32(sp)
    8000094e:	ec26                	sd	s1,24(sp)
    80000950:	e84a                	sd	s2,16(sp)
    80000952:	e44e                	sd	s3,8(sp)
    80000954:	e052                	sd	s4,0(sp)
    80000956:	1800                	addi	s0,sp,48
    80000958:	8a2a                	mv	s4,a0
    8000095a:	00012517          	auipc	a0,0x12
    8000095e:	9be50513          	addi	a0,a0,-1602 # 80012318 <uart_tx_lock>
    80000962:	2a0000ef          	jal	80000c02 <acquire>
    80000966:	0000a797          	auipc	a5,0xa
    8000096a:	8ae7a783          	lw	a5,-1874(a5) # 8000a214 <panicked>
    8000096e:	efbd                	bnez	a5,800009ec <uartputc+0xa4>
    80000970:	0000a717          	auipc	a4,0xa
    80000974:	8b073703          	ld	a4,-1872(a4) # 8000a220 <uart_tx_w>
    80000978:	0000a797          	auipc	a5,0xa
    8000097c:	8a07b783          	ld	a5,-1888(a5) # 8000a218 <uart_tx_r>
    80000980:	02078793          	addi	a5,a5,32
    80000984:	00012997          	auipc	s3,0x12
    80000988:	99498993          	addi	s3,s3,-1644 # 80012318 <uart_tx_lock>
    8000098c:	0000a497          	auipc	s1,0xa
    80000990:	88c48493          	addi	s1,s1,-1908 # 8000a218 <uart_tx_r>
    80000994:	0000a917          	auipc	s2,0xa
    80000998:	88c90913          	addi	s2,s2,-1908 # 8000a220 <uart_tx_w>
    8000099c:	00e79d63          	bne	a5,a4,800009b6 <uartputc+0x6e>
    800009a0:	85ce                	mv	a1,s3
    800009a2:	8526                	mv	a0,s1
    800009a4:	518010ef          	jal	80001ebc <sleep>
    800009a8:	00093703          	ld	a4,0(s2)
    800009ac:	609c                	ld	a5,0(s1)
    800009ae:	02078793          	addi	a5,a5,32
    800009b2:	fee787e3          	beq	a5,a4,800009a0 <uartputc+0x58>
    800009b6:	00012497          	auipc	s1,0x12
    800009ba:	96248493          	addi	s1,s1,-1694 # 80012318 <uart_tx_lock>
    800009be:	01f77793          	andi	a5,a4,31
    800009c2:	97a6                	add	a5,a5,s1
    800009c4:	01478c23          	sb	s4,24(a5)
    800009c8:	0705                	addi	a4,a4,1
    800009ca:	0000a797          	auipc	a5,0xa
    800009ce:	84e7bb23          	sd	a4,-1962(a5) # 8000a220 <uart_tx_w>
    800009d2:	ed7ff0ef          	jal	800008a8 <uartstart>
    800009d6:	8526                	mv	a0,s1
    800009d8:	2c2000ef          	jal	80000c9a <release>
    800009dc:	70a2                	ld	ra,40(sp)
    800009de:	7402                	ld	s0,32(sp)
    800009e0:	64e2                	ld	s1,24(sp)
    800009e2:	6942                	ld	s2,16(sp)
    800009e4:	69a2                	ld	s3,8(sp)
    800009e6:	6a02                	ld	s4,0(sp)
    800009e8:	6145                	addi	sp,sp,48
    800009ea:	8082                	ret
    800009ec:	a001                	j	800009ec <uartputc+0xa4>

00000000800009ee <uartgetc>:
    800009ee:	1141                	addi	sp,sp,-16
    800009f0:	e422                	sd	s0,8(sp)
    800009f2:	0800                	addi	s0,sp,16
    800009f4:	100007b7          	lui	a5,0x10000
    800009f8:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009fa:	0007c783          	lbu	a5,0(a5)
    800009fe:	8b85                	andi	a5,a5,1
    80000a00:	cb81                	beqz	a5,80000a10 <uartgetc+0x22>
    80000a02:	100007b7          	lui	a5,0x10000
    80000a06:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000a0a:	6422                	ld	s0,8(sp)
    80000a0c:	0141                	addi	sp,sp,16
    80000a0e:	8082                	ret
    80000a10:	557d                	li	a0,-1
    80000a12:	bfe5                	j	80000a0a <uartgetc+0x1c>

0000000080000a14 <uartintr>:
    80000a14:	1101                	addi	sp,sp,-32
    80000a16:	ec06                	sd	ra,24(sp)
    80000a18:	e822                	sd	s0,16(sp)
    80000a1a:	e426                	sd	s1,8(sp)
    80000a1c:	1000                	addi	s0,sp,32
    80000a1e:	54fd                	li	s1,-1
    80000a20:	a019                	j	80000a26 <uartintr+0x12>
    80000a22:	851ff0ef          	jal	80000272 <consoleintr>
    80000a26:	fc9ff0ef          	jal	800009ee <uartgetc>
    80000a2a:	fe951ce3          	bne	a0,s1,80000a22 <uartintr+0xe>
    80000a2e:	00012497          	auipc	s1,0x12
    80000a32:	8ea48493          	addi	s1,s1,-1814 # 80012318 <uart_tx_lock>
    80000a36:	8526                	mv	a0,s1
    80000a38:	1ca000ef          	jal	80000c02 <acquire>
    80000a3c:	e6dff0ef          	jal	800008a8 <uartstart>
    80000a40:	8526                	mv	a0,s1
    80000a42:	258000ef          	jal	80000c9a <release>
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
    80000a68:	b1c78793          	addi	a5,a5,-1252 # 80023580 <end>
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
    80000a84:	8d090913          	addi	s2,s2,-1840 # 80012350 <kmem>
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
    80000b12:	84250513          	addi	a0,a0,-1982 # 80012350 <kmem>
    80000b16:	06c000ef          	jal	80000b82 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b1a:	45c5                	li	a1,17
    80000b1c:	05ee                	slli	a1,a1,0x1b
    80000b1e:	00023517          	auipc	a0,0x23
    80000b22:	a6250513          	addi	a0,a0,-1438 # 80023580 <end>
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
    80000b40:	81448493          	addi	s1,s1,-2028 # 80012350 <kmem>
    80000b44:	8526                	mv	a0,s1
    80000b46:	0bc000ef          	jal	80000c02 <acquire>
  r = kmem.freelist;
    80000b4a:	6c84                	ld	s1,24(s1)
  if(r)
    80000b4c:	c485                	beqz	s1,80000b74 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b4e:	609c                	ld	a5,0(s1)
    80000b50:	00012517          	auipc	a0,0x12
    80000b54:	80050513          	addi	a0,a0,-2048 # 80012350 <kmem>
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
    80000b74:	00011517          	auipc	a0,0x11
    80000b78:	7dc50513          	addi	a0,a0,2012 # 80012350 <kmem>
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
    80000bac:	527000ef          	jal	800018d2 <mycpu>
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
    80000bda:	4f9000ef          	jal	800018d2 <mycpu>
    80000bde:	5d3c                	lw	a5,120(a0)
    80000be0:	cb99                	beqz	a5,80000bf6 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000be2:	4f1000ef          	jal	800018d2 <mycpu>
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
    80000bf6:	4dd000ef          	jal	800018d2 <mycpu>
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
    80000c2a:	4a9000ef          	jal	800018d2 <mycpu>
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
    80000c4e:	485000ef          	jal	800018d2 <mycpu>
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
    80000d4a:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdba81>
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
    80000e78:	24b000ef          	jal	800018c2 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e7c:	00009717          	auipc	a4,0x9
    80000e80:	3ac70713          	addi	a4,a4,940 # 8000a228 <started>
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
    80000e90:	233000ef          	jal	800018c2 <cpuid>
    80000e94:	85aa                	mv	a1,a0
    80000e96:	00006517          	auipc	a0,0x6
    80000e9a:	20250513          	addi	a0,a0,514 # 80007098 <etext+0x98>
    80000e9e:	e32ff0ef          	jal	800004d0 <printf>
    kvminithart();    // turn on paging
    80000ea2:	080000ef          	jal	80000f22 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ea6:	538010ef          	jal	800023de <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000eaa:	3be040ef          	jal	80005268 <plicinithart>
  }

  scheduler();        
    80000eae:	675000ef          	jal	80001d22 <scheduler>
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
    80000ee2:	2ca000ef          	jal	800011ac <kvminit>
    kvminithart();   // turn on paging
    80000ee6:	03c000ef          	jal	80000f22 <kvminithart>
    procinit();      // process table
    80000eea:	123000ef          	jal	8000180c <procinit>
    trapinit();      // trap vectors
    80000eee:	4cc010ef          	jal	800023ba <trapinit>
    trapinithart();  // install kernel trap vector
    80000ef2:	4ec010ef          	jal	800023de <trapinithart>
    plicinit();      // set up interrupt controller
    80000ef6:	358040ef          	jal	8000524e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000efa:	36e040ef          	jal	80005268 <plicinithart>
    binit();         // buffer cache
    80000efe:	313010ef          	jal	80002a10 <binit>
    iinit();         // inode table
    80000f02:	104020ef          	jal	80003006 <iinit>
    fileinit();      // file table
    80000f06:	6b1020ef          	jal	80003db6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f0a:	44e040ef          	jal	80005358 <virtio_disk_init>
    userinit();      // first user process
    80000f0e:	449000ef          	jal	80001b56 <userinit>
    __sync_synchronize();
    80000f12:	0330000f          	fence	rw,rw
    started = 1;
    80000f16:	4785                	li	a5,1
    80000f18:	00009717          	auipc	a4,0x9
    80000f1c:	30f72823          	sw	a5,784(a4) # 8000a228 <started>
    80000f20:	b779                	j	80000eae <main+0x3e>

0000000080000f22 <kvminithart>:
    80000f22:	1141                	addi	sp,sp,-16
    80000f24:	e422                	sd	s0,8(sp)
    80000f26:	0800                	addi	s0,sp,16
    80000f28:	12000073          	sfence.vma
    80000f2c:	00009797          	auipc	a5,0x9
    80000f30:	3047b783          	ld	a5,772(a5) # 8000a230 <kernel_pagetable>
    80000f34:	83b1                	srli	a5,a5,0xc
    80000f36:	577d                	li	a4,-1
    80000f38:	177e                	slli	a4,a4,0x3f
    80000f3a:	8fd9                	or	a5,a5,a4
    80000f3c:	18079073          	csrw	satp,a5
    80000f40:	12000073          	sfence.vma
    80000f44:	6422                	ld	s0,8(sp)
    80000f46:	0141                	addi	sp,sp,16
    80000f48:	8082                	ret

0000000080000f4a <walk>:
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
    80000f64:	57fd                	li	a5,-1
    80000f66:	83e9                	srli	a5,a5,0x1a
    80000f68:	4a79                	li	s4,30
    80000f6a:	4b31                	li	s6,12
    80000f6c:	02b7fc63          	bgeu	a5,a1,80000fa4 <walk+0x5a>
    80000f70:	00006517          	auipc	a0,0x6
    80000f74:	14050513          	addi	a0,a0,320 # 800070b0 <etext+0xb0>
    80000f78:	82bff0ef          	jal	800007a2 <panic>
    80000f7c:	060a8263          	beqz	s5,80000fe0 <walk+0x96>
    80000f80:	bb3ff0ef          	jal	80000b32 <kalloc>
    80000f84:	84aa                	mv	s1,a0
    80000f86:	c139                	beqz	a0,80000fcc <walk+0x82>
    80000f88:	6605                	lui	a2,0x1
    80000f8a:	4581                	li	a1,0
    80000f8c:	d4bff0ef          	jal	80000cd6 <memset>
    80000f90:	00c4d793          	srli	a5,s1,0xc
    80000f94:	07aa                	slli	a5,a5,0xa
    80000f96:	0017e793          	ori	a5,a5,1
    80000f9a:	00f93023          	sd	a5,0(s2)
    80000f9e:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdba77>
    80000fa0:	036a0063          	beq	s4,s6,80000fc0 <walk+0x76>
    80000fa4:	0149d933          	srl	s2,s3,s4
    80000fa8:	1ff97913          	andi	s2,s2,511
    80000fac:	090e                	slli	s2,s2,0x3
    80000fae:	9926                	add	s2,s2,s1
    80000fb0:	00093483          	ld	s1,0(s2)
    80000fb4:	0014f793          	andi	a5,s1,1
    80000fb8:	d3f1                	beqz	a5,80000f7c <walk+0x32>
    80000fba:	80a9                	srli	s1,s1,0xa
    80000fbc:	04b2                	slli	s1,s1,0xc
    80000fbe:	b7c5                	j	80000f9e <walk+0x54>
    80000fc0:	00c9d513          	srli	a0,s3,0xc
    80000fc4:	1ff57513          	andi	a0,a0,511
    80000fc8:	050e                	slli	a0,a0,0x3
    80000fca:	9526                	add	a0,a0,s1
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
    80000fe0:	4501                	li	a0,0
    80000fe2:	b7ed                	j	80000fcc <walk+0x82>

0000000080000fe4 <walkaddr>:
    80000fe4:	57fd                	li	a5,-1
    80000fe6:	83e9                	srli	a5,a5,0x1a
    80000fe8:	00b7f463          	bgeu	a5,a1,80000ff0 <walkaddr+0xc>
    80000fec:	4501                	li	a0,0
    80000fee:	8082                	ret
    80000ff0:	1141                	addi	sp,sp,-16
    80000ff2:	e406                	sd	ra,8(sp)
    80000ff4:	e022                	sd	s0,0(sp)
    80000ff6:	0800                	addi	s0,sp,16
    80000ff8:	4601                	li	a2,0
    80000ffa:	f51ff0ef          	jal	80000f4a <walk>
    80000ffe:	c105                	beqz	a0,8000101e <walkaddr+0x3a>
    80001000:	611c                	ld	a5,0(a0)
    80001002:	0117f693          	andi	a3,a5,17
    80001006:	4745                	li	a4,17
    80001008:	4501                	li	a0,0
    8000100a:	00e68663          	beq	a3,a4,80001016 <walkaddr+0x32>
    8000100e:	60a2                	ld	ra,8(sp)
    80001010:	6402                	ld	s0,0(sp)
    80001012:	0141                	addi	sp,sp,16
    80001014:	8082                	ret
    80001016:	83a9                	srli	a5,a5,0xa
    80001018:	00c79513          	slli	a0,a5,0xc
    8000101c:	bfcd                	j	8000100e <walkaddr+0x2a>
    8000101e:	4501                	li	a0,0
    80001020:	b7fd                	j	8000100e <walkaddr+0x2a>

0000000080001022 <mappages>:
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
    80001038:	03459793          	slli	a5,a1,0x34
    8000103c:	e7a9                	bnez	a5,80001086 <mappages+0x64>
    8000103e:	8aaa                	mv	s5,a0
    80001040:	8b3a                	mv	s6,a4
    80001042:	03461793          	slli	a5,a2,0x34
    80001046:	e7b1                	bnez	a5,80001092 <mappages+0x70>
    80001048:	ca39                	beqz	a2,8000109e <mappages+0x7c>
    8000104a:	77fd                	lui	a5,0xfffff
    8000104c:	963e                	add	a2,a2,a5
    8000104e:	00b609b3          	add	s3,a2,a1
    80001052:	892e                	mv	s2,a1
    80001054:	40b68a33          	sub	s4,a3,a1
    80001058:	6b85                	lui	s7,0x1
    8000105a:	014904b3          	add	s1,s2,s4
    8000105e:	4605                	li	a2,1
    80001060:	85ca                	mv	a1,s2
    80001062:	8556                	mv	a0,s5
    80001064:	ee7ff0ef          	jal	80000f4a <walk>
    80001068:	c539                	beqz	a0,800010b6 <mappages+0x94>
    8000106a:	611c                	ld	a5,0(a0)
    8000106c:	8b85                	andi	a5,a5,1
    8000106e:	ef95                	bnez	a5,800010aa <mappages+0x88>
    80001070:	80b1                	srli	s1,s1,0xc
    80001072:	04aa                	slli	s1,s1,0xa
    80001074:	0164e4b3          	or	s1,s1,s6
    80001078:	0014e493          	ori	s1,s1,1
    8000107c:	e104                	sd	s1,0(a0)
    8000107e:	05390863          	beq	s2,s3,800010ce <mappages+0xac>
    80001082:	995e                	add	s2,s2,s7
    80001084:	bfd9                	j	8000105a <mappages+0x38>
    80001086:	00006517          	auipc	a0,0x6
    8000108a:	03250513          	addi	a0,a0,50 # 800070b8 <etext+0xb8>
    8000108e:	f14ff0ef          	jal	800007a2 <panic>
    80001092:	00006517          	auipc	a0,0x6
    80001096:	04650513          	addi	a0,a0,70 # 800070d8 <etext+0xd8>
    8000109a:	f08ff0ef          	jal	800007a2 <panic>
    8000109e:	00006517          	auipc	a0,0x6
    800010a2:	05a50513          	addi	a0,a0,90 # 800070f8 <etext+0xf8>
    800010a6:	efcff0ef          	jal	800007a2 <panic>
    800010aa:	00006517          	auipc	a0,0x6
    800010ae:	05e50513          	addi	a0,a0,94 # 80007108 <etext+0x108>
    800010b2:	ef0ff0ef          	jal	800007a2 <panic>
    800010b6:	557d                	li	a0,-1
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
    800010ce:	4501                	li	a0,0
    800010d0:	b7e5                	j	800010b8 <mappages+0x96>

00000000800010d2 <kvmmap>:
    800010d2:	1141                	addi	sp,sp,-16
    800010d4:	e406                	sd	ra,8(sp)
    800010d6:	e022                	sd	s0,0(sp)
    800010d8:	0800                	addi	s0,sp,16
    800010da:	87b6                	mv	a5,a3
    800010dc:	86b2                	mv	a3,a2
    800010de:	863e                	mv	a2,a5
    800010e0:	f43ff0ef          	jal	80001022 <mappages>
    800010e4:	e509                	bnez	a0,800010ee <kvmmap+0x1c>
    800010e6:	60a2                	ld	ra,8(sp)
    800010e8:	6402                	ld	s0,0(sp)
    800010ea:	0141                	addi	sp,sp,16
    800010ec:	8082                	ret
    800010ee:	00006517          	auipc	a0,0x6
    800010f2:	02a50513          	addi	a0,a0,42 # 80007118 <etext+0x118>
    800010f6:	eacff0ef          	jal	800007a2 <panic>

00000000800010fa <kvmmake>:
    800010fa:	1101                	addi	sp,sp,-32
    800010fc:	ec06                	sd	ra,24(sp)
    800010fe:	e822                	sd	s0,16(sp)
    80001100:	e426                	sd	s1,8(sp)
    80001102:	e04a                	sd	s2,0(sp)
    80001104:	1000                	addi	s0,sp,32
    80001106:	a2dff0ef          	jal	80000b32 <kalloc>
    8000110a:	84aa                	mv	s1,a0
    8000110c:	6605                	lui	a2,0x1
    8000110e:	4581                	li	a1,0
    80001110:	bc7ff0ef          	jal	80000cd6 <memset>
    80001114:	4719                	li	a4,6
    80001116:	6685                	lui	a3,0x1
    80001118:	10000637          	lui	a2,0x10000
    8000111c:	100005b7          	lui	a1,0x10000
    80001120:	8526                	mv	a0,s1
    80001122:	fb1ff0ef          	jal	800010d2 <kvmmap>
    80001126:	4719                	li	a4,6
    80001128:	6685                	lui	a3,0x1
    8000112a:	10001637          	lui	a2,0x10001
    8000112e:	100015b7          	lui	a1,0x10001
    80001132:	8526                	mv	a0,s1
    80001134:	f9fff0ef          	jal	800010d2 <kvmmap>
    80001138:	4719                	li	a4,6
    8000113a:	040006b7          	lui	a3,0x4000
    8000113e:	0c000637          	lui	a2,0xc000
    80001142:	0c0005b7          	lui	a1,0xc000
    80001146:	8526                	mv	a0,s1
    80001148:	f8bff0ef          	jal	800010d2 <kvmmap>
    8000114c:	00006917          	auipc	s2,0x6
    80001150:	eb490913          	addi	s2,s2,-332 # 80007000 <etext>
    80001154:	4729                	li	a4,10
    80001156:	80006697          	auipc	a3,0x80006
    8000115a:	eaa68693          	addi	a3,a3,-342 # 7000 <_entry-0x7fff9000>
    8000115e:	4605                	li	a2,1
    80001160:	067e                	slli	a2,a2,0x1f
    80001162:	85b2                	mv	a1,a2
    80001164:	8526                	mv	a0,s1
    80001166:	f6dff0ef          	jal	800010d2 <kvmmap>
    8000116a:	46c5                	li	a3,17
    8000116c:	06ee                	slli	a3,a3,0x1b
    8000116e:	4719                	li	a4,6
    80001170:	412686b3          	sub	a3,a3,s2
    80001174:	864a                	mv	a2,s2
    80001176:	85ca                	mv	a1,s2
    80001178:	8526                	mv	a0,s1
    8000117a:	f59ff0ef          	jal	800010d2 <kvmmap>
    8000117e:	4729                	li	a4,10
    80001180:	6685                	lui	a3,0x1
    80001182:	00005617          	auipc	a2,0x5
    80001186:	e7e60613          	addi	a2,a2,-386 # 80006000 <_trampoline>
    8000118a:	040005b7          	lui	a1,0x4000
    8000118e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001190:	05b2                	slli	a1,a1,0xc
    80001192:	8526                	mv	a0,s1
    80001194:	f3fff0ef          	jal	800010d2 <kvmmap>
    80001198:	8526                	mv	a0,s1
    8000119a:	5da000ef          	jal	80001774 <proc_mapstacks>
    8000119e:	8526                	mv	a0,s1
    800011a0:	60e2                	ld	ra,24(sp)
    800011a2:	6442                	ld	s0,16(sp)
    800011a4:	64a2                	ld	s1,8(sp)
    800011a6:	6902                	ld	s2,0(sp)
    800011a8:	6105                	addi	sp,sp,32
    800011aa:	8082                	ret

00000000800011ac <kvminit>:
    800011ac:	1141                	addi	sp,sp,-16
    800011ae:	e406                	sd	ra,8(sp)
    800011b0:	e022                	sd	s0,0(sp)
    800011b2:	0800                	addi	s0,sp,16
    800011b4:	f47ff0ef          	jal	800010fa <kvmmake>
    800011b8:	00009797          	auipc	a5,0x9
    800011bc:	06a7bc23          	sd	a0,120(a5) # 8000a230 <kernel_pagetable>
    800011c0:	60a2                	ld	ra,8(sp)
    800011c2:	6402                	ld	s0,0(sp)
    800011c4:	0141                	addi	sp,sp,16
    800011c6:	8082                	ret

00000000800011c8 <uvmunmap>:
    800011c8:	715d                	addi	sp,sp,-80
    800011ca:	e486                	sd	ra,72(sp)
    800011cc:	e0a2                	sd	s0,64(sp)
    800011ce:	0880                	addi	s0,sp,80
    800011d0:	03459793          	slli	a5,a1,0x34
    800011d4:	e39d                	bnez	a5,800011fa <uvmunmap+0x32>
    800011d6:	f84a                	sd	s2,48(sp)
    800011d8:	f44e                	sd	s3,40(sp)
    800011da:	f052                	sd	s4,32(sp)
    800011dc:	ec56                	sd	s5,24(sp)
    800011de:	e85a                	sd	s6,16(sp)
    800011e0:	e45e                	sd	s7,8(sp)
    800011e2:	8a2a                	mv	s4,a0
    800011e4:	892e                	mv	s2,a1
    800011e6:	8ab6                	mv	s5,a3
    800011e8:	0632                	slli	a2,a2,0xc
    800011ea:	00b609b3          	add	s3,a2,a1
    800011ee:	4b85                	li	s7,1
    800011f0:	6b05                	lui	s6,0x1
    800011f2:	0735ff63          	bgeu	a1,s3,80001270 <uvmunmap+0xa8>
    800011f6:	fc26                	sd	s1,56(sp)
    800011f8:	a0a9                	j	80001242 <uvmunmap+0x7a>
    800011fa:	fc26                	sd	s1,56(sp)
    800011fc:	f84a                	sd	s2,48(sp)
    800011fe:	f44e                	sd	s3,40(sp)
    80001200:	f052                	sd	s4,32(sp)
    80001202:	ec56                	sd	s5,24(sp)
    80001204:	e85a                	sd	s6,16(sp)
    80001206:	e45e                	sd	s7,8(sp)
    80001208:	00006517          	auipc	a0,0x6
    8000120c:	f1850513          	addi	a0,a0,-232 # 80007120 <etext+0x120>
    80001210:	d92ff0ef          	jal	800007a2 <panic>
    80001214:	00006517          	auipc	a0,0x6
    80001218:	f2450513          	addi	a0,a0,-220 # 80007138 <etext+0x138>
    8000121c:	d86ff0ef          	jal	800007a2 <panic>
    80001220:	00006517          	auipc	a0,0x6
    80001224:	f2850513          	addi	a0,a0,-216 # 80007148 <etext+0x148>
    80001228:	d7aff0ef          	jal	800007a2 <panic>
    8000122c:	00006517          	auipc	a0,0x6
    80001230:	f3450513          	addi	a0,a0,-204 # 80007160 <etext+0x160>
    80001234:	d6eff0ef          	jal	800007a2 <panic>
    80001238:	0004b023          	sd	zero,0(s1)
    8000123c:	995a                	add	s2,s2,s6
    8000123e:	03397863          	bgeu	s2,s3,8000126e <uvmunmap+0xa6>
    80001242:	4601                	li	a2,0
    80001244:	85ca                	mv	a1,s2
    80001246:	8552                	mv	a0,s4
    80001248:	d03ff0ef          	jal	80000f4a <walk>
    8000124c:	84aa                	mv	s1,a0
    8000124e:	d179                	beqz	a0,80001214 <uvmunmap+0x4c>
    80001250:	6108                	ld	a0,0(a0)
    80001252:	00157793          	andi	a5,a0,1
    80001256:	d7e9                	beqz	a5,80001220 <uvmunmap+0x58>
    80001258:	3ff57793          	andi	a5,a0,1023
    8000125c:	fd7788e3          	beq	a5,s7,8000122c <uvmunmap+0x64>
    80001260:	fc0a8ce3          	beqz	s5,80001238 <uvmunmap+0x70>
    80001264:	8129                	srli	a0,a0,0xa
    80001266:	0532                	slli	a0,a0,0xc
    80001268:	fe8ff0ef          	jal	80000a50 <kfree>
    8000126c:	b7f1                	j	80001238 <uvmunmap+0x70>
    8000126e:	74e2                	ld	s1,56(sp)
    80001270:	7942                	ld	s2,48(sp)
    80001272:	79a2                	ld	s3,40(sp)
    80001274:	7a02                	ld	s4,32(sp)
    80001276:	6ae2                	ld	s5,24(sp)
    80001278:	6b42                	ld	s6,16(sp)
    8000127a:	6ba2                	ld	s7,8(sp)
    8000127c:	60a6                	ld	ra,72(sp)
    8000127e:	6406                	ld	s0,64(sp)
    80001280:	6161                	addi	sp,sp,80
    80001282:	8082                	ret

0000000080001284 <uvmcreate>:
    80001284:	1101                	addi	sp,sp,-32
    80001286:	ec06                	sd	ra,24(sp)
    80001288:	e822                	sd	s0,16(sp)
    8000128a:	e426                	sd	s1,8(sp)
    8000128c:	1000                	addi	s0,sp,32
    8000128e:	8a5ff0ef          	jal	80000b32 <kalloc>
    80001292:	84aa                	mv	s1,a0
    80001294:	c509                	beqz	a0,8000129e <uvmcreate+0x1a>
    80001296:	6605                	lui	a2,0x1
    80001298:	4581                	li	a1,0
    8000129a:	a3dff0ef          	jal	80000cd6 <memset>
    8000129e:	8526                	mv	a0,s1
    800012a0:	60e2                	ld	ra,24(sp)
    800012a2:	6442                	ld	s0,16(sp)
    800012a4:	64a2                	ld	s1,8(sp)
    800012a6:	6105                	addi	sp,sp,32
    800012a8:	8082                	ret

00000000800012aa <uvmfirst>:
    800012aa:	7179                	addi	sp,sp,-48
    800012ac:	f406                	sd	ra,40(sp)
    800012ae:	f022                	sd	s0,32(sp)
    800012b0:	ec26                	sd	s1,24(sp)
    800012b2:	e84a                	sd	s2,16(sp)
    800012b4:	e44e                	sd	s3,8(sp)
    800012b6:	e052                	sd	s4,0(sp)
    800012b8:	1800                	addi	s0,sp,48
    800012ba:	6785                	lui	a5,0x1
    800012bc:	04f67063          	bgeu	a2,a5,800012fc <uvmfirst+0x52>
    800012c0:	8a2a                	mv	s4,a0
    800012c2:	89ae                	mv	s3,a1
    800012c4:	84b2                	mv	s1,a2
    800012c6:	86dff0ef          	jal	80000b32 <kalloc>
    800012ca:	892a                	mv	s2,a0
    800012cc:	6605                	lui	a2,0x1
    800012ce:	4581                	li	a1,0
    800012d0:	a07ff0ef          	jal	80000cd6 <memset>
    800012d4:	4779                	li	a4,30
    800012d6:	86ca                	mv	a3,s2
    800012d8:	6605                	lui	a2,0x1
    800012da:	4581                	li	a1,0
    800012dc:	8552                	mv	a0,s4
    800012de:	d45ff0ef          	jal	80001022 <mappages>
    800012e2:	8626                	mv	a2,s1
    800012e4:	85ce                	mv	a1,s3
    800012e6:	854a                	mv	a0,s2
    800012e8:	a4bff0ef          	jal	80000d32 <memmove>
    800012ec:	70a2                	ld	ra,40(sp)
    800012ee:	7402                	ld	s0,32(sp)
    800012f0:	64e2                	ld	s1,24(sp)
    800012f2:	6942                	ld	s2,16(sp)
    800012f4:	69a2                	ld	s3,8(sp)
    800012f6:	6a02                	ld	s4,0(sp)
    800012f8:	6145                	addi	sp,sp,48
    800012fa:	8082                	ret
    800012fc:	00006517          	auipc	a0,0x6
    80001300:	e7c50513          	addi	a0,a0,-388 # 80007178 <etext+0x178>
    80001304:	c9eff0ef          	jal	800007a2 <panic>

0000000080001308 <uvmdealloc>:
    80001308:	1101                	addi	sp,sp,-32
    8000130a:	ec06                	sd	ra,24(sp)
    8000130c:	e822                	sd	s0,16(sp)
    8000130e:	e426                	sd	s1,8(sp)
    80001310:	1000                	addi	s0,sp,32
    80001312:	84ae                	mv	s1,a1
    80001314:	00b67d63          	bgeu	a2,a1,8000132e <uvmdealloc+0x26>
    80001318:	84b2                	mv	s1,a2
    8000131a:	6785                	lui	a5,0x1
    8000131c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000131e:	00f60733          	add	a4,a2,a5
    80001322:	76fd                	lui	a3,0xfffff
    80001324:	8f75                	and	a4,a4,a3
    80001326:	97ae                	add	a5,a5,a1
    80001328:	8ff5                	and	a5,a5,a3
    8000132a:	00f76863          	bltu	a4,a5,8000133a <uvmdealloc+0x32>
    8000132e:	8526                	mv	a0,s1
    80001330:	60e2                	ld	ra,24(sp)
    80001332:	6442                	ld	s0,16(sp)
    80001334:	64a2                	ld	s1,8(sp)
    80001336:	6105                	addi	sp,sp,32
    80001338:	8082                	ret
    8000133a:	8f99                	sub	a5,a5,a4
    8000133c:	83b1                	srli	a5,a5,0xc
    8000133e:	4685                	li	a3,1
    80001340:	0007861b          	sext.w	a2,a5
    80001344:	85ba                	mv	a1,a4
    80001346:	e83ff0ef          	jal	800011c8 <uvmunmap>
    8000134a:	b7d5                	j	8000132e <uvmdealloc+0x26>

000000008000134c <uvmalloc>:
    8000134c:	08b66f63          	bltu	a2,a1,800013ea <uvmalloc+0x9e>
    80001350:	7139                	addi	sp,sp,-64
    80001352:	fc06                	sd	ra,56(sp)
    80001354:	f822                	sd	s0,48(sp)
    80001356:	ec4e                	sd	s3,24(sp)
    80001358:	e852                	sd	s4,16(sp)
    8000135a:	e456                	sd	s5,8(sp)
    8000135c:	0080                	addi	s0,sp,64
    8000135e:	8aaa                	mv	s5,a0
    80001360:	8a32                	mv	s4,a2
    80001362:	6785                	lui	a5,0x1
    80001364:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001366:	95be                	add	a1,a1,a5
    80001368:	77fd                	lui	a5,0xfffff
    8000136a:	00f5f9b3          	and	s3,a1,a5
    8000136e:	08c9f063          	bgeu	s3,a2,800013ee <uvmalloc+0xa2>
    80001372:	f426                	sd	s1,40(sp)
    80001374:	f04a                	sd	s2,32(sp)
    80001376:	e05a                	sd	s6,0(sp)
    80001378:	894e                	mv	s2,s3
    8000137a:	0126eb13          	ori	s6,a3,18
    8000137e:	fb4ff0ef          	jal	80000b32 <kalloc>
    80001382:	84aa                	mv	s1,a0
    80001384:	c515                	beqz	a0,800013b0 <uvmalloc+0x64>
    80001386:	6605                	lui	a2,0x1
    80001388:	4581                	li	a1,0
    8000138a:	94dff0ef          	jal	80000cd6 <memset>
    8000138e:	875a                	mv	a4,s6
    80001390:	86a6                	mv	a3,s1
    80001392:	6605                	lui	a2,0x1
    80001394:	85ca                	mv	a1,s2
    80001396:	8556                	mv	a0,s5
    80001398:	c8bff0ef          	jal	80001022 <mappages>
    8000139c:	e915                	bnez	a0,800013d0 <uvmalloc+0x84>
    8000139e:	6785                	lui	a5,0x1
    800013a0:	993e                	add	s2,s2,a5
    800013a2:	fd496ee3          	bltu	s2,s4,8000137e <uvmalloc+0x32>
    800013a6:	8552                	mv	a0,s4
    800013a8:	74a2                	ld	s1,40(sp)
    800013aa:	7902                	ld	s2,32(sp)
    800013ac:	6b02                	ld	s6,0(sp)
    800013ae:	a811                	j	800013c2 <uvmalloc+0x76>
    800013b0:	864e                	mv	a2,s3
    800013b2:	85ca                	mv	a1,s2
    800013b4:	8556                	mv	a0,s5
    800013b6:	f53ff0ef          	jal	80001308 <uvmdealloc>
    800013ba:	4501                	li	a0,0
    800013bc:	74a2                	ld	s1,40(sp)
    800013be:	7902                	ld	s2,32(sp)
    800013c0:	6b02                	ld	s6,0(sp)
    800013c2:	70e2                	ld	ra,56(sp)
    800013c4:	7442                	ld	s0,48(sp)
    800013c6:	69e2                	ld	s3,24(sp)
    800013c8:	6a42                	ld	s4,16(sp)
    800013ca:	6aa2                	ld	s5,8(sp)
    800013cc:	6121                	addi	sp,sp,64
    800013ce:	8082                	ret
    800013d0:	8526                	mv	a0,s1
    800013d2:	e7eff0ef          	jal	80000a50 <kfree>
    800013d6:	864e                	mv	a2,s3
    800013d8:	85ca                	mv	a1,s2
    800013da:	8556                	mv	a0,s5
    800013dc:	f2dff0ef          	jal	80001308 <uvmdealloc>
    800013e0:	4501                	li	a0,0
    800013e2:	74a2                	ld	s1,40(sp)
    800013e4:	7902                	ld	s2,32(sp)
    800013e6:	6b02                	ld	s6,0(sp)
    800013e8:	bfe9                	j	800013c2 <uvmalloc+0x76>
    800013ea:	852e                	mv	a0,a1
    800013ec:	8082                	ret
    800013ee:	8532                	mv	a0,a2
    800013f0:	bfc9                	j	800013c2 <uvmalloc+0x76>

00000000800013f2 <freewalk>:
    800013f2:	7179                	addi	sp,sp,-48
    800013f4:	f406                	sd	ra,40(sp)
    800013f6:	f022                	sd	s0,32(sp)
    800013f8:	ec26                	sd	s1,24(sp)
    800013fa:	e84a                	sd	s2,16(sp)
    800013fc:	e44e                	sd	s3,8(sp)
    800013fe:	e052                	sd	s4,0(sp)
    80001400:	1800                	addi	s0,sp,48
    80001402:	8a2a                	mv	s4,a0
    80001404:	84aa                	mv	s1,a0
    80001406:	6905                	lui	s2,0x1
    80001408:	992a                	add	s2,s2,a0
    8000140a:	4985                	li	s3,1
    8000140c:	a819                	j	80001422 <freewalk+0x30>
    8000140e:	83a9                	srli	a5,a5,0xa
    80001410:	00c79513          	slli	a0,a5,0xc
    80001414:	fdfff0ef          	jal	800013f2 <freewalk>
    80001418:	0004b023          	sd	zero,0(s1)
    8000141c:	04a1                	addi	s1,s1,8
    8000141e:	01248f63          	beq	s1,s2,8000143c <freewalk+0x4a>
    80001422:	609c                	ld	a5,0(s1)
    80001424:	00f7f713          	andi	a4,a5,15
    80001428:	ff3703e3          	beq	a4,s3,8000140e <freewalk+0x1c>
    8000142c:	8b85                	andi	a5,a5,1
    8000142e:	d7fd                	beqz	a5,8000141c <freewalk+0x2a>
    80001430:	00006517          	auipc	a0,0x6
    80001434:	d6850513          	addi	a0,a0,-664 # 80007198 <etext+0x198>
    80001438:	b6aff0ef          	jal	800007a2 <panic>
    8000143c:	8552                	mv	a0,s4
    8000143e:	e12ff0ef          	jal	80000a50 <kfree>
    80001442:	70a2                	ld	ra,40(sp)
    80001444:	7402                	ld	s0,32(sp)
    80001446:	64e2                	ld	s1,24(sp)
    80001448:	6942                	ld	s2,16(sp)
    8000144a:	69a2                	ld	s3,8(sp)
    8000144c:	6a02                	ld	s4,0(sp)
    8000144e:	6145                	addi	sp,sp,48
    80001450:	8082                	ret

0000000080001452 <uvmfree>:
    80001452:	1101                	addi	sp,sp,-32
    80001454:	ec06                	sd	ra,24(sp)
    80001456:	e822                	sd	s0,16(sp)
    80001458:	e426                	sd	s1,8(sp)
    8000145a:	1000                	addi	s0,sp,32
    8000145c:	84aa                	mv	s1,a0
    8000145e:	e989                	bnez	a1,80001470 <uvmfree+0x1e>
    80001460:	8526                	mv	a0,s1
    80001462:	f91ff0ef          	jal	800013f2 <freewalk>
    80001466:	60e2                	ld	ra,24(sp)
    80001468:	6442                	ld	s0,16(sp)
    8000146a:	64a2                	ld	s1,8(sp)
    8000146c:	6105                	addi	sp,sp,32
    8000146e:	8082                	ret
    80001470:	6785                	lui	a5,0x1
    80001472:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001474:	95be                	add	a1,a1,a5
    80001476:	4685                	li	a3,1
    80001478:	00c5d613          	srli	a2,a1,0xc
    8000147c:	4581                	li	a1,0
    8000147e:	d4bff0ef          	jal	800011c8 <uvmunmap>
    80001482:	bff9                	j	80001460 <uvmfree+0xe>

0000000080001484 <uvmcopy>:
    80001484:	c65d                	beqz	a2,80001532 <uvmcopy+0xae>
    80001486:	715d                	addi	sp,sp,-80
    80001488:	e486                	sd	ra,72(sp)
    8000148a:	e0a2                	sd	s0,64(sp)
    8000148c:	fc26                	sd	s1,56(sp)
    8000148e:	f84a                	sd	s2,48(sp)
    80001490:	f44e                	sd	s3,40(sp)
    80001492:	f052                	sd	s4,32(sp)
    80001494:	ec56                	sd	s5,24(sp)
    80001496:	e85a                	sd	s6,16(sp)
    80001498:	e45e                	sd	s7,8(sp)
    8000149a:	0880                	addi	s0,sp,80
    8000149c:	8b2a                	mv	s6,a0
    8000149e:	8aae                	mv	s5,a1
    800014a0:	8a32                	mv	s4,a2
    800014a2:	4981                	li	s3,0
    800014a4:	4601                	li	a2,0
    800014a6:	85ce                	mv	a1,s3
    800014a8:	855a                	mv	a0,s6
    800014aa:	aa1ff0ef          	jal	80000f4a <walk>
    800014ae:	c121                	beqz	a0,800014ee <uvmcopy+0x6a>
    800014b0:	6118                	ld	a4,0(a0)
    800014b2:	00177793          	andi	a5,a4,1
    800014b6:	c3b1                	beqz	a5,800014fa <uvmcopy+0x76>
    800014b8:	00a75593          	srli	a1,a4,0xa
    800014bc:	00c59b93          	slli	s7,a1,0xc
    800014c0:	3ff77493          	andi	s1,a4,1023
    800014c4:	e6eff0ef          	jal	80000b32 <kalloc>
    800014c8:	892a                	mv	s2,a0
    800014ca:	c129                	beqz	a0,8000150c <uvmcopy+0x88>
    800014cc:	6605                	lui	a2,0x1
    800014ce:	85de                	mv	a1,s7
    800014d0:	863ff0ef          	jal	80000d32 <memmove>
    800014d4:	8726                	mv	a4,s1
    800014d6:	86ca                	mv	a3,s2
    800014d8:	6605                	lui	a2,0x1
    800014da:	85ce                	mv	a1,s3
    800014dc:	8556                	mv	a0,s5
    800014de:	b45ff0ef          	jal	80001022 <mappages>
    800014e2:	e115                	bnez	a0,80001506 <uvmcopy+0x82>
    800014e4:	6785                	lui	a5,0x1
    800014e6:	99be                	add	s3,s3,a5
    800014e8:	fb49eee3          	bltu	s3,s4,800014a4 <uvmcopy+0x20>
    800014ec:	a805                	j	8000151c <uvmcopy+0x98>
    800014ee:	00006517          	auipc	a0,0x6
    800014f2:	cba50513          	addi	a0,a0,-838 # 800071a8 <etext+0x1a8>
    800014f6:	aacff0ef          	jal	800007a2 <panic>
    800014fa:	00006517          	auipc	a0,0x6
    800014fe:	cce50513          	addi	a0,a0,-818 # 800071c8 <etext+0x1c8>
    80001502:	aa0ff0ef          	jal	800007a2 <panic>
    80001506:	854a                	mv	a0,s2
    80001508:	d48ff0ef          	jal	80000a50 <kfree>
    8000150c:	4685                	li	a3,1
    8000150e:	00c9d613          	srli	a2,s3,0xc
    80001512:	4581                	li	a1,0
    80001514:	8556                	mv	a0,s5
    80001516:	cb3ff0ef          	jal	800011c8 <uvmunmap>
    8000151a:	557d                	li	a0,-1
    8000151c:	60a6                	ld	ra,72(sp)
    8000151e:	6406                	ld	s0,64(sp)
    80001520:	74e2                	ld	s1,56(sp)
    80001522:	7942                	ld	s2,48(sp)
    80001524:	79a2                	ld	s3,40(sp)
    80001526:	7a02                	ld	s4,32(sp)
    80001528:	6ae2                	ld	s5,24(sp)
    8000152a:	6b42                	ld	s6,16(sp)
    8000152c:	6ba2                	ld	s7,8(sp)
    8000152e:	6161                	addi	sp,sp,80
    80001530:	8082                	ret
    80001532:	4501                	li	a0,0
    80001534:	8082                	ret

0000000080001536 <uvmclear>:
    80001536:	1141                	addi	sp,sp,-16
    80001538:	e406                	sd	ra,8(sp)
    8000153a:	e022                	sd	s0,0(sp)
    8000153c:	0800                	addi	s0,sp,16
    8000153e:	4601                	li	a2,0
    80001540:	a0bff0ef          	jal	80000f4a <walk>
    80001544:	c901                	beqz	a0,80001554 <uvmclear+0x1e>
    80001546:	611c                	ld	a5,0(a0)
    80001548:	9bbd                	andi	a5,a5,-17
    8000154a:	e11c                	sd	a5,0(a0)
    8000154c:	60a2                	ld	ra,8(sp)
    8000154e:	6402                	ld	s0,0(sp)
    80001550:	0141                	addi	sp,sp,16
    80001552:	8082                	ret
    80001554:	00006517          	auipc	a0,0x6
    80001558:	c9450513          	addi	a0,a0,-876 # 800071e8 <etext+0x1e8>
    8000155c:	a46ff0ef          	jal	800007a2 <panic>

0000000080001560 <copyout>:
    80001560:	cad1                	beqz	a3,800015f4 <copyout+0x94>
    80001562:	711d                	addi	sp,sp,-96
    80001564:	ec86                	sd	ra,88(sp)
    80001566:	e8a2                	sd	s0,80(sp)
    80001568:	e4a6                	sd	s1,72(sp)
    8000156a:	fc4e                	sd	s3,56(sp)
    8000156c:	f456                	sd	s5,40(sp)
    8000156e:	f05a                	sd	s6,32(sp)
    80001570:	ec5e                	sd	s7,24(sp)
    80001572:	1080                	addi	s0,sp,96
    80001574:	8baa                	mv	s7,a0
    80001576:	8aae                	mv	s5,a1
    80001578:	8b32                	mv	s6,a2
    8000157a:	89b6                	mv	s3,a3
    8000157c:	74fd                	lui	s1,0xfffff
    8000157e:	8ced                	and	s1,s1,a1
    80001580:	57fd                	li	a5,-1
    80001582:	83e9                	srli	a5,a5,0x1a
    80001584:	0697ea63          	bltu	a5,s1,800015f8 <copyout+0x98>
    80001588:	e0ca                	sd	s2,64(sp)
    8000158a:	f852                	sd	s4,48(sp)
    8000158c:	e862                	sd	s8,16(sp)
    8000158e:	e466                	sd	s9,8(sp)
    80001590:	e06a                	sd	s10,0(sp)
    80001592:	4cd5                	li	s9,21
    80001594:	6d05                	lui	s10,0x1
    80001596:	8c3e                	mv	s8,a5
    80001598:	a025                	j	800015c0 <copyout+0x60>
    8000159a:	83a9                	srli	a5,a5,0xa
    8000159c:	07b2                	slli	a5,a5,0xc
    8000159e:	409a8533          	sub	a0,s5,s1
    800015a2:	0009061b          	sext.w	a2,s2
    800015a6:	85da                	mv	a1,s6
    800015a8:	953e                	add	a0,a0,a5
    800015aa:	f88ff0ef          	jal	80000d32 <memmove>
    800015ae:	412989b3          	sub	s3,s3,s2
    800015b2:	9b4a                	add	s6,s6,s2
    800015b4:	02098963          	beqz	s3,800015e6 <copyout+0x86>
    800015b8:	054c6263          	bltu	s8,s4,800015fc <copyout+0x9c>
    800015bc:	84d2                	mv	s1,s4
    800015be:	8ad2                	mv	s5,s4
    800015c0:	4601                	li	a2,0
    800015c2:	85a6                	mv	a1,s1
    800015c4:	855e                	mv	a0,s7
    800015c6:	985ff0ef          	jal	80000f4a <walk>
    800015ca:	c121                	beqz	a0,8000160a <copyout+0xaa>
    800015cc:	611c                	ld	a5,0(a0)
    800015ce:	0157f713          	andi	a4,a5,21
    800015d2:	05971b63          	bne	a4,s9,80001628 <copyout+0xc8>
    800015d6:	01a48a33          	add	s4,s1,s10
    800015da:	415a0933          	sub	s2,s4,s5
    800015de:	fb29fee3          	bgeu	s3,s2,8000159a <copyout+0x3a>
    800015e2:	894e                	mv	s2,s3
    800015e4:	bf5d                	j	8000159a <copyout+0x3a>
    800015e6:	4501                	li	a0,0
    800015e8:	6906                	ld	s2,64(sp)
    800015ea:	7a42                	ld	s4,48(sp)
    800015ec:	6c42                	ld	s8,16(sp)
    800015ee:	6ca2                	ld	s9,8(sp)
    800015f0:	6d02                	ld	s10,0(sp)
    800015f2:	a015                	j	80001616 <copyout+0xb6>
    800015f4:	4501                	li	a0,0
    800015f6:	8082                	ret
    800015f8:	557d                	li	a0,-1
    800015fa:	a831                	j	80001616 <copyout+0xb6>
    800015fc:	557d                	li	a0,-1
    800015fe:	6906                	ld	s2,64(sp)
    80001600:	7a42                	ld	s4,48(sp)
    80001602:	6c42                	ld	s8,16(sp)
    80001604:	6ca2                	ld	s9,8(sp)
    80001606:	6d02                	ld	s10,0(sp)
    80001608:	a039                	j	80001616 <copyout+0xb6>
    8000160a:	557d                	li	a0,-1
    8000160c:	6906                	ld	s2,64(sp)
    8000160e:	7a42                	ld	s4,48(sp)
    80001610:	6c42                	ld	s8,16(sp)
    80001612:	6ca2                	ld	s9,8(sp)
    80001614:	6d02                	ld	s10,0(sp)
    80001616:	60e6                	ld	ra,88(sp)
    80001618:	6446                	ld	s0,80(sp)
    8000161a:	64a6                	ld	s1,72(sp)
    8000161c:	79e2                	ld	s3,56(sp)
    8000161e:	7aa2                	ld	s5,40(sp)
    80001620:	7b02                	ld	s6,32(sp)
    80001622:	6be2                	ld	s7,24(sp)
    80001624:	6125                	addi	sp,sp,96
    80001626:	8082                	ret
    80001628:	557d                	li	a0,-1
    8000162a:	6906                	ld	s2,64(sp)
    8000162c:	7a42                	ld	s4,48(sp)
    8000162e:	6c42                	ld	s8,16(sp)
    80001630:	6ca2                	ld	s9,8(sp)
    80001632:	6d02                	ld	s10,0(sp)
    80001634:	b7cd                	j	80001616 <copyout+0xb6>

0000000080001636 <copyin>:
    80001636:	c6a5                	beqz	a3,8000169e <copyin+0x68>
    80001638:	715d                	addi	sp,sp,-80
    8000163a:	e486                	sd	ra,72(sp)
    8000163c:	e0a2                	sd	s0,64(sp)
    8000163e:	fc26                	sd	s1,56(sp)
    80001640:	f84a                	sd	s2,48(sp)
    80001642:	f44e                	sd	s3,40(sp)
    80001644:	f052                	sd	s4,32(sp)
    80001646:	ec56                	sd	s5,24(sp)
    80001648:	e85a                	sd	s6,16(sp)
    8000164a:	e45e                	sd	s7,8(sp)
    8000164c:	e062                	sd	s8,0(sp)
    8000164e:	0880                	addi	s0,sp,80
    80001650:	8b2a                	mv	s6,a0
    80001652:	8a2e                	mv	s4,a1
    80001654:	8c32                	mv	s8,a2
    80001656:	89b6                	mv	s3,a3
    80001658:	7bfd                	lui	s7,0xfffff
    8000165a:	6a85                	lui	s5,0x1
    8000165c:	a00d                	j	8000167e <copyin+0x48>
    8000165e:	018505b3          	add	a1,a0,s8
    80001662:	0004861b          	sext.w	a2,s1
    80001666:	412585b3          	sub	a1,a1,s2
    8000166a:	8552                	mv	a0,s4
    8000166c:	ec6ff0ef          	jal	80000d32 <memmove>
    80001670:	409989b3          	sub	s3,s3,s1
    80001674:	9a26                	add	s4,s4,s1
    80001676:	01590c33          	add	s8,s2,s5
    8000167a:	02098063          	beqz	s3,8000169a <copyin+0x64>
    8000167e:	017c7933          	and	s2,s8,s7
    80001682:	85ca                	mv	a1,s2
    80001684:	855a                	mv	a0,s6
    80001686:	95fff0ef          	jal	80000fe4 <walkaddr>
    8000168a:	cd01                	beqz	a0,800016a2 <copyin+0x6c>
    8000168c:	418904b3          	sub	s1,s2,s8
    80001690:	94d6                	add	s1,s1,s5
    80001692:	fc99f6e3          	bgeu	s3,s1,8000165e <copyin+0x28>
    80001696:	84ce                	mv	s1,s3
    80001698:	b7d9                	j	8000165e <copyin+0x28>
    8000169a:	4501                	li	a0,0
    8000169c:	a021                	j	800016a4 <copyin+0x6e>
    8000169e:	4501                	li	a0,0
    800016a0:	8082                	ret
    800016a2:	557d                	li	a0,-1
    800016a4:	60a6                	ld	ra,72(sp)
    800016a6:	6406                	ld	s0,64(sp)
    800016a8:	74e2                	ld	s1,56(sp)
    800016aa:	7942                	ld	s2,48(sp)
    800016ac:	79a2                	ld	s3,40(sp)
    800016ae:	7a02                	ld	s4,32(sp)
    800016b0:	6ae2                	ld	s5,24(sp)
    800016b2:	6b42                	ld	s6,16(sp)
    800016b4:	6ba2                	ld	s7,8(sp)
    800016b6:	6c02                	ld	s8,0(sp)
    800016b8:	6161                	addi	sp,sp,80
    800016ba:	8082                	ret

00000000800016bc <copyinstr>:
    800016bc:	c6dd                	beqz	a3,8000176a <copyinstr+0xae>
    800016be:	715d                	addi	sp,sp,-80
    800016c0:	e486                	sd	ra,72(sp)
    800016c2:	e0a2                	sd	s0,64(sp)
    800016c4:	fc26                	sd	s1,56(sp)
    800016c6:	f84a                	sd	s2,48(sp)
    800016c8:	f44e                	sd	s3,40(sp)
    800016ca:	f052                	sd	s4,32(sp)
    800016cc:	ec56                	sd	s5,24(sp)
    800016ce:	e85a                	sd	s6,16(sp)
    800016d0:	e45e                	sd	s7,8(sp)
    800016d2:	0880                	addi	s0,sp,80
    800016d4:	8a2a                	mv	s4,a0
    800016d6:	8b2e                	mv	s6,a1
    800016d8:	8bb2                	mv	s7,a2
    800016da:	8936                	mv	s2,a3
    800016dc:	7afd                	lui	s5,0xfffff
    800016de:	6985                	lui	s3,0x1
    800016e0:	a825                	j	80001718 <copyinstr+0x5c>
    800016e2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800016e6:	4785                	li	a5,1
    800016e8:	37fd                	addiw	a5,a5,-1
    800016ea:	0007851b          	sext.w	a0,a5
    800016ee:	60a6                	ld	ra,72(sp)
    800016f0:	6406                	ld	s0,64(sp)
    800016f2:	74e2                	ld	s1,56(sp)
    800016f4:	7942                	ld	s2,48(sp)
    800016f6:	79a2                	ld	s3,40(sp)
    800016f8:	7a02                	ld	s4,32(sp)
    800016fa:	6ae2                	ld	s5,24(sp)
    800016fc:	6b42                	ld	s6,16(sp)
    800016fe:	6ba2                	ld	s7,8(sp)
    80001700:	6161                	addi	sp,sp,80
    80001702:	8082                	ret
    80001704:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80001708:	9742                	add	a4,a4,a6
    8000170a:	40b70933          	sub	s2,a4,a1
    8000170e:	01348bb3          	add	s7,s1,s3
    80001712:	04e58463          	beq	a1,a4,8000175a <copyinstr+0x9e>
    80001716:	8b3e                	mv	s6,a5
    80001718:	015bf4b3          	and	s1,s7,s5
    8000171c:	85a6                	mv	a1,s1
    8000171e:	8552                	mv	a0,s4
    80001720:	8c5ff0ef          	jal	80000fe4 <walkaddr>
    80001724:	cd0d                	beqz	a0,8000175e <copyinstr+0xa2>
    80001726:	417486b3          	sub	a3,s1,s7
    8000172a:	96ce                	add	a3,a3,s3
    8000172c:	00d97363          	bgeu	s2,a3,80001732 <copyinstr+0x76>
    80001730:	86ca                	mv	a3,s2
    80001732:	955e                	add	a0,a0,s7
    80001734:	8d05                	sub	a0,a0,s1
    80001736:	c695                	beqz	a3,80001762 <copyinstr+0xa6>
    80001738:	87da                	mv	a5,s6
    8000173a:	885a                	mv	a6,s6
    8000173c:	41650633          	sub	a2,a0,s6
    80001740:	96da                	add	a3,a3,s6
    80001742:	85be                	mv	a1,a5
    80001744:	00f60733          	add	a4,a2,a5
    80001748:	00074703          	lbu	a4,0(a4)
    8000174c:	db59                	beqz	a4,800016e2 <copyinstr+0x26>
    8000174e:	00e78023          	sb	a4,0(a5)
    80001752:	0785                	addi	a5,a5,1
    80001754:	fed797e3          	bne	a5,a3,80001742 <copyinstr+0x86>
    80001758:	b775                	j	80001704 <copyinstr+0x48>
    8000175a:	4781                	li	a5,0
    8000175c:	b771                	j	800016e8 <copyinstr+0x2c>
    8000175e:	557d                	li	a0,-1
    80001760:	b779                	j	800016ee <copyinstr+0x32>
    80001762:	6b85                	lui	s7,0x1
    80001764:	9ba6                	add	s7,s7,s1
    80001766:	87da                	mv	a5,s6
    80001768:	b77d                	j	80001716 <copyinstr+0x5a>
    8000176a:	4781                	li	a5,0
    8000176c:	37fd                	addiw	a5,a5,-1
    8000176e:	0007851b          	sext.w	a0,a5
    80001772:	8082                	ret

0000000080001774 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001774:	7139                	addi	sp,sp,-64
    80001776:	fc06                	sd	ra,56(sp)
    80001778:	f822                	sd	s0,48(sp)
    8000177a:	f426                	sd	s1,40(sp)
    8000177c:	f04a                	sd	s2,32(sp)
    8000177e:	ec4e                	sd	s3,24(sp)
    80001780:	e852                	sd	s4,16(sp)
    80001782:	e456                	sd	s5,8(sp)
    80001784:	e05a                	sd	s6,0(sp)
    80001786:	0080                	addi	s0,sp,64
    80001788:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000178a:	00011497          	auipc	s1,0x11
    8000178e:	01648493          	addi	s1,s1,22 # 800127a0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001792:	8b26                	mv	s6,s1
    80001794:	04fa5937          	lui	s2,0x4fa5
    80001798:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    8000179c:	0932                	slli	s2,s2,0xc
    8000179e:	fa590913          	addi	s2,s2,-91
    800017a2:	0932                	slli	s2,s2,0xc
    800017a4:	fa590913          	addi	s2,s2,-91
    800017a8:	0932                	slli	s2,s2,0xc
    800017aa:	fa590913          	addi	s2,s2,-91
    800017ae:	040009b7          	lui	s3,0x4000
    800017b2:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017b4:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017b6:	00017a97          	auipc	s5,0x17
    800017ba:	9eaa8a93          	addi	s5,s5,-1558 # 800181a0 <tickslock>
    char *pa = kalloc();
    800017be:	b74ff0ef          	jal	80000b32 <kalloc>
    800017c2:	862a                	mv	a2,a0
    if(pa == 0)
    800017c4:	cd15                	beqz	a0,80001800 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017c6:	416485b3          	sub	a1,s1,s6
    800017ca:	858d                	srai	a1,a1,0x3
    800017cc:	032585b3          	mul	a1,a1,s2
    800017d0:	2585                	addiw	a1,a1,1
    800017d2:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017d6:	4719                	li	a4,6
    800017d8:	6685                	lui	a3,0x1
    800017da:	40b985b3          	sub	a1,s3,a1
    800017de:	8552                	mv	a0,s4
    800017e0:	8f3ff0ef          	jal	800010d2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017e4:	16848493          	addi	s1,s1,360
    800017e8:	fd549be3          	bne	s1,s5,800017be <proc_mapstacks+0x4a>
  }
}
    800017ec:	70e2                	ld	ra,56(sp)
    800017ee:	7442                	ld	s0,48(sp)
    800017f0:	74a2                	ld	s1,40(sp)
    800017f2:	7902                	ld	s2,32(sp)
    800017f4:	69e2                	ld	s3,24(sp)
    800017f6:	6a42                	ld	s4,16(sp)
    800017f8:	6aa2                	ld	s5,8(sp)
    800017fa:	6b02                	ld	s6,0(sp)
    800017fc:	6121                	addi	sp,sp,64
    800017fe:	8082                	ret
      panic("kalloc");
    80001800:	00006517          	auipc	a0,0x6
    80001804:	9f850513          	addi	a0,a0,-1544 # 800071f8 <etext+0x1f8>
    80001808:	f9bfe0ef          	jal	800007a2 <panic>

000000008000180c <procinit>:

// initialize the proc table.
void
procinit(void)
{
    8000180c:	7139                	addi	sp,sp,-64
    8000180e:	fc06                	sd	ra,56(sp)
    80001810:	f822                	sd	s0,48(sp)
    80001812:	f426                	sd	s1,40(sp)
    80001814:	f04a                	sd	s2,32(sp)
    80001816:	ec4e                	sd	s3,24(sp)
    80001818:	e852                	sd	s4,16(sp)
    8000181a:	e456                	sd	s5,8(sp)
    8000181c:	e05a                	sd	s6,0(sp)
    8000181e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001820:	00006597          	auipc	a1,0x6
    80001824:	9e058593          	addi	a1,a1,-1568 # 80007200 <etext+0x200>
    80001828:	00011517          	auipc	a0,0x11
    8000182c:	b4850513          	addi	a0,a0,-1208 # 80012370 <pid_lock>
    80001830:	b52ff0ef          	jal	80000b82 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001834:	00006597          	auipc	a1,0x6
    80001838:	9d458593          	addi	a1,a1,-1580 # 80007208 <etext+0x208>
    8000183c:	00011517          	auipc	a0,0x11
    80001840:	b4c50513          	addi	a0,a0,-1204 # 80012388 <wait_lock>
    80001844:	b3eff0ef          	jal	80000b82 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001848:	00011497          	auipc	s1,0x11
    8000184c:	f5848493          	addi	s1,s1,-168 # 800127a0 <proc>
      initlock(&p->lock, "proc");
    80001850:	00006b17          	auipc	s6,0x6
    80001854:	9c8b0b13          	addi	s6,s6,-1592 # 80007218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001858:	8aa6                	mv	s5,s1
    8000185a:	04fa5937          	lui	s2,0x4fa5
    8000185e:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001862:	0932                	slli	s2,s2,0xc
    80001864:	fa590913          	addi	s2,s2,-91
    80001868:	0932                	slli	s2,s2,0xc
    8000186a:	fa590913          	addi	s2,s2,-91
    8000186e:	0932                	slli	s2,s2,0xc
    80001870:	fa590913          	addi	s2,s2,-91
    80001874:	040009b7          	lui	s3,0x4000
    80001878:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000187a:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000187c:	00017a17          	auipc	s4,0x17
    80001880:	924a0a13          	addi	s4,s4,-1756 # 800181a0 <tickslock>
      initlock(&p->lock, "proc");
    80001884:	85da                	mv	a1,s6
    80001886:	8526                	mv	a0,s1
    80001888:	afaff0ef          	jal	80000b82 <initlock>
      p->state = UNUSED;
    8000188c:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001890:	415487b3          	sub	a5,s1,s5
    80001894:	878d                	srai	a5,a5,0x3
    80001896:	032787b3          	mul	a5,a5,s2
    8000189a:	2785                	addiw	a5,a5,1
    8000189c:	00d7979b          	slliw	a5,a5,0xd
    800018a0:	40f987b3          	sub	a5,s3,a5
    800018a4:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018a6:	16848493          	addi	s1,s1,360
    800018aa:	fd449de3          	bne	s1,s4,80001884 <procinit+0x78>
  }
}
    800018ae:	70e2                	ld	ra,56(sp)
    800018b0:	7442                	ld	s0,48(sp)
    800018b2:	74a2                	ld	s1,40(sp)
    800018b4:	7902                	ld	s2,32(sp)
    800018b6:	69e2                	ld	s3,24(sp)
    800018b8:	6a42                	ld	s4,16(sp)
    800018ba:	6aa2                	ld	s5,8(sp)
    800018bc:	6b02                	ld	s6,0(sp)
    800018be:	6121                	addi	sp,sp,64
    800018c0:	8082                	ret

00000000800018c2 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018c2:	1141                	addi	sp,sp,-16
    800018c4:	e422                	sd	s0,8(sp)
    800018c6:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018c8:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018ca:	2501                	sext.w	a0,a0
    800018cc:	6422                	ld	s0,8(sp)
    800018ce:	0141                	addi	sp,sp,16
    800018d0:	8082                	ret

00000000800018d2 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018d2:	1141                	addi	sp,sp,-16
    800018d4:	e422                	sd	s0,8(sp)
    800018d6:	0800                	addi	s0,sp,16
    800018d8:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018da:	2781                	sext.w	a5,a5
    800018dc:	079e                	slli	a5,a5,0x7
  return c;
}
    800018de:	00011517          	auipc	a0,0x11
    800018e2:	ac250513          	addi	a0,a0,-1342 # 800123a0 <cpus>
    800018e6:	953e                	add	a0,a0,a5
    800018e8:	6422                	ld	s0,8(sp)
    800018ea:	0141                	addi	sp,sp,16
    800018ec:	8082                	ret

00000000800018ee <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800018ee:	1101                	addi	sp,sp,-32
    800018f0:	ec06                	sd	ra,24(sp)
    800018f2:	e822                	sd	s0,16(sp)
    800018f4:	e426                	sd	s1,8(sp)
    800018f6:	1000                	addi	s0,sp,32
  push_off();
    800018f8:	acaff0ef          	jal	80000bc2 <push_off>
    800018fc:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800018fe:	2781                	sext.w	a5,a5
    80001900:	079e                	slli	a5,a5,0x7
    80001902:	00011717          	auipc	a4,0x11
    80001906:	a6e70713          	addi	a4,a4,-1426 # 80012370 <pid_lock>
    8000190a:	97ba                	add	a5,a5,a4
    8000190c:	7b84                	ld	s1,48(a5)
  pop_off();
    8000190e:	b38ff0ef          	jal	80000c46 <pop_off>
  return p;
}
    80001912:	8526                	mv	a0,s1
    80001914:	60e2                	ld	ra,24(sp)
    80001916:	6442                	ld	s0,16(sp)
    80001918:	64a2                	ld	s1,8(sp)
    8000191a:	6105                	addi	sp,sp,32
    8000191c:	8082                	ret

000000008000191e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000191e:	1141                	addi	sp,sp,-16
    80001920:	e406                	sd	ra,8(sp)
    80001922:	e022                	sd	s0,0(sp)
    80001924:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001926:	fc9ff0ef          	jal	800018ee <myproc>
    8000192a:	b70ff0ef          	jal	80000c9a <release>

  if (first) {
    8000192e:	00009797          	auipc	a5,0x9
    80001932:	8727a783          	lw	a5,-1934(a5) # 8000a1a0 <first.1>
    80001936:	e799                	bnez	a5,80001944 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001938:	2bf000ef          	jal	800023f6 <usertrapret>
}
    8000193c:	60a2                	ld	ra,8(sp)
    8000193e:	6402                	ld	s0,0(sp)
    80001940:	0141                	addi	sp,sp,16
    80001942:	8082                	ret
    fsinit(ROOTDEV);
    80001944:	4505                	li	a0,1
    80001946:	654010ef          	jal	80002f9a <fsinit>
    first = 0;
    8000194a:	00009797          	auipc	a5,0x9
    8000194e:	8407ab23          	sw	zero,-1962(a5) # 8000a1a0 <first.1>
    __sync_synchronize();
    80001952:	0330000f          	fence	rw,rw
    80001956:	b7cd                	j	80001938 <forkret+0x1a>

0000000080001958 <allocpid>:
{
    80001958:	1101                	addi	sp,sp,-32
    8000195a:	ec06                	sd	ra,24(sp)
    8000195c:	e822                	sd	s0,16(sp)
    8000195e:	e426                	sd	s1,8(sp)
    80001960:	e04a                	sd	s2,0(sp)
    80001962:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001964:	00011917          	auipc	s2,0x11
    80001968:	a0c90913          	addi	s2,s2,-1524 # 80012370 <pid_lock>
    8000196c:	854a                	mv	a0,s2
    8000196e:	a94ff0ef          	jal	80000c02 <acquire>
  pid = nextpid;
    80001972:	00009797          	auipc	a5,0x9
    80001976:	83278793          	addi	a5,a5,-1998 # 8000a1a4 <nextpid>
    8000197a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000197c:	0014871b          	addiw	a4,s1,1
    80001980:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001982:	854a                	mv	a0,s2
    80001984:	b16ff0ef          	jal	80000c9a <release>
}
    80001988:	8526                	mv	a0,s1
    8000198a:	60e2                	ld	ra,24(sp)
    8000198c:	6442                	ld	s0,16(sp)
    8000198e:	64a2                	ld	s1,8(sp)
    80001990:	6902                	ld	s2,0(sp)
    80001992:	6105                	addi	sp,sp,32
    80001994:	8082                	ret

0000000080001996 <proc_pagetable>:
{
    80001996:	1101                	addi	sp,sp,-32
    80001998:	ec06                	sd	ra,24(sp)
    8000199a:	e822                	sd	s0,16(sp)
    8000199c:	e426                	sd	s1,8(sp)
    8000199e:	e04a                	sd	s2,0(sp)
    800019a0:	1000                	addi	s0,sp,32
    800019a2:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800019a4:	8e1ff0ef          	jal	80001284 <uvmcreate>
    800019a8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800019aa:	cd05                	beqz	a0,800019e2 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800019ac:	4729                	li	a4,10
    800019ae:	00004697          	auipc	a3,0x4
    800019b2:	65268693          	addi	a3,a3,1618 # 80006000 <_trampoline>
    800019b6:	6605                	lui	a2,0x1
    800019b8:	040005b7          	lui	a1,0x4000
    800019bc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019be:	05b2                	slli	a1,a1,0xc
    800019c0:	e62ff0ef          	jal	80001022 <mappages>
    800019c4:	02054663          	bltz	a0,800019f0 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800019c8:	4719                	li	a4,6
    800019ca:	05893683          	ld	a3,88(s2)
    800019ce:	6605                	lui	a2,0x1
    800019d0:	020005b7          	lui	a1,0x2000
    800019d4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800019d6:	05b6                	slli	a1,a1,0xd
    800019d8:	8526                	mv	a0,s1
    800019da:	e48ff0ef          	jal	80001022 <mappages>
    800019de:	00054f63          	bltz	a0,800019fc <proc_pagetable+0x66>
}
    800019e2:	8526                	mv	a0,s1
    800019e4:	60e2                	ld	ra,24(sp)
    800019e6:	6442                	ld	s0,16(sp)
    800019e8:	64a2                	ld	s1,8(sp)
    800019ea:	6902                	ld	s2,0(sp)
    800019ec:	6105                	addi	sp,sp,32
    800019ee:	8082                	ret
    uvmfree(pagetable, 0);
    800019f0:	4581                	li	a1,0
    800019f2:	8526                	mv	a0,s1
    800019f4:	a5fff0ef          	jal	80001452 <uvmfree>
    return 0;
    800019f8:	4481                	li	s1,0
    800019fa:	b7e5                	j	800019e2 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800019fc:	4681                	li	a3,0
    800019fe:	4605                	li	a2,1
    80001a00:	040005b7          	lui	a1,0x4000
    80001a04:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a06:	05b2                	slli	a1,a1,0xc
    80001a08:	8526                	mv	a0,s1
    80001a0a:	fbeff0ef          	jal	800011c8 <uvmunmap>
    uvmfree(pagetable, 0);
    80001a0e:	4581                	li	a1,0
    80001a10:	8526                	mv	a0,s1
    80001a12:	a41ff0ef          	jal	80001452 <uvmfree>
    return 0;
    80001a16:	4481                	li	s1,0
    80001a18:	b7e9                	j	800019e2 <proc_pagetable+0x4c>

0000000080001a1a <proc_freepagetable>:
{
    80001a1a:	1101                	addi	sp,sp,-32
    80001a1c:	ec06                	sd	ra,24(sp)
    80001a1e:	e822                	sd	s0,16(sp)
    80001a20:	e426                	sd	s1,8(sp)
    80001a22:	e04a                	sd	s2,0(sp)
    80001a24:	1000                	addi	s0,sp,32
    80001a26:	84aa                	mv	s1,a0
    80001a28:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a2a:	4681                	li	a3,0
    80001a2c:	4605                	li	a2,1
    80001a2e:	040005b7          	lui	a1,0x4000
    80001a32:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a34:	05b2                	slli	a1,a1,0xc
    80001a36:	f92ff0ef          	jal	800011c8 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a3a:	4681                	li	a3,0
    80001a3c:	4605                	li	a2,1
    80001a3e:	020005b7          	lui	a1,0x2000
    80001a42:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a44:	05b6                	slli	a1,a1,0xd
    80001a46:	8526                	mv	a0,s1
    80001a48:	f80ff0ef          	jal	800011c8 <uvmunmap>
  uvmfree(pagetable, sz);
    80001a4c:	85ca                	mv	a1,s2
    80001a4e:	8526                	mv	a0,s1
    80001a50:	a03ff0ef          	jal	80001452 <uvmfree>
}
    80001a54:	60e2                	ld	ra,24(sp)
    80001a56:	6442                	ld	s0,16(sp)
    80001a58:	64a2                	ld	s1,8(sp)
    80001a5a:	6902                	ld	s2,0(sp)
    80001a5c:	6105                	addi	sp,sp,32
    80001a5e:	8082                	ret

0000000080001a60 <freeproc>:
{
    80001a60:	1101                	addi	sp,sp,-32
    80001a62:	ec06                	sd	ra,24(sp)
    80001a64:	e822                	sd	s0,16(sp)
    80001a66:	e426                	sd	s1,8(sp)
    80001a68:	1000                	addi	s0,sp,32
    80001a6a:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001a6c:	6d28                	ld	a0,88(a0)
    80001a6e:	c119                	beqz	a0,80001a74 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001a70:	fe1fe0ef          	jal	80000a50 <kfree>
  p->trapframe = 0;
    80001a74:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001a78:	68a8                	ld	a0,80(s1)
    80001a7a:	c501                	beqz	a0,80001a82 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001a7c:	64ac                	ld	a1,72(s1)
    80001a7e:	f9dff0ef          	jal	80001a1a <proc_freepagetable>
  p->pagetable = 0;
    80001a82:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001a86:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001a8a:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001a8e:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001a92:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001a96:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001a9a:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001a9e:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001aa2:	0004ac23          	sw	zero,24(s1)
}
    80001aa6:	60e2                	ld	ra,24(sp)
    80001aa8:	6442                	ld	s0,16(sp)
    80001aaa:	64a2                	ld	s1,8(sp)
    80001aac:	6105                	addi	sp,sp,32
    80001aae:	8082                	ret

0000000080001ab0 <allocproc>:
{
    80001ab0:	1101                	addi	sp,sp,-32
    80001ab2:	ec06                	sd	ra,24(sp)
    80001ab4:	e822                	sd	s0,16(sp)
    80001ab6:	e426                	sd	s1,8(sp)
    80001ab8:	e04a                	sd	s2,0(sp)
    80001aba:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001abc:	00011497          	auipc	s1,0x11
    80001ac0:	ce448493          	addi	s1,s1,-796 # 800127a0 <proc>
    80001ac4:	00016917          	auipc	s2,0x16
    80001ac8:	6dc90913          	addi	s2,s2,1756 # 800181a0 <tickslock>
    acquire(&p->lock);
    80001acc:	8526                	mv	a0,s1
    80001ace:	934ff0ef          	jal	80000c02 <acquire>
    if(p->state == UNUSED) {
    80001ad2:	4c9c                	lw	a5,24(s1)
    80001ad4:	cb91                	beqz	a5,80001ae8 <allocproc+0x38>
      release(&p->lock);
    80001ad6:	8526                	mv	a0,s1
    80001ad8:	9c2ff0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001adc:	16848493          	addi	s1,s1,360
    80001ae0:	ff2496e3          	bne	s1,s2,80001acc <allocproc+0x1c>
  return 0;
    80001ae4:	4481                	li	s1,0
    80001ae6:	a089                	j	80001b28 <allocproc+0x78>
  p->pid = allocpid();
    80001ae8:	e71ff0ef          	jal	80001958 <allocpid>
    80001aec:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001aee:	4785                	li	a5,1
    80001af0:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001af2:	840ff0ef          	jal	80000b32 <kalloc>
    80001af6:	892a                	mv	s2,a0
    80001af8:	eca8                	sd	a0,88(s1)
    80001afa:	cd15                	beqz	a0,80001b36 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001afc:	8526                	mv	a0,s1
    80001afe:	e99ff0ef          	jal	80001996 <proc_pagetable>
    80001b02:	892a                	mv	s2,a0
    80001b04:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001b06:	c121                	beqz	a0,80001b46 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001b08:	07000613          	li	a2,112
    80001b0c:	4581                	li	a1,0
    80001b0e:	06048513          	addi	a0,s1,96
    80001b12:	9c4ff0ef          	jal	80000cd6 <memset>
  p->context.ra = (uint64)forkret;
    80001b16:	00000797          	auipc	a5,0x0
    80001b1a:	e0878793          	addi	a5,a5,-504 # 8000191e <forkret>
    80001b1e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b20:	60bc                	ld	a5,64(s1)
    80001b22:	6705                	lui	a4,0x1
    80001b24:	97ba                	add	a5,a5,a4
    80001b26:	f4bc                	sd	a5,104(s1)
}
    80001b28:	8526                	mv	a0,s1
    80001b2a:	60e2                	ld	ra,24(sp)
    80001b2c:	6442                	ld	s0,16(sp)
    80001b2e:	64a2                	ld	s1,8(sp)
    80001b30:	6902                	ld	s2,0(sp)
    80001b32:	6105                	addi	sp,sp,32
    80001b34:	8082                	ret
    freeproc(p);
    80001b36:	8526                	mv	a0,s1
    80001b38:	f29ff0ef          	jal	80001a60 <freeproc>
    release(&p->lock);
    80001b3c:	8526                	mv	a0,s1
    80001b3e:	95cff0ef          	jal	80000c9a <release>
    return 0;
    80001b42:	84ca                	mv	s1,s2
    80001b44:	b7d5                	j	80001b28 <allocproc+0x78>
    freeproc(p);
    80001b46:	8526                	mv	a0,s1
    80001b48:	f19ff0ef          	jal	80001a60 <freeproc>
    release(&p->lock);
    80001b4c:	8526                	mv	a0,s1
    80001b4e:	94cff0ef          	jal	80000c9a <release>
    return 0;
    80001b52:	84ca                	mv	s1,s2
    80001b54:	bfd1                	j	80001b28 <allocproc+0x78>

0000000080001b56 <userinit>:
{
    80001b56:	1101                	addi	sp,sp,-32
    80001b58:	ec06                	sd	ra,24(sp)
    80001b5a:	e822                	sd	s0,16(sp)
    80001b5c:	e426                	sd	s1,8(sp)
    80001b5e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001b60:	f51ff0ef          	jal	80001ab0 <allocproc>
    80001b64:	84aa                	mv	s1,a0
  initproc = p;
    80001b66:	00008797          	auipc	a5,0x8
    80001b6a:	6ca7b923          	sd	a0,1746(a5) # 8000a238 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001b6e:	03400613          	li	a2,52
    80001b72:	00008597          	auipc	a1,0x8
    80001b76:	63e58593          	addi	a1,a1,1598 # 8000a1b0 <initcode>
    80001b7a:	6928                	ld	a0,80(a0)
    80001b7c:	f2eff0ef          	jal	800012aa <uvmfirst>
  p->sz = PGSIZE;
    80001b80:	6785                	lui	a5,0x1
    80001b82:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001b84:	6cb8                	ld	a4,88(s1)
    80001b86:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001b8a:	6cb8                	ld	a4,88(s1)
    80001b8c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001b8e:	4641                	li	a2,16
    80001b90:	00005597          	auipc	a1,0x5
    80001b94:	69058593          	addi	a1,a1,1680 # 80007220 <etext+0x220>
    80001b98:	15848513          	addi	a0,s1,344
    80001b9c:	a78ff0ef          	jal	80000e14 <safestrcpy>
  p->cwd = namei("/");
    80001ba0:	00005517          	auipc	a0,0x5
    80001ba4:	69050513          	addi	a0,a0,1680 # 80007230 <etext+0x230>
    80001ba8:	501010ef          	jal	800038a8 <namei>
    80001bac:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001bb0:	478d                	li	a5,3
    80001bb2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001bb4:	8526                	mv	a0,s1
    80001bb6:	8e4ff0ef          	jal	80000c9a <release>
}
    80001bba:	60e2                	ld	ra,24(sp)
    80001bbc:	6442                	ld	s0,16(sp)
    80001bbe:	64a2                	ld	s1,8(sp)
    80001bc0:	6105                	addi	sp,sp,32
    80001bc2:	8082                	ret

0000000080001bc4 <growproc>:
{
    80001bc4:	1101                	addi	sp,sp,-32
    80001bc6:	ec06                	sd	ra,24(sp)
    80001bc8:	e822                	sd	s0,16(sp)
    80001bca:	e426                	sd	s1,8(sp)
    80001bcc:	e04a                	sd	s2,0(sp)
    80001bce:	1000                	addi	s0,sp,32
    80001bd0:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001bd2:	d1dff0ef          	jal	800018ee <myproc>
    80001bd6:	84aa                	mv	s1,a0
  sz = p->sz;
    80001bd8:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001bda:	01204c63          	bgtz	s2,80001bf2 <growproc+0x2e>
  } else if(n < 0){
    80001bde:	02094463          	bltz	s2,80001c06 <growproc+0x42>
  p->sz = sz;
    80001be2:	e4ac                	sd	a1,72(s1)
  return 0;
    80001be4:	4501                	li	a0,0
}
    80001be6:	60e2                	ld	ra,24(sp)
    80001be8:	6442                	ld	s0,16(sp)
    80001bea:	64a2                	ld	s1,8(sp)
    80001bec:	6902                	ld	s2,0(sp)
    80001bee:	6105                	addi	sp,sp,32
    80001bf0:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001bf2:	4691                	li	a3,4
    80001bf4:	00b90633          	add	a2,s2,a1
    80001bf8:	6928                	ld	a0,80(a0)
    80001bfa:	f52ff0ef          	jal	8000134c <uvmalloc>
    80001bfe:	85aa                	mv	a1,a0
    80001c00:	f16d                	bnez	a0,80001be2 <growproc+0x1e>
      return -1;
    80001c02:	557d                	li	a0,-1
    80001c04:	b7cd                	j	80001be6 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c06:	00b90633          	add	a2,s2,a1
    80001c0a:	6928                	ld	a0,80(a0)
    80001c0c:	efcff0ef          	jal	80001308 <uvmdealloc>
    80001c10:	85aa                	mv	a1,a0
    80001c12:	bfc1                	j	80001be2 <growproc+0x1e>

0000000080001c14 <fork>:
{
    80001c14:	7139                	addi	sp,sp,-64
    80001c16:	fc06                	sd	ra,56(sp)
    80001c18:	f822                	sd	s0,48(sp)
    80001c1a:	f04a                	sd	s2,32(sp)
    80001c1c:	e456                	sd	s5,8(sp)
    80001c1e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c20:	ccfff0ef          	jal	800018ee <myproc>
    80001c24:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001c26:	e8bff0ef          	jal	80001ab0 <allocproc>
    80001c2a:	0e050a63          	beqz	a0,80001d1e <fork+0x10a>
    80001c2e:	e852                	sd	s4,16(sp)
    80001c30:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001c32:	048ab603          	ld	a2,72(s5)
    80001c36:	692c                	ld	a1,80(a0)
    80001c38:	050ab503          	ld	a0,80(s5)
    80001c3c:	849ff0ef          	jal	80001484 <uvmcopy>
    80001c40:	04054a63          	bltz	a0,80001c94 <fork+0x80>
    80001c44:	f426                	sd	s1,40(sp)
    80001c46:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001c48:	048ab783          	ld	a5,72(s5)
    80001c4c:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001c50:	058ab683          	ld	a3,88(s5)
    80001c54:	87b6                	mv	a5,a3
    80001c56:	058a3703          	ld	a4,88(s4)
    80001c5a:	12068693          	addi	a3,a3,288
    80001c5e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001c62:	6788                	ld	a0,8(a5)
    80001c64:	6b8c                	ld	a1,16(a5)
    80001c66:	6f90                	ld	a2,24(a5)
    80001c68:	01073023          	sd	a6,0(a4)
    80001c6c:	e708                	sd	a0,8(a4)
    80001c6e:	eb0c                	sd	a1,16(a4)
    80001c70:	ef10                	sd	a2,24(a4)
    80001c72:	02078793          	addi	a5,a5,32
    80001c76:	02070713          	addi	a4,a4,32
    80001c7a:	fed792e3          	bne	a5,a3,80001c5e <fork+0x4a>
  np->trapframe->a0 = 0;
    80001c7e:	058a3783          	ld	a5,88(s4)
    80001c82:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001c86:	0d0a8493          	addi	s1,s5,208
    80001c8a:	0d0a0913          	addi	s2,s4,208
    80001c8e:	150a8993          	addi	s3,s5,336
    80001c92:	a831                	j	80001cae <fork+0x9a>
    freeproc(np);
    80001c94:	8552                	mv	a0,s4
    80001c96:	dcbff0ef          	jal	80001a60 <freeproc>
    release(&np->lock);
    80001c9a:	8552                	mv	a0,s4
    80001c9c:	ffffe0ef          	jal	80000c9a <release>
    return -1;
    80001ca0:	597d                	li	s2,-1
    80001ca2:	6a42                	ld	s4,16(sp)
    80001ca4:	a0b5                	j	80001d10 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001ca6:	04a1                	addi	s1,s1,8
    80001ca8:	0921                	addi	s2,s2,8
    80001caa:	01348963          	beq	s1,s3,80001cbc <fork+0xa8>
    if(p->ofile[i])
    80001cae:	6088                	ld	a0,0(s1)
    80001cb0:	d97d                	beqz	a0,80001ca6 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001cb2:	186020ef          	jal	80003e38 <filedup>
    80001cb6:	00a93023          	sd	a0,0(s2)
    80001cba:	b7f5                	j	80001ca6 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001cbc:	150ab503          	ld	a0,336(s5)
    80001cc0:	4d8010ef          	jal	80003198 <idup>
    80001cc4:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001cc8:	4641                	li	a2,16
    80001cca:	158a8593          	addi	a1,s5,344
    80001cce:	158a0513          	addi	a0,s4,344
    80001cd2:	942ff0ef          	jal	80000e14 <safestrcpy>
  pid = np->pid;
    80001cd6:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001cda:	8552                	mv	a0,s4
    80001cdc:	fbffe0ef          	jal	80000c9a <release>
  acquire(&wait_lock);
    80001ce0:	00010497          	auipc	s1,0x10
    80001ce4:	6a848493          	addi	s1,s1,1704 # 80012388 <wait_lock>
    80001ce8:	8526                	mv	a0,s1
    80001cea:	f19fe0ef          	jal	80000c02 <acquire>
  np->parent = p;
    80001cee:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001cf2:	8526                	mv	a0,s1
    80001cf4:	fa7fe0ef          	jal	80000c9a <release>
  acquire(&np->lock);
    80001cf8:	8552                	mv	a0,s4
    80001cfa:	f09fe0ef          	jal	80000c02 <acquire>
  np->state = RUNNABLE;
    80001cfe:	478d                	li	a5,3
    80001d00:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001d04:	8552                	mv	a0,s4
    80001d06:	f95fe0ef          	jal	80000c9a <release>
  return pid;
    80001d0a:	74a2                	ld	s1,40(sp)
    80001d0c:	69e2                	ld	s3,24(sp)
    80001d0e:	6a42                	ld	s4,16(sp)
}
    80001d10:	854a                	mv	a0,s2
    80001d12:	70e2                	ld	ra,56(sp)
    80001d14:	7442                	ld	s0,48(sp)
    80001d16:	7902                	ld	s2,32(sp)
    80001d18:	6aa2                	ld	s5,8(sp)
    80001d1a:	6121                	addi	sp,sp,64
    80001d1c:	8082                	ret
    return -1;
    80001d1e:	597d                	li	s2,-1
    80001d20:	bfc5                	j	80001d10 <fork+0xfc>

0000000080001d22 <scheduler>:
{
    80001d22:	715d                	addi	sp,sp,-80
    80001d24:	e486                	sd	ra,72(sp)
    80001d26:	e0a2                	sd	s0,64(sp)
    80001d28:	fc26                	sd	s1,56(sp)
    80001d2a:	f84a                	sd	s2,48(sp)
    80001d2c:	f44e                	sd	s3,40(sp)
    80001d2e:	f052                	sd	s4,32(sp)
    80001d30:	ec56                	sd	s5,24(sp)
    80001d32:	e85a                	sd	s6,16(sp)
    80001d34:	e45e                	sd	s7,8(sp)
    80001d36:	e062                	sd	s8,0(sp)
    80001d38:	0880                	addi	s0,sp,80
    80001d3a:	8792                	mv	a5,tp
  int id = r_tp();
    80001d3c:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d3e:	00779b13          	slli	s6,a5,0x7
    80001d42:	00010717          	auipc	a4,0x10
    80001d46:	62e70713          	addi	a4,a4,1582 # 80012370 <pid_lock>
    80001d4a:	975a                	add	a4,a4,s6
    80001d4c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001d50:	00010717          	auipc	a4,0x10
    80001d54:	65870713          	addi	a4,a4,1624 # 800123a8 <cpus+0x8>
    80001d58:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001d5a:	4c11                	li	s8,4
        c->proc = p;
    80001d5c:	079e                	slli	a5,a5,0x7
    80001d5e:	00010a17          	auipc	s4,0x10
    80001d62:	612a0a13          	addi	s4,s4,1554 # 80012370 <pid_lock>
    80001d66:	9a3e                	add	s4,s4,a5
        found = 1;
    80001d68:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d6a:	00016997          	auipc	s3,0x16
    80001d6e:	43698993          	addi	s3,s3,1078 # 800181a0 <tickslock>
    80001d72:	a0a9                	j	80001dbc <scheduler+0x9a>
      release(&p->lock);
    80001d74:	8526                	mv	a0,s1
    80001d76:	f25fe0ef          	jal	80000c9a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d7a:	16848493          	addi	s1,s1,360
    80001d7e:	03348563          	beq	s1,s3,80001da8 <scheduler+0x86>
      acquire(&p->lock);
    80001d82:	8526                	mv	a0,s1
    80001d84:	e7ffe0ef          	jal	80000c02 <acquire>
      if(p->state == RUNNABLE) {
    80001d88:	4c9c                	lw	a5,24(s1)
    80001d8a:	ff2795e3          	bne	a5,s2,80001d74 <scheduler+0x52>
        p->state = RUNNING;
    80001d8e:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001d92:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001d96:	06048593          	addi	a1,s1,96
    80001d9a:	855a                	mv	a0,s6
    80001d9c:	5b4000ef          	jal	80002350 <swtch>
        c->proc = 0;
    80001da0:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001da4:	8ade                	mv	s5,s7
    80001da6:	b7f9                	j	80001d74 <scheduler+0x52>
    if(found == 0) {
    80001da8:	000a9a63          	bnez	s5,80001dbc <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001db0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001db4:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001db8:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dbc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001dc0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dc4:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001dc8:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001dca:	00011497          	auipc	s1,0x11
    80001dce:	9d648493          	addi	s1,s1,-1578 # 800127a0 <proc>
      if(p->state == RUNNABLE) {
    80001dd2:	490d                	li	s2,3
    80001dd4:	b77d                	j	80001d82 <scheduler+0x60>

0000000080001dd6 <sched>:
{
    80001dd6:	7179                	addi	sp,sp,-48
    80001dd8:	f406                	sd	ra,40(sp)
    80001dda:	f022                	sd	s0,32(sp)
    80001ddc:	ec26                	sd	s1,24(sp)
    80001dde:	e84a                	sd	s2,16(sp)
    80001de0:	e44e                	sd	s3,8(sp)
    80001de2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001de4:	b0bff0ef          	jal	800018ee <myproc>
    80001de8:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001dea:	daffe0ef          	jal	80000b98 <holding>
    80001dee:	c92d                	beqz	a0,80001e60 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001df0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001df2:	2781                	sext.w	a5,a5
    80001df4:	079e                	slli	a5,a5,0x7
    80001df6:	00010717          	auipc	a4,0x10
    80001dfa:	57a70713          	addi	a4,a4,1402 # 80012370 <pid_lock>
    80001dfe:	97ba                	add	a5,a5,a4
    80001e00:	0a87a703          	lw	a4,168(a5)
    80001e04:	4785                	li	a5,1
    80001e06:	06f71363          	bne	a4,a5,80001e6c <sched+0x96>
  if(p->state == RUNNING)
    80001e0a:	4c98                	lw	a4,24(s1)
    80001e0c:	4791                	li	a5,4
    80001e0e:	06f70563          	beq	a4,a5,80001e78 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e12:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e16:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e18:	e7b5                	bnez	a5,80001e84 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e1a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e1c:	00010917          	auipc	s2,0x10
    80001e20:	55490913          	addi	s2,s2,1364 # 80012370 <pid_lock>
    80001e24:	2781                	sext.w	a5,a5
    80001e26:	079e                	slli	a5,a5,0x7
    80001e28:	97ca                	add	a5,a5,s2
    80001e2a:	0ac7a983          	lw	s3,172(a5)
    80001e2e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e30:	2781                	sext.w	a5,a5
    80001e32:	079e                	slli	a5,a5,0x7
    80001e34:	00010597          	auipc	a1,0x10
    80001e38:	57458593          	addi	a1,a1,1396 # 800123a8 <cpus+0x8>
    80001e3c:	95be                	add	a1,a1,a5
    80001e3e:	06048513          	addi	a0,s1,96
    80001e42:	50e000ef          	jal	80002350 <swtch>
    80001e46:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001e48:	2781                	sext.w	a5,a5
    80001e4a:	079e                	slli	a5,a5,0x7
    80001e4c:	993e                	add	s2,s2,a5
    80001e4e:	0b392623          	sw	s3,172(s2)
}
    80001e52:	70a2                	ld	ra,40(sp)
    80001e54:	7402                	ld	s0,32(sp)
    80001e56:	64e2                	ld	s1,24(sp)
    80001e58:	6942                	ld	s2,16(sp)
    80001e5a:	69a2                	ld	s3,8(sp)
    80001e5c:	6145                	addi	sp,sp,48
    80001e5e:	8082                	ret
    panic("sched p->lock");
    80001e60:	00005517          	auipc	a0,0x5
    80001e64:	3d850513          	addi	a0,a0,984 # 80007238 <etext+0x238>
    80001e68:	93bfe0ef          	jal	800007a2 <panic>
    panic("sched locks");
    80001e6c:	00005517          	auipc	a0,0x5
    80001e70:	3dc50513          	addi	a0,a0,988 # 80007248 <etext+0x248>
    80001e74:	92ffe0ef          	jal	800007a2 <panic>
    panic("sched running");
    80001e78:	00005517          	auipc	a0,0x5
    80001e7c:	3e050513          	addi	a0,a0,992 # 80007258 <etext+0x258>
    80001e80:	923fe0ef          	jal	800007a2 <panic>
    panic("sched interruptible");
    80001e84:	00005517          	auipc	a0,0x5
    80001e88:	3e450513          	addi	a0,a0,996 # 80007268 <etext+0x268>
    80001e8c:	917fe0ef          	jal	800007a2 <panic>

0000000080001e90 <yield>:
{
    80001e90:	1101                	addi	sp,sp,-32
    80001e92:	ec06                	sd	ra,24(sp)
    80001e94:	e822                	sd	s0,16(sp)
    80001e96:	e426                	sd	s1,8(sp)
    80001e98:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001e9a:	a55ff0ef          	jal	800018ee <myproc>
    80001e9e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001ea0:	d63fe0ef          	jal	80000c02 <acquire>
  p->state = RUNNABLE;
    80001ea4:	478d                	li	a5,3
    80001ea6:	cc9c                	sw	a5,24(s1)
  sched();
    80001ea8:	f2fff0ef          	jal	80001dd6 <sched>
  release(&p->lock);
    80001eac:	8526                	mv	a0,s1
    80001eae:	dedfe0ef          	jal	80000c9a <release>
}
    80001eb2:	60e2                	ld	ra,24(sp)
    80001eb4:	6442                	ld	s0,16(sp)
    80001eb6:	64a2                	ld	s1,8(sp)
    80001eb8:	6105                	addi	sp,sp,32
    80001eba:	8082                	ret

0000000080001ebc <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001ebc:	7179                	addi	sp,sp,-48
    80001ebe:	f406                	sd	ra,40(sp)
    80001ec0:	f022                	sd	s0,32(sp)
    80001ec2:	ec26                	sd	s1,24(sp)
    80001ec4:	e84a                	sd	s2,16(sp)
    80001ec6:	e44e                	sd	s3,8(sp)
    80001ec8:	1800                	addi	s0,sp,48
    80001eca:	89aa                	mv	s3,a0
    80001ecc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ece:	a21ff0ef          	jal	800018ee <myproc>
    80001ed2:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001ed4:	d2ffe0ef          	jal	80000c02 <acquire>
  release(lk);
    80001ed8:	854a                	mv	a0,s2
    80001eda:	dc1fe0ef          	jal	80000c9a <release>

  // Go to sleep.
  p->chan = chan;
    80001ede:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001ee2:	4789                	li	a5,2
    80001ee4:	cc9c                	sw	a5,24(s1)

  sched();
    80001ee6:	ef1ff0ef          	jal	80001dd6 <sched>

  // Tidy up.
  p->chan = 0;
    80001eea:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001eee:	8526                	mv	a0,s1
    80001ef0:	dabfe0ef          	jal	80000c9a <release>
  acquire(lk);
    80001ef4:	854a                	mv	a0,s2
    80001ef6:	d0dfe0ef          	jal	80000c02 <acquire>
}
    80001efa:	70a2                	ld	ra,40(sp)
    80001efc:	7402                	ld	s0,32(sp)
    80001efe:	64e2                	ld	s1,24(sp)
    80001f00:	6942                	ld	s2,16(sp)
    80001f02:	69a2                	ld	s3,8(sp)
    80001f04:	6145                	addi	sp,sp,48
    80001f06:	8082                	ret

0000000080001f08 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001f08:	7139                	addi	sp,sp,-64
    80001f0a:	fc06                	sd	ra,56(sp)
    80001f0c:	f822                	sd	s0,48(sp)
    80001f0e:	f426                	sd	s1,40(sp)
    80001f10:	f04a                	sd	s2,32(sp)
    80001f12:	ec4e                	sd	s3,24(sp)
    80001f14:	e852                	sd	s4,16(sp)
    80001f16:	e456                	sd	s5,8(sp)
    80001f18:	0080                	addi	s0,sp,64
    80001f1a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001f1c:	00011497          	auipc	s1,0x11
    80001f20:	88448493          	addi	s1,s1,-1916 # 800127a0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001f24:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001f26:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f28:	00016917          	auipc	s2,0x16
    80001f2c:	27890913          	addi	s2,s2,632 # 800181a0 <tickslock>
    80001f30:	a801                	j	80001f40 <wakeup+0x38>
      }
      release(&p->lock);
    80001f32:	8526                	mv	a0,s1
    80001f34:	d67fe0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f38:	16848493          	addi	s1,s1,360
    80001f3c:	03248263          	beq	s1,s2,80001f60 <wakeup+0x58>
    if(p != myproc()){
    80001f40:	9afff0ef          	jal	800018ee <myproc>
    80001f44:	fea48ae3          	beq	s1,a0,80001f38 <wakeup+0x30>
      acquire(&p->lock);
    80001f48:	8526                	mv	a0,s1
    80001f4a:	cb9fe0ef          	jal	80000c02 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001f4e:	4c9c                	lw	a5,24(s1)
    80001f50:	ff3791e3          	bne	a5,s3,80001f32 <wakeup+0x2a>
    80001f54:	709c                	ld	a5,32(s1)
    80001f56:	fd479ee3          	bne	a5,s4,80001f32 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001f5a:	0154ac23          	sw	s5,24(s1)
    80001f5e:	bfd1                	j	80001f32 <wakeup+0x2a>
    }
  }
}
    80001f60:	70e2                	ld	ra,56(sp)
    80001f62:	7442                	ld	s0,48(sp)
    80001f64:	74a2                	ld	s1,40(sp)
    80001f66:	7902                	ld	s2,32(sp)
    80001f68:	69e2                	ld	s3,24(sp)
    80001f6a:	6a42                	ld	s4,16(sp)
    80001f6c:	6aa2                	ld	s5,8(sp)
    80001f6e:	6121                	addi	sp,sp,64
    80001f70:	8082                	ret

0000000080001f72 <reparent>:
{
    80001f72:	7179                	addi	sp,sp,-48
    80001f74:	f406                	sd	ra,40(sp)
    80001f76:	f022                	sd	s0,32(sp)
    80001f78:	ec26                	sd	s1,24(sp)
    80001f7a:	e84a                	sd	s2,16(sp)
    80001f7c:	e44e                	sd	s3,8(sp)
    80001f7e:	e052                	sd	s4,0(sp)
    80001f80:	1800                	addi	s0,sp,48
    80001f82:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f84:	00011497          	auipc	s1,0x11
    80001f88:	81c48493          	addi	s1,s1,-2020 # 800127a0 <proc>
      pp->parent = initproc;
    80001f8c:	00008a17          	auipc	s4,0x8
    80001f90:	2aca0a13          	addi	s4,s4,684 # 8000a238 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f94:	00016997          	auipc	s3,0x16
    80001f98:	20c98993          	addi	s3,s3,524 # 800181a0 <tickslock>
    80001f9c:	a029                	j	80001fa6 <reparent+0x34>
    80001f9e:	16848493          	addi	s1,s1,360
    80001fa2:	01348b63          	beq	s1,s3,80001fb8 <reparent+0x46>
    if(pp->parent == p){
    80001fa6:	7c9c                	ld	a5,56(s1)
    80001fa8:	ff279be3          	bne	a5,s2,80001f9e <reparent+0x2c>
      pp->parent = initproc;
    80001fac:	000a3503          	ld	a0,0(s4)
    80001fb0:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001fb2:	f57ff0ef          	jal	80001f08 <wakeup>
    80001fb6:	b7e5                	j	80001f9e <reparent+0x2c>
}
    80001fb8:	70a2                	ld	ra,40(sp)
    80001fba:	7402                	ld	s0,32(sp)
    80001fbc:	64e2                	ld	s1,24(sp)
    80001fbe:	6942                	ld	s2,16(sp)
    80001fc0:	69a2                	ld	s3,8(sp)
    80001fc2:	6a02                	ld	s4,0(sp)
    80001fc4:	6145                	addi	sp,sp,48
    80001fc6:	8082                	ret

0000000080001fc8 <exit>:
{
    80001fc8:	7179                	addi	sp,sp,-48
    80001fca:	f406                	sd	ra,40(sp)
    80001fcc:	f022                	sd	s0,32(sp)
    80001fce:	ec26                	sd	s1,24(sp)
    80001fd0:	e84a                	sd	s2,16(sp)
    80001fd2:	e44e                	sd	s3,8(sp)
    80001fd4:	e052                	sd	s4,0(sp)
    80001fd6:	1800                	addi	s0,sp,48
    80001fd8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001fda:	915ff0ef          	jal	800018ee <myproc>
    80001fde:	89aa                	mv	s3,a0
  if(p == initproc)
    80001fe0:	00008797          	auipc	a5,0x8
    80001fe4:	2587b783          	ld	a5,600(a5) # 8000a238 <initproc>
    80001fe8:	0d050493          	addi	s1,a0,208
    80001fec:	15050913          	addi	s2,a0,336
    80001ff0:	00a79f63          	bne	a5,a0,8000200e <exit+0x46>
    panic("init exiting");
    80001ff4:	00005517          	auipc	a0,0x5
    80001ff8:	28c50513          	addi	a0,a0,652 # 80007280 <etext+0x280>
    80001ffc:	fa6fe0ef          	jal	800007a2 <panic>
      fileclose(f);
    80002000:	67f010ef          	jal	80003e7e <fileclose>
      p->ofile[fd] = 0;
    80002004:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002008:	04a1                	addi	s1,s1,8
    8000200a:	01248563          	beq	s1,s2,80002014 <exit+0x4c>
    if(p->ofile[fd]){
    8000200e:	6088                	ld	a0,0(s1)
    80002010:	f965                	bnez	a0,80002000 <exit+0x38>
    80002012:	bfdd                	j	80002008 <exit+0x40>
  begin_op();
    80002014:	251010ef          	jal	80003a64 <begin_op>
  iput(p->cwd);
    80002018:	1509b503          	ld	a0,336(s3)
    8000201c:	334010ef          	jal	80003350 <iput>
  end_op();
    80002020:	2af010ef          	jal	80003ace <end_op>
  p->cwd = 0;
    80002024:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002028:	00010497          	auipc	s1,0x10
    8000202c:	36048493          	addi	s1,s1,864 # 80012388 <wait_lock>
    80002030:	8526                	mv	a0,s1
    80002032:	bd1fe0ef          	jal	80000c02 <acquire>
  reparent(p);
    80002036:	854e                	mv	a0,s3
    80002038:	f3bff0ef          	jal	80001f72 <reparent>
  wakeup(p->parent);
    8000203c:	0389b503          	ld	a0,56(s3)
    80002040:	ec9ff0ef          	jal	80001f08 <wakeup>
  acquire(&p->lock);
    80002044:	854e                	mv	a0,s3
    80002046:	bbdfe0ef          	jal	80000c02 <acquire>
  p->xstate = status;
    8000204a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000204e:	4795                	li	a5,5
    80002050:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002054:	8526                	mv	a0,s1
    80002056:	c45fe0ef          	jal	80000c9a <release>
  sched();
    8000205a:	d7dff0ef          	jal	80001dd6 <sched>
  panic("zombie exit");
    8000205e:	00005517          	auipc	a0,0x5
    80002062:	23250513          	addi	a0,a0,562 # 80007290 <etext+0x290>
    80002066:	f3cfe0ef          	jal	800007a2 <panic>

000000008000206a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000206a:	7179                	addi	sp,sp,-48
    8000206c:	f406                	sd	ra,40(sp)
    8000206e:	f022                	sd	s0,32(sp)
    80002070:	ec26                	sd	s1,24(sp)
    80002072:	e84a                	sd	s2,16(sp)
    80002074:	e44e                	sd	s3,8(sp)
    80002076:	1800                	addi	s0,sp,48
    80002078:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000207a:	00010497          	auipc	s1,0x10
    8000207e:	72648493          	addi	s1,s1,1830 # 800127a0 <proc>
    80002082:	00016997          	auipc	s3,0x16
    80002086:	11e98993          	addi	s3,s3,286 # 800181a0 <tickslock>
    acquire(&p->lock);
    8000208a:	8526                	mv	a0,s1
    8000208c:	b77fe0ef          	jal	80000c02 <acquire>
    if(p->pid == pid){
    80002090:	589c                	lw	a5,48(s1)
    80002092:	01278b63          	beq	a5,s2,800020a8 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002096:	8526                	mv	a0,s1
    80002098:	c03fe0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000209c:	16848493          	addi	s1,s1,360
    800020a0:	ff3495e3          	bne	s1,s3,8000208a <kill+0x20>
  }
  return -1;
    800020a4:	557d                	li	a0,-1
    800020a6:	a819                	j	800020bc <kill+0x52>
      p->killed = 1;
    800020a8:	4785                	li	a5,1
    800020aa:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800020ac:	4c98                	lw	a4,24(s1)
    800020ae:	4789                	li	a5,2
    800020b0:	00f70d63          	beq	a4,a5,800020ca <kill+0x60>
      release(&p->lock);
    800020b4:	8526                	mv	a0,s1
    800020b6:	be5fe0ef          	jal	80000c9a <release>
      return 0;
    800020ba:	4501                	li	a0,0
}
    800020bc:	70a2                	ld	ra,40(sp)
    800020be:	7402                	ld	s0,32(sp)
    800020c0:	64e2                	ld	s1,24(sp)
    800020c2:	6942                	ld	s2,16(sp)
    800020c4:	69a2                	ld	s3,8(sp)
    800020c6:	6145                	addi	sp,sp,48
    800020c8:	8082                	ret
        p->state = RUNNABLE;
    800020ca:	478d                	li	a5,3
    800020cc:	cc9c                	sw	a5,24(s1)
    800020ce:	b7dd                	j	800020b4 <kill+0x4a>

00000000800020d0 <setkilled>:

void
setkilled(struct proc *p)
{
    800020d0:	1101                	addi	sp,sp,-32
    800020d2:	ec06                	sd	ra,24(sp)
    800020d4:	e822                	sd	s0,16(sp)
    800020d6:	e426                	sd	s1,8(sp)
    800020d8:	1000                	addi	s0,sp,32
    800020da:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020dc:	b27fe0ef          	jal	80000c02 <acquire>
  p->killed = 1;
    800020e0:	4785                	li	a5,1
    800020e2:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800020e4:	8526                	mv	a0,s1
    800020e6:	bb5fe0ef          	jal	80000c9a <release>
}
    800020ea:	60e2                	ld	ra,24(sp)
    800020ec:	6442                	ld	s0,16(sp)
    800020ee:	64a2                	ld	s1,8(sp)
    800020f0:	6105                	addi	sp,sp,32
    800020f2:	8082                	ret

00000000800020f4 <killed>:

int
killed(struct proc *p)
{
    800020f4:	1101                	addi	sp,sp,-32
    800020f6:	ec06                	sd	ra,24(sp)
    800020f8:	e822                	sd	s0,16(sp)
    800020fa:	e426                	sd	s1,8(sp)
    800020fc:	e04a                	sd	s2,0(sp)
    800020fe:	1000                	addi	s0,sp,32
    80002100:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002102:	b01fe0ef          	jal	80000c02 <acquire>
  k = p->killed;
    80002106:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000210a:	8526                	mv	a0,s1
    8000210c:	b8ffe0ef          	jal	80000c9a <release>
  return k;
}
    80002110:	854a                	mv	a0,s2
    80002112:	60e2                	ld	ra,24(sp)
    80002114:	6442                	ld	s0,16(sp)
    80002116:	64a2                	ld	s1,8(sp)
    80002118:	6902                	ld	s2,0(sp)
    8000211a:	6105                	addi	sp,sp,32
    8000211c:	8082                	ret

000000008000211e <wait>:
{
    8000211e:	715d                	addi	sp,sp,-80
    80002120:	e486                	sd	ra,72(sp)
    80002122:	e0a2                	sd	s0,64(sp)
    80002124:	fc26                	sd	s1,56(sp)
    80002126:	f84a                	sd	s2,48(sp)
    80002128:	f44e                	sd	s3,40(sp)
    8000212a:	f052                	sd	s4,32(sp)
    8000212c:	ec56                	sd	s5,24(sp)
    8000212e:	e85a                	sd	s6,16(sp)
    80002130:	e45e                	sd	s7,8(sp)
    80002132:	e062                	sd	s8,0(sp)
    80002134:	0880                	addi	s0,sp,80
    80002136:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002138:	fb6ff0ef          	jal	800018ee <myproc>
    8000213c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000213e:	00010517          	auipc	a0,0x10
    80002142:	24a50513          	addi	a0,a0,586 # 80012388 <wait_lock>
    80002146:	abdfe0ef          	jal	80000c02 <acquire>
    havekids = 0;
    8000214a:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000214c:	4a15                	li	s4,5
        havekids = 1;
    8000214e:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002150:	00016997          	auipc	s3,0x16
    80002154:	05098993          	addi	s3,s3,80 # 800181a0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002158:	00010c17          	auipc	s8,0x10
    8000215c:	230c0c13          	addi	s8,s8,560 # 80012388 <wait_lock>
    80002160:	a871                	j	800021fc <wait+0xde>
          pid = pp->pid;
    80002162:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002166:	000b0c63          	beqz	s6,8000217e <wait+0x60>
    8000216a:	4691                	li	a3,4
    8000216c:	02c48613          	addi	a2,s1,44
    80002170:	85da                	mv	a1,s6
    80002172:	05093503          	ld	a0,80(s2)
    80002176:	beaff0ef          	jal	80001560 <copyout>
    8000217a:	02054b63          	bltz	a0,800021b0 <wait+0x92>
          freeproc(pp);
    8000217e:	8526                	mv	a0,s1
    80002180:	8e1ff0ef          	jal	80001a60 <freeproc>
          release(&pp->lock);
    80002184:	8526                	mv	a0,s1
    80002186:	b15fe0ef          	jal	80000c9a <release>
          release(&wait_lock);
    8000218a:	00010517          	auipc	a0,0x10
    8000218e:	1fe50513          	addi	a0,a0,510 # 80012388 <wait_lock>
    80002192:	b09fe0ef          	jal	80000c9a <release>
}
    80002196:	854e                	mv	a0,s3
    80002198:	60a6                	ld	ra,72(sp)
    8000219a:	6406                	ld	s0,64(sp)
    8000219c:	74e2                	ld	s1,56(sp)
    8000219e:	7942                	ld	s2,48(sp)
    800021a0:	79a2                	ld	s3,40(sp)
    800021a2:	7a02                	ld	s4,32(sp)
    800021a4:	6ae2                	ld	s5,24(sp)
    800021a6:	6b42                	ld	s6,16(sp)
    800021a8:	6ba2                	ld	s7,8(sp)
    800021aa:	6c02                	ld	s8,0(sp)
    800021ac:	6161                	addi	sp,sp,80
    800021ae:	8082                	ret
            release(&pp->lock);
    800021b0:	8526                	mv	a0,s1
    800021b2:	ae9fe0ef          	jal	80000c9a <release>
            release(&wait_lock);
    800021b6:	00010517          	auipc	a0,0x10
    800021ba:	1d250513          	addi	a0,a0,466 # 80012388 <wait_lock>
    800021be:	addfe0ef          	jal	80000c9a <release>
            return -1;
    800021c2:	59fd                	li	s3,-1
    800021c4:	bfc9                	j	80002196 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021c6:	16848493          	addi	s1,s1,360
    800021ca:	03348063          	beq	s1,s3,800021ea <wait+0xcc>
      if(pp->parent == p){
    800021ce:	7c9c                	ld	a5,56(s1)
    800021d0:	ff279be3          	bne	a5,s2,800021c6 <wait+0xa8>
        acquire(&pp->lock);
    800021d4:	8526                	mv	a0,s1
    800021d6:	a2dfe0ef          	jal	80000c02 <acquire>
        if(pp->state == ZOMBIE){
    800021da:	4c9c                	lw	a5,24(s1)
    800021dc:	f94783e3          	beq	a5,s4,80002162 <wait+0x44>
        release(&pp->lock);
    800021e0:	8526                	mv	a0,s1
    800021e2:	ab9fe0ef          	jal	80000c9a <release>
        havekids = 1;
    800021e6:	8756                	mv	a4,s5
    800021e8:	bff9                	j	800021c6 <wait+0xa8>
    if(!havekids || killed(p)){
    800021ea:	cf19                	beqz	a4,80002208 <wait+0xea>
    800021ec:	854a                	mv	a0,s2
    800021ee:	f07ff0ef          	jal	800020f4 <killed>
    800021f2:	e919                	bnez	a0,80002208 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800021f4:	85e2                	mv	a1,s8
    800021f6:	854a                	mv	a0,s2
    800021f8:	cc5ff0ef          	jal	80001ebc <sleep>
    havekids = 0;
    800021fc:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021fe:	00010497          	auipc	s1,0x10
    80002202:	5a248493          	addi	s1,s1,1442 # 800127a0 <proc>
    80002206:	b7e1                	j	800021ce <wait+0xb0>
      release(&wait_lock);
    80002208:	00010517          	auipc	a0,0x10
    8000220c:	18050513          	addi	a0,a0,384 # 80012388 <wait_lock>
    80002210:	a8bfe0ef          	jal	80000c9a <release>
      return -1;
    80002214:	59fd                	li	s3,-1
    80002216:	b741                	j	80002196 <wait+0x78>

0000000080002218 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002218:	7179                	addi	sp,sp,-48
    8000221a:	f406                	sd	ra,40(sp)
    8000221c:	f022                	sd	s0,32(sp)
    8000221e:	ec26                	sd	s1,24(sp)
    80002220:	e84a                	sd	s2,16(sp)
    80002222:	e44e                	sd	s3,8(sp)
    80002224:	e052                	sd	s4,0(sp)
    80002226:	1800                	addi	s0,sp,48
    80002228:	84aa                	mv	s1,a0
    8000222a:	892e                	mv	s2,a1
    8000222c:	89b2                	mv	s3,a2
    8000222e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002230:	ebeff0ef          	jal	800018ee <myproc>
  if(user_dst){
    80002234:	cc99                	beqz	s1,80002252 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002236:	86d2                	mv	a3,s4
    80002238:	864e                	mv	a2,s3
    8000223a:	85ca                	mv	a1,s2
    8000223c:	6928                	ld	a0,80(a0)
    8000223e:	b22ff0ef          	jal	80001560 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002242:	70a2                	ld	ra,40(sp)
    80002244:	7402                	ld	s0,32(sp)
    80002246:	64e2                	ld	s1,24(sp)
    80002248:	6942                	ld	s2,16(sp)
    8000224a:	69a2                	ld	s3,8(sp)
    8000224c:	6a02                	ld	s4,0(sp)
    8000224e:	6145                	addi	sp,sp,48
    80002250:	8082                	ret
    memmove((char *)dst, src, len);
    80002252:	000a061b          	sext.w	a2,s4
    80002256:	85ce                	mv	a1,s3
    80002258:	854a                	mv	a0,s2
    8000225a:	ad9fe0ef          	jal	80000d32 <memmove>
    return 0;
    8000225e:	8526                	mv	a0,s1
    80002260:	b7cd                	j	80002242 <either_copyout+0x2a>

0000000080002262 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002262:	7179                	addi	sp,sp,-48
    80002264:	f406                	sd	ra,40(sp)
    80002266:	f022                	sd	s0,32(sp)
    80002268:	ec26                	sd	s1,24(sp)
    8000226a:	e84a                	sd	s2,16(sp)
    8000226c:	e44e                	sd	s3,8(sp)
    8000226e:	e052                	sd	s4,0(sp)
    80002270:	1800                	addi	s0,sp,48
    80002272:	892a                	mv	s2,a0
    80002274:	84ae                	mv	s1,a1
    80002276:	89b2                	mv	s3,a2
    80002278:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000227a:	e74ff0ef          	jal	800018ee <myproc>
  if(user_src){
    8000227e:	cc99                	beqz	s1,8000229c <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002280:	86d2                	mv	a3,s4
    80002282:	864e                	mv	a2,s3
    80002284:	85ca                	mv	a1,s2
    80002286:	6928                	ld	a0,80(a0)
    80002288:	baeff0ef          	jal	80001636 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000228c:	70a2                	ld	ra,40(sp)
    8000228e:	7402                	ld	s0,32(sp)
    80002290:	64e2                	ld	s1,24(sp)
    80002292:	6942                	ld	s2,16(sp)
    80002294:	69a2                	ld	s3,8(sp)
    80002296:	6a02                	ld	s4,0(sp)
    80002298:	6145                	addi	sp,sp,48
    8000229a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000229c:	000a061b          	sext.w	a2,s4
    800022a0:	85ce                	mv	a1,s3
    800022a2:	854a                	mv	a0,s2
    800022a4:	a8ffe0ef          	jal	80000d32 <memmove>
    return 0;
    800022a8:	8526                	mv	a0,s1
    800022aa:	b7cd                	j	8000228c <either_copyin+0x2a>

00000000800022ac <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800022ac:	715d                	addi	sp,sp,-80
    800022ae:	e486                	sd	ra,72(sp)
    800022b0:	e0a2                	sd	s0,64(sp)
    800022b2:	fc26                	sd	s1,56(sp)
    800022b4:	f84a                	sd	s2,48(sp)
    800022b6:	f44e                	sd	s3,40(sp)
    800022b8:	f052                	sd	s4,32(sp)
    800022ba:	ec56                	sd	s5,24(sp)
    800022bc:	e85a                	sd	s6,16(sp)
    800022be:	e45e                	sd	s7,8(sp)
    800022c0:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800022c2:	00005517          	auipc	a0,0x5
    800022c6:	db650513          	addi	a0,a0,-586 # 80007078 <etext+0x78>
    800022ca:	a06fe0ef          	jal	800004d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800022ce:	00010497          	auipc	s1,0x10
    800022d2:	62a48493          	addi	s1,s1,1578 # 800128f8 <proc+0x158>
    800022d6:	00016917          	auipc	s2,0x16
    800022da:	02290913          	addi	s2,s2,34 # 800182f8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800022de:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800022e0:	00005997          	auipc	s3,0x5
    800022e4:	fc098993          	addi	s3,s3,-64 # 800072a0 <etext+0x2a0>
    printf("%d %s %s", p->pid, state, p->name);
    800022e8:	00005a97          	auipc	s5,0x5
    800022ec:	fc0a8a93          	addi	s5,s5,-64 # 800072a8 <etext+0x2a8>
    printf("\n");
    800022f0:	00005a17          	auipc	s4,0x5
    800022f4:	d88a0a13          	addi	s4,s4,-632 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800022f8:	00005b97          	auipc	s7,0x5
    800022fc:	490b8b93          	addi	s7,s7,1168 # 80007788 <states.0>
    80002300:	a829                	j	8000231a <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002302:	ed86a583          	lw	a1,-296(a3)
    80002306:	8556                	mv	a0,s5
    80002308:	9c8fe0ef          	jal	800004d0 <printf>
    printf("\n");
    8000230c:	8552                	mv	a0,s4
    8000230e:	9c2fe0ef          	jal	800004d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002312:	16848493          	addi	s1,s1,360
    80002316:	03248263          	beq	s1,s2,8000233a <procdump+0x8e>
    if(p->state == UNUSED)
    8000231a:	86a6                	mv	a3,s1
    8000231c:	ec04a783          	lw	a5,-320(s1)
    80002320:	dbed                	beqz	a5,80002312 <procdump+0x66>
      state = "???";
    80002322:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002324:	fcfb6fe3          	bltu	s6,a5,80002302 <procdump+0x56>
    80002328:	02079713          	slli	a4,a5,0x20
    8000232c:	01d75793          	srli	a5,a4,0x1d
    80002330:	97de                	add	a5,a5,s7
    80002332:	6390                	ld	a2,0(a5)
    80002334:	f679                	bnez	a2,80002302 <procdump+0x56>
      state = "???";
    80002336:	864e                	mv	a2,s3
    80002338:	b7e9                	j	80002302 <procdump+0x56>
  }
}
    8000233a:	60a6                	ld	ra,72(sp)
    8000233c:	6406                	ld	s0,64(sp)
    8000233e:	74e2                	ld	s1,56(sp)
    80002340:	7942                	ld	s2,48(sp)
    80002342:	79a2                	ld	s3,40(sp)
    80002344:	7a02                	ld	s4,32(sp)
    80002346:	6ae2                	ld	s5,24(sp)
    80002348:	6b42                	ld	s6,16(sp)
    8000234a:	6ba2                	ld	s7,8(sp)
    8000234c:	6161                	addi	sp,sp,80
    8000234e:	8082                	ret

0000000080002350 <swtch>:
    80002350:	00153023          	sd	ra,0(a0)
    80002354:	00253423          	sd	sp,8(a0)
    80002358:	e900                	sd	s0,16(a0)
    8000235a:	ed04                	sd	s1,24(a0)
    8000235c:	03253023          	sd	s2,32(a0)
    80002360:	03353423          	sd	s3,40(a0)
    80002364:	03453823          	sd	s4,48(a0)
    80002368:	03553c23          	sd	s5,56(a0)
    8000236c:	05653023          	sd	s6,64(a0)
    80002370:	05753423          	sd	s7,72(a0)
    80002374:	05853823          	sd	s8,80(a0)
    80002378:	05953c23          	sd	s9,88(a0)
    8000237c:	07a53023          	sd	s10,96(a0)
    80002380:	07b53423          	sd	s11,104(a0)
    80002384:	0005b083          	ld	ra,0(a1)
    80002388:	0085b103          	ld	sp,8(a1)
    8000238c:	6980                	ld	s0,16(a1)
    8000238e:	6d84                	ld	s1,24(a1)
    80002390:	0205b903          	ld	s2,32(a1)
    80002394:	0285b983          	ld	s3,40(a1)
    80002398:	0305ba03          	ld	s4,48(a1)
    8000239c:	0385ba83          	ld	s5,56(a1)
    800023a0:	0405bb03          	ld	s6,64(a1)
    800023a4:	0485bb83          	ld	s7,72(a1)
    800023a8:	0505bc03          	ld	s8,80(a1)
    800023ac:	0585bc83          	ld	s9,88(a1)
    800023b0:	0605bd03          	ld	s10,96(a1)
    800023b4:	0685bd83          	ld	s11,104(a1)
    800023b8:	8082                	ret

00000000800023ba <trapinit>:
    800023ba:	1141                	addi	sp,sp,-16
    800023bc:	e406                	sd	ra,8(sp)
    800023be:	e022                	sd	s0,0(sp)
    800023c0:	0800                	addi	s0,sp,16
    800023c2:	00005597          	auipc	a1,0x5
    800023c6:	f2658593          	addi	a1,a1,-218 # 800072e8 <etext+0x2e8>
    800023ca:	00016517          	auipc	a0,0x16
    800023ce:	dd650513          	addi	a0,a0,-554 # 800181a0 <tickslock>
    800023d2:	fb0fe0ef          	jal	80000b82 <initlock>
    800023d6:	60a2                	ld	ra,8(sp)
    800023d8:	6402                	ld	s0,0(sp)
    800023da:	0141                	addi	sp,sp,16
    800023dc:	8082                	ret

00000000800023de <trapinithart>:
    800023de:	1141                	addi	sp,sp,-16
    800023e0:	e422                	sd	s0,8(sp)
    800023e2:	0800                	addi	s0,sp,16
    800023e4:	00003797          	auipc	a5,0x3
    800023e8:	e0c78793          	addi	a5,a5,-500 # 800051f0 <kernelvec>
    800023ec:	10579073          	csrw	stvec,a5
    800023f0:	6422                	ld	s0,8(sp)
    800023f2:	0141                	addi	sp,sp,16
    800023f4:	8082                	ret

00000000800023f6 <usertrapret>:
    800023f6:	1141                	addi	sp,sp,-16
    800023f8:	e406                	sd	ra,8(sp)
    800023fa:	e022                	sd	s0,0(sp)
    800023fc:	0800                	addi	s0,sp,16
    800023fe:	cf0ff0ef          	jal	800018ee <myproc>
    80002402:	100027f3          	csrr	a5,sstatus
    80002406:	9bf5                	andi	a5,a5,-3
    80002408:	10079073          	csrw	sstatus,a5
    8000240c:	00004697          	auipc	a3,0x4
    80002410:	bf468693          	addi	a3,a3,-1036 # 80006000 <_trampoline>
    80002414:	00004717          	auipc	a4,0x4
    80002418:	bec70713          	addi	a4,a4,-1044 # 80006000 <_trampoline>
    8000241c:	8f15                	sub	a4,a4,a3
    8000241e:	040007b7          	lui	a5,0x4000
    80002422:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002424:	07b2                	slli	a5,a5,0xc
    80002426:	973e                	add	a4,a4,a5
    80002428:	10571073          	csrw	stvec,a4
    8000242c:	6d38                	ld	a4,88(a0)
    8000242e:	18002673          	csrr	a2,satp
    80002432:	e310                	sd	a2,0(a4)
    80002434:	6d30                	ld	a2,88(a0)
    80002436:	6138                	ld	a4,64(a0)
    80002438:	6585                	lui	a1,0x1
    8000243a:	972e                	add	a4,a4,a1
    8000243c:	e618                	sd	a4,8(a2)
    8000243e:	6d38                	ld	a4,88(a0)
    80002440:	00000617          	auipc	a2,0x0
    80002444:	11060613          	addi	a2,a2,272 # 80002550 <usertrap>
    80002448:	eb10                	sd	a2,16(a4)
    8000244a:	6d38                	ld	a4,88(a0)
    8000244c:	8612                	mv	a2,tp
    8000244e:	f310                	sd	a2,32(a4)
    80002450:	10002773          	csrr	a4,sstatus
    80002454:	eff77713          	andi	a4,a4,-257
    80002458:	02076713          	ori	a4,a4,32
    8000245c:	10071073          	csrw	sstatus,a4
    80002460:	6d38                	ld	a4,88(a0)
    80002462:	6f18                	ld	a4,24(a4)
    80002464:	14171073          	csrw	sepc,a4
    80002468:	6928                	ld	a0,80(a0)
    8000246a:	8131                	srli	a0,a0,0xc
    8000246c:	00004717          	auipc	a4,0x4
    80002470:	c3070713          	addi	a4,a4,-976 # 8000609c <userret>
    80002474:	8f15                	sub	a4,a4,a3
    80002476:	97ba                	add	a5,a5,a4
    80002478:	577d                	li	a4,-1
    8000247a:	177e                	slli	a4,a4,0x3f
    8000247c:	8d59                	or	a0,a0,a4
    8000247e:	9782                	jalr	a5
    80002480:	60a2                	ld	ra,8(sp)
    80002482:	6402                	ld	s0,0(sp)
    80002484:	0141                	addi	sp,sp,16
    80002486:	8082                	ret

0000000080002488 <clockintr>:
    80002488:	1101                	addi	sp,sp,-32
    8000248a:	ec06                	sd	ra,24(sp)
    8000248c:	e822                	sd	s0,16(sp)
    8000248e:	1000                	addi	s0,sp,32
    80002490:	c32ff0ef          	jal	800018c2 <cpuid>
    80002494:	cd11                	beqz	a0,800024b0 <clockintr+0x28>
    80002496:	c01027f3          	rdtime	a5
    8000249a:	000f4737          	lui	a4,0xf4
    8000249e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800024a2:	97ba                	add	a5,a5,a4
    800024a4:	14d79073          	csrw	stimecmp,a5
    800024a8:	60e2                	ld	ra,24(sp)
    800024aa:	6442                	ld	s0,16(sp)
    800024ac:	6105                	addi	sp,sp,32
    800024ae:	8082                	ret
    800024b0:	e426                	sd	s1,8(sp)
    800024b2:	00016497          	auipc	s1,0x16
    800024b6:	cee48493          	addi	s1,s1,-786 # 800181a0 <tickslock>
    800024ba:	8526                	mv	a0,s1
    800024bc:	f46fe0ef          	jal	80000c02 <acquire>
    800024c0:	00008517          	auipc	a0,0x8
    800024c4:	d8050513          	addi	a0,a0,-640 # 8000a240 <ticks>
    800024c8:	411c                	lw	a5,0(a0)
    800024ca:	2785                	addiw	a5,a5,1
    800024cc:	c11c                	sw	a5,0(a0)
    800024ce:	a3bff0ef          	jal	80001f08 <wakeup>
    800024d2:	8526                	mv	a0,s1
    800024d4:	fc6fe0ef          	jal	80000c9a <release>
    800024d8:	64a2                	ld	s1,8(sp)
    800024da:	bf75                	j	80002496 <clockintr+0xe>

00000000800024dc <devintr>:
    800024dc:	1101                	addi	sp,sp,-32
    800024de:	ec06                	sd	ra,24(sp)
    800024e0:	e822                	sd	s0,16(sp)
    800024e2:	1000                	addi	s0,sp,32
    800024e4:	14202773          	csrr	a4,scause
    800024e8:	57fd                	li	a5,-1
    800024ea:	17fe                	slli	a5,a5,0x3f
    800024ec:	07a5                	addi	a5,a5,9
    800024ee:	00f70c63          	beq	a4,a5,80002506 <devintr+0x2a>
    800024f2:	57fd                	li	a5,-1
    800024f4:	17fe                	slli	a5,a5,0x3f
    800024f6:	0795                	addi	a5,a5,5
    800024f8:	4501                	li	a0,0
    800024fa:	04f70763          	beq	a4,a5,80002548 <devintr+0x6c>
    800024fe:	60e2                	ld	ra,24(sp)
    80002500:	6442                	ld	s0,16(sp)
    80002502:	6105                	addi	sp,sp,32
    80002504:	8082                	ret
    80002506:	e426                	sd	s1,8(sp)
    80002508:	595020ef          	jal	8000529c <plic_claim>
    8000250c:	84aa                	mv	s1,a0
    8000250e:	47a9                	li	a5,10
    80002510:	00f50963          	beq	a0,a5,80002522 <devintr+0x46>
    80002514:	4785                	li	a5,1
    80002516:	00f50963          	beq	a0,a5,80002528 <devintr+0x4c>
    8000251a:	4505                	li	a0,1
    8000251c:	e889                	bnez	s1,8000252e <devintr+0x52>
    8000251e:	64a2                	ld	s1,8(sp)
    80002520:	bff9                	j	800024fe <devintr+0x22>
    80002522:	cf2fe0ef          	jal	80000a14 <uartintr>
    80002526:	a819                	j	8000253c <devintr+0x60>
    80002528:	23a030ef          	jal	80005762 <virtio_disk_intr>
    8000252c:	a801                	j	8000253c <devintr+0x60>
    8000252e:	85a6                	mv	a1,s1
    80002530:	00005517          	auipc	a0,0x5
    80002534:	dc050513          	addi	a0,a0,-576 # 800072f0 <etext+0x2f0>
    80002538:	f99fd0ef          	jal	800004d0 <printf>
    8000253c:	8526                	mv	a0,s1
    8000253e:	57f020ef          	jal	800052bc <plic_complete>
    80002542:	4505                	li	a0,1
    80002544:	64a2                	ld	s1,8(sp)
    80002546:	bf65                	j	800024fe <devintr+0x22>
    80002548:	f41ff0ef          	jal	80002488 <clockintr>
    8000254c:	4509                	li	a0,2
    8000254e:	bf45                	j	800024fe <devintr+0x22>

0000000080002550 <usertrap>:
    80002550:	1101                	addi	sp,sp,-32
    80002552:	ec06                	sd	ra,24(sp)
    80002554:	e822                	sd	s0,16(sp)
    80002556:	e426                	sd	s1,8(sp)
    80002558:	e04a                	sd	s2,0(sp)
    8000255a:	1000                	addi	s0,sp,32
    8000255c:	100027f3          	csrr	a5,sstatus
    80002560:	1007f793          	andi	a5,a5,256
    80002564:	ef85                	bnez	a5,8000259c <usertrap+0x4c>
    80002566:	00003797          	auipc	a5,0x3
    8000256a:	c8a78793          	addi	a5,a5,-886 # 800051f0 <kernelvec>
    8000256e:	10579073          	csrw	stvec,a5
    80002572:	b7cff0ef          	jal	800018ee <myproc>
    80002576:	84aa                	mv	s1,a0
    80002578:	6d3c                	ld	a5,88(a0)
    8000257a:	14102773          	csrr	a4,sepc
    8000257e:	ef98                	sd	a4,24(a5)
    80002580:	14202773          	csrr	a4,scause
    80002584:	47a1                	li	a5,8
    80002586:	02f70163          	beq	a4,a5,800025a8 <usertrap+0x58>
    8000258a:	f53ff0ef          	jal	800024dc <devintr>
    8000258e:	892a                	mv	s2,a0
    80002590:	c135                	beqz	a0,800025f4 <usertrap+0xa4>
    80002592:	8526                	mv	a0,s1
    80002594:	b61ff0ef          	jal	800020f4 <killed>
    80002598:	cd1d                	beqz	a0,800025d6 <usertrap+0x86>
    8000259a:	a81d                	j	800025d0 <usertrap+0x80>
    8000259c:	00005517          	auipc	a0,0x5
    800025a0:	d7450513          	addi	a0,a0,-652 # 80007310 <etext+0x310>
    800025a4:	9fefe0ef          	jal	800007a2 <panic>
    800025a8:	b4dff0ef          	jal	800020f4 <killed>
    800025ac:	e121                	bnez	a0,800025ec <usertrap+0x9c>
    800025ae:	6cb8                	ld	a4,88(s1)
    800025b0:	6f1c                	ld	a5,24(a4)
    800025b2:	0791                	addi	a5,a5,4
    800025b4:	ef1c                	sd	a5,24(a4)
    800025b6:	100027f3          	csrr	a5,sstatus
    800025ba:	0027e793          	ori	a5,a5,2
    800025be:	10079073          	csrw	sstatus,a5
    800025c2:	248000ef          	jal	8000280a <syscall>
    800025c6:	8526                	mv	a0,s1
    800025c8:	b2dff0ef          	jal	800020f4 <killed>
    800025cc:	c901                	beqz	a0,800025dc <usertrap+0x8c>
    800025ce:	4901                	li	s2,0
    800025d0:	557d                	li	a0,-1
    800025d2:	9f7ff0ef          	jal	80001fc8 <exit>
    800025d6:	4789                	li	a5,2
    800025d8:	04f90563          	beq	s2,a5,80002622 <usertrap+0xd2>
    800025dc:	e1bff0ef          	jal	800023f6 <usertrapret>
    800025e0:	60e2                	ld	ra,24(sp)
    800025e2:	6442                	ld	s0,16(sp)
    800025e4:	64a2                	ld	s1,8(sp)
    800025e6:	6902                	ld	s2,0(sp)
    800025e8:	6105                	addi	sp,sp,32
    800025ea:	8082                	ret
    800025ec:	557d                	li	a0,-1
    800025ee:	9dbff0ef          	jal	80001fc8 <exit>
    800025f2:	bf75                	j	800025ae <usertrap+0x5e>
    800025f4:	142025f3          	csrr	a1,scause
    800025f8:	5890                	lw	a2,48(s1)
    800025fa:	00005517          	auipc	a0,0x5
    800025fe:	d3650513          	addi	a0,a0,-714 # 80007330 <etext+0x330>
    80002602:	ecffd0ef          	jal	800004d0 <printf>
    80002606:	141025f3          	csrr	a1,sepc
    8000260a:	14302673          	csrr	a2,stval
    8000260e:	00005517          	auipc	a0,0x5
    80002612:	d5250513          	addi	a0,a0,-686 # 80007360 <etext+0x360>
    80002616:	ebbfd0ef          	jal	800004d0 <printf>
    8000261a:	8526                	mv	a0,s1
    8000261c:	ab5ff0ef          	jal	800020d0 <setkilled>
    80002620:	b75d                	j	800025c6 <usertrap+0x76>
    80002622:	86fff0ef          	jal	80001e90 <yield>
    80002626:	bf5d                	j	800025dc <usertrap+0x8c>

0000000080002628 <kerneltrap>:
    80002628:	7179                	addi	sp,sp,-48
    8000262a:	f406                	sd	ra,40(sp)
    8000262c:	f022                	sd	s0,32(sp)
    8000262e:	ec26                	sd	s1,24(sp)
    80002630:	e84a                	sd	s2,16(sp)
    80002632:	e44e                	sd	s3,8(sp)
    80002634:	1800                	addi	s0,sp,48
    80002636:	14102973          	csrr	s2,sepc
    8000263a:	100024f3          	csrr	s1,sstatus
    8000263e:	142029f3          	csrr	s3,scause
    80002642:	1004f793          	andi	a5,s1,256
    80002646:	c795                	beqz	a5,80002672 <kerneltrap+0x4a>
    80002648:	100027f3          	csrr	a5,sstatus
    8000264c:	8b89                	andi	a5,a5,2
    8000264e:	eb85                	bnez	a5,8000267e <kerneltrap+0x56>
    80002650:	e8dff0ef          	jal	800024dc <devintr>
    80002654:	c91d                	beqz	a0,8000268a <kerneltrap+0x62>
    80002656:	4789                	li	a5,2
    80002658:	04f50a63          	beq	a0,a5,800026ac <kerneltrap+0x84>
    8000265c:	14191073          	csrw	sepc,s2
    80002660:	10049073          	csrw	sstatus,s1
    80002664:	70a2                	ld	ra,40(sp)
    80002666:	7402                	ld	s0,32(sp)
    80002668:	64e2                	ld	s1,24(sp)
    8000266a:	6942                	ld	s2,16(sp)
    8000266c:	69a2                	ld	s3,8(sp)
    8000266e:	6145                	addi	sp,sp,48
    80002670:	8082                	ret
    80002672:	00005517          	auipc	a0,0x5
    80002676:	d1650513          	addi	a0,a0,-746 # 80007388 <etext+0x388>
    8000267a:	928fe0ef          	jal	800007a2 <panic>
    8000267e:	00005517          	auipc	a0,0x5
    80002682:	d3250513          	addi	a0,a0,-718 # 800073b0 <etext+0x3b0>
    80002686:	91cfe0ef          	jal	800007a2 <panic>
    8000268a:	14102673          	csrr	a2,sepc
    8000268e:	143026f3          	csrr	a3,stval
    80002692:	85ce                	mv	a1,s3
    80002694:	00005517          	auipc	a0,0x5
    80002698:	d3c50513          	addi	a0,a0,-708 # 800073d0 <etext+0x3d0>
    8000269c:	e35fd0ef          	jal	800004d0 <printf>
    800026a0:	00005517          	auipc	a0,0x5
    800026a4:	d5850513          	addi	a0,a0,-680 # 800073f8 <etext+0x3f8>
    800026a8:	8fafe0ef          	jal	800007a2 <panic>
    800026ac:	a42ff0ef          	jal	800018ee <myproc>
    800026b0:	d555                	beqz	a0,8000265c <kerneltrap+0x34>
    800026b2:	fdeff0ef          	jal	80001e90 <yield>
    800026b6:	b75d                	j	8000265c <kerneltrap+0x34>

00000000800026b8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800026b8:	1101                	addi	sp,sp,-32
    800026ba:	ec06                	sd	ra,24(sp)
    800026bc:	e822                	sd	s0,16(sp)
    800026be:	e426                	sd	s1,8(sp)
    800026c0:	1000                	addi	s0,sp,32
    800026c2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800026c4:	a2aff0ef          	jal	800018ee <myproc>
  switch (n) {
    800026c8:	4795                	li	a5,5
    800026ca:	0497e163          	bltu	a5,s1,8000270c <argraw+0x54>
    800026ce:	048a                	slli	s1,s1,0x2
    800026d0:	00005717          	auipc	a4,0x5
    800026d4:	0e870713          	addi	a4,a4,232 # 800077b8 <states.0+0x30>
    800026d8:	94ba                	add	s1,s1,a4
    800026da:	409c                	lw	a5,0(s1)
    800026dc:	97ba                	add	a5,a5,a4
    800026de:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800026e0:	6d3c                	ld	a5,88(a0)
    800026e2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800026e4:	60e2                	ld	ra,24(sp)
    800026e6:	6442                	ld	s0,16(sp)
    800026e8:	64a2                	ld	s1,8(sp)
    800026ea:	6105                	addi	sp,sp,32
    800026ec:	8082                	ret
    return p->trapframe->a1;
    800026ee:	6d3c                	ld	a5,88(a0)
    800026f0:	7fa8                	ld	a0,120(a5)
    800026f2:	bfcd                	j	800026e4 <argraw+0x2c>
    return p->trapframe->a2;
    800026f4:	6d3c                	ld	a5,88(a0)
    800026f6:	63c8                	ld	a0,128(a5)
    800026f8:	b7f5                	j	800026e4 <argraw+0x2c>
    return p->trapframe->a3;
    800026fa:	6d3c                	ld	a5,88(a0)
    800026fc:	67c8                	ld	a0,136(a5)
    800026fe:	b7dd                	j	800026e4 <argraw+0x2c>
    return p->trapframe->a4;
    80002700:	6d3c                	ld	a5,88(a0)
    80002702:	6bc8                	ld	a0,144(a5)
    80002704:	b7c5                	j	800026e4 <argraw+0x2c>
    return p->trapframe->a5;
    80002706:	6d3c                	ld	a5,88(a0)
    80002708:	6fc8                	ld	a0,152(a5)
    8000270a:	bfe9                	j	800026e4 <argraw+0x2c>
  panic("argraw");
    8000270c:	00005517          	auipc	a0,0x5
    80002710:	cfc50513          	addi	a0,a0,-772 # 80007408 <etext+0x408>
    80002714:	88efe0ef          	jal	800007a2 <panic>

0000000080002718 <fetchaddr>:
{
    80002718:	1101                	addi	sp,sp,-32
    8000271a:	ec06                	sd	ra,24(sp)
    8000271c:	e822                	sd	s0,16(sp)
    8000271e:	e426                	sd	s1,8(sp)
    80002720:	e04a                	sd	s2,0(sp)
    80002722:	1000                	addi	s0,sp,32
    80002724:	84aa                	mv	s1,a0
    80002726:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002728:	9c6ff0ef          	jal	800018ee <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000272c:	653c                	ld	a5,72(a0)
    8000272e:	02f4f663          	bgeu	s1,a5,8000275a <fetchaddr+0x42>
    80002732:	00848713          	addi	a4,s1,8
    80002736:	02e7e463          	bltu	a5,a4,8000275e <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000273a:	46a1                	li	a3,8
    8000273c:	8626                	mv	a2,s1
    8000273e:	85ca                	mv	a1,s2
    80002740:	6928                	ld	a0,80(a0)
    80002742:	ef5fe0ef          	jal	80001636 <copyin>
    80002746:	00a03533          	snez	a0,a0
    8000274a:	40a00533          	neg	a0,a0
}
    8000274e:	60e2                	ld	ra,24(sp)
    80002750:	6442                	ld	s0,16(sp)
    80002752:	64a2                	ld	s1,8(sp)
    80002754:	6902                	ld	s2,0(sp)
    80002756:	6105                	addi	sp,sp,32
    80002758:	8082                	ret
    return -1;
    8000275a:	557d                	li	a0,-1
    8000275c:	bfcd                	j	8000274e <fetchaddr+0x36>
    8000275e:	557d                	li	a0,-1
    80002760:	b7fd                	j	8000274e <fetchaddr+0x36>

0000000080002762 <fetchstr>:
{
    80002762:	7179                	addi	sp,sp,-48
    80002764:	f406                	sd	ra,40(sp)
    80002766:	f022                	sd	s0,32(sp)
    80002768:	ec26                	sd	s1,24(sp)
    8000276a:	e84a                	sd	s2,16(sp)
    8000276c:	e44e                	sd	s3,8(sp)
    8000276e:	1800                	addi	s0,sp,48
    80002770:	892a                	mv	s2,a0
    80002772:	84ae                	mv	s1,a1
    80002774:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002776:	978ff0ef          	jal	800018ee <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000277a:	86ce                	mv	a3,s3
    8000277c:	864a                	mv	a2,s2
    8000277e:	85a6                	mv	a1,s1
    80002780:	6928                	ld	a0,80(a0)
    80002782:	f3bfe0ef          	jal	800016bc <copyinstr>
    80002786:	00054c63          	bltz	a0,8000279e <fetchstr+0x3c>
  return strlen(buf);
    8000278a:	8526                	mv	a0,s1
    8000278c:	ebafe0ef          	jal	80000e46 <strlen>
}
    80002790:	70a2                	ld	ra,40(sp)
    80002792:	7402                	ld	s0,32(sp)
    80002794:	64e2                	ld	s1,24(sp)
    80002796:	6942                	ld	s2,16(sp)
    80002798:	69a2                	ld	s3,8(sp)
    8000279a:	6145                	addi	sp,sp,48
    8000279c:	8082                	ret
    return -1;
    8000279e:	557d                	li	a0,-1
    800027a0:	bfc5                	j	80002790 <fetchstr+0x2e>

00000000800027a2 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800027a2:	1101                	addi	sp,sp,-32
    800027a4:	ec06                	sd	ra,24(sp)
    800027a6:	e822                	sd	s0,16(sp)
    800027a8:	e426                	sd	s1,8(sp)
    800027aa:	1000                	addi	s0,sp,32
    800027ac:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027ae:	f0bff0ef          	jal	800026b8 <argraw>
    800027b2:	c088                	sw	a0,0(s1)
}
    800027b4:	60e2                	ld	ra,24(sp)
    800027b6:	6442                	ld	s0,16(sp)
    800027b8:	64a2                	ld	s1,8(sp)
    800027ba:	6105                	addi	sp,sp,32
    800027bc:	8082                	ret

00000000800027be <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800027be:	1101                	addi	sp,sp,-32
    800027c0:	ec06                	sd	ra,24(sp)
    800027c2:	e822                	sd	s0,16(sp)
    800027c4:	e426                	sd	s1,8(sp)
    800027c6:	1000                	addi	s0,sp,32
    800027c8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027ca:	eefff0ef          	jal	800026b8 <argraw>
    800027ce:	e088                	sd	a0,0(s1)
}
    800027d0:	60e2                	ld	ra,24(sp)
    800027d2:	6442                	ld	s0,16(sp)
    800027d4:	64a2                	ld	s1,8(sp)
    800027d6:	6105                	addi	sp,sp,32
    800027d8:	8082                	ret

00000000800027da <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800027da:	7179                	addi	sp,sp,-48
    800027dc:	f406                	sd	ra,40(sp)
    800027de:	f022                	sd	s0,32(sp)
    800027e0:	ec26                	sd	s1,24(sp)
    800027e2:	e84a                	sd	s2,16(sp)
    800027e4:	1800                	addi	s0,sp,48
    800027e6:	84ae                	mv	s1,a1
    800027e8:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800027ea:	fd840593          	addi	a1,s0,-40
    800027ee:	fd1ff0ef          	jal	800027be <argaddr>
  return fetchstr(addr, buf, max);
    800027f2:	864a                	mv	a2,s2
    800027f4:	85a6                	mv	a1,s1
    800027f6:	fd843503          	ld	a0,-40(s0)
    800027fa:	f69ff0ef          	jal	80002762 <fetchstr>
}
    800027fe:	70a2                	ld	ra,40(sp)
    80002800:	7402                	ld	s0,32(sp)
    80002802:	64e2                	ld	s1,24(sp)
    80002804:	6942                	ld	s2,16(sp)
    80002806:	6145                	addi	sp,sp,48
    80002808:	8082                	ret

000000008000280a <syscall>:
[SYS_kbdint]  sys_kbdint,
};

void
syscall(void)
{
    8000280a:	1101                	addi	sp,sp,-32
    8000280c:	ec06                	sd	ra,24(sp)
    8000280e:	e822                	sd	s0,16(sp)
    80002810:	e426                	sd	s1,8(sp)
    80002812:	e04a                	sd	s2,0(sp)
    80002814:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002816:	8d8ff0ef          	jal	800018ee <myproc>
    8000281a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000281c:	05853903          	ld	s2,88(a0)
    80002820:	0a893783          	ld	a5,168(s2)
    80002824:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002828:	37fd                	addiw	a5,a5,-1
    8000282a:	4755                	li	a4,21
    8000282c:	00f76f63          	bltu	a4,a5,8000284a <syscall+0x40>
    80002830:	00369713          	slli	a4,a3,0x3
    80002834:	00005797          	auipc	a5,0x5
    80002838:	f9c78793          	addi	a5,a5,-100 # 800077d0 <syscalls>
    8000283c:	97ba                	add	a5,a5,a4
    8000283e:	639c                	ld	a5,0(a5)
    80002840:	c789                	beqz	a5,8000284a <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002842:	9782                	jalr	a5
    80002844:	06a93823          	sd	a0,112(s2)
    80002848:	a829                	j	80002862 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000284a:	15848613          	addi	a2,s1,344
    8000284e:	588c                	lw	a1,48(s1)
    80002850:	00005517          	auipc	a0,0x5
    80002854:	bc050513          	addi	a0,a0,-1088 # 80007410 <etext+0x410>
    80002858:	c79fd0ef          	jal	800004d0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000285c:	6cbc                	ld	a5,88(s1)
    8000285e:	577d                	li	a4,-1
    80002860:	fbb8                	sd	a4,112(a5)
  }
}
    80002862:	60e2                	ld	ra,24(sp)
    80002864:	6442                	ld	s0,16(sp)
    80002866:	64a2                	ld	s1,8(sp)
    80002868:	6902                	ld	s2,0(sp)
    8000286a:	6105                	addi	sp,sp,32
    8000286c:	8082                	ret

000000008000286e <sys_exit>:
    8000286e:	1101                	addi	sp,sp,-32
    80002870:	ec06                	sd	ra,24(sp)
    80002872:	e822                	sd	s0,16(sp)
    80002874:	1000                	addi	s0,sp,32
    80002876:	fec40593          	addi	a1,s0,-20
    8000287a:	4501                	li	a0,0
    8000287c:	f27ff0ef          	jal	800027a2 <argint>
    80002880:	fec42503          	lw	a0,-20(s0)
    80002884:	f44ff0ef          	jal	80001fc8 <exit>
    80002888:	4501                	li	a0,0
    8000288a:	60e2                	ld	ra,24(sp)
    8000288c:	6442                	ld	s0,16(sp)
    8000288e:	6105                	addi	sp,sp,32
    80002890:	8082                	ret

0000000080002892 <sys_getpid>:
    80002892:	1141                	addi	sp,sp,-16
    80002894:	e406                	sd	ra,8(sp)
    80002896:	e022                	sd	s0,0(sp)
    80002898:	0800                	addi	s0,sp,16
    8000289a:	854ff0ef          	jal	800018ee <myproc>
    8000289e:	5908                	lw	a0,48(a0)
    800028a0:	60a2                	ld	ra,8(sp)
    800028a2:	6402                	ld	s0,0(sp)
    800028a4:	0141                	addi	sp,sp,16
    800028a6:	8082                	ret

00000000800028a8 <sys_fork>:
    800028a8:	1141                	addi	sp,sp,-16
    800028aa:	e406                	sd	ra,8(sp)
    800028ac:	e022                	sd	s0,0(sp)
    800028ae:	0800                	addi	s0,sp,16
    800028b0:	b64ff0ef          	jal	80001c14 <fork>
    800028b4:	60a2                	ld	ra,8(sp)
    800028b6:	6402                	ld	s0,0(sp)
    800028b8:	0141                	addi	sp,sp,16
    800028ba:	8082                	ret

00000000800028bc <sys_wait>:
    800028bc:	1101                	addi	sp,sp,-32
    800028be:	ec06                	sd	ra,24(sp)
    800028c0:	e822                	sd	s0,16(sp)
    800028c2:	1000                	addi	s0,sp,32
    800028c4:	fe840593          	addi	a1,s0,-24
    800028c8:	4501                	li	a0,0
    800028ca:	ef5ff0ef          	jal	800027be <argaddr>
    800028ce:	fe843503          	ld	a0,-24(s0)
    800028d2:	84dff0ef          	jal	8000211e <wait>
    800028d6:	60e2                	ld	ra,24(sp)
    800028d8:	6442                	ld	s0,16(sp)
    800028da:	6105                	addi	sp,sp,32
    800028dc:	8082                	ret

00000000800028de <sys_sbrk>:
    800028de:	7179                	addi	sp,sp,-48
    800028e0:	f406                	sd	ra,40(sp)
    800028e2:	f022                	sd	s0,32(sp)
    800028e4:	ec26                	sd	s1,24(sp)
    800028e6:	1800                	addi	s0,sp,48
    800028e8:	fdc40593          	addi	a1,s0,-36
    800028ec:	4501                	li	a0,0
    800028ee:	eb5ff0ef          	jal	800027a2 <argint>
    800028f2:	ffdfe0ef          	jal	800018ee <myproc>
    800028f6:	6524                	ld	s1,72(a0)
    800028f8:	fdc42503          	lw	a0,-36(s0)
    800028fc:	ac8ff0ef          	jal	80001bc4 <growproc>
    80002900:	00054863          	bltz	a0,80002910 <sys_sbrk+0x32>
    80002904:	8526                	mv	a0,s1
    80002906:	70a2                	ld	ra,40(sp)
    80002908:	7402                	ld	s0,32(sp)
    8000290a:	64e2                	ld	s1,24(sp)
    8000290c:	6145                	addi	sp,sp,48
    8000290e:	8082                	ret
    80002910:	54fd                	li	s1,-1
    80002912:	bfcd                	j	80002904 <sys_sbrk+0x26>

0000000080002914 <sys_sleep>:
    80002914:	7139                	addi	sp,sp,-64
    80002916:	fc06                	sd	ra,56(sp)
    80002918:	f822                	sd	s0,48(sp)
    8000291a:	f04a                	sd	s2,32(sp)
    8000291c:	0080                	addi	s0,sp,64
    8000291e:	fcc40593          	addi	a1,s0,-52
    80002922:	4501                	li	a0,0
    80002924:	e7fff0ef          	jal	800027a2 <argint>
    80002928:	fcc42783          	lw	a5,-52(s0)
    8000292c:	0607c763          	bltz	a5,8000299a <sys_sleep+0x86>
    80002930:	00016517          	auipc	a0,0x16
    80002934:	87050513          	addi	a0,a0,-1936 # 800181a0 <tickslock>
    80002938:	acafe0ef          	jal	80000c02 <acquire>
    8000293c:	00008917          	auipc	s2,0x8
    80002940:	90492903          	lw	s2,-1788(s2) # 8000a240 <ticks>
    80002944:	fcc42783          	lw	a5,-52(s0)
    80002948:	cf8d                	beqz	a5,80002982 <sys_sleep+0x6e>
    8000294a:	f426                	sd	s1,40(sp)
    8000294c:	ec4e                	sd	s3,24(sp)
    8000294e:	00016997          	auipc	s3,0x16
    80002952:	85298993          	addi	s3,s3,-1966 # 800181a0 <tickslock>
    80002956:	00008497          	auipc	s1,0x8
    8000295a:	8ea48493          	addi	s1,s1,-1814 # 8000a240 <ticks>
    8000295e:	f91fe0ef          	jal	800018ee <myproc>
    80002962:	f92ff0ef          	jal	800020f4 <killed>
    80002966:	ed0d                	bnez	a0,800029a0 <sys_sleep+0x8c>
    80002968:	85ce                	mv	a1,s3
    8000296a:	8526                	mv	a0,s1
    8000296c:	d50ff0ef          	jal	80001ebc <sleep>
    80002970:	409c                	lw	a5,0(s1)
    80002972:	412787bb          	subw	a5,a5,s2
    80002976:	fcc42703          	lw	a4,-52(s0)
    8000297a:	fee7e2e3          	bltu	a5,a4,8000295e <sys_sleep+0x4a>
    8000297e:	74a2                	ld	s1,40(sp)
    80002980:	69e2                	ld	s3,24(sp)
    80002982:	00016517          	auipc	a0,0x16
    80002986:	81e50513          	addi	a0,a0,-2018 # 800181a0 <tickslock>
    8000298a:	b10fe0ef          	jal	80000c9a <release>
    8000298e:	4501                	li	a0,0
    80002990:	70e2                	ld	ra,56(sp)
    80002992:	7442                	ld	s0,48(sp)
    80002994:	7902                	ld	s2,32(sp)
    80002996:	6121                	addi	sp,sp,64
    80002998:	8082                	ret
    8000299a:	fc042623          	sw	zero,-52(s0)
    8000299e:	bf49                	j	80002930 <sys_sleep+0x1c>
    800029a0:	00016517          	auipc	a0,0x16
    800029a4:	80050513          	addi	a0,a0,-2048 # 800181a0 <tickslock>
    800029a8:	af2fe0ef          	jal	80000c9a <release>
    800029ac:	557d                	li	a0,-1
    800029ae:	74a2                	ld	s1,40(sp)
    800029b0:	69e2                	ld	s3,24(sp)
    800029b2:	bff9                	j	80002990 <sys_sleep+0x7c>

00000000800029b4 <sys_kill>:
    800029b4:	1101                	addi	sp,sp,-32
    800029b6:	ec06                	sd	ra,24(sp)
    800029b8:	e822                	sd	s0,16(sp)
    800029ba:	1000                	addi	s0,sp,32
    800029bc:	fec40593          	addi	a1,s0,-20
    800029c0:	4501                	li	a0,0
    800029c2:	de1ff0ef          	jal	800027a2 <argint>
    800029c6:	fec42503          	lw	a0,-20(s0)
    800029ca:	ea0ff0ef          	jal	8000206a <kill>
    800029ce:	60e2                	ld	ra,24(sp)
    800029d0:	6442                	ld	s0,16(sp)
    800029d2:	6105                	addi	sp,sp,32
    800029d4:	8082                	ret

00000000800029d6 <sys_uptime>:
    800029d6:	1101                	addi	sp,sp,-32
    800029d8:	ec06                	sd	ra,24(sp)
    800029da:	e822                	sd	s0,16(sp)
    800029dc:	e426                	sd	s1,8(sp)
    800029de:	1000                	addi	s0,sp,32
    800029e0:	00015517          	auipc	a0,0x15
    800029e4:	7c050513          	addi	a0,a0,1984 # 800181a0 <tickslock>
    800029e8:	a1afe0ef          	jal	80000c02 <acquire>
    800029ec:	00008497          	auipc	s1,0x8
    800029f0:	8544a483          	lw	s1,-1964(s1) # 8000a240 <ticks>
    800029f4:	00015517          	auipc	a0,0x15
    800029f8:	7ac50513          	addi	a0,a0,1964 # 800181a0 <tickslock>
    800029fc:	a9efe0ef          	jal	80000c9a <release>
    80002a00:	02049513          	slli	a0,s1,0x20
    80002a04:	9101                	srli	a0,a0,0x20
    80002a06:	60e2                	ld	ra,24(sp)
    80002a08:	6442                	ld	s0,16(sp)
    80002a0a:	64a2                	ld	s1,8(sp)
    80002a0c:	6105                	addi	sp,sp,32
    80002a0e:	8082                	ret

0000000080002a10 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002a10:	7179                	addi	sp,sp,-48
    80002a12:	f406                	sd	ra,40(sp)
    80002a14:	f022                	sd	s0,32(sp)
    80002a16:	ec26                	sd	s1,24(sp)
    80002a18:	e84a                	sd	s2,16(sp)
    80002a1a:	e44e                	sd	s3,8(sp)
    80002a1c:	e052                	sd	s4,0(sp)
    80002a1e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002a20:	00005597          	auipc	a1,0x5
    80002a24:	a1058593          	addi	a1,a1,-1520 # 80007430 <etext+0x430>
    80002a28:	00015517          	auipc	a0,0x15
    80002a2c:	79050513          	addi	a0,a0,1936 # 800181b8 <bcache>
    80002a30:	952fe0ef          	jal	80000b82 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002a34:	0001d797          	auipc	a5,0x1d
    80002a38:	78478793          	addi	a5,a5,1924 # 800201b8 <bcache+0x8000>
    80002a3c:	0001e717          	auipc	a4,0x1e
    80002a40:	9e470713          	addi	a4,a4,-1564 # 80020420 <bcache+0x8268>
    80002a44:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002a48:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002a4c:	00015497          	auipc	s1,0x15
    80002a50:	78448493          	addi	s1,s1,1924 # 800181d0 <bcache+0x18>
    b->next = bcache.head.next;
    80002a54:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002a56:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002a58:	00005a17          	auipc	s4,0x5
    80002a5c:	9e0a0a13          	addi	s4,s4,-1568 # 80007438 <etext+0x438>
    b->next = bcache.head.next;
    80002a60:	2b893783          	ld	a5,696(s2)
    80002a64:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002a66:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002a6a:	85d2                	mv	a1,s4
    80002a6c:	01048513          	addi	a0,s1,16
    80002a70:	248010ef          	jal	80003cb8 <initsleeplock>
    bcache.head.next->prev = b;
    80002a74:	2b893783          	ld	a5,696(s2)
    80002a78:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002a7a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002a7e:	45848493          	addi	s1,s1,1112
    80002a82:	fd349fe3          	bne	s1,s3,80002a60 <binit+0x50>
  }
}
    80002a86:	70a2                	ld	ra,40(sp)
    80002a88:	7402                	ld	s0,32(sp)
    80002a8a:	64e2                	ld	s1,24(sp)
    80002a8c:	6942                	ld	s2,16(sp)
    80002a8e:	69a2                	ld	s3,8(sp)
    80002a90:	6a02                	ld	s4,0(sp)
    80002a92:	6145                	addi	sp,sp,48
    80002a94:	8082                	ret

0000000080002a96 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002a96:	7179                	addi	sp,sp,-48
    80002a98:	f406                	sd	ra,40(sp)
    80002a9a:	f022                	sd	s0,32(sp)
    80002a9c:	ec26                	sd	s1,24(sp)
    80002a9e:	e84a                	sd	s2,16(sp)
    80002aa0:	e44e                	sd	s3,8(sp)
    80002aa2:	1800                	addi	s0,sp,48
    80002aa4:	892a                	mv	s2,a0
    80002aa6:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002aa8:	00015517          	auipc	a0,0x15
    80002aac:	71050513          	addi	a0,a0,1808 # 800181b8 <bcache>
    80002ab0:	952fe0ef          	jal	80000c02 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002ab4:	0001e497          	auipc	s1,0x1e
    80002ab8:	9bc4b483          	ld	s1,-1604(s1) # 80020470 <bcache+0x82b8>
    80002abc:	0001e797          	auipc	a5,0x1e
    80002ac0:	96478793          	addi	a5,a5,-1692 # 80020420 <bcache+0x8268>
    80002ac4:	02f48b63          	beq	s1,a5,80002afa <bread+0x64>
    80002ac8:	873e                	mv	a4,a5
    80002aca:	a021                	j	80002ad2 <bread+0x3c>
    80002acc:	68a4                	ld	s1,80(s1)
    80002ace:	02e48663          	beq	s1,a4,80002afa <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002ad2:	449c                	lw	a5,8(s1)
    80002ad4:	ff279ce3          	bne	a5,s2,80002acc <bread+0x36>
    80002ad8:	44dc                	lw	a5,12(s1)
    80002ada:	ff3799e3          	bne	a5,s3,80002acc <bread+0x36>
      b->refcnt++;
    80002ade:	40bc                	lw	a5,64(s1)
    80002ae0:	2785                	addiw	a5,a5,1
    80002ae2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ae4:	00015517          	auipc	a0,0x15
    80002ae8:	6d450513          	addi	a0,a0,1748 # 800181b8 <bcache>
    80002aec:	9aefe0ef          	jal	80000c9a <release>
      acquiresleep(&b->lock);
    80002af0:	01048513          	addi	a0,s1,16
    80002af4:	1fa010ef          	jal	80003cee <acquiresleep>
      return b;
    80002af8:	a889                	j	80002b4a <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002afa:	0001e497          	auipc	s1,0x1e
    80002afe:	96e4b483          	ld	s1,-1682(s1) # 80020468 <bcache+0x82b0>
    80002b02:	0001e797          	auipc	a5,0x1e
    80002b06:	91e78793          	addi	a5,a5,-1762 # 80020420 <bcache+0x8268>
    80002b0a:	00f48863          	beq	s1,a5,80002b1a <bread+0x84>
    80002b0e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002b10:	40bc                	lw	a5,64(s1)
    80002b12:	cb91                	beqz	a5,80002b26 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002b14:	64a4                	ld	s1,72(s1)
    80002b16:	fee49de3          	bne	s1,a4,80002b10 <bread+0x7a>
  panic("bget: no buffers");
    80002b1a:	00005517          	auipc	a0,0x5
    80002b1e:	92650513          	addi	a0,a0,-1754 # 80007440 <etext+0x440>
    80002b22:	c81fd0ef          	jal	800007a2 <panic>
      b->dev = dev;
    80002b26:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002b2a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002b2e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002b32:	4785                	li	a5,1
    80002b34:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002b36:	00015517          	auipc	a0,0x15
    80002b3a:	68250513          	addi	a0,a0,1666 # 800181b8 <bcache>
    80002b3e:	95cfe0ef          	jal	80000c9a <release>
      acquiresleep(&b->lock);
    80002b42:	01048513          	addi	a0,s1,16
    80002b46:	1a8010ef          	jal	80003cee <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002b4a:	409c                	lw	a5,0(s1)
    80002b4c:	cb89                	beqz	a5,80002b5e <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002b4e:	8526                	mv	a0,s1
    80002b50:	70a2                	ld	ra,40(sp)
    80002b52:	7402                	ld	s0,32(sp)
    80002b54:	64e2                	ld	s1,24(sp)
    80002b56:	6942                	ld	s2,16(sp)
    80002b58:	69a2                	ld	s3,8(sp)
    80002b5a:	6145                	addi	sp,sp,48
    80002b5c:	8082                	ret
    virtio_disk_rw(b, 0);
    80002b5e:	4581                	li	a1,0
    80002b60:	8526                	mv	a0,s1
    80002b62:	1ef020ef          	jal	80005550 <virtio_disk_rw>
    b->valid = 1;
    80002b66:	4785                	li	a5,1
    80002b68:	c09c                	sw	a5,0(s1)
  return b;
    80002b6a:	b7d5                	j	80002b4e <bread+0xb8>

0000000080002b6c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002b6c:	1101                	addi	sp,sp,-32
    80002b6e:	ec06                	sd	ra,24(sp)
    80002b70:	e822                	sd	s0,16(sp)
    80002b72:	e426                	sd	s1,8(sp)
    80002b74:	1000                	addi	s0,sp,32
    80002b76:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002b78:	0541                	addi	a0,a0,16
    80002b7a:	1f2010ef          	jal	80003d6c <holdingsleep>
    80002b7e:	c911                	beqz	a0,80002b92 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002b80:	4585                	li	a1,1
    80002b82:	8526                	mv	a0,s1
    80002b84:	1cd020ef          	jal	80005550 <virtio_disk_rw>
}
    80002b88:	60e2                	ld	ra,24(sp)
    80002b8a:	6442                	ld	s0,16(sp)
    80002b8c:	64a2                	ld	s1,8(sp)
    80002b8e:	6105                	addi	sp,sp,32
    80002b90:	8082                	ret
    panic("bwrite");
    80002b92:	00005517          	auipc	a0,0x5
    80002b96:	8c650513          	addi	a0,a0,-1850 # 80007458 <etext+0x458>
    80002b9a:	c09fd0ef          	jal	800007a2 <panic>

0000000080002b9e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002b9e:	1101                	addi	sp,sp,-32
    80002ba0:	ec06                	sd	ra,24(sp)
    80002ba2:	e822                	sd	s0,16(sp)
    80002ba4:	e426                	sd	s1,8(sp)
    80002ba6:	e04a                	sd	s2,0(sp)
    80002ba8:	1000                	addi	s0,sp,32
    80002baa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002bac:	01050913          	addi	s2,a0,16
    80002bb0:	854a                	mv	a0,s2
    80002bb2:	1ba010ef          	jal	80003d6c <holdingsleep>
    80002bb6:	c135                	beqz	a0,80002c1a <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002bb8:	854a                	mv	a0,s2
    80002bba:	17a010ef          	jal	80003d34 <releasesleep>

  acquire(&bcache.lock);
    80002bbe:	00015517          	auipc	a0,0x15
    80002bc2:	5fa50513          	addi	a0,a0,1530 # 800181b8 <bcache>
    80002bc6:	83cfe0ef          	jal	80000c02 <acquire>
  b->refcnt--;
    80002bca:	40bc                	lw	a5,64(s1)
    80002bcc:	37fd                	addiw	a5,a5,-1
    80002bce:	0007871b          	sext.w	a4,a5
    80002bd2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002bd4:	e71d                	bnez	a4,80002c02 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002bd6:	68b8                	ld	a4,80(s1)
    80002bd8:	64bc                	ld	a5,72(s1)
    80002bda:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002bdc:	68b8                	ld	a4,80(s1)
    80002bde:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002be0:	0001d797          	auipc	a5,0x1d
    80002be4:	5d878793          	addi	a5,a5,1496 # 800201b8 <bcache+0x8000>
    80002be8:	2b87b703          	ld	a4,696(a5)
    80002bec:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002bee:	0001e717          	auipc	a4,0x1e
    80002bf2:	83270713          	addi	a4,a4,-1998 # 80020420 <bcache+0x8268>
    80002bf6:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002bf8:	2b87b703          	ld	a4,696(a5)
    80002bfc:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002bfe:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002c02:	00015517          	auipc	a0,0x15
    80002c06:	5b650513          	addi	a0,a0,1462 # 800181b8 <bcache>
    80002c0a:	890fe0ef          	jal	80000c9a <release>
}
    80002c0e:	60e2                	ld	ra,24(sp)
    80002c10:	6442                	ld	s0,16(sp)
    80002c12:	64a2                	ld	s1,8(sp)
    80002c14:	6902                	ld	s2,0(sp)
    80002c16:	6105                	addi	sp,sp,32
    80002c18:	8082                	ret
    panic("brelse");
    80002c1a:	00005517          	auipc	a0,0x5
    80002c1e:	84650513          	addi	a0,a0,-1978 # 80007460 <etext+0x460>
    80002c22:	b81fd0ef          	jal	800007a2 <panic>

0000000080002c26 <bpin>:

void
bpin(struct buf *b) {
    80002c26:	1101                	addi	sp,sp,-32
    80002c28:	ec06                	sd	ra,24(sp)
    80002c2a:	e822                	sd	s0,16(sp)
    80002c2c:	e426                	sd	s1,8(sp)
    80002c2e:	1000                	addi	s0,sp,32
    80002c30:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002c32:	00015517          	auipc	a0,0x15
    80002c36:	58650513          	addi	a0,a0,1414 # 800181b8 <bcache>
    80002c3a:	fc9fd0ef          	jal	80000c02 <acquire>
  b->refcnt++;
    80002c3e:	40bc                	lw	a5,64(s1)
    80002c40:	2785                	addiw	a5,a5,1
    80002c42:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002c44:	00015517          	auipc	a0,0x15
    80002c48:	57450513          	addi	a0,a0,1396 # 800181b8 <bcache>
    80002c4c:	84efe0ef          	jal	80000c9a <release>
}
    80002c50:	60e2                	ld	ra,24(sp)
    80002c52:	6442                	ld	s0,16(sp)
    80002c54:	64a2                	ld	s1,8(sp)
    80002c56:	6105                	addi	sp,sp,32
    80002c58:	8082                	ret

0000000080002c5a <bunpin>:

void
bunpin(struct buf *b) {
    80002c5a:	1101                	addi	sp,sp,-32
    80002c5c:	ec06                	sd	ra,24(sp)
    80002c5e:	e822                	sd	s0,16(sp)
    80002c60:	e426                	sd	s1,8(sp)
    80002c62:	1000                	addi	s0,sp,32
    80002c64:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002c66:	00015517          	auipc	a0,0x15
    80002c6a:	55250513          	addi	a0,a0,1362 # 800181b8 <bcache>
    80002c6e:	f95fd0ef          	jal	80000c02 <acquire>
  b->refcnt--;
    80002c72:	40bc                	lw	a5,64(s1)
    80002c74:	37fd                	addiw	a5,a5,-1
    80002c76:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002c78:	00015517          	auipc	a0,0x15
    80002c7c:	54050513          	addi	a0,a0,1344 # 800181b8 <bcache>
    80002c80:	81afe0ef          	jal	80000c9a <release>
}
    80002c84:	60e2                	ld	ra,24(sp)
    80002c86:	6442                	ld	s0,16(sp)
    80002c88:	64a2                	ld	s1,8(sp)
    80002c8a:	6105                	addi	sp,sp,32
    80002c8c:	8082                	ret

0000000080002c8e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002c8e:	1101                	addi	sp,sp,-32
    80002c90:	ec06                	sd	ra,24(sp)
    80002c92:	e822                	sd	s0,16(sp)
    80002c94:	e426                	sd	s1,8(sp)
    80002c96:	e04a                	sd	s2,0(sp)
    80002c98:	1000                	addi	s0,sp,32
    80002c9a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002c9c:	00d5d59b          	srliw	a1,a1,0xd
    80002ca0:	0001e797          	auipc	a5,0x1e
    80002ca4:	bf47a783          	lw	a5,-1036(a5) # 80020894 <sb+0x1c>
    80002ca8:	9dbd                	addw	a1,a1,a5
    80002caa:	dedff0ef          	jal	80002a96 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002cae:	0074f713          	andi	a4,s1,7
    80002cb2:	4785                	li	a5,1
    80002cb4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002cb8:	14ce                	slli	s1,s1,0x33
    80002cba:	90d9                	srli	s1,s1,0x36
    80002cbc:	00950733          	add	a4,a0,s1
    80002cc0:	05874703          	lbu	a4,88(a4)
    80002cc4:	00e7f6b3          	and	a3,a5,a4
    80002cc8:	c29d                	beqz	a3,80002cee <bfree+0x60>
    80002cca:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002ccc:	94aa                	add	s1,s1,a0
    80002cce:	fff7c793          	not	a5,a5
    80002cd2:	8f7d                	and	a4,a4,a5
    80002cd4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002cd8:	711000ef          	jal	80003be8 <log_write>
  brelse(bp);
    80002cdc:	854a                	mv	a0,s2
    80002cde:	ec1ff0ef          	jal	80002b9e <brelse>
}
    80002ce2:	60e2                	ld	ra,24(sp)
    80002ce4:	6442                	ld	s0,16(sp)
    80002ce6:	64a2                	ld	s1,8(sp)
    80002ce8:	6902                	ld	s2,0(sp)
    80002cea:	6105                	addi	sp,sp,32
    80002cec:	8082                	ret
    panic("freeing free block");
    80002cee:	00004517          	auipc	a0,0x4
    80002cf2:	77a50513          	addi	a0,a0,1914 # 80007468 <etext+0x468>
    80002cf6:	aadfd0ef          	jal	800007a2 <panic>

0000000080002cfa <balloc>:
{
    80002cfa:	711d                	addi	sp,sp,-96
    80002cfc:	ec86                	sd	ra,88(sp)
    80002cfe:	e8a2                	sd	s0,80(sp)
    80002d00:	e4a6                	sd	s1,72(sp)
    80002d02:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002d04:	0001e797          	auipc	a5,0x1e
    80002d08:	b787a783          	lw	a5,-1160(a5) # 8002087c <sb+0x4>
    80002d0c:	0e078f63          	beqz	a5,80002e0a <balloc+0x110>
    80002d10:	e0ca                	sd	s2,64(sp)
    80002d12:	fc4e                	sd	s3,56(sp)
    80002d14:	f852                	sd	s4,48(sp)
    80002d16:	f456                	sd	s5,40(sp)
    80002d18:	f05a                	sd	s6,32(sp)
    80002d1a:	ec5e                	sd	s7,24(sp)
    80002d1c:	e862                	sd	s8,16(sp)
    80002d1e:	e466                	sd	s9,8(sp)
    80002d20:	8baa                	mv	s7,a0
    80002d22:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002d24:	0001eb17          	auipc	s6,0x1e
    80002d28:	b54b0b13          	addi	s6,s6,-1196 # 80020878 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002d2c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002d2e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002d30:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002d32:	6c89                	lui	s9,0x2
    80002d34:	a0b5                	j	80002da0 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002d36:	97ca                	add	a5,a5,s2
    80002d38:	8e55                	or	a2,a2,a3
    80002d3a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002d3e:	854a                	mv	a0,s2
    80002d40:	6a9000ef          	jal	80003be8 <log_write>
        brelse(bp);
    80002d44:	854a                	mv	a0,s2
    80002d46:	e59ff0ef          	jal	80002b9e <brelse>
  bp = bread(dev, bno);
    80002d4a:	85a6                	mv	a1,s1
    80002d4c:	855e                	mv	a0,s7
    80002d4e:	d49ff0ef          	jal	80002a96 <bread>
    80002d52:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002d54:	40000613          	li	a2,1024
    80002d58:	4581                	li	a1,0
    80002d5a:	05850513          	addi	a0,a0,88
    80002d5e:	f79fd0ef          	jal	80000cd6 <memset>
  log_write(bp);
    80002d62:	854a                	mv	a0,s2
    80002d64:	685000ef          	jal	80003be8 <log_write>
  brelse(bp);
    80002d68:	854a                	mv	a0,s2
    80002d6a:	e35ff0ef          	jal	80002b9e <brelse>
}
    80002d6e:	6906                	ld	s2,64(sp)
    80002d70:	79e2                	ld	s3,56(sp)
    80002d72:	7a42                	ld	s4,48(sp)
    80002d74:	7aa2                	ld	s5,40(sp)
    80002d76:	7b02                	ld	s6,32(sp)
    80002d78:	6be2                	ld	s7,24(sp)
    80002d7a:	6c42                	ld	s8,16(sp)
    80002d7c:	6ca2                	ld	s9,8(sp)
}
    80002d7e:	8526                	mv	a0,s1
    80002d80:	60e6                	ld	ra,88(sp)
    80002d82:	6446                	ld	s0,80(sp)
    80002d84:	64a6                	ld	s1,72(sp)
    80002d86:	6125                	addi	sp,sp,96
    80002d88:	8082                	ret
    brelse(bp);
    80002d8a:	854a                	mv	a0,s2
    80002d8c:	e13ff0ef          	jal	80002b9e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002d90:	015c87bb          	addw	a5,s9,s5
    80002d94:	00078a9b          	sext.w	s5,a5
    80002d98:	004b2703          	lw	a4,4(s6)
    80002d9c:	04eaff63          	bgeu	s5,a4,80002dfa <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002da0:	41fad79b          	sraiw	a5,s5,0x1f
    80002da4:	0137d79b          	srliw	a5,a5,0x13
    80002da8:	015787bb          	addw	a5,a5,s5
    80002dac:	40d7d79b          	sraiw	a5,a5,0xd
    80002db0:	01cb2583          	lw	a1,28(s6)
    80002db4:	9dbd                	addw	a1,a1,a5
    80002db6:	855e                	mv	a0,s7
    80002db8:	cdfff0ef          	jal	80002a96 <bread>
    80002dbc:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002dbe:	004b2503          	lw	a0,4(s6)
    80002dc2:	000a849b          	sext.w	s1,s5
    80002dc6:	8762                	mv	a4,s8
    80002dc8:	fca4f1e3          	bgeu	s1,a0,80002d8a <balloc+0x90>
      m = 1 << (bi % 8);
    80002dcc:	00777693          	andi	a3,a4,7
    80002dd0:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002dd4:	41f7579b          	sraiw	a5,a4,0x1f
    80002dd8:	01d7d79b          	srliw	a5,a5,0x1d
    80002ddc:	9fb9                	addw	a5,a5,a4
    80002dde:	4037d79b          	sraiw	a5,a5,0x3
    80002de2:	00f90633          	add	a2,s2,a5
    80002de6:	05864603          	lbu	a2,88(a2)
    80002dea:	00c6f5b3          	and	a1,a3,a2
    80002dee:	d5a1                	beqz	a1,80002d36 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002df0:	2705                	addiw	a4,a4,1
    80002df2:	2485                	addiw	s1,s1,1
    80002df4:	fd471ae3          	bne	a4,s4,80002dc8 <balloc+0xce>
    80002df8:	bf49                	j	80002d8a <balloc+0x90>
    80002dfa:	6906                	ld	s2,64(sp)
    80002dfc:	79e2                	ld	s3,56(sp)
    80002dfe:	7a42                	ld	s4,48(sp)
    80002e00:	7aa2                	ld	s5,40(sp)
    80002e02:	7b02                	ld	s6,32(sp)
    80002e04:	6be2                	ld	s7,24(sp)
    80002e06:	6c42                	ld	s8,16(sp)
    80002e08:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002e0a:	00004517          	auipc	a0,0x4
    80002e0e:	67650513          	addi	a0,a0,1654 # 80007480 <etext+0x480>
    80002e12:	ebefd0ef          	jal	800004d0 <printf>
  return 0;
    80002e16:	4481                	li	s1,0
    80002e18:	b79d                	j	80002d7e <balloc+0x84>

0000000080002e1a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002e1a:	7179                	addi	sp,sp,-48
    80002e1c:	f406                	sd	ra,40(sp)
    80002e1e:	f022                	sd	s0,32(sp)
    80002e20:	ec26                	sd	s1,24(sp)
    80002e22:	e84a                	sd	s2,16(sp)
    80002e24:	e44e                	sd	s3,8(sp)
    80002e26:	1800                	addi	s0,sp,48
    80002e28:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002e2a:	47ad                	li	a5,11
    80002e2c:	02b7e663          	bltu	a5,a1,80002e58 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002e30:	02059793          	slli	a5,a1,0x20
    80002e34:	01e7d593          	srli	a1,a5,0x1e
    80002e38:	00b504b3          	add	s1,a0,a1
    80002e3c:	0504a903          	lw	s2,80(s1)
    80002e40:	06091a63          	bnez	s2,80002eb4 <bmap+0x9a>
      addr = balloc(ip->dev);
    80002e44:	4108                	lw	a0,0(a0)
    80002e46:	eb5ff0ef          	jal	80002cfa <balloc>
    80002e4a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002e4e:	06090363          	beqz	s2,80002eb4 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002e52:	0524a823          	sw	s2,80(s1)
    80002e56:	a8b9                	j	80002eb4 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002e58:	ff45849b          	addiw	s1,a1,-12
    80002e5c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002e60:	0ff00793          	li	a5,255
    80002e64:	06e7ee63          	bltu	a5,a4,80002ee0 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002e68:	08052903          	lw	s2,128(a0)
    80002e6c:	00091d63          	bnez	s2,80002e86 <bmap+0x6c>
      addr = balloc(ip->dev);
    80002e70:	4108                	lw	a0,0(a0)
    80002e72:	e89ff0ef          	jal	80002cfa <balloc>
    80002e76:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002e7a:	02090d63          	beqz	s2,80002eb4 <bmap+0x9a>
    80002e7e:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002e80:	0929a023          	sw	s2,128(s3)
    80002e84:	a011                	j	80002e88 <bmap+0x6e>
    80002e86:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002e88:	85ca                	mv	a1,s2
    80002e8a:	0009a503          	lw	a0,0(s3)
    80002e8e:	c09ff0ef          	jal	80002a96 <bread>
    80002e92:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002e94:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002e98:	02049713          	slli	a4,s1,0x20
    80002e9c:	01e75593          	srli	a1,a4,0x1e
    80002ea0:	00b784b3          	add	s1,a5,a1
    80002ea4:	0004a903          	lw	s2,0(s1)
    80002ea8:	00090e63          	beqz	s2,80002ec4 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002eac:	8552                	mv	a0,s4
    80002eae:	cf1ff0ef          	jal	80002b9e <brelse>
    return addr;
    80002eb2:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002eb4:	854a                	mv	a0,s2
    80002eb6:	70a2                	ld	ra,40(sp)
    80002eb8:	7402                	ld	s0,32(sp)
    80002eba:	64e2                	ld	s1,24(sp)
    80002ebc:	6942                	ld	s2,16(sp)
    80002ebe:	69a2                	ld	s3,8(sp)
    80002ec0:	6145                	addi	sp,sp,48
    80002ec2:	8082                	ret
      addr = balloc(ip->dev);
    80002ec4:	0009a503          	lw	a0,0(s3)
    80002ec8:	e33ff0ef          	jal	80002cfa <balloc>
    80002ecc:	0005091b          	sext.w	s2,a0
      if(addr){
    80002ed0:	fc090ee3          	beqz	s2,80002eac <bmap+0x92>
        a[bn] = addr;
    80002ed4:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002ed8:	8552                	mv	a0,s4
    80002eda:	50f000ef          	jal	80003be8 <log_write>
    80002ede:	b7f9                	j	80002eac <bmap+0x92>
    80002ee0:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002ee2:	00004517          	auipc	a0,0x4
    80002ee6:	5b650513          	addi	a0,a0,1462 # 80007498 <etext+0x498>
    80002eea:	8b9fd0ef          	jal	800007a2 <panic>

0000000080002eee <iget>:
{
    80002eee:	7179                	addi	sp,sp,-48
    80002ef0:	f406                	sd	ra,40(sp)
    80002ef2:	f022                	sd	s0,32(sp)
    80002ef4:	ec26                	sd	s1,24(sp)
    80002ef6:	e84a                	sd	s2,16(sp)
    80002ef8:	e44e                	sd	s3,8(sp)
    80002efa:	e052                	sd	s4,0(sp)
    80002efc:	1800                	addi	s0,sp,48
    80002efe:	89aa                	mv	s3,a0
    80002f00:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002f02:	0001e517          	auipc	a0,0x1e
    80002f06:	99650513          	addi	a0,a0,-1642 # 80020898 <itable>
    80002f0a:	cf9fd0ef          	jal	80000c02 <acquire>
  empty = 0;
    80002f0e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002f10:	0001e497          	auipc	s1,0x1e
    80002f14:	9a048493          	addi	s1,s1,-1632 # 800208b0 <itable+0x18>
    80002f18:	0001f697          	auipc	a3,0x1f
    80002f1c:	42868693          	addi	a3,a3,1064 # 80022340 <log>
    80002f20:	a039                	j	80002f2e <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002f22:	02090963          	beqz	s2,80002f54 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002f26:	08848493          	addi	s1,s1,136
    80002f2a:	02d48863          	beq	s1,a3,80002f5a <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002f2e:	449c                	lw	a5,8(s1)
    80002f30:	fef059e3          	blez	a5,80002f22 <iget+0x34>
    80002f34:	4098                	lw	a4,0(s1)
    80002f36:	ff3716e3          	bne	a4,s3,80002f22 <iget+0x34>
    80002f3a:	40d8                	lw	a4,4(s1)
    80002f3c:	ff4713e3          	bne	a4,s4,80002f22 <iget+0x34>
      ip->ref++;
    80002f40:	2785                	addiw	a5,a5,1
    80002f42:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002f44:	0001e517          	auipc	a0,0x1e
    80002f48:	95450513          	addi	a0,a0,-1708 # 80020898 <itable>
    80002f4c:	d4ffd0ef          	jal	80000c9a <release>
      return ip;
    80002f50:	8926                	mv	s2,s1
    80002f52:	a02d                	j	80002f7c <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002f54:	fbe9                	bnez	a5,80002f26 <iget+0x38>
      empty = ip;
    80002f56:	8926                	mv	s2,s1
    80002f58:	b7f9                	j	80002f26 <iget+0x38>
  if(empty == 0)
    80002f5a:	02090a63          	beqz	s2,80002f8e <iget+0xa0>
  ip->dev = dev;
    80002f5e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002f62:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002f66:	4785                	li	a5,1
    80002f68:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002f6c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002f70:	0001e517          	auipc	a0,0x1e
    80002f74:	92850513          	addi	a0,a0,-1752 # 80020898 <itable>
    80002f78:	d23fd0ef          	jal	80000c9a <release>
}
    80002f7c:	854a                	mv	a0,s2
    80002f7e:	70a2                	ld	ra,40(sp)
    80002f80:	7402                	ld	s0,32(sp)
    80002f82:	64e2                	ld	s1,24(sp)
    80002f84:	6942                	ld	s2,16(sp)
    80002f86:	69a2                	ld	s3,8(sp)
    80002f88:	6a02                	ld	s4,0(sp)
    80002f8a:	6145                	addi	sp,sp,48
    80002f8c:	8082                	ret
    panic("iget: no inodes");
    80002f8e:	00004517          	auipc	a0,0x4
    80002f92:	52250513          	addi	a0,a0,1314 # 800074b0 <etext+0x4b0>
    80002f96:	80dfd0ef          	jal	800007a2 <panic>

0000000080002f9a <fsinit>:
fsinit(int dev) {
    80002f9a:	7179                	addi	sp,sp,-48
    80002f9c:	f406                	sd	ra,40(sp)
    80002f9e:	f022                	sd	s0,32(sp)
    80002fa0:	ec26                	sd	s1,24(sp)
    80002fa2:	e84a                	sd	s2,16(sp)
    80002fa4:	e44e                	sd	s3,8(sp)
    80002fa6:	1800                	addi	s0,sp,48
    80002fa8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002faa:	4585                	li	a1,1
    80002fac:	aebff0ef          	jal	80002a96 <bread>
    80002fb0:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002fb2:	0001e997          	auipc	s3,0x1e
    80002fb6:	8c698993          	addi	s3,s3,-1850 # 80020878 <sb>
    80002fba:	02000613          	li	a2,32
    80002fbe:	05850593          	addi	a1,a0,88
    80002fc2:	854e                	mv	a0,s3
    80002fc4:	d6ffd0ef          	jal	80000d32 <memmove>
  brelse(bp);
    80002fc8:	8526                	mv	a0,s1
    80002fca:	bd5ff0ef          	jal	80002b9e <brelse>
  if(sb.magic != FSMAGIC)
    80002fce:	0009a703          	lw	a4,0(s3)
    80002fd2:	102037b7          	lui	a5,0x10203
    80002fd6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002fda:	02f71063          	bne	a4,a5,80002ffa <fsinit+0x60>
  initlog(dev, &sb);
    80002fde:	0001e597          	auipc	a1,0x1e
    80002fe2:	89a58593          	addi	a1,a1,-1894 # 80020878 <sb>
    80002fe6:	854a                	mv	a0,s2
    80002fe8:	1f9000ef          	jal	800039e0 <initlog>
}
    80002fec:	70a2                	ld	ra,40(sp)
    80002fee:	7402                	ld	s0,32(sp)
    80002ff0:	64e2                	ld	s1,24(sp)
    80002ff2:	6942                	ld	s2,16(sp)
    80002ff4:	69a2                	ld	s3,8(sp)
    80002ff6:	6145                	addi	sp,sp,48
    80002ff8:	8082                	ret
    panic("invalid file system");
    80002ffa:	00004517          	auipc	a0,0x4
    80002ffe:	4c650513          	addi	a0,a0,1222 # 800074c0 <etext+0x4c0>
    80003002:	fa0fd0ef          	jal	800007a2 <panic>

0000000080003006 <iinit>:
{
    80003006:	7179                	addi	sp,sp,-48
    80003008:	f406                	sd	ra,40(sp)
    8000300a:	f022                	sd	s0,32(sp)
    8000300c:	ec26                	sd	s1,24(sp)
    8000300e:	e84a                	sd	s2,16(sp)
    80003010:	e44e                	sd	s3,8(sp)
    80003012:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003014:	00004597          	auipc	a1,0x4
    80003018:	4c458593          	addi	a1,a1,1220 # 800074d8 <etext+0x4d8>
    8000301c:	0001e517          	auipc	a0,0x1e
    80003020:	87c50513          	addi	a0,a0,-1924 # 80020898 <itable>
    80003024:	b5ffd0ef          	jal	80000b82 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003028:	0001e497          	auipc	s1,0x1e
    8000302c:	89848493          	addi	s1,s1,-1896 # 800208c0 <itable+0x28>
    80003030:	0001f997          	auipc	s3,0x1f
    80003034:	32098993          	addi	s3,s3,800 # 80022350 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003038:	00004917          	auipc	s2,0x4
    8000303c:	4a890913          	addi	s2,s2,1192 # 800074e0 <etext+0x4e0>
    80003040:	85ca                	mv	a1,s2
    80003042:	8526                	mv	a0,s1
    80003044:	475000ef          	jal	80003cb8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003048:	08848493          	addi	s1,s1,136
    8000304c:	ff349ae3          	bne	s1,s3,80003040 <iinit+0x3a>
}
    80003050:	70a2                	ld	ra,40(sp)
    80003052:	7402                	ld	s0,32(sp)
    80003054:	64e2                	ld	s1,24(sp)
    80003056:	6942                	ld	s2,16(sp)
    80003058:	69a2                	ld	s3,8(sp)
    8000305a:	6145                	addi	sp,sp,48
    8000305c:	8082                	ret

000000008000305e <ialloc>:
{
    8000305e:	7139                	addi	sp,sp,-64
    80003060:	fc06                	sd	ra,56(sp)
    80003062:	f822                	sd	s0,48(sp)
    80003064:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003066:	0001e717          	auipc	a4,0x1e
    8000306a:	81e72703          	lw	a4,-2018(a4) # 80020884 <sb+0xc>
    8000306e:	4785                	li	a5,1
    80003070:	06e7f063          	bgeu	a5,a4,800030d0 <ialloc+0x72>
    80003074:	f426                	sd	s1,40(sp)
    80003076:	f04a                	sd	s2,32(sp)
    80003078:	ec4e                	sd	s3,24(sp)
    8000307a:	e852                	sd	s4,16(sp)
    8000307c:	e456                	sd	s5,8(sp)
    8000307e:	e05a                	sd	s6,0(sp)
    80003080:	8aaa                	mv	s5,a0
    80003082:	8b2e                	mv	s6,a1
    80003084:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003086:	0001da17          	auipc	s4,0x1d
    8000308a:	7f2a0a13          	addi	s4,s4,2034 # 80020878 <sb>
    8000308e:	00495593          	srli	a1,s2,0x4
    80003092:	018a2783          	lw	a5,24(s4)
    80003096:	9dbd                	addw	a1,a1,a5
    80003098:	8556                	mv	a0,s5
    8000309a:	9fdff0ef          	jal	80002a96 <bread>
    8000309e:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800030a0:	05850993          	addi	s3,a0,88
    800030a4:	00f97793          	andi	a5,s2,15
    800030a8:	079a                	slli	a5,a5,0x6
    800030aa:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800030ac:	00099783          	lh	a5,0(s3)
    800030b0:	cb9d                	beqz	a5,800030e6 <ialloc+0x88>
    brelse(bp);
    800030b2:	aedff0ef          	jal	80002b9e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800030b6:	0905                	addi	s2,s2,1
    800030b8:	00ca2703          	lw	a4,12(s4)
    800030bc:	0009079b          	sext.w	a5,s2
    800030c0:	fce7e7e3          	bltu	a5,a4,8000308e <ialloc+0x30>
    800030c4:	74a2                	ld	s1,40(sp)
    800030c6:	7902                	ld	s2,32(sp)
    800030c8:	69e2                	ld	s3,24(sp)
    800030ca:	6a42                	ld	s4,16(sp)
    800030cc:	6aa2                	ld	s5,8(sp)
    800030ce:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800030d0:	00004517          	auipc	a0,0x4
    800030d4:	41850513          	addi	a0,a0,1048 # 800074e8 <etext+0x4e8>
    800030d8:	bf8fd0ef          	jal	800004d0 <printf>
  return 0;
    800030dc:	4501                	li	a0,0
}
    800030de:	70e2                	ld	ra,56(sp)
    800030e0:	7442                	ld	s0,48(sp)
    800030e2:	6121                	addi	sp,sp,64
    800030e4:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800030e6:	04000613          	li	a2,64
    800030ea:	4581                	li	a1,0
    800030ec:	854e                	mv	a0,s3
    800030ee:	be9fd0ef          	jal	80000cd6 <memset>
      dip->type = type;
    800030f2:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800030f6:	8526                	mv	a0,s1
    800030f8:	2f1000ef          	jal	80003be8 <log_write>
      brelse(bp);
    800030fc:	8526                	mv	a0,s1
    800030fe:	aa1ff0ef          	jal	80002b9e <brelse>
      return iget(dev, inum);
    80003102:	0009059b          	sext.w	a1,s2
    80003106:	8556                	mv	a0,s5
    80003108:	de7ff0ef          	jal	80002eee <iget>
    8000310c:	74a2                	ld	s1,40(sp)
    8000310e:	7902                	ld	s2,32(sp)
    80003110:	69e2                	ld	s3,24(sp)
    80003112:	6a42                	ld	s4,16(sp)
    80003114:	6aa2                	ld	s5,8(sp)
    80003116:	6b02                	ld	s6,0(sp)
    80003118:	b7d9                	j	800030de <ialloc+0x80>

000000008000311a <iupdate>:
{
    8000311a:	1101                	addi	sp,sp,-32
    8000311c:	ec06                	sd	ra,24(sp)
    8000311e:	e822                	sd	s0,16(sp)
    80003120:	e426                	sd	s1,8(sp)
    80003122:	e04a                	sd	s2,0(sp)
    80003124:	1000                	addi	s0,sp,32
    80003126:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003128:	415c                	lw	a5,4(a0)
    8000312a:	0047d79b          	srliw	a5,a5,0x4
    8000312e:	0001d597          	auipc	a1,0x1d
    80003132:	7625a583          	lw	a1,1890(a1) # 80020890 <sb+0x18>
    80003136:	9dbd                	addw	a1,a1,a5
    80003138:	4108                	lw	a0,0(a0)
    8000313a:	95dff0ef          	jal	80002a96 <bread>
    8000313e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003140:	05850793          	addi	a5,a0,88
    80003144:	40d8                	lw	a4,4(s1)
    80003146:	8b3d                	andi	a4,a4,15
    80003148:	071a                	slli	a4,a4,0x6
    8000314a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000314c:	04449703          	lh	a4,68(s1)
    80003150:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003154:	04649703          	lh	a4,70(s1)
    80003158:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000315c:	04849703          	lh	a4,72(s1)
    80003160:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003164:	04a49703          	lh	a4,74(s1)
    80003168:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000316c:	44f8                	lw	a4,76(s1)
    8000316e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003170:	03400613          	li	a2,52
    80003174:	05048593          	addi	a1,s1,80
    80003178:	00c78513          	addi	a0,a5,12
    8000317c:	bb7fd0ef          	jal	80000d32 <memmove>
  log_write(bp);
    80003180:	854a                	mv	a0,s2
    80003182:	267000ef          	jal	80003be8 <log_write>
  brelse(bp);
    80003186:	854a                	mv	a0,s2
    80003188:	a17ff0ef          	jal	80002b9e <brelse>
}
    8000318c:	60e2                	ld	ra,24(sp)
    8000318e:	6442                	ld	s0,16(sp)
    80003190:	64a2                	ld	s1,8(sp)
    80003192:	6902                	ld	s2,0(sp)
    80003194:	6105                	addi	sp,sp,32
    80003196:	8082                	ret

0000000080003198 <idup>:
{
    80003198:	1101                	addi	sp,sp,-32
    8000319a:	ec06                	sd	ra,24(sp)
    8000319c:	e822                	sd	s0,16(sp)
    8000319e:	e426                	sd	s1,8(sp)
    800031a0:	1000                	addi	s0,sp,32
    800031a2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800031a4:	0001d517          	auipc	a0,0x1d
    800031a8:	6f450513          	addi	a0,a0,1780 # 80020898 <itable>
    800031ac:	a57fd0ef          	jal	80000c02 <acquire>
  ip->ref++;
    800031b0:	449c                	lw	a5,8(s1)
    800031b2:	2785                	addiw	a5,a5,1
    800031b4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800031b6:	0001d517          	auipc	a0,0x1d
    800031ba:	6e250513          	addi	a0,a0,1762 # 80020898 <itable>
    800031be:	addfd0ef          	jal	80000c9a <release>
}
    800031c2:	8526                	mv	a0,s1
    800031c4:	60e2                	ld	ra,24(sp)
    800031c6:	6442                	ld	s0,16(sp)
    800031c8:	64a2                	ld	s1,8(sp)
    800031ca:	6105                	addi	sp,sp,32
    800031cc:	8082                	ret

00000000800031ce <ilock>:
{
    800031ce:	1101                	addi	sp,sp,-32
    800031d0:	ec06                	sd	ra,24(sp)
    800031d2:	e822                	sd	s0,16(sp)
    800031d4:	e426                	sd	s1,8(sp)
    800031d6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800031d8:	cd19                	beqz	a0,800031f6 <ilock+0x28>
    800031da:	84aa                	mv	s1,a0
    800031dc:	451c                	lw	a5,8(a0)
    800031de:	00f05c63          	blez	a5,800031f6 <ilock+0x28>
  acquiresleep(&ip->lock);
    800031e2:	0541                	addi	a0,a0,16
    800031e4:	30b000ef          	jal	80003cee <acquiresleep>
  if(ip->valid == 0){
    800031e8:	40bc                	lw	a5,64(s1)
    800031ea:	cf89                	beqz	a5,80003204 <ilock+0x36>
}
    800031ec:	60e2                	ld	ra,24(sp)
    800031ee:	6442                	ld	s0,16(sp)
    800031f0:	64a2                	ld	s1,8(sp)
    800031f2:	6105                	addi	sp,sp,32
    800031f4:	8082                	ret
    800031f6:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800031f8:	00004517          	auipc	a0,0x4
    800031fc:	30850513          	addi	a0,a0,776 # 80007500 <etext+0x500>
    80003200:	da2fd0ef          	jal	800007a2 <panic>
    80003204:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003206:	40dc                	lw	a5,4(s1)
    80003208:	0047d79b          	srliw	a5,a5,0x4
    8000320c:	0001d597          	auipc	a1,0x1d
    80003210:	6845a583          	lw	a1,1668(a1) # 80020890 <sb+0x18>
    80003214:	9dbd                	addw	a1,a1,a5
    80003216:	4088                	lw	a0,0(s1)
    80003218:	87fff0ef          	jal	80002a96 <bread>
    8000321c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000321e:	05850593          	addi	a1,a0,88
    80003222:	40dc                	lw	a5,4(s1)
    80003224:	8bbd                	andi	a5,a5,15
    80003226:	079a                	slli	a5,a5,0x6
    80003228:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000322a:	00059783          	lh	a5,0(a1)
    8000322e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003232:	00259783          	lh	a5,2(a1)
    80003236:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000323a:	00459783          	lh	a5,4(a1)
    8000323e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003242:	00659783          	lh	a5,6(a1)
    80003246:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000324a:	459c                	lw	a5,8(a1)
    8000324c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000324e:	03400613          	li	a2,52
    80003252:	05b1                	addi	a1,a1,12
    80003254:	05048513          	addi	a0,s1,80
    80003258:	adbfd0ef          	jal	80000d32 <memmove>
    brelse(bp);
    8000325c:	854a                	mv	a0,s2
    8000325e:	941ff0ef          	jal	80002b9e <brelse>
    ip->valid = 1;
    80003262:	4785                	li	a5,1
    80003264:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003266:	04449783          	lh	a5,68(s1)
    8000326a:	c399                	beqz	a5,80003270 <ilock+0xa2>
    8000326c:	6902                	ld	s2,0(sp)
    8000326e:	bfbd                	j	800031ec <ilock+0x1e>
      panic("ilock: no type");
    80003270:	00004517          	auipc	a0,0x4
    80003274:	29850513          	addi	a0,a0,664 # 80007508 <etext+0x508>
    80003278:	d2afd0ef          	jal	800007a2 <panic>

000000008000327c <iunlock>:
{
    8000327c:	1101                	addi	sp,sp,-32
    8000327e:	ec06                	sd	ra,24(sp)
    80003280:	e822                	sd	s0,16(sp)
    80003282:	e426                	sd	s1,8(sp)
    80003284:	e04a                	sd	s2,0(sp)
    80003286:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003288:	c505                	beqz	a0,800032b0 <iunlock+0x34>
    8000328a:	84aa                	mv	s1,a0
    8000328c:	01050913          	addi	s2,a0,16
    80003290:	854a                	mv	a0,s2
    80003292:	2db000ef          	jal	80003d6c <holdingsleep>
    80003296:	cd09                	beqz	a0,800032b0 <iunlock+0x34>
    80003298:	449c                	lw	a5,8(s1)
    8000329a:	00f05b63          	blez	a5,800032b0 <iunlock+0x34>
  releasesleep(&ip->lock);
    8000329e:	854a                	mv	a0,s2
    800032a0:	295000ef          	jal	80003d34 <releasesleep>
}
    800032a4:	60e2                	ld	ra,24(sp)
    800032a6:	6442                	ld	s0,16(sp)
    800032a8:	64a2                	ld	s1,8(sp)
    800032aa:	6902                	ld	s2,0(sp)
    800032ac:	6105                	addi	sp,sp,32
    800032ae:	8082                	ret
    panic("iunlock");
    800032b0:	00004517          	auipc	a0,0x4
    800032b4:	26850513          	addi	a0,a0,616 # 80007518 <etext+0x518>
    800032b8:	ceafd0ef          	jal	800007a2 <panic>

00000000800032bc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800032bc:	7179                	addi	sp,sp,-48
    800032be:	f406                	sd	ra,40(sp)
    800032c0:	f022                	sd	s0,32(sp)
    800032c2:	ec26                	sd	s1,24(sp)
    800032c4:	e84a                	sd	s2,16(sp)
    800032c6:	e44e                	sd	s3,8(sp)
    800032c8:	1800                	addi	s0,sp,48
    800032ca:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800032cc:	05050493          	addi	s1,a0,80
    800032d0:	08050913          	addi	s2,a0,128
    800032d4:	a021                	j	800032dc <itrunc+0x20>
    800032d6:	0491                	addi	s1,s1,4
    800032d8:	01248b63          	beq	s1,s2,800032ee <itrunc+0x32>
    if(ip->addrs[i]){
    800032dc:	408c                	lw	a1,0(s1)
    800032de:	dde5                	beqz	a1,800032d6 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800032e0:	0009a503          	lw	a0,0(s3)
    800032e4:	9abff0ef          	jal	80002c8e <bfree>
      ip->addrs[i] = 0;
    800032e8:	0004a023          	sw	zero,0(s1)
    800032ec:	b7ed                	j	800032d6 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800032ee:	0809a583          	lw	a1,128(s3)
    800032f2:	ed89                	bnez	a1,8000330c <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800032f4:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800032f8:	854e                	mv	a0,s3
    800032fa:	e21ff0ef          	jal	8000311a <iupdate>
}
    800032fe:	70a2                	ld	ra,40(sp)
    80003300:	7402                	ld	s0,32(sp)
    80003302:	64e2                	ld	s1,24(sp)
    80003304:	6942                	ld	s2,16(sp)
    80003306:	69a2                	ld	s3,8(sp)
    80003308:	6145                	addi	sp,sp,48
    8000330a:	8082                	ret
    8000330c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000330e:	0009a503          	lw	a0,0(s3)
    80003312:	f84ff0ef          	jal	80002a96 <bread>
    80003316:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003318:	05850493          	addi	s1,a0,88
    8000331c:	45850913          	addi	s2,a0,1112
    80003320:	a021                	j	80003328 <itrunc+0x6c>
    80003322:	0491                	addi	s1,s1,4
    80003324:	01248963          	beq	s1,s2,80003336 <itrunc+0x7a>
      if(a[j])
    80003328:	408c                	lw	a1,0(s1)
    8000332a:	dde5                	beqz	a1,80003322 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000332c:	0009a503          	lw	a0,0(s3)
    80003330:	95fff0ef          	jal	80002c8e <bfree>
    80003334:	b7fd                	j	80003322 <itrunc+0x66>
    brelse(bp);
    80003336:	8552                	mv	a0,s4
    80003338:	867ff0ef          	jal	80002b9e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000333c:	0809a583          	lw	a1,128(s3)
    80003340:	0009a503          	lw	a0,0(s3)
    80003344:	94bff0ef          	jal	80002c8e <bfree>
    ip->addrs[NDIRECT] = 0;
    80003348:	0809a023          	sw	zero,128(s3)
    8000334c:	6a02                	ld	s4,0(sp)
    8000334e:	b75d                	j	800032f4 <itrunc+0x38>

0000000080003350 <iput>:
{
    80003350:	1101                	addi	sp,sp,-32
    80003352:	ec06                	sd	ra,24(sp)
    80003354:	e822                	sd	s0,16(sp)
    80003356:	e426                	sd	s1,8(sp)
    80003358:	1000                	addi	s0,sp,32
    8000335a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000335c:	0001d517          	auipc	a0,0x1d
    80003360:	53c50513          	addi	a0,a0,1340 # 80020898 <itable>
    80003364:	89ffd0ef          	jal	80000c02 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003368:	4498                	lw	a4,8(s1)
    8000336a:	4785                	li	a5,1
    8000336c:	02f70063          	beq	a4,a5,8000338c <iput+0x3c>
  ip->ref--;
    80003370:	449c                	lw	a5,8(s1)
    80003372:	37fd                	addiw	a5,a5,-1
    80003374:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003376:	0001d517          	auipc	a0,0x1d
    8000337a:	52250513          	addi	a0,a0,1314 # 80020898 <itable>
    8000337e:	91dfd0ef          	jal	80000c9a <release>
}
    80003382:	60e2                	ld	ra,24(sp)
    80003384:	6442                	ld	s0,16(sp)
    80003386:	64a2                	ld	s1,8(sp)
    80003388:	6105                	addi	sp,sp,32
    8000338a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000338c:	40bc                	lw	a5,64(s1)
    8000338e:	d3ed                	beqz	a5,80003370 <iput+0x20>
    80003390:	04a49783          	lh	a5,74(s1)
    80003394:	fff1                	bnez	a5,80003370 <iput+0x20>
    80003396:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003398:	01048913          	addi	s2,s1,16
    8000339c:	854a                	mv	a0,s2
    8000339e:	151000ef          	jal	80003cee <acquiresleep>
    release(&itable.lock);
    800033a2:	0001d517          	auipc	a0,0x1d
    800033a6:	4f650513          	addi	a0,a0,1270 # 80020898 <itable>
    800033aa:	8f1fd0ef          	jal	80000c9a <release>
    itrunc(ip);
    800033ae:	8526                	mv	a0,s1
    800033b0:	f0dff0ef          	jal	800032bc <itrunc>
    ip->type = 0;
    800033b4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800033b8:	8526                	mv	a0,s1
    800033ba:	d61ff0ef          	jal	8000311a <iupdate>
    ip->valid = 0;
    800033be:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800033c2:	854a                	mv	a0,s2
    800033c4:	171000ef          	jal	80003d34 <releasesleep>
    acquire(&itable.lock);
    800033c8:	0001d517          	auipc	a0,0x1d
    800033cc:	4d050513          	addi	a0,a0,1232 # 80020898 <itable>
    800033d0:	833fd0ef          	jal	80000c02 <acquire>
    800033d4:	6902                	ld	s2,0(sp)
    800033d6:	bf69                	j	80003370 <iput+0x20>

00000000800033d8 <iunlockput>:
{
    800033d8:	1101                	addi	sp,sp,-32
    800033da:	ec06                	sd	ra,24(sp)
    800033dc:	e822                	sd	s0,16(sp)
    800033de:	e426                	sd	s1,8(sp)
    800033e0:	1000                	addi	s0,sp,32
    800033e2:	84aa                	mv	s1,a0
  iunlock(ip);
    800033e4:	e99ff0ef          	jal	8000327c <iunlock>
  iput(ip);
    800033e8:	8526                	mv	a0,s1
    800033ea:	f67ff0ef          	jal	80003350 <iput>
}
    800033ee:	60e2                	ld	ra,24(sp)
    800033f0:	6442                	ld	s0,16(sp)
    800033f2:	64a2                	ld	s1,8(sp)
    800033f4:	6105                	addi	sp,sp,32
    800033f6:	8082                	ret

00000000800033f8 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800033f8:	1141                	addi	sp,sp,-16
    800033fa:	e422                	sd	s0,8(sp)
    800033fc:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800033fe:	411c                	lw	a5,0(a0)
    80003400:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003402:	415c                	lw	a5,4(a0)
    80003404:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003406:	04451783          	lh	a5,68(a0)
    8000340a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000340e:	04a51783          	lh	a5,74(a0)
    80003412:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003416:	04c56783          	lwu	a5,76(a0)
    8000341a:	e99c                	sd	a5,16(a1)
}
    8000341c:	6422                	ld	s0,8(sp)
    8000341e:	0141                	addi	sp,sp,16
    80003420:	8082                	ret

0000000080003422 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003422:	457c                	lw	a5,76(a0)
    80003424:	0ed7eb63          	bltu	a5,a3,8000351a <readi+0xf8>
{
    80003428:	7159                	addi	sp,sp,-112
    8000342a:	f486                	sd	ra,104(sp)
    8000342c:	f0a2                	sd	s0,96(sp)
    8000342e:	eca6                	sd	s1,88(sp)
    80003430:	e0d2                	sd	s4,64(sp)
    80003432:	fc56                	sd	s5,56(sp)
    80003434:	f85a                	sd	s6,48(sp)
    80003436:	f45e                	sd	s7,40(sp)
    80003438:	1880                	addi	s0,sp,112
    8000343a:	8b2a                	mv	s6,a0
    8000343c:	8bae                	mv	s7,a1
    8000343e:	8a32                	mv	s4,a2
    80003440:	84b6                	mv	s1,a3
    80003442:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003444:	9f35                	addw	a4,a4,a3
    return 0;
    80003446:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003448:	0cd76063          	bltu	a4,a3,80003508 <readi+0xe6>
    8000344c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000344e:	00e7f463          	bgeu	a5,a4,80003456 <readi+0x34>
    n = ip->size - off;
    80003452:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003456:	080a8f63          	beqz	s5,800034f4 <readi+0xd2>
    8000345a:	e8ca                	sd	s2,80(sp)
    8000345c:	f062                	sd	s8,32(sp)
    8000345e:	ec66                	sd	s9,24(sp)
    80003460:	e86a                	sd	s10,16(sp)
    80003462:	e46e                	sd	s11,8(sp)
    80003464:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003466:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000346a:	5c7d                	li	s8,-1
    8000346c:	a80d                	j	8000349e <readi+0x7c>
    8000346e:	020d1d93          	slli	s11,s10,0x20
    80003472:	020ddd93          	srli	s11,s11,0x20
    80003476:	05890613          	addi	a2,s2,88
    8000347a:	86ee                	mv	a3,s11
    8000347c:	963a                	add	a2,a2,a4
    8000347e:	85d2                	mv	a1,s4
    80003480:	855e                	mv	a0,s7
    80003482:	d97fe0ef          	jal	80002218 <either_copyout>
    80003486:	05850763          	beq	a0,s8,800034d4 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000348a:	854a                	mv	a0,s2
    8000348c:	f12ff0ef          	jal	80002b9e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003490:	013d09bb          	addw	s3,s10,s3
    80003494:	009d04bb          	addw	s1,s10,s1
    80003498:	9a6e                	add	s4,s4,s11
    8000349a:	0559f763          	bgeu	s3,s5,800034e8 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    8000349e:	00a4d59b          	srliw	a1,s1,0xa
    800034a2:	855a                	mv	a0,s6
    800034a4:	977ff0ef          	jal	80002e1a <bmap>
    800034a8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800034ac:	c5b1                	beqz	a1,800034f8 <readi+0xd6>
    bp = bread(ip->dev, addr);
    800034ae:	000b2503          	lw	a0,0(s6)
    800034b2:	de4ff0ef          	jal	80002a96 <bread>
    800034b6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800034b8:	3ff4f713          	andi	a4,s1,1023
    800034bc:	40ec87bb          	subw	a5,s9,a4
    800034c0:	413a86bb          	subw	a3,s5,s3
    800034c4:	8d3e                	mv	s10,a5
    800034c6:	2781                	sext.w	a5,a5
    800034c8:	0006861b          	sext.w	a2,a3
    800034cc:	faf671e3          	bgeu	a2,a5,8000346e <readi+0x4c>
    800034d0:	8d36                	mv	s10,a3
    800034d2:	bf71                	j	8000346e <readi+0x4c>
      brelse(bp);
    800034d4:	854a                	mv	a0,s2
    800034d6:	ec8ff0ef          	jal	80002b9e <brelse>
      tot = -1;
    800034da:	59fd                	li	s3,-1
      break;
    800034dc:	6946                	ld	s2,80(sp)
    800034de:	7c02                	ld	s8,32(sp)
    800034e0:	6ce2                	ld	s9,24(sp)
    800034e2:	6d42                	ld	s10,16(sp)
    800034e4:	6da2                	ld	s11,8(sp)
    800034e6:	a831                	j	80003502 <readi+0xe0>
    800034e8:	6946                	ld	s2,80(sp)
    800034ea:	7c02                	ld	s8,32(sp)
    800034ec:	6ce2                	ld	s9,24(sp)
    800034ee:	6d42                	ld	s10,16(sp)
    800034f0:	6da2                	ld	s11,8(sp)
    800034f2:	a801                	j	80003502 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800034f4:	89d6                	mv	s3,s5
    800034f6:	a031                	j	80003502 <readi+0xe0>
    800034f8:	6946                	ld	s2,80(sp)
    800034fa:	7c02                	ld	s8,32(sp)
    800034fc:	6ce2                	ld	s9,24(sp)
    800034fe:	6d42                	ld	s10,16(sp)
    80003500:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003502:	0009851b          	sext.w	a0,s3
    80003506:	69a6                	ld	s3,72(sp)
}
    80003508:	70a6                	ld	ra,104(sp)
    8000350a:	7406                	ld	s0,96(sp)
    8000350c:	64e6                	ld	s1,88(sp)
    8000350e:	6a06                	ld	s4,64(sp)
    80003510:	7ae2                	ld	s5,56(sp)
    80003512:	7b42                	ld	s6,48(sp)
    80003514:	7ba2                	ld	s7,40(sp)
    80003516:	6165                	addi	sp,sp,112
    80003518:	8082                	ret
    return 0;
    8000351a:	4501                	li	a0,0
}
    8000351c:	8082                	ret

000000008000351e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000351e:	457c                	lw	a5,76(a0)
    80003520:	10d7e063          	bltu	a5,a3,80003620 <writei+0x102>
{
    80003524:	7159                	addi	sp,sp,-112
    80003526:	f486                	sd	ra,104(sp)
    80003528:	f0a2                	sd	s0,96(sp)
    8000352a:	e8ca                	sd	s2,80(sp)
    8000352c:	e0d2                	sd	s4,64(sp)
    8000352e:	fc56                	sd	s5,56(sp)
    80003530:	f85a                	sd	s6,48(sp)
    80003532:	f45e                	sd	s7,40(sp)
    80003534:	1880                	addi	s0,sp,112
    80003536:	8aaa                	mv	s5,a0
    80003538:	8bae                	mv	s7,a1
    8000353a:	8a32                	mv	s4,a2
    8000353c:	8936                	mv	s2,a3
    8000353e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003540:	00e687bb          	addw	a5,a3,a4
    80003544:	0ed7e063          	bltu	a5,a3,80003624 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003548:	00043737          	lui	a4,0x43
    8000354c:	0cf76e63          	bltu	a4,a5,80003628 <writei+0x10a>
    80003550:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003552:	0a0b0f63          	beqz	s6,80003610 <writei+0xf2>
    80003556:	eca6                	sd	s1,88(sp)
    80003558:	f062                	sd	s8,32(sp)
    8000355a:	ec66                	sd	s9,24(sp)
    8000355c:	e86a                	sd	s10,16(sp)
    8000355e:	e46e                	sd	s11,8(sp)
    80003560:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003562:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003566:	5c7d                	li	s8,-1
    80003568:	a825                	j	800035a0 <writei+0x82>
    8000356a:	020d1d93          	slli	s11,s10,0x20
    8000356e:	020ddd93          	srli	s11,s11,0x20
    80003572:	05848513          	addi	a0,s1,88
    80003576:	86ee                	mv	a3,s11
    80003578:	8652                	mv	a2,s4
    8000357a:	85de                	mv	a1,s7
    8000357c:	953a                	add	a0,a0,a4
    8000357e:	ce5fe0ef          	jal	80002262 <either_copyin>
    80003582:	05850a63          	beq	a0,s8,800035d6 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003586:	8526                	mv	a0,s1
    80003588:	660000ef          	jal	80003be8 <log_write>
    brelse(bp);
    8000358c:	8526                	mv	a0,s1
    8000358e:	e10ff0ef          	jal	80002b9e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003592:	013d09bb          	addw	s3,s10,s3
    80003596:	012d093b          	addw	s2,s10,s2
    8000359a:	9a6e                	add	s4,s4,s11
    8000359c:	0569f063          	bgeu	s3,s6,800035dc <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800035a0:	00a9559b          	srliw	a1,s2,0xa
    800035a4:	8556                	mv	a0,s5
    800035a6:	875ff0ef          	jal	80002e1a <bmap>
    800035aa:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800035ae:	c59d                	beqz	a1,800035dc <writei+0xbe>
    bp = bread(ip->dev, addr);
    800035b0:	000aa503          	lw	a0,0(s5)
    800035b4:	ce2ff0ef          	jal	80002a96 <bread>
    800035b8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800035ba:	3ff97713          	andi	a4,s2,1023
    800035be:	40ec87bb          	subw	a5,s9,a4
    800035c2:	413b06bb          	subw	a3,s6,s3
    800035c6:	8d3e                	mv	s10,a5
    800035c8:	2781                	sext.w	a5,a5
    800035ca:	0006861b          	sext.w	a2,a3
    800035ce:	f8f67ee3          	bgeu	a2,a5,8000356a <writei+0x4c>
    800035d2:	8d36                	mv	s10,a3
    800035d4:	bf59                	j	8000356a <writei+0x4c>
      brelse(bp);
    800035d6:	8526                	mv	a0,s1
    800035d8:	dc6ff0ef          	jal	80002b9e <brelse>
  }

  if(off > ip->size)
    800035dc:	04caa783          	lw	a5,76(s5)
    800035e0:	0327fa63          	bgeu	a5,s2,80003614 <writei+0xf6>
    ip->size = off;
    800035e4:	052aa623          	sw	s2,76(s5)
    800035e8:	64e6                	ld	s1,88(sp)
    800035ea:	7c02                	ld	s8,32(sp)
    800035ec:	6ce2                	ld	s9,24(sp)
    800035ee:	6d42                	ld	s10,16(sp)
    800035f0:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800035f2:	8556                	mv	a0,s5
    800035f4:	b27ff0ef          	jal	8000311a <iupdate>

  return tot;
    800035f8:	0009851b          	sext.w	a0,s3
    800035fc:	69a6                	ld	s3,72(sp)
}
    800035fe:	70a6                	ld	ra,104(sp)
    80003600:	7406                	ld	s0,96(sp)
    80003602:	6946                	ld	s2,80(sp)
    80003604:	6a06                	ld	s4,64(sp)
    80003606:	7ae2                	ld	s5,56(sp)
    80003608:	7b42                	ld	s6,48(sp)
    8000360a:	7ba2                	ld	s7,40(sp)
    8000360c:	6165                	addi	sp,sp,112
    8000360e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003610:	89da                	mv	s3,s6
    80003612:	b7c5                	j	800035f2 <writei+0xd4>
    80003614:	64e6                	ld	s1,88(sp)
    80003616:	7c02                	ld	s8,32(sp)
    80003618:	6ce2                	ld	s9,24(sp)
    8000361a:	6d42                	ld	s10,16(sp)
    8000361c:	6da2                	ld	s11,8(sp)
    8000361e:	bfd1                	j	800035f2 <writei+0xd4>
    return -1;
    80003620:	557d                	li	a0,-1
}
    80003622:	8082                	ret
    return -1;
    80003624:	557d                	li	a0,-1
    80003626:	bfe1                	j	800035fe <writei+0xe0>
    return -1;
    80003628:	557d                	li	a0,-1
    8000362a:	bfd1                	j	800035fe <writei+0xe0>

000000008000362c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000362c:	1141                	addi	sp,sp,-16
    8000362e:	e406                	sd	ra,8(sp)
    80003630:	e022                	sd	s0,0(sp)
    80003632:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003634:	4639                	li	a2,14
    80003636:	f6cfd0ef          	jal	80000da2 <strncmp>
}
    8000363a:	60a2                	ld	ra,8(sp)
    8000363c:	6402                	ld	s0,0(sp)
    8000363e:	0141                	addi	sp,sp,16
    80003640:	8082                	ret

0000000080003642 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003642:	7139                	addi	sp,sp,-64
    80003644:	fc06                	sd	ra,56(sp)
    80003646:	f822                	sd	s0,48(sp)
    80003648:	f426                	sd	s1,40(sp)
    8000364a:	f04a                	sd	s2,32(sp)
    8000364c:	ec4e                	sd	s3,24(sp)
    8000364e:	e852                	sd	s4,16(sp)
    80003650:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003652:	04451703          	lh	a4,68(a0)
    80003656:	4785                	li	a5,1
    80003658:	00f71a63          	bne	a4,a5,8000366c <dirlookup+0x2a>
    8000365c:	892a                	mv	s2,a0
    8000365e:	89ae                	mv	s3,a1
    80003660:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003662:	457c                	lw	a5,76(a0)
    80003664:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003666:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003668:	e39d                	bnez	a5,8000368e <dirlookup+0x4c>
    8000366a:	a095                	j	800036ce <dirlookup+0x8c>
    panic("dirlookup not DIR");
    8000366c:	00004517          	auipc	a0,0x4
    80003670:	eb450513          	addi	a0,a0,-332 # 80007520 <etext+0x520>
    80003674:	92efd0ef          	jal	800007a2 <panic>
      panic("dirlookup read");
    80003678:	00004517          	auipc	a0,0x4
    8000367c:	ec050513          	addi	a0,a0,-320 # 80007538 <etext+0x538>
    80003680:	922fd0ef          	jal	800007a2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003684:	24c1                	addiw	s1,s1,16
    80003686:	04c92783          	lw	a5,76(s2)
    8000368a:	04f4f163          	bgeu	s1,a5,800036cc <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000368e:	4741                	li	a4,16
    80003690:	86a6                	mv	a3,s1
    80003692:	fc040613          	addi	a2,s0,-64
    80003696:	4581                	li	a1,0
    80003698:	854a                	mv	a0,s2
    8000369a:	d89ff0ef          	jal	80003422 <readi>
    8000369e:	47c1                	li	a5,16
    800036a0:	fcf51ce3          	bne	a0,a5,80003678 <dirlookup+0x36>
    if(de.inum == 0)
    800036a4:	fc045783          	lhu	a5,-64(s0)
    800036a8:	dff1                	beqz	a5,80003684 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    800036aa:	fc240593          	addi	a1,s0,-62
    800036ae:	854e                	mv	a0,s3
    800036b0:	f7dff0ef          	jal	8000362c <namecmp>
    800036b4:	f961                	bnez	a0,80003684 <dirlookup+0x42>
      if(poff)
    800036b6:	000a0463          	beqz	s4,800036be <dirlookup+0x7c>
        *poff = off;
    800036ba:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800036be:	fc045583          	lhu	a1,-64(s0)
    800036c2:	00092503          	lw	a0,0(s2)
    800036c6:	829ff0ef          	jal	80002eee <iget>
    800036ca:	a011                	j	800036ce <dirlookup+0x8c>
  return 0;
    800036cc:	4501                	li	a0,0
}
    800036ce:	70e2                	ld	ra,56(sp)
    800036d0:	7442                	ld	s0,48(sp)
    800036d2:	74a2                	ld	s1,40(sp)
    800036d4:	7902                	ld	s2,32(sp)
    800036d6:	69e2                	ld	s3,24(sp)
    800036d8:	6a42                	ld	s4,16(sp)
    800036da:	6121                	addi	sp,sp,64
    800036dc:	8082                	ret

00000000800036de <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800036de:	711d                	addi	sp,sp,-96
    800036e0:	ec86                	sd	ra,88(sp)
    800036e2:	e8a2                	sd	s0,80(sp)
    800036e4:	e4a6                	sd	s1,72(sp)
    800036e6:	e0ca                	sd	s2,64(sp)
    800036e8:	fc4e                	sd	s3,56(sp)
    800036ea:	f852                	sd	s4,48(sp)
    800036ec:	f456                	sd	s5,40(sp)
    800036ee:	f05a                	sd	s6,32(sp)
    800036f0:	ec5e                	sd	s7,24(sp)
    800036f2:	e862                	sd	s8,16(sp)
    800036f4:	e466                	sd	s9,8(sp)
    800036f6:	1080                	addi	s0,sp,96
    800036f8:	84aa                	mv	s1,a0
    800036fa:	8b2e                	mv	s6,a1
    800036fc:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800036fe:	00054703          	lbu	a4,0(a0)
    80003702:	02f00793          	li	a5,47
    80003706:	00f70e63          	beq	a4,a5,80003722 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000370a:	9e4fe0ef          	jal	800018ee <myproc>
    8000370e:	15053503          	ld	a0,336(a0)
    80003712:	a87ff0ef          	jal	80003198 <idup>
    80003716:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003718:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000371c:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000371e:	4b85                	li	s7,1
    80003720:	a871                	j	800037bc <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003722:	4585                	li	a1,1
    80003724:	4505                	li	a0,1
    80003726:	fc8ff0ef          	jal	80002eee <iget>
    8000372a:	8a2a                	mv	s4,a0
    8000372c:	b7f5                	j	80003718 <namex+0x3a>
      iunlockput(ip);
    8000372e:	8552                	mv	a0,s4
    80003730:	ca9ff0ef          	jal	800033d8 <iunlockput>
      return 0;
    80003734:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003736:	8552                	mv	a0,s4
    80003738:	60e6                	ld	ra,88(sp)
    8000373a:	6446                	ld	s0,80(sp)
    8000373c:	64a6                	ld	s1,72(sp)
    8000373e:	6906                	ld	s2,64(sp)
    80003740:	79e2                	ld	s3,56(sp)
    80003742:	7a42                	ld	s4,48(sp)
    80003744:	7aa2                	ld	s5,40(sp)
    80003746:	7b02                	ld	s6,32(sp)
    80003748:	6be2                	ld	s7,24(sp)
    8000374a:	6c42                	ld	s8,16(sp)
    8000374c:	6ca2                	ld	s9,8(sp)
    8000374e:	6125                	addi	sp,sp,96
    80003750:	8082                	ret
      iunlock(ip);
    80003752:	8552                	mv	a0,s4
    80003754:	b29ff0ef          	jal	8000327c <iunlock>
      return ip;
    80003758:	bff9                	j	80003736 <namex+0x58>
      iunlockput(ip);
    8000375a:	8552                	mv	a0,s4
    8000375c:	c7dff0ef          	jal	800033d8 <iunlockput>
      return 0;
    80003760:	8a4e                	mv	s4,s3
    80003762:	bfd1                	j	80003736 <namex+0x58>
  len = path - s;
    80003764:	40998633          	sub	a2,s3,s1
    80003768:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000376c:	099c5063          	bge	s8,s9,800037ec <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003770:	4639                	li	a2,14
    80003772:	85a6                	mv	a1,s1
    80003774:	8556                	mv	a0,s5
    80003776:	dbcfd0ef          	jal	80000d32 <memmove>
    8000377a:	84ce                	mv	s1,s3
  while(*path == '/')
    8000377c:	0004c783          	lbu	a5,0(s1)
    80003780:	01279763          	bne	a5,s2,8000378e <namex+0xb0>
    path++;
    80003784:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003786:	0004c783          	lbu	a5,0(s1)
    8000378a:	ff278de3          	beq	a5,s2,80003784 <namex+0xa6>
    ilock(ip);
    8000378e:	8552                	mv	a0,s4
    80003790:	a3fff0ef          	jal	800031ce <ilock>
    if(ip->type != T_DIR){
    80003794:	044a1783          	lh	a5,68(s4)
    80003798:	f9779be3          	bne	a5,s7,8000372e <namex+0x50>
    if(nameiparent && *path == '\0'){
    8000379c:	000b0563          	beqz	s6,800037a6 <namex+0xc8>
    800037a0:	0004c783          	lbu	a5,0(s1)
    800037a4:	d7dd                	beqz	a5,80003752 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    800037a6:	4601                	li	a2,0
    800037a8:	85d6                	mv	a1,s5
    800037aa:	8552                	mv	a0,s4
    800037ac:	e97ff0ef          	jal	80003642 <dirlookup>
    800037b0:	89aa                	mv	s3,a0
    800037b2:	d545                	beqz	a0,8000375a <namex+0x7c>
    iunlockput(ip);
    800037b4:	8552                	mv	a0,s4
    800037b6:	c23ff0ef          	jal	800033d8 <iunlockput>
    ip = next;
    800037ba:	8a4e                	mv	s4,s3
  while(*path == '/')
    800037bc:	0004c783          	lbu	a5,0(s1)
    800037c0:	01279763          	bne	a5,s2,800037ce <namex+0xf0>
    path++;
    800037c4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800037c6:	0004c783          	lbu	a5,0(s1)
    800037ca:	ff278de3          	beq	a5,s2,800037c4 <namex+0xe6>
  if(*path == 0)
    800037ce:	cb8d                	beqz	a5,80003800 <namex+0x122>
  while(*path != '/' && *path != 0)
    800037d0:	0004c783          	lbu	a5,0(s1)
    800037d4:	89a6                	mv	s3,s1
  len = path - s;
    800037d6:	4c81                	li	s9,0
    800037d8:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800037da:	01278963          	beq	a5,s2,800037ec <namex+0x10e>
    800037de:	d3d9                	beqz	a5,80003764 <namex+0x86>
    path++;
    800037e0:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800037e2:	0009c783          	lbu	a5,0(s3)
    800037e6:	ff279ce3          	bne	a5,s2,800037de <namex+0x100>
    800037ea:	bfad                	j	80003764 <namex+0x86>
    memmove(name, s, len);
    800037ec:	2601                	sext.w	a2,a2
    800037ee:	85a6                	mv	a1,s1
    800037f0:	8556                	mv	a0,s5
    800037f2:	d40fd0ef          	jal	80000d32 <memmove>
    name[len] = 0;
    800037f6:	9cd6                	add	s9,s9,s5
    800037f8:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800037fc:	84ce                	mv	s1,s3
    800037fe:	bfbd                	j	8000377c <namex+0x9e>
  if(nameiparent){
    80003800:	f20b0be3          	beqz	s6,80003736 <namex+0x58>
    iput(ip);
    80003804:	8552                	mv	a0,s4
    80003806:	b4bff0ef          	jal	80003350 <iput>
    return 0;
    8000380a:	4a01                	li	s4,0
    8000380c:	b72d                	j	80003736 <namex+0x58>

000000008000380e <dirlink>:
{
    8000380e:	7139                	addi	sp,sp,-64
    80003810:	fc06                	sd	ra,56(sp)
    80003812:	f822                	sd	s0,48(sp)
    80003814:	f04a                	sd	s2,32(sp)
    80003816:	ec4e                	sd	s3,24(sp)
    80003818:	e852                	sd	s4,16(sp)
    8000381a:	0080                	addi	s0,sp,64
    8000381c:	892a                	mv	s2,a0
    8000381e:	8a2e                	mv	s4,a1
    80003820:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003822:	4601                	li	a2,0
    80003824:	e1fff0ef          	jal	80003642 <dirlookup>
    80003828:	e535                	bnez	a0,80003894 <dirlink+0x86>
    8000382a:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000382c:	04c92483          	lw	s1,76(s2)
    80003830:	c48d                	beqz	s1,8000385a <dirlink+0x4c>
    80003832:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003834:	4741                	li	a4,16
    80003836:	86a6                	mv	a3,s1
    80003838:	fc040613          	addi	a2,s0,-64
    8000383c:	4581                	li	a1,0
    8000383e:	854a                	mv	a0,s2
    80003840:	be3ff0ef          	jal	80003422 <readi>
    80003844:	47c1                	li	a5,16
    80003846:	04f51b63          	bne	a0,a5,8000389c <dirlink+0x8e>
    if(de.inum == 0)
    8000384a:	fc045783          	lhu	a5,-64(s0)
    8000384e:	c791                	beqz	a5,8000385a <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003850:	24c1                	addiw	s1,s1,16
    80003852:	04c92783          	lw	a5,76(s2)
    80003856:	fcf4efe3          	bltu	s1,a5,80003834 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    8000385a:	4639                	li	a2,14
    8000385c:	85d2                	mv	a1,s4
    8000385e:	fc240513          	addi	a0,s0,-62
    80003862:	d76fd0ef          	jal	80000dd8 <strncpy>
  de.inum = inum;
    80003866:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000386a:	4741                	li	a4,16
    8000386c:	86a6                	mv	a3,s1
    8000386e:	fc040613          	addi	a2,s0,-64
    80003872:	4581                	li	a1,0
    80003874:	854a                	mv	a0,s2
    80003876:	ca9ff0ef          	jal	8000351e <writei>
    8000387a:	1541                	addi	a0,a0,-16
    8000387c:	00a03533          	snez	a0,a0
    80003880:	40a00533          	neg	a0,a0
    80003884:	74a2                	ld	s1,40(sp)
}
    80003886:	70e2                	ld	ra,56(sp)
    80003888:	7442                	ld	s0,48(sp)
    8000388a:	7902                	ld	s2,32(sp)
    8000388c:	69e2                	ld	s3,24(sp)
    8000388e:	6a42                	ld	s4,16(sp)
    80003890:	6121                	addi	sp,sp,64
    80003892:	8082                	ret
    iput(ip);
    80003894:	abdff0ef          	jal	80003350 <iput>
    return -1;
    80003898:	557d                	li	a0,-1
    8000389a:	b7f5                	j	80003886 <dirlink+0x78>
      panic("dirlink read");
    8000389c:	00004517          	auipc	a0,0x4
    800038a0:	cac50513          	addi	a0,a0,-852 # 80007548 <etext+0x548>
    800038a4:	efffc0ef          	jal	800007a2 <panic>

00000000800038a8 <namei>:

struct inode*
namei(char *path)
{
    800038a8:	1101                	addi	sp,sp,-32
    800038aa:	ec06                	sd	ra,24(sp)
    800038ac:	e822                	sd	s0,16(sp)
    800038ae:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800038b0:	fe040613          	addi	a2,s0,-32
    800038b4:	4581                	li	a1,0
    800038b6:	e29ff0ef          	jal	800036de <namex>
}
    800038ba:	60e2                	ld	ra,24(sp)
    800038bc:	6442                	ld	s0,16(sp)
    800038be:	6105                	addi	sp,sp,32
    800038c0:	8082                	ret

00000000800038c2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800038c2:	1141                	addi	sp,sp,-16
    800038c4:	e406                	sd	ra,8(sp)
    800038c6:	e022                	sd	s0,0(sp)
    800038c8:	0800                	addi	s0,sp,16
    800038ca:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800038cc:	4585                	li	a1,1
    800038ce:	e11ff0ef          	jal	800036de <namex>
}
    800038d2:	60a2                	ld	ra,8(sp)
    800038d4:	6402                	ld	s0,0(sp)
    800038d6:	0141                	addi	sp,sp,16
    800038d8:	8082                	ret

00000000800038da <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800038da:	1101                	addi	sp,sp,-32
    800038dc:	ec06                	sd	ra,24(sp)
    800038de:	e822                	sd	s0,16(sp)
    800038e0:	e426                	sd	s1,8(sp)
    800038e2:	e04a                	sd	s2,0(sp)
    800038e4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800038e6:	0001f917          	auipc	s2,0x1f
    800038ea:	a5a90913          	addi	s2,s2,-1446 # 80022340 <log>
    800038ee:	01892583          	lw	a1,24(s2)
    800038f2:	02892503          	lw	a0,40(s2)
    800038f6:	9a0ff0ef          	jal	80002a96 <bread>
    800038fa:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800038fc:	02c92603          	lw	a2,44(s2)
    80003900:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003902:	00c05f63          	blez	a2,80003920 <write_head+0x46>
    80003906:	0001f717          	auipc	a4,0x1f
    8000390a:	a6a70713          	addi	a4,a4,-1430 # 80022370 <log+0x30>
    8000390e:	87aa                	mv	a5,a0
    80003910:	060a                	slli	a2,a2,0x2
    80003912:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003914:	4314                	lw	a3,0(a4)
    80003916:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003918:	0711                	addi	a4,a4,4
    8000391a:	0791                	addi	a5,a5,4
    8000391c:	fec79ce3          	bne	a5,a2,80003914 <write_head+0x3a>
  }
  bwrite(buf);
    80003920:	8526                	mv	a0,s1
    80003922:	a4aff0ef          	jal	80002b6c <bwrite>
  brelse(buf);
    80003926:	8526                	mv	a0,s1
    80003928:	a76ff0ef          	jal	80002b9e <brelse>
}
    8000392c:	60e2                	ld	ra,24(sp)
    8000392e:	6442                	ld	s0,16(sp)
    80003930:	64a2                	ld	s1,8(sp)
    80003932:	6902                	ld	s2,0(sp)
    80003934:	6105                	addi	sp,sp,32
    80003936:	8082                	ret

0000000080003938 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003938:	0001f797          	auipc	a5,0x1f
    8000393c:	a347a783          	lw	a5,-1484(a5) # 8002236c <log+0x2c>
    80003940:	08f05f63          	blez	a5,800039de <install_trans+0xa6>
{
    80003944:	7139                	addi	sp,sp,-64
    80003946:	fc06                	sd	ra,56(sp)
    80003948:	f822                	sd	s0,48(sp)
    8000394a:	f426                	sd	s1,40(sp)
    8000394c:	f04a                	sd	s2,32(sp)
    8000394e:	ec4e                	sd	s3,24(sp)
    80003950:	e852                	sd	s4,16(sp)
    80003952:	e456                	sd	s5,8(sp)
    80003954:	e05a                	sd	s6,0(sp)
    80003956:	0080                	addi	s0,sp,64
    80003958:	8b2a                	mv	s6,a0
    8000395a:	0001fa97          	auipc	s5,0x1f
    8000395e:	a16a8a93          	addi	s5,s5,-1514 # 80022370 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003962:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003964:	0001f997          	auipc	s3,0x1f
    80003968:	9dc98993          	addi	s3,s3,-1572 # 80022340 <log>
    8000396c:	a829                	j	80003986 <install_trans+0x4e>
    brelse(lbuf);
    8000396e:	854a                	mv	a0,s2
    80003970:	a2eff0ef          	jal	80002b9e <brelse>
    brelse(dbuf);
    80003974:	8526                	mv	a0,s1
    80003976:	a28ff0ef          	jal	80002b9e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000397a:	2a05                	addiw	s4,s4,1
    8000397c:	0a91                	addi	s5,s5,4
    8000397e:	02c9a783          	lw	a5,44(s3)
    80003982:	04fa5463          	bge	s4,a5,800039ca <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003986:	0189a583          	lw	a1,24(s3)
    8000398a:	014585bb          	addw	a1,a1,s4
    8000398e:	2585                	addiw	a1,a1,1
    80003990:	0289a503          	lw	a0,40(s3)
    80003994:	902ff0ef          	jal	80002a96 <bread>
    80003998:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000399a:	000aa583          	lw	a1,0(s5)
    8000399e:	0289a503          	lw	a0,40(s3)
    800039a2:	8f4ff0ef          	jal	80002a96 <bread>
    800039a6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800039a8:	40000613          	li	a2,1024
    800039ac:	05890593          	addi	a1,s2,88
    800039b0:	05850513          	addi	a0,a0,88
    800039b4:	b7efd0ef          	jal	80000d32 <memmove>
    bwrite(dbuf);  // write dst to disk
    800039b8:	8526                	mv	a0,s1
    800039ba:	9b2ff0ef          	jal	80002b6c <bwrite>
    if(recovering == 0)
    800039be:	fa0b18e3          	bnez	s6,8000396e <install_trans+0x36>
      bunpin(dbuf);
    800039c2:	8526                	mv	a0,s1
    800039c4:	a96ff0ef          	jal	80002c5a <bunpin>
    800039c8:	b75d                	j	8000396e <install_trans+0x36>
}
    800039ca:	70e2                	ld	ra,56(sp)
    800039cc:	7442                	ld	s0,48(sp)
    800039ce:	74a2                	ld	s1,40(sp)
    800039d0:	7902                	ld	s2,32(sp)
    800039d2:	69e2                	ld	s3,24(sp)
    800039d4:	6a42                	ld	s4,16(sp)
    800039d6:	6aa2                	ld	s5,8(sp)
    800039d8:	6b02                	ld	s6,0(sp)
    800039da:	6121                	addi	sp,sp,64
    800039dc:	8082                	ret
    800039de:	8082                	ret

00000000800039e0 <initlog>:
{
    800039e0:	7179                	addi	sp,sp,-48
    800039e2:	f406                	sd	ra,40(sp)
    800039e4:	f022                	sd	s0,32(sp)
    800039e6:	ec26                	sd	s1,24(sp)
    800039e8:	e84a                	sd	s2,16(sp)
    800039ea:	e44e                	sd	s3,8(sp)
    800039ec:	1800                	addi	s0,sp,48
    800039ee:	892a                	mv	s2,a0
    800039f0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800039f2:	0001f497          	auipc	s1,0x1f
    800039f6:	94e48493          	addi	s1,s1,-1714 # 80022340 <log>
    800039fa:	00004597          	auipc	a1,0x4
    800039fe:	b5e58593          	addi	a1,a1,-1186 # 80007558 <etext+0x558>
    80003a02:	8526                	mv	a0,s1
    80003a04:	97efd0ef          	jal	80000b82 <initlock>
  log.start = sb->logstart;
    80003a08:	0149a583          	lw	a1,20(s3)
    80003a0c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003a0e:	0109a783          	lw	a5,16(s3)
    80003a12:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003a14:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003a18:	854a                	mv	a0,s2
    80003a1a:	87cff0ef          	jal	80002a96 <bread>
  log.lh.n = lh->n;
    80003a1e:	4d30                	lw	a2,88(a0)
    80003a20:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003a22:	00c05f63          	blez	a2,80003a40 <initlog+0x60>
    80003a26:	87aa                	mv	a5,a0
    80003a28:	0001f717          	auipc	a4,0x1f
    80003a2c:	94870713          	addi	a4,a4,-1720 # 80022370 <log+0x30>
    80003a30:	060a                	slli	a2,a2,0x2
    80003a32:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003a34:	4ff4                	lw	a3,92(a5)
    80003a36:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003a38:	0791                	addi	a5,a5,4
    80003a3a:	0711                	addi	a4,a4,4
    80003a3c:	fec79ce3          	bne	a5,a2,80003a34 <initlog+0x54>
  brelse(buf);
    80003a40:	95eff0ef          	jal	80002b9e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003a44:	4505                	li	a0,1
    80003a46:	ef3ff0ef          	jal	80003938 <install_trans>
  log.lh.n = 0;
    80003a4a:	0001f797          	auipc	a5,0x1f
    80003a4e:	9207a123          	sw	zero,-1758(a5) # 8002236c <log+0x2c>
  write_head(); // clear the log
    80003a52:	e89ff0ef          	jal	800038da <write_head>
}
    80003a56:	70a2                	ld	ra,40(sp)
    80003a58:	7402                	ld	s0,32(sp)
    80003a5a:	64e2                	ld	s1,24(sp)
    80003a5c:	6942                	ld	s2,16(sp)
    80003a5e:	69a2                	ld	s3,8(sp)
    80003a60:	6145                	addi	sp,sp,48
    80003a62:	8082                	ret

0000000080003a64 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003a64:	1101                	addi	sp,sp,-32
    80003a66:	ec06                	sd	ra,24(sp)
    80003a68:	e822                	sd	s0,16(sp)
    80003a6a:	e426                	sd	s1,8(sp)
    80003a6c:	e04a                	sd	s2,0(sp)
    80003a6e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003a70:	0001f517          	auipc	a0,0x1f
    80003a74:	8d050513          	addi	a0,a0,-1840 # 80022340 <log>
    80003a78:	98afd0ef          	jal	80000c02 <acquire>
  while(1){
    if(log.committing){
    80003a7c:	0001f497          	auipc	s1,0x1f
    80003a80:	8c448493          	addi	s1,s1,-1852 # 80022340 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003a84:	4979                	li	s2,30
    80003a86:	a029                	j	80003a90 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003a88:	85a6                	mv	a1,s1
    80003a8a:	8526                	mv	a0,s1
    80003a8c:	c30fe0ef          	jal	80001ebc <sleep>
    if(log.committing){
    80003a90:	50dc                	lw	a5,36(s1)
    80003a92:	fbfd                	bnez	a5,80003a88 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003a94:	5098                	lw	a4,32(s1)
    80003a96:	2705                	addiw	a4,a4,1
    80003a98:	0027179b          	slliw	a5,a4,0x2
    80003a9c:	9fb9                	addw	a5,a5,a4
    80003a9e:	0017979b          	slliw	a5,a5,0x1
    80003aa2:	54d4                	lw	a3,44(s1)
    80003aa4:	9fb5                	addw	a5,a5,a3
    80003aa6:	00f95763          	bge	s2,a5,80003ab4 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003aaa:	85a6                	mv	a1,s1
    80003aac:	8526                	mv	a0,s1
    80003aae:	c0efe0ef          	jal	80001ebc <sleep>
    80003ab2:	bff9                	j	80003a90 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003ab4:	0001f517          	auipc	a0,0x1f
    80003ab8:	88c50513          	addi	a0,a0,-1908 # 80022340 <log>
    80003abc:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003abe:	9dcfd0ef          	jal	80000c9a <release>
      break;
    }
  }
}
    80003ac2:	60e2                	ld	ra,24(sp)
    80003ac4:	6442                	ld	s0,16(sp)
    80003ac6:	64a2                	ld	s1,8(sp)
    80003ac8:	6902                	ld	s2,0(sp)
    80003aca:	6105                	addi	sp,sp,32
    80003acc:	8082                	ret

0000000080003ace <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003ace:	7139                	addi	sp,sp,-64
    80003ad0:	fc06                	sd	ra,56(sp)
    80003ad2:	f822                	sd	s0,48(sp)
    80003ad4:	f426                	sd	s1,40(sp)
    80003ad6:	f04a                	sd	s2,32(sp)
    80003ad8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003ada:	0001f497          	auipc	s1,0x1f
    80003ade:	86648493          	addi	s1,s1,-1946 # 80022340 <log>
    80003ae2:	8526                	mv	a0,s1
    80003ae4:	91efd0ef          	jal	80000c02 <acquire>
  log.outstanding -= 1;
    80003ae8:	509c                	lw	a5,32(s1)
    80003aea:	37fd                	addiw	a5,a5,-1
    80003aec:	0007891b          	sext.w	s2,a5
    80003af0:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003af2:	50dc                	lw	a5,36(s1)
    80003af4:	ef9d                	bnez	a5,80003b32 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003af6:	04091763          	bnez	s2,80003b44 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003afa:	0001f497          	auipc	s1,0x1f
    80003afe:	84648493          	addi	s1,s1,-1978 # 80022340 <log>
    80003b02:	4785                	li	a5,1
    80003b04:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003b06:	8526                	mv	a0,s1
    80003b08:	992fd0ef          	jal	80000c9a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003b0c:	54dc                	lw	a5,44(s1)
    80003b0e:	04f04b63          	bgtz	a5,80003b64 <end_op+0x96>
    acquire(&log.lock);
    80003b12:	0001f497          	auipc	s1,0x1f
    80003b16:	82e48493          	addi	s1,s1,-2002 # 80022340 <log>
    80003b1a:	8526                	mv	a0,s1
    80003b1c:	8e6fd0ef          	jal	80000c02 <acquire>
    log.committing = 0;
    80003b20:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003b24:	8526                	mv	a0,s1
    80003b26:	be2fe0ef          	jal	80001f08 <wakeup>
    release(&log.lock);
    80003b2a:	8526                	mv	a0,s1
    80003b2c:	96efd0ef          	jal	80000c9a <release>
}
    80003b30:	a025                	j	80003b58 <end_op+0x8a>
    80003b32:	ec4e                	sd	s3,24(sp)
    80003b34:	e852                	sd	s4,16(sp)
    80003b36:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003b38:	00004517          	auipc	a0,0x4
    80003b3c:	a2850513          	addi	a0,a0,-1496 # 80007560 <etext+0x560>
    80003b40:	c63fc0ef          	jal	800007a2 <panic>
    wakeup(&log);
    80003b44:	0001e497          	auipc	s1,0x1e
    80003b48:	7fc48493          	addi	s1,s1,2044 # 80022340 <log>
    80003b4c:	8526                	mv	a0,s1
    80003b4e:	bbafe0ef          	jal	80001f08 <wakeup>
  release(&log.lock);
    80003b52:	8526                	mv	a0,s1
    80003b54:	946fd0ef          	jal	80000c9a <release>
}
    80003b58:	70e2                	ld	ra,56(sp)
    80003b5a:	7442                	ld	s0,48(sp)
    80003b5c:	74a2                	ld	s1,40(sp)
    80003b5e:	7902                	ld	s2,32(sp)
    80003b60:	6121                	addi	sp,sp,64
    80003b62:	8082                	ret
    80003b64:	ec4e                	sd	s3,24(sp)
    80003b66:	e852                	sd	s4,16(sp)
    80003b68:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b6a:	0001fa97          	auipc	s5,0x1f
    80003b6e:	806a8a93          	addi	s5,s5,-2042 # 80022370 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003b72:	0001ea17          	auipc	s4,0x1e
    80003b76:	7cea0a13          	addi	s4,s4,1998 # 80022340 <log>
    80003b7a:	018a2583          	lw	a1,24(s4)
    80003b7e:	012585bb          	addw	a1,a1,s2
    80003b82:	2585                	addiw	a1,a1,1
    80003b84:	028a2503          	lw	a0,40(s4)
    80003b88:	f0ffe0ef          	jal	80002a96 <bread>
    80003b8c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003b8e:	000aa583          	lw	a1,0(s5)
    80003b92:	028a2503          	lw	a0,40(s4)
    80003b96:	f01fe0ef          	jal	80002a96 <bread>
    80003b9a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003b9c:	40000613          	li	a2,1024
    80003ba0:	05850593          	addi	a1,a0,88
    80003ba4:	05848513          	addi	a0,s1,88
    80003ba8:	98afd0ef          	jal	80000d32 <memmove>
    bwrite(to);  // write the log
    80003bac:	8526                	mv	a0,s1
    80003bae:	fbffe0ef          	jal	80002b6c <bwrite>
    brelse(from);
    80003bb2:	854e                	mv	a0,s3
    80003bb4:	febfe0ef          	jal	80002b9e <brelse>
    brelse(to);
    80003bb8:	8526                	mv	a0,s1
    80003bba:	fe5fe0ef          	jal	80002b9e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bbe:	2905                	addiw	s2,s2,1
    80003bc0:	0a91                	addi	s5,s5,4
    80003bc2:	02ca2783          	lw	a5,44(s4)
    80003bc6:	faf94ae3          	blt	s2,a5,80003b7a <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003bca:	d11ff0ef          	jal	800038da <write_head>
    install_trans(0); // Now install writes to home locations
    80003bce:	4501                	li	a0,0
    80003bd0:	d69ff0ef          	jal	80003938 <install_trans>
    log.lh.n = 0;
    80003bd4:	0001e797          	auipc	a5,0x1e
    80003bd8:	7807ac23          	sw	zero,1944(a5) # 8002236c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003bdc:	cffff0ef          	jal	800038da <write_head>
    80003be0:	69e2                	ld	s3,24(sp)
    80003be2:	6a42                	ld	s4,16(sp)
    80003be4:	6aa2                	ld	s5,8(sp)
    80003be6:	b735                	j	80003b12 <end_op+0x44>

0000000080003be8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003be8:	1101                	addi	sp,sp,-32
    80003bea:	ec06                	sd	ra,24(sp)
    80003bec:	e822                	sd	s0,16(sp)
    80003bee:	e426                	sd	s1,8(sp)
    80003bf0:	e04a                	sd	s2,0(sp)
    80003bf2:	1000                	addi	s0,sp,32
    80003bf4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003bf6:	0001e917          	auipc	s2,0x1e
    80003bfa:	74a90913          	addi	s2,s2,1866 # 80022340 <log>
    80003bfe:	854a                	mv	a0,s2
    80003c00:	802fd0ef          	jal	80000c02 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003c04:	02c92603          	lw	a2,44(s2)
    80003c08:	47f5                	li	a5,29
    80003c0a:	06c7c363          	blt	a5,a2,80003c70 <log_write+0x88>
    80003c0e:	0001e797          	auipc	a5,0x1e
    80003c12:	74e7a783          	lw	a5,1870(a5) # 8002235c <log+0x1c>
    80003c16:	37fd                	addiw	a5,a5,-1
    80003c18:	04f65c63          	bge	a2,a5,80003c70 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003c1c:	0001e797          	auipc	a5,0x1e
    80003c20:	7447a783          	lw	a5,1860(a5) # 80022360 <log+0x20>
    80003c24:	04f05c63          	blez	a5,80003c7c <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003c28:	4781                	li	a5,0
    80003c2a:	04c05f63          	blez	a2,80003c88 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003c2e:	44cc                	lw	a1,12(s1)
    80003c30:	0001e717          	auipc	a4,0x1e
    80003c34:	74070713          	addi	a4,a4,1856 # 80022370 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003c38:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003c3a:	4314                	lw	a3,0(a4)
    80003c3c:	04b68663          	beq	a3,a1,80003c88 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003c40:	2785                	addiw	a5,a5,1
    80003c42:	0711                	addi	a4,a4,4
    80003c44:	fef61be3          	bne	a2,a5,80003c3a <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003c48:	0621                	addi	a2,a2,8
    80003c4a:	060a                	slli	a2,a2,0x2
    80003c4c:	0001e797          	auipc	a5,0x1e
    80003c50:	6f478793          	addi	a5,a5,1780 # 80022340 <log>
    80003c54:	97b2                	add	a5,a5,a2
    80003c56:	44d8                	lw	a4,12(s1)
    80003c58:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003c5a:	8526                	mv	a0,s1
    80003c5c:	fcbfe0ef          	jal	80002c26 <bpin>
    log.lh.n++;
    80003c60:	0001e717          	auipc	a4,0x1e
    80003c64:	6e070713          	addi	a4,a4,1760 # 80022340 <log>
    80003c68:	575c                	lw	a5,44(a4)
    80003c6a:	2785                	addiw	a5,a5,1
    80003c6c:	d75c                	sw	a5,44(a4)
    80003c6e:	a80d                	j	80003ca0 <log_write+0xb8>
    panic("too big a transaction");
    80003c70:	00004517          	auipc	a0,0x4
    80003c74:	90050513          	addi	a0,a0,-1792 # 80007570 <etext+0x570>
    80003c78:	b2bfc0ef          	jal	800007a2 <panic>
    panic("log_write outside of trans");
    80003c7c:	00004517          	auipc	a0,0x4
    80003c80:	90c50513          	addi	a0,a0,-1780 # 80007588 <etext+0x588>
    80003c84:	b1ffc0ef          	jal	800007a2 <panic>
  log.lh.block[i] = b->blockno;
    80003c88:	00878693          	addi	a3,a5,8
    80003c8c:	068a                	slli	a3,a3,0x2
    80003c8e:	0001e717          	auipc	a4,0x1e
    80003c92:	6b270713          	addi	a4,a4,1714 # 80022340 <log>
    80003c96:	9736                	add	a4,a4,a3
    80003c98:	44d4                	lw	a3,12(s1)
    80003c9a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003c9c:	faf60fe3          	beq	a2,a5,80003c5a <log_write+0x72>
  }
  release(&log.lock);
    80003ca0:	0001e517          	auipc	a0,0x1e
    80003ca4:	6a050513          	addi	a0,a0,1696 # 80022340 <log>
    80003ca8:	ff3fc0ef          	jal	80000c9a <release>
}
    80003cac:	60e2                	ld	ra,24(sp)
    80003cae:	6442                	ld	s0,16(sp)
    80003cb0:	64a2                	ld	s1,8(sp)
    80003cb2:	6902                	ld	s2,0(sp)
    80003cb4:	6105                	addi	sp,sp,32
    80003cb6:	8082                	ret

0000000080003cb8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003cb8:	1101                	addi	sp,sp,-32
    80003cba:	ec06                	sd	ra,24(sp)
    80003cbc:	e822                	sd	s0,16(sp)
    80003cbe:	e426                	sd	s1,8(sp)
    80003cc0:	e04a                	sd	s2,0(sp)
    80003cc2:	1000                	addi	s0,sp,32
    80003cc4:	84aa                	mv	s1,a0
    80003cc6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003cc8:	00004597          	auipc	a1,0x4
    80003ccc:	8e058593          	addi	a1,a1,-1824 # 800075a8 <etext+0x5a8>
    80003cd0:	0521                	addi	a0,a0,8
    80003cd2:	eb1fc0ef          	jal	80000b82 <initlock>
  lk->name = name;
    80003cd6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003cda:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003cde:	0204a423          	sw	zero,40(s1)
}
    80003ce2:	60e2                	ld	ra,24(sp)
    80003ce4:	6442                	ld	s0,16(sp)
    80003ce6:	64a2                	ld	s1,8(sp)
    80003ce8:	6902                	ld	s2,0(sp)
    80003cea:	6105                	addi	sp,sp,32
    80003cec:	8082                	ret

0000000080003cee <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003cee:	1101                	addi	sp,sp,-32
    80003cf0:	ec06                	sd	ra,24(sp)
    80003cf2:	e822                	sd	s0,16(sp)
    80003cf4:	e426                	sd	s1,8(sp)
    80003cf6:	e04a                	sd	s2,0(sp)
    80003cf8:	1000                	addi	s0,sp,32
    80003cfa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003cfc:	00850913          	addi	s2,a0,8
    80003d00:	854a                	mv	a0,s2
    80003d02:	f01fc0ef          	jal	80000c02 <acquire>
  while (lk->locked) {
    80003d06:	409c                	lw	a5,0(s1)
    80003d08:	c799                	beqz	a5,80003d16 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003d0a:	85ca                	mv	a1,s2
    80003d0c:	8526                	mv	a0,s1
    80003d0e:	9aefe0ef          	jal	80001ebc <sleep>
  while (lk->locked) {
    80003d12:	409c                	lw	a5,0(s1)
    80003d14:	fbfd                	bnez	a5,80003d0a <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003d16:	4785                	li	a5,1
    80003d18:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003d1a:	bd5fd0ef          	jal	800018ee <myproc>
    80003d1e:	591c                	lw	a5,48(a0)
    80003d20:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003d22:	854a                	mv	a0,s2
    80003d24:	f77fc0ef          	jal	80000c9a <release>
}
    80003d28:	60e2                	ld	ra,24(sp)
    80003d2a:	6442                	ld	s0,16(sp)
    80003d2c:	64a2                	ld	s1,8(sp)
    80003d2e:	6902                	ld	s2,0(sp)
    80003d30:	6105                	addi	sp,sp,32
    80003d32:	8082                	ret

0000000080003d34 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003d34:	1101                	addi	sp,sp,-32
    80003d36:	ec06                	sd	ra,24(sp)
    80003d38:	e822                	sd	s0,16(sp)
    80003d3a:	e426                	sd	s1,8(sp)
    80003d3c:	e04a                	sd	s2,0(sp)
    80003d3e:	1000                	addi	s0,sp,32
    80003d40:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003d42:	00850913          	addi	s2,a0,8
    80003d46:	854a                	mv	a0,s2
    80003d48:	ebbfc0ef          	jal	80000c02 <acquire>
  lk->locked = 0;
    80003d4c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003d50:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003d54:	8526                	mv	a0,s1
    80003d56:	9b2fe0ef          	jal	80001f08 <wakeup>
  release(&lk->lk);
    80003d5a:	854a                	mv	a0,s2
    80003d5c:	f3ffc0ef          	jal	80000c9a <release>
}
    80003d60:	60e2                	ld	ra,24(sp)
    80003d62:	6442                	ld	s0,16(sp)
    80003d64:	64a2                	ld	s1,8(sp)
    80003d66:	6902                	ld	s2,0(sp)
    80003d68:	6105                	addi	sp,sp,32
    80003d6a:	8082                	ret

0000000080003d6c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003d6c:	7179                	addi	sp,sp,-48
    80003d6e:	f406                	sd	ra,40(sp)
    80003d70:	f022                	sd	s0,32(sp)
    80003d72:	ec26                	sd	s1,24(sp)
    80003d74:	e84a                	sd	s2,16(sp)
    80003d76:	1800                	addi	s0,sp,48
    80003d78:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003d7a:	00850913          	addi	s2,a0,8
    80003d7e:	854a                	mv	a0,s2
    80003d80:	e83fc0ef          	jal	80000c02 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003d84:	409c                	lw	a5,0(s1)
    80003d86:	ef81                	bnez	a5,80003d9e <holdingsleep+0x32>
    80003d88:	4481                	li	s1,0
  release(&lk->lk);
    80003d8a:	854a                	mv	a0,s2
    80003d8c:	f0ffc0ef          	jal	80000c9a <release>
  return r;
}
    80003d90:	8526                	mv	a0,s1
    80003d92:	70a2                	ld	ra,40(sp)
    80003d94:	7402                	ld	s0,32(sp)
    80003d96:	64e2                	ld	s1,24(sp)
    80003d98:	6942                	ld	s2,16(sp)
    80003d9a:	6145                	addi	sp,sp,48
    80003d9c:	8082                	ret
    80003d9e:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003da0:	0284a983          	lw	s3,40(s1)
    80003da4:	b4bfd0ef          	jal	800018ee <myproc>
    80003da8:	5904                	lw	s1,48(a0)
    80003daa:	413484b3          	sub	s1,s1,s3
    80003dae:	0014b493          	seqz	s1,s1
    80003db2:	69a2                	ld	s3,8(sp)
    80003db4:	bfd9                	j	80003d8a <holdingsleep+0x1e>

0000000080003db6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003db6:	1141                	addi	sp,sp,-16
    80003db8:	e406                	sd	ra,8(sp)
    80003dba:	e022                	sd	s0,0(sp)
    80003dbc:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003dbe:	00003597          	auipc	a1,0x3
    80003dc2:	7fa58593          	addi	a1,a1,2042 # 800075b8 <etext+0x5b8>
    80003dc6:	0001e517          	auipc	a0,0x1e
    80003dca:	6c250513          	addi	a0,a0,1730 # 80022488 <ftable>
    80003dce:	db5fc0ef          	jal	80000b82 <initlock>
}
    80003dd2:	60a2                	ld	ra,8(sp)
    80003dd4:	6402                	ld	s0,0(sp)
    80003dd6:	0141                	addi	sp,sp,16
    80003dd8:	8082                	ret

0000000080003dda <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003dda:	1101                	addi	sp,sp,-32
    80003ddc:	ec06                	sd	ra,24(sp)
    80003dde:	e822                	sd	s0,16(sp)
    80003de0:	e426                	sd	s1,8(sp)
    80003de2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003de4:	0001e517          	auipc	a0,0x1e
    80003de8:	6a450513          	addi	a0,a0,1700 # 80022488 <ftable>
    80003dec:	e17fc0ef          	jal	80000c02 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003df0:	0001e497          	auipc	s1,0x1e
    80003df4:	6b048493          	addi	s1,s1,1712 # 800224a0 <ftable+0x18>
    80003df8:	0001f717          	auipc	a4,0x1f
    80003dfc:	64870713          	addi	a4,a4,1608 # 80023440 <disk>
    if(f->ref == 0){
    80003e00:	40dc                	lw	a5,4(s1)
    80003e02:	cf89                	beqz	a5,80003e1c <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003e04:	02848493          	addi	s1,s1,40
    80003e08:	fee49ce3          	bne	s1,a4,80003e00 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003e0c:	0001e517          	auipc	a0,0x1e
    80003e10:	67c50513          	addi	a0,a0,1660 # 80022488 <ftable>
    80003e14:	e87fc0ef          	jal	80000c9a <release>
  return 0;
    80003e18:	4481                	li	s1,0
    80003e1a:	a809                	j	80003e2c <filealloc+0x52>
      f->ref = 1;
    80003e1c:	4785                	li	a5,1
    80003e1e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003e20:	0001e517          	auipc	a0,0x1e
    80003e24:	66850513          	addi	a0,a0,1640 # 80022488 <ftable>
    80003e28:	e73fc0ef          	jal	80000c9a <release>
}
    80003e2c:	8526                	mv	a0,s1
    80003e2e:	60e2                	ld	ra,24(sp)
    80003e30:	6442                	ld	s0,16(sp)
    80003e32:	64a2                	ld	s1,8(sp)
    80003e34:	6105                	addi	sp,sp,32
    80003e36:	8082                	ret

0000000080003e38 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003e38:	1101                	addi	sp,sp,-32
    80003e3a:	ec06                	sd	ra,24(sp)
    80003e3c:	e822                	sd	s0,16(sp)
    80003e3e:	e426                	sd	s1,8(sp)
    80003e40:	1000                	addi	s0,sp,32
    80003e42:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003e44:	0001e517          	auipc	a0,0x1e
    80003e48:	64450513          	addi	a0,a0,1604 # 80022488 <ftable>
    80003e4c:	db7fc0ef          	jal	80000c02 <acquire>
  if(f->ref < 1)
    80003e50:	40dc                	lw	a5,4(s1)
    80003e52:	02f05063          	blez	a5,80003e72 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003e56:	2785                	addiw	a5,a5,1
    80003e58:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003e5a:	0001e517          	auipc	a0,0x1e
    80003e5e:	62e50513          	addi	a0,a0,1582 # 80022488 <ftable>
    80003e62:	e39fc0ef          	jal	80000c9a <release>
  return f;
}
    80003e66:	8526                	mv	a0,s1
    80003e68:	60e2                	ld	ra,24(sp)
    80003e6a:	6442                	ld	s0,16(sp)
    80003e6c:	64a2                	ld	s1,8(sp)
    80003e6e:	6105                	addi	sp,sp,32
    80003e70:	8082                	ret
    panic("filedup");
    80003e72:	00003517          	auipc	a0,0x3
    80003e76:	74e50513          	addi	a0,a0,1870 # 800075c0 <etext+0x5c0>
    80003e7a:	929fc0ef          	jal	800007a2 <panic>

0000000080003e7e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003e7e:	7139                	addi	sp,sp,-64
    80003e80:	fc06                	sd	ra,56(sp)
    80003e82:	f822                	sd	s0,48(sp)
    80003e84:	f426                	sd	s1,40(sp)
    80003e86:	0080                	addi	s0,sp,64
    80003e88:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003e8a:	0001e517          	auipc	a0,0x1e
    80003e8e:	5fe50513          	addi	a0,a0,1534 # 80022488 <ftable>
    80003e92:	d71fc0ef          	jal	80000c02 <acquire>
  if(f->ref < 1)
    80003e96:	40dc                	lw	a5,4(s1)
    80003e98:	04f05a63          	blez	a5,80003eec <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003e9c:	37fd                	addiw	a5,a5,-1
    80003e9e:	0007871b          	sext.w	a4,a5
    80003ea2:	c0dc                	sw	a5,4(s1)
    80003ea4:	04e04e63          	bgtz	a4,80003f00 <fileclose+0x82>
    80003ea8:	f04a                	sd	s2,32(sp)
    80003eaa:	ec4e                	sd	s3,24(sp)
    80003eac:	e852                	sd	s4,16(sp)
    80003eae:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003eb0:	0004a903          	lw	s2,0(s1)
    80003eb4:	0094ca83          	lbu	s5,9(s1)
    80003eb8:	0104ba03          	ld	s4,16(s1)
    80003ebc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ec0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ec4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ec8:	0001e517          	auipc	a0,0x1e
    80003ecc:	5c050513          	addi	a0,a0,1472 # 80022488 <ftable>
    80003ed0:	dcbfc0ef          	jal	80000c9a <release>

  if(ff.type == FD_PIPE){
    80003ed4:	4785                	li	a5,1
    80003ed6:	04f90063          	beq	s2,a5,80003f16 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003eda:	3979                	addiw	s2,s2,-2
    80003edc:	4785                	li	a5,1
    80003ede:	0527f563          	bgeu	a5,s2,80003f28 <fileclose+0xaa>
    80003ee2:	7902                	ld	s2,32(sp)
    80003ee4:	69e2                	ld	s3,24(sp)
    80003ee6:	6a42                	ld	s4,16(sp)
    80003ee8:	6aa2                	ld	s5,8(sp)
    80003eea:	a00d                	j	80003f0c <fileclose+0x8e>
    80003eec:	f04a                	sd	s2,32(sp)
    80003eee:	ec4e                	sd	s3,24(sp)
    80003ef0:	e852                	sd	s4,16(sp)
    80003ef2:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003ef4:	00003517          	auipc	a0,0x3
    80003ef8:	6d450513          	addi	a0,a0,1748 # 800075c8 <etext+0x5c8>
    80003efc:	8a7fc0ef          	jal	800007a2 <panic>
    release(&ftable.lock);
    80003f00:	0001e517          	auipc	a0,0x1e
    80003f04:	58850513          	addi	a0,a0,1416 # 80022488 <ftable>
    80003f08:	d93fc0ef          	jal	80000c9a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003f0c:	70e2                	ld	ra,56(sp)
    80003f0e:	7442                	ld	s0,48(sp)
    80003f10:	74a2                	ld	s1,40(sp)
    80003f12:	6121                	addi	sp,sp,64
    80003f14:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003f16:	85d6                	mv	a1,s5
    80003f18:	8552                	mv	a0,s4
    80003f1a:	336000ef          	jal	80004250 <pipeclose>
    80003f1e:	7902                	ld	s2,32(sp)
    80003f20:	69e2                	ld	s3,24(sp)
    80003f22:	6a42                	ld	s4,16(sp)
    80003f24:	6aa2                	ld	s5,8(sp)
    80003f26:	b7dd                	j	80003f0c <fileclose+0x8e>
    begin_op();
    80003f28:	b3dff0ef          	jal	80003a64 <begin_op>
    iput(ff.ip);
    80003f2c:	854e                	mv	a0,s3
    80003f2e:	c22ff0ef          	jal	80003350 <iput>
    end_op();
    80003f32:	b9dff0ef          	jal	80003ace <end_op>
    80003f36:	7902                	ld	s2,32(sp)
    80003f38:	69e2                	ld	s3,24(sp)
    80003f3a:	6a42                	ld	s4,16(sp)
    80003f3c:	6aa2                	ld	s5,8(sp)
    80003f3e:	b7f9                	j	80003f0c <fileclose+0x8e>

0000000080003f40 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003f40:	715d                	addi	sp,sp,-80
    80003f42:	e486                	sd	ra,72(sp)
    80003f44:	e0a2                	sd	s0,64(sp)
    80003f46:	fc26                	sd	s1,56(sp)
    80003f48:	f44e                	sd	s3,40(sp)
    80003f4a:	0880                	addi	s0,sp,80
    80003f4c:	84aa                	mv	s1,a0
    80003f4e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003f50:	99ffd0ef          	jal	800018ee <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003f54:	409c                	lw	a5,0(s1)
    80003f56:	37f9                	addiw	a5,a5,-2
    80003f58:	4705                	li	a4,1
    80003f5a:	04f76063          	bltu	a4,a5,80003f9a <filestat+0x5a>
    80003f5e:	f84a                	sd	s2,48(sp)
    80003f60:	892a                	mv	s2,a0
    ilock(f->ip);
    80003f62:	6c88                	ld	a0,24(s1)
    80003f64:	a6aff0ef          	jal	800031ce <ilock>
    stati(f->ip, &st);
    80003f68:	fb840593          	addi	a1,s0,-72
    80003f6c:	6c88                	ld	a0,24(s1)
    80003f6e:	c8aff0ef          	jal	800033f8 <stati>
    iunlock(f->ip);
    80003f72:	6c88                	ld	a0,24(s1)
    80003f74:	b08ff0ef          	jal	8000327c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003f78:	46e1                	li	a3,24
    80003f7a:	fb840613          	addi	a2,s0,-72
    80003f7e:	85ce                	mv	a1,s3
    80003f80:	05093503          	ld	a0,80(s2)
    80003f84:	ddcfd0ef          	jal	80001560 <copyout>
    80003f88:	41f5551b          	sraiw	a0,a0,0x1f
    80003f8c:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003f8e:	60a6                	ld	ra,72(sp)
    80003f90:	6406                	ld	s0,64(sp)
    80003f92:	74e2                	ld	s1,56(sp)
    80003f94:	79a2                	ld	s3,40(sp)
    80003f96:	6161                	addi	sp,sp,80
    80003f98:	8082                	ret
  return -1;
    80003f9a:	557d                	li	a0,-1
    80003f9c:	bfcd                	j	80003f8e <filestat+0x4e>

0000000080003f9e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003f9e:	7179                	addi	sp,sp,-48
    80003fa0:	f406                	sd	ra,40(sp)
    80003fa2:	f022                	sd	s0,32(sp)
    80003fa4:	e84a                	sd	s2,16(sp)
    80003fa6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003fa8:	00854783          	lbu	a5,8(a0)
    80003fac:	cfd1                	beqz	a5,80004048 <fileread+0xaa>
    80003fae:	ec26                	sd	s1,24(sp)
    80003fb0:	e44e                	sd	s3,8(sp)
    80003fb2:	84aa                	mv	s1,a0
    80003fb4:	89ae                	mv	s3,a1
    80003fb6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003fb8:	411c                	lw	a5,0(a0)
    80003fba:	4705                	li	a4,1
    80003fbc:	04e78363          	beq	a5,a4,80004002 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003fc0:	470d                	li	a4,3
    80003fc2:	04e78763          	beq	a5,a4,80004010 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003fc6:	4709                	li	a4,2
    80003fc8:	06e79a63          	bne	a5,a4,8000403c <fileread+0x9e>
    ilock(f->ip);
    80003fcc:	6d08                	ld	a0,24(a0)
    80003fce:	a00ff0ef          	jal	800031ce <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003fd2:	874a                	mv	a4,s2
    80003fd4:	5094                	lw	a3,32(s1)
    80003fd6:	864e                	mv	a2,s3
    80003fd8:	4585                	li	a1,1
    80003fda:	6c88                	ld	a0,24(s1)
    80003fdc:	c46ff0ef          	jal	80003422 <readi>
    80003fe0:	892a                	mv	s2,a0
    80003fe2:	00a05563          	blez	a0,80003fec <fileread+0x4e>
      f->off += r;
    80003fe6:	509c                	lw	a5,32(s1)
    80003fe8:	9fa9                	addw	a5,a5,a0
    80003fea:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003fec:	6c88                	ld	a0,24(s1)
    80003fee:	a8eff0ef          	jal	8000327c <iunlock>
    80003ff2:	64e2                	ld	s1,24(sp)
    80003ff4:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003ff6:	854a                	mv	a0,s2
    80003ff8:	70a2                	ld	ra,40(sp)
    80003ffa:	7402                	ld	s0,32(sp)
    80003ffc:	6942                	ld	s2,16(sp)
    80003ffe:	6145                	addi	sp,sp,48
    80004000:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004002:	6908                	ld	a0,16(a0)
    80004004:	388000ef          	jal	8000438c <piperead>
    80004008:	892a                	mv	s2,a0
    8000400a:	64e2                	ld	s1,24(sp)
    8000400c:	69a2                	ld	s3,8(sp)
    8000400e:	b7e5                	j	80003ff6 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004010:	02451783          	lh	a5,36(a0)
    80004014:	03079693          	slli	a3,a5,0x30
    80004018:	92c1                	srli	a3,a3,0x30
    8000401a:	4725                	li	a4,9
    8000401c:	02d76863          	bltu	a4,a3,8000404c <fileread+0xae>
    80004020:	0792                	slli	a5,a5,0x4
    80004022:	0001e717          	auipc	a4,0x1e
    80004026:	3c670713          	addi	a4,a4,966 # 800223e8 <devsw>
    8000402a:	97ba                	add	a5,a5,a4
    8000402c:	639c                	ld	a5,0(a5)
    8000402e:	c39d                	beqz	a5,80004054 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004030:	4505                	li	a0,1
    80004032:	9782                	jalr	a5
    80004034:	892a                	mv	s2,a0
    80004036:	64e2                	ld	s1,24(sp)
    80004038:	69a2                	ld	s3,8(sp)
    8000403a:	bf75                	j	80003ff6 <fileread+0x58>
    panic("fileread");
    8000403c:	00003517          	auipc	a0,0x3
    80004040:	59c50513          	addi	a0,a0,1436 # 800075d8 <etext+0x5d8>
    80004044:	f5efc0ef          	jal	800007a2 <panic>
    return -1;
    80004048:	597d                	li	s2,-1
    8000404a:	b775                	j	80003ff6 <fileread+0x58>
      return -1;
    8000404c:	597d                	li	s2,-1
    8000404e:	64e2                	ld	s1,24(sp)
    80004050:	69a2                	ld	s3,8(sp)
    80004052:	b755                	j	80003ff6 <fileread+0x58>
    80004054:	597d                	li	s2,-1
    80004056:	64e2                	ld	s1,24(sp)
    80004058:	69a2                	ld	s3,8(sp)
    8000405a:	bf71                	j	80003ff6 <fileread+0x58>

000000008000405c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000405c:	00954783          	lbu	a5,9(a0)
    80004060:	10078b63          	beqz	a5,80004176 <filewrite+0x11a>
{
    80004064:	715d                	addi	sp,sp,-80
    80004066:	e486                	sd	ra,72(sp)
    80004068:	e0a2                	sd	s0,64(sp)
    8000406a:	f84a                	sd	s2,48(sp)
    8000406c:	f052                	sd	s4,32(sp)
    8000406e:	e85a                	sd	s6,16(sp)
    80004070:	0880                	addi	s0,sp,80
    80004072:	892a                	mv	s2,a0
    80004074:	8b2e                	mv	s6,a1
    80004076:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004078:	411c                	lw	a5,0(a0)
    8000407a:	4705                	li	a4,1
    8000407c:	02e78763          	beq	a5,a4,800040aa <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004080:	470d                	li	a4,3
    80004082:	02e78863          	beq	a5,a4,800040b2 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004086:	4709                	li	a4,2
    80004088:	0ce79c63          	bne	a5,a4,80004160 <filewrite+0x104>
    8000408c:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000408e:	0ac05863          	blez	a2,8000413e <filewrite+0xe2>
    80004092:	fc26                	sd	s1,56(sp)
    80004094:	ec56                	sd	s5,24(sp)
    80004096:	e45e                	sd	s7,8(sp)
    80004098:	e062                	sd	s8,0(sp)
    int i = 0;
    8000409a:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000409c:	6b85                	lui	s7,0x1
    8000409e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800040a2:	6c05                	lui	s8,0x1
    800040a4:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800040a8:	a8b5                	j	80004124 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800040aa:	6908                	ld	a0,16(a0)
    800040ac:	1fc000ef          	jal	800042a8 <pipewrite>
    800040b0:	a04d                	j	80004152 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800040b2:	02451783          	lh	a5,36(a0)
    800040b6:	03079693          	slli	a3,a5,0x30
    800040ba:	92c1                	srli	a3,a3,0x30
    800040bc:	4725                	li	a4,9
    800040be:	0ad76e63          	bltu	a4,a3,8000417a <filewrite+0x11e>
    800040c2:	0792                	slli	a5,a5,0x4
    800040c4:	0001e717          	auipc	a4,0x1e
    800040c8:	32470713          	addi	a4,a4,804 # 800223e8 <devsw>
    800040cc:	97ba                	add	a5,a5,a4
    800040ce:	679c                	ld	a5,8(a5)
    800040d0:	c7dd                	beqz	a5,8000417e <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800040d2:	4505                	li	a0,1
    800040d4:	9782                	jalr	a5
    800040d6:	a8b5                	j	80004152 <filewrite+0xf6>
      if(n1 > max)
    800040d8:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800040dc:	989ff0ef          	jal	80003a64 <begin_op>
      ilock(f->ip);
    800040e0:	01893503          	ld	a0,24(s2)
    800040e4:	8eaff0ef          	jal	800031ce <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800040e8:	8756                	mv	a4,s5
    800040ea:	02092683          	lw	a3,32(s2)
    800040ee:	01698633          	add	a2,s3,s6
    800040f2:	4585                	li	a1,1
    800040f4:	01893503          	ld	a0,24(s2)
    800040f8:	c26ff0ef          	jal	8000351e <writei>
    800040fc:	84aa                	mv	s1,a0
    800040fe:	00a05763          	blez	a0,8000410c <filewrite+0xb0>
        f->off += r;
    80004102:	02092783          	lw	a5,32(s2)
    80004106:	9fa9                	addw	a5,a5,a0
    80004108:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000410c:	01893503          	ld	a0,24(s2)
    80004110:	96cff0ef          	jal	8000327c <iunlock>
      end_op();
    80004114:	9bbff0ef          	jal	80003ace <end_op>

      if(r != n1){
    80004118:	029a9563          	bne	s5,s1,80004142 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    8000411c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004120:	0149da63          	bge	s3,s4,80004134 <filewrite+0xd8>
      int n1 = n - i;
    80004124:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004128:	0004879b          	sext.w	a5,s1
    8000412c:	fafbd6e3          	bge	s7,a5,800040d8 <filewrite+0x7c>
    80004130:	84e2                	mv	s1,s8
    80004132:	b75d                	j	800040d8 <filewrite+0x7c>
    80004134:	74e2                	ld	s1,56(sp)
    80004136:	6ae2                	ld	s5,24(sp)
    80004138:	6ba2                	ld	s7,8(sp)
    8000413a:	6c02                	ld	s8,0(sp)
    8000413c:	a039                	j	8000414a <filewrite+0xee>
    int i = 0;
    8000413e:	4981                	li	s3,0
    80004140:	a029                	j	8000414a <filewrite+0xee>
    80004142:	74e2                	ld	s1,56(sp)
    80004144:	6ae2                	ld	s5,24(sp)
    80004146:	6ba2                	ld	s7,8(sp)
    80004148:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000414a:	033a1c63          	bne	s4,s3,80004182 <filewrite+0x126>
    8000414e:	8552                	mv	a0,s4
    80004150:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004152:	60a6                	ld	ra,72(sp)
    80004154:	6406                	ld	s0,64(sp)
    80004156:	7942                	ld	s2,48(sp)
    80004158:	7a02                	ld	s4,32(sp)
    8000415a:	6b42                	ld	s6,16(sp)
    8000415c:	6161                	addi	sp,sp,80
    8000415e:	8082                	ret
    80004160:	fc26                	sd	s1,56(sp)
    80004162:	f44e                	sd	s3,40(sp)
    80004164:	ec56                	sd	s5,24(sp)
    80004166:	e45e                	sd	s7,8(sp)
    80004168:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000416a:	00003517          	auipc	a0,0x3
    8000416e:	47e50513          	addi	a0,a0,1150 # 800075e8 <etext+0x5e8>
    80004172:	e30fc0ef          	jal	800007a2 <panic>
    return -1;
    80004176:	557d                	li	a0,-1
}
    80004178:	8082                	ret
      return -1;
    8000417a:	557d                	li	a0,-1
    8000417c:	bfd9                	j	80004152 <filewrite+0xf6>
    8000417e:	557d                	li	a0,-1
    80004180:	bfc9                	j	80004152 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80004182:	557d                	li	a0,-1
    80004184:	79a2                	ld	s3,40(sp)
    80004186:	b7f1                	j	80004152 <filewrite+0xf6>

0000000080004188 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004188:	7179                	addi	sp,sp,-48
    8000418a:	f406                	sd	ra,40(sp)
    8000418c:	f022                	sd	s0,32(sp)
    8000418e:	ec26                	sd	s1,24(sp)
    80004190:	e052                	sd	s4,0(sp)
    80004192:	1800                	addi	s0,sp,48
    80004194:	84aa                	mv	s1,a0
    80004196:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004198:	0005b023          	sd	zero,0(a1)
    8000419c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800041a0:	c3bff0ef          	jal	80003dda <filealloc>
    800041a4:	e088                	sd	a0,0(s1)
    800041a6:	c549                	beqz	a0,80004230 <pipealloc+0xa8>
    800041a8:	c33ff0ef          	jal	80003dda <filealloc>
    800041ac:	00aa3023          	sd	a0,0(s4)
    800041b0:	cd25                	beqz	a0,80004228 <pipealloc+0xa0>
    800041b2:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800041b4:	97ffc0ef          	jal	80000b32 <kalloc>
    800041b8:	892a                	mv	s2,a0
    800041ba:	c12d                	beqz	a0,8000421c <pipealloc+0x94>
    800041bc:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800041be:	4985                	li	s3,1
    800041c0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800041c4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800041c8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800041cc:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800041d0:	00003597          	auipc	a1,0x3
    800041d4:	42858593          	addi	a1,a1,1064 # 800075f8 <etext+0x5f8>
    800041d8:	9abfc0ef          	jal	80000b82 <initlock>
  (*f0)->type = FD_PIPE;
    800041dc:	609c                	ld	a5,0(s1)
    800041de:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800041e2:	609c                	ld	a5,0(s1)
    800041e4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800041e8:	609c                	ld	a5,0(s1)
    800041ea:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800041ee:	609c                	ld	a5,0(s1)
    800041f0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800041f4:	000a3783          	ld	a5,0(s4)
    800041f8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800041fc:	000a3783          	ld	a5,0(s4)
    80004200:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004204:	000a3783          	ld	a5,0(s4)
    80004208:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000420c:	000a3783          	ld	a5,0(s4)
    80004210:	0127b823          	sd	s2,16(a5)
  return 0;
    80004214:	4501                	li	a0,0
    80004216:	6942                	ld	s2,16(sp)
    80004218:	69a2                	ld	s3,8(sp)
    8000421a:	a01d                	j	80004240 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000421c:	6088                	ld	a0,0(s1)
    8000421e:	c119                	beqz	a0,80004224 <pipealloc+0x9c>
    80004220:	6942                	ld	s2,16(sp)
    80004222:	a029                	j	8000422c <pipealloc+0xa4>
    80004224:	6942                	ld	s2,16(sp)
    80004226:	a029                	j	80004230 <pipealloc+0xa8>
    80004228:	6088                	ld	a0,0(s1)
    8000422a:	c10d                	beqz	a0,8000424c <pipealloc+0xc4>
    fileclose(*f0);
    8000422c:	c53ff0ef          	jal	80003e7e <fileclose>
  if(*f1)
    80004230:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004234:	557d                	li	a0,-1
  if(*f1)
    80004236:	c789                	beqz	a5,80004240 <pipealloc+0xb8>
    fileclose(*f1);
    80004238:	853e                	mv	a0,a5
    8000423a:	c45ff0ef          	jal	80003e7e <fileclose>
  return -1;
    8000423e:	557d                	li	a0,-1
}
    80004240:	70a2                	ld	ra,40(sp)
    80004242:	7402                	ld	s0,32(sp)
    80004244:	64e2                	ld	s1,24(sp)
    80004246:	6a02                	ld	s4,0(sp)
    80004248:	6145                	addi	sp,sp,48
    8000424a:	8082                	ret
  return -1;
    8000424c:	557d                	li	a0,-1
    8000424e:	bfcd                	j	80004240 <pipealloc+0xb8>

0000000080004250 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004250:	1101                	addi	sp,sp,-32
    80004252:	ec06                	sd	ra,24(sp)
    80004254:	e822                	sd	s0,16(sp)
    80004256:	e426                	sd	s1,8(sp)
    80004258:	e04a                	sd	s2,0(sp)
    8000425a:	1000                	addi	s0,sp,32
    8000425c:	84aa                	mv	s1,a0
    8000425e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004260:	9a3fc0ef          	jal	80000c02 <acquire>
  if(writable){
    80004264:	02090763          	beqz	s2,80004292 <pipeclose+0x42>
    pi->writeopen = 0;
    80004268:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000426c:	21848513          	addi	a0,s1,536
    80004270:	c99fd0ef          	jal	80001f08 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004274:	2204b783          	ld	a5,544(s1)
    80004278:	e785                	bnez	a5,800042a0 <pipeclose+0x50>
    release(&pi->lock);
    8000427a:	8526                	mv	a0,s1
    8000427c:	a1ffc0ef          	jal	80000c9a <release>
    kfree((char*)pi);
    80004280:	8526                	mv	a0,s1
    80004282:	fcefc0ef          	jal	80000a50 <kfree>
  } else
    release(&pi->lock);
}
    80004286:	60e2                	ld	ra,24(sp)
    80004288:	6442                	ld	s0,16(sp)
    8000428a:	64a2                	ld	s1,8(sp)
    8000428c:	6902                	ld	s2,0(sp)
    8000428e:	6105                	addi	sp,sp,32
    80004290:	8082                	ret
    pi->readopen = 0;
    80004292:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004296:	21c48513          	addi	a0,s1,540
    8000429a:	c6ffd0ef          	jal	80001f08 <wakeup>
    8000429e:	bfd9                	j	80004274 <pipeclose+0x24>
    release(&pi->lock);
    800042a0:	8526                	mv	a0,s1
    800042a2:	9f9fc0ef          	jal	80000c9a <release>
}
    800042a6:	b7c5                	j	80004286 <pipeclose+0x36>

00000000800042a8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800042a8:	711d                	addi	sp,sp,-96
    800042aa:	ec86                	sd	ra,88(sp)
    800042ac:	e8a2                	sd	s0,80(sp)
    800042ae:	e4a6                	sd	s1,72(sp)
    800042b0:	e0ca                	sd	s2,64(sp)
    800042b2:	fc4e                	sd	s3,56(sp)
    800042b4:	f852                	sd	s4,48(sp)
    800042b6:	f456                	sd	s5,40(sp)
    800042b8:	1080                	addi	s0,sp,96
    800042ba:	84aa                	mv	s1,a0
    800042bc:	8aae                	mv	s5,a1
    800042be:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800042c0:	e2efd0ef          	jal	800018ee <myproc>
    800042c4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800042c6:	8526                	mv	a0,s1
    800042c8:	93bfc0ef          	jal	80000c02 <acquire>
  while(i < n){
    800042cc:	0b405a63          	blez	s4,80004380 <pipewrite+0xd8>
    800042d0:	f05a                	sd	s6,32(sp)
    800042d2:	ec5e                	sd	s7,24(sp)
    800042d4:	e862                	sd	s8,16(sp)
  int i = 0;
    800042d6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800042d8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800042da:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800042de:	21c48b93          	addi	s7,s1,540
    800042e2:	a81d                	j	80004318 <pipewrite+0x70>
      release(&pi->lock);
    800042e4:	8526                	mv	a0,s1
    800042e6:	9b5fc0ef          	jal	80000c9a <release>
      return -1;
    800042ea:	597d                	li	s2,-1
    800042ec:	7b02                	ld	s6,32(sp)
    800042ee:	6be2                	ld	s7,24(sp)
    800042f0:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800042f2:	854a                	mv	a0,s2
    800042f4:	60e6                	ld	ra,88(sp)
    800042f6:	6446                	ld	s0,80(sp)
    800042f8:	64a6                	ld	s1,72(sp)
    800042fa:	6906                	ld	s2,64(sp)
    800042fc:	79e2                	ld	s3,56(sp)
    800042fe:	7a42                	ld	s4,48(sp)
    80004300:	7aa2                	ld	s5,40(sp)
    80004302:	6125                	addi	sp,sp,96
    80004304:	8082                	ret
      wakeup(&pi->nread);
    80004306:	8562                	mv	a0,s8
    80004308:	c01fd0ef          	jal	80001f08 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000430c:	85a6                	mv	a1,s1
    8000430e:	855e                	mv	a0,s7
    80004310:	badfd0ef          	jal	80001ebc <sleep>
  while(i < n){
    80004314:	05495b63          	bge	s2,s4,8000436a <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80004318:	2204a783          	lw	a5,544(s1)
    8000431c:	d7e1                	beqz	a5,800042e4 <pipewrite+0x3c>
    8000431e:	854e                	mv	a0,s3
    80004320:	dd5fd0ef          	jal	800020f4 <killed>
    80004324:	f161                	bnez	a0,800042e4 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004326:	2184a783          	lw	a5,536(s1)
    8000432a:	21c4a703          	lw	a4,540(s1)
    8000432e:	2007879b          	addiw	a5,a5,512
    80004332:	fcf70ae3          	beq	a4,a5,80004306 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004336:	4685                	li	a3,1
    80004338:	01590633          	add	a2,s2,s5
    8000433c:	faf40593          	addi	a1,s0,-81
    80004340:	0509b503          	ld	a0,80(s3)
    80004344:	af2fd0ef          	jal	80001636 <copyin>
    80004348:	03650e63          	beq	a0,s6,80004384 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000434c:	21c4a783          	lw	a5,540(s1)
    80004350:	0017871b          	addiw	a4,a5,1
    80004354:	20e4ae23          	sw	a4,540(s1)
    80004358:	1ff7f793          	andi	a5,a5,511
    8000435c:	97a6                	add	a5,a5,s1
    8000435e:	faf44703          	lbu	a4,-81(s0)
    80004362:	00e78c23          	sb	a4,24(a5)
      i++;
    80004366:	2905                	addiw	s2,s2,1
    80004368:	b775                	j	80004314 <pipewrite+0x6c>
    8000436a:	7b02                	ld	s6,32(sp)
    8000436c:	6be2                	ld	s7,24(sp)
    8000436e:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004370:	21848513          	addi	a0,s1,536
    80004374:	b95fd0ef          	jal	80001f08 <wakeup>
  release(&pi->lock);
    80004378:	8526                	mv	a0,s1
    8000437a:	921fc0ef          	jal	80000c9a <release>
  return i;
    8000437e:	bf95                	j	800042f2 <pipewrite+0x4a>
  int i = 0;
    80004380:	4901                	li	s2,0
    80004382:	b7fd                	j	80004370 <pipewrite+0xc8>
    80004384:	7b02                	ld	s6,32(sp)
    80004386:	6be2                	ld	s7,24(sp)
    80004388:	6c42                	ld	s8,16(sp)
    8000438a:	b7dd                	j	80004370 <pipewrite+0xc8>

000000008000438c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000438c:	715d                	addi	sp,sp,-80
    8000438e:	e486                	sd	ra,72(sp)
    80004390:	e0a2                	sd	s0,64(sp)
    80004392:	fc26                	sd	s1,56(sp)
    80004394:	f84a                	sd	s2,48(sp)
    80004396:	f44e                	sd	s3,40(sp)
    80004398:	f052                	sd	s4,32(sp)
    8000439a:	ec56                	sd	s5,24(sp)
    8000439c:	0880                	addi	s0,sp,80
    8000439e:	84aa                	mv	s1,a0
    800043a0:	892e                	mv	s2,a1
    800043a2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800043a4:	d4afd0ef          	jal	800018ee <myproc>
    800043a8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800043aa:	8526                	mv	a0,s1
    800043ac:	857fc0ef          	jal	80000c02 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043b0:	2184a703          	lw	a4,536(s1)
    800043b4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800043b8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043bc:	02f71563          	bne	a4,a5,800043e6 <piperead+0x5a>
    800043c0:	2244a783          	lw	a5,548(s1)
    800043c4:	cb85                	beqz	a5,800043f4 <piperead+0x68>
    if(killed(pr)){
    800043c6:	8552                	mv	a0,s4
    800043c8:	d2dfd0ef          	jal	800020f4 <killed>
    800043cc:	ed19                	bnez	a0,800043ea <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800043ce:	85a6                	mv	a1,s1
    800043d0:	854e                	mv	a0,s3
    800043d2:	aebfd0ef          	jal	80001ebc <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043d6:	2184a703          	lw	a4,536(s1)
    800043da:	21c4a783          	lw	a5,540(s1)
    800043de:	fef701e3          	beq	a4,a5,800043c0 <piperead+0x34>
    800043e2:	e85a                	sd	s6,16(sp)
    800043e4:	a809                	j	800043f6 <piperead+0x6a>
    800043e6:	e85a                	sd	s6,16(sp)
    800043e8:	a039                	j	800043f6 <piperead+0x6a>
      release(&pi->lock);
    800043ea:	8526                	mv	a0,s1
    800043ec:	8affc0ef          	jal	80000c9a <release>
      return -1;
    800043f0:	59fd                	li	s3,-1
    800043f2:	a8b1                	j	8000444e <piperead+0xc2>
    800043f4:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800043f6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800043f8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800043fa:	05505263          	blez	s5,8000443e <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800043fe:	2184a783          	lw	a5,536(s1)
    80004402:	21c4a703          	lw	a4,540(s1)
    80004406:	02f70c63          	beq	a4,a5,8000443e <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000440a:	0017871b          	addiw	a4,a5,1
    8000440e:	20e4ac23          	sw	a4,536(s1)
    80004412:	1ff7f793          	andi	a5,a5,511
    80004416:	97a6                	add	a5,a5,s1
    80004418:	0187c783          	lbu	a5,24(a5)
    8000441c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004420:	4685                	li	a3,1
    80004422:	fbf40613          	addi	a2,s0,-65
    80004426:	85ca                	mv	a1,s2
    80004428:	050a3503          	ld	a0,80(s4)
    8000442c:	934fd0ef          	jal	80001560 <copyout>
    80004430:	01650763          	beq	a0,s6,8000443e <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004434:	2985                	addiw	s3,s3,1
    80004436:	0905                	addi	s2,s2,1
    80004438:	fd3a93e3          	bne	s5,s3,800043fe <piperead+0x72>
    8000443c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000443e:	21c48513          	addi	a0,s1,540
    80004442:	ac7fd0ef          	jal	80001f08 <wakeup>
  release(&pi->lock);
    80004446:	8526                	mv	a0,s1
    80004448:	853fc0ef          	jal	80000c9a <release>
    8000444c:	6b42                	ld	s6,16(sp)
  return i;
}
    8000444e:	854e                	mv	a0,s3
    80004450:	60a6                	ld	ra,72(sp)
    80004452:	6406                	ld	s0,64(sp)
    80004454:	74e2                	ld	s1,56(sp)
    80004456:	7942                	ld	s2,48(sp)
    80004458:	79a2                	ld	s3,40(sp)
    8000445a:	7a02                	ld	s4,32(sp)
    8000445c:	6ae2                	ld	s5,24(sp)
    8000445e:	6161                	addi	sp,sp,80
    80004460:	8082                	ret

0000000080004462 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004462:	1141                	addi	sp,sp,-16
    80004464:	e422                	sd	s0,8(sp)
    80004466:	0800                	addi	s0,sp,16
    80004468:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000446a:	8905                	andi	a0,a0,1
    8000446c:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000446e:	8b89                	andi	a5,a5,2
    80004470:	c399                	beqz	a5,80004476 <flags2perm+0x14>
      perm |= PTE_W;
    80004472:	00456513          	ori	a0,a0,4
    return perm;
}
    80004476:	6422                	ld	s0,8(sp)
    80004478:	0141                	addi	sp,sp,16
    8000447a:	8082                	ret

000000008000447c <exec>:

int
exec(char *path, char **argv)
{
    8000447c:	df010113          	addi	sp,sp,-528
    80004480:	20113423          	sd	ra,520(sp)
    80004484:	20813023          	sd	s0,512(sp)
    80004488:	ffa6                	sd	s1,504(sp)
    8000448a:	fbca                	sd	s2,496(sp)
    8000448c:	0c00                	addi	s0,sp,528
    8000448e:	892a                	mv	s2,a0
    80004490:	dea43c23          	sd	a0,-520(s0)
    80004494:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004498:	c56fd0ef          	jal	800018ee <myproc>
    8000449c:	84aa                	mv	s1,a0

  begin_op();
    8000449e:	dc6ff0ef          	jal	80003a64 <begin_op>

  if((ip = namei(path)) == 0){
    800044a2:	854a                	mv	a0,s2
    800044a4:	c04ff0ef          	jal	800038a8 <namei>
    800044a8:	c931                	beqz	a0,800044fc <exec+0x80>
    800044aa:	f3d2                	sd	s4,480(sp)
    800044ac:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800044ae:	d21fe0ef          	jal	800031ce <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800044b2:	04000713          	li	a4,64
    800044b6:	4681                	li	a3,0
    800044b8:	e5040613          	addi	a2,s0,-432
    800044bc:	4581                	li	a1,0
    800044be:	8552                	mv	a0,s4
    800044c0:	f63fe0ef          	jal	80003422 <readi>
    800044c4:	04000793          	li	a5,64
    800044c8:	00f51a63          	bne	a0,a5,800044dc <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800044cc:	e5042703          	lw	a4,-432(s0)
    800044d0:	464c47b7          	lui	a5,0x464c4
    800044d4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800044d8:	02f70663          	beq	a4,a5,80004504 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800044dc:	8552                	mv	a0,s4
    800044de:	efbfe0ef          	jal	800033d8 <iunlockput>
    end_op();
    800044e2:	decff0ef          	jal	80003ace <end_op>
  }
  return -1;
    800044e6:	557d                	li	a0,-1
    800044e8:	7a1e                	ld	s4,480(sp)
}
    800044ea:	20813083          	ld	ra,520(sp)
    800044ee:	20013403          	ld	s0,512(sp)
    800044f2:	74fe                	ld	s1,504(sp)
    800044f4:	795e                	ld	s2,496(sp)
    800044f6:	21010113          	addi	sp,sp,528
    800044fa:	8082                	ret
    end_op();
    800044fc:	dd2ff0ef          	jal	80003ace <end_op>
    return -1;
    80004500:	557d                	li	a0,-1
    80004502:	b7e5                	j	800044ea <exec+0x6e>
    80004504:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004506:	8526                	mv	a0,s1
    80004508:	c8efd0ef          	jal	80001996 <proc_pagetable>
    8000450c:	8b2a                	mv	s6,a0
    8000450e:	2c050b63          	beqz	a0,800047e4 <exec+0x368>
    80004512:	f7ce                	sd	s3,488(sp)
    80004514:	efd6                	sd	s5,472(sp)
    80004516:	e7de                	sd	s7,456(sp)
    80004518:	e3e2                	sd	s8,448(sp)
    8000451a:	ff66                	sd	s9,440(sp)
    8000451c:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000451e:	e7042d03          	lw	s10,-400(s0)
    80004522:	e8845783          	lhu	a5,-376(s0)
    80004526:	12078963          	beqz	a5,80004658 <exec+0x1dc>
    8000452a:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000452c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000452e:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004530:	6c85                	lui	s9,0x1
    80004532:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004536:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000453a:	6a85                	lui	s5,0x1
    8000453c:	a085                	j	8000459c <exec+0x120>
      panic("loadseg: address should exist");
    8000453e:	00003517          	auipc	a0,0x3
    80004542:	0c250513          	addi	a0,a0,194 # 80007600 <etext+0x600>
    80004546:	a5cfc0ef          	jal	800007a2 <panic>
    if(sz - i < PGSIZE)
    8000454a:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000454c:	8726                	mv	a4,s1
    8000454e:	012c06bb          	addw	a3,s8,s2
    80004552:	4581                	li	a1,0
    80004554:	8552                	mv	a0,s4
    80004556:	ecdfe0ef          	jal	80003422 <readi>
    8000455a:	2501                	sext.w	a0,a0
    8000455c:	24a49a63          	bne	s1,a0,800047b0 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80004560:	012a893b          	addw	s2,s5,s2
    80004564:	03397363          	bgeu	s2,s3,8000458a <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80004568:	02091593          	slli	a1,s2,0x20
    8000456c:	9181                	srli	a1,a1,0x20
    8000456e:	95de                	add	a1,a1,s7
    80004570:	855a                	mv	a0,s6
    80004572:	a73fc0ef          	jal	80000fe4 <walkaddr>
    80004576:	862a                	mv	a2,a0
    if(pa == 0)
    80004578:	d179                	beqz	a0,8000453e <exec+0xc2>
    if(sz - i < PGSIZE)
    8000457a:	412984bb          	subw	s1,s3,s2
    8000457e:	0004879b          	sext.w	a5,s1
    80004582:	fcfcf4e3          	bgeu	s9,a5,8000454a <exec+0xce>
    80004586:	84d6                	mv	s1,s5
    80004588:	b7c9                	j	8000454a <exec+0xce>
    sz = sz1;
    8000458a:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000458e:	2d85                	addiw	s11,s11,1
    80004590:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004594:	e8845783          	lhu	a5,-376(s0)
    80004598:	08fdd063          	bge	s11,a5,80004618 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000459c:	2d01                	sext.w	s10,s10
    8000459e:	03800713          	li	a4,56
    800045a2:	86ea                	mv	a3,s10
    800045a4:	e1840613          	addi	a2,s0,-488
    800045a8:	4581                	li	a1,0
    800045aa:	8552                	mv	a0,s4
    800045ac:	e77fe0ef          	jal	80003422 <readi>
    800045b0:	03800793          	li	a5,56
    800045b4:	1cf51663          	bne	a0,a5,80004780 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    800045b8:	e1842783          	lw	a5,-488(s0)
    800045bc:	4705                	li	a4,1
    800045be:	fce798e3          	bne	a5,a4,8000458e <exec+0x112>
    if(ph.memsz < ph.filesz)
    800045c2:	e4043483          	ld	s1,-448(s0)
    800045c6:	e3843783          	ld	a5,-456(s0)
    800045ca:	1af4ef63          	bltu	s1,a5,80004788 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045ce:	e2843783          	ld	a5,-472(s0)
    800045d2:	94be                	add	s1,s1,a5
    800045d4:	1af4ee63          	bltu	s1,a5,80004790 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    800045d8:	df043703          	ld	a4,-528(s0)
    800045dc:	8ff9                	and	a5,a5,a4
    800045de:	1a079d63          	bnez	a5,80004798 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800045e2:	e1c42503          	lw	a0,-484(s0)
    800045e6:	e7dff0ef          	jal	80004462 <flags2perm>
    800045ea:	86aa                	mv	a3,a0
    800045ec:	8626                	mv	a2,s1
    800045ee:	85ca                	mv	a1,s2
    800045f0:	855a                	mv	a0,s6
    800045f2:	d5bfc0ef          	jal	8000134c <uvmalloc>
    800045f6:	e0a43423          	sd	a0,-504(s0)
    800045fa:	1a050363          	beqz	a0,800047a0 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800045fe:	e2843b83          	ld	s7,-472(s0)
    80004602:	e2042c03          	lw	s8,-480(s0)
    80004606:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000460a:	00098463          	beqz	s3,80004612 <exec+0x196>
    8000460e:	4901                	li	s2,0
    80004610:	bfa1                	j	80004568 <exec+0xec>
    sz = sz1;
    80004612:	e0843903          	ld	s2,-504(s0)
    80004616:	bfa5                	j	8000458e <exec+0x112>
    80004618:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000461a:	8552                	mv	a0,s4
    8000461c:	dbdfe0ef          	jal	800033d8 <iunlockput>
  end_op();
    80004620:	caeff0ef          	jal	80003ace <end_op>
  p = myproc();
    80004624:	acafd0ef          	jal	800018ee <myproc>
    80004628:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000462a:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000462e:	6985                	lui	s3,0x1
    80004630:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004632:	99ca                	add	s3,s3,s2
    80004634:	77fd                	lui	a5,0xfffff
    80004636:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000463a:	4691                	li	a3,4
    8000463c:	6609                	lui	a2,0x2
    8000463e:	964e                	add	a2,a2,s3
    80004640:	85ce                	mv	a1,s3
    80004642:	855a                	mv	a0,s6
    80004644:	d09fc0ef          	jal	8000134c <uvmalloc>
    80004648:	892a                	mv	s2,a0
    8000464a:	e0a43423          	sd	a0,-504(s0)
    8000464e:	e519                	bnez	a0,8000465c <exec+0x1e0>
  if(pagetable)
    80004650:	e1343423          	sd	s3,-504(s0)
    80004654:	4a01                	li	s4,0
    80004656:	aab1                	j	800047b2 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004658:	4901                	li	s2,0
    8000465a:	b7c1                	j	8000461a <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    8000465c:	75f9                	lui	a1,0xffffe
    8000465e:	95aa                	add	a1,a1,a0
    80004660:	855a                	mv	a0,s6
    80004662:	ed5fc0ef          	jal	80001536 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004666:	7bfd                	lui	s7,0xfffff
    80004668:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000466a:	e0043783          	ld	a5,-512(s0)
    8000466e:	6388                	ld	a0,0(a5)
    80004670:	cd39                	beqz	a0,800046ce <exec+0x252>
    80004672:	e9040993          	addi	s3,s0,-368
    80004676:	f9040c13          	addi	s8,s0,-112
    8000467a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000467c:	fcafc0ef          	jal	80000e46 <strlen>
    80004680:	0015079b          	addiw	a5,a0,1
    80004684:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004688:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000468c:	11796e63          	bltu	s2,s7,800047a8 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004690:	e0043d03          	ld	s10,-512(s0)
    80004694:	000d3a03          	ld	s4,0(s10)
    80004698:	8552                	mv	a0,s4
    8000469a:	facfc0ef          	jal	80000e46 <strlen>
    8000469e:	0015069b          	addiw	a3,a0,1
    800046a2:	8652                	mv	a2,s4
    800046a4:	85ca                	mv	a1,s2
    800046a6:	855a                	mv	a0,s6
    800046a8:	eb9fc0ef          	jal	80001560 <copyout>
    800046ac:	10054063          	bltz	a0,800047ac <exec+0x330>
    ustack[argc] = sp;
    800046b0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800046b4:	0485                	addi	s1,s1,1
    800046b6:	008d0793          	addi	a5,s10,8
    800046ba:	e0f43023          	sd	a5,-512(s0)
    800046be:	008d3503          	ld	a0,8(s10)
    800046c2:	c909                	beqz	a0,800046d4 <exec+0x258>
    if(argc >= MAXARG)
    800046c4:	09a1                	addi	s3,s3,8
    800046c6:	fb899be3          	bne	s3,s8,8000467c <exec+0x200>
  ip = 0;
    800046ca:	4a01                	li	s4,0
    800046cc:	a0dd                	j	800047b2 <exec+0x336>
  sp = sz;
    800046ce:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800046d2:	4481                	li	s1,0
  ustack[argc] = 0;
    800046d4:	00349793          	slli	a5,s1,0x3
    800046d8:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdba10>
    800046dc:	97a2                	add	a5,a5,s0
    800046de:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800046e2:	00148693          	addi	a3,s1,1
    800046e6:	068e                	slli	a3,a3,0x3
    800046e8:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800046ec:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800046f0:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800046f4:	f5796ee3          	bltu	s2,s7,80004650 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800046f8:	e9040613          	addi	a2,s0,-368
    800046fc:	85ca                	mv	a1,s2
    800046fe:	855a                	mv	a0,s6
    80004700:	e61fc0ef          	jal	80001560 <copyout>
    80004704:	0e054263          	bltz	a0,800047e8 <exec+0x36c>
  p->trapframe->a1 = sp;
    80004708:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000470c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004710:	df843783          	ld	a5,-520(s0)
    80004714:	0007c703          	lbu	a4,0(a5)
    80004718:	cf11                	beqz	a4,80004734 <exec+0x2b8>
    8000471a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000471c:	02f00693          	li	a3,47
    80004720:	a039                	j	8000472e <exec+0x2b2>
      last = s+1;
    80004722:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004726:	0785                	addi	a5,a5,1
    80004728:	fff7c703          	lbu	a4,-1(a5)
    8000472c:	c701                	beqz	a4,80004734 <exec+0x2b8>
    if(*s == '/')
    8000472e:	fed71ce3          	bne	a4,a3,80004726 <exec+0x2aa>
    80004732:	bfc5                	j	80004722 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004734:	4641                	li	a2,16
    80004736:	df843583          	ld	a1,-520(s0)
    8000473a:	158a8513          	addi	a0,s5,344
    8000473e:	ed6fc0ef          	jal	80000e14 <safestrcpy>
  oldpagetable = p->pagetable;
    80004742:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004746:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000474a:	e0843783          	ld	a5,-504(s0)
    8000474e:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004752:	058ab783          	ld	a5,88(s5)
    80004756:	e6843703          	ld	a4,-408(s0)
    8000475a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000475c:	058ab783          	ld	a5,88(s5)
    80004760:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004764:	85e6                	mv	a1,s9
    80004766:	ab4fd0ef          	jal	80001a1a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000476a:	0004851b          	sext.w	a0,s1
    8000476e:	79be                	ld	s3,488(sp)
    80004770:	7a1e                	ld	s4,480(sp)
    80004772:	6afe                	ld	s5,472(sp)
    80004774:	6b5e                	ld	s6,464(sp)
    80004776:	6bbe                	ld	s7,456(sp)
    80004778:	6c1e                	ld	s8,448(sp)
    8000477a:	7cfa                	ld	s9,440(sp)
    8000477c:	7d5a                	ld	s10,432(sp)
    8000477e:	b3b5                	j	800044ea <exec+0x6e>
    80004780:	e1243423          	sd	s2,-504(s0)
    80004784:	7dba                	ld	s11,424(sp)
    80004786:	a035                	j	800047b2 <exec+0x336>
    80004788:	e1243423          	sd	s2,-504(s0)
    8000478c:	7dba                	ld	s11,424(sp)
    8000478e:	a015                	j	800047b2 <exec+0x336>
    80004790:	e1243423          	sd	s2,-504(s0)
    80004794:	7dba                	ld	s11,424(sp)
    80004796:	a831                	j	800047b2 <exec+0x336>
    80004798:	e1243423          	sd	s2,-504(s0)
    8000479c:	7dba                	ld	s11,424(sp)
    8000479e:	a811                	j	800047b2 <exec+0x336>
    800047a0:	e1243423          	sd	s2,-504(s0)
    800047a4:	7dba                	ld	s11,424(sp)
    800047a6:	a031                	j	800047b2 <exec+0x336>
  ip = 0;
    800047a8:	4a01                	li	s4,0
    800047aa:	a021                	j	800047b2 <exec+0x336>
    800047ac:	4a01                	li	s4,0
  if(pagetable)
    800047ae:	a011                	j	800047b2 <exec+0x336>
    800047b0:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800047b2:	e0843583          	ld	a1,-504(s0)
    800047b6:	855a                	mv	a0,s6
    800047b8:	a62fd0ef          	jal	80001a1a <proc_freepagetable>
  return -1;
    800047bc:	557d                	li	a0,-1
  if(ip){
    800047be:	000a1b63          	bnez	s4,800047d4 <exec+0x358>
    800047c2:	79be                	ld	s3,488(sp)
    800047c4:	7a1e                	ld	s4,480(sp)
    800047c6:	6afe                	ld	s5,472(sp)
    800047c8:	6b5e                	ld	s6,464(sp)
    800047ca:	6bbe                	ld	s7,456(sp)
    800047cc:	6c1e                	ld	s8,448(sp)
    800047ce:	7cfa                	ld	s9,440(sp)
    800047d0:	7d5a                	ld	s10,432(sp)
    800047d2:	bb21                	j	800044ea <exec+0x6e>
    800047d4:	79be                	ld	s3,488(sp)
    800047d6:	6afe                	ld	s5,472(sp)
    800047d8:	6b5e                	ld	s6,464(sp)
    800047da:	6bbe                	ld	s7,456(sp)
    800047dc:	6c1e                	ld	s8,448(sp)
    800047de:	7cfa                	ld	s9,440(sp)
    800047e0:	7d5a                	ld	s10,432(sp)
    800047e2:	b9ed                	j	800044dc <exec+0x60>
    800047e4:	6b5e                	ld	s6,464(sp)
    800047e6:	b9dd                	j	800044dc <exec+0x60>
  sz = sz1;
    800047e8:	e0843983          	ld	s3,-504(s0)
    800047ec:	b595                	j	80004650 <exec+0x1d4>

00000000800047ee <argfd>:
    800047ee:	7179                	addi	sp,sp,-48
    800047f0:	f406                	sd	ra,40(sp)
    800047f2:	f022                	sd	s0,32(sp)
    800047f4:	ec26                	sd	s1,24(sp)
    800047f6:	e84a                	sd	s2,16(sp)
    800047f8:	1800                	addi	s0,sp,48
    800047fa:	892e                	mv	s2,a1
    800047fc:	84b2                	mv	s1,a2
    800047fe:	fdc40593          	addi	a1,s0,-36
    80004802:	fa1fd0ef          	jal	800027a2 <argint>
    80004806:	fdc42703          	lw	a4,-36(s0)
    8000480a:	47bd                	li	a5,15
    8000480c:	02e7e963          	bltu	a5,a4,8000483e <argfd+0x50>
    80004810:	8defd0ef          	jal	800018ee <myproc>
    80004814:	fdc42703          	lw	a4,-36(s0)
    80004818:	01a70793          	addi	a5,a4,26
    8000481c:	078e                	slli	a5,a5,0x3
    8000481e:	953e                	add	a0,a0,a5
    80004820:	611c                	ld	a5,0(a0)
    80004822:	c385                	beqz	a5,80004842 <argfd+0x54>
    80004824:	00090463          	beqz	s2,8000482c <argfd+0x3e>
    80004828:	00e92023          	sw	a4,0(s2)
    8000482c:	4501                	li	a0,0
    8000482e:	c091                	beqz	s1,80004832 <argfd+0x44>
    80004830:	e09c                	sd	a5,0(s1)
    80004832:	70a2                	ld	ra,40(sp)
    80004834:	7402                	ld	s0,32(sp)
    80004836:	64e2                	ld	s1,24(sp)
    80004838:	6942                	ld	s2,16(sp)
    8000483a:	6145                	addi	sp,sp,48
    8000483c:	8082                	ret
    8000483e:	557d                	li	a0,-1
    80004840:	bfcd                	j	80004832 <argfd+0x44>
    80004842:	557d                	li	a0,-1
    80004844:	b7fd                	j	80004832 <argfd+0x44>

0000000080004846 <fdalloc>:
    80004846:	1101                	addi	sp,sp,-32
    80004848:	ec06                	sd	ra,24(sp)
    8000484a:	e822                	sd	s0,16(sp)
    8000484c:	e426                	sd	s1,8(sp)
    8000484e:	1000                	addi	s0,sp,32
    80004850:	84aa                	mv	s1,a0
    80004852:	89cfd0ef          	jal	800018ee <myproc>
    80004856:	862a                	mv	a2,a0
    80004858:	0d050793          	addi	a5,a0,208
    8000485c:	4501                	li	a0,0
    8000485e:	46c1                	li	a3,16
    80004860:	6398                	ld	a4,0(a5)
    80004862:	cb19                	beqz	a4,80004878 <fdalloc+0x32>
    80004864:	2505                	addiw	a0,a0,1
    80004866:	07a1                	addi	a5,a5,8
    80004868:	fed51ce3          	bne	a0,a3,80004860 <fdalloc+0x1a>
    8000486c:	557d                	li	a0,-1
    8000486e:	60e2                	ld	ra,24(sp)
    80004870:	6442                	ld	s0,16(sp)
    80004872:	64a2                	ld	s1,8(sp)
    80004874:	6105                	addi	sp,sp,32
    80004876:	8082                	ret
    80004878:	01a50793          	addi	a5,a0,26
    8000487c:	078e                	slli	a5,a5,0x3
    8000487e:	963e                	add	a2,a2,a5
    80004880:	e204                	sd	s1,0(a2)
    80004882:	b7f5                	j	8000486e <fdalloc+0x28>

0000000080004884 <create>:
    80004884:	715d                	addi	sp,sp,-80
    80004886:	e486                	sd	ra,72(sp)
    80004888:	e0a2                	sd	s0,64(sp)
    8000488a:	fc26                	sd	s1,56(sp)
    8000488c:	f84a                	sd	s2,48(sp)
    8000488e:	f44e                	sd	s3,40(sp)
    80004890:	ec56                	sd	s5,24(sp)
    80004892:	e85a                	sd	s6,16(sp)
    80004894:	0880                	addi	s0,sp,80
    80004896:	8b2e                	mv	s6,a1
    80004898:	89b2                	mv	s3,a2
    8000489a:	8936                	mv	s2,a3
    8000489c:	fb040593          	addi	a1,s0,-80
    800048a0:	822ff0ef          	jal	800038c2 <nameiparent>
    800048a4:	84aa                	mv	s1,a0
    800048a6:	10050a63          	beqz	a0,800049ba <create+0x136>
    800048aa:	925fe0ef          	jal	800031ce <ilock>
    800048ae:	4601                	li	a2,0
    800048b0:	fb040593          	addi	a1,s0,-80
    800048b4:	8526                	mv	a0,s1
    800048b6:	d8dfe0ef          	jal	80003642 <dirlookup>
    800048ba:	8aaa                	mv	s5,a0
    800048bc:	c129                	beqz	a0,800048fe <create+0x7a>
    800048be:	8526                	mv	a0,s1
    800048c0:	b19fe0ef          	jal	800033d8 <iunlockput>
    800048c4:	8556                	mv	a0,s5
    800048c6:	909fe0ef          	jal	800031ce <ilock>
    800048ca:	4789                	li	a5,2
    800048cc:	02fb1463          	bne	s6,a5,800048f4 <create+0x70>
    800048d0:	044ad783          	lhu	a5,68(s5)
    800048d4:	37f9                	addiw	a5,a5,-2
    800048d6:	17c2                	slli	a5,a5,0x30
    800048d8:	93c1                	srli	a5,a5,0x30
    800048da:	4705                	li	a4,1
    800048dc:	00f76c63          	bltu	a4,a5,800048f4 <create+0x70>
    800048e0:	8556                	mv	a0,s5
    800048e2:	60a6                	ld	ra,72(sp)
    800048e4:	6406                	ld	s0,64(sp)
    800048e6:	74e2                	ld	s1,56(sp)
    800048e8:	7942                	ld	s2,48(sp)
    800048ea:	79a2                	ld	s3,40(sp)
    800048ec:	6ae2                	ld	s5,24(sp)
    800048ee:	6b42                	ld	s6,16(sp)
    800048f0:	6161                	addi	sp,sp,80
    800048f2:	8082                	ret
    800048f4:	8556                	mv	a0,s5
    800048f6:	ae3fe0ef          	jal	800033d8 <iunlockput>
    800048fa:	4a81                	li	s5,0
    800048fc:	b7d5                	j	800048e0 <create+0x5c>
    800048fe:	f052                	sd	s4,32(sp)
    80004900:	85da                	mv	a1,s6
    80004902:	4088                	lw	a0,0(s1)
    80004904:	f5afe0ef          	jal	8000305e <ialloc>
    80004908:	8a2a                	mv	s4,a0
    8000490a:	cd15                	beqz	a0,80004946 <create+0xc2>
    8000490c:	8c3fe0ef          	jal	800031ce <ilock>
    80004910:	053a1323          	sh	s3,70(s4)
    80004914:	052a1423          	sh	s2,72(s4)
    80004918:	4905                	li	s2,1
    8000491a:	052a1523          	sh	s2,74(s4)
    8000491e:	8552                	mv	a0,s4
    80004920:	ffafe0ef          	jal	8000311a <iupdate>
    80004924:	032b0763          	beq	s6,s2,80004952 <create+0xce>
    80004928:	004a2603          	lw	a2,4(s4)
    8000492c:	fb040593          	addi	a1,s0,-80
    80004930:	8526                	mv	a0,s1
    80004932:	eddfe0ef          	jal	8000380e <dirlink>
    80004936:	06054563          	bltz	a0,800049a0 <create+0x11c>
    8000493a:	8526                	mv	a0,s1
    8000493c:	a9dfe0ef          	jal	800033d8 <iunlockput>
    80004940:	8ad2                	mv	s5,s4
    80004942:	7a02                	ld	s4,32(sp)
    80004944:	bf71                	j	800048e0 <create+0x5c>
    80004946:	8526                	mv	a0,s1
    80004948:	a91fe0ef          	jal	800033d8 <iunlockput>
    8000494c:	8ad2                	mv	s5,s4
    8000494e:	7a02                	ld	s4,32(sp)
    80004950:	bf41                	j	800048e0 <create+0x5c>
    80004952:	004a2603          	lw	a2,4(s4)
    80004956:	00003597          	auipc	a1,0x3
    8000495a:	cca58593          	addi	a1,a1,-822 # 80007620 <etext+0x620>
    8000495e:	8552                	mv	a0,s4
    80004960:	eaffe0ef          	jal	8000380e <dirlink>
    80004964:	02054e63          	bltz	a0,800049a0 <create+0x11c>
    80004968:	40d0                	lw	a2,4(s1)
    8000496a:	00003597          	auipc	a1,0x3
    8000496e:	cbe58593          	addi	a1,a1,-834 # 80007628 <etext+0x628>
    80004972:	8552                	mv	a0,s4
    80004974:	e9bfe0ef          	jal	8000380e <dirlink>
    80004978:	02054463          	bltz	a0,800049a0 <create+0x11c>
    8000497c:	004a2603          	lw	a2,4(s4)
    80004980:	fb040593          	addi	a1,s0,-80
    80004984:	8526                	mv	a0,s1
    80004986:	e89fe0ef          	jal	8000380e <dirlink>
    8000498a:	00054b63          	bltz	a0,800049a0 <create+0x11c>
    8000498e:	04a4d783          	lhu	a5,74(s1)
    80004992:	2785                	addiw	a5,a5,1
    80004994:	04f49523          	sh	a5,74(s1)
    80004998:	8526                	mv	a0,s1
    8000499a:	f80fe0ef          	jal	8000311a <iupdate>
    8000499e:	bf71                	j	8000493a <create+0xb6>
    800049a0:	040a1523          	sh	zero,74(s4)
    800049a4:	8552                	mv	a0,s4
    800049a6:	f74fe0ef          	jal	8000311a <iupdate>
    800049aa:	8552                	mv	a0,s4
    800049ac:	a2dfe0ef          	jal	800033d8 <iunlockput>
    800049b0:	8526                	mv	a0,s1
    800049b2:	a27fe0ef          	jal	800033d8 <iunlockput>
    800049b6:	7a02                	ld	s4,32(sp)
    800049b8:	b725                	j	800048e0 <create+0x5c>
    800049ba:	8aaa                	mv	s5,a0
    800049bc:	b715                	j	800048e0 <create+0x5c>

00000000800049be <sys_dup>:
    800049be:	7179                	addi	sp,sp,-48
    800049c0:	f406                	sd	ra,40(sp)
    800049c2:	f022                	sd	s0,32(sp)
    800049c4:	1800                	addi	s0,sp,48
    800049c6:	fd840613          	addi	a2,s0,-40
    800049ca:	4581                	li	a1,0
    800049cc:	4501                	li	a0,0
    800049ce:	e21ff0ef          	jal	800047ee <argfd>
    800049d2:	57fd                	li	a5,-1
    800049d4:	02054363          	bltz	a0,800049fa <sys_dup+0x3c>
    800049d8:	ec26                	sd	s1,24(sp)
    800049da:	e84a                	sd	s2,16(sp)
    800049dc:	fd843903          	ld	s2,-40(s0)
    800049e0:	854a                	mv	a0,s2
    800049e2:	e65ff0ef          	jal	80004846 <fdalloc>
    800049e6:	84aa                	mv	s1,a0
    800049e8:	57fd                	li	a5,-1
    800049ea:	00054d63          	bltz	a0,80004a04 <sys_dup+0x46>
    800049ee:	854a                	mv	a0,s2
    800049f0:	c48ff0ef          	jal	80003e38 <filedup>
    800049f4:	87a6                	mv	a5,s1
    800049f6:	64e2                	ld	s1,24(sp)
    800049f8:	6942                	ld	s2,16(sp)
    800049fa:	853e                	mv	a0,a5
    800049fc:	70a2                	ld	ra,40(sp)
    800049fe:	7402                	ld	s0,32(sp)
    80004a00:	6145                	addi	sp,sp,48
    80004a02:	8082                	ret
    80004a04:	64e2                	ld	s1,24(sp)
    80004a06:	6942                	ld	s2,16(sp)
    80004a08:	bfcd                	j	800049fa <sys_dup+0x3c>

0000000080004a0a <sys_read>:
    80004a0a:	7179                	addi	sp,sp,-48
    80004a0c:	f406                	sd	ra,40(sp)
    80004a0e:	f022                	sd	s0,32(sp)
    80004a10:	1800                	addi	s0,sp,48
    80004a12:	fd840593          	addi	a1,s0,-40
    80004a16:	4505                	li	a0,1
    80004a18:	da7fd0ef          	jal	800027be <argaddr>
    80004a1c:	fe440593          	addi	a1,s0,-28
    80004a20:	4509                	li	a0,2
    80004a22:	d81fd0ef          	jal	800027a2 <argint>
    80004a26:	fe840613          	addi	a2,s0,-24
    80004a2a:	4581                	li	a1,0
    80004a2c:	4501                	li	a0,0
    80004a2e:	dc1ff0ef          	jal	800047ee <argfd>
    80004a32:	87aa                	mv	a5,a0
    80004a34:	557d                	li	a0,-1
    80004a36:	0007ca63          	bltz	a5,80004a4a <sys_read+0x40>
    80004a3a:	fe442603          	lw	a2,-28(s0)
    80004a3e:	fd843583          	ld	a1,-40(s0)
    80004a42:	fe843503          	ld	a0,-24(s0)
    80004a46:	d58ff0ef          	jal	80003f9e <fileread>
    80004a4a:	70a2                	ld	ra,40(sp)
    80004a4c:	7402                	ld	s0,32(sp)
    80004a4e:	6145                	addi	sp,sp,48
    80004a50:	8082                	ret

0000000080004a52 <sys_write>:
    80004a52:	7179                	addi	sp,sp,-48
    80004a54:	f406                	sd	ra,40(sp)
    80004a56:	f022                	sd	s0,32(sp)
    80004a58:	1800                	addi	s0,sp,48
    80004a5a:	fd840593          	addi	a1,s0,-40
    80004a5e:	4505                	li	a0,1
    80004a60:	d5ffd0ef          	jal	800027be <argaddr>
    80004a64:	fe440593          	addi	a1,s0,-28
    80004a68:	4509                	li	a0,2
    80004a6a:	d39fd0ef          	jal	800027a2 <argint>
    80004a6e:	fe840613          	addi	a2,s0,-24
    80004a72:	4581                	li	a1,0
    80004a74:	4501                	li	a0,0
    80004a76:	d79ff0ef          	jal	800047ee <argfd>
    80004a7a:	87aa                	mv	a5,a0
    80004a7c:	557d                	li	a0,-1
    80004a7e:	0007ca63          	bltz	a5,80004a92 <sys_write+0x40>
    80004a82:	fe442603          	lw	a2,-28(s0)
    80004a86:	fd843583          	ld	a1,-40(s0)
    80004a8a:	fe843503          	ld	a0,-24(s0)
    80004a8e:	dceff0ef          	jal	8000405c <filewrite>
    80004a92:	70a2                	ld	ra,40(sp)
    80004a94:	7402                	ld	s0,32(sp)
    80004a96:	6145                	addi	sp,sp,48
    80004a98:	8082                	ret

0000000080004a9a <sys_close>:
    80004a9a:	1101                	addi	sp,sp,-32
    80004a9c:	ec06                	sd	ra,24(sp)
    80004a9e:	e822                	sd	s0,16(sp)
    80004aa0:	1000                	addi	s0,sp,32
    80004aa2:	fe040613          	addi	a2,s0,-32
    80004aa6:	fec40593          	addi	a1,s0,-20
    80004aaa:	4501                	li	a0,0
    80004aac:	d43ff0ef          	jal	800047ee <argfd>
    80004ab0:	57fd                	li	a5,-1
    80004ab2:	02054063          	bltz	a0,80004ad2 <sys_close+0x38>
    80004ab6:	e39fc0ef          	jal	800018ee <myproc>
    80004aba:	fec42783          	lw	a5,-20(s0)
    80004abe:	07e9                	addi	a5,a5,26
    80004ac0:	078e                	slli	a5,a5,0x3
    80004ac2:	953e                	add	a0,a0,a5
    80004ac4:	00053023          	sd	zero,0(a0)
    80004ac8:	fe043503          	ld	a0,-32(s0)
    80004acc:	bb2ff0ef          	jal	80003e7e <fileclose>
    80004ad0:	4781                	li	a5,0
    80004ad2:	853e                	mv	a0,a5
    80004ad4:	60e2                	ld	ra,24(sp)
    80004ad6:	6442                	ld	s0,16(sp)
    80004ad8:	6105                	addi	sp,sp,32
    80004ada:	8082                	ret

0000000080004adc <sys_fstat>:
    80004adc:	1101                	addi	sp,sp,-32
    80004ade:	ec06                	sd	ra,24(sp)
    80004ae0:	e822                	sd	s0,16(sp)
    80004ae2:	1000                	addi	s0,sp,32
    80004ae4:	fe040593          	addi	a1,s0,-32
    80004ae8:	4505                	li	a0,1
    80004aea:	cd5fd0ef          	jal	800027be <argaddr>
    80004aee:	fe840613          	addi	a2,s0,-24
    80004af2:	4581                	li	a1,0
    80004af4:	4501                	li	a0,0
    80004af6:	cf9ff0ef          	jal	800047ee <argfd>
    80004afa:	87aa                	mv	a5,a0
    80004afc:	557d                	li	a0,-1
    80004afe:	0007c863          	bltz	a5,80004b0e <sys_fstat+0x32>
    80004b02:	fe043583          	ld	a1,-32(s0)
    80004b06:	fe843503          	ld	a0,-24(s0)
    80004b0a:	c36ff0ef          	jal	80003f40 <filestat>
    80004b0e:	60e2                	ld	ra,24(sp)
    80004b10:	6442                	ld	s0,16(sp)
    80004b12:	6105                	addi	sp,sp,32
    80004b14:	8082                	ret

0000000080004b16 <sys_link>:
    80004b16:	7169                	addi	sp,sp,-304
    80004b18:	f606                	sd	ra,296(sp)
    80004b1a:	f222                	sd	s0,288(sp)
    80004b1c:	1a00                	addi	s0,sp,304
    80004b1e:	08000613          	li	a2,128
    80004b22:	ed040593          	addi	a1,s0,-304
    80004b26:	4501                	li	a0,0
    80004b28:	cb3fd0ef          	jal	800027da <argstr>
    80004b2c:	57fd                	li	a5,-1
    80004b2e:	0c054e63          	bltz	a0,80004c0a <sys_link+0xf4>
    80004b32:	08000613          	li	a2,128
    80004b36:	f5040593          	addi	a1,s0,-176
    80004b3a:	4505                	li	a0,1
    80004b3c:	c9ffd0ef          	jal	800027da <argstr>
    80004b40:	57fd                	li	a5,-1
    80004b42:	0c054463          	bltz	a0,80004c0a <sys_link+0xf4>
    80004b46:	ee26                	sd	s1,280(sp)
    80004b48:	f1dfe0ef          	jal	80003a64 <begin_op>
    80004b4c:	ed040513          	addi	a0,s0,-304
    80004b50:	d59fe0ef          	jal	800038a8 <namei>
    80004b54:	84aa                	mv	s1,a0
    80004b56:	c53d                	beqz	a0,80004bc4 <sys_link+0xae>
    80004b58:	e76fe0ef          	jal	800031ce <ilock>
    80004b5c:	04449703          	lh	a4,68(s1)
    80004b60:	4785                	li	a5,1
    80004b62:	06f70663          	beq	a4,a5,80004bce <sys_link+0xb8>
    80004b66:	ea4a                	sd	s2,272(sp)
    80004b68:	04a4d783          	lhu	a5,74(s1)
    80004b6c:	2785                	addiw	a5,a5,1
    80004b6e:	04f49523          	sh	a5,74(s1)
    80004b72:	8526                	mv	a0,s1
    80004b74:	da6fe0ef          	jal	8000311a <iupdate>
    80004b78:	8526                	mv	a0,s1
    80004b7a:	f02fe0ef          	jal	8000327c <iunlock>
    80004b7e:	fd040593          	addi	a1,s0,-48
    80004b82:	f5040513          	addi	a0,s0,-176
    80004b86:	d3dfe0ef          	jal	800038c2 <nameiparent>
    80004b8a:	892a                	mv	s2,a0
    80004b8c:	cd21                	beqz	a0,80004be4 <sys_link+0xce>
    80004b8e:	e40fe0ef          	jal	800031ce <ilock>
    80004b92:	00092703          	lw	a4,0(s2)
    80004b96:	409c                	lw	a5,0(s1)
    80004b98:	04f71363          	bne	a4,a5,80004bde <sys_link+0xc8>
    80004b9c:	40d0                	lw	a2,4(s1)
    80004b9e:	fd040593          	addi	a1,s0,-48
    80004ba2:	854a                	mv	a0,s2
    80004ba4:	c6bfe0ef          	jal	8000380e <dirlink>
    80004ba8:	02054b63          	bltz	a0,80004bde <sys_link+0xc8>
    80004bac:	854a                	mv	a0,s2
    80004bae:	82bfe0ef          	jal	800033d8 <iunlockput>
    80004bb2:	8526                	mv	a0,s1
    80004bb4:	f9cfe0ef          	jal	80003350 <iput>
    80004bb8:	f17fe0ef          	jal	80003ace <end_op>
    80004bbc:	4781                	li	a5,0
    80004bbe:	64f2                	ld	s1,280(sp)
    80004bc0:	6952                	ld	s2,272(sp)
    80004bc2:	a0a1                	j	80004c0a <sys_link+0xf4>
    80004bc4:	f0bfe0ef          	jal	80003ace <end_op>
    80004bc8:	57fd                	li	a5,-1
    80004bca:	64f2                	ld	s1,280(sp)
    80004bcc:	a83d                	j	80004c0a <sys_link+0xf4>
    80004bce:	8526                	mv	a0,s1
    80004bd0:	809fe0ef          	jal	800033d8 <iunlockput>
    80004bd4:	efbfe0ef          	jal	80003ace <end_op>
    80004bd8:	57fd                	li	a5,-1
    80004bda:	64f2                	ld	s1,280(sp)
    80004bdc:	a03d                	j	80004c0a <sys_link+0xf4>
    80004bde:	854a                	mv	a0,s2
    80004be0:	ff8fe0ef          	jal	800033d8 <iunlockput>
    80004be4:	8526                	mv	a0,s1
    80004be6:	de8fe0ef          	jal	800031ce <ilock>
    80004bea:	04a4d783          	lhu	a5,74(s1)
    80004bee:	37fd                	addiw	a5,a5,-1
    80004bf0:	04f49523          	sh	a5,74(s1)
    80004bf4:	8526                	mv	a0,s1
    80004bf6:	d24fe0ef          	jal	8000311a <iupdate>
    80004bfa:	8526                	mv	a0,s1
    80004bfc:	fdcfe0ef          	jal	800033d8 <iunlockput>
    80004c00:	ecffe0ef          	jal	80003ace <end_op>
    80004c04:	57fd                	li	a5,-1
    80004c06:	64f2                	ld	s1,280(sp)
    80004c08:	6952                	ld	s2,272(sp)
    80004c0a:	853e                	mv	a0,a5
    80004c0c:	70b2                	ld	ra,296(sp)
    80004c0e:	7412                	ld	s0,288(sp)
    80004c10:	6155                	addi	sp,sp,304
    80004c12:	8082                	ret

0000000080004c14 <sys_unlink>:
    80004c14:	7151                	addi	sp,sp,-240
    80004c16:	f586                	sd	ra,232(sp)
    80004c18:	f1a2                	sd	s0,224(sp)
    80004c1a:	1980                	addi	s0,sp,240
    80004c1c:	08000613          	li	a2,128
    80004c20:	f3040593          	addi	a1,s0,-208
    80004c24:	4501                	li	a0,0
    80004c26:	bb5fd0ef          	jal	800027da <argstr>
    80004c2a:	16054063          	bltz	a0,80004d8a <sys_unlink+0x176>
    80004c2e:	eda6                	sd	s1,216(sp)
    80004c30:	e35fe0ef          	jal	80003a64 <begin_op>
    80004c34:	fb040593          	addi	a1,s0,-80
    80004c38:	f3040513          	addi	a0,s0,-208
    80004c3c:	c87fe0ef          	jal	800038c2 <nameiparent>
    80004c40:	84aa                	mv	s1,a0
    80004c42:	c945                	beqz	a0,80004cf2 <sys_unlink+0xde>
    80004c44:	d8afe0ef          	jal	800031ce <ilock>
    80004c48:	00003597          	auipc	a1,0x3
    80004c4c:	9d858593          	addi	a1,a1,-1576 # 80007620 <etext+0x620>
    80004c50:	fb040513          	addi	a0,s0,-80
    80004c54:	9d9fe0ef          	jal	8000362c <namecmp>
    80004c58:	10050e63          	beqz	a0,80004d74 <sys_unlink+0x160>
    80004c5c:	00003597          	auipc	a1,0x3
    80004c60:	9cc58593          	addi	a1,a1,-1588 # 80007628 <etext+0x628>
    80004c64:	fb040513          	addi	a0,s0,-80
    80004c68:	9c5fe0ef          	jal	8000362c <namecmp>
    80004c6c:	10050463          	beqz	a0,80004d74 <sys_unlink+0x160>
    80004c70:	e9ca                	sd	s2,208(sp)
    80004c72:	f2c40613          	addi	a2,s0,-212
    80004c76:	fb040593          	addi	a1,s0,-80
    80004c7a:	8526                	mv	a0,s1
    80004c7c:	9c7fe0ef          	jal	80003642 <dirlookup>
    80004c80:	892a                	mv	s2,a0
    80004c82:	0e050863          	beqz	a0,80004d72 <sys_unlink+0x15e>
    80004c86:	d48fe0ef          	jal	800031ce <ilock>
    80004c8a:	04a91783          	lh	a5,74(s2)
    80004c8e:	06f05763          	blez	a5,80004cfc <sys_unlink+0xe8>
    80004c92:	04491703          	lh	a4,68(s2)
    80004c96:	4785                	li	a5,1
    80004c98:	06f70963          	beq	a4,a5,80004d0a <sys_unlink+0xf6>
    80004c9c:	4641                	li	a2,16
    80004c9e:	4581                	li	a1,0
    80004ca0:	fc040513          	addi	a0,s0,-64
    80004ca4:	832fc0ef          	jal	80000cd6 <memset>
    80004ca8:	4741                	li	a4,16
    80004caa:	f2c42683          	lw	a3,-212(s0)
    80004cae:	fc040613          	addi	a2,s0,-64
    80004cb2:	4581                	li	a1,0
    80004cb4:	8526                	mv	a0,s1
    80004cb6:	869fe0ef          	jal	8000351e <writei>
    80004cba:	47c1                	li	a5,16
    80004cbc:	08f51b63          	bne	a0,a5,80004d52 <sys_unlink+0x13e>
    80004cc0:	04491703          	lh	a4,68(s2)
    80004cc4:	4785                	li	a5,1
    80004cc6:	08f70d63          	beq	a4,a5,80004d60 <sys_unlink+0x14c>
    80004cca:	8526                	mv	a0,s1
    80004ccc:	f0cfe0ef          	jal	800033d8 <iunlockput>
    80004cd0:	04a95783          	lhu	a5,74(s2)
    80004cd4:	37fd                	addiw	a5,a5,-1
    80004cd6:	04f91523          	sh	a5,74(s2)
    80004cda:	854a                	mv	a0,s2
    80004cdc:	c3efe0ef          	jal	8000311a <iupdate>
    80004ce0:	854a                	mv	a0,s2
    80004ce2:	ef6fe0ef          	jal	800033d8 <iunlockput>
    80004ce6:	de9fe0ef          	jal	80003ace <end_op>
    80004cea:	4501                	li	a0,0
    80004cec:	64ee                	ld	s1,216(sp)
    80004cee:	694e                	ld	s2,208(sp)
    80004cf0:	a849                	j	80004d82 <sys_unlink+0x16e>
    80004cf2:	dddfe0ef          	jal	80003ace <end_op>
    80004cf6:	557d                	li	a0,-1
    80004cf8:	64ee                	ld	s1,216(sp)
    80004cfa:	a061                	j	80004d82 <sys_unlink+0x16e>
    80004cfc:	e5ce                	sd	s3,200(sp)
    80004cfe:	00003517          	auipc	a0,0x3
    80004d02:	93250513          	addi	a0,a0,-1742 # 80007630 <etext+0x630>
    80004d06:	a9dfb0ef          	jal	800007a2 <panic>
    80004d0a:	04c92703          	lw	a4,76(s2)
    80004d0e:	02000793          	li	a5,32
    80004d12:	f8e7f5e3          	bgeu	a5,a4,80004c9c <sys_unlink+0x88>
    80004d16:	e5ce                	sd	s3,200(sp)
    80004d18:	02000993          	li	s3,32
    80004d1c:	4741                	li	a4,16
    80004d1e:	86ce                	mv	a3,s3
    80004d20:	f1840613          	addi	a2,s0,-232
    80004d24:	4581                	li	a1,0
    80004d26:	854a                	mv	a0,s2
    80004d28:	efafe0ef          	jal	80003422 <readi>
    80004d2c:	47c1                	li	a5,16
    80004d2e:	00f51c63          	bne	a0,a5,80004d46 <sys_unlink+0x132>
    80004d32:	f1845783          	lhu	a5,-232(s0)
    80004d36:	efa1                	bnez	a5,80004d8e <sys_unlink+0x17a>
    80004d38:	29c1                	addiw	s3,s3,16
    80004d3a:	04c92783          	lw	a5,76(s2)
    80004d3e:	fcf9efe3          	bltu	s3,a5,80004d1c <sys_unlink+0x108>
    80004d42:	69ae                	ld	s3,200(sp)
    80004d44:	bfa1                	j	80004c9c <sys_unlink+0x88>
    80004d46:	00003517          	auipc	a0,0x3
    80004d4a:	90250513          	addi	a0,a0,-1790 # 80007648 <etext+0x648>
    80004d4e:	a55fb0ef          	jal	800007a2 <panic>
    80004d52:	e5ce                	sd	s3,200(sp)
    80004d54:	00003517          	auipc	a0,0x3
    80004d58:	90c50513          	addi	a0,a0,-1780 # 80007660 <etext+0x660>
    80004d5c:	a47fb0ef          	jal	800007a2 <panic>
    80004d60:	04a4d783          	lhu	a5,74(s1)
    80004d64:	37fd                	addiw	a5,a5,-1
    80004d66:	04f49523          	sh	a5,74(s1)
    80004d6a:	8526                	mv	a0,s1
    80004d6c:	baefe0ef          	jal	8000311a <iupdate>
    80004d70:	bfa9                	j	80004cca <sys_unlink+0xb6>
    80004d72:	694e                	ld	s2,208(sp)
    80004d74:	8526                	mv	a0,s1
    80004d76:	e62fe0ef          	jal	800033d8 <iunlockput>
    80004d7a:	d55fe0ef          	jal	80003ace <end_op>
    80004d7e:	557d                	li	a0,-1
    80004d80:	64ee                	ld	s1,216(sp)
    80004d82:	70ae                	ld	ra,232(sp)
    80004d84:	740e                	ld	s0,224(sp)
    80004d86:	616d                	addi	sp,sp,240
    80004d88:	8082                	ret
    80004d8a:	557d                	li	a0,-1
    80004d8c:	bfdd                	j	80004d82 <sys_unlink+0x16e>
    80004d8e:	854a                	mv	a0,s2
    80004d90:	e48fe0ef          	jal	800033d8 <iunlockput>
    80004d94:	694e                	ld	s2,208(sp)
    80004d96:	69ae                	ld	s3,200(sp)
    80004d98:	bff1                	j	80004d74 <sys_unlink+0x160>

0000000080004d9a <sys_open>:
    80004d9a:	7131                	addi	sp,sp,-192
    80004d9c:	fd06                	sd	ra,184(sp)
    80004d9e:	f922                	sd	s0,176(sp)
    80004da0:	0180                	addi	s0,sp,192
    80004da2:	f4c40593          	addi	a1,s0,-180
    80004da6:	4505                	li	a0,1
    80004da8:	9fbfd0ef          	jal	800027a2 <argint>
    80004dac:	08000613          	li	a2,128
    80004db0:	f5040593          	addi	a1,s0,-176
    80004db4:	4501                	li	a0,0
    80004db6:	a25fd0ef          	jal	800027da <argstr>
    80004dba:	87aa                	mv	a5,a0
    80004dbc:	557d                	li	a0,-1
    80004dbe:	0a07c263          	bltz	a5,80004e62 <sys_open+0xc8>
    80004dc2:	f526                	sd	s1,168(sp)
    80004dc4:	ca1fe0ef          	jal	80003a64 <begin_op>
    80004dc8:	f4c42783          	lw	a5,-180(s0)
    80004dcc:	2007f793          	andi	a5,a5,512
    80004dd0:	c3d5                	beqz	a5,80004e74 <sys_open+0xda>
    80004dd2:	4681                	li	a3,0
    80004dd4:	4601                	li	a2,0
    80004dd6:	4589                	li	a1,2
    80004dd8:	f5040513          	addi	a0,s0,-176
    80004ddc:	aa9ff0ef          	jal	80004884 <create>
    80004de0:	84aa                	mv	s1,a0
    80004de2:	c541                	beqz	a0,80004e6a <sys_open+0xd0>
    80004de4:	04449703          	lh	a4,68(s1)
    80004de8:	478d                	li	a5,3
    80004dea:	00f71763          	bne	a4,a5,80004df8 <sys_open+0x5e>
    80004dee:	0464d703          	lhu	a4,70(s1)
    80004df2:	47a5                	li	a5,9
    80004df4:	0ae7ed63          	bltu	a5,a4,80004eae <sys_open+0x114>
    80004df8:	f14a                	sd	s2,160(sp)
    80004dfa:	fe1fe0ef          	jal	80003dda <filealloc>
    80004dfe:	892a                	mv	s2,a0
    80004e00:	c179                	beqz	a0,80004ec6 <sys_open+0x12c>
    80004e02:	ed4e                	sd	s3,152(sp)
    80004e04:	a43ff0ef          	jal	80004846 <fdalloc>
    80004e08:	89aa                	mv	s3,a0
    80004e0a:	0a054a63          	bltz	a0,80004ebe <sys_open+0x124>
    80004e0e:	04449703          	lh	a4,68(s1)
    80004e12:	478d                	li	a5,3
    80004e14:	0cf70263          	beq	a4,a5,80004ed8 <sys_open+0x13e>
    80004e18:	4789                	li	a5,2
    80004e1a:	00f92023          	sw	a5,0(s2)
    80004e1e:	02092023          	sw	zero,32(s2)
    80004e22:	00993c23          	sd	s1,24(s2)
    80004e26:	f4c42783          	lw	a5,-180(s0)
    80004e2a:	0017c713          	xori	a4,a5,1
    80004e2e:	8b05                	andi	a4,a4,1
    80004e30:	00e90423          	sb	a4,8(s2)
    80004e34:	0037f713          	andi	a4,a5,3
    80004e38:	00e03733          	snez	a4,a4
    80004e3c:	00e904a3          	sb	a4,9(s2)
    80004e40:	4007f793          	andi	a5,a5,1024
    80004e44:	c791                	beqz	a5,80004e50 <sys_open+0xb6>
    80004e46:	04449703          	lh	a4,68(s1)
    80004e4a:	4789                	li	a5,2
    80004e4c:	08f70d63          	beq	a4,a5,80004ee6 <sys_open+0x14c>
    80004e50:	8526                	mv	a0,s1
    80004e52:	c2afe0ef          	jal	8000327c <iunlock>
    80004e56:	c79fe0ef          	jal	80003ace <end_op>
    80004e5a:	854e                	mv	a0,s3
    80004e5c:	74aa                	ld	s1,168(sp)
    80004e5e:	790a                	ld	s2,160(sp)
    80004e60:	69ea                	ld	s3,152(sp)
    80004e62:	70ea                	ld	ra,184(sp)
    80004e64:	744a                	ld	s0,176(sp)
    80004e66:	6129                	addi	sp,sp,192
    80004e68:	8082                	ret
    80004e6a:	c65fe0ef          	jal	80003ace <end_op>
    80004e6e:	557d                	li	a0,-1
    80004e70:	74aa                	ld	s1,168(sp)
    80004e72:	bfc5                	j	80004e62 <sys_open+0xc8>
    80004e74:	f5040513          	addi	a0,s0,-176
    80004e78:	a31fe0ef          	jal	800038a8 <namei>
    80004e7c:	84aa                	mv	s1,a0
    80004e7e:	c11d                	beqz	a0,80004ea4 <sys_open+0x10a>
    80004e80:	b4efe0ef          	jal	800031ce <ilock>
    80004e84:	04449703          	lh	a4,68(s1)
    80004e88:	4785                	li	a5,1
    80004e8a:	f4f71de3          	bne	a4,a5,80004de4 <sys_open+0x4a>
    80004e8e:	f4c42783          	lw	a5,-180(s0)
    80004e92:	d3bd                	beqz	a5,80004df8 <sys_open+0x5e>
    80004e94:	8526                	mv	a0,s1
    80004e96:	d42fe0ef          	jal	800033d8 <iunlockput>
    80004e9a:	c35fe0ef          	jal	80003ace <end_op>
    80004e9e:	557d                	li	a0,-1
    80004ea0:	74aa                	ld	s1,168(sp)
    80004ea2:	b7c1                	j	80004e62 <sys_open+0xc8>
    80004ea4:	c2bfe0ef          	jal	80003ace <end_op>
    80004ea8:	557d                	li	a0,-1
    80004eaa:	74aa                	ld	s1,168(sp)
    80004eac:	bf5d                	j	80004e62 <sys_open+0xc8>
    80004eae:	8526                	mv	a0,s1
    80004eb0:	d28fe0ef          	jal	800033d8 <iunlockput>
    80004eb4:	c1bfe0ef          	jal	80003ace <end_op>
    80004eb8:	557d                	li	a0,-1
    80004eba:	74aa                	ld	s1,168(sp)
    80004ebc:	b75d                	j	80004e62 <sys_open+0xc8>
    80004ebe:	854a                	mv	a0,s2
    80004ec0:	fbffe0ef          	jal	80003e7e <fileclose>
    80004ec4:	69ea                	ld	s3,152(sp)
    80004ec6:	8526                	mv	a0,s1
    80004ec8:	d10fe0ef          	jal	800033d8 <iunlockput>
    80004ecc:	c03fe0ef          	jal	80003ace <end_op>
    80004ed0:	557d                	li	a0,-1
    80004ed2:	74aa                	ld	s1,168(sp)
    80004ed4:	790a                	ld	s2,160(sp)
    80004ed6:	b771                	j	80004e62 <sys_open+0xc8>
    80004ed8:	00f92023          	sw	a5,0(s2)
    80004edc:	04649783          	lh	a5,70(s1)
    80004ee0:	02f91223          	sh	a5,36(s2)
    80004ee4:	bf3d                	j	80004e22 <sys_open+0x88>
    80004ee6:	8526                	mv	a0,s1
    80004ee8:	bd4fe0ef          	jal	800032bc <itrunc>
    80004eec:	b795                	j	80004e50 <sys_open+0xb6>

0000000080004eee <sys_mkdir>:
    80004eee:	7175                	addi	sp,sp,-144
    80004ef0:	e506                	sd	ra,136(sp)
    80004ef2:	e122                	sd	s0,128(sp)
    80004ef4:	0900                	addi	s0,sp,144
    80004ef6:	b6ffe0ef          	jal	80003a64 <begin_op>
    80004efa:	08000613          	li	a2,128
    80004efe:	f7040593          	addi	a1,s0,-144
    80004f02:	4501                	li	a0,0
    80004f04:	8d7fd0ef          	jal	800027da <argstr>
    80004f08:	02054363          	bltz	a0,80004f2e <sys_mkdir+0x40>
    80004f0c:	4681                	li	a3,0
    80004f0e:	4601                	li	a2,0
    80004f10:	4585                	li	a1,1
    80004f12:	f7040513          	addi	a0,s0,-144
    80004f16:	96fff0ef          	jal	80004884 <create>
    80004f1a:	c911                	beqz	a0,80004f2e <sys_mkdir+0x40>
    80004f1c:	cbcfe0ef          	jal	800033d8 <iunlockput>
    80004f20:	baffe0ef          	jal	80003ace <end_op>
    80004f24:	4501                	li	a0,0
    80004f26:	60aa                	ld	ra,136(sp)
    80004f28:	640a                	ld	s0,128(sp)
    80004f2a:	6149                	addi	sp,sp,144
    80004f2c:	8082                	ret
    80004f2e:	ba1fe0ef          	jal	80003ace <end_op>
    80004f32:	557d                	li	a0,-1
    80004f34:	bfcd                	j	80004f26 <sys_mkdir+0x38>

0000000080004f36 <sys_mknod>:
    80004f36:	7135                	addi	sp,sp,-160
    80004f38:	ed06                	sd	ra,152(sp)
    80004f3a:	e922                	sd	s0,144(sp)
    80004f3c:	1100                	addi	s0,sp,160
    80004f3e:	b27fe0ef          	jal	80003a64 <begin_op>
    80004f42:	f6c40593          	addi	a1,s0,-148
    80004f46:	4505                	li	a0,1
    80004f48:	85bfd0ef          	jal	800027a2 <argint>
    80004f4c:	f6840593          	addi	a1,s0,-152
    80004f50:	4509                	li	a0,2
    80004f52:	851fd0ef          	jal	800027a2 <argint>
    80004f56:	08000613          	li	a2,128
    80004f5a:	f7040593          	addi	a1,s0,-144
    80004f5e:	4501                	li	a0,0
    80004f60:	87bfd0ef          	jal	800027da <argstr>
    80004f64:	02054563          	bltz	a0,80004f8e <sys_mknod+0x58>
    80004f68:	f6841683          	lh	a3,-152(s0)
    80004f6c:	f6c41603          	lh	a2,-148(s0)
    80004f70:	458d                	li	a1,3
    80004f72:	f7040513          	addi	a0,s0,-144
    80004f76:	90fff0ef          	jal	80004884 <create>
    80004f7a:	c911                	beqz	a0,80004f8e <sys_mknod+0x58>
    80004f7c:	c5cfe0ef          	jal	800033d8 <iunlockput>
    80004f80:	b4ffe0ef          	jal	80003ace <end_op>
    80004f84:	4501                	li	a0,0
    80004f86:	60ea                	ld	ra,152(sp)
    80004f88:	644a                	ld	s0,144(sp)
    80004f8a:	610d                	addi	sp,sp,160
    80004f8c:	8082                	ret
    80004f8e:	b41fe0ef          	jal	80003ace <end_op>
    80004f92:	557d                	li	a0,-1
    80004f94:	bfcd                	j	80004f86 <sys_mknod+0x50>

0000000080004f96 <sys_chdir>:
    80004f96:	7135                	addi	sp,sp,-160
    80004f98:	ed06                	sd	ra,152(sp)
    80004f9a:	e922                	sd	s0,144(sp)
    80004f9c:	e14a                	sd	s2,128(sp)
    80004f9e:	1100                	addi	s0,sp,160
    80004fa0:	94ffc0ef          	jal	800018ee <myproc>
    80004fa4:	892a                	mv	s2,a0
    80004fa6:	abffe0ef          	jal	80003a64 <begin_op>
    80004faa:	08000613          	li	a2,128
    80004fae:	f6040593          	addi	a1,s0,-160
    80004fb2:	4501                	li	a0,0
    80004fb4:	827fd0ef          	jal	800027da <argstr>
    80004fb8:	04054363          	bltz	a0,80004ffe <sys_chdir+0x68>
    80004fbc:	e526                	sd	s1,136(sp)
    80004fbe:	f6040513          	addi	a0,s0,-160
    80004fc2:	8e7fe0ef          	jal	800038a8 <namei>
    80004fc6:	84aa                	mv	s1,a0
    80004fc8:	c915                	beqz	a0,80004ffc <sys_chdir+0x66>
    80004fca:	a04fe0ef          	jal	800031ce <ilock>
    80004fce:	04449703          	lh	a4,68(s1)
    80004fd2:	4785                	li	a5,1
    80004fd4:	02f71963          	bne	a4,a5,80005006 <sys_chdir+0x70>
    80004fd8:	8526                	mv	a0,s1
    80004fda:	aa2fe0ef          	jal	8000327c <iunlock>
    80004fde:	15093503          	ld	a0,336(s2)
    80004fe2:	b6efe0ef          	jal	80003350 <iput>
    80004fe6:	ae9fe0ef          	jal	80003ace <end_op>
    80004fea:	14993823          	sd	s1,336(s2)
    80004fee:	4501                	li	a0,0
    80004ff0:	64aa                	ld	s1,136(sp)
    80004ff2:	60ea                	ld	ra,152(sp)
    80004ff4:	644a                	ld	s0,144(sp)
    80004ff6:	690a                	ld	s2,128(sp)
    80004ff8:	610d                	addi	sp,sp,160
    80004ffa:	8082                	ret
    80004ffc:	64aa                	ld	s1,136(sp)
    80004ffe:	ad1fe0ef          	jal	80003ace <end_op>
    80005002:	557d                	li	a0,-1
    80005004:	b7fd                	j	80004ff2 <sys_chdir+0x5c>
    80005006:	8526                	mv	a0,s1
    80005008:	bd0fe0ef          	jal	800033d8 <iunlockput>
    8000500c:	ac3fe0ef          	jal	80003ace <end_op>
    80005010:	557d                	li	a0,-1
    80005012:	64aa                	ld	s1,136(sp)
    80005014:	bff9                	j	80004ff2 <sys_chdir+0x5c>

0000000080005016 <sys_exec>:
    80005016:	7121                	addi	sp,sp,-448
    80005018:	ff06                	sd	ra,440(sp)
    8000501a:	fb22                	sd	s0,432(sp)
    8000501c:	0380                	addi	s0,sp,448
    8000501e:	e4840593          	addi	a1,s0,-440
    80005022:	4505                	li	a0,1
    80005024:	f9afd0ef          	jal	800027be <argaddr>
    80005028:	08000613          	li	a2,128
    8000502c:	f5040593          	addi	a1,s0,-176
    80005030:	4501                	li	a0,0
    80005032:	fa8fd0ef          	jal	800027da <argstr>
    80005036:	87aa                	mv	a5,a0
    80005038:	557d                	li	a0,-1
    8000503a:	0c07c463          	bltz	a5,80005102 <sys_exec+0xec>
    8000503e:	f726                	sd	s1,424(sp)
    80005040:	f34a                	sd	s2,416(sp)
    80005042:	ef4e                	sd	s3,408(sp)
    80005044:	eb52                	sd	s4,400(sp)
    80005046:	10000613          	li	a2,256
    8000504a:	4581                	li	a1,0
    8000504c:	e5040513          	addi	a0,s0,-432
    80005050:	c87fb0ef          	jal	80000cd6 <memset>
    80005054:	e5040493          	addi	s1,s0,-432
    80005058:	89a6                	mv	s3,s1
    8000505a:	4901                	li	s2,0
    8000505c:	02000a13          	li	s4,32
    80005060:	00391513          	slli	a0,s2,0x3
    80005064:	e4040593          	addi	a1,s0,-448
    80005068:	e4843783          	ld	a5,-440(s0)
    8000506c:	953e                	add	a0,a0,a5
    8000506e:	eaafd0ef          	jal	80002718 <fetchaddr>
    80005072:	02054663          	bltz	a0,8000509e <sys_exec+0x88>
    80005076:	e4043783          	ld	a5,-448(s0)
    8000507a:	c3a9                	beqz	a5,800050bc <sys_exec+0xa6>
    8000507c:	ab7fb0ef          	jal	80000b32 <kalloc>
    80005080:	85aa                	mv	a1,a0
    80005082:	00a9b023          	sd	a0,0(s3)
    80005086:	cd01                	beqz	a0,8000509e <sys_exec+0x88>
    80005088:	6605                	lui	a2,0x1
    8000508a:	e4043503          	ld	a0,-448(s0)
    8000508e:	ed4fd0ef          	jal	80002762 <fetchstr>
    80005092:	00054663          	bltz	a0,8000509e <sys_exec+0x88>
    80005096:	0905                	addi	s2,s2,1
    80005098:	09a1                	addi	s3,s3,8
    8000509a:	fd4913e3          	bne	s2,s4,80005060 <sys_exec+0x4a>
    8000509e:	f5040913          	addi	s2,s0,-176
    800050a2:	6088                	ld	a0,0(s1)
    800050a4:	c931                	beqz	a0,800050f8 <sys_exec+0xe2>
    800050a6:	9abfb0ef          	jal	80000a50 <kfree>
    800050aa:	04a1                	addi	s1,s1,8
    800050ac:	ff249be3          	bne	s1,s2,800050a2 <sys_exec+0x8c>
    800050b0:	557d                	li	a0,-1
    800050b2:	74ba                	ld	s1,424(sp)
    800050b4:	791a                	ld	s2,416(sp)
    800050b6:	69fa                	ld	s3,408(sp)
    800050b8:	6a5a                	ld	s4,400(sp)
    800050ba:	a0a1                	j	80005102 <sys_exec+0xec>
    800050bc:	0009079b          	sext.w	a5,s2
    800050c0:	078e                	slli	a5,a5,0x3
    800050c2:	fd078793          	addi	a5,a5,-48
    800050c6:	97a2                	add	a5,a5,s0
    800050c8:	e807b023          	sd	zero,-384(a5)
    800050cc:	e5040593          	addi	a1,s0,-432
    800050d0:	f5040513          	addi	a0,s0,-176
    800050d4:	ba8ff0ef          	jal	8000447c <exec>
    800050d8:	892a                	mv	s2,a0
    800050da:	f5040993          	addi	s3,s0,-176
    800050de:	6088                	ld	a0,0(s1)
    800050e0:	c511                	beqz	a0,800050ec <sys_exec+0xd6>
    800050e2:	96ffb0ef          	jal	80000a50 <kfree>
    800050e6:	04a1                	addi	s1,s1,8
    800050e8:	ff349be3          	bne	s1,s3,800050de <sys_exec+0xc8>
    800050ec:	854a                	mv	a0,s2
    800050ee:	74ba                	ld	s1,424(sp)
    800050f0:	791a                	ld	s2,416(sp)
    800050f2:	69fa                	ld	s3,408(sp)
    800050f4:	6a5a                	ld	s4,400(sp)
    800050f6:	a031                	j	80005102 <sys_exec+0xec>
    800050f8:	557d                	li	a0,-1
    800050fa:	74ba                	ld	s1,424(sp)
    800050fc:	791a                	ld	s2,416(sp)
    800050fe:	69fa                	ld	s3,408(sp)
    80005100:	6a5a                	ld	s4,400(sp)
    80005102:	70fa                	ld	ra,440(sp)
    80005104:	745a                	ld	s0,432(sp)
    80005106:	6139                	addi	sp,sp,448
    80005108:	8082                	ret

000000008000510a <sys_pipe>:
    8000510a:	7139                	addi	sp,sp,-64
    8000510c:	fc06                	sd	ra,56(sp)
    8000510e:	f822                	sd	s0,48(sp)
    80005110:	f426                	sd	s1,40(sp)
    80005112:	0080                	addi	s0,sp,64
    80005114:	fdafc0ef          	jal	800018ee <myproc>
    80005118:	84aa                	mv	s1,a0
    8000511a:	fd840593          	addi	a1,s0,-40
    8000511e:	4501                	li	a0,0
    80005120:	e9efd0ef          	jal	800027be <argaddr>
    80005124:	fc840593          	addi	a1,s0,-56
    80005128:	fd040513          	addi	a0,s0,-48
    8000512c:	85cff0ef          	jal	80004188 <pipealloc>
    80005130:	57fd                	li	a5,-1
    80005132:	0a054463          	bltz	a0,800051da <sys_pipe+0xd0>
    80005136:	fcf42223          	sw	a5,-60(s0)
    8000513a:	fd043503          	ld	a0,-48(s0)
    8000513e:	f08ff0ef          	jal	80004846 <fdalloc>
    80005142:	fca42223          	sw	a0,-60(s0)
    80005146:	08054163          	bltz	a0,800051c8 <sys_pipe+0xbe>
    8000514a:	fc843503          	ld	a0,-56(s0)
    8000514e:	ef8ff0ef          	jal	80004846 <fdalloc>
    80005152:	fca42023          	sw	a0,-64(s0)
    80005156:	06054063          	bltz	a0,800051b6 <sys_pipe+0xac>
    8000515a:	4691                	li	a3,4
    8000515c:	fc440613          	addi	a2,s0,-60
    80005160:	fd843583          	ld	a1,-40(s0)
    80005164:	68a8                	ld	a0,80(s1)
    80005166:	bfafc0ef          	jal	80001560 <copyout>
    8000516a:	00054e63          	bltz	a0,80005186 <sys_pipe+0x7c>
    8000516e:	4691                	li	a3,4
    80005170:	fc040613          	addi	a2,s0,-64
    80005174:	fd843583          	ld	a1,-40(s0)
    80005178:	0591                	addi	a1,a1,4
    8000517a:	68a8                	ld	a0,80(s1)
    8000517c:	be4fc0ef          	jal	80001560 <copyout>
    80005180:	4781                	li	a5,0
    80005182:	04055c63          	bgez	a0,800051da <sys_pipe+0xd0>
    80005186:	fc442783          	lw	a5,-60(s0)
    8000518a:	07e9                	addi	a5,a5,26
    8000518c:	078e                	slli	a5,a5,0x3
    8000518e:	97a6                	add	a5,a5,s1
    80005190:	0007b023          	sd	zero,0(a5)
    80005194:	fc042783          	lw	a5,-64(s0)
    80005198:	07e9                	addi	a5,a5,26
    8000519a:	078e                	slli	a5,a5,0x3
    8000519c:	94be                	add	s1,s1,a5
    8000519e:	0004b023          	sd	zero,0(s1)
    800051a2:	fd043503          	ld	a0,-48(s0)
    800051a6:	cd9fe0ef          	jal	80003e7e <fileclose>
    800051aa:	fc843503          	ld	a0,-56(s0)
    800051ae:	cd1fe0ef          	jal	80003e7e <fileclose>
    800051b2:	57fd                	li	a5,-1
    800051b4:	a01d                	j	800051da <sys_pipe+0xd0>
    800051b6:	fc442783          	lw	a5,-60(s0)
    800051ba:	0007c763          	bltz	a5,800051c8 <sys_pipe+0xbe>
    800051be:	07e9                	addi	a5,a5,26
    800051c0:	078e                	slli	a5,a5,0x3
    800051c2:	97a6                	add	a5,a5,s1
    800051c4:	0007b023          	sd	zero,0(a5)
    800051c8:	fd043503          	ld	a0,-48(s0)
    800051cc:	cb3fe0ef          	jal	80003e7e <fileclose>
    800051d0:	fc843503          	ld	a0,-56(s0)
    800051d4:	cabfe0ef          	jal	80003e7e <fileclose>
    800051d8:	57fd                	li	a5,-1
    800051da:	853e                	mv	a0,a5
    800051dc:	70e2                	ld	ra,56(sp)
    800051de:	7442                	ld	s0,48(sp)
    800051e0:	74a2                	ld	s1,40(sp)
    800051e2:	6121                	addi	sp,sp,64
    800051e4:	8082                	ret
	...

00000000800051f0 <kernelvec>:
    800051f0:	7111                	addi	sp,sp,-256
    800051f2:	e006                	sd	ra,0(sp)
    800051f4:	e40a                	sd	sp,8(sp)
    800051f6:	e80e                	sd	gp,16(sp)
    800051f8:	ec12                	sd	tp,24(sp)
    800051fa:	f016                	sd	t0,32(sp)
    800051fc:	f41a                	sd	t1,40(sp)
    800051fe:	f81e                	sd	t2,48(sp)
    80005200:	e4aa                	sd	a0,72(sp)
    80005202:	e8ae                	sd	a1,80(sp)
    80005204:	ecb2                	sd	a2,88(sp)
    80005206:	f0b6                	sd	a3,96(sp)
    80005208:	f4ba                	sd	a4,104(sp)
    8000520a:	f8be                	sd	a5,112(sp)
    8000520c:	fcc2                	sd	a6,120(sp)
    8000520e:	e146                	sd	a7,128(sp)
    80005210:	edf2                	sd	t3,216(sp)
    80005212:	f1f6                	sd	t4,224(sp)
    80005214:	f5fa                	sd	t5,232(sp)
    80005216:	f9fe                	sd	t6,240(sp)
    80005218:	c10fd0ef          	jal	80002628 <kerneltrap>
    8000521c:	6082                	ld	ra,0(sp)
    8000521e:	6122                	ld	sp,8(sp)
    80005220:	61c2                	ld	gp,16(sp)
    80005222:	7282                	ld	t0,32(sp)
    80005224:	7322                	ld	t1,40(sp)
    80005226:	73c2                	ld	t2,48(sp)
    80005228:	6526                	ld	a0,72(sp)
    8000522a:	65c6                	ld	a1,80(sp)
    8000522c:	6666                	ld	a2,88(sp)
    8000522e:	7686                	ld	a3,96(sp)
    80005230:	7726                	ld	a4,104(sp)
    80005232:	77c6                	ld	a5,112(sp)
    80005234:	7866                	ld	a6,120(sp)
    80005236:	688a                	ld	a7,128(sp)
    80005238:	6e6e                	ld	t3,216(sp)
    8000523a:	7e8e                	ld	t4,224(sp)
    8000523c:	7f2e                	ld	t5,232(sp)
    8000523e:	7fce                	ld	t6,240(sp)
    80005240:	6111                	addi	sp,sp,256
    80005242:	10200073          	sret
	...

000000008000524e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000524e:	1141                	addi	sp,sp,-16
    80005250:	e422                	sd	s0,8(sp)
    80005252:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005254:	0c0007b7          	lui	a5,0xc000
    80005258:	4705                	li	a4,1
    8000525a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000525c:	0c0007b7          	lui	a5,0xc000
    80005260:	c3d8                	sw	a4,4(a5)
}
    80005262:	6422                	ld	s0,8(sp)
    80005264:	0141                	addi	sp,sp,16
    80005266:	8082                	ret

0000000080005268 <plicinithart>:

void
plicinithart(void)
{
    80005268:	1141                	addi	sp,sp,-16
    8000526a:	e406                	sd	ra,8(sp)
    8000526c:	e022                	sd	s0,0(sp)
    8000526e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005270:	e52fc0ef          	jal	800018c2 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005274:	0085171b          	slliw	a4,a0,0x8
    80005278:	0c0027b7          	lui	a5,0xc002
    8000527c:	97ba                	add	a5,a5,a4
    8000527e:	40200713          	li	a4,1026
    80005282:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005286:	00d5151b          	slliw	a0,a0,0xd
    8000528a:	0c2017b7          	lui	a5,0xc201
    8000528e:	97aa                	add	a5,a5,a0
    80005290:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005294:	60a2                	ld	ra,8(sp)
    80005296:	6402                	ld	s0,0(sp)
    80005298:	0141                	addi	sp,sp,16
    8000529a:	8082                	ret

000000008000529c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000529c:	1141                	addi	sp,sp,-16
    8000529e:	e406                	sd	ra,8(sp)
    800052a0:	e022                	sd	s0,0(sp)
    800052a2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052a4:	e1efc0ef          	jal	800018c2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052a8:	00d5151b          	slliw	a0,a0,0xd
    800052ac:	0c2017b7          	lui	a5,0xc201
    800052b0:	97aa                	add	a5,a5,a0
  return irq;
}
    800052b2:	43c8                	lw	a0,4(a5)
    800052b4:	60a2                	ld	ra,8(sp)
    800052b6:	6402                	ld	s0,0(sp)
    800052b8:	0141                	addi	sp,sp,16
    800052ba:	8082                	ret

00000000800052bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052bc:	1101                	addi	sp,sp,-32
    800052be:	ec06                	sd	ra,24(sp)
    800052c0:	e822                	sd	s0,16(sp)
    800052c2:	e426                	sd	s1,8(sp)
    800052c4:	1000                	addi	s0,sp,32
    800052c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052c8:	dfafc0ef          	jal	800018c2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052cc:	00d5151b          	slliw	a0,a0,0xd
    800052d0:	0c2017b7          	lui	a5,0xc201
    800052d4:	97aa                	add	a5,a5,a0
    800052d6:	c3c4                	sw	s1,4(a5)
}
    800052d8:	60e2                	ld	ra,24(sp)
    800052da:	6442                	ld	s0,16(sp)
    800052dc:	64a2                	ld	s1,8(sp)
    800052de:	6105                	addi	sp,sp,32
    800052e0:	8082                	ret

00000000800052e2 <free_desc>:
    800052e2:	1141                	addi	sp,sp,-16
    800052e4:	e406                	sd	ra,8(sp)
    800052e6:	e022                	sd	s0,0(sp)
    800052e8:	0800                	addi	s0,sp,16
    800052ea:	479d                	li	a5,7
    800052ec:	04a7ca63          	blt	a5,a0,80005340 <free_desc+0x5e>
    800052f0:	0001e797          	auipc	a5,0x1e
    800052f4:	15078793          	addi	a5,a5,336 # 80023440 <disk>
    800052f8:	97aa                	add	a5,a5,a0
    800052fa:	0187c783          	lbu	a5,24(a5)
    800052fe:	e7b9                	bnez	a5,8000534c <free_desc+0x6a>
    80005300:	00451693          	slli	a3,a0,0x4
    80005304:	0001e797          	auipc	a5,0x1e
    80005308:	13c78793          	addi	a5,a5,316 # 80023440 <disk>
    8000530c:	6398                	ld	a4,0(a5)
    8000530e:	9736                	add	a4,a4,a3
    80005310:	00073023          	sd	zero,0(a4)
    80005314:	6398                	ld	a4,0(a5)
    80005316:	9736                	add	a4,a4,a3
    80005318:	00072423          	sw	zero,8(a4)
    8000531c:	00071623          	sh	zero,12(a4)
    80005320:	00071723          	sh	zero,14(a4)
    80005324:	97aa                	add	a5,a5,a0
    80005326:	4705                	li	a4,1
    80005328:	00e78c23          	sb	a4,24(a5)
    8000532c:	0001e517          	auipc	a0,0x1e
    80005330:	12c50513          	addi	a0,a0,300 # 80023458 <disk+0x18>
    80005334:	bd5fc0ef          	jal	80001f08 <wakeup>
    80005338:	60a2                	ld	ra,8(sp)
    8000533a:	6402                	ld	s0,0(sp)
    8000533c:	0141                	addi	sp,sp,16
    8000533e:	8082                	ret
    80005340:	00002517          	auipc	a0,0x2
    80005344:	33050513          	addi	a0,a0,816 # 80007670 <etext+0x670>
    80005348:	c5afb0ef          	jal	800007a2 <panic>
    8000534c:	00002517          	auipc	a0,0x2
    80005350:	33450513          	addi	a0,a0,820 # 80007680 <etext+0x680>
    80005354:	c4efb0ef          	jal	800007a2 <panic>

0000000080005358 <virtio_disk_init>:
    80005358:	1101                	addi	sp,sp,-32
    8000535a:	ec06                	sd	ra,24(sp)
    8000535c:	e822                	sd	s0,16(sp)
    8000535e:	e426                	sd	s1,8(sp)
    80005360:	e04a                	sd	s2,0(sp)
    80005362:	1000                	addi	s0,sp,32
    80005364:	00002597          	auipc	a1,0x2
    80005368:	32c58593          	addi	a1,a1,812 # 80007690 <etext+0x690>
    8000536c:	0001e517          	auipc	a0,0x1e
    80005370:	1fc50513          	addi	a0,a0,508 # 80023568 <disk+0x128>
    80005374:	80ffb0ef          	jal	80000b82 <initlock>
    80005378:	100017b7          	lui	a5,0x10001
    8000537c:	4398                	lw	a4,0(a5)
    8000537e:	2701                	sext.w	a4,a4
    80005380:	747277b7          	lui	a5,0x74727
    80005384:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005388:	18f71063          	bne	a4,a5,80005508 <virtio_disk_init+0x1b0>
    8000538c:	100017b7          	lui	a5,0x10001
    80005390:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80005392:	439c                	lw	a5,0(a5)
    80005394:	2781                	sext.w	a5,a5
    80005396:	4709                	li	a4,2
    80005398:	16e79863          	bne	a5,a4,80005508 <virtio_disk_init+0x1b0>
    8000539c:	100017b7          	lui	a5,0x10001
    800053a0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800053a2:	439c                	lw	a5,0(a5)
    800053a4:	2781                	sext.w	a5,a5
    800053a6:	16e79163          	bne	a5,a4,80005508 <virtio_disk_init+0x1b0>
    800053aa:	100017b7          	lui	a5,0x10001
    800053ae:	47d8                	lw	a4,12(a5)
    800053b0:	2701                	sext.w	a4,a4
    800053b2:	554d47b7          	lui	a5,0x554d4
    800053b6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053ba:	14f71763          	bne	a4,a5,80005508 <virtio_disk_init+0x1b0>
    800053be:	100017b7          	lui	a5,0x10001
    800053c2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
    800053c6:	4705                	li	a4,1
    800053c8:	dbb8                	sw	a4,112(a5)
    800053ca:	470d                	li	a4,3
    800053cc:	dbb8                	sw	a4,112(a5)
    800053ce:	10001737          	lui	a4,0x10001
    800053d2:	4b14                	lw	a3,16(a4)
    800053d4:	c7ffe737          	lui	a4,0xc7ffe
    800053d8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb1df>
    800053dc:	8ef9                	and	a3,a3,a4
    800053de:	10001737          	lui	a4,0x10001
    800053e2:	d314                	sw	a3,32(a4)
    800053e4:	472d                	li	a4,11
    800053e6:	dbb8                	sw	a4,112(a5)
    800053e8:	07078793          	addi	a5,a5,112
    800053ec:	439c                	lw	a5,0(a5)
    800053ee:	0007891b          	sext.w	s2,a5
    800053f2:	8ba1                	andi	a5,a5,8
    800053f4:	12078063          	beqz	a5,80005514 <virtio_disk_init+0x1bc>
    800053f8:	100017b7          	lui	a5,0x10001
    800053fc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
    80005400:	100017b7          	lui	a5,0x10001
    80005404:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005408:	439c                	lw	a5,0(a5)
    8000540a:	2781                	sext.w	a5,a5
    8000540c:	10079a63          	bnez	a5,80005520 <virtio_disk_init+0x1c8>
    80005410:	100017b7          	lui	a5,0x10001
    80005414:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005418:	439c                	lw	a5,0(a5)
    8000541a:	2781                	sext.w	a5,a5
    8000541c:	10078863          	beqz	a5,8000552c <virtio_disk_init+0x1d4>
    80005420:	471d                	li	a4,7
    80005422:	10f77b63          	bgeu	a4,a5,80005538 <virtio_disk_init+0x1e0>
    80005426:	f0cfb0ef          	jal	80000b32 <kalloc>
    8000542a:	0001e497          	auipc	s1,0x1e
    8000542e:	01648493          	addi	s1,s1,22 # 80023440 <disk>
    80005432:	e088                	sd	a0,0(s1)
    80005434:	efefb0ef          	jal	80000b32 <kalloc>
    80005438:	e488                	sd	a0,8(s1)
    8000543a:	ef8fb0ef          	jal	80000b32 <kalloc>
    8000543e:	87aa                	mv	a5,a0
    80005440:	e888                	sd	a0,16(s1)
    80005442:	6088                	ld	a0,0(s1)
    80005444:	10050063          	beqz	a0,80005544 <virtio_disk_init+0x1ec>
    80005448:	0001e717          	auipc	a4,0x1e
    8000544c:	00073703          	ld	a4,0(a4) # 80023448 <disk+0x8>
    80005450:	0e070a63          	beqz	a4,80005544 <virtio_disk_init+0x1ec>
    80005454:	0e078863          	beqz	a5,80005544 <virtio_disk_init+0x1ec>
    80005458:	6605                	lui	a2,0x1
    8000545a:	4581                	li	a1,0
    8000545c:	87bfb0ef          	jal	80000cd6 <memset>
    80005460:	0001e497          	auipc	s1,0x1e
    80005464:	fe048493          	addi	s1,s1,-32 # 80023440 <disk>
    80005468:	6605                	lui	a2,0x1
    8000546a:	4581                	li	a1,0
    8000546c:	6488                	ld	a0,8(s1)
    8000546e:	869fb0ef          	jal	80000cd6 <memset>
    80005472:	6605                	lui	a2,0x1
    80005474:	4581                	li	a1,0
    80005476:	6888                	ld	a0,16(s1)
    80005478:	85ffb0ef          	jal	80000cd6 <memset>
    8000547c:	100017b7          	lui	a5,0x10001
    80005480:	4721                	li	a4,8
    80005482:	df98                	sw	a4,56(a5)
    80005484:	4098                	lw	a4,0(s1)
    80005486:	100017b7          	lui	a5,0x10001
    8000548a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
    8000548e:	40d8                	lw	a4,4(s1)
    80005490:	100017b7          	lui	a5,0x10001
    80005494:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
    80005498:	649c                	ld	a5,8(s1)
    8000549a:	0007869b          	sext.w	a3,a5
    8000549e:	10001737          	lui	a4,0x10001
    800054a2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
    800054a6:	9781                	srai	a5,a5,0x20
    800054a8:	10001737          	lui	a4,0x10001
    800054ac:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
    800054b0:	689c                	ld	a5,16(s1)
    800054b2:	0007869b          	sext.w	a3,a5
    800054b6:	10001737          	lui	a4,0x10001
    800054ba:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
    800054be:	9781                	srai	a5,a5,0x20
    800054c0:	10001737          	lui	a4,0x10001
    800054c4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
    800054c8:	10001737          	lui	a4,0x10001
    800054cc:	4785                	li	a5,1
    800054ce:	c37c                	sw	a5,68(a4)
    800054d0:	00f48c23          	sb	a5,24(s1)
    800054d4:	00f48ca3          	sb	a5,25(s1)
    800054d8:	00f48d23          	sb	a5,26(s1)
    800054dc:	00f48da3          	sb	a5,27(s1)
    800054e0:	00f48e23          	sb	a5,28(s1)
    800054e4:	00f48ea3          	sb	a5,29(s1)
    800054e8:	00f48f23          	sb	a5,30(s1)
    800054ec:	00f48fa3          	sb	a5,31(s1)
    800054f0:	00496913          	ori	s2,s2,4
    800054f4:	100017b7          	lui	a5,0x10001
    800054f8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
    800054fc:	60e2                	ld	ra,24(sp)
    800054fe:	6442                	ld	s0,16(sp)
    80005500:	64a2                	ld	s1,8(sp)
    80005502:	6902                	ld	s2,0(sp)
    80005504:	6105                	addi	sp,sp,32
    80005506:	8082                	ret
    80005508:	00002517          	auipc	a0,0x2
    8000550c:	19850513          	addi	a0,a0,408 # 800076a0 <etext+0x6a0>
    80005510:	a92fb0ef          	jal	800007a2 <panic>
    80005514:	00002517          	auipc	a0,0x2
    80005518:	1ac50513          	addi	a0,a0,428 # 800076c0 <etext+0x6c0>
    8000551c:	a86fb0ef          	jal	800007a2 <panic>
    80005520:	00002517          	auipc	a0,0x2
    80005524:	1c050513          	addi	a0,a0,448 # 800076e0 <etext+0x6e0>
    80005528:	a7afb0ef          	jal	800007a2 <panic>
    8000552c:	00002517          	auipc	a0,0x2
    80005530:	1d450513          	addi	a0,a0,468 # 80007700 <etext+0x700>
    80005534:	a6efb0ef          	jal	800007a2 <panic>
    80005538:	00002517          	auipc	a0,0x2
    8000553c:	1e850513          	addi	a0,a0,488 # 80007720 <etext+0x720>
    80005540:	a62fb0ef          	jal	800007a2 <panic>
    80005544:	00002517          	auipc	a0,0x2
    80005548:	1fc50513          	addi	a0,a0,508 # 80007740 <etext+0x740>
    8000554c:	a56fb0ef          	jal	800007a2 <panic>

0000000080005550 <virtio_disk_rw>:
    80005550:	7159                	addi	sp,sp,-112
    80005552:	f486                	sd	ra,104(sp)
    80005554:	f0a2                	sd	s0,96(sp)
    80005556:	eca6                	sd	s1,88(sp)
    80005558:	e8ca                	sd	s2,80(sp)
    8000555a:	e4ce                	sd	s3,72(sp)
    8000555c:	e0d2                	sd	s4,64(sp)
    8000555e:	fc56                	sd	s5,56(sp)
    80005560:	f85a                	sd	s6,48(sp)
    80005562:	f45e                	sd	s7,40(sp)
    80005564:	f062                	sd	s8,32(sp)
    80005566:	ec66                	sd	s9,24(sp)
    80005568:	1880                	addi	s0,sp,112
    8000556a:	8a2a                	mv	s4,a0
    8000556c:	8bae                	mv	s7,a1
    8000556e:	00c52c83          	lw	s9,12(a0)
    80005572:	001c9c9b          	slliw	s9,s9,0x1
    80005576:	1c82                	slli	s9,s9,0x20
    80005578:	020cdc93          	srli	s9,s9,0x20
    8000557c:	0001e517          	auipc	a0,0x1e
    80005580:	fec50513          	addi	a0,a0,-20 # 80023568 <disk+0x128>
    80005584:	e7efb0ef          	jal	80000c02 <acquire>
    80005588:	4981                	li	s3,0
    8000558a:	44a1                	li	s1,8
    8000558c:	0001eb17          	auipc	s6,0x1e
    80005590:	eb4b0b13          	addi	s6,s6,-332 # 80023440 <disk>
    80005594:	4a8d                	li	s5,3
    80005596:	0001ec17          	auipc	s8,0x1e
    8000559a:	fd2c0c13          	addi	s8,s8,-46 # 80023568 <disk+0x128>
    8000559e:	a8b9                	j	800055fc <virtio_disk_rw+0xac>
    800055a0:	00fb0733          	add	a4,s6,a5
    800055a4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    800055a8:	c19c                	sw	a5,0(a1)
    800055aa:	0207c563          	bltz	a5,800055d4 <virtio_disk_rw+0x84>
    800055ae:	2905                	addiw	s2,s2,1
    800055b0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800055b2:	05590963          	beq	s2,s5,80005604 <virtio_disk_rw+0xb4>
    800055b6:	85b2                	mv	a1,a2
    800055b8:	0001e717          	auipc	a4,0x1e
    800055bc:	e8870713          	addi	a4,a4,-376 # 80023440 <disk>
    800055c0:	87ce                	mv	a5,s3
    800055c2:	01874683          	lbu	a3,24(a4)
    800055c6:	fee9                	bnez	a3,800055a0 <virtio_disk_rw+0x50>
    800055c8:	2785                	addiw	a5,a5,1
    800055ca:	0705                	addi	a4,a4,1
    800055cc:	fe979be3          	bne	a5,s1,800055c2 <virtio_disk_rw+0x72>
    800055d0:	57fd                	li	a5,-1
    800055d2:	c19c                	sw	a5,0(a1)
    800055d4:	01205d63          	blez	s2,800055ee <virtio_disk_rw+0x9e>
    800055d8:	f9042503          	lw	a0,-112(s0)
    800055dc:	d07ff0ef          	jal	800052e2 <free_desc>
    800055e0:	4785                	li	a5,1
    800055e2:	0127d663          	bge	a5,s2,800055ee <virtio_disk_rw+0x9e>
    800055e6:	f9442503          	lw	a0,-108(s0)
    800055ea:	cf9ff0ef          	jal	800052e2 <free_desc>
    800055ee:	85e2                	mv	a1,s8
    800055f0:	0001e517          	auipc	a0,0x1e
    800055f4:	e6850513          	addi	a0,a0,-408 # 80023458 <disk+0x18>
    800055f8:	8c5fc0ef          	jal	80001ebc <sleep>
    800055fc:	f9040613          	addi	a2,s0,-112
    80005600:	894e                	mv	s2,s3
    80005602:	bf55                	j	800055b6 <virtio_disk_rw+0x66>
    80005604:	f9042503          	lw	a0,-112(s0)
    80005608:	00451693          	slli	a3,a0,0x4
    8000560c:	0001e797          	auipc	a5,0x1e
    80005610:	e3478793          	addi	a5,a5,-460 # 80023440 <disk>
    80005614:	00a50713          	addi	a4,a0,10
    80005618:	0712                	slli	a4,a4,0x4
    8000561a:	973e                	add	a4,a4,a5
    8000561c:	01703633          	snez	a2,s7
    80005620:	c710                	sw	a2,8(a4)
    80005622:	00072623          	sw	zero,12(a4)
    80005626:	01973823          	sd	s9,16(a4)
    8000562a:	6398                	ld	a4,0(a5)
    8000562c:	9736                	add	a4,a4,a3
    8000562e:	0a868613          	addi	a2,a3,168
    80005632:	963e                	add	a2,a2,a5
    80005634:	e310                	sd	a2,0(a4)
    80005636:	6390                	ld	a2,0(a5)
    80005638:	00d605b3          	add	a1,a2,a3
    8000563c:	4741                	li	a4,16
    8000563e:	c598                	sw	a4,8(a1)
    80005640:	4805                	li	a6,1
    80005642:	01059623          	sh	a6,12(a1)
    80005646:	f9442703          	lw	a4,-108(s0)
    8000564a:	00e59723          	sh	a4,14(a1)
    8000564e:	0712                	slli	a4,a4,0x4
    80005650:	963a                	add	a2,a2,a4
    80005652:	058a0593          	addi	a1,s4,88
    80005656:	e20c                	sd	a1,0(a2)
    80005658:	0007b883          	ld	a7,0(a5)
    8000565c:	9746                	add	a4,a4,a7
    8000565e:	40000613          	li	a2,1024
    80005662:	c710                	sw	a2,8(a4)
    80005664:	001bb613          	seqz	a2,s7
    80005668:	0016161b          	slliw	a2,a2,0x1
    8000566c:	00166613          	ori	a2,a2,1
    80005670:	00c71623          	sh	a2,12(a4)
    80005674:	f9842583          	lw	a1,-104(s0)
    80005678:	00b71723          	sh	a1,14(a4)
    8000567c:	00250613          	addi	a2,a0,2
    80005680:	0612                	slli	a2,a2,0x4
    80005682:	963e                	add	a2,a2,a5
    80005684:	577d                	li	a4,-1
    80005686:	00e60823          	sb	a4,16(a2)
    8000568a:	0592                	slli	a1,a1,0x4
    8000568c:	98ae                	add	a7,a7,a1
    8000568e:	03068713          	addi	a4,a3,48
    80005692:	973e                	add	a4,a4,a5
    80005694:	00e8b023          	sd	a4,0(a7)
    80005698:	6398                	ld	a4,0(a5)
    8000569a:	972e                	add	a4,a4,a1
    8000569c:	01072423          	sw	a6,8(a4)
    800056a0:	4689                	li	a3,2
    800056a2:	00d71623          	sh	a3,12(a4)
    800056a6:	00071723          	sh	zero,14(a4)
    800056aa:	010a2223          	sw	a6,4(s4)
    800056ae:	01463423          	sd	s4,8(a2)
    800056b2:	6794                	ld	a3,8(a5)
    800056b4:	0026d703          	lhu	a4,2(a3)
    800056b8:	8b1d                	andi	a4,a4,7
    800056ba:	0706                	slli	a4,a4,0x1
    800056bc:	96ba                	add	a3,a3,a4
    800056be:	00a69223          	sh	a0,4(a3)
    800056c2:	0330000f          	fence	rw,rw
    800056c6:	6798                	ld	a4,8(a5)
    800056c8:	00275783          	lhu	a5,2(a4)
    800056cc:	2785                	addiw	a5,a5,1
    800056ce:	00f71123          	sh	a5,2(a4)
    800056d2:	0330000f          	fence	rw,rw
    800056d6:	100017b7          	lui	a5,0x10001
    800056da:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>
    800056de:	004a2783          	lw	a5,4(s4)
    800056e2:	0001e917          	auipc	s2,0x1e
    800056e6:	e8690913          	addi	s2,s2,-378 # 80023568 <disk+0x128>
    800056ea:	4485                	li	s1,1
    800056ec:	01079a63          	bne	a5,a6,80005700 <virtio_disk_rw+0x1b0>
    800056f0:	85ca                	mv	a1,s2
    800056f2:	8552                	mv	a0,s4
    800056f4:	fc8fc0ef          	jal	80001ebc <sleep>
    800056f8:	004a2783          	lw	a5,4(s4)
    800056fc:	fe978ae3          	beq	a5,s1,800056f0 <virtio_disk_rw+0x1a0>
    80005700:	f9042903          	lw	s2,-112(s0)
    80005704:	00290713          	addi	a4,s2,2
    80005708:	0712                	slli	a4,a4,0x4
    8000570a:	0001e797          	auipc	a5,0x1e
    8000570e:	d3678793          	addi	a5,a5,-714 # 80023440 <disk>
    80005712:	97ba                	add	a5,a5,a4
    80005714:	0007b423          	sd	zero,8(a5)
    80005718:	0001e997          	auipc	s3,0x1e
    8000571c:	d2898993          	addi	s3,s3,-728 # 80023440 <disk>
    80005720:	00491713          	slli	a4,s2,0x4
    80005724:	0009b783          	ld	a5,0(s3)
    80005728:	97ba                	add	a5,a5,a4
    8000572a:	00c7d483          	lhu	s1,12(a5)
    8000572e:	854a                	mv	a0,s2
    80005730:	00e7d903          	lhu	s2,14(a5)
    80005734:	bafff0ef          	jal	800052e2 <free_desc>
    80005738:	8885                	andi	s1,s1,1
    8000573a:	f0fd                	bnez	s1,80005720 <virtio_disk_rw+0x1d0>
    8000573c:	0001e517          	auipc	a0,0x1e
    80005740:	e2c50513          	addi	a0,a0,-468 # 80023568 <disk+0x128>
    80005744:	d56fb0ef          	jal	80000c9a <release>
    80005748:	70a6                	ld	ra,104(sp)
    8000574a:	7406                	ld	s0,96(sp)
    8000574c:	64e6                	ld	s1,88(sp)
    8000574e:	6946                	ld	s2,80(sp)
    80005750:	69a6                	ld	s3,72(sp)
    80005752:	6a06                	ld	s4,64(sp)
    80005754:	7ae2                	ld	s5,56(sp)
    80005756:	7b42                	ld	s6,48(sp)
    80005758:	7ba2                	ld	s7,40(sp)
    8000575a:	7c02                	ld	s8,32(sp)
    8000575c:	6ce2                	ld	s9,24(sp)
    8000575e:	6165                	addi	sp,sp,112
    80005760:	8082                	ret

0000000080005762 <virtio_disk_intr>:
    80005762:	1101                	addi	sp,sp,-32
    80005764:	ec06                	sd	ra,24(sp)
    80005766:	e822                	sd	s0,16(sp)
    80005768:	e426                	sd	s1,8(sp)
    8000576a:	1000                	addi	s0,sp,32
    8000576c:	0001e497          	auipc	s1,0x1e
    80005770:	cd448493          	addi	s1,s1,-812 # 80023440 <disk>
    80005774:	0001e517          	auipc	a0,0x1e
    80005778:	df450513          	addi	a0,a0,-524 # 80023568 <disk+0x128>
    8000577c:	c86fb0ef          	jal	80000c02 <acquire>
    80005780:	100017b7          	lui	a5,0x10001
    80005784:	53b8                	lw	a4,96(a5)
    80005786:	8b0d                	andi	a4,a4,3
    80005788:	100017b7          	lui	a5,0x10001
    8000578c:	d3f8                	sw	a4,100(a5)
    8000578e:	0330000f          	fence	rw,rw
    80005792:	689c                	ld	a5,16(s1)
    80005794:	0204d703          	lhu	a4,32(s1)
    80005798:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000579c:	04f70663          	beq	a4,a5,800057e8 <virtio_disk_intr+0x86>
    800057a0:	0330000f          	fence	rw,rw
    800057a4:	6898                	ld	a4,16(s1)
    800057a6:	0204d783          	lhu	a5,32(s1)
    800057aa:	8b9d                	andi	a5,a5,7
    800057ac:	078e                	slli	a5,a5,0x3
    800057ae:	97ba                	add	a5,a5,a4
    800057b0:	43dc                	lw	a5,4(a5)
    800057b2:	00278713          	addi	a4,a5,2
    800057b6:	0712                	slli	a4,a4,0x4
    800057b8:	9726                	add	a4,a4,s1
    800057ba:	01074703          	lbu	a4,16(a4)
    800057be:	e321                	bnez	a4,800057fe <virtio_disk_intr+0x9c>
    800057c0:	0789                	addi	a5,a5,2
    800057c2:	0792                	slli	a5,a5,0x4
    800057c4:	97a6                	add	a5,a5,s1
    800057c6:	6788                	ld	a0,8(a5)
    800057c8:	00052223          	sw	zero,4(a0)
    800057cc:	f3cfc0ef          	jal	80001f08 <wakeup>
    800057d0:	0204d783          	lhu	a5,32(s1)
    800057d4:	2785                	addiw	a5,a5,1
    800057d6:	17c2                	slli	a5,a5,0x30
    800057d8:	93c1                	srli	a5,a5,0x30
    800057da:	02f49023          	sh	a5,32(s1)
    800057de:	6898                	ld	a4,16(s1)
    800057e0:	00275703          	lhu	a4,2(a4)
    800057e4:	faf71ee3          	bne	a4,a5,800057a0 <virtio_disk_intr+0x3e>
    800057e8:	0001e517          	auipc	a0,0x1e
    800057ec:	d8050513          	addi	a0,a0,-640 # 80023568 <disk+0x128>
    800057f0:	caafb0ef          	jal	80000c9a <release>
    800057f4:	60e2                	ld	ra,24(sp)
    800057f6:	6442                	ld	s0,16(sp)
    800057f8:	64a2                	ld	s1,8(sp)
    800057fa:	6105                	addi	sp,sp,32
    800057fc:	8082                	ret
    800057fe:	00002517          	auipc	a0,0x2
    80005802:	f5a50513          	addi	a0,a0,-166 # 80007758 <etext+0x758>
    80005806:	f9dfa0ef          	jal	800007a2 <panic>

000000008000580a <sys_kbdint>:
    8000580a:	1141                	addi	sp,sp,-16
    8000580c:	e422                	sd	s0,8(sp)
    8000580e:	0800                	addi	s0,sp,16
    80005810:	00005517          	auipc	a0,0x5
    80005814:	a0052503          	lw	a0,-1536(a0) # 8000a210 <keyboard_int_cnt>
    80005818:	6422                	ld	s0,8(sp)
    8000581a:	0141                	addi	sp,sp,16
    8000581c:	8082                	ret
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
