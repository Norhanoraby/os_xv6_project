
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	29013103          	ld	sp,656(sp) # 8000a290 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb1df>
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
    800000fa:	17a020ef          	jal	80002274 <either_copyin>
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
    80000158:	19c50513          	addi	a0,a0,412 # 800122f0 <cons>
    8000015c:	2a7000ef          	jal	80000c02 <acquire>
    80000160:	00012497          	auipc	s1,0x12
    80000164:	19048493          	addi	s1,s1,400 # 800122f0 <cons>
    80000168:	00012917          	auipc	s2,0x12
    8000016c:	22090913          	addi	s2,s2,544 # 80012388 <cons+0x98>
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
    80000180:	780010ef          	jal	80001900 <myproc>
    80000184:	783010ef          	jal	80002106 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	541010ef          	jal	80001ece <sleep>
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    800001a0:	00012717          	auipc	a4,0x12
    800001a4:	15070713          	addi	a4,a4,336 # 800122f0 <cons>
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
    800001d2:	058020ef          	jal	8000222a <either_copyout>
    800001d6:	57fd                	li	a5,-1
    800001d8:	04f50863          	beq	a0,a5,80000228 <consoleread+0xf2>
    800001dc:	0a05                	addi	s4,s4,1
    800001de:	39fd                	addiw	s3,s3,-1
    800001e0:	47a9                	li	a5,10
    800001e2:	04fb8d63          	beq	s7,a5,8000023c <consoleread+0x106>
    800001e6:	6be2                	ld	s7,24(sp)
    800001e8:	b761                	j	80000170 <consoleread+0x3a>
    800001ea:	00012517          	auipc	a0,0x12
    800001ee:	10650513          	addi	a0,a0,262 # 800122f0 <cons>
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
    80000218:	16f72a23          	sw	a5,372(a4) # 80012388 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
    8000022a:	00012517          	auipc	a0,0x12
    8000022e:	0c650513          	addi	a0,a0,198 # 800122f0 <cons>
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
    80000282:	07250513          	addi	a0,a0,114 # 800122f0 <cons>
    80000286:	17d000ef          	jal	80000c02 <acquire>
    8000028a:	0000a717          	auipc	a4,0xa
    8000028e:	02670713          	addi	a4,a4,38 # 8000a2b0 <keyboard_int_cnt>
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
    800002ae:	010020ef          	jal	800022be <procdump>
    800002b2:	00012517          	auipc	a0,0x12
    800002b6:	03e50513          	addi	a0,a0,62 # 800122f0 <cons>
    800002ba:	1e1000ef          	jal	80000c9a <release>
    800002be:	60e2                	ld	ra,24(sp)
    800002c0:	6442                	ld	s0,16(sp)
    800002c2:	64a2                	ld	s1,8(sp)
    800002c4:	6105                	addi	sp,sp,32
    800002c6:	8082                	ret
    800002c8:	07f00793          	li	a5,127
    800002cc:	0cf48063          	beq	s1,a5,8000038c <consoleintr+0x11a>
    800002d0:	00012717          	auipc	a4,0x12
    800002d4:	02070713          	addi	a4,a4,32 # 800122f0 <cons>
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
    800002fa:	ffa78793          	addi	a5,a5,-6 # 800122f0 <cons>
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
    80000328:	0647a783          	lw	a5,100(a5) # 80012388 <cons+0x98>
    8000032c:	9f1d                	subw	a4,a4,a5
    8000032e:	08000793          	li	a5,128
    80000332:	f8f710e3          	bne	a4,a5,800002b2 <consoleintr+0x40>
    80000336:	a07d                	j	800003e4 <consoleintr+0x172>
    80000338:	e04a                	sd	s2,0(sp)
    8000033a:	00012717          	auipc	a4,0x12
    8000033e:	fb670713          	addi	a4,a4,-74 # 800122f0 <cons>
    80000342:	0a072783          	lw	a5,160(a4)
    80000346:	09c72703          	lw	a4,156(a4)
    8000034a:	00012497          	auipc	s1,0x12
    8000034e:	fa648493          	addi	s1,s1,-90 # 800122f0 <cons>
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
    80000390:	f6470713          	addi	a4,a4,-156 # 800122f0 <cons>
    80000394:	0a072783          	lw	a5,160(a4)
    80000398:	09c72703          	lw	a4,156(a4)
    8000039c:	f0f70be3          	beq	a4,a5,800002b2 <consoleintr+0x40>
    800003a0:	37fd                	addiw	a5,a5,-1
    800003a2:	00012717          	auipc	a4,0x12
    800003a6:	fef72723          	sw	a5,-18(a4) # 80012390 <cons+0xa0>
    800003aa:	10000513          	li	a0,256
    800003ae:	e93ff0ef          	jal	80000240 <consputc>
    800003b2:	b701                	j	800002b2 <consoleintr+0x40>
    800003b4:	ee048fe3          	beqz	s1,800002b2 <consoleintr+0x40>
    800003b8:	bf21                	j	800002d0 <consoleintr+0x5e>
    800003ba:	4529                	li	a0,10
    800003bc:	e85ff0ef          	jal	80000240 <consputc>
    800003c0:	00012797          	auipc	a5,0x12
    800003c4:	f3078793          	addi	a5,a5,-208 # 800122f0 <cons>
    800003c8:	0a07a703          	lw	a4,160(a5)
    800003cc:	0017069b          	addiw	a3,a4,1
    800003d0:	0006861b          	sext.w	a2,a3
    800003d4:	0ad7a023          	sw	a3,160(a5)
    800003d8:	07f77713          	andi	a4,a4,127
    800003dc:	97ba                	add	a5,a5,a4
    800003de:	4729                	li	a4,10
    800003e0:	00e78c23          	sb	a4,24(a5)
    800003e4:	00012797          	auipc	a5,0x12
    800003e8:	fac7a423          	sw	a2,-88(a5) # 8001238c <cons+0x9c>
    800003ec:	00012517          	auipc	a0,0x12
    800003f0:	f9c50513          	addi	a0,a0,-100 # 80012388 <cons+0x98>
    800003f4:	327010ef          	jal	80001f1a <wakeup>
    800003f8:	bd6d                	j	800002b2 <consoleintr+0x40>

00000000800003fa <consoleinit>:
    800003fa:	1141                	addi	sp,sp,-16
    800003fc:	e406                	sd	ra,8(sp)
    800003fe:	e022                	sd	s0,0(sp)
    80000400:	0800                	addi	s0,sp,16
    80000402:	00007597          	auipc	a1,0x7
    80000406:	bfe58593          	addi	a1,a1,-1026 # 80007000 <etext>
    8000040a:	00012517          	auipc	a0,0x12
    8000040e:	ee650513          	addi	a0,a0,-282 # 800122f0 <cons>
    80000412:	770000ef          	jal	80000b82 <initlock>
    80000416:	3f4000ef          	jal	8000080a <uartinit>
    8000041a:	00022797          	auipc	a5,0x22
    8000041e:	06e78793          	addi	a5,a5,110 # 80022488 <devsw>
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
    80000458:	32c60613          	addi	a2,a2,812 # 80007780 <digits>
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
    800004f2:	ec27a783          	lw	a5,-318(a5) # 800123b0 <pr+0x18>
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
    8000053e:	e5e50513          	addi	a0,a0,-418 # 80012398 <pr>
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
    800006fe:	086b8b93          	addi	s7,s7,134 # 80007780 <digits>
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
    80000798:	c0450513          	addi	a0,a0,-1020 # 80012398 <pr>
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
    800007b2:	c007a123          	sw	zero,-1022(a5) # 800123b0 <pr+0x18>
    800007b6:	00007517          	auipc	a0,0x7
    800007ba:	86250513          	addi	a0,a0,-1950 # 80007018 <etext+0x18>
    800007be:	d13ff0ef          	jal	800004d0 <printf>
    800007c2:	85a6                	mv	a1,s1
    800007c4:	00007517          	auipc	a0,0x7
    800007c8:	85c50513          	addi	a0,a0,-1956 # 80007020 <etext+0x20>
    800007cc:	d05ff0ef          	jal	800004d0 <printf>
    800007d0:	4785                	li	a5,1
    800007d2:	0000a717          	auipc	a4,0xa
    800007d6:	aef72123          	sw	a5,-1310(a4) # 8000a2b4 <panicked>
    800007da:	a001                	j	800007da <panic+0x38>

00000000800007dc <printfinit>:
    800007dc:	1101                	addi	sp,sp,-32
    800007de:	ec06                	sd	ra,24(sp)
    800007e0:	e822                	sd	s0,16(sp)
    800007e2:	e426                	sd	s1,8(sp)
    800007e4:	1000                	addi	s0,sp,32
    800007e6:	00012497          	auipc	s1,0x12
    800007ea:	bb248493          	addi	s1,s1,-1102 # 80012398 <pr>
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
    80000852:	b6a50513          	addi	a0,a0,-1174 # 800123b8 <uart_tx_lock>
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
    80000876:	a427a783          	lw	a5,-1470(a5) # 8000a2b4 <panicked>
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
    800008ac:	a107b783          	ld	a5,-1520(a5) # 8000a2b8 <uart_tx_r>
    800008b0:	0000a717          	auipc	a4,0xa
    800008b4:	a1073703          	ld	a4,-1520(a4) # 8000a2c0 <uart_tx_w>
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
    800008da:	ae2a8a93          	addi	s5,s5,-1310 # 800123b8 <uart_tx_lock>
    800008de:	0000a497          	auipc	s1,0xa
    800008e2:	9da48493          	addi	s1,s1,-1574 # 8000a2b8 <uart_tx_r>
    800008e6:	10000a37          	lui	s4,0x10000
    800008ea:	0000a997          	auipc	s3,0xa
    800008ee:	9d698993          	addi	s3,s3,-1578 # 8000a2c0 <uart_tx_w>
    800008f2:	00094703          	lbu	a4,0(s2)
    800008f6:	02077713          	andi	a4,a4,32
    800008fa:	c71d                	beqz	a4,80000928 <uartstart+0x80>
    800008fc:	01f7f713          	andi	a4,a5,31
    80000900:	9756                	add	a4,a4,s5
    80000902:	01874b03          	lbu	s6,24(a4)
    80000906:	0785                	addi	a5,a5,1
    80000908:	e09c                	sd	a5,0(s1)
    8000090a:	8526                	mv	a0,s1
    8000090c:	60e010ef          	jal	80001f1a <wakeup>
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
    8000095e:	a5e50513          	addi	a0,a0,-1442 # 800123b8 <uart_tx_lock>
    80000962:	2a0000ef          	jal	80000c02 <acquire>
    80000966:	0000a797          	auipc	a5,0xa
    8000096a:	94e7a783          	lw	a5,-1714(a5) # 8000a2b4 <panicked>
    8000096e:	efbd                	bnez	a5,800009ec <uartputc+0xa4>
    80000970:	0000a717          	auipc	a4,0xa
    80000974:	95073703          	ld	a4,-1712(a4) # 8000a2c0 <uart_tx_w>
    80000978:	0000a797          	auipc	a5,0xa
    8000097c:	9407b783          	ld	a5,-1728(a5) # 8000a2b8 <uart_tx_r>
    80000980:	02078793          	addi	a5,a5,32
    80000984:	00012997          	auipc	s3,0x12
    80000988:	a3498993          	addi	s3,s3,-1484 # 800123b8 <uart_tx_lock>
    8000098c:	0000a497          	auipc	s1,0xa
    80000990:	92c48493          	addi	s1,s1,-1748 # 8000a2b8 <uart_tx_r>
    80000994:	0000a917          	auipc	s2,0xa
    80000998:	92c90913          	addi	s2,s2,-1748 # 8000a2c0 <uart_tx_w>
    8000099c:	00e79d63          	bne	a5,a4,800009b6 <uartputc+0x6e>
    800009a0:	85ce                	mv	a1,s3
    800009a2:	8526                	mv	a0,s1
    800009a4:	52a010ef          	jal	80001ece <sleep>
    800009a8:	00093703          	ld	a4,0(s2)
    800009ac:	609c                	ld	a5,0(s1)
    800009ae:	02078793          	addi	a5,a5,32
    800009b2:	fee787e3          	beq	a5,a4,800009a0 <uartputc+0x58>
    800009b6:	00012497          	auipc	s1,0x12
    800009ba:	a0248493          	addi	s1,s1,-1534 # 800123b8 <uart_tx_lock>
    800009be:	01f77793          	andi	a5,a4,31
    800009c2:	97a6                	add	a5,a5,s1
    800009c4:	01478c23          	sb	s4,24(a5)
    800009c8:	0705                	addi	a4,a4,1
    800009ca:	0000a797          	auipc	a5,0xa
    800009ce:	8ee7bb23          	sd	a4,-1802(a5) # 8000a2c0 <uart_tx_w>
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
    80000a32:	98a48493          	addi	s1,s1,-1654 # 800123b8 <uart_tx_lock>
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
    80000a68:	bbc78793          	addi	a5,a5,-1092 # 80023620 <end>
    80000a6c:	02f56f63          	bltu	a0,a5,80000aaa <kfree+0x5a>
    80000a70:	47c5                	li	a5,17
    80000a72:	07ee                	slli	a5,a5,0x1b
    80000a74:	02f57b63          	bgeu	a0,a5,80000aaa <kfree+0x5a>
    80000a78:	6605                	lui	a2,0x1
    80000a7a:	4585                	li	a1,1
    80000a7c:	25a000ef          	jal	80000cd6 <memset>
    80000a80:	00012917          	auipc	s2,0x12
    80000a84:	97090913          	addi	s2,s2,-1680 # 800123f0 <kmem>
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
    80000b12:	8e250513          	addi	a0,a0,-1822 # 800123f0 <kmem>
    80000b16:	06c000ef          	jal	80000b82 <initlock>
    80000b1a:	45c5                	li	a1,17
    80000b1c:	05ee                	slli	a1,a1,0x1b
    80000b1e:	00023517          	auipc	a0,0x23
    80000b22:	b0250513          	addi	a0,a0,-1278 # 80023620 <end>
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
    80000b40:	8b448493          	addi	s1,s1,-1868 # 800123f0 <kmem>
    80000b44:	8526                	mv	a0,s1
    80000b46:	0bc000ef          	jal	80000c02 <acquire>
    80000b4a:	6c84                	ld	s1,24(s1)
    80000b4c:	c485                	beqz	s1,80000b74 <kalloc+0x42>
    80000b4e:	609c                	ld	a5,0(s1)
    80000b50:	00012517          	auipc	a0,0x12
    80000b54:	8a050513          	addi	a0,a0,-1888 # 800123f0 <kmem>
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
    80000b78:	87c50513          	addi	a0,a0,-1924 # 800123f0 <kmem>
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
    80000bac:	539000ef          	jal	800018e4 <mycpu>
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
    80000bda:	50b000ef          	jal	800018e4 <mycpu>
    80000bde:	5d3c                	lw	a5,120(a0)
    80000be0:	cb99                	beqz	a5,80000bf6 <push_off+0x34>
    80000be2:	503000ef          	jal	800018e4 <mycpu>
    80000be6:	5d3c                	lw	a5,120(a0)
    80000be8:	2785                	addiw	a5,a5,1
    80000bea:	dd3c                	sw	a5,120(a0)
    80000bec:	60e2                	ld	ra,24(sp)
    80000bee:	6442                	ld	s0,16(sp)
    80000bf0:	64a2                	ld	s1,8(sp)
    80000bf2:	6105                	addi	sp,sp,32
    80000bf4:	8082                	ret
    80000bf6:	4ef000ef          	jal	800018e4 <mycpu>
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
    80000c2a:	4bb000ef          	jal	800018e4 <mycpu>
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
    80000c4e:	497000ef          	jal	800018e4 <mycpu>
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
    80000d4a:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb9e1>
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
    80000e78:	25d000ef          	jal	800018d4 <cpuid>
    80000e7c:	00009717          	auipc	a4,0x9
    80000e80:	44c70713          	addi	a4,a4,1100 # 8000a2c8 <started>
    80000e84:	c51d                	beqz	a0,80000eb2 <main+0x42>
    80000e86:	431c                	lw	a5,0(a4)
    80000e88:	2781                	sext.w	a5,a5
    80000e8a:	dff5                	beqz	a5,80000e86 <main+0x16>
    80000e8c:	0330000f          	fence	rw,rw
    80000e90:	245000ef          	jal	800018d4 <cpuid>
    80000e94:	85aa                	mv	a1,a0
    80000e96:	00006517          	auipc	a0,0x6
    80000e9a:	20250513          	addi	a0,a0,514 # 80007098 <etext+0x98>
    80000e9e:	e32ff0ef          	jal	800004d0 <printf>
    80000ea2:	080000ef          	jal	80000f22 <kvminithart>
    80000ea6:	54a010ef          	jal	800023f0 <trapinithart>
    80000eaa:	42e040ef          	jal	800052d8 <plicinithart>
    80000eae:	687000ef          	jal	80001d34 <scheduler>
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
    80000ee2:	2dc000ef          	jal	800011be <kvminit>
    80000ee6:	03c000ef          	jal	80000f22 <kvminithart>
    80000eea:	135000ef          	jal	8000181e <procinit>
    80000eee:	4de010ef          	jal	800023cc <trapinit>
    80000ef2:	4fe010ef          	jal	800023f0 <trapinithart>
    80000ef6:	3c8040ef          	jal	800052be <plicinit>
    80000efa:	3de040ef          	jal	800052d8 <plicinithart>
    80000efe:	389010ef          	jal	80002a86 <binit>
    80000f02:	17a020ef          	jal	8000307c <iinit>
    80000f06:	727020ef          	jal	80003e2c <fileinit>
    80000f0a:	4be040ef          	jal	800053c8 <virtio_disk_init>
    80000f0e:	45b000ef          	jal	80001b68 <userinit>
    80000f12:	0330000f          	fence	rw,rw
    80000f16:	4785                	li	a5,1
    80000f18:	00009717          	auipc	a4,0x9
    80000f1c:	3af72823          	sw	a5,944(a4) # 8000a2c8 <started>
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
    80000f30:	3a47b783          	ld	a5,932(a5) # 8000a2d0 <kernel_pagetable>
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
    80000f9e:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb9d7>
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
    800011ce:	10a7b323          	sd	a0,262(a5) # 8000a2d0 <kernel_pagetable>
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
    8000179c:	00011497          	auipc	s1,0x11
    800017a0:	0a448493          	addi	s1,s1,164 # 80012840 <proc>
    800017a4:	8b26                	mv	s6,s1
    800017a6:	04fa5937          	lui	s2,0x4fa5
    800017aa:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    800017ae:	0932                	slli	s2,s2,0xc
    800017b0:	fa590913          	addi	s2,s2,-91
    800017b4:	0932                	slli	s2,s2,0xc
    800017b6:	fa590913          	addi	s2,s2,-91
    800017ba:	0932                	slli	s2,s2,0xc
    800017bc:	fa590913          	addi	s2,s2,-91
    800017c0:	040009b7          	lui	s3,0x4000
    800017c4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017c6:	09b2                	slli	s3,s3,0xc
    800017c8:	00017a97          	auipc	s5,0x17
    800017cc:	a78a8a93          	addi	s5,s5,-1416 # 80018240 <tickslock>
    800017d0:	b62ff0ef          	jal	80000b32 <kalloc>
    800017d4:	862a                	mv	a2,a0
    800017d6:	cd15                	beqz	a0,80001812 <proc_mapstacks+0x8c>
    800017d8:	416485b3          	sub	a1,s1,s6
    800017dc:	858d                	srai	a1,a1,0x3
    800017de:	032585b3          	mul	a1,a1,s2
    800017e2:	2585                	addiw	a1,a1,1
    800017e4:	00d5959b          	slliw	a1,a1,0xd
    800017e8:	4719                	li	a4,6
    800017ea:	6685                	lui	a3,0x1
    800017ec:	40b985b3          	sub	a1,s3,a1
    800017f0:	8552                	mv	a0,s4
    800017f2:	8e1ff0ef          	jal	800010d2 <kvmmap>
    800017f6:	16848493          	addi	s1,s1,360
    800017fa:	fd549be3          	bne	s1,s5,800017d0 <proc_mapstacks+0x4a>
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
    80001812:	00006517          	auipc	a0,0x6
    80001816:	9e650513          	addi	a0,a0,-1562 # 800071f8 <etext+0x1f8>
    8000181a:	f89fe0ef          	jal	800007a2 <panic>

000000008000181e <procinit>:
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
    80001832:	00006597          	auipc	a1,0x6
    80001836:	9ce58593          	addi	a1,a1,-1586 # 80007200 <etext+0x200>
    8000183a:	00011517          	auipc	a0,0x11
    8000183e:	bd650513          	addi	a0,a0,-1066 # 80012410 <pid_lock>
    80001842:	b40ff0ef          	jal	80000b82 <initlock>
    80001846:	00006597          	auipc	a1,0x6
    8000184a:	9c258593          	addi	a1,a1,-1598 # 80007208 <etext+0x208>
    8000184e:	00011517          	auipc	a0,0x11
    80001852:	bda50513          	addi	a0,a0,-1062 # 80012428 <wait_lock>
    80001856:	b2cff0ef          	jal	80000b82 <initlock>
    8000185a:	00011497          	auipc	s1,0x11
    8000185e:	fe648493          	addi	s1,s1,-26 # 80012840 <proc>
    80001862:	00006b17          	auipc	s6,0x6
    80001866:	9b6b0b13          	addi	s6,s6,-1610 # 80007218 <etext+0x218>
    8000186a:	8aa6                	mv	s5,s1
    8000186c:	04fa5937          	lui	s2,0x4fa5
    80001870:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001874:	0932                	slli	s2,s2,0xc
    80001876:	fa590913          	addi	s2,s2,-91
    8000187a:	0932                	slli	s2,s2,0xc
    8000187c:	fa590913          	addi	s2,s2,-91
    80001880:	0932                	slli	s2,s2,0xc
    80001882:	fa590913          	addi	s2,s2,-91
    80001886:	040009b7          	lui	s3,0x4000
    8000188a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000188c:	09b2                	slli	s3,s3,0xc
    8000188e:	00017a17          	auipc	s4,0x17
    80001892:	9b2a0a13          	addi	s4,s4,-1614 # 80018240 <tickslock>
    80001896:	85da                	mv	a1,s6
    80001898:	8526                	mv	a0,s1
    8000189a:	ae8ff0ef          	jal	80000b82 <initlock>
    8000189e:	0004ac23          	sw	zero,24(s1)
    800018a2:	415487b3          	sub	a5,s1,s5
    800018a6:	878d                	srai	a5,a5,0x3
    800018a8:	032787b3          	mul	a5,a5,s2
    800018ac:	2785                	addiw	a5,a5,1
    800018ae:	00d7979b          	slliw	a5,a5,0xd
    800018b2:	40f987b3          	sub	a5,s3,a5
    800018b6:	e0bc                	sd	a5,64(s1)
    800018b8:	16848493          	addi	s1,s1,360
    800018bc:	fd449de3          	bne	s1,s4,80001896 <procinit+0x78>
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
    800018d4:	1141                	addi	sp,sp,-16
    800018d6:	e422                	sd	s0,8(sp)
    800018d8:	0800                	addi	s0,sp,16
    800018da:	8512                	mv	a0,tp
    800018dc:	2501                	sext.w	a0,a0
    800018de:	6422                	ld	s0,8(sp)
    800018e0:	0141                	addi	sp,sp,16
    800018e2:	8082                	ret

00000000800018e4 <mycpu>:
    800018e4:	1141                	addi	sp,sp,-16
    800018e6:	e422                	sd	s0,8(sp)
    800018e8:	0800                	addi	s0,sp,16
    800018ea:	8792                	mv	a5,tp
    800018ec:	2781                	sext.w	a5,a5
    800018ee:	079e                	slli	a5,a5,0x7
    800018f0:	00011517          	auipc	a0,0x11
    800018f4:	b5050513          	addi	a0,a0,-1200 # 80012440 <cpus>
    800018f8:	953e                	add	a0,a0,a5
    800018fa:	6422                	ld	s0,8(sp)
    800018fc:	0141                	addi	sp,sp,16
    800018fe:	8082                	ret

0000000080001900 <myproc>:
    80001900:	1101                	addi	sp,sp,-32
    80001902:	ec06                	sd	ra,24(sp)
    80001904:	e822                	sd	s0,16(sp)
    80001906:	e426                	sd	s1,8(sp)
    80001908:	1000                	addi	s0,sp,32
    8000190a:	ab8ff0ef          	jal	80000bc2 <push_off>
    8000190e:	8792                	mv	a5,tp
    80001910:	2781                	sext.w	a5,a5
    80001912:	079e                	slli	a5,a5,0x7
    80001914:	00011717          	auipc	a4,0x11
    80001918:	afc70713          	addi	a4,a4,-1284 # 80012410 <pid_lock>
    8000191c:	97ba                	add	a5,a5,a4
    8000191e:	7b84                	ld	s1,48(a5)
    80001920:	b26ff0ef          	jal	80000c46 <pop_off>
    80001924:	8526                	mv	a0,s1
    80001926:	60e2                	ld	ra,24(sp)
    80001928:	6442                	ld	s0,16(sp)
    8000192a:	64a2                	ld	s1,8(sp)
    8000192c:	6105                	addi	sp,sp,32
    8000192e:	8082                	ret

0000000080001930 <forkret>:
    80001930:	1141                	addi	sp,sp,-16
    80001932:	e406                	sd	ra,8(sp)
    80001934:	e022                	sd	s0,0(sp)
    80001936:	0800                	addi	s0,sp,16
    80001938:	fc9ff0ef          	jal	80001900 <myproc>
    8000193c:	b5eff0ef          	jal	80000c9a <release>
    80001940:	00009797          	auipc	a5,0x9
    80001944:	9007a783          	lw	a5,-1792(a5) # 8000a240 <first.1>
    80001948:	e799                	bnez	a5,80001956 <forkret+0x26>
    8000194a:	2bf000ef          	jal	80002408 <usertrapret>
    8000194e:	60a2                	ld	ra,8(sp)
    80001950:	6402                	ld	s0,0(sp)
    80001952:	0141                	addi	sp,sp,16
    80001954:	8082                	ret
    80001956:	4505                	li	a0,1
    80001958:	6b8010ef          	jal	80003010 <fsinit>
    8000195c:	00009797          	auipc	a5,0x9
    80001960:	8e07a223          	sw	zero,-1820(a5) # 8000a240 <first.1>
    80001964:	0330000f          	fence	rw,rw
    80001968:	b7cd                	j	8000194a <forkret+0x1a>

000000008000196a <allocpid>:
    8000196a:	1101                	addi	sp,sp,-32
    8000196c:	ec06                	sd	ra,24(sp)
    8000196e:	e822                	sd	s0,16(sp)
    80001970:	e426                	sd	s1,8(sp)
    80001972:	e04a                	sd	s2,0(sp)
    80001974:	1000                	addi	s0,sp,32
    80001976:	00011917          	auipc	s2,0x11
    8000197a:	a9a90913          	addi	s2,s2,-1382 # 80012410 <pid_lock>
    8000197e:	854a                	mv	a0,s2
    80001980:	a82ff0ef          	jal	80000c02 <acquire>
    80001984:	00009797          	auipc	a5,0x9
    80001988:	8c078793          	addi	a5,a5,-1856 # 8000a244 <nextpid>
    8000198c:	4384                	lw	s1,0(a5)
    8000198e:	0014871b          	addiw	a4,s1,1
    80001992:	c398                	sw	a4,0(a5)
    80001994:	854a                	mv	a0,s2
    80001996:	b04ff0ef          	jal	80000c9a <release>
    8000199a:	8526                	mv	a0,s1
    8000199c:	60e2                	ld	ra,24(sp)
    8000199e:	6442                	ld	s0,16(sp)
    800019a0:	64a2                	ld	s1,8(sp)
    800019a2:	6902                	ld	s2,0(sp)
    800019a4:	6105                	addi	sp,sp,32
    800019a6:	8082                	ret

00000000800019a8 <proc_pagetable>:
    800019a8:	1101                	addi	sp,sp,-32
    800019aa:	ec06                	sd	ra,24(sp)
    800019ac:	e822                	sd	s0,16(sp)
    800019ae:	e426                	sd	s1,8(sp)
    800019b0:	e04a                	sd	s2,0(sp)
    800019b2:	1000                	addi	s0,sp,32
    800019b4:	892a                	mv	s2,a0
    800019b6:	8e1ff0ef          	jal	80001296 <uvmcreate>
    800019ba:	84aa                	mv	s1,a0
    800019bc:	cd05                	beqz	a0,800019f4 <proc_pagetable+0x4c>
    800019be:	4729                	li	a4,10
    800019c0:	00004697          	auipc	a3,0x4
    800019c4:	64068693          	addi	a3,a3,1600 # 80006000 <_trampoline>
    800019c8:	6605                	lui	a2,0x1
    800019ca:	040005b7          	lui	a1,0x4000
    800019ce:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019d0:	05b2                	slli	a1,a1,0xc
    800019d2:	e50ff0ef          	jal	80001022 <mappages>
    800019d6:	02054663          	bltz	a0,80001a02 <proc_pagetable+0x5a>
    800019da:	4719                	li	a4,6
    800019dc:	05893683          	ld	a3,88(s2)
    800019e0:	6605                	lui	a2,0x1
    800019e2:	020005b7          	lui	a1,0x2000
    800019e6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800019e8:	05b6                	slli	a1,a1,0xd
    800019ea:	8526                	mv	a0,s1
    800019ec:	e36ff0ef          	jal	80001022 <mappages>
    800019f0:	00054f63          	bltz	a0,80001a0e <proc_pagetable+0x66>
    800019f4:	8526                	mv	a0,s1
    800019f6:	60e2                	ld	ra,24(sp)
    800019f8:	6442                	ld	s0,16(sp)
    800019fa:	64a2                	ld	s1,8(sp)
    800019fc:	6902                	ld	s2,0(sp)
    800019fe:	6105                	addi	sp,sp,32
    80001a00:	8082                	ret
    80001a02:	4581                	li	a1,0
    80001a04:	8526                	mv	a0,s1
    80001a06:	a5fff0ef          	jal	80001464 <uvmfree>
    80001a0a:	4481                	li	s1,0
    80001a0c:	b7e5                	j	800019f4 <proc_pagetable+0x4c>
    80001a0e:	4681                	li	a3,0
    80001a10:	4605                	li	a2,1
    80001a12:	040005b7          	lui	a1,0x4000
    80001a16:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a18:	05b2                	slli	a1,a1,0xc
    80001a1a:	8526                	mv	a0,s1
    80001a1c:	fbeff0ef          	jal	800011da <uvmunmap>
    80001a20:	4581                	li	a1,0
    80001a22:	8526                	mv	a0,s1
    80001a24:	a41ff0ef          	jal	80001464 <uvmfree>
    80001a28:	4481                	li	s1,0
    80001a2a:	b7e9                	j	800019f4 <proc_pagetable+0x4c>

0000000080001a2c <proc_freepagetable>:
    80001a2c:	1101                	addi	sp,sp,-32
    80001a2e:	ec06                	sd	ra,24(sp)
    80001a30:	e822                	sd	s0,16(sp)
    80001a32:	e426                	sd	s1,8(sp)
    80001a34:	e04a                	sd	s2,0(sp)
    80001a36:	1000                	addi	s0,sp,32
    80001a38:	84aa                	mv	s1,a0
    80001a3a:	892e                	mv	s2,a1
    80001a3c:	4681                	li	a3,0
    80001a3e:	4605                	li	a2,1
    80001a40:	040005b7          	lui	a1,0x4000
    80001a44:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a46:	05b2                	slli	a1,a1,0xc
    80001a48:	f92ff0ef          	jal	800011da <uvmunmap>
    80001a4c:	4681                	li	a3,0
    80001a4e:	4605                	li	a2,1
    80001a50:	020005b7          	lui	a1,0x2000
    80001a54:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a56:	05b6                	slli	a1,a1,0xd
    80001a58:	8526                	mv	a0,s1
    80001a5a:	f80ff0ef          	jal	800011da <uvmunmap>
    80001a5e:	85ca                	mv	a1,s2
    80001a60:	8526                	mv	a0,s1
    80001a62:	a03ff0ef          	jal	80001464 <uvmfree>
    80001a66:	60e2                	ld	ra,24(sp)
    80001a68:	6442                	ld	s0,16(sp)
    80001a6a:	64a2                	ld	s1,8(sp)
    80001a6c:	6902                	ld	s2,0(sp)
    80001a6e:	6105                	addi	sp,sp,32
    80001a70:	8082                	ret

0000000080001a72 <freeproc>:
    80001a72:	1101                	addi	sp,sp,-32
    80001a74:	ec06                	sd	ra,24(sp)
    80001a76:	e822                	sd	s0,16(sp)
    80001a78:	e426                	sd	s1,8(sp)
    80001a7a:	1000                	addi	s0,sp,32
    80001a7c:	84aa                	mv	s1,a0
    80001a7e:	6d28                	ld	a0,88(a0)
    80001a80:	c119                	beqz	a0,80001a86 <freeproc+0x14>
    80001a82:	fcffe0ef          	jal	80000a50 <kfree>
    80001a86:	0404bc23          	sd	zero,88(s1)
    80001a8a:	68a8                	ld	a0,80(s1)
    80001a8c:	c501                	beqz	a0,80001a94 <freeproc+0x22>
    80001a8e:	64ac                	ld	a1,72(s1)
    80001a90:	f9dff0ef          	jal	80001a2c <proc_freepagetable>
    80001a94:	0404b823          	sd	zero,80(s1)
    80001a98:	0404b423          	sd	zero,72(s1)
    80001a9c:	0204a823          	sw	zero,48(s1)
    80001aa0:	0204bc23          	sd	zero,56(s1)
    80001aa4:	14048c23          	sb	zero,344(s1)
    80001aa8:	0204b023          	sd	zero,32(s1)
    80001aac:	0204a423          	sw	zero,40(s1)
    80001ab0:	0204a623          	sw	zero,44(s1)
    80001ab4:	0004ac23          	sw	zero,24(s1)
    80001ab8:	60e2                	ld	ra,24(sp)
    80001aba:	6442                	ld	s0,16(sp)
    80001abc:	64a2                	ld	s1,8(sp)
    80001abe:	6105                	addi	sp,sp,32
    80001ac0:	8082                	ret

0000000080001ac2 <allocproc>:
    80001ac2:	1101                	addi	sp,sp,-32
    80001ac4:	ec06                	sd	ra,24(sp)
    80001ac6:	e822                	sd	s0,16(sp)
    80001ac8:	e426                	sd	s1,8(sp)
    80001aca:	e04a                	sd	s2,0(sp)
    80001acc:	1000                	addi	s0,sp,32
    80001ace:	00011497          	auipc	s1,0x11
    80001ad2:	d7248493          	addi	s1,s1,-654 # 80012840 <proc>
    80001ad6:	00016917          	auipc	s2,0x16
    80001ada:	76a90913          	addi	s2,s2,1898 # 80018240 <tickslock>
    80001ade:	8526                	mv	a0,s1
    80001ae0:	922ff0ef          	jal	80000c02 <acquire>
    80001ae4:	4c9c                	lw	a5,24(s1)
    80001ae6:	cb91                	beqz	a5,80001afa <allocproc+0x38>
    80001ae8:	8526                	mv	a0,s1
    80001aea:	9b0ff0ef          	jal	80000c9a <release>
    80001aee:	16848493          	addi	s1,s1,360
    80001af2:	ff2496e3          	bne	s1,s2,80001ade <allocproc+0x1c>
    80001af6:	4481                	li	s1,0
    80001af8:	a089                	j	80001b3a <allocproc+0x78>
    80001afa:	e71ff0ef          	jal	8000196a <allocpid>
    80001afe:	d888                	sw	a0,48(s1)
    80001b00:	4785                	li	a5,1
    80001b02:	cc9c                	sw	a5,24(s1)
    80001b04:	82eff0ef          	jal	80000b32 <kalloc>
    80001b08:	892a                	mv	s2,a0
    80001b0a:	eca8                	sd	a0,88(s1)
    80001b0c:	cd15                	beqz	a0,80001b48 <allocproc+0x86>
    80001b0e:	8526                	mv	a0,s1
    80001b10:	e99ff0ef          	jal	800019a8 <proc_pagetable>
    80001b14:	892a                	mv	s2,a0
    80001b16:	e8a8                	sd	a0,80(s1)
    80001b18:	c121                	beqz	a0,80001b58 <allocproc+0x96>
    80001b1a:	07000613          	li	a2,112
    80001b1e:	4581                	li	a1,0
    80001b20:	06048513          	addi	a0,s1,96
    80001b24:	9b2ff0ef          	jal	80000cd6 <memset>
    80001b28:	00000797          	auipc	a5,0x0
    80001b2c:	e0878793          	addi	a5,a5,-504 # 80001930 <forkret>
    80001b30:	f0bc                	sd	a5,96(s1)
    80001b32:	60bc                	ld	a5,64(s1)
    80001b34:	6705                	lui	a4,0x1
    80001b36:	97ba                	add	a5,a5,a4
    80001b38:	f4bc                	sd	a5,104(s1)
    80001b3a:	8526                	mv	a0,s1
    80001b3c:	60e2                	ld	ra,24(sp)
    80001b3e:	6442                	ld	s0,16(sp)
    80001b40:	64a2                	ld	s1,8(sp)
    80001b42:	6902                	ld	s2,0(sp)
    80001b44:	6105                	addi	sp,sp,32
    80001b46:	8082                	ret
    80001b48:	8526                	mv	a0,s1
    80001b4a:	f29ff0ef          	jal	80001a72 <freeproc>
    80001b4e:	8526                	mv	a0,s1
    80001b50:	94aff0ef          	jal	80000c9a <release>
    80001b54:	84ca                	mv	s1,s2
    80001b56:	b7d5                	j	80001b3a <allocproc+0x78>
    80001b58:	8526                	mv	a0,s1
    80001b5a:	f19ff0ef          	jal	80001a72 <freeproc>
    80001b5e:	8526                	mv	a0,s1
    80001b60:	93aff0ef          	jal	80000c9a <release>
    80001b64:	84ca                	mv	s1,s2
    80001b66:	bfd1                	j	80001b3a <allocproc+0x78>

0000000080001b68 <userinit>:
    80001b68:	1101                	addi	sp,sp,-32
    80001b6a:	ec06                	sd	ra,24(sp)
    80001b6c:	e822                	sd	s0,16(sp)
    80001b6e:	e426                	sd	s1,8(sp)
    80001b70:	1000                	addi	s0,sp,32
    80001b72:	f51ff0ef          	jal	80001ac2 <allocproc>
    80001b76:	84aa                	mv	s1,a0
    80001b78:	00008797          	auipc	a5,0x8
    80001b7c:	76a7b023          	sd	a0,1888(a5) # 8000a2d8 <initproc>
    80001b80:	03400613          	li	a2,52
    80001b84:	00008597          	auipc	a1,0x8
    80001b88:	6cc58593          	addi	a1,a1,1740 # 8000a250 <initcode>
    80001b8c:	6928                	ld	a0,80(a0)
    80001b8e:	f2eff0ef          	jal	800012bc <uvmfirst>
    80001b92:	6785                	lui	a5,0x1
    80001b94:	e4bc                	sd	a5,72(s1)
    80001b96:	6cb8                	ld	a4,88(s1)
    80001b98:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    80001b9c:	6cb8                	ld	a4,88(s1)
    80001b9e:	fb1c                	sd	a5,48(a4)
    80001ba0:	4641                	li	a2,16
    80001ba2:	00005597          	auipc	a1,0x5
    80001ba6:	67e58593          	addi	a1,a1,1662 # 80007220 <etext+0x220>
    80001baa:	15848513          	addi	a0,s1,344
    80001bae:	a66ff0ef          	jal	80000e14 <safestrcpy>
    80001bb2:	00005517          	auipc	a0,0x5
    80001bb6:	67e50513          	addi	a0,a0,1662 # 80007230 <etext+0x230>
    80001bba:	565010ef          	jal	8000391e <namei>
    80001bbe:	14a4b823          	sd	a0,336(s1)
    80001bc2:	478d                	li	a5,3
    80001bc4:	cc9c                	sw	a5,24(s1)
    80001bc6:	8526                	mv	a0,s1
    80001bc8:	8d2ff0ef          	jal	80000c9a <release>
    80001bcc:	60e2                	ld	ra,24(sp)
    80001bce:	6442                	ld	s0,16(sp)
    80001bd0:	64a2                	ld	s1,8(sp)
    80001bd2:	6105                	addi	sp,sp,32
    80001bd4:	8082                	ret

0000000080001bd6 <growproc>:
    80001bd6:	1101                	addi	sp,sp,-32
    80001bd8:	ec06                	sd	ra,24(sp)
    80001bda:	e822                	sd	s0,16(sp)
    80001bdc:	e426                	sd	s1,8(sp)
    80001bde:	e04a                	sd	s2,0(sp)
    80001be0:	1000                	addi	s0,sp,32
    80001be2:	892a                	mv	s2,a0
    80001be4:	d1dff0ef          	jal	80001900 <myproc>
    80001be8:	84aa                	mv	s1,a0
    80001bea:	652c                	ld	a1,72(a0)
    80001bec:	01204c63          	bgtz	s2,80001c04 <growproc+0x2e>
    80001bf0:	02094463          	bltz	s2,80001c18 <growproc+0x42>
    80001bf4:	e4ac                	sd	a1,72(s1)
    80001bf6:	4501                	li	a0,0
    80001bf8:	60e2                	ld	ra,24(sp)
    80001bfa:	6442                	ld	s0,16(sp)
    80001bfc:	64a2                	ld	s1,8(sp)
    80001bfe:	6902                	ld	s2,0(sp)
    80001c00:	6105                	addi	sp,sp,32
    80001c02:	8082                	ret
    80001c04:	4691                	li	a3,4
    80001c06:	00b90633          	add	a2,s2,a1
    80001c0a:	6928                	ld	a0,80(a0)
    80001c0c:	f52ff0ef          	jal	8000135e <uvmalloc>
    80001c10:	85aa                	mv	a1,a0
    80001c12:	f16d                	bnez	a0,80001bf4 <growproc+0x1e>
    80001c14:	557d                	li	a0,-1
    80001c16:	b7cd                	j	80001bf8 <growproc+0x22>
    80001c18:	00b90633          	add	a2,s2,a1
    80001c1c:	6928                	ld	a0,80(a0)
    80001c1e:	efcff0ef          	jal	8000131a <uvmdealloc>
    80001c22:	85aa                	mv	a1,a0
    80001c24:	bfc1                	j	80001bf4 <growproc+0x1e>

0000000080001c26 <fork>:
    80001c26:	7139                	addi	sp,sp,-64
    80001c28:	fc06                	sd	ra,56(sp)
    80001c2a:	f822                	sd	s0,48(sp)
    80001c2c:	f04a                	sd	s2,32(sp)
    80001c2e:	e456                	sd	s5,8(sp)
    80001c30:	0080                	addi	s0,sp,64
    80001c32:	ccfff0ef          	jal	80001900 <myproc>
    80001c36:	8aaa                	mv	s5,a0
    80001c38:	e8bff0ef          	jal	80001ac2 <allocproc>
    80001c3c:	0e050a63          	beqz	a0,80001d30 <fork+0x10a>
    80001c40:	e852                	sd	s4,16(sp)
    80001c42:	8a2a                	mv	s4,a0
    80001c44:	048ab603          	ld	a2,72(s5)
    80001c48:	692c                	ld	a1,80(a0)
    80001c4a:	050ab503          	ld	a0,80(s5)
    80001c4e:	849ff0ef          	jal	80001496 <uvmcopy>
    80001c52:	04054a63          	bltz	a0,80001ca6 <fork+0x80>
    80001c56:	f426                	sd	s1,40(sp)
    80001c58:	ec4e                	sd	s3,24(sp)
    80001c5a:	048ab783          	ld	a5,72(s5)
    80001c5e:	04fa3423          	sd	a5,72(s4)
    80001c62:	058ab683          	ld	a3,88(s5)
    80001c66:	87b6                	mv	a5,a3
    80001c68:	058a3703          	ld	a4,88(s4)
    80001c6c:	12068693          	addi	a3,a3,288
    80001c70:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001c74:	6788                	ld	a0,8(a5)
    80001c76:	6b8c                	ld	a1,16(a5)
    80001c78:	6f90                	ld	a2,24(a5)
    80001c7a:	01073023          	sd	a6,0(a4)
    80001c7e:	e708                	sd	a0,8(a4)
    80001c80:	eb0c                	sd	a1,16(a4)
    80001c82:	ef10                	sd	a2,24(a4)
    80001c84:	02078793          	addi	a5,a5,32
    80001c88:	02070713          	addi	a4,a4,32
    80001c8c:	fed792e3          	bne	a5,a3,80001c70 <fork+0x4a>
    80001c90:	058a3783          	ld	a5,88(s4)
    80001c94:	0607b823          	sd	zero,112(a5)
    80001c98:	0d0a8493          	addi	s1,s5,208
    80001c9c:	0d0a0913          	addi	s2,s4,208
    80001ca0:	150a8993          	addi	s3,s5,336
    80001ca4:	a831                	j	80001cc0 <fork+0x9a>
    80001ca6:	8552                	mv	a0,s4
    80001ca8:	dcbff0ef          	jal	80001a72 <freeproc>
    80001cac:	8552                	mv	a0,s4
    80001cae:	fedfe0ef          	jal	80000c9a <release>
    80001cb2:	597d                	li	s2,-1
    80001cb4:	6a42                	ld	s4,16(sp)
    80001cb6:	a0b5                	j	80001d22 <fork+0xfc>
    80001cb8:	04a1                	addi	s1,s1,8
    80001cba:	0921                	addi	s2,s2,8
    80001cbc:	01348963          	beq	s1,s3,80001cce <fork+0xa8>
    80001cc0:	6088                	ld	a0,0(s1)
    80001cc2:	d97d                	beqz	a0,80001cb8 <fork+0x92>
    80001cc4:	1ea020ef          	jal	80003eae <filedup>
    80001cc8:	00a93023          	sd	a0,0(s2)
    80001ccc:	b7f5                	j	80001cb8 <fork+0x92>
    80001cce:	150ab503          	ld	a0,336(s5)
    80001cd2:	53c010ef          	jal	8000320e <idup>
    80001cd6:	14aa3823          	sd	a0,336(s4)
    80001cda:	4641                	li	a2,16
    80001cdc:	158a8593          	addi	a1,s5,344
    80001ce0:	158a0513          	addi	a0,s4,344
    80001ce4:	930ff0ef          	jal	80000e14 <safestrcpy>
    80001ce8:	030a2903          	lw	s2,48(s4)
    80001cec:	8552                	mv	a0,s4
    80001cee:	fadfe0ef          	jal	80000c9a <release>
    80001cf2:	00010497          	auipc	s1,0x10
    80001cf6:	73648493          	addi	s1,s1,1846 # 80012428 <wait_lock>
    80001cfa:	8526                	mv	a0,s1
    80001cfc:	f07fe0ef          	jal	80000c02 <acquire>
    80001d00:	035a3c23          	sd	s5,56(s4)
    80001d04:	8526                	mv	a0,s1
    80001d06:	f95fe0ef          	jal	80000c9a <release>
    80001d0a:	8552                	mv	a0,s4
    80001d0c:	ef7fe0ef          	jal	80000c02 <acquire>
    80001d10:	478d                	li	a5,3
    80001d12:	00fa2c23          	sw	a5,24(s4)
    80001d16:	8552                	mv	a0,s4
    80001d18:	f83fe0ef          	jal	80000c9a <release>
    80001d1c:	74a2                	ld	s1,40(sp)
    80001d1e:	69e2                	ld	s3,24(sp)
    80001d20:	6a42                	ld	s4,16(sp)
    80001d22:	854a                	mv	a0,s2
    80001d24:	70e2                	ld	ra,56(sp)
    80001d26:	7442                	ld	s0,48(sp)
    80001d28:	7902                	ld	s2,32(sp)
    80001d2a:	6aa2                	ld	s5,8(sp)
    80001d2c:	6121                	addi	sp,sp,64
    80001d2e:	8082                	ret
    80001d30:	597d                	li	s2,-1
    80001d32:	bfc5                	j	80001d22 <fork+0xfc>

0000000080001d34 <scheduler>:
    80001d34:	715d                	addi	sp,sp,-80
    80001d36:	e486                	sd	ra,72(sp)
    80001d38:	e0a2                	sd	s0,64(sp)
    80001d3a:	fc26                	sd	s1,56(sp)
    80001d3c:	f84a                	sd	s2,48(sp)
    80001d3e:	f44e                	sd	s3,40(sp)
    80001d40:	f052                	sd	s4,32(sp)
    80001d42:	ec56                	sd	s5,24(sp)
    80001d44:	e85a                	sd	s6,16(sp)
    80001d46:	e45e                	sd	s7,8(sp)
    80001d48:	e062                	sd	s8,0(sp)
    80001d4a:	0880                	addi	s0,sp,80
    80001d4c:	8792                	mv	a5,tp
    80001d4e:	2781                	sext.w	a5,a5
    80001d50:	00779b13          	slli	s6,a5,0x7
    80001d54:	00010717          	auipc	a4,0x10
    80001d58:	6bc70713          	addi	a4,a4,1724 # 80012410 <pid_lock>
    80001d5c:	975a                	add	a4,a4,s6
    80001d5e:	02073823          	sd	zero,48(a4)
    80001d62:	00010717          	auipc	a4,0x10
    80001d66:	6e670713          	addi	a4,a4,1766 # 80012448 <cpus+0x8>
    80001d6a:	9b3a                	add	s6,s6,a4
    80001d6c:	4c11                	li	s8,4
    80001d6e:	079e                	slli	a5,a5,0x7
    80001d70:	00010a17          	auipc	s4,0x10
    80001d74:	6a0a0a13          	addi	s4,s4,1696 # 80012410 <pid_lock>
    80001d78:	9a3e                	add	s4,s4,a5
    80001d7a:	4b85                	li	s7,1
    80001d7c:	00016997          	auipc	s3,0x16
    80001d80:	4c498993          	addi	s3,s3,1220 # 80018240 <tickslock>
    80001d84:	a0a9                	j	80001dce <scheduler+0x9a>
    80001d86:	8526                	mv	a0,s1
    80001d88:	f13fe0ef          	jal	80000c9a <release>
    80001d8c:	16848493          	addi	s1,s1,360
    80001d90:	03348563          	beq	s1,s3,80001dba <scheduler+0x86>
    80001d94:	8526                	mv	a0,s1
    80001d96:	e6dfe0ef          	jal	80000c02 <acquire>
    80001d9a:	4c9c                	lw	a5,24(s1)
    80001d9c:	ff2795e3          	bne	a5,s2,80001d86 <scheduler+0x52>
    80001da0:	0184ac23          	sw	s8,24(s1)
    80001da4:	029a3823          	sd	s1,48(s4)
    80001da8:	06048593          	addi	a1,s1,96
    80001dac:	855a                	mv	a0,s6
    80001dae:	5b4000ef          	jal	80002362 <swtch>
    80001db2:	020a3823          	sd	zero,48(s4)
    80001db6:	8ade                	mv	s5,s7
    80001db8:	b7f9                	j	80001d86 <scheduler+0x52>
    80001dba:	000a9a63          	bnez	s5,80001dce <scheduler+0x9a>
    80001dbe:	100027f3          	csrr	a5,sstatus
    80001dc2:	0027e793          	ori	a5,a5,2
    80001dc6:	10079073          	csrw	sstatus,a5
    80001dca:	10500073          	wfi
    80001dce:	100027f3          	csrr	a5,sstatus
    80001dd2:	0027e793          	ori	a5,a5,2
    80001dd6:	10079073          	csrw	sstatus,a5
    80001dda:	4a81                	li	s5,0
    80001ddc:	00011497          	auipc	s1,0x11
    80001de0:	a6448493          	addi	s1,s1,-1436 # 80012840 <proc>
    80001de4:	490d                	li	s2,3
    80001de6:	b77d                	j	80001d94 <scheduler+0x60>

0000000080001de8 <sched>:
    80001de8:	7179                	addi	sp,sp,-48
    80001dea:	f406                	sd	ra,40(sp)
    80001dec:	f022                	sd	s0,32(sp)
    80001dee:	ec26                	sd	s1,24(sp)
    80001df0:	e84a                	sd	s2,16(sp)
    80001df2:	e44e                	sd	s3,8(sp)
    80001df4:	1800                	addi	s0,sp,48
    80001df6:	b0bff0ef          	jal	80001900 <myproc>
    80001dfa:	84aa                	mv	s1,a0
    80001dfc:	d9dfe0ef          	jal	80000b98 <holding>
    80001e00:	c92d                	beqz	a0,80001e72 <sched+0x8a>
    80001e02:	8792                	mv	a5,tp
    80001e04:	2781                	sext.w	a5,a5
    80001e06:	079e                	slli	a5,a5,0x7
    80001e08:	00010717          	auipc	a4,0x10
    80001e0c:	60870713          	addi	a4,a4,1544 # 80012410 <pid_lock>
    80001e10:	97ba                	add	a5,a5,a4
    80001e12:	0a87a703          	lw	a4,168(a5)
    80001e16:	4785                	li	a5,1
    80001e18:	06f71363          	bne	a4,a5,80001e7e <sched+0x96>
    80001e1c:	4c98                	lw	a4,24(s1)
    80001e1e:	4791                	li	a5,4
    80001e20:	06f70563          	beq	a4,a5,80001e8a <sched+0xa2>
    80001e24:	100027f3          	csrr	a5,sstatus
    80001e28:	8b89                	andi	a5,a5,2
    80001e2a:	e7b5                	bnez	a5,80001e96 <sched+0xae>
    80001e2c:	8792                	mv	a5,tp
    80001e2e:	00010917          	auipc	s2,0x10
    80001e32:	5e290913          	addi	s2,s2,1506 # 80012410 <pid_lock>
    80001e36:	2781                	sext.w	a5,a5
    80001e38:	079e                	slli	a5,a5,0x7
    80001e3a:	97ca                	add	a5,a5,s2
    80001e3c:	0ac7a983          	lw	s3,172(a5)
    80001e40:	8792                	mv	a5,tp
    80001e42:	2781                	sext.w	a5,a5
    80001e44:	079e                	slli	a5,a5,0x7
    80001e46:	00010597          	auipc	a1,0x10
    80001e4a:	60258593          	addi	a1,a1,1538 # 80012448 <cpus+0x8>
    80001e4e:	95be                	add	a1,a1,a5
    80001e50:	06048513          	addi	a0,s1,96
    80001e54:	50e000ef          	jal	80002362 <swtch>
    80001e58:	8792                	mv	a5,tp
    80001e5a:	2781                	sext.w	a5,a5
    80001e5c:	079e                	slli	a5,a5,0x7
    80001e5e:	993e                	add	s2,s2,a5
    80001e60:	0b392623          	sw	s3,172(s2)
    80001e64:	70a2                	ld	ra,40(sp)
    80001e66:	7402                	ld	s0,32(sp)
    80001e68:	64e2                	ld	s1,24(sp)
    80001e6a:	6942                	ld	s2,16(sp)
    80001e6c:	69a2                	ld	s3,8(sp)
    80001e6e:	6145                	addi	sp,sp,48
    80001e70:	8082                	ret
    80001e72:	00005517          	auipc	a0,0x5
    80001e76:	3c650513          	addi	a0,a0,966 # 80007238 <etext+0x238>
    80001e7a:	929fe0ef          	jal	800007a2 <panic>
    80001e7e:	00005517          	auipc	a0,0x5
    80001e82:	3ca50513          	addi	a0,a0,970 # 80007248 <etext+0x248>
    80001e86:	91dfe0ef          	jal	800007a2 <panic>
    80001e8a:	00005517          	auipc	a0,0x5
    80001e8e:	3ce50513          	addi	a0,a0,974 # 80007258 <etext+0x258>
    80001e92:	911fe0ef          	jal	800007a2 <panic>
    80001e96:	00005517          	auipc	a0,0x5
    80001e9a:	3d250513          	addi	a0,a0,978 # 80007268 <etext+0x268>
    80001e9e:	905fe0ef          	jal	800007a2 <panic>

0000000080001ea2 <yield>:
    80001ea2:	1101                	addi	sp,sp,-32
    80001ea4:	ec06                	sd	ra,24(sp)
    80001ea6:	e822                	sd	s0,16(sp)
    80001ea8:	e426                	sd	s1,8(sp)
    80001eaa:	1000                	addi	s0,sp,32
    80001eac:	a55ff0ef          	jal	80001900 <myproc>
    80001eb0:	84aa                	mv	s1,a0
    80001eb2:	d51fe0ef          	jal	80000c02 <acquire>
    80001eb6:	478d                	li	a5,3
    80001eb8:	cc9c                	sw	a5,24(s1)
    80001eba:	f2fff0ef          	jal	80001de8 <sched>
    80001ebe:	8526                	mv	a0,s1
    80001ec0:	ddbfe0ef          	jal	80000c9a <release>
    80001ec4:	60e2                	ld	ra,24(sp)
    80001ec6:	6442                	ld	s0,16(sp)
    80001ec8:	64a2                	ld	s1,8(sp)
    80001eca:	6105                	addi	sp,sp,32
    80001ecc:	8082                	ret

0000000080001ece <sleep>:
    80001ece:	7179                	addi	sp,sp,-48
    80001ed0:	f406                	sd	ra,40(sp)
    80001ed2:	f022                	sd	s0,32(sp)
    80001ed4:	ec26                	sd	s1,24(sp)
    80001ed6:	e84a                	sd	s2,16(sp)
    80001ed8:	e44e                	sd	s3,8(sp)
    80001eda:	1800                	addi	s0,sp,48
    80001edc:	89aa                	mv	s3,a0
    80001ede:	892e                	mv	s2,a1
    80001ee0:	a21ff0ef          	jal	80001900 <myproc>
    80001ee4:	84aa                	mv	s1,a0
    80001ee6:	d1dfe0ef          	jal	80000c02 <acquire>
    80001eea:	854a                	mv	a0,s2
    80001eec:	daffe0ef          	jal	80000c9a <release>
    80001ef0:	0334b023          	sd	s3,32(s1)
    80001ef4:	4789                	li	a5,2
    80001ef6:	cc9c                	sw	a5,24(s1)
    80001ef8:	ef1ff0ef          	jal	80001de8 <sched>
    80001efc:	0204b023          	sd	zero,32(s1)
    80001f00:	8526                	mv	a0,s1
    80001f02:	d99fe0ef          	jal	80000c9a <release>
    80001f06:	854a                	mv	a0,s2
    80001f08:	cfbfe0ef          	jal	80000c02 <acquire>
    80001f0c:	70a2                	ld	ra,40(sp)
    80001f0e:	7402                	ld	s0,32(sp)
    80001f10:	64e2                	ld	s1,24(sp)
    80001f12:	6942                	ld	s2,16(sp)
    80001f14:	69a2                	ld	s3,8(sp)
    80001f16:	6145                	addi	sp,sp,48
    80001f18:	8082                	ret

0000000080001f1a <wakeup>:
    80001f1a:	7139                	addi	sp,sp,-64
    80001f1c:	fc06                	sd	ra,56(sp)
    80001f1e:	f822                	sd	s0,48(sp)
    80001f20:	f426                	sd	s1,40(sp)
    80001f22:	f04a                	sd	s2,32(sp)
    80001f24:	ec4e                	sd	s3,24(sp)
    80001f26:	e852                	sd	s4,16(sp)
    80001f28:	e456                	sd	s5,8(sp)
    80001f2a:	0080                	addi	s0,sp,64
    80001f2c:	8a2a                	mv	s4,a0
    80001f2e:	00011497          	auipc	s1,0x11
    80001f32:	91248493          	addi	s1,s1,-1774 # 80012840 <proc>
    80001f36:	4989                	li	s3,2
    80001f38:	4a8d                	li	s5,3
    80001f3a:	00016917          	auipc	s2,0x16
    80001f3e:	30690913          	addi	s2,s2,774 # 80018240 <tickslock>
    80001f42:	a801                	j	80001f52 <wakeup+0x38>
    80001f44:	8526                	mv	a0,s1
    80001f46:	d55fe0ef          	jal	80000c9a <release>
    80001f4a:	16848493          	addi	s1,s1,360
    80001f4e:	03248263          	beq	s1,s2,80001f72 <wakeup+0x58>
    80001f52:	9afff0ef          	jal	80001900 <myproc>
    80001f56:	fea48ae3          	beq	s1,a0,80001f4a <wakeup+0x30>
    80001f5a:	8526                	mv	a0,s1
    80001f5c:	ca7fe0ef          	jal	80000c02 <acquire>
    80001f60:	4c9c                	lw	a5,24(s1)
    80001f62:	ff3791e3          	bne	a5,s3,80001f44 <wakeup+0x2a>
    80001f66:	709c                	ld	a5,32(s1)
    80001f68:	fd479ee3          	bne	a5,s4,80001f44 <wakeup+0x2a>
    80001f6c:	0154ac23          	sw	s5,24(s1)
    80001f70:	bfd1                	j	80001f44 <wakeup+0x2a>
    80001f72:	70e2                	ld	ra,56(sp)
    80001f74:	7442                	ld	s0,48(sp)
    80001f76:	74a2                	ld	s1,40(sp)
    80001f78:	7902                	ld	s2,32(sp)
    80001f7a:	69e2                	ld	s3,24(sp)
    80001f7c:	6a42                	ld	s4,16(sp)
    80001f7e:	6aa2                	ld	s5,8(sp)
    80001f80:	6121                	addi	sp,sp,64
    80001f82:	8082                	ret

0000000080001f84 <reparent>:
    80001f84:	7179                	addi	sp,sp,-48
    80001f86:	f406                	sd	ra,40(sp)
    80001f88:	f022                	sd	s0,32(sp)
    80001f8a:	ec26                	sd	s1,24(sp)
    80001f8c:	e84a                	sd	s2,16(sp)
    80001f8e:	e44e                	sd	s3,8(sp)
    80001f90:	e052                	sd	s4,0(sp)
    80001f92:	1800                	addi	s0,sp,48
    80001f94:	892a                	mv	s2,a0
    80001f96:	00011497          	auipc	s1,0x11
    80001f9a:	8aa48493          	addi	s1,s1,-1878 # 80012840 <proc>
    80001f9e:	00008a17          	auipc	s4,0x8
    80001fa2:	33aa0a13          	addi	s4,s4,826 # 8000a2d8 <initproc>
    80001fa6:	00016997          	auipc	s3,0x16
    80001faa:	29a98993          	addi	s3,s3,666 # 80018240 <tickslock>
    80001fae:	a029                	j	80001fb8 <reparent+0x34>
    80001fb0:	16848493          	addi	s1,s1,360
    80001fb4:	01348b63          	beq	s1,s3,80001fca <reparent+0x46>
    80001fb8:	7c9c                	ld	a5,56(s1)
    80001fba:	ff279be3          	bne	a5,s2,80001fb0 <reparent+0x2c>
    80001fbe:	000a3503          	ld	a0,0(s4)
    80001fc2:	fc88                	sd	a0,56(s1)
    80001fc4:	f57ff0ef          	jal	80001f1a <wakeup>
    80001fc8:	b7e5                	j	80001fb0 <reparent+0x2c>
    80001fca:	70a2                	ld	ra,40(sp)
    80001fcc:	7402                	ld	s0,32(sp)
    80001fce:	64e2                	ld	s1,24(sp)
    80001fd0:	6942                	ld	s2,16(sp)
    80001fd2:	69a2                	ld	s3,8(sp)
    80001fd4:	6a02                	ld	s4,0(sp)
    80001fd6:	6145                	addi	sp,sp,48
    80001fd8:	8082                	ret

0000000080001fda <exit>:
    80001fda:	7179                	addi	sp,sp,-48
    80001fdc:	f406                	sd	ra,40(sp)
    80001fde:	f022                	sd	s0,32(sp)
    80001fe0:	ec26                	sd	s1,24(sp)
    80001fe2:	e84a                	sd	s2,16(sp)
    80001fe4:	e44e                	sd	s3,8(sp)
    80001fe6:	e052                	sd	s4,0(sp)
    80001fe8:	1800                	addi	s0,sp,48
    80001fea:	8a2a                	mv	s4,a0
    80001fec:	915ff0ef          	jal	80001900 <myproc>
    80001ff0:	89aa                	mv	s3,a0
    80001ff2:	00008797          	auipc	a5,0x8
    80001ff6:	2e67b783          	ld	a5,742(a5) # 8000a2d8 <initproc>
    80001ffa:	0d050493          	addi	s1,a0,208
    80001ffe:	15050913          	addi	s2,a0,336
    80002002:	00a79f63          	bne	a5,a0,80002020 <exit+0x46>
    80002006:	00005517          	auipc	a0,0x5
    8000200a:	27a50513          	addi	a0,a0,634 # 80007280 <etext+0x280>
    8000200e:	f94fe0ef          	jal	800007a2 <panic>
    80002012:	6e3010ef          	jal	80003ef4 <fileclose>
    80002016:	0004b023          	sd	zero,0(s1)
    8000201a:	04a1                	addi	s1,s1,8
    8000201c:	01248563          	beq	s1,s2,80002026 <exit+0x4c>
    80002020:	6088                	ld	a0,0(s1)
    80002022:	f965                	bnez	a0,80002012 <exit+0x38>
    80002024:	bfdd                	j	8000201a <exit+0x40>
    80002026:	2b5010ef          	jal	80003ada <begin_op>
    8000202a:	1509b503          	ld	a0,336(s3)
    8000202e:	398010ef          	jal	800033c6 <iput>
    80002032:	313010ef          	jal	80003b44 <end_op>
    80002036:	1409b823          	sd	zero,336(s3)
    8000203a:	00010497          	auipc	s1,0x10
    8000203e:	3ee48493          	addi	s1,s1,1006 # 80012428 <wait_lock>
    80002042:	8526                	mv	a0,s1
    80002044:	bbffe0ef          	jal	80000c02 <acquire>
    80002048:	854e                	mv	a0,s3
    8000204a:	f3bff0ef          	jal	80001f84 <reparent>
    8000204e:	0389b503          	ld	a0,56(s3)
    80002052:	ec9ff0ef          	jal	80001f1a <wakeup>
    80002056:	854e                	mv	a0,s3
    80002058:	babfe0ef          	jal	80000c02 <acquire>
    8000205c:	0349a623          	sw	s4,44(s3)
    80002060:	4795                	li	a5,5
    80002062:	00f9ac23          	sw	a5,24(s3)
    80002066:	8526                	mv	a0,s1
    80002068:	c33fe0ef          	jal	80000c9a <release>
    8000206c:	d7dff0ef          	jal	80001de8 <sched>
    80002070:	00005517          	auipc	a0,0x5
    80002074:	22050513          	addi	a0,a0,544 # 80007290 <etext+0x290>
    80002078:	f2afe0ef          	jal	800007a2 <panic>

000000008000207c <kill>:
    8000207c:	7179                	addi	sp,sp,-48
    8000207e:	f406                	sd	ra,40(sp)
    80002080:	f022                	sd	s0,32(sp)
    80002082:	ec26                	sd	s1,24(sp)
    80002084:	e84a                	sd	s2,16(sp)
    80002086:	e44e                	sd	s3,8(sp)
    80002088:	1800                	addi	s0,sp,48
    8000208a:	892a                	mv	s2,a0
    8000208c:	00010497          	auipc	s1,0x10
    80002090:	7b448493          	addi	s1,s1,1972 # 80012840 <proc>
    80002094:	00016997          	auipc	s3,0x16
    80002098:	1ac98993          	addi	s3,s3,428 # 80018240 <tickslock>
    8000209c:	8526                	mv	a0,s1
    8000209e:	b65fe0ef          	jal	80000c02 <acquire>
    800020a2:	589c                	lw	a5,48(s1)
    800020a4:	01278b63          	beq	a5,s2,800020ba <kill+0x3e>
    800020a8:	8526                	mv	a0,s1
    800020aa:	bf1fe0ef          	jal	80000c9a <release>
    800020ae:	16848493          	addi	s1,s1,360
    800020b2:	ff3495e3          	bne	s1,s3,8000209c <kill+0x20>
    800020b6:	557d                	li	a0,-1
    800020b8:	a819                	j	800020ce <kill+0x52>
    800020ba:	4785                	li	a5,1
    800020bc:	d49c                	sw	a5,40(s1)
    800020be:	4c98                	lw	a4,24(s1)
    800020c0:	4789                	li	a5,2
    800020c2:	00f70d63          	beq	a4,a5,800020dc <kill+0x60>
    800020c6:	8526                	mv	a0,s1
    800020c8:	bd3fe0ef          	jal	80000c9a <release>
    800020cc:	4501                	li	a0,0
    800020ce:	70a2                	ld	ra,40(sp)
    800020d0:	7402                	ld	s0,32(sp)
    800020d2:	64e2                	ld	s1,24(sp)
    800020d4:	6942                	ld	s2,16(sp)
    800020d6:	69a2                	ld	s3,8(sp)
    800020d8:	6145                	addi	sp,sp,48
    800020da:	8082                	ret
    800020dc:	478d                	li	a5,3
    800020de:	cc9c                	sw	a5,24(s1)
    800020e0:	b7dd                	j	800020c6 <kill+0x4a>

00000000800020e2 <setkilled>:
    800020e2:	1101                	addi	sp,sp,-32
    800020e4:	ec06                	sd	ra,24(sp)
    800020e6:	e822                	sd	s0,16(sp)
    800020e8:	e426                	sd	s1,8(sp)
    800020ea:	1000                	addi	s0,sp,32
    800020ec:	84aa                	mv	s1,a0
    800020ee:	b15fe0ef          	jal	80000c02 <acquire>
    800020f2:	4785                	li	a5,1
    800020f4:	d49c                	sw	a5,40(s1)
    800020f6:	8526                	mv	a0,s1
    800020f8:	ba3fe0ef          	jal	80000c9a <release>
    800020fc:	60e2                	ld	ra,24(sp)
    800020fe:	6442                	ld	s0,16(sp)
    80002100:	64a2                	ld	s1,8(sp)
    80002102:	6105                	addi	sp,sp,32
    80002104:	8082                	ret

0000000080002106 <killed>:
    80002106:	1101                	addi	sp,sp,-32
    80002108:	ec06                	sd	ra,24(sp)
    8000210a:	e822                	sd	s0,16(sp)
    8000210c:	e426                	sd	s1,8(sp)
    8000210e:	e04a                	sd	s2,0(sp)
    80002110:	1000                	addi	s0,sp,32
    80002112:	84aa                	mv	s1,a0
    80002114:	aeffe0ef          	jal	80000c02 <acquire>
    80002118:	0284a903          	lw	s2,40(s1)
    8000211c:	8526                	mv	a0,s1
    8000211e:	b7dfe0ef          	jal	80000c9a <release>
    80002122:	854a                	mv	a0,s2
    80002124:	60e2                	ld	ra,24(sp)
    80002126:	6442                	ld	s0,16(sp)
    80002128:	64a2                	ld	s1,8(sp)
    8000212a:	6902                	ld	s2,0(sp)
    8000212c:	6105                	addi	sp,sp,32
    8000212e:	8082                	ret

0000000080002130 <wait>:
    80002130:	715d                	addi	sp,sp,-80
    80002132:	e486                	sd	ra,72(sp)
    80002134:	e0a2                	sd	s0,64(sp)
    80002136:	fc26                	sd	s1,56(sp)
    80002138:	f84a                	sd	s2,48(sp)
    8000213a:	f44e                	sd	s3,40(sp)
    8000213c:	f052                	sd	s4,32(sp)
    8000213e:	ec56                	sd	s5,24(sp)
    80002140:	e85a                	sd	s6,16(sp)
    80002142:	e45e                	sd	s7,8(sp)
    80002144:	e062                	sd	s8,0(sp)
    80002146:	0880                	addi	s0,sp,80
    80002148:	8b2a                	mv	s6,a0
    8000214a:	fb6ff0ef          	jal	80001900 <myproc>
    8000214e:	892a                	mv	s2,a0
    80002150:	00010517          	auipc	a0,0x10
    80002154:	2d850513          	addi	a0,a0,728 # 80012428 <wait_lock>
    80002158:	aabfe0ef          	jal	80000c02 <acquire>
    8000215c:	4b81                	li	s7,0
    8000215e:	4a15                	li	s4,5
    80002160:	4a85                	li	s5,1
    80002162:	00016997          	auipc	s3,0x16
    80002166:	0de98993          	addi	s3,s3,222 # 80018240 <tickslock>
    8000216a:	00010c17          	auipc	s8,0x10
    8000216e:	2bec0c13          	addi	s8,s8,702 # 80012428 <wait_lock>
    80002172:	a871                	j	8000220e <wait+0xde>
    80002174:	0304a983          	lw	s3,48(s1)
    80002178:	000b0c63          	beqz	s6,80002190 <wait+0x60>
    8000217c:	4691                	li	a3,4
    8000217e:	02c48613          	addi	a2,s1,44
    80002182:	85da                	mv	a1,s6
    80002184:	05093503          	ld	a0,80(s2)
    80002188:	beaff0ef          	jal	80001572 <copyout>
    8000218c:	02054b63          	bltz	a0,800021c2 <wait+0x92>
    80002190:	8526                	mv	a0,s1
    80002192:	8e1ff0ef          	jal	80001a72 <freeproc>
    80002196:	8526                	mv	a0,s1
    80002198:	b03fe0ef          	jal	80000c9a <release>
    8000219c:	00010517          	auipc	a0,0x10
    800021a0:	28c50513          	addi	a0,a0,652 # 80012428 <wait_lock>
    800021a4:	af7fe0ef          	jal	80000c9a <release>
    800021a8:	854e                	mv	a0,s3
    800021aa:	60a6                	ld	ra,72(sp)
    800021ac:	6406                	ld	s0,64(sp)
    800021ae:	74e2                	ld	s1,56(sp)
    800021b0:	7942                	ld	s2,48(sp)
    800021b2:	79a2                	ld	s3,40(sp)
    800021b4:	7a02                	ld	s4,32(sp)
    800021b6:	6ae2                	ld	s5,24(sp)
    800021b8:	6b42                	ld	s6,16(sp)
    800021ba:	6ba2                	ld	s7,8(sp)
    800021bc:	6c02                	ld	s8,0(sp)
    800021be:	6161                	addi	sp,sp,80
    800021c0:	8082                	ret
    800021c2:	8526                	mv	a0,s1
    800021c4:	ad7fe0ef          	jal	80000c9a <release>
    800021c8:	00010517          	auipc	a0,0x10
    800021cc:	26050513          	addi	a0,a0,608 # 80012428 <wait_lock>
    800021d0:	acbfe0ef          	jal	80000c9a <release>
    800021d4:	59fd                	li	s3,-1
    800021d6:	bfc9                	j	800021a8 <wait+0x78>
    800021d8:	16848493          	addi	s1,s1,360
    800021dc:	03348063          	beq	s1,s3,800021fc <wait+0xcc>
    800021e0:	7c9c                	ld	a5,56(s1)
    800021e2:	ff279be3          	bne	a5,s2,800021d8 <wait+0xa8>
    800021e6:	8526                	mv	a0,s1
    800021e8:	a1bfe0ef          	jal	80000c02 <acquire>
    800021ec:	4c9c                	lw	a5,24(s1)
    800021ee:	f94783e3          	beq	a5,s4,80002174 <wait+0x44>
    800021f2:	8526                	mv	a0,s1
    800021f4:	aa7fe0ef          	jal	80000c9a <release>
    800021f8:	8756                	mv	a4,s5
    800021fa:	bff9                	j	800021d8 <wait+0xa8>
    800021fc:	cf19                	beqz	a4,8000221a <wait+0xea>
    800021fe:	854a                	mv	a0,s2
    80002200:	f07ff0ef          	jal	80002106 <killed>
    80002204:	e919                	bnez	a0,8000221a <wait+0xea>
    80002206:	85e2                	mv	a1,s8
    80002208:	854a                	mv	a0,s2
    8000220a:	cc5ff0ef          	jal	80001ece <sleep>
    8000220e:	875e                	mv	a4,s7
    80002210:	00010497          	auipc	s1,0x10
    80002214:	63048493          	addi	s1,s1,1584 # 80012840 <proc>
    80002218:	b7e1                	j	800021e0 <wait+0xb0>
    8000221a:	00010517          	auipc	a0,0x10
    8000221e:	20e50513          	addi	a0,a0,526 # 80012428 <wait_lock>
    80002222:	a79fe0ef          	jal	80000c9a <release>
    80002226:	59fd                	li	s3,-1
    80002228:	b741                	j	800021a8 <wait+0x78>

000000008000222a <either_copyout>:
    8000222a:	7179                	addi	sp,sp,-48
    8000222c:	f406                	sd	ra,40(sp)
    8000222e:	f022                	sd	s0,32(sp)
    80002230:	ec26                	sd	s1,24(sp)
    80002232:	e84a                	sd	s2,16(sp)
    80002234:	e44e                	sd	s3,8(sp)
    80002236:	e052                	sd	s4,0(sp)
    80002238:	1800                	addi	s0,sp,48
    8000223a:	84aa                	mv	s1,a0
    8000223c:	892e                	mv	s2,a1
    8000223e:	89b2                	mv	s3,a2
    80002240:	8a36                	mv	s4,a3
    80002242:	ebeff0ef          	jal	80001900 <myproc>
    80002246:	cc99                	beqz	s1,80002264 <either_copyout+0x3a>
    80002248:	86d2                	mv	a3,s4
    8000224a:	864e                	mv	a2,s3
    8000224c:	85ca                	mv	a1,s2
    8000224e:	6928                	ld	a0,80(a0)
    80002250:	b22ff0ef          	jal	80001572 <copyout>
    80002254:	70a2                	ld	ra,40(sp)
    80002256:	7402                	ld	s0,32(sp)
    80002258:	64e2                	ld	s1,24(sp)
    8000225a:	6942                	ld	s2,16(sp)
    8000225c:	69a2                	ld	s3,8(sp)
    8000225e:	6a02                	ld	s4,0(sp)
    80002260:	6145                	addi	sp,sp,48
    80002262:	8082                	ret
    80002264:	000a061b          	sext.w	a2,s4
    80002268:	85ce                	mv	a1,s3
    8000226a:	854a                	mv	a0,s2
    8000226c:	ac7fe0ef          	jal	80000d32 <memmove>
    80002270:	8526                	mv	a0,s1
    80002272:	b7cd                	j	80002254 <either_copyout+0x2a>

0000000080002274 <either_copyin>:
    80002274:	7179                	addi	sp,sp,-48
    80002276:	f406                	sd	ra,40(sp)
    80002278:	f022                	sd	s0,32(sp)
    8000227a:	ec26                	sd	s1,24(sp)
    8000227c:	e84a                	sd	s2,16(sp)
    8000227e:	e44e                	sd	s3,8(sp)
    80002280:	e052                	sd	s4,0(sp)
    80002282:	1800                	addi	s0,sp,48
    80002284:	892a                	mv	s2,a0
    80002286:	84ae                	mv	s1,a1
    80002288:	89b2                	mv	s3,a2
    8000228a:	8a36                	mv	s4,a3
    8000228c:	e74ff0ef          	jal	80001900 <myproc>
    80002290:	cc99                	beqz	s1,800022ae <either_copyin+0x3a>
    80002292:	86d2                	mv	a3,s4
    80002294:	864e                	mv	a2,s3
    80002296:	85ca                	mv	a1,s2
    80002298:	6928                	ld	a0,80(a0)
    8000229a:	baeff0ef          	jal	80001648 <copyin>
    8000229e:	70a2                	ld	ra,40(sp)
    800022a0:	7402                	ld	s0,32(sp)
    800022a2:	64e2                	ld	s1,24(sp)
    800022a4:	6942                	ld	s2,16(sp)
    800022a6:	69a2                	ld	s3,8(sp)
    800022a8:	6a02                	ld	s4,0(sp)
    800022aa:	6145                	addi	sp,sp,48
    800022ac:	8082                	ret
    800022ae:	000a061b          	sext.w	a2,s4
    800022b2:	85ce                	mv	a1,s3
    800022b4:	854a                	mv	a0,s2
    800022b6:	a7dfe0ef          	jal	80000d32 <memmove>
    800022ba:	8526                	mv	a0,s1
    800022bc:	b7cd                	j	8000229e <either_copyin+0x2a>

00000000800022be <procdump>:
    800022be:	715d                	addi	sp,sp,-80
    800022c0:	e486                	sd	ra,72(sp)
    800022c2:	e0a2                	sd	s0,64(sp)
    800022c4:	fc26                	sd	s1,56(sp)
    800022c6:	f84a                	sd	s2,48(sp)
    800022c8:	f44e                	sd	s3,40(sp)
    800022ca:	f052                	sd	s4,32(sp)
    800022cc:	ec56                	sd	s5,24(sp)
    800022ce:	e85a                	sd	s6,16(sp)
    800022d0:	e45e                	sd	s7,8(sp)
    800022d2:	0880                	addi	s0,sp,80
    800022d4:	00005517          	auipc	a0,0x5
    800022d8:	da450513          	addi	a0,a0,-604 # 80007078 <etext+0x78>
    800022dc:	9f4fe0ef          	jal	800004d0 <printf>
    800022e0:	00010497          	auipc	s1,0x10
    800022e4:	6b848493          	addi	s1,s1,1720 # 80012998 <proc+0x158>
    800022e8:	00016917          	auipc	s2,0x16
    800022ec:	0b090913          	addi	s2,s2,176 # 80018398 <bcache+0x140>
    800022f0:	4b15                	li	s6,5
    800022f2:	00005997          	auipc	s3,0x5
    800022f6:	fae98993          	addi	s3,s3,-82 # 800072a0 <etext+0x2a0>
    800022fa:	00005a97          	auipc	s5,0x5
    800022fe:	faea8a93          	addi	s5,s5,-82 # 800072a8 <etext+0x2a8>
    80002302:	00005a17          	auipc	s4,0x5
    80002306:	d76a0a13          	addi	s4,s4,-650 # 80007078 <etext+0x78>
    8000230a:	00005b97          	auipc	s7,0x5
    8000230e:	48eb8b93          	addi	s7,s7,1166 # 80007798 <states.0>
    80002312:	a829                	j	8000232c <procdump+0x6e>
    80002314:	ed86a583          	lw	a1,-296(a3)
    80002318:	8556                	mv	a0,s5
    8000231a:	9b6fe0ef          	jal	800004d0 <printf>
    8000231e:	8552                	mv	a0,s4
    80002320:	9b0fe0ef          	jal	800004d0 <printf>
    80002324:	16848493          	addi	s1,s1,360
    80002328:	03248263          	beq	s1,s2,8000234c <procdump+0x8e>
    8000232c:	86a6                	mv	a3,s1
    8000232e:	ec04a783          	lw	a5,-320(s1)
    80002332:	dbed                	beqz	a5,80002324 <procdump+0x66>
    80002334:	864e                	mv	a2,s3
    80002336:	fcfb6fe3          	bltu	s6,a5,80002314 <procdump+0x56>
    8000233a:	02079713          	slli	a4,a5,0x20
    8000233e:	01d75793          	srli	a5,a4,0x1d
    80002342:	97de                	add	a5,a5,s7
    80002344:	6390                	ld	a2,0(a5)
    80002346:	f679                	bnez	a2,80002314 <procdump+0x56>
    80002348:	864e                	mv	a2,s3
    8000234a:	b7e9                	j	80002314 <procdump+0x56>
    8000234c:	60a6                	ld	ra,72(sp)
    8000234e:	6406                	ld	s0,64(sp)
    80002350:	74e2                	ld	s1,56(sp)
    80002352:	7942                	ld	s2,48(sp)
    80002354:	79a2                	ld	s3,40(sp)
    80002356:	7a02                	ld	s4,32(sp)
    80002358:	6ae2                	ld	s5,24(sp)
    8000235a:	6b42                	ld	s6,16(sp)
    8000235c:	6ba2                	ld	s7,8(sp)
    8000235e:	6161                	addi	sp,sp,80
    80002360:	8082                	ret

0000000080002362 <swtch>:
    80002362:	00153023          	sd	ra,0(a0)
    80002366:	00253423          	sd	sp,8(a0)
    8000236a:	e900                	sd	s0,16(a0)
    8000236c:	ed04                	sd	s1,24(a0)
    8000236e:	03253023          	sd	s2,32(a0)
    80002372:	03353423          	sd	s3,40(a0)
    80002376:	03453823          	sd	s4,48(a0)
    8000237a:	03553c23          	sd	s5,56(a0)
    8000237e:	05653023          	sd	s6,64(a0)
    80002382:	05753423          	sd	s7,72(a0)
    80002386:	05853823          	sd	s8,80(a0)
    8000238a:	05953c23          	sd	s9,88(a0)
    8000238e:	07a53023          	sd	s10,96(a0)
    80002392:	07b53423          	sd	s11,104(a0)
    80002396:	0005b083          	ld	ra,0(a1)
    8000239a:	0085b103          	ld	sp,8(a1)
    8000239e:	6980                	ld	s0,16(a1)
    800023a0:	6d84                	ld	s1,24(a1)
    800023a2:	0205b903          	ld	s2,32(a1)
    800023a6:	0285b983          	ld	s3,40(a1)
    800023aa:	0305ba03          	ld	s4,48(a1)
    800023ae:	0385ba83          	ld	s5,56(a1)
    800023b2:	0405bb03          	ld	s6,64(a1)
    800023b6:	0485bb83          	ld	s7,72(a1)
    800023ba:	0505bc03          	ld	s8,80(a1)
    800023be:	0585bc83          	ld	s9,88(a1)
    800023c2:	0605bd03          	ld	s10,96(a1)
    800023c6:	0685bd83          	ld	s11,104(a1)
    800023ca:	8082                	ret

00000000800023cc <trapinit>:
    800023cc:	1141                	addi	sp,sp,-16
    800023ce:	e406                	sd	ra,8(sp)
    800023d0:	e022                	sd	s0,0(sp)
    800023d2:	0800                	addi	s0,sp,16
    800023d4:	00005597          	auipc	a1,0x5
    800023d8:	f1458593          	addi	a1,a1,-236 # 800072e8 <etext+0x2e8>
    800023dc:	00016517          	auipc	a0,0x16
    800023e0:	e6450513          	addi	a0,a0,-412 # 80018240 <tickslock>
    800023e4:	f9efe0ef          	jal	80000b82 <initlock>
    800023e8:	60a2                	ld	ra,8(sp)
    800023ea:	6402                	ld	s0,0(sp)
    800023ec:	0141                	addi	sp,sp,16
    800023ee:	8082                	ret

00000000800023f0 <trapinithart>:
    800023f0:	1141                	addi	sp,sp,-16
    800023f2:	e422                	sd	s0,8(sp)
    800023f4:	0800                	addi	s0,sp,16
    800023f6:	00003797          	auipc	a5,0x3
    800023fa:	e6a78793          	addi	a5,a5,-406 # 80005260 <kernelvec>
    800023fe:	10579073          	csrw	stvec,a5
    80002402:	6422                	ld	s0,8(sp)
    80002404:	0141                	addi	sp,sp,16
    80002406:	8082                	ret

0000000080002408 <usertrapret>:
    80002408:	1141                	addi	sp,sp,-16
    8000240a:	e406                	sd	ra,8(sp)
    8000240c:	e022                	sd	s0,0(sp)
    8000240e:	0800                	addi	s0,sp,16
    80002410:	cf0ff0ef          	jal	80001900 <myproc>
    80002414:	100027f3          	csrr	a5,sstatus
    80002418:	9bf5                	andi	a5,a5,-3
    8000241a:	10079073          	csrw	sstatus,a5
    8000241e:	00004697          	auipc	a3,0x4
    80002422:	be268693          	addi	a3,a3,-1054 # 80006000 <_trampoline>
    80002426:	00004717          	auipc	a4,0x4
    8000242a:	bda70713          	addi	a4,a4,-1062 # 80006000 <_trampoline>
    8000242e:	8f15                	sub	a4,a4,a3
    80002430:	040007b7          	lui	a5,0x4000
    80002434:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002436:	07b2                	slli	a5,a5,0xc
    80002438:	973e                	add	a4,a4,a5
    8000243a:	10571073          	csrw	stvec,a4
    8000243e:	6d38                	ld	a4,88(a0)
    80002440:	18002673          	csrr	a2,satp
    80002444:	e310                	sd	a2,0(a4)
    80002446:	6d30                	ld	a2,88(a0)
    80002448:	6138                	ld	a4,64(a0)
    8000244a:	6585                	lui	a1,0x1
    8000244c:	972e                	add	a4,a4,a1
    8000244e:	e618                	sd	a4,8(a2)
    80002450:	6d38                	ld	a4,88(a0)
    80002452:	00000617          	auipc	a2,0x0
    80002456:	11060613          	addi	a2,a2,272 # 80002562 <usertrap>
    8000245a:	eb10                	sd	a2,16(a4)
    8000245c:	6d38                	ld	a4,88(a0)
    8000245e:	8612                	mv	a2,tp
    80002460:	f310                	sd	a2,32(a4)
    80002462:	10002773          	csrr	a4,sstatus
    80002466:	eff77713          	andi	a4,a4,-257
    8000246a:	02076713          	ori	a4,a4,32
    8000246e:	10071073          	csrw	sstatus,a4
    80002472:	6d38                	ld	a4,88(a0)
    80002474:	6f18                	ld	a4,24(a4)
    80002476:	14171073          	csrw	sepc,a4
    8000247a:	6928                	ld	a0,80(a0)
    8000247c:	8131                	srli	a0,a0,0xc
    8000247e:	00004717          	auipc	a4,0x4
    80002482:	c1e70713          	addi	a4,a4,-994 # 8000609c <userret>
    80002486:	8f15                	sub	a4,a4,a3
    80002488:	97ba                	add	a5,a5,a4
    8000248a:	577d                	li	a4,-1
    8000248c:	177e                	slli	a4,a4,0x3f
    8000248e:	8d59                	or	a0,a0,a4
    80002490:	9782                	jalr	a5
    80002492:	60a2                	ld	ra,8(sp)
    80002494:	6402                	ld	s0,0(sp)
    80002496:	0141                	addi	sp,sp,16
    80002498:	8082                	ret

000000008000249a <clockintr>:
    8000249a:	1101                	addi	sp,sp,-32
    8000249c:	ec06                	sd	ra,24(sp)
    8000249e:	e822                	sd	s0,16(sp)
    800024a0:	1000                	addi	s0,sp,32
    800024a2:	c32ff0ef          	jal	800018d4 <cpuid>
    800024a6:	cd11                	beqz	a0,800024c2 <clockintr+0x28>
    800024a8:	c01027f3          	rdtime	a5
    800024ac:	000f4737          	lui	a4,0xf4
    800024b0:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800024b4:	97ba                	add	a5,a5,a4
    800024b6:	14d79073          	csrw	stimecmp,a5
    800024ba:	60e2                	ld	ra,24(sp)
    800024bc:	6442                	ld	s0,16(sp)
    800024be:	6105                	addi	sp,sp,32
    800024c0:	8082                	ret
    800024c2:	e426                	sd	s1,8(sp)
    800024c4:	00016497          	auipc	s1,0x16
    800024c8:	d7c48493          	addi	s1,s1,-644 # 80018240 <tickslock>
    800024cc:	8526                	mv	a0,s1
    800024ce:	f34fe0ef          	jal	80000c02 <acquire>
    800024d2:	00008517          	auipc	a0,0x8
    800024d6:	e0e50513          	addi	a0,a0,-498 # 8000a2e0 <ticks>
    800024da:	411c                	lw	a5,0(a0)
    800024dc:	2785                	addiw	a5,a5,1
    800024de:	c11c                	sw	a5,0(a0)
    800024e0:	a3bff0ef          	jal	80001f1a <wakeup>
    800024e4:	8526                	mv	a0,s1
    800024e6:	fb4fe0ef          	jal	80000c9a <release>
    800024ea:	64a2                	ld	s1,8(sp)
    800024ec:	bf75                	j	800024a8 <clockintr+0xe>

00000000800024ee <devintr>:
    800024ee:	1101                	addi	sp,sp,-32
    800024f0:	ec06                	sd	ra,24(sp)
    800024f2:	e822                	sd	s0,16(sp)
    800024f4:	1000                	addi	s0,sp,32
    800024f6:	14202773          	csrr	a4,scause
    800024fa:	57fd                	li	a5,-1
    800024fc:	17fe                	slli	a5,a5,0x3f
    800024fe:	07a5                	addi	a5,a5,9
    80002500:	00f70c63          	beq	a4,a5,80002518 <devintr+0x2a>
    80002504:	57fd                	li	a5,-1
    80002506:	17fe                	slli	a5,a5,0x3f
    80002508:	0795                	addi	a5,a5,5
    8000250a:	4501                	li	a0,0
    8000250c:	04f70763          	beq	a4,a5,8000255a <devintr+0x6c>
    80002510:	60e2                	ld	ra,24(sp)
    80002512:	6442                	ld	s0,16(sp)
    80002514:	6105                	addi	sp,sp,32
    80002516:	8082                	ret
    80002518:	e426                	sd	s1,8(sp)
    8000251a:	5f3020ef          	jal	8000530c <plic_claim>
    8000251e:	84aa                	mv	s1,a0
    80002520:	47a9                	li	a5,10
    80002522:	00f50963          	beq	a0,a5,80002534 <devintr+0x46>
    80002526:	4785                	li	a5,1
    80002528:	00f50963          	beq	a0,a5,8000253a <devintr+0x4c>
    8000252c:	4505                	li	a0,1
    8000252e:	e889                	bnez	s1,80002540 <devintr+0x52>
    80002530:	64a2                	ld	s1,8(sp)
    80002532:	bff9                	j	80002510 <devintr+0x22>
    80002534:	ce0fe0ef          	jal	80000a14 <uartintr>
    80002538:	a819                	j	8000254e <devintr+0x60>
    8000253a:	298030ef          	jal	800057d2 <virtio_disk_intr>
    8000253e:	a801                	j	8000254e <devintr+0x60>
    80002540:	85a6                	mv	a1,s1
    80002542:	00005517          	auipc	a0,0x5
    80002546:	dae50513          	addi	a0,a0,-594 # 800072f0 <etext+0x2f0>
    8000254a:	f87fd0ef          	jal	800004d0 <printf>
    8000254e:	8526                	mv	a0,s1
    80002550:	5dd020ef          	jal	8000532c <plic_complete>
    80002554:	4505                	li	a0,1
    80002556:	64a2                	ld	s1,8(sp)
    80002558:	bf65                	j	80002510 <devintr+0x22>
    8000255a:	f41ff0ef          	jal	8000249a <clockintr>
    8000255e:	4509                	li	a0,2
    80002560:	bf45                	j	80002510 <devintr+0x22>

0000000080002562 <usertrap>:
    80002562:	1101                	addi	sp,sp,-32
    80002564:	ec06                	sd	ra,24(sp)
    80002566:	e822                	sd	s0,16(sp)
    80002568:	e426                	sd	s1,8(sp)
    8000256a:	e04a                	sd	s2,0(sp)
    8000256c:	1000                	addi	s0,sp,32
    8000256e:	100027f3          	csrr	a5,sstatus
    80002572:	1007f793          	andi	a5,a5,256
    80002576:	ef85                	bnez	a5,800025ae <usertrap+0x4c>
    80002578:	00003797          	auipc	a5,0x3
    8000257c:	ce878793          	addi	a5,a5,-792 # 80005260 <kernelvec>
    80002580:	10579073          	csrw	stvec,a5
    80002584:	b7cff0ef          	jal	80001900 <myproc>
    80002588:	84aa                	mv	s1,a0
    8000258a:	6d3c                	ld	a5,88(a0)
    8000258c:	14102773          	csrr	a4,sepc
    80002590:	ef98                	sd	a4,24(a5)
    80002592:	14202773          	csrr	a4,scause
    80002596:	47a1                	li	a5,8
    80002598:	02f70163          	beq	a4,a5,800025ba <usertrap+0x58>
    8000259c:	f53ff0ef          	jal	800024ee <devintr>
    800025a0:	892a                	mv	s2,a0
    800025a2:	c135                	beqz	a0,80002606 <usertrap+0xa4>
    800025a4:	8526                	mv	a0,s1
    800025a6:	b61ff0ef          	jal	80002106 <killed>
    800025aa:	cd1d                	beqz	a0,800025e8 <usertrap+0x86>
    800025ac:	a81d                	j	800025e2 <usertrap+0x80>
    800025ae:	00005517          	auipc	a0,0x5
    800025b2:	d6250513          	addi	a0,a0,-670 # 80007310 <etext+0x310>
    800025b6:	9ecfe0ef          	jal	800007a2 <panic>
    800025ba:	b4dff0ef          	jal	80002106 <killed>
    800025be:	e121                	bnez	a0,800025fe <usertrap+0x9c>
    800025c0:	6cb8                	ld	a4,88(s1)
    800025c2:	6f1c                	ld	a5,24(a4)
    800025c4:	0791                	addi	a5,a5,4
    800025c6:	ef1c                	sd	a5,24(a4)
    800025c8:	100027f3          	csrr	a5,sstatus
    800025cc:	0027e793          	ori	a5,a5,2
    800025d0:	10079073          	csrw	sstatus,a5
    800025d4:	248000ef          	jal	8000281c <syscall>
    800025d8:	8526                	mv	a0,s1
    800025da:	b2dff0ef          	jal	80002106 <killed>
    800025de:	c901                	beqz	a0,800025ee <usertrap+0x8c>
    800025e0:	4901                	li	s2,0
    800025e2:	557d                	li	a0,-1
    800025e4:	9f7ff0ef          	jal	80001fda <exit>
    800025e8:	4789                	li	a5,2
    800025ea:	04f90563          	beq	s2,a5,80002634 <usertrap+0xd2>
    800025ee:	e1bff0ef          	jal	80002408 <usertrapret>
    800025f2:	60e2                	ld	ra,24(sp)
    800025f4:	6442                	ld	s0,16(sp)
    800025f6:	64a2                	ld	s1,8(sp)
    800025f8:	6902                	ld	s2,0(sp)
    800025fa:	6105                	addi	sp,sp,32
    800025fc:	8082                	ret
    800025fe:	557d                	li	a0,-1
    80002600:	9dbff0ef          	jal	80001fda <exit>
    80002604:	bf75                	j	800025c0 <usertrap+0x5e>
    80002606:	142025f3          	csrr	a1,scause
    8000260a:	5890                	lw	a2,48(s1)
    8000260c:	00005517          	auipc	a0,0x5
    80002610:	d2450513          	addi	a0,a0,-732 # 80007330 <etext+0x330>
    80002614:	ebdfd0ef          	jal	800004d0 <printf>
    80002618:	141025f3          	csrr	a1,sepc
    8000261c:	14302673          	csrr	a2,stval
    80002620:	00005517          	auipc	a0,0x5
    80002624:	d4050513          	addi	a0,a0,-704 # 80007360 <etext+0x360>
    80002628:	ea9fd0ef          	jal	800004d0 <printf>
    8000262c:	8526                	mv	a0,s1
    8000262e:	ab5ff0ef          	jal	800020e2 <setkilled>
    80002632:	b75d                	j	800025d8 <usertrap+0x76>
    80002634:	86fff0ef          	jal	80001ea2 <yield>
    80002638:	bf5d                	j	800025ee <usertrap+0x8c>

000000008000263a <kerneltrap>:
    8000263a:	7179                	addi	sp,sp,-48
    8000263c:	f406                	sd	ra,40(sp)
    8000263e:	f022                	sd	s0,32(sp)
    80002640:	ec26                	sd	s1,24(sp)
    80002642:	e84a                	sd	s2,16(sp)
    80002644:	e44e                	sd	s3,8(sp)
    80002646:	1800                	addi	s0,sp,48
    80002648:	14102973          	csrr	s2,sepc
    8000264c:	100024f3          	csrr	s1,sstatus
    80002650:	142029f3          	csrr	s3,scause
    80002654:	1004f793          	andi	a5,s1,256
    80002658:	c795                	beqz	a5,80002684 <kerneltrap+0x4a>
    8000265a:	100027f3          	csrr	a5,sstatus
    8000265e:	8b89                	andi	a5,a5,2
    80002660:	eb85                	bnez	a5,80002690 <kerneltrap+0x56>
    80002662:	e8dff0ef          	jal	800024ee <devintr>
    80002666:	c91d                	beqz	a0,8000269c <kerneltrap+0x62>
    80002668:	4789                	li	a5,2
    8000266a:	04f50a63          	beq	a0,a5,800026be <kerneltrap+0x84>
    8000266e:	14191073          	csrw	sepc,s2
    80002672:	10049073          	csrw	sstatus,s1
    80002676:	70a2                	ld	ra,40(sp)
    80002678:	7402                	ld	s0,32(sp)
    8000267a:	64e2                	ld	s1,24(sp)
    8000267c:	6942                	ld	s2,16(sp)
    8000267e:	69a2                	ld	s3,8(sp)
    80002680:	6145                	addi	sp,sp,48
    80002682:	8082                	ret
    80002684:	00005517          	auipc	a0,0x5
    80002688:	d0450513          	addi	a0,a0,-764 # 80007388 <etext+0x388>
    8000268c:	916fe0ef          	jal	800007a2 <panic>
    80002690:	00005517          	auipc	a0,0x5
    80002694:	d2050513          	addi	a0,a0,-736 # 800073b0 <etext+0x3b0>
    80002698:	90afe0ef          	jal	800007a2 <panic>
    8000269c:	14102673          	csrr	a2,sepc
    800026a0:	143026f3          	csrr	a3,stval
    800026a4:	85ce                	mv	a1,s3
    800026a6:	00005517          	auipc	a0,0x5
    800026aa:	d2a50513          	addi	a0,a0,-726 # 800073d0 <etext+0x3d0>
    800026ae:	e23fd0ef          	jal	800004d0 <printf>
    800026b2:	00005517          	auipc	a0,0x5
    800026b6:	d4650513          	addi	a0,a0,-698 # 800073f8 <etext+0x3f8>
    800026ba:	8e8fe0ef          	jal	800007a2 <panic>
    800026be:	a42ff0ef          	jal	80001900 <myproc>
    800026c2:	d555                	beqz	a0,8000266e <kerneltrap+0x34>
    800026c4:	fdeff0ef          	jal	80001ea2 <yield>
    800026c8:	b75d                	j	8000266e <kerneltrap+0x34>

00000000800026ca <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800026ca:	1101                	addi	sp,sp,-32
    800026cc:	ec06                	sd	ra,24(sp)
    800026ce:	e822                	sd	s0,16(sp)
    800026d0:	e426                	sd	s1,8(sp)
    800026d2:	1000                	addi	s0,sp,32
    800026d4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800026d6:	a2aff0ef          	jal	80001900 <myproc>
  switch (n) {
    800026da:	4795                	li	a5,5
    800026dc:	0497e163          	bltu	a5,s1,8000271e <argraw+0x54>
    800026e0:	048a                	slli	s1,s1,0x2
    800026e2:	00005717          	auipc	a4,0x5
    800026e6:	0e670713          	addi	a4,a4,230 # 800077c8 <states.0+0x30>
    800026ea:	94ba                	add	s1,s1,a4
    800026ec:	409c                	lw	a5,0(s1)
    800026ee:	97ba                	add	a5,a5,a4
    800026f0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800026f2:	6d3c                	ld	a5,88(a0)
    800026f4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800026f6:	60e2                	ld	ra,24(sp)
    800026f8:	6442                	ld	s0,16(sp)
    800026fa:	64a2                	ld	s1,8(sp)
    800026fc:	6105                	addi	sp,sp,32
    800026fe:	8082                	ret
    return p->trapframe->a1;
    80002700:	6d3c                	ld	a5,88(a0)
    80002702:	7fa8                	ld	a0,120(a5)
    80002704:	bfcd                	j	800026f6 <argraw+0x2c>
    return p->trapframe->a2;
    80002706:	6d3c                	ld	a5,88(a0)
    80002708:	63c8                	ld	a0,128(a5)
    8000270a:	b7f5                	j	800026f6 <argraw+0x2c>
    return p->trapframe->a3;
    8000270c:	6d3c                	ld	a5,88(a0)
    8000270e:	67c8                	ld	a0,136(a5)
    80002710:	b7dd                	j	800026f6 <argraw+0x2c>
    return p->trapframe->a4;
    80002712:	6d3c                	ld	a5,88(a0)
    80002714:	6bc8                	ld	a0,144(a5)
    80002716:	b7c5                	j	800026f6 <argraw+0x2c>
    return p->trapframe->a5;
    80002718:	6d3c                	ld	a5,88(a0)
    8000271a:	6fc8                	ld	a0,152(a5)
    8000271c:	bfe9                	j	800026f6 <argraw+0x2c>
  panic("argraw");
    8000271e:	00005517          	auipc	a0,0x5
    80002722:	cea50513          	addi	a0,a0,-790 # 80007408 <etext+0x408>
    80002726:	87cfe0ef          	jal	800007a2 <panic>

000000008000272a <fetchaddr>:
{
    8000272a:	1101                	addi	sp,sp,-32
    8000272c:	ec06                	sd	ra,24(sp)
    8000272e:	e822                	sd	s0,16(sp)
    80002730:	e426                	sd	s1,8(sp)
    80002732:	e04a                	sd	s2,0(sp)
    80002734:	1000                	addi	s0,sp,32
    80002736:	84aa                	mv	s1,a0
    80002738:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000273a:	9c6ff0ef          	jal	80001900 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000273e:	653c                	ld	a5,72(a0)
    80002740:	02f4f663          	bgeu	s1,a5,8000276c <fetchaddr+0x42>
    80002744:	00848713          	addi	a4,s1,8
    80002748:	02e7e463          	bltu	a5,a4,80002770 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000274c:	46a1                	li	a3,8
    8000274e:	8626                	mv	a2,s1
    80002750:	85ca                	mv	a1,s2
    80002752:	6928                	ld	a0,80(a0)
    80002754:	ef5fe0ef          	jal	80001648 <copyin>
    80002758:	00a03533          	snez	a0,a0
    8000275c:	40a00533          	neg	a0,a0
}
    80002760:	60e2                	ld	ra,24(sp)
    80002762:	6442                	ld	s0,16(sp)
    80002764:	64a2                	ld	s1,8(sp)
    80002766:	6902                	ld	s2,0(sp)
    80002768:	6105                	addi	sp,sp,32
    8000276a:	8082                	ret
    return -1;
    8000276c:	557d                	li	a0,-1
    8000276e:	bfcd                	j	80002760 <fetchaddr+0x36>
    80002770:	557d                	li	a0,-1
    80002772:	b7fd                	j	80002760 <fetchaddr+0x36>

0000000080002774 <fetchstr>:
{
    80002774:	7179                	addi	sp,sp,-48
    80002776:	f406                	sd	ra,40(sp)
    80002778:	f022                	sd	s0,32(sp)
    8000277a:	ec26                	sd	s1,24(sp)
    8000277c:	e84a                	sd	s2,16(sp)
    8000277e:	e44e                	sd	s3,8(sp)
    80002780:	1800                	addi	s0,sp,48
    80002782:	892a                	mv	s2,a0
    80002784:	84ae                	mv	s1,a1
    80002786:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002788:	978ff0ef          	jal	80001900 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000278c:	86ce                	mv	a3,s3
    8000278e:	864a                	mv	a2,s2
    80002790:	85a6                	mv	a1,s1
    80002792:	6928                	ld	a0,80(a0)
    80002794:	f3bfe0ef          	jal	800016ce <copyinstr>
    80002798:	00054c63          	bltz	a0,800027b0 <fetchstr+0x3c>
  return strlen(buf);
    8000279c:	8526                	mv	a0,s1
    8000279e:	ea8fe0ef          	jal	80000e46 <strlen>
}
    800027a2:	70a2                	ld	ra,40(sp)
    800027a4:	7402                	ld	s0,32(sp)
    800027a6:	64e2                	ld	s1,24(sp)
    800027a8:	6942                	ld	s2,16(sp)
    800027aa:	69a2                	ld	s3,8(sp)
    800027ac:	6145                	addi	sp,sp,48
    800027ae:	8082                	ret
    return -1;
    800027b0:	557d                	li	a0,-1
    800027b2:	bfc5                	j	800027a2 <fetchstr+0x2e>

00000000800027b4 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800027b4:	1101                	addi	sp,sp,-32
    800027b6:	ec06                	sd	ra,24(sp)
    800027b8:	e822                	sd	s0,16(sp)
    800027ba:	e426                	sd	s1,8(sp)
    800027bc:	1000                	addi	s0,sp,32
    800027be:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027c0:	f0bff0ef          	jal	800026ca <argraw>
    800027c4:	c088                	sw	a0,0(s1)
}
    800027c6:	60e2                	ld	ra,24(sp)
    800027c8:	6442                	ld	s0,16(sp)
    800027ca:	64a2                	ld	s1,8(sp)
    800027cc:	6105                	addi	sp,sp,32
    800027ce:	8082                	ret

00000000800027d0 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800027d0:	1101                	addi	sp,sp,-32
    800027d2:	ec06                	sd	ra,24(sp)
    800027d4:	e822                	sd	s0,16(sp)
    800027d6:	e426                	sd	s1,8(sp)
    800027d8:	1000                	addi	s0,sp,32
    800027da:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027dc:	eefff0ef          	jal	800026ca <argraw>
    800027e0:	e088                	sd	a0,0(s1)
}
    800027e2:	60e2                	ld	ra,24(sp)
    800027e4:	6442                	ld	s0,16(sp)
    800027e6:	64a2                	ld	s1,8(sp)
    800027e8:	6105                	addi	sp,sp,32
    800027ea:	8082                	ret

00000000800027ec <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800027ec:	7179                	addi	sp,sp,-48
    800027ee:	f406                	sd	ra,40(sp)
    800027f0:	f022                	sd	s0,32(sp)
    800027f2:	ec26                	sd	s1,24(sp)
    800027f4:	e84a                	sd	s2,16(sp)
    800027f6:	1800                	addi	s0,sp,48
    800027f8:	84ae                	mv	s1,a1
    800027fa:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800027fc:	fd840593          	addi	a1,s0,-40
    80002800:	fd1ff0ef          	jal	800027d0 <argaddr>
  return fetchstr(addr, buf, max);
    80002804:	864a                	mv	a2,s2
    80002806:	85a6                	mv	a1,s1
    80002808:	fd843503          	ld	a0,-40(s0)
    8000280c:	f69ff0ef          	jal	80002774 <fetchstr>
}
    80002810:	70a2                	ld	ra,40(sp)
    80002812:	7402                	ld	s0,32(sp)
    80002814:	64e2                	ld	s1,24(sp)
    80002816:	6942                	ld	s2,16(sp)
    80002818:	6145                	addi	sp,sp,48
    8000281a:	8082                	ret

000000008000281c <syscall>:
[SYS_shutdown] sys_shutdown,
};

void
syscall(void)
{
    8000281c:	1101                	addi	sp,sp,-32
    8000281e:	ec06                	sd	ra,24(sp)
    80002820:	e822                	sd	s0,16(sp)
    80002822:	e426                	sd	s1,8(sp)
    80002824:	e04a                	sd	s2,0(sp)
    80002826:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002828:	8d8ff0ef          	jal	80001900 <myproc>
    8000282c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000282e:	05853903          	ld	s2,88(a0)
    80002832:	0a893783          	ld	a5,168(s2)
    80002836:	0007869b          	sext.w	a3,a5
  syscall_count++; 
    8000283a:	00008617          	auipc	a2,0x8
    8000283e:	aae60613          	addi	a2,a2,-1362 # 8000a2e8 <syscall_count>
    80002842:	6218                	ld	a4,0(a2)
    80002844:	0705                	addi	a4,a4,1
    80002846:	e218                	sd	a4,0(a2)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002848:	37fd                	addiw	a5,a5,-1
    8000284a:	4761                	li	a4,24
    8000284c:	00f76f63          	bltu	a4,a5,8000286a <syscall+0x4e>
    80002850:	00369713          	slli	a4,a3,0x3
    80002854:	00005797          	auipc	a5,0x5
    80002858:	f8c78793          	addi	a5,a5,-116 # 800077e0 <syscalls>
    8000285c:	97ba                	add	a5,a5,a4
    8000285e:	639c                	ld	a5,0(a5)
    80002860:	c789                	beqz	a5,8000286a <syscall+0x4e>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002862:	9782                	jalr	a5
    80002864:	06a93823          	sd	a0,112(s2)
    80002868:	a829                	j	80002882 <syscall+0x66>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000286a:	15848613          	addi	a2,s1,344
    8000286e:	588c                	lw	a1,48(s1)
    80002870:	00005517          	auipc	a0,0x5
    80002874:	ba050513          	addi	a0,a0,-1120 # 80007410 <etext+0x410>
    80002878:	c59fd0ef          	jal	800004d0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000287c:	6cbc                	ld	a5,88(s1)
    8000287e:	577d                	li	a4,-1
    80002880:	fbb8                	sd	a4,112(a5)
  }
}
    80002882:	60e2                	ld	ra,24(sp)
    80002884:	6442                	ld	s0,16(sp)
    80002886:	64a2                	ld	s1,8(sp)
    80002888:	6902                	ld	s2,0(sp)
    8000288a:	6105                	addi	sp,sp,32
    8000288c:	8082                	ret

000000008000288e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000288e:	1101                	addi	sp,sp,-32
    80002890:	ec06                	sd	ra,24(sp)
    80002892:	e822                	sd	s0,16(sp)
    80002894:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002896:	fec40593          	addi	a1,s0,-20
    8000289a:	4501                	li	a0,0
    8000289c:	f19ff0ef          	jal	800027b4 <argint>
  exit(n);
    800028a0:	fec42503          	lw	a0,-20(s0)
    800028a4:	f36ff0ef          	jal	80001fda <exit>
  return 0;  // not reached
}
    800028a8:	4501                	li	a0,0
    800028aa:	60e2                	ld	ra,24(sp)
    800028ac:	6442                	ld	s0,16(sp)
    800028ae:	6105                	addi	sp,sp,32
    800028b0:	8082                	ret

00000000800028b2 <sys_getpid>:

uint64
sys_getpid(void)
{
    800028b2:	1141                	addi	sp,sp,-16
    800028b4:	e406                	sd	ra,8(sp)
    800028b6:	e022                	sd	s0,0(sp)
    800028b8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800028ba:	846ff0ef          	jal	80001900 <myproc>
}
    800028be:	5908                	lw	a0,48(a0)
    800028c0:	60a2                	ld	ra,8(sp)
    800028c2:	6402                	ld	s0,0(sp)
    800028c4:	0141                	addi	sp,sp,16
    800028c6:	8082                	ret

00000000800028c8 <sys_fork>:

uint64
sys_fork(void)
{
    800028c8:	1141                	addi	sp,sp,-16
    800028ca:	e406                	sd	ra,8(sp)
    800028cc:	e022                	sd	s0,0(sp)
    800028ce:	0800                	addi	s0,sp,16
  return fork();
    800028d0:	b56ff0ef          	jal	80001c26 <fork>
}
    800028d4:	60a2                	ld	ra,8(sp)
    800028d6:	6402                	ld	s0,0(sp)
    800028d8:	0141                	addi	sp,sp,16
    800028da:	8082                	ret

00000000800028dc <sys_wait>:

uint64
sys_wait(void)
{
    800028dc:	1101                	addi	sp,sp,-32
    800028de:	ec06                	sd	ra,24(sp)
    800028e0:	e822                	sd	s0,16(sp)
    800028e2:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800028e4:	fe840593          	addi	a1,s0,-24
    800028e8:	4501                	li	a0,0
    800028ea:	ee7ff0ef          	jal	800027d0 <argaddr>
  return wait(p);
    800028ee:	fe843503          	ld	a0,-24(s0)
    800028f2:	83fff0ef          	jal	80002130 <wait>
}
    800028f6:	60e2                	ld	ra,24(sp)
    800028f8:	6442                	ld	s0,16(sp)
    800028fa:	6105                	addi	sp,sp,32
    800028fc:	8082                	ret

00000000800028fe <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800028fe:	7179                	addi	sp,sp,-48
    80002900:	f406                	sd	ra,40(sp)
    80002902:	f022                	sd	s0,32(sp)
    80002904:	ec26                	sd	s1,24(sp)
    80002906:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002908:	fdc40593          	addi	a1,s0,-36
    8000290c:	4501                	li	a0,0
    8000290e:	ea7ff0ef          	jal	800027b4 <argint>
  addr = myproc()->sz;
    80002912:	feffe0ef          	jal	80001900 <myproc>
    80002916:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002918:	fdc42503          	lw	a0,-36(s0)
    8000291c:	abaff0ef          	jal	80001bd6 <growproc>
    80002920:	00054863          	bltz	a0,80002930 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002924:	8526                	mv	a0,s1
    80002926:	70a2                	ld	ra,40(sp)
    80002928:	7402                	ld	s0,32(sp)
    8000292a:	64e2                	ld	s1,24(sp)
    8000292c:	6145                	addi	sp,sp,48
    8000292e:	8082                	ret
    return -1;
    80002930:	54fd                	li	s1,-1
    80002932:	bfcd                	j	80002924 <sys_sbrk+0x26>

0000000080002934 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002934:	7139                	addi	sp,sp,-64
    80002936:	fc06                	sd	ra,56(sp)
    80002938:	f822                	sd	s0,48(sp)
    8000293a:	f04a                	sd	s2,32(sp)
    8000293c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000293e:	fcc40593          	addi	a1,s0,-52
    80002942:	4501                	li	a0,0
    80002944:	e71ff0ef          	jal	800027b4 <argint>
  if(n < 0)
    80002948:	fcc42783          	lw	a5,-52(s0)
    8000294c:	0607c763          	bltz	a5,800029ba <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002950:	00016517          	auipc	a0,0x16
    80002954:	8f050513          	addi	a0,a0,-1808 # 80018240 <tickslock>
    80002958:	aaafe0ef          	jal	80000c02 <acquire>
  ticks0 = ticks;
    8000295c:	00008917          	auipc	s2,0x8
    80002960:	98492903          	lw	s2,-1660(s2) # 8000a2e0 <ticks>
  while(ticks - ticks0 < n){
    80002964:	fcc42783          	lw	a5,-52(s0)
    80002968:	cf8d                	beqz	a5,800029a2 <sys_sleep+0x6e>
    8000296a:	f426                	sd	s1,40(sp)
    8000296c:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000296e:	00016997          	auipc	s3,0x16
    80002972:	8d298993          	addi	s3,s3,-1838 # 80018240 <tickslock>
    80002976:	00008497          	auipc	s1,0x8
    8000297a:	96a48493          	addi	s1,s1,-1686 # 8000a2e0 <ticks>
    if(killed(myproc())){
    8000297e:	f83fe0ef          	jal	80001900 <myproc>
    80002982:	f84ff0ef          	jal	80002106 <killed>
    80002986:	ed0d                	bnez	a0,800029c0 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002988:	85ce                	mv	a1,s3
    8000298a:	8526                	mv	a0,s1
    8000298c:	d42ff0ef          	jal	80001ece <sleep>
  while(ticks - ticks0 < n){
    80002990:	409c                	lw	a5,0(s1)
    80002992:	412787bb          	subw	a5,a5,s2
    80002996:	fcc42703          	lw	a4,-52(s0)
    8000299a:	fee7e2e3          	bltu	a5,a4,8000297e <sys_sleep+0x4a>
    8000299e:	74a2                	ld	s1,40(sp)
    800029a0:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800029a2:	00016517          	auipc	a0,0x16
    800029a6:	89e50513          	addi	a0,a0,-1890 # 80018240 <tickslock>
    800029aa:	af0fe0ef          	jal	80000c9a <release>
  return 0;
    800029ae:	4501                	li	a0,0
}
    800029b0:	70e2                	ld	ra,56(sp)
    800029b2:	7442                	ld	s0,48(sp)
    800029b4:	7902                	ld	s2,32(sp)
    800029b6:	6121                	addi	sp,sp,64
    800029b8:	8082                	ret
    n = 0;
    800029ba:	fc042623          	sw	zero,-52(s0)
    800029be:	bf49                	j	80002950 <sys_sleep+0x1c>
      release(&tickslock);
    800029c0:	00016517          	auipc	a0,0x16
    800029c4:	88050513          	addi	a0,a0,-1920 # 80018240 <tickslock>
    800029c8:	ad2fe0ef          	jal	80000c9a <release>
      return -1;
    800029cc:	557d                	li	a0,-1
    800029ce:	74a2                	ld	s1,40(sp)
    800029d0:	69e2                	ld	s3,24(sp)
    800029d2:	bff9                	j	800029b0 <sys_sleep+0x7c>

00000000800029d4 <sys_kill>:

uint64
sys_kill(void)
{
    800029d4:	1101                	addi	sp,sp,-32
    800029d6:	ec06                	sd	ra,24(sp)
    800029d8:	e822                	sd	s0,16(sp)
    800029da:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800029dc:	fec40593          	addi	a1,s0,-20
    800029e0:	4501                	li	a0,0
    800029e2:	dd3ff0ef          	jal	800027b4 <argint>
  return kill(pid);
    800029e6:	fec42503          	lw	a0,-20(s0)
    800029ea:	e92ff0ef          	jal	8000207c <kill>
}
    800029ee:	60e2                	ld	ra,24(sp)
    800029f0:	6442                	ld	s0,16(sp)
    800029f2:	6105                	addi	sp,sp,32
    800029f4:	8082                	ret

00000000800029f6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800029f6:	1101                	addi	sp,sp,-32
    800029f8:	ec06                	sd	ra,24(sp)
    800029fa:	e822                	sd	s0,16(sp)
    800029fc:	e426                	sd	s1,8(sp)
    800029fe:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002a00:	00016517          	auipc	a0,0x16
    80002a04:	84050513          	addi	a0,a0,-1984 # 80018240 <tickslock>
    80002a08:	9fafe0ef          	jal	80000c02 <acquire>
  xticks = ticks;
    80002a0c:	00008497          	auipc	s1,0x8
    80002a10:	8d44a483          	lw	s1,-1836(s1) # 8000a2e0 <ticks>
  release(&tickslock);
    80002a14:	00016517          	auipc	a0,0x16
    80002a18:	82c50513          	addi	a0,a0,-2004 # 80018240 <tickslock>
    80002a1c:	a7efe0ef          	jal	80000c9a <release>
  return xticks;
}
    80002a20:	02049513          	slli	a0,s1,0x20
    80002a24:	9101                	srli	a0,a0,0x20
    80002a26:	60e2                	ld	ra,24(sp)
    80002a28:	6442                	ld	s0,16(sp)
    80002a2a:	64a2                	ld	s1,8(sp)
    80002a2c:	6105                	addi	sp,sp,32
    80002a2e:	8082                	ret

0000000080002a30 <sys_countsyscall>:
uint64 syscall_count = 0;
uint64
sys_countsyscall(void)
{
    80002a30:	1141                	addi	sp,sp,-16
    80002a32:	e422                	sd	s0,8(sp)
    80002a34:	0800                	addi	s0,sp,16
  return syscall_count;
}
    80002a36:	00008517          	auipc	a0,0x8
    80002a3a:	8b253503          	ld	a0,-1870(a0) # 8000a2e8 <syscall_count>
    80002a3e:	6422                	ld	s0,8(sp)
    80002a40:	0141                	addi	sp,sp,16
    80002a42:	8082                	ret

0000000080002a44 <sys_getppid>:
uint64
sys_getppid(void)
{
    80002a44:	1141                	addi	sp,sp,-16
    80002a46:	e406                	sd	ra,8(sp)
    80002a48:	e022                	sd	s0,0(sp)
    80002a4a:	0800                	addi	s0,sp,16
  return myproc()->parent->pid;
    80002a4c:	eb5fe0ef          	jal	80001900 <myproc>
    80002a50:	7d1c                	ld	a5,56(a0)
}
    80002a52:	5b88                	lw	a0,48(a5)
    80002a54:	60a2                	ld	ra,8(sp)
    80002a56:	6402                	ld	s0,0(sp)
    80002a58:	0141                	addi	sp,sp,16
    80002a5a:	8082                	ret

0000000080002a5c <sys_shutdown>:
uint64
sys_shutdown(void)
{
    80002a5c:	1141                	addi	sp,sp,-16
    80002a5e:	e406                	sd	ra,8(sp)
    80002a60:	e022                	sd	s0,0(sp)
    80002a62:	0800                	addi	s0,sp,16
  printf("shutting down \n");
    80002a64:	00005517          	auipc	a0,0x5
    80002a68:	9cc50513          	addi	a0,a0,-1588 # 80007430 <etext+0x430>
    80002a6c:	a65fd0ef          	jal	800004d0 <printf>
  volatile uint32 *shutdown_reg=(uint32 *)0x100000;
  *shutdown_reg=0x5555;
    80002a70:	6795                	lui	a5,0x5
    80002a72:	55578793          	addi	a5,a5,1365 # 5555 <_entry-0x7fffaaab>
    80002a76:	00100737          	lui	a4,0x100
    80002a7a:	c31c                	sw	a5,0(a4)
  return 0;
}
    80002a7c:	4501                	li	a0,0
    80002a7e:	60a2                	ld	ra,8(sp)
    80002a80:	6402                	ld	s0,0(sp)
    80002a82:	0141                	addi	sp,sp,16
    80002a84:	8082                	ret

0000000080002a86 <binit>:
    80002a86:	7179                	addi	sp,sp,-48
    80002a88:	f406                	sd	ra,40(sp)
    80002a8a:	f022                	sd	s0,32(sp)
    80002a8c:	ec26                	sd	s1,24(sp)
    80002a8e:	e84a                	sd	s2,16(sp)
    80002a90:	e44e                	sd	s3,8(sp)
    80002a92:	e052                	sd	s4,0(sp)
    80002a94:	1800                	addi	s0,sp,48
    80002a96:	00005597          	auipc	a1,0x5
    80002a9a:	9aa58593          	addi	a1,a1,-1622 # 80007440 <etext+0x440>
    80002a9e:	00015517          	auipc	a0,0x15
    80002aa2:	7ba50513          	addi	a0,a0,1978 # 80018258 <bcache>
    80002aa6:	8dcfe0ef          	jal	80000b82 <initlock>
    80002aaa:	0001d797          	auipc	a5,0x1d
    80002aae:	7ae78793          	addi	a5,a5,1966 # 80020258 <bcache+0x8000>
    80002ab2:	0001e717          	auipc	a4,0x1e
    80002ab6:	a0e70713          	addi	a4,a4,-1522 # 800204c0 <bcache+0x8268>
    80002aba:	2ae7b823          	sd	a4,688(a5)
    80002abe:	2ae7bc23          	sd	a4,696(a5)
    80002ac2:	00015497          	auipc	s1,0x15
    80002ac6:	7ae48493          	addi	s1,s1,1966 # 80018270 <bcache+0x18>
    80002aca:	893e                	mv	s2,a5
    80002acc:	89ba                	mv	s3,a4
    80002ace:	00005a17          	auipc	s4,0x5
    80002ad2:	97aa0a13          	addi	s4,s4,-1670 # 80007448 <etext+0x448>
    80002ad6:	2b893783          	ld	a5,696(s2)
    80002ada:	e8bc                	sd	a5,80(s1)
    80002adc:	0534b423          	sd	s3,72(s1)
    80002ae0:	85d2                	mv	a1,s4
    80002ae2:	01048513          	addi	a0,s1,16
    80002ae6:	248010ef          	jal	80003d2e <initsleeplock>
    80002aea:	2b893783          	ld	a5,696(s2)
    80002aee:	e7a4                	sd	s1,72(a5)
    80002af0:	2a993c23          	sd	s1,696(s2)
    80002af4:	45848493          	addi	s1,s1,1112
    80002af8:	fd349fe3          	bne	s1,s3,80002ad6 <binit+0x50>
    80002afc:	70a2                	ld	ra,40(sp)
    80002afe:	7402                	ld	s0,32(sp)
    80002b00:	64e2                	ld	s1,24(sp)
    80002b02:	6942                	ld	s2,16(sp)
    80002b04:	69a2                	ld	s3,8(sp)
    80002b06:	6a02                	ld	s4,0(sp)
    80002b08:	6145                	addi	sp,sp,48
    80002b0a:	8082                	ret

0000000080002b0c <bread>:
    80002b0c:	7179                	addi	sp,sp,-48
    80002b0e:	f406                	sd	ra,40(sp)
    80002b10:	f022                	sd	s0,32(sp)
    80002b12:	ec26                	sd	s1,24(sp)
    80002b14:	e84a                	sd	s2,16(sp)
    80002b16:	e44e                	sd	s3,8(sp)
    80002b18:	1800                	addi	s0,sp,48
    80002b1a:	892a                	mv	s2,a0
    80002b1c:	89ae                	mv	s3,a1
    80002b1e:	00015517          	auipc	a0,0x15
    80002b22:	73a50513          	addi	a0,a0,1850 # 80018258 <bcache>
    80002b26:	8dcfe0ef          	jal	80000c02 <acquire>
    80002b2a:	0001e497          	auipc	s1,0x1e
    80002b2e:	9e64b483          	ld	s1,-1562(s1) # 80020510 <bcache+0x82b8>
    80002b32:	0001e797          	auipc	a5,0x1e
    80002b36:	98e78793          	addi	a5,a5,-1650 # 800204c0 <bcache+0x8268>
    80002b3a:	02f48b63          	beq	s1,a5,80002b70 <bread+0x64>
    80002b3e:	873e                	mv	a4,a5
    80002b40:	a021                	j	80002b48 <bread+0x3c>
    80002b42:	68a4                	ld	s1,80(s1)
    80002b44:	02e48663          	beq	s1,a4,80002b70 <bread+0x64>
    80002b48:	449c                	lw	a5,8(s1)
    80002b4a:	ff279ce3          	bne	a5,s2,80002b42 <bread+0x36>
    80002b4e:	44dc                	lw	a5,12(s1)
    80002b50:	ff3799e3          	bne	a5,s3,80002b42 <bread+0x36>
    80002b54:	40bc                	lw	a5,64(s1)
    80002b56:	2785                	addiw	a5,a5,1
    80002b58:	c0bc                	sw	a5,64(s1)
    80002b5a:	00015517          	auipc	a0,0x15
    80002b5e:	6fe50513          	addi	a0,a0,1790 # 80018258 <bcache>
    80002b62:	938fe0ef          	jal	80000c9a <release>
    80002b66:	01048513          	addi	a0,s1,16
    80002b6a:	1fa010ef          	jal	80003d64 <acquiresleep>
    80002b6e:	a889                	j	80002bc0 <bread+0xb4>
    80002b70:	0001e497          	auipc	s1,0x1e
    80002b74:	9984b483          	ld	s1,-1640(s1) # 80020508 <bcache+0x82b0>
    80002b78:	0001e797          	auipc	a5,0x1e
    80002b7c:	94878793          	addi	a5,a5,-1720 # 800204c0 <bcache+0x8268>
    80002b80:	00f48863          	beq	s1,a5,80002b90 <bread+0x84>
    80002b84:	873e                	mv	a4,a5
    80002b86:	40bc                	lw	a5,64(s1)
    80002b88:	cb91                	beqz	a5,80002b9c <bread+0x90>
    80002b8a:	64a4                	ld	s1,72(s1)
    80002b8c:	fee49de3          	bne	s1,a4,80002b86 <bread+0x7a>
    80002b90:	00005517          	auipc	a0,0x5
    80002b94:	8c050513          	addi	a0,a0,-1856 # 80007450 <etext+0x450>
    80002b98:	c0bfd0ef          	jal	800007a2 <panic>
    80002b9c:	0124a423          	sw	s2,8(s1)
    80002ba0:	0134a623          	sw	s3,12(s1)
    80002ba4:	0004a023          	sw	zero,0(s1)
    80002ba8:	4785                	li	a5,1
    80002baa:	c0bc                	sw	a5,64(s1)
    80002bac:	00015517          	auipc	a0,0x15
    80002bb0:	6ac50513          	addi	a0,a0,1708 # 80018258 <bcache>
    80002bb4:	8e6fe0ef          	jal	80000c9a <release>
    80002bb8:	01048513          	addi	a0,s1,16
    80002bbc:	1a8010ef          	jal	80003d64 <acquiresleep>
    80002bc0:	409c                	lw	a5,0(s1)
    80002bc2:	cb89                	beqz	a5,80002bd4 <bread+0xc8>
    80002bc4:	8526                	mv	a0,s1
    80002bc6:	70a2                	ld	ra,40(sp)
    80002bc8:	7402                	ld	s0,32(sp)
    80002bca:	64e2                	ld	s1,24(sp)
    80002bcc:	6942                	ld	s2,16(sp)
    80002bce:	69a2                	ld	s3,8(sp)
    80002bd0:	6145                	addi	sp,sp,48
    80002bd2:	8082                	ret
    80002bd4:	4581                	li	a1,0
    80002bd6:	8526                	mv	a0,s1
    80002bd8:	1e9020ef          	jal	800055c0 <virtio_disk_rw>
    80002bdc:	4785                	li	a5,1
    80002bde:	c09c                	sw	a5,0(s1)
    80002be0:	b7d5                	j	80002bc4 <bread+0xb8>

0000000080002be2 <bwrite>:
    80002be2:	1101                	addi	sp,sp,-32
    80002be4:	ec06                	sd	ra,24(sp)
    80002be6:	e822                	sd	s0,16(sp)
    80002be8:	e426                	sd	s1,8(sp)
    80002bea:	1000                	addi	s0,sp,32
    80002bec:	84aa                	mv	s1,a0
    80002bee:	0541                	addi	a0,a0,16
    80002bf0:	1f2010ef          	jal	80003de2 <holdingsleep>
    80002bf4:	c911                	beqz	a0,80002c08 <bwrite+0x26>
    80002bf6:	4585                	li	a1,1
    80002bf8:	8526                	mv	a0,s1
    80002bfa:	1c7020ef          	jal	800055c0 <virtio_disk_rw>
    80002bfe:	60e2                	ld	ra,24(sp)
    80002c00:	6442                	ld	s0,16(sp)
    80002c02:	64a2                	ld	s1,8(sp)
    80002c04:	6105                	addi	sp,sp,32
    80002c06:	8082                	ret
    80002c08:	00005517          	auipc	a0,0x5
    80002c0c:	86050513          	addi	a0,a0,-1952 # 80007468 <etext+0x468>
    80002c10:	b93fd0ef          	jal	800007a2 <panic>

0000000080002c14 <brelse>:
    80002c14:	1101                	addi	sp,sp,-32
    80002c16:	ec06                	sd	ra,24(sp)
    80002c18:	e822                	sd	s0,16(sp)
    80002c1a:	e426                	sd	s1,8(sp)
    80002c1c:	e04a                	sd	s2,0(sp)
    80002c1e:	1000                	addi	s0,sp,32
    80002c20:	84aa                	mv	s1,a0
    80002c22:	01050913          	addi	s2,a0,16
    80002c26:	854a                	mv	a0,s2
    80002c28:	1ba010ef          	jal	80003de2 <holdingsleep>
    80002c2c:	c135                	beqz	a0,80002c90 <brelse+0x7c>
    80002c2e:	854a                	mv	a0,s2
    80002c30:	17a010ef          	jal	80003daa <releasesleep>
    80002c34:	00015517          	auipc	a0,0x15
    80002c38:	62450513          	addi	a0,a0,1572 # 80018258 <bcache>
    80002c3c:	fc7fd0ef          	jal	80000c02 <acquire>
    80002c40:	40bc                	lw	a5,64(s1)
    80002c42:	37fd                	addiw	a5,a5,-1
    80002c44:	0007871b          	sext.w	a4,a5
    80002c48:	c0bc                	sw	a5,64(s1)
    80002c4a:	e71d                	bnez	a4,80002c78 <brelse+0x64>
    80002c4c:	68b8                	ld	a4,80(s1)
    80002c4e:	64bc                	ld	a5,72(s1)
    80002c50:	e73c                	sd	a5,72(a4)
    80002c52:	68b8                	ld	a4,80(s1)
    80002c54:	ebb8                	sd	a4,80(a5)
    80002c56:	0001d797          	auipc	a5,0x1d
    80002c5a:	60278793          	addi	a5,a5,1538 # 80020258 <bcache+0x8000>
    80002c5e:	2b87b703          	ld	a4,696(a5)
    80002c62:	e8b8                	sd	a4,80(s1)
    80002c64:	0001e717          	auipc	a4,0x1e
    80002c68:	85c70713          	addi	a4,a4,-1956 # 800204c0 <bcache+0x8268>
    80002c6c:	e4b8                	sd	a4,72(s1)
    80002c6e:	2b87b703          	ld	a4,696(a5)
    80002c72:	e724                	sd	s1,72(a4)
    80002c74:	2a97bc23          	sd	s1,696(a5)
    80002c78:	00015517          	auipc	a0,0x15
    80002c7c:	5e050513          	addi	a0,a0,1504 # 80018258 <bcache>
    80002c80:	81afe0ef          	jal	80000c9a <release>
    80002c84:	60e2                	ld	ra,24(sp)
    80002c86:	6442                	ld	s0,16(sp)
    80002c88:	64a2                	ld	s1,8(sp)
    80002c8a:	6902                	ld	s2,0(sp)
    80002c8c:	6105                	addi	sp,sp,32
    80002c8e:	8082                	ret
    80002c90:	00004517          	auipc	a0,0x4
    80002c94:	7e050513          	addi	a0,a0,2016 # 80007470 <etext+0x470>
    80002c98:	b0bfd0ef          	jal	800007a2 <panic>

0000000080002c9c <bpin>:
    80002c9c:	1101                	addi	sp,sp,-32
    80002c9e:	ec06                	sd	ra,24(sp)
    80002ca0:	e822                	sd	s0,16(sp)
    80002ca2:	e426                	sd	s1,8(sp)
    80002ca4:	1000                	addi	s0,sp,32
    80002ca6:	84aa                	mv	s1,a0
    80002ca8:	00015517          	auipc	a0,0x15
    80002cac:	5b050513          	addi	a0,a0,1456 # 80018258 <bcache>
    80002cb0:	f53fd0ef          	jal	80000c02 <acquire>
    80002cb4:	40bc                	lw	a5,64(s1)
    80002cb6:	2785                	addiw	a5,a5,1
    80002cb8:	c0bc                	sw	a5,64(s1)
    80002cba:	00015517          	auipc	a0,0x15
    80002cbe:	59e50513          	addi	a0,a0,1438 # 80018258 <bcache>
    80002cc2:	fd9fd0ef          	jal	80000c9a <release>
    80002cc6:	60e2                	ld	ra,24(sp)
    80002cc8:	6442                	ld	s0,16(sp)
    80002cca:	64a2                	ld	s1,8(sp)
    80002ccc:	6105                	addi	sp,sp,32
    80002cce:	8082                	ret

0000000080002cd0 <bunpin>:
    80002cd0:	1101                	addi	sp,sp,-32
    80002cd2:	ec06                	sd	ra,24(sp)
    80002cd4:	e822                	sd	s0,16(sp)
    80002cd6:	e426                	sd	s1,8(sp)
    80002cd8:	1000                	addi	s0,sp,32
    80002cda:	84aa                	mv	s1,a0
    80002cdc:	00015517          	auipc	a0,0x15
    80002ce0:	57c50513          	addi	a0,a0,1404 # 80018258 <bcache>
    80002ce4:	f1ffd0ef          	jal	80000c02 <acquire>
    80002ce8:	40bc                	lw	a5,64(s1)
    80002cea:	37fd                	addiw	a5,a5,-1
    80002cec:	c0bc                	sw	a5,64(s1)
    80002cee:	00015517          	auipc	a0,0x15
    80002cf2:	56a50513          	addi	a0,a0,1386 # 80018258 <bcache>
    80002cf6:	fa5fd0ef          	jal	80000c9a <release>
    80002cfa:	60e2                	ld	ra,24(sp)
    80002cfc:	6442                	ld	s0,16(sp)
    80002cfe:	64a2                	ld	s1,8(sp)
    80002d00:	6105                	addi	sp,sp,32
    80002d02:	8082                	ret

0000000080002d04 <bfree>:
    80002d04:	1101                	addi	sp,sp,-32
    80002d06:	ec06                	sd	ra,24(sp)
    80002d08:	e822                	sd	s0,16(sp)
    80002d0a:	e426                	sd	s1,8(sp)
    80002d0c:	e04a                	sd	s2,0(sp)
    80002d0e:	1000                	addi	s0,sp,32
    80002d10:	84ae                	mv	s1,a1
    80002d12:	00d5d59b          	srliw	a1,a1,0xd
    80002d16:	0001e797          	auipc	a5,0x1e
    80002d1a:	c1e7a783          	lw	a5,-994(a5) # 80020934 <sb+0x1c>
    80002d1e:	9dbd                	addw	a1,a1,a5
    80002d20:	dedff0ef          	jal	80002b0c <bread>
    80002d24:	0074f713          	andi	a4,s1,7
    80002d28:	4785                	li	a5,1
    80002d2a:	00e797bb          	sllw	a5,a5,a4
    80002d2e:	14ce                	slli	s1,s1,0x33
    80002d30:	90d9                	srli	s1,s1,0x36
    80002d32:	00950733          	add	a4,a0,s1
    80002d36:	05874703          	lbu	a4,88(a4)
    80002d3a:	00e7f6b3          	and	a3,a5,a4
    80002d3e:	c29d                	beqz	a3,80002d64 <bfree+0x60>
    80002d40:	892a                	mv	s2,a0
    80002d42:	94aa                	add	s1,s1,a0
    80002d44:	fff7c793          	not	a5,a5
    80002d48:	8f7d                	and	a4,a4,a5
    80002d4a:	04e48c23          	sb	a4,88(s1)
    80002d4e:	711000ef          	jal	80003c5e <log_write>
    80002d52:	854a                	mv	a0,s2
    80002d54:	ec1ff0ef          	jal	80002c14 <brelse>
    80002d58:	60e2                	ld	ra,24(sp)
    80002d5a:	6442                	ld	s0,16(sp)
    80002d5c:	64a2                	ld	s1,8(sp)
    80002d5e:	6902                	ld	s2,0(sp)
    80002d60:	6105                	addi	sp,sp,32
    80002d62:	8082                	ret
    80002d64:	00004517          	auipc	a0,0x4
    80002d68:	71450513          	addi	a0,a0,1812 # 80007478 <etext+0x478>
    80002d6c:	a37fd0ef          	jal	800007a2 <panic>

0000000080002d70 <balloc>:
    80002d70:	711d                	addi	sp,sp,-96
    80002d72:	ec86                	sd	ra,88(sp)
    80002d74:	e8a2                	sd	s0,80(sp)
    80002d76:	e4a6                	sd	s1,72(sp)
    80002d78:	1080                	addi	s0,sp,96
    80002d7a:	0001e797          	auipc	a5,0x1e
    80002d7e:	ba27a783          	lw	a5,-1118(a5) # 8002091c <sb+0x4>
    80002d82:	0e078f63          	beqz	a5,80002e80 <balloc+0x110>
    80002d86:	e0ca                	sd	s2,64(sp)
    80002d88:	fc4e                	sd	s3,56(sp)
    80002d8a:	f852                	sd	s4,48(sp)
    80002d8c:	f456                	sd	s5,40(sp)
    80002d8e:	f05a                	sd	s6,32(sp)
    80002d90:	ec5e                	sd	s7,24(sp)
    80002d92:	e862                	sd	s8,16(sp)
    80002d94:	e466                	sd	s9,8(sp)
    80002d96:	8baa                	mv	s7,a0
    80002d98:	4a81                	li	s5,0
    80002d9a:	0001eb17          	auipc	s6,0x1e
    80002d9e:	b7eb0b13          	addi	s6,s6,-1154 # 80020918 <sb>
    80002da2:	4c01                	li	s8,0
    80002da4:	4985                	li	s3,1
    80002da6:	6a09                	lui	s4,0x2
    80002da8:	6c89                	lui	s9,0x2
    80002daa:	a0b5                	j	80002e16 <balloc+0xa6>
    80002dac:	97ca                	add	a5,a5,s2
    80002dae:	8e55                	or	a2,a2,a3
    80002db0:	04c78c23          	sb	a2,88(a5)
    80002db4:	854a                	mv	a0,s2
    80002db6:	6a9000ef          	jal	80003c5e <log_write>
    80002dba:	854a                	mv	a0,s2
    80002dbc:	e59ff0ef          	jal	80002c14 <brelse>
    80002dc0:	85a6                	mv	a1,s1
    80002dc2:	855e                	mv	a0,s7
    80002dc4:	d49ff0ef          	jal	80002b0c <bread>
    80002dc8:	892a                	mv	s2,a0
    80002dca:	40000613          	li	a2,1024
    80002dce:	4581                	li	a1,0
    80002dd0:	05850513          	addi	a0,a0,88
    80002dd4:	f03fd0ef          	jal	80000cd6 <memset>
    80002dd8:	854a                	mv	a0,s2
    80002dda:	685000ef          	jal	80003c5e <log_write>
    80002dde:	854a                	mv	a0,s2
    80002de0:	e35ff0ef          	jal	80002c14 <brelse>
    80002de4:	6906                	ld	s2,64(sp)
    80002de6:	79e2                	ld	s3,56(sp)
    80002de8:	7a42                	ld	s4,48(sp)
    80002dea:	7aa2                	ld	s5,40(sp)
    80002dec:	7b02                	ld	s6,32(sp)
    80002dee:	6be2                	ld	s7,24(sp)
    80002df0:	6c42                	ld	s8,16(sp)
    80002df2:	6ca2                	ld	s9,8(sp)
    80002df4:	8526                	mv	a0,s1
    80002df6:	60e6                	ld	ra,88(sp)
    80002df8:	6446                	ld	s0,80(sp)
    80002dfa:	64a6                	ld	s1,72(sp)
    80002dfc:	6125                	addi	sp,sp,96
    80002dfe:	8082                	ret
    80002e00:	854a                	mv	a0,s2
    80002e02:	e13ff0ef          	jal	80002c14 <brelse>
    80002e06:	015c87bb          	addw	a5,s9,s5
    80002e0a:	00078a9b          	sext.w	s5,a5
    80002e0e:	004b2703          	lw	a4,4(s6)
    80002e12:	04eaff63          	bgeu	s5,a4,80002e70 <balloc+0x100>
    80002e16:	41fad79b          	sraiw	a5,s5,0x1f
    80002e1a:	0137d79b          	srliw	a5,a5,0x13
    80002e1e:	015787bb          	addw	a5,a5,s5
    80002e22:	40d7d79b          	sraiw	a5,a5,0xd
    80002e26:	01cb2583          	lw	a1,28(s6)
    80002e2a:	9dbd                	addw	a1,a1,a5
    80002e2c:	855e                	mv	a0,s7
    80002e2e:	cdfff0ef          	jal	80002b0c <bread>
    80002e32:	892a                	mv	s2,a0
    80002e34:	004b2503          	lw	a0,4(s6)
    80002e38:	000a849b          	sext.w	s1,s5
    80002e3c:	8762                	mv	a4,s8
    80002e3e:	fca4f1e3          	bgeu	s1,a0,80002e00 <balloc+0x90>
    80002e42:	00777693          	andi	a3,a4,7
    80002e46:	00d996bb          	sllw	a3,s3,a3
    80002e4a:	41f7579b          	sraiw	a5,a4,0x1f
    80002e4e:	01d7d79b          	srliw	a5,a5,0x1d
    80002e52:	9fb9                	addw	a5,a5,a4
    80002e54:	4037d79b          	sraiw	a5,a5,0x3
    80002e58:	00f90633          	add	a2,s2,a5
    80002e5c:	05864603          	lbu	a2,88(a2)
    80002e60:	00c6f5b3          	and	a1,a3,a2
    80002e64:	d5a1                	beqz	a1,80002dac <balloc+0x3c>
    80002e66:	2705                	addiw	a4,a4,1
    80002e68:	2485                	addiw	s1,s1,1
    80002e6a:	fd471ae3          	bne	a4,s4,80002e3e <balloc+0xce>
    80002e6e:	bf49                	j	80002e00 <balloc+0x90>
    80002e70:	6906                	ld	s2,64(sp)
    80002e72:	79e2                	ld	s3,56(sp)
    80002e74:	7a42                	ld	s4,48(sp)
    80002e76:	7aa2                	ld	s5,40(sp)
    80002e78:	7b02                	ld	s6,32(sp)
    80002e7a:	6be2                	ld	s7,24(sp)
    80002e7c:	6c42                	ld	s8,16(sp)
    80002e7e:	6ca2                	ld	s9,8(sp)
    80002e80:	00004517          	auipc	a0,0x4
    80002e84:	61050513          	addi	a0,a0,1552 # 80007490 <etext+0x490>
    80002e88:	e48fd0ef          	jal	800004d0 <printf>
    80002e8c:	4481                	li	s1,0
    80002e8e:	b79d                	j	80002df4 <balloc+0x84>

0000000080002e90 <bmap>:
    80002e90:	7179                	addi	sp,sp,-48
    80002e92:	f406                	sd	ra,40(sp)
    80002e94:	f022                	sd	s0,32(sp)
    80002e96:	ec26                	sd	s1,24(sp)
    80002e98:	e84a                	sd	s2,16(sp)
    80002e9a:	e44e                	sd	s3,8(sp)
    80002e9c:	1800                	addi	s0,sp,48
    80002e9e:	89aa                	mv	s3,a0
    80002ea0:	47ad                	li	a5,11
    80002ea2:	02b7e663          	bltu	a5,a1,80002ece <bmap+0x3e>
    80002ea6:	02059793          	slli	a5,a1,0x20
    80002eaa:	01e7d593          	srli	a1,a5,0x1e
    80002eae:	00b504b3          	add	s1,a0,a1
    80002eb2:	0504a903          	lw	s2,80(s1)
    80002eb6:	06091a63          	bnez	s2,80002f2a <bmap+0x9a>
    80002eba:	4108                	lw	a0,0(a0)
    80002ebc:	eb5ff0ef          	jal	80002d70 <balloc>
    80002ec0:	0005091b          	sext.w	s2,a0
    80002ec4:	06090363          	beqz	s2,80002f2a <bmap+0x9a>
    80002ec8:	0524a823          	sw	s2,80(s1)
    80002ecc:	a8b9                	j	80002f2a <bmap+0x9a>
    80002ece:	ff45849b          	addiw	s1,a1,-12
    80002ed2:	0004871b          	sext.w	a4,s1
    80002ed6:	0ff00793          	li	a5,255
    80002eda:	06e7ee63          	bltu	a5,a4,80002f56 <bmap+0xc6>
    80002ede:	08052903          	lw	s2,128(a0)
    80002ee2:	00091d63          	bnez	s2,80002efc <bmap+0x6c>
    80002ee6:	4108                	lw	a0,0(a0)
    80002ee8:	e89ff0ef          	jal	80002d70 <balloc>
    80002eec:	0005091b          	sext.w	s2,a0
    80002ef0:	02090d63          	beqz	s2,80002f2a <bmap+0x9a>
    80002ef4:	e052                	sd	s4,0(sp)
    80002ef6:	0929a023          	sw	s2,128(s3)
    80002efa:	a011                	j	80002efe <bmap+0x6e>
    80002efc:	e052                	sd	s4,0(sp)
    80002efe:	85ca                	mv	a1,s2
    80002f00:	0009a503          	lw	a0,0(s3)
    80002f04:	c09ff0ef          	jal	80002b0c <bread>
    80002f08:	8a2a                	mv	s4,a0
    80002f0a:	05850793          	addi	a5,a0,88
    80002f0e:	02049713          	slli	a4,s1,0x20
    80002f12:	01e75593          	srli	a1,a4,0x1e
    80002f16:	00b784b3          	add	s1,a5,a1
    80002f1a:	0004a903          	lw	s2,0(s1)
    80002f1e:	00090e63          	beqz	s2,80002f3a <bmap+0xaa>
    80002f22:	8552                	mv	a0,s4
    80002f24:	cf1ff0ef          	jal	80002c14 <brelse>
    80002f28:	6a02                	ld	s4,0(sp)
    80002f2a:	854a                	mv	a0,s2
    80002f2c:	70a2                	ld	ra,40(sp)
    80002f2e:	7402                	ld	s0,32(sp)
    80002f30:	64e2                	ld	s1,24(sp)
    80002f32:	6942                	ld	s2,16(sp)
    80002f34:	69a2                	ld	s3,8(sp)
    80002f36:	6145                	addi	sp,sp,48
    80002f38:	8082                	ret
    80002f3a:	0009a503          	lw	a0,0(s3)
    80002f3e:	e33ff0ef          	jal	80002d70 <balloc>
    80002f42:	0005091b          	sext.w	s2,a0
    80002f46:	fc090ee3          	beqz	s2,80002f22 <bmap+0x92>
    80002f4a:	0124a023          	sw	s2,0(s1)
    80002f4e:	8552                	mv	a0,s4
    80002f50:	50f000ef          	jal	80003c5e <log_write>
    80002f54:	b7f9                	j	80002f22 <bmap+0x92>
    80002f56:	e052                	sd	s4,0(sp)
    80002f58:	00004517          	auipc	a0,0x4
    80002f5c:	55050513          	addi	a0,a0,1360 # 800074a8 <etext+0x4a8>
    80002f60:	843fd0ef          	jal	800007a2 <panic>

0000000080002f64 <iget>:
    80002f64:	7179                	addi	sp,sp,-48
    80002f66:	f406                	sd	ra,40(sp)
    80002f68:	f022                	sd	s0,32(sp)
    80002f6a:	ec26                	sd	s1,24(sp)
    80002f6c:	e84a                	sd	s2,16(sp)
    80002f6e:	e44e                	sd	s3,8(sp)
    80002f70:	e052                	sd	s4,0(sp)
    80002f72:	1800                	addi	s0,sp,48
    80002f74:	89aa                	mv	s3,a0
    80002f76:	8a2e                	mv	s4,a1
    80002f78:	0001e517          	auipc	a0,0x1e
    80002f7c:	9c050513          	addi	a0,a0,-1600 # 80020938 <itable>
    80002f80:	c83fd0ef          	jal	80000c02 <acquire>
    80002f84:	4901                	li	s2,0
    80002f86:	0001e497          	auipc	s1,0x1e
    80002f8a:	9ca48493          	addi	s1,s1,-1590 # 80020950 <itable+0x18>
    80002f8e:	0001f697          	auipc	a3,0x1f
    80002f92:	45268693          	addi	a3,a3,1106 # 800223e0 <log>
    80002f96:	a039                	j	80002fa4 <iget+0x40>
    80002f98:	02090963          	beqz	s2,80002fca <iget+0x66>
    80002f9c:	08848493          	addi	s1,s1,136
    80002fa0:	02d48863          	beq	s1,a3,80002fd0 <iget+0x6c>
    80002fa4:	449c                	lw	a5,8(s1)
    80002fa6:	fef059e3          	blez	a5,80002f98 <iget+0x34>
    80002faa:	4098                	lw	a4,0(s1)
    80002fac:	ff3716e3          	bne	a4,s3,80002f98 <iget+0x34>
    80002fb0:	40d8                	lw	a4,4(s1)
    80002fb2:	ff4713e3          	bne	a4,s4,80002f98 <iget+0x34>
    80002fb6:	2785                	addiw	a5,a5,1
    80002fb8:	c49c                	sw	a5,8(s1)
    80002fba:	0001e517          	auipc	a0,0x1e
    80002fbe:	97e50513          	addi	a0,a0,-1666 # 80020938 <itable>
    80002fc2:	cd9fd0ef          	jal	80000c9a <release>
    80002fc6:	8926                	mv	s2,s1
    80002fc8:	a02d                	j	80002ff2 <iget+0x8e>
    80002fca:	fbe9                	bnez	a5,80002f9c <iget+0x38>
    80002fcc:	8926                	mv	s2,s1
    80002fce:	b7f9                	j	80002f9c <iget+0x38>
    80002fd0:	02090a63          	beqz	s2,80003004 <iget+0xa0>
    80002fd4:	01392023          	sw	s3,0(s2)
    80002fd8:	01492223          	sw	s4,4(s2)
    80002fdc:	4785                	li	a5,1
    80002fde:	00f92423          	sw	a5,8(s2)
    80002fe2:	04092023          	sw	zero,64(s2)
    80002fe6:	0001e517          	auipc	a0,0x1e
    80002fea:	95250513          	addi	a0,a0,-1710 # 80020938 <itable>
    80002fee:	cadfd0ef          	jal	80000c9a <release>
    80002ff2:	854a                	mv	a0,s2
    80002ff4:	70a2                	ld	ra,40(sp)
    80002ff6:	7402                	ld	s0,32(sp)
    80002ff8:	64e2                	ld	s1,24(sp)
    80002ffa:	6942                	ld	s2,16(sp)
    80002ffc:	69a2                	ld	s3,8(sp)
    80002ffe:	6a02                	ld	s4,0(sp)
    80003000:	6145                	addi	sp,sp,48
    80003002:	8082                	ret
    80003004:	00004517          	auipc	a0,0x4
    80003008:	4bc50513          	addi	a0,a0,1212 # 800074c0 <etext+0x4c0>
    8000300c:	f96fd0ef          	jal	800007a2 <panic>

0000000080003010 <fsinit>:
    80003010:	7179                	addi	sp,sp,-48
    80003012:	f406                	sd	ra,40(sp)
    80003014:	f022                	sd	s0,32(sp)
    80003016:	ec26                	sd	s1,24(sp)
    80003018:	e84a                	sd	s2,16(sp)
    8000301a:	e44e                	sd	s3,8(sp)
    8000301c:	1800                	addi	s0,sp,48
    8000301e:	892a                	mv	s2,a0
    80003020:	4585                	li	a1,1
    80003022:	aebff0ef          	jal	80002b0c <bread>
    80003026:	84aa                	mv	s1,a0
    80003028:	0001e997          	auipc	s3,0x1e
    8000302c:	8f098993          	addi	s3,s3,-1808 # 80020918 <sb>
    80003030:	02000613          	li	a2,32
    80003034:	05850593          	addi	a1,a0,88
    80003038:	854e                	mv	a0,s3
    8000303a:	cf9fd0ef          	jal	80000d32 <memmove>
    8000303e:	8526                	mv	a0,s1
    80003040:	bd5ff0ef          	jal	80002c14 <brelse>
    80003044:	0009a703          	lw	a4,0(s3)
    80003048:	102037b7          	lui	a5,0x10203
    8000304c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003050:	02f71063          	bne	a4,a5,80003070 <fsinit+0x60>
    80003054:	0001e597          	auipc	a1,0x1e
    80003058:	8c458593          	addi	a1,a1,-1852 # 80020918 <sb>
    8000305c:	854a                	mv	a0,s2
    8000305e:	1f9000ef          	jal	80003a56 <initlog>
    80003062:	70a2                	ld	ra,40(sp)
    80003064:	7402                	ld	s0,32(sp)
    80003066:	64e2                	ld	s1,24(sp)
    80003068:	6942                	ld	s2,16(sp)
    8000306a:	69a2                	ld	s3,8(sp)
    8000306c:	6145                	addi	sp,sp,48
    8000306e:	8082                	ret
    80003070:	00004517          	auipc	a0,0x4
    80003074:	46050513          	addi	a0,a0,1120 # 800074d0 <etext+0x4d0>
    80003078:	f2afd0ef          	jal	800007a2 <panic>

000000008000307c <iinit>:
    8000307c:	7179                	addi	sp,sp,-48
    8000307e:	f406                	sd	ra,40(sp)
    80003080:	f022                	sd	s0,32(sp)
    80003082:	ec26                	sd	s1,24(sp)
    80003084:	e84a                	sd	s2,16(sp)
    80003086:	e44e                	sd	s3,8(sp)
    80003088:	1800                	addi	s0,sp,48
    8000308a:	00004597          	auipc	a1,0x4
    8000308e:	45e58593          	addi	a1,a1,1118 # 800074e8 <etext+0x4e8>
    80003092:	0001e517          	auipc	a0,0x1e
    80003096:	8a650513          	addi	a0,a0,-1882 # 80020938 <itable>
    8000309a:	ae9fd0ef          	jal	80000b82 <initlock>
    8000309e:	0001e497          	auipc	s1,0x1e
    800030a2:	8c248493          	addi	s1,s1,-1854 # 80020960 <itable+0x28>
    800030a6:	0001f997          	auipc	s3,0x1f
    800030aa:	34a98993          	addi	s3,s3,842 # 800223f0 <log+0x10>
    800030ae:	00004917          	auipc	s2,0x4
    800030b2:	44290913          	addi	s2,s2,1090 # 800074f0 <etext+0x4f0>
    800030b6:	85ca                	mv	a1,s2
    800030b8:	8526                	mv	a0,s1
    800030ba:	475000ef          	jal	80003d2e <initsleeplock>
    800030be:	08848493          	addi	s1,s1,136
    800030c2:	ff349ae3          	bne	s1,s3,800030b6 <iinit+0x3a>
    800030c6:	70a2                	ld	ra,40(sp)
    800030c8:	7402                	ld	s0,32(sp)
    800030ca:	64e2                	ld	s1,24(sp)
    800030cc:	6942                	ld	s2,16(sp)
    800030ce:	69a2                	ld	s3,8(sp)
    800030d0:	6145                	addi	sp,sp,48
    800030d2:	8082                	ret

00000000800030d4 <ialloc>:
    800030d4:	7139                	addi	sp,sp,-64
    800030d6:	fc06                	sd	ra,56(sp)
    800030d8:	f822                	sd	s0,48(sp)
    800030da:	0080                	addi	s0,sp,64
    800030dc:	0001e717          	auipc	a4,0x1e
    800030e0:	84872703          	lw	a4,-1976(a4) # 80020924 <sb+0xc>
    800030e4:	4785                	li	a5,1
    800030e6:	06e7f063          	bgeu	a5,a4,80003146 <ialloc+0x72>
    800030ea:	f426                	sd	s1,40(sp)
    800030ec:	f04a                	sd	s2,32(sp)
    800030ee:	ec4e                	sd	s3,24(sp)
    800030f0:	e852                	sd	s4,16(sp)
    800030f2:	e456                	sd	s5,8(sp)
    800030f4:	e05a                	sd	s6,0(sp)
    800030f6:	8aaa                	mv	s5,a0
    800030f8:	8b2e                	mv	s6,a1
    800030fa:	4905                	li	s2,1
    800030fc:	0001ea17          	auipc	s4,0x1e
    80003100:	81ca0a13          	addi	s4,s4,-2020 # 80020918 <sb>
    80003104:	00495593          	srli	a1,s2,0x4
    80003108:	018a2783          	lw	a5,24(s4)
    8000310c:	9dbd                	addw	a1,a1,a5
    8000310e:	8556                	mv	a0,s5
    80003110:	9fdff0ef          	jal	80002b0c <bread>
    80003114:	84aa                	mv	s1,a0
    80003116:	05850993          	addi	s3,a0,88
    8000311a:	00f97793          	andi	a5,s2,15
    8000311e:	079a                	slli	a5,a5,0x6
    80003120:	99be                	add	s3,s3,a5
    80003122:	00099783          	lh	a5,0(s3)
    80003126:	cb9d                	beqz	a5,8000315c <ialloc+0x88>
    80003128:	aedff0ef          	jal	80002c14 <brelse>
    8000312c:	0905                	addi	s2,s2,1
    8000312e:	00ca2703          	lw	a4,12(s4)
    80003132:	0009079b          	sext.w	a5,s2
    80003136:	fce7e7e3          	bltu	a5,a4,80003104 <ialloc+0x30>
    8000313a:	74a2                	ld	s1,40(sp)
    8000313c:	7902                	ld	s2,32(sp)
    8000313e:	69e2                	ld	s3,24(sp)
    80003140:	6a42                	ld	s4,16(sp)
    80003142:	6aa2                	ld	s5,8(sp)
    80003144:	6b02                	ld	s6,0(sp)
    80003146:	00004517          	auipc	a0,0x4
    8000314a:	3b250513          	addi	a0,a0,946 # 800074f8 <etext+0x4f8>
    8000314e:	b82fd0ef          	jal	800004d0 <printf>
    80003152:	4501                	li	a0,0
    80003154:	70e2                	ld	ra,56(sp)
    80003156:	7442                	ld	s0,48(sp)
    80003158:	6121                	addi	sp,sp,64
    8000315a:	8082                	ret
    8000315c:	04000613          	li	a2,64
    80003160:	4581                	li	a1,0
    80003162:	854e                	mv	a0,s3
    80003164:	b73fd0ef          	jal	80000cd6 <memset>
    80003168:	01699023          	sh	s6,0(s3)
    8000316c:	8526                	mv	a0,s1
    8000316e:	2f1000ef          	jal	80003c5e <log_write>
    80003172:	8526                	mv	a0,s1
    80003174:	aa1ff0ef          	jal	80002c14 <brelse>
    80003178:	0009059b          	sext.w	a1,s2
    8000317c:	8556                	mv	a0,s5
    8000317e:	de7ff0ef          	jal	80002f64 <iget>
    80003182:	74a2                	ld	s1,40(sp)
    80003184:	7902                	ld	s2,32(sp)
    80003186:	69e2                	ld	s3,24(sp)
    80003188:	6a42                	ld	s4,16(sp)
    8000318a:	6aa2                	ld	s5,8(sp)
    8000318c:	6b02                	ld	s6,0(sp)
    8000318e:	b7d9                	j	80003154 <ialloc+0x80>

0000000080003190 <iupdate>:
    80003190:	1101                	addi	sp,sp,-32
    80003192:	ec06                	sd	ra,24(sp)
    80003194:	e822                	sd	s0,16(sp)
    80003196:	e426                	sd	s1,8(sp)
    80003198:	e04a                	sd	s2,0(sp)
    8000319a:	1000                	addi	s0,sp,32
    8000319c:	84aa                	mv	s1,a0
    8000319e:	415c                	lw	a5,4(a0)
    800031a0:	0047d79b          	srliw	a5,a5,0x4
    800031a4:	0001d597          	auipc	a1,0x1d
    800031a8:	78c5a583          	lw	a1,1932(a1) # 80020930 <sb+0x18>
    800031ac:	9dbd                	addw	a1,a1,a5
    800031ae:	4108                	lw	a0,0(a0)
    800031b0:	95dff0ef          	jal	80002b0c <bread>
    800031b4:	892a                	mv	s2,a0
    800031b6:	05850793          	addi	a5,a0,88
    800031ba:	40d8                	lw	a4,4(s1)
    800031bc:	8b3d                	andi	a4,a4,15
    800031be:	071a                	slli	a4,a4,0x6
    800031c0:	97ba                	add	a5,a5,a4
    800031c2:	04449703          	lh	a4,68(s1)
    800031c6:	00e79023          	sh	a4,0(a5)
    800031ca:	04649703          	lh	a4,70(s1)
    800031ce:	00e79123          	sh	a4,2(a5)
    800031d2:	04849703          	lh	a4,72(s1)
    800031d6:	00e79223          	sh	a4,4(a5)
    800031da:	04a49703          	lh	a4,74(s1)
    800031de:	00e79323          	sh	a4,6(a5)
    800031e2:	44f8                	lw	a4,76(s1)
    800031e4:	c798                	sw	a4,8(a5)
    800031e6:	03400613          	li	a2,52
    800031ea:	05048593          	addi	a1,s1,80
    800031ee:	00c78513          	addi	a0,a5,12
    800031f2:	b41fd0ef          	jal	80000d32 <memmove>
    800031f6:	854a                	mv	a0,s2
    800031f8:	267000ef          	jal	80003c5e <log_write>
    800031fc:	854a                	mv	a0,s2
    800031fe:	a17ff0ef          	jal	80002c14 <brelse>
    80003202:	60e2                	ld	ra,24(sp)
    80003204:	6442                	ld	s0,16(sp)
    80003206:	64a2                	ld	s1,8(sp)
    80003208:	6902                	ld	s2,0(sp)
    8000320a:	6105                	addi	sp,sp,32
    8000320c:	8082                	ret

000000008000320e <idup>:
    8000320e:	1101                	addi	sp,sp,-32
    80003210:	ec06                	sd	ra,24(sp)
    80003212:	e822                	sd	s0,16(sp)
    80003214:	e426                	sd	s1,8(sp)
    80003216:	1000                	addi	s0,sp,32
    80003218:	84aa                	mv	s1,a0
    8000321a:	0001d517          	auipc	a0,0x1d
    8000321e:	71e50513          	addi	a0,a0,1822 # 80020938 <itable>
    80003222:	9e1fd0ef          	jal	80000c02 <acquire>
    80003226:	449c                	lw	a5,8(s1)
    80003228:	2785                	addiw	a5,a5,1
    8000322a:	c49c                	sw	a5,8(s1)
    8000322c:	0001d517          	auipc	a0,0x1d
    80003230:	70c50513          	addi	a0,a0,1804 # 80020938 <itable>
    80003234:	a67fd0ef          	jal	80000c9a <release>
    80003238:	8526                	mv	a0,s1
    8000323a:	60e2                	ld	ra,24(sp)
    8000323c:	6442                	ld	s0,16(sp)
    8000323e:	64a2                	ld	s1,8(sp)
    80003240:	6105                	addi	sp,sp,32
    80003242:	8082                	ret

0000000080003244 <ilock>:
    80003244:	1101                	addi	sp,sp,-32
    80003246:	ec06                	sd	ra,24(sp)
    80003248:	e822                	sd	s0,16(sp)
    8000324a:	e426                	sd	s1,8(sp)
    8000324c:	1000                	addi	s0,sp,32
    8000324e:	cd19                	beqz	a0,8000326c <ilock+0x28>
    80003250:	84aa                	mv	s1,a0
    80003252:	451c                	lw	a5,8(a0)
    80003254:	00f05c63          	blez	a5,8000326c <ilock+0x28>
    80003258:	0541                	addi	a0,a0,16
    8000325a:	30b000ef          	jal	80003d64 <acquiresleep>
    8000325e:	40bc                	lw	a5,64(s1)
    80003260:	cf89                	beqz	a5,8000327a <ilock+0x36>
    80003262:	60e2                	ld	ra,24(sp)
    80003264:	6442                	ld	s0,16(sp)
    80003266:	64a2                	ld	s1,8(sp)
    80003268:	6105                	addi	sp,sp,32
    8000326a:	8082                	ret
    8000326c:	e04a                	sd	s2,0(sp)
    8000326e:	00004517          	auipc	a0,0x4
    80003272:	2a250513          	addi	a0,a0,674 # 80007510 <etext+0x510>
    80003276:	d2cfd0ef          	jal	800007a2 <panic>
    8000327a:	e04a                	sd	s2,0(sp)
    8000327c:	40dc                	lw	a5,4(s1)
    8000327e:	0047d79b          	srliw	a5,a5,0x4
    80003282:	0001d597          	auipc	a1,0x1d
    80003286:	6ae5a583          	lw	a1,1710(a1) # 80020930 <sb+0x18>
    8000328a:	9dbd                	addw	a1,a1,a5
    8000328c:	4088                	lw	a0,0(s1)
    8000328e:	87fff0ef          	jal	80002b0c <bread>
    80003292:	892a                	mv	s2,a0
    80003294:	05850593          	addi	a1,a0,88
    80003298:	40dc                	lw	a5,4(s1)
    8000329a:	8bbd                	andi	a5,a5,15
    8000329c:	079a                	slli	a5,a5,0x6
    8000329e:	95be                	add	a1,a1,a5
    800032a0:	00059783          	lh	a5,0(a1)
    800032a4:	04f49223          	sh	a5,68(s1)
    800032a8:	00259783          	lh	a5,2(a1)
    800032ac:	04f49323          	sh	a5,70(s1)
    800032b0:	00459783          	lh	a5,4(a1)
    800032b4:	04f49423          	sh	a5,72(s1)
    800032b8:	00659783          	lh	a5,6(a1)
    800032bc:	04f49523          	sh	a5,74(s1)
    800032c0:	459c                	lw	a5,8(a1)
    800032c2:	c4fc                	sw	a5,76(s1)
    800032c4:	03400613          	li	a2,52
    800032c8:	05b1                	addi	a1,a1,12
    800032ca:	05048513          	addi	a0,s1,80
    800032ce:	a65fd0ef          	jal	80000d32 <memmove>
    800032d2:	854a                	mv	a0,s2
    800032d4:	941ff0ef          	jal	80002c14 <brelse>
    800032d8:	4785                	li	a5,1
    800032da:	c0bc                	sw	a5,64(s1)
    800032dc:	04449783          	lh	a5,68(s1)
    800032e0:	c399                	beqz	a5,800032e6 <ilock+0xa2>
    800032e2:	6902                	ld	s2,0(sp)
    800032e4:	bfbd                	j	80003262 <ilock+0x1e>
    800032e6:	00004517          	auipc	a0,0x4
    800032ea:	23250513          	addi	a0,a0,562 # 80007518 <etext+0x518>
    800032ee:	cb4fd0ef          	jal	800007a2 <panic>

00000000800032f2 <iunlock>:
    800032f2:	1101                	addi	sp,sp,-32
    800032f4:	ec06                	sd	ra,24(sp)
    800032f6:	e822                	sd	s0,16(sp)
    800032f8:	e426                	sd	s1,8(sp)
    800032fa:	e04a                	sd	s2,0(sp)
    800032fc:	1000                	addi	s0,sp,32
    800032fe:	c505                	beqz	a0,80003326 <iunlock+0x34>
    80003300:	84aa                	mv	s1,a0
    80003302:	01050913          	addi	s2,a0,16
    80003306:	854a                	mv	a0,s2
    80003308:	2db000ef          	jal	80003de2 <holdingsleep>
    8000330c:	cd09                	beqz	a0,80003326 <iunlock+0x34>
    8000330e:	449c                	lw	a5,8(s1)
    80003310:	00f05b63          	blez	a5,80003326 <iunlock+0x34>
    80003314:	854a                	mv	a0,s2
    80003316:	295000ef          	jal	80003daa <releasesleep>
    8000331a:	60e2                	ld	ra,24(sp)
    8000331c:	6442                	ld	s0,16(sp)
    8000331e:	64a2                	ld	s1,8(sp)
    80003320:	6902                	ld	s2,0(sp)
    80003322:	6105                	addi	sp,sp,32
    80003324:	8082                	ret
    80003326:	00004517          	auipc	a0,0x4
    8000332a:	20250513          	addi	a0,a0,514 # 80007528 <etext+0x528>
    8000332e:	c74fd0ef          	jal	800007a2 <panic>

0000000080003332 <itrunc>:
    80003332:	7179                	addi	sp,sp,-48
    80003334:	f406                	sd	ra,40(sp)
    80003336:	f022                	sd	s0,32(sp)
    80003338:	ec26                	sd	s1,24(sp)
    8000333a:	e84a                	sd	s2,16(sp)
    8000333c:	e44e                	sd	s3,8(sp)
    8000333e:	1800                	addi	s0,sp,48
    80003340:	89aa                	mv	s3,a0
    80003342:	05050493          	addi	s1,a0,80
    80003346:	08050913          	addi	s2,a0,128
    8000334a:	a021                	j	80003352 <itrunc+0x20>
    8000334c:	0491                	addi	s1,s1,4
    8000334e:	01248b63          	beq	s1,s2,80003364 <itrunc+0x32>
    80003352:	408c                	lw	a1,0(s1)
    80003354:	dde5                	beqz	a1,8000334c <itrunc+0x1a>
    80003356:	0009a503          	lw	a0,0(s3)
    8000335a:	9abff0ef          	jal	80002d04 <bfree>
    8000335e:	0004a023          	sw	zero,0(s1)
    80003362:	b7ed                	j	8000334c <itrunc+0x1a>
    80003364:	0809a583          	lw	a1,128(s3)
    80003368:	ed89                	bnez	a1,80003382 <itrunc+0x50>
    8000336a:	0409a623          	sw	zero,76(s3)
    8000336e:	854e                	mv	a0,s3
    80003370:	e21ff0ef          	jal	80003190 <iupdate>
    80003374:	70a2                	ld	ra,40(sp)
    80003376:	7402                	ld	s0,32(sp)
    80003378:	64e2                	ld	s1,24(sp)
    8000337a:	6942                	ld	s2,16(sp)
    8000337c:	69a2                	ld	s3,8(sp)
    8000337e:	6145                	addi	sp,sp,48
    80003380:	8082                	ret
    80003382:	e052                	sd	s4,0(sp)
    80003384:	0009a503          	lw	a0,0(s3)
    80003388:	f84ff0ef          	jal	80002b0c <bread>
    8000338c:	8a2a                	mv	s4,a0
    8000338e:	05850493          	addi	s1,a0,88
    80003392:	45850913          	addi	s2,a0,1112
    80003396:	a021                	j	8000339e <itrunc+0x6c>
    80003398:	0491                	addi	s1,s1,4
    8000339a:	01248963          	beq	s1,s2,800033ac <itrunc+0x7a>
    8000339e:	408c                	lw	a1,0(s1)
    800033a0:	dde5                	beqz	a1,80003398 <itrunc+0x66>
    800033a2:	0009a503          	lw	a0,0(s3)
    800033a6:	95fff0ef          	jal	80002d04 <bfree>
    800033aa:	b7fd                	j	80003398 <itrunc+0x66>
    800033ac:	8552                	mv	a0,s4
    800033ae:	867ff0ef          	jal	80002c14 <brelse>
    800033b2:	0809a583          	lw	a1,128(s3)
    800033b6:	0009a503          	lw	a0,0(s3)
    800033ba:	94bff0ef          	jal	80002d04 <bfree>
    800033be:	0809a023          	sw	zero,128(s3)
    800033c2:	6a02                	ld	s4,0(sp)
    800033c4:	b75d                	j	8000336a <itrunc+0x38>

00000000800033c6 <iput>:
    800033c6:	1101                	addi	sp,sp,-32
    800033c8:	ec06                	sd	ra,24(sp)
    800033ca:	e822                	sd	s0,16(sp)
    800033cc:	e426                	sd	s1,8(sp)
    800033ce:	1000                	addi	s0,sp,32
    800033d0:	84aa                	mv	s1,a0
    800033d2:	0001d517          	auipc	a0,0x1d
    800033d6:	56650513          	addi	a0,a0,1382 # 80020938 <itable>
    800033da:	829fd0ef          	jal	80000c02 <acquire>
    800033de:	4498                	lw	a4,8(s1)
    800033e0:	4785                	li	a5,1
    800033e2:	02f70063          	beq	a4,a5,80003402 <iput+0x3c>
    800033e6:	449c                	lw	a5,8(s1)
    800033e8:	37fd                	addiw	a5,a5,-1
    800033ea:	c49c                	sw	a5,8(s1)
    800033ec:	0001d517          	auipc	a0,0x1d
    800033f0:	54c50513          	addi	a0,a0,1356 # 80020938 <itable>
    800033f4:	8a7fd0ef          	jal	80000c9a <release>
    800033f8:	60e2                	ld	ra,24(sp)
    800033fa:	6442                	ld	s0,16(sp)
    800033fc:	64a2                	ld	s1,8(sp)
    800033fe:	6105                	addi	sp,sp,32
    80003400:	8082                	ret
    80003402:	40bc                	lw	a5,64(s1)
    80003404:	d3ed                	beqz	a5,800033e6 <iput+0x20>
    80003406:	04a49783          	lh	a5,74(s1)
    8000340a:	fff1                	bnez	a5,800033e6 <iput+0x20>
    8000340c:	e04a                	sd	s2,0(sp)
    8000340e:	01048913          	addi	s2,s1,16
    80003412:	854a                	mv	a0,s2
    80003414:	151000ef          	jal	80003d64 <acquiresleep>
    80003418:	0001d517          	auipc	a0,0x1d
    8000341c:	52050513          	addi	a0,a0,1312 # 80020938 <itable>
    80003420:	87bfd0ef          	jal	80000c9a <release>
    80003424:	8526                	mv	a0,s1
    80003426:	f0dff0ef          	jal	80003332 <itrunc>
    8000342a:	04049223          	sh	zero,68(s1)
    8000342e:	8526                	mv	a0,s1
    80003430:	d61ff0ef          	jal	80003190 <iupdate>
    80003434:	0404a023          	sw	zero,64(s1)
    80003438:	854a                	mv	a0,s2
    8000343a:	171000ef          	jal	80003daa <releasesleep>
    8000343e:	0001d517          	auipc	a0,0x1d
    80003442:	4fa50513          	addi	a0,a0,1274 # 80020938 <itable>
    80003446:	fbcfd0ef          	jal	80000c02 <acquire>
    8000344a:	6902                	ld	s2,0(sp)
    8000344c:	bf69                	j	800033e6 <iput+0x20>

000000008000344e <iunlockput>:
    8000344e:	1101                	addi	sp,sp,-32
    80003450:	ec06                	sd	ra,24(sp)
    80003452:	e822                	sd	s0,16(sp)
    80003454:	e426                	sd	s1,8(sp)
    80003456:	1000                	addi	s0,sp,32
    80003458:	84aa                	mv	s1,a0
    8000345a:	e99ff0ef          	jal	800032f2 <iunlock>
    8000345e:	8526                	mv	a0,s1
    80003460:	f67ff0ef          	jal	800033c6 <iput>
    80003464:	60e2                	ld	ra,24(sp)
    80003466:	6442                	ld	s0,16(sp)
    80003468:	64a2                	ld	s1,8(sp)
    8000346a:	6105                	addi	sp,sp,32
    8000346c:	8082                	ret

000000008000346e <stati>:
    8000346e:	1141                	addi	sp,sp,-16
    80003470:	e422                	sd	s0,8(sp)
    80003472:	0800                	addi	s0,sp,16
    80003474:	411c                	lw	a5,0(a0)
    80003476:	c19c                	sw	a5,0(a1)
    80003478:	415c                	lw	a5,4(a0)
    8000347a:	c1dc                	sw	a5,4(a1)
    8000347c:	04451783          	lh	a5,68(a0)
    80003480:	00f59423          	sh	a5,8(a1)
    80003484:	04a51783          	lh	a5,74(a0)
    80003488:	00f59523          	sh	a5,10(a1)
    8000348c:	04c56783          	lwu	a5,76(a0)
    80003490:	e99c                	sd	a5,16(a1)
    80003492:	6422                	ld	s0,8(sp)
    80003494:	0141                	addi	sp,sp,16
    80003496:	8082                	ret

0000000080003498 <readi>:
    80003498:	457c                	lw	a5,76(a0)
    8000349a:	0ed7eb63          	bltu	a5,a3,80003590 <readi+0xf8>
    8000349e:	7159                	addi	sp,sp,-112
    800034a0:	f486                	sd	ra,104(sp)
    800034a2:	f0a2                	sd	s0,96(sp)
    800034a4:	eca6                	sd	s1,88(sp)
    800034a6:	e0d2                	sd	s4,64(sp)
    800034a8:	fc56                	sd	s5,56(sp)
    800034aa:	f85a                	sd	s6,48(sp)
    800034ac:	f45e                	sd	s7,40(sp)
    800034ae:	1880                	addi	s0,sp,112
    800034b0:	8b2a                	mv	s6,a0
    800034b2:	8bae                	mv	s7,a1
    800034b4:	8a32                	mv	s4,a2
    800034b6:	84b6                	mv	s1,a3
    800034b8:	8aba                	mv	s5,a4
    800034ba:	9f35                	addw	a4,a4,a3
    800034bc:	4501                	li	a0,0
    800034be:	0cd76063          	bltu	a4,a3,8000357e <readi+0xe6>
    800034c2:	e4ce                	sd	s3,72(sp)
    800034c4:	00e7f463          	bgeu	a5,a4,800034cc <readi+0x34>
    800034c8:	40d78abb          	subw	s5,a5,a3
    800034cc:	080a8f63          	beqz	s5,8000356a <readi+0xd2>
    800034d0:	e8ca                	sd	s2,80(sp)
    800034d2:	f062                	sd	s8,32(sp)
    800034d4:	ec66                	sd	s9,24(sp)
    800034d6:	e86a                	sd	s10,16(sp)
    800034d8:	e46e                	sd	s11,8(sp)
    800034da:	4981                	li	s3,0
    800034dc:	40000c93          	li	s9,1024
    800034e0:	5c7d                	li	s8,-1
    800034e2:	a80d                	j	80003514 <readi+0x7c>
    800034e4:	020d1d93          	slli	s11,s10,0x20
    800034e8:	020ddd93          	srli	s11,s11,0x20
    800034ec:	05890613          	addi	a2,s2,88
    800034f0:	86ee                	mv	a3,s11
    800034f2:	963a                	add	a2,a2,a4
    800034f4:	85d2                	mv	a1,s4
    800034f6:	855e                	mv	a0,s7
    800034f8:	d33fe0ef          	jal	8000222a <either_copyout>
    800034fc:	05850763          	beq	a0,s8,8000354a <readi+0xb2>
    80003500:	854a                	mv	a0,s2
    80003502:	f12ff0ef          	jal	80002c14 <brelse>
    80003506:	013d09bb          	addw	s3,s10,s3
    8000350a:	009d04bb          	addw	s1,s10,s1
    8000350e:	9a6e                	add	s4,s4,s11
    80003510:	0559f763          	bgeu	s3,s5,8000355e <readi+0xc6>
    80003514:	00a4d59b          	srliw	a1,s1,0xa
    80003518:	855a                	mv	a0,s6
    8000351a:	977ff0ef          	jal	80002e90 <bmap>
    8000351e:	0005059b          	sext.w	a1,a0
    80003522:	c5b1                	beqz	a1,8000356e <readi+0xd6>
    80003524:	000b2503          	lw	a0,0(s6)
    80003528:	de4ff0ef          	jal	80002b0c <bread>
    8000352c:	892a                	mv	s2,a0
    8000352e:	3ff4f713          	andi	a4,s1,1023
    80003532:	40ec87bb          	subw	a5,s9,a4
    80003536:	413a86bb          	subw	a3,s5,s3
    8000353a:	8d3e                	mv	s10,a5
    8000353c:	2781                	sext.w	a5,a5
    8000353e:	0006861b          	sext.w	a2,a3
    80003542:	faf671e3          	bgeu	a2,a5,800034e4 <readi+0x4c>
    80003546:	8d36                	mv	s10,a3
    80003548:	bf71                	j	800034e4 <readi+0x4c>
    8000354a:	854a                	mv	a0,s2
    8000354c:	ec8ff0ef          	jal	80002c14 <brelse>
    80003550:	59fd                	li	s3,-1
    80003552:	6946                	ld	s2,80(sp)
    80003554:	7c02                	ld	s8,32(sp)
    80003556:	6ce2                	ld	s9,24(sp)
    80003558:	6d42                	ld	s10,16(sp)
    8000355a:	6da2                	ld	s11,8(sp)
    8000355c:	a831                	j	80003578 <readi+0xe0>
    8000355e:	6946                	ld	s2,80(sp)
    80003560:	7c02                	ld	s8,32(sp)
    80003562:	6ce2                	ld	s9,24(sp)
    80003564:	6d42                	ld	s10,16(sp)
    80003566:	6da2                	ld	s11,8(sp)
    80003568:	a801                	j	80003578 <readi+0xe0>
    8000356a:	89d6                	mv	s3,s5
    8000356c:	a031                	j	80003578 <readi+0xe0>
    8000356e:	6946                	ld	s2,80(sp)
    80003570:	7c02                	ld	s8,32(sp)
    80003572:	6ce2                	ld	s9,24(sp)
    80003574:	6d42                	ld	s10,16(sp)
    80003576:	6da2                	ld	s11,8(sp)
    80003578:	0009851b          	sext.w	a0,s3
    8000357c:	69a6                	ld	s3,72(sp)
    8000357e:	70a6                	ld	ra,104(sp)
    80003580:	7406                	ld	s0,96(sp)
    80003582:	64e6                	ld	s1,88(sp)
    80003584:	6a06                	ld	s4,64(sp)
    80003586:	7ae2                	ld	s5,56(sp)
    80003588:	7b42                	ld	s6,48(sp)
    8000358a:	7ba2                	ld	s7,40(sp)
    8000358c:	6165                	addi	sp,sp,112
    8000358e:	8082                	ret
    80003590:	4501                	li	a0,0
    80003592:	8082                	ret

0000000080003594 <writei>:
    80003594:	457c                	lw	a5,76(a0)
    80003596:	10d7e063          	bltu	a5,a3,80003696 <writei+0x102>
    8000359a:	7159                	addi	sp,sp,-112
    8000359c:	f486                	sd	ra,104(sp)
    8000359e:	f0a2                	sd	s0,96(sp)
    800035a0:	e8ca                	sd	s2,80(sp)
    800035a2:	e0d2                	sd	s4,64(sp)
    800035a4:	fc56                	sd	s5,56(sp)
    800035a6:	f85a                	sd	s6,48(sp)
    800035a8:	f45e                	sd	s7,40(sp)
    800035aa:	1880                	addi	s0,sp,112
    800035ac:	8aaa                	mv	s5,a0
    800035ae:	8bae                	mv	s7,a1
    800035b0:	8a32                	mv	s4,a2
    800035b2:	8936                	mv	s2,a3
    800035b4:	8b3a                	mv	s6,a4
    800035b6:	00e687bb          	addw	a5,a3,a4
    800035ba:	0ed7e063          	bltu	a5,a3,8000369a <writei+0x106>
    800035be:	00043737          	lui	a4,0x43
    800035c2:	0cf76e63          	bltu	a4,a5,8000369e <writei+0x10a>
    800035c6:	e4ce                	sd	s3,72(sp)
    800035c8:	0a0b0f63          	beqz	s6,80003686 <writei+0xf2>
    800035cc:	eca6                	sd	s1,88(sp)
    800035ce:	f062                	sd	s8,32(sp)
    800035d0:	ec66                	sd	s9,24(sp)
    800035d2:	e86a                	sd	s10,16(sp)
    800035d4:	e46e                	sd	s11,8(sp)
    800035d6:	4981                	li	s3,0
    800035d8:	40000c93          	li	s9,1024
    800035dc:	5c7d                	li	s8,-1
    800035de:	a825                	j	80003616 <writei+0x82>
    800035e0:	020d1d93          	slli	s11,s10,0x20
    800035e4:	020ddd93          	srli	s11,s11,0x20
    800035e8:	05848513          	addi	a0,s1,88
    800035ec:	86ee                	mv	a3,s11
    800035ee:	8652                	mv	a2,s4
    800035f0:	85de                	mv	a1,s7
    800035f2:	953a                	add	a0,a0,a4
    800035f4:	c81fe0ef          	jal	80002274 <either_copyin>
    800035f8:	05850a63          	beq	a0,s8,8000364c <writei+0xb8>
    800035fc:	8526                	mv	a0,s1
    800035fe:	660000ef          	jal	80003c5e <log_write>
    80003602:	8526                	mv	a0,s1
    80003604:	e10ff0ef          	jal	80002c14 <brelse>
    80003608:	013d09bb          	addw	s3,s10,s3
    8000360c:	012d093b          	addw	s2,s10,s2
    80003610:	9a6e                	add	s4,s4,s11
    80003612:	0569f063          	bgeu	s3,s6,80003652 <writei+0xbe>
    80003616:	00a9559b          	srliw	a1,s2,0xa
    8000361a:	8556                	mv	a0,s5
    8000361c:	875ff0ef          	jal	80002e90 <bmap>
    80003620:	0005059b          	sext.w	a1,a0
    80003624:	c59d                	beqz	a1,80003652 <writei+0xbe>
    80003626:	000aa503          	lw	a0,0(s5)
    8000362a:	ce2ff0ef          	jal	80002b0c <bread>
    8000362e:	84aa                	mv	s1,a0
    80003630:	3ff97713          	andi	a4,s2,1023
    80003634:	40ec87bb          	subw	a5,s9,a4
    80003638:	413b06bb          	subw	a3,s6,s3
    8000363c:	8d3e                	mv	s10,a5
    8000363e:	2781                	sext.w	a5,a5
    80003640:	0006861b          	sext.w	a2,a3
    80003644:	f8f67ee3          	bgeu	a2,a5,800035e0 <writei+0x4c>
    80003648:	8d36                	mv	s10,a3
    8000364a:	bf59                	j	800035e0 <writei+0x4c>
    8000364c:	8526                	mv	a0,s1
    8000364e:	dc6ff0ef          	jal	80002c14 <brelse>
    80003652:	04caa783          	lw	a5,76(s5)
    80003656:	0327fa63          	bgeu	a5,s2,8000368a <writei+0xf6>
    8000365a:	052aa623          	sw	s2,76(s5)
    8000365e:	64e6                	ld	s1,88(sp)
    80003660:	7c02                	ld	s8,32(sp)
    80003662:	6ce2                	ld	s9,24(sp)
    80003664:	6d42                	ld	s10,16(sp)
    80003666:	6da2                	ld	s11,8(sp)
    80003668:	8556                	mv	a0,s5
    8000366a:	b27ff0ef          	jal	80003190 <iupdate>
    8000366e:	0009851b          	sext.w	a0,s3
    80003672:	69a6                	ld	s3,72(sp)
    80003674:	70a6                	ld	ra,104(sp)
    80003676:	7406                	ld	s0,96(sp)
    80003678:	6946                	ld	s2,80(sp)
    8000367a:	6a06                	ld	s4,64(sp)
    8000367c:	7ae2                	ld	s5,56(sp)
    8000367e:	7b42                	ld	s6,48(sp)
    80003680:	7ba2                	ld	s7,40(sp)
    80003682:	6165                	addi	sp,sp,112
    80003684:	8082                	ret
    80003686:	89da                	mv	s3,s6
    80003688:	b7c5                	j	80003668 <writei+0xd4>
    8000368a:	64e6                	ld	s1,88(sp)
    8000368c:	7c02                	ld	s8,32(sp)
    8000368e:	6ce2                	ld	s9,24(sp)
    80003690:	6d42                	ld	s10,16(sp)
    80003692:	6da2                	ld	s11,8(sp)
    80003694:	bfd1                	j	80003668 <writei+0xd4>
    80003696:	557d                	li	a0,-1
    80003698:	8082                	ret
    8000369a:	557d                	li	a0,-1
    8000369c:	bfe1                	j	80003674 <writei+0xe0>
    8000369e:	557d                	li	a0,-1
    800036a0:	bfd1                	j	80003674 <writei+0xe0>

00000000800036a2 <namecmp>:
    800036a2:	1141                	addi	sp,sp,-16
    800036a4:	e406                	sd	ra,8(sp)
    800036a6:	e022                	sd	s0,0(sp)
    800036a8:	0800                	addi	s0,sp,16
    800036aa:	4639                	li	a2,14
    800036ac:	ef6fd0ef          	jal	80000da2 <strncmp>
    800036b0:	60a2                	ld	ra,8(sp)
    800036b2:	6402                	ld	s0,0(sp)
    800036b4:	0141                	addi	sp,sp,16
    800036b6:	8082                	ret

00000000800036b8 <dirlookup>:
    800036b8:	7139                	addi	sp,sp,-64
    800036ba:	fc06                	sd	ra,56(sp)
    800036bc:	f822                	sd	s0,48(sp)
    800036be:	f426                	sd	s1,40(sp)
    800036c0:	f04a                	sd	s2,32(sp)
    800036c2:	ec4e                	sd	s3,24(sp)
    800036c4:	e852                	sd	s4,16(sp)
    800036c6:	0080                	addi	s0,sp,64
    800036c8:	04451703          	lh	a4,68(a0)
    800036cc:	4785                	li	a5,1
    800036ce:	00f71a63          	bne	a4,a5,800036e2 <dirlookup+0x2a>
    800036d2:	892a                	mv	s2,a0
    800036d4:	89ae                	mv	s3,a1
    800036d6:	8a32                	mv	s4,a2
    800036d8:	457c                	lw	a5,76(a0)
    800036da:	4481                	li	s1,0
    800036dc:	4501                	li	a0,0
    800036de:	e39d                	bnez	a5,80003704 <dirlookup+0x4c>
    800036e0:	a095                	j	80003744 <dirlookup+0x8c>
    800036e2:	00004517          	auipc	a0,0x4
    800036e6:	e4e50513          	addi	a0,a0,-434 # 80007530 <etext+0x530>
    800036ea:	8b8fd0ef          	jal	800007a2 <panic>
    800036ee:	00004517          	auipc	a0,0x4
    800036f2:	e5a50513          	addi	a0,a0,-422 # 80007548 <etext+0x548>
    800036f6:	8acfd0ef          	jal	800007a2 <panic>
    800036fa:	24c1                	addiw	s1,s1,16
    800036fc:	04c92783          	lw	a5,76(s2)
    80003700:	04f4f163          	bgeu	s1,a5,80003742 <dirlookup+0x8a>
    80003704:	4741                	li	a4,16
    80003706:	86a6                	mv	a3,s1
    80003708:	fc040613          	addi	a2,s0,-64
    8000370c:	4581                	li	a1,0
    8000370e:	854a                	mv	a0,s2
    80003710:	d89ff0ef          	jal	80003498 <readi>
    80003714:	47c1                	li	a5,16
    80003716:	fcf51ce3          	bne	a0,a5,800036ee <dirlookup+0x36>
    8000371a:	fc045783          	lhu	a5,-64(s0)
    8000371e:	dff1                	beqz	a5,800036fa <dirlookup+0x42>
    80003720:	fc240593          	addi	a1,s0,-62
    80003724:	854e                	mv	a0,s3
    80003726:	f7dff0ef          	jal	800036a2 <namecmp>
    8000372a:	f961                	bnez	a0,800036fa <dirlookup+0x42>
    8000372c:	000a0463          	beqz	s4,80003734 <dirlookup+0x7c>
    80003730:	009a2023          	sw	s1,0(s4)
    80003734:	fc045583          	lhu	a1,-64(s0)
    80003738:	00092503          	lw	a0,0(s2)
    8000373c:	829ff0ef          	jal	80002f64 <iget>
    80003740:	a011                	j	80003744 <dirlookup+0x8c>
    80003742:	4501                	li	a0,0
    80003744:	70e2                	ld	ra,56(sp)
    80003746:	7442                	ld	s0,48(sp)
    80003748:	74a2                	ld	s1,40(sp)
    8000374a:	7902                	ld	s2,32(sp)
    8000374c:	69e2                	ld	s3,24(sp)
    8000374e:	6a42                	ld	s4,16(sp)
    80003750:	6121                	addi	sp,sp,64
    80003752:	8082                	ret

0000000080003754 <namex>:
    80003754:	711d                	addi	sp,sp,-96
    80003756:	ec86                	sd	ra,88(sp)
    80003758:	e8a2                	sd	s0,80(sp)
    8000375a:	e4a6                	sd	s1,72(sp)
    8000375c:	e0ca                	sd	s2,64(sp)
    8000375e:	fc4e                	sd	s3,56(sp)
    80003760:	f852                	sd	s4,48(sp)
    80003762:	f456                	sd	s5,40(sp)
    80003764:	f05a                	sd	s6,32(sp)
    80003766:	ec5e                	sd	s7,24(sp)
    80003768:	e862                	sd	s8,16(sp)
    8000376a:	e466                	sd	s9,8(sp)
    8000376c:	1080                	addi	s0,sp,96
    8000376e:	84aa                	mv	s1,a0
    80003770:	8b2e                	mv	s6,a1
    80003772:	8ab2                	mv	s5,a2
    80003774:	00054703          	lbu	a4,0(a0)
    80003778:	02f00793          	li	a5,47
    8000377c:	00f70e63          	beq	a4,a5,80003798 <namex+0x44>
    80003780:	980fe0ef          	jal	80001900 <myproc>
    80003784:	15053503          	ld	a0,336(a0)
    80003788:	a87ff0ef          	jal	8000320e <idup>
    8000378c:	8a2a                	mv	s4,a0
    8000378e:	02f00913          	li	s2,47
    80003792:	4c35                	li	s8,13
    80003794:	4b85                	li	s7,1
    80003796:	a871                	j	80003832 <namex+0xde>
    80003798:	4585                	li	a1,1
    8000379a:	4505                	li	a0,1
    8000379c:	fc8ff0ef          	jal	80002f64 <iget>
    800037a0:	8a2a                	mv	s4,a0
    800037a2:	b7f5                	j	8000378e <namex+0x3a>
    800037a4:	8552                	mv	a0,s4
    800037a6:	ca9ff0ef          	jal	8000344e <iunlockput>
    800037aa:	4a01                	li	s4,0
    800037ac:	8552                	mv	a0,s4
    800037ae:	60e6                	ld	ra,88(sp)
    800037b0:	6446                	ld	s0,80(sp)
    800037b2:	64a6                	ld	s1,72(sp)
    800037b4:	6906                	ld	s2,64(sp)
    800037b6:	79e2                	ld	s3,56(sp)
    800037b8:	7a42                	ld	s4,48(sp)
    800037ba:	7aa2                	ld	s5,40(sp)
    800037bc:	7b02                	ld	s6,32(sp)
    800037be:	6be2                	ld	s7,24(sp)
    800037c0:	6c42                	ld	s8,16(sp)
    800037c2:	6ca2                	ld	s9,8(sp)
    800037c4:	6125                	addi	sp,sp,96
    800037c6:	8082                	ret
    800037c8:	8552                	mv	a0,s4
    800037ca:	b29ff0ef          	jal	800032f2 <iunlock>
    800037ce:	bff9                	j	800037ac <namex+0x58>
    800037d0:	8552                	mv	a0,s4
    800037d2:	c7dff0ef          	jal	8000344e <iunlockput>
    800037d6:	8a4e                	mv	s4,s3
    800037d8:	bfd1                	j	800037ac <namex+0x58>
    800037da:	40998633          	sub	a2,s3,s1
    800037de:	00060c9b          	sext.w	s9,a2
    800037e2:	099c5063          	bge	s8,s9,80003862 <namex+0x10e>
    800037e6:	4639                	li	a2,14
    800037e8:	85a6                	mv	a1,s1
    800037ea:	8556                	mv	a0,s5
    800037ec:	d46fd0ef          	jal	80000d32 <memmove>
    800037f0:	84ce                	mv	s1,s3
    800037f2:	0004c783          	lbu	a5,0(s1)
    800037f6:	01279763          	bne	a5,s2,80003804 <namex+0xb0>
    800037fa:	0485                	addi	s1,s1,1
    800037fc:	0004c783          	lbu	a5,0(s1)
    80003800:	ff278de3          	beq	a5,s2,800037fa <namex+0xa6>
    80003804:	8552                	mv	a0,s4
    80003806:	a3fff0ef          	jal	80003244 <ilock>
    8000380a:	044a1783          	lh	a5,68(s4)
    8000380e:	f9779be3          	bne	a5,s7,800037a4 <namex+0x50>
    80003812:	000b0563          	beqz	s6,8000381c <namex+0xc8>
    80003816:	0004c783          	lbu	a5,0(s1)
    8000381a:	d7dd                	beqz	a5,800037c8 <namex+0x74>
    8000381c:	4601                	li	a2,0
    8000381e:	85d6                	mv	a1,s5
    80003820:	8552                	mv	a0,s4
    80003822:	e97ff0ef          	jal	800036b8 <dirlookup>
    80003826:	89aa                	mv	s3,a0
    80003828:	d545                	beqz	a0,800037d0 <namex+0x7c>
    8000382a:	8552                	mv	a0,s4
    8000382c:	c23ff0ef          	jal	8000344e <iunlockput>
    80003830:	8a4e                	mv	s4,s3
    80003832:	0004c783          	lbu	a5,0(s1)
    80003836:	01279763          	bne	a5,s2,80003844 <namex+0xf0>
    8000383a:	0485                	addi	s1,s1,1
    8000383c:	0004c783          	lbu	a5,0(s1)
    80003840:	ff278de3          	beq	a5,s2,8000383a <namex+0xe6>
    80003844:	cb8d                	beqz	a5,80003876 <namex+0x122>
    80003846:	0004c783          	lbu	a5,0(s1)
    8000384a:	89a6                	mv	s3,s1
    8000384c:	4c81                	li	s9,0
    8000384e:	4601                	li	a2,0
    80003850:	01278963          	beq	a5,s2,80003862 <namex+0x10e>
    80003854:	d3d9                	beqz	a5,800037da <namex+0x86>
    80003856:	0985                	addi	s3,s3,1
    80003858:	0009c783          	lbu	a5,0(s3)
    8000385c:	ff279ce3          	bne	a5,s2,80003854 <namex+0x100>
    80003860:	bfad                	j	800037da <namex+0x86>
    80003862:	2601                	sext.w	a2,a2
    80003864:	85a6                	mv	a1,s1
    80003866:	8556                	mv	a0,s5
    80003868:	ccafd0ef          	jal	80000d32 <memmove>
    8000386c:	9cd6                	add	s9,s9,s5
    8000386e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003872:	84ce                	mv	s1,s3
    80003874:	bfbd                	j	800037f2 <namex+0x9e>
    80003876:	f20b0be3          	beqz	s6,800037ac <namex+0x58>
    8000387a:	8552                	mv	a0,s4
    8000387c:	b4bff0ef          	jal	800033c6 <iput>
    80003880:	4a01                	li	s4,0
    80003882:	b72d                	j	800037ac <namex+0x58>

0000000080003884 <dirlink>:
    80003884:	7139                	addi	sp,sp,-64
    80003886:	fc06                	sd	ra,56(sp)
    80003888:	f822                	sd	s0,48(sp)
    8000388a:	f04a                	sd	s2,32(sp)
    8000388c:	ec4e                	sd	s3,24(sp)
    8000388e:	e852                	sd	s4,16(sp)
    80003890:	0080                	addi	s0,sp,64
    80003892:	892a                	mv	s2,a0
    80003894:	8a2e                	mv	s4,a1
    80003896:	89b2                	mv	s3,a2
    80003898:	4601                	li	a2,0
    8000389a:	e1fff0ef          	jal	800036b8 <dirlookup>
    8000389e:	e535                	bnez	a0,8000390a <dirlink+0x86>
    800038a0:	f426                	sd	s1,40(sp)
    800038a2:	04c92483          	lw	s1,76(s2)
    800038a6:	c48d                	beqz	s1,800038d0 <dirlink+0x4c>
    800038a8:	4481                	li	s1,0
    800038aa:	4741                	li	a4,16
    800038ac:	86a6                	mv	a3,s1
    800038ae:	fc040613          	addi	a2,s0,-64
    800038b2:	4581                	li	a1,0
    800038b4:	854a                	mv	a0,s2
    800038b6:	be3ff0ef          	jal	80003498 <readi>
    800038ba:	47c1                	li	a5,16
    800038bc:	04f51b63          	bne	a0,a5,80003912 <dirlink+0x8e>
    800038c0:	fc045783          	lhu	a5,-64(s0)
    800038c4:	c791                	beqz	a5,800038d0 <dirlink+0x4c>
    800038c6:	24c1                	addiw	s1,s1,16
    800038c8:	04c92783          	lw	a5,76(s2)
    800038cc:	fcf4efe3          	bltu	s1,a5,800038aa <dirlink+0x26>
    800038d0:	4639                	li	a2,14
    800038d2:	85d2                	mv	a1,s4
    800038d4:	fc240513          	addi	a0,s0,-62
    800038d8:	d00fd0ef          	jal	80000dd8 <strncpy>
    800038dc:	fd341023          	sh	s3,-64(s0)
    800038e0:	4741                	li	a4,16
    800038e2:	86a6                	mv	a3,s1
    800038e4:	fc040613          	addi	a2,s0,-64
    800038e8:	4581                	li	a1,0
    800038ea:	854a                	mv	a0,s2
    800038ec:	ca9ff0ef          	jal	80003594 <writei>
    800038f0:	1541                	addi	a0,a0,-16
    800038f2:	00a03533          	snez	a0,a0
    800038f6:	40a00533          	neg	a0,a0
    800038fa:	74a2                	ld	s1,40(sp)
    800038fc:	70e2                	ld	ra,56(sp)
    800038fe:	7442                	ld	s0,48(sp)
    80003900:	7902                	ld	s2,32(sp)
    80003902:	69e2                	ld	s3,24(sp)
    80003904:	6a42                	ld	s4,16(sp)
    80003906:	6121                	addi	sp,sp,64
    80003908:	8082                	ret
    8000390a:	abdff0ef          	jal	800033c6 <iput>
    8000390e:	557d                	li	a0,-1
    80003910:	b7f5                	j	800038fc <dirlink+0x78>
    80003912:	00004517          	auipc	a0,0x4
    80003916:	c4650513          	addi	a0,a0,-954 # 80007558 <etext+0x558>
    8000391a:	e89fc0ef          	jal	800007a2 <panic>

000000008000391e <namei>:
    8000391e:	1101                	addi	sp,sp,-32
    80003920:	ec06                	sd	ra,24(sp)
    80003922:	e822                	sd	s0,16(sp)
    80003924:	1000                	addi	s0,sp,32
    80003926:	fe040613          	addi	a2,s0,-32
    8000392a:	4581                	li	a1,0
    8000392c:	e29ff0ef          	jal	80003754 <namex>
    80003930:	60e2                	ld	ra,24(sp)
    80003932:	6442                	ld	s0,16(sp)
    80003934:	6105                	addi	sp,sp,32
    80003936:	8082                	ret

0000000080003938 <nameiparent>:
    80003938:	1141                	addi	sp,sp,-16
    8000393a:	e406                	sd	ra,8(sp)
    8000393c:	e022                	sd	s0,0(sp)
    8000393e:	0800                	addi	s0,sp,16
    80003940:	862e                	mv	a2,a1
    80003942:	4585                	li	a1,1
    80003944:	e11ff0ef          	jal	80003754 <namex>
    80003948:	60a2                	ld	ra,8(sp)
    8000394a:	6402                	ld	s0,0(sp)
    8000394c:	0141                	addi	sp,sp,16
    8000394e:	8082                	ret

0000000080003950 <write_head>:
    80003950:	1101                	addi	sp,sp,-32
    80003952:	ec06                	sd	ra,24(sp)
    80003954:	e822                	sd	s0,16(sp)
    80003956:	e426                	sd	s1,8(sp)
    80003958:	e04a                	sd	s2,0(sp)
    8000395a:	1000                	addi	s0,sp,32
    8000395c:	0001f917          	auipc	s2,0x1f
    80003960:	a8490913          	addi	s2,s2,-1404 # 800223e0 <log>
    80003964:	01892583          	lw	a1,24(s2)
    80003968:	02892503          	lw	a0,40(s2)
    8000396c:	9a0ff0ef          	jal	80002b0c <bread>
    80003970:	84aa                	mv	s1,a0
    80003972:	02c92603          	lw	a2,44(s2)
    80003976:	cd30                	sw	a2,88(a0)
    80003978:	00c05f63          	blez	a2,80003996 <write_head+0x46>
    8000397c:	0001f717          	auipc	a4,0x1f
    80003980:	a9470713          	addi	a4,a4,-1388 # 80022410 <log+0x30>
    80003984:	87aa                	mv	a5,a0
    80003986:	060a                	slli	a2,a2,0x2
    80003988:	962a                	add	a2,a2,a0
    8000398a:	4314                	lw	a3,0(a4)
    8000398c:	cff4                	sw	a3,92(a5)
    8000398e:	0711                	addi	a4,a4,4
    80003990:	0791                	addi	a5,a5,4
    80003992:	fec79ce3          	bne	a5,a2,8000398a <write_head+0x3a>
    80003996:	8526                	mv	a0,s1
    80003998:	a4aff0ef          	jal	80002be2 <bwrite>
    8000399c:	8526                	mv	a0,s1
    8000399e:	a76ff0ef          	jal	80002c14 <brelse>
    800039a2:	60e2                	ld	ra,24(sp)
    800039a4:	6442                	ld	s0,16(sp)
    800039a6:	64a2                	ld	s1,8(sp)
    800039a8:	6902                	ld	s2,0(sp)
    800039aa:	6105                	addi	sp,sp,32
    800039ac:	8082                	ret

00000000800039ae <install_trans>:
    800039ae:	0001f797          	auipc	a5,0x1f
    800039b2:	a5e7a783          	lw	a5,-1442(a5) # 8002240c <log+0x2c>
    800039b6:	08f05f63          	blez	a5,80003a54 <install_trans+0xa6>
    800039ba:	7139                	addi	sp,sp,-64
    800039bc:	fc06                	sd	ra,56(sp)
    800039be:	f822                	sd	s0,48(sp)
    800039c0:	f426                	sd	s1,40(sp)
    800039c2:	f04a                	sd	s2,32(sp)
    800039c4:	ec4e                	sd	s3,24(sp)
    800039c6:	e852                	sd	s4,16(sp)
    800039c8:	e456                	sd	s5,8(sp)
    800039ca:	e05a                	sd	s6,0(sp)
    800039cc:	0080                	addi	s0,sp,64
    800039ce:	8b2a                	mv	s6,a0
    800039d0:	0001fa97          	auipc	s5,0x1f
    800039d4:	a40a8a93          	addi	s5,s5,-1472 # 80022410 <log+0x30>
    800039d8:	4a01                	li	s4,0
    800039da:	0001f997          	auipc	s3,0x1f
    800039de:	a0698993          	addi	s3,s3,-1530 # 800223e0 <log>
    800039e2:	a829                	j	800039fc <install_trans+0x4e>
    800039e4:	854a                	mv	a0,s2
    800039e6:	a2eff0ef          	jal	80002c14 <brelse>
    800039ea:	8526                	mv	a0,s1
    800039ec:	a28ff0ef          	jal	80002c14 <brelse>
    800039f0:	2a05                	addiw	s4,s4,1
    800039f2:	0a91                	addi	s5,s5,4
    800039f4:	02c9a783          	lw	a5,44(s3)
    800039f8:	04fa5463          	bge	s4,a5,80003a40 <install_trans+0x92>
    800039fc:	0189a583          	lw	a1,24(s3)
    80003a00:	014585bb          	addw	a1,a1,s4
    80003a04:	2585                	addiw	a1,a1,1
    80003a06:	0289a503          	lw	a0,40(s3)
    80003a0a:	902ff0ef          	jal	80002b0c <bread>
    80003a0e:	892a                	mv	s2,a0
    80003a10:	000aa583          	lw	a1,0(s5)
    80003a14:	0289a503          	lw	a0,40(s3)
    80003a18:	8f4ff0ef          	jal	80002b0c <bread>
    80003a1c:	84aa                	mv	s1,a0
    80003a1e:	40000613          	li	a2,1024
    80003a22:	05890593          	addi	a1,s2,88
    80003a26:	05850513          	addi	a0,a0,88
    80003a2a:	b08fd0ef          	jal	80000d32 <memmove>
    80003a2e:	8526                	mv	a0,s1
    80003a30:	9b2ff0ef          	jal	80002be2 <bwrite>
    80003a34:	fa0b18e3          	bnez	s6,800039e4 <install_trans+0x36>
    80003a38:	8526                	mv	a0,s1
    80003a3a:	a96ff0ef          	jal	80002cd0 <bunpin>
    80003a3e:	b75d                	j	800039e4 <install_trans+0x36>
    80003a40:	70e2                	ld	ra,56(sp)
    80003a42:	7442                	ld	s0,48(sp)
    80003a44:	74a2                	ld	s1,40(sp)
    80003a46:	7902                	ld	s2,32(sp)
    80003a48:	69e2                	ld	s3,24(sp)
    80003a4a:	6a42                	ld	s4,16(sp)
    80003a4c:	6aa2                	ld	s5,8(sp)
    80003a4e:	6b02                	ld	s6,0(sp)
    80003a50:	6121                	addi	sp,sp,64
    80003a52:	8082                	ret
    80003a54:	8082                	ret

0000000080003a56 <initlog>:
    80003a56:	7179                	addi	sp,sp,-48
    80003a58:	f406                	sd	ra,40(sp)
    80003a5a:	f022                	sd	s0,32(sp)
    80003a5c:	ec26                	sd	s1,24(sp)
    80003a5e:	e84a                	sd	s2,16(sp)
    80003a60:	e44e                	sd	s3,8(sp)
    80003a62:	1800                	addi	s0,sp,48
    80003a64:	892a                	mv	s2,a0
    80003a66:	89ae                	mv	s3,a1
    80003a68:	0001f497          	auipc	s1,0x1f
    80003a6c:	97848493          	addi	s1,s1,-1672 # 800223e0 <log>
    80003a70:	00004597          	auipc	a1,0x4
    80003a74:	af858593          	addi	a1,a1,-1288 # 80007568 <etext+0x568>
    80003a78:	8526                	mv	a0,s1
    80003a7a:	908fd0ef          	jal	80000b82 <initlock>
    80003a7e:	0149a583          	lw	a1,20(s3)
    80003a82:	cc8c                	sw	a1,24(s1)
    80003a84:	0109a783          	lw	a5,16(s3)
    80003a88:	ccdc                	sw	a5,28(s1)
    80003a8a:	0324a423          	sw	s2,40(s1)
    80003a8e:	854a                	mv	a0,s2
    80003a90:	87cff0ef          	jal	80002b0c <bread>
    80003a94:	4d30                	lw	a2,88(a0)
    80003a96:	d4d0                	sw	a2,44(s1)
    80003a98:	00c05f63          	blez	a2,80003ab6 <initlog+0x60>
    80003a9c:	87aa                	mv	a5,a0
    80003a9e:	0001f717          	auipc	a4,0x1f
    80003aa2:	97270713          	addi	a4,a4,-1678 # 80022410 <log+0x30>
    80003aa6:	060a                	slli	a2,a2,0x2
    80003aa8:	962a                	add	a2,a2,a0
    80003aaa:	4ff4                	lw	a3,92(a5)
    80003aac:	c314                	sw	a3,0(a4)
    80003aae:	0791                	addi	a5,a5,4
    80003ab0:	0711                	addi	a4,a4,4
    80003ab2:	fec79ce3          	bne	a5,a2,80003aaa <initlog+0x54>
    80003ab6:	95eff0ef          	jal	80002c14 <brelse>
    80003aba:	4505                	li	a0,1
    80003abc:	ef3ff0ef          	jal	800039ae <install_trans>
    80003ac0:	0001f797          	auipc	a5,0x1f
    80003ac4:	9407a623          	sw	zero,-1716(a5) # 8002240c <log+0x2c>
    80003ac8:	e89ff0ef          	jal	80003950 <write_head>
    80003acc:	70a2                	ld	ra,40(sp)
    80003ace:	7402                	ld	s0,32(sp)
    80003ad0:	64e2                	ld	s1,24(sp)
    80003ad2:	6942                	ld	s2,16(sp)
    80003ad4:	69a2                	ld	s3,8(sp)
    80003ad6:	6145                	addi	sp,sp,48
    80003ad8:	8082                	ret

0000000080003ada <begin_op>:
    80003ada:	1101                	addi	sp,sp,-32
    80003adc:	ec06                	sd	ra,24(sp)
    80003ade:	e822                	sd	s0,16(sp)
    80003ae0:	e426                	sd	s1,8(sp)
    80003ae2:	e04a                	sd	s2,0(sp)
    80003ae4:	1000                	addi	s0,sp,32
    80003ae6:	0001f517          	auipc	a0,0x1f
    80003aea:	8fa50513          	addi	a0,a0,-1798 # 800223e0 <log>
    80003aee:	914fd0ef          	jal	80000c02 <acquire>
    80003af2:	0001f497          	auipc	s1,0x1f
    80003af6:	8ee48493          	addi	s1,s1,-1810 # 800223e0 <log>
    80003afa:	4979                	li	s2,30
    80003afc:	a029                	j	80003b06 <begin_op+0x2c>
    80003afe:	85a6                	mv	a1,s1
    80003b00:	8526                	mv	a0,s1
    80003b02:	bccfe0ef          	jal	80001ece <sleep>
    80003b06:	50dc                	lw	a5,36(s1)
    80003b08:	fbfd                	bnez	a5,80003afe <begin_op+0x24>
    80003b0a:	5098                	lw	a4,32(s1)
    80003b0c:	2705                	addiw	a4,a4,1
    80003b0e:	0027179b          	slliw	a5,a4,0x2
    80003b12:	9fb9                	addw	a5,a5,a4
    80003b14:	0017979b          	slliw	a5,a5,0x1
    80003b18:	54d4                	lw	a3,44(s1)
    80003b1a:	9fb5                	addw	a5,a5,a3
    80003b1c:	00f95763          	bge	s2,a5,80003b2a <begin_op+0x50>
    80003b20:	85a6                	mv	a1,s1
    80003b22:	8526                	mv	a0,s1
    80003b24:	baafe0ef          	jal	80001ece <sleep>
    80003b28:	bff9                	j	80003b06 <begin_op+0x2c>
    80003b2a:	0001f517          	auipc	a0,0x1f
    80003b2e:	8b650513          	addi	a0,a0,-1866 # 800223e0 <log>
    80003b32:	d118                	sw	a4,32(a0)
    80003b34:	966fd0ef          	jal	80000c9a <release>
    80003b38:	60e2                	ld	ra,24(sp)
    80003b3a:	6442                	ld	s0,16(sp)
    80003b3c:	64a2                	ld	s1,8(sp)
    80003b3e:	6902                	ld	s2,0(sp)
    80003b40:	6105                	addi	sp,sp,32
    80003b42:	8082                	ret

0000000080003b44 <end_op>:
    80003b44:	7139                	addi	sp,sp,-64
    80003b46:	fc06                	sd	ra,56(sp)
    80003b48:	f822                	sd	s0,48(sp)
    80003b4a:	f426                	sd	s1,40(sp)
    80003b4c:	f04a                	sd	s2,32(sp)
    80003b4e:	0080                	addi	s0,sp,64
    80003b50:	0001f497          	auipc	s1,0x1f
    80003b54:	89048493          	addi	s1,s1,-1904 # 800223e0 <log>
    80003b58:	8526                	mv	a0,s1
    80003b5a:	8a8fd0ef          	jal	80000c02 <acquire>
    80003b5e:	509c                	lw	a5,32(s1)
    80003b60:	37fd                	addiw	a5,a5,-1
    80003b62:	0007891b          	sext.w	s2,a5
    80003b66:	d09c                	sw	a5,32(s1)
    80003b68:	50dc                	lw	a5,36(s1)
    80003b6a:	ef9d                	bnez	a5,80003ba8 <end_op+0x64>
    80003b6c:	04091763          	bnez	s2,80003bba <end_op+0x76>
    80003b70:	0001f497          	auipc	s1,0x1f
    80003b74:	87048493          	addi	s1,s1,-1936 # 800223e0 <log>
    80003b78:	4785                	li	a5,1
    80003b7a:	d0dc                	sw	a5,36(s1)
    80003b7c:	8526                	mv	a0,s1
    80003b7e:	91cfd0ef          	jal	80000c9a <release>
    80003b82:	54dc                	lw	a5,44(s1)
    80003b84:	04f04b63          	bgtz	a5,80003bda <end_op+0x96>
    80003b88:	0001f497          	auipc	s1,0x1f
    80003b8c:	85848493          	addi	s1,s1,-1960 # 800223e0 <log>
    80003b90:	8526                	mv	a0,s1
    80003b92:	870fd0ef          	jal	80000c02 <acquire>
    80003b96:	0204a223          	sw	zero,36(s1)
    80003b9a:	8526                	mv	a0,s1
    80003b9c:	b7efe0ef          	jal	80001f1a <wakeup>
    80003ba0:	8526                	mv	a0,s1
    80003ba2:	8f8fd0ef          	jal	80000c9a <release>
    80003ba6:	a025                	j	80003bce <end_op+0x8a>
    80003ba8:	ec4e                	sd	s3,24(sp)
    80003baa:	e852                	sd	s4,16(sp)
    80003bac:	e456                	sd	s5,8(sp)
    80003bae:	00004517          	auipc	a0,0x4
    80003bb2:	9c250513          	addi	a0,a0,-1598 # 80007570 <etext+0x570>
    80003bb6:	bedfc0ef          	jal	800007a2 <panic>
    80003bba:	0001f497          	auipc	s1,0x1f
    80003bbe:	82648493          	addi	s1,s1,-2010 # 800223e0 <log>
    80003bc2:	8526                	mv	a0,s1
    80003bc4:	b56fe0ef          	jal	80001f1a <wakeup>
    80003bc8:	8526                	mv	a0,s1
    80003bca:	8d0fd0ef          	jal	80000c9a <release>
    80003bce:	70e2                	ld	ra,56(sp)
    80003bd0:	7442                	ld	s0,48(sp)
    80003bd2:	74a2                	ld	s1,40(sp)
    80003bd4:	7902                	ld	s2,32(sp)
    80003bd6:	6121                	addi	sp,sp,64
    80003bd8:	8082                	ret
    80003bda:	ec4e                	sd	s3,24(sp)
    80003bdc:	e852                	sd	s4,16(sp)
    80003bde:	e456                	sd	s5,8(sp)
    80003be0:	0001fa97          	auipc	s5,0x1f
    80003be4:	830a8a93          	addi	s5,s5,-2000 # 80022410 <log+0x30>
    80003be8:	0001ea17          	auipc	s4,0x1e
    80003bec:	7f8a0a13          	addi	s4,s4,2040 # 800223e0 <log>
    80003bf0:	018a2583          	lw	a1,24(s4)
    80003bf4:	012585bb          	addw	a1,a1,s2
    80003bf8:	2585                	addiw	a1,a1,1
    80003bfa:	028a2503          	lw	a0,40(s4)
    80003bfe:	f0ffe0ef          	jal	80002b0c <bread>
    80003c02:	84aa                	mv	s1,a0
    80003c04:	000aa583          	lw	a1,0(s5)
    80003c08:	028a2503          	lw	a0,40(s4)
    80003c0c:	f01fe0ef          	jal	80002b0c <bread>
    80003c10:	89aa                	mv	s3,a0
    80003c12:	40000613          	li	a2,1024
    80003c16:	05850593          	addi	a1,a0,88
    80003c1a:	05848513          	addi	a0,s1,88
    80003c1e:	914fd0ef          	jal	80000d32 <memmove>
    80003c22:	8526                	mv	a0,s1
    80003c24:	fbffe0ef          	jal	80002be2 <bwrite>
    80003c28:	854e                	mv	a0,s3
    80003c2a:	febfe0ef          	jal	80002c14 <brelse>
    80003c2e:	8526                	mv	a0,s1
    80003c30:	fe5fe0ef          	jal	80002c14 <brelse>
    80003c34:	2905                	addiw	s2,s2,1
    80003c36:	0a91                	addi	s5,s5,4
    80003c38:	02ca2783          	lw	a5,44(s4)
    80003c3c:	faf94ae3          	blt	s2,a5,80003bf0 <end_op+0xac>
    80003c40:	d11ff0ef          	jal	80003950 <write_head>
    80003c44:	4501                	li	a0,0
    80003c46:	d69ff0ef          	jal	800039ae <install_trans>
    80003c4a:	0001e797          	auipc	a5,0x1e
    80003c4e:	7c07a123          	sw	zero,1986(a5) # 8002240c <log+0x2c>
    80003c52:	cffff0ef          	jal	80003950 <write_head>
    80003c56:	69e2                	ld	s3,24(sp)
    80003c58:	6a42                	ld	s4,16(sp)
    80003c5a:	6aa2                	ld	s5,8(sp)
    80003c5c:	b735                	j	80003b88 <end_op+0x44>

0000000080003c5e <log_write>:
    80003c5e:	1101                	addi	sp,sp,-32
    80003c60:	ec06                	sd	ra,24(sp)
    80003c62:	e822                	sd	s0,16(sp)
    80003c64:	e426                	sd	s1,8(sp)
    80003c66:	e04a                	sd	s2,0(sp)
    80003c68:	1000                	addi	s0,sp,32
    80003c6a:	84aa                	mv	s1,a0
    80003c6c:	0001e917          	auipc	s2,0x1e
    80003c70:	77490913          	addi	s2,s2,1908 # 800223e0 <log>
    80003c74:	854a                	mv	a0,s2
    80003c76:	f8dfc0ef          	jal	80000c02 <acquire>
    80003c7a:	02c92603          	lw	a2,44(s2)
    80003c7e:	47f5                	li	a5,29
    80003c80:	06c7c363          	blt	a5,a2,80003ce6 <log_write+0x88>
    80003c84:	0001e797          	auipc	a5,0x1e
    80003c88:	7787a783          	lw	a5,1912(a5) # 800223fc <log+0x1c>
    80003c8c:	37fd                	addiw	a5,a5,-1
    80003c8e:	04f65c63          	bge	a2,a5,80003ce6 <log_write+0x88>
    80003c92:	0001e797          	auipc	a5,0x1e
    80003c96:	76e7a783          	lw	a5,1902(a5) # 80022400 <log+0x20>
    80003c9a:	04f05c63          	blez	a5,80003cf2 <log_write+0x94>
    80003c9e:	4781                	li	a5,0
    80003ca0:	04c05f63          	blez	a2,80003cfe <log_write+0xa0>
    80003ca4:	44cc                	lw	a1,12(s1)
    80003ca6:	0001e717          	auipc	a4,0x1e
    80003caa:	76a70713          	addi	a4,a4,1898 # 80022410 <log+0x30>
    80003cae:	4781                	li	a5,0
    80003cb0:	4314                	lw	a3,0(a4)
    80003cb2:	04b68663          	beq	a3,a1,80003cfe <log_write+0xa0>
    80003cb6:	2785                	addiw	a5,a5,1
    80003cb8:	0711                	addi	a4,a4,4
    80003cba:	fef61be3          	bne	a2,a5,80003cb0 <log_write+0x52>
    80003cbe:	0621                	addi	a2,a2,8
    80003cc0:	060a                	slli	a2,a2,0x2
    80003cc2:	0001e797          	auipc	a5,0x1e
    80003cc6:	71e78793          	addi	a5,a5,1822 # 800223e0 <log>
    80003cca:	97b2                	add	a5,a5,a2
    80003ccc:	44d8                	lw	a4,12(s1)
    80003cce:	cb98                	sw	a4,16(a5)
    80003cd0:	8526                	mv	a0,s1
    80003cd2:	fcbfe0ef          	jal	80002c9c <bpin>
    80003cd6:	0001e717          	auipc	a4,0x1e
    80003cda:	70a70713          	addi	a4,a4,1802 # 800223e0 <log>
    80003cde:	575c                	lw	a5,44(a4)
    80003ce0:	2785                	addiw	a5,a5,1
    80003ce2:	d75c                	sw	a5,44(a4)
    80003ce4:	a80d                	j	80003d16 <log_write+0xb8>
    80003ce6:	00004517          	auipc	a0,0x4
    80003cea:	89a50513          	addi	a0,a0,-1894 # 80007580 <etext+0x580>
    80003cee:	ab5fc0ef          	jal	800007a2 <panic>
    80003cf2:	00004517          	auipc	a0,0x4
    80003cf6:	8a650513          	addi	a0,a0,-1882 # 80007598 <etext+0x598>
    80003cfa:	aa9fc0ef          	jal	800007a2 <panic>
    80003cfe:	00878693          	addi	a3,a5,8
    80003d02:	068a                	slli	a3,a3,0x2
    80003d04:	0001e717          	auipc	a4,0x1e
    80003d08:	6dc70713          	addi	a4,a4,1756 # 800223e0 <log>
    80003d0c:	9736                	add	a4,a4,a3
    80003d0e:	44d4                	lw	a3,12(s1)
    80003d10:	cb14                	sw	a3,16(a4)
    80003d12:	faf60fe3          	beq	a2,a5,80003cd0 <log_write+0x72>
    80003d16:	0001e517          	auipc	a0,0x1e
    80003d1a:	6ca50513          	addi	a0,a0,1738 # 800223e0 <log>
    80003d1e:	f7dfc0ef          	jal	80000c9a <release>
    80003d22:	60e2                	ld	ra,24(sp)
    80003d24:	6442                	ld	s0,16(sp)
    80003d26:	64a2                	ld	s1,8(sp)
    80003d28:	6902                	ld	s2,0(sp)
    80003d2a:	6105                	addi	sp,sp,32
    80003d2c:	8082                	ret

0000000080003d2e <initsleeplock>:
    80003d2e:	1101                	addi	sp,sp,-32
    80003d30:	ec06                	sd	ra,24(sp)
    80003d32:	e822                	sd	s0,16(sp)
    80003d34:	e426                	sd	s1,8(sp)
    80003d36:	e04a                	sd	s2,0(sp)
    80003d38:	1000                	addi	s0,sp,32
    80003d3a:	84aa                	mv	s1,a0
    80003d3c:	892e                	mv	s2,a1
    80003d3e:	00004597          	auipc	a1,0x4
    80003d42:	87a58593          	addi	a1,a1,-1926 # 800075b8 <etext+0x5b8>
    80003d46:	0521                	addi	a0,a0,8
    80003d48:	e3bfc0ef          	jal	80000b82 <initlock>
    80003d4c:	0324b023          	sd	s2,32(s1)
    80003d50:	0004a023          	sw	zero,0(s1)
    80003d54:	0204a423          	sw	zero,40(s1)
    80003d58:	60e2                	ld	ra,24(sp)
    80003d5a:	6442                	ld	s0,16(sp)
    80003d5c:	64a2                	ld	s1,8(sp)
    80003d5e:	6902                	ld	s2,0(sp)
    80003d60:	6105                	addi	sp,sp,32
    80003d62:	8082                	ret

0000000080003d64 <acquiresleep>:
    80003d64:	1101                	addi	sp,sp,-32
    80003d66:	ec06                	sd	ra,24(sp)
    80003d68:	e822                	sd	s0,16(sp)
    80003d6a:	e426                	sd	s1,8(sp)
    80003d6c:	e04a                	sd	s2,0(sp)
    80003d6e:	1000                	addi	s0,sp,32
    80003d70:	84aa                	mv	s1,a0
    80003d72:	00850913          	addi	s2,a0,8
    80003d76:	854a                	mv	a0,s2
    80003d78:	e8bfc0ef          	jal	80000c02 <acquire>
    80003d7c:	409c                	lw	a5,0(s1)
    80003d7e:	c799                	beqz	a5,80003d8c <acquiresleep+0x28>
    80003d80:	85ca                	mv	a1,s2
    80003d82:	8526                	mv	a0,s1
    80003d84:	94afe0ef          	jal	80001ece <sleep>
    80003d88:	409c                	lw	a5,0(s1)
    80003d8a:	fbfd                	bnez	a5,80003d80 <acquiresleep+0x1c>
    80003d8c:	4785                	li	a5,1
    80003d8e:	c09c                	sw	a5,0(s1)
    80003d90:	b71fd0ef          	jal	80001900 <myproc>
    80003d94:	591c                	lw	a5,48(a0)
    80003d96:	d49c                	sw	a5,40(s1)
    80003d98:	854a                	mv	a0,s2
    80003d9a:	f01fc0ef          	jal	80000c9a <release>
    80003d9e:	60e2                	ld	ra,24(sp)
    80003da0:	6442                	ld	s0,16(sp)
    80003da2:	64a2                	ld	s1,8(sp)
    80003da4:	6902                	ld	s2,0(sp)
    80003da6:	6105                	addi	sp,sp,32
    80003da8:	8082                	ret

0000000080003daa <releasesleep>:
    80003daa:	1101                	addi	sp,sp,-32
    80003dac:	ec06                	sd	ra,24(sp)
    80003dae:	e822                	sd	s0,16(sp)
    80003db0:	e426                	sd	s1,8(sp)
    80003db2:	e04a                	sd	s2,0(sp)
    80003db4:	1000                	addi	s0,sp,32
    80003db6:	84aa                	mv	s1,a0
    80003db8:	00850913          	addi	s2,a0,8
    80003dbc:	854a                	mv	a0,s2
    80003dbe:	e45fc0ef          	jal	80000c02 <acquire>
    80003dc2:	0004a023          	sw	zero,0(s1)
    80003dc6:	0204a423          	sw	zero,40(s1)
    80003dca:	8526                	mv	a0,s1
    80003dcc:	94efe0ef          	jal	80001f1a <wakeup>
    80003dd0:	854a                	mv	a0,s2
    80003dd2:	ec9fc0ef          	jal	80000c9a <release>
    80003dd6:	60e2                	ld	ra,24(sp)
    80003dd8:	6442                	ld	s0,16(sp)
    80003dda:	64a2                	ld	s1,8(sp)
    80003ddc:	6902                	ld	s2,0(sp)
    80003dde:	6105                	addi	sp,sp,32
    80003de0:	8082                	ret

0000000080003de2 <holdingsleep>:
    80003de2:	7179                	addi	sp,sp,-48
    80003de4:	f406                	sd	ra,40(sp)
    80003de6:	f022                	sd	s0,32(sp)
    80003de8:	ec26                	sd	s1,24(sp)
    80003dea:	e84a                	sd	s2,16(sp)
    80003dec:	1800                	addi	s0,sp,48
    80003dee:	84aa                	mv	s1,a0
    80003df0:	00850913          	addi	s2,a0,8
    80003df4:	854a                	mv	a0,s2
    80003df6:	e0dfc0ef          	jal	80000c02 <acquire>
    80003dfa:	409c                	lw	a5,0(s1)
    80003dfc:	ef81                	bnez	a5,80003e14 <holdingsleep+0x32>
    80003dfe:	4481                	li	s1,0
    80003e00:	854a                	mv	a0,s2
    80003e02:	e99fc0ef          	jal	80000c9a <release>
    80003e06:	8526                	mv	a0,s1
    80003e08:	70a2                	ld	ra,40(sp)
    80003e0a:	7402                	ld	s0,32(sp)
    80003e0c:	64e2                	ld	s1,24(sp)
    80003e0e:	6942                	ld	s2,16(sp)
    80003e10:	6145                	addi	sp,sp,48
    80003e12:	8082                	ret
    80003e14:	e44e                	sd	s3,8(sp)
    80003e16:	0284a983          	lw	s3,40(s1)
    80003e1a:	ae7fd0ef          	jal	80001900 <myproc>
    80003e1e:	5904                	lw	s1,48(a0)
    80003e20:	413484b3          	sub	s1,s1,s3
    80003e24:	0014b493          	seqz	s1,s1
    80003e28:	69a2                	ld	s3,8(sp)
    80003e2a:	bfd9                	j	80003e00 <holdingsleep+0x1e>

0000000080003e2c <fileinit>:
    80003e2c:	1141                	addi	sp,sp,-16
    80003e2e:	e406                	sd	ra,8(sp)
    80003e30:	e022                	sd	s0,0(sp)
    80003e32:	0800                	addi	s0,sp,16
    80003e34:	00003597          	auipc	a1,0x3
    80003e38:	79458593          	addi	a1,a1,1940 # 800075c8 <etext+0x5c8>
    80003e3c:	0001e517          	auipc	a0,0x1e
    80003e40:	6ec50513          	addi	a0,a0,1772 # 80022528 <ftable>
    80003e44:	d3ffc0ef          	jal	80000b82 <initlock>
    80003e48:	60a2                	ld	ra,8(sp)
    80003e4a:	6402                	ld	s0,0(sp)
    80003e4c:	0141                	addi	sp,sp,16
    80003e4e:	8082                	ret

0000000080003e50 <filealloc>:
    80003e50:	1101                	addi	sp,sp,-32
    80003e52:	ec06                	sd	ra,24(sp)
    80003e54:	e822                	sd	s0,16(sp)
    80003e56:	e426                	sd	s1,8(sp)
    80003e58:	1000                	addi	s0,sp,32
    80003e5a:	0001e517          	auipc	a0,0x1e
    80003e5e:	6ce50513          	addi	a0,a0,1742 # 80022528 <ftable>
    80003e62:	da1fc0ef          	jal	80000c02 <acquire>
    80003e66:	0001e497          	auipc	s1,0x1e
    80003e6a:	6da48493          	addi	s1,s1,1754 # 80022540 <ftable+0x18>
    80003e6e:	0001f717          	auipc	a4,0x1f
    80003e72:	67270713          	addi	a4,a4,1650 # 800234e0 <disk>
    80003e76:	40dc                	lw	a5,4(s1)
    80003e78:	cf89                	beqz	a5,80003e92 <filealloc+0x42>
    80003e7a:	02848493          	addi	s1,s1,40
    80003e7e:	fee49ce3          	bne	s1,a4,80003e76 <filealloc+0x26>
    80003e82:	0001e517          	auipc	a0,0x1e
    80003e86:	6a650513          	addi	a0,a0,1702 # 80022528 <ftable>
    80003e8a:	e11fc0ef          	jal	80000c9a <release>
    80003e8e:	4481                	li	s1,0
    80003e90:	a809                	j	80003ea2 <filealloc+0x52>
    80003e92:	4785                	li	a5,1
    80003e94:	c0dc                	sw	a5,4(s1)
    80003e96:	0001e517          	auipc	a0,0x1e
    80003e9a:	69250513          	addi	a0,a0,1682 # 80022528 <ftable>
    80003e9e:	dfdfc0ef          	jal	80000c9a <release>
    80003ea2:	8526                	mv	a0,s1
    80003ea4:	60e2                	ld	ra,24(sp)
    80003ea6:	6442                	ld	s0,16(sp)
    80003ea8:	64a2                	ld	s1,8(sp)
    80003eaa:	6105                	addi	sp,sp,32
    80003eac:	8082                	ret

0000000080003eae <filedup>:
    80003eae:	1101                	addi	sp,sp,-32
    80003eb0:	ec06                	sd	ra,24(sp)
    80003eb2:	e822                	sd	s0,16(sp)
    80003eb4:	e426                	sd	s1,8(sp)
    80003eb6:	1000                	addi	s0,sp,32
    80003eb8:	84aa                	mv	s1,a0
    80003eba:	0001e517          	auipc	a0,0x1e
    80003ebe:	66e50513          	addi	a0,a0,1646 # 80022528 <ftable>
    80003ec2:	d41fc0ef          	jal	80000c02 <acquire>
    80003ec6:	40dc                	lw	a5,4(s1)
    80003ec8:	02f05063          	blez	a5,80003ee8 <filedup+0x3a>
    80003ecc:	2785                	addiw	a5,a5,1
    80003ece:	c0dc                	sw	a5,4(s1)
    80003ed0:	0001e517          	auipc	a0,0x1e
    80003ed4:	65850513          	addi	a0,a0,1624 # 80022528 <ftable>
    80003ed8:	dc3fc0ef          	jal	80000c9a <release>
    80003edc:	8526                	mv	a0,s1
    80003ede:	60e2                	ld	ra,24(sp)
    80003ee0:	6442                	ld	s0,16(sp)
    80003ee2:	64a2                	ld	s1,8(sp)
    80003ee4:	6105                	addi	sp,sp,32
    80003ee6:	8082                	ret
    80003ee8:	00003517          	auipc	a0,0x3
    80003eec:	6e850513          	addi	a0,a0,1768 # 800075d0 <etext+0x5d0>
    80003ef0:	8b3fc0ef          	jal	800007a2 <panic>

0000000080003ef4 <fileclose>:
    80003ef4:	7139                	addi	sp,sp,-64
    80003ef6:	fc06                	sd	ra,56(sp)
    80003ef8:	f822                	sd	s0,48(sp)
    80003efa:	f426                	sd	s1,40(sp)
    80003efc:	0080                	addi	s0,sp,64
    80003efe:	84aa                	mv	s1,a0
    80003f00:	0001e517          	auipc	a0,0x1e
    80003f04:	62850513          	addi	a0,a0,1576 # 80022528 <ftable>
    80003f08:	cfbfc0ef          	jal	80000c02 <acquire>
    80003f0c:	40dc                	lw	a5,4(s1)
    80003f0e:	04f05a63          	blez	a5,80003f62 <fileclose+0x6e>
    80003f12:	37fd                	addiw	a5,a5,-1
    80003f14:	0007871b          	sext.w	a4,a5
    80003f18:	c0dc                	sw	a5,4(s1)
    80003f1a:	04e04e63          	bgtz	a4,80003f76 <fileclose+0x82>
    80003f1e:	f04a                	sd	s2,32(sp)
    80003f20:	ec4e                	sd	s3,24(sp)
    80003f22:	e852                	sd	s4,16(sp)
    80003f24:	e456                	sd	s5,8(sp)
    80003f26:	0004a903          	lw	s2,0(s1)
    80003f2a:	0094ca83          	lbu	s5,9(s1)
    80003f2e:	0104ba03          	ld	s4,16(s1)
    80003f32:	0184b983          	ld	s3,24(s1)
    80003f36:	0004a223          	sw	zero,4(s1)
    80003f3a:	0004a023          	sw	zero,0(s1)
    80003f3e:	0001e517          	auipc	a0,0x1e
    80003f42:	5ea50513          	addi	a0,a0,1514 # 80022528 <ftable>
    80003f46:	d55fc0ef          	jal	80000c9a <release>
    80003f4a:	4785                	li	a5,1
    80003f4c:	04f90063          	beq	s2,a5,80003f8c <fileclose+0x98>
    80003f50:	3979                	addiw	s2,s2,-2
    80003f52:	4785                	li	a5,1
    80003f54:	0527f563          	bgeu	a5,s2,80003f9e <fileclose+0xaa>
    80003f58:	7902                	ld	s2,32(sp)
    80003f5a:	69e2                	ld	s3,24(sp)
    80003f5c:	6a42                	ld	s4,16(sp)
    80003f5e:	6aa2                	ld	s5,8(sp)
    80003f60:	a00d                	j	80003f82 <fileclose+0x8e>
    80003f62:	f04a                	sd	s2,32(sp)
    80003f64:	ec4e                	sd	s3,24(sp)
    80003f66:	e852                	sd	s4,16(sp)
    80003f68:	e456                	sd	s5,8(sp)
    80003f6a:	00003517          	auipc	a0,0x3
    80003f6e:	66e50513          	addi	a0,a0,1646 # 800075d8 <etext+0x5d8>
    80003f72:	831fc0ef          	jal	800007a2 <panic>
    80003f76:	0001e517          	auipc	a0,0x1e
    80003f7a:	5b250513          	addi	a0,a0,1458 # 80022528 <ftable>
    80003f7e:	d1dfc0ef          	jal	80000c9a <release>
    80003f82:	70e2                	ld	ra,56(sp)
    80003f84:	7442                	ld	s0,48(sp)
    80003f86:	74a2                	ld	s1,40(sp)
    80003f88:	6121                	addi	sp,sp,64
    80003f8a:	8082                	ret
    80003f8c:	85d6                	mv	a1,s5
    80003f8e:	8552                	mv	a0,s4
    80003f90:	336000ef          	jal	800042c6 <pipeclose>
    80003f94:	7902                	ld	s2,32(sp)
    80003f96:	69e2                	ld	s3,24(sp)
    80003f98:	6a42                	ld	s4,16(sp)
    80003f9a:	6aa2                	ld	s5,8(sp)
    80003f9c:	b7dd                	j	80003f82 <fileclose+0x8e>
    80003f9e:	b3dff0ef          	jal	80003ada <begin_op>
    80003fa2:	854e                	mv	a0,s3
    80003fa4:	c22ff0ef          	jal	800033c6 <iput>
    80003fa8:	b9dff0ef          	jal	80003b44 <end_op>
    80003fac:	7902                	ld	s2,32(sp)
    80003fae:	69e2                	ld	s3,24(sp)
    80003fb0:	6a42                	ld	s4,16(sp)
    80003fb2:	6aa2                	ld	s5,8(sp)
    80003fb4:	b7f9                	j	80003f82 <fileclose+0x8e>

0000000080003fb6 <filestat>:
    80003fb6:	715d                	addi	sp,sp,-80
    80003fb8:	e486                	sd	ra,72(sp)
    80003fba:	e0a2                	sd	s0,64(sp)
    80003fbc:	fc26                	sd	s1,56(sp)
    80003fbe:	f44e                	sd	s3,40(sp)
    80003fc0:	0880                	addi	s0,sp,80
    80003fc2:	84aa                	mv	s1,a0
    80003fc4:	89ae                	mv	s3,a1
    80003fc6:	93bfd0ef          	jal	80001900 <myproc>
    80003fca:	409c                	lw	a5,0(s1)
    80003fcc:	37f9                	addiw	a5,a5,-2
    80003fce:	4705                	li	a4,1
    80003fd0:	04f76063          	bltu	a4,a5,80004010 <filestat+0x5a>
    80003fd4:	f84a                	sd	s2,48(sp)
    80003fd6:	892a                	mv	s2,a0
    80003fd8:	6c88                	ld	a0,24(s1)
    80003fda:	a6aff0ef          	jal	80003244 <ilock>
    80003fde:	fb840593          	addi	a1,s0,-72
    80003fe2:	6c88                	ld	a0,24(s1)
    80003fe4:	c8aff0ef          	jal	8000346e <stati>
    80003fe8:	6c88                	ld	a0,24(s1)
    80003fea:	b08ff0ef          	jal	800032f2 <iunlock>
    80003fee:	46e1                	li	a3,24
    80003ff0:	fb840613          	addi	a2,s0,-72
    80003ff4:	85ce                	mv	a1,s3
    80003ff6:	05093503          	ld	a0,80(s2)
    80003ffa:	d78fd0ef          	jal	80001572 <copyout>
    80003ffe:	41f5551b          	sraiw	a0,a0,0x1f
    80004002:	7942                	ld	s2,48(sp)
    80004004:	60a6                	ld	ra,72(sp)
    80004006:	6406                	ld	s0,64(sp)
    80004008:	74e2                	ld	s1,56(sp)
    8000400a:	79a2                	ld	s3,40(sp)
    8000400c:	6161                	addi	sp,sp,80
    8000400e:	8082                	ret
    80004010:	557d                	li	a0,-1
    80004012:	bfcd                	j	80004004 <filestat+0x4e>

0000000080004014 <fileread>:
    80004014:	7179                	addi	sp,sp,-48
    80004016:	f406                	sd	ra,40(sp)
    80004018:	f022                	sd	s0,32(sp)
    8000401a:	e84a                	sd	s2,16(sp)
    8000401c:	1800                	addi	s0,sp,48
    8000401e:	00854783          	lbu	a5,8(a0)
    80004022:	cfd1                	beqz	a5,800040be <fileread+0xaa>
    80004024:	ec26                	sd	s1,24(sp)
    80004026:	e44e                	sd	s3,8(sp)
    80004028:	84aa                	mv	s1,a0
    8000402a:	89ae                	mv	s3,a1
    8000402c:	8932                	mv	s2,a2
    8000402e:	411c                	lw	a5,0(a0)
    80004030:	4705                	li	a4,1
    80004032:	04e78363          	beq	a5,a4,80004078 <fileread+0x64>
    80004036:	470d                	li	a4,3
    80004038:	04e78763          	beq	a5,a4,80004086 <fileread+0x72>
    8000403c:	4709                	li	a4,2
    8000403e:	06e79a63          	bne	a5,a4,800040b2 <fileread+0x9e>
    80004042:	6d08                	ld	a0,24(a0)
    80004044:	a00ff0ef          	jal	80003244 <ilock>
    80004048:	874a                	mv	a4,s2
    8000404a:	5094                	lw	a3,32(s1)
    8000404c:	864e                	mv	a2,s3
    8000404e:	4585                	li	a1,1
    80004050:	6c88                	ld	a0,24(s1)
    80004052:	c46ff0ef          	jal	80003498 <readi>
    80004056:	892a                	mv	s2,a0
    80004058:	00a05563          	blez	a0,80004062 <fileread+0x4e>
    8000405c:	509c                	lw	a5,32(s1)
    8000405e:	9fa9                	addw	a5,a5,a0
    80004060:	d09c                	sw	a5,32(s1)
    80004062:	6c88                	ld	a0,24(s1)
    80004064:	a8eff0ef          	jal	800032f2 <iunlock>
    80004068:	64e2                	ld	s1,24(sp)
    8000406a:	69a2                	ld	s3,8(sp)
    8000406c:	854a                	mv	a0,s2
    8000406e:	70a2                	ld	ra,40(sp)
    80004070:	7402                	ld	s0,32(sp)
    80004072:	6942                	ld	s2,16(sp)
    80004074:	6145                	addi	sp,sp,48
    80004076:	8082                	ret
    80004078:	6908                	ld	a0,16(a0)
    8000407a:	388000ef          	jal	80004402 <piperead>
    8000407e:	892a                	mv	s2,a0
    80004080:	64e2                	ld	s1,24(sp)
    80004082:	69a2                	ld	s3,8(sp)
    80004084:	b7e5                	j	8000406c <fileread+0x58>
    80004086:	02451783          	lh	a5,36(a0)
    8000408a:	03079693          	slli	a3,a5,0x30
    8000408e:	92c1                	srli	a3,a3,0x30
    80004090:	4725                	li	a4,9
    80004092:	02d76863          	bltu	a4,a3,800040c2 <fileread+0xae>
    80004096:	0792                	slli	a5,a5,0x4
    80004098:	0001e717          	auipc	a4,0x1e
    8000409c:	3f070713          	addi	a4,a4,1008 # 80022488 <devsw>
    800040a0:	97ba                	add	a5,a5,a4
    800040a2:	639c                	ld	a5,0(a5)
    800040a4:	c39d                	beqz	a5,800040ca <fileread+0xb6>
    800040a6:	4505                	li	a0,1
    800040a8:	9782                	jalr	a5
    800040aa:	892a                	mv	s2,a0
    800040ac:	64e2                	ld	s1,24(sp)
    800040ae:	69a2                	ld	s3,8(sp)
    800040b0:	bf75                	j	8000406c <fileread+0x58>
    800040b2:	00003517          	auipc	a0,0x3
    800040b6:	53650513          	addi	a0,a0,1334 # 800075e8 <etext+0x5e8>
    800040ba:	ee8fc0ef          	jal	800007a2 <panic>
    800040be:	597d                	li	s2,-1
    800040c0:	b775                	j	8000406c <fileread+0x58>
    800040c2:	597d                	li	s2,-1
    800040c4:	64e2                	ld	s1,24(sp)
    800040c6:	69a2                	ld	s3,8(sp)
    800040c8:	b755                	j	8000406c <fileread+0x58>
    800040ca:	597d                	li	s2,-1
    800040cc:	64e2                	ld	s1,24(sp)
    800040ce:	69a2                	ld	s3,8(sp)
    800040d0:	bf71                	j	8000406c <fileread+0x58>

00000000800040d2 <filewrite>:
    800040d2:	00954783          	lbu	a5,9(a0)
    800040d6:	10078b63          	beqz	a5,800041ec <filewrite+0x11a>
    800040da:	715d                	addi	sp,sp,-80
    800040dc:	e486                	sd	ra,72(sp)
    800040de:	e0a2                	sd	s0,64(sp)
    800040e0:	f84a                	sd	s2,48(sp)
    800040e2:	f052                	sd	s4,32(sp)
    800040e4:	e85a                	sd	s6,16(sp)
    800040e6:	0880                	addi	s0,sp,80
    800040e8:	892a                	mv	s2,a0
    800040ea:	8b2e                	mv	s6,a1
    800040ec:	8a32                	mv	s4,a2
    800040ee:	411c                	lw	a5,0(a0)
    800040f0:	4705                	li	a4,1
    800040f2:	02e78763          	beq	a5,a4,80004120 <filewrite+0x4e>
    800040f6:	470d                	li	a4,3
    800040f8:	02e78863          	beq	a5,a4,80004128 <filewrite+0x56>
    800040fc:	4709                	li	a4,2
    800040fe:	0ce79c63          	bne	a5,a4,800041d6 <filewrite+0x104>
    80004102:	f44e                	sd	s3,40(sp)
    80004104:	0ac05863          	blez	a2,800041b4 <filewrite+0xe2>
    80004108:	fc26                	sd	s1,56(sp)
    8000410a:	ec56                	sd	s5,24(sp)
    8000410c:	e45e                	sd	s7,8(sp)
    8000410e:	e062                	sd	s8,0(sp)
    80004110:	4981                	li	s3,0
    80004112:	6b85                	lui	s7,0x1
    80004114:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004118:	6c05                	lui	s8,0x1
    8000411a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000411e:	a8b5                	j	8000419a <filewrite+0xc8>
    80004120:	6908                	ld	a0,16(a0)
    80004122:	1fc000ef          	jal	8000431e <pipewrite>
    80004126:	a04d                	j	800041c8 <filewrite+0xf6>
    80004128:	02451783          	lh	a5,36(a0)
    8000412c:	03079693          	slli	a3,a5,0x30
    80004130:	92c1                	srli	a3,a3,0x30
    80004132:	4725                	li	a4,9
    80004134:	0ad76e63          	bltu	a4,a3,800041f0 <filewrite+0x11e>
    80004138:	0792                	slli	a5,a5,0x4
    8000413a:	0001e717          	auipc	a4,0x1e
    8000413e:	34e70713          	addi	a4,a4,846 # 80022488 <devsw>
    80004142:	97ba                	add	a5,a5,a4
    80004144:	679c                	ld	a5,8(a5)
    80004146:	c7dd                	beqz	a5,800041f4 <filewrite+0x122>
    80004148:	4505                	li	a0,1
    8000414a:	9782                	jalr	a5
    8000414c:	a8b5                	j	800041c8 <filewrite+0xf6>
    8000414e:	00048a9b          	sext.w	s5,s1
    80004152:	989ff0ef          	jal	80003ada <begin_op>
    80004156:	01893503          	ld	a0,24(s2)
    8000415a:	8eaff0ef          	jal	80003244 <ilock>
    8000415e:	8756                	mv	a4,s5
    80004160:	02092683          	lw	a3,32(s2)
    80004164:	01698633          	add	a2,s3,s6
    80004168:	4585                	li	a1,1
    8000416a:	01893503          	ld	a0,24(s2)
    8000416e:	c26ff0ef          	jal	80003594 <writei>
    80004172:	84aa                	mv	s1,a0
    80004174:	00a05763          	blez	a0,80004182 <filewrite+0xb0>
    80004178:	02092783          	lw	a5,32(s2)
    8000417c:	9fa9                	addw	a5,a5,a0
    8000417e:	02f92023          	sw	a5,32(s2)
    80004182:	01893503          	ld	a0,24(s2)
    80004186:	96cff0ef          	jal	800032f2 <iunlock>
    8000418a:	9bbff0ef          	jal	80003b44 <end_op>
    8000418e:	029a9563          	bne	s5,s1,800041b8 <filewrite+0xe6>
    80004192:	013489bb          	addw	s3,s1,s3
    80004196:	0149da63          	bge	s3,s4,800041aa <filewrite+0xd8>
    8000419a:	413a04bb          	subw	s1,s4,s3
    8000419e:	0004879b          	sext.w	a5,s1
    800041a2:	fafbd6e3          	bge	s7,a5,8000414e <filewrite+0x7c>
    800041a6:	84e2                	mv	s1,s8
    800041a8:	b75d                	j	8000414e <filewrite+0x7c>
    800041aa:	74e2                	ld	s1,56(sp)
    800041ac:	6ae2                	ld	s5,24(sp)
    800041ae:	6ba2                	ld	s7,8(sp)
    800041b0:	6c02                	ld	s8,0(sp)
    800041b2:	a039                	j	800041c0 <filewrite+0xee>
    800041b4:	4981                	li	s3,0
    800041b6:	a029                	j	800041c0 <filewrite+0xee>
    800041b8:	74e2                	ld	s1,56(sp)
    800041ba:	6ae2                	ld	s5,24(sp)
    800041bc:	6ba2                	ld	s7,8(sp)
    800041be:	6c02                	ld	s8,0(sp)
    800041c0:	033a1c63          	bne	s4,s3,800041f8 <filewrite+0x126>
    800041c4:	8552                	mv	a0,s4
    800041c6:	79a2                	ld	s3,40(sp)
    800041c8:	60a6                	ld	ra,72(sp)
    800041ca:	6406                	ld	s0,64(sp)
    800041cc:	7942                	ld	s2,48(sp)
    800041ce:	7a02                	ld	s4,32(sp)
    800041d0:	6b42                	ld	s6,16(sp)
    800041d2:	6161                	addi	sp,sp,80
    800041d4:	8082                	ret
    800041d6:	fc26                	sd	s1,56(sp)
    800041d8:	f44e                	sd	s3,40(sp)
    800041da:	ec56                	sd	s5,24(sp)
    800041dc:	e45e                	sd	s7,8(sp)
    800041de:	e062                	sd	s8,0(sp)
    800041e0:	00003517          	auipc	a0,0x3
    800041e4:	41850513          	addi	a0,a0,1048 # 800075f8 <etext+0x5f8>
    800041e8:	dbafc0ef          	jal	800007a2 <panic>
    800041ec:	557d                	li	a0,-1
    800041ee:	8082                	ret
    800041f0:	557d                	li	a0,-1
    800041f2:	bfd9                	j	800041c8 <filewrite+0xf6>
    800041f4:	557d                	li	a0,-1
    800041f6:	bfc9                	j	800041c8 <filewrite+0xf6>
    800041f8:	557d                	li	a0,-1
    800041fa:	79a2                	ld	s3,40(sp)
    800041fc:	b7f1                	j	800041c8 <filewrite+0xf6>

00000000800041fe <pipealloc>:
    800041fe:	7179                	addi	sp,sp,-48
    80004200:	f406                	sd	ra,40(sp)
    80004202:	f022                	sd	s0,32(sp)
    80004204:	ec26                	sd	s1,24(sp)
    80004206:	e052                	sd	s4,0(sp)
    80004208:	1800                	addi	s0,sp,48
    8000420a:	84aa                	mv	s1,a0
    8000420c:	8a2e                	mv	s4,a1
    8000420e:	0005b023          	sd	zero,0(a1)
    80004212:	00053023          	sd	zero,0(a0)
    80004216:	c3bff0ef          	jal	80003e50 <filealloc>
    8000421a:	e088                	sd	a0,0(s1)
    8000421c:	c549                	beqz	a0,800042a6 <pipealloc+0xa8>
    8000421e:	c33ff0ef          	jal	80003e50 <filealloc>
    80004222:	00aa3023          	sd	a0,0(s4)
    80004226:	cd25                	beqz	a0,8000429e <pipealloc+0xa0>
    80004228:	e84a                	sd	s2,16(sp)
    8000422a:	909fc0ef          	jal	80000b32 <kalloc>
    8000422e:	892a                	mv	s2,a0
    80004230:	c12d                	beqz	a0,80004292 <pipealloc+0x94>
    80004232:	e44e                	sd	s3,8(sp)
    80004234:	4985                	li	s3,1
    80004236:	23352023          	sw	s3,544(a0)
    8000423a:	23352223          	sw	s3,548(a0)
    8000423e:	20052e23          	sw	zero,540(a0)
    80004242:	20052c23          	sw	zero,536(a0)
    80004246:	00003597          	auipc	a1,0x3
    8000424a:	3c258593          	addi	a1,a1,962 # 80007608 <etext+0x608>
    8000424e:	935fc0ef          	jal	80000b82 <initlock>
    80004252:	609c                	ld	a5,0(s1)
    80004254:	0137a023          	sw	s3,0(a5)
    80004258:	609c                	ld	a5,0(s1)
    8000425a:	01378423          	sb	s3,8(a5)
    8000425e:	609c                	ld	a5,0(s1)
    80004260:	000784a3          	sb	zero,9(a5)
    80004264:	609c                	ld	a5,0(s1)
    80004266:	0127b823          	sd	s2,16(a5)
    8000426a:	000a3783          	ld	a5,0(s4)
    8000426e:	0137a023          	sw	s3,0(a5)
    80004272:	000a3783          	ld	a5,0(s4)
    80004276:	00078423          	sb	zero,8(a5)
    8000427a:	000a3783          	ld	a5,0(s4)
    8000427e:	013784a3          	sb	s3,9(a5)
    80004282:	000a3783          	ld	a5,0(s4)
    80004286:	0127b823          	sd	s2,16(a5)
    8000428a:	4501                	li	a0,0
    8000428c:	6942                	ld	s2,16(sp)
    8000428e:	69a2                	ld	s3,8(sp)
    80004290:	a01d                	j	800042b6 <pipealloc+0xb8>
    80004292:	6088                	ld	a0,0(s1)
    80004294:	c119                	beqz	a0,8000429a <pipealloc+0x9c>
    80004296:	6942                	ld	s2,16(sp)
    80004298:	a029                	j	800042a2 <pipealloc+0xa4>
    8000429a:	6942                	ld	s2,16(sp)
    8000429c:	a029                	j	800042a6 <pipealloc+0xa8>
    8000429e:	6088                	ld	a0,0(s1)
    800042a0:	c10d                	beqz	a0,800042c2 <pipealloc+0xc4>
    800042a2:	c53ff0ef          	jal	80003ef4 <fileclose>
    800042a6:	000a3783          	ld	a5,0(s4)
    800042aa:	557d                	li	a0,-1
    800042ac:	c789                	beqz	a5,800042b6 <pipealloc+0xb8>
    800042ae:	853e                	mv	a0,a5
    800042b0:	c45ff0ef          	jal	80003ef4 <fileclose>
    800042b4:	557d                	li	a0,-1
    800042b6:	70a2                	ld	ra,40(sp)
    800042b8:	7402                	ld	s0,32(sp)
    800042ba:	64e2                	ld	s1,24(sp)
    800042bc:	6a02                	ld	s4,0(sp)
    800042be:	6145                	addi	sp,sp,48
    800042c0:	8082                	ret
    800042c2:	557d                	li	a0,-1
    800042c4:	bfcd                	j	800042b6 <pipealloc+0xb8>

00000000800042c6 <pipeclose>:
    800042c6:	1101                	addi	sp,sp,-32
    800042c8:	ec06                	sd	ra,24(sp)
    800042ca:	e822                	sd	s0,16(sp)
    800042cc:	e426                	sd	s1,8(sp)
    800042ce:	e04a                	sd	s2,0(sp)
    800042d0:	1000                	addi	s0,sp,32
    800042d2:	84aa                	mv	s1,a0
    800042d4:	892e                	mv	s2,a1
    800042d6:	92dfc0ef          	jal	80000c02 <acquire>
    800042da:	02090763          	beqz	s2,80004308 <pipeclose+0x42>
    800042de:	2204a223          	sw	zero,548(s1)
    800042e2:	21848513          	addi	a0,s1,536
    800042e6:	c35fd0ef          	jal	80001f1a <wakeup>
    800042ea:	2204b783          	ld	a5,544(s1)
    800042ee:	e785                	bnez	a5,80004316 <pipeclose+0x50>
    800042f0:	8526                	mv	a0,s1
    800042f2:	9a9fc0ef          	jal	80000c9a <release>
    800042f6:	8526                	mv	a0,s1
    800042f8:	f58fc0ef          	jal	80000a50 <kfree>
    800042fc:	60e2                	ld	ra,24(sp)
    800042fe:	6442                	ld	s0,16(sp)
    80004300:	64a2                	ld	s1,8(sp)
    80004302:	6902                	ld	s2,0(sp)
    80004304:	6105                	addi	sp,sp,32
    80004306:	8082                	ret
    80004308:	2204a023          	sw	zero,544(s1)
    8000430c:	21c48513          	addi	a0,s1,540
    80004310:	c0bfd0ef          	jal	80001f1a <wakeup>
    80004314:	bfd9                	j	800042ea <pipeclose+0x24>
    80004316:	8526                	mv	a0,s1
    80004318:	983fc0ef          	jal	80000c9a <release>
    8000431c:	b7c5                	j	800042fc <pipeclose+0x36>

000000008000431e <pipewrite>:
    8000431e:	711d                	addi	sp,sp,-96
    80004320:	ec86                	sd	ra,88(sp)
    80004322:	e8a2                	sd	s0,80(sp)
    80004324:	e4a6                	sd	s1,72(sp)
    80004326:	e0ca                	sd	s2,64(sp)
    80004328:	fc4e                	sd	s3,56(sp)
    8000432a:	f852                	sd	s4,48(sp)
    8000432c:	f456                	sd	s5,40(sp)
    8000432e:	1080                	addi	s0,sp,96
    80004330:	84aa                	mv	s1,a0
    80004332:	8aae                	mv	s5,a1
    80004334:	8a32                	mv	s4,a2
    80004336:	dcafd0ef          	jal	80001900 <myproc>
    8000433a:	89aa                	mv	s3,a0
    8000433c:	8526                	mv	a0,s1
    8000433e:	8c5fc0ef          	jal	80000c02 <acquire>
    80004342:	0b405a63          	blez	s4,800043f6 <pipewrite+0xd8>
    80004346:	f05a                	sd	s6,32(sp)
    80004348:	ec5e                	sd	s7,24(sp)
    8000434a:	e862                	sd	s8,16(sp)
    8000434c:	4901                	li	s2,0
    8000434e:	5b7d                	li	s6,-1
    80004350:	21848c13          	addi	s8,s1,536
    80004354:	21c48b93          	addi	s7,s1,540
    80004358:	a81d                	j	8000438e <pipewrite+0x70>
    8000435a:	8526                	mv	a0,s1
    8000435c:	93ffc0ef          	jal	80000c9a <release>
    80004360:	597d                	li	s2,-1
    80004362:	7b02                	ld	s6,32(sp)
    80004364:	6be2                	ld	s7,24(sp)
    80004366:	6c42                	ld	s8,16(sp)
    80004368:	854a                	mv	a0,s2
    8000436a:	60e6                	ld	ra,88(sp)
    8000436c:	6446                	ld	s0,80(sp)
    8000436e:	64a6                	ld	s1,72(sp)
    80004370:	6906                	ld	s2,64(sp)
    80004372:	79e2                	ld	s3,56(sp)
    80004374:	7a42                	ld	s4,48(sp)
    80004376:	7aa2                	ld	s5,40(sp)
    80004378:	6125                	addi	sp,sp,96
    8000437a:	8082                	ret
    8000437c:	8562                	mv	a0,s8
    8000437e:	b9dfd0ef          	jal	80001f1a <wakeup>
    80004382:	85a6                	mv	a1,s1
    80004384:	855e                	mv	a0,s7
    80004386:	b49fd0ef          	jal	80001ece <sleep>
    8000438a:	05495b63          	bge	s2,s4,800043e0 <pipewrite+0xc2>
    8000438e:	2204a783          	lw	a5,544(s1)
    80004392:	d7e1                	beqz	a5,8000435a <pipewrite+0x3c>
    80004394:	854e                	mv	a0,s3
    80004396:	d71fd0ef          	jal	80002106 <killed>
    8000439a:	f161                	bnez	a0,8000435a <pipewrite+0x3c>
    8000439c:	2184a783          	lw	a5,536(s1)
    800043a0:	21c4a703          	lw	a4,540(s1)
    800043a4:	2007879b          	addiw	a5,a5,512
    800043a8:	fcf70ae3          	beq	a4,a5,8000437c <pipewrite+0x5e>
    800043ac:	4685                	li	a3,1
    800043ae:	01590633          	add	a2,s2,s5
    800043b2:	faf40593          	addi	a1,s0,-81
    800043b6:	0509b503          	ld	a0,80(s3)
    800043ba:	a8efd0ef          	jal	80001648 <copyin>
    800043be:	03650e63          	beq	a0,s6,800043fa <pipewrite+0xdc>
    800043c2:	21c4a783          	lw	a5,540(s1)
    800043c6:	0017871b          	addiw	a4,a5,1
    800043ca:	20e4ae23          	sw	a4,540(s1)
    800043ce:	1ff7f793          	andi	a5,a5,511
    800043d2:	97a6                	add	a5,a5,s1
    800043d4:	faf44703          	lbu	a4,-81(s0)
    800043d8:	00e78c23          	sb	a4,24(a5)
    800043dc:	2905                	addiw	s2,s2,1
    800043de:	b775                	j	8000438a <pipewrite+0x6c>
    800043e0:	7b02                	ld	s6,32(sp)
    800043e2:	6be2                	ld	s7,24(sp)
    800043e4:	6c42                	ld	s8,16(sp)
    800043e6:	21848513          	addi	a0,s1,536
    800043ea:	b31fd0ef          	jal	80001f1a <wakeup>
    800043ee:	8526                	mv	a0,s1
    800043f0:	8abfc0ef          	jal	80000c9a <release>
    800043f4:	bf95                	j	80004368 <pipewrite+0x4a>
    800043f6:	4901                	li	s2,0
    800043f8:	b7fd                	j	800043e6 <pipewrite+0xc8>
    800043fa:	7b02                	ld	s6,32(sp)
    800043fc:	6be2                	ld	s7,24(sp)
    800043fe:	6c42                	ld	s8,16(sp)
    80004400:	b7dd                	j	800043e6 <pipewrite+0xc8>

0000000080004402 <piperead>:
    80004402:	715d                	addi	sp,sp,-80
    80004404:	e486                	sd	ra,72(sp)
    80004406:	e0a2                	sd	s0,64(sp)
    80004408:	fc26                	sd	s1,56(sp)
    8000440a:	f84a                	sd	s2,48(sp)
    8000440c:	f44e                	sd	s3,40(sp)
    8000440e:	f052                	sd	s4,32(sp)
    80004410:	ec56                	sd	s5,24(sp)
    80004412:	0880                	addi	s0,sp,80
    80004414:	84aa                	mv	s1,a0
    80004416:	892e                	mv	s2,a1
    80004418:	8ab2                	mv	s5,a2
    8000441a:	ce6fd0ef          	jal	80001900 <myproc>
    8000441e:	8a2a                	mv	s4,a0
    80004420:	8526                	mv	a0,s1
    80004422:	fe0fc0ef          	jal	80000c02 <acquire>
    80004426:	2184a703          	lw	a4,536(s1)
    8000442a:	21c4a783          	lw	a5,540(s1)
    8000442e:	21848993          	addi	s3,s1,536
    80004432:	02f71563          	bne	a4,a5,8000445c <piperead+0x5a>
    80004436:	2244a783          	lw	a5,548(s1)
    8000443a:	cb85                	beqz	a5,8000446a <piperead+0x68>
    8000443c:	8552                	mv	a0,s4
    8000443e:	cc9fd0ef          	jal	80002106 <killed>
    80004442:	ed19                	bnez	a0,80004460 <piperead+0x5e>
    80004444:	85a6                	mv	a1,s1
    80004446:	854e                	mv	a0,s3
    80004448:	a87fd0ef          	jal	80001ece <sleep>
    8000444c:	2184a703          	lw	a4,536(s1)
    80004450:	21c4a783          	lw	a5,540(s1)
    80004454:	fef701e3          	beq	a4,a5,80004436 <piperead+0x34>
    80004458:	e85a                	sd	s6,16(sp)
    8000445a:	a809                	j	8000446c <piperead+0x6a>
    8000445c:	e85a                	sd	s6,16(sp)
    8000445e:	a039                	j	8000446c <piperead+0x6a>
    80004460:	8526                	mv	a0,s1
    80004462:	839fc0ef          	jal	80000c9a <release>
    80004466:	59fd                	li	s3,-1
    80004468:	a8b1                	j	800044c4 <piperead+0xc2>
    8000446a:	e85a                	sd	s6,16(sp)
    8000446c:	4981                	li	s3,0
    8000446e:	5b7d                	li	s6,-1
    80004470:	05505263          	blez	s5,800044b4 <piperead+0xb2>
    80004474:	2184a783          	lw	a5,536(s1)
    80004478:	21c4a703          	lw	a4,540(s1)
    8000447c:	02f70c63          	beq	a4,a5,800044b4 <piperead+0xb2>
    80004480:	0017871b          	addiw	a4,a5,1
    80004484:	20e4ac23          	sw	a4,536(s1)
    80004488:	1ff7f793          	andi	a5,a5,511
    8000448c:	97a6                	add	a5,a5,s1
    8000448e:	0187c783          	lbu	a5,24(a5)
    80004492:	faf40fa3          	sb	a5,-65(s0)
    80004496:	4685                	li	a3,1
    80004498:	fbf40613          	addi	a2,s0,-65
    8000449c:	85ca                	mv	a1,s2
    8000449e:	050a3503          	ld	a0,80(s4)
    800044a2:	8d0fd0ef          	jal	80001572 <copyout>
    800044a6:	01650763          	beq	a0,s6,800044b4 <piperead+0xb2>
    800044aa:	2985                	addiw	s3,s3,1
    800044ac:	0905                	addi	s2,s2,1
    800044ae:	fd3a93e3          	bne	s5,s3,80004474 <piperead+0x72>
    800044b2:	89d6                	mv	s3,s5
    800044b4:	21c48513          	addi	a0,s1,540
    800044b8:	a63fd0ef          	jal	80001f1a <wakeup>
    800044bc:	8526                	mv	a0,s1
    800044be:	fdcfc0ef          	jal	80000c9a <release>
    800044c2:	6b42                	ld	s6,16(sp)
    800044c4:	854e                	mv	a0,s3
    800044c6:	60a6                	ld	ra,72(sp)
    800044c8:	6406                	ld	s0,64(sp)
    800044ca:	74e2                	ld	s1,56(sp)
    800044cc:	7942                	ld	s2,48(sp)
    800044ce:	79a2                	ld	s3,40(sp)
    800044d0:	7a02                	ld	s4,32(sp)
    800044d2:	6ae2                	ld	s5,24(sp)
    800044d4:	6161                	addi	sp,sp,80
    800044d6:	8082                	ret

00000000800044d8 <flags2perm>:
    800044d8:	1141                	addi	sp,sp,-16
    800044da:	e422                	sd	s0,8(sp)
    800044dc:	0800                	addi	s0,sp,16
    800044de:	87aa                	mv	a5,a0
    800044e0:	8905                	andi	a0,a0,1
    800044e2:	050e                	slli	a0,a0,0x3
    800044e4:	8b89                	andi	a5,a5,2
    800044e6:	c399                	beqz	a5,800044ec <flags2perm+0x14>
    800044e8:	00456513          	ori	a0,a0,4
    800044ec:	6422                	ld	s0,8(sp)
    800044ee:	0141                	addi	sp,sp,16
    800044f0:	8082                	ret

00000000800044f2 <exec>:
    800044f2:	df010113          	addi	sp,sp,-528
    800044f6:	20113423          	sd	ra,520(sp)
    800044fa:	20813023          	sd	s0,512(sp)
    800044fe:	ffa6                	sd	s1,504(sp)
    80004500:	fbca                	sd	s2,496(sp)
    80004502:	0c00                	addi	s0,sp,528
    80004504:	892a                	mv	s2,a0
    80004506:	dea43c23          	sd	a0,-520(s0)
    8000450a:	e0b43023          	sd	a1,-512(s0)
    8000450e:	bf2fd0ef          	jal	80001900 <myproc>
    80004512:	84aa                	mv	s1,a0
    80004514:	dc6ff0ef          	jal	80003ada <begin_op>
    80004518:	854a                	mv	a0,s2
    8000451a:	c04ff0ef          	jal	8000391e <namei>
    8000451e:	c931                	beqz	a0,80004572 <exec+0x80>
    80004520:	f3d2                	sd	s4,480(sp)
    80004522:	8a2a                	mv	s4,a0
    80004524:	d21fe0ef          	jal	80003244 <ilock>
    80004528:	04000713          	li	a4,64
    8000452c:	4681                	li	a3,0
    8000452e:	e5040613          	addi	a2,s0,-432
    80004532:	4581                	li	a1,0
    80004534:	8552                	mv	a0,s4
    80004536:	f63fe0ef          	jal	80003498 <readi>
    8000453a:	04000793          	li	a5,64
    8000453e:	00f51a63          	bne	a0,a5,80004552 <exec+0x60>
    80004542:	e5042703          	lw	a4,-432(s0)
    80004546:	464c47b7          	lui	a5,0x464c4
    8000454a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000454e:	02f70663          	beq	a4,a5,8000457a <exec+0x88>
    80004552:	8552                	mv	a0,s4
    80004554:	efbfe0ef          	jal	8000344e <iunlockput>
    80004558:	decff0ef          	jal	80003b44 <end_op>
    8000455c:	557d                	li	a0,-1
    8000455e:	7a1e                	ld	s4,480(sp)
    80004560:	20813083          	ld	ra,520(sp)
    80004564:	20013403          	ld	s0,512(sp)
    80004568:	74fe                	ld	s1,504(sp)
    8000456a:	795e                	ld	s2,496(sp)
    8000456c:	21010113          	addi	sp,sp,528
    80004570:	8082                	ret
    80004572:	dd2ff0ef          	jal	80003b44 <end_op>
    80004576:	557d                	li	a0,-1
    80004578:	b7e5                	j	80004560 <exec+0x6e>
    8000457a:	ebda                	sd	s6,464(sp)
    8000457c:	8526                	mv	a0,s1
    8000457e:	c2afd0ef          	jal	800019a8 <proc_pagetable>
    80004582:	8b2a                	mv	s6,a0
    80004584:	2c050b63          	beqz	a0,8000485a <exec+0x368>
    80004588:	f7ce                	sd	s3,488(sp)
    8000458a:	efd6                	sd	s5,472(sp)
    8000458c:	e7de                	sd	s7,456(sp)
    8000458e:	e3e2                	sd	s8,448(sp)
    80004590:	ff66                	sd	s9,440(sp)
    80004592:	fb6a                	sd	s10,432(sp)
    80004594:	e7042d03          	lw	s10,-400(s0)
    80004598:	e8845783          	lhu	a5,-376(s0)
    8000459c:	12078963          	beqz	a5,800046ce <exec+0x1dc>
    800045a0:	f76e                	sd	s11,424(sp)
    800045a2:	4901                	li	s2,0
    800045a4:	4d81                	li	s11,0
    800045a6:	6c85                	lui	s9,0x1
    800045a8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800045ac:	def43823          	sd	a5,-528(s0)
    800045b0:	6a85                	lui	s5,0x1
    800045b2:	a085                	j	80004612 <exec+0x120>
    800045b4:	00003517          	auipc	a0,0x3
    800045b8:	05c50513          	addi	a0,a0,92 # 80007610 <etext+0x610>
    800045bc:	9e6fc0ef          	jal	800007a2 <panic>
    800045c0:	2481                	sext.w	s1,s1
    800045c2:	8726                	mv	a4,s1
    800045c4:	012c06bb          	addw	a3,s8,s2
    800045c8:	4581                	li	a1,0
    800045ca:	8552                	mv	a0,s4
    800045cc:	ecdfe0ef          	jal	80003498 <readi>
    800045d0:	2501                	sext.w	a0,a0
    800045d2:	24a49a63          	bne	s1,a0,80004826 <exec+0x334>
    800045d6:	012a893b          	addw	s2,s5,s2
    800045da:	03397363          	bgeu	s2,s3,80004600 <exec+0x10e>
    800045de:	02091593          	slli	a1,s2,0x20
    800045e2:	9181                	srli	a1,a1,0x20
    800045e4:	95de                	add	a1,a1,s7
    800045e6:	855a                	mv	a0,s6
    800045e8:	9fdfc0ef          	jal	80000fe4 <walkaddr>
    800045ec:	862a                	mv	a2,a0
    800045ee:	d179                	beqz	a0,800045b4 <exec+0xc2>
    800045f0:	412984bb          	subw	s1,s3,s2
    800045f4:	0004879b          	sext.w	a5,s1
    800045f8:	fcfcf4e3          	bgeu	s9,a5,800045c0 <exec+0xce>
    800045fc:	84d6                	mv	s1,s5
    800045fe:	b7c9                	j	800045c0 <exec+0xce>
    80004600:	e0843903          	ld	s2,-504(s0)
    80004604:	2d85                	addiw	s11,s11,1
    80004606:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    8000460a:	e8845783          	lhu	a5,-376(s0)
    8000460e:	08fdd063          	bge	s11,a5,8000468e <exec+0x19c>
    80004612:	2d01                	sext.w	s10,s10
    80004614:	03800713          	li	a4,56
    80004618:	86ea                	mv	a3,s10
    8000461a:	e1840613          	addi	a2,s0,-488
    8000461e:	4581                	li	a1,0
    80004620:	8552                	mv	a0,s4
    80004622:	e77fe0ef          	jal	80003498 <readi>
    80004626:	03800793          	li	a5,56
    8000462a:	1cf51663          	bne	a0,a5,800047f6 <exec+0x304>
    8000462e:	e1842783          	lw	a5,-488(s0)
    80004632:	4705                	li	a4,1
    80004634:	fce798e3          	bne	a5,a4,80004604 <exec+0x112>
    80004638:	e4043483          	ld	s1,-448(s0)
    8000463c:	e3843783          	ld	a5,-456(s0)
    80004640:	1af4ef63          	bltu	s1,a5,800047fe <exec+0x30c>
    80004644:	e2843783          	ld	a5,-472(s0)
    80004648:	94be                	add	s1,s1,a5
    8000464a:	1af4ee63          	bltu	s1,a5,80004806 <exec+0x314>
    8000464e:	df043703          	ld	a4,-528(s0)
    80004652:	8ff9                	and	a5,a5,a4
    80004654:	1a079d63          	bnez	a5,8000480e <exec+0x31c>
    80004658:	e1c42503          	lw	a0,-484(s0)
    8000465c:	e7dff0ef          	jal	800044d8 <flags2perm>
    80004660:	86aa                	mv	a3,a0
    80004662:	8626                	mv	a2,s1
    80004664:	85ca                	mv	a1,s2
    80004666:	855a                	mv	a0,s6
    80004668:	cf7fc0ef          	jal	8000135e <uvmalloc>
    8000466c:	e0a43423          	sd	a0,-504(s0)
    80004670:	1a050363          	beqz	a0,80004816 <exec+0x324>
    80004674:	e2843b83          	ld	s7,-472(s0)
    80004678:	e2042c03          	lw	s8,-480(s0)
    8000467c:	e3842983          	lw	s3,-456(s0)
    80004680:	00098463          	beqz	s3,80004688 <exec+0x196>
    80004684:	4901                	li	s2,0
    80004686:	bfa1                	j	800045de <exec+0xec>
    80004688:	e0843903          	ld	s2,-504(s0)
    8000468c:	bfa5                	j	80004604 <exec+0x112>
    8000468e:	7dba                	ld	s11,424(sp)
    80004690:	8552                	mv	a0,s4
    80004692:	dbdfe0ef          	jal	8000344e <iunlockput>
    80004696:	caeff0ef          	jal	80003b44 <end_op>
    8000469a:	a66fd0ef          	jal	80001900 <myproc>
    8000469e:	8aaa                	mv	s5,a0
    800046a0:	04853c83          	ld	s9,72(a0)
    800046a4:	6985                	lui	s3,0x1
    800046a6:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800046a8:	99ca                	add	s3,s3,s2
    800046aa:	77fd                	lui	a5,0xfffff
    800046ac:	00f9f9b3          	and	s3,s3,a5
    800046b0:	4691                	li	a3,4
    800046b2:	6609                	lui	a2,0x2
    800046b4:	964e                	add	a2,a2,s3
    800046b6:	85ce                	mv	a1,s3
    800046b8:	855a                	mv	a0,s6
    800046ba:	ca5fc0ef          	jal	8000135e <uvmalloc>
    800046be:	892a                	mv	s2,a0
    800046c0:	e0a43423          	sd	a0,-504(s0)
    800046c4:	e519                	bnez	a0,800046d2 <exec+0x1e0>
    800046c6:	e1343423          	sd	s3,-504(s0)
    800046ca:	4a01                	li	s4,0
    800046cc:	aab1                	j	80004828 <exec+0x336>
    800046ce:	4901                	li	s2,0
    800046d0:	b7c1                	j	80004690 <exec+0x19e>
    800046d2:	75f9                	lui	a1,0xffffe
    800046d4:	95aa                	add	a1,a1,a0
    800046d6:	855a                	mv	a0,s6
    800046d8:	e71fc0ef          	jal	80001548 <uvmclear>
    800046dc:	7bfd                	lui	s7,0xfffff
    800046de:	9bca                	add	s7,s7,s2
    800046e0:	e0043783          	ld	a5,-512(s0)
    800046e4:	6388                	ld	a0,0(a5)
    800046e6:	cd39                	beqz	a0,80004744 <exec+0x252>
    800046e8:	e9040993          	addi	s3,s0,-368
    800046ec:	f9040c13          	addi	s8,s0,-112
    800046f0:	4481                	li	s1,0
    800046f2:	f54fc0ef          	jal	80000e46 <strlen>
    800046f6:	0015079b          	addiw	a5,a0,1
    800046fa:	40f907b3          	sub	a5,s2,a5
    800046fe:	ff07f913          	andi	s2,a5,-16
    80004702:	11796e63          	bltu	s2,s7,8000481e <exec+0x32c>
    80004706:	e0043d03          	ld	s10,-512(s0)
    8000470a:	000d3a03          	ld	s4,0(s10)
    8000470e:	8552                	mv	a0,s4
    80004710:	f36fc0ef          	jal	80000e46 <strlen>
    80004714:	0015069b          	addiw	a3,a0,1
    80004718:	8652                	mv	a2,s4
    8000471a:	85ca                	mv	a1,s2
    8000471c:	855a                	mv	a0,s6
    8000471e:	e55fc0ef          	jal	80001572 <copyout>
    80004722:	10054063          	bltz	a0,80004822 <exec+0x330>
    80004726:	0129b023          	sd	s2,0(s3)
    8000472a:	0485                	addi	s1,s1,1
    8000472c:	008d0793          	addi	a5,s10,8
    80004730:	e0f43023          	sd	a5,-512(s0)
    80004734:	008d3503          	ld	a0,8(s10)
    80004738:	c909                	beqz	a0,8000474a <exec+0x258>
    8000473a:	09a1                	addi	s3,s3,8
    8000473c:	fb899be3          	bne	s3,s8,800046f2 <exec+0x200>
    80004740:	4a01                	li	s4,0
    80004742:	a0dd                	j	80004828 <exec+0x336>
    80004744:	e0843903          	ld	s2,-504(s0)
    80004748:	4481                	li	s1,0
    8000474a:	00349793          	slli	a5,s1,0x3
    8000474e:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb970>
    80004752:	97a2                	add	a5,a5,s0
    80004754:	f007b023          	sd	zero,-256(a5)
    80004758:	00148693          	addi	a3,s1,1
    8000475c:	068e                	slli	a3,a3,0x3
    8000475e:	40d90933          	sub	s2,s2,a3
    80004762:	ff097913          	andi	s2,s2,-16
    80004766:	e0843983          	ld	s3,-504(s0)
    8000476a:	f5796ee3          	bltu	s2,s7,800046c6 <exec+0x1d4>
    8000476e:	e9040613          	addi	a2,s0,-368
    80004772:	85ca                	mv	a1,s2
    80004774:	855a                	mv	a0,s6
    80004776:	dfdfc0ef          	jal	80001572 <copyout>
    8000477a:	0e054263          	bltz	a0,8000485e <exec+0x36c>
    8000477e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004782:	0727bc23          	sd	s2,120(a5)
    80004786:	df843783          	ld	a5,-520(s0)
    8000478a:	0007c703          	lbu	a4,0(a5)
    8000478e:	cf11                	beqz	a4,800047aa <exec+0x2b8>
    80004790:	0785                	addi	a5,a5,1
    80004792:	02f00693          	li	a3,47
    80004796:	a039                	j	800047a4 <exec+0x2b2>
    80004798:	def43c23          	sd	a5,-520(s0)
    8000479c:	0785                	addi	a5,a5,1
    8000479e:	fff7c703          	lbu	a4,-1(a5)
    800047a2:	c701                	beqz	a4,800047aa <exec+0x2b8>
    800047a4:	fed71ce3          	bne	a4,a3,8000479c <exec+0x2aa>
    800047a8:	bfc5                	j	80004798 <exec+0x2a6>
    800047aa:	4641                	li	a2,16
    800047ac:	df843583          	ld	a1,-520(s0)
    800047b0:	158a8513          	addi	a0,s5,344
    800047b4:	e60fc0ef          	jal	80000e14 <safestrcpy>
    800047b8:	050ab503          	ld	a0,80(s5)
    800047bc:	056ab823          	sd	s6,80(s5)
    800047c0:	e0843783          	ld	a5,-504(s0)
    800047c4:	04fab423          	sd	a5,72(s5)
    800047c8:	058ab783          	ld	a5,88(s5)
    800047cc:	e6843703          	ld	a4,-408(s0)
    800047d0:	ef98                	sd	a4,24(a5)
    800047d2:	058ab783          	ld	a5,88(s5)
    800047d6:	0327b823          	sd	s2,48(a5)
    800047da:	85e6                	mv	a1,s9
    800047dc:	a50fd0ef          	jal	80001a2c <proc_freepagetable>
    800047e0:	0004851b          	sext.w	a0,s1
    800047e4:	79be                	ld	s3,488(sp)
    800047e6:	7a1e                	ld	s4,480(sp)
    800047e8:	6afe                	ld	s5,472(sp)
    800047ea:	6b5e                	ld	s6,464(sp)
    800047ec:	6bbe                	ld	s7,456(sp)
    800047ee:	6c1e                	ld	s8,448(sp)
    800047f0:	7cfa                	ld	s9,440(sp)
    800047f2:	7d5a                	ld	s10,432(sp)
    800047f4:	b3b5                	j	80004560 <exec+0x6e>
    800047f6:	e1243423          	sd	s2,-504(s0)
    800047fa:	7dba                	ld	s11,424(sp)
    800047fc:	a035                	j	80004828 <exec+0x336>
    800047fe:	e1243423          	sd	s2,-504(s0)
    80004802:	7dba                	ld	s11,424(sp)
    80004804:	a015                	j	80004828 <exec+0x336>
    80004806:	e1243423          	sd	s2,-504(s0)
    8000480a:	7dba                	ld	s11,424(sp)
    8000480c:	a831                	j	80004828 <exec+0x336>
    8000480e:	e1243423          	sd	s2,-504(s0)
    80004812:	7dba                	ld	s11,424(sp)
    80004814:	a811                	j	80004828 <exec+0x336>
    80004816:	e1243423          	sd	s2,-504(s0)
    8000481a:	7dba                	ld	s11,424(sp)
    8000481c:	a031                	j	80004828 <exec+0x336>
    8000481e:	4a01                	li	s4,0
    80004820:	a021                	j	80004828 <exec+0x336>
    80004822:	4a01                	li	s4,0
    80004824:	a011                	j	80004828 <exec+0x336>
    80004826:	7dba                	ld	s11,424(sp)
    80004828:	e0843583          	ld	a1,-504(s0)
    8000482c:	855a                	mv	a0,s6
    8000482e:	9fefd0ef          	jal	80001a2c <proc_freepagetable>
    80004832:	557d                	li	a0,-1
    80004834:	000a1b63          	bnez	s4,8000484a <exec+0x358>
    80004838:	79be                	ld	s3,488(sp)
    8000483a:	7a1e                	ld	s4,480(sp)
    8000483c:	6afe                	ld	s5,472(sp)
    8000483e:	6b5e                	ld	s6,464(sp)
    80004840:	6bbe                	ld	s7,456(sp)
    80004842:	6c1e                	ld	s8,448(sp)
    80004844:	7cfa                	ld	s9,440(sp)
    80004846:	7d5a                	ld	s10,432(sp)
    80004848:	bb21                	j	80004560 <exec+0x6e>
    8000484a:	79be                	ld	s3,488(sp)
    8000484c:	6afe                	ld	s5,472(sp)
    8000484e:	6b5e                	ld	s6,464(sp)
    80004850:	6bbe                	ld	s7,456(sp)
    80004852:	6c1e                	ld	s8,448(sp)
    80004854:	7cfa                	ld	s9,440(sp)
    80004856:	7d5a                	ld	s10,432(sp)
    80004858:	b9ed                	j	80004552 <exec+0x60>
    8000485a:	6b5e                	ld	s6,464(sp)
    8000485c:	b9dd                	j	80004552 <exec+0x60>
    8000485e:	e0843983          	ld	s3,-504(s0)
    80004862:	b595                	j	800046c6 <exec+0x1d4>

0000000080004864 <argfd>:
    80004864:	7179                	addi	sp,sp,-48
    80004866:	f406                	sd	ra,40(sp)
    80004868:	f022                	sd	s0,32(sp)
    8000486a:	ec26                	sd	s1,24(sp)
    8000486c:	e84a                	sd	s2,16(sp)
    8000486e:	1800                	addi	s0,sp,48
    80004870:	892e                	mv	s2,a1
    80004872:	84b2                	mv	s1,a2
    80004874:	fdc40593          	addi	a1,s0,-36
    80004878:	f3dfd0ef          	jal	800027b4 <argint>
    8000487c:	fdc42703          	lw	a4,-36(s0)
    80004880:	47bd                	li	a5,15
    80004882:	02e7e963          	bltu	a5,a4,800048b4 <argfd+0x50>
    80004886:	87afd0ef          	jal	80001900 <myproc>
    8000488a:	fdc42703          	lw	a4,-36(s0)
    8000488e:	01a70793          	addi	a5,a4,26
    80004892:	078e                	slli	a5,a5,0x3
    80004894:	953e                	add	a0,a0,a5
    80004896:	611c                	ld	a5,0(a0)
    80004898:	c385                	beqz	a5,800048b8 <argfd+0x54>
    8000489a:	00090463          	beqz	s2,800048a2 <argfd+0x3e>
    8000489e:	00e92023          	sw	a4,0(s2)
    800048a2:	4501                	li	a0,0
    800048a4:	c091                	beqz	s1,800048a8 <argfd+0x44>
    800048a6:	e09c                	sd	a5,0(s1)
    800048a8:	70a2                	ld	ra,40(sp)
    800048aa:	7402                	ld	s0,32(sp)
    800048ac:	64e2                	ld	s1,24(sp)
    800048ae:	6942                	ld	s2,16(sp)
    800048b0:	6145                	addi	sp,sp,48
    800048b2:	8082                	ret
    800048b4:	557d                	li	a0,-1
    800048b6:	bfcd                	j	800048a8 <argfd+0x44>
    800048b8:	557d                	li	a0,-1
    800048ba:	b7fd                	j	800048a8 <argfd+0x44>

00000000800048bc <fdalloc>:
    800048bc:	1101                	addi	sp,sp,-32
    800048be:	ec06                	sd	ra,24(sp)
    800048c0:	e822                	sd	s0,16(sp)
    800048c2:	e426                	sd	s1,8(sp)
    800048c4:	1000                	addi	s0,sp,32
    800048c6:	84aa                	mv	s1,a0
    800048c8:	838fd0ef          	jal	80001900 <myproc>
    800048cc:	862a                	mv	a2,a0
    800048ce:	0d050793          	addi	a5,a0,208
    800048d2:	4501                	li	a0,0
    800048d4:	46c1                	li	a3,16
    800048d6:	6398                	ld	a4,0(a5)
    800048d8:	cb19                	beqz	a4,800048ee <fdalloc+0x32>
    800048da:	2505                	addiw	a0,a0,1
    800048dc:	07a1                	addi	a5,a5,8
    800048de:	fed51ce3          	bne	a0,a3,800048d6 <fdalloc+0x1a>
    800048e2:	557d                	li	a0,-1
    800048e4:	60e2                	ld	ra,24(sp)
    800048e6:	6442                	ld	s0,16(sp)
    800048e8:	64a2                	ld	s1,8(sp)
    800048ea:	6105                	addi	sp,sp,32
    800048ec:	8082                	ret
    800048ee:	01a50793          	addi	a5,a0,26
    800048f2:	078e                	slli	a5,a5,0x3
    800048f4:	963e                	add	a2,a2,a5
    800048f6:	e204                	sd	s1,0(a2)
    800048f8:	b7f5                	j	800048e4 <fdalloc+0x28>

00000000800048fa <create>:
    800048fa:	715d                	addi	sp,sp,-80
    800048fc:	e486                	sd	ra,72(sp)
    800048fe:	e0a2                	sd	s0,64(sp)
    80004900:	fc26                	sd	s1,56(sp)
    80004902:	f84a                	sd	s2,48(sp)
    80004904:	f44e                	sd	s3,40(sp)
    80004906:	ec56                	sd	s5,24(sp)
    80004908:	e85a                	sd	s6,16(sp)
    8000490a:	0880                	addi	s0,sp,80
    8000490c:	8b2e                	mv	s6,a1
    8000490e:	89b2                	mv	s3,a2
    80004910:	8936                	mv	s2,a3
    80004912:	fb040593          	addi	a1,s0,-80
    80004916:	822ff0ef          	jal	80003938 <nameiparent>
    8000491a:	84aa                	mv	s1,a0
    8000491c:	10050a63          	beqz	a0,80004a30 <create+0x136>
    80004920:	925fe0ef          	jal	80003244 <ilock>
    80004924:	4601                	li	a2,0
    80004926:	fb040593          	addi	a1,s0,-80
    8000492a:	8526                	mv	a0,s1
    8000492c:	d8dfe0ef          	jal	800036b8 <dirlookup>
    80004930:	8aaa                	mv	s5,a0
    80004932:	c129                	beqz	a0,80004974 <create+0x7a>
    80004934:	8526                	mv	a0,s1
    80004936:	b19fe0ef          	jal	8000344e <iunlockput>
    8000493a:	8556                	mv	a0,s5
    8000493c:	909fe0ef          	jal	80003244 <ilock>
    80004940:	4789                	li	a5,2
    80004942:	02fb1463          	bne	s6,a5,8000496a <create+0x70>
    80004946:	044ad783          	lhu	a5,68(s5)
    8000494a:	37f9                	addiw	a5,a5,-2
    8000494c:	17c2                	slli	a5,a5,0x30
    8000494e:	93c1                	srli	a5,a5,0x30
    80004950:	4705                	li	a4,1
    80004952:	00f76c63          	bltu	a4,a5,8000496a <create+0x70>
    80004956:	8556                	mv	a0,s5
    80004958:	60a6                	ld	ra,72(sp)
    8000495a:	6406                	ld	s0,64(sp)
    8000495c:	74e2                	ld	s1,56(sp)
    8000495e:	7942                	ld	s2,48(sp)
    80004960:	79a2                	ld	s3,40(sp)
    80004962:	6ae2                	ld	s5,24(sp)
    80004964:	6b42                	ld	s6,16(sp)
    80004966:	6161                	addi	sp,sp,80
    80004968:	8082                	ret
    8000496a:	8556                	mv	a0,s5
    8000496c:	ae3fe0ef          	jal	8000344e <iunlockput>
    80004970:	4a81                	li	s5,0
    80004972:	b7d5                	j	80004956 <create+0x5c>
    80004974:	f052                	sd	s4,32(sp)
    80004976:	85da                	mv	a1,s6
    80004978:	4088                	lw	a0,0(s1)
    8000497a:	f5afe0ef          	jal	800030d4 <ialloc>
    8000497e:	8a2a                	mv	s4,a0
    80004980:	cd15                	beqz	a0,800049bc <create+0xc2>
    80004982:	8c3fe0ef          	jal	80003244 <ilock>
    80004986:	053a1323          	sh	s3,70(s4)
    8000498a:	052a1423          	sh	s2,72(s4)
    8000498e:	4905                	li	s2,1
    80004990:	052a1523          	sh	s2,74(s4)
    80004994:	8552                	mv	a0,s4
    80004996:	ffafe0ef          	jal	80003190 <iupdate>
    8000499a:	032b0763          	beq	s6,s2,800049c8 <create+0xce>
    8000499e:	004a2603          	lw	a2,4(s4)
    800049a2:	fb040593          	addi	a1,s0,-80
    800049a6:	8526                	mv	a0,s1
    800049a8:	eddfe0ef          	jal	80003884 <dirlink>
    800049ac:	06054563          	bltz	a0,80004a16 <create+0x11c>
    800049b0:	8526                	mv	a0,s1
    800049b2:	a9dfe0ef          	jal	8000344e <iunlockput>
    800049b6:	8ad2                	mv	s5,s4
    800049b8:	7a02                	ld	s4,32(sp)
    800049ba:	bf71                	j	80004956 <create+0x5c>
    800049bc:	8526                	mv	a0,s1
    800049be:	a91fe0ef          	jal	8000344e <iunlockput>
    800049c2:	8ad2                	mv	s5,s4
    800049c4:	7a02                	ld	s4,32(sp)
    800049c6:	bf41                	j	80004956 <create+0x5c>
    800049c8:	004a2603          	lw	a2,4(s4)
    800049cc:	00003597          	auipc	a1,0x3
    800049d0:	c6458593          	addi	a1,a1,-924 # 80007630 <etext+0x630>
    800049d4:	8552                	mv	a0,s4
    800049d6:	eaffe0ef          	jal	80003884 <dirlink>
    800049da:	02054e63          	bltz	a0,80004a16 <create+0x11c>
    800049de:	40d0                	lw	a2,4(s1)
    800049e0:	00003597          	auipc	a1,0x3
    800049e4:	c5858593          	addi	a1,a1,-936 # 80007638 <etext+0x638>
    800049e8:	8552                	mv	a0,s4
    800049ea:	e9bfe0ef          	jal	80003884 <dirlink>
    800049ee:	02054463          	bltz	a0,80004a16 <create+0x11c>
    800049f2:	004a2603          	lw	a2,4(s4)
    800049f6:	fb040593          	addi	a1,s0,-80
    800049fa:	8526                	mv	a0,s1
    800049fc:	e89fe0ef          	jal	80003884 <dirlink>
    80004a00:	00054b63          	bltz	a0,80004a16 <create+0x11c>
    80004a04:	04a4d783          	lhu	a5,74(s1)
    80004a08:	2785                	addiw	a5,a5,1
    80004a0a:	04f49523          	sh	a5,74(s1)
    80004a0e:	8526                	mv	a0,s1
    80004a10:	f80fe0ef          	jal	80003190 <iupdate>
    80004a14:	bf71                	j	800049b0 <create+0xb6>
    80004a16:	040a1523          	sh	zero,74(s4)
    80004a1a:	8552                	mv	a0,s4
    80004a1c:	f74fe0ef          	jal	80003190 <iupdate>
    80004a20:	8552                	mv	a0,s4
    80004a22:	a2dfe0ef          	jal	8000344e <iunlockput>
    80004a26:	8526                	mv	a0,s1
    80004a28:	a27fe0ef          	jal	8000344e <iunlockput>
    80004a2c:	7a02                	ld	s4,32(sp)
    80004a2e:	b725                	j	80004956 <create+0x5c>
    80004a30:	8aaa                	mv	s5,a0
    80004a32:	b715                	j	80004956 <create+0x5c>

0000000080004a34 <sys_dup>:
    80004a34:	7179                	addi	sp,sp,-48
    80004a36:	f406                	sd	ra,40(sp)
    80004a38:	f022                	sd	s0,32(sp)
    80004a3a:	1800                	addi	s0,sp,48
    80004a3c:	fd840613          	addi	a2,s0,-40
    80004a40:	4581                	li	a1,0
    80004a42:	4501                	li	a0,0
    80004a44:	e21ff0ef          	jal	80004864 <argfd>
    80004a48:	57fd                	li	a5,-1
    80004a4a:	02054363          	bltz	a0,80004a70 <sys_dup+0x3c>
    80004a4e:	ec26                	sd	s1,24(sp)
    80004a50:	e84a                	sd	s2,16(sp)
    80004a52:	fd843903          	ld	s2,-40(s0)
    80004a56:	854a                	mv	a0,s2
    80004a58:	e65ff0ef          	jal	800048bc <fdalloc>
    80004a5c:	84aa                	mv	s1,a0
    80004a5e:	57fd                	li	a5,-1
    80004a60:	00054d63          	bltz	a0,80004a7a <sys_dup+0x46>
    80004a64:	854a                	mv	a0,s2
    80004a66:	c48ff0ef          	jal	80003eae <filedup>
    80004a6a:	87a6                	mv	a5,s1
    80004a6c:	64e2                	ld	s1,24(sp)
    80004a6e:	6942                	ld	s2,16(sp)
    80004a70:	853e                	mv	a0,a5
    80004a72:	70a2                	ld	ra,40(sp)
    80004a74:	7402                	ld	s0,32(sp)
    80004a76:	6145                	addi	sp,sp,48
    80004a78:	8082                	ret
    80004a7a:	64e2                	ld	s1,24(sp)
    80004a7c:	6942                	ld	s2,16(sp)
    80004a7e:	bfcd                	j	80004a70 <sys_dup+0x3c>

0000000080004a80 <sys_read>:
    80004a80:	7179                	addi	sp,sp,-48
    80004a82:	f406                	sd	ra,40(sp)
    80004a84:	f022                	sd	s0,32(sp)
    80004a86:	1800                	addi	s0,sp,48
    80004a88:	fd840593          	addi	a1,s0,-40
    80004a8c:	4505                	li	a0,1
    80004a8e:	d43fd0ef          	jal	800027d0 <argaddr>
    80004a92:	fe440593          	addi	a1,s0,-28
    80004a96:	4509                	li	a0,2
    80004a98:	d1dfd0ef          	jal	800027b4 <argint>
    80004a9c:	fe840613          	addi	a2,s0,-24
    80004aa0:	4581                	li	a1,0
    80004aa2:	4501                	li	a0,0
    80004aa4:	dc1ff0ef          	jal	80004864 <argfd>
    80004aa8:	87aa                	mv	a5,a0
    80004aaa:	557d                	li	a0,-1
    80004aac:	0007ca63          	bltz	a5,80004ac0 <sys_read+0x40>
    80004ab0:	fe442603          	lw	a2,-28(s0)
    80004ab4:	fd843583          	ld	a1,-40(s0)
    80004ab8:	fe843503          	ld	a0,-24(s0)
    80004abc:	d58ff0ef          	jal	80004014 <fileread>
    80004ac0:	70a2                	ld	ra,40(sp)
    80004ac2:	7402                	ld	s0,32(sp)
    80004ac4:	6145                	addi	sp,sp,48
    80004ac6:	8082                	ret

0000000080004ac8 <sys_write>:
    80004ac8:	7179                	addi	sp,sp,-48
    80004aca:	f406                	sd	ra,40(sp)
    80004acc:	f022                	sd	s0,32(sp)
    80004ace:	1800                	addi	s0,sp,48
    80004ad0:	fd840593          	addi	a1,s0,-40
    80004ad4:	4505                	li	a0,1
    80004ad6:	cfbfd0ef          	jal	800027d0 <argaddr>
    80004ada:	fe440593          	addi	a1,s0,-28
    80004ade:	4509                	li	a0,2
    80004ae0:	cd5fd0ef          	jal	800027b4 <argint>
    80004ae4:	fe840613          	addi	a2,s0,-24
    80004ae8:	4581                	li	a1,0
    80004aea:	4501                	li	a0,0
    80004aec:	d79ff0ef          	jal	80004864 <argfd>
    80004af0:	87aa                	mv	a5,a0
    80004af2:	557d                	li	a0,-1
    80004af4:	0007ca63          	bltz	a5,80004b08 <sys_write+0x40>
    80004af8:	fe442603          	lw	a2,-28(s0)
    80004afc:	fd843583          	ld	a1,-40(s0)
    80004b00:	fe843503          	ld	a0,-24(s0)
    80004b04:	dceff0ef          	jal	800040d2 <filewrite>
    80004b08:	70a2                	ld	ra,40(sp)
    80004b0a:	7402                	ld	s0,32(sp)
    80004b0c:	6145                	addi	sp,sp,48
    80004b0e:	8082                	ret

0000000080004b10 <sys_close>:
    80004b10:	1101                	addi	sp,sp,-32
    80004b12:	ec06                	sd	ra,24(sp)
    80004b14:	e822                	sd	s0,16(sp)
    80004b16:	1000                	addi	s0,sp,32
    80004b18:	fe040613          	addi	a2,s0,-32
    80004b1c:	fec40593          	addi	a1,s0,-20
    80004b20:	4501                	li	a0,0
    80004b22:	d43ff0ef          	jal	80004864 <argfd>
    80004b26:	57fd                	li	a5,-1
    80004b28:	02054063          	bltz	a0,80004b48 <sys_close+0x38>
    80004b2c:	dd5fc0ef          	jal	80001900 <myproc>
    80004b30:	fec42783          	lw	a5,-20(s0)
    80004b34:	07e9                	addi	a5,a5,26
    80004b36:	078e                	slli	a5,a5,0x3
    80004b38:	953e                	add	a0,a0,a5
    80004b3a:	00053023          	sd	zero,0(a0)
    80004b3e:	fe043503          	ld	a0,-32(s0)
    80004b42:	bb2ff0ef          	jal	80003ef4 <fileclose>
    80004b46:	4781                	li	a5,0
    80004b48:	853e                	mv	a0,a5
    80004b4a:	60e2                	ld	ra,24(sp)
    80004b4c:	6442                	ld	s0,16(sp)
    80004b4e:	6105                	addi	sp,sp,32
    80004b50:	8082                	ret

0000000080004b52 <sys_fstat>:
    80004b52:	1101                	addi	sp,sp,-32
    80004b54:	ec06                	sd	ra,24(sp)
    80004b56:	e822                	sd	s0,16(sp)
    80004b58:	1000                	addi	s0,sp,32
    80004b5a:	fe040593          	addi	a1,s0,-32
    80004b5e:	4505                	li	a0,1
    80004b60:	c71fd0ef          	jal	800027d0 <argaddr>
    80004b64:	fe840613          	addi	a2,s0,-24
    80004b68:	4581                	li	a1,0
    80004b6a:	4501                	li	a0,0
    80004b6c:	cf9ff0ef          	jal	80004864 <argfd>
    80004b70:	87aa                	mv	a5,a0
    80004b72:	557d                	li	a0,-1
    80004b74:	0007c863          	bltz	a5,80004b84 <sys_fstat+0x32>
    80004b78:	fe043583          	ld	a1,-32(s0)
    80004b7c:	fe843503          	ld	a0,-24(s0)
    80004b80:	c36ff0ef          	jal	80003fb6 <filestat>
    80004b84:	60e2                	ld	ra,24(sp)
    80004b86:	6442                	ld	s0,16(sp)
    80004b88:	6105                	addi	sp,sp,32
    80004b8a:	8082                	ret

0000000080004b8c <sys_link>:
    80004b8c:	7169                	addi	sp,sp,-304
    80004b8e:	f606                	sd	ra,296(sp)
    80004b90:	f222                	sd	s0,288(sp)
    80004b92:	1a00                	addi	s0,sp,304
    80004b94:	08000613          	li	a2,128
    80004b98:	ed040593          	addi	a1,s0,-304
    80004b9c:	4501                	li	a0,0
    80004b9e:	c4ffd0ef          	jal	800027ec <argstr>
    80004ba2:	57fd                	li	a5,-1
    80004ba4:	0c054e63          	bltz	a0,80004c80 <sys_link+0xf4>
    80004ba8:	08000613          	li	a2,128
    80004bac:	f5040593          	addi	a1,s0,-176
    80004bb0:	4505                	li	a0,1
    80004bb2:	c3bfd0ef          	jal	800027ec <argstr>
    80004bb6:	57fd                	li	a5,-1
    80004bb8:	0c054463          	bltz	a0,80004c80 <sys_link+0xf4>
    80004bbc:	ee26                	sd	s1,280(sp)
    80004bbe:	f1dfe0ef          	jal	80003ada <begin_op>
    80004bc2:	ed040513          	addi	a0,s0,-304
    80004bc6:	d59fe0ef          	jal	8000391e <namei>
    80004bca:	84aa                	mv	s1,a0
    80004bcc:	c53d                	beqz	a0,80004c3a <sys_link+0xae>
    80004bce:	e76fe0ef          	jal	80003244 <ilock>
    80004bd2:	04449703          	lh	a4,68(s1)
    80004bd6:	4785                	li	a5,1
    80004bd8:	06f70663          	beq	a4,a5,80004c44 <sys_link+0xb8>
    80004bdc:	ea4a                	sd	s2,272(sp)
    80004bde:	04a4d783          	lhu	a5,74(s1)
    80004be2:	2785                	addiw	a5,a5,1
    80004be4:	04f49523          	sh	a5,74(s1)
    80004be8:	8526                	mv	a0,s1
    80004bea:	da6fe0ef          	jal	80003190 <iupdate>
    80004bee:	8526                	mv	a0,s1
    80004bf0:	f02fe0ef          	jal	800032f2 <iunlock>
    80004bf4:	fd040593          	addi	a1,s0,-48
    80004bf8:	f5040513          	addi	a0,s0,-176
    80004bfc:	d3dfe0ef          	jal	80003938 <nameiparent>
    80004c00:	892a                	mv	s2,a0
    80004c02:	cd21                	beqz	a0,80004c5a <sys_link+0xce>
    80004c04:	e40fe0ef          	jal	80003244 <ilock>
    80004c08:	00092703          	lw	a4,0(s2)
    80004c0c:	409c                	lw	a5,0(s1)
    80004c0e:	04f71363          	bne	a4,a5,80004c54 <sys_link+0xc8>
    80004c12:	40d0                	lw	a2,4(s1)
    80004c14:	fd040593          	addi	a1,s0,-48
    80004c18:	854a                	mv	a0,s2
    80004c1a:	c6bfe0ef          	jal	80003884 <dirlink>
    80004c1e:	02054b63          	bltz	a0,80004c54 <sys_link+0xc8>
    80004c22:	854a                	mv	a0,s2
    80004c24:	82bfe0ef          	jal	8000344e <iunlockput>
    80004c28:	8526                	mv	a0,s1
    80004c2a:	f9cfe0ef          	jal	800033c6 <iput>
    80004c2e:	f17fe0ef          	jal	80003b44 <end_op>
    80004c32:	4781                	li	a5,0
    80004c34:	64f2                	ld	s1,280(sp)
    80004c36:	6952                	ld	s2,272(sp)
    80004c38:	a0a1                	j	80004c80 <sys_link+0xf4>
    80004c3a:	f0bfe0ef          	jal	80003b44 <end_op>
    80004c3e:	57fd                	li	a5,-1
    80004c40:	64f2                	ld	s1,280(sp)
    80004c42:	a83d                	j	80004c80 <sys_link+0xf4>
    80004c44:	8526                	mv	a0,s1
    80004c46:	809fe0ef          	jal	8000344e <iunlockput>
    80004c4a:	efbfe0ef          	jal	80003b44 <end_op>
    80004c4e:	57fd                	li	a5,-1
    80004c50:	64f2                	ld	s1,280(sp)
    80004c52:	a03d                	j	80004c80 <sys_link+0xf4>
    80004c54:	854a                	mv	a0,s2
    80004c56:	ff8fe0ef          	jal	8000344e <iunlockput>
    80004c5a:	8526                	mv	a0,s1
    80004c5c:	de8fe0ef          	jal	80003244 <ilock>
    80004c60:	04a4d783          	lhu	a5,74(s1)
    80004c64:	37fd                	addiw	a5,a5,-1
    80004c66:	04f49523          	sh	a5,74(s1)
    80004c6a:	8526                	mv	a0,s1
    80004c6c:	d24fe0ef          	jal	80003190 <iupdate>
    80004c70:	8526                	mv	a0,s1
    80004c72:	fdcfe0ef          	jal	8000344e <iunlockput>
    80004c76:	ecffe0ef          	jal	80003b44 <end_op>
    80004c7a:	57fd                	li	a5,-1
    80004c7c:	64f2                	ld	s1,280(sp)
    80004c7e:	6952                	ld	s2,272(sp)
    80004c80:	853e                	mv	a0,a5
    80004c82:	70b2                	ld	ra,296(sp)
    80004c84:	7412                	ld	s0,288(sp)
    80004c86:	6155                	addi	sp,sp,304
    80004c88:	8082                	ret

0000000080004c8a <sys_unlink>:
    80004c8a:	7151                	addi	sp,sp,-240
    80004c8c:	f586                	sd	ra,232(sp)
    80004c8e:	f1a2                	sd	s0,224(sp)
    80004c90:	1980                	addi	s0,sp,240
    80004c92:	08000613          	li	a2,128
    80004c96:	f3040593          	addi	a1,s0,-208
    80004c9a:	4501                	li	a0,0
    80004c9c:	b51fd0ef          	jal	800027ec <argstr>
    80004ca0:	16054063          	bltz	a0,80004e00 <sys_unlink+0x176>
    80004ca4:	eda6                	sd	s1,216(sp)
    80004ca6:	e35fe0ef          	jal	80003ada <begin_op>
    80004caa:	fb040593          	addi	a1,s0,-80
    80004cae:	f3040513          	addi	a0,s0,-208
    80004cb2:	c87fe0ef          	jal	80003938 <nameiparent>
    80004cb6:	84aa                	mv	s1,a0
    80004cb8:	c945                	beqz	a0,80004d68 <sys_unlink+0xde>
    80004cba:	d8afe0ef          	jal	80003244 <ilock>
    80004cbe:	00003597          	auipc	a1,0x3
    80004cc2:	97258593          	addi	a1,a1,-1678 # 80007630 <etext+0x630>
    80004cc6:	fb040513          	addi	a0,s0,-80
    80004cca:	9d9fe0ef          	jal	800036a2 <namecmp>
    80004cce:	10050e63          	beqz	a0,80004dea <sys_unlink+0x160>
    80004cd2:	00003597          	auipc	a1,0x3
    80004cd6:	96658593          	addi	a1,a1,-1690 # 80007638 <etext+0x638>
    80004cda:	fb040513          	addi	a0,s0,-80
    80004cde:	9c5fe0ef          	jal	800036a2 <namecmp>
    80004ce2:	10050463          	beqz	a0,80004dea <sys_unlink+0x160>
    80004ce6:	e9ca                	sd	s2,208(sp)
    80004ce8:	f2c40613          	addi	a2,s0,-212
    80004cec:	fb040593          	addi	a1,s0,-80
    80004cf0:	8526                	mv	a0,s1
    80004cf2:	9c7fe0ef          	jal	800036b8 <dirlookup>
    80004cf6:	892a                	mv	s2,a0
    80004cf8:	0e050863          	beqz	a0,80004de8 <sys_unlink+0x15e>
    80004cfc:	d48fe0ef          	jal	80003244 <ilock>
    80004d00:	04a91783          	lh	a5,74(s2)
    80004d04:	06f05763          	blez	a5,80004d72 <sys_unlink+0xe8>
    80004d08:	04491703          	lh	a4,68(s2)
    80004d0c:	4785                	li	a5,1
    80004d0e:	06f70963          	beq	a4,a5,80004d80 <sys_unlink+0xf6>
    80004d12:	4641                	li	a2,16
    80004d14:	4581                	li	a1,0
    80004d16:	fc040513          	addi	a0,s0,-64
    80004d1a:	fbdfb0ef          	jal	80000cd6 <memset>
    80004d1e:	4741                	li	a4,16
    80004d20:	f2c42683          	lw	a3,-212(s0)
    80004d24:	fc040613          	addi	a2,s0,-64
    80004d28:	4581                	li	a1,0
    80004d2a:	8526                	mv	a0,s1
    80004d2c:	869fe0ef          	jal	80003594 <writei>
    80004d30:	47c1                	li	a5,16
    80004d32:	08f51b63          	bne	a0,a5,80004dc8 <sys_unlink+0x13e>
    80004d36:	04491703          	lh	a4,68(s2)
    80004d3a:	4785                	li	a5,1
    80004d3c:	08f70d63          	beq	a4,a5,80004dd6 <sys_unlink+0x14c>
    80004d40:	8526                	mv	a0,s1
    80004d42:	f0cfe0ef          	jal	8000344e <iunlockput>
    80004d46:	04a95783          	lhu	a5,74(s2)
    80004d4a:	37fd                	addiw	a5,a5,-1
    80004d4c:	04f91523          	sh	a5,74(s2)
    80004d50:	854a                	mv	a0,s2
    80004d52:	c3efe0ef          	jal	80003190 <iupdate>
    80004d56:	854a                	mv	a0,s2
    80004d58:	ef6fe0ef          	jal	8000344e <iunlockput>
    80004d5c:	de9fe0ef          	jal	80003b44 <end_op>
    80004d60:	4501                	li	a0,0
    80004d62:	64ee                	ld	s1,216(sp)
    80004d64:	694e                	ld	s2,208(sp)
    80004d66:	a849                	j	80004df8 <sys_unlink+0x16e>
    80004d68:	dddfe0ef          	jal	80003b44 <end_op>
    80004d6c:	557d                	li	a0,-1
    80004d6e:	64ee                	ld	s1,216(sp)
    80004d70:	a061                	j	80004df8 <sys_unlink+0x16e>
    80004d72:	e5ce                	sd	s3,200(sp)
    80004d74:	00003517          	auipc	a0,0x3
    80004d78:	8cc50513          	addi	a0,a0,-1844 # 80007640 <etext+0x640>
    80004d7c:	a27fb0ef          	jal	800007a2 <panic>
    80004d80:	04c92703          	lw	a4,76(s2)
    80004d84:	02000793          	li	a5,32
    80004d88:	f8e7f5e3          	bgeu	a5,a4,80004d12 <sys_unlink+0x88>
    80004d8c:	e5ce                	sd	s3,200(sp)
    80004d8e:	02000993          	li	s3,32
    80004d92:	4741                	li	a4,16
    80004d94:	86ce                	mv	a3,s3
    80004d96:	f1840613          	addi	a2,s0,-232
    80004d9a:	4581                	li	a1,0
    80004d9c:	854a                	mv	a0,s2
    80004d9e:	efafe0ef          	jal	80003498 <readi>
    80004da2:	47c1                	li	a5,16
    80004da4:	00f51c63          	bne	a0,a5,80004dbc <sys_unlink+0x132>
    80004da8:	f1845783          	lhu	a5,-232(s0)
    80004dac:	efa1                	bnez	a5,80004e04 <sys_unlink+0x17a>
    80004dae:	29c1                	addiw	s3,s3,16
    80004db0:	04c92783          	lw	a5,76(s2)
    80004db4:	fcf9efe3          	bltu	s3,a5,80004d92 <sys_unlink+0x108>
    80004db8:	69ae                	ld	s3,200(sp)
    80004dba:	bfa1                	j	80004d12 <sys_unlink+0x88>
    80004dbc:	00003517          	auipc	a0,0x3
    80004dc0:	89c50513          	addi	a0,a0,-1892 # 80007658 <etext+0x658>
    80004dc4:	9dffb0ef          	jal	800007a2 <panic>
    80004dc8:	e5ce                	sd	s3,200(sp)
    80004dca:	00003517          	auipc	a0,0x3
    80004dce:	8a650513          	addi	a0,a0,-1882 # 80007670 <etext+0x670>
    80004dd2:	9d1fb0ef          	jal	800007a2 <panic>
    80004dd6:	04a4d783          	lhu	a5,74(s1)
    80004dda:	37fd                	addiw	a5,a5,-1
    80004ddc:	04f49523          	sh	a5,74(s1)
    80004de0:	8526                	mv	a0,s1
    80004de2:	baefe0ef          	jal	80003190 <iupdate>
    80004de6:	bfa9                	j	80004d40 <sys_unlink+0xb6>
    80004de8:	694e                	ld	s2,208(sp)
    80004dea:	8526                	mv	a0,s1
    80004dec:	e62fe0ef          	jal	8000344e <iunlockput>
    80004df0:	d55fe0ef          	jal	80003b44 <end_op>
    80004df4:	557d                	li	a0,-1
    80004df6:	64ee                	ld	s1,216(sp)
    80004df8:	70ae                	ld	ra,232(sp)
    80004dfa:	740e                	ld	s0,224(sp)
    80004dfc:	616d                	addi	sp,sp,240
    80004dfe:	8082                	ret
    80004e00:	557d                	li	a0,-1
    80004e02:	bfdd                	j	80004df8 <sys_unlink+0x16e>
    80004e04:	854a                	mv	a0,s2
    80004e06:	e48fe0ef          	jal	8000344e <iunlockput>
    80004e0a:	694e                	ld	s2,208(sp)
    80004e0c:	69ae                	ld	s3,200(sp)
    80004e0e:	bff1                	j	80004dea <sys_unlink+0x160>

0000000080004e10 <sys_open>:
    80004e10:	7131                	addi	sp,sp,-192
    80004e12:	fd06                	sd	ra,184(sp)
    80004e14:	f922                	sd	s0,176(sp)
    80004e16:	0180                	addi	s0,sp,192
    80004e18:	f4c40593          	addi	a1,s0,-180
    80004e1c:	4505                	li	a0,1
    80004e1e:	997fd0ef          	jal	800027b4 <argint>
    80004e22:	08000613          	li	a2,128
    80004e26:	f5040593          	addi	a1,s0,-176
    80004e2a:	4501                	li	a0,0
    80004e2c:	9c1fd0ef          	jal	800027ec <argstr>
    80004e30:	87aa                	mv	a5,a0
    80004e32:	557d                	li	a0,-1
    80004e34:	0a07c263          	bltz	a5,80004ed8 <sys_open+0xc8>
    80004e38:	f526                	sd	s1,168(sp)
    80004e3a:	ca1fe0ef          	jal	80003ada <begin_op>
    80004e3e:	f4c42783          	lw	a5,-180(s0)
    80004e42:	2007f793          	andi	a5,a5,512
    80004e46:	c3d5                	beqz	a5,80004eea <sys_open+0xda>
    80004e48:	4681                	li	a3,0
    80004e4a:	4601                	li	a2,0
    80004e4c:	4589                	li	a1,2
    80004e4e:	f5040513          	addi	a0,s0,-176
    80004e52:	aa9ff0ef          	jal	800048fa <create>
    80004e56:	84aa                	mv	s1,a0
    80004e58:	c541                	beqz	a0,80004ee0 <sys_open+0xd0>
    80004e5a:	04449703          	lh	a4,68(s1)
    80004e5e:	478d                	li	a5,3
    80004e60:	00f71763          	bne	a4,a5,80004e6e <sys_open+0x5e>
    80004e64:	0464d703          	lhu	a4,70(s1)
    80004e68:	47a5                	li	a5,9
    80004e6a:	0ae7ed63          	bltu	a5,a4,80004f24 <sys_open+0x114>
    80004e6e:	f14a                	sd	s2,160(sp)
    80004e70:	fe1fe0ef          	jal	80003e50 <filealloc>
    80004e74:	892a                	mv	s2,a0
    80004e76:	c179                	beqz	a0,80004f3c <sys_open+0x12c>
    80004e78:	ed4e                	sd	s3,152(sp)
    80004e7a:	a43ff0ef          	jal	800048bc <fdalloc>
    80004e7e:	89aa                	mv	s3,a0
    80004e80:	0a054a63          	bltz	a0,80004f34 <sys_open+0x124>
    80004e84:	04449703          	lh	a4,68(s1)
    80004e88:	478d                	li	a5,3
    80004e8a:	0cf70263          	beq	a4,a5,80004f4e <sys_open+0x13e>
    80004e8e:	4789                	li	a5,2
    80004e90:	00f92023          	sw	a5,0(s2)
    80004e94:	02092023          	sw	zero,32(s2)
    80004e98:	00993c23          	sd	s1,24(s2)
    80004e9c:	f4c42783          	lw	a5,-180(s0)
    80004ea0:	0017c713          	xori	a4,a5,1
    80004ea4:	8b05                	andi	a4,a4,1
    80004ea6:	00e90423          	sb	a4,8(s2)
    80004eaa:	0037f713          	andi	a4,a5,3
    80004eae:	00e03733          	snez	a4,a4
    80004eb2:	00e904a3          	sb	a4,9(s2)
    80004eb6:	4007f793          	andi	a5,a5,1024
    80004eba:	c791                	beqz	a5,80004ec6 <sys_open+0xb6>
    80004ebc:	04449703          	lh	a4,68(s1)
    80004ec0:	4789                	li	a5,2
    80004ec2:	08f70d63          	beq	a4,a5,80004f5c <sys_open+0x14c>
    80004ec6:	8526                	mv	a0,s1
    80004ec8:	c2afe0ef          	jal	800032f2 <iunlock>
    80004ecc:	c79fe0ef          	jal	80003b44 <end_op>
    80004ed0:	854e                	mv	a0,s3
    80004ed2:	74aa                	ld	s1,168(sp)
    80004ed4:	790a                	ld	s2,160(sp)
    80004ed6:	69ea                	ld	s3,152(sp)
    80004ed8:	70ea                	ld	ra,184(sp)
    80004eda:	744a                	ld	s0,176(sp)
    80004edc:	6129                	addi	sp,sp,192
    80004ede:	8082                	ret
    80004ee0:	c65fe0ef          	jal	80003b44 <end_op>
    80004ee4:	557d                	li	a0,-1
    80004ee6:	74aa                	ld	s1,168(sp)
    80004ee8:	bfc5                	j	80004ed8 <sys_open+0xc8>
    80004eea:	f5040513          	addi	a0,s0,-176
    80004eee:	a31fe0ef          	jal	8000391e <namei>
    80004ef2:	84aa                	mv	s1,a0
    80004ef4:	c11d                	beqz	a0,80004f1a <sys_open+0x10a>
    80004ef6:	b4efe0ef          	jal	80003244 <ilock>
    80004efa:	04449703          	lh	a4,68(s1)
    80004efe:	4785                	li	a5,1
    80004f00:	f4f71de3          	bne	a4,a5,80004e5a <sys_open+0x4a>
    80004f04:	f4c42783          	lw	a5,-180(s0)
    80004f08:	d3bd                	beqz	a5,80004e6e <sys_open+0x5e>
    80004f0a:	8526                	mv	a0,s1
    80004f0c:	d42fe0ef          	jal	8000344e <iunlockput>
    80004f10:	c35fe0ef          	jal	80003b44 <end_op>
    80004f14:	557d                	li	a0,-1
    80004f16:	74aa                	ld	s1,168(sp)
    80004f18:	b7c1                	j	80004ed8 <sys_open+0xc8>
    80004f1a:	c2bfe0ef          	jal	80003b44 <end_op>
    80004f1e:	557d                	li	a0,-1
    80004f20:	74aa                	ld	s1,168(sp)
    80004f22:	bf5d                	j	80004ed8 <sys_open+0xc8>
    80004f24:	8526                	mv	a0,s1
    80004f26:	d28fe0ef          	jal	8000344e <iunlockput>
    80004f2a:	c1bfe0ef          	jal	80003b44 <end_op>
    80004f2e:	557d                	li	a0,-1
    80004f30:	74aa                	ld	s1,168(sp)
    80004f32:	b75d                	j	80004ed8 <sys_open+0xc8>
    80004f34:	854a                	mv	a0,s2
    80004f36:	fbffe0ef          	jal	80003ef4 <fileclose>
    80004f3a:	69ea                	ld	s3,152(sp)
    80004f3c:	8526                	mv	a0,s1
    80004f3e:	d10fe0ef          	jal	8000344e <iunlockput>
    80004f42:	c03fe0ef          	jal	80003b44 <end_op>
    80004f46:	557d                	li	a0,-1
    80004f48:	74aa                	ld	s1,168(sp)
    80004f4a:	790a                	ld	s2,160(sp)
    80004f4c:	b771                	j	80004ed8 <sys_open+0xc8>
    80004f4e:	00f92023          	sw	a5,0(s2)
    80004f52:	04649783          	lh	a5,70(s1)
    80004f56:	02f91223          	sh	a5,36(s2)
    80004f5a:	bf3d                	j	80004e98 <sys_open+0x88>
    80004f5c:	8526                	mv	a0,s1
    80004f5e:	bd4fe0ef          	jal	80003332 <itrunc>
    80004f62:	b795                	j	80004ec6 <sys_open+0xb6>

0000000080004f64 <sys_mkdir>:
    80004f64:	7175                	addi	sp,sp,-144
    80004f66:	e506                	sd	ra,136(sp)
    80004f68:	e122                	sd	s0,128(sp)
    80004f6a:	0900                	addi	s0,sp,144
    80004f6c:	b6ffe0ef          	jal	80003ada <begin_op>
    80004f70:	08000613          	li	a2,128
    80004f74:	f7040593          	addi	a1,s0,-144
    80004f78:	4501                	li	a0,0
    80004f7a:	873fd0ef          	jal	800027ec <argstr>
    80004f7e:	02054363          	bltz	a0,80004fa4 <sys_mkdir+0x40>
    80004f82:	4681                	li	a3,0
    80004f84:	4601                	li	a2,0
    80004f86:	4585                	li	a1,1
    80004f88:	f7040513          	addi	a0,s0,-144
    80004f8c:	96fff0ef          	jal	800048fa <create>
    80004f90:	c911                	beqz	a0,80004fa4 <sys_mkdir+0x40>
    80004f92:	cbcfe0ef          	jal	8000344e <iunlockput>
    80004f96:	baffe0ef          	jal	80003b44 <end_op>
    80004f9a:	4501                	li	a0,0
    80004f9c:	60aa                	ld	ra,136(sp)
    80004f9e:	640a                	ld	s0,128(sp)
    80004fa0:	6149                	addi	sp,sp,144
    80004fa2:	8082                	ret
    80004fa4:	ba1fe0ef          	jal	80003b44 <end_op>
    80004fa8:	557d                	li	a0,-1
    80004faa:	bfcd                	j	80004f9c <sys_mkdir+0x38>

0000000080004fac <sys_mknod>:
    80004fac:	7135                	addi	sp,sp,-160
    80004fae:	ed06                	sd	ra,152(sp)
    80004fb0:	e922                	sd	s0,144(sp)
    80004fb2:	1100                	addi	s0,sp,160
    80004fb4:	b27fe0ef          	jal	80003ada <begin_op>
    80004fb8:	f6c40593          	addi	a1,s0,-148
    80004fbc:	4505                	li	a0,1
    80004fbe:	ff6fd0ef          	jal	800027b4 <argint>
    80004fc2:	f6840593          	addi	a1,s0,-152
    80004fc6:	4509                	li	a0,2
    80004fc8:	fecfd0ef          	jal	800027b4 <argint>
    80004fcc:	08000613          	li	a2,128
    80004fd0:	f7040593          	addi	a1,s0,-144
    80004fd4:	4501                	li	a0,0
    80004fd6:	817fd0ef          	jal	800027ec <argstr>
    80004fda:	02054563          	bltz	a0,80005004 <sys_mknod+0x58>
    80004fde:	f6841683          	lh	a3,-152(s0)
    80004fe2:	f6c41603          	lh	a2,-148(s0)
    80004fe6:	458d                	li	a1,3
    80004fe8:	f7040513          	addi	a0,s0,-144
    80004fec:	90fff0ef          	jal	800048fa <create>
    80004ff0:	c911                	beqz	a0,80005004 <sys_mknod+0x58>
    80004ff2:	c5cfe0ef          	jal	8000344e <iunlockput>
    80004ff6:	b4ffe0ef          	jal	80003b44 <end_op>
    80004ffa:	4501                	li	a0,0
    80004ffc:	60ea                	ld	ra,152(sp)
    80004ffe:	644a                	ld	s0,144(sp)
    80005000:	610d                	addi	sp,sp,160
    80005002:	8082                	ret
    80005004:	b41fe0ef          	jal	80003b44 <end_op>
    80005008:	557d                	li	a0,-1
    8000500a:	bfcd                	j	80004ffc <sys_mknod+0x50>

000000008000500c <sys_chdir>:
    8000500c:	7135                	addi	sp,sp,-160
    8000500e:	ed06                	sd	ra,152(sp)
    80005010:	e922                	sd	s0,144(sp)
    80005012:	e14a                	sd	s2,128(sp)
    80005014:	1100                	addi	s0,sp,160
    80005016:	8ebfc0ef          	jal	80001900 <myproc>
    8000501a:	892a                	mv	s2,a0
    8000501c:	abffe0ef          	jal	80003ada <begin_op>
    80005020:	08000613          	li	a2,128
    80005024:	f6040593          	addi	a1,s0,-160
    80005028:	4501                	li	a0,0
    8000502a:	fc2fd0ef          	jal	800027ec <argstr>
    8000502e:	04054363          	bltz	a0,80005074 <sys_chdir+0x68>
    80005032:	e526                	sd	s1,136(sp)
    80005034:	f6040513          	addi	a0,s0,-160
    80005038:	8e7fe0ef          	jal	8000391e <namei>
    8000503c:	84aa                	mv	s1,a0
    8000503e:	c915                	beqz	a0,80005072 <sys_chdir+0x66>
    80005040:	a04fe0ef          	jal	80003244 <ilock>
    80005044:	04449703          	lh	a4,68(s1)
    80005048:	4785                	li	a5,1
    8000504a:	02f71963          	bne	a4,a5,8000507c <sys_chdir+0x70>
    8000504e:	8526                	mv	a0,s1
    80005050:	aa2fe0ef          	jal	800032f2 <iunlock>
    80005054:	15093503          	ld	a0,336(s2)
    80005058:	b6efe0ef          	jal	800033c6 <iput>
    8000505c:	ae9fe0ef          	jal	80003b44 <end_op>
    80005060:	14993823          	sd	s1,336(s2)
    80005064:	4501                	li	a0,0
    80005066:	64aa                	ld	s1,136(sp)
    80005068:	60ea                	ld	ra,152(sp)
    8000506a:	644a                	ld	s0,144(sp)
    8000506c:	690a                	ld	s2,128(sp)
    8000506e:	610d                	addi	sp,sp,160
    80005070:	8082                	ret
    80005072:	64aa                	ld	s1,136(sp)
    80005074:	ad1fe0ef          	jal	80003b44 <end_op>
    80005078:	557d                	li	a0,-1
    8000507a:	b7fd                	j	80005068 <sys_chdir+0x5c>
    8000507c:	8526                	mv	a0,s1
    8000507e:	bd0fe0ef          	jal	8000344e <iunlockput>
    80005082:	ac3fe0ef          	jal	80003b44 <end_op>
    80005086:	557d                	li	a0,-1
    80005088:	64aa                	ld	s1,136(sp)
    8000508a:	bff9                	j	80005068 <sys_chdir+0x5c>

000000008000508c <sys_exec>:
    8000508c:	7121                	addi	sp,sp,-448
    8000508e:	ff06                	sd	ra,440(sp)
    80005090:	fb22                	sd	s0,432(sp)
    80005092:	0380                	addi	s0,sp,448
    80005094:	e4840593          	addi	a1,s0,-440
    80005098:	4505                	li	a0,1
    8000509a:	f36fd0ef          	jal	800027d0 <argaddr>
    8000509e:	08000613          	li	a2,128
    800050a2:	f5040593          	addi	a1,s0,-176
    800050a6:	4501                	li	a0,0
    800050a8:	f44fd0ef          	jal	800027ec <argstr>
    800050ac:	87aa                	mv	a5,a0
    800050ae:	557d                	li	a0,-1
    800050b0:	0c07c463          	bltz	a5,80005178 <sys_exec+0xec>
    800050b4:	f726                	sd	s1,424(sp)
    800050b6:	f34a                	sd	s2,416(sp)
    800050b8:	ef4e                	sd	s3,408(sp)
    800050ba:	eb52                	sd	s4,400(sp)
    800050bc:	10000613          	li	a2,256
    800050c0:	4581                	li	a1,0
    800050c2:	e5040513          	addi	a0,s0,-432
    800050c6:	c11fb0ef          	jal	80000cd6 <memset>
    800050ca:	e5040493          	addi	s1,s0,-432
    800050ce:	89a6                	mv	s3,s1
    800050d0:	4901                	li	s2,0
    800050d2:	02000a13          	li	s4,32
    800050d6:	00391513          	slli	a0,s2,0x3
    800050da:	e4040593          	addi	a1,s0,-448
    800050de:	e4843783          	ld	a5,-440(s0)
    800050e2:	953e                	add	a0,a0,a5
    800050e4:	e46fd0ef          	jal	8000272a <fetchaddr>
    800050e8:	02054663          	bltz	a0,80005114 <sys_exec+0x88>
    800050ec:	e4043783          	ld	a5,-448(s0)
    800050f0:	c3a9                	beqz	a5,80005132 <sys_exec+0xa6>
    800050f2:	a41fb0ef          	jal	80000b32 <kalloc>
    800050f6:	85aa                	mv	a1,a0
    800050f8:	00a9b023          	sd	a0,0(s3)
    800050fc:	cd01                	beqz	a0,80005114 <sys_exec+0x88>
    800050fe:	6605                	lui	a2,0x1
    80005100:	e4043503          	ld	a0,-448(s0)
    80005104:	e70fd0ef          	jal	80002774 <fetchstr>
    80005108:	00054663          	bltz	a0,80005114 <sys_exec+0x88>
    8000510c:	0905                	addi	s2,s2,1
    8000510e:	09a1                	addi	s3,s3,8
    80005110:	fd4913e3          	bne	s2,s4,800050d6 <sys_exec+0x4a>
    80005114:	f5040913          	addi	s2,s0,-176
    80005118:	6088                	ld	a0,0(s1)
    8000511a:	c931                	beqz	a0,8000516e <sys_exec+0xe2>
    8000511c:	935fb0ef          	jal	80000a50 <kfree>
    80005120:	04a1                	addi	s1,s1,8
    80005122:	ff249be3          	bne	s1,s2,80005118 <sys_exec+0x8c>
    80005126:	557d                	li	a0,-1
    80005128:	74ba                	ld	s1,424(sp)
    8000512a:	791a                	ld	s2,416(sp)
    8000512c:	69fa                	ld	s3,408(sp)
    8000512e:	6a5a                	ld	s4,400(sp)
    80005130:	a0a1                	j	80005178 <sys_exec+0xec>
    80005132:	0009079b          	sext.w	a5,s2
    80005136:	078e                	slli	a5,a5,0x3
    80005138:	fd078793          	addi	a5,a5,-48
    8000513c:	97a2                	add	a5,a5,s0
    8000513e:	e807b023          	sd	zero,-384(a5)
    80005142:	e5040593          	addi	a1,s0,-432
    80005146:	f5040513          	addi	a0,s0,-176
    8000514a:	ba8ff0ef          	jal	800044f2 <exec>
    8000514e:	892a                	mv	s2,a0
    80005150:	f5040993          	addi	s3,s0,-176
    80005154:	6088                	ld	a0,0(s1)
    80005156:	c511                	beqz	a0,80005162 <sys_exec+0xd6>
    80005158:	8f9fb0ef          	jal	80000a50 <kfree>
    8000515c:	04a1                	addi	s1,s1,8
    8000515e:	ff349be3          	bne	s1,s3,80005154 <sys_exec+0xc8>
    80005162:	854a                	mv	a0,s2
    80005164:	74ba                	ld	s1,424(sp)
    80005166:	791a                	ld	s2,416(sp)
    80005168:	69fa                	ld	s3,408(sp)
    8000516a:	6a5a                	ld	s4,400(sp)
    8000516c:	a031                	j	80005178 <sys_exec+0xec>
    8000516e:	557d                	li	a0,-1
    80005170:	74ba                	ld	s1,424(sp)
    80005172:	791a                	ld	s2,416(sp)
    80005174:	69fa                	ld	s3,408(sp)
    80005176:	6a5a                	ld	s4,400(sp)
    80005178:	70fa                	ld	ra,440(sp)
    8000517a:	745a                	ld	s0,432(sp)
    8000517c:	6139                	addi	sp,sp,448
    8000517e:	8082                	ret

0000000080005180 <sys_pipe>:
    80005180:	7139                	addi	sp,sp,-64
    80005182:	fc06                	sd	ra,56(sp)
    80005184:	f822                	sd	s0,48(sp)
    80005186:	f426                	sd	s1,40(sp)
    80005188:	0080                	addi	s0,sp,64
    8000518a:	f76fc0ef          	jal	80001900 <myproc>
    8000518e:	84aa                	mv	s1,a0
    80005190:	fd840593          	addi	a1,s0,-40
    80005194:	4501                	li	a0,0
    80005196:	e3afd0ef          	jal	800027d0 <argaddr>
    8000519a:	fc840593          	addi	a1,s0,-56
    8000519e:	fd040513          	addi	a0,s0,-48
    800051a2:	85cff0ef          	jal	800041fe <pipealloc>
    800051a6:	57fd                	li	a5,-1
    800051a8:	0a054463          	bltz	a0,80005250 <sys_pipe+0xd0>
    800051ac:	fcf42223          	sw	a5,-60(s0)
    800051b0:	fd043503          	ld	a0,-48(s0)
    800051b4:	f08ff0ef          	jal	800048bc <fdalloc>
    800051b8:	fca42223          	sw	a0,-60(s0)
    800051bc:	08054163          	bltz	a0,8000523e <sys_pipe+0xbe>
    800051c0:	fc843503          	ld	a0,-56(s0)
    800051c4:	ef8ff0ef          	jal	800048bc <fdalloc>
    800051c8:	fca42023          	sw	a0,-64(s0)
    800051cc:	06054063          	bltz	a0,8000522c <sys_pipe+0xac>
    800051d0:	4691                	li	a3,4
    800051d2:	fc440613          	addi	a2,s0,-60
    800051d6:	fd843583          	ld	a1,-40(s0)
    800051da:	68a8                	ld	a0,80(s1)
    800051dc:	b96fc0ef          	jal	80001572 <copyout>
    800051e0:	00054e63          	bltz	a0,800051fc <sys_pipe+0x7c>
    800051e4:	4691                	li	a3,4
    800051e6:	fc040613          	addi	a2,s0,-64
    800051ea:	fd843583          	ld	a1,-40(s0)
    800051ee:	0591                	addi	a1,a1,4
    800051f0:	68a8                	ld	a0,80(s1)
    800051f2:	b80fc0ef          	jal	80001572 <copyout>
    800051f6:	4781                	li	a5,0
    800051f8:	04055c63          	bgez	a0,80005250 <sys_pipe+0xd0>
    800051fc:	fc442783          	lw	a5,-60(s0)
    80005200:	07e9                	addi	a5,a5,26
    80005202:	078e                	slli	a5,a5,0x3
    80005204:	97a6                	add	a5,a5,s1
    80005206:	0007b023          	sd	zero,0(a5)
    8000520a:	fc042783          	lw	a5,-64(s0)
    8000520e:	07e9                	addi	a5,a5,26
    80005210:	078e                	slli	a5,a5,0x3
    80005212:	94be                	add	s1,s1,a5
    80005214:	0004b023          	sd	zero,0(s1)
    80005218:	fd043503          	ld	a0,-48(s0)
    8000521c:	cd9fe0ef          	jal	80003ef4 <fileclose>
    80005220:	fc843503          	ld	a0,-56(s0)
    80005224:	cd1fe0ef          	jal	80003ef4 <fileclose>
    80005228:	57fd                	li	a5,-1
    8000522a:	a01d                	j	80005250 <sys_pipe+0xd0>
    8000522c:	fc442783          	lw	a5,-60(s0)
    80005230:	0007c763          	bltz	a5,8000523e <sys_pipe+0xbe>
    80005234:	07e9                	addi	a5,a5,26
    80005236:	078e                	slli	a5,a5,0x3
    80005238:	97a6                	add	a5,a5,s1
    8000523a:	0007b023          	sd	zero,0(a5)
    8000523e:	fd043503          	ld	a0,-48(s0)
    80005242:	cb3fe0ef          	jal	80003ef4 <fileclose>
    80005246:	fc843503          	ld	a0,-56(s0)
    8000524a:	cabfe0ef          	jal	80003ef4 <fileclose>
    8000524e:	57fd                	li	a5,-1
    80005250:	853e                	mv	a0,a5
    80005252:	70e2                	ld	ra,56(sp)
    80005254:	7442                	ld	s0,48(sp)
    80005256:	74a2                	ld	s1,40(sp)
    80005258:	6121                	addi	sp,sp,64
    8000525a:	8082                	ret
    8000525c:	0000                	unimp
	...

0000000080005260 <kernelvec>:
    80005260:	7111                	addi	sp,sp,-256
    80005262:	e006                	sd	ra,0(sp)
    80005264:	e40a                	sd	sp,8(sp)
    80005266:	e80e                	sd	gp,16(sp)
    80005268:	ec12                	sd	tp,24(sp)
    8000526a:	f016                	sd	t0,32(sp)
    8000526c:	f41a                	sd	t1,40(sp)
    8000526e:	f81e                	sd	t2,48(sp)
    80005270:	e4aa                	sd	a0,72(sp)
    80005272:	e8ae                	sd	a1,80(sp)
    80005274:	ecb2                	sd	a2,88(sp)
    80005276:	f0b6                	sd	a3,96(sp)
    80005278:	f4ba                	sd	a4,104(sp)
    8000527a:	f8be                	sd	a5,112(sp)
    8000527c:	fcc2                	sd	a6,120(sp)
    8000527e:	e146                	sd	a7,128(sp)
    80005280:	edf2                	sd	t3,216(sp)
    80005282:	f1f6                	sd	t4,224(sp)
    80005284:	f5fa                	sd	t5,232(sp)
    80005286:	f9fe                	sd	t6,240(sp)
    80005288:	bb2fd0ef          	jal	8000263a <kerneltrap>
    8000528c:	6082                	ld	ra,0(sp)
    8000528e:	6122                	ld	sp,8(sp)
    80005290:	61c2                	ld	gp,16(sp)
    80005292:	7282                	ld	t0,32(sp)
    80005294:	7322                	ld	t1,40(sp)
    80005296:	73c2                	ld	t2,48(sp)
    80005298:	6526                	ld	a0,72(sp)
    8000529a:	65c6                	ld	a1,80(sp)
    8000529c:	6666                	ld	a2,88(sp)
    8000529e:	7686                	ld	a3,96(sp)
    800052a0:	7726                	ld	a4,104(sp)
    800052a2:	77c6                	ld	a5,112(sp)
    800052a4:	7866                	ld	a6,120(sp)
    800052a6:	688a                	ld	a7,128(sp)
    800052a8:	6e6e                	ld	t3,216(sp)
    800052aa:	7e8e                	ld	t4,224(sp)
    800052ac:	7f2e                	ld	t5,232(sp)
    800052ae:	7fce                	ld	t6,240(sp)
    800052b0:	6111                	addi	sp,sp,256
    800052b2:	10200073          	sret
	...

00000000800052be <plicinit>:
    800052be:	1141                	addi	sp,sp,-16
    800052c0:	e422                	sd	s0,8(sp)
    800052c2:	0800                	addi	s0,sp,16
    800052c4:	0c0007b7          	lui	a5,0xc000
    800052c8:	4705                	li	a4,1
    800052ca:	d798                	sw	a4,40(a5)
    800052cc:	0c0007b7          	lui	a5,0xc000
    800052d0:	c3d8                	sw	a4,4(a5)
    800052d2:	6422                	ld	s0,8(sp)
    800052d4:	0141                	addi	sp,sp,16
    800052d6:	8082                	ret

00000000800052d8 <plicinithart>:
    800052d8:	1141                	addi	sp,sp,-16
    800052da:	e406                	sd	ra,8(sp)
    800052dc:	e022                	sd	s0,0(sp)
    800052de:	0800                	addi	s0,sp,16
    800052e0:	df4fc0ef          	jal	800018d4 <cpuid>
    800052e4:	0085171b          	slliw	a4,a0,0x8
    800052e8:	0c0027b7          	lui	a5,0xc002
    800052ec:	97ba                	add	a5,a5,a4
    800052ee:	40200713          	li	a4,1026
    800052f2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>
    800052f6:	00d5151b          	slliw	a0,a0,0xd
    800052fa:	0c2017b7          	lui	a5,0xc201
    800052fe:	97aa                	add	a5,a5,a0
    80005300:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
    80005304:	60a2                	ld	ra,8(sp)
    80005306:	6402                	ld	s0,0(sp)
    80005308:	0141                	addi	sp,sp,16
    8000530a:	8082                	ret

000000008000530c <plic_claim>:
    8000530c:	1141                	addi	sp,sp,-16
    8000530e:	e406                	sd	ra,8(sp)
    80005310:	e022                	sd	s0,0(sp)
    80005312:	0800                	addi	s0,sp,16
    80005314:	dc0fc0ef          	jal	800018d4 <cpuid>
    80005318:	00d5151b          	slliw	a0,a0,0xd
    8000531c:	0c2017b7          	lui	a5,0xc201
    80005320:	97aa                	add	a5,a5,a0
    80005322:	43c8                	lw	a0,4(a5)
    80005324:	60a2                	ld	ra,8(sp)
    80005326:	6402                	ld	s0,0(sp)
    80005328:	0141                	addi	sp,sp,16
    8000532a:	8082                	ret

000000008000532c <plic_complete>:
    8000532c:	1101                	addi	sp,sp,-32
    8000532e:	ec06                	sd	ra,24(sp)
    80005330:	e822                	sd	s0,16(sp)
    80005332:	e426                	sd	s1,8(sp)
    80005334:	1000                	addi	s0,sp,32
    80005336:	84aa                	mv	s1,a0
    80005338:	d9cfc0ef          	jal	800018d4 <cpuid>
    8000533c:	00d5151b          	slliw	a0,a0,0xd
    80005340:	0c2017b7          	lui	a5,0xc201
    80005344:	97aa                	add	a5,a5,a0
    80005346:	c3c4                	sw	s1,4(a5)
    80005348:	60e2                	ld	ra,24(sp)
    8000534a:	6442                	ld	s0,16(sp)
    8000534c:	64a2                	ld	s1,8(sp)
    8000534e:	6105                	addi	sp,sp,32
    80005350:	8082                	ret

0000000080005352 <free_desc>:
    80005352:	1141                	addi	sp,sp,-16
    80005354:	e406                	sd	ra,8(sp)
    80005356:	e022                	sd	s0,0(sp)
    80005358:	0800                	addi	s0,sp,16
    8000535a:	479d                	li	a5,7
    8000535c:	04a7ca63          	blt	a5,a0,800053b0 <free_desc+0x5e>
    80005360:	0001e797          	auipc	a5,0x1e
    80005364:	18078793          	addi	a5,a5,384 # 800234e0 <disk>
    80005368:	97aa                	add	a5,a5,a0
    8000536a:	0187c783          	lbu	a5,24(a5)
    8000536e:	e7b9                	bnez	a5,800053bc <free_desc+0x6a>
    80005370:	00451693          	slli	a3,a0,0x4
    80005374:	0001e797          	auipc	a5,0x1e
    80005378:	16c78793          	addi	a5,a5,364 # 800234e0 <disk>
    8000537c:	6398                	ld	a4,0(a5)
    8000537e:	9736                	add	a4,a4,a3
    80005380:	00073023          	sd	zero,0(a4)
    80005384:	6398                	ld	a4,0(a5)
    80005386:	9736                	add	a4,a4,a3
    80005388:	00072423          	sw	zero,8(a4)
    8000538c:	00071623          	sh	zero,12(a4)
    80005390:	00071723          	sh	zero,14(a4)
    80005394:	97aa                	add	a5,a5,a0
    80005396:	4705                	li	a4,1
    80005398:	00e78c23          	sb	a4,24(a5)
    8000539c:	0001e517          	auipc	a0,0x1e
    800053a0:	15c50513          	addi	a0,a0,348 # 800234f8 <disk+0x18>
    800053a4:	b77fc0ef          	jal	80001f1a <wakeup>
    800053a8:	60a2                	ld	ra,8(sp)
    800053aa:	6402                	ld	s0,0(sp)
    800053ac:	0141                	addi	sp,sp,16
    800053ae:	8082                	ret
    800053b0:	00002517          	auipc	a0,0x2
    800053b4:	2d050513          	addi	a0,a0,720 # 80007680 <etext+0x680>
    800053b8:	beafb0ef          	jal	800007a2 <panic>
    800053bc:	00002517          	auipc	a0,0x2
    800053c0:	2d450513          	addi	a0,a0,724 # 80007690 <etext+0x690>
    800053c4:	bdefb0ef          	jal	800007a2 <panic>

00000000800053c8 <virtio_disk_init>:
    800053c8:	1101                	addi	sp,sp,-32
    800053ca:	ec06                	sd	ra,24(sp)
    800053cc:	e822                	sd	s0,16(sp)
    800053ce:	e426                	sd	s1,8(sp)
    800053d0:	e04a                	sd	s2,0(sp)
    800053d2:	1000                	addi	s0,sp,32
    800053d4:	00002597          	auipc	a1,0x2
    800053d8:	2cc58593          	addi	a1,a1,716 # 800076a0 <etext+0x6a0>
    800053dc:	0001e517          	auipc	a0,0x1e
    800053e0:	22c50513          	addi	a0,a0,556 # 80023608 <disk+0x128>
    800053e4:	f9efb0ef          	jal	80000b82 <initlock>
    800053e8:	100017b7          	lui	a5,0x10001
    800053ec:	4398                	lw	a4,0(a5)
    800053ee:	2701                	sext.w	a4,a4
    800053f0:	747277b7          	lui	a5,0x74727
    800053f4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053f8:	18f71063          	bne	a4,a5,80005578 <virtio_disk_init+0x1b0>
    800053fc:	100017b7          	lui	a5,0x10001
    80005400:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80005402:	439c                	lw	a5,0(a5)
    80005404:	2781                	sext.w	a5,a5
    80005406:	4709                	li	a4,2
    80005408:	16e79863          	bne	a5,a4,80005578 <virtio_disk_init+0x1b0>
    8000540c:	100017b7          	lui	a5,0x10001
    80005410:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005412:	439c                	lw	a5,0(a5)
    80005414:	2781                	sext.w	a5,a5
    80005416:	16e79163          	bne	a5,a4,80005578 <virtio_disk_init+0x1b0>
    8000541a:	100017b7          	lui	a5,0x10001
    8000541e:	47d8                	lw	a4,12(a5)
    80005420:	2701                	sext.w	a4,a4
    80005422:	554d47b7          	lui	a5,0x554d4
    80005426:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000542a:	14f71763          	bne	a4,a5,80005578 <virtio_disk_init+0x1b0>
    8000542e:	100017b7          	lui	a5,0x10001
    80005432:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
    80005436:	4705                	li	a4,1
    80005438:	dbb8                	sw	a4,112(a5)
    8000543a:	470d                	li	a4,3
    8000543c:	dbb8                	sw	a4,112(a5)
    8000543e:	10001737          	lui	a4,0x10001
    80005442:	4b14                	lw	a3,16(a4)
    80005444:	c7ffe737          	lui	a4,0xc7ffe
    80005448:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb13f>
    8000544c:	8ef9                	and	a3,a3,a4
    8000544e:	10001737          	lui	a4,0x10001
    80005452:	d314                	sw	a3,32(a4)
    80005454:	472d                	li	a4,11
    80005456:	dbb8                	sw	a4,112(a5)
    80005458:	07078793          	addi	a5,a5,112
    8000545c:	439c                	lw	a5,0(a5)
    8000545e:	0007891b          	sext.w	s2,a5
    80005462:	8ba1                	andi	a5,a5,8
    80005464:	12078063          	beqz	a5,80005584 <virtio_disk_init+0x1bc>
    80005468:	100017b7          	lui	a5,0x10001
    8000546c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
    80005470:	100017b7          	lui	a5,0x10001
    80005474:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005478:	439c                	lw	a5,0(a5)
    8000547a:	2781                	sext.w	a5,a5
    8000547c:	10079a63          	bnez	a5,80005590 <virtio_disk_init+0x1c8>
    80005480:	100017b7          	lui	a5,0x10001
    80005484:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005488:	439c                	lw	a5,0(a5)
    8000548a:	2781                	sext.w	a5,a5
    8000548c:	10078863          	beqz	a5,8000559c <virtio_disk_init+0x1d4>
    80005490:	471d                	li	a4,7
    80005492:	10f77b63          	bgeu	a4,a5,800055a8 <virtio_disk_init+0x1e0>
    80005496:	e9cfb0ef          	jal	80000b32 <kalloc>
    8000549a:	0001e497          	auipc	s1,0x1e
    8000549e:	04648493          	addi	s1,s1,70 # 800234e0 <disk>
    800054a2:	e088                	sd	a0,0(s1)
    800054a4:	e8efb0ef          	jal	80000b32 <kalloc>
    800054a8:	e488                	sd	a0,8(s1)
    800054aa:	e88fb0ef          	jal	80000b32 <kalloc>
    800054ae:	87aa                	mv	a5,a0
    800054b0:	e888                	sd	a0,16(s1)
    800054b2:	6088                	ld	a0,0(s1)
    800054b4:	10050063          	beqz	a0,800055b4 <virtio_disk_init+0x1ec>
    800054b8:	0001e717          	auipc	a4,0x1e
    800054bc:	03073703          	ld	a4,48(a4) # 800234e8 <disk+0x8>
    800054c0:	0e070a63          	beqz	a4,800055b4 <virtio_disk_init+0x1ec>
    800054c4:	0e078863          	beqz	a5,800055b4 <virtio_disk_init+0x1ec>
    800054c8:	6605                	lui	a2,0x1
    800054ca:	4581                	li	a1,0
    800054cc:	80bfb0ef          	jal	80000cd6 <memset>
    800054d0:	0001e497          	auipc	s1,0x1e
    800054d4:	01048493          	addi	s1,s1,16 # 800234e0 <disk>
    800054d8:	6605                	lui	a2,0x1
    800054da:	4581                	li	a1,0
    800054dc:	6488                	ld	a0,8(s1)
    800054de:	ff8fb0ef          	jal	80000cd6 <memset>
    800054e2:	6605                	lui	a2,0x1
    800054e4:	4581                	li	a1,0
    800054e6:	6888                	ld	a0,16(s1)
    800054e8:	feefb0ef          	jal	80000cd6 <memset>
    800054ec:	100017b7          	lui	a5,0x10001
    800054f0:	4721                	li	a4,8
    800054f2:	df98                	sw	a4,56(a5)
    800054f4:	4098                	lw	a4,0(s1)
    800054f6:	100017b7          	lui	a5,0x10001
    800054fa:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
    800054fe:	40d8                	lw	a4,4(s1)
    80005500:	100017b7          	lui	a5,0x10001
    80005504:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
    80005508:	649c                	ld	a5,8(s1)
    8000550a:	0007869b          	sext.w	a3,a5
    8000550e:	10001737          	lui	a4,0x10001
    80005512:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
    80005516:	9781                	srai	a5,a5,0x20
    80005518:	10001737          	lui	a4,0x10001
    8000551c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
    80005520:	689c                	ld	a5,16(s1)
    80005522:	0007869b          	sext.w	a3,a5
    80005526:	10001737          	lui	a4,0x10001
    8000552a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
    8000552e:	9781                	srai	a5,a5,0x20
    80005530:	10001737          	lui	a4,0x10001
    80005534:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
    80005538:	10001737          	lui	a4,0x10001
    8000553c:	4785                	li	a5,1
    8000553e:	c37c                	sw	a5,68(a4)
    80005540:	00f48c23          	sb	a5,24(s1)
    80005544:	00f48ca3          	sb	a5,25(s1)
    80005548:	00f48d23          	sb	a5,26(s1)
    8000554c:	00f48da3          	sb	a5,27(s1)
    80005550:	00f48e23          	sb	a5,28(s1)
    80005554:	00f48ea3          	sb	a5,29(s1)
    80005558:	00f48f23          	sb	a5,30(s1)
    8000555c:	00f48fa3          	sb	a5,31(s1)
    80005560:	00496913          	ori	s2,s2,4
    80005564:	100017b7          	lui	a5,0x10001
    80005568:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
    8000556c:	60e2                	ld	ra,24(sp)
    8000556e:	6442                	ld	s0,16(sp)
    80005570:	64a2                	ld	s1,8(sp)
    80005572:	6902                	ld	s2,0(sp)
    80005574:	6105                	addi	sp,sp,32
    80005576:	8082                	ret
    80005578:	00002517          	auipc	a0,0x2
    8000557c:	13850513          	addi	a0,a0,312 # 800076b0 <etext+0x6b0>
    80005580:	a22fb0ef          	jal	800007a2 <panic>
    80005584:	00002517          	auipc	a0,0x2
    80005588:	14c50513          	addi	a0,a0,332 # 800076d0 <etext+0x6d0>
    8000558c:	a16fb0ef          	jal	800007a2 <panic>
    80005590:	00002517          	auipc	a0,0x2
    80005594:	16050513          	addi	a0,a0,352 # 800076f0 <etext+0x6f0>
    80005598:	a0afb0ef          	jal	800007a2 <panic>
    8000559c:	00002517          	auipc	a0,0x2
    800055a0:	17450513          	addi	a0,a0,372 # 80007710 <etext+0x710>
    800055a4:	9fefb0ef          	jal	800007a2 <panic>
    800055a8:	00002517          	auipc	a0,0x2
    800055ac:	18850513          	addi	a0,a0,392 # 80007730 <etext+0x730>
    800055b0:	9f2fb0ef          	jal	800007a2 <panic>
    800055b4:	00002517          	auipc	a0,0x2
    800055b8:	19c50513          	addi	a0,a0,412 # 80007750 <etext+0x750>
    800055bc:	9e6fb0ef          	jal	800007a2 <panic>

00000000800055c0 <virtio_disk_rw>:
    800055c0:	7159                	addi	sp,sp,-112
    800055c2:	f486                	sd	ra,104(sp)
    800055c4:	f0a2                	sd	s0,96(sp)
    800055c6:	eca6                	sd	s1,88(sp)
    800055c8:	e8ca                	sd	s2,80(sp)
    800055ca:	e4ce                	sd	s3,72(sp)
    800055cc:	e0d2                	sd	s4,64(sp)
    800055ce:	fc56                	sd	s5,56(sp)
    800055d0:	f85a                	sd	s6,48(sp)
    800055d2:	f45e                	sd	s7,40(sp)
    800055d4:	f062                	sd	s8,32(sp)
    800055d6:	ec66                	sd	s9,24(sp)
    800055d8:	1880                	addi	s0,sp,112
    800055da:	8a2a                	mv	s4,a0
    800055dc:	8bae                	mv	s7,a1
    800055de:	00c52c83          	lw	s9,12(a0)
    800055e2:	001c9c9b          	slliw	s9,s9,0x1
    800055e6:	1c82                	slli	s9,s9,0x20
    800055e8:	020cdc93          	srli	s9,s9,0x20
    800055ec:	0001e517          	auipc	a0,0x1e
    800055f0:	01c50513          	addi	a0,a0,28 # 80023608 <disk+0x128>
    800055f4:	e0efb0ef          	jal	80000c02 <acquire>
    800055f8:	4981                	li	s3,0
    800055fa:	44a1                	li	s1,8
    800055fc:	0001eb17          	auipc	s6,0x1e
    80005600:	ee4b0b13          	addi	s6,s6,-284 # 800234e0 <disk>
    80005604:	4a8d                	li	s5,3
    80005606:	0001ec17          	auipc	s8,0x1e
    8000560a:	002c0c13          	addi	s8,s8,2 # 80023608 <disk+0x128>
    8000560e:	a8b9                	j	8000566c <virtio_disk_rw+0xac>
    80005610:	00fb0733          	add	a4,s6,a5
    80005614:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    80005618:	c19c                	sw	a5,0(a1)
    8000561a:	0207c563          	bltz	a5,80005644 <virtio_disk_rw+0x84>
    8000561e:	2905                	addiw	s2,s2,1
    80005620:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005622:	05590963          	beq	s2,s5,80005674 <virtio_disk_rw+0xb4>
    80005626:	85b2                	mv	a1,a2
    80005628:	0001e717          	auipc	a4,0x1e
    8000562c:	eb870713          	addi	a4,a4,-328 # 800234e0 <disk>
    80005630:	87ce                	mv	a5,s3
    80005632:	01874683          	lbu	a3,24(a4)
    80005636:	fee9                	bnez	a3,80005610 <virtio_disk_rw+0x50>
    80005638:	2785                	addiw	a5,a5,1
    8000563a:	0705                	addi	a4,a4,1
    8000563c:	fe979be3          	bne	a5,s1,80005632 <virtio_disk_rw+0x72>
    80005640:	57fd                	li	a5,-1
    80005642:	c19c                	sw	a5,0(a1)
    80005644:	01205d63          	blez	s2,8000565e <virtio_disk_rw+0x9e>
    80005648:	f9042503          	lw	a0,-112(s0)
    8000564c:	d07ff0ef          	jal	80005352 <free_desc>
    80005650:	4785                	li	a5,1
    80005652:	0127d663          	bge	a5,s2,8000565e <virtio_disk_rw+0x9e>
    80005656:	f9442503          	lw	a0,-108(s0)
    8000565a:	cf9ff0ef          	jal	80005352 <free_desc>
    8000565e:	85e2                	mv	a1,s8
    80005660:	0001e517          	auipc	a0,0x1e
    80005664:	e9850513          	addi	a0,a0,-360 # 800234f8 <disk+0x18>
    80005668:	867fc0ef          	jal	80001ece <sleep>
    8000566c:	f9040613          	addi	a2,s0,-112
    80005670:	894e                	mv	s2,s3
    80005672:	bf55                	j	80005626 <virtio_disk_rw+0x66>
    80005674:	f9042503          	lw	a0,-112(s0)
    80005678:	00451693          	slli	a3,a0,0x4
    8000567c:	0001e797          	auipc	a5,0x1e
    80005680:	e6478793          	addi	a5,a5,-412 # 800234e0 <disk>
    80005684:	00a50713          	addi	a4,a0,10
    80005688:	0712                	slli	a4,a4,0x4
    8000568a:	973e                	add	a4,a4,a5
    8000568c:	01703633          	snez	a2,s7
    80005690:	c710                	sw	a2,8(a4)
    80005692:	00072623          	sw	zero,12(a4)
    80005696:	01973823          	sd	s9,16(a4)
    8000569a:	6398                	ld	a4,0(a5)
    8000569c:	9736                	add	a4,a4,a3
    8000569e:	0a868613          	addi	a2,a3,168
    800056a2:	963e                	add	a2,a2,a5
    800056a4:	e310                	sd	a2,0(a4)
    800056a6:	6390                	ld	a2,0(a5)
    800056a8:	00d605b3          	add	a1,a2,a3
    800056ac:	4741                	li	a4,16
    800056ae:	c598                	sw	a4,8(a1)
    800056b0:	4805                	li	a6,1
    800056b2:	01059623          	sh	a6,12(a1)
    800056b6:	f9442703          	lw	a4,-108(s0)
    800056ba:	00e59723          	sh	a4,14(a1)
    800056be:	0712                	slli	a4,a4,0x4
    800056c0:	963a                	add	a2,a2,a4
    800056c2:	058a0593          	addi	a1,s4,88
    800056c6:	e20c                	sd	a1,0(a2)
    800056c8:	0007b883          	ld	a7,0(a5)
    800056cc:	9746                	add	a4,a4,a7
    800056ce:	40000613          	li	a2,1024
    800056d2:	c710                	sw	a2,8(a4)
    800056d4:	001bb613          	seqz	a2,s7
    800056d8:	0016161b          	slliw	a2,a2,0x1
    800056dc:	00166613          	ori	a2,a2,1
    800056e0:	00c71623          	sh	a2,12(a4)
    800056e4:	f9842583          	lw	a1,-104(s0)
    800056e8:	00b71723          	sh	a1,14(a4)
    800056ec:	00250613          	addi	a2,a0,2
    800056f0:	0612                	slli	a2,a2,0x4
    800056f2:	963e                	add	a2,a2,a5
    800056f4:	577d                	li	a4,-1
    800056f6:	00e60823          	sb	a4,16(a2)
    800056fa:	0592                	slli	a1,a1,0x4
    800056fc:	98ae                	add	a7,a7,a1
    800056fe:	03068713          	addi	a4,a3,48
    80005702:	973e                	add	a4,a4,a5
    80005704:	00e8b023          	sd	a4,0(a7)
    80005708:	6398                	ld	a4,0(a5)
    8000570a:	972e                	add	a4,a4,a1
    8000570c:	01072423          	sw	a6,8(a4)
    80005710:	4689                	li	a3,2
    80005712:	00d71623          	sh	a3,12(a4)
    80005716:	00071723          	sh	zero,14(a4)
    8000571a:	010a2223          	sw	a6,4(s4)
    8000571e:	01463423          	sd	s4,8(a2)
    80005722:	6794                	ld	a3,8(a5)
    80005724:	0026d703          	lhu	a4,2(a3)
    80005728:	8b1d                	andi	a4,a4,7
    8000572a:	0706                	slli	a4,a4,0x1
    8000572c:	96ba                	add	a3,a3,a4
    8000572e:	00a69223          	sh	a0,4(a3)
    80005732:	0330000f          	fence	rw,rw
    80005736:	6798                	ld	a4,8(a5)
    80005738:	00275783          	lhu	a5,2(a4)
    8000573c:	2785                	addiw	a5,a5,1
    8000573e:	00f71123          	sh	a5,2(a4)
    80005742:	0330000f          	fence	rw,rw
    80005746:	100017b7          	lui	a5,0x10001
    8000574a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>
    8000574e:	004a2783          	lw	a5,4(s4)
    80005752:	0001e917          	auipc	s2,0x1e
    80005756:	eb690913          	addi	s2,s2,-330 # 80023608 <disk+0x128>
    8000575a:	4485                	li	s1,1
    8000575c:	01079a63          	bne	a5,a6,80005770 <virtio_disk_rw+0x1b0>
    80005760:	85ca                	mv	a1,s2
    80005762:	8552                	mv	a0,s4
    80005764:	f6afc0ef          	jal	80001ece <sleep>
    80005768:	004a2783          	lw	a5,4(s4)
    8000576c:	fe978ae3          	beq	a5,s1,80005760 <virtio_disk_rw+0x1a0>
    80005770:	f9042903          	lw	s2,-112(s0)
    80005774:	00290713          	addi	a4,s2,2
    80005778:	0712                	slli	a4,a4,0x4
    8000577a:	0001e797          	auipc	a5,0x1e
    8000577e:	d6678793          	addi	a5,a5,-666 # 800234e0 <disk>
    80005782:	97ba                	add	a5,a5,a4
    80005784:	0007b423          	sd	zero,8(a5)
    80005788:	0001e997          	auipc	s3,0x1e
    8000578c:	d5898993          	addi	s3,s3,-680 # 800234e0 <disk>
    80005790:	00491713          	slli	a4,s2,0x4
    80005794:	0009b783          	ld	a5,0(s3)
    80005798:	97ba                	add	a5,a5,a4
    8000579a:	00c7d483          	lhu	s1,12(a5)
    8000579e:	854a                	mv	a0,s2
    800057a0:	00e7d903          	lhu	s2,14(a5)
    800057a4:	bafff0ef          	jal	80005352 <free_desc>
    800057a8:	8885                	andi	s1,s1,1
    800057aa:	f0fd                	bnez	s1,80005790 <virtio_disk_rw+0x1d0>
    800057ac:	0001e517          	auipc	a0,0x1e
    800057b0:	e5c50513          	addi	a0,a0,-420 # 80023608 <disk+0x128>
    800057b4:	ce6fb0ef          	jal	80000c9a <release>
    800057b8:	70a6                	ld	ra,104(sp)
    800057ba:	7406                	ld	s0,96(sp)
    800057bc:	64e6                	ld	s1,88(sp)
    800057be:	6946                	ld	s2,80(sp)
    800057c0:	69a6                	ld	s3,72(sp)
    800057c2:	6a06                	ld	s4,64(sp)
    800057c4:	7ae2                	ld	s5,56(sp)
    800057c6:	7b42                	ld	s6,48(sp)
    800057c8:	7ba2                	ld	s7,40(sp)
    800057ca:	7c02                	ld	s8,32(sp)
    800057cc:	6ce2                	ld	s9,24(sp)
    800057ce:	6165                	addi	sp,sp,112
    800057d0:	8082                	ret

00000000800057d2 <virtio_disk_intr>:
    800057d2:	1101                	addi	sp,sp,-32
    800057d4:	ec06                	sd	ra,24(sp)
    800057d6:	e822                	sd	s0,16(sp)
    800057d8:	e426                	sd	s1,8(sp)
    800057da:	1000                	addi	s0,sp,32
    800057dc:	0001e497          	auipc	s1,0x1e
    800057e0:	d0448493          	addi	s1,s1,-764 # 800234e0 <disk>
    800057e4:	0001e517          	auipc	a0,0x1e
    800057e8:	e2450513          	addi	a0,a0,-476 # 80023608 <disk+0x128>
    800057ec:	c16fb0ef          	jal	80000c02 <acquire>
    800057f0:	100017b7          	lui	a5,0x10001
    800057f4:	53b8                	lw	a4,96(a5)
    800057f6:	8b0d                	andi	a4,a4,3
    800057f8:	100017b7          	lui	a5,0x10001
    800057fc:	d3f8                	sw	a4,100(a5)
    800057fe:	0330000f          	fence	rw,rw
    80005802:	689c                	ld	a5,16(s1)
    80005804:	0204d703          	lhu	a4,32(s1)
    80005808:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000580c:	04f70663          	beq	a4,a5,80005858 <virtio_disk_intr+0x86>
    80005810:	0330000f          	fence	rw,rw
    80005814:	6898                	ld	a4,16(s1)
    80005816:	0204d783          	lhu	a5,32(s1)
    8000581a:	8b9d                	andi	a5,a5,7
    8000581c:	078e                	slli	a5,a5,0x3
    8000581e:	97ba                	add	a5,a5,a4
    80005820:	43dc                	lw	a5,4(a5)
    80005822:	00278713          	addi	a4,a5,2
    80005826:	0712                	slli	a4,a4,0x4
    80005828:	9726                	add	a4,a4,s1
    8000582a:	01074703          	lbu	a4,16(a4)
    8000582e:	e321                	bnez	a4,8000586e <virtio_disk_intr+0x9c>
    80005830:	0789                	addi	a5,a5,2
    80005832:	0792                	slli	a5,a5,0x4
    80005834:	97a6                	add	a5,a5,s1
    80005836:	6788                	ld	a0,8(a5)
    80005838:	00052223          	sw	zero,4(a0)
    8000583c:	edefc0ef          	jal	80001f1a <wakeup>
    80005840:	0204d783          	lhu	a5,32(s1)
    80005844:	2785                	addiw	a5,a5,1
    80005846:	17c2                	slli	a5,a5,0x30
    80005848:	93c1                	srli	a5,a5,0x30
    8000584a:	02f49023          	sh	a5,32(s1)
    8000584e:	6898                	ld	a4,16(s1)
    80005850:	00275703          	lhu	a4,2(a4)
    80005854:	faf71ee3          	bne	a4,a5,80005810 <virtio_disk_intr+0x3e>
    80005858:	0001e517          	auipc	a0,0x1e
    8000585c:	db050513          	addi	a0,a0,-592 # 80023608 <disk+0x128>
    80005860:	c3afb0ef          	jal	80000c9a <release>
    80005864:	60e2                	ld	ra,24(sp)
    80005866:	6442                	ld	s0,16(sp)
    80005868:	64a2                	ld	s1,8(sp)
    8000586a:	6105                	addi	sp,sp,32
    8000586c:	8082                	ret
    8000586e:	00002517          	auipc	a0,0x2
    80005872:	efa50513          	addi	a0,a0,-262 # 80007768 <etext+0x768>
    80005876:	f2dfa0ef          	jal	800007a2 <panic>

000000008000587a <sys_kbdint>:
    8000587a:	1141                	addi	sp,sp,-16
    8000587c:	e422                	sd	s0,8(sp)
    8000587e:	0800                	addi	s0,sp,16
    80005880:	00005517          	auipc	a0,0x5
    80005884:	a3052503          	lw	a0,-1488(a0) # 8000a2b0 <keyboard_int_cnt>
    80005888:	6422                	ld	s0,8(sp)
    8000588a:	0141                	addi	sp,sp,16
    8000588c:	8082                	ret
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
