
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	51013103          	ld	sp,1296(sp) # 8000a510 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffda94f>
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
    800000fa:	5e4020ef          	jal	800026de <either_copyin>
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
    80000158:	42c50513          	addi	a0,a0,1068 # 80012580 <cons>
    8000015c:	2a7000ef          	jal	80000c02 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00012497          	auipc	s1,0x12
    80000164:	42048493          	addi	s1,s1,1056 # 80012580 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00012917          	auipc	s2,0x12
    8000016c:	4b090913          	addi	s2,s2,1200 # 80012618 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	792010ef          	jal	80001912 <myproc>
    80000184:	3ec020ef          	jal	80002570 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	034020ef          	jal	800021c2 <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	00012717          	auipc	a4,0x12
    800001a4:	3e070713          	addi	a4,a4,992 # 80012580 <cons>
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
    800001d2:	4c2020ef          	jal	80002694 <either_copyout>
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
    800001ee:	39650513          	addi	a0,a0,918 # 80012580 <cons>
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
    80000218:	40f72223          	sw	a5,1028(a4) # 80012618 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	00012517          	auipc	a0,0x12
    8000022e:	35650513          	addi	a0,a0,854 # 80012580 <cons>
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
    80000282:	30250513          	addi	a0,a0,770 # 80012580 <cons>
    80000286:	17d000ef          	jal	80000c02 <acquire>
  keyboard_int_cnt++;
    8000028a:	0000a717          	auipc	a4,0xa
    8000028e:	2a670713          	addi	a4,a4,678 # 8000a530 <keyboard_int_cnt>
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
    800002ae:	47a020ef          	jal	80002728 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002b2:	00012517          	auipc	a0,0x12
    800002b6:	2ce50513          	addi	a0,a0,718 # 80012580 <cons>
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
    800002d4:	2b070713          	addi	a4,a4,688 # 80012580 <cons>
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
    800002fa:	28a78793          	addi	a5,a5,650 # 80012580 <cons>
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
    80000328:	2f47a783          	lw	a5,756(a5) # 80012618 <cons+0x98>
    8000032c:	9f1d                	subw	a4,a4,a5
    8000032e:	08000793          	li	a5,128
    80000332:	f8f710e3          	bne	a4,a5,800002b2 <consoleintr+0x40>
    80000336:	a07d                	j	800003e4 <consoleintr+0x172>
    80000338:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000033a:	00012717          	auipc	a4,0x12
    8000033e:	24670713          	addi	a4,a4,582 # 80012580 <cons>
    80000342:	0a072783          	lw	a5,160(a4)
    80000346:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	00012497          	auipc	s1,0x12
    8000034e:	23648493          	addi	s1,s1,566 # 80012580 <cons>
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
    80000390:	1f470713          	addi	a4,a4,500 # 80012580 <cons>
    80000394:	0a072783          	lw	a5,160(a4)
    80000398:	09c72703          	lw	a4,156(a4)
    8000039c:	f0f70be3          	beq	a4,a5,800002b2 <consoleintr+0x40>
      cons.e--;
    800003a0:	37fd                	addiw	a5,a5,-1
    800003a2:	00012717          	auipc	a4,0x12
    800003a6:	26f72f23          	sw	a5,638(a4) # 80012620 <cons+0xa0>
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
    800003c4:	1c078793          	addi	a5,a5,448 # 80012580 <cons>
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
    800003e8:	22c7ac23          	sw	a2,568(a5) # 8001261c <cons+0x9c>
        wakeup(&cons.r);
    800003ec:	00012517          	auipc	a0,0x12
    800003f0:	22c50513          	addi	a0,a0,556 # 80012618 <cons+0x98>
    800003f4:	77b010ef          	jal	8000236e <wakeup>
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
    8000040e:	17650513          	addi	a0,a0,374 # 80012580 <cons>
    80000412:	770000ef          	jal	80000b82 <initlock>

  uartinit();
    80000416:	3f4000ef          	jal	8000080a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000041a:	00023797          	auipc	a5,0x23
    8000041e:	8fe78793          	addi	a5,a5,-1794 # 80022d18 <devsw>
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
    800004f2:	1527a783          	lw	a5,338(a5) # 80012640 <pr+0x18>
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
    8000053e:	0ee50513          	addi	a0,a0,238 # 80012628 <pr>
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
    80000798:	e9450513          	addi	a0,a0,-364 # 80012628 <pr>
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
    800007b2:	e807a923          	sw	zero,-366(a5) # 80012640 <pr+0x18>
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
    800007d6:	d6f72123          	sw	a5,-670(a4) # 8000a534 <panicked>
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
    800007ea:	e4248493          	addi	s1,s1,-446 # 80012628 <pr>
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
    80000852:	dfa50513          	addi	a0,a0,-518 # 80012648 <uart_tx_lock>
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
    80000876:	cc27a783          	lw	a5,-830(a5) # 8000a534 <panicked>
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
    800008ac:	c907b783          	ld	a5,-880(a5) # 8000a538 <uart_tx_r>
    800008b0:	0000a717          	auipc	a4,0xa
    800008b4:	c9073703          	ld	a4,-880(a4) # 8000a540 <uart_tx_w>
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
    800008da:	d72a8a93          	addi	s5,s5,-654 # 80012648 <uart_tx_lock>
    uart_tx_r += 1;
    800008de:	0000a497          	auipc	s1,0xa
    800008e2:	c5a48493          	addi	s1,s1,-934 # 8000a538 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008e6:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008ea:	0000a997          	auipc	s3,0xa
    800008ee:	c5698993          	addi	s3,s3,-938 # 8000a540 <uart_tx_w>
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
    8000090c:	263010ef          	jal	8000236e <wakeup>
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
    8000095e:	cee50513          	addi	a0,a0,-786 # 80012648 <uart_tx_lock>
    80000962:	2a0000ef          	jal	80000c02 <acquire>
  if(panicked){
    80000966:	0000a797          	auipc	a5,0xa
    8000096a:	bce7a783          	lw	a5,-1074(a5) # 8000a534 <panicked>
    8000096e:	efbd                	bnez	a5,800009ec <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000970:	0000a717          	auipc	a4,0xa
    80000974:	bd073703          	ld	a4,-1072(a4) # 8000a540 <uart_tx_w>
    80000978:	0000a797          	auipc	a5,0xa
    8000097c:	bc07b783          	ld	a5,-1088(a5) # 8000a538 <uart_tx_r>
    80000980:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000984:	00012997          	auipc	s3,0x12
    80000988:	cc498993          	addi	s3,s3,-828 # 80012648 <uart_tx_lock>
    8000098c:	0000a497          	auipc	s1,0xa
    80000990:	bac48493          	addi	s1,s1,-1108 # 8000a538 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000994:	0000a917          	auipc	s2,0xa
    80000998:	bac90913          	addi	s2,s2,-1108 # 8000a540 <uart_tx_w>
    8000099c:	00e79d63          	bne	a5,a4,800009b6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800009a0:	85ce                	mv	a1,s3
    800009a2:	8526                	mv	a0,s1
    800009a4:	01f010ef          	jal	800021c2 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800009a8:	00093703          	ld	a4,0(s2)
    800009ac:	609c                	ld	a5,0(s1)
    800009ae:	02078793          	addi	a5,a5,32
    800009b2:	fee787e3          	beq	a5,a4,800009a0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009b6:	00012497          	auipc	s1,0x12
    800009ba:	c9248493          	addi	s1,s1,-878 # 80012648 <uart_tx_lock>
    800009be:	01f77793          	andi	a5,a4,31
    800009c2:	97a6                	add	a5,a5,s1
    800009c4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009c8:	0705                	addi	a4,a4,1
    800009ca:	0000a797          	auipc	a5,0xa
    800009ce:	b6e7bb23          	sd	a4,-1162(a5) # 8000a540 <uart_tx_w>
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
    80000a32:	c1a48493          	addi	s1,s1,-998 # 80012648 <uart_tx_lock>
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
    80000a68:	44c78793          	addi	a5,a5,1100 # 80023eb0 <end>
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
    80000a84:	c0090913          	addi	s2,s2,-1024 # 80012680 <kmem>
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
    80000b12:	b7250513          	addi	a0,a0,-1166 # 80012680 <kmem>
    80000b16:	06c000ef          	jal	80000b82 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b1a:	45c5                	li	a1,17
    80000b1c:	05ee                	slli	a1,a1,0x1b
    80000b1e:	00023517          	auipc	a0,0x23
    80000b22:	39250513          	addi	a0,a0,914 # 80023eb0 <end>
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
    80000b40:	b4448493          	addi	s1,s1,-1212 # 80012680 <kmem>
    80000b44:	8526                	mv	a0,s1
    80000b46:	0bc000ef          	jal	80000c02 <acquire>
  r = kmem.freelist;
    80000b4a:	6c84                	ld	s1,24(s1)
  if(r)
    80000b4c:	c485                	beqz	s1,80000b74 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b4e:	609c                	ld	a5,0(s1)
    80000b50:	00012517          	auipc	a0,0x12
    80000b54:	b3050513          	addi	a0,a0,-1232 # 80012680 <kmem>
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
    80000b78:	b0c50513          	addi	a0,a0,-1268 # 80012680 <kmem>
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
    80000d4a:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb151>
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
    80000e80:	6cc70713          	addi	a4,a4,1740 # 8000a548 <started>
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
    80000ea6:	1b5010ef          	jal	8000285a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000eaa:	1af040ef          	jal	80005858 <plicinithart>
  }

  scheduler();        
    80000eae:	196010ef          	jal	80002044 <scheduler>
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
    80000eee:	149010ef          	jal	80002836 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ef2:	169010ef          	jal	8000285a <trapinithart>
    plicinit();      // set up interrupt controller
    80000ef6:	149040ef          	jal	8000583e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000efa:	15f040ef          	jal	80005858 <plicinithart>
    binit();         // buffer cache
    80000efe:	108020ef          	jal	80003006 <binit>
    iinit();         // inode table
    80000f02:	6fa020ef          	jal	800035fc <iinit>
    fileinit();      // file table
    80000f06:	4a6030ef          	jal	800043ac <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f0a:	23f040ef          	jal	80005948 <virtio_disk_init>
    userinit();      // first user process
    80000f0e:	5a1000ef          	jal	80001cae <userinit>
    __sync_synchronize();
    80000f12:	0330000f          	fence	rw,rw
    started = 1;
    80000f16:	4785                	li	a5,1
    80000f18:	00009717          	auipc	a4,0x9
    80000f1c:	62f72823          	sw	a5,1584(a4) # 8000a548 <started>
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
    80000f30:	6247b783          	ld	a5,1572(a5) # 8000a550 <kernel_pagetable>
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
    80000f9e:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb147>
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
    800011e0:	36a7ba23          	sd	a0,884(a5) # 8000a550 <kernel_pagetable>
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
    800017b2:	32248493          	addi	s1,s1,802 # 80012ad0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800017b6:	8b26                	mv	s6,s1
    800017b8:	faaab937          	lui	s2,0xfaaab
    800017bc:	aab90913          	addi	s2,s2,-1365 # fffffffffaaaaaab <end+0xffffffff7aa86bfb>
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
    800017de:	2f6a8a93          	addi	s5,s5,758 # 80018ad0 <tickslock>
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
    80001850:	e5450513          	addi	a0,a0,-428 # 800126a0 <pid_lock>
    80001854:	b2eff0ef          	jal	80000b82 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001858:	00006597          	auipc	a1,0x6
    8000185c:	9b058593          	addi	a1,a1,-1616 # 80007208 <etext+0x208>
    80001860:	00011517          	auipc	a0,0x11
    80001864:	e5850513          	addi	a0,a0,-424 # 800126b8 <wait_lock>
    80001868:	b1aff0ef          	jal	80000b82 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000186c:	00011497          	auipc	s1,0x11
    80001870:	26448493          	addi	s1,s1,612 # 80012ad0 <proc>
      initlock(&p->lock, "proc");
    80001874:	00006b17          	auipc	s6,0x6
    80001878:	9a4b0b13          	addi	s6,s6,-1628 # 80007218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000187c:	8aa6                	mv	s5,s1
    8000187e:	faaab937          	lui	s2,0xfaaab
    80001882:	aab90913          	addi	s2,s2,-1365 # fffffffffaaaaaab <end+0xffffffff7aa86bfb>
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
    800018a4:	230a0a13          	addi	s4,s4,560 # 80018ad0 <tickslock>
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
    80001906:	dce50513          	addi	a0,a0,-562 # 800126d0 <cpus>
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
    8000192a:	d7a70713          	addi	a4,a4,-646 # 800126a0 <pid_lock>
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
    8000197c:	15848493          	addi	s1,s1,344 # 80012ad0 <proc>
      pinfo.ppid = (p->parent) ? p->parent->pid : 0;  // Handle init process
    80001980:	4b81                	li	s7,0
  for (p = proc; p < &proc[NPROC]; p++) {
    80001982:	00017a97          	auipc	s5,0x17
    80001986:	14ea8a93          	addi	s5,s5,334 # 80018ad0 <tickslock>
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
    80001a46:	a7e7a783          	lw	a5,-1410(a5) # 8000a4c0 <first.1>
    80001a4a:	e799                	bnez	a5,80001a58 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001a4c:	627000ef          	jal	80002872 <usertrapret>
}
    80001a50:	60a2                	ld	ra,8(sp)
    80001a52:	6402                	ld	s0,0(sp)
    80001a54:	0141                	addi	sp,sp,16
    80001a56:	8082                	ret
    fsinit(ROOTDEV);
    80001a58:	4505                	li	a0,1
    80001a5a:	337010ef          	jal	80003590 <fsinit>
    first = 0;
    80001a5e:	00009797          	auipc	a5,0x9
    80001a62:	a607a123          	sw	zero,-1438(a5) # 8000a4c0 <first.1>
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
    80001a7c:	c2890913          	addi	s2,s2,-984 # 800126a0 <pid_lock>
    80001a80:	854a                	mv	a0,s2
    80001a82:	980ff0ef          	jal	80000c02 <acquire>
  pid = nextpid;
    80001a86:	00009797          	auipc	a5,0x9
    80001a8a:	a3e78793          	addi	a5,a5,-1474 # 8000a4c4 <nextpid>
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
    80001bba:	9b27a783          	lw	a5,-1614(a5) # 8000a568 <ticks>
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
    80001bf0:	ee448493          	addi	s1,s1,-284 # 80012ad0 <proc>
    80001bf4:	00017917          	auipc	s2,0x17
    80001bf8:	edc90913          	addi	s2,s2,-292 # 80018ad0 <tickslock>
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
    80001c16:	a0ad                	j	80001c80 <allocproc+0xa0>
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
    80001c2a:	c135                	beqz	a0,80001c8e <allocproc+0xae>
  p->pagetable = proc_pagetable(p);
    80001c2c:	8526                	mv	a0,s1
    80001c2e:	e7dff0ef          	jal	80001aaa <proc_pagetable>
    80001c32:	892a                	mv	s2,a0
    80001c34:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c36:	c525                	beqz	a0,80001c9e <allocproc+0xbe>
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
    80001c5c:	9107a783          	lw	a5,-1776(a5) # 8000a568 <ticks>
    80001c60:	16f4a423          	sw	a5,360(s1)
  p->run_time = 0;
    80001c64:	1604a623          	sw	zero,364(s1)
  if (p->pid % 2 != 0)
    80001c68:	589c                	lw	a5,48(s1)
    80001c6a:	8b85                	andi	a5,a5,1
      p->priority = 5;
    80001c6c:	4715                	li	a4,5
  if (p->pid % 2 != 0)
    80001c6e:	c391                	beqz	a5,80001c72 <allocproc+0x92>
      p->priority = 10;
    80001c70:	4729                	li	a4,10
    80001c72:	d8d8                	sw	a4,52(s1)
  p->turnaround_time=0;
    80001c74:	1604aa23          	sw	zero,372(s1)
  p->waiting_time = 0;
    80001c78:	1604ac23          	sw	zero,376(s1)
  p->finish_time = 0;
    80001c7c:	1604a823          	sw	zero,368(s1)
}
    80001c80:	8526                	mv	a0,s1
    80001c82:	60e2                	ld	ra,24(sp)
    80001c84:	6442                	ld	s0,16(sp)
    80001c86:	64a2                	ld	s1,8(sp)
    80001c88:	6902                	ld	s2,0(sp)
    80001c8a:	6105                	addi	sp,sp,32
    80001c8c:	8082                	ret
    freeproc(p);
    80001c8e:	8526                	mv	a0,s1
    80001c90:	ee5ff0ef          	jal	80001b74 <freeproc>
    release(&p->lock);
    80001c94:	8526                	mv	a0,s1
    80001c96:	804ff0ef          	jal	80000c9a <release>
    return 0;
    80001c9a:	84ca                	mv	s1,s2
    80001c9c:	b7d5                	j	80001c80 <allocproc+0xa0>
    freeproc(p);
    80001c9e:	8526                	mv	a0,s1
    80001ca0:	ed5ff0ef          	jal	80001b74 <freeproc>
    release(&p->lock);
    80001ca4:	8526                	mv	a0,s1
    80001ca6:	ff5fe0ef          	jal	80000c9a <release>
    return 0;
    80001caa:	84ca                	mv	s1,s2
    80001cac:	bfd1                	j	80001c80 <allocproc+0xa0>

0000000080001cae <userinit>:
{
    80001cae:	1101                	addi	sp,sp,-32
    80001cb0:	ec06                	sd	ra,24(sp)
    80001cb2:	e822                	sd	s0,16(sp)
    80001cb4:	e426                	sd	s1,8(sp)
    80001cb6:	1000                	addi	s0,sp,32
  p = allocproc();
    80001cb8:	f29ff0ef          	jal	80001be0 <allocproc>
    80001cbc:	84aa                	mv	s1,a0
  initproc = p;
    80001cbe:	00009797          	auipc	a5,0x9
    80001cc2:	8aa7b123          	sd	a0,-1886(a5) # 8000a560 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001cc6:	03400613          	li	a2,52
    80001cca:	00009597          	auipc	a1,0x9
    80001cce:	80658593          	addi	a1,a1,-2042 # 8000a4d0 <initcode>
    80001cd2:	6928                	ld	a0,80(a0)
    80001cd4:	dfaff0ef          	jal	800012ce <uvmfirst>
  p->sz = PGSIZE;
    80001cd8:	6785                	lui	a5,0x1
    80001cda:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001cdc:	6cb8                	ld	a4,88(s1)
    80001cde:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001ce2:	6cb8                	ld	a4,88(s1)
    80001ce4:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001ce6:	4641                	li	a2,16
    80001ce8:	00005597          	auipc	a1,0x5
    80001cec:	53858593          	addi	a1,a1,1336 # 80007220 <etext+0x220>
    80001cf0:	15848513          	addi	a0,s1,344
    80001cf4:	920ff0ef          	jal	80000e14 <safestrcpy>
  p->cwd = namei("/");
    80001cf8:	00005517          	auipc	a0,0x5
    80001cfc:	53850513          	addi	a0,a0,1336 # 80007230 <etext+0x230>
    80001d00:	19e020ef          	jal	80003e9e <namei>
    80001d04:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001d08:	478d                	li	a5,3
    80001d0a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d0c:	8526                	mv	a0,s1
    80001d0e:	f8dfe0ef          	jal	80000c9a <release>
}
    80001d12:	60e2                	ld	ra,24(sp)
    80001d14:	6442                	ld	s0,16(sp)
    80001d16:	64a2                	ld	s1,8(sp)
    80001d18:	6105                	addi	sp,sp,32
    80001d1a:	8082                	ret

0000000080001d1c <growproc>:
{
    80001d1c:	1101                	addi	sp,sp,-32
    80001d1e:	ec06                	sd	ra,24(sp)
    80001d20:	e822                	sd	s0,16(sp)
    80001d22:	e426                	sd	s1,8(sp)
    80001d24:	e04a                	sd	s2,0(sp)
    80001d26:	1000                	addi	s0,sp,32
    80001d28:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001d2a:	be9ff0ef          	jal	80001912 <myproc>
    80001d2e:	84aa                	mv	s1,a0
  sz = p->sz;
    80001d30:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001d32:	01204c63          	bgtz	s2,80001d4a <growproc+0x2e>
  } else if(n < 0){
    80001d36:	02094463          	bltz	s2,80001d5e <growproc+0x42>
  p->sz = sz;
    80001d3a:	e4ac                	sd	a1,72(s1)
  return 0;
    80001d3c:	4501                	li	a0,0
}
    80001d3e:	60e2                	ld	ra,24(sp)
    80001d40:	6442                	ld	s0,16(sp)
    80001d42:	64a2                	ld	s1,8(sp)
    80001d44:	6902                	ld	s2,0(sp)
    80001d46:	6105                	addi	sp,sp,32
    80001d48:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001d4a:	4691                	li	a3,4
    80001d4c:	00b90633          	add	a2,s2,a1
    80001d50:	6928                	ld	a0,80(a0)
    80001d52:	e1eff0ef          	jal	80001370 <uvmalloc>
    80001d56:	85aa                	mv	a1,a0
    80001d58:	f16d                	bnez	a0,80001d3a <growproc+0x1e>
      return -1;
    80001d5a:	557d                	li	a0,-1
    80001d5c:	b7cd                	j	80001d3e <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d5e:	00b90633          	add	a2,s2,a1
    80001d62:	6928                	ld	a0,80(a0)
    80001d64:	dc8ff0ef          	jal	8000132c <uvmdealloc>
    80001d68:	85aa                	mv	a1,a0
    80001d6a:	bfc1                	j	80001d3a <growproc+0x1e>

0000000080001d6c <fork>:
{
    80001d6c:	7139                	addi	sp,sp,-64
    80001d6e:	fc06                	sd	ra,56(sp)
    80001d70:	f822                	sd	s0,48(sp)
    80001d72:	f04a                	sd	s2,32(sp)
    80001d74:	e456                	sd	s5,8(sp)
    80001d76:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001d78:	b9bff0ef          	jal	80001912 <myproc>
    80001d7c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001d7e:	e63ff0ef          	jal	80001be0 <allocproc>
    80001d82:	0e050a63          	beqz	a0,80001e76 <fork+0x10a>
    80001d86:	e852                	sd	s4,16(sp)
    80001d88:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001d8a:	048ab603          	ld	a2,72(s5)
    80001d8e:	692c                	ld	a1,80(a0)
    80001d90:	050ab503          	ld	a0,80(s5)
    80001d94:	f14ff0ef          	jal	800014a8 <uvmcopy>
    80001d98:	04054a63          	bltz	a0,80001dec <fork+0x80>
    80001d9c:	f426                	sd	s1,40(sp)
    80001d9e:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001da0:	048ab783          	ld	a5,72(s5)
    80001da4:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001da8:	058ab683          	ld	a3,88(s5)
    80001dac:	87b6                	mv	a5,a3
    80001dae:	058a3703          	ld	a4,88(s4)
    80001db2:	12068693          	addi	a3,a3,288
    80001db6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001dba:	6788                	ld	a0,8(a5)
    80001dbc:	6b8c                	ld	a1,16(a5)
    80001dbe:	6f90                	ld	a2,24(a5)
    80001dc0:	01073023          	sd	a6,0(a4)
    80001dc4:	e708                	sd	a0,8(a4)
    80001dc6:	eb0c                	sd	a1,16(a4)
    80001dc8:	ef10                	sd	a2,24(a4)
    80001dca:	02078793          	addi	a5,a5,32
    80001dce:	02070713          	addi	a4,a4,32
    80001dd2:	fed792e3          	bne	a5,a3,80001db6 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001dd6:	058a3783          	ld	a5,88(s4)
    80001dda:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001dde:	0d0a8493          	addi	s1,s5,208
    80001de2:	0d0a0913          	addi	s2,s4,208
    80001de6:	150a8993          	addi	s3,s5,336
    80001dea:	a831                	j	80001e06 <fork+0x9a>
    freeproc(np);
    80001dec:	8552                	mv	a0,s4
    80001dee:	d87ff0ef          	jal	80001b74 <freeproc>
    release(&np->lock);
    80001df2:	8552                	mv	a0,s4
    80001df4:	ea7fe0ef          	jal	80000c9a <release>
    return -1;
    80001df8:	597d                	li	s2,-1
    80001dfa:	6a42                	ld	s4,16(sp)
    80001dfc:	a0b5                	j	80001e68 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001dfe:	04a1                	addi	s1,s1,8
    80001e00:	0921                	addi	s2,s2,8
    80001e02:	01348963          	beq	s1,s3,80001e14 <fork+0xa8>
    if(p->ofile[i])
    80001e06:	6088                	ld	a0,0(s1)
    80001e08:	d97d                	beqz	a0,80001dfe <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e0a:	624020ef          	jal	8000442e <filedup>
    80001e0e:	00a93023          	sd	a0,0(s2)
    80001e12:	b7f5                	j	80001dfe <fork+0x92>
  np->cwd = idup(p->cwd);
    80001e14:	150ab503          	ld	a0,336(s5)
    80001e18:	177010ef          	jal	8000378e <idup>
    80001e1c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e20:	4641                	li	a2,16
    80001e22:	158a8593          	addi	a1,s5,344
    80001e26:	158a0513          	addi	a0,s4,344
    80001e2a:	febfe0ef          	jal	80000e14 <safestrcpy>
  pid = np->pid;
    80001e2e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001e32:	8552                	mv	a0,s4
    80001e34:	e67fe0ef          	jal	80000c9a <release>
  acquire(&wait_lock);
    80001e38:	00011497          	auipc	s1,0x11
    80001e3c:	88048493          	addi	s1,s1,-1920 # 800126b8 <wait_lock>
    80001e40:	8526                	mv	a0,s1
    80001e42:	dc1fe0ef          	jal	80000c02 <acquire>
  np->parent = p;
    80001e46:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001e4a:	8526                	mv	a0,s1
    80001e4c:	e4ffe0ef          	jal	80000c9a <release>
  acquire(&np->lock);
    80001e50:	8552                	mv	a0,s4
    80001e52:	db1fe0ef          	jal	80000c02 <acquire>
  np->state = RUNNABLE;
    80001e56:	478d                	li	a5,3
    80001e58:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e5c:	8552                	mv	a0,s4
    80001e5e:	e3dfe0ef          	jal	80000c9a <release>
  return pid;
    80001e62:	74a2                	ld	s1,40(sp)
    80001e64:	69e2                	ld	s3,24(sp)
    80001e66:	6a42                	ld	s4,16(sp)
}
    80001e68:	854a                	mv	a0,s2
    80001e6a:	70e2                	ld	ra,56(sp)
    80001e6c:	7442                	ld	s0,48(sp)
    80001e6e:	7902                	ld	s2,32(sp)
    80001e70:	6aa2                	ld	s5,8(sp)
    80001e72:	6121                	addi	sp,sp,64
    80001e74:	8082                	ret
    return -1;
    80001e76:	597d                	li	s2,-1
    80001e78:	bfc5                	j	80001e68 <fork+0xfc>

0000000080001e7a <update_time>:
{
    80001e7a:	7179                	addi	sp,sp,-48
    80001e7c:	f406                	sd	ra,40(sp)
    80001e7e:	f022                	sd	s0,32(sp)
    80001e80:	ec26                	sd	s1,24(sp)
    80001e82:	e84a                	sd	s2,16(sp)
    80001e84:	e44e                	sd	s3,8(sp)
    80001e86:	e052                	sd	s4,0(sp)
    80001e88:	1800                	addi	s0,sp,48
  for (p = proc; p < &proc[NPROC]; p++) {
    80001e8a:	00011497          	auipc	s1,0x11
    80001e8e:	c4648493          	addi	s1,s1,-954 # 80012ad0 <proc>
    if (p->state == RUNNING) {
    80001e92:	4991                	li	s3,4
    if (p->state == RUNNABLE) {
    80001e94:	4a0d                	li	s4,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001e96:	00017917          	auipc	s2,0x17
    80001e9a:	c3a90913          	addi	s2,s2,-966 # 80018ad0 <tickslock>
    80001e9e:	a829                	j	80001eb8 <update_time+0x3e>
      p->run_time++;
    80001ea0:	16c4a783          	lw	a5,364(s1)
    80001ea4:	2785                	addiw	a5,a5,1
    80001ea6:	16f4a623          	sw	a5,364(s1)
    release(&p->lock);//lehd hena
    80001eaa:	8526                	mv	a0,s1
    80001eac:	deffe0ef          	jal	80000c9a <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001eb0:	18048493          	addi	s1,s1,384
    80001eb4:	03248063          	beq	s1,s2,80001ed4 <update_time+0x5a>
    acquire(&p->lock);//n3adel mn hena
    80001eb8:	8526                	mv	a0,s1
    80001eba:	d49fe0ef          	jal	80000c02 <acquire>
    if (p->state == RUNNING) {
    80001ebe:	4c9c                	lw	a5,24(s1)
    80001ec0:	ff3780e3          	beq	a5,s3,80001ea0 <update_time+0x26>
    if (p->state == RUNNABLE) {
    80001ec4:	ff4793e3          	bne	a5,s4,80001eaa <update_time+0x30>
      p->waiting_time++;
    80001ec8:	1784a783          	lw	a5,376(s1)
    80001ecc:	2785                	addiw	a5,a5,1
    80001ece:	16f4ac23          	sw	a5,376(s1)
    80001ed2:	bfe1                	j	80001eaa <update_time+0x30>
}
    80001ed4:	70a2                	ld	ra,40(sp)
    80001ed6:	7402                	ld	s0,32(sp)
    80001ed8:	64e2                	ld	s1,24(sp)
    80001eda:	6942                	ld	s2,16(sp)
    80001edc:	69a2                	ld	s3,8(sp)
    80001ede:	6a02                	ld	s4,0(sp)
    80001ee0:	6145                	addi	sp,sp,48
    80001ee2:	8082                	ret

0000000080001ee4 <choose_next_process>:
struct proc *choose_next_process() {
    80001ee4:	7179                	addi	sp,sp,-48
    80001ee6:	f406                	sd	ra,40(sp)
    80001ee8:	f022                	sd	s0,32(sp)
    80001eea:	ec26                	sd	s1,24(sp)
    80001eec:	1800                	addi	s0,sp,48
  if(sched_mode == SCHED_ROUND_ROBIN) {
    80001eee:	00008797          	auipc	a5,0x8
    80001ef2:	66a7a783          	lw	a5,1642(a5) # 8000a558 <sched_mode>
    80001ef6:	e39d                	bnez	a5,80001f1c <choose_next_process+0x38>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ef8:	00011497          	auipc	s1,0x11
    80001efc:	bd848493          	addi	s1,s1,-1064 # 80012ad0 <proc>
      if (p->state == RUNNABLE)
    80001f00:	470d                	li	a4,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f02:	00017697          	auipc	a3,0x17
    80001f06:	bce68693          	addi	a3,a3,-1074 # 80018ad0 <tickslock>
      if (p->state == RUNNABLE)
    80001f0a:	4c9c                	lw	a5,24(s1)
    80001f0c:	10e78863          	beq	a5,a4,8000201c <choose_next_process+0x138>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f10:	18048493          	addi	s1,s1,384
    80001f14:	fed49be3          	bne	s1,a3,80001f0a <choose_next_process+0x26>
  return 0;
    80001f18:	4481                	li	s1,0
    80001f1a:	a209                	j	8000201c <choose_next_process+0x138>
  else if (sched_mode == SCHED_FCFS) {
    80001f1c:	4705                	li	a4,1
    80001f1e:	02e78463          	beq	a5,a4,80001f46 <choose_next_process+0x62>
  else if (sched_mode == SCHED_PRIORITY) {
    80001f22:	4709                	li	a4,2
  return 0;
    80001f24:	4481                	li	s1,0
  else if (sched_mode == SCHED_PRIORITY) {
    80001f26:	0ee79b63          	bne	a5,a4,8000201c <choose_next_process+0x138>
    80001f2a:	e84a                	sd	s2,16(sp)
    80001f2c:	e44e                	sd	s3,8(sp)
    80001f2e:	e052                	sd	s4,0(sp)
      int max_prio = -1;
    80001f30:	597d                	li	s2,-1
      for(p = proc; p < &proc[NPROC]; p++) {
    80001f32:	00011497          	auipc	s1,0x11
    80001f36:	b9e48493          	addi	s1,s1,-1122 # 80012ad0 <proc>
        if(p->state == RUNNABLE) {
    80001f3a:	4a0d                	li	s4,3
      for(p = proc; p < &proc[NPROC]; p++) {
    80001f3c:	00017997          	auipc	s3,0x17
    80001f40:	b9498993          	addi	s3,s3,-1132 # 80018ad0 <tickslock>
    80001f44:	a8a5                	j	80001fbc <choose_next_process+0xd8>
    80001f46:	e84a                	sd	s2,16(sp)
    80001f48:	e44e                	sd	s3,8(sp)
    80001f4a:	e052                	sd	s4,0(sp)
  struct proc *min_proc = 0;
    80001f4c:	4481                	li	s1,0
     for(p = proc; p < &proc[NPROC]; p++) {
    80001f4e:	00011917          	auipc	s2,0x11
    80001f52:	b8290913          	addi	s2,s2,-1150 # 80012ad0 <proc>
      if(p->state == RUNNABLE) {
    80001f56:	4a0d                	li	s4,3
     for(p = proc; p < &proc[NPROC]; p++) {
    80001f58:	00017997          	auipc	s3,0x17
    80001f5c:	b7898993          	addi	s3,s3,-1160 # 80018ad0 <tickslock>
    80001f60:	a801                	j	80001f70 <choose_next_process+0x8c>
          release(&p->lock);
    80001f62:	854a                	mv	a0,s2
    80001f64:	d37fe0ef          	jal	80000c9a <release>
     for(p = proc; p < &proc[NPROC]; p++) {
    80001f68:	18090913          	addi	s2,s2,384
    80001f6c:	03390763          	beq	s2,s3,80001f9a <choose_next_process+0xb6>
      acquire(&p->lock);
    80001f70:	854a                	mv	a0,s2
    80001f72:	c91fe0ef          	jal	80000c02 <acquire>
      if(p->state == RUNNABLE) {
    80001f76:	01892783          	lw	a5,24(s2)
    80001f7a:	ff4794e3          	bne	a5,s4,80001f62 <choose_next_process+0x7e>
            if(min_proc == 0 || p->creation_time < min_proc->creation_time) {
    80001f7e:	cc81                	beqz	s1,80001f96 <choose_next_process+0xb2>
    80001f80:	16892703          	lw	a4,360(s2)
    80001f84:	1684a783          	lw	a5,360(s1)
    80001f88:	fcf77de3          	bgeu	a4,a5,80001f62 <choose_next_process+0x7e>
              if(min_proc != 0) release(&min_proc->lock); // Release prev candidate
    80001f8c:	8526                	mv	a0,s1
    80001f8e:	d0dfe0ef          	jal	80000c9a <release>
              min_proc= p; // Keep lock held for the new candidate
    80001f92:	84ca                	mv	s1,s2
    80001f94:	bfd1                	j	80001f68 <choose_next_process+0x84>
    80001f96:	84ca                	mv	s1,s2
    80001f98:	bfc1                	j	80001f68 <choose_next_process+0x84>
        if(min_proc!= 0) {
    80001f9a:	c0cd                	beqz	s1,8000203c <choose_next_process+0x158>
          release(&min_proc->lock);
    80001f9c:	8526                	mv	a0,s1
    80001f9e:	cfdfe0ef          	jal	80000c9a <release>
    80001fa2:	6942                	ld	s2,16(sp)
    80001fa4:	69a2                	ld	s3,8(sp)
    80001fa6:	6a02                	ld	s4,0(sp)
    80001fa8:	a895                	j	8000201c <choose_next_process+0x138>
            if(p->priority > max_prio) {
    80001faa:	0007091b          	sext.w	s2,a4
        release(&p->lock);
    80001fae:	8526                	mv	a0,s1
    80001fb0:	cebfe0ef          	jal	80000c9a <release>
      for(p = proc; p < &proc[NPROC]; p++) {
    80001fb4:	18048493          	addi	s1,s1,384
    80001fb8:	01348f63          	beq	s1,s3,80001fd6 <choose_next_process+0xf2>
        acquire(&p->lock);
    80001fbc:	8526                	mv	a0,s1
    80001fbe:	c45fe0ef          	jal	80000c02 <acquire>
        if(p->state == RUNNABLE) {
    80001fc2:	4c9c                	lw	a5,24(s1)
    80001fc4:	ff4795e3          	bne	a5,s4,80001fae <choose_next_process+0xca>
            if(p->priority > max_prio) {
    80001fc8:	58dc                	lw	a5,52(s1)
    80001fca:	873e                	mv	a4,a5
    80001fcc:	2781                	sext.w	a5,a5
    80001fce:	fd27dee3          	bge	a5,s2,80001faa <choose_next_process+0xc6>
    80001fd2:	874a                	mv	a4,s2
    80001fd4:	bfd9                	j	80001faa <choose_next_process+0xc6>
      if(max_prio == -1) return 0;
    80001fd6:	57fd                	li	a5,-1
    80001fd8:	04f90d63          	beq	s2,a5,80002032 <choose_next_process+0x14e>
      for(p = proc; p < &proc[NPROC]; p++) {
    80001fdc:	00011497          	auipc	s1,0x11
    80001fe0:	af448493          	addi	s1,s1,-1292 # 80012ad0 <proc>
          if(p->state == RUNNABLE && p->priority == max_prio) {
    80001fe4:	498d                	li	s3,3
      for(p = proc; p < &proc[NPROC]; p++) {
    80001fe6:	00017a17          	auipc	s4,0x17
    80001fea:	aeaa0a13          	addi	s4,s4,-1302 # 80018ad0 <tickslock>
    80001fee:	a801                	j	80001ffe <choose_next_process+0x11a>
          release(&p->lock);
    80001ff0:	8526                	mv	a0,s1
    80001ff2:	ca9fe0ef          	jal	80000c9a <release>
      for(p = proc; p < &proc[NPROC]; p++) {
    80001ff6:	18048493          	addi	s1,s1,384
    80001ffa:	03448763          	beq	s1,s4,80002028 <choose_next_process+0x144>
          acquire(&p->lock);
    80001ffe:	8526                	mv	a0,s1
    80002000:	c03fe0ef          	jal	80000c02 <acquire>
          if(p->state == RUNNABLE && p->priority == max_prio) {
    80002004:	4c9c                	lw	a5,24(s1)
    80002006:	ff3795e3          	bne	a5,s3,80001ff0 <choose_next_process+0x10c>
    8000200a:	58dc                	lw	a5,52(s1)
    8000200c:	ff2792e3          	bne	a5,s2,80001ff0 <choose_next_process+0x10c>
              release(&p->lock); // Unlock before returning
    80002010:	8526                	mv	a0,s1
    80002012:	c89fe0ef          	jal	80000c9a <release>
              return p;
    80002016:	6942                	ld	s2,16(sp)
    80002018:	69a2                	ld	s3,8(sp)
    8000201a:	6a02                	ld	s4,0(sp)
}
    8000201c:	8526                	mv	a0,s1
    8000201e:	70a2                	ld	ra,40(sp)
    80002020:	7402                	ld	s0,32(sp)
    80002022:	64e2                	ld	s1,24(sp)
    80002024:	6145                	addi	sp,sp,48
    80002026:	8082                	ret
  return 0;
    80002028:	4481                	li	s1,0
    8000202a:	6942                	ld	s2,16(sp)
    8000202c:	69a2                	ld	s3,8(sp)
    8000202e:	6a02                	ld	s4,0(sp)
    80002030:	b7f5                	j	8000201c <choose_next_process+0x138>
      if(max_prio == -1) return 0;
    80002032:	4481                	li	s1,0
    80002034:	6942                	ld	s2,16(sp)
    80002036:	69a2                	ld	s3,8(sp)
    80002038:	6a02                	ld	s4,0(sp)
    8000203a:	b7cd                	j	8000201c <choose_next_process+0x138>
    8000203c:	6942                	ld	s2,16(sp)
    8000203e:	69a2                	ld	s3,8(sp)
    80002040:	6a02                	ld	s4,0(sp)
    80002042:	bfe9                	j	8000201c <choose_next_process+0x138>

0000000080002044 <scheduler>:
{
    80002044:	7139                	addi	sp,sp,-64
    80002046:	fc06                	sd	ra,56(sp)
    80002048:	f822                	sd	s0,48(sp)
    8000204a:	f426                	sd	s1,40(sp)
    8000204c:	f04a                	sd	s2,32(sp)
    8000204e:	ec4e                	sd	s3,24(sp)
    80002050:	e852                	sd	s4,16(sp)
    80002052:	e456                	sd	s5,8(sp)
    80002054:	0080                	addi	s0,sp,64
    80002056:	8792                	mv	a5,tp
  int id = r_tp();
    80002058:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000205a:	00779a13          	slli	s4,a5,0x7
    8000205e:	00010717          	auipc	a4,0x10
    80002062:	64270713          	addi	a4,a4,1602 # 800126a0 <pid_lock>
    80002066:	9752                	add	a4,a4,s4
    80002068:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000206c:	00010717          	auipc	a4,0x10
    80002070:	66c70713          	addi	a4,a4,1644 # 800126d8 <cpus+0x8>
    80002074:	9a3a                	add	s4,s4,a4
      if (p->state == RUNNABLE) {
    80002076:	490d                	li	s2,3
        p->state = RUNNING;
    80002078:	4a91                	li	s5,4
        c->proc = p;
    8000207a:	079e                	slli	a5,a5,0x7
    8000207c:	00010997          	auipc	s3,0x10
    80002080:	62498993          	addi	s3,s3,1572 # 800126a0 <pid_lock>
    80002084:	99be                	add	s3,s3,a5
    80002086:	a805                	j	800020b6 <scheduler+0x72>
        p->state = RUNNING;
    80002088:	0154ac23          	sw	s5,24(s1)
        c->proc = p;
    8000208c:	0299b823          	sd	s1,48(s3)
        swtch(&c->context, &p->context);
    80002090:	06048593          	addi	a1,s1,96
    80002094:	8552                	mv	a0,s4
    80002096:	736000ef          	jal	800027cc <swtch>
        c->proc = 0;
    8000209a:	0209b823          	sd	zero,48(s3)
      release(&p->lock);
    8000209e:	8526                	mv	a0,s1
    800020a0:	bfbfe0ef          	jal	80000c9a <release>
    if(found == 0) {
    800020a4:	a809                	j	800020b6 <scheduler+0x72>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020a6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800020aa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800020ae:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    800020b2:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020b6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800020ba:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800020be:	10079073          	csrw	sstatus,a5
    p = choose_next_process();
    800020c2:	e23ff0ef          	jal	80001ee4 <choose_next_process>
    800020c6:	84aa                	mv	s1,a0
    if(p != 0) {
    800020c8:	dd79                	beqz	a0,800020a6 <scheduler+0x62>
      acquire(&p->lock);
    800020ca:	b39fe0ef          	jal	80000c02 <acquire>
      if (p->state == RUNNABLE) {
    800020ce:	4c9c                	lw	a5,24(s1)
    800020d0:	fb278ce3          	beq	a5,s2,80002088 <scheduler+0x44>
      release(&p->lock);
    800020d4:	8526                	mv	a0,s1
    800020d6:	bc5fe0ef          	jal	80000c9a <release>
    if(found == 0) {
    800020da:	b7f1                	j	800020a6 <scheduler+0x62>

00000000800020dc <sched>:
{
    800020dc:	7179                	addi	sp,sp,-48
    800020de:	f406                	sd	ra,40(sp)
    800020e0:	f022                	sd	s0,32(sp)
    800020e2:	ec26                	sd	s1,24(sp)
    800020e4:	e84a                	sd	s2,16(sp)
    800020e6:	e44e                	sd	s3,8(sp)
    800020e8:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800020ea:	829ff0ef          	jal	80001912 <myproc>
    800020ee:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800020f0:	aa9fe0ef          	jal	80000b98 <holding>
    800020f4:	c92d                	beqz	a0,80002166 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020f6:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800020f8:	2781                	sext.w	a5,a5
    800020fa:	079e                	slli	a5,a5,0x7
    800020fc:	00010717          	auipc	a4,0x10
    80002100:	5a470713          	addi	a4,a4,1444 # 800126a0 <pid_lock>
    80002104:	97ba                	add	a5,a5,a4
    80002106:	0a87a703          	lw	a4,168(a5)
    8000210a:	4785                	li	a5,1
    8000210c:	06f71363          	bne	a4,a5,80002172 <sched+0x96>
  if(p->state == RUNNING)
    80002110:	4c98                	lw	a4,24(s1)
    80002112:	4791                	li	a5,4
    80002114:	06f70563          	beq	a4,a5,8000217e <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002118:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000211c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000211e:	e7b5                	bnez	a5,8000218a <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002120:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002122:	00010917          	auipc	s2,0x10
    80002126:	57e90913          	addi	s2,s2,1406 # 800126a0 <pid_lock>
    8000212a:	2781                	sext.w	a5,a5
    8000212c:	079e                	slli	a5,a5,0x7
    8000212e:	97ca                	add	a5,a5,s2
    80002130:	0ac7a983          	lw	s3,172(a5)
    80002134:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002136:	2781                	sext.w	a5,a5
    80002138:	079e                	slli	a5,a5,0x7
    8000213a:	00010597          	auipc	a1,0x10
    8000213e:	59e58593          	addi	a1,a1,1438 # 800126d8 <cpus+0x8>
    80002142:	95be                	add	a1,a1,a5
    80002144:	06048513          	addi	a0,s1,96
    80002148:	684000ef          	jal	800027cc <swtch>
    8000214c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000214e:	2781                	sext.w	a5,a5
    80002150:	079e                	slli	a5,a5,0x7
    80002152:	993e                	add	s2,s2,a5
    80002154:	0b392623          	sw	s3,172(s2)
}
    80002158:	70a2                	ld	ra,40(sp)
    8000215a:	7402                	ld	s0,32(sp)
    8000215c:	64e2                	ld	s1,24(sp)
    8000215e:	6942                	ld	s2,16(sp)
    80002160:	69a2                	ld	s3,8(sp)
    80002162:	6145                	addi	sp,sp,48
    80002164:	8082                	ret
    panic("sched p->lock");
    80002166:	00005517          	auipc	a0,0x5
    8000216a:	0d250513          	addi	a0,a0,210 # 80007238 <etext+0x238>
    8000216e:	e34fe0ef          	jal	800007a2 <panic>
    panic("sched locks");
    80002172:	00005517          	auipc	a0,0x5
    80002176:	0d650513          	addi	a0,a0,214 # 80007248 <etext+0x248>
    8000217a:	e28fe0ef          	jal	800007a2 <panic>
    panic("sched running");
    8000217e:	00005517          	auipc	a0,0x5
    80002182:	0da50513          	addi	a0,a0,218 # 80007258 <etext+0x258>
    80002186:	e1cfe0ef          	jal	800007a2 <panic>
    panic("sched interruptible");
    8000218a:	00005517          	auipc	a0,0x5
    8000218e:	0de50513          	addi	a0,a0,222 # 80007268 <etext+0x268>
    80002192:	e10fe0ef          	jal	800007a2 <panic>

0000000080002196 <yield>:
{
    80002196:	1101                	addi	sp,sp,-32
    80002198:	ec06                	sd	ra,24(sp)
    8000219a:	e822                	sd	s0,16(sp)
    8000219c:	e426                	sd	s1,8(sp)
    8000219e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800021a0:	f72ff0ef          	jal	80001912 <myproc>
    800021a4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800021a6:	a5dfe0ef          	jal	80000c02 <acquire>
  p->state = RUNNABLE;
    800021aa:	478d                	li	a5,3
    800021ac:	cc9c                	sw	a5,24(s1)
  sched();
    800021ae:	f2fff0ef          	jal	800020dc <sched>
  release(&p->lock);
    800021b2:	8526                	mv	a0,s1
    800021b4:	ae7fe0ef          	jal	80000c9a <release>
}
    800021b8:	60e2                	ld	ra,24(sp)
    800021ba:	6442                	ld	s0,16(sp)
    800021bc:	64a2                	ld	s1,8(sp)
    800021be:	6105                	addi	sp,sp,32
    800021c0:	8082                	ret

00000000800021c2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800021c2:	7179                	addi	sp,sp,-48
    800021c4:	f406                	sd	ra,40(sp)
    800021c6:	f022                	sd	s0,32(sp)
    800021c8:	ec26                	sd	s1,24(sp)
    800021ca:	e84a                	sd	s2,16(sp)
    800021cc:	e44e                	sd	s3,8(sp)
    800021ce:	1800                	addi	s0,sp,48
    800021d0:	89aa                	mv	s3,a0
    800021d2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021d4:	f3eff0ef          	jal	80001912 <myproc>
    800021d8:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800021da:	a29fe0ef          	jal	80000c02 <acquire>
  release(lk);
    800021de:	854a                	mv	a0,s2
    800021e0:	abbfe0ef          	jal	80000c9a <release>

  // Go to sleep.
  p->chan = chan;
    800021e4:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800021e8:	4789                	li	a5,2
    800021ea:	cc9c                	sw	a5,24(s1)

  sched();
    800021ec:	ef1ff0ef          	jal	800020dc <sched>

  // Tidy up.
  p->chan = 0;
    800021f0:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800021f4:	8526                	mv	a0,s1
    800021f6:	aa5fe0ef          	jal	80000c9a <release>
  acquire(lk);
    800021fa:	854a                	mv	a0,s2
    800021fc:	a07fe0ef          	jal	80000c02 <acquire>
}
    80002200:	70a2                	ld	ra,40(sp)
    80002202:	7402                	ld	s0,32(sp)
    80002204:	64e2                	ld	s1,24(sp)
    80002206:	6942                	ld	s2,16(sp)
    80002208:	69a2                	ld	s3,8(sp)
    8000220a:	6145                	addi	sp,sp,48
    8000220c:	8082                	ret

000000008000220e <wait_sched>:
{
    8000220e:	711d                	addi	sp,sp,-96
    80002210:	ec86                	sd	ra,88(sp)
    80002212:	e8a2                	sd	s0,80(sp)
    80002214:	e4a6                	sd	s1,72(sp)
    80002216:	e0ca                	sd	s2,64(sp)
    80002218:	fc4e                	sd	s3,56(sp)
    8000221a:	f852                	sd	s4,48(sp)
    8000221c:	f456                	sd	s5,40(sp)
    8000221e:	f05a                	sd	s6,32(sp)
    80002220:	ec5e                	sd	s7,24(sp)
    80002222:	e862                	sd	s8,16(sp)
    80002224:	e466                	sd	s9,8(sp)
    80002226:	e06a                	sd	s10,0(sp)
    80002228:	1080                	addi	s0,sp,96
    8000222a:	8c2a                	mv	s8,a0
    8000222c:	8bae                	mv	s7,a1
    8000222e:	8b32                	mv	s6,a2
  struct proc *p = myproc();
    80002230:	ee2ff0ef          	jal	80001912 <myproc>
    80002234:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002236:	00010517          	auipc	a0,0x10
    8000223a:	48250513          	addi	a0,a0,1154 # 800126b8 <wait_lock>
    8000223e:	9c5fe0ef          	jal	80000c02 <acquire>
    havekids = 0;
    80002242:	4c81                	li	s9,0
        if(np->state == ZOMBIE){
    80002244:	4a15                	li	s4,5
        havekids = 1;
    80002246:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80002248:	00017997          	auipc	s3,0x17
    8000224c:	88898993          	addi	s3,s3,-1912 # 80018ad0 <tickslock>
    sleep(p, &wait_lock);  
    80002250:	00010d17          	auipc	s10,0x10
    80002254:	468d0d13          	addi	s10,s10,1128 # 800126b8 <wait_lock>
    80002258:	a8ed                	j	80002352 <wait_sched+0x144>
          pid = np->pid;
    8000225a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000225e:	040c1b63          	bnez	s8,800022b4 <wait_sched+0xa6>
          if(addr_tt != 0 && copyout(p->pagetable, addr_tt, (char *)&np->turnaround_time,
    80002262:	060b9e63          	bnez	s7,800022de <wait_sched+0xd0>
          if(addr_wt != 0 && copyout(p->pagetable, addr_wt, (char *)&np->waiting_time,
    80002266:	000b0c63          	beqz	s6,8000227e <wait_sched+0x70>
    8000226a:	4691                	li	a3,4
    8000226c:	17848613          	addi	a2,s1,376
    80002270:	85da                	mv	a1,s6
    80002272:	05093503          	ld	a0,80(s2)
    80002276:	b0eff0ef          	jal	80001584 <copyout>
    8000227a:	08054763          	bltz	a0,80002308 <wait_sched+0xfa>
          freeproc(np);
    8000227e:	8526                	mv	a0,s1
    80002280:	8f5ff0ef          	jal	80001b74 <freeproc>
          release(&np->lock);
    80002284:	8526                	mv	a0,s1
    80002286:	a15fe0ef          	jal	80000c9a <release>
          release(&wait_lock);
    8000228a:	00010517          	auipc	a0,0x10
    8000228e:	42e50513          	addi	a0,a0,1070 # 800126b8 <wait_lock>
    80002292:	a09fe0ef          	jal	80000c9a <release>
}
    80002296:	854e                	mv	a0,s3
    80002298:	60e6                	ld	ra,88(sp)
    8000229a:	6446                	ld	s0,80(sp)
    8000229c:	64a6                	ld	s1,72(sp)
    8000229e:	6906                	ld	s2,64(sp)
    800022a0:	79e2                	ld	s3,56(sp)
    800022a2:	7a42                	ld	s4,48(sp)
    800022a4:	7aa2                	ld	s5,40(sp)
    800022a6:	7b02                	ld	s6,32(sp)
    800022a8:	6be2                	ld	s7,24(sp)
    800022aa:	6c42                	ld	s8,16(sp)
    800022ac:	6ca2                	ld	s9,8(sp)
    800022ae:	6d02                	ld	s10,0(sp)
    800022b0:	6125                	addi	sp,sp,96
    800022b2:	8082                	ret
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800022b4:	4691                	li	a3,4
    800022b6:	02c48613          	addi	a2,s1,44
    800022ba:	85e2                	mv	a1,s8
    800022bc:	05093503          	ld	a0,80(s2)
    800022c0:	ac4ff0ef          	jal	80001584 <copyout>
    800022c4:	f8055fe3          	bgez	a0,80002262 <wait_sched+0x54>
            release(&np->lock);
    800022c8:	8526                	mv	a0,s1
    800022ca:	9d1fe0ef          	jal	80000c9a <release>
            release(&wait_lock);
    800022ce:	00010517          	auipc	a0,0x10
    800022d2:	3ea50513          	addi	a0,a0,1002 # 800126b8 <wait_lock>
    800022d6:	9c5fe0ef          	jal	80000c9a <release>
            return -1;
    800022da:	59fd                	li	s3,-1
    800022dc:	bf6d                	j	80002296 <wait_sched+0x88>
          if(addr_tt != 0 && copyout(p->pagetable, addr_tt, (char *)&np->turnaround_time,
    800022de:	4691                	li	a3,4
    800022e0:	17448613          	addi	a2,s1,372
    800022e4:	85de                	mv	a1,s7
    800022e6:	05093503          	ld	a0,80(s2)
    800022ea:	a9aff0ef          	jal	80001584 <copyout>
    800022ee:	f6055ce3          	bgez	a0,80002266 <wait_sched+0x58>
            release(&np->lock);
    800022f2:	8526                	mv	a0,s1
    800022f4:	9a7fe0ef          	jal	80000c9a <release>
            release(&wait_lock);
    800022f8:	00010517          	auipc	a0,0x10
    800022fc:	3c050513          	addi	a0,a0,960 # 800126b8 <wait_lock>
    80002300:	99bfe0ef          	jal	80000c9a <release>
            return -1;
    80002304:	59fd                	li	s3,-1
    80002306:	bf41                	j	80002296 <wait_sched+0x88>
             release(&np->lock);
    80002308:	8526                	mv	a0,s1
    8000230a:	991fe0ef          	jal	80000c9a <release>
             release(&wait_lock);
    8000230e:	00010517          	auipc	a0,0x10
    80002312:	3aa50513          	addi	a0,a0,938 # 800126b8 <wait_lock>
    80002316:	985fe0ef          	jal	80000c9a <release>
             return -1;
    8000231a:	59fd                	li	s3,-1
    8000231c:	bfad                	j	80002296 <wait_sched+0x88>
    for(np = proc; np < &proc[NPROC]; np++){
    8000231e:	18048493          	addi	s1,s1,384
    80002322:	03348063          	beq	s1,s3,80002342 <wait_sched+0x134>
      if(np->parent == p){
    80002326:	7c9c                	ld	a5,56(s1)
    80002328:	ff279be3          	bne	a5,s2,8000231e <wait_sched+0x110>
        acquire(&np->lock);
    8000232c:	8526                	mv	a0,s1
    8000232e:	8d5fe0ef          	jal	80000c02 <acquire>
        if(np->state == ZOMBIE){
    80002332:	4c9c                	lw	a5,24(s1)
    80002334:	f34783e3          	beq	a5,s4,8000225a <wait_sched+0x4c>
        release(&np->lock);
    80002338:	8526                	mv	a0,s1
    8000233a:	961fe0ef          	jal	80000c9a <release>
        havekids = 1;
    8000233e:	8756                	mv	a4,s5
    80002340:	bff9                	j	8000231e <wait_sched+0x110>
    if(!havekids || p->killed){
    80002342:	cf11                	beqz	a4,8000235e <wait_sched+0x150>
    80002344:	02892783          	lw	a5,40(s2)
    80002348:	eb99                	bnez	a5,8000235e <wait_sched+0x150>
    sleep(p, &wait_lock);  
    8000234a:	85ea                	mv	a1,s10
    8000234c:	854a                	mv	a0,s2
    8000234e:	e75ff0ef          	jal	800021c2 <sleep>
    havekids = 0;
    80002352:	8766                	mv	a4,s9
    for(np = proc; np < &proc[NPROC]; np++){
    80002354:	00010497          	auipc	s1,0x10
    80002358:	77c48493          	addi	s1,s1,1916 # 80012ad0 <proc>
    8000235c:	b7e9                	j	80002326 <wait_sched+0x118>
      release(&wait_lock);
    8000235e:	00010517          	auipc	a0,0x10
    80002362:	35a50513          	addi	a0,a0,858 # 800126b8 <wait_lock>
    80002366:	935fe0ef          	jal	80000c9a <release>
      return -1;
    8000236a:	59fd                	li	s3,-1
    8000236c:	b72d                	j	80002296 <wait_sched+0x88>

000000008000236e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000236e:	7139                	addi	sp,sp,-64
    80002370:	fc06                	sd	ra,56(sp)
    80002372:	f822                	sd	s0,48(sp)
    80002374:	f426                	sd	s1,40(sp)
    80002376:	f04a                	sd	s2,32(sp)
    80002378:	ec4e                	sd	s3,24(sp)
    8000237a:	e852                	sd	s4,16(sp)
    8000237c:	e456                	sd	s5,8(sp)
    8000237e:	0080                	addi	s0,sp,64
    80002380:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002382:	00010497          	auipc	s1,0x10
    80002386:	74e48493          	addi	s1,s1,1870 # 80012ad0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000238a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000238c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000238e:	00016917          	auipc	s2,0x16
    80002392:	74290913          	addi	s2,s2,1858 # 80018ad0 <tickslock>
    80002396:	a801                	j	800023a6 <wakeup+0x38>
      }
      release(&p->lock);
    80002398:	8526                	mv	a0,s1
    8000239a:	901fe0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000239e:	18048493          	addi	s1,s1,384
    800023a2:	03248263          	beq	s1,s2,800023c6 <wakeup+0x58>
    if(p != myproc()){
    800023a6:	d6cff0ef          	jal	80001912 <myproc>
    800023aa:	fea48ae3          	beq	s1,a0,8000239e <wakeup+0x30>
      acquire(&p->lock);
    800023ae:	8526                	mv	a0,s1
    800023b0:	853fe0ef          	jal	80000c02 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800023b4:	4c9c                	lw	a5,24(s1)
    800023b6:	ff3791e3          	bne	a5,s3,80002398 <wakeup+0x2a>
    800023ba:	709c                	ld	a5,32(s1)
    800023bc:	fd479ee3          	bne	a5,s4,80002398 <wakeup+0x2a>
        p->state = RUNNABLE;
    800023c0:	0154ac23          	sw	s5,24(s1)
    800023c4:	bfd1                	j	80002398 <wakeup+0x2a>
    }
  }
}
    800023c6:	70e2                	ld	ra,56(sp)
    800023c8:	7442                	ld	s0,48(sp)
    800023ca:	74a2                	ld	s1,40(sp)
    800023cc:	7902                	ld	s2,32(sp)
    800023ce:	69e2                	ld	s3,24(sp)
    800023d0:	6a42                	ld	s4,16(sp)
    800023d2:	6aa2                	ld	s5,8(sp)
    800023d4:	6121                	addi	sp,sp,64
    800023d6:	8082                	ret

00000000800023d8 <reparent>:
{
    800023d8:	7179                	addi	sp,sp,-48
    800023da:	f406                	sd	ra,40(sp)
    800023dc:	f022                	sd	s0,32(sp)
    800023de:	ec26                	sd	s1,24(sp)
    800023e0:	e84a                	sd	s2,16(sp)
    800023e2:	e44e                	sd	s3,8(sp)
    800023e4:	e052                	sd	s4,0(sp)
    800023e6:	1800                	addi	s0,sp,48
    800023e8:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800023ea:	00010497          	auipc	s1,0x10
    800023ee:	6e648493          	addi	s1,s1,1766 # 80012ad0 <proc>
      pp->parent = initproc;
    800023f2:	00008a17          	auipc	s4,0x8
    800023f6:	16ea0a13          	addi	s4,s4,366 # 8000a560 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800023fa:	00016997          	auipc	s3,0x16
    800023fe:	6d698993          	addi	s3,s3,1750 # 80018ad0 <tickslock>
    80002402:	a029                	j	8000240c <reparent+0x34>
    80002404:	18048493          	addi	s1,s1,384
    80002408:	01348b63          	beq	s1,s3,8000241e <reparent+0x46>
    if(pp->parent == p){
    8000240c:	7c9c                	ld	a5,56(s1)
    8000240e:	ff279be3          	bne	a5,s2,80002404 <reparent+0x2c>
      pp->parent = initproc;
    80002412:	000a3503          	ld	a0,0(s4)
    80002416:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002418:	f57ff0ef          	jal	8000236e <wakeup>
    8000241c:	b7e5                	j	80002404 <reparent+0x2c>
}
    8000241e:	70a2                	ld	ra,40(sp)
    80002420:	7402                	ld	s0,32(sp)
    80002422:	64e2                	ld	s1,24(sp)
    80002424:	6942                	ld	s2,16(sp)
    80002426:	69a2                	ld	s3,8(sp)
    80002428:	6a02                	ld	s4,0(sp)
    8000242a:	6145                	addi	sp,sp,48
    8000242c:	8082                	ret

000000008000242e <exit>:
{
    8000242e:	7179                	addi	sp,sp,-48
    80002430:	f406                	sd	ra,40(sp)
    80002432:	f022                	sd	s0,32(sp)
    80002434:	ec26                	sd	s1,24(sp)
    80002436:	e84a                	sd	s2,16(sp)
    80002438:	e44e                	sd	s3,8(sp)
    8000243a:	e052                	sd	s4,0(sp)
    8000243c:	1800                	addi	s0,sp,48
    8000243e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002440:	cd2ff0ef          	jal	80001912 <myproc>
    80002444:	89aa                	mv	s3,a0
  if(p == initproc)
    80002446:	00008797          	auipc	a5,0x8
    8000244a:	11a7b783          	ld	a5,282(a5) # 8000a560 <initproc>
    8000244e:	0d050493          	addi	s1,a0,208
    80002452:	15050913          	addi	s2,a0,336
    80002456:	00a79f63          	bne	a5,a0,80002474 <exit+0x46>
    panic("init exiting");
    8000245a:	00005517          	auipc	a0,0x5
    8000245e:	e2650513          	addi	a0,a0,-474 # 80007280 <etext+0x280>
    80002462:	b40fe0ef          	jal	800007a2 <panic>
      fileclose(f);
    80002466:	00e020ef          	jal	80004474 <fileclose>
      p->ofile[fd] = 0;
    8000246a:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000246e:	04a1                	addi	s1,s1,8
    80002470:	01248563          	beq	s1,s2,8000247a <exit+0x4c>
    if(p->ofile[fd]){
    80002474:	6088                	ld	a0,0(s1)
    80002476:	f965                	bnez	a0,80002466 <exit+0x38>
    80002478:	bfdd                	j	8000246e <exit+0x40>
  begin_op();
    8000247a:	3e1010ef          	jal	8000405a <begin_op>
  iput(p->cwd);
    8000247e:	1509b503          	ld	a0,336(s3)
    80002482:	4c4010ef          	jal	80003946 <iput>
  end_op();
    80002486:	43f010ef          	jal	800040c4 <end_op>
  p->cwd = 0;
    8000248a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000248e:	00010497          	auipc	s1,0x10
    80002492:	22a48493          	addi	s1,s1,554 # 800126b8 <wait_lock>
    80002496:	8526                	mv	a0,s1
    80002498:	f6afe0ef          	jal	80000c02 <acquire>
  reparent(p);
    8000249c:	854e                	mv	a0,s3
    8000249e:	f3bff0ef          	jal	800023d8 <reparent>
  wakeup(p->parent);
    800024a2:	0389b503          	ld	a0,56(s3)
    800024a6:	ec9ff0ef          	jal	8000236e <wakeup>
  acquire(&p->lock);
    800024aa:	854e                	mv	a0,s3
    800024ac:	f56fe0ef          	jal	80000c02 <acquire>
  p->finish_time = ticks;
    800024b0:	00008797          	auipc	a5,0x8
    800024b4:	0b87a783          	lw	a5,184(a5) # 8000a568 <ticks>
    800024b8:	16f9a823          	sw	a5,368(s3)
  p->turnaround_time = p->finish_time - p->creation_time;
    800024bc:	1689a703          	lw	a4,360(s3)
    800024c0:	9f99                	subw	a5,a5,a4
    800024c2:	16f9aa23          	sw	a5,372(s3)
  p->xstate = status;
    800024c6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800024ca:	4795                	li	a5,5
    800024cc:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800024d0:	8526                	mv	a0,s1
    800024d2:	fc8fe0ef          	jal	80000c9a <release>
  sched();
    800024d6:	c07ff0ef          	jal	800020dc <sched>
  panic("zombie exit");
    800024da:	00005517          	auipc	a0,0x5
    800024de:	db650513          	addi	a0,a0,-586 # 80007290 <etext+0x290>
    800024e2:	ac0fe0ef          	jal	800007a2 <panic>

00000000800024e6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800024e6:	7179                	addi	sp,sp,-48
    800024e8:	f406                	sd	ra,40(sp)
    800024ea:	f022                	sd	s0,32(sp)
    800024ec:	ec26                	sd	s1,24(sp)
    800024ee:	e84a                	sd	s2,16(sp)
    800024f0:	e44e                	sd	s3,8(sp)
    800024f2:	1800                	addi	s0,sp,48
    800024f4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800024f6:	00010497          	auipc	s1,0x10
    800024fa:	5da48493          	addi	s1,s1,1498 # 80012ad0 <proc>
    800024fe:	00016997          	auipc	s3,0x16
    80002502:	5d298993          	addi	s3,s3,1490 # 80018ad0 <tickslock>
    acquire(&p->lock);
    80002506:	8526                	mv	a0,s1
    80002508:	efafe0ef          	jal	80000c02 <acquire>
    if(p->pid == pid){
    8000250c:	589c                	lw	a5,48(s1)
    8000250e:	01278b63          	beq	a5,s2,80002524 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002512:	8526                	mv	a0,s1
    80002514:	f86fe0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002518:	18048493          	addi	s1,s1,384
    8000251c:	ff3495e3          	bne	s1,s3,80002506 <kill+0x20>
  }
  return -1;
    80002520:	557d                	li	a0,-1
    80002522:	a819                	j	80002538 <kill+0x52>
      p->killed = 1;
    80002524:	4785                	li	a5,1
    80002526:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002528:	4c98                	lw	a4,24(s1)
    8000252a:	4789                	li	a5,2
    8000252c:	00f70d63          	beq	a4,a5,80002546 <kill+0x60>
      release(&p->lock);
    80002530:	8526                	mv	a0,s1
    80002532:	f68fe0ef          	jal	80000c9a <release>
      return 0;
    80002536:	4501                	li	a0,0
}
    80002538:	70a2                	ld	ra,40(sp)
    8000253a:	7402                	ld	s0,32(sp)
    8000253c:	64e2                	ld	s1,24(sp)
    8000253e:	6942                	ld	s2,16(sp)
    80002540:	69a2                	ld	s3,8(sp)
    80002542:	6145                	addi	sp,sp,48
    80002544:	8082                	ret
        p->state = RUNNABLE;
    80002546:	478d                	li	a5,3
    80002548:	cc9c                	sw	a5,24(s1)
    8000254a:	b7dd                	j	80002530 <kill+0x4a>

000000008000254c <setkilled>:

void
setkilled(struct proc *p)
{
    8000254c:	1101                	addi	sp,sp,-32
    8000254e:	ec06                	sd	ra,24(sp)
    80002550:	e822                	sd	s0,16(sp)
    80002552:	e426                	sd	s1,8(sp)
    80002554:	1000                	addi	s0,sp,32
    80002556:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002558:	eaafe0ef          	jal	80000c02 <acquire>
  p->killed = 1;
    8000255c:	4785                	li	a5,1
    8000255e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002560:	8526                	mv	a0,s1
    80002562:	f38fe0ef          	jal	80000c9a <release>
}
    80002566:	60e2                	ld	ra,24(sp)
    80002568:	6442                	ld	s0,16(sp)
    8000256a:	64a2                	ld	s1,8(sp)
    8000256c:	6105                	addi	sp,sp,32
    8000256e:	8082                	ret

0000000080002570 <killed>:

int
killed(struct proc *p)
{
    80002570:	1101                	addi	sp,sp,-32
    80002572:	ec06                	sd	ra,24(sp)
    80002574:	e822                	sd	s0,16(sp)
    80002576:	e426                	sd	s1,8(sp)
    80002578:	e04a                	sd	s2,0(sp)
    8000257a:	1000                	addi	s0,sp,32
    8000257c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000257e:	e84fe0ef          	jal	80000c02 <acquire>
  k = p->killed;
    80002582:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002586:	8526                	mv	a0,s1
    80002588:	f12fe0ef          	jal	80000c9a <release>
  return k;
}
    8000258c:	854a                	mv	a0,s2
    8000258e:	60e2                	ld	ra,24(sp)
    80002590:	6442                	ld	s0,16(sp)
    80002592:	64a2                	ld	s1,8(sp)
    80002594:	6902                	ld	s2,0(sp)
    80002596:	6105                	addi	sp,sp,32
    80002598:	8082                	ret

000000008000259a <wait>:
{
    8000259a:	715d                	addi	sp,sp,-80
    8000259c:	e486                	sd	ra,72(sp)
    8000259e:	e0a2                	sd	s0,64(sp)
    800025a0:	fc26                	sd	s1,56(sp)
    800025a2:	f84a                	sd	s2,48(sp)
    800025a4:	f44e                	sd	s3,40(sp)
    800025a6:	f052                	sd	s4,32(sp)
    800025a8:	ec56                	sd	s5,24(sp)
    800025aa:	e85a                	sd	s6,16(sp)
    800025ac:	e45e                	sd	s7,8(sp)
    800025ae:	e062                	sd	s8,0(sp)
    800025b0:	0880                	addi	s0,sp,80
    800025b2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800025b4:	b5eff0ef          	jal	80001912 <myproc>
    800025b8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800025ba:	00010517          	auipc	a0,0x10
    800025be:	0fe50513          	addi	a0,a0,254 # 800126b8 <wait_lock>
    800025c2:	e40fe0ef          	jal	80000c02 <acquire>
    havekids = 0;
    800025c6:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800025c8:	4a15                	li	s4,5
        havekids = 1;
    800025ca:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800025cc:	00016997          	auipc	s3,0x16
    800025d0:	50498993          	addi	s3,s3,1284 # 80018ad0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800025d4:	00010c17          	auipc	s8,0x10
    800025d8:	0e4c0c13          	addi	s8,s8,228 # 800126b8 <wait_lock>
    800025dc:	a871                	j	80002678 <wait+0xde>
          pid = pp->pid;
    800025de:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800025e2:	000b0c63          	beqz	s6,800025fa <wait+0x60>
    800025e6:	4691                	li	a3,4
    800025e8:	02c48613          	addi	a2,s1,44
    800025ec:	85da                	mv	a1,s6
    800025ee:	05093503          	ld	a0,80(s2)
    800025f2:	f93fe0ef          	jal	80001584 <copyout>
    800025f6:	02054b63          	bltz	a0,8000262c <wait+0x92>
          freeproc(pp);
    800025fa:	8526                	mv	a0,s1
    800025fc:	d78ff0ef          	jal	80001b74 <freeproc>
          release(&pp->lock);
    80002600:	8526                	mv	a0,s1
    80002602:	e98fe0ef          	jal	80000c9a <release>
          release(&wait_lock);
    80002606:	00010517          	auipc	a0,0x10
    8000260a:	0b250513          	addi	a0,a0,178 # 800126b8 <wait_lock>
    8000260e:	e8cfe0ef          	jal	80000c9a <release>
}
    80002612:	854e                	mv	a0,s3
    80002614:	60a6                	ld	ra,72(sp)
    80002616:	6406                	ld	s0,64(sp)
    80002618:	74e2                	ld	s1,56(sp)
    8000261a:	7942                	ld	s2,48(sp)
    8000261c:	79a2                	ld	s3,40(sp)
    8000261e:	7a02                	ld	s4,32(sp)
    80002620:	6ae2                	ld	s5,24(sp)
    80002622:	6b42                	ld	s6,16(sp)
    80002624:	6ba2                	ld	s7,8(sp)
    80002626:	6c02                	ld	s8,0(sp)
    80002628:	6161                	addi	sp,sp,80
    8000262a:	8082                	ret
            release(&pp->lock);
    8000262c:	8526                	mv	a0,s1
    8000262e:	e6cfe0ef          	jal	80000c9a <release>
            release(&wait_lock);
    80002632:	00010517          	auipc	a0,0x10
    80002636:	08650513          	addi	a0,a0,134 # 800126b8 <wait_lock>
    8000263a:	e60fe0ef          	jal	80000c9a <release>
            return -1;
    8000263e:	59fd                	li	s3,-1
    80002640:	bfc9                	j	80002612 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002642:	18048493          	addi	s1,s1,384
    80002646:	03348063          	beq	s1,s3,80002666 <wait+0xcc>
      if(pp->parent == p){
    8000264a:	7c9c                	ld	a5,56(s1)
    8000264c:	ff279be3          	bne	a5,s2,80002642 <wait+0xa8>
        acquire(&pp->lock);
    80002650:	8526                	mv	a0,s1
    80002652:	db0fe0ef          	jal	80000c02 <acquire>
        if(pp->state == ZOMBIE){
    80002656:	4c9c                	lw	a5,24(s1)
    80002658:	f94783e3          	beq	a5,s4,800025de <wait+0x44>
        release(&pp->lock);
    8000265c:	8526                	mv	a0,s1
    8000265e:	e3cfe0ef          	jal	80000c9a <release>
        havekids = 1;
    80002662:	8756                	mv	a4,s5
    80002664:	bff9                	j	80002642 <wait+0xa8>
    if(!havekids || killed(p)){
    80002666:	cf19                	beqz	a4,80002684 <wait+0xea>
    80002668:	854a                	mv	a0,s2
    8000266a:	f07ff0ef          	jal	80002570 <killed>
    8000266e:	e919                	bnez	a0,80002684 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002670:	85e2                	mv	a1,s8
    80002672:	854a                	mv	a0,s2
    80002674:	b4fff0ef          	jal	800021c2 <sleep>
    havekids = 0;
    80002678:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000267a:	00010497          	auipc	s1,0x10
    8000267e:	45648493          	addi	s1,s1,1110 # 80012ad0 <proc>
    80002682:	b7e1                	j	8000264a <wait+0xb0>
      release(&wait_lock);
    80002684:	00010517          	auipc	a0,0x10
    80002688:	03450513          	addi	a0,a0,52 # 800126b8 <wait_lock>
    8000268c:	e0efe0ef          	jal	80000c9a <release>
      return -1;
    80002690:	59fd                	li	s3,-1
    80002692:	b741                	j	80002612 <wait+0x78>

0000000080002694 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002694:	7179                	addi	sp,sp,-48
    80002696:	f406                	sd	ra,40(sp)
    80002698:	f022                	sd	s0,32(sp)
    8000269a:	ec26                	sd	s1,24(sp)
    8000269c:	e84a                	sd	s2,16(sp)
    8000269e:	e44e                	sd	s3,8(sp)
    800026a0:	e052                	sd	s4,0(sp)
    800026a2:	1800                	addi	s0,sp,48
    800026a4:	84aa                	mv	s1,a0
    800026a6:	892e                	mv	s2,a1
    800026a8:	89b2                	mv	s3,a2
    800026aa:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800026ac:	a66ff0ef          	jal	80001912 <myproc>
  if(user_dst){
    800026b0:	cc99                	beqz	s1,800026ce <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800026b2:	86d2                	mv	a3,s4
    800026b4:	864e                	mv	a2,s3
    800026b6:	85ca                	mv	a1,s2
    800026b8:	6928                	ld	a0,80(a0)
    800026ba:	ecbfe0ef          	jal	80001584 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800026be:	70a2                	ld	ra,40(sp)
    800026c0:	7402                	ld	s0,32(sp)
    800026c2:	64e2                	ld	s1,24(sp)
    800026c4:	6942                	ld	s2,16(sp)
    800026c6:	69a2                	ld	s3,8(sp)
    800026c8:	6a02                	ld	s4,0(sp)
    800026ca:	6145                	addi	sp,sp,48
    800026cc:	8082                	ret
    memmove((char *)dst, src, len);
    800026ce:	000a061b          	sext.w	a2,s4
    800026d2:	85ce                	mv	a1,s3
    800026d4:	854a                	mv	a0,s2
    800026d6:	e5cfe0ef          	jal	80000d32 <memmove>
    return 0;
    800026da:	8526                	mv	a0,s1
    800026dc:	b7cd                	j	800026be <either_copyout+0x2a>

00000000800026de <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800026de:	7179                	addi	sp,sp,-48
    800026e0:	f406                	sd	ra,40(sp)
    800026e2:	f022                	sd	s0,32(sp)
    800026e4:	ec26                	sd	s1,24(sp)
    800026e6:	e84a                	sd	s2,16(sp)
    800026e8:	e44e                	sd	s3,8(sp)
    800026ea:	e052                	sd	s4,0(sp)
    800026ec:	1800                	addi	s0,sp,48
    800026ee:	892a                	mv	s2,a0
    800026f0:	84ae                	mv	s1,a1
    800026f2:	89b2                	mv	s3,a2
    800026f4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800026f6:	a1cff0ef          	jal	80001912 <myproc>
  if(user_src){
    800026fa:	cc99                	beqz	s1,80002718 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800026fc:	86d2                	mv	a3,s4
    800026fe:	864e                	mv	a2,s3
    80002700:	85ca                	mv	a1,s2
    80002702:	6928                	ld	a0,80(a0)
    80002704:	f57fe0ef          	jal	8000165a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002708:	70a2                	ld	ra,40(sp)
    8000270a:	7402                	ld	s0,32(sp)
    8000270c:	64e2                	ld	s1,24(sp)
    8000270e:	6942                	ld	s2,16(sp)
    80002710:	69a2                	ld	s3,8(sp)
    80002712:	6a02                	ld	s4,0(sp)
    80002714:	6145                	addi	sp,sp,48
    80002716:	8082                	ret
    memmove(dst, (char*)src, len);
    80002718:	000a061b          	sext.w	a2,s4
    8000271c:	85ce                	mv	a1,s3
    8000271e:	854a                	mv	a0,s2
    80002720:	e12fe0ef          	jal	80000d32 <memmove>
    return 0;
    80002724:	8526                	mv	a0,s1
    80002726:	b7cd                	j	80002708 <either_copyin+0x2a>

0000000080002728 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002728:	715d                	addi	sp,sp,-80
    8000272a:	e486                	sd	ra,72(sp)
    8000272c:	e0a2                	sd	s0,64(sp)
    8000272e:	fc26                	sd	s1,56(sp)
    80002730:	f84a                	sd	s2,48(sp)
    80002732:	f44e                	sd	s3,40(sp)
    80002734:	f052                	sd	s4,32(sp)
    80002736:	ec56                	sd	s5,24(sp)
    80002738:	e85a                	sd	s6,16(sp)
    8000273a:	e45e                	sd	s7,8(sp)
    8000273c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000273e:	00005517          	auipc	a0,0x5
    80002742:	93a50513          	addi	a0,a0,-1734 # 80007078 <etext+0x78>
    80002746:	d8bfd0ef          	jal	800004d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000274a:	00010497          	auipc	s1,0x10
    8000274e:	4de48493          	addi	s1,s1,1246 # 80012c28 <proc+0x158>
    80002752:	00016917          	auipc	s2,0x16
    80002756:	4d690913          	addi	s2,s2,1238 # 80018c28 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000275a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000275c:	00005997          	auipc	s3,0x5
    80002760:	b4498993          	addi	s3,s3,-1212 # 800072a0 <etext+0x2a0>
    printf("%d %s %s", p->pid, state, p->name);
    80002764:	00005a97          	auipc	s5,0x5
    80002768:	b44a8a93          	addi	s5,s5,-1212 # 800072a8 <etext+0x2a8>
    printf("\n");
    8000276c:	00005a17          	auipc	s4,0x5
    80002770:	90ca0a13          	addi	s4,s4,-1780 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002774:	00005b97          	auipc	s7,0x5
    80002778:	024b8b93          	addi	s7,s7,36 # 80007798 <states.0>
    8000277c:	a829                	j	80002796 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000277e:	ed86a583          	lw	a1,-296(a3)
    80002782:	8556                	mv	a0,s5
    80002784:	d4dfd0ef          	jal	800004d0 <printf>
    printf("\n");
    80002788:	8552                	mv	a0,s4
    8000278a:	d47fd0ef          	jal	800004d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000278e:	18048493          	addi	s1,s1,384
    80002792:	03248263          	beq	s1,s2,800027b6 <procdump+0x8e>
    if(p->state == UNUSED)
    80002796:	86a6                	mv	a3,s1
    80002798:	ec04a783          	lw	a5,-320(s1)
    8000279c:	dbed                	beqz	a5,8000278e <procdump+0x66>
      state = "???";
    8000279e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800027a0:	fcfb6fe3          	bltu	s6,a5,8000277e <procdump+0x56>
    800027a4:	02079713          	slli	a4,a5,0x20
    800027a8:	01d75793          	srli	a5,a4,0x1d
    800027ac:	97de                	add	a5,a5,s7
    800027ae:	6390                	ld	a2,0(a5)
    800027b0:	f679                	bnez	a2,8000277e <procdump+0x56>
      state = "???";
    800027b2:	864e                	mv	a2,s3
    800027b4:	b7e9                	j	8000277e <procdump+0x56>
  }
    800027b6:	60a6                	ld	ra,72(sp)
    800027b8:	6406                	ld	s0,64(sp)
    800027ba:	74e2                	ld	s1,56(sp)
    800027bc:	7942                	ld	s2,48(sp)
    800027be:	79a2                	ld	s3,40(sp)
    800027c0:	7a02                	ld	s4,32(sp)
    800027c2:	6ae2                	ld	s5,24(sp)
    800027c4:	6b42                	ld	s6,16(sp)
    800027c6:	6ba2                	ld	s7,8(sp)
    800027c8:	6161                	addi	sp,sp,80
    800027ca:	8082                	ret

00000000800027cc <swtch>:
    800027cc:	00153023          	sd	ra,0(a0)
    800027d0:	00253423          	sd	sp,8(a0)
    800027d4:	e900                	sd	s0,16(a0)
    800027d6:	ed04                	sd	s1,24(a0)
    800027d8:	03253023          	sd	s2,32(a0)
    800027dc:	03353423          	sd	s3,40(a0)
    800027e0:	03453823          	sd	s4,48(a0)
    800027e4:	03553c23          	sd	s5,56(a0)
    800027e8:	05653023          	sd	s6,64(a0)
    800027ec:	05753423          	sd	s7,72(a0)
    800027f0:	05853823          	sd	s8,80(a0)
    800027f4:	05953c23          	sd	s9,88(a0)
    800027f8:	07a53023          	sd	s10,96(a0)
    800027fc:	07b53423          	sd	s11,104(a0)
    80002800:	0005b083          	ld	ra,0(a1)
    80002804:	0085b103          	ld	sp,8(a1)
    80002808:	6980                	ld	s0,16(a1)
    8000280a:	6d84                	ld	s1,24(a1)
    8000280c:	0205b903          	ld	s2,32(a1)
    80002810:	0285b983          	ld	s3,40(a1)
    80002814:	0305ba03          	ld	s4,48(a1)
    80002818:	0385ba83          	ld	s5,56(a1)
    8000281c:	0405bb03          	ld	s6,64(a1)
    80002820:	0485bb83          	ld	s7,72(a1)
    80002824:	0505bc03          	ld	s8,80(a1)
    80002828:	0585bc83          	ld	s9,88(a1)
    8000282c:	0605bd03          	ld	s10,96(a1)
    80002830:	0685bd83          	ld	s11,104(a1)
    80002834:	8082                	ret

0000000080002836 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002836:	1141                	addi	sp,sp,-16
    80002838:	e406                	sd	ra,8(sp)
    8000283a:	e022                	sd	s0,0(sp)
    8000283c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000283e:	00005597          	auipc	a1,0x5
    80002842:	aaa58593          	addi	a1,a1,-1366 # 800072e8 <etext+0x2e8>
    80002846:	00016517          	auipc	a0,0x16
    8000284a:	28a50513          	addi	a0,a0,650 # 80018ad0 <tickslock>
    8000284e:	b34fe0ef          	jal	80000b82 <initlock>
}
    80002852:	60a2                	ld	ra,8(sp)
    80002854:	6402                	ld	s0,0(sp)
    80002856:	0141                	addi	sp,sp,16
    80002858:	8082                	ret

000000008000285a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000285a:	1141                	addi	sp,sp,-16
    8000285c:	e422                	sd	s0,8(sp)
    8000285e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002860:	00003797          	auipc	a5,0x3
    80002864:	f8078793          	addi	a5,a5,-128 # 800057e0 <kernelvec>
    80002868:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000286c:	6422                	ld	s0,8(sp)
    8000286e:	0141                	addi	sp,sp,16
    80002870:	8082                	ret

0000000080002872 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002872:	1141                	addi	sp,sp,-16
    80002874:	e406                	sd	ra,8(sp)
    80002876:	e022                	sd	s0,0(sp)
    80002878:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000287a:	898ff0ef          	jal	80001912 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000287e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002882:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002884:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002888:	00003697          	auipc	a3,0x3
    8000288c:	77868693          	addi	a3,a3,1912 # 80006000 <_trampoline>
    80002890:	00003717          	auipc	a4,0x3
    80002894:	77070713          	addi	a4,a4,1904 # 80006000 <_trampoline>
    80002898:	8f15                	sub	a4,a4,a3
    8000289a:	040007b7          	lui	a5,0x4000
    8000289e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800028a0:	07b2                	slli	a5,a5,0xc
    800028a2:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028a4:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800028a8:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800028aa:	18002673          	csrr	a2,satp
    800028ae:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800028b0:	6d30                	ld	a2,88(a0)
    800028b2:	6138                	ld	a4,64(a0)
    800028b4:	6585                	lui	a1,0x1
    800028b6:	972e                	add	a4,a4,a1
    800028b8:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800028ba:	6d38                	ld	a4,88(a0)
    800028bc:	00000617          	auipc	a2,0x0
    800028c0:	11a60613          	addi	a2,a2,282 # 800029d6 <usertrap>
    800028c4:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800028c6:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800028c8:	8612                	mv	a2,tp
    800028ca:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028cc:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800028d0:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800028d4:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028d8:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800028dc:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800028de:	6f18                	ld	a4,24(a4)
    800028e0:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800028e4:	6928                	ld	a0,80(a0)
    800028e6:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800028e8:	00003717          	auipc	a4,0x3
    800028ec:	7b470713          	addi	a4,a4,1972 # 8000609c <userret>
    800028f0:	8f15                	sub	a4,a4,a3
    800028f2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800028f4:	577d                	li	a4,-1
    800028f6:	177e                	slli	a4,a4,0x3f
    800028f8:	8d59                	or	a0,a0,a4
    800028fa:	9782                	jalr	a5
}
    800028fc:	60a2                	ld	ra,8(sp)
    800028fe:	6402                	ld	s0,0(sp)
    80002900:	0141                	addi	sp,sp,16
    80002902:	8082                	ret

0000000080002904 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002904:	1101                	addi	sp,sp,-32
    80002906:	ec06                	sd	ra,24(sp)
    80002908:	e822                	sd	s0,16(sp)
    8000290a:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000290c:	fdbfe0ef          	jal	800018e6 <cpuid>
    80002910:	cd11                	beqz	a0,8000292c <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002912:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002916:	000f4737          	lui	a4,0xf4
    8000291a:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000291e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002920:	14d79073          	csrw	stimecmp,a5
}
    80002924:	60e2                	ld	ra,24(sp)
    80002926:	6442                	ld	s0,16(sp)
    80002928:	6105                	addi	sp,sp,32
    8000292a:	8082                	ret
    8000292c:	e426                	sd	s1,8(sp)
    8000292e:	e04a                	sd	s2,0(sp)
    acquire(&tickslock);
    80002930:	00016917          	auipc	s2,0x16
    80002934:	1a090913          	addi	s2,s2,416 # 80018ad0 <tickslock>
    80002938:	854a                	mv	a0,s2
    8000293a:	ac8fe0ef          	jal	80000c02 <acquire>
    ticks++;
    8000293e:	00008497          	auipc	s1,0x8
    80002942:	c2a48493          	addi	s1,s1,-982 # 8000a568 <ticks>
    80002946:	409c                	lw	a5,0(s1)
    80002948:	2785                	addiw	a5,a5,1
    8000294a:	c09c                	sw	a5,0(s1)
    update_time();
    8000294c:	d2eff0ef          	jal	80001e7a <update_time>
    wakeup(&ticks);
    80002950:	8526                	mv	a0,s1
    80002952:	a1dff0ef          	jal	8000236e <wakeup>
    release(&tickslock);
    80002956:	854a                	mv	a0,s2
    80002958:	b42fe0ef          	jal	80000c9a <release>
    8000295c:	64a2                	ld	s1,8(sp)
    8000295e:	6902                	ld	s2,0(sp)
    80002960:	bf4d                	j	80002912 <clockintr+0xe>

0000000080002962 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002962:	1101                	addi	sp,sp,-32
    80002964:	ec06                	sd	ra,24(sp)
    80002966:	e822                	sd	s0,16(sp)
    80002968:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000296a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    8000296e:	57fd                	li	a5,-1
    80002970:	17fe                	slli	a5,a5,0x3f
    80002972:	07a5                	addi	a5,a5,9
    80002974:	00f70c63          	beq	a4,a5,8000298c <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002978:	57fd                	li	a5,-1
    8000297a:	17fe                	slli	a5,a5,0x3f
    8000297c:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000297e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002980:	04f70763          	beq	a4,a5,800029ce <devintr+0x6c>
  }
}
    80002984:	60e2                	ld	ra,24(sp)
    80002986:	6442                	ld	s0,16(sp)
    80002988:	6105                	addi	sp,sp,32
    8000298a:	8082                	ret
    8000298c:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    8000298e:	6ff020ef          	jal	8000588c <plic_claim>
    80002992:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002994:	47a9                	li	a5,10
    80002996:	00f50963          	beq	a0,a5,800029a8 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    8000299a:	4785                	li	a5,1
    8000299c:	00f50963          	beq	a0,a5,800029ae <devintr+0x4c>
    return 1;
    800029a0:	4505                	li	a0,1
    } else if(irq){
    800029a2:	e889                	bnez	s1,800029b4 <devintr+0x52>
    800029a4:	64a2                	ld	s1,8(sp)
    800029a6:	bff9                	j	80002984 <devintr+0x22>
      uartintr();
    800029a8:	86cfe0ef          	jal	80000a14 <uartintr>
    if(irq)
    800029ac:	a819                	j	800029c2 <devintr+0x60>
      virtio_disk_intr();
    800029ae:	3a4030ef          	jal	80005d52 <virtio_disk_intr>
    if(irq)
    800029b2:	a801                	j	800029c2 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800029b4:	85a6                	mv	a1,s1
    800029b6:	00005517          	auipc	a0,0x5
    800029ba:	93a50513          	addi	a0,a0,-1734 # 800072f0 <etext+0x2f0>
    800029be:	b13fd0ef          	jal	800004d0 <printf>
      plic_complete(irq);
    800029c2:	8526                	mv	a0,s1
    800029c4:	6e9020ef          	jal	800058ac <plic_complete>
    return 1;
    800029c8:	4505                	li	a0,1
    800029ca:	64a2                	ld	s1,8(sp)
    800029cc:	bf65                	j	80002984 <devintr+0x22>
    clockintr();
    800029ce:	f37ff0ef          	jal	80002904 <clockintr>
    return 2;
    800029d2:	4509                	li	a0,2
    800029d4:	bf45                	j	80002984 <devintr+0x22>

00000000800029d6 <usertrap>:
{
    800029d6:	1101                	addi	sp,sp,-32
    800029d8:	ec06                	sd	ra,24(sp)
    800029da:	e822                	sd	s0,16(sp)
    800029dc:	e426                	sd	s1,8(sp)
    800029de:	e04a                	sd	s2,0(sp)
    800029e0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029e2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800029e6:	1007f793          	andi	a5,a5,256
    800029ea:	ef85                	bnez	a5,80002a22 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800029ec:	00003797          	auipc	a5,0x3
    800029f0:	df478793          	addi	a5,a5,-524 # 800057e0 <kernelvec>
    800029f4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800029f8:	f1bfe0ef          	jal	80001912 <myproc>
    800029fc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800029fe:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a00:	14102773          	csrr	a4,sepc
    80002a04:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a06:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002a0a:	47a1                	li	a5,8
    80002a0c:	02f70163          	beq	a4,a5,80002a2e <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80002a10:	f53ff0ef          	jal	80002962 <devintr>
    80002a14:	892a                	mv	s2,a0
    80002a16:	c135                	beqz	a0,80002a7a <usertrap+0xa4>
  if(killed(p))
    80002a18:	8526                	mv	a0,s1
    80002a1a:	b57ff0ef          	jal	80002570 <killed>
    80002a1e:	cd1d                	beqz	a0,80002a5c <usertrap+0x86>
    80002a20:	a81d                	j	80002a56 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80002a22:	00005517          	auipc	a0,0x5
    80002a26:	8ee50513          	addi	a0,a0,-1810 # 80007310 <etext+0x310>
    80002a2a:	d79fd0ef          	jal	800007a2 <panic>
    if(killed(p))
    80002a2e:	b43ff0ef          	jal	80002570 <killed>
    80002a32:	e121                	bnez	a0,80002a72 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80002a34:	6cb8                	ld	a4,88(s1)
    80002a36:	6f1c                	ld	a5,24(a4)
    80002a38:	0791                	addi	a5,a5,4
    80002a3a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a3c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002a40:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a44:	10079073          	csrw	sstatus,a5
    syscall();
    80002a48:	24a000ef          	jal	80002c92 <syscall>
  if(killed(p))
    80002a4c:	8526                	mv	a0,s1
    80002a4e:	b23ff0ef          	jal	80002570 <killed>
    80002a52:	c901                	beqz	a0,80002a62 <usertrap+0x8c>
    80002a54:	4901                	li	s2,0
    exit(-1);
    80002a56:	557d                	li	a0,-1
    80002a58:	9d7ff0ef          	jal	8000242e <exit>
  if(which_dev == 2)
    80002a5c:	4789                	li	a5,2
    80002a5e:	04f90563          	beq	s2,a5,80002aa8 <usertrap+0xd2>
  usertrapret();
    80002a62:	e11ff0ef          	jal	80002872 <usertrapret>
}
    80002a66:	60e2                	ld	ra,24(sp)
    80002a68:	6442                	ld	s0,16(sp)
    80002a6a:	64a2                	ld	s1,8(sp)
    80002a6c:	6902                	ld	s2,0(sp)
    80002a6e:	6105                	addi	sp,sp,32
    80002a70:	8082                	ret
      exit(-1);
    80002a72:	557d                	li	a0,-1
    80002a74:	9bbff0ef          	jal	8000242e <exit>
    80002a78:	bf75                	j	80002a34 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a7a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002a7e:	5890                	lw	a2,48(s1)
    80002a80:	00005517          	auipc	a0,0x5
    80002a84:	8b050513          	addi	a0,a0,-1872 # 80007330 <etext+0x330>
    80002a88:	a49fd0ef          	jal	800004d0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a8c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a90:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002a94:	00005517          	auipc	a0,0x5
    80002a98:	8cc50513          	addi	a0,a0,-1844 # 80007360 <etext+0x360>
    80002a9c:	a35fd0ef          	jal	800004d0 <printf>
    setkilled(p);
    80002aa0:	8526                	mv	a0,s1
    80002aa2:	aabff0ef          	jal	8000254c <setkilled>
    80002aa6:	b75d                	j	80002a4c <usertrap+0x76>
    yield();
    80002aa8:	eeeff0ef          	jal	80002196 <yield>
    80002aac:	bf5d                	j	80002a62 <usertrap+0x8c>

0000000080002aae <kerneltrap>:
{
    80002aae:	7179                	addi	sp,sp,-48
    80002ab0:	f406                	sd	ra,40(sp)
    80002ab2:	f022                	sd	s0,32(sp)
    80002ab4:	ec26                	sd	s1,24(sp)
    80002ab6:	e84a                	sd	s2,16(sp)
    80002ab8:	e44e                	sd	s3,8(sp)
    80002aba:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002abc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ac0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ac4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002ac8:	1004f793          	andi	a5,s1,256
    80002acc:	c795                	beqz	a5,80002af8 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ace:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002ad2:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002ad4:	eb85                	bnez	a5,80002b04 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002ad6:	e8dff0ef          	jal	80002962 <devintr>
    80002ada:	c91d                	beqz	a0,80002b10 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002adc:	4789                	li	a5,2
    80002ade:	04f50a63          	beq	a0,a5,80002b32 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002ae2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002ae6:	10049073          	csrw	sstatus,s1
}
    80002aea:	70a2                	ld	ra,40(sp)
    80002aec:	7402                	ld	s0,32(sp)
    80002aee:	64e2                	ld	s1,24(sp)
    80002af0:	6942                	ld	s2,16(sp)
    80002af2:	69a2                	ld	s3,8(sp)
    80002af4:	6145                	addi	sp,sp,48
    80002af6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002af8:	00005517          	auipc	a0,0x5
    80002afc:	89050513          	addi	a0,a0,-1904 # 80007388 <etext+0x388>
    80002b00:	ca3fd0ef          	jal	800007a2 <panic>
    panic("kerneltrap: interrupts enabled");
    80002b04:	00005517          	auipc	a0,0x5
    80002b08:	8ac50513          	addi	a0,a0,-1876 # 800073b0 <etext+0x3b0>
    80002b0c:	c97fd0ef          	jal	800007a2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b10:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002b14:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002b18:	85ce                	mv	a1,s3
    80002b1a:	00005517          	auipc	a0,0x5
    80002b1e:	8b650513          	addi	a0,a0,-1866 # 800073d0 <etext+0x3d0>
    80002b22:	9affd0ef          	jal	800004d0 <printf>
    panic("kerneltrap");
    80002b26:	00005517          	auipc	a0,0x5
    80002b2a:	8d250513          	addi	a0,a0,-1838 # 800073f8 <etext+0x3f8>
    80002b2e:	c75fd0ef          	jal	800007a2 <panic>
  if(which_dev == 2 && myproc() != 0)
    80002b32:	de1fe0ef          	jal	80001912 <myproc>
    80002b36:	d555                	beqz	a0,80002ae2 <kerneltrap+0x34>
    yield();
    80002b38:	e5eff0ef          	jal	80002196 <yield>
    80002b3c:	b75d                	j	80002ae2 <kerneltrap+0x34>

0000000080002b3e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002b3e:	1101                	addi	sp,sp,-32
    80002b40:	ec06                	sd	ra,24(sp)
    80002b42:	e822                	sd	s0,16(sp)
    80002b44:	e426                	sd	s1,8(sp)
    80002b46:	1000                	addi	s0,sp,32
    80002b48:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002b4a:	dc9fe0ef          	jal	80001912 <myproc>
  switch (n) {
    80002b4e:	4795                	li	a5,5
    80002b50:	0497e163          	bltu	a5,s1,80002b92 <argraw+0x54>
    80002b54:	048a                	slli	s1,s1,0x2
    80002b56:	00005717          	auipc	a4,0x5
    80002b5a:	c7270713          	addi	a4,a4,-910 # 800077c8 <states.0+0x30>
    80002b5e:	94ba                	add	s1,s1,a4
    80002b60:	409c                	lw	a5,0(s1)
    80002b62:	97ba                	add	a5,a5,a4
    80002b64:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002b66:	6d3c                	ld	a5,88(a0)
    80002b68:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002b6a:	60e2                	ld	ra,24(sp)
    80002b6c:	6442                	ld	s0,16(sp)
    80002b6e:	64a2                	ld	s1,8(sp)
    80002b70:	6105                	addi	sp,sp,32
    80002b72:	8082                	ret
    return p->trapframe->a1;
    80002b74:	6d3c                	ld	a5,88(a0)
    80002b76:	7fa8                	ld	a0,120(a5)
    80002b78:	bfcd                	j	80002b6a <argraw+0x2c>
    return p->trapframe->a2;
    80002b7a:	6d3c                	ld	a5,88(a0)
    80002b7c:	63c8                	ld	a0,128(a5)
    80002b7e:	b7f5                	j	80002b6a <argraw+0x2c>
    return p->trapframe->a3;
    80002b80:	6d3c                	ld	a5,88(a0)
    80002b82:	67c8                	ld	a0,136(a5)
    80002b84:	b7dd                	j	80002b6a <argraw+0x2c>
    return p->trapframe->a4;
    80002b86:	6d3c                	ld	a5,88(a0)
    80002b88:	6bc8                	ld	a0,144(a5)
    80002b8a:	b7c5                	j	80002b6a <argraw+0x2c>
    return p->trapframe->a5;
    80002b8c:	6d3c                	ld	a5,88(a0)
    80002b8e:	6fc8                	ld	a0,152(a5)
    80002b90:	bfe9                	j	80002b6a <argraw+0x2c>
  panic("argraw");
    80002b92:	00005517          	auipc	a0,0x5
    80002b96:	87650513          	addi	a0,a0,-1930 # 80007408 <etext+0x408>
    80002b9a:	c09fd0ef          	jal	800007a2 <panic>

0000000080002b9e <fetchaddr>:
{
    80002b9e:	1101                	addi	sp,sp,-32
    80002ba0:	ec06                	sd	ra,24(sp)
    80002ba2:	e822                	sd	s0,16(sp)
    80002ba4:	e426                	sd	s1,8(sp)
    80002ba6:	e04a                	sd	s2,0(sp)
    80002ba8:	1000                	addi	s0,sp,32
    80002baa:	84aa                	mv	s1,a0
    80002bac:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002bae:	d65fe0ef          	jal	80001912 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002bb2:	653c                	ld	a5,72(a0)
    80002bb4:	02f4f663          	bgeu	s1,a5,80002be0 <fetchaddr+0x42>
    80002bb8:	00848713          	addi	a4,s1,8
    80002bbc:	02e7e463          	bltu	a5,a4,80002be4 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002bc0:	46a1                	li	a3,8
    80002bc2:	8626                	mv	a2,s1
    80002bc4:	85ca                	mv	a1,s2
    80002bc6:	6928                	ld	a0,80(a0)
    80002bc8:	a93fe0ef          	jal	8000165a <copyin>
    80002bcc:	00a03533          	snez	a0,a0
    80002bd0:	40a00533          	neg	a0,a0
}
    80002bd4:	60e2                	ld	ra,24(sp)
    80002bd6:	6442                	ld	s0,16(sp)
    80002bd8:	64a2                	ld	s1,8(sp)
    80002bda:	6902                	ld	s2,0(sp)
    80002bdc:	6105                	addi	sp,sp,32
    80002bde:	8082                	ret
    return -1;
    80002be0:	557d                	li	a0,-1
    80002be2:	bfcd                	j	80002bd4 <fetchaddr+0x36>
    80002be4:	557d                	li	a0,-1
    80002be6:	b7fd                	j	80002bd4 <fetchaddr+0x36>

0000000080002be8 <fetchstr>:
{
    80002be8:	7179                	addi	sp,sp,-48
    80002bea:	f406                	sd	ra,40(sp)
    80002bec:	f022                	sd	s0,32(sp)
    80002bee:	ec26                	sd	s1,24(sp)
    80002bf0:	e84a                	sd	s2,16(sp)
    80002bf2:	e44e                	sd	s3,8(sp)
    80002bf4:	1800                	addi	s0,sp,48
    80002bf6:	892a                	mv	s2,a0
    80002bf8:	84ae                	mv	s1,a1
    80002bfa:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002bfc:	d17fe0ef          	jal	80001912 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002c00:	86ce                	mv	a3,s3
    80002c02:	864a                	mv	a2,s2
    80002c04:	85a6                	mv	a1,s1
    80002c06:	6928                	ld	a0,80(a0)
    80002c08:	ad9fe0ef          	jal	800016e0 <copyinstr>
    80002c0c:	00054c63          	bltz	a0,80002c24 <fetchstr+0x3c>
  return strlen(buf);
    80002c10:	8526                	mv	a0,s1
    80002c12:	a34fe0ef          	jal	80000e46 <strlen>
}
    80002c16:	70a2                	ld	ra,40(sp)
    80002c18:	7402                	ld	s0,32(sp)
    80002c1a:	64e2                	ld	s1,24(sp)
    80002c1c:	6942                	ld	s2,16(sp)
    80002c1e:	69a2                	ld	s3,8(sp)
    80002c20:	6145                	addi	sp,sp,48
    80002c22:	8082                	ret
    return -1;
    80002c24:	557d                	li	a0,-1
    80002c26:	bfc5                	j	80002c16 <fetchstr+0x2e>

0000000080002c28 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002c28:	1101                	addi	sp,sp,-32
    80002c2a:	ec06                	sd	ra,24(sp)
    80002c2c:	e822                	sd	s0,16(sp)
    80002c2e:	e426                	sd	s1,8(sp)
    80002c30:	1000                	addi	s0,sp,32
    80002c32:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c34:	f0bff0ef          	jal	80002b3e <argraw>
    80002c38:	c088                	sw	a0,0(s1)
}
    80002c3a:	60e2                	ld	ra,24(sp)
    80002c3c:	6442                	ld	s0,16(sp)
    80002c3e:	64a2                	ld	s1,8(sp)
    80002c40:	6105                	addi	sp,sp,32
    80002c42:	8082                	ret

0000000080002c44 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002c44:	1101                	addi	sp,sp,-32
    80002c46:	ec06                	sd	ra,24(sp)
    80002c48:	e822                	sd	s0,16(sp)
    80002c4a:	e426                	sd	s1,8(sp)
    80002c4c:	1000                	addi	s0,sp,32
    80002c4e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c50:	eefff0ef          	jal	80002b3e <argraw>
    80002c54:	e088                	sd	a0,0(s1)
   return 0;
}
    80002c56:	4501                	li	a0,0
    80002c58:	60e2                	ld	ra,24(sp)
    80002c5a:	6442                	ld	s0,16(sp)
    80002c5c:	64a2                	ld	s1,8(sp)
    80002c5e:	6105                	addi	sp,sp,32
    80002c60:	8082                	ret

0000000080002c62 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002c62:	7179                	addi	sp,sp,-48
    80002c64:	f406                	sd	ra,40(sp)
    80002c66:	f022                	sd	s0,32(sp)
    80002c68:	ec26                	sd	s1,24(sp)
    80002c6a:	e84a                	sd	s2,16(sp)
    80002c6c:	1800                	addi	s0,sp,48
    80002c6e:	84ae                	mv	s1,a1
    80002c70:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002c72:	fd840593          	addi	a1,s0,-40
    80002c76:	fcfff0ef          	jal	80002c44 <argaddr>
  return fetchstr(addr, buf, max);
    80002c7a:	864a                	mv	a2,s2
    80002c7c:	85a6                	mv	a1,s1
    80002c7e:	fd843503          	ld	a0,-40(s0)
    80002c82:	f67ff0ef          	jal	80002be8 <fetchstr>
}
    80002c86:	70a2                	ld	ra,40(sp)
    80002c88:	7402                	ld	s0,32(sp)
    80002c8a:	64e2                	ld	s1,24(sp)
    80002c8c:	6942                	ld	s2,16(sp)
    80002c8e:	6145                	addi	sp,sp,48
    80002c90:	8082                	ret

0000000080002c92 <syscall>:

};

void
syscall(void)
{
    80002c92:	1101                	addi	sp,sp,-32
    80002c94:	ec06                	sd	ra,24(sp)
    80002c96:	e822                	sd	s0,16(sp)
    80002c98:	e426                	sd	s1,8(sp)
    80002c9a:	e04a                	sd	s2,0(sp)
    80002c9c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002c9e:	c75fe0ef          	jal	80001912 <myproc>
    80002ca2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002ca4:	05853903          	ld	s2,88(a0)
    80002ca8:	0a893783          	ld	a5,168(s2)
    80002cac:	0007869b          	sext.w	a3,a5
  syscall_count++; 
    80002cb0:	00008617          	auipc	a2,0x8
    80002cb4:	8c060613          	addi	a2,a2,-1856 # 8000a570 <syscall_count>
    80002cb8:	6218                	ld	a4,0(a2)
    80002cba:	0705                	addi	a4,a4,1
    80002cbc:	e218                	sd	a4,0(a2)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002cbe:	37fd                	addiw	a5,a5,-1
    80002cc0:	4775                	li	a4,29
    80002cc2:	00f76f63          	bltu	a4,a5,80002ce0 <syscall+0x4e>
    80002cc6:	00369713          	slli	a4,a3,0x3
    80002cca:	00005797          	auipc	a5,0x5
    80002cce:	b1678793          	addi	a5,a5,-1258 # 800077e0 <syscalls>
    80002cd2:	97ba                	add	a5,a5,a4
    80002cd4:	639c                	ld	a5,0(a5)
    80002cd6:	c789                	beqz	a5,80002ce0 <syscall+0x4e>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002cd8:	9782                	jalr	a5
    80002cda:	06a93823          	sd	a0,112(s2)
    80002cde:	a829                	j	80002cf8 <syscall+0x66>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002ce0:	15848613          	addi	a2,s1,344
    80002ce4:	588c                	lw	a1,48(s1)
    80002ce6:	00004517          	auipc	a0,0x4
    80002cea:	72a50513          	addi	a0,a0,1834 # 80007410 <etext+0x410>
    80002cee:	fe2fd0ef          	jal	800004d0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002cf2:	6cbc                	ld	a5,88(s1)
    80002cf4:	577d                	li	a4,-1
    80002cf6:	fbb8                	sd	a4,112(a5)
  }
    80002cf8:	60e2                	ld	ra,24(sp)
    80002cfa:	6442                	ld	s0,16(sp)
    80002cfc:	64a2                	ld	s1,8(sp)
    80002cfe:	6902                	ld	s2,0(sp)
    80002d00:	6105                	addi	sp,sp,32
    80002d02:	8082                	ret

0000000080002d04 <sys_exit>:
#include "proc.h"
//#include "date.h"   

uint64
sys_exit(void)
{
    80002d04:	1101                	addi	sp,sp,-32
    80002d06:	ec06                	sd	ra,24(sp)
    80002d08:	e822                	sd	s0,16(sp)
    80002d0a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002d0c:	fec40593          	addi	a1,s0,-20
    80002d10:	4501                	li	a0,0
    80002d12:	f17ff0ef          	jal	80002c28 <argint>
  exit(n);
    80002d16:	fec42503          	lw	a0,-20(s0)
    80002d1a:	f14ff0ef          	jal	8000242e <exit>
  return 0;  // not reached
}
    80002d1e:	4501                	li	a0,0
    80002d20:	60e2                	ld	ra,24(sp)
    80002d22:	6442                	ld	s0,16(sp)
    80002d24:	6105                	addi	sp,sp,32
    80002d26:	8082                	ret

0000000080002d28 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002d28:	1141                	addi	sp,sp,-16
    80002d2a:	e406                	sd	ra,8(sp)
    80002d2c:	e022                	sd	s0,0(sp)
    80002d2e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002d30:	be3fe0ef          	jal	80001912 <myproc>
}
    80002d34:	5908                	lw	a0,48(a0)
    80002d36:	60a2                	ld	ra,8(sp)
    80002d38:	6402                	ld	s0,0(sp)
    80002d3a:	0141                	addi	sp,sp,16
    80002d3c:	8082                	ret

0000000080002d3e <sys_fork>:

uint64
sys_fork(void)
{
    80002d3e:	1141                	addi	sp,sp,-16
    80002d40:	e406                	sd	ra,8(sp)
    80002d42:	e022                	sd	s0,0(sp)
    80002d44:	0800                	addi	s0,sp,16
  return fork();
    80002d46:	826ff0ef          	jal	80001d6c <fork>
}
    80002d4a:	60a2                	ld	ra,8(sp)
    80002d4c:	6402                	ld	s0,0(sp)
    80002d4e:	0141                	addi	sp,sp,16
    80002d50:	8082                	ret

0000000080002d52 <sys_wait>:

uint64
sys_wait(void)
{
    80002d52:	1101                	addi	sp,sp,-32
    80002d54:	ec06                	sd	ra,24(sp)
    80002d56:	e822                	sd	s0,16(sp)
    80002d58:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002d5a:	fe840593          	addi	a1,s0,-24
    80002d5e:	4501                	li	a0,0
    80002d60:	ee5ff0ef          	jal	80002c44 <argaddr>
  return wait(p);
    80002d64:	fe843503          	ld	a0,-24(s0)
    80002d68:	833ff0ef          	jal	8000259a <wait>
}
    80002d6c:	60e2                	ld	ra,24(sp)
    80002d6e:	6442                	ld	s0,16(sp)
    80002d70:	6105                	addi	sp,sp,32
    80002d72:	8082                	ret

0000000080002d74 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002d74:	7179                	addi	sp,sp,-48
    80002d76:	f406                	sd	ra,40(sp)
    80002d78:	f022                	sd	s0,32(sp)
    80002d7a:	ec26                	sd	s1,24(sp)
    80002d7c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002d7e:	fdc40593          	addi	a1,s0,-36
    80002d82:	4501                	li	a0,0
    80002d84:	ea5ff0ef          	jal	80002c28 <argint>
  addr = myproc()->sz;
    80002d88:	b8bfe0ef          	jal	80001912 <myproc>
    80002d8c:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002d8e:	fdc42503          	lw	a0,-36(s0)
    80002d92:	f8bfe0ef          	jal	80001d1c <growproc>
    80002d96:	00054863          	bltz	a0,80002da6 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002d9a:	8526                	mv	a0,s1
    80002d9c:	70a2                	ld	ra,40(sp)
    80002d9e:	7402                	ld	s0,32(sp)
    80002da0:	64e2                	ld	s1,24(sp)
    80002da2:	6145                	addi	sp,sp,48
    80002da4:	8082                	ret
    return -1;
    80002da6:	54fd                	li	s1,-1
    80002da8:	bfcd                	j	80002d9a <sys_sbrk+0x26>

0000000080002daa <sys_sleep>:

uint64
sys_sleep(void)
{
    80002daa:	7139                	addi	sp,sp,-64
    80002dac:	fc06                	sd	ra,56(sp)
    80002dae:	f822                	sd	s0,48(sp)
    80002db0:	f04a                	sd	s2,32(sp)
    80002db2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002db4:	fcc40593          	addi	a1,s0,-52
    80002db8:	4501                	li	a0,0
    80002dba:	e6fff0ef          	jal	80002c28 <argint>
  if(n < 0)
    80002dbe:	fcc42783          	lw	a5,-52(s0)
    80002dc2:	0607c763          	bltz	a5,80002e30 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002dc6:	00016517          	auipc	a0,0x16
    80002dca:	d0a50513          	addi	a0,a0,-758 # 80018ad0 <tickslock>
    80002dce:	e35fd0ef          	jal	80000c02 <acquire>
  ticks0 = ticks;
    80002dd2:	00007917          	auipc	s2,0x7
    80002dd6:	79692903          	lw	s2,1942(s2) # 8000a568 <ticks>
  while(ticks - ticks0 < n){
    80002dda:	fcc42783          	lw	a5,-52(s0)
    80002dde:	cf8d                	beqz	a5,80002e18 <sys_sleep+0x6e>
    80002de0:	f426                	sd	s1,40(sp)
    80002de2:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002de4:	00016997          	auipc	s3,0x16
    80002de8:	cec98993          	addi	s3,s3,-788 # 80018ad0 <tickslock>
    80002dec:	00007497          	auipc	s1,0x7
    80002df0:	77c48493          	addi	s1,s1,1916 # 8000a568 <ticks>
    if(killed(myproc())){
    80002df4:	b1ffe0ef          	jal	80001912 <myproc>
    80002df8:	f78ff0ef          	jal	80002570 <killed>
    80002dfc:	ed0d                	bnez	a0,80002e36 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002dfe:	85ce                	mv	a1,s3
    80002e00:	8526                	mv	a0,s1
    80002e02:	bc0ff0ef          	jal	800021c2 <sleep>
  while(ticks - ticks0 < n){
    80002e06:	409c                	lw	a5,0(s1)
    80002e08:	412787bb          	subw	a5,a5,s2
    80002e0c:	fcc42703          	lw	a4,-52(s0)
    80002e10:	fee7e2e3          	bltu	a5,a4,80002df4 <sys_sleep+0x4a>
    80002e14:	74a2                	ld	s1,40(sp)
    80002e16:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002e18:	00016517          	auipc	a0,0x16
    80002e1c:	cb850513          	addi	a0,a0,-840 # 80018ad0 <tickslock>
    80002e20:	e7bfd0ef          	jal	80000c9a <release>
  return 0;
    80002e24:	4501                	li	a0,0
}
    80002e26:	70e2                	ld	ra,56(sp)
    80002e28:	7442                	ld	s0,48(sp)
    80002e2a:	7902                	ld	s2,32(sp)
    80002e2c:	6121                	addi	sp,sp,64
    80002e2e:	8082                	ret
    n = 0;
    80002e30:	fc042623          	sw	zero,-52(s0)
    80002e34:	bf49                	j	80002dc6 <sys_sleep+0x1c>
      release(&tickslock);
    80002e36:	00016517          	auipc	a0,0x16
    80002e3a:	c9a50513          	addi	a0,a0,-870 # 80018ad0 <tickslock>
    80002e3e:	e5dfd0ef          	jal	80000c9a <release>
      return -1;
    80002e42:	557d                	li	a0,-1
    80002e44:	74a2                	ld	s1,40(sp)
    80002e46:	69e2                	ld	s3,24(sp)
    80002e48:	bff9                	j	80002e26 <sys_sleep+0x7c>

0000000080002e4a <sys_kill>:

uint64
sys_kill(void)
{
    80002e4a:	1101                	addi	sp,sp,-32
    80002e4c:	ec06                	sd	ra,24(sp)
    80002e4e:	e822                	sd	s0,16(sp)
    80002e50:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002e52:	fec40593          	addi	a1,s0,-20
    80002e56:	4501                	li	a0,0
    80002e58:	dd1ff0ef          	jal	80002c28 <argint>
  return kill(pid);
    80002e5c:	fec42503          	lw	a0,-20(s0)
    80002e60:	e86ff0ef          	jal	800024e6 <kill>
}
    80002e64:	60e2                	ld	ra,24(sp)
    80002e66:	6442                	ld	s0,16(sp)
    80002e68:	6105                	addi	sp,sp,32
    80002e6a:	8082                	ret

0000000080002e6c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002e6c:	1101                	addi	sp,sp,-32
    80002e6e:	ec06                	sd	ra,24(sp)
    80002e70:	e822                	sd	s0,16(sp)
    80002e72:	e426                	sd	s1,8(sp)
    80002e74:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002e76:	00016517          	auipc	a0,0x16
    80002e7a:	c5a50513          	addi	a0,a0,-934 # 80018ad0 <tickslock>
    80002e7e:	d85fd0ef          	jal	80000c02 <acquire>
  xticks = ticks;
    80002e82:	00007497          	auipc	s1,0x7
    80002e86:	6e64a483          	lw	s1,1766(s1) # 8000a568 <ticks>
  release(&tickslock);
    80002e8a:	00016517          	auipc	a0,0x16
    80002e8e:	c4650513          	addi	a0,a0,-954 # 80018ad0 <tickslock>
    80002e92:	e09fd0ef          	jal	80000c9a <release>
  return xticks;
}
    80002e96:	02049513          	slli	a0,s1,0x20
    80002e9a:	9101                	srli	a0,a0,0x20
    80002e9c:	60e2                	ld	ra,24(sp)
    80002e9e:	6442                	ld	s0,16(sp)
    80002ea0:	64a2                	ld	s1,8(sp)
    80002ea2:	6105                	addi	sp,sp,32
    80002ea4:	8082                	ret

0000000080002ea6 <sys_countsyscall>:
uint64 syscall_count = 0;
uint64
sys_countsyscall(void)
{
    80002ea6:	1141                	addi	sp,sp,-16
    80002ea8:	e422                	sd	s0,8(sp)
    80002eaa:	0800                	addi	s0,sp,16
  return syscall_count;
}
    80002eac:	00007517          	auipc	a0,0x7
    80002eb0:	6c453503          	ld	a0,1732(a0) # 8000a570 <syscall_count>
    80002eb4:	6422                	ld	s0,8(sp)
    80002eb6:	0141                	addi	sp,sp,16
    80002eb8:	8082                	ret

0000000080002eba <sys_getppid>:
uint64
sys_getppid(void)
{
    80002eba:	1141                	addi	sp,sp,-16
    80002ebc:	e406                	sd	ra,8(sp)
    80002ebe:	e022                	sd	s0,0(sp)
    80002ec0:	0800                	addi	s0,sp,16
  return myproc()->parent->pid;
    80002ec2:	a51fe0ef          	jal	80001912 <myproc>
    80002ec6:	7d1c                	ld	a5,56(a0)
}
    80002ec8:	5b88                	lw	a0,48(a5)
    80002eca:	60a2                	ld	ra,8(sp)
    80002ecc:	6402                	ld	s0,0(sp)
    80002ece:	0141                	addi	sp,sp,16
    80002ed0:	8082                	ret

0000000080002ed2 <sys_shutdown>:
uint64
sys_shutdown(void)
{
    80002ed2:	1141                	addi	sp,sp,-16
    80002ed4:	e406                	sd	ra,8(sp)
    80002ed6:	e022                	sd	s0,0(sp)
    80002ed8:	0800                	addi	s0,sp,16
  printf("shutting down \n");
    80002eda:	00004517          	auipc	a0,0x4
    80002ede:	55650513          	addi	a0,a0,1366 # 80007430 <etext+0x430>
    80002ee2:	deefd0ef          	jal	800004d0 <printf>
  volatile uint32 *shutdown_reg=(uint32 *)0x100000;
  *shutdown_reg=0x5555;
    80002ee6:	6795                	lui	a5,0x5
    80002ee8:	55578793          	addi	a5,a5,1365 # 5555 <_entry-0x7fffaaab>
    80002eec:	00100737          	lui	a4,0x100
    80002ef0:	c31c                	sw	a5,0(a4)
  return 0;
}
    80002ef2:	4501                	li	a0,0
    80002ef4:	60a2                	ld	ra,8(sp)
    80002ef6:	6402                	ld	s0,0(sp)
    80002ef8:	0141                	addi	sp,sp,16
    80002efa:	8082                	ret

0000000080002efc <sys_rand>:
// Simple kernel PRNG using LCG
static unsigned int lcg_state = 1;

uint64
sys_rand(void)
{
    80002efc:	1141                	addi	sp,sp,-16
    80002efe:	e422                	sd	s0,8(sp)
    80002f00:	0800                	addi	s0,sp,16
  // Seed only once using ticks (global variable provided by xv6)
  extern uint ticks;
  if (lcg_state == 1)
    80002f02:	00007717          	auipc	a4,0x7
    80002f06:	5c672703          	lw	a4,1478(a4) # 8000a4c8 <lcg_state>
    80002f0a:	4785                	li	a5,1
    80002f0c:	02f70763          	beq	a4,a5,80002f3a <sys_rand+0x3e>
    lcg_state = ticks + 1;  // avoid 0 seed

  // LCG formula
  lcg_state = (1103515245 * lcg_state + 12345) & 0x7fffffff;
    80002f10:	00007717          	auipc	a4,0x7
    80002f14:	5b870713          	addi	a4,a4,1464 # 8000a4c8 <lcg_state>
    80002f18:	4314                	lw	a3,0(a4)
    80002f1a:	41c657b7          	lui	a5,0x41c65
    80002f1e:	e6d7879b          	addiw	a5,a5,-403 # 41c64e6d <_entry-0x3e39b193>
    80002f22:	02d7853b          	mulw	a0,a5,a3
    80002f26:	678d                	lui	a5,0x3
    80002f28:	0397879b          	addiw	a5,a5,57 # 3039 <_entry-0x7fffcfc7>
    80002f2c:	9d3d                	addw	a0,a0,a5
    80002f2e:	1506                	slli	a0,a0,0x21
    80002f30:	9105                	srli	a0,a0,0x21
    80002f32:	c308                	sw	a0,0(a4)

  return lcg_state;
}
    80002f34:	6422                	ld	s0,8(sp)
    80002f36:	0141                	addi	sp,sp,16
    80002f38:	8082                	ret
    lcg_state = ticks + 1;  // avoid 0 seed
    80002f3a:	00007797          	auipc	a5,0x7
    80002f3e:	62e7a783          	lw	a5,1582(a5) # 8000a568 <ticks>
    80002f42:	2785                	addiw	a5,a5,1
    80002f44:	00007717          	auipc	a4,0x7
    80002f48:	58f72223          	sw	a5,1412(a4) # 8000a4c8 <lcg_state>
    80002f4c:	b7d1                	j	80002f10 <sys_rand+0x14>

0000000080002f4e <sys_getptable>:

uint64
sys_getptable(void)
{
    80002f4e:	1101                	addi	sp,sp,-32
    80002f50:	ec06                	sd	ra,24(sp)
    80002f52:	e822                	sd	s0,16(sp)
    80002f54:	1000                	addi	s0,sp,32
  int nproc;
  uint64 buffer;
  
  argint(0, &nproc);
    80002f56:	fec40593          	addi	a1,s0,-20
    80002f5a:	4501                	li	a0,0
    80002f5c:	ccdff0ef          	jal	80002c28 <argint>
  argaddr(1, &buffer);
    80002f60:	fe040593          	addi	a1,s0,-32
    80002f64:	4505                	li	a0,1
    80002f66:	cdfff0ef          	jal	80002c44 <argaddr>
  
  return getptable(nproc, buffer);
    80002f6a:	fe043583          	ld	a1,-32(s0)
    80002f6e:	fec42503          	lw	a0,-20(s0)
    80002f72:	9d1fe0ef          	jal	80001942 <getptable>
}
    80002f76:	60e2                	ld	ra,24(sp)
    80002f78:	6442                	ld	s0,16(sp)
    80002f7a:	6105                	addi	sp,sp,32
    80002f7c:	8082                	ret

0000000080002f7e <sys_set_sched>:
// Import the global variable
extern int sched_mode; 

uint64
sys_set_sched(void)
{
    80002f7e:	1101                	addi	sp,sp,-32
    80002f80:	ec06                	sd	ra,24(sp)
    80002f82:	e822                	sd	s0,16(sp)
    80002f84:	1000                	addi	s0,sp,32
  int mode;
  // Read the 1st argument passed to the syscall
 argint(0, &mode);
    80002f86:	fec40593          	addi	a1,s0,-20
    80002f8a:	4501                	li	a0,0
    80002f8c:	c9dff0ef          	jal	80002c28 <argint>
  
  // Validations
  if(mode != 0 && mode != 1 && mode !=2) // 0=RR, 1=FCFS, 2=prio
    80002f90:	fec42783          	lw	a5,-20(s0)
    80002f94:	0007869b          	sext.w	a3,a5
    80002f98:	4709                	li	a4,2
      return -1;
    80002f9a:	557d                	li	a0,-1
  if(mode != 0 && mode != 1 && mode !=2) // 0=RR, 1=FCFS, 2=prio
    80002f9c:	00d76763          	bltu	a4,a3,80002faa <sys_set_sched+0x2c>

  sched_mode = mode; // UPDATE THE GLOBAL VARIABLE
    80002fa0:	00007717          	auipc	a4,0x7
    80002fa4:	5af72c23          	sw	a5,1464(a4) # 8000a558 <sched_mode>
  return 0; // Success
    80002fa8:	4501                	li	a0,0
}
    80002faa:	60e2                	ld	ra,24(sp)
    80002fac:	6442                	ld	s0,16(sp)
    80002fae:	6105                	addi	sp,sp,32
    80002fb0:	8082                	ret

0000000080002fb2 <sys_wait_sched>:
uint64
sys_wait_sched(void)
{
    80002fb2:	7179                	addi	sp,sp,-48
    80002fb4:	f406                	sd	ra,40(sp)
    80002fb6:	f022                	sd	s0,32(sp)
    80002fb8:	1800                	addi	s0,sp,48
  uint64 p_status; // Pointer for status
  uint64 p_tt;     // Pointer for Turnaround Time
  uint64 p_wt;     // Pointer for Waiting Time

  // Retrieve the 3 addresses passed by the user
  if(argaddr(0, &p_status) < 0) return -1;
    80002fba:	fe840593          	addi	a1,s0,-24
    80002fbe:	4501                	li	a0,0
    80002fc0:	c85ff0ef          	jal	80002c44 <argaddr>
    80002fc4:	57fd                	li	a5,-1
    80002fc6:	02054b63          	bltz	a0,80002ffc <sys_wait_sched+0x4a>
  if(argaddr(1, &p_tt) < 0)     return -1;
    80002fca:	fe040593          	addi	a1,s0,-32
    80002fce:	4505                	li	a0,1
    80002fd0:	c75ff0ef          	jal	80002c44 <argaddr>
    80002fd4:	57fd                	li	a5,-1
    80002fd6:	02054363          	bltz	a0,80002ffc <sys_wait_sched+0x4a>
  if(argaddr(2, &p_wt) < 0)     return -1;
    80002fda:	fd840593          	addi	a1,s0,-40
    80002fde:	4509                	li	a0,2
    80002fe0:	c65ff0ef          	jal	80002c44 <argaddr>
    80002fe4:	57fd                	li	a5,-1
    80002fe6:	00054b63          	bltz	a0,80002ffc <sys_wait_sched+0x4a>

  return wait_sched(p_status, p_tt, p_wt);
    80002fea:	fd843603          	ld	a2,-40(s0)
    80002fee:	fe043583          	ld	a1,-32(s0)
    80002ff2:	fe843503          	ld	a0,-24(s0)
    80002ff6:	a18ff0ef          	jal	8000220e <wait_sched>
    80002ffa:	87aa                	mv	a5,a0
}
    80002ffc:	853e                	mv	a0,a5
    80002ffe:	70a2                	ld	ra,40(sp)
    80003000:	7402                	ld	s0,32(sp)
    80003002:	6145                	addi	sp,sp,48
    80003004:	8082                	ret

0000000080003006 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003006:	7179                	addi	sp,sp,-48
    80003008:	f406                	sd	ra,40(sp)
    8000300a:	f022                	sd	s0,32(sp)
    8000300c:	ec26                	sd	s1,24(sp)
    8000300e:	e84a                	sd	s2,16(sp)
    80003010:	e44e                	sd	s3,8(sp)
    80003012:	e052                	sd	s4,0(sp)
    80003014:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003016:	00004597          	auipc	a1,0x4
    8000301a:	42a58593          	addi	a1,a1,1066 # 80007440 <etext+0x440>
    8000301e:	00016517          	auipc	a0,0x16
    80003022:	aca50513          	addi	a0,a0,-1334 # 80018ae8 <bcache>
    80003026:	b5dfd0ef          	jal	80000b82 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000302a:	0001e797          	auipc	a5,0x1e
    8000302e:	abe78793          	addi	a5,a5,-1346 # 80020ae8 <bcache+0x8000>
    80003032:	0001e717          	auipc	a4,0x1e
    80003036:	d1e70713          	addi	a4,a4,-738 # 80020d50 <bcache+0x8268>
    8000303a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000303e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003042:	00016497          	auipc	s1,0x16
    80003046:	abe48493          	addi	s1,s1,-1346 # 80018b00 <bcache+0x18>
    b->next = bcache.head.next;
    8000304a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000304c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000304e:	00004a17          	auipc	s4,0x4
    80003052:	3faa0a13          	addi	s4,s4,1018 # 80007448 <etext+0x448>
    b->next = bcache.head.next;
    80003056:	2b893783          	ld	a5,696(s2)
    8000305a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000305c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003060:	85d2                	mv	a1,s4
    80003062:	01048513          	addi	a0,s1,16
    80003066:	248010ef          	jal	800042ae <initsleeplock>
    bcache.head.next->prev = b;
    8000306a:	2b893783          	ld	a5,696(s2)
    8000306e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003070:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003074:	45848493          	addi	s1,s1,1112
    80003078:	fd349fe3          	bne	s1,s3,80003056 <binit+0x50>
  }
}
    8000307c:	70a2                	ld	ra,40(sp)
    8000307e:	7402                	ld	s0,32(sp)
    80003080:	64e2                	ld	s1,24(sp)
    80003082:	6942                	ld	s2,16(sp)
    80003084:	69a2                	ld	s3,8(sp)
    80003086:	6a02                	ld	s4,0(sp)
    80003088:	6145                	addi	sp,sp,48
    8000308a:	8082                	ret

000000008000308c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000308c:	7179                	addi	sp,sp,-48
    8000308e:	f406                	sd	ra,40(sp)
    80003090:	f022                	sd	s0,32(sp)
    80003092:	ec26                	sd	s1,24(sp)
    80003094:	e84a                	sd	s2,16(sp)
    80003096:	e44e                	sd	s3,8(sp)
    80003098:	1800                	addi	s0,sp,48
    8000309a:	892a                	mv	s2,a0
    8000309c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000309e:	00016517          	auipc	a0,0x16
    800030a2:	a4a50513          	addi	a0,a0,-1462 # 80018ae8 <bcache>
    800030a6:	b5dfd0ef          	jal	80000c02 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800030aa:	0001e497          	auipc	s1,0x1e
    800030ae:	cf64b483          	ld	s1,-778(s1) # 80020da0 <bcache+0x82b8>
    800030b2:	0001e797          	auipc	a5,0x1e
    800030b6:	c9e78793          	addi	a5,a5,-866 # 80020d50 <bcache+0x8268>
    800030ba:	02f48b63          	beq	s1,a5,800030f0 <bread+0x64>
    800030be:	873e                	mv	a4,a5
    800030c0:	a021                	j	800030c8 <bread+0x3c>
    800030c2:	68a4                	ld	s1,80(s1)
    800030c4:	02e48663          	beq	s1,a4,800030f0 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800030c8:	449c                	lw	a5,8(s1)
    800030ca:	ff279ce3          	bne	a5,s2,800030c2 <bread+0x36>
    800030ce:	44dc                	lw	a5,12(s1)
    800030d0:	ff3799e3          	bne	a5,s3,800030c2 <bread+0x36>
      b->refcnt++;
    800030d4:	40bc                	lw	a5,64(s1)
    800030d6:	2785                	addiw	a5,a5,1
    800030d8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800030da:	00016517          	auipc	a0,0x16
    800030de:	a0e50513          	addi	a0,a0,-1522 # 80018ae8 <bcache>
    800030e2:	bb9fd0ef          	jal	80000c9a <release>
      acquiresleep(&b->lock);
    800030e6:	01048513          	addi	a0,s1,16
    800030ea:	1fa010ef          	jal	800042e4 <acquiresleep>
      return b;
    800030ee:	a889                	j	80003140 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800030f0:	0001e497          	auipc	s1,0x1e
    800030f4:	ca84b483          	ld	s1,-856(s1) # 80020d98 <bcache+0x82b0>
    800030f8:	0001e797          	auipc	a5,0x1e
    800030fc:	c5878793          	addi	a5,a5,-936 # 80020d50 <bcache+0x8268>
    80003100:	00f48863          	beq	s1,a5,80003110 <bread+0x84>
    80003104:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003106:	40bc                	lw	a5,64(s1)
    80003108:	cb91                	beqz	a5,8000311c <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000310a:	64a4                	ld	s1,72(s1)
    8000310c:	fee49de3          	bne	s1,a4,80003106 <bread+0x7a>
  panic("bget: no buffers");
    80003110:	00004517          	auipc	a0,0x4
    80003114:	34050513          	addi	a0,a0,832 # 80007450 <etext+0x450>
    80003118:	e8afd0ef          	jal	800007a2 <panic>
      b->dev = dev;
    8000311c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003120:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003124:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003128:	4785                	li	a5,1
    8000312a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000312c:	00016517          	auipc	a0,0x16
    80003130:	9bc50513          	addi	a0,a0,-1604 # 80018ae8 <bcache>
    80003134:	b67fd0ef          	jal	80000c9a <release>
      acquiresleep(&b->lock);
    80003138:	01048513          	addi	a0,s1,16
    8000313c:	1a8010ef          	jal	800042e4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003140:	409c                	lw	a5,0(s1)
    80003142:	cb89                	beqz	a5,80003154 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003144:	8526                	mv	a0,s1
    80003146:	70a2                	ld	ra,40(sp)
    80003148:	7402                	ld	s0,32(sp)
    8000314a:	64e2                	ld	s1,24(sp)
    8000314c:	6942                	ld	s2,16(sp)
    8000314e:	69a2                	ld	s3,8(sp)
    80003150:	6145                	addi	sp,sp,48
    80003152:	8082                	ret
    virtio_disk_rw(b, 0);
    80003154:	4581                	li	a1,0
    80003156:	8526                	mv	a0,s1
    80003158:	1e9020ef          	jal	80005b40 <virtio_disk_rw>
    b->valid = 1;
    8000315c:	4785                	li	a5,1
    8000315e:	c09c                	sw	a5,0(s1)
  return b;
    80003160:	b7d5                	j	80003144 <bread+0xb8>

0000000080003162 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003162:	1101                	addi	sp,sp,-32
    80003164:	ec06                	sd	ra,24(sp)
    80003166:	e822                	sd	s0,16(sp)
    80003168:	e426                	sd	s1,8(sp)
    8000316a:	1000                	addi	s0,sp,32
    8000316c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000316e:	0541                	addi	a0,a0,16
    80003170:	1f2010ef          	jal	80004362 <holdingsleep>
    80003174:	c911                	beqz	a0,80003188 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003176:	4585                	li	a1,1
    80003178:	8526                	mv	a0,s1
    8000317a:	1c7020ef          	jal	80005b40 <virtio_disk_rw>
}
    8000317e:	60e2                	ld	ra,24(sp)
    80003180:	6442                	ld	s0,16(sp)
    80003182:	64a2                	ld	s1,8(sp)
    80003184:	6105                	addi	sp,sp,32
    80003186:	8082                	ret
    panic("bwrite");
    80003188:	00004517          	auipc	a0,0x4
    8000318c:	2e050513          	addi	a0,a0,736 # 80007468 <etext+0x468>
    80003190:	e12fd0ef          	jal	800007a2 <panic>

0000000080003194 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003194:	1101                	addi	sp,sp,-32
    80003196:	ec06                	sd	ra,24(sp)
    80003198:	e822                	sd	s0,16(sp)
    8000319a:	e426                	sd	s1,8(sp)
    8000319c:	e04a                	sd	s2,0(sp)
    8000319e:	1000                	addi	s0,sp,32
    800031a0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800031a2:	01050913          	addi	s2,a0,16
    800031a6:	854a                	mv	a0,s2
    800031a8:	1ba010ef          	jal	80004362 <holdingsleep>
    800031ac:	c135                	beqz	a0,80003210 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    800031ae:	854a                	mv	a0,s2
    800031b0:	17a010ef          	jal	8000432a <releasesleep>

  acquire(&bcache.lock);
    800031b4:	00016517          	auipc	a0,0x16
    800031b8:	93450513          	addi	a0,a0,-1740 # 80018ae8 <bcache>
    800031bc:	a47fd0ef          	jal	80000c02 <acquire>
  b->refcnt--;
    800031c0:	40bc                	lw	a5,64(s1)
    800031c2:	37fd                	addiw	a5,a5,-1
    800031c4:	0007871b          	sext.w	a4,a5
    800031c8:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800031ca:	e71d                	bnez	a4,800031f8 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800031cc:	68b8                	ld	a4,80(s1)
    800031ce:	64bc                	ld	a5,72(s1)
    800031d0:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800031d2:	68b8                	ld	a4,80(s1)
    800031d4:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800031d6:	0001e797          	auipc	a5,0x1e
    800031da:	91278793          	addi	a5,a5,-1774 # 80020ae8 <bcache+0x8000>
    800031de:	2b87b703          	ld	a4,696(a5)
    800031e2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800031e4:	0001e717          	auipc	a4,0x1e
    800031e8:	b6c70713          	addi	a4,a4,-1172 # 80020d50 <bcache+0x8268>
    800031ec:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800031ee:	2b87b703          	ld	a4,696(a5)
    800031f2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800031f4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800031f8:	00016517          	auipc	a0,0x16
    800031fc:	8f050513          	addi	a0,a0,-1808 # 80018ae8 <bcache>
    80003200:	a9bfd0ef          	jal	80000c9a <release>
}
    80003204:	60e2                	ld	ra,24(sp)
    80003206:	6442                	ld	s0,16(sp)
    80003208:	64a2                	ld	s1,8(sp)
    8000320a:	6902                	ld	s2,0(sp)
    8000320c:	6105                	addi	sp,sp,32
    8000320e:	8082                	ret
    panic("brelse");
    80003210:	00004517          	auipc	a0,0x4
    80003214:	26050513          	addi	a0,a0,608 # 80007470 <etext+0x470>
    80003218:	d8afd0ef          	jal	800007a2 <panic>

000000008000321c <bpin>:

void
bpin(struct buf *b) {
    8000321c:	1101                	addi	sp,sp,-32
    8000321e:	ec06                	sd	ra,24(sp)
    80003220:	e822                	sd	s0,16(sp)
    80003222:	e426                	sd	s1,8(sp)
    80003224:	1000                	addi	s0,sp,32
    80003226:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003228:	00016517          	auipc	a0,0x16
    8000322c:	8c050513          	addi	a0,a0,-1856 # 80018ae8 <bcache>
    80003230:	9d3fd0ef          	jal	80000c02 <acquire>
  b->refcnt++;
    80003234:	40bc                	lw	a5,64(s1)
    80003236:	2785                	addiw	a5,a5,1
    80003238:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000323a:	00016517          	auipc	a0,0x16
    8000323e:	8ae50513          	addi	a0,a0,-1874 # 80018ae8 <bcache>
    80003242:	a59fd0ef          	jal	80000c9a <release>
}
    80003246:	60e2                	ld	ra,24(sp)
    80003248:	6442                	ld	s0,16(sp)
    8000324a:	64a2                	ld	s1,8(sp)
    8000324c:	6105                	addi	sp,sp,32
    8000324e:	8082                	ret

0000000080003250 <bunpin>:

void
bunpin(struct buf *b) {
    80003250:	1101                	addi	sp,sp,-32
    80003252:	ec06                	sd	ra,24(sp)
    80003254:	e822                	sd	s0,16(sp)
    80003256:	e426                	sd	s1,8(sp)
    80003258:	1000                	addi	s0,sp,32
    8000325a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000325c:	00016517          	auipc	a0,0x16
    80003260:	88c50513          	addi	a0,a0,-1908 # 80018ae8 <bcache>
    80003264:	99ffd0ef          	jal	80000c02 <acquire>
  b->refcnt--;
    80003268:	40bc                	lw	a5,64(s1)
    8000326a:	37fd                	addiw	a5,a5,-1
    8000326c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000326e:	00016517          	auipc	a0,0x16
    80003272:	87a50513          	addi	a0,a0,-1926 # 80018ae8 <bcache>
    80003276:	a25fd0ef          	jal	80000c9a <release>
}
    8000327a:	60e2                	ld	ra,24(sp)
    8000327c:	6442                	ld	s0,16(sp)
    8000327e:	64a2                	ld	s1,8(sp)
    80003280:	6105                	addi	sp,sp,32
    80003282:	8082                	ret

0000000080003284 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003284:	1101                	addi	sp,sp,-32
    80003286:	ec06                	sd	ra,24(sp)
    80003288:	e822                	sd	s0,16(sp)
    8000328a:	e426                	sd	s1,8(sp)
    8000328c:	e04a                	sd	s2,0(sp)
    8000328e:	1000                	addi	s0,sp,32
    80003290:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003292:	00d5d59b          	srliw	a1,a1,0xd
    80003296:	0001e797          	auipc	a5,0x1e
    8000329a:	f2e7a783          	lw	a5,-210(a5) # 800211c4 <sb+0x1c>
    8000329e:	9dbd                	addw	a1,a1,a5
    800032a0:	dedff0ef          	jal	8000308c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800032a4:	0074f713          	andi	a4,s1,7
    800032a8:	4785                	li	a5,1
    800032aa:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800032ae:	14ce                	slli	s1,s1,0x33
    800032b0:	90d9                	srli	s1,s1,0x36
    800032b2:	00950733          	add	a4,a0,s1
    800032b6:	05874703          	lbu	a4,88(a4)
    800032ba:	00e7f6b3          	and	a3,a5,a4
    800032be:	c29d                	beqz	a3,800032e4 <bfree+0x60>
    800032c0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800032c2:	94aa                	add	s1,s1,a0
    800032c4:	fff7c793          	not	a5,a5
    800032c8:	8f7d                	and	a4,a4,a5
    800032ca:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800032ce:	711000ef          	jal	800041de <log_write>
  brelse(bp);
    800032d2:	854a                	mv	a0,s2
    800032d4:	ec1ff0ef          	jal	80003194 <brelse>
}
    800032d8:	60e2                	ld	ra,24(sp)
    800032da:	6442                	ld	s0,16(sp)
    800032dc:	64a2                	ld	s1,8(sp)
    800032de:	6902                	ld	s2,0(sp)
    800032e0:	6105                	addi	sp,sp,32
    800032e2:	8082                	ret
    panic("freeing free block");
    800032e4:	00004517          	auipc	a0,0x4
    800032e8:	19450513          	addi	a0,a0,404 # 80007478 <etext+0x478>
    800032ec:	cb6fd0ef          	jal	800007a2 <panic>

00000000800032f0 <balloc>:
{
    800032f0:	711d                	addi	sp,sp,-96
    800032f2:	ec86                	sd	ra,88(sp)
    800032f4:	e8a2                	sd	s0,80(sp)
    800032f6:	e4a6                	sd	s1,72(sp)
    800032f8:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800032fa:	0001e797          	auipc	a5,0x1e
    800032fe:	eb27a783          	lw	a5,-334(a5) # 800211ac <sb+0x4>
    80003302:	0e078f63          	beqz	a5,80003400 <balloc+0x110>
    80003306:	e0ca                	sd	s2,64(sp)
    80003308:	fc4e                	sd	s3,56(sp)
    8000330a:	f852                	sd	s4,48(sp)
    8000330c:	f456                	sd	s5,40(sp)
    8000330e:	f05a                	sd	s6,32(sp)
    80003310:	ec5e                	sd	s7,24(sp)
    80003312:	e862                	sd	s8,16(sp)
    80003314:	e466                	sd	s9,8(sp)
    80003316:	8baa                	mv	s7,a0
    80003318:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000331a:	0001eb17          	auipc	s6,0x1e
    8000331e:	e8eb0b13          	addi	s6,s6,-370 # 800211a8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003322:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003324:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003326:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003328:	6c89                	lui	s9,0x2
    8000332a:	a0b5                	j	80003396 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000332c:	97ca                	add	a5,a5,s2
    8000332e:	8e55                	or	a2,a2,a3
    80003330:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003334:	854a                	mv	a0,s2
    80003336:	6a9000ef          	jal	800041de <log_write>
        brelse(bp);
    8000333a:	854a                	mv	a0,s2
    8000333c:	e59ff0ef          	jal	80003194 <brelse>
  bp = bread(dev, bno);
    80003340:	85a6                	mv	a1,s1
    80003342:	855e                	mv	a0,s7
    80003344:	d49ff0ef          	jal	8000308c <bread>
    80003348:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000334a:	40000613          	li	a2,1024
    8000334e:	4581                	li	a1,0
    80003350:	05850513          	addi	a0,a0,88
    80003354:	983fd0ef          	jal	80000cd6 <memset>
  log_write(bp);
    80003358:	854a                	mv	a0,s2
    8000335a:	685000ef          	jal	800041de <log_write>
  brelse(bp);
    8000335e:	854a                	mv	a0,s2
    80003360:	e35ff0ef          	jal	80003194 <brelse>
}
    80003364:	6906                	ld	s2,64(sp)
    80003366:	79e2                	ld	s3,56(sp)
    80003368:	7a42                	ld	s4,48(sp)
    8000336a:	7aa2                	ld	s5,40(sp)
    8000336c:	7b02                	ld	s6,32(sp)
    8000336e:	6be2                	ld	s7,24(sp)
    80003370:	6c42                	ld	s8,16(sp)
    80003372:	6ca2                	ld	s9,8(sp)
}
    80003374:	8526                	mv	a0,s1
    80003376:	60e6                	ld	ra,88(sp)
    80003378:	6446                	ld	s0,80(sp)
    8000337a:	64a6                	ld	s1,72(sp)
    8000337c:	6125                	addi	sp,sp,96
    8000337e:	8082                	ret
    brelse(bp);
    80003380:	854a                	mv	a0,s2
    80003382:	e13ff0ef          	jal	80003194 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003386:	015c87bb          	addw	a5,s9,s5
    8000338a:	00078a9b          	sext.w	s5,a5
    8000338e:	004b2703          	lw	a4,4(s6)
    80003392:	04eaff63          	bgeu	s5,a4,800033f0 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80003396:	41fad79b          	sraiw	a5,s5,0x1f
    8000339a:	0137d79b          	srliw	a5,a5,0x13
    8000339e:	015787bb          	addw	a5,a5,s5
    800033a2:	40d7d79b          	sraiw	a5,a5,0xd
    800033a6:	01cb2583          	lw	a1,28(s6)
    800033aa:	9dbd                	addw	a1,a1,a5
    800033ac:	855e                	mv	a0,s7
    800033ae:	cdfff0ef          	jal	8000308c <bread>
    800033b2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033b4:	004b2503          	lw	a0,4(s6)
    800033b8:	000a849b          	sext.w	s1,s5
    800033bc:	8762                	mv	a4,s8
    800033be:	fca4f1e3          	bgeu	s1,a0,80003380 <balloc+0x90>
      m = 1 << (bi % 8);
    800033c2:	00777693          	andi	a3,a4,7
    800033c6:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800033ca:	41f7579b          	sraiw	a5,a4,0x1f
    800033ce:	01d7d79b          	srliw	a5,a5,0x1d
    800033d2:	9fb9                	addw	a5,a5,a4
    800033d4:	4037d79b          	sraiw	a5,a5,0x3
    800033d8:	00f90633          	add	a2,s2,a5
    800033dc:	05864603          	lbu	a2,88(a2)
    800033e0:	00c6f5b3          	and	a1,a3,a2
    800033e4:	d5a1                	beqz	a1,8000332c <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033e6:	2705                	addiw	a4,a4,1
    800033e8:	2485                	addiw	s1,s1,1
    800033ea:	fd471ae3          	bne	a4,s4,800033be <balloc+0xce>
    800033ee:	bf49                	j	80003380 <balloc+0x90>
    800033f0:	6906                	ld	s2,64(sp)
    800033f2:	79e2                	ld	s3,56(sp)
    800033f4:	7a42                	ld	s4,48(sp)
    800033f6:	7aa2                	ld	s5,40(sp)
    800033f8:	7b02                	ld	s6,32(sp)
    800033fa:	6be2                	ld	s7,24(sp)
    800033fc:	6c42                	ld	s8,16(sp)
    800033fe:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80003400:	00004517          	auipc	a0,0x4
    80003404:	09050513          	addi	a0,a0,144 # 80007490 <etext+0x490>
    80003408:	8c8fd0ef          	jal	800004d0 <printf>
  return 0;
    8000340c:	4481                	li	s1,0
    8000340e:	b79d                	j	80003374 <balloc+0x84>

0000000080003410 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003410:	7179                	addi	sp,sp,-48
    80003412:	f406                	sd	ra,40(sp)
    80003414:	f022                	sd	s0,32(sp)
    80003416:	ec26                	sd	s1,24(sp)
    80003418:	e84a                	sd	s2,16(sp)
    8000341a:	e44e                	sd	s3,8(sp)
    8000341c:	1800                	addi	s0,sp,48
    8000341e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003420:	47ad                	li	a5,11
    80003422:	02b7e663          	bltu	a5,a1,8000344e <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80003426:	02059793          	slli	a5,a1,0x20
    8000342a:	01e7d593          	srli	a1,a5,0x1e
    8000342e:	00b504b3          	add	s1,a0,a1
    80003432:	0504a903          	lw	s2,80(s1)
    80003436:	06091a63          	bnez	s2,800034aa <bmap+0x9a>
      addr = balloc(ip->dev);
    8000343a:	4108                	lw	a0,0(a0)
    8000343c:	eb5ff0ef          	jal	800032f0 <balloc>
    80003440:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003444:	06090363          	beqz	s2,800034aa <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80003448:	0524a823          	sw	s2,80(s1)
    8000344c:	a8b9                	j	800034aa <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000344e:	ff45849b          	addiw	s1,a1,-12
    80003452:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003456:	0ff00793          	li	a5,255
    8000345a:	06e7ee63          	bltu	a5,a4,800034d6 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000345e:	08052903          	lw	s2,128(a0)
    80003462:	00091d63          	bnez	s2,8000347c <bmap+0x6c>
      addr = balloc(ip->dev);
    80003466:	4108                	lw	a0,0(a0)
    80003468:	e89ff0ef          	jal	800032f0 <balloc>
    8000346c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003470:	02090d63          	beqz	s2,800034aa <bmap+0x9a>
    80003474:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003476:	0929a023          	sw	s2,128(s3)
    8000347a:	a011                	j	8000347e <bmap+0x6e>
    8000347c:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000347e:	85ca                	mv	a1,s2
    80003480:	0009a503          	lw	a0,0(s3)
    80003484:	c09ff0ef          	jal	8000308c <bread>
    80003488:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000348a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000348e:	02049713          	slli	a4,s1,0x20
    80003492:	01e75593          	srli	a1,a4,0x1e
    80003496:	00b784b3          	add	s1,a5,a1
    8000349a:	0004a903          	lw	s2,0(s1)
    8000349e:	00090e63          	beqz	s2,800034ba <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800034a2:	8552                	mv	a0,s4
    800034a4:	cf1ff0ef          	jal	80003194 <brelse>
    return addr;
    800034a8:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800034aa:	854a                	mv	a0,s2
    800034ac:	70a2                	ld	ra,40(sp)
    800034ae:	7402                	ld	s0,32(sp)
    800034b0:	64e2                	ld	s1,24(sp)
    800034b2:	6942                	ld	s2,16(sp)
    800034b4:	69a2                	ld	s3,8(sp)
    800034b6:	6145                	addi	sp,sp,48
    800034b8:	8082                	ret
      addr = balloc(ip->dev);
    800034ba:	0009a503          	lw	a0,0(s3)
    800034be:	e33ff0ef          	jal	800032f0 <balloc>
    800034c2:	0005091b          	sext.w	s2,a0
      if(addr){
    800034c6:	fc090ee3          	beqz	s2,800034a2 <bmap+0x92>
        a[bn] = addr;
    800034ca:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800034ce:	8552                	mv	a0,s4
    800034d0:	50f000ef          	jal	800041de <log_write>
    800034d4:	b7f9                	j	800034a2 <bmap+0x92>
    800034d6:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800034d8:	00004517          	auipc	a0,0x4
    800034dc:	fd050513          	addi	a0,a0,-48 # 800074a8 <etext+0x4a8>
    800034e0:	ac2fd0ef          	jal	800007a2 <panic>

00000000800034e4 <iget>:
{
    800034e4:	7179                	addi	sp,sp,-48
    800034e6:	f406                	sd	ra,40(sp)
    800034e8:	f022                	sd	s0,32(sp)
    800034ea:	ec26                	sd	s1,24(sp)
    800034ec:	e84a                	sd	s2,16(sp)
    800034ee:	e44e                	sd	s3,8(sp)
    800034f0:	e052                	sd	s4,0(sp)
    800034f2:	1800                	addi	s0,sp,48
    800034f4:	89aa                	mv	s3,a0
    800034f6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800034f8:	0001e517          	auipc	a0,0x1e
    800034fc:	cd050513          	addi	a0,a0,-816 # 800211c8 <itable>
    80003500:	f02fd0ef          	jal	80000c02 <acquire>
  empty = 0;
    80003504:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003506:	0001e497          	auipc	s1,0x1e
    8000350a:	cda48493          	addi	s1,s1,-806 # 800211e0 <itable+0x18>
    8000350e:	0001f697          	auipc	a3,0x1f
    80003512:	76268693          	addi	a3,a3,1890 # 80022c70 <log>
    80003516:	a039                	j	80003524 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003518:	02090963          	beqz	s2,8000354a <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000351c:	08848493          	addi	s1,s1,136
    80003520:	02d48863          	beq	s1,a3,80003550 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003524:	449c                	lw	a5,8(s1)
    80003526:	fef059e3          	blez	a5,80003518 <iget+0x34>
    8000352a:	4098                	lw	a4,0(s1)
    8000352c:	ff3716e3          	bne	a4,s3,80003518 <iget+0x34>
    80003530:	40d8                	lw	a4,4(s1)
    80003532:	ff4713e3          	bne	a4,s4,80003518 <iget+0x34>
      ip->ref++;
    80003536:	2785                	addiw	a5,a5,1
    80003538:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000353a:	0001e517          	auipc	a0,0x1e
    8000353e:	c8e50513          	addi	a0,a0,-882 # 800211c8 <itable>
    80003542:	f58fd0ef          	jal	80000c9a <release>
      return ip;
    80003546:	8926                	mv	s2,s1
    80003548:	a02d                	j	80003572 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000354a:	fbe9                	bnez	a5,8000351c <iget+0x38>
      empty = ip;
    8000354c:	8926                	mv	s2,s1
    8000354e:	b7f9                	j	8000351c <iget+0x38>
  if(empty == 0)
    80003550:	02090a63          	beqz	s2,80003584 <iget+0xa0>
  ip->dev = dev;
    80003554:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003558:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000355c:	4785                	li	a5,1
    8000355e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003562:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003566:	0001e517          	auipc	a0,0x1e
    8000356a:	c6250513          	addi	a0,a0,-926 # 800211c8 <itable>
    8000356e:	f2cfd0ef          	jal	80000c9a <release>
}
    80003572:	854a                	mv	a0,s2
    80003574:	70a2                	ld	ra,40(sp)
    80003576:	7402                	ld	s0,32(sp)
    80003578:	64e2                	ld	s1,24(sp)
    8000357a:	6942                	ld	s2,16(sp)
    8000357c:	69a2                	ld	s3,8(sp)
    8000357e:	6a02                	ld	s4,0(sp)
    80003580:	6145                	addi	sp,sp,48
    80003582:	8082                	ret
    panic("iget: no inodes");
    80003584:	00004517          	auipc	a0,0x4
    80003588:	f3c50513          	addi	a0,a0,-196 # 800074c0 <etext+0x4c0>
    8000358c:	a16fd0ef          	jal	800007a2 <panic>

0000000080003590 <fsinit>:
fsinit(int dev) {
    80003590:	7179                	addi	sp,sp,-48
    80003592:	f406                	sd	ra,40(sp)
    80003594:	f022                	sd	s0,32(sp)
    80003596:	ec26                	sd	s1,24(sp)
    80003598:	e84a                	sd	s2,16(sp)
    8000359a:	e44e                	sd	s3,8(sp)
    8000359c:	1800                	addi	s0,sp,48
    8000359e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800035a0:	4585                	li	a1,1
    800035a2:	aebff0ef          	jal	8000308c <bread>
    800035a6:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800035a8:	0001e997          	auipc	s3,0x1e
    800035ac:	c0098993          	addi	s3,s3,-1024 # 800211a8 <sb>
    800035b0:	02000613          	li	a2,32
    800035b4:	05850593          	addi	a1,a0,88
    800035b8:	854e                	mv	a0,s3
    800035ba:	f78fd0ef          	jal	80000d32 <memmove>
  brelse(bp);
    800035be:	8526                	mv	a0,s1
    800035c0:	bd5ff0ef          	jal	80003194 <brelse>
  if(sb.magic != FSMAGIC)
    800035c4:	0009a703          	lw	a4,0(s3)
    800035c8:	102037b7          	lui	a5,0x10203
    800035cc:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800035d0:	02f71063          	bne	a4,a5,800035f0 <fsinit+0x60>
  initlog(dev, &sb);
    800035d4:	0001e597          	auipc	a1,0x1e
    800035d8:	bd458593          	addi	a1,a1,-1068 # 800211a8 <sb>
    800035dc:	854a                	mv	a0,s2
    800035de:	1f9000ef          	jal	80003fd6 <initlog>
}
    800035e2:	70a2                	ld	ra,40(sp)
    800035e4:	7402                	ld	s0,32(sp)
    800035e6:	64e2                	ld	s1,24(sp)
    800035e8:	6942                	ld	s2,16(sp)
    800035ea:	69a2                	ld	s3,8(sp)
    800035ec:	6145                	addi	sp,sp,48
    800035ee:	8082                	ret
    panic("invalid file system");
    800035f0:	00004517          	auipc	a0,0x4
    800035f4:	ee050513          	addi	a0,a0,-288 # 800074d0 <etext+0x4d0>
    800035f8:	9aafd0ef          	jal	800007a2 <panic>

00000000800035fc <iinit>:
{
    800035fc:	7179                	addi	sp,sp,-48
    800035fe:	f406                	sd	ra,40(sp)
    80003600:	f022                	sd	s0,32(sp)
    80003602:	ec26                	sd	s1,24(sp)
    80003604:	e84a                	sd	s2,16(sp)
    80003606:	e44e                	sd	s3,8(sp)
    80003608:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000360a:	00004597          	auipc	a1,0x4
    8000360e:	ede58593          	addi	a1,a1,-290 # 800074e8 <etext+0x4e8>
    80003612:	0001e517          	auipc	a0,0x1e
    80003616:	bb650513          	addi	a0,a0,-1098 # 800211c8 <itable>
    8000361a:	d68fd0ef          	jal	80000b82 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000361e:	0001e497          	auipc	s1,0x1e
    80003622:	bd248493          	addi	s1,s1,-1070 # 800211f0 <itable+0x28>
    80003626:	0001f997          	auipc	s3,0x1f
    8000362a:	65a98993          	addi	s3,s3,1626 # 80022c80 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000362e:	00004917          	auipc	s2,0x4
    80003632:	ec290913          	addi	s2,s2,-318 # 800074f0 <etext+0x4f0>
    80003636:	85ca                	mv	a1,s2
    80003638:	8526                	mv	a0,s1
    8000363a:	475000ef          	jal	800042ae <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000363e:	08848493          	addi	s1,s1,136
    80003642:	ff349ae3          	bne	s1,s3,80003636 <iinit+0x3a>
}
    80003646:	70a2                	ld	ra,40(sp)
    80003648:	7402                	ld	s0,32(sp)
    8000364a:	64e2                	ld	s1,24(sp)
    8000364c:	6942                	ld	s2,16(sp)
    8000364e:	69a2                	ld	s3,8(sp)
    80003650:	6145                	addi	sp,sp,48
    80003652:	8082                	ret

0000000080003654 <ialloc>:
{
    80003654:	7139                	addi	sp,sp,-64
    80003656:	fc06                	sd	ra,56(sp)
    80003658:	f822                	sd	s0,48(sp)
    8000365a:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000365c:	0001e717          	auipc	a4,0x1e
    80003660:	b5872703          	lw	a4,-1192(a4) # 800211b4 <sb+0xc>
    80003664:	4785                	li	a5,1
    80003666:	06e7f063          	bgeu	a5,a4,800036c6 <ialloc+0x72>
    8000366a:	f426                	sd	s1,40(sp)
    8000366c:	f04a                	sd	s2,32(sp)
    8000366e:	ec4e                	sd	s3,24(sp)
    80003670:	e852                	sd	s4,16(sp)
    80003672:	e456                	sd	s5,8(sp)
    80003674:	e05a                	sd	s6,0(sp)
    80003676:	8aaa                	mv	s5,a0
    80003678:	8b2e                	mv	s6,a1
    8000367a:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000367c:	0001ea17          	auipc	s4,0x1e
    80003680:	b2ca0a13          	addi	s4,s4,-1236 # 800211a8 <sb>
    80003684:	00495593          	srli	a1,s2,0x4
    80003688:	018a2783          	lw	a5,24(s4)
    8000368c:	9dbd                	addw	a1,a1,a5
    8000368e:	8556                	mv	a0,s5
    80003690:	9fdff0ef          	jal	8000308c <bread>
    80003694:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003696:	05850993          	addi	s3,a0,88
    8000369a:	00f97793          	andi	a5,s2,15
    8000369e:	079a                	slli	a5,a5,0x6
    800036a0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800036a2:	00099783          	lh	a5,0(s3)
    800036a6:	cb9d                	beqz	a5,800036dc <ialloc+0x88>
    brelse(bp);
    800036a8:	aedff0ef          	jal	80003194 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800036ac:	0905                	addi	s2,s2,1
    800036ae:	00ca2703          	lw	a4,12(s4)
    800036b2:	0009079b          	sext.w	a5,s2
    800036b6:	fce7e7e3          	bltu	a5,a4,80003684 <ialloc+0x30>
    800036ba:	74a2                	ld	s1,40(sp)
    800036bc:	7902                	ld	s2,32(sp)
    800036be:	69e2                	ld	s3,24(sp)
    800036c0:	6a42                	ld	s4,16(sp)
    800036c2:	6aa2                	ld	s5,8(sp)
    800036c4:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800036c6:	00004517          	auipc	a0,0x4
    800036ca:	e3250513          	addi	a0,a0,-462 # 800074f8 <etext+0x4f8>
    800036ce:	e03fc0ef          	jal	800004d0 <printf>
  return 0;
    800036d2:	4501                	li	a0,0
}
    800036d4:	70e2                	ld	ra,56(sp)
    800036d6:	7442                	ld	s0,48(sp)
    800036d8:	6121                	addi	sp,sp,64
    800036da:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800036dc:	04000613          	li	a2,64
    800036e0:	4581                	li	a1,0
    800036e2:	854e                	mv	a0,s3
    800036e4:	df2fd0ef          	jal	80000cd6 <memset>
      dip->type = type;
    800036e8:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800036ec:	8526                	mv	a0,s1
    800036ee:	2f1000ef          	jal	800041de <log_write>
      brelse(bp);
    800036f2:	8526                	mv	a0,s1
    800036f4:	aa1ff0ef          	jal	80003194 <brelse>
      return iget(dev, inum);
    800036f8:	0009059b          	sext.w	a1,s2
    800036fc:	8556                	mv	a0,s5
    800036fe:	de7ff0ef          	jal	800034e4 <iget>
    80003702:	74a2                	ld	s1,40(sp)
    80003704:	7902                	ld	s2,32(sp)
    80003706:	69e2                	ld	s3,24(sp)
    80003708:	6a42                	ld	s4,16(sp)
    8000370a:	6aa2                	ld	s5,8(sp)
    8000370c:	6b02                	ld	s6,0(sp)
    8000370e:	b7d9                	j	800036d4 <ialloc+0x80>

0000000080003710 <iupdate>:
{
    80003710:	1101                	addi	sp,sp,-32
    80003712:	ec06                	sd	ra,24(sp)
    80003714:	e822                	sd	s0,16(sp)
    80003716:	e426                	sd	s1,8(sp)
    80003718:	e04a                	sd	s2,0(sp)
    8000371a:	1000                	addi	s0,sp,32
    8000371c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000371e:	415c                	lw	a5,4(a0)
    80003720:	0047d79b          	srliw	a5,a5,0x4
    80003724:	0001e597          	auipc	a1,0x1e
    80003728:	a9c5a583          	lw	a1,-1380(a1) # 800211c0 <sb+0x18>
    8000372c:	9dbd                	addw	a1,a1,a5
    8000372e:	4108                	lw	a0,0(a0)
    80003730:	95dff0ef          	jal	8000308c <bread>
    80003734:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003736:	05850793          	addi	a5,a0,88
    8000373a:	40d8                	lw	a4,4(s1)
    8000373c:	8b3d                	andi	a4,a4,15
    8000373e:	071a                	slli	a4,a4,0x6
    80003740:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003742:	04449703          	lh	a4,68(s1)
    80003746:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000374a:	04649703          	lh	a4,70(s1)
    8000374e:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003752:	04849703          	lh	a4,72(s1)
    80003756:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000375a:	04a49703          	lh	a4,74(s1)
    8000375e:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003762:	44f8                	lw	a4,76(s1)
    80003764:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003766:	03400613          	li	a2,52
    8000376a:	05048593          	addi	a1,s1,80
    8000376e:	00c78513          	addi	a0,a5,12
    80003772:	dc0fd0ef          	jal	80000d32 <memmove>
  log_write(bp);
    80003776:	854a                	mv	a0,s2
    80003778:	267000ef          	jal	800041de <log_write>
  brelse(bp);
    8000377c:	854a                	mv	a0,s2
    8000377e:	a17ff0ef          	jal	80003194 <brelse>
}
    80003782:	60e2                	ld	ra,24(sp)
    80003784:	6442                	ld	s0,16(sp)
    80003786:	64a2                	ld	s1,8(sp)
    80003788:	6902                	ld	s2,0(sp)
    8000378a:	6105                	addi	sp,sp,32
    8000378c:	8082                	ret

000000008000378e <idup>:
{
    8000378e:	1101                	addi	sp,sp,-32
    80003790:	ec06                	sd	ra,24(sp)
    80003792:	e822                	sd	s0,16(sp)
    80003794:	e426                	sd	s1,8(sp)
    80003796:	1000                	addi	s0,sp,32
    80003798:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000379a:	0001e517          	auipc	a0,0x1e
    8000379e:	a2e50513          	addi	a0,a0,-1490 # 800211c8 <itable>
    800037a2:	c60fd0ef          	jal	80000c02 <acquire>
  ip->ref++;
    800037a6:	449c                	lw	a5,8(s1)
    800037a8:	2785                	addiw	a5,a5,1
    800037aa:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800037ac:	0001e517          	auipc	a0,0x1e
    800037b0:	a1c50513          	addi	a0,a0,-1508 # 800211c8 <itable>
    800037b4:	ce6fd0ef          	jal	80000c9a <release>
}
    800037b8:	8526                	mv	a0,s1
    800037ba:	60e2                	ld	ra,24(sp)
    800037bc:	6442                	ld	s0,16(sp)
    800037be:	64a2                	ld	s1,8(sp)
    800037c0:	6105                	addi	sp,sp,32
    800037c2:	8082                	ret

00000000800037c4 <ilock>:
{
    800037c4:	1101                	addi	sp,sp,-32
    800037c6:	ec06                	sd	ra,24(sp)
    800037c8:	e822                	sd	s0,16(sp)
    800037ca:	e426                	sd	s1,8(sp)
    800037cc:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800037ce:	cd19                	beqz	a0,800037ec <ilock+0x28>
    800037d0:	84aa                	mv	s1,a0
    800037d2:	451c                	lw	a5,8(a0)
    800037d4:	00f05c63          	blez	a5,800037ec <ilock+0x28>
  acquiresleep(&ip->lock);
    800037d8:	0541                	addi	a0,a0,16
    800037da:	30b000ef          	jal	800042e4 <acquiresleep>
  if(ip->valid == 0){
    800037de:	40bc                	lw	a5,64(s1)
    800037e0:	cf89                	beqz	a5,800037fa <ilock+0x36>
}
    800037e2:	60e2                	ld	ra,24(sp)
    800037e4:	6442                	ld	s0,16(sp)
    800037e6:	64a2                	ld	s1,8(sp)
    800037e8:	6105                	addi	sp,sp,32
    800037ea:	8082                	ret
    800037ec:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800037ee:	00004517          	auipc	a0,0x4
    800037f2:	d2250513          	addi	a0,a0,-734 # 80007510 <etext+0x510>
    800037f6:	fadfc0ef          	jal	800007a2 <panic>
    800037fa:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800037fc:	40dc                	lw	a5,4(s1)
    800037fe:	0047d79b          	srliw	a5,a5,0x4
    80003802:	0001e597          	auipc	a1,0x1e
    80003806:	9be5a583          	lw	a1,-1602(a1) # 800211c0 <sb+0x18>
    8000380a:	9dbd                	addw	a1,a1,a5
    8000380c:	4088                	lw	a0,0(s1)
    8000380e:	87fff0ef          	jal	8000308c <bread>
    80003812:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003814:	05850593          	addi	a1,a0,88
    80003818:	40dc                	lw	a5,4(s1)
    8000381a:	8bbd                	andi	a5,a5,15
    8000381c:	079a                	slli	a5,a5,0x6
    8000381e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003820:	00059783          	lh	a5,0(a1)
    80003824:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003828:	00259783          	lh	a5,2(a1)
    8000382c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003830:	00459783          	lh	a5,4(a1)
    80003834:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003838:	00659783          	lh	a5,6(a1)
    8000383c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003840:	459c                	lw	a5,8(a1)
    80003842:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003844:	03400613          	li	a2,52
    80003848:	05b1                	addi	a1,a1,12
    8000384a:	05048513          	addi	a0,s1,80
    8000384e:	ce4fd0ef          	jal	80000d32 <memmove>
    brelse(bp);
    80003852:	854a                	mv	a0,s2
    80003854:	941ff0ef          	jal	80003194 <brelse>
    ip->valid = 1;
    80003858:	4785                	li	a5,1
    8000385a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000385c:	04449783          	lh	a5,68(s1)
    80003860:	c399                	beqz	a5,80003866 <ilock+0xa2>
    80003862:	6902                	ld	s2,0(sp)
    80003864:	bfbd                	j	800037e2 <ilock+0x1e>
      panic("ilock: no type");
    80003866:	00004517          	auipc	a0,0x4
    8000386a:	cb250513          	addi	a0,a0,-846 # 80007518 <etext+0x518>
    8000386e:	f35fc0ef          	jal	800007a2 <panic>

0000000080003872 <iunlock>:
{
    80003872:	1101                	addi	sp,sp,-32
    80003874:	ec06                	sd	ra,24(sp)
    80003876:	e822                	sd	s0,16(sp)
    80003878:	e426                	sd	s1,8(sp)
    8000387a:	e04a                	sd	s2,0(sp)
    8000387c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000387e:	c505                	beqz	a0,800038a6 <iunlock+0x34>
    80003880:	84aa                	mv	s1,a0
    80003882:	01050913          	addi	s2,a0,16
    80003886:	854a                	mv	a0,s2
    80003888:	2db000ef          	jal	80004362 <holdingsleep>
    8000388c:	cd09                	beqz	a0,800038a6 <iunlock+0x34>
    8000388e:	449c                	lw	a5,8(s1)
    80003890:	00f05b63          	blez	a5,800038a6 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003894:	854a                	mv	a0,s2
    80003896:	295000ef          	jal	8000432a <releasesleep>
}
    8000389a:	60e2                	ld	ra,24(sp)
    8000389c:	6442                	ld	s0,16(sp)
    8000389e:	64a2                	ld	s1,8(sp)
    800038a0:	6902                	ld	s2,0(sp)
    800038a2:	6105                	addi	sp,sp,32
    800038a4:	8082                	ret
    panic("iunlock");
    800038a6:	00004517          	auipc	a0,0x4
    800038aa:	c8250513          	addi	a0,a0,-894 # 80007528 <etext+0x528>
    800038ae:	ef5fc0ef          	jal	800007a2 <panic>

00000000800038b2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800038b2:	7179                	addi	sp,sp,-48
    800038b4:	f406                	sd	ra,40(sp)
    800038b6:	f022                	sd	s0,32(sp)
    800038b8:	ec26                	sd	s1,24(sp)
    800038ba:	e84a                	sd	s2,16(sp)
    800038bc:	e44e                	sd	s3,8(sp)
    800038be:	1800                	addi	s0,sp,48
    800038c0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800038c2:	05050493          	addi	s1,a0,80
    800038c6:	08050913          	addi	s2,a0,128
    800038ca:	a021                	j	800038d2 <itrunc+0x20>
    800038cc:	0491                	addi	s1,s1,4
    800038ce:	01248b63          	beq	s1,s2,800038e4 <itrunc+0x32>
    if(ip->addrs[i]){
    800038d2:	408c                	lw	a1,0(s1)
    800038d4:	dde5                	beqz	a1,800038cc <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800038d6:	0009a503          	lw	a0,0(s3)
    800038da:	9abff0ef          	jal	80003284 <bfree>
      ip->addrs[i] = 0;
    800038de:	0004a023          	sw	zero,0(s1)
    800038e2:	b7ed                	j	800038cc <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800038e4:	0809a583          	lw	a1,128(s3)
    800038e8:	ed89                	bnez	a1,80003902 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800038ea:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800038ee:	854e                	mv	a0,s3
    800038f0:	e21ff0ef          	jal	80003710 <iupdate>
}
    800038f4:	70a2                	ld	ra,40(sp)
    800038f6:	7402                	ld	s0,32(sp)
    800038f8:	64e2                	ld	s1,24(sp)
    800038fa:	6942                	ld	s2,16(sp)
    800038fc:	69a2                	ld	s3,8(sp)
    800038fe:	6145                	addi	sp,sp,48
    80003900:	8082                	ret
    80003902:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003904:	0009a503          	lw	a0,0(s3)
    80003908:	f84ff0ef          	jal	8000308c <bread>
    8000390c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000390e:	05850493          	addi	s1,a0,88
    80003912:	45850913          	addi	s2,a0,1112
    80003916:	a021                	j	8000391e <itrunc+0x6c>
    80003918:	0491                	addi	s1,s1,4
    8000391a:	01248963          	beq	s1,s2,8000392c <itrunc+0x7a>
      if(a[j])
    8000391e:	408c                	lw	a1,0(s1)
    80003920:	dde5                	beqz	a1,80003918 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003922:	0009a503          	lw	a0,0(s3)
    80003926:	95fff0ef          	jal	80003284 <bfree>
    8000392a:	b7fd                	j	80003918 <itrunc+0x66>
    brelse(bp);
    8000392c:	8552                	mv	a0,s4
    8000392e:	867ff0ef          	jal	80003194 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003932:	0809a583          	lw	a1,128(s3)
    80003936:	0009a503          	lw	a0,0(s3)
    8000393a:	94bff0ef          	jal	80003284 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000393e:	0809a023          	sw	zero,128(s3)
    80003942:	6a02                	ld	s4,0(sp)
    80003944:	b75d                	j	800038ea <itrunc+0x38>

0000000080003946 <iput>:
{
    80003946:	1101                	addi	sp,sp,-32
    80003948:	ec06                	sd	ra,24(sp)
    8000394a:	e822                	sd	s0,16(sp)
    8000394c:	e426                	sd	s1,8(sp)
    8000394e:	1000                	addi	s0,sp,32
    80003950:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003952:	0001e517          	auipc	a0,0x1e
    80003956:	87650513          	addi	a0,a0,-1930 # 800211c8 <itable>
    8000395a:	aa8fd0ef          	jal	80000c02 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000395e:	4498                	lw	a4,8(s1)
    80003960:	4785                	li	a5,1
    80003962:	02f70063          	beq	a4,a5,80003982 <iput+0x3c>
  ip->ref--;
    80003966:	449c                	lw	a5,8(s1)
    80003968:	37fd                	addiw	a5,a5,-1
    8000396a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000396c:	0001e517          	auipc	a0,0x1e
    80003970:	85c50513          	addi	a0,a0,-1956 # 800211c8 <itable>
    80003974:	b26fd0ef          	jal	80000c9a <release>
}
    80003978:	60e2                	ld	ra,24(sp)
    8000397a:	6442                	ld	s0,16(sp)
    8000397c:	64a2                	ld	s1,8(sp)
    8000397e:	6105                	addi	sp,sp,32
    80003980:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003982:	40bc                	lw	a5,64(s1)
    80003984:	d3ed                	beqz	a5,80003966 <iput+0x20>
    80003986:	04a49783          	lh	a5,74(s1)
    8000398a:	fff1                	bnez	a5,80003966 <iput+0x20>
    8000398c:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000398e:	01048913          	addi	s2,s1,16
    80003992:	854a                	mv	a0,s2
    80003994:	151000ef          	jal	800042e4 <acquiresleep>
    release(&itable.lock);
    80003998:	0001e517          	auipc	a0,0x1e
    8000399c:	83050513          	addi	a0,a0,-2000 # 800211c8 <itable>
    800039a0:	afafd0ef          	jal	80000c9a <release>
    itrunc(ip);
    800039a4:	8526                	mv	a0,s1
    800039a6:	f0dff0ef          	jal	800038b2 <itrunc>
    ip->type = 0;
    800039aa:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800039ae:	8526                	mv	a0,s1
    800039b0:	d61ff0ef          	jal	80003710 <iupdate>
    ip->valid = 0;
    800039b4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800039b8:	854a                	mv	a0,s2
    800039ba:	171000ef          	jal	8000432a <releasesleep>
    acquire(&itable.lock);
    800039be:	0001e517          	auipc	a0,0x1e
    800039c2:	80a50513          	addi	a0,a0,-2038 # 800211c8 <itable>
    800039c6:	a3cfd0ef          	jal	80000c02 <acquire>
    800039ca:	6902                	ld	s2,0(sp)
    800039cc:	bf69                	j	80003966 <iput+0x20>

00000000800039ce <iunlockput>:
{
    800039ce:	1101                	addi	sp,sp,-32
    800039d0:	ec06                	sd	ra,24(sp)
    800039d2:	e822                	sd	s0,16(sp)
    800039d4:	e426                	sd	s1,8(sp)
    800039d6:	1000                	addi	s0,sp,32
    800039d8:	84aa                	mv	s1,a0
  iunlock(ip);
    800039da:	e99ff0ef          	jal	80003872 <iunlock>
  iput(ip);
    800039de:	8526                	mv	a0,s1
    800039e0:	f67ff0ef          	jal	80003946 <iput>
}
    800039e4:	60e2                	ld	ra,24(sp)
    800039e6:	6442                	ld	s0,16(sp)
    800039e8:	64a2                	ld	s1,8(sp)
    800039ea:	6105                	addi	sp,sp,32
    800039ec:	8082                	ret

00000000800039ee <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800039ee:	1141                	addi	sp,sp,-16
    800039f0:	e422                	sd	s0,8(sp)
    800039f2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800039f4:	411c                	lw	a5,0(a0)
    800039f6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800039f8:	415c                	lw	a5,4(a0)
    800039fa:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800039fc:	04451783          	lh	a5,68(a0)
    80003a00:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003a04:	04a51783          	lh	a5,74(a0)
    80003a08:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003a0c:	04c56783          	lwu	a5,76(a0)
    80003a10:	e99c                	sd	a5,16(a1)
}
    80003a12:	6422                	ld	s0,8(sp)
    80003a14:	0141                	addi	sp,sp,16
    80003a16:	8082                	ret

0000000080003a18 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a18:	457c                	lw	a5,76(a0)
    80003a1a:	0ed7eb63          	bltu	a5,a3,80003b10 <readi+0xf8>
{
    80003a1e:	7159                	addi	sp,sp,-112
    80003a20:	f486                	sd	ra,104(sp)
    80003a22:	f0a2                	sd	s0,96(sp)
    80003a24:	eca6                	sd	s1,88(sp)
    80003a26:	e0d2                	sd	s4,64(sp)
    80003a28:	fc56                	sd	s5,56(sp)
    80003a2a:	f85a                	sd	s6,48(sp)
    80003a2c:	f45e                	sd	s7,40(sp)
    80003a2e:	1880                	addi	s0,sp,112
    80003a30:	8b2a                	mv	s6,a0
    80003a32:	8bae                	mv	s7,a1
    80003a34:	8a32                	mv	s4,a2
    80003a36:	84b6                	mv	s1,a3
    80003a38:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003a3a:	9f35                	addw	a4,a4,a3
    return 0;
    80003a3c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003a3e:	0cd76063          	bltu	a4,a3,80003afe <readi+0xe6>
    80003a42:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003a44:	00e7f463          	bgeu	a5,a4,80003a4c <readi+0x34>
    n = ip->size - off;
    80003a48:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a4c:	080a8f63          	beqz	s5,80003aea <readi+0xd2>
    80003a50:	e8ca                	sd	s2,80(sp)
    80003a52:	f062                	sd	s8,32(sp)
    80003a54:	ec66                	sd	s9,24(sp)
    80003a56:	e86a                	sd	s10,16(sp)
    80003a58:	e46e                	sd	s11,8(sp)
    80003a5a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a5c:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003a60:	5c7d                	li	s8,-1
    80003a62:	a80d                	j	80003a94 <readi+0x7c>
    80003a64:	020d1d93          	slli	s11,s10,0x20
    80003a68:	020ddd93          	srli	s11,s11,0x20
    80003a6c:	05890613          	addi	a2,s2,88
    80003a70:	86ee                	mv	a3,s11
    80003a72:	963a                	add	a2,a2,a4
    80003a74:	85d2                	mv	a1,s4
    80003a76:	855e                	mv	a0,s7
    80003a78:	c1dfe0ef          	jal	80002694 <either_copyout>
    80003a7c:	05850763          	beq	a0,s8,80003aca <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003a80:	854a                	mv	a0,s2
    80003a82:	f12ff0ef          	jal	80003194 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a86:	013d09bb          	addw	s3,s10,s3
    80003a8a:	009d04bb          	addw	s1,s10,s1
    80003a8e:	9a6e                	add	s4,s4,s11
    80003a90:	0559f763          	bgeu	s3,s5,80003ade <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80003a94:	00a4d59b          	srliw	a1,s1,0xa
    80003a98:	855a                	mv	a0,s6
    80003a9a:	977ff0ef          	jal	80003410 <bmap>
    80003a9e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003aa2:	c5b1                	beqz	a1,80003aee <readi+0xd6>
    bp = bread(ip->dev, addr);
    80003aa4:	000b2503          	lw	a0,0(s6)
    80003aa8:	de4ff0ef          	jal	8000308c <bread>
    80003aac:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003aae:	3ff4f713          	andi	a4,s1,1023
    80003ab2:	40ec87bb          	subw	a5,s9,a4
    80003ab6:	413a86bb          	subw	a3,s5,s3
    80003aba:	8d3e                	mv	s10,a5
    80003abc:	2781                	sext.w	a5,a5
    80003abe:	0006861b          	sext.w	a2,a3
    80003ac2:	faf671e3          	bgeu	a2,a5,80003a64 <readi+0x4c>
    80003ac6:	8d36                	mv	s10,a3
    80003ac8:	bf71                	j	80003a64 <readi+0x4c>
      brelse(bp);
    80003aca:	854a                	mv	a0,s2
    80003acc:	ec8ff0ef          	jal	80003194 <brelse>
      tot = -1;
    80003ad0:	59fd                	li	s3,-1
      break;
    80003ad2:	6946                	ld	s2,80(sp)
    80003ad4:	7c02                	ld	s8,32(sp)
    80003ad6:	6ce2                	ld	s9,24(sp)
    80003ad8:	6d42                	ld	s10,16(sp)
    80003ada:	6da2                	ld	s11,8(sp)
    80003adc:	a831                	j	80003af8 <readi+0xe0>
    80003ade:	6946                	ld	s2,80(sp)
    80003ae0:	7c02                	ld	s8,32(sp)
    80003ae2:	6ce2                	ld	s9,24(sp)
    80003ae4:	6d42                	ld	s10,16(sp)
    80003ae6:	6da2                	ld	s11,8(sp)
    80003ae8:	a801                	j	80003af8 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003aea:	89d6                	mv	s3,s5
    80003aec:	a031                	j	80003af8 <readi+0xe0>
    80003aee:	6946                	ld	s2,80(sp)
    80003af0:	7c02                	ld	s8,32(sp)
    80003af2:	6ce2                	ld	s9,24(sp)
    80003af4:	6d42                	ld	s10,16(sp)
    80003af6:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003af8:	0009851b          	sext.w	a0,s3
    80003afc:	69a6                	ld	s3,72(sp)
}
    80003afe:	70a6                	ld	ra,104(sp)
    80003b00:	7406                	ld	s0,96(sp)
    80003b02:	64e6                	ld	s1,88(sp)
    80003b04:	6a06                	ld	s4,64(sp)
    80003b06:	7ae2                	ld	s5,56(sp)
    80003b08:	7b42                	ld	s6,48(sp)
    80003b0a:	7ba2                	ld	s7,40(sp)
    80003b0c:	6165                	addi	sp,sp,112
    80003b0e:	8082                	ret
    return 0;
    80003b10:	4501                	li	a0,0
}
    80003b12:	8082                	ret

0000000080003b14 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b14:	457c                	lw	a5,76(a0)
    80003b16:	10d7e063          	bltu	a5,a3,80003c16 <writei+0x102>
{
    80003b1a:	7159                	addi	sp,sp,-112
    80003b1c:	f486                	sd	ra,104(sp)
    80003b1e:	f0a2                	sd	s0,96(sp)
    80003b20:	e8ca                	sd	s2,80(sp)
    80003b22:	e0d2                	sd	s4,64(sp)
    80003b24:	fc56                	sd	s5,56(sp)
    80003b26:	f85a                	sd	s6,48(sp)
    80003b28:	f45e                	sd	s7,40(sp)
    80003b2a:	1880                	addi	s0,sp,112
    80003b2c:	8aaa                	mv	s5,a0
    80003b2e:	8bae                	mv	s7,a1
    80003b30:	8a32                	mv	s4,a2
    80003b32:	8936                	mv	s2,a3
    80003b34:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b36:	00e687bb          	addw	a5,a3,a4
    80003b3a:	0ed7e063          	bltu	a5,a3,80003c1a <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003b3e:	00043737          	lui	a4,0x43
    80003b42:	0cf76e63          	bltu	a4,a5,80003c1e <writei+0x10a>
    80003b46:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b48:	0a0b0f63          	beqz	s6,80003c06 <writei+0xf2>
    80003b4c:	eca6                	sd	s1,88(sp)
    80003b4e:	f062                	sd	s8,32(sp)
    80003b50:	ec66                	sd	s9,24(sp)
    80003b52:	e86a                	sd	s10,16(sp)
    80003b54:	e46e                	sd	s11,8(sp)
    80003b56:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b58:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003b5c:	5c7d                	li	s8,-1
    80003b5e:	a825                	j	80003b96 <writei+0x82>
    80003b60:	020d1d93          	slli	s11,s10,0x20
    80003b64:	020ddd93          	srli	s11,s11,0x20
    80003b68:	05848513          	addi	a0,s1,88
    80003b6c:	86ee                	mv	a3,s11
    80003b6e:	8652                	mv	a2,s4
    80003b70:	85de                	mv	a1,s7
    80003b72:	953a                	add	a0,a0,a4
    80003b74:	b6bfe0ef          	jal	800026de <either_copyin>
    80003b78:	05850a63          	beq	a0,s8,80003bcc <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003b7c:	8526                	mv	a0,s1
    80003b7e:	660000ef          	jal	800041de <log_write>
    brelse(bp);
    80003b82:	8526                	mv	a0,s1
    80003b84:	e10ff0ef          	jal	80003194 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b88:	013d09bb          	addw	s3,s10,s3
    80003b8c:	012d093b          	addw	s2,s10,s2
    80003b90:	9a6e                	add	s4,s4,s11
    80003b92:	0569f063          	bgeu	s3,s6,80003bd2 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003b96:	00a9559b          	srliw	a1,s2,0xa
    80003b9a:	8556                	mv	a0,s5
    80003b9c:	875ff0ef          	jal	80003410 <bmap>
    80003ba0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003ba4:	c59d                	beqz	a1,80003bd2 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003ba6:	000aa503          	lw	a0,0(s5)
    80003baa:	ce2ff0ef          	jal	8000308c <bread>
    80003bae:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bb0:	3ff97713          	andi	a4,s2,1023
    80003bb4:	40ec87bb          	subw	a5,s9,a4
    80003bb8:	413b06bb          	subw	a3,s6,s3
    80003bbc:	8d3e                	mv	s10,a5
    80003bbe:	2781                	sext.w	a5,a5
    80003bc0:	0006861b          	sext.w	a2,a3
    80003bc4:	f8f67ee3          	bgeu	a2,a5,80003b60 <writei+0x4c>
    80003bc8:	8d36                	mv	s10,a3
    80003bca:	bf59                	j	80003b60 <writei+0x4c>
      brelse(bp);
    80003bcc:	8526                	mv	a0,s1
    80003bce:	dc6ff0ef          	jal	80003194 <brelse>
  }

  if(off > ip->size)
    80003bd2:	04caa783          	lw	a5,76(s5)
    80003bd6:	0327fa63          	bgeu	a5,s2,80003c0a <writei+0xf6>
    ip->size = off;
    80003bda:	052aa623          	sw	s2,76(s5)
    80003bde:	64e6                	ld	s1,88(sp)
    80003be0:	7c02                	ld	s8,32(sp)
    80003be2:	6ce2                	ld	s9,24(sp)
    80003be4:	6d42                	ld	s10,16(sp)
    80003be6:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003be8:	8556                	mv	a0,s5
    80003bea:	b27ff0ef          	jal	80003710 <iupdate>

  return tot;
    80003bee:	0009851b          	sext.w	a0,s3
    80003bf2:	69a6                	ld	s3,72(sp)
}
    80003bf4:	70a6                	ld	ra,104(sp)
    80003bf6:	7406                	ld	s0,96(sp)
    80003bf8:	6946                	ld	s2,80(sp)
    80003bfa:	6a06                	ld	s4,64(sp)
    80003bfc:	7ae2                	ld	s5,56(sp)
    80003bfe:	7b42                	ld	s6,48(sp)
    80003c00:	7ba2                	ld	s7,40(sp)
    80003c02:	6165                	addi	sp,sp,112
    80003c04:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c06:	89da                	mv	s3,s6
    80003c08:	b7c5                	j	80003be8 <writei+0xd4>
    80003c0a:	64e6                	ld	s1,88(sp)
    80003c0c:	7c02                	ld	s8,32(sp)
    80003c0e:	6ce2                	ld	s9,24(sp)
    80003c10:	6d42                	ld	s10,16(sp)
    80003c12:	6da2                	ld	s11,8(sp)
    80003c14:	bfd1                	j	80003be8 <writei+0xd4>
    return -1;
    80003c16:	557d                	li	a0,-1
}
    80003c18:	8082                	ret
    return -1;
    80003c1a:	557d                	li	a0,-1
    80003c1c:	bfe1                	j	80003bf4 <writei+0xe0>
    return -1;
    80003c1e:	557d                	li	a0,-1
    80003c20:	bfd1                	j	80003bf4 <writei+0xe0>

0000000080003c22 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003c22:	1141                	addi	sp,sp,-16
    80003c24:	e406                	sd	ra,8(sp)
    80003c26:	e022                	sd	s0,0(sp)
    80003c28:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c2a:	4639                	li	a2,14
    80003c2c:	976fd0ef          	jal	80000da2 <strncmp>
}
    80003c30:	60a2                	ld	ra,8(sp)
    80003c32:	6402                	ld	s0,0(sp)
    80003c34:	0141                	addi	sp,sp,16
    80003c36:	8082                	ret

0000000080003c38 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c38:	7139                	addi	sp,sp,-64
    80003c3a:	fc06                	sd	ra,56(sp)
    80003c3c:	f822                	sd	s0,48(sp)
    80003c3e:	f426                	sd	s1,40(sp)
    80003c40:	f04a                	sd	s2,32(sp)
    80003c42:	ec4e                	sd	s3,24(sp)
    80003c44:	e852                	sd	s4,16(sp)
    80003c46:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003c48:	04451703          	lh	a4,68(a0)
    80003c4c:	4785                	li	a5,1
    80003c4e:	00f71a63          	bne	a4,a5,80003c62 <dirlookup+0x2a>
    80003c52:	892a                	mv	s2,a0
    80003c54:	89ae                	mv	s3,a1
    80003c56:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c58:	457c                	lw	a5,76(a0)
    80003c5a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003c5c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c5e:	e39d                	bnez	a5,80003c84 <dirlookup+0x4c>
    80003c60:	a095                	j	80003cc4 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003c62:	00004517          	auipc	a0,0x4
    80003c66:	8ce50513          	addi	a0,a0,-1842 # 80007530 <etext+0x530>
    80003c6a:	b39fc0ef          	jal	800007a2 <panic>
      panic("dirlookup read");
    80003c6e:	00004517          	auipc	a0,0x4
    80003c72:	8da50513          	addi	a0,a0,-1830 # 80007548 <etext+0x548>
    80003c76:	b2dfc0ef          	jal	800007a2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c7a:	24c1                	addiw	s1,s1,16
    80003c7c:	04c92783          	lw	a5,76(s2)
    80003c80:	04f4f163          	bgeu	s1,a5,80003cc2 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c84:	4741                	li	a4,16
    80003c86:	86a6                	mv	a3,s1
    80003c88:	fc040613          	addi	a2,s0,-64
    80003c8c:	4581                	li	a1,0
    80003c8e:	854a                	mv	a0,s2
    80003c90:	d89ff0ef          	jal	80003a18 <readi>
    80003c94:	47c1                	li	a5,16
    80003c96:	fcf51ce3          	bne	a0,a5,80003c6e <dirlookup+0x36>
    if(de.inum == 0)
    80003c9a:	fc045783          	lhu	a5,-64(s0)
    80003c9e:	dff1                	beqz	a5,80003c7a <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003ca0:	fc240593          	addi	a1,s0,-62
    80003ca4:	854e                	mv	a0,s3
    80003ca6:	f7dff0ef          	jal	80003c22 <namecmp>
    80003caa:	f961                	bnez	a0,80003c7a <dirlookup+0x42>
      if(poff)
    80003cac:	000a0463          	beqz	s4,80003cb4 <dirlookup+0x7c>
        *poff = off;
    80003cb0:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003cb4:	fc045583          	lhu	a1,-64(s0)
    80003cb8:	00092503          	lw	a0,0(s2)
    80003cbc:	829ff0ef          	jal	800034e4 <iget>
    80003cc0:	a011                	j	80003cc4 <dirlookup+0x8c>
  return 0;
    80003cc2:	4501                	li	a0,0
}
    80003cc4:	70e2                	ld	ra,56(sp)
    80003cc6:	7442                	ld	s0,48(sp)
    80003cc8:	74a2                	ld	s1,40(sp)
    80003cca:	7902                	ld	s2,32(sp)
    80003ccc:	69e2                	ld	s3,24(sp)
    80003cce:	6a42                	ld	s4,16(sp)
    80003cd0:	6121                	addi	sp,sp,64
    80003cd2:	8082                	ret

0000000080003cd4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003cd4:	711d                	addi	sp,sp,-96
    80003cd6:	ec86                	sd	ra,88(sp)
    80003cd8:	e8a2                	sd	s0,80(sp)
    80003cda:	e4a6                	sd	s1,72(sp)
    80003cdc:	e0ca                	sd	s2,64(sp)
    80003cde:	fc4e                	sd	s3,56(sp)
    80003ce0:	f852                	sd	s4,48(sp)
    80003ce2:	f456                	sd	s5,40(sp)
    80003ce4:	f05a                	sd	s6,32(sp)
    80003ce6:	ec5e                	sd	s7,24(sp)
    80003ce8:	e862                	sd	s8,16(sp)
    80003cea:	e466                	sd	s9,8(sp)
    80003cec:	1080                	addi	s0,sp,96
    80003cee:	84aa                	mv	s1,a0
    80003cf0:	8b2e                	mv	s6,a1
    80003cf2:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003cf4:	00054703          	lbu	a4,0(a0)
    80003cf8:	02f00793          	li	a5,47
    80003cfc:	00f70e63          	beq	a4,a5,80003d18 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003d00:	c13fd0ef          	jal	80001912 <myproc>
    80003d04:	15053503          	ld	a0,336(a0)
    80003d08:	a87ff0ef          	jal	8000378e <idup>
    80003d0c:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003d0e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003d12:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d14:	4b85                	li	s7,1
    80003d16:	a871                	j	80003db2 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003d18:	4585                	li	a1,1
    80003d1a:	4505                	li	a0,1
    80003d1c:	fc8ff0ef          	jal	800034e4 <iget>
    80003d20:	8a2a                	mv	s4,a0
    80003d22:	b7f5                	j	80003d0e <namex+0x3a>
      iunlockput(ip);
    80003d24:	8552                	mv	a0,s4
    80003d26:	ca9ff0ef          	jal	800039ce <iunlockput>
      return 0;
    80003d2a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d2c:	8552                	mv	a0,s4
    80003d2e:	60e6                	ld	ra,88(sp)
    80003d30:	6446                	ld	s0,80(sp)
    80003d32:	64a6                	ld	s1,72(sp)
    80003d34:	6906                	ld	s2,64(sp)
    80003d36:	79e2                	ld	s3,56(sp)
    80003d38:	7a42                	ld	s4,48(sp)
    80003d3a:	7aa2                	ld	s5,40(sp)
    80003d3c:	7b02                	ld	s6,32(sp)
    80003d3e:	6be2                	ld	s7,24(sp)
    80003d40:	6c42                	ld	s8,16(sp)
    80003d42:	6ca2                	ld	s9,8(sp)
    80003d44:	6125                	addi	sp,sp,96
    80003d46:	8082                	ret
      iunlock(ip);
    80003d48:	8552                	mv	a0,s4
    80003d4a:	b29ff0ef          	jal	80003872 <iunlock>
      return ip;
    80003d4e:	bff9                	j	80003d2c <namex+0x58>
      iunlockput(ip);
    80003d50:	8552                	mv	a0,s4
    80003d52:	c7dff0ef          	jal	800039ce <iunlockput>
      return 0;
    80003d56:	8a4e                	mv	s4,s3
    80003d58:	bfd1                	j	80003d2c <namex+0x58>
  len = path - s;
    80003d5a:	40998633          	sub	a2,s3,s1
    80003d5e:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003d62:	099c5063          	bge	s8,s9,80003de2 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003d66:	4639                	li	a2,14
    80003d68:	85a6                	mv	a1,s1
    80003d6a:	8556                	mv	a0,s5
    80003d6c:	fc7fc0ef          	jal	80000d32 <memmove>
    80003d70:	84ce                	mv	s1,s3
  while(*path == '/')
    80003d72:	0004c783          	lbu	a5,0(s1)
    80003d76:	01279763          	bne	a5,s2,80003d84 <namex+0xb0>
    path++;
    80003d7a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003d7c:	0004c783          	lbu	a5,0(s1)
    80003d80:	ff278de3          	beq	a5,s2,80003d7a <namex+0xa6>
    ilock(ip);
    80003d84:	8552                	mv	a0,s4
    80003d86:	a3fff0ef          	jal	800037c4 <ilock>
    if(ip->type != T_DIR){
    80003d8a:	044a1783          	lh	a5,68(s4)
    80003d8e:	f9779be3          	bne	a5,s7,80003d24 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003d92:	000b0563          	beqz	s6,80003d9c <namex+0xc8>
    80003d96:	0004c783          	lbu	a5,0(s1)
    80003d9a:	d7dd                	beqz	a5,80003d48 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003d9c:	4601                	li	a2,0
    80003d9e:	85d6                	mv	a1,s5
    80003da0:	8552                	mv	a0,s4
    80003da2:	e97ff0ef          	jal	80003c38 <dirlookup>
    80003da6:	89aa                	mv	s3,a0
    80003da8:	d545                	beqz	a0,80003d50 <namex+0x7c>
    iunlockput(ip);
    80003daa:	8552                	mv	a0,s4
    80003dac:	c23ff0ef          	jal	800039ce <iunlockput>
    ip = next;
    80003db0:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003db2:	0004c783          	lbu	a5,0(s1)
    80003db6:	01279763          	bne	a5,s2,80003dc4 <namex+0xf0>
    path++;
    80003dba:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003dbc:	0004c783          	lbu	a5,0(s1)
    80003dc0:	ff278de3          	beq	a5,s2,80003dba <namex+0xe6>
  if(*path == 0)
    80003dc4:	cb8d                	beqz	a5,80003df6 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003dc6:	0004c783          	lbu	a5,0(s1)
    80003dca:	89a6                	mv	s3,s1
  len = path - s;
    80003dcc:	4c81                	li	s9,0
    80003dce:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003dd0:	01278963          	beq	a5,s2,80003de2 <namex+0x10e>
    80003dd4:	d3d9                	beqz	a5,80003d5a <namex+0x86>
    path++;
    80003dd6:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003dd8:	0009c783          	lbu	a5,0(s3)
    80003ddc:	ff279ce3          	bne	a5,s2,80003dd4 <namex+0x100>
    80003de0:	bfad                	j	80003d5a <namex+0x86>
    memmove(name, s, len);
    80003de2:	2601                	sext.w	a2,a2
    80003de4:	85a6                	mv	a1,s1
    80003de6:	8556                	mv	a0,s5
    80003de8:	f4bfc0ef          	jal	80000d32 <memmove>
    name[len] = 0;
    80003dec:	9cd6                	add	s9,s9,s5
    80003dee:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003df2:	84ce                	mv	s1,s3
    80003df4:	bfbd                	j	80003d72 <namex+0x9e>
  if(nameiparent){
    80003df6:	f20b0be3          	beqz	s6,80003d2c <namex+0x58>
    iput(ip);
    80003dfa:	8552                	mv	a0,s4
    80003dfc:	b4bff0ef          	jal	80003946 <iput>
    return 0;
    80003e00:	4a01                	li	s4,0
    80003e02:	b72d                	j	80003d2c <namex+0x58>

0000000080003e04 <dirlink>:
{
    80003e04:	7139                	addi	sp,sp,-64
    80003e06:	fc06                	sd	ra,56(sp)
    80003e08:	f822                	sd	s0,48(sp)
    80003e0a:	f04a                	sd	s2,32(sp)
    80003e0c:	ec4e                	sd	s3,24(sp)
    80003e0e:	e852                	sd	s4,16(sp)
    80003e10:	0080                	addi	s0,sp,64
    80003e12:	892a                	mv	s2,a0
    80003e14:	8a2e                	mv	s4,a1
    80003e16:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e18:	4601                	li	a2,0
    80003e1a:	e1fff0ef          	jal	80003c38 <dirlookup>
    80003e1e:	e535                	bnez	a0,80003e8a <dirlink+0x86>
    80003e20:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e22:	04c92483          	lw	s1,76(s2)
    80003e26:	c48d                	beqz	s1,80003e50 <dirlink+0x4c>
    80003e28:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e2a:	4741                	li	a4,16
    80003e2c:	86a6                	mv	a3,s1
    80003e2e:	fc040613          	addi	a2,s0,-64
    80003e32:	4581                	li	a1,0
    80003e34:	854a                	mv	a0,s2
    80003e36:	be3ff0ef          	jal	80003a18 <readi>
    80003e3a:	47c1                	li	a5,16
    80003e3c:	04f51b63          	bne	a0,a5,80003e92 <dirlink+0x8e>
    if(de.inum == 0)
    80003e40:	fc045783          	lhu	a5,-64(s0)
    80003e44:	c791                	beqz	a5,80003e50 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e46:	24c1                	addiw	s1,s1,16
    80003e48:	04c92783          	lw	a5,76(s2)
    80003e4c:	fcf4efe3          	bltu	s1,a5,80003e2a <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003e50:	4639                	li	a2,14
    80003e52:	85d2                	mv	a1,s4
    80003e54:	fc240513          	addi	a0,s0,-62
    80003e58:	f81fc0ef          	jal	80000dd8 <strncpy>
  de.inum = inum;
    80003e5c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e60:	4741                	li	a4,16
    80003e62:	86a6                	mv	a3,s1
    80003e64:	fc040613          	addi	a2,s0,-64
    80003e68:	4581                	li	a1,0
    80003e6a:	854a                	mv	a0,s2
    80003e6c:	ca9ff0ef          	jal	80003b14 <writei>
    80003e70:	1541                	addi	a0,a0,-16
    80003e72:	00a03533          	snez	a0,a0
    80003e76:	40a00533          	neg	a0,a0
    80003e7a:	74a2                	ld	s1,40(sp)
}
    80003e7c:	70e2                	ld	ra,56(sp)
    80003e7e:	7442                	ld	s0,48(sp)
    80003e80:	7902                	ld	s2,32(sp)
    80003e82:	69e2                	ld	s3,24(sp)
    80003e84:	6a42                	ld	s4,16(sp)
    80003e86:	6121                	addi	sp,sp,64
    80003e88:	8082                	ret
    iput(ip);
    80003e8a:	abdff0ef          	jal	80003946 <iput>
    return -1;
    80003e8e:	557d                	li	a0,-1
    80003e90:	b7f5                	j	80003e7c <dirlink+0x78>
      panic("dirlink read");
    80003e92:	00003517          	auipc	a0,0x3
    80003e96:	6c650513          	addi	a0,a0,1734 # 80007558 <etext+0x558>
    80003e9a:	909fc0ef          	jal	800007a2 <panic>

0000000080003e9e <namei>:

struct inode*
namei(char *path)
{
    80003e9e:	1101                	addi	sp,sp,-32
    80003ea0:	ec06                	sd	ra,24(sp)
    80003ea2:	e822                	sd	s0,16(sp)
    80003ea4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003ea6:	fe040613          	addi	a2,s0,-32
    80003eaa:	4581                	li	a1,0
    80003eac:	e29ff0ef          	jal	80003cd4 <namex>
}
    80003eb0:	60e2                	ld	ra,24(sp)
    80003eb2:	6442                	ld	s0,16(sp)
    80003eb4:	6105                	addi	sp,sp,32
    80003eb6:	8082                	ret

0000000080003eb8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003eb8:	1141                	addi	sp,sp,-16
    80003eba:	e406                	sd	ra,8(sp)
    80003ebc:	e022                	sd	s0,0(sp)
    80003ebe:	0800                	addi	s0,sp,16
    80003ec0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003ec2:	4585                	li	a1,1
    80003ec4:	e11ff0ef          	jal	80003cd4 <namex>
}
    80003ec8:	60a2                	ld	ra,8(sp)
    80003eca:	6402                	ld	s0,0(sp)
    80003ecc:	0141                	addi	sp,sp,16
    80003ece:	8082                	ret

0000000080003ed0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003ed0:	1101                	addi	sp,sp,-32
    80003ed2:	ec06                	sd	ra,24(sp)
    80003ed4:	e822                	sd	s0,16(sp)
    80003ed6:	e426                	sd	s1,8(sp)
    80003ed8:	e04a                	sd	s2,0(sp)
    80003eda:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003edc:	0001f917          	auipc	s2,0x1f
    80003ee0:	d9490913          	addi	s2,s2,-620 # 80022c70 <log>
    80003ee4:	01892583          	lw	a1,24(s2)
    80003ee8:	02892503          	lw	a0,40(s2)
    80003eec:	9a0ff0ef          	jal	8000308c <bread>
    80003ef0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003ef2:	02c92603          	lw	a2,44(s2)
    80003ef6:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003ef8:	00c05f63          	blez	a2,80003f16 <write_head+0x46>
    80003efc:	0001f717          	auipc	a4,0x1f
    80003f00:	da470713          	addi	a4,a4,-604 # 80022ca0 <log+0x30>
    80003f04:	87aa                	mv	a5,a0
    80003f06:	060a                	slli	a2,a2,0x2
    80003f08:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003f0a:	4314                	lw	a3,0(a4)
    80003f0c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003f0e:	0711                	addi	a4,a4,4
    80003f10:	0791                	addi	a5,a5,4
    80003f12:	fec79ce3          	bne	a5,a2,80003f0a <write_head+0x3a>
  }
  bwrite(buf);
    80003f16:	8526                	mv	a0,s1
    80003f18:	a4aff0ef          	jal	80003162 <bwrite>
  brelse(buf);
    80003f1c:	8526                	mv	a0,s1
    80003f1e:	a76ff0ef          	jal	80003194 <brelse>
}
    80003f22:	60e2                	ld	ra,24(sp)
    80003f24:	6442                	ld	s0,16(sp)
    80003f26:	64a2                	ld	s1,8(sp)
    80003f28:	6902                	ld	s2,0(sp)
    80003f2a:	6105                	addi	sp,sp,32
    80003f2c:	8082                	ret

0000000080003f2e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f2e:	0001f797          	auipc	a5,0x1f
    80003f32:	d6e7a783          	lw	a5,-658(a5) # 80022c9c <log+0x2c>
    80003f36:	08f05f63          	blez	a5,80003fd4 <install_trans+0xa6>
{
    80003f3a:	7139                	addi	sp,sp,-64
    80003f3c:	fc06                	sd	ra,56(sp)
    80003f3e:	f822                	sd	s0,48(sp)
    80003f40:	f426                	sd	s1,40(sp)
    80003f42:	f04a                	sd	s2,32(sp)
    80003f44:	ec4e                	sd	s3,24(sp)
    80003f46:	e852                	sd	s4,16(sp)
    80003f48:	e456                	sd	s5,8(sp)
    80003f4a:	e05a                	sd	s6,0(sp)
    80003f4c:	0080                	addi	s0,sp,64
    80003f4e:	8b2a                	mv	s6,a0
    80003f50:	0001fa97          	auipc	s5,0x1f
    80003f54:	d50a8a93          	addi	s5,s5,-688 # 80022ca0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f58:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003f5a:	0001f997          	auipc	s3,0x1f
    80003f5e:	d1698993          	addi	s3,s3,-746 # 80022c70 <log>
    80003f62:	a829                	j	80003f7c <install_trans+0x4e>
    brelse(lbuf);
    80003f64:	854a                	mv	a0,s2
    80003f66:	a2eff0ef          	jal	80003194 <brelse>
    brelse(dbuf);
    80003f6a:	8526                	mv	a0,s1
    80003f6c:	a28ff0ef          	jal	80003194 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f70:	2a05                	addiw	s4,s4,1
    80003f72:	0a91                	addi	s5,s5,4
    80003f74:	02c9a783          	lw	a5,44(s3)
    80003f78:	04fa5463          	bge	s4,a5,80003fc0 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003f7c:	0189a583          	lw	a1,24(s3)
    80003f80:	014585bb          	addw	a1,a1,s4
    80003f84:	2585                	addiw	a1,a1,1
    80003f86:	0289a503          	lw	a0,40(s3)
    80003f8a:	902ff0ef          	jal	8000308c <bread>
    80003f8e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003f90:	000aa583          	lw	a1,0(s5)
    80003f94:	0289a503          	lw	a0,40(s3)
    80003f98:	8f4ff0ef          	jal	8000308c <bread>
    80003f9c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003f9e:	40000613          	li	a2,1024
    80003fa2:	05890593          	addi	a1,s2,88
    80003fa6:	05850513          	addi	a0,a0,88
    80003faa:	d89fc0ef          	jal	80000d32 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003fae:	8526                	mv	a0,s1
    80003fb0:	9b2ff0ef          	jal	80003162 <bwrite>
    if(recovering == 0)
    80003fb4:	fa0b18e3          	bnez	s6,80003f64 <install_trans+0x36>
      bunpin(dbuf);
    80003fb8:	8526                	mv	a0,s1
    80003fba:	a96ff0ef          	jal	80003250 <bunpin>
    80003fbe:	b75d                	j	80003f64 <install_trans+0x36>
}
    80003fc0:	70e2                	ld	ra,56(sp)
    80003fc2:	7442                	ld	s0,48(sp)
    80003fc4:	74a2                	ld	s1,40(sp)
    80003fc6:	7902                	ld	s2,32(sp)
    80003fc8:	69e2                	ld	s3,24(sp)
    80003fca:	6a42                	ld	s4,16(sp)
    80003fcc:	6aa2                	ld	s5,8(sp)
    80003fce:	6b02                	ld	s6,0(sp)
    80003fd0:	6121                	addi	sp,sp,64
    80003fd2:	8082                	ret
    80003fd4:	8082                	ret

0000000080003fd6 <initlog>:
{
    80003fd6:	7179                	addi	sp,sp,-48
    80003fd8:	f406                	sd	ra,40(sp)
    80003fda:	f022                	sd	s0,32(sp)
    80003fdc:	ec26                	sd	s1,24(sp)
    80003fde:	e84a                	sd	s2,16(sp)
    80003fe0:	e44e                	sd	s3,8(sp)
    80003fe2:	1800                	addi	s0,sp,48
    80003fe4:	892a                	mv	s2,a0
    80003fe6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003fe8:	0001f497          	auipc	s1,0x1f
    80003fec:	c8848493          	addi	s1,s1,-888 # 80022c70 <log>
    80003ff0:	00003597          	auipc	a1,0x3
    80003ff4:	57858593          	addi	a1,a1,1400 # 80007568 <etext+0x568>
    80003ff8:	8526                	mv	a0,s1
    80003ffa:	b89fc0ef          	jal	80000b82 <initlock>
  log.start = sb->logstart;
    80003ffe:	0149a583          	lw	a1,20(s3)
    80004002:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004004:	0109a783          	lw	a5,16(s3)
    80004008:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000400a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000400e:	854a                	mv	a0,s2
    80004010:	87cff0ef          	jal	8000308c <bread>
  log.lh.n = lh->n;
    80004014:	4d30                	lw	a2,88(a0)
    80004016:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004018:	00c05f63          	blez	a2,80004036 <initlog+0x60>
    8000401c:	87aa                	mv	a5,a0
    8000401e:	0001f717          	auipc	a4,0x1f
    80004022:	c8270713          	addi	a4,a4,-894 # 80022ca0 <log+0x30>
    80004026:	060a                	slli	a2,a2,0x2
    80004028:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000402a:	4ff4                	lw	a3,92(a5)
    8000402c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000402e:	0791                	addi	a5,a5,4
    80004030:	0711                	addi	a4,a4,4
    80004032:	fec79ce3          	bne	a5,a2,8000402a <initlog+0x54>
  brelse(buf);
    80004036:	95eff0ef          	jal	80003194 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000403a:	4505                	li	a0,1
    8000403c:	ef3ff0ef          	jal	80003f2e <install_trans>
  log.lh.n = 0;
    80004040:	0001f797          	auipc	a5,0x1f
    80004044:	c407ae23          	sw	zero,-932(a5) # 80022c9c <log+0x2c>
  write_head(); // clear the log
    80004048:	e89ff0ef          	jal	80003ed0 <write_head>
}
    8000404c:	70a2                	ld	ra,40(sp)
    8000404e:	7402                	ld	s0,32(sp)
    80004050:	64e2                	ld	s1,24(sp)
    80004052:	6942                	ld	s2,16(sp)
    80004054:	69a2                	ld	s3,8(sp)
    80004056:	6145                	addi	sp,sp,48
    80004058:	8082                	ret

000000008000405a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000405a:	1101                	addi	sp,sp,-32
    8000405c:	ec06                	sd	ra,24(sp)
    8000405e:	e822                	sd	s0,16(sp)
    80004060:	e426                	sd	s1,8(sp)
    80004062:	e04a                	sd	s2,0(sp)
    80004064:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004066:	0001f517          	auipc	a0,0x1f
    8000406a:	c0a50513          	addi	a0,a0,-1014 # 80022c70 <log>
    8000406e:	b95fc0ef          	jal	80000c02 <acquire>
  while(1){
    if(log.committing){
    80004072:	0001f497          	auipc	s1,0x1f
    80004076:	bfe48493          	addi	s1,s1,-1026 # 80022c70 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000407a:	4979                	li	s2,30
    8000407c:	a029                	j	80004086 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000407e:	85a6                	mv	a1,s1
    80004080:	8526                	mv	a0,s1
    80004082:	940fe0ef          	jal	800021c2 <sleep>
    if(log.committing){
    80004086:	50dc                	lw	a5,36(s1)
    80004088:	fbfd                	bnez	a5,8000407e <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000408a:	5098                	lw	a4,32(s1)
    8000408c:	2705                	addiw	a4,a4,1
    8000408e:	0027179b          	slliw	a5,a4,0x2
    80004092:	9fb9                	addw	a5,a5,a4
    80004094:	0017979b          	slliw	a5,a5,0x1
    80004098:	54d4                	lw	a3,44(s1)
    8000409a:	9fb5                	addw	a5,a5,a3
    8000409c:	00f95763          	bge	s2,a5,800040aa <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800040a0:	85a6                	mv	a1,s1
    800040a2:	8526                	mv	a0,s1
    800040a4:	91efe0ef          	jal	800021c2 <sleep>
    800040a8:	bff9                	j	80004086 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800040aa:	0001f517          	auipc	a0,0x1f
    800040ae:	bc650513          	addi	a0,a0,-1082 # 80022c70 <log>
    800040b2:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800040b4:	be7fc0ef          	jal	80000c9a <release>
      break;
    }
  }
}
    800040b8:	60e2                	ld	ra,24(sp)
    800040ba:	6442                	ld	s0,16(sp)
    800040bc:	64a2                	ld	s1,8(sp)
    800040be:	6902                	ld	s2,0(sp)
    800040c0:	6105                	addi	sp,sp,32
    800040c2:	8082                	ret

00000000800040c4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800040c4:	7139                	addi	sp,sp,-64
    800040c6:	fc06                	sd	ra,56(sp)
    800040c8:	f822                	sd	s0,48(sp)
    800040ca:	f426                	sd	s1,40(sp)
    800040cc:	f04a                	sd	s2,32(sp)
    800040ce:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800040d0:	0001f497          	auipc	s1,0x1f
    800040d4:	ba048493          	addi	s1,s1,-1120 # 80022c70 <log>
    800040d8:	8526                	mv	a0,s1
    800040da:	b29fc0ef          	jal	80000c02 <acquire>
  log.outstanding -= 1;
    800040de:	509c                	lw	a5,32(s1)
    800040e0:	37fd                	addiw	a5,a5,-1
    800040e2:	0007891b          	sext.w	s2,a5
    800040e6:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800040e8:	50dc                	lw	a5,36(s1)
    800040ea:	ef9d                	bnez	a5,80004128 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    800040ec:	04091763          	bnez	s2,8000413a <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    800040f0:	0001f497          	auipc	s1,0x1f
    800040f4:	b8048493          	addi	s1,s1,-1152 # 80022c70 <log>
    800040f8:	4785                	li	a5,1
    800040fa:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800040fc:	8526                	mv	a0,s1
    800040fe:	b9dfc0ef          	jal	80000c9a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004102:	54dc                	lw	a5,44(s1)
    80004104:	04f04b63          	bgtz	a5,8000415a <end_op+0x96>
    acquire(&log.lock);
    80004108:	0001f497          	auipc	s1,0x1f
    8000410c:	b6848493          	addi	s1,s1,-1176 # 80022c70 <log>
    80004110:	8526                	mv	a0,s1
    80004112:	af1fc0ef          	jal	80000c02 <acquire>
    log.committing = 0;
    80004116:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000411a:	8526                	mv	a0,s1
    8000411c:	a52fe0ef          	jal	8000236e <wakeup>
    release(&log.lock);
    80004120:	8526                	mv	a0,s1
    80004122:	b79fc0ef          	jal	80000c9a <release>
}
    80004126:	a025                	j	8000414e <end_op+0x8a>
    80004128:	ec4e                	sd	s3,24(sp)
    8000412a:	e852                	sd	s4,16(sp)
    8000412c:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000412e:	00003517          	auipc	a0,0x3
    80004132:	44250513          	addi	a0,a0,1090 # 80007570 <etext+0x570>
    80004136:	e6cfc0ef          	jal	800007a2 <panic>
    wakeup(&log);
    8000413a:	0001f497          	auipc	s1,0x1f
    8000413e:	b3648493          	addi	s1,s1,-1226 # 80022c70 <log>
    80004142:	8526                	mv	a0,s1
    80004144:	a2afe0ef          	jal	8000236e <wakeup>
  release(&log.lock);
    80004148:	8526                	mv	a0,s1
    8000414a:	b51fc0ef          	jal	80000c9a <release>
}
    8000414e:	70e2                	ld	ra,56(sp)
    80004150:	7442                	ld	s0,48(sp)
    80004152:	74a2                	ld	s1,40(sp)
    80004154:	7902                	ld	s2,32(sp)
    80004156:	6121                	addi	sp,sp,64
    80004158:	8082                	ret
    8000415a:	ec4e                	sd	s3,24(sp)
    8000415c:	e852                	sd	s4,16(sp)
    8000415e:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004160:	0001fa97          	auipc	s5,0x1f
    80004164:	b40a8a93          	addi	s5,s5,-1216 # 80022ca0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004168:	0001fa17          	auipc	s4,0x1f
    8000416c:	b08a0a13          	addi	s4,s4,-1272 # 80022c70 <log>
    80004170:	018a2583          	lw	a1,24(s4)
    80004174:	012585bb          	addw	a1,a1,s2
    80004178:	2585                	addiw	a1,a1,1
    8000417a:	028a2503          	lw	a0,40(s4)
    8000417e:	f0ffe0ef          	jal	8000308c <bread>
    80004182:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004184:	000aa583          	lw	a1,0(s5)
    80004188:	028a2503          	lw	a0,40(s4)
    8000418c:	f01fe0ef          	jal	8000308c <bread>
    80004190:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004192:	40000613          	li	a2,1024
    80004196:	05850593          	addi	a1,a0,88
    8000419a:	05848513          	addi	a0,s1,88
    8000419e:	b95fc0ef          	jal	80000d32 <memmove>
    bwrite(to);  // write the log
    800041a2:	8526                	mv	a0,s1
    800041a4:	fbffe0ef          	jal	80003162 <bwrite>
    brelse(from);
    800041a8:	854e                	mv	a0,s3
    800041aa:	febfe0ef          	jal	80003194 <brelse>
    brelse(to);
    800041ae:	8526                	mv	a0,s1
    800041b0:	fe5fe0ef          	jal	80003194 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800041b4:	2905                	addiw	s2,s2,1
    800041b6:	0a91                	addi	s5,s5,4
    800041b8:	02ca2783          	lw	a5,44(s4)
    800041bc:	faf94ae3          	blt	s2,a5,80004170 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800041c0:	d11ff0ef          	jal	80003ed0 <write_head>
    install_trans(0); // Now install writes to home locations
    800041c4:	4501                	li	a0,0
    800041c6:	d69ff0ef          	jal	80003f2e <install_trans>
    log.lh.n = 0;
    800041ca:	0001f797          	auipc	a5,0x1f
    800041ce:	ac07a923          	sw	zero,-1326(a5) # 80022c9c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800041d2:	cffff0ef          	jal	80003ed0 <write_head>
    800041d6:	69e2                	ld	s3,24(sp)
    800041d8:	6a42                	ld	s4,16(sp)
    800041da:	6aa2                	ld	s5,8(sp)
    800041dc:	b735                	j	80004108 <end_op+0x44>

00000000800041de <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800041de:	1101                	addi	sp,sp,-32
    800041e0:	ec06                	sd	ra,24(sp)
    800041e2:	e822                	sd	s0,16(sp)
    800041e4:	e426                	sd	s1,8(sp)
    800041e6:	e04a                	sd	s2,0(sp)
    800041e8:	1000                	addi	s0,sp,32
    800041ea:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800041ec:	0001f917          	auipc	s2,0x1f
    800041f0:	a8490913          	addi	s2,s2,-1404 # 80022c70 <log>
    800041f4:	854a                	mv	a0,s2
    800041f6:	a0dfc0ef          	jal	80000c02 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800041fa:	02c92603          	lw	a2,44(s2)
    800041fe:	47f5                	li	a5,29
    80004200:	06c7c363          	blt	a5,a2,80004266 <log_write+0x88>
    80004204:	0001f797          	auipc	a5,0x1f
    80004208:	a887a783          	lw	a5,-1400(a5) # 80022c8c <log+0x1c>
    8000420c:	37fd                	addiw	a5,a5,-1
    8000420e:	04f65c63          	bge	a2,a5,80004266 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004212:	0001f797          	auipc	a5,0x1f
    80004216:	a7e7a783          	lw	a5,-1410(a5) # 80022c90 <log+0x20>
    8000421a:	04f05c63          	blez	a5,80004272 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000421e:	4781                	li	a5,0
    80004220:	04c05f63          	blez	a2,8000427e <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004224:	44cc                	lw	a1,12(s1)
    80004226:	0001f717          	auipc	a4,0x1f
    8000422a:	a7a70713          	addi	a4,a4,-1414 # 80022ca0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000422e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004230:	4314                	lw	a3,0(a4)
    80004232:	04b68663          	beq	a3,a1,8000427e <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80004236:	2785                	addiw	a5,a5,1
    80004238:	0711                	addi	a4,a4,4
    8000423a:	fef61be3          	bne	a2,a5,80004230 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000423e:	0621                	addi	a2,a2,8
    80004240:	060a                	slli	a2,a2,0x2
    80004242:	0001f797          	auipc	a5,0x1f
    80004246:	a2e78793          	addi	a5,a5,-1490 # 80022c70 <log>
    8000424a:	97b2                	add	a5,a5,a2
    8000424c:	44d8                	lw	a4,12(s1)
    8000424e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004250:	8526                	mv	a0,s1
    80004252:	fcbfe0ef          	jal	8000321c <bpin>
    log.lh.n++;
    80004256:	0001f717          	auipc	a4,0x1f
    8000425a:	a1a70713          	addi	a4,a4,-1510 # 80022c70 <log>
    8000425e:	575c                	lw	a5,44(a4)
    80004260:	2785                	addiw	a5,a5,1
    80004262:	d75c                	sw	a5,44(a4)
    80004264:	a80d                	j	80004296 <log_write+0xb8>
    panic("too big a transaction");
    80004266:	00003517          	auipc	a0,0x3
    8000426a:	31a50513          	addi	a0,a0,794 # 80007580 <etext+0x580>
    8000426e:	d34fc0ef          	jal	800007a2 <panic>
    panic("log_write outside of trans");
    80004272:	00003517          	auipc	a0,0x3
    80004276:	32650513          	addi	a0,a0,806 # 80007598 <etext+0x598>
    8000427a:	d28fc0ef          	jal	800007a2 <panic>
  log.lh.block[i] = b->blockno;
    8000427e:	00878693          	addi	a3,a5,8
    80004282:	068a                	slli	a3,a3,0x2
    80004284:	0001f717          	auipc	a4,0x1f
    80004288:	9ec70713          	addi	a4,a4,-1556 # 80022c70 <log>
    8000428c:	9736                	add	a4,a4,a3
    8000428e:	44d4                	lw	a3,12(s1)
    80004290:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004292:	faf60fe3          	beq	a2,a5,80004250 <log_write+0x72>
  }
  release(&log.lock);
    80004296:	0001f517          	auipc	a0,0x1f
    8000429a:	9da50513          	addi	a0,a0,-1574 # 80022c70 <log>
    8000429e:	9fdfc0ef          	jal	80000c9a <release>
}
    800042a2:	60e2                	ld	ra,24(sp)
    800042a4:	6442                	ld	s0,16(sp)
    800042a6:	64a2                	ld	s1,8(sp)
    800042a8:	6902                	ld	s2,0(sp)
    800042aa:	6105                	addi	sp,sp,32
    800042ac:	8082                	ret

00000000800042ae <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800042ae:	1101                	addi	sp,sp,-32
    800042b0:	ec06                	sd	ra,24(sp)
    800042b2:	e822                	sd	s0,16(sp)
    800042b4:	e426                	sd	s1,8(sp)
    800042b6:	e04a                	sd	s2,0(sp)
    800042b8:	1000                	addi	s0,sp,32
    800042ba:	84aa                	mv	s1,a0
    800042bc:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800042be:	00003597          	auipc	a1,0x3
    800042c2:	2fa58593          	addi	a1,a1,762 # 800075b8 <etext+0x5b8>
    800042c6:	0521                	addi	a0,a0,8
    800042c8:	8bbfc0ef          	jal	80000b82 <initlock>
  lk->name = name;
    800042cc:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800042d0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800042d4:	0204a423          	sw	zero,40(s1)
}
    800042d8:	60e2                	ld	ra,24(sp)
    800042da:	6442                	ld	s0,16(sp)
    800042dc:	64a2                	ld	s1,8(sp)
    800042de:	6902                	ld	s2,0(sp)
    800042e0:	6105                	addi	sp,sp,32
    800042e2:	8082                	ret

00000000800042e4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800042e4:	1101                	addi	sp,sp,-32
    800042e6:	ec06                	sd	ra,24(sp)
    800042e8:	e822                	sd	s0,16(sp)
    800042ea:	e426                	sd	s1,8(sp)
    800042ec:	e04a                	sd	s2,0(sp)
    800042ee:	1000                	addi	s0,sp,32
    800042f0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800042f2:	00850913          	addi	s2,a0,8
    800042f6:	854a                	mv	a0,s2
    800042f8:	90bfc0ef          	jal	80000c02 <acquire>
  while (lk->locked) {
    800042fc:	409c                	lw	a5,0(s1)
    800042fe:	c799                	beqz	a5,8000430c <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004300:	85ca                	mv	a1,s2
    80004302:	8526                	mv	a0,s1
    80004304:	ebffd0ef          	jal	800021c2 <sleep>
  while (lk->locked) {
    80004308:	409c                	lw	a5,0(s1)
    8000430a:	fbfd                	bnez	a5,80004300 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000430c:	4785                	li	a5,1
    8000430e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004310:	e02fd0ef          	jal	80001912 <myproc>
    80004314:	591c                	lw	a5,48(a0)
    80004316:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004318:	854a                	mv	a0,s2
    8000431a:	981fc0ef          	jal	80000c9a <release>
}
    8000431e:	60e2                	ld	ra,24(sp)
    80004320:	6442                	ld	s0,16(sp)
    80004322:	64a2                	ld	s1,8(sp)
    80004324:	6902                	ld	s2,0(sp)
    80004326:	6105                	addi	sp,sp,32
    80004328:	8082                	ret

000000008000432a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000432a:	1101                	addi	sp,sp,-32
    8000432c:	ec06                	sd	ra,24(sp)
    8000432e:	e822                	sd	s0,16(sp)
    80004330:	e426                	sd	s1,8(sp)
    80004332:	e04a                	sd	s2,0(sp)
    80004334:	1000                	addi	s0,sp,32
    80004336:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004338:	00850913          	addi	s2,a0,8
    8000433c:	854a                	mv	a0,s2
    8000433e:	8c5fc0ef          	jal	80000c02 <acquire>
  lk->locked = 0;
    80004342:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004346:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000434a:	8526                	mv	a0,s1
    8000434c:	822fe0ef          	jal	8000236e <wakeup>
  release(&lk->lk);
    80004350:	854a                	mv	a0,s2
    80004352:	949fc0ef          	jal	80000c9a <release>
}
    80004356:	60e2                	ld	ra,24(sp)
    80004358:	6442                	ld	s0,16(sp)
    8000435a:	64a2                	ld	s1,8(sp)
    8000435c:	6902                	ld	s2,0(sp)
    8000435e:	6105                	addi	sp,sp,32
    80004360:	8082                	ret

0000000080004362 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004362:	7179                	addi	sp,sp,-48
    80004364:	f406                	sd	ra,40(sp)
    80004366:	f022                	sd	s0,32(sp)
    80004368:	ec26                	sd	s1,24(sp)
    8000436a:	e84a                	sd	s2,16(sp)
    8000436c:	1800                	addi	s0,sp,48
    8000436e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004370:	00850913          	addi	s2,a0,8
    80004374:	854a                	mv	a0,s2
    80004376:	88dfc0ef          	jal	80000c02 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000437a:	409c                	lw	a5,0(s1)
    8000437c:	ef81                	bnez	a5,80004394 <holdingsleep+0x32>
    8000437e:	4481                	li	s1,0
  release(&lk->lk);
    80004380:	854a                	mv	a0,s2
    80004382:	919fc0ef          	jal	80000c9a <release>
  return r;
}
    80004386:	8526                	mv	a0,s1
    80004388:	70a2                	ld	ra,40(sp)
    8000438a:	7402                	ld	s0,32(sp)
    8000438c:	64e2                	ld	s1,24(sp)
    8000438e:	6942                	ld	s2,16(sp)
    80004390:	6145                	addi	sp,sp,48
    80004392:	8082                	ret
    80004394:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004396:	0284a983          	lw	s3,40(s1)
    8000439a:	d78fd0ef          	jal	80001912 <myproc>
    8000439e:	5904                	lw	s1,48(a0)
    800043a0:	413484b3          	sub	s1,s1,s3
    800043a4:	0014b493          	seqz	s1,s1
    800043a8:	69a2                	ld	s3,8(sp)
    800043aa:	bfd9                	j	80004380 <holdingsleep+0x1e>

00000000800043ac <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800043ac:	1141                	addi	sp,sp,-16
    800043ae:	e406                	sd	ra,8(sp)
    800043b0:	e022                	sd	s0,0(sp)
    800043b2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800043b4:	00003597          	auipc	a1,0x3
    800043b8:	21458593          	addi	a1,a1,532 # 800075c8 <etext+0x5c8>
    800043bc:	0001f517          	auipc	a0,0x1f
    800043c0:	9fc50513          	addi	a0,a0,-1540 # 80022db8 <ftable>
    800043c4:	fbefc0ef          	jal	80000b82 <initlock>
}
    800043c8:	60a2                	ld	ra,8(sp)
    800043ca:	6402                	ld	s0,0(sp)
    800043cc:	0141                	addi	sp,sp,16
    800043ce:	8082                	ret

00000000800043d0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800043d0:	1101                	addi	sp,sp,-32
    800043d2:	ec06                	sd	ra,24(sp)
    800043d4:	e822                	sd	s0,16(sp)
    800043d6:	e426                	sd	s1,8(sp)
    800043d8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800043da:	0001f517          	auipc	a0,0x1f
    800043de:	9de50513          	addi	a0,a0,-1570 # 80022db8 <ftable>
    800043e2:	821fc0ef          	jal	80000c02 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800043e6:	0001f497          	auipc	s1,0x1f
    800043ea:	9ea48493          	addi	s1,s1,-1558 # 80022dd0 <ftable+0x18>
    800043ee:	00020717          	auipc	a4,0x20
    800043f2:	98270713          	addi	a4,a4,-1662 # 80023d70 <disk>
    if(f->ref == 0){
    800043f6:	40dc                	lw	a5,4(s1)
    800043f8:	cf89                	beqz	a5,80004412 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800043fa:	02848493          	addi	s1,s1,40
    800043fe:	fee49ce3          	bne	s1,a4,800043f6 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004402:	0001f517          	auipc	a0,0x1f
    80004406:	9b650513          	addi	a0,a0,-1610 # 80022db8 <ftable>
    8000440a:	891fc0ef          	jal	80000c9a <release>
  return 0;
    8000440e:	4481                	li	s1,0
    80004410:	a809                	j	80004422 <filealloc+0x52>
      f->ref = 1;
    80004412:	4785                	li	a5,1
    80004414:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004416:	0001f517          	auipc	a0,0x1f
    8000441a:	9a250513          	addi	a0,a0,-1630 # 80022db8 <ftable>
    8000441e:	87dfc0ef          	jal	80000c9a <release>
}
    80004422:	8526                	mv	a0,s1
    80004424:	60e2                	ld	ra,24(sp)
    80004426:	6442                	ld	s0,16(sp)
    80004428:	64a2                	ld	s1,8(sp)
    8000442a:	6105                	addi	sp,sp,32
    8000442c:	8082                	ret

000000008000442e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000442e:	1101                	addi	sp,sp,-32
    80004430:	ec06                	sd	ra,24(sp)
    80004432:	e822                	sd	s0,16(sp)
    80004434:	e426                	sd	s1,8(sp)
    80004436:	1000                	addi	s0,sp,32
    80004438:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000443a:	0001f517          	auipc	a0,0x1f
    8000443e:	97e50513          	addi	a0,a0,-1666 # 80022db8 <ftable>
    80004442:	fc0fc0ef          	jal	80000c02 <acquire>
  if(f->ref < 1)
    80004446:	40dc                	lw	a5,4(s1)
    80004448:	02f05063          	blez	a5,80004468 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000444c:	2785                	addiw	a5,a5,1
    8000444e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004450:	0001f517          	auipc	a0,0x1f
    80004454:	96850513          	addi	a0,a0,-1688 # 80022db8 <ftable>
    80004458:	843fc0ef          	jal	80000c9a <release>
  return f;
}
    8000445c:	8526                	mv	a0,s1
    8000445e:	60e2                	ld	ra,24(sp)
    80004460:	6442                	ld	s0,16(sp)
    80004462:	64a2                	ld	s1,8(sp)
    80004464:	6105                	addi	sp,sp,32
    80004466:	8082                	ret
    panic("filedup");
    80004468:	00003517          	auipc	a0,0x3
    8000446c:	16850513          	addi	a0,a0,360 # 800075d0 <etext+0x5d0>
    80004470:	b32fc0ef          	jal	800007a2 <panic>

0000000080004474 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004474:	7139                	addi	sp,sp,-64
    80004476:	fc06                	sd	ra,56(sp)
    80004478:	f822                	sd	s0,48(sp)
    8000447a:	f426                	sd	s1,40(sp)
    8000447c:	0080                	addi	s0,sp,64
    8000447e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004480:	0001f517          	auipc	a0,0x1f
    80004484:	93850513          	addi	a0,a0,-1736 # 80022db8 <ftable>
    80004488:	f7afc0ef          	jal	80000c02 <acquire>
  if(f->ref < 1)
    8000448c:	40dc                	lw	a5,4(s1)
    8000448e:	04f05a63          	blez	a5,800044e2 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80004492:	37fd                	addiw	a5,a5,-1
    80004494:	0007871b          	sext.w	a4,a5
    80004498:	c0dc                	sw	a5,4(s1)
    8000449a:	04e04e63          	bgtz	a4,800044f6 <fileclose+0x82>
    8000449e:	f04a                	sd	s2,32(sp)
    800044a0:	ec4e                	sd	s3,24(sp)
    800044a2:	e852                	sd	s4,16(sp)
    800044a4:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800044a6:	0004a903          	lw	s2,0(s1)
    800044aa:	0094ca83          	lbu	s5,9(s1)
    800044ae:	0104ba03          	ld	s4,16(s1)
    800044b2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800044b6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800044ba:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800044be:	0001f517          	auipc	a0,0x1f
    800044c2:	8fa50513          	addi	a0,a0,-1798 # 80022db8 <ftable>
    800044c6:	fd4fc0ef          	jal	80000c9a <release>

  if(ff.type == FD_PIPE){
    800044ca:	4785                	li	a5,1
    800044cc:	04f90063          	beq	s2,a5,8000450c <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800044d0:	3979                	addiw	s2,s2,-2
    800044d2:	4785                	li	a5,1
    800044d4:	0527f563          	bgeu	a5,s2,8000451e <fileclose+0xaa>
    800044d8:	7902                	ld	s2,32(sp)
    800044da:	69e2                	ld	s3,24(sp)
    800044dc:	6a42                	ld	s4,16(sp)
    800044de:	6aa2                	ld	s5,8(sp)
    800044e0:	a00d                	j	80004502 <fileclose+0x8e>
    800044e2:	f04a                	sd	s2,32(sp)
    800044e4:	ec4e                	sd	s3,24(sp)
    800044e6:	e852                	sd	s4,16(sp)
    800044e8:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800044ea:	00003517          	auipc	a0,0x3
    800044ee:	0ee50513          	addi	a0,a0,238 # 800075d8 <etext+0x5d8>
    800044f2:	ab0fc0ef          	jal	800007a2 <panic>
    release(&ftable.lock);
    800044f6:	0001f517          	auipc	a0,0x1f
    800044fa:	8c250513          	addi	a0,a0,-1854 # 80022db8 <ftable>
    800044fe:	f9cfc0ef          	jal	80000c9a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004502:	70e2                	ld	ra,56(sp)
    80004504:	7442                	ld	s0,48(sp)
    80004506:	74a2                	ld	s1,40(sp)
    80004508:	6121                	addi	sp,sp,64
    8000450a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000450c:	85d6                	mv	a1,s5
    8000450e:	8552                	mv	a0,s4
    80004510:	336000ef          	jal	80004846 <pipeclose>
    80004514:	7902                	ld	s2,32(sp)
    80004516:	69e2                	ld	s3,24(sp)
    80004518:	6a42                	ld	s4,16(sp)
    8000451a:	6aa2                	ld	s5,8(sp)
    8000451c:	b7dd                	j	80004502 <fileclose+0x8e>
    begin_op();
    8000451e:	b3dff0ef          	jal	8000405a <begin_op>
    iput(ff.ip);
    80004522:	854e                	mv	a0,s3
    80004524:	c22ff0ef          	jal	80003946 <iput>
    end_op();
    80004528:	b9dff0ef          	jal	800040c4 <end_op>
    8000452c:	7902                	ld	s2,32(sp)
    8000452e:	69e2                	ld	s3,24(sp)
    80004530:	6a42                	ld	s4,16(sp)
    80004532:	6aa2                	ld	s5,8(sp)
    80004534:	b7f9                	j	80004502 <fileclose+0x8e>

0000000080004536 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004536:	715d                	addi	sp,sp,-80
    80004538:	e486                	sd	ra,72(sp)
    8000453a:	e0a2                	sd	s0,64(sp)
    8000453c:	fc26                	sd	s1,56(sp)
    8000453e:	f44e                	sd	s3,40(sp)
    80004540:	0880                	addi	s0,sp,80
    80004542:	84aa                	mv	s1,a0
    80004544:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004546:	bccfd0ef          	jal	80001912 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000454a:	409c                	lw	a5,0(s1)
    8000454c:	37f9                	addiw	a5,a5,-2
    8000454e:	4705                	li	a4,1
    80004550:	04f76063          	bltu	a4,a5,80004590 <filestat+0x5a>
    80004554:	f84a                	sd	s2,48(sp)
    80004556:	892a                	mv	s2,a0
    ilock(f->ip);
    80004558:	6c88                	ld	a0,24(s1)
    8000455a:	a6aff0ef          	jal	800037c4 <ilock>
    stati(f->ip, &st);
    8000455e:	fb840593          	addi	a1,s0,-72
    80004562:	6c88                	ld	a0,24(s1)
    80004564:	c8aff0ef          	jal	800039ee <stati>
    iunlock(f->ip);
    80004568:	6c88                	ld	a0,24(s1)
    8000456a:	b08ff0ef          	jal	80003872 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000456e:	46e1                	li	a3,24
    80004570:	fb840613          	addi	a2,s0,-72
    80004574:	85ce                	mv	a1,s3
    80004576:	05093503          	ld	a0,80(s2)
    8000457a:	80afd0ef          	jal	80001584 <copyout>
    8000457e:	41f5551b          	sraiw	a0,a0,0x1f
    80004582:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004584:	60a6                	ld	ra,72(sp)
    80004586:	6406                	ld	s0,64(sp)
    80004588:	74e2                	ld	s1,56(sp)
    8000458a:	79a2                	ld	s3,40(sp)
    8000458c:	6161                	addi	sp,sp,80
    8000458e:	8082                	ret
  return -1;
    80004590:	557d                	li	a0,-1
    80004592:	bfcd                	j	80004584 <filestat+0x4e>

0000000080004594 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004594:	7179                	addi	sp,sp,-48
    80004596:	f406                	sd	ra,40(sp)
    80004598:	f022                	sd	s0,32(sp)
    8000459a:	e84a                	sd	s2,16(sp)
    8000459c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000459e:	00854783          	lbu	a5,8(a0)
    800045a2:	cfd1                	beqz	a5,8000463e <fileread+0xaa>
    800045a4:	ec26                	sd	s1,24(sp)
    800045a6:	e44e                	sd	s3,8(sp)
    800045a8:	84aa                	mv	s1,a0
    800045aa:	89ae                	mv	s3,a1
    800045ac:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800045ae:	411c                	lw	a5,0(a0)
    800045b0:	4705                	li	a4,1
    800045b2:	04e78363          	beq	a5,a4,800045f8 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800045b6:	470d                	li	a4,3
    800045b8:	04e78763          	beq	a5,a4,80004606 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800045bc:	4709                	li	a4,2
    800045be:	06e79a63          	bne	a5,a4,80004632 <fileread+0x9e>
    ilock(f->ip);
    800045c2:	6d08                	ld	a0,24(a0)
    800045c4:	a00ff0ef          	jal	800037c4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800045c8:	874a                	mv	a4,s2
    800045ca:	5094                	lw	a3,32(s1)
    800045cc:	864e                	mv	a2,s3
    800045ce:	4585                	li	a1,1
    800045d0:	6c88                	ld	a0,24(s1)
    800045d2:	c46ff0ef          	jal	80003a18 <readi>
    800045d6:	892a                	mv	s2,a0
    800045d8:	00a05563          	blez	a0,800045e2 <fileread+0x4e>
      f->off += r;
    800045dc:	509c                	lw	a5,32(s1)
    800045de:	9fa9                	addw	a5,a5,a0
    800045e0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800045e2:	6c88                	ld	a0,24(s1)
    800045e4:	a8eff0ef          	jal	80003872 <iunlock>
    800045e8:	64e2                	ld	s1,24(sp)
    800045ea:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800045ec:	854a                	mv	a0,s2
    800045ee:	70a2                	ld	ra,40(sp)
    800045f0:	7402                	ld	s0,32(sp)
    800045f2:	6942                	ld	s2,16(sp)
    800045f4:	6145                	addi	sp,sp,48
    800045f6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800045f8:	6908                	ld	a0,16(a0)
    800045fa:	388000ef          	jal	80004982 <piperead>
    800045fe:	892a                	mv	s2,a0
    80004600:	64e2                	ld	s1,24(sp)
    80004602:	69a2                	ld	s3,8(sp)
    80004604:	b7e5                	j	800045ec <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004606:	02451783          	lh	a5,36(a0)
    8000460a:	03079693          	slli	a3,a5,0x30
    8000460e:	92c1                	srli	a3,a3,0x30
    80004610:	4725                	li	a4,9
    80004612:	02d76863          	bltu	a4,a3,80004642 <fileread+0xae>
    80004616:	0792                	slli	a5,a5,0x4
    80004618:	0001e717          	auipc	a4,0x1e
    8000461c:	70070713          	addi	a4,a4,1792 # 80022d18 <devsw>
    80004620:	97ba                	add	a5,a5,a4
    80004622:	639c                	ld	a5,0(a5)
    80004624:	c39d                	beqz	a5,8000464a <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004626:	4505                	li	a0,1
    80004628:	9782                	jalr	a5
    8000462a:	892a                	mv	s2,a0
    8000462c:	64e2                	ld	s1,24(sp)
    8000462e:	69a2                	ld	s3,8(sp)
    80004630:	bf75                	j	800045ec <fileread+0x58>
    panic("fileread");
    80004632:	00003517          	auipc	a0,0x3
    80004636:	fb650513          	addi	a0,a0,-74 # 800075e8 <etext+0x5e8>
    8000463a:	968fc0ef          	jal	800007a2 <panic>
    return -1;
    8000463e:	597d                	li	s2,-1
    80004640:	b775                	j	800045ec <fileread+0x58>
      return -1;
    80004642:	597d                	li	s2,-1
    80004644:	64e2                	ld	s1,24(sp)
    80004646:	69a2                	ld	s3,8(sp)
    80004648:	b755                	j	800045ec <fileread+0x58>
    8000464a:	597d                	li	s2,-1
    8000464c:	64e2                	ld	s1,24(sp)
    8000464e:	69a2                	ld	s3,8(sp)
    80004650:	bf71                	j	800045ec <fileread+0x58>

0000000080004652 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004652:	00954783          	lbu	a5,9(a0)
    80004656:	10078b63          	beqz	a5,8000476c <filewrite+0x11a>
{
    8000465a:	715d                	addi	sp,sp,-80
    8000465c:	e486                	sd	ra,72(sp)
    8000465e:	e0a2                	sd	s0,64(sp)
    80004660:	f84a                	sd	s2,48(sp)
    80004662:	f052                	sd	s4,32(sp)
    80004664:	e85a                	sd	s6,16(sp)
    80004666:	0880                	addi	s0,sp,80
    80004668:	892a                	mv	s2,a0
    8000466a:	8b2e                	mv	s6,a1
    8000466c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000466e:	411c                	lw	a5,0(a0)
    80004670:	4705                	li	a4,1
    80004672:	02e78763          	beq	a5,a4,800046a0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004676:	470d                	li	a4,3
    80004678:	02e78863          	beq	a5,a4,800046a8 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000467c:	4709                	li	a4,2
    8000467e:	0ce79c63          	bne	a5,a4,80004756 <filewrite+0x104>
    80004682:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004684:	0ac05863          	blez	a2,80004734 <filewrite+0xe2>
    80004688:	fc26                	sd	s1,56(sp)
    8000468a:	ec56                	sd	s5,24(sp)
    8000468c:	e45e                	sd	s7,8(sp)
    8000468e:	e062                	sd	s8,0(sp)
    int i = 0;
    80004690:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004692:	6b85                	lui	s7,0x1
    80004694:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004698:	6c05                	lui	s8,0x1
    8000469a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000469e:	a8b5                	j	8000471a <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800046a0:	6908                	ld	a0,16(a0)
    800046a2:	1fc000ef          	jal	8000489e <pipewrite>
    800046a6:	a04d                	j	80004748 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800046a8:	02451783          	lh	a5,36(a0)
    800046ac:	03079693          	slli	a3,a5,0x30
    800046b0:	92c1                	srli	a3,a3,0x30
    800046b2:	4725                	li	a4,9
    800046b4:	0ad76e63          	bltu	a4,a3,80004770 <filewrite+0x11e>
    800046b8:	0792                	slli	a5,a5,0x4
    800046ba:	0001e717          	auipc	a4,0x1e
    800046be:	65e70713          	addi	a4,a4,1630 # 80022d18 <devsw>
    800046c2:	97ba                	add	a5,a5,a4
    800046c4:	679c                	ld	a5,8(a5)
    800046c6:	c7dd                	beqz	a5,80004774 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800046c8:	4505                	li	a0,1
    800046ca:	9782                	jalr	a5
    800046cc:	a8b5                	j	80004748 <filewrite+0xf6>
      if(n1 > max)
    800046ce:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800046d2:	989ff0ef          	jal	8000405a <begin_op>
      ilock(f->ip);
    800046d6:	01893503          	ld	a0,24(s2)
    800046da:	8eaff0ef          	jal	800037c4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800046de:	8756                	mv	a4,s5
    800046e0:	02092683          	lw	a3,32(s2)
    800046e4:	01698633          	add	a2,s3,s6
    800046e8:	4585                	li	a1,1
    800046ea:	01893503          	ld	a0,24(s2)
    800046ee:	c26ff0ef          	jal	80003b14 <writei>
    800046f2:	84aa                	mv	s1,a0
    800046f4:	00a05763          	blez	a0,80004702 <filewrite+0xb0>
        f->off += r;
    800046f8:	02092783          	lw	a5,32(s2)
    800046fc:	9fa9                	addw	a5,a5,a0
    800046fe:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004702:	01893503          	ld	a0,24(s2)
    80004706:	96cff0ef          	jal	80003872 <iunlock>
      end_op();
    8000470a:	9bbff0ef          	jal	800040c4 <end_op>

      if(r != n1){
    8000470e:	029a9563          	bne	s5,s1,80004738 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004712:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004716:	0149da63          	bge	s3,s4,8000472a <filewrite+0xd8>
      int n1 = n - i;
    8000471a:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000471e:	0004879b          	sext.w	a5,s1
    80004722:	fafbd6e3          	bge	s7,a5,800046ce <filewrite+0x7c>
    80004726:	84e2                	mv	s1,s8
    80004728:	b75d                	j	800046ce <filewrite+0x7c>
    8000472a:	74e2                	ld	s1,56(sp)
    8000472c:	6ae2                	ld	s5,24(sp)
    8000472e:	6ba2                	ld	s7,8(sp)
    80004730:	6c02                	ld	s8,0(sp)
    80004732:	a039                	j	80004740 <filewrite+0xee>
    int i = 0;
    80004734:	4981                	li	s3,0
    80004736:	a029                	j	80004740 <filewrite+0xee>
    80004738:	74e2                	ld	s1,56(sp)
    8000473a:	6ae2                	ld	s5,24(sp)
    8000473c:	6ba2                	ld	s7,8(sp)
    8000473e:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004740:	033a1c63          	bne	s4,s3,80004778 <filewrite+0x126>
    80004744:	8552                	mv	a0,s4
    80004746:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004748:	60a6                	ld	ra,72(sp)
    8000474a:	6406                	ld	s0,64(sp)
    8000474c:	7942                	ld	s2,48(sp)
    8000474e:	7a02                	ld	s4,32(sp)
    80004750:	6b42                	ld	s6,16(sp)
    80004752:	6161                	addi	sp,sp,80
    80004754:	8082                	ret
    80004756:	fc26                	sd	s1,56(sp)
    80004758:	f44e                	sd	s3,40(sp)
    8000475a:	ec56                	sd	s5,24(sp)
    8000475c:	e45e                	sd	s7,8(sp)
    8000475e:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004760:	00003517          	auipc	a0,0x3
    80004764:	e9850513          	addi	a0,a0,-360 # 800075f8 <etext+0x5f8>
    80004768:	83afc0ef          	jal	800007a2 <panic>
    return -1;
    8000476c:	557d                	li	a0,-1
}
    8000476e:	8082                	ret
      return -1;
    80004770:	557d                	li	a0,-1
    80004772:	bfd9                	j	80004748 <filewrite+0xf6>
    80004774:	557d                	li	a0,-1
    80004776:	bfc9                	j	80004748 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80004778:	557d                	li	a0,-1
    8000477a:	79a2                	ld	s3,40(sp)
    8000477c:	b7f1                	j	80004748 <filewrite+0xf6>

000000008000477e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000477e:	7179                	addi	sp,sp,-48
    80004780:	f406                	sd	ra,40(sp)
    80004782:	f022                	sd	s0,32(sp)
    80004784:	ec26                	sd	s1,24(sp)
    80004786:	e052                	sd	s4,0(sp)
    80004788:	1800                	addi	s0,sp,48
    8000478a:	84aa                	mv	s1,a0
    8000478c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000478e:	0005b023          	sd	zero,0(a1)
    80004792:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004796:	c3bff0ef          	jal	800043d0 <filealloc>
    8000479a:	e088                	sd	a0,0(s1)
    8000479c:	c549                	beqz	a0,80004826 <pipealloc+0xa8>
    8000479e:	c33ff0ef          	jal	800043d0 <filealloc>
    800047a2:	00aa3023          	sd	a0,0(s4)
    800047a6:	cd25                	beqz	a0,8000481e <pipealloc+0xa0>
    800047a8:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800047aa:	b88fc0ef          	jal	80000b32 <kalloc>
    800047ae:	892a                	mv	s2,a0
    800047b0:	c12d                	beqz	a0,80004812 <pipealloc+0x94>
    800047b2:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800047b4:	4985                	li	s3,1
    800047b6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800047ba:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800047be:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800047c2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800047c6:	00003597          	auipc	a1,0x3
    800047ca:	e4258593          	addi	a1,a1,-446 # 80007608 <etext+0x608>
    800047ce:	bb4fc0ef          	jal	80000b82 <initlock>
  (*f0)->type = FD_PIPE;
    800047d2:	609c                	ld	a5,0(s1)
    800047d4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800047d8:	609c                	ld	a5,0(s1)
    800047da:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800047de:	609c                	ld	a5,0(s1)
    800047e0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800047e4:	609c                	ld	a5,0(s1)
    800047e6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800047ea:	000a3783          	ld	a5,0(s4)
    800047ee:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800047f2:	000a3783          	ld	a5,0(s4)
    800047f6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800047fa:	000a3783          	ld	a5,0(s4)
    800047fe:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004802:	000a3783          	ld	a5,0(s4)
    80004806:	0127b823          	sd	s2,16(a5)
  return 0;
    8000480a:	4501                	li	a0,0
    8000480c:	6942                	ld	s2,16(sp)
    8000480e:	69a2                	ld	s3,8(sp)
    80004810:	a01d                	j	80004836 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004812:	6088                	ld	a0,0(s1)
    80004814:	c119                	beqz	a0,8000481a <pipealloc+0x9c>
    80004816:	6942                	ld	s2,16(sp)
    80004818:	a029                	j	80004822 <pipealloc+0xa4>
    8000481a:	6942                	ld	s2,16(sp)
    8000481c:	a029                	j	80004826 <pipealloc+0xa8>
    8000481e:	6088                	ld	a0,0(s1)
    80004820:	c10d                	beqz	a0,80004842 <pipealloc+0xc4>
    fileclose(*f0);
    80004822:	c53ff0ef          	jal	80004474 <fileclose>
  if(*f1)
    80004826:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000482a:	557d                	li	a0,-1
  if(*f1)
    8000482c:	c789                	beqz	a5,80004836 <pipealloc+0xb8>
    fileclose(*f1);
    8000482e:	853e                	mv	a0,a5
    80004830:	c45ff0ef          	jal	80004474 <fileclose>
  return -1;
    80004834:	557d                	li	a0,-1
}
    80004836:	70a2                	ld	ra,40(sp)
    80004838:	7402                	ld	s0,32(sp)
    8000483a:	64e2                	ld	s1,24(sp)
    8000483c:	6a02                	ld	s4,0(sp)
    8000483e:	6145                	addi	sp,sp,48
    80004840:	8082                	ret
  return -1;
    80004842:	557d                	li	a0,-1
    80004844:	bfcd                	j	80004836 <pipealloc+0xb8>

0000000080004846 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004846:	1101                	addi	sp,sp,-32
    80004848:	ec06                	sd	ra,24(sp)
    8000484a:	e822                	sd	s0,16(sp)
    8000484c:	e426                	sd	s1,8(sp)
    8000484e:	e04a                	sd	s2,0(sp)
    80004850:	1000                	addi	s0,sp,32
    80004852:	84aa                	mv	s1,a0
    80004854:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004856:	bacfc0ef          	jal	80000c02 <acquire>
  if(writable){
    8000485a:	02090763          	beqz	s2,80004888 <pipeclose+0x42>
    pi->writeopen = 0;
    8000485e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004862:	21848513          	addi	a0,s1,536
    80004866:	b09fd0ef          	jal	8000236e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000486a:	2204b783          	ld	a5,544(s1)
    8000486e:	e785                	bnez	a5,80004896 <pipeclose+0x50>
    release(&pi->lock);
    80004870:	8526                	mv	a0,s1
    80004872:	c28fc0ef          	jal	80000c9a <release>
    kfree((char*)pi);
    80004876:	8526                	mv	a0,s1
    80004878:	9d8fc0ef          	jal	80000a50 <kfree>
  } else
    release(&pi->lock);
}
    8000487c:	60e2                	ld	ra,24(sp)
    8000487e:	6442                	ld	s0,16(sp)
    80004880:	64a2                	ld	s1,8(sp)
    80004882:	6902                	ld	s2,0(sp)
    80004884:	6105                	addi	sp,sp,32
    80004886:	8082                	ret
    pi->readopen = 0;
    80004888:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000488c:	21c48513          	addi	a0,s1,540
    80004890:	adffd0ef          	jal	8000236e <wakeup>
    80004894:	bfd9                	j	8000486a <pipeclose+0x24>
    release(&pi->lock);
    80004896:	8526                	mv	a0,s1
    80004898:	c02fc0ef          	jal	80000c9a <release>
}
    8000489c:	b7c5                	j	8000487c <pipeclose+0x36>

000000008000489e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000489e:	711d                	addi	sp,sp,-96
    800048a0:	ec86                	sd	ra,88(sp)
    800048a2:	e8a2                	sd	s0,80(sp)
    800048a4:	e4a6                	sd	s1,72(sp)
    800048a6:	e0ca                	sd	s2,64(sp)
    800048a8:	fc4e                	sd	s3,56(sp)
    800048aa:	f852                	sd	s4,48(sp)
    800048ac:	f456                	sd	s5,40(sp)
    800048ae:	1080                	addi	s0,sp,96
    800048b0:	84aa                	mv	s1,a0
    800048b2:	8aae                	mv	s5,a1
    800048b4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800048b6:	85cfd0ef          	jal	80001912 <myproc>
    800048ba:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800048bc:	8526                	mv	a0,s1
    800048be:	b44fc0ef          	jal	80000c02 <acquire>
  while(i < n){
    800048c2:	0b405a63          	blez	s4,80004976 <pipewrite+0xd8>
    800048c6:	f05a                	sd	s6,32(sp)
    800048c8:	ec5e                	sd	s7,24(sp)
    800048ca:	e862                	sd	s8,16(sp)
  int i = 0;
    800048cc:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800048ce:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800048d0:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800048d4:	21c48b93          	addi	s7,s1,540
    800048d8:	a81d                	j	8000490e <pipewrite+0x70>
      release(&pi->lock);
    800048da:	8526                	mv	a0,s1
    800048dc:	bbefc0ef          	jal	80000c9a <release>
      return -1;
    800048e0:	597d                	li	s2,-1
    800048e2:	7b02                	ld	s6,32(sp)
    800048e4:	6be2                	ld	s7,24(sp)
    800048e6:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800048e8:	854a                	mv	a0,s2
    800048ea:	60e6                	ld	ra,88(sp)
    800048ec:	6446                	ld	s0,80(sp)
    800048ee:	64a6                	ld	s1,72(sp)
    800048f0:	6906                	ld	s2,64(sp)
    800048f2:	79e2                	ld	s3,56(sp)
    800048f4:	7a42                	ld	s4,48(sp)
    800048f6:	7aa2                	ld	s5,40(sp)
    800048f8:	6125                	addi	sp,sp,96
    800048fa:	8082                	ret
      wakeup(&pi->nread);
    800048fc:	8562                	mv	a0,s8
    800048fe:	a71fd0ef          	jal	8000236e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004902:	85a6                	mv	a1,s1
    80004904:	855e                	mv	a0,s7
    80004906:	8bdfd0ef          	jal	800021c2 <sleep>
  while(i < n){
    8000490a:	05495b63          	bge	s2,s4,80004960 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    8000490e:	2204a783          	lw	a5,544(s1)
    80004912:	d7e1                	beqz	a5,800048da <pipewrite+0x3c>
    80004914:	854e                	mv	a0,s3
    80004916:	c5bfd0ef          	jal	80002570 <killed>
    8000491a:	f161                	bnez	a0,800048da <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000491c:	2184a783          	lw	a5,536(s1)
    80004920:	21c4a703          	lw	a4,540(s1)
    80004924:	2007879b          	addiw	a5,a5,512
    80004928:	fcf70ae3          	beq	a4,a5,800048fc <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000492c:	4685                	li	a3,1
    8000492e:	01590633          	add	a2,s2,s5
    80004932:	faf40593          	addi	a1,s0,-81
    80004936:	0509b503          	ld	a0,80(s3)
    8000493a:	d21fc0ef          	jal	8000165a <copyin>
    8000493e:	03650e63          	beq	a0,s6,8000497a <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004942:	21c4a783          	lw	a5,540(s1)
    80004946:	0017871b          	addiw	a4,a5,1
    8000494a:	20e4ae23          	sw	a4,540(s1)
    8000494e:	1ff7f793          	andi	a5,a5,511
    80004952:	97a6                	add	a5,a5,s1
    80004954:	faf44703          	lbu	a4,-81(s0)
    80004958:	00e78c23          	sb	a4,24(a5)
      i++;
    8000495c:	2905                	addiw	s2,s2,1
    8000495e:	b775                	j	8000490a <pipewrite+0x6c>
    80004960:	7b02                	ld	s6,32(sp)
    80004962:	6be2                	ld	s7,24(sp)
    80004964:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004966:	21848513          	addi	a0,s1,536
    8000496a:	a05fd0ef          	jal	8000236e <wakeup>
  release(&pi->lock);
    8000496e:	8526                	mv	a0,s1
    80004970:	b2afc0ef          	jal	80000c9a <release>
  return i;
    80004974:	bf95                	j	800048e8 <pipewrite+0x4a>
  int i = 0;
    80004976:	4901                	li	s2,0
    80004978:	b7fd                	j	80004966 <pipewrite+0xc8>
    8000497a:	7b02                	ld	s6,32(sp)
    8000497c:	6be2                	ld	s7,24(sp)
    8000497e:	6c42                	ld	s8,16(sp)
    80004980:	b7dd                	j	80004966 <pipewrite+0xc8>

0000000080004982 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004982:	715d                	addi	sp,sp,-80
    80004984:	e486                	sd	ra,72(sp)
    80004986:	e0a2                	sd	s0,64(sp)
    80004988:	fc26                	sd	s1,56(sp)
    8000498a:	f84a                	sd	s2,48(sp)
    8000498c:	f44e                	sd	s3,40(sp)
    8000498e:	f052                	sd	s4,32(sp)
    80004990:	ec56                	sd	s5,24(sp)
    80004992:	0880                	addi	s0,sp,80
    80004994:	84aa                	mv	s1,a0
    80004996:	892e                	mv	s2,a1
    80004998:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000499a:	f79fc0ef          	jal	80001912 <myproc>
    8000499e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800049a0:	8526                	mv	a0,s1
    800049a2:	a60fc0ef          	jal	80000c02 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800049a6:	2184a703          	lw	a4,536(s1)
    800049aa:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800049ae:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800049b2:	02f71563          	bne	a4,a5,800049dc <piperead+0x5a>
    800049b6:	2244a783          	lw	a5,548(s1)
    800049ba:	cb85                	beqz	a5,800049ea <piperead+0x68>
    if(killed(pr)){
    800049bc:	8552                	mv	a0,s4
    800049be:	bb3fd0ef          	jal	80002570 <killed>
    800049c2:	ed19                	bnez	a0,800049e0 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800049c4:	85a6                	mv	a1,s1
    800049c6:	854e                	mv	a0,s3
    800049c8:	ffafd0ef          	jal	800021c2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800049cc:	2184a703          	lw	a4,536(s1)
    800049d0:	21c4a783          	lw	a5,540(s1)
    800049d4:	fef701e3          	beq	a4,a5,800049b6 <piperead+0x34>
    800049d8:	e85a                	sd	s6,16(sp)
    800049da:	a809                	j	800049ec <piperead+0x6a>
    800049dc:	e85a                	sd	s6,16(sp)
    800049de:	a039                	j	800049ec <piperead+0x6a>
      release(&pi->lock);
    800049e0:	8526                	mv	a0,s1
    800049e2:	ab8fc0ef          	jal	80000c9a <release>
      return -1;
    800049e6:	59fd                	li	s3,-1
    800049e8:	a8b1                	j	80004a44 <piperead+0xc2>
    800049ea:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800049ec:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800049ee:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800049f0:	05505263          	blez	s5,80004a34 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800049f4:	2184a783          	lw	a5,536(s1)
    800049f8:	21c4a703          	lw	a4,540(s1)
    800049fc:	02f70c63          	beq	a4,a5,80004a34 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004a00:	0017871b          	addiw	a4,a5,1
    80004a04:	20e4ac23          	sw	a4,536(s1)
    80004a08:	1ff7f793          	andi	a5,a5,511
    80004a0c:	97a6                	add	a5,a5,s1
    80004a0e:	0187c783          	lbu	a5,24(a5)
    80004a12:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a16:	4685                	li	a3,1
    80004a18:	fbf40613          	addi	a2,s0,-65
    80004a1c:	85ca                	mv	a1,s2
    80004a1e:	050a3503          	ld	a0,80(s4)
    80004a22:	b63fc0ef          	jal	80001584 <copyout>
    80004a26:	01650763          	beq	a0,s6,80004a34 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a2a:	2985                	addiw	s3,s3,1
    80004a2c:	0905                	addi	s2,s2,1
    80004a2e:	fd3a93e3          	bne	s5,s3,800049f4 <piperead+0x72>
    80004a32:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004a34:	21c48513          	addi	a0,s1,540
    80004a38:	937fd0ef          	jal	8000236e <wakeup>
  release(&pi->lock);
    80004a3c:	8526                	mv	a0,s1
    80004a3e:	a5cfc0ef          	jal	80000c9a <release>
    80004a42:	6b42                	ld	s6,16(sp)
  return i;
}
    80004a44:	854e                	mv	a0,s3
    80004a46:	60a6                	ld	ra,72(sp)
    80004a48:	6406                	ld	s0,64(sp)
    80004a4a:	74e2                	ld	s1,56(sp)
    80004a4c:	7942                	ld	s2,48(sp)
    80004a4e:	79a2                	ld	s3,40(sp)
    80004a50:	7a02                	ld	s4,32(sp)
    80004a52:	6ae2                	ld	s5,24(sp)
    80004a54:	6161                	addi	sp,sp,80
    80004a56:	8082                	ret

0000000080004a58 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004a58:	1141                	addi	sp,sp,-16
    80004a5a:	e422                	sd	s0,8(sp)
    80004a5c:	0800                	addi	s0,sp,16
    80004a5e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004a60:	8905                	andi	a0,a0,1
    80004a62:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004a64:	8b89                	andi	a5,a5,2
    80004a66:	c399                	beqz	a5,80004a6c <flags2perm+0x14>
      perm |= PTE_W;
    80004a68:	00456513          	ori	a0,a0,4
    return perm;
}
    80004a6c:	6422                	ld	s0,8(sp)
    80004a6e:	0141                	addi	sp,sp,16
    80004a70:	8082                	ret

0000000080004a72 <exec>:

int
exec(char *path, char **argv)
{
    80004a72:	df010113          	addi	sp,sp,-528
    80004a76:	20113423          	sd	ra,520(sp)
    80004a7a:	20813023          	sd	s0,512(sp)
    80004a7e:	ffa6                	sd	s1,504(sp)
    80004a80:	fbca                	sd	s2,496(sp)
    80004a82:	0c00                	addi	s0,sp,528
    80004a84:	892a                	mv	s2,a0
    80004a86:	dea43c23          	sd	a0,-520(s0)
    80004a8a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004a8e:	e85fc0ef          	jal	80001912 <myproc>
    80004a92:	84aa                	mv	s1,a0

  begin_op();
    80004a94:	dc6ff0ef          	jal	8000405a <begin_op>

  if((ip = namei(path)) == 0){
    80004a98:	854a                	mv	a0,s2
    80004a9a:	c04ff0ef          	jal	80003e9e <namei>
    80004a9e:	c931                	beqz	a0,80004af2 <exec+0x80>
    80004aa0:	f3d2                	sd	s4,480(sp)
    80004aa2:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004aa4:	d21fe0ef          	jal	800037c4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004aa8:	04000713          	li	a4,64
    80004aac:	4681                	li	a3,0
    80004aae:	e5040613          	addi	a2,s0,-432
    80004ab2:	4581                	li	a1,0
    80004ab4:	8552                	mv	a0,s4
    80004ab6:	f63fe0ef          	jal	80003a18 <readi>
    80004aba:	04000793          	li	a5,64
    80004abe:	00f51a63          	bne	a0,a5,80004ad2 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004ac2:	e5042703          	lw	a4,-432(s0)
    80004ac6:	464c47b7          	lui	a5,0x464c4
    80004aca:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004ace:	02f70663          	beq	a4,a5,80004afa <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004ad2:	8552                	mv	a0,s4
    80004ad4:	efbfe0ef          	jal	800039ce <iunlockput>
    end_op();
    80004ad8:	decff0ef          	jal	800040c4 <end_op>
  }
  return -1;
    80004adc:	557d                	li	a0,-1
    80004ade:	7a1e                	ld	s4,480(sp)
}
    80004ae0:	20813083          	ld	ra,520(sp)
    80004ae4:	20013403          	ld	s0,512(sp)
    80004ae8:	74fe                	ld	s1,504(sp)
    80004aea:	795e                	ld	s2,496(sp)
    80004aec:	21010113          	addi	sp,sp,528
    80004af0:	8082                	ret
    end_op();
    80004af2:	dd2ff0ef          	jal	800040c4 <end_op>
    return -1;
    80004af6:	557d                	li	a0,-1
    80004af8:	b7e5                	j	80004ae0 <exec+0x6e>
    80004afa:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004afc:	8526                	mv	a0,s1
    80004afe:	fadfc0ef          	jal	80001aaa <proc_pagetable>
    80004b02:	8b2a                	mv	s6,a0
    80004b04:	2c050b63          	beqz	a0,80004dda <exec+0x368>
    80004b08:	f7ce                	sd	s3,488(sp)
    80004b0a:	efd6                	sd	s5,472(sp)
    80004b0c:	e7de                	sd	s7,456(sp)
    80004b0e:	e3e2                	sd	s8,448(sp)
    80004b10:	ff66                	sd	s9,440(sp)
    80004b12:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004b14:	e7042d03          	lw	s10,-400(s0)
    80004b18:	e8845783          	lhu	a5,-376(s0)
    80004b1c:	12078963          	beqz	a5,80004c4e <exec+0x1dc>
    80004b20:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004b22:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004b24:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004b26:	6c85                	lui	s9,0x1
    80004b28:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004b2c:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004b30:	6a85                	lui	s5,0x1
    80004b32:	a085                	j	80004b92 <exec+0x120>
      panic("loadseg: address should exist");
    80004b34:	00003517          	auipc	a0,0x3
    80004b38:	adc50513          	addi	a0,a0,-1316 # 80007610 <etext+0x610>
    80004b3c:	c67fb0ef          	jal	800007a2 <panic>
    if(sz - i < PGSIZE)
    80004b40:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004b42:	8726                	mv	a4,s1
    80004b44:	012c06bb          	addw	a3,s8,s2
    80004b48:	4581                	li	a1,0
    80004b4a:	8552                	mv	a0,s4
    80004b4c:	ecdfe0ef          	jal	80003a18 <readi>
    80004b50:	2501                	sext.w	a0,a0
    80004b52:	24a49a63          	bne	s1,a0,80004da6 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80004b56:	012a893b          	addw	s2,s5,s2
    80004b5a:	03397363          	bgeu	s2,s3,80004b80 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80004b5e:	02091593          	slli	a1,s2,0x20
    80004b62:	9181                	srli	a1,a1,0x20
    80004b64:	95de                	add	a1,a1,s7
    80004b66:	855a                	mv	a0,s6
    80004b68:	c7cfc0ef          	jal	80000fe4 <walkaddr>
    80004b6c:	862a                	mv	a2,a0
    if(pa == 0)
    80004b6e:	d179                	beqz	a0,80004b34 <exec+0xc2>
    if(sz - i < PGSIZE)
    80004b70:	412984bb          	subw	s1,s3,s2
    80004b74:	0004879b          	sext.w	a5,s1
    80004b78:	fcfcf4e3          	bgeu	s9,a5,80004b40 <exec+0xce>
    80004b7c:	84d6                	mv	s1,s5
    80004b7e:	b7c9                	j	80004b40 <exec+0xce>
    sz = sz1;
    80004b80:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004b84:	2d85                	addiw	s11,s11,1
    80004b86:	038d0d1b          	addiw	s10,s10,56
    80004b8a:	e8845783          	lhu	a5,-376(s0)
    80004b8e:	08fdd063          	bge	s11,a5,80004c0e <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004b92:	2d01                	sext.w	s10,s10
    80004b94:	03800713          	li	a4,56
    80004b98:	86ea                	mv	a3,s10
    80004b9a:	e1840613          	addi	a2,s0,-488
    80004b9e:	4581                	li	a1,0
    80004ba0:	8552                	mv	a0,s4
    80004ba2:	e77fe0ef          	jal	80003a18 <readi>
    80004ba6:	03800793          	li	a5,56
    80004baa:	1cf51663          	bne	a0,a5,80004d76 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004bae:	e1842783          	lw	a5,-488(s0)
    80004bb2:	4705                	li	a4,1
    80004bb4:	fce798e3          	bne	a5,a4,80004b84 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80004bb8:	e4043483          	ld	s1,-448(s0)
    80004bbc:	e3843783          	ld	a5,-456(s0)
    80004bc0:	1af4ef63          	bltu	s1,a5,80004d7e <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004bc4:	e2843783          	ld	a5,-472(s0)
    80004bc8:	94be                	add	s1,s1,a5
    80004bca:	1af4ee63          	bltu	s1,a5,80004d86 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80004bce:	df043703          	ld	a4,-528(s0)
    80004bd2:	8ff9                	and	a5,a5,a4
    80004bd4:	1a079d63          	bnez	a5,80004d8e <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004bd8:	e1c42503          	lw	a0,-484(s0)
    80004bdc:	e7dff0ef          	jal	80004a58 <flags2perm>
    80004be0:	86aa                	mv	a3,a0
    80004be2:	8626                	mv	a2,s1
    80004be4:	85ca                	mv	a1,s2
    80004be6:	855a                	mv	a0,s6
    80004be8:	f88fc0ef          	jal	80001370 <uvmalloc>
    80004bec:	e0a43423          	sd	a0,-504(s0)
    80004bf0:	1a050363          	beqz	a0,80004d96 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004bf4:	e2843b83          	ld	s7,-472(s0)
    80004bf8:	e2042c03          	lw	s8,-480(s0)
    80004bfc:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004c00:	00098463          	beqz	s3,80004c08 <exec+0x196>
    80004c04:	4901                	li	s2,0
    80004c06:	bfa1                	j	80004b5e <exec+0xec>
    sz = sz1;
    80004c08:	e0843903          	ld	s2,-504(s0)
    80004c0c:	bfa5                	j	80004b84 <exec+0x112>
    80004c0e:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004c10:	8552                	mv	a0,s4
    80004c12:	dbdfe0ef          	jal	800039ce <iunlockput>
  end_op();
    80004c16:	caeff0ef          	jal	800040c4 <end_op>
  p = myproc();
    80004c1a:	cf9fc0ef          	jal	80001912 <myproc>
    80004c1e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004c20:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004c24:	6985                	lui	s3,0x1
    80004c26:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004c28:	99ca                	add	s3,s3,s2
    80004c2a:	77fd                	lui	a5,0xfffff
    80004c2c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004c30:	4691                	li	a3,4
    80004c32:	6609                	lui	a2,0x2
    80004c34:	964e                	add	a2,a2,s3
    80004c36:	85ce                	mv	a1,s3
    80004c38:	855a                	mv	a0,s6
    80004c3a:	f36fc0ef          	jal	80001370 <uvmalloc>
    80004c3e:	892a                	mv	s2,a0
    80004c40:	e0a43423          	sd	a0,-504(s0)
    80004c44:	e519                	bnez	a0,80004c52 <exec+0x1e0>
  if(pagetable)
    80004c46:	e1343423          	sd	s3,-504(s0)
    80004c4a:	4a01                	li	s4,0
    80004c4c:	aab1                	j	80004da8 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004c4e:	4901                	li	s2,0
    80004c50:	b7c1                	j	80004c10 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004c52:	75f9                	lui	a1,0xffffe
    80004c54:	95aa                	add	a1,a1,a0
    80004c56:	855a                	mv	a0,s6
    80004c58:	903fc0ef          	jal	8000155a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004c5c:	7bfd                	lui	s7,0xfffff
    80004c5e:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004c60:	e0043783          	ld	a5,-512(s0)
    80004c64:	6388                	ld	a0,0(a5)
    80004c66:	cd39                	beqz	a0,80004cc4 <exec+0x252>
    80004c68:	e9040993          	addi	s3,s0,-368
    80004c6c:	f9040c13          	addi	s8,s0,-112
    80004c70:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004c72:	9d4fc0ef          	jal	80000e46 <strlen>
    80004c76:	0015079b          	addiw	a5,a0,1
    80004c7a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004c7e:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004c82:	11796e63          	bltu	s2,s7,80004d9e <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004c86:	e0043d03          	ld	s10,-512(s0)
    80004c8a:	000d3a03          	ld	s4,0(s10)
    80004c8e:	8552                	mv	a0,s4
    80004c90:	9b6fc0ef          	jal	80000e46 <strlen>
    80004c94:	0015069b          	addiw	a3,a0,1
    80004c98:	8652                	mv	a2,s4
    80004c9a:	85ca                	mv	a1,s2
    80004c9c:	855a                	mv	a0,s6
    80004c9e:	8e7fc0ef          	jal	80001584 <copyout>
    80004ca2:	10054063          	bltz	a0,80004da2 <exec+0x330>
    ustack[argc] = sp;
    80004ca6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004caa:	0485                	addi	s1,s1,1
    80004cac:	008d0793          	addi	a5,s10,8
    80004cb0:	e0f43023          	sd	a5,-512(s0)
    80004cb4:	008d3503          	ld	a0,8(s10)
    80004cb8:	c909                	beqz	a0,80004cca <exec+0x258>
    if(argc >= MAXARG)
    80004cba:	09a1                	addi	s3,s3,8
    80004cbc:	fb899be3          	bne	s3,s8,80004c72 <exec+0x200>
  ip = 0;
    80004cc0:	4a01                	li	s4,0
    80004cc2:	a0dd                	j	80004da8 <exec+0x336>
  sp = sz;
    80004cc4:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004cc8:	4481                	li	s1,0
  ustack[argc] = 0;
    80004cca:	00349793          	slli	a5,s1,0x3
    80004cce:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb0e0>
    80004cd2:	97a2                	add	a5,a5,s0
    80004cd4:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004cd8:	00148693          	addi	a3,s1,1
    80004cdc:	068e                	slli	a3,a3,0x3
    80004cde:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004ce2:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004ce6:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004cea:	f5796ee3          	bltu	s2,s7,80004c46 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004cee:	e9040613          	addi	a2,s0,-368
    80004cf2:	85ca                	mv	a1,s2
    80004cf4:	855a                	mv	a0,s6
    80004cf6:	88ffc0ef          	jal	80001584 <copyout>
    80004cfa:	0e054263          	bltz	a0,80004dde <exec+0x36c>
  p->trapframe->a1 = sp;
    80004cfe:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004d02:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004d06:	df843783          	ld	a5,-520(s0)
    80004d0a:	0007c703          	lbu	a4,0(a5)
    80004d0e:	cf11                	beqz	a4,80004d2a <exec+0x2b8>
    80004d10:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004d12:	02f00693          	li	a3,47
    80004d16:	a039                	j	80004d24 <exec+0x2b2>
      last = s+1;
    80004d18:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004d1c:	0785                	addi	a5,a5,1
    80004d1e:	fff7c703          	lbu	a4,-1(a5)
    80004d22:	c701                	beqz	a4,80004d2a <exec+0x2b8>
    if(*s == '/')
    80004d24:	fed71ce3          	bne	a4,a3,80004d1c <exec+0x2aa>
    80004d28:	bfc5                	j	80004d18 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004d2a:	4641                	li	a2,16
    80004d2c:	df843583          	ld	a1,-520(s0)
    80004d30:	158a8513          	addi	a0,s5,344
    80004d34:	8e0fc0ef          	jal	80000e14 <safestrcpy>
  oldpagetable = p->pagetable;
    80004d38:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004d3c:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004d40:	e0843783          	ld	a5,-504(s0)
    80004d44:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004d48:	058ab783          	ld	a5,88(s5)
    80004d4c:	e6843703          	ld	a4,-408(s0)
    80004d50:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004d52:	058ab783          	ld	a5,88(s5)
    80004d56:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004d5a:	85e6                	mv	a1,s9
    80004d5c:	dd3fc0ef          	jal	80001b2e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004d60:	0004851b          	sext.w	a0,s1
    80004d64:	79be                	ld	s3,488(sp)
    80004d66:	7a1e                	ld	s4,480(sp)
    80004d68:	6afe                	ld	s5,472(sp)
    80004d6a:	6b5e                	ld	s6,464(sp)
    80004d6c:	6bbe                	ld	s7,456(sp)
    80004d6e:	6c1e                	ld	s8,448(sp)
    80004d70:	7cfa                	ld	s9,440(sp)
    80004d72:	7d5a                	ld	s10,432(sp)
    80004d74:	b3b5                	j	80004ae0 <exec+0x6e>
    80004d76:	e1243423          	sd	s2,-504(s0)
    80004d7a:	7dba                	ld	s11,424(sp)
    80004d7c:	a035                	j	80004da8 <exec+0x336>
    80004d7e:	e1243423          	sd	s2,-504(s0)
    80004d82:	7dba                	ld	s11,424(sp)
    80004d84:	a015                	j	80004da8 <exec+0x336>
    80004d86:	e1243423          	sd	s2,-504(s0)
    80004d8a:	7dba                	ld	s11,424(sp)
    80004d8c:	a831                	j	80004da8 <exec+0x336>
    80004d8e:	e1243423          	sd	s2,-504(s0)
    80004d92:	7dba                	ld	s11,424(sp)
    80004d94:	a811                	j	80004da8 <exec+0x336>
    80004d96:	e1243423          	sd	s2,-504(s0)
    80004d9a:	7dba                	ld	s11,424(sp)
    80004d9c:	a031                	j	80004da8 <exec+0x336>
  ip = 0;
    80004d9e:	4a01                	li	s4,0
    80004da0:	a021                	j	80004da8 <exec+0x336>
    80004da2:	4a01                	li	s4,0
  if(pagetable)
    80004da4:	a011                	j	80004da8 <exec+0x336>
    80004da6:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004da8:	e0843583          	ld	a1,-504(s0)
    80004dac:	855a                	mv	a0,s6
    80004dae:	d81fc0ef          	jal	80001b2e <proc_freepagetable>
  return -1;
    80004db2:	557d                	li	a0,-1
  if(ip){
    80004db4:	000a1b63          	bnez	s4,80004dca <exec+0x358>
    80004db8:	79be                	ld	s3,488(sp)
    80004dba:	7a1e                	ld	s4,480(sp)
    80004dbc:	6afe                	ld	s5,472(sp)
    80004dbe:	6b5e                	ld	s6,464(sp)
    80004dc0:	6bbe                	ld	s7,456(sp)
    80004dc2:	6c1e                	ld	s8,448(sp)
    80004dc4:	7cfa                	ld	s9,440(sp)
    80004dc6:	7d5a                	ld	s10,432(sp)
    80004dc8:	bb21                	j	80004ae0 <exec+0x6e>
    80004dca:	79be                	ld	s3,488(sp)
    80004dcc:	6afe                	ld	s5,472(sp)
    80004dce:	6b5e                	ld	s6,464(sp)
    80004dd0:	6bbe                	ld	s7,456(sp)
    80004dd2:	6c1e                	ld	s8,448(sp)
    80004dd4:	7cfa                	ld	s9,440(sp)
    80004dd6:	7d5a                	ld	s10,432(sp)
    80004dd8:	b9ed                	j	80004ad2 <exec+0x60>
    80004dda:	6b5e                	ld	s6,464(sp)
    80004ddc:	b9dd                	j	80004ad2 <exec+0x60>
  sz = sz1;
    80004dde:	e0843983          	ld	s3,-504(s0)
    80004de2:	b595                	j	80004c46 <exec+0x1d4>

0000000080004de4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004de4:	7179                	addi	sp,sp,-48
    80004de6:	f406                	sd	ra,40(sp)
    80004de8:	f022                	sd	s0,32(sp)
    80004dea:	ec26                	sd	s1,24(sp)
    80004dec:	e84a                	sd	s2,16(sp)
    80004dee:	1800                	addi	s0,sp,48
    80004df0:	892e                	mv	s2,a1
    80004df2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004df4:	fdc40593          	addi	a1,s0,-36
    80004df8:	e31fd0ef          	jal	80002c28 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004dfc:	fdc42703          	lw	a4,-36(s0)
    80004e00:	47bd                	li	a5,15
    80004e02:	02e7e963          	bltu	a5,a4,80004e34 <argfd+0x50>
    80004e06:	b0dfc0ef          	jal	80001912 <myproc>
    80004e0a:	fdc42703          	lw	a4,-36(s0)
    80004e0e:	01a70793          	addi	a5,a4,26
    80004e12:	078e                	slli	a5,a5,0x3
    80004e14:	953e                	add	a0,a0,a5
    80004e16:	611c                	ld	a5,0(a0)
    80004e18:	c385                	beqz	a5,80004e38 <argfd+0x54>
    return -1;
  if(pfd)
    80004e1a:	00090463          	beqz	s2,80004e22 <argfd+0x3e>
    *pfd = fd;
    80004e1e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004e22:	4501                	li	a0,0
  if(pf)
    80004e24:	c091                	beqz	s1,80004e28 <argfd+0x44>
    *pf = f;
    80004e26:	e09c                	sd	a5,0(s1)
}
    80004e28:	70a2                	ld	ra,40(sp)
    80004e2a:	7402                	ld	s0,32(sp)
    80004e2c:	64e2                	ld	s1,24(sp)
    80004e2e:	6942                	ld	s2,16(sp)
    80004e30:	6145                	addi	sp,sp,48
    80004e32:	8082                	ret
    return -1;
    80004e34:	557d                	li	a0,-1
    80004e36:	bfcd                	j	80004e28 <argfd+0x44>
    80004e38:	557d                	li	a0,-1
    80004e3a:	b7fd                	j	80004e28 <argfd+0x44>

0000000080004e3c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004e3c:	1101                	addi	sp,sp,-32
    80004e3e:	ec06                	sd	ra,24(sp)
    80004e40:	e822                	sd	s0,16(sp)
    80004e42:	e426                	sd	s1,8(sp)
    80004e44:	1000                	addi	s0,sp,32
    80004e46:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004e48:	acbfc0ef          	jal	80001912 <myproc>
    80004e4c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004e4e:	0d050793          	addi	a5,a0,208
    80004e52:	4501                	li	a0,0
    80004e54:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004e56:	6398                	ld	a4,0(a5)
    80004e58:	cb19                	beqz	a4,80004e6e <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004e5a:	2505                	addiw	a0,a0,1
    80004e5c:	07a1                	addi	a5,a5,8
    80004e5e:	fed51ce3          	bne	a0,a3,80004e56 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004e62:	557d                	li	a0,-1
}
    80004e64:	60e2                	ld	ra,24(sp)
    80004e66:	6442                	ld	s0,16(sp)
    80004e68:	64a2                	ld	s1,8(sp)
    80004e6a:	6105                	addi	sp,sp,32
    80004e6c:	8082                	ret
      p->ofile[fd] = f;
    80004e6e:	01a50793          	addi	a5,a0,26
    80004e72:	078e                	slli	a5,a5,0x3
    80004e74:	963e                	add	a2,a2,a5
    80004e76:	e204                	sd	s1,0(a2)
      return fd;
    80004e78:	b7f5                	j	80004e64 <fdalloc+0x28>

0000000080004e7a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004e7a:	715d                	addi	sp,sp,-80
    80004e7c:	e486                	sd	ra,72(sp)
    80004e7e:	e0a2                	sd	s0,64(sp)
    80004e80:	fc26                	sd	s1,56(sp)
    80004e82:	f84a                	sd	s2,48(sp)
    80004e84:	f44e                	sd	s3,40(sp)
    80004e86:	ec56                	sd	s5,24(sp)
    80004e88:	e85a                	sd	s6,16(sp)
    80004e8a:	0880                	addi	s0,sp,80
    80004e8c:	8b2e                	mv	s6,a1
    80004e8e:	89b2                	mv	s3,a2
    80004e90:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004e92:	fb040593          	addi	a1,s0,-80
    80004e96:	822ff0ef          	jal	80003eb8 <nameiparent>
    80004e9a:	84aa                	mv	s1,a0
    80004e9c:	10050a63          	beqz	a0,80004fb0 <create+0x136>
    return 0;

  ilock(dp);
    80004ea0:	925fe0ef          	jal	800037c4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004ea4:	4601                	li	a2,0
    80004ea6:	fb040593          	addi	a1,s0,-80
    80004eaa:	8526                	mv	a0,s1
    80004eac:	d8dfe0ef          	jal	80003c38 <dirlookup>
    80004eb0:	8aaa                	mv	s5,a0
    80004eb2:	c129                	beqz	a0,80004ef4 <create+0x7a>
    iunlockput(dp);
    80004eb4:	8526                	mv	a0,s1
    80004eb6:	b19fe0ef          	jal	800039ce <iunlockput>
    ilock(ip);
    80004eba:	8556                	mv	a0,s5
    80004ebc:	909fe0ef          	jal	800037c4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004ec0:	4789                	li	a5,2
    80004ec2:	02fb1463          	bne	s6,a5,80004eea <create+0x70>
    80004ec6:	044ad783          	lhu	a5,68(s5)
    80004eca:	37f9                	addiw	a5,a5,-2
    80004ecc:	17c2                	slli	a5,a5,0x30
    80004ece:	93c1                	srli	a5,a5,0x30
    80004ed0:	4705                	li	a4,1
    80004ed2:	00f76c63          	bltu	a4,a5,80004eea <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004ed6:	8556                	mv	a0,s5
    80004ed8:	60a6                	ld	ra,72(sp)
    80004eda:	6406                	ld	s0,64(sp)
    80004edc:	74e2                	ld	s1,56(sp)
    80004ede:	7942                	ld	s2,48(sp)
    80004ee0:	79a2                	ld	s3,40(sp)
    80004ee2:	6ae2                	ld	s5,24(sp)
    80004ee4:	6b42                	ld	s6,16(sp)
    80004ee6:	6161                	addi	sp,sp,80
    80004ee8:	8082                	ret
    iunlockput(ip);
    80004eea:	8556                	mv	a0,s5
    80004eec:	ae3fe0ef          	jal	800039ce <iunlockput>
    return 0;
    80004ef0:	4a81                	li	s5,0
    80004ef2:	b7d5                	j	80004ed6 <create+0x5c>
    80004ef4:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004ef6:	85da                	mv	a1,s6
    80004ef8:	4088                	lw	a0,0(s1)
    80004efa:	f5afe0ef          	jal	80003654 <ialloc>
    80004efe:	8a2a                	mv	s4,a0
    80004f00:	cd15                	beqz	a0,80004f3c <create+0xc2>
  ilock(ip);
    80004f02:	8c3fe0ef          	jal	800037c4 <ilock>
  ip->major = major;
    80004f06:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004f0a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004f0e:	4905                	li	s2,1
    80004f10:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004f14:	8552                	mv	a0,s4
    80004f16:	ffafe0ef          	jal	80003710 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004f1a:	032b0763          	beq	s6,s2,80004f48 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004f1e:	004a2603          	lw	a2,4(s4)
    80004f22:	fb040593          	addi	a1,s0,-80
    80004f26:	8526                	mv	a0,s1
    80004f28:	eddfe0ef          	jal	80003e04 <dirlink>
    80004f2c:	06054563          	bltz	a0,80004f96 <create+0x11c>
  iunlockput(dp);
    80004f30:	8526                	mv	a0,s1
    80004f32:	a9dfe0ef          	jal	800039ce <iunlockput>
  return ip;
    80004f36:	8ad2                	mv	s5,s4
    80004f38:	7a02                	ld	s4,32(sp)
    80004f3a:	bf71                	j	80004ed6 <create+0x5c>
    iunlockput(dp);
    80004f3c:	8526                	mv	a0,s1
    80004f3e:	a91fe0ef          	jal	800039ce <iunlockput>
    return 0;
    80004f42:	8ad2                	mv	s5,s4
    80004f44:	7a02                	ld	s4,32(sp)
    80004f46:	bf41                	j	80004ed6 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004f48:	004a2603          	lw	a2,4(s4)
    80004f4c:	00002597          	auipc	a1,0x2
    80004f50:	6e458593          	addi	a1,a1,1764 # 80007630 <etext+0x630>
    80004f54:	8552                	mv	a0,s4
    80004f56:	eaffe0ef          	jal	80003e04 <dirlink>
    80004f5a:	02054e63          	bltz	a0,80004f96 <create+0x11c>
    80004f5e:	40d0                	lw	a2,4(s1)
    80004f60:	00002597          	auipc	a1,0x2
    80004f64:	6d858593          	addi	a1,a1,1752 # 80007638 <etext+0x638>
    80004f68:	8552                	mv	a0,s4
    80004f6a:	e9bfe0ef          	jal	80003e04 <dirlink>
    80004f6e:	02054463          	bltz	a0,80004f96 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004f72:	004a2603          	lw	a2,4(s4)
    80004f76:	fb040593          	addi	a1,s0,-80
    80004f7a:	8526                	mv	a0,s1
    80004f7c:	e89fe0ef          	jal	80003e04 <dirlink>
    80004f80:	00054b63          	bltz	a0,80004f96 <create+0x11c>
    dp->nlink++;  // for ".."
    80004f84:	04a4d783          	lhu	a5,74(s1)
    80004f88:	2785                	addiw	a5,a5,1
    80004f8a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004f8e:	8526                	mv	a0,s1
    80004f90:	f80fe0ef          	jal	80003710 <iupdate>
    80004f94:	bf71                	j	80004f30 <create+0xb6>
  ip->nlink = 0;
    80004f96:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004f9a:	8552                	mv	a0,s4
    80004f9c:	f74fe0ef          	jal	80003710 <iupdate>
  iunlockput(ip);
    80004fa0:	8552                	mv	a0,s4
    80004fa2:	a2dfe0ef          	jal	800039ce <iunlockput>
  iunlockput(dp);
    80004fa6:	8526                	mv	a0,s1
    80004fa8:	a27fe0ef          	jal	800039ce <iunlockput>
  return 0;
    80004fac:	7a02                	ld	s4,32(sp)
    80004fae:	b725                	j	80004ed6 <create+0x5c>
    return 0;
    80004fb0:	8aaa                	mv	s5,a0
    80004fb2:	b715                	j	80004ed6 <create+0x5c>

0000000080004fb4 <sys_dup>:
{
    80004fb4:	7179                	addi	sp,sp,-48
    80004fb6:	f406                	sd	ra,40(sp)
    80004fb8:	f022                	sd	s0,32(sp)
    80004fba:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004fbc:	fd840613          	addi	a2,s0,-40
    80004fc0:	4581                	li	a1,0
    80004fc2:	4501                	li	a0,0
    80004fc4:	e21ff0ef          	jal	80004de4 <argfd>
    return -1;
    80004fc8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004fca:	02054363          	bltz	a0,80004ff0 <sys_dup+0x3c>
    80004fce:	ec26                	sd	s1,24(sp)
    80004fd0:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004fd2:	fd843903          	ld	s2,-40(s0)
    80004fd6:	854a                	mv	a0,s2
    80004fd8:	e65ff0ef          	jal	80004e3c <fdalloc>
    80004fdc:	84aa                	mv	s1,a0
    return -1;
    80004fde:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004fe0:	00054d63          	bltz	a0,80004ffa <sys_dup+0x46>
  filedup(f);
    80004fe4:	854a                	mv	a0,s2
    80004fe6:	c48ff0ef          	jal	8000442e <filedup>
  return fd;
    80004fea:	87a6                	mv	a5,s1
    80004fec:	64e2                	ld	s1,24(sp)
    80004fee:	6942                	ld	s2,16(sp)
}
    80004ff0:	853e                	mv	a0,a5
    80004ff2:	70a2                	ld	ra,40(sp)
    80004ff4:	7402                	ld	s0,32(sp)
    80004ff6:	6145                	addi	sp,sp,48
    80004ff8:	8082                	ret
    80004ffa:	64e2                	ld	s1,24(sp)
    80004ffc:	6942                	ld	s2,16(sp)
    80004ffe:	bfcd                	j	80004ff0 <sys_dup+0x3c>

0000000080005000 <sys_read>:
{
    80005000:	7179                	addi	sp,sp,-48
    80005002:	f406                	sd	ra,40(sp)
    80005004:	f022                	sd	s0,32(sp)
    80005006:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005008:	fd840593          	addi	a1,s0,-40
    8000500c:	4505                	li	a0,1
    8000500e:	c37fd0ef          	jal	80002c44 <argaddr>
  argint(2, &n);
    80005012:	fe440593          	addi	a1,s0,-28
    80005016:	4509                	li	a0,2
    80005018:	c11fd0ef          	jal	80002c28 <argint>
  if(argfd(0, 0, &f) < 0)
    8000501c:	fe840613          	addi	a2,s0,-24
    80005020:	4581                	li	a1,0
    80005022:	4501                	li	a0,0
    80005024:	dc1ff0ef          	jal	80004de4 <argfd>
    80005028:	87aa                	mv	a5,a0
    return -1;
    8000502a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000502c:	0007ca63          	bltz	a5,80005040 <sys_read+0x40>
  return fileread(f, p, n);
    80005030:	fe442603          	lw	a2,-28(s0)
    80005034:	fd843583          	ld	a1,-40(s0)
    80005038:	fe843503          	ld	a0,-24(s0)
    8000503c:	d58ff0ef          	jal	80004594 <fileread>
}
    80005040:	70a2                	ld	ra,40(sp)
    80005042:	7402                	ld	s0,32(sp)
    80005044:	6145                	addi	sp,sp,48
    80005046:	8082                	ret

0000000080005048 <sys_write>:
{
    80005048:	7179                	addi	sp,sp,-48
    8000504a:	f406                	sd	ra,40(sp)
    8000504c:	f022                	sd	s0,32(sp)
    8000504e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005050:	fd840593          	addi	a1,s0,-40
    80005054:	4505                	li	a0,1
    80005056:	beffd0ef          	jal	80002c44 <argaddr>
  argint(2, &n);
    8000505a:	fe440593          	addi	a1,s0,-28
    8000505e:	4509                	li	a0,2
    80005060:	bc9fd0ef          	jal	80002c28 <argint>
  if(argfd(0, 0, &f) < 0)
    80005064:	fe840613          	addi	a2,s0,-24
    80005068:	4581                	li	a1,0
    8000506a:	4501                	li	a0,0
    8000506c:	d79ff0ef          	jal	80004de4 <argfd>
    80005070:	87aa                	mv	a5,a0
    return -1;
    80005072:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005074:	0007ca63          	bltz	a5,80005088 <sys_write+0x40>
  return filewrite(f, p, n);
    80005078:	fe442603          	lw	a2,-28(s0)
    8000507c:	fd843583          	ld	a1,-40(s0)
    80005080:	fe843503          	ld	a0,-24(s0)
    80005084:	dceff0ef          	jal	80004652 <filewrite>
}
    80005088:	70a2                	ld	ra,40(sp)
    8000508a:	7402                	ld	s0,32(sp)
    8000508c:	6145                	addi	sp,sp,48
    8000508e:	8082                	ret

0000000080005090 <sys_close>:
{
    80005090:	1101                	addi	sp,sp,-32
    80005092:	ec06                	sd	ra,24(sp)
    80005094:	e822                	sd	s0,16(sp)
    80005096:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005098:	fe040613          	addi	a2,s0,-32
    8000509c:	fec40593          	addi	a1,s0,-20
    800050a0:	4501                	li	a0,0
    800050a2:	d43ff0ef          	jal	80004de4 <argfd>
    return -1;
    800050a6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800050a8:	02054063          	bltz	a0,800050c8 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    800050ac:	867fc0ef          	jal	80001912 <myproc>
    800050b0:	fec42783          	lw	a5,-20(s0)
    800050b4:	07e9                	addi	a5,a5,26
    800050b6:	078e                	slli	a5,a5,0x3
    800050b8:	953e                	add	a0,a0,a5
    800050ba:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800050be:	fe043503          	ld	a0,-32(s0)
    800050c2:	bb2ff0ef          	jal	80004474 <fileclose>
  return 0;
    800050c6:	4781                	li	a5,0
}
    800050c8:	853e                	mv	a0,a5
    800050ca:	60e2                	ld	ra,24(sp)
    800050cc:	6442                	ld	s0,16(sp)
    800050ce:	6105                	addi	sp,sp,32
    800050d0:	8082                	ret

00000000800050d2 <sys_fstat>:
{
    800050d2:	1101                	addi	sp,sp,-32
    800050d4:	ec06                	sd	ra,24(sp)
    800050d6:	e822                	sd	s0,16(sp)
    800050d8:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800050da:	fe040593          	addi	a1,s0,-32
    800050de:	4505                	li	a0,1
    800050e0:	b65fd0ef          	jal	80002c44 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800050e4:	fe840613          	addi	a2,s0,-24
    800050e8:	4581                	li	a1,0
    800050ea:	4501                	li	a0,0
    800050ec:	cf9ff0ef          	jal	80004de4 <argfd>
    800050f0:	87aa                	mv	a5,a0
    return -1;
    800050f2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800050f4:	0007c863          	bltz	a5,80005104 <sys_fstat+0x32>
  return filestat(f, st);
    800050f8:	fe043583          	ld	a1,-32(s0)
    800050fc:	fe843503          	ld	a0,-24(s0)
    80005100:	c36ff0ef          	jal	80004536 <filestat>
}
    80005104:	60e2                	ld	ra,24(sp)
    80005106:	6442                	ld	s0,16(sp)
    80005108:	6105                	addi	sp,sp,32
    8000510a:	8082                	ret

000000008000510c <sys_link>:
{
    8000510c:	7169                	addi	sp,sp,-304
    8000510e:	f606                	sd	ra,296(sp)
    80005110:	f222                	sd	s0,288(sp)
    80005112:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005114:	08000613          	li	a2,128
    80005118:	ed040593          	addi	a1,s0,-304
    8000511c:	4501                	li	a0,0
    8000511e:	b45fd0ef          	jal	80002c62 <argstr>
    return -1;
    80005122:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005124:	0c054e63          	bltz	a0,80005200 <sys_link+0xf4>
    80005128:	08000613          	li	a2,128
    8000512c:	f5040593          	addi	a1,s0,-176
    80005130:	4505                	li	a0,1
    80005132:	b31fd0ef          	jal	80002c62 <argstr>
    return -1;
    80005136:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005138:	0c054463          	bltz	a0,80005200 <sys_link+0xf4>
    8000513c:	ee26                	sd	s1,280(sp)
  begin_op();
    8000513e:	f1dfe0ef          	jal	8000405a <begin_op>
  if((ip = namei(old)) == 0){
    80005142:	ed040513          	addi	a0,s0,-304
    80005146:	d59fe0ef          	jal	80003e9e <namei>
    8000514a:	84aa                	mv	s1,a0
    8000514c:	c53d                	beqz	a0,800051ba <sys_link+0xae>
  ilock(ip);
    8000514e:	e76fe0ef          	jal	800037c4 <ilock>
  if(ip->type == T_DIR){
    80005152:	04449703          	lh	a4,68(s1)
    80005156:	4785                	li	a5,1
    80005158:	06f70663          	beq	a4,a5,800051c4 <sys_link+0xb8>
    8000515c:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000515e:	04a4d783          	lhu	a5,74(s1)
    80005162:	2785                	addiw	a5,a5,1
    80005164:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005168:	8526                	mv	a0,s1
    8000516a:	da6fe0ef          	jal	80003710 <iupdate>
  iunlock(ip);
    8000516e:	8526                	mv	a0,s1
    80005170:	f02fe0ef          	jal	80003872 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005174:	fd040593          	addi	a1,s0,-48
    80005178:	f5040513          	addi	a0,s0,-176
    8000517c:	d3dfe0ef          	jal	80003eb8 <nameiparent>
    80005180:	892a                	mv	s2,a0
    80005182:	cd21                	beqz	a0,800051da <sys_link+0xce>
  ilock(dp);
    80005184:	e40fe0ef          	jal	800037c4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005188:	00092703          	lw	a4,0(s2)
    8000518c:	409c                	lw	a5,0(s1)
    8000518e:	04f71363          	bne	a4,a5,800051d4 <sys_link+0xc8>
    80005192:	40d0                	lw	a2,4(s1)
    80005194:	fd040593          	addi	a1,s0,-48
    80005198:	854a                	mv	a0,s2
    8000519a:	c6bfe0ef          	jal	80003e04 <dirlink>
    8000519e:	02054b63          	bltz	a0,800051d4 <sys_link+0xc8>
  iunlockput(dp);
    800051a2:	854a                	mv	a0,s2
    800051a4:	82bfe0ef          	jal	800039ce <iunlockput>
  iput(ip);
    800051a8:	8526                	mv	a0,s1
    800051aa:	f9cfe0ef          	jal	80003946 <iput>
  end_op();
    800051ae:	f17fe0ef          	jal	800040c4 <end_op>
  return 0;
    800051b2:	4781                	li	a5,0
    800051b4:	64f2                	ld	s1,280(sp)
    800051b6:	6952                	ld	s2,272(sp)
    800051b8:	a0a1                	j	80005200 <sys_link+0xf4>
    end_op();
    800051ba:	f0bfe0ef          	jal	800040c4 <end_op>
    return -1;
    800051be:	57fd                	li	a5,-1
    800051c0:	64f2                	ld	s1,280(sp)
    800051c2:	a83d                	j	80005200 <sys_link+0xf4>
    iunlockput(ip);
    800051c4:	8526                	mv	a0,s1
    800051c6:	809fe0ef          	jal	800039ce <iunlockput>
    end_op();
    800051ca:	efbfe0ef          	jal	800040c4 <end_op>
    return -1;
    800051ce:	57fd                	li	a5,-1
    800051d0:	64f2                	ld	s1,280(sp)
    800051d2:	a03d                	j	80005200 <sys_link+0xf4>
    iunlockput(dp);
    800051d4:	854a                	mv	a0,s2
    800051d6:	ff8fe0ef          	jal	800039ce <iunlockput>
  ilock(ip);
    800051da:	8526                	mv	a0,s1
    800051dc:	de8fe0ef          	jal	800037c4 <ilock>
  ip->nlink--;
    800051e0:	04a4d783          	lhu	a5,74(s1)
    800051e4:	37fd                	addiw	a5,a5,-1
    800051e6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800051ea:	8526                	mv	a0,s1
    800051ec:	d24fe0ef          	jal	80003710 <iupdate>
  iunlockput(ip);
    800051f0:	8526                	mv	a0,s1
    800051f2:	fdcfe0ef          	jal	800039ce <iunlockput>
  end_op();
    800051f6:	ecffe0ef          	jal	800040c4 <end_op>
  return -1;
    800051fa:	57fd                	li	a5,-1
    800051fc:	64f2                	ld	s1,280(sp)
    800051fe:	6952                	ld	s2,272(sp)
}
    80005200:	853e                	mv	a0,a5
    80005202:	70b2                	ld	ra,296(sp)
    80005204:	7412                	ld	s0,288(sp)
    80005206:	6155                	addi	sp,sp,304
    80005208:	8082                	ret

000000008000520a <sys_unlink>:
{
    8000520a:	7151                	addi	sp,sp,-240
    8000520c:	f586                	sd	ra,232(sp)
    8000520e:	f1a2                	sd	s0,224(sp)
    80005210:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005212:	08000613          	li	a2,128
    80005216:	f3040593          	addi	a1,s0,-208
    8000521a:	4501                	li	a0,0
    8000521c:	a47fd0ef          	jal	80002c62 <argstr>
    80005220:	16054063          	bltz	a0,80005380 <sys_unlink+0x176>
    80005224:	eda6                	sd	s1,216(sp)
  begin_op();
    80005226:	e35fe0ef          	jal	8000405a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000522a:	fb040593          	addi	a1,s0,-80
    8000522e:	f3040513          	addi	a0,s0,-208
    80005232:	c87fe0ef          	jal	80003eb8 <nameiparent>
    80005236:	84aa                	mv	s1,a0
    80005238:	c945                	beqz	a0,800052e8 <sys_unlink+0xde>
  ilock(dp);
    8000523a:	d8afe0ef          	jal	800037c4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000523e:	00002597          	auipc	a1,0x2
    80005242:	3f258593          	addi	a1,a1,1010 # 80007630 <etext+0x630>
    80005246:	fb040513          	addi	a0,s0,-80
    8000524a:	9d9fe0ef          	jal	80003c22 <namecmp>
    8000524e:	10050e63          	beqz	a0,8000536a <sys_unlink+0x160>
    80005252:	00002597          	auipc	a1,0x2
    80005256:	3e658593          	addi	a1,a1,998 # 80007638 <etext+0x638>
    8000525a:	fb040513          	addi	a0,s0,-80
    8000525e:	9c5fe0ef          	jal	80003c22 <namecmp>
    80005262:	10050463          	beqz	a0,8000536a <sys_unlink+0x160>
    80005266:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005268:	f2c40613          	addi	a2,s0,-212
    8000526c:	fb040593          	addi	a1,s0,-80
    80005270:	8526                	mv	a0,s1
    80005272:	9c7fe0ef          	jal	80003c38 <dirlookup>
    80005276:	892a                	mv	s2,a0
    80005278:	0e050863          	beqz	a0,80005368 <sys_unlink+0x15e>
  ilock(ip);
    8000527c:	d48fe0ef          	jal	800037c4 <ilock>
  if(ip->nlink < 1)
    80005280:	04a91783          	lh	a5,74(s2)
    80005284:	06f05763          	blez	a5,800052f2 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005288:	04491703          	lh	a4,68(s2)
    8000528c:	4785                	li	a5,1
    8000528e:	06f70963          	beq	a4,a5,80005300 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80005292:	4641                	li	a2,16
    80005294:	4581                	li	a1,0
    80005296:	fc040513          	addi	a0,s0,-64
    8000529a:	a3dfb0ef          	jal	80000cd6 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000529e:	4741                	li	a4,16
    800052a0:	f2c42683          	lw	a3,-212(s0)
    800052a4:	fc040613          	addi	a2,s0,-64
    800052a8:	4581                	li	a1,0
    800052aa:	8526                	mv	a0,s1
    800052ac:	869fe0ef          	jal	80003b14 <writei>
    800052b0:	47c1                	li	a5,16
    800052b2:	08f51b63          	bne	a0,a5,80005348 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    800052b6:	04491703          	lh	a4,68(s2)
    800052ba:	4785                	li	a5,1
    800052bc:	08f70d63          	beq	a4,a5,80005356 <sys_unlink+0x14c>
  iunlockput(dp);
    800052c0:	8526                	mv	a0,s1
    800052c2:	f0cfe0ef          	jal	800039ce <iunlockput>
  ip->nlink--;
    800052c6:	04a95783          	lhu	a5,74(s2)
    800052ca:	37fd                	addiw	a5,a5,-1
    800052cc:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800052d0:	854a                	mv	a0,s2
    800052d2:	c3efe0ef          	jal	80003710 <iupdate>
  iunlockput(ip);
    800052d6:	854a                	mv	a0,s2
    800052d8:	ef6fe0ef          	jal	800039ce <iunlockput>
  end_op();
    800052dc:	de9fe0ef          	jal	800040c4 <end_op>
  return 0;
    800052e0:	4501                	li	a0,0
    800052e2:	64ee                	ld	s1,216(sp)
    800052e4:	694e                	ld	s2,208(sp)
    800052e6:	a849                	j	80005378 <sys_unlink+0x16e>
    end_op();
    800052e8:	dddfe0ef          	jal	800040c4 <end_op>
    return -1;
    800052ec:	557d                	li	a0,-1
    800052ee:	64ee                	ld	s1,216(sp)
    800052f0:	a061                	j	80005378 <sys_unlink+0x16e>
    800052f2:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    800052f4:	00002517          	auipc	a0,0x2
    800052f8:	34c50513          	addi	a0,a0,844 # 80007640 <etext+0x640>
    800052fc:	ca6fb0ef          	jal	800007a2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005300:	04c92703          	lw	a4,76(s2)
    80005304:	02000793          	li	a5,32
    80005308:	f8e7f5e3          	bgeu	a5,a4,80005292 <sys_unlink+0x88>
    8000530c:	e5ce                	sd	s3,200(sp)
    8000530e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005312:	4741                	li	a4,16
    80005314:	86ce                	mv	a3,s3
    80005316:	f1840613          	addi	a2,s0,-232
    8000531a:	4581                	li	a1,0
    8000531c:	854a                	mv	a0,s2
    8000531e:	efafe0ef          	jal	80003a18 <readi>
    80005322:	47c1                	li	a5,16
    80005324:	00f51c63          	bne	a0,a5,8000533c <sys_unlink+0x132>
    if(de.inum != 0)
    80005328:	f1845783          	lhu	a5,-232(s0)
    8000532c:	efa1                	bnez	a5,80005384 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000532e:	29c1                	addiw	s3,s3,16
    80005330:	04c92783          	lw	a5,76(s2)
    80005334:	fcf9efe3          	bltu	s3,a5,80005312 <sys_unlink+0x108>
    80005338:	69ae                	ld	s3,200(sp)
    8000533a:	bfa1                	j	80005292 <sys_unlink+0x88>
      panic("isdirempty: readi");
    8000533c:	00002517          	auipc	a0,0x2
    80005340:	31c50513          	addi	a0,a0,796 # 80007658 <etext+0x658>
    80005344:	c5efb0ef          	jal	800007a2 <panic>
    80005348:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    8000534a:	00002517          	auipc	a0,0x2
    8000534e:	32650513          	addi	a0,a0,806 # 80007670 <etext+0x670>
    80005352:	c50fb0ef          	jal	800007a2 <panic>
    dp->nlink--;
    80005356:	04a4d783          	lhu	a5,74(s1)
    8000535a:	37fd                	addiw	a5,a5,-1
    8000535c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005360:	8526                	mv	a0,s1
    80005362:	baefe0ef          	jal	80003710 <iupdate>
    80005366:	bfa9                	j	800052c0 <sys_unlink+0xb6>
    80005368:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    8000536a:	8526                	mv	a0,s1
    8000536c:	e62fe0ef          	jal	800039ce <iunlockput>
  end_op();
    80005370:	d55fe0ef          	jal	800040c4 <end_op>
  return -1;
    80005374:	557d                	li	a0,-1
    80005376:	64ee                	ld	s1,216(sp)
}
    80005378:	70ae                	ld	ra,232(sp)
    8000537a:	740e                	ld	s0,224(sp)
    8000537c:	616d                	addi	sp,sp,240
    8000537e:	8082                	ret
    return -1;
    80005380:	557d                	li	a0,-1
    80005382:	bfdd                	j	80005378 <sys_unlink+0x16e>
    iunlockput(ip);
    80005384:	854a                	mv	a0,s2
    80005386:	e48fe0ef          	jal	800039ce <iunlockput>
    goto bad;
    8000538a:	694e                	ld	s2,208(sp)
    8000538c:	69ae                	ld	s3,200(sp)
    8000538e:	bff1                	j	8000536a <sys_unlink+0x160>

0000000080005390 <sys_open>:

uint64
sys_open(void)
{
    80005390:	7131                	addi	sp,sp,-192
    80005392:	fd06                	sd	ra,184(sp)
    80005394:	f922                	sd	s0,176(sp)
    80005396:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005398:	f4c40593          	addi	a1,s0,-180
    8000539c:	4505                	li	a0,1
    8000539e:	88bfd0ef          	jal	80002c28 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800053a2:	08000613          	li	a2,128
    800053a6:	f5040593          	addi	a1,s0,-176
    800053aa:	4501                	li	a0,0
    800053ac:	8b7fd0ef          	jal	80002c62 <argstr>
    800053b0:	87aa                	mv	a5,a0
    return -1;
    800053b2:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800053b4:	0a07c263          	bltz	a5,80005458 <sys_open+0xc8>
    800053b8:	f526                	sd	s1,168(sp)

  begin_op();
    800053ba:	ca1fe0ef          	jal	8000405a <begin_op>

  if(omode & O_CREATE){
    800053be:	f4c42783          	lw	a5,-180(s0)
    800053c2:	2007f793          	andi	a5,a5,512
    800053c6:	c3d5                	beqz	a5,8000546a <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800053c8:	4681                	li	a3,0
    800053ca:	4601                	li	a2,0
    800053cc:	4589                	li	a1,2
    800053ce:	f5040513          	addi	a0,s0,-176
    800053d2:	aa9ff0ef          	jal	80004e7a <create>
    800053d6:	84aa                	mv	s1,a0
    if(ip == 0){
    800053d8:	c541                	beqz	a0,80005460 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800053da:	04449703          	lh	a4,68(s1)
    800053de:	478d                	li	a5,3
    800053e0:	00f71763          	bne	a4,a5,800053ee <sys_open+0x5e>
    800053e4:	0464d703          	lhu	a4,70(s1)
    800053e8:	47a5                	li	a5,9
    800053ea:	0ae7ed63          	bltu	a5,a4,800054a4 <sys_open+0x114>
    800053ee:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800053f0:	fe1fe0ef          	jal	800043d0 <filealloc>
    800053f4:	892a                	mv	s2,a0
    800053f6:	c179                	beqz	a0,800054bc <sys_open+0x12c>
    800053f8:	ed4e                	sd	s3,152(sp)
    800053fa:	a43ff0ef          	jal	80004e3c <fdalloc>
    800053fe:	89aa                	mv	s3,a0
    80005400:	0a054a63          	bltz	a0,800054b4 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005404:	04449703          	lh	a4,68(s1)
    80005408:	478d                	li	a5,3
    8000540a:	0cf70263          	beq	a4,a5,800054ce <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000540e:	4789                	li	a5,2
    80005410:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005414:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005418:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000541c:	f4c42783          	lw	a5,-180(s0)
    80005420:	0017c713          	xori	a4,a5,1
    80005424:	8b05                	andi	a4,a4,1
    80005426:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000542a:	0037f713          	andi	a4,a5,3
    8000542e:	00e03733          	snez	a4,a4
    80005432:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005436:	4007f793          	andi	a5,a5,1024
    8000543a:	c791                	beqz	a5,80005446 <sys_open+0xb6>
    8000543c:	04449703          	lh	a4,68(s1)
    80005440:	4789                	li	a5,2
    80005442:	08f70d63          	beq	a4,a5,800054dc <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80005446:	8526                	mv	a0,s1
    80005448:	c2afe0ef          	jal	80003872 <iunlock>
  end_op();
    8000544c:	c79fe0ef          	jal	800040c4 <end_op>

  return fd;
    80005450:	854e                	mv	a0,s3
    80005452:	74aa                	ld	s1,168(sp)
    80005454:	790a                	ld	s2,160(sp)
    80005456:	69ea                	ld	s3,152(sp)
}
    80005458:	70ea                	ld	ra,184(sp)
    8000545a:	744a                	ld	s0,176(sp)
    8000545c:	6129                	addi	sp,sp,192
    8000545e:	8082                	ret
      end_op();
    80005460:	c65fe0ef          	jal	800040c4 <end_op>
      return -1;
    80005464:	557d                	li	a0,-1
    80005466:	74aa                	ld	s1,168(sp)
    80005468:	bfc5                	j	80005458 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    8000546a:	f5040513          	addi	a0,s0,-176
    8000546e:	a31fe0ef          	jal	80003e9e <namei>
    80005472:	84aa                	mv	s1,a0
    80005474:	c11d                	beqz	a0,8000549a <sys_open+0x10a>
    ilock(ip);
    80005476:	b4efe0ef          	jal	800037c4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000547a:	04449703          	lh	a4,68(s1)
    8000547e:	4785                	li	a5,1
    80005480:	f4f71de3          	bne	a4,a5,800053da <sys_open+0x4a>
    80005484:	f4c42783          	lw	a5,-180(s0)
    80005488:	d3bd                	beqz	a5,800053ee <sys_open+0x5e>
      iunlockput(ip);
    8000548a:	8526                	mv	a0,s1
    8000548c:	d42fe0ef          	jal	800039ce <iunlockput>
      end_op();
    80005490:	c35fe0ef          	jal	800040c4 <end_op>
      return -1;
    80005494:	557d                	li	a0,-1
    80005496:	74aa                	ld	s1,168(sp)
    80005498:	b7c1                	j	80005458 <sys_open+0xc8>
      end_op();
    8000549a:	c2bfe0ef          	jal	800040c4 <end_op>
      return -1;
    8000549e:	557d                	li	a0,-1
    800054a0:	74aa                	ld	s1,168(sp)
    800054a2:	bf5d                	j	80005458 <sys_open+0xc8>
    iunlockput(ip);
    800054a4:	8526                	mv	a0,s1
    800054a6:	d28fe0ef          	jal	800039ce <iunlockput>
    end_op();
    800054aa:	c1bfe0ef          	jal	800040c4 <end_op>
    return -1;
    800054ae:	557d                	li	a0,-1
    800054b0:	74aa                	ld	s1,168(sp)
    800054b2:	b75d                	j	80005458 <sys_open+0xc8>
      fileclose(f);
    800054b4:	854a                	mv	a0,s2
    800054b6:	fbffe0ef          	jal	80004474 <fileclose>
    800054ba:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800054bc:	8526                	mv	a0,s1
    800054be:	d10fe0ef          	jal	800039ce <iunlockput>
    end_op();
    800054c2:	c03fe0ef          	jal	800040c4 <end_op>
    return -1;
    800054c6:	557d                	li	a0,-1
    800054c8:	74aa                	ld	s1,168(sp)
    800054ca:	790a                	ld	s2,160(sp)
    800054cc:	b771                	j	80005458 <sys_open+0xc8>
    f->type = FD_DEVICE;
    800054ce:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800054d2:	04649783          	lh	a5,70(s1)
    800054d6:	02f91223          	sh	a5,36(s2)
    800054da:	bf3d                	j	80005418 <sys_open+0x88>
    itrunc(ip);
    800054dc:	8526                	mv	a0,s1
    800054de:	bd4fe0ef          	jal	800038b2 <itrunc>
    800054e2:	b795                	j	80005446 <sys_open+0xb6>

00000000800054e4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800054e4:	7175                	addi	sp,sp,-144
    800054e6:	e506                	sd	ra,136(sp)
    800054e8:	e122                	sd	s0,128(sp)
    800054ea:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800054ec:	b6ffe0ef          	jal	8000405a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800054f0:	08000613          	li	a2,128
    800054f4:	f7040593          	addi	a1,s0,-144
    800054f8:	4501                	li	a0,0
    800054fa:	f68fd0ef          	jal	80002c62 <argstr>
    800054fe:	02054363          	bltz	a0,80005524 <sys_mkdir+0x40>
    80005502:	4681                	li	a3,0
    80005504:	4601                	li	a2,0
    80005506:	4585                	li	a1,1
    80005508:	f7040513          	addi	a0,s0,-144
    8000550c:	96fff0ef          	jal	80004e7a <create>
    80005510:	c911                	beqz	a0,80005524 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005512:	cbcfe0ef          	jal	800039ce <iunlockput>
  end_op();
    80005516:	baffe0ef          	jal	800040c4 <end_op>
  return 0;
    8000551a:	4501                	li	a0,0
}
    8000551c:	60aa                	ld	ra,136(sp)
    8000551e:	640a                	ld	s0,128(sp)
    80005520:	6149                	addi	sp,sp,144
    80005522:	8082                	ret
    end_op();
    80005524:	ba1fe0ef          	jal	800040c4 <end_op>
    return -1;
    80005528:	557d                	li	a0,-1
    8000552a:	bfcd                	j	8000551c <sys_mkdir+0x38>

000000008000552c <sys_mknod>:

uint64
sys_mknod(void)
{
    8000552c:	7135                	addi	sp,sp,-160
    8000552e:	ed06                	sd	ra,152(sp)
    80005530:	e922                	sd	s0,144(sp)
    80005532:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005534:	b27fe0ef          	jal	8000405a <begin_op>
  argint(1, &major);
    80005538:	f6c40593          	addi	a1,s0,-148
    8000553c:	4505                	li	a0,1
    8000553e:	eeafd0ef          	jal	80002c28 <argint>
  argint(2, &minor);
    80005542:	f6840593          	addi	a1,s0,-152
    80005546:	4509                	li	a0,2
    80005548:	ee0fd0ef          	jal	80002c28 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000554c:	08000613          	li	a2,128
    80005550:	f7040593          	addi	a1,s0,-144
    80005554:	4501                	li	a0,0
    80005556:	f0cfd0ef          	jal	80002c62 <argstr>
    8000555a:	02054563          	bltz	a0,80005584 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000555e:	f6841683          	lh	a3,-152(s0)
    80005562:	f6c41603          	lh	a2,-148(s0)
    80005566:	458d                	li	a1,3
    80005568:	f7040513          	addi	a0,s0,-144
    8000556c:	90fff0ef          	jal	80004e7a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005570:	c911                	beqz	a0,80005584 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005572:	c5cfe0ef          	jal	800039ce <iunlockput>
  end_op();
    80005576:	b4ffe0ef          	jal	800040c4 <end_op>
  return 0;
    8000557a:	4501                	li	a0,0
}
    8000557c:	60ea                	ld	ra,152(sp)
    8000557e:	644a                	ld	s0,144(sp)
    80005580:	610d                	addi	sp,sp,160
    80005582:	8082                	ret
    end_op();
    80005584:	b41fe0ef          	jal	800040c4 <end_op>
    return -1;
    80005588:	557d                	li	a0,-1
    8000558a:	bfcd                	j	8000557c <sys_mknod+0x50>

000000008000558c <sys_chdir>:

uint64
sys_chdir(void)
{
    8000558c:	7135                	addi	sp,sp,-160
    8000558e:	ed06                	sd	ra,152(sp)
    80005590:	e922                	sd	s0,144(sp)
    80005592:	e14a                	sd	s2,128(sp)
    80005594:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005596:	b7cfc0ef          	jal	80001912 <myproc>
    8000559a:	892a                	mv	s2,a0
  
  begin_op();
    8000559c:	abffe0ef          	jal	8000405a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800055a0:	08000613          	li	a2,128
    800055a4:	f6040593          	addi	a1,s0,-160
    800055a8:	4501                	li	a0,0
    800055aa:	eb8fd0ef          	jal	80002c62 <argstr>
    800055ae:	04054363          	bltz	a0,800055f4 <sys_chdir+0x68>
    800055b2:	e526                	sd	s1,136(sp)
    800055b4:	f6040513          	addi	a0,s0,-160
    800055b8:	8e7fe0ef          	jal	80003e9e <namei>
    800055bc:	84aa                	mv	s1,a0
    800055be:	c915                	beqz	a0,800055f2 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800055c0:	a04fe0ef          	jal	800037c4 <ilock>
  if(ip->type != T_DIR){
    800055c4:	04449703          	lh	a4,68(s1)
    800055c8:	4785                	li	a5,1
    800055ca:	02f71963          	bne	a4,a5,800055fc <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800055ce:	8526                	mv	a0,s1
    800055d0:	aa2fe0ef          	jal	80003872 <iunlock>
  iput(p->cwd);
    800055d4:	15093503          	ld	a0,336(s2)
    800055d8:	b6efe0ef          	jal	80003946 <iput>
  end_op();
    800055dc:	ae9fe0ef          	jal	800040c4 <end_op>
  p->cwd = ip;
    800055e0:	14993823          	sd	s1,336(s2)
  return 0;
    800055e4:	4501                	li	a0,0
    800055e6:	64aa                	ld	s1,136(sp)
}
    800055e8:	60ea                	ld	ra,152(sp)
    800055ea:	644a                	ld	s0,144(sp)
    800055ec:	690a                	ld	s2,128(sp)
    800055ee:	610d                	addi	sp,sp,160
    800055f0:	8082                	ret
    800055f2:	64aa                	ld	s1,136(sp)
    end_op();
    800055f4:	ad1fe0ef          	jal	800040c4 <end_op>
    return -1;
    800055f8:	557d                	li	a0,-1
    800055fa:	b7fd                	j	800055e8 <sys_chdir+0x5c>
    iunlockput(ip);
    800055fc:	8526                	mv	a0,s1
    800055fe:	bd0fe0ef          	jal	800039ce <iunlockput>
    end_op();
    80005602:	ac3fe0ef          	jal	800040c4 <end_op>
    return -1;
    80005606:	557d                	li	a0,-1
    80005608:	64aa                	ld	s1,136(sp)
    8000560a:	bff9                	j	800055e8 <sys_chdir+0x5c>

000000008000560c <sys_exec>:

uint64
sys_exec(void)
{
    8000560c:	7121                	addi	sp,sp,-448
    8000560e:	ff06                	sd	ra,440(sp)
    80005610:	fb22                	sd	s0,432(sp)
    80005612:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005614:	e4840593          	addi	a1,s0,-440
    80005618:	4505                	li	a0,1
    8000561a:	e2afd0ef          	jal	80002c44 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000561e:	08000613          	li	a2,128
    80005622:	f5040593          	addi	a1,s0,-176
    80005626:	4501                	li	a0,0
    80005628:	e3afd0ef          	jal	80002c62 <argstr>
    8000562c:	87aa                	mv	a5,a0
    return -1;
    8000562e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005630:	0c07c463          	bltz	a5,800056f8 <sys_exec+0xec>
    80005634:	f726                	sd	s1,424(sp)
    80005636:	f34a                	sd	s2,416(sp)
    80005638:	ef4e                	sd	s3,408(sp)
    8000563a:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000563c:	10000613          	li	a2,256
    80005640:	4581                	li	a1,0
    80005642:	e5040513          	addi	a0,s0,-432
    80005646:	e90fb0ef          	jal	80000cd6 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000564a:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000564e:	89a6                	mv	s3,s1
    80005650:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005652:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005656:	00391513          	slli	a0,s2,0x3
    8000565a:	e4040593          	addi	a1,s0,-448
    8000565e:	e4843783          	ld	a5,-440(s0)
    80005662:	953e                	add	a0,a0,a5
    80005664:	d3afd0ef          	jal	80002b9e <fetchaddr>
    80005668:	02054663          	bltz	a0,80005694 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    8000566c:	e4043783          	ld	a5,-448(s0)
    80005670:	c3a9                	beqz	a5,800056b2 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005672:	cc0fb0ef          	jal	80000b32 <kalloc>
    80005676:	85aa                	mv	a1,a0
    80005678:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000567c:	cd01                	beqz	a0,80005694 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000567e:	6605                	lui	a2,0x1
    80005680:	e4043503          	ld	a0,-448(s0)
    80005684:	d64fd0ef          	jal	80002be8 <fetchstr>
    80005688:	00054663          	bltz	a0,80005694 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    8000568c:	0905                	addi	s2,s2,1
    8000568e:	09a1                	addi	s3,s3,8
    80005690:	fd4913e3          	bne	s2,s4,80005656 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005694:	f5040913          	addi	s2,s0,-176
    80005698:	6088                	ld	a0,0(s1)
    8000569a:	c931                	beqz	a0,800056ee <sys_exec+0xe2>
    kfree(argv[i]);
    8000569c:	bb4fb0ef          	jal	80000a50 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800056a0:	04a1                	addi	s1,s1,8
    800056a2:	ff249be3          	bne	s1,s2,80005698 <sys_exec+0x8c>
  return -1;
    800056a6:	557d                	li	a0,-1
    800056a8:	74ba                	ld	s1,424(sp)
    800056aa:	791a                	ld	s2,416(sp)
    800056ac:	69fa                	ld	s3,408(sp)
    800056ae:	6a5a                	ld	s4,400(sp)
    800056b0:	a0a1                	j	800056f8 <sys_exec+0xec>
      argv[i] = 0;
    800056b2:	0009079b          	sext.w	a5,s2
    800056b6:	078e                	slli	a5,a5,0x3
    800056b8:	fd078793          	addi	a5,a5,-48
    800056bc:	97a2                	add	a5,a5,s0
    800056be:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800056c2:	e5040593          	addi	a1,s0,-432
    800056c6:	f5040513          	addi	a0,s0,-176
    800056ca:	ba8ff0ef          	jal	80004a72 <exec>
    800056ce:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800056d0:	f5040993          	addi	s3,s0,-176
    800056d4:	6088                	ld	a0,0(s1)
    800056d6:	c511                	beqz	a0,800056e2 <sys_exec+0xd6>
    kfree(argv[i]);
    800056d8:	b78fb0ef          	jal	80000a50 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800056dc:	04a1                	addi	s1,s1,8
    800056de:	ff349be3          	bne	s1,s3,800056d4 <sys_exec+0xc8>
  return ret;
    800056e2:	854a                	mv	a0,s2
    800056e4:	74ba                	ld	s1,424(sp)
    800056e6:	791a                	ld	s2,416(sp)
    800056e8:	69fa                	ld	s3,408(sp)
    800056ea:	6a5a                	ld	s4,400(sp)
    800056ec:	a031                	j	800056f8 <sys_exec+0xec>
  return -1;
    800056ee:	557d                	li	a0,-1
    800056f0:	74ba                	ld	s1,424(sp)
    800056f2:	791a                	ld	s2,416(sp)
    800056f4:	69fa                	ld	s3,408(sp)
    800056f6:	6a5a                	ld	s4,400(sp)
}
    800056f8:	70fa                	ld	ra,440(sp)
    800056fa:	745a                	ld	s0,432(sp)
    800056fc:	6139                	addi	sp,sp,448
    800056fe:	8082                	ret

0000000080005700 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005700:	7139                	addi	sp,sp,-64
    80005702:	fc06                	sd	ra,56(sp)
    80005704:	f822                	sd	s0,48(sp)
    80005706:	f426                	sd	s1,40(sp)
    80005708:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000570a:	a08fc0ef          	jal	80001912 <myproc>
    8000570e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005710:	fd840593          	addi	a1,s0,-40
    80005714:	4501                	li	a0,0
    80005716:	d2efd0ef          	jal	80002c44 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000571a:	fc840593          	addi	a1,s0,-56
    8000571e:	fd040513          	addi	a0,s0,-48
    80005722:	85cff0ef          	jal	8000477e <pipealloc>
    return -1;
    80005726:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005728:	0a054463          	bltz	a0,800057d0 <sys_pipe+0xd0>
  fd0 = -1;
    8000572c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005730:	fd043503          	ld	a0,-48(s0)
    80005734:	f08ff0ef          	jal	80004e3c <fdalloc>
    80005738:	fca42223          	sw	a0,-60(s0)
    8000573c:	08054163          	bltz	a0,800057be <sys_pipe+0xbe>
    80005740:	fc843503          	ld	a0,-56(s0)
    80005744:	ef8ff0ef          	jal	80004e3c <fdalloc>
    80005748:	fca42023          	sw	a0,-64(s0)
    8000574c:	06054063          	bltz	a0,800057ac <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005750:	4691                	li	a3,4
    80005752:	fc440613          	addi	a2,s0,-60
    80005756:	fd843583          	ld	a1,-40(s0)
    8000575a:	68a8                	ld	a0,80(s1)
    8000575c:	e29fb0ef          	jal	80001584 <copyout>
    80005760:	00054e63          	bltz	a0,8000577c <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005764:	4691                	li	a3,4
    80005766:	fc040613          	addi	a2,s0,-64
    8000576a:	fd843583          	ld	a1,-40(s0)
    8000576e:	0591                	addi	a1,a1,4
    80005770:	68a8                	ld	a0,80(s1)
    80005772:	e13fb0ef          	jal	80001584 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005776:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005778:	04055c63          	bgez	a0,800057d0 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000577c:	fc442783          	lw	a5,-60(s0)
    80005780:	07e9                	addi	a5,a5,26
    80005782:	078e                	slli	a5,a5,0x3
    80005784:	97a6                	add	a5,a5,s1
    80005786:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000578a:	fc042783          	lw	a5,-64(s0)
    8000578e:	07e9                	addi	a5,a5,26
    80005790:	078e                	slli	a5,a5,0x3
    80005792:	94be                	add	s1,s1,a5
    80005794:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005798:	fd043503          	ld	a0,-48(s0)
    8000579c:	cd9fe0ef          	jal	80004474 <fileclose>
    fileclose(wf);
    800057a0:	fc843503          	ld	a0,-56(s0)
    800057a4:	cd1fe0ef          	jal	80004474 <fileclose>
    return -1;
    800057a8:	57fd                	li	a5,-1
    800057aa:	a01d                	j	800057d0 <sys_pipe+0xd0>
    if(fd0 >= 0)
    800057ac:	fc442783          	lw	a5,-60(s0)
    800057b0:	0007c763          	bltz	a5,800057be <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800057b4:	07e9                	addi	a5,a5,26
    800057b6:	078e                	slli	a5,a5,0x3
    800057b8:	97a6                	add	a5,a5,s1
    800057ba:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800057be:	fd043503          	ld	a0,-48(s0)
    800057c2:	cb3fe0ef          	jal	80004474 <fileclose>
    fileclose(wf);
    800057c6:	fc843503          	ld	a0,-56(s0)
    800057ca:	cabfe0ef          	jal	80004474 <fileclose>
    return -1;
    800057ce:	57fd                	li	a5,-1
}
    800057d0:	853e                	mv	a0,a5
    800057d2:	70e2                	ld	ra,56(sp)
    800057d4:	7442                	ld	s0,48(sp)
    800057d6:	74a2                	ld	s1,40(sp)
    800057d8:	6121                	addi	sp,sp,64
    800057da:	8082                	ret
    800057dc:	0000                	unimp
	...

00000000800057e0 <kernelvec>:
    800057e0:	7111                	addi	sp,sp,-256
    800057e2:	e006                	sd	ra,0(sp)
    800057e4:	e40a                	sd	sp,8(sp)
    800057e6:	e80e                	sd	gp,16(sp)
    800057e8:	ec12                	sd	tp,24(sp)
    800057ea:	f016                	sd	t0,32(sp)
    800057ec:	f41a                	sd	t1,40(sp)
    800057ee:	f81e                	sd	t2,48(sp)
    800057f0:	e4aa                	sd	a0,72(sp)
    800057f2:	e8ae                	sd	a1,80(sp)
    800057f4:	ecb2                	sd	a2,88(sp)
    800057f6:	f0b6                	sd	a3,96(sp)
    800057f8:	f4ba                	sd	a4,104(sp)
    800057fa:	f8be                	sd	a5,112(sp)
    800057fc:	fcc2                	sd	a6,120(sp)
    800057fe:	e146                	sd	a7,128(sp)
    80005800:	edf2                	sd	t3,216(sp)
    80005802:	f1f6                	sd	t4,224(sp)
    80005804:	f5fa                	sd	t5,232(sp)
    80005806:	f9fe                	sd	t6,240(sp)
    80005808:	aa6fd0ef          	jal	80002aae <kerneltrap>
    8000580c:	6082                	ld	ra,0(sp)
    8000580e:	6122                	ld	sp,8(sp)
    80005810:	61c2                	ld	gp,16(sp)
    80005812:	7282                	ld	t0,32(sp)
    80005814:	7322                	ld	t1,40(sp)
    80005816:	73c2                	ld	t2,48(sp)
    80005818:	6526                	ld	a0,72(sp)
    8000581a:	65c6                	ld	a1,80(sp)
    8000581c:	6666                	ld	a2,88(sp)
    8000581e:	7686                	ld	a3,96(sp)
    80005820:	7726                	ld	a4,104(sp)
    80005822:	77c6                	ld	a5,112(sp)
    80005824:	7866                	ld	a6,120(sp)
    80005826:	688a                	ld	a7,128(sp)
    80005828:	6e6e                	ld	t3,216(sp)
    8000582a:	7e8e                	ld	t4,224(sp)
    8000582c:	7f2e                	ld	t5,232(sp)
    8000582e:	7fce                	ld	t6,240(sp)
    80005830:	6111                	addi	sp,sp,256
    80005832:	10200073          	sret
	...

000000008000583e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000583e:	1141                	addi	sp,sp,-16
    80005840:	e422                	sd	s0,8(sp)
    80005842:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005844:	0c0007b7          	lui	a5,0xc000
    80005848:	4705                	li	a4,1
    8000584a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000584c:	0c0007b7          	lui	a5,0xc000
    80005850:	c3d8                	sw	a4,4(a5)
}
    80005852:	6422                	ld	s0,8(sp)
    80005854:	0141                	addi	sp,sp,16
    80005856:	8082                	ret

0000000080005858 <plicinithart>:

void
plicinithart(void)
{
    80005858:	1141                	addi	sp,sp,-16
    8000585a:	e406                	sd	ra,8(sp)
    8000585c:	e022                	sd	s0,0(sp)
    8000585e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005860:	886fc0ef          	jal	800018e6 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005864:	0085171b          	slliw	a4,a0,0x8
    80005868:	0c0027b7          	lui	a5,0xc002
    8000586c:	97ba                	add	a5,a5,a4
    8000586e:	40200713          	li	a4,1026
    80005872:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005876:	00d5151b          	slliw	a0,a0,0xd
    8000587a:	0c2017b7          	lui	a5,0xc201
    8000587e:	97aa                	add	a5,a5,a0
    80005880:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005884:	60a2                	ld	ra,8(sp)
    80005886:	6402                	ld	s0,0(sp)
    80005888:	0141                	addi	sp,sp,16
    8000588a:	8082                	ret

000000008000588c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000588c:	1141                	addi	sp,sp,-16
    8000588e:	e406                	sd	ra,8(sp)
    80005890:	e022                	sd	s0,0(sp)
    80005892:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005894:	852fc0ef          	jal	800018e6 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005898:	00d5151b          	slliw	a0,a0,0xd
    8000589c:	0c2017b7          	lui	a5,0xc201
    800058a0:	97aa                	add	a5,a5,a0
  return irq;
}
    800058a2:	43c8                	lw	a0,4(a5)
    800058a4:	60a2                	ld	ra,8(sp)
    800058a6:	6402                	ld	s0,0(sp)
    800058a8:	0141                	addi	sp,sp,16
    800058aa:	8082                	ret

00000000800058ac <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800058ac:	1101                	addi	sp,sp,-32
    800058ae:	ec06                	sd	ra,24(sp)
    800058b0:	e822                	sd	s0,16(sp)
    800058b2:	e426                	sd	s1,8(sp)
    800058b4:	1000                	addi	s0,sp,32
    800058b6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800058b8:	82efc0ef          	jal	800018e6 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800058bc:	00d5151b          	slliw	a0,a0,0xd
    800058c0:	0c2017b7          	lui	a5,0xc201
    800058c4:	97aa                	add	a5,a5,a0
    800058c6:	c3c4                	sw	s1,4(a5)
}
    800058c8:	60e2                	ld	ra,24(sp)
    800058ca:	6442                	ld	s0,16(sp)
    800058cc:	64a2                	ld	s1,8(sp)
    800058ce:	6105                	addi	sp,sp,32
    800058d0:	8082                	ret

00000000800058d2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800058d2:	1141                	addi	sp,sp,-16
    800058d4:	e406                	sd	ra,8(sp)
    800058d6:	e022                	sd	s0,0(sp)
    800058d8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800058da:	479d                	li	a5,7
    800058dc:	04a7ca63          	blt	a5,a0,80005930 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800058e0:	0001e797          	auipc	a5,0x1e
    800058e4:	49078793          	addi	a5,a5,1168 # 80023d70 <disk>
    800058e8:	97aa                	add	a5,a5,a0
    800058ea:	0187c783          	lbu	a5,24(a5)
    800058ee:	e7b9                	bnez	a5,8000593c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800058f0:	00451693          	slli	a3,a0,0x4
    800058f4:	0001e797          	auipc	a5,0x1e
    800058f8:	47c78793          	addi	a5,a5,1148 # 80023d70 <disk>
    800058fc:	6398                	ld	a4,0(a5)
    800058fe:	9736                	add	a4,a4,a3
    80005900:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005904:	6398                	ld	a4,0(a5)
    80005906:	9736                	add	a4,a4,a3
    80005908:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000590c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005910:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005914:	97aa                	add	a5,a5,a0
    80005916:	4705                	li	a4,1
    80005918:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000591c:	0001e517          	auipc	a0,0x1e
    80005920:	46c50513          	addi	a0,a0,1132 # 80023d88 <disk+0x18>
    80005924:	a4bfc0ef          	jal	8000236e <wakeup>
}
    80005928:	60a2                	ld	ra,8(sp)
    8000592a:	6402                	ld	s0,0(sp)
    8000592c:	0141                	addi	sp,sp,16
    8000592e:	8082                	ret
    panic("free_desc 1");
    80005930:	00002517          	auipc	a0,0x2
    80005934:	d5050513          	addi	a0,a0,-688 # 80007680 <etext+0x680>
    80005938:	e6bfa0ef          	jal	800007a2 <panic>
    panic("free_desc 2");
    8000593c:	00002517          	auipc	a0,0x2
    80005940:	d5450513          	addi	a0,a0,-684 # 80007690 <etext+0x690>
    80005944:	e5ffa0ef          	jal	800007a2 <panic>

0000000080005948 <virtio_disk_init>:
{
    80005948:	1101                	addi	sp,sp,-32
    8000594a:	ec06                	sd	ra,24(sp)
    8000594c:	e822                	sd	s0,16(sp)
    8000594e:	e426                	sd	s1,8(sp)
    80005950:	e04a                	sd	s2,0(sp)
    80005952:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005954:	00002597          	auipc	a1,0x2
    80005958:	d4c58593          	addi	a1,a1,-692 # 800076a0 <etext+0x6a0>
    8000595c:	0001e517          	auipc	a0,0x1e
    80005960:	53c50513          	addi	a0,a0,1340 # 80023e98 <disk+0x128>
    80005964:	a1efb0ef          	jal	80000b82 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005968:	100017b7          	lui	a5,0x10001
    8000596c:	4398                	lw	a4,0(a5)
    8000596e:	2701                	sext.w	a4,a4
    80005970:	747277b7          	lui	a5,0x74727
    80005974:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005978:	18f71063          	bne	a4,a5,80005af8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000597c:	100017b7          	lui	a5,0x10001
    80005980:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80005982:	439c                	lw	a5,0(a5)
    80005984:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005986:	4709                	li	a4,2
    80005988:	16e79863          	bne	a5,a4,80005af8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000598c:	100017b7          	lui	a5,0x10001
    80005990:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005992:	439c                	lw	a5,0(a5)
    80005994:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005996:	16e79163          	bne	a5,a4,80005af8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000599a:	100017b7          	lui	a5,0x10001
    8000599e:	47d8                	lw	a4,12(a5)
    800059a0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800059a2:	554d47b7          	lui	a5,0x554d4
    800059a6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800059aa:	14f71763          	bne	a4,a5,80005af8 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800059ae:	100017b7          	lui	a5,0x10001
    800059b2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800059b6:	4705                	li	a4,1
    800059b8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800059ba:	470d                	li	a4,3
    800059bc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800059be:	10001737          	lui	a4,0x10001
    800059c2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800059c4:	c7ffe737          	lui	a4,0xc7ffe
    800059c8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fda8af>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800059cc:	8ef9                	and	a3,a3,a4
    800059ce:	10001737          	lui	a4,0x10001
    800059d2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800059d4:	472d                	li	a4,11
    800059d6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800059d8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800059dc:	439c                	lw	a5,0(a5)
    800059de:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800059e2:	8ba1                	andi	a5,a5,8
    800059e4:	12078063          	beqz	a5,80005b04 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800059e8:	100017b7          	lui	a5,0x10001
    800059ec:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800059f0:	100017b7          	lui	a5,0x10001
    800059f4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800059f8:	439c                	lw	a5,0(a5)
    800059fa:	2781                	sext.w	a5,a5
    800059fc:	10079a63          	bnez	a5,80005b10 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005a00:	100017b7          	lui	a5,0x10001
    80005a04:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005a08:	439c                	lw	a5,0(a5)
    80005a0a:	2781                	sext.w	a5,a5
  if(max == 0)
    80005a0c:	10078863          	beqz	a5,80005b1c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005a10:	471d                	li	a4,7
    80005a12:	10f77b63          	bgeu	a4,a5,80005b28 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005a16:	91cfb0ef          	jal	80000b32 <kalloc>
    80005a1a:	0001e497          	auipc	s1,0x1e
    80005a1e:	35648493          	addi	s1,s1,854 # 80023d70 <disk>
    80005a22:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005a24:	90efb0ef          	jal	80000b32 <kalloc>
    80005a28:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005a2a:	908fb0ef          	jal	80000b32 <kalloc>
    80005a2e:	87aa                	mv	a5,a0
    80005a30:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005a32:	6088                	ld	a0,0(s1)
    80005a34:	10050063          	beqz	a0,80005b34 <virtio_disk_init+0x1ec>
    80005a38:	0001e717          	auipc	a4,0x1e
    80005a3c:	34073703          	ld	a4,832(a4) # 80023d78 <disk+0x8>
    80005a40:	0e070a63          	beqz	a4,80005b34 <virtio_disk_init+0x1ec>
    80005a44:	0e078863          	beqz	a5,80005b34 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005a48:	6605                	lui	a2,0x1
    80005a4a:	4581                	li	a1,0
    80005a4c:	a8afb0ef          	jal	80000cd6 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005a50:	0001e497          	auipc	s1,0x1e
    80005a54:	32048493          	addi	s1,s1,800 # 80023d70 <disk>
    80005a58:	6605                	lui	a2,0x1
    80005a5a:	4581                	li	a1,0
    80005a5c:	6488                	ld	a0,8(s1)
    80005a5e:	a78fb0ef          	jal	80000cd6 <memset>
  memset(disk.used, 0, PGSIZE);
    80005a62:	6605                	lui	a2,0x1
    80005a64:	4581                	li	a1,0
    80005a66:	6888                	ld	a0,16(s1)
    80005a68:	a6efb0ef          	jal	80000cd6 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005a6c:	100017b7          	lui	a5,0x10001
    80005a70:	4721                	li	a4,8
    80005a72:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005a74:	4098                	lw	a4,0(s1)
    80005a76:	100017b7          	lui	a5,0x10001
    80005a7a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005a7e:	40d8                	lw	a4,4(s1)
    80005a80:	100017b7          	lui	a5,0x10001
    80005a84:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005a88:	649c                	ld	a5,8(s1)
    80005a8a:	0007869b          	sext.w	a3,a5
    80005a8e:	10001737          	lui	a4,0x10001
    80005a92:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005a96:	9781                	srai	a5,a5,0x20
    80005a98:	10001737          	lui	a4,0x10001
    80005a9c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005aa0:	689c                	ld	a5,16(s1)
    80005aa2:	0007869b          	sext.w	a3,a5
    80005aa6:	10001737          	lui	a4,0x10001
    80005aaa:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005aae:	9781                	srai	a5,a5,0x20
    80005ab0:	10001737          	lui	a4,0x10001
    80005ab4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005ab8:	10001737          	lui	a4,0x10001
    80005abc:	4785                	li	a5,1
    80005abe:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005ac0:	00f48c23          	sb	a5,24(s1)
    80005ac4:	00f48ca3          	sb	a5,25(s1)
    80005ac8:	00f48d23          	sb	a5,26(s1)
    80005acc:	00f48da3          	sb	a5,27(s1)
    80005ad0:	00f48e23          	sb	a5,28(s1)
    80005ad4:	00f48ea3          	sb	a5,29(s1)
    80005ad8:	00f48f23          	sb	a5,30(s1)
    80005adc:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005ae0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ae4:	100017b7          	lui	a5,0x10001
    80005ae8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80005aec:	60e2                	ld	ra,24(sp)
    80005aee:	6442                	ld	s0,16(sp)
    80005af0:	64a2                	ld	s1,8(sp)
    80005af2:	6902                	ld	s2,0(sp)
    80005af4:	6105                	addi	sp,sp,32
    80005af6:	8082                	ret
    panic("could not find virtio disk");
    80005af8:	00002517          	auipc	a0,0x2
    80005afc:	bb850513          	addi	a0,a0,-1096 # 800076b0 <etext+0x6b0>
    80005b00:	ca3fa0ef          	jal	800007a2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005b04:	00002517          	auipc	a0,0x2
    80005b08:	bcc50513          	addi	a0,a0,-1076 # 800076d0 <etext+0x6d0>
    80005b0c:	c97fa0ef          	jal	800007a2 <panic>
    panic("virtio disk should not be ready");
    80005b10:	00002517          	auipc	a0,0x2
    80005b14:	be050513          	addi	a0,a0,-1056 # 800076f0 <etext+0x6f0>
    80005b18:	c8bfa0ef          	jal	800007a2 <panic>
    panic("virtio disk has no queue 0");
    80005b1c:	00002517          	auipc	a0,0x2
    80005b20:	bf450513          	addi	a0,a0,-1036 # 80007710 <etext+0x710>
    80005b24:	c7ffa0ef          	jal	800007a2 <panic>
    panic("virtio disk max queue too short");
    80005b28:	00002517          	auipc	a0,0x2
    80005b2c:	c0850513          	addi	a0,a0,-1016 # 80007730 <etext+0x730>
    80005b30:	c73fa0ef          	jal	800007a2 <panic>
    panic("virtio disk kalloc");
    80005b34:	00002517          	auipc	a0,0x2
    80005b38:	c1c50513          	addi	a0,a0,-996 # 80007750 <etext+0x750>
    80005b3c:	c67fa0ef          	jal	800007a2 <panic>

0000000080005b40 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005b40:	7159                	addi	sp,sp,-112
    80005b42:	f486                	sd	ra,104(sp)
    80005b44:	f0a2                	sd	s0,96(sp)
    80005b46:	eca6                	sd	s1,88(sp)
    80005b48:	e8ca                	sd	s2,80(sp)
    80005b4a:	e4ce                	sd	s3,72(sp)
    80005b4c:	e0d2                	sd	s4,64(sp)
    80005b4e:	fc56                	sd	s5,56(sp)
    80005b50:	f85a                	sd	s6,48(sp)
    80005b52:	f45e                	sd	s7,40(sp)
    80005b54:	f062                	sd	s8,32(sp)
    80005b56:	ec66                	sd	s9,24(sp)
    80005b58:	1880                	addi	s0,sp,112
    80005b5a:	8a2a                	mv	s4,a0
    80005b5c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005b5e:	00c52c83          	lw	s9,12(a0)
    80005b62:	001c9c9b          	slliw	s9,s9,0x1
    80005b66:	1c82                	slli	s9,s9,0x20
    80005b68:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005b6c:	0001e517          	auipc	a0,0x1e
    80005b70:	32c50513          	addi	a0,a0,812 # 80023e98 <disk+0x128>
    80005b74:	88efb0ef          	jal	80000c02 <acquire>
  for(int i = 0; i < 3; i++){
    80005b78:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005b7a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005b7c:	0001eb17          	auipc	s6,0x1e
    80005b80:	1f4b0b13          	addi	s6,s6,500 # 80023d70 <disk>
  for(int i = 0; i < 3; i++){
    80005b84:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005b86:	0001ec17          	auipc	s8,0x1e
    80005b8a:	312c0c13          	addi	s8,s8,786 # 80023e98 <disk+0x128>
    80005b8e:	a8b9                	j	80005bec <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005b90:	00fb0733          	add	a4,s6,a5
    80005b94:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005b98:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005b9a:	0207c563          	bltz	a5,80005bc4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005b9e:	2905                	addiw	s2,s2,1
    80005ba0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005ba2:	05590963          	beq	s2,s5,80005bf4 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005ba6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005ba8:	0001e717          	auipc	a4,0x1e
    80005bac:	1c870713          	addi	a4,a4,456 # 80023d70 <disk>
    80005bb0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005bb2:	01874683          	lbu	a3,24(a4)
    80005bb6:	fee9                	bnez	a3,80005b90 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005bb8:	2785                	addiw	a5,a5,1
    80005bba:	0705                	addi	a4,a4,1
    80005bbc:	fe979be3          	bne	a5,s1,80005bb2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005bc0:	57fd                	li	a5,-1
    80005bc2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005bc4:	01205d63          	blez	s2,80005bde <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005bc8:	f9042503          	lw	a0,-112(s0)
    80005bcc:	d07ff0ef          	jal	800058d2 <free_desc>
      for(int j = 0; j < i; j++)
    80005bd0:	4785                	li	a5,1
    80005bd2:	0127d663          	bge	a5,s2,80005bde <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005bd6:	f9442503          	lw	a0,-108(s0)
    80005bda:	cf9ff0ef          	jal	800058d2 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005bde:	85e2                	mv	a1,s8
    80005be0:	0001e517          	auipc	a0,0x1e
    80005be4:	1a850513          	addi	a0,a0,424 # 80023d88 <disk+0x18>
    80005be8:	ddafc0ef          	jal	800021c2 <sleep>
  for(int i = 0; i < 3; i++){
    80005bec:	f9040613          	addi	a2,s0,-112
    80005bf0:	894e                	mv	s2,s3
    80005bf2:	bf55                	j	80005ba6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005bf4:	f9042503          	lw	a0,-112(s0)
    80005bf8:	00451693          	slli	a3,a0,0x4

  if(write)
    80005bfc:	0001e797          	auipc	a5,0x1e
    80005c00:	17478793          	addi	a5,a5,372 # 80023d70 <disk>
    80005c04:	00a50713          	addi	a4,a0,10
    80005c08:	0712                	slli	a4,a4,0x4
    80005c0a:	973e                	add	a4,a4,a5
    80005c0c:	01703633          	snez	a2,s7
    80005c10:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005c12:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005c16:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005c1a:	6398                	ld	a4,0(a5)
    80005c1c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005c1e:	0a868613          	addi	a2,a3,168
    80005c22:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005c24:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005c26:	6390                	ld	a2,0(a5)
    80005c28:	00d605b3          	add	a1,a2,a3
    80005c2c:	4741                	li	a4,16
    80005c2e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005c30:	4805                	li	a6,1
    80005c32:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005c36:	f9442703          	lw	a4,-108(s0)
    80005c3a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005c3e:	0712                	slli	a4,a4,0x4
    80005c40:	963a                	add	a2,a2,a4
    80005c42:	058a0593          	addi	a1,s4,88
    80005c46:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005c48:	0007b883          	ld	a7,0(a5)
    80005c4c:	9746                	add	a4,a4,a7
    80005c4e:	40000613          	li	a2,1024
    80005c52:	c710                	sw	a2,8(a4)
  if(write)
    80005c54:	001bb613          	seqz	a2,s7
    80005c58:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005c5c:	00166613          	ori	a2,a2,1
    80005c60:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005c64:	f9842583          	lw	a1,-104(s0)
    80005c68:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005c6c:	00250613          	addi	a2,a0,2
    80005c70:	0612                	slli	a2,a2,0x4
    80005c72:	963e                	add	a2,a2,a5
    80005c74:	577d                	li	a4,-1
    80005c76:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005c7a:	0592                	slli	a1,a1,0x4
    80005c7c:	98ae                	add	a7,a7,a1
    80005c7e:	03068713          	addi	a4,a3,48
    80005c82:	973e                	add	a4,a4,a5
    80005c84:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005c88:	6398                	ld	a4,0(a5)
    80005c8a:	972e                	add	a4,a4,a1
    80005c8c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005c90:	4689                	li	a3,2
    80005c92:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005c96:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005c9a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005c9e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005ca2:	6794                	ld	a3,8(a5)
    80005ca4:	0026d703          	lhu	a4,2(a3)
    80005ca8:	8b1d                	andi	a4,a4,7
    80005caa:	0706                	slli	a4,a4,0x1
    80005cac:	96ba                	add	a3,a3,a4
    80005cae:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005cb2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005cb6:	6798                	ld	a4,8(a5)
    80005cb8:	00275783          	lhu	a5,2(a4)
    80005cbc:	2785                	addiw	a5,a5,1
    80005cbe:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005cc2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005cc6:	100017b7          	lui	a5,0x10001
    80005cca:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005cce:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005cd2:	0001e917          	auipc	s2,0x1e
    80005cd6:	1c690913          	addi	s2,s2,454 # 80023e98 <disk+0x128>
  while(b->disk == 1) {
    80005cda:	4485                	li	s1,1
    80005cdc:	01079a63          	bne	a5,a6,80005cf0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005ce0:	85ca                	mv	a1,s2
    80005ce2:	8552                	mv	a0,s4
    80005ce4:	cdefc0ef          	jal	800021c2 <sleep>
  while(b->disk == 1) {
    80005ce8:	004a2783          	lw	a5,4(s4)
    80005cec:	fe978ae3          	beq	a5,s1,80005ce0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005cf0:	f9042903          	lw	s2,-112(s0)
    80005cf4:	00290713          	addi	a4,s2,2
    80005cf8:	0712                	slli	a4,a4,0x4
    80005cfa:	0001e797          	auipc	a5,0x1e
    80005cfe:	07678793          	addi	a5,a5,118 # 80023d70 <disk>
    80005d02:	97ba                	add	a5,a5,a4
    80005d04:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005d08:	0001e997          	auipc	s3,0x1e
    80005d0c:	06898993          	addi	s3,s3,104 # 80023d70 <disk>
    80005d10:	00491713          	slli	a4,s2,0x4
    80005d14:	0009b783          	ld	a5,0(s3)
    80005d18:	97ba                	add	a5,a5,a4
    80005d1a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005d1e:	854a                	mv	a0,s2
    80005d20:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005d24:	bafff0ef          	jal	800058d2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005d28:	8885                	andi	s1,s1,1
    80005d2a:	f0fd                	bnez	s1,80005d10 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005d2c:	0001e517          	auipc	a0,0x1e
    80005d30:	16c50513          	addi	a0,a0,364 # 80023e98 <disk+0x128>
    80005d34:	f67fa0ef          	jal	80000c9a <release>
}
    80005d38:	70a6                	ld	ra,104(sp)
    80005d3a:	7406                	ld	s0,96(sp)
    80005d3c:	64e6                	ld	s1,88(sp)
    80005d3e:	6946                	ld	s2,80(sp)
    80005d40:	69a6                	ld	s3,72(sp)
    80005d42:	6a06                	ld	s4,64(sp)
    80005d44:	7ae2                	ld	s5,56(sp)
    80005d46:	7b42                	ld	s6,48(sp)
    80005d48:	7ba2                	ld	s7,40(sp)
    80005d4a:	7c02                	ld	s8,32(sp)
    80005d4c:	6ce2                	ld	s9,24(sp)
    80005d4e:	6165                	addi	sp,sp,112
    80005d50:	8082                	ret

0000000080005d52 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005d52:	1101                	addi	sp,sp,-32
    80005d54:	ec06                	sd	ra,24(sp)
    80005d56:	e822                	sd	s0,16(sp)
    80005d58:	e426                	sd	s1,8(sp)
    80005d5a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005d5c:	0001e497          	auipc	s1,0x1e
    80005d60:	01448493          	addi	s1,s1,20 # 80023d70 <disk>
    80005d64:	0001e517          	auipc	a0,0x1e
    80005d68:	13450513          	addi	a0,a0,308 # 80023e98 <disk+0x128>
    80005d6c:	e97fa0ef          	jal	80000c02 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005d70:	100017b7          	lui	a5,0x10001
    80005d74:	53b8                	lw	a4,96(a5)
    80005d76:	8b0d                	andi	a4,a4,3
    80005d78:	100017b7          	lui	a5,0x10001
    80005d7c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005d7e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005d82:	689c                	ld	a5,16(s1)
    80005d84:	0204d703          	lhu	a4,32(s1)
    80005d88:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005d8c:	04f70663          	beq	a4,a5,80005dd8 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005d90:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005d94:	6898                	ld	a4,16(s1)
    80005d96:	0204d783          	lhu	a5,32(s1)
    80005d9a:	8b9d                	andi	a5,a5,7
    80005d9c:	078e                	slli	a5,a5,0x3
    80005d9e:	97ba                	add	a5,a5,a4
    80005da0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005da2:	00278713          	addi	a4,a5,2
    80005da6:	0712                	slli	a4,a4,0x4
    80005da8:	9726                	add	a4,a4,s1
    80005daa:	01074703          	lbu	a4,16(a4)
    80005dae:	e321                	bnez	a4,80005dee <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005db0:	0789                	addi	a5,a5,2
    80005db2:	0792                	slli	a5,a5,0x4
    80005db4:	97a6                	add	a5,a5,s1
    80005db6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005db8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005dbc:	db2fc0ef          	jal	8000236e <wakeup>

    disk.used_idx += 1;
    80005dc0:	0204d783          	lhu	a5,32(s1)
    80005dc4:	2785                	addiw	a5,a5,1
    80005dc6:	17c2                	slli	a5,a5,0x30
    80005dc8:	93c1                	srli	a5,a5,0x30
    80005dca:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005dce:	6898                	ld	a4,16(s1)
    80005dd0:	00275703          	lhu	a4,2(a4)
    80005dd4:	faf71ee3          	bne	a4,a5,80005d90 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005dd8:	0001e517          	auipc	a0,0x1e
    80005ddc:	0c050513          	addi	a0,a0,192 # 80023e98 <disk+0x128>
    80005de0:	ebbfa0ef          	jal	80000c9a <release>
}
    80005de4:	60e2                	ld	ra,24(sp)
    80005de6:	6442                	ld	s0,16(sp)
    80005de8:	64a2                	ld	s1,8(sp)
    80005dea:	6105                	addi	sp,sp,32
    80005dec:	8082                	ret
      panic("virtio_disk_intr status");
    80005dee:	00002517          	auipc	a0,0x2
    80005df2:	97a50513          	addi	a0,a0,-1670 # 80007768 <etext+0x768>
    80005df6:	9adfa0ef          	jal	800007a2 <panic>

0000000080005dfa <sys_random>:
 
//Random
static unsigned int lcg_state=1; //PRNG state
uint64
sys_random(void)
{
    80005dfa:	1141                	addi	sp,sp,-16
    80005dfc:	e422                	sd	s0,8(sp)
    80005dfe:	0800                	addi	s0,sp,16
  // Seed only once using ticks (global variable provided by xv6)
  extern uint ticks;
  if (lcg_state == 1)
    80005e00:	00004717          	auipc	a4,0x4
    80005e04:	6cc72703          	lw	a4,1740(a4) # 8000a4cc <lcg_state>
    80005e08:	4785                	li	a5,1
    80005e0a:	02f70763          	beq	a4,a5,80005e38 <sys_random+0x3e>
    lcg_state = ticks + 1;  // avoid 0 seed

  // LCG formula
  lcg_state = (1103515245 * lcg_state + 12345) & 0x7fffffff;
    80005e0e:	00004717          	auipc	a4,0x4
    80005e12:	6be70713          	addi	a4,a4,1726 # 8000a4cc <lcg_state>
    80005e16:	4314                	lw	a3,0(a4)
    80005e18:	41c657b7          	lui	a5,0x41c65
    80005e1c:	e6d7879b          	addiw	a5,a5,-403 # 41c64e6d <_entry-0x3e39b193>
    80005e20:	02d7853b          	mulw	a0,a5,a3
    80005e24:	678d                	lui	a5,0x3
    80005e26:	0397879b          	addiw	a5,a5,57 # 3039 <_entry-0x7fffcfc7>
    80005e2a:	9d3d                	addw	a0,a0,a5
    80005e2c:	1506                	slli	a0,a0,0x21
    80005e2e:	9105                	srli	a0,a0,0x21
    80005e30:	c308                	sw	a0,0(a4)

  return lcg_state;
}
    80005e32:	6422                	ld	s0,8(sp)
    80005e34:	0141                	addi	sp,sp,16
    80005e36:	8082                	ret
    lcg_state = ticks + 1;  // avoid 0 seed
    80005e38:	00004797          	auipc	a5,0x4
    80005e3c:	7307a783          	lw	a5,1840(a5) # 8000a568 <ticks>
    80005e40:	2785                	addiw	a5,a5,1
    80005e42:	00004717          	auipc	a4,0x4
    80005e46:	68f72523          	sw	a5,1674(a4) # 8000a4cc <lcg_state>
    80005e4a:	b7d1                	j	80005e0e <sys_random+0x14>

0000000080005e4c <sys_datetime>:
  r->day = (int)day;
}

uint64
sys_datetime(void)
{
    80005e4c:	7179                	addi	sp,sp,-48
    80005e4e:	f406                	sd	ra,40(sp)
    80005e50:	f022                	sd	s0,32(sp)
    80005e52:	1800                	addi	s0,sp,48
  uint64 user_addr;
  struct rtcdate rd;

  // get user pointer argument 0
  if(argaddr(0, &user_addr) < 0)
    80005e54:	fe840593          	addi	a1,s0,-24
    80005e58:	4501                	li	a0,0
    80005e5a:	debfc0ef          	jal	80002c44 <argaddr>
    80005e5e:	87aa                	mv	a5,a0
    return -1;
    80005e60:	557d                	li	a0,-1
  if(argaddr(0, &user_addr) < 0)
    80005e62:	1207c363          	bltz	a5,80005f88 <sys_datetime+0x13c>

 volatile uint64 *mtime = (volatile uint64 *)CLINT_MTIME;
 uint64 mtime_val = *mtime;   // increments in cycles / platform timeunits
    80005e66:	0200c7b7          	lui	a5,0x200c
    80005e6a:	ff87b703          	ld	a4,-8(a5) # 200bff8 <_entry-0x7dff4008>
// Now convert to seconds. The conversion constant depends on the platform's mtime frequency.
// On QEMU virt, mtime increments at the host timer frequency used by the platform (platform dependent).

uint64 unix_secs = BOOT_EPOCH + (mtime_val / MTIME_FREQ);
    80005e6e:	009897b7          	lui	a5,0x989
    80005e72:	68078793          	addi	a5,a5,1664 # 989680 <_entry-0x7f676980>
    80005e76:	02f75733          	divu	a4,a4,a5


//TO adjust cairo 
unix_secs+=7200;
    80005e7a:	693c17b7          	lui	a5,0x693c1
    80005e7e:	73e78793          	addi	a5,a5,1854 # 693c173e <_entry-0x16c3e8c2>
    80005e82:	973e                	add	a4,a4,a5
  uint64 rem = secs % 86400;
    80005e84:	66d5                	lui	a3,0x15
    80005e86:	18068693          	addi	a3,a3,384 # 15180 <_entry-0x7ffeae80>
    80005e8a:	02d777b3          	remu	a5,a4,a3
  r->hour = rem / 3600;
    80005e8e:	6605                	lui	a2,0x1
    80005e90:	e1060613          	addi	a2,a2,-496 # e10 <_entry-0x7ffff1f0>
    80005e94:	02c7d5b3          	divu	a1,a5,a2
    80005e98:	fcb42c23          	sw	a1,-40(s0)
  rem %= 3600;
    80005e9c:	02c7f7b3          	remu	a5,a5,a2
  r->minute = rem / 60;
    80005ea0:	03c00613          	li	a2,60
    80005ea4:	02c7d5b3          	divu	a1,a5,a2
    80005ea8:	fcb42a23          	sw	a1,-44(s0)
  r->second = rem % 60;
    80005eac:	02c7f7b3          	remu	a5,a5,a2
    80005eb0:	fcf42823          	sw	a5,-48(s0)
  uint64 days = secs / 86400;
    80005eb4:	02d75733          	divu	a4,a4,a3
  int64_t z = (int64_t)days + 719468; // shift to 0000-03-01 epoch used by algorithm
    80005eb8:	000b07b7          	lui	a5,0xb0
    80005ebc:	a6c78793          	addi	a5,a5,-1428 # afa6c <_entry-0x7ff50594>
    80005ec0:	973e                	add	a4,a4,a5
  int64_t era = (z >= 0 ? z : z - 146096) / 146097;
    80005ec2:	000247b7          	lui	a5,0x24
    80005ec6:	ab178793          	addi	a5,a5,-1359 # 23ab1 <_entry-0x7ffdc54f>
    80005eca:	02f748b3          	div	a7,a4,a5
  unsigned doe = (unsigned)(z - era * 146097);          // [0, 146096]
    80005ece:	02f887bb          	mulw	a5,a7,a5
    80005ed2:	9f1d                	subw	a4,a4,a5
  unsigned yoe = (doe - doe/1460 + doe/36524 - doe/146096) / 365; // [0, 399]
    80005ed4:	66a5                	lui	a3,0x9
    80005ed6:	eac6869b          	addiw	a3,a3,-340 # 8eac <_entry-0x7fff7154>
    80005eda:	02d756bb          	divuw	a3,a4,a3
    80005ede:	9eb9                	addw	a3,a3,a4
    80005ee0:	5b400813          	li	a6,1460
    80005ee4:	030757bb          	divuw	a5,a4,a6
    80005ee8:	9e9d                	subw	a3,a3,a5
    80005eea:	000247b7          	lui	a5,0x24
    80005eee:	ab07879b          	addiw	a5,a5,-1360 # 23ab0 <_entry-0x7ffdc550>
    80005ef2:	02f757bb          	divuw	a5,a4,a5
    80005ef6:	9e9d                	subw	a3,a3,a5
    80005ef8:	16d00593          	li	a1,365
    80005efc:	02b6d53b          	divuw	a0,a3,a1
  int year = (int)(yoe + era * 400);
    80005f00:	19000613          	li	a2,400
    80005f04:	0316063b          	mulw	a2,a2,a7
    80005f08:	9e29                	addw	a2,a2,a0
  unsigned doy = doe - (365*yoe + yoe/4 - yoe/100);     // [0, 365]
    80005f0a:	67a5                	lui	a5,0x9
    80005f0c:	e947879b          	addiw	a5,a5,-364 # 8e94 <_entry-0x7fff716c>
    80005f10:	02f6d7bb          	divuw	a5,a3,a5
    80005f14:	9fb9                	addw	a5,a5,a4
    80005f16:	0306d6bb          	divuw	a3,a3,a6
    80005f1a:	9f95                	subw	a5,a5,a3
    80005f1c:	02a585bb          	mulw	a1,a1,a0
    80005f20:	9f8d                	subw	a5,a5,a1
  unsigned mp = (5*doy + 2) / 153;                      // [0, 11]
    80005f22:	0027971b          	slliw	a4,a5,0x2
    80005f26:	9f3d                	addw	a4,a4,a5
    80005f28:	2709                	addiw	a4,a4,2
    80005f2a:	0007051b          	sext.w	a0,a4
    80005f2e:	09900693          	li	a3,153
    80005f32:	02d7573b          	divuw	a4,a4,a3
  unsigned day = doy - (153*mp+2)/5 + 1;                // [1, 31]
    80005f36:	2785                	addiw	a5,a5,1
    80005f38:	0037169b          	slliw	a3,a4,0x3
    80005f3c:	9eb9                	addw	a3,a3,a4
    80005f3e:	0046959b          	slliw	a1,a3,0x4
    80005f42:	9ead                	addw	a3,a3,a1
    80005f44:	2689                	addiw	a3,a3,2
    80005f46:	4595                	li	a1,5
    80005f48:	02b6d6bb          	divuw	a3,a3,a1
    80005f4c:	9f95                	subw	a5,a5,a3
  unsigned month = mp + (mp < 10 ? 3 : -9);             // [1, 12]
    80005f4e:	5f900593          	li	a1,1529
    80005f52:	56dd                	li	a3,-9
    80005f54:	00a5e363          	bltu	a1,a0,80005f5a <sys_datetime+0x10e>
    80005f58:	468d                	li	a3,3
    80005f5a:	9f35                	addw	a4,a4,a3
    80005f5c:	0007069b          	sext.w	a3,a4
  year += (month <= 2);
    80005f60:	0036b693          	sltiu	a3,a3,3
    80005f64:	9eb1                	addw	a3,a3,a2
  r->year = year;
    80005f66:	fed42223          	sw	a3,-28(s0)
  r->month = (int)month;
    80005f6a:	fee42023          	sw	a4,-32(s0)
  r->day = (int)day;
    80005f6e:	fcf42e23          	sw	a5,-36(s0)

  seconds_to_rtcdate(unix_secs, &rd);


  // copy to user space
  if(copyout(myproc()->pagetable, user_addr, (char *)&rd, sizeof(rd)) < 0)
    80005f72:	9a1fb0ef          	jal	80001912 <myproc>
    80005f76:	46e1                	li	a3,24
    80005f78:	fd040613          	addi	a2,s0,-48
    80005f7c:	fe843583          	ld	a1,-24(s0)
    80005f80:	6928                	ld	a0,80(a0)
    80005f82:	e02fb0ef          	jal	80001584 <copyout>
    80005f86:	957d                	srai	a0,a0,0x3f
    return -1;

  return 0;
}
    80005f88:	70a2                	ld	ra,40(sp)
    80005f8a:	7402                	ld	s0,32(sp)
    80005f8c:	6145                	addi	sp,sp,48
    80005f8e:	8082                	ret

0000000080005f90 <sys_kbdint>:
extern int keyboard_int_cnt;
uint64 sys_kbdint()
{
    80005f90:	1141                	addi	sp,sp,-16
    80005f92:	e422                	sd	s0,8(sp)
    80005f94:	0800                	addi	s0,sp,16

return keyboard_int_cnt;
}
    80005f96:	00004517          	auipc	a0,0x4
    80005f9a:	59a52503          	lw	a0,1434(a0) # 8000a530 <keyboard_int_cnt>
    80005f9e:	6422                	ld	s0,8(sp)
    80005fa0:	0141                	addi	sp,sp,16
    80005fa2:	8082                	ret
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
