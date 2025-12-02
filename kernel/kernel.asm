
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	25013103          	ld	sp,592(sp) # 8000a250 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
    80000022:	304027f3          	csrr	a5,mie
    80000026:	0207e793          	ori	a5,a5,32
    8000002a:	30479073          	csrw	mie,a5
    8000002e:	30a027f3          	csrr	a5,0x30a
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4
    80000038:	30a79073          	csrw	0x30a,a5
    8000003c:	306027f3          	csrr	a5,mcounteren
    80000040:	0027e793          	ori	a5,a5,2
    80000044:	30679073          	csrw	mcounteren,a5
    80000048:	c01027f3          	rdtime	a5
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
    80000056:	14d79073          	csrw	stimecmp,a5
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
    80000068:	300027f3          	csrr	a5,mstatus
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb21f>
    80000072:	8ff9                	and	a5,a5,a4
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
    8000007c:	30079073          	csrw	mstatus,a5
    80000080:	00001797          	auipc	a5,0x1
    80000084:	df078793          	addi	a5,a5,-528 # 80000e70 <main>
    80000088:	34179073          	csrw	mepc,a5
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
    8000009a:	30379073          	csrw	mideleg,a5
    8000009e:	104027f3          	csrr	a5,sie
    800000a2:	2227e793          	ori	a5,a5,546
    800000a6:	10479073          	csrw	sie,a5
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
    800000bc:	f14027f3          	csrr	a5,mhartid
    800000c0:	2781                	sext.w	a5,a5
    800000c2:	823e                	mv	tp,a5
    800000c4:	30200073          	mret
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	f84a                	sd	s2,48(sp)
    800000d8:	0880                	addi	s0,sp,80
    800000da:	04c05263          	blez	a2,8000011e <consolewrite+0x4e>
    800000de:	fc26                	sd	s1,56(sp)
    800000e0:	f44e                	sd	s3,40(sp)
    800000e2:	f052                	sd	s4,32(sp)
    800000e4:	ec56                	sd	s5,24(sp)
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	168020ef          	jal	80002262 <either_copyin>
    800000fe:	03550263          	beq	a0,s5,80000122 <consolewrite+0x52>
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	043000ef          	jal	80000948 <uartputc>
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
    8000012a:	854a                	mv	a0,s2
    8000012c:	60a6                	ld	ra,72(sp)
    8000012e:	6406                	ld	s0,64(sp)
    80000130:	7942                	ld	s2,48(sp)
    80000132:	6161                	addi	sp,sp,80
    80000134:	8082                	ret

0000000080000136 <consoleread>:
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
    80000150:	00060b1b          	sext.w	s6,a2
    80000154:	00012517          	auipc	a0,0x12
    80000158:	15c50513          	addi	a0,a0,348 # 800122b0 <cons>
    8000015c:	2a7000ef          	jal	80000c02 <acquire>
    80000160:	00012497          	auipc	s1,0x12
    80000164:	15048493          	addi	s1,s1,336 # 800122b0 <cons>
    80000168:	00012917          	auipc	s2,0x12
    8000016c:	1e090913          	addi	s2,s2,480 # 80012348 <cons+0x98>
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
    80000180:	76e010ef          	jal	800018ee <myproc>
    80000184:	771010ef          	jal	800020f4 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	52f010ef          	jal	80001ebc <sleep>
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    800001a0:	00012717          	auipc	a4,0x12
    800001a4:	11070713          	addi	a4,a4,272 # 800122b0 <cons>
    800001a8:	0017869b          	addiw	a3,a5,1
    800001ac:	08d72c23          	sw	a3,152(a4)
    800001b0:	07f7f693          	andi	a3,a5,127
    800001b4:	9736                	add	a4,a4,a3
    800001b6:	01874703          	lbu	a4,24(a4)
    800001ba:	00070b9b          	sext.w	s7,a4
    800001be:	4691                	li	a3,4
    800001c0:	04db8663          	beq	s7,a3,8000020c <consoleread+0xd6>
    800001c4:	fae407a3          	sb	a4,-81(s0)
    800001c8:	4685                	li	a3,1
    800001ca:	faf40613          	addi	a2,s0,-81
    800001ce:	85d2                	mv	a1,s4
    800001d0:	8556                	mv	a0,s5
    800001d2:	046020ef          	jal	80002218 <either_copyout>
    800001d6:	57fd                	li	a5,-1
    800001d8:	04f50863          	beq	a0,a5,80000228 <consoleread+0xf2>
    800001dc:	0a05                	addi	s4,s4,1
    800001de:	39fd                	addiw	s3,s3,-1
    800001e0:	47a9                	li	a5,10
    800001e2:	04fb8d63          	beq	s7,a5,8000023c <consoleread+0x106>
    800001e6:	6be2                	ld	s7,24(sp)
    800001e8:	b761                	j	80000170 <consoleread+0x3a>
    800001ea:	00012517          	auipc	a0,0x12
    800001ee:	0c650513          	addi	a0,a0,198 # 800122b0 <cons>
    800001f2:	2a9000ef          	jal	80000c9a <release>
    800001f6:	557d                	li	a0,-1
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
    8000020c:	0009871b          	sext.w	a4,s3
    80000210:	01677a63          	bgeu	a4,s6,80000224 <consoleread+0xee>
    80000214:	00012717          	auipc	a4,0x12
    80000218:	12f72a23          	sw	a5,308(a4) # 80012348 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
    8000022a:	00012517          	auipc	a0,0x12
    8000022e:	08650513          	addi	a0,a0,134 # 800122b0 <cons>
    80000232:	269000ef          	jal	80000c9a <release>
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	bf7d                	j	800001f8 <consoleread+0xc2>
    8000023c:	6be2                	ld	s7,24(sp)
    8000023e:	b7f5                	j	8000022a <consoleread+0xf4>

0000000080000240 <consputc>:
    80000240:	1141                	addi	sp,sp,-16
    80000242:	e406                	sd	ra,8(sp)
    80000244:	e022                	sd	s0,0(sp)
    80000246:	0800                	addi	s0,sp,16
    80000248:	10000793          	li	a5,256
    8000024c:	00f50863          	beq	a0,a5,8000025c <consputc+0x1c>
    80000250:	612000ef          	jal	80000862 <uartputc_sync>
    80000254:	60a2                	ld	ra,8(sp)
    80000256:	6402                	ld	s0,0(sp)
    80000258:	0141                	addi	sp,sp,16
    8000025a:	8082                	ret
    8000025c:	4521                	li	a0,8
    8000025e:	604000ef          	jal	80000862 <uartputc_sync>
    80000262:	02000513          	li	a0,32
    80000266:	5fc000ef          	jal	80000862 <uartputc_sync>
    8000026a:	4521                	li	a0,8
    8000026c:	5f6000ef          	jal	80000862 <uartputc_sync>
    80000270:	b7d5                	j	80000254 <consputc+0x14>

0000000080000272 <consoleintr>:
    80000272:	1101                	addi	sp,sp,-32
    80000274:	ec06                	sd	ra,24(sp)
    80000276:	e822                	sd	s0,16(sp)
    80000278:	e426                	sd	s1,8(sp)
    8000027a:	1000                	addi	s0,sp,32
    8000027c:	84aa                	mv	s1,a0
    8000027e:	00012517          	auipc	a0,0x12
    80000282:	03250513          	addi	a0,a0,50 # 800122b0 <cons>
    80000286:	17d000ef          	jal	80000c02 <acquire>
    8000028a:	0000a717          	auipc	a4,0xa
    8000028e:	fe670713          	addi	a4,a4,-26 # 8000a270 <keyboard_int_cnt>
    80000292:	431c                	lw	a5,0(a4)
    80000294:	2785                	addiw	a5,a5,1
    80000296:	c31c                	sw	a5,0(a4)
    80000298:	47d5                	li	a5,21
    8000029a:	08f48f63          	beq	s1,a5,80000338 <consoleintr+0xc6>
    8000029e:	0297c563          	blt	a5,s1,800002c8 <consoleintr+0x56>
    800002a2:	47a1                	li	a5,8
    800002a4:	0ef48463          	beq	s1,a5,8000038c <consoleintr+0x11a>
    800002a8:	47c1                	li	a5,16
    800002aa:	10f49563          	bne	s1,a5,800003b4 <consoleintr+0x142>
    800002ae:	7ff010ef          	jal	800022ac <procdump>
    800002b2:	00012517          	auipc	a0,0x12
    800002b6:	ffe50513          	addi	a0,a0,-2 # 800122b0 <cons>
    800002ba:	1e1000ef          	jal	80000c9a <release>
    800002be:	60e2                	ld	ra,24(sp)
    800002c0:	6442                	ld	s0,16(sp)
    800002c2:	64a2                	ld	s1,8(sp)
    800002c4:	6105                	addi	sp,sp,32
    800002c6:	8082                	ret
    800002c8:	07f00793          	li	a5,127
    800002cc:	0cf48063          	beq	s1,a5,8000038c <consoleintr+0x11a>
    800002d0:	00012717          	auipc	a4,0x12
    800002d4:	fe070713          	addi	a4,a4,-32 # 800122b0 <cons>
    800002d8:	0a072783          	lw	a5,160(a4)
    800002dc:	09872703          	lw	a4,152(a4)
    800002e0:	9f99                	subw	a5,a5,a4
    800002e2:	07f00713          	li	a4,127
    800002e6:	fcf766e3          	bltu	a4,a5,800002b2 <consoleintr+0x40>
    800002ea:	47b5                	li	a5,13
    800002ec:	0cf48763          	beq	s1,a5,800003ba <consoleintr+0x148>
    800002f0:	8526                	mv	a0,s1
    800002f2:	f4fff0ef          	jal	80000240 <consputc>
    800002f6:	00012797          	auipc	a5,0x12
    800002fa:	fba78793          	addi	a5,a5,-70 # 800122b0 <cons>
    800002fe:	0a07a683          	lw	a3,160(a5)
    80000302:	0016871b          	addiw	a4,a3,1
    80000306:	0007061b          	sext.w	a2,a4
    8000030a:	0ae7a023          	sw	a4,160(a5)
    8000030e:	07f6f693          	andi	a3,a3,127
    80000312:	97b6                	add	a5,a5,a3
    80000314:	00978c23          	sb	s1,24(a5)
    80000318:	47a9                	li	a5,10
    8000031a:	0cf48563          	beq	s1,a5,800003e4 <consoleintr+0x172>
    8000031e:	4791                	li	a5,4
    80000320:	0cf48263          	beq	s1,a5,800003e4 <consoleintr+0x172>
    80000324:	00012797          	auipc	a5,0x12
    80000328:	0247a783          	lw	a5,36(a5) # 80012348 <cons+0x98>
    8000032c:	9f1d                	subw	a4,a4,a5
    8000032e:	08000793          	li	a5,128
    80000332:	f8f710e3          	bne	a4,a5,800002b2 <consoleintr+0x40>
    80000336:	a07d                	j	800003e4 <consoleintr+0x172>
    80000338:	e04a                	sd	s2,0(sp)
    8000033a:	00012717          	auipc	a4,0x12
    8000033e:	f7670713          	addi	a4,a4,-138 # 800122b0 <cons>
    80000342:	0a072783          	lw	a5,160(a4)
    80000346:	09c72703          	lw	a4,156(a4)
    8000034a:	00012497          	auipc	s1,0x12
    8000034e:	f6648493          	addi	s1,s1,-154 # 800122b0 <cons>
    80000352:	4929                	li	s2,10
    80000354:	02f70863          	beq	a4,a5,80000384 <consoleintr+0x112>
    80000358:	37fd                	addiw	a5,a5,-1
    8000035a:	07f7f713          	andi	a4,a5,127
    8000035e:	9726                	add	a4,a4,s1
    80000360:	01874703          	lbu	a4,24(a4)
    80000364:	03270263          	beq	a4,s2,80000388 <consoleintr+0x116>
    80000368:	0af4a023          	sw	a5,160(s1)
    8000036c:	10000513          	li	a0,256
    80000370:	ed1ff0ef          	jal	80000240 <consputc>
    80000374:	0a04a783          	lw	a5,160(s1)
    80000378:	09c4a703          	lw	a4,156(s1)
    8000037c:	fcf71ee3          	bne	a4,a5,80000358 <consoleintr+0xe6>
    80000380:	6902                	ld	s2,0(sp)
    80000382:	bf05                	j	800002b2 <consoleintr+0x40>
    80000384:	6902                	ld	s2,0(sp)
    80000386:	b735                	j	800002b2 <consoleintr+0x40>
    80000388:	6902                	ld	s2,0(sp)
    8000038a:	b725                	j	800002b2 <consoleintr+0x40>
    8000038c:	00012717          	auipc	a4,0x12
    80000390:	f2470713          	addi	a4,a4,-220 # 800122b0 <cons>
    80000394:	0a072783          	lw	a5,160(a4)
    80000398:	09c72703          	lw	a4,156(a4)
    8000039c:	f0f70be3          	beq	a4,a5,800002b2 <consoleintr+0x40>
    800003a0:	37fd                	addiw	a5,a5,-1
    800003a2:	00012717          	auipc	a4,0x12
    800003a6:	faf72723          	sw	a5,-82(a4) # 80012350 <cons+0xa0>
    800003aa:	10000513          	li	a0,256
    800003ae:	e93ff0ef          	jal	80000240 <consputc>
    800003b2:	b701                	j	800002b2 <consoleintr+0x40>
    800003b4:	ee048fe3          	beqz	s1,800002b2 <consoleintr+0x40>
    800003b8:	bf21                	j	800002d0 <consoleintr+0x5e>
    800003ba:	4529                	li	a0,10
    800003bc:	e85ff0ef          	jal	80000240 <consputc>
    800003c0:	00012797          	auipc	a5,0x12
    800003c4:	ef078793          	addi	a5,a5,-272 # 800122b0 <cons>
    800003c8:	0a07a703          	lw	a4,160(a5)
    800003cc:	0017069b          	addiw	a3,a4,1
    800003d0:	0006861b          	sext.w	a2,a3
    800003d4:	0ad7a023          	sw	a3,160(a5)
    800003d8:	07f77713          	andi	a4,a4,127
    800003dc:	97ba                	add	a5,a5,a4
    800003de:	4729                	li	a4,10
    800003e0:	00e78c23          	sb	a4,24(a5)
    800003e4:	00012797          	auipc	a5,0x12
    800003e8:	f6c7a423          	sw	a2,-152(a5) # 8001234c <cons+0x9c>
    800003ec:	00012517          	auipc	a0,0x12
    800003f0:	f5c50513          	addi	a0,a0,-164 # 80012348 <cons+0x98>
    800003f4:	315010ef          	jal	80001f08 <wakeup>
    800003f8:	bd6d                	j	800002b2 <consoleintr+0x40>

00000000800003fa <consoleinit>:
    800003fa:	1141                	addi	sp,sp,-16
    800003fc:	e406                	sd	ra,8(sp)
    800003fe:	e022                	sd	s0,0(sp)
    80000400:	0800                	addi	s0,sp,16
    80000402:	00007597          	auipc	a1,0x7
    80000406:	bfe58593          	addi	a1,a1,-1026 # 80007000 <etext>
    8000040a:	00012517          	auipc	a0,0x12
    8000040e:	ea650513          	addi	a0,a0,-346 # 800122b0 <cons>
    80000412:	770000ef          	jal	80000b82 <initlock>
    80000416:	3f4000ef          	jal	8000080a <uartinit>
    8000041a:	00022797          	auipc	a5,0x22
    8000041e:	02e78793          	addi	a5,a5,46 # 80022448 <devsw>
    80000422:	00000717          	auipc	a4,0x0
    80000426:	d1470713          	addi	a4,a4,-748 # 80000136 <consoleread>
    8000042a:	eb98                	sd	a4,16(a5)
    8000042c:	00000717          	auipc	a4,0x0
    80000430:	ca470713          	addi	a4,a4,-860 # 800000d0 <consolewrite>
    80000434:	ef98                	sd	a4,24(a5)
    80000436:	60a2                	ld	ra,8(sp)
    80000438:	6402                	ld	s0,0(sp)
    8000043a:	0141                	addi	sp,sp,16
    8000043c:	8082                	ret

000000008000043e <printint>:
    8000043e:	7179                	addi	sp,sp,-48
    80000440:	f406                	sd	ra,40(sp)
    80000442:	f022                	sd	s0,32(sp)
    80000444:	1800                	addi	s0,sp,48
    80000446:	c219                	beqz	a2,8000044c <printint+0xe>
    80000448:	08054063          	bltz	a0,800004c8 <printint+0x8a>
    8000044c:	4881                	li	a7,0
    8000044e:	fd040693          	addi	a3,s0,-48
    80000452:	4781                	li	a5,0
    80000454:	00007617          	auipc	a2,0x7
    80000458:	31c60613          	addi	a2,a2,796 # 80007770 <digits>
    8000045c:	883e                	mv	a6,a5
    8000045e:	2785                	addiw	a5,a5,1
    80000460:	02b57733          	remu	a4,a0,a1
    80000464:	9732                	add	a4,a4,a2
    80000466:	00074703          	lbu	a4,0(a4)
    8000046a:	00e68023          	sb	a4,0(a3)
    8000046e:	872a                	mv	a4,a0
    80000470:	02b55533          	divu	a0,a0,a1
    80000474:	0685                	addi	a3,a3,1
    80000476:	feb773e3          	bgeu	a4,a1,8000045c <printint+0x1e>
    8000047a:	00088a63          	beqz	a7,8000048e <printint+0x50>
    8000047e:	1781                	addi	a5,a5,-32
    80000480:	97a2                	add	a5,a5,s0
    80000482:	02d00713          	li	a4,45
    80000486:	fee78823          	sb	a4,-16(a5)
    8000048a:	0028079b          	addiw	a5,a6,2
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
    800004ae:	fff4c503          	lbu	a0,-1(s1)
    800004b2:	d8fff0ef          	jal	80000240 <consputc>
    800004b6:	14fd                	addi	s1,s1,-1
    800004b8:	ff249be3          	bne	s1,s2,800004ae <printint+0x70>
    800004bc:	64e2                	ld	s1,24(sp)
    800004be:	6942                	ld	s2,16(sp)
    800004c0:	70a2                	ld	ra,40(sp)
    800004c2:	7402                	ld	s0,32(sp)
    800004c4:	6145                	addi	sp,sp,48
    800004c6:	8082                	ret
    800004c8:	40a00533          	neg	a0,a0
    800004cc:	4885                	li	a7,1
    800004ce:	b741                	j	8000044e <printint+0x10>

00000000800004d0 <printf>:
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
    800004ee:	00012797          	auipc	a5,0x12
    800004f2:	e827a783          	lw	a5,-382(a5) # 80012370 <pr+0x18>
    800004f6:	f6f43c23          	sd	a5,-136(s0)
    800004fa:	e3a1                	bnez	a5,8000053a <printf+0x6a>
    800004fc:	00840793          	addi	a5,s0,8
    80000500:	f8f43423          	sd	a5,-120(s0)
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
    80000520:	02500a93          	li	s5,37
    80000524:	06400b13          	li	s6,100
    80000528:	06c00c13          	li	s8,108
    8000052c:	07500c93          	li	s9,117
    80000530:	07800d13          	li	s10,120
    80000534:	07000d93          	li	s11,112
    80000538:	a815                	j	8000056c <printf+0x9c>
    8000053a:	00012517          	auipc	a0,0x12
    8000053e:	e1e50513          	addi	a0,a0,-482 # 80012358 <pr>
    80000542:	6c0000ef          	jal	80000c02 <acquire>
    80000546:	00840793          	addi	a5,s0,8
    8000054a:	f8f43423          	sd	a5,-120(s0)
    8000054e:	000a4503          	lbu	a0,0(s4)
    80000552:	fd4d                	bnez	a0,8000050c <printf+0x3c>
    80000554:	a481                	j	80000794 <printf+0x2c4>
    80000556:	cebff0ef          	jal	80000240 <consputc>
    8000055a:	84ce                	mv	s1,s3
    8000055c:	0014899b          	addiw	s3,s1,1
    80000560:	013a07b3          	add	a5,s4,s3
    80000564:	0007c503          	lbu	a0,0(a5)
    80000568:	1e050b63          	beqz	a0,8000075e <printf+0x28e>
    8000056c:	ff5515e3          	bne	a0,s5,80000556 <printf+0x86>
    80000570:	0019849b          	addiw	s1,s3,1
    80000574:	009a07b3          	add	a5,s4,s1
    80000578:	0007c903          	lbu	s2,0(a5)
    8000057c:	1e090163          	beqz	s2,8000075e <printf+0x28e>
    80000580:	0017c783          	lbu	a5,1(a5)
    80000584:	86be                	mv	a3,a5
    80000586:	c789                	beqz	a5,80000590 <printf+0xc0>
    80000588:	009a0733          	add	a4,s4,s1
    8000058c:	00274683          	lbu	a3,2(a4)
    80000590:	03690763          	beq	s2,s6,800005be <printf+0xee>
    80000594:	05890163          	beq	s2,s8,800005d6 <printf+0x106>
    80000598:	0d990b63          	beq	s2,s9,8000066e <printf+0x19e>
    8000059c:	13a90163          	beq	s2,s10,800006be <printf+0x1ee>
    800005a0:	13b90b63          	beq	s2,s11,800006d6 <printf+0x206>
    800005a4:	07300793          	li	a5,115
    800005a8:	16f90a63          	beq	s2,a5,8000071c <printf+0x24c>
    800005ac:	1b590463          	beq	s2,s5,80000754 <printf+0x284>
    800005b0:	8556                	mv	a0,s5
    800005b2:	c8fff0ef          	jal	80000240 <consputc>
    800005b6:	854a                	mv	a0,s2
    800005b8:	c89ff0ef          	jal	80000240 <consputc>
    800005bc:	b745                	j	8000055c <printf+0x8c>
    800005be:	f8843783          	ld	a5,-120(s0)
    800005c2:	00878713          	addi	a4,a5,8
    800005c6:	f8e43423          	sd	a4,-120(s0)
    800005ca:	4605                	li	a2,1
    800005cc:	45a9                	li	a1,10
    800005ce:	4388                	lw	a0,0(a5)
    800005d0:	e6fff0ef          	jal	8000043e <printint>
    800005d4:	b761                	j	8000055c <printf+0x8c>
    800005d6:	03678663          	beq	a5,s6,80000602 <printf+0x132>
    800005da:	05878263          	beq	a5,s8,8000061e <printf+0x14e>
    800005de:	0b978463          	beq	a5,s9,80000686 <printf+0x1b6>
    800005e2:	fda797e3          	bne	a5,s10,800005b0 <printf+0xe0>
    800005e6:	f8843783          	ld	a5,-120(s0)
    800005ea:	00878713          	addi	a4,a5,8
    800005ee:	f8e43423          	sd	a4,-120(s0)
    800005f2:	4601                	li	a2,0
    800005f4:	45c1                	li	a1,16
    800005f6:	6388                	ld	a0,0(a5)
    800005f8:	e47ff0ef          	jal	8000043e <printint>
    800005fc:	0029849b          	addiw	s1,s3,2
    80000600:	bfb1                	j	8000055c <printf+0x8c>
    80000602:	f8843783          	ld	a5,-120(s0)
    80000606:	00878713          	addi	a4,a5,8
    8000060a:	f8e43423          	sd	a4,-120(s0)
    8000060e:	4605                	li	a2,1
    80000610:	45a9                	li	a1,10
    80000612:	6388                	ld	a0,0(a5)
    80000614:	e2bff0ef          	jal	8000043e <printint>
    80000618:	0029849b          	addiw	s1,s3,2
    8000061c:	b781                	j	8000055c <printf+0x8c>
    8000061e:	06400793          	li	a5,100
    80000622:	02f68863          	beq	a3,a5,80000652 <printf+0x182>
    80000626:	07500793          	li	a5,117
    8000062a:	06f68c63          	beq	a3,a5,800006a2 <printf+0x1d2>
    8000062e:	07800793          	li	a5,120
    80000632:	f6f69fe3          	bne	a3,a5,800005b0 <printf+0xe0>
    80000636:	f8843783          	ld	a5,-120(s0)
    8000063a:	00878713          	addi	a4,a5,8
    8000063e:	f8e43423          	sd	a4,-120(s0)
    80000642:	4601                	li	a2,0
    80000644:	45c1                	li	a1,16
    80000646:	6388                	ld	a0,0(a5)
    80000648:	df7ff0ef          	jal	8000043e <printint>
    8000064c:	0039849b          	addiw	s1,s3,3
    80000650:	b731                	j	8000055c <printf+0x8c>
    80000652:	f8843783          	ld	a5,-120(s0)
    80000656:	00878713          	addi	a4,a5,8
    8000065a:	f8e43423          	sd	a4,-120(s0)
    8000065e:	4605                	li	a2,1
    80000660:	45a9                	li	a1,10
    80000662:	6388                	ld	a0,0(a5)
    80000664:	ddbff0ef          	jal	8000043e <printint>
    80000668:	0039849b          	addiw	s1,s3,3
    8000066c:	bdc5                	j	8000055c <printf+0x8c>
    8000066e:	f8843783          	ld	a5,-120(s0)
    80000672:	00878713          	addi	a4,a5,8
    80000676:	f8e43423          	sd	a4,-120(s0)
    8000067a:	4601                	li	a2,0
    8000067c:	45a9                	li	a1,10
    8000067e:	4388                	lw	a0,0(a5)
    80000680:	dbfff0ef          	jal	8000043e <printint>
    80000684:	bde1                	j	8000055c <printf+0x8c>
    80000686:	f8843783          	ld	a5,-120(s0)
    8000068a:	00878713          	addi	a4,a5,8
    8000068e:	f8e43423          	sd	a4,-120(s0)
    80000692:	4601                	li	a2,0
    80000694:	45a9                	li	a1,10
    80000696:	6388                	ld	a0,0(a5)
    80000698:	da7ff0ef          	jal	8000043e <printint>
    8000069c:	0029849b          	addiw	s1,s3,2
    800006a0:	bd75                	j	8000055c <printf+0x8c>
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	addi	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	4601                	li	a2,0
    800006b0:	45a9                	li	a1,10
    800006b2:	6388                	ld	a0,0(a5)
    800006b4:	d8bff0ef          	jal	8000043e <printint>
    800006b8:	0039849b          	addiw	s1,s3,3
    800006bc:	b545                	j	8000055c <printf+0x8c>
    800006be:	f8843783          	ld	a5,-120(s0)
    800006c2:	00878713          	addi	a4,a5,8
    800006c6:	f8e43423          	sd	a4,-120(s0)
    800006ca:	4601                	li	a2,0
    800006cc:	45c1                	li	a1,16
    800006ce:	4388                	lw	a0,0(a5)
    800006d0:	d6fff0ef          	jal	8000043e <printint>
    800006d4:	b561                	j	8000055c <printf+0x8c>
    800006d6:	e4de                	sd	s7,72(sp)
    800006d8:	f8843783          	ld	a5,-120(s0)
    800006dc:	00878713          	addi	a4,a5,8
    800006e0:	f8e43423          	sd	a4,-120(s0)
    800006e4:	0007b983          	ld	s3,0(a5)
    800006e8:	03000513          	li	a0,48
    800006ec:	b55ff0ef          	jal	80000240 <consputc>
    800006f0:	07800513          	li	a0,120
    800006f4:	b4dff0ef          	jal	80000240 <consputc>
    800006f8:	4941                	li	s2,16
    800006fa:	00007b97          	auipc	s7,0x7
    800006fe:	076b8b93          	addi	s7,s7,118 # 80007770 <digits>
    80000702:	03c9d793          	srli	a5,s3,0x3c
    80000706:	97de                	add	a5,a5,s7
    80000708:	0007c503          	lbu	a0,0(a5)
    8000070c:	b35ff0ef          	jal	80000240 <consputc>
    80000710:	0992                	slli	s3,s3,0x4
    80000712:	397d                	addiw	s2,s2,-1
    80000714:	fe0917e3          	bnez	s2,80000702 <printf+0x232>
    80000718:	6ba6                	ld	s7,72(sp)
    8000071a:	b589                	j	8000055c <printf+0x8c>
    8000071c:	f8843783          	ld	a5,-120(s0)
    80000720:	00878713          	addi	a4,a5,8
    80000724:	f8e43423          	sd	a4,-120(s0)
    80000728:	0007b903          	ld	s2,0(a5)
    8000072c:	00090d63          	beqz	s2,80000746 <printf+0x276>
    80000730:	00094503          	lbu	a0,0(s2)
    80000734:	e20504e3          	beqz	a0,8000055c <printf+0x8c>
    80000738:	b09ff0ef          	jal	80000240 <consputc>
    8000073c:	0905                	addi	s2,s2,1
    8000073e:	00094503          	lbu	a0,0(s2)
    80000742:	f97d                	bnez	a0,80000738 <printf+0x268>
    80000744:	bd21                	j	8000055c <printf+0x8c>
    80000746:	00007917          	auipc	s2,0x7
    8000074a:	8c290913          	addi	s2,s2,-1854 # 80007008 <etext+0x8>
    8000074e:	02800513          	li	a0,40
    80000752:	b7dd                	j	80000738 <printf+0x268>
    80000754:	02500513          	li	a0,37
    80000758:	ae9ff0ef          	jal	80000240 <consputc>
    8000075c:	b501                	j	8000055c <printf+0x8c>
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
    80000794:	00012517          	auipc	a0,0x12
    80000798:	bc450513          	addi	a0,a0,-1084 # 80012358 <pr>
    8000079c:	4fe000ef          	jal	80000c9a <release>
    800007a0:	bfd9                	j	80000776 <printf+0x2a6>

00000000800007a2 <panic>:
    800007a2:	1101                	addi	sp,sp,-32
    800007a4:	ec06                	sd	ra,24(sp)
    800007a6:	e822                	sd	s0,16(sp)
    800007a8:	e426                	sd	s1,8(sp)
    800007aa:	1000                	addi	s0,sp,32
    800007ac:	84aa                	mv	s1,a0
    800007ae:	00012797          	auipc	a5,0x12
    800007b2:	bc07a123          	sw	zero,-1086(a5) # 80012370 <pr+0x18>
    800007b6:	00007517          	auipc	a0,0x7
    800007ba:	86250513          	addi	a0,a0,-1950 # 80007018 <etext+0x18>
    800007be:	d13ff0ef          	jal	800004d0 <printf>
    800007c2:	85a6                	mv	a1,s1
    800007c4:	00007517          	auipc	a0,0x7
    800007c8:	85c50513          	addi	a0,a0,-1956 # 80007020 <etext+0x20>
    800007cc:	d05ff0ef          	jal	800004d0 <printf>
    800007d0:	4785                	li	a5,1
    800007d2:	0000a717          	auipc	a4,0xa
    800007d6:	aaf72123          	sw	a5,-1374(a4) # 8000a274 <panicked>
    800007da:	a001                	j	800007da <panic+0x38>

00000000800007dc <printfinit>:
    800007dc:	1101                	addi	sp,sp,-32
    800007de:	ec06                	sd	ra,24(sp)
    800007e0:	e822                	sd	s0,16(sp)
    800007e2:	e426                	sd	s1,8(sp)
    800007e4:	1000                	addi	s0,sp,32
    800007e6:	00012497          	auipc	s1,0x12
    800007ea:	b7248493          	addi	s1,s1,-1166 # 80012358 <pr>
    800007ee:	00007597          	auipc	a1,0x7
    800007f2:	83a58593          	addi	a1,a1,-1990 # 80007028 <etext+0x28>
    800007f6:	8526                	mv	a0,s1
    800007f8:	38a000ef          	jal	80000b82 <initlock>
    800007fc:	4785                	li	a5,1
    800007fe:	cc9c                	sw	a5,24(s1)
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
    80000852:	b2a50513          	addi	a0,a0,-1238 # 80012378 <uart_tx_lock>
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
    80000876:	a027a783          	lw	a5,-1534(a5) # 8000a274 <panicked>
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
    800008ac:	9d07b783          	ld	a5,-1584(a5) # 8000a278 <uart_tx_r>
    800008b0:	0000a717          	auipc	a4,0xa
    800008b4:	9d073703          	ld	a4,-1584(a4) # 8000a280 <uart_tx_w>
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
    800008da:	aa2a8a93          	addi	s5,s5,-1374 # 80012378 <uart_tx_lock>
    uart_tx_r += 1;
    800008de:	0000a497          	auipc	s1,0xa
    800008e2:	99a48493          	addi	s1,s1,-1638 # 8000a278 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008e6:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008ea:	0000a997          	auipc	s3,0xa
    800008ee:	99698993          	addi	s3,s3,-1642 # 8000a280 <uart_tx_w>
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
    8000090c:	5fc010ef          	jal	80001f08 <wakeup>
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
    8000095e:	a1e50513          	addi	a0,a0,-1506 # 80012378 <uart_tx_lock>
    80000962:	2a0000ef          	jal	80000c02 <acquire>
  if(panicked){
    80000966:	0000a797          	auipc	a5,0xa
    8000096a:	90e7a783          	lw	a5,-1778(a5) # 8000a274 <panicked>
    8000096e:	efbd                	bnez	a5,800009ec <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000970:	0000a717          	auipc	a4,0xa
    80000974:	91073703          	ld	a4,-1776(a4) # 8000a280 <uart_tx_w>
    80000978:	0000a797          	auipc	a5,0xa
    8000097c:	9007b783          	ld	a5,-1792(a5) # 8000a278 <uart_tx_r>
    80000980:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000984:	00012997          	auipc	s3,0x12
    80000988:	9f498993          	addi	s3,s3,-1548 # 80012378 <uart_tx_lock>
    8000098c:	0000a497          	auipc	s1,0xa
    80000990:	8ec48493          	addi	s1,s1,-1812 # 8000a278 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000994:	0000a917          	auipc	s2,0xa
    80000998:	8ec90913          	addi	s2,s2,-1812 # 8000a280 <uart_tx_w>
    8000099c:	00e79d63          	bne	a5,a4,800009b6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800009a0:	85ce                	mv	a1,s3
    800009a2:	8526                	mv	a0,s1
    800009a4:	518010ef          	jal	80001ebc <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800009a8:	00093703          	ld	a4,0(s2)
    800009ac:	609c                	ld	a5,0(s1)
    800009ae:	02078793          	addi	a5,a5,32
    800009b2:	fee787e3          	beq	a5,a4,800009a0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009b6:	00012497          	auipc	s1,0x12
    800009ba:	9c248493          	addi	s1,s1,-1598 # 80012378 <uart_tx_lock>
    800009be:	01f77793          	andi	a5,a4,31
    800009c2:	97a6                	add	a5,a5,s1
    800009c4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009c8:	0705                	addi	a4,a4,1
    800009ca:	0000a797          	auipc	a5,0xa
    800009ce:	8ae7bb23          	sd	a4,-1866(a5) # 8000a280 <uart_tx_w>
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
    80000a32:	94a48493          	addi	s1,s1,-1718 # 80012378 <uart_tx_lock>
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
    80000a50:	1101                	addi	sp,sp,-32
    80000a52:	ec06                	sd	ra,24(sp)
    80000a54:	e822                	sd	s0,16(sp)
    80000a56:	e426                	sd	s1,8(sp)
    80000a58:	e04a                	sd	s2,0(sp)
    80000a5a:	1000                	addi	s0,sp,32
    80000a5c:	03451793          	slli	a5,a0,0x34
    80000a60:	e7a9                	bnez	a5,80000aaa <kfree+0x5a>
    80000a62:	84aa                	mv	s1,a0
    80000a64:	00023797          	auipc	a5,0x23
    80000a68:	b7c78793          	addi	a5,a5,-1156 # 800235e0 <end>
    80000a6c:	02f56f63          	bltu	a0,a5,80000aaa <kfree+0x5a>
    80000a70:	47c5                	li	a5,17
    80000a72:	07ee                	slli	a5,a5,0x1b
    80000a74:	02f57b63          	bgeu	a0,a5,80000aaa <kfree+0x5a>
    80000a78:	6605                	lui	a2,0x1
    80000a7a:	4585                	li	a1,1
    80000a7c:	25a000ef          	jal	80000cd6 <memset>
    80000a80:	00012917          	auipc	s2,0x12
    80000a84:	93090913          	addi	s2,s2,-1744 # 800123b0 <kmem>
    80000a88:	854a                	mv	a0,s2
    80000a8a:	178000ef          	jal	80000c02 <acquire>
    80000a8e:	01893783          	ld	a5,24(s2)
    80000a92:	e09c                	sd	a5,0(s1)
    80000a94:	00993c23          	sd	s1,24(s2)
    80000a98:	854a                	mv	a0,s2
    80000a9a:	200000ef          	jal	80000c9a <release>
    80000a9e:	60e2                	ld	ra,24(sp)
    80000aa0:	6442                	ld	s0,16(sp)
    80000aa2:	64a2                	ld	s1,8(sp)
    80000aa4:	6902                	ld	s2,0(sp)
    80000aa6:	6105                	addi	sp,sp,32
    80000aa8:	8082                	ret
    80000aaa:	00006517          	auipc	a0,0x6
    80000aae:	58e50513          	addi	a0,a0,1422 # 80007038 <etext+0x38>
    80000ab2:	cf1ff0ef          	jal	800007a2 <panic>

0000000080000ab6 <freerange>:
    80000ab6:	7179                	addi	sp,sp,-48
    80000ab8:	f406                	sd	ra,40(sp)
    80000aba:	f022                	sd	s0,32(sp)
    80000abc:	ec26                	sd	s1,24(sp)
    80000abe:	1800                	addi	s0,sp,48
    80000ac0:	6785                	lui	a5,0x1
    80000ac2:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ac6:	00e504b3          	add	s1,a0,a4
    80000aca:	777d                	lui	a4,0xfffff
    80000acc:	8cf9                	and	s1,s1,a4
    80000ace:	94be                	add	s1,s1,a5
    80000ad0:	0295e263          	bltu	a1,s1,80000af4 <freerange+0x3e>
    80000ad4:	e84a                	sd	s2,16(sp)
    80000ad6:	e44e                	sd	s3,8(sp)
    80000ad8:	e052                	sd	s4,0(sp)
    80000ada:	892e                	mv	s2,a1
    80000adc:	7a7d                	lui	s4,0xfffff
    80000ade:	6985                	lui	s3,0x1
    80000ae0:	01448533          	add	a0,s1,s4
    80000ae4:	f6dff0ef          	jal	80000a50 <kfree>
    80000ae8:	94ce                	add	s1,s1,s3
    80000aea:	fe997be3          	bgeu	s2,s1,80000ae0 <freerange+0x2a>
    80000aee:	6942                	ld	s2,16(sp)
    80000af0:	69a2                	ld	s3,8(sp)
    80000af2:	6a02                	ld	s4,0(sp)
    80000af4:	70a2                	ld	ra,40(sp)
    80000af6:	7402                	ld	s0,32(sp)
    80000af8:	64e2                	ld	s1,24(sp)
    80000afa:	6145                	addi	sp,sp,48
    80000afc:	8082                	ret

0000000080000afe <kinit>:
    80000afe:	1141                	addi	sp,sp,-16
    80000b00:	e406                	sd	ra,8(sp)
    80000b02:	e022                	sd	s0,0(sp)
    80000b04:	0800                	addi	s0,sp,16
    80000b06:	00006597          	auipc	a1,0x6
    80000b0a:	53a58593          	addi	a1,a1,1338 # 80007040 <etext+0x40>
    80000b0e:	00012517          	auipc	a0,0x12
    80000b12:	8a250513          	addi	a0,a0,-1886 # 800123b0 <kmem>
    80000b16:	06c000ef          	jal	80000b82 <initlock>
    80000b1a:	45c5                	li	a1,17
    80000b1c:	05ee                	slli	a1,a1,0x1b
    80000b1e:	00023517          	auipc	a0,0x23
    80000b22:	ac250513          	addi	a0,a0,-1342 # 800235e0 <end>
    80000b26:	f91ff0ef          	jal	80000ab6 <freerange>
    80000b2a:	60a2                	ld	ra,8(sp)
    80000b2c:	6402                	ld	s0,0(sp)
    80000b2e:	0141                	addi	sp,sp,16
    80000b30:	8082                	ret

0000000080000b32 <kalloc>:
    80000b32:	1101                	addi	sp,sp,-32
    80000b34:	ec06                	sd	ra,24(sp)
    80000b36:	e822                	sd	s0,16(sp)
    80000b38:	e426                	sd	s1,8(sp)
    80000b3a:	1000                	addi	s0,sp,32
    80000b3c:	00012497          	auipc	s1,0x12
    80000b40:	87448493          	addi	s1,s1,-1932 # 800123b0 <kmem>
    80000b44:	8526                	mv	a0,s1
    80000b46:	0bc000ef          	jal	80000c02 <acquire>
    80000b4a:	6c84                	ld	s1,24(s1)
    80000b4c:	c485                	beqz	s1,80000b74 <kalloc+0x42>
    80000b4e:	609c                	ld	a5,0(s1)
    80000b50:	00012517          	auipc	a0,0x12
    80000b54:	86050513          	addi	a0,a0,-1952 # 800123b0 <kmem>
    80000b58:	ed1c                	sd	a5,24(a0)
    80000b5a:	140000ef          	jal	80000c9a <release>
    80000b5e:	6605                	lui	a2,0x1
    80000b60:	4595                	li	a1,5
    80000b62:	8526                	mv	a0,s1
    80000b64:	172000ef          	jal	80000cd6 <memset>
    80000b68:	8526                	mv	a0,s1
    80000b6a:	60e2                	ld	ra,24(sp)
    80000b6c:	6442                	ld	s0,16(sp)
    80000b6e:	64a2                	ld	s1,8(sp)
    80000b70:	6105                	addi	sp,sp,32
    80000b72:	8082                	ret
    80000b74:	00012517          	auipc	a0,0x12
    80000b78:	83c50513          	addi	a0,a0,-1988 # 800123b0 <kmem>
    80000b7c:	11e000ef          	jal	80000c9a <release>
    80000b80:	b7e5                	j	80000b68 <kalloc+0x36>

0000000080000b82 <initlock>:
    80000b82:	1141                	addi	sp,sp,-16
    80000b84:	e422                	sd	s0,8(sp)
    80000b86:	0800                	addi	s0,sp,16
    80000b88:	e50c                	sd	a1,8(a0)
    80000b8a:	00052023          	sw	zero,0(a0)
    80000b8e:	00053823          	sd	zero,16(a0)
    80000b92:	6422                	ld	s0,8(sp)
    80000b94:	0141                	addi	sp,sp,16
    80000b96:	8082                	ret

0000000080000b98 <holding>:
    80000b98:	411c                	lw	a5,0(a0)
    80000b9a:	e399                	bnez	a5,80000ba0 <holding+0x8>
    80000b9c:	4501                	li	a0,0
    80000b9e:	8082                	ret
    80000ba0:	1101                	addi	sp,sp,-32
    80000ba2:	ec06                	sd	ra,24(sp)
    80000ba4:	e822                	sd	s0,16(sp)
    80000ba6:	e426                	sd	s1,8(sp)
    80000ba8:	1000                	addi	s0,sp,32
    80000baa:	6904                	ld	s1,16(a0)
    80000bac:	527000ef          	jal	800018d2 <mycpu>
    80000bb0:	40a48533          	sub	a0,s1,a0
    80000bb4:	00153513          	seqz	a0,a0
    80000bb8:	60e2                	ld	ra,24(sp)
    80000bba:	6442                	ld	s0,16(sp)
    80000bbc:	64a2                	ld	s1,8(sp)
    80000bbe:	6105                	addi	sp,sp,32
    80000bc0:	8082                	ret

0000000080000bc2 <push_off>:
    80000bc2:	1101                	addi	sp,sp,-32
    80000bc4:	ec06                	sd	ra,24(sp)
    80000bc6:	e822                	sd	s0,16(sp)
    80000bc8:	e426                	sd	s1,8(sp)
    80000bca:	1000                	addi	s0,sp,32
    80000bcc:	100024f3          	csrr	s1,sstatus
    80000bd0:	100027f3          	csrr	a5,sstatus
    80000bd4:	9bf5                	andi	a5,a5,-3
    80000bd6:	10079073          	csrw	sstatus,a5
    80000bda:	4f9000ef          	jal	800018d2 <mycpu>
    80000bde:	5d3c                	lw	a5,120(a0)
    80000be0:	cb99                	beqz	a5,80000bf6 <push_off+0x34>
    80000be2:	4f1000ef          	jal	800018d2 <mycpu>
    80000be6:	5d3c                	lw	a5,120(a0)
    80000be8:	2785                	addiw	a5,a5,1
    80000bea:	dd3c                	sw	a5,120(a0)
    80000bec:	60e2                	ld	ra,24(sp)
    80000bee:	6442                	ld	s0,16(sp)
    80000bf0:	64a2                	ld	s1,8(sp)
    80000bf2:	6105                	addi	sp,sp,32
    80000bf4:	8082                	ret
    80000bf6:	4dd000ef          	jal	800018d2 <mycpu>
    80000bfa:	8085                	srli	s1,s1,0x1
    80000bfc:	8885                	andi	s1,s1,1
    80000bfe:	dd64                	sw	s1,124(a0)
    80000c00:	b7cd                	j	80000be2 <push_off+0x20>

0000000080000c02 <acquire>:
    80000c02:	1101                	addi	sp,sp,-32
    80000c04:	ec06                	sd	ra,24(sp)
    80000c06:	e822                	sd	s0,16(sp)
    80000c08:	e426                	sd	s1,8(sp)
    80000c0a:	1000                	addi	s0,sp,32
    80000c0c:	84aa                	mv	s1,a0
    80000c0e:	fb5ff0ef          	jal	80000bc2 <push_off>
    80000c12:	8526                	mv	a0,s1
    80000c14:	f85ff0ef          	jal	80000b98 <holding>
    80000c18:	4705                	li	a4,1
    80000c1a:	e105                	bnez	a0,80000c3a <acquire+0x38>
    80000c1c:	87ba                	mv	a5,a4
    80000c1e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c22:	2781                	sext.w	a5,a5
    80000c24:	ffe5                	bnez	a5,80000c1c <acquire+0x1a>
    80000c26:	0330000f          	fence	rw,rw
    80000c2a:	4a9000ef          	jal	800018d2 <mycpu>
    80000c2e:	e888                	sd	a0,16(s1)
    80000c30:	60e2                	ld	ra,24(sp)
    80000c32:	6442                	ld	s0,16(sp)
    80000c34:	64a2                	ld	s1,8(sp)
    80000c36:	6105                	addi	sp,sp,32
    80000c38:	8082                	ret
    80000c3a:	00006517          	auipc	a0,0x6
    80000c3e:	40e50513          	addi	a0,a0,1038 # 80007048 <etext+0x48>
    80000c42:	b61ff0ef          	jal	800007a2 <panic>

0000000080000c46 <pop_off>:
    80000c46:	1141                	addi	sp,sp,-16
    80000c48:	e406                	sd	ra,8(sp)
    80000c4a:	e022                	sd	s0,0(sp)
    80000c4c:	0800                	addi	s0,sp,16
    80000c4e:	485000ef          	jal	800018d2 <mycpu>
    80000c52:	100027f3          	csrr	a5,sstatus
    80000c56:	8b89                	andi	a5,a5,2
    80000c58:	e78d                	bnez	a5,80000c82 <pop_off+0x3c>
    80000c5a:	5d3c                	lw	a5,120(a0)
    80000c5c:	02f05963          	blez	a5,80000c8e <pop_off+0x48>
    80000c60:	37fd                	addiw	a5,a5,-1
    80000c62:	0007871b          	sext.w	a4,a5
    80000c66:	dd3c                	sw	a5,120(a0)
    80000c68:	eb09                	bnez	a4,80000c7a <pop_off+0x34>
    80000c6a:	5d7c                	lw	a5,124(a0)
    80000c6c:	c799                	beqz	a5,80000c7a <pop_off+0x34>
    80000c6e:	100027f3          	csrr	a5,sstatus
    80000c72:	0027e793          	ori	a5,a5,2
    80000c76:	10079073          	csrw	sstatus,a5
    80000c7a:	60a2                	ld	ra,8(sp)
    80000c7c:	6402                	ld	s0,0(sp)
    80000c7e:	0141                	addi	sp,sp,16
    80000c80:	8082                	ret
    80000c82:	00006517          	auipc	a0,0x6
    80000c86:	3ce50513          	addi	a0,a0,974 # 80007050 <etext+0x50>
    80000c8a:	b19ff0ef          	jal	800007a2 <panic>
    80000c8e:	00006517          	auipc	a0,0x6
    80000c92:	3da50513          	addi	a0,a0,986 # 80007068 <etext+0x68>
    80000c96:	b0dff0ef          	jal	800007a2 <panic>

0000000080000c9a <release>:
    80000c9a:	1101                	addi	sp,sp,-32
    80000c9c:	ec06                	sd	ra,24(sp)
    80000c9e:	e822                	sd	s0,16(sp)
    80000ca0:	e426                	sd	s1,8(sp)
    80000ca2:	1000                	addi	s0,sp,32
    80000ca4:	84aa                	mv	s1,a0
    80000ca6:	ef3ff0ef          	jal	80000b98 <holding>
    80000caa:	c105                	beqz	a0,80000cca <release+0x30>
    80000cac:	0004b823          	sd	zero,16(s1)
    80000cb0:	0330000f          	fence	rw,rw
    80000cb4:	0310000f          	fence	rw,w
    80000cb8:	0004a023          	sw	zero,0(s1)
    80000cbc:	f8bff0ef          	jal	80000c46 <pop_off>
    80000cc0:	60e2                	ld	ra,24(sp)
    80000cc2:	6442                	ld	s0,16(sp)
    80000cc4:	64a2                	ld	s1,8(sp)
    80000cc6:	6105                	addi	sp,sp,32
    80000cc8:	8082                	ret
    80000cca:	00006517          	auipc	a0,0x6
    80000cce:	3a650513          	addi	a0,a0,934 # 80007070 <etext+0x70>
    80000cd2:	ad1ff0ef          	jal	800007a2 <panic>

0000000080000cd6 <memset>:
    80000cd6:	1141                	addi	sp,sp,-16
    80000cd8:	e422                	sd	s0,8(sp)
    80000cda:	0800                	addi	s0,sp,16
    80000cdc:	ca19                	beqz	a2,80000cf2 <memset+0x1c>
    80000cde:	87aa                	mv	a5,a0
    80000ce0:	1602                	slli	a2,a2,0x20
    80000ce2:	9201                	srli	a2,a2,0x20
    80000ce4:	00a60733          	add	a4,a2,a0
    80000ce8:	00b78023          	sb	a1,0(a5)
    80000cec:	0785                	addi	a5,a5,1
    80000cee:	fee79de3          	bne	a5,a4,80000ce8 <memset+0x12>
    80000cf2:	6422                	ld	s0,8(sp)
    80000cf4:	0141                	addi	sp,sp,16
    80000cf6:	8082                	ret

0000000080000cf8 <memcmp>:
    80000cf8:	1141                	addi	sp,sp,-16
    80000cfa:	e422                	sd	s0,8(sp)
    80000cfc:	0800                	addi	s0,sp,16
    80000cfe:	ca05                	beqz	a2,80000d2e <memcmp+0x36>
    80000d00:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d04:	1682                	slli	a3,a3,0x20
    80000d06:	9281                	srli	a3,a3,0x20
    80000d08:	0685                	addi	a3,a3,1
    80000d0a:	96aa                	add	a3,a3,a0
    80000d0c:	00054783          	lbu	a5,0(a0)
    80000d10:	0005c703          	lbu	a4,0(a1)
    80000d14:	00e79863          	bne	a5,a4,80000d24 <memcmp+0x2c>
    80000d18:	0505                	addi	a0,a0,1
    80000d1a:	0585                	addi	a1,a1,1
    80000d1c:	fed518e3          	bne	a0,a3,80000d0c <memcmp+0x14>
    80000d20:	4501                	li	a0,0
    80000d22:	a019                	j	80000d28 <memcmp+0x30>
    80000d24:	40e7853b          	subw	a0,a5,a4
    80000d28:	6422                	ld	s0,8(sp)
    80000d2a:	0141                	addi	sp,sp,16
    80000d2c:	8082                	ret
    80000d2e:	4501                	li	a0,0
    80000d30:	bfe5                	j	80000d28 <memcmp+0x30>

0000000080000d32 <memmove>:
    80000d32:	1141                	addi	sp,sp,-16
    80000d34:	e422                	sd	s0,8(sp)
    80000d36:	0800                	addi	s0,sp,16
    80000d38:	c205                	beqz	a2,80000d58 <memmove+0x26>
    80000d3a:	02a5e263          	bltu	a1,a0,80000d5e <memmove+0x2c>
    80000d3e:	1602                	slli	a2,a2,0x20
    80000d40:	9201                	srli	a2,a2,0x20
    80000d42:	00c587b3          	add	a5,a1,a2
    80000d46:	872a                	mv	a4,a0
    80000d48:	0585                	addi	a1,a1,1
    80000d4a:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdba21>
    80000d4c:	fff5c683          	lbu	a3,-1(a1)
    80000d50:	fed70fa3          	sb	a3,-1(a4)
    80000d54:	feb79ae3          	bne	a5,a1,80000d48 <memmove+0x16>
    80000d58:	6422                	ld	s0,8(sp)
    80000d5a:	0141                	addi	sp,sp,16
    80000d5c:	8082                	ret
    80000d5e:	02061693          	slli	a3,a2,0x20
    80000d62:	9281                	srli	a3,a3,0x20
    80000d64:	00d58733          	add	a4,a1,a3
    80000d68:	fce57be3          	bgeu	a0,a4,80000d3e <memmove+0xc>
    80000d6c:	96aa                	add	a3,a3,a0
    80000d6e:	fff6079b          	addiw	a5,a2,-1
    80000d72:	1782                	slli	a5,a5,0x20
    80000d74:	9381                	srli	a5,a5,0x20
    80000d76:	fff7c793          	not	a5,a5
    80000d7a:	97ba                	add	a5,a5,a4
    80000d7c:	177d                	addi	a4,a4,-1
    80000d7e:	16fd                	addi	a3,a3,-1
    80000d80:	00074603          	lbu	a2,0(a4)
    80000d84:	00c68023          	sb	a2,0(a3)
    80000d88:	fef71ae3          	bne	a4,a5,80000d7c <memmove+0x4a>
    80000d8c:	b7f1                	j	80000d58 <memmove+0x26>

0000000080000d8e <memcpy>:
    80000d8e:	1141                	addi	sp,sp,-16
    80000d90:	e406                	sd	ra,8(sp)
    80000d92:	e022                	sd	s0,0(sp)
    80000d94:	0800                	addi	s0,sp,16
    80000d96:	f9dff0ef          	jal	80000d32 <memmove>
    80000d9a:	60a2                	ld	ra,8(sp)
    80000d9c:	6402                	ld	s0,0(sp)
    80000d9e:	0141                	addi	sp,sp,16
    80000da0:	8082                	ret

0000000080000da2 <strncmp>:
    80000da2:	1141                	addi	sp,sp,-16
    80000da4:	e422                	sd	s0,8(sp)
    80000da6:	0800                	addi	s0,sp,16
    80000da8:	ce11                	beqz	a2,80000dc4 <strncmp+0x22>
    80000daa:	00054783          	lbu	a5,0(a0)
    80000dae:	cf89                	beqz	a5,80000dc8 <strncmp+0x26>
    80000db0:	0005c703          	lbu	a4,0(a1)
    80000db4:	00f71a63          	bne	a4,a5,80000dc8 <strncmp+0x26>
    80000db8:	367d                	addiw	a2,a2,-1
    80000dba:	0505                	addi	a0,a0,1
    80000dbc:	0585                	addi	a1,a1,1
    80000dbe:	f675                	bnez	a2,80000daa <strncmp+0x8>
    80000dc0:	4501                	li	a0,0
    80000dc2:	a801                	j	80000dd2 <strncmp+0x30>
    80000dc4:	4501                	li	a0,0
    80000dc6:	a031                	j	80000dd2 <strncmp+0x30>
    80000dc8:	00054503          	lbu	a0,0(a0)
    80000dcc:	0005c783          	lbu	a5,0(a1)
    80000dd0:	9d1d                	subw	a0,a0,a5
    80000dd2:	6422                	ld	s0,8(sp)
    80000dd4:	0141                	addi	sp,sp,16
    80000dd6:	8082                	ret

0000000080000dd8 <strncpy>:
    80000dd8:	1141                	addi	sp,sp,-16
    80000dda:	e422                	sd	s0,8(sp)
    80000ddc:	0800                	addi	s0,sp,16
    80000dde:	87aa                	mv	a5,a0
    80000de0:	86b2                	mv	a3,a2
    80000de2:	367d                	addiw	a2,a2,-1
    80000de4:	02d05563          	blez	a3,80000e0e <strncpy+0x36>
    80000de8:	0785                	addi	a5,a5,1
    80000dea:	0005c703          	lbu	a4,0(a1)
    80000dee:	fee78fa3          	sb	a4,-1(a5)
    80000df2:	0585                	addi	a1,a1,1
    80000df4:	f775                	bnez	a4,80000de0 <strncpy+0x8>
    80000df6:	873e                	mv	a4,a5
    80000df8:	9fb5                	addw	a5,a5,a3
    80000dfa:	37fd                	addiw	a5,a5,-1
    80000dfc:	00c05963          	blez	a2,80000e0e <strncpy+0x36>
    80000e00:	0705                	addi	a4,a4,1
    80000e02:	fe070fa3          	sb	zero,-1(a4)
    80000e06:	40e786bb          	subw	a3,a5,a4
    80000e0a:	fed04be3          	bgtz	a3,80000e00 <strncpy+0x28>
    80000e0e:	6422                	ld	s0,8(sp)
    80000e10:	0141                	addi	sp,sp,16
    80000e12:	8082                	ret

0000000080000e14 <safestrcpy>:
    80000e14:	1141                	addi	sp,sp,-16
    80000e16:	e422                	sd	s0,8(sp)
    80000e18:	0800                	addi	s0,sp,16
    80000e1a:	02c05363          	blez	a2,80000e40 <safestrcpy+0x2c>
    80000e1e:	fff6069b          	addiw	a3,a2,-1
    80000e22:	1682                	slli	a3,a3,0x20
    80000e24:	9281                	srli	a3,a3,0x20
    80000e26:	96ae                	add	a3,a3,a1
    80000e28:	87aa                	mv	a5,a0
    80000e2a:	00d58963          	beq	a1,a3,80000e3c <safestrcpy+0x28>
    80000e2e:	0585                	addi	a1,a1,1
    80000e30:	0785                	addi	a5,a5,1
    80000e32:	fff5c703          	lbu	a4,-1(a1)
    80000e36:	fee78fa3          	sb	a4,-1(a5)
    80000e3a:	fb65                	bnez	a4,80000e2a <safestrcpy+0x16>
    80000e3c:	00078023          	sb	zero,0(a5)
    80000e40:	6422                	ld	s0,8(sp)
    80000e42:	0141                	addi	sp,sp,16
    80000e44:	8082                	ret

0000000080000e46 <strlen>:
    80000e46:	1141                	addi	sp,sp,-16
    80000e48:	e422                	sd	s0,8(sp)
    80000e4a:	0800                	addi	s0,sp,16
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
    80000e66:	6422                	ld	s0,8(sp)
    80000e68:	0141                	addi	sp,sp,16
    80000e6a:	8082                	ret
    80000e6c:	4501                	li	a0,0
    80000e6e:	bfe5                	j	80000e66 <strlen+0x20>

0000000080000e70 <main>:
    80000e70:	1141                	addi	sp,sp,-16
    80000e72:	e406                	sd	ra,8(sp)
    80000e74:	e022                	sd	s0,0(sp)
    80000e76:	0800                	addi	s0,sp,16
    80000e78:	24b000ef          	jal	800018c2 <cpuid>
    80000e7c:	00009717          	auipc	a4,0x9
    80000e80:	40c70713          	addi	a4,a4,1036 # 8000a288 <started>
    80000e84:	c51d                	beqz	a0,80000eb2 <main+0x42>
    80000e86:	431c                	lw	a5,0(a4)
    80000e88:	2781                	sext.w	a5,a5
    80000e8a:	dff5                	beqz	a5,80000e86 <main+0x16>
    80000e8c:	0330000f          	fence	rw,rw
    80000e90:	233000ef          	jal	800018c2 <cpuid>
    80000e94:	85aa                	mv	a1,a0
    80000e96:	00006517          	auipc	a0,0x6
    80000e9a:	20250513          	addi	a0,a0,514 # 80007098 <etext+0x98>
    80000e9e:	e32ff0ef          	jal	800004d0 <printf>
    80000ea2:	080000ef          	jal	80000f22 <kvminithart>
    80000ea6:	538010ef          	jal	800023de <trapinithart>
    80000eaa:	3ee040ef          	jal	80005298 <plicinithart>
    80000eae:	675000ef          	jal	80001d22 <scheduler>
    80000eb2:	d48ff0ef          	jal	800003fa <consoleinit>
    80000eb6:	927ff0ef          	jal	800007dc <printfinit>
    80000eba:	00006517          	auipc	a0,0x6
    80000ebe:	1be50513          	addi	a0,a0,446 # 80007078 <etext+0x78>
    80000ec2:	e0eff0ef          	jal	800004d0 <printf>
    80000ec6:	00006517          	auipc	a0,0x6
    80000eca:	1ba50513          	addi	a0,a0,442 # 80007080 <etext+0x80>
    80000ece:	e02ff0ef          	jal	800004d0 <printf>
    80000ed2:	00006517          	auipc	a0,0x6
    80000ed6:	1a650513          	addi	a0,a0,422 # 80007078 <etext+0x78>
    80000eda:	df6ff0ef          	jal	800004d0 <printf>
    80000ede:	c21ff0ef          	jal	80000afe <kinit>
    80000ee2:	2ca000ef          	jal	800011ac <kvminit>
    80000ee6:	03c000ef          	jal	80000f22 <kvminithart>
    80000eea:	123000ef          	jal	8000180c <procinit>
    80000eee:	4cc010ef          	jal	800023ba <trapinit>
    80000ef2:	4ec010ef          	jal	800023de <trapinithart>
    80000ef6:	388040ef          	jal	8000527e <plicinit>
    80000efa:	39e040ef          	jal	80005298 <plicinithart>
    80000efe:	34d010ef          	jal	80002a4a <binit>
    80000f02:	13e020ef          	jal	80003040 <iinit>
    80000f06:	6eb020ef          	jal	80003df0 <fileinit>
    80000f0a:	47e040ef          	jal	80005388 <virtio_disk_init>
    80000f0e:	449000ef          	jal	80001b56 <userinit>
    80000f12:	0330000f          	fence	rw,rw
    80000f16:	4785                	li	a5,1
    80000f18:	00009717          	auipc	a4,0x9
    80000f1c:	36f72823          	sw	a5,880(a4) # 8000a288 <started>
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
    80000f30:	3647b783          	ld	a5,868(a5) # 8000a290 <kernel_pagetable>
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
    80000f9e:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdba17>
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
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001126:	4719                	li	a4,6
    80001128:	6685                	lui	a3,0x1
    8000112a:	10001637          	lui	a2,0x10001
    8000112e:	100015b7          	lui	a1,0x10001
    80001132:	8526                	mv	a0,s1
    80001134:	f9fff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001138:	4719                	li	a4,6
    8000113a:	040006b7          	lui	a3,0x4000
    8000113e:	0c000637          	lui	a2,0xc000
    80001142:	0c0005b7          	lui	a1,0xc000
    80001146:	8526                	mv	a0,s1
    80001148:	f8bff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
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
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000116a:	46c5                	li	a3,17
    8000116c:	06ee                	slli	a3,a3,0x1b
    8000116e:	4719                	li	a4,6
    80001170:	412686b3          	sub	a3,a3,s2
    80001174:	864a                	mv	a2,s2
    80001176:	85ca                	mv	a1,s2
    80001178:	8526                	mv	a0,s1
    8000117a:	f59ff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000117e:	4729                	li	a4,10
    80001180:	6685                	lui	a3,0x1
    80001182:	00005617          	auipc	a2,0x5
    80001186:	e7e60613          	addi	a2,a2,-386 # 80006000 <_trampoline>
    8000118a:	040005b7          	lui	a1,0x4000
    8000118e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001190:	05b2                	slli	a1,a1,0xc
    80001192:	8526                	mv	a0,s1
    80001194:	f3fff0ef          	jal	800010d2 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001198:	8526                	mv	a0,s1
    8000119a:	5da000ef          	jal	80001774 <proc_mapstacks>
}
    8000119e:	8526                	mv	a0,s1
    800011a0:	60e2                	ld	ra,24(sp)
    800011a2:	6442                	ld	s0,16(sp)
    800011a4:	64a2                	ld	s1,8(sp)
    800011a6:	6902                	ld	s2,0(sp)
    800011a8:	6105                	addi	sp,sp,32
    800011aa:	8082                	ret

00000000800011ac <kvminit>:
{
    800011ac:	1141                	addi	sp,sp,-16
    800011ae:	e406                	sd	ra,8(sp)
    800011b0:	e022                	sd	s0,0(sp)
    800011b2:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011b4:	f47ff0ef          	jal	800010fa <kvmmake>
    800011b8:	00009797          	auipc	a5,0x9
    800011bc:	0ca7bc23          	sd	a0,216(a5) # 8000a290 <kernel_pagetable>
}
    800011c0:	60a2                	ld	ra,8(sp)
    800011c2:	6402                	ld	s0,0(sp)
    800011c4:	0141                	addi	sp,sp,16
    800011c6:	8082                	ret

00000000800011c8 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011c8:	715d                	addi	sp,sp,-80
    800011ca:	e486                	sd	ra,72(sp)
    800011cc:	e0a2                	sd	s0,64(sp)
    800011ce:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
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
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011e8:	0632                	slli	a2,a2,0xc
    800011ea:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800011ee:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
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
    panic("uvmunmap: not aligned");
    80001208:	00006517          	auipc	a0,0x6
    8000120c:	f1850513          	addi	a0,a0,-232 # 80007120 <etext+0x120>
    80001210:	d92ff0ef          	jal	800007a2 <panic>
      panic("uvmunmap: walk");
    80001214:	00006517          	auipc	a0,0x6
    80001218:	f2450513          	addi	a0,a0,-220 # 80007138 <etext+0x138>
    8000121c:	d86ff0ef          	jal	800007a2 <panic>
      panic("uvmunmap: not mapped");
    80001220:	00006517          	auipc	a0,0x6
    80001224:	f2850513          	addi	a0,a0,-216 # 80007148 <etext+0x148>
    80001228:	d7aff0ef          	jal	800007a2 <panic>
      panic("uvmunmap: not a leaf");
    8000122c:	00006517          	auipc	a0,0x6
    80001230:	f3450513          	addi	a0,a0,-204 # 80007160 <etext+0x160>
    80001234:	d6eff0ef          	jal	800007a2 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001238:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000123c:	995a                	add	s2,s2,s6
    8000123e:	03397863          	bgeu	s2,s3,8000126e <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001242:	4601                	li	a2,0
    80001244:	85ca                	mv	a1,s2
    80001246:	8552                	mv	a0,s4
    80001248:	d03ff0ef          	jal	80000f4a <walk>
    8000124c:	84aa                	mv	s1,a0
    8000124e:	d179                	beqz	a0,80001214 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001250:	6108                	ld	a0,0(a0)
    80001252:	00157793          	andi	a5,a0,1
    80001256:	d7e9                	beqz	a5,80001220 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001258:	3ff57793          	andi	a5,a0,1023
    8000125c:	fd7788e3          	beq	a5,s7,8000122c <uvmunmap+0x64>
    if(do_free){
    80001260:	fc0a8ce3          	beqz	s5,80001238 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    80001264:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
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
  }
}
    8000127c:	60a6                	ld	ra,72(sp)
    8000127e:	6406                	ld	s0,64(sp)
    80001280:	6161                	addi	sp,sp,80
    80001282:	8082                	ret

0000000080001284 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001284:	1101                	addi	sp,sp,-32
    80001286:	ec06                	sd	ra,24(sp)
    80001288:	e822                	sd	s0,16(sp)
    8000128a:	e426                	sd	s1,8(sp)
    8000128c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000128e:	8a5ff0ef          	jal	80000b32 <kalloc>
    80001292:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001294:	c509                	beqz	a0,8000129e <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001296:	6605                	lui	a2,0x1
    80001298:	4581                	li	a1,0
    8000129a:	a3dff0ef          	jal	80000cd6 <memset>
  return pagetable;
}
    8000129e:	8526                	mv	a0,s1
    800012a0:	60e2                	ld	ra,24(sp)
    800012a2:	6442                	ld	s0,16(sp)
    800012a4:	64a2                	ld	s1,8(sp)
    800012a6:	6105                	addi	sp,sp,32
    800012a8:	8082                	ret

00000000800012aa <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800012aa:	7179                	addi	sp,sp,-48
    800012ac:	f406                	sd	ra,40(sp)
    800012ae:	f022                	sd	s0,32(sp)
    800012b0:	ec26                	sd	s1,24(sp)
    800012b2:	e84a                	sd	s2,16(sp)
    800012b4:	e44e                	sd	s3,8(sp)
    800012b6:	e052                	sd	s4,0(sp)
    800012b8:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012ba:	6785                	lui	a5,0x1
    800012bc:	04f67063          	bgeu	a2,a5,800012fc <uvmfirst+0x52>
    800012c0:	8a2a                	mv	s4,a0
    800012c2:	89ae                	mv	s3,a1
    800012c4:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012c6:	86dff0ef          	jal	80000b32 <kalloc>
    800012ca:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012cc:	6605                	lui	a2,0x1
    800012ce:	4581                	li	a1,0
    800012d0:	a07ff0ef          	jal	80000cd6 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012d4:	4779                	li	a4,30
    800012d6:	86ca                	mv	a3,s2
    800012d8:	6605                	lui	a2,0x1
    800012da:	4581                	li	a1,0
    800012dc:	8552                	mv	a0,s4
    800012de:	d45ff0ef          	jal	80001022 <mappages>
  memmove(mem, src, sz);
    800012e2:	8626                	mv	a2,s1
    800012e4:	85ce                	mv	a1,s3
    800012e6:	854a                	mv	a0,s2
    800012e8:	a4bff0ef          	jal	80000d32 <memmove>
}
    800012ec:	70a2                	ld	ra,40(sp)
    800012ee:	7402                	ld	s0,32(sp)
    800012f0:	64e2                	ld	s1,24(sp)
    800012f2:	6942                	ld	s2,16(sp)
    800012f4:	69a2                	ld	s3,8(sp)
    800012f6:	6a02                	ld	s4,0(sp)
    800012f8:	6145                	addi	sp,sp,48
    800012fa:	8082                	ret
    panic("uvmfirst: more than a page");
    800012fc:	00006517          	auipc	a0,0x6
    80001300:	e7c50513          	addi	a0,a0,-388 # 80007178 <etext+0x178>
    80001304:	c9eff0ef          	jal	800007a2 <panic>

0000000080001308 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001308:	1101                	addi	sp,sp,-32
    8000130a:	ec06                	sd	ra,24(sp)
    8000130c:	e822                	sd	s0,16(sp)
    8000130e:	e426                	sd	s1,8(sp)
    80001310:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001312:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001314:	00b67d63          	bgeu	a2,a1,8000132e <uvmdealloc+0x26>
    80001318:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000131a:	6785                	lui	a5,0x1
    8000131c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000131e:	00f60733          	add	a4,a2,a5
    80001322:	76fd                	lui	a3,0xfffff
    80001324:	8f75                	and	a4,a4,a3
    80001326:	97ae                	add	a5,a5,a1
    80001328:	8ff5                	and	a5,a5,a3
    8000132a:	00f76863          	bltu	a4,a5,8000133a <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000132e:	8526                	mv	a0,s1
    80001330:	60e2                	ld	ra,24(sp)
    80001332:	6442                	ld	s0,16(sp)
    80001334:	64a2                	ld	s1,8(sp)
    80001336:	6105                	addi	sp,sp,32
    80001338:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000133a:	8f99                	sub	a5,a5,a4
    8000133c:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000133e:	4685                	li	a3,1
    80001340:	0007861b          	sext.w	a2,a5
    80001344:	85ba                	mv	a1,a4
    80001346:	e83ff0ef          	jal	800011c8 <uvmunmap>
    8000134a:	b7d5                	j	8000132e <uvmdealloc+0x26>

000000008000134c <uvmalloc>:
  if(newsz < oldsz)
    8000134c:	08b66f63          	bltu	a2,a1,800013ea <uvmalloc+0x9e>
{
    80001350:	7139                	addi	sp,sp,-64
    80001352:	fc06                	sd	ra,56(sp)
    80001354:	f822                	sd	s0,48(sp)
    80001356:	ec4e                	sd	s3,24(sp)
    80001358:	e852                	sd	s4,16(sp)
    8000135a:	e456                	sd	s5,8(sp)
    8000135c:	0080                	addi	s0,sp,64
    8000135e:	8aaa                	mv	s5,a0
    80001360:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001362:	6785                	lui	a5,0x1
    80001364:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001366:	95be                	add	a1,a1,a5
    80001368:	77fd                	lui	a5,0xfffff
    8000136a:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000136e:	08c9f063          	bgeu	s3,a2,800013ee <uvmalloc+0xa2>
    80001372:	f426                	sd	s1,40(sp)
    80001374:	f04a                	sd	s2,32(sp)
    80001376:	e05a                	sd	s6,0(sp)
    80001378:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000137a:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000137e:	fb4ff0ef          	jal	80000b32 <kalloc>
    80001382:	84aa                	mv	s1,a0
    if(mem == 0){
    80001384:	c515                	beqz	a0,800013b0 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001386:	6605                	lui	a2,0x1
    80001388:	4581                	li	a1,0
    8000138a:	94dff0ef          	jal	80000cd6 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000138e:	875a                	mv	a4,s6
    80001390:	86a6                	mv	a3,s1
    80001392:	6605                	lui	a2,0x1
    80001394:	85ca                	mv	a1,s2
    80001396:	8556                	mv	a0,s5
    80001398:	c8bff0ef          	jal	80001022 <mappages>
    8000139c:	e915                	bnez	a0,800013d0 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000139e:	6785                	lui	a5,0x1
    800013a0:	993e                	add	s2,s2,a5
    800013a2:	fd496ee3          	bltu	s2,s4,8000137e <uvmalloc+0x32>
  return newsz;
    800013a6:	8552                	mv	a0,s4
    800013a8:	74a2                	ld	s1,40(sp)
    800013aa:	7902                	ld	s2,32(sp)
    800013ac:	6b02                	ld	s6,0(sp)
    800013ae:	a811                	j	800013c2 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800013b0:	864e                	mv	a2,s3
    800013b2:	85ca                	mv	a1,s2
    800013b4:	8556                	mv	a0,s5
    800013b6:	f53ff0ef          	jal	80001308 <uvmdealloc>
      return 0;
    800013ba:	4501                	li	a0,0
    800013bc:	74a2                	ld	s1,40(sp)
    800013be:	7902                	ld	s2,32(sp)
    800013c0:	6b02                	ld	s6,0(sp)
}
    800013c2:	70e2                	ld	ra,56(sp)
    800013c4:	7442                	ld	s0,48(sp)
    800013c6:	69e2                	ld	s3,24(sp)
    800013c8:	6a42                	ld	s4,16(sp)
    800013ca:	6aa2                	ld	s5,8(sp)
    800013cc:	6121                	addi	sp,sp,64
    800013ce:	8082                	ret
      kfree(mem);
    800013d0:	8526                	mv	a0,s1
    800013d2:	e7eff0ef          	jal	80000a50 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013d6:	864e                	mv	a2,s3
    800013d8:	85ca                	mv	a1,s2
    800013da:	8556                	mv	a0,s5
    800013dc:	f2dff0ef          	jal	80001308 <uvmdealloc>
      return 0;
    800013e0:	4501                	li	a0,0
    800013e2:	74a2                	ld	s1,40(sp)
    800013e4:	7902                	ld	s2,32(sp)
    800013e6:	6b02                	ld	s6,0(sp)
    800013e8:	bfe9                	j	800013c2 <uvmalloc+0x76>
    return oldsz;
    800013ea:	852e                	mv	a0,a1
}
    800013ec:	8082                	ret
  return newsz;
    800013ee:	8532                	mv	a0,a2
    800013f0:	bfc9                	j	800013c2 <uvmalloc+0x76>

00000000800013f2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800013f2:	7179                	addi	sp,sp,-48
    800013f4:	f406                	sd	ra,40(sp)
    800013f6:	f022                	sd	s0,32(sp)
    800013f8:	ec26                	sd	s1,24(sp)
    800013fa:	e84a                	sd	s2,16(sp)
    800013fc:	e44e                	sd	s3,8(sp)
    800013fe:	e052                	sd	s4,0(sp)
    80001400:	1800                	addi	s0,sp,48
    80001402:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001404:	84aa                	mv	s1,a0
    80001406:	6905                	lui	s2,0x1
    80001408:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000140a:	4985                	li	s3,1
    8000140c:	a819                	j	80001422 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000140e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001410:	00c79513          	slli	a0,a5,0xc
    80001414:	fdfff0ef          	jal	800013f2 <freewalk>
      pagetable[i] = 0;
    80001418:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000141c:	04a1                	addi	s1,s1,8
    8000141e:	01248f63          	beq	s1,s2,8000143c <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001422:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001424:	00f7f713          	andi	a4,a5,15
    80001428:	ff3703e3          	beq	a4,s3,8000140e <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000142c:	8b85                	andi	a5,a5,1
    8000142e:	d7fd                	beqz	a5,8000141c <freewalk+0x2a>
      panic("freewalk: leaf");
    80001430:	00006517          	auipc	a0,0x6
    80001434:	d6850513          	addi	a0,a0,-664 # 80007198 <etext+0x198>
    80001438:	b6aff0ef          	jal	800007a2 <panic>
    }
  }
  kfree((void*)pagetable);
    8000143c:	8552                	mv	a0,s4
    8000143e:	e12ff0ef          	jal	80000a50 <kfree>
}
    80001442:	70a2                	ld	ra,40(sp)
    80001444:	7402                	ld	s0,32(sp)
    80001446:	64e2                	ld	s1,24(sp)
    80001448:	6942                	ld	s2,16(sp)
    8000144a:	69a2                	ld	s3,8(sp)
    8000144c:	6a02                	ld	s4,0(sp)
    8000144e:	6145                	addi	sp,sp,48
    80001450:	8082                	ret

0000000080001452 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001452:	1101                	addi	sp,sp,-32
    80001454:	ec06                	sd	ra,24(sp)
    80001456:	e822                	sd	s0,16(sp)
    80001458:	e426                	sd	s1,8(sp)
    8000145a:	1000                	addi	s0,sp,32
    8000145c:	84aa                	mv	s1,a0
  if(sz > 0)
    8000145e:	e989                	bnez	a1,80001470 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001460:	8526                	mv	a0,s1
    80001462:	f91ff0ef          	jal	800013f2 <freewalk>
}
    80001466:	60e2                	ld	ra,24(sp)
    80001468:	6442                	ld	s0,16(sp)
    8000146a:	64a2                	ld	s1,8(sp)
    8000146c:	6105                	addi	sp,sp,32
    8000146e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001470:	6785                	lui	a5,0x1
    80001472:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001474:	95be                	add	a1,a1,a5
    80001476:	4685                	li	a3,1
    80001478:	00c5d613          	srli	a2,a1,0xc
    8000147c:	4581                	li	a1,0
    8000147e:	d4bff0ef          	jal	800011c8 <uvmunmap>
    80001482:	bff9                	j	80001460 <uvmfree+0xe>

0000000080001484 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001484:	c65d                	beqz	a2,80001532 <uvmcopy+0xae>
{
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
  for(i = 0; i < sz; i += PGSIZE){
    800014a2:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800014a4:	4601                	li	a2,0
    800014a6:	85ce                	mv	a1,s3
    800014a8:	855a                	mv	a0,s6
    800014aa:	aa1ff0ef          	jal	80000f4a <walk>
    800014ae:	c121                	beqz	a0,800014ee <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800014b0:	6118                	ld	a4,0(a0)
    800014b2:	00177793          	andi	a5,a4,1
    800014b6:	c3b1                	beqz	a5,800014fa <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800014b8:	00a75593          	srli	a1,a4,0xa
    800014bc:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014c0:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014c4:	e6eff0ef          	jal	80000b32 <kalloc>
    800014c8:	892a                	mv	s2,a0
    800014ca:	c129                	beqz	a0,8000150c <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014cc:	6605                	lui	a2,0x1
    800014ce:	85de                	mv	a1,s7
    800014d0:	863ff0ef          	jal	80000d32 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014d4:	8726                	mv	a4,s1
    800014d6:	86ca                	mv	a3,s2
    800014d8:	6605                	lui	a2,0x1
    800014da:	85ce                	mv	a1,s3
    800014dc:	8556                	mv	a0,s5
    800014de:	b45ff0ef          	jal	80001022 <mappages>
    800014e2:	e115                	bnez	a0,80001506 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    800014e4:	6785                	lui	a5,0x1
    800014e6:	99be                	add	s3,s3,a5
    800014e8:	fb49eee3          	bltu	s3,s4,800014a4 <uvmcopy+0x20>
    800014ec:	a805                	j	8000151c <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    800014ee:	00006517          	auipc	a0,0x6
    800014f2:	cba50513          	addi	a0,a0,-838 # 800071a8 <etext+0x1a8>
    800014f6:	aacff0ef          	jal	800007a2 <panic>
      panic("uvmcopy: page not present");
    800014fa:	00006517          	auipc	a0,0x6
    800014fe:	cce50513          	addi	a0,a0,-818 # 800071c8 <etext+0x1c8>
    80001502:	aa0ff0ef          	jal	800007a2 <panic>
      kfree(mem);
    80001506:	854a                	mv	a0,s2
    80001508:	d48ff0ef          	jal	80000a50 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000150c:	4685                	li	a3,1
    8000150e:	00c9d613          	srli	a2,s3,0xc
    80001512:	4581                	li	a1,0
    80001514:	8556                	mv	a0,s5
    80001516:	cb3ff0ef          	jal	800011c8 <uvmunmap>
  return -1;
    8000151a:	557d                	li	a0,-1
}
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
  return 0;
    80001532:	4501                	li	a0,0
}
    80001534:	8082                	ret

0000000080001536 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001536:	1141                	addi	sp,sp,-16
    80001538:	e406                	sd	ra,8(sp)
    8000153a:	e022                	sd	s0,0(sp)
    8000153c:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000153e:	4601                	li	a2,0
    80001540:	a0bff0ef          	jal	80000f4a <walk>
  if(pte == 0)
    80001544:	c901                	beqz	a0,80001554 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001546:	611c                	ld	a5,0(a0)
    80001548:	9bbd                	andi	a5,a5,-17
    8000154a:	e11c                	sd	a5,0(a0)
}
    8000154c:	60a2                	ld	ra,8(sp)
    8000154e:	6402                	ld	s0,0(sp)
    80001550:	0141                	addi	sp,sp,16
    80001552:	8082                	ret
    panic("uvmclear");
    80001554:	00006517          	auipc	a0,0x6
    80001558:	c9450513          	addi	a0,a0,-876 # 800071e8 <etext+0x1e8>
    8000155c:	a46ff0ef          	jal	800007a2 <panic>

0000000080001560 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001560:	cad1                	beqz	a3,800015f4 <copyout+0x94>
{
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
    va0 = PGROUNDDOWN(dstva);
    8000157c:	74fd                	lui	s1,0xfffff
    8000157e:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001580:	57fd                	li	a5,-1
    80001582:	83e9                	srli	a5,a5,0x1a
    80001584:	0697ea63          	bltu	a5,s1,800015f8 <copyout+0x98>
    80001588:	e0ca                	sd	s2,64(sp)
    8000158a:	f852                	sd	s4,48(sp)
    8000158c:	e862                	sd	s8,16(sp)
    8000158e:	e466                	sd	s9,8(sp)
    80001590:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001592:	4cd5                	li	s9,21
    80001594:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80001596:	8c3e                	mv	s8,a5
    80001598:	a025                	j	800015c0 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    8000159a:	83a9                	srli	a5,a5,0xa
    8000159c:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000159e:	409a8533          	sub	a0,s5,s1
    800015a2:	0009061b          	sext.w	a2,s2
    800015a6:	85da                	mv	a1,s6
    800015a8:	953e                	add	a0,a0,a5
    800015aa:	f88ff0ef          	jal	80000d32 <memmove>

    len -= n;
    800015ae:	412989b3          	sub	s3,s3,s2
    src += n;
    800015b2:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800015b4:	02098963          	beqz	s3,800015e6 <copyout+0x86>
    if(va0 >= MAXVA)
    800015b8:	054c6263          	bltu	s8,s4,800015fc <copyout+0x9c>
    800015bc:	84d2                	mv	s1,s4
    800015be:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    800015c0:	4601                	li	a2,0
    800015c2:	85a6                	mv	a1,s1
    800015c4:	855e                	mv	a0,s7
    800015c6:	985ff0ef          	jal	80000f4a <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015ca:	c121                	beqz	a0,8000160a <copyout+0xaa>
    800015cc:	611c                	ld	a5,0(a0)
    800015ce:	0157f713          	andi	a4,a5,21
    800015d2:	05971b63          	bne	a4,s9,80001628 <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    800015d6:	01a48a33          	add	s4,s1,s10
    800015da:	415a0933          	sub	s2,s4,s5
    if(n > len)
    800015de:	fb29fee3          	bgeu	s3,s2,8000159a <copyout+0x3a>
    800015e2:	894e                	mv	s2,s3
    800015e4:	bf5d                	j	8000159a <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    800015e6:	4501                	li	a0,0
    800015e8:	6906                	ld	s2,64(sp)
    800015ea:	7a42                	ld	s4,48(sp)
    800015ec:	6c42                	ld	s8,16(sp)
    800015ee:	6ca2                	ld	s9,8(sp)
    800015f0:	6d02                	ld	s10,0(sp)
    800015f2:	a015                	j	80001616 <copyout+0xb6>
    800015f4:	4501                	li	a0,0
}
    800015f6:	8082                	ret
      return -1;
    800015f8:	557d                	li	a0,-1
    800015fa:	a831                	j	80001616 <copyout+0xb6>
    800015fc:	557d                	li	a0,-1
    800015fe:	6906                	ld	s2,64(sp)
    80001600:	7a42                	ld	s4,48(sp)
    80001602:	6c42                	ld	s8,16(sp)
    80001604:	6ca2                	ld	s9,8(sp)
    80001606:	6d02                	ld	s10,0(sp)
    80001608:	a039                	j	80001616 <copyout+0xb6>
      return -1;
    8000160a:	557d                	li	a0,-1
    8000160c:	6906                	ld	s2,64(sp)
    8000160e:	7a42                	ld	s4,48(sp)
    80001610:	6c42                	ld	s8,16(sp)
    80001612:	6ca2                	ld	s9,8(sp)
    80001614:	6d02                	ld	s10,0(sp)
}
    80001616:	60e6                	ld	ra,88(sp)
    80001618:	6446                	ld	s0,80(sp)
    8000161a:	64a6                	ld	s1,72(sp)
    8000161c:	79e2                	ld	s3,56(sp)
    8000161e:	7aa2                	ld	s5,40(sp)
    80001620:	7b02                	ld	s6,32(sp)
    80001622:	6be2                	ld	s7,24(sp)
    80001624:	6125                	addi	sp,sp,96
    80001626:	8082                	ret
      return -1;
    80001628:	557d                	li	a0,-1
    8000162a:	6906                	ld	s2,64(sp)
    8000162c:	7a42                	ld	s4,48(sp)
    8000162e:	6c42                	ld	s8,16(sp)
    80001630:	6ca2                	ld	s9,8(sp)
    80001632:	6d02                	ld	s10,0(sp)
    80001634:	b7cd                	j	80001616 <copyout+0xb6>

0000000080001636 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001636:	c6a5                	beqz	a3,8000169e <copyin+0x68>
{
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
    va0 = PGROUNDDOWN(srcva);
    80001658:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000165a:	6a85                	lui	s5,0x1
    8000165c:	a00d                	j	8000167e <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000165e:	018505b3          	add	a1,a0,s8
    80001662:	0004861b          	sext.w	a2,s1
    80001666:	412585b3          	sub	a1,a1,s2
    8000166a:	8552                	mv	a0,s4
    8000166c:	ec6ff0ef          	jal	80000d32 <memmove>

    len -= n;
    80001670:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001674:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001676:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000167a:	02098063          	beqz	s3,8000169a <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    8000167e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001682:	85ca                	mv	a1,s2
    80001684:	855a                	mv	a0,s6
    80001686:	95fff0ef          	jal	80000fe4 <walkaddr>
    if(pa0 == 0)
    8000168a:	cd01                	beqz	a0,800016a2 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    8000168c:	418904b3          	sub	s1,s2,s8
    80001690:	94d6                	add	s1,s1,s5
    if(n > len)
    80001692:	fc99f6e3          	bgeu	s3,s1,8000165e <copyin+0x28>
    80001696:	84ce                	mv	s1,s3
    80001698:	b7d9                	j	8000165e <copyin+0x28>
  }
  return 0;
    8000169a:	4501                	li	a0,0
    8000169c:	a021                	j	800016a4 <copyin+0x6e>
    8000169e:	4501                	li	a0,0
}
    800016a0:	8082                	ret
      return -1;
    800016a2:	557d                	li	a0,-1
}
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
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800016bc:	c6dd                	beqz	a3,8000176a <copyinstr+0xae>
{
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
    va0 = PGROUNDDOWN(srcva);
    800016dc:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016de:	6985                	lui	s3,0x1
    800016e0:	a825                	j	80001718 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016e2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800016e6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016e8:	37fd                	addiw	a5,a5,-1
    800016ea:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
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
      --max;
    8000170a:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    8000170e:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001712:	04e58463          	beq	a1,a4,8000175a <copyinstr+0x9e>
{
    80001716:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80001718:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000171c:	85a6                	mv	a1,s1
    8000171e:	8552                	mv	a0,s4
    80001720:	8c5ff0ef          	jal	80000fe4 <walkaddr>
    if(pa0 == 0)
    80001724:	cd0d                	beqz	a0,8000175e <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001726:	417486b3          	sub	a3,s1,s7
    8000172a:	96ce                	add	a3,a3,s3
    if(n > max)
    8000172c:	00d97363          	bgeu	s2,a3,80001732 <copyinstr+0x76>
    80001730:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001732:	955e                	add	a0,a0,s7
    80001734:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001736:	c695                	beqz	a3,80001762 <copyinstr+0xa6>
    80001738:	87da                	mv	a5,s6
    8000173a:	885a                	mv	a6,s6
      if(*p == '\0'){
    8000173c:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001740:	96da                	add	a3,a3,s6
    80001742:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001744:	00f60733          	add	a4,a2,a5
    80001748:	00074703          	lbu	a4,0(a4)
    8000174c:	db59                	beqz	a4,800016e2 <copyinstr+0x26>
        *dst = *p;
    8000174e:	00e78023          	sb	a4,0(a5)
      dst++;
    80001752:	0785                	addi	a5,a5,1
    while(n > 0){
    80001754:	fed797e3          	bne	a5,a3,80001742 <copyinstr+0x86>
    80001758:	b775                	j	80001704 <copyinstr+0x48>
    8000175a:	4781                	li	a5,0
    8000175c:	b771                	j	800016e8 <copyinstr+0x2c>
      return -1;
    8000175e:	557d                	li	a0,-1
    80001760:	b779                	j	800016ee <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001762:	6b85                	lui	s7,0x1
    80001764:	9ba6                	add	s7,s7,s1
    80001766:	87da                	mv	a5,s6
    80001768:	b77d                	j	80001716 <copyinstr+0x5a>
  int got_null = 0;
    8000176a:	4781                	li	a5,0
  if(got_null){
    8000176c:	37fd                	addiw	a5,a5,-1
    8000176e:	0007851b          	sext.w	a0,a5
}
    80001772:	8082                	ret

0000000080001774 <proc_mapstacks>:
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
    8000178a:	00011497          	auipc	s1,0x11
    8000178e:	07648493          	addi	s1,s1,118 # 80012800 <proc>
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
    800017b6:	00017a97          	auipc	s5,0x17
    800017ba:	a4aa8a93          	addi	s5,s5,-1462 # 80018200 <tickslock>
    800017be:	b74ff0ef          	jal	80000b32 <kalloc>
    800017c2:	862a                	mv	a2,a0
    800017c4:	cd15                	beqz	a0,80001800 <proc_mapstacks+0x8c>
    800017c6:	416485b3          	sub	a1,s1,s6
    800017ca:	858d                	srai	a1,a1,0x3
    800017cc:	032585b3          	mul	a1,a1,s2
    800017d0:	2585                	addiw	a1,a1,1
    800017d2:	00d5959b          	slliw	a1,a1,0xd
    800017d6:	4719                	li	a4,6
    800017d8:	6685                	lui	a3,0x1
    800017da:	40b985b3          	sub	a1,s3,a1
    800017de:	8552                	mv	a0,s4
    800017e0:	8f3ff0ef          	jal	800010d2 <kvmmap>
    800017e4:	16848493          	addi	s1,s1,360
    800017e8:	fd549be3          	bne	s1,s5,800017be <proc_mapstacks+0x4a>
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
    80001800:	00006517          	auipc	a0,0x6
    80001804:	9f850513          	addi	a0,a0,-1544 # 800071f8 <etext+0x1f8>
    80001808:	f9bfe0ef          	jal	800007a2 <panic>

000000008000180c <procinit>:
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
    80001820:	00006597          	auipc	a1,0x6
    80001824:	9e058593          	addi	a1,a1,-1568 # 80007200 <etext+0x200>
    80001828:	00011517          	auipc	a0,0x11
    8000182c:	ba850513          	addi	a0,a0,-1112 # 800123d0 <pid_lock>
    80001830:	b52ff0ef          	jal	80000b82 <initlock>
    80001834:	00006597          	auipc	a1,0x6
    80001838:	9d458593          	addi	a1,a1,-1580 # 80007208 <etext+0x208>
    8000183c:	00011517          	auipc	a0,0x11
    80001840:	bac50513          	addi	a0,a0,-1108 # 800123e8 <wait_lock>
    80001844:	b3eff0ef          	jal	80000b82 <initlock>
    80001848:	00011497          	auipc	s1,0x11
    8000184c:	fb848493          	addi	s1,s1,-72 # 80012800 <proc>
    80001850:	00006b17          	auipc	s6,0x6
    80001854:	9c8b0b13          	addi	s6,s6,-1592 # 80007218 <etext+0x218>
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
    8000187c:	00017a17          	auipc	s4,0x17
    80001880:	984a0a13          	addi	s4,s4,-1660 # 80018200 <tickslock>
    80001884:	85da                	mv	a1,s6
    80001886:	8526                	mv	a0,s1
    80001888:	afaff0ef          	jal	80000b82 <initlock>
    8000188c:	0004ac23          	sw	zero,24(s1)
    80001890:	415487b3          	sub	a5,s1,s5
    80001894:	878d                	srai	a5,a5,0x3
    80001896:	032787b3          	mul	a5,a5,s2
    8000189a:	2785                	addiw	a5,a5,1
    8000189c:	00d7979b          	slliw	a5,a5,0xd
    800018a0:	40f987b3          	sub	a5,s3,a5
    800018a4:	e0bc                	sd	a5,64(s1)
    800018a6:	16848493          	addi	s1,s1,360
    800018aa:	fd449de3          	bne	s1,s4,80001884 <procinit+0x78>
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
    800018c2:	1141                	addi	sp,sp,-16
    800018c4:	e422                	sd	s0,8(sp)
    800018c6:	0800                	addi	s0,sp,16
    800018c8:	8512                	mv	a0,tp
    800018ca:	2501                	sext.w	a0,a0
    800018cc:	6422                	ld	s0,8(sp)
    800018ce:	0141                	addi	sp,sp,16
    800018d0:	8082                	ret

00000000800018d2 <mycpu>:
    800018d2:	1141                	addi	sp,sp,-16
    800018d4:	e422                	sd	s0,8(sp)
    800018d6:	0800                	addi	s0,sp,16
    800018d8:	8792                	mv	a5,tp
    800018da:	2781                	sext.w	a5,a5
    800018dc:	079e                	slli	a5,a5,0x7
    800018de:	00011517          	auipc	a0,0x11
    800018e2:	b2250513          	addi	a0,a0,-1246 # 80012400 <cpus>
    800018e6:	953e                	add	a0,a0,a5
    800018e8:	6422                	ld	s0,8(sp)
    800018ea:	0141                	addi	sp,sp,16
    800018ec:	8082                	ret

00000000800018ee <myproc>:
    800018ee:	1101                	addi	sp,sp,-32
    800018f0:	ec06                	sd	ra,24(sp)
    800018f2:	e822                	sd	s0,16(sp)
    800018f4:	e426                	sd	s1,8(sp)
    800018f6:	1000                	addi	s0,sp,32
    800018f8:	acaff0ef          	jal	80000bc2 <push_off>
    800018fc:	8792                	mv	a5,tp
    800018fe:	2781                	sext.w	a5,a5
    80001900:	079e                	slli	a5,a5,0x7
    80001902:	00011717          	auipc	a4,0x11
    80001906:	ace70713          	addi	a4,a4,-1330 # 800123d0 <pid_lock>
    8000190a:	97ba                	add	a5,a5,a4
    8000190c:	7b84                	ld	s1,48(a5)
    8000190e:	b38ff0ef          	jal	80000c46 <pop_off>
    80001912:	8526                	mv	a0,s1
    80001914:	60e2                	ld	ra,24(sp)
    80001916:	6442                	ld	s0,16(sp)
    80001918:	64a2                	ld	s1,8(sp)
    8000191a:	6105                	addi	sp,sp,32
    8000191c:	8082                	ret

000000008000191e <forkret>:
    8000191e:	1141                	addi	sp,sp,-16
    80001920:	e406                	sd	ra,8(sp)
    80001922:	e022                	sd	s0,0(sp)
    80001924:	0800                	addi	s0,sp,16
    80001926:	fc9ff0ef          	jal	800018ee <myproc>
    8000192a:	b70ff0ef          	jal	80000c9a <release>
    8000192e:	00009797          	auipc	a5,0x9
    80001932:	8d27a783          	lw	a5,-1838(a5) # 8000a200 <first.1>
    80001936:	e799                	bnez	a5,80001944 <forkret+0x26>
    80001938:	2bf000ef          	jal	800023f6 <usertrapret>
    8000193c:	60a2                	ld	ra,8(sp)
    8000193e:	6402                	ld	s0,0(sp)
    80001940:	0141                	addi	sp,sp,16
    80001942:	8082                	ret
    80001944:	4505                	li	a0,1
    80001946:	68e010ef          	jal	80002fd4 <fsinit>
    8000194a:	00009797          	auipc	a5,0x9
    8000194e:	8a07ab23          	sw	zero,-1866(a5) # 8000a200 <first.1>
    80001952:	0330000f          	fence	rw,rw
    80001956:	b7cd                	j	80001938 <forkret+0x1a>

0000000080001958 <allocpid>:
    80001958:	1101                	addi	sp,sp,-32
    8000195a:	ec06                	sd	ra,24(sp)
    8000195c:	e822                	sd	s0,16(sp)
    8000195e:	e426                	sd	s1,8(sp)
    80001960:	e04a                	sd	s2,0(sp)
    80001962:	1000                	addi	s0,sp,32
    80001964:	00011917          	auipc	s2,0x11
    80001968:	a6c90913          	addi	s2,s2,-1428 # 800123d0 <pid_lock>
    8000196c:	854a                	mv	a0,s2
    8000196e:	a94ff0ef          	jal	80000c02 <acquire>
    80001972:	00009797          	auipc	a5,0x9
    80001976:	89278793          	addi	a5,a5,-1902 # 8000a204 <nextpid>
    8000197a:	4384                	lw	s1,0(a5)
    8000197c:	0014871b          	addiw	a4,s1,1
    80001980:	c398                	sw	a4,0(a5)
    80001982:	854a                	mv	a0,s2
    80001984:	b16ff0ef          	jal	80000c9a <release>
    80001988:	8526                	mv	a0,s1
    8000198a:	60e2                	ld	ra,24(sp)
    8000198c:	6442                	ld	s0,16(sp)
    8000198e:	64a2                	ld	s1,8(sp)
    80001990:	6902                	ld	s2,0(sp)
    80001992:	6105                	addi	sp,sp,32
    80001994:	8082                	ret

0000000080001996 <proc_pagetable>:
    80001996:	1101                	addi	sp,sp,-32
    80001998:	ec06                	sd	ra,24(sp)
    8000199a:	e822                	sd	s0,16(sp)
    8000199c:	e426                	sd	s1,8(sp)
    8000199e:	e04a                	sd	s2,0(sp)
    800019a0:	1000                	addi	s0,sp,32
    800019a2:	892a                	mv	s2,a0
    800019a4:	8e1ff0ef          	jal	80001284 <uvmcreate>
    800019a8:	84aa                	mv	s1,a0
    800019aa:	cd05                	beqz	a0,800019e2 <proc_pagetable+0x4c>
    800019ac:	4729                	li	a4,10
    800019ae:	00004697          	auipc	a3,0x4
    800019b2:	65268693          	addi	a3,a3,1618 # 80006000 <_trampoline>
    800019b6:	6605                	lui	a2,0x1
    800019b8:	040005b7          	lui	a1,0x4000
    800019bc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019be:	05b2                	slli	a1,a1,0xc
    800019c0:	e62ff0ef          	jal	80001022 <mappages>
    800019c4:	02054663          	bltz	a0,800019f0 <proc_pagetable+0x5a>
    800019c8:	4719                	li	a4,6
    800019ca:	05893683          	ld	a3,88(s2)
    800019ce:	6605                	lui	a2,0x1
    800019d0:	020005b7          	lui	a1,0x2000
    800019d4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800019d6:	05b6                	slli	a1,a1,0xd
    800019d8:	8526                	mv	a0,s1
    800019da:	e48ff0ef          	jal	80001022 <mappages>
    800019de:	00054f63          	bltz	a0,800019fc <proc_pagetable+0x66>
    800019e2:	8526                	mv	a0,s1
    800019e4:	60e2                	ld	ra,24(sp)
    800019e6:	6442                	ld	s0,16(sp)
    800019e8:	64a2                	ld	s1,8(sp)
    800019ea:	6902                	ld	s2,0(sp)
    800019ec:	6105                	addi	sp,sp,32
    800019ee:	8082                	ret
    800019f0:	4581                	li	a1,0
    800019f2:	8526                	mv	a0,s1
    800019f4:	a5fff0ef          	jal	80001452 <uvmfree>
    800019f8:	4481                	li	s1,0
    800019fa:	b7e5                	j	800019e2 <proc_pagetable+0x4c>
    800019fc:	4681                	li	a3,0
    800019fe:	4605                	li	a2,1
    80001a00:	040005b7          	lui	a1,0x4000
    80001a04:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a06:	05b2                	slli	a1,a1,0xc
    80001a08:	8526                	mv	a0,s1
    80001a0a:	fbeff0ef          	jal	800011c8 <uvmunmap>
    80001a0e:	4581                	li	a1,0
    80001a10:	8526                	mv	a0,s1
    80001a12:	a41ff0ef          	jal	80001452 <uvmfree>
    80001a16:	4481                	li	s1,0
    80001a18:	b7e9                	j	800019e2 <proc_pagetable+0x4c>

0000000080001a1a <proc_freepagetable>:
    80001a1a:	1101                	addi	sp,sp,-32
    80001a1c:	ec06                	sd	ra,24(sp)
    80001a1e:	e822                	sd	s0,16(sp)
    80001a20:	e426                	sd	s1,8(sp)
    80001a22:	e04a                	sd	s2,0(sp)
    80001a24:	1000                	addi	s0,sp,32
    80001a26:	84aa                	mv	s1,a0
    80001a28:	892e                	mv	s2,a1
    80001a2a:	4681                	li	a3,0
    80001a2c:	4605                	li	a2,1
    80001a2e:	040005b7          	lui	a1,0x4000
    80001a32:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a34:	05b2                	slli	a1,a1,0xc
    80001a36:	f92ff0ef          	jal	800011c8 <uvmunmap>
    80001a3a:	4681                	li	a3,0
    80001a3c:	4605                	li	a2,1
    80001a3e:	020005b7          	lui	a1,0x2000
    80001a42:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a44:	05b6                	slli	a1,a1,0xd
    80001a46:	8526                	mv	a0,s1
    80001a48:	f80ff0ef          	jal	800011c8 <uvmunmap>
    80001a4c:	85ca                	mv	a1,s2
    80001a4e:	8526                	mv	a0,s1
    80001a50:	a03ff0ef          	jal	80001452 <uvmfree>
    80001a54:	60e2                	ld	ra,24(sp)
    80001a56:	6442                	ld	s0,16(sp)
    80001a58:	64a2                	ld	s1,8(sp)
    80001a5a:	6902                	ld	s2,0(sp)
    80001a5c:	6105                	addi	sp,sp,32
    80001a5e:	8082                	ret

0000000080001a60 <freeproc>:
    80001a60:	1101                	addi	sp,sp,-32
    80001a62:	ec06                	sd	ra,24(sp)
    80001a64:	e822                	sd	s0,16(sp)
    80001a66:	e426                	sd	s1,8(sp)
    80001a68:	1000                	addi	s0,sp,32
    80001a6a:	84aa                	mv	s1,a0
    80001a6c:	6d28                	ld	a0,88(a0)
    80001a6e:	c119                	beqz	a0,80001a74 <freeproc+0x14>
    80001a70:	fe1fe0ef          	jal	80000a50 <kfree>
    80001a74:	0404bc23          	sd	zero,88(s1)
    80001a78:	68a8                	ld	a0,80(s1)
    80001a7a:	c501                	beqz	a0,80001a82 <freeproc+0x22>
    80001a7c:	64ac                	ld	a1,72(s1)
    80001a7e:	f9dff0ef          	jal	80001a1a <proc_freepagetable>
    80001a82:	0404b823          	sd	zero,80(s1)
    80001a86:	0404b423          	sd	zero,72(s1)
    80001a8a:	0204a823          	sw	zero,48(s1)
    80001a8e:	0204bc23          	sd	zero,56(s1)
    80001a92:	14048c23          	sb	zero,344(s1)
    80001a96:	0204b023          	sd	zero,32(s1)
    80001a9a:	0204a423          	sw	zero,40(s1)
    80001a9e:	0204a623          	sw	zero,44(s1)
    80001aa2:	0004ac23          	sw	zero,24(s1)
    80001aa6:	60e2                	ld	ra,24(sp)
    80001aa8:	6442                	ld	s0,16(sp)
    80001aaa:	64a2                	ld	s1,8(sp)
    80001aac:	6105                	addi	sp,sp,32
    80001aae:	8082                	ret

0000000080001ab0 <allocproc>:
    80001ab0:	1101                	addi	sp,sp,-32
    80001ab2:	ec06                	sd	ra,24(sp)
    80001ab4:	e822                	sd	s0,16(sp)
    80001ab6:	e426                	sd	s1,8(sp)
    80001ab8:	e04a                	sd	s2,0(sp)
    80001aba:	1000                	addi	s0,sp,32
    80001abc:	00011497          	auipc	s1,0x11
    80001ac0:	d4448493          	addi	s1,s1,-700 # 80012800 <proc>
    80001ac4:	00016917          	auipc	s2,0x16
    80001ac8:	73c90913          	addi	s2,s2,1852 # 80018200 <tickslock>
    80001acc:	8526                	mv	a0,s1
    80001ace:	934ff0ef          	jal	80000c02 <acquire>
    80001ad2:	4c9c                	lw	a5,24(s1)
    80001ad4:	cb91                	beqz	a5,80001ae8 <allocproc+0x38>
    80001ad6:	8526                	mv	a0,s1
    80001ad8:	9c2ff0ef          	jal	80000c9a <release>
    80001adc:	16848493          	addi	s1,s1,360
    80001ae0:	ff2496e3          	bne	s1,s2,80001acc <allocproc+0x1c>
    80001ae4:	4481                	li	s1,0
    80001ae6:	a089                	j	80001b28 <allocproc+0x78>
    80001ae8:	e71ff0ef          	jal	80001958 <allocpid>
    80001aec:	d888                	sw	a0,48(s1)
    80001aee:	4785                	li	a5,1
    80001af0:	cc9c                	sw	a5,24(s1)
    80001af2:	840ff0ef          	jal	80000b32 <kalloc>
    80001af6:	892a                	mv	s2,a0
    80001af8:	eca8                	sd	a0,88(s1)
    80001afa:	cd15                	beqz	a0,80001b36 <allocproc+0x86>
    80001afc:	8526                	mv	a0,s1
    80001afe:	e99ff0ef          	jal	80001996 <proc_pagetable>
    80001b02:	892a                	mv	s2,a0
    80001b04:	e8a8                	sd	a0,80(s1)
    80001b06:	c121                	beqz	a0,80001b46 <allocproc+0x96>
    80001b08:	07000613          	li	a2,112
    80001b0c:	4581                	li	a1,0
    80001b0e:	06048513          	addi	a0,s1,96
    80001b12:	9c4ff0ef          	jal	80000cd6 <memset>
    80001b16:	00000797          	auipc	a5,0x0
    80001b1a:	e0878793          	addi	a5,a5,-504 # 8000191e <forkret>
    80001b1e:	f0bc                	sd	a5,96(s1)
    80001b20:	60bc                	ld	a5,64(s1)
    80001b22:	6705                	lui	a4,0x1
    80001b24:	97ba                	add	a5,a5,a4
    80001b26:	f4bc                	sd	a5,104(s1)
    80001b28:	8526                	mv	a0,s1
    80001b2a:	60e2                	ld	ra,24(sp)
    80001b2c:	6442                	ld	s0,16(sp)
    80001b2e:	64a2                	ld	s1,8(sp)
    80001b30:	6902                	ld	s2,0(sp)
    80001b32:	6105                	addi	sp,sp,32
    80001b34:	8082                	ret
    80001b36:	8526                	mv	a0,s1
    80001b38:	f29ff0ef          	jal	80001a60 <freeproc>
    80001b3c:	8526                	mv	a0,s1
    80001b3e:	95cff0ef          	jal	80000c9a <release>
    80001b42:	84ca                	mv	s1,s2
    80001b44:	b7d5                	j	80001b28 <allocproc+0x78>
    80001b46:	8526                	mv	a0,s1
    80001b48:	f19ff0ef          	jal	80001a60 <freeproc>
    80001b4c:	8526                	mv	a0,s1
    80001b4e:	94cff0ef          	jal	80000c9a <release>
    80001b52:	84ca                	mv	s1,s2
    80001b54:	bfd1                	j	80001b28 <allocproc+0x78>

0000000080001b56 <userinit>:
    80001b56:	1101                	addi	sp,sp,-32
    80001b58:	ec06                	sd	ra,24(sp)
    80001b5a:	e822                	sd	s0,16(sp)
    80001b5c:	e426                	sd	s1,8(sp)
    80001b5e:	1000                	addi	s0,sp,32
    80001b60:	f51ff0ef          	jal	80001ab0 <allocproc>
    80001b64:	84aa                	mv	s1,a0
    80001b66:	00008797          	auipc	a5,0x8
    80001b6a:	72a7b923          	sd	a0,1842(a5) # 8000a298 <initproc>
    80001b6e:	03400613          	li	a2,52
    80001b72:	00008597          	auipc	a1,0x8
    80001b76:	69e58593          	addi	a1,a1,1694 # 8000a210 <initcode>
    80001b7a:	6928                	ld	a0,80(a0)
    80001b7c:	f2eff0ef          	jal	800012aa <uvmfirst>
    80001b80:	6785                	lui	a5,0x1
    80001b82:	e4bc                	sd	a5,72(s1)
    80001b84:	6cb8                	ld	a4,88(s1)
    80001b86:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    80001b8a:	6cb8                	ld	a4,88(s1)
    80001b8c:	fb1c                	sd	a5,48(a4)
    80001b8e:	4641                	li	a2,16
    80001b90:	00005597          	auipc	a1,0x5
    80001b94:	69058593          	addi	a1,a1,1680 # 80007220 <etext+0x220>
    80001b98:	15848513          	addi	a0,s1,344
    80001b9c:	a78ff0ef          	jal	80000e14 <safestrcpy>
    80001ba0:	00005517          	auipc	a0,0x5
    80001ba4:	69050513          	addi	a0,a0,1680 # 80007230 <etext+0x230>
    80001ba8:	53b010ef          	jal	800038e2 <namei>
    80001bac:	14a4b823          	sd	a0,336(s1)
    80001bb0:	478d                	li	a5,3
    80001bb2:	cc9c                	sw	a5,24(s1)
    80001bb4:	8526                	mv	a0,s1
    80001bb6:	8e4ff0ef          	jal	80000c9a <release>
    80001bba:	60e2                	ld	ra,24(sp)
    80001bbc:	6442                	ld	s0,16(sp)
    80001bbe:	64a2                	ld	s1,8(sp)
    80001bc0:	6105                	addi	sp,sp,32
    80001bc2:	8082                	ret

0000000080001bc4 <growproc>:
    80001bc4:	1101                	addi	sp,sp,-32
    80001bc6:	ec06                	sd	ra,24(sp)
    80001bc8:	e822                	sd	s0,16(sp)
    80001bca:	e426                	sd	s1,8(sp)
    80001bcc:	e04a                	sd	s2,0(sp)
    80001bce:	1000                	addi	s0,sp,32
    80001bd0:	892a                	mv	s2,a0
    80001bd2:	d1dff0ef          	jal	800018ee <myproc>
    80001bd6:	84aa                	mv	s1,a0
    80001bd8:	652c                	ld	a1,72(a0)
    80001bda:	01204c63          	bgtz	s2,80001bf2 <growproc+0x2e>
    80001bde:	02094463          	bltz	s2,80001c06 <growproc+0x42>
    80001be2:	e4ac                	sd	a1,72(s1)
    80001be4:	4501                	li	a0,0
    80001be6:	60e2                	ld	ra,24(sp)
    80001be8:	6442                	ld	s0,16(sp)
    80001bea:	64a2                	ld	s1,8(sp)
    80001bec:	6902                	ld	s2,0(sp)
    80001bee:	6105                	addi	sp,sp,32
    80001bf0:	8082                	ret
    80001bf2:	4691                	li	a3,4
    80001bf4:	00b90633          	add	a2,s2,a1
    80001bf8:	6928                	ld	a0,80(a0)
    80001bfa:	f52ff0ef          	jal	8000134c <uvmalloc>
    80001bfe:	85aa                	mv	a1,a0
    80001c00:	f16d                	bnez	a0,80001be2 <growproc+0x1e>
    80001c02:	557d                	li	a0,-1
    80001c04:	b7cd                	j	80001be6 <growproc+0x22>
    80001c06:	00b90633          	add	a2,s2,a1
    80001c0a:	6928                	ld	a0,80(a0)
    80001c0c:	efcff0ef          	jal	80001308 <uvmdealloc>
    80001c10:	85aa                	mv	a1,a0
    80001c12:	bfc1                	j	80001be2 <growproc+0x1e>

0000000080001c14 <fork>:
    80001c14:	7139                	addi	sp,sp,-64
    80001c16:	fc06                	sd	ra,56(sp)
    80001c18:	f822                	sd	s0,48(sp)
    80001c1a:	f04a                	sd	s2,32(sp)
    80001c1c:	e456                	sd	s5,8(sp)
    80001c1e:	0080                	addi	s0,sp,64
    80001c20:	ccfff0ef          	jal	800018ee <myproc>
    80001c24:	8aaa                	mv	s5,a0
    80001c26:	e8bff0ef          	jal	80001ab0 <allocproc>
    80001c2a:	0e050a63          	beqz	a0,80001d1e <fork+0x10a>
    80001c2e:	e852                	sd	s4,16(sp)
    80001c30:	8a2a                	mv	s4,a0
    80001c32:	048ab603          	ld	a2,72(s5)
    80001c36:	692c                	ld	a1,80(a0)
    80001c38:	050ab503          	ld	a0,80(s5)
    80001c3c:	849ff0ef          	jal	80001484 <uvmcopy>
    80001c40:	04054a63          	bltz	a0,80001c94 <fork+0x80>
    80001c44:	f426                	sd	s1,40(sp)
    80001c46:	ec4e                	sd	s3,24(sp)
    80001c48:	048ab783          	ld	a5,72(s5)
    80001c4c:	04fa3423          	sd	a5,72(s4)
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
    80001c7e:	058a3783          	ld	a5,88(s4)
    80001c82:	0607b823          	sd	zero,112(a5)
    80001c86:	0d0a8493          	addi	s1,s5,208
    80001c8a:	0d0a0913          	addi	s2,s4,208
    80001c8e:	150a8993          	addi	s3,s5,336
    80001c92:	a831                	j	80001cae <fork+0x9a>
    80001c94:	8552                	mv	a0,s4
    80001c96:	dcbff0ef          	jal	80001a60 <freeproc>
    80001c9a:	8552                	mv	a0,s4
    80001c9c:	ffffe0ef          	jal	80000c9a <release>
    80001ca0:	597d                	li	s2,-1
    80001ca2:	6a42                	ld	s4,16(sp)
    80001ca4:	a0b5                	j	80001d10 <fork+0xfc>
    80001ca6:	04a1                	addi	s1,s1,8
    80001ca8:	0921                	addi	s2,s2,8
    80001caa:	01348963          	beq	s1,s3,80001cbc <fork+0xa8>
    80001cae:	6088                	ld	a0,0(s1)
    80001cb0:	d97d                	beqz	a0,80001ca6 <fork+0x92>
    80001cb2:	1c0020ef          	jal	80003e72 <filedup>
    80001cb6:	00a93023          	sd	a0,0(s2)
    80001cba:	b7f5                	j	80001ca6 <fork+0x92>
    80001cbc:	150ab503          	ld	a0,336(s5)
    80001cc0:	512010ef          	jal	800031d2 <idup>
    80001cc4:	14aa3823          	sd	a0,336(s4)
    80001cc8:	4641                	li	a2,16
    80001cca:	158a8593          	addi	a1,s5,344
    80001cce:	158a0513          	addi	a0,s4,344
    80001cd2:	942ff0ef          	jal	80000e14 <safestrcpy>
    80001cd6:	030a2903          	lw	s2,48(s4)
    80001cda:	8552                	mv	a0,s4
    80001cdc:	fbffe0ef          	jal	80000c9a <release>
    80001ce0:	00010497          	auipc	s1,0x10
    80001ce4:	70848493          	addi	s1,s1,1800 # 800123e8 <wait_lock>
    80001ce8:	8526                	mv	a0,s1
    80001cea:	f19fe0ef          	jal	80000c02 <acquire>
    80001cee:	035a3c23          	sd	s5,56(s4)
    80001cf2:	8526                	mv	a0,s1
    80001cf4:	fa7fe0ef          	jal	80000c9a <release>
    80001cf8:	8552                	mv	a0,s4
    80001cfa:	f09fe0ef          	jal	80000c02 <acquire>
    80001cfe:	478d                	li	a5,3
    80001d00:	00fa2c23          	sw	a5,24(s4)
    80001d04:	8552                	mv	a0,s4
    80001d06:	f95fe0ef          	jal	80000c9a <release>
    80001d0a:	74a2                	ld	s1,40(sp)
    80001d0c:	69e2                	ld	s3,24(sp)
    80001d0e:	6a42                	ld	s4,16(sp)
    80001d10:	854a                	mv	a0,s2
    80001d12:	70e2                	ld	ra,56(sp)
    80001d14:	7442                	ld	s0,48(sp)
    80001d16:	7902                	ld	s2,32(sp)
    80001d18:	6aa2                	ld	s5,8(sp)
    80001d1a:	6121                	addi	sp,sp,64
    80001d1c:	8082                	ret
    80001d1e:	597d                	li	s2,-1
    80001d20:	bfc5                	j	80001d10 <fork+0xfc>

0000000080001d22 <scheduler>:
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
    80001d3c:	2781                	sext.w	a5,a5
    80001d3e:	00779b13          	slli	s6,a5,0x7
    80001d42:	00010717          	auipc	a4,0x10
    80001d46:	68e70713          	addi	a4,a4,1678 # 800123d0 <pid_lock>
    80001d4a:	975a                	add	a4,a4,s6
    80001d4c:	02073823          	sd	zero,48(a4)
    80001d50:	00010717          	auipc	a4,0x10
    80001d54:	6b870713          	addi	a4,a4,1720 # 80012408 <cpus+0x8>
    80001d58:	9b3a                	add	s6,s6,a4
    80001d5a:	4c11                	li	s8,4
    80001d5c:	079e                	slli	a5,a5,0x7
    80001d5e:	00010a17          	auipc	s4,0x10
    80001d62:	672a0a13          	addi	s4,s4,1650 # 800123d0 <pid_lock>
    80001d66:	9a3e                	add	s4,s4,a5
    80001d68:	4b85                	li	s7,1
    80001d6a:	00016997          	auipc	s3,0x16
    80001d6e:	49698993          	addi	s3,s3,1174 # 80018200 <tickslock>
    80001d72:	a0a9                	j	80001dbc <scheduler+0x9a>
    80001d74:	8526                	mv	a0,s1
    80001d76:	f25fe0ef          	jal	80000c9a <release>
    80001d7a:	16848493          	addi	s1,s1,360
    80001d7e:	03348563          	beq	s1,s3,80001da8 <scheduler+0x86>
    80001d82:	8526                	mv	a0,s1
    80001d84:	e7ffe0ef          	jal	80000c02 <acquire>
    80001d88:	4c9c                	lw	a5,24(s1)
    80001d8a:	ff2795e3          	bne	a5,s2,80001d74 <scheduler+0x52>
    80001d8e:	0184ac23          	sw	s8,24(s1)
    80001d92:	029a3823          	sd	s1,48(s4)
    80001d96:	06048593          	addi	a1,s1,96
    80001d9a:	855a                	mv	a0,s6
    80001d9c:	5b4000ef          	jal	80002350 <swtch>
    80001da0:	020a3823          	sd	zero,48(s4)
    80001da4:	8ade                	mv	s5,s7
    80001da6:	b7f9                	j	80001d74 <scheduler+0x52>
    80001da8:	000a9a63          	bnez	s5,80001dbc <scheduler+0x9a>
    80001dac:	100027f3          	csrr	a5,sstatus
    80001db0:	0027e793          	ori	a5,a5,2
    80001db4:	10079073          	csrw	sstatus,a5
    80001db8:	10500073          	wfi
    80001dbc:	100027f3          	csrr	a5,sstatus
    80001dc0:	0027e793          	ori	a5,a5,2
    80001dc4:	10079073          	csrw	sstatus,a5
    80001dc8:	4a81                	li	s5,0
    80001dca:	00011497          	auipc	s1,0x11
    80001dce:	a3648493          	addi	s1,s1,-1482 # 80012800 <proc>
    80001dd2:	490d                	li	s2,3
    80001dd4:	b77d                	j	80001d82 <scheduler+0x60>

0000000080001dd6 <sched>:
    80001dd6:	7179                	addi	sp,sp,-48
    80001dd8:	f406                	sd	ra,40(sp)
    80001dda:	f022                	sd	s0,32(sp)
    80001ddc:	ec26                	sd	s1,24(sp)
    80001dde:	e84a                	sd	s2,16(sp)
    80001de0:	e44e                	sd	s3,8(sp)
    80001de2:	1800                	addi	s0,sp,48
    80001de4:	b0bff0ef          	jal	800018ee <myproc>
    80001de8:	84aa                	mv	s1,a0
    80001dea:	daffe0ef          	jal	80000b98 <holding>
    80001dee:	c92d                	beqz	a0,80001e60 <sched+0x8a>
    80001df0:	8792                	mv	a5,tp
    80001df2:	2781                	sext.w	a5,a5
    80001df4:	079e                	slli	a5,a5,0x7
    80001df6:	00010717          	auipc	a4,0x10
    80001dfa:	5da70713          	addi	a4,a4,1498 # 800123d0 <pid_lock>
    80001dfe:	97ba                	add	a5,a5,a4
    80001e00:	0a87a703          	lw	a4,168(a5)
    80001e04:	4785                	li	a5,1
    80001e06:	06f71363          	bne	a4,a5,80001e6c <sched+0x96>
    80001e0a:	4c98                	lw	a4,24(s1)
    80001e0c:	4791                	li	a5,4
    80001e0e:	06f70563          	beq	a4,a5,80001e78 <sched+0xa2>
    80001e12:	100027f3          	csrr	a5,sstatus
    80001e16:	8b89                	andi	a5,a5,2
    80001e18:	e7b5                	bnez	a5,80001e84 <sched+0xae>
    80001e1a:	8792                	mv	a5,tp
    80001e1c:	00010917          	auipc	s2,0x10
    80001e20:	5b490913          	addi	s2,s2,1460 # 800123d0 <pid_lock>
    80001e24:	2781                	sext.w	a5,a5
    80001e26:	079e                	slli	a5,a5,0x7
    80001e28:	97ca                	add	a5,a5,s2
    80001e2a:	0ac7a983          	lw	s3,172(a5)
    80001e2e:	8792                	mv	a5,tp
    80001e30:	2781                	sext.w	a5,a5
    80001e32:	079e                	slli	a5,a5,0x7
    80001e34:	00010597          	auipc	a1,0x10
    80001e38:	5d458593          	addi	a1,a1,1492 # 80012408 <cpus+0x8>
    80001e3c:	95be                	add	a1,a1,a5
    80001e3e:	06048513          	addi	a0,s1,96
    80001e42:	50e000ef          	jal	80002350 <swtch>
    80001e46:	8792                	mv	a5,tp
    80001e48:	2781                	sext.w	a5,a5
    80001e4a:	079e                	slli	a5,a5,0x7
    80001e4c:	993e                	add	s2,s2,a5
    80001e4e:	0b392623          	sw	s3,172(s2)
    80001e52:	70a2                	ld	ra,40(sp)
    80001e54:	7402                	ld	s0,32(sp)
    80001e56:	64e2                	ld	s1,24(sp)
    80001e58:	6942                	ld	s2,16(sp)
    80001e5a:	69a2                	ld	s3,8(sp)
    80001e5c:	6145                	addi	sp,sp,48
    80001e5e:	8082                	ret
    80001e60:	00005517          	auipc	a0,0x5
    80001e64:	3d850513          	addi	a0,a0,984 # 80007238 <etext+0x238>
    80001e68:	93bfe0ef          	jal	800007a2 <panic>
    80001e6c:	00005517          	auipc	a0,0x5
    80001e70:	3dc50513          	addi	a0,a0,988 # 80007248 <etext+0x248>
    80001e74:	92ffe0ef          	jal	800007a2 <panic>
    80001e78:	00005517          	auipc	a0,0x5
    80001e7c:	3e050513          	addi	a0,a0,992 # 80007258 <etext+0x258>
    80001e80:	923fe0ef          	jal	800007a2 <panic>
    80001e84:	00005517          	auipc	a0,0x5
    80001e88:	3e450513          	addi	a0,a0,996 # 80007268 <etext+0x268>
    80001e8c:	917fe0ef          	jal	800007a2 <panic>

0000000080001e90 <yield>:
    80001e90:	1101                	addi	sp,sp,-32
    80001e92:	ec06                	sd	ra,24(sp)
    80001e94:	e822                	sd	s0,16(sp)
    80001e96:	e426                	sd	s1,8(sp)
    80001e98:	1000                	addi	s0,sp,32
    80001e9a:	a55ff0ef          	jal	800018ee <myproc>
    80001e9e:	84aa                	mv	s1,a0
    80001ea0:	d63fe0ef          	jal	80000c02 <acquire>
    80001ea4:	478d                	li	a5,3
    80001ea6:	cc9c                	sw	a5,24(s1)
    80001ea8:	f2fff0ef          	jal	80001dd6 <sched>
    80001eac:	8526                	mv	a0,s1
    80001eae:	dedfe0ef          	jal	80000c9a <release>
    80001eb2:	60e2                	ld	ra,24(sp)
    80001eb4:	6442                	ld	s0,16(sp)
    80001eb6:	64a2                	ld	s1,8(sp)
    80001eb8:	6105                	addi	sp,sp,32
    80001eba:	8082                	ret

0000000080001ebc <sleep>:
    80001ebc:	7179                	addi	sp,sp,-48
    80001ebe:	f406                	sd	ra,40(sp)
    80001ec0:	f022                	sd	s0,32(sp)
    80001ec2:	ec26                	sd	s1,24(sp)
    80001ec4:	e84a                	sd	s2,16(sp)
    80001ec6:	e44e                	sd	s3,8(sp)
    80001ec8:	1800                	addi	s0,sp,48
    80001eca:	89aa                	mv	s3,a0
    80001ecc:	892e                	mv	s2,a1
    80001ece:	a21ff0ef          	jal	800018ee <myproc>
    80001ed2:	84aa                	mv	s1,a0
    80001ed4:	d2ffe0ef          	jal	80000c02 <acquire>
    80001ed8:	854a                	mv	a0,s2
    80001eda:	dc1fe0ef          	jal	80000c9a <release>
    80001ede:	0334b023          	sd	s3,32(s1)
    80001ee2:	4789                	li	a5,2
    80001ee4:	cc9c                	sw	a5,24(s1)
    80001ee6:	ef1ff0ef          	jal	80001dd6 <sched>
    80001eea:	0204b023          	sd	zero,32(s1)
    80001eee:	8526                	mv	a0,s1
    80001ef0:	dabfe0ef          	jal	80000c9a <release>
    80001ef4:	854a                	mv	a0,s2
    80001ef6:	d0dfe0ef          	jal	80000c02 <acquire>
    80001efa:	70a2                	ld	ra,40(sp)
    80001efc:	7402                	ld	s0,32(sp)
    80001efe:	64e2                	ld	s1,24(sp)
    80001f00:	6942                	ld	s2,16(sp)
    80001f02:	69a2                	ld	s3,8(sp)
    80001f04:	6145                	addi	sp,sp,48
    80001f06:	8082                	ret

0000000080001f08 <wakeup>:
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
    80001f1c:	00011497          	auipc	s1,0x11
    80001f20:	8e448493          	addi	s1,s1,-1820 # 80012800 <proc>
    80001f24:	4989                	li	s3,2
    80001f26:	4a8d                	li	s5,3
    80001f28:	00016917          	auipc	s2,0x16
    80001f2c:	2d890913          	addi	s2,s2,728 # 80018200 <tickslock>
    80001f30:	a801                	j	80001f40 <wakeup+0x38>
    80001f32:	8526                	mv	a0,s1
    80001f34:	d67fe0ef          	jal	80000c9a <release>
    80001f38:	16848493          	addi	s1,s1,360
    80001f3c:	03248263          	beq	s1,s2,80001f60 <wakeup+0x58>
    80001f40:	9afff0ef          	jal	800018ee <myproc>
    80001f44:	fea48ae3          	beq	s1,a0,80001f38 <wakeup+0x30>
    80001f48:	8526                	mv	a0,s1
    80001f4a:	cb9fe0ef          	jal	80000c02 <acquire>
    80001f4e:	4c9c                	lw	a5,24(s1)
    80001f50:	ff3791e3          	bne	a5,s3,80001f32 <wakeup+0x2a>
    80001f54:	709c                	ld	a5,32(s1)
    80001f56:	fd479ee3          	bne	a5,s4,80001f32 <wakeup+0x2a>
    80001f5a:	0154ac23          	sw	s5,24(s1)
    80001f5e:	bfd1                	j	80001f32 <wakeup+0x2a>
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
    80001f72:	7179                	addi	sp,sp,-48
    80001f74:	f406                	sd	ra,40(sp)
    80001f76:	f022                	sd	s0,32(sp)
    80001f78:	ec26                	sd	s1,24(sp)
    80001f7a:	e84a                	sd	s2,16(sp)
    80001f7c:	e44e                	sd	s3,8(sp)
    80001f7e:	e052                	sd	s4,0(sp)
    80001f80:	1800                	addi	s0,sp,48
    80001f82:	892a                	mv	s2,a0
    80001f84:	00011497          	auipc	s1,0x11
    80001f88:	87c48493          	addi	s1,s1,-1924 # 80012800 <proc>
    80001f8c:	00008a17          	auipc	s4,0x8
    80001f90:	30ca0a13          	addi	s4,s4,780 # 8000a298 <initproc>
    80001f94:	00016997          	auipc	s3,0x16
    80001f98:	26c98993          	addi	s3,s3,620 # 80018200 <tickslock>
    80001f9c:	a029                	j	80001fa6 <reparent+0x34>
    80001f9e:	16848493          	addi	s1,s1,360
    80001fa2:	01348b63          	beq	s1,s3,80001fb8 <reparent+0x46>
    80001fa6:	7c9c                	ld	a5,56(s1)
    80001fa8:	ff279be3          	bne	a5,s2,80001f9e <reparent+0x2c>
    80001fac:	000a3503          	ld	a0,0(s4)
    80001fb0:	fc88                	sd	a0,56(s1)
    80001fb2:	f57ff0ef          	jal	80001f08 <wakeup>
    80001fb6:	b7e5                	j	80001f9e <reparent+0x2c>
    80001fb8:	70a2                	ld	ra,40(sp)
    80001fba:	7402                	ld	s0,32(sp)
    80001fbc:	64e2                	ld	s1,24(sp)
    80001fbe:	6942                	ld	s2,16(sp)
    80001fc0:	69a2                	ld	s3,8(sp)
    80001fc2:	6a02                	ld	s4,0(sp)
    80001fc4:	6145                	addi	sp,sp,48
    80001fc6:	8082                	ret

0000000080001fc8 <exit>:
    80001fc8:	7179                	addi	sp,sp,-48
    80001fca:	f406                	sd	ra,40(sp)
    80001fcc:	f022                	sd	s0,32(sp)
    80001fce:	ec26                	sd	s1,24(sp)
    80001fd0:	e84a                	sd	s2,16(sp)
    80001fd2:	e44e                	sd	s3,8(sp)
    80001fd4:	e052                	sd	s4,0(sp)
    80001fd6:	1800                	addi	s0,sp,48
    80001fd8:	8a2a                	mv	s4,a0
    80001fda:	915ff0ef          	jal	800018ee <myproc>
    80001fde:	89aa                	mv	s3,a0
    80001fe0:	00008797          	auipc	a5,0x8
    80001fe4:	2b87b783          	ld	a5,696(a5) # 8000a298 <initproc>
    80001fe8:	0d050493          	addi	s1,a0,208
    80001fec:	15050913          	addi	s2,a0,336
    80001ff0:	00a79f63          	bne	a5,a0,8000200e <exit+0x46>
    80001ff4:	00005517          	auipc	a0,0x5
    80001ff8:	28c50513          	addi	a0,a0,652 # 80007280 <etext+0x280>
    80001ffc:	fa6fe0ef          	jal	800007a2 <panic>
    80002000:	6b9010ef          	jal	80003eb8 <fileclose>
    80002004:	0004b023          	sd	zero,0(s1)
    80002008:	04a1                	addi	s1,s1,8
    8000200a:	01248563          	beq	s1,s2,80002014 <exit+0x4c>
    8000200e:	6088                	ld	a0,0(s1)
    80002010:	f965                	bnez	a0,80002000 <exit+0x38>
    80002012:	bfdd                	j	80002008 <exit+0x40>
    80002014:	28b010ef          	jal	80003a9e <begin_op>
    80002018:	1509b503          	ld	a0,336(s3)
    8000201c:	36e010ef          	jal	8000338a <iput>
    80002020:	2e9010ef          	jal	80003b08 <end_op>
    80002024:	1409b823          	sd	zero,336(s3)
    80002028:	00010497          	auipc	s1,0x10
    8000202c:	3c048493          	addi	s1,s1,960 # 800123e8 <wait_lock>
    80002030:	8526                	mv	a0,s1
    80002032:	bd1fe0ef          	jal	80000c02 <acquire>
    80002036:	854e                	mv	a0,s3
    80002038:	f3bff0ef          	jal	80001f72 <reparent>
    8000203c:	0389b503          	ld	a0,56(s3)
    80002040:	ec9ff0ef          	jal	80001f08 <wakeup>
    80002044:	854e                	mv	a0,s3
    80002046:	bbdfe0ef          	jal	80000c02 <acquire>
    8000204a:	0349a623          	sw	s4,44(s3)
    8000204e:	4795                	li	a5,5
    80002050:	00f9ac23          	sw	a5,24(s3)
    80002054:	8526                	mv	a0,s1
    80002056:	c45fe0ef          	jal	80000c9a <release>
    8000205a:	d7dff0ef          	jal	80001dd6 <sched>
    8000205e:	00005517          	auipc	a0,0x5
    80002062:	23250513          	addi	a0,a0,562 # 80007290 <etext+0x290>
    80002066:	f3cfe0ef          	jal	800007a2 <panic>

000000008000206a <kill>:
    8000206a:	7179                	addi	sp,sp,-48
    8000206c:	f406                	sd	ra,40(sp)
    8000206e:	f022                	sd	s0,32(sp)
    80002070:	ec26                	sd	s1,24(sp)
    80002072:	e84a                	sd	s2,16(sp)
    80002074:	e44e                	sd	s3,8(sp)
    80002076:	1800                	addi	s0,sp,48
    80002078:	892a                	mv	s2,a0
    8000207a:	00010497          	auipc	s1,0x10
    8000207e:	78648493          	addi	s1,s1,1926 # 80012800 <proc>
    80002082:	00016997          	auipc	s3,0x16
    80002086:	17e98993          	addi	s3,s3,382 # 80018200 <tickslock>
    8000208a:	8526                	mv	a0,s1
    8000208c:	b77fe0ef          	jal	80000c02 <acquire>
    80002090:	589c                	lw	a5,48(s1)
    80002092:	01278b63          	beq	a5,s2,800020a8 <kill+0x3e>
    80002096:	8526                	mv	a0,s1
    80002098:	c03fe0ef          	jal	80000c9a <release>
    8000209c:	16848493          	addi	s1,s1,360
    800020a0:	ff3495e3          	bne	s1,s3,8000208a <kill+0x20>
    800020a4:	557d                	li	a0,-1
    800020a6:	a819                	j	800020bc <kill+0x52>
    800020a8:	4785                	li	a5,1
    800020aa:	d49c                	sw	a5,40(s1)
    800020ac:	4c98                	lw	a4,24(s1)
    800020ae:	4789                	li	a5,2
    800020b0:	00f70d63          	beq	a4,a5,800020ca <kill+0x60>
    800020b4:	8526                	mv	a0,s1
    800020b6:	be5fe0ef          	jal	80000c9a <release>
    800020ba:	4501                	li	a0,0
    800020bc:	70a2                	ld	ra,40(sp)
    800020be:	7402                	ld	s0,32(sp)
    800020c0:	64e2                	ld	s1,24(sp)
    800020c2:	6942                	ld	s2,16(sp)
    800020c4:	69a2                	ld	s3,8(sp)
    800020c6:	6145                	addi	sp,sp,48
    800020c8:	8082                	ret
    800020ca:	478d                	li	a5,3
    800020cc:	cc9c                	sw	a5,24(s1)
    800020ce:	b7dd                	j	800020b4 <kill+0x4a>

00000000800020d0 <setkilled>:
    800020d0:	1101                	addi	sp,sp,-32
    800020d2:	ec06                	sd	ra,24(sp)
    800020d4:	e822                	sd	s0,16(sp)
    800020d6:	e426                	sd	s1,8(sp)
    800020d8:	1000                	addi	s0,sp,32
    800020da:	84aa                	mv	s1,a0
    800020dc:	b27fe0ef          	jal	80000c02 <acquire>
    800020e0:	4785                	li	a5,1
    800020e2:	d49c                	sw	a5,40(s1)
    800020e4:	8526                	mv	a0,s1
    800020e6:	bb5fe0ef          	jal	80000c9a <release>
    800020ea:	60e2                	ld	ra,24(sp)
    800020ec:	6442                	ld	s0,16(sp)
    800020ee:	64a2                	ld	s1,8(sp)
    800020f0:	6105                	addi	sp,sp,32
    800020f2:	8082                	ret

00000000800020f4 <killed>:
    800020f4:	1101                	addi	sp,sp,-32
    800020f6:	ec06                	sd	ra,24(sp)
    800020f8:	e822                	sd	s0,16(sp)
    800020fa:	e426                	sd	s1,8(sp)
    800020fc:	e04a                	sd	s2,0(sp)
    800020fe:	1000                	addi	s0,sp,32
    80002100:	84aa                	mv	s1,a0
    80002102:	b01fe0ef          	jal	80000c02 <acquire>
    80002106:	0284a903          	lw	s2,40(s1)
    8000210a:	8526                	mv	a0,s1
    8000210c:	b8ffe0ef          	jal	80000c9a <release>
    80002110:	854a                	mv	a0,s2
    80002112:	60e2                	ld	ra,24(sp)
    80002114:	6442                	ld	s0,16(sp)
    80002116:	64a2                	ld	s1,8(sp)
    80002118:	6902                	ld	s2,0(sp)
    8000211a:	6105                	addi	sp,sp,32
    8000211c:	8082                	ret

000000008000211e <wait>:
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
    80002138:	fb6ff0ef          	jal	800018ee <myproc>
    8000213c:	892a                	mv	s2,a0
    8000213e:	00010517          	auipc	a0,0x10
    80002142:	2aa50513          	addi	a0,a0,682 # 800123e8 <wait_lock>
    80002146:	abdfe0ef          	jal	80000c02 <acquire>
    8000214a:	4b81                	li	s7,0
    8000214c:	4a15                	li	s4,5
    8000214e:	4a85                	li	s5,1
    80002150:	00016997          	auipc	s3,0x16
    80002154:	0b098993          	addi	s3,s3,176 # 80018200 <tickslock>
    80002158:	00010c17          	auipc	s8,0x10
    8000215c:	290c0c13          	addi	s8,s8,656 # 800123e8 <wait_lock>
    80002160:	a871                	j	800021fc <wait+0xde>
    80002162:	0304a983          	lw	s3,48(s1)
    80002166:	000b0c63          	beqz	s6,8000217e <wait+0x60>
    8000216a:	4691                	li	a3,4
    8000216c:	02c48613          	addi	a2,s1,44
    80002170:	85da                	mv	a1,s6
    80002172:	05093503          	ld	a0,80(s2)
    80002176:	beaff0ef          	jal	80001560 <copyout>
    8000217a:	02054b63          	bltz	a0,800021b0 <wait+0x92>
    8000217e:	8526                	mv	a0,s1
    80002180:	8e1ff0ef          	jal	80001a60 <freeproc>
    80002184:	8526                	mv	a0,s1
    80002186:	b15fe0ef          	jal	80000c9a <release>
    8000218a:	00010517          	auipc	a0,0x10
    8000218e:	25e50513          	addi	a0,a0,606 # 800123e8 <wait_lock>
    80002192:	b09fe0ef          	jal	80000c9a <release>
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
    800021b0:	8526                	mv	a0,s1
    800021b2:	ae9fe0ef          	jal	80000c9a <release>
    800021b6:	00010517          	auipc	a0,0x10
    800021ba:	23250513          	addi	a0,a0,562 # 800123e8 <wait_lock>
    800021be:	addfe0ef          	jal	80000c9a <release>
    800021c2:	59fd                	li	s3,-1
    800021c4:	bfc9                	j	80002196 <wait+0x78>
    800021c6:	16848493          	addi	s1,s1,360
    800021ca:	03348063          	beq	s1,s3,800021ea <wait+0xcc>
    800021ce:	7c9c                	ld	a5,56(s1)
    800021d0:	ff279be3          	bne	a5,s2,800021c6 <wait+0xa8>
    800021d4:	8526                	mv	a0,s1
    800021d6:	a2dfe0ef          	jal	80000c02 <acquire>
    800021da:	4c9c                	lw	a5,24(s1)
    800021dc:	f94783e3          	beq	a5,s4,80002162 <wait+0x44>
    800021e0:	8526                	mv	a0,s1
    800021e2:	ab9fe0ef          	jal	80000c9a <release>
    800021e6:	8756                	mv	a4,s5
    800021e8:	bff9                	j	800021c6 <wait+0xa8>
    800021ea:	cf19                	beqz	a4,80002208 <wait+0xea>
    800021ec:	854a                	mv	a0,s2
    800021ee:	f07ff0ef          	jal	800020f4 <killed>
    800021f2:	e919                	bnez	a0,80002208 <wait+0xea>
    800021f4:	85e2                	mv	a1,s8
    800021f6:	854a                	mv	a0,s2
    800021f8:	cc5ff0ef          	jal	80001ebc <sleep>
    800021fc:	875e                	mv	a4,s7
    800021fe:	00010497          	auipc	s1,0x10
    80002202:	60248493          	addi	s1,s1,1538 # 80012800 <proc>
    80002206:	b7e1                	j	800021ce <wait+0xb0>
    80002208:	00010517          	auipc	a0,0x10
    8000220c:	1e050513          	addi	a0,a0,480 # 800123e8 <wait_lock>
    80002210:	a8bfe0ef          	jal	80000c9a <release>
    80002214:	59fd                	li	s3,-1
    80002216:	b741                	j	80002196 <wait+0x78>

0000000080002218 <either_copyout>:
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
    80002230:	ebeff0ef          	jal	800018ee <myproc>
    80002234:	cc99                	beqz	s1,80002252 <either_copyout+0x3a>
    80002236:	86d2                	mv	a3,s4
    80002238:	864e                	mv	a2,s3
    8000223a:	85ca                	mv	a1,s2
    8000223c:	6928                	ld	a0,80(a0)
    8000223e:	b22ff0ef          	jal	80001560 <copyout>
    80002242:	70a2                	ld	ra,40(sp)
    80002244:	7402                	ld	s0,32(sp)
    80002246:	64e2                	ld	s1,24(sp)
    80002248:	6942                	ld	s2,16(sp)
    8000224a:	69a2                	ld	s3,8(sp)
    8000224c:	6a02                	ld	s4,0(sp)
    8000224e:	6145                	addi	sp,sp,48
    80002250:	8082                	ret
    80002252:	000a061b          	sext.w	a2,s4
    80002256:	85ce                	mv	a1,s3
    80002258:	854a                	mv	a0,s2
    8000225a:	ad9fe0ef          	jal	80000d32 <memmove>
    8000225e:	8526                	mv	a0,s1
    80002260:	b7cd                	j	80002242 <either_copyout+0x2a>

0000000080002262 <either_copyin>:
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
    8000227a:	e74ff0ef          	jal	800018ee <myproc>
    8000227e:	cc99                	beqz	s1,8000229c <either_copyin+0x3a>
    80002280:	86d2                	mv	a3,s4
    80002282:	864e                	mv	a2,s3
    80002284:	85ca                	mv	a1,s2
    80002286:	6928                	ld	a0,80(a0)
    80002288:	baeff0ef          	jal	80001636 <copyin>
    8000228c:	70a2                	ld	ra,40(sp)
    8000228e:	7402                	ld	s0,32(sp)
    80002290:	64e2                	ld	s1,24(sp)
    80002292:	6942                	ld	s2,16(sp)
    80002294:	69a2                	ld	s3,8(sp)
    80002296:	6a02                	ld	s4,0(sp)
    80002298:	6145                	addi	sp,sp,48
    8000229a:	8082                	ret
    8000229c:	000a061b          	sext.w	a2,s4
    800022a0:	85ce                	mv	a1,s3
    800022a2:	854a                	mv	a0,s2
    800022a4:	a8ffe0ef          	jal	80000d32 <memmove>
    800022a8:	8526                	mv	a0,s1
    800022aa:	b7cd                	j	8000228c <either_copyin+0x2a>

00000000800022ac <procdump>:
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
    800022c2:	00005517          	auipc	a0,0x5
    800022c6:	db650513          	addi	a0,a0,-586 # 80007078 <etext+0x78>
    800022ca:	a06fe0ef          	jal	800004d0 <printf>
    800022ce:	00010497          	auipc	s1,0x10
    800022d2:	68a48493          	addi	s1,s1,1674 # 80012958 <proc+0x158>
    800022d6:	00016917          	auipc	s2,0x16
    800022da:	08290913          	addi	s2,s2,130 # 80018358 <bcache+0x140>
    800022de:	4b15                	li	s6,5
    800022e0:	00005997          	auipc	s3,0x5
    800022e4:	fc098993          	addi	s3,s3,-64 # 800072a0 <etext+0x2a0>
    800022e8:	00005a97          	auipc	s5,0x5
    800022ec:	fc0a8a93          	addi	s5,s5,-64 # 800072a8 <etext+0x2a8>
    800022f0:	00005a17          	auipc	s4,0x5
    800022f4:	d88a0a13          	addi	s4,s4,-632 # 80007078 <etext+0x78>
    800022f8:	00005b97          	auipc	s7,0x5
    800022fc:	490b8b93          	addi	s7,s7,1168 # 80007788 <states.0>
    80002300:	a829                	j	8000231a <procdump+0x6e>
    80002302:	ed86a583          	lw	a1,-296(a3)
    80002306:	8556                	mv	a0,s5
    80002308:	9c8fe0ef          	jal	800004d0 <printf>
    8000230c:	8552                	mv	a0,s4
    8000230e:	9c2fe0ef          	jal	800004d0 <printf>
    80002312:	16848493          	addi	s1,s1,360
    80002316:	03248263          	beq	s1,s2,8000233a <procdump+0x8e>
    8000231a:	86a6                	mv	a3,s1
    8000231c:	ec04a783          	lw	a5,-320(s1)
    80002320:	dbed                	beqz	a5,80002312 <procdump+0x66>
    80002322:	864e                	mv	a2,s3
    80002324:	fcfb6fe3          	bltu	s6,a5,80002302 <procdump+0x56>
    80002328:	02079713          	slli	a4,a5,0x20
    8000232c:	01d75793          	srli	a5,a4,0x1d
    80002330:	97de                	add	a5,a5,s7
    80002332:	6390                	ld	a2,0(a5)
    80002334:	f679                	bnez	a2,80002302 <procdump+0x56>
    80002336:	864e                	mv	a2,s3
    80002338:	b7e9                	j	80002302 <procdump+0x56>
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

extern int devintr();

void
trapinit(void)
{
    800023ba:	1141                	addi	sp,sp,-16
    800023bc:	e406                	sd	ra,8(sp)
    800023be:	e022                	sd	s0,0(sp)
    800023c0:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800023c2:	00005597          	auipc	a1,0x5
    800023c6:	f2658593          	addi	a1,a1,-218 # 800072e8 <etext+0x2e8>
    800023ca:	00016517          	auipc	a0,0x16
    800023ce:	e3650513          	addi	a0,a0,-458 # 80018200 <tickslock>
    800023d2:	fb0fe0ef          	jal	80000b82 <initlock>
}
    800023d6:	60a2                	ld	ra,8(sp)
    800023d8:	6402                	ld	s0,0(sp)
    800023da:	0141                	addi	sp,sp,16
    800023dc:	8082                	ret

00000000800023de <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800023de:	1141                	addi	sp,sp,-16
    800023e0:	e422                	sd	s0,8(sp)
    800023e2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800023e4:	00003797          	auipc	a5,0x3
    800023e8:	e3c78793          	addi	a5,a5,-452 # 80005220 <kernelvec>
    800023ec:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800023f0:	6422                	ld	s0,8(sp)
    800023f2:	0141                	addi	sp,sp,16
    800023f4:	8082                	ret

00000000800023f6 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800023f6:	1141                	addi	sp,sp,-16
    800023f8:	e406                	sd	ra,8(sp)
    800023fa:	e022                	sd	s0,0(sp)
    800023fc:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800023fe:	cf0ff0ef          	jal	800018ee <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002402:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002406:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002408:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000240c:	00004697          	auipc	a3,0x4
    80002410:	bf468693          	addi	a3,a3,-1036 # 80006000 <_trampoline>
    80002414:	00004717          	auipc	a4,0x4
    80002418:	bec70713          	addi	a4,a4,-1044 # 80006000 <_trampoline>
    8000241c:	8f15                	sub	a4,a4,a3
    8000241e:	040007b7          	lui	a5,0x4000
    80002422:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002424:	07b2                	slli	a5,a5,0xc
    80002426:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002428:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000242c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000242e:	18002673          	csrr	a2,satp
    80002432:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002434:	6d30                	ld	a2,88(a0)
    80002436:	6138                	ld	a4,64(a0)
    80002438:	6585                	lui	a1,0x1
    8000243a:	972e                	add	a4,a4,a1
    8000243c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000243e:	6d38                	ld	a4,88(a0)
    80002440:	00000617          	auipc	a2,0x0
    80002444:	11060613          	addi	a2,a2,272 # 80002550 <usertrap>
    80002448:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000244a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000244c:	8612                	mv	a2,tp
    8000244e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002450:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002454:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002458:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000245c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002460:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002462:	6f18                	ld	a4,24(a4)
    80002464:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002468:	6928                	ld	a0,80(a0)
    8000246a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000246c:	00004717          	auipc	a4,0x4
    80002470:	c3070713          	addi	a4,a4,-976 # 8000609c <userret>
    80002474:	8f15                	sub	a4,a4,a3
    80002476:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002478:	577d                	li	a4,-1
    8000247a:	177e                	slli	a4,a4,0x3f
    8000247c:	8d59                	or	a0,a0,a4
    8000247e:	9782                	jalr	a5
}
    80002480:	60a2                	ld	ra,8(sp)
    80002482:	6402                	ld	s0,0(sp)
    80002484:	0141                	addi	sp,sp,16
    80002486:	8082                	ret

0000000080002488 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002488:	1101                	addi	sp,sp,-32
    8000248a:	ec06                	sd	ra,24(sp)
    8000248c:	e822                	sd	s0,16(sp)
    8000248e:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80002490:	c32ff0ef          	jal	800018c2 <cpuid>
    80002494:	cd11                	beqz	a0,800024b0 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002496:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000249a:	000f4737          	lui	a4,0xf4
    8000249e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800024a2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800024a4:	14d79073          	csrw	stimecmp,a5
}
    800024a8:	60e2                	ld	ra,24(sp)
    800024aa:	6442                	ld	s0,16(sp)
    800024ac:	6105                	addi	sp,sp,32
    800024ae:	8082                	ret
    800024b0:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800024b2:	00016497          	auipc	s1,0x16
    800024b6:	d4e48493          	addi	s1,s1,-690 # 80018200 <tickslock>
    800024ba:	8526                	mv	a0,s1
    800024bc:	f46fe0ef          	jal	80000c02 <acquire>
    ticks++;
    800024c0:	00008517          	auipc	a0,0x8
    800024c4:	de050513          	addi	a0,a0,-544 # 8000a2a0 <ticks>
    800024c8:	411c                	lw	a5,0(a0)
    800024ca:	2785                	addiw	a5,a5,1
    800024cc:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800024ce:	a3bff0ef          	jal	80001f08 <wakeup>
    release(&tickslock);
    800024d2:	8526                	mv	a0,s1
    800024d4:	fc6fe0ef          	jal	80000c9a <release>
    800024d8:	64a2                	ld	s1,8(sp)
    800024da:	bf75                	j	80002496 <clockintr+0xe>

00000000800024dc <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800024dc:	1101                	addi	sp,sp,-32
    800024de:	ec06                	sd	ra,24(sp)
    800024e0:	e822                	sd	s0,16(sp)
    800024e2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800024e4:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800024e8:	57fd                	li	a5,-1
    800024ea:	17fe                	slli	a5,a5,0x3f
    800024ec:	07a5                	addi	a5,a5,9
    800024ee:	00f70c63          	beq	a4,a5,80002506 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800024f2:	57fd                	li	a5,-1
    800024f4:	17fe                	slli	a5,a5,0x3f
    800024f6:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800024f8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800024fa:	04f70763          	beq	a4,a5,80002548 <devintr+0x6c>
  }
}
    800024fe:	60e2                	ld	ra,24(sp)
    80002500:	6442                	ld	s0,16(sp)
    80002502:	6105                	addi	sp,sp,32
    80002504:	8082                	ret
    80002506:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002508:	5c5020ef          	jal	800052cc <plic_claim>
    8000250c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000250e:	47a9                	li	a5,10
    80002510:	00f50963          	beq	a0,a5,80002522 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80002514:	4785                	li	a5,1
    80002516:	00f50963          	beq	a0,a5,80002528 <devintr+0x4c>
    return 1;
    8000251a:	4505                	li	a0,1
    } else if(irq){
    8000251c:	e889                	bnez	s1,8000252e <devintr+0x52>
    8000251e:	64a2                	ld	s1,8(sp)
    80002520:	bff9                	j	800024fe <devintr+0x22>
      uartintr();
    80002522:	cf2fe0ef          	jal	80000a14 <uartintr>
    if(irq)
    80002526:	a819                	j	8000253c <devintr+0x60>
      virtio_disk_intr();
    80002528:	26a030ef          	jal	80005792 <virtio_disk_intr>
    if(irq)
    8000252c:	a801                	j	8000253c <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    8000252e:	85a6                	mv	a1,s1
    80002530:	00005517          	auipc	a0,0x5
    80002534:	dc050513          	addi	a0,a0,-576 # 800072f0 <etext+0x2f0>
    80002538:	f99fd0ef          	jal	800004d0 <printf>
      plic_complete(irq);
    8000253c:	8526                	mv	a0,s1
    8000253e:	5af020ef          	jal	800052ec <plic_complete>
    return 1;
    80002542:	4505                	li	a0,1
    80002544:	64a2                	ld	s1,8(sp)
    80002546:	bf65                	j	800024fe <devintr+0x22>
    clockintr();
    80002548:	f41ff0ef          	jal	80002488 <clockintr>
    return 2;
    8000254c:	4509                	li	a0,2
    8000254e:	bf45                	j	800024fe <devintr+0x22>

0000000080002550 <usertrap>:
{
    80002550:	1101                	addi	sp,sp,-32
    80002552:	ec06                	sd	ra,24(sp)
    80002554:	e822                	sd	s0,16(sp)
    80002556:	e426                	sd	s1,8(sp)
    80002558:	e04a                	sd	s2,0(sp)
    8000255a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000255c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002560:	1007f793          	andi	a5,a5,256
    80002564:	ef85                	bnez	a5,8000259c <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002566:	00003797          	auipc	a5,0x3
    8000256a:	cba78793          	addi	a5,a5,-838 # 80005220 <kernelvec>
    8000256e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002572:	b7cff0ef          	jal	800018ee <myproc>
    80002576:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002578:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000257a:	14102773          	csrr	a4,sepc
    8000257e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002580:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002584:	47a1                	li	a5,8
    80002586:	02f70163          	beq	a4,a5,800025a8 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    8000258a:	f53ff0ef          	jal	800024dc <devintr>
    8000258e:	892a                	mv	s2,a0
    80002590:	c135                	beqz	a0,800025f4 <usertrap+0xa4>
  if(killed(p))
    80002592:	8526                	mv	a0,s1
    80002594:	b61ff0ef          	jal	800020f4 <killed>
    80002598:	cd1d                	beqz	a0,800025d6 <usertrap+0x86>
    8000259a:	a81d                	j	800025d0 <usertrap+0x80>
    panic("usertrap: not from user mode");
    8000259c:	00005517          	auipc	a0,0x5
    800025a0:	d7450513          	addi	a0,a0,-652 # 80007310 <etext+0x310>
    800025a4:	9fefe0ef          	jal	800007a2 <panic>
    if(killed(p))
    800025a8:	b4dff0ef          	jal	800020f4 <killed>
    800025ac:	e121                	bnez	a0,800025ec <usertrap+0x9c>
    p->trapframe->epc += 4;
    800025ae:	6cb8                	ld	a4,88(s1)
    800025b0:	6f1c                	ld	a5,24(a4)
    800025b2:	0791                	addi	a5,a5,4
    800025b4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025b6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800025ba:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025be:	10079073          	csrw	sstatus,a5
    syscall();
    800025c2:	248000ef          	jal	8000280a <syscall>
  if(killed(p))
    800025c6:	8526                	mv	a0,s1
    800025c8:	b2dff0ef          	jal	800020f4 <killed>
    800025cc:	c901                	beqz	a0,800025dc <usertrap+0x8c>
    800025ce:	4901                	li	s2,0
    exit(-1);
    800025d0:	557d                	li	a0,-1
    800025d2:	9f7ff0ef          	jal	80001fc8 <exit>
  if(which_dev == 2)
    800025d6:	4789                	li	a5,2
    800025d8:	04f90563          	beq	s2,a5,80002622 <usertrap+0xd2>
  usertrapret();
    800025dc:	e1bff0ef          	jal	800023f6 <usertrapret>
}
    800025e0:	60e2                	ld	ra,24(sp)
    800025e2:	6442                	ld	s0,16(sp)
    800025e4:	64a2                	ld	s1,8(sp)
    800025e6:	6902                	ld	s2,0(sp)
    800025e8:	6105                	addi	sp,sp,32
    800025ea:	8082                	ret
      exit(-1);
    800025ec:	557d                	li	a0,-1
    800025ee:	9dbff0ef          	jal	80001fc8 <exit>
    800025f2:	bf75                	j	800025ae <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800025f4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800025f8:	5890                	lw	a2,48(s1)
    800025fa:	00005517          	auipc	a0,0x5
    800025fe:	d3650513          	addi	a0,a0,-714 # 80007330 <etext+0x330>
    80002602:	ecffd0ef          	jal	800004d0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002606:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000260a:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    8000260e:	00005517          	auipc	a0,0x5
    80002612:	d5250513          	addi	a0,a0,-686 # 80007360 <etext+0x360>
    80002616:	ebbfd0ef          	jal	800004d0 <printf>
    setkilled(p);
    8000261a:	8526                	mv	a0,s1
    8000261c:	ab5ff0ef          	jal	800020d0 <setkilled>
    80002620:	b75d                	j	800025c6 <usertrap+0x76>
    yield();
    80002622:	86fff0ef          	jal	80001e90 <yield>
    80002626:	bf5d                	j	800025dc <usertrap+0x8c>

0000000080002628 <kerneltrap>:
{
    80002628:	7179                	addi	sp,sp,-48
    8000262a:	f406                	sd	ra,40(sp)
    8000262c:	f022                	sd	s0,32(sp)
    8000262e:	ec26                	sd	s1,24(sp)
    80002630:	e84a                	sd	s2,16(sp)
    80002632:	e44e                	sd	s3,8(sp)
    80002634:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002636:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000263a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000263e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002642:	1004f793          	andi	a5,s1,256
    80002646:	c795                	beqz	a5,80002672 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002648:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000264c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000264e:	eb85                	bnez	a5,8000267e <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002650:	e8dff0ef          	jal	800024dc <devintr>
    80002654:	c91d                	beqz	a0,8000268a <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002656:	4789                	li	a5,2
    80002658:	04f50a63          	beq	a0,a5,800026ac <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000265c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002660:	10049073          	csrw	sstatus,s1
}
    80002664:	70a2                	ld	ra,40(sp)
    80002666:	7402                	ld	s0,32(sp)
    80002668:	64e2                	ld	s1,24(sp)
    8000266a:	6942                	ld	s2,16(sp)
    8000266c:	69a2                	ld	s3,8(sp)
    8000266e:	6145                	addi	sp,sp,48
    80002670:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002672:	00005517          	auipc	a0,0x5
    80002676:	d1650513          	addi	a0,a0,-746 # 80007388 <etext+0x388>
    8000267a:	928fe0ef          	jal	800007a2 <panic>
    panic("kerneltrap: interrupts enabled");
    8000267e:	00005517          	auipc	a0,0x5
    80002682:	d3250513          	addi	a0,a0,-718 # 800073b0 <etext+0x3b0>
    80002686:	91cfe0ef          	jal	800007a2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000268a:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000268e:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002692:	85ce                	mv	a1,s3
    80002694:	00005517          	auipc	a0,0x5
    80002698:	d3c50513          	addi	a0,a0,-708 # 800073d0 <etext+0x3d0>
    8000269c:	e35fd0ef          	jal	800004d0 <printf>
    panic("kerneltrap");
    800026a0:	00005517          	auipc	a0,0x5
    800026a4:	d5850513          	addi	a0,a0,-680 # 800073f8 <etext+0x3f8>
    800026a8:	8fafe0ef          	jal	800007a2 <panic>
  if(which_dev == 2 && myproc() != 0)
    800026ac:	a42ff0ef          	jal	800018ee <myproc>
    800026b0:	d555                	beqz	a0,8000265c <kerneltrap+0x34>
    yield();
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
[SYS_getppid] sys_getppid,
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
  syscall_count++; 
    80002828:	00008617          	auipc	a2,0x8
    8000282c:	a8060613          	addi	a2,a2,-1408 # 8000a2a8 <syscall_count>
    80002830:	6218                	ld	a4,0(a2)
    80002832:	0705                	addi	a4,a4,1
    80002834:	e218                	sd	a4,0(a2)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002836:	37fd                	addiw	a5,a5,-1
    80002838:	475d                	li	a4,23
    8000283a:	00f76f63          	bltu	a4,a5,80002858 <syscall+0x4e>
    8000283e:	00369713          	slli	a4,a3,0x3
    80002842:	00005797          	auipc	a5,0x5
    80002846:	f8e78793          	addi	a5,a5,-114 # 800077d0 <syscalls>
    8000284a:	97ba                	add	a5,a5,a4
    8000284c:	639c                	ld	a5,0(a5)
    8000284e:	c789                	beqz	a5,80002858 <syscall+0x4e>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002850:	9782                	jalr	a5
    80002852:	06a93823          	sd	a0,112(s2)
    80002856:	a829                	j	80002870 <syscall+0x66>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002858:	15848613          	addi	a2,s1,344
    8000285c:	588c                	lw	a1,48(s1)
    8000285e:	00005517          	auipc	a0,0x5
    80002862:	bb250513          	addi	a0,a0,-1102 # 80007410 <etext+0x410>
    80002866:	c6bfd0ef          	jal	800004d0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000286a:	6cbc                	ld	a5,88(s1)
    8000286c:	577d                	li	a4,-1
    8000286e:	fbb8                	sd	a4,112(a5)
  }
}
    80002870:	60e2                	ld	ra,24(sp)
    80002872:	6442                	ld	s0,16(sp)
    80002874:	64a2                	ld	s1,8(sp)
    80002876:	6902                	ld	s2,0(sp)
    80002878:	6105                	addi	sp,sp,32
    8000287a:	8082                	ret

000000008000287c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000287c:	1101                	addi	sp,sp,-32
    8000287e:	ec06                	sd	ra,24(sp)
    80002880:	e822                	sd	s0,16(sp)
    80002882:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002884:	fec40593          	addi	a1,s0,-20
    80002888:	4501                	li	a0,0
    8000288a:	f19ff0ef          	jal	800027a2 <argint>
  exit(n);
    8000288e:	fec42503          	lw	a0,-20(s0)
    80002892:	f36ff0ef          	jal	80001fc8 <exit>
  return 0;  // not reached
}
    80002896:	4501                	li	a0,0
    80002898:	60e2                	ld	ra,24(sp)
    8000289a:	6442                	ld	s0,16(sp)
    8000289c:	6105                	addi	sp,sp,32
    8000289e:	8082                	ret

00000000800028a0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800028a0:	1141                	addi	sp,sp,-16
    800028a2:	e406                	sd	ra,8(sp)
    800028a4:	e022                	sd	s0,0(sp)
    800028a6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800028a8:	846ff0ef          	jal	800018ee <myproc>
}
    800028ac:	5908                	lw	a0,48(a0)
    800028ae:	60a2                	ld	ra,8(sp)
    800028b0:	6402                	ld	s0,0(sp)
    800028b2:	0141                	addi	sp,sp,16
    800028b4:	8082                	ret

00000000800028b6 <sys_fork>:

uint64
sys_fork(void)
{
    800028b6:	1141                	addi	sp,sp,-16
    800028b8:	e406                	sd	ra,8(sp)
    800028ba:	e022                	sd	s0,0(sp)
    800028bc:	0800                	addi	s0,sp,16
  return fork();
    800028be:	b56ff0ef          	jal	80001c14 <fork>
}
    800028c2:	60a2                	ld	ra,8(sp)
    800028c4:	6402                	ld	s0,0(sp)
    800028c6:	0141                	addi	sp,sp,16
    800028c8:	8082                	ret

00000000800028ca <sys_wait>:

uint64
sys_wait(void)
{
    800028ca:	1101                	addi	sp,sp,-32
    800028cc:	ec06                	sd	ra,24(sp)
    800028ce:	e822                	sd	s0,16(sp)
    800028d0:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800028d2:	fe840593          	addi	a1,s0,-24
    800028d6:	4501                	li	a0,0
    800028d8:	ee7ff0ef          	jal	800027be <argaddr>
  return wait(p);
    800028dc:	fe843503          	ld	a0,-24(s0)
    800028e0:	83fff0ef          	jal	8000211e <wait>
}
    800028e4:	60e2                	ld	ra,24(sp)
    800028e6:	6442                	ld	s0,16(sp)
    800028e8:	6105                	addi	sp,sp,32
    800028ea:	8082                	ret

00000000800028ec <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800028ec:	7179                	addi	sp,sp,-48
    800028ee:	f406                	sd	ra,40(sp)
    800028f0:	f022                	sd	s0,32(sp)
    800028f2:	ec26                	sd	s1,24(sp)
    800028f4:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800028f6:	fdc40593          	addi	a1,s0,-36
    800028fa:	4501                	li	a0,0
    800028fc:	ea7ff0ef          	jal	800027a2 <argint>
  addr = myproc()->sz;
    80002900:	feffe0ef          	jal	800018ee <myproc>
    80002904:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002906:	fdc42503          	lw	a0,-36(s0)
    8000290a:	abaff0ef          	jal	80001bc4 <growproc>
    8000290e:	00054863          	bltz	a0,8000291e <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002912:	8526                	mv	a0,s1
    80002914:	70a2                	ld	ra,40(sp)
    80002916:	7402                	ld	s0,32(sp)
    80002918:	64e2                	ld	s1,24(sp)
    8000291a:	6145                	addi	sp,sp,48
    8000291c:	8082                	ret
    return -1;
    8000291e:	54fd                	li	s1,-1
    80002920:	bfcd                	j	80002912 <sys_sbrk+0x26>

0000000080002922 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002922:	7139                	addi	sp,sp,-64
    80002924:	fc06                	sd	ra,56(sp)
    80002926:	f822                	sd	s0,48(sp)
    80002928:	f04a                	sd	s2,32(sp)
    8000292a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000292c:	fcc40593          	addi	a1,s0,-52
    80002930:	4501                	li	a0,0
    80002932:	e71ff0ef          	jal	800027a2 <argint>
  if(n < 0)
    80002936:	fcc42783          	lw	a5,-52(s0)
    8000293a:	0607c763          	bltz	a5,800029a8 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    8000293e:	00016517          	auipc	a0,0x16
    80002942:	8c250513          	addi	a0,a0,-1854 # 80018200 <tickslock>
    80002946:	abcfe0ef          	jal	80000c02 <acquire>
  ticks0 = ticks;
    8000294a:	00008917          	auipc	s2,0x8
    8000294e:	95692903          	lw	s2,-1706(s2) # 8000a2a0 <ticks>
  while(ticks - ticks0 < n){
    80002952:	fcc42783          	lw	a5,-52(s0)
    80002956:	cf8d                	beqz	a5,80002990 <sys_sleep+0x6e>
    80002958:	f426                	sd	s1,40(sp)
    8000295a:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000295c:	00016997          	auipc	s3,0x16
    80002960:	8a498993          	addi	s3,s3,-1884 # 80018200 <tickslock>
    80002964:	00008497          	auipc	s1,0x8
    80002968:	93c48493          	addi	s1,s1,-1732 # 8000a2a0 <ticks>
    if(killed(myproc())){
    8000296c:	f83fe0ef          	jal	800018ee <myproc>
    80002970:	f84ff0ef          	jal	800020f4 <killed>
    80002974:	ed0d                	bnez	a0,800029ae <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002976:	85ce                	mv	a1,s3
    80002978:	8526                	mv	a0,s1
    8000297a:	d42ff0ef          	jal	80001ebc <sleep>
  while(ticks - ticks0 < n){
    8000297e:	409c                	lw	a5,0(s1)
    80002980:	412787bb          	subw	a5,a5,s2
    80002984:	fcc42703          	lw	a4,-52(s0)
    80002988:	fee7e2e3          	bltu	a5,a4,8000296c <sys_sleep+0x4a>
    8000298c:	74a2                	ld	s1,40(sp)
    8000298e:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002990:	00016517          	auipc	a0,0x16
    80002994:	87050513          	addi	a0,a0,-1936 # 80018200 <tickslock>
    80002998:	b02fe0ef          	jal	80000c9a <release>
  return 0;
    8000299c:	4501                	li	a0,0
}
    8000299e:	70e2                	ld	ra,56(sp)
    800029a0:	7442                	ld	s0,48(sp)
    800029a2:	7902                	ld	s2,32(sp)
    800029a4:	6121                	addi	sp,sp,64
    800029a6:	8082                	ret
    n = 0;
    800029a8:	fc042623          	sw	zero,-52(s0)
    800029ac:	bf49                	j	8000293e <sys_sleep+0x1c>
      release(&tickslock);
    800029ae:	00016517          	auipc	a0,0x16
    800029b2:	85250513          	addi	a0,a0,-1966 # 80018200 <tickslock>
    800029b6:	ae4fe0ef          	jal	80000c9a <release>
      return -1;
    800029ba:	557d                	li	a0,-1
    800029bc:	74a2                	ld	s1,40(sp)
    800029be:	69e2                	ld	s3,24(sp)
    800029c0:	bff9                	j	8000299e <sys_sleep+0x7c>

00000000800029c2 <sys_kill>:

uint64
sys_kill(void)
{
    800029c2:	1101                	addi	sp,sp,-32
    800029c4:	ec06                	sd	ra,24(sp)
    800029c6:	e822                	sd	s0,16(sp)
    800029c8:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800029ca:	fec40593          	addi	a1,s0,-20
    800029ce:	4501                	li	a0,0
    800029d0:	dd3ff0ef          	jal	800027a2 <argint>
  return kill(pid);
    800029d4:	fec42503          	lw	a0,-20(s0)
    800029d8:	e92ff0ef          	jal	8000206a <kill>
}
    800029dc:	60e2                	ld	ra,24(sp)
    800029de:	6442                	ld	s0,16(sp)
    800029e0:	6105                	addi	sp,sp,32
    800029e2:	8082                	ret

00000000800029e4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800029e4:	1101                	addi	sp,sp,-32
    800029e6:	ec06                	sd	ra,24(sp)
    800029e8:	e822                	sd	s0,16(sp)
    800029ea:	e426                	sd	s1,8(sp)
    800029ec:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800029ee:	00016517          	auipc	a0,0x16
    800029f2:	81250513          	addi	a0,a0,-2030 # 80018200 <tickslock>
    800029f6:	a0cfe0ef          	jal	80000c02 <acquire>
  xticks = ticks;
    800029fa:	00008497          	auipc	s1,0x8
    800029fe:	8a64a483          	lw	s1,-1882(s1) # 8000a2a0 <ticks>
  release(&tickslock);
    80002a02:	00015517          	auipc	a0,0x15
    80002a06:	7fe50513          	addi	a0,a0,2046 # 80018200 <tickslock>
    80002a0a:	a90fe0ef          	jal	80000c9a <release>
  return xticks;
}
    80002a0e:	02049513          	slli	a0,s1,0x20
    80002a12:	9101                	srli	a0,a0,0x20
    80002a14:	60e2                	ld	ra,24(sp)
    80002a16:	6442                	ld	s0,16(sp)
    80002a18:	64a2                	ld	s1,8(sp)
    80002a1a:	6105                	addi	sp,sp,32
    80002a1c:	8082                	ret

0000000080002a1e <sys_countsyscall>:
uint64 syscall_count = 0;
uint64
sys_countsyscall(void)
{
    80002a1e:	1141                	addi	sp,sp,-16
    80002a20:	e422                	sd	s0,8(sp)
    80002a22:	0800                	addi	s0,sp,16
  return syscall_count;
}
    80002a24:	00008517          	auipc	a0,0x8
    80002a28:	88453503          	ld	a0,-1916(a0) # 8000a2a8 <syscall_count>
    80002a2c:	6422                	ld	s0,8(sp)
    80002a2e:	0141                	addi	sp,sp,16
    80002a30:	8082                	ret

0000000080002a32 <sys_getppid>:
uint64
sys_getppid(void)
{
    80002a32:	1141                	addi	sp,sp,-16
    80002a34:	e406                	sd	ra,8(sp)
    80002a36:	e022                	sd	s0,0(sp)
    80002a38:	0800                	addi	s0,sp,16
  return myproc()->parent->pid;
    80002a3a:	eb5fe0ef          	jal	800018ee <myproc>
    80002a3e:	7d1c                	ld	a5,56(a0)
}
    80002a40:	5b88                	lw	a0,48(a5)
    80002a42:	60a2                	ld	ra,8(sp)
    80002a44:	6402                	ld	s0,0(sp)
    80002a46:	0141                	addi	sp,sp,16
    80002a48:	8082                	ret

0000000080002a4a <binit>:
    80002a4a:	7179                	addi	sp,sp,-48
    80002a4c:	f406                	sd	ra,40(sp)
    80002a4e:	f022                	sd	s0,32(sp)
    80002a50:	ec26                	sd	s1,24(sp)
    80002a52:	e84a                	sd	s2,16(sp)
    80002a54:	e44e                	sd	s3,8(sp)
    80002a56:	e052                	sd	s4,0(sp)
    80002a58:	1800                	addi	s0,sp,48
    80002a5a:	00005597          	auipc	a1,0x5
    80002a5e:	9d658593          	addi	a1,a1,-1578 # 80007430 <etext+0x430>
    80002a62:	00015517          	auipc	a0,0x15
    80002a66:	7b650513          	addi	a0,a0,1974 # 80018218 <bcache>
    80002a6a:	918fe0ef          	jal	80000b82 <initlock>
    80002a6e:	0001d797          	auipc	a5,0x1d
    80002a72:	7aa78793          	addi	a5,a5,1962 # 80020218 <bcache+0x8000>
    80002a76:	0001e717          	auipc	a4,0x1e
    80002a7a:	a0a70713          	addi	a4,a4,-1526 # 80020480 <bcache+0x8268>
    80002a7e:	2ae7b823          	sd	a4,688(a5)
    80002a82:	2ae7bc23          	sd	a4,696(a5)
    80002a86:	00015497          	auipc	s1,0x15
    80002a8a:	7aa48493          	addi	s1,s1,1962 # 80018230 <bcache+0x18>
    80002a8e:	893e                	mv	s2,a5
    80002a90:	89ba                	mv	s3,a4
    80002a92:	00005a17          	auipc	s4,0x5
    80002a96:	9a6a0a13          	addi	s4,s4,-1626 # 80007438 <etext+0x438>
    80002a9a:	2b893783          	ld	a5,696(s2)
    80002a9e:	e8bc                	sd	a5,80(s1)
    80002aa0:	0534b423          	sd	s3,72(s1)
    80002aa4:	85d2                	mv	a1,s4
    80002aa6:	01048513          	addi	a0,s1,16
    80002aaa:	248010ef          	jal	80003cf2 <initsleeplock>
    80002aae:	2b893783          	ld	a5,696(s2)
    80002ab2:	e7a4                	sd	s1,72(a5)
    80002ab4:	2a993c23          	sd	s1,696(s2)
    80002ab8:	45848493          	addi	s1,s1,1112
    80002abc:	fd349fe3          	bne	s1,s3,80002a9a <binit+0x50>
    80002ac0:	70a2                	ld	ra,40(sp)
    80002ac2:	7402                	ld	s0,32(sp)
    80002ac4:	64e2                	ld	s1,24(sp)
    80002ac6:	6942                	ld	s2,16(sp)
    80002ac8:	69a2                	ld	s3,8(sp)
    80002aca:	6a02                	ld	s4,0(sp)
    80002acc:	6145                	addi	sp,sp,48
    80002ace:	8082                	ret

0000000080002ad0 <bread>:
    80002ad0:	7179                	addi	sp,sp,-48
    80002ad2:	f406                	sd	ra,40(sp)
    80002ad4:	f022                	sd	s0,32(sp)
    80002ad6:	ec26                	sd	s1,24(sp)
    80002ad8:	e84a                	sd	s2,16(sp)
    80002ada:	e44e                	sd	s3,8(sp)
    80002adc:	1800                	addi	s0,sp,48
    80002ade:	892a                	mv	s2,a0
    80002ae0:	89ae                	mv	s3,a1
    80002ae2:	00015517          	auipc	a0,0x15
    80002ae6:	73650513          	addi	a0,a0,1846 # 80018218 <bcache>
    80002aea:	918fe0ef          	jal	80000c02 <acquire>
    80002aee:	0001e497          	auipc	s1,0x1e
    80002af2:	9e24b483          	ld	s1,-1566(s1) # 800204d0 <bcache+0x82b8>
    80002af6:	0001e797          	auipc	a5,0x1e
    80002afa:	98a78793          	addi	a5,a5,-1654 # 80020480 <bcache+0x8268>
    80002afe:	02f48b63          	beq	s1,a5,80002b34 <bread+0x64>
    80002b02:	873e                	mv	a4,a5
    80002b04:	a021                	j	80002b0c <bread+0x3c>
    80002b06:	68a4                	ld	s1,80(s1)
    80002b08:	02e48663          	beq	s1,a4,80002b34 <bread+0x64>
    80002b0c:	449c                	lw	a5,8(s1)
    80002b0e:	ff279ce3          	bne	a5,s2,80002b06 <bread+0x36>
    80002b12:	44dc                	lw	a5,12(s1)
    80002b14:	ff3799e3          	bne	a5,s3,80002b06 <bread+0x36>
    80002b18:	40bc                	lw	a5,64(s1)
    80002b1a:	2785                	addiw	a5,a5,1
    80002b1c:	c0bc                	sw	a5,64(s1)
    80002b1e:	00015517          	auipc	a0,0x15
    80002b22:	6fa50513          	addi	a0,a0,1786 # 80018218 <bcache>
    80002b26:	974fe0ef          	jal	80000c9a <release>
    80002b2a:	01048513          	addi	a0,s1,16
    80002b2e:	1fa010ef          	jal	80003d28 <acquiresleep>
    80002b32:	a889                	j	80002b84 <bread+0xb4>
    80002b34:	0001e497          	auipc	s1,0x1e
    80002b38:	9944b483          	ld	s1,-1644(s1) # 800204c8 <bcache+0x82b0>
    80002b3c:	0001e797          	auipc	a5,0x1e
    80002b40:	94478793          	addi	a5,a5,-1724 # 80020480 <bcache+0x8268>
    80002b44:	00f48863          	beq	s1,a5,80002b54 <bread+0x84>
    80002b48:	873e                	mv	a4,a5
    80002b4a:	40bc                	lw	a5,64(s1)
    80002b4c:	cb91                	beqz	a5,80002b60 <bread+0x90>
    80002b4e:	64a4                	ld	s1,72(s1)
    80002b50:	fee49de3          	bne	s1,a4,80002b4a <bread+0x7a>
    80002b54:	00005517          	auipc	a0,0x5
    80002b58:	8ec50513          	addi	a0,a0,-1812 # 80007440 <etext+0x440>
    80002b5c:	c47fd0ef          	jal	800007a2 <panic>
    80002b60:	0124a423          	sw	s2,8(s1)
    80002b64:	0134a623          	sw	s3,12(s1)
    80002b68:	0004a023          	sw	zero,0(s1)
    80002b6c:	4785                	li	a5,1
    80002b6e:	c0bc                	sw	a5,64(s1)
    80002b70:	00015517          	auipc	a0,0x15
    80002b74:	6a850513          	addi	a0,a0,1704 # 80018218 <bcache>
    80002b78:	922fe0ef          	jal	80000c9a <release>
    80002b7c:	01048513          	addi	a0,s1,16
    80002b80:	1a8010ef          	jal	80003d28 <acquiresleep>
    80002b84:	409c                	lw	a5,0(s1)
    80002b86:	cb89                	beqz	a5,80002b98 <bread+0xc8>
    80002b88:	8526                	mv	a0,s1
    80002b8a:	70a2                	ld	ra,40(sp)
    80002b8c:	7402                	ld	s0,32(sp)
    80002b8e:	64e2                	ld	s1,24(sp)
    80002b90:	6942                	ld	s2,16(sp)
    80002b92:	69a2                	ld	s3,8(sp)
    80002b94:	6145                	addi	sp,sp,48
    80002b96:	8082                	ret
    80002b98:	4581                	li	a1,0
    80002b9a:	8526                	mv	a0,s1
    80002b9c:	1e5020ef          	jal	80005580 <virtio_disk_rw>
    80002ba0:	4785                	li	a5,1
    80002ba2:	c09c                	sw	a5,0(s1)
    80002ba4:	b7d5                	j	80002b88 <bread+0xb8>

0000000080002ba6 <bwrite>:
    80002ba6:	1101                	addi	sp,sp,-32
    80002ba8:	ec06                	sd	ra,24(sp)
    80002baa:	e822                	sd	s0,16(sp)
    80002bac:	e426                	sd	s1,8(sp)
    80002bae:	1000                	addi	s0,sp,32
    80002bb0:	84aa                	mv	s1,a0
    80002bb2:	0541                	addi	a0,a0,16
    80002bb4:	1f2010ef          	jal	80003da6 <holdingsleep>
    80002bb8:	c911                	beqz	a0,80002bcc <bwrite+0x26>
    80002bba:	4585                	li	a1,1
    80002bbc:	8526                	mv	a0,s1
    80002bbe:	1c3020ef          	jal	80005580 <virtio_disk_rw>
    80002bc2:	60e2                	ld	ra,24(sp)
    80002bc4:	6442                	ld	s0,16(sp)
    80002bc6:	64a2                	ld	s1,8(sp)
    80002bc8:	6105                	addi	sp,sp,32
    80002bca:	8082                	ret
    80002bcc:	00005517          	auipc	a0,0x5
    80002bd0:	88c50513          	addi	a0,a0,-1908 # 80007458 <etext+0x458>
    80002bd4:	bcffd0ef          	jal	800007a2 <panic>

0000000080002bd8 <brelse>:
    80002bd8:	1101                	addi	sp,sp,-32
    80002bda:	ec06                	sd	ra,24(sp)
    80002bdc:	e822                	sd	s0,16(sp)
    80002bde:	e426                	sd	s1,8(sp)
    80002be0:	e04a                	sd	s2,0(sp)
    80002be2:	1000                	addi	s0,sp,32
    80002be4:	84aa                	mv	s1,a0
    80002be6:	01050913          	addi	s2,a0,16
    80002bea:	854a                	mv	a0,s2
    80002bec:	1ba010ef          	jal	80003da6 <holdingsleep>
    80002bf0:	c135                	beqz	a0,80002c54 <brelse+0x7c>
    80002bf2:	854a                	mv	a0,s2
    80002bf4:	17a010ef          	jal	80003d6e <releasesleep>
    80002bf8:	00015517          	auipc	a0,0x15
    80002bfc:	62050513          	addi	a0,a0,1568 # 80018218 <bcache>
    80002c00:	802fe0ef          	jal	80000c02 <acquire>
    80002c04:	40bc                	lw	a5,64(s1)
    80002c06:	37fd                	addiw	a5,a5,-1
    80002c08:	0007871b          	sext.w	a4,a5
    80002c0c:	c0bc                	sw	a5,64(s1)
    80002c0e:	e71d                	bnez	a4,80002c3c <brelse+0x64>
    80002c10:	68b8                	ld	a4,80(s1)
    80002c12:	64bc                	ld	a5,72(s1)
    80002c14:	e73c                	sd	a5,72(a4)
    80002c16:	68b8                	ld	a4,80(s1)
    80002c18:	ebb8                	sd	a4,80(a5)
    80002c1a:	0001d797          	auipc	a5,0x1d
    80002c1e:	5fe78793          	addi	a5,a5,1534 # 80020218 <bcache+0x8000>
    80002c22:	2b87b703          	ld	a4,696(a5)
    80002c26:	e8b8                	sd	a4,80(s1)
    80002c28:	0001e717          	auipc	a4,0x1e
    80002c2c:	85870713          	addi	a4,a4,-1960 # 80020480 <bcache+0x8268>
    80002c30:	e4b8                	sd	a4,72(s1)
    80002c32:	2b87b703          	ld	a4,696(a5)
    80002c36:	e724                	sd	s1,72(a4)
    80002c38:	2a97bc23          	sd	s1,696(a5)
    80002c3c:	00015517          	auipc	a0,0x15
    80002c40:	5dc50513          	addi	a0,a0,1500 # 80018218 <bcache>
    80002c44:	856fe0ef          	jal	80000c9a <release>
    80002c48:	60e2                	ld	ra,24(sp)
    80002c4a:	6442                	ld	s0,16(sp)
    80002c4c:	64a2                	ld	s1,8(sp)
    80002c4e:	6902                	ld	s2,0(sp)
    80002c50:	6105                	addi	sp,sp,32
    80002c52:	8082                	ret
    80002c54:	00005517          	auipc	a0,0x5
    80002c58:	80c50513          	addi	a0,a0,-2036 # 80007460 <etext+0x460>
    80002c5c:	b47fd0ef          	jal	800007a2 <panic>

0000000080002c60 <bpin>:
    80002c60:	1101                	addi	sp,sp,-32
    80002c62:	ec06                	sd	ra,24(sp)
    80002c64:	e822                	sd	s0,16(sp)
    80002c66:	e426                	sd	s1,8(sp)
    80002c68:	1000                	addi	s0,sp,32
    80002c6a:	84aa                	mv	s1,a0
    80002c6c:	00015517          	auipc	a0,0x15
    80002c70:	5ac50513          	addi	a0,a0,1452 # 80018218 <bcache>
    80002c74:	f8ffd0ef          	jal	80000c02 <acquire>
    80002c78:	40bc                	lw	a5,64(s1)
    80002c7a:	2785                	addiw	a5,a5,1
    80002c7c:	c0bc                	sw	a5,64(s1)
    80002c7e:	00015517          	auipc	a0,0x15
    80002c82:	59a50513          	addi	a0,a0,1434 # 80018218 <bcache>
    80002c86:	814fe0ef          	jal	80000c9a <release>
    80002c8a:	60e2                	ld	ra,24(sp)
    80002c8c:	6442                	ld	s0,16(sp)
    80002c8e:	64a2                	ld	s1,8(sp)
    80002c90:	6105                	addi	sp,sp,32
    80002c92:	8082                	ret

0000000080002c94 <bunpin>:
    80002c94:	1101                	addi	sp,sp,-32
    80002c96:	ec06                	sd	ra,24(sp)
    80002c98:	e822                	sd	s0,16(sp)
    80002c9a:	e426                	sd	s1,8(sp)
    80002c9c:	1000                	addi	s0,sp,32
    80002c9e:	84aa                	mv	s1,a0
    80002ca0:	00015517          	auipc	a0,0x15
    80002ca4:	57850513          	addi	a0,a0,1400 # 80018218 <bcache>
    80002ca8:	f5bfd0ef          	jal	80000c02 <acquire>
    80002cac:	40bc                	lw	a5,64(s1)
    80002cae:	37fd                	addiw	a5,a5,-1
    80002cb0:	c0bc                	sw	a5,64(s1)
    80002cb2:	00015517          	auipc	a0,0x15
    80002cb6:	56650513          	addi	a0,a0,1382 # 80018218 <bcache>
    80002cba:	fe1fd0ef          	jal	80000c9a <release>
    80002cbe:	60e2                	ld	ra,24(sp)
    80002cc0:	6442                	ld	s0,16(sp)
    80002cc2:	64a2                	ld	s1,8(sp)
    80002cc4:	6105                	addi	sp,sp,32
    80002cc6:	8082                	ret

0000000080002cc8 <bfree>:
    80002cc8:	1101                	addi	sp,sp,-32
    80002cca:	ec06                	sd	ra,24(sp)
    80002ccc:	e822                	sd	s0,16(sp)
    80002cce:	e426                	sd	s1,8(sp)
    80002cd0:	e04a                	sd	s2,0(sp)
    80002cd2:	1000                	addi	s0,sp,32
    80002cd4:	84ae                	mv	s1,a1
    80002cd6:	00d5d59b          	srliw	a1,a1,0xd
    80002cda:	0001e797          	auipc	a5,0x1e
    80002cde:	c1a7a783          	lw	a5,-998(a5) # 800208f4 <sb+0x1c>
    80002ce2:	9dbd                	addw	a1,a1,a5
    80002ce4:	dedff0ef          	jal	80002ad0 <bread>
    80002ce8:	0074f713          	andi	a4,s1,7
    80002cec:	4785                	li	a5,1
    80002cee:	00e797bb          	sllw	a5,a5,a4
    80002cf2:	14ce                	slli	s1,s1,0x33
    80002cf4:	90d9                	srli	s1,s1,0x36
    80002cf6:	00950733          	add	a4,a0,s1
    80002cfa:	05874703          	lbu	a4,88(a4)
    80002cfe:	00e7f6b3          	and	a3,a5,a4
    80002d02:	c29d                	beqz	a3,80002d28 <bfree+0x60>
    80002d04:	892a                	mv	s2,a0
    80002d06:	94aa                	add	s1,s1,a0
    80002d08:	fff7c793          	not	a5,a5
    80002d0c:	8f7d                	and	a4,a4,a5
    80002d0e:	04e48c23          	sb	a4,88(s1)
    80002d12:	711000ef          	jal	80003c22 <log_write>
    80002d16:	854a                	mv	a0,s2
    80002d18:	ec1ff0ef          	jal	80002bd8 <brelse>
    80002d1c:	60e2                	ld	ra,24(sp)
    80002d1e:	6442                	ld	s0,16(sp)
    80002d20:	64a2                	ld	s1,8(sp)
    80002d22:	6902                	ld	s2,0(sp)
    80002d24:	6105                	addi	sp,sp,32
    80002d26:	8082                	ret
    80002d28:	00004517          	auipc	a0,0x4
    80002d2c:	74050513          	addi	a0,a0,1856 # 80007468 <etext+0x468>
    80002d30:	a73fd0ef          	jal	800007a2 <panic>

0000000080002d34 <balloc>:
    80002d34:	711d                	addi	sp,sp,-96
    80002d36:	ec86                	sd	ra,88(sp)
    80002d38:	e8a2                	sd	s0,80(sp)
    80002d3a:	e4a6                	sd	s1,72(sp)
    80002d3c:	1080                	addi	s0,sp,96
    80002d3e:	0001e797          	auipc	a5,0x1e
    80002d42:	b9e7a783          	lw	a5,-1122(a5) # 800208dc <sb+0x4>
    80002d46:	0e078f63          	beqz	a5,80002e44 <balloc+0x110>
    80002d4a:	e0ca                	sd	s2,64(sp)
    80002d4c:	fc4e                	sd	s3,56(sp)
    80002d4e:	f852                	sd	s4,48(sp)
    80002d50:	f456                	sd	s5,40(sp)
    80002d52:	f05a                	sd	s6,32(sp)
    80002d54:	ec5e                	sd	s7,24(sp)
    80002d56:	e862                	sd	s8,16(sp)
    80002d58:	e466                	sd	s9,8(sp)
    80002d5a:	8baa                	mv	s7,a0
    80002d5c:	4a81                	li	s5,0
    80002d5e:	0001eb17          	auipc	s6,0x1e
    80002d62:	b7ab0b13          	addi	s6,s6,-1158 # 800208d8 <sb>
    80002d66:	4c01                	li	s8,0
    80002d68:	4985                	li	s3,1
    80002d6a:	6a09                	lui	s4,0x2
    80002d6c:	6c89                	lui	s9,0x2
    80002d6e:	a0b5                	j	80002dda <balloc+0xa6>
    80002d70:	97ca                	add	a5,a5,s2
    80002d72:	8e55                	or	a2,a2,a3
    80002d74:	04c78c23          	sb	a2,88(a5)
    80002d78:	854a                	mv	a0,s2
    80002d7a:	6a9000ef          	jal	80003c22 <log_write>
    80002d7e:	854a                	mv	a0,s2
    80002d80:	e59ff0ef          	jal	80002bd8 <brelse>
    80002d84:	85a6                	mv	a1,s1
    80002d86:	855e                	mv	a0,s7
    80002d88:	d49ff0ef          	jal	80002ad0 <bread>
    80002d8c:	892a                	mv	s2,a0
    80002d8e:	40000613          	li	a2,1024
    80002d92:	4581                	li	a1,0
    80002d94:	05850513          	addi	a0,a0,88
    80002d98:	f3ffd0ef          	jal	80000cd6 <memset>
    80002d9c:	854a                	mv	a0,s2
    80002d9e:	685000ef          	jal	80003c22 <log_write>
    80002da2:	854a                	mv	a0,s2
    80002da4:	e35ff0ef          	jal	80002bd8 <brelse>
    80002da8:	6906                	ld	s2,64(sp)
    80002daa:	79e2                	ld	s3,56(sp)
    80002dac:	7a42                	ld	s4,48(sp)
    80002dae:	7aa2                	ld	s5,40(sp)
    80002db0:	7b02                	ld	s6,32(sp)
    80002db2:	6be2                	ld	s7,24(sp)
    80002db4:	6c42                	ld	s8,16(sp)
    80002db6:	6ca2                	ld	s9,8(sp)
    80002db8:	8526                	mv	a0,s1
    80002dba:	60e6                	ld	ra,88(sp)
    80002dbc:	6446                	ld	s0,80(sp)
    80002dbe:	64a6                	ld	s1,72(sp)
    80002dc0:	6125                	addi	sp,sp,96
    80002dc2:	8082                	ret
    80002dc4:	854a                	mv	a0,s2
    80002dc6:	e13ff0ef          	jal	80002bd8 <brelse>
    80002dca:	015c87bb          	addw	a5,s9,s5
    80002dce:	00078a9b          	sext.w	s5,a5
    80002dd2:	004b2703          	lw	a4,4(s6)
    80002dd6:	04eaff63          	bgeu	s5,a4,80002e34 <balloc+0x100>
    80002dda:	41fad79b          	sraiw	a5,s5,0x1f
    80002dde:	0137d79b          	srliw	a5,a5,0x13
    80002de2:	015787bb          	addw	a5,a5,s5
    80002de6:	40d7d79b          	sraiw	a5,a5,0xd
    80002dea:	01cb2583          	lw	a1,28(s6)
    80002dee:	9dbd                	addw	a1,a1,a5
    80002df0:	855e                	mv	a0,s7
    80002df2:	cdfff0ef          	jal	80002ad0 <bread>
    80002df6:	892a                	mv	s2,a0
    80002df8:	004b2503          	lw	a0,4(s6)
    80002dfc:	000a849b          	sext.w	s1,s5
    80002e00:	8762                	mv	a4,s8
    80002e02:	fca4f1e3          	bgeu	s1,a0,80002dc4 <balloc+0x90>
    80002e06:	00777693          	andi	a3,a4,7
    80002e0a:	00d996bb          	sllw	a3,s3,a3
    80002e0e:	41f7579b          	sraiw	a5,a4,0x1f
    80002e12:	01d7d79b          	srliw	a5,a5,0x1d
    80002e16:	9fb9                	addw	a5,a5,a4
    80002e18:	4037d79b          	sraiw	a5,a5,0x3
    80002e1c:	00f90633          	add	a2,s2,a5
    80002e20:	05864603          	lbu	a2,88(a2)
    80002e24:	00c6f5b3          	and	a1,a3,a2
    80002e28:	d5a1                	beqz	a1,80002d70 <balloc+0x3c>
    80002e2a:	2705                	addiw	a4,a4,1
    80002e2c:	2485                	addiw	s1,s1,1
    80002e2e:	fd471ae3          	bne	a4,s4,80002e02 <balloc+0xce>
    80002e32:	bf49                	j	80002dc4 <balloc+0x90>
    80002e34:	6906                	ld	s2,64(sp)
    80002e36:	79e2                	ld	s3,56(sp)
    80002e38:	7a42                	ld	s4,48(sp)
    80002e3a:	7aa2                	ld	s5,40(sp)
    80002e3c:	7b02                	ld	s6,32(sp)
    80002e3e:	6be2                	ld	s7,24(sp)
    80002e40:	6c42                	ld	s8,16(sp)
    80002e42:	6ca2                	ld	s9,8(sp)
    80002e44:	00004517          	auipc	a0,0x4
    80002e48:	63c50513          	addi	a0,a0,1596 # 80007480 <etext+0x480>
    80002e4c:	e84fd0ef          	jal	800004d0 <printf>
    80002e50:	4481                	li	s1,0
    80002e52:	b79d                	j	80002db8 <balloc+0x84>

0000000080002e54 <bmap>:
    80002e54:	7179                	addi	sp,sp,-48
    80002e56:	f406                	sd	ra,40(sp)
    80002e58:	f022                	sd	s0,32(sp)
    80002e5a:	ec26                	sd	s1,24(sp)
    80002e5c:	e84a                	sd	s2,16(sp)
    80002e5e:	e44e                	sd	s3,8(sp)
    80002e60:	1800                	addi	s0,sp,48
    80002e62:	89aa                	mv	s3,a0
    80002e64:	47ad                	li	a5,11
    80002e66:	02b7e663          	bltu	a5,a1,80002e92 <bmap+0x3e>
    80002e6a:	02059793          	slli	a5,a1,0x20
    80002e6e:	01e7d593          	srli	a1,a5,0x1e
    80002e72:	00b504b3          	add	s1,a0,a1
    80002e76:	0504a903          	lw	s2,80(s1)
    80002e7a:	06091a63          	bnez	s2,80002eee <bmap+0x9a>
    80002e7e:	4108                	lw	a0,0(a0)
    80002e80:	eb5ff0ef          	jal	80002d34 <balloc>
    80002e84:	0005091b          	sext.w	s2,a0
    80002e88:	06090363          	beqz	s2,80002eee <bmap+0x9a>
    80002e8c:	0524a823          	sw	s2,80(s1)
    80002e90:	a8b9                	j	80002eee <bmap+0x9a>
    80002e92:	ff45849b          	addiw	s1,a1,-12
    80002e96:	0004871b          	sext.w	a4,s1
    80002e9a:	0ff00793          	li	a5,255
    80002e9e:	06e7ee63          	bltu	a5,a4,80002f1a <bmap+0xc6>
    80002ea2:	08052903          	lw	s2,128(a0)
    80002ea6:	00091d63          	bnez	s2,80002ec0 <bmap+0x6c>
    80002eaa:	4108                	lw	a0,0(a0)
    80002eac:	e89ff0ef          	jal	80002d34 <balloc>
    80002eb0:	0005091b          	sext.w	s2,a0
    80002eb4:	02090d63          	beqz	s2,80002eee <bmap+0x9a>
    80002eb8:	e052                	sd	s4,0(sp)
    80002eba:	0929a023          	sw	s2,128(s3)
    80002ebe:	a011                	j	80002ec2 <bmap+0x6e>
    80002ec0:	e052                	sd	s4,0(sp)
    80002ec2:	85ca                	mv	a1,s2
    80002ec4:	0009a503          	lw	a0,0(s3)
    80002ec8:	c09ff0ef          	jal	80002ad0 <bread>
    80002ecc:	8a2a                	mv	s4,a0
    80002ece:	05850793          	addi	a5,a0,88
    80002ed2:	02049713          	slli	a4,s1,0x20
    80002ed6:	01e75593          	srli	a1,a4,0x1e
    80002eda:	00b784b3          	add	s1,a5,a1
    80002ede:	0004a903          	lw	s2,0(s1)
    80002ee2:	00090e63          	beqz	s2,80002efe <bmap+0xaa>
    80002ee6:	8552                	mv	a0,s4
    80002ee8:	cf1ff0ef          	jal	80002bd8 <brelse>
    80002eec:	6a02                	ld	s4,0(sp)
    80002eee:	854a                	mv	a0,s2
    80002ef0:	70a2                	ld	ra,40(sp)
    80002ef2:	7402                	ld	s0,32(sp)
    80002ef4:	64e2                	ld	s1,24(sp)
    80002ef6:	6942                	ld	s2,16(sp)
    80002ef8:	69a2                	ld	s3,8(sp)
    80002efa:	6145                	addi	sp,sp,48
    80002efc:	8082                	ret
    80002efe:	0009a503          	lw	a0,0(s3)
    80002f02:	e33ff0ef          	jal	80002d34 <balloc>
    80002f06:	0005091b          	sext.w	s2,a0
    80002f0a:	fc090ee3          	beqz	s2,80002ee6 <bmap+0x92>
    80002f0e:	0124a023          	sw	s2,0(s1)
    80002f12:	8552                	mv	a0,s4
    80002f14:	50f000ef          	jal	80003c22 <log_write>
    80002f18:	b7f9                	j	80002ee6 <bmap+0x92>
    80002f1a:	e052                	sd	s4,0(sp)
    80002f1c:	00004517          	auipc	a0,0x4
    80002f20:	57c50513          	addi	a0,a0,1404 # 80007498 <etext+0x498>
    80002f24:	87ffd0ef          	jal	800007a2 <panic>

0000000080002f28 <iget>:
    80002f28:	7179                	addi	sp,sp,-48
    80002f2a:	f406                	sd	ra,40(sp)
    80002f2c:	f022                	sd	s0,32(sp)
    80002f2e:	ec26                	sd	s1,24(sp)
    80002f30:	e84a                	sd	s2,16(sp)
    80002f32:	e44e                	sd	s3,8(sp)
    80002f34:	e052                	sd	s4,0(sp)
    80002f36:	1800                	addi	s0,sp,48
    80002f38:	89aa                	mv	s3,a0
    80002f3a:	8a2e                	mv	s4,a1
    80002f3c:	0001e517          	auipc	a0,0x1e
    80002f40:	9bc50513          	addi	a0,a0,-1604 # 800208f8 <itable>
    80002f44:	cbffd0ef          	jal	80000c02 <acquire>
    80002f48:	4901                	li	s2,0
    80002f4a:	0001e497          	auipc	s1,0x1e
    80002f4e:	9c648493          	addi	s1,s1,-1594 # 80020910 <itable+0x18>
    80002f52:	0001f697          	auipc	a3,0x1f
    80002f56:	44e68693          	addi	a3,a3,1102 # 800223a0 <log>
    80002f5a:	a039                	j	80002f68 <iget+0x40>
    80002f5c:	02090963          	beqz	s2,80002f8e <iget+0x66>
    80002f60:	08848493          	addi	s1,s1,136
    80002f64:	02d48863          	beq	s1,a3,80002f94 <iget+0x6c>
    80002f68:	449c                	lw	a5,8(s1)
    80002f6a:	fef059e3          	blez	a5,80002f5c <iget+0x34>
    80002f6e:	4098                	lw	a4,0(s1)
    80002f70:	ff3716e3          	bne	a4,s3,80002f5c <iget+0x34>
    80002f74:	40d8                	lw	a4,4(s1)
    80002f76:	ff4713e3          	bne	a4,s4,80002f5c <iget+0x34>
    80002f7a:	2785                	addiw	a5,a5,1
    80002f7c:	c49c                	sw	a5,8(s1)
    80002f7e:	0001e517          	auipc	a0,0x1e
    80002f82:	97a50513          	addi	a0,a0,-1670 # 800208f8 <itable>
    80002f86:	d15fd0ef          	jal	80000c9a <release>
    80002f8a:	8926                	mv	s2,s1
    80002f8c:	a02d                	j	80002fb6 <iget+0x8e>
    80002f8e:	fbe9                	bnez	a5,80002f60 <iget+0x38>
    80002f90:	8926                	mv	s2,s1
    80002f92:	b7f9                	j	80002f60 <iget+0x38>
    80002f94:	02090a63          	beqz	s2,80002fc8 <iget+0xa0>
    80002f98:	01392023          	sw	s3,0(s2)
    80002f9c:	01492223          	sw	s4,4(s2)
    80002fa0:	4785                	li	a5,1
    80002fa2:	00f92423          	sw	a5,8(s2)
    80002fa6:	04092023          	sw	zero,64(s2)
    80002faa:	0001e517          	auipc	a0,0x1e
    80002fae:	94e50513          	addi	a0,a0,-1714 # 800208f8 <itable>
    80002fb2:	ce9fd0ef          	jal	80000c9a <release>
    80002fb6:	854a                	mv	a0,s2
    80002fb8:	70a2                	ld	ra,40(sp)
    80002fba:	7402                	ld	s0,32(sp)
    80002fbc:	64e2                	ld	s1,24(sp)
    80002fbe:	6942                	ld	s2,16(sp)
    80002fc0:	69a2                	ld	s3,8(sp)
    80002fc2:	6a02                	ld	s4,0(sp)
    80002fc4:	6145                	addi	sp,sp,48
    80002fc6:	8082                	ret
    80002fc8:	00004517          	auipc	a0,0x4
    80002fcc:	4e850513          	addi	a0,a0,1256 # 800074b0 <etext+0x4b0>
    80002fd0:	fd2fd0ef          	jal	800007a2 <panic>

0000000080002fd4 <fsinit>:
    80002fd4:	7179                	addi	sp,sp,-48
    80002fd6:	f406                	sd	ra,40(sp)
    80002fd8:	f022                	sd	s0,32(sp)
    80002fda:	ec26                	sd	s1,24(sp)
    80002fdc:	e84a                	sd	s2,16(sp)
    80002fde:	e44e                	sd	s3,8(sp)
    80002fe0:	1800                	addi	s0,sp,48
    80002fe2:	892a                	mv	s2,a0
    80002fe4:	4585                	li	a1,1
    80002fe6:	aebff0ef          	jal	80002ad0 <bread>
    80002fea:	84aa                	mv	s1,a0
    80002fec:	0001e997          	auipc	s3,0x1e
    80002ff0:	8ec98993          	addi	s3,s3,-1812 # 800208d8 <sb>
    80002ff4:	02000613          	li	a2,32
    80002ff8:	05850593          	addi	a1,a0,88
    80002ffc:	854e                	mv	a0,s3
    80002ffe:	d35fd0ef          	jal	80000d32 <memmove>
    80003002:	8526                	mv	a0,s1
    80003004:	bd5ff0ef          	jal	80002bd8 <brelse>
    80003008:	0009a703          	lw	a4,0(s3)
    8000300c:	102037b7          	lui	a5,0x10203
    80003010:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003014:	02f71063          	bne	a4,a5,80003034 <fsinit+0x60>
    80003018:	0001e597          	auipc	a1,0x1e
    8000301c:	8c058593          	addi	a1,a1,-1856 # 800208d8 <sb>
    80003020:	854a                	mv	a0,s2
    80003022:	1f9000ef          	jal	80003a1a <initlog>
    80003026:	70a2                	ld	ra,40(sp)
    80003028:	7402                	ld	s0,32(sp)
    8000302a:	64e2                	ld	s1,24(sp)
    8000302c:	6942                	ld	s2,16(sp)
    8000302e:	69a2                	ld	s3,8(sp)
    80003030:	6145                	addi	sp,sp,48
    80003032:	8082                	ret
    80003034:	00004517          	auipc	a0,0x4
    80003038:	48c50513          	addi	a0,a0,1164 # 800074c0 <etext+0x4c0>
    8000303c:	f66fd0ef          	jal	800007a2 <panic>

0000000080003040 <iinit>:
    80003040:	7179                	addi	sp,sp,-48
    80003042:	f406                	sd	ra,40(sp)
    80003044:	f022                	sd	s0,32(sp)
    80003046:	ec26                	sd	s1,24(sp)
    80003048:	e84a                	sd	s2,16(sp)
    8000304a:	e44e                	sd	s3,8(sp)
    8000304c:	1800                	addi	s0,sp,48
    8000304e:	00004597          	auipc	a1,0x4
    80003052:	48a58593          	addi	a1,a1,1162 # 800074d8 <etext+0x4d8>
    80003056:	0001e517          	auipc	a0,0x1e
    8000305a:	8a250513          	addi	a0,a0,-1886 # 800208f8 <itable>
    8000305e:	b25fd0ef          	jal	80000b82 <initlock>
    80003062:	0001e497          	auipc	s1,0x1e
    80003066:	8be48493          	addi	s1,s1,-1858 # 80020920 <itable+0x28>
    8000306a:	0001f997          	auipc	s3,0x1f
    8000306e:	34698993          	addi	s3,s3,838 # 800223b0 <log+0x10>
    80003072:	00004917          	auipc	s2,0x4
    80003076:	46e90913          	addi	s2,s2,1134 # 800074e0 <etext+0x4e0>
    8000307a:	85ca                	mv	a1,s2
    8000307c:	8526                	mv	a0,s1
    8000307e:	475000ef          	jal	80003cf2 <initsleeplock>
    80003082:	08848493          	addi	s1,s1,136
    80003086:	ff349ae3          	bne	s1,s3,8000307a <iinit+0x3a>
    8000308a:	70a2                	ld	ra,40(sp)
    8000308c:	7402                	ld	s0,32(sp)
    8000308e:	64e2                	ld	s1,24(sp)
    80003090:	6942                	ld	s2,16(sp)
    80003092:	69a2                	ld	s3,8(sp)
    80003094:	6145                	addi	sp,sp,48
    80003096:	8082                	ret

0000000080003098 <ialloc>:
    80003098:	7139                	addi	sp,sp,-64
    8000309a:	fc06                	sd	ra,56(sp)
    8000309c:	f822                	sd	s0,48(sp)
    8000309e:	0080                	addi	s0,sp,64
    800030a0:	0001e717          	auipc	a4,0x1e
    800030a4:	84472703          	lw	a4,-1980(a4) # 800208e4 <sb+0xc>
    800030a8:	4785                	li	a5,1
    800030aa:	06e7f063          	bgeu	a5,a4,8000310a <ialloc+0x72>
    800030ae:	f426                	sd	s1,40(sp)
    800030b0:	f04a                	sd	s2,32(sp)
    800030b2:	ec4e                	sd	s3,24(sp)
    800030b4:	e852                	sd	s4,16(sp)
    800030b6:	e456                	sd	s5,8(sp)
    800030b8:	e05a                	sd	s6,0(sp)
    800030ba:	8aaa                	mv	s5,a0
    800030bc:	8b2e                	mv	s6,a1
    800030be:	4905                	li	s2,1
    800030c0:	0001ea17          	auipc	s4,0x1e
    800030c4:	818a0a13          	addi	s4,s4,-2024 # 800208d8 <sb>
    800030c8:	00495593          	srli	a1,s2,0x4
    800030cc:	018a2783          	lw	a5,24(s4)
    800030d0:	9dbd                	addw	a1,a1,a5
    800030d2:	8556                	mv	a0,s5
    800030d4:	9fdff0ef          	jal	80002ad0 <bread>
    800030d8:	84aa                	mv	s1,a0
    800030da:	05850993          	addi	s3,a0,88
    800030de:	00f97793          	andi	a5,s2,15
    800030e2:	079a                	slli	a5,a5,0x6
    800030e4:	99be                	add	s3,s3,a5
    800030e6:	00099783          	lh	a5,0(s3)
    800030ea:	cb9d                	beqz	a5,80003120 <ialloc+0x88>
    800030ec:	aedff0ef          	jal	80002bd8 <brelse>
    800030f0:	0905                	addi	s2,s2,1
    800030f2:	00ca2703          	lw	a4,12(s4)
    800030f6:	0009079b          	sext.w	a5,s2
    800030fa:	fce7e7e3          	bltu	a5,a4,800030c8 <ialloc+0x30>
    800030fe:	74a2                	ld	s1,40(sp)
    80003100:	7902                	ld	s2,32(sp)
    80003102:	69e2                	ld	s3,24(sp)
    80003104:	6a42                	ld	s4,16(sp)
    80003106:	6aa2                	ld	s5,8(sp)
    80003108:	6b02                	ld	s6,0(sp)
    8000310a:	00004517          	auipc	a0,0x4
    8000310e:	3de50513          	addi	a0,a0,990 # 800074e8 <etext+0x4e8>
    80003112:	bbefd0ef          	jal	800004d0 <printf>
    80003116:	4501                	li	a0,0
    80003118:	70e2                	ld	ra,56(sp)
    8000311a:	7442                	ld	s0,48(sp)
    8000311c:	6121                	addi	sp,sp,64
    8000311e:	8082                	ret
    80003120:	04000613          	li	a2,64
    80003124:	4581                	li	a1,0
    80003126:	854e                	mv	a0,s3
    80003128:	baffd0ef          	jal	80000cd6 <memset>
    8000312c:	01699023          	sh	s6,0(s3)
    80003130:	8526                	mv	a0,s1
    80003132:	2f1000ef          	jal	80003c22 <log_write>
    80003136:	8526                	mv	a0,s1
    80003138:	aa1ff0ef          	jal	80002bd8 <brelse>
    8000313c:	0009059b          	sext.w	a1,s2
    80003140:	8556                	mv	a0,s5
    80003142:	de7ff0ef          	jal	80002f28 <iget>
    80003146:	74a2                	ld	s1,40(sp)
    80003148:	7902                	ld	s2,32(sp)
    8000314a:	69e2                	ld	s3,24(sp)
    8000314c:	6a42                	ld	s4,16(sp)
    8000314e:	6aa2                	ld	s5,8(sp)
    80003150:	6b02                	ld	s6,0(sp)
    80003152:	b7d9                	j	80003118 <ialloc+0x80>

0000000080003154 <iupdate>:
    80003154:	1101                	addi	sp,sp,-32
    80003156:	ec06                	sd	ra,24(sp)
    80003158:	e822                	sd	s0,16(sp)
    8000315a:	e426                	sd	s1,8(sp)
    8000315c:	e04a                	sd	s2,0(sp)
    8000315e:	1000                	addi	s0,sp,32
    80003160:	84aa                	mv	s1,a0
    80003162:	415c                	lw	a5,4(a0)
    80003164:	0047d79b          	srliw	a5,a5,0x4
    80003168:	0001d597          	auipc	a1,0x1d
    8000316c:	7885a583          	lw	a1,1928(a1) # 800208f0 <sb+0x18>
    80003170:	9dbd                	addw	a1,a1,a5
    80003172:	4108                	lw	a0,0(a0)
    80003174:	95dff0ef          	jal	80002ad0 <bread>
    80003178:	892a                	mv	s2,a0
    8000317a:	05850793          	addi	a5,a0,88
    8000317e:	40d8                	lw	a4,4(s1)
    80003180:	8b3d                	andi	a4,a4,15
    80003182:	071a                	slli	a4,a4,0x6
    80003184:	97ba                	add	a5,a5,a4
    80003186:	04449703          	lh	a4,68(s1)
    8000318a:	00e79023          	sh	a4,0(a5)
    8000318e:	04649703          	lh	a4,70(s1)
    80003192:	00e79123          	sh	a4,2(a5)
    80003196:	04849703          	lh	a4,72(s1)
    8000319a:	00e79223          	sh	a4,4(a5)
    8000319e:	04a49703          	lh	a4,74(s1)
    800031a2:	00e79323          	sh	a4,6(a5)
    800031a6:	44f8                	lw	a4,76(s1)
    800031a8:	c798                	sw	a4,8(a5)
    800031aa:	03400613          	li	a2,52
    800031ae:	05048593          	addi	a1,s1,80
    800031b2:	00c78513          	addi	a0,a5,12
    800031b6:	b7dfd0ef          	jal	80000d32 <memmove>
    800031ba:	854a                	mv	a0,s2
    800031bc:	267000ef          	jal	80003c22 <log_write>
    800031c0:	854a                	mv	a0,s2
    800031c2:	a17ff0ef          	jal	80002bd8 <brelse>
    800031c6:	60e2                	ld	ra,24(sp)
    800031c8:	6442                	ld	s0,16(sp)
    800031ca:	64a2                	ld	s1,8(sp)
    800031cc:	6902                	ld	s2,0(sp)
    800031ce:	6105                	addi	sp,sp,32
    800031d0:	8082                	ret

00000000800031d2 <idup>:
    800031d2:	1101                	addi	sp,sp,-32
    800031d4:	ec06                	sd	ra,24(sp)
    800031d6:	e822                	sd	s0,16(sp)
    800031d8:	e426                	sd	s1,8(sp)
    800031da:	1000                	addi	s0,sp,32
    800031dc:	84aa                	mv	s1,a0
    800031de:	0001d517          	auipc	a0,0x1d
    800031e2:	71a50513          	addi	a0,a0,1818 # 800208f8 <itable>
    800031e6:	a1dfd0ef          	jal	80000c02 <acquire>
    800031ea:	449c                	lw	a5,8(s1)
    800031ec:	2785                	addiw	a5,a5,1
    800031ee:	c49c                	sw	a5,8(s1)
    800031f0:	0001d517          	auipc	a0,0x1d
    800031f4:	70850513          	addi	a0,a0,1800 # 800208f8 <itable>
    800031f8:	aa3fd0ef          	jal	80000c9a <release>
    800031fc:	8526                	mv	a0,s1
    800031fe:	60e2                	ld	ra,24(sp)
    80003200:	6442                	ld	s0,16(sp)
    80003202:	64a2                	ld	s1,8(sp)
    80003204:	6105                	addi	sp,sp,32
    80003206:	8082                	ret

0000000080003208 <ilock>:
    80003208:	1101                	addi	sp,sp,-32
    8000320a:	ec06                	sd	ra,24(sp)
    8000320c:	e822                	sd	s0,16(sp)
    8000320e:	e426                	sd	s1,8(sp)
    80003210:	1000                	addi	s0,sp,32
    80003212:	cd19                	beqz	a0,80003230 <ilock+0x28>
    80003214:	84aa                	mv	s1,a0
    80003216:	451c                	lw	a5,8(a0)
    80003218:	00f05c63          	blez	a5,80003230 <ilock+0x28>
    8000321c:	0541                	addi	a0,a0,16
    8000321e:	30b000ef          	jal	80003d28 <acquiresleep>
    80003222:	40bc                	lw	a5,64(s1)
    80003224:	cf89                	beqz	a5,8000323e <ilock+0x36>
    80003226:	60e2                	ld	ra,24(sp)
    80003228:	6442                	ld	s0,16(sp)
    8000322a:	64a2                	ld	s1,8(sp)
    8000322c:	6105                	addi	sp,sp,32
    8000322e:	8082                	ret
    80003230:	e04a                	sd	s2,0(sp)
    80003232:	00004517          	auipc	a0,0x4
    80003236:	2ce50513          	addi	a0,a0,718 # 80007500 <etext+0x500>
    8000323a:	d68fd0ef          	jal	800007a2 <panic>
    8000323e:	e04a                	sd	s2,0(sp)
    80003240:	40dc                	lw	a5,4(s1)
    80003242:	0047d79b          	srliw	a5,a5,0x4
    80003246:	0001d597          	auipc	a1,0x1d
    8000324a:	6aa5a583          	lw	a1,1706(a1) # 800208f0 <sb+0x18>
    8000324e:	9dbd                	addw	a1,a1,a5
    80003250:	4088                	lw	a0,0(s1)
    80003252:	87fff0ef          	jal	80002ad0 <bread>
    80003256:	892a                	mv	s2,a0
    80003258:	05850593          	addi	a1,a0,88
    8000325c:	40dc                	lw	a5,4(s1)
    8000325e:	8bbd                	andi	a5,a5,15
    80003260:	079a                	slli	a5,a5,0x6
    80003262:	95be                	add	a1,a1,a5
    80003264:	00059783          	lh	a5,0(a1)
    80003268:	04f49223          	sh	a5,68(s1)
    8000326c:	00259783          	lh	a5,2(a1)
    80003270:	04f49323          	sh	a5,70(s1)
    80003274:	00459783          	lh	a5,4(a1)
    80003278:	04f49423          	sh	a5,72(s1)
    8000327c:	00659783          	lh	a5,6(a1)
    80003280:	04f49523          	sh	a5,74(s1)
    80003284:	459c                	lw	a5,8(a1)
    80003286:	c4fc                	sw	a5,76(s1)
    80003288:	03400613          	li	a2,52
    8000328c:	05b1                	addi	a1,a1,12
    8000328e:	05048513          	addi	a0,s1,80
    80003292:	aa1fd0ef          	jal	80000d32 <memmove>
    80003296:	854a                	mv	a0,s2
    80003298:	941ff0ef          	jal	80002bd8 <brelse>
    8000329c:	4785                	li	a5,1
    8000329e:	c0bc                	sw	a5,64(s1)
    800032a0:	04449783          	lh	a5,68(s1)
    800032a4:	c399                	beqz	a5,800032aa <ilock+0xa2>
    800032a6:	6902                	ld	s2,0(sp)
    800032a8:	bfbd                	j	80003226 <ilock+0x1e>
    800032aa:	00004517          	auipc	a0,0x4
    800032ae:	25e50513          	addi	a0,a0,606 # 80007508 <etext+0x508>
    800032b2:	cf0fd0ef          	jal	800007a2 <panic>

00000000800032b6 <iunlock>:
    800032b6:	1101                	addi	sp,sp,-32
    800032b8:	ec06                	sd	ra,24(sp)
    800032ba:	e822                	sd	s0,16(sp)
    800032bc:	e426                	sd	s1,8(sp)
    800032be:	e04a                	sd	s2,0(sp)
    800032c0:	1000                	addi	s0,sp,32
    800032c2:	c505                	beqz	a0,800032ea <iunlock+0x34>
    800032c4:	84aa                	mv	s1,a0
    800032c6:	01050913          	addi	s2,a0,16
    800032ca:	854a                	mv	a0,s2
    800032cc:	2db000ef          	jal	80003da6 <holdingsleep>
    800032d0:	cd09                	beqz	a0,800032ea <iunlock+0x34>
    800032d2:	449c                	lw	a5,8(s1)
    800032d4:	00f05b63          	blez	a5,800032ea <iunlock+0x34>
    800032d8:	854a                	mv	a0,s2
    800032da:	295000ef          	jal	80003d6e <releasesleep>
    800032de:	60e2                	ld	ra,24(sp)
    800032e0:	6442                	ld	s0,16(sp)
    800032e2:	64a2                	ld	s1,8(sp)
    800032e4:	6902                	ld	s2,0(sp)
    800032e6:	6105                	addi	sp,sp,32
    800032e8:	8082                	ret
    800032ea:	00004517          	auipc	a0,0x4
    800032ee:	22e50513          	addi	a0,a0,558 # 80007518 <etext+0x518>
    800032f2:	cb0fd0ef          	jal	800007a2 <panic>

00000000800032f6 <itrunc>:
    800032f6:	7179                	addi	sp,sp,-48
    800032f8:	f406                	sd	ra,40(sp)
    800032fa:	f022                	sd	s0,32(sp)
    800032fc:	ec26                	sd	s1,24(sp)
    800032fe:	e84a                	sd	s2,16(sp)
    80003300:	e44e                	sd	s3,8(sp)
    80003302:	1800                	addi	s0,sp,48
    80003304:	89aa                	mv	s3,a0
    80003306:	05050493          	addi	s1,a0,80
    8000330a:	08050913          	addi	s2,a0,128
    8000330e:	a021                	j	80003316 <itrunc+0x20>
    80003310:	0491                	addi	s1,s1,4
    80003312:	01248b63          	beq	s1,s2,80003328 <itrunc+0x32>
    80003316:	408c                	lw	a1,0(s1)
    80003318:	dde5                	beqz	a1,80003310 <itrunc+0x1a>
    8000331a:	0009a503          	lw	a0,0(s3)
    8000331e:	9abff0ef          	jal	80002cc8 <bfree>
    80003322:	0004a023          	sw	zero,0(s1)
    80003326:	b7ed                	j	80003310 <itrunc+0x1a>
    80003328:	0809a583          	lw	a1,128(s3)
    8000332c:	ed89                	bnez	a1,80003346 <itrunc+0x50>
    8000332e:	0409a623          	sw	zero,76(s3)
    80003332:	854e                	mv	a0,s3
    80003334:	e21ff0ef          	jal	80003154 <iupdate>
    80003338:	70a2                	ld	ra,40(sp)
    8000333a:	7402                	ld	s0,32(sp)
    8000333c:	64e2                	ld	s1,24(sp)
    8000333e:	6942                	ld	s2,16(sp)
    80003340:	69a2                	ld	s3,8(sp)
    80003342:	6145                	addi	sp,sp,48
    80003344:	8082                	ret
    80003346:	e052                	sd	s4,0(sp)
    80003348:	0009a503          	lw	a0,0(s3)
    8000334c:	f84ff0ef          	jal	80002ad0 <bread>
    80003350:	8a2a                	mv	s4,a0
    80003352:	05850493          	addi	s1,a0,88
    80003356:	45850913          	addi	s2,a0,1112
    8000335a:	a021                	j	80003362 <itrunc+0x6c>
    8000335c:	0491                	addi	s1,s1,4
    8000335e:	01248963          	beq	s1,s2,80003370 <itrunc+0x7a>
    80003362:	408c                	lw	a1,0(s1)
    80003364:	dde5                	beqz	a1,8000335c <itrunc+0x66>
    80003366:	0009a503          	lw	a0,0(s3)
    8000336a:	95fff0ef          	jal	80002cc8 <bfree>
    8000336e:	b7fd                	j	8000335c <itrunc+0x66>
    80003370:	8552                	mv	a0,s4
    80003372:	867ff0ef          	jal	80002bd8 <brelse>
    80003376:	0809a583          	lw	a1,128(s3)
    8000337a:	0009a503          	lw	a0,0(s3)
    8000337e:	94bff0ef          	jal	80002cc8 <bfree>
    80003382:	0809a023          	sw	zero,128(s3)
    80003386:	6a02                	ld	s4,0(sp)
    80003388:	b75d                	j	8000332e <itrunc+0x38>

000000008000338a <iput>:
    8000338a:	1101                	addi	sp,sp,-32
    8000338c:	ec06                	sd	ra,24(sp)
    8000338e:	e822                	sd	s0,16(sp)
    80003390:	e426                	sd	s1,8(sp)
    80003392:	1000                	addi	s0,sp,32
    80003394:	84aa                	mv	s1,a0
    80003396:	0001d517          	auipc	a0,0x1d
    8000339a:	56250513          	addi	a0,a0,1378 # 800208f8 <itable>
    8000339e:	865fd0ef          	jal	80000c02 <acquire>
    800033a2:	4498                	lw	a4,8(s1)
    800033a4:	4785                	li	a5,1
    800033a6:	02f70063          	beq	a4,a5,800033c6 <iput+0x3c>
    800033aa:	449c                	lw	a5,8(s1)
    800033ac:	37fd                	addiw	a5,a5,-1
    800033ae:	c49c                	sw	a5,8(s1)
    800033b0:	0001d517          	auipc	a0,0x1d
    800033b4:	54850513          	addi	a0,a0,1352 # 800208f8 <itable>
    800033b8:	8e3fd0ef          	jal	80000c9a <release>
    800033bc:	60e2                	ld	ra,24(sp)
    800033be:	6442                	ld	s0,16(sp)
    800033c0:	64a2                	ld	s1,8(sp)
    800033c2:	6105                	addi	sp,sp,32
    800033c4:	8082                	ret
    800033c6:	40bc                	lw	a5,64(s1)
    800033c8:	d3ed                	beqz	a5,800033aa <iput+0x20>
    800033ca:	04a49783          	lh	a5,74(s1)
    800033ce:	fff1                	bnez	a5,800033aa <iput+0x20>
    800033d0:	e04a                	sd	s2,0(sp)
    800033d2:	01048913          	addi	s2,s1,16
    800033d6:	854a                	mv	a0,s2
    800033d8:	151000ef          	jal	80003d28 <acquiresleep>
    800033dc:	0001d517          	auipc	a0,0x1d
    800033e0:	51c50513          	addi	a0,a0,1308 # 800208f8 <itable>
    800033e4:	8b7fd0ef          	jal	80000c9a <release>
    800033e8:	8526                	mv	a0,s1
    800033ea:	f0dff0ef          	jal	800032f6 <itrunc>
    800033ee:	04049223          	sh	zero,68(s1)
    800033f2:	8526                	mv	a0,s1
    800033f4:	d61ff0ef          	jal	80003154 <iupdate>
    800033f8:	0404a023          	sw	zero,64(s1)
    800033fc:	854a                	mv	a0,s2
    800033fe:	171000ef          	jal	80003d6e <releasesleep>
    80003402:	0001d517          	auipc	a0,0x1d
    80003406:	4f650513          	addi	a0,a0,1270 # 800208f8 <itable>
    8000340a:	ff8fd0ef          	jal	80000c02 <acquire>
    8000340e:	6902                	ld	s2,0(sp)
    80003410:	bf69                	j	800033aa <iput+0x20>

0000000080003412 <iunlockput>:
    80003412:	1101                	addi	sp,sp,-32
    80003414:	ec06                	sd	ra,24(sp)
    80003416:	e822                	sd	s0,16(sp)
    80003418:	e426                	sd	s1,8(sp)
    8000341a:	1000                	addi	s0,sp,32
    8000341c:	84aa                	mv	s1,a0
    8000341e:	e99ff0ef          	jal	800032b6 <iunlock>
    80003422:	8526                	mv	a0,s1
    80003424:	f67ff0ef          	jal	8000338a <iput>
    80003428:	60e2                	ld	ra,24(sp)
    8000342a:	6442                	ld	s0,16(sp)
    8000342c:	64a2                	ld	s1,8(sp)
    8000342e:	6105                	addi	sp,sp,32
    80003430:	8082                	ret

0000000080003432 <stati>:
    80003432:	1141                	addi	sp,sp,-16
    80003434:	e422                	sd	s0,8(sp)
    80003436:	0800                	addi	s0,sp,16
    80003438:	411c                	lw	a5,0(a0)
    8000343a:	c19c                	sw	a5,0(a1)
    8000343c:	415c                	lw	a5,4(a0)
    8000343e:	c1dc                	sw	a5,4(a1)
    80003440:	04451783          	lh	a5,68(a0)
    80003444:	00f59423          	sh	a5,8(a1)
    80003448:	04a51783          	lh	a5,74(a0)
    8000344c:	00f59523          	sh	a5,10(a1)
    80003450:	04c56783          	lwu	a5,76(a0)
    80003454:	e99c                	sd	a5,16(a1)
    80003456:	6422                	ld	s0,8(sp)
    80003458:	0141                	addi	sp,sp,16
    8000345a:	8082                	ret

000000008000345c <readi>:
    8000345c:	457c                	lw	a5,76(a0)
    8000345e:	0ed7eb63          	bltu	a5,a3,80003554 <readi+0xf8>
    80003462:	7159                	addi	sp,sp,-112
    80003464:	f486                	sd	ra,104(sp)
    80003466:	f0a2                	sd	s0,96(sp)
    80003468:	eca6                	sd	s1,88(sp)
    8000346a:	e0d2                	sd	s4,64(sp)
    8000346c:	fc56                	sd	s5,56(sp)
    8000346e:	f85a                	sd	s6,48(sp)
    80003470:	f45e                	sd	s7,40(sp)
    80003472:	1880                	addi	s0,sp,112
    80003474:	8b2a                	mv	s6,a0
    80003476:	8bae                	mv	s7,a1
    80003478:	8a32                	mv	s4,a2
    8000347a:	84b6                	mv	s1,a3
    8000347c:	8aba                	mv	s5,a4
    8000347e:	9f35                	addw	a4,a4,a3
    80003480:	4501                	li	a0,0
    80003482:	0cd76063          	bltu	a4,a3,80003542 <readi+0xe6>
    80003486:	e4ce                	sd	s3,72(sp)
    80003488:	00e7f463          	bgeu	a5,a4,80003490 <readi+0x34>
    8000348c:	40d78abb          	subw	s5,a5,a3
    80003490:	080a8f63          	beqz	s5,8000352e <readi+0xd2>
    80003494:	e8ca                	sd	s2,80(sp)
    80003496:	f062                	sd	s8,32(sp)
    80003498:	ec66                	sd	s9,24(sp)
    8000349a:	e86a                	sd	s10,16(sp)
    8000349c:	e46e                	sd	s11,8(sp)
    8000349e:	4981                	li	s3,0
    800034a0:	40000c93          	li	s9,1024
    800034a4:	5c7d                	li	s8,-1
    800034a6:	a80d                	j	800034d8 <readi+0x7c>
    800034a8:	020d1d93          	slli	s11,s10,0x20
    800034ac:	020ddd93          	srli	s11,s11,0x20
    800034b0:	05890613          	addi	a2,s2,88
    800034b4:	86ee                	mv	a3,s11
    800034b6:	963a                	add	a2,a2,a4
    800034b8:	85d2                	mv	a1,s4
    800034ba:	855e                	mv	a0,s7
    800034bc:	d5dfe0ef          	jal	80002218 <either_copyout>
    800034c0:	05850763          	beq	a0,s8,8000350e <readi+0xb2>
    800034c4:	854a                	mv	a0,s2
    800034c6:	f12ff0ef          	jal	80002bd8 <brelse>
    800034ca:	013d09bb          	addw	s3,s10,s3
    800034ce:	009d04bb          	addw	s1,s10,s1
    800034d2:	9a6e                	add	s4,s4,s11
    800034d4:	0559f763          	bgeu	s3,s5,80003522 <readi+0xc6>
    800034d8:	00a4d59b          	srliw	a1,s1,0xa
    800034dc:	855a                	mv	a0,s6
    800034de:	977ff0ef          	jal	80002e54 <bmap>
    800034e2:	0005059b          	sext.w	a1,a0
    800034e6:	c5b1                	beqz	a1,80003532 <readi+0xd6>
    800034e8:	000b2503          	lw	a0,0(s6)
    800034ec:	de4ff0ef          	jal	80002ad0 <bread>
    800034f0:	892a                	mv	s2,a0
    800034f2:	3ff4f713          	andi	a4,s1,1023
    800034f6:	40ec87bb          	subw	a5,s9,a4
    800034fa:	413a86bb          	subw	a3,s5,s3
    800034fe:	8d3e                	mv	s10,a5
    80003500:	2781                	sext.w	a5,a5
    80003502:	0006861b          	sext.w	a2,a3
    80003506:	faf671e3          	bgeu	a2,a5,800034a8 <readi+0x4c>
    8000350a:	8d36                	mv	s10,a3
    8000350c:	bf71                	j	800034a8 <readi+0x4c>
    8000350e:	854a                	mv	a0,s2
    80003510:	ec8ff0ef          	jal	80002bd8 <brelse>
    80003514:	59fd                	li	s3,-1
    80003516:	6946                	ld	s2,80(sp)
    80003518:	7c02                	ld	s8,32(sp)
    8000351a:	6ce2                	ld	s9,24(sp)
    8000351c:	6d42                	ld	s10,16(sp)
    8000351e:	6da2                	ld	s11,8(sp)
    80003520:	a831                	j	8000353c <readi+0xe0>
    80003522:	6946                	ld	s2,80(sp)
    80003524:	7c02                	ld	s8,32(sp)
    80003526:	6ce2                	ld	s9,24(sp)
    80003528:	6d42                	ld	s10,16(sp)
    8000352a:	6da2                	ld	s11,8(sp)
    8000352c:	a801                	j	8000353c <readi+0xe0>
    8000352e:	89d6                	mv	s3,s5
    80003530:	a031                	j	8000353c <readi+0xe0>
    80003532:	6946                	ld	s2,80(sp)
    80003534:	7c02                	ld	s8,32(sp)
    80003536:	6ce2                	ld	s9,24(sp)
    80003538:	6d42                	ld	s10,16(sp)
    8000353a:	6da2                	ld	s11,8(sp)
    8000353c:	0009851b          	sext.w	a0,s3
    80003540:	69a6                	ld	s3,72(sp)
    80003542:	70a6                	ld	ra,104(sp)
    80003544:	7406                	ld	s0,96(sp)
    80003546:	64e6                	ld	s1,88(sp)
    80003548:	6a06                	ld	s4,64(sp)
    8000354a:	7ae2                	ld	s5,56(sp)
    8000354c:	7b42                	ld	s6,48(sp)
    8000354e:	7ba2                	ld	s7,40(sp)
    80003550:	6165                	addi	sp,sp,112
    80003552:	8082                	ret
    80003554:	4501                	li	a0,0
    80003556:	8082                	ret

0000000080003558 <writei>:
    80003558:	457c                	lw	a5,76(a0)
    8000355a:	10d7e063          	bltu	a5,a3,8000365a <writei+0x102>
    8000355e:	7159                	addi	sp,sp,-112
    80003560:	f486                	sd	ra,104(sp)
    80003562:	f0a2                	sd	s0,96(sp)
    80003564:	e8ca                	sd	s2,80(sp)
    80003566:	e0d2                	sd	s4,64(sp)
    80003568:	fc56                	sd	s5,56(sp)
    8000356a:	f85a                	sd	s6,48(sp)
    8000356c:	f45e                	sd	s7,40(sp)
    8000356e:	1880                	addi	s0,sp,112
    80003570:	8aaa                	mv	s5,a0
    80003572:	8bae                	mv	s7,a1
    80003574:	8a32                	mv	s4,a2
    80003576:	8936                	mv	s2,a3
    80003578:	8b3a                	mv	s6,a4
    8000357a:	00e687bb          	addw	a5,a3,a4
    8000357e:	0ed7e063          	bltu	a5,a3,8000365e <writei+0x106>
    80003582:	00043737          	lui	a4,0x43
    80003586:	0cf76e63          	bltu	a4,a5,80003662 <writei+0x10a>
    8000358a:	e4ce                	sd	s3,72(sp)
    8000358c:	0a0b0f63          	beqz	s6,8000364a <writei+0xf2>
    80003590:	eca6                	sd	s1,88(sp)
    80003592:	f062                	sd	s8,32(sp)
    80003594:	ec66                	sd	s9,24(sp)
    80003596:	e86a                	sd	s10,16(sp)
    80003598:	e46e                	sd	s11,8(sp)
    8000359a:	4981                	li	s3,0
    8000359c:	40000c93          	li	s9,1024
    800035a0:	5c7d                	li	s8,-1
    800035a2:	a825                	j	800035da <writei+0x82>
    800035a4:	020d1d93          	slli	s11,s10,0x20
    800035a8:	020ddd93          	srli	s11,s11,0x20
    800035ac:	05848513          	addi	a0,s1,88
    800035b0:	86ee                	mv	a3,s11
    800035b2:	8652                	mv	a2,s4
    800035b4:	85de                	mv	a1,s7
    800035b6:	953a                	add	a0,a0,a4
    800035b8:	cabfe0ef          	jal	80002262 <either_copyin>
    800035bc:	05850a63          	beq	a0,s8,80003610 <writei+0xb8>
    800035c0:	8526                	mv	a0,s1
    800035c2:	660000ef          	jal	80003c22 <log_write>
    800035c6:	8526                	mv	a0,s1
    800035c8:	e10ff0ef          	jal	80002bd8 <brelse>
    800035cc:	013d09bb          	addw	s3,s10,s3
    800035d0:	012d093b          	addw	s2,s10,s2
    800035d4:	9a6e                	add	s4,s4,s11
    800035d6:	0569f063          	bgeu	s3,s6,80003616 <writei+0xbe>
    800035da:	00a9559b          	srliw	a1,s2,0xa
    800035de:	8556                	mv	a0,s5
    800035e0:	875ff0ef          	jal	80002e54 <bmap>
    800035e4:	0005059b          	sext.w	a1,a0
    800035e8:	c59d                	beqz	a1,80003616 <writei+0xbe>
    800035ea:	000aa503          	lw	a0,0(s5)
    800035ee:	ce2ff0ef          	jal	80002ad0 <bread>
    800035f2:	84aa                	mv	s1,a0
    800035f4:	3ff97713          	andi	a4,s2,1023
    800035f8:	40ec87bb          	subw	a5,s9,a4
    800035fc:	413b06bb          	subw	a3,s6,s3
    80003600:	8d3e                	mv	s10,a5
    80003602:	2781                	sext.w	a5,a5
    80003604:	0006861b          	sext.w	a2,a3
    80003608:	f8f67ee3          	bgeu	a2,a5,800035a4 <writei+0x4c>
    8000360c:	8d36                	mv	s10,a3
    8000360e:	bf59                	j	800035a4 <writei+0x4c>
    80003610:	8526                	mv	a0,s1
    80003612:	dc6ff0ef          	jal	80002bd8 <brelse>
    80003616:	04caa783          	lw	a5,76(s5)
    8000361a:	0327fa63          	bgeu	a5,s2,8000364e <writei+0xf6>
    8000361e:	052aa623          	sw	s2,76(s5)
    80003622:	64e6                	ld	s1,88(sp)
    80003624:	7c02                	ld	s8,32(sp)
    80003626:	6ce2                	ld	s9,24(sp)
    80003628:	6d42                	ld	s10,16(sp)
    8000362a:	6da2                	ld	s11,8(sp)
    8000362c:	8556                	mv	a0,s5
    8000362e:	b27ff0ef          	jal	80003154 <iupdate>
    80003632:	0009851b          	sext.w	a0,s3
    80003636:	69a6                	ld	s3,72(sp)
    80003638:	70a6                	ld	ra,104(sp)
    8000363a:	7406                	ld	s0,96(sp)
    8000363c:	6946                	ld	s2,80(sp)
    8000363e:	6a06                	ld	s4,64(sp)
    80003640:	7ae2                	ld	s5,56(sp)
    80003642:	7b42                	ld	s6,48(sp)
    80003644:	7ba2                	ld	s7,40(sp)
    80003646:	6165                	addi	sp,sp,112
    80003648:	8082                	ret
    8000364a:	89da                	mv	s3,s6
    8000364c:	b7c5                	j	8000362c <writei+0xd4>
    8000364e:	64e6                	ld	s1,88(sp)
    80003650:	7c02                	ld	s8,32(sp)
    80003652:	6ce2                	ld	s9,24(sp)
    80003654:	6d42                	ld	s10,16(sp)
    80003656:	6da2                	ld	s11,8(sp)
    80003658:	bfd1                	j	8000362c <writei+0xd4>
    8000365a:	557d                	li	a0,-1
    8000365c:	8082                	ret
    8000365e:	557d                	li	a0,-1
    80003660:	bfe1                	j	80003638 <writei+0xe0>
    80003662:	557d                	li	a0,-1
    80003664:	bfd1                	j	80003638 <writei+0xe0>

0000000080003666 <namecmp>:
    80003666:	1141                	addi	sp,sp,-16
    80003668:	e406                	sd	ra,8(sp)
    8000366a:	e022                	sd	s0,0(sp)
    8000366c:	0800                	addi	s0,sp,16
    8000366e:	4639                	li	a2,14
    80003670:	f32fd0ef          	jal	80000da2 <strncmp>
    80003674:	60a2                	ld	ra,8(sp)
    80003676:	6402                	ld	s0,0(sp)
    80003678:	0141                	addi	sp,sp,16
    8000367a:	8082                	ret

000000008000367c <dirlookup>:
    8000367c:	7139                	addi	sp,sp,-64
    8000367e:	fc06                	sd	ra,56(sp)
    80003680:	f822                	sd	s0,48(sp)
    80003682:	f426                	sd	s1,40(sp)
    80003684:	f04a                	sd	s2,32(sp)
    80003686:	ec4e                	sd	s3,24(sp)
    80003688:	e852                	sd	s4,16(sp)
    8000368a:	0080                	addi	s0,sp,64
    8000368c:	04451703          	lh	a4,68(a0)
    80003690:	4785                	li	a5,1
    80003692:	00f71a63          	bne	a4,a5,800036a6 <dirlookup+0x2a>
    80003696:	892a                	mv	s2,a0
    80003698:	89ae                	mv	s3,a1
    8000369a:	8a32                	mv	s4,a2
    8000369c:	457c                	lw	a5,76(a0)
    8000369e:	4481                	li	s1,0
    800036a0:	4501                	li	a0,0
    800036a2:	e39d                	bnez	a5,800036c8 <dirlookup+0x4c>
    800036a4:	a095                	j	80003708 <dirlookup+0x8c>
    800036a6:	00004517          	auipc	a0,0x4
    800036aa:	e7a50513          	addi	a0,a0,-390 # 80007520 <etext+0x520>
    800036ae:	8f4fd0ef          	jal	800007a2 <panic>
    800036b2:	00004517          	auipc	a0,0x4
    800036b6:	e8650513          	addi	a0,a0,-378 # 80007538 <etext+0x538>
    800036ba:	8e8fd0ef          	jal	800007a2 <panic>
    800036be:	24c1                	addiw	s1,s1,16
    800036c0:	04c92783          	lw	a5,76(s2)
    800036c4:	04f4f163          	bgeu	s1,a5,80003706 <dirlookup+0x8a>
    800036c8:	4741                	li	a4,16
    800036ca:	86a6                	mv	a3,s1
    800036cc:	fc040613          	addi	a2,s0,-64
    800036d0:	4581                	li	a1,0
    800036d2:	854a                	mv	a0,s2
    800036d4:	d89ff0ef          	jal	8000345c <readi>
    800036d8:	47c1                	li	a5,16
    800036da:	fcf51ce3          	bne	a0,a5,800036b2 <dirlookup+0x36>
    800036de:	fc045783          	lhu	a5,-64(s0)
    800036e2:	dff1                	beqz	a5,800036be <dirlookup+0x42>
    800036e4:	fc240593          	addi	a1,s0,-62
    800036e8:	854e                	mv	a0,s3
    800036ea:	f7dff0ef          	jal	80003666 <namecmp>
    800036ee:	f961                	bnez	a0,800036be <dirlookup+0x42>
    800036f0:	000a0463          	beqz	s4,800036f8 <dirlookup+0x7c>
    800036f4:	009a2023          	sw	s1,0(s4)
    800036f8:	fc045583          	lhu	a1,-64(s0)
    800036fc:	00092503          	lw	a0,0(s2)
    80003700:	829ff0ef          	jal	80002f28 <iget>
    80003704:	a011                	j	80003708 <dirlookup+0x8c>
    80003706:	4501                	li	a0,0
    80003708:	70e2                	ld	ra,56(sp)
    8000370a:	7442                	ld	s0,48(sp)
    8000370c:	74a2                	ld	s1,40(sp)
    8000370e:	7902                	ld	s2,32(sp)
    80003710:	69e2                	ld	s3,24(sp)
    80003712:	6a42                	ld	s4,16(sp)
    80003714:	6121                	addi	sp,sp,64
    80003716:	8082                	ret

0000000080003718 <namex>:
    80003718:	711d                	addi	sp,sp,-96
    8000371a:	ec86                	sd	ra,88(sp)
    8000371c:	e8a2                	sd	s0,80(sp)
    8000371e:	e4a6                	sd	s1,72(sp)
    80003720:	e0ca                	sd	s2,64(sp)
    80003722:	fc4e                	sd	s3,56(sp)
    80003724:	f852                	sd	s4,48(sp)
    80003726:	f456                	sd	s5,40(sp)
    80003728:	f05a                	sd	s6,32(sp)
    8000372a:	ec5e                	sd	s7,24(sp)
    8000372c:	e862                	sd	s8,16(sp)
    8000372e:	e466                	sd	s9,8(sp)
    80003730:	1080                	addi	s0,sp,96
    80003732:	84aa                	mv	s1,a0
    80003734:	8b2e                	mv	s6,a1
    80003736:	8ab2                	mv	s5,a2
    80003738:	00054703          	lbu	a4,0(a0)
    8000373c:	02f00793          	li	a5,47
    80003740:	00f70e63          	beq	a4,a5,8000375c <namex+0x44>
    80003744:	9aafe0ef          	jal	800018ee <myproc>
    80003748:	15053503          	ld	a0,336(a0)
    8000374c:	a87ff0ef          	jal	800031d2 <idup>
    80003750:	8a2a                	mv	s4,a0
    80003752:	02f00913          	li	s2,47
    80003756:	4c35                	li	s8,13
    80003758:	4b85                	li	s7,1
    8000375a:	a871                	j	800037f6 <namex+0xde>
    8000375c:	4585                	li	a1,1
    8000375e:	4505                	li	a0,1
    80003760:	fc8ff0ef          	jal	80002f28 <iget>
    80003764:	8a2a                	mv	s4,a0
    80003766:	b7f5                	j	80003752 <namex+0x3a>
    80003768:	8552                	mv	a0,s4
    8000376a:	ca9ff0ef          	jal	80003412 <iunlockput>
    8000376e:	4a01                	li	s4,0
    80003770:	8552                	mv	a0,s4
    80003772:	60e6                	ld	ra,88(sp)
    80003774:	6446                	ld	s0,80(sp)
    80003776:	64a6                	ld	s1,72(sp)
    80003778:	6906                	ld	s2,64(sp)
    8000377a:	79e2                	ld	s3,56(sp)
    8000377c:	7a42                	ld	s4,48(sp)
    8000377e:	7aa2                	ld	s5,40(sp)
    80003780:	7b02                	ld	s6,32(sp)
    80003782:	6be2                	ld	s7,24(sp)
    80003784:	6c42                	ld	s8,16(sp)
    80003786:	6ca2                	ld	s9,8(sp)
    80003788:	6125                	addi	sp,sp,96
    8000378a:	8082                	ret
    8000378c:	8552                	mv	a0,s4
    8000378e:	b29ff0ef          	jal	800032b6 <iunlock>
    80003792:	bff9                	j	80003770 <namex+0x58>
    80003794:	8552                	mv	a0,s4
    80003796:	c7dff0ef          	jal	80003412 <iunlockput>
    8000379a:	8a4e                	mv	s4,s3
    8000379c:	bfd1                	j	80003770 <namex+0x58>
    8000379e:	40998633          	sub	a2,s3,s1
    800037a2:	00060c9b          	sext.w	s9,a2
    800037a6:	099c5063          	bge	s8,s9,80003826 <namex+0x10e>
    800037aa:	4639                	li	a2,14
    800037ac:	85a6                	mv	a1,s1
    800037ae:	8556                	mv	a0,s5
    800037b0:	d82fd0ef          	jal	80000d32 <memmove>
    800037b4:	84ce                	mv	s1,s3
    800037b6:	0004c783          	lbu	a5,0(s1)
    800037ba:	01279763          	bne	a5,s2,800037c8 <namex+0xb0>
    800037be:	0485                	addi	s1,s1,1
    800037c0:	0004c783          	lbu	a5,0(s1)
    800037c4:	ff278de3          	beq	a5,s2,800037be <namex+0xa6>
    800037c8:	8552                	mv	a0,s4
    800037ca:	a3fff0ef          	jal	80003208 <ilock>
    800037ce:	044a1783          	lh	a5,68(s4)
    800037d2:	f9779be3          	bne	a5,s7,80003768 <namex+0x50>
    800037d6:	000b0563          	beqz	s6,800037e0 <namex+0xc8>
    800037da:	0004c783          	lbu	a5,0(s1)
    800037de:	d7dd                	beqz	a5,8000378c <namex+0x74>
    800037e0:	4601                	li	a2,0
    800037e2:	85d6                	mv	a1,s5
    800037e4:	8552                	mv	a0,s4
    800037e6:	e97ff0ef          	jal	8000367c <dirlookup>
    800037ea:	89aa                	mv	s3,a0
    800037ec:	d545                	beqz	a0,80003794 <namex+0x7c>
    800037ee:	8552                	mv	a0,s4
    800037f0:	c23ff0ef          	jal	80003412 <iunlockput>
    800037f4:	8a4e                	mv	s4,s3
    800037f6:	0004c783          	lbu	a5,0(s1)
    800037fa:	01279763          	bne	a5,s2,80003808 <namex+0xf0>
    800037fe:	0485                	addi	s1,s1,1
    80003800:	0004c783          	lbu	a5,0(s1)
    80003804:	ff278de3          	beq	a5,s2,800037fe <namex+0xe6>
    80003808:	cb8d                	beqz	a5,8000383a <namex+0x122>
    8000380a:	0004c783          	lbu	a5,0(s1)
    8000380e:	89a6                	mv	s3,s1
    80003810:	4c81                	li	s9,0
    80003812:	4601                	li	a2,0
    80003814:	01278963          	beq	a5,s2,80003826 <namex+0x10e>
    80003818:	d3d9                	beqz	a5,8000379e <namex+0x86>
    8000381a:	0985                	addi	s3,s3,1
    8000381c:	0009c783          	lbu	a5,0(s3)
    80003820:	ff279ce3          	bne	a5,s2,80003818 <namex+0x100>
    80003824:	bfad                	j	8000379e <namex+0x86>
    80003826:	2601                	sext.w	a2,a2
    80003828:	85a6                	mv	a1,s1
    8000382a:	8556                	mv	a0,s5
    8000382c:	d06fd0ef          	jal	80000d32 <memmove>
    80003830:	9cd6                	add	s9,s9,s5
    80003832:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003836:	84ce                	mv	s1,s3
    80003838:	bfbd                	j	800037b6 <namex+0x9e>
    8000383a:	f20b0be3          	beqz	s6,80003770 <namex+0x58>
    8000383e:	8552                	mv	a0,s4
    80003840:	b4bff0ef          	jal	8000338a <iput>
    80003844:	4a01                	li	s4,0
    80003846:	b72d                	j	80003770 <namex+0x58>

0000000080003848 <dirlink>:
    80003848:	7139                	addi	sp,sp,-64
    8000384a:	fc06                	sd	ra,56(sp)
    8000384c:	f822                	sd	s0,48(sp)
    8000384e:	f04a                	sd	s2,32(sp)
    80003850:	ec4e                	sd	s3,24(sp)
    80003852:	e852                	sd	s4,16(sp)
    80003854:	0080                	addi	s0,sp,64
    80003856:	892a                	mv	s2,a0
    80003858:	8a2e                	mv	s4,a1
    8000385a:	89b2                	mv	s3,a2
    8000385c:	4601                	li	a2,0
    8000385e:	e1fff0ef          	jal	8000367c <dirlookup>
    80003862:	e535                	bnez	a0,800038ce <dirlink+0x86>
    80003864:	f426                	sd	s1,40(sp)
    80003866:	04c92483          	lw	s1,76(s2)
    8000386a:	c48d                	beqz	s1,80003894 <dirlink+0x4c>
    8000386c:	4481                	li	s1,0
    8000386e:	4741                	li	a4,16
    80003870:	86a6                	mv	a3,s1
    80003872:	fc040613          	addi	a2,s0,-64
    80003876:	4581                	li	a1,0
    80003878:	854a                	mv	a0,s2
    8000387a:	be3ff0ef          	jal	8000345c <readi>
    8000387e:	47c1                	li	a5,16
    80003880:	04f51b63          	bne	a0,a5,800038d6 <dirlink+0x8e>
    80003884:	fc045783          	lhu	a5,-64(s0)
    80003888:	c791                	beqz	a5,80003894 <dirlink+0x4c>
    8000388a:	24c1                	addiw	s1,s1,16
    8000388c:	04c92783          	lw	a5,76(s2)
    80003890:	fcf4efe3          	bltu	s1,a5,8000386e <dirlink+0x26>
    80003894:	4639                	li	a2,14
    80003896:	85d2                	mv	a1,s4
    80003898:	fc240513          	addi	a0,s0,-62
    8000389c:	d3cfd0ef          	jal	80000dd8 <strncpy>
    800038a0:	fd341023          	sh	s3,-64(s0)
    800038a4:	4741                	li	a4,16
    800038a6:	86a6                	mv	a3,s1
    800038a8:	fc040613          	addi	a2,s0,-64
    800038ac:	4581                	li	a1,0
    800038ae:	854a                	mv	a0,s2
    800038b0:	ca9ff0ef          	jal	80003558 <writei>
    800038b4:	1541                	addi	a0,a0,-16
    800038b6:	00a03533          	snez	a0,a0
    800038ba:	40a00533          	neg	a0,a0
    800038be:	74a2                	ld	s1,40(sp)
    800038c0:	70e2                	ld	ra,56(sp)
    800038c2:	7442                	ld	s0,48(sp)
    800038c4:	7902                	ld	s2,32(sp)
    800038c6:	69e2                	ld	s3,24(sp)
    800038c8:	6a42                	ld	s4,16(sp)
    800038ca:	6121                	addi	sp,sp,64
    800038cc:	8082                	ret
    800038ce:	abdff0ef          	jal	8000338a <iput>
    800038d2:	557d                	li	a0,-1
    800038d4:	b7f5                	j	800038c0 <dirlink+0x78>
    800038d6:	00004517          	auipc	a0,0x4
    800038da:	c7250513          	addi	a0,a0,-910 # 80007548 <etext+0x548>
    800038de:	ec5fc0ef          	jal	800007a2 <panic>

00000000800038e2 <namei>:
    800038e2:	1101                	addi	sp,sp,-32
    800038e4:	ec06                	sd	ra,24(sp)
    800038e6:	e822                	sd	s0,16(sp)
    800038e8:	1000                	addi	s0,sp,32
    800038ea:	fe040613          	addi	a2,s0,-32
    800038ee:	4581                	li	a1,0
    800038f0:	e29ff0ef          	jal	80003718 <namex>
    800038f4:	60e2                	ld	ra,24(sp)
    800038f6:	6442                	ld	s0,16(sp)
    800038f8:	6105                	addi	sp,sp,32
    800038fa:	8082                	ret

00000000800038fc <nameiparent>:
    800038fc:	1141                	addi	sp,sp,-16
    800038fe:	e406                	sd	ra,8(sp)
    80003900:	e022                	sd	s0,0(sp)
    80003902:	0800                	addi	s0,sp,16
    80003904:	862e                	mv	a2,a1
    80003906:	4585                	li	a1,1
    80003908:	e11ff0ef          	jal	80003718 <namex>
    8000390c:	60a2                	ld	ra,8(sp)
    8000390e:	6402                	ld	s0,0(sp)
    80003910:	0141                	addi	sp,sp,16
    80003912:	8082                	ret

0000000080003914 <write_head>:
    80003914:	1101                	addi	sp,sp,-32
    80003916:	ec06                	sd	ra,24(sp)
    80003918:	e822                	sd	s0,16(sp)
    8000391a:	e426                	sd	s1,8(sp)
    8000391c:	e04a                	sd	s2,0(sp)
    8000391e:	1000                	addi	s0,sp,32
    80003920:	0001f917          	auipc	s2,0x1f
    80003924:	a8090913          	addi	s2,s2,-1408 # 800223a0 <log>
    80003928:	01892583          	lw	a1,24(s2)
    8000392c:	02892503          	lw	a0,40(s2)
    80003930:	9a0ff0ef          	jal	80002ad0 <bread>
    80003934:	84aa                	mv	s1,a0
    80003936:	02c92603          	lw	a2,44(s2)
    8000393a:	cd30                	sw	a2,88(a0)
    8000393c:	00c05f63          	blez	a2,8000395a <write_head+0x46>
    80003940:	0001f717          	auipc	a4,0x1f
    80003944:	a9070713          	addi	a4,a4,-1392 # 800223d0 <log+0x30>
    80003948:	87aa                	mv	a5,a0
    8000394a:	060a                	slli	a2,a2,0x2
    8000394c:	962a                	add	a2,a2,a0
    8000394e:	4314                	lw	a3,0(a4)
    80003950:	cff4                	sw	a3,92(a5)
    80003952:	0711                	addi	a4,a4,4
    80003954:	0791                	addi	a5,a5,4
    80003956:	fec79ce3          	bne	a5,a2,8000394e <write_head+0x3a>
    8000395a:	8526                	mv	a0,s1
    8000395c:	a4aff0ef          	jal	80002ba6 <bwrite>
    80003960:	8526                	mv	a0,s1
    80003962:	a76ff0ef          	jal	80002bd8 <brelse>
    80003966:	60e2                	ld	ra,24(sp)
    80003968:	6442                	ld	s0,16(sp)
    8000396a:	64a2                	ld	s1,8(sp)
    8000396c:	6902                	ld	s2,0(sp)
    8000396e:	6105                	addi	sp,sp,32
    80003970:	8082                	ret

0000000080003972 <install_trans>:
    80003972:	0001f797          	auipc	a5,0x1f
    80003976:	a5a7a783          	lw	a5,-1446(a5) # 800223cc <log+0x2c>
    8000397a:	08f05f63          	blez	a5,80003a18 <install_trans+0xa6>
    8000397e:	7139                	addi	sp,sp,-64
    80003980:	fc06                	sd	ra,56(sp)
    80003982:	f822                	sd	s0,48(sp)
    80003984:	f426                	sd	s1,40(sp)
    80003986:	f04a                	sd	s2,32(sp)
    80003988:	ec4e                	sd	s3,24(sp)
    8000398a:	e852                	sd	s4,16(sp)
    8000398c:	e456                	sd	s5,8(sp)
    8000398e:	e05a                	sd	s6,0(sp)
    80003990:	0080                	addi	s0,sp,64
    80003992:	8b2a                	mv	s6,a0
    80003994:	0001fa97          	auipc	s5,0x1f
    80003998:	a3ca8a93          	addi	s5,s5,-1476 # 800223d0 <log+0x30>
    8000399c:	4a01                	li	s4,0
    8000399e:	0001f997          	auipc	s3,0x1f
    800039a2:	a0298993          	addi	s3,s3,-1534 # 800223a0 <log>
    800039a6:	a829                	j	800039c0 <install_trans+0x4e>
    800039a8:	854a                	mv	a0,s2
    800039aa:	a2eff0ef          	jal	80002bd8 <brelse>
    800039ae:	8526                	mv	a0,s1
    800039b0:	a28ff0ef          	jal	80002bd8 <brelse>
    800039b4:	2a05                	addiw	s4,s4,1
    800039b6:	0a91                	addi	s5,s5,4
    800039b8:	02c9a783          	lw	a5,44(s3)
    800039bc:	04fa5463          	bge	s4,a5,80003a04 <install_trans+0x92>
    800039c0:	0189a583          	lw	a1,24(s3)
    800039c4:	014585bb          	addw	a1,a1,s4
    800039c8:	2585                	addiw	a1,a1,1
    800039ca:	0289a503          	lw	a0,40(s3)
    800039ce:	902ff0ef          	jal	80002ad0 <bread>
    800039d2:	892a                	mv	s2,a0
    800039d4:	000aa583          	lw	a1,0(s5)
    800039d8:	0289a503          	lw	a0,40(s3)
    800039dc:	8f4ff0ef          	jal	80002ad0 <bread>
    800039e0:	84aa                	mv	s1,a0
    800039e2:	40000613          	li	a2,1024
    800039e6:	05890593          	addi	a1,s2,88
    800039ea:	05850513          	addi	a0,a0,88
    800039ee:	b44fd0ef          	jal	80000d32 <memmove>
    800039f2:	8526                	mv	a0,s1
    800039f4:	9b2ff0ef          	jal	80002ba6 <bwrite>
    800039f8:	fa0b18e3          	bnez	s6,800039a8 <install_trans+0x36>
    800039fc:	8526                	mv	a0,s1
    800039fe:	a96ff0ef          	jal	80002c94 <bunpin>
    80003a02:	b75d                	j	800039a8 <install_trans+0x36>
    80003a04:	70e2                	ld	ra,56(sp)
    80003a06:	7442                	ld	s0,48(sp)
    80003a08:	74a2                	ld	s1,40(sp)
    80003a0a:	7902                	ld	s2,32(sp)
    80003a0c:	69e2                	ld	s3,24(sp)
    80003a0e:	6a42                	ld	s4,16(sp)
    80003a10:	6aa2                	ld	s5,8(sp)
    80003a12:	6b02                	ld	s6,0(sp)
    80003a14:	6121                	addi	sp,sp,64
    80003a16:	8082                	ret
    80003a18:	8082                	ret

0000000080003a1a <initlog>:
    80003a1a:	7179                	addi	sp,sp,-48
    80003a1c:	f406                	sd	ra,40(sp)
    80003a1e:	f022                	sd	s0,32(sp)
    80003a20:	ec26                	sd	s1,24(sp)
    80003a22:	e84a                	sd	s2,16(sp)
    80003a24:	e44e                	sd	s3,8(sp)
    80003a26:	1800                	addi	s0,sp,48
    80003a28:	892a                	mv	s2,a0
    80003a2a:	89ae                	mv	s3,a1
    80003a2c:	0001f497          	auipc	s1,0x1f
    80003a30:	97448493          	addi	s1,s1,-1676 # 800223a0 <log>
    80003a34:	00004597          	auipc	a1,0x4
    80003a38:	b2458593          	addi	a1,a1,-1244 # 80007558 <etext+0x558>
    80003a3c:	8526                	mv	a0,s1
    80003a3e:	944fd0ef          	jal	80000b82 <initlock>
    80003a42:	0149a583          	lw	a1,20(s3)
    80003a46:	cc8c                	sw	a1,24(s1)
    80003a48:	0109a783          	lw	a5,16(s3)
    80003a4c:	ccdc                	sw	a5,28(s1)
    80003a4e:	0324a423          	sw	s2,40(s1)
    80003a52:	854a                	mv	a0,s2
    80003a54:	87cff0ef          	jal	80002ad0 <bread>
    80003a58:	4d30                	lw	a2,88(a0)
    80003a5a:	d4d0                	sw	a2,44(s1)
    80003a5c:	00c05f63          	blez	a2,80003a7a <initlog+0x60>
    80003a60:	87aa                	mv	a5,a0
    80003a62:	0001f717          	auipc	a4,0x1f
    80003a66:	96e70713          	addi	a4,a4,-1682 # 800223d0 <log+0x30>
    80003a6a:	060a                	slli	a2,a2,0x2
    80003a6c:	962a                	add	a2,a2,a0
    80003a6e:	4ff4                	lw	a3,92(a5)
    80003a70:	c314                	sw	a3,0(a4)
    80003a72:	0791                	addi	a5,a5,4
    80003a74:	0711                	addi	a4,a4,4
    80003a76:	fec79ce3          	bne	a5,a2,80003a6e <initlog+0x54>
    80003a7a:	95eff0ef          	jal	80002bd8 <brelse>
    80003a7e:	4505                	li	a0,1
    80003a80:	ef3ff0ef          	jal	80003972 <install_trans>
    80003a84:	0001f797          	auipc	a5,0x1f
    80003a88:	9407a423          	sw	zero,-1720(a5) # 800223cc <log+0x2c>
    80003a8c:	e89ff0ef          	jal	80003914 <write_head>
    80003a90:	70a2                	ld	ra,40(sp)
    80003a92:	7402                	ld	s0,32(sp)
    80003a94:	64e2                	ld	s1,24(sp)
    80003a96:	6942                	ld	s2,16(sp)
    80003a98:	69a2                	ld	s3,8(sp)
    80003a9a:	6145                	addi	sp,sp,48
    80003a9c:	8082                	ret

0000000080003a9e <begin_op>:
    80003a9e:	1101                	addi	sp,sp,-32
    80003aa0:	ec06                	sd	ra,24(sp)
    80003aa2:	e822                	sd	s0,16(sp)
    80003aa4:	e426                	sd	s1,8(sp)
    80003aa6:	e04a                	sd	s2,0(sp)
    80003aa8:	1000                	addi	s0,sp,32
    80003aaa:	0001f517          	auipc	a0,0x1f
    80003aae:	8f650513          	addi	a0,a0,-1802 # 800223a0 <log>
    80003ab2:	950fd0ef          	jal	80000c02 <acquire>
    80003ab6:	0001f497          	auipc	s1,0x1f
    80003aba:	8ea48493          	addi	s1,s1,-1814 # 800223a0 <log>
    80003abe:	4979                	li	s2,30
    80003ac0:	a029                	j	80003aca <begin_op+0x2c>
    80003ac2:	85a6                	mv	a1,s1
    80003ac4:	8526                	mv	a0,s1
    80003ac6:	bf6fe0ef          	jal	80001ebc <sleep>
    80003aca:	50dc                	lw	a5,36(s1)
    80003acc:	fbfd                	bnez	a5,80003ac2 <begin_op+0x24>
    80003ace:	5098                	lw	a4,32(s1)
    80003ad0:	2705                	addiw	a4,a4,1
    80003ad2:	0027179b          	slliw	a5,a4,0x2
    80003ad6:	9fb9                	addw	a5,a5,a4
    80003ad8:	0017979b          	slliw	a5,a5,0x1
    80003adc:	54d4                	lw	a3,44(s1)
    80003ade:	9fb5                	addw	a5,a5,a3
    80003ae0:	00f95763          	bge	s2,a5,80003aee <begin_op+0x50>
    80003ae4:	85a6                	mv	a1,s1
    80003ae6:	8526                	mv	a0,s1
    80003ae8:	bd4fe0ef          	jal	80001ebc <sleep>
    80003aec:	bff9                	j	80003aca <begin_op+0x2c>
    80003aee:	0001f517          	auipc	a0,0x1f
    80003af2:	8b250513          	addi	a0,a0,-1870 # 800223a0 <log>
    80003af6:	d118                	sw	a4,32(a0)
    80003af8:	9a2fd0ef          	jal	80000c9a <release>
    80003afc:	60e2                	ld	ra,24(sp)
    80003afe:	6442                	ld	s0,16(sp)
    80003b00:	64a2                	ld	s1,8(sp)
    80003b02:	6902                	ld	s2,0(sp)
    80003b04:	6105                	addi	sp,sp,32
    80003b06:	8082                	ret

0000000080003b08 <end_op>:
    80003b08:	7139                	addi	sp,sp,-64
    80003b0a:	fc06                	sd	ra,56(sp)
    80003b0c:	f822                	sd	s0,48(sp)
    80003b0e:	f426                	sd	s1,40(sp)
    80003b10:	f04a                	sd	s2,32(sp)
    80003b12:	0080                	addi	s0,sp,64
    80003b14:	0001f497          	auipc	s1,0x1f
    80003b18:	88c48493          	addi	s1,s1,-1908 # 800223a0 <log>
    80003b1c:	8526                	mv	a0,s1
    80003b1e:	8e4fd0ef          	jal	80000c02 <acquire>
    80003b22:	509c                	lw	a5,32(s1)
    80003b24:	37fd                	addiw	a5,a5,-1
    80003b26:	0007891b          	sext.w	s2,a5
    80003b2a:	d09c                	sw	a5,32(s1)
    80003b2c:	50dc                	lw	a5,36(s1)
    80003b2e:	ef9d                	bnez	a5,80003b6c <end_op+0x64>
    80003b30:	04091763          	bnez	s2,80003b7e <end_op+0x76>
    80003b34:	0001f497          	auipc	s1,0x1f
    80003b38:	86c48493          	addi	s1,s1,-1940 # 800223a0 <log>
    80003b3c:	4785                	li	a5,1
    80003b3e:	d0dc                	sw	a5,36(s1)
    80003b40:	8526                	mv	a0,s1
    80003b42:	958fd0ef          	jal	80000c9a <release>
    80003b46:	54dc                	lw	a5,44(s1)
    80003b48:	04f04b63          	bgtz	a5,80003b9e <end_op+0x96>
    80003b4c:	0001f497          	auipc	s1,0x1f
    80003b50:	85448493          	addi	s1,s1,-1964 # 800223a0 <log>
    80003b54:	8526                	mv	a0,s1
    80003b56:	8acfd0ef          	jal	80000c02 <acquire>
    80003b5a:	0204a223          	sw	zero,36(s1)
    80003b5e:	8526                	mv	a0,s1
    80003b60:	ba8fe0ef          	jal	80001f08 <wakeup>
    80003b64:	8526                	mv	a0,s1
    80003b66:	934fd0ef          	jal	80000c9a <release>
    80003b6a:	a025                	j	80003b92 <end_op+0x8a>
    80003b6c:	ec4e                	sd	s3,24(sp)
    80003b6e:	e852                	sd	s4,16(sp)
    80003b70:	e456                	sd	s5,8(sp)
    80003b72:	00004517          	auipc	a0,0x4
    80003b76:	9ee50513          	addi	a0,a0,-1554 # 80007560 <etext+0x560>
    80003b7a:	c29fc0ef          	jal	800007a2 <panic>
    80003b7e:	0001f497          	auipc	s1,0x1f
    80003b82:	82248493          	addi	s1,s1,-2014 # 800223a0 <log>
    80003b86:	8526                	mv	a0,s1
    80003b88:	b80fe0ef          	jal	80001f08 <wakeup>
    80003b8c:	8526                	mv	a0,s1
    80003b8e:	90cfd0ef          	jal	80000c9a <release>
    80003b92:	70e2                	ld	ra,56(sp)
    80003b94:	7442                	ld	s0,48(sp)
    80003b96:	74a2                	ld	s1,40(sp)
    80003b98:	7902                	ld	s2,32(sp)
    80003b9a:	6121                	addi	sp,sp,64
    80003b9c:	8082                	ret
    80003b9e:	ec4e                	sd	s3,24(sp)
    80003ba0:	e852                	sd	s4,16(sp)
    80003ba2:	e456                	sd	s5,8(sp)
    80003ba4:	0001fa97          	auipc	s5,0x1f
    80003ba8:	82ca8a93          	addi	s5,s5,-2004 # 800223d0 <log+0x30>
    80003bac:	0001ea17          	auipc	s4,0x1e
    80003bb0:	7f4a0a13          	addi	s4,s4,2036 # 800223a0 <log>
    80003bb4:	018a2583          	lw	a1,24(s4)
    80003bb8:	012585bb          	addw	a1,a1,s2
    80003bbc:	2585                	addiw	a1,a1,1
    80003bbe:	028a2503          	lw	a0,40(s4)
    80003bc2:	f0ffe0ef          	jal	80002ad0 <bread>
    80003bc6:	84aa                	mv	s1,a0
    80003bc8:	000aa583          	lw	a1,0(s5)
    80003bcc:	028a2503          	lw	a0,40(s4)
    80003bd0:	f01fe0ef          	jal	80002ad0 <bread>
    80003bd4:	89aa                	mv	s3,a0
    80003bd6:	40000613          	li	a2,1024
    80003bda:	05850593          	addi	a1,a0,88
    80003bde:	05848513          	addi	a0,s1,88
    80003be2:	950fd0ef          	jal	80000d32 <memmove>
    80003be6:	8526                	mv	a0,s1
    80003be8:	fbffe0ef          	jal	80002ba6 <bwrite>
    80003bec:	854e                	mv	a0,s3
    80003bee:	febfe0ef          	jal	80002bd8 <brelse>
    80003bf2:	8526                	mv	a0,s1
    80003bf4:	fe5fe0ef          	jal	80002bd8 <brelse>
    80003bf8:	2905                	addiw	s2,s2,1
    80003bfa:	0a91                	addi	s5,s5,4
    80003bfc:	02ca2783          	lw	a5,44(s4)
    80003c00:	faf94ae3          	blt	s2,a5,80003bb4 <end_op+0xac>
    80003c04:	d11ff0ef          	jal	80003914 <write_head>
    80003c08:	4501                	li	a0,0
    80003c0a:	d69ff0ef          	jal	80003972 <install_trans>
    80003c0e:	0001e797          	auipc	a5,0x1e
    80003c12:	7a07af23          	sw	zero,1982(a5) # 800223cc <log+0x2c>
    80003c16:	cffff0ef          	jal	80003914 <write_head>
    80003c1a:	69e2                	ld	s3,24(sp)
    80003c1c:	6a42                	ld	s4,16(sp)
    80003c1e:	6aa2                	ld	s5,8(sp)
    80003c20:	b735                	j	80003b4c <end_op+0x44>

0000000080003c22 <log_write>:
    80003c22:	1101                	addi	sp,sp,-32
    80003c24:	ec06                	sd	ra,24(sp)
    80003c26:	e822                	sd	s0,16(sp)
    80003c28:	e426                	sd	s1,8(sp)
    80003c2a:	e04a                	sd	s2,0(sp)
    80003c2c:	1000                	addi	s0,sp,32
    80003c2e:	84aa                	mv	s1,a0
    80003c30:	0001e917          	auipc	s2,0x1e
    80003c34:	77090913          	addi	s2,s2,1904 # 800223a0 <log>
    80003c38:	854a                	mv	a0,s2
    80003c3a:	fc9fc0ef          	jal	80000c02 <acquire>
    80003c3e:	02c92603          	lw	a2,44(s2)
    80003c42:	47f5                	li	a5,29
    80003c44:	06c7c363          	blt	a5,a2,80003caa <log_write+0x88>
    80003c48:	0001e797          	auipc	a5,0x1e
    80003c4c:	7747a783          	lw	a5,1908(a5) # 800223bc <log+0x1c>
    80003c50:	37fd                	addiw	a5,a5,-1
    80003c52:	04f65c63          	bge	a2,a5,80003caa <log_write+0x88>
    80003c56:	0001e797          	auipc	a5,0x1e
    80003c5a:	76a7a783          	lw	a5,1898(a5) # 800223c0 <log+0x20>
    80003c5e:	04f05c63          	blez	a5,80003cb6 <log_write+0x94>
    80003c62:	4781                	li	a5,0
    80003c64:	04c05f63          	blez	a2,80003cc2 <log_write+0xa0>
    80003c68:	44cc                	lw	a1,12(s1)
    80003c6a:	0001e717          	auipc	a4,0x1e
    80003c6e:	76670713          	addi	a4,a4,1894 # 800223d0 <log+0x30>
    80003c72:	4781                	li	a5,0
    80003c74:	4314                	lw	a3,0(a4)
    80003c76:	04b68663          	beq	a3,a1,80003cc2 <log_write+0xa0>
    80003c7a:	2785                	addiw	a5,a5,1
    80003c7c:	0711                	addi	a4,a4,4
    80003c7e:	fef61be3          	bne	a2,a5,80003c74 <log_write+0x52>
    80003c82:	0621                	addi	a2,a2,8
    80003c84:	060a                	slli	a2,a2,0x2
    80003c86:	0001e797          	auipc	a5,0x1e
    80003c8a:	71a78793          	addi	a5,a5,1818 # 800223a0 <log>
    80003c8e:	97b2                	add	a5,a5,a2
    80003c90:	44d8                	lw	a4,12(s1)
    80003c92:	cb98                	sw	a4,16(a5)
    80003c94:	8526                	mv	a0,s1
    80003c96:	fcbfe0ef          	jal	80002c60 <bpin>
    80003c9a:	0001e717          	auipc	a4,0x1e
    80003c9e:	70670713          	addi	a4,a4,1798 # 800223a0 <log>
    80003ca2:	575c                	lw	a5,44(a4)
    80003ca4:	2785                	addiw	a5,a5,1
    80003ca6:	d75c                	sw	a5,44(a4)
    80003ca8:	a80d                	j	80003cda <log_write+0xb8>
    80003caa:	00004517          	auipc	a0,0x4
    80003cae:	8c650513          	addi	a0,a0,-1850 # 80007570 <etext+0x570>
    80003cb2:	af1fc0ef          	jal	800007a2 <panic>
    80003cb6:	00004517          	auipc	a0,0x4
    80003cba:	8d250513          	addi	a0,a0,-1838 # 80007588 <etext+0x588>
    80003cbe:	ae5fc0ef          	jal	800007a2 <panic>
    80003cc2:	00878693          	addi	a3,a5,8
    80003cc6:	068a                	slli	a3,a3,0x2
    80003cc8:	0001e717          	auipc	a4,0x1e
    80003ccc:	6d870713          	addi	a4,a4,1752 # 800223a0 <log>
    80003cd0:	9736                	add	a4,a4,a3
    80003cd2:	44d4                	lw	a3,12(s1)
    80003cd4:	cb14                	sw	a3,16(a4)
    80003cd6:	faf60fe3          	beq	a2,a5,80003c94 <log_write+0x72>
    80003cda:	0001e517          	auipc	a0,0x1e
    80003cde:	6c650513          	addi	a0,a0,1734 # 800223a0 <log>
    80003ce2:	fb9fc0ef          	jal	80000c9a <release>
    80003ce6:	60e2                	ld	ra,24(sp)
    80003ce8:	6442                	ld	s0,16(sp)
    80003cea:	64a2                	ld	s1,8(sp)
    80003cec:	6902                	ld	s2,0(sp)
    80003cee:	6105                	addi	sp,sp,32
    80003cf0:	8082                	ret

0000000080003cf2 <initsleeplock>:
    80003cf2:	1101                	addi	sp,sp,-32
    80003cf4:	ec06                	sd	ra,24(sp)
    80003cf6:	e822                	sd	s0,16(sp)
    80003cf8:	e426                	sd	s1,8(sp)
    80003cfa:	e04a                	sd	s2,0(sp)
    80003cfc:	1000                	addi	s0,sp,32
    80003cfe:	84aa                	mv	s1,a0
    80003d00:	892e                	mv	s2,a1
    80003d02:	00004597          	auipc	a1,0x4
    80003d06:	8a658593          	addi	a1,a1,-1882 # 800075a8 <etext+0x5a8>
    80003d0a:	0521                	addi	a0,a0,8
    80003d0c:	e77fc0ef          	jal	80000b82 <initlock>
    80003d10:	0324b023          	sd	s2,32(s1)
    80003d14:	0004a023          	sw	zero,0(s1)
    80003d18:	0204a423          	sw	zero,40(s1)
    80003d1c:	60e2                	ld	ra,24(sp)
    80003d1e:	6442                	ld	s0,16(sp)
    80003d20:	64a2                	ld	s1,8(sp)
    80003d22:	6902                	ld	s2,0(sp)
    80003d24:	6105                	addi	sp,sp,32
    80003d26:	8082                	ret

0000000080003d28 <acquiresleep>:
    80003d28:	1101                	addi	sp,sp,-32
    80003d2a:	ec06                	sd	ra,24(sp)
    80003d2c:	e822                	sd	s0,16(sp)
    80003d2e:	e426                	sd	s1,8(sp)
    80003d30:	e04a                	sd	s2,0(sp)
    80003d32:	1000                	addi	s0,sp,32
    80003d34:	84aa                	mv	s1,a0
    80003d36:	00850913          	addi	s2,a0,8
    80003d3a:	854a                	mv	a0,s2
    80003d3c:	ec7fc0ef          	jal	80000c02 <acquire>
    80003d40:	409c                	lw	a5,0(s1)
    80003d42:	c799                	beqz	a5,80003d50 <acquiresleep+0x28>
    80003d44:	85ca                	mv	a1,s2
    80003d46:	8526                	mv	a0,s1
    80003d48:	974fe0ef          	jal	80001ebc <sleep>
    80003d4c:	409c                	lw	a5,0(s1)
    80003d4e:	fbfd                	bnez	a5,80003d44 <acquiresleep+0x1c>
    80003d50:	4785                	li	a5,1
    80003d52:	c09c                	sw	a5,0(s1)
    80003d54:	b9bfd0ef          	jal	800018ee <myproc>
    80003d58:	591c                	lw	a5,48(a0)
    80003d5a:	d49c                	sw	a5,40(s1)
    80003d5c:	854a                	mv	a0,s2
    80003d5e:	f3dfc0ef          	jal	80000c9a <release>
    80003d62:	60e2                	ld	ra,24(sp)
    80003d64:	6442                	ld	s0,16(sp)
    80003d66:	64a2                	ld	s1,8(sp)
    80003d68:	6902                	ld	s2,0(sp)
    80003d6a:	6105                	addi	sp,sp,32
    80003d6c:	8082                	ret

0000000080003d6e <releasesleep>:
    80003d6e:	1101                	addi	sp,sp,-32
    80003d70:	ec06                	sd	ra,24(sp)
    80003d72:	e822                	sd	s0,16(sp)
    80003d74:	e426                	sd	s1,8(sp)
    80003d76:	e04a                	sd	s2,0(sp)
    80003d78:	1000                	addi	s0,sp,32
    80003d7a:	84aa                	mv	s1,a0
    80003d7c:	00850913          	addi	s2,a0,8
    80003d80:	854a                	mv	a0,s2
    80003d82:	e81fc0ef          	jal	80000c02 <acquire>
    80003d86:	0004a023          	sw	zero,0(s1)
    80003d8a:	0204a423          	sw	zero,40(s1)
    80003d8e:	8526                	mv	a0,s1
    80003d90:	978fe0ef          	jal	80001f08 <wakeup>
    80003d94:	854a                	mv	a0,s2
    80003d96:	f05fc0ef          	jal	80000c9a <release>
    80003d9a:	60e2                	ld	ra,24(sp)
    80003d9c:	6442                	ld	s0,16(sp)
    80003d9e:	64a2                	ld	s1,8(sp)
    80003da0:	6902                	ld	s2,0(sp)
    80003da2:	6105                	addi	sp,sp,32
    80003da4:	8082                	ret

0000000080003da6 <holdingsleep>:
    80003da6:	7179                	addi	sp,sp,-48
    80003da8:	f406                	sd	ra,40(sp)
    80003daa:	f022                	sd	s0,32(sp)
    80003dac:	ec26                	sd	s1,24(sp)
    80003dae:	e84a                	sd	s2,16(sp)
    80003db0:	1800                	addi	s0,sp,48
    80003db2:	84aa                	mv	s1,a0
    80003db4:	00850913          	addi	s2,a0,8
    80003db8:	854a                	mv	a0,s2
    80003dba:	e49fc0ef          	jal	80000c02 <acquire>
    80003dbe:	409c                	lw	a5,0(s1)
    80003dc0:	ef81                	bnez	a5,80003dd8 <holdingsleep+0x32>
    80003dc2:	4481                	li	s1,0
    80003dc4:	854a                	mv	a0,s2
    80003dc6:	ed5fc0ef          	jal	80000c9a <release>
    80003dca:	8526                	mv	a0,s1
    80003dcc:	70a2                	ld	ra,40(sp)
    80003dce:	7402                	ld	s0,32(sp)
    80003dd0:	64e2                	ld	s1,24(sp)
    80003dd2:	6942                	ld	s2,16(sp)
    80003dd4:	6145                	addi	sp,sp,48
    80003dd6:	8082                	ret
    80003dd8:	e44e                	sd	s3,8(sp)
    80003dda:	0284a983          	lw	s3,40(s1)
    80003dde:	b11fd0ef          	jal	800018ee <myproc>
    80003de2:	5904                	lw	s1,48(a0)
    80003de4:	413484b3          	sub	s1,s1,s3
    80003de8:	0014b493          	seqz	s1,s1
    80003dec:	69a2                	ld	s3,8(sp)
    80003dee:	bfd9                	j	80003dc4 <holdingsleep+0x1e>

0000000080003df0 <fileinit>:
    80003df0:	1141                	addi	sp,sp,-16
    80003df2:	e406                	sd	ra,8(sp)
    80003df4:	e022                	sd	s0,0(sp)
    80003df6:	0800                	addi	s0,sp,16
    80003df8:	00003597          	auipc	a1,0x3
    80003dfc:	7c058593          	addi	a1,a1,1984 # 800075b8 <etext+0x5b8>
    80003e00:	0001e517          	auipc	a0,0x1e
    80003e04:	6e850513          	addi	a0,a0,1768 # 800224e8 <ftable>
    80003e08:	d7bfc0ef          	jal	80000b82 <initlock>
    80003e0c:	60a2                	ld	ra,8(sp)
    80003e0e:	6402                	ld	s0,0(sp)
    80003e10:	0141                	addi	sp,sp,16
    80003e12:	8082                	ret

0000000080003e14 <filealloc>:
    80003e14:	1101                	addi	sp,sp,-32
    80003e16:	ec06                	sd	ra,24(sp)
    80003e18:	e822                	sd	s0,16(sp)
    80003e1a:	e426                	sd	s1,8(sp)
    80003e1c:	1000                	addi	s0,sp,32
    80003e1e:	0001e517          	auipc	a0,0x1e
    80003e22:	6ca50513          	addi	a0,a0,1738 # 800224e8 <ftable>
    80003e26:	dddfc0ef          	jal	80000c02 <acquire>
    80003e2a:	0001e497          	auipc	s1,0x1e
    80003e2e:	6d648493          	addi	s1,s1,1750 # 80022500 <ftable+0x18>
    80003e32:	0001f717          	auipc	a4,0x1f
    80003e36:	66e70713          	addi	a4,a4,1646 # 800234a0 <disk>
    80003e3a:	40dc                	lw	a5,4(s1)
    80003e3c:	cf89                	beqz	a5,80003e56 <filealloc+0x42>
    80003e3e:	02848493          	addi	s1,s1,40
    80003e42:	fee49ce3          	bne	s1,a4,80003e3a <filealloc+0x26>
    80003e46:	0001e517          	auipc	a0,0x1e
    80003e4a:	6a250513          	addi	a0,a0,1698 # 800224e8 <ftable>
    80003e4e:	e4dfc0ef          	jal	80000c9a <release>
    80003e52:	4481                	li	s1,0
    80003e54:	a809                	j	80003e66 <filealloc+0x52>
    80003e56:	4785                	li	a5,1
    80003e58:	c0dc                	sw	a5,4(s1)
    80003e5a:	0001e517          	auipc	a0,0x1e
    80003e5e:	68e50513          	addi	a0,a0,1678 # 800224e8 <ftable>
    80003e62:	e39fc0ef          	jal	80000c9a <release>
    80003e66:	8526                	mv	a0,s1
    80003e68:	60e2                	ld	ra,24(sp)
    80003e6a:	6442                	ld	s0,16(sp)
    80003e6c:	64a2                	ld	s1,8(sp)
    80003e6e:	6105                	addi	sp,sp,32
    80003e70:	8082                	ret

0000000080003e72 <filedup>:
    80003e72:	1101                	addi	sp,sp,-32
    80003e74:	ec06                	sd	ra,24(sp)
    80003e76:	e822                	sd	s0,16(sp)
    80003e78:	e426                	sd	s1,8(sp)
    80003e7a:	1000                	addi	s0,sp,32
    80003e7c:	84aa                	mv	s1,a0
    80003e7e:	0001e517          	auipc	a0,0x1e
    80003e82:	66a50513          	addi	a0,a0,1642 # 800224e8 <ftable>
    80003e86:	d7dfc0ef          	jal	80000c02 <acquire>
    80003e8a:	40dc                	lw	a5,4(s1)
    80003e8c:	02f05063          	blez	a5,80003eac <filedup+0x3a>
    80003e90:	2785                	addiw	a5,a5,1
    80003e92:	c0dc                	sw	a5,4(s1)
    80003e94:	0001e517          	auipc	a0,0x1e
    80003e98:	65450513          	addi	a0,a0,1620 # 800224e8 <ftable>
    80003e9c:	dfffc0ef          	jal	80000c9a <release>
    80003ea0:	8526                	mv	a0,s1
    80003ea2:	60e2                	ld	ra,24(sp)
    80003ea4:	6442                	ld	s0,16(sp)
    80003ea6:	64a2                	ld	s1,8(sp)
    80003ea8:	6105                	addi	sp,sp,32
    80003eaa:	8082                	ret
    80003eac:	00003517          	auipc	a0,0x3
    80003eb0:	71450513          	addi	a0,a0,1812 # 800075c0 <etext+0x5c0>
    80003eb4:	8effc0ef          	jal	800007a2 <panic>

0000000080003eb8 <fileclose>:
    80003eb8:	7139                	addi	sp,sp,-64
    80003eba:	fc06                	sd	ra,56(sp)
    80003ebc:	f822                	sd	s0,48(sp)
    80003ebe:	f426                	sd	s1,40(sp)
    80003ec0:	0080                	addi	s0,sp,64
    80003ec2:	84aa                	mv	s1,a0
    80003ec4:	0001e517          	auipc	a0,0x1e
    80003ec8:	62450513          	addi	a0,a0,1572 # 800224e8 <ftable>
    80003ecc:	d37fc0ef          	jal	80000c02 <acquire>
    80003ed0:	40dc                	lw	a5,4(s1)
    80003ed2:	04f05a63          	blez	a5,80003f26 <fileclose+0x6e>
    80003ed6:	37fd                	addiw	a5,a5,-1
    80003ed8:	0007871b          	sext.w	a4,a5
    80003edc:	c0dc                	sw	a5,4(s1)
    80003ede:	04e04e63          	bgtz	a4,80003f3a <fileclose+0x82>
    80003ee2:	f04a                	sd	s2,32(sp)
    80003ee4:	ec4e                	sd	s3,24(sp)
    80003ee6:	e852                	sd	s4,16(sp)
    80003ee8:	e456                	sd	s5,8(sp)
    80003eea:	0004a903          	lw	s2,0(s1)
    80003eee:	0094ca83          	lbu	s5,9(s1)
    80003ef2:	0104ba03          	ld	s4,16(s1)
    80003ef6:	0184b983          	ld	s3,24(s1)
    80003efa:	0004a223          	sw	zero,4(s1)
    80003efe:	0004a023          	sw	zero,0(s1)
    80003f02:	0001e517          	auipc	a0,0x1e
    80003f06:	5e650513          	addi	a0,a0,1510 # 800224e8 <ftable>
    80003f0a:	d91fc0ef          	jal	80000c9a <release>
    80003f0e:	4785                	li	a5,1
    80003f10:	04f90063          	beq	s2,a5,80003f50 <fileclose+0x98>
    80003f14:	3979                	addiw	s2,s2,-2
    80003f16:	4785                	li	a5,1
    80003f18:	0527f563          	bgeu	a5,s2,80003f62 <fileclose+0xaa>
    80003f1c:	7902                	ld	s2,32(sp)
    80003f1e:	69e2                	ld	s3,24(sp)
    80003f20:	6a42                	ld	s4,16(sp)
    80003f22:	6aa2                	ld	s5,8(sp)
    80003f24:	a00d                	j	80003f46 <fileclose+0x8e>
    80003f26:	f04a                	sd	s2,32(sp)
    80003f28:	ec4e                	sd	s3,24(sp)
    80003f2a:	e852                	sd	s4,16(sp)
    80003f2c:	e456                	sd	s5,8(sp)
    80003f2e:	00003517          	auipc	a0,0x3
    80003f32:	69a50513          	addi	a0,a0,1690 # 800075c8 <etext+0x5c8>
    80003f36:	86dfc0ef          	jal	800007a2 <panic>
    80003f3a:	0001e517          	auipc	a0,0x1e
    80003f3e:	5ae50513          	addi	a0,a0,1454 # 800224e8 <ftable>
    80003f42:	d59fc0ef          	jal	80000c9a <release>
    80003f46:	70e2                	ld	ra,56(sp)
    80003f48:	7442                	ld	s0,48(sp)
    80003f4a:	74a2                	ld	s1,40(sp)
    80003f4c:	6121                	addi	sp,sp,64
    80003f4e:	8082                	ret
    80003f50:	85d6                	mv	a1,s5
    80003f52:	8552                	mv	a0,s4
    80003f54:	336000ef          	jal	8000428a <pipeclose>
    80003f58:	7902                	ld	s2,32(sp)
    80003f5a:	69e2                	ld	s3,24(sp)
    80003f5c:	6a42                	ld	s4,16(sp)
    80003f5e:	6aa2                	ld	s5,8(sp)
    80003f60:	b7dd                	j	80003f46 <fileclose+0x8e>
    80003f62:	b3dff0ef          	jal	80003a9e <begin_op>
    80003f66:	854e                	mv	a0,s3
    80003f68:	c22ff0ef          	jal	8000338a <iput>
    80003f6c:	b9dff0ef          	jal	80003b08 <end_op>
    80003f70:	7902                	ld	s2,32(sp)
    80003f72:	69e2                	ld	s3,24(sp)
    80003f74:	6a42                	ld	s4,16(sp)
    80003f76:	6aa2                	ld	s5,8(sp)
    80003f78:	b7f9                	j	80003f46 <fileclose+0x8e>

0000000080003f7a <filestat>:
    80003f7a:	715d                	addi	sp,sp,-80
    80003f7c:	e486                	sd	ra,72(sp)
    80003f7e:	e0a2                	sd	s0,64(sp)
    80003f80:	fc26                	sd	s1,56(sp)
    80003f82:	f44e                	sd	s3,40(sp)
    80003f84:	0880                	addi	s0,sp,80
    80003f86:	84aa                	mv	s1,a0
    80003f88:	89ae                	mv	s3,a1
    80003f8a:	965fd0ef          	jal	800018ee <myproc>
    80003f8e:	409c                	lw	a5,0(s1)
    80003f90:	37f9                	addiw	a5,a5,-2
    80003f92:	4705                	li	a4,1
    80003f94:	04f76063          	bltu	a4,a5,80003fd4 <filestat+0x5a>
    80003f98:	f84a                	sd	s2,48(sp)
    80003f9a:	892a                	mv	s2,a0
    80003f9c:	6c88                	ld	a0,24(s1)
    80003f9e:	a6aff0ef          	jal	80003208 <ilock>
    80003fa2:	fb840593          	addi	a1,s0,-72
    80003fa6:	6c88                	ld	a0,24(s1)
    80003fa8:	c8aff0ef          	jal	80003432 <stati>
    80003fac:	6c88                	ld	a0,24(s1)
    80003fae:	b08ff0ef          	jal	800032b6 <iunlock>
    80003fb2:	46e1                	li	a3,24
    80003fb4:	fb840613          	addi	a2,s0,-72
    80003fb8:	85ce                	mv	a1,s3
    80003fba:	05093503          	ld	a0,80(s2)
    80003fbe:	da2fd0ef          	jal	80001560 <copyout>
    80003fc2:	41f5551b          	sraiw	a0,a0,0x1f
    80003fc6:	7942                	ld	s2,48(sp)
    80003fc8:	60a6                	ld	ra,72(sp)
    80003fca:	6406                	ld	s0,64(sp)
    80003fcc:	74e2                	ld	s1,56(sp)
    80003fce:	79a2                	ld	s3,40(sp)
    80003fd0:	6161                	addi	sp,sp,80
    80003fd2:	8082                	ret
    80003fd4:	557d                	li	a0,-1
    80003fd6:	bfcd                	j	80003fc8 <filestat+0x4e>

0000000080003fd8 <fileread>:
    80003fd8:	7179                	addi	sp,sp,-48
    80003fda:	f406                	sd	ra,40(sp)
    80003fdc:	f022                	sd	s0,32(sp)
    80003fde:	e84a                	sd	s2,16(sp)
    80003fe0:	1800                	addi	s0,sp,48
    80003fe2:	00854783          	lbu	a5,8(a0)
    80003fe6:	cfd1                	beqz	a5,80004082 <fileread+0xaa>
    80003fe8:	ec26                	sd	s1,24(sp)
    80003fea:	e44e                	sd	s3,8(sp)
    80003fec:	84aa                	mv	s1,a0
    80003fee:	89ae                	mv	s3,a1
    80003ff0:	8932                	mv	s2,a2
    80003ff2:	411c                	lw	a5,0(a0)
    80003ff4:	4705                	li	a4,1
    80003ff6:	04e78363          	beq	a5,a4,8000403c <fileread+0x64>
    80003ffa:	470d                	li	a4,3
    80003ffc:	04e78763          	beq	a5,a4,8000404a <fileread+0x72>
    80004000:	4709                	li	a4,2
    80004002:	06e79a63          	bne	a5,a4,80004076 <fileread+0x9e>
    80004006:	6d08                	ld	a0,24(a0)
    80004008:	a00ff0ef          	jal	80003208 <ilock>
    8000400c:	874a                	mv	a4,s2
    8000400e:	5094                	lw	a3,32(s1)
    80004010:	864e                	mv	a2,s3
    80004012:	4585                	li	a1,1
    80004014:	6c88                	ld	a0,24(s1)
    80004016:	c46ff0ef          	jal	8000345c <readi>
    8000401a:	892a                	mv	s2,a0
    8000401c:	00a05563          	blez	a0,80004026 <fileread+0x4e>
    80004020:	509c                	lw	a5,32(s1)
    80004022:	9fa9                	addw	a5,a5,a0
    80004024:	d09c                	sw	a5,32(s1)
    80004026:	6c88                	ld	a0,24(s1)
    80004028:	a8eff0ef          	jal	800032b6 <iunlock>
    8000402c:	64e2                	ld	s1,24(sp)
    8000402e:	69a2                	ld	s3,8(sp)
    80004030:	854a                	mv	a0,s2
    80004032:	70a2                	ld	ra,40(sp)
    80004034:	7402                	ld	s0,32(sp)
    80004036:	6942                	ld	s2,16(sp)
    80004038:	6145                	addi	sp,sp,48
    8000403a:	8082                	ret
    8000403c:	6908                	ld	a0,16(a0)
    8000403e:	388000ef          	jal	800043c6 <piperead>
    80004042:	892a                	mv	s2,a0
    80004044:	64e2                	ld	s1,24(sp)
    80004046:	69a2                	ld	s3,8(sp)
    80004048:	b7e5                	j	80004030 <fileread+0x58>
    8000404a:	02451783          	lh	a5,36(a0)
    8000404e:	03079693          	slli	a3,a5,0x30
    80004052:	92c1                	srli	a3,a3,0x30
    80004054:	4725                	li	a4,9
    80004056:	02d76863          	bltu	a4,a3,80004086 <fileread+0xae>
    8000405a:	0792                	slli	a5,a5,0x4
    8000405c:	0001e717          	auipc	a4,0x1e
    80004060:	3ec70713          	addi	a4,a4,1004 # 80022448 <devsw>
    80004064:	97ba                	add	a5,a5,a4
    80004066:	639c                	ld	a5,0(a5)
    80004068:	c39d                	beqz	a5,8000408e <fileread+0xb6>
    8000406a:	4505                	li	a0,1
    8000406c:	9782                	jalr	a5
    8000406e:	892a                	mv	s2,a0
    80004070:	64e2                	ld	s1,24(sp)
    80004072:	69a2                	ld	s3,8(sp)
    80004074:	bf75                	j	80004030 <fileread+0x58>
    80004076:	00003517          	auipc	a0,0x3
    8000407a:	56250513          	addi	a0,a0,1378 # 800075d8 <etext+0x5d8>
    8000407e:	f24fc0ef          	jal	800007a2 <panic>
    80004082:	597d                	li	s2,-1
    80004084:	b775                	j	80004030 <fileread+0x58>
    80004086:	597d                	li	s2,-1
    80004088:	64e2                	ld	s1,24(sp)
    8000408a:	69a2                	ld	s3,8(sp)
    8000408c:	b755                	j	80004030 <fileread+0x58>
    8000408e:	597d                	li	s2,-1
    80004090:	64e2                	ld	s1,24(sp)
    80004092:	69a2                	ld	s3,8(sp)
    80004094:	bf71                	j	80004030 <fileread+0x58>

0000000080004096 <filewrite>:
    80004096:	00954783          	lbu	a5,9(a0)
    8000409a:	10078b63          	beqz	a5,800041b0 <filewrite+0x11a>
    8000409e:	715d                	addi	sp,sp,-80
    800040a0:	e486                	sd	ra,72(sp)
    800040a2:	e0a2                	sd	s0,64(sp)
    800040a4:	f84a                	sd	s2,48(sp)
    800040a6:	f052                	sd	s4,32(sp)
    800040a8:	e85a                	sd	s6,16(sp)
    800040aa:	0880                	addi	s0,sp,80
    800040ac:	892a                	mv	s2,a0
    800040ae:	8b2e                	mv	s6,a1
    800040b0:	8a32                	mv	s4,a2
    800040b2:	411c                	lw	a5,0(a0)
    800040b4:	4705                	li	a4,1
    800040b6:	02e78763          	beq	a5,a4,800040e4 <filewrite+0x4e>
    800040ba:	470d                	li	a4,3
    800040bc:	02e78863          	beq	a5,a4,800040ec <filewrite+0x56>
    800040c0:	4709                	li	a4,2
    800040c2:	0ce79c63          	bne	a5,a4,8000419a <filewrite+0x104>
    800040c6:	f44e                	sd	s3,40(sp)
    800040c8:	0ac05863          	blez	a2,80004178 <filewrite+0xe2>
    800040cc:	fc26                	sd	s1,56(sp)
    800040ce:	ec56                	sd	s5,24(sp)
    800040d0:	e45e                	sd	s7,8(sp)
    800040d2:	e062                	sd	s8,0(sp)
    800040d4:	4981                	li	s3,0
    800040d6:	6b85                	lui	s7,0x1
    800040d8:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800040dc:	6c05                	lui	s8,0x1
    800040de:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800040e2:	a8b5                	j	8000415e <filewrite+0xc8>
    800040e4:	6908                	ld	a0,16(a0)
    800040e6:	1fc000ef          	jal	800042e2 <pipewrite>
    800040ea:	a04d                	j	8000418c <filewrite+0xf6>
    800040ec:	02451783          	lh	a5,36(a0)
    800040f0:	03079693          	slli	a3,a5,0x30
    800040f4:	92c1                	srli	a3,a3,0x30
    800040f6:	4725                	li	a4,9
    800040f8:	0ad76e63          	bltu	a4,a3,800041b4 <filewrite+0x11e>
    800040fc:	0792                	slli	a5,a5,0x4
    800040fe:	0001e717          	auipc	a4,0x1e
    80004102:	34a70713          	addi	a4,a4,842 # 80022448 <devsw>
    80004106:	97ba                	add	a5,a5,a4
    80004108:	679c                	ld	a5,8(a5)
    8000410a:	c7dd                	beqz	a5,800041b8 <filewrite+0x122>
    8000410c:	4505                	li	a0,1
    8000410e:	9782                	jalr	a5
    80004110:	a8b5                	j	8000418c <filewrite+0xf6>
    80004112:	00048a9b          	sext.w	s5,s1
    80004116:	989ff0ef          	jal	80003a9e <begin_op>
    8000411a:	01893503          	ld	a0,24(s2)
    8000411e:	8eaff0ef          	jal	80003208 <ilock>
    80004122:	8756                	mv	a4,s5
    80004124:	02092683          	lw	a3,32(s2)
    80004128:	01698633          	add	a2,s3,s6
    8000412c:	4585                	li	a1,1
    8000412e:	01893503          	ld	a0,24(s2)
    80004132:	c26ff0ef          	jal	80003558 <writei>
    80004136:	84aa                	mv	s1,a0
    80004138:	00a05763          	blez	a0,80004146 <filewrite+0xb0>
    8000413c:	02092783          	lw	a5,32(s2)
    80004140:	9fa9                	addw	a5,a5,a0
    80004142:	02f92023          	sw	a5,32(s2)
    80004146:	01893503          	ld	a0,24(s2)
    8000414a:	96cff0ef          	jal	800032b6 <iunlock>
    8000414e:	9bbff0ef          	jal	80003b08 <end_op>
    80004152:	029a9563          	bne	s5,s1,8000417c <filewrite+0xe6>
    80004156:	013489bb          	addw	s3,s1,s3
    8000415a:	0149da63          	bge	s3,s4,8000416e <filewrite+0xd8>
    8000415e:	413a04bb          	subw	s1,s4,s3
    80004162:	0004879b          	sext.w	a5,s1
    80004166:	fafbd6e3          	bge	s7,a5,80004112 <filewrite+0x7c>
    8000416a:	84e2                	mv	s1,s8
    8000416c:	b75d                	j	80004112 <filewrite+0x7c>
    8000416e:	74e2                	ld	s1,56(sp)
    80004170:	6ae2                	ld	s5,24(sp)
    80004172:	6ba2                	ld	s7,8(sp)
    80004174:	6c02                	ld	s8,0(sp)
    80004176:	a039                	j	80004184 <filewrite+0xee>
    80004178:	4981                	li	s3,0
    8000417a:	a029                	j	80004184 <filewrite+0xee>
    8000417c:	74e2                	ld	s1,56(sp)
    8000417e:	6ae2                	ld	s5,24(sp)
    80004180:	6ba2                	ld	s7,8(sp)
    80004182:	6c02                	ld	s8,0(sp)
    80004184:	033a1c63          	bne	s4,s3,800041bc <filewrite+0x126>
    80004188:	8552                	mv	a0,s4
    8000418a:	79a2                	ld	s3,40(sp)
    8000418c:	60a6                	ld	ra,72(sp)
    8000418e:	6406                	ld	s0,64(sp)
    80004190:	7942                	ld	s2,48(sp)
    80004192:	7a02                	ld	s4,32(sp)
    80004194:	6b42                	ld	s6,16(sp)
    80004196:	6161                	addi	sp,sp,80
    80004198:	8082                	ret
    8000419a:	fc26                	sd	s1,56(sp)
    8000419c:	f44e                	sd	s3,40(sp)
    8000419e:	ec56                	sd	s5,24(sp)
    800041a0:	e45e                	sd	s7,8(sp)
    800041a2:	e062                	sd	s8,0(sp)
    800041a4:	00003517          	auipc	a0,0x3
    800041a8:	44450513          	addi	a0,a0,1092 # 800075e8 <etext+0x5e8>
    800041ac:	df6fc0ef          	jal	800007a2 <panic>
    800041b0:	557d                	li	a0,-1
    800041b2:	8082                	ret
    800041b4:	557d                	li	a0,-1
    800041b6:	bfd9                	j	8000418c <filewrite+0xf6>
    800041b8:	557d                	li	a0,-1
    800041ba:	bfc9                	j	8000418c <filewrite+0xf6>
    800041bc:	557d                	li	a0,-1
    800041be:	79a2                	ld	s3,40(sp)
    800041c0:	b7f1                	j	8000418c <filewrite+0xf6>

00000000800041c2 <pipealloc>:
    800041c2:	7179                	addi	sp,sp,-48
    800041c4:	f406                	sd	ra,40(sp)
    800041c6:	f022                	sd	s0,32(sp)
    800041c8:	ec26                	sd	s1,24(sp)
    800041ca:	e052                	sd	s4,0(sp)
    800041cc:	1800                	addi	s0,sp,48
    800041ce:	84aa                	mv	s1,a0
    800041d0:	8a2e                	mv	s4,a1
    800041d2:	0005b023          	sd	zero,0(a1)
    800041d6:	00053023          	sd	zero,0(a0)
    800041da:	c3bff0ef          	jal	80003e14 <filealloc>
    800041de:	e088                	sd	a0,0(s1)
    800041e0:	c549                	beqz	a0,8000426a <pipealloc+0xa8>
    800041e2:	c33ff0ef          	jal	80003e14 <filealloc>
    800041e6:	00aa3023          	sd	a0,0(s4)
    800041ea:	cd25                	beqz	a0,80004262 <pipealloc+0xa0>
    800041ec:	e84a                	sd	s2,16(sp)
    800041ee:	945fc0ef          	jal	80000b32 <kalloc>
    800041f2:	892a                	mv	s2,a0
    800041f4:	c12d                	beqz	a0,80004256 <pipealloc+0x94>
    800041f6:	e44e                	sd	s3,8(sp)
    800041f8:	4985                	li	s3,1
    800041fa:	23352023          	sw	s3,544(a0)
    800041fe:	23352223          	sw	s3,548(a0)
    80004202:	20052e23          	sw	zero,540(a0)
    80004206:	20052c23          	sw	zero,536(a0)
    8000420a:	00003597          	auipc	a1,0x3
    8000420e:	3ee58593          	addi	a1,a1,1006 # 800075f8 <etext+0x5f8>
    80004212:	971fc0ef          	jal	80000b82 <initlock>
    80004216:	609c                	ld	a5,0(s1)
    80004218:	0137a023          	sw	s3,0(a5)
    8000421c:	609c                	ld	a5,0(s1)
    8000421e:	01378423          	sb	s3,8(a5)
    80004222:	609c                	ld	a5,0(s1)
    80004224:	000784a3          	sb	zero,9(a5)
    80004228:	609c                	ld	a5,0(s1)
    8000422a:	0127b823          	sd	s2,16(a5)
    8000422e:	000a3783          	ld	a5,0(s4)
    80004232:	0137a023          	sw	s3,0(a5)
    80004236:	000a3783          	ld	a5,0(s4)
    8000423a:	00078423          	sb	zero,8(a5)
    8000423e:	000a3783          	ld	a5,0(s4)
    80004242:	013784a3          	sb	s3,9(a5)
    80004246:	000a3783          	ld	a5,0(s4)
    8000424a:	0127b823          	sd	s2,16(a5)
    8000424e:	4501                	li	a0,0
    80004250:	6942                	ld	s2,16(sp)
    80004252:	69a2                	ld	s3,8(sp)
    80004254:	a01d                	j	8000427a <pipealloc+0xb8>
    80004256:	6088                	ld	a0,0(s1)
    80004258:	c119                	beqz	a0,8000425e <pipealloc+0x9c>
    8000425a:	6942                	ld	s2,16(sp)
    8000425c:	a029                	j	80004266 <pipealloc+0xa4>
    8000425e:	6942                	ld	s2,16(sp)
    80004260:	a029                	j	8000426a <pipealloc+0xa8>
    80004262:	6088                	ld	a0,0(s1)
    80004264:	c10d                	beqz	a0,80004286 <pipealloc+0xc4>
    80004266:	c53ff0ef          	jal	80003eb8 <fileclose>
    8000426a:	000a3783          	ld	a5,0(s4)
    8000426e:	557d                	li	a0,-1
    80004270:	c789                	beqz	a5,8000427a <pipealloc+0xb8>
    80004272:	853e                	mv	a0,a5
    80004274:	c45ff0ef          	jal	80003eb8 <fileclose>
    80004278:	557d                	li	a0,-1
    8000427a:	70a2                	ld	ra,40(sp)
    8000427c:	7402                	ld	s0,32(sp)
    8000427e:	64e2                	ld	s1,24(sp)
    80004280:	6a02                	ld	s4,0(sp)
    80004282:	6145                	addi	sp,sp,48
    80004284:	8082                	ret
    80004286:	557d                	li	a0,-1
    80004288:	bfcd                	j	8000427a <pipealloc+0xb8>

000000008000428a <pipeclose>:
    8000428a:	1101                	addi	sp,sp,-32
    8000428c:	ec06                	sd	ra,24(sp)
    8000428e:	e822                	sd	s0,16(sp)
    80004290:	e426                	sd	s1,8(sp)
    80004292:	e04a                	sd	s2,0(sp)
    80004294:	1000                	addi	s0,sp,32
    80004296:	84aa                	mv	s1,a0
    80004298:	892e                	mv	s2,a1
    8000429a:	969fc0ef          	jal	80000c02 <acquire>
    8000429e:	02090763          	beqz	s2,800042cc <pipeclose+0x42>
    800042a2:	2204a223          	sw	zero,548(s1)
    800042a6:	21848513          	addi	a0,s1,536
    800042aa:	c5ffd0ef          	jal	80001f08 <wakeup>
    800042ae:	2204b783          	ld	a5,544(s1)
    800042b2:	e785                	bnez	a5,800042da <pipeclose+0x50>
    800042b4:	8526                	mv	a0,s1
    800042b6:	9e5fc0ef          	jal	80000c9a <release>
    800042ba:	8526                	mv	a0,s1
    800042bc:	f94fc0ef          	jal	80000a50 <kfree>
    800042c0:	60e2                	ld	ra,24(sp)
    800042c2:	6442                	ld	s0,16(sp)
    800042c4:	64a2                	ld	s1,8(sp)
    800042c6:	6902                	ld	s2,0(sp)
    800042c8:	6105                	addi	sp,sp,32
    800042ca:	8082                	ret
    800042cc:	2204a023          	sw	zero,544(s1)
    800042d0:	21c48513          	addi	a0,s1,540
    800042d4:	c35fd0ef          	jal	80001f08 <wakeup>
    800042d8:	bfd9                	j	800042ae <pipeclose+0x24>
    800042da:	8526                	mv	a0,s1
    800042dc:	9bffc0ef          	jal	80000c9a <release>
    800042e0:	b7c5                	j	800042c0 <pipeclose+0x36>

00000000800042e2 <pipewrite>:
    800042e2:	711d                	addi	sp,sp,-96
    800042e4:	ec86                	sd	ra,88(sp)
    800042e6:	e8a2                	sd	s0,80(sp)
    800042e8:	e4a6                	sd	s1,72(sp)
    800042ea:	e0ca                	sd	s2,64(sp)
    800042ec:	fc4e                	sd	s3,56(sp)
    800042ee:	f852                	sd	s4,48(sp)
    800042f0:	f456                	sd	s5,40(sp)
    800042f2:	1080                	addi	s0,sp,96
    800042f4:	84aa                	mv	s1,a0
    800042f6:	8aae                	mv	s5,a1
    800042f8:	8a32                	mv	s4,a2
    800042fa:	df4fd0ef          	jal	800018ee <myproc>
    800042fe:	89aa                	mv	s3,a0
    80004300:	8526                	mv	a0,s1
    80004302:	901fc0ef          	jal	80000c02 <acquire>
    80004306:	0b405a63          	blez	s4,800043ba <pipewrite+0xd8>
    8000430a:	f05a                	sd	s6,32(sp)
    8000430c:	ec5e                	sd	s7,24(sp)
    8000430e:	e862                	sd	s8,16(sp)
    80004310:	4901                	li	s2,0
    80004312:	5b7d                	li	s6,-1
    80004314:	21848c13          	addi	s8,s1,536
    80004318:	21c48b93          	addi	s7,s1,540
    8000431c:	a81d                	j	80004352 <pipewrite+0x70>
    8000431e:	8526                	mv	a0,s1
    80004320:	97bfc0ef          	jal	80000c9a <release>
    80004324:	597d                	li	s2,-1
    80004326:	7b02                	ld	s6,32(sp)
    80004328:	6be2                	ld	s7,24(sp)
    8000432a:	6c42                	ld	s8,16(sp)
    8000432c:	854a                	mv	a0,s2
    8000432e:	60e6                	ld	ra,88(sp)
    80004330:	6446                	ld	s0,80(sp)
    80004332:	64a6                	ld	s1,72(sp)
    80004334:	6906                	ld	s2,64(sp)
    80004336:	79e2                	ld	s3,56(sp)
    80004338:	7a42                	ld	s4,48(sp)
    8000433a:	7aa2                	ld	s5,40(sp)
    8000433c:	6125                	addi	sp,sp,96
    8000433e:	8082                	ret
    80004340:	8562                	mv	a0,s8
    80004342:	bc7fd0ef          	jal	80001f08 <wakeup>
    80004346:	85a6                	mv	a1,s1
    80004348:	855e                	mv	a0,s7
    8000434a:	b73fd0ef          	jal	80001ebc <sleep>
    8000434e:	05495b63          	bge	s2,s4,800043a4 <pipewrite+0xc2>
    80004352:	2204a783          	lw	a5,544(s1)
    80004356:	d7e1                	beqz	a5,8000431e <pipewrite+0x3c>
    80004358:	854e                	mv	a0,s3
    8000435a:	d9bfd0ef          	jal	800020f4 <killed>
    8000435e:	f161                	bnez	a0,8000431e <pipewrite+0x3c>
    80004360:	2184a783          	lw	a5,536(s1)
    80004364:	21c4a703          	lw	a4,540(s1)
    80004368:	2007879b          	addiw	a5,a5,512
    8000436c:	fcf70ae3          	beq	a4,a5,80004340 <pipewrite+0x5e>
    80004370:	4685                	li	a3,1
    80004372:	01590633          	add	a2,s2,s5
    80004376:	faf40593          	addi	a1,s0,-81
    8000437a:	0509b503          	ld	a0,80(s3)
    8000437e:	ab8fd0ef          	jal	80001636 <copyin>
    80004382:	03650e63          	beq	a0,s6,800043be <pipewrite+0xdc>
    80004386:	21c4a783          	lw	a5,540(s1)
    8000438a:	0017871b          	addiw	a4,a5,1
    8000438e:	20e4ae23          	sw	a4,540(s1)
    80004392:	1ff7f793          	andi	a5,a5,511
    80004396:	97a6                	add	a5,a5,s1
    80004398:	faf44703          	lbu	a4,-81(s0)
    8000439c:	00e78c23          	sb	a4,24(a5)
    800043a0:	2905                	addiw	s2,s2,1
    800043a2:	b775                	j	8000434e <pipewrite+0x6c>
    800043a4:	7b02                	ld	s6,32(sp)
    800043a6:	6be2                	ld	s7,24(sp)
    800043a8:	6c42                	ld	s8,16(sp)
    800043aa:	21848513          	addi	a0,s1,536
    800043ae:	b5bfd0ef          	jal	80001f08 <wakeup>
    800043b2:	8526                	mv	a0,s1
    800043b4:	8e7fc0ef          	jal	80000c9a <release>
    800043b8:	bf95                	j	8000432c <pipewrite+0x4a>
    800043ba:	4901                	li	s2,0
    800043bc:	b7fd                	j	800043aa <pipewrite+0xc8>
    800043be:	7b02                	ld	s6,32(sp)
    800043c0:	6be2                	ld	s7,24(sp)
    800043c2:	6c42                	ld	s8,16(sp)
    800043c4:	b7dd                	j	800043aa <pipewrite+0xc8>

00000000800043c6 <piperead>:
    800043c6:	715d                	addi	sp,sp,-80
    800043c8:	e486                	sd	ra,72(sp)
    800043ca:	e0a2                	sd	s0,64(sp)
    800043cc:	fc26                	sd	s1,56(sp)
    800043ce:	f84a                	sd	s2,48(sp)
    800043d0:	f44e                	sd	s3,40(sp)
    800043d2:	f052                	sd	s4,32(sp)
    800043d4:	ec56                	sd	s5,24(sp)
    800043d6:	0880                	addi	s0,sp,80
    800043d8:	84aa                	mv	s1,a0
    800043da:	892e                	mv	s2,a1
    800043dc:	8ab2                	mv	s5,a2
    800043de:	d10fd0ef          	jal	800018ee <myproc>
    800043e2:	8a2a                	mv	s4,a0
    800043e4:	8526                	mv	a0,s1
    800043e6:	81dfc0ef          	jal	80000c02 <acquire>
    800043ea:	2184a703          	lw	a4,536(s1)
    800043ee:	21c4a783          	lw	a5,540(s1)
    800043f2:	21848993          	addi	s3,s1,536
    800043f6:	02f71563          	bne	a4,a5,80004420 <piperead+0x5a>
    800043fa:	2244a783          	lw	a5,548(s1)
    800043fe:	cb85                	beqz	a5,8000442e <piperead+0x68>
    80004400:	8552                	mv	a0,s4
    80004402:	cf3fd0ef          	jal	800020f4 <killed>
    80004406:	ed19                	bnez	a0,80004424 <piperead+0x5e>
    80004408:	85a6                	mv	a1,s1
    8000440a:	854e                	mv	a0,s3
    8000440c:	ab1fd0ef          	jal	80001ebc <sleep>
    80004410:	2184a703          	lw	a4,536(s1)
    80004414:	21c4a783          	lw	a5,540(s1)
    80004418:	fef701e3          	beq	a4,a5,800043fa <piperead+0x34>
    8000441c:	e85a                	sd	s6,16(sp)
    8000441e:	a809                	j	80004430 <piperead+0x6a>
    80004420:	e85a                	sd	s6,16(sp)
    80004422:	a039                	j	80004430 <piperead+0x6a>
    80004424:	8526                	mv	a0,s1
    80004426:	875fc0ef          	jal	80000c9a <release>
    8000442a:	59fd                	li	s3,-1
    8000442c:	a8b1                	j	80004488 <piperead+0xc2>
    8000442e:	e85a                	sd	s6,16(sp)
    80004430:	4981                	li	s3,0
    80004432:	5b7d                	li	s6,-1
    80004434:	05505263          	blez	s5,80004478 <piperead+0xb2>
    80004438:	2184a783          	lw	a5,536(s1)
    8000443c:	21c4a703          	lw	a4,540(s1)
    80004440:	02f70c63          	beq	a4,a5,80004478 <piperead+0xb2>
    80004444:	0017871b          	addiw	a4,a5,1
    80004448:	20e4ac23          	sw	a4,536(s1)
    8000444c:	1ff7f793          	andi	a5,a5,511
    80004450:	97a6                	add	a5,a5,s1
    80004452:	0187c783          	lbu	a5,24(a5)
    80004456:	faf40fa3          	sb	a5,-65(s0)
    8000445a:	4685                	li	a3,1
    8000445c:	fbf40613          	addi	a2,s0,-65
    80004460:	85ca                	mv	a1,s2
    80004462:	050a3503          	ld	a0,80(s4)
    80004466:	8fafd0ef          	jal	80001560 <copyout>
    8000446a:	01650763          	beq	a0,s6,80004478 <piperead+0xb2>
    8000446e:	2985                	addiw	s3,s3,1
    80004470:	0905                	addi	s2,s2,1
    80004472:	fd3a93e3          	bne	s5,s3,80004438 <piperead+0x72>
    80004476:	89d6                	mv	s3,s5
    80004478:	21c48513          	addi	a0,s1,540
    8000447c:	a8dfd0ef          	jal	80001f08 <wakeup>
    80004480:	8526                	mv	a0,s1
    80004482:	819fc0ef          	jal	80000c9a <release>
    80004486:	6b42                	ld	s6,16(sp)
    80004488:	854e                	mv	a0,s3
    8000448a:	60a6                	ld	ra,72(sp)
    8000448c:	6406                	ld	s0,64(sp)
    8000448e:	74e2                	ld	s1,56(sp)
    80004490:	7942                	ld	s2,48(sp)
    80004492:	79a2                	ld	s3,40(sp)
    80004494:	7a02                	ld	s4,32(sp)
    80004496:	6ae2                	ld	s5,24(sp)
    80004498:	6161                	addi	sp,sp,80
    8000449a:	8082                	ret

000000008000449c <flags2perm>:
    8000449c:	1141                	addi	sp,sp,-16
    8000449e:	e422                	sd	s0,8(sp)
    800044a0:	0800                	addi	s0,sp,16
    800044a2:	87aa                	mv	a5,a0
    800044a4:	8905                	andi	a0,a0,1
    800044a6:	050e                	slli	a0,a0,0x3
    800044a8:	8b89                	andi	a5,a5,2
    800044aa:	c399                	beqz	a5,800044b0 <flags2perm+0x14>
    800044ac:	00456513          	ori	a0,a0,4
    800044b0:	6422                	ld	s0,8(sp)
    800044b2:	0141                	addi	sp,sp,16
    800044b4:	8082                	ret

00000000800044b6 <exec>:
    800044b6:	df010113          	addi	sp,sp,-528
    800044ba:	20113423          	sd	ra,520(sp)
    800044be:	20813023          	sd	s0,512(sp)
    800044c2:	ffa6                	sd	s1,504(sp)
    800044c4:	fbca                	sd	s2,496(sp)
    800044c6:	0c00                	addi	s0,sp,528
    800044c8:	892a                	mv	s2,a0
    800044ca:	dea43c23          	sd	a0,-520(s0)
    800044ce:	e0b43023          	sd	a1,-512(s0)
    800044d2:	c1cfd0ef          	jal	800018ee <myproc>
    800044d6:	84aa                	mv	s1,a0
    800044d8:	dc6ff0ef          	jal	80003a9e <begin_op>
    800044dc:	854a                	mv	a0,s2
    800044de:	c04ff0ef          	jal	800038e2 <namei>
    800044e2:	c931                	beqz	a0,80004536 <exec+0x80>
    800044e4:	f3d2                	sd	s4,480(sp)
    800044e6:	8a2a                	mv	s4,a0
    800044e8:	d21fe0ef          	jal	80003208 <ilock>
    800044ec:	04000713          	li	a4,64
    800044f0:	4681                	li	a3,0
    800044f2:	e5040613          	addi	a2,s0,-432
    800044f6:	4581                	li	a1,0
    800044f8:	8552                	mv	a0,s4
    800044fa:	f63fe0ef          	jal	8000345c <readi>
    800044fe:	04000793          	li	a5,64
    80004502:	00f51a63          	bne	a0,a5,80004516 <exec+0x60>
    80004506:	e5042703          	lw	a4,-432(s0)
    8000450a:	464c47b7          	lui	a5,0x464c4
    8000450e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004512:	02f70663          	beq	a4,a5,8000453e <exec+0x88>
    80004516:	8552                	mv	a0,s4
    80004518:	efbfe0ef          	jal	80003412 <iunlockput>
    8000451c:	decff0ef          	jal	80003b08 <end_op>
    80004520:	557d                	li	a0,-1
    80004522:	7a1e                	ld	s4,480(sp)
    80004524:	20813083          	ld	ra,520(sp)
    80004528:	20013403          	ld	s0,512(sp)
    8000452c:	74fe                	ld	s1,504(sp)
    8000452e:	795e                	ld	s2,496(sp)
    80004530:	21010113          	addi	sp,sp,528
    80004534:	8082                	ret
    80004536:	dd2ff0ef          	jal	80003b08 <end_op>
    8000453a:	557d                	li	a0,-1
    8000453c:	b7e5                	j	80004524 <exec+0x6e>
    8000453e:	ebda                	sd	s6,464(sp)
    80004540:	8526                	mv	a0,s1
    80004542:	c54fd0ef          	jal	80001996 <proc_pagetable>
    80004546:	8b2a                	mv	s6,a0
    80004548:	2c050b63          	beqz	a0,8000481e <exec+0x368>
    8000454c:	f7ce                	sd	s3,488(sp)
    8000454e:	efd6                	sd	s5,472(sp)
    80004550:	e7de                	sd	s7,456(sp)
    80004552:	e3e2                	sd	s8,448(sp)
    80004554:	ff66                	sd	s9,440(sp)
    80004556:	fb6a                	sd	s10,432(sp)
    80004558:	e7042d03          	lw	s10,-400(s0)
    8000455c:	e8845783          	lhu	a5,-376(s0)
    80004560:	12078963          	beqz	a5,80004692 <exec+0x1dc>
    80004564:	f76e                	sd	s11,424(sp)
    80004566:	4901                	li	s2,0
    80004568:	4d81                	li	s11,0
    8000456a:	6c85                	lui	s9,0x1
    8000456c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004570:	def43823          	sd	a5,-528(s0)
    80004574:	6a85                	lui	s5,0x1
    80004576:	a085                	j	800045d6 <exec+0x120>
    80004578:	00003517          	auipc	a0,0x3
    8000457c:	08850513          	addi	a0,a0,136 # 80007600 <etext+0x600>
    80004580:	a22fc0ef          	jal	800007a2 <panic>
    80004584:	2481                	sext.w	s1,s1
    80004586:	8726                	mv	a4,s1
    80004588:	012c06bb          	addw	a3,s8,s2
    8000458c:	4581                	li	a1,0
    8000458e:	8552                	mv	a0,s4
    80004590:	ecdfe0ef          	jal	8000345c <readi>
    80004594:	2501                	sext.w	a0,a0
    80004596:	24a49a63          	bne	s1,a0,800047ea <exec+0x334>
    8000459a:	012a893b          	addw	s2,s5,s2
    8000459e:	03397363          	bgeu	s2,s3,800045c4 <exec+0x10e>
    800045a2:	02091593          	slli	a1,s2,0x20
    800045a6:	9181                	srli	a1,a1,0x20
    800045a8:	95de                	add	a1,a1,s7
    800045aa:	855a                	mv	a0,s6
    800045ac:	a39fc0ef          	jal	80000fe4 <walkaddr>
    800045b0:	862a                	mv	a2,a0
    800045b2:	d179                	beqz	a0,80004578 <exec+0xc2>
    800045b4:	412984bb          	subw	s1,s3,s2
    800045b8:	0004879b          	sext.w	a5,s1
    800045bc:	fcfcf4e3          	bgeu	s9,a5,80004584 <exec+0xce>
    800045c0:	84d6                	mv	s1,s5
    800045c2:	b7c9                	j	80004584 <exec+0xce>
    800045c4:	e0843903          	ld	s2,-504(s0)
    800045c8:	2d85                	addiw	s11,s11,1
    800045ca:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    800045ce:	e8845783          	lhu	a5,-376(s0)
    800045d2:	08fdd063          	bge	s11,a5,80004652 <exec+0x19c>
    800045d6:	2d01                	sext.w	s10,s10
    800045d8:	03800713          	li	a4,56
    800045dc:	86ea                	mv	a3,s10
    800045de:	e1840613          	addi	a2,s0,-488
    800045e2:	4581                	li	a1,0
    800045e4:	8552                	mv	a0,s4
    800045e6:	e77fe0ef          	jal	8000345c <readi>
    800045ea:	03800793          	li	a5,56
    800045ee:	1cf51663          	bne	a0,a5,800047ba <exec+0x304>
    800045f2:	e1842783          	lw	a5,-488(s0)
    800045f6:	4705                	li	a4,1
    800045f8:	fce798e3          	bne	a5,a4,800045c8 <exec+0x112>
    800045fc:	e4043483          	ld	s1,-448(s0)
    80004600:	e3843783          	ld	a5,-456(s0)
    80004604:	1af4ef63          	bltu	s1,a5,800047c2 <exec+0x30c>
    80004608:	e2843783          	ld	a5,-472(s0)
    8000460c:	94be                	add	s1,s1,a5
    8000460e:	1af4ee63          	bltu	s1,a5,800047ca <exec+0x314>
    80004612:	df043703          	ld	a4,-528(s0)
    80004616:	8ff9                	and	a5,a5,a4
    80004618:	1a079d63          	bnez	a5,800047d2 <exec+0x31c>
    8000461c:	e1c42503          	lw	a0,-484(s0)
    80004620:	e7dff0ef          	jal	8000449c <flags2perm>
    80004624:	86aa                	mv	a3,a0
    80004626:	8626                	mv	a2,s1
    80004628:	85ca                	mv	a1,s2
    8000462a:	855a                	mv	a0,s6
    8000462c:	d21fc0ef          	jal	8000134c <uvmalloc>
    80004630:	e0a43423          	sd	a0,-504(s0)
    80004634:	1a050363          	beqz	a0,800047da <exec+0x324>
    80004638:	e2843b83          	ld	s7,-472(s0)
    8000463c:	e2042c03          	lw	s8,-480(s0)
    80004640:	e3842983          	lw	s3,-456(s0)
    80004644:	00098463          	beqz	s3,8000464c <exec+0x196>
    80004648:	4901                	li	s2,0
    8000464a:	bfa1                	j	800045a2 <exec+0xec>
    8000464c:	e0843903          	ld	s2,-504(s0)
    80004650:	bfa5                	j	800045c8 <exec+0x112>
    80004652:	7dba                	ld	s11,424(sp)
    80004654:	8552                	mv	a0,s4
    80004656:	dbdfe0ef          	jal	80003412 <iunlockput>
    8000465a:	caeff0ef          	jal	80003b08 <end_op>
    8000465e:	a90fd0ef          	jal	800018ee <myproc>
    80004662:	8aaa                	mv	s5,a0
    80004664:	04853c83          	ld	s9,72(a0)
    80004668:	6985                	lui	s3,0x1
    8000466a:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000466c:	99ca                	add	s3,s3,s2
    8000466e:	77fd                	lui	a5,0xfffff
    80004670:	00f9f9b3          	and	s3,s3,a5
    80004674:	4691                	li	a3,4
    80004676:	6609                	lui	a2,0x2
    80004678:	964e                	add	a2,a2,s3
    8000467a:	85ce                	mv	a1,s3
    8000467c:	855a                	mv	a0,s6
    8000467e:	ccffc0ef          	jal	8000134c <uvmalloc>
    80004682:	892a                	mv	s2,a0
    80004684:	e0a43423          	sd	a0,-504(s0)
    80004688:	e519                	bnez	a0,80004696 <exec+0x1e0>
    8000468a:	e1343423          	sd	s3,-504(s0)
    8000468e:	4a01                	li	s4,0
    80004690:	aab1                	j	800047ec <exec+0x336>
    80004692:	4901                	li	s2,0
    80004694:	b7c1                	j	80004654 <exec+0x19e>
    80004696:	75f9                	lui	a1,0xffffe
    80004698:	95aa                	add	a1,a1,a0
    8000469a:	855a                	mv	a0,s6
    8000469c:	e9bfc0ef          	jal	80001536 <uvmclear>
    800046a0:	7bfd                	lui	s7,0xfffff
    800046a2:	9bca                	add	s7,s7,s2
    800046a4:	e0043783          	ld	a5,-512(s0)
    800046a8:	6388                	ld	a0,0(a5)
    800046aa:	cd39                	beqz	a0,80004708 <exec+0x252>
    800046ac:	e9040993          	addi	s3,s0,-368
    800046b0:	f9040c13          	addi	s8,s0,-112
    800046b4:	4481                	li	s1,0
    800046b6:	f90fc0ef          	jal	80000e46 <strlen>
    800046ba:	0015079b          	addiw	a5,a0,1
    800046be:	40f907b3          	sub	a5,s2,a5
    800046c2:	ff07f913          	andi	s2,a5,-16
    800046c6:	11796e63          	bltu	s2,s7,800047e2 <exec+0x32c>
    800046ca:	e0043d03          	ld	s10,-512(s0)
    800046ce:	000d3a03          	ld	s4,0(s10)
    800046d2:	8552                	mv	a0,s4
    800046d4:	f72fc0ef          	jal	80000e46 <strlen>
    800046d8:	0015069b          	addiw	a3,a0,1
    800046dc:	8652                	mv	a2,s4
    800046de:	85ca                	mv	a1,s2
    800046e0:	855a                	mv	a0,s6
    800046e2:	e7ffc0ef          	jal	80001560 <copyout>
    800046e6:	10054063          	bltz	a0,800047e6 <exec+0x330>
    800046ea:	0129b023          	sd	s2,0(s3)
    800046ee:	0485                	addi	s1,s1,1
    800046f0:	008d0793          	addi	a5,s10,8
    800046f4:	e0f43023          	sd	a5,-512(s0)
    800046f8:	008d3503          	ld	a0,8(s10)
    800046fc:	c909                	beqz	a0,8000470e <exec+0x258>
    800046fe:	09a1                	addi	s3,s3,8
    80004700:	fb899be3          	bne	s3,s8,800046b6 <exec+0x200>
    80004704:	4a01                	li	s4,0
    80004706:	a0dd                	j	800047ec <exec+0x336>
    80004708:	e0843903          	ld	s2,-504(s0)
    8000470c:	4481                	li	s1,0
    8000470e:	00349793          	slli	a5,s1,0x3
    80004712:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb9b0>
    80004716:	97a2                	add	a5,a5,s0
    80004718:	f007b023          	sd	zero,-256(a5)
    8000471c:	00148693          	addi	a3,s1,1
    80004720:	068e                	slli	a3,a3,0x3
    80004722:	40d90933          	sub	s2,s2,a3
    80004726:	ff097913          	andi	s2,s2,-16
    8000472a:	e0843983          	ld	s3,-504(s0)
    8000472e:	f5796ee3          	bltu	s2,s7,8000468a <exec+0x1d4>
    80004732:	e9040613          	addi	a2,s0,-368
    80004736:	85ca                	mv	a1,s2
    80004738:	855a                	mv	a0,s6
    8000473a:	e27fc0ef          	jal	80001560 <copyout>
    8000473e:	0e054263          	bltz	a0,80004822 <exec+0x36c>
    80004742:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004746:	0727bc23          	sd	s2,120(a5)
    8000474a:	df843783          	ld	a5,-520(s0)
    8000474e:	0007c703          	lbu	a4,0(a5)
    80004752:	cf11                	beqz	a4,8000476e <exec+0x2b8>
    80004754:	0785                	addi	a5,a5,1
    80004756:	02f00693          	li	a3,47
    8000475a:	a039                	j	80004768 <exec+0x2b2>
    8000475c:	def43c23          	sd	a5,-520(s0)
    80004760:	0785                	addi	a5,a5,1
    80004762:	fff7c703          	lbu	a4,-1(a5)
    80004766:	c701                	beqz	a4,8000476e <exec+0x2b8>
    80004768:	fed71ce3          	bne	a4,a3,80004760 <exec+0x2aa>
    8000476c:	bfc5                	j	8000475c <exec+0x2a6>
    8000476e:	4641                	li	a2,16
    80004770:	df843583          	ld	a1,-520(s0)
    80004774:	158a8513          	addi	a0,s5,344
    80004778:	e9cfc0ef          	jal	80000e14 <safestrcpy>
    8000477c:	050ab503          	ld	a0,80(s5)
    80004780:	056ab823          	sd	s6,80(s5)
    80004784:	e0843783          	ld	a5,-504(s0)
    80004788:	04fab423          	sd	a5,72(s5)
    8000478c:	058ab783          	ld	a5,88(s5)
    80004790:	e6843703          	ld	a4,-408(s0)
    80004794:	ef98                	sd	a4,24(a5)
    80004796:	058ab783          	ld	a5,88(s5)
    8000479a:	0327b823          	sd	s2,48(a5)
    8000479e:	85e6                	mv	a1,s9
    800047a0:	a7afd0ef          	jal	80001a1a <proc_freepagetable>
    800047a4:	0004851b          	sext.w	a0,s1
    800047a8:	79be                	ld	s3,488(sp)
    800047aa:	7a1e                	ld	s4,480(sp)
    800047ac:	6afe                	ld	s5,472(sp)
    800047ae:	6b5e                	ld	s6,464(sp)
    800047b0:	6bbe                	ld	s7,456(sp)
    800047b2:	6c1e                	ld	s8,448(sp)
    800047b4:	7cfa                	ld	s9,440(sp)
    800047b6:	7d5a                	ld	s10,432(sp)
    800047b8:	b3b5                	j	80004524 <exec+0x6e>
    800047ba:	e1243423          	sd	s2,-504(s0)
    800047be:	7dba                	ld	s11,424(sp)
    800047c0:	a035                	j	800047ec <exec+0x336>
    800047c2:	e1243423          	sd	s2,-504(s0)
    800047c6:	7dba                	ld	s11,424(sp)
    800047c8:	a015                	j	800047ec <exec+0x336>
    800047ca:	e1243423          	sd	s2,-504(s0)
    800047ce:	7dba                	ld	s11,424(sp)
    800047d0:	a831                	j	800047ec <exec+0x336>
    800047d2:	e1243423          	sd	s2,-504(s0)
    800047d6:	7dba                	ld	s11,424(sp)
    800047d8:	a811                	j	800047ec <exec+0x336>
    800047da:	e1243423          	sd	s2,-504(s0)
    800047de:	7dba                	ld	s11,424(sp)
    800047e0:	a031                	j	800047ec <exec+0x336>
    800047e2:	4a01                	li	s4,0
    800047e4:	a021                	j	800047ec <exec+0x336>
    800047e6:	4a01                	li	s4,0
    800047e8:	a011                	j	800047ec <exec+0x336>
    800047ea:	7dba                	ld	s11,424(sp)
    800047ec:	e0843583          	ld	a1,-504(s0)
    800047f0:	855a                	mv	a0,s6
    800047f2:	a28fd0ef          	jal	80001a1a <proc_freepagetable>
    800047f6:	557d                	li	a0,-1
    800047f8:	000a1b63          	bnez	s4,8000480e <exec+0x358>
    800047fc:	79be                	ld	s3,488(sp)
    800047fe:	7a1e                	ld	s4,480(sp)
    80004800:	6afe                	ld	s5,472(sp)
    80004802:	6b5e                	ld	s6,464(sp)
    80004804:	6bbe                	ld	s7,456(sp)
    80004806:	6c1e                	ld	s8,448(sp)
    80004808:	7cfa                	ld	s9,440(sp)
    8000480a:	7d5a                	ld	s10,432(sp)
    8000480c:	bb21                	j	80004524 <exec+0x6e>
    8000480e:	79be                	ld	s3,488(sp)
    80004810:	6afe                	ld	s5,472(sp)
    80004812:	6b5e                	ld	s6,464(sp)
    80004814:	6bbe                	ld	s7,456(sp)
    80004816:	6c1e                	ld	s8,448(sp)
    80004818:	7cfa                	ld	s9,440(sp)
    8000481a:	7d5a                	ld	s10,432(sp)
    8000481c:	b9ed                	j	80004516 <exec+0x60>
    8000481e:	6b5e                	ld	s6,464(sp)
    80004820:	b9dd                	j	80004516 <exec+0x60>
    80004822:	e0843983          	ld	s3,-504(s0)
    80004826:	b595                	j	8000468a <exec+0x1d4>

0000000080004828 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004828:	7179                	addi	sp,sp,-48
    8000482a:	f406                	sd	ra,40(sp)
    8000482c:	f022                	sd	s0,32(sp)
    8000482e:	ec26                	sd	s1,24(sp)
    80004830:	e84a                	sd	s2,16(sp)
    80004832:	1800                	addi	s0,sp,48
    80004834:	892e                	mv	s2,a1
    80004836:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004838:	fdc40593          	addi	a1,s0,-36
    8000483c:	f67fd0ef          	jal	800027a2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004840:	fdc42703          	lw	a4,-36(s0)
    80004844:	47bd                	li	a5,15
    80004846:	02e7e963          	bltu	a5,a4,80004878 <argfd+0x50>
    8000484a:	8a4fd0ef          	jal	800018ee <myproc>
    8000484e:	fdc42703          	lw	a4,-36(s0)
    80004852:	01a70793          	addi	a5,a4,26
    80004856:	078e                	slli	a5,a5,0x3
    80004858:	953e                	add	a0,a0,a5
    8000485a:	611c                	ld	a5,0(a0)
    8000485c:	c385                	beqz	a5,8000487c <argfd+0x54>
    return -1;
  if(pfd)
    8000485e:	00090463          	beqz	s2,80004866 <argfd+0x3e>
    *pfd = fd;
    80004862:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004866:	4501                	li	a0,0
  if(pf)
    80004868:	c091                	beqz	s1,8000486c <argfd+0x44>
    *pf = f;
    8000486a:	e09c                	sd	a5,0(s1)
}
    8000486c:	70a2                	ld	ra,40(sp)
    8000486e:	7402                	ld	s0,32(sp)
    80004870:	64e2                	ld	s1,24(sp)
    80004872:	6942                	ld	s2,16(sp)
    80004874:	6145                	addi	sp,sp,48
    80004876:	8082                	ret
    return -1;
    80004878:	557d                	li	a0,-1
    8000487a:	bfcd                	j	8000486c <argfd+0x44>
    8000487c:	557d                	li	a0,-1
    8000487e:	b7fd                	j	8000486c <argfd+0x44>

0000000080004880 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004880:	1101                	addi	sp,sp,-32
    80004882:	ec06                	sd	ra,24(sp)
    80004884:	e822                	sd	s0,16(sp)
    80004886:	e426                	sd	s1,8(sp)
    80004888:	1000                	addi	s0,sp,32
    8000488a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000488c:	862fd0ef          	jal	800018ee <myproc>
    80004890:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004892:	0d050793          	addi	a5,a0,208
    80004896:	4501                	li	a0,0
    80004898:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000489a:	6398                	ld	a4,0(a5)
    8000489c:	cb19                	beqz	a4,800048b2 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    8000489e:	2505                	addiw	a0,a0,1
    800048a0:	07a1                	addi	a5,a5,8
    800048a2:	fed51ce3          	bne	a0,a3,8000489a <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800048a6:	557d                	li	a0,-1
}
    800048a8:	60e2                	ld	ra,24(sp)
    800048aa:	6442                	ld	s0,16(sp)
    800048ac:	64a2                	ld	s1,8(sp)
    800048ae:	6105                	addi	sp,sp,32
    800048b0:	8082                	ret
      p->ofile[fd] = f;
    800048b2:	01a50793          	addi	a5,a0,26
    800048b6:	078e                	slli	a5,a5,0x3
    800048b8:	963e                	add	a2,a2,a5
    800048ba:	e204                	sd	s1,0(a2)
      return fd;
    800048bc:	b7f5                	j	800048a8 <fdalloc+0x28>

00000000800048be <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800048be:	715d                	addi	sp,sp,-80
    800048c0:	e486                	sd	ra,72(sp)
    800048c2:	e0a2                	sd	s0,64(sp)
    800048c4:	fc26                	sd	s1,56(sp)
    800048c6:	f84a                	sd	s2,48(sp)
    800048c8:	f44e                	sd	s3,40(sp)
    800048ca:	ec56                	sd	s5,24(sp)
    800048cc:	e85a                	sd	s6,16(sp)
    800048ce:	0880                	addi	s0,sp,80
    800048d0:	8b2e                	mv	s6,a1
    800048d2:	89b2                	mv	s3,a2
    800048d4:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800048d6:	fb040593          	addi	a1,s0,-80
    800048da:	822ff0ef          	jal	800038fc <nameiparent>
    800048de:	84aa                	mv	s1,a0
    800048e0:	10050a63          	beqz	a0,800049f4 <create+0x136>
    return 0;

  ilock(dp);
    800048e4:	925fe0ef          	jal	80003208 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800048e8:	4601                	li	a2,0
    800048ea:	fb040593          	addi	a1,s0,-80
    800048ee:	8526                	mv	a0,s1
    800048f0:	d8dfe0ef          	jal	8000367c <dirlookup>
    800048f4:	8aaa                	mv	s5,a0
    800048f6:	c129                	beqz	a0,80004938 <create+0x7a>
    iunlockput(dp);
    800048f8:	8526                	mv	a0,s1
    800048fa:	b19fe0ef          	jal	80003412 <iunlockput>
    ilock(ip);
    800048fe:	8556                	mv	a0,s5
    80004900:	909fe0ef          	jal	80003208 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004904:	4789                	li	a5,2
    80004906:	02fb1463          	bne	s6,a5,8000492e <create+0x70>
    8000490a:	044ad783          	lhu	a5,68(s5)
    8000490e:	37f9                	addiw	a5,a5,-2
    80004910:	17c2                	slli	a5,a5,0x30
    80004912:	93c1                	srli	a5,a5,0x30
    80004914:	4705                	li	a4,1
    80004916:	00f76c63          	bltu	a4,a5,8000492e <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000491a:	8556                	mv	a0,s5
    8000491c:	60a6                	ld	ra,72(sp)
    8000491e:	6406                	ld	s0,64(sp)
    80004920:	74e2                	ld	s1,56(sp)
    80004922:	7942                	ld	s2,48(sp)
    80004924:	79a2                	ld	s3,40(sp)
    80004926:	6ae2                	ld	s5,24(sp)
    80004928:	6b42                	ld	s6,16(sp)
    8000492a:	6161                	addi	sp,sp,80
    8000492c:	8082                	ret
    iunlockput(ip);
    8000492e:	8556                	mv	a0,s5
    80004930:	ae3fe0ef          	jal	80003412 <iunlockput>
    return 0;
    80004934:	4a81                	li	s5,0
    80004936:	b7d5                	j	8000491a <create+0x5c>
    80004938:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    8000493a:	85da                	mv	a1,s6
    8000493c:	4088                	lw	a0,0(s1)
    8000493e:	f5afe0ef          	jal	80003098 <ialloc>
    80004942:	8a2a                	mv	s4,a0
    80004944:	cd15                	beqz	a0,80004980 <create+0xc2>
  ilock(ip);
    80004946:	8c3fe0ef          	jal	80003208 <ilock>
  ip->major = major;
    8000494a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000494e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004952:	4905                	li	s2,1
    80004954:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004958:	8552                	mv	a0,s4
    8000495a:	ffafe0ef          	jal	80003154 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000495e:	032b0763          	beq	s6,s2,8000498c <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004962:	004a2603          	lw	a2,4(s4)
    80004966:	fb040593          	addi	a1,s0,-80
    8000496a:	8526                	mv	a0,s1
    8000496c:	eddfe0ef          	jal	80003848 <dirlink>
    80004970:	06054563          	bltz	a0,800049da <create+0x11c>
  iunlockput(dp);
    80004974:	8526                	mv	a0,s1
    80004976:	a9dfe0ef          	jal	80003412 <iunlockput>
  return ip;
    8000497a:	8ad2                	mv	s5,s4
    8000497c:	7a02                	ld	s4,32(sp)
    8000497e:	bf71                	j	8000491a <create+0x5c>
    iunlockput(dp);
    80004980:	8526                	mv	a0,s1
    80004982:	a91fe0ef          	jal	80003412 <iunlockput>
    return 0;
    80004986:	8ad2                	mv	s5,s4
    80004988:	7a02                	ld	s4,32(sp)
    8000498a:	bf41                	j	8000491a <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000498c:	004a2603          	lw	a2,4(s4)
    80004990:	00003597          	auipc	a1,0x3
    80004994:	c9058593          	addi	a1,a1,-880 # 80007620 <etext+0x620>
    80004998:	8552                	mv	a0,s4
    8000499a:	eaffe0ef          	jal	80003848 <dirlink>
    8000499e:	02054e63          	bltz	a0,800049da <create+0x11c>
    800049a2:	40d0                	lw	a2,4(s1)
    800049a4:	00003597          	auipc	a1,0x3
    800049a8:	c8458593          	addi	a1,a1,-892 # 80007628 <etext+0x628>
    800049ac:	8552                	mv	a0,s4
    800049ae:	e9bfe0ef          	jal	80003848 <dirlink>
    800049b2:	02054463          	bltz	a0,800049da <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800049b6:	004a2603          	lw	a2,4(s4)
    800049ba:	fb040593          	addi	a1,s0,-80
    800049be:	8526                	mv	a0,s1
    800049c0:	e89fe0ef          	jal	80003848 <dirlink>
    800049c4:	00054b63          	bltz	a0,800049da <create+0x11c>
    dp->nlink++;  // for ".."
    800049c8:	04a4d783          	lhu	a5,74(s1)
    800049cc:	2785                	addiw	a5,a5,1
    800049ce:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800049d2:	8526                	mv	a0,s1
    800049d4:	f80fe0ef          	jal	80003154 <iupdate>
    800049d8:	bf71                	j	80004974 <create+0xb6>
  ip->nlink = 0;
    800049da:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800049de:	8552                	mv	a0,s4
    800049e0:	f74fe0ef          	jal	80003154 <iupdate>
  iunlockput(ip);
    800049e4:	8552                	mv	a0,s4
    800049e6:	a2dfe0ef          	jal	80003412 <iunlockput>
  iunlockput(dp);
    800049ea:	8526                	mv	a0,s1
    800049ec:	a27fe0ef          	jal	80003412 <iunlockput>
  return 0;
    800049f0:	7a02                	ld	s4,32(sp)
    800049f2:	b725                	j	8000491a <create+0x5c>
    return 0;
    800049f4:	8aaa                	mv	s5,a0
    800049f6:	b715                	j	8000491a <create+0x5c>

00000000800049f8 <sys_dup>:
{
    800049f8:	7179                	addi	sp,sp,-48
    800049fa:	f406                	sd	ra,40(sp)
    800049fc:	f022                	sd	s0,32(sp)
    800049fe:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004a00:	fd840613          	addi	a2,s0,-40
    80004a04:	4581                	li	a1,0
    80004a06:	4501                	li	a0,0
    80004a08:	e21ff0ef          	jal	80004828 <argfd>
    return -1;
    80004a0c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004a0e:	02054363          	bltz	a0,80004a34 <sys_dup+0x3c>
    80004a12:	ec26                	sd	s1,24(sp)
    80004a14:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004a16:	fd843903          	ld	s2,-40(s0)
    80004a1a:	854a                	mv	a0,s2
    80004a1c:	e65ff0ef          	jal	80004880 <fdalloc>
    80004a20:	84aa                	mv	s1,a0
    return -1;
    80004a22:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004a24:	00054d63          	bltz	a0,80004a3e <sys_dup+0x46>
  filedup(f);
    80004a28:	854a                	mv	a0,s2
    80004a2a:	c48ff0ef          	jal	80003e72 <filedup>
  return fd;
    80004a2e:	87a6                	mv	a5,s1
    80004a30:	64e2                	ld	s1,24(sp)
    80004a32:	6942                	ld	s2,16(sp)
}
    80004a34:	853e                	mv	a0,a5
    80004a36:	70a2                	ld	ra,40(sp)
    80004a38:	7402                	ld	s0,32(sp)
    80004a3a:	6145                	addi	sp,sp,48
    80004a3c:	8082                	ret
    80004a3e:	64e2                	ld	s1,24(sp)
    80004a40:	6942                	ld	s2,16(sp)
    80004a42:	bfcd                	j	80004a34 <sys_dup+0x3c>

0000000080004a44 <sys_read>:
{
    80004a44:	7179                	addi	sp,sp,-48
    80004a46:	f406                	sd	ra,40(sp)
    80004a48:	f022                	sd	s0,32(sp)
    80004a4a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004a4c:	fd840593          	addi	a1,s0,-40
    80004a50:	4505                	li	a0,1
    80004a52:	d6dfd0ef          	jal	800027be <argaddr>
  argint(2, &n);
    80004a56:	fe440593          	addi	a1,s0,-28
    80004a5a:	4509                	li	a0,2
    80004a5c:	d47fd0ef          	jal	800027a2 <argint>
  if(argfd(0, 0, &f) < 0)
    80004a60:	fe840613          	addi	a2,s0,-24
    80004a64:	4581                	li	a1,0
    80004a66:	4501                	li	a0,0
    80004a68:	dc1ff0ef          	jal	80004828 <argfd>
    80004a6c:	87aa                	mv	a5,a0
    return -1;
    80004a6e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a70:	0007ca63          	bltz	a5,80004a84 <sys_read+0x40>
  return fileread(f, p, n);
    80004a74:	fe442603          	lw	a2,-28(s0)
    80004a78:	fd843583          	ld	a1,-40(s0)
    80004a7c:	fe843503          	ld	a0,-24(s0)
    80004a80:	d58ff0ef          	jal	80003fd8 <fileread>
}
    80004a84:	70a2                	ld	ra,40(sp)
    80004a86:	7402                	ld	s0,32(sp)
    80004a88:	6145                	addi	sp,sp,48
    80004a8a:	8082                	ret

0000000080004a8c <sys_write>:
{
    80004a8c:	7179                	addi	sp,sp,-48
    80004a8e:	f406                	sd	ra,40(sp)
    80004a90:	f022                	sd	s0,32(sp)
    80004a92:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004a94:	fd840593          	addi	a1,s0,-40
    80004a98:	4505                	li	a0,1
    80004a9a:	d25fd0ef          	jal	800027be <argaddr>
  argint(2, &n);
    80004a9e:	fe440593          	addi	a1,s0,-28
    80004aa2:	4509                	li	a0,2
    80004aa4:	cfffd0ef          	jal	800027a2 <argint>
  if(argfd(0, 0, &f) < 0)
    80004aa8:	fe840613          	addi	a2,s0,-24
    80004aac:	4581                	li	a1,0
    80004aae:	4501                	li	a0,0
    80004ab0:	d79ff0ef          	jal	80004828 <argfd>
    80004ab4:	87aa                	mv	a5,a0
    return -1;
    80004ab6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004ab8:	0007ca63          	bltz	a5,80004acc <sys_write+0x40>
  return filewrite(f, p, n);
    80004abc:	fe442603          	lw	a2,-28(s0)
    80004ac0:	fd843583          	ld	a1,-40(s0)
    80004ac4:	fe843503          	ld	a0,-24(s0)
    80004ac8:	dceff0ef          	jal	80004096 <filewrite>
}
    80004acc:	70a2                	ld	ra,40(sp)
    80004ace:	7402                	ld	s0,32(sp)
    80004ad0:	6145                	addi	sp,sp,48
    80004ad2:	8082                	ret

0000000080004ad4 <sys_close>:
{
    80004ad4:	1101                	addi	sp,sp,-32
    80004ad6:	ec06                	sd	ra,24(sp)
    80004ad8:	e822                	sd	s0,16(sp)
    80004ada:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004adc:	fe040613          	addi	a2,s0,-32
    80004ae0:	fec40593          	addi	a1,s0,-20
    80004ae4:	4501                	li	a0,0
    80004ae6:	d43ff0ef          	jal	80004828 <argfd>
    return -1;
    80004aea:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004aec:	02054063          	bltz	a0,80004b0c <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004af0:	dfffc0ef          	jal	800018ee <myproc>
    80004af4:	fec42783          	lw	a5,-20(s0)
    80004af8:	07e9                	addi	a5,a5,26
    80004afa:	078e                	slli	a5,a5,0x3
    80004afc:	953e                	add	a0,a0,a5
    80004afe:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004b02:	fe043503          	ld	a0,-32(s0)
    80004b06:	bb2ff0ef          	jal	80003eb8 <fileclose>
  return 0;
    80004b0a:	4781                	li	a5,0
}
    80004b0c:	853e                	mv	a0,a5
    80004b0e:	60e2                	ld	ra,24(sp)
    80004b10:	6442                	ld	s0,16(sp)
    80004b12:	6105                	addi	sp,sp,32
    80004b14:	8082                	ret

0000000080004b16 <sys_fstat>:
{
    80004b16:	1101                	addi	sp,sp,-32
    80004b18:	ec06                	sd	ra,24(sp)
    80004b1a:	e822                	sd	s0,16(sp)
    80004b1c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004b1e:	fe040593          	addi	a1,s0,-32
    80004b22:	4505                	li	a0,1
    80004b24:	c9bfd0ef          	jal	800027be <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004b28:	fe840613          	addi	a2,s0,-24
    80004b2c:	4581                	li	a1,0
    80004b2e:	4501                	li	a0,0
    80004b30:	cf9ff0ef          	jal	80004828 <argfd>
    80004b34:	87aa                	mv	a5,a0
    return -1;
    80004b36:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b38:	0007c863          	bltz	a5,80004b48 <sys_fstat+0x32>
  return filestat(f, st);
    80004b3c:	fe043583          	ld	a1,-32(s0)
    80004b40:	fe843503          	ld	a0,-24(s0)
    80004b44:	c36ff0ef          	jal	80003f7a <filestat>
}
    80004b48:	60e2                	ld	ra,24(sp)
    80004b4a:	6442                	ld	s0,16(sp)
    80004b4c:	6105                	addi	sp,sp,32
    80004b4e:	8082                	ret

0000000080004b50 <sys_link>:
{
    80004b50:	7169                	addi	sp,sp,-304
    80004b52:	f606                	sd	ra,296(sp)
    80004b54:	f222                	sd	s0,288(sp)
    80004b56:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b58:	08000613          	li	a2,128
    80004b5c:	ed040593          	addi	a1,s0,-304
    80004b60:	4501                	li	a0,0
    80004b62:	c79fd0ef          	jal	800027da <argstr>
    return -1;
    80004b66:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b68:	0c054e63          	bltz	a0,80004c44 <sys_link+0xf4>
    80004b6c:	08000613          	li	a2,128
    80004b70:	f5040593          	addi	a1,s0,-176
    80004b74:	4505                	li	a0,1
    80004b76:	c65fd0ef          	jal	800027da <argstr>
    return -1;
    80004b7a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b7c:	0c054463          	bltz	a0,80004c44 <sys_link+0xf4>
    80004b80:	ee26                	sd	s1,280(sp)
  begin_op();
    80004b82:	f1dfe0ef          	jal	80003a9e <begin_op>
  if((ip = namei(old)) == 0){
    80004b86:	ed040513          	addi	a0,s0,-304
    80004b8a:	d59fe0ef          	jal	800038e2 <namei>
    80004b8e:	84aa                	mv	s1,a0
    80004b90:	c53d                	beqz	a0,80004bfe <sys_link+0xae>
  ilock(ip);
    80004b92:	e76fe0ef          	jal	80003208 <ilock>
  if(ip->type == T_DIR){
    80004b96:	04449703          	lh	a4,68(s1)
    80004b9a:	4785                	li	a5,1
    80004b9c:	06f70663          	beq	a4,a5,80004c08 <sys_link+0xb8>
    80004ba0:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004ba2:	04a4d783          	lhu	a5,74(s1)
    80004ba6:	2785                	addiw	a5,a5,1
    80004ba8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004bac:	8526                	mv	a0,s1
    80004bae:	da6fe0ef          	jal	80003154 <iupdate>
  iunlock(ip);
    80004bb2:	8526                	mv	a0,s1
    80004bb4:	f02fe0ef          	jal	800032b6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004bb8:	fd040593          	addi	a1,s0,-48
    80004bbc:	f5040513          	addi	a0,s0,-176
    80004bc0:	d3dfe0ef          	jal	800038fc <nameiparent>
    80004bc4:	892a                	mv	s2,a0
    80004bc6:	cd21                	beqz	a0,80004c1e <sys_link+0xce>
  ilock(dp);
    80004bc8:	e40fe0ef          	jal	80003208 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004bcc:	00092703          	lw	a4,0(s2)
    80004bd0:	409c                	lw	a5,0(s1)
    80004bd2:	04f71363          	bne	a4,a5,80004c18 <sys_link+0xc8>
    80004bd6:	40d0                	lw	a2,4(s1)
    80004bd8:	fd040593          	addi	a1,s0,-48
    80004bdc:	854a                	mv	a0,s2
    80004bde:	c6bfe0ef          	jal	80003848 <dirlink>
    80004be2:	02054b63          	bltz	a0,80004c18 <sys_link+0xc8>
  iunlockput(dp);
    80004be6:	854a                	mv	a0,s2
    80004be8:	82bfe0ef          	jal	80003412 <iunlockput>
  iput(ip);
    80004bec:	8526                	mv	a0,s1
    80004bee:	f9cfe0ef          	jal	8000338a <iput>
  end_op();
    80004bf2:	f17fe0ef          	jal	80003b08 <end_op>
  return 0;
    80004bf6:	4781                	li	a5,0
    80004bf8:	64f2                	ld	s1,280(sp)
    80004bfa:	6952                	ld	s2,272(sp)
    80004bfc:	a0a1                	j	80004c44 <sys_link+0xf4>
    end_op();
    80004bfe:	f0bfe0ef          	jal	80003b08 <end_op>
    return -1;
    80004c02:	57fd                	li	a5,-1
    80004c04:	64f2                	ld	s1,280(sp)
    80004c06:	a83d                	j	80004c44 <sys_link+0xf4>
    iunlockput(ip);
    80004c08:	8526                	mv	a0,s1
    80004c0a:	809fe0ef          	jal	80003412 <iunlockput>
    end_op();
    80004c0e:	efbfe0ef          	jal	80003b08 <end_op>
    return -1;
    80004c12:	57fd                	li	a5,-1
    80004c14:	64f2                	ld	s1,280(sp)
    80004c16:	a03d                	j	80004c44 <sys_link+0xf4>
    iunlockput(dp);
    80004c18:	854a                	mv	a0,s2
    80004c1a:	ff8fe0ef          	jal	80003412 <iunlockput>
  ilock(ip);
    80004c1e:	8526                	mv	a0,s1
    80004c20:	de8fe0ef          	jal	80003208 <ilock>
  ip->nlink--;
    80004c24:	04a4d783          	lhu	a5,74(s1)
    80004c28:	37fd                	addiw	a5,a5,-1
    80004c2a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c2e:	8526                	mv	a0,s1
    80004c30:	d24fe0ef          	jal	80003154 <iupdate>
  iunlockput(ip);
    80004c34:	8526                	mv	a0,s1
    80004c36:	fdcfe0ef          	jal	80003412 <iunlockput>
  end_op();
    80004c3a:	ecffe0ef          	jal	80003b08 <end_op>
  return -1;
    80004c3e:	57fd                	li	a5,-1
    80004c40:	64f2                	ld	s1,280(sp)
    80004c42:	6952                	ld	s2,272(sp)
}
    80004c44:	853e                	mv	a0,a5
    80004c46:	70b2                	ld	ra,296(sp)
    80004c48:	7412                	ld	s0,288(sp)
    80004c4a:	6155                	addi	sp,sp,304
    80004c4c:	8082                	ret

0000000080004c4e <sys_unlink>:
{
    80004c4e:	7151                	addi	sp,sp,-240
    80004c50:	f586                	sd	ra,232(sp)
    80004c52:	f1a2                	sd	s0,224(sp)
    80004c54:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004c56:	08000613          	li	a2,128
    80004c5a:	f3040593          	addi	a1,s0,-208
    80004c5e:	4501                	li	a0,0
    80004c60:	b7bfd0ef          	jal	800027da <argstr>
    80004c64:	16054063          	bltz	a0,80004dc4 <sys_unlink+0x176>
    80004c68:	eda6                	sd	s1,216(sp)
  begin_op();
    80004c6a:	e35fe0ef          	jal	80003a9e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004c6e:	fb040593          	addi	a1,s0,-80
    80004c72:	f3040513          	addi	a0,s0,-208
    80004c76:	c87fe0ef          	jal	800038fc <nameiparent>
    80004c7a:	84aa                	mv	s1,a0
    80004c7c:	c945                	beqz	a0,80004d2c <sys_unlink+0xde>
  ilock(dp);
    80004c7e:	d8afe0ef          	jal	80003208 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004c82:	00003597          	auipc	a1,0x3
    80004c86:	99e58593          	addi	a1,a1,-1634 # 80007620 <etext+0x620>
    80004c8a:	fb040513          	addi	a0,s0,-80
    80004c8e:	9d9fe0ef          	jal	80003666 <namecmp>
    80004c92:	10050e63          	beqz	a0,80004dae <sys_unlink+0x160>
    80004c96:	00003597          	auipc	a1,0x3
    80004c9a:	99258593          	addi	a1,a1,-1646 # 80007628 <etext+0x628>
    80004c9e:	fb040513          	addi	a0,s0,-80
    80004ca2:	9c5fe0ef          	jal	80003666 <namecmp>
    80004ca6:	10050463          	beqz	a0,80004dae <sys_unlink+0x160>
    80004caa:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004cac:	f2c40613          	addi	a2,s0,-212
    80004cb0:	fb040593          	addi	a1,s0,-80
    80004cb4:	8526                	mv	a0,s1
    80004cb6:	9c7fe0ef          	jal	8000367c <dirlookup>
    80004cba:	892a                	mv	s2,a0
    80004cbc:	0e050863          	beqz	a0,80004dac <sys_unlink+0x15e>
  ilock(ip);
    80004cc0:	d48fe0ef          	jal	80003208 <ilock>
  if(ip->nlink < 1)
    80004cc4:	04a91783          	lh	a5,74(s2)
    80004cc8:	06f05763          	blez	a5,80004d36 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ccc:	04491703          	lh	a4,68(s2)
    80004cd0:	4785                	li	a5,1
    80004cd2:	06f70963          	beq	a4,a5,80004d44 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004cd6:	4641                	li	a2,16
    80004cd8:	4581                	li	a1,0
    80004cda:	fc040513          	addi	a0,s0,-64
    80004cde:	ff9fb0ef          	jal	80000cd6 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ce2:	4741                	li	a4,16
    80004ce4:	f2c42683          	lw	a3,-212(s0)
    80004ce8:	fc040613          	addi	a2,s0,-64
    80004cec:	4581                	li	a1,0
    80004cee:	8526                	mv	a0,s1
    80004cf0:	869fe0ef          	jal	80003558 <writei>
    80004cf4:	47c1                	li	a5,16
    80004cf6:	08f51b63          	bne	a0,a5,80004d8c <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004cfa:	04491703          	lh	a4,68(s2)
    80004cfe:	4785                	li	a5,1
    80004d00:	08f70d63          	beq	a4,a5,80004d9a <sys_unlink+0x14c>
  iunlockput(dp);
    80004d04:	8526                	mv	a0,s1
    80004d06:	f0cfe0ef          	jal	80003412 <iunlockput>
  ip->nlink--;
    80004d0a:	04a95783          	lhu	a5,74(s2)
    80004d0e:	37fd                	addiw	a5,a5,-1
    80004d10:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004d14:	854a                	mv	a0,s2
    80004d16:	c3efe0ef          	jal	80003154 <iupdate>
  iunlockput(ip);
    80004d1a:	854a                	mv	a0,s2
    80004d1c:	ef6fe0ef          	jal	80003412 <iunlockput>
  end_op();
    80004d20:	de9fe0ef          	jal	80003b08 <end_op>
  return 0;
    80004d24:	4501                	li	a0,0
    80004d26:	64ee                	ld	s1,216(sp)
    80004d28:	694e                	ld	s2,208(sp)
    80004d2a:	a849                	j	80004dbc <sys_unlink+0x16e>
    end_op();
    80004d2c:	dddfe0ef          	jal	80003b08 <end_op>
    return -1;
    80004d30:	557d                	li	a0,-1
    80004d32:	64ee                	ld	s1,216(sp)
    80004d34:	a061                	j	80004dbc <sys_unlink+0x16e>
    80004d36:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004d38:	00003517          	auipc	a0,0x3
    80004d3c:	8f850513          	addi	a0,a0,-1800 # 80007630 <etext+0x630>
    80004d40:	a63fb0ef          	jal	800007a2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d44:	04c92703          	lw	a4,76(s2)
    80004d48:	02000793          	li	a5,32
    80004d4c:	f8e7f5e3          	bgeu	a5,a4,80004cd6 <sys_unlink+0x88>
    80004d50:	e5ce                	sd	s3,200(sp)
    80004d52:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d56:	4741                	li	a4,16
    80004d58:	86ce                	mv	a3,s3
    80004d5a:	f1840613          	addi	a2,s0,-232
    80004d5e:	4581                	li	a1,0
    80004d60:	854a                	mv	a0,s2
    80004d62:	efafe0ef          	jal	8000345c <readi>
    80004d66:	47c1                	li	a5,16
    80004d68:	00f51c63          	bne	a0,a5,80004d80 <sys_unlink+0x132>
    if(de.inum != 0)
    80004d6c:	f1845783          	lhu	a5,-232(s0)
    80004d70:	efa1                	bnez	a5,80004dc8 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d72:	29c1                	addiw	s3,s3,16
    80004d74:	04c92783          	lw	a5,76(s2)
    80004d78:	fcf9efe3          	bltu	s3,a5,80004d56 <sys_unlink+0x108>
    80004d7c:	69ae                	ld	s3,200(sp)
    80004d7e:	bfa1                	j	80004cd6 <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004d80:	00003517          	auipc	a0,0x3
    80004d84:	8c850513          	addi	a0,a0,-1848 # 80007648 <etext+0x648>
    80004d88:	a1bfb0ef          	jal	800007a2 <panic>
    80004d8c:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004d8e:	00003517          	auipc	a0,0x3
    80004d92:	8d250513          	addi	a0,a0,-1838 # 80007660 <etext+0x660>
    80004d96:	a0dfb0ef          	jal	800007a2 <panic>
    dp->nlink--;
    80004d9a:	04a4d783          	lhu	a5,74(s1)
    80004d9e:	37fd                	addiw	a5,a5,-1
    80004da0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004da4:	8526                	mv	a0,s1
    80004da6:	baefe0ef          	jal	80003154 <iupdate>
    80004daa:	bfa9                	j	80004d04 <sys_unlink+0xb6>
    80004dac:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004dae:	8526                	mv	a0,s1
    80004db0:	e62fe0ef          	jal	80003412 <iunlockput>
  end_op();
    80004db4:	d55fe0ef          	jal	80003b08 <end_op>
  return -1;
    80004db8:	557d                	li	a0,-1
    80004dba:	64ee                	ld	s1,216(sp)
}
    80004dbc:	70ae                	ld	ra,232(sp)
    80004dbe:	740e                	ld	s0,224(sp)
    80004dc0:	616d                	addi	sp,sp,240
    80004dc2:	8082                	ret
    return -1;
    80004dc4:	557d                	li	a0,-1
    80004dc6:	bfdd                	j	80004dbc <sys_unlink+0x16e>
    iunlockput(ip);
    80004dc8:	854a                	mv	a0,s2
    80004dca:	e48fe0ef          	jal	80003412 <iunlockput>
    goto bad;
    80004dce:	694e                	ld	s2,208(sp)
    80004dd0:	69ae                	ld	s3,200(sp)
    80004dd2:	bff1                	j	80004dae <sys_unlink+0x160>

0000000080004dd4 <sys_open>:

uint64
sys_open(void)
{
    80004dd4:	7131                	addi	sp,sp,-192
    80004dd6:	fd06                	sd	ra,184(sp)
    80004dd8:	f922                	sd	s0,176(sp)
    80004dda:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004ddc:	f4c40593          	addi	a1,s0,-180
    80004de0:	4505                	li	a0,1
    80004de2:	9c1fd0ef          	jal	800027a2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004de6:	08000613          	li	a2,128
    80004dea:	f5040593          	addi	a1,s0,-176
    80004dee:	4501                	li	a0,0
    80004df0:	9ebfd0ef          	jal	800027da <argstr>
    80004df4:	87aa                	mv	a5,a0
    return -1;
    80004df6:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004df8:	0a07c263          	bltz	a5,80004e9c <sys_open+0xc8>
    80004dfc:	f526                	sd	s1,168(sp)

  begin_op();
    80004dfe:	ca1fe0ef          	jal	80003a9e <begin_op>

  if(omode & O_CREATE){
    80004e02:	f4c42783          	lw	a5,-180(s0)
    80004e06:	2007f793          	andi	a5,a5,512
    80004e0a:	c3d5                	beqz	a5,80004eae <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004e0c:	4681                	li	a3,0
    80004e0e:	4601                	li	a2,0
    80004e10:	4589                	li	a1,2
    80004e12:	f5040513          	addi	a0,s0,-176
    80004e16:	aa9ff0ef          	jal	800048be <create>
    80004e1a:	84aa                	mv	s1,a0
    if(ip == 0){
    80004e1c:	c541                	beqz	a0,80004ea4 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004e1e:	04449703          	lh	a4,68(s1)
    80004e22:	478d                	li	a5,3
    80004e24:	00f71763          	bne	a4,a5,80004e32 <sys_open+0x5e>
    80004e28:	0464d703          	lhu	a4,70(s1)
    80004e2c:	47a5                	li	a5,9
    80004e2e:	0ae7ed63          	bltu	a5,a4,80004ee8 <sys_open+0x114>
    80004e32:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004e34:	fe1fe0ef          	jal	80003e14 <filealloc>
    80004e38:	892a                	mv	s2,a0
    80004e3a:	c179                	beqz	a0,80004f00 <sys_open+0x12c>
    80004e3c:	ed4e                	sd	s3,152(sp)
    80004e3e:	a43ff0ef          	jal	80004880 <fdalloc>
    80004e42:	89aa                	mv	s3,a0
    80004e44:	0a054a63          	bltz	a0,80004ef8 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004e48:	04449703          	lh	a4,68(s1)
    80004e4c:	478d                	li	a5,3
    80004e4e:	0cf70263          	beq	a4,a5,80004f12 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e52:	4789                	li	a5,2
    80004e54:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004e58:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004e5c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004e60:	f4c42783          	lw	a5,-180(s0)
    80004e64:	0017c713          	xori	a4,a5,1
    80004e68:	8b05                	andi	a4,a4,1
    80004e6a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e6e:	0037f713          	andi	a4,a5,3
    80004e72:	00e03733          	snez	a4,a4
    80004e76:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e7a:	4007f793          	andi	a5,a5,1024
    80004e7e:	c791                	beqz	a5,80004e8a <sys_open+0xb6>
    80004e80:	04449703          	lh	a4,68(s1)
    80004e84:	4789                	li	a5,2
    80004e86:	08f70d63          	beq	a4,a5,80004f20 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e8a:	8526                	mv	a0,s1
    80004e8c:	c2afe0ef          	jal	800032b6 <iunlock>
  end_op();
    80004e90:	c79fe0ef          	jal	80003b08 <end_op>

  return fd;
    80004e94:	854e                	mv	a0,s3
    80004e96:	74aa                	ld	s1,168(sp)
    80004e98:	790a                	ld	s2,160(sp)
    80004e9a:	69ea                	ld	s3,152(sp)
}
    80004e9c:	70ea                	ld	ra,184(sp)
    80004e9e:	744a                	ld	s0,176(sp)
    80004ea0:	6129                	addi	sp,sp,192
    80004ea2:	8082                	ret
      end_op();
    80004ea4:	c65fe0ef          	jal	80003b08 <end_op>
      return -1;
    80004ea8:	557d                	li	a0,-1
    80004eaa:	74aa                	ld	s1,168(sp)
    80004eac:	bfc5                	j	80004e9c <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004eae:	f5040513          	addi	a0,s0,-176
    80004eb2:	a31fe0ef          	jal	800038e2 <namei>
    80004eb6:	84aa                	mv	s1,a0
    80004eb8:	c11d                	beqz	a0,80004ede <sys_open+0x10a>
    ilock(ip);
    80004eba:	b4efe0ef          	jal	80003208 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004ebe:	04449703          	lh	a4,68(s1)
    80004ec2:	4785                	li	a5,1
    80004ec4:	f4f71de3          	bne	a4,a5,80004e1e <sys_open+0x4a>
    80004ec8:	f4c42783          	lw	a5,-180(s0)
    80004ecc:	d3bd                	beqz	a5,80004e32 <sys_open+0x5e>
      iunlockput(ip);
    80004ece:	8526                	mv	a0,s1
    80004ed0:	d42fe0ef          	jal	80003412 <iunlockput>
      end_op();
    80004ed4:	c35fe0ef          	jal	80003b08 <end_op>
      return -1;
    80004ed8:	557d                	li	a0,-1
    80004eda:	74aa                	ld	s1,168(sp)
    80004edc:	b7c1                	j	80004e9c <sys_open+0xc8>
      end_op();
    80004ede:	c2bfe0ef          	jal	80003b08 <end_op>
      return -1;
    80004ee2:	557d                	li	a0,-1
    80004ee4:	74aa                	ld	s1,168(sp)
    80004ee6:	bf5d                	j	80004e9c <sys_open+0xc8>
    iunlockput(ip);
    80004ee8:	8526                	mv	a0,s1
    80004eea:	d28fe0ef          	jal	80003412 <iunlockput>
    end_op();
    80004eee:	c1bfe0ef          	jal	80003b08 <end_op>
    return -1;
    80004ef2:	557d                	li	a0,-1
    80004ef4:	74aa                	ld	s1,168(sp)
    80004ef6:	b75d                	j	80004e9c <sys_open+0xc8>
      fileclose(f);
    80004ef8:	854a                	mv	a0,s2
    80004efa:	fbffe0ef          	jal	80003eb8 <fileclose>
    80004efe:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004f00:	8526                	mv	a0,s1
    80004f02:	d10fe0ef          	jal	80003412 <iunlockput>
    end_op();
    80004f06:	c03fe0ef          	jal	80003b08 <end_op>
    return -1;
    80004f0a:	557d                	li	a0,-1
    80004f0c:	74aa                	ld	s1,168(sp)
    80004f0e:	790a                	ld	s2,160(sp)
    80004f10:	b771                	j	80004e9c <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004f12:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004f16:	04649783          	lh	a5,70(s1)
    80004f1a:	02f91223          	sh	a5,36(s2)
    80004f1e:	bf3d                	j	80004e5c <sys_open+0x88>
    itrunc(ip);
    80004f20:	8526                	mv	a0,s1
    80004f22:	bd4fe0ef          	jal	800032f6 <itrunc>
    80004f26:	b795                	j	80004e8a <sys_open+0xb6>

0000000080004f28 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f28:	7175                	addi	sp,sp,-144
    80004f2a:	e506                	sd	ra,136(sp)
    80004f2c:	e122                	sd	s0,128(sp)
    80004f2e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f30:	b6ffe0ef          	jal	80003a9e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f34:	08000613          	li	a2,128
    80004f38:	f7040593          	addi	a1,s0,-144
    80004f3c:	4501                	li	a0,0
    80004f3e:	89dfd0ef          	jal	800027da <argstr>
    80004f42:	02054363          	bltz	a0,80004f68 <sys_mkdir+0x40>
    80004f46:	4681                	li	a3,0
    80004f48:	4601                	li	a2,0
    80004f4a:	4585                	li	a1,1
    80004f4c:	f7040513          	addi	a0,s0,-144
    80004f50:	96fff0ef          	jal	800048be <create>
    80004f54:	c911                	beqz	a0,80004f68 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f56:	cbcfe0ef          	jal	80003412 <iunlockput>
  end_op();
    80004f5a:	baffe0ef          	jal	80003b08 <end_op>
  return 0;
    80004f5e:	4501                	li	a0,0
}
    80004f60:	60aa                	ld	ra,136(sp)
    80004f62:	640a                	ld	s0,128(sp)
    80004f64:	6149                	addi	sp,sp,144
    80004f66:	8082                	ret
    end_op();
    80004f68:	ba1fe0ef          	jal	80003b08 <end_op>
    return -1;
    80004f6c:	557d                	li	a0,-1
    80004f6e:	bfcd                	j	80004f60 <sys_mkdir+0x38>

0000000080004f70 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f70:	7135                	addi	sp,sp,-160
    80004f72:	ed06                	sd	ra,152(sp)
    80004f74:	e922                	sd	s0,144(sp)
    80004f76:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f78:	b27fe0ef          	jal	80003a9e <begin_op>
  argint(1, &major);
    80004f7c:	f6c40593          	addi	a1,s0,-148
    80004f80:	4505                	li	a0,1
    80004f82:	821fd0ef          	jal	800027a2 <argint>
  argint(2, &minor);
    80004f86:	f6840593          	addi	a1,s0,-152
    80004f8a:	4509                	li	a0,2
    80004f8c:	817fd0ef          	jal	800027a2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f90:	08000613          	li	a2,128
    80004f94:	f7040593          	addi	a1,s0,-144
    80004f98:	4501                	li	a0,0
    80004f9a:	841fd0ef          	jal	800027da <argstr>
    80004f9e:	02054563          	bltz	a0,80004fc8 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004fa2:	f6841683          	lh	a3,-152(s0)
    80004fa6:	f6c41603          	lh	a2,-148(s0)
    80004faa:	458d                	li	a1,3
    80004fac:	f7040513          	addi	a0,s0,-144
    80004fb0:	90fff0ef          	jal	800048be <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fb4:	c911                	beqz	a0,80004fc8 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fb6:	c5cfe0ef          	jal	80003412 <iunlockput>
  end_op();
    80004fba:	b4ffe0ef          	jal	80003b08 <end_op>
  return 0;
    80004fbe:	4501                	li	a0,0
}
    80004fc0:	60ea                	ld	ra,152(sp)
    80004fc2:	644a                	ld	s0,144(sp)
    80004fc4:	610d                	addi	sp,sp,160
    80004fc6:	8082                	ret
    end_op();
    80004fc8:	b41fe0ef          	jal	80003b08 <end_op>
    return -1;
    80004fcc:	557d                	li	a0,-1
    80004fce:	bfcd                	j	80004fc0 <sys_mknod+0x50>

0000000080004fd0 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fd0:	7135                	addi	sp,sp,-160
    80004fd2:	ed06                	sd	ra,152(sp)
    80004fd4:	e922                	sd	s0,144(sp)
    80004fd6:	e14a                	sd	s2,128(sp)
    80004fd8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fda:	915fc0ef          	jal	800018ee <myproc>
    80004fde:	892a                	mv	s2,a0
  
  begin_op();
    80004fe0:	abffe0ef          	jal	80003a9e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fe4:	08000613          	li	a2,128
    80004fe8:	f6040593          	addi	a1,s0,-160
    80004fec:	4501                	li	a0,0
    80004fee:	fecfd0ef          	jal	800027da <argstr>
    80004ff2:	04054363          	bltz	a0,80005038 <sys_chdir+0x68>
    80004ff6:	e526                	sd	s1,136(sp)
    80004ff8:	f6040513          	addi	a0,s0,-160
    80004ffc:	8e7fe0ef          	jal	800038e2 <namei>
    80005000:	84aa                	mv	s1,a0
    80005002:	c915                	beqz	a0,80005036 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005004:	a04fe0ef          	jal	80003208 <ilock>
  if(ip->type != T_DIR){
    80005008:	04449703          	lh	a4,68(s1)
    8000500c:	4785                	li	a5,1
    8000500e:	02f71963          	bne	a4,a5,80005040 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005012:	8526                	mv	a0,s1
    80005014:	aa2fe0ef          	jal	800032b6 <iunlock>
  iput(p->cwd);
    80005018:	15093503          	ld	a0,336(s2)
    8000501c:	b6efe0ef          	jal	8000338a <iput>
  end_op();
    80005020:	ae9fe0ef          	jal	80003b08 <end_op>
  p->cwd = ip;
    80005024:	14993823          	sd	s1,336(s2)
  return 0;
    80005028:	4501                	li	a0,0
    8000502a:	64aa                	ld	s1,136(sp)
}
    8000502c:	60ea                	ld	ra,152(sp)
    8000502e:	644a                	ld	s0,144(sp)
    80005030:	690a                	ld	s2,128(sp)
    80005032:	610d                	addi	sp,sp,160
    80005034:	8082                	ret
    80005036:	64aa                	ld	s1,136(sp)
    end_op();
    80005038:	ad1fe0ef          	jal	80003b08 <end_op>
    return -1;
    8000503c:	557d                	li	a0,-1
    8000503e:	b7fd                	j	8000502c <sys_chdir+0x5c>
    iunlockput(ip);
    80005040:	8526                	mv	a0,s1
    80005042:	bd0fe0ef          	jal	80003412 <iunlockput>
    end_op();
    80005046:	ac3fe0ef          	jal	80003b08 <end_op>
    return -1;
    8000504a:	557d                	li	a0,-1
    8000504c:	64aa                	ld	s1,136(sp)
    8000504e:	bff9                	j	8000502c <sys_chdir+0x5c>

0000000080005050 <sys_exec>:

uint64
sys_exec(void)
{
    80005050:	7121                	addi	sp,sp,-448
    80005052:	ff06                	sd	ra,440(sp)
    80005054:	fb22                	sd	s0,432(sp)
    80005056:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005058:	e4840593          	addi	a1,s0,-440
    8000505c:	4505                	li	a0,1
    8000505e:	f60fd0ef          	jal	800027be <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005062:	08000613          	li	a2,128
    80005066:	f5040593          	addi	a1,s0,-176
    8000506a:	4501                	li	a0,0
    8000506c:	f6efd0ef          	jal	800027da <argstr>
    80005070:	87aa                	mv	a5,a0
    return -1;
    80005072:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005074:	0c07c463          	bltz	a5,8000513c <sys_exec+0xec>
    80005078:	f726                	sd	s1,424(sp)
    8000507a:	f34a                	sd	s2,416(sp)
    8000507c:	ef4e                	sd	s3,408(sp)
    8000507e:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005080:	10000613          	li	a2,256
    80005084:	4581                	li	a1,0
    80005086:	e5040513          	addi	a0,s0,-432
    8000508a:	c4dfb0ef          	jal	80000cd6 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000508e:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005092:	89a6                	mv	s3,s1
    80005094:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005096:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000509a:	00391513          	slli	a0,s2,0x3
    8000509e:	e4040593          	addi	a1,s0,-448
    800050a2:	e4843783          	ld	a5,-440(s0)
    800050a6:	953e                	add	a0,a0,a5
    800050a8:	e70fd0ef          	jal	80002718 <fetchaddr>
    800050ac:	02054663          	bltz	a0,800050d8 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800050b0:	e4043783          	ld	a5,-448(s0)
    800050b4:	c3a9                	beqz	a5,800050f6 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050b6:	a7dfb0ef          	jal	80000b32 <kalloc>
    800050ba:	85aa                	mv	a1,a0
    800050bc:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050c0:	cd01                	beqz	a0,800050d8 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050c2:	6605                	lui	a2,0x1
    800050c4:	e4043503          	ld	a0,-448(s0)
    800050c8:	e9afd0ef          	jal	80002762 <fetchstr>
    800050cc:	00054663          	bltz	a0,800050d8 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800050d0:	0905                	addi	s2,s2,1
    800050d2:	09a1                	addi	s3,s3,8
    800050d4:	fd4913e3          	bne	s2,s4,8000509a <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050d8:	f5040913          	addi	s2,s0,-176
    800050dc:	6088                	ld	a0,0(s1)
    800050de:	c931                	beqz	a0,80005132 <sys_exec+0xe2>
    kfree(argv[i]);
    800050e0:	971fb0ef          	jal	80000a50 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050e4:	04a1                	addi	s1,s1,8
    800050e6:	ff249be3          	bne	s1,s2,800050dc <sys_exec+0x8c>
  return -1;
    800050ea:	557d                	li	a0,-1
    800050ec:	74ba                	ld	s1,424(sp)
    800050ee:	791a                	ld	s2,416(sp)
    800050f0:	69fa                	ld	s3,408(sp)
    800050f2:	6a5a                	ld	s4,400(sp)
    800050f4:	a0a1                	j	8000513c <sys_exec+0xec>
      argv[i] = 0;
    800050f6:	0009079b          	sext.w	a5,s2
    800050fa:	078e                	slli	a5,a5,0x3
    800050fc:	fd078793          	addi	a5,a5,-48
    80005100:	97a2                	add	a5,a5,s0
    80005102:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005106:	e5040593          	addi	a1,s0,-432
    8000510a:	f5040513          	addi	a0,s0,-176
    8000510e:	ba8ff0ef          	jal	800044b6 <exec>
    80005112:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005114:	f5040993          	addi	s3,s0,-176
    80005118:	6088                	ld	a0,0(s1)
    8000511a:	c511                	beqz	a0,80005126 <sys_exec+0xd6>
    kfree(argv[i]);
    8000511c:	935fb0ef          	jal	80000a50 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005120:	04a1                	addi	s1,s1,8
    80005122:	ff349be3          	bne	s1,s3,80005118 <sys_exec+0xc8>
  return ret;
    80005126:	854a                	mv	a0,s2
    80005128:	74ba                	ld	s1,424(sp)
    8000512a:	791a                	ld	s2,416(sp)
    8000512c:	69fa                	ld	s3,408(sp)
    8000512e:	6a5a                	ld	s4,400(sp)
    80005130:	a031                	j	8000513c <sys_exec+0xec>
  return -1;
    80005132:	557d                	li	a0,-1
    80005134:	74ba                	ld	s1,424(sp)
    80005136:	791a                	ld	s2,416(sp)
    80005138:	69fa                	ld	s3,408(sp)
    8000513a:	6a5a                	ld	s4,400(sp)
}
    8000513c:	70fa                	ld	ra,440(sp)
    8000513e:	745a                	ld	s0,432(sp)
    80005140:	6139                	addi	sp,sp,448
    80005142:	8082                	ret

0000000080005144 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005144:	7139                	addi	sp,sp,-64
    80005146:	fc06                	sd	ra,56(sp)
    80005148:	f822                	sd	s0,48(sp)
    8000514a:	f426                	sd	s1,40(sp)
    8000514c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000514e:	fa0fc0ef          	jal	800018ee <myproc>
    80005152:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005154:	fd840593          	addi	a1,s0,-40
    80005158:	4501                	li	a0,0
    8000515a:	e64fd0ef          	jal	800027be <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000515e:	fc840593          	addi	a1,s0,-56
    80005162:	fd040513          	addi	a0,s0,-48
    80005166:	85cff0ef          	jal	800041c2 <pipealloc>
    return -1;
    8000516a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000516c:	0a054463          	bltz	a0,80005214 <sys_pipe+0xd0>
  fd0 = -1;
    80005170:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005174:	fd043503          	ld	a0,-48(s0)
    80005178:	f08ff0ef          	jal	80004880 <fdalloc>
    8000517c:	fca42223          	sw	a0,-60(s0)
    80005180:	08054163          	bltz	a0,80005202 <sys_pipe+0xbe>
    80005184:	fc843503          	ld	a0,-56(s0)
    80005188:	ef8ff0ef          	jal	80004880 <fdalloc>
    8000518c:	fca42023          	sw	a0,-64(s0)
    80005190:	06054063          	bltz	a0,800051f0 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005194:	4691                	li	a3,4
    80005196:	fc440613          	addi	a2,s0,-60
    8000519a:	fd843583          	ld	a1,-40(s0)
    8000519e:	68a8                	ld	a0,80(s1)
    800051a0:	bc0fc0ef          	jal	80001560 <copyout>
    800051a4:	00054e63          	bltz	a0,800051c0 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051a8:	4691                	li	a3,4
    800051aa:	fc040613          	addi	a2,s0,-64
    800051ae:	fd843583          	ld	a1,-40(s0)
    800051b2:	0591                	addi	a1,a1,4
    800051b4:	68a8                	ld	a0,80(s1)
    800051b6:	baafc0ef          	jal	80001560 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051ba:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051bc:	04055c63          	bgez	a0,80005214 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800051c0:	fc442783          	lw	a5,-60(s0)
    800051c4:	07e9                	addi	a5,a5,26
    800051c6:	078e                	slli	a5,a5,0x3
    800051c8:	97a6                	add	a5,a5,s1
    800051ca:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800051ce:	fc042783          	lw	a5,-64(s0)
    800051d2:	07e9                	addi	a5,a5,26
    800051d4:	078e                	slli	a5,a5,0x3
    800051d6:	94be                	add	s1,s1,a5
    800051d8:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800051dc:	fd043503          	ld	a0,-48(s0)
    800051e0:	cd9fe0ef          	jal	80003eb8 <fileclose>
    fileclose(wf);
    800051e4:	fc843503          	ld	a0,-56(s0)
    800051e8:	cd1fe0ef          	jal	80003eb8 <fileclose>
    return -1;
    800051ec:	57fd                	li	a5,-1
    800051ee:	a01d                	j	80005214 <sys_pipe+0xd0>
    if(fd0 >= 0)
    800051f0:	fc442783          	lw	a5,-60(s0)
    800051f4:	0007c763          	bltz	a5,80005202 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800051f8:	07e9                	addi	a5,a5,26
    800051fa:	078e                	slli	a5,a5,0x3
    800051fc:	97a6                	add	a5,a5,s1
    800051fe:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005202:	fd043503          	ld	a0,-48(s0)
    80005206:	cb3fe0ef          	jal	80003eb8 <fileclose>
    fileclose(wf);
    8000520a:	fc843503          	ld	a0,-56(s0)
    8000520e:	cabfe0ef          	jal	80003eb8 <fileclose>
    return -1;
    80005212:	57fd                	li	a5,-1
}
    80005214:	853e                	mv	a0,a5
    80005216:	70e2                	ld	ra,56(sp)
    80005218:	7442                	ld	s0,48(sp)
    8000521a:	74a2                	ld	s1,40(sp)
    8000521c:	6121                	addi	sp,sp,64
    8000521e:	8082                	ret

0000000080005220 <kernelvec>:
    80005220:	7111                	addi	sp,sp,-256
    80005222:	e006                	sd	ra,0(sp)
    80005224:	e40a                	sd	sp,8(sp)
    80005226:	e80e                	sd	gp,16(sp)
    80005228:	ec12                	sd	tp,24(sp)
    8000522a:	f016                	sd	t0,32(sp)
    8000522c:	f41a                	sd	t1,40(sp)
    8000522e:	f81e                	sd	t2,48(sp)
    80005230:	e4aa                	sd	a0,72(sp)
    80005232:	e8ae                	sd	a1,80(sp)
    80005234:	ecb2                	sd	a2,88(sp)
    80005236:	f0b6                	sd	a3,96(sp)
    80005238:	f4ba                	sd	a4,104(sp)
    8000523a:	f8be                	sd	a5,112(sp)
    8000523c:	fcc2                	sd	a6,120(sp)
    8000523e:	e146                	sd	a7,128(sp)
    80005240:	edf2                	sd	t3,216(sp)
    80005242:	f1f6                	sd	t4,224(sp)
    80005244:	f5fa                	sd	t5,232(sp)
    80005246:	f9fe                	sd	t6,240(sp)
    80005248:	be0fd0ef          	jal	80002628 <kerneltrap>
    8000524c:	6082                	ld	ra,0(sp)
    8000524e:	6122                	ld	sp,8(sp)
    80005250:	61c2                	ld	gp,16(sp)
    80005252:	7282                	ld	t0,32(sp)
    80005254:	7322                	ld	t1,40(sp)
    80005256:	73c2                	ld	t2,48(sp)
    80005258:	6526                	ld	a0,72(sp)
    8000525a:	65c6                	ld	a1,80(sp)
    8000525c:	6666                	ld	a2,88(sp)
    8000525e:	7686                	ld	a3,96(sp)
    80005260:	7726                	ld	a4,104(sp)
    80005262:	77c6                	ld	a5,112(sp)
    80005264:	7866                	ld	a6,120(sp)
    80005266:	688a                	ld	a7,128(sp)
    80005268:	6e6e                	ld	t3,216(sp)
    8000526a:	7e8e                	ld	t4,224(sp)
    8000526c:	7f2e                	ld	t5,232(sp)
    8000526e:	7fce                	ld	t6,240(sp)
    80005270:	6111                	addi	sp,sp,256
    80005272:	10200073          	sret
	...

000000008000527e <plicinit>:
    8000527e:	1141                	addi	sp,sp,-16
    80005280:	e422                	sd	s0,8(sp)
    80005282:	0800                	addi	s0,sp,16
    80005284:	0c0007b7          	lui	a5,0xc000
    80005288:	4705                	li	a4,1
    8000528a:	d798                	sw	a4,40(a5)
    8000528c:	0c0007b7          	lui	a5,0xc000
    80005290:	c3d8                	sw	a4,4(a5)
    80005292:	6422                	ld	s0,8(sp)
    80005294:	0141                	addi	sp,sp,16
    80005296:	8082                	ret

0000000080005298 <plicinithart>:
    80005298:	1141                	addi	sp,sp,-16
    8000529a:	e406                	sd	ra,8(sp)
    8000529c:	e022                	sd	s0,0(sp)
    8000529e:	0800                	addi	s0,sp,16
    800052a0:	e22fc0ef          	jal	800018c2 <cpuid>
    800052a4:	0085171b          	slliw	a4,a0,0x8
    800052a8:	0c0027b7          	lui	a5,0xc002
    800052ac:	97ba                	add	a5,a5,a4
    800052ae:	40200713          	li	a4,1026
    800052b2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>
    800052b6:	00d5151b          	slliw	a0,a0,0xd
    800052ba:	0c2017b7          	lui	a5,0xc201
    800052be:	97aa                	add	a5,a5,a0
    800052c0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
    800052c4:	60a2                	ld	ra,8(sp)
    800052c6:	6402                	ld	s0,0(sp)
    800052c8:	0141                	addi	sp,sp,16
    800052ca:	8082                	ret

00000000800052cc <plic_claim>:
    800052cc:	1141                	addi	sp,sp,-16
    800052ce:	e406                	sd	ra,8(sp)
    800052d0:	e022                	sd	s0,0(sp)
    800052d2:	0800                	addi	s0,sp,16
    800052d4:	deefc0ef          	jal	800018c2 <cpuid>
    800052d8:	00d5151b          	slliw	a0,a0,0xd
    800052dc:	0c2017b7          	lui	a5,0xc201
    800052e0:	97aa                	add	a5,a5,a0
    800052e2:	43c8                	lw	a0,4(a5)
    800052e4:	60a2                	ld	ra,8(sp)
    800052e6:	6402                	ld	s0,0(sp)
    800052e8:	0141                	addi	sp,sp,16
    800052ea:	8082                	ret

00000000800052ec <plic_complete>:
    800052ec:	1101                	addi	sp,sp,-32
    800052ee:	ec06                	sd	ra,24(sp)
    800052f0:	e822                	sd	s0,16(sp)
    800052f2:	e426                	sd	s1,8(sp)
    800052f4:	1000                	addi	s0,sp,32
    800052f6:	84aa                	mv	s1,a0
    800052f8:	dcafc0ef          	jal	800018c2 <cpuid>
    800052fc:	00d5151b          	slliw	a0,a0,0xd
    80005300:	0c2017b7          	lui	a5,0xc201
    80005304:	97aa                	add	a5,a5,a0
    80005306:	c3c4                	sw	s1,4(a5)
    80005308:	60e2                	ld	ra,24(sp)
    8000530a:	6442                	ld	s0,16(sp)
    8000530c:	64a2                	ld	s1,8(sp)
    8000530e:	6105                	addi	sp,sp,32
    80005310:	8082                	ret

0000000080005312 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005312:	1141                	addi	sp,sp,-16
    80005314:	e406                	sd	ra,8(sp)
    80005316:	e022                	sd	s0,0(sp)
    80005318:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000531a:	479d                	li	a5,7
    8000531c:	04a7ca63          	blt	a5,a0,80005370 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005320:	0001e797          	auipc	a5,0x1e
    80005324:	18078793          	addi	a5,a5,384 # 800234a0 <disk>
    80005328:	97aa                	add	a5,a5,a0
    8000532a:	0187c783          	lbu	a5,24(a5)
    8000532e:	e7b9                	bnez	a5,8000537c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005330:	00451693          	slli	a3,a0,0x4
    80005334:	0001e797          	auipc	a5,0x1e
    80005338:	16c78793          	addi	a5,a5,364 # 800234a0 <disk>
    8000533c:	6398                	ld	a4,0(a5)
    8000533e:	9736                	add	a4,a4,a3
    80005340:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005344:	6398                	ld	a4,0(a5)
    80005346:	9736                	add	a4,a4,a3
    80005348:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000534c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005350:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005354:	97aa                	add	a5,a5,a0
    80005356:	4705                	li	a4,1
    80005358:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000535c:	0001e517          	auipc	a0,0x1e
    80005360:	15c50513          	addi	a0,a0,348 # 800234b8 <disk+0x18>
    80005364:	ba5fc0ef          	jal	80001f08 <wakeup>
}
    80005368:	60a2                	ld	ra,8(sp)
    8000536a:	6402                	ld	s0,0(sp)
    8000536c:	0141                	addi	sp,sp,16
    8000536e:	8082                	ret
    panic("free_desc 1");
    80005370:	00002517          	auipc	a0,0x2
    80005374:	30050513          	addi	a0,a0,768 # 80007670 <etext+0x670>
    80005378:	c2afb0ef          	jal	800007a2 <panic>
    panic("free_desc 2");
    8000537c:	00002517          	auipc	a0,0x2
    80005380:	30450513          	addi	a0,a0,772 # 80007680 <etext+0x680>
    80005384:	c1efb0ef          	jal	800007a2 <panic>

0000000080005388 <virtio_disk_init>:
{
    80005388:	1101                	addi	sp,sp,-32
    8000538a:	ec06                	sd	ra,24(sp)
    8000538c:	e822                	sd	s0,16(sp)
    8000538e:	e426                	sd	s1,8(sp)
    80005390:	e04a                	sd	s2,0(sp)
    80005392:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005394:	00002597          	auipc	a1,0x2
    80005398:	2fc58593          	addi	a1,a1,764 # 80007690 <etext+0x690>
    8000539c:	0001e517          	auipc	a0,0x1e
    800053a0:	22c50513          	addi	a0,a0,556 # 800235c8 <disk+0x128>
    800053a4:	fdefb0ef          	jal	80000b82 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053a8:	100017b7          	lui	a5,0x10001
    800053ac:	4398                	lw	a4,0(a5)
    800053ae:	2701                	sext.w	a4,a4
    800053b0:	747277b7          	lui	a5,0x74727
    800053b4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053b8:	18f71063          	bne	a4,a5,80005538 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800053bc:	100017b7          	lui	a5,0x10001
    800053c0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800053c2:	439c                	lw	a5,0(a5)
    800053c4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053c6:	4709                	li	a4,2
    800053c8:	16e79863          	bne	a5,a4,80005538 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053cc:	100017b7          	lui	a5,0x10001
    800053d0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800053d2:	439c                	lw	a5,0(a5)
    800053d4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800053d6:	16e79163          	bne	a5,a4,80005538 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053da:	100017b7          	lui	a5,0x10001
    800053de:	47d8                	lw	a4,12(a5)
    800053e0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053e2:	554d47b7          	lui	a5,0x554d4
    800053e6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053ea:	14f71763          	bne	a4,a5,80005538 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053ee:	100017b7          	lui	a5,0x10001
    800053f2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053f6:	4705                	li	a4,1
    800053f8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053fa:	470d                	li	a4,3
    800053fc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053fe:	10001737          	lui	a4,0x10001
    80005402:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005404:	c7ffe737          	lui	a4,0xc7ffe
    80005408:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb17f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000540c:	8ef9                	and	a3,a3,a4
    8000540e:	10001737          	lui	a4,0x10001
    80005412:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005414:	472d                	li	a4,11
    80005416:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005418:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000541c:	439c                	lw	a5,0(a5)
    8000541e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005422:	8ba1                	andi	a5,a5,8
    80005424:	12078063          	beqz	a5,80005544 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005428:	100017b7          	lui	a5,0x10001
    8000542c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005430:	100017b7          	lui	a5,0x10001
    80005434:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005438:	439c                	lw	a5,0(a5)
    8000543a:	2781                	sext.w	a5,a5
    8000543c:	10079a63          	bnez	a5,80005550 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005440:	100017b7          	lui	a5,0x10001
    80005444:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005448:	439c                	lw	a5,0(a5)
    8000544a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000544c:	10078863          	beqz	a5,8000555c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005450:	471d                	li	a4,7
    80005452:	10f77b63          	bgeu	a4,a5,80005568 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005456:	edcfb0ef          	jal	80000b32 <kalloc>
    8000545a:	0001e497          	auipc	s1,0x1e
    8000545e:	04648493          	addi	s1,s1,70 # 800234a0 <disk>
    80005462:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005464:	ecefb0ef          	jal	80000b32 <kalloc>
    80005468:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000546a:	ec8fb0ef          	jal	80000b32 <kalloc>
    8000546e:	87aa                	mv	a5,a0
    80005470:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005472:	6088                	ld	a0,0(s1)
    80005474:	10050063          	beqz	a0,80005574 <virtio_disk_init+0x1ec>
    80005478:	0001e717          	auipc	a4,0x1e
    8000547c:	03073703          	ld	a4,48(a4) # 800234a8 <disk+0x8>
    80005480:	0e070a63          	beqz	a4,80005574 <virtio_disk_init+0x1ec>
    80005484:	0e078863          	beqz	a5,80005574 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005488:	6605                	lui	a2,0x1
    8000548a:	4581                	li	a1,0
    8000548c:	84bfb0ef          	jal	80000cd6 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005490:	0001e497          	auipc	s1,0x1e
    80005494:	01048493          	addi	s1,s1,16 # 800234a0 <disk>
    80005498:	6605                	lui	a2,0x1
    8000549a:	4581                	li	a1,0
    8000549c:	6488                	ld	a0,8(s1)
    8000549e:	839fb0ef          	jal	80000cd6 <memset>
  memset(disk.used, 0, PGSIZE);
    800054a2:	6605                	lui	a2,0x1
    800054a4:	4581                	li	a1,0
    800054a6:	6888                	ld	a0,16(s1)
    800054a8:	82ffb0ef          	jal	80000cd6 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054ac:	100017b7          	lui	a5,0x10001
    800054b0:	4721                	li	a4,8
    800054b2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800054b4:	4098                	lw	a4,0(s1)
    800054b6:	100017b7          	lui	a5,0x10001
    800054ba:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800054be:	40d8                	lw	a4,4(s1)
    800054c0:	100017b7          	lui	a5,0x10001
    800054c4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800054c8:	649c                	ld	a5,8(s1)
    800054ca:	0007869b          	sext.w	a3,a5
    800054ce:	10001737          	lui	a4,0x10001
    800054d2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800054d6:	9781                	srai	a5,a5,0x20
    800054d8:	10001737          	lui	a4,0x10001
    800054dc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800054e0:	689c                	ld	a5,16(s1)
    800054e2:	0007869b          	sext.w	a3,a5
    800054e6:	10001737          	lui	a4,0x10001
    800054ea:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800054ee:	9781                	srai	a5,a5,0x20
    800054f0:	10001737          	lui	a4,0x10001
    800054f4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800054f8:	10001737          	lui	a4,0x10001
    800054fc:	4785                	li	a5,1
    800054fe:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005500:	00f48c23          	sb	a5,24(s1)
    80005504:	00f48ca3          	sb	a5,25(s1)
    80005508:	00f48d23          	sb	a5,26(s1)
    8000550c:	00f48da3          	sb	a5,27(s1)
    80005510:	00f48e23          	sb	a5,28(s1)
    80005514:	00f48ea3          	sb	a5,29(s1)
    80005518:	00f48f23          	sb	a5,30(s1)
    8000551c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005520:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005524:	100017b7          	lui	a5,0x10001
    80005528:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000552c:	60e2                	ld	ra,24(sp)
    8000552e:	6442                	ld	s0,16(sp)
    80005530:	64a2                	ld	s1,8(sp)
    80005532:	6902                	ld	s2,0(sp)
    80005534:	6105                	addi	sp,sp,32
    80005536:	8082                	ret
    panic("could not find virtio disk");
    80005538:	00002517          	auipc	a0,0x2
    8000553c:	16850513          	addi	a0,a0,360 # 800076a0 <etext+0x6a0>
    80005540:	a62fb0ef          	jal	800007a2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005544:	00002517          	auipc	a0,0x2
    80005548:	17c50513          	addi	a0,a0,380 # 800076c0 <etext+0x6c0>
    8000554c:	a56fb0ef          	jal	800007a2 <panic>
    panic("virtio disk should not be ready");
    80005550:	00002517          	auipc	a0,0x2
    80005554:	19050513          	addi	a0,a0,400 # 800076e0 <etext+0x6e0>
    80005558:	a4afb0ef          	jal	800007a2 <panic>
    panic("virtio disk has no queue 0");
    8000555c:	00002517          	auipc	a0,0x2
    80005560:	1a450513          	addi	a0,a0,420 # 80007700 <etext+0x700>
    80005564:	a3efb0ef          	jal	800007a2 <panic>
    panic("virtio disk max queue too short");
    80005568:	00002517          	auipc	a0,0x2
    8000556c:	1b850513          	addi	a0,a0,440 # 80007720 <etext+0x720>
    80005570:	a32fb0ef          	jal	800007a2 <panic>
    panic("virtio disk kalloc");
    80005574:	00002517          	auipc	a0,0x2
    80005578:	1cc50513          	addi	a0,a0,460 # 80007740 <etext+0x740>
    8000557c:	a26fb0ef          	jal	800007a2 <panic>

0000000080005580 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005580:	7159                	addi	sp,sp,-112
    80005582:	f486                	sd	ra,104(sp)
    80005584:	f0a2                	sd	s0,96(sp)
    80005586:	eca6                	sd	s1,88(sp)
    80005588:	e8ca                	sd	s2,80(sp)
    8000558a:	e4ce                	sd	s3,72(sp)
    8000558c:	e0d2                	sd	s4,64(sp)
    8000558e:	fc56                	sd	s5,56(sp)
    80005590:	f85a                	sd	s6,48(sp)
    80005592:	f45e                	sd	s7,40(sp)
    80005594:	f062                	sd	s8,32(sp)
    80005596:	ec66                	sd	s9,24(sp)
    80005598:	1880                	addi	s0,sp,112
    8000559a:	8a2a                	mv	s4,a0
    8000559c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000559e:	00c52c83          	lw	s9,12(a0)
    800055a2:	001c9c9b          	slliw	s9,s9,0x1
    800055a6:	1c82                	slli	s9,s9,0x20
    800055a8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800055ac:	0001e517          	auipc	a0,0x1e
    800055b0:	01c50513          	addi	a0,a0,28 # 800235c8 <disk+0x128>
    800055b4:	e4efb0ef          	jal	80000c02 <acquire>
  for(int i = 0; i < 3; i++){
    800055b8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800055ba:	44a1                	li	s1,8
      disk.free[i] = 0;
    800055bc:	0001eb17          	auipc	s6,0x1e
    800055c0:	ee4b0b13          	addi	s6,s6,-284 # 800234a0 <disk>
  for(int i = 0; i < 3; i++){
    800055c4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055c6:	0001ec17          	auipc	s8,0x1e
    800055ca:	002c0c13          	addi	s8,s8,2 # 800235c8 <disk+0x128>
    800055ce:	a8b9                	j	8000562c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    800055d0:	00fb0733          	add	a4,s6,a5
    800055d4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    800055d8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800055da:	0207c563          	bltz	a5,80005604 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    800055de:	2905                	addiw	s2,s2,1
    800055e0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800055e2:	05590963          	beq	s2,s5,80005634 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    800055e6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800055e8:	0001e717          	auipc	a4,0x1e
    800055ec:	eb870713          	addi	a4,a4,-328 # 800234a0 <disk>
    800055f0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800055f2:	01874683          	lbu	a3,24(a4)
    800055f6:	fee9                	bnez	a3,800055d0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    800055f8:	2785                	addiw	a5,a5,1
    800055fa:	0705                	addi	a4,a4,1
    800055fc:	fe979be3          	bne	a5,s1,800055f2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005600:	57fd                	li	a5,-1
    80005602:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005604:	01205d63          	blez	s2,8000561e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005608:	f9042503          	lw	a0,-112(s0)
    8000560c:	d07ff0ef          	jal	80005312 <free_desc>
      for(int j = 0; j < i; j++)
    80005610:	4785                	li	a5,1
    80005612:	0127d663          	bge	a5,s2,8000561e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005616:	f9442503          	lw	a0,-108(s0)
    8000561a:	cf9ff0ef          	jal	80005312 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000561e:	85e2                	mv	a1,s8
    80005620:	0001e517          	auipc	a0,0x1e
    80005624:	e9850513          	addi	a0,a0,-360 # 800234b8 <disk+0x18>
    80005628:	895fc0ef          	jal	80001ebc <sleep>
  for(int i = 0; i < 3; i++){
    8000562c:	f9040613          	addi	a2,s0,-112
    80005630:	894e                	mv	s2,s3
    80005632:	bf55                	j	800055e6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005634:	f9042503          	lw	a0,-112(s0)
    80005638:	00451693          	slli	a3,a0,0x4

  if(write)
    8000563c:	0001e797          	auipc	a5,0x1e
    80005640:	e6478793          	addi	a5,a5,-412 # 800234a0 <disk>
    80005644:	00a50713          	addi	a4,a0,10
    80005648:	0712                	slli	a4,a4,0x4
    8000564a:	973e                	add	a4,a4,a5
    8000564c:	01703633          	snez	a2,s7
    80005650:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005652:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005656:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000565a:	6398                	ld	a4,0(a5)
    8000565c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000565e:	0a868613          	addi	a2,a3,168
    80005662:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005664:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005666:	6390                	ld	a2,0(a5)
    80005668:	00d605b3          	add	a1,a2,a3
    8000566c:	4741                	li	a4,16
    8000566e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005670:	4805                	li	a6,1
    80005672:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005676:	f9442703          	lw	a4,-108(s0)
    8000567a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000567e:	0712                	slli	a4,a4,0x4
    80005680:	963a                	add	a2,a2,a4
    80005682:	058a0593          	addi	a1,s4,88
    80005686:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005688:	0007b883          	ld	a7,0(a5)
    8000568c:	9746                	add	a4,a4,a7
    8000568e:	40000613          	li	a2,1024
    80005692:	c710                	sw	a2,8(a4)
  if(write)
    80005694:	001bb613          	seqz	a2,s7
    80005698:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000569c:	00166613          	ori	a2,a2,1
    800056a0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800056a4:	f9842583          	lw	a1,-104(s0)
    800056a8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056ac:	00250613          	addi	a2,a0,2
    800056b0:	0612                	slli	a2,a2,0x4
    800056b2:	963e                	add	a2,a2,a5
    800056b4:	577d                	li	a4,-1
    800056b6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056ba:	0592                	slli	a1,a1,0x4
    800056bc:	98ae                	add	a7,a7,a1
    800056be:	03068713          	addi	a4,a3,48
    800056c2:	973e                	add	a4,a4,a5
    800056c4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800056c8:	6398                	ld	a4,0(a5)
    800056ca:	972e                	add	a4,a4,a1
    800056cc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056d0:	4689                	li	a3,2
    800056d2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800056d6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056da:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    800056de:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056e2:	6794                	ld	a3,8(a5)
    800056e4:	0026d703          	lhu	a4,2(a3)
    800056e8:	8b1d                	andi	a4,a4,7
    800056ea:	0706                	slli	a4,a4,0x1
    800056ec:	96ba                	add	a3,a3,a4
    800056ee:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800056f2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056f6:	6798                	ld	a4,8(a5)
    800056f8:	00275783          	lhu	a5,2(a4)
    800056fc:	2785                	addiw	a5,a5,1
    800056fe:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005702:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005706:	100017b7          	lui	a5,0x10001
    8000570a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000570e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005712:	0001e917          	auipc	s2,0x1e
    80005716:	eb690913          	addi	s2,s2,-330 # 800235c8 <disk+0x128>
  while(b->disk == 1) {
    8000571a:	4485                	li	s1,1
    8000571c:	01079a63          	bne	a5,a6,80005730 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005720:	85ca                	mv	a1,s2
    80005722:	8552                	mv	a0,s4
    80005724:	f98fc0ef          	jal	80001ebc <sleep>
  while(b->disk == 1) {
    80005728:	004a2783          	lw	a5,4(s4)
    8000572c:	fe978ae3          	beq	a5,s1,80005720 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005730:	f9042903          	lw	s2,-112(s0)
    80005734:	00290713          	addi	a4,s2,2
    80005738:	0712                	slli	a4,a4,0x4
    8000573a:	0001e797          	auipc	a5,0x1e
    8000573e:	d6678793          	addi	a5,a5,-666 # 800234a0 <disk>
    80005742:	97ba                	add	a5,a5,a4
    80005744:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005748:	0001e997          	auipc	s3,0x1e
    8000574c:	d5898993          	addi	s3,s3,-680 # 800234a0 <disk>
    80005750:	00491713          	slli	a4,s2,0x4
    80005754:	0009b783          	ld	a5,0(s3)
    80005758:	97ba                	add	a5,a5,a4
    8000575a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000575e:	854a                	mv	a0,s2
    80005760:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005764:	bafff0ef          	jal	80005312 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005768:	8885                	andi	s1,s1,1
    8000576a:	f0fd                	bnez	s1,80005750 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000576c:	0001e517          	auipc	a0,0x1e
    80005770:	e5c50513          	addi	a0,a0,-420 # 800235c8 <disk+0x128>
    80005774:	d26fb0ef          	jal	80000c9a <release>
}
    80005778:	70a6                	ld	ra,104(sp)
    8000577a:	7406                	ld	s0,96(sp)
    8000577c:	64e6                	ld	s1,88(sp)
    8000577e:	6946                	ld	s2,80(sp)
    80005780:	69a6                	ld	s3,72(sp)
    80005782:	6a06                	ld	s4,64(sp)
    80005784:	7ae2                	ld	s5,56(sp)
    80005786:	7b42                	ld	s6,48(sp)
    80005788:	7ba2                	ld	s7,40(sp)
    8000578a:	7c02                	ld	s8,32(sp)
    8000578c:	6ce2                	ld	s9,24(sp)
    8000578e:	6165                	addi	sp,sp,112
    80005790:	8082                	ret

0000000080005792 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005792:	1101                	addi	sp,sp,-32
    80005794:	ec06                	sd	ra,24(sp)
    80005796:	e822                	sd	s0,16(sp)
    80005798:	e426                	sd	s1,8(sp)
    8000579a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000579c:	0001e497          	auipc	s1,0x1e
    800057a0:	d0448493          	addi	s1,s1,-764 # 800234a0 <disk>
    800057a4:	0001e517          	auipc	a0,0x1e
    800057a8:	e2450513          	addi	a0,a0,-476 # 800235c8 <disk+0x128>
    800057ac:	c56fb0ef          	jal	80000c02 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057b0:	100017b7          	lui	a5,0x10001
    800057b4:	53b8                	lw	a4,96(a5)
    800057b6:	8b0d                	andi	a4,a4,3
    800057b8:	100017b7          	lui	a5,0x10001
    800057bc:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800057be:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057c2:	689c                	ld	a5,16(s1)
    800057c4:	0204d703          	lhu	a4,32(s1)
    800057c8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800057cc:	04f70663          	beq	a4,a5,80005818 <virtio_disk_intr+0x86>
    __sync_synchronize();
    800057d0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057d4:	6898                	ld	a4,16(s1)
    800057d6:	0204d783          	lhu	a5,32(s1)
    800057da:	8b9d                	andi	a5,a5,7
    800057dc:	078e                	slli	a5,a5,0x3
    800057de:	97ba                	add	a5,a5,a4
    800057e0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057e2:	00278713          	addi	a4,a5,2
    800057e6:	0712                	slli	a4,a4,0x4
    800057e8:	9726                	add	a4,a4,s1
    800057ea:	01074703          	lbu	a4,16(a4)
    800057ee:	e321                	bnez	a4,8000582e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057f0:	0789                	addi	a5,a5,2
    800057f2:	0792                	slli	a5,a5,0x4
    800057f4:	97a6                	add	a5,a5,s1
    800057f6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800057f8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057fc:	f0cfc0ef          	jal	80001f08 <wakeup>

    disk.used_idx += 1;
    80005800:	0204d783          	lhu	a5,32(s1)
    80005804:	2785                	addiw	a5,a5,1
    80005806:	17c2                	slli	a5,a5,0x30
    80005808:	93c1                	srli	a5,a5,0x30
    8000580a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000580e:	6898                	ld	a4,16(s1)
    80005810:	00275703          	lhu	a4,2(a4)
    80005814:	faf71ee3          	bne	a4,a5,800057d0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005818:	0001e517          	auipc	a0,0x1e
    8000581c:	db050513          	addi	a0,a0,-592 # 800235c8 <disk+0x128>
    80005820:	c7afb0ef          	jal	80000c9a <release>
}
    80005824:	60e2                	ld	ra,24(sp)
    80005826:	6442                	ld	s0,16(sp)
    80005828:	64a2                	ld	s1,8(sp)
    8000582a:	6105                	addi	sp,sp,32
    8000582c:	8082                	ret
      panic("virtio_disk_intr status");
    8000582e:	00002517          	auipc	a0,0x2
    80005832:	f2a50513          	addi	a0,a0,-214 # 80007758 <etext+0x758>
    80005836:	f6dfa0ef          	jal	800007a2 <panic>

000000008000583a <sys_kbdint>:
#include "types.h"
extern int keyboard_int_cnt;
uint64 sys_kbdint()
{
    8000583a:	1141                	addi	sp,sp,-16
    8000583c:	e422                	sd	s0,8(sp)
    8000583e:	0800                	addi	s0,sp,16

return keyboard_int_cnt;
}
    80005840:	00005517          	auipc	a0,0x5
    80005844:	a3052503          	lw	a0,-1488(a0) # 8000a270 <keyboard_int_cnt>
    80005848:	6422                	ld	s0,8(sp)
    8000584a:	0141                	addi	sp,sp,16
    8000584c:	8082                	ret
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
